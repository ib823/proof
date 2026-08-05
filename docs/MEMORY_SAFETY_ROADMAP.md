# RIINA Memory-Safety Roadmap

*Published 2026-08-05 (REQ-49). Aligns with CISA/NSA/FBI + AU/CA/NZ/UK "The Case for
Memory Safe Roadmaps" (Secure by Design), which asked software manufacturers to publish a
memory-safety roadmap by 1 January 2026.*

## TL;DR

RIINA is **memory-safe by construction** and has been since its first release: the compiler
and runtime are written in safe Rust with zero third-party runtime dependencies (Law 8,
proven by SBOM), and the language RIINA compiles has no unsafe pointer surface. There is no
migration to plan — there is no memory-unsafe code to migrate away from. This document
exists to state that publicly, and — more usefully — to be honest that **memory safety is
necessary but not sufficient**, and to say what RIINA does *above* it.

## The honest boundary: memory safety is table stakes, not the product

Most of the vulnerability classes that matter to a security-critical program are **not**
memory-safety bugs. A perfectly memory-safe program can still:

- leak a secret to a public sink (an information-flow bug);
- perform an I/O effect it was never authorised for (a capability/effect bug);
- branch on a secret in a way that leaks it through timing (a side-channel bug);
- accept unsanitised input into an injection sink (a taint bug);
- verify the wrong value because a content hash collided (an integrity bug).

CISA's roadmap is about eliminating the *first* rung — the memory-corruption classes (buffer
overflow, use-after-free, type confusion) that dominate CVEs in C/C++. RIINA clears that rung
by construction. Its actual differentiator is the **enforced layer above it**: information-flow
control, an effect system, capability types, constant-time blocks, linear/affine types, taint
tracking — each checked by the compiler, each with a mechanized Coq counterpart in the core
calculus. That is the claim RIINA stands on. Memory safety is the floor, not the ceiling.

## Current status (verify, do not trust — re-derive from commands)

| Property | Mechanism | Status |
|---|---|---|
| Compiler/runtime memory safety | Safe Rust; `unsafe` only with documented justification | Enforced (`cargo clippy` gates; grep for `unsafe`) |
| Zero third-party runtime deps | Law 8 | Proven (`sbom/*.cdx.json`) |
| Compiled-language memory safety | RIINA has no raw-pointer surface in source; codegen is verified against a differential | Enforced (C/WASM byte-equal differential) |
| Memory-safety *of the type theory* | Progress + Preservation for the core calculus | Mechanized in Coq (`type_system/{Progress,Preservation}.v`) |
| Spatial safety of the compiled artifact | modelled in the `W001_VerifiedMemory` domain | Coq (domain lane) |

## Roadmap

RIINA has no memory-unsafe code to remove, so its "roadmap" is maintenance and depth, not
migration:

1. **Hold the line.** `unsafe` in RIINA's own Rust stays justified-or-absent, CI-gated. Any
   future `unsafe` block ships with a documented safety argument (existing policy, Forbidden #3).
2. **Deepen the layer that actually matters.** Finish compiler-enforcement parity (REQ-27) so
   every Coq-modelled security property is enforced by the shipped compiler, not just proved.
3. **Hardware memory-safety contracts (Phase 9).** Track CHERI/Morello and ARM MTE/MIE as
   *optional targets*, not dependencies — RIINA's safety does not rest on them, but it can
   emit for them where a deployment demands hardware-enforced spatial safety. (Research: the
   `S001_HardwareContracts`, `39_DOMAIN_PHI_VERIFIED_HARDWARE` domains; 2026-H1 refresh Batch 3.)
4. **Be a destination for others' roadmaps.** The manufacturers now obliged to publish CISA
   roadmaps are RIINA's buyers. RIINA is a place a memory-unsafe codebase can migrate *to* —
   with the honest caveat above: it gives them memory safety **and** the IFC/effect/CT layer,
   not memory safety alone.

## What this document is not

This is a positioning and status document, not a conformance claim. "Memory-safe by
construction" is a statement about the absence of a raw-pointer surface and the use of safe
Rust, cross-checked by the differential and the mechanized Progress/Preservation proofs — it
is not an assertion that RIINA is free of all bugs, nor that the CISA roadmap's organisational
expectations (inventory, prioritisation, timelines for *legacy* products) apply to a codebase
that was memory-safe from commit one. Re-derive every status above from the cited commands
before repeating it.
