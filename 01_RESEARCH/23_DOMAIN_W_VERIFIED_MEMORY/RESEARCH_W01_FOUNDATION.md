# W-01: Verified Memory Management — Memory is PROVEN

**Domain:** W — Verified Memory Management
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Verified allocator, separation logic, region-based memory, ownership types

---

## 1. Problem Statement

Memory corruption vulnerabilities have been the dominant class of security bugs for over 50 years. Buffer overflows enabled the Morris Worm (1988), use-after-free bugs account for approximately 70% of Chrome and Windows CVEs as of 2024, and heap corruption enables type confusion attacks that bypass all type-level guarantees. Even in memory-safe languages like Rust, the runtime memory allocator itself is typically unverified C code — a buggy allocator can return overlapping memory regions, allow access to freed memory, or corrupt internal metadata, bypassing all type-system safety guarantees.

RIINA's type system prevents logical memory errors at the source level, but the runtime allocator operates below the type system's guarantees. If the allocator is incorrect, it can silently undermine every safety property that the type system establishes. Domain W addresses this by formally verifying the memory allocator using separation logic, ensuring that memory safety holds not just at the type level but at the implementation level.

## 2. State of the Art

### 2.1 Separation Logic

Separation logic, introduced by John Reynolds and Peter O'Hearn, extends Hoare logic with spatial reasoning about heap memory. The key operator is the separating conjunction (P * Q), which asserts that the heap can be split into two disjoint parts satisfying P and Q respectively. The frame rule enables modular reasoning: if a program operates on one part of the heap, the rest is automatically preserved. Separation logic has become the standard tool for verifying heap-manipulating programs.

Reynolds, J. C., "Separation Logic: A Logic for Shared Mutable Data Structures", *LICS*, 2002.

O'Hearn, P. W., "Resources, Concurrency, and Local Reasoning", *Theoretical Computer Science*, 375(1-3):271-307, 2007.

### 2.2 Iris: Higher-Order Concurrent Separation Logic

Iris, developed by Ralf Jung, Robbert Krebbers, and colleagues at MPI-SWS, is a higher-order concurrent separation logic framework implemented in Coq. Iris provides a flexible foundation for reasoning about shared-memory concurrent programs using ghost state, invariants, and the "later" modality. It has been used to verify complex concurrent data structures, the Rust type system (via RustBelt), and the correctness of weak memory models.

Jung, R., Krebbers, R., Jourdan, J.-H., Bizjak, A., Birkedal, L., Dreyer, D., "Iris from the Ground Up: A Modular Foundation for Higher-Order Concurrent Separation Logic", *Journal of Functional Programming*, 28:e20, 2018.

Jung, R., Jourdan, J.-H., Krebbers, R., Dreyer, D., "RustBelt: Securing the Foundations of the Rust Programming Language", *POPL*, 2018.

### 2.3 RustBelt: Verified Safety for Rust

RustBelt provides the first formal proof that Rust's type system (including ownership, borrowing, and lifetimes) guarantees safety even in the presence of unsafe code, provided that unsafe code satisfies a semantic contract. Built on Iris, RustBelt formalizes Rust's type system as a semantic model and proves that well-typed programs cannot exhibit undefined behavior. This work is directly relevant to RIINA, which adopts Rust-style ownership.

Jung, R., Jourdan, J.-H., Krebbers, R., Dreyer, D., "RustBelt: Securing the Foundations of the Rust Programming Language", *POPL*, 2018.

### 2.4 RefinedC: Verified C Programs

RefinedC, developed by Michael Sammler et al., combines Rust-style ownership types with separation logic to verify C programs. It automates separation logic proofs using refinement types, enabling verification of real C code (including parts of the Linux kernel) with relatively low annotation burden. RefinedC demonstrates that ownership-based verification can be applied even to languages without built-in ownership.

