# AQ-01: Concurrent & Distributed Systems Verification — Beyond Session Types

**Domain:** AQ — Concurrent & Distributed Systems Verification
**Status:** Research Complete
**Date:** 2026-03-13
**RIINA Feature Target:** Concurrent effects, verified channel protocols, distributed consensus contracts

---

## 1. Problem Statement

RIINA has session types (Phase 6, REQ-16) and basic IFC (Bell-LaPadula). But concurrent and distributed systems verification goes far beyond session types:

- **Concurrent shared-memory programs** need data-race freedom, deadlock freedom, linearizability
- **Distributed systems** need consensus correctness, partition tolerance, causal consistency
- **IFC under concurrency** is fundamentally harder — timing channels, scheduler-induced leaks
- **Algebraic effects + concurrency** interaction is an open research area

---

## 2. State of the Art

### 2.1 Iris — Higher-Order Concurrent Separation Logic

**Iris** (MPI-SWS, JACM 2023) is the dominant framework for mechanized verification of concurrent programs. Implemented in Coq (Rocq). Core abstractions:

- **Persistent vs ephemeral propositions**: Persistent propositions (knowledge) can be duplicated; ephemeral propositions (ownership) cannot — a separation logic for concurrency
- **Invariants for shared state**: Named invariants protect shared resources, opened atomically
- **Ghost state with algebraic structure**: Resources modeled as elements of a camera (complete ordered family of monoids), enabling ownership transfer and composition
- **Logical atomicity**: Specifies that a fine-grained concurrent operation behaves as if it executes in one atomic step — the formal notion of linearizability

**What Iris verifies:**
- Safety and correctness of concurrent programs
- Linearizability of lock-free concurrent data structures
- Type soundness via semantic type models (RustBelt uses Iris for Rust type safety)
- Memory safety and data-race freedom
- Programs under weak memory models (C11 release-acquire)

### 2.2 RustBelt (MPI-SWS, POPL 2018)

RustBelt uses Iris to formally verify Rust's type system safety claims:
- Safe encapsulation of `unsafe` code
- The Stacked Borrows aliasing model
- Concurrent data structures (`Mutex<T>`, `RwLock<T>`)
- Lifetime-based ownership transfer

**RIINA relevance:** RustBelt's methodology — proving a type system sound using Iris — is directly applicable to RIINA's type system.

### 2.3 Verdi (University of Washington, PLDI 2015)

Verdi is a Coq framework for implementing and formally verifying distributed systems. Key methodology: **Verified System Transformers (VSTs)**:

1. Write proof against an idealized network model (no faults)
2. Apply a VST (e.g., primary-backup replication) that transforms the program
3. The VST carries a proof that the transformed system satisfies the original spec under the realistic fault model

**Verified systems:**
- **LockServ**: Distributed lock server (safety + liveness)
- **VarD**: Distributed key-value store
- **Raft**: Leader election, log replication, safety (CPP 2016 — first mechanized Raft proof)

### 2.4 IronFleet (Microsoft Research, SOSP 2015)

IronFleet proved safety AND liveness of practical distributed systems using Dafny:
- **Multi-Paxos-based replicated state machine** library
- **Sharded key-value store**

Methodology: TLA+-style state-machine refinement for protocol reasoning + Hoare logic for implementation reasoning. Dafny bridges the two levels.

**Significance:** First proof of both safety and liveness for production-quality distributed systems (not toy examples).

### 2.5 CRDTs — Conflict-free Replicated Data Types

CRDTs have been formally verified in Coq and Isabelle:
- **Strong eventual consistency**: Any two replicas with the same update set reach the same state
- Verified types: G-Counters, OR-Sets, Two-Phase Sets, RGA (collaborative text editing)
- **Chapar project**: Verified causal consistency for key-value stores

### 2.6 TLA+ for Distributed Specification

TLA+ (Temporal Logic of Actions) is the dominant specification language for distributed systems:
- Used at AWS (S3, DynamoDB), Microsoft (Azure Cosmos DB), Dropbox
- TLC model checker for state space exploration
- TLAPS proof system for deductive proofs
- Expresses both safety (invariants) and liveness (temporal properties)

### 2.7 SecCSL — Information Flow in Concurrent Separation Logic

**SecCSL** (Murray et al., CSF 2018) extends concurrent separation logic with information flow security:
- Non-interference under concurrent execution
- Addresses timing channels from shared-memory contention
- Scheduler non-interference (termination-insensitive)

**Key insight:** Standard IFC non-interference breaks under concurrency because the scheduler's choices can leak information. SecCSL provides compositional reasoning principles that account for this.

---

## 3. Concurrent Primitives Requiring Verification

For RIINA compiling to C:

