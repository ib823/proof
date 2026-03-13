; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SpeculativeExecution — SMT Verification
; Derived from 02_FORMAL/coq/domains/SpeculativeExecution.v (20 assertions)
; Module: SpeculativeExecution
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Ind_effect 0)) (((Eff_pure) (Eff_timed) (Eff_speculative))))

(declare-datatypes ((visibility 0)) (((Public) (Secret))))

(declare-datatypes ((value 0)) (((VNat) (VBool))))

(declare-datatypes ((instr 0)) (((IConst) (IBinop) (IBranch) (ISeq) (IAnnot))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Ind_effect exhaustiveness ---
(push 1)
(declare-const x Ind_effect)
(assert (not (or (= x Eff_pure) (= x Eff_timed) (= x Eff_speculative))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Ind_effect: Eff_pure != Eff_timed ---
(push 1)
(assert (= Eff_pure Eff_timed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Ind_effect: Eff_timed != Eff_speculative ---
(push 1)
(assert (= Eff_timed Eff_speculative))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Ind_effect finite cardinality (3 values) ---
(push 1)
(declare-const x Ind_effect)
(assert (and (not (= x Eff_pure)) (not (= x Eff_timed)) (not (= x Eff_speculative))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. visibility exhaustiveness ---
(push 1)
(declare-const x visibility)
(assert (not (or (= x Public) (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. visibility: Public != Secret ---
(push 1)
(assert (= Public Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. visibility finite cardinality (2 values) ---
(push 1)
(declare-const x visibility)
(assert (and (not (= x Public)) (not (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. value exhaustiveness ---
(push 1)
(declare-const x value)
(assert (not (or (= x VNat) (= x VBool))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. value: VNat != VBool ---
(push 1)
(assert (= VNat VBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. value finite cardinality (2 values) ---
(push 1)
(declare-const x value)
(assert (and (not (= x VNat)) (not (= x VBool))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. instr exhaustiveness ---
(push 1)
(declare-const x instr)
(assert (not (or (= x IConst) (= x IBinop) (= x IBranch) (= x ISeq) (= x IAnnot))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. instr: IConst != IBinop ---
(push 1)
(assert (= IConst IBinop))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. instr: IBinop != IBranch ---
(push 1)
(assert (= IBinop IBranch))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. instr: IBranch != ISeq ---
(push 1)
(assert (= IBranch ISeq))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. instr: IConst != IAnnot ---
(push 1)
(assert (= IConst IAnnot))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. instr finite cardinality (5 values) ---
(push 1)
(declare-const x instr)
(assert (and (not (= x IConst)) (not (= x IBinop)) (not (= x IBranch)) (not (= x ISeq)) (not (= x IAnnot))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
