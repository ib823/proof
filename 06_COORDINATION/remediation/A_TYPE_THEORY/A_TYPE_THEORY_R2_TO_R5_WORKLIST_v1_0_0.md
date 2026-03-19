# A_TYPE_THEORY R2 To R5 Worklist v1.0.0

This worklist is gate-driven. `A_TYPE_THEORY` does not move upward because it has a large research archive and strong Coq core. It moves upward only when the umbrella is split, the example corpus is repaired, and a bounded child domain is re-audited with stronger executable evidence.

## Current Baseline

- Conservative umbrella rating: `R2`
- Conservative blocker gates:
  - `G2`
  - `G3`
  - `G7`
  - `G8`
  - `G10`
  - `G13`
  - `G14`

## Gate-By-Gate Remediation

| Gate | Current State | Required Change | Required Artifact | Done When |
|------|---------------|-----------------|-------------------|-----------|
| `G1` Canonical Identity | Partial | define one bounded child domain as the primary live target | bounded scope pack | the live child domain and research subset line up |
| `G2` Boundary Precision | Fail | write explicit in-scope and out-of-scope statements for the umbrella and child domains | scope statement | the 20-branch umbrella is no longer implied as one live subsystem |
| `G3` Workflow Inventory | Fail | rebuild workflow evidence around examples that actually pass | workflow matrix | canonical positive and negative workflows are executable |
| `G4` Threat and Failure Model | Partial | write explicit failure and abuse cases for the bounded child domain | threat model and negative workflows | failure handling is explicit |
| `G5` Property Set | Partial | keep only bounded, live-linked properties in strong current-state claims | property matrix | every public property maps to live scope |
| `G6` Formal Model Depth | Pass | preserve core Coq depth while aligning it with the chosen child domain | updated Coq mapping | proof depth stays real and scoped |
| `G7` Toolchain Enforcement | Partial | bind claims only to the enforced child domain surface | AST/typechecker/runtime/codegen map | every claimed feature is truly enforced |
| `G8` Executable Evidence | Fail | repair or replace canonical examples | live examples and tests | the example corpus passes for the child domain |
| `G9` Adversarial Coverage | Partial | add stronger negative and boundary workflows for the child domain | negative tests | invalid cases are demonstrably rejected |
| `G10` Independent Evidence Honesty | Fail | remove generated/vacuous lanes from strong confidence claims | metrics/wording cleanup | multi-prover inflation stops |
| `G11` Observability and Auditability | Pass | preserve traceability | audit artifacts | reviewers can reconstruct the rating |
| `G12` Freshness and Reproducibility | Pass | keep command-derived evidence current | audit commands and CI | evidence remains reproducible |
| `G13` Public Claim Discipline | Fail | purge umbrella-wide implementation wording | wording updates | claims match the bounded child domain |
| `G14` Regression Immunity | Partial | add a readiness gate for the child domain and umbrella boundaries | domain-specific CI checks | rating cannot silently drift |

## R2 -> R3

Required:
- `A_TYPE_THEORY_CORE` or another bounded child domain is explicitly scoped
- canonical positive and negative examples for that child domain pass
- strong claims stop at the child-domain boundary

Do not claim `R3` if:
- the umbrella still stands in for every research branch
- examples still fail
- generated/vacuous lanes are still used as confidence inflation

## R3 -> R4

Required:
- workflow coverage is complete for the child domain
- adversarial coverage is explicit
- residual risks are written

## R4 -> R5

Required:
- all `G1-G14` pass for the child domain
- third-party reproduction is straightforward
- the umbrella is re-audited only after multiple child domains mature

## Concrete Work Sequence

1. Freeze wording at the reviewer-safe `R2` umbrella claim.
2. Split the umbrella and choose `A_TYPE_THEORY_CORE` as the first serious child domain.
3. Repair the example corpus for the core subset.
4. Re-audit the child domain.
5. Revisit the umbrella only after honest child-domain maturity exists.

## Final Rule

The fastest way to fake progress is to keep calling the whole 20-branch umbrella “enforced.”

The fastest way to reach real `R5` is:
- one bounded child domain
- one repaired canonical example set
- one honest proof-to-implementation mapping
- one re-audit that survives hostile review
