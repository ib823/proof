# Y_VERIFIED_STDLIB Remediation Plan

## Phase 1: Audit Repair (immediate)
1. Correct implementation mapping to riina-codegen builtins/platform + riina-typechecker
2. Include StandardLibrary.v and PlatformStdlibVerification.v in evidence review
3. Write definitive Y vs P boundary statement
4. Add generated-lane disclaimers for non-Coq files
5. Commit audit artifact from clean tree

## Phase 2: Formal Model Improvement
1. Address vacuous theorems in Y001_VerifiedStdlib.v (lines 546, 584, 610, 619, 628, 664, 679)
2. Strengthen properties to have non-trivial proof content
3. Add per-builtin-family row mapping: research claim -> Coq theorem -> Rust impl -> typing -> tests

## Phase 3: Toolchain Enforcement (R2 -> R3)
1. Replace `Ty::Fn(Any, Any, Pure)` with precise types for all 5 builtin families
2. Ensure `riinac check` rejects malformed builtin calls at compile time
3. Add negative tests for each builtin family with wrong argument types
4. Show one complete theorem-to-implementation trace for a live builtin
5. Separate compile-time vs runtime rejection and document both

## Dependencies
- Coordinate with P_STANDARD_LIBRARY remediation for boundary resolution
