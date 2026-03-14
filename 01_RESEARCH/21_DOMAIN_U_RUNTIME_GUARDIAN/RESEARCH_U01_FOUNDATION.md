# U-01: Runtime Guardian & Verified Micro-Hypervisor — Trust Nothing, Not Even the Silicon

**Domain:** U — Runtime Guardian
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Verified runtime monitor, CFI enforcement, N-modular redundancy, fault detection

---

## 1. Problem Statement

Formal proofs (Track A) verify that RIINA programs behave correctly assuming the hardware executes instructions faithfully. However, physics does not respect formal models: cosmic rays flip bits in RAM, power supply noise glitches CPU clocks, electromagnetic interference corrupts data, and fault injection attacks deliberately corrupt execution state. A single bit flip can change `is_admin = false` to `is_admin = true`, bypassing all type-system guarantees.

Beyond physical faults, runtime attacks such as Return-Oriented Programming (ROP) and Jump-Oriented Programming (JOP) exploit memory corruption to hijack control flow, violating the assumptions of static verification. Even in the absence of memory corruption bugs in RIINA code, the runtime system, OS kernel, and hardware interfaces present attack surfaces.

Domain U addresses this gap by introducing RIINA-SENTINEL: a formally verified micro-hypervisor and runtime monitor that enforces safety invariants at execution time, detecting and responding to physical faults, control flow violations, and integrity breaches that cannot be prevented by static analysis alone.

## 2. State of the Art

### 2.1 seL4: The Verified Microkernel

seL4 is the world's first operating system kernel with a machine-checked proof of functional correctness. Developed at NICTA (now Data61/CSIRO), seL4's Isabelle/HOL proof establishes that the kernel's C implementation correctly implements its abstract specification, and that the binary produced by the compiler matches the C code. The proof covers approximately 10,000 lines of C code and 200,000 lines of proof. seL4 also has proven integrity and confidentiality enforcement guarantees.

Klein, G., Elphinstone, K., Heiser, G., et al., "seL4: Formal Verification of an OS Kernel", *SOSP*, 2009.

Klein, G., Andronick, J., Elphinstone, K., et al., "Comprehensive Formal Verification of an OS Microkernel", *ACM Transactions on Computer Systems*, 32(1):2, 2014.

### 2.2 CertiKOS: Certified Kit Operating System

CertiKOS, developed by Zhong Shao's group at Yale, is a verified concurrent OS kernel. Unlike seL4 (which was verified for a single-core configuration), CertiKOS proves correctness of concurrent kernel operations including interrupt handling, context switching, and multi-core scheduling. CertiKOS uses a layered verification approach with certified abstraction layers, enabling modular proofs that compose.

Gu, R., Shao, Z., Chen, H., Wu, X., Kim, J., Sjöberg, V., Costanzo, D., "CertiKOS: An Extensible Architecture for Building Certified Concurrent OS Kernels", *OSDI*, 2016.

### 2.3 Control Flow Integrity (CFI)

Control Flow Integrity, introduced by Abadi et al., ensures that program execution follows only the valid control flow graph (CFG) determined at compile time. CFI prevents control flow hijacking attacks (ROP, JOP) by inserting checks at indirect branches and returns. Hardware-assisted CFI (Intel CET, ARM BTI/PAC) provides lower-overhead enforcement than software-only approaches.

Abadi, M., Budiu, M., Erlingsson, U., Ligatti, J., "Control-Flow Integrity: Principles, Implementations, and Applications", *CCS*, 2005.

Burow, N., Carr, S. A., Nash, J., Larsen, P., Franz, M., Brunthaler, S., Payer, M., "Control-Flow Integrity: Precision, Security, and Performance", *ACM Computing Surveys*, 50(1):16, 2017.

### 2.4 XMHF: Extensible Micro-Hypervisor Framework

