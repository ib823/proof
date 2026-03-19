# Domain Audit Record

## 1. Identity

- Domain name: Verified Compliance
- Domain identifier: `AJ_VERIFIED_COMPLIANCE`
- Folder(s): `01_RESEARCH/55_DOMAIN_AJ_VERIFIED_COMPLIANCE/`, `02_FORMAL/*/VerifiedCompliance.*`, `03_PROTO/crates/riina-compliance/`, `07_EXAMPLES/04_compliance/`
- Audit date: `2026-03-19`
- Auditor: Codex
- Current repo commit: `0293b678480d19c92843c34b2a25306bca54eb60`
- Command-derived Rust passing tests on this snapshot: `2476`
- `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings` on this snapshot: `passed`
- `audit-docs.sh` status on this snapshot: `0 discrepancies`, `1 warning` (`Coq warning status is stale`)
- Dirty files at audit start:
  - `06_COORDINATION/audit_outputs/domain_r5/`
  - `06_COORDINATION/prompts/`
  - `06_COORDINATION/remediation/AO_BLOCKCHAIN/`
  - `scripts/run-domain-audit-program.sh`
  - `scripts/run-gemini-hostile-review.sh`

## 2. Canonical Sources

### 2.1 Live authority files

| Layer | File(s) | Canonical? | Notes |
|------|---------|------------|-------|
| Research | `01_RESEARCH/55_DOMAIN_AJ_VERIFIED_COMPLIANCE/RESEARCH_AJ01_FOUNDATION.md` | Yes | Canonical research target: compliance-as-code, regulatory verification, audit automation, continuous monitoring |
| Formal | `02_FORMAL/coq/domains/VerifiedCompliance.v` | Yes | Active Coq file with `35` theorem statements covering GDPR, HIPAA, PCI-DSS, and policy-mapping abstractions |
| Implementation | `03_PROTO/crates/riina-compliance/src/lib.rs`, `03_PROTO/crates/riina-compliance/src/rules.rs`, `03_PROTO/crates/riina-compliance/src/report.rs`, `03_PROTO/crates/riina-compliance/src/validator.rs`, `03_PROTO/crates/riinac/src/main.rs` | Yes | Real opt-in compliance rule engine, CLI integration, and report generation exist |
| Examples | `07_EXAMPLES/04_compliance/`, `07_EXAMPLES/compliance/ewallet_pci.rii`, `07_EXAMPLES/showcase/rekod_perubatan_hipaa.rii` | Partial | Real example inventory exists, but at least one flagship example does not survive the live frontend |
| Reports | none domain-specific found | No | Global metrics exist, but no per-domain verified-compliance status report was found |

### 2.2 Historical or non-authoritative files

| File | Why not authoritative |
|------|------------------------|
| `01_RESEARCH/55_DOMAIN_AJ_VERIFIED_COMPLIANCE/OLD_RESEARCH_AJ01_FOUNDATION.md` | Historical predecessor, not the live research source |
| `02_FORMAL/coq/compliance/VerifiedCompliance.v` | Byte-for-byte duplicate of `02_FORMAL/coq/domains/VerifiedCompliance.v`, not independent authority |
| `02_FORMAL/lean/RIINA/Domains/VerifiedCompliance.lean` | Generated/derived lane, not independent source design |
| `02_FORMAL/isabelle/RIINA/Domains/VerifiedCompliance.thy` | Generated/derived lane, not independent source design |
| `02_FORMAL/smt/RIINA/Domains/VerifiedCompliance.smt2` | Reduces theorems to `= 0 0` placeholders |
| `02_FORMAL/alloy/RIINA/Domains/VerifiedCompliance.als` | Auto-generated from Coq and reduces assertions to `some store`-style existence claims |
| `02_FORMAL/tlaplus/RIINA/Domains/VerifiedCompliance.tla` | Reduces core predicates to `== TRUE` |
| `04_SPECS/business/RIINA_BUSINESS_MODEL_v1_0_0.md` | Business framing, not implementation authority |

## 3. Scope

- Covered problem:
  - regulatory-compliance verification claims for privacy, healthcare, payments, finance, and related technical controls
  - policy/rule checking, compliance-report generation, and formal control-mapping abstractions
- Explicitly excluded problem:
  - legal advice, regulator acceptance, human interpretation of ambiguous regulations, organization-wide governance programs, live continuous monitoring agents, and cross-system evidence collection
