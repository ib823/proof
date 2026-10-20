#!/usr/bin/env bash
# ============================================================================
# check-doc-drift.sh — every number, version and scoped claim on every public
# surface must agree with its source (mandate S5.7, R5; REQ-109).
#
# Sources of truth:
#   VERSION                                  the release version
#   website/public/metrics.json              counts (generate-metrics.sh)
#   scripts/provision-coq.sh                 the pinned Rocq version
#   02_FORMAL/smt/SCOPED_SET.txt             the SMT scoped-set size
#   03_PROTO/crates/riinac/tests/end_to_end.rs  CORPUS_PASSING
#
# The Coq core/model/excluded numbers and the raw-total ban are checked by
# audit-docs.sh (check_public_counts); this script checks everything else, and
# audit-docs.sh runs it, so the pre-commit hook and CI both do.
#
# A line that is explicitly historical ("historical", "at release", "at the
# tagged commit") keeps its numbers.
#
# It also fails when README.md or the website lacks a link to one of the
# generated ledgers (mandate §9.3), and when a planning document other than
# RIINA_MASTER_PLAN.md is not headed SUPERSEDED (S5.6).
#
# Usage:
#   bash scripts/check-doc-drift.sh              # check the repository
#   bash scripts/check-doc-drift.sh --self-test  # every rule catches a seeded fault
# ============================================================================
set -euo pipefail
REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
exec python3 -I - "$REPO_ROOT" "$@" <<'PY'
import json
import os
import re
import subprocess
import sys

ROOT = sys.argv[1]
SELF_TEST = "--self-test" in sys.argv[2:]

# Public surfaces (mandate §5). CHANGELOG is release history: only its banner
# line is a current-state surface.
SURFACES = [
    "README.md", "docs/i18n/README_ms.md", "docs/i18n/README_zh.md",
    "docs/UNDERSTANDING_RIINA.md", "docs/guide/GETTING_STARTED.md",
    "07_EXAMPLES/README.md", "llms.txt", "AGENTS.md", "COPILOT.md",
    ".cursorrules", ".clinerules", ".github/copilot-instructions.md",
    "SECURITY.md", "CONTRIBUTING.md", "website/index.html",
    "website/src/RiinaWebsite.jsx", "riina-vscode/package.json",
]
HISTORICAL = re.compile(r"historical|at release|at the tagged commit", re.I)

# The generated ledgers and the builtin matrix: README and the website must
# link every one of them (mandate §9.3, S1.11; REQ-103).
LEDGERS = [
    "HEADLINE_THEOREMS.md", "PROPERTY_LEDGER.md", "TRUSTED_BASE.md",
    "PROOF_STATUS.md", "AXIOMS.md", "docs/api/STDLIB.md",
]


def read(rel):
    with open(os.path.join(ROOT, rel), encoding="utf-8") as fh:
        return fh.read()


def num(s):
    return int(s.replace(",", ""))


