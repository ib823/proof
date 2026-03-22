# Domain Audit Record

## 1. Identity

- Domain name: Effect Systems
- Domain identifier: `B_EFFECT_SYSTEMS`
- Folder(s): `01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/`, `02_FORMAL/coq/effects/`, `02_FORMAL/coq/domains/AlgebraicEffects.v`, `03_PROTO/crates/riina-types/`, `03_PROTO/crates/riina-parser/`, `03_PROTO/crates/riina-typechecker/`, `03_PROTO/crates/riina-codegen/`, `03_PROTO/crates/riina-pkg/`, `07_EXAMPLES/02_effects/`
- Audit date: `2026-03-20`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Command-derived Rust passing tests on this snapshot:
  - `riina-typechecker`: `258` passed (12 effect-specific, including 3 negative rejection tests)
  - `riina-codegen`: `493` passed (including `test_eval_grant_require`, `test_eval_missing_capability`, `test_lower_grant`, `test_lower_require`)
  - `riina-pkg`: `5` effect-specific passed (including `escalation_detected`)
- Coq theorem count (command-derived):
  - `EffectAlgebra.v`: `44` Qed, `0` Admitted
  - `EffectSystem.v`: `36` Qed, `0` Admitted
  - `EffectGate.v`: `40` Qed, `0` Admitted
  - `AlgebraicEffects.v`: `22` Qed, `0` Admitted
  - **Total: 142 Qed, 0 Admitted**

## 2. Canonical Source Map

### Canonical research authority

- `01_RESEARCH/02_DOMAIN_B_EFFECT_SYSTEMS/`
- 20 research documents: surveys, comparisons, and decisions (ADR format)
- Key decisions:
  - `RESEARCH_B01_ALGEBRAIC_EFFECTS_DECISION.md` — algebraic effects adopted
  - `RESEARCH_B03_COEFFECTS_DECISION.md` — graded coeffects with semiring structure
  - `RESEARCH_B04_EFFECT_HANDLERS_DECISION.md` — deep handlers, evidence-passing, multi-shot continuations
  - `RESEARCH_B09_EFFECT_SUBTYPING_SURVEY.md` and `_DECISION.md`
  - `RESEARCH_B10_EFFECTS_PRACTICE_DECISION.md` — production-ready standard handlers

### Additional research in specs layer

- `01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_SURVEY.md`
- `01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_COMPARISON.md`
- `01_RESEARCH/specs/RESEARCH_A05_EFFECT_SYSTEMS_DECISION.md`
- `01_RESEARCH/specs/RESEARCH_A11_EFFECT_TYPES_DECISION.md`
- `01_RESEARCH/specs/RESEARCH_B*` (duplicates of domain folder contents)

### Canonical formal files

- `02_FORMAL/coq/effects/EffectAlgebra.v` — lattice structure, join/meet laws, decidability
- `02_FORMAL/coq/effects/EffectSystem.v` — typing rules, effect safety theorem, monotonicity
- `02_FORMAL/coq/effects/EffectGate.v` — capability gating, grant/require, perform_requires_license
- `02_FORMAL/coq/domains/AlgebraicEffects.v` — handler semantics, deep/shallow handlers, effect masking

### Non-authoritative or generated prover evidence

All non-Coq prover lanes are auto-generated (confirmed by `Derived from` / `Auto-generated` markers):
- Lean: `02_FORMAL/lean/RIINA/Effects/{EffectAlgebra,EffectSystem,EffectGate}.lean`
- Isabelle: `02_FORMAL/isabelle/RIINA/Effects/{EffectAlgebra,EffectSystem,EffectGate}.thy`
- SMT: `02_FORMAL/smt/RIINA/Effects/{EffectAlgebra,EffectSystem,EffectGate}.smt2`
- Alloy: `02_FORMAL/alloy/RIINA/Effects/{EffectAlgebra,EffectSystem,EffectGate}.als`
- F*: `02_FORMAL/fstar/RIINA/Effects/{EffectAlgebra,EffectSystem,EffectGate}.fst`
- TLA+: `02_FORMAL/tlaplus/RIINA/Effects/EffectGate.tla`
- Verus: `02_FORMAL/verus/RIINA/Effects/{effect_algebra,effect_system,effect_gate}*.rs`

