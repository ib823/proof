# Domain Audit Record

## 1. Identity

- Domain name: RIINA-BANK
- Domain identifier: `RIINA_BANK`
- Folder(s): `01_RESEARCH/34_DOMAIN_RIINA_BANK/`, `02_FORMAL/coq/domains/CoreBanking.v`
- Audit date: `2026-03-19`
- Auditor: Codex
- Current repo commit: `0293b678480d19c92843c34b2a25306bca54eb60`
- Command-derived Rust passing tests on this snapshot: `2476`
- `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings` on this snapshot: `passed`
- `audit-docs.sh` status on this snapshot: `0 discrepancies`, `1 warning` (`Coq warning status is stale`)

## 2. Canonical Source Map

### Canonical research authority

- `01_RESEARCH/34_DOMAIN_RIINA_BANK/RESEARCH_BANK01_FOUNDATION.md`

### Canonical formal files

- `02_FORMAL/coq/domains/CoreBanking.v`
- secondary lanes:
  - `02_FORMAL/lean/RIINA/Domains/CoreBanking.lean`
  - `02_FORMAL/isabelle/RIINA/Domains/CoreBanking.thy`
  - `02_FORMAL/fstar/RIINA/Domains/CoreBanking.fst`
  - `02_FORMAL/alloy/RIINA/Domains/CoreBanking.als`
  - `02_FORMAL/smt/RIINA/Domains/CoreBanking.smt2`
  - `02_FORMAL/tlaplus/RIINA/Domains/CoreBanking.tla`
  - `02_FORMAL/verus/RIINA/Domains/core_banking.rs`
  - `02_FORMAL/kani/RIINA/Domains/core_banking.rs`
  - `02_FORMAL/tv/RIINA/Domains/CoreBanking.tv.smt2`

### Live implementation search result

No dedicated core-banking subsystem was found in the live compiler/runtime crates. The only finance-adjacent live surface found in `03_PROTO` was narrow J6 syntax such as `zakat` and Shariah-related keywords, not a real banking module.

### Canonical example search result

No canonical `RIINA_BANK` example files were found in `07_EXAMPLES` by filename search. `07_EXAMPLES/08_jalinan/syariah_escrow.rii` exists and runs, but it is not a core-banking subsystem example and does not exercise the research or formal banking scope.

## 3. Current Scope Assessment

### What the research claims

`RESEARCH_BANK01_FOUNDATION.md` claims RIINA-BANK is:
- the "absolute core banking system"
- the end of evolution in banking software
- a replacement rendering Temenos, FLEXCUBE, BaNCS, Vault, and others obsolete

It enumerates broad module families including:
- CIF / KYC / AML
- deposits
- loans
- cards
- payments
- treasury
- Islamic banking

### What the live repo actually supports

- one live Coq core-banking file with 30 theorems
- secondary generated or translated lanes for the same file
- no dedicated parser/typechecker/runtime banking subsystem
- no live account, ledger, loan, payment, treasury, or CIF language constructs

### What is not honestly supported yet

- compile-time verified core-banking workflows
- executable core-banking examples through `riinac`
- live banking state machines
- live ledger/account invariants in the runtime
- end-to-end banking product families in the compiler

## 4. Workflow Inventory

| Workflow | Current status | Evidence |
|----------|----------------|----------|
| Formal reasoning about selected banking invariants | Exists | `CoreBanking.v` contains 30 theorem statements across multiple banking areas |
| Live compile-time checking of banking workflows | Missing | no banking subsystem found in `03_PROTO` crates |
| Executable core-banking example through `riinac` | Missing | no canonical banking examples found in `07_EXAMPLES` |
| Narrow Shariah escrow script execution | Works but not representative | `syariah_escrow.rii` runs and returns `Int(1000)`, but it is not a core-banking workflow |

## 5. Formal Depth Assessment

### Coq

`CoreBanking.v` is real and includes some nontrivial proofs:
- `BANK_001_01_customer_identity_uniqueness` uses list induction over customer uniqueness
- `BANK_001_18_idempotency` and related list invariants are structurally meaningful