# --------------------------------------------------------------------------
# Truth
# --------------------------------------------------------------------------
def load_truth():
    m = json.loads(read("website/public/metrics.json"))
    t = {
        "version": read("VERSION").strip(),
        "metrics_version": m.get("version"),
        "parameters": m["proofs"]["parameters"],
        "crates": m["rust"]["crates"],
        "examples": m["examples"],
        "rust_tests": m["rust"]["tests"],
        "coq_files_active": m["coq"]["filesActive"],
        "counting": {k: m["proofs"]["countingPolicy"][k] for k in
                     ("coreMechanizedQed", "modelMechanizedQedNonvacuous", "excludedQed")},
    }
    comp = m.get("compliance") or {}
    t["profiles"] = comp.get("profiles")
    t["rules"] = comp.get("rules")
    t["per_profile"] = comp.get("perProfile") or {}
    pin = re.search(r'ROCQ_CORE_VERSION="\$\{RIINA_ROCQ_CORE_VERSION:-([0-9.]+)\}"',
                    read("scripts/provision-coq.sh"))
    t["rocq"] = pin.group(1) if pin else None
    smt = 0
    for line in read("02_FORMAL/smt/SCOPED_SET.txt").splitlines():
        parts = line.split()
        if line.strip().startswith("#") or len(parts) < 2 or not parts[1].isdigit():
            continue
        smt += int(parts[1])
    t["smt"] = smt
    e2e = re.search(r"const CORPUS_PASSING: usize = (\d+);",
                    read("03_PROTO/crates/riinac/tests/end_to_end.rs"))
    t["corpus_passing"] = int(e2e.group(1)) if e2e else None
    # Rust crypto tests that compare an implementation with its Coq model.
    links = 0
    for d, _, fs in os.walk(os.path.join(ROOT, "05_TOOLING/crates/riina-core/src")):
        for f in fs:
            if f.endswith(".rs"):
                with open(os.path.join(d, f), encoding="utf-8") as fh:
                    links += len(re.findall(r"\bfn test_\w+_matches_coq_model\s*\(", fh.read()))
    t["bridge_links"] = links
    t["status"] = m.get("status", {})
    man = read("VERIFICATION_MANIFEST.md") if os.path.exists(os.path.join(ROOT, "VERIFICATION_MANIFEST.md")) else ""
    t["manifest"] = {k: (re.search(rf"^\*\*{k}:\*\* (\S+)", man, re.M) or [None, None])[1]
                     for k in ("Git SHA", "Mode", "Status")}
    t["cargo_versions"] = {}
    for ws in ("03_PROTO/Cargo.toml", "05_TOOLING/Cargo.toml"):
        sec = read(ws).split("[workspace.package]", 1)[1]
        v = re.search(r'^version = "([^"]+)"', sec, re.M)
        t["cargo_versions"][ws] = v.group(1) if v else None
    t["website_package"] = json.loads(read("website/package.json")).get("version")
    return t


# --------------------------------------------------------------------------
# Rules: each takes (line, truth) and yields problem strings.
# --------------------------------------------------------------------------
def r_test_count(line, t):
    for n in re.findall(r"\b(\d{1,2},\d{3}) tests\b", line):
        if num(n) != t["rust_tests"]:
            yield f"test count {n} (metrics.json rust.tests = {t['rust_tests']})"


def r_parameters(line, t):
    for n in re.findall(r"\b(\d+) `?Parameter`?s?\b", line):
        if int(n) != t["parameters"]:
            yield f"{n} Parameters (metrics.json proofs.parameters = {t['parameters']})"


def r_crates(line, t):
    for n in re.findall(r"\b(\d+) (?:workspace )?crates\b", line):
        # Only the compiler workspace's count is published; the tooling
        # workspace is described without one.
        if int(n) != t["crates"] and "tooling" not in line.lower():
            yield f"{n} crates (metrics.json rust.crates = {t['crates']})"


def r_examples(line, t):
    for n in re.findall(r"\b(\d+) (?:example programs|example \.rii files|\.rii files|example files)\b", line):
        if int(n) != t["examples"]:
            yield f"{n} examples (metrics.json examples = {t['examples']})"
    for n in re.findall(r"\b(\d+) (?:of the \d+ )?pass `?riinac check`?", line):
        if t["corpus_passing"] is not None and int(n) != t["corpus_passing"]:
            yield f"{n} examples pass check (end_to_end.rs CORPUS_PASSING = {t['corpus_passing']})"


def r_rocq(line, t):
    if t["rocq"] is None or re.search(r"untested|not 9\.2|9\.2\.0 is", line):
        return
    for v in re.findall(r"\bRocq (\d+\.\d+\.\d+)\b", line):
        if v != t["rocq"] and "stdlib" not in line:
            yield f"Rocq {v} (pinned in provision-coq.sh: {t['rocq']})"


def r_smt(line, t):
    low = line.lower()
    if "smt" not in low and "z3" not in low:
        return
    for n in re.findall(r"\b(\d+) (?:z3-checked |scoped )?properties\b", line):
        if int(n) != t["smt"]:
            yield f"{n} SMT properties (SCOPED_SET.txt total = {t['smt']})"


def r_compliance(line, t):
    if t["profiles"] is None:
        return
    low = line.lower()
    for n in re.findall(r"\b(\d+) (?:compliance )?profiles?\b", line):
        if "profile" in low and int(n) != t["profiles"] and int(n) > 3:
            yield f"{n} compliance profiles (riina-compliance has {t['profiles']})"
    for n in re.findall(r"\b(\d{2,4}) machine-checkable rules\b", line):
        if int(n) != t["rules"]:
            yield f"{n} machine-checkable rules (riina-compliance has {t['rules']})"
    for slug, n in re.findall(r"\b([a-z0-9-]+) (?:checker )?profile \((\d+) rules", line):
        want = t["per_profile"].get(slug)
        if want is not None and int(n) != want:
            yield f"{slug} profile has {n} rules here, {want} in riina-compliance"
    if "15 profile names" in line:
        yield f"'15 profile names' (riina-compliance has {t['profiles']})"


