#!/usr/bin/env python3
"""coq-counting-policy.py — the three published Coq numbers (mandate S2.7).

RIINA publishes no raw Qed total. It publishes three numbers, so a reader can
see what the proofs cover and what is excluded:

  core_mechanized_qed             Qed in the core metatheory directories
                                  (CORE_DIRS) and the compiler-link files
                                  (COMPILER_LINK_FILES), minus excluded proofs
  model_mechanized_qed_nonvacuous Qed in every other active file (domain,
                                  industry, compliance, crypto and runtime
                                  models), minus excluded proofs
  excluded_qed                    proofs that scripts/detect-vacuous-proofs.py
                                  flags as vacuous patterns (one per flagged
                                  theorem); proofs that rest on a premise the
                                  build refutes (REFUTED_PREMISE); counterexample
                                  proofs (COUNTEREXAMPLES, and every proof under
                                  counterexamples/); every `Example` and `Remark`
                                  proof (examples are not coverage); and every
                                  Qed in EXCLUDED_FILES

The three always add up to the active-build Qed count (every `Qed.` line in
the files `_CoqProject` lists, the same count generate-metrics.sh records as
internal.coqQedActive); the script fails if they do not.

Every file that holds a kernel capstone (KERNEL_CAPSTONES in
03_PROTO/crates/riinac/src/verify.rs) must count as core; the script fails
otherwise, and it fails if a named proof in REFUTED_PREMISE or COUNTEREXAMPLES
no longer exists, so neither list can go stale.

Limits: the vacuity patterns are heuristics, so `excluded_qed` is a lower
bound on vacuous proofs. The full counterexample triage, which moves these
proofs to counterexamples/, is REQ-104.

Usage: python3 scripts/coq-counting-policy.py <repo-root>   (prints JSON)
"""

import json
import os
import re
import subprocess
import sys

# The core metatheory. Everything else in the active build is a model.
CORE_DIRS = ("foundations", "type_system", "properties", "effects", "termination")

# Files outside CORE_DIRS that the compiler implements directly (mandate S2.7,
# "compiler-link files"). Each entry needs a reason.
COMPILER_LINK_FILES = {
    # The type checker's crypto-agility rule mirrors `accepts` here
    # (riina-typechecker/src/lib.rs), and the file holds the
    # accepts_uses_only_current capstone.
    "crypto/AlgorithmPolicy.v",
}

# Every proof in a file under these directories is a counterexample (REQ-104
# creates counterexamples/).
COUNTEREXAMPLE_DIRS = ("counterexamples",)

# Counterexample proofs still in their original files: they show a statement
# is false, so they are not coverage.
COUNTEREXAMPLES = {
    # Landin's knot: a well-typed program through a higher-order reference that
    # does not terminate, so full-calculus SN is false (REQ-84).
    "termination/ReducibilityFull.v": {
        "well_typed_SN_premise_store_values_are_values_refutable",
        "knot_step_deref", "knot_step_beta", "knot_not_SN", "knot_fn_typed",
        "knot_call_typed", "knot_store_wf", "landin_knot_counterexample",
        "well_typed_SN_conclusion_is_false",
    },
}

# Proofs whose statement carries a premise the build refutes, so they hold
# vacuously. These are the Section lemmas whose discharged type includes the
# store_values_are_values hypothesis, which
# well_typed_SN_premise_store_values_are_values_refutable disproves (found by
# `Check` on each Section lemma after `End ReducibilityFull`).
REFUTED_PREMISE = {
    "termination/ReducibilityFull.v": {
        "fundamental_reducibility", "well_typed_SN", "SN_app", "well_typed_SN_recursion_free",
    },
}

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


def qed_names(path):
    """Names of the declarations whose proof ends in `Qed.`."""
    names, current = set(), None
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                m = DECL.match(line)
                if m:
                    current = m.group(2)
                if "Qed." in line and current is not None:
                    names.add(current)
                    current = None
    except FileNotFoundError:
        pass
    return names


def capstone_files(root):
    """Files that hold a KERNEL_CAPSTONES theorem, from verify.rs."""
    src = open(os.path.join(root, "03_PROTO", "crates", "riinac", "src", "verify.rs"),
               encoding="utf-8").read()
    block = src.split("const KERNEL_CAPSTONES", 1)[1].split("];", 1)[0]
    return {m.replace(".", "/") + ".v" for m in re.findall(r'\("([A-Za-z_./]+)",\s*"', block)}


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
    files = active_files(coq_dir)

    def is_core(rel):
        return rel.split("/", 1)[0] in CORE_DIRS or rel in COMPILER_LINK_FILES

    problems = []
    for rel in sorted(capstone_files(root)):
        if rel not in files:
            problems.append(f"capstone file {rel} is not in the active build")
        elif not is_core(rel):
            problems.append(f"capstone file {rel} is not core (add it to COMPILER_LINK_FILES)")
    for rel in sorted(COMPILER_LINK_FILES - set(files)):
        problems.append(f"COMPILER_LINK_FILES names {rel}, which is not in the active build")
    for table, label in ((COUNTEREXAMPLES, "COUNTEREXAMPLES"), (REFUTED_PREMISE, "REFUTED_PREMISE")):
        for rel, names in sorted(table.items()):
            missing = names - qed_names(os.path.join(coq_dir, rel))
            if missing:
                problems.append(f"{label} names proofs not found in {rel}: {sorted(missing)}")
    if problems:
        print("counting policy: " + "; ".join(problems), file=sys.stderr)
        sys.exit(1)

    core = model = excluded = total = examples = counterexamples = refuted = 0
    for rel in files:
        path = os.path.join(coq_dir, rel)
        qed = qed_count(path)
        total += qed
        ex = example_names(path)
        examples += len(ex)
        cx = COUNTEREXAMPLES.get(rel, set())
        rp = REFUTED_PREMISE.get(rel, set())
        if rel.split("/", 1)[0] in COUNTEREXAMPLE_DIRS:
            counterexamples += qed
        counterexamples += len(cx)
        refuted += len(rp)
        # A proof in more than one category is excluded once.
        if rel in EXCLUDED_FILES or rel.split("/", 1)[0] in COUNTEREXAMPLE_DIRS:
            dropped = qed
        else:
            dropped = min(qed, len(flagged.get(rel, set()) | ex | cx | rp))
        excluded += dropped
        if is_core(rel):
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
        "counterexampleQed": counterexamples,
        "refutedPremiseQed": refuted,
        "coreDirs": list(CORE_DIRS),
        "compilerLinkFiles": sorted(COMPILER_LINK_FILES),
        "excludedFiles": sorted(EXCLUDED_FILES),
    }))


if __name__ == "__main__":
    main()
