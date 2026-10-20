# JALINAN Guide

JALINAN (Jaringan Autonomi, Logik Integrasi, Notari, Aktor, Nod) is RIINA's
surface for distributed programs: actors, choreographies, content hashing and
CRDT merge. This page says what each one does in the shipped compiler today,
and what is proven about it and where.

Every `riina` block below is checked by the test suite
(`03_PROTO/crates/riinac/tests/doc_snippets.rs`).

## What is proven, and what is not

- **Proven in Coq, about models.** Actor semantics (`domains/ActorCalculus.v`,
  `domains/ActorSupervision.v`), choreography projection and deadlock freedom
  (`domains/ChoreographyTypes.v`, `domains/ChoreographyProjection.v`), CRDT merge
  laws (`domains/CRDTFoundations.v`: `gc_merge_comm` and its siblings) and
  content-addressed state (`domains/MerkleDAG.v`, `domains/ContentAddressedState.v`).
  These are theorems about each file's own definitions; the project counts them
  as model results, not as guarantees about the compiler.
- **Not proven.** That `riinac` implements those models. The compiler's
  choreography projection *mirrors* the Coq definitions; it is tested, not
  verified.
- **Backends.** Which constructs run on the interpreter, C and WASM is stated
  only in the generated builtin matrix, [docs/api/STDLIB.md](api/STDLIB.md).

## Actors

```riina
pelaku Pembilang {
    keadaan: Nombor
    kendalikan Tambah(n) {
        n + 1
    }
}

biar k = lahir Pembilang(0);   // spawn, with initial state 0
hantar(k, 5);                  // send 5
terima(k)                      // receive the reply: 6
```

- `pelaku` declares an actor type, `keadaan` its state and `kendalikan` a
  message handler.
- `lahir` spawns an instance, `hantar` sends it a message and `terima` waits for
  the reply.
- A handler cannot read `keadaan` yet: the checker reports
  `Variable not found: keadaan`. Stateful handlers are part of the example
  corpus work (REQ-55).

## Choreography

A choreography is a protocol between named roles. The compiler projects it to
each role's local session type and checks that the projections fit.

```riina
koreografi Pembelian {
    peranan Pemohon, Pelulus;

    Pemohon -> Pelulus: hantar Nombor;
    Pelulus -> Pemohon: hantar Benar;
    tamat;
}
```

- `koreografi` defines the protocol and `peranan` its roles.
- `A -> B: hantar T;` sends a value of type `T` from `A` to `B`; `tamat` ends it.

Deadlock freedom is proven in Coq for the session calculus (`ST_020` in
`domains/SessionTypes.v`, `CT_117_choreography_deadlock_free` in
`domains/ChoreographyTypes.v`). The compiler's projection
(`project_choreography` / `multiparty::project` in `riina-typechecker`) follows
those definitions but is not a verified compiler: for that bar, see Kalas, a
choreographic language with an end-to-end verified compiler to CakeML. RIINA
also has no session-channel operations in source yet, so the projected local
type is checked, not a sequence of channel operations.

## Content addressing

```riina
fungsi semak() -> Benar kesan Kripto {
    biar data = "Maklumat penting";
    biar cap = cincang(data);   // hash the data
    sahkan(cap, data)           // re-hash and compare: betul
}
```

- `cincang` hashes a value and `sahkan` checks a value against a hash. Both
  need the `Kripto` effect.
- The hash comes from RIINA's own cryptography, which is experimental and has
  not been externally audited.

## CRDTs

`gabung` is the CRDT merge form, and its laws (commutative, associative,
idempotent) are proven in Coq for the model's counters. **It cannot be used from
a program yet:** no source syntax produces a CRDT value, so
`07_EXAMPLES/08_jalinan/crdt_merge.rii` fails `riinac check` with
`Expected CRDT type, found Int`. Making it usable is tracked as REQ-55.

## Examples

`07_EXAMPLES/08_jalinan/` holds the examples. Not all of them pass
`riinac check` yet; run it on a file to see. The ones that fail are tracked
under REQ-55.
