# RIINA_CAPITAL_MARKETS Remediation Plan v1.0.0

## Purpose

Turn `RIINA_CAPITAL_MARKETS` from a broad research thesis plus bounded formalization into a domain that can eventually support honest capital-markets claims.

## Current Truth

As of [RIINA_CAPITAL_MARKETS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_CAPITAL_MARKETS_R5_AUDIT.md) and [RIINA_CAPITAL_MARKETS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_CAPITAL_MARKETS_R5_REVIEW.md):
- `RIINA_CAPITAL_MARKETS` is `R2`
- one bounded Coq order-book/trade/settlement model exists
- secondary lanes are generated or vacuous and must not be counted as meaningful independent evidence
- the live compiler/runtime has no capital-markets subsystem
- no canonical trading or settlement examples execute through `riinac`
- research wording overclaims a world-replacing trading platform

## Governing Rule

The domain may not be claimed above the weakest live link. Today that weakest link is the complete absence of a live trading subsystem despite very broad research claims.

## Non-Negotiable Remediation Principles

1. A bounded Coq market model is not a trading platform.
2. Generated or placeholder prover lanes do not count as serious market-model depth.
3. Exchange-platform-obsolescence rhetoric must stop unless the live system exists.
4. The first promotion path must be one narrow executable trading slice, not a global platform claim.

## Required Strategic Shift

### 1. Freeze the claim surface

Required outcome:
- all wording drops to the reviewer-safe `R2` claim
- no exchange-replacement language remains in current-state docs

### 2. Choose the first live capital-markets slice

Required outcome:
- pick one bounded slice such as:
  - order-book matching
  - or trade settlement finality
- state exactly what is in scope and what is out of scope

### 3. Materialize the bounded slice in the toolchain

Required outcome:
- orders/trades/settlements appear in the AST and typechecker
- runtime/codegen support the same slice
- invalid cases are rejected or trapped by the real toolchain

### 4. Rebuild the formal model around the same slice

Required outcome:
- Coq proofs focus on the exact live slice
- theorems deepen from bounded examples to workflow-complete invariants
- secondary lanes are either replaced with real models or explicitly removed from assurance claims

### 5. Add executable workflows

Required outcome:
- at least one valid order/trade/settlement workflow executes through `riinac`
- at least one invalid workflow is rejected

## Execution Order

1. Reduce wording to the bounded formal-model claim.
2. Choose the first live trading slice.
3. Implement it in the toolchain.
4. Rework Coq around the same slice.
5. Add valid and invalid example workflows.
6. Re-audit `RIINA_CAPITAL_MARKETS`.

## Exit Criteria

`RIINA_CAPITAL_MARKETS` may not move above `R2` until:
- a bounded live trading subsystem exists
- canonical workflows execute through the toolchain
- generated/vacuous lanes stop being counted as serious evidence
- research wording matches the bounded live state
