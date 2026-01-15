# ULTIMATE FORENSIC AUDIT REPORT

## TERAS PROOF REPOSITORY

| Field | Value |
|-------|-------|
| Repository | https://github.com/ib823/proof |
| Audit Date | 2026-01-15T08:26:51+00:00 |
| Auditor | Claude Code Forensic System |
| Mode | ULTRA KIASU \| FUCKING PARANOID \| ZERO TRUST \| ZERO LAZINESS |

---

## SECTION 1: REPOSITORY METRICS

| Metric | Value |
|--------|-------|
| Total Files | 715 |
| Total Lines | 1069549 |
| Total Commits | 27 |
| Repository Hash | 65906bc8229a5335f5e985a802e2adfff5eeb9fce59caed313619ee5cdf095c4 |

### 1.1 Language Breakdown

```
v: 3366 lines
rs: 30770 lines
md: 241855 lines
toml: 473 lines
sh: 693 lines
ads: 241 lines
adb: 0 lines
```

---

## SECTION 2: COQ PROOF STATUS

| File | Theorems | Lemmas | Qed | Admitted | Status |
|------|----------|--------|-----|----------|--------|
| EffectAlgebra.v | 0
0 | 9 | 9 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| EffectGate.v | 1 | 0
0 | 1 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| EffectSystem.v | 1 | 0
0 | 1 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| Semantics.v | 0
0 | 2 | 2 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| Syntax.v | 0
0 | 3 | 3 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| Typing.v | 0
0 | 1 | 1 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| Composition.v | 0
0 | 0
0 | 0
0 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| NonInterference.v | 2 | 40 | 42 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| SecurityProperties.v | 0
0 | 0
0 | 0
0 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| Preservation.v | 1 | 6 | 7 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| Progress.v | 1 | 4 | 5 | 0
0 | 🟡 PARTIAL (0
0 admits) |
| TypeSafety.v | 2 | 0
0 | 2 | 0
0 | 🟡 PARTIAL (0
0 admits) |

### 2.1 Build Status

Build Exit Code: 0

### 2.2 Admits Analysis

| Type | Count |
|------|-------|
| Admitted | 0 |
| admit. | 0 |
| Abort | 0 |

### 2.3 Admitted Locations

```
```

---

## SECTION 3: RUST CODE STATUS

| Metric | Value |
|--------|-------|
| Rust Files | 46 |
| Unsafe Blocks | 16 |
| TODO/FIXME | 34 |
| Panic/Unwrap | 89 |

### 3.1 Dependency Audit

```
DEPENDENCY AUDIT REPORT
=======================

=== ./03_PROTO/crates/teras-lang-types/Cargo.toml ===

Dependencies:
[dependencies]

Dev-dependencies:

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-codegen/Cargo.toml ===

Dependencies:
[dependencies]

Dev-dependencies:

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-parser/Cargo.toml ===

Dependencies:
[dependencies]
teras-lang-lexer.workspace = true
teras-lang-types.workspace = true


Dev-dependencies:
[dev-dependencies]

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-lexer/Cargo.toml ===

Dependencies:
[dependencies]
# No dependencies (Law 8)


Dev-dependencies:
[dev-dependencies]

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-typechecker/Cargo.toml ===

Dependencies:
[dependencies]
```

---

## SECTION 4: DOCUMENTATION STATUS

| Metric | Value |
|--------|-------|
| Markdown Files | 308 |
| Total Words | Calculated during audit |

---

## SECTION 5: RESEARCH ARCHIVE

| Metric | Value |
|--------|-------|
| Research Files | 299 |

---

## SECTION 6: CRITICAL FINDINGS

### 6.1 Security Concerns

- Unsafe blocks: 16
- Third-party dependencies: Review dependency_audit.txt

### 6.2 Incomplete Work

- Admitted proofs: 0
- TODO items: 34

---

## SECTION 7: FILE INVENTORY

### Complete File List

```
./SESSION_LOG.md
./CLAUDE.md
./02_FORMAL/coq/foundations/.Syntax.aux
./02_FORMAL/coq/foundations/Typing.v
./02_FORMAL/coq/foundations/Syntax.v
./02_FORMAL/coq/foundations/Semantics.v
./02_FORMAL/coq/effects/EffectGate.v
./02_FORMAL/coq/effects/EffectAlgebra.v
./02_FORMAL/coq/effects/EffectSystem.v
./02_FORMAL/coq/_CoqProject
./02_FORMAL/coq/type_system/TypeSafety.v
./02_FORMAL/coq/type_system/Progress.v
./02_FORMAL/coq/type_system/Preservation.v
./02_FORMAL/coq/.gitignore
./02_FORMAL/coq/.lia.cache
./02_FORMAL/coq/Makefile
./02_FORMAL/coq/properties/Composition.v
./02_FORMAL/coq/properties/SecurityProperties.v
./02_FORMAL/coq/properties/NonInterference.v
./PROGRESS.md
./03_PROTO/crates/teras-lang-types/Cargo.toml
./03_PROTO/crates/teras-lang-types/src/lib.rs
./03_PROTO/crates/teras-lang-codegen/Cargo.toml
./03_PROTO/crates/teras-lang-codegen/src/lib.rs
./03_PROTO/crates/teras-lang-parser/Cargo.toml
./03_PROTO/crates/teras-lang-parser/src/tests.rs
./03_PROTO/crates/teras-lang-parser/src/lib.rs
./03_PROTO/crates/teras-lang-lexer/Cargo.toml
./03_PROTO/crates/teras-lang-lexer/src/lexer.rs
./03_PROTO/crates/teras-lang-lexer/src/error.rs
./03_PROTO/crates/teras-lang-lexer/src/token.rs
./03_PROTO/crates/teras-lang-lexer/src/lib.rs
./03_PROTO/crates/teras-lang-typechecker/Cargo.toml
./03_PROTO/crates/teras-lang-typechecker/src/tests.rs
./03_PROTO/crates/teras-lang-typechecker/src/lib.rs
./03_PROTO/crates/terasc/Cargo.toml
./03_PROTO/crates/terasc/src/main.rs
./03_PROTO/Cargo.toml
./03_PROTO/Cargo.lock
./RESUMPTION_PROMPT.md
./.gitignore
./00_SETUP/SETUP_COMPLETE.marker
./00_SETUP/scripts/verify_setup.sh
./00_SETUP/scripts/install_lean.sh
./00_SETUP/scripts/install_rust.sh
./00_SETUP/scripts/install_coq.sh
./06_COORDINATION/MASTER_ATTACK_PLAN.md
./06_COORDINATION/COORDINATION_LOG.md
./06_COORDINATION/DECISIONS.md
./06_COORDINATION/DEPENDENCY_GRAPH.md
./README.md
./04_SPECS/language/.gitkeep
./04_SPECS/README.md
./04_SPECS/effect_gate/.gitkeep
./04_SPECS/products/.gitkeep
./01_RESEARCH/06_DOMAIN_F_MEMORY_SAFETY/RESEARCH_DOMAIN_F_COMPLETE.md
./01_RESEARCH/TRACK_F_STATUS_UPDATE_2026-01-03.md
./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_AUDIT_REPORT.md
./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_INTEGRATION.md
./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_COMPLETE_SUMMARY.md
./01_RESEARCH/specs/LATS_v1_0_0_ASSESSMENT.md
./01_RESEARCH/specs/RESEARCH_C03_LABEL_MODELS_DECISION.md
./01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_C02_SECURITY_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_DECISION.md
./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A01_MLTT_DECISION.md
./01_RESEARCH/specs/RESEARCH_C06_C10_COMBINED.md
./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_COMPARISON.md
./01_RESEARCH/specs/VALIDATION-REPORT-A-V01_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_A13_OWNERSHIP_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A17_HIGHER_KINDED_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_H_POLICY_LANGUAGES.md
./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_SURVEY__1_.md
./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_DECISION.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_J_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_B05_KOKA_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_E_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A04_LINEAR_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A07_SESSION_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_TRACK_AUDIT_REPORT.md
./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_C03_LABEL_MODELS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A14_CAPABILITY_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_B09_EFFECT_SUBTYPING_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A15_STAGED_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_B02_MONADIC_EFFECTS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A16_SIZED_TYPES_COMPARISON.md
./01_RESEARCH/specs/TERAS_DEFINITIVE_PLAN_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_B06_FRANK_EFFEKT_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A01_MLTT_SURVEY.md
./01_RESEARCH/specs/TERAS_GAP_ELIMINATION_ADDENDUM_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_M_COMPLETE.md
./01_RESEARCH/specs/TERAS_PHASE_A_BOOT_TRUE_BOOTSTRAP_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_O_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_B08_EFFECT_INFERENCE_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A19_TYPE_INFERENCE_DECISION.md
./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A16_ROW_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_B02_MONADIC_EFFECTS_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_B10_EFFECTS_PRACTICE_DECISION.md
./01_RESEARCH/specs/RESEARCH_C02_SECURITY_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_B04_EFFECT_HANDLERS_DECISION.md
./01_RESEARCH/specs/RESEARCH_A11_EFFECT_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A19_TYPE_INFERENCE_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A17_ROW_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A10_GRADUAL_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_TRACK_INTEGRATION.md
./01_RESEARCH/specs/RESEARCH_C04_DECLASSIFICATION_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A13_OWNERSHIP_TYPES_DECISION.md
./01_RESEARCH/specs/TERAS_MASTER_ARCHITECTURE_v3_2_2_CONSOLIDATED.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_Q_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A20_TYPE_SOUNDNESS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_C04_C05_COMBINED.md
./01_RESEARCH/specs/CTSS_v1_0_1.md
./01_RESEARCH/specs/TRACK_A_SEAMLESS_CONTINUATION_PROTOCOL_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_D_HARDWARE_SECURITY.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_G_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A19_TYPE_INFERENCE_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A20_TYPE_SOUNDNESS_DECISION.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_N_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_B04_EFFECT_HANDLERS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_B07_ROW_EFFECTS_COMPARISON_DECISION.md
./01_RESEARCH/specs/RESEARCH_B01_ALGEBRAIC_EFFECTS_COMPARISON.md
./01_RESEARCH/specs/TERAS_HASH_CHAIN.md
./01_RESEARCH/specs/RESEARCH_A12_REGION_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A17_HIGHER_KINDED_TYPES_SURVEY.md
./01_RESEARCH/specs/TERAS_PHASE_A_ALL_PROMPTS_v2_0_0.md
./01_RESEARCH/specs/RESEARCH_A08_DEPENDENT_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A11_EFFECT_TYPES_SURVEY.md
./01_RESEARCH/specs/TERAS-LANG-LEXER-SPEC_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_B04_EFFECT_HANDLERS_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A11_EFFECT_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A16_SIZED_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A02_COC_CIC_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_G_SIDE_CHANNEL.md
./01_RESEARCH/specs/TERAS-LANG-GRAMMAR-STMT_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_A04_LINEAR_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_B07_ROW_EFFECTS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A07_SESSION_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A17_ROW_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_B05_KOKA_SURVEY__1_.md
./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_B10_EFFECTS_PRACTICE_SURVEY.md
./01_RESEARCH/specs/TERAS-LANG-GRAMMAR-EXPR_v1_0_0.md
./01_RESEARCH/specs/teras-lang-foundation-v0_3_1.md
./01_RESEARCH/specs/RESEARCH_A04_LINEAR_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A18_HIGHER_KINDED_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_B09_EFFECT_SUBTYPING_COMPARISON_DECISION.md
./01_RESEARCH/specs/RESEARCH_A15_STAGED_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_I_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A01_MLTT_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_K_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A08_DEPENDENT_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A10_GRADUAL_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A10_GRADUAL_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_B01_ALGEBRAIC_EFFECTS_SURVEY.md
./01_RESEARCH/specs/RESEARCH_B08_EFFECT_INFERENCE_COMPARISON_DECISION.md
./01_RESEARCH/specs/RESEARCH_A02_COC_CIC_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A03_HOTT_CUBICAL_DECISION.md
./01_RESEARCH/specs/TRACK_A_COMPLETION_GAP_ANALYSIS_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_L_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A06_UNIQUENESS_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A16_ROW_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A20_TYPE_SOUNDNESS_COMPARISON.md
./01_RESEARCH/specs/TERAS_PROGRESS.md
./01_RESEARCH/specs/RESEARCH_B06_FRANK_EFFEKT_DECISION.md
./01_RESEARCH/specs/RESEARCH_A17_HIGHER_KINDED_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_DECISION.md
./01_RESEARCH/specs/RESEARCH_A16_SIZED_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A12_REGION_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_B01_ALGEBRAIC_EFFECTS_DECISION.md
./01_RESEARCH/specs/RESEARCH_B10_EFFECTS_PRACTICE_COMPARISON_DECISION.md
./01_RESEARCH/specs/TERAS_COORDINATION_LOG_v1_0_0.md
./01_RESEARCH/specs/RESEARCH_A15_STAGED_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_TRACK_COMPLETE_SUMMARY.md
./01_RESEARCH/specs/RESEARCH_A06_UNIQUENESS_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A16_ROW_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_P_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_I_OS_SECURITY.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_L_ATTACK_RESEARCH.md
./01_RESEARCH/specs/RESEARCH_A02_COC_CIC_DECISION.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_D_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_B06_FRANK_EFFEKT_SURVEY.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_H_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A13_OWNERSHIP_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_A17_TYPE_INFERENCE_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A18_HIGHER_KINDED_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A08_DEPENDENT_TYPES_DECISION.md
./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_DOMAIN_F_COMPLETE.md
./01_RESEARCH/specs/RESEARCH_A14_CAPABILITY_TYPES_COMPARISON.md
./01_RESEARCH/specs/RESEARCH_B05_KOKA_DECISION.md
./01_RESEARCH/specs/TERAS_RESEARCH_SCOPE_FINAL_LOCKED.md
./01_RESEARCH/specs/RESEARCH_A08_REFINEMENT_TYPES_SURVEY.md
./01_RESEARCH/specs/RESEARCH_B05_KOKA_SURVEY.md
./01_RESEARCH/specs/RESEARCH_A18_HIGHER_KINDED_TYPES_COMPARISON.md
```

---

## SECTION 8: CRYPTOGRAPHIC HASHES

### All File Hashes (SHA-256)

