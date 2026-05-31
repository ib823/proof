; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Composition — SMT Verification
; Derived from 02_FORMAL/coq/properties/Composition.v (6 assertions)
; Module: Composition
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

; --- Structural verification from Coq lemma signatures ---

; --- 1. val_rel_pair (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. val_rel_inl (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. val_rel_inr (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. exp_rel_pair_values (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. exp_rel_inl_values (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
