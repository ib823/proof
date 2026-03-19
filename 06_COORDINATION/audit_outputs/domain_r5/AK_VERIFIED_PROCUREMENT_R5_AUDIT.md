# Domain Audit Record

## 1. Identity

- Domain name: Verified Procurement
- Domain identifier: `AK_VERIFIED_PROCUREMENT`
- Folder(s): `01_RESEARCH/56_DOMAIN_AK_VERIFIED_PROCUREMENT/`, `02_FORMAL/tlaplus/RIINA/Active/TelusProcurementProtocol.tla`, `02_FORMAL/alloy/RIINA/Active/TelusProcurementAccessControl.als`, `07_EXAMPLES/08_jalinan/procurement.rii`
- Audit date: `2026-03-19`
- Auditor: Codex
- Current repo commit: `0293b678480d19c92843c34b2a25306bca54eb60`
- Command-derived Rust passing tests on this snapshot: `2476`
- `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings` on this snapshot: `passed`
- `audit-docs.sh` status on this snapshot: `0 discrepancies`, `1 warning` (`Coq warning status is stale`)
- Dirty files at audit start:
  - `06_COORDINATION/audit_outputs/domain_r5/`
  - `06_COORDINATION/prompts/`
  - `06_COORDINATION/remediation/`
  - `scripts/run-domain-audit-program.sh`
  - `scripts/run-gemini-hostile-review.sh`

## 2. Canonical Sources

### 2.1 Live authority files

| Layer | File(s) | Canonical? | Notes |
|------|---------|------------|-------|
| Research | `01_RESEARCH/56_DOMAIN_AK_VERIFIED_PROCUREMENT/RESEARCH_AK01_PROCUREMENT_STATE_MACHINES.md`, `RESEARCH_AK02_PROCUREMENT_METHOD_SELECTION.md`, `RESEARCH_AK03_STANDARDS_THEOREM_MAPPINGS.md`, `RESEARCH_AK04_OCDS_DATA_STANDARD.md` | Yes | Canonical umbrella research set: lifecycle state machines, method selection, standards mappings, OCDS data model |
| Formal | `02_FORMAL/tlaplus/RIINA/Active/TelusProcurementProtocol.tla` | Partial | Real manually maintained TLA+ smoke spec for a bounded procurement protocol slice |
| Formal | `02_FORMAL/alloy/RIINA/Active/TelusProcurementAccessControl.als` | Partial | Real manually maintained Alloy smoke model for a bounded access-control slice |
| Tooling | `03_PROTO/crates/riinac/src/verify.rs` | Yes | Verification harness treats the TLA+/Alloy files as active smoke models |
| Examples | `07_EXAMPLES/08_jalinan/procurement.rii` | Partial | Procurement-themed choreography example exists, but it does not survive the live parser |
| Reports | `website/public/metrics.json` | Partial | Public metrics openly describe these as partial smoke models, not full domain implementations |

### 2.2 Historical or non-authoritative files

| File | Why not authoritative |
|------|------------------------|
| `03_PROTO/crates/*` procurement references | None found | No live procurement domain implementation surface exists in the compiler/runtime crates |
| `02_FORMAL/coq/*` procurement references | None found | Research promises Coq formalization, but no live procurement Coq file exists |
| `02_FORMAL/lean/*` procurement references | None found | No live Lean procurement lane exists |
| `02_FORMAL/isabelle/*` procurement references | None found | No live Isabelle procurement lane exists |
| `website/public/metrics.json` smoke labels | Status surface only | Reports partial smoke-model presence, not domain authority |

## 3. Scope

- Covered problem:
  - public-procurement lifecycle integrity, procurement-method selection legality, standards theorem mappings, OCDS data integrity, and bounded active smoke models for procurement protocol/access control
- Explicitly excluded problem:
  - deployed procurement platform, full ePerolehan implementation, live tender/evaluation/award/payment runtime, legal advice, regulator certification, and cross-system government integration