```
9888dc7e5b1b9ff1238a2f30695b957b0a64427d527cacaedfc60ee382fe68c6  ./SESSION_LOG.md
b3393c084c1345e7c5847cc9e935731549aeca4c747061fccf453869f684955a  ./CLAUDE.md
0ff72af372af92407d8e97f17b91317389ea0bdbe5b505bf26de51d552c15e43  ./02_FORMAL/coq/foundations/.Syntax.aux
e06139b99a430dc49ff547adcce626f113e3797181963f1c9a4a477f54ce2177  ./02_FORMAL/coq/foundations/Typing.v
e203305dc3034ebd5a874154b4092504cf988da241318fdfb7fc9e7ce390a6d7  ./02_FORMAL/coq/foundations/Syntax.v
2891e76faf0be4bf4eadc83dfe232d81909c7d744d00f8f980f2f142e133b305  ./02_FORMAL/coq/foundations/Semantics.v
3e2fcb01ef2fe973e4a6197e492a0dae609597855e9f5cbc864af09c5d1e97a2  ./02_FORMAL/coq/effects/EffectGate.v
04dcc2c7040dadfc4d1f43da3bba85af83b1e55270d76e72ad6856d0f4dd2863  ./02_FORMAL/coq/effects/EffectAlgebra.v
300e968a8281f94a00e928c6fc47983680749ec53f9fc346be5822f044c6ba46  ./02_FORMAL/coq/effects/EffectSystem.v
a79092c6b4918469eabfa8c321f8a22e030c2f0ddb1a019a34af1dc4987b0974  ./02_FORMAL/coq/_CoqProject
120f81d16239eb42eff0c0a5fce2915fb7b620c8149de41b46a70cfb38970ab3  ./02_FORMAL/coq/type_system/TypeSafety.v
5168e49c1ef444b7be6d59ed6ca7af899a242d20224f289fffee608921fe0c94  ./02_FORMAL/coq/type_system/Progress.v
11d981ce23e19f8bbd6de969a4ff38bd679c07f5ef2603dccdafb71b2f9573c9  ./02_FORMAL/coq/type_system/Preservation.v
715cef0cf8f9ee55546a79e782fb9f43466666e6ce0a2e8c9b7b474c9adf73c8  ./02_FORMAL/coq/.gitignore
00b1835029aa7961c2676156683bcb93f55df047f0f1940e13aaaae133ca425e  ./02_FORMAL/coq/.lia.cache
3a02734b8b269a7785fea9421a4bd3df61ebe6643919f831a8ac75c19ebc0658  ./02_FORMAL/coq/Makefile
cdd395b380b40b676abf69e0a4151534641524888704d92fa66d67f86133324c  ./02_FORMAL/coq/properties/Composition.v
42754dfea5a924d146272ccd9ea1612095805b67b64335f06c04a1bdc1881b47  ./02_FORMAL/coq/properties/SecurityProperties.v
43744e1901efd4efaac4b5af52a7e5d64e80925e725cec8fd1db436c68727fe7  ./02_FORMAL/coq/properties/NonInterference.v
079f84dc76fa8711fbbc3731a41ccde41cb3323b7ba42a5cc816391f5e0a2578  ./PROGRESS.md
3bc44dd1512973bde2c056a62697a0b6634c5e443455e69e1174710ace684498  ./03_PROTO/crates/teras-lang-types/Cargo.toml
6abdbe9bac8051af391998fc5b9c2b92ed8466c3da3f6e7700a816bd427283a3  ./03_PROTO/crates/teras-lang-types/src/lib.rs
9df04dabbd534b95ca0ae65577320eacbddc2f7de37081cea01bc8b7513b09c8  ./03_PROTO/crates/teras-lang-codegen/Cargo.toml
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./03_PROTO/crates/teras-lang-codegen/src/lib.rs
e85c6debfbf1f13ba7012e9e705d25a083a88ab5c2d56929ffa26fdb481fd4ac  ./03_PROTO/crates/teras-lang-parser/Cargo.toml
ef713a8822186e8d2fa6e9df4da6b015e2d7be48b6a0620fb6b53b54f41bd4aa  ./03_PROTO/crates/teras-lang-parser/src/tests.rs
b1fa0f08740c4c13ce38ea2faf239d56f5a970819c30f4c599dcbb9369664c68  ./03_PROTO/crates/teras-lang-parser/src/lib.rs
d81e154850f0291104c91517378b167dd27048bbf22e9ae3b29b9f7b9a60effe  ./03_PROTO/crates/teras-lang-lexer/Cargo.toml
64ceac789ffce27e3cc994ceccdc8fd0d1eca261aca988b6612d5f0e46a04d61  ./03_PROTO/crates/teras-lang-lexer/src/lexer.rs
8d7f1d56c66bb672f62aedd7a9825d77071c06199a7ba6a9d56e5c60c0e171b6  ./03_PROTO/crates/teras-lang-lexer/src/error.rs
4e1d03bfb28a8ae3942816975e426d46cd2b5598c7f53c13c3e927d360993d49  ./03_PROTO/crates/teras-lang-lexer/src/token.rs
f57f1726400052961178ecb7f1af58e639832a10b01cd4de7f8fd5f780f4b60e  ./03_PROTO/crates/teras-lang-lexer/src/lib.rs
7d15acd948f577c268093be872bea719385b6d9211d1a858fa7947809a3dc83e  ./03_PROTO/crates/teras-lang-typechecker/Cargo.toml
42c388a40be8e12f4ae2af45115eb7cdbc1851f382558ce54d59e77fe3c225d9  ./03_PROTO/crates/teras-lang-typechecker/src/tests.rs
cfcd0063ce712cf5c8d2dd69b8a9e0b7881ff9558cfe602573a6feafbda58173  ./03_PROTO/crates/teras-lang-typechecker/src/lib.rs
37189fada9497fe06e1969325bcd5d005191dd7aa70f906bc8a01bbf76059ddc  ./03_PROTO/crates/terasc/Cargo.toml
8e1d6816a5b2e5bcfa465311647e37c2adf2f1ee42dc1d518fd71d73bf3f6dfc  ./03_PROTO/crates/terasc/src/main.rs
eb95134e700b66ed51bca0b7e1843b4df983aeae0e85cbe48dffecfee120a217  ./03_PROTO/Cargo.toml
393222745fbc3fe1c4ac81e05d4915979041d134fc80cb0a523e0814e98b9591  ./03_PROTO/Cargo.lock
6aabee0318085675cf23cf65e47471c646713461a89edd530d05363540214297  ./RESUMPTION_PROMPT.md
5357ab4f33b4cafe330737f460b9d2f0c34fc1c0ddbdbd53a2d5459444816bdd  ./.gitignore
96e7fb659b88e30923284c6e0de8d51f66cc7062a1a39f469401efd1fea6c53e  ./00_SETUP/SETUP_COMPLETE.marker
3fc7991a49ec2366c5e3cf6cb5704441eb03b0bf9255c827c30a341b20904074  ./00_SETUP/scripts/verify_setup.sh
13bdb55159db37440f523f6a6764709c6f5ca2d25454dd4a8d0e9b691ba824ba  ./00_SETUP/scripts/install_lean.sh
d6c6633ec10ed67acc613217f70db035666cdf1d3bd86b0f0e87420aa599b359  ./00_SETUP/scripts/install_rust.sh
10f404ccdb79a99696f83209f4b821d0299ef98df8c97b5df2dd125254da2c10  ./00_SETUP/scripts/install_coq.sh
dd50620e30253f440296a86cf95c78eecd426885d1b6b954c67e9adce34e08fb  ./06_COORDINATION/MASTER_ATTACK_PLAN.md
1137eac27ff52b3eb974fa2a74a0dbd8dea8f0fef6c600cc3132ede76d8420cb  ./06_COORDINATION/COORDINATION_LOG.md
9526b326def3071ef38f78badfffc0ca02cd67a63666522f268f747e20181a14  ./06_COORDINATION/DECISIONS.md
27dec833b5aa612d727a38e8340b44b3846537df7c9ae8d01d7a7a2ab6dc1f19  ./06_COORDINATION/DEPENDENCY_GRAPH.md
e990bd795ecc3bd4abbb37c9db69f381526e0d321435cba0adcd0415043cc2b0  ./README.md
b72a33cd14f57f38971130f1a249aecadea384e9ad8d46e754d25d65c1bb8a4d  ./04_SPECS/language/.gitkeep
042ecdbcd0cdda2ddbec9bdd92015d1313b55f62d6c43b84357e0542c6cbecb1  ./04_SPECS/README.md
b72a33cd14f57f38971130f1a249aecadea384e9ad8d46e754d25d65c1bb8a4d  ./04_SPECS/effect_gate/.gitkeep
b72a33cd14f57f38971130f1a249aecadea384e9ad8d46e754d25d65c1bb8a4d  ./04_SPECS/products/.gitkeep
219f3f4e5e38fd3cbb27ae0af42348dcdeefd56a688ac25071a429bcf9bd9b49  ./01_RESEARCH/06_DOMAIN_F_MEMORY_SAFETY/RESEARCH_DOMAIN_F_COMPLETE.md
e592911aa14a06274e6db61794f8f39ea3d6d92a855fb0f98df649301a35270c  ./01_RESEARCH/TRACK_F_STATUS_UPDATE_2026-01-03.md
0143c8cc4514c65b014d4804206e842cc3879b1063f35eea60684d6a0f5ff64e  ./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_AUDIT_REPORT.md
cd8c02b65d9e5397333e9c14610a2db113305c41d2b5eba246325f1eaff28f21  ./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_INTEGRATION.md
22881a21eaf82c14257cc328ae944db64e282d63f4a118625585f167db0ad6d4  ./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_COMPLETE_SUMMARY.md
5e9a9b97f449de2cd5890883a1482f8935ada5c48c5e55bbbf6c2aea439411ad  ./01_RESEARCH/specs/LATS_v1_0_0_ASSESSMENT.md
a9abe5848df11e62553856b27ea0b6cf515053baf8a2406c9645c8925462379b  ./01_RESEARCH/specs/RESEARCH_C03_LABEL_MODELS_DECISION.md
d097f145c0a0ca47d15ef81fcf73e4fb70c93145f58397198ce2ca2c443367b7  ./01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_SURVEY.md
bff05859556c0326266e1d3007a1a828b9c5f491550290e34bbe125d7d1d930d  ./01_RESEARCH/specs/RESEARCH_C02_SECURITY_TYPES_SURVEY.md
7e7df8d839a5e6c86a45e8f0f1b0b24e6e51ed17f585283561a86e5f02ac96ba  ./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_DECISION.md
131c0b15fbaccf93bee6b847580ace459d42245a0cfd99cf29da28abee7ca09a  ./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_DECISION.md
fd29147d314cb07b24661eba07f384d212750eaed133a108ee5d77edb7b7e02a  ./01_RESEARCH/specs/RESEARCH_A01_MLTT_DECISION.md
e2eb2e09c331a4fb0ab36416118afafd25517b1f136a6d3f26ba40239d4fe5be  ./01_RESEARCH/specs/RESEARCH_C06_C10_COMBINED.md
84f79ee8e6c9968e4fae8b78f9eba0a7d6c9098d5132ab8501cf44da08e9372f  ./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_COMPARISON.md
bba910a677cd373fce5523a82c44facb41fedd90293ac71e62de2a3b5c4c2d56  ./01_RESEARCH/specs/VALIDATION-REPORT-A-V01_v1_0_0.md
e0f6df7bf81f97665e31e0c07c1697553f10a81ca33d05e05ec5bccaa79dbdb8  ./01_RESEARCH/specs/RESEARCH_A13_OWNERSHIP_TYPES_SURVEY.md
ea7c85a8fd2fb18e42eb1d7e4f8573bc7cca1b73902df6be0493e36f627c993e  ./01_RESEARCH/specs/RESEARCH_A17_HIGHER_KINDED_TYPES_COMPARISON.md
7de09e7b9dd300b6b561ffe2efb010db79fc877994c56a47a316ccbb9bf8e153  ./01_RESEARCH/specs/RESEARCH_DOMAIN_H_POLICY_LANGUAGES.md
ab6f594b91a99765063bc0f06ab8b28022ce49156cb485385790f3a69573ed3f  ./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_SURVEY__1_.md
186ae6e6be7beb1770f08e28a6d989dbb18561b8fff27544b2946e84e8e16a63  ./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_DECISION.md
78df245d79d19a19bba95fcdffce90e13fbee94a643d81dba5e7834324cc0077  ./01_RESEARCH/specs/RESEARCH_DOMAIN_J_COMPLETE.md
969ebf2a895d019f910701aecef578ae68eebfb133eaa856f7cff359fa901c45  ./01_RESEARCH/specs/RESEARCH_B05_KOKA_COMPARISON.md
38e57bddc220da4619315de10495f378d6a42512a7173df67518b5919b5f5391  ./01_RESEARCH/specs/RESEARCH_DOMAIN_E_COMPLETE.md
5d63c1f3671d9733ad68816833080fedc35841e72f52fabd76e4dcf965a808b3  ./01_RESEARCH/specs/RESEARCH_A04_LINEAR_TYPES_SURVEY.md
07c48ed69d26ec9b2038c7fd13a03527ac5e4db2b65d852cecc5134a15d76f49  ./01_RESEARCH/specs/RESEARCH_A07_SESSION_TYPES_DECISION.md
cb6a4f106274016fa66dfd9760e87561bd6d8bbe403644651549c6e5ee7b9928  ./01_RESEARCH/specs/RESEARCH_TRACK_AUDIT_REPORT.md
fcc39d4b9f7c563f5192230911f163d3631dfb5f956c8a9546cd10f300ad120a  ./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_SURVEY.md
5da399fee93f16152018b0544ccb56c71959ad86913b98df6f05b4a91dee5c57  ./01_RESEARCH/specs/RESEARCH_C03_LABEL_MODELS_SURVEY.md
47f0aabcdf7a563710e458645e4687447240bc6dfa5457880a078a355eff42a2  ./01_RESEARCH/specs/RESEARCH_A14_CAPABILITY_TYPES_DECISION.md
d3a4bbda3e765da39c592191abbb9167052ade47dbd3e8226d419f5a858b46e6  ./01_RESEARCH/specs/RESEARCH_B09_EFFECT_SUBTYPING_SURVEY.md
3ad4ee223bda02440de45b595a93e82507fcbe1475fcfd6ed543053dafaf9b16  ./01_RESEARCH/specs/RESEARCH_A15_STAGED_TYPES_DECISION.md
351bb114ba8ad0b047acc9b8424c6267ce641ad7a45b1d92749f99e8a6a8441c  ./01_RESEARCH/specs/RESEARCH_B02_MONADIC_EFFECTS_SURVEY.md
4da1d2b06d0206db1d0b979d97a38318f2535282ff4b2e62bd4187a6f83310f2  ./01_RESEARCH/specs/RESEARCH_A16_SIZED_TYPES_COMPARISON.md
737d3a515f05d0eb2bd23cfddec81cdb2f617d6f681afdd147e9f7a900e7c5cb  ./01_RESEARCH/specs/TERAS_DEFINITIVE_PLAN_v1_0_0.md
2ae286915c1b6646fb195c342aab6c55827e18110011a45abfc9d1159cca5b56  ./01_RESEARCH/specs/RESEARCH_B06_FRANK_EFFEKT_COMPARISON.md
fe666c2bbfc3bafb336a838bbfaa4bb4b2a8d405827147267a1c153e55e787d7  ./01_RESEARCH/specs/RESEARCH_A01_MLTT_SURVEY.md
394ac9b378084f63c326382842df6e789b8215702d7208ef597ce3edd5744fb4  ./01_RESEARCH/specs/TERAS_GAP_ELIMINATION_ADDENDUM_v1_0_0.md
d56574b36282bb2e95cd3ecebb4e3a6801949bd8da183d517f173fba6aadddaa  ./01_RESEARCH/specs/RESEARCH_DOMAIN_M_COMPLETE.md
5c2dc49759737d0b333a930230047919dec647078686b937947fad2dab9674b2  ./01_RESEARCH/specs/TERAS_PHASE_A_BOOT_TRUE_BOOTSTRAP_v1_0_0.md
54f6d546bf7b836f91747c633a55fa3161e03ba54c08fb387d10dc59f0cc38f0  ./01_RESEARCH/specs/RESEARCH_DOMAIN_O_COMPLETE.md
a31645559ef89c4e7f95cddfa0ab38df823183a28eed47f050ed148edcb4aa5d  ./01_RESEARCH/specs/RESEARCH_B08_EFFECT_INFERENCE_SURVEY.md
6a875f4bb0a12c6e1f7428400b94901bab8992d56ba6bf0daa2d6472f93f3636  ./01_RESEARCH/specs/RESEARCH_A19_TYPE_INFERENCE_DECISION.md
55be9ee38501c8274f98022da07c371c49a48af51c23083e688ac5c01bdff118  ./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_SURVEY.md
8c93f85e416dd4651276c386e6286f4fcc63b3a2da48a124dbecf00b973af1e8  ./01_RESEARCH/specs/RESEARCH_A16_ROW_TYPES_COMPARISON.md
48102a35c67a47477a62686f4975fb47f22e02bba4f4c530340e92548ca08fe1  ./01_RESEARCH/specs/RESEARCH_B02_MONADIC_EFFECTS_COMPARISON.md
```

---

## AUDIT COMPLETE

Generated: Thu Jan 15 08:26:51 UTC 2026

All detailed reports available in: /workspaces/forensic_audit_20260115_081333/AUDIT_REPORT


---

## Build Exit Codes

### Coq

```
0

```

### Rust (cargo build per Cargo.toml directory)

```
/workspaces/forensic_audit_20260115_081333/proof/03_PROTO: 0
/workspaces/forensic_audit_20260115_081333/proof/03_PROTO/crates/teras-lang-codegen: 0
/workspaces/forensic_audit_20260115_081333/proof/03_PROTO/crates/teras-lang-lexer: 0
/workspaces/forensic_audit_20260115_081333/proof/03_PROTO/crates/teras-lang-parser: 0
/workspaces/forensic_audit_20260115_081333/proof/03_PROTO/crates/teras-lang-typechecker: 0
/workspaces/forensic_audit_20260115_081333/proof/03_PROTO/crates/teras-lang-types: 0
/workspaces/forensic_audit_20260115_081333/proof/03_PROTO/crates/terasc: 0
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-build: 0
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-core: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-effect: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-lang-codegen: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-lang-lexer: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-lang-parser: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-lang-types: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/teras-verify: 0
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/crates/terasc: 101
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/tools/artifact-sign: 0
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/tools/build-manifest: 0
/workspaces/forensic_audit_20260115_081333/proof/05_TOOLING/tools/hash-chain: 0
```

---

## Admits List

```
```

---

## Unsafe Audit

```
./03_PROTO/crates/teras-lang-lexer/src/lexer.rs:379:            "unsafe" => TokenKind::KwUnsafe,
./03_PROTO/crates/teras-lang-lexer/src/lib.rs:9:#![forbid(unsafe_code)]
./03_PROTO/crates/terasc/src/main.rs:7:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-lang-types/src/lib.rs:2:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-core/src/zeroize.rs:41:        unsafe {
./05_TOOLING/crates/teras-core/src/zeroize.rs:80:                    unsafe {
./05_TOOLING/crates/teras-core/src/crypto/ed25519.rs:86:        unsafe { &*(self.public_key.as_ptr() as *const Ed25519VerifyingKey) }
./05_TOOLING/crates/teras-core/src/lib.rs:33:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-verify/src/main.rs:14:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-lang-codegen/src/lib.rs:2:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-lang-parser/src/lib.rs:2:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-lang-lexer/src/lib.rs:2:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-effect/src/lib.rs:2:#![forbid(unsafe_code)]
./05_TOOLING/crates/teras-build/src/main.rs:16:#![forbid(unsafe_code)]
./05_TOOLING/tools/artifact-sign/src/main.rs:14:#![forbid(unsafe_code)]
./05_TOOLING/tools/build-manifest/src/main.rs:16:#![forbid(unsafe_code)]
```

---

## Dependency Audit

```
DEPENDENCY AUDIT REPORT
=======================

=== ./03_PROTO/crates/teras-lang-types/Cargo.toml ===

Dependencies:
[dependencies]

Dev-dependencies:

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-codegen/Cargo.toml ===

Dependencies:
[dependencies]

Dev-dependencies:

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-parser/Cargo.toml ===

Dependencies:
[dependencies]
teras-lang-lexer.workspace = true
teras-lang-types.workspace = true


Dev-dependencies:
[dev-dependencies]

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-lexer/Cargo.toml ===

Dependencies:
[dependencies]
# No dependencies (Law 8)


Dev-dependencies:
[dev-dependencies]

Build-dependencies:

=== ./03_PROTO/crates/teras-lang-typechecker/Cargo.toml ===

Dependencies:
[dependencies]
teras-lang-types = { path = "../teras-lang-types" }

Dev-dependencies:

Build-dependencies:

=== ./03_PROTO/crates/terasc/Cargo.toml ===

Dependencies:
[dependencies]
teras-lang-parser = { path = "../teras-lang-parser" }
teras-lang-typechecker = { path = "../teras-lang-typechecker" }
teras-lang-types = { path = "../teras-lang-types" }
anyhow = "1.0"

Dev-dependencies:

Build-dependencies:

=== ./03_PROTO/Cargo.toml ===

Dependencies:

Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/teras-lang-types/Cargo.toml ===

Dependencies:
[dependencies]
teras-core.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/teras-core/Cargo.toml ===

Dependencies:
[dependencies]
# ZERO runtime dependencies per Law 8


Dev-dependencies:
[dev-dependencies]
proptest.workspace = true


Build-dependencies:

=== ./05_TOOLING/crates/teras-verify/Cargo.toml ===

Dependencies:
[dependencies]
clap.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/teras-lang-codegen/Cargo.toml ===

Dependencies:
[dependencies]
teras-core.workspace = true
teras-lang-types.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/teras-lang-parser/Cargo.toml ===

Dependencies:
[dependencies]
teras-core.workspace = true
teras-lang-lexer.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/teras-lang-lexer/Cargo.toml ===

Dependencies:
[dependencies]
teras-core.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/teras-effect/Cargo.toml ===

Dependencies:
[dependencies]
teras-core.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/terasc/Cargo.toml ===

Dependencies:
[dependencies]
teras-core.workspace = true
teras-lang-lexer.workspace = true
teras-lang-parser.workspace = true
teras-lang-types.workspace = true
teras-lang-codegen.workspace = true
clap.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/crates/teras-build/Cargo.toml ===

Dependencies:
[dependencies]
clap.workspace = true
serde.workspace = true
serde_json.workspace = true
toml.workspace = true
tokio.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/Cargo.toml ===

Dependencies:

Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/tools/artifact-sign/Cargo.toml ===

Dependencies:
[dependencies]
clap.workspace = true


Dev-dependencies:

Build-dependencies:

=== ./05_TOOLING/tools/hash-chain/Cargo.toml ===

Dependencies:
[dependencies]
# CLI
clap = { workspace = true }

# Serialization
serde = { workspace = true }
serde_json = { workspace = true }

# Cryptography
sha2 = { workspace = true }

# Time
chrono = { workspace = true }


Dev-dependencies:
[dev-dependencies]
tempfile = "3.10"


Build-dependencies:

=== ./05_TOOLING/tools/build-manifest/Cargo.toml ===

Dependencies:
[dependencies]
clap.workspace = true
serde.workspace = true
serde_json.workspace = true
sha2.workspace = true
chrono.workspace = true


Dev-dependencies:

Build-dependencies:

```

---

## TODO Audit

```
./03_PROTO/crates/teras-lang-lexer/src/lexer.rs:308:                    return Ok(TokenKind::LiteralInt(s, None)); // TODO: Suffix
./03_PROTO/crates/teras-lang-typechecker/src/lib.rs:184:            // TODO: Validate payload type matches effect definition?
./05_TOOLING/crates/teras-core/src/constant_time.rs:93:    // TODO: Implement proper bitwise selection
./05_TOOLING/crates/teras-core/src/crypto/ed25519.rs:58:        // TODO: Implement proper Ed25519 key derivation
./05_TOOLING/crates/teras-core/src/crypto/ed25519.rs:104:        // TODO: Implement Ed25519 signing
./05_TOOLING/crates/teras-core/src/crypto/ed25519.rs:146:        // TODO: Validate that the point is on the curve
./05_TOOLING/crates/teras-core/src/crypto/ed25519.rs:167:        // TODO: Implement Ed25519 verification
./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs:81:        // TODO: Validate secret key
./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs:102:        // TODO: Implement ML-DSA signing
./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs:131:        // TODO: Implement hedged signing
./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs:171:        // TODO: Validate public key
./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs:190:        // TODO: Implement ML-DSA verification
./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs:226:        // TODO: Implement ML-DSA key generation
./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs:446:        // TODO: Add actual NIST test vectors when implementing
./05_TOOLING/crates/teras-core/src/crypto/x25519.rs:45:        // TODO: Implement proper X25519 key generation
./05_TOOLING/crates/teras-core/src/crypto/x25519.rs:85:        // TODO: Implement X25519 scalar multiplication
./05_TOOLING/crates/teras-core/src/crypto/x25519.rs:118:    // TODO: Implement X25519 function
./05_TOOLING/crates/teras-core/src/crypto/x25519.rs:131:    // TODO: Implement X25519 basepoint multiplication
./05_TOOLING/crates/teras-core/src/crypto/hybrid.rs:338:        // TODO: Validate both public keys
./05_TOOLING/crates/teras-core/src/crypto/ml_kem.rs:73:        // TODO: Validate public key
./05_TOOLING/crates/teras-core/src/crypto/ml_kem.rs:94:        // TODO: Implement ML-KEM encapsulation
./05_TOOLING/crates/teras-core/src/crypto/ml_kem.rs:119:        // TODO: Validate secret key
./05_TOOLING/crates/teras-core/src/crypto/ml_kem.rs:140:        // TODO: Implement ML-KEM decapsulation (FO transform)
./05_TOOLING/crates/teras-core/src/crypto/ml_kem.rs:189:        // TODO: Implement ML-KEM key generation
./05_TOOLING/crates/teras-core/src/crypto/ml_kem.rs:385:        // TODO: Add actual NIST test vectors when implementing
./05_TOOLING/crates/teras-verify/src/main.rs:521:    // TODO: Actually compare builds
./05_TOOLING/crates/teras-verify/src/main.rs:829:            // TODO: Integrate GNATprove
./05_TOOLING/crates/teras-verify/src/main.rs:840:            // TODO: Implement mutation testing
./05_TOOLING/crates/teras-build/src/main.rs:414:            // TODO: Actually compile with stage 0 when TERAS-LANG is ready
./05_TOOLING/crates/teras-build/src/main.rs:433:            // TODO: Actually compile with stage 1 when self-hosting ready
./05_TOOLING/crates/teras-build/src/main.rs:443:                // TODO: Compare binaries when self-hosting ready
./05_TOOLING/crates/teras-build/src/main.rs:471:    // TODO: Integrate with actual HDL toolchain
./05_TOOLING/tools/build-manifest/src/main.rs:426:    // TODO: Parse manifest and verify hashes
./05_TOOLING/tools/build-manifest/src/main.rs:462:    // TODO: Parse and compare
```

---

## File Hashes (SHA-256)

