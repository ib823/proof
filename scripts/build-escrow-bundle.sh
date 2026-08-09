#!/bin/bash
# build-escrow-bundle.sh — REQ-56 step 1 (owner adopted the recommended
# sequencing 2026-08-09: escrow first).
#
# Produces the deposit a software-escrow agent lodges: the COMPLETE means to
# continue RIINA if the owner cannot — full git history, the toolchain pins,
# the verified provision-to-push runbook, and the claims snapshot — with a
# checksum manifest so the deposit itself is verifiable at release time.
#
# The bundle is an ARTIFACT, never committed (out-of-tree output dir).
# Signing the escrow CONTRACT (agent, trigger events, beneficiaries) is the
# owner's act; the README template inside the bundle lists what to fill in.
#
# Usage:
#   bash scripts/build-escrow-bundle.sh [OUTDIR]        # build (default ../riina-escrow-bundle)
#   bash scripts/build-escrow-bundle.sh --check OUTDIR  # verify an existing deposit

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

check_mode=0
if [ "${1:-}" = "--check" ]; then
    check_mode=1
    shift
fi
OUT="${1:-$ROOT_DIR/../riina-escrow-bundle}"

if [ "$check_mode" -eq 1 ]; then
    echo "=== Escrow deposit check: $OUT ==="
    [ -d "$OUT" ] || { echo "FAIL: $OUT does not exist"; exit 1; }
    (cd "$OUT" && sha256sum -c MANIFEST.sha256) || { echo "FAIL: checksum mismatch"; exit 1; }
    git bundle verify "$OUT/riina.bundle" >/dev/null || { echo "FAIL: git bundle invalid"; exit 1; }
    echo "OK: deposit verifies (checksums + bundle integrity)"
    exit 0
fi

echo "=== Building escrow deposit: $OUT ==="
mkdir -p "$OUT"

# 1. Full history, every branch and tag — restorable with plain git.
git -C "$ROOT_DIR" bundle create "$OUT/riina.bundle" --all
git bundle verify "$OUT/riina.bundle" >/dev/null

# 2. Toolchain pins — everything §2 of the runbook installs, pinned.
{
    echo "# RIINA toolchain pins (escrow snapshot $(git -C "$ROOT_DIR" rev-parse --short HEAD), $(date -u +%Y-%m-%dT%H:%M:%SZ))"
    echo ""
    echo "## rust-toolchain.toml (05_TOOLING; 03_PROTO inherits the same pin via CI)"
    cat "$ROOT_DIR/05_TOOLING/rust-toolchain.toml"
    echo ""
    echo "## Rocq (from scripts/provision-coq.sh — the script IS the pin)"
    grep -E "^(ROCQ|OCAML|PIN|readonly).*=" "$ROOT_DIR/scripts/provision-coq.sh" | head -10
    echo ""
    echo "## Lean"
    cat "$ROOT_DIR/02_FORMAL/lean/lean-toolchain" 2>/dev/null || echo "(no lean-toolchain file)"
    echo ""
    echo "## wasmtime (C/WASM differential)"
    echo "v27.0.0 — https://github.com/bytecodealliance/wasmtime/releases/download/v27.0.0/"
} > "$OUT/TOOLCHAIN_PINS.txt"

# 3. The provision-to-push runbook (the restore procedure IS onboarding).
cp "$ROOT_DIR/00_SETUP/MAINTAINER_ONBOARDING.md" "$OUT/"

# 4. Claims snapshot at deposit time.
cp "$ROOT_DIR/website/public/metrics.json" "$OUT/metrics.json"

# 5. Release-conditions template the owner completes with the agent.
cat > "$OUT/README_ESCROW.md" <<'EOF'
# RIINA Escrow Deposit — Release & Restore

## What this is
The complete means to continue the RIINA project: full git history
(riina.bundle), pinned toolchain (TOOLCHAIN_PINS.txt), the verified
provision-to-push runbook (MAINTAINER_ONBOARDING.md), and the published-claims
snapshot at deposit time (metrics.json). Integrity: MANIFEST.sha256.

## Release conditions (OWNER: complete with the escrow agent)
- Beneficiaries: ____________________________________________
- Trigger events (e.g. death/incapacity of the owner; N months of
  unresponsiveness to registered notice; owner's written instruction):
  ____________________________________________
- Verification agent must perform at release: `sha256sum -c MANIFEST.sha256`
  and `git bundle verify riina.bundle`.

## Restore procedure (for the beneficiary)
1. `git clone riina.bundle riina-proof && cd riina-proof && git checkout main`
2. Follow MAINTAINER_ONBOARDING.md from §2 (provisioning) through §5
   (demonstration task). The runbook was written from a verified fresh-machine
   session; every command in it was executed before it was documented.
3. The planning authority is RIINA_MASTER_PLAN.md in the repository;
   operational rules are CLAUDE.md. Trust nothing this deposit says about
   project state — re-derive it by the commands in the runbook (that
   discipline is itself the project's prime directive).

## Refresh cadence
Re-run scripts/build-escrow-bundle.sh and re-lodge on every release tag, or
quarterly, whichever is sooner. A stale deposit restores an old project;
`git bundle` is cheap — do not let the deposit rot.
EOF

# 6. Checksum manifest over everything above.
(cd "$OUT" && sha256sum riina.bundle TOOLCHAIN_PINS.txt MAINTAINER_ONBOARDING.md metrics.json README_ESCROW.md > MANIFEST.sha256)

echo ""
echo "Deposit built:"
ls -la "$OUT"
echo ""
echo "Verify anytime:  bash scripts/build-escrow-bundle.sh --check $OUT"
echo "Owner next step: lodge the directory with a software-escrow agent and"
echo "complete the release-conditions section of README_ESCROW.md."
