# AL_VERIFIED_LAYOUT R2 To R5 Worklist v1.0.0

This worklist is gate-driven. `AL_VERIFIED_LAYOUT` does not move upward because the repo has layout research or a detached renderer crate. It moves upward only when the bounded live slice and the public claim surface are re-audited as passing.

## Current Baseline

- Conservative umbrella rating: `R2`
- Conservative blocker gates:
  - `G2`
  - `G3`
  - `G4`
  - `G5`
  - `G7`
  - `G8`
  - `G9`
  - `G10`
  - `G11`
  - `G13`
  - `G14`

## Gate-By-Gate Remediation

| Gate | Current State | Required Change | Required Artifact | Done When |
|------|---------------|-----------------|-------------------|-----------|
| `G1` Canonical Identity | Partial | unify the live story around one bounded layout subsystem | bounded scope note plus compiler/backend ownership map | research, formal, and implementation slices clearly line up |
| `G2` Boundary Precision | Fail | write explicit in-scope and out-of-scope statements for the current UI subset | scope section in live specs and audit docs | perfect-UI claims disappear |
| `G3` Workflow Inventory | Partial | enumerate valid and invalid UI/layout workflows for the bounded slice | workflow matrix and example set | every claim maps to a live workflow |
| `G4` Threat and Failure Model | Partial | add invalid sequencing, broken interaction, and accessibility failure states | threat model plus negative tests | failure states are explicit and executable |
| `G5` Property Set | Partial | tie live properties to the bounded slice only | property matrix | no property is still research-only while being publicly claimed |
| `G6` Formal Model Depth | Partial | replace sample-instance-heavy reasoning with workflow-tied proofs where the live slice claims enforcement | stronger Coq file revisions | hostile review sees structural rather than mostly boolean validity proofs |
| `G7` Toolchain Enforcement | Partial | wire renderer/backend support into the compiler path | backend integration changes | the bounded slice is actually part of the compiler |
| `G8` Executable Evidence | Partial | make all canonical examples run | repaired examples plus tests | no canonical CAHAYA example is broken |
| `G9` Adversarial Evidence | Partial | add end-to-end negative layout/accessibility tests | invalid examples and regression tests | hostile review sees real rejection evidence |
| `G10` Independent Evidence Honesty | Partial | keep generated/vacuous lanes out of strong claims | wording and status notes | non-Coq lanes are not overcounted |
| `G11` Observability and Auditability | Partial | add reproducible renderer/output evidence and domain-specific status reports | output snapshots or audit artifacts | third parties can inspect the bounded slice clearly |
| `G12` Freshness and Reproducibility | Pass | preserve rerunnable commands | audit commands and CI | third parties can re-run the evidence |
| `G13` Public Claim Discipline | Fail | strip perfect-UI and pixel-perfect language from current-status claims | wording updates | all public wording matches the bounded live slice |
| `G14` Regression Immunity | Fail | add AL readiness checks to CI | domain-specific readiness gate | rating cannot silently drift |

## R2 -> R3

Required:
- integrated compiler/backend support for the bounded slice
- all canonical examples parse and run
- invalid covered cases are rejected or flagged through the real toolchain

Do not claim `R3` if:
- the live backend path is still detached
- canonical examples still fail
- HTML/terminal rendering remains crate-only

## R3 -> R4

Required:
- workflow coverage is complete for the stated slice
- end-to-end negative and adversarial tests exist
- residual risks are narrow and explicit

Do not claim `R4` if:
- accessibility failures are only unit-test local
- interactions are not covered
- the live slice still excludes major claimed workflows without saying so

## R4 -> R5

Required:
- all `G1-G14` pass
- third-party reproduction is straightforward
- claims are exact and conservative
- regression gates prevent drift

Do not claim `R5` if:
- perfect-UI wording returns without matching evidence
- advanced layout claims still outrun the live slice
- generated lanes are still being used as confidence inflation

## Concrete Work Sequence

1. Freeze public wording at the reviewer-safe `R2` claim.
2. Fix `hello_ui.rii`.
3. Add explicit HTML/terminal compiler integration.
4. Bind live workflows to the bounded Coq slice.
5. Add end-to-end negative UI/accessibility workflows.
6. Re-audit the domain.

## Final Rule

The fastest way to fake progress here is to keep publishing perfect-layout rhetoric while the real compiler can only handle a narrow CAHAYA subset.

The fastest way to reach real `R5` is:
- one bounded live slice
- one integrated backend path
- one fully working example suite
- one stronger formal model tied to that exact slice
