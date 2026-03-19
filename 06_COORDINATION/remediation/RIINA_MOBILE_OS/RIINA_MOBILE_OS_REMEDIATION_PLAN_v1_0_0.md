# RIINA_MOBILE_OS Remediation Plan v1.0.0

## Purpose

Turn `RIINA_MOBILE_OS` from a broad research thesis plus bounded formal and implementation slices into a domain that can eventually support honest mobile/OS claims.

## Current Truth

As of [RIINA_MOBILE_OS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_MOBILE_OS_R5_AUDIT.md) and [RIINA_MOBILE_OS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_MOBILE_OS_R5_REVIEW.md):
- `RIINA_MOBILE_OS` is `R2`
- multiple real Coq files exist for mobile platform, mobile bridge verification, and TERAS-oriented kernel/security/capability slices
- `03_PROTO/crates/riina-os/` is a real tested primitive crate
- Android/iOS bridge generation targets are live and reachable through `riinac`
- there is no live end-to-end mobile operating system or TERAS runtime workflow through the language
- secondary lanes are generated or vacuous and must not be counted as strong independent evidence
- research wording overclaims a complete mathematically proven mobile OS replacing Android/iOS

## Governing Rule

The domain may not be claimed above the weakest live link. Today that weakest link is the absence of a real integrated mobile OS workflow despite broad research claims.

## Non-Negotiable Remediation Principles

1. A tested primitive crate plus bridge generators is not a mobile operating system.
2. Config-heavy theorem files do not justify full-stack mobile-OS claims.
3. Generated or vacuous secondary lanes do not count as serious independent support.
4. The umbrella must split into bounded child domains before it can honestly move upward.
5. The first promotion path should follow the strongest evidence-to-scope ratio, not the broadest marketing surface.

## Required Strategic Shift

### 1. Freeze the claim surface

Required outcome:
- all wording drops to the reviewer-safe `R2` claim
- world-first and Android/iOS-obsolescence wording stops in current-state descriptions

### 2. Split the umbrella into bounded child domains

Required outcome:
- separate mobile bridges, OS primitives, TERAS kernel/security, Android/iOS targets, and integration into distinct auditable slices
- each child domain declares exact in-scope and out-of-scope boundaries

### 3. Choose the first flagship vertical

Required outcome:
- start with `RIINA_MOBILE_OS_MOBILE_BRIDGES`
- keep kernel, capability, and runtime ambitions explicitly out of the first `R5`

### 4. Materialize one live bounded subsystem

Required outcome:
- one mobile child domain has real compiler/runtime semantics, executable examples, invalid-case rejection, and auditable artifacts
- bridge generation becomes an end-to-end workflow instead of just file emission helpers

### 5. Rebuild the formal model around the same bounded slice

Required outcome:
- Coq proofs line up with the live subsystem rather than a broad umbrella thesis
- theorem depth shifts from config-validity emphasis toward workflow and state-transition soundness

### 6. Add executable workflows and negative cases

Required outcome:
- at least one valid mobile workflow executes end-to-end through the toolchain
- at least one invalid or adversarial workflow is rejected

## Execution Order

1. Reduce wording to the bounded `R2` claim.
2. Split the umbrella into child domains.
3. Build `RIINA_MOBILE_OS_MOBILE_BRIDGES` as the first serious live slice.
4. Rework the formal proof depth around that slice.
5. Add valid and invalid mobile workflows.
6. Re-audit `RIINA_MOBILE_OS_MOBILE_BRIDGES`.
7. Re-audit the umbrella only after multiple child domains become real.

## Exit Criteria

`RIINA_MOBILE_OS` may not move above `R2` until:
- the umbrella is decomposed into bounded child domains
- one child domain reaches a stronger audited level with executable evidence
- secondary lanes stop inflating confidence
- public wording matches the bounded live state
