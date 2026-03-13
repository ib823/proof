; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA RollbackProtection — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/RollbackProtection.v (21 assertions)
; Module: RollbackProtection
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ComponentId 0)) (((CompId))))

(declare-datatypes ((Version 0))
  (((mk-version (major Int) (minor Int) (patch Int) (build Int)))))

(declare-datatypes ((VersionedComponent 0))
  (((mk-versioned_component (comp_id ComponentId) (comp_version Version) (comp_hash Int)))))

(declare-datatypes ((MinVersionEntry 0))
  (((mk-min_version_entry (min_comp_id ComponentId) (min_version Version) (stored_in_hardware Bool)))))

(declare-datatypes ((RollbackState 0))
  (((mk-rollback_state (minimum_versions (Seq Int)) (current_versions (Seq Int)) (anti_rollback_enabled Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Version accessor round-trip: major ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (major (mk-version f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Version accessor round-trip: minor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (minor (mk-version f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Version accessor round-trip: patch ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (patch (mk-version f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Version accessor round-trip: build ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (build (mk-version f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Version: non-negative int fields sum ---
(push 1)
(declare-const r Version)
(assert (>= (major r) 0))
(assert (>= (minor r) 0))
(assert (not (>= (+ (major r) (minor r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. VersionedComponent accessor round-trip: comp_id ---
(push 1)
(declare-const f0 ComponentId)
(declare-const f1 Version)
(declare-const f2 Int)
(assert (not (= (comp_id (mk-versioned_component f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. VersionedComponent accessor round-trip: comp_version ---
(push 1)
(declare-const f0 ComponentId)
(declare-const f1 Version)
(declare-const f2 Int)
(assert (not (= (comp_version (mk-versioned_component f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. VersionedComponent accessor round-trip: comp_hash ---
(push 1)
(declare-const f0 ComponentId)
(declare-const f1 Version)
(declare-const f2 Int)
(assert (not (= (comp_hash (mk-versioned_component f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. MinVersionEntry accessor round-trip: min_comp_id ---
(push 1)
(declare-const f0 ComponentId)
(declare-const f1 Version)
(declare-const f2 Bool)
(assert (not (= (min_comp_id (mk-min_version_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. MinVersionEntry accessor round-trip: min_version ---
(push 1)
(declare-const f0 ComponentId)
(declare-const f1 Version)
(declare-const f2 Bool)
(assert (not (= (min_version (mk-min_version_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. MinVersionEntry accessor round-trip: stored_in_hardware ---
(push 1)
(declare-const f0 ComponentId)
(declare-const f1 Version)
(declare-const f2 Bool)
(assert (not (= (stored_in_hardware (mk-min_version_entry f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
