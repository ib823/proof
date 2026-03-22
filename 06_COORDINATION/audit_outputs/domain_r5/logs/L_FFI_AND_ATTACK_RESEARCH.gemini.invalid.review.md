# Domain Audit Review

## 1. Verdict
**Verdict: accept with reductions**

## 2. Snapshot validation
- Branch: `main`
- Commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Review valid for this snapshot: Yes
- Drift: Materially harmless (only uncommitted audit docs and scripts present)

## 3. Maximum honest rating
**R2** (Implementation is real and heavily tested; Coq layer is 100% vacuous)

## 4. Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| `G1` | Pass | Pass | Agree | Research folder exists. | None |
| `G2` | Partial | Partial | Agree | Combined domain covering FFI and broad attack research. | None |
| `G3` | Partial | Partial | Agree | Implementation workflows tested; attack research lacks live enforcement. | None |
| `G4` | Partial | Partial | Agree | No unified threat model document. | None |
| `G5` | Partial | Fail | Downgrade | Coq properties are 100% boolean stubs, providing zero formal modeling of the actual FFI AST or compiler implementation. | Downgrade to Fail. |
| `G6` | Fail (provisional) | Fail | Confirm | Both `RustFFISecurity.v` and `FFIAttackResearch.v` are entirely vacuous boolean properties proven by reflexivity. | Confirm Fail. |
| `G7` | Pass | Pass | Agree | Real extern block parsing, raw pointer types, and extensive C/WASM/JNI/Swift codegen implemented. | None |
| `G8` | Pass | Pass | Corrected (Upward) | The audit claimed 153 tests, but `cargo test -p riina-codegen` runs 451 unit tests and 41 wasm_e2e tests. | Update test count. |
| `G9` | Partial | Partial | Agree | No explicit FFI boundary attack tests in the repo. | None |
| `G10` | Pass | Pass | Agree | Vacuity was mostly flagged proactively by the auditor. | None |
| `G11` | Partial | Fail | Downgrade | Implementation evidence is strong, but the trace to the formal layer is completely nonexistent due to total vacuity. | Downgrade to Fail. |
| `G12` | Pass | Pass | Agree | Command-derived checks pass. | None |
| `G13` | Not audited | Not audited | Agree | | None |
| `G14` | Partial | Partial | Agree | Hook-gated structure is incomplete. | None |

## 5. Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| High | G5, G6, G11 | `RustFFISecurity.v` and `FFIAttackResearch.v` are "likely" or "mixed" boolean stubs | Both files are 100% vacuous. They define records of booleans and trivial size counts, proven entirely by `reflexivity`. There is no actual theorem content. | Downgrade G5 and G11 to Fail; Confirm G6 Fail. |
| Low | G8 | "153 codegen tests" | `cargo test` reveals 451 unit tests in `riina-codegen` and 41 tests in `wasm_e2e`. The audit significantly undercounted the implementation strength. | Correct the test count upward in public claims. |

## 6. Overclaim lines
- "RustFFISecurity.v: ... 79% reflexivity — likely boolean stubs" (It is 100% vacuous)
- "FFIAttackResearch.v: ... 50% reflexivity — mixed" (It is also 100% vacuous)
- "G5 Partial: Coq properties likely vacuous" (Should be Fail)
- "G11 Partial: Implementation evidence strong, Coq trace likely broken" (Trace is definitively broken, should be Fail)

## 7. Missed evidence lines
- The implementation is substantially stronger than audited: it possesses over 490 codegen and end-to-end WASM tests, not just 153.

## 8. Safe claim
"FFI with extern block parsing, raw pointer types, and multi-target codegen (C, WASM, JNI, Swift) implemented and heavily tested (490+ tests), accompanied by research-level attack taxonomy."

## 9. Unsafe claim
"FFI formally verified", "FFI safety mathematically proven in Coq", "Attack-resistant FFI verified."

## 10. Release condition
Domain safely retains an R2 rating based on the excellent implementation layer. To claim R3, the vacuous Coq files must be deleted or completely rewritten to perform structural, non-boolean proofs over the actual FFI boundary semantics.

## 11. Next review advice
Delete `RustFFISecurity.v` and `FFIAttackResearch.v` as they add no value, skew metrics, and present a risk of being mistaken for real proofs. Maintain the R2 rating based on the highly verified implementation and robust codegen test suite.