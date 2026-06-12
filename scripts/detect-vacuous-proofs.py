#!/usr/bin/env python3
"""
detect-vacuous-proofs.py — RIINA Proof Vacuity Detector

Scans Coq .v files for four known vacuity patterns:
  P1: Theorem concludes with True, proved by trivial/exact I
  P2: Theorem proved by reflexivity on hardcoded boolean record fields
  P3: Definitions that are := False (making dependent theorems trivially provable)
  P4: Theorems that are pure definitional unfolding (A → A tautologies)

Usage:
  python3 scripts/detect-vacuous-proofs.py [path ...]
  python3 scripts/detect-vacuous-proofs.py                          # scan all active .v files
  python3 scripts/detect-vacuous-proofs.py 02_FORMAL/coq/domains/   # scan one directory
  python3 scripts/detect-vacuous-proofs.py --summary                # summary only

Exit code:
  0 if no vacuous proofs found
  1 if vacuous proofs found
"""

import os
import re
import sys
import json
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Tuple

@dataclass
class Finding:
    file: str
    line: int
    pattern: str  # P1, P2, P3, P4
    name: str
    detail: str
    severity: str  # critical, high, medium, info

@dataclass
class FileReport:
    path: str
    qed_count: int = 0
    findings: List[Finding] = field(default_factory=list)
    reflexivity_count: int = 0
    trivial_count: int = 0
    false_defs: int = 0
    tautology_proofs: int = 0

    @property
    def vacuous_count(self):
        return len(self.findings)

    @property
    def vacuity_pct(self):
        if self.qed_count == 0:
            return 0
        return round(self.vacuous_count * 100 / self.qed_count)

    @property
    def verdict(self):
        if self.qed_count == 0:
            return "NO_PROOFS"
        pct = self.vacuity_pct
        if pct >= 70:
            return "VACUOUS"
        elif pct >= 40:
            return "MIXED"
        elif pct > 0:
            return "MOSTLY_REAL"
        return "CLEAN"


def parse_coq_file(filepath: str) -> FileReport:
    """Parse a .v file and detect vacuity patterns."""
    report = FileReport(path=filepath)

    try:
        with open(filepath, 'r', errors='replace') as f:
            content = f.read()
            lines = content.split('\n')
    except Exception as e:
        return report

    # Count Qed
    report.qed_count = len(re.findall(r'\bQed\b\.', content))
    if report.qed_count == 0:
        return report

    # --- Pattern P3: Definition X := False ---
    for i, line in enumerate(lines, 1):
        m = re.match(r'^Definition\s+(\w+).*:=\s*False\s*\.', line)
        if m:
            report.false_defs += 1
            report.findings.append(Finding(
                file=filepath, line=i, pattern="P3",
                name=m.group(1),
                detail=f"Definition {m.group(1)} := False — all dependent theorems are trivially provable",
                severity="critical"
            ))

    # --- Parse theorem/proof blocks using line-by-line state machine ---
    # States: IDLE -> IN_STATEMENT -> IN_PROOF
    state = 'IDLE'
    current_name = ''
    current_statement_lines = []
    current_proof_lines = []
    current_start_line = 0

    for i, line in enumerate(lines, 1):
        stripped = line.strip()

        if state == 'IDLE':
            m = re.match(r'^(Theorem|Lemma)\s+(\w+)', stripped)
            if m:
                current_name = m.group(2)
                current_start_line = i
                current_statement_lines = [stripped]
                current_proof_lines = []
                if 'Proof.' in stripped:
                    state = 'IN_PROOF'
                else:
                    state = 'IN_STATEMENT'

        elif state == 'IN_STATEMENT':
            current_statement_lines.append(stripped)
            if 'Proof.' in stripped:
                state = 'IN_PROOF'

        elif state == 'IN_PROOF':
            if stripped.startswith('Qed.') or stripped == 'Qed.':
                # Complete block found — analyze it
                statement = ' '.join(current_statement_lines)
                proof_body = ' '.join(current_proof_lines)
                # Remove "Proof." prefix from proof body
                proof_body = re.sub(r'^.*?Proof\.\s*', '', proof_body).strip()

                _analyze_proof_block(
                    report, filepath, current_start_line,
                    current_name, statement, proof_body
                )
                state = 'IDLE'
            else:
                current_proof_lines.append(stripped)

    return report


