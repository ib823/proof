# AE-01: Verified Audit Trail — Provably Tamper-Evident Logging

**Domain:** AE — Verified Audit Trail
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Tamper-evident logging, audit integrity proofs, accountability, append-only verification, mandatory audit effects

---

## 1. Problem Statement

Audit trails are the last line of defense: when prevention fails, logs must faithfully record what happened, when, and by whom. Yet attackers routinely tamper with logs to cover their tracks — the 2017 Equifax breach went undetected for 76 days partly because monitoring systems were disabled. Traditional logging systems store events in files or databases that can be modified, deleted, or truncated by anyone with administrative access.

The challenge is twofold: ensuring that all security-relevant events are logged (completeness) and ensuring that logged events cannot be modified after recording (integrity). RIINA addresses both through its effect system (mandatory audit effects ensure completeness) and cryptographic log structures (hash chains ensure integrity), with formal proofs that these properties hold.

## 2. State of the Art

### 2.1 Secure Audit Logs

Schneier and Kelsey developed the foundational framework for secure audit logs using hash chains with forward integrity. Their construction ensures that an attacker who compromises the logging system cannot modify past log entries without detection, even with full access to current cryptographic keys.

Schneier, B., Kelsey, J., "Secure Audit Logs to Support Computer Forensics", *ACM TISSEC*, 2(2):159-176, 1999.

### 2.2 Tamper-Evident Logging

Crosby and Wallach developed efficient tamper-evident logging using Merkle hash trees, enabling logarithmic-time proofs that a specific entry exists in the log and that the log is consistent (append-only). Their construction is the basis for Certificate Transparency.

Crosby, S. A., Wallach, D. S., "Efficient Data Structures for Tamper-Evident Logging", *USENIX Security*, 2009.

### 2.3 Transparency Logs

Pulls et al. formalized transparency logs as cryptographic data structures that provide publicly verifiable append-only semantics. The framework generalizes Certificate Transparency to arbitrary data types and provides formal security definitions.

Pulls, T., Dahlberg, R., "Verifiable Light-Weight Monitoring for Certificate Transparency Logs", *Nordic Conference on Secure IT Systems*, 2015.

### 2.4 Certificate Transparency

Laurie et al. developed Certificate Transparency (CT), a system for publicly logging TLS certificates using Merkle trees. CT enables detection of mis-issued certificates and provides a practical deployment of tamper-evident logging at internet scale.

Laurie, B., Langley, A., Kasper, E., "Certificate Transparency", RFC 6962, 2013.

### 2.5 Cryptographic Timestamping

Haber and Stornetta introduced cryptographic timestamping using hash chains, proving that a document existed at a particular time. Their work predates blockchain by two decades and provides the theoretical foundation for tamper-evident chronological records.

Haber, S., Stornetta, W. S., "How to Time-Stamp a Digital Document", *Journal of Cryptology*, 3(2):99-111, 1991.

### 2.6 Log Safety Analysis

Accorsi developed formal methods for analyzing log safety — the property that audit logs contain sufficient information to reconstruct security-relevant events. The analysis framework identifies logging gaps that could prevent forensic investigation.

Accorsi, R., "Safe-Keeping Digital Evidence with Secure Logging Protocols: State of the Art and Challenges", *IT Professional*, 12(2):40-47, 2010.

### 2.7 Audit with Key Exposure Resistance

Waters et al. developed audit logging schemes that remain secure even if audit keys are exposed, using identity-based encryption and forward-secure signatures. The construction ensures that log integrity is maintained throughout the key lifecycle.

Waters, B., Balfanz, D., Durfee, G., Smetters, D. K., "Building an Encrypted and Searchable Audit Log", *NDSS*, 2004.

### 2.8 Forward-Secure Sequential Aggregate Signatures

Ma and Tsudik developed forward-secure sequential aggregate (FssAgg) signatures for secure logging, where each log entry is signed with a key that is then erased, preventing retroactive forgery. The aggregate property keeps signature size constant regardless of log length.

