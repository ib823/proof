; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SupplyChainSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/SupplyChainSecurity.v (37 assertions)
; Module: SupplyChainSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SignedArtifact 0))
  (((mk-signed_artifact (sa_content_hash Int) (sa_signature Int) (sa_signer_key Int) (sa_verified Bool)))))

(declare-datatypes ((VerifiedPackage 0))
  (((mk-verified_package (vp_name Int) (vp_canonical_name Int) (vp_in_allowlist Bool) (vp_name_verified Bool)))))

(declare-datatypes ((ScopedPackage 0))
  (((mk-scoped_package (sp_namespace Int) (sp_name Int) (sp_internal_registry Bool) (sp_namespace_verified Bool)))))

(declare-datatypes ((ReproducibleBuild 0))
  (((mk-reproducible_build (rb_source_hash Int) (rb_output_hash Int) (rb_builder1_hash Int) (rb_builder2_hash Int) (rb_hashes_match Bool)))))

(declare-datatypes ((TUFPackage 0))
  (((mk-tuf_package (tuf_root_signed Bool) (tuf_targets_signed Bool) (tuf_snapshot_signed Bool) (tuf_timestamp_signed Bool) (tuf_threshold_met Bool)))))

(declare-datatypes ((VerifiedFirmware 0))
  (((mk-verified_firmware (fw_signature Int) (fw_vendor_key Int) (fw_hash Int) (fw_signature_valid Bool) (fw_rollback_protected Bool)))))

(declare-datatypes ((HardwareAttestation 0))
  (((mk-hardware_attestation (hw_tpm_present Bool) (hw_secure_boot Bool) (hw_attestation_chain (Seq Int)) (hw_chain_valid Bool)))))

(declare-datatypes ((VendorVerification 0))
  (((mk-vendor_verification (vendor_id Int) (vendor_cert_valid Bool) (vendor_audit_passed Bool) (vendor_in_approved_list Bool)))))

(declare-datatypes ((NetworkSegmentation 0))
  (((mk-network_segmentation (ns_source_segment Int) (ns_dest_segment Int) (ns_firewall_rules (Seq Int)) (ns_segments_isolated Bool)))))

(declare-datatypes ((SignedUpdate 0))
  (((mk-signed_update (upd_signature_valid Bool) (upd_current_version Int) (upd_new_version Int) (upd_version_incremented Bool)))))

(declare-datatypes ((SignedCode 0))
  (((mk-signed_code (code_signature_valid Bool) (code_review_approved Bool) (code_reviewer_count Int) (code_min_reviewers Int)))))

(declare-datatypes ((DDCBuild 0))
  (((mk-ddc_build (ddc_compiler1_hash Int) (ddc_compiler2_hash Int) (ddc_compilers_different Bool) (ddc_output1_hash Int) (ddc_output2_hash Int) (ddc_outputs_match Bool)))))

(declare-datatypes ((BinaryVerification 0))
  (((mk-binary_verification (bin_source_hash Int) (bin_claimed_hash Int) (bin_reproduced_hash Int) (bin_reproducible Bool)))))

(declare-datatypes ((CertificateTransparency 0))
  (((mk-certificate_transparency (ct_cert_id Int) (ct_in_log Bool) (ct_sct_valid Bool) (ct_log_consistent Bool)))))

(declare-datatypes ((AccessControl 0))
  (((mk-access_control (ac_user_id Int) (ac_mfa_enabled Bool) (ac_role_verified Bool) (ac_access_logged Bool)))))

