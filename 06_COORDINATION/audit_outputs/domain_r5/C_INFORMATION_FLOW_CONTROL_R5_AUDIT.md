# Domain Audit Record

## 1. Identity

- Domain name: Information Flow Control
- Domain identifier: `C_INFORMATION_FLOW_CONTROL`
- Folder(s): `01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/`, `02_FORMAL/coq/domains/{TaintSystemCorrectness,Z001_DeclassificationPolicy,QuantitativeDeclassification}.v`, `02_FORMAL/coq/properties/Declassification.v`, `02_FORMAL/coq/foundations/{Syntax,Typing}.v`, `03_PROTO/crates/riina-{types,parser,typechecker}/`, `07_EXAMPLES/01_security/`
- Audit date: `2026-03-20`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Command-derived test evidence:
  - `riina-typechecker`: `258` total passed, `109` formalized tests passed, `65` IFC-specific formalized tests (Bell-LaPadula, declassification, taint, CSRF, SQL injection, implicit flow, constant-time, sanitizer, path traversal)
- Coq theorem count (command-derived):
  - `TaintSystemCorrectness.v`: `52` Qed, `0` Admitted
  - `Z001_DeclassificationPolicy.v`: `36` Qed, `0` Admitted
  - `QuantitativeDeclassification.v`: `22` Qed, `0` Admitted
  - `Declassification.v` (properties): `27` Qed, `0` Admitted
  - **Total IFC-specific: 137 Qed, 0 Admitted**

## 2. Canonical Source Map

### Canonical research authority

- `01_RESEARCH/03_DOMAIN_C_INFORMATION_FLOW_CONTROL/` — 9 research documents
- Key decisions (all APPROVED):
  - `RESEARCH_C01_IFC_FOUNDATIONS_DECISION.md` — static IFC with DLM-style labels, termination-insensitive noninterference
  - `RESEARCH_C02_SECURITY_TYPES_DECISION.md` — labeled types (T @ L), PC tracking, label polymorphism
  - `RESEARCH_C03_LABEL_MODELS_DECISION.md` — 5-level security lattice (Public → TopSecret), compartments, DLM

### Canonical formal files

- `02_FORMAL/coq/domains/TaintSystemCorrectness.v` — taint source tracking (15 variants), sanitizer soundness (9 variants), type preservation for tainted types
- `02_FORMAL/coq/domains/Z001_DeclassificationPolicy.v` — DLM principals, authority relations, security level lattice, declassification policy validation
- `02_FORMAL/coq/domains/QuantitativeDeclassification.v` — budget-based declassification, composition soundness
- `02_FORMAL/coq/properties/Declassification.v` — semantic typing for declassification, secret indistinguishability, policy-safe declassification
- `02_FORMAL/coq/foundations/Syntax.v` — security_level (6 variants), taint_source (15 variants), sanitizer (9 variants), TLabeled, TTainted, TSecret, EDeclassify
- `02_FORMAL/coq/foundations/Typing.v` — IFC typing rules, PC tracking, label subtyping

### Non-authoritative or generated prover evidence

All non-Coq IFC lanes are auto-generated (confirmed by markers):
- Lean: `02_FORMAL/lean/RIINA/Properties/Declassification.lean`, `NonInterference.lean` and variants
- SMT: `02_FORMAL/smt/RIINA/Properties/Declassification.smt2`
- TLA+: `02_FORMAL/tlaplus/RIINA/Properties/NonInterference_v2.tla`
- Alloy: `02_FORMAL/alloy/RIINA/Properties/NonInterference_v2.als`
- Isabelle, F*: limited/auxiliary files

### Canonical implementation files

- `03_PROTO/crates/riina-types/src/lib.rs` — SecurityLevel (6 levels), TaintSource (15 variants), Sanitizer (30+ variants), Ty::Labeled, Ty::Tainted, Ty::Secret, Ty::Sanitized
- `03_PROTO/crates/riina-parser/src/lib.rs` — bilingual security level parsing (Awam/Public, Rahsia/Secret, etc.)
- `03_PROTO/crates/riina-typechecker/src/lib.rs` — IFC enforcement: SecurityViolation, InvalidDeclassification, ImplicitFlowViolation, TaintViolation, SanitizerMismatch, ConstantTimeViolation, Bell-LaPadula no-read-up/no-write-down, taint compatibility, declass_ok()

