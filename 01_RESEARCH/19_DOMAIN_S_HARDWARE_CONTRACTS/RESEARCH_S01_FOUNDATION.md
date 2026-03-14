# S-01: Hardware Contracts & Microarchitectural Formalism — Modeling the Lying Silicon

**Domain:** S — Hardware Contracts
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Augmented ISA model, constant-time type enforcement, speculative execution safety proofs

---

## 1. Problem Statement

Traditional formal methods verify software against an Instruction Set Architecture (ISA) model that describes what each instruction does functionally (e.g., "ADD RAX, RBX stores the sum in RAX"). However, modern CPUs do not simply execute the ISA — they transcode instructions into micro-operations, execute them speculatively and out-of-order, and optimize based on branch prediction, cache state, and other microarchitectural features.

The Spectre (Kocher et al., 2019) and Meltdown (Lipp et al., 2018) attacks demonstrated that this abstraction gap is a security catastrophe: software proven correct against the ISA model is insecure on actual hardware because the ISA abstracts away the mechanisms (timing, speculation, cache state) through which secrets leak. A program verified to never read unauthorized memory can still leak that memory's contents through cache timing during speculative execution.

RIINA cannot verify security properties against a model that ignores these physical realities. Domain S defines an augmented ISA model — "Hardware-Software Contracts" — that explicitly accounts for microarchitectural state, speculative execution, and observable side channels, enabling RIINA to verify constant-time execution and speculative safety.

## 2. State of the Art

### 2.1 Spectre and Microarchitectural Attacks

The Spectre family of attacks exploits speculative execution to leak secrets through cache timing side channels. Kocher et al. demonstrated that branch misprediction can cause the CPU to execute instructions on a speculative path that accesses secret-dependent memory addresses, leaving observable traces in the cache even after the speculative state is rolled back. Subsequent variants (Spectre v2, Spectre-RSB, SpectreRSB, LVI, ret2spec) have shown that the attack surface is far broader than initially understood.

Kocher, P., Horn, J., Fogh, A., et al., "Spectre Attacks: Exploiting Speculative Execution", *IEEE S&P*, 2019.

Lipp, M., Schwarz, M., Gruss, D., et al., "Meltdown: Reading Kernel Memory from User Space", *USENIX Security*, 2018.

### 2.2 Hardware-Software Contracts

Guarnieri et al. introduced the concept of "hardware-software contracts" as a principled way to reason about security in the presence of microarchitectural features. A contract specifies what observations an attacker can make from program execution — for instance, whether they can observe cache access patterns or branch directions. Programs are then verified secure under a specific contract, and the hardware is responsible for implementing a contract that matches its actual leakage behavior.

This framework enables compositional reasoning: software developers write code that is secure under a declared contract, and hardware vendors certify that their chips implement that contract. Different contracts capture different threat models (e.g., cache-attacker, speculation-attacker).

Guarnieri, M., Koepf, B., Morales, J. F., Reineke, J., Sanchez, A., "Hardware-Software Contracts for Secure Speculation", *IEEE S&P*, 2021.

### 2.3 Spectector: Automated Speculative Execution Analysis

Spectector is a tool for automatically analyzing programs for speculative execution leaks. It formalizes a semantics for speculative execution and checks whether programs satisfy "speculative non-interference" — the property that speculative execution does not leak more information than sequential execution. Spectector works at the assembly level and can verify constant-time behavior under speculation.

Guarnieri, M., Koepf, B., Morales, J. F., Reineke, J., Sanchez, A., "Spectector: Principled Detection of Speculative Information Flows", *IEEE S&P*, 2020.

### 2.4 Sail: Machine-Readable ISA Specifications

The Sail language, developed by the REMS project at Cambridge, provides machine-readable formal specifications of instruction set architectures. Sail models exist for ARMv8-A, RISC-V, MIPS, and CHERI-MIPS. These models are executable (serving as reference simulators) and exportable to theorem provers (Coq, Isabelle, HOL4), enabling formal reasoning about machine code behavior.

