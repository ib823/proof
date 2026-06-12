#!/bin/bash
#═══════════════════════════════════════════════════════════════════════════════════
#  RIINA COMPREHENSIVE INTEGRITY VERIFICATION
#  Run manually for integrity monitoring
#═══════════════════════════════════════════════════════════════════════════════════

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║  RIINA INTEGRITY VERIFICATION REPORT                             ║"
echo "║  Generated: $TIMESTAMP"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# 1. Git State
echo "=== GIT STATE ==="
echo "Branch:  $(git -C "$REPO_ROOT" branch --show-current)"
echo "HEAD:    $(git -C "$REPO_ROOT" rev-parse HEAD)"
echo "Date:    $(git -C "$REPO_ROOT" log -1 --format=%ci)"
echo "Author:  $(git -C "$REPO_ROOT" log -1 --format='%an <%ae>')"
echo "Sig:     $(git -C "$REPO_ROOT" log -1 --format='%G? %GK' | head -1)"
echo ""

# 2. Signature Verification (last 20 commits)
echo "=== SIGNATURES (last 20) ==="
git -C "$REPO_ROOT" log --pretty=format:"%h %G? %s" -20
echo ""
echo ""

UNSIGNED=$(git -C "$REPO_ROOT" log --pretty=format:"%H %G?" -50 | awk '$2 != "G" && $2 != "U" && $2 != "N" { c++ } END { print c+0 }')
NOSIG=$(git -C "$REPO_ROOT" log --pretty=format:"%H %G?" -50 | awk '$2 == "N" { c++ } END { print c+0 }')
echo "Unsigned (bad sig): $UNSIGNED in last 50 commits"
echo "No signature:       $NOSIG in last 50 commits"
echo ""

# 3. Repository State Hash
echo "=== REPOSITORY STATE HASH ==="
REPO_HASH=$(find "$REPO_ROOT" -type f \( -name "*.v" -o -name "*.rs" -o -name "*.md" -o -name "*.toml" \) \
    -not -path "*/.git/*" -not -path "*/target/*" \
    -exec sha256sum {} \; | sort | sha256sum | cut -d' ' -f1)
echo "Hash: $REPO_HASH"
echo ""

# 4. Remote comparison
echo "=== REMOTE STATE ==="
git -C "$REPO_ROOT" fetch origin 2>/dev/null || echo "(fetch failed)"
LOCAL_HEAD=$(git -C "$REPO_ROOT" rev-parse HEAD)
REMOTE_HEAD=$(git -C "$REPO_ROOT" rev-parse origin/main 2>/dev/null || echo "UNKNOWN")
echo "Local:  $LOCAL_HEAD"
echo "Remote: $REMOTE_HEAD"
if [ "$LOCAL_HEAD" = "$REMOTE_HEAD" ]; then
    echo "Status: IN SYNC"
else
    echo "Status: DIVERGED"
fi
echo ""

# 5. Proof integrity summary
echo "=== PROOF INTEGRITY ==="
COQ_ROOT="$REPO_ROOT/02_FORMAL/coq"
COQ_PROJECT="$COQ_ROOT/_CoqProject"

ACTIVE_FILES=0
ACTIVE_ADMITTED=0
ACTIVE_AXIOMS=0
ACTIVE_ASSUMPTIONS=0

if [ -f "$COQ_PROJECT" ]; then
    while IFS= read -r rel; do
        path="$COQ_ROOT/$rel"
        [ -f "$path" ] || continue
        ACTIVE_FILES=$((ACTIVE_FILES + 1))

        admitted_hits=$(grep -Ec '^[[:space:]]*Admitted\.' "$path" || true)
        axiom_hits=$(grep -Ec '^[[:space:]]*Axiom[[:space:]]+' "$path" || true)
        assumption_hits=$(grep -Ec '^[[:space:]]*Parameter[[:space:]]+val_rel_n_step_up[[:space:]]' "$path" || true)

        ACTIVE_ADMITTED=$((ACTIVE_ADMITTED + admitted_hits))
        ACTIVE_AXIOMS=$((ACTIVE_AXIOMS + axiom_hits))
        ACTIVE_ASSUMPTIONS=$((ACTIVE_ASSUMPTIONS + assumption_hits))
    done < <(
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
fi

GLOBAL_ADMITTED=0
GLOBAL_AXIOMS=0
while IFS= read -r file; do
    admitted_hits=$(grep -Ec '^[[:space:]]*Admitted\.' "$file" || true)
    axiom_hits=$(grep -Ec '^[[:space:]]*Axiom[[:space:]]+' "$file" || true)
    GLOBAL_ADMITTED=$((GLOBAL_ADMITTED + admitted_hits))
    GLOBAL_AXIOMS=$((GLOBAL_AXIOMS + axiom_hits))
done < <(find "$REPO_ROOT/02_FORMAL" -name "*.v" -type f 2>/dev/null)

echo "Active build (_CoqProject):"
echo "  Files:              $ACTIVE_FILES"
echo "  Admitted:           $ACTIVE_ADMITTED"
echo "  Axioms:             $ACTIVE_AXIOMS"
echo "  Explicit assumptions: $ACTIVE_ASSUMPTIONS"
echo "Global repo (includes archived/non-active):"
echo "  Admitted:           $GLOBAL_ADMITTED"
echo "  Axioms:             $GLOBAL_AXIOMS"
echo ""

echo "=== SUMMARY ==="
echo "Timestamp: $TIMESTAMP"
echo "Repo Hash: $REPO_HASH"
echo "Commit:    $(git -C "$REPO_ROOT" rev-parse --short HEAD)"
echo ""
echo "Store this output securely. Compare repo hashes across runs to detect changes."
