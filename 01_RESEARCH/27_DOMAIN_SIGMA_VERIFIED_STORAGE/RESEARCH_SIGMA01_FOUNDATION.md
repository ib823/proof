# Σ-01: Verified Persistent Storage — Every Transaction PROVEN Correct

**Domain:** Σ — Verified Persistent Storage
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Type-safe queries, verified ACID properties, crash-safe transactions, verified query optimization

---

## 1. Problem Statement

Databases are the foundation of virtually all software systems, yet they are among the most vulnerability-prone components. SQL injection has been the #1 web application vulnerability for two decades, enabling catastrophic data breaches (Equifax 2017: 147 million records, Yahoo 2013-2014: 3 billion accounts). Beyond injection, database engines contain memory safety bugs (buffer overflows in C/C++ implementations), ACID property violations under concurrent access, and crash-recovery bugs that can corrupt data.

Current database engines (MySQL, PostgreSQL, MongoDB) consist of millions of lines of unverified C/C++ code. Even SQLite, the "most tested" database, relies on extensive testing rather than formal proof. RIINA's goal is a storage layer where queries are type-safe by construction (eliminating SQL injection), ACID properties are mathematically proven (not tested), memory safety is guaranteed, and crash recovery is formally verified.

## 2. State of the Art

### 2.1 FSCQ: Verified File System with Crash Safety

FSCQ (File System with Crash-safety proofs in Coq), developed by Chen et al. at MIT, is the first file system with a machine-checked proof of crash safety. FSCQ proves that after any sequence of crashes and recoveries, the file system is in a consistent state. The key technical contribution is the Crash Hoare Logic (CHL), which extends Hoare logic with crash conditions that specify what invariants hold after an unexpected crash.

Chen, H., Ziegler, D., Chajed, T., Chlipala, A., Kaashoek, M. F., Zeldovich, N., "Using Crash Hoare Logic for Certifying the FSCQ File System", *SOSP*, 2015.

### 2.2 Verdi: Verified Distributed Systems Framework

Verdi, from the University of Washington, provides a framework for implementing and verifying distributed systems in Coq. Verdi introduces "verified system transformers" that add fault tolerance (e.g., state machine replication) to a verified single-node system. The framework has been used to verify an implementation of the Raft consensus protocol.

Wilcox, J. R., Woos, D., Panchekha, P., Tatlock, Z., Wang, X., Ernst, M. D., Anderson, T., "Verdi: A Framework for Implementing and Formally Verifying Distributed Systems", *PLDI*, 2015.

### 2.3 CertiKV: Verified Key-Value Store

CertiKV demonstrates end-to-end verification of a key-value store, proving linearizability of concurrent operations, crash safety of the write-ahead log, and correctness of the B-tree index. The project combines concurrent separation logic with crash-safety reasoning.

### 2.4 TigerBeetle: Financial Database Design

TigerBeetle is a purpose-built database for financial transactions, designed with correctness as the primary goal. While not formally verified, TigerBeetle's deterministic simulation testing methodology (inspired by FoundationDB) catches bugs that traditional testing misses. Its design philosophy — fixed-schema, no dynamic allocation, deterministic execution — aligns with formal verification goals.

### 2.5 Yggdrasil: Verified File System Framework

Yggdrasil, developed at the University of Washington, uses push-button verification to automatically prove crash safety for file system implementations. It separates specification, implementation, and crash-safety reasoning into distinct layers, enabling modular verification.

Sigurbjarnarson, H., Bornholt, J., Torlak, E., Wang, X., "Push-Button Verification of File Systems via Crash Refinement", *OSDI*, 2016.

### 2.6 Cogent: Language for Verified Systems

Cogent is a restricted functional language designed for implementing systems code (file systems, drivers) that can be automatically verified. Programs written in Cogent can be automatically translated to both C (for execution) and Isabelle/HOL (for verification), with a proof that the C code refines the Isabelle specification.

Amani, S., Hixon, A., Chen, Z., et al., "Cogent: Uniqueness Types and Certifying Compilation", *Journal of Functional Programming*, 29:e25, 2019.

### 2.7 SQLite Formal Analysis

While SQLite is not formally verified, its extensive testing (100% MC/DC branch coverage, billions of test cases) and simple design make it a practical baseline. Recent work has applied bounded model checking and symbolic execution to SQLite, finding several bugs in rarely-exercised code paths.

