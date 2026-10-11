#!/bin/bash
# TERAS Rust Installation Script

set -euo pipefail

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              TERAS Rust Installation Script                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"

# Check if already installed
if command -v rustc &> /dev/null; then
    VERSION=$(rustc --version)
    echo "Rust already installed: $VERSION"
    
    # Check if correct version (pinned to 1.94.x; see rust-toolchain.toml)
    if [[ "$VERSION" == *"1.94"* ]]; then
        echo "Version is compatible"
        exit 0
    fi
fi

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "Installing Rust..."

# Install rustup from a pinned, checksum-verified rustup-init binary (not a
# script piped from the network into sh).
RUSTUP_INIT_VERSION="1.29.1"
case "$(uname -m)" in
    x86_64)  RUSTUP_TARGET="x86_64-unknown-linux-gnu"
             RUSTUP_INIT_SHA256="dda7234360b7f578ca8b0ddcb80145646fa61a67c1720a5abc7051b35c9fcb71" ;;
    aarch64) RUSTUP_TARGET="aarch64-unknown-linux-gnu"
             RUSTUP_INIT_SHA256="15f6e4ce9f583b929c996c91562bad6d4454f3281de858b02cdfdef615fac433" ;;
    *) echo "ERROR: unsupported architecture $(uname -m) — install rustup manually"; exit 1 ;;
esac
RUSTUP_INIT="$(mktemp)"
trap 'rm -f "$RUSTUP_INIT"' EXIT
curl --proto '=https' --tlsv1.2 -sSfL -o "$RUSTUP_INIT" \
    "https://static.rust-lang.org/rustup/archive/${RUSTUP_INIT_VERSION}/${RUSTUP_TARGET}/rustup-init"
echo "${RUSTUP_INIT_SHA256}  ${RUSTUP_INIT}" | sha256sum -c -
chmod +x "$RUSTUP_INIT"

# The pinned toolchain (rust-toolchain.toml, workspace rust-version) is the
# DEFAULT — this used to fall back to `stable`, which drifts away from the pin.
PINNED_RUST="1.94.1"
"$RUSTUP_INIT" -y --default-toolchain "$PINNED_RUST"

# Add to PATH
source "$HOME/.cargo/env"
rustup default "$PINNED_RUST"

# Install additional components
rustup component add clippy rustfmt

# Verify installation
echo ""
echo "Verifying installation..."
rustc --version
cargo --version
clippy-driver --version

echo ""
echo "✅ Rust installation complete"
