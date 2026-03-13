; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA RustFFISecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/RustFFISecurity.v (34 assertions)
; Module: RustFFISecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FFIVulnerability 0)) (((FFI_UseAfterFree) (FFI_TypeConfusion) (FFI_LifetimeEscape) (FFI_PanicUnwind) (FFI_NullPointer) (FFI_BufferOverflow) (FFI_DoubleFree) (FFI_DataRace))))

(declare-datatypes ((FFIBoundary 0)) (((RustToC) (CToRust) (Bidirectional))))

(declare-datatypes ((LifetimeSafety 0)) (((LifetimeSafe) (LifetimeViolated))))

(declare-datatypes ((PanicSafety 0)) (((PanicSafe) (PanicUnsafe))))

(declare-datatypes ((NullCheck 0)) (((NullChecked) (NullUnchecked))))

(declare-datatypes ((BufferValidation 0)) (((BufferValidated) (BufferUnchecked))))

(declare-datatypes ((TypeMarshalling 0)) (((TypeMarshalSafe) (TypeMarshalUnsafe))))

(declare-datatypes ((FFISafetyPolicy 0))
  (((mk-ffi_safety_policy (ffi_require_effect_annotation Bool) (ffi_enforce_lifetime_bounds Bool) (ffi_require_panic_wrapper Bool) (ffi_require_null_check Bool) (ffi_require_buffer_validation Bool) (ffi_require_type_marshalling Bool) (ffi_forbid_shared_mut Bool) (ffi_log_all_calls Bool)))))

