# AK_VERIFIED_PROCUREMENT R1 To R5 Worklist v1.0.0

This worklist is gate-driven. `AK_VERIFIED_PROCUREMENT` does not move upward because documents or smoke models exist. It moves upward only when gates are re-audited as passing.

## Current Baseline

- Conservative umbrella rating: `R1`
- Conservative blocker gates:
  - `G2`
  - `G3`
  - `G6`
  - `G7`
  - `G8`
  - `G9`
  - `G13`
  - `G14`

## Gate-By-Gate Remediation

| Gate | Current State | Required Change | Required Artifact | Done When |
|------|---------------|-----------------|-------------------|-----------|
| `G1` Canonical Identity | Partial | define child domains and one canonical authority file per child domain | child-domain spec set | every claimed child domain has one canonical spec and one canonical formal file |
| `G2` Boundary Precision | Fail | write explicit in-scope and out-of-scope statements per child domain | scope statements in each child-domain spec | no procurement claim relies on umbrella wording to hide exclusions |
| `G3` Workflow Inventory | Fail/Partial | enumerate valid and forbidden workflows per child domain | workflow matrix per child domain | each claimed workflow maps to formal, implementation, and tests |
| `G4` Threat and Failure Model | Partial | encode bribery, bypass, ordering, and authorization failure states formally and in tests | threat model section plus invalid-state theorems and attack tests | conceptual failures become executable/formal states |
| `G5` Property Set | Partial | complete the core property list per child domain | property matrix per child domain | every public claim maps to an enforceable property |
| `G6` Formal Model Depth | Fail | add real Coq files for the bounded live slice | Coq child-domain files with nontrivial proofs | hostile review cannot dismiss the proofs as absent or cosmetic |
| `G7` Toolchain Enforcement | Fail | implement real procurement syntax/types/effects/runtime semantics | parser/typechecker/runtime/codegen changes plus tests | invalid procurement cases are actually rejected |
| `G8` Executable Evidence | Fail | make canonical procurement examples pass and invalid examples fail | runnable examples and regression tests | examples are live evidence, not concepts |
| `G9` Adversarial Evidence | Fail | add forbidden transition, unauthorized actor, and illegal method tests | negative tests plus attack cases | hostile review finds real rejection evidence |
| `G10` Independent Evidence Honesty | Partial | keep smoke models bounded and clearly labeled | TLA+/Alloy scope notes and status wiring | non-Coq evidence is not overcounted |
| `G11` Observability and Auditability | Partial | add procurement event traces or receipts for the bounded slice | logs, receipts, or domain report artifact | third parties can inspect what happened |
| `G12` Freshness and Reproducibility | Pass | preserve reproducible command paths | commands in audit docs and CI | third parties can rerun the bounded slice |
| `G13` Public Claim Discipline | Fail | reduce research/public wording to the bounded live slice | wording fixes in research and public docs | no compile-time legality claims exceed the toolchain |
| `G14` Regression Immunity | Fail | add procurement readiness checks to CI | domain-specific readiness gate | the rating cannot silently drift downward |

## R1 -> R2

Required:
- one bounded procurement slice with a live Coq lane
- nontrivial state/transition theorems for that slice
- a precise workflow-to-proof map

Do not claim `R2` if:
- the only evidence is research or smoke models
- Coq still has no procurement file
- the formal model does not correspond to the executable slice

## R2 -> R3

Required:
- parser/typechecker/runtime enforcement for the same bounded slice
- at least one valid workflow executes
- at least one invalid workflow is rejected

Do not claim `R3` if:
- examples are still conceptual
- procurement logic lives only in docs
- invalid cases are not rejected by the actual toolchain

## R3 -> R4

Required:
- workflow coverage is complete for the stated slice
- negative and adversarial cases exist
- observability/audit trail exists for the slice

Do not claim `R4` if:
- lifecycle stages are missing
- attack cases are absent
- runtime traces are not inspectable

## R4 -> R5

Required:
- all `G1-G14` pass for the child domain
- third-party reproduction is straightforward
- public wording is exact
- regression gates prevent drift

Do not claim `R5` if:
- any unsupported procurement case passes silently
- smoke models are still carrying claims that belong to the live toolchain
- umbrella wording exceeds child-domain evidence

## Concrete Work Sequence

1. Freeze umbrella wording at `R1`.
2. Create child-domain specs and IDs.
3. Build `AK_PROCUREMENT_STATE_MACHINES` to `R5`.
4. Re-audit `AK_PROCUREMENT_STATE_MACHINES`.
5. Build `AK_PROCUREMENT_ACCESS_CONTROL`.
6. Build `AK_PROCUREMENT_PROTOCOLS`.
7. Build `AK_PROCUREMENT_METHOD_SELECTION`.
8. Build `AK_PROCUREMENT_OCDS_INTEGRITY`.
9. Build `AK_PROCUREMENT_STANDARDS_MAPPINGS`.
10. Re-audit umbrella `AK_VERIFIED_PROCUREMENT` only after multiple child domains are real.

## Immediate Task List

### First tranche

- keep umbrella wording fixed at reviewer-safe `R1`
- define the bounded first procurement lifecycle slice
- make `07_EXAMPLES/08_jalinan/procurement.rii` parse or replace it with a live canonical example
- create the matching Coq file for that same slice
- keep TLA+/Alloy evidence clearly labeled as bounded smoke models

### Next implementation tranche

- add role-aware access-control semantics
- add protocol/order semantics for tender and award flow
- add method-selection logic tied to explicit thresholds and exceptions
- add OCDS data integrity pipeline and tests
- connect procurement events to inspectable traces or receipts

### Before any new broad claim

- re-run child-domain audit
- run adversarial review
- reduce wording if the review downgrades the result

## Final Rule

The fastest way to fake procurement progress is to keep adding policy prose and standards mappings without a live bounded procurement slice.

The fastest way to reach real `R5` is:
- one narrow child domain
- one explicit workflow scope
- one nontrivial Coq model
- one enforced runtime path
- one attack-tested workflow family