### 2.8 Verified B-Trees and Index Structures

Formal verification of B-tree implementations proves that insertions, deletions, and lookups maintain the B-tree invariants (key ordering, balance, occupancy bounds). Ernst et al. verified a B-tree in Isabelle/HOL, proving both functional correctness and complexity bounds.

Ernst, G., Pfähler, J., Schellhorn, G., Haneberg, D., Reif, W., "KIV: Overview and VerifyThis Competition", *Software Tools for Technology Transfer*, 17(6):677-694, 2015.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| SQL injection impossibility | Type-safe query language | Queries are types, not strings; injection is a type error |
| ACID atomicity | Crash Hoare Logic | Transactions proven atomic across crashes |
| ACID consistency | Invariant preservation proofs | Schema invariants proven preserved by every operation |
| ACID isolation | Concurrent separation logic | Concurrent transactions proven serializable |
| ACID durability | Write-ahead log verification | Committed data proven recoverable after crash |
| Query optimization correctness | Refinement proof | Optimized query proven equivalent to unoptimized |
| Memory safety | Separation logic (Domain W) | No buffer overflows in storage engine |

## 4. RIINA Integration Architecture

### 4.1 Type-Safe Query Language

```riina
// Queries are types, not strings — SQL injection impossible
jenis Pertanyaan<T> = ...

fungsi cari_pengguna(id: Nombor) -> Hasil<Pengguna, RalatDB> kesan Baca {
    biar pertanyaan = Pertanyaan::pilih::<Pengguna>()
        .di_mana(Pengguna::id, sama_dengan(id));
    pulang db.laksana(pertanyaan);
}
```

### 4.2 Coq Formalization

```coq
(* ACID atomicity via crash Hoare logic *)
Theorem transaction_atomic : forall txn db db',
  exec_transaction txn db = Some db' ->
  forall crash_point, recovered_state (crash_at txn crash_point db)
    = db \/ recovered_state (crash_at txn crash_point db) = db'.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Chen, H., et al., "FSCQ" (2015) | SOSP | Crash-safe verified file system |
| Wilcox, J. R., et al., "Verdi" (2015) | PLDI | Verified distributed systems framework |
| Sigurbjarnarson, H., et al., "Yggdrasil" (2016) | OSDI | Push-button file system verification |
| Amani, S., et al., "Cogent" (2019) | JFP | Verified systems programming language |
| Ernst, G., et al., "Verified B-Trees" (2015) | STTT | Formal B-tree verification |
| Chajed, T., Tassarotti, J., Kaashoek, M. F., Zeldovich, N., "Verifying Concurrent, Crash-Safe Systems with Perennial", *SOSP*, 2019 | SOSP | Concurrent crash-safe verification |
| Hawblitzel, C., et al., "IronFleet" (2015) | SOSP | Verified distributed systems |
| Gu, R., et al., "CertiKOS" (2016) | OSDI | Verified concurrent OS kernel |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Type-safe query language | 3-4 | High — eliminates injection by construction | Phase 1 |
| Write-ahead log verification | 4-6 | High — FSCQ methodology | Phase 2 |
| B-tree index verification | 4-6 | Medium — complex invariants | Phase 2 |
| ACID atomicity proof | 3-4 | High — Crash Hoare Logic | Phase 3 |
| Concurrent transaction verification | 6-8 | Medium — serializability proofs | Phase 3 |
| Query optimizer verification | 4-6 | Medium — equivalence checking | Phase 4 |
| Crash recovery proof | 4-6 | Medium — complex state machine | Phase 4 |

## 7. Scope Limitations

1. **Performance gap.** Verified storage implementations are typically 2-10x slower than optimized unverified databases. The verification constraint limits available optimizations.
2. **Schema flexibility.** The type-safe query approach requires fixed schemas at compile time, making dynamic schema changes more difficult than in traditional databases.
3. **Distributed transactions.** Verifying distributed ACID (2PC, Paxos-based commit) is significantly harder than single-node ACID. Cross-shard transactions are deferred.
4. **Crash model limitations.** The crash model assumes atomic disk sector writes. Real hardware may have torn writes or silent data corruption, requiring additional verification.
5. **No verified SQL parser.** The type-safe query language avoids SQL entirely. Legacy SQL compatibility requires an unverified translation layer.

---

*"Data is not stored. Data is PROVEN durable."*
