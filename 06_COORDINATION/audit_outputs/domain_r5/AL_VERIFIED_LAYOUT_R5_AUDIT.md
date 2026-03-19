# Domain Audit Record

## 1. Identity

- Domain name: Verified Layout
- Domain identifier: `AL_VERIFIED_LAYOUT`
- Folder(s): `01_RESEARCH/57_DOMAIN_AL_VERIFIED_LAYOUT/`, `02_FORMAL/coq/domains/VerifiedLayout.v`, `02_FORMAL/coq/domains/AccessibilityVerification.v`, `03_PROTO/crates/riina-ui/`, `07_EXAMPLES/09_cahaya/`
- Audit date: `2026-03-19`
- Auditor: Codex
- Current repo commit: `0293b678480d19c92843c34b2a25306bca54eb60`
- Command-derived Rust passing tests on this snapshot: `2476`
- `cargo clippy --manifest-path 03_PROTO/Cargo.toml -- -D warnings` on this snapshot: `passed`
- `audit-docs.sh` status on this snapshot: `0 discrepancies`, `1 warning` (`Coq warning status is stale`)

## 2. Canonical Source Map

### Canonical research authority

- `01_RESEARCH/57_DOMAIN_AL_VERIFIED_LAYOUT/RESEARCH_AL01_FOUNDATION.md`

### Canonical formal files

- `02_FORMAL/coq/domains/VerifiedLayout.v`
- `02_FORMAL/coq/domains/AccessibilityVerification.v`

### Canonical implementation files

- frontend CAHAYA surface:
  - `03_PROTO/crates/riina-lexer/src/lexer.rs`
  - `03_PROTO/crates/riina-parser/src/lib.rs`
  - `03_PROTO/crates/riina-typechecker/src/lib.rs`
  - `03_PROTO/crates/riina-codegen/src/interp.rs`
  - `03_PROTO/crates/riina-codegen/src/lower.rs`
  - `03_PROTO/crates/riina-codegen/src/emit.rs`
- standalone UI crate:
  - `03_PROTO/crates/riina-ui/src/lib.rs`
  - `03_PROTO/crates/riina-ui/src/sinar.rs`
  - `03_PROTO/crates/riina-ui/src/rupa.rs`
  - `03_PROTO/crates/riina-ui/src/lukis.rs`
  - `03_PROTO/crates/riina-ui/src/susun.rs`
  - `03_PROTO/crates/riina-ui/src/sentuh.rs`
  - `03_PROTO/crates/riina-ui/src/terminal.rs`
  - `03_PROTO/crates/riina-ui/src/html.rs`

### Canonical examples

- `07_EXAMPLES/09_cahaya/layout_example.rii`
- `07_EXAMPLES/09_cahaya/contrast_check.rii`
- `07_EXAMPLES/09_cahaya/hello_ui.rii`

### Non-authoritative or overclaim-prone supporting files

- `04_SPECS/language/RIINA_MATERIALIZATION_PLAN_v1_0_0.md`
- `04_SPECS/requirements/cahaya_render.jsx`

## 3. Current Scope Assessment

### What the research claims

The research thesis claims: `"If it compiles, the UI/UX is perfect."` It further claims pixel-perfect layouts on every screen, accessibility for every human, responsiveness at every viewport, and visually consistent output across every platform in `RESEARCH_AL01_FOUNDATION.md`.

### What the live repo actually supports

- lexer/parser/typechecker/interpreter support for:
  - `paparan` / `display`
  - `baris` / `row`
  - `lajur` / `column`
  - `tulisan` / `text`
  - `butang` / `button`
  - `warna` / `color`
  - `kontras` / `contrast`
  - `gaya` / `style`
- a standalone `riina-ui` crate with:
  - ANSI terminal rendering
  - HTML rendering
  - simple row/column layout placement
  - overlap detection
  - WCAG contrast helpers
  - input-event helpers

### What is not honestly supported yet

- verified flexbox/grid as live language constructs
- responsive layout proofs across viewport ranges
- live target support for `terminal` or `html` in the backend target enum
- end-to-end integration of the standalone `riina-ui` crate into `riinac`
- compile-time guarantee that all covered UI/accessibility properties are enforced
- the research-thesis claim of perfect UI/UX across platforms

## 4. Workflow Inventory

| Workflow | Current status | Evidence |
|----------|----------------|----------|
| Parse and execute a simple row-based UI display | Works | `layout_example.rii` runs through `riinac` and emits ANSI-colored output |
| Evaluate WCAG-style contrast for literal colors | Works | `contrast_check.rii` runs through `riinac` and returns `Bool(true)` |
| Parse and execute a button example with handler | Broken | `hello_ui.rii` fails with `Expected identifier` at `fungsi() { 42 }` |
| Render UI tree through standalone terminal renderer | Works in crate tests | `cargo test -p riina-ui --manifest-path 03_PROTO/Cargo.toml` passes |
| Render UI tree through standalone HTML renderer | Works in crate tests | same `riina-ui` test run |
| Build a first-class `--target html` or `--target terminal` artifact | Missing | `03_PROTO/crates/riina-codegen/src/backend.rs` has no `Html` or `Terminal` target |