- Covered actors:
  - developer, auditor, compliance engineer, regulated operator, data subject/patient/cardholder abstractions, control owner
- Covered assets:
  - personal data, PHI, cardholder data, control mappings, evidence chains, compliance reports
- Covered trust boundaries:
  - compiler/typechecker boundary, opt-in compliance-validation boundary, report-generation boundary, theorem-to-derived-lane boundary
- Covered lifecycle phases:
  - choose compliance profile, parse/typecheck program, run post-typecheck AST checks, emit compliance report, map controls/proofs in the formal model
- Covered jurisdictions or standards:
  - GDPR, HIPAA, PCI-DSS, SOX, SOC 2, ISO 27001, NIST CSF, PDPA, BNM, and other profile slugs listed by `riinac --list-compliance`
- Assumptions:
  - compliance checking is opt-in through `--compliance`
  - AST heuristics are treated as proxies for regulatory controls
  - boolean-valued Coq fields are treated as abstractions of compliance truth
- Residual risks:
  - no first-class `Compliance` or `Audit` effect exists in the live language frontend
  - example inventory and public wording exceed what the live parser/typechecker/runtime demonstrably enforce
  - non-Coq lane breadth can create a false sense of independent evidence

## 4. Workflow Matrix

| Workflow | Valid or forbidden | Research | Formalized | Enforced | Tested | Receipted/observable | Notes |
|----------|--------------------|----------|------------|----------|--------|----------------------|-------|
| Select one or more compliance profiles and run policy checks | Valid | Yes | No | Yes | Yes | Yes | Real CLI surface exists via `--compliance` |
| Generate a structured compliance report artifact | Valid | Yes | Partial | Yes | Yes | Yes | Real JSON/text report generator with file hash and profile coverage exists |
| Treat compliance violations as mandatory type errors in the core frontend | Claimed valid | Yes | Partial | No | No | No | No compliance effect/type regime exists in the core typechecker |
| Enforce GDPR/HIPAA/PCI constraints as compile-time semantics, not lint rules | Claimed valid | Yes | Partial | No | Partial | No | Live implementation is a post-typecheck AST walker |
| Run continuous compliance monitoring over deployed behavior | Claimed valid | Yes | Partial | No | No | No | Research and Coq mention monitoring; no live monitor/runtime agent exists |
| Execute flagship `.rii` compliance examples end-to-end | Valid | Yes | No | Partial | No | No | At least `gdpr_consent.rii` fails to parse in the live frontend |
| Provide regulator-grade evidence chains and proofs per control | Claimed valid | Yes | Partial | No | No | Partial | Report generator exists, but no live proof/evidence-chain verifier exists in the domain |

## 5. Property Matrix

| Property | Why it matters | Formal artifact | Enforcement artifact | Tests/examples | Status |
|----------|----------------|-----------------|----------------------|----------------|--------|
| Data minimization | Core GDPR/privacy obligation | `AJ_001_01_gdpr_data_minimization` in Coq | Heuristic GDPR rules in `riina-compliance` | Rule tests only | Partial |
| Purpose limitation | Core GDPR/privacy obligation | `AJ_001_02_gdpr_purpose_limitation` in Coq | Heuristic GDPR rules | Rule tests only | Partial |
| Storage limitation / retention | Time-bounded compliance obligation | `AJ_001_03_gdpr_storage_limitation` in Coq | No frontend retention type/effect regime | Example inventory only | Partial |
| HIPAA audit/access/encryption controls | Core healthcare requirements | `AJ_001_10`-`AJ_001_17` in Coq | Heuristic HIPAA rules | Rule tests only | Partial |
| PCI segmentation/encryption/logging | Core payment requirements | `AJ_001_18`-`AJ_001_25` in Coq | Heuristic PCI-DSS rules | Rule tests only | Partial |
| Control mapping completeness | Needed for auditability of coverage claims | `AJ_001_26_control_mapping_complete` in Coq | Report coverage fields in `report.rs` | Report tests | Partial |
| Evidence chain validity | Needed for real audit trust | `AJ_001_27_evidence_chain_valid` in Coq | Missing live verifier | Missing | Partial |
| Continuous monitoring | Required for the research claim of continuous compliance | `AJ_001_28_continuous_monitoring` in Coq | Missing live runtime monitor | Missing | Missing |

## 6. Formal Evidence

