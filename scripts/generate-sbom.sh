#!/usr/bin/env bash
# generate-sbom.sh — Software Bill of Materials (CycloneDX 1.5) for RIINA.
#
# Emits two SBOMs, because "what ships" and "what builds it" are different
# supply chains and conflating them would be dishonest:
#   sbom/riina-proto.cdx.json    — the shipped compiler/runtime (03_PROTO).
#                                  Headline: ZERO external dependencies.
#   sbom/riina-tooling.cdx.json  — the build/test toolchain (05_TOOLING). Has
#                                  external dev/build deps; never shipped to users.
#
# Generated deterministically from `cargo metadata` (sorted components, no
# volatile timestamp/serial), so the committed SBOMs are reproducible and a
# drift check is meaningful.
#
# Usage:
#   bash scripts/generate-sbom.sh           # (re)generate both SBOMs
#   bash scripts/generate-sbom.sh --check   # fail if the committed SBOMs are stale
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

gen() {
    local manifest="$1" appname="$2"
    cargo metadata --format-version 1 --manifest-path "$manifest" --locked 2>/dev/null \
        | APPNAME="$appname" python3 "$ROOT/scripts/_sbom_from_metadata.py"
}

emit() {
    local manifest="$1" appname="$2" outfile="$3"
    local tmp
    tmp="$(mktemp)"
    gen "$manifest" "$appname" > "$tmp"
    if [ "$CHECK" -eq 1 ]; then
        if ! diff -q "$tmp" "$ROOT/$outfile" >/dev/null 2>&1; then
            echo "[STALE] $outfile differs from a fresh generation — run: bash scripts/generate-sbom.sh"
            rm -f "$tmp"
            return 1
        fi
        echo "[OK] $outfile up to date"
    else
        mkdir -p "$(dirname "$ROOT/$outfile")"
        mv "$tmp" "$ROOT/$outfile"
        echo "[WROTE] $outfile"
    fi
    rm -f "$tmp" 2>/dev/null || true
}

rc=0
emit "$ROOT/03_PROTO/Cargo.toml"   "riinac"        "sbom/riina-proto.cdx.json"   || rc=1
emit "$ROOT/05_TOOLING/Cargo.toml" "riina-tooling" "sbom/riina-tooling.cdx.json" || rc=1
exit $rc
