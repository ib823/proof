#!/usr/bin/env bash
# ============================================================================
# sync-public.sh — Sync validated main commits to public branch
#
# MANDATORY FLOW:
#   1. All work happens on main
#   2. Commit on main (pre-commit: riinac verify --fast)
#   3. Push main (pre-push: riinac verify --full)
#   4. Run this script to sync to public
#
# Usage:
#   bash scripts/sync-public.sh              # Sync latest main commit
#   bash scripts/sync-public.sh <commit>     # Sync specific commit
#   bash scripts/sync-public.sh <from>..<to> # Sync range of commits
#
# This script:
#   - Verifies you are on main and it's clean
#   - Verifies the commit(s) exist on main
#   - Switches to public branch
#   - Cherry-picks the commit(s)
#   - Removes internal files that should not be on public
#   - Amends the cherry-pick to exclude them
#   - Pushes public
#   - Switches back to main
# ============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_ROOT="$(git rev-parse --show-toplevel)"

# Internal files/dirs that must NEVER appear on public
INTERNAL_PATHS=(
    # --- Internal directories ---
    "01_RESEARCH/"
    "06_COORDINATION/"
    "99_ARCHIVE/"
    "claude_ai_output/"
    "dist/"

    # --- Internal docs ---
    "CLAUDE.md"
    "PROGRESS.md"
    "SESSION_LOG.md"
    "REPO_PROTECTION_GUIDE.md"
    "WORKER_B_SPEC_STORE_REL_REWRITE.md"
    "VERIFICATION_MANIFEST.md"
    "axiom_audit_report.txt"
    "riina-website.jsx"
    "AUDIT_REPORT_2026_02_06.md"

    # --- Coq internal strategy/delegation files ---
    "02_FORMAL/coq/CLAUDE_*.md"
    "02_FORMAL/coq/DELEGATION_TASKS.md"
    "02_FORMAL/coq/TASK_PROMPTS.md"
    "02_FORMAL/coq/ZERO_AXIOM_ATTACK_PLAN.md"
    "02_FORMAL/coq/AXIOM_ELIMINATION_STRATEGY.md"
    "02_FORMAL/coq/_CoqProject.backup"
    "02_FORMAL/coq/properties/_archive_deprecated/"
    "02_FORMAL/coq/properties/BRIDGE_ANALYSIS_CONCLUSION.md"
    "02_FORMAL/coq/properties/check_ax.v"

    # --- Confidential specs ---
    "04_SPECS/business/"
    "04_SPECS/RIINA_PRIME_DIRECTIVE_GAP_CLOSURE.md"
    "04_SPECS/scope/RIINA_RESEARCH_EXECUTION_MAP.md"

    # --- Strategy/internal planning docs ---
    "*STRATEGY*.md"
    "*ATTACK*.md"
    "*PLAN*.md"
    "BRIDGE_ANALYSIS_*.md"
    "*_GAP_CLOSURE*.md"
    "*PRIME_DIRECTIVE*.md"
    "AUDIT_REPORT_*.md"
    "RESEARCH_STATUS_AUDIT.md"

    # --- Internal workflow docs ---
    "COMMIT_PROTOCOL.md"

    # --- Local toolchain installs (must never be published) ---
    "05_TOOLING/tools/isabelle/"
    "05_TOOLING/tools/fstar/"

    # --- Internal audit/gap analysis docs ---
    "04_SPECS/cross-cutting/EXHAUSTIVENESS_AUDIT.md"
    "04_SPECS/cross-cutting/RESEARCH_COMPONENTS_AUDIT_*.md"

    # --- Internal sync/verification scripts (not needed by external users) ---
    "scripts/sync-public.sh"
    "scripts/verify-public.sh"
    "scripts/sync-metrics.sh"
    "scripts/verify-riina-deploy.sh"
    "scripts/generate-full-stack.py"

    # --- IDE/editor config ---
    ".cursor/"

    # --- Stray artifacts (screenshots, backups, caches, test files) ---
    "Screenshot_*.jpg"
    "image.png"
    "05_TOOLING/test_inversion"
    "05_TOOLING/test_inversion.rs"
)

