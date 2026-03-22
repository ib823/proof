# T_HERMETIC_BUILD Remediation Plan v1.0.0

## Purpose

Replace the identity-function formal model with real build semantics and add hermeticity enforcement to the package system to reach R2.

## Current Truth

As of [T_HERMETIC_BUILD_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/T_HERMETIC_BUILD_R5_AUDIT.md) and [T_HERMETIC_BUILD_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/T_HERMETIC_BUILD_R5_REVIEW.md):
- `T_HERMETIC_BUILD` is `R1` (downgraded from R2 by hostile review)
- Coq: definitions are identity functions (`source_semantics src := src`, `compile binary src := src`)
- All proofs are tautologies regardless of reflexivity percentage
- "hermetic" does not appear once in `03_PROTO`
- riina-pkg has 54 tests but none test hermetic properties
- Alloy model is auto-generated from vacuous Coq (not independent evidence)
- Original audit overclaimed "Coq has real proofs (35% reflexivity)"

## Governing Rules

1. Identity-function definitions make all dependent proofs trivially true regardless of the proof tactic used.
2. The reflexivity percentage metric is meaningless when the underlying definitions are tautological.
3. Auto-generated prover files from vacuous models do not count as independent evidence.
4. Generic package manager tests do not constitute hermetic build evidence.

## Required Structural Changes

### 1. Rewrite Coq formal model

The definitions `source_semantics src := src` and `compile binary src := src` must be replaced with models that capture the actual semantic gap between source, compiled binary, and execution environment. A hermetic build model must at minimum distinguish:
- Source inputs (code, dependencies)
- Build environment (tools, OS, timestamps)
- Build output (binary, artifacts)
- The property that identical inputs produce identical outputs regardless of environment

### 2. Add hermeticity enforcement

riina-pkg must enforce at least one hermetic build property. Options include:
- Deterministic output hashing (same source = same hash)
- Network isolation during build
- Timestamp normalization
- Dependency pinning with hash verification

### 3. Write independent prover evidence

The Alloy model must be rewritten independently (not auto-generated) once the Coq model is nontrivial.

### 4. Add domain-specific tests

Tests must exercise hermetic properties specifically, not just generic packaging operations.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G5 | Fail | Define real properties | `T001_HermeticBuild.v` | Properties distinguish source from environment |
| G6 | Fail | Rewrite definitions | `T001_HermeticBuild.v` | No identity functions in core definitions |
| G7 | Fail | Add hermeticity enforcement | `riina-pkg` | "hermetic" appears in implementation with logic |
| G8 | Fail | Add hermetic-specific tests | riina-pkg test module | At least 3 tests for hermetic properties |
| G10 | Fail | Rewrite Alloy independently | `T001_HermeticBuild.als` | Not auto-generated; models real properties |
| G13 | Fail | Correct claims | Audit and public wording | No claim implies R2-level evidence |

## Exit Criteria

`T_HERMETIC_BUILD` may not claim R2 until:
- Core Coq definitions are not identity functions
- At least one hermetic build property is enforced in riina-pkg
- At least 3 domain-specific tests exercise hermetic properties
- Alloy model is independently written
- Re-audit confirms all remediated gates pass