- Covered actors:
  - requisitioner, budget officer, procurement officer, evaluation chair, approving authority, vendor manager, auditor, bidder abstractions
- Covered assets:
  - procurement case, bids, award state, contract-signing gate, procurement method decision, audit/access capabilities, OCDS release/record abstractions
- Covered trust boundaries:
  - role-separation boundary in smoke models, budgeting-before-tender boundary, award-before-contract boundary, research-to-toolchain boundary
- Covered lifecycle phases:
  - research covers full lifecycle from requisition to closeout; active smoke models cover only a narrow protocol/access-control slice
- Covered jurisdictions or standards:
  - UNCAC, OECD, COSO, ISO 37001, WTO GPA, UNCITRAL, Malaysia procurement rules, OCDS
- Assumptions:
  - research theorem sketches stand in for future Coq development
  - TLA+/Alloy active models are treated as bounded smoke models, not full domain closure
  - JALINAN primitives are assumed to be the substrate for procurement examples
- Residual risks:
  - no live procurement semantics exist in the RIINA frontend
  - no Coq procurement lane exists despite research claims
  - canonical example is not executable through the live parser
  - smoke-model presence can be mistaken for full domain implementation

## 4. Workflow Matrix

| Workflow | Valid or forbidden | Research | Formalized | Enforced | Tested | Receipted/observable | Notes |
|----------|--------------------|----------|------------|----------|--------|----------------------|-------|
| Reject illegal procurement state transitions at compile time | Claimed valid | Yes | No live Coq/frontend support | No | No | No | Research claims “the code does not compile,” but no live frontend procurement types/effects exist |
| Select procurement method legally from thresholds and constraints | Claimed valid | Yes | No live implementation | No | No | No | Research describes a pure function; no compiler/runtime implementation found |
| Enforce role separation across procurement actors | Valid in bounded slice | Yes | Partial | No | Partial | Partial | Manually maintained TLA+/Alloy smoke models encode small slices only |
| Publish procurement/OCDS data with verified completeness | Claimed valid | Yes | No live implementation | No | No | No | OCDS work is research-only today |
| Run a procurement choreography example end-to-end | Valid | Partial | No | No | No | No | `07_EXAMPLES/08_jalinan/procurement.rii` fails in the live parser |
| Treat TLA+/Alloy smoke models as full procurement implementation evidence | Forbidden | No | No | No | N/A | Partial | Metrics already label them as partial smoke models; they cannot justify strong umbrella claims |

## 5. Property Matrix

| Property | Why it matters | Formal artifact | Enforcement artifact | Tests/examples | Status |
|----------|----------------|-----------------|----------------------|----------------|--------|
| Budget before tender | Prevents unauthorized procurement | `TenderRequiresBudget` in `TelusProcurementProtocol.tla` | Missing in live frontend/runtime | No live procurement tests | Partial |
| Evaluation before award | Prevents predetermined awards | `AwardNeedsEvaluation` in TLA+ | Missing in live frontend/runtime | No live procurement tests | Partial |
| Competition before award | Prevents single-bid abuse in bounded slice | `AwardNeedsCompetition` in TLA+ | Missing in live frontend/runtime | No live procurement tests | Partial |
| Standstill before contract | Preserves challenge rights | `ContractNeedsStandstill` in TLA+ | Missing in live frontend/runtime | No live procurement tests | Partial |
| Separation of duty | Prevents role collapse and corruption | `RoleSeparation` in TLA+, `ProcurementSeparationOfDuty` in Alloy | Missing in live frontend/runtime | No live procurement tests | Partial |
| Least-privilege access control | Prevents unauthorized approval/vendor binding/audit access | Alloy capability assertions | Missing in live frontend/runtime | No live procurement tests | Partial |
| Method-selection legality | Core procurement law requirement | Research theorem catalog only | Missing | Missing | Missing |
| OCDS integrity and completeness | Needed for publishable procurement evidence | Research theorem catalog only | Missing | Missing | Missing |

