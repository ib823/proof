#!/usr/bin/env bash
# ============================================================================
# audit-docs.sh — MANDATORY documentation audit before any commit
#
# This script scans the codebase and compares actual metrics against
# documented values. Any discrepancy MUST be resolved before commit.
#
# Usage:
#   bash scripts/audit-docs.sh           # Full audit with report
#   bash scripts/audit-docs.sh --quick   # Quick check, exit code only
#
# Exit codes:
#   0 — All documentation is current
#   1 — Discrepancies found (BLOCK COMMIT)
#   2 — Script error
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
QUICK_MODE="${1:-}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ "$QUICK_MODE" != "--quick" ]; then
    echo ""
    echo "================================================================"
    echo "  RIINA DOCUMENTATION AUDIT"
    echo "================================================================"
    echo ""
fi

DISCREPANCIES=0
WARNINGS=0

# ── Helper functions ──────────────────────────────────────────────────

count_qed_active() {
    local total=0
    while IFS= read -r f; do
        local count=$(grep -c "Qed\." "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            total=$((total + count))
        fi
    done < <(find "$REPO_ROOT/02_FORMAL/coq" -name "*.v" -type f ! -path "*/_archive_deprecated/*" ! -path "*/_incomplete/*" 2>/dev/null)
    echo "$total"
}

count_admitted_active() {
    local total=0
    while IFS= read -r f; do
        local count=$(grep -cP '^\s*Admitted\.' "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            total=$((total + count))
        fi
    done < <(find "$REPO_ROOT/02_FORMAL/coq" -name "*.v" -type f ! -path "*/_archive_deprecated/*" ! -path "*/_incomplete/*" 2>/dev/null)
    echo "$total"
}

count_coq_files() {
    find "$REPO_ROOT/02_FORMAL/coq" -name "*.v" -type f 2>/dev/null | wc -l
}

count_coq_active_files() {
    local project="$REPO_ROOT/02_FORMAL/coq/_CoqProject"
    if [ ! -f "$project" ]; then
        echo "0"
        return
    fi
    awk '
      {
        line=$0;
        sub(/^[ \t]+/, "", line);
        if (line ~ /^[#-]/ || line == "") next;
        split(line, tok, /[ \t]+/);
        if (tok[1] ~ /\.v$/) c++;
      }
      END { print c + 0 }
    ' "$project"
}

count_lean_theorems() {
    local total=0
    while IFS= read -r f; do
        local count=$(grep -cP "^\s*(theorem|lemma)\s" "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            total=$((total + count))
        fi
    done < <(find "$REPO_ROOT/02_FORMAL/lean" -name "*.lean" -type f ! -name "lakefile.lean" 2>/dev/null)
    echo "$total"
}

count_isabelle_lemmas() {
    local total=0
    while IFS= read -r f; do
        local count=$(grep -cP "^\s*(lemma|theorem|corollary)\s" "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            total=$((total + count))
        fi
    done < <(find "$REPO_ROOT/02_FORMAL/isabelle" -name "*.thy" -type f 2>/dev/null)
    echo "$total"
}

count_isabelle_smoke_lemmas() {
    local root="$REPO_ROOT/02_FORMAL/isabelle/RIINA/Core/ROOT"
    local total=0
    if [ ! -f "$root" ]; then
        echo "0"
        return
    fi
    while IFS= read -r theory; do
        local thy="$REPO_ROOT/02_FORMAL/isabelle/RIINA/${theory}.thy"
        local count=$(grep -cP "^\s*(lemma|theorem|corollary)\s" "$thy" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            total=$((total + count))
        fi
    done < <(
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
        ' "$root" 2>/dev/null
    )
    echo "$total"
}

count_examples() {
    find "$REPO_ROOT/07_EXAMPLES" -name "*.rii" -type f 2>/dev/null | wc -l
}

get_max_session_from_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "0"
        return
    fi
    local value
    value=$(grep -oP "Session \K\d+" "$file" 2>/dev/null | sort -n | tail -1 || true)
    echo "${value:-0}"
}

get_actual_session() {
    local session_log
    local session_claude
    session_log="$(get_max_session_from_file "$REPO_ROOT/SESSION_LOG.md")"
    session_claude="$(get_max_session_from_file "$REPO_ROOT/CLAUDE.md")"
    if [ "$session_log" -gt "$session_claude" ]; then
        echo "$session_log"
    else
        echo "$session_claude"
    fi
}

check_value() {
    local name="$1"
    local actual="$2"
    local documented="$3"
    local file="$4"

    if [ "$actual" != "$documented" ]; then
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${RED}[MISMATCH]${NC} $name"
            echo "           Actual:     $actual"
            echo "           Documented: $documented (in $file)"
        fi
        DISCREPANCIES=$((DISCREPANCIES + 1))
        return 1
    else
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${GREEN}[OK]${NC} $name: $actual"
        fi
        return 0
    fi
}

check_no_stale() {
    local file="$1"
    local pattern="$2"
    local desc="$3"

    if [ ! -f "$file" ]; then
        return 0
    fi

    if grep -qP "$pattern" "$file" 2>/dev/null; then
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${RED}[STALE]${NC} $desc in $(basename "$file")"
            echo "           Pattern found: $pattern"
        fi
        DISCREPANCIES=$((DISCREPANCIES + 1))
        return 1
    fi
    return 0
}

warn_check() {
    local name="$1"
    local status="$2"

    if [ "$status" = "missing" ]; then
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${YELLOW}[WARN]${NC} $name"
        fi
        WARNINGS=$((WARNINGS + 1))
    fi
}

# ── Gather actual metrics ─────────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Scanning codebase...${NC}"
    echo ""
fi

ACTUAL_QED=$(count_qed_active)
ACTUAL_ADMITTED=$(count_admitted_active)
ACTUAL_COQ_FILES=$(count_coq_files)
ACTUAL_COQ_ACTIVE_FILES=$(count_coq_active_files)
ACTUAL_LEAN=$(count_lean_theorems)
ACTUAL_ISABELLE=$(count_isabelle_lemmas)
ACTUAL_ISABELLE_SMOKE=$(count_isabelle_smoke_lemmas)
# Note: ACTUAL_TOTAL for audit checks only covers Coq+Lean+Isabelle (manually verified provers).
# The full 10-prover total is in metrics.json and includes generated stubs.
ACTUAL_TOTAL=$((ACTUAL_QED + ACTUAL_LEAN + ACTUAL_ISABELLE))
ACTUAL_EXAMPLES=$(count_examples)
ACTUAL_SESSION=$(get_actual_session)
# Locale-independent thousands separator
add_commas() { echo "$1" | sed ':a;s/\B[0-9]\{3\}\>$/,&/;ta'; }
ACTUAL_QED_COMMA=$(add_commas "$ACTUAL_QED")

if [ "$QUICK_MODE" != "--quick" ]; then
    echo "Actual metrics from codebase:"
    echo "  Qed (active):  $ACTUAL_QED"
    echo "  Admitted:      $ACTUAL_ADMITTED"
    echo "  Coq files:     $ACTUAL_COQ_FILES"
    echo "  Coq active:    $ACTUAL_COQ_ACTIVE_FILES"
    echo "  Lean:          $ACTUAL_LEAN theorems"
    echo "  Isabelle:      $ACTUAL_ISABELLE lemmas"
    echo "  Total proofs:  $ACTUAL_TOTAL"
    echo "  Examples:      $ACTUAL_EXAMPLES"
    echo "  Session:       $ACTUAL_SESSION"
    echo ""
fi

# ── Check CLAUDE.md / RIINA_MASTER_PLAN.md ────────────────────────────
# CLAUDE.md is now a thin operational pointer (no metrics).
# Metrics live in RIINA_MASTER_PLAN.md Part 2. Check the banner if present,
# otherwise check the master plan.

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking CLAUDE.md / RIINA_MASTER_PLAN.md...${NC}"
fi

# Try CLAUDE.md banner first (sync-metrics.sh writes it), then fall back to master plan
METRICS_SOURCE=""
if [ -f "$REPO_ROOT/CLAUDE.md" ]; then
    DOC_QED=$(grep -oP '\d+,?\d* Qed' "$REPO_ROOT/CLAUDE.md" | head -1 | grep -oP '^\d+,?\d*' | tr -d ',' || echo "0")
    if [ "$DOC_QED" != "0" ]; then
        METRICS_SOURCE="CLAUDE.md"
    fi
fi

# Fall back to RIINA_MASTER_PLAN.md if CLAUDE.md has no metrics (thin pointer mode)
if [ "$DOC_QED" = "0" ] && [ -f "$REPO_ROOT/RIINA_MASTER_PLAN.md" ]; then
    DOC_QED=$(grep -oP '\d+,?\d* Qed' "$REPO_ROOT/RIINA_MASTER_PLAN.md" | head -1 | grep -oP '^\d+,?\d*' | tr -d ',' || echo "0")
    METRICS_SOURCE="RIINA_MASTER_PLAN.md"
fi

# Lean/Isabelle: try CLAUDE.md table format, then master plan
DOC_LEAN=$(grep -oP 'Lean 4 Theorems[*]{2} \| \K\d+' "$REPO_ROOT/CLAUDE.md" 2>/dev/null | head -1 || echo "0")
if [ "$DOC_LEAN" = "0" ] && [ -f "$REPO_ROOT/RIINA_MASTER_PLAN.md" ]; then
    # Master plan uses "Theorem/lemma declarations | N,NNN" format
    DOC_LEAN=$(grep -oP 'Theorem/lemma declarations \| \K\d+,?\d*' "$REPO_ROOT/RIINA_MASTER_PLAN.md" | head -1 | tr -d ',' || echo "0")
fi

DOC_ISABELLE=$(grep -oP 'Isabelle/HOL Lemmas[*]{2} \| \K\d+' "$REPO_ROOT/CLAUDE.md" 2>/dev/null | head -1 || echo "0")
if [ "$DOC_ISABELLE" = "0" ] && [ -f "$REPO_ROOT/RIINA_MASTER_PLAN.md" ]; then
    # Master plan Isabelle section — look for lemma count line
    DOC_ISABELLE=$(grep -oP 'Lemma count \(grep\) \| ~?\K\d+,?\d*' "$REPO_ROOT/RIINA_MASTER_PLAN.md" | head -1 | tr -d ',~' || echo "0")
fi

DOC_SESSION=$(get_max_session_from_file "$REPO_ROOT/CLAUDE.md" 2>/dev/null || echo "0")

LABEL="${METRICS_SOURCE:-CLAUDE.md}"
check_value "Qed proofs ($LABEL)" "$ACTUAL_QED" "$DOC_QED" "$LABEL" || true

# Lean/Isabelle: only check if documented value is non-zero (thin CLAUDE.md may omit)
if [ "$DOC_LEAN" != "0" ]; then
    check_value "Lean theorems ($LABEL)" "$ACTUAL_LEAN" "$DOC_LEAN" "$LABEL" || true
else
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "${GREEN}[OK]${NC} Lean theorems: not in $LABEL (metrics in metrics.json)"
    fi
fi
if [ "$DOC_ISABELLE" != "0" ]; then
    check_value "Isabelle lemmas ($LABEL)" "$ACTUAL_ISABELLE" "$DOC_ISABELLE" "$LABEL" || true
else
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "${GREEN}[OK]${NC} Isabelle lemmas: not in $LABEL (metrics in metrics.json)"
    fi
fi

# Session number is internal tracking — warn but don't block
if [ "$ACTUAL_SESSION" != "$DOC_SESSION" ]; then
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "${YELLOW}[WARN]${NC} Session number ($LABEL): actual=$ACTUAL_SESSION, documented=$DOC_SESSION"
    fi
    WARNINGS=$((WARNINGS + 1))
else
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "${GREEN}[OK]${NC} Session number ($LABEL): $DOC_SESSION"
    fi
fi

if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check README.md ───────────────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking README.md...${NC}"
fi

if [ -f "$REPO_ROOT/README.md" ]; then
    # Check for known-stale Qed counts (historical values that should never appear)
    check_no_stale "$REPO_ROOT/README.md" "6,193|6193" "Stale Qed count (6,193)" || true
    check_no_stale "$REPO_ROOT/README.md" "4,044|4044" "Stale Qed count (4,044)" || true
    check_no_stale "$REPO_ROOT/README.md" "4,885|4885" "Stale Qed count (4,885)" || true
    check_no_stale "$REPO_ROOT/README.md" "policy axiom|1 \\(policy\\)|1 axiom" "Stale active-axiom claim" || true

    # Dynamically check that README Lean/Isabelle/Qed match actual counts
    README_QED=$(grep -oP '[0-9,]+ Coq Qed' "$REPO_ROOT/README.md" | head -1 | grep -oP '^[0-9,]+' | tr -d ',' || echo "0")
    if [ "$README_QED" != "0" ] && [ "$README_QED" != "$ACTUAL_QED" ]; then
        check_value "Qed in README.md" "$ACTUAL_QED" "$README_QED" "README.md" || true
    fi
else
    warn_check "README.md not found" "missing"
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check SECURITY.md ────────────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking SECURITY.md...${NC}"
fi

if [ -f "$REPO_ROOT/SECURITY.md" ]; then
    check_no_stale "$REPO_ROOT/SECURITY.md" "6,193" "Stale Qed count (6,193)" || true
    check_no_stale "$REPO_ROOT/SECURITY.md" "4,044" "Stale Qed count (4,044)" || true
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check CONTRIBUTING.md ────────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking CONTRIBUTING.md...${NC}"
fi

if [ -f "$REPO_ROOT/CONTRIBUTING.md" ]; then
    check_no_stale "$REPO_ROOT/CONTRIBUTING.md" "6,193|6193" "Stale Qed count (6,193)" || true
    check_no_stale "$REPO_ROOT/CONTRIBUTING.md" "Rocq 9\\.1" "Stale prover ref (Rocq 9.1)" || true
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check CHANGELOG.md ───────────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking CHANGELOG.md banner...${NC}"
fi

if [ -f "$REPO_ROOT/CHANGELOG.md" ]; then
    CL_QED=$(grep -oP '\d+,?\d* Coq Qed' "$REPO_ROOT/CHANGELOG.md" | head -1 | grep -oP '^\d+,?\d*' | tr -d ',' || echo "0")
    check_value "Qed in CHANGELOG.md banner" "$ACTUAL_QED" "$CL_QED" "CHANGELOG.md" || true
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check PROGRESS.md ────────────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking PROGRESS.md...${NC}"
fi

if [ -f "$REPO_ROOT/PROGRESS.md" ]; then
    PG_QED=$(grep -oP 'Qed Proofs \(Coq\) \| \*\*\K[0-9,]+' "$REPO_ROOT/PROGRESS.md" | tr -d ',' || echo "0")
    check_value "Qed in PROGRESS.md table" "$ACTUAL_QED" "$PG_QED" "PROGRESS.md" || true
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check website metrics.json ────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking website/public/metrics.json...${NC}"
fi

METRICS_FILE="$REPO_ROOT/website/public/metrics.json"
if [ -f "$METRICS_FILE" ]; then
    WEB_QED=$(grep -oP '"qedActive":\s*\K\d+' "$METRICS_FILE" || echo "0")
    WEB_COQ_ACTIVE=$(python3 -c "import json; print(json.load(open('$METRICS_FILE'))['coq']['filesActive'])" 2>/dev/null || echo "0")
    WEB_SESSION=$(grep -oP '"session":\s*\K\d+' "$METRICS_FILE" || echo "0")
    WEB_LEAN=$(python3 -c "import json; print(json.load(open('$METRICS_FILE'))['lean']['theorems'])" 2>/dev/null || grep -oP '"theorems":\s*\K\d+' "$METRICS_FILE" | head -1 || echo "0")
    WEB_ISABELLE=$(python3 -c "import json; print(json.load(open('$METRICS_FILE'))['isabelle']['lemmas'])" 2>/dev/null || grep -oP '"lemmas":\s*\K\d+' "$METRICS_FILE" | head -1 || echo "0")
    WEB_ISABELLE_RAW=$(python3 -c "import json; print(json.load(open('$METRICS_FILE'))['isabelle'].get('lemmasRaw', json.load(open('$METRICS_FILE'))['isabelle']['lemmas']))" 2>/dev/null || echo "$WEB_ISABELLE")
    WEB_ISABELLE_COMPILED=$(python3 -c "import json; print(json.load(open('$METRICS_FILE'))['isabelle'].get('compiledLemmas', 0))" 2>/dev/null || echo "0")
    WEB_ISABELLE_SMOKE=$(python3 -c "import json; print(str(json.load(open('$METRICS_FILE'))['isabelle'].get('smokeBuildOk', False)).lower())" 2>/dev/null || echo "false")
    WEB_ISABELLE_QUARANTINED=$(python3 -c "import json; print(str(json.load(open('$METRICS_FILE'))['isabelle'].get('quarantined', False)).lower())" 2>/dev/null || echo "false")

    check_value "Website Qed (metrics.json)" "$ACTUAL_QED" "$WEB_QED" "metrics.json" || true
    check_value "Website active Coq files (metrics.json)" "$ACTUAL_COQ_ACTIVE_FILES" "$WEB_COQ_ACTIVE" "metrics.json" || true
    check_value "Website Lean (metrics.json)" "$ACTUAL_LEAN" "$WEB_LEAN" "metrics.json" || true
    if [ "$WEB_ISABELLE_QUARANTINED" = "true" ]; then
        check_value "Website Isabelle raw (metrics.json)" "$ACTUAL_ISABELLE" "$WEB_ISABELLE_RAW" "metrics.json" || true
        if [ "$WEB_ISABELLE_SMOKE" = "true" ]; then
            check_value "Website Isabelle partial compiled count (metrics.json)" "$ACTUAL_ISABELLE_SMOKE" "$WEB_ISABELLE" "metrics.json" || true
            check_value "Website Isabelle compiledLemmas (metrics.json)" "$ACTUAL_ISABELLE_SMOKE" "$WEB_ISABELLE_COMPILED" "metrics.json" || true
        else
            check_value "Website Isabelle quarantined count (metrics.json)" "0" "$WEB_ISABELLE" "metrics.json" || true
        fi
    else
        check_value "Website Isabelle (metrics.json)" "$ACTUAL_ISABELLE" "$WEB_ISABELLE" "metrics.json" || true
    fi
    # Session number is internal tracking — warn but don't block
    if [ "$ACTUAL_SESSION" != "$WEB_SESSION" ]; then
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${YELLOW}[WARN]${NC} Website Session (metrics.json): actual=$ACTUAL_SESSION, documented=$WEB_SESSION"
        fi
        WARNINGS=$((WARNINGS + 1))
    else
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${GREEN}[OK]${NC} Website Session (metrics.json): $WEB_SESSION"
        fi
    fi
else
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "${YELLOW}[WARN]${NC} metrics.json not found (run: bash scripts/generate-metrics.sh)"
    fi
    WARNINGS=$((WARNINGS + 1))
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check RiinaWebsite.jsx hero stats ─────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking website hero stats...${NC}"
fi

WEBSITE_JSX="$REPO_ROOT/website/src/RiinaWebsite.jsx"
if [ -f "$WEBSITE_JSX" ]; then
    # Check for known-stale counts in JSX (historical values that should never appear)
    check_no_stale "$WEBSITE_JSX" "7,875|7875" "Stale total (7,875)" || true
else
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "${YELLOW}[WARN]${NC} RiinaWebsite.jsx not found"
    fi
    WARNINGS=$((WARNINGS + 1))
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check website/index.html ─────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking website/index.html...${NC}"
fi

INDEX_HTML="$REPO_ROOT/website/index.html"
if [ -f "$INDEX_HTML" ]; then
    check_no_stale "$INDEX_HTML" "7,875|7875" "Stale total proofs (7,875)" || true
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check enterprise docs for Rocq 9.1 ───────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking enterprise docs...${NC}"
fi

for ent_file in "$REPO_ROOT/docs/enterprise/CERTIFICATION.md" "$REPO_ROOT/docs/enterprise/COMPLIANCE_PACKAGING.md"; do
    if [ -f "$ent_file" ]; then
        check_no_stale "$ent_file" "Rocq 9\\.1" "Stale prover ref (Rocq 9.1)" || true
    fi
done
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check high-visibility docs for stale active-build claims ─────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking high-visibility active-build claims...${NC}"
fi

if [ -f "$REPO_ROOT/docs/UNDERSTANDING_RIINA.md" ]; then
    check_no_stale "$REPO_ROOT/docs/UNDERSTANDING_RIINA.md" "4,885|4885" "Stale Qed count (4,885)" || true
    check_no_stale "$REPO_ROOT/docs/UNDERSTANDING_RIINA.md" "4 justified axioms|Foundational axioms[[:space:]]*\\|[[:space:]]*4" "Stale axiom claim (4)" || true
    check_no_stale "$REPO_ROOT/docs/UNDERSTANDING_RIINA.md" "249 active proof files|Active proof files[[:space:]]*\\|[[:space:]]*249" "Stale active file count (249)" || true
fi

if [ -f "$REPO_ROOT/docs/enterprise/COMPLIANCE_GUIDE.md" ]; then
    check_no_stale "$REPO_ROOT/docs/enterprise/COMPLIANCE_GUIDE.md" "4,885|4885|4 justified axioms" "Stale compliance proof baseline claim" || true
fi

if [ -f "$REPO_ROOT/docs/enterprise/COMPLIANCE_PACKAGING.md" ]; then
    check_no_stale "$REPO_ROOT/docs/enterprise/COMPLIANCE_PACKAGING.md" "4 justified axioms" "Stale compliance assumptions claim" || true
fi

if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check quality metadata consistency ────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking quality metadata...${NC}"
fi

if [ -f "$METRICS_FILE" ]; then
    # Check: if lean.compiled == false but lean.sorry == 0, warn about misleading claim
    LEAN_COMPILED=$(python3 -c "import json; d=json.load(open('$METRICS_FILE')); print(str(d.get('quality',{}).get('leanCompiled',True)).lower())" 2>/dev/null || echo "true")
    LEAN_SORRY_WEB=$(python3 -c "import json; print(json.load(open('$METRICS_FILE'))['lean']['sorry'])" 2>/dev/null || echo "0")
    if [ "$LEAN_COMPILED" = "false" ] && [ "$LEAN_SORRY_WEB" = "0" ]; then
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${YELLOW}[WARN]${NC} Lean reports 0 sorry but leanCompiled=false (sorry count is syntactic, not verified)"
        fi
        WARNINGS=$((WARNINGS + 1))
    fi

    ISA_COMPILED=$(python3 -c "import json; d=json.load(open('$METRICS_FILE')); print(str(d.get('quality',{}).get('isabelleCompiled',True)).lower())" 2>/dev/null || echo "true")
    ISA_SORRY_WEB=$(python3 -c "import json; print(json.load(open('$METRICS_FILE'))['isabelle']['sorry'])" 2>/dev/null || echo "0")
    ISA_SORRY_VERIFIED=$(python3 -c "import json; print(str(json.load(open('$METRICS_FILE'))['isabelle'].get('sorryVerified', True)).lower())" 2>/dev/null || echo "true")
    if [ "$ISA_COMPILED" = "false" ]; then
        if [ "$ISA_SORRY_VERIFIED" = "false" ]; then
            echo -e "${GREEN}[OK]${NC} Isabelle sorry count ($ISA_SORRY_WEB) correctly marked as unverified (sorryVerified=false)"
        else
            echo -e "${RED}[MISMATCH]${NC} Isabelle isabelleCompiled=false but sorryVerified is not false — run generate-metrics.sh"
            DISCREPANCIES=$((DISCREPANCIES + 1))
        fi
    fi

    # Check stub prover counts match metrics.json
    for prover_key in fstar tlaplus alloy smt verus kani tv; do
        STATUS=$(python3 -c "import json; d=json.load(open('$METRICS_FILE')); print(d.get('quality',{}).get('${prover_key}Status','unknown'))" 2>/dev/null || echo "unknown")
        if [ "$STATUS" = "stub" ]; then
            if [ "$QUICK_MODE" != "--quick" ]; then
                echo -e "${YELLOW}[INFO]${NC} ${prover_key}: status=stub (generated, not independently verified)"
            fi
        fi
    done
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Check hooks are installed ─────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking git hooks...${NC}"

    if [ -f "$REPO_ROOT/.git/hooks/pre-commit" ]; then
        if grep -q "riinac verify" "$REPO_ROOT/.git/hooks/pre-commit" 2>/dev/null; then
            echo -e "${GREEN}[OK]${NC} pre-commit hook installed (riinac verify)"
        else
            echo -e "${RED}[ERROR]${NC} pre-commit hook exists but is NOT the RIINA hook!"
            echo "         Run: bash 00_SETUP/scripts/install_hooks.sh"
            DISCREPANCIES=$((DISCREPANCIES + 1))
        fi
    else
        echo -e "${RED}[ERROR]${NC} pre-commit hook NOT installed!"
        echo "         Run: bash 00_SETUP/scripts/install_hooks.sh"
        DISCREPANCIES=$((DISCREPANCIES + 1))
    fi

    if [ -f "$REPO_ROOT/.git/hooks/pre-push" ]; then
        if grep -q "riinac verify" "$REPO_ROOT/.git/hooks/pre-push" 2>/dev/null; then
            echo -e "${GREEN}[OK]${NC} pre-push hook installed (riinac verify --full)"
        else
            echo -e "${RED}[ERROR]${NC} pre-push hook exists but is NOT the RIINA hook!"
            echo "         Run: bash 00_SETUP/scripts/install_hooks.sh"
            DISCREPANCIES=$((DISCREPANCIES + 1))
        fi
    else
        echo -e "${RED}[ERROR]${NC} pre-push hook NOT installed!"
        echo "         Run: bash 00_SETUP/scripts/install_hooks.sh"
        DISCREPANCIES=$((DISCREPANCIES + 1))
    fi
    echo ""
fi

# ── Count stale Tier 2 banners (informational) ───────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking Tier 2 banners...${NC}"

    STALE_BANNERS=0
    while IFS= read -r file; do
        # Skip Tier 3
        case "$file" in
            */01_RESEARCH/*|*/99_ARCHIVE/*|*/_archive_deprecated/*|*/CLAUDE_WEB_PROMPT_*|*/CLAUDE_AI_*|*/delegation_prompts/*) continue ;;
        esac
        banner_line=$(grep -E "^\*\*(Audit Update|Verification):\*\*" "$file" | head -1)
        # Check if banner has current Qed count
        if ! echo "$banner_line" | grep -q "${ACTUAL_QED_COMMA} Coq Qed" 2>/dev/null; then
            STALE_BANNERS=$((STALE_BANNERS + 1))
        fi
    done < <(grep -rlE "^\*\*(Audit Update|Verification):\*\*" "$REPO_ROOT" 2>/dev/null || true)

    if [ "$STALE_BANNERS" -gt 0 ]; then
        echo -e "${YELLOW}[WARN]${NC} $STALE_BANNERS files have stale verification banners"
        echo "         Run: bash scripts/sync-metrics.sh"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "${GREEN}[OK]${NC} All verification banners are current"
    fi
    echo ""
fi

# ── Check Coq warning budget status ───────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo -e "${CYAN}Checking Coq warning budget...${NC}"
fi

COQ_WARNING_STATUS="$REPO_ROOT/reports/coq_warning_status.json"
COQ_WARNING_BUDGET="$REPO_ROOT/reports/coq_warning_budget.json"
if [ -f "$COQ_WARNING_STATUS" ] && [ -f "$COQ_WARNING_BUDGET" ]; then
    COQ_WARN_EVAL=$(python3 - "$COQ_WARNING_STATUS" "$COQ_WARNING_BUDGET" "$(git -C "$REPO_ROOT" rev-parse HEAD 2>/dev/null || echo '')" "$(git -C "$REPO_ROOT" rev-parse HEAD^ 2>/dev/null || echo '')" <<'PY'
import json, sys
status_path, budget_path, head, parent = sys.argv[1:5]
with open(status_path, "r", encoding="utf-8") as f:
    status = json.load(f)
with open(budget_path, "r", encoding="utf-8") as f:
    budget = json.load(f)

repo_head = status.get("repoHead", "")
fresh = repo_head in {head, parent}

totals = status.get("totals", {})
obs_total = int(totals.get("warnings", 0))
obs_kinds = totals.get("kinds", {})
if not isinstance(obs_kinds, dict):
    obs_kinds = {}

max_total = int(budget.get("maxTotalWarnings", 0))
max_by_kind = budget.get("maxByKind", {})
if not isinstance(max_by_kind, dict):
    max_by_kind = {}

bad = []
if obs_total > max_total:
    bad.append(f"total={obs_total}>{max_total}")
for k, v in obs_kinds.items():
    observed = int(v)
    allowed = int(max_by_kind.get(k, 0))
    if observed > allowed:
        bad.append(f"{k}={observed}>{allowed}")

print(f"fresh={'true' if fresh else 'false'}")
print(f"total={obs_total}")
print(f"budget_total={max_total}")
print(f"violations={'|'.join(bad)}")
PY
)
    COQ_WARN_FRESH="$(printf '%s\n' "$COQ_WARN_EVAL" | awk -F= '/^fresh=/{print $2}' | tail -1)"
    COQ_WARN_TOTAL="$(printf '%s\n' "$COQ_WARN_EVAL" | awk -F= '/^total=/{print $2}' | tail -1)"
    COQ_WARN_BUDGET_TOTAL="$(printf '%s\n' "$COQ_WARN_EVAL" | awk -F= '/^budget_total=/{print $2}' | tail -1)"
    COQ_WARN_VIOLATIONS="$(printf '%s\n' "$COQ_WARN_EVAL" | awk -F= '/^violations=/{print $2}' | tail -1)"

    if [ "$COQ_WARN_FRESH" != "true" ]; then
        if [ "$QUICK_MODE" != "--quick" ]; then
            echo -e "${YELLOW}[WARN]${NC} Coq warning status is stale (run: python3 scripts/audit-coq-warnings.py --mode build --clean --enforce-budget)"
        fi
        WARNINGS=$((WARNINGS + 1))
    else
        if [ -n "$COQ_WARN_VIOLATIONS" ]; then
            if [ "$QUICK_MODE" != "--quick" ]; then
                echo -e "${RED}[MISMATCH]${NC} Coq warning budget exceeded: $COQ_WARN_VIOLATIONS"
            fi
            DISCREPANCIES=$((DISCREPANCIES + 1))
        else
            if [ "$QUICK_MODE" != "--quick" ]; then
                echo -e "${GREEN}[OK]${NC} Coq warning budget: total=$COQ_WARN_TOTAL (budget=$COQ_WARN_BUDGET_TOTAL)"
            fi
        fi
    fi
else
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "${YELLOW}[WARN]${NC} Coq warning status/budget missing (run: python3 scripts/audit-coq-warnings.py --mode build --clean --write-budget)"
    fi
    WARNINGS=$((WARNINGS + 1))
fi
if [ "$QUICK_MODE" != "--quick" ]; then echo ""; fi

# ── Final report ──────────────────────────────────────────────────────

if [ "$QUICK_MODE" != "--quick" ]; then
    echo "================================================================"
fi
if [ "$DISCREPANCIES" -gt 0 ]; then
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "  ${RED}AUDIT FAILED${NC}"
        echo ""
        echo "  Discrepancies: $DISCREPANCIES"
        echo "  Warnings:      $WARNINGS"
        echo ""
        echo "  FIX ALL DISCREPANCIES BEFORE COMMITTING."
        echo "  Run: bash scripts/sync-metrics.sh"
        echo "================================================================"
    fi
    exit 1
elif [ "$WARNINGS" -gt 0 ]; then
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "  ${YELLOW}AUDIT PASSED WITH WARNINGS${NC}"
        echo ""
        echo "  Discrepancies: 0"
        echo "  Warnings:      $WARNINGS"
        echo ""
        echo "  Review warnings. Proceed with caution."
        echo "================================================================"
    fi
    exit 0
else
    if [ "$QUICK_MODE" != "--quick" ]; then
        echo -e "  ${GREEN}AUDIT PASSED${NC}"
        echo ""
        echo "  All documentation is current."
        echo "  Proceed with commit."
        echo "================================================================"
    fi
    exit 0
fi
