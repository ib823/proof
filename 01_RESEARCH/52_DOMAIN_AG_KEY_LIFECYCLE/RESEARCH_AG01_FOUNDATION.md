# AG-01: Verified Key Lifecycle Management — Provably Correct Cryptographic Key Handling

**Domain:** AG — Verified Key Lifecycle Management
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Key generation, distribution, rotation, revocation, escrow, HSM integration, verified key state machines

---

## 1. Problem Statement

Cryptographic keys are the foundation of all security, yet key management is consistently identified as the weakest link. The 2011 DigiNotar breach compromised hundreds of TLS certificates because root key management procedures were inadequate. The 2014 Heartbleed vulnerability exposed private keys from server memory. HSM misconfigurations have resulted in key extraction from hardware security modules that were supposed to be tamper-proof.

Key lifecycle management encompasses generation (with sufficient entropy), distribution (without exposure), storage (in secure hardware), rotation (without service disruption), revocation (with timely propagation), and destruction (without recovery). Each phase has specific security requirements, and a failure in any phase compromises the entire system. RIINA provides verified key lifecycle management through state machine types that enforce correct key handling at every phase.

## 2. State of the Art

### 2.1 Secret Sharing

Shamir developed (t,n)-threshold secret sharing, where a secret is split into n shares such that any t shares can reconstruct the secret but fewer than t shares reveal no information. Secret sharing is foundational for key escrow, distributed key generation, and multi-party key management.

Shamir, A., "How to Share a Secret", *Communications of the ACM*, 22(11):612-613, 1979.

### 2.2 Identity-Based Encryption

Boneh and Franklin developed the first practical identity-based encryption scheme, where public keys are derived from identities (email addresses, names) rather than random values. IBE simplifies key distribution by eliminating the need for public key infrastructure.

Boneh, D., Franklin, M., "Identity-Based Encryption from the Weil Pairing", *CRYPTO*, 2001.

### 2.3 NIST Key Management Guidelines

NIST SP 800-57 provides comprehensive guidelines for cryptographic key management, covering key types, algorithms, key lengths, lifecycle phases, and protection requirements. The standard defines the authoritative framework for government and industry key management.

Barker, E., "Recommendation for Key Management: Part 1 – General", *NIST Special Publication 800-57 Part 1 Revision 5*, 2020.

### 2.4 Threshold ECDSA

Gennaro and Goldfeder developed efficient threshold ECDSA protocols, enabling distributed signing where no single party holds the complete signing key. This eliminates the single point of compromise for signing keys.

Gennaro, R., Goldfeder, S., "Fast Multiparty Threshold ECDSA with Fast Trustless Setup", *CCS*, 2018.

### 2.5 OpenPGP Key Management

Callas et al. defined the OpenPGP standard for key management in messaging, establishing the web of trust model where users certify each other's keys without a central authority. The standard provides practical key lifecycle operations including generation, certification, revocation, and expiry.

Callas, J., Donnerhacke, L., Finney, H., Shaw, D., Thayer, R., "OpenPGP Message Format", RFC 4880, 2007.

### 2.6 Key Management Trust

Blaze et al. analyzed trust management in cryptographic key systems, developing the PolicyMaker and KeyNote frameworks for automated trust management. The work formalized how trust decisions should be made based on key credentials and policies.

Blaze, M., Feigenbaum, J., Lacy, J., "Decentralized Trust Management", *IEEE S&P*, 1996.

### 2.7 Key Establishment Protocols

Boyd and Mathuria provided a comprehensive treatment of key establishment protocols, covering both key transport and key agreement protocols, with formal security analysis of each protocol type.

Boyd, C., Mathuria, A., "Protocols for Authentication and Key Establishment", Springer, 2003.

### 2.8 NIST Key Management Part 2

Barker and Roginsky defined specific key management practices for government applications, including key wrapping, key derivation, key confirmation, and key archival procedures with formal security requirements.

Barker, E., Barker, W., Burr, W., Polk, W., Smid, M., "Recommendation for Key Management: Part 2", *NIST SP 800-57 Part 2*, 2019.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Key entropy | Randomness proof | Key generated from verified entropy source |
| Key isolation | Linear type proof | Key material cannot be duplicated or leaked |
| Rotation correctness | State machine proof | Old key revoked before new key activated |
| Revocation propagation | Coverage proof | All relying parties notified of revocation |
| Secure destruction | Erasure proof | Key material zeroed after destruction |
| Threshold security | Information-theoretic proof | Fewer than t shares reveal nothing |