## 6. Formal Evidence

### 6.1 Coq

| File | Key definitions | Key theorems | Nontrivial? | Notes |
|------|-----------------|--------------|-------------|-------|
| none found | N/A | N/A | N/A | Research explicitly sketches Coq formalization and theorem mappings, but no live procurement Coq file exists |

### 6.2 Other prover lanes

| Lane | Files | Independent or generated | Serious or cosmetic | Notes |
|------|-------|--------------------------|---------------------|-------|
| Lean | none found | N/A | N/A | No live procurement Lean lane found |
| Isabelle | none found | N/A | N/A | No live procurement Isabelle lane found |
| SMT | none found | N/A | N/A | No procurement SMT lane found |
| Alloy | `02_FORMAL/alloy/RIINA/Active/TelusProcurementAccessControl.als` | Manual | Partial but bounded | Real finite access-control smoke model, not full procurement domain |
| F* | none found | N/A | N/A | No live procurement F* lane found |
| TLA+ | `02_FORMAL/tlaplus/RIINA/Active/TelusProcurementProtocol.tla` | Manual | Partial but bounded | Real finite protocol smoke model, not full procurement domain |
| Verus | none found | N/A | N/A | No live procurement Verus lane found |
| Kani | none found | N/A | N/A | No live procurement Kani lane found |
| TV | none found | N/A | N/A | No procurement translation-validation lane found |

### 6.3 Vacuity audit

| Finding | File | Impact | Resolved? |
|---------|------|--------|-----------|
| Research claims compile-time refusal for illegal transitions | `RESEARCH_AK01_PROCUREMENT_STATE_MACHINES.md:48`, `906` | Overstates live implementation boundary because no procurement frontend exists | No |
| Research claims each standards requirement maps to Coq theorems and compilation property | `RESEARCH_AK03_STANDARDS_THEOREM_MAPPINGS.md:24`, `935` | Overstates live formal/toolchain state because no Coq procurement files exist | No |
| No live Coq/Lean/Isabelle procurement lane exists | grep over `02_FORMAL/coq`, `lean`, `isabelle` returned no procurement hits | Caps formal depth at the umbrella level | No |
| TLA+/Alloy files are explicitly smoke models | `03_PROTO/crates/riinac/src/verify.rs:2247-2351`, `2419-2617`, `website/public/metrics.json:135` | They are real but bounded; they cannot justify full domain claims | No |
| Canonical example fails the live parser | `cargo run ... riinac -- check 07_EXAMPLES/08_jalinan/procurement.rii` | Removes executable-evidence basis for the umbrella | No |

## 7. Implementation Evidence

| Layer | File(s) | What is real today | What is still placeholder |
|------|---------|--------------------|---------------------------|
| Lexer/parser | general JALINAN frontend only | Generic choreography/actor parsing exists | No procurement-specific syntax, types, or transitions in the live frontend |
| Types/effects | none domain-specific found | General RIINA types/effects exist | No procurement types/effects or state-machine types exist |
| Typechecker | none domain-specific found | General typechecker exists | No procurement legality, thresholds, separation, or method-selection checks exist |
| Runtime | none domain-specific found | Generic actor/content/runtime support exists | No procurement runtime state machine or workflow engine exists |
| Codegen | none domain-specific found | Generic codegen exists | No procurement-preserving codegen path exists |
| Tooling | `03_PROTO/crates/riinac/src/verify.rs` | TLA+/Alloy smoke models are exercised as lane smoke checks | This is verification-harness support, not procurement domain implementation |

## 8. Executable Evidence