## 5. Formal Depth Assessment

### Coq

- `VerifiedLayout.v` is live and non-empty, with box model, overlap, bounds, and accessibility records.
- It includes some nontrivial list reasoning such as `all_in_bounds` and monotonicity lemmas like `VL_039`.
- It also contains many shallow sample-instance and boolean-unpacking proofs such as:
  - `VL_017` through `VL_021` by reflexivity over a pre-constructed good config
  - `VL_040` through `VL_048` over accessibility booleans
- `AccessibilityVerification.v` is largely boolean-config validity plus projection lemmas. It is mechanized, but much of it is configuration-validity reasoning rather than workflow-complete UI verification.

### Non-Coq lanes

- `VerifiedLayout.als` and `AccessibilityVerification.als` are explicitly derived from Coq.
- `VerifiedLayout.smt2` and `AccessibilityVerification.smt2` contain many `= 0 0` placeholders.
- `AccessibilityVerification.tla` contains multiple `== TRUE` definitions.
- Verus/Kani files are also marked as derived from Coq.

Conclusion:
- the domain has real formalization, enough to exceed pure research-only status
- the non-Coq lanes are not safe to count as strong independent evidence

## 6. Live Implementation Assessment

### Real live frontend/runtime evidence

- lexer keywords exist in `riina-lexer/src/lexer.rs`
- parser rules exist in `riina-parser/src/lib.rs` for display/row/column/text/button/color/contrast/style
- typechecker rules exist in `riina-typechecker/src/lib.rs`
- interpreter support exists in `riina-codegen/src/interp.rs`
- lowering/emit support exists in `riina-codegen/src/lower.rs` and `riina-codegen/src/emit.rs`

### Real standalone crate evidence

- `riina-ui` exists as a separate crate with:
  - row/column layout in `susun.rs`
  - WCAG contrast helpers in `rupa.rs`
  - renderer abstraction in `sinar.rs`
  - terminal and HTML renderers in `terminal.rs` and `html.rs`
- `cargo test -p riina-ui --manifest-path 03_PROTO/Cargo.toml` passed with `45` tests

### Structural limitations

- `riina-ui` is not wired into the live compiler pipeline; the only direct references found in `03_PROTO` were the crate manifests
- backend target support still only includes `Native`, `Wasm32`, `Wasm64`, `AndroidArm64`, and `IosArm64`
- the live CAHAYA slice is much narrower than the research claims about full layout verification, flexbox/grid, and cross-platform pixel-perfect guarantees

## 7. Executable Evidence

Commands run on this snapshot:

```bash
export PATH="/home/codespace/.rustup/toolchains/1.84.0-x86_64-unknown-linux-gnu/bin:$PATH"
cargo test -p riina-ui --manifest-path 03_PROTO/Cargo.toml
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- run 07_EXAMPLES/09_cahaya/layout_example.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- run 07_EXAMPLES/09_cahaya/contrast_check.rii
cargo run --quiet --manifest-path 03_PROTO/Cargo.toml -p riinac -- run 07_EXAMPLES/09_cahaya/hello_ui.rii
```

Observed outcomes:

- `riina-ui` tests: `45` passed
- `layout_example.rii`: executed and emitted colored row output
- `contrast_check.rii`: executed and returned `Bool(true)`
- `hello_ui.rii`: failed to parse with `Expected identifier` at the button handler

## 8. Gate Scores

| Gate | Score | Basis | Consequence |
|------|-------|-------|-------------|
| `G1` Canonical Identity | Partial | Research, Coq, CAHAYA frontend, and `riina-ui` crate all exist, but the live implementation is split between a wired CAHAYA slice and a detached UI crate | Domain identity is real but not cleanly unified |
| `G2` Boundary Precision | Fail | Research/spec wording claims perfect UI/UX and broad responsive/pixel-perfect guarantees far beyond the live slice | Caps the domain below enforcement claims |
| `G3` Workflow Inventory | Partial | A few concrete workflows are executable, but the broad lifecycle and responsiveness claims are not mapped to live workflows | Blocks `R4` |
| `G4` Threat and Failure Model | Partial | Accessibility and no-overlap concerns exist, but abuse, sequencing, and cross-platform failure states are not comprehensively enforced | Blocks `R4` |
| `G5` Property Set | Partial | Real properties exist for overlap, bounds, contrast, and some accessibility concepts, but many research properties are not live | Blocks higher claims |
| `G6` Formal Model Depth | Partial | Live Coq files exist, but much of the proof mass is sample-instance or boolean-validity reasoning; non-Coq lanes are largely generated/vacuous | Enough for formal modeling, not enough for strong independence |
| `G7` Toolchain Enforcement | Partial | Real CAHAYA parser/typechecker/interpreter support exists, but the `riina-ui` crate is not wired into the compiler targets and the covered subset is narrow | Blocks `R3-R4` claims for the full umbrella |
| `G8` Executable Evidence | Partial | Two canonical examples work, one fails, and no first-class `html`/`terminal` target exists | Blocks `R3-R4` for the broader claim surface |
| `G9` Adversarial Evidence | Partial | Unit tests cover overlap detection and low-contrast failure locally, but not through a workflow-complete end-to-end invalid UI suite | Blocks `R4` |
| `G10` Independent Evidence Honesty | Partial | Derived/vacuous non-Coq lanes are visibly derived, but they are not safe to count as strong independent evidence | Requires explicit honesty in claims |
| `G11` Observability and Auditability | Partial | Example outputs and renderer strings are inspectable, but there is no audit-grade layout proof artifact or runtime evidence chain | Blocks `R4-R5` |
| `G12` Freshness and Reproducibility | Pass | Commands reran cleanly on current `HEAD` | Audit is reproducible |
| `G13` Public Claim Discipline | Fail | Research/spec wording still claims compile-time-perfect UI/UX and pixel-perfect guarantees | Public wording must be reduced |
| `G14` Regression Immunity | Fail | No AL-specific readiness gate exists to stop drift between research claims and live subset | Rating is not protected |

