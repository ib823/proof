# AJ_VERIFIED_COMPLIANCE Remediation Plan v1.0.0

## Purpose

Turn `AJ_VERIFIED_COMPLIANCE` from a research-backed compliance-lint and reporting umbrella into a domain that can eventually support honest bounded compile-time regulatory-compliance claims.

## Current Truth

As of [AJ_VERIFIED_COMPLIANCE_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AJ_VERIFIED_COMPLIANCE_R5_AUDIT.md) and [AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md):
- `AJ_VERIFIED_COMPLIANCE` is `R1`
- the live implementation centers on `riina-compliance`, an opt-in post-typecheck AST rule engine and report generator
- no first-class `Compliance`, `Pematuhan`, or `Audit` effect exists in the core frontend
- canonical compliance examples are not yet reliable executable evidence through the live parser/typechecker
- Coq is mechanized but shallow
- derived non-Coq lanes are not safe to count as serious independent evidence

## Governing Rule

The domain may not be claimed above what the weakest live link supports. Today that weakest link is the absence of core frontend compliance semantics and the absence of workflow-complete executable evidence.

## Non-Negotiable Remediation Principles

1. Post-typecheck AST linting is not the same thing as compile-time compliance guarantees.
2. Compliance reports are not the same thing as verified regulator-grade evidence chains.
3. Generated or vacuous prover lanes do not raise this domain's assurance level.
4. Canonical examples do not count as evidence unless they parse, typecheck, and run through the live toolchain.
5. Public/business wording must shrink to the live enforced subset until remediation lands.

## Required Structural Changes

### 1. Add a bounded core compliance regime

Required outcome:
- a first-class compliance effect/type surface for a narrow, explicitly bounded subset
- parser and typechecker awareness of that subset
- explicit rejection of invalid covered cases without relying on `--compliance` as a separate lint pass

### 2. Re-scope the live rule engine

Required outcome:
- `riina-compliance` becomes a bounded extension of real frontend guarantees, not the entire guarantee itself
- clear separation between heuristic advisory rules and truly enforced rules
- public report output marks heuristic vs enforced checks honestly

### 3. Rebuild the formal model around live workflows

Required outcome:
- move beyond constructor lifting and reflexivity
- introduce state, transition, and trace theorems tied to the bounded live subset
- stop counting duplicate or vacuous lanes as domain depth

### 4. Make canonical examples executable

Required outcome:
- at least one valid compliance workflow parses, typechecks, and runs
- at least one invalid workflow is rejected by the actual toolchain
- examples used as public evidence are kept in sync with the live frontend

### 5. Repair public wording

Required outcome:
- website and business docs reduced to the reviewer-safe `R1` claim until bounded core semantics exist

## Execution Order

1. Introduce a bounded frontend compliance effect/type regime.
2. Make one canonical profile subset executable end-to-end.
3. Rework Coq around that same subset.
4. Reclassify or remove vacuous derived evidence.
5. Re-audit the domain.

## Exit Criteria

`AJ_VERIFIED_COMPLIANCE` may not move above `R1` until:
- a bounded compliance subset exists in the live frontend
- canonical valid and invalid workflows execute through the actual toolchain
- public wording stops calling lint-stage findings “type errors”
- vacuous secondary lanes stop being counted as serious evidence
