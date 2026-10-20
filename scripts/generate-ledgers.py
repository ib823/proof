#!/usr/bin/env python3
"""generate-ledgers.py — HEADLINE_THEOREMS.md, PROPERTY_LEDGER.md, TRUSTED_BASE.md.

REQ-103 (mandate S2.4, S2.9, S2.10, S1.11, §2). The three ledgers at the
repository root are generated, never hand-edited:

  HEADLINE_THEOREMS.md   from 04_SPECS/ledgers/headline_theorems.toml, the
                         KERNEL_CAPSTONES list in riinac's verify.rs, the Coq
                         sources (file and line) and captured Print Assumptions
  PROPERTY_LEDGER.md     from 04_SPECS/ledgers/properties.toml
  TRUSTED_BASE.md        from the repository and the capture

Facts that need tools (Print Assumptions, tool versions, the size of the
emitted C prelude, code sizes) are measured by `--capture` where the Coq build
exists, and stored in reports/ledger_capture.json with the commit they were
measured at. `--check` needs no Coq: it fails when a generated file differs
from what the sources produce, when the capture is stale for the Coq files it
covers, when the registry and KERNEL_CAPSTONES disagree, or when a named
witness or test path does not exist.

Usage:
  python3 scripts/generate-ledgers.py             # regenerate the three files
  python3 scripts/generate-ledgers.py --check     # fail on drift (CI)
  python3 scripts/generate-ledgers.py --capture   # re-measure (needs rocq + built .vo)
  python3 scripts/generate-ledgers.py --list-parameters   # active Parameter sites
"""

import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
import tomllib

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
COQ = os.path.join(ROOT, "02_FORMAL", "coq")
CAPTURE = os.path.join(ROOT, "reports", "ledger_capture.json")
OUTPUTS = ("HEADLINE_THEOREMS.md", "PROPERTY_LEDGER.md", "TRUSTED_BASE.md")
LEVELS = ("PROVEN-IMPL", "PROVEN-MODEL", "ENFORCED-TESTED", "MODELLED", "GENERATED", "RETIRED", "PLANNED")
THEOREM_FIELDS = ("name", "module", "statement", "fragment", "public_claim", "positive_witness",
                  "negative_witness", "reviewer", "review_date", "status")
PROPERTY_FIELDS = ("id", "property", "level", "fragment", "theorem", "tests", "command")
# metrics.json claimLevels values, mapped onto the mandate's §2 vocabulary.
CLAIM_LEVEL_MAP = [
    ("mechanized (Coq)", "PROVEN-MODEL"),
    ("mechanized (SMT scoped set)", "MODELLED"),
    ("generated", "GENERATED"),
    ("retired", "RETIRED"),
    ("compiled", "none published today"),
    ("independently_audited", "none (false today)"),
]


def read(rel):
    with open(os.path.join(ROOT, rel), encoding="utf-8") as fh:
        return fh.read()


def die(msg):
    print(f"generate-ledgers: {msg}", file=sys.stderr)
    sys.exit(1)


# --------------------------------------------------------------------------
# Inputs
# --------------------------------------------------------------------------
def kernel_capstones():
    src = read("03_PROTO/crates/riinac/src/verify.rs")
    block = src.split("const KERNEL_CAPSTONES: &[(&str, &str)] = &[", 1)[1].split("];", 1)[0]
    return re.findall(r'\("([\w.]+)", "(\w+)"\)', block)


def active_coq_files():
    out = []
    for line in read("02_FORMAL/coq/_CoqProject").splitlines():
        e = line.strip()
        if e and not e.startswith("#") and e.endswith(".v"):
            out.append(e)
    return out


DECL = re.compile(r"^[ \t]*(?:Theorem|Lemma|Corollary|Example|Fact|Proposition)\s+([A-Za-z_][\w']*)", re.M)


def strip_comments(text):
    """Blank out Coq comments (nested, string-aware), keeping every newline so
    line numbers stay exact."""
    out, depth, i, n, in_str = [], 0, 0, len(text), False
    while i < n:
        c = text[i]
        if depth == 0 and c == '"':
            in_str = not in_str
            out.append(c)
            i += 1
        elif not in_str and text.startswith("(*", i):
            depth += 1
            out.append("  ")
            i += 2
        elif depth > 0 and text.startswith("*)", i):
            depth -= 1
            out.append("  ")
            i += 2
        else:
            out.append(c if depth == 0 or c == "\n" else " ")
            i += 1
    return "".join(out)


