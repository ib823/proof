# RIINA Research Refresh — 2026 H1, Batch 5 (REQ-38)

## Document Control

| Property | Value |
|----------|-------|
| Document ID | RESEARCH-REFRESH-2026H1-B5 |
| Version | 1.0.0 |
| Date | 2026-06-13 |
| Scope | AI/ML security beyond inference-time robustness; closes the REQ-38 gap behind the Part 6 "OWASP LLM Top-10 90%" claim and the Domain AM "AI-first language" positioning |
| Method | Web-sourced survey (cited frameworks) → comparison → decision, per the 01_RESEARCH house format |
| Status | Complete (Batch 5 of the broad refresh) |
| Supersedes | Nothing — augments Domain NU (verified AI/ML), Domain AT (AI/ML safety verification), Domain AM (AI-first language), and qualifies the Part 6 OWASP-LLM row |

> **Why this exists.** The corpus covers neural-network *inference-time*
> verification (α,β-CROWN/VNN-COMP — robustness ε-balls, Lyapunov stability) but
> the 2026-06-12 audit (REQ-38) found **no** treatment of the broader ML-security
> surface: training-data poisoning, model extraction, membership inference, LLM
> prompt-injection/jailbreak, RAG correctness, and federated/differential-privacy
> verification. That surface is load-bearing because Part 6 claims "OWASP LLM
> Top-10 90%" and Domain AM positions RIINA as an "AI-first language." This dossier
> states honestly what RIINA can and cannot enforce, and re-qualifies the claim.

---

# B5-01: The threat surface and the honest language/type boundary

## Executive Summary

ML security splits into threats a **language/type system can enforce** at the
trust boundary, and threats that are **statistical/model-level** and outside any
type system's reach. RIINA's leverage is the former; conflating the two is the
overclaim REQ-38 guards against.

## Survey of the surface (frameworks: OWASP LLM Top-10 2025, MITRE ATLAS, NIST AI RMF)

- **Prompt injection / jailbreak (OWASP LLM01):** untrusted text reaching an LLM
  "instruction" position. Structurally a **taint** problem — untrusted input must
  not flow to a trusted-instruction sink without mediation.
- **Insecure output handling (LLM02):** LLM output treated as trusted (fed to
  `eval`, SQL, shell, DOM). Structurally **taint at the sink** — LLM output is
  `Tainted` and must be sanitized before a sensitive sink.
- **Training-data poisoning (LLM03):** adversarial training data flips model
  behavior / plants backdoors. **Statistical + supply-chain**; not type-enforceable
  at inference. Defenses: data provenance/attestation, RONI/influence analysis,
  spectral-signature backdoor detection — *process*, not language.
- **Model extraction / stealing:** query-based reconstruction of a model's weights
  or behavior. **Rate/observation-level**; defenses are query budgeting,
  watermarking, output perturbation — *deployment*, not language.
- **Membership inference:** deciding whether a record was in the training set.
  **Statistical privacy**; the principled defense is **differential privacy**
  (DP-SGD) with a tracked ε budget — a *training-time* guarantee.
- **Federated learning:** distributed training without centralizing data; security
  needs secure aggregation (MPC) + DP + Byzantine-robust aggregation. **Protocol +
  statistical**, not language-level.
- **RAG correctness:** retrieval-augmented generation grounding/faithfulness.
  Partly a **taint/provenance** problem (which retrieved chunk is trusted), partly
  statistical (faithfulness is not decidable by types).

## The dividing line

| Threat | Type-enforceable at the boundary? | RIINA's principled lever |
|---|---|---|
| Prompt injection (LLM01) | **Yes** | Taint: untrusted → instruction sink |
| Insecure output handling (LLM02) | **Yes** | Taint: LLM output `Tainted` → sink sanitizer |
| Excessive agency / tool calls | **Partly** | Capability/effect gating of tool calls |
| Sensitive-info disclosure | **Partly** | IFC: secret may not reach LLM/public sink (REQ-27) |
| Training-data poisoning | No (process) | Supply-chain attestation only |
| Model extraction | No (deployment) | — |
| Membership inference | No (statistical) | DP is a training property, not a type |
| Federated/DP guarantees | No (protocol/statistical) | — |
| RAG faithfulness | Partly (provenance) | Taint/provenance; faithfulness undecidable |

## Decision (RIINA) — the honest claim

**RIINA's AI-security value is the taint/IFC/capability boundary, NOT statistical
model security.** Concretely, the type-enforceable lane (LLM01/LLM02, agency,
disclosure) is a natural extension of RIINA's *existing* taint + REQ-27 secret-sink
machinery: an LLM API binding would type its prompt parameter to **reject
`Tainted` (untrusted) input in the instruction position** and type its completion
as **`Tainted<Teks, LlmOutput>`** that a downstream sensitive sink must sanitize —
exactly the discipline already enforced for `sql_*`/`http_*`/file sinks. The
statistical/process threats (poisoning, extraction, membership inference,
federated/DP) are **explicitly out of language scope** and belong to data
governance, training-time DP, and deployment controls.

---

# B5-02: Re-qualification of the Part 6 "OWASP LLM Top-10 90%" claim

The prior "90%" row conflated boundary-enforceable and statistical threats. Honest
restatement:

> **OWASP LLM Top-10 (2025): RIINA's *type-system* lane covers the boundary-
> enforceable items** — prompt injection (LLM01) and insecure output handling
> (LLM02) as taint problems, excessive agency via capability/effect gating, and
> sensitive-disclosure via IFC (REQ-27) — **as a design direction, not yet a
> shipped LLM binding.** The statistical/process items (training-data poisoning,
> model theft, membership inference) are **out of language scope** by design and
> are not claimed. The bare "90%" figure is withdrawn as unsubstantiated; it is
> replaced by this enumerated, honestly-scoped position.

## Decision (RIINA)

**Withdraw the unqualified "90%"; adopt the enumerated boundary/out-of-scope split
above.** When an LLM stdlib binding is built (future, not now), it must (1) type
prompts to reject untrusted-instruction taint, (2) type completions as `Tainted`,
(3) capability-gate tool invocation — and ship with pos/neg parity tests mirroring
the existing injection-prevention suite. No code in this batch; this closes the
*research + honesty* half of REQ-38 and supersedes the bare percentage.

---

## Summary

| Cluster | RIINA position |
|---|---|
| Boundary-enforceable (injection, output-handling, agency, disclosure) | In-scope **design direction**; extends existing taint/IFC/capability machinery; not yet a shipped LLM binding |
| Statistical/process (poisoning, extraction, membership inference, DP, federated) | **Out of language scope** by design; data-governance / training-time / deployment controls |
| Inference-time robustness (α,β-CROWN) | Already surveyed (Domain AT / Batch 1); RIINA claims no NN-verification lane |

Feeds REQ-38 (PARTIAL → research + honesty recorded; an actual LLM-binding
implementation with the taint typing above is the named follow-on) and the Part 6
OWASP-LLM re-qualification.
