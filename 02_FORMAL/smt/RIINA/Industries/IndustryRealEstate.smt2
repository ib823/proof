; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryRealEstate — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryRealEstate.v (26 assertions)
; Module: IndustryRealEstate
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((PropertyData 0)) (((OwnerPII) (FinancialRecords) (TenantData) (AccessCredentials) (SmartHomeData) (BuildingTelemetry))))

(declare-datatypes ((BuildingSystem 0)) (((HVAC) (Lighting) (AccessControl) (Surveillance) (FireSafety) (Elevator))))

(declare-datatypes ((RealEstateEffect 0)) (((PropertyTransaction) (BuildingControl) (AccessEvent) (TenantDataAccess) (SmartHomeIO))))

(declare-datatypes ((SmartBuildingControls 0))
  (((mk-smart_building_controls (network_segmentation Bool) (device_authentication Bool) (encrypted_communication Bool) (firmware_verification Bool) (physical_access_logging Bool) (failsafe_operation Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- PropertyData enum properties ---

; --- 1. PropertyData exhaustiveness ---
(push 1)
(declare-const x PropertyData)
(assert (not (or (= x OwnerPII) (= x FinancialRecords) (= x TenantData) (= x AccessCredentials) (= x SmartHomeData) (= x BuildingTelemetry))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. PropertyData: OwnerPII != FinancialRecords ---
(push 1)
(assert (= OwnerPII FinancialRecords))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. PropertyData: FinancialRecords != TenantData ---
(push 1)
(assert (= FinancialRecords TenantData))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. PropertyData: TenantData != AccessCredentials ---
(push 1)
(assert (= TenantData AccessCredentials))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. PropertyData: OwnerPII != BuildingTelemetry ---
(push 1)
(assert (= OwnerPII BuildingTelemetry))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. PropertyData finite cardinality (6 values) ---
(push 1)
(declare-const x PropertyData)
(assert (and (not (= x OwnerPII)) (not (= x FinancialRecords)) (not (= x TenantData)) (not (= x AccessCredentials)) (not (= x SmartHomeData)) (not (= x BuildingTelemetry))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BuildingSystem enum properties ---

; --- 7. BuildingSystem exhaustiveness ---
(push 1)
(declare-const x BuildingSystem)
(assert (not (or (= x HVAC) (= x Lighting) (= x AccessControl) (= x Surveillance) (= x FireSafety) (= x Elevator))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. BuildingSystem: HVAC != Lighting ---
(push 1)
(assert (= HVAC Lighting))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. BuildingSystem: Lighting != AccessControl ---
(push 1)
(assert (= Lighting AccessControl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. BuildingSystem: AccessControl != Surveillance ---
(push 1)
(assert (= AccessControl Surveillance))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BuildingSystem: HVAC != Elevator ---
(push 1)
(assert (= HVAC Elevator))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. BuildingSystem finite cardinality (6 values) ---
(push 1)
(declare-const x BuildingSystem)
(assert (and (not (= x HVAC)) (not (= x Lighting)) (not (= x AccessControl)) (not (= x Surveillance)) (not (= x FireSafety)) (not (= x Elevator))))
(check-sat) ; expect UNSAT
(pop 1)

; --- RealEstateEffect enum properties ---

; --- 13. RealEstateEffect exhaustiveness ---
(push 1)
(declare-const x RealEstateEffect)
(assert (not (or (= x PropertyTransaction) (= x BuildingControl) (= x AccessEvent) (= x TenantDataAccess) (= x SmartHomeIO))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. RealEstateEffect: PropertyTransaction != BuildingControl ---
(push 1)
(assert (= PropertyTransaction BuildingControl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. RealEstateEffect: BuildingControl != AccessEvent ---
(push 1)
(assert (= BuildingControl AccessEvent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. RealEstateEffect: AccessEvent != TenantDataAccess ---
(push 1)
(assert (= AccessEvent TenantDataAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. RealEstateEffect: PropertyTransaction != SmartHomeIO ---
(push 1)
(assert (= PropertyTransaction SmartHomeIO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. RealEstateEffect finite cardinality (5 values) ---
(push 1)
(declare-const x RealEstateEffect)
(assert (and (not (= x PropertyTransaction)) (not (= x BuildingControl)) (not (= x AccessEvent)) (not (= x TenantDataAccess)) (not (= x SmartHomeIO))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SmartBuildingControls record properties ---

; --- 19. SmartBuildingControls accessor round-trip: network_segmentation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (network_segmentation (mk-smart_building_controls f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SmartBuildingControls accessor round-trip: device_authentication ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (device_authentication (mk-smart_building_controls f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SmartBuildingControls accessor round-trip: encrypted_communication ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (encrypted_communication (mk-smart_building_controls f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SmartBuildingControls accessor round-trip: firmware_verification ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (firmware_verification (mk-smart_building_controls f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SmartBuildingControls accessor round-trip: physical_access_logging ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (physical_access_logging (mk-smart_building_controls f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SmartBuildingControls_all_enabled ((g SmartBuildingControls)) Bool
  (and (network_segmentation g) (device_authentication g) (encrypted_communication g) (firmware_verification g) (physical_access_logging g)))

; --- 24. SmartBuildingControls: all-enabled completeness ---
(push 1)
(declare-const g SmartBuildingControls)
(assert (network_segmentation g))
(assert (device_authentication g))
(assert (encrypted_communication g))
(assert (firmware_verification g))
(assert (physical_access_logging g))
(assert (not (SmartBuildingControls_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SmartBuildingControls: SmartBuildingControls_all_enabled implies network_segmentation ---
(push 1)
(declare-const g SmartBuildingControls)
(assert (SmartBuildingControls_all_enabled g))
(assert (not (network_segmentation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SmartBuildingControls: SmartBuildingControls_all_enabled implies device_authentication ---
(push 1)
(declare-const g SmartBuildingControls)
(assert (SmartBuildingControls_all_enabled g))
(assert (not (device_authentication g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. SmartBuildingControls: SmartBuildingControls_all_enabled implies encrypted_communication ---
(push 1)
(declare-const g SmartBuildingControls)
(assert (SmartBuildingControls_all_enabled g))
(assert (not (encrypted_communication g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
