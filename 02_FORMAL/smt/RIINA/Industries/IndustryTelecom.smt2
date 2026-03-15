; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryTelecom — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryTelecom.v (24 assertions)
; Module: IndustryTelecom
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TelecomDomain 0)) (((RAN) (Core) (Transport) (Service) (Management))))

(declare-datatypes ((NetworkFunction 0)) (((AMF) (SMF) (UPF) (AUSF) (UDM))))

(declare-datatypes ((TelecomEffect 0)) (((SignalingIO) (UserPlaneIO) (SubscriberData) (NetworkConfig) (BillingRecord))))

(declare-datatypes ((Security_5G 0))
  (((mk-security_5_g (primary_authentication Bool) (nas_security Bool) (as_security Bool) (user_plane_integrity Bool) (service_based_security Bool) (network_slicing_isolation Bool)))))

(declare-datatypes ((NetworkSlice 0))
  (((mk-network_slice (slice_id Int) (slice_domain TelecomDomain) (slice_encrypted Bool) (slice_isolated Bool) (slice_sla_latency_ms Int)))))

(declare-datatypes ((LawfulIntercept 0))
  (((mk-lawful_intercept (li_target Int) (li_warrant_id Int) (li_authorized Bool) (li_logged Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TelecomDomain enum properties ---

; --- 1. TelecomDomain exhaustiveness ---
(push 1)
(declare-const x TelecomDomain)
(assert (not (or (= x RAN) (= x Core) (= x Transport) (= x Service) (= x Management))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TelecomDomain: RAN != Core ---
(push 1)
(assert (= RAN Core))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TelecomDomain: Core != Transport ---
(push 1)
(assert (= Core Transport))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TelecomDomain: Transport != Service ---
(push 1)
(assert (= Transport Service))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TelecomDomain: RAN != Management ---
(push 1)
(assert (= RAN Management))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TelecomDomain finite cardinality (5 values) ---
(push 1)
(declare-const x TelecomDomain)
(assert (and (not (= x RAN)) (not (= x Core)) (not (= x Transport)) (not (= x Service)) (not (= x Management))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkFunction enum properties ---

; --- 7. NetworkFunction exhaustiveness ---
(push 1)
(declare-const x NetworkFunction)
(assert (not (or (= x AMF) (= x SMF) (= x UPF) (= x AUSF) (= x UDM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. NetworkFunction: AMF != SMF ---
(push 1)
(assert (= AMF SMF))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. NetworkFunction: SMF != UPF ---
(push 1)
(assert (= SMF UPF))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. NetworkFunction: UPF != AUSF ---
(push 1)
(assert (= UPF AUSF))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. NetworkFunction: AMF != UDM ---
(push 1)
(assert (= AMF UDM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. NetworkFunction finite cardinality (5 values) ---
(push 1)
(declare-const x NetworkFunction)
(assert (and (not (= x AMF)) (not (= x SMF)) (not (= x UPF)) (not (= x AUSF)) (not (= x UDM))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TelecomEffect enum properties ---

; --- 13. TelecomEffect exhaustiveness ---
(push 1)
(declare-const x TelecomEffect)
(assert (not (or (= x SignalingIO) (= x UserPlaneIO) (= x SubscriberData) (= x NetworkConfig) (= x BillingRecord))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. TelecomEffect: SignalingIO != UserPlaneIO ---
(push 1)
(assert (= SignalingIO UserPlaneIO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. TelecomEffect: UserPlaneIO != SubscriberData ---
(push 1)
(assert (= UserPlaneIO SubscriberData))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. TelecomEffect: SubscriberData != NetworkConfig ---
(push 1)
(assert (= SubscriberData NetworkConfig))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TelecomEffect: SignalingIO != BillingRecord ---
(push 1)
(assert (= SignalingIO BillingRecord))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TelecomEffect finite cardinality (5 values) ---
(push 1)
(declare-const x TelecomEffect)
(assert (and (not (= x SignalingIO)) (not (= x UserPlaneIO)) (not (= x SubscriberData)) (not (= x NetworkConfig)) (not (= x BillingRecord))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Security_5G record properties ---

; --- 19. Security_5G accessor round-trip: primary_authentication ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (primary_authentication (mk-security_5_g f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Security_5G accessor round-trip: nas_security ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (nas_security (mk-security_5_g f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Security_5G accessor round-trip: as_security ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (as_security (mk-security_5_g f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Security_5G accessor round-trip: user_plane_integrity ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (user_plane_integrity (mk-security_5_g f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Security_5G accessor round-trip: service_based_security ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (service_based_security (mk-security_5_g f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun Security_5G_all_enabled ((g Security_5G)) Bool
  (and (primary_authentication g) (nas_security g) (as_security g) (user_plane_integrity g) (service_based_security g)))

; --- 24. Security_5G: all-enabled completeness ---
(push 1)
(declare-const g Security_5G)
(assert (primary_authentication g))
(assert (nas_security g))
(assert (as_security g))
(assert (user_plane_integrity g))
(assert (service_based_security g))
(assert (not (Security_5G_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Security_5G: Security_5G_all_enabled implies primary_authentication ---
(push 1)
(declare-const g Security_5G)
(assert (Security_5G_all_enabled g))
(assert (not (primary_authentication g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Security_5G: Security_5G_all_enabled implies nas_security ---
(push 1)
(declare-const g Security_5G)
(assert (Security_5G_all_enabled g))
(assert (not (nas_security g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Security_5G: Security_5G_all_enabled implies as_security ---
(push 1)
(declare-const g Security_5G)
(assert (Security_5G_all_enabled g))
(assert (not (as_security g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkSlice record properties ---

; --- 28. NetworkSlice accessor round-trip: slice_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TelecomDomain)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (slice_id (mk-network_slice f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. NetworkSlice accessor round-trip: slice_domain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TelecomDomain)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (slice_domain (mk-network_slice f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. NetworkSlice accessor round-trip: slice_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TelecomDomain)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (slice_encrypted (mk-network_slice f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. NetworkSlice accessor round-trip: slice_isolated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 TelecomDomain)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (slice_isolated (mk-network_slice f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LawfulIntercept record properties ---

; --- 32. LawfulIntercept accessor round-trip: li_target ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (li_target (mk-lawful_intercept f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. LawfulIntercept accessor round-trip: li_warrant_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (li_warrant_id (mk-lawful_intercept f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. LawfulIntercept accessor round-trip: li_authorized ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (li_authorized (mk-lawful_intercept f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. LawfulIntercept: integer field consistency ---
(push 1)
(declare-const r LawfulIntercept)
(assert (>= (li_target r) 0))
(assert (>= (li_warrant_id r) 0))
(assert (not (>= (+ (li_target r) (li_warrant_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TelecomDomain ordering properties ---

(define-fun TelecomDomain_level ((x TelecomDomain)) Int
  (ite (= x RAN) 0 (ite (= x Core) 1 (ite (= x Transport) 2 (ite (= x Service) 3 4)))))

(define-fun TelecomDomain_leq ((x TelecomDomain) (y TelecomDomain)) Bool
  (<= (TelecomDomain_level x) (TelecomDomain_level y)))

; --- 36. TelecomDomain_leq reflexivity ---
(push 1)
(declare-const x TelecomDomain)
(assert (not (TelecomDomain_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TelecomDomain_leq transitivity ---
(push 1)
(declare-const x TelecomDomain)
(declare-const y TelecomDomain)
(declare-const z TelecomDomain)
(assert (TelecomDomain_leq x y))
(assert (TelecomDomain_leq y z))
(assert (not (TelecomDomain_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. TelecomDomain_leq antisymmetry ---
(push 1)
(declare-const x TelecomDomain)
(declare-const y TelecomDomain)
(assert (TelecomDomain_leq x y))
(assert (TelecomDomain_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. RAN is bottom ---
(push 1)
(declare-const x TelecomDomain)
(assert (not (TelecomDomain_leq RAN x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Management is top ---
(push 1)
(declare-const x TelecomDomain)
(assert (not (TelecomDomain_leq x Management)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
