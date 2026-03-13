# AP-01: Quantum Computing Integration — Formal Verification at the Classical-Quantum Boundary

**Domain:** AP — Quantum Computing Integration
**Status:** Research Complete
**Date:** 2026-03-13
**RIINA Feature Target:** Quantum effect type, linear qubit handles, FFI boundary contracts

---

## 1. Problem Statement

RIINA compiles to C. Quantum computing backends exist at C FFI boundaries (via QIR, Qiskit Runtime, etc.). The question: **what can RIINA's type system guarantee about programs that interface with quantum hardware?**

RIINA cannot verify quantum circuit correctness (that requires quantum-specific tools like SQIR/VOQC). RIINA **can** verify:
- The classical driver program's correctness
- Interface contracts with the quantum runtime
- Linear resource management of qubit handles
- Information flow of measurement results (declassification)

---

## 2. State of the Art

### 2.1 SQIR / VOQC (University of Maryland, inQWIRE Group)

**SQIR** (Small Quantum Intermediate Representation) is the primary framework for formally verified quantum programming. It is a language deeply embedded in Coq, used both as an IR for compilation and as a substrate for proving quantum algorithm correctness. Key properties verified:

- **Correctness of Grover's search algorithm** (probability analysis in Coq)
- **Quantum phase estimation correctness**
- **Complete formalization of Shor's factoring algorithm**
- **Verified gate decompositions** for CH, CSWAP, multi-controlled X/Z gates

**VOQC** (Verified Optimizer for Quantum Circuits, POPL 2021) demonstrates that circuit optimizations — gate cancellation, Hadamard reduction, rotation merging, SWAP insertion for hardware mapping — can be formally proven correct with respect to SQIR's denotational semantics. Code is extracted to OCaml for execution.

**Known gap:** Real numbers in Coq are mapped to floating-point during extraction, introducing rounding error not accounted for in proofs.

### 2.2 QWIRE (University of Pennsylvania / Yale)

QWIRE is a Coq formalization of a higher-order quantum circuit language using a **linear type system over wire types**. The linear type system enforces:

- **No-cloning**: Quantum states cannot be duplicated (enforced by linearity)
- **No-deletion**: Quantum states cannot be silently discarded
- Proper quantum resource management throughout circuit construction

Denotational semantics are given as superoperators on density matrices. Verified programs include Deutsch-Jozsa, quantum adders, teleportation. QWIRE depends on **QuantumLib** (shared Coq library for matrices, probability, quantum measurement semantics). QWIRE compiles to OpenQASM 2.0.

### 2.3 QIR (Quantum Intermediate Representation Alliance)

QIR is a compiler IR for hybrid classical-quantum computation, built directly on **LLVM IR**. It is not formally verified but defines a standard representation:

- Quantum operations encoded as LLVM SSA instructions
- Opaque qubit/result types with external function call semantics
- Classical LLVM infrastructure reused (optimization passes, target backends)
- QIR Alliance members: Microsoft, IBM, Amazon, Google

QIR is the **practical interoperability layer** between classical language compilers and quantum hardware backends. Relevant to RIINA: a RIINA program targeting quantum hardware would produce C code that calls QIR-compatible runtime functions.

### 2.4 Q# (Microsoft)

Q# provides a classical-quantum type system:
- Quantum operations are first-class values
- Operations are distinguished from functions (operations can have side effects on quantum state)
- Adjoint/controlled functors expressible at the type level
- No formal correctness proofs, but a well-defined type system with quantum-specific restrictions

### 2.5 Quipper (Embedded Haskell DSL)

No formal guarantees, but provides rich circuit description with classical control. Used for benchmarking large quantum algorithms. Demonstrates the practical design space for circuit DSLs.

---

## 3. Properties Verifiable at the Classical-Quantum Boundary

| Property | Verification Method | RIINA Relevance |
|----------|-------------------|-----------------|
| **Unitary equivalence** | SQIR denotational semantics in Coq | External — delegated to quantum verifier |
| **Algorithm correctness** | Probabilistic Coq proofs (Grover, Shor) | External — RIINA trusts quantum verifier certificate |
| **Linear resource management** | Linear type system (QWIRE) | **Direct** — RIINA linear types enforce qubit handle discipline |
| **Compilation correctness** | VOQC verified optimizer in Coq | External — quantum IR layer |
| **Classical driver correctness** | Standard program verification | **Direct** — RIINA verifies classical side via effects + IFC |
| **Measurement declassification** | IFC label tracking | **Direct** — quantum measurement results are declassification events |
| **Ancilla correctness** | Circuit assertions in SQIR | External — quantum IR layer |