# Glob patterns to sweep (git ls-files + rm)
INTERNAL_GLOBS=(
    "*.bak"
    "*.backup"
    "*.old"
    "*.tmp"
    "*.aux"
    "*.glob"
    "*.vo"
    "*.vos"
    "*.vok"
    "*.crashcoqide"
    "*_test_print.v"
    ".lia.cache"
    ".nia.cache"
    "02_FORMAL/coq/.lia.cache"
    "02_FORMAL/coq/.nia.cache"
)

# ── Shared helpers ──────────────────────────────────────────────────────────

# Does $1 match the internal-exclusion lists?
is_internal_path() {
    local f="$1" pattern glob
    for pattern in "${INTERNAL_PATHS[@]}"; do
        case "$f" in
            $pattern*) return 0 ;;
        esac
    done
    for glob in "${INTERNAL_GLOBS[@]}"; do
        case "$f" in
            $glob) return 0 ;;
        esac
    done
    return 1
}

# Remove every internal path/glob from the index and working tree.
strip_internals() {
    local pattern glob MATCHED
    for pattern in "${INTERNAL_PATHS[@]}"; do
        git rm -rf --quiet --ignore-unmatch "$pattern" 2>/dev/null || true
        if ls $REPO_ROOT/$pattern 1>/dev/null 2>&1; then
            rm -rf $REPO_ROOT/$pattern 2>/dev/null || true
        fi
    done
    for glob in "${INTERNAL_GLOBS[@]}"; do
        MATCHED=$(git ls-files "$glob" 2>/dev/null || true)
        if [ -n "$MATCHED" ]; then
            while IFS= read -r f; do
                git rm -f --quiet "$f" 2>/dev/null || true
            done <<< "$MATCHED"
        fi
    done
}

# Regenerate the proof ledgers against the tree we are on and stage them.
# PROOF_STATUS.md/AXIOMS.md global counts are tree-derived; main's blob embeds
# the unpublished properties/_archive_deprecated/, so the freshness gate
# (update-proof-ledger.sh --check) can only pass on the curated public tree
# if the committed ledgers are regenerated FROM that tree.
regen_public_ledgers() {
    if [ -f "$REPO_ROOT/scripts/update-proof-ledger.sh" ]; then
        bash "$REPO_ROOT/scripts/update-proof-ledger.sh" >/dev/null
        git add PROOF_STATUS.md AXIOMS.md 2>/dev/null || true
    fi
}

# Run verify-public.sh against the current (public) tree. The script itself is
# internal-excluded — it does not exist on public — so run main's copy;
# previously a plain [ -f ] guard made the whole gate silently self-skip.
run_verify_public() {
    local tmp rc=0
    tmp="$(mktemp)"
    if git cat-file -e main:scripts/verify-public.sh 2>/dev/null; then
        git show main:scripts/verify-public.sh > "$tmp"
    elif [ -f "$REPO_ROOT/scripts/verify-public.sh" ]; then
        cp "$REPO_ROOT/scripts/verify-public.sh" "$tmp"
    else
        echo -e "${RED}ERROR: verify-public.sh not found on main or in working tree${NC}"
        rm -f "$tmp"
        return 1
    fi
    bash "$tmp" || rc=$?
    rm -f "$tmp"
    return $rc
}

# Clear any cherry-pick/sequencer state (a previous conflict-stopped run left
# state that made the next run spuriously report "no new changes").
cleanup_sequencer() {
    git cherry-pick --abort 2>/dev/null || true
    rm -rf "$REPO_ROOT/.git/sequencer" 2>/dev/null || true
}

echo ""
echo "================================================================"
echo "  RIINA: SYNC MAIN → PUBLIC"
echo "================================================================"
echo ""

# Step 1: Verify we're on main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}ERROR: Must be on main branch (currently on: $CURRENT_BRANCH)${NC}"
    echo "Run: git checkout main"
    exit 1
fi
echo -e "${GREEN}[✓] On main branch${NC}"

# Step 2: Verify working tree is clean (tolerate auto-generated verification reports)
DIRTY_FILES=$(git diff --name-only HEAD | grep -Ev "^(VERIFICATION_MANIFEST.md|reports/public_quality_status.json|reports/easier_gap_status.json)$" || true)
if [ -n "$DIRTY_FILES" ]; then
    echo -e "${RED}ERROR: Uncommitted changes on main. Commit or stash first.${NC}"
    echo "$DIRTY_FILES"
    exit 1
