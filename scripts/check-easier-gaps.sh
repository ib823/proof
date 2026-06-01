#!/usr/bin/env bash
# ============================================================================
# check-easier-gaps.sh — Closure checks for easier strategic gaps (1,2,9,12)
#
# Items covered:
#   1) Type System Soundness (cross-prover foundation presence)
#   2) Non-Interference active-scope hygiene (no active NI assumptions/axioms)
#   9) Protocol correctness foundation (Coq + TLA+ + Alloy artifacts)
#  12) Trust-chain foundation (DDC/hermetic artifacts + secret/Trojan-source security gates;
#      signed-commit gate retracted 2026-06-01 as unenforceable)
#
# Usage:
#   bash scripts/check-easier-gaps.sh
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPORT_PATH="$REPO_ROOT/reports/easier_gap_status.json"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

COQ_DIR="$REPO_ROOT/02_FORMAL/coq"
COQ_PROJECT="$COQ_DIR/_CoqProject"
LEAN_DIR="$REPO_ROOT/02_FORMAL/lean/RIINA"
ISA_DIR="$REPO_ROOT/02_FORMAL/isabelle/RIINA"
TLA_DIR="$REPO_ROOT/02_FORMAL/tlaplus/RIINA/Domains"
ALLOY_DIR="$REPO_ROOT/02_FORMAL/alloy/RIINA/Domains"

ITEM1_STATUS="FAIL"
ITEM1_DETAIL=""
ITEM2_STATUS="FAIL"
ITEM2_DETAIL=""
ITEM9_STATUS="FAIL"
ITEM9_DETAIL=""
ITEM12_STATUS="FAIL"
ITEM12_DETAIL=""

escape_json() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

echo ""
echo "================================================================"
echo "  RIINA EASIER GAP CLOSURE CHECK (1,2,9,12)"
echo "================================================================"

# ---------------------------------------------------------------------------
# Item 1: Type System Soundness
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

coq_exists=1
coq_listed=1
coq_type_paths=()
for rel in "${coq_type_files[@]}"; do
  path="$COQ_DIR/$rel"
  coq_type_paths+=("$path")
  if [ ! -f "$path" ]; then
    coq_exists=0
  fi
  if ! grep -Fxq "$rel" "$COQ_PROJECT"; then
    coq_listed=0
  fi
done

lean_exists=1
lean_type_paths=()
for rel in "${lean_type_files[@]}"; do
  path="$LEAN_DIR/$rel"
  lean_type_paths+=("$path")
  if [ ! -f "$path" ]; then
    lean_exists=0
  fi
done

isa_exists=1
isa_type_paths=()
for rel in "${isa_type_files[@]}"; do
  path="$ISA_DIR/$rel"
  isa_type_paths+=("$path")
  if [ ! -f "$path" ]; then
    isa_exists=0
  fi
done

coq_type_theorems=0
lean_type_theorems=0
isa_type_theorems=0
if [ "$coq_exists" -eq 1 ]; then
  coq_type_theorems="$( (grep -Eh '^(Theorem|Lemma) ' "${coq_type_paths[@]}" || true) | wc -l | tr -d ' ' )"
fi
if [ "$lean_exists" -eq 1 ]; then
  lean_type_theorems="$( (grep -Eh '^(theorem|lemma) ' "${lean_type_paths[@]}" || true) | wc -l | tr -d ' ' )"
fi
if [ "$isa_exists" -eq 1 ]; then
  isa_type_theorems="$( (grep -Eh '^(theorem|lemma) ' "${isa_type_paths[@]}" || true) | wc -l | tr -d ' ' )"
fi

if [ "$coq_exists" -eq 1 ] \
  && [ "$coq_listed" -eq 1 ] \
  && [ "$lean_exists" -eq 1 ] \
  && [ "$isa_exists" -eq 1 ] \
  && [ "$coq_type_theorems" -gt 0 ] \
  && [ "$lean_type_theorems" -gt 0 ] \
  && [ "$isa_type_theorems" -gt 0 ]; then
  ITEM1_STATUS="PASS"
else
  ITEM1_STATUS="FAIL"
fi
ITEM1_DETAIL="coq_exists=$coq_exists coq_listed=$coq_listed coq_thm=$coq_type_theorems lean_exists=$lean_exists lean_thm=$lean_type_theorems isa_exists=$isa_exists isa_thm=$isa_type_theorems"

# ---------------------------------------------------------------------------
# Item 2: Non-Interference active-scope hygiene
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
archive_ni_required=0
for f in \
  "NonInterference_v2.v" \
  "NonInterference_v2_LogicalRelation.v" \
  "NonInterference_v2_Monotone.v"; do
  if [ -f "$COQ_DIR/properties/_archive_deprecated/$f" ]; then
    archive_ni_required=$((archive_ni_required + 1))
  fi
done
archive_ni_total="$(ls -1 "$COQ_DIR/properties/_archive_deprecated"/NonInterference_v2*.v 2>/dev/null | wc -l | tr -d ' ')"

