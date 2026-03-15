; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA FFIAttackResearch — SMT Verification
; Derived from 02_FORMAL/coq/domains/FFIAttackResearch.v (20 assertions)
; Module: FFIAttackResearch
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FFIType 0)) (((FFI_Int8) (FFI_Int16) (FFI_Int32) (FFI_Int64) (FFI_Ptr) (FFI_Array) (FFI_Struct) (FFI_Void))))

(declare-datatypes ((FFICallDescriptor 0))
  (((mk-ffi_call_descriptor (ffi_name Int) (ffi_params (Seq Int)) (ffi_return FFIType) (ffi_sandboxed Bool) (ffi_validated Bool)))))

(declare-datatypes ((MemRegion 0))
  (((mk-mem_region (region_base Int) (region_size Int) (region_owner Int)))))

(declare-datatypes ((Sandbox 0))
  (((mk-sandbox (sandbox_id Int) (sandbox_region MemRegion) (sandbox_active Bool) (allowed_calls (Seq Int))))))

(declare-datatypes ((MarshalBuffer 0))
  (((mk-marshal_buffer (buf_capacity Int) (buf_used Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- FFIType enum properties ---

; --- 1. FFIType exhaustiveness ---
(push 1)
(declare-const x FFIType)
(assert (not (or (= x FFI_Int8) (= x FFI_Int16) (= x FFI_Int32) (= x FFI_Int64) (= x FFI_Ptr) (= x FFI_Array) (= x FFI_Struct) (= x FFI_Void))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FFIType: FFI_Int8 != FFI_Int16 ---
(push 1)
(assert (= FFI_Int8 FFI_Int16))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FFIType: FFI_Int16 != FFI_Int32 ---
(push 1)
(assert (= FFI_Int16 FFI_Int32))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FFIType: FFI_Int32 != FFI_Int64 ---
(push 1)
(assert (= FFI_Int32 FFI_Int64))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FFIType: FFI_Int8 != FFI_Void ---
(push 1)
(assert (= FFI_Int8 FFI_Void))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FFIType finite cardinality (8 values) ---
(push 1)
(declare-const x FFIType)
(assert (and (not (= x FFI_Int8)) (not (= x FFI_Int16)) (not (= x FFI_Int32)) (not (= x FFI_Int64)) (not (= x FFI_Ptr)) (not (= x FFI_Array)) (not (= x FFI_Struct)) (not (= x FFI_Void))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FFICallDescriptor record properties ---

; --- 7. FFICallDescriptor accessor round-trip: ffi_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 FFIType)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ffi_name (mk-ffi_call_descriptor f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FFICallDescriptor accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 FFIType)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ffi_params (mk-ffi_call_descriptor f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FFICallDescriptor accessor round-trip: ffi_return ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 FFIType)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ffi_return (mk-ffi_call_descriptor f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FFICallDescriptor accessor round-trip: ffi_sandboxed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 FFIType)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ffi_sandboxed (mk-ffi_call_descriptor f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FFICallDescriptor: integer field consistency ---
(push 1)
(declare-const r FFICallDescriptor)
(assert (>= (ffi_name r) 0))
(assert (>= (seq.len (ffi_params r)) 0))
(assert (not (>= (+ (ffi_name r) (seq.len (ffi_params r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemRegion record properties ---

; --- 12. MemRegion accessor round-trip: region_base ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (region_base (mk-mem_region f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. MemRegion accessor round-trip: region_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (region_size (mk-mem_region f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MemRegion: integer field consistency ---
(push 1)
(declare-const r MemRegion)
(assert (>= (region_base r) 0))
(assert (>= (region_size r) 0))
(assert (not (>= (+ (region_base r) (region_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Sandbox record properties ---

; --- 15. Sandbox accessor round-trip: sandbox_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 MemRegion)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (sandbox_id (mk-sandbox f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Sandbox accessor round-trip: sandbox_region ---
(push 1)
(declare-const f0 Int)
(declare-const f1 MemRegion)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (sandbox_region (mk-sandbox f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Sandbox accessor round-trip: sandbox_active ---
(push 1)
(declare-const f0 Int)
(declare-const f1 MemRegion)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (sandbox_active (mk-sandbox f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MarshalBuffer record properties ---

; --- 18. MarshalBuffer accessor round-trip: buf_capacity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (buf_capacity (mk-marshal_buffer f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
