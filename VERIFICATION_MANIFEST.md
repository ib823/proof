# RIINA Verification Manifest
**Generated:** 2026-10-21T01:58:38Z
**Git SHA:** fe3b97fa2
**Mode:** full
**Status:** PASS

> Scope: Rust + primary proof lane (Coq). Fails closed if the Coq toolchain is absent.

| Check | Status | Details |
|-------|--------|---------|
| Rust Tests | PASS | 3648 tests |
| Clippy | PASS | 0 warnings |
| _CoqProject Completeness | PASS | all 335 .v files listed in _CoqProject |
| Coq Compilation | PASS | 335 .vo files compiled in 169s; 0 warning(s) (budget 2) |
| Coq Kernel Assumptions | PASS | 10 capstones attested (9 unconditional, 9 axiom-free); axioms within reviewed whitelist (1 allowed: funext); well_typed_SN CONDITIONAL on 4 section premise(s) [env_reducible_closed, lambda_body_SN, store_values_are_values, stores_recursion_free] (REQ-84: section premises are refutable and the conclusion is false for the full calculus (well_typed_SN_conclusion_is_false, Landin's knot) — vacuous; the premise-free guarantee is ref_free_well_typed_SN) |
| Core Conformance (REQ-111) | PASS | 27 programs compared with Coq's type_check_fn: 15 both accept, 12 both reject, 0 soundness discrepancies, 0 type/effect mismatches, 0 completeness gaps (0 tracked); 116 programs outside the core (first constructs: Expr::BinOp 28, Ty::Any 17, Builtins 15, Expr::LetMut 15), 0 not compared, 55 unparsed; expr constructors exercised 26/27 (not: ELoc); planted controls caught |
| Coq Admits | PASS | 0 (target: 0) |
| Coq Axioms | PASS | 0 (target: 0) |
| Coq Aborts | PASS | 0 (target: 0) |
| Coq Kernel-Weakening Constructs | PASS | 0 (Conjecture, give_up, Admit Obligations, bypass_check, Unset Guard/Positivity/Universe Checking) |
| Coq Explicit Step-Up Assumption | PASS | 0 (target: 0; Parameter val_rel_n_step_up) |
| Lean 4 Compilation | WARN | no Lean sources: the generated corpus was archived out of main on 2026-10-20 (owner ruling D6; preserved at commit fd23fbdb8). Nothing is verified in this lane |
| Lean sorry Scan | WARN | no Lean sources: the generated corpus was archived out of main on 2026-10-20 (owner ruling D6; preserved at commit fd23fbdb8). Nothing is verified in this lane |
| Isabelle Compilation | WARN | ROOT file not found in isabelle/RIINA/ |
| Isabelle sorry/oops | WARN | no Isabelle sources: the generated corpus was archived out of main on 2026-10-20 (owner ruling D6; preserved at commit fd23fbdb8). Nothing is verified in this lane |
| F* Compilation | WARN | pinned local F* not found (run: bash scripts/provision-smoke-toolchains.sh or bash scripts/provision-fstar.sh) |
| F* admit Scan | PASS | 0 admit in 1 files (0 lemmas) |
| TLA+ Compilation | PASS | Active spec TelusProcurementProtocol parsed and model checked in 1s (5 theorems, local_active) |
| TLA+ Scan | PASS | 3 files (15 theorems) |
| Alloy Compilation | PASS | Active model TelusProcurementAccessControl executed in 6s (6 checked assertions, local_active) |
| Alloy Scan | PASS | 3 files (25 assertions) |
| SMT Scan | PASS | 4 files (149 assertions) |
| Verus admit Scan | PASS | 0 admit in 1 files (4 proof fns) |
| Kani Scan | PASS | 3 files (25 harnesses) |
| TV Scan | PASS | 2 files (34 validations) |
| Prover Corpus Inventory (raw counts, not verification) | PASS | Raw declaration counts of the non-Coq lanes: internal, NOT summed, not proofs (Coq's three published numbers are in the Metrics Accuracy row). Lean: 0 | Isabelle: 0 | F*: 0 | TLA+: 15 | Alloy: 25 | SMT: 149 | Verus: 4 | Kani: 25 | TV: 34 |
| Transpiler Staleness | WARN | 1 prover(s) may be stale: SMT — re-check the hand-written lane files against the Coq change with the lane's own gate (scripts/verify-smt.sh for SMT); do NOT run the generate-*.py transpilers, whose output was archived under ruling D6 (checked: SMT; skipped generated/non-compiled: Lean, Isabelle, F*, TLA+, Alloy, Verus, Kani, TV) |
| Metrics Accuracy | PASS | metrics.json matches live counts (Coq: 1679 core / 9719 model / 1443 excluded Qed, partition checked; Lean=0, Isabelle=0, Admitted=0, Axioms=0) |
| Primary Verifier (Coq) Present | PASS | Coq/Rocq prover available at /root/.opam/rocq/bin/rocq |
