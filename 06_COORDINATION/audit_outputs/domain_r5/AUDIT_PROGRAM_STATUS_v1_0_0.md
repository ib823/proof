# RIINA Audit Program Status v1.0.0

This file is the live status tracker for the domain-audit program. It is not a replacement for [RIINA_MASTER_PLAN.md](/workspaces/proof/RIINA_MASTER_PLAN.md) and does not grant planning authority.

Audit method authority:
- [DOMAIN_R5_CHECKLIST_v1_0_0.md](/workspaces/proof/04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md)
- [DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md](/workspaces/proof/04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md)
- [DOMAIN_AUDIT_QUEUE_v1_0_0.md](/workspaces/proof/06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md)

Tracker snapshot:
- Tracker commit when written: `5e861d69924fd904619cc56f2a6734d571ccbb06`
- Program floor from queue:
  - `79` umbrella audits
  - `16` confirmed child-domain audits
  - `2` umbrella re-audits
  - current known minimum primary audits: `97`
  - current known minimum total runs with hostile review: `194`

## Current Counters

| Counter | Value | Basis |
|--------|-------|-------|
| Umbrella audits started | `79 / 79` | All 79 umbrella audits have primary audit artifacts |
| Umbrella audits fully closed | `37 / 79` | 37 domains closed (hostile reviewed + reconciled + remediated) |
| Umbrella audits awaiting hostile review | `42 / 79` | PI_VERIFIED_PERFORMANCE through AT_AI_ML_SAFETY_VERIFICATION (Gemini + Codex quota exhausted — Codex resets Mar 26) |
| Child-domain audits started | `0 / 16 confirmed` | none yet |
| Child-domain audits fully closed | `0 / 16 confirmed` | none yet |
| Umbrella re-audits completed | `0 / 2 confirmed` | none yet |

## Domain Status Table