## 4. RIINA Integration Architecture

### 4.1 Key Lifecycle State Machine

```riina
// Key lifecycle enforced by type system
jenis KeadaanKunci = Dijana | Aktif | Digantung | Dibatalkan | Dimusnahkan;

fungsi aktifkan_kunci(
    kunci: Kunci<Dijana>,
    kelulusan: Kelulusan<Kuorum>,
) -> Kunci<Aktif>
    kesan KitarHayatKunci
{
    // Type system enforces: only Generated keys can be activated
    // Quorum approval required
    sahkan_kuorum(kelulusan)?;
    pulang kunci.tukar_keadaan(Aktif);
}

fungsi batalkan_kunci(
    kunci: Kunci<Aktif>,
    sebab: SebabPembatalan,
) -> Kunci<Dibatalkan>
    kesan KitarHayatKunci, Audit
{
    terbit_pembatalan(kunci.id, sebab);
    pulang kunci.tukar_keadaan(Dibatalkan);
}
```

### 4.2 Coq Formalization

```coq
(* Key lifecycle: valid state transitions only *)
Inductive KeyState := Generated | Active | Suspended | Revoked | Destroyed.

Inductive valid_transition : KeyState -> KeyState -> Prop :=
  | gen_to_active : valid_transition Generated Active
  | active_to_suspended : valid_transition Active Suspended
  | suspended_to_active : valid_transition Suspended Active
  | active_to_revoked : valid_transition Active Revoked
  | suspended_to_revoked : valid_transition Suspended Revoked
  | revoked_to_destroyed : valid_transition Revoked Destroyed.

(* No key resurrection: destroyed keys stay destroyed *)
Theorem no_resurrection : forall s,
  ~ valid_transition Destroyed s.
Proof.
  intros s H. inversion H.
Qed.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Shamir, A., "Secret Sharing" (1979) | Communications of the ACM | Threshold secret sharing |
| Boneh, D., Franklin, M., "IBE" (2001) | CRYPTO | Identity-based encryption |
| Barker, E., "NIST SP 800-57" (2020) | NIST | Key management guidelines |
| Gennaro, R., et al., "Threshold ECDSA" (2018) | CCS | Distributed signing |
| Callas, J., et al., "OpenPGP" (2007) | RFC 4880 | Key lifecycle standard |
| Blaze, M., et al., "Trust Management" (1996) | IEEE S&P | Decentralized key trust |
| Boyd, C., et al., "Key Establishment" (2003) | Springer | Protocol foundations |
| Barker, E., et al., "NIST SP 800-57 Part 2" (2019) | NIST | Key management practices |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Key state machine types | 2-3 | High — finite states | Phase 1 |
| Entropy source verification | 3-4 | Medium — randomness testing | Phase 1 |
| Key wrapping verification | 3-4 | High — standard crypto | Phase 2 |
| Threshold key management | 4-6 | Medium — multi-party protocols | Phase 2 |
| HSM integration verification | 4-6 | Medium — hardware interface | Phase 3 |
| End-to-end key lifecycle proof | 6-8 | Low-Medium — lifecycle complexity | Phase 4 |

## 7. Scope Limitations

1. **Entropy quality.** Key generation requires true randomness. Verifying entropy quality requires hardware trust in random number generators.
2. **HSM trust.** HSMs are assumed tamper-resistant, but vulnerabilities have been found in HSM firmware and APIs.
3. **Side channels.** Key material in memory is vulnerable to side-channel attacks. Verified key handling must include constant-time operations.
4. **Key discovery.** Revocation information must reach all relying parties. Network partitions can delay or prevent revocation propagation.
5. **Backward compatibility.** Key rotation requires supporting old and new keys during transition periods, complicating the state machine.
6. **Regulatory requirements.** Different jurisdictions have different key management requirements (key escrow, minimum key lengths), creating compliance complexity.

---

*"A key that follows its proven lifecycle cannot be mishandled."*
