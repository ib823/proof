#!/usr/bin/env bash
# ============================================================================
# check-dim14-runtime.sh
#
# Dimension 14 runtime-proof executable gate.
# Verifies that runtime proof architecture is implemented in code (not docs
# only) and that the crate-level execution tests pass.
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPORT_PATH="$REPO_ROOT/reports/dim14_runtime_status.json"
REPO_HEAD="$(git -C "$REPO_ROOT" rev-parse HEAD 2>/dev/null || echo "")"
REPO_BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

run_with_timeout() {
  local seconds="$1"
  shift
  if command -v timeout >/dev/null 2>&1; then
    timeout "$seconds" "$@"
  else
    "$@"
  fi
}

bool_json() {
  if [ "$1" -eq 1 ]; then
    echo "true"
  else
    echo "false"
  fi
}

echo ""
echo "================================================================"
echo "  RIINA DIM14 RUNTIME PROOF CHECK"
echo "================================================================"

mkdir -p "$REPO_ROOT/reports"

CAPABILITY_IMPL=0
ATTESTATION_IMPL=0
CT_ORACLE_IMPL=0
EFFECT_GATE_IMPL=0
PROOF_BUNDLE_IMPL=0
RUNTIME_TESTS_OK=0
RUNTIME_CHECK_OK=0
RUNTIME_VERIFIER_OK=0
RUNTIME_VERIFIER_TESTS_OK=0

CAPABILITY_FILE="$REPO_ROOT/05_TOOLING/crates/riina-effect/src/capability.rs"
ATTESTATION_FILE="$REPO_ROOT/05_TOOLING/crates/riina-effect/src/attestation.rs"
CT_ORACLE_FILE="$REPO_ROOT/05_TOOLING/crates/riina-effect/src/ct_oracle.rs"
EFFECT_GATE_FILE="$REPO_ROOT/05_TOOLING/crates/riina-effect/src/effect_gate.rs"
PROOF_BUNDLE_FILE="$REPO_ROOT/05_TOOLING/crates/riina-effect/src/proof_bundle.rs"

if [ -f "$CAPABILITY_FILE" ] && grep -q 'pub struct CapabilityToken' "$CAPABILITY_FILE"; then
  CAPABILITY_IMPL=1
fi
if [ -f "$ATTESTATION_FILE" ] && grep -q 'pub trait AttestationProvider' "$ATTESTATION_FILE"; then
  ATTESTATION_IMPL=1
fi
if [ -f "$CT_ORACLE_FILE" ] && grep -q 'pub struct CtOracle' "$CT_ORACLE_FILE"; then
  CT_ORACLE_IMPL=1
fi
if [ -f "$EFFECT_GATE_FILE" ] && grep -q 'pub struct EffectGate' "$EFFECT_GATE_FILE"; then
  EFFECT_GATE_IMPL=1
fi
if [ -f "$PROOF_BUNDLE_FILE" ] && grep -q 'pub struct RuntimeProofBundle' "$PROOF_BUNDLE_FILE"; then
  PROOF_BUNDLE_IMPL=1
fi

if run_with_timeout 1200 cargo check --manifest-path "$REPO_ROOT/05_TOOLING/Cargo.toml" -p riina-effect >/dev/null 2>&1; then
  RUNTIME_CHECK_OK=1
fi

if run_with_timeout 1200 cargo test --manifest-path "$REPO_ROOT/05_TOOLING/Cargo.toml" -p riina-effect >/dev/null 2>&1; then
  RUNTIME_TESTS_OK=1
fi

if run_with_timeout 1200 cargo run --manifest-path "$REPO_ROOT/05_TOOLING/Cargo.toml" -p runtime-proof-verify -- --self-check >/dev/null 2>&1; then
  RUNTIME_VERIFIER_OK=1
fi
if run_with_timeout 1200 cargo test --manifest-path "$REPO_ROOT/05_TOOLING/Cargo.toml" -p runtime-proof-verify >/dev/null 2>&1; then
  RUNTIME_VERIFIER_TESTS_OK=1
fi

OVERALL="PASS"
if [ "$CAPABILITY_IMPL" -ne 1 ] || [ "$ATTESTATION_IMPL" -ne 1 ] || [ "$CT_ORACLE_IMPL" -ne 1 ] || [ "$EFFECT_GATE_IMPL" -ne 1 ] || [ "$PROOF_BUNDLE_IMPL" -ne 1 ] || [ "$RUNTIME_CHECK_OK" -ne 1 ] || [ "$RUNTIME_TESTS_OK" -ne 1 ] || [ "$RUNTIME_VERIFIER_OK" -ne 1 ] || [ "$RUNTIME_VERIFIER_TESTS_OK" -ne 1 ]; then
  OVERALL="FAIL"
fi

cat > "$REPORT_PATH" <<EOF_JSON
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "repo_head": "$REPO_HEAD",
  "repo_branch": "$REPO_BRANCH",
  "scope": "dimension_14_runtime_proof_architecture",
  "checks": {
    "capability_impl": $(bool_json "$CAPABILITY_IMPL"),
    "attestation_impl": $(bool_json "$ATTESTATION_IMPL"),
    "ct_oracle_impl": $(bool_json "$CT_ORACLE_IMPL"),
    "effect_gate_impl": $(bool_json "$EFFECT_GATE_IMPL"),
    "proof_bundle_impl": $(bool_json "$PROOF_BUNDLE_IMPL"),
    "cargo_check_riina_effect": $(bool_json "$RUNTIME_CHECK_OK"),
    "cargo_test_riina_effect": $(bool_json "$RUNTIME_TESTS_OK"),
    "runtime_proof_verify_self_check": $(bool_json "$RUNTIME_VERIFIER_OK"),
    "runtime_proof_verify_tests": $(bool_json "$RUNTIME_VERIFIER_TESTS_OK")
  },
  "overall": "$OVERALL"
}
EOF_JSON

echo "capability_impl          : $CAPABILITY_IMPL"
echo "attestation_impl         : $ATTESTATION_IMPL"
echo "ct_oracle_impl           : $CT_ORACLE_IMPL"
echo "effect_gate_impl         : $EFFECT_GATE_IMPL"
echo "proof_bundle_impl        : $PROOF_BUNDLE_IMPL"
echo "cargo_check_riina_effect : $RUNTIME_CHECK_OK"
echo "cargo_test_riina_effect  : $RUNTIME_TESTS_OK"
echo "runtime_proof_verify     : $RUNTIME_VERIFIER_OK"
echo "runtime_proof_verify_tst : $RUNTIME_VERIFIER_TESTS_OK"
echo "overall                  : $OVERALL"
echo "report                   : $REPORT_PATH"

if [ "$OVERALL" = "PASS" ]; then
  echo -e "${GREEN}Dimension 14 runtime proof check passed.${NC}"
  exit 0
fi

echo -e "${RED}Dimension 14 runtime proof check failed.${NC}"
exit 1
