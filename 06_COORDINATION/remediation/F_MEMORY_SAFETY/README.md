# Remediation Package: F_MEMORY_SAFETY

## Domain
- Domain ID: `F_MEMORY_SAFETY`
- Current honest rating: `R3`
- Target rating: `R4`
- Hostile review verdict: accept (no reductions)
- Created: 2026-03-20

## Why R3
632 Coq Qed (nontrivial), real linearity enforcement (14 tests, 6 negative). R3 cap: formal model is broad (spatial, temporal, bounds, ROP, data races) but enforcement is narrow (linearity only).

## Remediation Items to Reach R4

### R4-1: Wire .rii examples into integration tests
**Gate:** G8 | **Severity:** Medium
**What:** Integration test for `07_EXAMPLES/01_security/{linear_types,linear_enforcement}.rii`

### R4-2: Scope clarification — split enforced vs formal-only
**Gate:** G2 | **Severity:** Medium
**What:** Explicitly document which memory safety properties are enforced vs formal-only. Either implement spatial safety in typechecker OR scope-exclude it from the enforcement claim.

### R4-3: Add spatial/temporal adversarial tests
**Gate:** G9 | **Severity:** Medium
**What:** If spatial safety is brought into enforcement scope, add negative tests for bounds overflow and use-after-free rejection.

### R4-4: Write threat model
**Gate:** G4 | **Severity:** Medium

## Re-audit Trigger
Re-audit after scope clarification (R4-2) and either spatial enforcement or explicit scope exclusion.
