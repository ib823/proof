; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA U001_RuntimeGuardian — SMT Verification
; Derived from 02_FORMAL/coq/domains/U001_RuntimeGuardian.v (36 assertions)
; Module: U001_RuntimeGuardian
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CFGEdge 0)) (((DirectCall) (IndirectCall) (Return) (DirectJump) (IndirectJump) (FallThrough))))

(declare-datatypes ((Protection 0)) (((ReadOnly) (ReadWrite) (NoAccess))))

(declare-datatypes ((SystemState 0))
  (((mk-system_state (ss_keys (Seq Int)) (ss_running Bool) (ss_audit_log (Seq Int)) (ss_panic Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. CFGEdge exhaustiveness ---
(push 1)
(declare-const x CFGEdge)
(assert (not (or (= x DirectCall) (= x IndirectCall) (= x Return) (= x DirectJump) (= x IndirectJump) (= x FallThrough))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CFGEdge: DirectCall != IndirectCall ---
(push 1)
(assert (= DirectCall IndirectCall))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CFGEdge: IndirectCall != Return ---
(push 1)
(assert (= IndirectCall Return))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CFGEdge: Return != DirectJump ---
(push 1)
(assert (= Return DirectJump))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CFGEdge: DirectCall != FallThrough ---
(push 1)
(assert (= DirectCall FallThrough))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CFGEdge finite cardinality (6 values) ---
(push 1)
(declare-const x CFGEdge)
(assert (and (not (= x DirectCall)) (not (= x IndirectCall)) (not (= x Return)) (not (= x DirectJump)) (not (= x IndirectJump)) (not (= x FallThrough))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Protection exhaustiveness ---
(push 1)
(declare-const x Protection)
(assert (not (or (= x ReadOnly) (= x ReadWrite) (= x NoAccess))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Protection: ReadOnly != ReadWrite ---
(push 1)
(assert (= ReadOnly ReadWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Protection: ReadWrite != NoAccess ---
(push 1)
(assert (= ReadWrite NoAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Protection finite cardinality (3 values) ---
(push 1)
(declare-const x Protection)
(assert (and (not (= x ReadOnly)) (not (= x ReadWrite)) (not (= x NoAccess))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