It also includes many shallow unfold-and-apply theorems:
- `BANK_001_03_beneficial_ownership_complete`
- `BANK_001_04_sanctions_check_mandatory`
- `BANK_001_24_derivative_valuation`
- Islamic-banking slice:
  - `BANK_001_26_murabaha_cost_plus`
  - `BANK_001_27_ijarah_ownership`
  - `BANK_001_28_musharakah_profit_loss`
  - `BANK_001_29_sukuk_asset_backing`
  - `BANK_001_30_shariah_no_riba`

These are mechanized and domain-shaped, but nowhere near a workflow-complete core-banking proof architecture.

### Non-Coq lanes

- `CoreBanking.als` is `Auto-generated from 02_FORMAL/coq/domains/CoreBanking.v`
- `CoreBanking.smt2` is `Derived from 02_FORMAL/coq/domains/CoreBanking.v` and contains many `= 0 0` placeholders
- `CoreBanking.tla` contains many `== TRUE` definitions
- Verus/Kani/TV files are derivative lanes, not strong independent evidence

Conclusion:
- the domain has enough real formalization to exceed research-only status
- the secondary lanes are not safe to count as strong independent evidence

## 6. Live Implementation Assessment

Searches across:
- `03_PROTO/crates/riina-types/src`
- `03_PROTO/crates/riina-parser/src`
- `03_PROTO/crates/riina-typechecker/src`
- `03_PROTO/crates/riina-codegen/src`

did not find a live core-banking subsystem corresponding to the research/formal scope.

What does exist:
- narrow J6 surface for `zakat`
- lexer-only or thin-surface Shariah keywords such as `sukuk`, `takaful`, `patuh_syariah`

What does not exist:
- accounts
- deposits
- loans
- cards
- payments
- CIF/KYC/AML
- treasury
- double-entry ledger runtime
- SWIFT / Nostro / settlement semantics

## 7. Executable Evidence

Commands run on this snapshot:

```bash
grep -RIn --exclude-dir=target --exclude-dir=.git -E 'account|loan|deposit|payment|cif|kyc|swift|nostro|payment_irrevocable|murabaha|sukuk' 03_PROTO/crates/riina-parser/src 03_PROTO/crates/riina-typechecker/src 03_PROTO/crates/riina-codegen/src
find 07_EXAMPLES -type f | grep -Ei 'bank|banking|sukuk|murabaha|zakat|shariah|finance|corebanking'
export PATH="/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- run 07_EXAMPLES/08_jalinan/syariah_escrow.rii
```

Observed outcomes:

- no live banking subsystem hits were found in the compiler/runtime crates
- no canonical banking example files were found by filename search
- `syariah_escrow.rii` executes, but it is not evidence of a live core-banking subsystem

## 8. Gate Scores

| Gate | Score | Basis | Consequence |
|------|-------|-------|-------------|
| `G1` Canonical Identity | Partial | One canonical research file and one canonical Coq file exist, but no matching live banking subsystem exists | Identity is formal/research-heavy rather than full-stack |
| `G2` Boundary Precision | Fail | Research claims an absolute end-state core-banking system across many product families without bounded live scope | Caps enforcement claims |
| `G3` Workflow Inventory | Partial | Research enumerates many workflows/modules, but the live toolchain does not implement them | Blocks `R3-R4` |
| `G4` Threat and Failure Model | Partial | Research/formal model covers some integrity/compliance concerns, but abuse and runtime banking failure handling are not live | Blocks `R4` |
| `G5` Property Set | Partial | Real domain-shaped properties exist in Coq, including customer identity, ledger, payments, treasury, and Islamic banking slices | Supports formal modeling only |
| `G6` Formal Model Depth | Partial | Real Coq file exists, with a mix of nontrivial and shallow theorems; non-Coq lanes are largely generated/vacuous | Supports `R2`, not higher |
| `G7` Toolchain Enforcement | Fail | No dedicated banking frontend/runtime subsystem exists in `03_PROTO` | Blocks `R3` |
| `G8` Executable Evidence | Fail | No canonical banking examples run through the live toolchain | Blocks `R3` |
| `G9` Adversarial Evidence | Fail | No live negative banking workflow suite exists | Blocks `R4` |
| `G10` Independent Evidence Honesty | Fail | Secondary lanes are largely structural noise: `Auto-generated from`, `= 0 0`, `== TRUE`, and `some st` placeholders | They must be excluded from any strong proof-confidence claim |
| `G11` Observability and Auditability | Fail | No live banking evidence chain, report, or runtime artifact exists | Blocks `R4-R5` |
| `G12` Freshness and Reproducibility | Pass | Commands are reproducible on current `HEAD` | Audit is reproducible |
| `G13` Public Claim Discipline | Fail | Research claims total banking obsolescence and absolute superiority far beyond the live repo reality | Wording must be reduced drastically |
| `G14` Regression Immunity | Fail | No bank-specific readiness gate exists | Rating is not protected |