fi
# Restore auto-generated files if modified by hooks/gates
git reset HEAD VERIFICATION_MANIFEST.md reports/public_quality_status.json reports/easier_gap_status.json 2>/dev/null || true
git checkout -- VERIFICATION_MANIFEST.md reports/public_quality_status.json reports/easier_gap_status.json 2>/dev/null || true
echo -e "${GREEN}[✓] Working tree clean${NC}"

# Step 3: Verify main has been pushed (commits are validated by pre-push hook)
LOCAL_HEAD=$(git rev-parse main)
REMOTE_HEAD=$(git rev-parse origin/main 2>/dev/null || echo "none")
if [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
    echo -e "${RED}ERROR: main has unpushed commits.${NC}"
    echo "Push main first (pre-push hook will run riinac verify --full):"
    echo "  git push origin main"
    exit 1
fi
echo -e "${GREEN}[✓] main is pushed and validated${NC}"

# Step 3b: Enforce public quality gates on main before sync
if [ -f "$REPO_ROOT/scripts/public-quality-gates.sh" ]; then
    echo "Running public quality gates on main..."
    if ! bash "$REPO_ROOT/scripts/public-quality-gates.sh"; then
        echo -e "${RED}ERROR: Public quality gates failed on main. Fix before sync.${NC}"
        exit 1
    fi
    # public-quality-gates writes reports/public_quality_status.json; keep tree clean
    git reset HEAD reports/public_quality_status.json 2>/dev/null || true
    git checkout -- reports/public_quality_status.json 2>/dev/null || true
else
    echo -e "${RED}ERROR: scripts/public-quality-gates.sh missing on main${NC}"
    exit 1
fi

# Step 4-R: --reconcile mode — content-level drift repair (TRACK_F fix).
#
# WHY: the range cherry-pick below stops at the first conflicting commit
# (git leaves the sequencer mid-range; later commits in the range are never
# applied) and the partial result is committed anyway. Years of such partial
# squashes left public's tree silently stale — e.g. the Coq corpus on public
# carried 7,105 Qed while the published metrics.json claimed 12,613, making
# the public claims non-reproducible from the public tree.
#
# WHAT: for every file tracked on main that is not internal-excluded, set
# public's content to main's exact blob (adds + updates; deliberately does
# NOT delete public files absent from main — curation decisions stay with
# the owner). Also enforces INTERNAL_PATHS/INTERNAL_GLOBS against files
# already tracked on public (removes historical leaks). The staged diff is
# then self-checked for contamination before the normal commit+push tail.
if [ "${1:-}" = "--reconcile" ]; then
    echo ""
    echo "Reconcile mode: setting public's tree to main's content (minus internals)..."
    MAIN_SHA="$(git rev-parse --short main)"
    git checkout public --quiet
    cleanup_sequencer

    # Build the list of public-destined files tracked on main.
    SYNC_LIST="$(mktemp)"
    git ls-tree -r --name-only main | while IFS= read -r f; do
        IS_INTERNAL=false
        for pattern in "${INTERNAL_PATHS[@]}"; do
            case "$f" in
                $pattern*) IS_INTERNAL=true; break ;;
            esac
        done
        if ! $IS_INTERNAL; then
            for glob in "${INTERNAL_GLOBS[@]}"; do
                case "$f" in
                    $glob) IS_INTERNAL=true; break ;;
                esac
            done
        fi
        $IS_INTERNAL || printf '%s\0' "$f"
    done > "$SYNC_LIST"
    tr -cd '\0' < "$SYNC_LIST" | wc -c | xargs -I{} echo "    Files to sync from main: {}"
    xargs -0 git checkout main -- < "$SYNC_LIST"
    rm -f "$SYNC_LIST"

    # Enforce the internal lists against files already tracked on public.
    strip_internals

    # Ledgers must be reproducible from the public tree itself.
    regen_public_ledgers

    git add -A

    # Contamination self-check on exactly what this commit would publish
    # (added lines only — removing a leaked file must not trip the check).
    if git diff --cached | grep -E '^\+' | grep -qE 'ib823/proof|/workspaces/proof'; then
        echo -e "${RED}ERROR: reconcile diff contains internal references. NOT committing.${NC}"
        git reset --hard HEAD --quiet
        git checkout main --quiet
        exit 1
    fi

    if git diff --cached --quiet; then
        echo -e "${GREEN}[✓] Public already matches main (nothing to reconcile)${NC}"
        git checkout main --quiet
        exit 0
    fi

    git commit --no-verify --quiet -m "[ALL] CHORE: reconcile public tree with main ($MAIN_SHA)

