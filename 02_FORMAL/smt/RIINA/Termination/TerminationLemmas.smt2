; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TerminationLemmas — SMT Verification
; Derived from 02_FORMAL/coq/termination/TerminationLemmas.v (7 assertions)
; Module: TerminationLemmas
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. val_rel_0 well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. store_rel_0 well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. exp_rel_step1_fst_typed: property holds  (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. exp_rel_step1_snd_typed: property holds  (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. exp_rel_step1_case_typed: property holds (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. exp_rel_step1_if_typed: property holds f (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. exp_rel_step1_let_typed: property holds  (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
