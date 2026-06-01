# RIINA Research Refresh — 2026 H1, Batch 3

## Document Control

| Property | Value |
|----------|-------|
| Document ID | RESEARCH-REFRESH-2026H1-B3 |
| Version | 1.0.0 |
| Date | 2026-06-01 |
| Scope | Hardware capabilities & leakage contracts (CHERI), mobile-OS memory-safety hardware, resilient/anti-jam mesh comms |
| Method | Web-sourced survey (cited) → comparison → decision, per the 01_RESEARCH house format |
| Status | Complete (Batch 3 — annual-refresh tier; closes the 2026 H1 broad refresh) |
| Augments | Domain D (hardware/capability), Domain S (hardware contracts), the mobile_os domain (Phase 9), and the networking (GA-HV) tracks |

> **Why this exists.** Closes the 2026 H1 refresh with the "annual-refresh tier"
> hardware/OS/comms domains. The headline finding ties back to Batch 1: **CHERI is
> not a silver bullet for transient-execution leakage**, and **hardware-software
> leakage contracts** are the formal abstraction RIINA should adopt to make its
> constant-time / side-channel claims precise at the ISA level.

---

# B3-01: CHERI Capabilities & Hardware-Software Leakage Contracts

## Executive Summary

CHERI (Capability Hardware Enhanced RISC Instructions) reached an industrial
inflection in 2024–2025:

- **Arm Morello** — 128-bit CHERI capabilities on a quad-core 2.5 GHz ARMv8.2
  Neoverse N1; UK Digital Security by Design (DSbD) evaluation platform.
- **CHERI Alliance** formally launched **2024** (FreeBSD Foundation, Capabilities
  Limited, SCI Semiconductor, Codasip, lowRISC, Cambridge).
