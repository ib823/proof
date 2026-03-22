# D_HARDWARE_AND_CAPABILITY_SECURITY Remediation Plan v1.0.0

## Purpose

Rebuild `D_HARDWARE_AND_CAPABILITY_SECURITY` from its R1 state after the hostile review revealed that all 255 Coq theorems are vacuous. This domain requires fundamental reconstruction, not incremental improvement.

## Current Truth

As of [D_HARDWARE_AND_CAPABILITY_SECURITY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/D_HARDWARE_AND_CAPABILITY_SECURITY_R5_AUDIT.md) and [D_HARDWARE_AND_CAPABILITY_SECURITY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/D_HARDWARE_AND_CAPABILITY_SECURITY_R5_REVIEW.md):
- `D_HARDWARE_AND_CAPABILITY_SECURITY` is `R1` (downgraded from R2 by hostile review)
- Hostile review verdict: **reject**
- All 255 Coq theorems are vacuous:
  - `HardwareSecurity.v`: 34 theorems prove `True` via `trivial.`
  - `CapabilitySecurity.v`: 108 theorems prove `true = true` via `reflexivity.` on hardcoded boolean fields
  - `TerasCapabilities.v`, `S001_HardwareContracts.v`, `VerifiedHardware.v`: same pattern
- The domain has research specification only (R1 level)
- No real formal model, no toolchain enforcement, no executable evidence
- Scope is excessively broad: hardware attacks + software capabilities + CHERI + TERAS OS

## Governing Rules

1. A theorem that proves `True` or `reflexivity` on a hardcoded boolean has zero informational content. It does not count as a formal property regardless of syntactic validity.
2. Scope must be bounded to an implementable subset before any upward movement. The current umbrella (hardware attacks + software capabilities + CHERI + TERAS OS) is too broad for honest enforcement claims.
3. Vacuous proofs must be replaced, not patched — the entire proof architecture in this domain is compromised.
4. This domain's failure established a methodology lesson: Qed count without proof body inspection is insufficient.

## Required Structural Changes

### 1. Bound scope to implementable subset

Choose ONE of:
- **Option A:** Software capability enforcement (unforgability, monotonicity, delegation, revocation)
- **Option B:** Microarchitectural attack mitigation properties (speculative execution, cache timing, power analysis)
- **Option C:** CHERI-style hardware capability model

Option A is recommended — it aligns with the existing typechecker architecture and can share infrastructure with the effect system capability model.

### 2. Rewrite Coq proofs with nontrivial properties

Replace all vacuous theorems with properties that:
- Could fail if definitions changed
- Reference hypothesis variables in their conclusions
- Prove relationships between inputs and outputs, not tautologies

### 3. Build enforcement pathway

After nontrivial proofs exist, plan the enforcement pathway: typechecker rules, runtime checks, or codegen properties that correspond to the formal model.

## Per-Gate Remediation Steps

### R1 -> R2

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G2 | Fail | Bound scope to implementable subset | Scope document | Single bounded scope with explicit exclusions |
| G3 | Fail | Write workflow inventory for bounded scope | Workflow document | Each workflow maps to at least one formal property |
| G6 | Fail | Rewrite Coq proofs with nontrivial properties | Rewritten `.v` files | No theorem concludes with `True` or proves `reflexivity` on hardcoded fields |

### R2 -> R3

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G7 | Fail | Implement enforcement in typechecker or runtime | Rust enforcement code | At least one formal property is enforced at compile or runtime |
| G8 | Fail | Create `.rii` examples demonstrating capabilities | Example files + integration tests | Examples pass parse + typecheck |
| G9 | Fail | Add adversarial tests | Negative test cases | Invalid capability operations are rejected |

## Exit Criteria

`D_HARDWARE_AND_CAPABILITY_SECURITY` may not claim R2 until:
- Scope is bounded to a single implementable subset
- All vacuous Coq theorems are replaced with nontrivial properties
- Workflow inventory exists for the bounded scope
- Re-audit confirms nontriviality (vacuity detection tool should be used)
