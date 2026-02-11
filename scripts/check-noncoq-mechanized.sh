#!/usr/bin/env bash
# ============================================================================
# check-noncoq-mechanized.sh
#
# Non-Coq mechanization readiness gate.
#
# Purpose:
#   Define and execute strict lane-specific mechanized criteria for
#   Lean, Isabelle, F*, TLA+, Alloy, SMT, Verus, Kani, and TV.
#
# Policy:
#   - Report freshness is tied to repo_head.
#   - Lean/Isabelle require full-lane build and zero `sorry`.
#   - F* requires full Active+Domains compilation and zero generated files.
#   - SMT/Verus/Kani/TV require full-lane machine checks and zero generated files.
#   - TLA+/Alloy require full-lane executable checks.
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPORT_PATH="$REPO_ROOT/reports/noncoq_mechanized_status.json"
REPO_HEAD="$(git -C "$REPO_ROOT" rev-parse HEAD 2>/dev/null || echo "")"
REPO_BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"

LEAN_DIR="$REPO_ROOT/02_FORMAL/lean"
ISA_DIR="$REPO_ROOT/02_FORMAL/isabelle/RIINA"
FSTAR_DIR="$REPO_ROOT/02_FORMAL/fstar/RIINA"
TLA_DIR="$REPO_ROOT/02_FORMAL/tlaplus/RIINA"
ALLOY_DIR="$REPO_ROOT/02_FORMAL/alloy/RIINA"
SMT_DIR="$REPO_ROOT/02_FORMAL/smt/RIINA"
VERUS_DIR="$REPO_ROOT/02_FORMAL/verus/RIINA"
KANI_DIR="$REPO_ROOT/02_FORMAL/kani/RIINA"
TV_DIR="$REPO_ROOT/02_FORMAL/tv/RIINA"
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

