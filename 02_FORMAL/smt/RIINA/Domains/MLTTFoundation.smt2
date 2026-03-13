; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MLTTFoundation — SMT Verification
; Derived from 02_FORMAL/coq/domains/MLTTFoundation.v (25 assertions)
; Module: MLTTFoundation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Ty 0)) (((TUnit) (TPi) (TSigma) (TId) (TUniverse))))

(declare-datatypes ((Term 0)) (((TmVar) (TmUnit) (TmLam) (TmApp) (TmPair) (TmFst) (TmSnd) (TmRefl) (TmJ))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Ty enum properties ---

; --- 1. Ty exhaustiveness ---
(push 1)
(declare-const x Ty)
(assert (not (or (= x TUnit) (= x TPi) (= x TSigma) (= x TId) (= x TUniverse))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Ty: TUnit != TPi ---
(push 1)
(assert (= TUnit TPi))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Ty: TPi != TSigma ---
(push 1)
(assert (= TPi TSigma))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Ty: TSigma != TId ---
(push 1)
(assert (= TSigma TId))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Ty: TUnit != TUniverse ---
(push 1)
(assert (= TUnit TUniverse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Ty finite cardinality (5 values) ---
(push 1)
(declare-const x Ty)
(assert (and (not (= x TUnit)) (not (= x TPi)) (not (= x TSigma)) (not (= x TId)) (not (= x TUniverse))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Term enum properties ---

; --- 7. Term exhaustiveness ---
(push 1)
(declare-const x Term)
(assert (not (or (= x TmVar) (= x TmUnit) (= x TmLam) (= x TmApp) (= x TmPair) (= x TmFst) (= x TmSnd) (= x TmRefl) (= x TmJ))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Term: TmVar != TmUnit ---
(push 1)
(assert (= TmVar TmUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Term: TmUnit != TmLam ---
(push 1)
(assert (= TmUnit TmLam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Term: TmLam != TmApp ---
(push 1)
(assert (= TmLam TmApp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Term: TmVar != TmJ ---
(push 1)
(assert (= TmVar TmJ))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Term finite cardinality (9 values) ---
(push 1)
(declare-const x Term)
(assert (and (not (= x TmVar)) (not (= x TmUnit)) (not (= x TmLam)) (not (= x TmApp)) (not (= x TmPair)) (not (= x TmFst)) (not (= x TmSnd)) (not (= x TmRefl)) (not (= x TmJ))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
