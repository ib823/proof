# RIINA Research Refresh — 2026 H1, Batch 4 (REQ-37)

## Document Control

| Property | Value |
|----------|-------|
| Document ID | RESEARCH-REFRESH-2026H1-B4 |
| Version | 1.0.0 |
| Date | 2026-06-13 |
| Scope | Post-quantum + hardware-root-of-trust currency wave; closes the gaps the corpus's own Batch 1 named "missing" plus the 2026-06-12 corpus audit (REQ-37) |
| Method | Web-/standards-sourced survey (cited) → comparison → decision, per the 01_RESEARCH house format |
| Status | Complete (Batch 4 of the broad refresh) |
| Supersedes | Nothing — augments Domain G (crypto), Domain D/S (hardware), Domain AS (post-quantum), REQ-19/REQ-31/REQ-32 |

> **Why this exists.** Batch 1 of this refresh explicitly flagged **FIPS 206
> (FN-DSA)** and **HQC** as missing from RIINA's post-quantum research, and the
> 2026-06-12 corpus audit (REQ-37) added **hybrid-KEM transition** (X-Wing),
> **SLAP** (a 2025 Apple M-series speculative attack absent while its sibling FLOP
> was covered), and **silicon root-of-trust** (Caliptra/OpenTitan) as currency
> gaps. This dossier closes each with a concrete RIINA decision. Honesty note: this
> is a *research* refresh — it states positions and decisions; it does not itself
> ship code or proofs.

---

# B4-01: FIPS 206 (FN-DSA / Falcon) — the third NIST signature standard

## Executive Summary

NIST's post-quantum signature line is three standards: **FIPS 204 (ML-DSA /
Dilithium)** and **FIPS 205 (SLH-DSA / SPHINCS+)** are final (Aug 2024); **FIPS
206 (FN-DSA, based on Falcon)** remains in **draft** as of this writing — the
NTRU-lattice, floating-point-Gaussian-sampling signature whose appeal is very
small signatures (≈ 666 B for the level-1 parameter) at the cost of a famously
hard-to-implement, side-channel-sensitive sampler.

## Survey

- FN-DSA's distinguishing risk is the **floating-point Gaussian sampler**: getting
  it constant-time is the open implementation hazard (the original Falcon reference
  needed careful `fpr_*` constant-time emulation; naive FP leaks the key via timing,
  and emulated/integer Gaussian sampling is the recommended path).
- The standard was not final at our knowledge horizon; treat any "FIPS 206
  support" claim as premature until the final spec + ACVP vectors exist.

## Comparison to RIINA's prior position

RIINA ships **ML-DSA-65 (FIPS 204)** byte-exact vs ACVP and a hybrid Ed25519+ML-DSA
signature. It makes **no** FN-DSA claim. That is the correct, honest position.

## Decision (RIINA)

**Do NOT implement FN-DSA yet.** Rationale: (1) the standard is draft; (2) the FP
Gaussian sampler is exactly the kind of side-channel-sensitive code whose
from-scratch constant-time implementation (Law 8 forbids a dependency) is a
multi-month, audit-grade effort; (3) ML-DSA already satisfies the signature need.
**Revisit when** FIPS 206 is final AND ACVP vectors are published — then scope an
integer-Gaussian (Karney/constant-time) sampler with a dudect + ctgrind gate from
day one. Record FN-DSA as a *known future standard*, not a gap to rush.

---

# B4-02: HQC — NIST's code-based backup KEM

## Executive Summary

In **March 2025 NIST selected HQC** (Hamming Quasi-Cyclic) as an additional
standardized KEM, to be specified in a future FIPS (draft expected 2026, final
~2027). HQC is **code-based** (BCH/quasi-cyclic), giving a *mathematically
independent* hardness assumption (decoding random linear codes) as a hedge against
a future structured-lattice break of ML-KEM. The trade-off is substantially larger
keys/ciphertexts than ML-KEM.

## Comparison to RIINA's prior position

RIINA ships **ML-KEM-768 (FIPS 203)** byte-exact vs ACVP and a hybrid
X25519+ML-KEM KEM. No HQC. Correct for today.

## Decision (RIINA)

**Do NOT implement HQC yet; record it as the designated diversity hedge.** HQC's
value is *assumption diversity*, which only matters if/when lattice confidence
erodes or a customer mandates a code-based KEM. Implementing a from-scratch
constant-time HQC (the decoder is the side-channel surface) before a final FIPS +
ACVP is premature. **Revisit when** the FIPS draft + ACVP land, or a customer
requires it. The hybrid design below is the nearer-term diversity story.

---

# B4-03: Hybrid KEM standardization (X-Wing) — reconcile with RIINA's shipped hybrid

## Executive Summary

The IETF/CFRG line for hybrid post-quantum key establishment has converged on
**X-Wing** (`draft-connolly-cfrg-xwing-kem`): a concrete combiner of
**ML-KEM-768 + X25519** with a fixed KDF and domain separation, designed so the
shared secret is secure if *either* component holds. This is precisely the
construction class RIINA already ships.

