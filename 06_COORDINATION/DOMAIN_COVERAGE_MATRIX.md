# Research Track → Coq Proof Coverage Matrix

**Audit Update:** 2026-02-06 (Session 78: Proof Depth 20+ All Files) — 7,928 Coq Qed + 91 Lean theorems + 102 Isabelle lemmas = 8,121 total proofs. 0 Admitted/sorry across all provers. 1 axiom (policy). 250 active .v, 11 .lean, 10 .thy. 86 triple-prover theorems. 845 Rust tests.

> Auto-generated: 2026-02-02
> Method: `grep -c "^Qed\."` on each .v file; `find -name "*.md"` on each research dir

---

## Summary

| Category | Research Docs | Coq Files | Total Qed | Coverage |
|----------|--------------|-----------|-----------|----------|
| **Core (A-C)** | 108 | 33 | 668 | HIGH |
| **Security (D-I)** | 10 | 26 | 309 | HIGH |
| **Toolchain (J-Q)** | 8 | 8 | 175 | HIGH |
| **Zero-Trust (R-Z)** | 9 | 9 | 304 | HIGH |
| **Greek (Sigma-Upsilon)** | 13 | 19 | 504 | HIGH |
| **Extended (AA-AM)** | 13 | 10 | 258 | MED |
| **Product Domains** | 8 | 13 | 319 | HIGH |
| **Mobile OS** | 5 | 27 | 154 | HIGH |
| **Security Foundation** | — | 11 | 62 | N/A |
| **UI/UX** | — | 7 | 49 | N/A |
| **Malaysia Compliance** | — | 9 | 86 | N/A |
| **Singapore Compliance** | — | 6 | 60 | N/A |
| **Industries** | — | 15 | 32 | N/A |
| **Compliance (standalone)** | — | 4 | 108 | N/A |
| **TOTALS** | **174+** | **197+** | **~3,088** | — |

> Note: Total active Qed across ALL .v files (including those not mapped to research domains) is ~4,044. The ~1,797 gap comes from properties/, foundations/, type_system/, effects/ files that serve multiple domains, plus domain files with additional cross-cutting proofs.

---

## Core Domains (A-C)

