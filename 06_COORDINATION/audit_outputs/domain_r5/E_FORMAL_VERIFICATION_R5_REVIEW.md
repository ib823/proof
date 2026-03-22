# Domain Audit Review

## Verdict

**accept**

## Snapshot validation

- **Branch:** `main`
- **Commit:** `2d436b083b56005b101f18718a7bd0f0aab722e9`
- **Is valid for this snapshot:** Yes
- **Drift analysis:** The current HEAD matches the exact snapshot commit. The untracked files are audit documents, prompts, and scripts that do not impact the domain evidence surface. The review remains materially valid.

## Maximum honest rating

**R3**
The core type safety proofs (`Progress.v`, `Preservation.v`, `TypeSafety.v`) are structurally sound and nontrivial, enforcing a robust formal base for verification. The audit correctly identifies the missing vacuity detection as a critical gap blocking R4 promotion. The F* files and other generated lanes contain stubbed/vacuous proofs (`admit ()`), but the audit rightly excludes them from the core evidence, successfully isolating the genuine proofs.

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| `G1` Canonical Identity | Pass | Pass | Agree | Explicit canonical references (`RESEARCH_DOMAIN_E_COMPLETE.md`, folders) correctly map to the domain. | Foundation is solid. |
| `G2` Boundary Precision | Pass | Pass | Agree | Scope accurately isolates the formal verification infrastructure and correctly excludes individual domain formalization. | Boundary enforced safely. |
| `G3` Workflow Inventory | Partial | Partial | Agree | Transpiler validation workflow lacks documentation. | Needs workflow documentation for the generation pipeline. |
| `G4` Threat and Failure Model | Partial | Partial | Agree | Pipeline integrity lacks an explicit threat model. Vacuity is flagged as a threat based on previous audits. | Risk is acknowledged but requires a formal threat model doc. |
| `G5` Property Set | Pass | Pass | Agree | Properties span core PL metatheory (progress, preservation, canonical forms). | Complete property specification. |
| `G6` Formal Model Depth | Pass | Pass | Agree | 241+ Qed across core infrastructure files. A manual inspection confirms induction, case analysis, and valid proof structures in these core files. | Legitimate evidence of R3 depth. |
| `G7` Toolchain Enforcement | Pass | Pass | Agree | Coq kernel and pre-commit checks strictly enforce compilation and prevent `Admitted` proofs in core files. | Solid mechanical enforcement. |
| `G8` Executable Evidence | Pass | Pass | Agree | `.vo` files are built, Rust tests pass cleanly, and the pipeline scripts are verified executable. | Reproducibility confirmed. |
| `G9` Adversarial Coverage | Partial | Partial | Agree | The audit appropriately self-identifies the missing vacuity detection tool (exposed by D_HARDWARE). | Major blocking gap for R4. |
| `G10` Evidence Honesty Across Prover Lanes | Pass | Pass | Agree | The audit explicitly disclaims non-Coq prover lanes as auto-generated (F* contains `admit ()`, etc.) and does not inflate its rating based on them. | High transparency and safety. |
| `G11` Observability and Auditability | Pass | Pass | Agree | Traceability from theorems to Coq build artifacts is strong. | Clear verification path. |
| `G12` Freshness and Reproducibility | Pass | Pass | Agree | Counts and builds are verified as currently reproducible on HEAD. | Reliable evidence baseline. |
| `G13` Public Claim Discipline | Not audited | Not audited | Agree | Standard for this review level. | N/A |
| `G14` Regression Immunity | Partial | Partial | Agree | CI tests and Coq builds are present, but lack regression defenses specifically against vacuous proof injections. | Hook-gated regression holds for structural failures only. |

## Findings table

| Severity | Gate | Claim Under Dispute | Counter-Evidence | Required Downgrade or Correction |
|----------|------|---------------------|------------------|----------------------------------|
| Low | `G6` | `LLMProofPipeline.v` — 19 Qed | `grep -c Qed` reveals 20 Qed. | Minor underclaim. No rating downgrade required. |

## Overclaim lines

None. The audit operates with high discipline by directly excluding generated lanes (which do contain vacuous `admit ()` assertions) and explicitly citing the vacuity risk in other domains to cap its rating.

## Missed evidence lines

- `LLMProofPipeline.v` has 20 Qed proofs, not 19.

## Safe claim

"Formal verification infrastructure with mechanized type safety (progress, preservation) in Coq, multi-prover pipeline supporting 10 lanes, and pre-commit enforcement against incomplete proofs."

## Unsafe claim

"All proofs verified nontrivial", "Complete formal verification", "All 13,143 proofs are substantive."

## Release condition

1. Build and integrate a vacuity detection tool to automatically flag tautological (`True`, `true = true`) or trivial (`reflexivity.`, `trivial.`) proof conclusions across all `.v` files.
2. Formally document the proof transpiler validation workflow and pipeline threat model.

## Next review advice

Verify that vacuity detection has been deployed to CI and that all subsequent formal proofs are gated by this new tooling. Assess the newly documented pipeline threat model to ensure malicious proof generation or transpiler drift is mitigated before permitting an R4 promotion.