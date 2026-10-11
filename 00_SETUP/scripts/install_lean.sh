#!/bin/bash
# TERAS Lean 4 Installation Script

set -euo pipefail

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              TERAS Lean 4 Installation Script                ║"
echo "╚══════════════════════════════════════════════════════════════╝"

# Check if already installed
if command -v lean &> /dev/null; then
    VERSION=$(lean --version)
    echo "Lean already installed: $VERSION"
    exit 0
fi

echo "Installing Lean 4 via elan..."

# Install elan (Lean version manager) from a pinned release tag, verified
# against a recorded checksum (was: `master`, piped straight into sh).
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ELAN_TAG="v4.2.4"
ELAN_INIT_SHA256="a620ff1641616222c8d37c54845492004bb84d6877cdbc944dd65c1aa685bf53"
ELAN_INIT="$(mktemp)"
trap 'rm -f "$ELAN_INIT"' EXIT
curl --proto '=https' --tlsv1.2 -sSfL -o "$ELAN_INIT" \
    "https://raw.githubusercontent.com/leanprover/elan/${ELAN_TAG}/elan-init.sh"
echo "${ELAN_INIT_SHA256}  ${ELAN_INIT}" | sha256sum -c -
sh "$ELAN_INIT" -y --default-toolchain none

# Add to PATH
export PATH="$HOME/.elan/bin:$PATH"
echo 'export PATH="$HOME/.elan/bin:$PATH"' >> ~/.bashrc

# The repository pins its Lean toolchain (02_FORMAL/lean/lean-toolchain,
# leanprover/lean4:v4.16.0); `stable` would install a different compiler.
LEAN_TOOLCHAIN="$(cat "$REPO_ROOT/02_FORMAL/lean/lean-toolchain")"
elan default "$LEAN_TOOLCHAIN"

# Verify installation
echo ""
echo "Verifying installation..."
lean --version

echo ""
echo "✅ Lean 4 installation complete"
