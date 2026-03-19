# Domain Audit Record

## 1. Identity

- Domain name: Type Theory Foundations
- Domain identifier: `A_TYPE_THEORY`
- Folder(s): `01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/`, `02_FORMAL/coq/foundations/`, `02_FORMAL/coq/type_system/`, `02_FORMAL/coq/properties/`, `02_FORMAL/coq/domains/{LinearTypes,SessionTypes,OwnershipTypes,DependentTypes,RefinementTypes}.v`, `03_PROTO/crates/riina-{types,parser,typechecker}/`, `03_PROTO/crates/riinac/`
- Audit date: `2026-03-19`
- Auditor: Codex
- Current repo commit: `5e861d69924fd904619cc56f2a6734d571ccbb06`
- Command-derived Rust passing tests on this snapshot: `2476`
- `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings` on this snapshot: `passed` on the pinned commit before docs-only audit-control changes
- Targeted domain test evidence on this snapshot:
  - `riina-parser`: `220` passed
  - `riina-typechecker`: `258` passed
  - `riinac`: `51` unit tests + `6` end-to-end tests passed

## 2. Canonical Source Map

### Canonical research authority

- `01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_DOMAIN_A_COMPLETE_SUMMARY.md`
- `01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A19_TYPE_INFERENCE_DECISION.md`
- `01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/RESEARCH_A20_TYPE_SOUNDNESS_DECISION.md`

### Supporting but not safe as current-state authority for the full umbrella

- `RESEARCH_A04_LINEAR_TYPES_DECISION.md`
- `RESEARCH_A07_SESSION_TYPES_DECISION.md`
- `RESEARCH_A13_OWNERSHIP_TYPES_DECISION.md`
- `RESEARCH_A14_CAPABILITY_TYPES_DECISION.md`
- the remaining research decision/survey/comparison files under `01_RESEARCH/01_DOMAIN_A_TYPE_THEORY/`

Reason:
- the summary and decision set describe a 20-session umbrella that is broader than the live implementation subset
- they are useful for scope discovery, but not safe to treat as evidence that every branch is live

### Canonical formal files

- Core Coq foundations and metatheory:
  - `02_FORMAL/coq/foundations/Syntax.v`
  - `02_FORMAL/coq/foundations/Typing.v`
  - `02_FORMAL/coq/type_system/Progress.v`
  - `02_FORMAL/coq/type_system/Preservation.v`
  - `02_FORMAL/coq/type_system/TypeSafety.v`
  - `02_FORMAL/coq/properties/CanonicalForms.v`
  - `02_FORMAL/coq/properties/SubstitutionCommute.v`
  - `02_FORMAL/coq/properties/TypingInversion.v`
- Additional domain-shaped Coq extensions relevant to the live subset:
  - `02_FORMAL/coq/domains/LinearTypes.v`
  - `02_FORMAL/coq/domains/SessionTypes.v`
  - `02_FORMAL/coq/domains/OwnershipTypes.v`
- Formal-only extension files not safe to count as live implementation support:
  - `02_FORMAL/coq/domains/DependentTypes.v`
  - `02_FORMAL/coq/domains/RefinementTypes.v`

### Non-authoritative or generated prover evidence

- Lean, Isabelle, and F* ports for these files are auto-generated or derived from Coq
- SMT files for the same surfaces include `= 0 0` placeholders
- these lanes are useful for honesty notes but not safe to count as strong independent evidence

### Canonical implementation files

- `03_PROTO/crates/riina-types/src/lib.rs`
- `03_PROTO/crates/riina-parser/src/lib.rs`
- `03_PROTO/crates/riina-typechecker/src/lib.rs`
- `03_PROTO/crates/riina-typechecker/src/program.rs`
- `03_PROTO/crates/riinac/src/main.rs`

### Canonical example evidence

Relevant examples exist, but the corpus is not cleanly trustworthy on this snapshot:
- `07_EXAMPLES/00_basics/hello.rii`
- `07_EXAMPLES/00_basics/type_annotations.rii`
- `07_EXAMPLES/02_effects/pure_functions.rii`
- `07_EXAMPLES/01_security/linear_types.rii`
- `07_EXAMPLES/08_jalinan/session_types.rii`

Current truth:
- ad hoc positive and negative `riinac check` workflows work
- several canonical example files currently fail under `riinac`, so the example corpus is not safe to count as a clean end-to-end evidence lane

## 3. Current Scope Assessment

### What the research claims

