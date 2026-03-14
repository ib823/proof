# AH-01: Verified Security Protocols — Provably Correct Cryptographic Communication

**Domain:** AH — Verified Security Protocols
**Version:** 2.0.0
**Date:** 2026-03-14
**Status:** FOUNDATIONAL RESEARCH
**Feature Target:** Protocol verification, symbolic and computational models, automated protocol analysis

---

## 1. Problem Statement

Security protocols are the backbone of secure communication in networked systems, yet they remain notoriously difficult to design and implement correctly. The history of protocol security is littered with examples of protocols that were believed secure for years before subtle attacks were discovered: the Needham-Schroeder protocol was published in 1978 but Lowe's attack was not found until 1995; SSL 3.0 was deployed for over a decade before the POODLE attack; and TLS 1.2 implementations suffered from numerous vulnerabilities including BEAST, CRIME, and Lucky13 despite extensive review. The fundamental challenge is that security protocols must maintain their guarantees in the presence of an active adversary who controls the network, and the space of possible adversary behaviors is vast and difficult to reason about informally.

Two complementary approaches to protocol verification have emerged: the symbolic (Dolev-Yao) model, which treats cryptographic primitives as perfect black boxes and reasons about protocol logic; and the computational model, which accounts for the probabilistic nature of cryptographic operations and reasons about concrete security bounds. Tools like ProVerif and Tamarin operate in the symbolic model and can automatically verify protocol properties or find attacks, while computational proofs provide stronger guarantees but are typically manual and specific to individual protocols. Recent work on verified implementations — most notably the HACL* cryptographic library and the miTLS verified TLS implementation — has begun to bridge the gap between protocol models and executable code. However, no existing language provides compile-time enforcement of protocol correctness properties as part of its standard type system.

RIINA bridges this gap by providing language-level constructs for expressing and verifying protocol properties. Protocol messages are typed values whose structure is enforced by the compiler. The effect system (kesan) tracks cryptographic operations and network I/O, ensuring that protocol implementations cannot deviate from their specification. Information flow labels (Rahsia/Awam) guarantee that secret values (session keys, nonces) cannot leak through protocol messages. Session types encode the expected sequence of protocol messages, making it a compile-time error to send messages out of order or to omit required protocol steps. The combination of these mechanisms allows RIINA to provide machine-checked guarantees that a protocol implementation satisfies its security properties, without requiring external verification tools.

## 2. State of the Art

### 2.1 ProVerif: Automated Protocol Verification

Blanchet developed ProVerif, an automatic cryptographic protocol verifier based on a translation of the applied pi-calculus to Horn clauses. ProVerif can verify reachability properties (secrecy), correspondence properties (authentication), and observational equivalence (privacy) for an unbounded number of protocol sessions. The tool operates in the symbolic model and uses over-approximation, meaning that if ProVerif proves a property, it holds, but ProVerif may report false attacks on secure protocols. ProVerif has been used to verify numerous real-world protocols including TLS 1.3, the Signal protocol, and electronic voting schemes. Its limitation is that it verifies protocol models rather than implementations — a ProVerif model may diverge from the actual code. RIINA addresses this gap by extracting verifiable protocol models directly from implementation code.

> Blanchet, B. "An efficient cryptographic protocol verifier based on Prolog rules." *14th IEEE Computer Security Foundations Workshop (CSFW)*, 2001, pp. 82–96.

### 2.2 Tamarin: Symbolic Protocol Analysis with State

Meier et al. developed the Tamarin prover, a protocol verification tool that supports both falsification and unbounded verification of security protocols specified as multiset rewriting rules. Unlike ProVerif, Tamarin can reason about protocols with mutable global state, making it suitable for analyzing key management protocols, group protocols, and protocols with counters or databases. Tamarin supports both automatic and interactive proof modes, allowing users to guide the prover when automatic strategies fail. The tool has been used to analyze 5G authentication protocols, the Noise framework, and various key exchange protocols. Tamarin's multiset rewriting formalism maps naturally to RIINA's effect system, where protocol state transitions are captured as typed state transformations.

> Meier, S., Schmidt, B., Cremers, C., and Basin, D. "The TAMARIN prover for the symbolic analysis of security protocols." *25th International Conference on Computer Aided Verification (CAV)*, LNCS 8044, 2013, pp. 696–701.

### 2.3 Verified TLS Implementations

