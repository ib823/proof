# AR-01: Hardware-Software Co-Verification — Verified Compilation to Hardware

**Domain:** AR — Hardware-Software Co-Verification
**Status:** Research Complete
**Date:** 2026-03-13
**RIINA Feature Target:** CompCert integration path, CHERI capability mapping, ISA-level property preservation

---

## 1. Problem Statement

RIINA compiles to C, then to native code via gcc/clang. This creates a **verification gap**: source-level guarantees (effect discipline, IFC, linear types) are enforced by `riinac` but nothing guarantees the generated C preserves these properties through compilation and execution on hardware.

The question: **how do we extend RIINA's verified guarantees from source through compilation down to the hardware level?**

---

## 2. State of the Art

### 2.1 CompCert — Verified C Compiler (INRIA)

CompCert is a formally verified optimizing C compiler proven in Coq. The key theorem:

> For all source programs `S` and behaviors `B`, if `S` has behavior `B`, then the compiled code `compile(S)` also has behavior `B`.

CompCert supports ARM, PowerPC, RISC-V, and x86 targets. It is the standard reference for verified compilation and directly addresses RIINA's verification gap: if RIINA generates C and CompCert compiles it, then RIINA's source-level behavioral properties hold for the generated binary.

**Current status:** CompCert 3.14 (latest), actively maintained, commercial license from AbsInt.

### 2.2 Sail ISA Specification Language (REMS Project, Cambridge/INRIA)

Sail is the state of the art for formally specifying instruction-set architectures. Adopted by the **RISC-V Foundation** for the official RISC-V ISA specification.

From a Sail specification, developers can:
- Type-check the spec for bitvector mismatches
- Generate executable emulators in C/OCaml
- Generate theorem-prover definitions (**Coq**, Isabelle, HOL4) for interactive verification
- Generate SMT-based symbolic evaluation (Isla)
- Create relaxed-memory concurrency models

Key publication: POPL 2019, "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS."

**Islaris** enables machine-code verification at the ISA level — proves properties of binary code against Sail-generated Coq models.

### 2.3 CHERI — Capability Hardware Enhanced RISC Instructions

CHERI extends conventional ISAs with **hardware capability** types:
- Pointers become capabilities with bounds, permissions, and sealing
- Hardware enforces spatial memory safety, stack safety, and compartmentalization
- Formally verified against Sail-generated Coq models (CHERI-MIPS, Morello ARM)

**RIINA relevance:** RIINA's capability tokens map almost directly to CHERI hardware capabilities. A RIINA program compiled for CHERI hardware could have its capability discipline enforced at both the type level (RIINA) and the hardware level (CHERI).

### 2.4 Kami (MIT CSAIL, PLDI 2017)

Kami is a Coq framework for specifying and verifying hardware designs at the register-transfer level:
- Designs extracted to Bluespec → Verilog for FPGA/ASIC
- Demonstrated on rv32i RISC-V processor verification
- Parametric module specifications with modular proof composition
- ~89% Coq, with Verilog/Bluespec for hardware output

### 2.5 Bedrock2 (MIT PLV, PLDI 2022)

Bedrock2 is the **most complete hardware-software co-verification stack** demonstrated:

1. **Verified C-like language** with Hoare-logic program logic
2. **Verified compiler** generating RISC-V machine code
3. **Verified Kami-based 4-stage pipelined RISC-V processor**
4. **End-to-end proofs**: source postcondition → compiled code on verified processor satisfies postcondition about I/O behavior

Demonstrated for an IoT lightbulb controller — verified from source through processor hardware.

### 2.6 CertiKOS (Yale FLINT, OSDI 2016)

CertiKOS is a verified OS kernel with layered abstraction methodology in Coq:
- Each abstraction layer has a deep specification
- Compositional verification enables modular proofs
- Security properties: privilege separation, no kernel zero-days
- Sits between hardware (CPU spec) and application software

### 2.7 DeepSpec (NSF Expedition, Princeton/MIT/Penn/Yale)

DeepSpec aimed to connect:
- Verified hardware (Kami processor)
- Verified compiler (CompCert)
- Verified OS kernel (CertiKOS)
- Verified applications

Through shared specification interfaces. This represents the aspirational end state of hardware-software co-verification: **functional correctness from transistors to application code.**

---

## 3. Properties Spanning the Hardware-Software Boundary

| Property | Software Verification | Hardware Verification | Bridge |
|----------|----------------------|----------------------|--------|
| **Semantic preservation** | RIINA type system | N/A | CompCert's correctness theorem |
| **ISA conformance** | N/A | Sail ISA spec | Sail → Coq extraction |
| **Memory safety** | RIINA linear types + IFC | CHERI capabilities | Capability token → CHERI mapping |
| **Security isolation** | RIINA effect gates | Hardware privilege levels | CertiKOS abstraction layers |
| **Side-channel freedom** | Constant-time types | Microarchitecture model | Jasmin's approach (type-level) |
| **I/O behavior** | Effect system | Hardware I/O spec | Bedrock2 I/O specification |

