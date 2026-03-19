# AN_SYARIAH R1 To R5 Worklist v1.0.0

This worklist is gate-driven. `AN_SYARIAH` does not move upward because work was done. It moves upward only when gates are re-audited as passing.

## Current Baseline

- Current umbrella rating: `R1`
- Current blocker gates from the audited record:
  - `G4`
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
| `G1` Canonical Identity | Partial | define child domains and one canonical authority file per child | child-domain spec set | every claimed child domain has one canonical spec and one canonical formal file |
| `G2` Boundary Precision | Partial | write explicit in-scope and out-of-scope statements per child domain and profile | scope statements in each child-domain spec | no child domain uses umbrella wording to hide exclusions |
| `G3` Workflow Inventory | Partial | enumerate valid and forbidden workflows per child domain | workflow matrix per child domain | each claimed workflow maps to formal, implementation, and tests |
| `G4` Threat and Failure Model | Fail | encode abuse, sequencing, and invalid-state models formally and in tests | threat model section plus invalid-state theorems and attack tests | conceptual threats become executable/formal states |
| `G5` Property Set | Partial | complete core property list per child domain | property matrix per child domain | every core claim has a corresponding property and enforcement path |
| `G6` Formal Model Depth | Fail | replace boolean-flag proofs with lifecycle and accounting theorems | new Coq domain files with nontrivial proofs | hostile review cannot classify proofs as definitional theater |
| `G7` Toolchain Enforcement | Fail | implement real semantics and invalid-case rejection | parser/typechecker/runtime/codegen changes plus tests | wrapper-only or lexer-only support is gone for claimed features |
| `G8` Executable Evidence | Fail | add real end-to-end workflows | audited `.rii` workflows and test commands | at least one positive and one negative workflow per child domain execute |
| `G9` Adversarial Coverage | Fail | add domain-specific attack cases | adversarial test suite | tamper, duplication, sequencing, and boundary attacks are exercised |
| `G10` Evidence Honesty Across Prover Lanes | Fail | demote weak lanes or replace them with meaningful encodings | lane-classification note plus improved artifacts where justified | public claims count only serious lanes |
| `G11` Observability and Auditability | Partial | produce structured receipts and audit artifacts | receipt schema and verification path | third party can reconstruct domain decisions without guesswork |
| `G12` Freshness and Reproducibility | Pass | preserve command-derived evidence discipline | audit commands and replay instructions | review can reproduce results on a pinned commit |
| `G13` Public Claim Discipline | Fail | reduce docs and examples to reviewer-safe scope | wording pass across research/examples/docs | no document implies broader enforcement than exists |
| `G14` Regression Immunity | Fail | add CI/domain gates | domain readiness checks and failing CI conditions | claims cannot silently outrun evidence again |

## Level Transitions

## R1 -> R2

Required:
- one child domain selected
- one canonical spec for that child domain
- one canonical Coq file with nontrivial local theorems
- explicit workflow-to-proof mapping

Recommended first target:
- `AN_SYARIAH_ZAKAT`

Do not claim `R2` if:
- proofs are still boolean decomposition
- workflow coverage is only descriptive
- live implementation still uses toy semantics

## R2 -> R3

Required:
- real toolchain enforcement for the selected child domain
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
- profile ambiguity is silently ignored

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
3. Implement governance/profile selection.
4. Build `AN_SYARIAH_ZAKAT` to `R5`.
5. Re-audit `AN_SYARIAH_ZAKAT`.
6. Only then start the next child domain.
7. Re-audit umbrella `AN_SYARIAH` after multiple child domains are real.

## Immediate Task List

### Week 1 equivalent

- create `AN_SYARIAH_GOVERNANCE_PROFILES` scope
- create `AN_SYARIAH_ZAKAT` canonical spec
- create `02_FORMAL/coq/domains/Zakat.v`
- define supported profile `AAOIFI_ZAKAT_CORE_V1`
- define out-of-scope cases that must fail closed

### Next implementation tranche

- add real zakat AST and profile constructs
- add rejection rules
- add runtime assessment and receipts
- add executable valid/invalid workflows

### Before any new broad claim

- re-run domain audit
- run adversarial review
- reduce wording if the review downgrades the result

## Final Rule

The fastest way to fake progress is to spread effort thinly across all Syariah topics.

The fastest way to reach real `R5` is:
- one narrow child domain
- one explicit profile
- one nontrivial formal model
- one enforced runtime path
- one attack-tested workflow family
