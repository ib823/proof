# RIINA Research Refresh — 2026 H1, Batch 1

## Document Control

| Property | Value |
|----------|-------|
| Document ID | RESEARCH-REFRESH-2026H1-B1 |
| Version | 1.0.0 |
| Date | 2026-06-01 |
| Scope | Time-sensitive refresh of three fast-moving domains where RIINA's prior research had aged |
| Method | Web-sourced survey (cited) → comparison → decision, per the 01_RESEARCH house format |
| Status | Complete (Batch 1 of the broad refresh; Batches 2+ in follow-up sessions) |
| Supersedes | Nothing — augments Domain D (hardware/capability), Domain E (formal verification), Domain G (crypto/side-channel) with 2024–2026 developments |

> **Why this exists.** A long hardening pass found that several technology and
> standards references in the codebase had aged relative to the live state of the
> field. This dossier refreshes the three highest-value ones: (1) neural-network
> verification SOTA, (2) post-2019 speculative-execution attacks, and (3) the
> post-quantum FIPS roll-out. Each section ends with a concrete decision for RIINA.

---

# B1-01: Neural-Network / AI-Model Verification (VNN-COMP 2025)

## Executive Summary

Formal verification of neural networks remains dominated by a single toolchain.
**α,β-CROWN** (alpha-beta-CROWN) is the winner of **VNN-COMP 2025**, the 6th
International Verification of Neural Networks Competition — and is now the
five-peat winner (VNN-COMP 2021, 2022, 2023, 2024, 2025), ranked top-1 across all
scored benchmarks. The tool is a GPU-accelerated bound-propagation +
branch-and-bound verifier led by Prof. Huan Zhang's group (UIUC).

## Survey

- **Still SOTA:** α,β-CROWN is unambiguously the reference complete verifier for
  ReLU and increasingly non-linear (tanh, sigmoid) networks. The 2025 cycle added
  Jacobian/continuous-time support enabling **Lyapunov-stability** verification of
  learned controllers — a meaningful expansion beyond robustness ε-balls.
- **Incremental research front:** "Clip-and-Verify" (linear constraint-driven
  domain clipping, arXiv 2512.11087) is now folded into α,β-CROWN to accelerate the
  branch-and-bound search. The competitive frontier is acceleration and nonlinear
  operator coverage, not a new winning architecture.
- **Methodology:** the field is bound-propagation (CROWN-family) + MILP/BaB; SMT
  and pure MILP verifiers (Marabou, MIPVerify) remain relevant baselines but do not
  top the benchmarks.

## Comparison to RIINA's prior position

RIINA has no neural-network verification lane and does not claim one — correct.
RIINA's relevance is indirect: the "verified ML pipeline / LLM-for-RIINA" ambitions
in Phase 10 (REQ-23 academic track, Bijak learning platform) would *consume* model
verification, not produce it.

## Decision

- **Do NOT build an in-house NN verifier.** If RIINA ever needs model-level
  guarantees (e.g., for the Phase-10 LLM tooling or a CAHAYA ML widget), integrate
  **α,β-CROWN** as an external oracle behind a `kesan` effect boundary rather than
  re-implementing bound propagation.
- Record α,β-CROWN / VNN-COMP 2025 as the tracked external SOTA in Domain E so the
  reference does not silently rot again. Re-check annually (VNN-COMP runs yearly).

---

# B1-02: Speculative / Transient-Execution Attacks Since 2019

## Executive Summary

The Spectre/Meltdown (2018) family did **not** close; a steady cadence of new
transient-execution attacks has continued through 2024, several of which are
**microarchitectural and unpatchable in silicon** (mitigations are microcode +
compiler + performance cost). The most consequential post-2019 entries:

| Attack | Year | Target | Mechanism |
|--------|------|--------|-----------|
| **Downfall** (GDS, CVE-2022-40982) | 2023 | Intel Skylake→Rocket Lake | `gather` instruction leaks the internal vector register file via Gather Data Sampling / Gather Value Injection |
| **Inception** (CVE-2023-20569) | 2023 | AMD Zen 3/4 | Phantom speculation + Training-in-Transient-Execution overflows the return-stack buffer (Spectre-V2/Retbleed lineage) |
| **Collide+Power** | 2023 | Cross-vendor | Power side-channel over shared microarchitectural state |
| **GoFetch** | 2024 | Apple M1/M2/M3 | Data-Memory-dependent Prefetcher (DMP) defeats constant-time crypto by prefetching pointer-shaped secrets |

## Survey

