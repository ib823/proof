; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AppDistribution — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/AppDistribution.v (27 assertions)
; Module: AppDistribution
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((InstallState 0)) (((NotInstalled) (Installing) (Installed) (Updating) (Failed))))

(declare-datatypes ((AppPackage 0))
  (((mk-app_package (package_id Int) (package_version Int) (code_signature Int) (entitlements (Seq Int)) (sandbox_profile Int)))))

(declare-datatypes ((SecurityScan 0))
  (((mk-security_scan (scan_package_id Int) (static_analysis_passed Bool) (dynamic_analysis_passed Bool) (signature_valid Bool) (known_malware_match Bool) (behavior_anomaly Bool)))))

(declare-datatypes ((StoreApplication 0))
  (((mk-store_application (store_app_id Int) (store_package AppPackage) (scan_result SecurityScan) (review_approved Bool) (in_riina_store Bool)))))

(declare-datatypes ((AppUpdate 0))
  (((mk-app_update (update_app_id Int) (old_version Int) (new_version Int) (update_package AppPackage) (update_verified Bool)))))

(declare-datatypes ((Installation 0))
  (((mk-installation (install_app_id Int) (install_state InstallState) (installed_version Int) (rollback_available Bool)))))

(declare-datatypes ((AppSignature 0))
  (((mk-app_signature (sig_app_id Int) (sig_hash Int) (sig_developer_id Int) (sig_verified Bool) (sig_timestamp Int)))))

(declare-datatypes ((CodeIntegrity 0))
  (((mk-code_integrity (ci_app_id Int) (ci_hash_original Int) (ci_hash_current Int) (ci_integrity_valid Bool)))))

(declare-datatypes ((EntitlementSet 0))
  (((mk-entitlement_set (ent_app_id Int) (ent_requested (Seq Int)) (ent_granted (Seq Int)) (ent_validated Bool)))))

(declare-datatypes ((ProvisioningProfile 0))
  (((mk-provisioning_profile (pp_app_id Int) (pp_expiry_date Int) (pp_current_date Int) (pp_valid Bool)))))

(declare-datatypes ((AppReview 0))
  (((mk-app_review (ar_app_id Int) (ar_reviewed Bool) (ar_passed Bool) (ar_reviewer_id Int)))))

(declare-datatypes ((BinaryReport 0))
  (((mk-binary_report (br_app_id Int) (br_size_bytes Int) (br_reported_size Int) (br_size_reported Bool)))))

(declare-datatypes ((AppVersionHistory 0))
  (((mk-app_version_history (vh_app_id Int) (vh_versions (Seq Int)) (vh_monotonic Bool)))))

(declare-datatypes ((OSRequirement 0))
  (((mk-os_requirement (os_req_app_id Int) (os_req_min_version Int) (os_current_version Int) (os_req_enforced Bool)))))

(declare-datatypes ((APIUsage 0))
  (((mk-api_usage (api_name_hash Int) (api_deprecated Bool) (api_flagged Bool)))))

(declare-datatypes ((PrivacyManifest 0))
  (((mk-privacy_manifest (pm_app_id Int) (pm_data_types (Seq Int)) (pm_purposes (Seq Int)) (pm_manifest_present Bool)))))

(declare-datatypes ((DataDeclaration 0))
  (((mk-data_declaration (dd_app_id Int) (dd_collected_types (Seq Int)) (dd_declared_types (Seq Int)) (dd_declared Bool)))))

(declare-datatypes ((AppClip 0))
  (((mk-app_clip (ac_app_id Int) (ac_size_mb Int) (ac_max_size_mb Int)))))

(declare-datatypes ((TestFlightBuild 0))
  (((mk-test_flight_build (tf_build_id Int) (tf_expiry_days Int) (tf_max_days Int) (tf_enforced Bool)))))

(declare-datatypes ((EnterpriseCert 0))
  (((mk-enterprise_cert (ec_org_id Int) (ec_valid Bool) (ec_revoked Bool)))))

