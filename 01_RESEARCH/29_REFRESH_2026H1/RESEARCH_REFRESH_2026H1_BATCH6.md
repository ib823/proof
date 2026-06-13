# RIINA Research Refresh — 2026 H1, Batch 6 (REQ-39)

## Document Control

| Property | Value |
|----------|-------|
| Document ID | RESEARCH-REFRESH-2026H1-B6 |
| Version | 1.0.0 |
| Date | 2026-06-13 |
| Scope | Promote two thin single-file domains to real depth: real-time/WCET + schedulability, and hardware-software co-verification (REQ-39) |
| Method | Survey (cited) → comparison → RIINA decision, per the 01_RESEARCH house format |
| Status | Complete (Batch 6 of the broad refresh) |
| Supersedes | Nothing — deepens Domain T–V (hermetic build / runtime guardian / termination) and Domain AR (HW-SW co-verification), flagged thin by the 2026-06-12 corpus audit |

> **Why this exists.** The corpus audit (REQ-39) found real-time/WCET and
> hardware-software co-verification were single-file foundational stubs while the
> foundational lanes (type theory, effects, IFC) had multi-session depth. This
> batch raises them to survey→comparison→decision depth so RIINA's position on
> each is explicit and defensible. Research-level; no code ships here.

---

# B6-01: Real-time / WCET / schedulability verification

## Executive Summary

Worst-Case Execution Time (WCET) and schedulability are a mature but
**assumption-heavy** field. The honest result: sound WCET is **not a
language-level property** — it is a property of (program × compiler × specific
microarchitecture × memory layout). A language can *enable* it (predictable
control flow, bounded loops, no hidden allocation) but cannot *deliver* a cycle
count from source alone.

## Survey

- **Static WCET — the reference tools:** **aiT** (AbsInt; abstract-interpretation
  WCET, used in DO-178 avionics), **OTAWA**, **Heptane**, **Chronos**. They
  combine value/cache/pipeline abstract interpretation with **IPET** (Implicit
  Path Enumeration — an ILP over the control-flow graph) to bound the longest
  path. All are **target-microarchitecture-specific** (they model the exact cache
  and pipeline).
- **The hard part is the microarchitecture:** caches, out-of-order execution,
  branch prediction, and shared-resource interference (multicore memory bus, LLC)
  make tight *and sound* bounds hard. **Timing anomalies** (a locally faster step
  yielding a globally slower path) mean naive worst-case-per-step composition is
  unsound. Multicore interference is the open frontier — partitioned scheduling +
  memory-bandwidth regulation (e.g. MemGuard-style) is the practical mitigation.
- **Schedulability:** classical **RMA/Liback-Layland** utilization bounds, **RTA**
  (Response-Time Analysis) fixed-point iteration, EDF. These are well-formalized
  (some mechanized — e.g. **Prosa**, a Coq library for response-time analysis) and
  are *compositional given per-task WCET inputs*. Prosa is the notable
  formal-methods anchor: schedulability is provable in Coq **once WCETs are given**.
- **Language enablers:** statically-bounded loops (no unbounded `while`), no
  hidden heap allocation on the hot path, no recursion (or bounded), predictable
  dispatch. These are exactly the disciplines a verified language can enforce.

## Comparison to RIINA's prior position

RIINA has Domain V (termination guarantees — `V001_TerminationGuarantees.v`,
sized-type termination) and a `RIINA_WCET_TYPES.md` spec fragment, but no
integrated WCET story. Termination ≠ WCET (terminating says nothing about cycles).

## Decision (RIINA)

**RIINA's WCET contribution is the *enabling discipline* + a Prosa-style
schedulability lane, NOT a source-level cycle oracle — stated relative to a named
target.** Concretely (research positions, not commitments):
1. **Enforce WCET-enabling constraints as opt-in effect/type discipline:** a
   `masa_tetap`-adjacent "real-time" mode that rejects unbounded loops, heap
   allocation, and unbounded recursion on annotated functions — RIINA *can* do
   this soundly at the type level.
2. **Bounds come from an external WCET tool** (aiT/OTAWA on the emitted C for a
   *named* target), consumed as a trusted input — exactly as RIINA's CT guarantee
   is stated relative to a hardware-software leakage contract (the same honesty
   pattern as the GoFetch/§6 scope).
