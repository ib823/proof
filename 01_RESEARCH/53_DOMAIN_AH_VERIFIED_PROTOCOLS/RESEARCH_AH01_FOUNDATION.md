# AH-01: Verified Security Protocols — Provably Correct Cryptographic Communication

**Domain:** AH — Verified Security Protocols
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Protocol verification, symbolic and computational models, automated protocol analysis, verified handshakes, session key security

---

## 1. Problem Statement

Security protocols are the mechanisms by which distributed parties establish shared secrets, authenticate identities, and communicate securely. Protocol design is notoriously error-prone: the Needham-Schroeder protocol, published in 1978, was found to contain a man-in-the-middle vulnerability by Lowe in 1995 — seventeen years later. TLS 1.2 had multiple vulnerabilities (BEAST, CRIME, POODLE, Heartbleed) despite extensive review. WPA2's KRACK attack exploited a protocol-level flaw in the 4-way handshake.

The fundamental challenge is that security protocols operate in adversarial environments where an attacker can intercept, modify, replay, and inject messages. Reasoning about protocol security requires considering all possible interleavings of messages between honest and malicious parties — an exponentially large space that human analysis cannot cover. Formal verification tools (ProVerif, Tamarin, Scyther) automate this analysis, providing mathematical proofs of protocol correctness.

## 2. State of the Art

### 2.1 ProVerif

Blanchet developed ProVerif, an automatic protocol verifier based on the applied pi-calculus. ProVerif can verify secrecy, authentication, and observational equivalence properties for an unbounded number of protocol sessions, making it the most widely used tool for protocol verification.

Blanchet, B., "An Efficient Cryptographic Protocol Verifier Based on Prolog Rules", *CSFW*, 2001.

### 2.2 Tamarin Prover

Meier et al. developed the Tamarin prover, which combines automated and interactive protocol verification using multiset rewriting rules. Tamarin supports both trace-based and observational equivalence properties and can handle stateful protocols and mutable global state.

Meier, S., Schmidt, B., Cremers, C., Basin, D., "The TAMARIN Prover for the Symbolic Analysis of Security Protocols", *CAV*, 2013.

### 2.3 Verified TLS

Bhargavan et al. developed miTLS, a verified reference implementation of TLS in F*. The verification covers the handshake protocol, record layer, and key derivation, proving authentication and secrecy against active network attackers.

Bhargavan, K., Fournet, C., Kohlweiss, M., Pironti, A., Strub, P.-Y., "Implementing TLS with Verified Cryptographic Security", *IEEE S&P*, 2013.

### 2.4 Scyther

Cremers developed Scyther, a tool for automatic protocol verification that uses a pattern-based approach to efficiently analyze protocols. Scyther can verify security properties for an unbounded number of sessions and has found attacks on several published protocols.

Cremers, C. J. F., "The Scyther Tool: Verification, Falsification, and Analysis of Security Protocols", *CAV*, 2008.

### 2.5 Dolev-Yao Model

Dolev and Yao formalized the threat model for protocol analysis, where the adversary controls the network and can intercept, modify, and inject messages, but cannot break cryptographic primitives. The Dolev-Yao model is the foundation of symbolic protocol analysis.

Dolev, D., Yao, A. C., "On the Security of Public Key Protocols", *IEEE Transactions on Information Theory*, 29(2):198-208, 1983.

### 2.6 Decidability of Protocol Security

Comon-Lundh and Cortier established decidability results for security protocol verification, showing that secrecy is decidable for bounded numbers of sessions and that certain protocol classes admit decidable analysis even for unbounded sessions.

Comon-Lundh, H., Cortier, V., "New Decidability Results for Fragments of First-Order Logic and Application to Cryptographic Protocols", *RTA*, 2003.

### 2.7 Protocol Verification Survey

Basin, Cremers, and Meadows provided a comprehensive survey of formal methods for security protocol verification, covering symbolic models, computational models, and the tools implementing each approach.

Basin, D., Cremers, C., Meadows, C., "Model Checking Security Protocols", *Handbook of Model Checking*, Springer, 2018.

### 2.8 Verified Record Layer

