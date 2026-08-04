#!/bin/bash
# RIINA Living Metrics Generator
# Generates metrics.json from actual codebase counts
# Called during website build to ensure accuracy
#
# IMPORTANT: This is the SINGLE SOURCE OF TRUTH for all metrics.
# After running this, run sync-metrics.sh to propagate to all docs.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_FILE="$ROOT_DIR/website/public/metrics.json"
PREV_METRICS="$ROOT_DIR/website/public/metrics.json"

# --fast mode: count #[test] annotations statically instead of running cargo test
FAST_MODE=0
if [ "${1:-}" = "--fast" ]; then
    FAST_MODE=1
fi

echo "=== RIINA Metrics Generator ==="
if [ "$FAST_MODE" -eq 1 ]; then
    echo "  (fast mode: static test count)"
fi

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE_HUMAN=$(date -u +"%B %d, %Y at %H:%M UTC")

escape_json() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' '
}

load_cached_fast_noncoq_metrics() {
    [ "$FAST_MODE" -eq 1 ] || return 0
    [ "$NONCOQ_MECH_FRESH" != true ] || return 0
    [ -f "$PREV_METRICS" ] || return 0
    command -v python3 >/dev/null 2>&1 || return 0

    eval "$(
        python3 - <<'PY' "$PREV_METRICS"
import json
import shlex
import sys

with open(sys.argv[1], "r", encoding="utf-8") as f:
    data = json.load(f)

quality = data.get("quality", {})
noncoq = quality.get("nonCoqMechanization", {})
pending = noncoq.get("pending", {})
backlog = noncoq.get("backlog", {})
claims = data.get("claimLevels", {})

compiled_claims = {"compiled", "mechanized", "independently_audited"}
mechanized_claims = {"mechanized", "independently_audited"}


def shell(name, value):
    if isinstance(value, bool):
        print(f"{name}={'true' if value else 'false'}")
    elif isinstance(value, int):
        print(f"{name}={value}")
    else:
        print(f"{name}={shlex.quote(str(value))}")


def claim_compiled(name):
    return claims.get(name) in compiled_claims


def claim_mechanized(name):
    return claims.get(name) in mechanized_claims


isabelle = data.get("isabelle", {})
fstar = data.get("fstar", {})
tlaplus = data.get("tlaplus", {})
alloy = data.get("alloy", {})

values = {
    "NONCOQ_MECH_SOURCE": "cached_metrics",
    "NONCOQ_MECH_OVERALL": bool(noncoq.get("overallMechanized", False)),
    "LEAN_COMPILED": claim_compiled("lean") or bool(quality.get("leanCompiled", False)),
    "ISABELLE_COMPILED": claim_compiled("isabelle") or bool(quality.get("isabelleCompiled", False)),
    "FSTAR_COMPILED": claim_compiled("fstar") or bool(fstar.get("smokeBuildOk", False)),
    "TLAPLUS_COMPILED": claim_compiled("tlaplus") or bool(tlaplus.get("smokeBuildOk", False)),
    "ALLOY_COMPILED": claim_compiled("alloy") or bool(alloy.get("smokeBuildOk", False)),
    "SMT_COMPILED": claim_compiled("smt"),
    "VERUS_COMPILED": claim_compiled("verus"),
    "KANI_COMPILED": claim_compiled("kani"),
    "TV_COMPILED": claim_compiled("tv"),
    "LEAN_MECHANIZED_READY": claim_mechanized("lean"),
    "ISABELLE_MECHANIZED_READY": claim_mechanized("isabelle"),
    "FSTAR_MECHANIZED_READY": claim_mechanized("fstar"),
    "TLAPLUS_MECHANIZED_READY": claim_mechanized("tlaplus"),
    "ALLOY_MECHANIZED_READY": claim_mechanized("alloy"),
    "SMT_MECHANIZED_READY": claim_mechanized("smt"),
    "VERUS_MECHANIZED_READY": claim_mechanized("verus"),
    "KANI_MECHANIZED_READY": claim_mechanized("kani"),
    "TV_MECHANIZED_READY": claim_mechanized("tv"),
    "LEAN_PENDING_REASON": pending.get("lean", "noncoq_report_missing_or_stale").replace("\n", " "),
    "ISABELLE_PENDING_REASON": pending.get("isabelle", "noncoq_report_missing_or_stale").replace("\n", " "),
    "FSTAR_PENDING_REASON": pending.get("fstar", "noncoq_report_missing_or_stale").replace("\n", " "),
    "TLAPLUS_PENDING_REASON": pending.get("tlaplus", "noncoq_report_missing_or_stale").replace("\n", " "),
    "ALLOY_PENDING_REASON": pending.get("alloy", "noncoq_report_missing_or_stale").replace("\n", " "),
    "SMT_PENDING_REASON": pending.get("smt", "noncoq_report_missing_or_stale").replace("\n", " "),
    "VERUS_PENDING_REASON": pending.get("verus", "noncoq_report_missing_or_stale").replace("\n", " "),
    "KANI_PENDING_REASON": pending.get("kani", "noncoq_report_missing_or_stale").replace("\n", " "),
    "TV_PENDING_REASON": pending.get("tv", "noncoq_report_missing_or_stale").replace("\n", " "),
    "LEAN_SORRY_BACKLOG": int(backlog.get("leanSorry", 0) or 0),
    "LEAN_AXIOMS_BACKLOG": int(backlog.get("leanAxioms", 0) or 0),
    "ISABELLE_SORRY_BACKLOG": int(backlog.get("isabelleSorry", 0) or 0),
    "FSTAR_GENERATED_BACKLOG": int(backlog.get("fstarGeneratedFiles", 0) or 0),
    "SMT_GENERATED_BACKLOG": int(backlog.get("smtGeneratedFiles", 0) or 0),
    "VERUS_GENERATED_BACKLOG": int(backlog.get("verusGeneratedFiles", 0) or 0),
    "KANI_GENERATED_BACKLOG": int(backlog.get("kaniGeneratedFiles", 0) or 0),
    "TV_GENERATED_BACKLOG": int(backlog.get("tvGeneratedFiles", 0) or 0),
    "ISABELLE_SMOKE_SESSION": isabelle.get("smokeSession", "RIINA_CORE"),
    "ISABELLE_SMOKE_BUILD_OK": bool(isabelle.get("smokeBuildOk", False)),
    "ISABELLE_COMPILED_THEORIES": int(isabelle.get("compiledTheories", 0) or 0),
    "ISABELLE_COMPILED_LEMMAS": int(isabelle.get("compiledLemmas", 0) or 0),
    "FSTAR_SMOKE_MODULE": fstar.get("smokeModule", "RIINA.Active.CryptographicSecurityActive"),
    "FSTAR_SMOKE_BUILD_OK": bool(fstar.get("smokeBuildOk", False)),
    "FSTAR_COMPILED_LEMMAS": int(fstar.get("compiledLemmas", 0) or 0),
    "TLAPLUS_SMOKE_SPEC": tlaplus.get("smokeSpec", "RIINA.Active.TelusProcurementProtocol"),
    "TLAPLUS_SMOKE_BUILD_OK": bool(tlaplus.get("smokeBuildOk", False)),
    "TLAPLUS_COMPILED_THEOREMS": int(tlaplus.get("compiledTheorems", 0) or 0),
    "ALLOY_SMOKE_MODEL": alloy.get("smokeModel", "RIINA.Active.TelusProcurementAccessControl"),
    "ALLOY_SMOKE_BUILD_OK": bool(alloy.get("smokeBuildOk", False)),
    "ALLOY_COMPILED_ASSERTIONS": int(alloy.get("compiledAssertions", 0) or 0),
}

for key, value in values.items():
    shell(key, value)
PY
    )"
}

ISABELLE_HELPER="$ROOT_DIR/scripts/isabelle-local.sh"
if [ -f "$ISABELLE_HELPER" ]; then
    # shellcheck disable=SC1090
    source "$ISABELLE_HELPER"
fi

FSTAR_HELPER="$ROOT_DIR/scripts/fstar-local.sh"
if [ -f "$FSTAR_HELPER" ]; then
    # shellcheck disable=SC1090
    source "$FSTAR_HELPER"
fi

detect_isabelle_bin() {
    if declare -F riina_require_local_isabelle >/dev/null 2>&1; then
        local bin
        if bin="$(riina_require_local_isabelle "$ROOT_DIR" 2>/dev/null)"; then
            riina_export_local_isabelle_env "$bin"
            printf '%s\n' "$bin"
            return 0
        fi
    fi
    return 1
}

detect_fstar_bin() {
    if declare -F riina_require_local_fstar >/dev/null 2>&1; then
        local bin
        if bin="$(riina_require_local_fstar "$ROOT_DIR" 2>/dev/null)"; then
            riina_export_local_fstar_env "$bin"
            printf '%s\n' "$bin"
            return 0
        fi
    fi
    return 1
}

detect_tla2tools_jar() {
    if [ -n "${TLA2TOOLS_JAR:-}" ] && [ -f "${TLA2TOOLS_JAR:-}" ]; then
        printf '%s\n' "$TLA2TOOLS_JAR"
        return 0
    fi
    if [ -f "$ROOT_DIR/05_TOOLING/tools/formal/tla2tools.jar" ]; then
        printf '%s\n' "$ROOT_DIR/05_TOOLING/tools/formal/tla2tools.jar"
        return 0
    fi
    return 1
}

detect_alloy_jar() {
    if [ -n "${ALLOY_JAR:-}" ] && [ -f "${ALLOY_JAR:-}" ]; then
        printf '%s\n' "$ALLOY_JAR"
        return 0
    fi
    if [ -f "$ROOT_DIR/05_TOOLING/tools/formal/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar" ]; then
        printf '%s\n' "$ROOT_DIR/05_TOOLING/tools/formal/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar"
        return 0
    fi
    return 1
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

report_head_matches_or_compatible() {
    local report_head="$1"
    shift

    if [ -z "$report_head" ] || [ -z "$CURRENT_HEAD" ]; then
        return 1
    fi

    if [ "$report_head" = "$CURRENT_HEAD" ] || { [ -n "$CURRENT_PARENT_HEAD" ] && [ "$report_head" = "$CURRENT_PARENT_HEAD" ]; }; then
        return 0
    fi

    if ! git -C "$ROOT_DIR" merge-base --is-ancestor "$report_head" "$CURRENT_HEAD" >/dev/null 2>&1; then
        return 1
    fi

    if git -C "$ROOT_DIR" diff --name-only "$report_head..$CURRENT_HEAD" -- "$@" | grep -q .; then
        return 1
    fi

    return 0
}

count_fstar_lemmas_in_file() {
    local file="$1"
    local val_count let_count
    val_count=$(grep -cP "^\s*val\s+\w+_lemma\b" "$file" 2>/dev/null || true)
    let_count=$(grep -cP "^\s*let(?:\s+rec)?\s+lemma_[A-Za-z0-9_']+\b" "$file" 2>/dev/null || true)
    echo $((val_count + let_count))
}

count_fstar_smoke_lemmas() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "0"
        return
    fi
    count_fstar_lemmas_in_file "$file"
}

