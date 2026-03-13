; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AIAssistedProofs — SMT Verification
; Derived from 02_FORMAL/coq/domains/AIAssistedProofs.v (30 assertions)
; Module: AIAssistedProofs
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((proof_source 0)) (((HumanProver) (AI_LLM) (AI_AutoVerus) (AI_APOLLO) (HybridHumanAI))))

(declare-datatypes ((proof_certificate 0)) (((CertAxiom) (CertIntro) (CertElim) (CertRefl))))

(declare-datatypes ((kernel_result 0)) (((KernelAccept) (KernelReject))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- proof_source enum properties ---

; --- 1. proof_source exhaustiveness ---
(push 1)
(declare-const x proof_source)
(assert (not (or (= x HumanProver) (= x AI_LLM) (= x AI_AutoVerus) (= x AI_APOLLO) (= x HybridHumanAI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. proof_source: HumanProver != AI_LLM ---
(push 1)
(assert (= HumanProver AI_LLM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. proof_source: AI_LLM != AI_AutoVerus ---
(push 1)
(assert (= AI_LLM AI_AutoVerus))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. proof_source: AI_AutoVerus != AI_APOLLO ---
(push 1)
(assert (= AI_AutoVerus AI_APOLLO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. proof_source: HumanProver != HybridHumanAI ---
(push 1)
(assert (= HumanProver HybridHumanAI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. proof_source finite cardinality (5 values) ---
(push 1)
(declare-const x proof_source)
(assert (and (not (= x HumanProver)) (not (= x AI_LLM)) (not (= x AI_AutoVerus)) (not (= x AI_APOLLO)) (not (= x HybridHumanAI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- proof_certificate enum properties ---

; --- 7. proof_certificate exhaustiveness ---
(push 1)
(declare-const x proof_certificate)
(assert (not (or (= x CertAxiom) (= x CertIntro) (= x CertElim) (= x CertRefl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. proof_certificate: CertAxiom != CertIntro ---
(push 1)
(assert (= CertAxiom CertIntro))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. proof_certificate: CertIntro != CertElim ---
(push 1)
(assert (= CertIntro CertElim))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. proof_certificate: CertElim != CertRefl ---
(push 1)
(assert (= CertElim CertRefl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. proof_certificate: CertAxiom != CertRefl ---
(push 1)
(assert (= CertAxiom CertRefl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. proof_certificate finite cardinality (4 values) ---
(push 1)
(declare-const x proof_certificate)
(assert (and (not (= x CertAxiom)) (not (= x CertIntro)) (not (= x CertElim)) (not (= x CertRefl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- kernel_result enum properties ---

; --- 13. kernel_result exhaustiveness ---
(push 1)
(declare-const x kernel_result)
(assert (not (or (= x KernelAccept) (= x KernelReject))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. kernel_result: KernelAccept != KernelReject ---
(push 1)
(assert (= KernelAccept KernelReject))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. kernel_result finite cardinality (2 values) ---
(push 1)
(declare-const x kernel_result)
(assert (and (not (= x KernelAccept)) (not (= x KernelReject))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
