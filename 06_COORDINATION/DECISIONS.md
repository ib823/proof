# RIINA Architecture Decisions

## Decision Log

### D001: Repository Structure

**Date**: 2026-01-11
**Decision**: Single repository with track-based directories
**Rationale**: Simplifies coordination for solo developer
**Status**: IMPLEMENTED

### D002: Coq as Primary Proof Assistant

**Date**: 2026-01-11
**Decision**: Use Rocq 9.1 (Coq 8.21) as primary, Lean 4 as secondary
**Rationale**: Better library support for PL proofs, mature ecosystem
**Status**: IMPLEMENTED

### D003: Zero Third-Party Crypto Dependencies

**Date**: 2026-01-03
**Decision**: Implement all crypto from scratch (Law 8)
**Rationale**: Nation-state resistance requires no supply chain trust
**Status**: IMPLEMENTED (symmetric), IN PROGRESS (asymmetric)

### D004: Lexer-First Prototype Development

**Date**: 2026-01-11
**Decision**: Track B starts with complete lexer before parser
**Rationale**: Lexer is self-contained, enables early testing
**Status**: IN PROGRESS

### D005: Certified Compilation (Domain R)

**Date**: 2026-01-15
**Decision**: Implement Translation Validation (TERAS-TV) instead of just a certified compiler.
**Rationale**: Eliminates "Trusting Trust" attacks. If the compiler lies, the proof fails.
**Status**: RESEARCH (Foundational)

### D006: Hardware Contracts (Domain S)

**Date**: 2026-01-15
**Decision**: Verify against an Augmented ISA model (ISA v2.0) that includes microarchitectural leakage.
**Rationale**: "Normal" proofs are invalid on speculative hardware (Spectre). We must model the hardware as an adversary.
**Status**: RESEARCH (Foundational)

### D007: Hermetic Recursive Bootstrap (Domain T)

**Date**: 2026-01-15
**Decision**: Bootstrap the entire toolchain from a single ~512-byte hex seed (`hex0`).
**Rationale**: Eliminates all supply chain attacks. We trust no binary on Earth.
**Status**: RESEARCH (Foundational)

### D008: Runtime Guardian (Domain U)

**Date**: 2026-01-15
**Decision**: Run applications under a formally verified Micro-Hypervisor (Sentinel).
**Rationale**: Physical faults (cosmic rays) bypass static proofs. The Sentinel enforces invariants at runtime.
**Status**: RESEARCH (Foundational)

### D009: Security-Aware Store Relation

**Date**: 2026-01-23
**Decision**: Make store_rel_n security-level aware - LOW locations require val_rel_n, HIGH only require typing.
**Rationale**: HIGH security data is not observable by low-security observers, so requiring structural equality is unnecessary and creates unprovable admits.
**Status**: IMPLEMENTED (Session 40)

### D010: Strong Induction for Step-Up

**Date**: 2026-01-23
**Decision**: Use strong induction via `lt_wf_ind` for combined_step_up_all theorem.
**Rationale**: Resolves mutual dependency between val_rel_n and store_rel_n step-up by providing IH for all m < n.
**Status**: IMPLEMENTED (Session 40)

### D011: Type Size Induction for TFn

**Date**: 2026-01-23
**Decision**: Use ty_size_induction for TFn case in val_rel step-up.
**Rationale**: Arguments T1 in TFn T1 T2 have strictly smaller ty_size, enabling recursive IH application.
**Status**: IMPLEMENTED (Session 41)

### D012: Materialization Plan Adoption

**Date**: 2026-01-30
**Decision**: Adopt `RIINA_MATERIALIZATION_PLAN_v1_0_0.md` as authoritative 7-phase plan for taking RIINA from prototype to production.
**Rationale**: Comprehensive plan correcting inaccurate state assumptions, incorporating syntax improvement spec, with concrete file paths, line estimates, and dependency graph.
**Status**: DOCUMENTED (execution deferred until Track A stabilizes)

### D013: Parser Desugaring Principle

**Date**: 2026-01-30
**Decision**: New parser syntax (pipe `|>`, guard `pastikan`, for-in, while) MUST desugar to existing `expr` constructors (EApp, EIf, ELet, ELam) — zero Coq impact.
**Rationale**: Avoids expensive re-verification of formal proofs when adding syntactic sugar.
**Status**: DOCUMENTED (pending implementation in Phase 1.2)

### D014: While Loop Termination Strategy — Fuel-Based

**Date**: 2026-01-30 (opened), 2026-02-14 (resolved)
**Decision**: Fuel-based bounded iteration. `selagi cond, had: N { body }` desugars to bounded recursion with fuel parameter N. Pure functions get provable termination. Effectful functions (`kesan Sistem`) may use unbounded `selagi` which desugars to a fuel of `usize::MAX` (non-termination only in effectful context).
**Rationale**: Preserves strong normalization (well_typed_SN) for pure code. Matches Coq's termination requirement. The fuel parameter is explicit — no hidden divergence. Effect-gating for unbounded loops keeps the pure/effectful boundary clean. Implementable as parser desugaring (D013 principle) — `selagi cond, had: N { body }` → recursive `EApp` with fuel countdown.
**Status**: RESOLVED

### D019: Module Resolution — File-Based

