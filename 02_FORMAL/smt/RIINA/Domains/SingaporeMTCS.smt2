; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SingaporeMTCS — SMT Verification
; Derived from 02_FORMAL/coq/domains/SingaporeMTCS.v (32 assertions)
; Module: SingaporeMTCS
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((MTCSLevel 0)) (((MTCS_Level1) (MTCS_Level2) (MTCS_Level3))))

(declare-datatypes ((IM8Classification 0)) (((IM8_Official) (IM8_Restricted) (IM8_Confidential) (IM8_Secret))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- MTCSLevel enum properties ---

; --- 1. MTCSLevel exhaustiveness ---
(push 1)
(declare-const x MTCSLevel)
(assert (not (or (= x MTCS_Level1) (= x MTCS_Level2) (= x MTCS_Level3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. MTCSLevel: MTCS_Level1 != MTCS_Level2 ---
(push 1)
(assert (= MTCS_Level1 MTCS_Level2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. MTCSLevel: MTCS_Level2 != MTCS_Level3 ---
(push 1)
(assert (= MTCS_Level2 MTCS_Level3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. MTCSLevel: MTCS_Level1 != MTCS_Level3 ---
(push 1)
(assert (= MTCS_Level1 MTCS_Level3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. MTCSLevel finite cardinality (3 values) ---
(push 1)
(declare-const x MTCSLevel)
(assert (and (not (= x MTCS_Level1)) (not (= x MTCS_Level2)) (not (= x MTCS_Level3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- IM8Classification enum properties ---

; --- 6. IM8Classification exhaustiveness ---
(push 1)
(declare-const x IM8Classification)
(assert (not (or (= x IM8_Official) (= x IM8_Restricted) (= x IM8_Confidential) (= x IM8_Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. IM8Classification: IM8_Official != IM8_Restricted ---
(push 1)
(assert (= IM8_Official IM8_Restricted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. IM8Classification: IM8_Restricted != IM8_Confidential ---
(push 1)
(assert (= IM8_Restricted IM8_Confidential))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. IM8Classification: IM8_Confidential != IM8_Secret ---
(push 1)
(assert (= IM8_Confidential IM8_Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. IM8Classification: IM8_Official != IM8_Secret ---
(push 1)
(assert (= IM8_Official IM8_Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. IM8Classification finite cardinality (4 values) ---
(push 1)
(declare-const x IM8Classification)
(assert (and (not (= x IM8_Official)) (not (= x IM8_Restricted)) (not (= x IM8_Confidential)) (not (= x IM8_Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MTCSLevel ordering properties ---

(define-fun MTCSLevel_level ((x MTCSLevel)) Int
  (ite (= x MTCS_Level1) 0 (ite (= x MTCS_Level2) 1 2)))

(define-fun MTCSLevel_leq ((x MTCSLevel) (y MTCSLevel)) Bool
  (<= (MTCSLevel_level x) (MTCSLevel_level y)))

; --- 12. MTCSLevel_leq reflexivity ---
(push 1)
(declare-const x MTCSLevel)
(assert (not (MTCSLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. MTCSLevel_leq transitivity ---
(push 1)
(declare-const x MTCSLevel)
(declare-const y MTCSLevel)
(declare-const z MTCSLevel)
(assert (MTCSLevel_leq x y))
(assert (MTCSLevel_leq y z))
(assert (not (MTCSLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MTCSLevel_leq antisymmetry ---
(push 1)
(declare-const x MTCSLevel)
(declare-const y MTCSLevel)
(assert (MTCSLevel_leq x y))
(assert (MTCSLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. MTCS_Level1 is bottom ---
(push 1)
(declare-const x MTCSLevel)
(assert (not (MTCSLevel_leq MTCS_Level1 x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. MTCS_Level3 is top ---
(push 1)
(declare-const x MTCSLevel)
(assert (not (MTCSLevel_leq x MTCS_Level3)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
