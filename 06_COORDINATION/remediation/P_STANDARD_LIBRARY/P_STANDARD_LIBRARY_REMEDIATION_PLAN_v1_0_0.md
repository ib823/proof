# P_STANDARD_LIBRARY Remediation Plan v1.0.0

## Purpose

Bridge the gap between shallow Coq functional models and the real Malay-localized Rust builtins to achieve R3 (Enforced Subsystem).

## Current Truth

As of [P_STANDARD_LIBRARY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/P_STANDARD_LIBRARY_R5_AUDIT.md) and [P_STANDARD_LIBRARY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/P_STANDARD_LIBRARY_R5_REVIEW.md):
- `P_STANDARD_LIBRARY` is `R2`
- Coq proofs are shallow (reflexivity over functional models, mathematically sound but not deep)
- 2 legitimate monad-law proofs use `destruct m; reflexivity` (valid for sum types)
- Real implementation in `riina-codegen/src/builtins/` with Malay names (`senarai`, `peta`, `teks`)
- No formal linkage between Coq English types and Rust Malay builtins
- Hostile review accepted R2 with terminology and location corrections

## Governing Rules

1. Shallow reflexivity proofs are mathematically sound but insufficient for R3 depth.
2. A formal-to-implementation mapping must be explicit and verifiable, not implied.
3. The Coq-to-Rust gap (English vs Malay naming) must be bridged formally or documented as a known limitation.

## Required Structural Changes

### 1. Formal-to-implementation mapping

The Coq models use English names (`Vec`, `HashMap`, `Option`). The Rust builtins use Malay names (`senarai`, `peta`, `pilihan`). Create an explicit translation table and, ideally, Kani or Verus harnesses that formally link the two layers.

### 2. Deepen formal evidence

Add inductive proofs for core stdlib properties: List append associativity, Map insert/lookup round-trip, Option bind associativity. These must require more than reflexivity.

### 3. Correct audit evidence locations

Update all references from `riina-types` to `riina-codegen/src/builtins/` as the canonical stdlib implementation location.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G4 | Fail | Create formal-to-implementation mapping | Translation table or Kani harnesses | Every Coq model links to its Rust builtin |
| G5 | Shallow | Add inductive proofs for core properties | `StandardLibrary.v` additions | At least 5 non-reflexivity proofs |
| G13 | Fail | Fix evidence location references | Audit document update | All references point to `riina-codegen/src/builtins/` |

## Exit Criteria

`P_STANDARD_LIBRARY` may not claim R3 until:
- Formal-to-implementation mapping exists and is verifiable
- At least 5 Coq proofs require induction or case analysis
- All audit references point to correct implementation locations
- Re-audit confirms all gates pass
