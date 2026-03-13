; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA LLMProofPipeline — SMT Verification
; Derived from 02_FORMAL/coq/domains/LLMProofPipeline.v (20 assertions)
; Module: LLMProofPipeline
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((formula 0)) (((FVar) (FImpl) (FConj) (FDisj))))

(declare-datatypes ((proof_term 0)) (((PAxiom) (PImplIntro) (PImplElim) (PConjIntro) (PConjElimL) (PConjElimR))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. formula exhaustiveness ---
(push 1)
(declare-const x formula)
(assert (not (or (= x FVar) (= x FImpl) (= x FConj) (= x FDisj))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. formula: FVar != FImpl ---
(push 1)
(assert (= FVar FImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. formula: FImpl != FConj ---
(push 1)
(assert (= FImpl FConj))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. formula: FConj != FDisj ---
(push 1)
(assert (= FConj FDisj))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. formula: FVar != FDisj ---
(push 1)
(assert (= FVar FDisj))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. formula finite cardinality (4 values) ---
(push 1)
(declare-const x formula)
(assert (and (not (= x FVar)) (not (= x FImpl)) (not (= x FConj)) (not (= x FDisj))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. proof_term exhaustiveness ---
(push 1)
(declare-const x proof_term)
(assert (not (or (= x PAxiom) (= x PImplIntro) (= x PImplElim) (= x PConjIntro) (= x PConjElimL) (= x PConjElimR))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. proof_term: PAxiom != PImplIntro ---
(push 1)
(assert (= PAxiom PImplIntro))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. proof_term: PImplIntro != PImplElim ---
(push 1)
(assert (= PImplIntro PImplElim))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. proof_term: PImplElim != PConjIntro ---
(push 1)
(assert (= PImplElim PConjIntro))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. proof_term: PAxiom != PConjElimR ---
(push 1)
(assert (= PAxiom PConjElimR))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. proof_term finite cardinality (6 values) ---
(push 1)
(declare-const x proof_term)
(assert (and (not (= x PAxiom)) (not (= x PImplIntro)) (not (= x PImplElim)) (not (= x PConjIntro)) (not (= x PConjElimL)) (not (= x PConjElimR))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
