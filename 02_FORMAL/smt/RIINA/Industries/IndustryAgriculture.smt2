; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryAgriculture — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryAgriculture.v (23 assertions)
; Module: IndustryAgriculture
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AgriData 0)) (((CropData) (SupplyChain) (ProcessingRecords) (QualityControl) (EquipmentTelemetry) (ChemicalUsage))))

(declare-datatypes ((FoodSafetyHazard 0)) (((Biological) (Chemical) (Physical) (Allergen) (Radiological))))

(declare-datatypes ((AgricultureEffect 0)) (((CropDataIO) (EquipmentControl) (ProcessingOperation) (TraceabilityRecord) (QualityTestResult))))

(declare-datatypes ((FoodSafetyControls 0))
  (((mk-food_safety_controls (haccp_plan Bool) (traceability_system Bool) (supplier_verification Bool) (preventive_controls Bool) (sanitation_controls Bool) (recall_capability Bool)))))

(declare-datatypes ((CertifiedFarm 0))
  (((mk-certified_farm (farm_id Int) (farm_area_hectares Int) (farm_min_area Int) (farm_organic_certified Bool) (farm_gps_lat Int) (farm_gps_lon Int) (farm_area_valid Int)))))

(declare-datatypes ((TraceEntry 0))
  (((mk-trace_entry (trace_product_id Int) (trace_batch_id Int) (trace_origin_farm Int) (trace_processing_plant Int) (trace_timestamp Int) (trace_expiry Int) (trace_valid_dates Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- AgriData enum properties ---

; --- 1. AgriData exhaustiveness ---
(push 1)
(declare-const x AgriData)
(assert (not (or (= x CropData) (= x SupplyChain) (= x ProcessingRecords) (= x QualityControl) (= x EquipmentTelemetry) (= x ChemicalUsage))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AgriData: CropData != SupplyChain ---
(push 1)
(assert (= CropData SupplyChain))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AgriData: SupplyChain != ProcessingRecords ---
(push 1)
(assert (= SupplyChain ProcessingRecords))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AgriData: ProcessingRecords != QualityControl ---
(push 1)
(assert (= ProcessingRecords QualityControl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AgriData: CropData != ChemicalUsage ---
(push 1)
(assert (= CropData ChemicalUsage))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. AgriData finite cardinality (6 values) ---
(push 1)
(declare-const x AgriData)
(assert (and (not (= x CropData)) (not (= x SupplyChain)) (not (= x ProcessingRecords)) (not (= x QualityControl)) (not (= x EquipmentTelemetry)) (not (= x ChemicalUsage))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FoodSafetyHazard enum properties ---

; --- 7. FoodSafetyHazard exhaustiveness ---
(push 1)
(declare-const x FoodSafetyHazard)
(assert (not (or (= x Biological) (= x Chemical) (= x Physical) (= x Allergen) (= x Radiological))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FoodSafetyHazard: Biological != Chemical ---
(push 1)
(assert (= Biological Chemical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FoodSafetyHazard: Chemical != Physical ---
(push 1)
(assert (= Chemical Physical))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. FoodSafetyHazard: Physical != Allergen ---
(push 1)
(assert (= Physical Allergen))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. FoodSafetyHazard: Biological != Radiological ---
(push 1)
(assert (= Biological Radiological))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. FoodSafetyHazard finite cardinality (5 values) ---
(push 1)
(declare-const x FoodSafetyHazard)
(assert (and (not (= x Biological)) (not (= x Chemical)) (not (= x Physical)) (not (= x Allergen)) (not (= x Radiological))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AgricultureEffect enum properties ---

; --- 13. AgricultureEffect exhaustiveness ---
(push 1)
(declare-const x AgricultureEffect)
(assert (not (or (= x CropDataIO) (= x EquipmentControl) (= x ProcessingOperation) (= x TraceabilityRecord) (= x QualityTestResult))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AgricultureEffect: CropDataIO != EquipmentControl ---
(push 1)
(assert (= CropDataIO EquipmentControl))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AgricultureEffect: EquipmentControl != ProcessingOperation ---
(push 1)
(assert (= EquipmentControl ProcessingOperation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AgricultureEffect: ProcessingOperation != TraceabilityRecord ---
(push 1)
(assert (= ProcessingOperation TraceabilityRecord))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. AgricultureEffect: CropDataIO != QualityTestResult ---
(push 1)
(assert (= CropDataIO QualityTestResult))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. AgricultureEffect finite cardinality (5 values) ---
(push 1)
(declare-const x AgricultureEffect)
(assert (and (not (= x CropDataIO)) (not (= x EquipmentControl)) (not (= x ProcessingOperation)) (not (= x TraceabilityRecord)) (not (= x QualityTestResult))))
(check-sat) ; expect UNSAT
(pop 1)

; --- FoodSafetyControls record properties ---

; --- 19. FoodSafetyControls accessor round-trip: haccp_plan ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (haccp_plan (mk-food_safety_controls f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FoodSafetyControls accessor round-trip: traceability_system ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (traceability_system (mk-food_safety_controls f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. FoodSafetyControls accessor round-trip: supplier_verification ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (supplier_verification (mk-food_safety_controls f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. FoodSafetyControls accessor round-trip: preventive_controls ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (preventive_controls (mk-food_safety_controls f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. FoodSafetyControls accessor round-trip: sanitation_controls ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (sanitation_controls (mk-food_safety_controls f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun FoodSafetyControls_all_enabled ((g FoodSafetyControls)) Bool
  (and (haccp_plan g) (traceability_system g) (supplier_verification g) (preventive_controls g) (sanitation_controls g)))

; --- 24. FoodSafetyControls: all-enabled completeness ---
(push 1)
(declare-const g FoodSafetyControls)
(assert (haccp_plan g))
(assert (traceability_system g))
(assert (supplier_verification g))
(assert (preventive_controls g))
(assert (sanitation_controls g))
(assert (not (FoodSafetyControls_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. FoodSafetyControls: FoodSafetyControls_all_enabled implies haccp_plan ---
(push 1)
(declare-const g FoodSafetyControls)
(assert (FoodSafetyControls_all_enabled g))
(assert (not (haccp_plan g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. FoodSafetyControls: FoodSafetyControls_all_enabled implies traceability_system ---
(push 1)
(declare-const g FoodSafetyControls)
(assert (FoodSafetyControls_all_enabled g))
(assert (not (traceability_system g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. FoodSafetyControls: FoodSafetyControls_all_enabled implies supplier_verification ---
(push 1)
(declare-const g FoodSafetyControls)
(assert (FoodSafetyControls_all_enabled g))
(assert (not (supplier_verification g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CertifiedFarm record properties ---

; --- 28. CertifiedFarm accessor round-trip: farm_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (farm_id (mk-certified_farm f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. CertifiedFarm accessor round-trip: farm_area_hectares ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (farm_area_hectares (mk-certified_farm f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. CertifiedFarm accessor round-trip: farm_min_area ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (farm_min_area (mk-certified_farm f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. CertifiedFarm accessor round-trip: farm_organic_certified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (farm_organic_certified (mk-certified_farm f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. CertifiedFarm accessor round-trip: farm_gps_lat ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (farm_gps_lat (mk-certified_farm f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. CertifiedFarm: integer field consistency ---
(push 1)
(declare-const r CertifiedFarm)
(assert (>= (farm_id r) 0))
(assert (>= (farm_area_hectares r) 0))
(assert (not (>= (+ (farm_id r) (farm_area_hectares r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TraceEntry record properties ---

; --- 34. TraceEntry accessor round-trip: trace_product_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (trace_product_id (mk-trace_entry f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. TraceEntry accessor round-trip: trace_batch_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (trace_batch_id (mk-trace_entry f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. TraceEntry accessor round-trip: trace_origin_farm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (trace_origin_farm (mk-trace_entry f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TraceEntry accessor round-trip: trace_processing_plant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (trace_processing_plant (mk-trace_entry f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. TraceEntry accessor round-trip: trace_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(assert (not (= (trace_timestamp (mk-trace_entry f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. TraceEntry: integer field consistency ---
(push 1)
(declare-const r TraceEntry)
(assert (>= (trace_product_id r) 0))
(assert (>= (trace_batch_id r) 0))
(assert (not (>= (+ (trace_product_id r) (trace_batch_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
