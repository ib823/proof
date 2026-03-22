# Remediation Package: C_INFORMATION_FLOW_CONTROL

## Domain

- Domain ID: `C_INFORMATION_FLOW_CONTROL`
- Domain name: Information Flow Control
- Current honest rating: `R3`
- Target rating: `R4`
- Audit: [C_INFORMATION_FLOW_CONTROL_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/C_INFORMATION_FLOW_CONTROL_R5_AUDIT.md)
- Hostile review: [C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md)
- Hostile review verdict: accept (no reductions)
- Created: 2026-03-20

## Why R3

137 Coq Qed theorems (zero Admitted), 65 IFC-specific formalized tests covering Bell-LaPadula, taint tracking, declassification, CSRF, SQL injection, implicit flow, constant-time. Real enforcement via 6 distinct error types in the typechecker. R3 cap comes from:

- G8 partial: 4 `.rii` IFC example files not toolchain-tested
- G2 partial: no consolidated boundary document
- G4 partial: no consolidated adversary/threat model document
- G14 partial: hook-gated, not CI-gated

## Remediation Items to Reach R4

### R4-1: Wire .rii security examples into integration tests

**Gate:** G8
**Severity:** Medium
**What:** Add integration test that loads each `.rii` file in `07_EXAMPLES/01_security/` and runs parse + typecheck.
**Where:** `03_PROTO/crates/riinac/tests/end_to_end.rs` or new test module
**Acceptance:** `cargo test` loads and validates all 4 IFC examples.

### R4-2: Write consolidated threat model

**Gate:** G4
**Severity:** Medium
**What:** Write a threat model document covering the 14 attack patterns already tested (SQL injection, CSRF, path traversal, command injection, email injection, implicit flow, constant-time bypass, deserialization, wrong sanitizer, wrong declassification proof, Bell-LaPadula violations, etc.).
**Where:** `04_SPECS/scope/IFC_THREAT_MODEL.md` or similar
**Acceptance:** Each attack pattern maps to a formal property, enforcement mechanism, and test.

### R4-3: Write consolidated boundary document

**Gate:** G2
**Severity:** Medium
**What:** Consolidate scope inclusions, exclusions, and assumptions into a single boundary document. Currently spread across 3 research decisions and the audit.
**Where:** `04_SPECS/scope/IFC_BOUNDARY.md` or similar
**Acceptance:** Single document with covered/excluded problems, actors, trust boundaries.

## Items NOT Required for R4 (Future R5 Work)

- Budget-based declassification enforcement in typechecker (proven in Coq, not yet in Rust)
- Runtime taint tracking (type-level only is acceptable for R3-R4)
- Dynamic IFC (research only)
- Distributed IFC across network boundaries (out of scope)
- CI pipeline (R5 blocker, not R4)

## Re-audit Trigger

Re-audit after items R4-1 through R4-3 are completed.
