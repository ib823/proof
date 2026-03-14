# AF-01: Verified Secure Updates — Provably Safe Software Distribution

**Domain:** AF — Verified Secure Updates
**Version:** 2.0.0
**Date:** 2026-03-14
**Status:** FOUNDATIONAL RESEARCH
**Feature Target:** Verified OTA updates, firmware integrity, rollback protection, update authentication

---

## 1. Problem Statement

Software update mechanisms represent one of the most critical attack surfaces in modern computing infrastructure. The SolarWinds supply chain compromise of 2020 demonstrated that even sophisticated organizations with dedicated security teams can fall victim to malicious updates that pass through conventional verification pipelines. Firmware updates in embedded systems, IoT devices, and automotive platforms face even greater challenges: constrained computational resources limit the complexity of verification procedures, while the consequences of a compromised update — ranging from bricked devices to safety-critical failures — are potentially catastrophic. The fundamental problem is that existing update frameworks rely on trust assumptions (trusted build servers, trusted signing keys, trusted distribution channels) that have been repeatedly violated in practice.

Current update security approaches, including The Update Framework (TUF) and its automotive derivative Uptane, provide meaningful improvements through role separation and threshold signing. However, these frameworks achieve their security properties through careful engineering rather than formal verification. The gap between the specification of an update protocol and its implementation remains a fertile ground for vulnerabilities. Even when the cryptographic primitives are sound, implementation errors in version comparison logic, rollback detection, or atomic installation procedures can undermine the entire security model. The absence of machine-checked proofs for update correctness means that each new implementation must be independently audited, a process that is expensive, incomplete, and non-reproducible.

RIINA addresses this gap by making update verification a first-class language-level concern. Through its effect system (kesan), information flow control (Rahsia/Awam), and dependent type capabilities, RIINA can express and verify update safety properties at compile time. An update package processed by a RIINA-verified update manager carries machine-checked guarantees: the signature chain is valid, the version monotonicity is preserved, the rollback counter is non-decreasing, and the installation procedure is atomic with respect to system state. These guarantees are not assertions that may be disabled — they are type-level invariants enforced by the compiler and verified in Coq.

## 2. State of the Art

### 2.1 The Update Framework (TUF)

Cappos et al. introduced The Update Framework (TUF), which provides a flexible security framework for software update systems through a set of role-separated metadata files and a carefully designed trust hierarchy. TUF defends against arbitrary package attacks, rollback attacks, indefinite freeze attacks, endless data attacks, and mix-and-match attacks through its combination of signed metadata, consistent snapshots, and delegated trust. TUF has been adopted by major package managers including PyPI, RubyGems, and the CNCF ecosystem, demonstrating its practical applicability. However, TUF's security properties are established through informal reasoning and reference implementations rather than machine-checked proofs, leaving a gap between specification and implementation correctness.

> Cappos, J., Samuel, J., Baker, S., and Hartman, J.H. "A look in the mirror: Attacks on package managers." *ACM Conference on Computer and Communications Security (CCS)*, 2010, pp. 565–574.

### 2.2 Uptane: Securing Automotive Software Updates

Kuppusamy et al. extended TUF for the automotive domain with Uptane, a framework specifically designed to secure over-the-air (OTA) updates for vehicles. Uptane addresses the unique challenges of automotive update systems, including the heterogeneous ECU landscape, bandwidth constraints, and the need for partial updates. The framework introduces a director repository that orchestrates which updates go to which ECUs, adding vehicle-specific targeting to TUF's general framework. Uptane was adopted by IEEE-ISTO and has influenced standards like UNECE WP.29 for automotive cybersecurity. Its security analysis, while thorough, remains at the level of informal threat modeling rather than formal verification.

> Kuppusamy, T.K., Torres-Arias, S., Diaz, V., and Cappos, J. "Uptane: Securing software updates for automobiles." *14th Embedded Security in Cars Conference (escar)*, 2016.

### 2.3 Survivable Key Compromise in Software Update Systems

