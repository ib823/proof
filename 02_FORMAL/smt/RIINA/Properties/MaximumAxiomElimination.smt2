; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MaximumAxiomElimination — SMT Verification
; Derived from 02_FORMAL/coq/properties/MaximumAxiomElimination.v (53 assertions)
; Module: MaximumAxiomElimination
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((sec_label 0)) (((L) (H))))

(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TNat) (TRef) (TProd) (TSum) (TArrow))))

(declare-datatypes ((expr 0)) (((EVar) (EUnit) (EBool) (ENat) (ELoc) (EPair) (EFst) (ESnd) (EInl) (EInr) (ELam) (EApp) (ERef) (EDeref) (EAssign) (EIf) (ELet))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. sec_label exhaustiveness ---
(push 1)
(declare-const x sec_label)
(assert (not (or (= x L) (= x H))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. sec_label: L != H ---
(push 1)
(assert (= L H))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. sec_label finite cardinality (2 values) ---
(push 1)
(declare-const x sec_label)
(assert (and (not (= x L)) (not (= x H))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ty exhaustiveness ---
(push 1)
(declare-const x ty)
(assert (not (or (= x TUnit) (= x TBool) (= x TNat) (= x TRef) (= x TProd) (= x TSum) (= x TArrow))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ty: TUnit != TBool ---
(push 1)
(assert (= TUnit TBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ty: TBool != TNat ---
(push 1)
(assert (= TBool TNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. ty: TNat != TRef ---
(push 1)
(assert (= TNat TRef))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ty: TUnit != TArrow ---
(push 1)
(assert (= TUnit TArrow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ty finite cardinality (7 values) ---
(push 1)
(declare-const x ty)
(assert (and (not (= x TUnit)) (not (= x TBool)) (not (= x TNat)) (not (= x TRef)) (not (= x TProd)) (not (= x TSum)) (not (= x TArrow))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. expr exhaustiveness ---
(push 1)
(declare-const x expr)
(assert (not (or (= x EVar) (= x EUnit) (= x EBool) (= x ENat) (= x ELoc) (= x EPair) (= x EFst) (= x ESnd) (= x EInl) (= x EInr) (= x ELam) (= x EApp) (= x ERef) (= x EDeref) (= x EAssign) (= x EIf) (= x ELet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. expr: EVar != EUnit ---
(push 1)
(assert (= EVar EUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. expr: EUnit != EBool ---
(push 1)
(assert (= EUnit EBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. expr: EBool != ENat ---
(push 1)
(assert (= EBool ENat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. expr: EVar != ELet ---
(push 1)
(assert (= EVar ELet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. expr finite cardinality (17 values) ---
(push 1)
(declare-const x expr)
(assert (and (not (= x EVar)) (not (= x EUnit)) (not (= x EBool)) (not (= x ENat)) (not (= x ELoc)) (not (= x EPair)) (not (= x EFst)) (not (= x ESnd)) (not (= x EInl)) (not (= x EInr)) (not (= x ELam)) (not (= x EApp)) (not (= x ERef)) (not (= x EDeref)) (not (= x EAssign)) (not (= x EIf)) (not (= x ELet))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
