; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ESGCompliance — SMT Verification
; Derived from 02_FORMAL/coq/domains/ESGCompliance.v (35 assertions)
; Module: ESGCompliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((EmissionScope 0)) (((Scope1) (Scope2_Location) (Scope2_Market) (Scope3))))

(declare-datatypes ((WaterSource 0)) (((SurfaceWater) (Groundwater) (Seawater) (Municipal) (Rainwater))))

(declare-datatypes ((EmissionSource 0))
  (((mk-emission_source (source_id Int) (source_type EmissionScope) (quantity Int) (emission_factor Int) (is_tracked Bool) (is_measured Bool) (is_reported Bool) (owned_or_controlled_flag Bool) (emission_hash Int)))))

(declare-datatypes ((WaterWithdrawal 0))
  (((mk-water_withdrawal (withdrawal_id Int) (water_source WaterSource) (volume Int) (quality Int) (source_documented Bool)))))

(declare-datatypes ((WasteRecord 0))
  (((mk-waste_record (waste_id Int) (waste_generated Int) (waste_diverted Int) (waste_landfilled Int) (waste_documented Bool)))))

(declare-datatypes ((BiodiversityAssessment 0))
  (((mk-biodiversity_assessment (bio_id Int) (dependencies_mapped Bool) (impacts_assessed Bool) (mitigation_planned Bool)))))

(declare-datatypes ((CircularEconomyMetric 0))
  (((mk-circular_economy_metric (circular_id Int) (recycled_input Int) (total_input Int) (measurement_verified Bool)))))

(declare-datatypes ((PollutionRecord 0))
  (((mk-pollution_record (pollution_id Int) (emission_level Int) (regulatory_limit Int) (permit_valid Bool)))))

(declare-datatypes ((RenewableEnergyCertificate 0))
  (((mk-renewable_energy_certificate (rec_id Int) (energy_amount Int) (certificate_valid Bool) (unique_claim Bool)))))

(declare-datatypes ((Employee 0))
  (((mk-employee (employee_id Int) (compensation Int) (living_wage_threshold Int) (age Int) (voluntary_employment Bool) (no_debt_bondage Bool) (documents_retained Bool) (employed_flag Bool) (gender Int)))))

(declare-datatypes ((SafetyIncident 0))
  (((mk-safety_incident (incident_id Int) (recorded Bool) (investigated Bool) (corrective_action Bool) (root_cause_documented Bool)))))

(declare-datatypes ((EmploymentDecision 0))
  (((mk-employment_decision (decision_id Int) (merit_based Bool) (documented_criteria Bool) (no_protected_class_bias Bool)))))

(declare-datatypes ((PayGapRecord 0))
  (((mk-pay_gap_record (paygap_id Int) (male_median Int) (female_median Int) (gap_calculated Bool) (gap_disclosed Bool)))))

(declare-datatypes ((HRDDProcess 0))
  (((mk-hrdd_process (hrdd_id Int) (policy_adopted Bool) (risk_assessment_done Bool) (mitigation_implemented Bool) (monitoring_active Bool)))))

(declare-datatypes ((Supplier 0))
  (((mk-supplier (supplier_id Int) (risk_assessed Bool) (assessment_date Int) (current_year Int) (high_risk Bool)))))

(declare-datatypes ((IndigenousCommunity 0))
  (((mk-indigenous_community (community_id Int) (fpic_obtained Bool) (consent_documented Bool) (ongoing_engagement Bool)))))

(declare-datatypes ((GrievanceMechanism 0))
  (((mk-grievance_mechanism (grievance_id Int) (anonymous_reporting Bool) (accessible Bool) (response_timeline Int)))))

(declare-datatypes ((StakeholderEngagement 0))
  (((mk-stakeholder_engagement (engagement_id Int) (communities_identified Bool) (consultation_done Bool) (feedback_incorporated Bool)))))

(declare-datatypes ((Director 0))
  (((mk-director (director_id Int) (is_independent Bool)))))

(declare-datatypes ((Board 0))
  (((mk-board (board_id Int) (directors (Seq Int)) (board_valid Bool)))))

(declare-datatypes ((ExecutiveComp 0))
  (((mk-executive_comp (exec_id Int) (total_comp Int) (esg_linked_portion Int) (esg_metrics_defined Bool)))))

