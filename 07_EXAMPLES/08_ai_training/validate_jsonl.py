#!/usr/bin/env python3
"""Validate every riina_safe_code entry in vuln_to_safe.jsonl against the RIINA compiler."""
import json
import subprocess
import sys
import tempfile
import os

RIINAC = "/workspaces/proof/03_PROTO/target/debug/riinac"
JSONL_PATH = "/workspaces/proof/07_EXAMPLES/08_ai_training/vuln_to_safe.jsonl"

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

        # Write code to temp file and use bash echo pipe to riinac
        # This avoids Python subprocess stdin encoding issues
        with tempfile.NamedTemporaryFile(mode='w', suffix='.rii', delete=False, dir='/tmp') as tf:
            tf.write(code)
            tf.write('\n')
            tmppath = tf.name

        try:
            # Use bash -c with cat pipe; CWD must be /workspaces/proof
            result = subprocess.run(
                ['bash', '-c', f'cd /workspaces/proof && cat "{tmppath}" | {RIINAC} check --stdin 2>&1'],
                capture_output=True, text=True, timeout=10
            )
            output = result.stdout.strip()
        except subprocess.TimeoutExpired:
            output = "TIMEOUT"
        finally:
            os.unlink(tmppath)

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
