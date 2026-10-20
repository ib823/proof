#!/usr/bin/env python3
"""generate-agent-files.py — the instruction files AI agents read (REQ-109, mandate S5.6).

AGENTS.md, COPILOT.md, .cursorrules, .clinerules, .github/copilot-instructions.md,
llms.txt and llms-full.txt are generated from templates in 04_SPECS/agent_files/,
never edited by hand. A template is the file's text with placeholders:

  {{name}}                 a value from metrics.json, VERSION or the sources below
  {{include:_part.md}}     another file from 04_SPECS/agent_files/
  {{kw:fungsi|fn, ...}}    keyword pairs, rendered as written but checked against
                           the lexer: both spellings must lex to the same token
  {{kwp:fungsi (fn), ...}} the same, written "malay (english)"
  {{ty:Nombor (Int), ...}} type names, checked against the parser's type table
  {{effects_order}} {{effects_list}} {{levels_order}} {{cli}}
  {{keyword_table}} {{type_table}}          generated from the compiler sources
  {{file:docs/api/STDLIB.md}}               a generated file, inlined

Sources: VERSION; website/public/metrics.json; the lexer, parser and type
definitions in 03_PROTO; riinac's usage text; 02_FORMAL/smt/SCOPED_SET.txt;
end_to_end.rs CORPUS_PASSING; scripts/provision-coq.sh. All of them ship on
the public branch, so the check runs there too.

Usage:
  python3 scripts/generate-agent-files.py           # regenerate
  python3 scripts/generate-agent-files.py --check   # fail on a hand edit or a stale file (CI)
"""

import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
TEMPLATES = "04_SPECS/agent_files"
TARGETS = {
    "AGENTS.md": "AGENTS.md.tmpl",
    "COPILOT.md": "COPILOT.md.tmpl",
    ".cursorrules": "cursorrules.tmpl",
    ".clinerules": "clinerules.tmpl",
    ".github/copilot-instructions.md": "copilot-instructions.md.tmpl",
    "llms.txt": "llms.txt.tmpl",
    "llms-full.txt": "llms-full.txt.tmpl",
}
PLACEHOLDER = re.compile(r"\{\{([a-z_]+)(?::(.*?))?\}\}", re.S)


def read(rel):
    with open(os.path.join(ROOT, rel), encoding="utf-8") as fh:
        return fh.read()


class GenError(Exception):
    pass


def commas(n):
    return f"{n:,}"


# --------------------------------------------------------------------------
# Compiler tables
# --------------------------------------------------------------------------
def fn_body(src, header):
    i = src.index(header)
    j = src.find("\n    fn ", i + len(header))
    return src[i:j if j > 0 else len(src)]


def alternatives(body):
    """Each `"a" | "b" => X` match arm as (names, rest-of-line)."""
    out = []
    for m in re.finditer(r'((?:"[A-Za-z_]\w*"\s*\|\s*)*"[A-Za-z_]\w*")\s*=>\s*([^\n]*)', body):
        out.append((re.findall(r'"([^"]+)"', m.group(1)), m.group(2)))
    return out


def keyword_table():
    """{token: [spellings]} from the lexer's keyword match."""
    lex = read("03_PROTO/crates/riina-lexer/src/lexer.rs")
    table = {}
    for names, rest in alternatives(lex):
        m = re.match(r"TokenKind::(Kw\w+)", rest)
        if m:
            table.setdefault(m.group(1), []).extend(names)
    if not table:
        raise GenError("no keywords found in riina-lexer/src/lexer.rs")
    return table


def type_arms():
    src = read("03_PROTO/crates/riina-parser/src/lib.rs")
    return [names for names, _ in alternatives(fn_body(src, "fn parse_ty_inner("))]


def named_levels(parse_fn, enum_header):
    """[(malay, english, level)] for a parser match against a `level()` table."""
    parser = read("03_PROTO/crates/riina-parser/src/lib.rs")
    types = read("03_PROTO/crates/riina-types/src/lib.rs")
    names = {}
    for alts, rest in alternatives(fn_body(parser, parse_fn)):
        m = re.match(r"Ok\(\w+::(\w+)\)", rest)
        if m and m.group(1) not in names:
            # The first arm for a variant names it; aliases such as MasaTetap
            # (which maps onto Crypto) are not separate entries.
            english = alts[0]
            malay = alts[1] if len(alts) > 1 else alts[0]
            names[m.group(1)] = (malay, english)
    enum = types[types.index(enum_header):]
    level_fn = enum[enum.index("pub const fn level(self)"):]
    level_fn = level_fn[:level_fn.index("\n    }")]
    levels = {v: int(n) for v, n in re.findall(r"Self::(\w+) => (\d+)", level_fn)}
    rows = []
    for variant, level in sorted(levels.items(), key=lambda kv: kv[1]):
        if variant not in names:
            raise GenError(f"{enum_header}: {variant} has a level but no parser spelling")
        rows.append((*names[variant], level))
    return rows