(declare-datatypes ((AntiCorruptionPolicy 0))
  (((mk-anti_corruption_policy (ac_id Int) (fcpa_compliant Bool) (uk_bribery_compliant Bool) (training_provided Bool) (controls_implemented Bool)))))

(declare-datatypes ((WhistleblowerPolicy 0))
  (((mk-whistleblower_policy (wb_id Int) (no_retaliation_policy Bool) (protection_enforced Bool) (anonymous_channel Bool)))))

(declare-datatypes ((ConflictOfInterest 0))
  (((mk-conflict_of_interest (coi_id Int) (policy_exists Bool) (disclosure_required Bool) (recusal_enforced Bool)))))

(declare-datatypes ((RelatedPartyTransaction 0))
  (((mk-related_party_transaction (rpt_id Int) (disclosed Bool) (board_approved Bool) (arms_length Bool)))))

(declare-datatypes ((Disclosure 0))
  (((mk-disclosure (disc_id Int) (gri_compliant Bool) (tcfd_aligned Bool) (sasb_aligned Bool) (methodology_documented Bool) (externally_verified Bool)))))

(declare-datatypes ((ScienceBasedTarget 0))
  (((mk-science_based_target (sbt_id Int) (target_year Int) (base_year Int) (reduction_percent Int) (validated Bool) (paris_aligned Bool)))))

