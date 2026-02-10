#!/usr/bin/env bash
# ============================================================================
# verify-riina-deploy.sh — Verify end-state deploy on ib823/riina
#
# Checks:
#   1) riina/main exists and matches origin/public (if origin/public exists)
#   2) riina/gh-pages exists
#   3) Live site endpoints respond (/, /metrics.json, /install.sh) unless skipped
#
# Usage:
#   bash scripts/verify-riina-deploy.sh
#   bash scripts/verify-riina-deploy.sh --skip-http
#   bash scripts/verify-riina-deploy.sh --remote riina --origin origin
# ============================================================================

set -euo pipefail

REMOTE="riina"
ORIGIN_REMOTE="origin"
SITE_URL="https://ib823.github.io/riina"
SKIP_HTTP=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
  cat <<'EOF'
Usage:
  bash scripts/verify-riina-deploy.sh [OPTIONS]

Options:
  --remote NAME       Remote for public deployment target (default: riina)
  --origin NAME       Primary remote containing public branch (default: origin)
  --site-url URL      Website URL base (default: https://ib823.github.io/riina)
  --skip-http         Skip live HTTP endpoint checks
  -h, --help          Show help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --remote)
      REMOTE="${2:-}"
      shift 2
      ;;
    --origin)
      ORIGIN_REMOTE="${2:-}"
      shift 2
      ;;
    --site-url)
      SITE_URL="${2:-}"
      shift 2
      ;;
    --skip-http)
      SKIP_HTTP=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown argument: $1${NC}"
      usage
      exit 1
      ;;
  esac
done

echo ""
echo "================================================================"
echo "  VERIFY RIINA DEPLOY END-STATE"
echo "================================================================"
echo "remote:   $REMOTE"
echo "origin:   $ORIGIN_REMOTE"
echo "site-url: $SITE_URL"
echo ""

if ! git remote | grep -qx "$REMOTE"; then
  echo -e "${RED}ERROR: remote '$REMOTE' not configured${NC}"
  exit 1
fi
echo -e "${GREEN}[✓] remote '$REMOTE' configured${NC}"

if ! git remote | grep -qx "$ORIGIN_REMOTE"; then
  echo -e "${RED}ERROR: remote '$ORIGIN_REMOTE' not configured${NC}"
  exit 1
fi
echo -e "${GREEN}[✓] remote '$ORIGIN_REMOTE' configured${NC}"

echo "Fetching remotes..."
git fetch "$REMOTE" main gh-pages --quiet
git fetch "$ORIGIN_REMOTE" main public --quiet || true
echo -e "${GREEN}[✓] remotes fetched${NC}"

if ! git show-ref --verify --quiet "refs/remotes/$REMOTE/main"; then
  echo -e "${RED}ERROR: $REMOTE/main not found${NC}"
  exit 1
fi
if ! git show-ref --verify --quiet "refs/remotes/$REMOTE/gh-pages"; then
  echo -e "${RED}ERROR: $REMOTE/gh-pages not found${NC}"
  exit 1
fi
echo -e "${GREEN}[✓] $REMOTE/main and $REMOTE/gh-pages exist${NC}"

REMOTE_MAIN_SHA="$(git rev-parse "refs/remotes/$REMOTE/main")"
REMOTE_GHPAGES_SHA="$(git rev-parse "refs/remotes/$REMOTE/gh-pages")"
echo "    $REMOTE/main:     $REMOTE_MAIN_SHA"
echo "    $REMOTE/gh-pages: $REMOTE_GHPAGES_SHA"

if git show-ref --verify --quiet "refs/remotes/$ORIGIN_REMOTE/public"; then
  ORIGIN_PUBLIC_SHA="$(git rev-parse "refs/remotes/$ORIGIN_REMOTE/public")"
  echo "    $ORIGIN_REMOTE/public: $ORIGIN_PUBLIC_SHA"
  if [ "$ORIGIN_PUBLIC_SHA" != "$REMOTE_MAIN_SHA" ]; then
    echo -e "${RED}ERROR: $REMOTE/main does not match $ORIGIN_REMOTE/public${NC}"
    exit 1
  fi
  echo -e "${GREEN}[✓] $REMOTE/main matches $ORIGIN_REMOTE/public${NC}"
else
  echo -e "${YELLOW}WARNING: $ORIGIN_REMOTE/public not found; skip parity check${NC}"
fi

if [ "$SKIP_HTTP" -eq 1 ]; then
  echo -e "${YELLOW}Skipping HTTP checks (--skip-http)${NC}"
else
  if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${RED}ERROR: python3 is required for HTTP checks${NC}"
    exit 1
  fi
  echo "Checking live endpoints..."
  python3 - "$SITE_URL" <<'PY'
import json
import sys
import urllib.error
import urllib.request

base = sys.argv[1].rstrip("/")
urls = [
    (f"{base}/", False),
    (f"{base}/metrics.json", True),
    (f"{base}/install.sh", False),
]

headers = {"User-Agent": "riina-deploy-verify/1.0"}

for url, expect_json in urls:
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=25) as resp:
            status = resp.getcode()
            body = resp.read()
    except urllib.error.URLError as e:
        print(f"ERROR: request failed for {url}: {e}")
        sys.exit(1)

    if status != 200:
        print(f"ERROR: non-200 status for {url}: {status}")
        sys.exit(1)

    if expect_json:
        try:
            obj = json.loads(body.decode("utf-8"))
        except Exception as e:
            print(f"ERROR: invalid JSON at {url}: {e}")
            sys.exit(1)

        required_top = ["version", "proofs", "claimLevels", "status"]
        missing = [k for k in required_top if k not in obj]
        if missing:
            print(f"ERROR: metrics.json missing keys: {missing}")
            sys.exit(1)

        claim = obj.get("claimLevels", {})
        status_obj = obj.get("status", {})
        print(
            "metrics.json OK: "
            f"version={obj.get('version')} "
            f"overall={claim.get('overall')} "
            f"build={status_obj.get('build')}"
        )
    else:
        print(f"OK: {url} (200)")
PY
  echo -e "${GREEN}[✓] live endpoint checks passed${NC}"
fi

echo ""
echo "================================================================"
echo -e "  ${GREEN}RIINA DEPLOY VERIFICATION PASSED${NC}"
echo "================================================================"
echo ""

