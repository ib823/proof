# Property ledger

> **Generated — do not edit by hand.** Source: `04_SPECS/ledgers/properties.toml`.
> Regenerate with `python3 scripts/generate-ledgers.py`. REQ-103.

Every security or correctness property RIINA advertises, with its claim level in the
hardening mandate's vocabulary (§2):

| Level | Meaning |
|---|---|
| PROVEN-IMPL | proven for, or validated on every run of, the shipped `riinac` |
| PROVEN-MODEL | Coq theorem, closed under the global context, about the formal model; linked to the compiler only by testing |
| ENFORCED-TESTED | the compiler rejects violations; positive and negative tests |
| MODELLED | a formal model of X, proving facts about its own definitions |
| GENERATED | produced by a script, not independently checked |
| RETIRED | no longer maintained |
| PLANNED | not built |

No property is PROVEN-IMPL today: that needs assured mode (REQ-100).

| Property | Level | Fragment | Theorem | Tests | Verify |
|---|---|---|---|---|---|
| Type safety: well-typed programs do not get stuck | PROVEN-MODEL | Full core calculus (27 constructors) | `type_safety` | `03_PROTO/crates/riina-typechecker/src/tests.rs` | `riinac verify --coq` |
| Effect soundness: evaluation stays within the declared effect | PROVEN-MODEL | Full core calculus | `effect_sound_multi_step_declared` | `03_PROTO/crates/riina-typechecker/src/tests.rs` | `riinac verify --coq` |
| The compiler rejects effects a function does not declare | ENFORCED-TESTED | The shipped language | — | `03_PROTO/crates/riina-typechecker/src/tests.rs`<br>`03_PROTO/crates/riinac/tests/end_to_end.rs` | `cargo test -p riina-typechecker` |
| Non-interference: secret inputs do not change observable results | PROVEN-MODEL | Reference-free, fix-free core only (REQ-89 extends it) | `ref_free_noninterference` | — | `riinac verify --coq` |
| The compiler rejects information-flow violations it implements (secret to public sinks, unproven declassification) | ENFORCED-TESTED | The shipped language; not proven to match the model | — | `03_PROTO/crates/riina-typechecker/src/tests.rs`<br>`03_PROTO/crates/riinac/tests/secret_arithmetic.rs` | `cargo test -p riina-typechecker` |
| Reduction-count independence from secrets | PROVEN-MODEL | Reference-free, fix-free core; cost model = reduction count, not cycles | `ref_free_constant_time` | — | `riinac verify --coq` |
| masa_tetap blocks reject secret-dependent branching and variable-time operations | ENFORCED-TESTED | The shipped language | — | `03_PROTO/crates/riinac/tests/masa_differential.rs` | `cargo test -p riinac --test masa_differential` |
| Termination of well-typed programs | PROVEN-MODEL | Reference-free, fix-free core only; false with higher-order references | `ref_free_well_typed_SN` | — | `riinac verify --coq` |
| The crypto-agility policy accepts only current algorithms | PROVEN-MODEL | The policy model (crypto/AlgorithmPolicy.v) | `accepts_uses_only_current` | `03_PROTO/crates/riinac/tests/kripto_runtime.rs` | `riinac verify --coq` |
| Runtime capability gate: an effect not granted is refused (interpreter and native C) | ENFORCED-TESTED | Interpreter and C backend | — | `03_PROTO/crates/riinac/tests/capability_gate.rs` | `cargo test -p riinac --test capability_gate` |
| Runtime capability gate on the WASM backend | PLANNED | WASM compiles the gate to a no-op today (REQ-114) | — | — | — |
| Packages may use only the effects their manifest allows | ENFORCED-TESTED | riinac pkg build | — | `03_PROTO/crates/riinac/tests/pkg_build.rs` | `cargo test -p riinac --test pkg_build` |
| Native (C) backend computes what the interpreter computes | ENFORCED-TESTED | Differential tests over the example corpus; not formally verified (REQ-59) | — | `03_PROTO/crates/riinac/tests/corpus_differential.rs`<br>`03_PROTO/crates/riinac/tests/audit_backend_differential.rs` | `cargo test -p riinac --test corpus_differential` |
| WASM backend agrees with the C backend | ENFORCED-TESTED | Differential tests; not formally verified | — | `03_PROTO/crates/riinac/tests/wasm_c_differential.rs` | `cargo test -p riinac --test wasm_c_differential` |
| No floating point: a float literal is a compile error (P0015) | ENFORCED-TESTED | The shipped parser | — | `03_PROTO/crates/riina-parser/src/tests.rs` | `cargo test -p riina-parser` |
| Compliance profiles: heuristic checks giving evidence toward a profile, not a conformity assessment | ENFORCED-TESTED | 19 profiles; per-rule implementation status is REQ-123 | — | `03_PROTO/crates/riina-compliance/src/tests.rs` | `cargo test -p riina-compliance` |
| Domain, industry and compliance Coq files | MODELLED | Facts about each file's own definitions; not verifications of real systems | — | — | `riinac verify --coq` |
| In-house cryptography (riina-core): experimental, not audited, not validated | ENFORCED-TESTED | Tested against NIST known-answer (ACVP) vectors for ML-KEM-768 and ML-DSA-65 and single RFC/FIPS vectors elsewhere; no CMVP/CAVP certificate | — | `05_TOOLING/crates/riina-core/tests/kat_audit.rs` | `cargo test --manifest-path 05_TOOLING/Cargo.toml -p riina-core` |
| Security-lattice and effect-join laws | MODELLED | Z3 scoped set (02_FORMAL/smt/SCOPED_SET.txt), checked for exact unsat counts | — | `02_FORMAL/smt/SCOPED_SET.txt` | `bash scripts/verify-smt.sh` |
| Assured mode: the extracted Coq checker decides every program | PLANNED | REQ-100 | — | — | — |
| Non-interference for the full core (references, fix, effects) | PLANNED | REQ-89 | — | — | — |
| Isabelle and F* prover lanes | RETIRED | Retired (REQ-67g); generated corpora archived 2026-10-20 (D6) | — | — | — |
| Independent Lean 4 re-proof of the core metatheory | PLANNED | REQ-67(b); the generated port was archived 2026-10-20 (D6) | — | — | — |

**By level:** PROVEN-MODEL 6, ENFORCED-TESTED 10, MODELLED 2, RETIRED 1, PLANNED 4

**`metrics.json` `claimLevels` → §2 levels:**

| claimLevels value | §2 level |
|---|---|
| mechanized (Coq) | PROVEN-MODEL |
| mechanized (SMT scoped set) | MODELLED |
| generated | GENERATED |
| retired | RETIRED |
| compiled | none published today |
| independently_audited | none (false today) |

PROVEN-MODEL rows were last checked in the kernel at commit `07e5821e5`;
ENFORCED-TESTED rows run on every commit (`cargo test` in CI).
