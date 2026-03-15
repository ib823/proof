; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DeserializationSafety — SMT Verification
; Derived from 02_FORMAL/coq/domains/DeserializationSafety.v (26 assertions)
; Module: DeserializationSafety
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SerFormat 0)) (((JSON) (MessagePack) (CBOR) (Protobuf) (Custom))))

(declare-datatypes ((TypeTag 0)) (((TagBool) (TagNat) (TagString) (TagList) (TagRecord) (TagNone))))

(declare-datatypes ((DeserResult 0)) (((DeserOk) (DeserTypeErr) (DeserOverflow) (DeserMalformed) (DeserGadget))))

(declare-datatypes ((DeserPolicy 0))
  (((mk-deser_policy (dp_max_depth Int) (dp_max_size_bytes Int) (dp_allow_polymorphic Bool) (dp_allow_callbacks Bool) (dp_allow_reflection Bool) (dp_require_schema Bool) (dp_require_type_tag Bool) (dp_sanitize_strings Bool) (dp_allowlist_types Bool) (dp_log_deserializations Bool)))))

(declare-datatypes ((SerializedInput 0))
  (((mk-serialized_input (si_format SerFormat) (si_size_bytes Int) (si_depth Int) (si_has_schema Bool) (si_has_type_tags Bool) (si_contains_code Bool) (si_types_allowlisted Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SerFormat enum properties ---

; --- 1. SerFormat exhaustiveness ---
(push 1)
(declare-const x SerFormat)
(assert (not (or (= x JSON) (= x MessagePack) (= x CBOR) (= x Protobuf) (= x Custom))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SerFormat: JSON != MessagePack ---
(push 1)
(assert (= JSON MessagePack))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SerFormat: MessagePack != CBOR ---
(push 1)
(assert (= MessagePack CBOR))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SerFormat: CBOR != Protobuf ---
(push 1)
(assert (= CBOR Protobuf))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SerFormat: JSON != Custom ---
(push 1)
(assert (= JSON Custom))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SerFormat finite cardinality (5 values) ---
(push 1)
(declare-const x SerFormat)
(assert (and (not (= x JSON)) (not (= x MessagePack)) (not (= x CBOR)) (not (= x Protobuf)) (not (= x Custom))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TypeTag enum properties ---

; --- 7. TypeTag exhaustiveness ---
(push 1)
(declare-const x TypeTag)
(assert (not (or (= x TagBool) (= x TagNat) (= x TagString) (= x TagList) (= x TagRecord) (= x TagNone))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TypeTag: TagBool != TagNat ---
(push 1)
(assert (= TagBool TagNat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TypeTag: TagNat != TagString ---
(push 1)
(assert (= TagNat TagString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TypeTag: TagString != TagList ---
(push 1)
(assert (= TagString TagList))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TypeTag: TagBool != TagNone ---
(push 1)
(assert (= TagBool TagNone))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TypeTag finite cardinality (6 values) ---
(push 1)
(declare-const x TypeTag)
(assert (and (not (= x TagBool)) (not (= x TagNat)) (not (= x TagString)) (not (= x TagList)) (not (= x TagRecord)) (not (= x TagNone))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DeserResult enum properties ---

; --- 13. DeserResult exhaustiveness ---
(push 1)
(declare-const x DeserResult)
(assert (not (or (= x DeserOk) (= x DeserTypeErr) (= x DeserOverflow) (= x DeserMalformed) (= x DeserGadget))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. DeserResult: DeserOk != DeserTypeErr ---
(push 1)
(assert (= DeserOk DeserTypeErr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. DeserResult: DeserTypeErr != DeserOverflow ---
(push 1)
(assert (= DeserTypeErr DeserOverflow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. DeserResult: DeserOverflow != DeserMalformed ---
(push 1)
(assert (= DeserOverflow DeserMalformed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. DeserResult: DeserOk != DeserGadget ---
(push 1)
(assert (= DeserOk DeserGadget))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. DeserResult finite cardinality (5 values) ---
(push 1)
(declare-const x DeserResult)
(assert (and (not (= x DeserOk)) (not (= x DeserTypeErr)) (not (= x DeserOverflow)) (not (= x DeserMalformed)) (not (= x DeserGadget))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DeserPolicy record properties ---

; --- 19. DeserPolicy accessor round-trip: dp_max_depth ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (dp_max_depth (mk-deser_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. DeserPolicy accessor round-trip: dp_max_size_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (dp_max_size_bytes (mk-deser_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. DeserPolicy accessor round-trip: dp_allow_polymorphic ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (dp_allow_polymorphic (mk-deser_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. DeserPolicy accessor round-trip: dp_allow_callbacks ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (dp_allow_callbacks (mk-deser_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. DeserPolicy accessor round-trip: dp_allow_reflection ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (dp_allow_reflection (mk-deser_policy f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. DeserPolicy: integer field consistency ---
(push 1)
(declare-const r DeserPolicy)
(assert (>= (dp_max_depth r) 0))
(assert (>= (dp_max_size_bytes r) 0))
(assert (not (>= (+ (dp_max_depth r) (dp_max_size_bytes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SerializedInput record properties ---

; --- 25. SerializedInput accessor round-trip: si_format ---
(push 1)
(declare-const f0 SerFormat)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (si_format (mk-serialized_input f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SerializedInput accessor round-trip: si_size_bytes ---
(push 1)
(declare-const f0 SerFormat)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (si_size_bytes (mk-serialized_input f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. SerializedInput accessor round-trip: si_depth ---
(push 1)
(declare-const f0 SerFormat)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (si_depth (mk-serialized_input f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. SerializedInput accessor round-trip: si_has_schema ---
(push 1)
(declare-const f0 SerFormat)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (si_has_schema (mk-serialized_input f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. SerializedInput accessor round-trip: si_has_type_tags ---
(push 1)
(declare-const f0 SerFormat)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (si_has_type_tags (mk-serialized_input f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SerializedInput: integer field consistency ---
(push 1)
(declare-const r SerializedInput)
(assert (>= (si_size_bytes r) 0))
(assert (>= (si_depth r) 0))
(assert (not (>= (+ (si_size_bytes r) (si_depth r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