| Evidence | Command | Expected outcome | Last verified |
|----------|---------|------------------|---------------|
| TLA+/Alloy smoke-model registration | `grep -RIn "TelusProcurementProtocol\\|TelusProcurementAccessControl" 03_PROTO/crates/riinac/src/verify.rs scripts/generate-metrics.sh scripts/check-noncoq-mechanized.sh` | Confirms active smoke models are wired into verification/metrics as partial smoke checks | `2026-03-19` |
| Procurement frontend presence check | `grep -RIn "perolehan\\|procurement\\|tender\\|bidder\\|award" 03_PROTO/crates/riina-types 03_PROTO/crates/riina-parser 03_PROTO/crates/riina-typechecker 03_PROTO/crates/riina-codegen 03_PROTO/crates/riinac` | Returns no procurement domain semantics in the live compiler/runtime surface | `2026-03-19` |
| Canonical procurement example | `cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check 07_EXAMPLES/08_jalinan/procurement.rii` | Fails in the live parser with `Unexpected token: KwSelect` | `2026-03-19` |
| Active smoke-model vacuity check | `grep -RIn "Auto-generated from\\|Derived from\\|== TRUE\\|= 0 0" 02_FORMAL/tlaplus/RIINA/Active/TelusProcurementProtocol.tla 02_FORMAL/alloy/RIINA/Active/TelusProcurementAccessControl.als` | Finds no vacuous placeholder patterns in the active smoke files | `2026-03-19` |

## 9. Gate Scores

| Gate | Pass / Partial / Fail | Evidence | Notes |
|------|-----------------------|----------|-------|
| `G1` Canonical Identity | Partial | Canonical research set exists, plus bounded active smoke models and example | The canonical implementation surface is effectively absent |
| `G2` Boundary Precision | Fail | Research claims compile-time refusal and theorem-backed compilation properties, but no live procurement frontend or Coq lane exists | Strong overstatement of live boundary |
| `G3` Workflow Inventory | Partial | Research inventories workflows in detail | Live system does not implement those workflows end-to-end |
| `G4` Threat and Failure Model | Partial | Research threat inventory is extensive | None of it is enforced in the live toolchain |
| `G5` Property Set | Partial | Good research property set and bounded smoke-model properties exist | Live enforced property set is near-zero |
| `G6` Formal Model Depth | Fail | No live Coq procurement lane; only bounded TLA+/Alloy smoke models exist | Blocks `R2` |
| `G7` Toolchain Enforcement | Fail | Grep found no procurement semantics in the live compiler/runtime crates | Critical blocker |
| `G8` Executable Evidence | Fail | Canonical example fails the live parser | No end-to-end executable umbrella workflow |
| `G9` Adversarial Coverage | Fail | No live invalid-workflow or corruption/abuse rejection cases execute through the toolchain | Smoke models are not enough |
| `G10` Evidence Honesty Across Prover Lanes | Partial | The active smoke models are honestly labeled as partial smoke checks | Honesty is better than AJ, but breadth is still far below the umbrella claim |
| `G11` Observability and Auditability | Partial | Metrics openly expose the smoke-model names and partial status | No live procurement evidence chain or domain report exists |
| `G12` Freshness and Reproducibility | Pass | Commands reran cleanly on current `HEAD` | Audit is reproducible |
| `G13` Public Claim Discipline | Fail | Research files make compile-time and Coq-backed claims that the live repo does not satisfy | Claims must be reduced to research/spec status |
| `G14` Regression Immunity | Fail | No AK-specific CI/readiness gate exists | Domain rating is not protected |

## 10. Rating

- Current rating: `R1`
- Rating cap: `R1`
- Why this is not higher:
  - the domain has a rich canonical research set and two real bounded smoke models, but no live procurement frontend/runtime semantics and no live Coq procurement lane
  - the canonical example does not execute through the live parser
  - the umbrella claim surface is much larger than the real implemented/formalized subset
- Minimum work to reach next level:
  - implement one bounded procurement slice in the live frontend/runtime, not just smoke models
  - create a real Coq procurement lane for that same slice
  - make canonical example workflows parse/typecheck/run through CI
  - reduce research/public wording until the bounded slice is real

## 11. Safe Public Wording

