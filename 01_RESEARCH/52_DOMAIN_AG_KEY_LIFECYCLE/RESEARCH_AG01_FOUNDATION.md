# AG-01: Verified Key Lifecycle Management — Provably Correct Cryptographic Key Handling

**Domain:** AG — Verified Key Lifecycle Management
**Version:** 2.0.0
**Date:** 2026-03-14
**Status:** FOUNDATIONAL RESEARCH
**Feature Target:** Key generation, distribution, rotation, revocation, escrow, HSM integration

---

## 1. Problem Statement

Cryptographic key management is widely recognized as the most challenging aspect of applied cryptography. While the mathematical foundations of modern cryptographic algorithms are well understood and extensively analyzed, the lifecycle management of the keys these algorithms depend upon remains a persistent source of catastrophic failures. Key generation with insufficient entropy, improper key storage exposing material to unauthorized access, failure to rotate keys on schedule, delayed or incomplete revocation of compromised keys, and insecure key distribution protocols have each independently caused significant security breaches. The 2011 RSA SecurID breach, the Heartbleed-induced mass key compromise, and numerous certificate authority failures all trace their root causes not to cryptographic weakness but to key management failures.

Current key management standards, notably NIST SP 800-57 and its companion documents, provide comprehensive guidance on key lifecycle management. However, these standards are expressed as natural-language recommendations that must be manually translated into code by each implementor. This translation process is error-prone: developers may misunderstand the standard, implement it partially, or introduce subtle bugs that violate key management invariants without producing obvious failures. Threshold cryptography schemes like Shamir's secret sharing and threshold ECDSA add further complexity, requiring careful coordination between multiple parties that is difficult to verify through testing alone. The gap between key management policy and implementation is a fundamental vulnerability in the security infrastructure of every organization.

RIINA addresses this challenge by encoding key lifecycle invariants directly into the type system. A cryptographic key in RIINA is not merely an opaque byte array — it is a typed value whose lifecycle state (generated, distributed, active, suspended, revoked, destroyed) is tracked by the compiler. The Rahsia (Secret) type label ensures that key material cannot leak to Awam (Public) contexts. Effect annotations (kesan) guarantee that key operations interact with hardware security modules through verified interfaces. State machine transitions in the key lifecycle are encoded as type-level transitions, making it impossible to use a revoked key for signing or to distribute a key without proper authorization. These guarantees compose: a system built from RIINA-verified key management components inherits the lifecycle correctness properties of each component.

## 2. State of the Art

### 2.1 Shamir's Secret Sharing

Shamir introduced the concept of (t,n)-threshold secret sharing, where a secret is divided into n shares such that any t shares can reconstruct the secret but fewer than t shares reveal no information about it. This information-theoretically secure scheme is foundational to modern key management, enabling key escrow, backup, and distributed trust without single points of failure. Shamir's scheme is based on polynomial interpolation over finite fields: the secret is the constant term of a random polynomial of degree t-1, and shares are evaluations of this polynomial at distinct non-zero points. The scheme's perfect secrecy property — that any t-1 shares provide zero information about the secret — makes it the gold standard for secret distribution. RIINA's formalization of secret sharing ensures that share generation, distribution, and reconstruction maintain these information-theoretic guarantees through type-level tracking of share counts and reconstruction thresholds.

> Shamir, A. "How to share a secret." *Communications of the ACM*, vol. 22, no. 11, 1979, pp. 612–613.

### 2.2 Identity-Based Encryption

Boneh and Franklin proposed the first practical identity-based encryption (IBE) scheme based on bilinear pairings on elliptic curves, enabling encryption to arbitrary identities (email addresses, names) without requiring prior distribution of public keys. IBE fundamentally changes the key distribution problem: rather than requiring a public key infrastructure (PKI) with certificates, a trusted key generation center (KGC) issues private keys to users based on their identity. This simplifies key management but introduces new challenges around KGC trust, key escrow (the KGC can decrypt all messages), and identity revocation. The Boneh-Franklin scheme's security is proven in the random oracle model under the Bilinear Diffie-Hellman assumption. RIINA's type system can encode the trust assumptions of IBE schemes, ensuring that applications using IBE correctly handle the inherent key escrow property and implement appropriate revocation mechanisms.