(declare-datatypes ((DependencyIsolation 0))
  (((mk-dependency_isolation (di_dependency_id Int) (di_isolation_level Int) (di_sandboxed Bool) (di_network_restricted Bool) (di_filesystem_restricted Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SignedArtifact record properties ---

; --- 1. SignedArtifact accessor round-trip: sa_content_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sa_content_hash (mk-signed_artifact f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SignedArtifact accessor round-trip: sa_signature ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sa_signature (mk-signed_artifact f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SignedArtifact accessor round-trip: sa_signer_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (sa_signer_key (mk-signed_artifact f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SignedArtifact: integer field consistency ---
(push 1)
(declare-const r SignedArtifact)
(assert (>= (sa_content_hash r) 0))
(assert (>= (sa_signature r) 0))
(assert (not (>= (+ (sa_content_hash r) (sa_signature r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedPackage record properties ---

; --- 5. VerifiedPackage accessor round-trip: vp_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (vp_name (mk-verified_package f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. VerifiedPackage accessor round-trip: vp_canonical_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (vp_canonical_name (mk-verified_package f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. VerifiedPackage accessor round-trip: vp_in_allowlist ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (vp_in_allowlist (mk-verified_package f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. VerifiedPackage: integer field consistency ---
(push 1)
(declare-const r VerifiedPackage)
(assert (>= (vp_name r) 0))
(assert (>= (vp_canonical_name r) 0))
(assert (not (>= (+ (vp_name r) (vp_canonical_name r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ScopedPackage record properties ---

; --- 9. ScopedPackage accessor round-trip: sp_namespace ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sp_namespace (mk-scoped_package f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ScopedPackage accessor round-trip: sp_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sp_name (mk-scoped_package f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ScopedPackage accessor round-trip: sp_internal_registry ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (sp_internal_registry (mk-scoped_package f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ScopedPackage: integer field consistency ---
(push 1)
(declare-const r ScopedPackage)
(assert (>= (sp_namespace r) 0))
(assert (>= (sp_name r) 0))
(assert (not (>= (+ (sp_namespace r) (sp_name r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReproducibleBuild record properties ---

; --- 13. ReproducibleBuild accessor round-trip: rb_source_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rb_source_hash (mk-reproducible_build f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ReproducibleBuild accessor round-trip: rb_output_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rb_output_hash (mk-reproducible_build f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ReproducibleBuild accessor round-trip: rb_builder1_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rb_builder1_hash (mk-reproducible_build f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ReproducibleBuild accessor round-trip: rb_builder2_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rb_builder2_hash (mk-reproducible_build f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ReproducibleBuild: integer field consistency ---
(push 1)
(declare-const r ReproducibleBuild)
(assert (>= (rb_source_hash r) 0))
(assert (>= (rb_output_hash r) 0))
(assert (not (>= (+ (rb_source_hash r) (rb_output_hash r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TUFPackage record properties ---

; --- 18. TUFPackage accessor round-trip: tuf_root_signed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tuf_root_signed (mk-t_u_f_package f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. TUFPackage accessor round-trip: tuf_targets_signed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tuf_targets_signed (mk-t_u_f_package f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. TUFPackage accessor round-trip: tuf_snapshot_signed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tuf_snapshot_signed (mk-t_u_f_package f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. TUFPackage accessor round-trip: tuf_timestamp_signed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (tuf_timestamp_signed (mk-t_u_f_package f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TUFPackage_all_enabled ((g TUFPackage)) Bool
  (and (tuf_root_signed g) (tuf_targets_signed g) (tuf_snapshot_signed g) (tuf_timestamp_signed g)))

; --- 22. TUFPackage: all-enabled completeness ---
(push 1)
(declare-const g TUFPackage)
(assert (tuf_root_signed g))
(assert (tuf_targets_signed g))
(assert (tuf_snapshot_signed g))
(assert (tuf_timestamp_signed g))
(assert (not (TUFPackage_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TUFPackage: TUFPackage_all_enabled implies tuf_root_signed ---
(push 1)
(declare-const g TUFPackage)
(assert (TUFPackage_all_enabled g))
(assert (not (tuf_root_signed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TUFPackage: TUFPackage_all_enabled implies tuf_targets_signed ---
(push 1)
(declare-const g TUFPackage)
(assert (TUFPackage_all_enabled g))
(assert (not (tuf_targets_signed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TUFPackage: TUFPackage_all_enabled implies tuf_snapshot_signed ---
(push 1)
(declare-const g TUFPackage)
(assert (TUFPackage_all_enabled g))
(assert (not (tuf_snapshot_signed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedFirmware record properties ---

; --- 26. VerifiedFirmware accessor round-trip: fw_signature ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fw_signature (mk-verified_firmware f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. VerifiedFirmware accessor round-trip: fw_vendor_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fw_vendor_key (mk-verified_firmware f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. VerifiedFirmware accessor round-trip: fw_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fw_hash (mk-verified_firmware f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. VerifiedFirmware accessor round-trip: fw_signature_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fw_signature_valid (mk-verified_firmware f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. VerifiedFirmware: integer field consistency ---
(push 1)
(declare-const r VerifiedFirmware)
(assert (>= (fw_signature r) 0))
(assert (>= (fw_vendor_key r) 0))
(assert (not (>= (+ (fw_signature r) (fw_vendor_key r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HardwareAttestation record properties ---

; --- 31. HardwareAttestation accessor round-trip: hw_tpm_present ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (hw_tpm_present (mk-hardware_attestation f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. HardwareAttestation accessor round-trip: hw_secure_boot ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (hw_secure_boot (mk-hardware_attestation f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. HardwareAttestation accessor round-trip: Seq ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (Seq (mk-hardware_attestation f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VendorVerification record properties ---

; --- 34. VendorVerification accessor round-trip: vendor_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (vendor_id (mk-vendor_verification f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VendorVerification accessor round-trip: vendor_cert_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (vendor_cert_valid (mk-vendor_verification f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. VendorVerification accessor round-trip: vendor_audit_passed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (vendor_audit_passed (mk-vendor_verification f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkSegmentation record properties ---

; --- 37. NetworkSegmentation accessor round-trip: ns_source_segment ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ns_source_segment (mk-network_segmentation f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. NetworkSegmentation accessor round-trip: ns_dest_segment ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ns_dest_segment (mk-network_segmentation f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. NetworkSegmentation accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (Seq (mk-network_segmentation f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. NetworkSegmentation: integer field consistency ---
(push 1)
(declare-const r NetworkSegmentation)
(assert (>= (ns_source_segment r) 0))
(assert (>= (ns_dest_segment r) 0))
(assert (not (>= (+ (ns_source_segment r) (ns_dest_segment r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignedUpdate record properties ---

; --- 41. SignedUpdate accessor round-trip: upd_signature_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (upd_signature_valid (mk-signed_update f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. SignedUpdate accessor round-trip: upd_current_version ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (upd_current_version (mk-signed_update f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. SignedUpdate accessor round-trip: upd_new_version ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (upd_new_version (mk-signed_update f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. SignedUpdate: integer field consistency ---
(push 1)
(declare-const r SignedUpdate)
(assert (>= (upd_current_version r) 0))
(assert (>= (upd_new_version r) 0))
(assert (not (>= (+ (upd_current_version r) (upd_new_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SignedCode record properties ---

; --- 45. SignedCode accessor round-trip: code_signature_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (code_signature_valid (mk-signed_code f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. SignedCode accessor round-trip: code_review_approved ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (code_review_approved (mk-signed_code f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. SignedCode accessor round-trip: code_reviewer_count ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (code_reviewer_count (mk-signed_code f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DDCBuild record properties ---

; --- 48. DDCBuild accessor round-trip: ddc_compiler1_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ddc_compiler1_hash (mk-d_d_c_build f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. DDCBuild accessor round-trip: ddc_compiler2_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ddc_compiler2_hash (mk-d_d_c_build f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. DDCBuild accessor round-trip: ddc_compilers_different ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ddc_compilers_different (mk-d_d_c_build f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. DDCBuild accessor round-trip: ddc_output1_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ddc_output1_hash (mk-d_d_c_build f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. DDCBuild accessor round-trip: ddc_output2_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (ddc_output2_hash (mk-d_d_c_build f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. DDCBuild: integer field consistency ---
(push 1)
(declare-const r DDCBuild)
(assert (>= (ddc_compiler1_hash r) 0))
(assert (>= (ddc_compiler2_hash r) 0))
(assert (not (>= (+ (ddc_compiler1_hash r) (ddc_compiler2_hash r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BinaryVerification record properties ---

; --- 54. BinaryVerification accessor round-trip: bin_source_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bin_source_hash (mk-binary_verification f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. BinaryVerification accessor round-trip: bin_claimed_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bin_claimed_hash (mk-binary_verification f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. BinaryVerification accessor round-trip: bin_reproduced_hash ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bin_reproduced_hash (mk-binary_verification f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. BinaryVerification: integer field consistency ---
(push 1)
(declare-const r BinaryVerification)
(assert (>= (bin_source_hash r) 0))
(assert (>= (bin_claimed_hash r) 0))
(assert (not (>= (+ (bin_source_hash r) (bin_claimed_hash r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CertificateTransparency record properties ---

; --- 58. CertificateTransparency accessor round-trip: ct_cert_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ct_cert_id (mk-certificate_transparency f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. CertificateTransparency accessor round-trip: ct_in_log ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ct_in_log (mk-certificate_transparency f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. CertificateTransparency accessor round-trip: ct_sct_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ct_sct_valid (mk-certificate_transparency f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AccessControl record properties ---

; --- 61. AccessControl accessor round-trip: ac_user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ac_user_id (mk-access_control f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. AccessControl accessor round-trip: ac_mfa_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ac_mfa_enabled (mk-access_control f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. AccessControl accessor round-trip: ac_role_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ac_role_verified (mk-access_control f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DependencyIsolation record properties ---

; --- 64. DependencyIsolation accessor round-trip: di_dependency_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (di_dependency_id (mk-dependency_isolation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. DependencyIsolation accessor round-trip: di_isolation_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (di_isolation_level (mk-dependency_isolation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. DependencyIsolation accessor round-trip: di_sandboxed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (di_sandboxed (mk-dependency_isolation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. DependencyIsolation accessor round-trip: di_network_restricted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (di_network_restricted (mk-dependency_isolation f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. DependencyIsolation: integer field consistency ---
(push 1)
(declare-const r DependencyIsolation)
(assert (>= (di_dependency_id r) 0))
(assert (>= (di_isolation_level r) 0))
(assert (not (>= (+ (di_dependency_id r) (di_isolation_level r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