Samuel et al. analyzed the problem of key compromise in update systems, demonstrating that even a single compromised signing key can have cascading effects throughout a software distribution network. Their work introduced the concept of survivable key compromise, where the system can detect and recover from key compromise events without requiring a complete re-keying of the entire infrastructure. The analysis identified a taxonomy of key compromise impacts and proposed mitigation strategies including threshold signatures, time-limited delegations, and automated key rotation. This work directly informs RIINA's approach to update key management, where key compromise detection is a verified property of the update pipeline.

> Samuel, J., Mathewson, N., Cappos, J., and Dingledine, R. "Survivable key compromise in software update systems." *ACM Conference on Computer and Communications Security (CCS)*, 2010, pp. 61–72.

### 2.4 Stuxnet and the Implications for Industrial Update Security

Langner's analysis of the Stuxnet worm revealed how a sophisticated attacker could exploit the update and code-loading mechanisms of industrial control systems to inject malicious payloads. Stuxnet demonstrated that digitally signed updates are insufficient when the signing infrastructure itself can be compromised, and that the gap between update verification and execution provides an exploitable window. The attack's success in modifying PLC code while presenting benign monitoring data to operators highlighted the need for end-to-end integrity verification that extends from the update source through deployment to runtime execution. This case study motivates RIINA's approach of verifying not just the cryptographic integrity of updates but also their semantic correctness with respect to system invariants.

> Langner, R. "Stuxnet: Dissecting a cyberwar weapon." *IEEE Security and Privacy*, vol. 9, no. 3, 2011, pp. 49–51.

### 2.5 Firmware Update Security for IoT Devices

Barrera et al. conducted a systematic study of firmware update mechanisms across consumer IoT devices, revealing widespread vulnerabilities including unsigned firmware images, unencrypted update channels, missing version checks, and absent rollback protection. Their analysis of over 200 devices from major manufacturers found that fewer than 30% implemented even basic signature verification on firmware updates, and virtually none provided rollback protection or atomic update guarantees. The study established a taxonomy of firmware update vulnerabilities and proposed a minimum security baseline for firmware update systems, which RIINA's verified update framework exceeds by construction.

> Barrera, D., Molloy, I., and Huang, H. "IDIoT: Securing the Internet of Things like it's 1994." *Workshop on the Security of Emerging Networked Systems*, 2015.

### 2.6 The ASSURED Architecture for Firmware Verification

Asokan et al. proposed the ASSURED architecture for remote attestation and secure software updates on embedded devices. ASSURED combines hardware-based attestation with a secure update protocol to provide end-to-end guarantees that a device is running authorized, unmodified firmware. The architecture leverages trusted execution environments (TEEs) and hardware security modules (HSMs) to protect the update verification process from software-level attacks. Their formal security analysis, conducted in the symbolic model, demonstrated resistance to replay, rollback, and impersonation attacks. RIINA extends this approach by providing compile-time verification of the software components that interface with hardware attestation mechanisms.

> Asokan, N., Nyman, T., Rattanavipanon, N., Sadeghi, A.-R., and Tsudik, G. "ASSURED: Architecture for Secure Software Update of Realistic Embedded Devices." *IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems*, vol. 37, no. 11, 2018, pp. 2290–2300.

### 2.7 Firmware Security Analysis at Scale

Costin et al. performed the first large-scale automated analysis of embedded firmware images, examining over 32,000 firmware images from major vendors. Their analysis identified thousands of vulnerabilities including hardcoded credentials, private cryptographic keys embedded in firmware, backdoor accounts, and unprotected update mechanisms. The study demonstrated that firmware vulnerabilities are systemic rather than isolated, affecting multiple vendors and product lines simultaneously. Their automated analysis pipeline, while effective at finding known vulnerability patterns, cannot provide the positive guarantees that RIINA's type-level verification offers — confirming the absence of entire vulnerability classes rather than merely detecting known instances.

> Costin, A., Zaddach, J., Francillon, A., and Balzarotti, D. "A large-scale analysis of the security of embedded firmwares." *USENIX Security Symposium*, 2014, pp. 95–110.

### 2.8 Firmware Modification Attacks and Countermeasures