Sammler, M., Lepigre, R., Krebbers, R., Memarian, K., Dreyer, D., Garg, D., "RefinedC: Automating the Foundational Verification of C Code with Refined Ownership Types", *PLDI*, 2021.

### 2.5 CompCert Memory Model

CompCert's memory model, designed by Leroy and Blazy, provides a formal specification of memory layout for C programs. The model supports block-structured memory with permissions (readable, writable, freeable), pointer arithmetic, and alignment constraints. It has been the basis for numerous verified systems and serves as a reference for formalizing memory behavior in verified compilers.

Leroy, X., Blazy, S., "Formal Verification of a C-like Memory Model and Its Uses for Verifying Program Transformations", *Journal of Automated Reasoning*, 41(1):1-31, 2008.

### 2.6 Region-Based Memory Management

Region-based memory management, pioneered by Tofte and Talpin, organizes allocations into hierarchical regions that are deallocated as a unit. This provides deterministic deallocation without garbage collection, bounded memory usage, and provable memory safety. The ML Kit compiler demonstrated that region inference can be fully automatic, and Cyclone adapted regions for a safe C dialect.

Tofte, M., Talpin, J.-P., "Region-Based Memory Management", *Information and Computation*, 132(2):109-176, 1997.

### 2.7 Verified Garbage Collection

Verified garbage collectors provide proven correctness for automatic memory management. McCreight et al. verified a copying garbage collector in Coq, proving that live objects are preserved and dead objects are correctly reclaimed. The CertiCoq project includes a verified generational garbage collector for the Coq-extracted runtime.

McCreight, A., Shao, Z., Lin, C., Li, L., "A General Framework for Certifying Garbage Collectors and Their Mutators", *PLDI*, 2007.

### 2.8 Verified Allocator Implementations

Several projects have formally verified memory allocators. The CertiKOS project includes a verified page allocator and slab allocator. Tuch et al. verified parts of the L4 microkernel's memory management using separation logic in Isabelle/HOL. More recently, the Verus project has been used to verify Rust allocator implementations.

Tuch, H., Klein, G., Norrish, M., "Types, Bytes, and Separation Logic", *POPL*, 2007.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Non-overlapping allocations | Separation logic (P * Q) | Allocator returns disjoint regions |
| Use-after-free prevention | Ownership/lifetime tracking | Type system prevents access after free |
| Double-free prevention | Linear/affine type enforcement | Free consumes ownership; second free is type error |
| Buffer overflow prevention | Bounds checking + verified allocator | Allocator returns exact sizes; type system checks bounds |
| Memory leak prevention | Region-based deallocation / verified GC | Regions freed at scope exit; GC proves reachability |
| Fragmentation bounds | Buddy allocator analysis | Fragmentation bounded by factor of 2 |
| Allocator functional correctness | Simulation proof against abstract spec | Concrete allocator refines abstract allocation model |

## 4. RIINA Integration Architecture

### 4.1 Ownership Type System

```riina
// RIINA ownership types
fungsi proses_data(data: &mut Buffer) kesan Tulis {
    // Exclusive borrow — only one mutable reference
    data.tulis("hasil");
}

fungsi baca_data(data: &Buffer) -> Teks kesan Baca {
    // Shared borrow — multiple readers, no writers
    pulang data.sebagai_teks();
}

// Region-based allocation
kawasan r {
    biar x = peruntuk_dalam(r, data);
    biar y = peruntuk_dalam(r, lebih_data);
    // All allocations freed when region ends
}
// x, y automatically deallocated here
```

### 4.2 Verified Allocator Stack

```
┌─────────────────────────────────────────┐
│         RIINA Runtime                    │
├─────────────────────────────────────────┤
│    Verified Allocator API                │
│    (alloc, free, realloc)               │
├─────────────────────────────────────────┤
│    Buddy Allocator Core                  │
│    (Coq-verified, extracted to Rust)    │
├─────────────────────────────────────────┤
│    Page Allocator                        │
│    (seL4 / Track U integration)         │
├─────────────────────────────────────────┤
│    Physical Memory (Hardware)            │
└─────────────────────────────────────────┘
```

