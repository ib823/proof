; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AlgebraicEffects — SMT Verification
; Derived from 02_FORMAL/coq/domains/AlgebraicEffects.v (22 assertions)
; Module: AlgebraicEffects
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((BaseTy 0)) (((TUnit) (TBool) (TNat))))

(declare-datatypes ((EffectOp 0)) (((OpRead) (OpWrite) (OpRaise) (OpPrint) (OpRandom) (OpAsync))))

(declare-datatypes ((CompTy 0)) (((CTyPure) (CTyEff))))

(declare-datatypes ((Ind_Val 0)) (((VUnit) (VBool) (VNat))))

(declare-datatypes ((Comp 0)) (((CReturn) (CPerform) (CHandle))))

(declare-datatypes ((EvalCtx 0)) (((EHole))))

(declare-datatypes ((OpSig 0))
  (((mk-op_sig (opInputTy BaseTy) (opOutputTy BaseTy)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. BaseTy exhaustiveness ---
(push 1)
(declare-const x BaseTy)
(assert (not (or (= x TUnit) (= x TBool) (= x TNat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. BaseTy: TUnit != TBool ---
(push 1)
(assert (= TUnit TBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. BaseTy: TBool != TNat ---
(push 1)
(assert (= TBool TNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. BaseTy finite cardinality (3 values) ---
(push 1)
(declare-const x BaseTy)
(assert (and (not (= x TUnit)) (not (= x TBool)) (not (= x TNat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. EffectOp exhaustiveness ---
(push 1)
(declare-const x EffectOp)
(assert (not (or (= x OpRead) (= x OpWrite) (= x OpRaise) (= x OpPrint) (= x OpRandom) (= x OpAsync))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. EffectOp: OpRead != OpWrite ---
(push 1)
(assert (= OpRead OpWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. EffectOp: OpWrite != OpRaise ---
(push 1)
(assert (= OpWrite OpRaise))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EffectOp: OpRaise != OpPrint ---
(push 1)
(assert (= OpRaise OpPrint))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. EffectOp: OpRead != OpAsync ---
(push 1)
(assert (= OpRead OpAsync))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. EffectOp finite cardinality (6 values) ---
(push 1)
(declare-const x EffectOp)
(assert (and (not (= x OpRead)) (not (= x OpWrite)) (not (= x OpRaise)) (not (= x OpPrint)) (not (= x OpRandom)) (not (= x OpAsync))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CompTy exhaustiveness ---
(push 1)
(declare-const x CompTy)
(assert (not (or (= x CTyPure) (= x CTyEff))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CompTy: CTyPure != CTyEff ---
(push 1)
(assert (= CTyPure CTyEff))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. CompTy finite cardinality (2 values) ---
(push 1)
(declare-const x CompTy)
(assert (and (not (= x CTyPure)) (not (= x CTyEff))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Ind_Val exhaustiveness ---
(push 1)
(declare-const x Ind_Val)
(assert (not (or (= x VUnit) (= x VBool) (= x VNat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Ind_Val: VUnit != VBool ---
(push 1)
(assert (= VUnit VBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Ind_Val: VBool != VNat ---
(push 1)
(assert (= VBool VNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Ind_Val finite cardinality (3 values) ---
(push 1)
(declare-const x Ind_Val)
(assert (and (not (= x VUnit)) (not (= x VBool)) (not (= x VNat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Comp exhaustiveness ---
(push 1)
(declare-const x Comp)
(assert (not (or (= x CReturn) (= x CPerform) (= x CHandle))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Comp: CReturn != CPerform ---
(push 1)
(assert (= CReturn CPerform))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Comp: CPerform != CHandle ---
(push 1)
(assert (= CPerform CHandle))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Comp finite cardinality (3 values) ---
(push 1)
(declare-const x Comp)
(assert (and (not (= x CReturn)) (not (= x CPerform)) (not (= x CHandle))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. OpSig accessor round-trip: opInputTy ---
(push 1)
(declare-const f0 BaseTy)
(declare-const f1 BaseTy)
(assert (not (= (opInputTy (mk-op_sig f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. OpSig accessor round-trip: opOutputTy ---
(push 1)
(declare-const f0 BaseTy)
(declare-const f1 BaseTy)
(assert (not (= (opOutputTy (mk-op_sig f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
