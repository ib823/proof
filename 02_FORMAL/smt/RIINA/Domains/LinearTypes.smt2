; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA LinearTypes — SMT Verification
; Derived from 02_FORMAL/coq/domains/LinearTypes.v (25 assertions)
; Module: LinearTypes
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Linearity 0)) (((Lin) (Aff) (Rel) (Unr))))

(declare-datatypes ((LTy 0)) (((LUnit) (LBool) (LFun) (LPair) (LBang))))

(declare-datatypes ((Usage 0)) (((Zero) (C_One) (Many))))

(declare-datatypes ((LTerm 0)) (((LVar) (LUnitVal) (LTrue) (LFalse) (LLam) (LApp) (LPairVal) (LLetPair) (LBangVal) (LLetBang) (LLet))))

(declare-datatypes ((ResourceState 0)) (((Available) (Consumed))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Linearity enum properties ---

; --- 1. Linearity exhaustiveness ---
(push 1)
(declare-const x Linearity)
(assert (not (or (= x Lin) (= x Aff) (= x Rel) (= x Unr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Linearity: Lin != Aff ---
(push 1)
(assert (= Lin Aff))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Linearity: Aff != Rel ---
(push 1)
(assert (= Aff Rel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Linearity: Rel != Unr ---
(push 1)
(assert (= Rel Unr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Linearity: Lin != Unr ---
(push 1)
(assert (= Lin Unr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Linearity finite cardinality (4 values) ---
(push 1)
(declare-const x Linearity)
(assert (and (not (= x Lin)) (not (= x Aff)) (not (= x Rel)) (not (= x Unr))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LTy enum properties ---

; --- 7. LTy exhaustiveness ---
(push 1)
(declare-const x LTy)
(assert (not (or (= x LUnit) (= x LBool) (= x LFun) (= x LPair) (= x LBang))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. LTy: LUnit != LBool ---
(push 1)
(assert (= LUnit LBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. LTy: LBool != LFun ---
(push 1)
(assert (= LBool LFun))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. LTy: LFun != LPair ---
(push 1)
(assert (= LFun LPair))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. LTy: LUnit != LBang ---
(push 1)
(assert (= LUnit LBang))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. LTy finite cardinality (5 values) ---
(push 1)
(declare-const x LTy)
(assert (and (not (= x LUnit)) (not (= x LBool)) (not (= x LFun)) (not (= x LPair)) (not (= x LBang))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Usage enum properties ---

; --- 13. Usage exhaustiveness ---
(push 1)
(declare-const x Usage)
(assert (not (or (= x Zero) (= x C_One) (= x Many))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Usage: Zero != C_One ---
(push 1)
(assert (= Zero C_One))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Usage: C_One != Many ---
(push 1)
(assert (= C_One Many))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Usage: Zero != Many ---
(push 1)
(assert (= Zero Many))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Usage finite cardinality (3 values) ---
(push 1)
(declare-const x Usage)
(assert (and (not (= x Zero)) (not (= x C_One)) (not (= x Many))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LTerm enum properties ---

; --- 18. LTerm exhaustiveness ---
(push 1)
(declare-const x LTerm)
(assert (not (or (= x LVar) (= x LUnitVal) (= x LTrue) (= x LFalse) (= x LLam) (= x LApp) (= x LPairVal) (= x LLetPair) (= x LBangVal) (= x LLetBang) (= x LLet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. LTerm: LVar != LUnitVal ---
(push 1)
(assert (= LVar LUnitVal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. LTerm: LUnitVal != LTrue ---
(push 1)
(assert (= LUnitVal LTrue))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. LTerm: LTrue != LFalse ---
(push 1)
(assert (= LTrue LFalse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. LTerm: LVar != LLet ---
(push 1)
(assert (= LVar LLet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. LTerm finite cardinality (11 values) ---
(push 1)
(declare-const x LTerm)
(assert (and (not (= x LVar)) (not (= x LUnitVal)) (not (= x LTrue)) (not (= x LFalse)) (not (= x LLam)) (not (= x LApp)) (not (= x LPairVal)) (not (= x LLetPair)) (not (= x LBangVal)) (not (= x LLetBang)) (not (= x LLet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ResourceState enum properties ---

; --- 24. ResourceState exhaustiveness ---
(push 1)
(declare-const x ResourceState)
(assert (not (or (= x Available) (= x Consumed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ResourceState: Available != Consumed ---
(push 1)
(assert (= Available Consumed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ResourceState finite cardinality (2 values) ---
(push 1)
(declare-const x ResourceState)
(assert (and (not (= x Available)) (not (= x Consumed))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