- Safe claim:
  - `RIINA currently has detailed procurement research plus bounded TLA+ and Alloy smoke models for a narrow procurement protocol/access-control slice, but it does not yet provide a live compile-time verified procurement subsystem in the language.`
- Unsafe claim:
  - `RIINA guarantees procurement legality at compile time, with full procurement state machines, method selection, standards compliance, and OCDS integrity enforced by the live toolchain.`

## 12. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| No live procurement frontend semantics | Critical | Introduce bounded procurement state/types/effects in the core frontend | Pending | Primary blocker |
| No live procurement Coq lane | Critical | Materialize the promised procurement Coq formalization for the same bounded slice | Pending | Research currently outruns formal implementation |
| Canonical example does not parse | High | Fix `07_EXAMPLES/08_jalinan/procurement.rii` or replace it with a live canonical example | Pending | Blocks executable evidence |
| Smoke models are too narrow for umbrella claims | High | Keep them bounded and explicitly scoped, or grow them with matching live implementation | Pending | TLA+/Alloy presence is not enough |
| Method-selection logic is research-only | High | Implement and test a bounded method-selection function | Pending | Core procurement legality claim currently unsupported |
| OCDS integrity/completeness is research-only | High | Add a real schema/record pipeline with tests and proofs | Pending | Currently no implementation surface |
| Public/research wording overclaims compile-time guarantees | Critical | Reduce wording to the safe-claim level until live frontend and Coq support exist | Pending | Claim discipline blocker |
| No domain-specific regression gate | Medium | Add AK readiness checks tied to the bounded live subset | Pending | Needed for `R4-R5` |

## 13. Promotion Checklist

### To reach `R1`

- [x] Canonical research scope exists
- [x] Canonical source set can be identified
- [ ] Overclaiming research/public wording is clearly demoted

### To reach `R2`

- [ ] Live Coq formal model exists for the claimed subset
- [ ] Nontrivial theorem set exists
- [ ] Workflow-to-proof mapping exists for a bounded live subset

### To reach `R3`

- [ ] Live frontend/runtime enforcement exists for a bounded procurement slice
- [ ] Invalid covered cases are rejected
- [ ] Executable positive path exists

### To reach `R4`

- [ ] Workflow coverage is complete for the stated scope
- [ ] Negative and adversarial tests exist
- [ ] Residual risks are explicit and narrow

### To reach `R5`

- [ ] Every gate `G1-G14` passes
- [ ] Third-party reproduction is possible without interpretive guesswork
- [ ] Public wording is conservative and exact
- [ ] Regression checks exist and are enforced

## 14. Sign-Off

- Final verdict:
  - `R1` is the maximum honest rating at commit `0293b678480d19c92843c34b2a25306bca54eb60`.
- Reviewer notes:
  - hostile review completed in [AK_VERIFIED_PROCUREMENT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AK_VERIFIED_PROCUREMENT_R5_REVIEW.md)
  - review verdict: `accept`
  - review confirmed the `R1` cap and agreed that the primary blockers are the absence of live procurement semantics, absence of a Coq procurement lane, and research wording that outruns the bounded smoke-model reality
- Follow-up date:
  - after bounded procurement semantics, executable examples, and a real Coq lane exist for re-audit

## 15. Next Audit Handoff

- Recommended next domain:
  - `AL_VERIFIED_LAYOUT`
- Recommended pattern:
  - `layout|susun|wcag|ui|render|overlap`
- Why this should be next:
  - it is the next high-risk umbrella in the queue after `AK_VERIFIED_PROCUREMENT`
  - it likely shares the same “rich research versus bounded live subset” tension
  - it is close to existing CAHAYA/SINAR/SUSUN implementation work
- Files to start from:
  - `01_RESEARCH/*AL*`
  - live UI/layout crates and specs
  - domain formal files under `02_FORMAL/*`
- Cross-domain risks to carry forward:
  - research claims outrunning live frontend semantics
  - bounded smoke-model evidence being mistaken for full domain support
  - canonical examples not executable through the live parser