def _analyze_proof_block(report, filepath, line_num, name, statement, proof_body):
    """Analyze a single theorem/proof block for vacuity."""

    # --- Pattern P1: Conclusion is True, proved by trivial/exact I ---
    if re.search(r'->\s*True\s*\.?\s*$', statement) or 'True.' in statement.split(':')[-1]:
        tactics = proof_body.lower().strip()
        if 'trivial' in tactics or 'exact i' in tactics or 'auto' in tactics:
            report.trivial_count += 1
            report.findings.append(Finding(
                file=filepath, line=line_num, pattern="P1",
                name=name,
                detail=f"Concludes with True, proved by {proof_body.strip()[:40]}",
                severity="critical"
            ))
            return

    # --- Pattern P2: reflexivity on boolean record (field = true) ---
    proof_stripped = re.sub(r'\s+', ' ', proof_body).strip()
    is_pure_refl = bool(re.match(
        r'^(intros[^.]*\.\s*)?(reflexivity\s*\.)\s*$',
        proof_stripped
    ))
    if is_pure_refl:
        if re.search(r'=\s*true\b', statement, re.IGNORECASE):
            report.reflexivity_count += 1
            report.findings.append(Finding(
                file=filepath, line=line_num, pattern="P2",
                name=name,
                detail="Proves field = true by reflexivity on hardcoded boolean record",
                severity="high"
            ))
            return

    # --- Pattern P4: Tautology (very short unfold + exact/apply/assumption) ---
    tactic_count = proof_stripped.count('.')
    has_real_work = any(t in proof_stripped for t in
        ['induction', 'destruct', 'inversion', 'case', 'rewrite', 'lia',
         'omega', 'specialize', 'generalize', 'remember', 'assert',
         'contradiction', 'discriminate', 'injection', 'split', 'left', 'right'])
    if tactic_count <= 3 and not has_real_work and proof_stripped:
        # Only flag if it looks like pure unfold+apply
        if re.match(r'^(intros[^.]*\.\s*)?(unfold[^.]*\.\s*)?(exact|assumption|apply)\s', proof_stripped):
            report.tautology_proofs += 1
            report.findings.append(Finding(
                file=filepath, line=line_num, pattern="P4",
                name=name,
                detail=f"Tautological proof: {proof_stripped[:60]}",
                severity="medium"
            ))

    return report


def scan_directory(path: str) -> List[FileReport]:
    """Scan a directory for .v files."""
    reports = []
    for root, dirs, files in os.walk(path):
        # Skip archive directories
        if '_archive_' in root or '_deprecated' in root:
            continue
        for fname in sorted(files):
            if fname.endswith('.v'):
                filepath = os.path.join(root, fname)
                report = parse_coq_file(filepath)
                if report.qed_count > 0:
                    reports.append(report)
    return reports


