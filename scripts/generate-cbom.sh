#!/usr/bin/env bash
# generate-cbom.sh — Cryptographic Bill of Materials for RIINA (REQ-48).
#
# A CBOM answers "which cryptographic algorithm is used where, and what is its
# deprecation status" — the inventory a PQC migration is planned against
# (NIST IR 8547: classical asymmetric deprecated 2030, removed 2035). It is the
# static counterpart of the compile-time deprecation gate: the gate REJECTS a
# deprecated selection (Coq crypto/AlgorithmPolicy.v `accepts`), the CBOM
# REPORTS the current inventory so a policy tightening can be planned.
#
# Deterministic (sorted, no timestamps) so the committed artifact and `--check`
# are meaningful. Written in bash + grep only — no third-party tooling.
#
# Usage:
#   bash scripts/generate-cbom.sh            # write sbom/riina.cbom.cdx.json
#   bash scripts/generate-cbom.sh --check    # fail if the committed file is stale

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHECK=0
[ "${1:-}" = "--check" ] && CHECK=1

CORE="$ROOT/05_TOOLING/crates/riina-core/src/crypto"
OUT="sbom/riina.cbom.cdx.json"

# The deprecation policy — MUST mirror `crypto_policy::DEPRECATED` in
# 03_PROTO/crates/riina-typechecker/src/lib.rs. Kept as a sorted list so a
# reviewer can diff the two by eye.
is_deprecated() {
    case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
        md5|sha1|sha-1|des|3des|triple-des|rc4|md4|rsa1024|rsa-1024|dsa1024) return 0 ;;
        *) return 1 ;;
    esac
}

# Discover the crypto primitives RIINA actually ships, from the source tree —
# one component per crypto/*.rs module. The algorithm name is the file stem.
gen() {
    printf '{\n'
    printf '  "bomFormat": "CycloneDX",\n'
    printf '  "specVersion": "1.5",\n'
    printf '  "version": 1,\n'
    printf '  "metadata": {\n'
    printf '    "component": { "type": "application", "name": "riina-crypto" },\n'
    printf '    "properties": [\n'
    printf '      { "name": "riina:cbom:policy", "value": "NIST IR 8547; mirrors crypto_policy::DEPRECATED" },\n'
    printf '      { "name": "riina:cbom:gate", "value": "02_FORMAL/coq/crypto/AlgorithmPolicy.v (accepts)" }\n'
    printf '    ]\n'
    printf '  },\n'
    printf '  "components": [\n'

    local first=1
    while IFS= read -r file; do
        local stem status
        stem="$(basename "$file" .rs)"
        [ "$stem" = "mod" ] && continue
        if is_deprecated "$stem"; then status="deprecated"; else status="current"; fi
        [ $first -eq 1 ] || printf ',\n'
        first=0
        printf '    {\n'
        printf '      "type": "cryptographic-asset",\n'
        printf '      "name": "%s",\n' "$stem"
        printf '      "bom-ref": "crypto/%s",\n' "$stem"
        printf '      "properties": [\n'
        printf '        { "name": "riina:crypto:source", "value": "05_TOOLING/crates/riina-core/src/crypto/%s.rs" },\n' "$stem"
        printf '        { "name": "riina:crypto:status", "value": "%s" }\n' "$status"
        printf '      ]\n'
        printf '    }'
    done < <(find "$CORE" -maxdepth 1 -name '*.rs' | sort)

    printf '\n  ]\n'
    printf '}\n'
}

tmp="$(mktemp)"
gen > "$tmp"
if [ "$CHECK" -eq 1 ]; then
    if ! diff -q "$tmp" "$ROOT/$OUT" >/dev/null 2>&1; then
        echo "[STALE] $OUT differs from a fresh generation — run: bash scripts/generate-cbom.sh"
        rm -f "$tmp"
        exit 1
    fi
    echo "[OK] $OUT up to date"
else
    mkdir -p "$(dirname "$ROOT/$OUT")"
    mv "$tmp" "$ROOT/$OUT"
    echo "[WROTE] $OUT"
fi
rm -f "$tmp" 2>/dev/null || true