**Date**: 2026-02-14
**Decision**: File-based module resolution (like Rust/Go). `modul foo;` looks for `foo.rii` or `foo/lib.rii` relative to the importing file's directory. Search order: (1) sibling `foo.rii`, (2) sibling directory `foo/lib.rii`, (3) package paths from `riina.toml`.
**Rationale**: File-based resolution is simpler for tooling (LSP, formatter, doc generator), maps naturally to file system, and matches developer expectations from Rust/Go. Declaration-based modules add parser/typechecker complexity with no security benefit.
**Status**: RESOLVED

### D020: Integer Representation — u64 Core + Signed Library

**Date**: 2026-02-14
**Decision**: Keep `u64` as the core integer representation (matches Coq's `nat`). Signed integer operations (`tolak`, subtraction yielding negative) provided as library functions returning `Option<u64>` or a dedicated `Bilangan` (Number) type wrapping i64. No change to `Expr::Int(u64)` or Coq `TInt`.
**Rationale**: Coq's natural number (`nat`) is unsigned. Changing to i64 would require re-proving all arithmetic lemmas in Coq. The library approach keeps the core type system aligned with formal proofs while providing signed arithmetic for practical programs. Future Phase 8 (self-hosting) may introduce `TSignedInt` if needed, with corresponding Coq formalization.
**Status**: RESOLVED

### D021: Infix Operator Syntax — Both (Desugar to Function Calls)

**Date**: 2026-02-14
**Decision**: Support both infix operators and function-call style. Infix operators desugar to function applications: `x + y` → `App(App(Var("tambah"), x), y)`. Supported infix operators: `+` (tambah), `-` (tolak), `*` (darab), `/` (bahagi), `%` (baki), `==` (sama), `!=` (tak_sama), `<`, `>`, `<=`, `>=`, `&&` (dan), `||` (atau). Precedence follows standard mathematical convention.
**Rationale**: Infix is ergonomic for arithmetic and comparisons. Desugaring to function calls means zero new Coq constructors needed (D013 principle). The parser handles precedence; the type system sees only `EApp`. Both styles can be mixed freely.
**Status**: RESOLVED

### D015: Coq Directory Consolidation — domains/ as Canonical Location

**Date**: 2026-02-02
**Decision**: Removed 11 empty placeholder directories from `02_FORMAL/coq/` (compiler/, concurrency/, infra/, memory/, network/, os/, performance/, physical/, runtime/, security/, ui/). All domain-specific proofs live in `domains/` and its subdirectories (mobile_os/, security_foundation/, uiux/).
**Rationale**: Empty directories with only `.gitkeep` files created false negatives in audits — appearing as "missing proofs" when the proofs exist in `domains/`. A single canonical location eliminates organizational ambiguity. The Coq build (249 files, 4,885 Qed) references `domains/` exclusively; no files ever existed in the removed directories. Core structural directories (`foundations/`, `type_system/`, `effects/`, `properties/`, `compliance/`, `Industries/`) are retained as they contain active proof files.
**Status**: IMPLEMENTED (Session 70 audit)

### D016: Website Must Use CSS Classes, Not Inline Styles

**Date**: 2026-02-02
**Decision**: All website styling in `RiinaWebsite.jsx` must use CSS classes (in `riina.css`), not React inline `style={{}}` objects. Existing ~588 inline styles must be migrated to CSS classes.
**Rationale**: React inline styles compile to element-level `style=""` attributes which have highest CSS specificity. No media query or class-based rule can override them, making responsive design impossible. The website is currently unusable on mobile due to this pattern.
**Status**: SPECIFIED (see Materialization Plan §12.9)

### D017: Verified Layout — Compile-Time UI/UX Correctness (Track AL)

**Date**: 2026-02-02
**Decision**: Establish research track AL (Domain 57: Verified Layout) to formalize RIINA's layout primitives in Coq and integrate layout verification into the compiler's type system. Layout types (`Susun<T>`, `Lentur`, `Grid`) carry proof obligations verified at compile time: no overflow at any viewport width, WCAG AAA accessibility, cross-platform visual equivalence. 105 properties across 47 layout + 38 accessibility + 12 performance + 8 cross-platform.
**Rationale**: No programming language offers compile-time UI/UX correctness. The closest academic work (Cassius/VizAssert, UW PLDI 2018) is an external verifier, not language-integrated. RIINA can be the first language where "if it compiles, the UI is perfect." This extends RIINA's security guarantee to the visual layer.
**Status**: RESEARCH (see `01_RESEARCH/57_DOMAIN_AL_VERIFIED_LAYOUT/RESEARCH_AL01_FOUNDATION.md`, Materialization Plan §12.10)

### D018: AI-First Language Design — Vibe Coding Standard (Track AM)

**Date**: 2026-02-02
**Decision**: Establish research track AM (Domain 58: AI-First Language) to make RIINA the ideal language for AI code generation. Key deliverables: (1) machine-readable language reference (≤40K tokens), (2) `riinac check --json` compiler-in-the-loop API, (3) `llms.txt` + AI IDE config files, (4) training data corpus (error/fix pairs, intent→code pairs, Python→RIINA comparisons), (5) MCP server for AI tools.
**Rationale**: 41% of new code is AI-generated (2026). The #1 vibe coding problem is AI generating plausible-but-wrong code. RIINA's compiler proves what humans don't read — the perfect safety net. But AI models need to know RIINA exists (zero training data today). This track addresses discoverability, AI context, compiler feedback API, and training data.
**Status**: RESEARCH (see `01_RESEARCH/58_DOMAIN_AM_AI_FIRST_LANGUAGE/RESEARCH_AM01_FOUNDATION.md`, Materialization Plan §12.11)