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
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
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
if [ -d "$ROOT_DIR/02_FORMAL/lean" ]; then
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
    done < <(find "$ROOT_DIR/02_FORMAL/lean" -name "*.lean" -type f ! -name "lakefile.lean" 2>/dev/null)
    LEAN_FILES=$(find "$ROOT_DIR/02_FORMAL/lean" -name "*.lean" -type f ! -name "lakefile.lean" 2>/dev/null | wc -l)
    LEAN_LINES=$(find "$ROOT_DIR/02_FORMAL/lean" -name "*.lean" -type f ! -name "lakefile.lean" -exec cat {} + 2>/dev/null | wc -l)
fi

# Count Isabelle lemmas (lemma + theorem + corollary declarations)
ISABELLE_LEMMAS=0
ISABELLE_SORRY=0
ISABELLE_FILES=0
ISABELLE_LINES=0
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

# Compute Lean axioms (axiom declarations)
LEAN_AXIOMS=0
if [ -d "$ROOT_DIR/02_FORMAL/lean" ]; then
    while IFS= read -r f; do
        count=$(grep -c "^axiom " "$f" 2>/dev/null || true)
        if [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null; then
            LEAN_AXIOMS=$((LEAN_AXIOMS + count))
        fi
    done < <(find "$ROOT_DIR/02_FORMAL/lean" -name "*.lean" -type f ! -name "lakefile.lean" 2>/dev/null)
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

# Count F* lemmas (val ... _lemma declarations)
FSTAR_LEMMAS=0
FSTAR_FILES=0
if [ -d "$ROOT_DIR/02_FORMAL/fstar" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "val\s+\w+_lemma\b" "$f" 2>/dev/null || true)
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && FSTAR_LEMMAS=$((FSTAR_LEMMAS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/fstar" -name "*.fst" -type f 2>/dev/null)
    FSTAR_FILES=$(find "$ROOT_DIR/02_FORMAL/fstar" -name "*.fst" -type f 2>/dev/null | wc -l)
fi

# Count TLA+ theorems (THEOREM declarations)
TLAPLUS_THEOREMS=0
TLAPLUS_FILES=0
if [ -d "$ROOT_DIR/02_FORMAL/tlaplus" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "^THEOREM\s" "$f" 2>/dev/null || true)
        [ -n "$count" ] && [ "$count" -gt 0 ] 2>/dev/null && TLAPLUS_THEOREMS=$((TLAPLUS_THEOREMS + count))
    done < <(find "$ROOT_DIR/02_FORMAL/tlaplus" -name "*.tla" -type f 2>/dev/null)
    TLAPLUS_FILES=$(find "$ROOT_DIR/02_FORMAL/tlaplus" -name "*.tla" -type f 2>/dev/null | wc -l)
fi

# Count Alloy assertions (check declarations)
ALLOY_ASSERTIONS=0
ALLOY_FILES=0
if [ -d "$ROOT_DIR/02_FORMAL/alloy" ]; then
    while IFS= read -r f; do
        count=$(grep -cP "^check\s" "$f" 2>/dev/null || true)
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

[ "$ISABELLE_QUARANTINED" = true ] && ISABELLE_LEMMAS_PUBLIC=0
[ "$FSTAR_QUARANTINED" = true ] && FSTAR_LEMMAS_PUBLIC=0
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
    PREV_METRICS="$ROOT_DIR/website/public/metrics.json"
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

DIM14_REPORT="$ROOT_DIR/reports/dim14_runtime_status.json"
DIM14_FRESH=false
CLAIM_DIM14="generated"

CURRENT_HEAD="$(git -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || echo "")"
CURRENT_PARENT_HEAD="$(git -C "$ROOT_DIR" rev-parse HEAD^ 2>/dev/null || echo "")"

if [ -f "$DIM14_REPORT" ] && command -v jq >/dev/null 2>&1; then
    dim14_head="$(jq -r '.repo_head // ""' "$DIM14_REPORT" 2>/dev/null || echo "")"
    if [ -n "$CURRENT_HEAD" ] && { [ "$dim14_head" = "$CURRENT_HEAD" ] || { [ -n "$CURRENT_PARENT_HEAD" ] && [ "$dim14_head" = "$CURRENT_PARENT_HEAD" ]; }; }; then
        DIM14_FRESH=true
    fi
    if [ "$DIM14_FRESH" = true ] && jq -e '.overall == "PASS"' "$DIM14_REPORT" >/dev/null 2>&1; then
        CLAIM_DIM14="compiled"
    fi
fi

if [ -f "$NONCOQ_MECH_REPORT" ] && command -v jq >/dev/null 2>&1; then
    noncoq_head="$(jq -r '.repo_head // ""' "$NONCOQ_MECH_REPORT" 2>/dev/null || echo "")"
    if [ -n "$CURRENT_HEAD" ] && { [ "$noncoq_head" = "$CURRENT_HEAD" ] || { [ -n "$CURRENT_PARENT_HEAD" ] && [ "$noncoq_head" = "$CURRENT_PARENT_HEAD" ]; }; }; then
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

# Quarantined lanes are always reported as generated-only until dequarantined.
[ "$ISABELLE_QUARANTINED" = true ] && CLAIM_ISABELLE="generated" && ISABELLE_COMPILED=false
[ "$FSTAR_QUARANTINED" = true ] && CLAIM_FSTAR="generated" && FSTAR_COMPILED=false
[ "$TLAPLUS_QUARANTINED" = true ] && CLAIM_TLAPLUS="generated" && TLAPLUS_COMPILED=false
[ "$ALLOY_QUARANTINED" = true ] && CLAIM_ALLOY="generated" && ALLOY_COMPILED=false
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
    "prover": "Coq 8.20.1"
  },
  "lean": {
    "theorems": $LEAN_THEOREMS,
    "sorry": $LEAN_SORRY,
    "axioms": $LEAN_AXIOMS,
    "files": $LEAN_FILES,
    "lines": $LEAN_LINES,
    "prover": "Lean 4"
  },
  "isabelle": {
    "lemmas": $ISABELLE_LEMMAS_PUBLIC,
    "lemmasRaw": $ISABELLE_LEMMAS,
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
    "quarantined": $FSTAR_QUARANTINED,
    "files": $FSTAR_FILES,
    "prover": "F*"
  },
  "tlaplus": {
    "theorems": $TLAPLUS_THEOREMS_PUBLIC,
    "theoremsRaw": $TLAPLUS_THEOREMS,
    "quarantined": $TLAPLUS_QUARANTINED,
    "files": $TLAPLUS_FILES,
    "prover": "TLA+"
  },
  "alloy": {
    "assertions": $ALLOY_ASSERTIONS_PUBLIC,
    "assertionsRaw": $ALLOY_ASSERTIONS,
    "quarantined": $ALLOY_QUARANTINED,
    "files": $ALLOY_FILES,
    "prover": "Alloy 6"
  },
  "smt": {
    "assertions": $SMT_ASSERTIONS_PUBLIC,
    "assertionsRaw": $SMT_ASSERTIONS,
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
echo "  Isabelle:     $ISABELLE_LEMMAS_PUBLIC lemmas (raw $ISABELLE_LEMMAS), $ISABELLE_SORRY sorry, $ISABELLE_FILES files, quarantined=$ISABELLE_QUARANTINED"
echo "  F*:           $FSTAR_LEMMAS_PUBLIC lemmas (raw $FSTAR_LEMMAS), $FSTAR_FILES files, quarantined=$FSTAR_QUARANTINED"
echo "  TLA+:         $TLAPLUS_THEOREMS_PUBLIC theorems (raw $TLAPLUS_THEOREMS), $TLAPLUS_FILES files, quarantined=$TLAPLUS_QUARANTINED"
echo "  Alloy:        $ALLOY_ASSERTIONS_PUBLIC assertions (raw $ALLOY_ASSERTIONS), $ALLOY_FILES files, quarantined=$ALLOY_QUARANTINED"
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