def coq_code(rel):
    return strip_comments(read(rel))


def active_declarations():
    names = {}
    for rel in active_coq_files():
        text = coq_code(f"02_FORMAL/coq/{rel}")
        for m in DECL.finditer(text):
            names.setdefault(m.group(1), f"02_FORMAL/coq/{rel}:{text[:m.start()].count(chr(10)) + 1}")
    return names


def theorem_location(module, name):
    rel = "02_FORMAL/coq/" + module.replace(".", "/") + ".v"
    text = coq_code(rel)
    m = re.search(rf"^[ \t]*(?:Theorem|Lemma|Corollary)\s+{re.escape(name)}\b", text, re.M)
    if not m:
        die(f"{name} not found in {rel}")
    return rel, text[:m.start()].count("\n") + 1


def parameter_sites():
    sites = []
    for rel in active_coq_files():
        for i, line in enumerate(coq_code(f"02_FORMAL/coq/{rel}").splitlines(), 1):
            m = re.match(r"[ \t]*Parameters?\s+([A-Za-z_][\w']*)", line)
            if m:
                sites.append((f"02_FORMAL/coq/{rel}:{i}", m.group(1)))
    return sites


def capture_sources_hash(capstones):
    """What the captured Print Assumptions depends on: the capstone list and
    every active Coq file (a dependency can change an assumption set)."""
    h = hashlib.sha256()
    for module, name in capstones:
        h.update(f"{module}.{name}\n".encode())
    for rel in sorted(active_coq_files()):
        h.update(rel.encode())
        h.update(read(f"02_FORMAL/coq/{rel}").encode())
    return h.hexdigest()


def load_sources():
    th = tomllib.loads(read("04_SPECS/ledgers/headline_theorems.toml"))["theorem"]
    props = tomllib.loads(read("04_SPECS/ledgers/properties.toml"))["property"]
    return th, props


# --------------------------------------------------------------------------
# Capture (needs rocq and the built Coq tree)
# --------------------------------------------------------------------------
def run(cmd, **kw):
    try:
        return subprocess.run(cmd, capture_output=True, text=True, **kw)
    except FileNotFoundError:
        return None


def first_line(cmd):
    r = run(cmd)
    if r is None or r.returncode != 0:
        return "not found"
    return (r.stdout or r.stderr).strip().splitlines()[0]


def parse_print_assumptions(text, names):
    """One block per Print Assumptions, in order: [] if closed, else axiom names."""
    blocks, cur = [], None
    for line in text.splitlines():
        if line.startswith("Closed under the global context"):
            if cur is not None:
                blocks.append(cur)
            blocks.append([])
            cur = None
        elif line.startswith("Axioms:"):
            if cur is not None:
                blocks.append(cur)
            cur = []
        elif cur is not None and line and not line[0].isspace():
            cur.append(line.split(" :", 1)[0].strip())
    if cur is not None:
        blocks.append(cur)
    if len(blocks) != len(names):
        die(f"Print Assumptions gave {len(blocks)} blocks for {len(names)} theorems")
    return {n: sorted(set(b)) for n, b in zip(names, blocks)}


def loc(paths):
    total = 0
    for p in paths:
        full = os.path.join(ROOT, p)
        files = [full] if os.path.isfile(full) else [
            os.path.join(d, f) for d, _, fs in os.walk(full) for f in fs if f.endswith(".rs")]
        for f in files:
            if os.path.basename(f) in ("tests.rs", "robustness_tests.rs"):
                continue
            with open(f, encoding="utf-8", errors="replace") as fh:
                total += sum(1 for line in fh if line.strip())
    return total


SIZE_GROUPS = {
    "frontend": ["03_PROTO/crates/riina-lexer/src", "03_PROTO/crates/riina-parser/src",
                 "03_PROTO/crates/riina-typechecker/src", "03_PROTO/crates/riina-types/src",
                 "03_PROTO/crates/riina-span/src", "03_PROTO/crates/riina-symbols/src",
                 "03_PROTO/crates/riina-arena/src"],
    "interpreter": ["03_PROTO/crates/riina-codegen/src/interp.rs", "03_PROTO/crates/riina-codegen/src/value.rs",
                    "03_PROTO/crates/riina-codegen/src/builtins"],
    "c_backend": ["03_PROTO/crates/riina-codegen/src/lower.rs", "03_PROTO/crates/riina-codegen/src/ir.rs",
                  "03_PROTO/crates/riina-codegen/src/emit.rs"],
    "wasm_backend": ["03_PROTO/crates/riina-codegen/src/wasm.rs", "03_PROTO/crates/riina-codegen/src/wasm_encode.rs"],
    "package_manager": ["03_PROTO/crates/riina-pkg/src"],
    "compliance": ["03_PROTO/crates/riina-compliance/src"],
    "crypto": ["05_TOOLING/crates/riina-core/src"],
    "driver": ["03_PROTO/crates/riinac/src"],
}