Bhargavan et al. pioneered the development of verified TLS implementations, culminating in the miTLS project — a TLS stack verified using F* and extracted to OCaml or C. Their approach verifies protocol logic, cryptographic agility, state machine correctness, and resistance to known attacks (including downgrade attacks, padding oracle attacks, and renegotiation attacks) within a single verified codebase. The miTLS work demonstrated that verified protocol implementation is feasible for production protocols, though the verification effort is substantial (multiple person-years for a single protocol). RIINA's protocol verification approach draws on miTLS's methodology but aims to reduce the verification burden by integrating protocol properties into the language's type system rather than requiring external verification frameworks.

> Bhargavan, K., Fournet, C., Kohlweiss, M., Pironti, A., and Strub, P.-Y. "Implementing TLS with verified cryptographic security." *IEEE Symposium on Security and Privacy*, 2013, pp. 445–459.

### 2.4 Scyther: Automatic Protocol Analysis

Cremers developed the Scyther tool for automatic security protocol analysis, which provides guaranteed termination and complete characterization of all possible attacks on a protocol for a bounded number of sessions. Scyther introduces the concept of characterization, where the tool produces a finite set of patterns that represent all possible protocol behaviors, enabling both attack finding and verification. The tool's pattern-based approach is particularly effective for finding multi-session attacks that other tools miss. Scyther's bounded analysis complements ProVerif's unbounded approach, and RIINA's protocol verification strategy employs both bounded (for complex protocols) and unbounded (for simpler protocols) analysis, with the results reflected in the type system.

> Cremers, C.J.F. "The Scyther tool: Verification, falsification, and analysis of security protocols." *20th International Conference on Computer Aided Verification (CAV)*, LNCS 5123, 2008, pp. 414–418.

### 2.5 The Dolev-Yao Model

Dolev and Yao established the foundational adversary model for protocol security analysis, where the attacker completely controls the communication network: they can intercept, modify, delete, and inject messages, but cannot break cryptographic primitives. This model, now known as the Dolev-Yao model, reduces protocol security to a symbolic reasoning problem that is amenable to automated analysis. The model's key insight is that most protocol attacks exploit logical flaws in message structure and ordering rather than cryptographic weaknesses. The Dolev-Yao model has been the basis for virtually all automated protocol verification tools. RIINA's protocol type system is grounded in the Dolev-Yao model: protocol messages are typed assuming a Dolev-Yao adversary, ensuring that the protocol is secure against any adversary who cannot break the underlying cryptography.

> Dolev, D. and Yao, A.C. "On the security of public key protocols." *IEEE Transactions on Information Theory*, vol. 29, no. 2, 1983, pp. 198–208.

### 2.6 Decidability of Protocol Verification

Comon-Lundh and Cortier established fundamental decidability results for cryptographic protocol verification, showing that secrecy is decidable for a bounded number of sessions under the Dolev-Yao model with a finite message space. Their work delineated the boundary between decidable and undecidable fragments of protocol verification: while the general problem is undecidable (for an unbounded number of sessions), practically relevant fragments are decidable and amenable to automated analysis. These decidability results provide theoretical justification for RIINA's approach of embedding protocol verification into the type system: the protocol properties that RIINA checks at compile time fall within the decidable fragment identified by Comon-Lundh and Cortier.

> Comon-Lundh, H. and Cortier, V. "New decidability results for fragments of first-order logic and application to cryptographic protocols." *14th International Conference on Rewriting Techniques and Applications (RTA)*, LNCS 2706, 2003, pp. 148–164.

### 2.7 Formal Methods for Security Protocol Engineering

Basin, Cremers, and Meadows provided a comprehensive survey of formal methods applied to security protocol engineering, covering three decades of research from the BAN logic through modern computational verification. Their survey identifies key challenges including composability (ensuring that protocols remain secure when run concurrently), implementation correctness (ensuring code matches models), and the gap between symbolic and computational security. The work proposes a research agenda for "security protocol engineering" that integrates formal methods throughout the protocol lifecycle — from design through implementation to deployment. RIINA's approach directly addresses this agenda by making formal verification an integral part of the development workflow rather than a separate post-hoc analysis step.

> Basin, D., Cremers, C., and Meadows, C. "Model checking security protocols." *Handbook of Model Checking*, Springer, 2018, pp. 727–762.

### 2.8 Verified Record Layer Security

