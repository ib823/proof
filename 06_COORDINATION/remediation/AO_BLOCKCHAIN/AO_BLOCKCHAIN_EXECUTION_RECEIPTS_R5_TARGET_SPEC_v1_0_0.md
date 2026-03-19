# AO_EXECUTION_RECEIPTS R5 Target Spec v1.0.0

## Purpose

Take `AO_EXECUTION_RECEIPTS` from a narrow live subsystem to an honest `R5` child domain.

This is the first blockchain child domain because it already has the strongest evidence-to-scope ratio in the repo.

## Current Truth

Live source today:
- [ExecutionReceipts.v](/workspaces/proof/02_FORMAL/coq/domains/ExecutionReceipts.v)
- [lib.rs](/workspaces/proof/03_PROTO/crates/riina-receipt/src/lib.rs)

Current strengths:
- receipt append and verify exist
- tamper tests exist for `prev_receipt`, `effect_type`, `program_hash`, and `receipt_id`
- there is already a dedicated Coq file and a dedicated Rust crate

Current weaknesses:
- receipt chain is not yet wired through the broader RIINA runtime as a first-class execution artifact
- hashing is `u64` FNV-1a, which is not serious blockchain-grade cryptographic integrity
- timestamp is fixed to `0`
- there is no explicit schema version, serialization contract, or external replay procedure
- examples are not yet elevated into audited end-to-end receipt workflows

## Scope

### In scope

- append-only execution receipts
- deterministic receipt identifiers
- verification of intact chains
- rejection of tampered chains
- runtime emission from effectful operations
- stable external representation
- auditable replay of receipt verification

### Out of scope for the first `R5`

- distributed consensus
- smart-contract semantics
- token economics
- distributed attestation / TPM / TDX
- cross-machine receipt federation

## Required Workflows

| Workflow | Valid or forbidden | Must exist by `R5` |
|----------|--------------------|--------------------|
| Append receipt after effect | Valid | Yes |
| Verify intact chain | Valid | Yes |
| Reject modified `prev_receipt` | Forbidden | Yes |
| Reject modified effect payload | Forbidden | Yes |
| Reject modified program hash | Forbidden | Yes |
| Reject modified receipt id | Forbidden | Yes |
| Serialize then verify same chain | Valid | Yes |
| Replay verification from saved artifact | Valid | Yes |

## Required Properties

1. Append preserves validity.
2. Verification is sound for the stated receipt model.
3. Tampering any covered field invalidates the chain.
4. Receipt order is observable and deterministic.
5. Receipt schema is versioned and replayable.
6. Runtime-reported receipts correspond to actual executed effects in the covered scope.

## Required Formal Artifacts

Minimum Coq targets:
- inductive receipt payload model, not just booleans
- append-validity theorem
- tamper-invalidity theorems for each covered field
- serialization/replay preservation theorem if serialization is part of scope
- soundness statement linking runtime receipt model to the formal receipt structure

Minimum standard:
- hostile review must not be able to classify the file as mere boolean unpacking

## Required Implementation Artifacts

1. Replace or clearly bound the current hash model.
   - Preferred: upgrade from `u64` FNV-1a to a stronger RIINA-available hash primitive
   - If not upgraded, public claim must never imply cryptographic-grade resistance
2. Replace fixed timestamp placeholder with real scoped semantics or remove timestamp from claimed scope.
3. Expose receipt generation from the interpreter/runtime, not just the standalone crate.
4. Add stable serialization format and replay command.
5. Add `.rii` or runtime-driven examples that produce and verify receipts.

## Required Tests

Positive:
- append single receipt
- append multiple receipts
- verify intact chain
- serialize and replay intact chain

Negative:
- reject tampered `prev_receipt`
- reject tampered `effect_type`
- reject tampered `program_hash`
- reject tampered `receipt_id`
- reject truncated or reordered chains if supported

Adversarial:
- mutation-style tamper sweep across all covered fields
- regression tests for any previously accepted invalid chain

## Required Observability

`AO_EXECUTION_RECEIPTS` cannot be `R5` unless a third party can:
- generate receipts from a real run
- save them
- replay verification
- inspect exactly what assumptions the model makes

## Exit Criteria

`AO_EXECUTION_RECEIPTS` is ready for re-audit when:
- scope is explicit
- the Coq model is nontrivial
- runtime integration is real
- valid and invalid workflows execute by command
- replay is reproducible
- public wording is exact
- regression checks exist

## Unsafe Shortcut List

Do not count the domain as `R5` if:
- receipts only exist in a library not connected to runtime execution
- hash integrity is overstated beyond the actual hash primitive
- examples are static or conceptual
- tamper tests exist but replay is not possible
- wording says "blockchain-grade" without cryptographic-grade evidence
