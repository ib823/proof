#!/usr/bin/env bash
# ============================================================================
# check-dim1-dim9-promotion.sh
#
# Purpose:
#   Promotion-readiness gate for:
#     - Dimension 1 (type-system cross-lane core)
#     - Dimension 9 (protocol cross-lane core)
#
# Default mode is conservative and non-overclaiming (non-blocking):
#   - Requires real Lean core compilation for Dim 1 foundation PASS.
#   - Accepts static TLA+/Alloy protocol checks for Dim 9 foundation PASS.
#   - Reports promotion readiness separately (requires executable tools).
#
# Strict mode:
#   --strict-tools => fail unless promotion readiness is true for both dims.
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPORT_PATH="$REPO_ROOT/reports/dim1_dim9_promotion_status.json"

STRICT_TOOLS=0
PROVISION_TOOLS="${RIINA_PROVISION_FORMAL_TOOLS:-0}"
AUTO_PROVISION_ON_STRICT="${RIINA_AUTO_PROVISION_FORMAL_TOOLS_ON_STRICT:-1}"

while [ $# -gt 0 ]; do
  case "$1" in
    --strict-tools)
      STRICT_TOOLS=1
      ;;
    --provision-tools)
      PROVISION_TOOLS=1
      ;;
    --no-provision-tools)
      PROVISION_TOOLS=0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: bash scripts/check-dim1-dim9-promotion.sh [--strict-tools] [--provision-tools|--no-provision-tools]" >&2
      exit 1
      ;;
  esac
  shift
done

if [ "$STRICT_TOOLS" -eq 1 ] && [ "$AUTO_PROVISION_ON_STRICT" = "1" ]; then
  PROVISION_TOOLS=1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

COQ_DIR="$REPO_ROOT/02_FORMAL/coq"
COQ_PROJECT="$COQ_DIR/_CoqProject"
LEAN_DIR="$REPO_ROOT/02_FORMAL/lean"
LEAN_TYPE_DIR="$LEAN_DIR/RIINA/TypeSystem"
ISA_DIR="$REPO_ROOT/02_FORMAL/isabelle/RIINA"
TLA_DIR="$REPO_ROOT/02_FORMAL/tlaplus/RIINA/Domains"
ALLOY_DIR="$REPO_ROOT/02_FORMAL/alloy/RIINA/Domains"
FORMAL_TOOLS_DIR="$REPO_ROOT/05_TOOLING/tools/formal"
ISABELLE_HELPER="$REPO_ROOT/scripts/isabelle-local.sh"

if [ -f "$ISABELLE_HELPER" ]; then
  # shellcheck disable=SC1090
  source "$ISABELLE_HELPER"
else
  echo "ERROR: missing Isabelle helper: $ISABELLE_HELPER" >&2
  exit 1
fi

escape_json() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

run_with_timeout() {
  local seconds="$1"
  shift
  if command -v timeout >/dev/null 2>&1; then
    timeout "$seconds" "$@"
  else
    "$@"
  fi
}

echo ""
echo "================================================================"
echo "  RIINA DIM1/DIM9 PROMOTION READINESS"
echo "================================================================"
echo "strict-tools: $STRICT_TOOLS"
echo "provision-tools: $PROVISION_TOOLS"

mkdir -p "$REPO_ROOT/reports"

# ---------------------------------------------------------------------------
# Tool inventory
# ---------------------------------------------------------------------------
HAS_LAKE=0
HAS_ISABELLE=0
HAS_DOCKER=0
HAS_JAVA=0
HAS_TLA2TOOLS_JAR=0
HAS_ALLOY_JAR=0
PROVISION_ATTEMPTED=0
PROVISION_SUCCEEDED=0