The umbrella research claims a 20-session type-theory program covering:
- MLTT with universes
- CoC polymorphism
- HoTT/cubical equality
- linear, uniqueness, ownership, region, and row systems
- effect rows and effect polymorphism
- session types
- refinement and dependent types
- gradual types
- higher-kinded types
- type-level computation
- Iris-based semantic soundness

### What the live repo actually supports

- a real core syntax/type/effect/security/capability/session AST in `riina-types`
- real parser support for the covered core subset in `riina-parser`
- real typechecker enforcement for:
  - core typing
  - effects
  - security levels and IFC-like checks
  - linearity tracking
  - capability gating
  - session-type duality/subtyping helpers
- real `riinac check` workflows for covered syntax
- real Coq core metatheory with syntax, typing, canonical forms, substitution, progress, preservation, and type safety

### What is not honestly supported yet

- live universes, Π/Σ dependent types, refinement solving, gradual typing, higher-kinded types, region types, or type-level computation in the Rust toolchain
- a workflow-complete umbrella covering every research branch under `01_DOMAIN_A_TYPE_THEORY`
- independently trustworthy non-Coq confirmation across generated or vacuous prover lanes
- a clean canonical example corpus for the umbrella; several shipped example files fail on this snapshot

## 4. Workflow Inventory

| Workflow | Current status | Evidence |
|----------|----------------|----------|
| Parse and typecheck a bounded core RIINA program | Works | `riinac check /tmp/riina_num_expr.rii` succeeded |
| Reject a bounded type mismatch in the live checker | Works | `riinac check /tmp/riina_bool_expr.rii` failed with `Annotation mismatch: expected Int, found Bool` |
| Exercise parser/typechecker/driver core suites | Works | `cargo test -p riina-types -p riina-parser -p riina-typechecker -p riinac --manifest-path 03_PROTO/Cargo.toml` passed |
| Run bounded end-to-end compiler workflows | Works | `riinac` end-to-end test suite passed `6` tests |
| Treat shipped type-theory example corpus as clean end-to-end evidence | Fails | `hello.rii`, `type_annotations.rii`, `pure_functions.rii`, and `linear_types.rii` fail under `riinac check` on this snapshot |
| Claim the entire 20-session research umbrella as live | Missing | no live Rust implementation for dependent, refinement, gradual, region, higher-kinded, or type-level branches |

## 5. Formal Depth Assessment

### Coq

The core Coq metatheory is real and nontrivial.

Command-derived counts across the core files:
- `Syntax.v`: `37` lemmas/theorems
- `Typing.v`: `33`
- `Progress.v`: `27`
- `Preservation.v`: `21`
- `TypeSafety.v`: `6`
- `CanonicalForms.v`: `43`
- `SubstitutionCommute.v`: `53`
- `TypingInversion.v`: `52`

Total across the core metatheory slice:
- `272` lemmas/theorems

Coq hygiene on the active lane:
- active `Axiom`: `0`
- active `Admitted`: `0`

Additional domain files such as `LinearTypes.v`, `SessionTypes.v`, `OwnershipTypes.v`, `DependentTypes.v`, and `RefinementTypes.v` expand the formal surface. The honest boundary, however, is that the live Rust toolchain only covers a subset of these ideas today.

Conclusion:
- the formal model is stronger than the previous business umbrellas
- the core metatheory is real enough to support an enforced bounded subset
- the umbrella still exceeds the live implementation surface

### Non-Coq lanes

- Lean `Syntax.lean` and `TypeSafety.lean` are auto-generated ports of Coq
- Isabelle `Syntax.thy` and `TypeSafety.thy` are auto-generated ports of Coq
- F* files are marked `Derived from`
- SMT files include many `= 0 0` placeholders for core theorems

Conclusion:
- Coq is the serious primary evidence
- generated or vacuous lanes must not be counted as strong independent confirmation

## 6. Live Implementation Assessment

### Real live evidence

- `riina-types` defines real enums and data structures for:
  - `SecurityLevel`
  - `Linearity`
  - `Effect`
  - `CapabilityKind`
  - `SessionType`
  - `Ty`
  - `Expr`
- `riina-parser` parses covered core constructs for:
  - effects
  - security levels
  - capability kinds
  - session types
  - linearity qualifiers
- `riina-typechecker` enforces covered semantics for:
  - effect safety
  - linearity violations
  - security-level mismatches
  - capability validation
  - session duality and subtype helpers
- targeted parser/typechecker/driver suites pass on this snapshot