| Domain | Dir | Research Docs | Coq Files | Qed | Coverage |
|--------|-----|--------------|-----------|-----|----------|
| **A — Type Theory** | 01_DOMAIN_A | 72 | Syntax.v (5), Typing.v (12), Semantics.v (13), Preservation.v (19), Progress.v (9), TypeSafety.v (2), DependentTypes.v (33), LinearTypes.v (23), OwnershipTypes.v (19), RefinementTypes.v (1), QuantumTypes.v (17), MLTTFoundation.v (25) | 178 | ~95% |
| **B — Effect Systems** | 02_DOMAIN_B | 27 | EffectAlgebra.v (9), EffectGate.v (1), EffectSystem.v (6), AlgebraicEffects.v (22) | 38 | ~80% |
| **C — Info Flow Control** | 03_DOMAIN_C | 9 | NI_v2.v (48), NI_v2_LR.v (129), NI_v2_Monotone.v (5), Declassification.v (7), QuantitativeDeclassification.v (8), + 18 properties/*.v | 398 | ~95% |

## Security Domains (D-I)

| Domain | Dir | Research Docs | Coq Files | Qed | Coverage |
|--------|-----|--------------|-----------|-----|----------|
| **D — Hardware Security** | 04_DOMAIN_D | 2 | HardwareSecurity.v (34), CapabilitySecurity.v (2), SpectreDefense.v (14), MeltdownDefense.v (10), SpeculativeExecution.v (11) | 71 | ~90% |
| **E — Formal Verification** | 05_DOMAIN_E | 1 | FormalVerification.v (36), MultiProverValidation.v (13), DualModeVerification.v (10), ProbabilisticVerification.v (10), LLMProofPipeline.v (19) | 88 | ~95% |
| **F — Memory Safety** | 06_DOMAIN_F | 1 | MemorySafety.v (2), BufferOverflowPrevention.v (8), IrisSeparationLogic.v (5) | 15 | ~60% |
| **G — Crypto** | 07_DOMAIN_G | 2 | ConstantTimeCrypto.v (16), CryptographicSecurity.v (0), PostQuantumKEM.v (13), PostQuantumSignatures.v (12), QuantumSafeTLS.v (2), FHESecurity.v (2), ZKSNARKSecurity.v (2), ZKSTARKSecurity.v (2), TimingSecurity.v (67) | 116 | ~75% |
| **H — Concurrency & Policy** | 08_DOMAIN_H | 2 | DataRaceFreedom.v (2), SessionTypes.v (2) | 4 | ~30% |
| **I — Error & OS** | 09_DOMAIN_I | 2 | ControlFlowIntegrity.v (15), HypervisorSecurity.v (2) | 17 | ~50% |

## Toolchain Domains (J-Q)

| Domain | Dir | Research Docs | Coq Files | Qed | Coverage |
|--------|-----|--------------|-----------|-----|----------|
| **J — Module Systems** | 10_DOMAIN_J | 1 | ModuleSystems.v (26) | 26 | ~90% |
| **K — Metaprogramming** | 11_DOMAIN_K | 2 | Metaprogramming.v (27) | 27 | ~80% |
| **L — FFI & Attack** | 12_DOMAIN_L | 2 | FFIAttackResearch.v (17), CrossLayerSecurity.v (11) | 28 | ~75% |
| **M — Testing QA** | 13_DOMAIN_M | 1 | TestingQA.v (29) | 29 | ~85% |
| **N — Tooling IDE** | 14_DOMAIN_N | 1 | ToolingIDE.v (21) | 21 | ~80% |
| **O — Runtime** | 15_DOMAIN_O | 1 | (none) | 0 | 0% |
| **P — Standard Library** | 16_DOMAIN_P | 1 | StandardLibrary.v (45) | 45 | ~90% |
| **Q — Compiler** | 17_DOMAIN_Q | 1 | CompilerCorrectness.v (2) | 2 | ~20% |

## Zero-Trust Domains (R-Z)

| Domain | Dir | Research Docs | Coq Files | Qed | Coverage |
|--------|-----|--------------|-----------|-----|----------|
| **R — Certified Compilation** | 18_DOMAIN_R | 1 | TranslationValidation.v (22) | 22 | ~80% |
| **S — Hardware Contracts** | 19_DOMAIN_S | 1 | S001_HardwareContracts.v (30) | 30 | ~85% |
| **T — Hermetic Build** | 20_DOMAIN_T | 1 | T001_HermeticBuild.v (28) | 28 | ~85% |
| **U — Runtime Guardian** | 21_DOMAIN_U | 1 | U001_RuntimeGuardian.v (36) | 36 | ~85% |
| **V — Termination** | 22_DOMAIN_V | 1 | V001_TerminationGuarantees.v (32) | 32 | ~85% |
| **W — Verified Memory** | 23_DOMAIN_W | 1 | W001_VerifiedMemory.v (40) | 40 | ~90% |
| **X — Concurrency Model** | 24_DOMAIN_X | 1 | X001_ConcurrencyModel.v (39) | 39 | ~90% |
| **Y — Verified Stdlib** | 25_DOMAIN_Y | 1 | Y001_VerifiedStdlib.v (41) | 41 | ~90% |
| **Z — Declassification** | 26_DOMAIN_Z | 1 | Z001_DeclassificationPolicy.v (36) | 36 | ~90% |

## Greek Letter Domains

| Domain | Dir | Research Docs | Coq Files | Qed | Coverage |
|--------|-----|--------------|-----------|-----|----------|
| **Sigma — Verified Storage** | 27_SIGMA | 1 | SIGMA001_VerifiedStorage.v (38) | 38 | ~90% |
| **Pi — Verified Performance** | 28_PI | 1 | PI001_VerifiedPerformance.v (34), WCETBounds.v (39), WCETTypes.v (8), BinarySizeBounds.v (17), SIMDVerification.v (14) | 112 | ~95% |
| **Delta — Verified Distribution** | 29_DELTA | 1 | DELTA001_VerifiedDistribution.v (28), DistributedConsensus.v (14), DistributedSecurity.v (47) | 89 | ~90% |
| **Omega — Network Defense** | 30_OMEGA | 1 | OMEGA001_NetworkDefense.v (30), NetworkDefense.v (43), NetworkSecurity.v (26) | 99 | ~95% |
| **Psi — Operational Security** | 31_PSI | 1 | PSI001_OperationalSecurity.v (39), OperationalSecurity.v (25) | 64 | ~90% |
| **Chi — Metadata Privacy** | 32_CHI | 1 | MetadataPrivacy.v (25) | 25 | ~85% |
| **Eta — Traffic Resistance** | 33_ETA | 1 | TrafficResistance.v (25) | 25 | ~85% |
| **Iota — Anonymous Comm** | 34_IOTA | 1 | AnonymousComm.v (25) | 25 | ~85% |
| **Kappa — Fullstack** | 35_KAPPA | 1 | FullstackSecurity.v (25) | 25 | ~85% |
| **Lambda — Mobile Platform** | 36_LAMBDA | 1 | MobilePlatform.v (25) | 25 | ~85% |
| **Mu — Enterprise ERP** | 37_MU | 1 | EnterpriseERP.v (25) | 25 | ~85% |
| **Nu — Verified AI/ML** | 38_NU | 1 | VerifiedAIML.v (15), AIMLSecurity.v (42), MLSafetyTypes.v (10) | 67 | ~90% |
| **Phi — Verified Hardware** | 39_PHI | 1 | VerifiedHardware.v (47) | 47 | ~90% |
| **Theta — Radiation Hardening** | 40_THETA | 1 | RadiationHardening.v (17) | 17 | ~80% |
| **AntiJam** | 41_ANTIJAM | 1 | AntiJamming.v (25) | 25 | ~85% |
| **Xi — Sensor Fusion** | 42_XI | 1 | SensorFusion.v (25) | 25 | ~85% |
| **Rho — Verified Autonomy** | 43_RHO | 1 | VerifiedAutonomy.v (25) | 25 | ~85% |
| **Tau — Mesh Networking** | 44_TAU | 1 | MeshNetworking.v (28) | 28 | ~85% |
| **Upsilon — Self-Healing** | 45_UPSILON | 1 | SelfHealing.v (25) | 25 | ~85% |

## Extended Domains (AA-AM)

| Domain | Dir | Research Docs | Coq Files | Qed | Coverage |
|--------|-----|--------------|-----------|-----|----------|
| **AA — Verified Identity** | 46_AA | 1 | VerifiedIdentity.v (40) | 40 | ~90% |
| **AB — Supply Chain** | 47_AB | 1 | SupplyChainSecurity.v (37) | 37 | ~90% |
| **AC — Covert Channels** | 48_AC | 1 | CovertChannels.v (16), CovertChannelElimination.v (23) | 39 | ~90% |
| **AD — Time Security** | 49_AD | 1 | TimeSecurity.v (25) | 25 | ~85% |
| **AE — Verified Audit** | 50_AE | 1 | VerifiedAudit.v (25) | 25 | ~85% |
| **AF — Secure Updates** | 51_AF | 1 | SecureUpdates.v (25) | 25 | ~85% |
| **AG — Key Lifecycle** | 52_AG | 1 | KeyLifecycle.v (25) | 25 | ~85% |
| **AH — Verified Protocols** | 53_AH | 1 | VerifiedProtocols.v (36) | 36 | ~90% |
| **AI — Verified Isolation** | 54_AI | 1 | VerifiedIsolation.v (35) | 35 | ~90% |
| **AJ — Verified Compliance** | 55_AJ | 1 | VerifiedCompliance.v (35) | 35 | ~90% |
| **AK — Verified Procurement** | 56_AK | 4 | (none) | 0 | 0% |
| **AL — Verified Layout** | 57_AL | 1 | (none) | 0 | 0% |
| **AM — AI-First Language** | 58_AM | 1 | (none) | 0 | 0% |

## Product Domains

| Domain | Dir | Research Docs | Coq Files | Qed | Coverage |
|--------|-----|--------------|-----------|-----|----------|
| **Total Stack** | 27_TOTAL_STACK | 1 | TotalStackFoundation.v (43) | 43 | ~90% |
| **RIINA OS** | 28_RIINA_OS | 1 | VerifiedMicrokernel.v (25) | 25 | ~80% |
| **RIINA Net** | 29_RIINA_NET | 1 | VerifiedNetwork.v (25), VerifiedNetworkStack.v (2) | 27 | ~80% |
| **RIINA Runtime** | 30_RIINA_RUNTIME | 1 | VerifiedRuntime.v (23) | 23 | ~80% |
| **RIINA UX** | 31_RIINA_UX | 1 | VerifiedUI.v (22) | 22 | ~80% |
| **RIINA Physics** | 32_RIINA_PHYSICS | 1 | PhysicsSecurity.v (16) | 16 | ~75% |
| **RIINA Infra** | 33_RIINA_INFRA | 1 | VerifiedInfra.v (26) | 26 | ~80% |
| **RIINA Bank** | 34_RIINA_BANK | 1 | CoreBanking.v (31) | 31 | ~85% |
| **RIINA Wallet** | 35_RIINA_WALLET | 1 | DigitalWallet.v (25) | 25 | ~85% |
| **RIINA Remit** | 36_RIINA_REMIT | 1 | CrossBorderRemittance.v (25) | 25 | ~85% |
| **RIINA HIS** | 37_RIINA_HIS | 1 | HealthcareIS.v (30) | 30 | ~85% |
| **RIINA ESG** | 38_RIINA_ESG | 1 | ESGCompliance.v (35) | 35 | ~90% |
| **RIINA Capital Markets** | 39_RIINA_CAPITAL | 1 | CapitalMarkets.v (15) | 15 | ~75% |

## Mobile OS Subdomain

| File | Qed |
|------|-----|
| AnimationSystem.v | 6 |
| AppDistribution.v | 7 |
| ApplicationLifecycle.v | 7 |
| BiometricSystem.v | 5 |
| CameraAudioSystem.v | 6 |
| CellularStack.v | 4 |
| ComputerVision.v | 5 |
| ConcurrencyFramework.v | 6 |
| DataPersistence.v | 5 |
| EncryptionSystem.v | 7 |
| FileSystem.v | 5 |
| GraphicsEngine.v | 6 |
| LocationServices.v | 6 |
| MemoryManagement.v | 6 |
| MultiDeviceContinuity.v | 5 |
| NetworkSecurity.v | 5 |
| NetworkingStack.v | 6 |
| NotificationSystem.v | 6 |
| OnDeviceML.v | 5 |
| PowerManagement.v | 6 |
| SystemApps.v | 8 |
| SystemArchitecture.v | 4 |
| TouchGestureSystem.v | 5 |
| TrackingPrevention.v | 5 |
| UIComponents.v | 6 |
| VoiceAssistant.v | 4 |
| WirelessProtocols.v | 5 |
| **Total (27 files)** | **154** |

## Security Foundation Subdomain

| File | Qed |
|------|-----|
| BootVerification.v | 6 |
| DisplayDriver.v | 5 |
| GarbageCollector.v | 5 |
| HardwareRootOfTrust.v | 6 |
| IOMMUProtection.v | 7 |
| InterruptVirtualization.v | 7 |
| MemoryVirtualization.v | 6 |
| NetworkDriver.v | 3 |
| RollbackProtection.v | 6 |
| SensorDrivers.v | 5 |
| VerifiedCrypto.v | 6 |
| **Total (11 files)** | **62** |

## UI/UX Subdomain

| File | Qed |
|------|-----|
| AnimationEngine.v | 5 |
| CognitiveAccessibility.v | 11 |
| GestureSystem.v | 4 |
| MotorAccessibility.v | 9 |
| ScrollPhysics.v | 4 |
| Transitions.v | 6 |
| VisualAccessibility.v | 10 |
| **Total (7 files)** | **49** |

## Compliance & Regulatory

| Region | Coq Files | Qed | Notes |
|--------|-----------|-----|-------|
| **Malaysia** | 9 files (PDPA, CybersecurityAct, BNMRMiT, BursaGov, KKMHealthcare, MAMPU, MCMC, DigitalSignature, SCGTM) | **86** | 9 regulatory frameworks |
| **Singapore** | 6 files (PDPA, CybersecurityAct, MAS_TRM, MTCS, HealthInfo, CyberTrustMark) | **60** | 6 regulatory frameworks |
| **ASEAN** | ASEANCompliance.v | **13** | Regional framework |
| **International** | HIPAA (15), PCI-DSS (37), DO-178C (28), ISO 26262 (23), CC EAL7 (52) | **155** | 5 major standards |
| **Compliance dir** | 4 files (DO178C, HIPAA, PCI-DSS, VerifiedCompliance) | **108** | Some overlap with domains/ |

## Industries

| File | Qed |
|------|-----|
| IndustryAerospace.v | 2 |
| IndustryAgriculture.v | 2 |
| IndustryEducation.v | 2 |
| IndustryEnergy.v | 2 |
| IndustryFinancial.v | 3 |
| IndustryGovernment.v | 2 |
| IndustryHealthcare.v | 2 |
| IndustryLegal.v | 2 |
| IndustryManufacturing.v | 2 |
| IndustryMedia.v | 2 |
| IndustryMilitary.v | 3 |
| IndustryRealEstate.v | 2 |
| IndustryRetail.v | 2 |
| IndustryTelecom.v | 2 |
| IndustryTransportation.v | 2 |
| **Total (15 files)** | **32** |

## Additional Cross-Cutting Domain Files

| File | Qed | Notes |
|------|-----|-------|
| AuthenticationProtocols.v | 2 | Cross-cutting |
| AuthenticationSecurity.v | 20 | Cross-cutting |
| BackendComposition.v | 11 | Phase 7 |
| BackendTraitVerification.v | 18 | Phase 7 |
| CertificationEvidence.v | 13 | Cross-cutting |
| ContainerSecurity.v | 2 | Cross-cutting |
| CSRFProtection.v | 3 | Web security |
| FutureSecurity.v | 24 | Forward-looking |
| HumanFactorSecurity.v | 54 | Cross-cutting |
| InjectionPrevention.v | 16 | Web security |
| MobileBridgeVerification.v | 20 | Phase 7 |
| PhysicalSecurity.v | 15 | Cross-cutting |
| PlatformStdlibVerification.v | 15 | Phase 7 |
| ROPDefense.v | 2 | Security |
| SecureBootVerification.v | 2 | Security |
| SmartContractSecurity.v | 27 | Blockchain |
| SQLInjectionPrevention.v | 8 | Web security |
| TEEAttestation.v | 2 | Hardware |
| VerifiedFileSystem.v | 2 | Storage |
| WasmBackendVerification.v | 39 | Phase 7 |
| WebSecurity.v | 25 | Web |
| XSSPrevention.v | 2 | Web security |

---

## Gaps Requiring Attention

| Domain | Issue | Priority |
|--------|-------|----------|
| **O — Runtime Execution** | 0 Coq files, 0 Qed | LOW (partially covered by U001_RuntimeGuardian.v) |
| **H — Concurrency & Policy** | Only 4 Qed across 2 files | LOW (X001_ConcurrencyModel.v has 39 Qed) |
| **Q — Compiler Architecture** | CompilerCorrectness.v has only 2 Qed | MED |
| **F — Memory Safety** | MemorySafety.v has only 2 Qed | MED (W001_VerifiedMemory.v has 40) |
| **AK — Verified Procurement** | 4 research docs, 0 Coq files | LOW |
| **AL — Verified Layout** | 1 research doc, 0 Coq files | LOW |
| **AM — AI-First Language** | 1 research doc, 0 Coq files | LOW |
| **CryptographicSecurity.v** | 0 Qed (empty proofs) | MED |
| **Industries/** | Only 2 Qed each (minimal coverage) | LOW |

---

## Admitted Proofs — Complete Inventory

| File | Admitted | Type | Notes |
|------|---------|------|-------|
| DELTA001_VerifiedDistribution.v | 3 | Domain proof | Distribution verification theorems |
| PlatformStdlibVerification.v | 1 | Compat stub | `admit. Admitted.` — Rocq 9.1 compatibility |
| WasmBackendVerification.v | 1 | Compat stub | `admit. Admitted.` — Rocq 9.1 compatibility |
| MobileBridgeVerification.v | 1 | Compat stub | `admit. Admitted.` — Rocq 9.1 compatibility |
| ValRelStepLimit_PROOF.v | 1 | Core property | Step-limit proof incomplete |
| **TOTAL** | **7** | **5 files** | |

---

## Gaps A1-A5: Unverified Typechecker Rules

Typing rules implemented in Rust (`03_PROTO/crates/riina-typechecker/`) with NO corresponding Coq proof.

| Gap | Rule Group | Rust Location | Coq Status | Action |
|-----|-----------|---------------|------------|--------|
| A1 | Tainted/Sanitized | riina-types (TTainted, TSanitized) | Types defined, no rules | Add T_Tainted, T_Sanitized to Typing.v |
| A2 | Labeled Types | riina-types (TLabeled) | Type defined, no rules | Add T_Labeled to Typing.v |
| A3 | Crypto Types | riina-types (TConstantTime, TZeroizing) | Types defined, no rules | Add typing rules |
| A4 | Session/FFI | riina-typechecker (FFICall, Chan) | Stub rules only | Add T_Chan, T_FFICall; define FFI types in Syntax.v |
| A5 | LetRec/BinOp/Capabilities | riina-typechecker (LetRec, BinOp, Require/Grant) | Missing entirely | Add ELetRec, EBinOp to Syntax.v; full typing rules |

**Priority order:** A5 (LetRec/BinOp — most used) > A1 (Tainted — security critical) > A4 (FFI) > A3 (Crypto) > A2 (Labeled)

---

*Generated by automated codebase analysis. Coverage percentages are estimates based on the ratio of proven theorems to research scope breadth.*
