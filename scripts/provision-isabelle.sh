#!/usr/bin/env bash
# ============================================================================
# provision-isabelle.sh
#
# Deterministically provision a pinned local Isabelle toolchain for RIINA.
#
# Installs into:
#   05_TOOLING/tools/isabelle/
#
# Usage:
#   bash scripts/provision-isabelle.sh
#
# Optional env overrides:
#   RIINA_ISABELLE_TOOLS_DIR
#   RIINA_ISABELLE_VERSION
#   RIINA_ISABELLE_URL
#   RIINA_ISABELLE_SHA256
#   RIINA_ISABELLE_KEEP_ARCHIVE=1        # keep downloaded tarball
#   RIINA_ISABELLE_VERIFY_RIINA_CORE=1   # run RIINA_CORE smoke build
# ============================================================================

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
TOOLS_DIR="${RIINA_ISABELLE_TOOLS_DIR:-$REPO_ROOT/05_TOOLING/tools/isabelle}"
VERSION="${RIINA_ISABELLE_VERSION:-2024}"
ARCHIVE_NAME="Isabelle${VERSION}_linux.tar.gz"
DEFAULT_URL="https://isabelle.in.tum.de/website-Isabelle${VERSION}/dist/${ARCHIVE_NAME}"
URL="${RIINA_ISABELLE_URL:-$DEFAULT_URL}"
SHA256_EXPECTED="${RIINA_ISABELLE_SHA256:-603aaaf8abea36597af3b0651d2c162a86c0a0dd4420766f47e5724039639267}"
INSTALL_DIR="${TOOLS_DIR}/Isabelle${VERSION}"
CURRENT_LINK="${TOOLS_DIR}/current"
BIN_PATH="${CURRENT_LINK}/bin/isabelle"
MANIFEST_PATH="${TOOLS_DIR}/INSTALL_MANIFEST.json"

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
echo "  RIINA LOCAL ISABELLE PROVISIONING"
echo "================================================================"
echo "version:  Isabelle${VERSION}"
echo "url:      ${URL}"
echo "install:  ${TOOLS_DIR}"

mkdir -p "$TOOLS_DIR"

tmp_archive="$(mktemp "/tmp/isabelle-${VERSION}.XXXXXX.tar.gz")"
tmp_extract="$(mktemp -d "/tmp/isabelle-${VERSION}.XXXXXX")"

cleanup() {
  rm -rf "$tmp_extract"
  if [ "${RIINA_ISABELLE_KEEP_ARCHIVE:-0}" != "1" ]; then
    rm -f "$tmp_archive"
  fi
}
trap cleanup EXIT

echo "Downloading archive..."
download_file "$URL" "$tmp_archive"

actual_sha="$(sha256_file "$tmp_archive")"
if [ "$actual_sha" != "$SHA256_EXPECTED" ]; then
  echo -e "${RED}ERROR: Isabelle archive checksum mismatch.${NC}" >&2
  echo "Expected: $SHA256_EXPECTED" >&2
  echo "Got     : $actual_sha" >&2
  exit 1
fi
echo -e "${GREEN}[ok]${NC} checksum verified"

echo "Extracting..."
tar -xzf "$tmp_archive" -C "$tmp_extract"

if [ ! -d "$tmp_extract/Isabelle${VERSION}" ]; then
  echo -e "${RED}ERROR: expected extracted directory Isabelle${VERSION} not found.${NC}" >&2
  exit 1
fi

rm -rf "$INSTALL_DIR"
mv "$tmp_extract/Isabelle${VERSION}" "$INSTALL_DIR"

ln -sfn "Isabelle${VERSION}" "$CURRENT_LINK"

if [ ! -x "$BIN_PATH" ]; then
  echo -e "${RED}ERROR: installed Isabelle binary not found at ${BIN_PATH}.${NC}" >&2
  exit 1
fi

version_line="$("$BIN_PATH" version 2>/dev/null | head -n 1 || true)"
if [[ "$version_line" != *"Isabelle${VERSION}"* ]]; then
  echo -e "${RED}ERROR: unexpected Isabelle version output.${NC}" >&2
  echo "Output: ${version_line}" >&2
  exit 1
fi
echo -e "${GREEN}[ok]${NC} version check: ${version_line}"

if [ "${RIINA_ISABELLE_VERIFY_RIINA_CORE:-0}" = "1" ]; then
  echo "Running RIINA_CORE smoke build..."
  "$BIN_PATH" build -d "$REPO_ROOT/02_FORMAL/isabelle/RIINA/Core" -b RIINA_CORE >/dev/null
  echo -e "${GREEN}[ok]${NC} RIINA_CORE smoke build passed"
fi

bin_sha="$(sha256_file "$BIN_PATH")"
archive_size="$(stat -c '%s' "$tmp_archive" 2>/dev/null || wc -c < "$tmp_archive")"

cat > "$MANIFEST_PATH" <<EOF_JSON
{
  "generated_utc": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "version": "Isabelle${VERSION}",
  "url": "$(escape_json "$URL")",
  "archive_sha256_expected": "$SHA256_EXPECTED",
  "archive_sha256_actual": "$actual_sha",
  "archive_size_bytes": $archive_size,
  "install_dir": "$(escape_json "$INSTALL_DIR")",
  "current_link": "$(escape_json "$CURRENT_LINK")",
  "isabelle_bin": "$(escape_json "$BIN_PATH")",
  "isabelle_bin_sha256": "$bin_sha",
  "isabelle_version_output": "$(escape_json "$version_line")"
}
EOF_JSON

echo ""
echo -e "${GREEN}Provisioned Isabelle toolchain.${NC}"
echo "Manifest: $MANIFEST_PATH"
echo ""
echo "Export for deterministic local use:"
echo "  export RIINA_ISABELLE_HOME=\"$CURRENT_LINK\""
echo "  export RIINA_ISABELLE_BIN=\"$BIN_PATH\""
echo "  export ISABELLE_HOME=\"$CURRENT_LINK\""
echo ""