## 9. Rating

- Current rating: `R2`
- Rating cap: `R2`
- Why this is not lower:
  - a real core-banking formal model exists in Coq
  - the model covers domain-shaped banking properties rather than only generic type/security concerns
- Why this is not higher:
  - there is no live banking subsystem in the compiler/runtime
  - there are no canonical executable banking workflows
  - secondary prover lanes are largely generated or vacuous
  - public wording overclaims an absolute end-state banking platform

## 10. Safe Public Wording

- Safe claim:
  - `RIINA currently contains a preliminary Coq formalization of core banking and Islamic finance invariants, including double-entry balancing, idempotency, and basic Shariah bounds. It does not yet possess a live, executable core-banking compiler subsystem or runtime engine.`
- Unsafe claim:
  - `RIINA-BANK is the absolute core banking system that makes all existing banking systems obsolete and provides fully verified live banking workflows across all major banking modules.`

## 11. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| No live banking subsystem in the compiler/runtime | Critical | Build a bounded bank domain slice in parser/typechecker/runtime | Pending | Main blocker |
| No canonical executable banking examples | Critical | Add and run bounded core-banking workflows through `riinac` | Pending | Needed for any move beyond `R2` |
| Research wording is absolute and false relative to repo reality | Critical | Reduce wording to the safe `R2` claim | Pending | Major trust blocker |
| Coq file is too broad and partly shallow | High | Split into bounded child domains with stronger workflow-specific proofs | Pending | Needed for serious depth |
| Non-Coq lanes are vacuous | High | Reclassify them honestly or replace them with real independent models | Pending | Independence blocker |
| No bank-specific regression gates | Medium | Add readiness checks for the bounded live slice | Pending | Needed for `R4-R5` |

## 12. Promotion Checklist

### To stay honest at `R2`

- [x] Canonical research source exists
- [x] Live Coq formal model exists
- [x] Domain-shaped banking properties exist
- [ ] Public wording is reduced to the bounded formal-only status

### To reach `R3`

- [ ] a bounded banking subsystem exists in the live frontend/runtime
- [ ] invalid covered banking cases are rejected through the toolchain
- [ ] canonical banking examples parse and execute

### To reach `R4`

- [ ] workflow coverage is complete for the stated bounded slice
- [ ] negative and adversarial banking workflows exist
- [ ] runtime evidence/observability exists where needed

### To reach `R5`

- [ ] every gate `G1-G14` passes
- [ ] third-party reproduction is straightforward
- [ ] public wording is exact and conservative
- [ ] bank-specific regression gates exist and are enforced

## 13. Sign-Off

- Final verdict:
  - `R2` is the maximum honest rating at commit `0293b678480d19c92843c34b2a25306bca54eb60`.
- Reviewer notes:
  - hostile review completed in [RIINA_BANK_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/RIINA_BANK_R5_REVIEW.md)
  - review verdict: `accept with reductions`
  - review kept `R2` but downgraded `G10` to `Fail`, confirming that the generated/vacuous secondary lanes must not be counted as meaningful independent evidence
- Follow-up date:
  - after bounded live banking semantics, executable examples, and purged overclaim/generator noise justify re-audit
