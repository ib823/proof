#!/usr/bin/env bash
# Install the pinned wasmtime used by the C/WASM backend differentials, and
# VERIFY it: the release tarball is checked against a recorded SHA-256 before
# anything from it is executed (the CI step previously ran whatever the URL
# served). The differential verdict is version-independent (recorded identical
# under wasmtime 27.0.0 and 45.0.0); the version is pinned for reproducibility.
#
# Usage: bash scripts/ci-install-wasmtime.sh [install-dir]   (default ~/.wasmtime/bin)
set -euo pipefail

VERSION="27.0.0"
SHA256="74678f6ec49d8b858ca5181d5492b967245f6c072b5763ea14a75eee1ad3c2d7"
URL="https://github.com/bytecodealliance/wasmtime/releases/download/v${VERSION}/wasmtime-v${VERSION}-x86_64-linux.tar.xz"
DEST="${1:-$HOME/.wasmtime/bin}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

curl -sSfL -o "$WORK/wasmtime.tar.xz" "$URL"
echo "${SHA256}  $WORK/wasmtime.tar.xz" | sha256sum -c -
tar xf "$WORK/wasmtime.tar.xz" -C "$WORK"
mkdir -p "$DEST"
cp "$WORK/wasmtime-v${VERSION}-x86_64-linux/wasmtime" "$DEST/"
"$DEST/wasmtime" --version

# On GitHub Actions, put it on PATH for later steps.
if [ -n "${GITHUB_PATH:-}" ]; then
    echo "$DEST" >> "$GITHUB_PATH"
fi