> Boneh, D. and Franklin, M. "Identity-based encryption from the Weil pairing." *CRYPTO 2001, LNCS 2139*, 2001, pp. 213–229.

### 2.3 NIST Key Management Guidelines

NIST Special Publication 800-57 provides comprehensive recommendations for key management across the full key lifecycle, covering key generation, registration, distribution, storage, use, rotation, revocation, archival, and destruction. The three-part standard addresses general guidance (Part 1), best practices for organizational key management (Part 2), and application-specific key management guidance (Part 3). The 2020 revision incorporates guidance for post-quantum cryptographic transitions, emphasizing crypto-agility and the need for key management systems that can accommodate algorithm changes without architectural redesign. RIINA's key lifecycle state machine is directly informed by the NIST lifecycle model, with each state and transition formalized as a type-level construct that the compiler verifies.

> Barker, E. "Recommendation for key management: Part 1 — General." *NIST Special Publication 800-57 Part 1, Revision 5*, 2020.

### 2.4 Key Management Recommendations for Storage and Transit

Barker and Roginsky provided detailed guidance on cryptographic key management for data-at-rest and data-in-transit scenarios, addressing the specific challenges of key wrapping, key transport protocols, and key agreement mechanisms. Their work emphasizes the importance of key separation — using distinct keys for distinct purposes — and the risks of key reuse across different cryptographic contexts. The guidance establishes minimum key lengths for various algorithms through 2031 and beyond, and provides a framework for evaluating the security strength of key establishment methods. RIINA encodes key separation as a type-level constraint: a key typed for encryption cannot be used for signing, and a key designated for one protocol context cannot be used in another.

> Barker, E. and Roginsky, A. "Transitioning the use of cryptographic algorithms and key lengths." *NIST Special Publication 800-131A, Revision 2*, 2016.

### 2.5 Threshold ECDSA Signatures

Gennaro and Goldfeder developed a practical threshold ECDSA signing protocol that enables t-of-n parties to collaboratively generate ECDSA signatures without any single party having access to the complete signing key. Their protocol achieves security against malicious adversaries (not merely semi-honest) and requires only a constant number of rounds, making it practical for real-world deployment. Threshold ECDSA is critical for cryptocurrency custody, multi-party authorization, and distributed key management systems where no single entity should possess a complete signing key. The protocol's security is proven under the strong RSA assumption and the DDH assumption. RIINA's effect system can model the multi-party communication required by threshold protocols, ensuring that each party's local computation and message exchange follows the protocol specification.

> Gennaro, R. and Goldfeder, S. "Fast multiparty threshold ECDSA with fast trustless setup." *ACM Conference on Computer and Communications Security (CCS)*, 2018, pp. 1179–1194.

### 2.6 OpenPGP Key Management

Callas et al. defined the OpenPGP message format (RFC 4880), which includes a comprehensive key management framework based on the web-of-trust model. Unlike hierarchical PKI systems, OpenPGP allows users to certify each other's keys through a decentralized trust network, eliminating the need for centralized certificate authorities. The specification defines key packet formats, signature types (including key binding, certification, and revocation signatures), and key validity algorithms. OpenPGP's key management model has been operational for over three decades, providing extensive real-world experience with decentralized key lifecycle management. RIINA's formalization of key certification and trust path computation draws on the OpenPGP model, encoding trust transitivity and certification validity as type-level properties.

> Callas, J., Donnerhacke, L., Finney, H., Shaw, D., and Thayer, R. "OpenPGP message format." *RFC 4880*, 2007.

### 2.7 Trust Management for Key Certification

Blaze, Feigenbaum, and Lacy introduced the PolicyMaker system for decentralized trust management, which generalizes the concept of key certification beyond simple identity binding. PolicyMaker treats trust as a programmable policy: rather than a certificate asserting "key K belongs to entity E," a PolicyMaker credential asserts "key K is authorized to perform actions satisfying policy P." This approach enables flexible, fine-grained key authorization that can express complex trust relationships. The compliance checking problem — determining whether a set of credentials authorizes a particular action — is shown to be decidable for a broad class of policies. RIINA's type system for key authorization is informed by PolicyMaker's approach, encoding key usage policies as type-level constraints that are verified at compile time.

> Blaze, M., Feigenbaum, J., and Lacy, J. "Decentralized trust management." *IEEE Symposium on Security and Privacy*, 1996, pp. 164–173.

