#!/usr/bin/env bash
# ============================================================================
# check-doc-drift.sh — every number, version and claim level on every public
# surface must agree with its source (mandate S5.7, R5, §2; REQ-109).
#
# Sources of truth:
#   VERSION                                  the release version
#   website/public/metrics.json              counts (generate-metrics.sh)
#   scripts/provision-coq.sh                 the pinned Rocq version
#   02_FORMAL/smt/SCOPED_SET.txt             the SMT scoped set and its parts
#   03_PROTO/crates/riinac/tests/end_to_end.rs  CORPUS_PASSING / CORPUS_TOTAL
#   docs/api/STDLIB.md                       builtin totals (generated)
#   the lexer, parser, riina-types and riinac's usage text (through
#     scripts/generate-agent-files.py): keyword, type, effect, level, command
#     and target counts
#   sbom/*.cdx.json, the Coq sources, riina-vscode snippets, the website
#     source and the master plan's Part 8, for the counts they hold
#
# The Coq core/model/excluded numbers and the raw-total ban are checked by
# audit-docs.sh (check_public_counts); this script checks everything else, and
# audit-docs.sh runs it, so the pre-commit hook and CI both do.
#
# Two passes over every surface:
#   1. rules: each known kind of claim is compared with its source;
#   2. the inventory: every number on the surface must sit inside a claim a
#      rule checks, or inside an EXEMPT pattern that says why it is not a
#      metric (a duration, a clause reference, a code literal). A new number
#      that neither covers fails, so the check cannot silently fall behind the
#      prose. The agent instruction files are inventoried through their
#      templates, whose hand-typed text is where a stray number would come from.
#
# Text is checked a sentence at a time (a table row, heading or code line is
# one unit). A sentence that is explicitly historical ("historical", "at
# release", "at the tagged commit", "at commit <sha>", "until <date>", "drop
# from") keeps its numbers, and so does the website's release list.
#
# Claim levels (§2): a level a surface states must be one of the seven §2
# levels, or a lane level from metrics.json `claimLevels.legend`, and every
# lane level must map onto a §2 level in generate-ledgers.py CLAIM_LEVEL_MAP.
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
import glob
import importlib.util
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
    "07_EXAMPLES/README.md", "llms.txt", "llms-full.txt", "AGENTS.md", "COPILOT.md",
    ".cursorrules", ".clinerules", ".github/copilot-instructions.md",
    "SECURITY.md", "CONTRIBUTING.md", "website/index.html",
    "website/src/RiinaWebsite.jsx", "riina-vscode/package.json",
    "docs/guide/WRITING_SECURE_RIINA.md", "docs/guide/MUTABLE_STATE.md",
    "docs/JALINAN_GUIDE.md", "docs/SYARIAH_GUIDE.md", "docs/CAHAYA_GUIDE.md",
    "docs/api/STDLIB.md", "docs/enterprise/COMPLIANCE_GUIDE.md",
    "docs/enterprise/COMPLIANCE_PACKAGING.md", "docs/enterprise/CERTIFICATION.md",
    "docs/spec/CORE_MAPPING.md",
]
# Surfaces the inventory reads through another file. The agent files' numbers
# are placeholders filled from the sources, so their templates (the hand-typed
# part) are inventoried instead; STDLIB.md is generated from the builtin
# registry and riina-typechecker/tests/stdlib_doc.rs fails when it drifts.
AGENT_FILES = {"AGENTS.md", "COPILOT.md", ".cursorrules", ".clinerules",
               ".github/copilot-instructions.md", "llms.txt", "llms-full.txt"}
AGENT_TEMPLATES = "04_SPECS/agent_files"
NOT_INVENTORIED = {"docs/api/STDLIB.md"}
HISTORICAL = re.compile(r"historical|at release|at the tagged commit|at commit `?[0-9a-f]{7,}"
                        r"|\b(?:until|before) \d{4}-\d{2}|\bdrop from\b", re.I)
# Blocks that are release history wherever they appear: (start, end) lines.
HISTORY_BLOCKS = [(re.compile(r"^const RELEASES = \["), re.compile(r"^\];"))]

# The generated ledgers and the builtin matrix: README and the website must
# link every one of them (mandate §9.3, S1.11; REQ-103).
LEDGERS = [
    "HEADLINE_THEOREMS.md", "PROPERTY_LEDGER.md", "TRUSTED_BASE.md",
    "PROOF_STATUS.md", "AXIOMS.md", "docs/api/STDLIB.md",
]

# Mandate §2: the only claim levels a property may carry.
LEVELS = ("PROVEN-IMPL", "PROVEN-MODEL", "ENFORCED-TESTED", "MODELLED", "GENERATED", "RETIRED", "PLANNED")


def path(rel):
    return os.path.join(ROOT, rel)


def read(rel):
    with open(path(rel), encoding="utf-8") as fh:
        return fh.read()


def maybe(rel):
    return read(rel) if os.path.exists(path(rel)) else None


def num(s):
    return int(s.replace(",", ""))