XMHF is a micro-hypervisor designed for verifiable security properties. Unlike full hypervisors (Xen, KVM), XMHF provides a minimal trusted computing base for security-critical functions: memory isolation, DMA protection, and secure boot. XMHF has been formally verified for memory integrity and correct DMA protection.

Vasudevan, A., Chaki, S., Jia, L., McCune, J., Newsome, J., Datta, A., "Design, Implementation, and Verification of an eXtensible and Modular Hypervisor Framework", *IEEE S&P*, 2013.

### 2.5 N-Modular Redundancy and Software Fault Tolerance

N-modular redundancy (NMR) runs N copies of a computation and compares outputs, detecting faults that affect fewer than N/2 copies. In hardware, triple modular redundancy (TMR) is standard in aerospace and nuclear systems. Software NMR runs diverse implementations (compiled with different compilers, using different algorithms) to detect both hardware faults and software bugs.

Avizienis, A., "The N-Version Approach to Fault-Tolerant Software", *IEEE Transactions on Software Engineering*, SE-11(12):1491-1501, 1985.

### 2.6 ARM TrustZone and TEEs

ARM TrustZone provides hardware isolation between a "Normal World" and a "Secure World," enabling Trusted Execution Environments (TEEs). The secure world runs a trusted OS and security-critical applications, isolated from the normal world by hardware. Intel SGX provides similar enclave-based isolation. These mechanisms can host a runtime monitor that is isolated from and cannot be compromised by the monitored application.

### 2.7 Runtime Verification and Monitoring

Runtime verification is a lightweight formal method that checks whether a system's execution satisfies a given specification. Unlike testing (which checks specific inputs) or model checking (which explores all states), runtime verification observes actual execution and raises alarms when violations occur. Frameworks like MOP (Monitoring-Oriented Programming) and LOLA provide specification languages for runtime monitors.

Leucker, M., Schallhart, C., "A Brief Account of Runtime Verification", *Journal of Logic and Algebraic Programming*, 78(5):293-303, 2009.

### 2.8 Watchdog Timers and Hardware Safety Monitors

Hardware watchdog timers provide a last line of defense: if software fails to "pet the watchdog" within a specified interval, the hardware resets the system. This mechanism detects infinite loops, deadlocks, and other liveness failures. Safety-critical systems (IEC 61508, DO-178C) require independent watchdog monitoring of all software functions.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Control flow integrity | CFG enforcement at runtime | Compiler emits CFG; SENTINEL verifies indirect branches |
| Memory integrity | Checksumming / ECC verification | Critical data structures verified at synchronization points |
| Fault detection | N-modular redundancy | Compiler generates diverse variants; SENTINEL compares states |
| Key zeroization | Panic protocol verification | SENTINEL wipes cryptographic keys on any invariant violation |
| Isolation from application | Hypervisor separation proof | SENTINEL runs in higher privilege level; application cannot access |
| Liveness | Watchdog timer | Non-maskable interrupt verifies SENTINEL integrity periodically |
| Audit trail integrity | Append-only log verification | Violations logged to write-once storage |

## 4. RIINA Integration Architecture

### 4.1 SENTINEL Architecture

```
┌─────────────────────────────────────────┐
│           RIINA Application              │
│     (Runs in unprivileged mode)         │
├─────────────────────────────────────────┤
│     RIINA-SENTINEL Monitor               │
│  ┌──────────┬──────────┬──────────┐     │
│  │  CFI     │  Memory  │  State   │     │
│  │  Check   │  Verify  │  Compare │     │
│  └──────────┴──────────┴──────────┘     │
├─────────────────────────────────────────┤
│     seL4 Verified Microkernel            │
├─────────────────────────────────────────┤
│     Hardware (+ Watchdog Timer)          │
└─────────────────────────────────────────┘
```

### 4.2 Panic Protocol