def capture():
    capstones = kernel_capstones()
    rocq = run(["rocq", "--version"])
    if rocq is None or rocq.returncode != 0:
        die("--capture needs `rocq` on PATH (eval $(opam env --switch=rocq))")
    scratch = "".join(f"From RIINA Require Import {m}.\n" for m, _ in capstones)
    scratch += "".join(f"Print Assumptions RIINA.{m}.{n}.\n" for m, n in capstones)
    with tempfile.TemporaryDirectory(prefix="riina_ledger_") as d:
        path = os.path.join(d, "ledger_capture.v")
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(scratch)
        r = run(["rocq", "compile", "-q", "-w", "-deprecated-native-compiler-option",
                 "-native-compiler", "no", "-Q", ".", "RIINA", path], cwd=COQ)
    if r is None or r.returncode != 0:
        die("rocq failed on the Print Assumptions scratch file (is the Coq tree built?):\n"
            + (r.stderr if r else ""))
    assumptions = parse_print_assumptions(r.stdout, [n for _, n in capstones])

    riinac = os.path.join(ROOT, "03_PROTO", "target", "release", "riinac")
    prelude = None
    if os.path.exists(riinac):
        with tempfile.TemporaryDirectory(prefix="riina_ledger_") as d:
            src = os.path.join(d, "kosong.rii")
            with open(src, "w", encoding="utf-8") as fh:
                fh.write("fungsi utama() -> Nombor kesan Bersih {\n    pulang 0;\n}\n")
            e = run([riinac, "emit-c", src], cwd=d)
            if e is not None and e.returncode == 0:
                out = e.stdout
                if not out.strip():
                    c_files = [f for f in os.listdir(d) if f.endswith(".c")]
                    out = open(os.path.join(d, c_files[0]), encoding="utf-8").read() if c_files else ""
                prelude = len(out.splitlines()) if out else None

    data = {
        "commit": subprocess.run(["git", "-C", ROOT, "rev-parse", "--short", "HEAD"],
                                 capture_output=True, text=True).stdout.strip(),
        "sources_sha256": capture_sources_hash(capstones),
        "print_assumptions": assumptions,
        "tools": {
            "rocq": first_line(["rocq", "--version"]),
            "rustc": first_line(["rustc", "--version"]),
            "cc": first_line(["cc", "--version"]),
            "z3": first_line(["z3", "--version"]),
            "wasmtime": first_line(["wasmtime", "--version"]),
            "host": first_line(["uname", "-srm"]),
        },
        "emitted_c_lines_minimal_program": prelude,
        "sizes_nonblank_lines": {k: loc(v) for k, v in SIZE_GROUPS.items()},
    }
    os.makedirs(os.path.dirname(CAPTURE), exist_ok=True)
    with open(CAPTURE, "w", encoding="utf-8") as fh:
        json.dump(data, fh, indent=2, sort_keys=True)
        fh.write("\n")
    print(f"Captured {len(assumptions)} theorems at {data['commit']} -> reports/ledger_capture.json")


