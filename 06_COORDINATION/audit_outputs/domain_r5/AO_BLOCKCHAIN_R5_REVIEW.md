# Blockchain Primitives Domain R5 Review

## 1. Verdict
**accept with reductions**

## 2. Snapshot validation
- **Branch:** `main`
- **Commit:** `93ad08b8684ae7a2d3e94b35c6308f218c60f132`
- **Review Valid:** Yes. The snapshot matches the expected base commit.

## 3. Maximum honest rating
**R1** (Downgraded from R2)

Although `DistributedConsensus.v` and `ExecutionReceipts.v` contain some nontrivial proofs, the broader "Blockchain Primitives" domain heavily overclaims its depth. Core formal models like `BlockchainSafety.v` and `BlockchainConsensus.v` rely almost entirely on boolean flag unpacking and reflexivity. Furthermore, the claimed implementation includes completely missing primitives (`block`), syntax-only tokens (`consensus`), and superficial wrappers (`ContractDeploy`), rendering it insufficient for an R2 rating across the umbrella domain.

## 4. Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| G1 Canonical Identity | Partial | Partial | Agree | Split between research and narrow implemented fragments. | Caps rating below R5. |
| G2 Boundary Precision | Partial | Partial | Agree | Public claims outrun live boundaries. | Caps rating below R5. |
| G3 Workflow Inventory | Partial | Fail | Downgrade | Consensus and smart contract lifecycles are claimed but lack any end-to-end workflows. | Caps rating below R4. |
| G4 Threat/Failure Model | Partial | Fail | Downgrade | No executable adversarial models exist for reentrancy, consensus abuse, or token inflation. | Caps rating below R4. |
| G5 Property Set | Partial | Partial | Agree | Key economic and execution properties are missing. | Caps rating below R4. |
| G6 Formal Model Depth | Partial | Fail | Downgrade | Most Coq files (`BlockchainSafety.v`, `BlockchainConsensus.v`) are boolean unpacking. The nontrivial `DistributedConsensus` model is entirely disconnected from the toolchain. | Caps rating at R1. |
| G7 Toolchain Enforcement | Partial | Fail | Downgrade | `KwConsensus` is lexer-only. `KwBlock` is completely missing. `SmartContract` is just a type wrapper with no stateful semantics. | Invalidates R3 claim potential. |
| G8 Executable Evidence | Partial | Fail | Downgrade | No `.rii` blockchain examples run as end-to-end workflows in CI. | Rejects executable evidence claims. |
| G9 Adversarial Coverage | Partial | Fail | Downgrade | Tests only cover receipt tampering and type mismatch; no blockchain/smart-contract attacks are modeled or tested. | Caps rating below R4. |
| G10 Evidence Honesty | Fail | Fail | Agree | SMT, Alloy, TLA+, F*, Kani, Verus lanes are demonstrably vacuous (e.g., `== TRUE`, `some p_c`) or auto-generated. | Fatal to R5. |
| G11 Observability | Partial | Partial | Agree | Traceability possible but manual. | Caps rating below R5. |
| G12 Freshness | Pass | Pass | Agree | Audit is reproducible on the snapshot. | None. |
| G13 Public Claim | Fail | Fail | Agree | Audit correctly identified overclaims in `RIINA_MASTER_PLAN.md`. | Fatal to R5. |
| G14 Regression Immunity| Fail | Fail | Agree | No domain-specific CI gate exists. | Fatal to R5. |

## 5. Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| Critical | G6 | "Partial" score / "enough to exceed R1" | Core models are boolean-heavy. The nontrivial consensus model is entirely disconnected from the toolchain. | Downgrade gate to Fail. Cap rating at R1. |
| High | G7 | "Partial" score | `KwConsensus` has no downstream semantics. `KwBlock` does not even exist in the Rust source. `SmartContract` is just an `Expr` wrapper. | Downgrade gate to Fail. |
| High | G8 | "Partial" score | No `.rii` examples run end-to-end in tests. | Downgrade gate to Fail. |
| High | G4, G9 | "Partial" score | Zero executable tests or formal state machine models exist for smart contract vulnerabilities like reentrancy. | Downgrade gates to Fail. |

## 6. Overclaim lines

- **Audit line:** "Current rating: R2"
- **Audit line:** "The domain has real formal modeling and at least one nontrivial local proof cluster ... which is enough to exceed R1." (Implies the whole umbrella domain is R2, which is false).

## 7. Missed evidence lines

- The audit missed that the `block` or `blok` keyword does not exist anywhere in the implementation (a grep for `KwBlock` returns zero results), making the scope completely misleading.
- The audit missed that `ContractDeploy` acts purely as a passthrough AST node without any stateful contract execution environment or semantics.

## 8. Safe claim

RIINA's blockchain domain is a specified research topic (R1) with experimental runtime support for content-addressing and receipts, but it currently lacks enforced consensus, blocks, or functional smart contracts.

## 9. Unsafe claim

RIINA provides a formally modeled (R2) blockchain primitives lane with consensus, smart contracts, and independent multi-prover verification.

## 10. Release condition

The domain rating cannot exceed R1 until the public scope is strictly narrowed to the implemented features (e.g., content-addressing and receipts), or until the broader blockchain primitives (consensus, blocks, smart contracts) are fully implemented and verified with state-transition proofs rather than boolean flags.

## 11. Next review advice

The auditor must revise the audit to downgrade the rating to R1. Mark G3, G4, G6, G7, G8, and G9 as Fail due to the overwhelming presence of syntax-only features, disconnected proofs, and missing core primitives. The domain scope must be either drastically narrowed to just `AO_EXECUTION_RECEIPTS` or actually implemented.