## Verdict
Invalid as written. The snapshot is correct, but the audit misses decisive contradictory evidence: the live toolchain only enforces the narrow syntactic `declass_ok` witness, the main Coq policy model contains vacuous or no-op security definitions, the non-Coq lanes are generated or derived, and shipped declassification examples/docs are stale. `R2` is still the ceiling, but only for partial formal modeling plus generic IFC declassification, not for declassification policy enforcement.

## Snapshot validation
- `git rev-parse HEAD` matched `2d436b083b56005b101f18718a7bd0f0aab722e9`.
- `git diff --name-only 2d436b083b56005b101f18718a7bd0f0aab722e9..HEAD` was empty.
- The worktree is dirty, but only from unrelated files; snapshot validity is not broken by `HEAD`.
- `grep -rn "^Axiom "` and `grep -rnP "^\s*Admitted\."` only hit `02_FORMAL/coq/properties/_archive_deprecated/*`; active Coq evidence is clean on those checks.
- `cargo test --all --manifest-path 03_PROTO/Cargo.toml` passed.
- Freshness problem: `cargo run -q -p riinac --manifest-path 03_PROTO/Cargo.toml -- check 07_EXAMPLES/01_security/declassify.rii` failed with `Expected identifier` at `07_EXAMPLES/01_security/declassify.rii:6:20`, so shipped domain evidence is stale against the pinned snapshot.

## Maximum honest rating
`R2`, and only under a narrower claim than the primary audit uses.

Reason:
- There is active Coq modeling in `02_FORMAL/coq/domains/Z001_DeclassificationPolicy.v` and `02_FORMAL/coq/domains/QuantitativeDeclassification.v`.
- There is live compiler/runtime support for generic `declassify` under the core IFC rule `declass_ok`.
- There is no live enforcement for the domain-shaped policy dimensions advertised by Track Z: principals, guards, budgets, audit logs, or differential-privacy style release control.
- The formal model is too shallow in key places to justify anything above “partially modeled”.

## Gate review table
| Gate | Status | Hostile review |
|---|---|---|
| G1 Canonical Identity | Fail | No canonical scope, assumptions, or not-in-scope block is established. Authority is split across `RESEARCH_Z01_FOUNDATION.md`, `Z001_DeclassificationPolicy.v`, `QuantitativeDeclassification.v`, and generic IFC core files. |
| G2 Boundary Precision | Fail | The audit never states covered actors, assets, trust boundaries, lifecycle phases, or exclusions. |
| G3 Workflow Inventory | Fail | No workflow matrix exists for WHO/WHAT/WHEN/HOW MUCH release. The only executable workflow is generic `dedah` unwrapping. |
| G4 Threat and Failure Model | Fail | The audit names no adversary, abuse cases, failure model, or residual risk. The implementation does not model audit evasion, budget abuse, or unauthorized principals. |
| G5 Property Set | Partial | The Coq files name robust guards, authorization, budgets, logging, and DP, but several are shallow or detached from execution. |
| G6 Formal Model Depth | Fail | `acts_for` is vacuous, `Step_Declass` is a state no-op, audit/logging theorems are mostly definitional, and the quantitative model is isolated from the RIINA AST/toolchain. |
| G7 Toolchain Enforcement | Fail | The live toolchain enforces only `declass_ok = prove(classify(same value))`; no principal, guard, budget, logging, or DP policy is enforced. |
| G8 Executable Evidence | Fail | There is one positive and one negative generic declassification path, but no executable evidence for policy workflows. The shipped domain example does not parse. |
| G9 Adversarial Coverage | Fail | Negative tests only cover malformed proof structure. No attack tests exist for authorization bypass, budget exhaustion, guard manipulation, or missing audit receipts. |
| G10 Evidence Honesty Across Prover Lanes | Fail | Lean/Isabelle ports are auto-generated and SMT/F*/TLA+/TV/Alloy lanes are derived or generated. The audit does not classify them as non-independent. |
| G11 Observability and Auditability | Fail | No runtime receipt or audit log is produced for declassification decisions. The review trail from claim to artifact is too thin and omits contradictions. |
| G12 Freshness and Reproducibility | Fail | Core tests reproduce, but public domain examples/docs are stale against the pinned snapshot. |
| G13 Public Claim Discipline | Fail | Repo prose claims proof-string audit logging and compiler tracking that the code does not implement. |
| G14 Regression Immunity | Fail | Regression checks only cover the core `declass_ok` witness, not Track Z policy features. |