These are useful for traceability but cannot count as independent evidence.

### Canonical implementation files

- `03_PROTO/crates/riina-types/src/lib.rs` — Effect enum (19 variants), level ordering, join, category
- `03_PROTO/crates/riina-parser/src/lib.rs` — `parse_effect()` with bilingual keywords (kesan, Bersih, Tulis, etc.)
- `03_PROTO/crates/riina-typechecker/src/lib.rs` — `EffectViolation`, `CapabilityViolation`, effect tracking in type inference
- `03_PROTO/crates/riina-typechecker/src/program.rs` — whole-program capability analysis, function effect bounds
- `03_PROTO/crates/riina-codegen/src/interp.rs` — runtime capability set, `MissingCapability` error
- `03_PROTO/crates/riina-codegen/src/lower.rs` — effect inference during IR lowering
- `03_PROTO/crates/riina-pkg/src/effects.rs` — package-level effect escalation checking

### Canonical example evidence

- `07_EXAMPLES/02_effects/` — 17 `.rii` files
- Representative: `pure_functions.rii`, `effect_composition.rii`, `capability_gated.rii`, `network.rii`, `effect_handlers.rii`

Current truth:
- Examples demonstrate valid syntax and real workflows (I/O, network, crypto, capability gating)
- **Examples are NOT toolchain-tested**: no Rust test references `07_EXAMPLES/02_effects/` — they are static demonstrations only

### Specifications

- `04_SPECS/effect_gate/` contains only `.gitkeep` — no separate specification document exists
- Specifications are embedded in research decisions and Coq files

## 3. Scope

- Covered problem: algebraic effect system with compile-time and runtime enforcement, capability gating, handler semantics
- Explicitly excluded problem: coeffect runtime tracking (decided in research but not implemented), row polymorphism (research only), effect handler optimization (research only), multi-shot continuations (research only — Coq models deep/shallow semantics but runtime only supports basic handlers)
- Covered actors: programmer (writes effect-annotated functions), compiler (checks effect bounds), runtime (enforces capabilities), package manager (checks effect escalation across dependencies)
- Covered assets: effect annotations, capability grants, effect handlers
- Covered trust boundaries: function boundaries (effect ceiling), package boundaries (escalation checking), scope boundaries (grant/require)
- Covered lifecycle phases: parsing, type checking, runtime interpretation, package dependency checking
- Covered jurisdictions or standards: none (language-internal property)
- Assumptions:
  - Effect level ordering is total and linear (enforced by `effect_level()` mapping)
  - Only the 19 defined effects exist; user-defined effects are not supported
  - Grant/require is scoped — capabilities do not leak across scope boundaries
- Residual risks:
  - Coeffect tracking (decided but not implemented) could be needed for advanced resource-bounded use cases
  - Handler semantics in Coq are richer than what the runtime supports
  - The .rii example corpus is untested — syntax correctness is assumed, not verified
  - Effect handler optimization (zero-overhead state/reader) is research only

## 4. Workflow Matrix

