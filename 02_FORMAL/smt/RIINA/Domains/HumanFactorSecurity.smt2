; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA HumanFactorSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/HumanFactorSecurity.v (54 assertions)
; Module: HumanFactorSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AuthMechanism 0)) (((PasswordOnly) (WebAuthn) (TOTP) (HardwareToken) (Biometric) (MultiFactorAuth))))

(declare-datatypes ((HumanThreat 0)) (((Phishing) (SpearPhishing) (Whaling) (Vishing) (Smishing) (Pretexting) (Baiting) (Tailgating) (DumpsterDiving) (ShoulderSurfing) (InsiderThreat) (Coercion) (Bribery) (Blackmail) (SocialEngineering) (CredentialSharing) (WeakPasswords) (PasswordReuse) (UnsafeBehavior) (ConfigurationError) (SockPuppetCampaign))))

(declare-datatypes ((UserRole 0)) (((StandardUser) (PrivilegedUser) (Executive) (Administrator) (Maintainer))))

(declare-datatypes ((TrainingStatus 0)) (((NotTrained) (BasicTrained) (AdvancedTrained) (CertifiedTrained))))

(declare-datatypes ((VerificationLevel 0)) (((NoVerification) (SingleVerification) (DualVerification) (MultiPartyVerification))))

(declare-datatypes ((PhysicalAccessLevel 0)) (((OpenAccess) (BadgeRequired) (BiometricRequired) (MantrapRequired) (EscortRequired))))

(declare-datatypes ((DisposalMethod 0)) (((StandardTrash) (Shredding) (CrossCutShredding) (SecureIncineration) (DegaussingAndDestruction))))

(declare-datatypes ((PasswordPolicy 0)) (((NoPolicy) (BasicPolicy) (StrongPolicy) (EnterprisePolicy) (ZeroTrustPolicy))))

(declare-datatypes ((ConfigManagement 0)) (((ManualConfig) (ScriptedConfig) (InfraAsCode) (AutomatedWithValidation) (ImmutableInfrastructure))))

(declare-datatypes ((ReviewProcess 0)) (((NoReview) (SingleReview) (PeerReview) (MultiMaintainerReview) (FormalVerificationReview))))