### 2.8 Protocols for Key Establishment

Boyd and Mathuria provided a comprehensive treatment of key establishment protocols, covering both key transport (where one party generates and distributes a key) and key agreement (where multiple parties jointly derive a shared key). Their systematic analysis encompasses symmetric-key, public-key, and hybrid protocols, with formal security models for each. The work introduces a unified framework for analyzing protocol security that accounts for forward secrecy, key compromise impersonation resistance, and unknown key-share attacks. Their taxonomy of key establishment protocols and their security properties directly informs RIINA's protocol verification framework, where key establishment protocol correctness is a type-level property that the compiler can check.

> Boyd, C. and Mathuria, A. *Protocols for Authentication and Key Establishment*. Springer, 2003.

## 3. Properties Verifiable by RIINA

| Property | RIINA Mechanism | Verification Level | Coq Theorem |
|---|---|---|---|
| Key lifecycle state machine correctness | Typestate pattern with linear types | Compile-time | `key_lifecycle_valid_transitions` |
| Key material confidentiality | Rahsia type label; no flow to Awam | Compile-time | `key_material_no_public_leak` |
| Key separation enforcement | Distinct key types per usage context | Compile-time | `key_usage_separation` |
| Threshold reconstruction correctness | Dependent types on share count vs threshold | Compile-time | `threshold_reconstruction_sound` |
| Key rotation monotonicity | Version counter in key metadata type | Compile-time | `key_rotation_monotone` |
| Revocation propagation completeness | Effect-tracked revocation broadcast | Compile + Runtime | `revocation_propagated_complete` |
| HSM interaction correctness | Kesan annotations for hardware effects | Compile-time | `hsm_interaction_correct` |
| Key derivation function domain separation | Type-level domain tag on KDF inputs | Compile-time | `kdf_domain_separation` |
| Entropy sufficiency for key generation | Effect-typed RNG with minimum entropy | Compile-time | `keygen_entropy_sufficient` |
| Key expiration enforcement | Temporal types with expiry metadata | Compile + Runtime | `expired_key_unusable` |

## 4. RIINA Integration Architecture

### 4.1 RIINA Code Example

```riina
// Verified key lifecycle management in RIINA
// Key states tracked at the type level — misuse is a compile error

jenis KeadaanKunci = Dijana | Diagih | Aktif | Digantung | Dibatalkan | Dimusnahkan

jenis Kunci<K: KeadaanKunci, G: KegunaanKunci> = {
    bahan: Rahsia Bait[],
    id: PengecamKunci,
    keadaan: K,
    kegunaan: G,
    dicipta: CapMasa,
    tamat_tempoh: CapMasa
}

jenis KegunaanKunci = Tandatangan | Penyulitan | PerjanjianKunci | BalutKunci

// Key generation — returns key in Dijana state only
fungsi jana_kunci<G: KegunaanKunci>(
    param: ParamPenjanaan,
    sumber_entropi: &Rahsia SumberEntropi
) -> Keputusan<Kunci<Dijana, G>, RalatKunci> kesan KesanHSM {
    // Entropy validation — type system ensures minimum entropy
    biar entropi = sumber_entropi.jana_bait(param.saiz_kunci);

    padanan sahkan_entropi(entropi, param.entropi_minimum) {
        Palsu => pulang Ralat(RalatKunci::EntropiTidakMencukupi),
        Benar => {}
    };

    biar bahan_kunci = terbitan_bahan_kunci(entropi, param);

    pulang Ok(Kunci {
        bahan: bahan_kunci,
        id: jana_id_kunci(),
        keadaan: Dijana,
        kegunaan: G,
        dicipta: masa_semasa(),
        tamat_tempoh: param.tamat_tempoh
    });
}

// Key activation — type-level state transition
fungsi aktifkan_kunci<G: KegunaanKunci>(
    kunci: Kunci<Dijana, G>,
    kebenaran: Rahsia TokenKebenaran
) -> Keputusan<Kunci<Aktif, G>, RalatKunci> kesan KesanHSM {
    padanan sahkan_kebenaran(kebenaran) {
        Palsu => pulang Ralat(RalatKunci::KebenaranTidakSah),
        Benar => {}
    };

    pulang Ok(kunci.tukar_keadaan(Aktif));
}

// Signing — only Aktif keys with Tandatangan usage accepted
fungsi tandatangan_mesej<M>(
    kunci: &Kunci<Aktif, Tandatangan>,
    mesej: &M
) -> Keputusan<TandatanganDigital, RalatKripto> kesan Bersih {
    biar hash = cincang(mesej);
    biar sig = tandatangan_dengan_kunci(kunci.bahan, hash);
    pulang Ok(sig);
}

// Key revocation — irreversible state transition
fungsi batalkan_kunci<G: KegunaanKunci>(
    kunci: Kunci<Aktif, G>,
    sebab: SebabPembatalan
) -> Kunci<Dibatalkan, G> kesan KesanHSM {
    biar kunci_batal = kunci.tukar_keadaan(Dibatalkan);
    log_pembatalan(kunci_batal.id, sebab);
    pulang kunci_batal;
}

// Shamir secret sharing — threshold enforced in types
fungsi bahagi_rahsia(
    rahsia: Rahsia Bait[],
    n: Nombor,
    ambang: Nombor
) -> Senarai<Bahagian> kesan Bersih {
    // Compiler verifies: ambang <= n, ambang >= 2
    biar polinomial = jana_polinomial_rawak(rahsia, ambang - 1);
    biar bahagian = untuk_setiap(1..=n, |i| {
        nilaikan_polinomial(polinomial, i)
    });
    pulang bahagian;
}
```