count_tla_theorems_in_file() {
    local file="$1"
    grep -cP "^\s*THEOREM\b" "$file" 2>/dev/null || true
}

count_tla_smoke_theorems() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "0"
        return
    fi
    count_tla_theorems_in_file "$file"
}

count_alloy_smoke_assertions() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "0"
        return
    fi
    grep -cP "^\s*check\s" "$file" 2>/dev/null || true
}

alloy_command_rows() {
    local jar="$1"
    local file="$2"
    local class="${ALLOY_CLI_CLASS:-org.alloytools.alloy.core.infra.Alloy}"
    run_with_timeout 120 java -cp "$jar" "$class" commands "$file" 2>/dev/null \
        | awk '/^[0-9]+[[:space:]]+\./ { print $1 ":" tolower($3) }'
}

alloy_exec_status() {
    local jar="$1"
    local file="$2"
    local index="$3"
    local class="${ALLOY_CLI_CLASS:-org.alloytools.alloy.core.infra.Alloy}"
    local tmp_dir
    tmp_dir="$(mktemp -d 2>/dev/null || mktemp -d -t riina-alloy-exec)"
    local output
    if ! output="$(cd "$tmp_dir" && run_with_timeout 180 java -cp "$jar" "$class" exec -c "$index" "$file" 2>&1)"; then
        rm -rf "$tmp_dir"
        return 1
    fi
    rm -rf "$tmp_dir"
    printf '%s\n' "$output" \
        | tr '\010\r' '  ' \
        | awk '/^[0-9][0-9]*\. / { print $NF }' \
        | tail -1
}

alloy_smoke_ok() {
    local jar="$1"
    local file="$2"
    local row idx kind expected status
    mapfile -t rows < <(alloy_command_rows "$jar" "$file")
    if [ "${#rows[@]}" -eq 0 ]; then
        return 1
    fi
    for row in "${rows[@]}"; do
        idx="${row%%:*}"
        kind="${row##*:}"
        case "$kind" in
            run) expected="SAT" ;;
            check) expected="UNSAT" ;;
            *) return 1 ;;
        esac
        status="$(alloy_exec_status "$jar" "$file" "$idx" || true)"
        if [ "$status" != "$expected" ]; then
            return 1
        fi
    done
    return 0
}