# --------------------------------------------------------------------------
# Validation and rendering
# --------------------------------------------------------------------------
def validate(theorems, props, cap):
    problems = []
    capstones = kernel_capstones()
    want = {n for _, n in capstones}
    have = {t.get("name") for t in theorems}
    for n in sorted(want - have):
        problems.append(f"KERNEL_CAPSTONES has {n}, the registry does not")
    for n in sorted(have - want):
        problems.append(f"the registry has {n}, KERNEL_CAPSTONES does not")
    decls = active_declarations()
    for t in theorems:
        for f in THEOREM_FIELDS:
            if not str(t.get(f, "")).strip():
                problems.append(f"{t.get('name', '?')}: missing field `{f}`")
        mod = dict((n, m) for m, n in capstones).get(t.get("name"))
        if mod and mod != t.get("module"):
            problems.append(f"{t['name']}: module {t.get('module')} != KERNEL_CAPSTONES {mod}")
        for w in ("positive_witness", "negative_witness"):
            v = t.get(w, "")
            if v and v != "PENDING" and v not in decls:
                problems.append(f"{t['name']}: {w} `{v}` is not declared in the active build")
        if t.get("status") not in ("HEADLINE", "CONDITIONAL"):
            problems.append(f"{t['name']}: status must be HEADLINE or CONDITIONAL")
    names = {t.get("name") for t in theorems}
    for p in props:
        for f in PROPERTY_FIELDS:
            if f not in p:
                problems.append(f"property {p.get('id', '?')}: missing field `{f}`")
        if p.get("level") not in LEVELS:
            problems.append(f"property {p.get('id')}: level `{p.get('level')}` is not a §2 claim level")
        if p.get("level") == "PROVEN-MODEL" and p.get("theorem") not in names:
            problems.append(f"property {p.get('id')}: PROVEN-MODEL needs a registry theorem")
        if p.get("theorem") and p["theorem"] not in names:
            problems.append(f"property {p.get('id')}: theorem `{p['theorem']}` is not in the registry")
        for path in p.get("tests", []):
            if not os.path.exists(os.path.join(ROOT, path)):
                problems.append(f"property {p.get('id')}: test path `{path}` does not exist")
    if cap is None:
        problems.append("reports/ledger_capture.json is missing (run --capture)")
    else:
        if cap.get("sources_sha256") != capture_sources_hash(capstones):
            problems.append("reports/ledger_capture.json is stale: the capstones or the active Coq "
                            "files changed since it was captured (run --capture where Coq is built)")
        for n in want:
            if n not in cap.get("print_assumptions", {}):
                problems.append(f"capture has no Print Assumptions for {n}")
    return problems


def md_cell(s):
    return str(s).replace("|", "/").replace("\n", " ")


def render_headline(theorems, cap):
    order = [n for _, n in kernel_capstones()]
    by = {t["name"]: t for t in theorems}
    pa = cap["print_assumptions"]
    out = ["# Headline theorems", "",
           "> **Generated — do not edit by hand.** Source: `04_SPECS/ledgers/headline_theorems.toml`,",
           "> the `KERNEL_CAPSTONES` list in `03_PROTO/crates/riinac/src/verify.rs` and the Coq",
           f"> sources; `Print Assumptions` captured at commit `{cap['commit']}`. Regenerate with",
           "> `python3 scripts/generate-ledgers.py` (`--capture` re-measures). REQ-103.", "",
           "These are the only theorems public surfaces may cite as guarantees (mandate S2.4). Every",
           "one is about the formal model of the language; the compiler is tested against that model,",
           "not proven to implement it. Reproduce with `riinac verify --coq`, which checks the same",
           "list in the kernel.", "",
           "| Theorem | File | Status | Kernel assumptions | Witnesses (+ / −) | Reviewed |",
           "|---|---|---|---|---|---|"]
    for n in order:
        t = by[n]
        rel, line = theorem_location(t["module"], n)
        axioms = pa[n]
        kern = "closed under the global context" if not axioms else ", ".join(f"`{a}`" for a in axioms)
        wit = f"{t['positive_witness']} / {t['negative_witness']}"
        rev = "PENDING (D7 reviewer)" if t["reviewer"] == "PENDING" else f"{t['reviewer']}, {t['review_date']}"
        out.append(f"| `{n}` | `{rel}:{line}` | {t['status']} | {md_cell(kern)} | {md_cell(wit)} | {md_cell(rev)} |")
    out.append("")
    for n in order:
        t = by[n]
        rel, line = theorem_location(t["module"], n)
        out += [f"## `{n}`", "",
                f"- **Statement:** {t['statement']}",
                f"- **Fragment:** {t['fragment']}",
                f"- **Public claim:** {t['public_claim']}",
                f"- **Source:** `{rel}:{line}` (module `RIINA.{t['module']}`)",
                f"- **Status:** {t['status']}"]
        if t.get("note"):
            out.append(f"- **Note:** {t['note']}")
        out += [f"- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)", ""]
    pending_w = sum(1 for t in theorems for w in ("positive_witness", "negative_witness") if t[w] == "PENDING")
    pending_r = sum(1 for t in theorems if t["reviewer"] == "PENDING")
    out += ["## Open items", "",
            f"- {pending_w} of {2 * len(theorems)} witnesses are PENDING (S2.9).",
            f"- {pending_r} of {len(theorems)} statements await a named human review (S2.10, owner ruling D7).",
            ""]
    return "\n".join(out)