### 4.2 Coq Formalization

```coq
(* AG-01: Verified Key Lifecycle Management — Coq Formalization *)
From Stdlib Require Import Bool Arith List String.
Import ListNotations.

(* Key lifecycle states *)
Inductive KeyState : Type :=
  | Generated : KeyState
  | Distributed : KeyState
  | Active : KeyState
  | Suspended : KeyState
  | Revoked : KeyState
  | Destroyed : KeyState.

(* Key usage types — enforce separation *)
Inductive KeyUsage : Type :=
  | Signing : KeyUsage
  | Encryption : KeyUsage
  | KeyAgreement : KeyUsage
  | KeyWrapping : KeyUsage.

(* Key record with state and usage *)
Record Key := mkKey {
  key_id : nat;
  key_state : KeyState;
  key_usage : KeyUsage;
  key_created : nat;
  key_expires : nat
}.

(* Valid state transitions in the key lifecycle *)
Inductive ValidTransition : KeyState -> KeyState -> Prop :=
  | trans_gen_dist : ValidTransition Generated Distributed
  | trans_gen_active : ValidTransition Generated Active
  | trans_dist_active : ValidTransition Distributed Active
  | trans_active_susp : ValidTransition Active Suspended
  | trans_susp_active : ValidTransition Suspended Active
  | trans_active_rev : ValidTransition Active Revoked
  | trans_susp_rev : ValidTransition Suspended Revoked
  | trans_rev_dest : ValidTransition Revoked Destroyed
  | trans_active_dest : ValidTransition Active Destroyed.

(* Key operation predicates *)
Definition can_sign (k : Key) : Prop :=
  key_state k = Active /\ key_usage k = Signing.

Definition can_encrypt (k : Key) : Prop :=
  key_state k = Active /\ key_usage k = Encryption.

(* Theorem: Revoked keys cannot sign *)
Theorem revoked_key_cannot_sign :
  forall k, key_state k = Revoked -> ~ can_sign k.
Proof.
  intros k Hrev Hsign.
  unfold can_sign in Hsign.
  destruct Hsign as [Hactive _].
  rewrite Hrev in Hactive. discriminate.
Qed.

(* Theorem: Key usage separation *)
Theorem key_usage_separation :
  forall k, key_usage k = Signing -> ~ can_encrypt k.
Proof.
  intros k Hsign Henc.
  unfold can_encrypt in Henc.
  destruct Henc as [_ Huse].
  rewrite Hsign in Huse. discriminate.
Qed.

(* Theorem: Revocation is irreversible *)
Theorem revocation_irreversible :
  ~ ValidTransition Revoked Active.
Proof.
  intro H. inversion H.
Qed.

(* Shamir share generation *)
Definition polynomial := list nat.

Fixpoint eval_poly (p : polynomial) (x : nat) (acc : nat) (pow : nat) : nat :=
  match p with
  | [] => acc
  | c :: rest => eval_poly rest x (acc + c * pow) (pow * x)
  end.

Definition Share := (nat * nat)%type.

Definition generate_shares (p : polynomial) (n : nat) : list Share :=
  map (fun i => (i, eval_poly p i 0 1)) (seq 1 n).

Theorem share_count_correct :
  forall p n, length (generate_shares p n) = n.
Proof.
  intros p n. unfold generate_shares.
  rewrite map_length. apply seq_length.
Qed.

(* Only valid next state from Revoked is Destroyed *)
Theorem revoked_only_to_destroyed :
  forall s, ValidTransition Revoked s -> s = Destroyed.
Proof.
  intros s H. inversion H. reflexivity.
Qed.
```

