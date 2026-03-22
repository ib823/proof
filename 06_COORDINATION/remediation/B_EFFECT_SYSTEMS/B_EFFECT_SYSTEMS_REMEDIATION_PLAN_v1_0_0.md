# B_EFFECT_SYSTEMS Remediation Plan v1.0.0

## Purpose

Turn `B_EFFECT_SYSTEMS` from a formally strong but under-tested domain into a fully evidenced R4+ domain by closing documentation gaps and wiring executable evidence into the test suite.

## Current Truth

As of [B_EFFECT_SYSTEMS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_AUDIT.md) and [B_EFFECT_SYSTEMS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_REVIEW.md):
- `B_EFFECT_SYSTEMS` is `R3`
- 142 Coq Qed theorems, zero Admitted — formal depth is real
- Three-layer enforcement (compile-time, runtime, package) is operational
- 17 `.rii` example files exist but are syntax-only, not toolchain-tested
- Only 4 negative test scenarios; no boundary, mutation, or tamper tests
- No canonical workflow inventory document
- No explicit adversary/threat model document

## Governing Rules

1. Example files that are not toolchain-tested do not count as executable evidence.
2. Adversarial coverage must include boundary, mutation, and escalation scenarios — not just happy-path negatives.
3. A workflow inventory must be traceable: every workflow links to at least one test and one formal artifact.
4. A threat model must be explicit and falsifiable, not implied by test existence.

## Required Structural Changes

### 1. Activate dormant example evidence

The 17 `.rii` files in `07_EXAMPLES/02_effects/` are dead weight until they pass through parse + typecheck. Wire them into integration tests so they serve as executable evidence.

### 2. Expand adversarial surface

4 negative tests is thin for a domain with 142 formal theorems. The adversarial surface must cover effect escalation, capability bypass, handler abuse, pure-context violation, and ceiling bypass.

### 3. Formalize workflow traceability

Create an explicit workflow inventory mapping every valid and forbidden workflow to its proof, enforcement mechanism, and test evidence.

### 4. Formalize threat model

Create an explicit threat model enumerating the attack patterns the effect system defends against, with links to formal properties, enforcement mechanisms, and tests.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G3 | Partial | Write canonical workflow inventory | `04_SPECS/effect_gate/WORKFLOW_INVENTORY.md` | Every workflow has traceable links to test + formal artifact |
| G4 | Partial | Write explicit threat/adversary model | `04_SPECS/effect_gate/THREAT_MODEL.md` | Each threat maps to property, enforcement, and test |
| G8 | Partial | Wire `.rii` examples into integration tests | `03_PROTO/crates/riinac/tests/` | `cargo test` validates all 17 effect examples |
| G9 | Partial | Add 10+ boundary/adversarial test cases | typechecker + codegen test modules | Boundary, mutation, tamper, escalation scenarios covered |

## Exit Criteria

`B_EFFECT_SYSTEMS` may not claim R4 until:
- All 17 `.rii` examples are toolchain-tested via `cargo test`
- At least 10 new adversarial test cases exist covering boundary and escalation scenarios
- Workflow inventory and threat model documents exist with full traceability
- Re-audit confirms all four gates pass