### 4.3 Coq Formalization

```coq
(* Allocation preserves separation *)
Theorem alloc_fresh : forall heap sz p heap',
  alloc heap sz = Some (p, heap') ->
  forall q, allocated heap q -> disjoint_blocks p sz q (block_size heap q).

(* Free returns memory to free list *)
Theorem free_reclaim : forall heap p heap',
  free heap p = Some heap' ->
  ~allocated heap' p.

(* Ownership transfer is linear *)
Theorem ownership_linear : forall G e p T,
  has_type G e (Owned T p) ->
  consumed p G ->
  ~has_type G e (Owned T p).
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Reynolds, J. C., "Separation Logic" (2002) | LICS | Foundational spatial heap logic |
| O'Hearn, P. W., "Resources, Concurrency, and Local Reasoning" (2007) | TCS | Frame rule and concurrent separation logic |
| Jung, R., et al., "Iris from the Ground Up" (2018) | JFP | Higher-order concurrent separation logic in Coq |
| Jung, R., et al., "RustBelt" (2018) | POPL | Verified safety for Rust ownership types |
| Sammler, M., et al., "RefinedC" (2021) | PLDI | Automated ownership-based C verification |
| Leroy, X., Blazy, S., "CompCert Memory Model" (2008) | J. Automated Reasoning | Formal C memory model |
| Tofte, M., Talpin, J.-P., "Region-Based Memory Management" (1997) | Information and Computation | Region inference theory |
| McCreight, A., et al., "Certifying Garbage Collectors" (2007) | PLDI | Verified GC framework |
| Tuch, H., et al., "Types, Bytes, and Separation Logic" (2007) | POPL | Low-level memory verification |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Separation logic foundation (in Coq) | 2-3 | High — Iris available | Phase 1 |
| Abstract allocator specification | 2-3 | High — well-understood interface | Phase 1 |
| Buddy allocator implementation + proof | 4-6 | Medium — complex invariants | Phase 2 |
| Ownership type system formalization | 3-4 | High — RustBelt methodology | Phase 2 |
| Region-based allocation | 3-4 | High — Tofte-Talpin theory | Phase 3 |
| Coq extraction to Rust | 2-3 | Medium — extraction quality issues | Phase 3 |
| Verified garbage collector | 6-8 | Medium — complex correctness proofs | Phase 4 |
| Integration with Domain U (seL4) | 4-6 | Medium — cross-system verification | Phase 5 |

## 7. Scope Limitations

1. **Performance of verified allocators.** Formally verified allocators (buddy allocators) typically have worse fragmentation and throughput than state-of-the-art production allocators (jemalloc, mimalloc, tcmalloc). The verification constraint limits the algorithms that can be tractably verified.

2. **Coq extraction quality.** Extracting Coq code to Rust produces idiomatic but not always efficient code. Manual optimization of extracted code requires re-verification. The gap between the verified Coq model and the actual Rust implementation is a source of potential unsoundness.

3. **Concurrent allocator verification.** Verifying a concurrent allocator (with thread-local caches, atomic free lists, etc.) is significantly harder than verifying a sequential one. Iris provides the tools, but the proof effort is substantial.

4. **Page-level memory management.** The verified allocator manages heap memory, but page allocation, virtual memory mapping, and TLB management are handled by the OS kernel. These are out of scope unless running on a verified kernel (seL4).

5. **Hardware memory model.** The allocator correctness proof assumes a sequential memory model. On modern hardware with weak memory ordering (ARM, RISC-V), additional proofs about memory barriers and acquire-release semantics are needed for concurrent allocation.

6. **No verified realloc.** Reallocation (growing a buffer in place or copying to a larger block) is significantly harder to verify than basic allocation and deallocation, due to the need to prove that data is correctly copied and old memory is properly freed.

---

*"Memory is not managed. Memory is PROVEN."*