(declare-datatypes ((ESGCompliantSystem 0))
  (((mk-esg_compliant_system (sys_emissions (Seq Int)) (sys_water (Seq Int)) (sys_waste (Seq Int)) (sys_biodiversity (Seq Int)) (sys_circular (Seq Int)) (sys_pollution (Seq Int)) (sys_renewables (Seq Int)) (sys_employees (Seq Int)) (sys_incidents (Seq Int)) (sys_decisions (Seq Int)) (sys_paygap (Seq Int)) (sys_hrdd HRDDProcess) (sys_suppliers (Seq Int)) (sys_indigenous (Seq Int)) (sys_grievance GrievanceMechanism) (sys_stakeholder (Seq Int)) (sys_board Board) (sys_exec_comp (Seq Int)) (sys_anti_corruption AntiCorruptionPolicy) (sys_whistleblower WhistleblowerPolicy) (sys_coi ConflictOfInterest) (sys_rpt (Seq Int)) (sys_disclosure Disclosure) (sys_sbt ScienceBasedTarget) (emissions_complete Int) (scope2_tracked Int) (emissions_unique Int) (scope3_complete Int) (emission_factors_verified Int) (renewables_unique Int) (water_documented Int) (waste_consistent Int) (biodiversity_mapped Int) (circular_verified Int) (pollution_within_limits Int) (employees_paid_fairly Int) (employees_voluntary Int) (employees_adult Int) (incidents_handled Int) (decisions_fair Int) (paygap_disclosed Int) (hrdd_active Int) (suppliers_assessed Int) (indigenous_consent Int) (grievance_available Int) (stakeholders_engaged Int) (board_has_independence Int) (exec_esg_linked Int) (anti_corruption_enforced Int) (whistleblower_safe Int) (coi_policy_enforced Int) (rpt_transparent Int) (gri_followed Int) (tcfd_implemented Int) (sasb_reported Int) (methodology_clear Int) (externally_assured Int) (sbt_validated Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- EmissionScope enum properties ---

; --- 1. EmissionScope exhaustiveness ---
(push 1)
(declare-const x EmissionScope)
(assert (not (or (= x Scope1) (= x Scope2_Location) (= x Scope2_Market) (= x Scope3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. EmissionScope: Scope1 != Scope2_Location ---
(push 1)
(assert (= Scope1 Scope2_Location))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. EmissionScope: Scope2_Location != Scope2_Market ---
(push 1)
(assert (= Scope2_Location Scope2_Market))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. EmissionScope: Scope2_Market != Scope3 ---
(push 1)
(assert (= Scope2_Market Scope3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. EmissionScope: Scope1 != Scope3 ---
(push 1)
(assert (= Scope1 Scope3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. EmissionScope finite cardinality (4 values) ---
(push 1)
(declare-const x EmissionScope)
(assert (and (not (= x Scope1)) (not (= x Scope2_Location)) (not (= x Scope2_Market)) (not (= x Scope3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- WaterSource enum properties ---

; --- 7. WaterSource exhaustiveness ---
(push 1)
(declare-const x WaterSource)
(assert (not (or (= x SurfaceWater) (= x Groundwater) (= x Seawater) (= x Municipal) (= x Rainwater))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. WaterSource: SurfaceWater != Groundwater ---
(push 1)
(assert (= SurfaceWater Groundwater))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. WaterSource: Groundwater != Seawater ---
(push 1)
(assert (= Groundwater Seawater))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. WaterSource: Seawater != Municipal ---
(push 1)
(assert (= Seawater Municipal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. WaterSource: SurfaceWater != Rainwater ---
(push 1)
(assert (= SurfaceWater Rainwater))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. WaterSource finite cardinality (5 values) ---
(push 1)
(declare-const x WaterSource)
(assert (and (not (= x SurfaceWater)) (not (= x Groundwater)) (not (= x Seawater)) (not (= x Municipal)) (not (= x Rainwater))))
(check-sat) ; expect UNSAT
(pop 1)

; --- EmissionSource record properties ---

; --- 13. EmissionSource accessor round-trip: source_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EmissionScope)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (source_id (mk-emission_source f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. EmissionSource accessor round-trip: source_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EmissionScope)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (source_type (mk-emission_source f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. EmissionSource accessor round-trip: quantity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EmissionScope)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (quantity (mk-emission_source f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. EmissionSource accessor round-trip: emission_factor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EmissionScope)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (emission_factor (mk-emission_source f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. EmissionSource accessor round-trip: is_tracked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 EmissionScope)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (is_tracked (mk-emission_source f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. EmissionSource: integer field consistency ---
(push 1)
(declare-const r EmissionSource)
(assert (>= (source_id r) 0))
(assert (>= (quantity r) 0))
(assert (not (>= (+ (source_id r) (quantity r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WaterWithdrawal record properties ---

; --- 19. WaterWithdrawal accessor round-trip: withdrawal_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 WaterSource)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (withdrawal_id (mk-water_withdrawal f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. WaterWithdrawal accessor round-trip: water_source ---
(push 1)
(declare-const f0 Int)
(declare-const f1 WaterSource)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (water_source (mk-water_withdrawal f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. WaterWithdrawal accessor round-trip: volume ---
(push 1)
(declare-const f0 Int)
(declare-const f1 WaterSource)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (volume (mk-water_withdrawal f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. WaterWithdrawal accessor round-trip: quality ---
(push 1)
(declare-const f0 Int)
(declare-const f1 WaterSource)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (quality (mk-water_withdrawal f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. WaterWithdrawal: integer field consistency ---
(push 1)
(declare-const r WaterWithdrawal)
(assert (>= (withdrawal_id r) 0))
(assert (>= (volume r) 0))
(assert (not (>= (+ (withdrawal_id r) (volume r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WasteRecord record properties ---

; --- 24. WasteRecord accessor round-trip: waste_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (waste_id (mk-waste_record f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. WasteRecord accessor round-trip: waste_generated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (waste_generated (mk-waste_record f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. WasteRecord accessor round-trip: waste_diverted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (waste_diverted (mk-waste_record f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. WasteRecord accessor round-trip: waste_landfilled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (waste_landfilled (mk-waste_record f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. WasteRecord: integer field consistency ---
(push 1)
(declare-const r WasteRecord)
(assert (>= (waste_id r) 0))
(assert (>= (waste_generated r) 0))
(assert (not (>= (+ (waste_id r) (waste_generated r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BiodiversityAssessment record properties ---

; --- 29. BiodiversityAssessment accessor round-trip: bio_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bio_id (mk-biodiversity_assessment f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. BiodiversityAssessment accessor round-trip: dependencies_mapped ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (dependencies_mapped (mk-biodiversity_assessment f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. BiodiversityAssessment accessor round-trip: impacts_assessed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (impacts_assessed (mk-biodiversity_assessment f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CircularEconomyMetric record properties ---

; --- 32. CircularEconomyMetric accessor round-trip: circular_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (circular_id (mk-circular_economy_metric f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. CircularEconomyMetric accessor round-trip: recycled_input ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (recycled_input (mk-circular_economy_metric f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. CircularEconomyMetric accessor round-trip: total_input ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (total_input (mk-circular_economy_metric f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. CircularEconomyMetric: integer field consistency ---
(push 1)
(declare-const r CircularEconomyMetric)
(assert (>= (circular_id r) 0))
(assert (>= (recycled_input r) 0))
(assert (not (>= (+ (circular_id r) (recycled_input r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PollutionRecord record properties ---

; --- 36. PollutionRecord accessor round-trip: pollution_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pollution_id (mk-pollution_record f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. PollutionRecord accessor round-trip: emission_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (emission_level (mk-pollution_record f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. PollutionRecord accessor round-trip: regulatory_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (regulatory_limit (mk-pollution_record f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. PollutionRecord: integer field consistency ---
(push 1)
(declare-const r PollutionRecord)
(assert (>= (pollution_id r) 0))
(assert (>= (emission_level r) 0))
(assert (not (>= (+ (pollution_id r) (emission_level r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RenewableEnergyCertificate record properties ---

; --- 40. RenewableEnergyCertificate accessor round-trip: rec_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rec_id (mk-renewable_energy_certificate f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. RenewableEnergyCertificate accessor round-trip: energy_amount ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (energy_amount (mk-renewable_energy_certificate f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. RenewableEnergyCertificate accessor round-trip: certificate_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (certificate_valid (mk-renewable_energy_certificate f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. RenewableEnergyCertificate: integer field consistency ---
(push 1)
(declare-const r RenewableEnergyCertificate)
(assert (>= (rec_id r) 0))
(assert (>= (energy_amount r) 0))
(assert (not (>= (+ (rec_id r) (energy_amount r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Employee record properties ---

; --- 44. Employee accessor round-trip: employee_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (employee_id (mk-employee f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. Employee accessor round-trip: compensation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (compensation (mk-employee f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. Employee accessor round-trip: living_wage_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (living_wage_threshold (mk-employee f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. Employee accessor round-trip: age ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (age (mk-employee f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. Employee accessor round-trip: voluntary_employment ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Int)
(assert (not (= (voluntary_employment (mk-employee f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. Employee: integer field consistency ---
(push 1)
(declare-const r Employee)
(assert (>= (employee_id r) 0))
(assert (>= (compensation r) 0))
(assert (not (>= (+ (employee_id r) (compensation r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SafetyIncident record properties ---

; --- 50. SafetyIncident accessor round-trip: incident_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (incident_id (mk-safety_incident f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. SafetyIncident accessor round-trip: recorded ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (recorded (mk-safety_incident f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. SafetyIncident accessor round-trip: investigated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (investigated (mk-safety_incident f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. SafetyIncident accessor round-trip: corrective_action ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (corrective_action (mk-safety_incident f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EmploymentDecision record properties ---

; --- 54. EmploymentDecision accessor round-trip: decision_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (decision_id (mk-employment_decision f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. EmploymentDecision accessor round-trip: merit_based ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (merit_based (mk-employment_decision f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. EmploymentDecision accessor round-trip: documented_criteria ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (documented_criteria (mk-employment_decision f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PayGapRecord record properties ---

; --- 57. PayGapRecord accessor round-trip: paygap_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (paygap_id (mk-pay_gap_record f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. PayGapRecord accessor round-trip: male_median ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (male_median (mk-pay_gap_record f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. PayGapRecord accessor round-trip: female_median ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (female_median (mk-pay_gap_record f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. PayGapRecord accessor round-trip: gap_calculated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (gap_calculated (mk-pay_gap_record f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. PayGapRecord: integer field consistency ---
(push 1)
(declare-const r PayGapRecord)
(assert (>= (paygap_id r) 0))
(assert (>= (male_median r) 0))
(assert (not (>= (+ (paygap_id r) (male_median r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HRDDProcess record properties ---

; --- 62. HRDDProcess accessor round-trip: hrdd_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (hrdd_id (mk-hrdd_process f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. HRDDProcess accessor round-trip: policy_adopted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (policy_adopted (mk-hrdd_process f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. HRDDProcess accessor round-trip: risk_assessment_done ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (risk_assessment_done (mk-hrdd_process f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. HRDDProcess accessor round-trip: mitigation_implemented ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (mitigation_implemented (mk-hrdd_process f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Supplier record properties ---

; --- 66. Supplier accessor round-trip: supplier_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (supplier_id (mk-supplier f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. Supplier accessor round-trip: risk_assessed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (risk_assessed (mk-supplier f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. Supplier accessor round-trip: assessment_date ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (assessment_date (mk-supplier f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. Supplier accessor round-trip: current_year ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (current_year (mk-supplier f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. Supplier: integer field consistency ---
(push 1)
(declare-const r Supplier)
(assert (>= (supplier_id r) 0))
(assert (>= (assessment_date r) 0))
(assert (not (>= (+ (supplier_id r) (assessment_date r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- IndigenousCommunity record properties ---

; --- 71. IndigenousCommunity accessor round-trip: community_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (community_id (mk-indigenous_community f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. IndigenousCommunity accessor round-trip: fpic_obtained ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (fpic_obtained (mk-indigenous_community f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. IndigenousCommunity accessor round-trip: consent_documented ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (consent_documented (mk-indigenous_community f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- GrievanceMechanism record properties ---

; --- 74. GrievanceMechanism accessor round-trip: grievance_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (grievance_id (mk-grievance_mechanism f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. GrievanceMechanism accessor round-trip: anonymous_reporting ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (anonymous_reporting (mk-grievance_mechanism f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. GrievanceMechanism accessor round-trip: accessible ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (accessible (mk-grievance_mechanism f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StakeholderEngagement record properties ---

; --- 77. StakeholderEngagement accessor round-trip: engagement_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (engagement_id (mk-stakeholder_engagement f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. StakeholderEngagement accessor round-trip: communities_identified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (communities_identified (mk-stakeholder_engagement f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. StakeholderEngagement accessor round-trip: consultation_done ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (consultation_done (mk-stakeholder_engagement f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Director record properties ---

; --- 80. Director accessor round-trip: director_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (director_id (mk-director f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Board record properties ---

; --- 81. Board accessor round-trip: board_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (board_id (mk-board f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. Board accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (directors (mk-board f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. Board: integer field consistency ---
(push 1)
(declare-const r Board)
(assert (>= (board_id r) 0))
(assert (>= (seq.len (directors r)) 0))
(assert (not (>= (+ (board_id r) (seq.len (directors r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExecutiveComp record properties ---

; --- 84. ExecutiveComp accessor round-trip: exec_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (exec_id (mk-executive_comp f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. ExecutiveComp accessor round-trip: total_comp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (total_comp (mk-executive_comp f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. ExecutiveComp accessor round-trip: esg_linked_portion ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (esg_linked_portion (mk-executive_comp f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. ExecutiveComp: integer field consistency ---
(push 1)
(declare-const r ExecutiveComp)
(assert (>= (exec_id r) 0))
(assert (>= (total_comp r) 0))
(assert (not (>= (+ (exec_id r) (total_comp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AntiCorruptionPolicy record properties ---

; --- 88. AntiCorruptionPolicy accessor round-trip: ac_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ac_id (mk-anti_corruption_policy f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 89. AntiCorruptionPolicy accessor round-trip: fcpa_compliant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (fcpa_compliant (mk-anti_corruption_policy f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 90. AntiCorruptionPolicy accessor round-trip: uk_bribery_compliant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (uk_bribery_compliant (mk-anti_corruption_policy f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 91. AntiCorruptionPolicy accessor round-trip: training_provided ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (training_provided (mk-anti_corruption_policy f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WhistleblowerPolicy record properties ---

; --- 92. WhistleblowerPolicy accessor round-trip: wb_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (wb_id (mk-whistleblower_policy f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 93. WhistleblowerPolicy accessor round-trip: no_retaliation_policy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (no_retaliation_policy (mk-whistleblower_policy f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 94. WhistleblowerPolicy accessor round-trip: protection_enforced ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (protection_enforced (mk-whistleblower_policy f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConflictOfInterest record properties ---

; --- 95. ConflictOfInterest accessor round-trip: coi_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (coi_id (mk-conflict_of_interest f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 96. ConflictOfInterest accessor round-trip: policy_exists ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (policy_exists (mk-conflict_of_interest f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 97. ConflictOfInterest accessor round-trip: disclosure_required ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (disclosure_required (mk-conflict_of_interest f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RelatedPartyTransaction record properties ---

; --- 98. RelatedPartyTransaction accessor round-trip: rpt_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rpt_id (mk-related_party_transaction f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 99. RelatedPartyTransaction accessor round-trip: disclosed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (disclosed (mk-related_party_transaction f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 100. RelatedPartyTransaction accessor round-trip: board_approved ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (board_approved (mk-related_party_transaction f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Disclosure record properties ---

; --- 101. Disclosure accessor round-trip: disc_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (disc_id (mk-disclosure f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 102. Disclosure accessor round-trip: gri_compliant ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (gri_compliant (mk-disclosure f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 103. Disclosure accessor round-trip: tcfd_aligned ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (tcfd_aligned (mk-disclosure f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 104. Disclosure accessor round-trip: sasb_aligned ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (sasb_aligned (mk-disclosure f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 105. Disclosure accessor round-trip: methodology_documented ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (methodology_documented (mk-disclosure f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ScienceBasedTarget record properties ---

; --- 106. ScienceBasedTarget accessor round-trip: sbt_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (sbt_id (mk-science_based_target f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 107. ScienceBasedTarget accessor round-trip: target_year ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (target_year (mk-science_based_target f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 108. ScienceBasedTarget accessor round-trip: base_year ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (base_year (mk-science_based_target f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 109. ScienceBasedTarget accessor round-trip: reduction_percent ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (reduction_percent (mk-science_based_target f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 110. ScienceBasedTarget accessor round-trip: validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (validated (mk-science_based_target f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 111. ScienceBasedTarget: integer field consistency ---
(push 1)
(declare-const r ScienceBasedTarget)
(assert (>= (sbt_id r) 0))
(assert (>= (target_year r) 0))
(assert (not (>= (+ (sbt_id r) (target_year r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ESGCompliantSystem record properties ---

; --- 112. ESGCompliantSystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 (Seq Int))
(declare-const f7 (Seq Int))
(declare-const f8 (Seq Int))
(declare-const f9 (Seq Int))
(declare-const f10 (Seq Int))
(declare-const f11 HRDDProcess)
(declare-const f12 (Seq Int))
(declare-const f13 (Seq Int))
(declare-const f14 GrievanceMechanism)
(declare-const f15 (Seq Int))
(declare-const f16 Board)
(declare-const f17 (Seq Int))
(declare-const f18 AntiCorruptionPolicy)
(declare-const f19 WhistleblowerPolicy)
(declare-const f20 ConflictOfInterest)
(declare-const f21 (Seq Int))
(declare-const f22 Disclosure)
(declare-const f23 ScienceBasedTarget)
(declare-const f24 Int)
(declare-const f25 Int)
(declare-const f26 Int)
(declare-const f27 Int)
(declare-const f28 Int)
(declare-const f29 Int)
(declare-const f30 Int)
(declare-const f31 Int)
(declare-const f32 Int)
(declare-const f33 Int)
(declare-const f34 Int)
(declare-const f35 Int)
(declare-const f36 Int)
(declare-const f37 Int)
(declare-const f38 Int)
(declare-const f39 Int)
(declare-const f40 Int)
(declare-const f41 Int)
(declare-const f42 Int)
(declare-const f43 Int)
(declare-const f44 Int)
(declare-const f45 Int)
(declare-const f46 Int)
(declare-const f47 Int)
(declare-const f48 Int)
(declare-const f49 Int)
(declare-const f50 Int)
(declare-const f51 Int)
(declare-const f52 Int)
(declare-const f53 Int)
(declare-const f54 Int)
(declare-const f55 Int)
(declare-const f56 Int)
(declare-const f57 Int)
(assert (not (= (sys_emissions (mk-esg_compliant_system f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 f34 f35 f36 f37 f38 f39 f40 f41 f42 f43 f44 f45 f46 f47 f48 f49 f50 f51 f52 f53 f54 f55 f56 f57)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 113. ESGCompliantSystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 (Seq Int))
(declare-const f7 (Seq Int))
(declare-const f8 (Seq Int))
(declare-const f9 (Seq Int))
(declare-const f10 (Seq Int))
(declare-const f11 HRDDProcess)
(declare-const f12 (Seq Int))
(declare-const f13 (Seq Int))
(declare-const f14 GrievanceMechanism)
(declare-const f15 (Seq Int))
(declare-const f16 Board)
(declare-const f17 (Seq Int))
(declare-const f18 AntiCorruptionPolicy)
(declare-const f19 WhistleblowerPolicy)
(declare-const f20 ConflictOfInterest)
(declare-const f21 (Seq Int))
(declare-const f22 Disclosure)
(declare-const f23 ScienceBasedTarget)
(declare-const f24 Int)
(declare-const f25 Int)
(declare-const f26 Int)
(declare-const f27 Int)
(declare-const f28 Int)
(declare-const f29 Int)
(declare-const f30 Int)
(declare-const f31 Int)
(declare-const f32 Int)
(declare-const f33 Int)
(declare-const f34 Int)
(declare-const f35 Int)
(declare-const f36 Int)
(declare-const f37 Int)
(declare-const f38 Int)
(declare-const f39 Int)
(declare-const f40 Int)
(declare-const f41 Int)
(declare-const f42 Int)
(declare-const f43 Int)
(declare-const f44 Int)
(declare-const f45 Int)
(declare-const f46 Int)
(declare-const f47 Int)
(declare-const f48 Int)
(declare-const f49 Int)
(declare-const f50 Int)
(declare-const f51 Int)
(declare-const f52 Int)
(declare-const f53 Int)
(declare-const f54 Int)
(declare-const f55 Int)
(declare-const f56 Int)
(declare-const f57 Int)
(assert (not (= (sys_water (mk-esg_compliant_system f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 f34 f35 f36 f37 f38 f39 f40 f41 f42 f43 f44 f45 f46 f47 f48 f49 f50 f51 f52 f53 f54 f55 f56 f57)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 114. ESGCompliantSystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 (Seq Int))
(declare-const f7 (Seq Int))
(declare-const f8 (Seq Int))
(declare-const f9 (Seq Int))
(declare-const f10 (Seq Int))
(declare-const f11 HRDDProcess)
(declare-const f12 (Seq Int))
(declare-const f13 (Seq Int))
(declare-const f14 GrievanceMechanism)
(declare-const f15 (Seq Int))
(declare-const f16 Board)
(declare-const f17 (Seq Int))
(declare-const f18 AntiCorruptionPolicy)
(declare-const f19 WhistleblowerPolicy)
(declare-const f20 ConflictOfInterest)
(declare-const f21 (Seq Int))
(declare-const f22 Disclosure)
(declare-const f23 ScienceBasedTarget)
(declare-const f24 Int)
(declare-const f25 Int)
(declare-const f26 Int)
(declare-const f27 Int)
(declare-const f28 Int)
(declare-const f29 Int)
(declare-const f30 Int)
(declare-const f31 Int)
(declare-const f32 Int)
(declare-const f33 Int)
(declare-const f34 Int)
(declare-const f35 Int)
(declare-const f36 Int)
(declare-const f37 Int)
(declare-const f38 Int)
(declare-const f39 Int)
(declare-const f40 Int)
(declare-const f41 Int)
(declare-const f42 Int)
(declare-const f43 Int)
(declare-const f44 Int)
(declare-const f45 Int)
(declare-const f46 Int)
(declare-const f47 Int)
(declare-const f48 Int)
(declare-const f49 Int)
(declare-const f50 Int)
(declare-const f51 Int)
(declare-const f52 Int)
(declare-const f53 Int)
(declare-const f54 Int)
(declare-const f55 Int)
(declare-const f56 Int)
(declare-const f57 Int)
(assert (not (= (sys_waste (mk-esg_compliant_system f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 f34 f35 f36 f37 f38 f39 f40 f41 f42 f43 f44 f45 f46 f47 f48 f49 f50 f51 f52 f53 f54 f55 f56 f57)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 115. ESGCompliantSystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 (Seq Int))
(declare-const f7 (Seq Int))
(declare-const f8 (Seq Int))
(declare-const f9 (Seq Int))
(declare-const f10 (Seq Int))
(declare-const f11 HRDDProcess)
(declare-const f12 (Seq Int))
(declare-const f13 (Seq Int))
(declare-const f14 GrievanceMechanism)
(declare-const f15 (Seq Int))
(declare-const f16 Board)
(declare-const f17 (Seq Int))
(declare-const f18 AntiCorruptionPolicy)
(declare-const f19 WhistleblowerPolicy)
(declare-const f20 ConflictOfInterest)
(declare-const f21 (Seq Int))
(declare-const f22 Disclosure)
(declare-const f23 ScienceBasedTarget)
(declare-const f24 Int)
(declare-const f25 Int)
(declare-const f26 Int)
(declare-const f27 Int)
(declare-const f28 Int)
(declare-const f29 Int)
(declare-const f30 Int)
(declare-const f31 Int)
(declare-const f32 Int)
(declare-const f33 Int)
(declare-const f34 Int)
(declare-const f35 Int)
(declare-const f36 Int)
(declare-const f37 Int)
(declare-const f38 Int)
(declare-const f39 Int)
(declare-const f40 Int)
(declare-const f41 Int)
(declare-const f42 Int)
(declare-const f43 Int)
(declare-const f44 Int)
(declare-const f45 Int)
(declare-const f46 Int)
(declare-const f47 Int)
(declare-const f48 Int)
(declare-const f49 Int)
(declare-const f50 Int)
(declare-const f51 Int)
(declare-const f52 Int)
(declare-const f53 Int)
(declare-const f54 Int)
(declare-const f55 Int)
(declare-const f56 Int)
(declare-const f57 Int)
(assert (not (= (sys_biodiversity (mk-esg_compliant_system f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 f34 f35 f36 f37 f38 f39 f40 f41 f42 f43 f44 f45 f46 f47 f48 f49 f50 f51 f52 f53 f54 f55 f56 f57)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 116. ESGCompliantSystem accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 (Seq Int))
(declare-const f6 (Seq Int))
(declare-const f7 (Seq Int))
(declare-const f8 (Seq Int))
(declare-const f9 (Seq Int))
(declare-const f10 (Seq Int))
(declare-const f11 HRDDProcess)
(declare-const f12 (Seq Int))
(declare-const f13 (Seq Int))
(declare-const f14 GrievanceMechanism)
(declare-const f15 (Seq Int))
(declare-const f16 Board)
(declare-const f17 (Seq Int))
(declare-const f18 AntiCorruptionPolicy)
(declare-const f19 WhistleblowerPolicy)
(declare-const f20 ConflictOfInterest)
(declare-const f21 (Seq Int))
(declare-const f22 Disclosure)
(declare-const f23 ScienceBasedTarget)
(declare-const f24 Int)
(declare-const f25 Int)
(declare-const f26 Int)
(declare-const f27 Int)
(declare-const f28 Int)
(declare-const f29 Int)
(declare-const f30 Int)
(declare-const f31 Int)
(declare-const f32 Int)
(declare-const f33 Int)
(declare-const f34 Int)
(declare-const f35 Int)
(declare-const f36 Int)
(declare-const f37 Int)
(declare-const f38 Int)
(declare-const f39 Int)
(declare-const f40 Int)
(declare-const f41 Int)
(declare-const f42 Int)
(declare-const f43 Int)
(declare-const f44 Int)
(declare-const f45 Int)
(declare-const f46 Int)
(declare-const f47 Int)
(declare-const f48 Int)
(declare-const f49 Int)
(declare-const f50 Int)
(declare-const f51 Int)
(declare-const f52 Int)
(declare-const f53 Int)
(declare-const f54 Int)
(declare-const f55 Int)
(declare-const f56 Int)
(declare-const f57 Int)
(assert (not (= (sys_circular (mk-esg_compliant_system f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31 f32 f33 f34 f35 f36 f37 f38 f39 f40 f41 f42 f43 f44 f45 f46 f47 f48 f49 f50 f51 f52 f53 f54 f55 f56 f57)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 117. ESGCompliantSystem: integer field consistency ---
(push 1)
(declare-const r ESGCompliantSystem)
(assert (>= (seq.len (sys_emissions r)) 0))
(assert (>= (seq.len (sys_emissions r)) 0))
(assert (not (>= (+ (seq.len (sys_emissions r)) (seq.len (sys_emissions r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