### Structural limitations

- no live Rust hits were found for:
  - dependent types
  - refinement types
  - gradual types
  - higher-kinded types
  - region types
  - universes
  - type-level computation
- the research umbrella is therefore much broader than the live enforced subset
- shipped examples are not a clean evidence lane for this domain on the current snapshot

## 7. Executable Evidence

Commands run on this snapshot:

```bash
export PATH="/home/codespace/.cargo/bin:/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
cargo test -p riina-types -p riina-parser -p riina-typechecker -p riinac --manifest-path 03_PROTO/Cargo.toml
printf 'fungsi utama() -> Nombor kesan Bersih {\n    42 + 1\n}\n' > /tmp/riina_num_expr.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check /tmp/riina_num_expr.rii
printf 'fungsi utama() -> Nombor kesan Bersih {\n    betul\n}\n' > /tmp/riina_bool_expr.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check /tmp/riina_bool_expr.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check 07_EXAMPLES/00_basics/hello.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check 07_EXAMPLES/00_basics/type_annotations.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check 07_EXAMPLES/02_effects/pure_functions.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- check 07_EXAMPLES/01_security/linear_types.rii
```

Observed outcomes:

- targeted parser/typechecker/driver suites passed
- positive bounded workflow succeeded:
  - `/tmp/riina_num_expr.rii` -> `Success!`
- negative bounded workflow succeeded:
  - `/tmp/riina_bool_expr.rii` -> `Annotation mismatch: expected Int, found Bool`
- canonical example corpus is not clean:
  - `hello.rii` fails with `Unexpected token: RBrace`
  - `type_annotations.rii` fails with `Unexpected token: RBrace`
  - `pure_functions.rii` fails with `Unexpected token: RBrace`
  - `linear_types.rii` fails with `Expected type`

## 8. Gate Scores

| Gate | Score | Basis | Consequence |
|------|-------|-------|-------------|
| `G1` Canonical Identity | Partial | One umbrella domain exists, but the research authority is spread across a summary plus many decision docs, and the live subset is narrower than the umbrella | Identity is broad and layered |
| `G2` Boundary Precision | Fail | The research umbrella claims far more branches than the live Rust toolchain implements | Caps current-state umbrella claims |
| `G3` Workflow Inventory | Fail | The canonical example corpus for the umbrella is broken on this snapshot, so the workflow evidence is not stable enough even though ad hoc commands and unit tests pass | Caps the umbrella at `R2` |
| `G4` Threat and Failure Model | Partial | Type safety, linearity, capability, and security failures are tested, but the umbrella-wide failure model across all 20 branches is not explicit or complete | Blocks `R4` |
| `G5` Property Set | Partial | Core type-theory properties are real and domain-shaped, but many advanced branch-specific properties remain formal-only or unimplemented live | Supports bounded subset only |
| `G6` Formal Model Depth | Pass | Core Coq metatheory is real, nontrivial, and hygiene-clean | Supports more than `R2` for the covered subset |
| `G7` Toolchain Enforcement | Partial | Real parser/typechecker enforcement exists for a bounded core subset, but many research branches have no live Rust implementation | Supports `R3` only for the covered subset |
| `G8` Executable Evidence | Fail | Positive and negative ad hoc workflows work, but the canonical example corpus is broken and cannot be counted as clean end-to-end umbrella evidence | Caps the umbrella at `R2` |
| `G9` Adversarial Coverage | Partial | Many invalid cases are rejected in unit tests, but umbrella-wide adversarial coverage is incomplete and example-based rejection evidence is weak | Blocks `R4` |
| `G10` Independent Evidence Honesty | Fail | Lean/Isabelle/F* are generated or derived, and SMT includes `= 0 0` placeholders; this is a critical inflation risk, not minor supporting noise | Not safe to count as strong independent confirmation |
| `G11` Observability and Auditability | Pass | Claims can be traced to live files, commands, proofs, tests, and explicit honesty notes | Audit is reconstructible |
| `G12` Freshness and Reproducibility | Pass | Commands were rerun on the pinned commit and evidence is command-derived | Audit is reproducible |
| `G13` Public Claim Discipline | Fail | The research umbrella overstates live support for many advanced branches | Wording must stay tightly bounded |
| `G14` Regression Immunity | Partial | General compiler and proof suites exist, but there is no dedicated domain-readiness gate for the umbrella claim surface | Rating is not fully protected |

## 9. Rating

