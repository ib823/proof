# A_TYPE_THEORY Remediation Plan v1.0.0

## Purpose

Turn `A_TYPE_THEORY` from a broad research umbrella plus real but bounded core implementation into an honestly scoped family of child domains.

## Current Truth

As of [A_TYPE_THEORY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/A_TYPE_THEORY_R5_AUDIT.md) and [A_TYPE_THEORY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/A_TYPE_THEORY_R5_REVIEW.md):
- `A_TYPE_THEORY` is `R2`
- core Coq metatheory is real and nontrivial
- the live compiler enforces a bounded core subset
- canonical example files for the umbrella are stale or broken
- non-Coq lanes are generated, derived, or vacuous
- the 20-session research umbrella is broader than the live implementation

## Governing Rule

The umbrella may not be claimed above the weakest live link. Today that weakest link is the mismatch between the 20 research branches and the bounded core subset the compiler actually enforces.

## Non-Negotiable Remediation Principles

1. The umbrella must be split before it can move upward honestly.
2. `A_TYPE_THEORY_CORE` is the first serious child-domain target.
3. Broken canonical examples invalidate stronger executable claims.
4. Generated, derived, or vacuous non-Coq lanes do not count as independent evidence.
5. Formal modeling of advanced branches is not the same as live implementation.

## Required Strategic Shift

### 1. Freeze the umbrella claim surface

Required outcome:
- the umbrella stays at the reviewer-safe `R2` wording
- no `R3` wording is used for the umbrella as a whole

### 2. Split the umbrella into child domains

Required outcome:
- separate the live core type subsystem from dependent, refinement, gradual, region, higher-kinded, and other research-only branches
- stop implying that every research branch shares the same maturity level

### 3. Choose the first flagship vertical

Required outcome:
- start with `A_TYPE_THEORY_CORE`
- keep advanced research branches out of the first `R5`

### 4. Repair executable evidence

Required outcome:
- fix or replace failing canonical examples
- ensure the bounded child domain has stable positive and negative end-to-end workflows

### 5. Rebuild honesty around non-Coq lanes

Required outcome:
- generated/vacuous ports are excluded from strong current-state assurance claims
- real independent lanes, if desired, must be manually deepened later

## Execution Order

1. Reduce public wording to the core-subsystem claim.
2. Split the umbrella into child domains.
3. Repair the example corpus for the core subset.
4. Promote `A_TYPE_THEORY_CORE` as the first serious live target.
5. Re-audit the child domain.
6. Revisit the umbrella only after multiple child domains mature.

## Exit Criteria

`A_TYPE_THEORY` may not move above `R2` until:
- the umbrella is decomposed honestly
- `A_TYPE_THEORY_CORE` or another bounded child domain is re-audited at a higher level
- canonical examples are stable
- generated/vacuous non-Coq lanes stop inflating confidence