Content-level drift repair: sets every public-destined file to main's exact
blob and enforces the internal-exclusion lists against historical leaks.
Repairs staleness accumulated by conflict-stopped range syncs (see
scripts/sync-public.sh --reconcile).

Synced from main ($MAIN_SHA). Internal files excluded."
    echo -e "${GREEN}[✓] Committed reconciliation on public${NC}"

    echo "Running post-reconcile verification (main's verify-public.sh)..."
    if ! run_verify_public; then
        echo -e "${RED}ERROR: Public branch verification failed. NOT pushing.${NC}"
        echo "The reconcile commit is left on public for inspection."
        git checkout main --quiet
        exit 1
    fi

    echo "Pushing public..."
    git push origin public --no-verify
    echo -e "${GREEN}[✓] Public branch pushed to origin${NC}"

    # Deliberately origin-only: reconcile is a bulk content repair, so the
    # riina-mirror push (a force-push to another repo) stays with the normal
    # single-commit sync path where the delta is small and reviewable.
    if git remote | grep -q "^riina$"; then
        echo -e "${YELLOW}[!] riina remote configured but NOT pushed by reconcile mode.${NC}"
        echo "    Review origin/public first, then mirror via the normal sync path."
    fi

    git checkout main --quiet
    echo -e "${GREEN}[✓] Back on main${NC}"
    echo ""
    echo "================================================================"
    echo -e "  ${GREEN}RECONCILE COMPLETE${NC}"
    echo "================================================================"
    exit 0
fi

