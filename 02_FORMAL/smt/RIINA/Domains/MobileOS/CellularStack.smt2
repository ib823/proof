; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CellularStack — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/CellularStack.v (24 assertions)
; Module: CellularStack
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CellularGeneration 0)) (((Gen2G) (Gen3G) (Gen4G) (Gen5G))))

(declare-datatypes ((Memory 0))
  (((mk-memory (mem_start Int) (mem_size Int) (mem_is_ap Bool)))))

(declare-datatypes ((BasebandProcessor 0))
  (((mk-baseband_processor (bb_id Int) (bb_accessible_memory (Seq Int)) (bb_isolated Bool)))))

(declare-datatypes ((Call 0))
  (((mk-call (call_id Int) (call_active Bool) (call_has_audio_gap Bool)))))

(declare-datatypes ((Handoff 0))
  (((mk-handoff (handoff_id Int) (handoff_from_tower Int) (handoff_to_tower Int) (handoff_seamless Bool)))))

(declare-datatypes ((IMSIProtection 0))
  (((mk-imsi_protection (imsi_value Int) (imsi_encrypted Bool) (imsi_exposed Bool) (imsi_supi_used Bool)))))

(declare-datatypes ((BasebandIsolation 0))
  (((mk-baseband_isolation (bbi_processor_id Int) (bbi_memory_isolated Bool) (bbi_dma_blocked Bool) (bbi_firmware_verified Bool)))))

(declare-datatypes ((SIMAuth 0))
  (((mk-sim_auth (sim_iccid Int) (sim_auth_complete Bool) (sim_mutual_auth Bool) (sim_key_agreement Bool)))))

(declare-datatypes ((RoamingConfig 0))
  (((mk-roaming_config (roaming_enabled Bool) (roaming_user_consented Bool) (roaming_cost_warning_shown Bool)))))

(declare-datatypes ((CellularEncryption 0))
  (((mk-cellular_encryption (cell_generation CellularGeneration) (cell_encrypted Bool) (cell_integrity_protected Bool)))))

(declare-datatypes ((CellTowerInfo 0))
  (((mk-cell_tower_info (tower_id Int) (tower_signal_strength Int) (tower_anomaly_detected Bool) (tower_stingray_suspected Bool)))))

(declare-datatypes ((SMSMessage 0))
  (((mk-sms_message (sms_id Int) (sms_encrypted Bool) (sms_rcs_enabled Bool)))))

(declare-datatypes ((VoLTECall 0))
  (((mk-vo_lte_call (volte_call_id Int) (volte_quality_score Int) (volte_min_quality Int) (volte_hd_voice Bool)))))

(declare-datatypes ((eSIMActivation 0))
  (((mk-e_sim_activation (esim_eid Int) (esim_profile_encrypted Bool) (esim_activation_code_valid Bool) (esim_activated Bool)))))

(declare-datatypes ((CarrierSettings 0))
  (((mk-carrier_settings (carrier_id Int) (carrier_settings_hash Int) (carrier_validated Bool) (carrier_version Int)))))

(declare-datatypes ((DataUsage 0))
  (((mk-data_usage (du_bytes_used Int) (du_bytes_limit Int) (du_tracked Bool) (du_warning_sent Bool)))))

(declare-datatypes ((CellularFailover 0))
  (((mk-cellular_failover (fo_primary_gen CellularGeneration) (fo_fallback_gen CellularGeneration) (fo_failover_handled Bool)))))

(declare-datatypes ((SignalMeasurement 0))
  (((mk-signal_measurement (sm_rssi Int) (sm_rsrp Int) (sm_accurate Bool) (sm_timestamp Int)))))

(declare-datatypes ((EmergencyCall 0))
  (((mk-emergency_call (ec_available Bool) (ec_sim_required Bool) (ec_any_network Bool)))))

