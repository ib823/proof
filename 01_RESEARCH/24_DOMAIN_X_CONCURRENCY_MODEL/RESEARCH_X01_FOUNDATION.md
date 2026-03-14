# X-01: Formal Concurrency Model — Concurrency is a Protocol, and Protocols are TYPES

**Domain:** X — Formal Concurrency Model
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Session types, ownership-based concurrency, linear channel endpoints, deadlock freedom

---

## 1. Problem Statement

Concurrent programming introduces bug classes that sequential programs cannot exhibit: data races, deadlocks, livelocks, TOCTOU vulnerabilities, and priority inversion. These bugs are non-deterministic, difficult to reproduce, and often manifest only under specific timing conditions. Data races are particularly insidious because they can cause undefined behavior even in otherwise type-safe languages — a data race can corrupt memory in ways that bypass all type-level guarantees.

RIINA's current formal semantics are purely sequential: the `step` relation in `Semantics.v` models single-threaded execution. The moment RIINA programs run on multi-core hardware, the formal guarantees become void for concurrent code. Domain X extends RIINA's type system and semantics to cover concurrency, proving that well-typed concurrent programs are data-race free and deadlock free by construction.

The approach combines three proven techniques: ownership types (preventing shared mutable state), session types (enforcing communication protocols), and linear types (ensuring channel endpoints are used exactly once).

## 2. State of the Art

### 2.1 Session Types

Session types, introduced by Honda, assign types to communication channels that describe the sequence and types of messages exchanged. A session type specifies the protocol: which messages are sent and received, in what order, and with what types. Type checking ensures that both endpoints of a channel follow the protocol, making protocol violations compile-time errors. Session types guarantee type safety, protocol fidelity, and (under certain conditions) deadlock freedom.

Honda, K., "Types for Dyadic Interaction", *CONCUR*, 1993.

Honda, K., Vasconcelos, V. T., Kubo, M., "Language Primitives and Type Discipline for Structured Communication-Based Programming", *ESOP*, 1998.

### 2.2 Multiparty Session Types

Multiparty session types extend binary session types to protocols involving more than two participants. A global type describes the complete protocol from a bird's-eye view, and projection generates local types for each participant. This approach has been applied to real-world protocols (HTTP, SMTP, OAuth) and implemented in languages like Scribble and session-typed Haskell.

Honda, K., Yoshida, N., Carbone, M., "Multiparty Asynchronous Session Types", *POPL*, 2008.

### 2.3 Iris: Concurrent Separation Logic

Iris provides the theoretical foundation for verifying concurrent programs using separation logic. Its key innovation is the combination of higher-order ghost state with invariants and the "later" modality, enabling reasoning about fine-grained concurrent data structures, lock-free algorithms, and weak memory models. Iris has been used to verify Rust's type system (RustBelt), concurrent data structures, and programming language metatheory.

Jung, R., Krebbers, R., Jourdan, J.-H., Bizjak, A., Birkedal, L., Dreyer, D., "Iris from the Ground Up", *Journal of Functional Programming*, 28:e20, 2018.

### 2.4 RustBelt and Rust Concurrency

RustBelt, built on Iris, provides the first formal proof that Rust's ownership and borrowing discipline guarantees thread safety. The key insight is that Rust's "shared XOR mutable" rule prevents data races by construction: data can be either shared (multiple readers, no writers) or exclusively owned (one writer, no readers), but never both simultaneously. RustBelt proves that this discipline is sound even in the presence of unsafe code implementing concurrent data structures.

Jung, R., Jourdan, J.-H., Krebbers, R., Dreyer, D., "RustBelt: Securing the Foundations of the Rust Programming Language", *POPL*, 2018.

### 2.5 Linear Types for Concurrency

Linear types ensure that values are used exactly once, which is essential for correctly managing channel endpoints: a channel endpoint that is used twice could cause protocol desynchronization, and one that is dropped could cause the other endpoint to deadlock. Wadler showed that linear logic corresponds to session types through a Curry-Howard correspondence, connecting the logical and computational perspectives.

Wadler, P., "Propositions as Sessions", *ICFP*, 2012.

### 2.6 Process Calculi: Pi-Calculus and CSP

The pi-calculus (Milner et al.) provides a mathematical foundation for mobile concurrent systems where communication channels can be passed as messages. CSP (Communicating Sequential Processes, Hoare) models concurrent systems as processes that communicate via synchronous channels. Both calculi have well-developed theories of behavioral equivalence and have influenced the design of concurrent programming languages.

Milner, R., Parrow, J., Walker, D., "A Calculus of Mobile Processes, Parts I and II", *Information and Computation*, 100(1):1-77, 1992.

### 2.7 Deadlock Freedom via Type Systems

Kobayashi developed type systems for the pi-calculus that guarantee deadlock freedom by assigning "obligation levels" and "capability levels" to channel operations. Padovani extended this to more practical settings. The GV (Gay-Vasconcelos) calculus provides a functional language with session types that guarantees deadlock freedom by construction through a priority-based type system.

Kobayashi, N., "A New Type System for Deadlock-Free Processes", *CONCUR*, 2006.

Padovani, L., "Deadlock-Free Typestate-Oriented Programming", *Programming*, 2(3):15, 2018.

### 2.8 Verified Concurrent Data Structures

Several projects have formally verified concurrent data structures. Iris has been used to verify Michael-Scott queues, Treiber stacks, and read-copy-update (RCU). The CCAL (Certified Concurrent Abstraction Layers) approach in CertiKOS verifies concurrent OS kernels. These projects demonstrate that formal verification of concurrent code is feasible, albeit labor-intensive.