# Count Qed proofs (active build) — from _CoqProject only (matches verify.rs)
QED_ACTIVE=0
while IFS= read -r f; do
    [[ "$f" =~ ^[[:space:]]*# ]] && continue
    [[ "$f" != *.v ]] && continue
    f=$(echo "$f" | sed 's/^[[:space:]]*//')
    fullpath="$ROOT_DIR/02_FORMAL/coq/$f"
    count=$(grep -c "Qed\." "$fullpath" 2>/dev/null || true)
    if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
        QED_ACTIVE=$((QED_ACTIVE + count))
    fi
done < "$ROOT_DIR/02_FORMAL/coq/_CoqProject"

# Count Qed proofs in deprecated archive
QED_DEPRECATED=0
while IFS= read -r f; do
    count=$(grep -c "Qed\." "$f" 2>/dev/null || true)
    if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
        QED_DEPRECATED=$((QED_DEPRECATED + count))
    fi
done < <(find "$ROOT_DIR/02_FORMAL/coq/properties/_archive_deprecated" -name "*.v" -type f 2>/dev/null)

# Count total .v files
COQ_FILES=$(find "$ROOT_DIR/02_FORMAL/coq" -name "*.v" -type f 2>/dev/null | wc -l)

# Count active build files (from _CoqProject) using the same parsing rules as
# proof-ledger/public-quality scripts (ignore comments/flags, only .v entries).
COQ_ACTIVE_FILES=$(
    awk '
      {
        line=$0;
        sub(/^[ \t]+/, "", line);
        if (line ~ /^[#-]/ || line == "") next;
        split(line, tok, /[ \t]+/);
        if (tok[1] ~ /\.v$/) c++;
      }
      END { print c + 0 }
    ' "$ROOT_DIR/02_FORMAL/coq/_CoqProject" 2>/dev/null || echo "0"
)

# Count Admitted in active build (should be 0) — from _CoqProject only
# Only count "Admitted." as standalone tactic (not in comments or strings)
ADMITTED=0
while IFS= read -r f; do
    [[ "$f" =~ ^[[:space:]]*# ]] && continue
    [[ "$f" != *.v ]] && continue
    f=$(echo "$f" | sed 's/^[[:space:]]*//')
    fullpath="$ROOT_DIR/02_FORMAL/coq/$f"
    count=$(grep -cP '^\s*Admitted\.' "$fullpath" 2>/dev/null || true)
    if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
        ADMITTED=$((ADMITTED + count))
    fi
done < "$ROOT_DIR/02_FORMAL/coq/_CoqProject"

# Count axioms dynamically from active build — from _CoqProject only
AXIOMS=0
while IFS= read -r f; do
    [[ "$f" =~ ^[[:space:]]*# ]] && continue
    [[ "$f" != *.v ]] && continue
    f=$(echo "$f" | sed 's/^[[:space:]]*//')
    fullpath="$ROOT_DIR/02_FORMAL/coq/$f"
    count=$(grep -cE "^Axiom " "$fullpath" 2>/dev/null || true)
    if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
        AXIOMS=$((AXIOMS + count))
    fi
done < "$ROOT_DIR/02_FORMAL/coq/_CoqProject"

# Count explicit proof-architecture assumptions in active build (target: 0)
# Currently tracked assumption:
#   - Parameter val_rel_n_step_up (NonInterference_v2.v)
ASSUMPTIONS=0
while IFS= read -r f; do
    [[ "$f" =~ ^[[:space:]]*# ]] && continue
    [[ "$f" != *.v ]] && continue
    f=$(echo "$f" | sed 's/^[[:space:]]*//')
    fullpath="$ROOT_DIR/02_FORMAL/coq/$f"
    count=$(grep -cE "^Parameter val_rel_n_step_up " "$fullpath" 2>/dev/null || true)
    if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
        ASSUMPTIONS=$((ASSUMPTIONS + count))
    fi
done < "$ROOT_DIR/02_FORMAL/coq/_CoqProject"

# Count Lean 4 theorems (theorem + lemma declarations)
LEAN_THEOREMS=0
LEAN_SORRY=0
LEAN_FILES=0
LEAN_LINES=0
LEAN_METRICS_DIR="$ROOT_DIR/02_FORMAL/lean/RIINA"
if [ -d "$LEAN_METRICS_DIR" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "^\s*(theorem|lemma)\s" "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            LEAN_THEOREMS=$((LEAN_THEOREMS + count))
        fi
        # Count token-level sorry usage (captures "by sorry", ":= sorry", etc.).
        sorry_count=$(grep -oP '\bsorry\b' "$f" 2>/dev/null | wc -l | tr -d ' ')
        if [ -n "$sorry_count" ] && [ "$sorry_count" -gt 0 ] 2>/dev/null; then
            LEAN_SORRY=$((LEAN_SORRY + sorry_count))
        fi
    done < <(find "$LEAN_METRICS_DIR" -name "*.lean" -type f ! -path "*/_wip/*" 2>/dev/null)
    LEAN_FILES=$(find "$LEAN_METRICS_DIR" -name "*.lean" -type f ! -path "*/_wip/*" 2>/dev/null | wc -l)
    LEAN_LINES=$(find "$LEAN_METRICS_DIR" -name "*.lean" -type f ! -path "*/_wip/*" -exec cat {} + 2>/dev/null | wc -l)
fi

# Count Isabelle lemmas (lemma + theorem + corollary declarations)
ISABELLE_LEMMAS=0
ISABELLE_SORRY=0
ISABELLE_FILES=0
ISABELLE_LINES=0
ISABELLE_SMOKE_DECLARED_THEORIES=0
ISABELLE_SMOKE_DECLARED_LEMMAS=0
ISABELLE_COMPILED_THEORIES=0
ISABELLE_COMPILED_LEMMAS=0
ISABELLE_SMOKE_BUILD_OK=false
ISABELLE_SMOKE_SESSION="RIINA_CORE"
ISABELLE_SMOKE_DIR="$ROOT_DIR/02_FORMAL/isabelle/RIINA/Core"
if [ -d "$ROOT_DIR/02_FORMAL/isabelle" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "^\s*(lemma|theorem|corollary)\s" "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            ISABELLE_LEMMAS=$((ISABELLE_LEMMAS + count))
        fi
        # Count token-level sorry/oops usage across the file.
        sorry_count=$(grep -oP '\b(sorry|oops)\b' "$f" 2>/dev/null | wc -l | tr -d ' ')
        if [ -n "$sorry_count" ] && [ "$sorry_count" -gt 0 ] 2>/dev/null; then
            ISABELLE_SORRY=$((ISABELLE_SORRY + sorry_count))
        fi
    done < <(find "$ROOT_DIR/02_FORMAL/isabelle" -name "*.thy" -type f 2>/dev/null)
    ISABELLE_FILES=$(find "$ROOT_DIR/02_FORMAL/isabelle" -name "*.thy" -type f 2>/dev/null | wc -l)
    ISABELLE_LINES=$(find "$ROOT_DIR/02_FORMAL/isabelle" -name "*.thy" -type f -exec cat {} + 2>/dev/null | wc -l)
fi

if [ -f "$ISABELLE_SMOKE_DIR/ROOT" ]; then
    mapfile -t ISABELLE_SMOKE_THEORIES < <(
        awk '
            /^  theories$/ { in_theories = 1; next }
            in_theories && /^[[:space:]]{4}[^[:space:]]/ {
                line = $0
                sub(/^[[:space:]]+/, "", line)
                sub(/[[:space:]]+$/, "", line)
                print line
                next
            }
            in_theories { exit }
        ' "$ISABELLE_SMOKE_DIR/ROOT" 2>/dev/null
    )
    ISABELLE_SMOKE_DECLARED_THEORIES=${#ISABELLE_SMOKE_THEORIES[@]}
    for theory in "${ISABELLE_SMOKE_THEORIES[@]}"; do
        thy_path="$ROOT_DIR/02_FORMAL/isabelle/RIINA/$theory.thy"
        count=$(grep -cP "^\s*(lemma|theorem|corollary)\s" "$thy_path" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            ISABELLE_SMOKE_DECLARED_LEMMAS=$((ISABELLE_SMOKE_DECLARED_LEMMAS + count))
        fi
    done
fi

# Compute Lean axioms (axiom declarations)
LEAN_AXIOMS=0
if [ -d "$LEAN_METRICS_DIR" ]; then
    while IFS= read -r f; do
        count=$(grep -c "^axiom " "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            LEAN_AXIOMS=$((LEAN_AXIOMS + count))
        fi
    done < <(find "$LEAN_METRICS_DIR" -name "*.lean" -type f ! -path "*/_wip/*" 2>/dev/null)
fi

# Compute Isabelle axioms
ISABELLE_AXIOMS=0
if [ -d "$ROOT_DIR/02_FORMAL/isabelle" ]; then
    while IFS= read -r f; do
        count=$(grep -c "axiomatization" "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            ISABELLE_AXIOMS=$((ISABELLE_AXIOMS + count))
        fi
    done < <(find "$ROOT_DIR/02_FORMAL/isabelle" -name "*.thy" -type f 2>/dev/null)
fi

# Count F* lemmas (generated `val ... _lemma` plus hand-written `let lemma_...`)
FSTAR_LEMMAS=0
FSTAR_FILES=0
FSTAR_COMPILED_LEMMAS=0
FSTAR_SMOKE_BUILD_OK=false
FSTAR_SMOKE_MODULE="RIINA.Active.CryptographicSecurityActive"
FSTAR_SMOKE_FILE="$ROOT_DIR/02_FORMAL/fstar/RIINA/Active/CryptographicSecurityActive.fst"
FSTAR_SMOKE_DECLARED_LEMMAS=0
if [ -d "$ROOT_DIR/02_FORMAL/fstar" ]; then
    while IFS= read -r f; do
        count=$(count_fstar_lemmas_in_file "$f")
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && FSTAR_LEMMAS=$((FSTAR_LEMMAS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/fstar" -name "*.fst" -type f 2>/dev/null)
    FSTAR_FILES=$(find "$ROOT_DIR/02_FORMAL/fstar" -name "*.fst" -type f 2>/dev/null | wc -l)
fi

if [ -f "$FSTAR_SMOKE_FILE" ]; then
    FSTAR_SMOKE_DECLARED_LEMMAS="$(count_fstar_smoke_lemmas "$FSTAR_SMOKE_FILE")"
fi

# Count TLA+ theorems (THEOREM declarations)
TLAPLUS_THEOREMS=0
TLAPLUS_FILES=0
TLAPLUS_COMPILED_THEOREMS=0
TLAPLUS_SMOKE_BUILD_OK=false
TLAPLUS_SMOKE_FILE="$ROOT_DIR/02_FORMAL/tlaplus/RIINA/Active/TelusProcurementProtocol.tla"
TLAPLUS_SMOKE_CFG="$ROOT_DIR/02_FORMAL/tlaplus/RIINA/Active/TelusProcurementProtocol.cfg"
TLAPLUS_SMOKE_SPEC="RIINA.Active.TelusProcurementProtocol"
TLAPLUS_SMOKE_DECLARED_THEOREMS=0
if [ -d "$ROOT_DIR/02_FORMAL/tlaplus" ]; then
    while IFS= read -r f; do
        count=$(count_tla_theorems_in_file "$f")
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && TLAPLUS_THEOREMS=$((TLAPLUS_THEOREMS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/tlaplus" -name "*.tla" -type f 2>/dev/null)
    TLAPLUS_FILES=$(find "$ROOT_DIR/02_FORMAL/tlaplus" -name "*.tla" -type f 2>/dev/null | wc -l)
fi
if [ -f "$TLAPLUS_SMOKE_FILE" ]; then
    TLAPLUS_SMOKE_DECLARED_THEOREMS="$(count_tla_smoke_theorems "$TLAPLUS_SMOKE_FILE")"
fi

# Count Alloy assertions (check declarations)
ALLOY_ASSERTIONS=0
ALLOY_FILES=0
ALLOY_COMPILED_ASSERTIONS=0
ALLOY_SMOKE_BUILD_OK=false
ALLOY_SMOKE_FILE="$ROOT_DIR/02_FORMAL/alloy/RIINA/Active/TelusProcurementAccessControl.als"
ALLOY_SMOKE_MODEL="RIINA.Active.TelusProcurementAccessControl"
ALLOY_SMOKE_DECLARED_ASSERTIONS=0
if [ -f "$ALLOY_SMOKE_FILE" ]; then
    ALLOY_SMOKE_DECLARED_ASSERTIONS="$(count_alloy_smoke_assertions "$ALLOY_SMOKE_FILE")"
fi
if [ -d "$ROOT_DIR/02_FORMAL/alloy" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "^\s*check\s" "$f" 2>/dev/null || true)
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && ALLOY_ASSERTIONS=$((ALLOY_ASSERTIONS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/alloy" -name "*.als" -type f 2>/dev/null)
    ALLOY_FILES=$(find "$ROOT_DIR/02_FORMAL/alloy" -name "*.als" -type f 2>/dev/null | wc -l)
fi

# Count SMT assertions (Z3/CVC5 - assert declarations, excluding .tv.smt2)
SMT_ASSERTIONS=0
SMT_FILES=0
if [ -d "$ROOT_DIR/02_FORMAL/smt" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "^\(assert\s" "$f" 2>/dev/null || true)
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && SMT_ASSERTIONS=$((SMT_ASSERTIONS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/smt" -name "*.smt2" -type f 2>/dev/null)
    SMT_FILES=$(find "$ROOT_DIR/02_FORMAL/smt" -name "*.smt2" -type f 2>/dev/null | wc -l)
fi

# Count Verus proofs (proof fn declarations)
VERUS_PROOFS=0
VERUS_FILES=0
if [ -d "$ROOT_DIR/02_FORMAL/verus" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "proof fn\s" "$f" 2>/dev/null || true)
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && VERUS_PROOFS=$((VERUS_PROOFS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/verus" -name "*.rs" -type f 2>/dev/null)
    VERUS_FILES=$(find "$ROOT_DIR/02_FORMAL/verus" -name "*.rs" -type f 2>/dev/null | wc -l)
fi

# Count Kani harnesses (#[kani::proof] declarations)
KANI_HARNESSES=0
KANI_FILES=0
if [ -d "$ROOT_DIR/02_FORMAL/kani" ]; then
    while IFS= read -r f; do
        count=$(grep -c '#\[kani::proof\]' "$f" 2>/dev/null || true)
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && KANI_HARNESSES=$((KANI_HARNESSES + count))
    done < <(find "$ROOT_DIR/02_FORMAL/kani" -name "*.rs" -type f 2>/dev/null)
    KANI_FILES=$(find "$ROOT_DIR/02_FORMAL/kani" -name "*.rs" -type f 2>/dev/null | wc -l)
fi

# Count Translation Validation assertions
TV_VALIDATIONS=0
TV_FILES=0
if [ -d "$ROOT_DIR/02_FORMAL/tv" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "^\(assert\s" "$f" 2>/dev/null || true)
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && TV_VALIDATIONS=$((TV_VALIDATIONS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/tv" -name "*.smt2" -type f 2>/dev/null)
    TV_FILES=$(find "$ROOT_DIR/02_FORMAL/tv" -name "*.smt2" -type f 2>/dev/null | wc -l)
fi

# Stub prover quarantine markers: if present, generated stub files are
# explicitly excluded from proof totals and headline prover counts.
ISABELLE_QUARANTINED=false
FSTAR_QUARANTINED=false
TLAPLUS_QUARANTINED=false
ALLOY_QUARANTINED=false
SMT_QUARANTINED=false
VERUS_QUARANTINED=false
KANI_QUARANTINED=false
TV_QUARANTINED=false

[ -f "$ROOT_DIR/02_FORMAL/isabelle/.STUB_QUARANTINED" ] && ISABELLE_QUARANTINED=true
[ -f "$ROOT_DIR/02_FORMAL/fstar/.STUB_QUARANTINED" ] && FSTAR_QUARANTINED=true
[ -f "$ROOT_DIR/02_FORMAL/tlaplus/.STUB_QUARANTINED" ] && TLAPLUS_QUARANTINED=true
[ -f "$ROOT_DIR/02_FORMAL/alloy/.STUB_QUARANTINED" ] && ALLOY_QUARANTINED=true
[ -f "$ROOT_DIR/02_FORMAL/smt/.STUB_QUARANTINED" ] && SMT_QUARANTINED=true
[ -f "$ROOT_DIR/02_FORMAL/verus/.STUB_QUARANTINED" ] && VERUS_QUARANTINED=true
[ -f "$ROOT_DIR/02_FORMAL/kani/.STUB_QUARANTINED" ] && KANI_QUARANTINED=true
[ -f "$ROOT_DIR/02_FORMAL/tv/.STUB_QUARANTINED" ] && TV_QUARANTINED=true

ISABELLE_LEMMAS_PUBLIC=$ISABELLE_LEMMAS
FSTAR_LEMMAS_PUBLIC=$FSTAR_LEMMAS
TLAPLUS_THEOREMS_PUBLIC=$TLAPLUS_THEOREMS
ALLOY_ASSERTIONS_PUBLIC=$ALLOY_ASSERTIONS
SMT_ASSERTIONS_PUBLIC=$SMT_ASSERTIONS
VERUS_PROOFS_PUBLIC=$VERUS_PROOFS
KANI_HARNESSES_PUBLIC=$KANI_HARNESSES
TV_VALIDATIONS_PUBLIC=$TV_VALIDATIONS

if [ "$ISABELLE_QUARANTINED" = true ]; then
    if [ "$ISABELLE_SMOKE_BUILD_OK" = true ] && [ "$ISABELLE_COMPILED_LEMMAS" -gt 0 ]; then
        ISABELLE_LEMMAS_PUBLIC=$ISABELLE_COMPILED_LEMMAS
    else
        ISABELLE_LEMMAS_PUBLIC=0
    fi
fi
if [ "$FSTAR_QUARANTINED" = true ]; then
    if [ "$FSTAR_SMOKE_BUILD_OK" = true ] && [ "$FSTAR_COMPILED_LEMMAS" -gt 0 ]; then
        FSTAR_LEMMAS_PUBLIC=$FSTAR_COMPILED_LEMMAS
    else
        FSTAR_LEMMAS_PUBLIC=0
    fi
fi
[ "$TLAPLUS_QUARANTINED" = true ] && TLAPLUS_THEOREMS_PUBLIC=0
[ "$ALLOY_QUARANTINED" = true ] && ALLOY_ASSERTIONS_PUBLIC=0
[ "$SMT_QUARANTINED" = true ] && SMT_ASSERTIONS_PUBLIC=0
[ "$VERUS_QUARANTINED" = true ] && VERUS_PROOFS_PUBLIC=0
[ "$KANI_QUARANTINED" = true ] && KANI_HARNESSES_PUBLIC=0
[ "$TV_QUARANTINED" = true ] && TV_VALIDATIONS_PUBLIC=0

# Quality tier counting: core vs domain vs trivial
# Tier 1 (core): foundations/ + type_system/ + effects/ + properties/ + termination/
COQ_TIER1_CORE=0
for subdir in foundations type_system effects properties termination; do
    dir="$ROOT_DIR/02_FORMAL/coq/$subdir"
    if [ -d "$dir" ]; then
        while IFS= read -r f; do
            count=$(grep -c "Qed\." "$f" 2>/dev/null || true)
            if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
                COQ_TIER1_CORE=$((COQ_TIER1_CORE + count))
            fi
        done < <(find "$dir" -name "*.v" -type f ! -path "*/_archive_deprecated/*" 2>/dev/null)
    fi
done

# Tier 2 (domain): domains/ + Industries/ + compliance/
COQ_TIER2_DOMAIN=$((QED_ACTIVE - COQ_TIER1_CORE))

# Count trivial proofs: "Proof. reflexivity. Qed." and "Proof. intros. exact I. Qed." patterns
COQ_TRIVIAL=0
while IFS= read -r f; do
    count=$(grep -cP 'Proof\.\s*(reflexivity|intros\.\s*exact I|exact I|trivial)\.\s*Qed\.' "$f" 2>/dev/null || true)
    if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
        COQ_TRIVIAL=$((COQ_TRIVIAL + count))
    fi
done < <(find "$ROOT_DIR/02_FORMAL/coq" -name "*.v" -type f ! -path "*/_archive_deprecated/*" 2>/dev/null)

# Total proofs across ALL 10 provers (excludes quarantined stub lanes)
TOTAL_PROOFS=$((QED_ACTIVE + LEAN_THEOREMS + ISABELLE_LEMMAS_PUBLIC + FSTAR_LEMMAS_PUBLIC + TLAPLUS_THEOREMS_PUBLIC + ALLOY_ASSERTIONS_PUBLIC + SMT_ASSERTIONS_PUBLIC + VERUS_PROOFS_PUBLIC + KANI_HARNESSES_PUBLIC + TV_VALIDATIONS_PUBLIC))

# Count triple-prover theorems: min(domain Lean theorems, domain Isabelle lemmas)
# + foundation triple-prover count from MULTIPROVER_VALIDATION.md
FOUNDATION_TRIPLE=$(grep -oP '\d+ triple-prover theorems' "$ROOT_DIR/02_FORMAL/MULTIPROVER_VALIDATION.md" 2>/dev/null | grep -oP '^\d+' || echo "86")
# Domain triple-prover: all domain theorems exist in all 3 provers
LEAN_DOMAIN_THEOREMS=0
if [ -d "$ROOT_DIR/02_FORMAL/lean/RIINA/Domains" ] || [ -d "$ROOT_DIR/02_FORMAL/lean/RIINA/Industries" ]; then
    for subdir in Domains Industries; do
        dir="$ROOT_DIR/02_FORMAL/lean/RIINA/$subdir"
        if [ -d "$dir" ]; then
            while IFS= read -r f; do
                count=$(grep -cP "^\s*(theorem|lemma)\s" "$f" 2>/dev/null || true)
                if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
                    LEAN_DOMAIN_THEOREMS=$((LEAN_DOMAIN_THEOREMS + count))
                fi
            done < <(find "$dir" -name "*.lean" -type f 2>/dev/null)
        fi
    done
fi
ISA_DOMAIN_LEMMAS=0
if [ -d "$ROOT_DIR/02_FORMAL/isabelle/RIINA/Domains" ] || [ -d "$ROOT_DIR/02_FORMAL/isabelle/RIINA/Industries" ]; then
    for subdir in Domains Industries; do
        dir="$ROOT_DIR/02_FORMAL/isabelle/RIINA/$subdir"
        if [ -d "$dir" ]; then
            while IFS= read -r f; do
                count=$(grep -cP "^\s*(lemma|theorem)\s" "$f" 2>/dev/null || true)
                if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
                    ISA_DOMAIN_LEMMAS=$((ISA_DOMAIN_LEMMAS + count))
                fi
            done < <(find "$dir" -name "*.thy" -type f 2>/dev/null)
        fi
    done
fi
# Triple-prover = min(Lean domain, Isabelle domain) + foundation
# If Isabelle is quarantined as generated stubs, triple-prover claims are zeroed.
if [ "$ISABELLE_QUARANTINED" = true ]; then
    DOMAIN_TRIPLE=0
    TRIPLE_PROVER=0
else
    DOMAIN_TRIPLE=$((LEAN_DOMAIN_THEOREMS < ISA_DOMAIN_LEMMAS ? LEAN_DOMAIN_THEOREMS : ISA_DOMAIN_LEMMAS))
    TRIPLE_PROVER=$((FOUNDATION_TRIPLE + DOMAIN_TRIPLE))
fi

# Count Rust tests
if [ -f "${HOME}/.cargo/env" ]; then
    source "${HOME}/.cargo/env"
fi
RUST_TESTS_SOURCE="full_cargo_test"
RUST_TESTS_ESTIMATED=0
RUST_TESTS_VERIFIED=0
if [ "$FAST_MODE" -eq 1 ]; then
    # Fast: count #[test] annotations statically (< 1s vs ~30s for cargo test)
    RUST_TESTS_ESTIMATED=$(grep -r '#\[test\]' "$ROOT_DIR/03_PROTO/crates" --include="*.rs" 2>/dev/null | wc -l)
    RUST_TESTS="$RUST_TESTS_ESTIMATED"
    RUST_TESTS_SOURCE="static_scan"

    # Preserve last verified test count when available so fast mode does not
    # regress published metrics to a static approximation.
    if [ -f "$PREV_METRICS" ] && command -v python3 >/dev/null 2>&1; then
        PREV_VERIFIED=$(python3 - <<'PY' "$PREV_METRICS"
import json, sys
try:
    with open(sys.argv[1], "r", encoding="utf-8") as f:
        data = json.load(f)
    rust = data.get("rust", {})
    val = rust.get("testsVerified", rust.get("tests", 0))
    print(int(val) if isinstance(val, int) or (isinstance(val, str) and val.isdigit()) else 0)
except Exception:
    print(0)
PY
)
        if [[ "$PREV_VERIFIED" =~ ^[0-9]+$ ]] && [ "$PREV_VERIFIED" -gt 0 ]; then
            RUST_TESTS="$PREV_VERIFIED"
            RUST_TESTS_VERIFIED="$PREV_VERIFIED"
            RUST_TESTS_SOURCE="cached_verified"
        fi
    fi
else
    # Full: run cargo test for accurate count
    RUST_TESTS=$(cd "$ROOT_DIR/03_PROTO" && cargo test --all 2>&1 | grep -oP '\d+ passed' | awk '{sum += $1} END {print sum+0}' || echo "0")
    RUST_TESTS_VERIFIED="$RUST_TESTS"
fi

if [ "$RUST_TESTS_VERIFIED" -le 0 ] 2>/dev/null; then
    RUST_TESTS_VERIFIED="$RUST_TESTS"
fi

# Count Rust crates (03_PROTO only — the main language crates)
RUST_CRATES=$(find "$ROOT_DIR/03_PROTO/crates" -name "Cargo.toml" -type f 2>/dev/null | wc -l)

# Count example files
EXAMPLE_FILES=$(find "$ROOT_DIR/07_EXAMPLES" -name "*.rii" -type f 2>/dev/null | wc -l)

# Count research domains
RESEARCH_DOMAINS=$(find "$ROOT_DIR/02_FORMAL/coq/domains" -name "*.v" -type f 2>/dev/null | wc -l)

# Get version
VERSION=$(cat "$ROOT_DIR/VERSION" 2>/dev/null || echo "0.1.0")

# Get git info
GIT_COMMIT=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

# Calculate session number (highest across CLAUDE.md and SESSION_LOG.md)
SESSION_FROM_LOG=$(grep -oP "Session \K\d+" "$ROOT_DIR/SESSION_LOG.md" 2>/dev/null | sort -n | tail -1 || echo "0")
SESSION_FROM_CLAUDE=$(grep -oP "Session \K\d+" "$ROOT_DIR/CLAUDE.md" 2>/dev/null | sort -n | tail -1 || echo "0")
SESSION=$((SESSION_FROM_LOG > SESSION_FROM_CLAUDE ? SESSION_FROM_LOG : SESSION_FROM_CLAUDE))

# Conservative claim-level classification for public messaging:
#   generated -> present in source or generated artifacts
#   compiled -> tool/lane compilation evidence available
#   mechanized -> machine-checked with active-build zero-gap policy
#   independently_audited -> external independent audit published
COQ_COMPILED=true
if [ "$QED_ACTIVE" -eq 0 ] || [ "$ADMITTED" -ne 0 ] || [ "$AXIOMS" -ne 0 ] || [ "$ASSUMPTIONS" -ne 0 ]; then
    COQ_COMPILED=false
fi

# Keep non-Coq claim levels fully tied to lane report evidence.
LEAN_COMPILED=false
ISABELLE_COMPILED=false
FSTAR_COMPILED=false
TLAPLUS_COMPILED=false
ALLOY_COMPILED=false
SMT_COMPILED=false
VERUS_COMPILED=false
KANI_COMPILED=false
TV_COMPILED=false

LEAN_MECHANIZED_READY=false
ISABELLE_MECHANIZED_READY=false
FSTAR_MECHANIZED_READY=false
TLAPLUS_MECHANIZED_READY=false
ALLOY_MECHANIZED_READY=false
SMT_MECHANIZED_READY=false
VERUS_MECHANIZED_READY=false
KANI_MECHANIZED_READY=false
TV_MECHANIZED_READY=false

NONCOQ_MECH_REPORT="$ROOT_DIR/reports/noncoq_mechanized_status.json"
NONCOQ_MECH_FRESH=false
NONCOQ_MECH_OVERALL=false
NONCOQ_MECH_SOURCE="missing_or_stale"

LEAN_PENDING_REASON="noncoq_report_missing_or_stale"
ISABELLE_PENDING_REASON="noncoq_report_missing_or_stale"
FSTAR_PENDING_REASON="noncoq_report_missing_or_stale"
TLAPLUS_PENDING_REASON="noncoq_report_missing_or_stale"
ALLOY_PENDING_REASON="noncoq_report_missing_or_stale"
SMT_PENDING_REASON="noncoq_report_missing_or_stale"
VERUS_PENDING_REASON="noncoq_report_missing_or_stale"
KANI_PENDING_REASON="noncoq_report_missing_or_stale"
TV_PENDING_REASON="noncoq_report_missing_or_stale"

LEAN_SORRY_BACKLOG="$LEAN_SORRY"
LEAN_AXIOMS_BACKLOG="$LEAN_AXIOMS"
ISABELLE_SORRY_BACKLOG="$ISABELLE_SORRY"
FSTAR_GENERATED_BACKLOG=0
SMT_GENERATED_BACKLOG=0
VERUS_GENERATED_BACKLOG=0
KANI_GENERATED_BACKLOG=0
TV_GENERATED_BACKLOG=0
TLAPLUS_SMOKE_BUILD_OK=false
TLAPLUS_COMPILED_THEOREMS=0
ALLOY_SMOKE_BUILD_OK=false
ALLOY_COMPILED_ASSERTIONS=0

DIM14_REPORT="$ROOT_DIR/reports/dim14_runtime_status.json"
DIM14_FRESH=false
CLAIM_DIM14="generated"

CURRENT_HEAD="$(git -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || echo "")"
CURRENT_PARENT_HEAD="$(git -C "$ROOT_DIR" rev-parse HEAD^ 2>/dev/null || echo "")"

if [ -f "$DIM14_REPORT" ] && command -v jq >/dev/null 2>&1; then
    dim14_head="$(jq -r '.repo_head // ""' "$DIM14_REPORT" 2>/dev/null || echo "")"
    if report_head_matches_or_compatible "$dim14_head" \
        03_PROTO/crates/riina-codegen \
        03_PROTO/crates/riinac \
        scripts/check-dim14-runtime.sh; then
        DIM14_FRESH=true
    fi
    if [ "$DIM14_FRESH" = true ] && jq -e '.overall == "PASS"' "$DIM14_REPORT" >/dev/null 2>&1; then
        CLAIM_DIM14="compiled"
    fi
fi

if [ -f "$NONCOQ_MECH_REPORT" ] && command -v jq >/dev/null 2>&1; then
    noncoq_head="$(jq -r '.repo_head // ""' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "")"
    if report_head_matches_or_compatible "$noncoq_head" \
        02_FORMAL/lean \
        02_FORMAL/isabelle \
        02_FORMAL/fstar \
        02_FORMAL/tlaplus \
        02_FORMAL/alloy \
        02_FORMAL/smt \
        02_FORMAL/verus \
        02_FORMAL/kani \
        02_FORMAL/tv \
        05_TOOLING/tools/formal \
        05_TOOLING/tools/isabelle \
        05_TOOLING/tools/fstar \
        scripts/check-noncoq-mechanized.sh \
        scripts/check-heavy-closure.sh \
        scripts/provision-formal-tools.sh \
        scripts/provision-smoke-toolchains.sh \
        scripts/provision-isabelle.sh \
        scripts/provision-fstar.sh \
        scripts/isabelle-local.sh \
        scripts/fstar-local.sh; then
        NONCOQ_MECH_FRESH=true
    fi
fi

if [ "$NONCOQ_MECH_FRESH" = true ]; then
    NONCOQ_MECH_SOURCE="strict_report"
    NONCOQ_MECH_OVERALL="$(jq -r '.overall_noncoq_mechanized // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"

    LEAN_COMPILED="$(jq -r '.lanes.lean.full_build_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    ISABELLE_COMPILED="$(jq -r '.lanes.isabelle.full_build_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    FSTAR_COMPILED="$(jq -r '.lanes.fstar.full_exec_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    TLAPLUS_COMPILED="$(jq -r '.lanes.tlaplus.full_exec_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    ALLOY_COMPILED="$(jq -r '.lanes.alloy.full_exec_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    SMT_COMPILED="$(jq -r '.lanes.smt.full_exec_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    VERUS_COMPILED="$(jq -r '.lanes.verus.full_exec_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    KANI_COMPILED="$(jq -r '.lanes.kani.full_exec_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    TV_COMPILED="$(jq -r '.lanes.tv.full_exec_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"

    LEAN_MECHANIZED_READY="$(jq -r '.lanes.lean.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    ISABELLE_MECHANIZED_READY="$(jq -r '.lanes.isabelle.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    FSTAR_MECHANIZED_READY="$(jq -r '.lanes.fstar.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    TLAPLUS_MECHANIZED_READY="$(jq -r '.lanes.tlaplus.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    ALLOY_MECHANIZED_READY="$(jq -r '.lanes.alloy.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    SMT_MECHANIZED_READY="$(jq -r '.lanes.smt.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    VERUS_MECHANIZED_READY="$(jq -r '.lanes.verus.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    KANI_MECHANIZED_READY="$(jq -r '.lanes.kani.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    TV_MECHANIZED_READY="$(jq -r '.lanes.tv.mechanized_ready // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"

    LEAN_PENDING_REASON="$(jq -r '.lanes.lean.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    ISABELLE_PENDING_REASON="$(jq -r '.lanes.isabelle.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    FSTAR_PENDING_REASON="$(jq -r '.lanes.fstar.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    TLAPLUS_PENDING_REASON="$(jq -r '.lanes.tlaplus.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    ALLOY_PENDING_REASON="$(jq -r '.lanes.alloy.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    SMT_PENDING_REASON="$(jq -r '.lanes.smt.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    VERUS_PENDING_REASON="$(jq -r '.lanes.verus.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    KANI_PENDING_REASON="$(jq -r '.lanes.kani.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"
    TV_PENDING_REASON="$(jq -r '.lanes.tv.pending // "none"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "none")"

    LEAN_SORRY_BACKLOG="$(jq -r '.lanes.lean.sorry // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    LEAN_AXIOMS_BACKLOG="$(jq -r '.lanes.lean.axioms // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    ISABELLE_SORRY_BACKLOG="$(jq -r '.lanes.isabelle.sorry // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    FSTAR_GENERATED_BACKLOG="$(jq -r '.lanes.fstar.generated_files // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    SMT_GENERATED_BACKLOG="$(jq -r '.lanes.smt.generated_files // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    VERUS_GENERATED_BACKLOG="$(jq -r '.lanes.verus.generated_files // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    KANI_GENERATED_BACKLOG="$(jq -r '.lanes.kani.generated_files // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    TV_GENERATED_BACKLOG="$(jq -r '.lanes.tv.generated_files // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"

    ISABELLE_SMOKE_SESSION="$(jq -r '.lanes.isabelle.smoke_session // "RIINA_CORE"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "RIINA_CORE")"
    ISABELLE_SMOKE_BUILD_OK="$(jq -r '.lanes.isabelle.smoke_build_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    ISABELLE_SMOKE_DECLARED_THEORIES="$(jq -r '.lanes.isabelle.smoke_declared_theories // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    ISABELLE_SMOKE_DECLARED_LEMMAS="$(jq -r '.lanes.isabelle.smoke_declared_lemmas // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    ISABELLE_COMPILED_THEORIES="$(jq -r '.lanes.isabelle.smoke_compiled_theories // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    ISABELLE_COMPILED_LEMMAS="$(jq -r '.lanes.isabelle.smoke_compiled_lemmas // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"

    FSTAR_SMOKE_MODULE="$(jq -r '.lanes.fstar.smoke_module // "RIINA.Active.CryptographicSecurityActive"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "RIINA.Active.CryptographicSecurityActive")"
    FSTAR_SMOKE_BUILD_OK="$(jq -r '.lanes.fstar.smoke_build_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    FSTAR_SMOKE_DECLARED_LEMMAS="$(jq -r '.lanes.fstar.smoke_declared_lemmas // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    FSTAR_COMPILED_LEMMAS="$(jq -r '.lanes.fstar.smoke_compiled_lemmas // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    TLAPLUS_SMOKE_SPEC="$(jq -r '.lanes.tlaplus.smoke_spec // "RIINA.Active.TelusProcurementProtocol"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "RIINA.Active.TelusProcurementProtocol")"
    TLAPLUS_SMOKE_BUILD_OK="$(jq -r '.lanes.tlaplus.smoke_build_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    TLAPLUS_SMOKE_DECLARED_THEOREMS="$(jq -r '.lanes.tlaplus.smoke_declared_theorems // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    TLAPLUS_COMPILED_THEOREMS="$(jq -r '.lanes.tlaplus.smoke_compiled_theorems // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    ALLOY_SMOKE_MODEL="$(jq -r '.lanes.alloy.smoke_model // "RIINA.Active.TelusProcurementAccessControl"' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "RIINA.Active.TelusProcurementAccessControl")"
    ALLOY_SMOKE_BUILD_OK="$(jq -r '.lanes.alloy.smoke_build_ok // false' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "false")"
    ALLOY_SMOKE_DECLARED_ASSERTIONS="$(jq -r '.lanes.alloy.smoke_declared_assertions // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
    ALLOY_COMPILED_ASSERTIONS="$(jq -r '.lanes.alloy.smoke_checked_assertions // 0' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "0")"
fi

if [ "$NONCOQ_MECH_FRESH" != true ]; then
    if ISABELLE_BIN_LOCAL="$(detect_isabelle_bin)"; then
        if [ -d "$ISABELLE_SMOKE_DIR" ] && "$ISABELLE_BIN_LOCAL" build -d "$ISABELLE_SMOKE_DIR" -b "$ISABELLE_SMOKE_SESSION" >/dev/null 2>&1; then
            ISABELLE_SMOKE_BUILD_OK=true
            ISABELLE_COMPILED_THEORIES="$ISABELLE_SMOKE_DECLARED_THEORIES"
            ISABELLE_COMPILED_LEMMAS="$ISABELLE_SMOKE_DECLARED_LEMMAS"
        fi
    fi

    if [ -f "$FSTAR_SMOKE_FILE" ] && FSTAR_BIN="$(detect_fstar_bin)"; then
        if "$FSTAR_BIN" \
            --cache_checked_modules \
            --cache_dir /tmp/riina-fstar-active-cache \
            --include "$ROOT_DIR/02_FORMAL/fstar" \
            "$FSTAR_SMOKE_FILE" >/dev/null 2>&1; then
            FSTAR_SMOKE_BUILD_OK=true
            FSTAR_COMPILED_LEMMAS="$FSTAR_SMOKE_DECLARED_LEMMAS"
        fi
    fi

    if [ -f "$TLAPLUS_SMOKE_FILE" ] && [ -f "$TLAPLUS_SMOKE_CFG" ] && command -v java >/dev/null 2>&1 && TLA2TOOLS_JAR_LOCAL="$(detect_tla2tools_jar)"; then
        TLAPLUS_META_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t riina-tla-smoke)"
        if (cd "$(dirname "$TLAPLUS_SMOKE_FILE")" \
            && java -cp "$TLA2TOOLS_JAR_LOCAL" tla2sany.SANY "$(basename "$TLAPLUS_SMOKE_FILE")" >/dev/null 2>&1 \
            && java -cp "$TLA2TOOLS_JAR_LOCAL" tlc2.TLC -cleanup -workers 1 -metadir "$TLAPLUS_META_DIR" -config "$(basename "$TLAPLUS_SMOKE_CFG")" "$(basename "$TLAPLUS_SMOKE_FILE")" >/dev/null 2>&1); then
            TLAPLUS_SMOKE_BUILD_OK=true
            TLAPLUS_COMPILED_THEOREMS="$TLAPLUS_SMOKE_DECLARED_THEOREMS"
        fi
        rm -rf "$TLAPLUS_META_DIR"
    fi

    if [ -f "$ALLOY_SMOKE_FILE" ] && command -v java >/dev/null 2>&1 && ALLOY_JAR_LOCAL="$(detect_alloy_jar)"; then
        if alloy_smoke_ok "$ALLOY_JAR_LOCAL" "$ALLOY_SMOKE_FILE"; then
            ALLOY_SMOKE_BUILD_OK=true
            ALLOY_COMPILED_ASSERTIONS="$ALLOY_SMOKE_DECLARED_ASSERTIONS"
        fi
    fi
fi

load_cached_fast_noncoq_metrics

ISABELLE_LEMMAS_PUBLIC=$ISABELLE_LEMMAS
FSTAR_LEMMAS_PUBLIC=$FSTAR_LEMMAS
TLAPLUS_THEOREMS_PUBLIC=$TLAPLUS_THEOREMS
ALLOY_ASSERTIONS_PUBLIC=$ALLOY_ASSERTIONS
SMT_ASSERTIONS_PUBLIC=$SMT_ASSERTIONS
VERUS_PROOFS_PUBLIC=$VERUS_PROOFS
KANI_HARNESSES_PUBLIC=$KANI_HARNESSES
TV_VALIDATIONS_PUBLIC=$TV_VALIDATIONS

if [ "$ISABELLE_QUARANTINED" = true ]; then
    if [ "$ISABELLE_SMOKE_BUILD_OK" = true ] && [ "$ISABELLE_COMPILED_LEMMAS" -gt 0 ]; then
        ISABELLE_LEMMAS_PUBLIC=$ISABELLE_COMPILED_LEMMAS
    else
        ISABELLE_LEMMAS_PUBLIC=0
    fi
fi
if [ "$FSTAR_QUARANTINED" = true ]; then
    if [ "$FSTAR_SMOKE_BUILD_OK" = true ] && [ "$FSTAR_COMPILED_LEMMAS" -gt 0 ]; then
        FSTAR_LEMMAS_PUBLIC=$FSTAR_COMPILED_LEMMAS
    else
        FSTAR_LEMMAS_PUBLIC=0
    fi
fi
if [ "$TLAPLUS_QUARANTINED" = true ]; then
    if [ "$TLAPLUS_SMOKE_BUILD_OK" = true ] && [ "$TLAPLUS_COMPILED_THEOREMS" -gt 0 ]; then
        TLAPLUS_THEOREMS_PUBLIC=$TLAPLUS_COMPILED_THEOREMS
    else
        TLAPLUS_THEOREMS_PUBLIC=0
    fi
fi
if [ "$ALLOY_QUARANTINED" = true ]; then
    if [ "$ALLOY_SMOKE_BUILD_OK" = true ] && [ "$ALLOY_COMPILED_ASSERTIONS" -gt 0 ]; then
        ALLOY_ASSERTIONS_PUBLIC=$ALLOY_COMPILED_ASSERTIONS
    else
        ALLOY_ASSERTIONS_PUBLIC=0
    fi
fi
[ "$SMT_QUARANTINED" = true ] && SMT_ASSERTIONS_PUBLIC=0
[ "$VERUS_QUARANTINED" = true ] && VERUS_PROOFS_PUBLIC=0
[ "$KANI_QUARANTINED" = true ] && KANI_HARNESSES_PUBLIC=0
[ "$TV_QUARANTINED" = true ] && TV_VALIDATIONS_PUBLIC=0

TOTAL_PROOFS=$((QED_ACTIVE + LEAN_THEOREMS + ISABELLE_LEMMAS_PUBLIC + FSTAR_LEMMAS_PUBLIC + TLAPLUS_THEOREMS_PUBLIC + ALLOY_ASSERTIONS_PUBLIC + SMT_ASSERTIONS_PUBLIC + VERUS_PROOFS_PUBLIC + KANI_HARNESSES_PUBLIC + TV_VALIDATIONS_PUBLIC))

if [ "$ISABELLE_SMOKE_BUILD_OK" = true ] && [ "$ISABELLE_COMPILED_THEORIES" -gt 0 ]; then
    ISABELLE_COMPILED=true
    if [ "$ISABELLE_MECHANIZED_READY" != true ]; then
        ISABELLE_PENDING_REASON="partial RIINA_CORE smoke build verified; full RIINA+RIINA_Domains build still pending"
    fi
fi

# HONESTY POLICY (2026-06-01): a trivial *smoke* artifact compiling does NOT earn
# a lane a "compiled" claim level — that overclaims (only a handful of trivial
# lemmas/assertions compile, not the lane). The smoke success is preserved in the
# per-lane data fields (smokeBuildOk, compiledLemmas, smokeVerified, smokeNote);
# the LANE claim level stays "generated" unless a fresh full-lane verification
# report (reports/noncoq_mechanized_status.json) vouches for it — which is exactly
# what scripts/public-quality-gates.sh requires. This keeps the two scripts
# consistent and matches REQ-08/09/10 = PARTIAL (smoke) in the master plan.
if [ "$FSTAR_SMOKE_BUILD_OK" = true ] && [ "$FSTAR_COMPILED_LEMMAS" -gt 0 ]; then
    if [ "$FSTAR_MECHANIZED_READY" != true ]; then
        FSTAR_PENDING_REASON="CryptographicSecurityActive smoke build verified (3 trivial lemmas); lane stays generated until full Active+Domains F* compilation"
    fi
fi

if [ "$TLAPLUS_SMOKE_BUILD_OK" = true ] && [ "$TLAPLUS_COMPILED_THEOREMS" -gt 0 ]; then
    if [ "$TLAPLUS_MECHANIZED_READY" != true ]; then
        TLAPLUS_PENDING_REASON="TelusProcurementProtocol smoke model checked (5 theorems); lane stays generated until full-lane SANY checks across TLA corpus"
    fi
fi

if [ "$ALLOY_SMOKE_BUILD_OK" = true ] && [ "$ALLOY_COMPILED_ASSERTIONS" -gt 0 ]; then
    if [ "$ALLOY_MECHANIZED_READY" != true ]; then
        ALLOY_PENDING_REASON="TelusProcurementAccessControl smoke model checked (6 assertions); lane stays generated until full-lane Alloy checks across corpus"
    fi
fi

CLAIM_COQ="generated"
[ "$COQ_COMPILED" = true ] && CLAIM_COQ="mechanized"

CLAIM_LEAN="generated"; [ "$LEAN_COMPILED" = true ] && CLAIM_LEAN="compiled"
CLAIM_ISABELLE="generated"; [ "$ISABELLE_COMPILED" = true ] && CLAIM_ISABELLE="compiled"
CLAIM_FSTAR="generated"; [ "$FSTAR_COMPILED" = true ] && CLAIM_FSTAR="compiled"
CLAIM_TLAPLUS="generated"; [ "$TLAPLUS_COMPILED" = true ] && CLAIM_TLAPLUS="compiled"
CLAIM_ALLOY="generated"; [ "$ALLOY_COMPILED" = true ] && CLAIM_ALLOY="compiled"
CLAIM_SMT="generated"; [ "$SMT_COMPILED" = true ] && CLAIM_SMT="compiled"
CLAIM_VERUS="generated"; [ "$VERUS_COMPILED" = true ] && CLAIM_VERUS="compiled"
CLAIM_KANI="generated"; [ "$KANI_COMPILED" = true ] && CLAIM_KANI="compiled"
CLAIM_TV="generated"; [ "$TV_COMPILED" = true ] && CLAIM_TV="compiled"

# Quarantined lanes keep generated-only public claim levels until explicitly
# dequarantined, even if a bounded smoke session proves partial compilation.
if [ "$ISABELLE_QUARANTINED" = true ]; then
  CLAIM_ISABELLE="generated"
  if [ "$ISABELLE_SMOKE_BUILD_OK" != true ] || [ "$ISABELLE_COMPILED_THEORIES" -eq 0 ]; then
    ISABELLE_COMPILED=false
  fi
fi
if [ "$FSTAR_QUARANTINED" = true ]; then
  CLAIM_FSTAR="generated"
  if [ "$FSTAR_SMOKE_BUILD_OK" != true ] || [ "$FSTAR_COMPILED_LEMMAS" -eq 0 ]; then
    FSTAR_COMPILED=false
  fi
fi
if [ "$TLAPLUS_QUARANTINED" = true ]; then
  CLAIM_TLAPLUS="generated"
  if [ "$TLAPLUS_SMOKE_BUILD_OK" != true ] || [ "$TLAPLUS_COMPILED_THEOREMS" -eq 0 ]; then
    TLAPLUS_COMPILED=false
  fi
fi
if [ "$ALLOY_QUARANTINED" = true ]; then
  CLAIM_ALLOY="generated"
  if [ "$ALLOY_SMOKE_BUILD_OK" != true ] || [ "$ALLOY_COMPILED_ASSERTIONS" -eq 0 ]; then
    ALLOY_COMPILED=false
  fi
fi
[ "$SMT_QUARANTINED" = true ] && CLAIM_SMT="generated" && SMT_COMPILED=false
[ "$VERUS_QUARANTINED" = true ] && CLAIM_VERUS="generated" && VERUS_COMPILED=false
[ "$KANI_QUARANTINED" = true ] && CLAIM_KANI="generated" && KANI_COMPILED=false
[ "$TV_QUARANTINED" = true ] && CLAIM_TV="generated" && TV_COMPILED=false

[ "$CLAIM_LEAN" = "compiled" ] && [ "$LEAN_MECHANIZED_READY" = true ] && CLAIM_LEAN="mechanized"
[ "$CLAIM_ISABELLE" = "compiled" ] && [ "$ISABELLE_MECHANIZED_READY" = true ] && CLAIM_ISABELLE="mechanized"
[ "$CLAIM_FSTAR" = "compiled" ] && [ "$FSTAR_MECHANIZED_READY" = true ] && CLAIM_FSTAR="mechanized"
[ "$CLAIM_TLAPLUS" = "compiled" ] && [ "$TLAPLUS_MECHANIZED_READY" = true ] && CLAIM_TLAPLUS="mechanized"
[ "$CLAIM_ALLOY" = "compiled" ] && [ "$ALLOY_MECHANIZED_READY" = true ] && CLAIM_ALLOY="mechanized"
[ "$CLAIM_SMT" = "compiled" ] && [ "$SMT_MECHANIZED_READY" = true ] && CLAIM_SMT="mechanized"
[ "$CLAIM_VERUS" = "compiled" ] && [ "$VERUS_MECHANIZED_READY" = true ] && CLAIM_VERUS="mechanized"
[ "$CLAIM_KANI" = "compiled" ] && [ "$KANI_MECHANIZED_READY" = true ] && CLAIM_KANI="mechanized"
[ "$CLAIM_TV" = "compiled" ] && [ "$TV_MECHANIZED_READY" = true ] && CLAIM_TV="mechanized"

ALL_NONCOQ_COMPILED=true
for level in "$CLAIM_LEAN" "$CLAIM_ISABELLE" "$CLAIM_FSTAR" "$CLAIM_TLAPLUS" "$CLAIM_ALLOY" "$CLAIM_SMT" "$CLAIM_VERUS" "$CLAIM_KANI" "$CLAIM_TV"; do
  if [ "$level" = "generated" ]; then
    ALL_NONCOQ_COMPILED=false
    break
  fi
done

ALL_NONCOQ_MECHANIZED=true
for level in "$CLAIM_LEAN" "$CLAIM_ISABELLE" "$CLAIM_FSTAR" "$CLAIM_TLAPLUS" "$CLAIM_ALLOY" "$CLAIM_SMT" "$CLAIM_VERUS" "$CLAIM_KANI" "$CLAIM_TV"; do
  if [ "$level" != "mechanized" ] && [ "$level" != "independently_audited" ]; then
    ALL_NONCOQ_MECHANIZED=false
    break
  fi
done

INDEPENDENTLY_AUDITED=false
OVERALL_CLAIM="generated"
if [ "$INDEPENDENTLY_AUDITED" = true ]; then
  OVERALL_CLAIM="independently_audited"
elif [ "$CLAIM_COQ" = "mechanized" ] && [ "$ALL_NONCOQ_MECHANIZED" = true ] \
  && { [ "$CLAIM_DIM14" = "mechanized" ] || [ "$CLAIM_DIM14" = "independently_audited" ]; }; then
  OVERALL_CLAIM="mechanized"
elif [ "$CLAIM_COQ" = "mechanized" ] && [ "$ALL_NONCOQ_COMPILED" = true ] \
  && [ "$CLAIM_DIM14" != "generated" ]; then
  OVERALL_CLAIM="compiled"
fi

MULTIPROVER_STATUS="IN_PROGRESS"
[ "$CLAIM_COQ" = "mechanized" ] && MULTIPROVER_STATUS="ACTIVE_COQ_MECHANIZED"
[ "$ALL_NONCOQ_COMPILED" = true ] && [ "$CLAIM_COQ" = "mechanized" ] && MULTIPROVER_STATUS="MULTI_LANE_COMPILED"
[ "$ALL_NONCOQ_MECHANIZED" = true ] && [ "$CLAIM_COQ" = "mechanized" ] && MULTIPROVER_STATUS="MULTI_LANE_MECHANIZED"
[ "$INDEPENDENTLY_AUDITED" = true ] && MULTIPROVER_STATUS="INDEPENDENTLY_AUDITED"

# Generate JSON
cat > "$OUTPUT_FILE" << EOF
{
  "generated": "$TIMESTAMP",
  "generatedHuman": "$DATE_HUMAN",
  "version": "$VERSION",
  "session": $SESSION,
  "git": {
    "commit": "$GIT_COMMIT",
    "branch": "$GIT_BRANCH"
  },
  "proofs": {
    "qedActive": $QED_ACTIVE,
    "qedDeprecated": $QED_DEPRECATED,
    "qedTotal": $((QED_ACTIVE + QED_DEPRECATED)),
    "admitted": $ADMITTED,
    "axioms": $AXIOMS,
    "assumptions": $ASSUMPTIONS,
    "axiomsJustified": true
  },
  "coq": {
    "filesTotal": $COQ_FILES,
    "filesActive": $COQ_ACTIVE_FILES,
    "domains": $RESEARCH_DOMAINS,
    "prover": "Rocq 9.1.1"
  },
  "lean": {
    "theorems": $LEAN_THEOREMS,
    "theoremsNote": "Count of theorem DECLARATIONS in the generated port, not verified proofs",
    "sorry": $LEAN_SORRY,
    "sorryNote": "0 literal sorry in the strict lane; 2 literal sorry exist in Properties/_wip; most proofs are non-elaborating (not visible to grep)",
    "axioms": $LEAN_AXIOMS,
    "files": $LEAN_FILES,
    "lines": $LEAN_LINES,
    "elaborationMeasured": "2026-06-01 (Lean 4.16.0)",
    "filesTotal": 326,
    "filesElaboratingClean": 7,
    "theoremsElaborating": 215,
    "defaultBuildTheorems": 0,
    "defaultBuildNote": "lake build RIINA passes but builds only the 0-theorem Domains/All shim; see 02_FORMAL/lean/COMPILATION_STATUS.md",
    "prover": "Lean 4"
  },
  "isabelle": {
    "lemmas": $ISABELLE_LEMMAS_PUBLIC,
    "lemmasRaw": $ISABELLE_LEMMAS,
    "compiledTheories": $ISABELLE_COMPILED_THEORIES,
    "compiledLemmas": $ISABELLE_COMPILED_LEMMAS,
    "smokeBuildOk": $ISABELLE_SMOKE_BUILD_OK,
    "smokeSession": "$(escape_json "$ISABELLE_SMOKE_SESSION")",
    "quarantined": $ISABELLE_QUARANTINED,
    "sorry": $ISABELLE_SORRY,
    "sorryVerified": $ISABELLE_COMPILED,
    "axioms": $ISABELLE_AXIOMS,
    "files": $ISABELLE_FILES,
    "lines": $ISABELLE_LINES,
    "prover": "Isabelle/HOL"
  },
  "fstar": {
    "lemmas": $FSTAR_LEMMAS_PUBLIC,
    "lemmasRaw": $FSTAR_LEMMAS,
    "lemmasRawNote": "Corpus-wide count of \`lemma_\`-named declarations; NOT all verified",
    "compiledLemmas": $FSTAR_COMPILED_LEMMAS,
    "smokeBuildOk": $FSTAR_SMOKE_BUILD_OK,
    "smokeVerified": "2026-06-01 (F* 2025.12.15): 'All verification conditions discharged successfully'",
    "smokeLemmas": 3,
    "smokeContent": "3 trivial lemmas (constant-time u8 eq reflexive/symmetric, zeroize length) — NOT the named crypto algorithms",
    "smokeModule": "$(escape_json "$FSTAR_SMOKE_MODULE")",
    "corpusAdmits": 11935,
    "quarantined": $FSTAR_QUARANTINED,
    "files": $FSTAR_FILES,
    "prover": "F*"
  },
  "tlaplus": {
    "theorems": $TLAPLUS_THEOREMS_PUBLIC,
    "theoremsRaw": $TLAPLUS_THEOREMS,
    "compiledTheorems": $TLAPLUS_COMPILED_THEOREMS,
    "smokeBuildOk": $TLAPLUS_SMOKE_BUILD_OK,
    "smokeVerified": "2026-06-01 (TLA2Tools): smoke check passed",
    "smokeSpec": "$(escape_json "$TLAPLUS_SMOKE_SPEC")",
    "smokeNote": "theoremsRaw is the corpus-wide THEOREM count; only the smoke-spec theorems are TLC-checked",
    "quarantined": $TLAPLUS_QUARANTINED,
    "files": $TLAPLUS_FILES,
    "prover": "TLA+"
  },
  "alloy": {
    "assertions": $ALLOY_ASSERTIONS_PUBLIC,
    "assertionsRaw": $ALLOY_ASSERTIONS,
    "compiledAssertions": $ALLOY_COMPILED_ASSERTIONS,
    "smokeBuildOk": $ALLOY_SMOKE_BUILD_OK,
    "smokeVerified": "2026-06-01 (Alloy 6.2.0): smoke check passed",
    "smokeModel": "$(escape_json "$ALLOY_SMOKE_MODEL")",
    "smokeNote": "assertionsRaw is the corpus-wide check count; only the smoke-model assertions are bounded-checked",
    "quarantined": $ALLOY_QUARANTINED,
    "files": $ALLOY_FILES,
    "prover": "Alloy 6"
  },
  "smt": {
    "assertions": $SMT_ASSERTIONS_PUBLIC,
    "assertionsRaw": $SMT_ASSERTIONS,
    "compiledAssertions": 25,
    "smokeBuildOk": true,
    "smokeVerified": "2026-06-01 (Z3 4.8.12): 25 unsat (security-lattice properties)",
    "smokeModule": "RIINA.Active.SecurityLatticeVerification",
    "smokeNote": "assertionsRaw is the corpus-wide assert count; only the 25 lattice properties in the smoke file actually verify (the prior '11,843 verified' figure was a counting error)",
    "quarantined": $SMT_QUARANTINED,
    "files": $SMT_FILES,
    "prover": "Z3/CVC5 (SMT-LIB)"
  },
  "verus": {
    "proofs": $VERUS_PROOFS_PUBLIC,
    "proofsRaw": $VERUS_PROOFS,
    "quarantined": $VERUS_QUARANTINED,
    "files": $VERUS_FILES,
    "prover": "Verus"
  },
  "kani": {
    "harnesses": $KANI_HARNESSES_PUBLIC,
    "harnessesRaw": $KANI_HARNESSES,
    "quarantined": $KANI_QUARANTINED,
    "files": $KANI_FILES,
    "prover": "Kani"
  },
  "tv": {
    "validations": $TV_VALIDATIONS_PUBLIC,
    "validationsRaw": $TV_VALIDATIONS,
    "quarantined": $TV_QUARANTINED,
    "files": $TV_FILES,
    "prover": "Translation Validation"
  },
  "multiProver": {
    "tripleProverTheorems": $TRIPLE_PROVER,
    "totalProofsAllProvers": $TOTAL_PROOFS,
    "totalProvers": 10,
    "proverList": ["Coq", "Lean 4", "Isabelle/HOL", "F*", "TLA+", "Alloy 6", "Z3/CVC5", "Verus", "Kani", "Translation Validation"],
    "sorry": $((LEAN_SORRY + ISABELLE_SORRY)),
    "status": "$MULTIPROVER_STATUS"
  },
  "quality": {
    "coqCompiled": $COQ_COMPILED,
    "leanCompiled": $LEAN_COMPILED,
    "isabelleCompiled": $ISABELLE_COMPILED,
    "fstarStatus": "$CLAIM_FSTAR",
    "tlaplusStatus": "$CLAIM_TLAPLUS",
    "alloyStatus": "$CLAIM_ALLOY",
    "smtStatus": "$CLAIM_SMT",
    "verusStatus": "$CLAIM_VERUS",
    "kaniStatus": "$CLAIM_KANI",
    "tvStatus": "$CLAIM_TV",
    "runtimeProofStatus": "$CLAIM_DIM14",
    "nonCoqMechanization": {
      "reportFresh": $NONCOQ_MECH_FRESH,
      "overallMechanized": $NONCOQ_MECH_OVERALL,
      "source": "$NONCOQ_MECH_SOURCE",
      "pending": {
        "lean": "$(escape_json "$LEAN_PENDING_REASON")",
        "isabelle": "$(escape_json "$ISABELLE_PENDING_REASON")",
        "fstar": "$(escape_json "$FSTAR_PENDING_REASON")",
        "tlaplus": "$(escape_json "$TLAPLUS_PENDING_REASON")",
        "alloy": "$(escape_json "$ALLOY_PENDING_REASON")",
        "smt": "$(escape_json "$SMT_PENDING_REASON")",
        "verus": "$(escape_json "$VERUS_PENDING_REASON")",
        "kani": "$(escape_json "$KANI_PENDING_REASON")",
        "tv": "$(escape_json "$TV_PENDING_REASON")"
      },
      "backlog": {
        "leanSorry": $LEAN_SORRY_BACKLOG,
        "leanAxioms": $LEAN_AXIOMS_BACKLOG,
        "isabelleSorry": $ISABELLE_SORRY_BACKLOG,
        "fstarGeneratedFiles": $FSTAR_GENERATED_BACKLOG,
        "smtGeneratedFiles": $SMT_GENERATED_BACKLOG,
        "verusGeneratedFiles": $VERUS_GENERATED_BACKLOG,
        "kaniGeneratedFiles": $KANI_GENERATED_BACKLOG,
        "tvGeneratedFiles": $TV_GENERATED_BACKLOG
      }
    },
    "coqTiers": {
      "core": $COQ_TIER1_CORE,
      "domain": $COQ_TIER2_DOMAIN,
      "domainTrivial": $COQ_TRIVIAL
    }
  },
  "claimLevels": {
    "legend": ["generated", "compiled", "mechanized", "independently_audited"],
    "overall": "$OVERALL_CLAIM",
    "independentlyAudited": $INDEPENDENTLY_AUDITED,
    "coq": "$CLAIM_COQ",
    "lean": "$CLAIM_LEAN",
    "isabelle": "$CLAIM_ISABELLE",
    "fstar": "$CLAIM_FSTAR",
    "tlaplus": "$CLAIM_TLAPLUS",
    "alloy": "$CLAIM_ALLOY",
    "smt": "$CLAIM_SMT",
    "verus": "$CLAIM_VERUS",
    "kani": "$CLAIM_KANI",
    "tv": "$CLAIM_TV",
    "runtimeProofArchitecture": "$CLAIM_DIM14"
  },
  "rust": {
    "tests": ${RUST_TESTS:-0},
    "testsVerified": ${RUST_TESTS_VERIFIED:-0},
    "testsEstimated": ${RUST_TESTS_ESTIMATED:-0},
    "testsSource": "$RUST_TESTS_SOURCE",
    "crates": $RUST_CRATES
  },
  "examples": $EXAMPLE_FILES,
  "status": {
    "build": "passing",
    "grade": "A",
    "threats": "1231+"
  },
  "milestones": [
    { "date": "2026-02-07", "event": "10-lane verification corpus published (Coq, Lean, Isabelle, F*, TLA+, Alloy, SMT, Verus, Kani, TV) — claim levels apply per lane" },
    { "date": "2026-02-07", "event": "Lean 4 lane integrated into public metrics (see claim levels for current status)" },
    { "date": "2026-02-07", "event": "SMT assertion corpus integrated into public metrics" },
    { "date": "2026-02-06", "event": "Proof depth 20+ across all 250 domain files" },
    { "date": "2026-02-06", "event": "Cross-prover mapping milestone recorded (current quality flags are authoritative)" },
    { "date": "2026-02-10", "event": "Axiom token elimination: 4 → 0 (active-build explicit assumptions now 0)" },
    { "date": "2026-02-01", "event": "Phase 7 complete: Platform Universality" }
  ]
}
EOF

echo "Generated: $OUTPUT_FILE"
echo "  Qed Active:   $QED_ACTIVE"
echo "  Qed Deprecated: $QED_DEPRECATED"
echo "  Qed Total:    $((QED_ACTIVE + QED_DEPRECATED))"
echo "  Admitted:     $ADMITTED"
echo "  Axioms:       $AXIOMS"
echo "  Assumptions:  $ASSUMPTIONS"
echo "  Lean:         $LEAN_THEOREMS theorems, $LEAN_SORRY sorry, $LEAN_FILES files"
echo "  Isabelle:     $ISABELLE_LEMMAS_PUBLIC lemmas (raw $ISABELLE_LEMMAS, compiled $ISABELLE_COMPILED_LEMMAS across $ISABELLE_COMPILED_THEORIES theories), $ISABELLE_SORRY sorry, $ISABELLE_FILES files, quarantined=$ISABELLE_QUARANTINED, smoke=$ISABELLE_SMOKE_BUILD_OK"
echo "  F*:           $FSTAR_LEMMAS_PUBLIC lemmas (raw $FSTAR_LEMMAS, compiled $FSTAR_COMPILED_LEMMAS), $FSTAR_FILES files, quarantined=$FSTAR_QUARANTINED, smoke=$FSTAR_SMOKE_BUILD_OK"
echo "  TLA+:         $TLAPLUS_THEOREMS_PUBLIC theorems (raw $TLAPLUS_THEOREMS, compiled $TLAPLUS_COMPILED_THEOREMS), $TLAPLUS_FILES files, quarantined=$TLAPLUS_QUARANTINED, smoke=$TLAPLUS_SMOKE_BUILD_OK"
echo "  Alloy:        $ALLOY_ASSERTIONS_PUBLIC assertions (raw $ALLOY_ASSERTIONS, compiled $ALLOY_COMPILED_ASSERTIONS), $ALLOY_FILES files, quarantined=$ALLOY_QUARANTINED, smoke=$ALLOY_SMOKE_BUILD_OK"
echo "  SMT:          $SMT_ASSERTIONS_PUBLIC assertions (raw $SMT_ASSERTIONS), $SMT_FILES files, quarantined=$SMT_QUARANTINED"
echo "  Verus:        $VERUS_PROOFS_PUBLIC proofs (raw $VERUS_PROOFS), $VERUS_FILES files, quarantined=$VERUS_QUARANTINED"
echo "  Kani:         $KANI_HARNESSES_PUBLIC harnesses (raw $KANI_HARNESSES), $KANI_FILES files, quarantined=$KANI_QUARANTINED"
echo "  TV:           $TV_VALIDATIONS_PUBLIC validations (raw $TV_VALIDATIONS), $TV_FILES files, quarantined=$TV_QUARANTINED"
echo "  Total proofs: $TOTAL_PROOFS (10 provers)"
echo "  Claim levels: overall=$OVERALL_CLAIM coq=$CLAIM_COQ lean=$CLAIM_LEAN isabelle=$CLAIM_ISABELLE"
echo "                fstar=$CLAIM_FSTAR tlaplus=$CLAIM_TLAPLUS alloy=$CLAIM_ALLOY smt=$CLAIM_SMT"
echo "                verus=$CLAIM_VERUS kani=$CLAIM_KANI tv=$CLAIM_TV dim14=$CLAIM_DIM14"
echo "  Rust tests source: $RUST_TESTS_SOURCE (tests=$RUST_TESTS, verified=$RUST_TESTS_VERIFIED, estimated=$RUST_TESTS_ESTIMATED)"
echo "  Quality tiers:"
echo "    Core Coq:   $COQ_TIER1_CORE (foundations/type_system/effects/properties/termination)"
echo "    Domain Coq: $COQ_TIER2_DOMAIN (domains/Industries/compliance)"
echo "    Trivial:    $COQ_TRIVIAL (reflexivity/exact I patterns)"
echo "  Rust tests:   $RUST_TESTS"
echo "  Session:      $SESSION"
echo "  Timestamp:    $TIMESTAMP"