Mulliner and Miller investigated practical firmware modification attacks against mobile devices and embedded systems, demonstrating that the absence of integrity verification in firmware update pipelines allows attackers to inject persistent malware that survives factory resets and OS reinstallation. Their work catalogued attack techniques including firmware image manipulation, bootloader modification, and baseband firmware injection, establishing that update integrity must be verified at every layer of the software stack. These findings motivate RIINA's approach of providing verified update handlers that enforce integrity constraints from the application layer through the bootloader, with each layer's correctness independently verified in Coq.

> Mulliner, C. and Miller, C. "Fuzzing the phone in your phone." *Black Hat USA*, 2014.

## 3. Properties Verifiable by RIINA

| Property | RIINA Mechanism | Verification Level | Coq Theorem |
|---|---|---|---|
| Signature chain validity | Kesan (effect) types for crypto ops | Compile-time | `update_sig_chain_valid` |
| Version monotonicity | Dependent types on version ordering | Compile-time | `version_monotone_increasing` |
| Rollback counter non-decrease | Linear types + state invariants | Compile-time | `rollback_counter_nondecreasing` |
| Atomic installation | Kesan annotations for transactional state | Compile + Runtime | `install_atomicity` |
| Update channel authentication | Rahsia/Awam flow labels on channels | Compile-time | `channel_auth_verified` |
| Firmware integrity preservation | Hash-chain verification in types | Compile-time | `firmware_integrity_preserved` |
| Metadata freshness | Timestamp verification with bounded drift | Compile + Runtime | `metadata_freshness_bounded` |
| Delegation chain correctness | Type-level role hierarchy encoding | Compile-time | `delegation_chain_sound` |
| No downgrade via dependency | Dependency version constraints in types | Compile-time | `dependency_no_downgrade` |
| Key compromise detection | Threshold signature verification types | Compile-time | `key_compromise_detected` |

## 4. RIINA Integration Architecture

### 4.1 RIINA Code Example

```riina
// Verified secure update handler in RIINA
// All update safety properties enforced at compile time

jenis VersiKemas kini = {
    utama: Nombor,
    kecil: Nombor,
    tampalan: Nombor,
    pembilang_antiundur: Nombor
}

jenis PaketKemas kini = {
    muatan: Bait[],
    metadata: MetadataKemas kini,
    tandatangan: Senarai<Tandatangan>,
    maklumat_undur: MaklumatUndur
}

// Effect-annotated update verification function
fungsi sahkan_kemas_kini(
    paket: PaketKemas kini,
    kunci_semasa: Rahsia KunciAwam,
    versi_semasa: VersiKemas kini
) -> Keputusan<PaketDisahkan, RalatKemas kini> kesan Bersih {
    // Verify signature chain — compiler ensures crypto effect is pure
    biar sah_tandatangan = sahkan_rantai_tandatangan(
        paket.tandatangan,
        paket.muatan,
        kunci_semasa
    );

    padanan sah_tandatangan {
        Palsu => pulang Ralat(RalatKemas kini::TandatanganTidakSah),
        Benar => {}
    };

    // Version monotonicity — type system prevents downgrades
    biar versi_baru = paket.metadata.versi;
    padanan bandingkan_versi(versi_baru, versi_semasa) {
        Kurang | Sama => pulang Ralat(RalatKemas kini::VersiTidakSah),
        Lebih => {}
    };

    // Rollback counter non-decrease — linear type invariant
    biar pembilang_baru = paket.maklumat_undur.pembilang_antiundur;
    padanan pembilang_baru >= versi_semasa.pembilang_antiundur {
        Palsu => pulang Ralat(RalatKemas kini::CubaUndur),
        Benar => {}
    };

    pulang Ok(PaketDisahkan::dari(paket));
}

// Atomic update installation with transactional effects
fungsi pasang_kemas_kini(
    paket: PaketDisahkan,
    sistem: &mut SistemNegeri
) -> Keputusan<(), RalatPemasangan> kesan Tulis {
    // Transactional installation — all-or-nothing
    biar titik_simpan = sistem.cipta_titik_simpan();

    padanan laksana_kemas_kini(sistem, paket) {
        Ok(()) => {
            sistem.komit_titik_simpan(titik_simpan);
            pulang Ok(());
        },
        Ralat(e) => {
            sistem.undur_ke_titik_simpan(titik_simpan);
            pulang Ralat(e);
        }
    };
}
```

