#!/usr/bin/env python3
"""Fix common transpiler issues in auto-generated Lean 4 files.

Key fixes:
1. Bare constructor references: BKC → .bKC (auto-detected from inductives)
2. Bare field access for structures: field record → record.field
3. `bool`/`nat` lowercase in type positions
4. `negb x` → `!x`
5. Broken `Nat` on own line (failed Nat.leb)
6. `| ._ =>` double-pipe fix
7. Non-private helper theorem duplicates
"""

import re
import sys
import os


def extract_constructors(content):
    """Extract all constructor names from inductive declarations.
    Returns a dict mapping UpperCase Coq name → .leanName
    """
    constructors = {}
    # Find all `| .constructorName : TypeName` or `| .constructorName` patterns
    for m in re.finditer(r'\|\s+\.(\w+)\s*(?::\s*\w+|:.*?(?:\n|$))?', content):
        lean_name = m.group(1)
        # Generate the likely Coq uppercase version
        # First letter uppercase, rest same
        coq_name = lean_name[0].upper() + lean_name[1:]
        constructors[coq_name] = '.' + lean_name
    return constructors


def extract_structure_fields(content):
    """Extract structure field names and their structure types.
    Returns dict: field_name → structure_type_name
    """
    fields = {}
    current_struct = None
    for line in content.split('\n'):
        m = re.match(r'structure\s+(\w+)\s+where', line)
        if m:
            current_struct = m.group(1)
            continue
        if current_struct:
            m = re.match(r'\s+(\w+)\s*:', line)
            if m:
                fields[m.group(1)] = current_struct
            elif line.strip().startswith('deriving') or (line.strip() and not line.strip().startswith('--') and not line.strip().startswith('/')):
                if not re.match(r'\s+\w+\s*:', line):
                    current_struct = None
    return fields


def fix_bare_constructors(content):
    """Replace bare Coq-style constructor names with Lean dot-notation.

    Within theorem statements and def bodies, replace BKC → .bKC etc.
    Skip replacements inside:
    - inductive declarations (where constructors are defined)
    - match arms (already using .name syntax)
    - doc comments
    """
    constructors = extract_constructors(content)
    if not constructors:
        return content

    # Sort by length (longest first) to avoid partial matches
    sorted_ctors = sorted(constructors.items(), key=lambda x: -len(x[0]))

    lines = content.split('\n')
    in_inductive = False
    result = []

    for line in lines:
        # Track if we're inside an inductive declaration
        if re.match(r'inductive\s+\w+', line):
            in_inductive = True
        elif in_inductive and (re.match(r'\s*deriving\b', line) or
                               (line.strip() and not line.startswith(' ') and not line.startswith('\t')
                                and not line.startswith('|') and not line.startswith('--')
                                and not line.startswith('/-'))):
            in_inductive = False

        # Skip inductive declarations, doc comments, and correspondence tables
        if in_inductive or line.strip().startswith('--') or line.strip().startswith('|') and '|' in line[1:]:
            result.append(line)
            continue

        # Skip lines that are match arms (already using dot notation)
        if re.match(r'\s+\|\s+\.', line):
            result.append(line)
            continue

        # Replace bare constructor references
        modified_line = line
        for coq_name, lean_name in sorted_ctors:
            # Match whole word, but NOT when preceded by `.` (already dotted)
            # and NOT when followed by `:` (definition context)
            # Use word boundary
            pattern = r'(?<!\.)(?<!\w)' + re.escape(coq_name) + r'(?!\w)(?!\s*:)'
            modified_line = re.sub(pattern, lean_name, modified_line)

        result.append(modified_line)

    return '\n'.join(result)


def fix_structure_field_access(content):
    """Convert bare field access `field_name record` to `record.field_name`.

    This is only done for fields defined in structures within the SAME file.
    We look for patterns like:
    - `field_name var &&` → `var.field_name &&`
    - `field_name (expr)` → `(expr).field_name` — too complex, skip

    Only handles the simple case where it's `field var` with var being a simple identifier.
    """
    fields = extract_structure_fields(content)
    if not fields:
        return content

    lines = content.split('\n')
    result = []
    in_def = False

    for line in lines:
        # Check if we're in a def body
        if re.match(r'def\s+\w+', line):
            in_def = True
        elif line and not line.startswith(' ') and not line.startswith('\t'):
            in_def = False

        if in_def:
            for field_name in fields:
                # Pattern: `field_name identifier` where identifier is a simple word
                # But NOT in definition position (field_name : type)
                pattern = r'\b' + re.escape(field_name) + r'\s+(\w+)\b'
                # Check if this looks like field access (not definition)
                matches = list(re.finditer(pattern, line))
                for m in reversed(matches):
                    var_name = m.group(1)
                    # Heuristic: skip if var_name looks like a type or keyword
                    if var_name in ('Bool', 'Nat', 'Prop', 'true', 'false', 'where', 'with', 'by', 'in'):
                        continue
                    # Replace field_name var → var.field_name
                    replacement = f'{var_name}.{field_name}'
                    line = line[:m.start()] + replacement + line[m.end():]

        result.append(line)

    return '\n'.join(result)


def fix_types(content):
    """Fix lowercase type names."""
    # Fix `: bool` → `: Bool` and `∀ x : bool` → `∀ x : Bool`
    content = re.sub(r'(?<=:\s)bool\b', 'Bool', content)
    content = re.sub(r'(?<=: )bool\b', 'Bool', content)
    content = re.sub(r'∀\s*\((\w+)\s*:\s*bool\)', r'∀ (\1 : Bool)', content)
    # Fix `: nat` → `: Nat`
    content = re.sub(r'(?<=:\s)nat\b', 'Nat', content)
    content = re.sub(r'(?<=: )nat\b', 'Nat', content)
    content = re.sub(r'∀\s*\((\w+)\s*:\s*nat\)', r'∀ (\1 : Nat)', content)
    return content


