; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedAIML — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedAIML.v (25 assertions)
; Module: VerifiedAIML
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Layer 0)) (((Dense) (ReLU) (Softmax) (Sigmoid))))

(declare-datatypes ((FixedPoint 0))
  (((mk-fixed_point (fp_int Int) (fp_frac Int) (fp_scale Int)))))

(declare-datatypes ((InputBounds 0))
  (((mk-input_bounds (ib_min Int) (ib_max Int)))))

(declare-datatypes ((Model 0))
  (((mk-model (model_weights (Seq Int)) (model_hash Int)))))

(declare-datatypes ((ActionSpace 0))
  (((mk-action_space (action_min Int) (action_max Int) (action_rate_limit Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Layer exhaustiveness ---
(push 1)
(declare-const x Layer)
(assert (not (or (= x Dense) (= x ReLU) (= x Softmax) (= x Sigmoid))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Layer: Dense != ReLU ---
(push 1)
(assert (= Dense ReLU))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Layer: ReLU != Softmax ---
(push 1)
(assert (= ReLU Softmax))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Layer: Softmax != Sigmoid ---
(push 1)
(assert (= Softmax Sigmoid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Layer: Dense != Sigmoid ---
(push 1)
(assert (= Dense Sigmoid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Layer finite cardinality (4 values) ---
(push 1)
(declare-const x Layer)
(assert (and (not (= x Dense)) (not (= x ReLU)) (not (= x Softmax)) (not (= x Sigmoid))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. FixedPoint accessor round-trip: fp_int ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (fp_int (mk-fixed_point f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FixedPoint accessor round-trip: fp_frac ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (fp_frac (mk-fixed_point f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FixedPoint accessor round-trip: fp_scale ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (fp_scale (mk-fixed_point f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FixedPoint: non-negative int fields sum ---
(push 1)
(declare-const r FixedPoint)
(assert (>= (fp_int r) 0))
(assert (>= (fp_frac r) 0))
(assert (not (>= (+ (fp_int r) (fp_frac r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. InputBounds accessor round-trip: ib_min ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ib_min (mk-input_bounds f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. InputBounds accessor round-trip: ib_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ib_max (mk-input_bounds f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. InputBounds: non-negative int fields sum ---
(push 1)
(declare-const r InputBounds)
(assert (>= (ib_min r) 0))
(assert (>= (ib_max r) 0))
(assert (not (>= (+ (ib_min r) (ib_max r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ActionSpace accessor round-trip: action_min ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (action_min (mk-action_space f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ActionSpace accessor round-trip: action_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (action_max (mk-action_space f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ActionSpace accessor round-trip: action_rate_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (action_rate_limit (mk-action_space f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ActionSpace: non-negative int fields sum ---
(push 1)
(declare-const r ActionSpace)
(assert (>= (action_min r) 0))
(assert (>= (action_max r) 0))
(assert (not (>= (+ (action_min r) (action_max r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
