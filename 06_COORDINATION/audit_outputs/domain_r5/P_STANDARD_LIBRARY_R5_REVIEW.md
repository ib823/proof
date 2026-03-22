# Domain Audit Review

## Verdict
`accept with reductions`

## Snapshot validation
- branch: `main`
- commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- valid for snapshot: `yes`
- drift consequence: `materially harmless` (no domain files changed since snapshot)

## Maximum honest rating
**R2**

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|---|---|---|---|---|---|
| G1 | Pass | Pass | Agree | Research docs exist | - |
| G2 | Pass | Pass | Agree | `02_FORMAL/coq/domains/StandardLibrary.v` has 40 shallow theorems. | - |
| G3 | Pass | Pass | Corrected | Audit claimed `riina-types` has stdlib. Actually implemented in `riina-codegen/src/builtins/` (Malay localized builtins). | Update evidence location. |
| G4 | Fail | Fail | Agree | No formal linkage between Coq models (`Vec`, `HashMap`) and Rust builtins (`senarai`, `peta`). | Keeps rating at R2. |
| G5 | Fail | Fail | Corrected | Audit called proofs "VACUOUS". They are shallow reflexivity proofs of functional models, but mathematically sound. | Reclassify as "shallow" rather than vacuous. |
| G6 | Pass | Pass | Agree | No fake auto-generation detected. | - |
| G7 | Pass | Pass | Agree | No axioms or admits in `StandardLibrary.v`. | - |
| G8 | Pass | Pass | Agree | `riina-codegen` has extensive unit tests for all standard library builtins. | - |
| G9 | Pass | Pass | Agree | Standard library heavily used in integration tests. | - |
| G10 | Pass | Pass | Agree | `cargo test` and `clippy` pass cleanly. | - |
| G11 | Pass | Pass | Agree | Safe claim correctly bounds the verification state. | - |
| G12 | Pass | Pass | Agree | Lack of domain-specific enforcement noted. | - |
| G13 | Fail | Fail | Agree | Disconnect between Coq English types and Rust Malay builtins. | Keeps rating at R2. |
| G14 | Pass | Pass | Agree | No false marketing in safe claim. | - |

## Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|---|---|---|---|---|
| Medium | G3 | "Implementation: riina-types has stdlib types" | `riina-types` contains only AST definitions. The actual standard library is implemented in `03_PROTO/crates/riina-codegen/src/builtins/` using Malay names (`senarai`, `peta`, `teks`, etc.). | Correct implementation mapping. |
| Low | G5 | "Coq is mostly vacuous (80% reflexivity)" | The proofs in `02_FORMAL/coq/domains/StandardLibrary.v` are shallow functional models proven by definitional equality, not logically vacuous. | Correct terminology from "vacuous" to "shallow". |

## Overclaim lines
- "Coq is mostly vacuous (80% reflexivity)" (They are shallow, not mathematically vacuous).
- "Implementation: riina-types has stdlib types"

## Missed evidence lines
- The implementation of the standard library actually lives in `03_PROTO/crates/riina-codegen/src/builtins/` and consists of heavily tested, Malay-localized builtins (e.g., `senarai` for List, `peta` for Map, `teks` for String).

## Safe claim
"RIINA has a standard library with basic types implemented as runtime builtins and partially modeled in Coq, but most formal proofs are shallow functional models."

## Unsafe claim
"RIINA's standard library is fully formally verified with deep implementation mappings."

## Release condition
Target R3 by creating Verus or Kani harnesses that formally link the Coq English functional models (`Vec`, `HashMap`) to the actual Rust Malay implementations (`senarai`, `peta`) in `riina-codegen/src/builtins/`.

## Next review advice
Inspect `riina-codegen/src/builtins/` for formal tooling annotations. Ensure the Coq models are updated to reflect the actual localized standard library design or that an explicit translation layer is formalized.