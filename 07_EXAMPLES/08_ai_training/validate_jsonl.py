#!/usr/bin/env python3
"""Validate every riina_safe_code entry in vuln_to_safe.jsonl against the RIINA compiler."""
import json
import subprocess
import sys
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, "..", ".."))
RIINAC = os.environ.get(
    "RIINAC", os.path.join(REPO_ROOT, "03_PROTO", "target", "debug", "riinac")
)
JSONL_PATH = os.path.join(SCRIPT_DIR, "vuln_to_safe.jsonl")

passed = 0
failed = 0
errors = []

with open(JSONL_PATH, 'r') as f:
    for line_num, line in enumerate(f, 1):
        line = line.strip()
        if not line:
            continue
        try:
            entry = json.loads(line)
        except json.JSONDecodeError as e:
            print(f"ENTRY {line_num}: JSON PARSE ERROR: {e}")
            failed += 1
            errors.append((line_num, f"JSON parse error: {e}"))
            continue

        code = entry.get("riina_safe_code", "")
        vuln = entry.get("vulnerability", "unknown")

        # Feed the source as UTF-8 bytes on stdin (no shell, no temp file).
        try:
            result = subprocess.run(
                [RIINAC, 'check', '--stdin'],
                input=(code + '\n').encode('utf-8'),
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                cwd=REPO_ROOT, timeout=10,
            )
            output = result.stdout.decode('utf-8', errors='replace').strip()
        except subprocess.TimeoutExpired:
            output = "TIMEOUT"

        if "Success!" in output:
            passed += 1
            print(f"ENTRY {line_num}: PASS ({vuln[:50]})")
        else:
            failed += 1
            errors.append((line_num, output))
            print(f"ENTRY {line_num}: FAIL ({vuln[:50]})")
            print(f"  Output: {output[:200]}")

print(f"\n{'='*60}")
print(f"RESULTS: {passed} passed, {failed} failed, {passed + failed} total")
print(f"{'='*60}")

if errors:
    print("\nFAILED ENTRIES:")
    for num, err in errors:
        print(f"  Entry {num}: {err[:150]}")

sys.exit(0 if failed == 0 else 1)
