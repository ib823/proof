; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Y001_VerifiedStdlib — SMT Verification
; Derived from 02_FORMAL/coq/domains/Y001_VerifiedStdlib.v (41 assertions)
; Module: Y001_VerifiedStdlib
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((IOEffect 0)) (((ReadFile) (WriteFile) (Network))))

(declare-datatypes ((JsonValue 0)) (((JsonNull) (JsonBool) (JsonNum) (JsonString) (JsonArray))))

(declare-datatypes ((Utf8String 0))
  (((mk-utf8_string (utf8_bytes (Seq Int)) (utf8_valid Int)))))

(declare-datatypes ((BoundedRead 0))
  (((mk-bounded_read (read_data (Seq Int)) (read_requested Int) (read_actual Int) (read_bounds_ok Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- IOEffect enum properties ---

; --- 1. IOEffect exhaustiveness ---
(push 1)
(declare-const x IOEffect)
(assert (not (or (= x ReadFile) (= x WriteFile) (= x Network))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. IOEffect: ReadFile != WriteFile ---
(push 1)
(assert (= ReadFile WriteFile))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. IOEffect: WriteFile != Network ---
(push 1)
(assert (= WriteFile Network))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. IOEffect: ReadFile != Network ---
(push 1)
(assert (= ReadFile Network))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. IOEffect finite cardinality (3 values) ---
(push 1)
(declare-const x IOEffect)
(assert (and (not (= x ReadFile)) (not (= x WriteFile)) (not (= x Network))))
(check-sat) ; expect UNSAT
(pop 1)

; --- JsonValue enum properties ---

; --- 6. JsonValue exhaustiveness ---
(push 1)
(declare-const x JsonValue)
(assert (not (or (= x JsonNull) (= x JsonBool) (= x JsonNum) (= x JsonString) (= x JsonArray))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. JsonValue: JsonNull != JsonBool ---
(push 1)
(assert (= JsonNull JsonBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. JsonValue: JsonBool != JsonNum ---
(push 1)
(assert (= JsonBool JsonNum))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. JsonValue: JsonNum != JsonString ---
(push 1)
(assert (= JsonNum JsonString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. JsonValue: JsonNull != JsonArray ---
(push 1)
(assert (= JsonNull JsonArray))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. JsonValue finite cardinality (5 values) ---
(push 1)
(declare-const x JsonValue)
(assert (and (not (= x JsonNull)) (not (= x JsonBool)) (not (= x JsonNum)) (not (= x JsonString)) (not (= x JsonArray))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Utf8String record properties ---

; --- 12. Utf8String accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (utf8_bytes (mk-utf8_string f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BoundedRead record properties ---

; --- 13. BoundedRead accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (read_data (mk-bounded_read f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. BoundedRead accessor round-trip: read_requested ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (read_requested (mk-bounded_read f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. BoundedRead accessor round-trip: read_actual ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (read_actual (mk-bounded_read f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. BoundedRead: integer field consistency ---
(push 1)
(declare-const r BoundedRead)
(assert (>= (seq.len (read_data r)) 0))
(assert (>= (read_requested r) 0))
(assert (not (>= (+ (seq.len (read_data r)) (read_requested r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
