#!/usr/bin/env bash
# ============================================================================
# security-gates.sh — Strict local security gates for RIINA
#
# Enforces:
#   1) Signed commit policy (required, not optional)
#   2) Secret pattern scanning on changed files in outgoing range(s)
#   3) Trojan source bidi-Unicode scan across source/docs
#
# Usage:
#   bash scripts/security-gates.sh
#   bash scripts/security-gates.sh --range origin/main..HEAD
#   bash scripts/security-gates.sh --range A..B --range C..D
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

RANGES=()

usage() {
  cat <<'EOF'
Usage:
  bash scripts/security-gates.sh [--range <git-range>]...

Examples:
  bash scripts/security-gates.sh
  bash scripts/security-gates.sh --range origin/main..HEAD
  bash scripts/security-gates.sh --range <old>..<new> --range <old2>..<new2>
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --range)
      if [ $# -lt 2 ]; then
        echo "ERROR: --range requires a value"
        exit 1
      fi
      RANGES+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [ ${#RANGES[@]} -eq 0 ]; then
  if git rev-parse --verify --quiet origin/main >/dev/null 2>&1; then
    RANGES=("origin/main..HEAD")
  elif git rev-parse --verify --quiet HEAD~1 >/dev/null 2>&1; then
    RANGES=("HEAD~1..HEAD")
  else
    RANGES=("HEAD")
  fi
fi

echo ""
echo "================================================================"
echo "  RIINA SECURITY GATES"
echo "================================================================"
echo "Ranges:"
for r in "${RANGES[@]}"; do
  echo "  - $r"
done

# Step 1: commit signature policy is mandatory
echo "[1/3] Enforcing signed-commit policy..."
GPG_SIGN="$(git config --get commit.gpgsign 2>/dev/null || echo "false")"
if [ "$GPG_SIGN" != "true" ]; then
  echo -e "${RED}FAIL: commit.gpgsign=false (or unset). Signed commits are mandatory.${NC}"
  echo "Run: git config --global commit.gpgsign true"
  exit 1
fi

UNSIGNED=""
for range in "${RANGES[@]}"; do
  COMMITS="$(git rev-list "$range" 2>/dev/null || true)"
  if [ -z "$COMMITS" ]; then
    continue
  fi

  while IFS= read -r sha; do
    [ -z "$sha" ] && continue
    sig="$(git log --format='%G?' -n 1 "$sha" 2>/dev/null || echo "?")"
    case "$sig" in
      G|U) : ;;
      *) UNSIGNED+="$sha $sig ($range)"$'\n' ;;
    esac
  done <<< "$COMMITS"
done

if [ -n "$UNSIGNED" ]; then
  echo -e "${RED}FAIL: Unsigned/unverified commits detected in outgoing range(s):${NC}"
  printf '%s' "$UNSIGNED"
  exit 1
fi
echo -e "${GREEN}      Signed-commit policy passed${NC}"

# Step 2: secret detection on changed files in outgoing range(s)
echo "[2/3] Scanning changed files for secrets..."
SECRETS_PATTERN='(password|secret|api[_-]?key|token|private[_-]?key)\s*[=:]\s*["\x27][^"\x27]+'
declare -A changed_files=()

for range in "${RANGES[@]}"; do
  while IFS= read -r path; do
    [ -z "$path" ] && continue
    changed_files["$path"]=1
  done < <(git diff --name-only --diff-filter=ACM "$range" 2>/dev/null || true)
done

if [ ${#changed_files[@]} -eq 0 ]; then
  echo -e "${YELLOW}      No changed files found in provided ranges; skipping range-limited secret scan${NC}"
else
  HITS=""
  for rel in "${!changed_files[@]}"; do
    case "$rel" in
      *.v|*.lean|*.thy) continue ;;
    esac

    abs="$REPO_ROOT/$rel"
    [ -f "$abs" ] || continue

    if grep -nEi "$SECRETS_PATTERN" "$abs" >/dev/null 2>&1; then
      HITS+="$rel"$'\n'
    fi
  done

  if [ -n "$HITS" ]; then
    echo -e "${RED}FAIL: Potential secrets detected in changed files:${NC}"
    printf '%s' "$HITS"
    exit 1
  fi
fi
echo -e "${GREEN}      Secret scan passed${NC}"

# Step 3: Trojan source scan (bidi unicode controls)
echo "[3/3] Scanning for Trojan source (bidi Unicode controls)..."
TROJAN="$(grep -rPl \
  '[\x{202A}\x{202B}\x{202C}\x{202D}\x{202E}\x{2066}\x{2067}\x{2068}\x{2069}]' \
  --include='*.v' --include='*.rs' --include='*.rii' --include='*.md' \
  --include='*.sh' --include='*.py' \
  "$REPO_ROOT" 2>/dev/null || true)"

if [ -n "$TROJAN" ]; then
  echo -e "${RED}FAIL: Trojan source characters detected:${NC}"
  echo "$TROJAN"
  exit 1
fi
echo -e "${GREEN}      Trojan-source scan passed${NC}"

echo ""
echo "================================================================"
echo -e "  ${GREEN}SECURITY GATES PASSED${NC}"
echo "================================================================"
