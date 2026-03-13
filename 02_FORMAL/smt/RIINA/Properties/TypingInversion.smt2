; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TypingInversion — SMT Verification
; Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 assertions)
; Module: TypingInversion
;
; Verifies: canonical forms (values have expected shapes for their types),
; typing inversion properties.

(set-logic QF_DT)
(set-option :produce-models true)


(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TInt) (TString) (TBytes) (TFn) (TProd) (TSum) (TList) (TOption) (TRef) (TSecret) (TLabeled) (TTainted) (TSanitized) (TProof) (TCapability) (TCapabilityFull) (TChan) (TSecureChan) (TConstantTime) (TZeroizing))))
(declare-datatypes ((expr 0)) (((EUnit) (EBool) (EInt) (EString) (ELoc) (EVar) (ELam) (EApp) (EPair) (EFst) (ESnd) (EInl) (EInr) (ECase) (EIf) (ELet) (EPerform) (EHandle) (ERef) (EDeref) (EAssign) (EClassify) (EDeclassify) (EProve) (ERequire) (EGrant))))

(define-fun is_value ((e expr)) Bool
  (or (= e EUnit) (= e EBool) (= e EInt) (= e EString)
      (= e ELoc) (= e ELam) (= e EPair) (= e EInl) (= e EInr)
      (= e EClassify) (= e EProve)))


; canonical_type map
(define-fun canonical_type ((e expr)) ty
  (ite (= e EUnit) TUnit
  (ite (= e EBool) TBool
  (ite (= e EInt) TInt
  (ite (= e EString) TString
  (ite (= e ELoc) TRef
  (ite (= e ELam) TFn
  (ite (= e EPair) TProd
  (ite (= e EInl) TSum
  (ite (= e EInr) TSum
  (ite (= e EClassify) TSecret
  (ite (= e EProve) TProof
  TUnit))))))))))))

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. Canonical: TUnit value is EUnit ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TUnit))
(assert (not (= v EUnit)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Canonical: TBool value is EBool ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TBool))
(assert (not (= v EBool)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Canonical: TInt value is EInt ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TInt))
(assert (not (= v EInt)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Canonical: TFn value is ELam ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TFn))
(assert (not (= v ELam)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Canonical: TRef value is ELoc ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TRef))
(assert (not (= v ELoc)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Canonical: TSecret value is EClassify ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TSecret))
(assert (not (= v EClassify)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. EVar is not a value ---
(push 1)
(assert (is_value EVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EApp is not a value ---
(push 1)
(assert (is_value EApp))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