```riina
// SENTINEL panic protocol — triggered on any invariant violation
fungsi panik_protokol() kesan PanikSistem {
    // 1. Zeroize all cryptographic keys
    hapus_kunci_semua();
    // 2. Halt all application threads
    henti_semua_benang();
    // 3. Log violation to write-once media
    log_pelanggaran(jenis_pelanggaran, masa_sekarang());
    // 4. Assert hardware panic pin (cuts power / triggers reset)
    tekan_butang_panik();
}
```

### 4.3 Coq Formalization

```coq
(* SENTINEL reference monitor property *)
Theorem sentinel_complete_mediation : forall app_state action,
  app_performs app_state action ->
  sentinel_checked action = true.

(* Fault detection via NMR *)
Theorem nmr_fault_detection : forall v1 v2 input,
  compile_variant1 source input = v1 ->
  compile_variant2 source input = v2 ->
  v1 <> v2 ->
  fault_detected v1 v2.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Klein, G., et al., "seL4: Formal Verification of an OS Kernel" (2009) | SOSP | First verified OS kernel |
| Klein, G., et al., "Comprehensive Formal Verification of an OS Microkernel" (2014) | ACM TOCS | Extended seL4 proofs including integrity/confidentiality |
| Gu, R., et al., "CertiKOS" (2016) | OSDI | Verified concurrent OS kernel |
| Abadi, M., et al., "Control-Flow Integrity" (2005) | CCS | Foundational CFI framework |
| Burow, N., et al., "Control-Flow Integrity: Precision, Security, and Performance" (2017) | ACM Computing Surveys | Comprehensive CFI survey |
| Vasudevan, A., et al., "XMHF" (2013) | IEEE S&P | Verified micro-hypervisor |
| Avizienis, A., "The N-Version Approach to Fault-Tolerant Software" (1985) | IEEE TSE | N-modular redundancy methodology |
| Leucker, M., Schallhart, C., "A Brief Account of Runtime Verification" (2009) | J. Logic and Algebraic Programming | Runtime verification survey |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| CFI enforcement on seL4 | 4-6 | High — seL4 proofs exist | Phase 1 |
| Memory integrity checker | 3-4 | High — checksum-based | Phase 1 |
| NMR compiler support | 6-8 | Medium — requires diverse code generation | Phase 2 |
| Panic protocol verification | 2-3 | High — small state machine | Phase 2 |
| seL4 integration | 6-9 | Medium — requires seL4 expertise | Phase 3 |
| Watchdog verification | 2-3 | High — simple hardware interface | Phase 3 |
| ARM TrustZone integration | 4-6 | Medium — platform-specific | Phase 4 |
| Full end-to-end SENTINEL proof | 8-12 | Low-Medium — composition of multiple proofs | Phase 5 |

## 7. Scope Limitations

1. **Performance overhead.** Runtime monitoring adds overhead to every operation. CFI checks at every indirect branch add 5-15% overhead; NMR doubles or triples computation cost. Selective monitoring (only critical functions) trades security for performance.

2. **seL4 limitations.** seL4's functional correctness proof assumes correct hardware behavior and covers only single-core configurations. Multi-core seL4 proofs are still in progress. RIINA-SENTINEL inherits these limitations.

3. **NMR does not prevent faults.** NMR detects faults after they occur and halts execution, but does not prevent data loss or corruption that happened before detection. For recovery (not just detection), additional mechanisms like checkpointing are needed.

4. **Compiler diversity.** NMR requires diverse implementations to be effective. If both variants are compiled by the same compiler, a compiler bug could produce identical wrong behavior in both. True diversity requires different compilers or different compilation paths.

5. **Physical attacks beyond bit flips.** SENTINEL can detect random bit flips via NMR and checksums, but sophisticated fault injection attacks (laser, EM) can target specific bits with precision. Defending against targeted physical attacks requires hardware countermeasures beyond software monitoring.

6. **No verified RISC-V seL4 port.** seL4's verification targets ARM and x86. A verified RISC-V port is in development but not yet complete, limiting RIINA's primary hardware target.

---

*"Trust nothing. Not even the silicon. Not even the atoms."*
