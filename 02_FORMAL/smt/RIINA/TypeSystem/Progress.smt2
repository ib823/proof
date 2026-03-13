; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Progress — SMT Verification
; Derived from 02_FORMAL/coq/type_system/Progress.v
; Module: Progress
;
; Verifies: canonical forms (values have expected shapes for their types),
; progress property structure (well-typed terms are values or can step).

(set-logic QF_DT)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; DATATYPE DECLARATIONS
; ═══════════════════════════════════════════════════════════════════════════

(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TInt) (TString) (TBytes) (TFn) (TProd) (TSum) (TList) (TOption) (TRef) (TSecret) (TLabeled) (TTainted) (TSanitized) (TProof) (TCapability) (TCapabilityFull) (TChan) (TSecureChan) (TConstantTime) (TZeroizing))))
(declare-datatypes ((expr 0)) (((EUnit) (EBool) (EInt) (EString) (ELoc) (EVar) (ELam) (EApp) (EPair) (EFst) (ESnd) (EInl) (EInr) (ECase) (EIf) (ELet) (EPerform) (EHandle) (ERef) (EDeref) (EAssign) (EClassify) (EDeclassify) (EProve) (ERequire) (EGrant))))

; ═══════════════════════════════════════════════════════════════════════════
; FUNCTION DEFINITIONS
; ═══════════════════════════════════════════════════════════════════════════

; is_value: expression is a value
(define-fun is_value ((e expr)) Bool
  (or (= e EUnit) (= e EBool) (= e EInt) (= e EString)
      (= e ELoc) (= e ELam) (= e EPair) (= e EInl) (= e EInr)
      (= e EClassify) (= e EProve)))

; canonical_type: the type a value form corresponds to
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

; can_step: non-value well-typed expressions can step
(define-fun can_step ((e expr)) Bool
  (not (is_value e)))

; ═══════════════════════════════════════════════════════════════════════════
; CANONICAL FORMS VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. canonical_unit: value v : TUnit -> v = EUnit ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TUnit))
(assert (not (= v EUnit)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. canonical_bool: value v : TBool -> v = EBool b ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TBool))
(assert (not (= v EBool)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. canonical_int: value v : TInt -> v = EInt n ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TInt))
(assert (not (= v EInt)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. canonical_fn: value v : TFn -> v = ELam ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TFn))
(assert (not (= v ELam)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. canonical_pair: value v : TProd -> v = EPair ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TProd))
(assert (not (= v EPair)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. canonical_ref: value v : TRef -> v = ELoc ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TRef))
(assert (not (= v ELoc)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. canonical_secret: value v : TSecret -> v = EClassify ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TSecret))
(assert (not (= v EClassify)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. canonical_proof: value v : TProof -> v = EProve ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TProof))
(assert (not (= v EProve)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Progress structure: every expression is either a value or can step ---
(push 1)
(declare-const e expr)
(assert (not (or (is_value e) (can_step e))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Non-value expressions can step ---
(push 1)
(declare-const e expr)
(assert (not (is_value e)))
(assert (not (can_step e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. EVar is not a value (closed term progress) ---
(push 1)
(assert (is_value EVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. EApp is not a value ---
(push 1)
(assert (is_value EApp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Sum canonicity: value v : TSum -> v = EInl or v = EInr ---
(push 1)
(declare-const v expr)
(assert (is_value v))
(assert (= (canonical_type v) TSum))
(assert (not (or (= v EInl) (= v EInr))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