def render_properties(props, cap):
    out = ["# Property ledger", "",
           "> **Generated — do not edit by hand.** Source: `04_SPECS/ledgers/properties.toml`.",
           "> Regenerate with `python3 scripts/generate-ledgers.py`. REQ-103.", "",
           "Every security or correctness property RIINA advertises, with its claim level in the",
           "hardening mandate's vocabulary (§2):", "",
           "| Level | Meaning |", "|---|---|",
           "| PROVEN-IMPL | proven for, or validated on every run of, the shipped `riinac` |",
           "| PROVEN-MODEL | Coq theorem, closed under the global context, about the formal model; linked to the compiler only by testing |",
           "| ENFORCED-TESTED | the compiler rejects violations; positive and negative tests |",
           "| MODELLED | a formal model of X, proving facts about its own definitions |",
           "| GENERATED | produced by a script, not independently checked |",
           "| RETIRED | no longer maintained |", "| PLANNED | not built |", "",
           "No property is PROVEN-IMPL today: that needs assured mode (REQ-100).", "",
           "| Property | Level | Fragment | Theorem | Tests | Verify |", "|---|---|---|---|---|---|"]
    for p in props:
        thm = f"`{p['theorem']}`" if p["theorem"] else "—"
        tests = "<br>".join(f"`{t}`" for t in p["tests"]) or "—"
        cmd = f"`{p['command']}`" if p["command"] else "—"
        out.append(f"| {md_cell(p['property'])} | {p['level']} | {md_cell(p['fragment'])} | {thm} | {tests} | {cmd} |")
    counts = {lv: sum(1 for p in props if p["level"] == lv) for lv in LEVELS}
    out += ["", "**By level:** " + ", ".join(f"{lv} {n}" for lv, n in counts.items() if n), "",
            "**`metrics.json` `claimLevels` → §2 levels:**", "", "| claimLevels value | §2 level |", "|---|---|"]
    out += [f"| {a} | {b} |" for a, b in CLAIM_LEVEL_MAP]
    out += ["", f"PROVEN-MODEL rows were last checked in the kernel at commit `{cap['commit']}`;",
            "ENFORCED-TESTED rows run on every commit (`cargo test` in CI).", ""]
    return "\n".join(out)


