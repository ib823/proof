# RIINA Verification Manifest
**Generated:** 2026-02-12T15:22:14Z
**Git SHA:** 96b1f327
**Status:** FAIL

| Check | Status | Details |
|-------|--------|---------|
| Rust Tests | PASS | 856 tests |
| Clippy | PASS | 0 warnings |
| _CoqProject Completeness | PASS | all 244 .v files listed in _CoqProject |
| Coq Compilation | PASS | 146 .vo files compiled in 1459s |
| Coq Admits | FAIL | 3 (target: 1) |
| Coq Axioms | PASS | 4 (informational; explicit assumptions tracked separately) |
| Coq Explicit Step-Up Assumption | PASS | 0 (target: 0; Parameter val_rel_n_step_up) |
| Lean 4 Compilation | PASS | Built in 38s (0 sorry warnings) |
| Lean sorry Scan | WARN | 5392 actionable sorry (+0 generated fallback stubs) in 256 files (7933 theorems/lemmas) |
| Isabelle Compilation | FAIL | FAILED (exit 143, 256s, local_core)
 |
| Isabelle sorry/oops | PASS | 0 sorry + 0 oops in 261 files (7441 lemmas) |
| F* admit Scan | PASS | 0 admit in 252 files (216 lemmas) |
| TLA+ Scan | PASS | 251 files (7928 theorems) |
| Alloy Scan | PASS | 251 files (15856 assertions) |
| SMT Scan | PASS | 251 files (7928 assertions) |
| Verus admit Scan | FAIL | 11 admit in 255 files (1552 proof fns) |
| Kani Scan | PASS | 252 files (1531 harnesses) |
| TV Scan | PASS | 251 files (11688 validations) |
| Cross-Prover Validation (10 provers) | PASS | Grand total: 70458 | Coq: 7748 | Lean: 7933 | Isabelle: 8078 | F*: 216 | TLA+: 7928 | Alloy: 15856 | SMT: 7928 | Verus: 1552 | Kani: 1531 | TV: 11688 | Parity: OK |
| Transpiler Staleness | PASS | all transpiler lanes are generated/non-compiled per metrics; freshness check skipped |
| Metrics Accuracy | FAIL | DRIFT: Admitted in metrics.json: 2 (must be <= 1) |
