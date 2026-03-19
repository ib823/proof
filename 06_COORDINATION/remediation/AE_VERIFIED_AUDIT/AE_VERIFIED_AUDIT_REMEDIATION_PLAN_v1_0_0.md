# AE_VERIFIED_AUDIT Remediation Plan v1.0.0

## Purpose

Turn `AE_VERIFIED_AUDIT` from a research-backed audit/compliance concept into a domain that can eventually support honest end-to-end audit-trail claims.

## Current Truth

As of [AE_VERIFIED_AUDIT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AE_VERIFIED_AUDIT_R5_AUDIT.md) and [AE_VERIFIED_AUDIT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AE_VERIFIED_AUDIT_R5_REVIEW.md):
- `AE_VERIFIED_AUDIT` is `R1`
- live implementation centers on compliance-report generation and `Write`-proxy audit linting
- no first-class `Audit` effect exists in `riina-types`
- no live append-only tamper-evident audit runtime exists
- Coq is mechanized but shallow
- generated non-Coq lanes are not safe to count as independent evidence

## Governing Rule

The domain may not be claimed above what the weakest live link supports. Today that weakest link is the absence of a real `Audit` effect and the absence of a dedicated audit-log runtime.

## Non-Negotiable Remediation Principles

1. `Write` is not enough to count as verified audit completeness.
2. Compliance reports are not the same thing as tamper-evident audit trails.
3. Generated prover lanes do not raise this domain’s assurance level.
4. Example files do not count as executable evidence unless CI runs them end-to-end.
5. Public wording must shrink to the live enforced subset until remediation lands.

## Required Structural Changes

### 1. Add a first-class audit effect

Required outcome:
- a dedicated `Audit` effect or equivalent language-level construct
- typechecker support for propagating and requiring it
- explicit rejection when security-relevant operations omit it

### 2. Build a real audit-log runtime

Required outcome:
- append-only audit log structure
- tamper-evident storage semantics
- runtime verification path for integrity checks
- explicit invalid-state rejection or alarm behavior

### 3. Rebuild the formal model

Required outcome:
- move beyond reflexive and boolean-unfolding proofs
- introduce state, transition, and trace theorems tied to the runtime
- prove append-only, completeness, and tamper-detection against the actual workflow model

### 4. Bind examples to CI

Required outcome:
- at least one valid audit-trail workflow
- at least one invalid/missing-audit workflow
- at least one tamper/truncation attack workflow
- all executed in CI

### 5. Repair public wording

Required outcome:
- website and spec wording reduced to the reviewer-safe `R1` claim until remediation lands

## Execution Order

1. Add `Audit` effect and rejection rules.
2. Build append-only audit-log runtime.
3. Add integrity verification and adversarial tests.
4. Rework Coq around the real runtime model.
5. Re-audit the domain.

## Exit Criteria

`AE_VERIFIED_AUDIT` may not move above `R1` until:
- `Audit` is a real first-class effect
- append-only audit logging exists live
- tamper detection is executable
- public claims stop outrunning the live subset