| Primitive | Verification Property | Verification Method |
|-----------|----------------------|---------------------|
| **Atomic operations** (CAS, fetch-add) | Correct under C11 memory model | Iris + weak memory extension |
| **Mutex/locks** | Ownership transfer, deadlock freedom | Iris invariants + ghost state |
| **Channels** | Protocol compliance (session types) | Session type checking |
| **Lock-free data structures** | Linearizability | Iris logical atomicity |
| **Memory ordering** | Sufficient ordering for correctness | Iris C11 model (ECOOP 2017) |
| **Distributed consensus** | Agreement, validity, termination | Verdi VSTs / IronFleet refinement |
| **Replicated state** | Strong eventual consistency | CRDT algebraic proofs |

---

## 4. RIINA Integration Architecture

### 4.1 Effect Types for Concurrency

```
kesan Selari     // Parallel — spawns concurrent computation
kesan Atomik     // Atomic — atomic memory operations
kesan Saluran    // Channel — message passing (session types)
kesan Kunci      // Lock — mutex acquisition/release
```

Effect hierarchy: `Bersih ⊑ Baca ⊑ Atomik ⊑ Selari`

### 4.2 Capability Tokens for Synchronization

```
// Lock capability: linear resource — must be acquired and released
jenis KunciCap<T> = Linear<MutexGuard<T>>

fungsi kunci<T>(m: &Mutex<T>) -> KunciCap<T> kesan Kunci {
    // Acquires lock, returns linear guard
    // Linear type ensures lock is eventually released (no deadlock from forgotten locks)
}

fungsi buka<T>(guard: KunciCap<T>) -> () kesan Kunci {
    // Releases lock by consuming the linear guard
}
```

### 4.3 IFC Under Concurrency

RIINA's Bell-LaPadula IFC must be extended for concurrent settings:

1. **No-read-up through channels**: A thread at security level `L` cannot receive from a channel carrying level `H` data
2. **No-write-down through channels**: A thread at level `H` cannot send on a channel observable at level `L`
3. **Scheduler non-interference**: RIINA's effect system can require that branching on secret values does not affect scheduling (by requiring constant-time execution in secret contexts)

```
// IFC-aware channel type
jenis SaluranSelamat<T, Tahap: SecurityLevel> = Chan<T>

// Only accessible at matching or higher security level
fungsi terima<T, L>(ch: SaluranSelamat<T, L>) -> T kesan Saluran
    di mana Self::Tahap >= L   // IFC: no-read-up check
```

### 4.4 Distributed Consensus Contracts

```
// Consensus protocol interface — verified by external TLA+/Verdi proof
antara_muka Konsensus<T> {
    // Safety: agreement — all nodes that decide, decide the same value
    // Safety: validity — the decided value was proposed by some node
    // Liveness: termination — all correct nodes eventually decide
    fungsi cadang(nilai: T) kesan Rangkaian
    fungsi putus() -> T kesan Rangkaian
}
```

The RIINA compiler enforces that any implementation of `Konsensus` must have an accompanying Verdi/IronFleet proof artifact. The type system ensures the consensus interface is used correctly (propose before decide, etc.).

---

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|-------------|
| Jung et al., "Iris from the Ground Up" | JACM 2023 | Comprehensive higher-order concurrent separation logic in Coq |
| Jung et al., "RustBelt" | POPL 2018 | Iris verifies Rust's type safety including unsafe encapsulation |
| Wilcox et al., "Verdi" | PLDI 2015 | VST methodology for verified distributed systems in Coq |
| Woos et al., "Planning for Change in a Formal Verification of the Raft Consensus Protocol" | CPP 2016 | First mechanized Raft proof |
| Hawblitzel et al., "IronFleet" | SOSP 2015 | Safety + liveness proofs for practical distributed systems |
| Kaiser et al., "Strong Logic for Weak Memory" | ECOOP 2017 | Iris extension for C11 release-acquire memory model |
| Murray et al., "SecCSL" | CSF 2018 | IFC in concurrent separation logic |
| Shapiro et al., "Conflict-free Replicated Data Types" | SSS 2011 | CRDT foundations and strong eventual consistency |

---

## 6. Formalizability Assessment

| Component | Effort | Feasibility | Phase |
|-----------|--------|-------------|-------|
| Concurrent effect types in Coq | Medium | High | Phase 6 |
| Data-race freedom via effect discipline | Medium | High (effect system already exists) | Phase 6 |
| IFC non-interference under concurrency | High | Medium (requires scheduler model) | Phase 7 |
| Session type integration | High | High (REQ-16 already planned) | Phase 6 |
| Lock capability linear types | Medium | High (extends T_Linear) | Phase 6 |
| Distributed consensus contracts | Very High | Medium (requires Verdi/IronFleet integration) | Phase 8 |
| CRDT correctness types | Medium | Medium (algebraic CRDT proofs exist) | Phase 7 |

**Bottom line:** RIINA's effect system + linear types + IFC provide natural anchors for concurrent verification. Data-race freedom via effect discipline and linear lock capabilities are immediately feasible. Distributed consensus contracts and IFC under concurrency are harder but achievable through external proof artifact integration.
