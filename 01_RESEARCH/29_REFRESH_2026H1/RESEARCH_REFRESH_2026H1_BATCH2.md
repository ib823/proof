# RIINA Research Refresh — 2026 H1, Batch 2

## Document Control

| Property | Value |
|----------|-------|
| Document ID | RESEARCH-REFRESH-2026H1-B2 |
| Version | 1.0.0 |
| Date | 2026-06-01 |
| Scope | Verified quantum compilation, zero-knowledge proofs, and LLM-assisted proof pipelines |
| Method | Web-sourced survey (cited) → comparison → decision, per the 01_RESEARCH house format |
| Status | Complete (Batch 2 of the broad refresh; Batch 3 in a follow-up session) |
| Augments | Domain E (formal verification), the blockchain/Syariah-finance domain, and Phase-10 ecosystem (REQ-22 LLM-for-RIINA, Bijak) |

> **Why this exists.** Continuation of the 2026 refresh. Batch 2 covers three
> domains adjacent to RIINA's longer-horizon ambitions: quantum compilation
> (Phase-N), zero-knowledge proofs (blockchain/Syariah finance, Phase 6), and
> LLM-assisted proving (Phase 10). Each ends in a concrete RIINA decision, and one
> produced a directive-level finding (zk-SNARK trusted setup vs. "No Assumptions").

---

# B2-01: Verified Quantum Compilation (SQIR / VOQC)

## Executive Summary

The reference point for *formally verified* quantum compilation remains **VOQC**
(A Verified Optimizer for Quantum Circuits, POPL 2021), built on **SQIR** (Small
Quantum Intermediate Representation) — and, notably, **written in Coq**, the same
proof assistant as RIINA's primary lane. VOQC is competitive with or better than
IBM Qiskit and CQC tket: ~17.7% average gate-count reduction vs Qiskit's 10.7% on
a 29-circuit benchmark. Extracted artifacts exist as `mlvoqc` (OCaml) and `pyvoqc`
(Python).

## Survey

- **Maturity:** SQIR/VOQC is stable, not rapidly moving; no 2025 architecture
  change surfaced. It uses a symbolic complex-matrix semantics to reason over
  circuits with an arbitrary number of qubits.
- **Toolchain caveat (important for RIINA):** SQIR/VOQC currently supports **Coq
  8.16–8.20** — it has **not** been ported to **Rocq 9.2** (RIINA's pinned prover).
  Any in-tree integration would require either a VOQC Rocq port or an extraction
  boundary.

## Comparison to RIINA's position

Quantum compilation is **not in RIINA's current scope** (no quantum keywords,
types, or domain). RIINA's relevance is purely prospective.

## Decision

- **Do NOT build verified quantum compilation in-house.** If a quantum target ever
  enters scope, integrate **VOQC** via its extracted `mlvoqc`/`pyvoqc` artifacts
  behind a `kesan` boundary rather than re-deriving circuit semantics.
- **Record the Coq-version mismatch** (VOQC = Coq ≤8.20; RIINA = Rocq 9.2) as a
  known integration cost, so nobody assumes a drop-in Coq merge is possible.
- Track in Domain E as external SOTA; re-check on a multi-year cadence (slow-moving).

---

# B2-02: Zero-Knowledge Proofs (SNARK vs STARK, 2026)

## Executive Summary

ZKPs have matured from theory to production by 2026. The two families trade off
cleanly:

| Property | zk-SNARK | zk-STARK |
|----------|----------|----------|
| Proof generation | ~68× faster | slower |
| Proof size | ~123× smaller | larger |
| Verification | slower | faster |
| **Trusted setup** | **Required** | **None (transparent)** |
| Post-quantum security | generally no (pairing-based) | **yes (hash-based)** |

Beyond blockchain, a 2025–2026 frontier is **verifiable ML inference** (translating
models into SNARK-verifiable form).

## Comparison to RIINA's position — DIRECTIVE-LEVEL FINDING

RIINA has a blockchain / Syariah-finance domain (`sukuk`, `mudarabah`,
`KontrakPintar`, `kesan SyariahPatuh`) where ZKPs are the natural privacy primitive.
The choice is **not value-neutral for RIINA**:

> **A zk-SNARK's trusted setup is, literally, a trusted assumption** — a structured
> reference string that, if its toxic waste is not destroyed, breaks soundness.
> That directly collides with RIINA's Prime Directive name itself: **"No
> Assumptions."** A transparent **zk-STARK** has **no trusted setup** and is
> **post-quantum secure**, both of which align with RIINA's zero-trust / no-axiom
> philosophy (cf. the Coq lane's 0-axiom discipline and Batch 1's PQC tracking).

