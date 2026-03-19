# RIINA_BANK Remediation Plan v1.0.0

## Purpose

Turn `RIINA_BANK` from a broad research thesis plus preliminary formalization into a domain that can eventually support honest bounded core-banking claims.

## Current Truth

As of [RIINA_BANK_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_BANK_R5_AUDIT.md) and [RIINA_BANK_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_BANK_R5_REVIEW.md):
- `RIINA_BANK` is `R2`
- a real Coq `CoreBanking.v` file exists with 30 theorems
- a few theorems are structurally meaningful, but most are shallow unfold-and-apply proofs
- secondary non-Coq lanes are generated or vacuous and must not be counted as serious independent evidence
- the live compiler/runtime contains no dedicated banking subsystem
- no canonical banking workflows execute through `riinac`
- research wording is massively stronger than the repo reality

## Governing Rule

The domain may not be claimed above the weakest live link. Today that weakest link is the complete absence of a live banking subsystem despite extremely broad public/research claims.

## Non-Negotiable Remediation Principles

1. A banking proof file is not a banking product.
2. Generated or placeholder prover lanes do not count as banking depth.
3. No absolute or market-obsolescence wording survives unless the live system exists.
4. Core-banking claims must be narrowed to one bounded executable slice before they can grow again.

## Required Strategic Shift

### 1. Freeze the claim surface

Required outcome:
- all public and research wording drops to the reviewer-safe `R2` claim
- no live-system language is used until a live bounded subsystem exists

### 2. Choose the first bounded banking slice

Required outcome:
- pick one narrow live slice, for example:
  - double-entry ledger + account balances
  - or payment idempotency + settlement status
- document exactly what is in scope and out of scope

### 3. Materialize the bounded slice in the compiler/runtime

Required outcome:
- banking data structures appear in `riina-types`
- parser/typechecker/runtime/codegen support the same slice
- invalid cases are rejected or trapped by the real toolchain

### 4. Rebuild the formal model around that slice

Required outcome:
- Coq proofs focus on the exact live slice
- theorem quality shifts from broad shallow coverage to bounded structural depth
- generated/vacuous lanes are either removed from claims or replaced with honest, real models

### 5. Add executable workflows

Required outcome:
- at least one valid banking workflow runs through `riinac`
- at least one invalid banking workflow is rejected
- examples become audit-grade evidence rather than concept prose

## Execution Order

1. Reduce wording to the bounded formal-model claim.
2. Choose the first live banking slice.
3. Implement that slice in the toolchain.
4. Rework Coq around the same slice.
5. Add valid and invalid banking examples.
6. Re-audit `RIINA_BANK`.

## Exit Criteria

`RIINA_BANK` may not move above `R2` until:
- a bounded live banking subsystem exists
- canonical banking workflows execute through the toolchain
- generated/vacuous lanes stop being counted as serious evidence
- the research/marketing wording matches the bounded live state
