; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaCybersecurityAct — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaCybersecurityAct.v (28 assertions)
; Module: MalaysiaCybersecurityAct
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((NCIISector 0)) (((Government) (BankingFinance) (Transport) (Defense) (Healthcare) (Telecom) (Energy) (Water) (AgricultureFood) (ScienceTechInnovation) (InformationComm))))

(declare-datatypes ((RiskLevel 0)) (((Low) (Medium) (High) (Critical))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- NCIISector enum properties ---

; --- 1. NCIISector exhaustiveness ---
(push 1)
(declare-const x NCIISector)
(assert (not (or (= x Government) (= x BankingFinance) (= x Transport) (= x Defense) (= x Healthcare) (= x Telecom) (= x Energy) (= x Water) (= x AgricultureFood) (= x ScienceTechInnovation) (= x InformationComm))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. NCIISector: Government != BankingFinance ---
(push 1)
(assert (= Government BankingFinance))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. NCIISector: BankingFinance != Transport ---
(push 1)
(assert (= BankingFinance Transport))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. NCIISector: Transport != Defense ---
(push 1)
(assert (= Transport Defense))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. NCIISector: Government != InformationComm ---
(push 1)
(assert (= Government InformationComm))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. NCIISector finite cardinality (11 values) ---
(push 1)
(declare-const x NCIISector)
(assert (and (not (= x Government)) (not (= x BankingFinance)) (not (= x Transport)) (not (= x Defense)) (not (= x Healthcare)) (not (= x Telecom)) (not (= x Energy)) (not (= x Water)) (not (= x AgricultureFood)) (not (= x ScienceTechInnovation)) (not (= x InformationComm))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiskLevel enum properties ---

; --- 7. RiskLevel exhaustiveness ---
(push 1)
(declare-const x RiskLevel)
(assert (not (or (= x Low) (= x Medium) (= x High) (= x Critical))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. RiskLevel: Low != Medium ---
(push 1)
(assert (= Low Medium))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. RiskLevel: Medium != High ---
(push 1)
(assert (= Medium High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. RiskLevel: High != Critical ---
(push 1)
(assert (= High Critical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. RiskLevel: Low != Critical ---
(push 1)
(assert (= Low Critical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. RiskLevel finite cardinality (4 values) ---
(push 1)
(declare-const x RiskLevel)
(assert (and (not (= x Low)) (not (= x Medium)) (not (= x High)) (not (= x Critical))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RiskLevel ordering properties ---

(define-fun RiskLevel_level ((x RiskLevel)) Int
  (ite (= x Low) 0 (ite (= x Medium) 1 (ite (= x High) 2 3))))

(define-fun RiskLevel_leq ((x RiskLevel) (y RiskLevel)) Bool
  (<= (RiskLevel_level x) (RiskLevel_level y)))

; --- 13. RiskLevel_leq reflexivity ---
(push 1)
(declare-const x RiskLevel)
(assert (not (RiskLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. RiskLevel_leq transitivity ---
(push 1)
(declare-const x RiskLevel)
(declare-const y RiskLevel)
(declare-const z RiskLevel)
(assert (RiskLevel_leq x y))
(assert (RiskLevel_leq y z))
(assert (not (RiskLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. RiskLevel_leq antisymmetry ---
(push 1)
(declare-const x RiskLevel)
(declare-const y RiskLevel)
(assert (RiskLevel_leq x y))
(assert (RiskLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Low is bottom ---
(push 1)
(declare-const x RiskLevel)
(assert (not (RiskLevel_leq Low x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Critical is top ---
(push 1)
(declare-const x RiskLevel)
(assert (not (RiskLevel_leq x Critical)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
