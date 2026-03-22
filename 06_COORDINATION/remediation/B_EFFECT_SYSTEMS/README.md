# Remediation Package: B_EFFECT_SYSTEMS

## Domain

- Domain ID: `B_EFFECT_SYSTEMS`
- Domain name: Effect Systems
- Current honest rating: `R3`
- Target rating: `R4`
- Audit: [B_EFFECT_SYSTEMS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_AUDIT.md)
- Hostile review: [B_EFFECT_SYSTEMS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_REVIEW.md)
- Hostile review verdict: accept (no reductions)
- Created: 2026-03-20

## Why R3

The domain has strong formal foundations (142 Coq Qed theorems, zero Admitted) and real three-layer enforcement (compile-time, runtime, package). The R3 cap comes from:

- G3 partial: no explicit canonical workflow inventory
- G4 partial: no explicit adversary/threat model
- G8 partial: 17 `.rii` example files are syntax-only, not toolchain-tested
- G9 partial: only 4 negative test scenarios; no boundary, mutation, or tamper tests

## Remediation Items to Reach R4

### R4-1: Wire .rii examples into integration tests

**Gate:** G8
**Severity:** Medium
**What:** Add a Rust integration test that dynamically loads each `.rii` file in `07_EXAMPLES/02_effects/` and runs it through parse + typecheck (at minimum).
**Where:** `03_PROTO/crates/riinac/tests/end_to_end.rs` or a new test module
**Acceptance:** `cargo test` loads and validates all 17 effect examples without failure.

### R4-2: Expand adversarial test coverage

**Gate:** G9
**Severity:** Medium
**What:** Add boundary-value and adversarial tests:
- Effect at ceiling boundary (e.g., `kesan Tulis` function calling `kesan Rangkaian` function)
- Join of two non-pure effects
- Malformed handler dispatch
- Attempt to grant an effect already in scope (idempotence check)
- Attempt to perform an effect not in the grant set (boundary)
- Package escalation with nested dependencies
**Where:** `03_PROTO/crates/riina-typechecker/src/program.rs` (tests section) and `03_PROTO/crates/riina-codegen/src/interp.rs` (tests section)
**Acceptance:** At least 10 new negative test cases covering boundary and adversarial scenarios.

### R4-3: Write canonical workflow inventory

**Gate:** G3
**Severity:** Medium
**What:** Write an explicit workflow inventory mapping each valid and forbidden workflow to its proof, enforcement, and test evidence.
**Where:** `04_SPECS/effect_gate/WORKFLOW_INVENTORY.md` or inline in the audit
**Acceptance:** Every workflow in the audit's workflow matrix has a traceable link to at least one test and one formal artifact.

### R4-4: Write explicit threat/adversary model

**Gate:** G4
**Severity:** Medium
**What:** Write a threat model covering:
- Effect escalation (dependency declares more effects than parent allows)
- Capability bypass (require without grant)
- Handler abuse (malformed or missing handler)
- Pure-context violation (impure operation in pure function)
- Effect ceiling bypass (function body exceeds declared effect)
**Where:** `04_SPECS/effect_gate/THREAT_MODEL.md` or inline in research
**Acceptance:** Each threat has a corresponding formal property, enforcement mechanism, and test.

## Items NOT Required for R4 (Future R5 Work)

- Coeffect runtime implementation (research decided, not built — low priority)
- Effect handler optimization (zero-overhead state/reader — research only)
- Row polymorphism (research only)
- Automated CI pipeline (currently hook-gated — R5 blocker, not R4)
- Public claim audit (deferred — R5 blocker)

## Re-audit Trigger

Re-audit this domain after items R4-1 through R4-4 are completed and verified by running the full test suite.
