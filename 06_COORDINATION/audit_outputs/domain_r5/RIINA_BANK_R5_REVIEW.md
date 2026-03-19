# RIINA-BANK R5 Hostile Review

## 1. Verdict

**Verdict:** `accept with reductions`

The primary audit correctly identifies the massive disparity between the `01_RESEARCH` claims ("obsolete Temenos, FLEXCUBE") and the actual `03_PROTO` reality (zero live banking constructs). The audit is highly accurate in catching the vacuous secondary prover lanes and correctly caps the domain at `R2`. However, the review further downgrades `G10` (Independent Evidence Honesty) to a strict `Fail` because maintaining auto-generated, empty placeholder files (`= 0 0`, `== TRUE`) across 8 different formal languages is not "partial" honesty—it is structural noise that inflates proof counts and must be explicitly rejected.

## 2. Snapshot Validation

- **Branch:** `main` (ahead 1, with local audit uncommitted files)
- **Commit:** `0293b678480d19c92843c34b2a25306bca54eb60`
- **Snapshot Validity:** VALID. 
- **Drift Assessment:** The drift from the snapshot consists entirely of audit outputs, prompts, and remediation tracking docs (`06_COORDINATION/` and `scripts/`). The core implementation (`03_PROTO`), formal (`02_FORMAL`), and examples (`07_EXAMPLES`) have zero drift. The review is materially valid.

## 3. Maximum Honest Rating

- **Current Audit Rating:** `R2`
- **Reviewer Maximum Honest Rating:** `R2`
- **Rationale:** `R2` requires meaningful formal modeling or early implementation. `CoreBanking.v` is a real file with 30 theorems. While 27 of these theorems are completely shallow (`unfold X; apply H`), 3 theorems (such as `BANK_001_08_double_entry_invariant` and `BANK_001_18_idempotency`) require structural list induction and represent real, non-trivial formal work. Therefore, it satisfies the minimum bar for `R2`. It completely fails the requirements for `R3` as there is absolutely zero live banking syntax, semantics, or executable evidence in the compiler.

## 4. Gate Review Table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| `G1` Canonical Identity | Partial | Partial | Agree | `CoreBanking.v` exists, but lacks any bounded subsystem in `03_PROTO`. | Caps rating, requires bounding. |
| `G2` Boundary Precision | Fail | Fail | Agree | `RESEARCH_BANK01_FOUNDATION.md` claims an unbounded, industry-replacing architecture. | Blocks any serious enforcement claims. |
| `G3` Workflow Inventory | Partial | Partial | Agree | Broad research enumeration, zero live workflow implementation. | Blocks `R3`. |
| `G4` Threat & Failure Model | Partial | Partial | Agree | Some formal properties cover invariants, but runtime failure handling for banking is nonexistent. | Blocks `R4`. |
| `G5` Property Set | Partial | Partial | Agree | Domain-shaped properties (KYC, Ledger, Murabaha) exist in Coq. | Supports `R2`. |
| `G6` Formal Model Depth | Partial | Partial | Agree | Mix of 3 real induction proofs and 27 vacuous `unfold; apply` tautologies. | Weak `R2`. |
| `G7` Toolchain Enforcement | Fail | Fail | Agree | Cargo search of `03_PROTO` reveals no `account`, `ledger`, `loan`, or `kyc` subsystems. | Blocks `R3`. |
| `G8` Executable Evidence | Fail | Fail | Agree | No core banking examples exist in `07_EXAMPLES`. | Blocks `R3`. |
| `G9` Adversarial Evidence | Fail | Fail | Agree | No negative testing for banking logic. | Blocks `R4`. |
| `G10` Evidence Honesty | Partial | **Fail** | **Downgrade** | Secondary lanes (Alloy, SMT, TLA+, FStar) are flooded with `Auto-generated from` and `= 0 0` / `== TRUE` placeholders. This is not partial honesty; it is actively misleading metrics inflation. | Requires purging or strict disclaimer of non-Coq files. |
| `G11` Observability | Fail | Fail | Agree | No live runtime artifacts for banking. | Blocks `R4`. |
| `G12` Reproducibility | Pass | Pass | Agree | Audit commands run cleanly on the snapshot. | Audit valid. |
| `G13` Claim Discipline | Fail | Fail | Agree | Research claims are dangerously absolute ("end of evolution in banking software") against a nonexistent codebase. | Wording must be purged. |
| `G14` Regression Immunity | Fail | Fail | Agree | No banking-specific CI gates. | Rating unprotected. |

## 5. Findings Table

| Severity | Gate | Claim under dispute | Counter-evidence | Required Downgrade or Correction |
|----------|------|---------------------|------------------|----------------------------------|
| High | `G10` | "Secondary lanes are visibly derived... Partial" | SMT contains purely `= 0 0` assertions, Alloy contains `some st`, TLA+ contains `== TRUE`. | Downgrade `G10` to `Fail`. Volumetric proof counts from these files must be strictly excluded from any public metrics. |
| Critical | `G13` | Research claims total banking obsolescence | The compiler contains zero banking language primitives. | The `01_RESEARCH` wording must be forcefully rewritten to match the safe claim below. |

## 6. Overclaim Lines

- **The Primary Audit explicitly and correctly caught the research overclaims:** "a replacement rendering Temenos, FLEXCUBE, BaNCS, Vault, and others obsolete". 
- **The Reviewer confirms this is a massive overclaim.** RIINA-BANK is currently a single Coq file with 30 basic theorems, not a banking system.

## 7. Missed Evidence Lines

- The audit correctly identified the lack of live implementation. `07_EXAMPLES/08_jalinan/syariah_escrow.rii` exists and executes, but correctly noted it is an escrow script, not a core banking ledger/system workflow.
- Zakat keyword was found in `riina-codegen`, but as the audit noted, it is a narrow expression, not a core-banking module.

## 8. Safe Claim

`RIINA currently contains a preliminary Coq formalization of core banking and Islamic finance invariants (such as double-entry ledger balancing, idempotency, and basic Shariah compliance bounds). It does not yet possess a live, executable core-banking compiler subsystem or runtime engine.`

## 9. Unsafe Claim

`RIINA-BANK is a fully verified, absolute core banking system that obsoletes legacy providers like Temenos and Vault, offering end-to-end verified ledgers, loans, payments, and KYC integrated at the language level.`

## 10. Release Condition

1. **Delete or flag vacuous lanes:** The `Auto-generated from` and placeholder files in TLA+, Alloy, SMT, and FStar must be explicitly excluded from RIINA's aggregate proof metrics, or replaced with real models.
2. **Purge marketing absolute claims:** The `01_RESEARCH/34_DOMAIN_RIINA_BANK` documentation must be stripped of claims implying RIINA currently possesses an operational banking replacement.
3. **Bound the scope:** The domain must explicitly document that its current state is a "Phase 1 Formal Model" and not an executable subsystem.

## 11. Next Review Advice

When auditing for `R3`, do not accept any Coq additions as evidence. You must see actual banking data structures (e.g., Accounts, Ledgers, Transactions) materialized in the AST (`03_PROTO/crates/riina-types`), properly type-checked in `riina-typechecker`, and cleanly executed in a multi-actor workflow under `07_EXAMPLES/`. Until the compiler understands what an "Account" is, the domain remains locked at `R2`.