# F_MEMORY_SAFETY Remediation Plan v1.0.0

## Purpose

Resolve the scope-enforcement mismatch that caps `F_MEMORY_SAFETY` at R3: the formal model is broad (spatial, temporal, bounds, ROP, data races) but enforcement is narrow (linearity only). Either expand enforcement or narrow scope.

## Current Truth

As of the R5 audit and hostile review (both accepted, no reductions):
- `F_MEMORY_SAFETY` is `R3`
- 632 Coq Qed theorems, nontrivial — covering linearity, spatial safety, temporal safety, bounds checking, ROP defense, data race freedom
- Real linearity enforcement in the typechecker with 14 tests (6 negative)
- Enforcement covers ONLY linearity — spatial safety, temporal safety, bounds checking, ROP defense, and data race freedom are formal-only
- `.rii` examples (`linear_types.rii`, `linear_enforcement.rii`) exist but are not toolchain-tested
- No explicit scope document separating enforced vs. formal-only properties
- No explicit threat model

## Governing Rules

1. A domain may not claim enforcement-level maturity for properties that are only formally modeled but not enforced. The rating is capped by the weakest enforced link.
2. The scope-enforcement gap must be resolved explicitly: either implement spatial safety enforcement OR scope-exclude it from enforcement claims.
3. Untested `.rii` examples do not count as executable evidence.
4. A broad formal model is an asset, but claiming it as enforcement is dishonest.

## Required Structural Changes

### 1. Scope clarification (critical decision point)

The domain must make an explicit decision:
- **Option A:** Implement spatial safety enforcement in the typechecker, bringing it into the enforced scope alongside linearity.
- **Option B:** Explicitly scope-exclude spatial, temporal, bounds, ROP, and data race properties from enforcement claims, limiting the enforcement claim to linearity only.

Option B is faster and honest. Option A is more valuable but requires significant implementation work. The decision must be documented.

### 2. Activate example evidence

Wire `07_EXAMPLES/01_security/linear_types.rii` and `linear_enforcement.rii` into integration tests.

### 3. Add adversarial tests matching scope

If spatial safety is brought into enforcement scope (Option A), add negative tests for bounds overflow and use-after-free rejection. If scoped out (Option B), add deeper linearity adversarial tests.

### 4. Write threat model

Document threats appropriate to the resolved scope.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G2 | Partial | Write scope clarification document (Option A or B) | `04_SPECS/scope/MEMORY_SAFETY_BOUNDARY.md` | Explicit enforced vs. formal-only property list |
| G4 | Partial | Write threat model for resolved scope | `04_SPECS/scope/MEMORY_SAFETY_THREAT_MODEL.md` | Each threat maps to property, enforcement, and test |
| G8 | Partial | Wire `.rii` examples into integration tests | `03_PROTO/crates/riinac/tests/` | `cargo test` validates both linearity examples |
| G9 | Partial | Add adversarial tests matching resolved scope | Typechecker test modules | Boundary and escalation scenarios covered |

## Exit Criteria

`F_MEMORY_SAFETY` may not claim R4 until:
- Scope clarification document exists with explicit Option A or Option B decision
- `.rii` examples pass parse + typecheck via `cargo test`
- Adversarial tests match the resolved enforcement scope
- Threat model exists for the resolved scope
- Re-audit confirms G2, G4, G8, and G9 pass