| Domain ID | Domain name | Scope class | Primary audit artifact | Hostile review artifact | Audit reconciled in repo? | Remediation package? | Current honest rating in repo | Audit snapshot commit | Current status | Next required action |
|----------|-------------|-------------|------------------------|-------------------------|---------------------------|----------------------|-------------------------------|----------------------|----------------|----------------------|
| `AN_SYARIAH` | Syariah Compliance | Umbrella | [AN_SYARIAH_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_AUDIT.md) | [AN_SYARIAH_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AN_SYARIAH_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/AN_SYARIAH/README.md) | `R1` | `2005b8471995f6610bd9c841569154e3343ab247` | `CLOSED` | Start future child-domain audits from `AN_SYARIAH_ZAKAT` when ready |
| `AO_BLOCKCHAIN` | Blockchain Primitives | Umbrella | [AO_BLOCKCHAIN_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_AUDIT.md) | [AO_BLOCKCHAIN_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AO_BLOCKCHAIN_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/AO_BLOCKCHAIN/README.md) | `R1` | `93ad08b8684ae7a2d3e94b35c6308f218c60f132` | `CLOSED` | Start future child-domain audits from `AO_EXECUTION_RECEIPTS` when the umbrella sweep reaches child-domain phase |
| `AE_VERIFIED_AUDIT` | Verified Audit | Umbrella | [AE_VERIFIED_AUDIT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AE_VERIFIED_AUDIT_R5_AUDIT.md) | [AE_VERIFIED_AUDIT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AE_VERIFIED_AUDIT_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/AE_VERIFIED_AUDIT/README.md) | `R1` | `0293b678480d19c92843c34b2a25306bca54eb60` | `CLOSED` | Revisit after `Audit`-effect and append-only runtime remediation changes land |
| `AJ_VERIFIED_COMPLIANCE` | Verified Compliance | Umbrella | [AJ_VERIFIED_COMPLIANCE_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AJ_VERIFIED_COMPLIANCE_R5_AUDIT.md) | [AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/AJ_VERIFIED_COMPLIANCE/README.md) | `R1` | `0293b678480d19c92843c34b2a25306bca54eb60` | `CLOSED` | Revisit after bounded frontend compliance semantics and executable canonical workflows land |
| `AK_VERIFIED_PROCUREMENT` | Verified Procurement | Umbrella | [AK_VERIFIED_PROCUREMENT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AK_VERIFIED_PROCUREMENT_R5_AUDIT.md) | [AK_VERIFIED_PROCUREMENT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AK_VERIFIED_PROCUREMENT_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/AK_VERIFIED_PROCUREMENT/README.md) | `R1` | `0293b678480d19c92843c34b2a25306bca54eb60` | `CLOSED` | Revisit after a bounded live procurement slice, executable example coverage, and a real Coq lane exist |
| `AL_VERIFIED_LAYOUT` | Verified Layout | Umbrella | [AL_VERIFIED_LAYOUT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AL_VERIFIED_LAYOUT_R5_AUDIT.md) | [AL_VERIFIED_LAYOUT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AL_VERIFIED_LAYOUT_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/AL_VERIFIED_LAYOUT/README.md) | `R2` | `0293b678480d19c92843c34b2a25306bca54eb60` | `CLOSED` | Revisit after renderer integration, repaired canonical examples, and reduced public wording land |
| `RIINA_BANK` | RIINA-BANK | Umbrella | [RIINA_BANK_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_BANK_R5_AUDIT.md) | [RIINA_BANK_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_BANK_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/RIINA_BANK/README.md) | `R2` | `0293b678480d19c92843c34b2a25306bca54eb60` | `CLOSED` | Revisit after bounded live banking semantics, executable examples, and purged overclaim/generator noise land |
| `RIINA_CAPITAL_MARKETS` | RIINA Capital Markets | Umbrella | [RIINA_CAPITAL_MARKETS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_CAPITAL_MARKETS_R5_AUDIT.md) | [RIINA_CAPITAL_MARKETS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_CAPITAL_MARKETS_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/RIINA_CAPITAL_MARKETS/README.md) | `R2` | `5e861d69924fd904619cc56f2a6734d571ccbb06` | `CLOSED` | Revisit after bounded live order/trade/settlement semantics, executable examples, and reduced public wording land |
| `RIINA_MOBILE_OS` | RIINA Mobile OS | Umbrella | [RIINA_MOBILE_OS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_MOBILE_OS_R5_AUDIT.md) | [RIINA_MOBILE_OS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_MOBILE_OS_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/RIINA_MOBILE_OS/README.md) | `R2` | `5e861d69924fd904619cc56f2a6734d571ccbb06` | `CLOSED` | Revisit after bounded mobile bridges, OS primitives, and TERAS integration child domains become real and public wording is reduced accordingly |
| `A_TYPE_THEORY` | Type Theory Foundations | Umbrella | [A_TYPE_THEORY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/A_TYPE_THEORY_R5_AUDIT.md) | [A_TYPE_THEORY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/A_TYPE_THEORY_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/A_TYPE_THEORY/README.md) | `R2` | `5e861d69924fd904619cc56f2a6734d571ccbb06` | `CLOSED` | Revisit after `A_TYPE_THEORY_CORE` is scoped, canonical examples are repaired, and the umbrella is decomposed honestly |
| `B_EFFECT_SYSTEMS` | Effect Systems | Umbrella | [B_EFFECT_SYSTEMS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_AUDIT.md) | [B_EFFECT_SYSTEMS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/B_EFFECT_SYSTEMS/README.md) | `R3` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Revisit after .rii example integration tests, expanded adversarial tests, canonical workflow inventory, and explicit threat model are added |
| `C_INFORMATION_FLOW_CONTROL` | Information Flow Control | Umbrella | [C_INFORMATION_FLOW_CONTROL_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/C_INFORMATION_FLOW_CONTROL_R5_AUDIT.md) | [C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/C_INFORMATION_FLOW_CONTROL/README.md) | `R3` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Revisit after .rii example integration tests, consolidated threat model, and consolidated boundary document are added |
| `D_HARDWARE_AND_CAPABILITY_SECURITY` | Hardware and Capability Security | Umbrella | [D_HARDWARE_AND_CAPABILITY_SECURITY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/D_HARDWARE_AND_CAPABILITY_SECURITY_R5_AUDIT.md) | [D_HARDWARE_AND_CAPABILITY_SECURITY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/D_HARDWARE_AND_CAPABILITY_SECURITY_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/D_HARDWARE_AND_CAPABILITY_SECURITY/README.md) | `R1` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Hostile review rejected audit (vacuous Coq proofs). Downgraded to R1. Revisit after Coq proofs rewritten with nontrivial properties |
| `E_FORMAL_VERIFICATION` | Formal Verification | Umbrella | [E_FORMAL_VERIFICATION_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/E_FORMAL_VERIFICATION_R5_AUDIT.md) | [E_FORMAL_VERIFICATION_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/E_FORMAL_VERIFICATION_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/E_FORMAL_VERIFICATION/README.md) | `R3` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Revisit after vacuity detection tool, pipeline workflow documentation, and pipeline threat model |
| `F_MEMORY_SAFETY` | Memory Safety | Umbrella | [F_MEMORY_SAFETY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/F_MEMORY_SAFETY_R5_AUDIT.md) | [F_MEMORY_SAFETY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/F_MEMORY_SAFETY_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/F_MEMORY_SAFETY/README.md) | `R3` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Revisit after scope clarification (enforced vs formal-only) and .rii example tests |
| `G_CRYPTO_AND_SIDECHANNEL` | Crypto and Side-Channel | Umbrella | [G_CRYPTO_AND_SIDECHANNEL_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/G_CRYPTO_AND_SIDECHANNEL_R5_AUDIT.md) | [G_CRYPTO_AND_SIDECHANNEL_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/G_CRYPTO_AND_SIDECHANNEL_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/G_CRYPTO_AND_SIDECHANNEL/README.md) | `R2` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Hostile review rejected (vacuous Coq). Downgraded to R2. CT enforcement real but Coq layer is boolean stubs |
| `H_CONCURRENCY_AND_POLICY` | Concurrency and Policy | Umbrella | [H_CONCURRENCY_AND_POLICY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/H_CONCURRENCY_AND_POLICY_R5_AUDIT.md) | [H_CONCURRENCY_AND_POLICY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/H_CONCURRENCY_AND_POLICY_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/H_CONCURRENCY_AND_POLICY/README.md) | `R2` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Hostile review rejected (False stubs). Downgraded to R2. Actor/session enforcement real but Coq deadlock/race model vacuous |
| `I_ERROR_HANDLING_AND_OS_SECURITY` | Error Handling and OS Security | Umbrella | [I_ERROR_HANDLING_AND_OS_SECURITY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/I_ERROR_HANDLING_AND_OS_SECURITY_R5_AUDIT.md) | [I_ERROR_HANDLING_AND_OS_SECURITY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/I_ERROR_HANDLING_AND_OS_SECURITY_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/I_ERROR_HANDLING_AND_OS_SECURITY/README.md) | `R2` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Hostile review rejected. Downgraded to R2 |
| `J_MODULE_SYSTEMS` | Module Systems | Umbrella | [J_MODULE_SYSTEMS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/J_MODULE_SYSTEMS_R5_AUDIT.md) | [J_MODULE_SYSTEMS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/J_MODULE_SYSTEMS_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/J_MODULE_SYSTEMS/README.md) | `R1` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | Parser skips module keywords. Downgraded to R1 |
| `K_METAPROGRAMMING_AND_EXISTING_SYSTEMS` | Metaprogramming | Umbrella | [K_METAPROGRAMMING_AND_EXISTING_SYSTEMS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/K_METAPROGRAMMING_AND_EXISTING_SYSTEMS_R5_AUDIT.md) | [K_METAPROGRAMMING_AND_EXISTING_SYSTEMS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/K_METAPROGRAMMING_AND_EXISTING_SYSTEMS_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/K_METAPROGRAMMING_AND_EXISTING_SYSTEMS/README.md) | `R1` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | R1 |
| `L_FFI_AND_ATTACK_RESEARCH` | FFI and Attack Research | Umbrella | [L_FFI_AND_ATTACK_RESEARCH_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/L_FFI_AND_ATTACK_RESEARCH_R5_AUDIT.md) | [L_FFI_AND_ATTACK_RESEARCH_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/L_FFI_AND_ATTACK_RESEARCH_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/L_FFI_AND_ATTACK_RESEARCH/README.md) | `R2` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | R2 |
| `M_TESTING_QA` | Testing and QA | Umbrella | [M_TESTING_QA_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/M_TESTING_QA_R5_AUDIT.md) | [M_TESTING_QA_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/M_TESTING_QA_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/M_TESTING_QA/README.md) | `R3` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | R3 |
| `N_TOOLING_IDE` | Tooling and IDE | Umbrella | [N_TOOLING_IDE_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/N_TOOLING_IDE_R5_AUDIT.md) | [N_TOOLING_IDE_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/N_TOOLING_IDE_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/N_TOOLING_IDE/README.md) | `R1` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | R1 |
| `O_RUNTIME_EXECUTION` | Runtime Execution | Umbrella | [O_RUNTIME_EXECUTION_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/O_RUNTIME_EXECUTION_R5_AUDIT.md) | [O_RUNTIME_EXECUTION_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/O_RUNTIME_EXECUTION_R5_REVIEW.md) | Yes | [README.md](/workspaces/proof/06_COORDINATION/remediation/O_RUNTIME_EXECUTION/README.md) | `R2` | `2d436b083b56005b101f18718a7bd0f0aab722e9` | `CLOSED` | R2. Hostile review overclaimed R4 — rejected upward. 542 real tests, vacuous Coq |

