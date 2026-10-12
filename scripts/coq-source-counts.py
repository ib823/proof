#!/usr/bin/env python3
"""Count Coq identifiers outside nested comments and strings in active sources.

Usage:
  coq-source-counts.py <coq-root> NAME...      total occurrences of the NAMEs
  coq-source-counts.py --forbidden <coq-root>  per-construct counts of the
                                               kernel-weakening constructs
                                               (prints `construct count` lines)
"""

import sys
from pathlib import Path


def _skip_string(source, i):
    """Skip a Coq string literal starting at source[i] == '"' ("" escapes)."""
    i += 1
    while i < len(source):
        if source[i] == '"':
            i += 1
            if i < len(source) and source[i] == '"':
                i += 1
            else:
                return i
        else:
            i += 1
    return i


def identifiers(source):
    i = 0
    depth = 0
    while i < len(source):
        if source.startswith("(*", i):
            depth += 1
            i += 2
        elif depth:
            if source.startswith("*)", i):
                depth -= 1
                i += 2
            elif source[i] == '"':
                # Coq lexes string literals INSIDE comments too: a "(*" or "*)"
                # within one does not change the nesting depth. Missing this let
                # `Proof. (* "(*" *) Admitted.` hide a real Admitted from the
                # scan (2026-10-11 audit) — Coq saw the comment close, the
                # scanner thought it was still open.
                i = _skip_string(source, i)
            else:
                i += 1
        elif source[i] == '"':
            i = _skip_string(source, i)
        elif source[i].isalpha() or source[i] == '_':
            start = i
            i += 1
            while i < len(source) and (source[i].isalnum() or source[i] in "_'"):
                i += 1
            yield source[start:i]
        else:
            i += 1


# Constructs that weaken what the kernel checks, or assume a statement without
# a proof, beyond the separately-gated Admitted/Axiom/Abort/Parameter counts.
SINGLE_TOKEN_FORBIDDEN = ("Conjecture", "Conjectures", "give_up", "bypass_check")
UNSET_CHECKS = ("Guard", "Positivity", "Universe")


def forbidden_counts(tokens):
    counts = {name: 0 for name in SINGLE_TOKEN_FORBIDDEN}
    counts["Admit Obligations"] = 0
    for flag in UNSET_CHECKS:
        counts[f"Unset {flag} Checking"] = 0
    for k, tok in enumerate(tokens):
        if tok in counts:
            counts[tok] += 1
        elif tok == "Admit" and k + 1 < len(tokens) and tokens[k + 1] == "Obligations":
            counts["Admit Obligations"] += 1
        elif (tok == "Unset" and k + 2 < len(tokens)
              and tokens[k + 1] in UNSET_CHECKS and tokens[k + 2] == "Checking"):
            counts[f"Unset {tokens[k + 1]} Checking"] += 1
    return counts


def active_files(root):
    project = (root / '_CoqProject').read_text(encoding='utf-8')
    files = [line.strip() for line in project.splitlines()
             if line.strip().endswith('.v') and not line.strip().startswith(('#', '-'))]
    if not files:
        raise ValueError('no active Coq sources in _CoqProject')
    listed = {Path(file).as_posix() for file in files}
    for source in root.rglob('*.v'):
        relative = source.relative_to(root)
        if any(part in {'_archive_deprecated', '_incomplete'} for part in relative.parts):
            continue
        if relative.as_posix() not in listed:
            raise ValueError(f'unlisted active Coq source: {relative.as_posix()}')
    return files


def count(root, names):
    # Missing/unreadable listed files fail instead of silently disappearing.
    return sum(token in names for file in active_files(root)
               for token in identifiers((root / file).read_text(encoding='utf-8')))


def forbidden(root):
    totals = None
    for file in active_files(root):
        counts = forbidden_counts(list(identifiers((root / file).read_text(encoding='utf-8'))))
        totals = counts if totals is None else {k: totals[k] + v for k, v in counts.items()}
    return totals


if __name__ == '__main__':
    try:
        if len(sys.argv) >= 2 and sys.argv[1] == '--forbidden':
            for construct, n in forbidden(Path(sys.argv[2])).items():
                print(f'{construct}\t{n}')
        else:
            print(count(Path(sys.argv[1]), set(sys.argv[2:])))
    except (OSError, UnicodeError, ValueError, IndexError) as error:
        print(f'Coq source audit failed: {error}', file=sys.stderr)
        sys.exit(2)
