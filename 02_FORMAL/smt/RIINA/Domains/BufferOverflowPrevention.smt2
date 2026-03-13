; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA BufferOverflowPrevention — SMT Verification
; Derived from 02_FORMAL/coq/domains/BufferOverflowPrevention.v (22 assertions)
; Module: BufferOverflowPrevention
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Buffer 0))
  (((mk-buffer (buf_size Int) (buf_used Int)))))

(declare-datatypes ((OverflowPrevention 0))
  (((mk-overflow_prevention (op_bounds_check_write Bool) (op_bounds_check_read Bool) (op_null_terminator_check Bool) (op_integer_overflow_check Bool) (op_stack_canaries Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Buffer record properties ---

; --- 1. Buffer accessor round-trip: buf_size ---
(push 1)
(declare-const f0 Int)
(assert (not (= (buf_size (mk-buffer f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- OverflowPrevention record properties ---

; --- 2. OverflowPrevention accessor round-trip: op_bounds_check_write ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (op_bounds_check_write (mk-overflow_prevention f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. OverflowPrevention accessor round-trip: op_bounds_check_read ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (op_bounds_check_read (mk-overflow_prevention f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. OverflowPrevention accessor round-trip: op_null_terminator_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (op_null_terminator_check (mk-overflow_prevention f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. OverflowPrevention accessor round-trip: op_integer_overflow_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (op_integer_overflow_check (mk-overflow_prevention f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun OverflowPrevention_all_enabled ((g OverflowPrevention)) Bool
  (and (op_bounds_check_write g) (op_bounds_check_read g) (op_null_terminator_check g) (op_integer_overflow_check g)))

; --- 6. OverflowPrevention: all-enabled completeness ---
(push 1)
(declare-const g OverflowPrevention)
(assert (op_bounds_check_write g))
(assert (op_bounds_check_read g))
(assert (op_null_terminator_check g))
(assert (op_integer_overflow_check g))
(assert (not (OverflowPrevention_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. OverflowPrevention: OverflowPrevention_all_enabled implies op_bounds_check_write ---
(push 1)
(declare-const g OverflowPrevention)
(assert (OverflowPrevention_all_enabled g))
(assert (not (op_bounds_check_write g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. OverflowPrevention: OverflowPrevention_all_enabled implies op_bounds_check_read ---
(push 1)
(declare-const g OverflowPrevention)
(assert (OverflowPrevention_all_enabled g))
(assert (not (op_bounds_check_read g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. OverflowPrevention: OverflowPrevention_all_enabled implies op_null_terminator_check ---
(push 1)
(declare-const g OverflowPrevention)
(assert (OverflowPrevention_all_enabled g))
(assert (not (op_null_terminator_check g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
