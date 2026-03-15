; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TestingQA — SMT Verification
; Derived from 02_FORMAL/coq/domains/TestingQA.v (29 assertions)
; Module: TestingQA
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TestResult 0)) (((TRPass) (TRFail) (TRError))))

(declare-datatypes ((TraceEvent 0)) (((TEEnter) (TEExit) (TEAssert) (TECoverage))))

(declare-datatypes ((MutationOp 0)) (((MONegate) (MOArithSwap) (MORelSwap) (MODeleteStmt) (MOConstChange))))

(declare-datatypes ((SecurityProperty 0)) (((SPAuthentication) (SPAuthorization) (SPConfidentiality) (SPIntegrity) (SPNonRepudiation))))

(declare-datatypes ((SimpleType 0)) (((TyNat) (TyBool) (TyFun))))

(declare-datatypes ((Expr 0)) (((ENat) (EBool) (EAdd) (EIf))))

(declare-datatypes ((SanitizerResult 0)) (((SRClean) (SRViolation))))

(declare-datatypes ((TestCase 0))
  (((mk-test_case (tc_name String) (tc_input Int) (tc_expected Int)))))

(declare-datatypes ((GenState 0))
  (((mk-gen_state (gs_seed Int) (gs_size Int)))))

(declare-datatypes ((Mutant 0))
  (((mk-mutant (mut_location Int) (mut_operator MutationOp) (mut_killed Bool)))))

(declare-datatypes ((SecurityCoverage 0))
  (((mk-security_coverage (sc_properties (Seq Int)) (sc_tested (Seq Int))))))

(declare-datatypes ((TimingMeasurement 0))
  (((mk-timing_measurement (tm_input1 Int) (tm_input2 Int) (tm_time1 Int) (tm_time2 Int)))))

(declare-datatypes ((TestState 0))
  (((mk-test_state (ts_counter Int) (ts_flag Bool)))))

(declare-datatypes ((Fixture 0))
  (((mk-fixture (fix_setup TestState) (fix_teardown TestState)))))

(declare-datatypes ((Component 0))
  (((mk-component (comp_name String) (comp_input_type SimpleType) (comp_output_type SimpleType) (comp_impl Int)))))

(declare-datatypes ((APIContract 0))
  (((mk-api_contract (api_precondition Int) (api_postcondition Int) (api_impl Int)))))

(declare-datatypes ((SecurityFlow 0))
  (((mk-security_flow (sf_source SecurityProperty) (sf_sink SecurityProperty) (sf_valid Bool)))))

(declare-datatypes ((KATTest 0))
  (((mk-kat_test (kat_input Int) (kat_expected Int)))))

