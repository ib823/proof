#!/usr/bin/env bash
# ============================================================================
# check-heavy-gaps.sh — Foundation checks for heavy strategic gaps (5,6,7,8,10,11,13)
#
# Scope intentionally checks FOUNDATION evidence (artifacts + anchor obligations),
# not full mathematical closure.
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPORT_PATH="$REPO_ROOT/reports/heavy_gap_status.json"
INVENTORY="$REPO_ROOT/scripts/coq_active_proof_inventory.tsv"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

escape_json() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

has_token() {
  local tok="$1"
  grep -qE "(^|[^[:alnum:]_])${tok}([^[:alnum:]_]|$)" "$INVENTORY"
}

count_files() {
  local dir="$1"
  local ext="$2"
  find "$dir" -type f -name "*.${ext}" 2>/dev/null | wc -l | tr -d ' '
}

echo ""
echo "================================================================"
echo "  RIINA HEAVY GAP FOUNDATION CHECK (5,6,7,8,10,11,13)"
echo "================================================================"

ITEM5_STATUS="FAIL"; ITEM5_DETAIL=""
ITEM6_STATUS="FAIL"; ITEM6_DETAIL=""
ITEM7_STATUS="FAIL"; ITEM7_DETAIL=""
ITEM8_STATUS="FAIL"; ITEM8_DETAIL=""
ITEM10_STATUS="FAIL"; ITEM10_DETAIL=""
ITEM11_STATUS="FAIL"; ITEM11_DETAIL=""
ITEM13_STATUS="FAIL"; ITEM13_DETAIL=""

if [ ! -f "$INVENTORY" ]; then
  echo -e "${RED}ERROR: missing inventory $INVENTORY${NC}"
  exit 1
fi

# Item 5: Constant-time foundation
ct_tokens=(pure_is_constant_time time_003_constant_time_property S_001_16_ct_cache_behavior)
ct_hits=0
for t in "${ct_tokens[@]}"; do has_token "$t" && ct_hits=$((ct_hits+1)); done
if [ "$ct_hits" -eq "${#ct_tokens[@]}" ]; then ITEM5_STATUS="PASS"; fi
ITEM5_DETAIL="anchor_hits=$ct_hits/${#ct_tokens[@]}"

# Item 6: Zeroization foundation
z_tokens=(U_001_26_panic_keys_zeroized PHI_001_34_zeroize_complete key_zeroization_complete_thm)
z_hits=0
for t in "${z_tokens[@]}"; do has_token "$t" && z_hits=$((z_hits+1)); done
if [ "$z_hits" -eq "${#z_tokens[@]}" ]; then ITEM6_STATUS="PASS"; fi
ITEM6_DETAIL="anchor_hits=$z_hits/${#z_tokens[@]}"

# Item 7: Compiler correctness foundation
c_tokens=(backend_003_all_preserve_types compiler_determinism translation_deterministic)
c_hits=0
for t in "${c_tokens[@]}"; do has_token "$t" && c_hits=$((c_hits+1)); done
tv_files=$(count_files "$REPO_ROOT/02_FORMAL/tv/RIINA/Domains" smt2)
if [ "$c_hits" -eq "${#c_tokens[@]}" ] && [ "$tv_files" -gt 0 ]; then ITEM7_STATUS="PASS"; fi
ITEM7_DETAIL="anchor_hits=$c_hits/${#c_tokens[@]} tv_files=$tv_files"

# Item 8: Crypto correctness foundation
k_tokens=(riina_complete_crypto_security full_001_riina_full_crypto_secure crypto_constant_time)
k_hits=0
for t in "${k_tokens[@]}"; do has_token "$t" && k_hits=$((k_hits+1)); done
fstar_files=$(count_files "$REPO_ROOT/02_FORMAL/fstar/RIINA/Domains" fst)
if [ "$k_hits" -eq "${#k_tokens[@]}" ] && [ "$fstar_files" -gt 0 ]; then ITEM8_STATUS="PASS"; fi
ITEM8_DETAIL="anchor_hits=$k_hits/${#k_tokens[@]} fstar_files=$fstar_files"

# Item 10: Implementation correctness foundation
verus_files=$(count_files "$REPO_ROOT/02_FORMAL/verus/RIINA/Domains" rs)
kani_files=$(count_files "$REPO_ROOT/02_FORMAL/kani/RIINA/Domains" rs)
riinac_src_files=$(find "$REPO_ROOT/03_PROTO/crates/riinac/src" -type f -name "*.rs" 2>/dev/null | wc -l | tr -d ' ')
if [ "$verus_files" -gt 0 ] && [ "$kani_files" -gt 0 ] && [ "$riinac_src_files" -gt 0 ]; then ITEM10_STATUS="PASS"; fi
ITEM10_DETAIL="verus_files=$verus_files kani_files=$kani_files riinac_src_files=$riinac_src_files"