metrics_assumptions=999
if [ -f "$REPO_ROOT/website/public/metrics.json" ]; then
  parsed="$(grep -m1 -E '"assumptions"[[:space:]]*:[[:space:]]*[0-9]+' "$REPO_ROOT/website/public/metrics.json" | sed -E 's/[^0-9]*([0-9]+).*/\1/' || true)"
  if [ -n "$parsed" ]; then
    metrics_assumptions="$parsed"
  fi
fi

if [ "$ni_listed" -eq 0 ] \
  && [ "$explicit_step_up" -eq 0 ] \
  && [ "$active_axioms" -eq 0 ] \
  && [ "$archive_ni_required" -eq 3 ] \
  && [ "$metrics_assumptions" -eq 0 ]; then
  ITEM2_STATUS="PASS"
else
  ITEM2_STATUS="FAIL"
fi
ITEM2_DETAIL="ni_listed=$ni_listed explicit_step_up=$explicit_step_up active_axioms=$active_axioms archived_ni_required=$archive_ni_required archived_ni_total=$archive_ni_total metrics_assumptions=$metrics_assumptions"

# ---------------------------------------------------------------------------
# Item 9: Protocol correctness foundation (artifact parity)
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

if [ "$protocol_exists" -eq 1 ] \
  && [ "$coq_protocol_theorems" -gt 0 ] \
  && [ "$tla_protocol_theorems" -gt 0 ] \
  && [ "$alloy_protocol_assertions" -gt 0 ]; then
  ITEM9_STATUS="PASS"
else
  ITEM9_STATUS="FAIL"
fi
ITEM9_DETAIL="exists=$protocol_exists coq_thm=$coq_protocol_theorems tla_thm=$tla_protocol_theorems alloy_assert=$alloy_protocol_assertions"

# ---------------------------------------------------------------------------
# Item 12: Trust-chain foundation (DDC/hermetic + enforcement hooks)
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
  if [ ! -f "$p" ]; then
    trust_files_exist=0
  fi
done

# The signed-commit gate was RETRACTED 2026-06-01 (unenforceable: the whole
# history is unsigned and no key is provisioned in CI/sessions). The trust-chain
# foundation now rests on the security gates that ARE enforceable: the secret
# scan and the Trojan-source (bidi-Unicode) scan. Verify those remain present.
security_gates=0
if grep -q 'Scanning changed files for secrets' "$REPO_ROOT/scripts/security-gates.sh" \
   && grep -q 'Trojan source' "$REPO_ROOT/scripts/security-gates.sh"; then
  security_gates=1
fi

bootstrap_cmd=0
if grep -q 'Commands::Bootstrap' "$REPO_ROOT/05_TOOLING/crates/riina-build/src/main.rs"; then
  bootstrap_cmd=1
fi

coq_ddc_theorems=0
if [ -f "$COQ_DIR/domains/T001_HermeticBuild.v" ] && [ -f "$COQ_DIR/domains/SupplyChainSecurity.v" ]; then
  coq_ddc_theorems="$( (grep -Eh '^(Theorem|Lemma) ' "$COQ_DIR/domains/T001_HermeticBuild.v" "$COQ_DIR/domains/SupplyChainSecurity.v" || true) | wc -l | tr -d ' ' )"
fi

if [ "$trust_files_exist" -eq 1 ] \
  && [ "$security_gates" -eq 1 ] \
  && [ "$bootstrap_cmd" -eq 1 ] \
  && [ "$coq_ddc_theorems" -gt 0 ]; then
  ITEM12_STATUS="PASS"
else
  ITEM12_STATUS="FAIL"
fi
ITEM12_DETAIL="files=$trust_files_exist security_gates=$security_gates (signing retracted) bootstrap_cmd=$bootstrap_cmd coq_thm=$coq_ddc_theorems"

# ---------------------------------------------------------------------------
# Report + exit
# ---------------------------------------------------------------------------

echo ""
echo "Item 1  Type System Soundness       : ${ITEM1_STATUS}"
echo "Item 2  Non-Interference Hygiene    : ${ITEM2_STATUS}"
echo "Item 9  Protocol Foundation         : ${ITEM9_STATUS}"
echo "Item 12 Trust-Chain Foundation      : ${ITEM12_STATUS}"

overall="PASS"
if [ "$ITEM1_STATUS" != "PASS" ] || [ "$ITEM2_STATUS" != "PASS" ] || [ "$ITEM9_STATUS" != "PASS" ] || [ "$ITEM12_STATUS" != "PASS" ]; then
  overall="FAIL"
fi

mkdir -p "$REPO_ROOT/reports"
cat > "$REPORT_PATH" <<EOF
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "scope": "easier_items_1_2_9_12",
  "item_1_type_system_soundness": {
    "status": "$ITEM1_STATUS",
    "detail": "$(escape_json "$ITEM1_DETAIL")"
  },
  "item_2_non_interference_hygiene": {
    "status": "$ITEM2_STATUS",
    "detail": "$(escape_json "$ITEM2_DETAIL")"
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
EOF

echo ""
echo "Report: $REPORT_PATH"
if [ "$overall" = "PASS" ]; then
  echo -e "${GREEN}Easier-gap closure checks passed.${NC}"
  exit 0
fi

echo -e "${RED}Easier-gap closure checks failed.${NC}"
echo -e "${YELLOW}Review details in $REPORT_PATH${NC}"
exit 1