def effects():
    return named_levels("fn parse_effect(", "pub enum Effect {")


def security_levels():
    return named_levels("fn parse_security_level(", "pub enum SecurityLevel {")


def cli_commands():
    src = read("03_PROTO/crates/riinac/src/main.rs")
    usage = src.split('const USAGE: &str = "\\', 1)[1].split('";', 1)[0]
    block = usage.split("Commands:", 1)[1].split("\n\n", 1)[0]
    return re.findall(r"^\s{2}(\S+)\s{2,}(.+)$", block, re.M)


# --------------------------------------------------------------------------
# Values
# --------------------------------------------------------------------------
def context():
    m = json.loads(read("website/public/metrics.json"))
    cp = m["proofs"]["countingPolicy"]
    smt_rows = []
    for line in read("02_FORMAL/smt/SCOPED_SET.txt").splitlines():
        parts = line.split()
        if line.strip() and not line.lstrip().startswith("#") and len(parts) >= 2 and parts[1].isdigit():
            smt_rows.append((parts[0], int(parts[1])))
    e2e = re.search(r"const CORPUS_PASSING: usize = (\d+);", read("03_PROTO/crates/riinac/tests/end_to_end.rs"))
    pin = re.search(r'ROCQ_CORE_VERSION="\$\{RIINA_ROCQ_CORE_VERSION:-([0-9.]+)\}"', read("scripts/provision-coq.sh"))
    if not (e2e and pin):
        raise GenError("CORPUS_PASSING or the Rocq pin not found")
    names = {"SecurityLatticeVerification": "security lattice", "EffectJoinVerification": "effect join"}
    smt_parts = []
    for path, n in smt_rows:
        stem = os.path.basename(path).rsplit(".", 1)[0]
        smt_parts.append(f"{names.get(stem, stem)} {n}")
    return {
        "version": read("VERSION").strip(),
        "date": m["generated"][:10],
        "core": commas(cp["coreMechanizedQed"]),
        "model": commas(cp["modelMechanizedQedNonvacuous"]),
        "excluded": commas(cp["excludedQed"]),
        "parameters": str(m["proofs"]["parameters"]),
        "admitted": str(m["proofs"]["admitted"]),
        "axioms": str(m["proofs"]["axioms"]),
        "coq_files_active": str(m["coq"]["filesActive"]),
        "rust_tests": commas(m["rust"]["tests"]),
        "crates": str(m["rust"]["crates"]),
        "examples": str(m["examples"]),
        "corpus_passing": e2e.group(1),
        "smt": str(sum(n for _, n in smt_rows)),
        "smt_breakdown": ", ".join(smt_parts),
        "tlaplus_theorems": str(m["tlaplus"]["theorems"]),
        "alloy_assertions": str(m["alloy"]["assertions"]),
        "fstar_lemmas": str(m["fstar"]["lemmas"]),
        "rocq": pin.group(1),
        "profiles": str(m["compliance"]["profiles"]),
        "rules": str(m["compliance"]["rules"]),
        "keywords_total": str(len(keyword_table())),
    }


# --------------------------------------------------------------------------
# Checked islands and generated tables
# --------------------------------------------------------------------------
def check_keywords(text, style):
    table = keyword_table()
    token_of = {s: tok for tok, spellings in table.items() for s in spellings}
    pat = r"([a-z_]+)\|([a-z_]+)" if style == "pipe" else r"([a-z_]+) \(([a-z_-]+)\)"
    pairs = re.findall(pat, text)
    if not pairs:
        raise GenError(f"keyword island has no pairs: {text[:60]!r}")
    for a, b in pairs:
        b = b.replace("-", "_") if style == "paren" and b not in token_of else b
        ta, tb = token_of.get(a), token_of.get(b)
        # "constant-time" style glosses are descriptions, not spellings: accept
        # a gloss only when the Malay spelling is a keyword.
        if ta is None:
            raise GenError(f"`{a}` is not a keyword the lexer knows")
        if tb is not None and tb != ta:
            raise GenError(f"`{a}` and `{b}` lex to different tokens ({ta}, {tb})")
        if tb is None and style == "pipe":
            raise GenError(f"`{b}` is not a keyword the lexer knows (paired with `{a}`)")
    return text


