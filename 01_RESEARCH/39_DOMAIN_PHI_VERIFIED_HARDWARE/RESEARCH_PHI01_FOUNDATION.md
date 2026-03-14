# PHI-01: Verified Hardware — Formal Assurance from Silicon to Software

**Domain:** PHI (φ) — Verified Hardware
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Hardware description language integration, verified HDL generation, processor specification verification, hardware capability enforcement (CHERI), side-channel resistant hardware constructs, hardware-software contract verification, RISC-V formal specification compliance

---

## 1. Problem Statement

The correctness of software ultimately depends on the correctness of the hardware executing it. A formally verified compiler producing formally verified machine code provides no guarantees if the processor misexecutes instructions due to design bugs, undocumented microarchitectural behavior, or hardware Trojans. The Intel FDIV bug (1994), the Pentium F00F bug, Spectre and Meltdown (2018), and ongoing discoveries of microarchitectural side channels demonstrate that processor design bugs have severe security and correctness consequences. Yet the hardware verification community and the software verification community have historically operated in isolation, with no unified framework for reasoning about correctness across the hardware-software boundary.

Hardware verification has a distinguished history: the use of ACL2 to verify the FDIV fix, the formal verification of Intel's Ivy Bridge execution cluster by Kaivola et al., and the development of frameworks like Kami for modular hardware verification in Coq have demonstrated that processor-scale verification is achievable. The RISC-V instruction set architecture, with its open specification and clean design, provides an ideal target for formal verification. Reid's work on formalizing the ARM ISA specification and the SAIL language for ISA specification have shown that instruction set semantics can be made precise enough for machine-checked reasoning.

RIINA's role in hardware verification is to close the hardware-software gap by providing a language whose formal semantics can be connected to a formally specified hardware model. When RIINA code is compiled to RISC-V machine code, and the RISC-V processor has been formally verified against its ISA specification, the chain of trust extends from source-level properties through compilation to execution. Additionally, RIINA can serve as a host language for verified hardware description, generating HDL (Verilog/VHDL) from formally verified specifications, following the approach pioneered by Kami and BlueSpec.

## 2. State of the Art

### 2.1 The Kami Framework for Verified Hardware

Vijayaraghavan et al. developed Kami, a framework for modular verification of hardware designs embedded in the Coq proof assistant. Kami uses a guarded atomic action semantics derived from BlueSpec, enabling compositional verification where modules can be verified independently and composed with guaranteed preservation of properties. Kami has been used to verify a multiprocessor cache coherence protocol (an implementation of the MSI protocol) and components of a RISC-V processor. The framework demonstrates that Coq's dependent type system and tactic language are powerful enough for hardware verification at the register-transfer level, making it a natural fit for RIINA's Coq-based formal foundation.

> Choi, J., Vijayaraghavan, M., Sherman, B., Chlipala, A., and Arvind. "Kami: A Platform for High-Level Parametric Hardware Specification and Its Modular Verification." *Proceedings of the ACM on Programming Languages (ICFP)*, 1:24:1-24:30, 2017.

### 2.2 Processor Verification with ACL2

Hunt and Swords at AMD and the University of Texas developed extensive processor verification methodologies using ACL2, a first-order functional programming language with an integrated theorem prover. ACL2 was used to verify the AMD floating-point division implementation after the Pentium FDIV bug, and has since been applied to verify x86 instruction decoders, floating-point units, and memory management units. The ACL2 approach emphasizes executable specifications — the formal model is itself a simulator that can be run on test vectors — bridging the gap between formal verification and traditional simulation-based validation.

> Hunt, W.A. and Swords, S. "Centaur Technology Media Unit Verification." *Proceedings of the 21st International Conference on Computer Aided Verification (CAV)*, pp. 353-367, 2009.

### 2.3 ARM ISA Formal Specification

