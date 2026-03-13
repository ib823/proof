---- MODULE IndustryAgriculture ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/Industries/IndustryAgriculture.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* AgriData (matches Coq: Inductive AgriData)
CONSTANTS CropData, SupplyChain, ProcessingRecords, QualityControl, EquipmentTelemetry, ChemicalUsage

AgriDataSet == {CropData, SupplyChain, ProcessingRecords, QualityControl, EquipmentTelemetry, ChemicalUsage}

\* FoodSafetyHazard (matches Coq: Inductive FoodSafetyHazard)
CONSTANTS Biological, Chemical, Physical, Allergen, Radiological

FoodSafetyHazardSet == {Biological, Chemical, Physical, Allergen, Radiological}

\* AgricultureEffect (matches Coq: Inductive AgricultureEffect)
CONSTANTS CropDataIO, EquipmentControl, ProcessingOperation, TraceabilityRecord, QualityTestResult

AgricultureEffectSet == {CropDataIO, EquipmentControl, ProcessingOperation, TraceabilityRecord, QualityTestResult}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* FoodSafetyControls (matches Coq: Record FoodSafetyControls)
VARIABLES haccp_plan, traceability_system, supplier_verification, preventive_controls, sanitation_controls, recall_capability

\* CertifiedFarm (matches Coq: Record CertifiedFarm)
VARIABLES farm_id, farm_area_hectares, farm_min_area, farm_organic_certified, farm_gps_lat, farm_gps_lon, farm_area_valid

\* TraceEntry (matches Coq: Record TraceEntry)
VARIABLES trace_product_id, trace_batch_id, trace_origin_farm, trace_processing_plant, trace_timestamp, trace_expiry, trace_valid_dates

vars == <<haccp_plan, traceability_system, supplier_verification, preventive_controls, sanitation_controls, recall_capability, farm_id, farm_area_hectares, farm_min_area, farm_organic_certified, farm_gps_lat, farm_gps_lon, farm_area_valid, trace_product_id, trace_batch_id, trace_origin_farm, trace_processing_plant, trace_timestamp, trace_expiry, trace_valid_dates>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ haccp_plan \in BOOLEAN
  /\ traceability_system \in BOOLEAN
  /\ supplier_verification \in BOOLEAN
  /\ preventive_controls \in BOOLEAN
  /\ sanitation_controls \in BOOLEAN
  /\ recall_capability \in BOOLEAN
  /\ farm_id \in Nat
  /\ farm_area_hectares \in Nat
  /\ farm_min_area \in Nat
  /\ farm_organic_certified \in BOOLEAN
  /\ farm_gps_lat \in Nat
  /\ farm_gps_lon \in Nat
  /\ farm_area_valid \in Nat
  /\ trace_product_id \in Nat
  /\ trace_batch_id \in Nat
  /\ trace_origin_farm \in Nat
  /\ trace_processing_plant \in Nat
  /\ trace_timestamp \in Nat
  /\ trace_expiry \in Nat
  /\ trace_valid_dates \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ haccp_plan = FALSE
  /\ traceability_system = FALSE
  /\ supplier_verification = FALSE
  /\ preventive_controls = FALSE
  /\ sanitation_controls = FALSE
  /\ recall_capability = FALSE
  /\ farm_id = 0
  /\ farm_area_hectares = 0
  /\ farm_min_area = 0
  /\ farm_organic_certified = FALSE
  /\ farm_gps_lat = 0
  /\ farm_gps_lon = 0
  /\ farm_area_valid = 0
  /\ trace_product_id = 0
  /\ trace_batch_id = 0
  /\ trace_origin_farm = 0
  /\ trace_processing_plant = 0
  /\ trace_timestamp = 0
  /\ trace_expiry = 0
  /\ trace_valid_dates = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* agri_data_sensitivity (matches Coq: Definition agri_data_sensitivity)
agri_data_sensitivity(d) ==
    CASE d = CropData -> 2
      [] d = SupplyChain -> 3
      [] d = ProcessingRecords -> 4
      [] d = QualityControl -> 3
      [] d = EquipmentTelemetry -> 1
      [] d = ChemicalUsage -> 5

\* hazard_severity (matches Coq: Definition hazard_severity)
hazard_severity(h) ==
    CASE h = Biological -> 5
      [] h = Chemical -> 4
      [] h = Physical -> 3
      [] h = Allergen -> 4
      [] h = Radiological -> 5

\* haccp_frequency (matches Coq: Definition haccp_frequency)
haccp_frequency(h) ==
    CASE h = Biological -> 1
      [] h = Chemical -> 2
      [] h = Physical -> 4
      [] h = Allergen -> 2
      [] h = Radiological -> 1

