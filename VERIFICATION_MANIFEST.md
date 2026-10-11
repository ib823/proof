# RIINA Verification Manifest
**Generated:** 2026-10-11T12:17:08Z
**Git SHA:** cba3cde
**Mode:** full
**Status:** PASS

> Scope: Rust + primary proof lane (Coq). Fails closed if the Coq toolchain is absent.

| Check | Status | Details |
|-------|--------|---------|
| Rust Tests | PASS | 3383 tests |
| Clippy | PASS | 0 warnings |
| _CoqProject Completeness | PASS | all 331 .v files listed in _CoqProject |
| Coq Compilation | PASS | 331 .vo files compiled in 237s; 0 warning(s) (budget 2) |
| Coq Kernel Assumptions | PASS | 5 capstones attested (4 unconditional); axioms within reviewed whitelist (1 allowed: funext); well_typed_SN CONDITIONAL on 4 section premise(s) [env_reducible_closed, lambda_body_SN, store_values_are_values, stores_recursion_free] (REQ-84: section premises are refutable — the theorem is vacuous until they are restated over well-formed stores and discharged) |
| Coq Admits | PASS | 0 (target: 0) |
| Coq Axioms | PASS | 0 (target: 0) |
| Coq Aborts | PASS | 0 (target: 0) |
| Coq Kernel-Weakening Constructs | PASS | 0 (Conjecture, give_up, Admit Obligations, bypass_check, Unset Guard/Positivity/Universe Checking) |
| Coq Explicit Step-Up Assumption | PASS | 0 (target: 0; Parameter val_rel_n_step_up) |
| Lean 4 Compilation | WARN | SKIPPED (lake not found (install elan / Lean 4)). Verification INCOMPLETE |
| Lean sorry Scan | PASS | 0 actionable sorry (+0 generated fallback stubs) in 326 files (12576 theorems/lemmas) |
| Isabelle Compilation | WARN | pinned local Isabelle not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-isabelle.sh) |
| Isabelle sorry/oops | PASS | 0 sorry + 0 oops in 368 files (12925 lemmas) |
| F* Compilation | WARN | pinned local F* not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-fstar.sh) |
| F* admit Scan | WARN | 12012 admit in 315 files (19 lemmas) |
| TLA+ Compilation | WARN | pinned local TLA2Tools jar not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-formal-tools.sh) |
| TLA+ Scan | PASS | 317 files (12284 theorems) |
| Alloy Compilation | WARN | pinned local Alloy jar not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-formal-tools.sh) |
| Alloy Scan | PASS | 306 files (11627 assertions) |
| SMT Scan | PASS | 318 files (12433 assertions) |
| Verus admit Scan | PASS | 0 admit in 323 files (6395 proof fns) |
| Kani Scan | PASS | 307 files (5664 harnesses) |
| TV Scan | PASS | 316 files (17463 validations) |
| Cross-Prover Validation (10 provers) | PASS | Grand total: 104571 | Coq: 12682 | Lean: 12576 | Isabelle: 12931 | F*: 516 | TLA+: 12284 | Alloy: 11627 | SMT: 12433 | Verus: 6395 | Kani: 5664 | TV: 17463 | Parity: OK |
| Transpiler Staleness | WARN | 1 prover(s) may be stale: SMT — run `python3 scripts/generate-full-stack.py` (checked: SMT; skipped generated/non-compiled: Lean, Isabelle, F*, TLA+, Alloy, Verus, Kani, TV) |
| Metrics Accuracy | PASS | metrics.json matches live counts (Qed=12682, Lean=12576, Isabelle=12931, Admitted=0, Axioms=0) |
| Primary Verifier (Coq) Present | PASS | Coq/Rocq prover available at /root/.opam/rocq/bin/rocq |
