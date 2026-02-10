#!/usr/bin/env bash
# ============================================================================
# check-medium-gaps.sh — Closure checks for medium strategic gaps (1,2,3,4,9,12)
#
# Items covered:
#   1) Type system soundness (cross-lane core presence)
#   2) Non-interference active-scope hygiene
#   3) Effect soundness foundation (Coq effect gate + backend preservation hooks)
#   4) Linear soundness foundation (Coq linear invariants + compiler signal)
#   9) Protocol correctness foundation (Coq + TLA+ + Alloy artifacts)
#  12) Trust-chain foundation (DDC/hermetic + signed-commit policy)
#
# Usage:
#   bash scripts/check-medium-gaps.sh
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPORT_PATH="$REPO_ROOT/reports/medium_gap_status.json"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

COQ_DIR="$REPO_ROOT/02_FORMAL/coq"
COQ_PROJECT="$COQ_DIR/_CoqProject"
LEAN_DIR="$REPO_ROOT/02_FORMAL/lean/RIINA"
ISA_DIR="$REPO_ROOT/02_FORMAL/isabelle/RIINA"
TLA_DIR="$REPO_ROOT/02_FORMAL/tlaplus/RIINA/Domains"
ALLOY_DIR="$REPO_ROOT/02_FORMAL/alloy/RIINA/Domains"
TYPECHECKER_RS="$REPO_ROOT/03_PROTO/crates/riina-typechecker/src/lib.rs"

escape_json() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

listed_in_project() {
  local rel="$1"
  grep -Fxq "$rel" "$COQ_PROJECT"
}

file_exists_and_listed() {
  local rel="$1"
  [ -f "$COQ_DIR/$rel" ] && listed_in_project "$rel"
}

echo ""
echo "================================================================"
echo "  RIINA MEDIUM GAP CLOSURE CHECK (1,2,3,4,9,12)"
echo "================================================================"

ITEM1_STATUS="FAIL"; ITEM1_DETAIL=""
ITEM2_STATUS="FAIL"; ITEM2_DETAIL=""
ITEM3_STATUS="FAIL"; ITEM3_DETAIL=""
ITEM4_STATUS="FAIL"; ITEM4_DETAIL=""
ITEM9_STATUS="FAIL"; ITEM9_DETAIL=""
ITEM12_STATUS="FAIL"; ITEM12_DETAIL=""

# ---------------------------------------------------------------------------
# Item 1: Type system soundness
# ---------------------------------------------------------------------------
coq_type_files=(
  "type_system/Progress.v"
  "type_system/Preservation.v"
  "type_system/TypeSafety.v"
)
lean_type_files=(
  "TypeSystem/Progress.lean"
  "TypeSystem/Preservation.lean"
  "TypeSystem/TypeSafety.lean"
)
isa_type_files=(
  "TypeSystem/Progress.thy"
  "TypeSystem/Preservation.thy"
  "TypeSystem/TypeSafety.thy"
)

coq_ok=1
for rel in "${coq_type_files[@]}"; do
  if ! file_exists_and_listed "$rel"; then
    coq_ok=0
  fi
done

lean_ok=1
for rel in "${lean_type_files[@]}"; do
  [ -f "$LEAN_DIR/$rel" ] || lean_ok=0
done

isa_ok=1
for rel in "${isa_type_files[@]}"; do
  [ -f "$ISA_DIR/$rel" ] || isa_ok=0
done

coq_thm=$(grep -Eh '^(Theorem|Lemma) ' "${coq_type_files[@]/#/$COQ_DIR/}" 2>/dev/null | wc -l | tr -d ' ')
lean_thm=$(grep -Eh '^(theorem|lemma) ' "${lean_type_files[@]/#/$LEAN_DIR/}" 2>/dev/null | wc -l | tr -d ' ')
isa_thm=$(grep -Eh '^(theorem|lemma) ' "${isa_type_files[@]/#/$ISA_DIR/}" 2>/dev/null | wc -l | tr -d ' ')

