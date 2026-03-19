# AO_BLOCKCHAIN R1 To R5 Worklist v1.0.0

This worklist is gate-driven. `AO_BLOCKCHAIN` does not move upward because work was done. It moves upward only when gates are re-audited as passing.

## Current Baseline

- Conservative umbrella rating: `R1`
- Conservative blocker gates:
  - `G2`
  - `G3`
  - `G6`
  - `G7`
  - `G8`
  - `G9`
  - `G10`
  - `G13`
  - `G14`

## Gate-By-Gate Remediation

| Gate | Current State | Required Change | Required Artifact | Done When |
|------|---------------|-----------------|-------------------|-----------|
| `G1` Canonical Identity | Partial | define child domains and one canonical authority file per child domain | child-domain spec set | every claimed child domain has one canonical spec and one canonical formal file |
| `G2` Boundary Precision | Fail/Partial | write explicit in-scope and out-of-scope statements per child domain | scope statements in each child-domain spec | no child domain relies on umbrella wording to hide exclusions |
| `G3` Workflow Inventory | Fail/Partial | enumerate valid and forbidden workflows per child domain | workflow matrix per child domain | each claimed workflow maps to formal, implementation, and tests |
| `G4` Threat and Failure Model | Partial | encode abuse, sequencing, and invalid-state models formally and in tests | threat model section plus invalid-state theorems and attack tests | conceptual threats become executable/formal states |
| `G5` Property Set | Partial | complete core property list per child domain | property matrix per child domain | every core claim has a corresponding property and enforcement path |
| `G6` Formal Model Depth | Fail/Partial | replace boolean-config proofs with state and trace theorems | new Coq child-domain files with nontrivial proofs | hostile review cannot classify proofs as definitional theater |
| `G7` Toolchain Enforcement | Fail | implement real semantics and invalid-case rejection | parser/typechecker/runtime/codegen changes plus tests | wrapper-only or lexer-only support is gone for claimed features |
| `G8` Executable Evidence | Fail | add real end-to-end workflows | audited commands and runtime-driven examples | at least one positive and one negative workflow per child domain execute |
| `G9` Adversarial Coverage | Fail | add domain-specific attack cases | adversarial test suite | tamper, reentrancy, inflation, ordering, and boundary attacks are exercised where relevant |
| `G10` Evidence Honesty Across Prover Lanes | Fail | demote weak lanes or replace them with meaningful encodings | lane-classification note plus improved artifacts where justified | public claims count only serious lanes |
| `G11` Observability and Auditability | Partial | produce structured receipts and audit artifacts | receipt schema, replay path, and domain evidence pack | third party can reconstruct domain decisions without guesswork |
| `G12` Freshness and Reproducibility | Pass | preserve command-derived evidence discipline | audit commands and replay instructions | review can reproduce results on a pinned commit |
| `G13` Public Claim Discipline | Fail | reduce docs and examples to reviewer-safe scope | wording pass across research/examples/docs | no document implies broader enforcement than exists |
| `G14` Regression Immunity | Fail | add child-domain readiness checks | domain readiness checks and failing CI conditions | claims cannot silently outrun evidence again |

## Level Transitions

## R1 -> R2

Required:
- one child domain selected
- one canonical spec for that child domain
- one canonical Coq file with nontrivial local theorems
- explicit workflow-to-proof mapping

Recommended first target:
- `AO_EXECUTION_RECEIPTS`

Do not claim `R2` if:
- proofs are still boolean decomposition
- workflow coverage is only descriptive
- live implementation still stops at a library artifact

## R2 -> R3

Required:
- real toolchain/runtime enforcement for the selected child domain
- invalid covered workflows rejected
- positive executable workflow exists

Do not claim `R3` if:
- semantics are wrapper-only
- invalid cases are not rejected
- examples are conceptual or unexecuted

## R3 -> R4

Required:
- workflow coverage complete for stated child-domain scope
- negative tests exist
- adversarial tests exist
- residual risks are narrow and explicit

Do not claim `R4` if:
- covered workflows are missing lifecycle stages
- attack cases are absent
- runtime observability is still manual

## R4 -> R5

Required:
- all `G1-G14` pass for the child domain
- third-party reproduction is straightforward
- receipts/observability are real
- public wording is exact
- regression gates prevent drift

Do not claim `R5` if:
- any unsupported case passes silently
- claims depend on generated or vacuous prover lanes
- umbrella wording exceeds child-domain evidence

## Concrete Work Sequence

1. Freeze umbrella public wording at `R1`.
2. Create child-domain specs and IDs.
3. Build `AO_EXECUTION_RECEIPTS` to `R5`.
4. Re-audit `AO_EXECUTION_RECEIPTS`.
5. Build `AO_CONTENT_ADDRESSED_STATE`.
6. Build `AO_MERKLE_DAG`.
7. Build `AO_TOKEN_ACCOUNTING`.
8. Build `AO_SMART_CONTRACT_RUNTIME`.
9. Build `AO_CONSENSUS_CORE`.
10. Re-audit umbrella `AO_BLOCKCHAIN` only after multiple child domains are real.

## Immediate Task List

### First tranche

- materialize the hostile blockchain review artifact in-repo and reconcile umbrella audit wording
- create `AO_EXECUTION_RECEIPTS` audit ID and canonical scope
- create stronger receipt formal model
- connect receipts to runtime execution
- define safe public wording for umbrella `AO_BLOCKCHAIN`

### Next implementation tranche

- add replayable receipt workflows
- add content-addressed public workflow examples
- define token accounting state model
- replace passthrough contract deployment with real semantics
- define explicit consensus scope before adding any more consensus syntax

### Before any new broad claim

- re-run child-domain audit
- run adversarial review
- reduce wording if the review downgrades the result

## Final Rule

The fastest way to fake blockchain progress is to keep adding syntax and theorem names under one umbrella.

The fastest way to reach real `R5` is:
- one narrow child domain
- one explicit scope
- one nontrivial formal model
- one enforced runtime path
- one attack-tested workflow family