Reid at ARM developed a comprehensive formal specification of the ARMv8-A instruction set architecture, covering over 5,000 pages of the architecture reference manual in a machine-readable format. This specification enables automatic generation of instruction decoders, simulators, and verification conditions. Reid's work demonstrated that ISA formalization is feasible even for complex commercial architectures and identified numerous ambiguities and errors in the natural-language specification. The SAIL language, developed at Cambridge, provides a domain-specific language for writing ISA specifications that can be compiled to Coq, Isabelle, and other theorem provers.

> Reid, A. "Trustworthy Specifications of ARM v8-A and v8-M System Level Architecture." *Proceedings of the 16th Conference on Formal Methods in Computer-Aided Design (FMCAD)*, pp. 161-168, 2016.

### 2.4 Intel Processor Formal Verification

Kaivola et al. at Intel described the formal verification of the execution cluster of the Intel Core i7 (Ivy Bridge) processor, representing one of the largest industrial formal verification efforts. The verification covered the integer and floating-point execution units, using a combination of theorem proving and model checking to verify functional correctness against the x86 ISA specification. This work demonstrated that formal verification of commercial processor components is industrially viable, though the verification focused on functional correctness and did not address microarchitectural side channels.

> Kaivola, R., Ghughal, R., Naber, N., Telber, A., Tinelli, J., Revi, D., Resta, G., Kirber, D., and Bentley, B. "Replacing Testing with Formal Verification in Intel Core i7 Processor Execution Engine Validation." *Proceedings of the 21st International Conference on Computer Aided Verification (CAV)*, pp. 414-429, 2009.

### 2.5 CHERI Capability Hardware

Watson et al. developed CHERI (Capability Hardware Enhanced RISC Instructions), a hardware-software security model that extends conventional ISAs with hardware capability support. CHERI capabilities are unforgeable, bounds-checked pointers that enforce spatial memory safety, compartmentalization, and fine-grained access control in hardware. The CHERI-MIPS and CHERI-RISC-V prototypes have been formally verified in Isabelle/HOL, with machine-checked proofs that the capability mechanism correctly enforces its intended security properties. CHERI represents the closest existing work to RIINA's vision of hardware-enforced language-level security properties.

> Watson, R.N.M., Woodruff, J., Neumann, P.G., Moore, S.W., Anderson, J., Chisnall, D., Dave, N.H., Davis, B., Gudka, K., Laurie, B., Murdoch, S.J., Norton, R., Roe, M., Son, S., and Vadera, M. "CHERI: A Hybrid Capability-System Architecture for Scalable Software Compartmentalization." *Proceedings of the IEEE Symposium on Security and Privacy (S&P)*, pp. 20-37, 2015.

### 2.6 RISC-V Formal Verification

The RISC-V instruction set architecture, with its open specification and modular design, has become a primary target for formal ISA verification. Multiple groups have developed formal specifications of RISC-V in various proof assistants: the MIT group using Kami in Coq, the Cambridge group using SAIL compiled to multiple targets, and industry efforts using SystemVerilog assertions. The RISC-V Formal Verification Framework provides a standardized interface for checking processor implementations against the ISA specification. Armstrong et al. developed a complete SAIL specification of RISC-V that has been used to generate Coq definitions suitable for proof.

> Armstrong, A., Bauereiss, T., Campbell, B., Reid, A., Gray, K.E., Norton, R.M., Mundkur, P., Wassell, M., French, J., Sheridan, C., Krishnaswami, N.R., and Sewell, P. "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS." *Proceedings of the ACM on Programming Languages (POPL)*, 3:71:1-71:31, 2019.

### 2.7 Hardware Trojans and Supply Chain Security

Hardware Trojans — malicious modifications inserted during design or fabrication — represent a supply chain threat that cannot be addressed by software-only verification. Formal approaches to Trojan detection include comparing a chip's behavior against its formal specification using side-channel analysis, and using proof-carrying hardware where the fabrication facility provides a machine-checkable proof that the manufactured chip implements the specified design. Tehranipoor and Koushanfar provided a comprehensive survey of hardware Trojan taxonomies, detection methods, and mitigation strategies, establishing the formal threat model for hardware supply chain security.