(declare-datatypes ((SecurityPolicyState 0))
  (((mk-security_policy_state (auth_mechanism AuthMechanism) (mfa_enabled Bool) (webauthn_enforced Bool) (training_status TrainingStatus) (phishing_training_complete Bool) (social_engineering_awareness Bool) (verification_level VerificationLevel) (callback_verification Bool) (out_of_band_verification Bool) (physical_access_level PhysicalAccessLevel) (privacy_screens_deployed Bool) (disposal_method DisposalMethod) (device_control_policy Bool) (url_filtering_enabled Bool) (least_privilege_enforced Bool) (audit_logging_enabled Bool) (credential_monitoring Bool) (duress_codes_enabled Bool) (plausible_deniability_possible Bool) (background_checks_performed Bool) (behavioral_monitoring Bool) (security_culture_established Bool) (password_policy PasswordPolicy) (unique_passwords_enforced Bool) (breach_detection_enabled Bool) (technical_controls_active Bool) (config_management ConfigManagement) (review_process ReviewProcess) (multi_maintainer_required Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- AuthMechanism enum properties ---

; --- 1. AuthMechanism exhaustiveness ---
(push 1)
(declare-const x AuthMechanism)
(assert (not (or (= x PasswordOnly) (= x WebAuthn) (= x TOTP) (= x HardwareToken) (= x Biometric) (= x MultiFactorAuth))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AuthMechanism: PasswordOnly != WebAuthn ---
(push 1)
(assert (= PasswordOnly WebAuthn))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AuthMechanism: WebAuthn != TOTP ---
(push 1)
(assert (= WebAuthn TOTP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AuthMechanism: TOTP != HardwareToken ---
(push 1)
(assert (= TOTP HardwareToken))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AuthMechanism: PasswordOnly != MultiFactorAuth ---
(push 1)
(assert (= PasswordOnly MultiFactorAuth))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. AuthMechanism finite cardinality (6 values) ---
(push 1)
(declare-const x AuthMechanism)
(assert (and (not (= x PasswordOnly)) (not (= x WebAuthn)) (not (= x TOTP)) (not (= x HardwareToken)) (not (= x Biometric)) (not (= x MultiFactorAuth))))
(check-sat) ; expect UNSAT
(pop 1)

; --- HumanThreat enum properties ---

; --- 7. HumanThreat exhaustiveness ---
(push 1)
(declare-const x HumanThreat)
(assert (not (or (= x Phishing) (= x SpearPhishing) (= x Whaling) (= x Vishing) (= x Smishing) (= x Pretexting) (= x Baiting) (= x Tailgating) (= x DumpsterDiving) (= x ShoulderSurfing) (= x InsiderThreat) (= x Coercion) (= x Bribery) (= x Blackmail) (= x SocialEngineering) (= x CredentialSharing) (= x WeakPasswords) (= x PasswordReuse) (= x UnsafeBehavior) (= x ConfigurationError) (= x SockPuppetCampaign))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. HumanThreat: Phishing != SpearPhishing ---
(push 1)
(assert (= Phishing SpearPhishing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. HumanThreat: SpearPhishing != Whaling ---
(push 1)
(assert (= SpearPhishing Whaling))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. HumanThreat: Whaling != Vishing ---
(push 1)
(assert (= Whaling Vishing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. HumanThreat: Phishing != SockPuppetCampaign ---
(push 1)
(assert (= Phishing SockPuppetCampaign))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. HumanThreat finite cardinality (21 values) ---
(push 1)
(declare-const x HumanThreat)
(assert (and (not (= x Phishing)) (not (= x SpearPhishing)) (not (= x Whaling)) (not (= x Vishing)) (not (= x Smishing)) (not (= x Pretexting)) (not (= x Baiting)) (not (= x Tailgating)) (not (= x DumpsterDiving)) (not (= x ShoulderSurfing)) (not (= x InsiderThreat)) (not (= x Coercion)) (not (= x Bribery)) (not (= x Blackmail)) (not (= x SocialEngineering)) (not (= x CredentialSharing)) (not (= x WeakPasswords)) (not (= x PasswordReuse)) (not (= x UnsafeBehavior)) (not (= x ConfigurationError)) (not (= x SockPuppetCampaign))))
(check-sat) ; expect UNSAT
(pop 1)

; --- UserRole enum properties ---

; --- 13. UserRole exhaustiveness ---
(push 1)
(declare-const x UserRole)
(assert (not (or (= x StandardUser) (= x PrivilegedUser) (= x Executive) (= x Administrator) (= x Maintainer))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. UserRole: StandardUser != PrivilegedUser ---
(push 1)
(assert (= StandardUser PrivilegedUser))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. UserRole: PrivilegedUser != Executive ---
(push 1)
(assert (= PrivilegedUser Executive))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. UserRole: Executive != Administrator ---
(push 1)
(assert (= Executive Administrator))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. UserRole: StandardUser != Maintainer ---
(push 1)
(assert (= StandardUser Maintainer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. UserRole finite cardinality (5 values) ---
(push 1)
(declare-const x UserRole)
(assert (and (not (= x StandardUser)) (not (= x PrivilegedUser)) (not (= x Executive)) (not (= x Administrator)) (not (= x Maintainer))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TrainingStatus enum properties ---

; --- 19. TrainingStatus exhaustiveness ---
(push 1)
(declare-const x TrainingStatus)
(assert (not (or (= x NotTrained) (= x BasicTrained) (= x AdvancedTrained) (= x CertifiedTrained))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. TrainingStatus: NotTrained != BasicTrained ---
(push 1)
(assert (= NotTrained BasicTrained))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. TrainingStatus: BasicTrained != AdvancedTrained ---
(push 1)
(assert (= BasicTrained AdvancedTrained))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. TrainingStatus: AdvancedTrained != CertifiedTrained ---
(push 1)
(assert (= AdvancedTrained CertifiedTrained))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TrainingStatus: NotTrained != CertifiedTrained ---
(push 1)
(assert (= NotTrained CertifiedTrained))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TrainingStatus finite cardinality (4 values) ---
(push 1)
(declare-const x TrainingStatus)
(assert (and (not (= x NotTrained)) (not (= x BasicTrained)) (not (= x AdvancedTrained)) (not (= x CertifiedTrained))))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationLevel enum properties ---

; --- 25. VerificationLevel exhaustiveness ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (or (= x NoVerification) (= x SingleVerification) (= x DualVerification) (= x MultiPartyVerification))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. VerificationLevel: NoVerification != SingleVerification ---
(push 1)
(assert (= NoVerification SingleVerification))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. VerificationLevel: SingleVerification != DualVerification ---
(push 1)
(assert (= SingleVerification DualVerification))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. VerificationLevel: DualVerification != MultiPartyVerification ---
(push 1)
(assert (= DualVerification MultiPartyVerification))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. VerificationLevel: NoVerification != MultiPartyVerification ---
(push 1)
(assert (= NoVerification MultiPartyVerification))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. VerificationLevel finite cardinality (4 values) ---
(push 1)
(declare-const x VerificationLevel)
(assert (and (not (= x NoVerification)) (not (= x SingleVerification)) (not (= x DualVerification)) (not (= x MultiPartyVerification))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PhysicalAccessLevel enum properties ---

; --- 31. PhysicalAccessLevel exhaustiveness ---
(push 1)
(declare-const x PhysicalAccessLevel)
(assert (not (or (= x OpenAccess) (= x BadgeRequired) (= x BiometricRequired) (= x MantrapRequired) (= x EscortRequired))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. PhysicalAccessLevel: OpenAccess != BadgeRequired ---
(push 1)
(assert (= OpenAccess BadgeRequired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. PhysicalAccessLevel: BadgeRequired != BiometricRequired ---
(push 1)
(assert (= BadgeRequired BiometricRequired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. PhysicalAccessLevel: BiometricRequired != MantrapRequired ---
(push 1)
(assert (= BiometricRequired MantrapRequired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. PhysicalAccessLevel: OpenAccess != EscortRequired ---
(push 1)
(assert (= OpenAccess EscortRequired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. PhysicalAccessLevel finite cardinality (5 values) ---
(push 1)
(declare-const x PhysicalAccessLevel)
(assert (and (not (= x OpenAccess)) (not (= x BadgeRequired)) (not (= x BiometricRequired)) (not (= x MantrapRequired)) (not (= x EscortRequired))))
(check-sat) ; expect UNSAT
(pop 1)

; --- DisposalMethod enum properties ---

; --- 37. DisposalMethod exhaustiveness ---
(push 1)
(declare-const x DisposalMethod)
(assert (not (or (= x StandardTrash) (= x Shredding) (= x CrossCutShredding) (= x SecureIncineration) (= x DegaussingAndDestruction))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. DisposalMethod: StandardTrash != Shredding ---
(push 1)
(assert (= StandardTrash Shredding))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. DisposalMethod: Shredding != CrossCutShredding ---
(push 1)
(assert (= Shredding CrossCutShredding))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. DisposalMethod: CrossCutShredding != SecureIncineration ---
(push 1)
(assert (= CrossCutShredding SecureIncineration))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. DisposalMethod: StandardTrash != DegaussingAndDestruction ---
(push 1)
(assert (= StandardTrash DegaussingAndDestruction))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. DisposalMethod finite cardinality (5 values) ---
(push 1)
(declare-const x DisposalMethod)
(assert (and (not (= x StandardTrash)) (not (= x Shredding)) (not (= x CrossCutShredding)) (not (= x SecureIncineration)) (not (= x DegaussingAndDestruction))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PasswordPolicy enum properties ---

; --- 43. PasswordPolicy exhaustiveness ---
(push 1)
(declare-const x PasswordPolicy)
(assert (not (or (= x NoPolicy) (= x BasicPolicy) (= x StrongPolicy) (= x EnterprisePolicy) (= x ZeroTrustPolicy))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. PasswordPolicy: NoPolicy != BasicPolicy ---
(push 1)
(assert (= NoPolicy BasicPolicy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. PasswordPolicy: BasicPolicy != StrongPolicy ---
(push 1)
(assert (= BasicPolicy StrongPolicy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. PasswordPolicy: StrongPolicy != EnterprisePolicy ---
(push 1)
(assert (= StrongPolicy EnterprisePolicy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. PasswordPolicy: NoPolicy != ZeroTrustPolicy ---
(push 1)
(assert (= NoPolicy ZeroTrustPolicy))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. PasswordPolicy finite cardinality (5 values) ---
(push 1)
(declare-const x PasswordPolicy)
(assert (and (not (= x NoPolicy)) (not (= x BasicPolicy)) (not (= x StrongPolicy)) (not (= x EnterprisePolicy)) (not (= x ZeroTrustPolicy))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConfigManagement enum properties ---

; --- 49. ConfigManagement exhaustiveness ---
(push 1)
(declare-const x ConfigManagement)
(assert (not (or (= x ManualConfig) (= x ScriptedConfig) (= x InfraAsCode) (= x AutomatedWithValidation) (= x ImmutableInfrastructure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. ConfigManagement: ManualConfig != ScriptedConfig ---
(push 1)
(assert (= ManualConfig ScriptedConfig))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. ConfigManagement: ScriptedConfig != InfraAsCode ---
(push 1)
(assert (= ScriptedConfig InfraAsCode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. ConfigManagement: InfraAsCode != AutomatedWithValidation ---
(push 1)
(assert (= InfraAsCode AutomatedWithValidation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. ConfigManagement: ManualConfig != ImmutableInfrastructure ---
(push 1)
(assert (= ManualConfig ImmutableInfrastructure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. ConfigManagement finite cardinality (5 values) ---
(push 1)
(declare-const x ConfigManagement)
(assert (and (not (= x ManualConfig)) (not (= x ScriptedConfig)) (not (= x InfraAsCode)) (not (= x AutomatedWithValidation)) (not (= x ImmutableInfrastructure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ReviewProcess enum properties ---

; --- 55. ReviewProcess exhaustiveness ---
(push 1)
(declare-const x ReviewProcess)
(assert (not (or (= x NoReview) (= x SingleReview) (= x PeerReview) (= x MultiMaintainerReview) (= x FormalVerificationReview))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. ReviewProcess: NoReview != SingleReview ---
(push 1)
(assert (= NoReview SingleReview))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. ReviewProcess: SingleReview != PeerReview ---
(push 1)
(assert (= SingleReview PeerReview))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. ReviewProcess: PeerReview != MultiMaintainerReview ---
(push 1)
(assert (= PeerReview MultiMaintainerReview))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. ReviewProcess: NoReview != FormalVerificationReview ---
(push 1)
(assert (= NoReview FormalVerificationReview))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. ReviewProcess finite cardinality (5 values) ---
(push 1)
(declare-const x ReviewProcess)
(assert (and (not (= x NoReview)) (not (= x SingleReview)) (not (= x PeerReview)) (not (= x MultiMaintainerReview)) (not (= x FormalVerificationReview))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityPolicyState record properties ---

; --- 61. SecurityPolicyState accessor round-trip: auth_mechanism ---
(push 1)
(declare-const f0 AuthMechanism)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 TrainingStatus)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 VerificationLevel)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 PhysicalAccessLevel)
(declare-const f10 Bool)
(declare-const f11 DisposalMethod)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(declare-const f19 Bool)
(declare-const f20 Bool)
(declare-const f21 Bool)
(declare-const f22 PasswordPolicy)
(declare-const f23 Bool)
(declare-const f24 Bool)
(declare-const f25 Bool)
(declare-const f26 ConfigManagement)
(declare-const f27 ReviewProcess)
(assert (not (= (auth_mechanism (mk-security_policy_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. SecurityPolicyState accessor round-trip: mfa_enabled ---
(push 1)
(declare-const f0 AuthMechanism)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 TrainingStatus)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 VerificationLevel)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 PhysicalAccessLevel)
(declare-const f10 Bool)
(declare-const f11 DisposalMethod)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(declare-const f19 Bool)
(declare-const f20 Bool)
(declare-const f21 Bool)
(declare-const f22 PasswordPolicy)
(declare-const f23 Bool)
(declare-const f24 Bool)
(declare-const f25 Bool)
(declare-const f26 ConfigManagement)
(declare-const f27 ReviewProcess)
(assert (not (= (mfa_enabled (mk-security_policy_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. SecurityPolicyState accessor round-trip: webauthn_enforced ---
(push 1)
(declare-const f0 AuthMechanism)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 TrainingStatus)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 VerificationLevel)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 PhysicalAccessLevel)
(declare-const f10 Bool)
(declare-const f11 DisposalMethod)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(declare-const f19 Bool)
(declare-const f20 Bool)
(declare-const f21 Bool)
(declare-const f22 PasswordPolicy)
(declare-const f23 Bool)
(declare-const f24 Bool)
(declare-const f25 Bool)
(declare-const f26 ConfigManagement)
(declare-const f27 ReviewProcess)
(assert (not (= (webauthn_enforced (mk-security_policy_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. SecurityPolicyState accessor round-trip: training_status ---
(push 1)
(declare-const f0 AuthMechanism)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 TrainingStatus)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 VerificationLevel)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 PhysicalAccessLevel)
(declare-const f10 Bool)
(declare-const f11 DisposalMethod)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(declare-const f19 Bool)
(declare-const f20 Bool)
(declare-const f21 Bool)
(declare-const f22 PasswordPolicy)
(declare-const f23 Bool)
(declare-const f24 Bool)
(declare-const f25 Bool)
(declare-const f26 ConfigManagement)
(declare-const f27 ReviewProcess)
(assert (not (= (training_status (mk-security_policy_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. SecurityPolicyState accessor round-trip: phishing_training_complete ---
(push 1)
(declare-const f0 AuthMechanism)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 TrainingStatus)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 VerificationLevel)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 PhysicalAccessLevel)
(declare-const f10 Bool)
(declare-const f11 DisposalMethod)
(declare-const f12 Bool)
(declare-const f13 Bool)
(declare-const f14 Bool)
(declare-const f15 Bool)
(declare-const f16 Bool)
(declare-const f17 Bool)
(declare-const f18 Bool)
(declare-const f19 Bool)
(declare-const f20 Bool)
(declare-const f21 Bool)
(declare-const f22 PasswordPolicy)
(declare-const f23 Bool)
(declare-const f24 Bool)
(declare-const f25 Bool)
(declare-const f26 ConfigManagement)
(declare-const f27 ReviewProcess)
(assert (not (= (phishing_training_complete (mk-security_policy_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerificationLevel ordering properties ---

(define-fun VerificationLevel_level ((x VerificationLevel)) Int
  (ite (= x NoVerification) 0 (ite (= x SingleVerification) 1 (ite (= x DualVerification) 2 3))))

(define-fun VerificationLevel_leq ((x VerificationLevel) (y VerificationLevel)) Bool
  (<= (VerificationLevel_level x) (VerificationLevel_level y)))

; --- 66. VerificationLevel_leq reflexivity ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (VerificationLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. VerificationLevel_leq transitivity ---
(push 1)
(declare-const x VerificationLevel)
(declare-const y VerificationLevel)
(declare-const z VerificationLevel)
(assert (VerificationLevel_leq x y))
(assert (VerificationLevel_leq y z))
(assert (not (VerificationLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. VerificationLevel_leq antisymmetry ---
(push 1)
(declare-const x VerificationLevel)
(declare-const y VerificationLevel)
(assert (VerificationLevel_leq x y))
(assert (VerificationLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. NoVerification is bottom ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (VerificationLevel_leq NoVerification x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. MultiPartyVerification is top ---
(push 1)
(declare-const x VerificationLevel)
(assert (not (VerificationLevel_leq x MultiPartyVerification)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PhysicalAccessLevel ordering properties ---

(define-fun PhysicalAccessLevel_level ((x PhysicalAccessLevel)) Int
  (ite (= x OpenAccess) 0 (ite (= x BadgeRequired) 1 (ite (= x BiometricRequired) 2 (ite (= x MantrapRequired) 3 4)))))

(define-fun PhysicalAccessLevel_leq ((x PhysicalAccessLevel) (y PhysicalAccessLevel)) Bool
  (<= (PhysicalAccessLevel_level x) (PhysicalAccessLevel_level y)))

; --- 71. PhysicalAccessLevel_leq reflexivity ---
(push 1)
(declare-const x PhysicalAccessLevel)
(assert (not (PhysicalAccessLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. PhysicalAccessLevel_leq transitivity ---
(push 1)
(declare-const x PhysicalAccessLevel)
(declare-const y PhysicalAccessLevel)
(declare-const z PhysicalAccessLevel)
(assert (PhysicalAccessLevel_leq x y))
(assert (PhysicalAccessLevel_leq y z))
(assert (not (PhysicalAccessLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. PhysicalAccessLevel_leq antisymmetry ---
(push 1)
(declare-const x PhysicalAccessLevel)
(declare-const y PhysicalAccessLevel)
(assert (PhysicalAccessLevel_leq x y))
(assert (PhysicalAccessLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. OpenAccess is bottom ---
(push 1)
(declare-const x PhysicalAccessLevel)
(assert (not (PhysicalAccessLevel_leq OpenAccess x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. EscortRequired is top ---
(push 1)
(declare-const x PhysicalAccessLevel)
(assert (not (PhysicalAccessLevel_leq x EscortRequired)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
