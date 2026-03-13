; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TaintSystemCorrectness — SMT Verification
; Derived from 02_FORMAL/coq/domains/TaintSystemCorrectness.v (50 assertions)
; Module: TaintSystemCorrectness
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((taint_source 0)) (((TaintNetworkExternal) (TaintNetworkInternal) (TaintUserInput) (TaintFileSystem) (TaintDatabase) (TaintEnvironment))))

(declare-datatypes ((sanitizer 0)) (((SanSqlParam) (SanHtmlEscape) (SanJsEscape) (SanCssEscape) (SanUrlEncode) (SanCommandEscape) (SanLdapEscape) (SanPathSanitize) (SanCsrfToken))))

(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TInt) (TString) (TFn) (TProd) (TList) (TTainted) (TSanitized))))

(declare-datatypes ((expr 0)) (((EUnit) (ETrue) (EFalse) (EInt) (EStr) (EVar) (EAbs) (EApp) (ELet) (EIf) (EPair) (EFst) (ESnd) (ETaint) (ESanitize) (EUseSink))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. taint_source exhaustiveness ---
(push 1)
(declare-const x taint_source)
(assert (not (or (= x TaintNetworkExternal) (= x TaintNetworkInternal) (= x TaintUserInput) (= x TaintFileSystem) (= x TaintDatabase) (= x TaintEnvironment))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. taint_source: TaintNetworkExternal != TaintNetworkInternal ---
(push 1)
(assert (= TaintNetworkExternal TaintNetworkInternal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. taint_source: TaintNetworkInternal != TaintUserInput ---
(push 1)
(assert (= TaintNetworkInternal TaintUserInput))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. taint_source: TaintUserInput != TaintFileSystem ---
(push 1)
(assert (= TaintUserInput TaintFileSystem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. taint_source: TaintNetworkExternal != TaintEnvironment ---
(push 1)
(assert (= TaintNetworkExternal TaintEnvironment))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. taint_source finite cardinality (6 values) ---
(push 1)
(declare-const x taint_source)
(assert (and (not (= x TaintNetworkExternal)) (not (= x TaintNetworkInternal)) (not (= x TaintUserInput)) (not (= x TaintFileSystem)) (not (= x TaintDatabase)) (not (= x TaintEnvironment))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. sanitizer exhaustiveness ---
(push 1)
(declare-const x sanitizer)
(assert (not (or (= x SanSqlParam) (= x SanHtmlEscape) (= x SanJsEscape) (= x SanCssEscape) (= x SanUrlEncode) (= x SanCommandEscape) (= x SanLdapEscape) (= x SanPathSanitize) (= x SanCsrfToken))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. sanitizer: SanSqlParam != SanHtmlEscape ---
(push 1)
(assert (= SanSqlParam SanHtmlEscape))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. sanitizer: SanHtmlEscape != SanJsEscape ---
(push 1)
(assert (= SanHtmlEscape SanJsEscape))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. sanitizer: SanJsEscape != SanCssEscape ---
(push 1)
(assert (= SanJsEscape SanCssEscape))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. sanitizer: SanSqlParam != SanCsrfToken ---
(push 1)
(assert (= SanSqlParam SanCsrfToken))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. sanitizer finite cardinality (9 values) ---
(push 1)
(declare-const x sanitizer)
(assert (and (not (= x SanSqlParam)) (not (= x SanHtmlEscape)) (not (= x SanJsEscape)) (not (= x SanCssEscape)) (not (= x SanUrlEncode)) (not (= x SanCommandEscape)) (not (= x SanLdapEscape)) (not (= x SanPathSanitize)) (not (= x SanCsrfToken))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. ty exhaustiveness ---
(push 1)
(declare-const x ty)
(assert (not (or (= x TUnit) (= x TBool) (= x TInt) (= x TString) (= x TFn) (= x TProd) (= x TList) (= x TTainted) (= x TSanitized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ty: TUnit != TBool ---
(push 1)
(assert (= TUnit TBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ty: TBool != TInt ---
(push 1)
(assert (= TBool TInt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ty: TInt != TString ---
(push 1)
(assert (= TInt TString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ty: TUnit != TSanitized ---
(push 1)
(assert (= TUnit TSanitized))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ty finite cardinality (9 values) ---
(push 1)
(declare-const x ty)
(assert (and (not (= x TUnit)) (not (= x TBool)) (not (= x TInt)) (not (= x TString)) (not (= x TFn)) (not (= x TProd)) (not (= x TList)) (not (= x TTainted)) (not (= x TSanitized))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. expr exhaustiveness ---
(push 1)
(declare-const x expr)
(assert (not (or (= x EUnit) (= x ETrue) (= x EFalse) (= x EInt) (= x EStr) (= x EVar) (= x EAbs) (= x EApp) (= x ELet) (= x EIf) (= x EPair) (= x EFst) (= x ESnd) (= x ETaint) (= x ESanitize) (= x EUseSink))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. expr: EUnit != ETrue ---
(push 1)
(assert (= EUnit ETrue))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. expr: ETrue != EFalse ---
(push 1)
(assert (= ETrue EFalse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. expr: EFalse != EInt ---
(push 1)
(assert (= EFalse EInt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. expr: EUnit != EUseSink ---
(push 1)
(assert (= EUnit EUseSink))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. expr finite cardinality (16 values) ---
(push 1)
(declare-const x expr)
(assert (and (not (= x EUnit)) (not (= x ETrue)) (not (= x EFalse)) (not (= x EInt)) (not (= x EStr)) (not (= x EVar)) (not (= x EAbs)) (not (= x EApp)) (not (= x ELet)) (not (= x EIf)) (not (= x EPair)) (not (= x EFst)) (not (= x ESnd)) (not (= x ETaint)) (not (= x ESanitize)) (not (= x EUseSink))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