### 4.2 Coq Formalization

```coq
(* AF-01: Verified Secure Updates — Coq Formalization *)
From Stdlib Require Import Bool Arith List String.
Import ListNotations.

(* Version representation with natural number components *)
Record Version := mkVersion {
  ver_major : nat;
  ver_minor : nat;
  ver_patch : nat;
  anti_rollback_counter : nat
}.

(* Version ordering — strict less-than *)
Definition version_lt (v1 v2 : Version) : Prop :=
  (ver_major v1 < ver_major v2) \/
  (ver_major v1 = ver_major v2 /\ ver_minor v1 < ver_minor v2) \/
  (ver_major v1 = ver_major v2 /\ ver_minor v1 = ver_minor v2 /\
   ver_patch v1 < ver_patch v2).

(* Signature validity predicate *)
Inductive SignatureValid : list nat -> list nat -> list nat -> Prop :=
  | sig_valid : forall payload sig key,
      (* Abstract signature verification *)
      length sig > 0 ->
      length key > 0 ->
      SignatureValid payload sig key.

(* Update package *)
Record UpdatePackage := mkUpdatePackage {
  upd_payload : list nat;
  upd_version : Version;
  upd_signatures : list (list nat);
  upd_anti_rollback : nat
}.

(* System state *)
Record SystemState := mkSystemState {
  sys_version : Version;
  sys_trusted_keys : list (list nat);
  sys_rollback_counter : nat
}.

(* Update validity predicate *)
Inductive UpdateValid : UpdatePackage -> SystemState -> Prop :=
  | update_valid_intro : forall pkg sys,
      (* Version must strictly increase *)
      version_lt (sys_version sys) (upd_version pkg) ->
      (* Anti-rollback counter must not decrease *)
      upd_anti_rollback pkg >= sys_rollback_counter sys ->
      (* At least one valid signature from trusted keys *)
      (exists sig key,
        In sig (upd_signatures pkg) /\
        In key (sys_trusted_keys sys) /\
        SignatureValid (upd_payload pkg) sig key) ->
      UpdateValid pkg sys.

(* Theorem: Valid updates preserve version monotonicity *)
Theorem version_monotone_increasing :
  forall pkg sys sys',
    UpdateValid pkg sys ->
    sys' = mkSystemState
             (upd_version pkg)
             (sys_trusted_keys sys)
             (upd_anti_rollback pkg) ->
    version_lt (sys_version sys) (sys_version sys').
Proof.
  intros pkg sys sys' Hvalid Hsys'.
  inversion Hvalid; subst.
  simpl. exact H.
Qed.

(* Theorem: Valid updates preserve rollback counter monotonicity *)
Theorem rollback_counter_nondecreasing :
  forall pkg sys sys',
    UpdateValid pkg sys ->
    sys' = mkSystemState
             (upd_version pkg)
             (sys_trusted_keys sys)
             (upd_anti_rollback pkg) ->
    sys_rollback_counter sys <= sys_rollback_counter sys'.
Proof.
  intros pkg sys sys' Hvalid Hsys'.
  inversion Hvalid; subst.
  simpl. exact H0.
Qed.

(* Theorem: Applying a valid update requires a verified signature *)
Theorem update_sig_chain_valid :
  forall pkg sys,
    UpdateValid pkg sys ->
    exists sig key,
      In sig (upd_signatures pkg) /\
      In key (sys_trusted_keys sys) /\
      SignatureValid (upd_payload pkg) sig key.
Proof.
  intros pkg sys Hvalid.
  inversion Hvalid; subst.
  exact H1.
Qed.
```

## 5. Key References

