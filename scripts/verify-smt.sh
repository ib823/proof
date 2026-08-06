#!/usr/bin/env bash
# verify-smt.sh — REQ-67a: verify the SMT lane's SCOPED SET with Z3.
#
# The SMT lane's honest claim is exactly the files in
# 02_FORMAL/smt/SCOPED_SET.txt, each with a recorded expected verdict.
# This script runs Z3 on every listed file and fails unless the output is
# EXACTLY the expected number of `unsat` lines — any `sat`, `unknown`,
# solver error, or count mismatch fails the gate. The generated corpus
# (everything NOT listed) carries no verification claim and is not run.
#
# Usage:
#   bash scripts/verify-smt.sh            # verify the scoped set
#   bash scripts/verify-smt.sh --check    # alias (the run IS the check)
#
# Negative controls (validated at introduction, 2026-08-06): corrupting an
# expected count in SCOPED_SET.txt FAILS; injecting a satisfiable
# (check-sat) BEFORE the file's (exit) FAILS. Note the subtlety the first
# control attempt exposed: content appended AFTER (exit) is dead to Z3 —
# but dead directives cannot fake outputs, and moving (exit) earlier
# reduces the unsat count below the expectation, so the gate is
# truncation-safe in both directions.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
MANIFEST="$REPO_ROOT/02_FORMAL/smt/SCOPED_SET.txt"
TIMEOUT_SEC="${RIINA_SMT_TIMEOUT_SEC:-120}"

if ! command -v z3 >/dev/null 2>&1; then
    echo "[FAIL] z3 not found. Install it (e.g. apt-get install -y z3) — this"
    echo "       gate never self-skips: a missing tool is a failure, not a pass."
    exit 1
fi

if [ ! -f "$MANIFEST" ]; then
    echo "[FAIL] scoped-set manifest missing: $MANIFEST"
    exit 1
fi

FILES=0
TOTAL_UNSAT=0
FAIL=0

while IFS= read -r line; do
    case "$line" in ''|'#'*) continue ;; esac
    rel="${line% *}"
    expected="${line##* }"
    f="$REPO_ROOT/$rel"
    if [ ! -f "$f" ]; then
        echo "[FAIL] listed file missing: $rel"
        FAIL=1
        continue
    fi
    out="$(timeout "$TIMEOUT_SEC" z3 -smt2 "$f" 2>&1 || true)"
    unsat_count="$(printf '%s\n' "$out" | grep -cx 'unsat' || true)"
    other="$(printf '%s\n' "$out" | grep -vx 'unsat' | grep -cv '^$' || true)"
    if [ "$unsat_count" -eq "$expected" ] && [ "$other" -eq 0 ]; then
        echo "[OK]   $rel — $unsat_count/$expected unsat"
        FILES=$((FILES + 1))
        TOTAL_UNSAT=$((TOTAL_UNSAT + unsat_count))
    else
        echo "[FAIL] $rel — expected $expected unsat, got $unsat_count unsat + $other other line(s)"
        printf '%s\n' "$out" | grep -vx 'unsat' | head -5 | sed 's/^/         /'
        FAIL=1
    fi
done < "$MANIFEST"

echo ""
if [ "$FAIL" -eq 0 ] && [ "$FILES" -gt 0 ]; then
    echo "[PASS] SMT scoped set: $FILES file(s), $TOTAL_UNSAT properties unsat under z3 $(z3 --version | grep -oP '\d+\.\d+\.\d+' | head -1)"
    exit 0
fi
echo "[FAIL] SMT scoped-set verification failed"
exit 1