---

## 4. RIINA Integration Architecture

### 4.1 The RIINA → CompCert Pipeline

```
RIINA (.rii)  →  riinac  →  C (CompCert-compatible subset)  →  CompCert  →  RISC-V binary
                    ↓                                              ↓
              Type safety proof                           Semantic preservation proof
              (Coq, 9,171 Qed)                           (CompCert Coq proof)
```

**Key constraint:** RIINA's generated C must stay within CompCert's supported C subset (Clight). This means:
- No computed gotos, no `setjmp`/`longjmp`
- No variable-length arrays
- Limited inline assembly
- These are already constraints RIINA respects (it generates clean C)

### 4.2 CHERI Capability Mapping

| RIINA Concept | CHERI Hardware Concept |
|---------------|----------------------|
| `Capability<Effect>` token | CHERI sealed capability with permission bits |
| `Linear<T>` ownership | CHERI capability with single-use permission |
| `Secret<T>` IFC label | CHERI compartment boundary |
| `Grant(eff, body)` | CHERI capability invocation |
| Effect gate (`kesan pintu`) | CHERI compartment transition |

A RIINA compiler targeting CHERI-RISC-V (Morello ARM, or CHERI-RISC-V) would compile:
```
biar cap = Grant(Tulis, blok { ... })
```
To a CHERI sealed capability invocation that hardware-enforces the capability boundary.

### 4.3 ISA-Level Property Verification

For critical RIINA properties to hold at the ISA level:

1. **IFC non-interference**: Requires that the compiled binary's observable behavior (timing, memory access patterns) does not depend on secret inputs. CompCert preserves behavioral semantics but not timing — a separate timing model is needed.

2. **Effect discipline**: Compiled as capability checks in CHERI or as runtime assertions in standard C. CompCert preserves the checks; CHERI hardware enforces them.

3. **Memory safety**: Compiled as bounds checks (standard C) or capability restrictions (CHERI). Sail ISA specs verify that the hardware correctly implements capability checking.

### 4.4 Side-Channel Considerations

RIINA's `ConstantTime<T>` type obligation means:
- No branching on secret values
- No secret-dependent memory indexing
- No secret-dependent loop iteration counts

These properties are preserved by CompCert's semantic preservation (branches on secrets in source → branches on secrets in binary). However, **microarchitectural side channels** (speculative execution, cache timing) require hardware-level analysis beyond CompCert's scope. The Jasmin approach (verified constant-time at assembly level) is the current best practice.

---

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|-------------|
| Leroy, "A Formally Verified Compiler Back-end" | JACM 2009 | CompCert — semantic preservation proof in Coq |
| Armstrong et al., "ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS" | POPL 2019 | Sail ISA specification language |
| Choi et al., "Kami: A Platform for High-Level Parametric Hardware Specification" | PLDI 2017 | Hardware verification in Coq → Bluespec |
| Erbsen et al., "Integration Verification Across Software and Hardware for a Simple Embedded System" | PLDI 2022 | Bedrock2 end-to-end IoT verification |
| Gu et al., "CertiKOS" | OSDI 2016 | Layered verified OS kernel |
| Watson et al., "CHERI: A Hybrid Capability-System Architecture" | S&P 2015 | Hardware capabilities for memory safety |
| Appel, "Verified Software Toolchain" | ESOP 2011 | VST connects CompCert to separation logic |

---

## 6. Formalizability Assessment

| Component | Effort | Feasibility | Phase |
|-----------|--------|-------------|-------|
| CompCert-compatible C emission | Low | Very High (already nearly there) | Phase 5 |
| CompCert integration proof sketch | High | High (CompCert's theorem applies if C is in Clight) | Phase 7 |
| CHERI capability mapping formalization | High | Medium (requires Sail CHERI spec) | Phase 8 |
| ISA-level IFC verification | Very High | Medium (requires Sail + Islaris) | Phase 8+ |
| Constant-time at assembly level | High | Medium (Jasmin approach) | Phase 7 |
| Full Bedrock2-style end-to-end | Very High | Low (research project scale) | Out of scope |

**Bottom line:** The most impactful near-term action is ensuring RIINA generates CompCert-compatible C (Clight subset). This immediately gives semantic preservation from RIINA source to RISC-V binary, closing the compiler verification gap. CHERI mapping and ISA-level verification are longer-term but architecturally natural given RIINA's capability-based design.
