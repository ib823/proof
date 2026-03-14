# AI-01: Verified Process Isolation — Provably Confined Execution

**Domain:** AI — Verified Process Isolation
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Sandbox verification, process isolation proofs, capability confinement, compartmentalization, verified memory protection

---

## 1. Problem Statement

Process isolation is the fundamental security mechanism in modern operating systems: preventing one process from accessing another's memory, files, or resources. Yet isolation failures remain among the most devastating vulnerability classes. The Spectre attack demonstrated that speculative execution can bypass hardware isolation boundaries. Container escapes allow processes to break out of their sandboxes. Rowhammer attacks flip bits in adjacent memory rows, bypassing isolation at the physical level.

The challenge is providing mathematically rigorous isolation guarantees: proving that no execution path allows a confined process to access resources outside its sandbox. Traditional isolation mechanisms (page tables, address spaces, capabilities) are implemented in complex kernel code that is difficult to verify. RIINA integrates with verified microkernels (seL4) and capability architectures (CHERI) to provide proven isolation guarantees from the language level down to the hardware.

## 2. State of the Art

### 2.1 seL4: Verified Microkernel

Klein et al. verified the seL4 microkernel, proving functional correctness, information flow security, and integrity properties. seL4's capability-based access control provides the foundation for verified process isolation.

Klein, G., Elphinstone, K., Heiser, G., et al., "seL4: Formal Verification of an OS Kernel", *SOSP*, 2009.

### 2.2 CHERI Capabilities

Watson et al. developed CHERI, extending RISC ISAs with hardware capabilities that provide fine-grained memory protection and compartmentalization. CHERI capabilities are unforgeable, bounds-checked pointers that enforce spatial memory safety in hardware.

Watson, R. N. M., Woodruff, J., Neumann, P. G., et al., "CHERI: A Hybrid Capability-System Architecture for Scalable Software Compartmentalization", *IEEE S&P*, 2015.

### 2.3 Software Fault Isolation

Morrisett et al. formalized software fault isolation (SFI) using a type-theoretic approach, proving that sandboxed code cannot access memory outside its designated region. The approach provides isolation without hardware support.

Morrisett, G., Tan, G., Tassarotti, J., Tristan, J.-B., Gan, E., "RockSalt: Better, Faster, Stronger SFI for the x86", *PLDI*, 2012.

### 2.4 Original SFI

Wahbe et al. introduced software fault isolation, using inline reference monitors to confine untrusted modules within a single address space. The technique partitions the address space into segments and rewrites code to enforce segment boundaries.

Wahbe, R., Lucco, S., Anderson, T. E., Graham, S. L., "Efficient Software-Based Fault Isolation", *SOSP*, 1993.

### 2.5 Native Client

Sehr et al. developed Native Client (NaCl), a production SFI system for running untrusted native code in the Chrome browser. NaCl validates binaries against a restricted instruction set that prevents escape from the sandbox.

Sehr, D., Muth, R., Biffle, C., Khimenko, V., Pasko, E., Schimpf, K., Yee, B., Chen, B., "Adapting Software Fault Isolation to Contemporary CPU Architectures", *USENIX Security*, 2010.

### 2.6 Nested Kernel

Mao et al. developed the Nested Kernel architecture, which uses virtualization hardware to protect an inner kernel within the main kernel's address space. The nested kernel mediates all page table modifications, providing verified memory isolation.

Mao, Y., Chen, H., Zhou, D., Wang, X., Zeldovich, N., Kaashoek, M. F., "Software Fault Isolation with API Integrity and Multi-Principal Modules", *SOSP*, 2011.

### 2.7 Light-weight Contexts

Litton et al. developed light-weight contexts (lwC), providing in-process isolation through multiple virtual memory views within a single process. lwC enables efficient compartmentalization without the overhead of full process creation.

Litton, J., Vahldiek-Oberwagner, A., Elnikety, E., Garg, D., Bhattacharjee, B., Druschel, P., "Light-Weight Contexts: An OS Abstraction for Safety and Performance", *OSDI*, 2016.

### 2.8 SOAAP

Gudka et al. developed SOAAP (Security-Oriented Analysis of Application Programs), a tool for analyzing compartmentalization opportunities in applications. SOAAP identifies privilege separation boundaries and evaluates compartmentalization strategies.