- Current rating: `R2`
- Rating cap: `R2`
- Why this is not lower:
  - the core Coq metatheory is real and nontrivial
  - the live compiler enforces a bounded core subset and rejects invalid covered cases
  - the domain exceeds pure research-only status
- Why this is not higher:
  - the umbrella research surface is much broader than the live subset
  - canonical example files are stale or failing on this snapshot
  - independent prover-lane evidence is generated, derived, or vacuous
  - the executable evidence is not strong enough for the umbrella to claim `R3`

## 10. Safe Public Wording

- Safe claim:
  - `RIINA's compiler implements and tests a core type subsystem with formal proofs of type safety in Coq. This subsystem includes enforcement of effects, security labels, linearity, and basic session-type constructs. Advanced features like dependent or refinement types are formally modeled but not yet implemented.`
- Unsafe claim:
  - `RIINA features a verified R3 type theory foundation across the full 20-session Type Theory Foundations umbrella.`

## 11. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| Research umbrella is much broader than the live subset | Critical | re-scope the umbrella to `A_TYPE_THEORY_CORE` plus separate child branches | Pending | main honesty blocker |
| Canonical example corpus is stale | Critical | repair or replace failing type-theory examples under `07_EXAMPLES` | Pending | blocks any honest `R3` umbrella claim |
| Independent non-Coq lanes are generated or vacuous | Critical | stop counting them as strong confirmation, or replace them with real independent models | Pending | evidence-honesty blocker |
| Advanced branches are absent from live Rust implementation | High | split the umbrella and audit child domains rather than implying full support | Pending | main scope blocker |
| No dedicated domain-readiness gate for the umbrella claim | Medium | add a domain-specific audit/readiness check for the bounded core subset | Pending | regression blocker |
| Formal-to-live mapping for advanced branches is missing | Medium | explicitly separate core enforced subset from formal-only branches in docs and audits | Pending | traceability blocker |
| End-to-end positive and negative evidence relies too much on ad hoc commands | Medium | promote current passing workflows into canonical checked examples | Pending | evidence-pack weakness |

## 12. Promotion Checklist

### To stay honest at `R2`

- [x] Real Coq metatheory exists
- [x] A bounded live enforced subset exists
- [ ] Public wording is reduced to the bounded core subset
- [ ] Canonical example corpus is repaired

### To reach `R3`

- [ ] re-scope to `A_TYPE_THEORY_CORE` or another bounded child domain
- [ ] canonical positive and negative examples for that bounded domain are stable
- [ ] covered workflows are executable without ad hoc-only evidence
- [ ] public wording matches the bounded child domain

### To reach `R5`

- [ ] every gate `G1-G14` passes
- [ ] the live subset and umbrella boundary are exact and externally reproducible
- [ ] independent evidence honesty is preserved across non-Coq lanes
- [ ] a domain-readiness gate prevents silent drift

## 13. Sign-Off

- Final verdict:
  - `R2` is the maximum honest rating at commit `5e861d69924fd904619cc56f2a6734d571ccbb06`.
- Reviewer notes:
  - hostile review completed in [A_TYPE_THEORY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/A_TYPE_THEORY_R5_REVIEW.md)
  - review verdict: `reject`
  - review downgraded the umbrella from provisional `R3` to `R2`
  - review advised re-scoping the first serious child target to `A_TYPE_THEORY_CORE`
- Follow-up date:
  - after `A_TYPE_THEORY_CORE` is scoped, the example corpus is repaired, and a child-domain re-audit is justified

## 14. Next Audit Handoff

- Next recommended domain:
  - `B_EFFECT_SYSTEMS`
- Why next:
  - `A_TYPE_THEORY` is now reconciled and closed as an umbrella at `R2`
  - the queue resumes exact umbrella order after `A_TYPE_THEORY`
  - the methodology correction from this review should now carry into the next foundational audit
- Immediate next action:
  - start the primary audit for `B_EFFECT_SYSTEMS`
- Reuse from this cycle:
  - tracker: [AUDIT_PROGRAM_STATUS_v1_0_0.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md)
  - queue: [DOMAIN_AUDIT_QUEUE_v1_0_0.md](/workspaces/proof/06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md)
  - audit method: [DOMAIN_R5_CHECKLIST_v1_0_0.md](/workspaces/proof/04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md)
  - first child-domain target: [A_TYPE_THEORY_CORE_R5_TARGET_SPEC_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/A_TYPE_THEORY/A_TYPE_THEORY_CORE_R5_TARGET_SPEC_v1_0_0.md)
