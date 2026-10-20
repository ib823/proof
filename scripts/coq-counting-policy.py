#!/usr/bin/env python3
"""coq-counting-policy.py — the three published Coq numbers (mandate S2.7).

RIINA publishes no raw Qed total. It publishes three numbers, so a reader can
see what the proofs cover and what is excluded:

  core_mechanized_qed             Qed in the core metatheory directories
                                  (CORE_DIRS), minus excluded proofs
  model_mechanized_qed_nonvacuous Qed in every other active file (domain,
                                  industry, compliance, crypto and runtime
                                  models), minus excluded proofs
  excluded_qed                    proofs that scripts/detect-vacuous-proofs.py
                                  flags as vacuous patterns (one per flagged
                                  theorem), every `Example` and `Remark` proof
                                  (examples are not coverage), and every Qed in
                                  EXCLUDED_FILES

The three always add up to the active-build Qed count (every `Qed.` line in
the files `_CoqProject` lists, the same count generate-metrics.sh publishes as
proofs.qedActive); the script fails if they do not.

Limits: the vacuity patterns are heuristics, so `excluded_qed` is a lower
bound on vacuous proofs. Counterexample and refutation proofs are not yet
separated out; that triage is REQ-104 (REQ-119 tracks the rest of S2.7).

Usage: python3 scripts/coq-counting-policy.py <repo-root>   (prints JSON)
"""

import json
import os
import re
import subprocess
import sys

# The core metatheory. Everything else in the active build is a model.
CORE_DIRS = ("foundations", "type_system", "properties", "effects", "termination")

# Active files whose proofs are tests or examples, not coverage. Each entry
# needs a reason.
EXCLUDED_FILES = {
    # A feasibility test of an encoding ("If this file compiles, Phase 1 can
    # proceed"), not a property of RIINA.
    "properties/AhmedStyleTest.v",
}

# Vacuity patterns that flag a proved theorem. P3 flags `:= False`
# definitions, which are not proofs.
THEOREM_PATTERNS = ("P1", "P2", "P4")


def active_files(coq_dir):
    files = []
    with open(os.path.join(coq_dir, "_CoqProject"), encoding="utf-8") as fh:
        for line in fh:
            entry = line.strip()
            if not entry or entry.startswith("#") or not entry.endswith(".v"):
                continue
            files.append(entry)
    return files


DECL = re.compile(
    r"^\s*(?:(?:Local|Global|#\[[^\]]*\])\s+)*"
    r"(Theorem|Lemma|Corollary|Proposition|Fact|Remark|Example|Definition|Fixpoint|"
    r"Instance|Program|Let|Goal)\b\s*([A-Za-z_][A-Za-z0-9_']*)?"
)


def example_names(path):
    """Names of `Example` / `Remark` declarations whose proof ends in `Qed.`."""
    names, current = set(), None
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                m = DECL.match(line)
                if m:
                    current = (m.group(1), m.group(2) or f"<anon:{len(names)}>")
                if "Qed." in line and current is not None:
                    if current[0] in ("Example", "Remark"):
                        names.add(current[1])
                    current = None
    except FileNotFoundError:
        pass
    return names


def qed_count(path):
    # Same rule as generate-metrics.sh's `grep -c "Qed\."`: lines containing it.
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            return sum(1 for line in fh if "Qed." in line)
    except FileNotFoundError:
        return 0


def vacuity_by_file(root):
    out = subprocess.run(
        [sys.executable, os.path.join(root, "scripts", "detect-vacuous-proofs.py"), "--json"],
        cwd=root,
        capture_output=True,
        text=True,
    )
    # The detector exits 1 whenever it finds anything; only bad output is an error.
    report = json.loads(out.stdout)
    flagged = {}
    for entry in report["files"]:
        rel = entry["path"].split("02_FORMAL/coq/", 1)[-1]
        names = {f["name"] for f in entry["findings"] if f["pattern"] in THEOREM_PATTERNS}
        flagged[rel] = names
    return flagged


def main():
    if len(sys.argv) != 2:
        print(__doc__.strip().splitlines()[-1], file=sys.stderr)
        sys.exit(2)
    root = os.path.abspath(sys.argv[1])
    coq_dir = os.path.join(root, "02_FORMAL", "coq")
    flagged = vacuity_by_file(root)

    core = model = excluded = total = examples = 0
    for rel in active_files(coq_dir):
        path = os.path.join(coq_dir, rel)
        qed = qed_count(path)
        total += qed
        ex = example_names(path)
        examples += len(ex)
        # A flagged theorem that is also an Example is excluded once.
        dropped = qed if rel in EXCLUDED_FILES else min(qed, len(flagged.get(rel, set()) | ex))
        excluded += dropped
        if rel.split("/", 1)[0] in CORE_DIRS:
            core += qed - dropped
        else:
            model += qed - dropped

    if core + model + excluded != total:
        print(f"counting policy does not partition the build: {core}+{model}+{excluded} != {total}",
              file=sys.stderr)
        sys.exit(1)

    print(json.dumps({
        "coreMechanizedQed": core,
        "modelMechanizedQedNonvacuous": model,
        "excludedQed": excluded,
        "activeQed": total,
        "exampleQed": examples,
        "coreDirs": list(CORE_DIRS),
        "excludedFiles": sorted(EXCLUDED_FILES),
    }))


if __name__ == "__main__":
    main()
