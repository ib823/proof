## Verdict
FAIL. The snapshot is valid, but the primary audit is not acceptable as written. It argues `R2` from the wrong files, misses vacuity in the canonical domain file, misses hidden proof premises in the strongest core theorem, and speculates about `R3` without verifying the live toolchain.

## Snapshot validation
- `git rev-parse HEAD` matched the required commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`.
- `git diff --name-only 2d436b083b56005b101f18718a7bd0f0aab722e9..HEAD` was empty.
- `git status --short --branch` showed a dirty worktree, but no commit drift. Rule 1 is not triggered because `HEAD` matches exactly.
- `grep -rn "^Axiom "` and `grep -rnP "^\s*Admitted\."` only hit `02_FORMAL/coq/properties/_archive_deprecated/`.
- `grep -RIn "Auto-generated from"` and `grep -RIn "Derived from"` showed generated/derived non-Coq lanes for `V001_TerminationGuarantees`, `WCETBounds`, and `WCETTypes` under `02_FORMAL/smt`, `02_FORMAL/alloy`, `02_FORMAL/fstar`, `02_FORMAL/tv`, and `02_FORMAL/tlaplus`.
- `cargo test --all --manifest-path 03_PROTO/Cargo.toml` passed on `2026-03-22`.
- Critical nuance: a live `coqtop -Q . RIINA` check showed `well_typed_SN` and `SN_app` are exported with explicit premises `env_reducible_closed`, `lambda_body_SN`, and `store_values_are_values`. The grep-based axiom scan does not catch this.

## Maximum honest rating
`R2`, but only under a much narrower claim: RIINA has nontrivial Coq termination and strong-normalization infrastructure for a core calculus, plus toy WCET models, with no compiler/runtime enforcement and unresolved theorem premises on the strongest result. If the claim remains broad RIINA termination guarantees for the live language/toolchain, the safe public posture is effectively `R1` wording.

## Gate review table
| Gate | Status | Review |
|---|---|---|
| G1 Canonical Identity | Fail | Canonical research exists in `01_RESEARCH/22_DOMAIN_V_TERMINATION_GUARANTEES/RESEARCH_V01_FOUNDATION.md`, but the audit substitutes `WCETBounds.v` and `WCETTypes.v`, which are performance/WCET artifacts, not the canonical termination domain file. |
| G2 Boundary Precision | Fail | The audit gives no canonical assumptions block, no not-in-scope block, and no honest boundary around pure core calculus vs live RIINA compiler/runtime. The `selagi` policy is also contradicted between specs and implementation. |
| G3 Workflow Inventory | Fail | No valid or forbidden workflow matrix exists for structural recursion, well-founded recursion, productivity, bounded loops, or non-terminating escape hatches. |
| G4 Threat and Failure Model | Partial | Research covers non-termination as DoS and notes FFI/codata limits, but the audit ignores live failure modes: unrestricted `selagi`, fake single-iteration semantics, and vacuous schedulability claims. |
| G5 Property Set | Partial | The research domain names the right properties, but the audit’s cited proof set is mostly WCET algebra over toy languages, not domain-complete RIINA termination properties. |
| G6 Formal Model Depth | Partial | There is real core Coq work in `02_FORMAL/coq/termination/`, but `02_FORMAL/coq/domains/V001_TerminationGuarantees.v` is highly vacuous and the flagship theorem in `ReducibilityFull.v` is not closed without extra premises. |
| G7 Toolchain Enforcement | Fail | `check_termination` is literally `true`, the parser accepts unrestricted `selagi`, the parser does not implement `had:` bounds, and the typechecker has no visible termination/WCET rejection path. |
| G8 Executable Evidence | Fail | There is no end-to-end positive and negative termination/WCET workflow evidence. The Rust suite passes, but it does not exercise termination enforcement for `selagi`, bounds, or `Bersih` totality. |
| G9 Adversarial Coverage | Fail | No negative tests for rejected recursion, `had:` bounds, `kesan Sistem` restriction, or WCET rejection were found. |
| G10 Evidence Honesty Across Prover Lanes | Partial | Generated/derived lanes are clearly labeled, which helps, but the audit does not discuss independence and does not explicitly demote those lanes. |
| G11 Observability and Auditability | Fail | The audit is not reconstructible. “25-31% reflexivity” is not a gate-based argument and does not explain why the rating is justified. |
| G12 Freshness and Reproducibility | Fail | The snapshot is fresh, but the audit still says implementation “needs verification” while speculating about `R3`. That is unresolved evidence, not reproducible support. |
| G13 Public Claim Discipline | Fail | Public examples and training data claim `Bersih` implies termination and present unrestricted `selagi` as normal RIINA, while the parser/spec/toolchain do not support that honestly. |
| G14 Regression Immunity | Fail | The documented termination policy already regressed: specs say bounded-or-`Sistem`, but lexer/parser/examples allow unrestricted loops and tests do not catch the contradiction. |

## Findings table
| Severity | Finding | Evidence | Impact |
|---|---|---|---|
| Critical | The strongest core theorem is not a closed theorem. | `02_FORMAL/coq/termination/ReducibilityFull.v:928-930`, `:970-974`, `:1005-1006`; live `coqtop -Q . RIINA` `Print well_typed_SN.` and `Print SN_app.` showed both theorems exported with those three premises as explicit parameters. | The audit cannot count `well_typed_SN`/`SN_app` as finished, unconditional termination evidence. |
| High | The canonical domain file is largely vacuous. | `02_FORMAL/coq/domains/V001_TerminationGuarantees.v:83-88`, `:126-129`, `:210-215`, `:234-235`, `:541-548`. | The “checker” and several “soundness” theorems collapse to `True`, `reflexivity`, or “always `true`”, so they do not justify domain depth. |
| High | The audit cites wrong-layer and partly wrong-domain evidence. | `02_FORMAL/coq/domains/WCETBounds.v:3-5` points to performance research; `02_FORMAL/coq/domains/WCETTypes.v:3-10`, `:23-29` define a self-contained toy cost language. | This confuses performance/WCET modeling with RIINA termination guarantees. |
| High | Live implementation contradicts the documented termination policy. | `04_SPECS/language/RIINA_MATERIALIZATION_PLAN_v1_0_0.md:1037-1042`, `:2952-2954`; `04_SPECS/language/SYNTAX_IMPROVEMENT_SPEC_v2_0_0.md:662-667`; `03_PROTO/crates/riina-lexer/src/lexer.rs:478-487`; `03_PROTO/crates/riina-parser/src/lib.rs:491-530`; no `selagi`/`had:` hits in `riina-typechecker`, `riina-types`, or `riinac`. | `R3` is impossible: there is no honest termination enforcement path, and the implementation/spec boundary is internally contradictory. |
| Medium | The parser’s `selagi`/`ulang` semantics are not faithful loops. | `03_PROTO/crates/riina-parser/src/lib.rs:502-513`, `:524-530`. | The parser implements a single-iteration conditional/sequence, not a real bounded loop and not a termination checker. |
| Medium | WCET “schedulability” evidence includes placeholder or unsafe claims. | `02_FORMAL/coq/domains/WCETBounds.v:70-72`, `:627-644`; live `coqtop` showed `Nat.div 100 0 = 0`. | Zero-period tasks can appear harmless under `utilization`, `deadline_feasibility` proves only `True`, and `response_time_bound` is identity; this is weak evidence for any serious domain claim. |
| Medium | Public wording already overclaims termination. | `07_EXAMPLES/08_ai_training/vuln_to_safe.jsonl:17`, `:21`; `07_EXAMPLES/00_basics/loops_while.rii:20-31`, `:109-112`. | G13 fails: the repo teaches users claims that the current proofs and toolchain do not honestly support. |

## Overclaim lines
| Audit line | Why it overclaims |
|---|---|
| `V_TERMINATION_GUARANTEES_R5_AUDIT.md:9` | Counting `WCETBounds.v` and `WCETTypes.v` as the main Coq evidence for termination misidentifies the domain and ignores the canonical `V001_TerminationGuarantees` and `termination/*.v` files. |
| `V_TERMINATION_GUARANTEES_R5_AUDIT.md:10` | “Needs verification” is not evidence. An unresolved implementation question cannot support a rating. |
| `V_TERMINATION_GUARANTEES_R5_AUDIT.md:15` | “Potential R3” is unsupported. No termination/WCET enforcement path was found in the typechecker, and the parser/spec conflict cuts the other direction. |
| `V_TERMINATION_GUARANTEES_R5_AUDIT.md:18` | The proposed “safe claim” is still unsafe because it centers the domain on WCET bounds and omits the vacuous checker and hidden theorem premises. |
| `V_TERMINATION_GUARANTEES_R5_AUDIT.md:22` | The final `R2` verdict may be salvageable only after scope narrowing, but this specific argument for `R2` is unsound and should not be released. |

## Missed evidence lines
| File:line | Missed point |
|---|---|
| `02_FORMAL/coq/domains/V001_TerminationGuarantees.v:126-129` | `decreases_on` is defined as `True` at every call site. |
| `02_FORMAL/coq/domains/V001_TerminationGuarantees.v:234-235` | `check_termination` always returns `true`. |
| `02_FORMAL/coq/domains/V001_TerminationGuarantees.v:362-370` | “checker soundness” only says `true -> structural_recursion -> terminates`; it does not validate a real checker. |
| `02_FORMAL/coq/termination/ReducibilityFull.v:928-930` | `env_reducible_closed` is an unresolved premise. |
| `02_FORMAL/coq/termination/ReducibilityFull.v:970-974` | `lambda_body_SN` is an unresolved premise. |
| `02_FORMAL/coq/termination/ReducibilityFull.v:1005-1006` | `store_values_are_values` is an unresolved premise. |
| `03_PROTO/crates/riina-parser/src/lib.rs:491-530` | Live parser behavior for `selagi` and `ulang` contradicts the termination policy and the public loop examples. |
| `04_SPECS/language/RIINA_MATERIALIZATION_PLAN_v1_0_0.md:1037-1042`, `:2952-2954` | The documented decision is bounded `selagi` or `Sistem`-only, not unrestricted parser support. |
| `07_EXAMPLES/00_basics/loops_while.rii:20-31`, `:109-112` | Public examples present unrestricted `selagi` in `kesan Bersih` and describe real looping semantics. |
| `07_EXAMPLES/08_ai_training/vuln_to_safe.jsonl:17`, `:21` | Public training data claims Coq termination proofs and `Bersih` guarantee bounded execution/termination. |

## Safe claim
RIINA has nontrivial Coq termination infrastructure for a core calculus, including strong-normalization and elimination lemmas, plus toy WCET submodels. The live compiler/runtime do not enforce termination guarantees or WCET claims today, the domain checker file is partly vacuous, and the strongest normalization theorem still exports unresolved premises.

## Unsafe claim
RIINA formally guarantees program termination, `Bersih` functions are enforced total by the toolchain, WCET is compiler-checked, or this domain is anywhere near `R3`.

## Release condition
- Reject the current primary audit as written.
- Rewrite the evidence pack around the canonical termination sources first: `RESEARCH_V01_FOUNDATION.md`, `V001_TerminationGuarantees.v`, and `02_FORMAL/coq/termination/*.v`.
- Explicitly disclose that `well_typed_SN` and `SN_app` currently require three external premises.
- Separate performance/WCET claims from termination claims. Do not let `WCETBounds.v` stand in for domain V identity.
- Either implement the documented bounded-or-`Sistem` loop policy with negative tests, or demote every public loop/termination claim that assumes it already exists.
- Remove all `R3` language until the live typechecker/runtime can reject invalid covered cases.

## Next review advice
- Do not use reflexivity percentages as a rating argument. Map claims to gates, workflows, and concrete rejection behavior.
- Ask Coq for exported theorem types, not just `grep "^Axiom "` or `grep "Admitted"`. Section hypotheses can evade the grep and still weaken the theorem materially.
- Audit domain V and WCET/performance as separate evidence threads. They interact, but they are not the same domain.
- Treat examples and AI-training corpora as public claims. If they say `Bersih` implies termination or show unrestricted `selagi`, that is real release-surface evidence.
- For the next hostile review, require one positive command and one negative command for termination enforcement, plus the exact tests that keep the parser/spec loop policy from drifting again.