---

## 4. RIINA Integration Architecture

### 4.1 Effect Type Design

```
kesan Kuantum    // Quantum effect — any interaction with quantum state
kesan Ukur       // Measure effect — collapses quantum state to classical
```

The `Kuantum` effect tracks qubit allocation and entanglement. The `Ukur` (Measure) effect is a sub-effect that produces classical results from quantum state — this is semantically a **declassification** from quantum (unobservable until measured) to classical (observable).

### 4.2 Linear Qubit Handles

```
// Qubit handle: linear resource — cannot be cloned, must be consumed
jenis Kubit = Linear<QubitHandle>

fungsi hadamard(q: Kubit) -> Kubit kesan Kuantum {
    // Applies H gate, returns transformed qubit
    // Linear type ensures q is consumed exactly once
}

fungsi ukur(q: Kubit) -> Bool kesan Ukur {
    // Measures qubit, collapsing state to classical result
    // q is consumed (linearity enforced), Bool is returned
    // This is an IFC declassification event
}
```

RIINA's existing capability system maps naturally:
- `Kubit` is a **Linear<T>** — RIINA's linear type fragment prevents duplication (no-cloning) and ensures consumption (no-leaking)
- Measurement is a **capability-gated declassification** — requires both `Kuantum` effect authorization and `Ukur` capability

### 4.3 FFI Boundary Contract

```
// FFI declaration for QIR-compatible quantum runtime
luaran fungsi qir_h(qubit: *mut Qubit) kesan Kuantum
luaran fungsi qir_cnot(control: *mut Qubit, target: *mut Qubit) kesan Kuantum
luaran fungsi qir_measure(qubit: *mut Qubit) -> Bool kesan Ukur
```

The RIINA type system enforces:
1. Quantum FFI functions are only callable within `Kuantum` effect scope
2. Qubit pointers are linearly tracked — no aliasing, no double-free
3. Measurement results carry IFC labels derived from the quantum context

### 4.4 Compilation Pipeline

```
RIINA (.rii) → riinac → C (classical driver + QIR calls) → gcc/clang → executable
                                                        ↘ QIR runtime → quantum backend
```

Properties that survive each stage:
- **RIINA → C**: Effect discipline, linear resource management (compile-time only)
- **C → executable**: Memory safety of classical driver (relies on C correctness)
- **QIR → quantum**: Circuit correctness (delegated to external verifier — SQIR/VOQC)

---

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|-------------|
| Hietala et al., "A Verified Optimizer for Quantum Circuits" | POPL 2021 | VOQC — verified circuit optimization in Coq |
| Hietala et al., "Proving Quantum Programs Correct" | ITP 2021 | SQIR + Grover/QPE/Shor correctness proofs |
| Paykin et al., "QWIRE: A Core Language for Quantum Circuits" | POPL 2017 | Linear types for quantum resources in Coq |
| Rand et al., "ReQWIRE: Reasoning about Reversible Quantum Circuits" | QPL 2018 | Reversible quantum circuit formalization |
| QIR Alliance Specification | QIR Alliance 2023 | LLVM-based quantum IR standard |
| Selinger, "Towards a Quantum Programming Language" | MSCS 2004 | Foundational quantum lambda calculus with linear types |
| Ying, "Foundations of Quantum Programming" | Morgan Kaufmann 2016 | Textbook on quantum program semantics and verification |

---

## 6. Formalizability Assessment

| Component | Effort | Feasibility | Phase |
|-----------|--------|-------------|-------|
| `Kuantum` effect type in Coq | Low | High | Phase 6 |
| Linear qubit handle typing rule | Medium | High (extends T_Linear) | Phase 6 |
| Measurement-as-declassification IFC rule | Low | High (extends T_Declassify) | Phase 6 |
| FFI boundary contract verification | Medium | Medium (requires C-level spec) | Phase 7 |
| End-to-end quantum circuit correctness | Very High | Low (requires SQIR integration) | Out of scope |

**Bottom line:** RIINA can provide strong guarantees about the classical side of quantum programs — linear resource management, effect discipline, IFC tracking of measurement results. Quantum circuit correctness is delegated to specialized verifiers (SQIR/VOQC) via certified interface contracts. ~80% of the language-level integration is feasible within RIINA's existing type system architecture.