```
9888dc7e5b1b9ff1238a2f30695b957b0a64427d527cacaedfc60ee382fe68c6  ./SESSION_LOG.md
b3393c084c1345e7c5847cc9e935731549aeca4c747061fccf453869f684955a  ./CLAUDE.md
0ff72af372af92407d8e97f17b91317389ea0bdbe5b505bf26de51d552c15e43  ./02_FORMAL/coq/foundations/.Syntax.aux
e06139b99a430dc49ff547adcce626f113e3797181963f1c9a4a477f54ce2177  ./02_FORMAL/coq/foundations/Typing.v
e203305dc3034ebd5a874154b4092504cf988da241318fdfb7fc9e7ce390a6d7  ./02_FORMAL/coq/foundations/Syntax.v
2891e76faf0be4bf4eadc83dfe232d81909c7d744d00f8f980f2f142e133b305  ./02_FORMAL/coq/foundations/Semantics.v
3e2fcb01ef2fe973e4a6197e492a0dae609597855e9f5cbc864af09c5d1e97a2  ./02_FORMAL/coq/effects/EffectGate.v
04dcc2c7040dadfc4d1f43da3bba85af83b1e55270d76e72ad6856d0f4dd2863  ./02_FORMAL/coq/effects/EffectAlgebra.v
300e968a8281f94a00e928c6fc47983680749ec53f9fc346be5822f044c6ba46  ./02_FORMAL/coq/effects/EffectSystem.v
a79092c6b4918469eabfa8c321f8a22e030c2f0ddb1a019a34af1dc4987b0974  ./02_FORMAL/coq/_CoqProject
120f81d16239eb42eff0c0a5fce2915fb7b620c8149de41b46a70cfb38970ab3  ./02_FORMAL/coq/type_system/TypeSafety.v
5168e49c1ef444b7be6d59ed6ca7af899a242d20224f289fffee608921fe0c94  ./02_FORMAL/coq/type_system/Progress.v
11d981ce23e19f8bbd6de969a4ff38bd679c07f5ef2603dccdafb71b2f9573c9  ./02_FORMAL/coq/type_system/Preservation.v
715cef0cf8f9ee55546a79e782fb9f43466666e6ce0a2e8c9b7b474c9adf73c8  ./02_FORMAL/coq/.gitignore
00b1835029aa7961c2676156683bcb93f55df047f0f1940e13aaaae133ca425e  ./02_FORMAL/coq/.lia.cache
3a02734b8b269a7785fea9421a4bd3df61ebe6643919f831a8ac75c19ebc0658  ./02_FORMAL/coq/Makefile
cdd395b380b40b676abf69e0a4151534641524888704d92fa66d67f86133324c  ./02_FORMAL/coq/properties/Composition.v
42754dfea5a924d146272ccd9ea1612095805b67b64335f06c04a1bdc1881b47  ./02_FORMAL/coq/properties/SecurityProperties.v
43744e1901efd4efaac4b5af52a7e5d64e80925e725cec8fd1db436c68727fe7  ./02_FORMAL/coq/properties/NonInterference.v
079f84dc76fa8711fbbc3731a41ccde41cb3323b7ba42a5cc816391f5e0a2578  ./PROGRESS.md
3bc44dd1512973bde2c056a62697a0b6634c5e443455e69e1174710ace684498  ./03_PROTO/crates/teras-lang-types/Cargo.toml
6abdbe9bac8051af391998fc5b9c2b92ed8466c3da3f6e7700a816bd427283a3  ./03_PROTO/crates/teras-lang-types/src/lib.rs
9df04dabbd534b95ca0ae65577320eacbddc2f7de37081cea01bc8b7513b09c8  ./03_PROTO/crates/teras-lang-codegen/Cargo.toml
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./03_PROTO/crates/teras-lang-codegen/src/lib.rs
e85c6debfbf1f13ba7012e9e705d25a083a88ab5c2d56929ffa26fdb481fd4ac  ./03_PROTO/crates/teras-lang-parser/Cargo.toml
ef713a8822186e8d2fa6e9df4da6b015e2d7be48b6a0620fb6b53b54f41bd4aa  ./03_PROTO/crates/teras-lang-parser/src/tests.rs
b1fa0f08740c4c13ce38ea2faf239d56f5a970819c30f4c599dcbb9369664c68  ./03_PROTO/crates/teras-lang-parser/src/lib.rs
d81e154850f0291104c91517378b167dd27048bbf22e9ae3b29b9f7b9a60effe  ./03_PROTO/crates/teras-lang-lexer/Cargo.toml
64ceac789ffce27e3cc994ceccdc8fd0d1eca261aca988b6612d5f0e46a04d61  ./03_PROTO/crates/teras-lang-lexer/src/lexer.rs
8d7f1d56c66bb672f62aedd7a9825d77071c06199a7ba6a9d56e5c60c0e171b6  ./03_PROTO/crates/teras-lang-lexer/src/error.rs
4e1d03bfb28a8ae3942816975e426d46cd2b5598c7f53c13c3e927d360993d49  ./03_PROTO/crates/teras-lang-lexer/src/token.rs
f57f1726400052961178ecb7f1af58e639832a10b01cd4de7f8fd5f780f4b60e  ./03_PROTO/crates/teras-lang-lexer/src/lib.rs
7d15acd948f577c268093be872bea719385b6d9211d1a858fa7947809a3dc83e  ./03_PROTO/crates/teras-lang-typechecker/Cargo.toml
42c388a40be8e12f4ae2af45115eb7cdbc1851f382558ce54d59e77fe3c225d9  ./03_PROTO/crates/teras-lang-typechecker/src/tests.rs
cfcd0063ce712cf5c8d2dd69b8a9e0b7881ff9558cfe602573a6feafbda58173  ./03_PROTO/crates/teras-lang-typechecker/src/lib.rs
37189fada9497fe06e1969325bcd5d005191dd7aa70f906bc8a01bbf76059ddc  ./03_PROTO/crates/terasc/Cargo.toml
8e1d6816a5b2e5bcfa465311647e37c2adf2f1ee42dc1d518fd71d73bf3f6dfc  ./03_PROTO/crates/terasc/src/main.rs
eb95134e700b66ed51bca0b7e1843b4df983aeae0e85cbe48dffecfee120a217  ./03_PROTO/Cargo.toml
393222745fbc3fe1c4ac81e05d4915979041d134fc80cb0a523e0814e98b9591  ./03_PROTO/Cargo.lock
6aabee0318085675cf23cf65e47471c646713461a89edd530d05363540214297  ./RESUMPTION_PROMPT.md
5357ab4f33b4cafe330737f460b9d2f0c34fc1c0ddbdbd53a2d5459444816bdd  ./.gitignore
96e7fb659b88e30923284c6e0de8d51f66cc7062a1a39f469401efd1fea6c53e  ./00_SETUP/SETUP_COMPLETE.marker
3fc7991a49ec2366c5e3cf6cb5704441eb03b0bf9255c827c30a341b20904074  ./00_SETUP/scripts/verify_setup.sh
13bdb55159db37440f523f6a6764709c6f5ca2d25454dd4a8d0e9b691ba824ba  ./00_SETUP/scripts/install_lean.sh
d6c6633ec10ed67acc613217f70db035666cdf1d3bd86b0f0e87420aa599b359  ./00_SETUP/scripts/install_rust.sh
10f404ccdb79a99696f83209f4b821d0299ef98df8c97b5df2dd125254da2c10  ./00_SETUP/scripts/install_coq.sh
dd50620e30253f440296a86cf95c78eecd426885d1b6b954c67e9adce34e08fb  ./06_COORDINATION/MASTER_ATTACK_PLAN.md
1137eac27ff52b3eb974fa2a74a0dbd8dea8f0fef6c600cc3132ede76d8420cb  ./06_COORDINATION/COORDINATION_LOG.md
9526b326def3071ef38f78badfffc0ca02cd67a63666522f268f747e20181a14  ./06_COORDINATION/DECISIONS.md
27dec833b5aa612d727a38e8340b44b3846537df7c9ae8d01d7a7a2ab6dc1f19  ./06_COORDINATION/DEPENDENCY_GRAPH.md
e990bd795ecc3bd4abbb37c9db69f381526e0d321435cba0adcd0415043cc2b0  ./README.md
b72a33cd14f57f38971130f1a249aecadea384e9ad8d46e754d25d65c1bb8a4d  ./04_SPECS/language/.gitkeep
042ecdbcd0cdda2ddbec9bdd92015d1313b55f62d6c43b84357e0542c6cbecb1  ./04_SPECS/README.md
b72a33cd14f57f38971130f1a249aecadea384e9ad8d46e754d25d65c1bb8a4d  ./04_SPECS/effect_gate/.gitkeep
b72a33cd14f57f38971130f1a249aecadea384e9ad8d46e754d25d65c1bb8a4d  ./04_SPECS/products/.gitkeep
219f3f4e5e38fd3cbb27ae0af42348dcdeefd56a688ac25071a429bcf9bd9b49  ./01_RESEARCH/06_DOMAIN_F_MEMORY_SAFETY/RESEARCH_DOMAIN_F_COMPLETE.md
e592911aa14a06274e6db61794f8f39ea3d6d92a855fb0f98df649301a35270c  ./01_RESEARCH/TRACK_F_STATUS_UPDATE_2026-01-03.md
0143c8cc4514c65b014d4804206e842cc3879b1063f35eea60684d6a0f5ff64e  ./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_AUDIT_REPORT.md
cd8c02b65d9e5397333e9c14610a2db113305c41d2b5eba246325f1eaff28f21  ./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_INTEGRATION.md
22881a21eaf82c14257cc328ae944db64e282d63f4a118625585f167db0ad6d4  ./01_RESEARCH/99_SUMMARIES_AND_INTEGRATION/RESEARCH_TRACK_COMPLETE_SUMMARY.md
5e9a9b97f449de2cd5890883a1482f8935ada5c48c5e55bbbf6c2aea439411ad  ./01_RESEARCH/specs/LATS_v1_0_0_ASSESSMENT.md
a9abe5848df11e62553856b27ea0b6cf515053baf8a2406c9645c8925462379b  ./01_RESEARCH/specs/RESEARCH_C03_LABEL_MODELS_DECISION.md
d097f145c0a0ca47d15ef81fcf73e4fb70c93145f58397198ce2ca2c443367b7  ./01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_SURVEY.md
bff05859556c0326266e1d3007a1a828b9c5f491550290e34bbe125d7d1d930d  ./01_RESEARCH/specs/RESEARCH_C02_SECURITY_TYPES_SURVEY.md
7e7df8d839a5e6c86a45e8f0f1b0b24e6e51ed17f585283561a86e5f02ac96ba  ./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_DECISION.md
131c0b15fbaccf93bee6b847580ace459d42245a0cfd99cf29da28abee7ca09a  ./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_DECISION.md
fd29147d314cb07b24661eba07f384d212750eaed133a108ee5d77edb7b7e02a  ./01_RESEARCH/specs/RESEARCH_A01_MLTT_DECISION.md
e2eb2e09c331a4fb0ab36416118afafd25517b1f136a6d3f26ba40239d4fe5be  ./01_RESEARCH/specs/RESEARCH_C06_C10_COMBINED.md
84f79ee8e6c9968e4fae8b78f9eba0a7d6c9098d5132ab8501cf44da08e9372f  ./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_COMPARISON.md
bba910a677cd373fce5523a82c44facb41fedd90293ac71e62de2a3b5c4c2d56  ./01_RESEARCH/specs/VALIDATION-REPORT-A-V01_v1_0_0.md
e0f6df7bf81f97665e31e0c07c1697553f10a81ca33d05e05ec5bccaa79dbdb8  ./01_RESEARCH/specs/RESEARCH_A13_OWNERSHIP_TYPES_SURVEY.md
ea7c85a8fd2fb18e42eb1d7e4f8573bc7cca1b73902df6be0493e36f627c993e  ./01_RESEARCH/specs/RESEARCH_A17_HIGHER_KINDED_TYPES_COMPARISON.md
7de09e7b9dd300b6b561ffe2efb010db79fc877994c56a47a316ccbb9bf8e153  ./01_RESEARCH/specs/RESEARCH_DOMAIN_H_POLICY_LANGUAGES.md
ab6f594b91a99765063bc0f06ab8b28022ce49156cb485385790f3a69573ed3f  ./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_SURVEY__1_.md
186ae6e6be7beb1770f08e28a6d989dbb18561b8fff27544b2946e84e8e16a63  ./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_DECISION.md
78df245d79d19a19bba95fcdffce90e13fbee94a643d81dba5e7834324cc0077  ./01_RESEARCH/specs/RESEARCH_DOMAIN_J_COMPLETE.md
969ebf2a895d019f910701aecef578ae68eebfb133eaa856f7cff359fa901c45  ./01_RESEARCH/specs/RESEARCH_B05_KOKA_COMPARISON.md
38e57bddc220da4619315de10495f378d6a42512a7173df67518b5919b5f5391  ./01_RESEARCH/specs/RESEARCH_DOMAIN_E_COMPLETE.md
5d63c1f3671d9733ad68816833080fedc35841e72f52fabd76e4dcf965a808b3  ./01_RESEARCH/specs/RESEARCH_A04_LINEAR_TYPES_SURVEY.md
07c48ed69d26ec9b2038c7fd13a03527ac5e4db2b65d852cecc5134a15d76f49  ./01_RESEARCH/specs/RESEARCH_A07_SESSION_TYPES_DECISION.md
cb6a4f106274016fa66dfd9760e87561bd6d8bbe403644651549c6e5ee7b9928  ./01_RESEARCH/specs/RESEARCH_TRACK_AUDIT_REPORT.md
fcc39d4b9f7c563f5192230911f163d3631dfb5f956c8a9546cd10f300ad120a  ./01_RESEARCH/specs/RESEARCH_B03_COEFFECTS_SURVEY.md
5da399fee93f16152018b0544ccb56c71959ad86913b98df6f05b4a91dee5c57  ./01_RESEARCH/specs/RESEARCH_C03_LABEL_MODELS_SURVEY.md
47f0aabcdf7a563710e458645e4687447240bc6dfa5457880a078a355eff42a2  ./01_RESEARCH/specs/RESEARCH_A14_CAPABILITY_TYPES_DECISION.md
d3a4bbda3e765da39c592191abbb9167052ade47dbd3e8226d419f5a858b46e6  ./01_RESEARCH/specs/RESEARCH_B09_EFFECT_SUBTYPING_SURVEY.md
3ad4ee223bda02440de45b595a93e82507fcbe1475fcfd6ed543053dafaf9b16  ./01_RESEARCH/specs/RESEARCH_A15_STAGED_TYPES_DECISION.md
351bb114ba8ad0b047acc9b8424c6267ce641ad7a45b1d92749f99e8a6a8441c  ./01_RESEARCH/specs/RESEARCH_B02_MONADIC_EFFECTS_SURVEY.md
4da1d2b06d0206db1d0b979d97a38318f2535282ff4b2e62bd4187a6f83310f2  ./01_RESEARCH/specs/RESEARCH_A16_SIZED_TYPES_COMPARISON.md
737d3a515f05d0eb2bd23cfddec81cdb2f617d6f681afdd147e9f7a900e7c5cb  ./01_RESEARCH/specs/TERAS_DEFINITIVE_PLAN_v1_0_0.md
2ae286915c1b6646fb195c342aab6c55827e18110011a45abfc9d1159cca5b56  ./01_RESEARCH/specs/RESEARCH_B06_FRANK_EFFEKT_COMPARISON.md
fe666c2bbfc3bafb336a838bbfaa4bb4b2a8d405827147267a1c153e55e787d7  ./01_RESEARCH/specs/RESEARCH_A01_MLTT_SURVEY.md
394ac9b378084f63c326382842df6e789b8215702d7208ef597ce3edd5744fb4  ./01_RESEARCH/specs/TERAS_GAP_ELIMINATION_ADDENDUM_v1_0_0.md
d56574b36282bb2e95cd3ecebb4e3a6801949bd8da183d517f173fba6aadddaa  ./01_RESEARCH/specs/RESEARCH_DOMAIN_M_COMPLETE.md
5c2dc49759737d0b333a930230047919dec647078686b937947fad2dab9674b2  ./01_RESEARCH/specs/TERAS_PHASE_A_BOOT_TRUE_BOOTSTRAP_v1_0_0.md
54f6d546bf7b836f91747c633a55fa3161e03ba54c08fb387d10dc59f0cc38f0  ./01_RESEARCH/specs/RESEARCH_DOMAIN_O_COMPLETE.md
a31645559ef89c4e7f95cddfa0ab38df823183a28eed47f050ed148edcb4aa5d  ./01_RESEARCH/specs/RESEARCH_B08_EFFECT_INFERENCE_SURVEY.md
6a875f4bb0a12c6e1f7428400b94901bab8992d56ba6bf0daa2d6472f93f3636  ./01_RESEARCH/specs/RESEARCH_A19_TYPE_INFERENCE_DECISION.md
55be9ee38501c8274f98022da07c371c49a48af51c23083e688ac5c01bdff118  ./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_SURVEY.md
8c93f85e416dd4651276c386e6286f4fcc63b3a2da48a124dbecf00b973af1e8  ./01_RESEARCH/specs/RESEARCH_A16_ROW_TYPES_COMPARISON.md
48102a35c67a47477a62686f4975fb47f22e02bba4f4c530340e92548ca08fe1  ./01_RESEARCH/specs/RESEARCH_B02_MONADIC_EFFECTS_COMPARISON.md
69c5efc4bf44708e2845b162f87e6cec6ec2462f048772e27d1017800d179f4d  ./01_RESEARCH/specs/RESEARCH_B10_EFFECTS_PRACTICE_DECISION.md
cd077fb7c1384b239f4dd58bb3dbd9d68f7c9083510349a9d42674f3e7ab5e02  ./01_RESEARCH/specs/RESEARCH_C02_SECURITY_TYPES_DECISION.md
702b54f1149837c1bf6b6af9d6202a8b16b6a3f85801f5f0f67ddb294e967443  ./01_RESEARCH/specs/RESEARCH_B04_EFFECT_HANDLERS_DECISION.md
45b099ff5c8923c7c099b2adc741f61e88e545f2c411fd1605fbad4486504115  ./01_RESEARCH/specs/RESEARCH_A11_EFFECT_TYPES_DECISION.md
4645fe52e88d9b3563dfe5ef962488f3d1775ea3f44f7db500109d31fedc022c  ./01_RESEARCH/specs/RESEARCH_A19_TYPE_INFERENCE_SURVEY.md
6bacc7d6b084a62758d41dbaaa7c09880ed3a91fd231f73dbef3f7063c214440  ./01_RESEARCH/specs/RESEARCH_A17_ROW_TYPES_SURVEY.md
1979d821a512930212164d927eddb148fd78e88d6ece6b4bba0c37073e8c86e2  ./01_RESEARCH/specs/RESEARCH_A10_GRADUAL_TYPES_SURVEY.md
b2d06ffbe65f24771b4f81368332302014d054825ceecbaedde137a2cc4a3f9e  ./01_RESEARCH/specs/RESEARCH_TRACK_INTEGRATION.md
eae3aa9b22b74154cc817673bd2d6d578a32f7d848f8017fc081b0e5e9578913  ./01_RESEARCH/specs/RESEARCH_C04_DECLASSIFICATION_SURVEY.md
81fa517f465ed7dfbbcfa8ce3ef2d7b7087fcb03496c067128818e017befbfc4  ./01_RESEARCH/specs/RESEARCH_A13_OWNERSHIP_TYPES_DECISION.md
85b0db281ab385a5909727e5e5bfb41c80c20d2b7b7d01788141ef45bd80af86  ./01_RESEARCH/specs/TERAS_MASTER_ARCHITECTURE_v3_2_2_CONSOLIDATED.md
939152e14b759d28ac4549e8281230fbee1678c68e57f3358be7760ae83661b4  ./01_RESEARCH/specs/RESEARCH_DOMAIN_Q_COMPLETE.md
a2d146e689a601df2aa31a72c3134a974c1dbfdf6cf8c3aab8958010d1b8eeef  ./01_RESEARCH/specs/RESEARCH_A20_TYPE_SOUNDNESS_SURVEY.md
a129ce513eef07334790c0936fbcfef4237d6c7f214f0011c5014e60fb26fdbf  ./01_RESEARCH/specs/RESEARCH_C04_C05_COMBINED.md
952e608b02ab92d9e1c5ccd5078f29ab04cfd80023c4f1c40970515d4187ffb1  ./01_RESEARCH/specs/CTSS_v1_0_1.md
7a8b4657d2ada8f4ffd799ea6eb2e77860d9dec3a89f27ba22597b5897c4b11e  ./01_RESEARCH/specs/TRACK_A_SEAMLESS_CONTINUATION_PROTOCOL_v1_0_0.md
dc8196e982f8ae4d739e2222f83d741ac7f12be7e7e2ceb67180b408b8862f81  ./01_RESEARCH/specs/RESEARCH_DOMAIN_D_HARDWARE_SECURITY.md
6e46b442e8f9b7ccf90264e58e3f69be071c239a29889b9c5cdcc612a6d28020  ./01_RESEARCH/specs/RESEARCH_DOMAIN_G_COMPLETE.md
d09c8545fe4b2d2106300000c44d827a6da8fd04d01e7e9357c93d216508053f  ./01_RESEARCH/specs/RESEARCH_A19_TYPE_INFERENCE_COMPARISON.md
58d081022490586dad1357d72df39a2d1ffc3e0f994cbb508cd80948e5aefb36  ./01_RESEARCH/specs/RESEARCH_A20_TYPE_SOUNDNESS_DECISION.md
1cd20e5e0ea7bbf463e3b45310dbf619a9c34927d52bf85fc41d89f0546d5ecf  ./01_RESEARCH/specs/RESEARCH_DOMAIN_N_COMPLETE.md
7ac411ceec9c8d7a7a36059219b4367f1e3ffab8ba664ab9c9a9559b6e687bfb  ./01_RESEARCH/specs/RESEARCH_B04_EFFECT_HANDLERS_SURVEY.md
1d435b1c23c681afa461ed2f119abfb7e7368ffc6350ceb79970c8615e71f405  ./01_RESEARCH/specs/RESEARCH_B07_ROW_EFFECTS_COMPARISON_DECISION.md
857c8f0b11d818f195acfd581758be6017c0722e6aa21538bbcff2a39102261d  ./01_RESEARCH/specs/RESEARCH_B01_ALGEBRAIC_EFFECTS_COMPARISON.md
f679b4d370d23b0d15f87f5669fdde375d67140a9cb7a81a6c34344fb7b68324  ./01_RESEARCH/specs/TERAS_HASH_CHAIN.md
22f613f4cb41dd6a4077ee770ab7a7e2fdc0100d72c06e06404a7e7088d70ec4  ./01_RESEARCH/specs/RESEARCH_A12_REGION_TYPES_DECISION.md
38af9561e258bbc9dbcc5851e06059997efdc612a8c4e1e7bad41e0705809f25  ./01_RESEARCH/specs/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_SURVEY.md
16a7da8cf81d699bba168a0a2e76acb35363cb0053f9db8325f38eed95faf5ef  ./01_RESEARCH/specs/RESEARCH_A17_HIGHER_KINDED_TYPES_SURVEY.md
a9dc1007de99db3116a8235b5d8232a5207b1fd947a9baa670cd59f16b7db9e2  ./01_RESEARCH/specs/TERAS_PHASE_A_ALL_PROMPTS_v2_0_0.md
25be5664c7b4961d20272ff37fcf659b7bc4cdbb9a12ec7271fa93f6809cd8af  ./01_RESEARCH/specs/RESEARCH_A08_DEPENDENT_TYPES_COMPARISON.md
b50599682a783218f0729bb176a1c818f314aef820ca2b3d1e9e3aa0534e1a24  ./01_RESEARCH/specs/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_COMPARISON.md
03546e6b4cf4230766bd36681ee6b29923381abf9ad00d3b088fc67d4ecd30cb  ./01_RESEARCH/specs/RESEARCH_A11_EFFECT_TYPES_SURVEY.md
927a2e550347157e4151014ca9cc30958c6d0c4fe1c38228f0928ad806d287f3  ./01_RESEARCH/specs/TERAS-LANG-LEXER-SPEC_v1_0_0.md
f5f0da415f4b3180aa90ecb6c138cd7f14362c40e55b226f0702102a84747c87  ./01_RESEARCH/specs/RESEARCH_B04_EFFECT_HANDLERS_COMPARISON.md
e69e9acb652d5a10dbd2e9cd0bfad9bcf19bb1a98cf24b5542c06e0a6e4573ca  ./01_RESEARCH/specs/RESEARCH_A11_EFFECT_TYPES_COMPARISON.md
e5c1c2bbd89baef4eee4e274105dd1f33061ce60875a05f0172317ab98542ca3  ./01_RESEARCH/specs/RESEARCH_A16_SIZED_TYPES_DECISION.md
40ee8aa922eea859afdf65df5fb1a0ab7228ec4069f25e05edd56d29f751eeeb  ./01_RESEARCH/specs/RESEARCH_A02_COC_CIC_COMPARISON.md
1991e78cd64dd1778e9182592160ba4e07a5ab586d1fcd2717f83ddd6fd2b37c  ./01_RESEARCH/specs/RESEARCH_DOMAIN_G_SIDE_CHANNEL.md
ffbfa0a2c8780b67c01e2985652fe54dcde611f5798c58bfcc9df9855e2d55ab  ./01_RESEARCH/specs/TERAS-LANG-GRAMMAR-STMT_v1_0_0.md
00059ac6a9b13348530c9f14aa1b8e6bc8c272ce6bf74ae17f06b5dd3ba2fd25  ./01_RESEARCH/specs/RESEARCH_A04_LINEAR_TYPES_COMPARISON.md
c1fc756625f03bdd417aea88733228171be1d9170a4617587847e74416a6e25e  ./01_RESEARCH/specs/RESEARCH_B07_ROW_EFFECTS_SURVEY.md
e2dd32ecc22a16b6b57fd0eab7e8bf5d728ca7df8f0f0c2c5a8c25f3e1be17c7  ./01_RESEARCH/specs/RESEARCH_A07_SESSION_TYPES_SURVEY.md
8c93f85e416dd4651276c386e6286f4fcc63b3a2da48a124dbecf00b973af1e8  ./01_RESEARCH/specs/RESEARCH_A17_ROW_TYPES_COMPARISON.md
bf7a1934f72d4953dbe734ac8505221eb16b08847b92e61a7f6601cfe0526bad  ./01_RESEARCH/specs/RESEARCH_B05_KOKA_SURVEY__1_.md
ab6f594b91a99765063bc0f06ab8b28022ce49156cb485385790f3a69573ed3f  ./01_RESEARCH/specs/RESEARCH_C01_IFC_FOUNDATIONS_SURVEY.md
5b8f291565c1e3de80788afc37ed4df9d4adf483201fe18c9f67582d6651a255  ./01_RESEARCH/specs/RESEARCH_B10_EFFECTS_PRACTICE_SURVEY.md
71f24db06dc0d17ee65e45cc0d37606f9059cfea313ec4e0a5de3f47fdb0b6e3  ./01_RESEARCH/specs/TERAS-LANG-GRAMMAR-EXPR_v1_0_0.md
7fd34f92d3576e7655cca0ce402b91da5b3982eb4e9b583296187b3a7008640b  ./01_RESEARCH/specs/teras-lang-foundation-v0_3_1.md
d98d3bf43e448005fd1c08edf682bc03cdc96069dfa88d45b97cfff3f25f569a  ./01_RESEARCH/specs/RESEARCH_A04_LINEAR_TYPES_DECISION.md
ac400eb28489b0e5825aba6ed0575ae788fb263e4230f4b3766c04f2bb8bf686  ./01_RESEARCH/specs/RESEARCH_A18_HIGHER_KINDED_TYPES_DECISION.md
ef4226df82f5bf0eecae8eb68954e3efe3e2e36d0ad4ec3b04f133135f058419  ./01_RESEARCH/specs/RESEARCH_B09_EFFECT_SUBTYPING_COMPARISON_DECISION.md
a4a351dd9c1a1465cb3f5211e8bc6eaced598a0fc7ab85e58d2c64d0291dc834  ./01_RESEARCH/specs/RESEARCH_A15_STAGED_TYPES_COMPARISON.md
4098b10e649d3bf716463d499fca7d72b5bf2c630843c7d93e9fc0029c175b12  ./01_RESEARCH/specs/RESEARCH_DOMAIN_I_COMPLETE.md
403b8df80a27c6de7da207190fb75cea714d7d1c14105968ac0a62768b103edb  ./01_RESEARCH/specs/RESEARCH_A01_MLTT_COMPARISON.md
51b151eeac638751454f2bd5443b505ee53bda0e17d6ffc7ad0ca27d1670305b  ./01_RESEARCH/specs/RESEARCH_DOMAIN_K_COMPLETE.md
fb9687bb8a284390185f299c4554e75297cdd529bb580146eab6c8af63fb3331  ./01_RESEARCH/specs/RESEARCH_A08_DEPENDENT_TYPES_SURVEY.md
95188f053453790019473ea3704a1b368342db09c1c8590bc46b705c855a681b  ./01_RESEARCH/specs/RESEARCH_A10_GRADUAL_TYPES_DECISION.md
95a5c3b18d57d3002cac14d504a8017103a18692231b3e5e4758c8cfb47df93e  ./01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_COMPARISON.md
d24e189cbcd052c654f4bb6663a69c6971f4f7774629163b120da71163a4db25  ./01_RESEARCH/specs/RESEARCH_A10_GRADUAL_TYPES_COMPARISON.md
9d323e6e52b53b7c9cf140671af350d7cd923db4f1f17c40fd39efcd3c4ba5a0  ./01_RESEARCH/specs/RESEARCH_B01_ALGEBRAIC_EFFECTS_SURVEY.md
4b6daceb78d7a6c03876004a261d397f826fe545b8dbb9c9b785239a3e1004ba  ./01_RESEARCH/specs/RESEARCH_B08_EFFECT_INFERENCE_COMPARISON_DECISION.md
6140fdd8869fc543b4da99b0cc68c75bf0ac4f7d6aa4d4bd08f6a7a583b81f34  ./01_RESEARCH/specs/RESEARCH_A02_COC_CIC_SURVEY.md
cdbcfdecb82b1102c9f3ab23ea824ce33506799931a0d33cf0bf38dc852bf6a4  ./01_RESEARCH/specs/RESEARCH_A03_HOTT_CUBICAL_DECISION.md
dc0413def5b387a9a04934e0583608fe0ba55d5b0f8141d0c95fe6b79685f44f  ./01_RESEARCH/specs/TRACK_A_COMPLETION_GAP_ANALYSIS_v1_0_0.md
db8eedaa0bf7dd66ee763a71b47257425c7a89210eba22fbc5870c3abc0cb07e  ./01_RESEARCH/specs/RESEARCH_DOMAIN_L_COMPLETE.md
ae0667c77097b5c73bb3bb8eba226e6329da4fbd99c56e39360c514e8bf0530d  ./01_RESEARCH/specs/RESEARCH_A06_UNIQUENESS_TYPES_SURVEY.md
6bacc7d6b084a62758d41dbaaa7c09880ed3a91fd231f73dbef3f7063c214440  ./01_RESEARCH/specs/RESEARCH_A16_ROW_TYPES_SURVEY.md
deb00a410545bf36e1bba78629c8cbd98d22f0be5666fa7a4974f621f3fc5398  ./01_RESEARCH/specs/RESEARCH_A20_TYPE_SOUNDNESS_COMPARISON.md
1527f3ae875c83584ac9df8054b87c78c1d4dc464535f712d76df09a9de7e4b9  ./01_RESEARCH/specs/TERAS_PROGRESS.md
7dca932e10a1270793fb87a5683ddfa831788f1b804410f8097289811b34cb76  ./01_RESEARCH/specs/RESEARCH_B06_FRANK_EFFEKT_DECISION.md
ac400eb28489b0e5825aba6ed0575ae788fb263e4230f4b3766c04f2bb8bf686  ./01_RESEARCH/specs/RESEARCH_A17_HIGHER_KINDED_TYPES_DECISION.md
2cbd6cd2c16c1e3ce2016c5df4f8f384eaa7607a176bb09c1029007c15076ff3  ./01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_DECISION.md
6682b2c3f49d1fe542918183fb00d29898260bf7a1da358f8d4ee12ab81abbe1  ./01_RESEARCH/specs/RESEARCH_A16_SIZED_TYPES_SURVEY.md
eddb8ab3527296d1d3464a3bf8581fa791e2daa3e3198120cbc409c8bd4e3c23  ./01_RESEARCH/specs/RESEARCH_A12_REGION_TYPES_COMPARISON.md
ea2261fc72ab6cffdfd82a532bff971b738270a9d0d42453135f3d5466253275  ./01_RESEARCH/specs/RESEARCH_B01_ALGEBRAIC_EFFECTS_DECISION.md
bbd9b75845401b537599d566a06297b8ab5414f747473b151e3e943455272a14  ./01_RESEARCH/specs/RESEARCH_B10_EFFECTS_PRACTICE_COMPARISON_DECISION.md
69c57d1fb8ece1aa35b270fbfebf943ad6d2361bdac4221e9837df6ee4c8a0cd  ./01_RESEARCH/specs/TERAS_COORDINATION_LOG_v1_0_0.md
6f3c44c7233fd0af4068714bd2f9efe4aa7966982b9b4ab03c420fee23d9d5b5  ./01_RESEARCH/specs/RESEARCH_A15_STAGED_TYPES_SURVEY.md
6ce91a0d0df5a9cd281966b978564d483eedf8493bda89dec89c2f736e7a9ed1  ./01_RESEARCH/specs/RESEARCH_TRACK_COMPLETE_SUMMARY.md
bc4a42c09dab55af4a540554e0b8e24e930b54704340d8475d7fe4e321f30d9c  ./01_RESEARCH/specs/RESEARCH_A06_UNIQUENESS_TYPES_DECISION.md
14bfcc2ed8a0d1ae76722a60e6c42547cb7894be2d135d577557d240dc6f6017  ./01_RESEARCH/specs/RESEARCH_A16_ROW_TYPES_DECISION.md
6b35c0d0406daf4b3a78b9f988055522e1ece8f806cac2ce0e32c0b9b076053a  ./01_RESEARCH/specs/RESEARCH_DOMAIN_P_COMPLETE.md
96532b1e0e1c9cc37e147aaf632f730ee1d094ecdf167e67decc840ca3905924  ./01_RESEARCH/specs/RESEARCH_DOMAIN_I_OS_SECURITY.md
9cb6ab6824cc798e80e532c12cf7e4a84b1e3d3342adf9f195a3115a29cf29fa  ./01_RESEARCH/specs/RESEARCH_DOMAIN_L_ATTACK_RESEARCH.md
72f4e858fc5ce4b141d1d667faac89220ca26ad95596c24f6ab28ad933cb6e8a  ./01_RESEARCH/specs/RESEARCH_A02_COC_CIC_DECISION.md
f03db4f498ae125c05057d54283cdb6def8e33949bc4e1744220a2bda238b13b  ./01_RESEARCH/specs/RESEARCH_DOMAIN_D_COMPLETE.md
b4ffff18245f6c8e4933a44b9cd596d24ceb888281cfb6e89b084b54cc35eec8  ./01_RESEARCH/specs/RESEARCH_B06_FRANK_EFFEKT_SURVEY.md
36b09e9ad97b936fc34649a2a5c9863160688fd5648f0e051f80c68ec203fd82  ./01_RESEARCH/specs/RESEARCH_DOMAIN_H_COMPLETE.md
b7d9e2132cab9fb02c06f802dcea93c53133b74d4af80673c9461ed3ac6b5d1f  ./01_RESEARCH/specs/RESEARCH_A13_OWNERSHIP_TYPES_COMPARISON.md
13bd1b8c194e9076bfe849d03625c7bbacaadd1c3a354b4a65e5493a153c2ca4  ./01_RESEARCH/specs/RESEARCH_A17_TYPE_INFERENCE_SURVEY.md
16a7da8cf81d699bba168a0a2e76acb35363cb0053f9db8325f38eed95faf5ef  ./01_RESEARCH/specs/RESEARCH_A18_HIGHER_KINDED_TYPES_SURVEY.md
5a63258d44692e4813dbbb7ab5b0cd0f03fe9c0c84ba33e25233ce260566de2f  ./01_RESEARCH/specs/RESEARCH_A08_DEPENDENT_TYPES_DECISION.md
20fe004cb27e9e5691d3d7a6f686cbe2df7f8b95b982bd68cb2f5a8767636a9c  ./01_RESEARCH/specs/RESEARCH_A09_DEPENDENT_TYPES_COMPARISON.md
a53163406b9b96ffe9e699770ccb235786d2e821c5f5d13a8af6cecc9215a2c7  ./01_RESEARCH/specs/RESEARCH_DOMAIN_F_COMPLETE.md
0cd7e0a891c76a1554c7b37809ee9d01ab2df5a55e80b2453ec1903c352a5712  ./01_RESEARCH/specs/RESEARCH_A14_CAPABILITY_TYPES_COMPARISON.md
eb160fadfb6704fd17d5e238dd42dc39216653fbe96ad06438737746773e75ae  ./01_RESEARCH/specs/RESEARCH_B05_KOKA_DECISION.md
0a93790b702263bd9012e5982786da8bd5dd685f485fcbabc7e6562f8c26a698  ./01_RESEARCH/specs/TERAS_RESEARCH_SCOPE_FINAL_LOCKED.md
107557a2f9081ed4a70463919ac3c7e6d67d6be2066af1f943b4d915e51e0473  ./01_RESEARCH/specs/RESEARCH_A08_REFINEMENT_TYPES_SURVEY.md
bf7a1934f72d4953dbe734ac8505221eb16b08847b92e61a7f6601cfe0526bad  ./01_RESEARCH/specs/RESEARCH_B05_KOKA_SURVEY.md
ea7c85a8fd2fb18e42eb1d7e4f8573bc7cca1b73902df6be0493e36f627c993e  ./01_RESEARCH/specs/RESEARCH_A18_HIGHER_KINDED_TYPES_COMPARISON.md
cef4c4d368d5391704e6795bcdb11af279d71c5044ca785821229eee0e488eb3  ./01_RESEARCH/specs/TERAS-LANG-GRAMMAR-DECL_v1_0_0.md
ee19a342859e5a844eeee0db738a0002a2fc0933ab6d73659c41f94457746e5f  ./01_RESEARCH/specs/RESEARCH_A14_CAPABILITY_TYPES_SURVEY.md
69c5efc4bf44708e2845b162f87e6cec6ec2462f048772e27d1017800d179f4d  ./01_RESEARCH/specs/RESEARCH_B10_EFFECTS_PRACTICE_DECISION__1_.md
439f87b854f8e31f89ab113e4376914bf032d7d002b0393ace8e1b94d2a5f323  ./01_RESEARCH/specs/RESEARCH_A08_REFINEMENT_TYPES_COMPARISON.md
20135eb7a02104a69ce5b96d76107c2098e3cfc3917c8f88a220e6a622671b41  ./01_RESEARCH/specs/TERAS-LANG-AST_v1_0_0.md
15efdf4893a08bee8ee83f0867d47cb9dec304344c40e5924e4132f4fd0ceac6  ./01_RESEARCH/specs/RESEARCH_A07_SESSION_TYPES_COMPARISON.md
04835517486c3e97b6082ba5d75e0b1bfc853c3cf57d0db391b5a77b81720108  ./01_RESEARCH/specs/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_DECISION.md
14bfcc2ed8a0d1ae76722a60e6c42547cb7894be2d135d577557d240dc6f6017  ./01_RESEARCH/specs/RESEARCH_A17_ROW_TYPES_DECISION.md
68f20270b25bbef22de52c309ffbe3830aa7aa519b118acac67ba157bee92450  ./01_RESEARCH/specs/RESEARCH_A12_REGION_TYPES_SURVEY.md
1bf4c10ca0f7f538129b0179c07fed0b5fe16a6177f76e7b4894e05685af5dd4  ./01_RESEARCH/specs/RESEARCH_A03_HOTT_CUBICAL_COMPARISON.md
9b91c9f084d0068c3383af01999ca64ac2d0a072b1fd88ba84365a9140be1833  ./01_RESEARCH/specs/RESEARCH_A08_REFINEMENT_TYPES_DECISION.md
cf2b3e6812ab2f0b50a58216e58ed7af7de51f0443b2ae628a6cd7e49f3a80e5  ./01_RESEARCH/specs/RESEARCH_A03_HOTT_CUBICAL_SURVEY.md
d2aa29f63f66a16d60a5fd448afa84fa65eeeb1d69622b43ff77d171b01704d1  ./01_RESEARCH/specs/RESEARCH_B02_MONADIC_EFFECTS_DECISION.md
db4c7fd23ad8af3d1b75d901c440e28934d8675555ff7014a5242ebd891d35e1  ./01_RESEARCH/specs/TERAS_MASTER_CONTEXT_v1_0_0.md
a2b88651306895b271c988234dd24a01666ed48fa3078c072a1e4fcebb2f302a  ./01_RESEARCH/15_DOMAIN_O_RUNTIME_EXECUTION/RESEARCH_DOMAIN_O_COMPLETE.md
393a1e6d4c35b9e2ee3982173698667e4f4715b9ee5c1b05b74a0d99dd2f70de  ./01_RESEARCH/09_DOMAIN_I_ERROR_HANDLING_AND_OS_SECURITY/RESEARCH_DOMAIN_I_COMPLETE.md
a9985837f575da3e861b0efe7cd3da1cfa8a152f66d09057c8f312fbbaa0da7f  ./01_RESEARCH/09_DOMAIN_I_ERROR_HANDLING_AND_OS_SECURITY/RESEARCH_DOMAIN_I_OS_SECURITY.md
1f3cced60f8fb1730e955c171074ff15dbe3f1b71cfd69d9505cc3607021e97b  ./01_RESEARCH/TERAS_COORDINATION_LOG_v1_0_2.md
ba8b56023e986b416f5984d02fc300652b39213d9c677da30ca0fab028b5c542  ./01_RESEARCH/05_DOMAIN_E_FORMAL_VERIFICATION/RESEARCH_DOMAIN_E_COMPLETE.md
171c669f91d7cb548473abc4f83706093d2c41cb0d867eb24c75094c334275fc  ./01_RESEARCH/07_DOMAIN_G_CRYPTO_AND_SIDECHANNEL/RESEARCH_DOMAIN_G_COMPLETE.md
e9596d6971d5d63fc87652646b02db300938e58325321f94dfc82a894d4f7c71  ./01_RESEARCH/07_DOMAIN_G_CRYPTO_AND_SIDECHANNEL/RESEARCH_DOMAIN_G_SIDE_CHANNEL.md
1f43cda533a4bd61c3bcfd664652149c567b48b980bde98c047c3fe3dba46a00  ./01_RESEARCH/TRACK_F_COMPLETION_SUMMARY_v1_0_0.md
ee45ad23f7da7d3a94d1be334c6931802faf27c2b6a832c39ce62acf7213ba10  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B03_COEFFECTS_DECISION.md
39759485dd077bf69b37a232ac03ff4c6f45d6a48d75e12fbccadeceedf22adc  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B03_COEFFECTS_COMPARISON.md
969ebf2a895d019f910701aecef578ae68eebfb133eaa856f7cff359fa901c45  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B05_KOKA_COMPARISON.md
df7feef26260eb152b8d91f93393c22048daa917843f1e32e874fbe250c78c40  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B03_COEFFECTS_SURVEY.md
d3a4bbda3e765da39c592191abbb9167052ade47dbd3e8226d419f5a858b46e6  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B09_EFFECT_SUBTYPING_SURVEY.md
567cf0642dcf49cc2cb192f7edfac2f5993c940d2271c2f1e53a9c591e8ada1c  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B02_MONADIC_EFFECTS_SURVEY.md
2c791c714a9c0426337d51ce016095479a0911a9bff8912578b490ec9d7a425e  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B06_FRANK_EFFEKT_COMPARISON.md
91b31d6314d90629bdf4074c1fa4bc5fad42369dcf2bddcf0434167a23cea9fa  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B08_EFFECT_INFERENCE_SURVEY.md
c4891615ed9a039c05db712783dbf448f20ebcf0eb1cc677f17b31e998eec5ec  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B02_MONADIC_EFFECTS_COMPARISON.md
69c5efc4bf44708e2845b162f87e6cec6ec2462f048772e27d1017800d179f4d  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B10_EFFECTS_PRACTICE_DECISION.md
db40a1e7bd895d6ed82cef1bceb0d0ce4c5672896d208cacc68cc648a946657d  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B04_EFFECT_HANDLERS_DECISION.md
3e6ebe6dfc56c5bde11a249e240d2599263ece611940ead8322c0b8c8579be9c  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B04_EFFECT_HANDLERS_SURVEY.md
1d435b1c23c681afa461ed2f119abfb7e7368ffc6350ceb79970c8615e71f405  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B07_ROW_EFFECTS_COMPARISON_DECISION.md
f74ecd860f6e20eff41714ce07d02eb1ccad0324277c893aa319aa38eef756e0  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B01_ALGEBRAIC_EFFECTS_COMPARISON.md
d2e8156a76c4e19b111ae9a7db550e422898c0d77eba397e0ac27ea2418018be  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B04_EFFECT_HANDLERS_COMPARISON.md
08a25d2f6c49505d63de6b9e19b0a6c770092703a4d220b91a5ad0b75b70829b  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B07_ROW_EFFECTS_SURVEY.md
fd78839154574c1cf900d97c344b9e46e3bc07e686f9570da07b8275561c98b9  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B10_EFFECTS_PRACTICE_SURVEY.md
ef4226df82f5bf0eecae8eb68954e3efe3e2e36d0ad4ec3b04f133135f058419  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B09_EFFECT_SUBTYPING_COMPARISON_DECISION.md
02a6a717418ca88afc517cc9fb2663f6b8d0814d7648b547cab3857911bdfc42  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B01_ALGEBRAIC_EFFECTS_SURVEY.md
a14dce2a3d609c8e6fd8286d5324dca3c850431824ba683c2f4b2607f284871d  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B08_EFFECT_INFERENCE_COMPARISON_DECISION.md
37b22496407a0dac8031d93f3678870a3fdd421b101eee7cf3b9e1817a766c51  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B06_FRANK_EFFEKT_DECISION.md
723400a75aedc97069dd3230d9afed604362d97c81f103da7871803373e3f673  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B01_ALGEBRAIC_EFFECTS_DECISION.md
92079c38d092856b84c16a264ea389584412658dd6ff0719f1864c637a65285a  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B10_EFFECTS_PRACTICE_COMPARISON_DECISION.md
5dea1ecb3fb218ad8ff388deac9caddccd1013e61979626204066e5267d9770a  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B06_FRANK_EFFEKT_SURVEY.md
101dd81d86b9e93549c9905d9f7d8ef15e7635d9f420c87c6c09b9304f47bf87  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B05_KOKA_DECISION.md
c122255c60df79cca6843230985ee9634a1b81665a079eee37c1e8ebc2910d04  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B05_KOKA_SURVEY.md
e5316c06646099106b235a82e4dd29d3cc40d6616bfc8dbd72aeb0a505e05be0  ./01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/RESEARCH_B02_MONADIC_EFFECTS_DECISION.md
15d9b3e8a8c36edea2da3fa55bb71a501aa18c3aad05ec05ce4a9943cbb5e821  ./01_RESEARCH/10_DOMAIN_J_MODULE_SYSTEMS/RESEARCH_DOMAIN_J_COMPLETE.md
7536c35cfa38d3fee6bfaf1b6d87d39ff1389a9fc188fba43fe36c858657731a  ./01_RESEARCH/21_DOMAIN_U_RUNTIME_GUARDIAN/RESEARCH_U01_FOUNDATION.md
f71e732db071241344dd3f131546aed012ad250b3aa1c033eead466196257b58  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C03_LABEL_MODELS_DECISION.md
331c348872f55862eeeac8818af840a2985ed2fdf9e2ae5eb7ce7ecb410f5bd0  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C02_SECURITY_TYPES_SURVEY.md
06cc769bea66d2ca82d1708a90838e5de8801cc3df63d3b8a158c6af329a250e  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C06_C10_COMBINED.md
b1d657a63993bdee2ae0ea63d78a73da2d43c9efd01f5fceabf4e2a1296819a3  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C01_IFC_FOUNDATIONS_DECISION.md
17b3eec5da22d45c6f9b93e82a3ab92c255ff4305fcfc9e838222e476c3dabbb  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C03_LABEL_MODELS_SURVEY.md
316cc2aec3a255534d53a7c77a42b799d6c0349038c6635749b08bc202a0f7b9  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C02_SECURITY_TYPES_DECISION.md
08fec50db1e5457fdc58d06bec0cb59cebd114377d9354054004d1b333b1f6d4  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C04_DECLASSIFICATION_SURVEY.md
5fa92bcb32533d9efa42ba219b01076eaa5ca851831fd10460e0bccdc7680b6f  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C04_C05_COMBINED.md
8f2108a9689b875faf534bc437f74de8d64227e88b8778eaa62a0d3c2aef2666  ./01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/RESEARCH_C01_IFC_FOUNDATIONS_SURVEY.md
be77f43dbf64b57baa85425be3ad9a859b648c459906e5035e83659667aee993  ./01_RESEARCH/16_DOMAIN_P_STANDARD_LIBRARY/RESEARCH_DOMAIN_P_COMPLETE.md
e56bdacfa5549dbd347f3460987c2d8762035e22f5cad0de920613839d4c1438  ./01_RESEARCH/04_DOMAIN_D_HARDWARE_AND_CAPABILITY_SECURITY/RESEARCH_DOMAIN_D_HARDWARE_SECURITY.md
102678b9846f94c5ec61dd16efa20e80d88f16cb9cfd00528e9abbdedd644317  ./01_RESEARCH/04_DOMAIN_D_HARDWARE_AND_CAPABILITY_SECURITY/RESEARCH_DOMAIN_D_COMPLETE.md
9af02c225f414d1686d5dde817f8608b230ce22a7639b3552d205b706343ffa5  ./01_RESEARCH/14_DOMAIN_N_TOOLING_IDE/RESEARCH_DOMAIN_N_COMPLETE.md
00472e4a499972721f9b230ab784b509d149ad982bb2716ec6c9dbde5a5297d9  ./01_RESEARCH/20_DOMAIN_T_HERMETIC_BUILD/RESEARCH_T01_FOUNDATION.md
69303996947fafc5b03d78c53f7e22afd4afd1c9fbd19e280cc1a771c44da09d  ./01_RESEARCH/13_DOMAIN_M_TESTING_QA/RESEARCH_DOMAIN_M_COMPLETE.md
6ae6d2e4e8707ab4bb56a65db76964942ddfbc453bb2f17d21e72222c9165f2a  ./01_RESEARCH/11_DOMAIN_K_METAPROGRAMMING_AND_EXISTING_SYSTEMS/RESEARCH_DOMAIN_K_COMPLETE.md
e8f762da35596eb5ff7675616543a52fe9c2d1c3837554e526ecee4c861b16ef  ./01_RESEARCH/11_DOMAIN_K_METAPROGRAMMING_AND_EXISTING_SYSTEMS/RESEARCH_DOMAIN_K_EXISTING_SYSTEMS.md
cadfeb67a61a582d270d754cc7e49662f36b916bc056da7af5c2824f904011e7  ./01_RESEARCH/00_METADATA/SHA256SUMS.txt
d592a3b2323120260ad4d1b19cdaad08284a94883cb14a4c9fd00821a533aa80  ./01_RESEARCH/00_METADATA/README.md
477548c5d990de5cbb86c0cf18d344ed2079e5f8e4d4fb1b81f661de94701125  ./01_RESEARCH/00_METADATA/MANIFEST.md
8a498bd152b224840982e08f700f4796093b4a15ad3aa14e0da02449dff3533f  ./01_RESEARCH/TERAS_COORDINATION_LOG_UPDATED_v1_0_1.md
6174e19865ab943f42c6b8081f4b67aeec07121b3a516316a599eaa637c0cf5e  ./01_RESEARCH/17_DOMAIN_Q_COMPILER_ARCHITECTURE/RESEARCH_DOMAIN_Q_COMPLETE.md
f333684b92b26417ae4aa793ff9b06eb25bef9357f7ec44870933d53dee971ed  ./01_RESEARCH/19_DOMAIN_S_HARDWARE_CONTRACTS/RESEARCH_S01_FOUNDATION.md
375015d9e16c0df828c35769b1ccdca8085f6475dc9213b47687edde4449b6fd  ./01_RESEARCH/18_DOMAIN_R_CERTIFIED_COMPILATION/RESEARCH_R01_FOUNDATION.md
2c66b18ef00e12e8d99accfc9531ac9cefb789d529fef40a04384b7585af0c83  ./01_RESEARCH/12_DOMAIN_L_FFI_AND_ATTACK_RESEARCH/RESEARCH_DOMAIN_L_COMPLETE.md
6911a0d3ed9500db2b31a6f03f985e4ca375e704e0c256dbe07632cc9241b928  ./01_RESEARCH/12_DOMAIN_L_FFI_AND_ATTACK_RESEARCH/RESEARCH_DOMAIN_L_ATTACK_RESEARCH.md
9c3536fc1d8e5ec52b2dec16a08f8a311d6369bc56e9cabb2a1f788020acedf6  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A05_EFFECT_SYSTEMS_SURVEY.md
b713e2e63268634cdd6ac6c4fd3937e46166c6b998d4074bb076fd2a41473847  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_DOMAIN_A_COMPLETE_SUMMARY.md
c041cfa5acc96a0ba18d59ce298e7bd9ed1e67d74bfeb4fb405b8886f1cede60  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A09_DEPENDENT_TYPES_DECISION.md
fd29147d314cb07b24661eba07f384d212750eaed133a108ee5d77edb7b7e02a  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A01_MLTT_DECISION.md
2db4f14fd2678eac01cb5be6dc2d7d7ef459a95dae6ee942b938a1a86afbf9c7  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A13_OWNERSHIP_TYPES_SURVEY.md
ea7c85a8fd2fb18e42eb1d7e4f8573bc7cca1b73902df6be0493e36f627c993e  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A17_HIGHER_KINDED_TYPES_COMPARISON.md
82119be96c5fc54029a5ac3abdf929fb5cbb2a4379e27c77d3ac41f1c89bb945  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A04_LINEAR_TYPES_SURVEY.md
b53458dd2a639d87c9d88c3fdcaedb9097033895dfaf33dd75ee153efcd18e1c  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A07_SESSION_TYPES_DECISION.md
c1a9e35022823a3c30f2d7aaf65729e5d1721c02372f67e9bb664b2207de30e2  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A14_CAPABILITY_TYPES_DECISION.md
e35e57a1470ca1cabe135b6e5f22e505c458aaf6eb8406e816e5f8d94a3bee1d  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A15_STAGED_TYPES_DECISION.md
09dd9e11b8893c8a6f694617af142b168addb2e07250cf3a53de8892d17361d7  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A16_SIZED_TYPES_COMPARISON.md
6c5548dce429a5c68b30d06895bc5efdc1a30cd651b7047fb080166840e21906  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A01_MLTT_SURVEY.md
551f661de424caa0feca79b889d302b177485e1e297a497c8ec512d85865cd7a  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A19_TYPE_INFERENCE_DECISION.md
e4b9ea61111cb211e7428e413203b9202bf0556fb243c96e5d4db9de421d3550  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A09_DEPENDENT_TYPES_SURVEY.md
8c93f85e416dd4651276c386e6286f4fcc63b3a2da48a124dbecf00b973af1e8  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A16_ROW_TYPES_COMPARISON.md
c51f5abe5c2c546fc3f2f6a6111ed017f8a564aabed6f7b75ed814c29dc76a8b  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A06_UNIQUENESS_TYPES_COMPARISON.md
13396490dcbd1409d686914144d86405037bc19e5e8ffe0a7a9af17262349264  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A11_EFFECT_TYPES_DECISION.md
7c7e8904dfbf903231a41413302cb955f27b519f5df0785c9b3e186b1f54b387  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A19_TYPE_INFERENCE_SURVEY.md
4f20e72491a831bab67a8d330c6f311c119b078ac6468922d53dca1aa6bb6022  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A17_ROW_TYPES_SURVEY.md
01075974d74d548ce9cbbc4d9ae4279d9c0b82671015ccaacd53964a889c63ca  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A10_GRADUAL_TYPES_SURVEY.md
7f50cce971e76e35e88651781251cac7762e09eaf765eb5dc4e5dc7e4b76b914  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A13_OWNERSHIP_TYPES_DECISION.md
a0e4d869926ae15c9c49497e5348e1847121e02d32cb79f702c1e75019012cb1  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A20_TYPE_SOUNDNESS_SURVEY.md
bfb5b19603457c78519dc04227556f58af8420ef63448e271e07ecf9f4d88b6c  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A19_TYPE_INFERENCE_COMPARISON.md
2939d3af068e1f069eaaae47a7665eb2dbcf873c1d1b2b93f41ed01d0b168297  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A20_TYPE_SOUNDNESS_DECISION.md
9a705cba545be48aa90db55f8e2348faa23c8f774fa72ef68874bdb66b3be28c  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A12_REGION_TYPES_DECISION.md
6e56113246a35c621b70a16e0313cefb19d42bb2b2ef35f3a7e58f8b048f43ba  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_SURVEY.md
1c9b4cfc95f227a6e2dcc1ff72805d4e8e8a5262b1ab0a5f35f6139717a8ea9a  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A17_HIGHER_KINDED_TYPES_SURVEY.md
54571d3a8e0a032e8d77a20321aa99e70ce9bdf99009c7abae1c9e12f4013ef9  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A08_DEPENDENT_TYPES_COMPARISON.md
6af0cc030c82433bb9c05d2f2fc6e96d41be80268e59b81ef26c20c3d125c310  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_COMPARISON.md
a2d28b0e2c5700acc06104c091fbe17c0ca00647beb8ac90909ab7fc3dd5dd67  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A11_EFFECT_TYPES_SURVEY.md
09e31d984f42d13b03820260ebe6f6bef750c79a164093c6fb55d253acdaa3cf  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A11_EFFECT_TYPES_COMPARISON.md
559aa15b6caab5fdcfef0e66a9bd3c185d3b0c2700486720f5cb2995f2c6b4af  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A16_SIZED_TYPES_DECISION.md
6aa81c5eef6230b1e78d40f05766b34c43e2292fa5f8ad67a7ba45de01702925  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A02_COC_CIC_COMPARISON.md
23bac9b63a5a55fdbd53b7926ba211237ebae3fa9df15b0a63fec8f035527459  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A04_LINEAR_TYPES_COMPARISON.md
c23dbf1f3ab6db097f345c8f5de44aff84915c60419d0c5b7cbb534043639b9f  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A07_SESSION_TYPES_SURVEY.md
8c93f85e416dd4651276c386e6286f4fcc63b3a2da48a124dbecf00b973af1e8  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A17_ROW_TYPES_COMPARISON.md
fe5f1b3f7858c28c2dc319d918e5697096df49fbb1e679ff1717a9da372c3535  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A04_LINEAR_TYPES_DECISION.md
ac400eb28489b0e5825aba6ed0575ae788fb263e4230f4b3766c04f2bb8bf686  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A18_HIGHER_KINDED_TYPES_DECISION.md
c7594efc11a07acd3937ada12f9c81ece100a59429ba3417c5c7a961ddd57a19  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A15_STAGED_TYPES_COMPARISON.md
d3f0c2bddedff9ff04736d08e85e8d226765a7d375ac8a6ab229b0d537635bd1  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A01_MLTT_COMPARISON.md
167a4f82b6dc44cf5b177ab17eb8225e3edd70a34ac52871c85f43caa7d27ecb  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A08_DEPENDENT_TYPES_SURVEY.md
f1306453253ef2989086b9e916df5b5d59ab4f83cb22204d9ac9effe3d186f8d  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A10_GRADUAL_TYPES_DECISION.md
d9e4f721d21e4a5bae4ed40770cb120acec9da4cffcbc3211c433e950eced756  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A05_EFFECT_SYSTEMS_COMPARISON.md
7c9cd4feea09e3aa477c0bcde1d4898cefa5d5bba8fd4e21d4419d525ac916a7  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A10_GRADUAL_TYPES_COMPARISON.md
6140fdd8869fc543b4da99b0cc68c75bf0ac4f7d6aa4d4bd08f6a7a583b81f34  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A02_COC_CIC_SURVEY.md
c791173eddfcbcea85eff200f321a79d37737b160086c3950be66840ef65e7dc  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A03_HOTT_CUBICAL_DECISION.md
10ac19918650c685d1c653f47a0ef7a9124defddec596f0905bdf6e4cba5d34f  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A06_UNIQUENESS_TYPES_SURVEY.md
4f20e72491a831bab67a8d330c6f311c119b078ac6468922d53dca1aa6bb6022  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A16_ROW_TYPES_SURVEY.md
53da0d39ac434b70498ad2ab0f958ccd30e11e6734d6acf557351a7bc2736c4a  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A20_TYPE_SOUNDNESS_COMPARISON.md
ac400eb28489b0e5825aba6ed0575ae788fb263e4230f4b3766c04f2bb8bf686  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A17_HIGHER_KINDED_TYPES_DECISION.md
37f7fa728ec30501bf04b6e5f77b183ee08aad1a56911dbdce0b219b7b29f196  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A05_EFFECT_SYSTEMS_DECISION.md
bd16e933b7d086f585ef00c7ab692b00d31e0820a3b4102363639269d6d26a15  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A16_SIZED_TYPES_SURVEY.md
3d94ef59f934a2d11ed0bcc1430e31e28ad7a26379828053cd7acfda2e3b6310  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A12_REGION_TYPES_COMPARISON.md
e5a9a24a1e0396ec4ca01b75279e33166c555874dd85a28385d75ea0ffa9fefb  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A15_STAGED_TYPES_SURVEY.md
94dfb237686f41700140daf0880990c7af666f5a757865b0dce7ecc2066ca59b  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A06_UNIQUENESS_TYPES_DECISION.md
14bfcc2ed8a0d1ae76722a60e6c42547cb7894be2d135d577557d240dc6f6017  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A16_ROW_TYPES_DECISION.md
72f4e858fc5ce4b141d1d667faac89220ca26ad95596c24f6ab28ad933cb6e8a  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A02_COC_CIC_DECISION.md
769e5331ad6078d2e1598a3f3840a7d7e906cc6125becf43171531090fd28b30  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A13_OWNERSHIP_TYPES_COMPARISON.md
a1adf6c0028469b709580af5ad518e59dc8bbb7a01830e242f6950dde0f9ba7d  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A17_TYPE_INFERENCE_SURVEY.md
1c9b4cfc95f227a6e2dcc1ff72805d4e8e8a5262b1ab0a5f35f6139717a8ea9a  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A18_HIGHER_KINDED_TYPES_SURVEY.md
b04c39f34dfd54f505f87abd76c9dd01b42b4c27bc0311d60a8701fd430a3260  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A08_DEPENDENT_TYPES_DECISION.md
5afcf7d3da7afc74077960249a0f706488df127f15745c097fd4c6f4e09d5468  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A09_DEPENDENT_TYPES_COMPARISON.md
cf4b6d4497a245705dfc877b8c1e6ef9e384e52e0d247fe0349cf5619a004dc9  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A14_CAPABILITY_TYPES_COMPARISON.md
d5f6dd3b672579f3520a3611c59e0b06f3e57b155b724c567bd06d1b097da793  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A08_REFINEMENT_TYPES_SURVEY.md
ea7c85a8fd2fb18e42eb1d7e4f8573bc7cca1b73902df6be0493e36f627c993e  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A18_HIGHER_KINDED_TYPES_COMPARISON.md
514d3859b5a50ad40ef1f9962c2d563b856298d7ff9a6cd93bfb5fc8a2dbd76d  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A14_CAPABILITY_TYPES_SURVEY.md
8a367ccde0fa0166641d015ff344ee7f81b8c37572f26b223eb585fe0595f2a7  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A08_REFINEMENT_TYPES_COMPARISON.md
b57ece6511e84bee360d37fd40c3de1d436355eb5ef41932d24691e1cd75023f  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A07_SESSION_TYPES_COMPARISON.md
99736ff20021b162223a7a6ef5d3d9eb92688d1fdab0c0271049f5abf415895f  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A18_TYPE_LEVEL_COMPUTATION_DECISION.md
14bfcc2ed8a0d1ae76722a60e6c42547cb7894be2d135d577557d240dc6f6017  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A17_ROW_TYPES_DECISION.md
43b586384b81ef68b38bd651484fe6210dae9b5c54a6f95863a0d9f7072e8a71  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A12_REGION_TYPES_SURVEY.md
ea79d14639ede26c49c14f3328bb581b5ca25141768e9c96755408f5e364491a  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A03_HOTT_CUBICAL_COMPARISON.md
b98499ba990bf647e4d239d6c30d04e88c00ce85e1743888a84f1406b2926c64  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A08_REFINEMENT_TYPES_DECISION.md
6381a937e7552cc3402a4bff17a4219a7daaf9f782d5d2bdc4747da837be8ac2  ./01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A03_HOTT_CUBICAL_SURVEY.md
d77ea25a9c958daa16c9e0ae236b9afd36995e167391b5ea765843376dfffa4b  ./01_RESEARCH/08_DOMAIN_H_CONCURRENCY_AND_POLICY/RESEARCH_DOMAIN_H_POLICY_LANGUAGES.md
a0d65d4eda61c03d2834e7f33fc0904564a4f885201409c0755ef0b0cac8b5e4  ./01_RESEARCH/08_DOMAIN_H_CONCURRENCY_AND_POLICY/RESEARCH_DOMAIN_H_COMPLETE.md
b1afeb3572973b3b3a8b1f2dccd03fb0e70833f0b87952aad73dbefb34d2f708  ./01_RESEARCH/TRACK_F-TOOL-BUILD_v1_0_0.md
0ee2cc07dca80ed4c7b426ae8ef0f6936d9cb5a3596dbd28564778fd9cf7519f  ./05_TOOLING/crates/teras-lang-types/Cargo.toml
8ac132fc70b6f2d53f41b44eea8760a8994f5f221f182e00987b86f5962a06cf  ./05_TOOLING/crates/teras-lang-types/src/lib.rs
ae12624c9735da0cd249624569ceada68e85304b7496a99cb52f33bd7e11ff25  ./05_TOOLING/crates/teras-core/Cargo.toml
ac3fac391fe6a8b440a13c215a4d5b9d1e7db3582221a4655d707c27b3462ce6  ./05_TOOLING/crates/teras-core/src/zeroize.rs
b9fc927c8b773d41e73ff84e2c47d6e9008138a1a5e6dc89f39bb1194a6aa63f  ./05_TOOLING/crates/teras-core/src/secret.rs
bbc39d63b775e8e7c6c5e078b489858d9d3a757d9ad47d25d3f87dee43a7a401  ./05_TOOLING/crates/teras-core/src/constant_time.rs
24b2c198796fe1916d0047ccdfa514b4af488be933bb5f9407277404700b6fd5  ./05_TOOLING/crates/teras-core/src/crypto/ed25519.rs
93fdeeb1f3a2127d0150b0c2801f8bb5de6863fa24ff68f27dde02c15e745654  ./05_TOOLING/crates/teras-core/src/crypto/gcm.rs
177b7ab6eb60241afcec2beb452bc61a3672e807ec0872bb4e27c75f02e3f5b9  ./05_TOOLING/crates/teras-core/src/crypto/ml_dsa.rs
dc274faf7e10abf4ef97a5093d6a808a609c4363fe8e9f1eab63a917ca15891b  ./05_TOOLING/crates/teras-core/src/crypto/x25519.rs
2bbc977a327696315f207072444d7c9cb8a5466280f60b4491d6d052e7c40086  ./05_TOOLING/crates/teras-core/src/crypto/hmac.rs
7eee26abdb7c2298e818a96715d9e566349dba72f311d92de0b3e0713ac9b117  ./05_TOOLING/crates/teras-core/src/crypto/sha2.rs
9aa5ead4008cd3d5fe57fc10a37310e5acb53c4b59fe98146834cf5acbfa7094  ./05_TOOLING/crates/teras-core/src/crypto/mod.rs
732a03444935db7555b76b4072acff12f83c8836cd59eb9f8038ba68b6f5546e  ./05_TOOLING/crates/teras-core/src/crypto/ghash.rs
f0821195977753db02adbdfb23913b9d752034d90cb3d69371e0c4661dddbba1  ./05_TOOLING/crates/teras-core/src/crypto/hkdf.rs
747cb185b03ddb9a88125331a93c1b2ee77158b5e8d3344d04e9b06e9e116566  ./05_TOOLING/crates/teras-core/src/crypto/hybrid.rs
6d0fdfb55896d9e63621d2f28bff5aab26197f3d399431ed144f431e398f41d2  ./05_TOOLING/crates/teras-core/src/crypto/aes.rs
bfe3c0687bd8cce112d392a0eccfbc68e9c9767d4870cc0eb93389d632cd3a65  ./05_TOOLING/crates/teras-core/src/crypto/ml_kem.rs
eef94139b6cae402d4141b2b27750d194582d257acfef1f82f3e1dea6ce22822  ./05_TOOLING/crates/teras-core/src/lib.rs
9c1862a30086d248ca2dca21fe9c4c7f8ec8ac23c33dfbbc711f1efdd5846499  ./05_TOOLING/crates/teras-verify/Cargo.toml
c4ca1272de389b3ab65511025e3a9ca97183f4e248676f37c3e8a8b1c6cea69f  ./05_TOOLING/crates/teras-verify/src/main.rs
e40a1bf22f7a619d9fe59635767606b19252c5f71391f3fc3bde3abe34be9317  ./05_TOOLING/crates/teras-lang-codegen/Cargo.toml
4c9dc73062ecd001728615bf232533cb957b17bc4daa2ccfca76350796d4ae29  ./05_TOOLING/crates/teras-lang-codegen/src/lib.rs
e3ce033baa129e57739b828b08d31c1e4d089c3b366e7c553fd9324ebf882167  ./05_TOOLING/crates/teras-lang-parser/Cargo.toml
31a9e0ff35af7aac6c75087ddacc7b243273681c9b2bd9a89e674cb6ce470982  ./05_TOOLING/crates/teras-lang-parser/src/lib.rs
34b994888b25592503fa19a53a4e516c6cc818be02e13fadec002f44e4578207  ./05_TOOLING/crates/teras-lang-lexer/Cargo.toml
988833dd4ece800b107b5f6a085bcc266ede689ec8c656be8af533d0e119f908  ./05_TOOLING/crates/teras-lang-lexer/src/lib.rs
c1021d1ff09a13271e76793ec5e5c94b3c24eacdd1454ed0e16471ad383edcb3  ./05_TOOLING/crates/teras-effect/Cargo.toml
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/crates/teras-effect/src/capability.rs
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/crates/teras-effect/src/proof_bundle.rs
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/crates/teras-effect/src/effect_gate.rs
346e1a6987c5216085d2f6753a94894a1f7775a00e3695bf7f7f9ead9fe8efae  ./05_TOOLING/crates/teras-effect/src/lib.rs
c3dd6c05ef69d08276c61542a151776a24acb36638e6e854477aa44952315a98  ./05_TOOLING/crates/terasc/Cargo.toml
2b5d87a06abfcda4ac7e0ee25bf623144a6a3513d35042f832e323de58eb234c  ./05_TOOLING/crates/terasc/src/main.rs
462105dab63dac052c5c1880445031b0597c2d767aa692a416943923a7b15b43  ./05_TOOLING/crates/teras-build/Cargo.toml
b9a87f44024e24883404da74a5fc875e10277480a3314cd56e000dc02202e877  ./05_TOOLING/crates/teras-build/src/main.rs
a12c9b59f0688820972ac742c06731f967de014451d9283261021265cda3ded5  ./05_TOOLING/target/debug/deps/libanstream-813afb745a1b9fed.rmeta
a39309001e6cc9eb91d17a26b01c437a9459d91be9fccba2b0db014c4bce0b71  ./05_TOOLING/target/debug/deps/liblibc-6be7e97cbb16fe4a.rlib
e3e5357eecd41767617e7672c8761796e300264a3c33d1dfdd77ddfc5a9d1104  ./05_TOOLING/target/debug/deps/libanstyle-866d7e1e7a50ab35.rmeta
21715adee21ae9a63ba1568e9a0d6ef0f9007cd21b3e77dc0406ac197a150b5f  ./05_TOOLING/target/debug/deps/autocfg-10dfddc15ee756c1.d
a402b1828988841cbd11c7bfb5f8150e40c25e25df20942d670b1ccfcd9c5fc5  ./05_TOOLING/target/debug/deps/libserde_derive-2b33547190230eda.so
830874e49017c0687bf003557b3a02216f786acd4e46d334e5c674c1dc50d701  ./05_TOOLING/target/debug/deps/anstyle_query-5b45402b4257ad8d.d
6ed4acf89fd3d88694d717aeb008e18950f9f152f5a959bb6475f428b619f36e  ./05_TOOLING/target/debug/deps/libstrsim-f2df8ac1b76461e2.rmeta
89a73b12e1dad8b23549d113a7b4e59710c55fa998035c329782aa9a91bb2423  ./05_TOOLING/target/debug/deps/libgeneric_array-64c97f562c8938cf.rmeta
5fc9deb2932cb8a9bbf220c79d9393669d57e76624eee8b6a2cbfb2d003c728f  ./05_TOOLING/target/debug/deps/libanstream-813afb745a1b9fed.rlib
b810c0af01aa7351349558ea17d2a3eb842021bd1bc481ab8015638de78a9c7b  ./05_TOOLING/target/debug/deps/libc-6be7e97cbb16fe4a.d
c6c6af90d88f9f8af1e8b70c8c335832af6f79b11e0f6eefad8efd4b25d58cd7  ./05_TOOLING/target/debug/deps/utf8parse-6e5842187ebbcc93.d
37b4883f19960b5bf9a505a407efa353816cc842f51bf8a221fe832b8b3fbfde  ./05_TOOLING/target/debug/deps/libanstyle_query-5b45402b4257ad8d.rlib
05643697d7dbfda0833895216fdf30272d45865a0288c9d183e1a2cdacff4997  ./05_TOOLING/target/debug/deps/libversion_check-e4e51b3e54dc818f.rlib
e62acdbdf99f397e2b8d2ce1ec9a1d17d5bafae268fecd69812de26cb8aea11f  ./05_TOOLING/target/debug/deps/proc_macro2-7f47ada5f1451fed.d
4ee8a4b3b290548a10a72f6a60cae5e5cc7ae8fc884a7edc0c8a5719e76239b0  ./05_TOOLING/target/debug/deps/libproc_macro2-7f47ada5f1451fed.rlib
67fbc7acd1e513345e34071c9d43dbcfc80162c05cf19454523b61faaf0adf43  ./05_TOOLING/target/debug/deps/libclap_builder-6893176bc789c161.rlib
47e49d3ccf84a12dc266da774857912410acf5f1d6a8dec13ff57e7898db7f12  ./05_TOOLING/target/debug/deps/libanstyle_parse-70c08b92fc2e6e25.rlib
d5471b161ff2cf63018c65d53399e7ddd5351d8cb80ef59dd0652697e41e0e26  ./05_TOOLING/target/debug/deps/libis_terminal_polyfill-35e81a5976e6bb9a.rlib
85280ce34452529242f472080ec2c33101e0c04497e4653f1216340a1a0e0e5b  ./05_TOOLING/target/debug/deps/libunicode_ident-5fb1160652e9cf6b.rlib
81db6d2a44d17f5a5c85147c6373a39cd611fe9f0d8632591fc6827974345a5e  ./05_TOOLING/target/debug/deps/generic_array-64c97f562c8938cf.d
ab082491c5e5561bbb5954b6fc207971eb9dc9dc0703b380cba4064a600d5c77  ./05_TOOLING/target/debug/deps/libclap_lex-019e28a81d885158.rmeta
b0358e21ec7f849f6d0bfc0b0c30942b0641e4b674872aa40587a68e7dd0da17  ./05_TOOLING/target/debug/deps/libcolorchoice-23567e66ed925ecc.rlib
7d5b4a33e7279d135438fb91c05f5647329701650991db1aafdced30fab370ea  ./05_TOOLING/target/debug/deps/libgeneric_array-64c97f562c8938cf.rlib
4fc193ad21816f880d58fe8e8ccc3a47dabdb354d75ffbeed99b6f3242367a5b  ./05_TOOLING/target/debug/deps/libcfg_if-50f30dfea7d9c938.rlib
d2139e1a1069344f0be1b0137dd84a4a78bd3ab610d9a20d15958a2cb6ed89d9  ./05_TOOLING/target/debug/deps/libautocfg-10dfddc15ee756c1.rlib
98703ba8874f868c9d8798178cacc40df67bebcedaf010ce498792700d942f5e  ./05_TOOLING/target/debug/deps/serde-0a293250c73ea41d.d
baccdfe751c80545cceb53d47e0db4668f134ef355dba997555d800d7618f293  ./05_TOOLING/target/debug/deps/anstyle-866d7e1e7a50ab35.d
044684dd90660eeadc6fee297aa24eeb9672ef72ef9fef3c3394c3f1e53760f0  ./05_TOOLING/target/debug/deps/libheck-885ddee7521d46eb.rmeta
1843d8becfa705d634af98eed76e801fb6fa82f6e90e1ce831215992b188a887  ./05_TOOLING/target/debug/deps/anstream-813afb745a1b9fed.d
7cbb6e4320385585c84f2dcd7cb97591db2af045c8d4b6316fd0a0067c84b6d4  ./05_TOOLING/target/debug/deps/libquote-848b6d7e1cfffc84.rlib
634aee266c18defa626c9474a3101f5a58638527bc558c05f7fa3992788ae336  ./05_TOOLING/target/debug/deps/libsyn-007ec89474eb2893.rmeta
2b05f384585a5c7a575fab5fedae6c53f08b0aa21d0ca9199d96f057997d4aff  ./05_TOOLING/target/debug/deps/heck-885ddee7521d46eb.d
fe4f95b1316b67cbe4bac5f3a9fec9d3a2e4408a8bbc28ec9d934dfa51f38222  ./05_TOOLING/target/debug/deps/libanstyle_query-5b45402b4257ad8d.rmeta
4d7b37b7c0d29c965798ca618028eaf58d48ef266a0f0500d0d6befc4e8b2c47  ./05_TOOLING/target/debug/deps/libclap-79173bda7467d02f.rmeta
8cafe738b4b8a6e9956908717dbab14378bbfeaa1957275ecba87d1ca86629d0  ./05_TOOLING/target/debug/deps/serde_core-5069c27ef1df41e0.d
2562b6b0ab089b1f71c22905c9055a618d9dad131091029e03806205694ec50e  ./05_TOOLING/target/debug/deps/strsim-f2df8ac1b76461e2.d
cf09962570d8b9dc260c7127e2d93626f48a859f9a59a3bca3b7739e354b02b8  ./05_TOOLING/target/debug/deps/libcolorchoice-23567e66ed925ecc.rmeta
c9f6c9d85061bef0a2d7f0d0b2689013baf27eddfcc29cfefd68ef14d434252f  ./05_TOOLING/target/debug/deps/libserde-0a293250c73ea41d.rlib
f80bdfd61658503db8056820c5f3c14ef3ebc3a4b6d6f1e68795d8a3d8ef1435  ./05_TOOLING/target/debug/deps/clap_lex-019e28a81d885158.d
a953d6a17c000483b364c2dd255bc1350be0eab0f29d96ad71e317af58b5108f  ./05_TOOLING/target/debug/deps/libclap_builder-6893176bc789c161.rmeta
2916525a5d577bd24e6f10bc844e12b6cef7ee3412ad31681e76e477e44830c6  ./05_TOOLING/target/debug/deps/clap_derive-6f3808cc7ceb6a16.d
1d34b5a1a1180b64fa042ffb093d5092f441d1ce4f9d0979d2ad1ab1dbe8d7ed  ./05_TOOLING/target/debug/deps/libheck-885ddee7521d46eb.rlib
7f0c97d09253fd2c1d13e3188f8883f5d7d2d79c5caed4585bd6bfb4a02a7512  ./05_TOOLING/target/debug/deps/libanstyle_parse-70c08b92fc2e6e25.rmeta
5565a1ecc70524d0e31d1c7e0fa4576f4acbfaba69a6ff7504f04a034acc344f  ./05_TOOLING/target/debug/deps/anstyle_parse-70c08b92fc2e6e25.d
b622d0389d85e0a380689e0f96e2518c60cec7fb4907ba183b9bd96ca7ef1392  ./05_TOOLING/target/debug/deps/clap-79173bda7467d02f.d
13dfaf6ece2058154c2167761c77ee743898e1a9d9f457b3c04d65f1d688d899  ./05_TOOLING/target/debug/deps/libcfg_if-50f30dfea7d9c938.rmeta
02cfa612099b46aa9442b0fd4f6b257630eb809c5154ea51077cfb1db6e35599  ./05_TOOLING/target/debug/deps/unicode_ident-5fb1160652e9cf6b.d
4168e95ae13badc9b0e1fcfc4d022aa2a1d3df43632fde6cdfa381e5196718c9  ./05_TOOLING/target/debug/deps/version_check-e4e51b3e54dc818f.d
0fb97c771c954e5a724500f7d2c885d9343790cd107c3ef467699d80cf36096d  ./05_TOOLING/target/debug/deps/libserde_core-5069c27ef1df41e0.rmeta
48d7b33312555f109fbdc036ef339dff694b529c69806f283a98f469a23bfc56  ./05_TOOLING/target/debug/deps/libsyn-007ec89474eb2893.rlib
0386d9e831406aa24e927e8b6924247f9f862d7d0a68643ba6cdb1c64de3b602  ./05_TOOLING/target/debug/deps/libutf8parse-6e5842187ebbcc93.rmeta
064e76b86c1b867f8ebaf761aa31a107d3cbe0fc40ce680f1a35c9602f62de51  ./05_TOOLING/target/debug/deps/libversion_check-e4e51b3e54dc818f.rmeta
3b6f1ad781c9a1195213100608f1b0c06e3c74ec5c83376bee30465dd61d516c  ./05_TOOLING/target/debug/deps/libautocfg-10dfddc15ee756c1.rmeta
c5f3860d7b3bb7568379c5dbe8a67b5c07df1fa809ecebff98e8f8b75637a06b  ./05_TOOLING/target/debug/deps/libquote-848b6d7e1cfffc84.rmeta
5a3c2a80188a2b181029731652b461c6238434a8130ebdc34fef4a45537c2c0a  ./05_TOOLING/target/debug/deps/liblibc-6be7e97cbb16fe4a.rmeta
9faa00b97ee6d3e98adae11b123985cb417e15b87af4ab04d3cd7f0bb977de91  ./05_TOOLING/target/debug/deps/syn-007ec89474eb2893.d
24cd8f01415c3db85a763296e78fb9e263c7ddbeac27d1bc50e5ede3444b5aa9  ./05_TOOLING/target/debug/deps/is_terminal_polyfill-35e81a5976e6bb9a.d
299d7cdf6c9104dbf9f7969ef77d43f6f87bbe505bab65a52dbf44a1a0b1bbc0  ./05_TOOLING/target/debug/deps/libunicode_ident-5fb1160652e9cf6b.rmeta
ece42a7e42739cebb08c31fb92f4eb0fc719e58a7d4c03c03e5552abea680c14  ./05_TOOLING/target/debug/deps/libclap_derive-6f3808cc7ceb6a16.so
d886f195c784c8d2790b90725ab8ee079ab34f2258b0a1cbbed80fb792099164  ./05_TOOLING/target/debug/deps/teras_core-894664ab93ea9758.d
23488e8fd3f19d1c9fb25da105173fc8c9f01dd3e2f8384cc4587c8ff9dd0b5f  ./05_TOOLING/target/debug/deps/cfg_if-50f30dfea7d9c938.d
15edf81cc02ecd06c5e161ee1fe1c61f3a8a8d7a365ba8369a45b5845484640e  ./05_TOOLING/target/debug/deps/libanstyle-866d7e1e7a50ab35.rlib
6242a0903d5932a4acee85f4d5f0cbefd6ebfc0bf945c644f96516dab09cc7ee  ./05_TOOLING/target/debug/deps/typenum-57e06e88f35ed3c9.d
2363bc7267289182381ebecabb25588551751a1854e8414505ccf1ed38eba80b  ./05_TOOLING/target/debug/deps/clap_builder-6893176bc789c161.d
b0eb39141635299e84c58b9c0801ca6887646f0b92e1fce55006f4301d3d523b  ./05_TOOLING/target/debug/deps/serde_derive-2b33547190230eda.d
230b1f51de23af9c11b33d967f6cbb3f295aa1c1a118756660443eb0f7a99422  ./05_TOOLING/target/debug/deps/libserde-0a293250c73ea41d.rmeta
0fe67f02bb0f017da6efb5b5f560ee64435419bdb309307d2741b5f74c231288  ./05_TOOLING/target/debug/deps/libutf8parse-6e5842187ebbcc93.rlib
545f80b5daab8beaf17498cf8ce3ae7b40c0ebe08a92a53108e46753537b3b56  ./05_TOOLING/target/debug/deps/quote-848b6d7e1cfffc84.d
9da3fffed4ae2c721f43a157aad0c364b869c4663302b5fe2577fe9e49bae632  ./05_TOOLING/target/debug/deps/libis_terminal_polyfill-35e81a5976e6bb9a.rmeta
c77cbba179cccd0770b736d9d8eb51792da8caa59c092a3ecd74ee15bd32632d  ./05_TOOLING/target/debug/deps/colorchoice-23567e66ed925ecc.d
d7b99125ec8d5748ac895260f840f710118f753f24cf053e24cc7f78d1f293ba  ./05_TOOLING/target/debug/deps/libtypenum-57e06e88f35ed3c9.rmeta
66e91fa92b1ffb31bb62705004e76e743b2b5aaebb012035fead3e16dee1e19b  ./05_TOOLING/target/debug/deps/libclap_lex-019e28a81d885158.rlib
318ce185d54df3618b0d4292a0d86c270154a521e3274c89602e53605cafe91b  ./05_TOOLING/target/debug/deps/libclap-79173bda7467d02f.rlib
a74e3dceeb287d7b72ae153c95470ea30a0875ac888155966eab1dac6d0f9ef5  ./05_TOOLING/target/debug/deps/libserde_core-5069c27ef1df41e0.rlib
646792fa431a7852947150227f59479ced04285a0f0984aee99e6e37e86bc0f7  ./05_TOOLING/target/debug/deps/libtypenum-57e06e88f35ed3c9.rlib
71ad0d54cfb14221a84e3a82395af31ca8469fe4fab9fdb1c03d0d0d8a631c5b  ./05_TOOLING/target/debug/deps/libproc_macro2-7f47ada5f1451fed.rmeta
3e7c189ea409b1a85a2cab769234a93b7bff732969cc678ef4fe6d3c399165eb  ./05_TOOLING/target/debug/deps/libstrsim-f2df8ac1b76461e2.rlib
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/.cargo-lock
0021e84fcfe456df2e99ede434e1a7d75fc2f6a40cc948eabb396f613fb3b3e1  ./05_TOOLING/target/debug/.fingerprint/autocfg-10dfddc15ee756c1/lib-autocfg.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/autocfg-10dfddc15ee756c1/dep-lib-autocfg
fcbb5b05d5e9ec6cb86570830276c84abeafa760777eb5649ef35075cda3882b  ./05_TOOLING/target/debug/.fingerprint/autocfg-10dfddc15ee756c1/lib-autocfg
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/autocfg-10dfddc15ee756c1/invoked.timestamp
802aa878e890714842bd3defd636895348d12a5c5cf74a1d88ada0968e269013  ./05_TOOLING/target/debug/.fingerprint/unicode-ident-5fb1160652e9cf6b/lib-unicode_ident.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/unicode-ident-5fb1160652e9cf6b/dep-lib-unicode_ident
8e8f00edaa9d2a712a3bf7205260ceba9ee51a02e394db67c2b099b39d768503  ./05_TOOLING/target/debug/.fingerprint/unicode-ident-5fb1160652e9cf6b/lib-unicode_ident
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/unicode-ident-5fb1160652e9cf6b/invoked.timestamp
459f3dbfd87c0fc62d9f6a95d88c4a148cb42a85c2e1a56ffb367510a5ad55f6  ./05_TOOLING/target/debug/.fingerprint/num-traits-bcfe50daa15d0f5c/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/num-traits-bcfe50daa15d0f5c/dep-build-script-build-script-build
bff50fc5f3df525e7d7cf70a3fec6ec032f8850e615f96a89a5e5ab56f50f2e6  ./05_TOOLING/target/debug/.fingerprint/num-traits-bcfe50daa15d0f5c/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/num-traits-bcfe50daa15d0f5c/invoked.timestamp
0cb109d056342468bc9871ae59bc1b85ed7c895a1085867c2ad39954b4ed68b8  ./05_TOOLING/target/debug/.fingerprint/anstyle-866d7e1e7a50ab35/lib-anstyle.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/anstyle-866d7e1e7a50ab35/dep-lib-anstyle
6d4fd726768d3423ad2bc6d4ec1e6054433ca012865ad43d1101e4eb3b1ce0dc  ./05_TOOLING/target/debug/.fingerprint/anstyle-866d7e1e7a50ab35/lib-anstyle
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/anstyle-866d7e1e7a50ab35/invoked.timestamp
46b67b7de6f40c0c4e97d224ecb93b5d3c5b1862048f1eaeabb6e5507f6096d7  ./05_TOOLING/target/debug/.fingerprint/clap-79173bda7467d02f/lib-clap.json
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/clap-79173bda7467d02f/invoked.timestamp
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/clap-79173bda7467d02f/dep-lib-clap
ee66604afd2ca5bfdc28c2494508718b8fcf41d65e912646791359b9c1382eca  ./05_TOOLING/target/debug/.fingerprint/clap-79173bda7467d02f/lib-clap
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/anstyle-query-5b45402b4257ad8d/dep-lib-anstyle_query
258c578b2073fbcf7edf790c0828db9802b192d5b85cb3ed926904d822225bfa  ./05_TOOLING/target/debug/.fingerprint/anstyle-query-5b45402b4257ad8d/lib-anstyle_query.json
a0452bc7ef5744a7508949a9784502c284519985f80bede443b9dbafa8cbad8c  ./05_TOOLING/target/debug/.fingerprint/anstyle-query-5b45402b4257ad8d/lib-anstyle_query
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/anstyle-query-5b45402b4257ad8d/invoked.timestamp
417450644a651e920d074fd30f5434f8ac01d45e1b0163a1b1a52c2b21e1e46f  ./05_TOOLING/target/debug/.fingerprint/zmij-68255aaf5bbcd5d8/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/zmij-68255aaf5bbcd5d8/dep-build-script-build-script-build
77faee6de9ce1221ddd062b2b6eff3059530abba48bf89c84bd20bd80393fc00  ./05_TOOLING/target/debug/.fingerprint/zmij-68255aaf5bbcd5d8/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/zmij-68255aaf5bbcd5d8/invoked.timestamp
f0e5e640d26b69c45034bb7cde67aa3e3db6c269c79fd2a05e6b0c2fdeb308fa  ./05_TOOLING/target/debug/.fingerprint/anstream-813afb745a1b9fed/lib-anstream.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/anstream-813afb745a1b9fed/dep-lib-anstream
e9e9606f62b4fbb72c191728f2b7ceb822ccd43548c359e1ad8311e4c6f32212  ./05_TOOLING/target/debug/.fingerprint/anstream-813afb745a1b9fed/lib-anstream
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/anstream-813afb745a1b9fed/invoked.timestamp
a242b2ef093f539756d093495db872c3ba375c847416d387a0ebb97d01712f0c  ./05_TOOLING/target/debug/.fingerprint/serde-37d3e83438400c49/run-build-script-build-script-build
d439375723aca6bc647856a53d6afac45faa842f12d79010e89352c53888e9ce  ./05_TOOLING/target/debug/.fingerprint/serde-37d3e83438400c49/run-build-script-build-script-build.json
44b7c776a6f14068f47c4516c260806af3441edb058695d3b755806b03b30ce1  ./05_TOOLING/target/debug/.fingerprint/typenum-88c184e8314906b5/run-build-script-build-script-build
ba44f5a12b2043878bd027e4aa2ec45d66ca7df18d712c92adcdcd3929cc9bea  ./05_TOOLING/target/debug/.fingerprint/typenum-88c184e8314906b5/run-build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/version_check-e4e51b3e54dc818f/dep-lib-version_check
267c204b93786c5616919cbb5bbee58029169073b2eeba17308da9c773610220  ./05_TOOLING/target/debug/.fingerprint/version_check-e4e51b3e54dc818f/lib-version_check.json
f0ef313a6322e287750b862376402c307c4046337fd10b35ef3e9f8e266d135d  ./05_TOOLING/target/debug/.fingerprint/version_check-e4e51b3e54dc818f/lib-version_check
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/version_check-e4e51b3e54dc818f/invoked.timestamp
e8a2c9644a89bd8da1a1bcbc587eed205a7efd820a95e97ac8b21706eb2b83cd  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-328772ad4132d55e/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-328772ad4132d55e/dep-build-script-build-script-build
9adbb97562d6ff508025a590d9215e41d385a7f6725275ab222379f8d6c96482  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-328772ad4132d55e/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-328772ad4132d55e/invoked.timestamp
faeaeb86565bf9cf75ed4622f455da9454e8866bce0015f1198aabf0e6790acc  ./05_TOOLING/target/debug/.fingerprint/serde_core-1d20d4037d30c199/run-build-script-build-script-build
a02359ed498c20750f9f65b8869e6f1c0e6263d6f31e5a62874a5f733f14f639  ./05_TOOLING/target/debug/.fingerprint/serde_core-1d20d4037d30c199/run-build-script-build-script-build.json
d51af3d52e0679d40d13ee0744b051563555f80c8d1bab7673df2478f9698c2f  ./05_TOOLING/target/debug/.fingerprint/serde-0a293250c73ea41d/dep-lib-serde
08bca80e541212713a80e2bec58bbbbd80f9714be8d93dd12988429c4130edad  ./05_TOOLING/target/debug/.fingerprint/serde-0a293250c73ea41d/lib-serde
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/serde-0a293250c73ea41d/invoked.timestamp
86ecce314ea416c72afcfb7f7365931a71250c10d39f4908156e001fcbfe9e3d  ./05_TOOLING/target/debug/.fingerprint/serde-0a293250c73ea41d/lib-serde.json
6e987786f8c1eebfd173bbde1d0e2ad537f90e590680de6676fbacbf74a3e270  ./05_TOOLING/target/debug/.fingerprint/quote-d84f5fa04b036a74/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/quote-d84f5fa04b036a74/dep-build-script-build-script-build
348ccbff8c6ead5d79212f0e71979779f71a332b94daf40194ea9857f3c038d0  ./05_TOOLING/target/debug/.fingerprint/quote-d84f5fa04b036a74/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/quote-d84f5fa04b036a74/invoked.timestamp
30eaf801d4c27e087fba3ac901aa69d4317384d6e4aa36b0ccd4dbaa1cafc315  ./05_TOOLING/target/debug/.fingerprint/clap_lex-019e28a81d885158/lib-clap_lex.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/clap_lex-019e28a81d885158/dep-lib-clap_lex
1c97d7e17c266d16849cb607bc2e492bcd2871ae48eb2d8e0c2001ff40863a96  ./05_TOOLING/target/debug/.fingerprint/clap_lex-019e28a81d885158/lib-clap_lex
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/clap_lex-019e28a81d885158/invoked.timestamp
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/cfg-if-50f30dfea7d9c938/dep-lib-cfg_if
3ddfb6102e22030ac563c7294882b2cdd3ec7383efd06bb9cdcedd448ee97b7a  ./05_TOOLING/target/debug/.fingerprint/cfg-if-50f30dfea7d9c938/lib-cfg_if
14930e57ff9fc33162473b5c5d9c66be8bce332c2986473b104c6ba3139cd901  ./05_TOOLING/target/debug/.fingerprint/cfg-if-50f30dfea7d9c938/lib-cfg_if.json
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/cfg-if-50f30dfea7d9c938/invoked.timestamp
40faf320809dedff6cbab6f7a79ea871750c0b95d1e2fe30123b12cf657ebec1  ./05_TOOLING/target/debug/.fingerprint/libc-7e686221307a2539/run-build-script-build-script-build
2ddf627ff330cb691a8fae0fc3494351edffbf302ff3f0a18dea0b7966b34bb7  ./05_TOOLING/target/debug/.fingerprint/libc-7e686221307a2539/run-build-script-build-script-build.json
bc1219478f2bb6ac59c2e9f4e2b1fd384b17e56ee5a195a239b319ce59f1a247  ./05_TOOLING/target/debug/.fingerprint/serde-09850bb34cca55a2/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/serde-09850bb34cca55a2/dep-build-script-build-script-build
ce2082619699932e482b2c144e077f12f6f8b6276628329db4d77fd6ab901b01  ./05_TOOLING/target/debug/.fingerprint/serde-09850bb34cca55a2/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/serde-09850bb34cca55a2/invoked.timestamp
a7dfed90d291a9a25bb6a5a624e04ac4a4cabb42a497d3af2be332008c54b821  ./05_TOOLING/target/debug/.fingerprint/zmij-1bf336ff377bb65b/run-build-script-build-script-build
f3e85762361ae6da61a57d9c3e13ac76ff323e31bc4efeb7d100db36be059145  ./05_TOOLING/target/debug/.fingerprint/zmij-1bf336ff377bb65b/run-build-script-build-script-build.json
e07206686af70b5810f63ad6c76ff5633dcbd1c3d5a5830a2e505468bfdf61c8  ./05_TOOLING/target/debug/.fingerprint/serde_core-5069c27ef1df41e0/dep-lib-serde_core
7986961e43a28722b85786982ebac30f4960422c2463714aee2b709dba191caf  ./05_TOOLING/target/debug/.fingerprint/serde_core-5069c27ef1df41e0/lib-serde_core
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/serde_core-5069c27ef1df41e0/invoked.timestamp
f0984e1c27b40ad05abcbb6cc726b317b597b4dcc54c0756d66be91a6c5db593  ./05_TOOLING/target/debug/.fingerprint/serde_core-5069c27ef1df41e0/lib-serde_core.json
20f40c6af5fbda2324a8352a0729ad52f9294c259aafa088d58f8e7ca545ce00  ./05_TOOLING/target/debug/.fingerprint/anstyle-parse-70c08b92fc2e6e25/lib-anstyle_parse
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/anstyle-parse-70c08b92fc2e6e25/dep-lib-anstyle_parse
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/anstyle-parse-70c08b92fc2e6e25/invoked.timestamp
9c1348091bd96996d92a76d9ac239672effd5a7fcae3db2efb59ce9697882bd7  ./05_TOOLING/target/debug/.fingerprint/anstyle-parse-70c08b92fc2e6e25/lib-anstyle_parse.json
a73352d2ce07caf0f5c7a3baa7726939c45978ce712358e605426b90b319bc9a  ./05_TOOLING/target/debug/.fingerprint/libc-2589e6fbe6d94c4c/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/libc-2589e6fbe6d94c4c/dep-build-script-build-script-build
ad50fcd620af7320de7d9aa1a0a104ccddb151ec470c765fe2a9e913c4441650  ./05_TOOLING/target/debug/.fingerprint/libc-2589e6fbe6d94c4c/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/libc-2589e6fbe6d94c4c/invoked.timestamp
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/libc-6be7e97cbb16fe4a/dep-lib-libc
38383d40ff7d05f95bdac6fbaf3f51296aa3e8fc2d1e1a8f5094e27dafadb975  ./05_TOOLING/target/debug/.fingerprint/libc-6be7e97cbb16fe4a/lib-libc
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/libc-6be7e97cbb16fe4a/invoked.timestamp
5446993c679ca31f9f880462bea15836ae164fcb08187fa3d86826971cf8a336  ./05_TOOLING/target/debug/.fingerprint/libc-6be7e97cbb16fe4a/lib-libc.json
0ac34450340f07afca5a66a5fb6e68dd71d3611d83c269dd6f954d90f08c205e  ./05_TOOLING/target/debug/.fingerprint/quote-0a85777d612b6e85/run-build-script-build-script-build
089f4e0fc9a360c6746c6735d5134cf3aafe37a5eb346e816392295628a7a05d  ./05_TOOLING/target/debug/.fingerprint/quote-0a85777d612b6e85/run-build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/is_terminal_polyfill-35e81a5976e6bb9a/dep-lib-is_terminal_polyfill
803722bac7902c5045b3f1f580b6ebcae2d1a4ce6c10e0c1bada49642c826139  ./05_TOOLING/target/debug/.fingerprint/is_terminal_polyfill-35e81a5976e6bb9a/lib-is_terminal_polyfill.json
0ce58acd4b7515e1d9b868a69cefa45b17d19757efaf076ac5acc43dd31e22d0  ./05_TOOLING/target/debug/.fingerprint/is_terminal_polyfill-35e81a5976e6bb9a/lib-is_terminal_polyfill
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/is_terminal_polyfill-35e81a5976e6bb9a/invoked.timestamp
58d30109321de1ee839836ec5538de154d0f3ff42c81edb867ec106db56f9447  ./05_TOOLING/target/debug/.fingerprint/typenum-57e06e88f35ed3c9/lib-typenum
d51f00a4281b85629ce35d15505eb856974f825716a58d07d95de6136a826e04  ./05_TOOLING/target/debug/.fingerprint/typenum-57e06e88f35ed3c9/lib-typenum.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/typenum-57e06e88f35ed3c9/dep-lib-typenum
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/typenum-57e06e88f35ed3c9/invoked.timestamp
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/clap_derive-6f3808cc7ceb6a16/dep-lib-clap_derive
eb8d3eff27f3b52abe8c7ea9bcc150bc1436ec757238ea59b5dad160b1e0d3ad  ./05_TOOLING/target/debug/.fingerprint/clap_derive-6f3808cc7ceb6a16/lib-clap_derive
a2c0393d4d9acfdb50ec7bcc24c61748338635719216e946aadf1f02af52f282  ./05_TOOLING/target/debug/.fingerprint/clap_derive-6f3808cc7ceb6a16/lib-clap_derive.json
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/clap_derive-6f3808cc7ceb6a16/invoked.timestamp
472af8999763a119c8fd3ed206eafebb7b6c12be6f9601fb9a610c2c296a0659  ./05_TOOLING/target/debug/.fingerprint/strsim-f2df8ac1b76461e2/lib-strsim.json
fc43e1bfe3180d34f6dc0a52a0a03dc5b4067b31d05a82327b11c525353c8e5f  ./05_TOOLING/target/debug/.fingerprint/strsim-f2df8ac1b76461e2/lib-strsim
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/strsim-f2df8ac1b76461e2/dep-lib-strsim
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/strsim-f2df8ac1b76461e2/invoked.timestamp
c83535b639f403d1a88d6296d20ed4400ee75c26b0ad36420ed0a3661093f598  ./05_TOOLING/target/debug/.fingerprint/parking_lot_core-2433b751f559cef6/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/parking_lot_core-2433b751f559cef6/dep-build-script-build-script-build
3691e9f0385db3afb7451038c399eff138ef193ade34e1cf454e2651526bb030  ./05_TOOLING/target/debug/.fingerprint/parking_lot_core-2433b751f559cef6/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/parking_lot_core-2433b751f559cef6/invoked.timestamp
90260ee4c0688280d7cc4cefa50f4a325eb342fbc2563509ee7851ce7a92de80  ./05_TOOLING/target/debug/.fingerprint/typenum-c39c03ff4de35ee8/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/typenum-c39c03ff4de35ee8/dep-build-script-build-script-build
08d844f640fc9426c2d1742dc9b3dadf16f5999b3df16b3557d57a468ce1b9f1  ./05_TOOLING/target/debug/.fingerprint/typenum-c39c03ff4de35ee8/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/typenum-c39c03ff4de35ee8/invoked.timestamp
26441f204d5aac4a0637d746c59058f7b1c272388b8a663f5e14399980d20b42  ./05_TOOLING/target/debug/.fingerprint/quote-848b6d7e1cfffc84/lib-quote.json
c5112ae6b28c66a230d2ed4f9186fe2ee2c07085cd3a4798c20e8a06cecccd59  ./05_TOOLING/target/debug/.fingerprint/quote-848b6d7e1cfffc84/lib-quote
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/quote-848b6d7e1cfffc84/dep-lib-quote
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/quote-848b6d7e1cfffc84/invoked.timestamp
bd5b585bb7e812a06994745b3171ebcbe93e9a79db0f727ef5bcb80d8c8ed7d0  ./05_TOOLING/target/debug/.fingerprint/generic-array-64c97f562c8938cf/lib-generic_array.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/generic-array-64c97f562c8938cf/dep-lib-generic_array
5c17fb7015ebb6fcac89c309bb139cdad00719b912e695eb5b6a6786154b99da  ./05_TOOLING/target/debug/.fingerprint/generic-array-64c97f562c8938cf/lib-generic_array
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/generic-array-64c97f562c8938cf/invoked.timestamp
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/heck-885ddee7521d46eb/dep-lib-heck
1a44f394348c4f6123255b8ab11d9699558556b1667f9dd6b6a29a2ad3bddb39  ./05_TOOLING/target/debug/.fingerprint/heck-885ddee7521d46eb/lib-heck.json
1c222fac49f31ee951d0667241870508c4cb2a36f5aa4b08275ccbb1d50d29e7  ./05_TOOLING/target/debug/.fingerprint/heck-885ddee7521d46eb/lib-heck
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/heck-885ddee7521d46eb/invoked.timestamp
5e761d529bae3e82bf96329211a22f2a43f0cf35b7a8e56ea5c8c9d1da3c0b65  ./05_TOOLING/target/debug/.fingerprint/generic-array-b32fa9943e73849d/run-build-script-build-script-build
ee2e449070630f9fcc628c4d1759a7a123bdc347d7bca7eb1253b9a70478e754  ./05_TOOLING/target/debug/.fingerprint/generic-array-b32fa9943e73849d/run-build-script-build-script-build.json
e98ea55e67b3bd08ec82cda32b83e8975630d8921090440fffc51865f13ea11e  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-6952c77f561663e6/run-build-script-build-script-build
a375f35f3f055d8d61f50a1fad2874dbc13b1e136dc5c2051b3ff285a42a0130  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-6952c77f561663e6/run-build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-7f47ada5f1451fed/dep-lib-proc_macro2
daf80c632f79420317b0737afc583feb2e6050f662ce7f92cad6a4de05970518  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-7f47ada5f1451fed/lib-proc_macro2.json
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-7f47ada5f1451fed/invoked.timestamp
672b1d4907c6beb079579e2b294b70693150d56c417c5455c25ce5e948c84ef9  ./05_TOOLING/target/debug/.fingerprint/proc-macro2-7f47ada5f1451fed/lib-proc_macro2
e1e25c28ad94d7be1e5f2f87e9769c4110e7209ce5b85c8d6b9d252a6128e9ff  ./05_TOOLING/target/debug/.fingerprint/serde_derive-2b33547190230eda/lib-serde_derive.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/serde_derive-2b33547190230eda/dep-lib-serde_derive
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/serde_derive-2b33547190230eda/invoked.timestamp
13a4f70e17f01d7144074fe41d47845ac6aba47cfbc46d6e83b78104456a9037  ./05_TOOLING/target/debug/.fingerprint/serde_derive-2b33547190230eda/lib-serde_derive
a39839e6ad8c1fcaf87cc7fa862de12dcdc2a07c794d2156554054393e59e707  ./05_TOOLING/target/debug/.fingerprint/colorchoice-23567e66ed925ecc/lib-colorchoice.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/colorchoice-23567e66ed925ecc/dep-lib-colorchoice
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/colorchoice-23567e66ed925ecc/invoked.timestamp
40e2959bda2e2a15f5d8e1e4b9a9ca7ef0066c3961cfd92769af2d8e3fcce4a6  ./05_TOOLING/target/debug/.fingerprint/colorchoice-23567e66ed925ecc/lib-colorchoice
0db1e201f7f81481683f0a4cd76c7f10c824f55c6be057ad4dd1d2b27f32e5f4  ./05_TOOLING/target/debug/.fingerprint/generic-array-873f0cb9f45cdc0a/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/generic-array-873f0cb9f45cdc0a/dep-build-script-build-script-build
b36c3638e0c2e6967a659c5ebe2ed0b09caa9c9e7ca0fdea71f8d4bb5bc07172  ./05_TOOLING/target/debug/.fingerprint/generic-array-873f0cb9f45cdc0a/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/generic-array-873f0cb9f45cdc0a/invoked.timestamp
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/utf8parse-6e5842187ebbcc93/dep-lib-utf8parse
ddf0caa9f0007bda5f56fbb7553cf669ab800dde1ab33a51acbeb354005bd82f  ./05_TOOLING/target/debug/.fingerprint/utf8parse-6e5842187ebbcc93/lib-utf8parse
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/utf8parse-6e5842187ebbcc93/invoked.timestamp
0ab6766f0ed962ce34db3e5e846bcca45a3f3dd00d5c0434d972c84828408ab7  ./05_TOOLING/target/debug/.fingerprint/utf8parse-6e5842187ebbcc93/lib-utf8parse.json
4d48fa63819161574444a8a48233c1629e5f853bd8daacee5fd8df4e9e864ae5  ./05_TOOLING/target/debug/.fingerprint/clap_builder-6893176bc789c161/lib-clap_builder
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/clap_builder-6893176bc789c161/dep-lib-clap_builder
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/clap_builder-6893176bc789c161/invoked.timestamp
70ca05dc8bd3cfee7fed51ce839adf6af31394d56b38a6fa181c74e90fd927b9  ./05_TOOLING/target/debug/.fingerprint/clap_builder-6893176bc789c161/lib-clap_builder.json
3f812774e715cb4a8ce9fa53ea76124466b6d02ac6b295bbfa3444289704e389  ./05_TOOLING/target/debug/.fingerprint/syn-007ec89474eb2893/lib-syn.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/syn-007ec89474eb2893/dep-lib-syn
34d2a894ba0c4caa4654eb2d5896a6c88c6759bf1f4098f7c135452bb7138a97  ./05_TOOLING/target/debug/.fingerprint/syn-007ec89474eb2893/lib-syn
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/syn-007ec89474eb2893/invoked.timestamp
4026eed0481b3a824dd15afcbe532af116a32c2db468732521fda98523d348ce  ./05_TOOLING/target/debug/.fingerprint/teras-core-894664ab93ea9758/output-lib-teras_core
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/teras-core-894664ab93ea9758/invoked.timestamp
fb87339d9c7077e423d7af5539f14a5975ad3c3fa7a8845d7fe97a87a91810f5  ./05_TOOLING/target/debug/.fingerprint/serde_core-b527563cb19990d8/build-script-build-script-build.json
93a4afc37518a1bf7830744017176e1d1946e5df993e47159069839f61fe49ab  ./05_TOOLING/target/debug/.fingerprint/serde_core-b527563cb19990d8/dep-build-script-build-script-build
95057c44d3a218a38e07d8bc32869faab4d60090a51dcc39f10d25dc638ea6f6  ./05_TOOLING/target/debug/.fingerprint/serde_core-b527563cb19990d8/build-script-build-script-build
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/.fingerprint/serde_core-b527563cb19990d8/invoked.timestamp
45ca3dc094d766ed810ad4e1105de64376154cccb77adee23f37f96c74efe22d  ./05_TOOLING/target/debug/incremental/teras_core-2rybwy381chp0/s-heqn0kf0dr-16bodxt-working/dep-graph.part.bin
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/incremental/teras_core-2rybwy381chp0/s-heqn0kf0dr-16bodxt.lock
ad03ed3fd5d3ef9b76a06deae0147a205373402154767b51060f7bdbf1a0a214  ./05_TOOLING/target/debug/build/num-traits-bcfe50daa15d0f5c/build_script_build-bcfe50daa15d0f5c
ad03ed3fd5d3ef9b76a06deae0147a205373402154767b51060f7bdbf1a0a214  ./05_TOOLING/target/debug/build/num-traits-bcfe50daa15d0f5c/build-script-build
557248e53c6d18b893e0a4422f2c4442cba7c44599cd8acb0460b82de57cbfd8  ./05_TOOLING/target/debug/build/num-traits-bcfe50daa15d0f5c/build_script_build-bcfe50daa15d0f5c.d
98f5c90cea33b460a1849e18d60980300c620cf9417c3ca3ff0b2928cb748886  ./05_TOOLING/target/debug/build/zmij-68255aaf5bbcd5d8/build_script_build-68255aaf5bbcd5d8.d
26486e7639688e17c0b3d9d9226a2c2c9a745395fb237d854f1af437953d4f43  ./05_TOOLING/target/debug/build/zmij-68255aaf5bbcd5d8/build-script-build
26486e7639688e17c0b3d9d9226a2c2c9a745395fb237d854f1af437953d4f43  ./05_TOOLING/target/debug/build/zmij-68255aaf5bbcd5d8/build_script_build-68255aaf5bbcd5d8
f8e9470772811a1bdcd201fb21e14cbf37a57d192b38cd98f66bd4a83442c26b  ./05_TOOLING/target/debug/build/serde-37d3e83438400c49/out/private.rs
fe045bb0b3986e82508dc02f10f7704ed2bf75e4cc02d874233e172221a080b1  ./05_TOOLING/target/debug/build/serde-37d3e83438400c49/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/serde-37d3e83438400c49/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/serde-37d3e83438400c49/stderr
fbefaabcc65c2512e804f217336578c3751a411d58efabf3d24b8a74e2072fbb  ./05_TOOLING/target/debug/build/serde-37d3e83438400c49/output
6e88a4f23285090588c53ed622e7286c1dd47073d822cbc54350c641e01827a1  ./05_TOOLING/target/debug/build/typenum-88c184e8314906b5/out/tests.rs
35bb0a5ed20f01c60dae6993ffb708479774a3520936633afd10ae82e43f7366  ./05_TOOLING/target/debug/build/typenum-88c184e8314906b5/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/typenum-88c184e8314906b5/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/typenum-88c184e8314906b5/stderr
7a428326ee000ef6286c61befa6cfa6e77fcf9b94415d8c78ce552a0e8a763d0  ./05_TOOLING/target/debug/build/typenum-88c184e8314906b5/output
3eebf776489d7d9d4b52354c30aafcf2a65e3302212b01b3cf2e31039be7217f  ./05_TOOLING/target/debug/build/proc-macro2-328772ad4132d55e/build-script-build
3eebf776489d7d9d4b52354c30aafcf2a65e3302212b01b3cf2e31039be7217f  ./05_TOOLING/target/debug/build/proc-macro2-328772ad4132d55e/build_script_build-328772ad4132d55e
f9ae60b34c9228cbb108e68d175ef373a2bed5fad42af2f5f0a38271da7865c0  ./05_TOOLING/target/debug/build/proc-macro2-328772ad4132d55e/build_script_build-328772ad4132d55e.d
27ad1b5fb4eebeb1da6419cbfad3ac1922ed1d817fcbab0a1dae1bdfd38d8307  ./05_TOOLING/target/debug/build/serde_core-1d20d4037d30c199/out/private.rs
c9fb76933378b289299e5229aa807a751d576d4a28068b3cd2de93b1a01dcd62  ./05_TOOLING/target/debug/build/serde_core-1d20d4037d30c199/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/serde_core-1d20d4037d30c199/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/serde_core-1d20d4037d30c199/stderr
b05731ace603d330b9a7aaf76b8433df15c3e1b2a3a95f4c644d5f5ed0c82f84  ./05_TOOLING/target/debug/build/serde_core-1d20d4037d30c199/output
331574ea2245bf3829024f986dff6a540afbd0dece7a0ef1f6d0ec89a60af75b  ./05_TOOLING/target/debug/build/quote-d84f5fa04b036a74/build-script-build
65decae605bf0932c51c602946149e3706ed89432aa8cfb15a5213ad2bcc6925  ./05_TOOLING/target/debug/build/quote-d84f5fa04b036a74/build_script_build-d84f5fa04b036a74.d
331574ea2245bf3829024f986dff6a540afbd0dece7a0ef1f6d0ec89a60af75b  ./05_TOOLING/target/debug/build/quote-d84f5fa04b036a74/build_script_build-d84f5fa04b036a74
d0f84efbc84aeb22a0246686a9871aa6038864511f4347a4cb6e5498377fa145  ./05_TOOLING/target/debug/build/libc-7e686221307a2539/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/libc-7e686221307a2539/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/libc-7e686221307a2539/stderr
240b954a10d14aa1075a7d90ec689c1c67e2ef0f392659e743b9ff2ed2b09b70  ./05_TOOLING/target/debug/build/libc-7e686221307a2539/output
425d6306bb6f811db4b81638c0f9e68d10798de0e7dc1924759cc69eae9e548a  ./05_TOOLING/target/debug/build/serde-09850bb34cca55a2/build-script-build
425d6306bb6f811db4b81638c0f9e68d10798de0e7dc1924759cc69eae9e548a  ./05_TOOLING/target/debug/build/serde-09850bb34cca55a2/build_script_build-09850bb34cca55a2
9fed9f3b8e5335cd454ce32a40db0e505370cacc86d15ad63a54b69450b41e2b  ./05_TOOLING/target/debug/build/serde-09850bb34cca55a2/build_script_build-09850bb34cca55a2.d
2588ad8e8594d78b60de301a280523a2b6614162d128fc5244c3fa5e676664ea  ./05_TOOLING/target/debug/build/zmij-1bf336ff377bb65b/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/zmij-1bf336ff377bb65b/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/zmij-1bf336ff377bb65b/stderr
8cf0cc5458ddbb299308a342e7f8f74bd1435babd1b1d129a1985495e95986c6  ./05_TOOLING/target/debug/build/zmij-1bf336ff377bb65b/output
4d0a2e14d7bdf67900ae2e747ea22749be6e8722ae4a95b84b80dff8ef809f49  ./05_TOOLING/target/debug/build/libc-2589e6fbe6d94c4c/build_script_build-2589e6fbe6d94c4c.d
c618c182c684cccf83382af09fb98574cec4c16c6914eb63ab77a7f60251d17d  ./05_TOOLING/target/debug/build/libc-2589e6fbe6d94c4c/build-script-build
c618c182c684cccf83382af09fb98574cec4c16c6914eb63ab77a7f60251d17d  ./05_TOOLING/target/debug/build/libc-2589e6fbe6d94c4c/build_script_build-2589e6fbe6d94c4c
d1be4bb7aec81cc8e2938c0c81a46daa506c5dd5b0cbf933cc25563f7b9de444  ./05_TOOLING/target/debug/build/quote-0a85777d612b6e85/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/quote-0a85777d612b6e85/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/quote-0a85777d612b6e85/stderr
e18aa0a6d8bc038d8be01c064d207eaefa1412edd991b27eb123b0664c53fecc  ./05_TOOLING/target/debug/build/quote-0a85777d612b6e85/output
260e0d721aa3fa4b96baac051a10aafe853eac54f254fa56a33e1bdd771d8bf9  ./05_TOOLING/target/debug/build/parking_lot_core-2433b751f559cef6/build_script_build-2433b751f559cef6
260e0d721aa3fa4b96baac051a10aafe853eac54f254fa56a33e1bdd771d8bf9  ./05_TOOLING/target/debug/build/parking_lot_core-2433b751f559cef6/build-script-build
4632de5a38fe91e02c2a3f2377b085bbe0d805d79546577e9c0e95995155615b  ./05_TOOLING/target/debug/build/parking_lot_core-2433b751f559cef6/build_script_build-2433b751f559cef6.d
3d090ca1d2dd582073fa736d201f1a7f8cb79f302ab010b2be1d2699ca8074be  ./05_TOOLING/target/debug/build/typenum-c39c03ff4de35ee8/build_script_build-c39c03ff4de35ee8
3d090ca1d2dd582073fa736d201f1a7f8cb79f302ab010b2be1d2699ca8074be  ./05_TOOLING/target/debug/build/typenum-c39c03ff4de35ee8/build-script-build
7e8022e69120aa2d4cfcb5a1e0cbb55fe2378c1f63eb904b377cea3d10370be1  ./05_TOOLING/target/debug/build/typenum-c39c03ff4de35ee8/build_script_build-c39c03ff4de35ee8.d
b2f7380ab4e601f41fca26160d0463410865aa86cede8306b4dc3658d6f28a57  ./05_TOOLING/target/debug/build/generic-array-b32fa9943e73849d/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/generic-array-b32fa9943e73849d/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/generic-array-b32fa9943e73849d/stderr
728ed3558e77726a99b8d4db0825e424cd99543ac81da7d80f84a5e04cf74869  ./05_TOOLING/target/debug/build/generic-array-b32fa9943e73849d/output
a55623be3ecad60d8e40217a2703439b418f772f50db1942159968279fa039b9  ./05_TOOLING/target/debug/build/proc-macro2-6952c77f561663e6/root-output
5a109e6643e8d3e88642e3f35e85d2a83e639d07523aa6e99166c48178e965c3  ./05_TOOLING/target/debug/build/proc-macro2-6952c77f561663e6/invoked.timestamp
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  ./05_TOOLING/target/debug/build/proc-macro2-6952c77f561663e6/stderr
de33fde236792562605f8861cb773c96cf48694087b821a4f20a7b27c60a3377  ./05_TOOLING/target/debug/build/proc-macro2-6952c77f561663e6/output
1f46378d79c1e3997740198ca6f015c67007f8c299e6191ff0cb4af529127679  ./05_TOOLING/target/debug/build/generic-array-873f0cb9f45cdc0a/build-script-build
e121c8386d98dea8830d71a4f33612c4ac3234c1ba788375fe1a9f014ba02518  ./05_TOOLING/target/debug/build/generic-array-873f0cb9f45cdc0a/build_script_build-873f0cb9f45cdc0a.d
1f46378d79c1e3997740198ca6f015c67007f8c299e6191ff0cb4af529127679  ./05_TOOLING/target/debug/build/generic-array-873f0cb9f45cdc0a/build_script_build-873f0cb9f45cdc0a
e3719fede7757a56f03c1b2c1f993b3f4b7ae1f1a403be7f604f397462f56715  ./05_TOOLING/target/debug/build/serde_core-b527563cb19990d8/build-script-build
e3719fede7757a56f03c1b2c1f993b3f4b7ae1f1a403be7f604f397462f56715  ./05_TOOLING/target/debug/build/serde_core-b527563cb19990d8/build_script_build-b527563cb19990d8
550890bda2432cfb4075cec13f1965fdf35ace1d154bd67906a50b54db38f639  ./05_TOOLING/target/debug/build/serde_core-b527563cb19990d8/build_script_build-b527563cb19990d8.d
54a2d8ef73fdefe1e198937df226d0cc73a504bee426b4fe9635089879936169  ./05_TOOLING/target/.rustc_info.json
6d9d1d216e0f83abc5e5662ca62c92b4f23009466b54fa27321a69acdb778bb2  ./05_TOOLING/target/CACHEDIR.TAG
ae2a91469b666af26e46bad55424cbb44ae8130a6d6bbc8f64769c673bfc02f3  ./05_TOOLING/rust-toolchain.toml
f40ee56ee1801d5f5a8827a9d124d0593bd039d3550cfdd3d32bd290f7e252bd  ./05_TOOLING/Cargo.toml
75cbcbd3acd776afad5f64a22118cd23c2196eca4cd009db99281b527a062026  ./05_TOOLING/ada/gnatprove.adc
5dc0780c55e5690cd70155c703227821d8f7cc455f3ecc5ca81517e1b9117cef  ./05_TOOLING/ada/teras.gpr
775977efad81709f418914670323f2389b773c9e06fe967f2afb258855079b28  ./05_TOOLING/ada/src/teras.ads
0f4853f93e6cb389d1fe18b09f61b81f35bc74f6264e49e4ad998a95b889f3fb  ./05_TOOLING/ada/src/crypto/teras-crypto.ads
a1cb4c2eeddc0ff99e292b16b65df51fd7beb5799dff2bdedacc1c3b236b8eee  ./05_TOOLING/ada/src/crypto/teras-crypto-aes.ads
e4b2615982a965e0726286b051a12c89eac935bd261f74f73462e2a3da6d27ca  ./05_TOOLING/tools/artifact-sign/Cargo.toml
037bf098c84e0203d7c540af2499d6a9153bd0085e3813567a4c68990a003ea8  ./05_TOOLING/tools/artifact-sign/src/main.rs
23824c50ec82c43befe2ceedff2ca8a3555d8c9e280fd19d87fa3b0fa295c56e  ./05_TOOLING/tools/hash-chain/Cargo.toml
a33d86d6b37135c474ecf173861937af34b2bae34c0785cb6f1d143a4fe17f92  ./05_TOOLING/tools/hash-chain/src/main.rs
7f5667b629d836a722360c32a4b7bd447d8eeac297d6af448816285a15216632  ./05_TOOLING/tools/build-manifest/Cargo.toml
96fe53f3da544befb596f7c3234748cab0963a22d28d98e7440cb2659c928f12  ./05_TOOLING/tools/build-manifest/src/main.rs
798e4d089411e590480abb6c10bf6b3df109a295714025fcadf68405b9815940  ./05_TOOLING/scripts/verify.sh
d8353b979653141ce4a4be79294982ea3029fc83a0b926b4c76cc4772ae4aa1e  ./05_TOOLING/docker/Dockerfile.dev
27c252b3f7cf61c36e4dd954a8754956f632c7684c160a0049deb43792170e86  ./05_TOOLING/Cargo.lock
```
