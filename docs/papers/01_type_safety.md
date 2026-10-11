# Paper 1: Type Safety for RIINA — Progress and Preservation with Security Labels

## Abstract

We present a formal proof of type safety for RIINA, a programming language with
Bahasa Melayu keywords and compile-time security enforcement. RIINA combines a
standard simply-typed lambda calculus core with an information flow control (IFC)
security lattice, algebraic effects, and linear types. We prove progress and
preservation for the full language, including security label interactions, effect
annotations, and substructural typing. All proofs are mechanized in Coq (Rocq 9.1.1, the pinned prover).

## Key Results

- **Theorem: Progress** — Well-typed programs either are values or can take a step.
  Coq reference: `progress` (`type_system/Progress.v`); with preservation it gives
  `type_safety` (`type_system/TypeSafety.v`), closed under the global context.
- **Theorem: Preservation** — If a well-typed term steps, the result is well-typed
  at the same type. Coq reference: `preservation` (`type_system/Preservation.v`);
  `preservation_effect` additionally bounds the result's effect by the declared one,
  giving dynamic effect soundness (`effect_sound_multi_step_declared`).
- **Theorem: Strong Normalization (reference-free, `fix`-free core)** — every
  well-typed term of that core terminates in every store and is strongly
  normalizing, with no premises. Coq reference: `ref_free_well_typed_SN`,
  `ref_free_terminates` (`termination/StrongNormRefFree.v`, closed under the
  global context). References are excluded for a reason: with higher-order
  references a well-typed term can diverge through Landin's knot, which Coq proves
  (`well_typed_SN_conclusion_is_false`), so the older `well_typed_SN` statement
  for the full calculus is false and is vacuous (REQ-84).
  **Scope (REQ-44, Option A):** general recursion (`fungsi`/`fix`, which the
  implementation desugars to `LetRec`) is Turing-complete and **intentionally not
  strongly normalizing** — its guarantee is *type safety* (progress + preservation,
  mechanized for `fix` in `foundations/RecursionSafety.v`), not termination.
  Structurally-decreasing recursion is separately covered by sized types
  (`domains/V001_TerminationGuarantees.v`).
- **Theorem: Security Label Consistency** — Type derivations respect the security
  lattice ordering (Awam < Dalaman < Sesi < Pengguna < Sistem < Rahsia).

## Proof Architecture

- Core calculus: simply-typed lambda calculus with pairs, sums, references
- Security extension: IFC labels as type-level annotations
- Effect extension: algebraic effect rows with lattice ordering
- Linear extension: substructural qualifiers (sekali, paling, mesti)
- Total Coq Qed proofs in core: see `02_FORMAL/coq/`

## Related Work (Sketch)

- Wright & Felleisen (1994) — Syntactic approach to type soundness
- Pottier & Simonet (2003) — Information flow inference (FlowCaml)
- Bauer & Pretnar (2015) — Algebraic effect handlers (Eff)
- Walker (2005) — Substructural type systems

## Venue Target

**POPL** (ACM SIGPLAN Symposium on Principles of Programming Languages)
or **ICFP** (International Conference on Functional Programming)

## Coq Source Files

- `02_FORMAL/coq/foundations/Syntax.v`
- `02_FORMAL/coq/foundations/Typing.v`
- `02_FORMAL/coq/foundations/Semantics.v`
- `02_FORMAL/coq/foundations/Progress.v`
- `02_FORMAL/coq/foundations/Preservation.v`
- `02_FORMAL/coq/foundations/Termination.v`