def r_axiom_caveat(line, t):
    # "0 Axiom" may never stand alone: the 29 Parameters go next to it (§5).
    if re.search(r"\b0 (?:`Axiom`|Axioms?|axioms?)\b", line) and not re.search(r"parameter", line, re.I):
        yield "'0 Axiom' without the Parameter caveat on the same line (mandate §5)"


def r_constant_time(line, t):
    low = line.lower()
    if re.search(r"constant[- ]time", low) and re.search(r"\bprov(?:en|es|ed)\b|\btheorem\b", low):
        if "reduction" not in low and "not a proof" not in low and "not proven" not in low:
            yield "constant-time proof claim without the reduction-count cost model (S2.3)"


RISKY = [
    (r"formally verified (?:programming )?language", "§5: 'formally verified language' (use 'Coq-verified core model')"),
    (r"proven before the code runs", "§5: 'proven before the code runs'"),
    (r"thousands (?:of )?theorems", "§5: 'thousands theorems'"),
    (r"\bmulti-prover\b", "§5: 'multi-prover'"),
    (r"\b(?:ten|nine|\d+) (?:generated |independent )?prover lanes\b", "§5: a prover-lane count"),
    (r"\bfips[- ]validated\b|\bfips[- ]certified\b", "§5: 'FIPS validated' without a certificate"),
    (r"if your program compiles, it is safe", "§5: 'if it compiles, it is safe'"),
]


def r_risky(line, t):
    low = line.lower()
    for pat, msg in RISKY:
        if re.search(pat, low) and not re.search(r"\bnot\b|never|withdrawn|retired|no longer", low):
            yield msg


def r_coq_files(line, t):
    for mm in re.finditer(r"\(?(\d[\d,]*)\)? active (?:Coq )?(?:files|modules)|\((\d[\d,]*) active\)", line):
        n = num(mm.group(1) or mm.group(2))
        if n != t["coq_files_active"]:
            yield f"{n} active Coq files, but metrics.json coq.filesActive is {t['coq_files_active']}"


def r_stale(line, t):
    """Statements B12 found contradicting PROOF_STATUS.md / llms.txt."""
    for mm in re.finditer(r"(\d+) (?:active )?`?Abort`?(?! sites? (?:were|are) (?:gone|closed))", line):
        if int(mm.group(1)) != 0:
            yield f"{mm.group(1)} Abort sites, but the active build has none (PROOF_STATUS.md)"
    if re.search(r"Isabelle[^.|]*\bcompiles\b", line):
        yield "Isabelle is retired (REQ-67g); it does not 'compile' as a lane"


NUMBER_WORDS = {w: i for i, w in enumerate(
    "zero one two three four five six seven eight nine ten eleven twelve".split())}


def r_bridge_links(line, t):
    for mm in re.finditer(r"\b(\w+) such differential links", line):
        word = mm.group(1).lower()
        n = int(word) if word.isdigit() else NUMBER_WORDS.get(word)
        if n is not None and n != t["bridge_links"]:
            yield (f"{mm.group(1)} differential links, but riina-core has {t['bridge_links']} "
                   "*_matches_coq_model tests")


LINE_RULES = [r_test_count, r_parameters, r_crates, r_examples, r_rocq, r_smt,
              r_compliance, r_axiom_caveat, r_constant_time, r_risky, r_coq_files, r_stale,
              r_bridge_links]


def check_text(rel, text, t):
    out = []
    for i, line in enumerate(text.splitlines(), 1):
        if HISTORICAL.search(line):
            continue
        for rule in LINE_RULES:
            for p in rule(line, t):
                out.append(f"{rel}:{i}: {p}")
    return out


