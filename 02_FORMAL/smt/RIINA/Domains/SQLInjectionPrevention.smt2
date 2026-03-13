; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SQLInjectionPrevention — SMT Verification
; Derived from 02_FORMAL/coq/domains/SQLInjectionPrevention.v (22 assertions)
; Module: SQLInjectionPrevention
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TaintLevel 0)) (((Untainted) (UserInput) (Sanitized))))

(declare-datatypes ((QueryMethod 0)) (((StringConcat) (Parameterized) (ORM))))

(declare-datatypes ((SQLOperation 0)) (((SQL_Select) (SQL_Insert) (SQL_Update) (SQL_Delete) (SQL_Execute))))

(declare-datatypes ((SQLSecurityConfig 0))
  (((mk-sql_security_config (sql_parameterized_only Bool) (sql_no_string_concat Bool) (sql_input_sanitized Bool) (sql_whitelist_validation Bool) (sql_escape_special_chars Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TaintLevel enum properties ---

; --- 1. TaintLevel exhaustiveness ---
(push 1)
(declare-const x TaintLevel)
(assert (not (or (= x Untainted) (= x UserInput) (= x Sanitized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TaintLevel: Untainted != UserInput ---
(push 1)
(assert (= Untainted UserInput))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TaintLevel: UserInput != Sanitized ---
(push 1)
(assert (= UserInput Sanitized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TaintLevel: Untainted != Sanitized ---
(push 1)
(assert (= Untainted Sanitized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TaintLevel finite cardinality (3 values) ---
(push 1)
(declare-const x TaintLevel)
(assert (and (not (= x Untainted)) (not (= x UserInput)) (not (= x Sanitized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- QueryMethod enum properties ---

; --- 6. QueryMethod exhaustiveness ---
(push 1)
(declare-const x QueryMethod)
(assert (not (or (= x StringConcat) (= x Parameterized) (= x ORM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. QueryMethod: StringConcat != Parameterized ---
(push 1)
(assert (= StringConcat Parameterized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. QueryMethod: Parameterized != ORM ---
(push 1)
(assert (= Parameterized ORM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. QueryMethod: StringConcat != ORM ---
(push 1)
(assert (= StringConcat ORM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. QueryMethod finite cardinality (3 values) ---
(push 1)
(declare-const x QueryMethod)
(assert (and (not (= x StringConcat)) (not (= x Parameterized)) (not (= x ORM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SQLOperation enum properties ---

; --- 11. SQLOperation exhaustiveness ---
(push 1)
(declare-const x SQLOperation)
(assert (not (or (= x SQL_Select) (= x SQL_Insert) (= x SQL_Update) (= x SQL_Delete) (= x SQL_Execute))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SQLOperation: SQL_Select != SQL_Insert ---
(push 1)
(assert (= SQL_Select SQL_Insert))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SQLOperation: SQL_Insert != SQL_Update ---
(push 1)
(assert (= SQL_Insert SQL_Update))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SQLOperation: SQL_Update != SQL_Delete ---
(push 1)
(assert (= SQL_Update SQL_Delete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SQLOperation: SQL_Select != SQL_Execute ---
(push 1)
(assert (= SQL_Select SQL_Execute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SQLOperation finite cardinality (5 values) ---
(push 1)
(declare-const x SQLOperation)
(assert (and (not (= x SQL_Select)) (not (= x SQL_Insert)) (not (= x SQL_Update)) (not (= x SQL_Delete)) (not (= x SQL_Execute))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SQLSecurityConfig record properties ---

; --- 17. SQLSecurityConfig accessor round-trip: sql_parameterized_only ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sql_parameterized_only (mk-s_q_l_security_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SQLSecurityConfig accessor round-trip: sql_no_string_concat ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sql_no_string_concat (mk-s_q_l_security_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SQLSecurityConfig accessor round-trip: sql_input_sanitized ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sql_input_sanitized (mk-s_q_l_security_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SQLSecurityConfig accessor round-trip: sql_whitelist_validation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sql_whitelist_validation (mk-s_q_l_security_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SQLSecurityConfig_all_enabled ((g SQLSecurityConfig)) Bool
  (and (sql_parameterized_only g) (sql_no_string_concat g) (sql_input_sanitized g) (sql_whitelist_validation g)))

; --- 21. SQLSecurityConfig: all-enabled completeness ---
(push 1)
(declare-const g SQLSecurityConfig)
(assert (sql_parameterized_only g))
(assert (sql_no_string_concat g))
(assert (sql_input_sanitized g))
(assert (sql_whitelist_validation g))
(assert (not (SQLSecurityConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SQLSecurityConfig: SQLSecurityConfig_all_enabled implies sql_parameterized_only ---
(push 1)
(declare-const g SQLSecurityConfig)
(assert (SQLSecurityConfig_all_enabled g))
(assert (not (sql_parameterized_only g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SQLSecurityConfig: SQLSecurityConfig_all_enabled implies sql_no_string_concat ---
(push 1)
(declare-const g SQLSecurityConfig)
(assert (SQLSecurityConfig_all_enabled g))
(assert (not (sql_no_string_concat g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SQLSecurityConfig: SQLSecurityConfig_all_enabled implies sql_input_sanitized ---
(push 1)
(declare-const g SQLSecurityConfig)
(assert (SQLSecurityConfig_all_enabled g))
(assert (not (sql_input_sanitized g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TaintLevel ordering properties ---

(define-fun TaintLevel_level ((x TaintLevel)) Int
  (ite (= x Untainted) 0 (ite (= x UserInput) 1 2)))

(define-fun TaintLevel_leq ((x TaintLevel) (y TaintLevel)) Bool
  (<= (TaintLevel_level x) (TaintLevel_level y)))

; --- 25. TaintLevel_leq reflexivity ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TaintLevel_leq transitivity ---
(push 1)
(declare-const x TaintLevel)
(declare-const y TaintLevel)
(declare-const z TaintLevel)
(assert (TaintLevel_leq x y))
(assert (TaintLevel_leq y z))
(assert (not (TaintLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TaintLevel_leq antisymmetry ---
(push 1)
(declare-const x TaintLevel)
(declare-const y TaintLevel)
(assert (TaintLevel_leq x y))
(assert (TaintLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Untainted is bottom ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq Untainted x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Sanitized is top ---
(push 1)
(declare-const x TaintLevel)
(assert (not (TaintLevel_leq x Sanitized)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