Gudka, K., Watson, R. N. M., Anderson, J., Sherwin, D., Moore, S. W., Sherlock, P., "Exploring Compartmentalisation Hypotheses with SOAAP", *ASPLOS*, 2015.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Memory isolation | Capability confinement proof | Process cannot access memory outside its region |
| Capability monotonicity | Type system proof | Capabilities can only be restricted, never amplified |
| Sandbox escape prevention | Reachability analysis | No execution path crosses sandbox boundary |
| IPC mediation | Channel type proof | All cross-boundary communication through verified channels |
| Resource bounds | Capability-limited allocation | Process cannot exhaust system resources |
| Information flow | Noninterference proof | No information flows from sandbox to outside |

## 4. RIINA Integration Architecture

### 4.1 Verified Sandbox Types

```riina
// Capability-confined sandbox
fungsi laksana_dalam_kotak_pasir<T>(
    kod: fungsi() -> T,
    keupayaan: SetKeupayaan<Terhad>,
) -> Hasil<T, RalatKotakPasir>
    kesan KotakPasir<Terkurung>
{
    // Effect guarantees: execution confined to capability set
    biar persekitaran = cipta_persekitaran_terkurung(keupayaan);
    biar hasil = persekitaran.laksana(kod);
    pulang Ok(hasil);
}

// Cross-sandbox communication via typed channel
fungsi hantar_merentas_sempadan<T: Boleh_Siri>(
    saluran: Saluran<T, SerahHak>,
    mesej: T,
) -> Hasil<(), RalatSaluran>
    kesan IPC<Dimediasi>
{
    // All cross-boundary communication is mediated
    sahkan_dasar_ipc(saluran, mesej)?;
    saluran.hantar(mesej);
    pulang Ok(());
}
```

### 4.2 Coq Formalization

```coq
(* Memory isolation: sandboxed process confined to region *)
Theorem sandbox_confinement : forall process region addr,
  sandboxed process region ->
  accesses process addr ->
  in_region addr region.

(* Capability monotonicity: derived capabilities cannot exceed parent *)
Theorem cap_monotonicity : forall cap derived,
  derives cap derived ->
  permissions derived ⊆ permissions cap /\
  bounds derived ⊆ bounds cap.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Klein, G., et al., "seL4" (2009) | SOSP | Verified microkernel |
| Watson, R. N. M., et al., "CHERI" (2015) | IEEE S&P | Hardware capabilities |
| Morrisett, G., et al., "RockSalt" (2012) | PLDI | Verified SFI |
| Wahbe, R., et al., "SFI" (1993) | SOSP | Software fault isolation |
| Sehr, D., et al., "Native Client" (2010) | USENIX Security | Production SFI |
| Mao, Y., et al., "Nested Kernel" (2011) | SOSP | In-kernel isolation |
| Litton, J., et al., "lwC" (2016) | OSDI | Light-weight contexts |
| Gudka, K., et al., "SOAAP" (2015) | ASPLOS | Compartmentalization analysis |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Capability type system | 3-4 | High — seL4/CHERI methodology | Phase 1 |
| Memory region proofs | 3-4 | High — spatial reasoning | Phase 1 |
| SFI verification | 4-6 | Medium — binary analysis | Phase 2 |
| IPC mediation proof | 3-4 | Medium — channel types | Phase 2 |
| Cross-domain information flow | 4-6 | Medium — noninterference | Phase 3 |
| End-to-end isolation proof | 6-8 | Low-Medium — hardware-software | Phase 4 |

## 7. Scope Limitations

1. **Hardware trust.** Software isolation ultimately relies on correct hardware (MMU, capabilities). Hardware bugs (Spectre, Meltdown, Rowhammer) can bypass all software isolation.
2. **Side channels.** Isolated processes may still communicate through timing channels, cache behavior, and shared hardware resources.
3. **Performance overhead.** Strong isolation adds overhead: context switches, capability checks, IPC marshalling. Some applications cannot tolerate this cost.
4. **Shared state.** Modern applications share memory, files, and services. Complete isolation conflicts with the need for controlled sharing.
5. **Covert channels.** Even with proven noninterference, covert channels through shared hardware resources may leak information.
6. **Dynamic loading.** Dynamically loaded code (plugins, JIT compilation) complicates static isolation verification.

---

*"What is confined by proof cannot escape by any execution path."*