# Source elan env for Lean toolchain (lake, lean, leanc)
if [ -f "$HOME/.elan/env" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.elan/env"
elif [ -d "$HOME/.elan/bin" ]; then
  export PATH="$HOME/.elan/bin:$PATH"
fi
command -v lake >/dev/null 2>&1 && HAS_LAKE=1
command -v java >/dev/null 2>&1 && HAS_JAVA=1

ISABELLE_BIN=""
ISABELLE_LOCAL_ERROR=""
if ISABELLE_BIN="$(riina_require_local_isabelle "$REPO_ROOT" 2>&1)"; then
  HAS_ISABELLE=1
  riina_export_local_isabelle_env "$ISABELLE_BIN"
else
  ISABELLE_LOCAL_ERROR="$ISABELLE_BIN"
  ISABELLE_BIN=""
fi

if [ -z "${TLA2TOOLS_JAR:-}" ] && [ -f "$FORMAL_TOOLS_DIR/tla2tools.jar" ]; then
  TLA2TOOLS_JAR="$FORMAL_TOOLS_DIR/tla2tools.jar"
fi
if [ -z "${ALLOY_JAR:-}" ] && [ -f "$FORMAL_TOOLS_DIR/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar" ]; then
  ALLOY_JAR="$FORMAL_TOOLS_DIR/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar"
fi

[ -n "${TLA2TOOLS_JAR:-}" ] && [ -f "${TLA2TOOLS_JAR:-}" ] && HAS_TLA2TOOLS_JAR=1
[ -n "${ALLOY_JAR:-}" ] && [ -f "${ALLOY_JAR:-}" ] && HAS_ALLOY_JAR=1

if [ "$PROVISION_TOOLS" = "1" ] \
  && [ "$HAS_JAVA" -eq 1 ] \
  && { [ "$HAS_TLA2TOOLS_JAR" -eq 0 ] || [ "$HAS_ALLOY_JAR" -eq 0 ]; }; then
  PROVISION_ATTEMPTED=1
  if [ -x "$REPO_ROOT/scripts/provision-formal-tools.sh" ] \
    && bash "$REPO_ROOT/scripts/provision-formal-tools.sh" >/dev/null 2>&1; then
    PROVISION_SUCCEEDED=1
    [ -z "${TLA2TOOLS_JAR:-}" ] && [ -f "$FORMAL_TOOLS_DIR/tla2tools.jar" ] \
      && TLA2TOOLS_JAR="$FORMAL_TOOLS_DIR/tla2tools.jar"
    if [ -z "${ALLOY_JAR:-}" ]; then
      default_alloy_jar="$FORMAL_TOOLS_DIR/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar"
      [ -f "$default_alloy_jar" ] && ALLOY_JAR="$default_alloy_jar"
    fi
    [ -n "${TLA2TOOLS_JAR:-}" ] && [ -f "${TLA2TOOLS_JAR:-}" ] && HAS_TLA2TOOLS_JAR=1
    [ -n "${ALLOY_JAR:-}" ] && [ -f "${ALLOY_JAR:-}" ] && HAS_ALLOY_JAR=1
  fi
fi

# ---------------------------------------------------------------------------
# Dimension 1: Type-system soundness promotion foundation
# ---------------------------------------------------------------------------
DIM1_STATUS="FAIL"
DIM1_PROMOTION_READY="false"

coq_type_files=(
  "type_system/Progress.v"
  "type_system/Preservation.v"
  "type_system/TypeSafety.v"
)
lean_type_files=(
  "$LEAN_TYPE_DIR/Progress.lean"
  "$LEAN_TYPE_DIR/Preservation.lean"
  "$LEAN_TYPE_DIR/TypeSafety.lean"
)
isa_type_files=(
  "$ISA_DIR/TypeSystem/Progress.thy"
  "$ISA_DIR/TypeSystem/Preservation.thy"
  "$ISA_DIR/TypeSystem/TypeSafety.thy"
)

coq_type_ok=1
for rel in "${coq_type_files[@]}"; do
  [ -f "$COQ_DIR/$rel" ] || coq_type_ok=0
  grep -Fxq "$rel" "$COQ_PROJECT" || coq_type_ok=0
done

coq_type_theorems="$(grep -Eh '^(Theorem|Lemma) ' "${coq_type_files[@]/#/$COQ_DIR/}" 2>/dev/null | wc -l | tr -d ' ')"

lean_type_ok=1
for f in "${lean_type_files[@]}"; do
  [ -f "$f" ] || lean_type_ok=0
done

lean_actionable_sorry=0
for f in "${lean_type_files[@]}"; do
  [ -f "$f" ] || continue
  hits="$(grep -nE '\bsorry\b' "$f" 2>/dev/null | grep -vc "complex match, needs manual translation" || true)"
  lean_actionable_sorry=$((lean_actionable_sorry + hits))
done

lean_build_ok=0
lean_build_mode="missing_lake"
lean_build_tail=""
if [ "$HAS_LAKE" -eq 1 ] && [ "$lean_type_ok" -eq 1 ]; then
  lean_tmp="$(mktemp)"
  if (
    cd "$LEAN_DIR"
    run_with_timeout 240 lake build \
      RIINA.TypeSystem.Progress \
      RIINA.TypeSystem.Preservation \
      RIINA.TypeSystem.TypeSafety
  ) >"$lean_tmp" 2>&1; then
    lean_build_ok=1
    lean_build_mode="lake_core_build"
  else
    lean_build_mode="lake_core_build_failed"
    lean_build_tail="$(tail -n 12 "$lean_tmp" | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')"
  fi
  rm -f "$lean_tmp"
fi

isa_type_ok=1
for f in "${isa_type_files[@]}"; do
  [ -f "$f" ] || isa_type_ok=0
done
isa_type_theorems="$(grep -Eh '^(theorem|lemma) ' "${isa_type_files[@]}" 2>/dev/null | wc -l | tr -d ' ')"

isabelle_build_ok=0
isabelle_build_mode="missing_local_isabelle"
if [ "$HAS_ISABELLE" -eq 1 ]; then
  isa_tmp="$(mktemp)"
  isa_core_tmp="$(mktemp -d "$REPO_ROOT/.isabelle-core.XXXXXX")"

  cp "$ISA_DIR/TypeSystem/Progress.thy" "$isa_core_tmp/Progress.thy"
  cp "$ISA_DIR/TypeSystem/Preservation.thy" "$isa_core_tmp/Preservation.thy"
  cp "$ISA_DIR/TypeSystem/TypeSafety.thy" "$isa_core_tmp/TypeSafety.thy"
  cat > "$isa_core_tmp/ROOT" <<'EOF_ROOT'
session RIINA_CORE = HOL +
  theories
    Progress
    Preservation
    TypeSafety
EOF_ROOT
  chmod 755 "$isa_core_tmp"
  chmod 644 "$isa_core_tmp"/Progress.thy "$isa_core_tmp"/Preservation.thy "$isa_core_tmp"/TypeSafety.thy "$isa_core_tmp"/ROOT

  if run_with_timeout 900 "$ISABELLE_BIN" build -d "$isa_core_tmp" -b RIINA_CORE >"$isa_tmp" 2>&1; then
    isabelle_build_ok=1
    isabelle_build_mode="isabelle_core_build_local"
  else
    isabelle_build_mode="isabelle_core_build_local_failed"
  fi

  rm -f "$isa_tmp"
  rm -rf "$isa_core_tmp"
fi

if [ "$coq_type_ok" -eq 1 ] && [ "$coq_type_theorems" -gt 0 ] \
  && [ "$lean_type_ok" -eq 1 ] && [ "$lean_build_ok" -eq 1 ] && [ "$lean_actionable_sorry" -eq 0 ] \
  && [ "$isa_type_ok" -eq 1 ] && [ "$isa_type_theorems" -gt 0 ]; then
  DIM1_STATUS="PASS"
fi

if [ "$DIM1_STATUS" = "PASS" ] && [ "$isabelle_build_ok" -eq 1 ]; then
  DIM1_PROMOTION_READY="true"
fi

DIM1_DETAIL="coq_core=$coq_type_ok coq_thm=$coq_type_theorems lean_core=$lean_type_ok lean_build=$lean_build_ok lean_mode=$lean_build_mode lean_actionable_sorry=$lean_actionable_sorry isa_core=$isa_type_ok isa_thm=$isa_type_theorems isa_build=$isabelle_build_ok isa_mode=$isabelle_build_mode"
if [ -n "$ISABELLE_LOCAL_ERROR" ]; then
  DIM1_DETAIL="$DIM1_DETAIL isa_local_error=$ISABELLE_LOCAL_ERROR"
fi
if [ -n "$lean_build_tail" ]; then
  DIM1_DETAIL="$DIM1_DETAIL lean_tail=$lean_build_tail"
fi

# ---------------------------------------------------------------------------
# Dimension 9: Protocol correctness promotion foundation
# ---------------------------------------------------------------------------
DIM9_STATUS="FAIL"
DIM9_PROMOTION_READY="false"

protocols=(SessionTypes AuthenticationProtocols VerifiedProtocols)

dim9_files_ok=1
coq_proto_files=()
tla_proto_files=()
alloy_proto_files=()
for p in "${protocols[@]}"; do
  c="$COQ_DIR/domains/${p}.v"
  t="$TLA_DIR/${p}.tla"
  a="$ALLOY_DIR/${p}.als"
  coq_proto_files+=("$c")
  tla_proto_files+=("$t")
  alloy_proto_files+=("$a")
  [ -f "$c" ] || dim9_files_ok=0
  [ -f "$t" ] || dim9_files_ok=0
  [ -f "$a" ] || dim9_files_ok=0
  grep -Fxq "domains/${p}.v" "$COQ_PROJECT" || dim9_files_ok=0
done

coq_proto_theorems="$( (grep -Eh '^(Theorem|Lemma) ' "${coq_proto_files[@]}" || true) | wc -l | tr -d ' ' )"
tla_proto_theorems="$( (grep -Eh '^[[:space:]]*THEOREM[[:space:]]' "${tla_proto_files[@]}" || true) | wc -l | tr -d ' ' )"
alloy_proto_asserts="$( (grep -Eh '^[[:space:]]*(assert|check)[[:space:]]' "${alloy_proto_files[@]}" || true) | wc -l | tr -d ' ' )"

tla_static_ok=1
for f in "${tla_proto_files[@]}"; do
  [ -f "$f" ] || tla_static_ok=0
  grep -q '^---- MODULE ' "$f" || tla_static_ok=0
  grep -q '^====$' "$f" || tla_static_ok=0
done

alloy_static_ok=1
for f in "${alloy_proto_files[@]}"; do
  [ -f "$f" ] || alloy_static_ok=0
  grep -Eq '^[[:space:]]*module[[:space:]]+' "$f" || alloy_static_ok=0
  grep -Eq '^[[:space:]]*assert[[:space:]]+' "$f" || alloy_static_ok=0
  grep -Eq '^[[:space:]]*check[[:space:]]+' "$f" || alloy_static_ok=0
done

tla_exec_ok=0
tla_exec_mode="static_only"
if [ "$HAS_JAVA" -eq 1 ] && [ "$HAS_TLA2TOOLS_JAR" -eq 1 ]; then
  tla_exec_ok=1
  tla_exec_mode="sany_parse"
  for f in "${tla_proto_files[@]}"; do
    if ! (
      cd "$TLA_DIR"
      run_with_timeout 90 java -cp "$TLA2TOOLS_JAR" tla2sany.SANY "$(basename "$f")"
    ) >/dev/null 2>&1; then
      tla_exec_ok=0
      tla_exec_mode="sany_parse_failed"
      break
    fi
  done
fi

alloy_exec_ok=0
alloy_exec_mode="static_only"
if [ "$HAS_JAVA" -eq 1 ] && [ "$HAS_ALLOY_JAR" -eq 1 ]; then
  ALLOY_EXEC_CLASS="${ALLOY_CLI_CLASS:-org.alloytools.alloy.core.infra.Alloy}"
  alloy_exec_ok=1
  alloy_exec_mode="jar_commands"
  for f in "${alloy_proto_files[@]}"; do
    if ! run_with_timeout 90 \
      java -cp "$ALLOY_JAR" "$ALLOY_EXEC_CLASS" commands "$f" >/dev/null 2>&1; then
      alloy_exec_ok=0
      alloy_exec_mode="jar_commands_failed"
      break
    fi
  done
fi

if [ "$dim9_files_ok" -eq 1 ] && [ "$coq_proto_theorems" -gt 0 ] \
  && [ "$tla_proto_theorems" -gt 0 ] && [ "$alloy_proto_asserts" -gt 0 ] \
  && [ "$tla_static_ok" -eq 1 ] && [ "$alloy_static_ok" -eq 1 ]; then
  DIM9_STATUS="PASS"
fi

if [ "$DIM9_STATUS" = "PASS" ] && [ "$tla_exec_ok" -eq 1 ] && [ "$alloy_exec_ok" -eq 1 ]; then
  DIM9_PROMOTION_READY="true"
fi

DIM9_DETAIL="files=$dim9_files_ok coq_thm=$coq_proto_theorems tla_thm=$tla_proto_theorems alloy_assert=$alloy_proto_asserts tla_static=$tla_static_ok alloy_static=$alloy_static_ok tla_exec=$tla_exec_ok tla_mode=$tla_exec_mode alloy_exec=$alloy_exec_ok alloy_mode=$alloy_exec_mode"

OVERALL_FOUNDATION="PASS"
if [ "$DIM1_STATUS" != "PASS" ] || [ "$DIM9_STATUS" != "PASS" ]; then
  OVERALL_FOUNDATION="FAIL"
fi

OVERALL_PROMOTION_READY="false"
if [ "$DIM1_PROMOTION_READY" = "true" ] && [ "$DIM9_PROMOTION_READY" = "true" ]; then
  OVERALL_PROMOTION_READY="true"
fi

echo ""
echo "Dimension 1 (type-system core)   : $DIM1_STATUS (promotion_ready=$DIM1_PROMOTION_READY)"
echo "Dimension 9 (protocol core)      : $DIM9_STATUS (promotion_ready=$DIM9_PROMOTION_READY)"
echo "Overall foundation               : $OVERALL_FOUNDATION"
echo "Overall promotion readiness      : $OVERALL_PROMOTION_READY"
if [ -n "$ISABELLE_LOCAL_ERROR" ]; then
  echo -e "${YELLOW}Local Isabelle enforcement: $ISABELLE_LOCAL_ERROR${NC}"
fi

cat > "$REPORT_PATH" <<EOF_JSON
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "repo_head": "$(git rev-parse HEAD)",
  "scope": "dim1_dim9_promotion_readiness",
  "strict_tools": $STRICT_TOOLS,
  "provision": {
    "requested": $([ "$PROVISION_TOOLS" = "1" ] && echo "true" || echo "false"),
    "attempted": $([ "$PROVISION_ATTEMPTED" -eq 1 ] && echo "true" || echo "false"),
    "succeeded": $([ "$PROVISION_SUCCEEDED" -eq 1 ] && echo "true" || echo "false")
  },
  "tools": {
    "lake": $([ "$HAS_LAKE" -eq 1 ] && echo "true" || echo "false"),
    "isabelle": $([ "$HAS_ISABELLE" -eq 1 ] && echo "true" || echo "false"),
    "docker": false,
    "isabelle_bin": "$(escape_json "${ISABELLE_BIN:-}")",
    "isabelle_local_error": "$(escape_json "${ISABELLE_LOCAL_ERROR:-}")",
    "java": $([ "$HAS_JAVA" -eq 1 ] && echo "true" || echo "false"),
    "tla2tools_jar": $([ "$HAS_TLA2TOOLS_JAR" -eq 1 ] && echo "true" || echo "false"),
    "alloy_jar": $([ "$HAS_ALLOY_JAR" -eq 1 ] && echo "true" || echo "false"),
    "tla2tools_path": "$(escape_json "${TLA2TOOLS_JAR:-}")",
    "alloy_path": "$(escape_json "${ALLOY_JAR:-}")"
  },
  "dimension_1": {
    "status": "$DIM1_STATUS",
    "promotion_ready": $DIM1_PROMOTION_READY,
    "checks": {
      "coq_core": $([ "$coq_type_ok" -eq 1 ] && echo "true" || echo "false"),
      "coq_theorem_count": $coq_type_theorems,
      "lean_core": $([ "$lean_type_ok" -eq 1 ] && echo "true" || echo "false"),
      "lean_build": $([ "$lean_build_ok" -eq 1 ] && echo "true" || echo "false"),
      "lean_actionable_sorry": $lean_actionable_sorry,
      "isabelle_core": $([ "$isa_type_ok" -eq 1 ] && echo "true" || echo "false"),
      "isabelle_theorem_count": $isa_type_theorems,
      "isabelle_build": $([ "$isabelle_build_ok" -eq 1 ] && echo "true" || echo "false")
    },
    "detail": "$(escape_json "$DIM1_DETAIL")"
  },
  "dimension_9": {
    "status": "$DIM9_STATUS",
    "promotion_ready": $DIM9_PROMOTION_READY,
    "checks": {
      "files": $([ "$dim9_files_ok" -eq 1 ] && echo "true" || echo "false"),
      "coq_theorem_count": $coq_proto_theorems,
      "tla_theorem_count": $tla_proto_theorems,
      "alloy_assert_count": $alloy_proto_asserts,
      "tla_static": $([ "$tla_static_ok" -eq 1 ] && echo "true" || echo "false"),
      "alloy_static": $([ "$alloy_static_ok" -eq 1 ] && echo "true" || echo "false"),
      "tla_exec": $([ "$tla_exec_ok" -eq 1 ] && echo "true" || echo "false"),
      "alloy_exec": $([ "$alloy_exec_ok" -eq 1 ] && echo "true" || echo "false")
    },
    "detail": "$(escape_json "$DIM9_DETAIL")"
  },
  "overall_foundation": "$OVERALL_FOUNDATION",
  "overall_promotion_ready": $OVERALL_PROMOTION_READY
}
EOF_JSON

echo "Report: $REPORT_PATH"

if [ "$STRICT_TOOLS" -eq 1 ] && [ -n "$ISABELLE_LOCAL_ERROR" ]; then
  echo -e "${RED}Strict tool mode requires pinned local Isabelle; run bash scripts/provision-isabelle.sh.${NC}"
  exit 1
fi

if [ "$STRICT_TOOLS" -eq 1 ] && [ "$OVERALL_PROMOTION_READY" != "true" ]; then
  echo -e "${RED}Strict tool mode requested and promotion readiness is not complete.${NC}"
  exit 1
fi

if [ "$OVERALL_FOUNDATION" != "PASS" ]; then
  echo -e "${YELLOW}Foundation gaps detected (non-blocking in default mode).${NC}"
  exit 0
fi

if [ "$OVERALL_PROMOTION_READY" != "true" ]; then
  echo -e "${YELLOW}Foundation pass, promotion not yet complete (expected until tool lanes are executable).${NC}"
else
  echo -e "${GREEN}Dim1/Dim9 promotion readiness complete.${NC}"
fi

exit 0