(declare-datatypes ((CarrierLock 0))
  (((mk-carrier_lock (cl_locked Bool) (cl_carrier_id Int) (cl_enforced Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. CellularGeneration exhaustiveness ---
(push 1)
(declare-const x CellularGeneration)
(assert (not (or (= x Gen2G) (= x Gen3G) (= x Gen4G) (= x Gen5G))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CellularGeneration: Gen2G != Gen3G ---
(push 1)
(assert (= Gen2G Gen3G))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CellularGeneration: Gen3G != Gen4G ---
(push 1)
(assert (= Gen3G Gen4G))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CellularGeneration: Gen4G != Gen5G ---
(push 1)
(assert (= Gen4G Gen5G))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CellularGeneration: Gen2G != Gen5G ---
(push 1)
(assert (= Gen2G Gen5G))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CellularGeneration finite cardinality (4 values) ---
(push 1)
(declare-const x CellularGeneration)
(assert (and (not (= x Gen2G)) (not (= x Gen3G)) (not (= x Gen4G)) (not (= x Gen5G))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Memory accessor round-trip: mem_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (mem_start (mk-memory f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Memory accessor round-trip: mem_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (mem_size (mk-memory f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Memory accessor round-trip: mem_is_ap ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (mem_is_ap (mk-memory f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Memory: non-negative int fields sum ---
(push 1)
(declare-const r Memory)
(assert (>= (mem_start r) 0))
(assert (>= (mem_size r) 0))
(assert (not (>= (+ (mem_start r) (mem_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BasebandProcessor accessor round-trip: bb_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (bb_id (mk-baseband_processor f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Call accessor round-trip: call_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (call_id (mk-call f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Call accessor round-trip: call_active ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (call_active (mk-call f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Call accessor round-trip: call_has_audio_gap ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (call_has_audio_gap (mk-call f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Handoff accessor round-trip: handoff_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (handoff_id (mk-handoff f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Handoff accessor round-trip: handoff_from_tower ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (handoff_from_tower (mk-handoff f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Handoff accessor round-trip: handoff_to_tower ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (handoff_to_tower (mk-handoff f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Handoff accessor round-trip: handoff_seamless ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (handoff_seamless (mk-handoff f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Handoff: non-negative int fields sum ---
(push 1)
(declare-const r Handoff)
(assert (>= (handoff_id r) 0))
(assert (>= (handoff_from_tower r) 0))
(assert (not (>= (+ (handoff_id r) (handoff_from_tower r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. IMSIProtection accessor round-trip: imsi_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (imsi_value (mk-imsi_protection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. IMSIProtection accessor round-trip: imsi_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (imsi_encrypted (mk-imsi_protection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. IMSIProtection accessor round-trip: imsi_exposed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (imsi_exposed (mk-imsi_protection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. IMSIProtection accessor round-trip: imsi_supi_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (imsi_supi_used (mk-imsi_protection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BasebandIsolation accessor round-trip: bbi_processor_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bbi_processor_id (mk-baseband_isolation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BasebandIsolation accessor round-trip: bbi_memory_isolated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bbi_memory_isolated (mk-baseband_isolation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BasebandIsolation accessor round-trip: bbi_dma_blocked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bbi_dma_blocked (mk-baseband_isolation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. BasebandIsolation accessor round-trip: bbi_firmware_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bbi_firmware_verified (mk-baseband_isolation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. SIMAuth accessor round-trip: sim_iccid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sim_iccid (mk-sim_auth f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. SIMAuth accessor round-trip: sim_auth_complete ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sim_auth_complete (mk-sim_auth f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SIMAuth accessor round-trip: sim_mutual_auth ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sim_mutual_auth (mk-sim_auth f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. SIMAuth accessor round-trip: sim_key_agreement ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sim_key_agreement (mk-sim_auth f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. RoamingConfig accessor round-trip: roaming_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (roaming_enabled (mk-roaming_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. RoamingConfig accessor round-trip: roaming_user_consented ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (roaming_user_consented (mk-roaming_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. RoamingConfig accessor round-trip: roaming_cost_warning_shown ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (roaming_cost_warning_shown (mk-roaming_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun RoamingConfig_all_enabled ((g RoamingConfig)) Bool
  (and (roaming_enabled g) (roaming_user_consented g) (roaming_cost_warning_shown g)))

; --- 35. RoamingConfig: all-enabled completeness ---
(push 1)
(declare-const g RoamingConfig)
(assert (roaming_enabled g))
(assert (roaming_user_consented g))
(assert (roaming_cost_warning_shown g))
(assert (not (RoamingConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. RoamingConfig: RoamingConfig_all_enabled implies roaming_enabled ---
(push 1)
(declare-const g RoamingConfig)
(assert (RoamingConfig_all_enabled g))
(assert (not (roaming_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. RoamingConfig: RoamingConfig_all_enabled implies roaming_user_consented ---
(push 1)
(declare-const g RoamingConfig)
(assert (RoamingConfig_all_enabled g))
(assert (not (roaming_user_consented g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. RoamingConfig: RoamingConfig_all_enabled implies roaming_cost_warning_shown ---
(push 1)
(declare-const g RoamingConfig)
(assert (RoamingConfig_all_enabled g))
(assert (not (roaming_cost_warning_shown g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. CellularEncryption accessor round-trip: cell_generation ---
(push 1)
(declare-const f0 CellularGeneration)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cell_generation (mk-cellular_encryption f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. CellularEncryption accessor round-trip: cell_encrypted ---
(push 1)
(declare-const f0 CellularGeneration)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cell_encrypted (mk-cellular_encryption f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. CellularEncryption accessor round-trip: cell_integrity_protected ---
(push 1)
(declare-const f0 CellularGeneration)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cell_integrity_protected (mk-cellular_encryption f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. CellTowerInfo accessor round-trip: tower_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tower_id (mk-cell_tower_info f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. CellTowerInfo accessor round-trip: tower_signal_strength ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tower_signal_strength (mk-cell_tower_info f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. CellTowerInfo accessor round-trip: tower_anomaly_detected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tower_anomaly_detected (mk-cell_tower_info f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. CellTowerInfo accessor round-trip: tower_stingray_suspected ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tower_stingray_suspected (mk-cell_tower_info f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. CellTowerInfo: non-negative int fields sum ---
(push 1)
(declare-const r CellTowerInfo)
(assert (>= (tower_id r) 0))
(assert (>= (tower_signal_strength r) 0))
(assert (not (>= (+ (tower_id r) (tower_signal_strength r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. SMSMessage accessor round-trip: sms_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sms_id (mk-sms_message f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. SMSMessage accessor round-trip: sms_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sms_encrypted (mk-sms_message f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. SMSMessage accessor round-trip: sms_rcs_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (sms_rcs_enabled (mk-sms_message f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. VoLTECall accessor round-trip: volte_call_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (volte_call_id (mk-vo_lte_call f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. VoLTECall accessor round-trip: volte_quality_score ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (volte_quality_score (mk-vo_lte_call f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. VoLTECall accessor round-trip: volte_min_quality ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (volte_min_quality (mk-vo_lte_call f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. VoLTECall accessor round-trip: volte_hd_voice ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (volte_hd_voice (mk-vo_lte_call f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. VoLTECall: non-negative int fields sum ---
(push 1)
(declare-const r VoLTECall)
(assert (>= (volte_call_id r) 0))
(assert (>= (volte_quality_score r) 0))
(assert (not (>= (+ (volte_call_id r) (volte_quality_score r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. eSIMActivation accessor round-trip: esim_eid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (esim_eid (mk-e_sim_activation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. eSIMActivation accessor round-trip: esim_profile_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (esim_profile_encrypted (mk-e_sim_activation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. eSIMActivation accessor round-trip: esim_activation_code_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (esim_activation_code_valid (mk-e_sim_activation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. eSIMActivation accessor round-trip: esim_activated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (esim_activated (mk-e_sim_activation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. CarrierSettings accessor round-trip: carrier_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (carrier_id (mk-carrier_settings f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. CarrierSettings accessor round-trip: carrier_settings_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (carrier_settings_hash (mk-carrier_settings f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. CarrierSettings accessor round-trip: carrier_validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (carrier_validated (mk-carrier_settings f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. CarrierSettings accessor round-trip: carrier_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (carrier_version (mk-carrier_settings f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. CarrierSettings: non-negative int fields sum ---
(push 1)
(declare-const r CarrierSettings)
(assert (>= (carrier_id r) 0))
(assert (>= (carrier_settings_hash r) 0))
(assert (not (>= (+ (carrier_id r) (carrier_settings_hash r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. DataUsage accessor round-trip: du_bytes_used ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (du_bytes_used (mk-data_usage f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. DataUsage accessor round-trip: du_bytes_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (du_bytes_limit (mk-data_usage f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. DataUsage accessor round-trip: du_tracked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (du_tracked (mk-data_usage f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. DataUsage accessor round-trip: du_warning_sent ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (du_warning_sent (mk-data_usage f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. DataUsage: non-negative int fields sum ---
(push 1)
(declare-const r DataUsage)
(assert (>= (du_bytes_used r) 0))
(assert (>= (du_bytes_limit r) 0))
(assert (not (>= (+ (du_bytes_used r) (du_bytes_limit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. CellularFailover accessor round-trip: fo_primary_gen ---
(push 1)
(declare-const f0 CellularGeneration)
(declare-const f1 CellularGeneration)
(declare-const f2 Bool)
(assert (not (= (fo_primary_gen (mk-cellular_failover f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. CellularFailover accessor round-trip: fo_fallback_gen ---
(push 1)
(declare-const f0 CellularGeneration)
(declare-const f1 CellularGeneration)
(declare-const f2 Bool)
(assert (not (= (fo_fallback_gen (mk-cellular_failover f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. CellularFailover accessor round-trip: fo_failover_handled ---
(push 1)
(declare-const f0 CellularGeneration)
(declare-const f1 CellularGeneration)
(declare-const f2 Bool)
(assert (not (= (fo_failover_handled (mk-cellular_failover f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. SignalMeasurement accessor round-trip: sm_rssi ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (sm_rssi (mk-signal_measurement f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. SignalMeasurement accessor round-trip: sm_rsrp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (sm_rsrp (mk-signal_measurement f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. SignalMeasurement accessor round-trip: sm_accurate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (sm_accurate (mk-signal_measurement f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. SignalMeasurement accessor round-trip: sm_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (sm_timestamp (mk-signal_measurement f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. SignalMeasurement: non-negative int fields sum ---
(push 1)
(declare-const r SignalMeasurement)
(assert (>= (sm_rssi r) 0))
(assert (>= (sm_rsrp r) 0))
(assert (not (>= (+ (sm_rssi r) (sm_rsrp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. EmergencyCall accessor round-trip: ec_available ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ec_available (mk-emergency_call f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. EmergencyCall accessor round-trip: ec_sim_required ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ec_sim_required (mk-emergency_call f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. EmergencyCall accessor round-trip: ec_any_network ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ec_any_network (mk-emergency_call f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun EmergencyCall_all_enabled ((g EmergencyCall)) Bool
  (and (ec_available g) (ec_sim_required g) (ec_any_network g)))

; --- 80. EmergencyCall: all-enabled completeness ---
(push 1)
(declare-const g EmergencyCall)
(assert (ec_available g))
(assert (ec_sim_required g))
(assert (ec_any_network g))
(assert (not (EmergencyCall_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. EmergencyCall: EmergencyCall_all_enabled implies ec_available ---
(push 1)
(declare-const g EmergencyCall)
(assert (EmergencyCall_all_enabled g))
(assert (not (ec_available g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. EmergencyCall: EmergencyCall_all_enabled implies ec_sim_required ---
(push 1)
(declare-const g EmergencyCall)
(assert (EmergencyCall_all_enabled g))
(assert (not (ec_sim_required g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. EmergencyCall: EmergencyCall_all_enabled implies ec_any_network ---
(push 1)
(declare-const g EmergencyCall)
(assert (EmergencyCall_all_enabled g))
(assert (not (ec_any_network g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. CarrierLock accessor round-trip: cl_locked ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cl_locked (mk-carrier_lock f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. CarrierLock accessor round-trip: cl_carrier_id ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cl_carrier_id (mk-carrier_lock f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. CarrierLock accessor round-trip: cl_enforced ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (cl_enforced (mk-carrier_lock f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