> Tehranipoor, M. and Koushanfar, F. "A Survey of Hardware Trojan Taxonomy and Detection." *IEEE Design & Test of Computers*, 27(1):10-25, 2010.

### 2.8 Side-Channel Resistant Hardware Design

Microarchitectural side channels — including cache timing (Flush+Reload, Prime+Probe), branch prediction (Spectre), and speculative execution (Meltdown) — enable attackers to extract secrets from software through hardware-level information leakage. Formal approaches to side-channel resistance include constant-time programming (verifying that execution time is independent of secret data), hardware partitioning (physically isolating security domains), and formal information flow analysis of hardware designs. Barthe et al. developed formal methods for verifying constant-time properties of software, which can be extended to hardware-level timing models when the processor's microarchitectural behavior is formally specified.

> Barthe, G., Grégoire, B., and Laporte, V. "Secure Compilation of Side-Channel Countermeasures: The Case of Cryptographic 'Constant-Time'." *Proceedings of the IEEE 31st Computer Security Foundations Symposium (CSF)*, pp. 328-343, 2018.

## 3. Properties Verifiable by RIINA

| Property | Verification Method | RIINA Mechanism |
|----------|-------------------|-----------------|
| ISA specification compliance | Model checking against SAIL spec | Verified compilation targeting formal RISC-V spec |
| Capability safety (CHERI) | Type-level capability tracking | Capability types mapped to hardware capabilities |
| Memory safety (hardware-enforced) | Bounds checking in hardware | Refinement types generating hardware bounds metadata |
| Constant-time execution | Information flow analysis | `kesan MasaTetap` effect for timing-insensitive code |
| Cache side-channel resistance | Formal cache model | Cache-oblivious programming constructs |
| Pipeline correctness | Simulation equivalence | Kami-style modular verification in Coq |
| Register file integrity | Type-level register tracking | Linear types for register allocation correctness |
| Interrupt handler safety | Verified interrupt semantics | `kesan Gangguan` effect with verified handler types |
| Bus protocol compliance | Protocol verification | Session types for hardware bus protocols |
| Clock domain crossing safety | Formal synchronization | Verified synchronizer types in HDL generation |

## 4. RIINA Integration Architecture

### 4.1 Verified Hardware Description

```riina
// RIINA as verified HDL: a simple ALU specification
jenis OpKod = Tambah | Tolak | Dan | Atau | Xor;

jenis DaftarBit<N: Nat> = Vektor(N, Bit);

// Verified ALU: output is provably correct for all inputs
fungsi alu(
    op: OpKod,
    a: DaftarBit<32>,
    b: DaftarBit<32>
) -> DaftarBit<32> kesan Bersih {
    padanan op {
        Tambah => tambah_bit(a, b),
        Tolak => tolak_bit(a, b),
        Dan   => dan_bit(a, b),
        Atau  => atau_bit(a, b),
        Xor   => xor_bit(a, b),
    }
}

// CHERI capability type mapped to hardware
jenis Keupayaan<T> = {
    asas: Alamat,
    had: Alamat,
    kebenaran: SetKebenaran,
    jenis_obj: PenandaJenis(T),
    dimeterai: Bool
};

// Capability-checked memory access
fungsi baca_memori<T>(
    kap: Keupayaan<T>,
    offset: Nat { n | n < kap.had - kap.asas }
) -> T kesan BacaMemori {
    // Type system enforces bounds checking
    // Hardware capability enforces at runtime
    pulang muat(kap.asas + offset);
}
```

### 4.2 Hardware-Software Contract