def render_trusted(theorems, cap):
    tools = cap["tools"]
    sizes = cap["sizes_nonblank_lines"]
    axioms = {}
    for n, axs in cap["print_assumptions"].items():
        for a in axs:
            axioms.setdefault(a, []).append(n)
    params = parameter_sites()
    pin = re.search(r'ROCQ_CORE_VERSION="\$\{RIINA_ROCQ_CORE_VERSION:-([0-9.]+)\}"', read("scripts/provision-coq.sh"))
    chan = re.search(r'channel = "([^"]+)"', read("rust-toolchain.toml"))
    stdlib = re.search(r"Total registered builtins: \*\*(\d+)\*\*", read("docs/api/STDLIB.md"))
    compiled = re.search(r"\*\*(\d+)\*\* of the \d+ compile", read("docs/api/STDLIB.md"))
    conditional = [t["name"] for t in theorems if t["status"] == "CONDITIONAL"]
    prelude = cap.get("emitted_c_lines_minimal_program")
    rows = [
        ("Rocq kernel", f"pinned {pin.group(1) if pin else '?'} (`scripts/provision-coq.sh`); captured: {tools['rocq']}", "external", "Checks every Coq proof; trusted."),
        ("Rocq stdlib axioms", "; ".join(f"`{a}` (used by {', '.join(ns)})" for a, ns in sorted(axioms.items())) or "none used by any capstone", "external", "From `Print Assumptions` on the capstones."),
        ("Trusted interface (`Parameter`)", f"{len(params)} declarations in the active build (listed below)", "—", "Axioms in all but name; none is used by a capstone (see HEADLINE_THEOREMS.md)."),
        ("Section premises", ", ".join(f"`{n}`" for n in conditional) or "none", "—", "A CONDITIONAL capstone rests on premises; it is never a guarantee."),
        ("Extraction toolchain", "none yet: no Coq code is extracted (REQ-54 S3)", "—", "Will join the trusted base with assured mode (REQ-100)."),
        ("Rust toolchain", f"pinned {chan.group(1) if chan else '?'} (`rust-toolchain.toml`); captured: {tools['rustc']}", "external", "Compiles riinac."),
        ("Elaboration and checking (riinac frontend)", "lexer, parser, type checker, types", sizes["frontend"], "Not proven to implement the Coq model; differential conformance is REQ-111."),
        ("Interpreter", "riina-codegen `interp.rs`, `value.rs`, builtins", sizes["interpreter"], "Reference for the backend differentials."),
        ("C backend and runtime prelude", f"riina-codegen `lower.rs`, `ir.rs`, `emit.rs`; a minimal program emits {prelude if prelude else '?'} lines of C", sizes["c_backend"], "Not formally verified; differential-tested (REQ-59)."),
        ("WASM backend", "riina-codegen `wasm.rs`, `wasm_encode.rs`", sizes["wasm_backend"], "No runtime capability gate yet (REQ-114)."),
        ("Builtins", f"{stdlib.group(1) if stdlib else '?'} registered, {compiled.group(1) if compiled else '?'} compile (`docs/api/STDLIB.md`)", "in the interpreter and C backend rows", "Builtin semantics are not modelled in Coq (REQ-99)."),
        ("C compiler", f"the host `cc`; captured: {tools['cc']}", "external", "gcc or clang on Linux and macOS; Windows only under WSL (the emitted C uses POSIX headers)."),
        ("Package manager", "riina-pkg", sizes["package_manager"], "Enforces manifest effect permissions (tested)."),
        ("Compliance checker", "riina-compliance", sizes["compliance"], "Heuristic rules; evidence, not certification."),
        ("Cryptography", "riina-core (05_TOOLING)", sizes["crypto"], "Experimental, not audited, not validated."),
        ("Compiler driver", "riinac", sizes["driver"], "Includes `riinac verify`."),
        ("Operating system and hardware", f"the host OS, libc and CPU; captured host: {tools['host']}", "external", "No hardware-level guarantee; constant time holds only in the reduction-count model."),
        ("Development and CI tools (not shipped)", f"wasmtime ({tools['wasmtime']}), z3 ({tools['z3']})", "external", "Used by tests and the SMT lane only."),
    ]
    out = ["# Trusted base", "",
           "> **Generated — do not edit by hand.** Regenerate with `python3 scripts/generate-ledgers.py`;",
           f"> sizes and tool versions measured by `--capture` at commit `{cap['commit']}`. REQ-103.", "",
           "Everything a RIINA guarantee depends on that is not itself proven (mandate S1.11). Sizes",
           "are non-blank lines of Rust source, excluding test files.", "",
           "| Component | What | Size | Note |", "|---|---|---|---|"]
    for name, what, size, note in rows:
        out.append(f"| {md_cell(name)} | {md_cell(what)} | {md_cell(size)} | {md_cell(note)} |")
    out += ["", "## Trusted interface: the `Parameter` declarations", ""]
    out += [f"- `{name}` — `{site}`" for site, name in params]
    out += [""]
    return "\n".join(out)


def generate(theorems, props, cap):
    return {
        "HEADLINE_THEOREMS.md": render_headline(theorems, cap),
        "PROPERTY_LEDGER.md": render_properties(props, cap),
        "TRUSTED_BASE.md": render_trusted(theorems, cap),
    }


def main():
    args = sys.argv[1:]
    if args == ["--list-parameters"]:
        # One `file:line name` per active Parameter, for AXIOMS.md
        # (scripts/update-proof-ledger.sh).
        for site, name in parameter_sites():
            print(f"{site} {name}")
        return
    if "--capture" in args:
        capture()
        if args == ["--capture"]:
            args = []
    theorems, props = load_sources()
    cap = json.load(open(CAPTURE, encoding="utf-8")) if os.path.exists(CAPTURE) else None
    problems = validate(theorems, props, cap)
    if "--check" in args:
        if cap is not None:
            for name, text in generate(theorems, props, cap).items():
                path = os.path.join(ROOT, name)
                if not os.path.exists(path) or open(path, encoding="utf-8").read() != text:
                    problems.append(f"{name} differs from its sources (run python3 scripts/generate-ledgers.py)")
        if problems:
            print("Ledger check FAILED:")
            print("\n".join("  " + p for p in problems))
            sys.exit(1)
        print("Ledgers are up to date (HEADLINE_THEOREMS.md, PROPERTY_LEDGER.md, TRUSTED_BASE.md).")
        return
    if problems:
        die("cannot generate:\n" + "\n".join("  " + p for p in problems))
    for name, text in generate(theorems, props, cap).items():
        with open(os.path.join(ROOT, name), "w", encoding="utf-8") as fh:
            fh.write(text)
    print("Wrote " + ", ".join(OUTPUTS))


if __name__ == "__main__":
    main()
