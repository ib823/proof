# Headline theorems

> **Generated — do not edit by hand.** Source: `04_SPECS/ledgers/headline_theorems.toml`,
> the `KERNEL_CAPSTONES` list in `03_PROTO/crates/riinac/src/verify.rs` and the Coq
> sources; `Print Assumptions` captured at commit `8840b0a92`. Regenerate with
> `python3 scripts/generate-ledgers.py` (`--capture` re-measures). REQ-103.

These are the only theorems public surfaces may cite as guarantees (mandate S2.4). Every
one is about the formal model of the language; the compiler is tested against that model,
not proven to implement it. Reproduce with `riinac verify --coq`, which checks the same
list in the kernel.

| Theorem | File | Status | Kernel assumptions | Witnesses (+ / −) | Reviewed |
|---|---|---|---|---|---|
| `type_safety` | `02_FORMAL/coq/type_system/TypeSafety.v:27` | HEADLINE | closed under the global context | `type_safety_premises_satisfiable` / `type_safety_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `progress` | `02_FORMAL/coq/type_system/Progress.v:118` | HEADLINE | closed under the global context | `progress_premises_satisfiable` / `progress_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `preservation` | `02_FORMAL/coq/type_system/Preservation.v:1229` | HEADLINE | closed under the global context | `preservation_premises_satisfiable` / `preservation_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `well_typed_SN` | `02_FORMAL/coq/termination/ReducibilityFull.v:1288` | CONDITIONAL | `FunctionalExtensionality.functional_extensionality_dep` | none: a premise is refuted in the build / `well_typed_SN_conclusion_is_false` | PENDING (D7 reviewer) |
| `accepts_uses_only_current` | `02_FORMAL/coq/crypto/AlgorithmPolicy.v:90` | HEADLINE | closed under the global context | `pqc_program_accepted` / `accepts_uses_only_current_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `effect_sound_multi_step_declared` | `02_FORMAL/coq/effects/EffectGate.v:608` | HEADLINE | closed under the global context | `effect_sound_multi_step_declared_premises_satisfiable` / `effect_sound_multi_step_declared_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `reachable_effects_from_program_text` | `02_FORMAL/coq/effects/EffectContainment.v:195` | HEADLINE | closed under the global context | `reachable_effects_from_program_text_premises_satisfiable` / `reachable_effects_from_program_text_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `ref_free_well_typed_SN` | `02_FORMAL/coq/termination/StrongNormRefFree.v:704` | HEADLINE | closed under the global context | `ref_free_well_typed_SN_premises_satisfiable` / `ref_free_well_typed_SN_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `ref_free_noninterference` | `02_FORMAL/coq/properties/NonInterferenceRefFree.v:656` | HEADLINE | closed under the global context | `ref_free_noninterference_nonvacuous` / `ref_free_noninterference_conclusion_not_trivial` | PENDING (D7 reviewer) |
| `ref_free_constant_time` | `02_FORMAL/coq/properties/NonInterferenceRefFree.v:690` | HEADLINE | closed under the global context | `ref_free_noninterference_nonvacuous` / `ref_free_constant_time_conclusion_not_trivial` | PENDING (D7 reviewer) |

## `type_safety`

- **Statement:** A closed term that is well typed at the Public level, run in a store that matches its store typing, is never stuck: it is a value or it can take a step.
- **Fragment:** The full core calculus in foundations/Syntax.v (27 constructors, including references and fix).
- **Public claim:** Type safety is proven in Coq for the language model.
- **Source:** `02_FORMAL/coq/type_system/TypeSafety.v:27` (module `RIINA.type_system.TypeSafety`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `progress`

- **Statement:** A closed, well-typed term in a well-formed store is a value or can take a step.
- **Fragment:** The full core calculus.
- **Public claim:** Progress is proven in Coq for the language model.
- **Source:** `02_FORMAL/coq/type_system/Progress.v:118` (module `RIINA.type_system.Progress`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `preservation`

- **Statement:** A step from a well-typed term in a well-formed store yields a term of the same type (its effect annotation may change), in a store that is still well formed under an extended store typing.
- **Fragment:** The full core calculus.
- **Public claim:** Preservation is proven in Coq for the language model.
- **Source:** `02_FORMAL/coq/type_system/Preservation.v:1229` (module `RIINA.type_system.Preservation`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `well_typed_SN`

- **Statement:** Under the Section premises of ReducibilityFull.v, every well-typed recursion-free term is strongly normalizing.
- **Fragment:** None in practice: one premise is refuted in the build, and the conclusion is false for the calculus with higher-order references.
- **Public claim:** Never cite as a guarantee.
- **Source:** `02_FORMAL/coq/termination/ReducibilityFull.v:1288` (module `RIINA.termination.ReducibilityFull`)
- **Status:** CONDITIONAL
- **Note:** Vacuous (REQ-84): well_typed_SN_premise_store_values_are_values_refutable disproves a premise, and well_typed_SN_conclusion_is_false (Landin's knot) shows the conclusion fails. Leaves KERNEL_CAPSTONES when REQ-104 moves it to counterexamples/ (REQ-116). The guarantee that holds is ref_free_well_typed_SN.
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `accepts_uses_only_current`

- **Statement:** A program the crypto-agility policy accepts uses only algorithms the policy marks as current.
- **Fragment:** The algorithm-policy model in crypto/AlgorithmPolicy.v (a fact about the policy check, not about the crypto implementations).
- **Public claim:** The crypto-agility policy check is proven in Coq to accept only current algorithms (policy model).
- **Source:** `02_FORMAL/coq/crypto/AlgorithmPolicy.v:90` (module `RIINA.crypto.AlgorithmPolicy`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `effect_sound_multi_step_declared`

- **Statement:** Every term reachable by evaluating a closed, well-typed term performs only effects within the effect bound its type declares.
- **Fragment:** The full core calculus.
- **Public claim:** Effect soundness against the declared effect is proven in Coq for the language model.
- **Source:** `02_FORMAL/coq/effects/EffectGate.v:608` (module `RIINA.effects.EffectGate`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `reachable_effects_from_program_text`

- **Statement:** Evaluation adds no effect site that is absent from the program text and the initial store.
- **Fragment:** The full core calculus (no typing premise).
- **Public claim:** Evaluation introduces no effect absent from the program and store (proven in Coq for the language model).
- **Source:** `02_FORMAL/coq/effects/EffectContainment.v:195` (module `RIINA.effects.EffectContainment`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `ref_free_well_typed_SN`

- **Statement:** Every well-typed term without references or fix is strongly normalizing: every evaluation of it terminates.
- **Fragment:** The reference-free, fix-free core only. With higher-order references, termination is provably false (see well_typed_SN).
- **Public claim:** Termination is proven in Coq for the reference-free, recursion-free core.
- **Source:** `02_FORMAL/coq/termination/StrongNormRefFree.v:704` (module `RIINA.termination.StrongNormRefFree`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `ref_free_noninterference`

- **Statement:** For a well-typed term without references or fix whose one free variable is Secret, and whose result type is observable, runs that differ only in the secret input reach the same value.
- **Fragment:** The reference-free, fix-free core only (REQ-89 extends it).
- **Public claim:** Non-interference is proven in Coq for the reference-free, recursion-free core; beyond it, it is enforced by tests.
- **Source:** `02_FORMAL/coq/properties/NonInterferenceRefFree.v:656` (module `RIINA.properties.NonInterferenceRefFree`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## `ref_free_constant_time`

- **Statement:** For the same terms, the number of evaluation steps is well defined and does not depend on the secret input.
- **Fragment:** The reference-free, fix-free core; the cost model is the reduction count of the formal semantics, not cycles or wall-clock time.
- **Public claim:** Reduction-count independence from secrets is proven in Coq for the language model, for the core fragment.
- **Source:** `02_FORMAL/coq/properties/NonInterferenceRefFree.v:690` (module `RIINA.properties.NonInterferenceRefFree`)
- **Status:** HEADLINE
- **Verify:** `riinac verify --coq` (kernel `Print Assumptions`)

## Cited on the website, not headline

The website's evidence ledger also shows these. None is a guarantee: each carries its own
claim level (§2), and cited families report how many of their proofs the vacuity detector
flags (those count as excluded Qed).

| Cited as | Level | Source | Kernel assumptions | Role |
|---|---|---|---|---|
| `Semantics.step_deterministic` | PROVEN-MODEL | `02_FORMAL/coq/foundations/Semantics.v:502` | closed under the global context | Evaluation in the formal semantics is deterministic. A building block the capstones rest on, not a security property. |
| `Declassification.logical_relation_declassify_proven` | PROVEN-MODEL | `02_FORMAL/coq/properties/Declassification.v:130` | closed under the global context | A declassification step lemma. A building block; the non-interference guarantee is ref_free_noninterference. |
| `X25519.x25519_rfc7748_vector1` | MODELLED | `02_FORMAL/coq/crypto/X25519.v:125` | closed under the global context | The Coq X25519 model computes the RFC 7748 test vector. A fact about the model, not about the shipped implementation. |
| `montgomery::tests::test_x25519_matches_coq_model` | ENFORCED-TESTED | `05_TOOLING/crates/riina-core/src/crypto/montgomery.rs` | — | Compares the shipped X25519 with the Coq model on test vectors. Testing, not a proof that the Rust implements the model. |
| `verification_boundary.json` | ENFORCED-TESTED | `05_TOOLING/crates/riina-core/verification_boundary.json` | — | States, per crypto primitive, what is modelled, trusted and not covered; a test fails when a primitive gains a proof without a boundary entry. |
| `HIPAACompliance.COMPLY_001_*` | MODELLED | `02_FORMAL/coq/compliance/HIPAACompliance.v` (15 theorems, 0 flagged vacuous) | — | HIPAA obligations as Coq facts about the file's own definitions. Evidence toward HIPAA, not a conformity assessment. |
| `PCIDSSCompliance.COMPLY_002_*` | MODELLED | `02_FORMAL/coq/compliance/PCIDSSCompliance.v` (37 theorems, 1 flagged vacuous) | — | PCI-DSS obligations as Coq facts about the file's own definitions. Evidence toward PCI-DSS, not a conformity assessment. |
| `DO178CCompliance.COMPLY_003_*` | MODELLED | `02_FORMAL/coq/compliance/DO178CCompliance.v` (20 theorems, 0 flagged vacuous) | — | DO-178C objectives as Coq facts about the file's own definitions. Evidence toward DO-178C, not certification. |
| `ConstantTimeCrypto.CT_001_branch_free` | MODELLED | `02_FORMAL/coq/domains/ConstantTimeCrypto.v:115` | closed under the global context | Models the masa_tetap branch-freedom discipline. The compiler's masa_tetap check is ENFORCED-TESTED separately (PROPERTY_LEDGER.md). |

## Witnesses and open items

- Every capstone has a positive witness (its premises hold for a concrete term) and a
  negative witness (its conclusion fails for a term that violates a premise), except the
  positive witness of a CONDITIONAL theorem whose premise the build refutes (S2.9). Most
  are in `02_FORMAL/coq/properties/HeadlineWitnesses.v`; the counting policy excludes
  them, since they test statements rather than cover anything.
- 10 of 10 statements await a named human review (S2.10, owner ruling D7).
