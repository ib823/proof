# Software Bill of Materials (SBOM)

CycloneDX 1.5 SBOMs for RIINA, generated **deterministically** from
`cargo metadata` by [`scripts/generate-sbom.sh`](../scripts/generate-sbom.sh)
(no timestamp/serial, components sorted by purl — so the committed files are
reproducible and drift-checkable).

There are two, because *what ships* and *what builds it* are different supply
chains and merging them would overstate the shipped attack surface:

| SBOM | Covers | Components | External deps |
|---|---|---|---|
| [`riina-proto.cdx.json`](riina-proto.cdx.json) | The **shipped compiler/runtime** (`03_PROTO`) | 19 | **0** |
| [`riina-tooling.cdx.json`](riina-tooling.cdx.json) | The **build/test toolchain** (`05_TOOLING`) — never shipped to users | 129 | 121 |

The headline is real and machine-checkable: **the shipped compiler has zero
external dependencies.** Every one of its 19 components is a first-party RIINA
workspace crate (`riina:origin = workspace`); the crypto, stdlib, and codegen are
all built from source (Law 8). The build/test tooling does use external crates —
that is expected and lives outside the trusted runtime surface.

## Regenerate / verify

```bash
bash scripts/generate-sbom.sh            # (re)generate both SBOMs
bash scripts/generate-sbom.sh --check    # fail if either committed SBOM is stale
```

Run `--check` after any dependency change; it diffs a fresh generation against
the committed files so the SBOMs cannot silently drift.

## Where REQ-31 stands (reproducible build attestation)

This SBOM is one piece of REQ-31 (Nix flake + SBOM + signed releases). Honest
status of the rest:

- **Reproducible build (Nix):** [`flake.nix`](../flake.nix) builds `riinac` via
  `rustPlatform.buildRustPackage` pinned to `03_PROTO/Cargo.lock`. With zero
  external runtime deps the build closure is minimal. *Verifying* a bit-for-bit
  reproducible `nix build` requires a Nix-capable environment/CI (not available
  in every dev container) — structurally validated here; CI verification is the
  open item.
- **Container:** a [`Dockerfile`](../Dockerfile) builds from source.
- **Release process:** `scripts/release.sh` / `scripts/build-release.sh` cut
  tagged releases.
- **Signing — NOT yet done (needs external trust material).** Release artifact
  signing (e.g. cosign/sigstore or minisign) requires a maintainer-held signing
  key and a CI secret, which cannot be created in-repo. The process is specified
  but the keys/secrets are an external, owner-provided step. Tracked under
  REQ-31 in `RIINA_MASTER_PLAN.md`.