# Step 4: Determine commit(s) to sync.
# A range is expanded to its individual commits and each is cherry-picked,
# resolved, stripped, and committed SEPARATELY. (The old behavior — one
# `git cherry-pick <from>..<to> --no-commit` squash — stopped at the first
# conflicting commit, committed the partial result, and left sequencer state
# that made the next run spuriously report "no new changes".)
if [ $# -ge 1 ]; then
    COMMIT_ARG="$1"
else
    COMMIT_ARG="$(git rev-parse HEAD)"
    echo -e "${YELLOW}    Syncing latest main commit: $(git log --oneline -1 HEAD)${NC}"
fi

if [[ "$COMMIT_ARG" == *".."* ]]; then
    mapfile -t COMMITS < <(git rev-list --reverse --no-merges "$COMMIT_ARG")
    if [ ${#COMMITS[@]} -eq 0 ]; then
        echo -e "${YELLOW}    Range contains no commits. Nothing to sync.${NC}"
        exit 0
    fi
    echo "    Range expands to ${#COMMITS[@]} commit(s)."
else
    COMMITS=("$(git rev-parse "$COMMIT_ARG")")
fi

# Step 5: Switch to public and clear any stale cherry-pick/sequencer state
echo ""
echo "Switching to public branch..."
git checkout public --quiet
cleanup_sequencer

# On unresolvable failure: restore a clean public checkout, return to main.
abort_sync() {
    local c="$1"
    echo -e "${RED}ERROR: could not cherry-pick $(git rev-parse --short "$c") cleanly. Aborting sync.${NC}"
    echo "Commits synced before the failure (if any) remain committed on public"
    echo "but have NOT been pushed. Resolve manually or use --reconcile."
    cleanup_sequencer
    git reset --hard HEAD --quiet
    git checkout main --quiet
    exit 1
}

SYNCED_COUNT=0
SKIPPED_COUNT=0

sync_one_commit() {
    local c="$1" rc=0 f
    local short subj
    short="$(git rev-parse --short "$c")"
    subj="$(git log --format=%s -n 1 "$c")"
    echo "Cherry-picking $short  $subj"

    git cherry-pick --no-commit "$c" >/dev/null 2>&1 || rc=$?

    # Conflict policy: internal file → remove; public file → take main's
    # version; file deleted on main → accept the deletion.
    local UNMERGED
    UNMERGED=$(git diff --name-only --diff-filter=U 2>/dev/null || true)
    if [ -n "$UNMERGED" ]; then
        echo -e "${YELLOW}    Resolving conflicts...${NC}"
        while IFS= read -r f; do
            if is_internal_path "$f"; then
                echo -e "${YELLOW}      Removing internal: $f${NC}"
                git rm -f --quiet "$f" 2>/dev/null || true
            elif git cat-file -e "main:$f" 2>/dev/null; then
                echo -e "${GREEN}      Keeping (accept main): $f${NC}"
                git checkout main --quiet -- "$f" && git add "$f"
            else
                echo -e "${YELLOW}      Deleted on main: $f${NC}"
                git rm -f --quiet "$f" 2>/dev/null || true
            fi
        done <<< "$UNMERGED"
    elif [ $rc -ne 0 ]; then
        # cherry-pick failed without leaving unmerged paths (e.g. empty
        # commit) — treat an empty index as a skip below, otherwise abort.
        if ! git diff --cached --quiet || ! git diff --quiet; then
            abort_sync "$c"
        fi
    fi

    # Any conflict still unresolved is a policy failure — do not guess.
    if [ -n "$(git diff --name-only --diff-filter=U 2>/dev/null)" ]; then
        abort_sync "$c"
    fi

    # Strip internals, regenerate tree-derived ledgers, stage everything.
    strip_internals
    regen_public_ledgers
    git add -A
    strip_internals   # git add -A may have re-added internal working-tree files

    if git diff --cached --quiet; then
        echo -e "${YELLOW}    SKIP $short — no public-destined changes (internal-only or already applied)${NC}"
        git cherry-pick --quit 2>/dev/null || true
        git reset --hard HEAD --quiet
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        return 0
    fi

    # Use --no-verify because main was already fully verified by pre-push hook.
    # Without this, the pre-commit hook regenerates VERIFICATION_MANIFEST.md
    # during the commit, re-introducing an internal file to public.
    git commit --no-verify --quiet -m "$(cat <<EOF
$subj

Cherry-picked from main ($short).
Internal files excluded.
EOF
)"
    SYNCED_COUNT=$((SYNCED_COUNT + 1))
    echo -e "${GREEN}    [✓] Committed on public${NC}"
}

for c in "${COMMITS[@]}"; do
    sync_one_commit "$c"
done

echo ""
echo "Synced $SYNCED_COUNT commit(s), skipped $SKIPPED_COUNT (no public-destined changes)."

if [ "$SYNCED_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}    Nothing new for public branch.${NC}"
    git checkout main --quiet
    echo -e "${GREEN}[✓] Back on main${NC}"
    exit 0
fi

# Step 10: Post-sync verification gate (runs main's verify-public.sh — the
# script is internal-excluded so it does not exist on the public tree).
echo "Running post-sync verification..."
if ! run_verify_public; then
    echo -e "${RED}ERROR: Public branch verification failed. NOT pushing.${NC}"
    echo "Fix issues, then re-run sync."
    git checkout main --quiet
    exit 1
fi

# Step 11: Push public to origin and riina (ib823/riina)
# Use --no-verify because main was already fully verified by pre-push hook.
# Public branch doesn't have the full repo structure (03_PROTO is missing),
# so pre-push hook would fail trying to run riinac.
echo "Pushing public..."
git push origin public --no-verify
echo -e "${GREEN}[✓] Public branch pushed to origin${NC}"

# Also push to riina remote (public → main) if configured
if git remote | grep -q "^riina$"; then
    echo "Pushing to riina remote (public → main)..."
    git push riina public:main --force-with-lease --no-verify
    echo -e "${GREEN}[✓] Public branch pushed to riina (ib823/riina)${NC}"
fi

# Step 11: Switch back to main (clean any conflict artifacts first)
git reset --hard HEAD --quiet 2>/dev/null || true
git checkout main --quiet
echo -e "${GREEN}[✓] Back on main${NC}"

echo ""
echo "================================================================"
echo -e "  ${GREEN}SYNC COMPLETE${NC}"
echo "================================================================"
echo ""
