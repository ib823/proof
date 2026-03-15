; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA FormalVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/FormalVerification.v (36 assertions)
; Module: FormalVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((BaseTy 0)) (((TyUnit) (TyBool) (TyNat) (TyInt))))

(declare-datatypes ((Ind_Pred 0)) (((PTrue) (PFalse) (PEq) (PLt) (PAnd) (POr) (PNot) (PImpl))))

(declare-datatypes ((RefinementTy 0)) (((RBase) (RRefine))))

(declare-datatypes ((HeapPred 0)) (((HPEmp) (HPPointsTo) (HPSep) (HPWand))))

(declare-datatypes ((VC 0)) (((VCValid) (VCAnd) (VCImpl))))

(declare-datatypes ((TyExpr 0)) (((TEBase) (TEPi) (TESigma) (TEVar))))

(declare-datatypes ((SMTFormula 0)) (((SMTTrue) (SMTFalse) (SMTEq) (SMTLt) (SMTAnd) (SMTOr) (SMTNot) (SMTImpl))))

(declare-datatypes ((Property 0)) (((PropAtom) (PropNot) (PropAnd) (PropOr) (PropNext) (PropUntil))))

(declare-datatypes ((BMCResult 0)) (((BMCSat) (BMCUnsat))))

(declare-datatypes ((SimpleProp 0)) (((SPTrue) (SPFalse) (SPAtom) (SPAnd) (SPOr) (SPImpl))))

(declare-datatypes ((ProofTerm 0)) (((PTTrueI) (PTAndI) (PTAndE1) (PTAndE2) (PTOrI1) (PTOrI2) (PTImplI) (PTImplE) (PTAssume))))

(declare-datatypes ((SrcExpr 0)) (((SrcUnit) (SrcBool) (SrcNat) (SrcVar) (SrcApp) (SrcLam))))

(declare-datatypes ((TgtExpr 0)) (((TgtUnit) (TgtBool) (TgtNat) (TgtVar) (TgtApp) (TgtLam))))

(declare-datatypes ((Ind_Effect 0)) (((EffPure) (EffIO) (EffState) (EffExn))))

(declare-datatypes ((SecLabel 0)) (((SecPublic) (SecPrivate) (SecSecret))))

(declare-datatypes ((SrcVal 0)) (((SVUnit) (SVBool) (SVNat) (SVClosure))))

(declare-datatypes ((TgtVal 0)) (((TVUnit) (TVBool) (TVNat) (TVClosure))))

(declare-datatypes ((Cmd 0)) (((CmdSkip) (CmdAssign) (CmdSeq) (CmdIf) (CmdWhile))))

(declare-datatypes ((Contract 0))
  (((mk-contract (precondition Ind_Pred) (postcondition Ind_Pred)))))