3. **Schedulability can be RIINA-verified given per-task WCETs** (a Prosa-style
   RTA/EDF Coq lane), since that part *is* compositional and mechanizable.
4. **Multicore interference is out of language scope** — a deployment/RTOS concern
   (partitioning + bandwidth regulation), disclosed not claimed.

This is REQ-39's real-time half: depth + an honest, target-relative position.

---

# B6-02: Hardware-software co-verification

## Executive Summary

Co-verification proves properties that span the hardware/software boundary
(e.g. "the software's security invariant holds given the HW's contract, and the
HW implements that contract"). The field's center of gravity is **specifying the
contract precisely** and proving each side against it — not one monolithic proof.

## Survey

- **ISA-level formal models:** **Sail** (the executable ISA-spec language; the
  authoritative formal models of ARMv8-A and RISC-V are written in Sail and export
  to Coq/Isabelle/HOL4). This is the linchpin — software proofs that need an ISA
  semantics build on Sail-derived models.
- **Verified hardware:** **Kami** (Coq, Bluespec-style modular hardware
  verification, MIT), the **RISC-V formal spec**, and end-to-end stacks like
  **CakeML** (verified compiler) over verified hardware. **Knox** (hardware
  security-module co-verification) and the **Iris**-based concurrent-separation
  work bound the software side.
- **Hardware-software leakage contracts (the security-relevant frontier):**
  **Guarnieri et al., "Hardware-Software Contracts for Secure Speculation" (S&P
  2021)** — the formal framework for stating *which* microarchitectural channels a
  program's security is proved against. This is the precise mechanism RIINA's
  threat model already gestures at for CT/GoFetch.
- **CHERI co-verification:** the CHERI capability model has machine-checked proofs
  (Sail + Isabelle) that the architecture enforces memory-safety/monotonicity — a
  concrete example of a HW contract a language can build on.

## Comparison to RIINA's prior position

Domain AR was a single foundational file; RIINA's threat model (§6, REQ-32)
already invokes "a named hardware-software leakage contract (Guarnieri et al.)"
for CT scope, and Batch 4 named Caliptra/OpenTitan as RoT anchors — so the pieces
exist but were not consolidated.

## Decision (RIINA)

**RIINA's co-verification posture: prove the SOFTWARE side against an explicitly
named hardware contract; treat the HARDWARE side as a trusted, separately-verified
input (Sail/Kami/CHERI), never re-proved in-language.** Concretely:
1. **Adopt the Guarnieri et al. (S&P 2021) leakage-contract framing as the
   official way RIINA states its CT/side-channel guarantees** — promote it from a
   threat-model footnote to the stated contract (in-scope vs out-of-scope channels
   become explicit, not implicit). This is the single most actionable item.
2. **If RIINA ever needs ISA-level reasoning** (e.g. for the CT codegen pass or a
   CHERI target), build on **Sail-derived** ARM/RISC-V models rather than a bespoke
   ISA semantics.
3. **The hardware RoT (Caliptra/OpenTitan, Batch 4) and the ISA contract (Sail) are
   the two trusted hardware inputs**; RIINA's verified surface is the language +
   stdlib + emitted code *relative to* those contracts. This boundary is the honest
   scope and should be stated wherever RIINA claims a HW-touching guarantee.

---

## Summary of decisions (research-level)

| Item | RIINA position |
|---|---|
| Source-level WCET cycle oracle | **Not claimed** — bounds come from an external target-specific tool (aiT/OTAWA), consumed as trusted input |
| WCET-enabling discipline | In-scope: opt-in type/effect mode rejecting unbounded loops/alloc/recursion |
| Schedulability | RIINA-verifiable given per-task WCETs (Prosa-style RTA/EDF Coq lane) — compositional, mechanizable |
| Multicore timing interference | Out of language scope (RTOS/partitioning) |
| HW-SW leakage contract | **Adopt Guarnieri et al. S&P 2021 framing** as the official CT-scope statement (highest-value follow-on) |
| ISA-level reasoning | Build on Sail-derived ARM/RISC-V models if ever needed; do not re-prove hardware |

Feeds REQ-39 (research depth recorded; the named follow-ons — the real-time
effect-mode and adopting the Guarnieri contract framing in the threat model — are
implementation/spec increments, not this batch).