# --------------------------------------------------------------------------
# Truth
# --------------------------------------------------------------------------
def agent_generator():
    sys.dont_write_bytecode = True  # leave no scripts/__pycache__ behind
    spec = importlib.util.spec_from_file_location("gaf", path("scripts/generate-agent-files.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def enum_variants(src, header):
    """The variant names of a Rust enum, from `pub enum X {` to its `}`."""
    i = src.index(header)
    body = src[i:src.index("\n}\n", i)]
    return re.findall(r"^\s{4}([A-Z]\w*)\b", body, re.M)


def coq_levels(src, fn):
    """{constructor: n} from a Coq `match` returning nat literals."""
    i = src.index(f"Definition {fn} ")
    body = src[i:src.index("end.", i)]
    return {c: int(n) for c, n in re.findall(r"\b([A-Z]\w*)\s*=>\s*(\d+)", body)}


def load_truth():
    m = json.loads(read("website/public/metrics.json"))
    t = {
        "version": read("VERSION").strip(),
        "metrics_version": m.get("version"),
        "admitted": m["proofs"]["admitted"],
        "axioms": m["proofs"]["axioms"],
        "parameters": m["proofs"]["parameters"],
        "vacuity": m["proofs"].get("vacuityFindings"),
        "crates": m["rust"]["crates"],
        "examples": m["examples"],
        "rust_tests": m["rust"]["tests"],
        "coq_files_active": m["coq"]["filesActive"],
        "coq_files_total": m["coq"].get("filesTotal"),
        "coq_domains": m["coq"].get("domains"),
        "lean_theorems": m["lean"]["theorems"],
        "isabelle_lemmas": m["isabelle"]["lemmas"],
        "fstar_lemmas": m["fstar"].get("smokeLemmas"),
        "tla_theorems": m["tlaplus"].get("compiledTheorems"),
        "alloy_assertions": m["alloy"].get("compiledAssertions"),
        "claim_levels": m.get("claimLevels") or {},
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
    smt, parts = 0, {}
    for line in read("02_FORMAL/smt/SCOPED_SET.txt").splitlines():
        p = line.split()
        if line.strip().startswith("#") or len(p) < 2 or not p[1].isdigit():
            continue
        smt += int(p[1])
        # SecurityLatticeVerification.smt2 -> "security lattice"
        stem = os.path.basename(p[0]).split(".")[0].replace("Verification", "")
        parts[" ".join(re.findall(r"[A-Z][a-z]*", stem)).lower()] = int(p[1])
    t["smt"], t["smt_parts"] = smt, parts
    ec = re.search(r"const EMIT_CORE_PASSING: usize = (\d+);",
                   maybe("03_PROTO/crates/riinac/tests/emit_core.rs") or "")
    t["emit_core_passing"] = int(ec.group(1)) if ec else None
    e2e = read("03_PROTO/crates/riinac/tests/end_to_end.rs")
    mm = re.search(r"const CORPUS_PASSING: usize = (\d+);", e2e)
    t["corpus_passing"] = int(mm.group(1)) if mm else None
    # Rust crypto tests that compare an implementation with its Coq model.
    links = 0
    for d, _, fs in os.walk(path("05_TOOLING/crates/riina-core/src")):
        for f in fs:
            if f.endswith(".rs"):
                with open(os.path.join(d, f), encoding="utf-8") as fh:
                    links += len(re.findall(r"\bfn test_\w+_matches_coq_model\s*\(", fh.read()))
    t["bridge_links"] = links
    t["status"] = m.get("status", {})
    # The manifest and the master plan are internal: the public tree has
    # neither, and there status.build was already checked on main before the
    # sync. A missing manifest on a tree that has the plan is an error.
    t["public_tree"] = not os.path.exists(path("RIINA_MASTER_PLAN.md"))
    man = maybe("VERIFICATION_MANIFEST.md") or ""
    t["manifest"] = {k: (re.search(rf"^\*\*{k}:\*\* (\S+)", man, re.M) or [None, None])[1]
                     for k in ("Git SHA", "Mode", "Status")}
    t["cargo_versions"] = {}
    for ws in ("03_PROTO/Cargo.toml", "05_TOOLING/Cargo.toml"):
        sec = read(ws).split("[workspace.package]", 1)[1]
        v = re.search(r'^version = "([^"]+)"', sec, re.M)
        t["cargo_versions"][ws] = v.group(1) if v else None
    rv = re.search(r'^rust-version = "(\d+\.\d+(?:\.\d+)?)"', read("03_PROTO/Cargo.toml"), re.M)
    t["rust_version"] = rv.group(1) if rv else None
    t["website_package"] = json.loads(read("website/package.json")).get("version")
    z3 = re.search(r"Z3 (\d+\.\d+\.\d+)", m["smt"].get("smokeVerified", ""))
    t["z3"] = z3.group(1) if z3 else None

    # The compiler's own tables, through the agent-file generator's parsers.
    g = agent_generator()
    t["keywords"] = len(g.keyword_table())
    t["effects"] = len(g.effects())
    t["security_levels"] = len(g.security_levels())
    t["rust_effect_level"] = {eng: n for _, eng, n in g.effects()}
    t["rust_sec_level"] = {eng: n for _, eng, n in g.security_levels()}
    t["commands"] = len(g.cli_commands())
    usage = read("03_PROTO/crates/riinac/src/main.rs")
    tg = re.search(r"--target <target>\s+Compilation target \(([^)]*)\)", usage)
    t["target_families"] = (len({re.split(r"\d|-", x.strip())[0] for x in tg.group(1).split(",")})
                            if tg else None)
    types_src = read("03_PROTO/crates/riina-types/src/lib.rs")
    t["types"] = len(enum_variants(types_src, "pub enum Ty {"))
    syntax = read("02_FORMAL/coq/foundations/Syntax.v")
    t["coq_effect_level"] = coq_levels(syntax, "effect_level")
    t["coq_sec_level"] = coq_levels(syntax, "sec_level_num")
    sem = read("02_FORMAL/coq/foundations/Semantics.v")
    i = sem.index("Inductive step")
    t["step_rules"] = len(re.findall(r"^\s*\|\s*ST_\w+", sem[i:i + re.search(r"\.\s*\n\s*\n", sem[i:]).end()], re.M))
    verify_rs = read("03_PROTO/crates/riinac/src/verify.rs")
    free = verify_rs.split("const AXIOM_FREE_CAPSTONES: &[&str] = &[", 1)[1].split("];", 1)[0]
    t["axiom_free_capstones"] = len(re.findall(r'"\w+"', free))
    stdlib = read("docs/api/STDLIB.md")
    mm = re.search(r"Total registered builtins: \*\*(\d+)\*\*", stdlib)
    t["builtins"] = int(mm.group(1)) if mm else None
    mm = re.search(r"\*\*(\d+)\*\* of the \d+ compile", stdlib)
    t["builtins_compiled"] = int(mm.group(1)) if mm else None
    t["example_dirs"] = len([d for d in os.listdir(path("07_EXAMPLES")) if os.path.isdir(path(f"07_EXAMPLES/{d}"))])
    t["industry_specs"] = (len(glob.glob(path("04_SPECS/industries/IND_*.md")))
                           if os.path.isdir(path("04_SPECS/industries")) else None)
    t["snippets"] = sum(read(os.path.relpath(f, ROOT)).count('"prefix"')
                        for f in glob.glob(path("riina-vscode/snippets/*.json")))
    site = read("website/src/RiinaWebsite.jsx")
    t["site_pages"] = len(set(re.findall(r"\{page === '(\w+)' &&", site)))
    sectors = site.split("const SECTORS = [", 1)[1].split("\n];", 1)[0]
    t["site_sectors"] = len(re.findall(r"^\s*\{ name: '", sectors, re.M))
    sbom = {}
    for name in ("proto", "tooling"):
        doc = json.loads(read(f"sbom/riina-{name}.cdx.json"))
        sbom[name] = sum(1 for c in doc.get("components", []) if not c["name"].startswith("riina"))
    t["sbom_third_party"] = sbom
    vs = maybe("05_TOOLING/scripts/verify.sh") or ""
    t["verify_levels"] = len(set(re.findall(r'"\$LEVEL" -ge (\d+)', vs))) or None
    plan = maybe("RIINA_MASTER_PLAN.md")
    if plan:
        part8 = plan.split("## PART 8:", 1)[1].split("\n## PART ", 1)[0]
        t["protocol_steps"] = len(re.findall(r"^### STEP \d+:", part8, re.M))
    else:
        t["protocol_steps"] = None
    t["ledger_impl"] = "| PROVEN-IMPL |" in (maybe("PROPERTY_LEDGER.md") or "").split("| Property |", 1)[-1]
    gl = read("scripts/generate-ledgers.py")
    cmap = gl.split("CLAIM_LEVEL_MAP = [", 1)[1].split("\n]", 1)[0]
    t["claim_level_map"] = re.findall(r'\("([^"]+)", "([^"]+)"\)', cmap)
    return t


def coq_file_qed(name):
    """Qed count of the active Coq file whose path ends with `name`."""
    for d, _, fs in os.walk(path("02_FORMAL/coq")):
        if "_archive" in d:
            continue
        for f in fs:
            full = os.path.join(d, f)
            if full.endswith("/" + name):
                with open(full, encoding="utf-8") as fh:
                    return len(re.findall(r"\bQed\.", fh.read()))
    return None


# --------------------------------------------------------------------------
# Rules: each takes (text, truth) and yields problem strings. Every pattern a
# rule checks is registered with claim(), and the inventory treats a number
# inside a registered match as checked.
# --------------------------------------------------------------------------
CLAIMS = []


def claim(pattern, flags=0):
    rx = re.compile(pattern, flags)
    CLAIMS.append(rx)
    return rx


def first(mm):
    return next(g for g in mm.groups() if g is not None)


TESTS = claim(r"\b(\d{1,2},?\d{3}) (?:Rust )?tests\b|\bRust tests \| (\d{1,2},?\d{3})\b")


def r_test_count(line, t):
    for mm in TESTS.finditer(line):
        if num(first(mm)) != t["rust_tests"]:
            yield f"test count {first(mm)} (metrics.json rust.tests = {t['rust_tests']})"


PARAMS = claim(r"\b(\d+) `?Parameter`?s?\b")


def r_parameters(line, t):
    for n in PARAMS.findall(line):
        if int(n) != t["parameters"]:
            yield f"{n} Parameters (metrics.json proofs.parameters = {t['parameters']})"


CRATES = claim(r"\b(\d+) (?:workspace )?crates\b|\b(?:Rust|Compiler) crates \| (\d+)\b")


def r_crates(line, t):
    for mm in CRATES.finditer(line):
        # Only the compiler workspace's count is published; the tooling
        # workspace is described without one.
        if int(first(mm)) != t["crates"] and "tooling" not in line.lower():
            yield f"{first(mm)} crates (metrics.json rust.crates = {t['crates']})"


EXAMPLES = claim(r"\b(\d+) (?:example programs|example \.rii files|\.rii files|example files"
                 r"|example `\.rii` files|`\.rii` example files)\b"
                 r"|\bExample programs \| (\d+)\b|\bexamples \((\d+) today\b")
PASSING = claim(r"\b(\d+) (?:of the (\d+) )?(?:examples |currently )?pass\b")
CATEGORIES = claim(r"\b(\d+) category directories\b")
EMITTED = claim(r"\b(\d+) of the (\d+) checked examples emit\b")


def r_examples(line, t):
    for mm in EXAMPLES.finditer(line):
        if int(first(mm)) != t["examples"]:
            yield f"{first(mm)} examples (metrics.json examples = {t['examples']})"
    for mm in PASSING.finditer(line):
        if "riinac check" not in line and "examples" not in line:
            continue
        if t["corpus_passing"] is not None and int(mm.group(1)) != t["corpus_passing"]:
            yield f"{mm.group(1)} examples pass check (end_to_end.rs CORPUS_PASSING = {t['corpus_passing']})"
        if mm.group(2) and int(mm.group(2)) != t["examples"]:
            yield f"'of the {mm.group(2)}' examples (metrics.json examples = {t['examples']})"
    for n, m in EMITTED.findall(line):
        if t.get("emit_core_passing") is not None and int(n) != t["emit_core_passing"]:
            yield f"{n} examples emit core terms (emit_core.rs EMIT_CORE_PASSING = {t['emit_core_passing']})"
        if t["corpus_passing"] is not None and int(m) != t["corpus_passing"]:
            yield f"'of the {m} checked examples' (end_to_end.rs CORPUS_PASSING = {t['corpus_passing']})"
    for n in CATEGORIES.findall(line):
        if t.get("example_dirs") is not None and int(n) != t["example_dirs"]:
            yield f"{n} category directories (07_EXAMPLES has {t['example_dirs']})"


ROCQ = claim(r"\bRocq (\d+\.\d+(?:\.\d+)?)\b")


def r_rocq(line, t):
    if t["rocq"] is None or re.search(r"untested|not 9\.2|9\.2\.0 is", line):
        return
    for v in ROCQ.findall(line):
        if v != t["rocq"] and "stdlib" not in line:
            yield f"Rocq {v} (pinned in provision-coq.sh: {t['rocq']})"


RUST_TC = claim(r"\bRust toolchain \((\d+\.\d+(?:\.\d+)?)\+?\)|\*\*Rust\*\* (\d+\.\d+(?:\.\d+)?)\+?")
Z3 = claim(r"\bZ3 (\d+\.\d+\.\d+)")


def r_rust_toolchain(line, t):
    for mm in RUST_TC.finditer(line):
        v = first(mm)
        if t.get("rust_version") and not t["rust_version"].startswith(v):
            yield f"Rust {v} (rust-version in 03_PROTO/Cargo.toml: {t['rust_version']})"
    for v in Z3.findall(line):
        if t.get("z3") and v != t["z3"]:
            yield f"Z3 {v} (metrics.json smt.smokeVerified ran Z3 {t['z3']})"


SMT_TOTAL = claim(r"\b(\d+) (?:z3-checked |scoped )?properties\b", re.I)
SMT_PART = claim(r"\b(security lattice|effect join) (\d+)\b", re.I)


def r_smt(line, t):
    low = line.lower()
    if "smt" not in low and "z3" not in low:
        return
    for n in SMT_TOTAL.findall(line):
        if int(n) != t["smt"]:
            yield f"{n} SMT properties (SCOPED_SET.txt total = {t['smt']})"
    for part, n in SMT_PART.findall(line):
        want = t.get("smt_parts", {}).get(part.lower())
        if want is not None and int(n) != want:
            yield f"{part} {n} (SCOPED_SET.txt lists {want})"


PROFILES = claim(r"\b(\d+) (?:compliance |available )?profiles?\b|\bCompliance profiles \| (\d+)\b")
RULES = claim(r"\b(\d{2,4}) (?:machine-checkable|heuristic) rules\b")
PER_PROFILE = claim(r"\b([a-z0-9-]+) (?:checker )?profile \((\d+) rules")


def r_compliance(line, t):
    if t["profiles"] is None:
        return
    low = line.lower()
    for mm in PROFILES.finditer(line):
        if "profile" in low and int(first(mm)) != t["profiles"] and int(first(mm)) > 3:
            yield f"{first(mm)} compliance profiles (riina-compliance has {t['profiles']})"
    for n in RULES.findall(line):
        if int(n) != t["rules"]:
            yield f"{n} compliance rules (riina-compliance has {t['rules']})"
    for slug, n in PER_PROFILE.findall(line):
        want = t["per_profile"].get(slug)
        if want is not None and int(n) != want:
            yield f"{slug} profile has {n} rules here, {want} in riina-compliance"
    if "15 profile names" in line:
        yield f"'15 profile names' (riina-compliance has {t['profiles']})"


AXIOMS = claim(r"\b(\d+) (?:`Axiom`|Axioms?\b|axioms?\b)|\bAxiom = (\d+)")


def r_axiom_caveat(line, t):
    # "0 Axiom" may never stand alone: the 29 Parameters go next to it (§5).
    if re.search(r"\b0 (?:`Axiom`|Axioms?\b|axioms?\b)", line) and not re.search(r"parameter", line, re.I):
        yield "'0 Axiom' without the Parameter caveat on the same line (mandate §5)"
    for mm in AXIOMS.finditer(line):
        if int(first(mm)) != t.get("axioms", 0):
            yield f"{first(mm)} Axiom (metrics.json proofs.axioms = {t.get('axioms')})"


ADMITTED = claim(r"\b(\d+) `?Admitted`?|\bAdmitted = (\d+)|Incomplete proofs \(Admitted\) \| (\d+)"
                 r"|# prints (\d+)|\bfiles, (\d+) errors\b")


def r_admitted(line, t):
    for mm in ADMITTED.finditer(line):
        if int(first(mm)) != t.get("admitted", 0):
            yield f"{first(mm)} Admitted (metrics.json proofs.admitted = {t.get('admitted')})"


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
    (r"proof certificate", "REQ-96: RIINA issues no proof certificate"),
    (r"certifiably correct", "REQ-96: 'certifiably correct'"),
    (r"replac\w* (?:for )?(?:manual )?code review", "REQ-96: a check does not replace code review"),
    (r"mathematically (?:guaranteed|proven secure|certain)", "REQ-96: 'mathematically guaranteed'"),
    (r"backed by (?:the )?coq (?:formal )?proofs", "REQ-96: compliance rules are not derived from Coq proofs"),
    (r"syariahpatuh", "REQ-96: there is no SyariahPatuh effect (REQ-20 is planned)"),
    (r"\b\d[\d,]*\+ threats\b", "an unmeasured threat count (removed from metrics.json 2026-10-20)"),
]

# Mandate S1.13: until the compiler itself is verified, the README and the
# website say so, in these words (owner-revisable wording, R7).
COMPILER_NOT_VERIFIED = re.compile(r"unlike compcert or cakeml,[^.]*\briinac\b[^.]*not (?:itself )?formally verified", re.I)


def check_compiler_honesty(readme, site):
    out = []
    for rel, text in (("README.md", readme), ("website/src/RiinaWebsite.jsx", site)):
        flat = re.sub(r"<[^>]+>|\s+", " ", text)
        if not COMPILER_NOT_VERIFIED.search(flat):
            out.append(f"{rel}: must say that, unlike CompCert or CakeML, riinac itself is not "
                       "formally verified (mandate S1.13)")
    return out


def r_risky(line, t):
    low = line.lower()
    for pat, msg in RISKY:
        if re.search(pat, low) and not re.search(r"\bnot\b|never|withdrawn|retired|no longer", low):
            yield msg


COQ_FILES = claim(r"\(?(\d[\d,]*)\)? active (?:Coq |proof |\.v )?(?:files|modules)|\((\d[\d,]*) active\)"
                  r"|\bActive proof files \| (\d+)\b")
COQ_TOTAL = claim(r"\b(\d+) Coq (?:proof )?files\b")
COQ_DOMAINS = claim(r"\b(\d+) domain-specific model files\b")
FILE_QED = claim(r"`(?:[\w/]+/)?(\w+\.v)` \((\d+) Qed")


def r_coq_files(line, t):
    for mm in COQ_FILES.finditer(line):
        n = num(first(mm))
        if n != t["coq_files_active"]:
            yield f"{n} active Coq files, but metrics.json coq.filesActive is {t['coq_files_active']}"
    for n in COQ_TOTAL.findall(line):
        if t.get("coq_files_total") is not None and int(n) != t["coq_files_total"]:
            yield f"{n} Coq files, but metrics.json coq.filesTotal is {t['coq_files_total']}"
    for n in COQ_DOMAINS.findall(line):
        if t.get("coq_domains") is not None and int(n) != t["coq_domains"]:
            yield f"{n} domain model files, but metrics.json coq.domains is {t['coq_domains']}"
    for name, n in FILE_QED.findall(line):
        want = t["file_qed"](name) if "file_qed" in t else None
        if want is not None and int(n) != want:
            yield f"{name} has {want} Qed, not {n}"


# The Coq core/model/excluded figures: their values are checked by audit-docs.sh
# check_public_counts, so here they only count as covered.
QED = claim(r"\b\d{1,3}(?:,\d{3})* (?:core|model|excluded) Qed\b")
ABORT = claim(r"(\d+) (?:active )?`?Abort`?(?! sites? (?:were|are) (?:gone|closed))")


def r_stale(line, t):
    """Statements B12 found contradicting PROOF_STATUS.md / llms.txt."""
    for mm in ABORT.finditer(line):
        if int(mm.group(1)) != 0:
            yield f"{mm.group(1)} Abort sites, but the active build has none (PROOF_STATUS.md)"
    if re.search(r"Isabelle[^.|]*\bcompiles\b", line):
        yield "Isabelle is retired (REQ-67g); it does not 'compile' as a lane"


NUMBER_WORDS = {w: i for i, w in enumerate(
    "zero one two three four five six seven eight nine ten eleven twelve".split())}


def word_num(w):
    return int(w) if w.isdigit() else NUMBER_WORDS.get(w.lower())


BRIDGE = claim(r"\b(\w+) such differential links")
CAPSTONES = claim(r"\b(\w+) capstone theorems are kernel-attested\b")
STEP_RULES = claim(r"\b(\d+) step rules\b")


def r_bridge_links(line, t):
    for w in BRIDGE.findall(line):
        n = word_num(w)
        if n is not None and n != t["bridge_links"]:
            yield (f"{w} differential links, but riina-core has {t['bridge_links']} "
                   "*_matches_coq_model tests")
    for w in CAPSTONES.findall(line):
        n = word_num(w)
        if n is not None and t.get("axiom_free_capstones") is not None and n != t["axiom_free_capstones"]:
            yield f"{w} closed capstones, but verify.rs AXIOM_FREE_CAPSTONES has {t['axiom_free_capstones']}"
    for n in STEP_RULES.findall(line):
        if t.get("step_rules") is not None and int(n) != t["step_rules"]:
            yield f"{n} step rules, but Semantics.v `step` has {t['step_rules']}"


LEAN = claim(r"\bLean theorems \| (\d+)|\bLean 4: (\d+) theorem")
ISABELLE = claim(r"\bIsabelle lemmas \| (\d+)")
FSTAR = claim(r"\b(\d+) trivial lemmas\b")
TLA = claim(r"\b(\d+) (?:TLC-checked theorems|THEOREMs)\b")
ALLOY = claim(r"\b(\d+) (?:bounded-checked )?assertions\b")
SMOKE = claim(r"\b(\d+) (?:hand-written |TLC-checked |Alloy )?smoke (?:spec|module|model)s?\b")
VACUITY = claim(r"\b(\d[\d,]*) vacuity (?:patterns|findings)\b")


def r_lanes(line, t):
    for key, rx, what in (("lean_theorems", LEAN, "Lean theorems"),
                          ("isabelle_lemmas", ISABELLE, "Isabelle lemmas"),
                          ("fstar_lemmas", FSTAR, "F* smoke lemmas"),
                          ("tla_theorems", TLA, "TLA+ smoke theorems"),
                          ("vacuity", VACUITY, "vacuity findings")):
        for mm in rx.finditer(line):
            if t.get(key) is not None and num(first(mm)) != t[key]:
                yield f"{first(mm)} {what} (metrics.json: {t[key]})"
    if "alloy" in line.lower():
        for n in ALLOY.findall(line):
            if t.get("alloy_assertions") is not None and int(n) != t["alloy_assertions"]:
                yield f"{n} Alloy assertions (metrics.json: {t['alloy_assertions']})"
    for n in SMOKE.findall(line):
        if int(n) != 1:
            yield f"{n} smoke specs: each smoke lane has exactly one (metrics.json smokeSpec/smokeModule)"


# Totals only: STDLIB.md's per-backend counts ("(21 builtins)") are generated.
BUILTINS = claim(r"\b(\d+) (?:registered builtins|built-in functions|builtins across)\b"
                 r"|\bStandard library builtins \| (\d+)")
BUILTINS_COMPILED = claim(r"\b(\d+) (?:of them )?compile\b")
KEYWORDS = claim(r"\b(\d+)(\+?) (?:bilingual )?keywords\b")
TYPES = claim(r"\b(\d+) types\b")
EFFECTS = claim(r"\b(\d+) effects\b")
SEC_LEVELS = claim(r"\b(\d+) security levels\b")
COMMANDS = claim(r"\b(\d+) (?:sub)?commands\b")
TARGETS = claim(r"\bTarget platforms \| (\d+)")


def r_compiler_tables(line, t):
    for mm in BUILTINS.finditer(line):
        if t.get("builtins") is not None and int(first(mm)) != t["builtins"]:
            yield f"{first(mm)} builtins (docs/api/STDLIB.md registers {t['builtins']})"
    if "builtin" in line.lower():
        for n in BUILTINS_COMPILED.findall(line):
            if t.get("builtins_compiled") is not None and int(n) != t["builtins_compiled"]:
                yield f"{n} builtins compile (docs/api/STDLIB.md: {t['builtins_compiled']})"
    for n, plus in KEYWORDS.findall(line):
        if plus or int(n) != t["keywords"]:
            yield f"{n}{plus} keywords (the lexer has {t['keywords']}; write the exact count)"
    low = line.lower()
    for n in TYPES.findall(line):
        if ("riina-types" in low or "type system" in low) and int(n) != t["types"]:
            yield f"{n} types (riina-types `Ty` has {t['types']} variants)"
    for key, rx, what in (("effects", EFFECTS, "effects (riina-types `Effect`)"),
                          ("security_levels", SEC_LEVELS, "security levels (riina-types `SecurityLevel`)"),
                          ("commands", COMMANDS, "commands (riinac's usage text)"),
                          ("target_families", TARGETS, "target platforms (riinac --target)")):
        for mm in rx.finditer(line):
            if t.get(key) is not None and int(first(mm)) != t[key]:
                yield f"{first(mm)} {what}: the source has {t[key]}"


INDUSTRY = claim(r"\b(\d+) industry compliance specifications\b")
SNIPPETS = claim(r"\b(\d+) code snippets\b")
PAGES = claim(r"\b(\d+)-page (?:site|Vite/React website)\b")
SECTORS = claim(r"\b(\d+) industry (?:verticals|sectors)\b")
STEPS = claim(r"\b(\d+) (?:mandatory )?steps\b")
VERIFY_LEVELS = claim(r"\(manual, (\d+) levels\)")
DEPS = claim(r"\*{0,2}(\d+)\*{0,2} third-party\b")
TOOLING_DEPS = claim(r"\bthe tooling SBOM lists (\d+)\b")


def r_repo_counts(line, t):
    for key, rx, what in (("industry_specs", INDUSTRY, "04_SPECS/industries/IND_*.md files"),
                          ("snippets", SNIPPETS, "VS Code snippets"),
                          ("site_pages", PAGES, "website pages (page === renders)"),
                          ("site_sectors", SECTORS, "website SECTORS entries"),
                          ("protocol_steps", STEPS, "steps in master plan Part 8"),
                          ("verify_levels", VERIFY_LEVELS, "levels in 05_TOOLING/scripts/verify.sh")):
        for n in rx.findall(line):
            if t.get(key) is not None and int(n) != t[key]:
                yield f"{n}, but there are {t[key]} {what}"
    sb = t.get("sbom_third_party") or {}
    for n in DEPS.findall(line):
        if "proto" in sb and int(n) != sb["proto"]:
            yield f"{n} third-party dependencies, but sbom/riina-proto.cdx.json lists {sb['proto']}"
    for n in TOOLING_DEPS.findall(line):
        if "tooling" in sb and int(n) != sb["tooling"]:
            yield f"tooling SBOM lists {n}, but sbom/riina-tooling.cdx.json has {sb['tooling']}"


# docs/spec/CORE_MAPPING.md states effect and security-level numbers for both
# sides of the Rust-Coq mapping.
EFF_RUST = claim(r"`(\w+)` \((\d+)\)")
EFF_BOTH = claim(r"`(\w+)` is (\d+) in Rust and (\d+) in Coq|`(\w+)` is (\d+) against (\d+)"
                 r"|`(\w+)` \((\d+) against (\d+)\)")
SEC_ROW = claim(r"`SecurityLevel::(\w+)` \| `(\w+)` \| \w+ \| (?:level )?(\d+)")


def r_core_mapping(line, t):
    if "rust_effect_level" not in t:
        return
    rust, coq = t["rust_effect_level"], t["coq_effect_level"]

    def coq_of(name):
        return coq.get("Eff" + name, coq.get({"NetworkSecure": "EffNetSecure"}.get(name, "")))

    if "level" in line.lower() or "inserts" in line:
        for name, n in EFF_RUST.findall(line):
            if name in rust and int(n) != rust[name]:
                yield f"`{name}` ({n}): Effect::level() gives {rust[name]}"
    for mm in EFF_BOTH.finditer(line):
        g = [x for x in mm.groups() if x is not None]
        name, r, c = g[0], int(g[1]), int(g[2])
        if name in rust and (r != rust[name] or c != coq_of(name)):
            yield f"`{name}` is {rust[name]} in Rust and {coq_of(name)} in Coq, not {r} and {c}"
    for name, coq_name, n in SEC_ROW.findall(line):
        want_r, want_c = t["rust_sec_level"].get(name), t["coq_sec_level"].get(coq_name)
        if int(n) != want_r or int(n) != want_c:
            yield f"SecurityLevel::{name} is {want_r} in Rust and {want_c} in Coq, not {n}"


# Claim levels (mandate §2).
# A level as data (`status: 'X'`) or as a legend entry (`>X</span> = …`).
LEVEL_LITERAL = re.compile(r"\b(?:status|level): '([A-Za-z_-]+)'|>([A-Z][A-Z_-]{3,})</span> =")
LEVEL_PROSE = re.compile(r"\b[Cc]laim(?: level)?(?::| is)? `([A-Za-z_-]+)`|\bClaim: ([a-z_]+)\b")
NEAR_LEVEL = re.compile(r"\b(?:PROVEN|ENFORCED)-[A-Z]+\b")
IMPL_WORDING = re.compile(r"\bprov(?:en|ed) (?:for|about|on) the shipped (?:compiler|riinac|binary)\b", re.I)


def r_claim_level(line, t):
    lanes = set(t.get("claim_levels", {}).get("legend") or [])
    for mm in LEVEL_LITERAL.finditer(line):
        lv = first(mm)
        if lv not in LEVELS:
            yield f"claim level '{lv}' is not a §2 level ({', '.join(LEVELS)})"
    for mm in LEVEL_PROSE.finditer(line):
        lv = first(mm)
        if lv.upper() not in LEVELS and lv not in lanes:
            yield f"claim level '{lv}' is neither a §2 level nor a metrics.json lane level"
    for lv in NEAR_LEVEL.findall(line):
        if lv not in LEVELS:
            yield f"'{lv}' looks like a §2 level but is not one"
    if IMPL_WORDING.search(line) and not t.get("ledger_impl") \
            and not re.search(r"\bnot\b|\bnone\b|\bno\b|until|neither|\bnor\b", line, re.I):
        yield "PROVEN-IMPL wording, but no property in PROPERTY_LEDGER.md is PROVEN-IMPL"


LINE_RULES = [r_test_count, r_parameters, r_crates, r_examples, r_rocq, r_rust_toolchain, r_smt,
              r_compliance, r_axiom_caveat, r_admitted, r_constant_time, r_risky, r_coq_files,
              r_stale, r_bridge_links, r_lanes, r_compiler_tables, r_repo_counts, r_core_mapping,
              r_claim_level]


def check_claim_levels(t):
    """Every lane level metrics.json publishes is in its legend, and every
    legend value maps onto a §2 level in generate-ledgers.py CLAIM_LEVEL_MAP
    (the map PROPERTY_LEDGER.md prints)."""
    out = []
    cl = t.get("claim_levels") or {}
    legend = cl.get("legend") or []
    rows = t.get("claim_level_map") or []
    for lane, lv in sorted(cl.items()):
        if lane in ("legend", "independentlyAudited"):
            continue
        if lv not in legend:
            out.append(f"metrics.json claimLevels.{lane} = {lv!r} is not in claimLevels.legend")
        if lv == "mechanized" and lane != "overall" and not any(
                src.startswith("mechanized (") and src[12:].lower().startswith(lane) for src, _ in rows):
            out.append(f"claimLevels.{lane} is mechanized, but CLAIM_LEVEL_MAP has no "
                       f"'mechanized ({lane} …)' row mapping it onto a §2 level")
    for lv in legend:
        if not any(src.split(" (")[0] == lv for src, _ in rows):
            out.append(f"lane level {lv!r} has no row in generate-ledgers.py CLAIM_LEVEL_MAP")
    for src, dst in rows:
        if dst not in LEVELS and not dst.startswith("none"):
            out.append(f"CLAIM_LEVEL_MAP maps {src!r} to {dst!r}, which is not a §2 level")
    return out


# --------------------------------------------------------------------------
# The inventory: every number must be checked by a rule above or exempted
# here, with the reason it is not a metric.
# --------------------------------------------------------------------------
# A dotted version ("9.1.1", "v3.1") must sit inside a version rule or an exemption.
VERSION_TOKEN = re.compile(r"(?<![\w.\-/§])v?\d+\.\d+(?:\.\d+)*(?![\w.]|\.\d)")
TOKEN = re.compile(r"(?<![\w.§/#@$\-−–×^:,{])[~≈]?\d(?:[\d,]*\d)?(?:\.\d+)?(?:[-–]\d+)?%?\+?"
                   r"(?:K|M|MB|GB|KB|KiB|MiB)?(?![\w]|[.:/,-]\d)")
EXEMPT = [(re.compile(p, f), why) for p, f, why in [
    (r"`[^`\n]*`", 0, "inline code: a literal in a program or command"),
    (r"^\s*(?:#+\s*|[-*]\s+)?\d+\.\s", 0, "list or section numbering"),
    (r"^\|\s*\d+\s*\|", 0, "a table's ordinal column"),
    (r"\b(?:Part|Parts|Phase|Phases|Gate|Wave|STEP|Tier|section|Section|Chapter|Art\.|Article|Annex)"
     r"\s?\d+(?:\(\d+\))*(?:\s?(?:through|to|and|[-–])\s?\d+)?", 0,
     "a reference to a numbered part, phase or clause"),
    (r"§\s?\d+(?:\.\d+)*", 0, "a section reference"),
    (r"\b\d+(?:\.\d+)?:\d+", 0, "a ratio"),
    (r'"(?:version|vscode|@types/[\w-]+|typescript)": "\^?\d+(?:\.\d+)+"', 0,
     "the VS Code extension's own version and its dependency ranges"),
    (r"\b(?:RFC|FIPS|NIST(?: SP| IR)?|IR|ISO|IEC|EAL|DAL|ASIL|CVSS|WCAG)\s?v?\d+(?:[-–/.]\d+)*", 0,
     "a standard or clause identifier"),
    (r"\b\d+ CFR(?: Part)? \d+", 0, "a CFR citation"),
    (r"\b(?:19|20)\d{2}-current\b|\b\d+(?:\.\d+)+-current\b", 0, "a regulation's edition"),
    (r"\bLean 4\b|\bAlloy 6\b", 0, "a product name"),
    (r"~?\d+(?:[-–]\d+)?\s?(?:minutes?|hours?|h|days?|d|weeks?|months?|years?|seconds?)\b", re.I,
     "a duration or deadline"),
    (r"\b\d+-(?:minute|hour|day|week|month|year)\b", 0, "a duration"),
    (r"\b\d{1,2} (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]* \d{4}\b"
     r"|\b(?:January|February|March|April|May|June|July|August|September|October|November|December) \d{4}\b",
     0, "a date"),
    (r"(?:©|&copy;|\(c\)) \d{4}", re.I, "a copyright year"),
    (r"\b\d+ \+ \d+ (?:=|equal) \d+", 0, "an arithmetic example"),
    (r"\blast \d+ digits\b", 0, "an illustration"),
    (r"\bcount \d+ to \d+\b", 0, "a program's expected output"),
    (r"\b\d+-bit\b", 0, "a bit width"),
    (r"\bat most 255\b", 0, "the u8 range"),
    (r"\b2\.5%", 0, "the zakat rate, a language constant"),
    (r"\b\d+ spaces\b", 0, "a style rule"),
    (r"Rules checked: \d+\s+Violations: \d+|Coverage: \d+/\d+ rules \([\d.]+%\)", 0,
     "a verbatim `riinac check --compliance hipaa --report` sample"),
    # JavaScript, HTML and CSS in the website sources.
    (r"^\s*(?://|/\*|\*).*", 0, "a source comment, not rendered"),
    (r"\b[A-Za-z]+: -?\d[\d.]*\b", 0, "a numeric style or object property"),
    (r"'[^'\n]*\d(?:px|vw|vh|em|rem|fr)\b[^'\n]*'", 0, "a CSS value"),
    (r"rgba?\([^)]*\)", 0, "a colour"),
    (r"'-?[\d.]+%'", 0, "a CSS percentage"),
    (r'\b[\w:-]+="-?[\d.]+%?"', 0, "a numeric HTML or SVG attribute"),
    (r"\bnum: '\d+'", 0, "an ordinal label"),
    (r"GF\(2\^\d+[−-]\d+\)", 0, "a field definition"),
    (r"\|\| -?\d+|[!=]==? -?\d+|\? -?\d+ : -?\d+|\.length [<>=]+ \d+", 0, "JavaScript code"),
    (r"\b(?:size|width|height) = \{?\d+\}?|viewBox=\"[^\"]*\"|setTimeout\(.*\)", 0, "JavaScript code"),
    (r"<K>.*", 0, "a RIINA code sample"),
    (r'href="https://fonts[^"]*"|content="width=device-width[^"]*"', 0, "an HTML attribute"),
    (r"[a-z-]+:\s*-?[\d.]+(?:px|em|rem|%)?(?=;|\s*\})", 0, "CSS"),
]]


def units(rel, text):
    """[(line, text)]: the sentences of the prose, and each table row, heading
    and code line on its own. Fenced code is left out, and so are the
    release-history blocks."""
    out, block, start, fence, hist = [], [], 0, False, False
    lines = text.splitlines()
    md = not rel.endswith((".jsx", ".html", ".json"))

    def flush():
        nonlocal block
        if block:
            joined = " ".join(s.strip() for s in block)
            # Split sentences, but not after an abbreviation or a clause mark.
            pieces = re.split(r"(?<!\be\.g)(?<!\bi\.e)(?<!\bArt)(?<!\bvs)(?<!\bcf)(?<!^\d\.)(?<!^\d\d\.)"
                              r"(?<=[.!?])\s+(?=[A-Z*`(\[])",
                              joined)
            for p in pieces:
                out.append((start, p))
        block = []

    for i, line in enumerate(lines, 1):
        if any(s.search(line) for s, _ in HISTORY_BLOCKS):
            hist = True
        if hist:
            if any(e.search(line) for _, e in HISTORY_BLOCKS):
                hist = False
            continue
        if not md:
            out.append((i, line))
            continue
        if line.lstrip().startswith("```"):
            flush()
            fence = not fence
            continue
        if fence:
            continue
        s = line.strip()
        if not s:
            flush()
            continue
        if s.startswith(("|", "#", "<", "├", "│", "└")) or re.match(r"^(?:[-*>]|\d+\.)\s", s):
            flush()
            if s.startswith(("|", "#", "├", "│", "└")):
                out.append((i, line))
                continue
        if not block:
            start = i
        block.append(line)
    flush()
    return out


def inventory(rel, text):
    out = []
    for i, unit in units(rel, text):
        if HISTORICAL.search(unit):
            continue
        covered = []
        for rx in CLAIMS:
            covered += [m.span() for m in rx.finditer(unit)]
        for rx, _ in EXEMPT:
            covered += [m.span() for m in rx.finditer(unit)]
        for tok in list(TOKEN.finditer(unit)) + list(VERSION_TOKEN.finditer(unit)):
            a, b = tok.span()
            if not any(s <= a and b <= e for s, e in covered):
                ctx = unit[max(0, a - 40):b + 40].strip()
                out.append(f"{rel}:{i}: `{tok.group(0)}` is checked by no rule and matches no EXEMPT "
                           f"pattern — derive it in check-doc-drift.sh or say why it is not a metric: …{ctx}…")
    return out


def inventory_sources():
    """(rel, text) for each file the inventory reads."""
    out = []
    for rel in SURFACES:
        if rel in NOT_INVENTORIED or rel in AGENT_FILES or not os.path.exists(path(rel)):
            continue
        out.append((rel, read(rel)))
    tdir = path(AGENT_TEMPLATES)
    if os.path.isdir(tdir):
        for f in sorted(os.listdir(tdir)):
            if f.endswith(".tmpl") or (f.startswith("_") and f.endswith(".md")):
                rel = f"{AGENT_TEMPLATES}/{f}"
                out.append((rel, read(rel)))
    return out


def check_text(rel, text, t):
    out = []
    for i, unit in units(rel, text):
        if HISTORICAL.search(unit):
            continue
        for rule in LINE_RULES:
            for p in rule(unit, t):
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


def check_metrics_status(status, manifest, public_tree=False):
    """metrics.json `status` is derived from the riinac verify manifest, never
    hand-typed (it once carried "grade": "A" and "threats": "1231+")."""
    out = []
    allowed = {"build", "verifiedCommit", "verifiedMode", "source"}
    for k in sorted(set(status) - allowed):
        out.append(f"metrics.json status.{k} is not measured by anything; remove it")
    if status.get("build") not in ("passing", "failing", "unverified"):
        out.append(f"metrics.json status.build {status.get('build')!r} is not passing/failing/unverified")
    if not manifest.get("Git SHA"):
        if not public_tree:
            out.append("VERIFICATION_MANIFEST.md is missing; status.build cannot be checked")
        return out
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
    problems += check_metrics_status(t["status"], t["manifest"], t["public_tree"])
    problems += check_claim_levels(t)
    problems += check_legacy_plans()
    for f in LEDGERS:
        if not os.path.exists(path(f)):
            problems.append(f"{f} is missing (run python3 scripts/generate-ledgers.py)")
    problems += check_ledger_links(read("README.md"), read("website/src/RiinaWebsite.jsx"))
    problems += check_compiler_honesty(read("README.md"), read("website/src/RiinaWebsite.jsx"))
    if t["profiles"] is None:
        problems.append("metrics.json has no compliance block (run scripts/generate-metrics.sh)")
    for rel in SURFACES:
        if os.path.exists(path(rel)):
            problems += check_text(rel, read(rel), t)
    banner = next((l for l in read("CHANGELOG.md").splitlines() if l.startswith("**Verification:**")), "")
    problems += check_text("CHANGELOG.md (banner)", banner, t)
    for rel, text in inventory_sources():
        problems += inventory(rel, text)
    problems += inventory("CHANGELOG.md (banner)", banner)
    return problems


def self_test(t):
    """Every rule must flag a seeded fault, and leave a correct line alone."""
    t = dict(t, rust_tests=3564, parameters=29, crates=18, examples=172, corpus_passing=84,
             rocq="9.1.1", smt=37, smt_parts={"security lattice": 25, "effect join": 12},
             profiles=19, rules=606, per_profile={"hipaa": 33},
             coq_files_active=334, coq_files_total=375, coq_domains=252, bridge_links=9,
             admitted=0, axioms=0, lean_theorems=0, isabelle_lemmas=0, fstar_lemmas=3,
             tla_theorems=5, alloy_assertions=6, vacuity=1318, builtins=374, builtins_compiled=342,
             keywords=132, types=45, effects=19, security_levels=6, commands=15, target_families=4,
             industry_specs=15, snippets=12, site_pages=7, site_sectors=9, protocol_steps=8,
             verify_levels=7, z3="4.8.12", sbom_third_party={"proto": 0, "tooling": 122}, example_dirs=20,
             axiom_free_capstones=9, step_rules=40, emit_core_passing=0, rust_version="1.94.1", ledger_impl=False,
             claim_levels={"legend": ["generated", "mechanized"]},
             file_qed=lambda name: 109 if name == "VerifiedFileSystem.v" else None,
             rust_effect_level={"Mut": 1, "Alloc": 3, "Read": 2, "Write": 4, "Gapura": 18},
             coq_effect_level={"EffRead": 1, "EffWrite": 2, "EffGapura": 16},
             rust_sec_level={"Public": 0, "Internal": 1}, coq_sec_level={"LPublic": 0, "LInternal": 1})
    seeded = {
        "3,560 tests pass": r_test_count, "| 3623 Rust tests |": r_test_count,
        "| Rust tests | 3,560 (compiler workspace) |": r_test_count,
        "29 `Parameter`s ok / 30 Parameters": r_parameters,
        "Rust compiler (19 crates)": r_crates, "| Compiler crates | 17 |": r_crates,
        "171 example programs": r_examples, "83 pass `riinac check`": r_examples,
        "**84 of the 171 examples pass": r_examples, "| Example programs | 170 (84 pass) |": r_examples,
        "across 21 category directories": r_examples, "1 of the 84 checked examples emit": r_examples,
        "0 of the 83 checked examples emit": r_examples,
        "Rocq 9.2.1 build": r_rocq, "Rocq 9.2 — only for proof work": r_rocq,
        "a Rust toolchain (1.80+)": r_rust_toolchain, "- **Rust** 1.93.0+": r_rust_toolchain,
        "by verify-smt.sh (Z3 4.8.11)": r_rust_toolchain,
        "SMT: 36 properties": r_smt, "a scoped SMT set of 36 Z3-checked properties": r_smt,
        "SMT: security lattice 24, effect join 12": r_smt,
        "19 profiles across 605 machine-checkable rules": r_compliance,
        "hipaa profile (54 rules)": r_compliance, "15 profile names": r_compliance,
        "| Compliance profiles | 15 (3 with checks) |": r_compliance,
        "19 profiles with 600 heuristic rules": r_compliance, "List the 18 available profiles": r_compliance,
        "0 Admitted, 0 axioms": r_axiom_caveat, "1 `Axiom`, 29 `Parameter`s": r_axiom_caveat,
        "1 Admitted remains": r_admitted, "| Incomplete proofs (Admitted) | 2 |": r_admitted,
        "constant time is proven": r_constant_time,
        "A formally verified programming language": r_risky,
        "Security properties, proven before the code runs": r_risky,
        "ten prover lanes": r_risky,
        "Each program ships with a proof certificate": r_risky,
        "It can replace manual code review": r_risky,
        "Backed by Coq formal proofs.": r_risky,
        "declare kesan SyariahPatuh": r_risky, "1,231+ threats modelled": r_risky,
        "Coq files: 317 (277 active)": r_coq_files, "333 active Coq files": r_coq_files,
        "| Active proof files | 333 |": r_coq_files, "374 Coq proof files": r_coq_files,
        "251 domain-specific model files": r_coq_files,
        "`domains/VerifiedFileSystem.v` (108 Qed: …)": r_coq_files,
        "4 active Abort sites remain (REQ-21)": r_stale,
        "the Isabelle smoke theory compiles": r_stale,
        "One of eight such differential links": r_bridge_links,
        "Eight capstone theorems are kernel-attested closed": r_bridge_links,
        "proven over all 39 step rules": r_bridge_links,
        "| Lean theorems | 3 — archived": r_lanes, "1 smoke module with 4 trivial lemmas": r_lanes,
        "(5 TLC-checked theorems; 7 bounded-checked assertions in Alloy)": r_lanes,
        "2 hand-written smoke specs": r_lanes, "flags 1,300 vacuity patterns": r_lanes,
        "88 builtins across 9 modules": r_compiler_tables, "| Standard library builtins | 88 |": r_compiler_tables,
        "70+ bilingual keywords": r_compiler_tables, "riina-types: 22 types": r_compiler_tables,
        "17 effects, 6 security levels": r_compiler_tables, "Compiler driver (11 subcommands)": r_compiler_tables,
        "| Target platforms | 5 (native …) |": r_compiler_tables,
        "374 builtins, of which 300 compile": r_compiler_tables,
        "16 industry compliance specifications": r_repo_counts, "11 code snippets": r_repo_counts,
        "15-page site": r_repo_counts, "15 industry verticals": r_repo_counts,
        "Part 8 (7 mandatory steps)": r_repo_counts, "(manual, 6 levels)": r_repo_counts,
        "**1** third-party at runtime": r_repo_counts, "the tooling SBOM lists 100": r_repo_counts,
        "inserts `Mut` (2) and `Alloc` (3).": r_core_mapping,
        "So `Read` is 2 in Rust and 2 in Coq,": r_core_mapping,
        "up to `Gapura` (18 against 15).": r_core_mapping,
        "| `SecurityLevel::Internal` | `LInternal` | core | 2 |": r_core_mapping,
        "status: 'CHECKER'": r_claim_level, "<span>CHECKER</span> = tested rules": r_claim_level, "Claim level `verified` until wired": r_claim_level,
        "a PROVEN-COMPILER property": r_claim_level,
        "type safety is proven for the shipped compiler": r_claim_level,
    }
    clean = {
        "3,564 tests pass": r_test_count, "| 3564 Rust tests |": r_test_count,
        "29 `Parameter`s (trusted interface)": r_parameters,
        "Rust compiler (18 crates)": r_crates, "172 example programs; 84 pass `riinac check`": r_examples,
        "**84 of the 172 examples pass": r_examples, "across 20 category directories": r_examples,
        "0 of the 84 checked examples emit": r_examples,
        "Rocq 9.1.1": r_rocq, "a Rust toolchain (1.94+)": r_rust_toolchain,
        "- **Rust** 1.94.1+, Z3 4.8.12": r_rust_toolchain,
        "SMT scoped set: 37 properties (security lattice 25, effect join 12)": r_smt,
        "19 profiles across 606 machine-checkable rules; hipaa profile (33 rules)": r_compliance,
        "| Compliance profiles | 19 (606 heuristic rules) |": r_compliance,
        "0 `Axiom`, 29 `Parameter`s": r_axiom_caveat, "`Axiom = 0` and 29 Parameters": r_axiom_caveat,
        "0 Admitted": r_admitted, "compiles 335 files, 0 errors": r_admitted,
        "reduction-count independence (the constant-time theorem, reduction model)": r_constant_time,
        "Programming language with a Coq-verified core model": r_risky,
        "RIINA does not issue a proof certificate": r_risky,
        "Not a replacement for code review.": r_risky,
        "334 active files; 334 active Coq modules; 334 active proof files": r_coq_files,
        "375 Coq proof files (334 active)": r_coq_files,
        "`domains/VerifiedFileSystem.v` (109 Qed: …)": r_coq_files,
        "0 Admitted, 0 Abort, 0 `Axiom`": r_stale,
        "One of nine such differential links": r_bridge_links,
        "Nine capstone theorems are kernel-attested closed": r_bridge_links,
        "| Lean theorems | 0 — archived": r_lanes,
        "1 hand-written smoke spec each (5 TLC-checked theorems; 6 bounded-checked assertions), Alloy": r_lanes,
        "374 registered builtins, of which 342 compile": r_compiler_tables,
        "132 keywords": r_compiler_tables, "riina-types (45 types, 19 effects, 6 security levels)": r_compiler_tables,
        "15 commands": r_compiler_tables,
        "15 industry compliance specifications; 12 code snippets; 7-page site; 9 industry sectors": r_repo_counts,
        "Part 8 (8 mandatory steps)": r_repo_counts, "**0** third-party at runtime": r_repo_counts,
        "inserts `Mut` (1) and `Alloc` (3).": r_core_mapping,
        "So `Read` is 2 in Rust and 1 in Coq, `Write` is 4 against 2,": r_core_mapping,
        "| `SecurityLevel::Public` | `LPublic` | core | level 0 on both sides |": r_core_mapping,
        "status: 'MODELLED'": r_claim_level, "status: 'ENFORCED-TESTED'": r_claim_level,
        "Claim level `generated` until wired": r_claim_level,
        "none is yet proven about the shipped compiler": r_claim_level,
    }
    failures = []
    for text, rule in seeded.items():
        if not list(rule(text, t)):
            failures.append(f"{rule.__name__} missed the seeded fault: {text!r}")
    for text, rule in clean.items():
        hits = list(rule(text, t))
        if hits:
            failures.append(f"{rule.__name__} flagged a correct line {text!r}: {hits}")
    if check_text("x.md", "historical: 3,000 tests and 0 axioms", t):
        failures.append("historical sentences must be exempt")
    if check_text("x.md", "Until 2026-10-20 there were 3,000 tests. Now: 3,564 tests.", t):
        failures.append("a history sentence must be exempt without exempting its neighbour")
    if not check_text("x.md", "There are\n3,000 tests.", t):
        failures.append("a claim wrapped across two lines must still be checked")
    # The inventory: an unchecked number fails, an exempt or checked one does not.
    if not inventory("x.md", "The compiler has 42 optimisation passes."):
        failures.append("inventory accepted an unchecked number")
    if not inventory("x.md", "Docker image, ~85MB."):
        failures.append("inventory accepted a size with a unit")
    if not inventory("x.md", "Requires LLVM 17.0.6 to build."):
        failures.append("inventory accepted an unchecked version")
    if inventory("x.md", "Build it (~3 minutes). See Part 8 and RFC 7748; `x > 0`.\n\n1. Step one."):
        failures.append("inventory flagged durations, references, code or list numbering")
    if inventory("x.md", "There are 3,564 tests and 29 `Parameter`s."):
        failures.append("inventory flagged numbers a rule checks")
    if inventory("x.md", "```\nlet x = 5;\n```\nUntil 2026-10-20 there were 12 files."):
        failures.append("inventory flagged fenced code or a history sentence")
    if inventory("x.jsx", "const RELEASES = [\n  { text: '88 builtins' },\n];"):
        failures.append("inventory flagged the release-history block")
    # Lane levels map onto §2.
    good = dict(t, claim_levels={"legend": ["generated", "mechanized"], "coq": "mechanized",
                                 "overall": "generated"},
                claim_level_map=[("mechanized (Coq)", "PROVEN-MODEL"), ("generated", "GENERATED")])
    if check_claim_levels(good):
        failures.append(f"check_claim_levels flagged a mapped legend: {check_claim_levels(good)}")
    if not check_claim_levels(dict(good, claim_levels=dict(good["claim_levels"], lean="mechanized"))):
        failures.append("check_claim_levels missed a mechanized lane with no map row")
    if not check_claim_levels(dict(good, claim_level_map=good["claim_level_map"] + [("x", "VERIFIED")])):
        failures.append("check_claim_levels missed a map row onto a non-§2 level")
    if not check_claim_levels(dict(good, claim_levels=dict(good["claim_levels"], tv="compiled"))):
        failures.append("check_claim_levels missed a lane level outside the legend")
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
    if not check_metrics_status(good, {}, public_tree=False):
        failures.append("check_metrics_status accepted a missing manifest on a tree with the plan")
    if check_metrics_status(good, {}, public_tree=True):
        failures.append("check_metrics_status flagged the public tree, which has no manifest")
    if not check_metrics_status(dict(good, build="green"), {}, public_tree=True):
        failures.append("check_metrics_status accepted an unknown build status")
    said = "Unlike CompCert or CakeML, the compiler `riinac` is not itself formally verified."
    said_js = "Unlike CompCert or CakeML, <span>riinac</span>\n itself is not formally verified."
    if check_compiler_honesty(said, said_js):
        failures.append("check_compiler_honesty flagged the S1.13 sentence")
    if len(check_compiler_honesty(said, "riinac is a compiler.")) != 1:
        failures.append("check_compiler_honesty missed a website without the S1.13 sentence")
    if check_ledger_links(all_md, all_js):
        failures.append("check_ledger_links flagged complete link lists")
    if len(check_ledger_links(all_md.replace("(TRUSTED_BASE.md)", ""), all_js)) != 1:
        failures.append("check_ledger_links missed a README without the TRUSTED_BASE.md link")
    return failures


truth = load_truth()
truth["file_qed"] = coq_file_qed
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
print(f"No doc drift across {len(SURFACES)} surfaces (version {truth['version']}); "
      f"every number is checked or exempt.")
PY