def check_versions(t):
    out = []
    v = t["version"]
    if t["metrics_version"] != v:
        out.append(f"metrics.json version {t['metrics_version']} != VERSION {v}")
    for ws, cv in t["cargo_versions"].items():
        if cv != v:
            out.append(f"{ws} [workspace.package] version {cv} != VERSION {v}")
    if t["website_package"] != v:
        out.append(f"website/package.json version {t['website_package']} != VERSION {v}")
    for rel, pat in (("llms.txt", r"^- Version: (\S+)"), ("AGENTS.md", r"^\| Version \| (\S+)")):
        mm = re.search(pat, read(rel), re.M)
        if mm and mm.group(1) != v:
            out.append(f"{rel}: version {mm.group(1)} != VERSION {v}")
    return out


def check_ledger_links(readme, site):
    out = []
    for f in LEDGERS:
        if f"]({f})" not in readme:
            out.append(f"README.md: no link to {f}")
        if f"'{f}'" not in site:
            out.append(f"website/src/RiinaWebsite.jsx: no link to {f} (LEDGERS)")
    return out


def check_legacy_plans():
    """Every planning document other than the master plan is headed SUPERSEDED
    (mandate S5.6). 01_RESEARCH and 99_ARCHIVE are archives already."""
    out = []
    files = subprocess.run(["git", "-C", ROOT, "ls-files", "*PLAN*.md"], capture_output=True,
                           text=True, check=True).stdout.split()
    for rel in files:
        if rel == "RIINA_MASTER_PLAN.md" or rel.startswith(("01_RESEARCH/", "99_ARCHIVE/")):
            continue
        if "SUPERSEDED" not in "\n".join(read(rel).splitlines()[:10]):
            out.append(f"{rel}: a planning document other than RIINA_MASTER_PLAN.md must be headed SUPERSEDED")
    return out


def check_metrics_status(status, manifest):
    """metrics.json `status` is derived from the riinac verify manifest, never
    hand-typed (it once carried "grade": "A" and "threats": "1231+")."""
    out = []
    allowed = {"build", "verifiedCommit", "verifiedMode", "source"}
    for k in sorted(set(status) - allowed):
        out.append(f"metrics.json status.{k} is not measured by anything; remove it")
    want = ("passing" if manifest.get("Mode") == "full" and manifest.get("Status") == "PASS"
            else "failing" if manifest.get("Status") == "FAIL" else "unverified")
    if status.get("build") != want:
        out.append(f"metrics.json status.build is {status.get('build')!r}; the manifest says {want!r}")
    if manifest.get("Git SHA") and status.get("verifiedCommit") != manifest["Git SHA"]:
        out.append(f"metrics.json status.verifiedCommit {status.get('verifiedCommit')} != manifest "
                   f"{manifest['Git SHA']} (run scripts/generate-metrics.sh)")
    return out


def check_site_defaults(t):
    """The website's fallback counts (shown while metrics.json loads) are the
    generated ones."""
    out = []
    src = read("website/src/useMetrics.js")
    for key, want in t["counting"].items():
        mm = re.search(key + r": (\d+)", src)
        if not mm or int(mm.group(1)) != want:
            got = mm.group(1) if mm else "missing"
            out.append(f"website/src/useMetrics.js: default {key} {got} != metrics.json {want}")
    if re.search(r"\bqedActive\b\s*:", src):
        out.append("website/src/useMetrics.js: defaults carry the raw qedActive total (mandate S2.7)")
    return out


def check_repo(t):
    problems = check_versions(t)
    problems += check_site_defaults(t)
    problems += check_metrics_status(t["status"], t["manifest"])
    problems += check_legacy_plans()
    for f in LEDGERS:
        if not os.path.exists(os.path.join(ROOT, f)):
            problems.append(f"{f} is missing (run python3 scripts/generate-ledgers.py)")
    problems += check_ledger_links(read("README.md"), read("website/src/RiinaWebsite.jsx"))
    if t["profiles"] is None:
        problems.append("metrics.json has no compliance block (run scripts/generate-metrics.sh)")
    for rel in SURFACES:
        if os.path.exists(os.path.join(ROOT, rel)):
            problems += check_text(rel, read(rel), t)
    banner = next((l for l in read("CHANGELOG.md").splitlines() if l.startswith("**Verification:**")), "")
    problems += check_text("CHANGELOG.md (banner)", banner, t)
    return problems


