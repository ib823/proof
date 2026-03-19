# AE_VERIFIED_AUDIT R1 to R5 Worklist v1.0.0

## Current Baseline

- Rating: `R1`
- Why:
  - research exists
  - Coq exists
  - compliance-report and audit-lint tooling exists
  - no first-class `Audit` effect exists
  - no live tamper-evident append-only runtime exists

## Worklist

### R1 to R2

- replace shallow definition-level proofs with nontrivial local theorems
- narrow public scope to the actually implemented subset
- explicitly demote generated non-Coq lanes in domain claims

### R2 to R3

- add `Audit` effect to `riina-types`
- propagate and enforce it in parser, typechecker, and runtime-relevant code paths
- add live append-only audit-log data structure
- reject missing-audit cases in the toolchain

### R3 to R4

- execute valid audit workflows in CI
- execute invalid audit workflows in CI
- add tamper/truncation adversarial tests
- bind inclusion / consistency verification to live runtime behavior

### R4 to R5

- add domain-specific regression gates
- make public wording exact and conservative
- make third-party reproduction straightforward
- ensure every gate `G1-G14` passes under hostile review

## Immediate Next Slice

1. Introduce `Audit` as a real effect.
2. Replace `Write`-proxy audit completeness checks with real audit-effect enforcement.
3. Add one canonical append-only audit-log workflow and one missing-audit rejection workflow.