# Item 11: Protocol <-> implementation binding foundation
p_tokens=(AH_001_01_protocol_specification AH_001_02_implementation_matches_spec AH_001_05_protocol_composition)
p_hits=0
for t in "${p_tokens[@]}"; do has_token "$t" && p_hits=$((p_hits+1)); done
tla_proto_files=0
for f in SessionTypes.tla AuthenticationProtocols.tla VerifiedProtocols.tla; do
  [ -f "$REPO_ROOT/02_FORMAL/tlaplus/RIINA/Domains/$f" ] && tla_proto_files=$((tla_proto_files+1))
done
if [ "$p_hits" -eq "${#p_tokens[@]}" ] && [ "$tla_proto_files" -eq 3 ]; then ITEM11_STATUS="PASS"; fi
ITEM11_DETAIL="anchor_hits=$p_hits/${#p_tokens[@]} tla_proto_files=$tla_proto_files"

# Item 13: Hardware assumptions foundation
h_tokens=(S_001_03_cache_state_modeled S_001_16_ct_cache_behavior PERF_001_11_cache_abstraction_sound)
h_hits=0
for t in "${h_tokens[@]}"; do has_token "$t" && h_hits=$((h_hits+1)); done
hw_files=0
for f in S001_HardwareContracts.v HardwareSecurity.v SpeculativeExecution.v; do
  [ -f "$REPO_ROOT/02_FORMAL/coq/domains/$f" ] && hw_files=$((hw_files+1))
done
if [ "$h_hits" -eq "${#h_tokens[@]}" ] && [ "$hw_files" -ge 2 ]; then ITEM13_STATUS="PASS"; fi
ITEM13_DETAIL="anchor_hits=$h_hits/${#h_tokens[@]} hw_files=$hw_files"

echo ""
echo "Item 5   Constant-Time Foundation         : ${ITEM5_STATUS}"
echo "Item 6   Zeroization Foundation           : ${ITEM6_STATUS}"
echo "Item 7   Compiler Correctness Foundation  : ${ITEM7_STATUS}"
echo "Item 8   Crypto Correctness Foundation    : ${ITEM8_STATUS}"
echo "Item 10  Implementation Foundation        : ${ITEM10_STATUS}"
echo "Item 11  Proto-Impl Binding Foundation   : ${ITEM11_STATUS}"
echo "Item 13  Hardware Assumption Foundation  : ${ITEM13_STATUS}"

overall="PASS"
for s in "$ITEM5_STATUS" "$ITEM6_STATUS" "$ITEM7_STATUS" "$ITEM8_STATUS" "$ITEM10_STATUS" "$ITEM11_STATUS" "$ITEM13_STATUS"; do
  if [ "$s" != "PASS" ]; then overall="FAIL"; fi
done

mkdir -p "$REPO_ROOT/reports"
cat > "$REPORT_PATH" <<EOF_JSON
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "scope": "heavy_items_5_6_7_8_10_11_13_foundation",
  "item_5_constant_time_foundation": {"status": "$ITEM5_STATUS", "detail": "$(escape_json "$ITEM5_DETAIL")"},
  "item_6_zeroization_foundation": {"status": "$ITEM6_STATUS", "detail": "$(escape_json "$ITEM6_DETAIL")"},
  "item_7_compiler_correctness_foundation": {"status": "$ITEM7_STATUS", "detail": "$(escape_json "$ITEM7_DETAIL")"},
  "item_8_crypto_correctness_foundation": {"status": "$ITEM8_STATUS", "detail": "$(escape_json "$ITEM8_DETAIL")"},
  "item_10_implementation_correctness_foundation": {"status": "$ITEM10_STATUS", "detail": "$(escape_json "$ITEM10_DETAIL")"},
  "item_11_protocol_impl_binding_foundation": {"status": "$ITEM11_STATUS", "detail": "$(escape_json "$ITEM11_DETAIL")"},
  "item_13_hardware_assumptions_foundation": {"status": "$ITEM13_STATUS", "detail": "$(escape_json "$ITEM13_DETAIL")"},
  "overall": "$overall"
}
EOF_JSON

echo ""
echo "Report: $REPORT_PATH"
if [ "$overall" = "PASS" ]; then
  echo -e "${GREEN}Heavy-gap foundation checks passed.${NC}"
  exit 0
else
  echo -e "${RED}Heavy-gap foundation checks failed.${NC}"
  exit 1
fi