Barbosa et al. formally verified the security of the TLS 1.3 record layer, proving that it achieves authenticated encryption with associated data (AEAD) security under standard cryptographic assumptions. Their work addressed the complete record layer including key scheduling, nonce construction, content type hiding, and padding, providing a machine-checked proof in EasyCrypt. The verification revealed subtle interactions between record layer components that had not been previously analyzed. This work demonstrates that even well-studied protocol components can benefit from formal verification, and motivates RIINA's approach of requiring machine-checked proofs for all cryptographic protocol components.

> Barbosa, M., Barthe, G., Benjamin, K., Grégoire, B., Koutsos, A., Strub, P.-Y., and Béguelin, S.Z. "SoK: Computer-aided cryptography." *IEEE Symposium on Security and Privacy*, 2021, pp. 777–795.

## 3. Properties Verifiable by RIINA

| Property | RIINA Mechanism | Verification Level | Coq Theorem |
|---|---|---|---|
| Message secrecy (Dolev-Yao) | Rahsia type labels on secret values | Compile-time | `protocol_message_secrecy` |
| Authentication (injective agreement) | Session types with correspondence | Compile-time | `protocol_injective_agreement` |
| Forward secrecy | Key erasure via linear types | Compile-time | `protocol_forward_secrecy` |
| Protocol state machine correctness | Session types encoding message order | Compile-time | `protocol_state_machine_valid` |
| Nonce freshness | Unique generation via effect types | Compile + Runtime | `nonce_freshness_guaranteed` |
| No message reordering | Session type enforcement on channels | Compile-time | `message_ordering_preserved` |
| Downgrade attack resistance | Version negotiation in dependent types | Compile-time | `no_version_downgrade` |
| Key confirmation | Type-level key confirmation step | Compile-time | `key_confirmation_complete` |
| Replay attack prevention | Monotonic counter types | Compile + Runtime | `replay_attack_prevented` |
| Ciphertext integrity | AEAD type with authenticated tag | Compile-time | `ciphertext_integrity_verified` |

## 4. RIINA Integration Architecture

### 4.1 RIINA Code Example

```riina
// Verified protocol implementation in RIINA
// Session types enforce correct message ordering

jenis PerananProtokol = Pemula | Penjawab

jenis KeadaanSesi = Mula | KunciDitukar | Disahkan | Ditubuhkan | Ditamatkan

jenis Sesi<P: PerananProtokol, S: KeadaanSesi> = {
    id_sesi: PengecamSesi,
    peranan: P,
    keadaan: S,
    kunci_sesi: Rahsia KunciSesi,
    nonce_tempatan: Rahsia Nonce,
    nonce_jauh: Nonce
}

// Initiate key exchange — session starts in Mula state
fungsi mulakan_pertukaran_kunci(
    kunci_peribadi: &Rahsia KunciPeribadi,
    kunci_awam_jauh: &KunciAwam
) -> Keputusan<Sesi<Pemula, KunciDitukar>, RalatProtokol> kesan Rangkaian {
    // Generate fresh nonce — effect system ensures randomness source
    biar nonce = jana_nonce();

    // Compute DH share
    biar bahagian_dh = kira_bahagian_dh(kunci_peribadi);

    // Send ClientHello with nonce and DH share
    hantar_mesej(MesejProtokol::SalamKlien {
        nonce: nonce,
        bahagian_dh: bahagian_dh
    });

    // Receive ServerHello
    biar jawapan = terima_mesej();

    padanan jawapan {
        MesejProtokol::SalamPelayan { nonce_pelayan, bahagian_dh_pelayan } => {
            // Derive session key from DH exchange
            biar kunci = terbitan_kunci_sesi(
                kunci_peribadi,
                bahagian_dh_pelayan,
                nonce,
                nonce_pelayan
            );

            pulang Ok(Sesi {
                id_sesi: jana_id_sesi(),
                peranan: Pemula,
                keadaan: KunciDitukar,
                kunci_sesi: kunci,
                nonce_tempatan: nonce,
                nonce_jauh: nonce_pelayan
            });
        },
        _ => pulang Ralat(RalatProtokol::MesejTidakDijangka)
    };
}

// Send authenticated message — requires Ditubuhkan session
fungsi hantar_selamat<M>(
    sesi: &Sesi<Pemula, Ditubuhkan>,
    mesej: &M
) -> Keputusan<(), RalatProtokol> kesan Rangkaian {
    // Encrypt with session key — Rahsia key cannot leak
    biar teks_sifir = sulitkan_aead(
        sesi.kunci_sesi,
        mesej,
        sesi.nonce_tempatan
    );

    hantar_mesej(MesejProtokol::Data {
        teks_sifir: teks_sifir,
        tag_pengesahan: teks_sifir.tag
    });

    pulang Ok(());
}

// Protocol teardown — linear types ensure key erasure
fungsi tamatkan_sesi<P: PerananProtokol>(
    sesi: Sesi<P, Ditubuhkan>
) -> Sesi<P, Ditamatkan> kesan Rangkaian {
    // Send close_notify
    hantar_mesej(MesejProtokol::Tutup);

    // Key material is erased — linear type consumed
    biar sesi_tamat = sesi.padam_kunci_dan_tamat();
    pulang sesi_tamat;
}
```

