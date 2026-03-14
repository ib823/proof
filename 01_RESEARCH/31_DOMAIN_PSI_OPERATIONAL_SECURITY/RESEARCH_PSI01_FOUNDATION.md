# Ψ-01: Operational Security — Trust No Single Human, Trust the Protocol

**Domain:** Ψ — Operational Security
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Multi-party computation, threshold cryptography, quorum-based operations, insider threat mitigation

---

## 1. Problem Statement

All other RIINA domains assume that human operators are not the vulnerability. This assumption is false. Physical coercion can extract keys from operators, social engineering bypasses technical controls, insider threats abuse authorized access, and hardware zero-days exist in silicon that no amount of software verification can detect.

The uncomfortable truth: given enough time and resources, any single human can be compromised. RIINA's operational security philosophy is: trust no single human, trust the protocol. Systems must be designed so that no single person can cause catastrophic failure, coercion of one person is insufficient to compromise the system, insider access is bounded and audited, and hardware diversity mitigates zero-day risks.

## 2. State of the Art

### 2.1 Threshold Cryptography

Threshold cryptography splits a secret key into n shares such that any t-of-n shares can reconstruct the key, but fewer than t shares reveal nothing. Shamir's Secret Sharing provides information-theoretic security. Threshold signatures (Gennaro et al.) enable distributed signing where no single party holds the complete signing key.

Shamir, A., "How to Share a Secret", *Communications of the ACM*, 22(11):612-613, 1979.

Gennaro, R., Goldfeder, S., "Fast Multiparty Threshold ECDSA with Fast Trustless Setup", *CCS*, 2018.

### 2.2 Multi-Party Computation (MPC)

Secure multi-party computation allows multiple parties to jointly compute a function over their inputs without revealing any party's input to others. Yao's garbled circuits and the GMW protocol provide foundational constructions. Modern MPC protocols (SPDZ, ABY) achieve practical performance for many computations.

Yao, A. C., "How to Generate and Exchange Secrets", *FOCS*, 1986.

Lindell, Y., "Secure Multiparty Computation", *Communications of the ACM*, 64(1):86-96, 2021.

### 2.3 Hardware Security Modules (HSMs) and Trusted Execution

HSMs provide tamper-resistant hardware for key storage and cryptographic operations. FIPS 140-2/140-3 certification levels define physical and logical security requirements. Intel SGX and ARM TrustZone provide software-accessible trusted execution environments, though both have been shown vulnerable to side-channel attacks.

### 2.4 Insider Threat Research

Research on insider threats has identified behavioral indicators, access pattern anomalies, and organizational factors that correlate with insider risk. The CERT Insider Threat Center at Carnegie Mellon maintains the most comprehensive database of insider incidents. Formal models of insider threats use game theory and mechanism design.

Cappelli, D. M., Moore, A. P., Trzeciak, R. F., "The CERT Guide to Insider Threats", Addison-Wesley, 2012.

### 2.5 Quorum Systems

Quorum systems define sets of participants whose agreement is required for operations. Byzantine quorum systems tolerate malicious participants. Malkhi and Reiter developed the theory of Byzantine dissemination and masking quorums, providing fault-tolerant data access without full replication.

Malkhi, D., Reiter, M. K., "Byzantine Quorum Systems", *Distributed Computing*, 11(4):203-213, 1998.

### 2.6 Formal Verification of Security Protocols

Tools like ProVerif, Tamarin, and CryptoVerif enable automated formal verification of cryptographic protocols. These tools can prove properties like secrecy, authentication, and forward secrecy for protocols involving multiple parties with potentially compromised components.

Blanchet, B., "Modeling and Verifying Security Protocols with the Applied Pi Calculus and ProVerif", *Foundations and Trends in Privacy and Security*, 1(1-2):1-135, 2016.

### 2.7 Zero-Knowledge Proofs

Zero-knowledge proofs allow one party to prove knowledge of a fact without revealing the fact itself. ZK-SNARKs and ZK-STARKs provide efficient non-interactive zero-knowledge proofs applicable to authentication, credential verification, and audit without data disclosure.

