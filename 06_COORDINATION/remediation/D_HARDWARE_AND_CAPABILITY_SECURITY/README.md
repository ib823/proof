# Remediation Package: D_HARDWARE_AND_CAPABILITY_SECURITY

## Domain

- Domain ID: `D_HARDWARE_AND_CAPABILITY_SECURITY`
- Domain name: Hardware and Capability Security
- Current honest rating: `R1`
- Target rating: `R2`
- Audit: [D_HARDWARE_AND_CAPABILITY_SECURITY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/D_HARDWARE_AND_CAPABILITY_SECURITY_R5_AUDIT.md)
- Hostile review: [D_HARDWARE_AND_CAPABILITY_SECURITY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/D_HARDWARE_AND_CAPABILITY_SECURITY_R5_REVIEW.md)
- Hostile review verdict: **reject** (downgrade from R2 to R1)
- Created: 2026-03-20

## Why R1

The hostile review discovered that all 255 Coq theorems in this domain are vacuous:
- `HardwareSecurity.v`: all 34 theorems prove `True` via `trivial.`
- `CapabilitySecurity.v`: all 108 theorems prove `true = true` via `reflexivity.` on hardcoded boolean record fields
- `TerasCapabilities.v`, `S001_HardwareContracts.v`, `VerifiedHardware.v`: same pattern

These are syntactically valid Coq but mathematically meaningless. They prove nothing about hardware security or capability properties. The domain therefore has:
- Research specification (R1 level)
- No real formal model (vacuous proofs do not constitute a model)
- No toolchain enforcement
- No executable evidence

## Remediation Items to Reach R2

### R2-1: Rewrite Coq proofs with nontrivial properties

**Gate:** G6
**Severity:** Critical
**What:** Replace vacuous `True` conclusions and `true = true` tautologies with actual formal properties:
- Capability unforgability should prove that capability creation requires authority
- Capability monotonicity should prove that derived permissions are a subset of source permissions
- Hardware attack mitigations should prove that mitigation configurations satisfy security invariants (not just that boolean flags are set)
**Where:** `02_FORMAL/coq/domains/{HardwareSecurity,CapabilitySecurity,TerasCapabilities}.v`
**Acceptance:** No theorem concludes with `True` or proves `reflexivity` on hardcoded fields. Each theorem proves a property that could fail if definitions changed.

### R2-2: Bound scope to implementable subset

**Gate:** G2
**Severity:** High
**What:** The umbrella covers hardware attacks, software capabilities, CHERI, and TERAS OS simultaneously. Bound the scope to a single implementable subset (e.g., "software capability enforcement" or "microarchitectural attack mitigation properties").
**Where:** Research or spec document
**Acceptance:** Single bounded scope statement with explicit exclusions.

### R2-3: Write workflow inventory

**Gate:** G3
**Severity:** Medium
**What:** Define valid and forbidden workflows for the bounded scope.
**Where:** Audit or spec document
**Acceptance:** Each workflow maps to at least one formal property.

## Methodology Lesson

This domain exposed a critical gap in the audit methodology: **Qed count without proof body inspection is insufficient.** Future audits must sample theorem bodies to verify nontriviality. A theorem proving `True` has zero informational content regardless of how many hypotheses it accepts.

## Re-audit Trigger

Re-audit after R2-1 (nontrivial Coq proofs) is completed.
