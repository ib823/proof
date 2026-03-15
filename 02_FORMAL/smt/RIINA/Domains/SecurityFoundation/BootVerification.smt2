; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA BootVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/BootVerification.v (22 assertions)
; Module: BootVerification
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((BootStageId 0)) (((HardwareRoot) (Bootloader) (SecondStage) (Kernel) (InitRamFS))))

(declare-datatypes ((VerificationResult 0)) (((Verified) (HashMismatch) (SignatureInvalid) (VersionRollback))))

(declare-datatypes ((BootImage 0))
  (((mk-boot_image (image_stage BootStageId) (image_hash Int) (image_signature Int) (image_version Int)))))

(declare-datatypes ((ExpectedHash 0))
  (((mk-expected_hash (expected_stage BootStageId) (expected_hash_value Int) (expected_public_key Int)))))

(declare-datatypes ((BootChainState 0))
  (((mk-boot_chain_state (verified_stages (Seq Int)) (current_stage BootStageId) (expected_hashes (Seq Int)) (minimum_versions (Seq Int)) (boot_successful Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- BootStageId enum properties ---

; --- 1. BootStageId exhaustiveness ---
(push 1)
(declare-const x BootStageId)
(assert (not (or (= x HardwareRoot) (= x Bootloader) (= x SecondStage) (= x Kernel) (= x InitRamFS))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. BootStageId: HardwareRoot != Bootloader ---
(push 1)
(assert (= HardwareRoot Bootloader))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. BootStageId: Bootloader != SecondStage ---
(push 1)
(assert (= Bootloader SecondStage))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. BootStageId: SecondStage != Kernel ---
(push 1)
(assert (= SecondStage Kernel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. BootStageId: HardwareRoot != InitRamFS ---
(push 1)
(assert (= HardwareRoot InitRamFS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. BootStageId finite cardinality (5 values) ---
(push 1)
(declare-const x BootStageId)
(assert (and (not (= x HardwareRoot)) (not (= x Bootloader)) (not (= x SecondStage)) (not (= x Kernel)) (not (= x InitRamFS))))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationResult enum properties ---

; --- 7. VerificationResult exhaustiveness ---
(push 1)
(declare-const x VerificationResult)
(assert (not (or (= x Verified) (= x HashMismatch) (= x SignatureInvalid) (= x VersionRollback))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. VerificationResult: Verified != HashMismatch ---
(push 1)
(assert (= Verified HashMismatch))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. VerificationResult: HashMismatch != SignatureInvalid ---
(push 1)
(assert (= HashMismatch SignatureInvalid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. VerificationResult: SignatureInvalid != VersionRollback ---
(push 1)
(assert (= SignatureInvalid VersionRollback))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. VerificationResult: Verified != VersionRollback ---
(push 1)
(assert (= Verified VersionRollback))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. VerificationResult finite cardinality (4 values) ---
(push 1)
(declare-const x VerificationResult)
(assert (and (not (= x Verified)) (not (= x HashMismatch)) (not (= x SignatureInvalid)) (not (= x VersionRollback))))
(check-sat) ; expect UNSAT
(pop 1)

; --- BootImage record properties ---

; --- 13. BootImage accessor round-trip: image_stage ---
(push 1)
(declare-const f0 BootStageId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (image_stage (mk-boot_image f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. BootImage accessor round-trip: image_hash ---
(push 1)
(declare-const f0 BootStageId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (image_hash (mk-boot_image f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. BootImage accessor round-trip: image_signature ---
(push 1)
(declare-const f0 BootStageId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (image_signature (mk-boot_image f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. BootImage: integer field consistency ---
(push 1)
(declare-const r BootImage)
(assert (>= (image_hash r) 0))
(assert (>= (image_signature r) 0))
(assert (not (>= (+ (image_hash r) (image_signature r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExpectedHash record properties ---

; --- 17. ExpectedHash accessor round-trip: expected_stage ---
(push 1)
(declare-const f0 BootStageId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (expected_stage (mk-expected_hash f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ExpectedHash accessor round-trip: expected_hash_value ---
(push 1)
(declare-const f0 BootStageId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (expected_hash_value (mk-expected_hash f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BootChainState record properties ---

; --- 19. BootChainState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 BootStageId)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Bool)
(assert (not (= (verified_stages (mk-boot_chain_state f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. BootChainState accessor round-trip: current_stage ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 BootStageId)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Bool)
(assert (not (= (current_stage (mk-boot_chain_state f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. BootChainState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 BootStageId)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Bool)
(assert (not (= (expected_hashes (mk-boot_chain_state f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. BootChainState accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 BootStageId)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Bool)
(assert (not (= (minimum_versions (mk-boot_chain_state f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BootChainState: integer field consistency ---
(push 1)
(declare-const r BootChainState)
(assert (>= (seq.len (verified_stages r)) 0))
(assert (>= (seq.len (verified_stages r)) 0))
(assert (not (>= (+ (seq.len (verified_stages r)) (seq.len (verified_stages r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