| Workflow | Valid or forbidden | Research | Formalized | Enforced | Tested | Receipted/observable | Notes |
|----------|--------------------|----------|------------|----------|--------|----------------------|-------|
| Declare function with effect annotation | Valid | Yes | Yes (EffectSystem.v) | Yes (parser + typechecker) | Yes (258 tests) | No | Core workflow |
| Pure function performs impure operation | Forbidden | Yes | Yes (EffectGate.v: perform_requires_license) | Yes (EffectViolation error) | Yes (check_program_rejects_zero_arg_pure_function_with_system_effect) | No | Key negative case |
| Require effect without prior grant | Forbidden | Yes | Yes (EffectGate.v: grant_no_escalation) | Yes (CapabilityViolation error) | Yes (check_program_rejects_missing_top_level_capability) | No | Capability check |
| Call function requiring effect without enclosing grant | Forbidden | Yes | Yes (EffectGate.v) | Yes (CapabilityViolation) | Yes (check_program_rejects_zero_arg_function_call_without_grant) | No | Cross-function flow |
| Grant provides capability for enclosed scope | Valid | Yes | Yes (EffectGate.v: grant_effect_transparent) | Yes (typechecker with_grant + interpreter caps.grant) | Yes (check_program_allows_granted_top_level_capability) | No | |
| Package dependency escalates effects | Forbidden | Yes | No | Yes (riina-pkg check_escalation) | Yes (escalation_detected) | No | Package boundary |
| Effect handler catches performed effect | Valid | Yes | Yes (AlgebraicEffects.v: deep/shallow handler semantics) | Partial (interp handles basic Perform/Handle) | Partial (test_eval_grant_require) | No | Handler runtime is basic |
| Effect composition across multiple effects | Valid | Yes | Yes (EffectAlgebra.v: join, meet) | Yes (effect.join in typechecker) | Yes (test_full_effect_accumulation) | No | |

## 5. Property Matrix

| Property | Why it matters | Formal artifact | Enforcement artifact | Tests/examples | Status |
|----------|----------------|-----------------|----------------------|----------------|--------|
| Effect safety | Well-typed programs only perform annotated effects | EffectSystem.v: `effect_safety` | typechecker EffectViolation | `check_program_rejects_zero_arg_pure_function_with_system_effect` | Proven + enforced + tested |
| Effect monotonicity | Weakening preserves well-typedness | EffectSystem.v: `performs_within_mono` | typechecker effect.join | Implicit in 258 passing tests | Proven + enforced |
| Non-escalation | Grant cannot escalate beyond scope | EffectGate.v: `grant_no_escalation` | typechecker CapabilityViolation | `check_program_rejects_missing_top_level_capability` | Proven + enforced + tested |
| Perform requires license | Non-pure effects blocked in pure context | EffectGate.v: `perform_requires_license`, `nonpure_perform_blocked` | typechecker + runtime MissingCapability | `test_eval_missing_capability` | Proven + enforced + tested |
| Effect lattice laws | Join/meet are well-defined operations | EffectAlgebra.v: 44 lattice theorems | riina-types Effect::join | Implicit | Proven + enforced |
| Package effect containment | Dependencies cannot require more effects than parent | Not formalized in Coq | riina-pkg check_escalation | `escalation_detected`, `permits_check` | Enforced + tested |
| Handler typing | Handlers are well-typed | AlgebraicEffects.v: `EFF_001_03_handler_typing` | typechecker Handle branch | `test_eval_grant_require` | Proven + partially enforced |
| Effect composition soundness | Join of effect sets is complete | EffectAlgebra.v + EffectSystem.v | typechecker computes joins | `test_full_effect_accumulation` | Proven + enforced |

## 6. Formal Evidence

### 6.1 Coq

| File | Key definitions | Key theorems | Nontrivial? | Notes |
|------|-----------------|--------------|-------------|-------|
| EffectAlgebra.v | effect_leq, effect_join, effect_meet | 44 lattice theorems: commutativity, associativity, absorption, distribution, decidability | Yes — structural algebraic proofs with lia | Complete lattice formalization |
| EffectSystem.v | has_type, performs_within, core_effects | effect_safety, performs_within_mono, effect_isolation, app/if/let composition | Yes — induction on typing derivations | Main safety theorem |
| EffectGate.v | gate_holds, grant_env, perform_licensed | perform_requires_license, grant_no_escalation, effect_sound_after_step, program_effect_contained, pure_program_no_effects | Yes — negation reasoning, multi-step soundness | Security-critical gating proofs |
| AlgebraicEffects.v | effect_sig, handler, eff_row | 22 theorems: handler typing, deep/shallow semantics, masking, resumption linearity, parametricity, coherence | Yes — mutual induction on handler forms | Handler formalization |

### 6.2 Other prover lanes