Ben-Sasson, E., Chiesa, A., Tromer, E., Virza, M., "Succinct Non-Interactive Zero Knowledge for a von Neumann Architecture", *USENIX Security*, 2014.

### 2.8 Key Ceremony and Operational Protocols

DNSSEC root key ceremonies and Bitcoin multi-sig protocols provide real-world examples of operational security procedures with formal properties. These ceremonies combine physical security, multi-party authorization, and cryptographic protocols.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| No single point of compromise | Threshold cryptography | Keys split into t-of-n shares |
| Insider threat bounded | Capability-based access + audit | Access limited to minimum necessary; all actions logged |
| Coercion resistance | Multi-party authorization | Critical operations require quorum agreement |
| Protocol correctness | ProVerif/Tamarin verification | Key management protocols formally verified |
| Audit completeness | Append-only log verification | All privileged operations logged immutably |
| Hardware diversity | Multiple vendor requirement | Critical systems use diverse hardware platforms |

## 4. RIINA Integration Architecture

### 4.1 Threshold Operations

```riina
// Critical operation requires t-of-n authorization
@kuorum(ambang: 3, daripada: 5)
fungsi tanda_kunci_baharu(kunci: KunciAwam) -> TandaTangan
    kesan KriptoAmbang
{
    // Cannot execute unless 3 of 5 keyholders authorize
    biar bahagian = kumpul_bahagian_tandatangan(3, 5);
    pulang gabung_tandatangan(bahagian);
}
```

### 4.2 Coq Formalization

```coq
(* Threshold security: fewer than t shares reveal nothing *)
Theorem threshold_security : forall secret shares t n,
  t <= n ->
  split secret n t = shares ->
  forall subset, length subset < t ->
  mutual_information secret (reconstruct subset) = 0.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Shamir, A., "How to Share a Secret" (1979) | Communications of the ACM | Secret sharing foundation |
| Gennaro, R., Goldfeder, S., "Threshold ECDSA" (2018) | CCS | Practical threshold signatures |
| Yao, A. C., "How to Generate and Exchange Secrets" (1986) | FOCS | Secure multi-party computation |
| Lindell, Y., "Secure Multiparty Computation" (2021) | Communications of the ACM | MPC survey |
| Malkhi, D., Reiter, M. K., "Byzantine Quorum Systems" (1998) | Distributed Computing | Fault-tolerant quorums |
| Blanchet, B., "ProVerif" (2016) | FnTPS | Protocol verification |
| Ben-Sasson, E., et al., "ZK-SNARKs" (2014) | USENIX Security | Zero-knowledge proofs |
| Cappelli, D. M., et al., "CERT Insider Threats" (2012) | Addison-Wesley | Insider threat taxonomy |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Threshold cryptography integration | 3-4 | High — well-understood constructions | Phase 1 |
| Quorum-based authorization types | 2-3 | High — type system extension | Phase 1 |
| MPC protocol verification | 4-6 | Medium — ProVerif/Tamarin | Phase 2 |
| Audit log verification | 2-3 | High — append-only log | Phase 2 |
| Insider threat modeling | 3-4 | Medium — game-theoretic | Phase 3 |
| ZK proof integration | 4-6 | Medium — complex cryptography | Phase 3 |
| Hardware diversity enforcement | 2-3 | Medium — build system integration | Phase 4 |

## 7. Scope Limitations

1. **Human factors are not formalizable.** Social engineering, coercion, and bribery are human problems. Formal methods can minimize the damage from compromised individuals but cannot prevent compromise.
2. **Usability vs. security.** Multi-party authorization and threshold operations are cumbersome. Emergency scenarios may require faster authorization than quorum processes allow.
3. **Key management complexity.** Threshold cryptography adds operational complexity: key shares must be distributed securely, stored separately, and periodically refreshed.
4. **MPC performance.** General-purpose MPC is orders of magnitude slower than plaintext computation. Only specific operations justify the overhead.
5. **Nation-state adversaries.** Adversaries with nation-state resources can compromise multiple parties simultaneously, potentially exceeding threshold assumptions.
6. **Hardware supply chain.** Hardware diversity mitigates zero-days but does not eliminate supply chain attacks that target multiple vendors.

---

*"Trust no single human. Trust the protocol."*