### 6.1 Coq

| File | Key definitions | Key theorems | Nontrivial? | Notes |
|------|-----------------|--------------|-------------|-------|
| `02_FORMAL/coq/domains/VerifiedCompliance.v` | `Regulation`, `ControlStatus`, `PersonalData`, `DataStore`, `PHI`, `CardholderData`, `CompliancePolicy`, `EvidenceChain` | `AJ_001_01`-`AJ_001_35` | Mostly no | Active mechanization exists, but representative theorems simply lift assumptions over constructors or reduce to reflexivity |

### 6.2 Other prover lanes

| Lane | Files | Independent or generated | Serious or cosmetic | Notes |
|------|-------|--------------------------|---------------------|-------|
| Lean | `02_FORMAL/lean/RIINA/Domains/VerifiedCompliance.lean` | Generated/derived | Cosmetic-to-partial | Mirrors Coq structure, not independent evidence |
| Isabelle | `02_FORMAL/isabelle/RIINA/Domains/VerifiedCompliance.thy` | Generated/derived | Cosmetic-to-partial | Mirrors Coq structure, not independent evidence |
| SMT | `02_FORMAL/smt/RIINA/Domains/VerifiedCompliance.smt2` | Derived | Vacuous | Theorems collapse to `= 0 0` placeholders |
| Alloy | `02_FORMAL/alloy/RIINA/Domains/VerifiedCompliance.als` | Generated | Vacuous | Auto-generated from Coq and uses `some store` existence claims |
| F* | `02_FORMAL/fstar/RIINA/Domains/VerifiedCompliance.fst` | Derived | Cosmetic | Derived lane, not independent enforcement evidence |
| TLA+ | `02_FORMAL/tlaplus/RIINA/Domains/VerifiedCompliance.tla` | Derived | Vacuous | Core predicates reduce to `== TRUE` |
| Verus | none domain-specific found | N/A | N/A | No live Verus domain file found for AJ |
| Kani | none domain-specific found | N/A | N/A | No live Kani domain file found for AJ |
| TV | `02_FORMAL/tv/RIINA/Domains/VerifiedCompliance.tv.smt2` | Derived | Cosmetic | Translation-validation artifact, not independent domain reasoning |

### 6.3 Vacuity audit

| Finding | File | Impact | Resolved? |
|---------|------|--------|-----------|
| Core Coq theorems are mostly constructor lifting or reflexive equalities | `02_FORMAL/coq/domains/VerifiedCompliance.v:412-457`, `792-943` | Caps formal depth for the domain | No |
| Coq file is duplicated byte-for-byte in two folders | `02_FORMAL/coq/domains/VerifiedCompliance.v`, `02_FORMAL/coq/compliance/VerifiedCompliance.v` | Inflates apparent authority breadth without adding independent evidence | No |
| SMT lane reduces every theorem to `= 0 0` | `02_FORMAL/smt/RIINA/Domains/VerifiedCompliance.smt2:266-402` | Cannot be counted as serious independent evidence | No |
| Alloy lane is auto-generated and relies on `some store`-style existence checks | `02_FORMAL/alloy/RIINA/Domains/VerifiedCompliance.als:3`, `180-220` | Cannot be counted as serious independent evidence | No |
| TLA+ lane reduces key predicates to `TRUE` | `02_FORMAL/tlaplus/RIINA/Domains/VerifiedCompliance.tla:209-338` | Not meaningful operational evidence | No |

## 7. Implementation Evidence

| Layer | File(s) | What is real today | What is still placeholder |
|------|---------|--------------------|---------------------------|
| Lexer/parser | `03_PROTO/crates/riina-parser/`, general frontend | General language frontend exists | No compliance syntax, no `Pematuhan`/`Compliance` effect syntax, no domain-specific frontend constructs |
| Types/effects | `03_PROTO/crates/riina-types/src/lib.rs` | Real general effect system exists | No `Compliance`, `Pematuhan`, or `Audit` effect in the live core type/effect layer |
| Typechecker | `03_PROTO/crates/riina-typechecker/src/lib.rs`, `program.rs` | Core typechecker exists | No compliance-profile semantics in the typechecker; grep found no compliance identifiers here |
| Runtime | `03_PROTO/crates/riinac/src/main.rs` | Real opt-in CLI hook runs compliance validation after typechecking | No continuous compliance monitor, no runtime evidence-chain verifier, no mandatory enforcement in core execution |
| Codegen | none domain-specific found | None | No compliance-preserving codegen or control instrumentation path was found |
| Tooling | `03_PROTO/crates/riina-compliance/src/lib.rs`, `rules.rs`, `validator.rs`, `report.rs` | Real post-typecheck AST rule engine, profile parsing, report generation, and `1087` targeted tests | Rules are heuristic AST checks, not proof-carrying or type-level compliance guarantees |

