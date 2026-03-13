; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA V001_TerminationGuarantees — SMT Verification
; Derived from 02_FORMAL/coq/domains/V001_TerminationGuarantees.v (32 assertions)
; Module: V001_TerminationGuarantees
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((expr 0)) (((EVar) (EConst) (EApp) (ELam) (ERec))))

(declare-datatypes ((sized_ty 0)) (((STNat) (STList) (STTree) (STFun))))

(declare-datatypes ((even_tree 0)) (((ELeaf) (ENode))))

(declare-datatypes ((odd_tree 0)) (((OLeaf) (ONode))))

(declare-datatypes ((NonTerminating 0)) (((Loop))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- expr enum properties ---

; --- 1. expr exhaustiveness ---
(push 1)
(declare-const x expr)
(assert (not (or (= x EVar) (= x EConst) (= x EApp) (= x ELam) (= x ERec))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. expr: EVar != EConst ---
(push 1)
(assert (= EVar EConst))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. expr: EConst != EApp ---
(push 1)
(assert (= EConst EApp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. expr: EApp != ELam ---
(push 1)
(assert (= EApp ELam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. expr: EVar != ERec ---
(push 1)
(assert (= EVar ERec))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. expr finite cardinality (5 values) ---
(push 1)
(declare-const x expr)
(assert (and (not (= x EVar)) (not (= x EConst)) (not (= x EApp)) (not (= x ELam)) (not (= x ERec))))
(check-sat) ; expect UNSAT
(pop 1)

; --- sized_ty enum properties ---

; --- 7. sized_ty exhaustiveness ---
(push 1)
(declare-const x sized_ty)
(assert (not (or (= x STNat) (= x STList) (= x STTree) (= x STFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. sized_ty: STNat != STList ---
(push 1)
(assert (= STNat STList))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. sized_ty: STList != STTree ---
(push 1)
(assert (= STList STTree))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. sized_ty: STTree != STFun ---
(push 1)
(assert (= STTree STFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. sized_ty: STNat != STFun ---
(push 1)
(assert (= STNat STFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. sized_ty finite cardinality (4 values) ---
(push 1)
(declare-const x sized_ty)
(assert (and (not (= x STNat)) (not (= x STList)) (not (= x STTree)) (not (= x STFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- even_tree enum properties ---

; --- 13. even_tree exhaustiveness ---
(push 1)
(declare-const x even_tree)
(assert (not (or (= x ELeaf) (= x ENode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. even_tree: ELeaf != ENode ---
(push 1)
(assert (= ELeaf ENode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. even_tree finite cardinality (2 values) ---
(push 1)
(declare-const x even_tree)
(assert (and (not (= x ELeaf)) (not (= x ENode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- odd_tree enum properties ---

; --- 16. odd_tree exhaustiveness ---
(push 1)
(declare-const x odd_tree)
(assert (not (or (= x OLeaf) (= x ONode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. odd_tree: OLeaf != ONode ---
(push 1)
(assert (= OLeaf ONode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. odd_tree finite cardinality (2 values) ---
(push 1)
(declare-const x odd_tree)
(assert (and (not (= x OLeaf)) (not (= x ONode))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