### Canonical example evidence

- `07_EXAMPLES/01_security/tainted_data.rii` (181 lines) — multi-source taint propagation and sanitization
- `07_EXAMPLES/01_security/declassify.rii` (152 lines) — declassification with proof obligations
- `07_EXAMPLES/01_security/info_flow.rii` (156 lines) — IFC enforcement with sink checks
- `07_EXAMPLES/01_security/security_levels.rii` (163 lines) — 6-level lattice demonstration

Note: examples are NOT toolchain-tested (same gap as B_EFFECT_SYSTEMS).

## 3. Scope

- Covered problem: static information flow control with type-level taint tracking, security labels, declassification with proofs, implicit flow prevention via program counter elevation
- Explicitly excluded: dynamic IFC (research only), multi-shot declassification revocation, distributed IFC across network boundaries, runtime taint propagation (only type-level)
- Covered actors: programmer (writes labeled/tainted code), compiler (enforces IFC rules), type system (tracks taint and labels)
- Covered assets: security labels, taint markers, sanitized data, classified/secret data, declassification proofs
- Covered trust boundaries: public/secret boundary (Bell-LaPadula), taint/clean boundary (sanitization), declassification boundary (proof obligation)
- Covered lifecycle phases: parsing, type checking
- Assumptions:
  - 6-level lattice is total and sufficient (Public ⊑ Internal ⊑ Session ⊑ User ⊑ System ⊑ Secret)
  - Taint sources are statically enumerable (15 variants)
  - Declassification requires structural proof matching
  - Termination-insensitive noninterference (timing channels excluded)
- Residual risks:
  - No runtime taint tracking — IFC is type-level only
  - No distributed IFC across process/network boundaries
  - .rii examples not toolchain-tested
  - Timing/covert channels explicitly excluded (termination-insensitive model)

## 4. Workflow Matrix

| Workflow | Valid or forbidden | Research | Formalized | Enforced | Tested | Notes |
|----------|--------------------|----------|------------|----------|--------|-------|
| Read secret ref in public context | Forbidden | Yes | Yes (Typing.v: no-read-up) | Yes (deref check) | Yes (test_bell_lapadula_deref_no_read_up, test_deref_secret_in_public_context_fails) | Bell-LaPadula |
| Write public ref in secret context | Forbidden | Yes | Yes (Typing.v: no-write-down) | Yes (assign check) | Yes (test_bell_lapadula_assign_no_write_down, test_assign_public_ref_in_secret_context_fails) | Bell-LaPadula |
| Write secret ref in public context | Valid | Yes | Yes | Yes | Yes (test_assign_secret_ref_in_public_context_ok) | Safe direction |
| Tainted data to SQL sink without sanitization | Forbidden | Yes | Yes (TaintSystemCorrectness.v) | Yes (TaintViolation) | Yes (test_sql_injection_prevented) | |
| Tainted data sanitized then used | Valid | Yes | Yes | Yes (Sanitized type) | Yes (test_sql_injection_safe_with_sanitization) | |
| Wrong sanitizer for sink | Forbidden | Yes | Yes | Yes (SanitizerMismatch) | Yes (test_sanitizer_mismatch) | |
| Declassify with valid proof | Valid | Yes | Yes (Declassification.v) | Yes (declass_ok) | Yes (test_proper_declassification) | |
| Declassify with wrong proof | Forbidden | Yes | Yes | Yes (InvalidDeclassification) | Yes (test_declassify_wrong_proof_structure) | |
| Implicit flow via secret branch to public write | Forbidden | Yes | Yes (PC tracking) | Yes (ImplicitFlowViolation) | Yes (test_implicit_flow_secret_deref_then_assign_public, test_implicit_flow_via_secret_comparison_in_public_context) | Denning-style |
| CSRF without token | Forbidden | Yes | Yes | Yes | Yes (test_csrf_post_without_token_fails, 10+ CSRF tests) | |
| Constant-time value in branch | Forbidden | Yes | Yes | Yes (ConstantTimeViolation) | Yes (test_ct_comparison_then_if_rejected, test_if_on_constant_time_bool_rejected) | |
| Path traversal without sanitization | Forbidden | Yes | Yes | Yes | Yes (test_path_traversal_prevented) | |
| Command injection without sanitization | Forbidden | Yes | Yes | Yes | Yes (test_command_injection_prevented) | |
| Email header injection | Forbidden | Yes | Yes | Yes | Yes (test_email_header_injection_prevented) | |

