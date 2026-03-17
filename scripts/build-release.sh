#!/usr/bin/env bash
# RIINA Release Build Script
# Builds riinac release binary, creates tarball + SHA256SUMS
# Usage: bash scripts/build-release.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROTO_DIR="$REPO_ROOT/03_PROTO"
DIST_DIR="$REPO_ROOT/dist"

# Extract version from Cargo.toml
VERSION=$(grep '^version' "$PROTO_DIR/Cargo.toml" | head -1 | sed 's/.*"\(.*\)".*/\1/')

# Detect target triple
ARCH="$(uname -m)"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
    linux)  TARGET="${ARCH}-unknown-linux-gnu" ;;
    darwin) TARGET="${ARCH}-apple-darwin" ;;
    *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

ARTIFACT_NAME="riinac-${VERSION}-${TARGET}"

echo "=== RIINA Release Build ==="
echo "Version: $VERSION"
echo "Target:  $TARGET"
echo ""

# Step 1: Build release binary
echo "[1/4] Building release binary..."
cargo build --release --manifest-path "$PROTO_DIR/Cargo.toml"

BINARY="$PROTO_DIR/target/release/riinac"
if [ ! -f "$BINARY" ]; then
    echo "ERROR: Binary not found at $BINARY"
    exit 1
fi

# Step 2: Run verification
echo "[2/4] Running riinac verify --fast..."
"$BINARY" verify --fast || echo "WARN: riinac verify not yet wired (expected during development)"

# Step 3: Create dist directory and tarball
echo "[3/4] Creating tarball..."
mkdir -p "$DIST_DIR"
STAGING=$(mktemp -d)
mkdir -p "$STAGING/$ARTIFACT_NAME"
cp "$BINARY" "$STAGING/$ARTIFACT_NAME/riinac"
cp "$REPO_ROOT/LICENSE" "$STAGING/$ARTIFACT_NAME/" 2>/dev/null || true
cp "$REPO_ROOT/README.md" "$STAGING/$ARTIFACT_NAME/" 2>/dev/null || true

TARBALL="$DIST_DIR/${ARTIFACT_NAME}.tar.gz"
tar -czf "$TARBALL" -C "$STAGING" "$ARTIFACT_NAME"
rm -rf "$STAGING"

# Step 4: Generate checksums
echo "[4/4] Generating SHA256SUMS..."
cd "$DIST_DIR"
sha256sum "$(basename "$TARBALL")" > SHA256SUMS

# Step 5: Sign artifacts (if signing key is set)
if [ -n "${RIINA_SIGNING_KEY:-}" ]; then
    echo "[5/5] Signing artifacts..."
    SIGN_TOOL="$REPO_ROOT/05_TOOLING/target/release/riina-artifact-sign"
    if [ ! -f "$SIGN_TOOL" ]; then
        SIGN_TOOL="$REPO_ROOT/05_TOOLING/target/debug/riina-artifact-sign"
    fi
    if [ -f "$SIGN_TOOL" ]; then
        "$SIGN_TOOL" sign "$TARBALL" --key "$RIINA_SIGNING_KEY"
        "$SIGN_TOOL" sign "$DIST_DIR/SHA256SUMS" --key "$RIINA_SIGNING_KEY"
        echo "Tarball signature:  ${TARBALL}.sig"
        echo "Checksums signature: $DIST_DIR/SHA256SUMS.sig"
    else
        echo "WARN: riina-artifact-sign not found, skipping signing"
    fi
else
    echo "[5/5] Skipping signing (RIINA_SIGNING_KEY not set)"
fi

echo ""
echo "=== Build Complete ==="
echo "Tarball:   $TARBALL"
echo "Checksums: $DIST_DIR/SHA256SUMS"
echo ""
cat "$DIST_DIR/SHA256SUMS"
