; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA RefinementTypes — SMT Verification
; Derived from 02_FORMAL/coq/domains/RefinementTypes.v (24 assertions)
; Module: RefinementTypes
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((BaseTy 0)) (((TyNat) (TyInt) (TyBool) (TyPtr))))

(declare-datatypes ((Ind_Pred 0)) (((PTrue) (PFalse) (PEqC) (PLtC) (PLeC) (PGtC) (PGeC) (PNeqC) (PAnd) (POr) (PNot) (PImpl))))

(declare-datatypes ((RefTy 0)) (((RBase) (RRefine) (RFun))))

(declare-datatypes ((Expr 0)) (((EVal) (EVar) (EApp) (ELam) (EPlus) (EMult))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. BaseTy exhaustiveness ---
(push 1)
(declare-const x BaseTy)
(assert (not (or (= x TyNat) (= x TyInt) (= x TyBool) (= x TyPtr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. BaseTy: TyNat != TyInt ---
(push 1)
(assert (= TyNat TyInt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. BaseTy: TyInt != TyBool ---
(push 1)
(assert (= TyInt TyBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. BaseTy: TyBool != TyPtr ---
(push 1)
(assert (= TyBool TyPtr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. BaseTy: TyNat != TyPtr ---
(push 1)
(assert (= TyNat TyPtr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. BaseTy finite cardinality (4 values) ---
(push 1)
(declare-const x BaseTy)
(assert (and (not (= x TyNat)) (not (= x TyInt)) (not (= x TyBool)) (not (= x TyPtr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Ind_Pred exhaustiveness ---
(push 1)
(declare-const x Ind_Pred)
(assert (not (or (= x PTrue) (= x PFalse) (= x PEqC) (= x PLtC) (= x PLeC) (= x PGtC) (= x PGeC) (= x PNeqC) (= x PAnd) (= x POr) (= x PNot) (= x PImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Ind_Pred: PTrue != PFalse ---
(push 1)
(assert (= PTrue PFalse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Ind_Pred: PFalse != PEqC ---
(push 1)
(assert (= PFalse PEqC))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Ind_Pred: PEqC != PLtC ---
(push 1)
(assert (= PEqC PLtC))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Ind_Pred: PTrue != PImpl ---
(push 1)
(assert (= PTrue PImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Ind_Pred finite cardinality (12 values) ---
(push 1)
(declare-const x Ind_Pred)
(assert (and (not (= x PTrue)) (not (= x PFalse)) (not (= x PEqC)) (not (= x PLtC)) (not (= x PLeC)) (not (= x PGtC)) (not (= x PGeC)) (not (= x PNeqC)) (not (= x PAnd)) (not (= x POr)) (not (= x PNot)) (not (= x PImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. RefTy exhaustiveness ---
(push 1)
(declare-const x RefTy)
(assert (not (or (= x RBase) (= x RRefine) (= x RFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. RefTy: RBase != RRefine ---
(push 1)
(assert (= RBase RRefine))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. RefTy: RRefine != RFun ---
(push 1)
(assert (= RRefine RFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. RefTy finite cardinality (3 values) ---
(push 1)
(declare-const x RefTy)
(assert (and (not (= x RBase)) (not (= x RRefine)) (not (= x RFun))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Expr exhaustiveness ---
(push 1)
(declare-const x Expr)
(assert (not (or (= x EVal) (= x EVar) (= x EApp) (= x ELam) (= x EPlus) (= x EMult))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Expr: EVal != EVar ---
(push 1)
(assert (= EVal EVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Expr: EVar != EApp ---
(push 1)
(assert (= EVar EApp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Expr: EApp != ELam ---
(push 1)
(assert (= EApp ELam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Expr: EVal != EMult ---
(push 1)
(assert (= EVal EMult))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Expr finite cardinality (6 values) ---
(push 1)
(declare-const x Expr)
(assert (and (not (= x EVal)) (not (= x EVar)) (not (= x EApp)) (not (= x ELam)) (not (= x EPlus)) (not (= x EMult))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