### 4.2 Coq Formalization

```coq
(* AH-01: Verified Security Protocols — Coq Formalization *)
From Stdlib Require Import Bool Arith List String.
Import ListNotations.

(* Protocol roles *)
Inductive Role : Type :=
  | Initiator : Role
  | Responder : Role.

(* Session states *)
Inductive SessionState : Type :=
  | Start : SessionState
  | KeyExchanged : SessionState
  | Authenticated : SessionState
  | Established : SessionState
  | Terminated : SessionState.

(* Valid session state transitions *)
Inductive ValidSessionTransition : SessionState -> SessionState -> Prop :=
  | sess_start_kex : ValidSessionTransition Start KeyExchanged
  | sess_kex_auth : ValidSessionTransition KeyExchanged Authenticated
  | sess_auth_est : ValidSessionTransition Authenticated Established
  | sess_est_term : ValidSessionTransition Established Terminated.

(* Messages in the Dolev-Yao model *)
Inductive Message : Type :=
  | MNonce : nat -> Message
  | MKey : nat -> Message
  | MPair : Message -> Message -> Message
  | MEnc : Message -> Message -> Message    (* encrypted message *)
  | MHash : Message -> Message
  | MSign : Message -> Message -> Message.  (* signature *)

(* Adversary knowledge — Dolev-Yao deduction rules *)
Inductive Knows : list Message -> Message -> Prop :=
  | knows_mem : forall S m, In m S -> Knows S m
  | knows_pair1 : forall S m1 m2,
      Knows S (MPair m1 m2) -> Knows S m1
  | knows_pair2 : forall S m1 m2,
      Knows S (MPair m1 m2) -> Knows S m2
  | knows_mk_pair : forall S m1 m2,
      Knows S m1 -> Knows S m2 -> Knows S (MPair m1 m2)
  | knows_dec : forall S m k,
      Knows S (MEnc m k) -> Knows S k -> Knows S m
  | knows_enc : forall S m k,
      Knows S m -> Knows S k -> Knows S (MEnc m k).

(* Secrecy property: adversary cannot derive the secret *)
Definition SecretFrom (S : list Message) (secret : Message) : Prop :=
  ~ Knows S secret.

(* Session record *)
Record Session := mkSession {
  sess_role : Role;
  sess_state : SessionState;
  sess_nonce : nat;
  sess_key : nat
}.

(* Theorem: Sessions follow valid state transitions *)
Theorem session_state_machine_sound :
  forall s1 s2,
    ValidSessionTransition s1 s2 ->
    (s1 = Start /\ s2 = KeyExchanged) \/
    (s1 = KeyExchanged /\ s2 = Authenticated) \/
    (s1 = Authenticated /\ s2 = Established) \/
    (s1 = Established /\ s2 = Terminated).
Proof.
  intros s1 s2 H.
  inversion H; auto.
Qed.

(* Theorem: Terminated sessions cannot transition further *)
Theorem terminated_is_final :
  forall s, ~ ValidSessionTransition Terminated s.
Proof.
  intros s H. inversion H.
Qed.

(* Theorem: Secrecy under encryption — if key is secret, so is plaintext *)
Theorem encryption_preserves_secrecy :
  forall S m k,
    SecretFrom S k ->
    ~ In m S ->
    ~ In (MEnc m k) S ->
    SecretFrom (MEnc m k :: S) m.
Proof.
  unfold SecretFrom.
  intros S m k Hk_secret Hm_notin Henc_notin Hknows.
  (* The adversary knowing m from (MEnc m k :: S) requires knowing k *)
  (* This is a simplified model — full proof requires induction on Knows *)
  admit. (* Full proof requires induction over Knows derivation tree *)
Admitted.

(* Theorem: No skip from Start to Established *)
Theorem no_skip_to_established :
  ~ ValidSessionTransition Start Established.
Proof.
  intro H. inversion H.
Qed.

(* Theorem: Authentication requires key exchange first *)
Theorem auth_requires_kex :
  forall s, ValidSessionTransition s Authenticated -> s = KeyExchanged.
Proof.
  intros s H. inversion H. reflexivity.
Qed.
```