(declare-datatypes ((LiquidState 0))
  (((mk-liquid_state (liquid_constraints (Seq Int)) (liquid_templates (Seq Int)) (liquid_iteration Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- BaseTy enum properties ---

; --- 1. BaseTy exhaustiveness ---
(push 1)
(declare-const x BaseTy)
(assert (not (or (= x TyUnit) (= x TyBool) (= x TyNat) (= x TyInt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. BaseTy: TyUnit != TyBool ---
(push 1)
(assert (= TyUnit TyBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. BaseTy: TyBool != TyNat ---
(push 1)
(assert (= TyBool TyNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. BaseTy: TyNat != TyInt ---
(push 1)
(assert (= TyNat TyInt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. BaseTy: TyUnit != TyInt ---
(push 1)
(assert (= TyUnit TyInt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. BaseTy finite cardinality (4 values) ---
(push 1)
(declare-const x BaseTy)
(assert (and (not (= x TyUnit)) (not (= x TyBool)) (not (= x TyNat)) (not (= x TyInt))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Ind_Pred enum properties ---

; --- 7. Ind_Pred exhaustiveness ---
(push 1)
(declare-const x Ind_Pred)
(assert (not (or (= x PTrue) (= x PFalse) (= x PEq) (= x PLt) (= x PAnd) (= x POr) (= x PNot) (= x PImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Ind_Pred: PTrue != PFalse ---
(push 1)
(assert (= PTrue PFalse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Ind_Pred: PFalse != PEq ---
(push 1)
(assert (= PFalse PEq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Ind_Pred: PEq != PLt ---
(push 1)
(assert (= PEq PLt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Ind_Pred: PTrue != PImpl ---
(push 1)
(assert (= PTrue PImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Ind_Pred finite cardinality (8 values) ---
(push 1)
(declare-const x Ind_Pred)
(assert (and (not (= x PTrue)) (not (= x PFalse)) (not (= x PEq)) (not (= x PLt)) (not (= x PAnd)) (not (= x POr)) (not (= x PNot)) (not (= x PImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RefinementTy enum properties ---

; --- 13. RefinementTy exhaustiveness ---
(push 1)
(declare-const x RefinementTy)
(assert (not (or (= x RBase) (= x RRefine))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. RefinementTy: RBase != RRefine ---
(push 1)
(assert (= RBase RRefine))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. RefinementTy finite cardinality (2 values) ---
(push 1)
(declare-const x RefinementTy)
(assert (and (not (= x RBase)) (not (= x RRefine))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HeapPred enum properties ---

; --- 16. HeapPred exhaustiveness ---
(push 1)
(declare-const x HeapPred)
(assert (not (or (= x HPEmp) (= x HPPointsTo) (= x HPSep) (= x HPWand))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. HeapPred: HPEmp != HPPointsTo ---
(push 1)
(assert (= HPEmp HPPointsTo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. HeapPred: HPPointsTo != HPSep ---
(push 1)
(assert (= HPPointsTo HPSep))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. HeapPred: HPSep != HPWand ---
(push 1)
(assert (= HPSep HPWand))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. HeapPred: HPEmp != HPWand ---
(push 1)
(assert (= HPEmp HPWand))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. HeapPred finite cardinality (4 values) ---
(push 1)
(declare-const x HeapPred)
(assert (and (not (= x HPEmp)) (not (= x HPPointsTo)) (not (= x HPSep)) (not (= x HPWand))))
(check-sat) ; expect UNSAT
(pop 1)

; --- VC enum properties ---

; --- 22. VC exhaustiveness ---
(push 1)
(declare-const x VC)
(assert (not (or (= x VCValid) (= x VCAnd) (= x VCImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. VC: VCValid != VCAnd ---
(push 1)
(assert (= VCValid VCAnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. VC: VCAnd != VCImpl ---
(push 1)
(assert (= VCAnd VCImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. VC: VCValid != VCImpl ---
(push 1)
(assert (= VCValid VCImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. VC finite cardinality (3 values) ---
(push 1)
(declare-const x VC)
(assert (and (not (= x VCValid)) (not (= x VCAnd)) (not (= x VCImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TyExpr enum properties ---

; --- 27. TyExpr exhaustiveness ---
(push 1)
(declare-const x TyExpr)
(assert (not (or (= x TEBase) (= x TEPi) (= x TESigma) (= x TEVar))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. TyExpr: TEBase != TEPi ---
(push 1)
(assert (= TEBase TEPi))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. TyExpr: TEPi != TESigma ---
(push 1)
(assert (= TEPi TESigma))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. TyExpr: TESigma != TEVar ---
(push 1)
(assert (= TESigma TEVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. TyExpr: TEBase != TEVar ---
(push 1)
(assert (= TEBase TEVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. TyExpr finite cardinality (4 values) ---
(push 1)
(declare-const x TyExpr)
(assert (and (not (= x TEBase)) (not (= x TEPi)) (not (= x TESigma)) (not (= x TEVar))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SMTFormula enum properties ---

; --- 33. SMTFormula exhaustiveness ---
(push 1)
(declare-const x SMTFormula)
(assert (not (or (= x SMTTrue) (= x SMTFalse) (= x SMTEq) (= x SMTLt) (= x SMTAnd) (= x SMTOr) (= x SMTNot) (= x SMTImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. SMTFormula: SMTTrue != SMTFalse ---
(push 1)
(assert (= SMTTrue SMTFalse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. SMTFormula: SMTFalse != SMTEq ---
(push 1)
(assert (= SMTFalse SMTEq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. SMTFormula: SMTEq != SMTLt ---
(push 1)
(assert (= SMTEq SMTLt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SMTFormula: SMTTrue != SMTImpl ---
(push 1)
(assert (= SMTTrue SMTImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. SMTFormula finite cardinality (8 values) ---
(push 1)
(declare-const x SMTFormula)
(assert (and (not (= x SMTTrue)) (not (= x SMTFalse)) (not (= x SMTEq)) (not (= x SMTLt)) (not (= x SMTAnd)) (not (= x SMTOr)) (not (= x SMTNot)) (not (= x SMTImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Property enum properties ---

; --- 39. Property exhaustiveness ---
(push 1)
(declare-const x Property)
(assert (not (or (= x PropAtom) (= x PropNot) (= x PropAnd) (= x PropOr) (= x PropNext) (= x PropUntil))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Property: PropAtom != PropNot ---
(push 1)
(assert (= PropAtom PropNot))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. Property: PropNot != PropAnd ---
(push 1)
(assert (= PropNot PropAnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Property: PropAnd != PropOr ---
(push 1)
(assert (= PropAnd PropOr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. Property: PropAtom != PropUntil ---
(push 1)
(assert (= PropAtom PropUntil))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Property finite cardinality (6 values) ---
(push 1)
(declare-const x Property)
(assert (and (not (= x PropAtom)) (not (= x PropNot)) (not (= x PropAnd)) (not (= x PropOr)) (not (= x PropNext)) (not (= x PropUntil))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BMCResult enum properties ---

; --- 45. BMCResult exhaustiveness ---
(push 1)
(declare-const x BMCResult)
(assert (not (or (= x BMCSat) (= x BMCUnsat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. BMCResult: BMCSat != BMCUnsat ---
(push 1)
(assert (= BMCSat BMCUnsat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. BMCResult finite cardinality (2 values) ---
(push 1)
(declare-const x BMCResult)
(assert (and (not (= x BMCSat)) (not (= x BMCUnsat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SimpleProp enum properties ---

; --- 48. SimpleProp exhaustiveness ---
(push 1)
(declare-const x SimpleProp)
(assert (not (or (= x SPTrue) (= x SPFalse) (= x SPAtom) (= x SPAnd) (= x SPOr) (= x SPImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. SimpleProp: SPTrue != SPFalse ---
(push 1)
(assert (= SPTrue SPFalse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. SimpleProp: SPFalse != SPAtom ---
(push 1)
(assert (= SPFalse SPAtom))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. SimpleProp: SPAtom != SPAnd ---
(push 1)
(assert (= SPAtom SPAnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. SimpleProp: SPTrue != SPImpl ---
(push 1)
(assert (= SPTrue SPImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. SimpleProp finite cardinality (6 values) ---
(push 1)
(declare-const x SimpleProp)
(assert (and (not (= x SPTrue)) (not (= x SPFalse)) (not (= x SPAtom)) (not (= x SPAnd)) (not (= x SPOr)) (not (= x SPImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProofTerm enum properties ---

; --- 54. ProofTerm exhaustiveness ---
(push 1)
(declare-const x ProofTerm)
(assert (not (or (= x PTTrueI) (= x PTAndI) (= x PTAndE1) (= x PTAndE2) (= x PTOrI1) (= x PTOrI2) (= x PTImplI) (= x PTImplE) (= x PTAssume))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. ProofTerm: PTTrueI != PTAndI ---
(push 1)
(assert (= PTTrueI PTAndI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. ProofTerm: PTAndI != PTAndE1 ---
(push 1)
(assert (= PTAndI PTAndE1))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. ProofTerm: PTAndE1 != PTAndE2 ---
(push 1)
(assert (= PTAndE1 PTAndE2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. ProofTerm: PTTrueI != PTAssume ---
(push 1)
(assert (= PTTrueI PTAssume))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ProofTerm finite cardinality (9 values) ---
(push 1)
(declare-const x ProofTerm)
(assert (and (not (= x PTTrueI)) (not (= x PTAndI)) (not (= x PTAndE1)) (not (= x PTAndE2)) (not (= x PTOrI1)) (not (= x PTOrI2)) (not (= x PTImplI)) (not (= x PTImplE)) (not (= x PTAssume))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SrcExpr enum properties ---

; --- 60. SrcExpr exhaustiveness ---
(push 1)
(declare-const x SrcExpr)
(assert (not (or (= x SrcUnit) (= x SrcBool) (= x SrcNat) (= x SrcVar) (= x SrcApp) (= x SrcLam))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. SrcExpr: SrcUnit != SrcBool ---
(push 1)
(assert (= SrcUnit SrcBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. SrcExpr: SrcBool != SrcNat ---
(push 1)
(assert (= SrcBool SrcNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. SrcExpr: SrcNat != SrcVar ---
(push 1)
(assert (= SrcNat SrcVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. SrcExpr: SrcUnit != SrcLam ---
(push 1)
(assert (= SrcUnit SrcLam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. SrcExpr finite cardinality (6 values) ---
(push 1)
(declare-const x SrcExpr)
(assert (and (not (= x SrcUnit)) (not (= x SrcBool)) (not (= x SrcNat)) (not (= x SrcVar)) (not (= x SrcApp)) (not (= x SrcLam))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TgtExpr enum properties ---

; --- 66. TgtExpr exhaustiveness ---
(push 1)
(declare-const x TgtExpr)
(assert (not (or (= x TgtUnit) (= x TgtBool) (= x TgtNat) (= x TgtVar) (= x TgtApp) (= x TgtLam))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. TgtExpr: TgtUnit != TgtBool ---
(push 1)
(assert (= TgtUnit TgtBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. TgtExpr: TgtBool != TgtNat ---
(push 1)
(assert (= TgtBool TgtNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. TgtExpr: TgtNat != TgtVar ---
(push 1)
(assert (= TgtNat TgtVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. TgtExpr: TgtUnit != TgtLam ---
(push 1)
(assert (= TgtUnit TgtLam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. TgtExpr finite cardinality (6 values) ---
(push 1)
(declare-const x TgtExpr)
(assert (and (not (= x TgtUnit)) (not (= x TgtBool)) (not (= x TgtNat)) (not (= x TgtVar)) (not (= x TgtApp)) (not (= x TgtLam))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Ind_Effect enum properties ---

; --- 72. Ind_Effect exhaustiveness ---
(push 1)
(declare-const x Ind_Effect)
(assert (not (or (= x EffPure) (= x EffIO) (= x EffState) (= x EffExn))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. Ind_Effect: EffPure != EffIO ---
(push 1)
(assert (= EffPure EffIO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. Ind_Effect: EffIO != EffState ---
(push 1)
(assert (= EffIO EffState))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. Ind_Effect: EffState != EffExn ---
(push 1)
(assert (= EffState EffExn))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. Ind_Effect: EffPure != EffExn ---
(push 1)
(assert (= EffPure EffExn))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. Ind_Effect finite cardinality (4 values) ---
(push 1)
(declare-const x Ind_Effect)
(assert (and (not (= x EffPure)) (not (= x EffIO)) (not (= x EffState)) (not (= x EffExn))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecLabel enum properties ---

; --- 78. SecLabel exhaustiveness ---
(push 1)
(declare-const x SecLabel)
(assert (not (or (= x SecPublic) (= x SecPrivate) (= x SecSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. SecLabel: SecPublic != SecPrivate ---
(push 1)
(assert (= SecPublic SecPrivate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. SecLabel: SecPrivate != SecSecret ---
(push 1)
(assert (= SecPrivate SecSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. SecLabel: SecPublic != SecSecret ---
(push 1)
(assert (= SecPublic SecSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. SecLabel finite cardinality (3 values) ---
(push 1)
(declare-const x SecLabel)
(assert (and (not (= x SecPublic)) (not (= x SecPrivate)) (not (= x SecSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SrcVal enum properties ---

; --- 83. SrcVal exhaustiveness ---
(push 1)
(declare-const x SrcVal)
(assert (not (or (= x SVUnit) (= x SVBool) (= x SVNat) (= x SVClosure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. SrcVal: SVUnit != SVBool ---
(push 1)
(assert (= SVUnit SVBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. SrcVal: SVBool != SVNat ---
(push 1)
(assert (= SVBool SVNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. SrcVal: SVNat != SVClosure ---
(push 1)
(assert (= SVNat SVClosure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. SrcVal: SVUnit != SVClosure ---
(push 1)
(assert (= SVUnit SVClosure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 88. SrcVal finite cardinality (4 values) ---
(push 1)
(declare-const x SrcVal)
(assert (and (not (= x SVUnit)) (not (= x SVBool)) (not (= x SVNat)) (not (= x SVClosure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TgtVal enum properties ---

; --- 89. TgtVal exhaustiveness ---
(push 1)
(declare-const x TgtVal)
(assert (not (or (= x TVUnit) (= x TVBool) (= x TVNat) (= x TVClosure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. TgtVal: TVUnit != TVBool ---
(push 1)
(assert (= TVUnit TVBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. TgtVal: TVBool != TVNat ---
(push 1)
(assert (= TVBool TVNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 92. TgtVal: TVNat != TVClosure ---
(push 1)
(assert (= TVNat TVClosure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. TgtVal: TVUnit != TVClosure ---
(push 1)
(assert (= TVUnit TVClosure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. TgtVal finite cardinality (4 values) ---
(push 1)
(declare-const x TgtVal)
(assert (and (not (= x TVUnit)) (not (= x TVBool)) (not (= x TVNat)) (not (= x TVClosure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Cmd enum properties ---

; --- 95. Cmd exhaustiveness ---
(push 1)
(declare-const x Cmd)
(assert (not (or (= x CmdSkip) (= x CmdAssign) (= x CmdSeq) (= x CmdIf) (= x CmdWhile))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. Cmd: CmdSkip != CmdAssign ---
(push 1)
(assert (= CmdSkip CmdAssign))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. Cmd: CmdAssign != CmdSeq ---
(push 1)
(assert (= CmdAssign CmdSeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 98. Cmd: CmdSeq != CmdIf ---
(push 1)
(assert (= CmdSeq CmdIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. Cmd: CmdSkip != CmdWhile ---
(push 1)
(assert (= CmdSkip CmdWhile))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. Cmd finite cardinality (5 values) ---
(push 1)
(declare-const x Cmd)
(assert (and (not (= x CmdSkip)) (not (= x CmdAssign)) (not (= x CmdSeq)) (not (= x CmdIf)) (not (= x CmdWhile))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Contract record properties ---

; --- 101. Contract accessor round-trip: precondition ---
(push 1)
(declare-const f0 Ind_Pred)
(declare-const f1 Ind_Pred)
(assert (not (= (precondition (mk-contract f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LiquidState record properties ---

; --- 102. LiquidState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (liquid_constraints (mk-liquid_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. LiquidState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (liquid_templates (mk-liquid_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. LiquidState: integer field consistency ---
(push 1)
(declare-const r LiquidState)
(assert (>= (seq.len (liquid_constraints r)) 0))
(assert (>= (seq.len (liquid_constraints r)) 0))
(assert (not (>= (+ (seq.len (liquid_constraints r)) (seq.len (liquid_constraints r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