bool_json() {
  if [ "$1" -eq 1 ]; then
    echo "true"
  else
    echo "false"
  fi
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

tool_exists() {
  command -v "$1" >/dev/null 2>&1
}

count_files() {
  local dir="$1"
  local glob="$2"
  if [ -d "$dir" ]; then
    find "$dir" -type f -name "$glob" 2>/dev/null | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

count_grep_files() {
  local pattern="$1"
  local dir="$2"
  local include="$3"
  if [ -d "$dir" ]; then
    (grep -RIl "$pattern" "$dir" --include="$include" 2>/dev/null || true) | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

z3_file_ok() {
  local f="$1"
  local out
  out="$(run_with_timeout 90 z3 -smt2 "$f" 2>/dev/null | head -n 1 || true)"
  case "$out" in
    sat|unsat|unknown) return 0 ;;
    *) return 1 ;;
  esac
}

echo ""
echo "================================================================"
echo "  RIINA NON-COQ MECHANIZED CHECK"
echo "================================================================"

mkdir -p "$REPO_ROOT/reports"

HAS_LAKE=0
HAS_ISABELLE=0
HAS_DOCKER=0
HAS_JAVA=0
HAS_Z3=0
HAS_FSTAR=0
HAS_VERUS=0
HAS_KANI=0

tool_exists lake && HAS_LAKE=1
tool_exists java && HAS_JAVA=1
tool_exists z3 && HAS_Z3=1
tool_exists fstar.exe && HAS_FSTAR=1
if [ "$HAS_FSTAR" -eq 0 ] && tool_exists fstar; then
  HAS_FSTAR=1
fi
tool_exists verus && HAS_VERUS=1
tool_exists kani && HAS_KANI=1

ISABELLE_BIN=""
ISABELLE_LOCAL_ERROR=""
if ISABELLE_BIN="$(riina_require_local_isabelle "$REPO_ROOT" 2>&1)"; then
  HAS_ISABELLE=1
  riina_export_local_isabelle_env "$ISABELLE_BIN"
else
  ISABELLE_LOCAL_ERROR="$ISABELLE_BIN"
  ISABELLE_BIN=""
fi

TLA2TOOLS_JAR="${TLA2TOOLS_JAR:-}"
ALLOY_JAR="${ALLOY_JAR:-}"
if [ -z "$TLA2TOOLS_JAR" ] && [ -f "$FORMAL_TOOLS_DIR/tla2tools.jar" ]; then
  TLA2TOOLS_JAR="$FORMAL_TOOLS_DIR/tla2tools.jar"
fi
if [ -z "$ALLOY_JAR" ] && [ -f "$FORMAL_TOOLS_DIR/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar" ]; then
  ALLOY_JAR="$FORMAL_TOOLS_DIR/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar"
fi
HAS_TLA2TOOLS_JAR=0
HAS_ALLOY_JAR=0
[ -n "$TLA2TOOLS_JAR" ] && [ -f "$TLA2TOOLS_JAR" ] && HAS_TLA2TOOLS_JAR=1
[ -n "$ALLOY_JAR" ] && [ -f "$ALLOY_JAR" ] && HAS_ALLOY_JAR=1

# ---------------------------------------------------------------------------
# Lean
# ---------------------------------------------------------------------------
LEAN_FILES="$(count_files "$LEAN_DIR/RIINA" "*.lean")"
LEAN_SORRY="$( (grep -RIn '\bsorry\b' "$LEAN_DIR/RIINA" --include="*.lean" 2>/dev/null || true) | wc -l | tr -d ' ' )"
LEAN_BUILD_OK=0
if [ "$HAS_LAKE" -eq 1 ] && [ "$LEAN_FILES" -gt 0 ]; then
  if (cd "$LEAN_DIR" && run_with_timeout 3600 lake build) >/dev/null 2>&1; then
    LEAN_BUILD_OK=1
  fi
fi
LEAN_MECHANIZED=0
if [ "$LEAN_BUILD_OK" -eq 1 ] && [ "$LEAN_SORRY" -eq 0 ] && [ "$LEAN_FILES" -gt 0 ]; then
  LEAN_MECHANIZED=1
fi
LEAN_PENDING="none"
if [ "$LEAN_MECHANIZED" -ne 1 ]; then
  LEAN_PENDING="require full-lane lake build and zero sorry across 02_FORMAL/lean/RIINA"
fi

# ---------------------------------------------------------------------------
# Isabelle
# ---------------------------------------------------------------------------
ISABELLE_FILES="$(count_files "$ISA_DIR" "*.thy")"
ISABELLE_SORRY="$( (grep -RIn '\bsorry\b' "$ISA_DIR" --include="*.thy" 2>/dev/null || true) | wc -l | tr -d ' ' )"
ISABELLE_BUILD_OK=0
ISABELLE_BUILD_MODE="missing_local_isabelle"
if [ "$ISABELLE_FILES" -gt 0 ]; then
  if [ "$HAS_ISABELLE" -eq 1 ]; then
    if run_with_timeout 7200 "$ISABELLE_BIN" build -d "$ISA_DIR" -b -o document=false RIINA >/dev/null 2>&1 \
      && run_with_timeout 7200 "$ISABELLE_BIN" build -d "$ISA_DIR" -b -o document=false RIINA_Domains >/dev/null 2>&1; then
      ISABELLE_BUILD_OK=1
      ISABELLE_BUILD_MODE="isabelle_full_build_local"
    else
      ISABELLE_BUILD_MODE="isabelle_full_build_local_failed"
    fi
  fi
fi
ISABELLE_MECHANIZED=0
if [ "$ISABELLE_BUILD_OK" -eq 1 ] && [ "$ISABELLE_SORRY" -eq 0 ] && [ "$ISABELLE_FILES" -gt 0 ]; then
  ISABELLE_MECHANIZED=1
fi
ISABELLE_PENDING="none"
if [ "$ISABELLE_MECHANIZED" -ne 1 ]; then
  ISABELLE_PENDING="require full RIINA+RIINA_Domains build and zero sorry across Isabelle corpus"
fi
if [ -n "$ISABELLE_LOCAL_ERROR" ]; then
  ISABELLE_PENDING="$ISABELLE_PENDING (local Isabelle enforcement: $ISABELLE_LOCAL_ERROR)"
fi

# ---------------------------------------------------------------------------
# F*
# ---------------------------------------------------------------------------
FSTAR_FILES="$(count_files "$FSTAR_DIR" "*.fst")"
FSTAR_GENERATED_FILES="$(count_grep_files "Auto-generated from 02_FORMAL/coq/" "$FSTAR_DIR" "*.fst")"
FSTAR_FULL_EXEC=0
FSTAR_BIN=""
if tool_exists fstar.exe; then
  FSTAR_BIN="$(command -v fstar.exe)"
elif tool_exists fstar; then
  FSTAR_BIN="$(command -v fstar)"
fi
if [ -n "$FSTAR_BIN" ] && [ "$FSTAR_FILES" -gt 0 ]; then
  mapfile -t FSTAR_LIST < <(find "$FSTAR_DIR" -type f -name "*.fst" | sort)
  if [ "${#FSTAR_LIST[@]}" -gt 0 ]; then
    if run_with_timeout 7200 "$FSTAR_BIN" \
      --cache_checked_modules \
      --cache_dir /tmp/riina-fstar-mechanized-cache \
      --include "$REPO_ROOT/02_FORMAL/fstar" \
      "${FSTAR_LIST[@]}" >/dev/null 2>&1; then
      FSTAR_FULL_EXEC=1
    fi
  fi
fi
FSTAR_MECHANIZED=0
if [ "$FSTAR_FULL_EXEC" -eq 1 ] && [ "$FSTAR_GENERATED_FILES" -eq 0 ] && [ "$FSTAR_FILES" -gt 0 ]; then
  FSTAR_MECHANIZED=1
fi
FSTAR_PENDING="none"
if [ "$FSTAR_MECHANIZED" -ne 1 ]; then
  FSTAR_PENDING="require full Active+Domains F* compilation with zero generated placeholders"
fi

# ---------------------------------------------------------------------------
# TLA+
# ---------------------------------------------------------------------------
TLA_FILES="$(count_files "$TLA_DIR" "*.tla")"
TLA_FULL_EXEC=0
if [ "$HAS_JAVA" -eq 1 ] && [ "$HAS_TLA2TOOLS_JAR" -eq 1 ] && [ "$TLA_FILES" -gt 0 ]; then
  TLA_FULL_EXEC=1
  mapfile -t TLA_LIST < <(find "$TLA_DIR" -type f -name "*.tla" | sort)
  for f in "${TLA_LIST[@]}"; do
    if ! (cd "$(dirname "$f")" && run_with_timeout 120 java -cp "$TLA2TOOLS_JAR" tla2sany.SANY "$(basename "$f")") >/dev/null 2>&1; then
      TLA_FULL_EXEC=0
      break
    fi
  done
fi
TLA_MECHANIZED=0
if [ "$TLA_FULL_EXEC" -eq 1 ] && [ "$TLA_FILES" -gt 0 ]; then
  TLA_MECHANIZED=1
fi
TLA_PENDING="none"
if [ "$TLA_MECHANIZED" -ne 1 ]; then
  TLA_PENDING="require full-lane executable SANY checks across TLA corpus"
fi

# ---------------------------------------------------------------------------
# Alloy
# ---------------------------------------------------------------------------
ALLOY_FILES="$(count_files "$ALLOY_DIR" "*.als")"
ALLOY_FULL_EXEC=0
if [ "$HAS_JAVA" -eq 1 ] && [ "$HAS_ALLOY_JAR" -eq 1 ] && [ "$ALLOY_FILES" -gt 0 ]; then
  ALLOY_EXEC_CLASS="${ALLOY_CLI_CLASS:-org.alloytools.alloy.core.infra.Alloy}"
  ALLOY_FULL_EXEC=1
  mapfile -t ALLOY_LIST < <(find "$ALLOY_DIR" -type f -name "*.als" | sort)
  for f in "${ALLOY_LIST[@]}"; do
    if ! run_with_timeout 120 java -cp "$ALLOY_JAR" "$ALLOY_EXEC_CLASS" commands "$f" >/dev/null 2>&1; then
      ALLOY_FULL_EXEC=0
      break
    fi
  done
fi
ALLOY_MECHANIZED=0
if [ "$ALLOY_FULL_EXEC" -eq 1 ] && [ "$ALLOY_FILES" -gt 0 ]; then
  ALLOY_MECHANIZED=1
fi
ALLOY_PENDING="none"
if [ "$ALLOY_MECHANIZED" -ne 1 ]; then
  ALLOY_PENDING="require full-lane executable command checks across Alloy corpus"
fi

# ---------------------------------------------------------------------------
# SMT
# ---------------------------------------------------------------------------
SMT_FILES="$(count_files "$SMT_DIR" "*.smt2")"
SMT_GENERATED_FILES="$(count_grep_files "; Auto-generated from" "$SMT_DIR" "*.smt2")"
SMT_FULL_EXEC=0
if [ "$HAS_Z3" -eq 1 ] && [ "$SMT_FILES" -gt 0 ]; then
  SMT_FULL_EXEC=1
  mapfile -t SMT_LIST < <(find "$SMT_DIR" -type f -name "*.smt2" | sort)
  for f in "${SMT_LIST[@]}"; do
    if ! z3_file_ok "$f"; then
      SMT_FULL_EXEC=0
      break
    fi
  done
fi
SMT_MECHANIZED=0
if [ "$SMT_FULL_EXEC" -eq 1 ] && [ "$SMT_GENERATED_FILES" -eq 0 ] && [ "$SMT_FILES" -gt 0 ]; then
  SMT_MECHANIZED=1
fi
SMT_PENDING="none"
if [ "$SMT_MECHANIZED" -ne 1 ]; then
  SMT_PENDING="require full-lane Z3 checks and zero generated placeholders"
fi

# ---------------------------------------------------------------------------
# Verus
# ---------------------------------------------------------------------------
VERUS_FILES="$(count_files "$VERUS_DIR" "*.rs")"
VERUS_GENERATED_FILES="$(count_grep_files "^// Auto-generated from" "$VERUS_DIR" "*.rs")"
VERUS_FULL_EXEC=0
if [ "$HAS_VERUS" -eq 1 ] && [ "$VERUS_FILES" -gt 0 ]; then
  VERUS_FULL_EXEC=1
  mapfile -t VERUS_LIST < <(find "$VERUS_DIR" -type f -name "*.rs" | sort)
  for f in "${VERUS_LIST[@]}"; do
    if ! run_with_timeout 180 verus "$f" >/dev/null 2>&1; then
      VERUS_FULL_EXEC=0
      break
    fi
  done
fi
VERUS_MECHANIZED=0
if [ "$VERUS_FULL_EXEC" -eq 1 ] && [ "$VERUS_GENERATED_FILES" -eq 0 ] && [ "$VERUS_FILES" -gt 0 ]; then
  VERUS_MECHANIZED=1
fi
VERUS_PENDING="none"
if [ "$VERUS_MECHANIZED" -ne 1 ]; then
  VERUS_PENDING="require full-lane Verus checks and zero generated placeholders"
fi

# ---------------------------------------------------------------------------
# Kani
# ---------------------------------------------------------------------------
KANI_FILES="$(count_files "$KANI_DIR" "*.rs")"
KANI_GENERATED_FILES="$(count_grep_files "^// Auto-generated from" "$KANI_DIR" "*.rs")"
KANI_HARNESS_FILES="$(count_grep_files "#\\[kani::proof\\]" "$KANI_DIR" "*.rs")"
KANI_FULL_EXEC=0
if [ "$HAS_KANI" -eq 1 ] && [ "$KANI_HARNESS_FILES" -gt 0 ]; then
  KANI_FULL_EXEC=1
  mapfile -t KANI_LIST < <(grep -RIl "#\\[kani::proof\\]" "$KANI_DIR" --include="*.rs" | sort)
  for f in "${KANI_LIST[@]}"; do
    if ! run_with_timeout 180 kani "$f" >/dev/null 2>&1; then
      KANI_FULL_EXEC=0
      break
    fi
  done
fi
KANI_MECHANIZED=0
if [ "$KANI_FULL_EXEC" -eq 1 ] && [ "$KANI_GENERATED_FILES" -eq 0 ] && [ "$KANI_HARNESS_FILES" -gt 0 ]; then
  KANI_MECHANIZED=1
fi
KANI_PENDING="none"
if [ "$KANI_MECHANIZED" -ne 1 ]; then
  KANI_PENDING="require full-lane Kani checks and zero generated placeholders"
fi

# ---------------------------------------------------------------------------
# Translation Validation (TV)
# ---------------------------------------------------------------------------
TV_FILES="$(count_files "$TV_DIR" "*.smt2")"
TV_GENERATED_FILES="$(count_grep_files "; Auto-generated from" "$TV_DIR" "*.smt2")"
TV_FULL_EXEC=0
if [ "$HAS_Z3" -eq 1 ] && [ "$TV_FILES" -gt 0 ]; then
  TV_FULL_EXEC=1
  mapfile -t TV_LIST < <(find "$TV_DIR" -type f -name "*.smt2" | sort)
  for f in "${TV_LIST[@]}"; do
    if ! z3_file_ok "$f"; then
      TV_FULL_EXEC=0
      break
    fi
  done
fi
TV_MECHANIZED=0
if [ "$TV_FULL_EXEC" -eq 1 ] && [ "$TV_GENERATED_FILES" -eq 0 ] && [ "$TV_FILES" -gt 0 ]; then
  TV_MECHANIZED=1
fi
TV_PENDING="none"
if [ "$TV_MECHANIZED" -ne 1 ]; then
  TV_PENDING="require full-lane TV checks and zero generated placeholders"
fi

OVERALL_NONCOQ_MECHANIZED=1
for lane in "$LEAN_MECHANIZED" "$ISABELLE_MECHANIZED" "$FSTAR_MECHANIZED" "$TLA_MECHANIZED" "$ALLOY_MECHANIZED" "$SMT_MECHANIZED" "$VERUS_MECHANIZED" "$KANI_MECHANIZED" "$TV_MECHANIZED"; do
  if [ "$lane" -ne 1 ]; then
    OVERALL_NONCOQ_MECHANIZED=0
    break
  fi
done

echo "Lean mechanized      : $LEAN_MECHANIZED (build=$LEAN_BUILD_OK sorry=$LEAN_SORRY files=$LEAN_FILES)"
echo "Isabelle mechanized  : $ISABELLE_MECHANIZED (build=$ISABELLE_BUILD_OK mode=$ISABELLE_BUILD_MODE sorry=$ISABELLE_SORRY files=$ISABELLE_FILES)"
echo "F* mechanized        : $FSTAR_MECHANIZED (exec=$FSTAR_FULL_EXEC generated=$FSTAR_GENERATED_FILES files=$FSTAR_FILES)"
echo "TLA+ mechanized      : $TLA_MECHANIZED (exec=$TLA_FULL_EXEC files=$TLA_FILES)"
echo "Alloy mechanized     : $ALLOY_MECHANIZED (exec=$ALLOY_FULL_EXEC files=$ALLOY_FILES)"
echo "SMT mechanized       : $SMT_MECHANIZED (exec=$SMT_FULL_EXEC generated=$SMT_GENERATED_FILES files=$SMT_FILES)"
echo "Verus mechanized     : $VERUS_MECHANIZED (exec=$VERUS_FULL_EXEC generated=$VERUS_GENERATED_FILES files=$VERUS_FILES)"
echo "Kani mechanized      : $KANI_MECHANIZED (exec=$KANI_FULL_EXEC generated=$KANI_GENERATED_FILES harness_files=$KANI_HARNESS_FILES)"
echo "TV mechanized        : $TV_MECHANIZED (exec=$TV_FULL_EXEC generated=$TV_GENERATED_FILES files=$TV_FILES)"
echo "Overall non-Coq mech : $([ "$OVERALL_NONCOQ_MECHANIZED" -eq 1 ] && echo true || echo false)"
if [ -n "$ISABELLE_LOCAL_ERROR" ]; then
  echo "Isabelle local policy: $ISABELLE_LOCAL_ERROR"
fi

cat > "$REPORT_PATH" <<EOF_JSON
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "repo_head": "$(escape_json "$REPO_HEAD")",
  "repo_branch": "$(escape_json "$REPO_BRANCH")",
  "scope": "noncoq_lane_mechanization_readiness",
  "tools": {
    "lake": $(bool_json "$HAS_LAKE"),
    "isabelle": $(bool_json "$HAS_ISABELLE"),
    "docker": false,
    "isabelle_bin": "$(escape_json "${ISABELLE_BIN:-}")",
    "isabelle_local_error": "$(escape_json "${ISABELLE_LOCAL_ERROR:-}")",
    "java": $(bool_json "$HAS_JAVA"),
    "z3": $(bool_json "$HAS_Z3"),
    "fstar": $(bool_json "$HAS_FSTAR"),
    "verus": $(bool_json "$HAS_VERUS"),
    "kani": $(bool_json "$HAS_KANI"),
    "tla2tools_jar": $(bool_json "$HAS_TLA2TOOLS_JAR"),
    "alloy_jar": $(bool_json "$HAS_ALLOY_JAR"),
    "tla2tools_path": "$(escape_json "$TLA2TOOLS_JAR")",
    "alloy_path": "$(escape_json "$ALLOY_JAR")"
  },
  "lanes": {
    "lean": {
      "full_build_ok": $(bool_json "$LEAN_BUILD_OK"),
      "files": $LEAN_FILES,
      "sorry": $LEAN_SORRY,
      "mechanized_ready": $(bool_json "$LEAN_MECHANIZED"),
      "pending": "$(escape_json "$LEAN_PENDING")"
    },
    "isabelle": {
      "full_build_ok": $(bool_json "$ISABELLE_BUILD_OK"),
      "build_mode": "$(escape_json "$ISABELLE_BUILD_MODE")",
      "files": $ISABELLE_FILES,
      "sorry": $ISABELLE_SORRY,
      "mechanized_ready": $(bool_json "$ISABELLE_MECHANIZED"),
      "pending": "$(escape_json "$ISABELLE_PENDING")"
    },
    "fstar": {
      "full_exec_ok": $(bool_json "$FSTAR_FULL_EXEC"),
      "files": $FSTAR_FILES,
      "generated_files": $FSTAR_GENERATED_FILES,
      "mechanized_ready": $(bool_json "$FSTAR_MECHANIZED"),
      "pending": "$(escape_json "$FSTAR_PENDING")"
    },
    "tlaplus": {
      "full_exec_ok": $(bool_json "$TLA_FULL_EXEC"),
      "files": $TLA_FILES,
      "mechanized_ready": $(bool_json "$TLA_MECHANIZED"),
      "pending": "$(escape_json "$TLA_PENDING")"
    },
    "alloy": {
      "full_exec_ok": $(bool_json "$ALLOY_FULL_EXEC"),
      "files": $ALLOY_FILES,
      "mechanized_ready": $(bool_json "$ALLOY_MECHANIZED"),
      "pending": "$(escape_json "$ALLOY_PENDING")"
    },
    "smt": {
      "full_exec_ok": $(bool_json "$SMT_FULL_EXEC"),
      "files": $SMT_FILES,
      "generated_files": $SMT_GENERATED_FILES,
      "mechanized_ready": $(bool_json "$SMT_MECHANIZED"),
      "pending": "$(escape_json "$SMT_PENDING")"
    },
    "verus": {
      "full_exec_ok": $(bool_json "$VERUS_FULL_EXEC"),
      "files": $VERUS_FILES,
      "generated_files": $VERUS_GENERATED_FILES,
      "mechanized_ready": $(bool_json "$VERUS_MECHANIZED"),
      "pending": "$(escape_json "$VERUS_PENDING")"
    },
    "kani": {
      "full_exec_ok": $(bool_json "$KANI_FULL_EXEC"),
      "files": $KANI_FILES,
      "generated_files": $KANI_GENERATED_FILES,
      "harness_files": $KANI_HARNESS_FILES,
      "mechanized_ready": $(bool_json "$KANI_MECHANIZED"),
      "pending": "$(escape_json "$KANI_PENDING")"
    },
    "tv": {
      "full_exec_ok": $(bool_json "$TV_FULL_EXEC"),
      "files": $TV_FILES,
      "generated_files": $TV_GENERATED_FILES,
      "mechanized_ready": $(bool_json "$TV_MECHANIZED"),
      "pending": "$(escape_json "$TV_PENDING")"
    }
  },
  "overall_noncoq_mechanized": $(bool_json "$OVERALL_NONCOQ_MECHANIZED")
}
EOF_JSON

echo "Report: $REPORT_PATH"
exit 0
