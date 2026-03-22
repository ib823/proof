# C_INFORMATION_FLOW_CONTROL Remediation Plan v1.0.0

## Purpose

Close the documentation and executable evidence gaps that cap `C_INFORMATION_FLOW_CONTROL` at R3, enabling honest promotion to R4.

## Current Truth

As of [C_INFORMATION_FLOW_CONTROL_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/C_INFORMATION_FLOW_CONTROL_R5_AUDIT.md) and [C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md):
- `C_INFORMATION_FLOW_CONTROL` is `R3`
- 137 Coq Qed theorems, zero Admitted — covering Bell-LaPadula, taint tracking, declassification, CSRF, SQL injection, implicit flow, constant-time
- 6 distinct IFC error types enforced in the typechecker
- 65 IFC-specific formalized tests
- 4 `.rii` IFC example files exist but are not toolchain-tested
- No consolidated threat model document (14 attack patterns tested but undocumented as a model)
- No consolidated boundary document (scope spread across 3 research decisions)

## Governing Rules

1. Untested `.rii` examples do not count as executable evidence regardless of their syntactic correctness.
2. Tested attack patterns do not substitute for an explicit threat model — the model must be a document, not an implication.
3. Scope scattered across multiple documents does not satisfy boundary precision — consolidation is required.

## Required Structural Changes

### 1. Activate IFC example evidence

Wire the 4 `.rii` files in `07_EXAMPLES/01_security/` into integration tests so they serve as executable evidence for IFC properties.

### 2. Consolidate threat model

The 14 attack patterns (SQL injection, CSRF, path traversal, command injection, email injection, implicit flow, constant-time bypass, deserialization, wrong sanitizer, wrong declassification proof, Bell-LaPadula violations, etc.) are tested but not documented as a coherent threat model. Create one.

### 3. Consolidate boundary document

Scope inclusions, exclusions, and assumptions are spread across 3 research decisions and the audit. Consolidate into a single boundary document.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G2 | Partial | Consolidate scope into single boundary document | `04_SPECS/scope/IFC_BOUNDARY.md` | Single document with covered/excluded problems, actors, trust boundaries |
| G4 | Partial | Write consolidated threat model | `04_SPECS/scope/IFC_THREAT_MODEL.md` | Each of 14 attack patterns maps to property, enforcement, and test |
| G8 | Partial | Wire `.rii` examples into integration tests | `03_PROTO/crates/riinac/tests/` | `cargo test` validates all 4 IFC examples |
| G14 | Partial | Maintain hook-gated enforcement (CI deferred to R5) | Pre-commit/pre-push hooks | No regression in tested properties |

## Exit Criteria

`C_INFORMATION_FLOW_CONTROL` may not claim R4 until:
- All 4 `.rii` IFC examples pass parse + typecheck via `cargo test`
- Consolidated threat model document exists with full attack-to-evidence mapping
- Consolidated boundary document exists with explicit scope inclusions and exclusions
- Re-audit confirms G2, G4, and G8 pass