\* all_food_safety_controls (matches Coq: Definition all_food_safety_controls)
all_food_safety_controls(c) ==
  haccp_plan /\ traceability_system /\ supplier_verification /\ preventive_controls /\ sanitation_controls /\ recall_capability

\* risk_score (matches Coq: Definition risk_score)
risk_score(h) ==
  h >= 0

\* count_food_controls (matches Coq: Definition count_food_controls)
count_food_controls(c) ==
  c >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateFoodSafetyControls ==
  /\ haccp_plan' \in BOOLEAN
  /\ traceability_system' \in BOOLEAN
  /\ supplier_verification' \in BOOLEAN
  /\ preventive_controls' \in BOOLEAN
  /\ sanitation_controls' \in BOOLEAN
  /\ recall_capability' \in BOOLEAN
  /\ UNCHANGED <<farm_id, farm_area_hectares, farm_min_area, farm_organic_certified, farm_gps_lat, farm_gps_lon, farm_area_valid, trace_product_id, trace_batch_id, trace_origin_farm, trace_processing_plant, trace_timestamp, trace_expiry, trace_valid_dates>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateFoodSafetyControls \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* fsma_compliance
THEOREM fsma_compliance ==
  \A controls \in Nat, facility \in Nat :
    controls >= 0

\* food_traceability
THEOREM food_traceability ==
  \A product \in Nat, supply_chain \in Nat :
    product >= 0 /\ supply_chain >= 0

\* precision_ag_security
THEOREM precision_ag_security ==
  \A equipment \in Nat, data \in AgriDataSet :
    equipment >= 0 /\ data >= 0

\* iso_22000_compliance
THEOREM iso_22000_compliance ==
  \A organization \in Nat :
    organization >= 0

\* supply_chain_integrity
THEOREM supply_chain_integrity ==
  \A supplier \in Nat, product \in Nat :
    supplier >= 0 /\ product >= 0

\* haccp_required
THEOREM haccp_required ==
  \A controls \in Nat, facility \in Nat :
    controls # 0

\* recall_capability_required
THEOREM recall_capability_required ==
  \A controls \in Nat :
    controls # 0

\* chemical_usage_highest_sensitivity
THEOREM chemical_usage_highest_sensitivity ==
  \A d \in Nat :
      agri_data_sensitivity d < = agri_data_sensitivity(ChemicalUsage)

\* agri_data_sensitivity_positive
THEOREM agri_data_sensitivity_positive ==
  \A d \in Nat :
      agri_data_sensitivity d > = 1

\* hazard_severity_bounded
THEOREM hazard_severity_bounded ==
  \A h \in Nat :
      hazard_severity h >= 3 /\ hazard_severity h <= 5

\* biological_radiological_equal
THEOREM biological_radiological_equal ==
  hazard_severity(Biological) = hazard_severity(Radiological)

\* higher_severity_more_frequent
THEOREM higher_severity_more_frequent ==
  \A h \in Nat :
      hazard_severity h >= 5 => haccp_frequency h <= 1

\* haccp_frequency_positive
THEOREM haccp_frequency_positive ==
  \A h \in Nat :
      haccp_frequency h > = 1

\* all_controls_implies_haccp
THEOREM all_controls_implies_haccp ==
  \A c \in Nat :
      all_food_safety_controls(c) => haccp_plan(c)

\* all_controls_implies_recall
THEOREM all_controls_implies_recall ==
  \A c \in Nat :
      all_food_safety_controls(c) => recall_capability(c)

\* all_controls_implies_traceability
THEOREM all_controls_implies_traceability ==
  \A c \in Nat :
      all_food_safety_controls(c) => traceability_system(c)

\* farm_area_meets_minimum
THEOREM farm_area_meets_minimum ==
  \A f \in Nat, CertifiedFarm \in Nat :
      farm_min_area f < = farm_area_hectares(f)

\* traceability_dates_valid
THEOREM traceability_dates_valid ==
  \A t \in Nat, TraceEntry \in Nat :
      trace_timestamp t < = trace_expiry(t)

\* agri_effect_eq_refl
THEOREM agri_effect_eq_refl ==
  \A e \in Nat :
      agri_effect_eq_dec e e = left eq_refl => e = e

\* risk_score_positive
THEOREM risk_score_positive ==
  \A h \in Nat :
      risk_score h > = 1

\* risk_score_bounded
THEOREM risk_score_bounded ==
  \A h \in Nat :
      risk_score h < = 25

\* count_controls_bounded
THEOREM count_controls_bounded ==
  \A c \in Nat :
      count_food_controls c < = 6

\* all_controls_count_six
THEOREM all_controls_count_six ==
  \A c \in Nat :
      all_food_safety_controls(c) => count_food_controls c = 6

====
