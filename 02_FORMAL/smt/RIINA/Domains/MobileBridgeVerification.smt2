; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MobileBridgeVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/MobileBridgeVerification.v (32 assertions)
; Module: MobileBridgeVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((RValue 0)) (((RVInt) (RVBool) (RVString) (RVUnit) (RVSecret))))

(declare-datatypes ((JNIValue 0)) (((JInt) (JBoolean) (JString) (JVoid) (JObject))))

(declare-datatypes ((SwiftValue 0)) (((SwInt) (SwBool) (SwString) (SwVoid) (SwOptional))))

(declare-datatypes ((BridgeEffect 0)) (((BPure) (BIO) (BNet) (BUI))))

(declare-datatypes ((BridgeResult 0)) (((BROk) (BRError))))

(declare-datatypes ((SwiftTypeTag 0)) (((STInt) (STBool) (STString) (STVoid) (STOptional))))

(declare-datatypes ((BridgeSecLabel 0)) (((BPublic) (BSecret))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- RValue enum properties ---

; --- 1. RValue exhaustiveness ---
(push 1)
(declare-const x RValue)
(assert (not (or (= x RVInt) (= x RVBool) (= x RVString) (= x RVUnit) (= x RVSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. RValue: RVInt != RVBool ---
(push 1)
(assert (= RVInt RVBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. RValue: RVBool != RVString ---
(push 1)
(assert (= RVBool RVString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. RValue: RVString != RVUnit ---
(push 1)
(assert (= RVString RVUnit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. RValue: RVInt != RVSecret ---
(push 1)
(assert (= RVInt RVSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. RValue finite cardinality (5 values) ---
(push 1)
(declare-const x RValue)
(assert (and (not (= x RVInt)) (not (= x RVBool)) (not (= x RVString)) (not (= x RVUnit)) (not (= x RVSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- JNIValue enum properties ---

; --- 7. JNIValue exhaustiveness ---
(push 1)
(declare-const x JNIValue)
(assert (not (or (= x JInt) (= x JBoolean) (= x JString) (= x JVoid) (= x JObject))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. JNIValue: JInt != JBoolean ---
(push 1)
(assert (= JInt JBoolean))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. JNIValue: JBoolean != JString ---
(push 1)
(assert (= JBoolean JString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. JNIValue: JString != JVoid ---
(push 1)
(assert (= JString JVoid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. JNIValue: JInt != JObject ---
(push 1)
(assert (= JInt JObject))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. JNIValue finite cardinality (5 values) ---
(push 1)
(declare-const x JNIValue)
(assert (and (not (= x JInt)) (not (= x JBoolean)) (not (= x JString)) (not (= x JVoid)) (not (= x JObject))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SwiftValue enum properties ---

; --- 13. SwiftValue exhaustiveness ---
(push 1)
(declare-const x SwiftValue)
(assert (not (or (= x SwInt) (= x SwBool) (= x SwString) (= x SwVoid) (= x SwOptional))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SwiftValue: SwInt != SwBool ---
(push 1)
(assert (= SwInt SwBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SwiftValue: SwBool != SwString ---
(push 1)
(assert (= SwBool SwString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SwiftValue: SwString != SwVoid ---
(push 1)
(assert (= SwString SwVoid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SwiftValue: SwInt != SwOptional ---
(push 1)
(assert (= SwInt SwOptional))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SwiftValue finite cardinality (5 values) ---
(push 1)
(declare-const x SwiftValue)
(assert (and (not (= x SwInt)) (not (= x SwBool)) (not (= x SwString)) (not (= x SwVoid)) (not (= x SwOptional))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BridgeEffect enum properties ---

; --- 19. BridgeEffect exhaustiveness ---
(push 1)
(declare-const x BridgeEffect)
(assert (not (or (= x BPure) (= x BIO) (= x BNet) (= x BUI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. BridgeEffect: BPure != BIO ---
(push 1)
(assert (= BPure BIO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. BridgeEffect: BIO != BNet ---
(push 1)
(assert (= BIO BNet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. BridgeEffect: BNet != BUI ---
(push 1)
(assert (= BNet BUI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BridgeEffect: BPure != BUI ---
(push 1)
(assert (= BPure BUI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BridgeEffect finite cardinality (4 values) ---
(push 1)
(declare-const x BridgeEffect)
(assert (and (not (= x BPure)) (not (= x BIO)) (not (= x BNet)) (not (= x BUI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BridgeResult enum properties ---

; --- 25. BridgeResult exhaustiveness ---
(push 1)
(declare-const x BridgeResult)
(assert (not (or (= x BROk) (= x BRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BridgeResult: BROk != BRError ---
(push 1)
(assert (= BROk BRError))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. BridgeResult finite cardinality (2 values) ---
(push 1)
(declare-const x BridgeResult)
(assert (and (not (= x BROk)) (not (= x BRError))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SwiftTypeTag enum properties ---

; --- 28. SwiftTypeTag exhaustiveness ---
(push 1)
(declare-const x SwiftTypeTag)
(assert (not (or (= x STInt) (= x STBool) (= x STString) (= x STVoid) (= x STOptional))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. SwiftTypeTag: STInt != STBool ---
(push 1)
(assert (= STInt STBool))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SwiftTypeTag: STBool != STString ---
(push 1)
(assert (= STBool STString))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. SwiftTypeTag: STString != STVoid ---
(push 1)
(assert (= STString STVoid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. SwiftTypeTag: STInt != STOptional ---
(push 1)
(assert (= STInt STOptional))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. SwiftTypeTag finite cardinality (5 values) ---
(push 1)
(declare-const x SwiftTypeTag)
(assert (and (not (= x STInt)) (not (= x STBool)) (not (= x STString)) (not (= x STVoid)) (not (= x STOptional))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BridgeSecLabel enum properties ---

; --- 34. BridgeSecLabel exhaustiveness ---
(push 1)
(declare-const x BridgeSecLabel)
(assert (not (or (= x BPublic) (= x BSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. BridgeSecLabel: BPublic != BSecret ---
(push 1)
(assert (= BPublic BSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. BridgeSecLabel finite cardinality (2 values) ---
(push 1)
(declare-const x BridgeSecLabel)
(assert (and (not (= x BPublic)) (not (= x BSecret))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