Vindum, S., Birkedal, L., "Contextual Refinement of the Michael-Scott Queue", *CPP*, 2021.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Data race freedom | Ownership types (shared XOR mutable) | Type system prevents concurrent read-write access |
| Deadlock freedom | Session types with priorities | Type system rejects circular channel dependencies |
| Protocol fidelity | Session type checking | Channel operations must match session type |
| Channel linearity | Linear type enforcement | Channel endpoints used exactly once |
| Progress guarantee | Session type progress theorem | Well-typed sessions always make progress |
| Lock ordering | Type-level lock ordering | Type system enforces consistent lock acquisition order |
| TOCTOU prevention | Atomic session types | Critical sections encoded as atomic session steps |

## 4. RIINA Integration Architecture

### 4.1 Session Types in RIINA

```riina
// Protocol type for file transfer
jenis PindahFail =
    !NamaFail.           // Send filename
    ?SaizFail.            // Receive size
    !Pengesahan.          // Send confirmation
    ?DataFail.            // Receive data
    Tamat                 // Protocol complete

// Type-safe client implementation
fungsi klien(ch: Saluran<PindahFail>) kesan IO {
    ch.hantar(nama_fail);       // Must send filename first
    biar saiz = ch.terima();     // Must receive size second
    ch.hantar(Sahkan);          // Must send confirmation third
    biar data = ch.terima();     // Must receive data fourth
    ch.tutup();                  // Must close at End
}
```

### 4.2 Ownership-Based Concurrency

```riina
// Shared XOR Mutable — enforced by type system
fungsi proses_selamat(data: &Buffer) kesan Baca {
    // Multiple threads can hold shared references
    biar nilai = data.baca();
}

fungsi ubah_eksklusif(data: &mut Buffer) kesan Tulis {
    // Only one thread can hold a mutable reference
    data.tulis("baharu");
}
```

### 4.3 Coq Formalization

```coq
(* Data race freedom theorem *)
Theorem data_race_free : forall config,
  well_typed_config config ->
  forall t1 t2 loc,
    t1 <> t2 ->
    accesses config t1 loc ->
    accesses config t2 loc ->
    read_only config t1 loc \/ read_only config t2 loc.

(* Session type progress *)
Theorem session_progress : forall config,
  well_typed_config config ->
  config_terminated config \/ exists config', cstep config config'.

(* Channel linearity *)
Theorem channel_linear : forall G ch S,
  has_ctype G ch (TChan S) ->
  count_uses G ch = 1.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Honda, K., "Types for Dyadic Interaction" (1993) | CONCUR | Foundational session types |
| Honda, K., Yoshida, N., Carbone, M., "Multiparty Asynchronous Session Types" (2008) | POPL | Multiparty protocols |
| Jung, R., et al., "Iris from the Ground Up" (2018) | JFP | Concurrent separation logic framework |
| Jung, R., et al., "RustBelt" (2018) | POPL | Verified Rust concurrency safety |
| Wadler, P., "Propositions as Sessions" (2012) | ICFP | Linear logic / session types correspondence |
| Milner, R., et al., "A Calculus of Mobile Processes" (1992) | Information and Computation | Pi-calculus foundation |
| Kobayashi, N., "A New Type System for Deadlock-Free Processes" (2006) | CONCUR | Deadlock freedom via types |
| Honda, K., et al., "Language Primitives for Structured Communication" (1998) | ESOP | Practical session types |
| Padovani, L., "Deadlock-Free Typestate-Oriented Programming" (2018) | Programming | Practical deadlock freedom |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Binary session types | 3-4 | High — well-understood theory | Phase 1 |
| Linear channel endpoints | 2-3 | High — standard linear type theory | Phase 1 |
| Ownership-based data race freedom | 3-4 | High — RustBelt methodology | Phase 2 |
| Deadlock freedom proof | 4-6 | Medium — priority-based approach | Phase 2 |
| Multiparty session types | 4-6 | Medium — projection complexity | Phase 3 |
| Concurrent semantics (thread pool) | 3-4 | Medium — interleaving semantics | Phase 3 |
| Lock ordering enforcement | 2-3 | High — standard technique | Phase 3 |
| Verified concurrent data structures | 6-8 | Medium — per-structure effort | Phase 4 |

## 7. Scope Limitations

1. **Session types require structured communication.** Not all concurrent patterns fit the session type model. Shared-memory concurrent data structures (lock-free queues, concurrent hash maps) require separate verification approaches (Iris-based proofs).

2. **Multiparty session type projection.** Projecting a global protocol to local types is undecidable in general. RIINA restricts to "well-formed" global types where projection is decidable, which excludes some complex protocols.

3. **Deadlock freedom vs. expressiveness.** The priority-based approach to deadlock freedom rejects some deadlock-free programs that use cyclic channel dependencies. Programmers may need to restructure code to satisfy the type system.

4. **Performance of message-passing.** Session types encourage message-passing concurrency, which can be less efficient than shared-memory approaches for certain workloads. RIINA must provide both paradigms with appropriate verification for each.

5. **Weak memory models.** The formal semantics assume sequential consistency. Real hardware (ARM, RISC-V) has weak memory ordering. Extending the proofs to weak memory requires additional formalization effort and may reject some efficient concurrent algorithms.

6. **No support for async/await.** The current model covers synchronous channels and thread spawning. Asynchronous programming patterns (futures, async/await) require additional type-level support not yet formalized.

---

*"Concurrency is not chaos. Concurrency is a protocol, and protocols are TYPES."*