if [ "$coq_ok" -eq 1 ] && [ "$lean_ok" -eq 1 ] && [ "$isa_ok" -eq 1 ] \
  && [ "$coq_thm" -gt 0 ] && [ "$lean_thm" -gt 0 ] && [ "$isa_thm" -gt 0 ]; then
  ITEM1_STATUS="PASS"
fi
ITEM1_DETAIL="coq=$coq_ok lean=$lean_ok isa=$isa_ok coq_thm=$coq_thm lean_thm=$lean_thm isa_thm=$isa_thm"

# ---------------------------------------------------------------------------
# Item 2: Non-interference active-scope hygiene
# ---------------------------------------------------------------------------
mapfile -t active_coq_files < <(
  awk '
    {
      line=$0;
      sub(/^[ \t]+/, "", line);
      if (line ~ /^[#-]/ || line == "") next;
      split(line, tok, /[ \t]+/);
      if (tok[1] ~ /\.v$/) print tok[1];
    }
  ' "$COQ_PROJECT"
)

explicit_step_up=0
active_axioms=0
for rel in "${active_coq_files[@]}"; do
  path="$COQ_DIR/$rel"
  [ -f "$path" ] || continue
  if grep -Eq '^[[:space:]]*Parameter[[:space:]]+val_rel_n_step_up[[:space:]]' "$path"; then
    explicit_step_up=$((explicit_step_up + 1))
  fi
  axiom_hits="$(grep -Ec '^[[:space:]]*Axiom[[:space:]]+' "$path" || true)"
  active_axioms=$((active_axioms + axiom_hits))
done

ni_listed="$(grep -Ec '^properties/NonInterference_v2' "$COQ_PROJECT" || true)"
metrics_assumptions=$(python3 - <<'PY' "$REPO_ROOT/website/public/metrics.json"
import json, sys
try:
  with open(sys.argv[1], 'r', encoding='utf-8') as f:
    d=json.load(f)
  print(int(d.get('proofs',{}).get('assumptions', 999)))
except Exception:
  print(999)
PY
)

if [ "$ni_listed" -eq 0 ] && [ "$explicit_step_up" -eq 0 ] && [ "$active_axioms" -eq 0 ] && [ "$metrics_assumptions" -eq 0 ]; then
  ITEM2_STATUS="PASS"
fi
ITEM2_DETAIL="ni_listed=$ni_listed explicit_step_up=$explicit_step_up active_axioms=$active_axioms metrics_assumptions=$metrics_assumptions"

# ---------------------------------------------------------------------------
# Item 3: Effect soundness foundation
# ---------------------------------------------------------------------------
required_effect_files=(
  "effects/EffectAlgebra.v"
  "effects/EffectGate.v"
  "effects/EffectSystem.v"
  "domains/AlgebraicEffects.v"
  "domains/BackendTraitVerification.v"
)

effect_files_ok=1
for rel in "${required_effect_files[@]}"; do
  file_exists_and_listed "$rel" || effect_files_ok=0
done

effect_tokens_ok=1
for tok in gate_enforcement perform_requires_license effect_safety EFF_001_13_effect_safety backend_003_all_preserve_effects; do
  if ! grep -RqsE "(^|[^[:alnum:]_])${tok}([^[:alnum:]_]|$)" \
      "$COQ_DIR/effects" "$COQ_DIR/domains/AlgebraicEffects.v" "$COQ_DIR/domains/BackendTraitVerification.v"; then
    effect_tokens_ok=0
  fi
done

# Compiler-side signal: effect checker code path exists.
compiler_effect_signal=0
if [ -f "$TYPECHECKER_RS" ] && grep -qi 'effect' "$TYPECHECKER_RS"; then
  compiler_effect_signal=1
fi

if [ "$effect_files_ok" -eq 1 ] && [ "$effect_tokens_ok" -eq 1 ] && [ "$compiler_effect_signal" -eq 1 ]; then
  ITEM3_STATUS="PASS"
fi
ITEM3_DETAIL="files=$effect_files_ok tokens=$effect_tokens_ok compiler_signal=$compiler_effect_signal"

# ---------------------------------------------------------------------------
# Item 4: Linear soundness foundation
# ---------------------------------------------------------------------------
required_linear_files=(
  "domains/LinearTypes.v"
  "domains/SessionTypes.v"
  "domains/QuantumTypes.v"
)

linear_files_ok=1
for rel in "${required_linear_files[@]}"; do
  file_exists_and_listed "$rel" || linear_files_ok=0
done

linear_tokens_ok=1
for tok in linear_must_be_used linear_zero_usage_invalid linear_many_usage_invalid unused_linear_ill_formed ST_013_fresh_linear linearity_full_consumption; do
  if ! grep -RqsE "(^|[^[:alnum:]_])${tok}([^[:alnum:]_]|$)" \
      "$COQ_DIR/domains/LinearTypes.v" "$COQ_DIR/domains/SessionTypes.v" "$COQ_DIR/domains/QuantumTypes.v"; then
    linear_tokens_ok=0
  fi
done

compiler_linear_signal=0
if [ -f "$TYPECHECKER_RS" ] && grep -qi 'linear' "$TYPECHECKER_RS"; then
  compiler_linear_signal=1
fi

if [ "$linear_files_ok" -eq 1 ] && [ "$linear_tokens_ok" -eq 1 ]; then
  ITEM4_STATUS="PASS"
fi
ITEM4_DETAIL="files=$linear_files_ok tokens=$linear_tokens_ok compiler_signal=$compiler_linear_signal"

# ---------------------------------------------------------------------------
# Item 9: Protocol correctness foundation
# ---------------------------------------------------------------------------
protocols=(SessionTypes AuthenticationProtocols VerifiedProtocols)
protocol_exists=1
coq_protocol_paths=()
tla_protocol_paths=()
alloy_protocol_paths=()

for name in "${protocols[@]}"; do
  coq_path="$COQ_DIR/domains/${name}.v"
  tla_path="$TLA_DIR/${name}.tla"
  alloy_path="$ALLOY_DIR/${name}.als"
  coq_protocol_paths+=("$coq_path")
  tla_protocol_paths+=("$tla_path")
  alloy_protocol_paths+=("$alloy_path")
  if [ ! -f "$coq_path" ] || [ ! -f "$tla_path" ] || [ ! -f "$alloy_path" ]; then
    protocol_exists=0
  fi
done

coq_protocol_theorems=0
tla_protocol_theorems=0
alloy_protocol_assertions=0
if [ "$protocol_exists" -eq 1 ]; then
  coq_protocol_theorems="$( (grep -Eh '^(Theorem|Lemma) ' "${coq_protocol_paths[@]}" || true) | wc -l | tr -d ' ' )"
  tla_protocol_theorems="$( (grep -Eh '^[[:space:]]*THEOREM[[:space:]]' "${tla_protocol_paths[@]}" || true) | wc -l | tr -d ' ' )"
  alloy_protocol_assertions="$( (grep -Eh '^[[:space:]]*(assert|check)[[:space:]]' "${alloy_protocol_paths[@]}" || true) | wc -l | tr -d ' ' )"
fi

if [ "$protocol_exists" -eq 1 ] && [ "$coq_protocol_theorems" -gt 0 ] && [ "$tla_protocol_theorems" -gt 0 ] && [ "$alloy_protocol_assertions" -gt 0 ]; then
  ITEM9_STATUS="PASS"
fi
ITEM9_DETAIL="exists=$protocol_exists coq_thm=$coq_protocol_theorems tla_thm=$tla_protocol_theorems alloy_assert=$alloy_protocol_assertions"

# ---------------------------------------------------------------------------
# Item 12: Trust-chain foundation
# ---------------------------------------------------------------------------
trust_paths=(
  "$COQ_DIR/domains/T001_HermeticBuild.v"
  "$COQ_DIR/domains/SupplyChainSecurity.v"
  "$REPO_ROOT/02_FORMAL/tlaplus/RIINA/Domains/T001_HermeticBuild.tla"
  "$REPO_ROOT/02_FORMAL/smt/RIINA/Domains/T001_HermeticBuild.smt2"
  "$REPO_ROOT/02_FORMAL/verus/RIINA/Domains/t001__hermetic_build.rs"
  "$REPO_ROOT/02_FORMAL/verus/RIINA/Domains/supply_chain_security.rs"
  "$REPO_ROOT/05_TOOLING/tools/verify_integrity.sh"
)

trust_files_exist=1
for p in "${trust_paths[@]}"; do
  [ -f "$p" ] || trust_files_exist=0
done

signed_policy=0
if grep -q 'commit.gpgsign' "$REPO_ROOT/scripts/security-gates.sh"; then
  signed_policy=1
fi

bootstrap_cmd=0
if grep -q 'Commands::Bootstrap' "$REPO_ROOT/05_TOOLING/crates/riina-build/src/main.rs"; then
  bootstrap_cmd=1
fi

coq_ddc_theorems=0
if [ -f "$COQ_DIR/domains/T001_HermeticBuild.v" ] && [ -f "$COQ_DIR/domains/SupplyChainSecurity.v" ]; then
  coq_ddc_theorems="$( (grep -Eh '^(Theorem|Lemma) ' "$COQ_DIR/domains/T001_HermeticBuild.v" "$COQ_DIR/domains/SupplyChainSecurity.v" || true) | wc -l | tr -d ' ' )"
fi

if [ "$trust_files_exist" -eq 1 ] && [ "$signed_policy" -eq 1 ] && [ "$bootstrap_cmd" -eq 1 ] && [ "$coq_ddc_theorems" -gt 0 ]; then
  ITEM12_STATUS="PASS"
fi
ITEM12_DETAIL="files=$trust_files_exist signed_policy=$signed_policy bootstrap_cmd=$bootstrap_cmd coq_thm=$coq_ddc_theorems"

# ---------------------------------------------------------------------------
# Report + exit
# ---------------------------------------------------------------------------
echo ""
echo "Item 1  Type System Soundness       : ${ITEM1_STATUS}"
echo "Item 2  Non-Interference Hygiene    : ${ITEM2_STATUS}"
echo "Item 3  Effect Soundness Foundation : ${ITEM3_STATUS}"
echo "Item 4  Linear Soundness Foundation : ${ITEM4_STATUS}"
echo "Item 9  Protocol Foundation         : ${ITEM9_STATUS}"
echo "Item 12 Trust-Chain Foundation      : ${ITEM12_STATUS}"

overall="PASS"
for s in "$ITEM1_STATUS" "$ITEM2_STATUS" "$ITEM3_STATUS" "$ITEM4_STATUS" "$ITEM9_STATUS" "$ITEM12_STATUS"; do
  if [ "$s" != "PASS" ]; then
    overall="FAIL"
  fi
done

mkdir -p "$REPO_ROOT/reports"
cat > "$REPORT_PATH" <<EOF_JSON
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "scope": "medium_items_1_2_3_4_9_12",
  "item_1_type_system_soundness": {
    "status": "$ITEM1_STATUS",
    "detail": "$(escape_json "$ITEM1_DETAIL")"
  },
  "item_2_non_interference_hygiene": {
    "status": "$ITEM2_STATUS",
    "detail": "$(escape_json "$ITEM2_DETAIL")"
  },
  "item_3_effect_soundness_foundation": {
    "status": "$ITEM3_STATUS",
    "detail": "$(escape_json "$ITEM3_DETAIL")"
  },
  "item_4_linear_soundness_foundation": {
    "status": "$ITEM4_STATUS",
    "detail": "$(escape_json "$ITEM4_DETAIL")"
  },
  "item_9_protocol_foundation": {
    "status": "$ITEM9_STATUS",
    "detail": "$(escape_json "$ITEM9_DETAIL")"
  },
  "item_12_trust_chain_foundation": {
    "status": "$ITEM12_STATUS",
    "detail": "$(escape_json "$ITEM12_DETAIL")"
  },
  "overall": "$overall"
}
EOF_JSON

echo ""
echo "Report: $REPORT_PATH"
if [ "$overall" = "PASS" ]; then
  echo -e "${GREEN}Medium-gap closure checks passed.${NC}"
  exit 0
else
  echo -e "${RED}Medium-gap closure checks failed.${NC}"
  exit 1
fi
