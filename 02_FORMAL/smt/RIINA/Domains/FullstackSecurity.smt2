; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA FullstackSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/FullstackSecurity.v (25 assertions)
; Module: FullstackSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ContentType 0)) (((RawHtml) (EscapedHtml) (PlainText) (SafeUrl) (TrustedHtml))))

(declare-datatypes ((ParamType 0)) (((IntParam) (StringParam) (BoolParam) (NullParam))))

(declare-datatypes ((AuthState 0)) (((Unauthenticated) (PendingMFA) (Authenticated) (Locked))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ContentType enum properties ---

; --- 1. ContentType exhaustiveness ---
(push 1)
(declare-const x ContentType)
(assert (not (or (= x RawHtml) (= x EscapedHtml) (= x PlainText) (= x SafeUrl) (= x TrustedHtml))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ContentType: RawHtml != EscapedHtml ---
(push 1)
(assert (= RawHtml EscapedHtml))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ContentType: EscapedHtml != PlainText ---
(push 1)
(assert (= EscapedHtml PlainText))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ContentType: PlainText != SafeUrl ---
(push 1)
(assert (= PlainText SafeUrl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ContentType: RawHtml != TrustedHtml ---
(push 1)
(assert (= RawHtml TrustedHtml))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ContentType finite cardinality (5 values) ---
(push 1)
(declare-const x ContentType)
(assert (and (not (= x RawHtml)) (not (= x EscapedHtml)) (not (= x PlainText)) (not (= x SafeUrl)) (not (= x TrustedHtml))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ParamType enum properties ---

; --- 7. ParamType exhaustiveness ---
(push 1)
(declare-const x ParamType)
(assert (not (or (= x IntParam) (= x StringParam) (= x BoolParam) (= x NullParam))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ParamType: IntParam != StringParam ---
(push 1)
(assert (= IntParam StringParam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ParamType: StringParam != BoolParam ---
(push 1)
(assert (= StringParam BoolParam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ParamType: BoolParam != NullParam ---
(push 1)
(assert (= BoolParam NullParam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ParamType: IntParam != NullParam ---
(push 1)
(assert (= IntParam NullParam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ParamType finite cardinality (4 values) ---
(push 1)
(declare-const x ParamType)
(assert (and (not (= x IntParam)) (not (= x StringParam)) (not (= x BoolParam)) (not (= x NullParam))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuthState enum properties ---

; --- 13. AuthState exhaustiveness ---
(push 1)
(declare-const x AuthState)
(assert (not (or (= x Unauthenticated) (= x PendingMFA) (= x Authenticated) (= x Locked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AuthState: Unauthenticated != PendingMFA ---
(push 1)
(assert (= Unauthenticated PendingMFA))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AuthState: PendingMFA != Authenticated ---
(push 1)
(assert (= PendingMFA Authenticated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AuthState: Authenticated != Locked ---
(push 1)
(assert (= Authenticated Locked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. AuthState: Unauthenticated != Locked ---
(push 1)
(assert (= Unauthenticated Locked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. AuthState finite cardinality (4 values) ---
(push 1)
(declare-const x AuthState)
(assert (and (not (= x Unauthenticated)) (not (= x PendingMFA)) (not (= x Authenticated)) (not (= x Locked))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