## Clear State So Far

| Area | What is true now |
|------|------------------|
| `AN_SYARIAH` | Primary audit completed, hostile review completed, audit reconciled downward, remediation package created, domain is closed at `R1` until real evidence changes |
| `AO_BLOCKCHAIN` | Primary audit completed, hostile review completed, audit reconciled downward, remediation package created, domain is closed at `R1` until real evidence changes |
| `AE_VERIFIED_AUDIT` | Primary audit completed, hostile review completed, review accepted, remediation package created, domain is closed at `R1` until real `Audit`-effect and append-only runtime changes land |
| `AJ_VERIFIED_COMPLIANCE` | Primary audit completed, hostile review completed, review accepted, remediation package created, domain is closed at `R1` until bounded frontend compliance semantics and executable canonical workflows land |
| `AK_VERIFIED_PROCUREMENT` | Primary audit completed, hostile review completed, review accepted, remediation package created, domain is closed at `R1` until a bounded live procurement slice, executable example coverage, and a real Coq lane land |
| `AL_VERIFIED_LAYOUT` | Primary audit completed, hostile review completed, review accepted, remediation package created, domain is closed at `R2` until renderer integration, repaired canonical examples, and reduced public wording land |
| `RIINA_BANK` | Primary audit completed, hostile review completed with reductions, remediation package created, domain is closed at `R2` until bounded live banking semantics, executable examples, and purged overclaim/generator noise land |
| `RIINA_CAPITAL_MARKETS` | Primary audit completed, hostile review completed, remediation package created, domain is closed at `R2` until bounded live order/trade/settlement semantics, executable examples, and reduced public wording land |
| `RIINA_MOBILE_OS` | Primary audit completed, hostile review completed, remediation package created, domain is closed at `R2` until bounded mobile bridges, OS primitives, TERAS/runtime integration, and reduced public wording justify re-audit |
| `A_TYPE_THEORY` | Primary audit completed, hostile review downgraded the umbrella to `R2`, remediation package created, and the first serious child-domain target is now `A_TYPE_THEORY_CORE` |
| `B_EFFECT_SYSTEMS` | Primary audit completed at `R3`, hostile review accepted with no reductions (Gemini CLI v0.34.0), reconciled, remediation package created, domain is closed at `R3` until .rii example integration tests, expanded adversarial tests, canonical workflow inventory, and explicit threat model are added |
| `C_INFORMATION_FLOW_CONTROL` | Primary audit completed at `R3`, hostile review accepted with no reductions (Gemini CLI v0.34.0), reconciled, remediation package created, domain is closed at `R3` until .rii example integration tests, consolidated threat model, and consolidated boundary document are added |
| `D_HARDWARE_AND_CAPABILITY_SECURITY` | Primary audit rated R2, hostile review **rejected** and downgraded to R1 (Gemini CLI v0.34.0). All 255 Coq theorems are vacuous (prove `True` or `true = true`). Reconciled to R1. Remediation requires rewriting Coq proofs with nontrivial properties |
| `E_FORMAL_VERIFICATION` | Primary audit completed at `R3`, hostile review accepted (Gemini CLI v0.34.0), reconciled, remediation package created. Core type safety proofs verified nontrivial. Closed at R3 until vacuity detection tool is built |
| `F_MEMORY_SAFETY` | Primary audit completed at `R3`, hostile review accepted (Gemini CLI v0.34.0), reconciled, remediation package created. Closed at R3 — linearity enforced, spatial formal-only |
| `G_CRYPTO_AND_SIDECHANNEL` | Primary audit rated R3, hostile review **rejected** (Claude CLI fallback). All 428 Coq domain theorems vacuous boolean stubs. CT type enforcement real but Coq layer bogus. Downgraded to R2. Missed ~130+ riina-core crypto tests |
| `H_CONCURRENCY_AND_POLICY` | Primary audit rated R3, hostile review **rejected** (Gemini CLI). Coq concurrency predicates are `False` stubs. Actor/session Rust enforcement real. Downgraded to R2 |
| `I_ERROR_HANDLING_AND_OS_SECURITY` | Primary audit rated R3, hostile review **rejected** (Gemini CLI). TerasSecurity.v and SQLInjectionPrevention.v are boolean stubs. Downgraded to R2. Injection enforcement real (44 tests) |
| `J_MODULE_SYSTEMS` | Primary audit rated R3, hostile review **rejected** (Gemini CLI). Parser skips modul/guna ("no module system yet"). Coq is definitional unfolding. riina-pkg is a package manager, not modules. Downgraded to R1 |
| `K_METAPROGRAMMING_AND_EXISTING_SYSTEMS` | Closed at R1. No implementation, vacuous Coq. Hostile review accepted |
| `L_FFI_AND_ATTACK_RESEARCH` | Closed at R2 |
| `M_TESTING_QA` | Closed at R3 (Gemini confirmed) |
| `N_TOOLING_IDE` | Closed at R1 |
| `O_RUNTIME_EXECUTION` | Closed at R2. Hostile review overclaimed R4 — rejected upward |
| Queue discipline | `O_RUNTIME_EXECUTION` closed. Next: `P_STANDARD_LIBRARY` |