## 8. Executable Evidence

| Evidence | Command | Expected outcome | Last verified |
|----------|---------|------------------|---------------|
| Profile inventory | `cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- --list-compliance` | Lists `16` compliance profiles | `2026-03-19` |
| Targeted rule-engine health | `cargo test --quiet -p riina-compliance --manifest-path 03_PROTO/Cargo.toml` | Passes with `1087` tests | `2026-03-19` |
| Flagship compliance example | `cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check --compliance gdpr 07_EXAMPLES/04_compliance/gdpr_consent.rii` | Fails in the live parser with `Unexpected token: KwType` | `2026-03-19` |
| Frontend compliance semantics check | `grep -RIn "Audit\\|Compliance\\|Pematuhan" 03_PROTO/crates/riina-types/src/lib.rs 03_PROTO/crates/riina-parser/src/lib.rs 03_PROTO/crates/riina-typechecker/src/lib.rs 03_PROTO/crates/riina-typechecker/src/program.rs` | Returns no matches | `2026-03-19` |

## 9. Gate Scores

| Gate | Pass / Partial / Fail | Evidence | Notes |
|------|-----------------------|----------|-------|
| `G1` Canonical Identity | Partial | Canonical research file and real tooling surface exist, but the formal lane is split by duplication and the implementation boundary is much narrower than the umbrella claim | Canonical source set can be reconstructed, not cleanly normalized |
| `G2` Boundary Precision | Fail | Research and website/business wording claim compile-time/continuous compliance, while the live surface is opt-in post-typecheck linting and reports | Public boundary is materially overstated |
| `G3` Workflow Inventory | Partial | Real workflows exist for profile selection, AST validation, and report generation | End-to-end regulatory workflows are incomplete and not frontend-enforced |
| `G4` Threat and Failure Model | Fail | No live model for regulator disagreement, cross-system gaps, evidence tampering, monitoring blind spots, or stale rule packs | Research caveats exist, but no enforced failure model exists |
| `G5` Property Set | Partial | Broad property inventory exists in research and Coq | The live enforced property set is only heuristic and incomplete |
| `G6` Formal Model Depth | Fail | Coq exists but is shallow; non-Coq lanes are vacuous or derived | This blocks `R2` |
| `G7` Toolchain Enforcement | Fail | Compliance is opt-in after typechecking; no core compliance effect/type regime exists | Violations are not core type errors |
| `G8` Executable Evidence | Fail | Rule-engine tests pass, but flagship examples do not execute end-to-end through the live frontend | The domain examples are not workflow-complete evidence |
| `G9` Adversarial Coverage | Fail | Rule tests exist, but they are rule-unit tests, not adversarial domain workflows against a verified compliance engine | No regulator-grade attack/tamper/drift coverage |
| `G10` Evidence Honesty Across Prover Lanes | Fail | Duplicate Coq file plus vacuous SMT/Alloy/TLA+ lanes cannot be counted as strong independent evidence | Breadth outruns seriousness |
| `G11` Observability and Auditability | Partial | Compliance reports are real observable artifacts with file hash and profile coverage | No live evidence-chain verifier or continuous-monitoring artifact |
| `G12` Freshness and Reproducibility | Pass | Commands were rerun on current `HEAD` and produced direct evidence for inventory, tests, and example failure | Audit is reproducible on the snapshot |
| `G13` Public Claim Discipline | Fail | `website/src/RiinaWebsite.jsx` and `04_SPECS/business/RIINA_BUSINESS_MODEL_v1_0_0.md` overclaim type-error and compile-time compliance guarantees | Public wording must be reduced |
| `G14` Regression Immunity | Fail | No AJ-specific CI/readiness gate prevents drift between claims and live reality | Domain rating is not protected |

## 10. Rating