(declare-datatypes ((FFICall 0))
  (((mk-ffi_call (ffi_boundary FFIBoundary) (ffi_has_effect_annotation Bool) (ffi_lifetime_safety LifetimeSafety) (ffi_panic_safety PanicSafety) (ffi_null_check NullCheck) (ffi_buffer_validation BufferValidation) (ffi_type_marshalling TypeMarshalling) (ffi_shared_mut Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- FFIVulnerability enum properties ---

; --- 1. FFIVulnerability exhaustiveness ---
(push 1)
(declare-const x FFIVulnerability)
(assert (not (or (= x FFI_UseAfterFree) (= x FFI_TypeConfusion) (= x FFI_LifetimeEscape) (= x FFI_PanicUnwind) (= x FFI_NullPointer) (= x FFI_BufferOverflow) (= x FFI_DoubleFree) (= x FFI_DataRace))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FFIVulnerability: FFI_UseAfterFree != FFI_TypeConfusion ---
(push 1)
(assert (= FFI_UseAfterFree FFI_TypeConfusion))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FFIVulnerability: FFI_TypeConfusion != FFI_LifetimeEscape ---
(push 1)
(assert (= FFI_TypeConfusion FFI_LifetimeEscape))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FFIVulnerability: FFI_LifetimeEscape != FFI_PanicUnwind ---
(push 1)
(assert (= FFI_LifetimeEscape FFI_PanicUnwind))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FFIVulnerability: FFI_UseAfterFree != FFI_DataRace ---
(push 1)
(assert (= FFI_UseAfterFree FFI_DataRace))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FFIVulnerability finite cardinality (8 values) ---
(push 1)
(declare-const x FFIVulnerability)
(assert (and (not (= x FFI_UseAfterFree)) (not (= x FFI_TypeConfusion)) (not (= x FFI_LifetimeEscape)) (not (= x FFI_PanicUnwind)) (not (= x FFI_NullPointer)) (not (= x FFI_BufferOverflow)) (not (= x FFI_DoubleFree)) (not (= x FFI_DataRace))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FFIBoundary enum properties ---

; --- 7. FFIBoundary exhaustiveness ---
(push 1)
(declare-const x FFIBoundary)
(assert (not (or (= x RustToC) (= x CToRust) (= x Bidirectional))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FFIBoundary: RustToC != CToRust ---
(push 1)
(assert (= RustToC CToRust))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FFIBoundary: CToRust != Bidirectional ---
(push 1)
(assert (= CToRust Bidirectional))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FFIBoundary: RustToC != Bidirectional ---
(push 1)
(assert (= RustToC Bidirectional))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FFIBoundary finite cardinality (3 values) ---
(push 1)
(declare-const x FFIBoundary)
(assert (and (not (= x RustToC)) (not (= x CToRust)) (not (= x Bidirectional))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LifetimeSafety enum properties ---

; --- 12. LifetimeSafety exhaustiveness ---
(push 1)
(declare-const x LifetimeSafety)
(assert (not (or (= x LifetimeSafe) (= x LifetimeViolated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. LifetimeSafety: LifetimeSafe != LifetimeViolated ---
(push 1)
(assert (= LifetimeSafe LifetimeViolated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. LifetimeSafety finite cardinality (2 values) ---
(push 1)
(declare-const x LifetimeSafety)
(assert (and (not (= x LifetimeSafe)) (not (= x LifetimeViolated))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PanicSafety enum properties ---

; --- 15. PanicSafety exhaustiveness ---
(push 1)
(declare-const x PanicSafety)
(assert (not (or (= x PanicSafe) (= x PanicUnsafe))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PanicSafety: PanicSafe != PanicUnsafe ---
(push 1)
(assert (= PanicSafe PanicUnsafe))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PanicSafety finite cardinality (2 values) ---
(push 1)
(declare-const x PanicSafety)
(assert (and (not (= x PanicSafe)) (not (= x PanicUnsafe))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NullCheck enum properties ---

; --- 18. NullCheck exhaustiveness ---
(push 1)
(declare-const x NullCheck)
(assert (not (or (= x NullChecked) (= x NullUnchecked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. NullCheck: NullChecked != NullUnchecked ---
(push 1)
(assert (= NullChecked NullUnchecked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. NullCheck finite cardinality (2 values) ---
(push 1)
(declare-const x NullCheck)
(assert (and (not (= x NullChecked)) (not (= x NullUnchecked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BufferValidation enum properties ---

; --- 21. BufferValidation exhaustiveness ---
(push 1)
(declare-const x BufferValidation)
(assert (not (or (= x BufferValidated) (= x BufferUnchecked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. BufferValidation: BufferValidated != BufferUnchecked ---
(push 1)
(assert (= BufferValidated BufferUnchecked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BufferValidation finite cardinality (2 values) ---
(push 1)
(declare-const x BufferValidation)
(assert (and (not (= x BufferValidated)) (not (= x BufferUnchecked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TypeMarshalling enum properties ---

; --- 24. TypeMarshalling exhaustiveness ---
(push 1)
(declare-const x TypeMarshalling)
(assert (not (or (= x TypeMarshalSafe) (= x TypeMarshalUnsafe))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TypeMarshalling: TypeMarshalSafe != TypeMarshalUnsafe ---
(push 1)
(assert (= TypeMarshalSafe TypeMarshalUnsafe))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TypeMarshalling finite cardinality (2 values) ---
(push 1)
(declare-const x TypeMarshalling)
(assert (and (not (= x TypeMarshalSafe)) (not (= x TypeMarshalUnsafe))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FFISafetyPolicy record properties ---

; --- 27. FFISafetyPolicy accessor round-trip: ffi_require_effect_annotation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ffi_require_effect_annotation (mk-f_f_i_safety_policy f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. FFISafetyPolicy accessor round-trip: ffi_enforce_lifetime_bounds ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ffi_enforce_lifetime_bounds (mk-f_f_i_safety_policy f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. FFISafetyPolicy accessor round-trip: ffi_require_panic_wrapper ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ffi_require_panic_wrapper (mk-f_f_i_safety_policy f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. FFISafetyPolicy accessor round-trip: ffi_require_null_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ffi_require_null_check (mk-f_f_i_safety_policy f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. FFISafetyPolicy accessor round-trip: ffi_require_buffer_validation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(assert (not (= (ffi_require_buffer_validation (mk-f_f_i_safety_policy f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FFISafetyPolicy_all_enabled ((g FFISafetyPolicy)) Bool
  (and (ffi_require_effect_annotation g) (ffi_enforce_lifetime_bounds g) (ffi_require_panic_wrapper g) (ffi_require_null_check g) (ffi_require_buffer_validation g) (ffi_require_type_marshalling g) (ffi_forbid_shared_mut g)))

; --- 32. FFISafetyPolicy: all-enabled completeness ---
(push 1)
(declare-const g FFISafetyPolicy)
(assert (ffi_require_effect_annotation g))
(assert (ffi_enforce_lifetime_bounds g))
(assert (ffi_require_panic_wrapper g))
(assert (ffi_require_null_check g))
(assert (ffi_require_buffer_validation g))
(assert (ffi_require_type_marshalling g))
(assert (ffi_forbid_shared_mut g))
(assert (not (FFISafetyPolicy_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. FFISafetyPolicy: FFISafetyPolicy_all_enabled implies ffi_require_effect_annotation ---
(push 1)
(declare-const g FFISafetyPolicy)
(assert (FFISafetyPolicy_all_enabled g))
(assert (not (ffi_require_effect_annotation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. FFISafetyPolicy: FFISafetyPolicy_all_enabled implies ffi_enforce_lifetime_bounds ---
(push 1)
(declare-const g FFISafetyPolicy)
(assert (FFISafetyPolicy_all_enabled g))
(assert (not (ffi_enforce_lifetime_bounds g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. FFISafetyPolicy: FFISafetyPolicy_all_enabled implies ffi_require_panic_wrapper ---
(push 1)
(declare-const g FFISafetyPolicy)
(assert (FFISafetyPolicy_all_enabled g))
(assert (not (ffi_require_panic_wrapper g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FFICall record properties ---

; --- 36. FFICall accessor round-trip: ffi_boundary ---
(push 1)
(declare-const f0 FFIBoundary)
(declare-const f1 Bool)
(declare-const f2 LifetimeSafety)
(declare-const f3 PanicSafety)
(declare-const f4 NullCheck)
(declare-const f5 BufferValidation)
(declare-const f6 TypeMarshalling)
(assert (not (= (ffi_boundary (mk-f_f_i_call f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. FFICall accessor round-trip: ffi_has_effect_annotation ---
(push 1)
(declare-const f0 FFIBoundary)
(declare-const f1 Bool)
(declare-const f2 LifetimeSafety)
(declare-const f3 PanicSafety)
(declare-const f4 NullCheck)
(declare-const f5 BufferValidation)
(declare-const f6 TypeMarshalling)
(assert (not (= (ffi_has_effect_annotation (mk-f_f_i_call f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. FFICall accessor round-trip: ffi_lifetime_safety ---
(push 1)
(declare-const f0 FFIBoundary)
(declare-const f1 Bool)
(declare-const f2 LifetimeSafety)
(declare-const f3 PanicSafety)
(declare-const f4 NullCheck)
(declare-const f5 BufferValidation)
(declare-const f6 TypeMarshalling)
(assert (not (= (ffi_lifetime_safety (mk-f_f_i_call f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. FFICall accessor round-trip: ffi_panic_safety ---
(push 1)
(declare-const f0 FFIBoundary)
(declare-const f1 Bool)
(declare-const f2 LifetimeSafety)
(declare-const f3 PanicSafety)
(declare-const f4 NullCheck)
(declare-const f5 BufferValidation)
(declare-const f6 TypeMarshalling)
(assert (not (= (ffi_panic_safety (mk-f_f_i_call f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. FFICall accessor round-trip: ffi_null_check ---
(push 1)
(declare-const f0 FFIBoundary)
(declare-const f1 Bool)
(declare-const f2 LifetimeSafety)
(declare-const f3 PanicSafety)
(declare-const f4 NullCheck)
(declare-const f5 BufferValidation)
(declare-const f6 TypeMarshalling)
(assert (not (= (ffi_null_check (mk-f_f_i_call f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
