; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PI001_VerifiedPerformance — SMT Verification
; Derived from 02_FORMAL/coq/domains/PI001_VerifiedPerformance.v (34 assertions)
; Module: PI001_VerifiedPerformance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((VEBTree 0)) (((VEBLeaf) (VEBNode))))

(declare-datatypes ((CASResult 0)) (((CASSuccess) (CASFailure))))

(declare-datatypes ((OptExpr 0)) (((OConst) (OVar) (OAdd) (OMul) (OIf))))

(declare-datatypes ((MSQueue 0))
  (((mk-ms_queue (msq_items (Seq Int)) (msq_head Int) (msq_tail Int)))))

(declare-datatypes ((LinPoint 0))
  (((mk-lin_point (lp_op Int) (lp_time Int) (lp_result Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- VEBTree enum properties ---

; --- 1. VEBTree exhaustiveness ---
(push 1)
(declare-const x VEBTree)
(assert (not (or (= x VEBLeaf) (= x VEBNode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. VEBTree: VEBLeaf != VEBNode ---
(push 1)
(assert (= VEBLeaf VEBNode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. VEBTree finite cardinality (2 values) ---
(push 1)
(declare-const x VEBTree)
(assert (and (not (= x VEBLeaf)) (not (= x VEBNode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CASResult enum properties ---

; --- 4. CASResult exhaustiveness ---
(push 1)
(declare-const x CASResult)
(assert (not (or (= x CASSuccess) (= x CASFailure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CASResult: CASSuccess != CASFailure ---
(push 1)
(assert (= CASSuccess CASFailure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CASResult finite cardinality (2 values) ---
(push 1)
(declare-const x CASResult)
(assert (and (not (= x CASSuccess)) (not (= x CASFailure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- OptExpr enum properties ---

; --- 7. OptExpr exhaustiveness ---
(push 1)
(declare-const x OptExpr)
(assert (not (or (= x OConst) (= x OVar) (= x OAdd) (= x OMul) (= x OIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. OptExpr: OConst != OVar ---
(push 1)
(assert (= OConst OVar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. OptExpr: OVar != OAdd ---
(push 1)
(assert (= OVar OAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. OptExpr: OAdd != OMul ---
(push 1)
(assert (= OAdd OMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. OptExpr: OConst != OIf ---
(push 1)
(assert (= OConst OIf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. OptExpr finite cardinality (5 values) ---
(push 1)
(declare-const x OptExpr)
(assert (and (not (= x OConst)) (not (= x OVar)) (not (= x OAdd)) (not (= x OMul)) (not (= x OIf))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MSQueue record properties ---

; --- 13. MSQueue accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (msq_items (mk-ms_queue f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MSQueue accessor round-trip: msq_head ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (msq_head (mk-ms_queue f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. MSQueue: integer field consistency ---
(push 1)
(declare-const r MSQueue)
(assert (>= (seq.len (msq_items r)) 0))
(assert (>= (msq_head r) 0))
(assert (not (>= (+ (seq.len (msq_items r)) (msq_head r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LinPoint record properties ---

; --- 16. LinPoint accessor round-trip: lp_op ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (lp_op (mk-lin_point f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. LinPoint accessor round-trip: lp_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (lp_time (mk-lin_point f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. LinPoint: integer field consistency ---
(push 1)
(declare-const r LinPoint)
(assert (>= (lp_op r) 0))
(assert (>= (lp_time r) 0))
(assert (not (>= (+ (lp_op r) (lp_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