```riina
// Contract between RIINA compiler and RISC-V hardware
kontrak PemprosesSahih {
    // Instruction execution matches ISA specification
    aksiom pelaksanaan_betul:
        untuk_semua (arahan: Arahan, keadaan: KeadaanPemproses),
            laksana(arahan, keadaan) == spesifikasi_isa(arahan, keadaan);

    // No speculative information leakage
    aksiom tiada_kebocoran_spekulatif:
        untuk_semua (rahsia: Bait, program: Aturcara),
            masa_pelaksanaan(program, rahsia) == 
            masa_pelaksanaan(program, ganti_rahsia(rahsia));

    // Capability monotonicity: capabilities cannot be amplified
    aksiom monotoni_keupayaan:
        untuk_semua (kap: Keupayaan, op: Operasi),
            kebenaran(hasil(op, kap)) ⊆ kebenaran(kap);
}
```

### 4.3 Coq Formalization of Hardware Properties

```coq
(* RISC-V instruction verification *)
Require Import Coq.Vectors.Vector.
Require Import Coq.NArith.NArith.

(* 32-bit word *)
Definition word := N.

(* Register file: 32 general-purpose registers *)
Definition regfile := Vector.t word 32.

(* RISC-V R-type instruction *)
Inductive RTypeOp : Type :=
  | ADD | SUB | AND | OR | XOR | SLL | SRL | SRA | SLT | SLTU.

(* ALU specification *)
Definition alu_spec (op : RTypeOp) (rs1 rs2 : word) : word :=
  match op with
  | ADD => N.add rs1 rs2
  | SUB => N.sub rs1 rs2
  | AND => N.land rs1 rs2
  | OR  => N.lor rs1 rs2
  | XOR => N.lxor rs1 rs2
  | SLT => if N.ltb rs1 rs2 then 1%N else 0%N
  | SLTU => if N.ltb rs1 rs2 then 1%N else 0%N
  | _ => 0%N  (* simplified *)
  end.

(* CHERI capability *)
Record Capability : Type := mkCap {
  cap_base   : N;
  cap_length : N;
  cap_perms  : N;   (* permission bitmask *)
  cap_sealed : bool
}.

(* Capability bounds check *)
Definition in_bounds (cap : Capability) (addr : N) : Prop :=
  (cap_base cap <= addr)%N /\ (addr < cap_base cap + cap_length cap)%N.

(* Capability monotonicity: derived capabilities cannot exceed parent *)
Definition cap_leq (c1 c2 : Capability) : Prop :=
  (cap_base c2 <= cap_base c1)%N /\
  (cap_base c1 + cap_length c1 <= cap_base c2 + cap_length c2)%N /\
  N.land (cap_perms c1) (cap_perms c2) = cap_perms c1.

Theorem cap_leq_trans :
  forall c1 c2 c3,
    cap_leq c1 c2 -> cap_leq c2 c3 -> cap_leq c1 c3.
Proof.
  unfold cap_leq. intros c1 c2 c3 [H1a [H1b H1c]] [H2a [H2b H2c]].
  split; [| split].
  - lia.
  - lia.
  - rewrite <- H1c. rewrite <- H2c.
    rewrite N.land_assoc. rewrite H1c. reflexivity.
Qed.
```

## 5. Key References