- **CHERIoT** (Microsoft's open-source embedded CHERI) → SCI Semiconductor's
  **ICENI** microcontrollers for automotive / industrial / defence / aerospace.

**Critical nuance (ties to Batch 1):** CHERI provides *spatial/temporal memory
safety and compartmentalization*, but **CHERI remains vulnerable to side-channel
leakage from speculative execution across compartment boundaries** (Cambridge:
"Safe Speculation for CHERI"; "Toward transient-execution attack mitigations on
CHERI"). CHERI does **not** by itself defeat Spectre/Downfall/GoFetch-class leaks.

The emerging formalism that *does* capture this is **hardware-software leakage
contracts** (Guarnieri et al., S&P 2021; synthesis for RISC-V open cores,
arXiv 2401.09383): ISA-level contracts that associate leakage traces with
executions, giving software a precise statement of what the hardware may leak.

## Comparison to RIINA's position

RIINA has a hardware-contract domain (**Domain S**) and a **Phase 9 CHERI RISC-V
compilation target**. Two corrections this refresh forces:

1. RIINA must **not** treat "compile to CHERI" as closing the side-channel /
   constant-time gap — CHERI is memory-safety + compartmentalization, *orthogonal*
   to the transient-execution leakage Batch 1 flagged (GoFetch/Downfall).
2. RIINA's CT and side-channel modeling currently lacks an ISA-level leakage model;
   **hardware-software leakage contracts are the right formal target.**

## Decision

- **Adopt "hardware-software leakage contracts" as the formal vocabulary** for
  RIINA's constant-time / side-channel guarantees in Domain S (and the Gate-B CT
  criterion). The CT guarantee should be stated *relative to a named leakage
  contract*, making explicit which microarchitectural channels are in/out of scope
  (closing the open end of the Batch-1 GoFetch caveat).
- **Keep the Phase-9 CHERI target**, but document it as *memory-safety +
  compartmentalization*, **not** a side-channel fix; pair it with the leakage-
  contract model and a software-managed compartment-ID mitigation for cross-
  compartment speculation.
- Track CHERI Alliance / Morello / CHERIoT-ICENI as the adoption baseline; annual
  re-check.

---

# B3-02: Mobile-OS Memory-Safety Hardware (MTE / MIE)

## Executive Summary

2025 was the year hardware memory tagging shipped at consumer scale:

| Platform | Tech | Status (late 2025) |
|----------|------|--------------------|
| Android (Pixel 8/9, Tensor G3/G4) | **ARM MTE** | GrapheneOS: production since Oct 2023 (kernel + base OS by default); stock Android 16: opt-in via Advanced Protection only |
| Apple (A19 / iPhone 17, Sept 2025) | **MIE** (Apple's MTE) | Enabled in the **kernel + 70+ userland processes** by default |
| Android 16 (2025-06-10) | Advanced Protection Mode | USB-data lock, 2G disable, sideload block, 72h auto-reboot |
| iOS | Lockdown Mode, PPL/SPTM, SEP | kernel lockdown; reboot-time signature checks |

The trusted base shifted: Android **pKVM** (Protected KVM) and iOS **SPTM/PPL**
(Secure Page Table Monitor / Page Protection Layer) are now the high-value targets.

## Comparison to RIINA's position

RIINA has a **mobile_os domain** (`domains/mobile_os/LocationServices.v`, etc.) and
a **Phase 9 "Real Android/iOS backends"** task. RIINA's memory safety is
**type-system-enforced at compile time** — so MTE/MIE is *complementary
defense-in-depth*, not a substitute, and not a competitor.

## Decision

- When RIINA targets mobile, **target MTE/MIE-capable hardware** and document the
  memory-tagging guarantee as **complementary** to RIINA's compile-time memory
  safety (belt-and-suspenders), never as the primary mechanism.
- Treat **pKVM (Android)** and **SPTM/PPL + SEP (iOS)** as the documented trusted
  computing base for any mobile backend — the RIINA TCB on mobile *includes* these.
- No claim change today: RIINA has no shipping mobile backend; this is backlog
  guidance for Phase 9.

---

# B3-03: Resilient / Anti-Jam Mesh Communications

## Executive Summary

The 2025 reference points for contested-environment comms:

- **Silvus StreamCaster NEXUS** (Oct 2025) + **Spectrum Dominance 2.0** — layered
  **LPI/LPD** (Low Probability of Intercept/Detection) + **Anti-Jam (AJ)** EW
  resiliency in a tactical MANET.
- **HopSync** — *stateless* frequency hopping that **eliminates synchronization
  broadcasts and fixed beacons**, drastically cutting the network's RF footprint
  (a key LPI/LPD advance).
- **Blu Wireless Phantom** — mmWave anti-jam mesh with IP networking on the move.

## Comparison to RIINA's position

This sits far from RIINA's core: RIINA is a language/verification stack, not a radio
or PHY. The relevance is only to the **networking (GA-HV) tracks** and **JALINAN**
distributed computing *if* RIINA ever targets tactical/defence comms applications.

## Decision

- **Out of core language scope.** RIINA does not build PHY/RF; it would *host*
  applications atop such links.
- If a defence/tactical application domain is ever pursued, record the reference
  model: **layered LPI/LPD + stateless frequency hopping (HopSync-style, no fixed
  beacons) + anti-jam mesh**, treated as **application-domain requirements**, not
  language features. JALINAN's actor/session model would run *over* such a link, not
  implement it.
- Lowest-priority / annual-refresh tier; no backlog item created beyond this note.

---

# Integration Notes

1. **Domain S (Hardware Contracts) + Gate-B CT criterion:** adopt **hardware-
   software leakage contracts** as the formal model; state RIINA's constant-time
   guarantee relative to a named contract (closes the Batch-1 GoFetch open end).
2. **Domain D / Phase 9 (CHERI):** CHERI = memory-safety + compartmentalization,
   **not** a side-channel fix; keep the target, pair it with the leakage-contract
   model + compartment-ID mitigation for cross-compartment speculation.
3. **mobile_os domain / Phase 9:** target MTE/MIE hardware as complementary defense;
   pKVM and SPTM/PPL/SEP are the documented mobile TCB.
4. **Networking (GA-HV) / JALINAN:** anti-jam mesh is an application-domain concern,
   out of core language scope.

## Sources

- CHERI/Morello/Alliance: Cambridge CTSRD CHERI-Morello pages; CHERI Alliance
  (cheri-alliance.org); "Safe Speculation for CHERI"
  (<https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/202411-iccd-cap-contracts.pdf>);
  "Toward transient-execution attack mitigations on CHERI" (UCAM-CL-TR-1001).
- Leakage contracts: Guarnieri et al., "Hardware-Software Contracts for Secure
  Speculation" (S&P 2021); "Synthesizing Hardware-Software Leakage Contracts for
  RISC-V" (arXiv 2401.09383).
- Mobile MTE/MIE: Android Source ARM-MTE docs; Apple Memory Integrity Enforcement
  (privacyguides.org, MacRumors, 2025-09); Android 16 Advanced Protection.
- Mesh/anti-jam: Silvus StreamCaster NEXUS / Spectrum Dominance (Motorola Solutions,
  2025-10); HopSync (beechat.network, 2025-07); Blu Wireless Phantom.