## 5. Property Matrix

| Property | Why it matters | Formal artifact | Enforcement artifact | Tests | Status |
|----------|----------------|-----------------|----------------------|-------|--------|
| No-read-up (Bell-LaPadula) | Prevents secret data leaking to public context | Typing.v (IFC rules) | typechecker deref check | test_bell_lapadula_deref_no_read_up | Proven + enforced + tested |
| No-write-down (Bell-LaPadula) | Prevents secret-context writes to public refs | Typing.v (IFC rules) | typechecker assign check | test_bell_lapadula_assign_no_write_down | Proven + enforced + tested |
| Taint type preservation | Tainted data stays tainted until sanitized | TaintSystemCorrectness.v (52 theorems) | type compatibility checks | test_sql_injection_prevented + 10 more | Proven + enforced + tested |
| Sanitizer soundness | Correct sanitizer removes correct taint | TaintSystemCorrectness.v | SanitizerMismatch error | test_sanitizer_mismatch | Proven + enforced + tested |
| Declassification policy safety | Only valid proofs declassify | Declassification.v, Z001_DeclassificationPolicy.v | declass_ok() | test_proper_declassification, test_declassify_wrong_proof_structure | Proven + enforced + tested |
| Secret indistinguishability | Secrets are trivially related (noninterference foundation) | Declassification.v: val_rel_le_secret_trivial | TSecret type constructor | Implicit in formalized tests | Proven |
| Budget monotonicity | Declassification budget only decreases | QuantitativeDeclassification.v (22 theorems) | Not directly enforced in typechecker | None | Proven, not enforced |
| Implicit flow prevention | PC elevation blocks secret→public leaks | Typing.v (PC tracking) | typechecker delta elevation | test_implicit_flow_* (2 tests) | Proven + enforced + tested |
| Constant-time guarantee | CT values never branch | Type system | ConstantTimeViolation | test_ct_comparison_then_if_rejected | Enforced + tested |

## 6. Formal Evidence

### 6.1 Coq

| File | Key definitions | Key theorems | Nontrivial? | Notes |
|------|-----------------|--------------|-------------|-------|
| TaintSystemCorrectness.v | taint_source (15), sanitizer (9), TTainted, TSanitized | 52: type preservation, sanitization soundness, taint propagation | Yes — structural induction on taint flows | Domain-critical |
| Z001_DeclassificationPolicy.v | Principal, authority, security_level lattice, labels | 36: lattice laws, principal ordering, policy validation | Yes — algebraic + authority reasoning | DLM formalization |
| QuantitativeDeclassification.v | budget, low_equiv, declass_cost | 22: budget monotonicity, composition soundness | Yes — quantitative reasoning | Budget tracking |
| Declassification.v | val_rel_at_type, declass_ok | 27: secret trivial relation, semantic typing, policy safety | Yes — logical relations | Noninterference foundation |

### 6.2 Other prover lanes

| Lane | Files | Independent or generated | Serious or cosmetic | Notes |
|------|-------|--------------------------|---------------------|-------|
| Lean | Declassification.lean, NonInterference*.lean (6+ files) | Generated | Cosmetic | Auto-generated from Coq |
| SMT | Declassification.smt2, NonInterference_v2.smt2 | Generated | Cosmetic | Partial bindings |
| TLA+ | NonInterference_v2.tla | Generated | Cosmetic | State machine model |
| Alloy | NonInterference_v2.als | Generated | Cosmetic | Relational model |
| Isabelle | StoreRelation.thy (auxiliary) | Limited | Cosmetic | No primary IFC formalization |
| F* | NonInterference_v2_LogicalRelation.fst | Limited | Cosmetic | Stub |

### 6.3 Vacuity audit