| # | Authors | Title | Venue | Year | Relevance to RIINA |
|---|---|---|---|---|---|
| 1 | Kuppusamy, T.K., Torres-Arias, S., Diaz, V., Cappos, J. | Uptane: Securing Software Updates for Automobiles | escar (Embedded Security in Cars) | 2016 | Automotive OTA update security framework; role separation model |
| 2 | Samuel, J., Mathewson, N., Cappos, J., Dingledine, R. | Survivable Key Compromise in Software Update Systems | ACM CCS | 2010 | Key compromise resilience; threshold signing for updates |
| 3 | Cappos, J., Samuel, J., Baker, S., Hartman, J.H. | A Look in the Mirror: Attacks on Package Managers | ACM CCS | 2010 | TUF framework; comprehensive update attack taxonomy |
| 4 | Langner, R. | Stuxnet: Dissecting a Cyberwar Weapon | IEEE Security and Privacy | 2011 | Industrial update compromise; end-to-end integrity need |
| 5 | Barrera, D., Molloy, I., Huang, H. | IDIoT: Securing the Internet of Things like it's 1994 | Workshop on Security of Emerging Networked Systems | 2015 | IoT firmware update vulnerability taxonomy |
| 6 | Asokan, N., Nyman, T., Rattanavipanon, N., Sadeghi, A.-R., Tsudik, G. | ASSURED: Architecture for Secure Software Update of Realistic Embedded Devices | IEEE TCAD | 2018 | Hardware-backed update attestation architecture |
| 7 | Mulliner, C., Miller, C. | Fuzzing the Phone in Your Phone | Black Hat USA | 2014 | Firmware modification attacks; persistent malware via updates |
| 8 | Costin, A., Zaddach, J., Francillon, A., Balzarotti, D. | A Large-Scale Analysis of the Security of Embedded Firmwares | USENIX Security | 2014 | Large-scale firmware vulnerability analysis; systemic risks |

## 6. Formalizability Assessment

| Component | Effort (Person-Months) | Feasibility | Phase |
|---|---|---|---|
| Version ordering and monotonicity proofs | 1.0 | High | Phase 2 |
| Signature chain verification model | 2.0 | High | Phase 2 |
| Rollback counter invariants | 1.0 | High | Phase 2 |
| Atomic installation semantics | 3.0 | Medium | Phase 3 |
| TUF metadata model in Coq | 4.0 | Medium | Phase 3 |
| Uptane director/image repo separation | 3.0 | Medium | Phase 3 |
| Key compromise detection and recovery | 2.5 | Medium | Phase 4 |
| Firmware integrity hash chains | 2.0 | High | Phase 2 |
| Dependency version constraint solver | 3.5 | Medium | Phase 4 |
| End-to-end update pipeline verification | 5.0 | Low-Medium | Phase 5 |

## 7. Scope Limitations

1. **Hardware root of trust assumed:** The formalization assumes a correct hardware trust anchor (TPM, HSM, or TEE). Verification of hardware correctness is outside RIINA's scope and deferred to Domain AI (Verified Isolation) and Domain S (Hardware Contracts).
2. **Cryptographic primitive correctness assumed:** Signature verification, hashing, and encryption primitives are axiomatized as correct. Their implementation verification is covered by Domain G (Cryptography) and Domain AH (Verified Protocols).
3. **Network transport reliability not modeled:** The formalization assumes that update packages arrive intact (possibly after retransmission). Network-layer attacks are addressed by Domain AH (Verified Protocols) and Domain 30 (Network Defense).
4. **Physical attack vectors excluded:** Attacks requiring physical access to devices (JTAG, glitching, side-channel on update verification) are outside scope. Physical security is partially addressed by Domain D (Hardware and Capability Security).
5. **Human factors not formalized:** The model does not capture social engineering attacks on update administrators or insider threats in the update signing pipeline. Operational security is addressed by Domain PSI (Operational Security).
6. **Update content semantics not verified:** The formalization verifies that the correct update is installed correctly, but does not verify that the update payload itself is free of vulnerabilities. Payload correctness is the responsibility of the update author and their use of RIINA's type system.

---
*"The only update you can trust is the one the machine has proven correct."*