Armstrong, A., Bauereiss, T., Campbell, B., et al., "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS", *POPL*, 2019.

### 2.5 Constant-Time Programming Verification

Constant-time programming is a discipline where the execution time of cryptographic code does not depend on secret inputs. Barthe et al. formalized this as a 2-safety hyperproperty and developed verification tools (ct-verif, ct-wasm) that can automatically check assembly code for constant-time violations. The approach models the program's trace of memory accesses and branch directions, verifying that these are independent of secret inputs.

Barthe, G., Grégoire, B., Laporte, V., "Secure Compilation of Side-Channel Countermeasures: The Case of Cryptographic 'Constant-Time'", *CSF*, 2018.

Almeida, J. B., Barbosa, M., Barthe, G., Dupressoir, F., Emmi, M., "Verifying Constant-Time Implementations", *USENIX Security*, 2016.

### 2.6 RISC-V Formal Specification

The RISC-V ISA has a formal specification maintained by the RISC-V Foundation, with models written in Sail and other formal languages. The openness of RISC-V (compared to x86 and ARM) makes it the ideal target for formal verification of hardware-software interaction. Multiple formal models exist, including the Sail RISC-V model, the RISCV-ISA-Formal model, and the spike reference simulator.

Nienhuis, K., Memarian, K., Sheridan, C., et al., "An Operational Semantics and Type Safety for RISC-V", *PLDI*, 2019 (RISC-V formal semantics work within the REMS project).

### 2.7 Cache Side-Channel Formal Models

Formal models of cache behavior have been developed to reason about timing side channels. These models capture set-associative cache behavior with LRU replacement and can be used to prove that a program's cache access pattern is independent of secret data. Tools like CacheAudit provide quantitative bounds on information leakage through cache side channels.

Doychev, G., Koepf, B., Mauborgne, L., Reineke, J., "CacheAudit: A Tool for the Static Analysis of Cache Side Channels", *ACM TISSEC*, 17(2), 2015.

### 2.8 Rowhammer and Physical Fault Attacks

Rowhammer attacks exploit DRAM physics: repeatedly accessing a row of memory can cause bit flips in adjacent rows. Formal analysis of Rowhammer requires modeling physical memory layout and access patterns. Gruss et al. demonstrated that Rowhammer can be exploited from JavaScript and that software-only mitigations are insufficient without hardware support.

Kim, Y., Daly, R., Kim, J., et al., "Flipping Bits in Memory Without Accessing Them: An Experimental Study of DRAM Disturbance Errors", *ISCA*, 2014.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Constant-time execution | Leakage model comparison (2-safety) | Effect annotation `kesan MasaTetap` (constant-time effect) |
| Speculative non-interference | Speculative semantics modeling | Compiler inserts fences; validator checks speculation paths |
| Cache-timing independence | Cache state abstraction | Type system tracks secret-dependent memory accesses |
| Branch prediction safety | Speculative CFG analysis | Validator rejects secret-dependent branches in crypto code |
| Rowhammer resilience | Physical row adjacency modeling | Memory allocator avoids vulnerable row patterns |
| ISA compliance | Formal ISA model checking | Binary validation against Sail RISC-V model |
| Side-channel budget | Quantitative information flow | Budget annotations limit observable leakage |

## 4. RIINA Integration Architecture

### 4.1 Augmented ISA Model

RIINA extends the standard ISA model (S, δ) to (S, μ, δ, λ):

```coq
(* Augmented machine state *)
Record MachineState := {
  arch_state : ArchState;         (* Registers, RAM *)
  micro_state : MicroState;       (* Cache, BTB, PHT *)
  spec_state : option SpecState;  (* Speculative shadow state *)
}.

(* Leakage model *)
Definition leakage (op : Instruction) (s : MachineState) : Observation :=
  mk_obs (cache_access op s) (branch_direction op s) (timing op s).

(* Constant-time property *)
Definition constant_time (prog : Program) : Prop :=
  forall s1 s2, public_equiv s1 s2 ->
  leakage_trace prog s1 = leakage_trace prog s2.
```

