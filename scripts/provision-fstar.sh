#!/usr/bin/env bash
# ============================================================================
# provision-fstar.sh
#
# Deterministically provision a pinned local F* toolchain for RIINA.
#
# Installs into:
#   05_TOOLING/tools/fstar/
#
# Usage:
#   bash scripts/provision-fstar.sh
#
# Optional env overrides:
#   RIINA_FSTAR_TOOLS_DIR
#   RIINA_FSTAR_VERSION
#   RIINA_FSTAR_URL
#   RIINA_FSTAR_SHA256
#   RIINA_FSTAR_KEEP_ARCHIVE=1        # keep downloaded tarball
#   RIINA_FSTAR_VERIFY_ACTIVE=1       # run CryptographicSecurityActive smoke build
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
TOOLS_DIR="${RIINA_FSTAR_TOOLS_DIR:-$REPO_ROOT/05_TOOLING/tools/fstar}"
VERSION="${RIINA_FSTAR_VERSION:-2025.12.15}"
ARCHIVE_NAME="fstar-v${VERSION}-Linux-x86_64.tar.gz"
DEFAULT_URL="https://github.com/FStarLang/FStar/releases/download/v${VERSION}/${ARCHIVE_NAME}"
URL="${RIINA_FSTAR_URL:-$DEFAULT_URL}"
SHA256_EXPECTED="${RIINA_FSTAR_SHA256:-d175809ba0fbdacad871fa7ba049d966d1c12aee0c52b7c0c35d30a5a649ffd8}"
INSTALL_DIR="${TOOLS_DIR}/fstar-v${VERSION}"
CURRENT_LINK="${TOOLS_DIR}/current"
BIN_PATH="${CURRENT_LINK}/bin/fstar.exe"
MANIFEST_PATH="${TOOLS_DIR}/INSTALL_MANIFEST.json"
ACTIVE_FILE="$REPO_ROOT/02_FORMAL/fstar/RIINA/Active/CryptographicSecurityActive.fst"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

sha256_file() {
  local path="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$path" | awk '{print $1}'
    return 0
  fi
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$path" | awk '{print $1}'
    return 0
  fi
  if command -v openssl >/dev/null 2>&1; then
    openssl dgst -sha256 "$path" | awk '{print $NF}'
    return 0
  fi
  echo -e "${RED}ERROR: no SHA-256 tool found (sha256sum/shasum/openssl).${NC}" >&2
  return 1
}

download_file() {
  local url="$1"
  local out="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -L --fail --silent --show-error "$url" -o "$out"
    return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$out" "$url"
    return 0
  fi
  echo -e "${RED}ERROR: neither curl nor wget is available for download.${NC}" >&2
  return 1
}

escape_json() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

echo ""
echo "================================================================"
echo "  RIINA LOCAL F* PROVISIONING"
echo "================================================================"
echo "version:  F* ${VERSION}"
echo "url:      ${URL}"
echo "install:  ${TOOLS_DIR}"

mkdir -p "$TOOLS_DIR"

tmp_archive="$(mktemp "/tmp/fstar-${VERSION}.XXXXXX.tar.gz")"
tmp_extract="$(mktemp -d "/tmp/fstar-${VERSION}.XXXXXX")"

cleanup() {
  rm -rf "$tmp_extract"
  if [ "${RIINA_FSTAR_KEEP_ARCHIVE:-0}" != "1" ]; then
    rm -f "$tmp_archive"
  fi
}
trap cleanup EXIT

echo "Downloading archive..."
download_file "$URL" "$tmp_archive"

actual_sha="$(sha256_file "$tmp_archive")"
if [ "$actual_sha" != "$SHA256_EXPECTED" ]; then
  echo -e "${RED}ERROR: F* archive checksum mismatch.${NC}" >&2
  echo "Expected: $SHA256_EXPECTED" >&2
  echo "Got     : $actual_sha" >&2
  exit 1
fi
echo -e "${GREEN}[ok]${NC} checksum verified"

echo "Extracting..."
tar -xzf "$tmp_archive" -C "$tmp_extract"

if [ ! -d "$tmp_extract/fstar" ]; then
  echo -e "${RED}ERROR: expected extracted directory 'fstar' not found.${NC}" >&2
  exit 1
fi

rm -rf "$INSTALL_DIR"
mv "$tmp_extract/fstar" "$INSTALL_DIR"
ln -sfn "fstar-v${VERSION}" "$CURRENT_LINK"

if [ ! -x "$BIN_PATH" ]; then
  echo -e "${RED}ERROR: installed F* binary not found at ${BIN_PATH}.${NC}" >&2
  exit 1
fi

version_line="$("$BIN_PATH" --version 2>/dev/null | head -n 1 || true)"
if [[ "$version_line" != "F* ${VERSION}"* ]]; then
  echo -e "${RED}ERROR: unexpected F* version output.${NC}" >&2
  echo "Output: ${version_line}" >&2
  exit 1
fi
echo -e "${GREEN}[ok]${NC} version check: ${version_line}"

if [ "${RIINA_FSTAR_VERIFY_ACTIVE:-0}" = "1" ]; then
  if [ ! -f "$ACTIVE_FILE" ]; then
    echo -e "${RED}ERROR: active F* smoke file not found: ${ACTIVE_FILE}${NC}" >&2
    exit 1
  fi
  echo "Running CryptographicSecurityActive smoke build..."
  "$BIN_PATH" \
    --cache_checked_modules \
    --cache_dir /tmp/riina-fstar-active-cache \
    --include "$REPO_ROOT/02_FORMAL/fstar" \
    "$ACTIVE_FILE" >/dev/null
  echo -e "${GREEN}[ok]${NC} CryptographicSecurityActive smoke build passed"
fi

bin_sha="$(sha256_file "$BIN_PATH")"
archive_size="$(stat -c '%s' "$tmp_archive" 2>/dev/null || wc -c < "$tmp_archive")"

cat > "$MANIFEST_PATH" <<EOF_JSON
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "version": "F* ${VERSION}",
  "url": "$(escape_json "$URL")",
  "archive_sha256_expected": "$SHA256_EXPECTED",
  "archive_sha256_actual": "$actual_sha",
  "archive_size_bytes": $archive_size,
  "install_dir": "$(escape_json "$INSTALL_DIR")",
  "current_link": "$(escape_json "$CURRENT_LINK")",
  "fstar_bin": "$(escape_json "$BIN_PATH")",
  "fstar_bin_sha256": "$bin_sha",
  "fstar_version_output": "$(escape_json "$version_line")"
}
EOF_JSON

echo ""
echo -e "${GREEN}Provisioned F* toolchain.${NC}"
echo "Manifest: $MANIFEST_PATH"
echo ""
echo "Export for deterministic local use:"
echo "  export RIINA_FSTAR_HOME=\"$CURRENT_LINK\""
echo "  export RIINA_FSTAR_BIN=\"$BIN_PATH\""
echo ""