Ma, D., Tsudik, G., "A New Approach to Secure Logging", *ACM TOSI*, 5(1):2, 2009.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| Append-only integrity | Hash chain proof | Log entries linked by cryptographic hashes |
| Completeness | Mandatory effect | kesan Audit cannot be suppressed |
| Consistency | Merkle proof | Log state transitions are monotonic |
| Forward integrity | Key erasure proof | Compromised keys cannot forge past entries |
| Tamper evidence | Inclusion proof | Any modification detectable by verifier |
| Temporal ordering | Timestamp chain | Entries ordered by verified timestamps |

## 4. RIINA Integration Architecture

### 4.1 Mandatory Audit Effects

```riina
// All security operations must produce audit records
fungsi padam_rekod(
    pengguna: Pengguna<Disahkan>,
    id_rekod: IdRekod,
) -> Hasil<(), RalatPadam>
    kesan Tulis, Audit  // Audit effect is MANDATORY
{
    // Effect system ensures audit log entry is produced
    // Cannot suppress the Audit effect
    log_audit(AuditEvent::Padam {
        pengguna: pengguna.id,
        rekod: id_rekod,
        masa: cap_masa_selamat(),
    });
    pangkalan_data.padam(id_rekod)?;
    pulang Ok(());
}
```

### 4.2 Coq Formalization

```coq
(* Append-only: log only grows *)
Theorem append_only : forall log entry log',
  append log entry = log' ->
  is_prefix log log'.

(* Completeness: security operations produce audit entries *)
Theorem audit_completeness : forall op state state',
  security_relevant op ->
  execute op state = (state', entries) ->
  length entries > 0.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Schneier, B., Kelsey, J., "Secure Audit Logs" (1999) | ACM TISSEC | Forward-secure logging |
| Crosby, S. A., Wallach, D. S., "Tamper-Evident Logging" (2009) | USENIX Security | Merkle-based logs |
| Pulls, T., et al., "Transparency Logs" (2015) | NordSec | Formal log definitions |
| Laurie, B., et al., "Certificate Transparency" (2013) | RFC 6962 | Public append-only logs |
| Haber, S., Stornetta, W. S., "Timestamping" (1991) | J. Cryptology | Cryptographic timestamps |
| Accorsi, R., "Log Safety" (2010) | IT Professional | Log completeness analysis |
| Waters, B., et al., "Encrypted Audit Log" (2004) | NDSS | Key-exposure resilience |
| Ma, D., Tsudik, G., "FssAgg Logging" (2009) | ACM TOSI | Forward-secure signatures |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| Hash chain verification | 2-3 | High — simple crypto | Phase 1 |
| Mandatory audit effect | 2-3 | High — effect system | Phase 1 |
| Merkle tree proofs | 3-4 | High — tree invariants | Phase 2 |
| Forward-secure logging | 3-4 | Medium — key management | Phase 2 |
| Audit completeness proof | 4-6 | Medium — coverage analysis | Phase 3 |
| End-to-end audit integrity | 6-8 | Low-Medium — system composition | Phase 4 |

## 7. Scope Limitations

1. **Storage costs.** Tamper-evident logs grow indefinitely. Cryptographic structures add overhead. Long-term archival requires significant storage.
2. **Performance.** Cryptographic operations (hashing, signing) on every log entry add latency. High-throughput systems may find per-entry cryptography prohibitive.
3. **Key management.** Forward-secure logging requires key rotation and secure erasure. Key management complexity can undermine the security benefits.
4. **Completeness depends on instrumentation.** Audit completeness requires that all security-relevant operations go through instrumented paths. Bypass routes defeat completeness.
5. **Privacy tension.** Comprehensive audit logs may contain sensitive information. Immutable logs conflict with data deletion requirements (GDPR right to erasure).
6. **Root compromise.** An attacker with root access can disable or bypass the audit system entirely. Hardware-backed logging (TPM) provides partial mitigation.

---

*"What is logged in the chain cannot be erased from history."*