def fix_negb(content):
    """Convert `negb x` to `!x`."""
    content = re.sub(r'\bnegb\s+(\w+)', r'!\1', content)
    content = re.sub(r'\bnegb\s*\(', r'!(', content)
    return content


def fix_broken_nat_defs(content):
    """Fix definitions with bare `Nat` body (broken Nat.leb/Nat.ble)."""
    lines = content.split('\n')
    fixed = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if i + 1 < len(lines) and lines[i+1].strip() == 'Nat':
            m = re.match(r'(def\s+\w+)\s*\(([^)]*)\)\s*:\s*Bool\s*:=', line)
            if m:
                params = m.group(2)
                param_names = []
                for p in params.split(','):
                    p = p.strip()
                    if ':' in p:
                        pname = p.split(':')[0].strip()
                        param_names.append(pname)
                    elif p:
                        param_names.append(p.split()[0] if ' ' in p else p)

                if len(param_names) >= 2:
                    fixed.append(line)
                    fixed.append(f'  Nat.ble {param_names[0]} {param_names[1]}')
                    i += 2
                    continue
        fixed.append(line)
        i += 1
    return '\n'.join(fixed)


def fix_empty_match(content):
    """Fix match blocks with empty body or truncated patterns."""
    # Pattern: match x with\n\n (empty)
    content = re.sub(r'(match \w+ with)\n\n(/--)', r'\1\n  | _ => true\n\n\2', content)
    return content


def fix_double_pipe(content):
    """Fix `| | _ =>` to `| _ =>`."""
    content = content.replace('| | _ =>', '| _ =>')
    return content


def fix_duplicate_helpers(content):
    """Remove non-private duplicate helper theorems."""
    helpers = ['andb_true_iff', 'andb_false_iff', 'negb_true_iff', 'negb_false_iff']
    for name in helpers:
        has_private = f'private theorem {name}' in content
        # Find non-private versions
        pattern = rf'^(/--\s+{name}.*?--/\n)?theorem {name}\b.*?$(?:\n  .*$)*'
        matches = list(re.finditer(pattern, content, re.MULTILINE))
        if has_private and matches:
            # Remove non-private duplicates
            for m in reversed(matches):
                content = content[:m.start()] + content[m.end():]
        elif matches and not has_private:
            # Make the first one private, remove the rest
            for i, m in enumerate(reversed(matches)):
                if i == len(matches) - 1:
                    # Make private
                    content = content[:m.start()] + 'private ' + content[m.start():]
                else:
                    content = content[:m.start()] + content[m.end():]
    return content


def fix_mk_constructors(content):
    """Replace Coq-style mk constructors with Lean .mk."""
    patterns = [
        (r'\bmkSQLConfig\b', 'SQLSecurityConfig.mk'),
        (r'\bmkUAFGuard\b', 'UseAfterFreeGuard.mk'),
        (r'\bmkDFGuard\b', 'DoubleFreeGuard.mk'),
        (r'\bmkNDGuard\b', 'NullDerefGuard.mk'),
        (r'\bmkBoundsGuard\b', 'BoundsGuard.mk'),
        (r'\bmkStackGuard\b', 'StackGuard.mk'),
        (r'\bmkHeapGuard\b', 'HeapGuard.mk'),
        (r'\bmkIsolationGuard\b', 'IsolationGuard.mk'),
        (r'\bmkMemSafety\b', 'MemorySafetyConfig.mk'),
        (r'\bmkPointer\b', 'Pointer.mk'),
        (r'\bmkMemRegion\b', 'MemoryRegion.mk'),
        (r'\bmkSecureMemRegion\b', 'SecureMemoryRegion.mk'),
    ]
    for pat, repl in patterns:
        content = re.sub(pat, repl, content)
    return content


def fix_file(filepath, dry_run=False):
    """Apply all fixes to a single file."""
    with open(filepath, 'r') as f:
        content = f.read()

    original = content

    content = fix_double_pipe(content)
    content = fix_types(content)
    content = fix_negb(content)
    content = fix_mk_constructors(content)
    content = fix_bare_constructors(content)
    content = fix_broken_nat_defs(content)
    content = fix_structure_field_access(content)

    if content != original:
        if not dry_run:
            with open(filepath, 'w') as f:
                f.write(content)
        return True
    return False


def main():
    dry_run = '--dry-run' in sys.argv

    if len(sys.argv) > 1 and sys.argv[1] != '--dry-run':
        # Fix specific files
        for filepath in sys.argv[1:]:
            if filepath.startswith('--'):
                continue
            if fix_file(filepath, dry_run):
                print(f"{'Would fix' if dry_run else 'Fixed'}: {filepath}")
            else:
                print(f"No changes: {filepath}")
    else:
        # Fix all .lean files under RIINA/
        count = 0
        for root, dirs, files in os.walk('RIINA'):
            # Skip already hand-corrected files
            if root == 'RIINA/Foundations':
                continue
            for f in files:
                if f.endswith('.lean'):
                    filepath = os.path.join(root, f)
                    if fix_file(filepath, dry_run):
                        count += 1
                        print(f"{'Would fix' if dry_run else 'Fixed'}: {filepath}")
        print(f"\nTotal files {'would modify' if dry_run else 'modified'}: {count}")


if __name__ == '__main__':
    main()
