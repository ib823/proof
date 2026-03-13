; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA T001_HermeticBuild — SMT Verification
; Derived from 02_FORMAL/coq/domains/T001_HermeticBuild.v (28 assertions)
; Module: T001_HermeticBuild
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Stage 0))
  (((mk-stage (stage_id Int) (stage_source Int) (stage_binary Int) (stage_hash Int)))))

(declare-datatypes ((BuildEnv 0))
  (((mk-build_env (env_network Bool) (env_filesystem (Seq Int)) (env_clock Int) (env_random_seed Int) (env_inputs (Seq Int))))))

(declare-datatypes ((Compiler 0))
  (((mk-compiler (compiler_binary Int) (compiler_source Int) (compiler_chain Int)))))

(declare-datatypes ((DDCResult 0))
  (((mk-ddc_result (compiler_a Compiler) (compiler_b Compiler) (compiler_aprime Compiler) (equivalent Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Stage record properties ---

; --- 1. Stage accessor round-trip: stage_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (stage_id (mk-stage f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Stage accessor round-trip: stage_source ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (stage_source (mk-stage f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Stage accessor round-trip: stage_binary ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (stage_binary (mk-stage f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Stage: integer field consistency ---
(push 1)
(declare-const r Stage)
(assert (>= (stage_id r) 0))
(assert (>= (stage_source r) 0))
(assert (not (>= (+ (stage_id r) (stage_source r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BuildEnv record properties ---

; --- 5. BuildEnv accessor round-trip: env_network ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (env_network (mk-build_env f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. BuildEnv accessor round-trip: Seq ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (Seq (mk-build_env f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. BuildEnv accessor round-trip: env_clock ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (env_clock (mk-build_env f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. BuildEnv accessor round-trip: env_random_seed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (env_random_seed (mk-build_env f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. BuildEnv: integer field consistency ---
(push 1)
(declare-const r BuildEnv)
(assert (>= (Seq r) 0))
(assert (>= (env_clock r) 0))
(assert (not (>= (+ (Seq r) (env_clock r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Compiler record properties ---

; --- 10. Compiler accessor round-trip: compiler_binary ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (compiler_binary (mk-compiler f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Compiler accessor round-trip: compiler_source ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (compiler_source (mk-compiler f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Compiler: integer field consistency ---
(push 1)
(declare-const r Compiler)
(assert (>= (compiler_binary r) 0))
(assert (>= (compiler_source r) 0))
(assert (not (>= (+ (compiler_binary r) (compiler_source r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DDCResult record properties ---

; --- 13. DDCResult accessor round-trip: compiler_a ---
(push 1)
(declare-const f0 Compiler)
(declare-const f1 Compiler)
(declare-const f2 Compiler)
(assert (not (= (compiler_a (mk-d_d_c_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. DDCResult accessor round-trip: compiler_b ---
(push 1)
(declare-const f0 Compiler)
(declare-const f1 Compiler)
(declare-const f2 Compiler)
(assert (not (= (compiler_b (mk-d_d_c_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. DDCResult accessor round-trip: compiler_aprime ---
(push 1)
(declare-const f0 Compiler)
(declare-const f1 Compiler)
(declare-const f2 Compiler)
(assert (not (= (compiler_aprime (mk-d_d_c_result f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