## 9. Rating

- Current rating: `R2`
- Rating cap: `R2`
- Why this is not lower:
  - a real formal model exists in live Coq files
  - a real live CAHAYA subset exists in the frontend/runtime
  - executable evidence exists for a narrow subset
- Why this is not higher:
  - enforcement is incomplete and much narrower than the research thesis
  - the standalone `riina-ui` crate is detached from the live compiler pipeline
  - one canonical example already fails
  - public wording still overclaims perfect UI/UX and cross-platform layout guarantees

## 10. Safe Public Wording

- Safe claim:
  - `RIINA currently has a formally modeled and partially executable UI/layout lane with live CAHAYA support for basic display, row/column composition, color contrast checking, and a standalone tested renderer/layout crate, but it does not yet provide the research-claimed compile-time guarantee of perfect responsive or accessibility-complete UI/UX.`
- Unsafe claim:
  - `If RIINA UI code compiles, the UI/UX is perfect, pixel-perfect on every screen, accessible to every human, and visually correct across every platform.`

## 11. Blocking Gaps

| Gap | Severity | Concrete fix | Owner | Notes |
|-----|----------|--------------|-------|-------|
| Research/spec wording wildly outruns live subset | Critical | Reduce wording to the bounded live slice | Pending | Main claim-discipline blocker |
| `riina-ui` crate is detached from the toolchain | High | Wire terminal/HTML rendering path into `riinac` or demote the crate to standalone status explicitly | Pending | Structural integration gap |
| No live `Html` or `Terminal` backend target | High | Add explicit targets or stop implying a real platform backend | Pending | Current target enum does not expose these |
| Canonical hello-world UI example fails | High | Fix `hello_ui.rii` or replace it with a truly live canonical example | Pending | Blocks end-to-end confidence |
| Flex/grid/responsive claims are research-only | Critical | Add bounded live semantics or remove those claims from current status | Pending | Core domain-boundary gap |
| Accessibility formal lane is config-heavy | Medium | Tie accessibility proofs to live workflow states and rejected cases | Pending | Needed for stronger `R2-R3` confidence |
| No AL-specific readiness gate | Medium | Add domain-specific checks for example execution and bounded feature support | Pending | Needed for `R4-R5` |

## 12. Promotion Checklist

### To stay honest at `R2`

- [x] Canonical research source exists
- [x] Live Coq formal model exists
- [x] Real live subset exists in parser/typechecker/runtime
- [x] Narrow executable examples exist
- [ ] Public wording is reduced to the bounded subset

### To reach `R3`

- [ ] `riina-ui` is actually integrated into the toolchain or explicitly replaced by a live backend path
- [ ] Covered invalid cases are rejected through the live toolchain for the claimed subset
- [ ] canonical happy-path examples all parse and execute

### To reach `R4`

- [ ] workflow matrix is complete for the stated UI/layout slice
- [ ] negative and adversarial UI/accessibility workflows exist end-to-end
- [ ] non-Coq lane honesty is reflected in public claims

### To reach `R5`

- [ ] every gate `G1-G14` passes
- [ ] third-party reproduction is straightforward
- [ ] public wording is exact and conservative
- [ ] AL-specific regression gates exist and are enforced

## 13. Sign-Off

- Final verdict:
  - `R2` is the maximum honest rating at commit `0293b678480d19c92843c34b2a25306bca54eb60`.
- Reviewer notes:
  - hostile review completed in [AL_VERIFIED_LAYOUT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AL_VERIFIED_LAYOUT_R5_REVIEW.md)
  - review verdict: `accept`
  - review confirmed the `R2` cap and agreed that the main blockers are the detached `riina-ui` crate, the broken `hello_ui.rii` example, and the false "perfect UI/UX" wording
- Follow-up date:
  - after live compiler integration, repaired canonical examples, and reduced public wording justify re-audit
