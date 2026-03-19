# AJ_VERIFIED_COMPLIANCE R1 to R5 Worklist v1.0.0

## Current Baseline

- Rating: `R1`
- Why:
  - canonical research exists
  - active Coq exists
  - a large opt-in rule/report engine exists
  - no first-class frontend compliance regime exists
  - canonical examples are not yet reliable live executable evidence
  - derived non-Coq lanes are too weak to count strongly

## Worklist

### R1 to R2

- narrow the public scope to the actually implemented subset
- replace shallow Coq theorems with nontrivial local theorems for that same subset
- explicitly demote duplicate and vacuous secondary lanes in domain claims

### R2 to R3

- add a bounded first-class compliance effect/type regime
- propagate and enforce it in parser, typechecker, and runtime-relevant paths
- distinguish enforced checks from heuristic rule-pack checks
- reject invalid covered cases in the live frontend

### R3 to R4

- execute valid compliance workflows in CI
- execute invalid workflows in CI
- add adversarial drift and claim-mismatch checks
- make canonical examples authoritative and live

### R4 to R5

- add AJ-specific regression gates
- make public/business wording exact and conservative
- make third-party reproduction straightforward
- ensure every gate `G1-G14` passes under hostile review

## Immediate Next Slice

1. Introduce `AJ_COMPLIANCE_EFFECTS_AND_TYPES` as a bounded live subset.
2. Make one canonical privacy or payment example parse/typecheck/run end-to-end.
3. Rework Coq and reports around that same bounded subset instead of the entire umbrella.