## Decision

- **If/when RIINA adds ZKP support for the blockchain/finance domain, default to
  zk-STARK**, not zk-SNARK — the transparent, post-quantum, no-trusted-setup family
  is the one consistent with "No Assumptions." A SNARK option may be offered only
  with an explicit, documented trusted-setup assumption (treated like a `Parameter`/
  TCB entry, never silently).
- Add this as a **design constraint** in the blockchain-domain backlog (not an
  implemented feature — RIINA has no ZKP code today).
- Watch verifiable-ML-inference as a possible future CAHAYA/AI-widget primitive.

---

# B2-03: LLM-Assisted Theorem Proving (2025–2026)

## Executive Summary

LLM-driven proof synthesis advanced sharply in 2025, and the SOTA is overwhelmingly
**Lean 4-targeted**:

- **DeepSeek-Prover-V2** (open source, May 2025) — recursive decomposition + RL,
  non-CoT and CoT modes emitting Lean 4 proofs.
- **Goedel-Prover-V2** (Princeton) — new open-source Lean 4 SOTA, models ~80×
  smaller than competitors.
- **AlphaProof** (DeepMind) — AlphaZero-style RL over millions of auto-formalized
  problems with test-time RL; **5/6 IMO 2025 problems solved with formally verified
  proofs.**
- Autoformalization (raw conjecture + `mathlib` context → Lean statement + proof
  sketch, refined via prover feedback) is the dominant data-generation loop.

## Comparison to RIINA's position

This is directly relevant to **Phase 10 / REQ-22 (fine-tuned LLM for RIINA code
generation)** and the Bijak learning platform. Two hard facts:

1. **The SOTA targets Lean 4** — but **RIINA's Lean lane is `generated`/broken**
   (7/326 files elaborate). RIINA's *mechanized* lane is **Coq/Rocq**, which is
   **not** where the strongest open LLM provers operate. So RIINA cannot today plug
   into DeepSeek/Goedel-Prover and get verified RIINA proofs.
2. The autoformalization loop needs an elaborating library to give prover feedback;
   RIINA's Lean port can't provide that yet.

## Decision

- **Do NOT claim any LLM-assisted proving capability** for RIINA — none exists, and
  the lane the SOTA needs (elaborating Lean) is precisely RIINA's weakest.
- **Strategic implication for the Lean lane:** if RIINA wants to ride the
  LLM-proving wave (Phase 10), the prerequisite is making the **Lean port actually
  elaborate** — which reframes the long-deferred "Lean elaboration" work from a
  cosmetic multi-prover nicety into the **enabling step** for REQ-22. This is the
  strongest argument yet for prioritizing Lean elaboration over a Lean *version*
  bump (cf. W4.4: bumping Lean 4.16→4.29 without fixing elaboration is backwards).
- Track DeepSeek-Prover-V2 / Goedel-Prover-V2 / AlphaProof as external SOTA in
  Domain E; re-check every 6 months (fast-moving).

---

# Integration Notes

1. **Domain E:** add external SOTA refs — VOQC (verified quantum, Coq ≤8.20),
   DeepSeek-Prover-V2 / Goedel-Prover-V2 / AlphaProof (LLM proving, Lean 4).
2. **Blockchain / Syariah-finance domain:** ZKP design constraint — **default to
   zk-STARK** (no trusted setup, post-quantum), consistent with "No Assumptions";
   any SNARK use must declare its trusted-setup assumption explicitly.
3. **Phase 10 / REQ-22:** LLM-for-RIINA depends on an elaborating Lean lane; this
   makes "fix Lean elaboration" a prerequisite, and argues against a blind Lean
   version bump.

## Sources

- SQIR/VOQC: <https://github.com/inQWIRE/SQIR>; "A Verified Optimizer for Quantum
  Circuits" (POPL 2021, <https://www.cs.umd.edu/~mwh/papers/voqc.pdf>); mlvoqc /
  pyvoqc bindings.
- ZKP: "Zero-Knowledge Proof Frameworks: A Survey" (arXiv 2502.07063); "A
  Comparative Analysis of zk-SNARKs and zk-STARKs" (arXiv 2512.10020); ZKP 2026
  overview (Calmops).
- LLM proving: DeepSeek-Prover-V2 (InfoQ 2025-05; arXiv 2405.14333 lineage);
  Goedel-Prover-V2 (Princeton); AlphaProof / IMO 2025 (DeepMind); Lean Copilot
  (arXiv 2404.12534).
