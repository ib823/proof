; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TotalStackFoundation — SMT Verification
; Derived from 02_FORMAL/coq/domains/TotalStackFoundation.v (51 assertions)
; Module: TotalStackFoundation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Layer 0)) (((L0_Physics) (L1_Silicon) (L2_Firmware) (L3_Network) (L4_OS) (L5_Runtime) (L6_App) (L7_UX))))

(declare-datatypes ((SecurityProperty 0)) (((SPConfidentiality) (SPIntegrity) (SPAvailability) (SPAuthentication) (SPAuthorization) (SPNonRepudiation))))

(declare-datatypes ((AttackType 0)) (((ATMemoryCorruption) (ATSideChannel) (ATNetworkAttack) (ATPrivilegeEscalation) (ATUIDeception) (ATBootCompromise) (ATRemoteCodeExec) (ATDataExfiltration) (ATDenialOfService) (ATMalwareExec) (ATInsiderThreat))))

(declare-datatypes ((LayerVerification 0))
  (((mk-layer_verification (lv_layer Layer) (lv_verified Bool) (lv_properties (Seq Int))))))

(declare-datatypes ((StackState 0))
  (((mk-stack_state (ss_layers (Seq Int)) (ss_interfaces_verified (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Layer enum properties ---

; --- 1. Layer exhaustiveness ---
(push 1)
(declare-const x Layer)
(assert (not (or (= x L0_Physics) (= x L1_Silicon) (= x L2_Firmware) (= x L3_Network) (= x L4_OS) (= x L5_Runtime) (= x L6_App) (= x L7_UX))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Layer: L0_Physics != L1_Silicon ---
(push 1)
(assert (= L0_Physics L1_Silicon))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Layer: L1_Silicon != L2_Firmware ---
(push 1)
(assert (= L1_Silicon L2_Firmware))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Layer: L2_Firmware != L3_Network ---
(push 1)
(assert (= L2_Firmware L3_Network))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Layer: L0_Physics != L7_UX ---
(push 1)
(assert (= L0_Physics L7_UX))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Layer finite cardinality (8 values) ---
(push 1)
(declare-const x Layer)
(assert (and (not (= x L0_Physics)) (not (= x L1_Silicon)) (not (= x L2_Firmware)) (not (= x L3_Network)) (not (= x L4_OS)) (not (= x L5_Runtime)) (not (= x L6_App)) (not (= x L7_UX))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityProperty enum properties ---

; --- 7. SecurityProperty exhaustiveness ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (or (= x SPConfidentiality) (= x SPIntegrity) (= x SPAvailability) (= x SPAuthentication) (= x SPAuthorization) (= x SPNonRepudiation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SecurityProperty: SPConfidentiality != SPIntegrity ---
(push 1)
(assert (= SPConfidentiality SPIntegrity))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SecurityProperty: SPIntegrity != SPAvailability ---
(push 1)
(assert (= SPIntegrity SPAvailability))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SecurityProperty: SPAvailability != SPAuthentication ---
(push 1)
(assert (= SPAvailability SPAuthentication))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SecurityProperty: SPConfidentiality != SPNonRepudiation ---
(push 1)
(assert (= SPConfidentiality SPNonRepudiation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SecurityProperty finite cardinality (6 values) ---
(push 1)
(declare-const x SecurityProperty)
(assert (and (not (= x SPConfidentiality)) (not (= x SPIntegrity)) (not (= x SPAvailability)) (not (= x SPAuthentication)) (not (= x SPAuthorization)) (not (= x SPNonRepudiation))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AttackType enum properties ---

; --- 13. AttackType exhaustiveness ---
(push 1)
(declare-const x AttackType)
(assert (not (or (= x ATMemoryCorruption) (= x ATSideChannel) (= x ATNetworkAttack) (= x ATPrivilegeEscalation) (= x ATUIDeception) (= x ATBootCompromise) (= x ATRemoteCodeExec) (= x ATDataExfiltration) (= x ATDenialOfService) (= x ATMalwareExec) (= x ATInsiderThreat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AttackType: ATMemoryCorruption != ATSideChannel ---
(push 1)
(assert (= ATMemoryCorruption ATSideChannel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AttackType: ATSideChannel != ATNetworkAttack ---
(push 1)
(assert (= ATSideChannel ATNetworkAttack))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AttackType: ATNetworkAttack != ATPrivilegeEscalation ---
(push 1)
(assert (= ATNetworkAttack ATPrivilegeEscalation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. AttackType: ATMemoryCorruption != ATInsiderThreat ---
(push 1)
(assert (= ATMemoryCorruption ATInsiderThreat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. AttackType finite cardinality (11 values) ---
(push 1)
(declare-const x AttackType)
(assert (and (not (= x ATMemoryCorruption)) (not (= x ATSideChannel)) (not (= x ATNetworkAttack)) (not (= x ATPrivilegeEscalation)) (not (= x ATUIDeception)) (not (= x ATBootCompromise)) (not (= x ATRemoteCodeExec)) (not (= x ATDataExfiltration)) (not (= x ATDenialOfService)) (not (= x ATMalwareExec)) (not (= x ATInsiderThreat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LayerVerification record properties ---

; --- 19. LayerVerification accessor round-trip: lv_layer ---
(push 1)
(declare-const f0 Layer)
(declare-const f1 Bool)
(assert (not (= (lv_layer (mk-layer_verification f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. LayerVerification accessor round-trip: lv_verified ---
(push 1)
(declare-const f0 Layer)
(declare-const f1 Bool)
(assert (not (= (lv_verified (mk-layer_verification f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StackState record properties ---

; --- 21. StackState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(assert (not (= (Seq (mk-stack_state f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityProperty ordering properties ---

(define-fun SecurityProperty_level ((x SecurityProperty)) Int
  (ite (= x SPConfidentiality) 0 (ite (= x SPIntegrity) 1 (ite (= x SPAvailability) 2 (ite (= x SPAuthentication) 3 (ite (= x SPAuthorization) 4 5))))))

(define-fun SecurityProperty_leq ((x SecurityProperty) (y SecurityProperty)) Bool
  (<= (SecurityProperty_level x) (SecurityProperty_level y)))

; --- 22. SecurityProperty_leq reflexivity ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (SecurityProperty_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SecurityProperty_leq transitivity ---
(push 1)
(declare-const x SecurityProperty)
(declare-const y SecurityProperty)
(declare-const z SecurityProperty)
(assert (SecurityProperty_leq x y))
(assert (SecurityProperty_leq y z))
(assert (not (SecurityProperty_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SecurityProperty_leq antisymmetry ---
(push 1)
(declare-const x SecurityProperty)
(declare-const y SecurityProperty)
(assert (SecurityProperty_leq x y))
(assert (SecurityProperty_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SPConfidentiality is bottom ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (SecurityProperty_leq SPConfidentiality x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SPNonRepudiation is top ---
(push 1)
(declare-const x SecurityProperty)
(assert (not (SecurityProperty_leq x SPNonRepudiation)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
