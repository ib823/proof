# Paper 4: Session Types for Distributed Actors in RIINA

## Abstract

We formalize RIINA's actor system (JALINAN) using multiparty session types
and choreographic programming. RIINA actors communicate via typed message
channels with compile-time protocol verification. We prove deadlock freedom,
protocol fidelity, and communication safety for choreography-projected
actor systems, mechanized in Coq.

**Scope of the claim (2026-08-05, REQ-52).** The theorems below are about the
*session calculus* mechanized in Coq (`ChoreographyTypes.v`,
`ChoreographyProjection.v`). The projection the shipped compiler performs is a
Rust implementation written to mirror those Coq definitions — it is **not** a
verified compiler, and no theorem connects the Rust projection's output to the
Coq calculus. The stronger bar exists in the literature: Kalas (Pohjola et al.,
ITP 2022) is a choreographic language with an end-to-end *verified* compiler to
CakeML, including verified endpoint projection; hacc does certified
choreography compilation. RIINA's claim is therefore "mechanized calculus +
mirroring implementation", not "verified compilation".

## Key Results

- **Theorem: Deadlock Freedom** — Well-typed choreographies projected to
  actors cannot deadlock, provided all roles participate.
- **Theorem: Protocol Fidelity** — Actor message exchanges conform to their
  declared choreography protocol at every step.
- **Theorem: Communication Safety** — Messages sent by one actor are always
  of the type expected by the receiver.
- **Theorem: Consensus Safety** — No two honest nodes disagree on committed
  values. Coq reference: `consensus_safety`
- **Theorem: Consensus Liveness** — Valid transactions are eventually included.
  Coq reference: `consensus_liveness`

## Actor Model

- `pelakon` — actor declaration with typed state
- `hantar` / `terima` — typed send/receive
- `lahir` — spawn with initial state
- `koreografi` — global interaction protocol
- `peranan` — role within choreography
- `penyelia` — supervision tree for fault tolerance

## Related Work (Sketch)

- Honda, Yoshida & Carbone (2016) — Multiparty asynchronous session types
- Scalas & Yoshida (2019) — Less is more: multiparty session types revisited
- De Alfaro & Henzinger (2001) — Interface automata
- Agha (1986) — Actors: a model of concurrent computation

## Venue Target

**CONCUR** (International Conference on Concurrency Theory)
or **ESOP** (European Symposium on Programming)

## Coq Source Files

- `02_FORMAL/coq/sessions/` (session type proofs)
- `02_FORMAL/coq/actors/` (actor model proofs)
- `02_FORMAL/coq/blockchain/Consensus.v`
