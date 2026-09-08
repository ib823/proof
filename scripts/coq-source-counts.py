#!/usr/bin/env python3
"""Count Coq identifiers outside nested comments and strings in active sources."""

import sys
from pathlib import Path


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
            else:
                i += 1
        elif source[i] == '"':
            i += 1
            while i < len(source):
                if source[i] == '"':
                    i += 1
                    if i < len(source) and source[i] == '"':
                        i += 1
                    else:
                        break
                else:
                    i += 1
        elif source[i].isalpha() or source[i] == '_':
            start = i
            i += 1
            while i < len(source) and (source[i].isalnum() or source[i] in "_'"):
                i += 1
            yield source[start:i]
        else:
            i += 1


def count(root, names):
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
    # Missing/unreadable listed files fail instead of silently disappearing.
    return sum(token in names for file in files
               for token in identifiers((root / file).read_text(encoding='utf-8')))


if __name__ == '__main__':
    try:
        print(count(Path(sys.argv[1]), set(sys.argv[2:])))
    except (OSError, UnicodeError, ValueError, IndexError) as error:
        print(f'Coq source audit failed: {error}', file=sys.stderr)
        sys.exit(2)
