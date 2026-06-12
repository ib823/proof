# Paper 2: Non-Interference via Step-Indexed Logical Relations for RIINA

## Abstract

We prove non-interference for RIINA's information flow control system using
step-indexed logical relations in the style of Appel and McAllester. RIINA
enforces a six-level security lattice (Awam through Rahsia) at compile time,
preventing unauthorized information flow from high-security to low-security
contexts. We mechanize the proof in Coq, demonstrating that well-typed RIINA
programs cannot leak secrets through direct flows, implicit flows, or
termination channels.

## Key Results

- **Theorem: Non-Interference** — Observations at security level L cannot
  distinguish executions that differ only in data at levels above L.
- **Theorem: No Direct Flows** — Data labeled `Rahsia` cannot flow to
  `Awam` without explicit declassification with proof justification.
- **Theorem: Declassification Soundness** — The `dedah` (declassify)
  operation requires a valid `Bukti` (proof) term, ensuring controlled
  information release.
- **Step-indexed approach** — Avoids the need for impredicative encodings;
  scales to the full language with effects and references.

## Proof Architecture

- Step-indexed logical relation over typed terms
- Security lattice: 6 levels with reflexive-transitive ordering
- Declassification modeled as bounded downward flow with proof obligation
- Compatible with effect annotations (effects don't leak information)
- Handles mutable references via step-indexed Kripke worlds

## Related Work (Sketch)

- Appel & McAllester (2001) — Step-indexed logical relations
- Volpano, Smith & Irvine (1996) — Type-based information flow
- Sabelfeld & Myers (2003) — Language-based information flow security
- Rajani & Garg (2018) — Non-interference for algebraic effects

## Venue Target

**IEEE S&P** (IEEE Symposium on Security and Privacy)
or **CCS** (ACM Conference on Computer and Communications Security)

## Coq Source Files

- `02_FORMAL/coq/security/` (security-related proofs)
- `02_FORMAL/coq/foundations/Security.v`
- `02_FORMAL/coq/foundations/Labels.v`
