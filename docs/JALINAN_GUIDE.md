# JALINAN Guide

JALINAN (Jaringan Autonomi, Logik Integrasi, Notari, Aktor, Nod) is RIINA's distributed computing framework. It unifies five concepts under formal verification.

## The 5 Unifications

1. **Code = Security** — Security properties are part of the type system, not separate middleware
2. **Session-Typed Protocols** — Communication follows type-checked session types; no malformed messages
3. **Content-Addressed State** — All state is Merkle-hashed; every change is traceable and tamper-evident
4. **Actors + Supervision** — Lightweight actors with fault-tolerant supervision trees
5. **Formal Verification** — All distributed properties proven at compile time via Coq/Lean

## Quick Start: Actors

### Define an Actor

```riina
pelakon Pembilang {
    keadaan: Nombor
    kendalikan Tambah(n) {
        n + keadaan
    }
}
```

- `pelakon` — declares an actor type
- `keadaan` — actor's internal state
- `kendalikan` — message handler

### Spawn, Send, Receive

```riina
biar k = lahir Pembilang(0);   // Spawn with initial state 0
hantar(k, 10);                  // Send message 10
biar hasil = terima(k);         // Receive result
```

- `lahir` — spawn a new actor instance
- `hantar` — send a message to an actor
- `terima` — receive (await) the actor's response

## Choreography

Choreographic programming makes multi-party protocols deadlock-free by construction — **at
the level RIINA proves it**: the deadlock-freedom theorems are mechanized in Coq over the
session calculus (`ST_020`/`CT_117`: 2-party projection duality ⇒ deadlock-free), and the
compiler's projection (`riina-typechecker`'s `project_choreography`/`multiparty::project`)
*mirrors* those Coq definitions. The projection implementation itself is **not** a verified
compiler — for that stronger bar, see Kalas (a choreographic language with an end-to-end
verified compiler to CakeML, including verified endpoint projection), which is the state of
the art RIINA does not yet meet. Per-statement channel-operation checking also does not
exist yet (RIINA has no session-channel surface operations; the projected local *type* is
checked, not an operation sequence).

```riina
koreografi Pembelian {
    peranan Pembeli, Penjual, Eskrow;

    Pembeli -> Eskrow: deposit(jumlah);
    Penjual -> Pembeli: hantar_barang(item);
    Eskrow -> Penjual: lepas_bayaran(jumlah);
}
```

- `koreografi` — defines a multi-party protocol
- `peranan` — declares participant roles
- `->` — directed message flow between roles

## Content-Addressing

Every value can be content-addressed for tamper evidence.

```riina
biar data = "Maklumat penting";
biar hash = cincang(data);           // Hash the data
sahkan(hash, data);                   // Verify integrity
```

- `cincang` — compute content hash
- `sahkan` — verify data matches a hash

## CRDTs (Conflict-Free Replicated Data Types)

Distributed state that merges without conflicts.

```riina
biar a = kaunter(5);
biar b = kaunter(3);
biar gabungan = gabung(a, b);    // Merge: result is 8
```

- `gabung` — merge two CRDT values (commutative, associative, idempotent)

## Examples

See `07_EXAMPLES/08_jalinan/` for complete working examples:

- `actor_simple.rii` — Minimal actor
- `actor_counter.rii` — Counter actor
- `distributed_counter.rii` — Multi-node distributed counter
- `choreography_basic.rii` — Multi-party protocol
- `content_hash.rii` — Content addressing
- `merkle_audit.rii` — Merkle audit trail
- `crdt_merge.rii` — CRDT merge operations
- `session_types.rii` — Session-typed channels
- `supervisor.rii` — Supervision trees
- `syariah_escrow.rii` — Syariah-compliant escrow
