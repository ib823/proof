#!/usr/bin/env python3
"""
Coq warning audit utility.

Builds Coq (optionally clean), parses compiler warnings, and enforces
a no-regression budget for warning classes.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional


FILE_LINE_RE = re.compile(r'^File "\./([^"]+)", line (\d+), characters ([^:]+):$')
WARNING_RE = re.compile(r"^Warning:\s*(.*)$")
TAG_RE = re.compile(r"\[([a-z0-9_.-]+)(?:,[^\]]*)?\]$", re.IGNORECASE)


@dataclass
class WarningEntry:
    kind: str
    file: str
    line: int
    chars: str
    message: str


def run(cmd: list[str], cwd: Path) -> tuple[int, str]:
    proc = subprocess.run(
        cmd,
        cwd=str(cwd),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    return proc.returncode, proc.stdout


def classify_kind(message: str) -> str:
    m = TAG_RE.search(message)
    if m:
        return m.group(1)
    if "To avoid stack overflow, large numbers in nat are interpreted as" in message:
        return "abstract-large-number"
    return "unclassified-warning"


def parse_warnings(log_text: str) -> list[WarningEntry]:
    entries: list[WarningEntry] = []
    pending_file: Optional[str] = None
    pending_line = 0
    pending_chars = ""

    for raw in log_text.splitlines():
        line = raw.rstrip("\n")
        fm = FILE_LINE_RE.match(line)
        if fm:
            pending_file = fm.group(1)
            pending_line = int(fm.group(2))
            pending_chars = fm.group(3)
            continue

        wm = WARNING_RE.match(line)
        if wm:
            msg = wm.group(1).strip()
            kind = classify_kind(msg)
            entries.append(
                WarningEntry(
                    kind=kind,
                    file=pending_file or "",
                    line=pending_line if pending_file else 0,
                    chars=pending_chars if pending_file else "",
                    message=msg,
                )
            )
            pending_file = None
            pending_line = 0
            pending_chars = ""
            continue

        if line.startswith("W: "):
            msg = line[3:].strip()
            entries.append(
                WarningEntry(
                    kind="build-warning",
                    file="",
                    line=0,
                    chars="",
                    message=msg,
                )
            )

    return entries


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def write_inventory(path: Path, entries: list[WarningEntry]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        f.write("kind\tfile\tline\tchars\tmessage\n")
        for e in entries:
            msg = e.message.replace("\t", " ").replace("\n", " ")
            f.write(f"{e.kind}\t{e.file}\t{e.line}\t{e.chars}\t{msg}\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit Coq build warnings.")
    parser.add_argument("--repo-root", default=".", help="Repository root.")
    parser.add_argument(
        "--coq-dir", default="02_FORMAL/coq", help="Coq directory relative to repo root."
    )
    parser.add_argument("--log-path", default="reports/coq_warning_build.log")
    parser.add_argument("--status-path", default="reports/coq_warning_status.json")
    parser.add_argument("--inventory-path", default="reports/coq_warning_inventory.tsv")
    parser.add_argument("--budget-path", default="reports/coq_warning_budget.json")
    parser.add_argument(
        "--mode",
        choices=["build", "parse"],
        default="build",
        help="build: run make and parse; parse: parse existing log only.",
    )
    parser.add_argument("--clean", action="store_true", help="Run make clean before build.")
    parser.add_argument(
        "--enforce-budget",
        action="store_true",
        help="Fail when warnings exceed budget thresholds.",
    )
    parser.add_argument(
        "--write-budget",
        action="store_true",
        help="Write/update budget from current warning counts.",
    )
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    coq_dir = (repo_root / args.coq_dir).resolve()
    log_path = (repo_root / args.log_path).resolve()
    status_path = (repo_root / args.status_path).resolve()
    inventory_path = (repo_root / args.inventory_path).resolve()
    budget_path = (repo_root / args.budget_path).resolve()

    log_text = ""
    if args.mode == "build":
        if args.clean:
            rc, out = run(["make", "clean"], coq_dir)
            if rc != 0:
                print(out, end="")
                print("error: make clean failed", file=sys.stderr)
                return 2
        rc, out = run(["make", "-j1"], coq_dir)
        log_text = out
        log_path.parent.mkdir(parents=True, exist_ok=True)
        log_path.write_text(log_text, encoding="utf-8")
        if rc != 0:
            print(out, end="")
            print("error: coq build failed", file=sys.stderr)
            return 2
    else:
        if not log_path.exists():
            print(f"error: log not found: {log_path}", file=sys.stderr)
            return 2
        log_text = log_path.read_text(encoding="utf-8", errors="replace")

    entries = parse_warnings(log_text)
    by_kind = Counter(e.kind for e in entries)
    by_file = Counter(e.file for e in entries if e.file)

    write_inventory(inventory_path, entries)

    head = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=str(repo_root), text=True
    ).strip()
    parent_head = ""
    try:
        parent_head = subprocess.check_output(
            ["git", "rev-parse", "HEAD^"], cwd=str(repo_root), text=True
        ).strip()
    except subprocess.CalledProcessError:
        parent_head = ""

    status = {
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "repoHead": head,
        "repoParentHead": parent_head,
        "totals": {
            "warnings": len(entries),
            "kinds": dict(sorted(by_kind.items())),
            "filesWithWarnings": len(by_file),
        },
        "topFiles": [
            {"file": file, "warnings": count}
            for file, count in by_file.most_common(25)
        ],
        "logPath": os.path.relpath(log_path, repo_root),
        "inventoryPath": os.path.relpath(inventory_path, repo_root),
    }
    status_path.parent.mkdir(parents=True, exist_ok=True)
    status_path.write_text(json.dumps(status, indent=2) + "\n", encoding="utf-8")

    if args.write_budget:
        budget = {
            "generatedAt": datetime.now(timezone.utc).isoformat(),
            "baselineHead": head,
            "maxTotalWarnings": len(entries),
            "maxByKind": dict(sorted(by_kind.items())),
        }
        budget_path.parent.mkdir(parents=True, exist_ok=True)
        budget_path.write_text(json.dumps(budget, indent=2) + "\n", encoding="utf-8")

    print(f"Coq warnings total: {len(entries)}")
    for kind, count in sorted(by_kind.items()):
        print(f"  {kind}: {count}")
    print(f"Inventory: {os.path.relpath(inventory_path, repo_root)}")
    print(f"Status:    {os.path.relpath(status_path, repo_root)}")

    if not args.enforce_budget:
        return 0

    budget = read_json(budget_path)
    if not budget:
        print(f"error: budget not found: {budget_path}", file=sys.stderr)
        return 2

    max_total = int(budget.get("maxTotalWarnings", 0))
    max_by_kind = {k: int(v) for k, v in budget.get("maxByKind", {}).items()}

    failures: list[str] = []
    if len(entries) > max_total:
        failures.append(f"total warnings {len(entries)} > budget {max_total}")

    for kind, observed in by_kind.items():
        allowed = max_by_kind.get(kind, 0)
        if observed > allowed:
            failures.append(f"{kind}: {observed} > budget {allowed}")

    for kind, allowed in max_by_kind.items():
        observed = by_kind.get(kind, 0)
        if observed > allowed:
            failures.append(f"{kind}: {observed} > budget {allowed}")

    if failures:
        print("warning budget exceeded:")
        for f in failures:
            print(f"  - {f}")
        return 1

    print("warning budget check: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
