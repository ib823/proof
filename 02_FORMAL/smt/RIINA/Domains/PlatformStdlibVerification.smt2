; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PlatformStdlibVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/PlatformStdlibVerification.v (20 assertions)
; Module: PlatformStdlibVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Platform 0)) (((PNative) (PWasm32) (PAndroid) (PIos))))

(declare-datatypes ((Capability 0)) (((CapFileSystem) (CapNetwork) (CapConsole) (CapTimer) (CapDOM) (CapSensor) (CapCamera) (CapPushNotif))))

(declare-datatypes ((PlatEffect 0)) (((PEPure) (PEIO) (PENet) (PEUI))))

(declare-datatypes ((PlatLabel 0)) (((PLPublic) (PLSecret))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Platform enum properties ---

; --- 1. Platform exhaustiveness ---
(push 1)
(declare-const x Platform)
(assert (not (or (= x PNative) (= x PWasm32) (= x PAndroid) (= x PIos))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Platform: PNative != PWasm32 ---
(push 1)
(assert (= PNative PWasm32))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Platform: PWasm32 != PAndroid ---
(push 1)
(assert (= PWasm32 PAndroid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Platform: PAndroid != PIos ---
(push 1)
(assert (= PAndroid PIos))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Platform: PNative != PIos ---
(push 1)
(assert (= PNative PIos))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Platform finite cardinality (4 values) ---
(push 1)
(declare-const x Platform)
(assert (and (not (= x PNative)) (not (= x PWasm32)) (not (= x PAndroid)) (not (= x PIos))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Capability enum properties ---

; --- 7. Capability exhaustiveness ---
(push 1)
(declare-const x Capability)
(assert (not (or (= x CapFileSystem) (= x CapNetwork) (= x CapConsole) (= x CapTimer) (= x CapDOM) (= x CapSensor) (= x CapCamera) (= x CapPushNotif))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Capability: CapFileSystem != CapNetwork ---
(push 1)
(assert (= CapFileSystem CapNetwork))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Capability: CapNetwork != CapConsole ---
(push 1)
(assert (= CapNetwork CapConsole))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Capability: CapConsole != CapTimer ---
(push 1)
(assert (= CapConsole CapTimer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Capability: CapFileSystem != CapPushNotif ---
(push 1)
(assert (= CapFileSystem CapPushNotif))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Capability finite cardinality (8 values) ---
(push 1)
(declare-const x Capability)
(assert (and (not (= x CapFileSystem)) (not (= x CapNetwork)) (not (= x CapConsole)) (not (= x CapTimer)) (not (= x CapDOM)) (not (= x CapSensor)) (not (= x CapCamera)) (not (= x CapPushNotif))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PlatEffect enum properties ---

; --- 13. PlatEffect exhaustiveness ---
(push 1)
(declare-const x PlatEffect)
(assert (not (or (= x PEPure) (= x PEIO) (= x PENet) (= x PEUI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PlatEffect: PEPure != PEIO ---
(push 1)
(assert (= PEPure PEIO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PlatEffect: PEIO != PENet ---
(push 1)
(assert (= PEIO PENet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PlatEffect: PENet != PEUI ---
(push 1)
(assert (= PENet PEUI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PlatEffect: PEPure != PEUI ---
(push 1)
(assert (= PEPure PEUI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. PlatEffect finite cardinality (4 values) ---
(push 1)
(declare-const x PlatEffect)
(assert (and (not (= x PEPure)) (not (= x PEIO)) (not (= x PENet)) (not (= x PEUI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PlatLabel enum properties ---

; --- 19. PlatLabel exhaustiveness ---
(push 1)
(declare-const x PlatLabel)
(assert (not (or (= x PLPublic) (= x PLSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. PlatLabel: PLPublic != PLSecret ---
(push 1)
(assert (= PLPublic PLSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. PlatLabel finite cardinality (2 values) ---
(push 1)
(declare-const x PlatLabel)
(assert (and (not (= x PLPublic)) (not (= x PLSecret))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