def self_test(t):
    """Every rule must flag a seeded fault, and leave a correct line alone."""
    t = dict(t, rust_tests=3564, parameters=29, crates=18, examples=172, corpus_passing=84,
             rocq="9.1.1", smt=37, profiles=19, rules=606, per_profile={"hipaa": 33},
             coq_files_active=334, bridge_links=9)
    seeded = {
        "3,560 tests pass": r_test_count, "29 `Parameter`s ok / 30 Parameters": r_parameters,
        "Rust compiler (19 crates)": r_crates, "171 example programs": r_examples,
        "83 pass `riinac check`": r_examples, "Rocq 9.2.1 build": r_rocq,
        "SMT: 36 properties": r_smt, "19 profiles across 605 machine-checkable rules": r_compliance,
        "hipaa profile (54 rules)": r_compliance, "15 profile names": r_compliance,
        "0 Admitted, 0 axioms": r_axiom_caveat, "constant time is proven": r_constant_time,
        "A formally verified programming language": r_risky,
        "Security properties, proven before the code runs": r_risky,
        "ten prover lanes": r_risky,
        "Coq files: 317 (277 active)": r_coq_files, "333 active Coq files": r_coq_files,
        "4 active Abort sites remain (REQ-21)": r_stale,
        "the Isabelle smoke theory compiles": r_stale,
        "One of eight such differential links": r_bridge_links,
    }
    clean = {
        "3,564 tests pass": r_test_count, "29 `Parameter`s (trusted interface)": r_parameters,
        "Rust compiler (18 crates)": r_crates, "172 example programs; 84 pass `riinac check`": r_examples,
        "Rocq 9.1.1": r_rocq, "SMT scoped set: 37 properties": r_smt,
        "19 profiles across 606 machine-checkable rules; hipaa profile (33 rules)": r_compliance,
        "0 `Axiom`, 29 `Parameter`s": r_axiom_caveat,
        "reduction-count independence (the constant-time theorem, reduction model)": r_constant_time,
        "Programming language with a Coq-verified core model": r_risky,
        "334 active files; 334 active Coq modules": r_coq_files,
        "0 Admitted, 0 Abort, 0 `Axiom`": r_stale,
        "One of nine such differential links": r_bridge_links,
    }
    failures = []
    for text, rule in seeded.items():
        if not list(rule(text, t)):
            failures.append(f"{rule.__name__} missed the seeded fault: {text!r}")
    for text, rule in clean.items():
        hits = list(rule(text, t))
        if hits:
            failures.append(f"{rule.__name__} flagged a correct line {text!r}: {hits}")
    if check_text("x", "historical: 3,000 tests and 0 axioms", t):
        failures.append("historical lines must be exempt")
    all_md = "".join(f"[x]({f}) " for f in LEDGERS)
    all_js = "".join(f"['{f}', 'x'] " for f in LEDGERS)
    full_pass = {"Git SHA": "abc1234", "Mode": "full", "Status": "PASS"}
    good = {"build": "passing", "verifiedCommit": "abc1234", "verifiedMode": "full", "source": "x"}
    if check_metrics_status(good, full_pass):
        failures.append("check_metrics_status flagged a status derived from the manifest")
    if not check_metrics_status(dict(good, grade="A"), full_pass):
        failures.append("check_metrics_status missed a hand-typed status.grade")
    if not check_metrics_status(good, dict(full_pass, Mode="fast")):
        failures.append("check_metrics_status missed 'passing' backed only by a fast-mode run")
    if check_ledger_links(all_md, all_js):
        failures.append("check_ledger_links flagged complete link lists")
    if len(check_ledger_links(all_md.replace("(TRUSTED_BASE.md)", ""), all_js)) != 1:
        failures.append("check_ledger_links missed a README without the TRUSTED_BASE.md link")
    return failures


truth = load_truth()
if SELF_TEST:
    fails = self_test(truth)
    if fails:
        print("check-doc-drift self-test FAILED:")
        print("\n".join("  " + f for f in fails))
        sys.exit(1)
    print("check-doc-drift self-test: every rule caught its seeded fault and passed its clean line")
    sys.exit(0)

problems = check_repo(truth)
if problems:
    print(f"DOC DRIFT: {len(problems)} problem(s):")
    print("\n".join("  " + p for p in problems))
    sys.exit(1)
print(f"No doc drift across {len(SURFACES)} surfaces (version {truth['version']}).")
PY
