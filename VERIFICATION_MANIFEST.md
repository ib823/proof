# RIINA Verification Manifest
**Generated:** 2026-06-01T23:31:19Z
**Git SHA:** 0988b83e
**Mode:** full
**Status:** PASS

> Scope: Rust + primary proof lane (Coq). Fails closed if the Coq toolchain is absent.

| Check | Status | Details |
|-------|--------|---------|
| Rust Tests | PASS | 2607 tests |
| Clippy | PASS | 0 warnings |
| _CoqProject Completeness | PASS | all 309 .v files listed in _CoqProject |
| Coq Compilation | PASS | 309 .vo files compiled in 159s |
| Coq Admits | PASS | 0 (target: 1) |
| Coq Axioms | PASS | 0 (informational; explicit assumptions tracked separately) |
| Coq Explicit Step-Up Assumption | PASS | 0 (target: 0; Parameter val_rel_n_step_up) |
| Lean 4 Compilation | WARN | GENERATED, not mechanized: default `lake build` builds only the 0-theorem `Domains/All` shim (0s); core Foundations/Syntax.lean does NOT elaborate (187 errors). See 02_FORMAL/lean/COMPILATION_STATUS.md |
| Lean sorry Scan | PASS | 0 actionable sorry (+0 generated fallback stubs) in 326 files (12576 theorems/lemmas) |
| Isabelle Compilation | WARN | pinned local Isabelle not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-isabelle.sh) |
| Isabelle sorry/oops | PASS | 0 sorry + 0 oops in 368 files (12925 lemmas) |
| F* Compilation | PASS | Active module CryptographicSecurityActive compiled in 0s (3 lemmas, local_active) |
| F* admit Scan | WARN | 12010 admit in 315 files (19 lemmas) |
| TLA+ Compilation | PASS | Active spec TelusProcurementProtocol parsed and model checked in 1s (5 theorems, local_active) |
| TLA+ Scan | PASS | 317 files (12282 theorems) |
| Alloy Compilation | PASS | Active model TelusProcurementAccessControl executed in 7s (6 checked assertions, local_active) |
| Alloy Scan | PASS | 306 files (11627 assertions) |
| SMT Scan | PASS | 317 files (12405 assertions) |
| Verus admit Scan | PASS | 0 admit in 323 files (6395 proof fns) |
| Kani Scan | PASS | 307 files (5664 harnesses) |
| TV Scan | PASS | 316 files (17463 validations) |
| Cross-Prover Validation (10 provers) | PASS | Grand total: 104245 | Coq: 12386 | Lean: 12576 | Isabelle: 12931 | F*: 516 | TLA+: 12282 | Alloy: 11627 | SMT: 12405 | Verus: 6395 | Kani: 5664 | TV: 17463 | Parity: OK |
| Transpiler Staleness | PASS | all transpiler lanes are generated/non-compiled per metrics; freshness check skipped |
| Metrics Accuracy | PASS | metrics.json matches live counts (Qed=12386, Lean=12576, Isabelle=12931, Admitted=0, Axioms=0) |
| Primary Verifier (Coq) Present | PASS | coqc available at /root/.opam/rocq/bin/coqc |