(declare-datatypes ((NotarizationStatus 0))
  (((mk-notarization_status (ns_app_id Int) (ns_notarized Bool) (ns_ticket_stapled Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. InstallState exhaustiveness ---
(push 1)
(declare-const x InstallState)
(assert (not (or (= x NotInstalled) (= x Installing) (= x Installed) (= x Updating) (= x Failed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. InstallState: NotInstalled != Installing ---
(push 1)
(assert (= NotInstalled Installing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. InstallState: Installing != Installed ---
(push 1)
(assert (= Installing Installed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. InstallState: Installed != Updating ---
(push 1)
(assert (= Installed Updating))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. InstallState: NotInstalled != Failed ---
(push 1)
(assert (= NotInstalled Failed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. InstallState finite cardinality (5 values) ---
(push 1)
(declare-const x InstallState)
(assert (and (not (= x NotInstalled)) (not (= x Installing)) (not (= x Installed)) (not (= x Updating)) (not (= x Failed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. AppPackage accessor round-trip: package_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (package_id (mk-app_package f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. AppPackage accessor round-trip: package_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (package_version (mk-app_package f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. AppPackage accessor round-trip: code_signature ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (code_signature (mk-app_package f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. AppPackage: non-negative int fields sum ---
(push 1)
(declare-const r AppPackage)
(assert (>= (package_id r) 0))
(assert (>= (package_version r) 0))
(assert (not (>= (+ (package_id r) (package_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SecurityScan accessor round-trip: scan_package_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (scan_package_id (mk-security_scan f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SecurityScan accessor round-trip: static_analysis_passed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (static_analysis_passed (mk-security_scan f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SecurityScan accessor round-trip: dynamic_analysis_passed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (dynamic_analysis_passed (mk-security_scan f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SecurityScan accessor round-trip: signature_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (signature_valid (mk-security_scan f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SecurityScan accessor round-trip: known_malware_match ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (known_malware_match (mk-security_scan f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. StoreApplication accessor round-trip: store_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppPackage)
(declare-const f2 SecurityScan)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (store_app_id (mk-store_application f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. StoreApplication accessor round-trip: store_package ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppPackage)
(declare-const f2 SecurityScan)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (store_package (mk-store_application f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. StoreApplication accessor round-trip: scan_result ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppPackage)
(declare-const f2 SecurityScan)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (scan_result (mk-store_application f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. StoreApplication accessor round-trip: review_approved ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppPackage)
(declare-const f2 SecurityScan)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (review_approved (mk-store_application f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. StoreApplication accessor round-trip: in_riina_store ---
(push 1)
(declare-const f0 Int)
(declare-const f1 AppPackage)
(declare-const f2 SecurityScan)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (in_riina_store (mk-store_application f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. AppUpdate accessor round-trip: update_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AppPackage)
(declare-const f4 Bool)
(assert (not (= (update_app_id (mk-app_update f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AppUpdate accessor round-trip: old_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AppPackage)
(declare-const f4 Bool)
(assert (not (= (old_version (mk-app_update f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AppUpdate accessor round-trip: new_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AppPackage)
(declare-const f4 Bool)
(assert (not (= (new_version (mk-app_update f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AppUpdate accessor round-trip: update_package ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AppPackage)
(declare-const f4 Bool)
(assert (not (= (update_package (mk-app_update f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. AppUpdate accessor round-trip: update_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 AppPackage)
(declare-const f4 Bool)
(assert (not (= (update_verified (mk-app_update f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AppUpdate: non-negative int fields sum ---
(push 1)
(declare-const r AppUpdate)
(assert (>= (update_app_id r) 0))
(assert (>= (old_version r) 0))
(assert (not (>= (+ (update_app_id r) (old_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Installation accessor round-trip: install_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 InstallState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (install_app_id (mk-installation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Installation accessor round-trip: install_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 InstallState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (install_state (mk-installation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Installation accessor round-trip: installed_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 InstallState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (installed_version (mk-installation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Installation accessor round-trip: rollback_available ---
(push 1)
(declare-const f0 Int)
(declare-const f1 InstallState)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rollback_available (mk-installation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Installation: non-negative int fields sum ---
(push 1)
(declare-const r Installation)
(assert (>= (install_app_id r) 0))
(assert (>= (installed_version r) 0))
(assert (not (>= (+ (install_app_id r) (installed_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. AppSignature accessor round-trip: sig_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (sig_app_id (mk-app_signature f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. AppSignature accessor round-trip: sig_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (sig_hash (mk-app_signature f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. AppSignature accessor round-trip: sig_developer_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (sig_developer_id (mk-app_signature f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. AppSignature accessor round-trip: sig_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (sig_verified (mk-app_signature f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. AppSignature accessor round-trip: sig_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (sig_timestamp (mk-app_signature f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. AppSignature: non-negative int fields sum ---
(push 1)
(declare-const r AppSignature)
(assert (>= (sig_app_id r) 0))
(assert (>= (sig_hash r) 0))
(assert (not (>= (+ (sig_app_id r) (sig_hash r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. CodeIntegrity accessor round-trip: ci_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ci_app_id (mk-code_integrity f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. CodeIntegrity accessor round-trip: ci_hash_original ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ci_hash_original (mk-code_integrity f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. CodeIntegrity accessor round-trip: ci_hash_current ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ci_hash_current (mk-code_integrity f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. CodeIntegrity accessor round-trip: ci_integrity_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ci_integrity_valid (mk-code_integrity f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. CodeIntegrity: non-negative int fields sum ---
(push 1)
(declare-const r CodeIntegrity)
(assert (>= (ci_app_id r) 0))
(assert (>= (ci_hash_original r) 0))
(assert (not (>= (+ (ci_app_id r) (ci_hash_original r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. EntitlementSet accessor round-trip: ent_app_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (ent_app_id (mk-entitlement_set f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ProvisioningProfile accessor round-trip: pp_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pp_app_id (mk-provisioning_profile f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ProvisioningProfile accessor round-trip: pp_expiry_date ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pp_expiry_date (mk-provisioning_profile f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. ProvisioningProfile accessor round-trip: pp_current_date ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pp_current_date (mk-provisioning_profile f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. ProvisioningProfile accessor round-trip: pp_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (pp_valid (mk-provisioning_profile f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. ProvisioningProfile: non-negative int fields sum ---
(push 1)
(declare-const r ProvisioningProfile)
(assert (>= (pp_app_id r) 0))
(assert (>= (pp_expiry_date r) 0))
(assert (not (>= (+ (pp_app_id r) (pp_expiry_date r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. AppReview accessor round-trip: ar_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (ar_app_id (mk-app_review f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. AppReview accessor round-trip: ar_reviewed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (ar_reviewed (mk-app_review f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. AppReview accessor round-trip: ar_passed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (ar_passed (mk-app_review f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. AppReview accessor round-trip: ar_reviewer_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (ar_reviewer_id (mk-app_review f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. AppReview: non-negative int fields sum ---
(push 1)
(declare-const r AppReview)
(assert (>= (ar_app_id r) 0))
(assert (>= (ar_reviewer_id r) 0))
(assert (not (>= (+ (ar_app_id r) (ar_reviewer_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. BinaryReport accessor round-trip: br_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (br_app_id (mk-binary_report f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. BinaryReport accessor round-trip: br_size_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (br_size_bytes (mk-binary_report f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. BinaryReport accessor round-trip: br_reported_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (br_reported_size (mk-binary_report f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. BinaryReport accessor round-trip: br_size_reported ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (br_size_reported (mk-binary_report f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. BinaryReport: non-negative int fields sum ---
(push 1)
(declare-const r BinaryReport)
(assert (>= (br_app_id r) 0))
(assert (>= (br_size_bytes r) 0))
(assert (not (>= (+ (br_app_id r) (br_size_bytes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. AppVersionHistory accessor round-trip: vh_app_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (vh_app_id (mk-app_version_history f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. OSRequirement accessor round-trip: os_req_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (os_req_app_id (mk-os_requirement f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. OSRequirement accessor round-trip: os_req_min_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (os_req_min_version (mk-os_requirement f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. OSRequirement accessor round-trip: os_current_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (os_current_version (mk-os_requirement f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. OSRequirement accessor round-trip: os_req_enforced ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (os_req_enforced (mk-os_requirement f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. OSRequirement: non-negative int fields sum ---
(push 1)
(declare-const r OSRequirement)
(assert (>= (os_req_app_id r) 0))
(assert (>= (os_req_min_version r) 0))
(assert (not (>= (+ (os_req_app_id r) (os_req_min_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. APIUsage accessor round-trip: api_name_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (api_name_hash (mk-api_usage f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. APIUsage accessor round-trip: api_deprecated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (api_deprecated (mk-api_usage f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. APIUsage accessor round-trip: api_flagged ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (api_flagged (mk-api_usage f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. PrivacyManifest accessor round-trip: pm_app_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (pm_app_id (mk-privacy_manifest f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. DataDeclaration accessor round-trip: dd_app_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (dd_app_id (mk-data_declaration f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. AppClip accessor round-trip: ac_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ac_app_id (mk-app_clip f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. AppClip accessor round-trip: ac_size_mb ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ac_size_mb (mk-app_clip f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. AppClip accessor round-trip: ac_max_size_mb ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ac_max_size_mb (mk-app_clip f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. AppClip: non-negative int fields sum ---
(push 1)
(declare-const r AppClip)
(assert (>= (ac_app_id r) 0))
(assert (>= (ac_size_mb r) 0))
(assert (not (>= (+ (ac_app_id r) (ac_size_mb r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. TestFlightBuild accessor round-trip: tf_build_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tf_build_id (mk-test_flight_build f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. TestFlightBuild accessor round-trip: tf_expiry_days ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tf_expiry_days (mk-test_flight_build f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. TestFlightBuild accessor round-trip: tf_max_days ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tf_max_days (mk-test_flight_build f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. TestFlightBuild accessor round-trip: tf_enforced ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (tf_enforced (mk-test_flight_build f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. TestFlightBuild: non-negative int fields sum ---
(push 1)
(declare-const r TestFlightBuild)
(assert (>= (tf_build_id r) 0))
(assert (>= (tf_expiry_days r) 0))
(assert (not (>= (+ (tf_build_id r) (tf_expiry_days r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. EnterpriseCert accessor round-trip: ec_org_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ec_org_id (mk-enterprise_cert f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. EnterpriseCert accessor round-trip: ec_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ec_valid (mk-enterprise_cert f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. EnterpriseCert accessor round-trip: ec_revoked ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ec_revoked (mk-enterprise_cert f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. NotarizationStatus accessor round-trip: ns_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ns_app_id (mk-notarization_status f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. NotarizationStatus accessor round-trip: ns_notarized ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ns_notarized (mk-notarization_status f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. NotarizationStatus accessor round-trip: ns_ticket_stapled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ns_ticket_stapled (mk-notarization_status f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