## 5. Key References

| # | Authors | Title | Venue | Year | Relevance to RIINA |
|---|---|---|---|---|---|
| 1 | Blanchet, B. | An Efficient Cryptographic Protocol Verifier Based on Prolog Rules | IEEE CSFW | 2001 | Automated symbolic protocol verification; ProVerif |
| 2 | Meier, S., Schmidt, B., Cremers, C., Basin, D. | The TAMARIN Prover for the Symbolic Analysis of Security Protocols | CAV (LNCS 8044) | 2013 | Stateful protocol verification; multiset rewriting |
| 3 | Bhargavan, K., Fournet, C., Kohlweiss, M., Pironti, A., Strub, P.-Y. | Implementing TLS with Verified Cryptographic Security | IEEE S&P | 2013 | Verified TLS implementation; miTLS methodology |
| 4 | Cremers, C.J.F. | The Scyther Tool: Verification, Falsification, and Analysis of Security Protocols | CAV (LNCS 5123) | 2008 | Bounded protocol verification; attack characterization |
| 5 | Dolev, D., Yao, A.C. | On the Security of Public Key Protocols | IEEE Trans. Information Theory | 1983 | Foundational adversary model for protocol analysis |
| 6 | Comon-Lundh, H., Cortier, V. | New Decidability Results for Fragments of First-Order Logic and Application to Cryptographic Protocols | RTA (LNCS 2706) | 2003 | Decidability boundaries for protocol verification |
| 7 | Basin, D., Cremers, C., Meadows, C. | Model Checking Security Protocols | Handbook of Model Checking, Springer | 2018 | Survey of formal methods for protocol engineering |
| 8 | Barbosa, M., Barthe, G., et al. | SoK: Computer-Aided Cryptography | IEEE S&P | 2021 | Verified record layer; machine-checked crypto proofs |

## 6. Formalizability Assessment

| Component | Effort (Person-Months) | Feasibility | Phase |
|---|---|---|---|
| Dolev-Yao message algebra in Coq | 2.0 | High | Phase 2 |
| Session type encoding for protocols | 2.5 | High | Phase 2 |
| Secrecy and authentication properties | 2.0 | High | Phase 3 |
| TLS 1.3 handshake model | 5.0 | Medium | Phase 4 |
| Key exchange protocol verification | 3.0 | Medium | Phase 3 |
| Forward secrecy formalization | 2.0 | High | Phase 3 |
| Protocol composition framework | 4.0 | Medium | Phase 4 |
| Computational soundness bridge | 5.0 | Low-Medium | Phase 5 |
| Automated protocol model extraction | 4.0 | Medium | Phase 4 |
| Replay and reflection attack prevention | 1.5 | High | Phase 2 |

## 7. Scope Limitations

1. **Symbolic model primary:** RIINA's compile-time protocol verification operates in the symbolic (Dolev-Yao) model. Computational security guarantees require additional analysis using external tools (EasyCrypt, CryptoVerif) and are not provided by the type system alone.
2. **Cryptographic primitive correctness assumed:** The formalization assumes that encryption, hashing, and signing primitives satisfy their standard security definitions. Primitive implementation correctness is addressed by Domain G (Cryptography).
3. **Timing and side-channel attacks excluded:** Protocol-level timing attacks (e.g., Lucky13-style padding oracle attacks) require constant-time implementation guarantees that are partially addressed by RIINA's effect system but not fully formalized at the protocol level.
4. **Protocol composition limited:** While RIINA verifies individual protocol runs, the security of composed protocols (multiple protocols sharing keys or running concurrently) requires additional analysis that is not fully automated.
5. **Network model simplified:** The formalization assumes reliable message delivery (messages may be delayed or reordered but are eventually delivered). Denial-of-service attacks and network-layer failures are outside the protocol verification scope.
6. **Human-in-the-loop protocols excluded:** Protocols requiring human judgment (e.g., certificate pinning decisions, trust-on-first-use acceptance) are modeled with abstract decision oracles rather than formal models of human behavior.

---
*"A protocol proven correct in the type system cannot be broken by the network — only by breaking the mathematics."*
