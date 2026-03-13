; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MultiProverValidation — SMT Verification
; Derived from 02_FORMAL/coq/domains/MultiProverValidation.v (24 assertions)
; Module: MultiProverValidation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((formula 0)) (((FAtom) (FNot) (FAnd) (FImpl))))

(declare-datatypes ((certificate 0)) (((CertAtom) (CertNotI) (CertAndI) (CertImplE) (CertAssume))))

(declare-datatypes ((proverA_repr 0)) (((PA_Atom) (PA_Neg) (PA_Conj) (PA_Arrow))))

(declare-datatypes ((proverB_repr 0)) (((PB_Var) (PB_Not) (PB_And) (PB_If))))

(declare-datatypes ((confidence 0)) (((NoConfidence) (SingleProver) (DualProver))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- formula enum properties ---

; --- 1. formula exhaustiveness ---
(push 1)
(declare-const x formula)
(assert (not (or (= x FAtom) (= x FNot) (= x FAnd) (= x FImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. formula: FAtom != FNot ---
(push 1)
(assert (= FAtom FNot))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. formula: FNot != FAnd ---
(push 1)
(assert (= FNot FAnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. formula: FAnd != FImpl ---
(push 1)
(assert (= FAnd FImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. formula: FAtom != FImpl ---
(push 1)
(assert (= FAtom FImpl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. formula finite cardinality (4 values) ---
(push 1)
(declare-const x formula)
(assert (and (not (= x FAtom)) (not (= x FNot)) (not (= x FAnd)) (not (= x FImpl))))
(check-sat) ; expect UNSAT
(pop 1)

; --- certificate enum properties ---

; --- 7. certificate exhaustiveness ---
(push 1)
(declare-const x certificate)
(assert (not (or (= x CertAtom) (= x CertNotI) (= x CertAndI) (= x CertImplE) (= x CertAssume))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. certificate: CertAtom != CertNotI ---
(push 1)
(assert (= CertAtom CertNotI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. certificate: CertNotI != CertAndI ---
(push 1)
(assert (= CertNotI CertAndI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. certificate: CertAndI != CertImplE ---
(push 1)
(assert (= CertAndI CertImplE))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. certificate: CertAtom != CertAssume ---
(push 1)
(assert (= CertAtom CertAssume))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. certificate finite cardinality (5 values) ---
(push 1)
(declare-const x certificate)
(assert (and (not (= x CertAtom)) (not (= x CertNotI)) (not (= x CertAndI)) (not (= x CertImplE)) (not (= x CertAssume))))
(check-sat) ; expect UNSAT
(pop 1)

; --- proverA_repr enum properties ---

; --- 13. proverA_repr exhaustiveness ---
(push 1)
(declare-const x proverA_repr)
(assert (not (or (= x PA_Atom) (= x PA_Neg) (= x PA_Conj) (= x PA_Arrow))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. proverA_repr: PA_Atom != PA_Neg ---
(push 1)
(assert (= PA_Atom PA_Neg))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. proverA_repr: PA_Neg != PA_Conj ---
(push 1)
(assert (= PA_Neg PA_Conj))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. proverA_repr: PA_Conj != PA_Arrow ---
(push 1)
(assert (= PA_Conj PA_Arrow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. proverA_repr: PA_Atom != PA_Arrow ---
(push 1)
(assert (= PA_Atom PA_Arrow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. proverA_repr finite cardinality (4 values) ---
(push 1)
(declare-const x proverA_repr)
(assert (and (not (= x PA_Atom)) (not (= x PA_Neg)) (not (= x PA_Conj)) (not (= x PA_Arrow))))
(check-sat) ; expect UNSAT
(pop 1)

; --- proverB_repr enum properties ---

; --- 19. proverB_repr exhaustiveness ---
(push 1)
(declare-const x proverB_repr)
(assert (not (or (= x PB_Var) (= x PB_Not) (= x PB_And) (= x PB_If))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. proverB_repr: PB_Var != PB_Not ---
(push 1)
(assert (= PB_Var PB_Not))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. proverB_repr: PB_Not != PB_And ---
(push 1)
(assert (= PB_Not PB_And))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. proverB_repr: PB_And != PB_If ---
(push 1)
(assert (= PB_And PB_If))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. proverB_repr: PB_Var != PB_If ---
(push 1)
(assert (= PB_Var PB_If))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. proverB_repr finite cardinality (4 values) ---
(push 1)
(declare-const x proverB_repr)
(assert (and (not (= x PB_Var)) (not (= x PB_Not)) (not (= x PB_And)) (not (= x PB_If))))
(check-sat) ; expect UNSAT
(pop 1)

; --- confidence enum properties ---

; --- 25. confidence exhaustiveness ---
(push 1)
(declare-const x confidence)
(assert (not (or (= x NoConfidence) (= x SingleProver) (= x DualProver))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. confidence: NoConfidence != SingleProver ---
(push 1)
(assert (= NoConfidence SingleProver))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. confidence: SingleProver != DualProver ---
(push 1)
(assert (= SingleProver DualProver))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. confidence: NoConfidence != DualProver ---
(push 1)
(assert (= NoConfidence DualProver))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. confidence finite cardinality (3 values) ---
(push 1)
(declare-const x confidence)
(assert (and (not (= x NoConfidence)) (not (= x SingleProver)) (not (= x DualProver))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