| Lane | Files | Independent or generated | Serious or cosmetic | Notes |
|------|-------|--------------------------|---------------------|-------|
| Lean | 3 files in Effects/ | Generated (marked "Derived from") | Cosmetic — cannot count as independent | Auto-generated by generate-full-stack.py |
| Isabelle | 3 files in Effects/ | Generated (marked "Derived from") | Cosmetic | Auto-generated |
| SMT | 3 files in Effects/ + 2 in Properties/ + 1 in Domains/ | Generated (marked "Derived from") | Cosmetic — need to check for vacuous assertions | Auto-generated |
| Alloy | 3 files in Effects/ | Generated | Cosmetic | Auto-generated |
| F* | 3 files in Effects/ | Generated (marked "Derived from") | Cosmetic | Auto-generated |
| TLA+ | 1+ files in Effects/ | Generated (marked "Derived from") | Cosmetic | Auto-generated |
| Verus | 6+ files in Effects/ | Generated | Cosmetic | Auto-generated |
| Kani | Not checked for effect-specific files | Presumed generated | Cosmetic | N/A |
| TV | Not checked | Presumed generated | Cosmetic | N/A |

### 6.3 Vacuity audit

| Finding | File | Impact | Resolved? |
|---------|------|--------|-----------|
| All non-Coq lanes are auto-generated from Coq | All non-Coq effect files | Cannot count as independent verification | Documented — not counted |
| SMT assertions may include tautological checks | smt/Effects/*.smt2 | Low — Coq is primary evidence | Not audited in detail |
| .rii examples are not toolchain-tested | 07_EXAMPLES/02_effects/*.rii | Medium — cannot verify they parse/typecheck | Unresolved |
| 04_SPECS/effect_gate/ is empty | 04_SPECS/effect_gate/.gitkeep | Low — specs embedded in research and Coq | Acceptable |

## 7. Implementation Evidence

| Layer | File(s) | What is real today | What is still placeholder |
|------|---------|--------------------|---------------------------|
| Lexer/parser | riina-parser/src/lib.rs:1241-1267 | Full bilingual `parse_effect()`: 19 effects × 2 names each; `kesan` keyword parsed; invalid effects rejected | None for basic effects; user-defined effects not supported |
| Types/effects | riina-types/src/lib.rs:132-198 | Effect enum (19 variants), level(), category(), join(), is_local(), to_capability_kind() | Coeffect tracking not implemented |
| Typechecker | riina-typechecker/src/lib.rs + program.rs | EffectViolation, CapabilityViolation, Grant/Require scoped checking, whole-program capability analysis, function effect ceiling enforcement | Effect handler type checking is basic |
| Runtime | riina-codegen/src/interp.rs:612-778 | CapabilitySet, MissingCapability error, Grant/Require/Perform enforcement | Handler dispatch only supports basic cases |
| Codegen | riina-codegen/src/lower.rs:598-702 | Effect inference during IR lowering | C codegen effect passthrough not audited |
| Tooling | riina-pkg/src/effects.rs | EffectPermissions, check_escalation across package boundaries | No manifest-level effect declaration syntax audited |

## 8. Executable Evidence

| Evidence | Command | Expected outcome | Last verified |
|----------|---------|------------------|---------------|
| Positive: typechecker allows granted capability | `cargo test -p riina-typechecker -- check_program_allows_granted_top_level_capability` | 1 test passed | 2026-03-20 |
| Negative: pure function with system effect rejected | `cargo test -p riina-typechecker -- check_program_rejects_zero_arg_pure_function_with_system_effect` | 1 test passed (EffectViolation) | 2026-03-20 |
| Negative: missing capability rejected | `cargo test -p riina-typechecker -- check_program_rejects_missing_top_level_capability` | 1 test passed (CapabilityViolation) | 2026-03-20 |
| Negative: function call without grant rejected | `cargo test -p riina-typechecker -- check_program_rejects_zero_arg_function_call_without_grant` | 1 test passed (CapabilityViolation) | 2026-03-20 |
| Positive: runtime grant/require | `cargo test -p riina-codegen -- test_eval_grant_require` | 1 test passed | 2026-03-20 |
| Negative: runtime missing capability | `cargo test -p riina-codegen -- test_eval_missing_capability` | 1 test passed (MissingCapability) | 2026-03-20 (found via --list but filter mismatch prevented isolated run — present in 493 passing codegen tests) |
| Negative: package effect escalation | `cargo test -p riina-pkg -- effect` | 5 tests passed (including escalation_detected) | 2026-03-20 |
| .rii examples | None | Not tested | Never |

## 9. Gate Scores

| Gate | Pass / Partial / Fail | Evidence | Notes |
|------|-----------------------|----------|-------|
| `G1` Canonical Identity | Pass | One domain name (Effect Systems), one identifier (B_EFFECT_SYSTEMS), one folder (02_DOMAIN_B_EFFECT_SYSTEMS), clear research corpus of 20 documents | No competing authority |
| `G2` Boundary Precision | Partial | Scope covers parsing through runtime enforcement. Exclusions (coeffects, row polymorphism, handler optimization) identified via research but not written as a canonical exclusion document | Exclusions discoverable but not consolidated |
| `G3` Workflow Inventory | Partial | Valid and forbidden workflows are exercised in tests. But no canonical workflow inventory document exists — workflows must be reconstructed from test names and Coq theorem names | Implicit, not explicit |
| `G4` Threat and Failure Model | Partial | Effect escalation, capability bypass, and pure-context violation are modeled. No explicit adversary model document. No abuse-case enumeration | Security properties proven but adversary model is implicit |
| `G5` Property Set | Pass | Safety (effect_safety), monotonicity (performs_within_mono), non-escalation (grant_no_escalation), license requirement (perform_requires_license), lattice laws (44 algebraic theorems), handler typing, package containment | Strong and domain-shaped |
| `G6` Formal Model Depth | Pass | 142 Coq Qed theorems across 4 files, zero Admitted, nontrivial induction/negation proofs, directly tied to domain workflows | Strongest gate |
| `G7` Toolchain Enforcement | Pass | Parser rejects invalid effects. Typechecker rejects EffectViolation and CapabilityViolation. Runtime rejects MissingCapability. Package manager rejects escalation. Three enforcement layers with rejection evidence | Real enforcement, not wrappers |
| `G8` Executable Evidence | Partial | 3 negative rejection tests in typechecker, 1 negative runtime test, 5 effect pkg tests. But .rii example files are NOT run through the toolchain — they are static syntax only | Examples untested |
| `G9` Adversarial Coverage | Partial | Negative tests exist for the core rejection cases (pure+system, missing capability, call without grant, escalation). But no boundary-value tests, no mutation tests, no tamper tests, no adversarial fuzzing | Basic negative coverage only |
| `G10` Evidence Honesty Across Prover Lanes | Pass | All non-Coq lanes explicitly marked as auto-generated. Not counted as independent evidence in this audit. Coq is sole formal authority | Honest marking |
| `G11` Observability and Auditability | Pass | Clear trace from Coq theorems → Rust implementation → test names. Reviewer can reconstruct the evidence chain | Good traceability |
| `G12` Freshness and Reproducibility | Pass | All test counts derived from commands run on 2026-03-20. Coq .vo files present. Rust tests pass on current commit | Fresh evidence |
| `G13` Public Claim Discipline | Not audited | Would need to check website and public-facing materials for effect system claims | Deferred to hostile review |
| `G14` Regression Immunity | Partial | Rust tests and Coq build would catch regressions. But no automated CI pipeline — relies on pre-commit/pre-push hooks and manual runs | Hook-gated, not CI-gated |

## 10. Rating

- Current rating: **R3**
- Rating cap: R3 — capped by G8 (partial: examples untested), G9 (partial: thin adversarial coverage), and G3 (partial: no explicit workflow inventory)
- Why this is not higher:
  - G8: .rii examples are not run through the toolchain — they are syntax demonstrations, not executable evidence
  - G9: Only 4 negative test scenarios exist; no boundary, mutation, or tamper testing
  - G3: Workflow inventory is implicit in tests and theorems, not canonically documented
  - G4: Threat model is implicit in Coq gate proofs, not written as a separate model
- Minimum work to reach R4:
  1. Add toolchain-tested .rii examples (parse + typecheck at minimum) as integration tests
  2. Add boundary-value effect tests (e.g., effect at ceiling boundary, join of two non-pure effects)
  3. Write explicit workflow inventory mapping to tests and proofs
  4. Write explicit threat/adversary model for the effect system
  5. Add test that handler dispatch rejects malformed handler

## 11. Safe Public Wording

- Safe claim: "Effect system with algebraic effects, formally modeled (142 Coq theorems) and enforced for covered workflows including compile-time effect bounds, runtime capability gating, and package-level escalation checking"
- Unsafe claim: "Complete verified effect system", "R5 effect system", "all effect workflows verified"

## 12. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| .rii examples not toolchain-tested | Medium | Add integration test that parses+typechecks each .rii in 02_effects/ | Implementation | Blocks G8 pass |
| No explicit workflow inventory | Medium | Write workflow list derived from test coverage | Documentation | Blocks G3 pass |
| No explicit threat model | Medium | Write adversary model for effect escalation, capability bypass, handler abuse | Documentation | Blocks G4 pass |
| Thin adversarial test coverage | Medium | Add boundary, mutation, handler-abuse tests | Testing | Blocks G9 pass |
| Effect handler runtime is basic | Low | Extend interpreter to support deep/shallow handler dispatch matching Coq model | Implementation | Blocks potential R4+ |
| Coeffect runtime not implemented | Low | Implement resource-budget tracking per research decision | Implementation | Research decided but not built |
| 04_SPECS/effect_gate/ empty | Low | Write a spec or accept that Coq + research serve as the spec | Documentation | Acceptable for R3 |

## 13. Promotion Checklist

### To reach `R1`

- [x] Canonical scope exists
- [x] Canonical source set exists
- [x] Historical files demoted

### To reach `R2`

- [x] Formal model exists
- [x] Nontrivial theorems exist (142 Qed)
- [x] Workflow-to-proof mapping exists (implicit via theorem names)

### To reach `R3`

- [x] Live enforcement exists (parser + typechecker + runtime)
- [x] Invalid covered case is rejected (3 negative typechecker tests + 1 runtime)
- [x] Executable positive path exists (grant/require accepted)

### To reach `R4`

- [ ] Workflow coverage is complete for stated scope — no explicit inventory
- [ ] Negative and adversarial tests exist — basic set only, needs expansion
- [x] Residual risks are explicit (coeffects, handler optimization, row polymorphism)

### To reach `R5`

- [ ] Every gate `G1-G14` passes — G2, G3, G4, G8, G9, G14 are partial
- [ ] Third-party reproduction is possible — partially (Coq builds, Rust tests pass)
- [ ] Public wording is conservative and exact — not audited
- [ ] Regression checks exist — hook-gated, not CI-gated

## 14. Sign-Off

- Final verdict: **R3 — Enforced for covered workflows**
- Reviewer notes: This is a strong domain with deep formal foundations (142 Coq theorems, zero Admitted) and real enforcement at three layers (compile-time, runtime, package). The main gaps are documentation (no explicit workflow inventory, threat model) and testing depth (examples untested, thin adversarial coverage). The formal layer is stronger than most audited domains — if the implementation evidence gaps are closed, R4 is reachable.
- Follow-up date: After .rii example integration tests and explicit workflow/threat documentation are added

## 15. Hostile Review Reconciliation

- Hostile review: [B_EFFECT_SYSTEMS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/B_EFFECT_SYSTEMS_R5_REVIEW.md)
- Hostile reviewer: Gemini CLI (v0.34.0)
- Hostile review date: 2026-03-20
- Hostile review verdict: **accept** (no reductions)
- Hostile review maximum honest rating: **R3** (agrees with primary audit)
- Hostile review findings: None. Zero overclaim lines. Zero missed evidence lines.
- Reconciliation action: No rating change required. Primary audit R3 confirmed by hostile review.
- Final reconciled rating: **R3**
- Remediation package: [README.md](/workspaces/proof/06_COORDINATION/remediation/B_EFFECT_SYSTEMS/README.md)
- Domain status: **CLOSED** at R3 until remediation items are addressed