| Finding | File | Impact | Resolved? |
|---------|------|--------|-----------|
| All non-Coq lanes auto-generated | All non-Coq IFC files | Cannot count as independent | Documented |
| .rii examples not toolchain-tested | 07_EXAMPLES/01_security/*.rii | Medium — syntax not verified by toolchain | Unresolved |
| Budget-based declassification not enforced in runtime | QuantitativeDeclassification.v | Low — proven but not implemented | Documented |

## 7. Implementation Evidence

| Layer | File(s) | What is real today | What is still placeholder |
|------|---------|--------------------|---------------------------|
| Types | riina-types/src/lib.rs | SecurityLevel (6), TaintSource (15), Sanitizer (30+), Ty::Labeled, Ty::Tainted, Ty::Secret, Ty::Sanitized | None for core types |
| Parser | riina-parser/src/lib.rs | Bilingual security level parsing (Awam/Public, Rahsia/Secret, etc.) | |
| Typechecker | riina-typechecker/src/lib.rs | Bell-LaPadula no-read-up/no-write-down, taint compatibility, declass_ok(), implicit flow via PC elevation, sanitizer matching, constant-time checking | Budget-based declassification not enforced |
| Runtime | N/A | No runtime IFC enforcement | Runtime taint tracking not implemented |

## 8. Executable Evidence

| Evidence | Command | Expected outcome | Last verified |
|----------|---------|------------------|---------------|
| No-read-up | `cargo test -p riina-typechecker -- test_bell_lapadula_deref_no_read_up` | 1 passed | 2026-03-20 |
| No-write-down | `cargo test -p riina-typechecker -- test_bell_lapadula_assign_no_write_down` | 1 passed | 2026-03-20 |
| SQL injection prevented | `cargo test -p riina-typechecker -- test_sql_injection_prevented` | 1 passed (via formalized_tests) | 2026-03-20 |
| Declassify wrong proof rejected | `cargo test -p riina-typechecker -- test_declassify_wrong_proof_structure` | 1 passed (via formalized_tests) | 2026-03-20 |
| Implicit flow detected | `cargo test -p riina-typechecker -- test_implicit_flow` | 2+ passed (via formalized_tests) | 2026-03-20 |
| All 65 IFC formalized tests | `cargo test -p riina-typechecker -- formalized_tests` | 109 passed (65 IFC-specific) | 2026-03-20 |
| .rii examples | None | Not tested | Never |

## 9. Gate Scores

| Gate | Pass / Partial / Fail | Evidence | Notes |
|------|-----------------------|----------|-------|
| `G1` Canonical Identity | Pass | One domain name, one identifier, one research folder (9 docs), 3 approved decisions | Clear authority |
| `G2` Boundary Precision | Partial | Scope covers taint + labels + declassification. Exclusions (dynamic IFC, distributed IFC, timing channels) identified in research but not consolidated | Same pattern as B_EFFECT_SYSTEMS |
| `G3` Workflow Inventory | Pass | 14 workflows identified and tested in workflow matrix, with both valid and forbidden cases | Stronger than B_EFFECT_SYSTEMS — explicit attack patterns tested |
| `G4` Threat and Failure Model | Partial | Attack patterns modeled (SQL injection, CSRF, path traversal, command injection, email injection, implicit flows). But no consolidated adversary model document | Implicit in tests, not documented |
| `G5` Property Set | Pass | Bell-LaPadula, taint preservation, sanitizer soundness, declassification safety, secret indistinguishability, implicit flow prevention, constant-time | Comprehensive and domain-shaped |
| `G6` Formal Model Depth | Pass | 137 Coq Qed theorems, zero Admitted, nontrivial (taint tracking, lattice laws, logical relations, budget reasoning) | Strong |
| `G7` Toolchain Enforcement | Pass | Parser handles security levels, typechecker enforces 6 distinct IFC error types, real rejection logic for Bell-LaPadula, taint, sanitizer, declassification, implicit flow, constant-time | Multi-faceted enforcement |
| `G8` Executable Evidence | Partial | 65 IFC-specific formalized tests with positive and negative cases. But .rii examples not toolchain-tested | Strong test suite but example gap remains |
| `G9` Adversarial Coverage | Pass | 65 formalized tests cover: SQL injection, CSRF (10 tests), command injection, path traversal, email injection, deserialization, implicit flow, constant-time bypass, sanitizer mismatch, wrong declassification proof | Substantially stronger than B_EFFECT_SYSTEMS |
| `G10` Evidence Honesty Across Prover Lanes | Pass | All non-Coq lanes marked as generated, not counted as independent | Honest |
| `G11` Observability and Auditability | Pass | Clear trace: Coq theorems → Rust type errors → formalized tests with Coq rule references | Good traceability |
| `G12` Freshness and Reproducibility | Pass | All counts command-derived on 2026-03-20 | Fresh |
| `G13` Public Claim Discipline | Not audited | Deferred to hostile review | |
| `G14` Regression Immunity | Partial | Tests exist but hook-gated, not CI-gated | Same as B_EFFECT_SYSTEMS |

## 10. Rating

- Current rating: **R3**
- Rating cap: R3 — capped by G8 (partial: .rii examples untested), G2 (partial: boundaries not consolidated), G4 (partial: no explicit threat model document), G14 (partial: hook-gated)
- Why this is not R4:
  - .rii examples remain untested by the toolchain
  - No consolidated boundary/threat model document
  - Budget-based declassification is proven but not enforced in typechecker
- Why this is not R2:
  - Real enforcement exists across parser, typechecker with 6 distinct error types
  - 65 IFC-specific formalized tests including attack pattern coverage
  - Bell-LaPadula, taint, declassification all enforced with rejection evidence
- Minimum work to reach R4:
  1. Wire .rii security examples into integration tests
  2. Write consolidated boundary and threat model document
  3. Implement budget-based declassification enforcement in typechecker (optional — could scope-exclude)

## 11. Safe Public Wording

- Safe claim: "Information flow control with static taint tracking, Bell-LaPadula enforcement, declassification with proof obligations, and implicit flow prevention, formally modeled (137 Coq theorems) and enforced at compile time for covered workflows"
- Unsafe claim: "Complete IFC system", "R5 information flow control", "all information flows verified", "runtime taint tracking"

## 12. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| .rii examples not toolchain-tested | Medium | Integration test for 07_EXAMPLES/01_security/*.rii | Implementation | Same gap as B_EFFECT_SYSTEMS |
| No consolidated threat model document | Medium | Write threat model covering all 14 attack patterns | Documentation | |
| Budget declassification not enforced | Low | Implement budget tracking in typechecker or scope-exclude | Implementation/Scope | Proven in Coq, not yet in Rust |
| No runtime taint tracking | Low | Implement or scope-exclude | Implementation/Scope | Type-level only is acceptable for R3 |

## 13. Promotion Checklist

### To reach `R1`

- [x] Canonical scope exists
- [x] Canonical source set exists
- [x] Historical files demoted

### To reach `R2`

- [x] Formal model exists (137 Qed)
- [x] Nontrivial theorems exist
- [x] Workflow-to-proof mapping exists

### To reach `R3`

- [x] Live enforcement exists (6 error types in typechecker)
- [x] Invalid covered case is rejected (65 formalized tests)
- [x] Executable positive path exists

### To reach `R4`

- [ ] Workflow coverage complete for stated scope — .rii examples untested
- [x] Negative and adversarial tests exist — 65 IFC-specific formalized tests
- [x] Residual risks explicit

### To reach `R5`

- [ ] Every gate passes — G2, G4, G8, G14 partial
- [ ] Third-party reproduction possible — partially
- [ ] Public wording conservative — not audited
- [ ] Regression checks exist — hook-gated

## 14. Sign-Off

- Final verdict: **R3 — Enforced for covered workflows**
- Reviewer notes: This domain is strong — deeper adversarial test coverage than B_EFFECT_SYSTEMS (65 IFC-specific tests covering SQL injection, CSRF, path traversal, command injection, implicit flow, constant-time bypass). The formal layer is solid (137 Coq Qed, zero Admitted). Main gaps are .rii example testing and documentation consolidation. Closer to R4 than B_EFFECT_SYSTEMS but the same .rii example gap holds it back.
- Follow-up date: After .rii example integration tests and consolidated threat model document

## 15. Hostile Review Reconciliation

- Hostile review: [C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/C_INFORMATION_FLOW_CONTROL_R5_REVIEW.md)
- Hostile reviewer: Gemini CLI (v0.34.0)
- Hostile review date: 2026-03-20
- Hostile review verdict: **accept** (no reductions)
- Hostile review maximum honest rating: **R3** (agrees with primary audit)
- Hostile review findings: None. Zero overclaim lines. Zero missed evidence lines.
- Reconciliation action: No rating change required. Primary audit R3 confirmed by hostile review.
- Final reconciled rating: **R3**
- Remediation package: [README.md](/workspaces/proof/06_COORDINATION/remediation/C_INFORMATION_FLOW_CONTROL/README.md)
- Domain status: **CLOSED** at R3 until remediation items are addressed