def print_report(reports: List[FileReport], summary_only: bool = False):
    """Print the vacuity report."""
    total_qed = sum(r.qed_count for r in reports)
    total_findings = sum(r.vacuous_count for r in reports)
    total_files = len(reports)
    vacuous_files = sum(1 for r in reports if r.verdict == "VACUOUS")
    mixed_files = sum(1 for r in reports if r.verdict == "MIXED")
    clean_files = sum(1 for r in reports if r.verdict == "CLEAN")
    real_files = sum(1 for r in reports if r.verdict == "MOSTLY_REAL")

    p1 = sum(1 for r in reports for f in r.findings if f.pattern == "P1")
    p2 = sum(1 for r in reports for f in r.findings if f.pattern == "P2")
    p3 = sum(1 for r in reports for f in r.findings if f.pattern == "P3")
    p4 = sum(1 for r in reports for f in r.findings if f.pattern == "P4")

    print("=" * 72)
    print("RIINA PROOF VACUITY DETECTION REPORT")
    print("=" * 72)
    print()
    print(f"Files scanned:     {total_files}")
    print(f"Total Qed:         {total_qed}")
    print(f"Total findings:    {total_findings}")
    print(f"Overall vacuity:   {round(total_findings * 100 / total_qed) if total_qed else 0}%")
    print()
    print("Pattern breakdown:")
    print(f"  P1 (True/trivial):        {p1:4d} critical")
    print(f"  P2 (reflexivity/boolean):  {p2:4d} high")
    print(f"  P3 (False definitions):    {p3:4d} critical")
    print(f"  P4 (tautology proofs):     {p4:4d} medium")
    print()
    print("File verdict distribution:")
    print(f"  VACUOUS (>=70%):  {vacuous_files:4d} files")
    print(f"  MIXED (40-69%):   {mixed_files:4d} files")
    print(f"  MOSTLY_REAL:      {real_files:4d} files")
    print(f"  CLEAN (0%):       {clean_files:4d} files")
    print()

    if not summary_only:
        # Print per-file details for VACUOUS and MIXED files
        flagged = [r for r in reports if r.verdict in ("VACUOUS", "MIXED")]
        if flagged:
            print("-" * 72)
            print("FLAGGED FILES (sorted by vacuity %)")
            print("-" * 72)
            for r in sorted(flagged, key=lambda x: x.vacuity_pct, reverse=True):
                relpath = os.path.relpath(r.path)
                print(f"\n  {relpath}")
                print(f"    Qed: {r.qed_count}  Vacuous: {r.vacuous_count}  ({r.vacuity_pct}%)  [{r.verdict}]")
                for f in r.findings[:5]:  # Show first 5 per file
                    print(f"    [{f.pattern}] L{f.line}: {f.name} — {f.detail[:70]}")
                if len(r.findings) > 5:
                    print(f"    ... and {len(r.findings) - 5} more findings")

        # Print critical findings from all files
        critical = [f for r in reports for f in r.findings if f.severity == "critical"]
        if critical:
            print()
            print("-" * 72)
            print(f"CRITICAL FINDINGS ({len(critical)})")
            print("-" * 72)
            for f in critical[:20]:
                relpath = os.path.relpath(f.file)
                print(f"  [{f.pattern}] {relpath}:L{f.line} {f.name}")
                print(f"         {f.detail}")

    print()
    print("=" * 72)
    if total_findings > 0:
        print(f"RESULT: {total_findings} vacuous proofs detected across {total_files} files")
        print("EXIT CODE: 1")
    else:
        print("RESULT: No vacuous proofs detected")
        print("EXIT CODE: 0")
    print("=" * 72)


def main():
    args = sys.argv[1:]
    summary_only = '--summary' in args
    args = [a for a in args if a != '--summary']

    json_output = '--json' in args
    args = [a for a in args if a != '--json']

    if not args:
        # Default: scan all active .v files
        args = ['02_FORMAL/coq/']

    all_reports = []
    for path in args:
        if os.path.isfile(path):
            report = parse_coq_file(path)
            if report.qed_count > 0:
                all_reports.append(report)
        elif os.path.isdir(path):
            all_reports.extend(scan_directory(path))
        else:
            print(f"Warning: {path} not found", file=sys.stderr)

    if json_output:
        output = {
            "total_files": len(all_reports),
            "total_qed": sum(r.qed_count for r in all_reports),
            "total_findings": sum(r.vacuous_count for r in all_reports),
            "files": [
                {
                    "path": r.path,
                    "qed": r.qed_count,
                    "vacuous": r.vacuous_count,
                    "pct": r.vacuity_pct,
                    "verdict": r.verdict,
                    "findings": [
                        {"pattern": f.pattern, "line": f.line, "name": f.name, "severity": f.severity}
                        for f in r.findings
                    ]
                }
                for r in all_reports if r.vacuous_count > 0
            ]
        }
        print(json.dumps(output, indent=2))
    else:
        print_report(all_reports, summary_only=summary_only)

    sys.exit(1 if any(r.vacuous_count > 0 for r in all_reports) else 0)


if __name__ == '__main__':
    main()
