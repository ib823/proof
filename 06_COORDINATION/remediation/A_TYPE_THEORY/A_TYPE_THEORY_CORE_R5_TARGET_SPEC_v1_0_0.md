# A_TYPE_THEORY_CORE R5 Target Spec v1.0.0

## Purpose

Take the strongest live type-theory slice in RIINA and turn it into an honest `R5` child domain.

Chosen child domain:
- `A_TYPE_THEORY_CORE`

Why this child domain first:
- real Coq metatheory already exists
- real parser/typechecker enforcement already exists
- invalid covered cases are already rejected by the live toolchain
- the main blockers are scope discipline and executable-example quality, not total absence of implementation

## Current Truth

Live source today:
- [Syntax.v](/workspaces/proof/02_FORMAL/coq/foundations/Syntax.v)
- [Typing.v](/workspaces/proof/02_FORMAL/coq/foundations/Typing.v)
- [Progress.v](/workspaces/proof/02_FORMAL/coq/type_system/Progress.v)
- [Preservation.v](/workspaces/proof/02_FORMAL/coq/type_system/Preservation.v)
- [TypeSafety.v](/workspaces/proof/02_FORMAL/coq/type_system/TypeSafety.v)
- [lib.rs](/workspaces/proof/03_PROTO/crates/riina-types/src/lib.rs)
- [lib.rs](/workspaces/proof/03_PROTO/crates/riina-parser/src/lib.rs)
- [lib.rs](/workspaces/proof/03_PROTO/crates/riina-typechecker/src/lib.rs)
- [main.rs](/workspaces/proof/03_PROTO/crates/riinac/src/main.rs)

Current strengths:
- real metatheory
- real parser and typechecker
- real negative tests
- bounded ad hoc positive and negative workflows

Current weaknesses:
- canonical example corpus for the covered subset is stale
- non-Coq lanes are not trustworthy as independent evidence
- the current umbrella still blurs the core subset with research-only branches

## Scope

### In scope

- core syntax and typing
- effects
- security labels
- linearity qualifiers
- capability-gated checking
- basic session-type constructs already enforced in the live toolchain
- positive and negative workflows for the covered subset

### Out of scope for the first `R5`

- dependent types
- refinement types
- gradual typing
- region types
- higher-kinded types
- type-level computation
- any branch that is formal-only or research-only today

## Required Workflows

| Workflow | Valid or forbidden | Must exist by `R5` |
|----------|--------------------|--------------------|
| Parse and typecheck a covered valid program | Valid | Yes |
| Reject a covered type mismatch | Forbidden | Yes |
| Reject a covered linearity violation | Forbidden | Yes |
| Reject a covered security-level violation | Forbidden | Yes |
| Reject a covered capability violation | Forbidden | Yes |
| Reject a covered session-type violation | Forbidden | Yes |
| Run canonical passing examples for the covered subset | Valid | Yes |

## Required Properties

1. Covered well-typed programs are not stuck under the modeled core semantics.
2. Covered invalid programs are rejected by the live toolchain.
3. Effects are constrained to the covered effect model.
4. Covered security-level and linearity checks are enforced.
5. Capability-gated covered workflows fail closed.

## Required Formal Artifacts

Minimum Coq targets:
- keep the current core metatheory active and mapped to the live subset
- add any missing explicit theorem-to-feature mapping needed for the child-domain scope

Minimum standard:
- hostile review must not be able to say the formal model exceeds the claimed live subset

## Required Implementation Artifacts

1. Repair or replace failing canonical example files.
2. Ensure the canonical core examples use current accepted syntax.
3. Add explicit child-domain smoke commands to the evidence pack.
4. Keep advanced branches out of the child-domain claim.

## Required Tests

Positive:
- canonical core syntax example
- canonical effects example
- canonical security example

Negative:
- type mismatch
- linearity violation
- security-level violation
- capability violation

Adversarial:
- regression tests for any previously failing or misparsed example
- regression tests for any previously accepted invalid program

## Exit Criteria

`A_TYPE_THEORY_CORE` is ready for re-audit when:
- scope is explicit
- canonical examples pass
- negative workflows are stable
- public wording is exact
- generated/vacuous non-Coq lanes are not used as strong confidence multipliers
- the child domain survives hostile review
