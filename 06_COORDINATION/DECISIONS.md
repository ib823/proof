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

### D014: While Loop Termination Strategy (OPEN)

**Date**: 2026-01-30
**Decision**: PENDING — requires decision between (a) bounded iteration with fuel parameter, (b) effect-based divergence marker, or (c) termination proof obligation.
**Rationale**: While loops can diverge; RIINA's strong normalization guarantee (well_typed_SN) must be reconciled.
**Status**: OPEN (see materialization plan §15 for details)

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