## 5. Key References

| # | Authors | Title | Venue | Year | Relevance to RIINA |
|---|---|---|---|---|---|
| 1 | Shamir, A. | How to Share a Secret | Communications of the ACM | 1979 | Foundation for threshold key management and escrow |
| 2 | Boneh, D., Franklin, M. | Identity-Based Encryption from the Weil Pairing | CRYPTO (LNCS 2139) | 2001 | IBE key distribution; trust assumption encoding |
| 3 | Barker, E. | Recommendation for Key Management: Part 1 — General | NIST SP 800-57 Rev. 5 | 2020 | Definitive key lifecycle state machine reference |
| 4 | Barker, E., Roginsky, A. | Transitioning the Use of Cryptographic Algorithms and Key Lengths | NIST SP 800-131A Rev. 2 | 2016 | Key separation and algorithm transition guidance |
| 5 | Gennaro, R., Goldfeder, S. | Fast Multiparty Threshold ECDSA with Fast Trustless Setup | ACM CCS | 2018 | Threshold signing; distributed key use verification |
| 6 | Callas, J., Donnerhacke, L., Finney, H., Shaw, D., Thayer, R. | OpenPGP Message Format | RFC 4880 | 2007 | Decentralized key certification; web-of-trust |
| 7 | Blaze, M., Feigenbaum, J., Lacy, J. | Decentralized Trust Management | IEEE S&P | 1996 | Policy-based key authorization model |
| 8 | Boyd, C., Mathuria, A. | Protocols for Authentication and Key Establishment | Springer (Book) | 2003 | Key transport and agreement protocol taxonomy |

## 6. Formalizability Assessment

| Component | Effort (Person-Months) | Feasibility | Phase |
|---|---|---|---|
| Key lifecycle state machine in Coq | 1.5 | High | Phase 2 |
| Key usage separation proofs | 1.0 | High | Phase 2 |
| Shamir secret sharing correctness | 2.5 | High | Phase 3 |
| Threshold ECDSA protocol model | 4.0 | Medium | Phase 4 |
| Key revocation propagation proofs | 2.0 | Medium | Phase 3 |
| HSM interaction model | 3.0 | Medium | Phase 3 |
| Key derivation function formalization | 2.0 | High | Phase 3 |
| Certificate chain validation | 3.5 | Medium | Phase 4 |
| Entropy source verification | 2.5 | Medium | Phase 4 |
| Post-quantum key transition model | 4.0 | Low-Medium | Phase 5 |

## 7. Scope Limitations

1. **Entropy source quality assumed:** The formalization assumes that the underlying random number generator provides sufficient entropy. Verification of hardware RNG quality requires physical testing and is outside the scope of formal verification.
2. **HSM correctness assumed:** Hardware security module behavior is modeled axiomatically. RIINA verifies correct software-HSM interfaces but does not verify HSM firmware or hardware.
3. **Side-channel resistance not guaranteed:** While RIINA prevents logical key leakage through its information flow type system, timing side-channels, power analysis, and electromagnetic emanation attacks require hardware-level countermeasures outside RIINA's scope.
4. **Multi-party protocol liveness not proven:** The formalization verifies safety properties (keys are never misused) but does not prove liveness (threshold signing always eventually completes) under arbitrary participant failures.
5. **Social engineering excluded:** Key lifecycle management depends on human operators for key ceremonies and revocation decisions. Social engineering attacks on operators are outside the formal model.
6. **Quantum computing impact bounded:** Post-quantum key management transitions are modeled at a high level but full quantum-resistant key lifecycle verification is deferred to future work.

---
*"A key that cannot be misused need not be trusted — it is correct by construction."*
