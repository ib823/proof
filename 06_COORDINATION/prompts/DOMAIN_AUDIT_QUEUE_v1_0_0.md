# RIINA Domain Audit Queue v1.0.0

This file is an operational queue for the domain-audit program. It does not replace [RIINA_MASTER_PLAN.md](/workspaces/proof/RIINA_MASTER_PLAN.md) and does not grant planning authority.

## Command-Derived Baseline

- Top-level auditable research domains: `79`
  - derived from:
    - `find 01_RESEARCH -maxdepth 1 -mindepth 1 -type d | grep '/[0-9][0-9]_DOMAIN_' | wc -l`
- Known confirmed child-domain expansions already defined:
  - `AN_SYARIAH`: `9` child domains
  - `AO_BLOCKCHAIN`: `7` child domains
- Known umbrella re-audits after child domains become real:
  - `AN_SYARIAH`
  - `AO_BLOCKCHAIN`

## Current Known Program Size

- Umbrella audit floor: `79`
- Known extra child-domain audits: `16`
- Known umbrella re-audits: `2`
- Current known minimum primary audits: `97`
- If every audit gets a hostile review, current known minimum total runs: `194`

This is a floor, not a ceiling. Other broad umbrellas may need child-domain splits after their first hostile review.

## Single-Worker Rule

If you insist on one worker platform, use one platform only:
- recommended: `Codex app`

But do not use one endless conversation for all `97+` audits.

Use this model instead:
1. one worker platform
2. one reusable master prompt pack
3. one fresh thread per domain
4. one saved audit artifact per domain
5. one hostile review pass per domain
6. one methodology-corrections file carried forward between threads

This still counts as a single-worker operating model while avoiding context drift.

## Queue Status Legend

- `READY`: not yet audited in this program
- `DONE_REVIEWED`: umbrella audit and hostile review both completed
- `DONE_AUDIT_ONLY`: umbrella audit exists, hostile review not yet materialized cleanly in-repo
- `SPLIT_CONFIRMED`: child-domain expansion already defined in remediation docs
- `SPLIT_PROBABLE`: breadth suggests likely later split, but not yet confirmed by remediation package

## Umbrella Audit Queue

1. `A_TYPE_THEORY` — `READY`
2. `B_EFFECT_SYSTEMS` — `READY`
3. `C_INFORMATION_FLOW_CONTROL` — `READY`
4. `D_HARDWARE_AND_CAPABILITY_SECURITY` — `READY`
5. `E_FORMAL_VERIFICATION` — `READY`
6. `F_MEMORY_SAFETY` — `READY`
7. `G_CRYPTO_AND_SIDECHANNEL` — `READY`
8. `H_CONCURRENCY_AND_POLICY` — `READY`
9. `I_ERROR_HANDLING_AND_OS_SECURITY` — `READY`
10. `J_MODULE_SYSTEMS` — `READY`
11. `K_METAPROGRAMMING_AND_EXISTING_SYSTEMS` — `READY`
12. `L_FFI_AND_ATTACK_RESEARCH` — `READY`
13. `M_TESTING_QA` — `READY`
14. `N_TOOLING_IDE` — `READY`
15. `O_RUNTIME_EXECUTION` — `READY`
16. `P_STANDARD_LIBRARY` — `READY`
17. `Q_COMPILER_ARCHITECTURE` — `READY`
18. `R_CERTIFIED_COMPILATION` — `READY`
19. `S_HARDWARE_CONTRACTS` — `READY`
20. `T_HERMETIC_BUILD` — `READY`
21. `U_RUNTIME_GUARDIAN` — `READY`
22. `V_TERMINATION_GUARANTEES` — `READY`
23. `W_VERIFIED_MEMORY` — `READY`
24. `X_CONCURRENCY_MODEL` — `READY`
25. `Y_VERIFIED_STDLIB` — `READY`
26. `Z_DECLASSIFICATION_POLICY` — `READY`
27. `SIGMA_VERIFIED_STORAGE` — `READY`
28. `TOTAL_STACK` — `READY`, `SPLIT_PROBABLE`
29. `PI_VERIFIED_PERFORMANCE` — `READY`
30. `RIINA_OS` — `READY`, `SPLIT_PROBABLE`
31. `DELTA_VERIFIED_DISTRIBUTION` — `READY`
32. `RIINA_NET` — `READY`, `SPLIT_PROBABLE`
33. `OMEGA_NETWORK_DEFENSE` — `READY`
34. `RIINA_RUNTIME` — `READY`, `SPLIT_PROBABLE`
35. `PSI_OPERATIONAL_SECURITY` — `READY`
36. `RIINA_UX` — `READY`, `SPLIT_PROBABLE`
37. `CHI_METADATA_PRIVACY` — `READY`
38. `RIINA_PHYSICS` — `READY`
39. `ETA_TRAFFIC_RESISTANCE` — `READY`
40. `RIINA_INFRA` — `READY`, `SPLIT_PROBABLE`
41. `IOTA_ANONYMOUS_COMM` — `READY`
42. `RIINA_BANK` — `READY`, `SPLIT_PROBABLE`
43. `KAPPA_FULLSTACK` — `READY`
44. `RIINA_WALLET` — `READY`
45. `LAMBDA_MOBILE_PLATFORM` — `READY`
46. `RIINA_REMIT` — `READY`
47. `MU_ENTERPRISE_ERP` — `READY`, `SPLIT_PROBABLE`
48. `RIINA_HIS` — `READY`
49. `NU_VERIFIED_AI_ML` — `READY`, `SPLIT_PROBABLE`
50. `RIINA_ESG` — `READY`
51. `PHI_VERIFIED_HARDWARE` — `READY`
52. `RIINA_CAPITAL_MARKETS` — `READY`, `SPLIT_PROBABLE`
53. `RIINA_MOBILE_OS` — `READY`, `SPLIT_PROBABLE`
54. `THETA_RADIATION_HARDENING` — `READY`
55. `ANTIJAM_ANTI_JAMMING` — `READY`
56. `XI_SENSOR_FUSION` — `READY`
57. `RHO_VERIFIED_AUTONOMY` — `READY`, `SPLIT_PROBABLE`
58. `TAU_MESH_NETWORKING` — `READY`
59. `UPSILON_SELF_HEALING` — `READY`
60. `AA_VERIFIED_IDENTITY` — `READY`
61. `AB_SUPPLY_CHAIN` — `READY`
62. `AC_COVERT_CHANNELS` — `READY`
63. `AD_TIME_SECURITY` — `READY`
64. `AE_VERIFIED_AUDIT` — `READY`, `SPLIT_PROBABLE`
65. `AF_SECURE_UPDATES` — `READY`
66. `AG_KEY_LIFECYCLE` — `READY`
67. `AH_VERIFIED_PROTOCOLS` — `READY`
68. `AI_VERIFIED_ISOLATION` — `READY`
69. `AJ_VERIFIED_COMPLIANCE` — `READY`, `SPLIT_PROBABLE`
70. `AK_VERIFIED_PROCUREMENT` — `READY`, `SPLIT_PROBABLE`
71. `AL_VERIFIED_LAYOUT` — `READY`, `SPLIT_PROBABLE`
72. `AM_AI_FIRST_LANGUAGE` — `READY`
73. `AN_SYARIAH` — `DONE_REVIEWED`, `SPLIT_CONFIRMED`
74. `AO_BLOCKCHAIN` — `DONE_AUDIT_ONLY`, `SPLIT_CONFIRMED`
75. `AP_QUANTUM_COMPUTING_INTEGRATION` — `READY`
76. `AQ_CONCURRENT_DISTRIBUTED_VERIFICATION` — `READY`
77. `AR_HARDWARE_SOFTWARE_COVERIFICATION` — `READY`
78. `AS_POST_QUANTUM_CRYPTOGRAPHY` — `READY`
79. `AT_AI_ML_SAFETY_VERIFICATION` — `READY`