### 4.2 Compiler Integration

```riina
// RIINA annotates security-critical code with timing requirements
fungsi bandingkan_rahsia(a: &[Bait], b: &[Bait]) -> Bool kesan MasaTetap {
    // Compiler must generate constant-time assembly
    // Validator checks no secret-dependent branches or memory accesses
    biar hasil = 0;
    untuk i dalam 0..a.panjang() {
        hasil = hasil | (a[i] ^ b[i]);
    }
    pulang hasil == 0;
}
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Kocher, P., et al., "Spectre Attacks" (2019) | IEEE S&P | Speculative execution attacks |
| Lipp, M., et al., "Meltdown" (2018) | USENIX Security | Kernel memory read via speculation |
| Guarnieri, M., et al., "Hardware-Software Contracts for Secure Speculation" (2021) | IEEE S&P | Formal contract framework |
| Guarnieri, M., et al., "Spectector" (2020) | IEEE S&P | Automated speculative leak detection |
| Armstrong, A., et al., "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS" (2019) | POPL | Sail ISA specification language |
| Barthe, G., et al., "Secure Compilation of Side-Channel Countermeasures" (2018) | CSF | Formal constant-time compilation |
| Almeida, J. B., et al., "Verifying Constant-Time Implementations" (2016) | USENIX Security | ct-verif automated checking |
| Kim, Y., et al., "Flipping Bits in Memory Without Accessing Them" (2014) | ISCA | Rowhammer discovery and analysis |
| Doychev, G., et al., "CacheAudit" (2015) | ACM TISSEC | Quantitative cache side-channel analysis |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| RISC-V ISA formalization (import Sail) | 3-4 | High — Sail-to-Coq export exists | Phase 1 |
| Speculative execution model | 4-6 | Medium — requires microarchitectural detail | Phase 2 |
| Cache side-channel model | 3-4 | High — CacheAudit methodology available | Phase 2 |
| Constant-time type system extension | 3-4 | High — well-understood theory | Phase 2 |
| Spectector-style validator | 4-6 | Medium — assembly-level analysis | Phase 3 |
| Rowhammer resilience model | 2-3 | Medium — physical layout dependent | Phase 4 |
| x86-64 ISA formalization | 8-12 | Low — extremely complex ISA | Phase 5 |
| ARM ISA formalization | 6-8 | Medium — Sail model exists | Phase 5 |

## 7. Scope Limitations

1. **Microarchitectural opacity.** Commercial CPUs (Intel, AMD, ARM) do not publish complete microarchitectural specifications. Formal models must rely on reverse-engineered behavior and may not capture undocumented features. Only RISC-V offers sufficiently open specifications for rigorous modeling.

2. **Model fidelity.** Any formal model of a CPU is an abstraction. New microarchitectural attacks (e.g., Load Value Injection, Microarchitectural Data Sampling) may exploit features not captured in the current model. The model must be continuously updated as new attack vectors are discovered.

3. **Performance cost of mitigations.** Constant-time programming and speculation barriers (e.g., LFENCE, CSDB) impose significant performance overhead (up to 30-50% for some workloads). RIINA must balance security guarantees against practical performance requirements.

4. **Scope limited to single-core.** The current model focuses on single-core microarchitectural state. Multi-core systems introduce additional side channels (shared caches, memory bus contention, coherence protocols) that require separate modeling.

5. **No hardware modification capability.** RIINA can constrain software behavior but cannot modify existing hardware. For hardware features that are inherently insecure (e.g., shared branch predictors), RIINA can only mitigate, not eliminate, the threat.

---

*"Physics is not an abstraction. It is a constraint."*