## Comparison to RIINA's prior position

RIINA's `riina-core/crypto/hybrid.rs` ships an **X25519 + ML-KEM-768 hybrid KEM**
with its own combiner (`HYBRID-KEM-X25519-ML-KEM-768-v1` domain string). The
research backing for *why this specific combiner is sound* was thin (the corpus
audit flagged "the code ships a hybrid type with almost no research behind it").

## Decision (RIINA)

**Align the combiner with X-Wing's construction and document the rationale.**
Action items (tracked, not yet executed): (1) verify RIINA's combiner matches
X-Wing's KDF input ordering and domain separation (`concat(ss_ML-KEM, ss_X25519,
ct_X25519, pk_X25519, label)` through SHA3/SHAKE), adjusting if it diverges; (2) if
RIINA keeps a bespoke combiner, document the security argument explicitly (IND-CCA
of the combined KEM given either component) rather than relying on folklore; (3)
add X-Wing test vectors if/when the draft publishes them. This is the highest-value
*near-term* PQC item because it hardens code RIINA already ships and exposes.

---

# B4-04: SLAP & FLOP — the 2025 Apple M-series speculative attacks

## Executive Summary

In **January 2025**, researchers disclosed two related speculative-execution
attacks on Apple M-series (and some A-series) CPUs: **SLAP** (Speculation attacks
via Load Address Prediction — the **Load Address Predictor**, LAP) and **FLOP**
(speculation via the **Load Value Predictor**, LVP / "False Load Output
Predictions"). They are a sibling pair: the CPU speculatively predicts a load's
*address* (SLAP) or *value* (FLOP) and computes on it before validation, opening a
Spectre-class transient window that leaks across security boundaries (e.g. Safari
process isolation). They are distinct from the data-memory-dependent **prefetcher**
(GoFetch) already in the corpus.

## Comparison to RIINA's prior position

The corpus covered **FLOP** (6 files) and **GoFetch** but **not SLAP** (0 files) —
an asymmetry, since SLAP is the address-prediction half of the same disclosure.

## Decision (RIINA)

**Add SLAP to the transient-execution threat register alongside FLOP/GoFetch/
Downfall/Inception, with the same honest scope as the existing GoFetch entry**
(`04_SPECS/security/THREAT_MODEL.md` Open-Risks, REQ-32): RIINA's source-level
constant-time guarantee covers instruction-timing and secret-dependent branch/memory
channels; it does **NOT** defeat predictor-driven transient execution (SLAP/FLOP)
on affected microarchitectures. The mitigation is deploy-time (vendor microcode/OS
controls, disabling LAP/LVP where exposed, or not co-locating secrets with attacker
JS) — a hardware-software leakage-contract concern (Phase 7/9), not a source-level
fix. This is a *threat-model documentation* action, not a code change.

---

# B4-05: Silicon root-of-trust — Caliptra & OpenTitan

## Executive Summary

Two open-source silicon **root-of-trust** (RoT) projects are now the industry
reference points: **Caliptra** (OCP/CHIPS-Alliance; an open RoT IP block for
datacenter SoCs, backed by Google/AMD/Microsoft/NVIDIA — measured boot, attestation,
crypto offload) and **OpenTitan** (lowRISC; a discrete open RoT chip / IP). Both
provide hardware-anchored measured boot, key storage, and attestation that a
verified software stack ultimately depends on.

## Comparison to RIINA's prior position

The corpus had **0 files** on either (Domain S / hardware contracts, Domain AB
supply-chain, REQ-31 attestation reference these areas abstractly).

## Decision (RIINA)

**Record Caliptra/OpenTitan as the named hardware-RoT anchors for RIINA's
attestation and secure-boot story, scoped as out-of-language-boundary.** RIINA is a
language + verified stdlib; the RoT is the hardware base its supply-chain
attestation (REQ-31 SBOM, reproducible build) and threat model assume but do not
implement. Action: cite them in the threat model's trust-anchor assumptions and in
the REQ-31 attestation narrative as the hardware layer below RIINA's software
attestation. No code; an honest boundary statement that RIINA's guarantees are
relative to a trustworthy RoT.

---

## Summary of decisions (all research-level; none ship code in this batch)

| Item | Decision | Trigger to revisit |
|---|---|---|
| FIPS 206 / FN-DSA | Do not implement; record as future standard | Final FIPS + ACVP vectors |
| HQC | Do not implement; record as diversity hedge | Final FIPS + ACVP, or customer mandate |
| X-Wing hybrid KEM | **Align/justify RIINA's shipped combiner** (highest near-term value) | Now — hardens shipped code |
| SLAP | Add to transient-exec threat register (honest scope) | Threat-model doc update |
| Caliptra / OpenTitan | Name as hardware-RoT trust anchors (out-of-boundary) | Threat-model + REQ-31 narrative |

These feed REQ-37 (PARTIAL → research recorded; the X-Wing combiner alignment and
threat-model additions are the named follow-on actions) and the Part 6 currency
qualification.