## Confirmed Child-Domain Expansion Queue

### `AN_SYARIAH`

1. `AN_SYARIAH_ZAKAT`
2. `AN_SYARIAH_SCREENING_PURIFICATION`
3. `AN_SYARIAH_SUKUK`
4. `AN_SYARIAH_MUDARABAH`
5. `AN_SYARIAH_MUSHARAKAH`
6. `AN_SYARIAH_TAKAFUL`
7. `AN_SYARIAH_WAKAF`
8. `AN_SYARIAH_GOVERNANCE_PROFILES`
9. `AN_SYARIAH_INTEGRATION`
10. Umbrella re-audit: `AN_SYARIAH`

### `AO_BLOCKCHAIN`

1. `AO_EXECUTION_RECEIPTS`
2. `AO_CONTENT_ADDRESSED_STATE`
3. `AO_MERKLE_DAG`
4. `AO_TOKEN_ACCOUNTING`
5. `AO_SMART_CONTRACT_RUNTIME`
6. `AO_CONSENSUS_CORE`
7. `AO_BLOCKCHAIN_INTEGRATION`
8. Umbrella re-audit: `AO_BLOCKCHAIN`

## Recommended Execution Order

### Phase 1: Finish current high-risk umbrellas first

1. reconcile `AO_BLOCKCHAIN` hostile review into the repo
2. audit `AE_VERIFIED_AUDIT`
3. audit `AJ_VERIFIED_COMPLIANCE`
4. audit `AK_VERIFIED_PROCUREMENT`
5. audit `AL_VERIFIED_LAYOUT`
6. audit `RIINA_BANK`
7. audit `RIINA_CAPITAL_MARKETS`
8. audit `RIINA_MOBILE_OS`

### Phase 2: Sweep the remaining umbrellas in numeric order

After the high-risk set, run the rest in the exact umbrella order listed above.

### Phase 3: Start child-domain remediation audits

Run child-domain audits only after the umbrella sweep is complete, starting with:
1. `AO_EXECUTION_RECEIPTS`
2. `AN_SYARIAH_ZAKAT`

## Hard Rule For Exhaustiveness

You are not done when the audit count reaches `79`.

You are done only when:
- all `79` umbrella audits have hostile reviews
- every confirmed child-domain expansion has its own audit and hostile review
- every split-confirmed umbrella has been re-audited after child domains mature
- public wording has been reconciled to the weakest real link

## Best Single-Worker Operating Cadence

Per domain:
1. pin `HEAD`
2. run primary audit
3. save audit artifact
4. run hostile review
5. reconcile rating if the review downgrades it
6. save handoff block naming the next domain
7. open a fresh thread for the next domain

Every 10 domains:
1. review methodology drift
2. update the shared prompt pack only if hostile reviews exposed repeat defects
3. continue