## Findings table
| Severity | Finding | Evidence |
|---|---|---|
| Critical | The authority model is vacuous, so principal-based authorization is not meaningfully modeled. | `acts_for` is defined as equality or `exists authority > 0`, which is always satisfiable for any principals in `02_FORMAL/coq/domains/Z001_DeclassificationPolicy.v:47-50`. Theorems `Z_001_02`, `Z_001_06`, and `Z_001_07` discharge by `exists 1` at `02_FORMAL/coq/domains/Z001_DeclassificationPolicy.v:283-335`. |
| Critical | The main Coq operational semantics does not perform declassification at all. | `Step_Declass` is `steps (PDeclass de) s s` in `02_FORMAL/coq/domains/Z001_DeclassificationPolicy.v:257-263`. `Z_001_13_robust_preserves_ni` then proves preservation by inverting two identity steps at `02_FORMAL/coq/domains/Z001_DeclassificationPolicy.v:382-390`. |
| High | Live implementation does not enforce declassification policy features; it only enforces the core syntactic witness. | Core rule is `declass_ok e1 e2 := exists v, e1 = EClassify v /\ e2 = EProve (EClassify v)` in `02_FORMAL/coq/foundations/Syntax.v:793-795`, used by `T_Declassify` in `02_FORMAL/coq/foundations/Typing.v:198-202`, mirrored in Rust at `03_PROTO/crates/riina-typechecker/src/lib.rs:2314-2355` and `03_PROTO/crates/riina-typechecker/src/lib.rs:2829-2851`. |
| High | Runtime/codegen paths ignore Track Z policy notions such as principals, guards, budgets, and audit logs. | Interpreter unwraps a secret after AST-pattern proof matching in `03_PROTO/crates/riina-codegen/src/interp.rs:739-752`. C emission only checks proof wrapping/equality in `03_PROTO/crates/riina-codegen/src/emit.rs:635-660`. Wasm drops the proof entirely and emits the secret value in `03_PROTO/crates/riina-codegen/src/wasm.rs:936-941`. |
| High | Shipped domain examples and user guidance are stale and contradictory. | `07_EXAMPLES/01_security/declassify.rii:5-151` uses unsupported `dedah(..., bukti: "...")` syntax and claims compiler audit tracking at lines `148-151`; the file fails `riinac check`. `07_EXAMPLES/06_ai_context/COMMON_MISTAKES.md:454-463` repeats the unsupported proof-string/audit-tracking claim. |
| Medium | The audit ignored active formal evidence, but that evidence does not rescue the domain. | `02_FORMAL/coq/domains/QuantitativeDeclassification.v:1-214` is active Coq and contains some nontrivial local lemmas, but it models a separate toy AST with `EDeclass ex cost` and has no toolchain binding. |
| Medium | Non-Coq prover lanes are not independent confirmation. | Lean port is explicitly auto-generated in `02_FORMAL/lean/RIINA/Domains/Z001_DeclassificationPolicy.lean:5-10`. Alloy is explicitly auto-generated in `02_FORMAL/alloy/RIINA/Domains/Z001_DeclassificationPolicy.als:1-4`. SMT/F*/TLA+/TV files are marked derived/generated by the required grep commands. |

## Overclaim lines
| Audit line | Why unsafe |
|---|---|
| `10` | “Implementation: Ties to C_IFC declassification enforcement” blurs generic `declass_ok` support with declassification policy enforcement. The tie is real only for the narrow syntactic witness. |
| `15` | “Shares enforcement with C_INFORMATION_FLOW_CONTROL's declassification mechanism” omits that the shared mechanism has no principal, budget, guard, audit, or DP semantics. |
| `18` | The “safe claim” is still too generous because “declassification policy” suggests policy dimensions that are not enforced. |
| `22` | “Potential R3 via C_IFC enforcement” is unsupported. Current enforcement is not domain-shaped enough for `R3` on Track Z. |

## Missed evidence lines
| Audit line | Missed evidence |
|---|---|
| `9` | Active formal evidence also includes `02_FORMAL/coq/domains/QuantitativeDeclassification.v`, which the audit ignored. |
| `10` | The live path is only `declass_ok` same-value proof checking, shown in `Syntax.v`, `Typing.v`, and Rust typechecker/runtime code. |
| `15` | The audit missed the vacuous `acts_for` definition and the no-op `Step_Declass` semantics, which materially weaken the claimed formal depth. |
| `15` | The audit missed stale public evidence: `07_EXAMPLES/01_security/declassify.rii` does not parse at the pinned snapshot and docs claim unsupported proof-string audit logging. |
| `15` | The audit missed that the non-Coq lanes for this domain are derived/generated, not independent corroboration. |

## Safe claim
RIINA currently supports a basic IFC declassification primitive that accepts only the narrow structural witness `declassify (classify v) with prove (classify v)`. Track Z also has active Coq models for broader policy ideas such as authorization, budgets, audit logs, and quantitative release, but those policy dimensions are not bound to the live compiler/runtime.

## Unsafe claim
RIINA enforces declassification policies with principal authorization, guard validation, budget accounting, audit receipts, or differential-privacy controls across the live toolchain.

## Release condition
Do not promote or describe this domain above the narrow `R2` claim until all of the following are true:
1. One canonical scope/assumptions/not-in-scope block exists for Track Z.
2. At least one real policy workflow is bound end-to-end to the AST, typechecker, runtime/codegen, and tests.
3. That workflow mechanically enforces an authorized principal, a real guard condition, budget consumption, and an observable audit receipt.
4. Stale example/docs are corrected to the supported syntax and semantics.
5. Generated or derived prover lanes are explicitly labeled non-independent in the audit evidence pack.

## Next review advice
Start from the current supported syntax and reject stale example prose up front. Review `Z001_DeclassificationPolicy.v`, `QuantitativeDeclassification.v`, `Syntax.v`, `Typing.v`, the Rust `declass_ok` implementation, and one real example compile/run path together. If a claimed policy dimension does not have a live reject path or receipt, score it as modeled-only, not enforced.