- **Constant-time is necessary but not sufficient on DMP hardware.** GoFetch is the
  key 2024 lesson: a *correct* constant-time implementation still leaks because the
  **prefetcher** acts on data that looks like a pointer. The defense is either
  hardware DMP-disable bits (Apple's DIT / data-independent timing flag) or
  algorithm-level blinding — neither is automatic.
- **No-fix-in-silicon is the norm.** Downfall/Inception/GoFetch all require
  microcode/OS/compiler mitigations with measurable performance cost on crypto.
- The canonical living reference is the Wikipedia "Transient execution CPU
  vulnerability" page, which now tracks ~a dozen named families.

## Comparison to RIINA's prior position

RIINA's `masa_tetap` (constant-time) blocks and the Coq side-channel domain (G)
model **timing** channels and secret-dependent branches. They do **not** model the
**DMP/prefetcher** class GoFetch exploits — a real gap between RIINA's
"constant-time ⇒ no leak" claim and 2024 hardware reality.

## Decision

- **Scope the constant-time claim honestly.** RIINA's CT guarantee should state it
  covers the *instruction-timing and branch* channels it models, and explicitly
  **excludes data-memory-dependent prefetcher (DMP) leakage** (GoFetch-class) unless
  the target sets the hardware data-independent-timing flag. Add this caveat to the
  CT documentation and the Gate-B constant-time exit criterion.
- **Future hardening (Domain D/G backlog):** when CHERI / hardware-contract work
  lands (Phase 7/9), require the DIT/DMP-off capability as part of the CT codegen
  contract on Apple-silicon-class targets.
- Re-check this list annually; treat any new transient-execution family touching
  prefetchers or constant-time crypto as a CT-scope event.

---

# B1-03: Post-Quantum Cryptography — FIPS Roll-out Status

## Executive Summary

NIST finalized the first three PQC standards on **2024-08-13**, and the program has
advanced materially since:

| Standard | Algorithm (was) | Role | Status (2026-06) |
|----------|-----------------|------|------------------|
| **FIPS 203** | ML-KEM (CRYSTALS-Kyber) | Primary KEM / general encryption | **Final** (2024-08) |
| **FIPS 204** | ML-DSA (CRYSTALS-Dilithium) | Primary digital signature | **Final** (2024-08) |
| **FIPS 205** | SLH-DSA (SPHINCS+) | Hash-based backup signature | **Final** (2024-08) |
| **FIPS 206** | FN-DSA (FALCON) | Compact signature (≈666 B for FN-DSA-512 vs ML-DSA's multi-KB) | **Draft submitted for approval 2025-08-28**; final expected late 2026 / early 2027 |
| **HQC** | Hamming Quasi-Cyclic | Second KEM, different math, ML-KEM backup | Selected 2025-03-11; **draft expected early 2026** |

## Survey

- The official names **ML-KEM / ML-DSA / SLH-DSA** are now the correct, final
  designations — *not* Kyber/Dilithium/SPHINCS+ (those are the legacy submission
  names).
- US government begins **preferring** PQC in sensitive systems in 2025; migration
  pressure (and "harvest-now-decrypt-later" risk) is the active driver.
- FN-DSA (FIPS 206) matters specifically where **signature size** is constrained
  (firmware, certificates, blockchain) — directly relevant to RIINA's blockchain /
  Syariah-finance domain.

## Comparison to RIINA's prior position

RIINA's docs were already corrected this cycle to use the final FIPS names
(ML-KEM/ML-DSA/SLH-DSA) — good. What was missing: **FIPS 206 (FN-DSA)** and **HQC**
as forthcoming standards, and the deployment-preference timeline.

## Decision

- **Crypto naming: no change needed** — ML-KEM/ML-DSA/SLH-DSA are current.
- **Add FN-DSA (FIPS 206) to the crypto backlog**, flagged for the blockchain /
  signature-size-sensitive paths, with an explicit "draft, not final" status so no
  doc over-claims a finalized FN-DSA before late-2026/2027.
- **Track HQC** as the second standardized KEM (algorithmic diversity / ML-KEM
  fallback). Neither FN-DSA nor HQC should be *claimed as implemented* in RIINA —
  they are standards-tracking entries only.
- The `riina-core` crypto lane stays "no external audit" (REQ-28) and **generated**
  in the F* lane (3 trivial smoke lemmas) — this dossier does not change those honest
  claim levels.

---

# Integration Notes

1. **Domain E (Formal Verification):** external NN-verification SOTA = α,β-CROWN
   (VNN-COMP 2025). Integrate-don't-rebuild.
2. **Domain D/G (Hardware / Side-channel):** constant-time claim must exclude
   DMP/GoFetch-class prefetcher leakage; DIT/DMP-off becomes a CHERI-era CT codegen
   requirement.
3. **Domain G (Crypto):** FIPS 203/204/205 final and correctly named; add FIPS 206
   (FN-DSA, draft) + HQC (draft) as standards-tracking backlog, never as
   implemented.

## Sources

- α,β-CROWN / VNN-COMP 2025: <https://github.com/Verified-Intelligence/alpha-beta-CROWN>;
  VNN-COMP 2025 summary (ResearchGate 398980425); Clip-and-Verify (arXiv 2512.11087).
- Transient execution: <https://en.wikipedia.org/wiki/Transient_execution_CPU_vulnerability>;
  Downfall/Inception (The Hacker News, 2023-08); GoFetch (The Hacker News, 2024-03;
  BleepingComputer).
- PQC FIPS: NIST CSRC FIPS 203 final (<https://csrc.nist.gov/pubs/fips/203/final>);
  NIST news 2024-08-13; DigiCert "FN-DSA (FIPS 206) Nears Draft Approval" (2025);
  NIST PQC standardization project page (HQC selection 2025-03-11).