- Current rating: `R1`
- Rating cap: `R1`
- Why this is not higher:
  - the live implementation is a real and sizeable opt-in rule/report engine, but it is not a first-class compile-time compliance regime in the language frontend
  - the formal lane is mechanized but shallow, and the secondary lanes are vacuous or derived
  - the flagship example inventory does not currently survive the live frontend as end-to-end executable evidence
- Minimum work to reach next level:
  - replace heuristic post-typecheck validation with a bounded, first-class compliance effect/type regime for a narrowly claimed subset
  - tie that same subset to nontrivial state/trace-level theorems, not just boolean/property lifting
  - execute canonical valid and invalid workflows end-to-end in CI using the live frontend
  - reduce public wording until the above exists

## 11. Safe Public Wording

- Safe claim:
  - `RIINA provides an opt-in, post-typecheck compliance rule engine for multiple regulatory profiles that generates coverage reports, but it does not yet guarantee compliance as an enforced compile-time type property or provide continuous runtime monitoring.`
- Unsafe claim:
  - `Compliance violations are type errors in RIINA, and a type-checked RIINA program is continuously compliant with GDPR, HIPAA, PCI-DSS, and related frameworks.`

## 12. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| No first-class compliance effect/type regime | Critical | Add bounded live frontend semantics for a narrow compliance subset instead of AST-only linting | Pending | Core blocker for `R2+` |
| Formal theorem set is shallow | High | Replace implication/reflexivity theorems with state-transition and trace-level invariants tied to live workflows | Pending | Needed for any serious rating increase |
| Secondary lanes are vacuous/derived | High | Demote or materially strengthen SMT/Alloy/TLA+ and duplicate-lane evidence | Pending | Current breadth is cosmetic |
| Flagship compliance examples are not live executable evidence | High | Make canonical examples parse/typecheck/run through CI or stop counting them as evidence | Pending | `gdpr_consent.rii` currently fails in the live parser |
| Continuous monitoring claim has no live runtime | High | Build an actual runtime monitor/evidence refresh path or remove that claim | Pending | Research claim currently outruns implementation |
| Public wording overclaims compile-time guarantees | Critical | Reduce website and business-language claims to the safe-claim level | Pending | Blocking honest public posture |
| No domain-specific regression gate | Medium | Add AJ readiness checks to fail CI on overclaim or broken canonical workflows | Pending | Needed for `R4-R5` |
| Report coverage is not certification-grade evidence | Medium | Explicitly scope reports as heuristic rule artifacts until proof/evidence-chain binding exists | Pending | Prevents false trust transfer |

## 13. Promotion Checklist

### To reach `R1`

- [x] Canonical scope exists in research
- [x] Canonical source set can be identified
- [ ] Historical/generated/non-authoritative files are clearly demoted in public claims

### To reach `R2`

- [x] Formal model exists
- [ ] Nontrivial theorem set exists for the claimed live subset
- [ ] Workflow-to-proof mapping exists for a bounded live subset

### To reach `R3`

- [ ] Live enforcement exists in the core frontend for a bounded compliance subset
- [ ] Invalid covered cases are rejected as part of the bounded live subset
- [ ] Executable positive path exists for the full stated subset

### To reach `R4`

- [ ] Workflow coverage is complete for the stated scope
- [ ] Negative and adversarial tests exist for the stated scope
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
  - hostile review completed in [AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md)
  - verdict: `accept`
  - reviewer accepted the `R1` cap and the existing gate scores without downgrade
  - reviewer-safe claim is now the safe claim above
- Follow-up date:
  - after bounded frontend compliance semantics and executable canonical workflows land

## 15. Next Audit Handoff

- Recommended next domain:
  - `AK_VERIFIED_PROCUREMENT`
- Recommended pattern:
  - `procurement|supply|vendor|contract|attest|acquisition`
- Why this should be next:
  - it is the next high-risk umbrella in the queue after `AJ_VERIFIED_COMPLIANCE`
  - it likely shares the same risk pattern of broad policy/compliance research outrunning live enforcement
  - it sits close to audit/compliance claim surfaces already showing overstatement risk
- Files to start from:
  - `01_RESEARCH/*AJ*` remediation carry-over for method corrections
  - `01_RESEARCH/*AK*`
  - domain formal files under `02_FORMAL/*`
  - live tooling or example surfaces under `03_PROTO/` and `07_EXAMPLES/`
- Cross-domain risks to carry forward:
  - duplicated Coq authorities
  - vacuous non-Coq lanes
  - conceptual examples not executable through the live frontend