def check_types(text):
    arms = type_arms()
    for malay, english in re.findall(r"`?([A-Za-z]\w*)(?:<[^>]*>)?(?:@\w+)?`? ?\(([A-Za-z]\w*)\)", text):
        if not any(malay in a and english in a for a in arms):
            raise GenError(f"type `{malay}` ({english}) is not one parser type with both names")
    for name in re.findall(r"`([A-Z]\w*)", text):
        if not any(name in a for a in arms):
            raise GenError(f"type `{name}` is not in the parser's type table")
    return text


def effects_order():
    return " < ".join(f"{malay}({lvl})" for malay, _, lvl in effects())


def effects_list():
    return " | ".join(f"{malay} ({english})" if malay != english else malay for malay, english, _ in effects())


def levels_order():
    return " < ".join(malay for malay, _, _ in security_levels())


def cli():
    width = max(len(c) for c, _ in cli_commands())
    return "\n".join(f"riinac {c.ljust(width)}  # {d}" for c, d in cli_commands())


def keyword_table_md():
    rows = ["| Token | Spellings |", "|---|---|"]
    for tok, spellings in sorted(keyword_table().items()):
        rows.append(f"| `{tok}` | {', '.join(f'`{s}`' for s in dict.fromkeys(spellings))} |")
    return "\n".join(rows)


def type_table_md():
    rows = ["| Type | Spellings |", "|---|---|"]
    for names in type_arms():
        rows.append(f"| {names[0]} | {', '.join(f'`{n}`' for n in names)} |")
    return "\n".join(rows)


# --------------------------------------------------------------------------
# Rendering
# --------------------------------------------------------------------------
def render(template_name, ctx, depth=0):
    if depth > 3:
        raise GenError("include nesting too deep")
    text = read(f"{TEMPLATES}/{template_name}")

    def sub(m):
        key, arg = m.group(1), m.group(2)
        if key == "include":
            return render(arg.strip(), ctx, depth + 1).rstrip("\n")
        if key == "file":
            return read(arg.strip()).rstrip("\n")
        if key == "kw":
            return check_keywords(arg, "pipe")
        if key == "kwp":
            return check_keywords(arg, "paren")
        if key == "ty":
            return check_types(arg)
        generated = {"effects_order": effects_order, "effects_list": effects_list,
                     "levels_order": levels_order, "cli": cli,
                     "keyword_table": keyword_table_md, "type_table": type_table_md}
        if key in generated and arg is None:
            return generated[key]()
        if key in ctx and arg is None:
            return ctx[key]
        raise GenError(f"{template_name}: unknown placeholder {{{{{m.group(0)[2:-2]}}}}}")

    return PLACEHOLDER.sub(sub, text)


def generate():
    ctx = context()
    out = {}
    for target, tmpl in TARGETS.items():
        body = render(tmpl, ctx).rstrip("\n")
        out[target] = (body + "\n\n<!-- Generated by scripts/generate-agent-files.py from "
                       f"{TEMPLATES}/{tmpl}. Edit the template, not this file (mandate S5.6). -->\n")
    return out


def main():
    check = sys.argv[1:] == ["--check"]
    if sys.argv[1:] not in ([], ["--check"]):
        print(__doc__.strip().splitlines()[-2].strip(), file=sys.stderr)
        sys.exit(2)
    try:
        files = generate()
    except (GenError, KeyError, ValueError, OSError) as e:
        print(f"generate-agent-files: {e}", file=sys.stderr)
        sys.exit(1)
    if check:
        stale = [t for t, text in files.items()
                 if not os.path.exists(os.path.join(ROOT, t)) or read(t) != text]
        if stale:
            print("Agent files differ from their templates (hand edit or stale; run "
                  "python3 scripts/generate-agent-files.py): " + ", ".join(stale))
            sys.exit(1)
        print(f"Agent files are up to date ({len(files)} files).")
        return
    for target, text in files.items():
        with open(os.path.join(ROOT, target), "w", encoding="utf-8") as fh:
            fh.write(text)
    print("Wrote " + ", ".join(files))


if __name__ == "__main__":
    main()
