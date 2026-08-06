#!/usr/bin/env bash
# ============================================================================
# coverage-check.sh — REQ-30 frontend line-coverage gate
#
# Measures line coverage of the untrusted-input frontend (lexer + parser +
# typechecker) with cargo-llvm-cov (stable toolchain; llvm-tools is in the
# pinned 1.94.1 component set) and FAILS if it drops below the threshold.
#
# Scope rationale: the frontend is the attack surface (`riinac check --stdin`,
# the REQ-30 fuzz target). The ≥80% line bar was first measured 2026-06-12
# (81.34%); this script turns that measurement into a repeatable regression
# gate. It is the in-repo source of truth; CI wraps it (no divergent check).
#
# Usage:   bash scripts/coverage-check.sh [THRESHOLD]
# Default THRESHOLD = 80 (percent lines).
# Exit:    0 = at/above threshold (or cargo-llvm-cov absent → SKIP, non-fatal);
#          1 = below threshold.
# ============================================================================

set -euo pipefail

THRESHOLD="${1:-80}"
ROOT="$(git rev-parse --show-toplevel)"
MANIFEST="$ROOT/03_PROTO/Cargo.toml"

if ! command -v cargo-llvm-cov >/dev/null 2>&1 && ! cargo llvm-cov --version >/dev/null 2>&1; then
    echo "[coverage] cargo-llvm-cov not installed — SKIP (install: cargo install cargo-llvm-cov)."
    echo "[coverage] (non-fatal: this lets local/pre-push runs proceed; CI installs it.)"
    exit 0
fi

echo "[coverage] measuring frontend line coverage (lexer + parser + typechecker), threshold ${THRESHOLD}%…"

# --fail-under-lines makes cargo-llvm-cov itself enforce the bar and exit non-zero.
cargo llvm-cov \
    --manifest-path "$MANIFEST" \
    -p riina-lexer -p riina-parser -p riina-typechecker \
    --release \
    --summary-only \
    --fail-under-lines "$THRESHOLD"

echo "[coverage] frontend line coverage >= ${THRESHOLD}% — PASS"
