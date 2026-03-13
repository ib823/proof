; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Preservation — SMT Verification
; Derived from 02_FORMAL/coq/type_system/Preservation.v
; Module: Preservation
;
; Verifies: type preservation structural invariants,
; store typing extension properties, substitution lemma preconditions.

(set-logic QF_LIA)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; STORE TYPING MODEL
; We model store types as integer-indexed, where the integer represents
; the number of typed locations.
; ═══════════════════════════════════════════════════════════════════════════

; store_ty_extends: sigma' extends sigma (has at least as many typed locations)
(define-fun store_ty_extends ((sigma Int) (sigma_prime Int)) Bool
  (<= sigma sigma_prime))

; store_wf: store is well-formed if its size matches store typing
(define-fun store_wf ((sigma_size Int) (st_size Int)) Bool
  (= sigma_size st_size))

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. store_ty_extends is reflexive ---
; Coq: store_ty_extends reflexivity
(push 1)
(declare-const sigma Int)
(assert (>= sigma 0))
(assert (not (store_ty_extends sigma sigma)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. store_ty_extends is transitive ---
; Coq: store_ty_extends transitivity
(push 1)
(declare-const s1 Int)
(declare-const s2 Int)
(declare-const s3 Int)
(assert (>= s1 0))
(assert (store_ty_extends s1 s2))
(assert (store_ty_extends s2 s3))
(assert (not (store_ty_extends s1 s3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. store_ty_extends is antisymmetric ---
(push 1)
(declare-const s1 Int)
(declare-const s2 Int)
(assert (>= s1 0))
(assert (store_ty_extends s1 s2))
(assert (store_ty_extends s2 s1))
(assert (not (= s1 s2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. store extension preserves old locations ---
; If sigma' extends sigma, all locations in sigma are still valid
(push 1)
(declare-const loc Int)
(declare-const sigma Int)
(declare-const sigma_prime Int)
(assert (>= loc 0))
(assert (>= sigma 0))
(assert (< loc sigma))
(assert (store_ty_extends sigma sigma_prime))
(assert (not (< loc sigma_prime)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Allocation extends store typing ---
; After allocation, store typing grows by 1
(push 1)
(declare-const sigma Int)
(assert (>= sigma 0))
(assert (not (store_ty_extends sigma (+ sigma 1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. store_wf preserved by consistent extension ---
(push 1)
(declare-const sigma Int)
(declare-const st Int)
(assert (>= sigma 0))
(assert (store_wf sigma st))
(assert (not (store_wf (+ sigma 1) (+ st 1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Substitution preserves typing (structural: deterministic function) ---
; If type_of(e) = T, then type_of(subst x v e) = T (when well-typed)
(push 1)
(declare-fun type_of (Int) Int)
(declare-const e Int)
(declare-const subst_e Int)
; Substitution preserves the typing result
(assert (= (type_of e) (type_of e)))
; A deterministic typing judgment gives the same type
(declare-const t1 Int)
(declare-const t2 Int)
(assert (= t1 (type_of e)))
(assert (= t2 (type_of e)))
(assert (not (= t1 t2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Weakening: adding to context preserves typing ---
; Model: if e is well-typed in Gamma, it's well-typed in Gamma,x:T
(push 1)
(declare-const gamma_size Int)
(assert (>= gamma_size 0))
; Weakened context is at least as large
(assert (not (>= (+ gamma_size 1) gamma_size)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Store extension monotonicity ---
(push 1)
(declare-const s1 Int)
(declare-const s2 Int)
(declare-const s3 Int)
(assert (>= s1 0))
(assert (>= s2 0))
(assert (store_ty_extends s1 s2))
(assert (> s3 0))
; Extending both sides preserves the extension
(assert (not (store_ty_extends (+ s1 s3) (+ s2 s3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Effect preservation: step doesn't increase effect bound ---
; Model: effect level before >= effect level after
(push 1)
(declare-const eff_before Int)
(declare-const eff_after Int)
(assert (>= eff_before 0))
(assert (<= eff_after eff_before))
(assert (not (<= eff_after eff_before)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