Barbosa et al. developed a verified implementation of the TLS 1.3 record layer using EverCrypt, providing a production-ready implementation with machine-checked proofs of functional correctness, memory safety, and cryptographic security.

Barbosa, M., Barthe, G., Bhargavan, K., Blanchet, B., Cremers, C., Liao, K., Parno, B., "SoK: Computer-Aided Cryptography", *IEEE S&P*, 2021.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Key secrecy | ProVerif/Tamarin proof | Session keys never revealed to adversary |
| Authentication | Correspondence proof | Protocol parties correctly identified |
| Forward secrecy | Key independence proof | Past sessions secure despite key compromise |
| Replay protection | Nonce freshness proof | Replayed messages detected and rejected |
| Protocol composition | UC-style proof | Protocols remain secure when composed |
| Message integrity | MAC/signature verification | Tampered messages detected |

## 4. RIINA Integration Architecture

### 4.1 Verified Protocol Types

```riina
// TLS handshake with verified security properties
fungsi jabat_tangan_tls(
    pelanggan: SijilPelanggan,
    pelayan: SijilPelayan,
) -> Hasil<Sesi<Selamat>, RalatProtokol>
    kesan Rangkaian<TLS13>
{
    // Effect guarantees: TLS 1.3 security properties
    biar hello_pelanggan = cipta_client_hello();
    hantar(hello_pelanggan);
    biar hello_pelayan = terima::<ServerHello>()?;
    biar kunci = tukar_kunci_ecdhe(hello_pelanggan, hello_pelayan);
    biar sesi = sahkan_dan_selesai(kunci, pelayan)?;
    pulang Ok(sesi);
}
```

### 4.2 Coq Formalization

```coq
(* Key secrecy: adversary cannot learn session key *)
Theorem key_secrecy : forall session adversary,
  honest_parties session ->
  ~ knows adversary (session_key session).

(* Authentication: server identity verified *)
Theorem server_authentication : forall client server session,
  handshake_complete client server session ->
  identity server = claimed_identity session.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Blanchet, B., "ProVerif" (2001) | CSFW | Automated protocol verification |
| Meier, S., et al., "Tamarin" (2013) | CAV | Stateful protocol verification |
| Bhargavan, K., et al., "Verified TLS" (2013) | IEEE S&P | Verified protocol implementation |
| Cremers, C. J. F., "Scyther" (2008) | CAV | Pattern-based protocol analysis |
| Dolev, D., Yao, A. C., "Dolev-Yao" (1983) | IEEE TIT | Protocol threat model |
| Comon-Lundh, H., et al., "Decidability" (2003) | RTA | Protocol security decidability |
| Basin, D., et al., "Survey" (2018) | Handbook of Model Checking | Verification survey |
| Barbosa, M., et al., "Verified Record Layer" (2021) | IEEE S&P | Verified crypto implementation |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| ProVerif integration | 3-4 | High — mature tool | Phase 1 |
| Key exchange verification | 3-4 | High — well-studied | Phase 1 |
| TLS 1.3 handshake proof | 4-6 | Medium — complex protocol | Phase 2 |
| Protocol composition | 5-7 | Low-Medium — UC framework | Phase 3 |
| Computational soundness | 4-6 | Medium — bridging symbolic/computational | Phase 3 |
| End-to-end protocol stack | 6-8 | Low-Medium — multiple layers | Phase 4 |

## 7. Scope Limitations

1. **Symbolic vs. computational gap.** Symbolic analysis (ProVerif, Tamarin) assumes perfect cryptography. Attacks exploiting cryptographic weaknesses require computational analysis.
2. **Implementation bugs.** Verified protocol models do not prevent implementation errors. The gap between model and code requires verified implementation (miTLS approach).
3. **Side channels.** Protocol verification does not consider timing, power, or cache side channels that can leak secrets during protocol execution.
4. **Unbounded state.** Some protocol properties are undecidable for unbounded sessions. Verification tools use approximations that may miss attacks or report false positives.
5. **Protocol evolution.** Security protocols evolve over time. Each version requires re-verification, and backward compatibility features can introduce vulnerabilities.
6. **Human interaction.** Protocols involving human decision points (certificate warnings, TOFU) cannot be fully formalized.

---

*"A protocol that is proven correct cannot be broken by any network adversary."*