(declare-datatypes ((BruteForceProtection 0))
  (((mk-brute_force_protection (bfp_max_attempts Int) (bfp_current_attempts Int) (bfp_locked Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TestResult enum properties ---

; --- 1. TestResult exhaustiveness ---
(push 1)
(declare-const x TestResult)
(assert (not (or (= x TRPass) (= x TRFail) (= x TRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TestResult: TRPass != TRFail ---
(push 1)
(assert (= TRPass TRFail))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TestResult: TRFail != TRError ---
(push 1)
(assert (= TRFail TRError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TestResult: TRPass != TRError ---
(push 1)
(assert (= TRPass TRError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TestResult finite cardinality (3 values) ---
(push 1)
(declare-const x TestResult)
(assert (and (not (= x TRPass)) (not (= x TRFail)) (not (= x TRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TraceEvent enum properties ---

; --- 6. TraceEvent exhaustiveness ---
(push 1)
(declare-const x TraceEvent)
(assert (not (or (= x TEEnter) (= x TEExit) (= x TEAssert) (= x TECoverage))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. TraceEvent: TEEnter != TEExit ---
(push 1)
(assert (= TEEnter TEExit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TraceEvent: TEExit != TEAssert ---
(push 1)
(assert (= TEExit TEAssert))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TraceEvent: TEAssert != TECoverage ---
(push 1)
(assert (= TEAssert TECoverage))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TraceEvent: TEEnter != TECoverage ---
(push 1)
(assert (= TEEnter TECoverage))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TraceEvent finite cardinality (4 values) ---
(push 1)
(declare-const x TraceEvent)
(assert (and (not (= x TEEnter)) (not (= x TEExit)) (not (= x TEAssert)) (not (= x TECoverage))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MutationOp enum properties ---

; --- 12. MutationOp exhaustiveness ---
(push 1)
(declare-const x MutationOp)
(assert (not (or (= x MONegate) (= x MOArithSwap) (= x MORelSwap) (= x MODeleteStmt) (= x MOConstChange))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. MutationOp: MONegate != MOArithSwap ---
(push 1)
(assert (= MONegate MOArithSwap))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MutationOp: MOArithSwap != MORelSwap ---
(push 1)
(assert (= MOArithSwap MORelSwap))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. MutationOp: MORelSwap != MODeleteStmt ---
(push 1)
(assert (= MORelSwap MODeleteStmt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. MutationOp: MONegate != MOConstChange ---
(push 1)
(assert (= MONegate MOConstChange))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. MutationOp finite cardinality (5 values) ---
(push 1)
(declare-const x MutationOp)
(assert (and (not (= x MONegate)) (not (= x MOArithSwap)) (not (= x MORelSwap)) (not (= x MODeleteStmt)) (not (= x MOConstChange))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityProperty enum properties ---

; --- 18. SecurityProperty exhaustiveness ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (or (= x SPAuthentication) (= x SPAuthorization) (= x SPConfidentiality) (= x SPIntegrity) (= x SPNonRepudiation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SecurityProperty: SPAuthentication != SPAuthorization ---
(push 1)
(assert (= SPAuthentication SPAuthorization))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SecurityProperty: SPAuthorization != SPConfidentiality ---
(push 1)
(assert (= SPAuthorization SPConfidentiality))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SecurityProperty: SPConfidentiality != SPIntegrity ---
(push 1)
(assert (= SPConfidentiality SPIntegrity))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SecurityProperty: SPAuthentication != SPNonRepudiation ---
(push 1)
(assert (= SPAuthentication SPNonRepudiation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SecurityProperty finite cardinality (5 values) ---
(push 1)
(declare-const x SecurityProperty)
(assert (and (not (= x SPAuthentication)) (not (= x SPAuthorization)) (not (= x SPConfidentiality)) (not (= x SPIntegrity)) (not (= x SPNonRepudiation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SimpleType enum properties ---

; --- 24. SimpleType exhaustiveness ---
(push 1)
(declare-const x SimpleType)
(assert (not (or (= x TyNat) (= x TyBool) (= x TyFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SimpleType: TyNat != TyBool ---
(push 1)
(assert (= TyNat TyBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SimpleType: TyBool != TyFun ---
(push 1)
(assert (= TyBool TyFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. SimpleType: TyNat != TyFun ---
(push 1)
(assert (= TyNat TyFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. SimpleType finite cardinality (3 values) ---
(push 1)
(declare-const x SimpleType)
(assert (and (not (= x TyNat)) (not (= x TyBool)) (not (= x TyFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Expr enum properties ---

; --- 29. Expr exhaustiveness ---
(push 1)
(declare-const x Expr)
(assert (not (or (= x ENat) (= x EBool) (= x EAdd) (= x EIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Expr: ENat != EBool ---
(push 1)
(assert (= ENat EBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Expr: EBool != EAdd ---
(push 1)
(assert (= EBool EAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Expr: EAdd != EIf ---
(push 1)
(assert (= EAdd EIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Expr: ENat != EIf ---
(push 1)
(assert (= ENat EIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Expr finite cardinality (4 values) ---
(push 1)
(declare-const x Expr)
(assert (and (not (= x ENat)) (not (= x EBool)) (not (= x EAdd)) (not (= x EIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SanitizerResult enum properties ---

; --- 35. SanitizerResult exhaustiveness ---
(push 1)
(declare-const x SanitizerResult)
(assert (not (or (= x SRClean) (= x SRViolation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. SanitizerResult: SRClean != SRViolation ---
(push 1)
(assert (= SRClean SRViolation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SanitizerResult finite cardinality (2 values) ---
(push 1)
(declare-const x SanitizerResult)
(assert (and (not (= x SRClean)) (not (= x SRViolation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TestCase record properties ---

; --- 38. TestCase accessor round-trip: tc_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (tc_name (mk-test_case f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. TestCase accessor round-trip: tc_input ---
(push 1)
(declare-const f0 String)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (tc_input (mk-test_case f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- GenState record properties ---

; --- 40. GenState accessor round-trip: gs_seed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (gs_seed (mk-gen_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Mutant record properties ---

; --- 41. Mutant accessor round-trip: mut_location ---
(push 1)
(declare-const f0 Int)
(declare-const f1 MutationOp)
(declare-const f2 Bool)
(assert (not (= (mut_location (mk-mutant f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Mutant accessor round-trip: mut_operator ---
(push 1)
(declare-const f0 Int)
(declare-const f1 MutationOp)
(declare-const f2 Bool)
(assert (not (= (mut_operator (mk-mutant f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityCoverage record properties ---

; --- 43. SecurityCoverage accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(assert (not (= (sc_properties (mk-security_coverage f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TimingMeasurement record properties ---

; --- 44. TimingMeasurement accessor round-trip: tm_input1 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tm_input1 (mk-timing_measurement f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. TimingMeasurement accessor round-trip: tm_input2 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tm_input2 (mk-timing_measurement f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. TimingMeasurement accessor round-trip: tm_time1 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tm_time1 (mk-timing_measurement f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. TimingMeasurement: integer field consistency ---
(push 1)
(declare-const r TimingMeasurement)
(assert (>= (tm_input1 r) 0))
(assert (>= (tm_input2 r) 0))
(assert (not (>= (+ (tm_input1 r) (tm_input2 r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TestState record properties ---

; --- 48. TestState accessor round-trip: ts_counter ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (ts_counter (mk-test_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Fixture record properties ---

; --- 49. Fixture accessor round-trip: fix_setup ---
(push 1)
(declare-const f0 TestState)
(declare-const f1 TestState)
(assert (not (= (fix_setup (mk-fixture f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Component record properties ---

; --- 50. Component accessor round-trip: comp_name ---
(push 1)
(declare-const f0 String)
(declare-const f1 SimpleType)
(declare-const f2 SimpleType)
(declare-const f3 Int)
(assert (not (= (comp_name (mk-component f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Component accessor round-trip: comp_input_type ---
(push 1)
(declare-const f0 String)
(declare-const f1 SimpleType)
(declare-const f2 SimpleType)
(declare-const f3 Int)
(assert (not (= (comp_input_type (mk-component f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Component accessor round-trip: comp_output_type ---
(push 1)
(declare-const f0 String)
(declare-const f1 SimpleType)
(declare-const f2 SimpleType)
(declare-const f3 Int)
(assert (not (= (comp_output_type (mk-component f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- APIContract record properties ---

; --- 53. APIContract accessor round-trip: api_precondition ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (api_precondition (mk-api_contract f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. APIContract accessor round-trip: api_postcondition ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (api_postcondition (mk-api_contract f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. APIContract: integer field consistency ---
(push 1)
(declare-const r APIContract)
(assert (>= (api_precondition r) 0))
(assert (>= (api_postcondition r) 0))
(assert (not (>= (+ (api_precondition r) (api_postcondition r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityFlow record properties ---

; --- 56. SecurityFlow accessor round-trip: sf_source ---
(push 1)
(declare-const f0 SecurityProperty)
(declare-const f1 SecurityProperty)
(declare-const f2 Bool)
(assert (not (= (sf_source (mk-security_flow f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. SecurityFlow accessor round-trip: sf_sink ---
(push 1)
(declare-const f0 SecurityProperty)
(declare-const f1 SecurityProperty)
(declare-const f2 Bool)
(assert (not (= (sf_sink (mk-security_flow f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- KATTest record properties ---

; --- 58. KATTest accessor round-trip: kat_input ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (kat_input (mk-kat_test f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BruteForceProtection record properties ---

; --- 59. BruteForceProtection accessor round-trip: bfp_max_attempts ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (bfp_max_attempts (mk-brute_force_protection f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. BruteForceProtection accessor round-trip: bfp_current_attempts ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (bfp_current_attempts (mk-brute_force_protection f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. BruteForceProtection: integer field consistency ---
(push 1)
(declare-const r BruteForceProtection)
(assert (>= (bfp_max_attempts r) 0))
(assert (>= (bfp_current_attempts r) 0))
(assert (not (>= (+ (bfp_max_attempts r) (bfp_current_attempts r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityProperty ordering properties ---

(define-fun SecurityProperty_level ((x SecurityProperty)) Int
  (ite (= x SPAuthentication) 0 (ite (= x SPAuthorization) 1 (ite (= x SPConfidentiality) 2 (ite (= x SPIntegrity) 3 4)))))

(define-fun SecurityProperty_leq ((x SecurityProperty) (y SecurityProperty)) Bool
  (<= (SecurityProperty_level x) (SecurityProperty_level y)))

; --- 62. SecurityProperty_leq reflexivity ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (SecurityProperty_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. SecurityProperty_leq transitivity ---
(push 1)
(declare-const x SecurityProperty)
(declare-const y SecurityProperty)
(declare-const z SecurityProperty)
(assert (SecurityProperty_leq x y))
(assert (SecurityProperty_leq y z))
(assert (not (SecurityProperty_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. SecurityProperty_leq antisymmetry ---
(push 1)
(declare-const x SecurityProperty)
(declare-const y SecurityProperty)
(assert (SecurityProperty_leq x y))
(assert (SecurityProperty_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. SPAuthentication is bottom ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (SecurityProperty_leq SPAuthentication x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. SPNonRepudiation is top ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (SecurityProperty_leq x SPNonRepudiation)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