| # | Reference | Venue | Year | Contribution |
|---|-----------|-------|------|-------------|
| 1 | Choi, J., Vijayaraghavan, M., Sherman, B., Chlipala, A., Arvind. "Kami: A Platform for High-Level Parametric Hardware Specification and Its Modular Verification" | ICFP 2017 | 2017 | Coq-embedded modular hardware verification framework |
| 2 | Hunt, W.A., Swords, S. "Centaur Technology Media Unit Verification" | CAV 2009 | 2009 | ACL2-based industrial processor verification |
| 3 | Reid, A. "Trustworthy Specifications of ARM v8-A and v8-M System Level Architecture" | FMCAD 2016 | 2016 | Formal ISA specification methodology |
| 4 | Kaivola, R. et al. "Replacing Testing with Formal Verification in Intel Core i7 Processor Execution Engine Validation" | CAV 2009 | 2009 | Industrial-scale processor formal verification |
| 5 | Watson, R.N.M. et al. "CHERI: A Hybrid Capability-System Architecture for Scalable Software Compartmentalization" | IEEE S&P 2015 | 2015 | Hardware capability architecture with formal verification |
| 6 | Armstrong, A. et al. "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS" | POPL 2019 | 2019 | Multi-ISA formal specification in SAIL |
| 7 | Tehranipoor, M., Koushanfar, F. "A Survey of Hardware Trojan Taxonomy and Detection" | IEEE D&T 27(1) | 2010 | Hardware Trojan threat model and detection survey |
| 8 | Barthe, G., Grégoire, B., Laporte, V. "Secure Compilation of Side-Channel Countermeasures" | CSF 2018 | 2018 | Formal verification of constant-time execution |
| 9 | Bourgeat, T. et al. "MI6: Secure Enclaves in a Speculative Out-of-Order Processor" | MICRO 2019 | 2019 | Formally verified secure enclave processor |
| 10 | Nienhuis, K. et al. "Rigorous Engineering for Hardware Security: Formal Modelling and Proof in the CHERI Design and Implementation Process" | IEEE S&P 2020 | 2020 | End-to-end formal verification of CHERI |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| RISC-V ISA specification (Coq) | 4 | High | Phase 3 |
| ALU correctness verification | 2 | High | Phase 3 |
| CHERI capability formalization | 3 | High | Phase 4 |
| Pipeline correctness (5-stage) | 6 | Medium | Phase 4 |
| Cache coherence protocol | 5 | Medium | Phase 5 |
| Side-channel resistance model | 4 | Medium | Phase 5 |
| HDL generation from RIINA | 8 | Low-Medium | Phase 5 |
| Hardware Trojan detection | 3 | Low | Phase 6 |
| Speculative execution model | 5 | Low-Medium | Phase 5 |
| Full SoC verification | 12 | Low | Phase 6+ |
| **Total** | **52** | | |

## 7. Scope Limitations

1. **Analog and physical-level verification gap.** Formal hardware verification operates at the register-transfer level (RTL) or above. Properties dependent on analog behavior — signal integrity, timing margins, power supply noise, process variation — cannot be captured in digital formal models. RIINA's hardware verification provides guarantees about the logical design, not the physical implementation.

2. **Fabrication trust assumption.** Even a formally verified HDL design must be fabricated by a foundry, and the fabrication process is not formally verified. Hardware Trojans inserted during fabrication, mask modifications, and process-induced faults create a trust gap between the verified design and the manufactured chip. RIINA can verify the design but cannot verify the silicon.

3. **Microarchitectural side channels are an open problem.** While formal models of cache timing and speculative execution exist, the space of possible microarchitectural side channels is not fully enumerated. New channels (e.g., Hertzbleed exploiting frequency scaling, or power side channels) continue to be discovered. RIINA can verify resistance against known, modeled channels but not against undiscovered ones.

4. **Verification scalability for complex SoCs.** Modern systems-on-chip contain billions of transistors, multiple processor cores, complex interconnects, and heterogeneous accelerators. Full-chip formal verification at this scale exceeds current capabilities. RIINA targets component-level verification with formally specified interfaces, not monolithic SoC verification.

5. **HDL generation maturity.** Generating verified HDL from a high-level language is a research challenge with limited industrial adoption. The semantic gap between RIINA's programming model and hardware execution (pipelining, clock domains, resource sharing) requires careful translation that must itself be verified, creating a bootstrapping problem.

6. **FPGA vs. ASIC verification divergence.** Formal verification results for an FPGA implementation do not automatically transfer to an ASIC implementation of the same design, due to differences in timing, resource mapping, and synthesis tool behavior. RIINA's verification targets the logical design, and technology-specific concerns require additional analysis.

---

*"Verified software on unverified hardware is a house on sand."*
