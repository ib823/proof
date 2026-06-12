#!/usr/bin/env bash
# Codespace post-create bootstrap for the RIINA proof workspace.
#
# Runs once on container creation (wired from .devcontainer/devcontainer.json).
# Idempotent — re-running is safe; installers self-check for existing state.
#
# Stages:
#   1. Install Rust toolchain (~5 min download on cold container)
#   2. Build riinac + install RIINA git hooks (~1-15 min depending on cargo cache)
#   3. Import GPG signing key from $GPG_PRIVATE_KEY secret, if set
#      (Set it under https://github.com/settings/codespaces → New secret.
#       Pair with $GPG_SIGNING_KEY = the 16-char key ID to auto-configure git.)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

echo "==> [1/3] Installing Rust toolchain..."
bash 00_SETUP/scripts/install_rust.sh

export PATH="$HOME/.cargo/bin:$PATH"

echo "==> [2/3] Building riinac and installing RIINA git hooks..."
bash 00_SETUP/scripts/install_hooks.sh

if [ -n "${GPG_PRIVATE_KEY:-}" ]; then
    echo "==> [3/3] Importing GPG signing key from \$GPG_PRIVATE_KEY..."
    printf '%s\n' "$GPG_PRIVATE_KEY" | gpg --batch --import
    if [ -n "${GPG_SIGNING_KEY:-}" ]; then
        git config user.signingkey "$GPG_SIGNING_KEY"
        git config commit.gpgsign true
        echo "    git configured to sign with $GPG_SIGNING_KEY"
    else
        echo "    \$GPG_SIGNING_KEY not set — run 'git config user.signingkey <ID>' manually"
    fi
else
    echo "==> [3/3] No \$GPG_PRIVATE_KEY secret set — skipping signing-key import"
    echo "    (Signing is required by the pre-push hook. Either set the secret"
    echo "     or generate a key here with 'gpg --quick-generate-key' before pushing.)"
fi

echo "==> Bootstrap complete."