## Update Protocol

Update this file after every domain cycle.

### When a primary audit is created

1. Add or update the row.
2. Set:
   - `Primary audit artifact` to the new file path
   - `Hostile review artifact` to `pending`
   - `Audit reconciled in repo?` to `No`
   - `Current status` to `AUDIT_ONLY`
3. Increment:
   - `Umbrella audits started` or `Child-domain audits started`

### When a hostile review is completed

1. Replace `pending` with the review file path.
2. If the review is accepted without rating change:
   - set `Current status` to `REVIEWED_PENDING_RECONCILIATION`
3. If the review downgrades or materially changes the audit:
   - set `Current status` to `REVIEWED_NEEDS_RECONCILIATION`

### When the audit is reconciled in-repo

1. Set `Audit reconciled in repo?` to `Yes`.
2. Set `Current honest rating in repo` to the final reconciled rating.
3. If remediation docs are needed and created:
   - set `Remediation package?` to the package README path
4. Set `Current status`:
   - `CLOSED` if the domain is done for now
   - `SPLIT_PENDING` if the umbrella is now waiting on child domains

### When a child-domain remediation audit starts

1. Add a new row for the child domain.
2. Use `Scope class = Child domain`.
3. Keep the umbrella row open until the child-domain program justifies re-audit.

### When an umbrella re-audit happens

1. Update the existing umbrella row, do not create a duplicate row.
2. Replace the audit/review artifact paths with the new re-audit artifacts or add a note in the status cell.
3. Update the rating and status based on the re-audit result.

## Closure Rule

A domain is only `CLOSED` when:
- primary audit artifact exists
- hostile review artifact exists in-repo
- audit has been reconciled in-repo
- remediation package exists if the domain required one
- next action for that domain is not "finish the current audit cycle"

Until then, the domain is not closed and should block the next new primary audit under the strict queue model.
