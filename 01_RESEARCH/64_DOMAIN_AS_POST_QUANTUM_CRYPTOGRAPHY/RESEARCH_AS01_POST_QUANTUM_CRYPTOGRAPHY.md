# AS-01: Post-Quantum Cryptography — Verified Implementations for RIINA

**Domain:** AS — Post-Quantum Cryptography
**Status:** Research Complete
**Date:** 2026-03-13
**RIINA Feature Target:** Verified crypto stdlib, constant-time enforcement via IFC, PQC primitive integration

---

## 1. Problem Statement

RIINA targets security-critical applications. Cryptographic primitives are the foundation of security, but:
- Classical crypto (RSA, ECDH) is vulnerable to quantum attack (Shor's algorithm)
- NIST standardized post-quantum algorithms in 2024 (ML-KEM/FIPS 203, ML-DSA/FIPS 204)
- Implementation correctness and side-channel resistance are critical — one bug can break the entire security chain
- RIINA's IFC and effect systems provide natural enforcement points for cryptographic discipline

---

## 2. State of the Art

### 2.1 HACL* / Project Everest (INRIA Paris, Microsoft Research, CMU)

HACL* is the leading formally verified cryptographic library. Written in **F*** (dependently-typed functional language with effect system), compiled to C and assembly via KaRaMeL.

**Verified properties for each primitive:**
- **Memory safety**: No buffer overflows, use-after-free, or out-of-bounds accesses
- **Functional correctness**: Output matches mathematical specification
- **Secret independence (constant-time)**: Control flow and memory access patterns do not depend on secret inputs

**Deployed algorithms:**
- ChaCha20-Poly1305 (AEAD)
- SHA-2/SHA-3 families (hash)
- X25519, Ed25519 (key exchange, signatures)
- HKDF, HMAC (key derivation)
- AES-GCM (via Vale verified assembly)

**Production deployment:** Mozilla Firefox NSS, Linux kernel, mbedTLS, Tezos blockchain, ElectionGuard voting SDK, WireGuard VPN. HACL* is the most successfully deployed formally verified cryptographic library in existence.

### 2.2 Jasmin / EasyCrypt / Libjade (Formosa-Crypto Consortium)

**Jasmin** is a language designed specifically for high-speed, high-assurance cryptography:
- **Type-level constant-time enforcement** (dedicated type system)
- **Formally defined semantics** in Coq
- **Verified compiler** (Coq proofs): semantic preservation + secret-independence preservation
- **EasyCrypt extraction**: programs extracted for cryptographic security game proofs

**Libjade** library contains formally verified implementations of:

| Algorithm | Type | Standard | Status |
|-----------|------|----------|--------|
| **ML-KEM (Kyber)** | KEM | FIPS 203 | Kyber-512, Kyber-768 verified (EasyCrypt functional correctness) |
| **ML-DSA (Dilithium)** | Signature | FIPS 204 | Formosa ML-DSA verified |
| **Falcon512** | Signature | NIST Round 3 | Verification function verified |
| **X-Wing** | Hybrid KEM | Draft | Combines X25519 + ML-KEM |
| **Curve25519/X25519** | Key exchange | RFC 7748 | Scalar multiplication verified |
| **SHA3/SHAKE** | Hash | FIPS 202 | Keccak family verified |
| **ChaCha20, Salsa20** | Stream cipher | RFC 8439 | Verified |
| **Poly1305** | MAC | RFC 8439 | Verified |

**Jazzline** (CCS 2025, Distinguished Paper Award): Establishes composable functional correctness proofs for Jasmin programs — proofs compose across function boundaries.

### 2.3 Fiat-Crypto (MIT PLV, S&P 2019)

Fiat-Crypto synthesizes **correct-by-construction** implementations of field arithmetic from Coq specifications:
- High-level field spec → PHOAS IR → optimization → C/Rust/Go/Zig code generation
- Verified properties: functional correctness of modular arithmetic, overflow-freedom
- Supported curves: Curve25519, P-256, NIST primes
- Generated code used in **BoringSSL (Google)**, Zig stdlib, Dalek Cryptography

### 2.4 EasyCrypt (Game-Based Cryptographic Proofs)

EasyCrypt is a proof assistant for **game-based cryptographic proofs**:
- Probabilistic reasoning with adversarial code
- Proves IND-CPA, IND-CCA, EUF-CMA and other standard security notions
- Used by Formosa-Crypto alongside Jasmin for post-quantum security proofs
- The EasyCrypt proof of ML-KEM security reduces to Module-LWE hardness

### 2.5 NIST Post-Quantum Standards (2024)

| Standard | Algorithm | Based On | Security |
|----------|-----------|----------|----------|
| **FIPS 203 (ML-KEM)** | Module-Lattice KEM | CRYSTALS-Kyber | IND-CCA2 under MLWE |
| **FIPS 204 (ML-DSA)** | Module-Lattice Digital Signature | CRYSTALS-Dilithium | EUF-CMA under MLWE/MSIS |
| **FIPS 205 (SLH-DSA)** | Stateless Hash-Based Signature | SPHINCS+ | EUF-CMA (conservative) |

ML-KEM security levels: ML-KEM-512 (NIST Level 1), ML-KEM-768 (Level 3), ML-KEM-1024 (Level 5).

**Known issue:** "Unbindable Kemmy Schmidt" (ePrint 2024/523) found binding security failures in ML-KEM under malicious key manipulation — the standard key generation is fine, but reused keys require care.

### 2.6 Vale (Microsoft Research) — Verified Assembly

Vale enables verification of hardware-accelerated crypto:
- AES-GCM using x86 AES-NI instructions
- Integrated with Project Everest/HACL* stack
- Verification of assembly-level constant-time and correctness

---

## 3. What Properties Can Be Formally Verified

| Property | Method | Tool |
|----------|--------|------|
| **Functional correctness** | Spec equivalence proof | F* (HACL*), Coq (Fiat-Crypto), Jasmin+EasyCrypt |
| **Memory safety** | Type-level enforcement | F* effect system, Jasmin type system |
| **Constant-time / secret independence** | Non-interference proof | Jasmin (type-level), HACL* (Low* effect), ct-verif |
| **CPA/CCA security** | Game-based reduction | EasyCrypt |
| **Termination** | Termination proof | Non-trivial for rejection sampling (Kyber keygen) |
| **Semantic preservation** | Compiler correctness | Jasmin verified compiler (Coq), KaRaMeL |
| **Thread safety** | No global mutable state | Structural enforcement |

---

## 4. RIINA Integration Architecture

### 4.1 Constant-Time as an IFC Property

**Key insight:** Secret independence (constant-time execution) is equivalent to an IFC non-interference property. RIINA already has this:

```
// Secret value: IFC label prevents flow to observable channels
biar kunci: Rahsia<Bait256> = jana_kunci();

// REJECTED by IFC: branching on secret leaks timing information
jika kunci[0] == 0 {  // ERROR: no-read-up violation — kunci is Rahsia
    ...
}

// ACCEPTED: constant-time comparison (no branching on secret)
biar sama = perbandingan_tetap(kunci, sasaran);  // Returns Rahsia<Bool>
```

RIINA's existing `T_Deref` (no-read-up) and `T_Assign` (no-write-down) rules already prevent secret-dependent branching and memory access patterns. This is exactly the constant-time property.

### 4.2 Crypto Effect Types

```
kesan Kripto       // Cryptographic operation effect
kesan JanaKunci    // Key generation (requires entropy source)
kesan Tandatangan  // Digital signature operation
kesan Sulitkan     // Encryption operation
kesan Nyahsulit    // Decryption operation
```

Effect hierarchy ensures crypto operations are explicit and auditable:
```
fungsi tandatangan_ml_dsa(
    kunci: Rahsia<MLDSAPrivateKey>,
    mesej: &[Bait]
) -> MLDSASignature kesan Tandatangan {
    // HACL*-generated C code at FFI boundary
    // IFC: kunci is Rahsia — no leakage through signatures
    // Constant-time: enforced by RIINA IFC + HACL* verification
}
```

### 4.3 Key Management via Capabilities

```
// Key is a capability: authorizes specific crypto operations
jenis KunciKap<Alg, Op> = Capability<KunciData<Alg>>

// Key generation requires JanaKunci capability
fungsi jana_ml_kem_768() -> (KunciKap<MLKEM768, Sulitkan>, KunciKap<MLKEM768, Nyahsulit>)
    kesan JanaKunci

// Encryption requires the correct key capability
fungsi kapsul(kunci_awam: &KunciKap<MLKEM768, Sulitkan>, mesej: &[Bait])
    -> (Ciphertext, SharedSecret)
    kesan Sulitkan
```

### 4.4 Standard Library Integration

RIINA's `riina-crypto` stdlib should wrap HACL*-generated C code:

```
01_RESEARCH/ ← theory and references
02_FORMAL/coq/ ← Coq proofs of crypto type rules
03_PROTO/crates/riina-crypto/ ← Rust bindings to HACL* C
    └── vendor/hacl-star/ ← HACL* verified C output
```

The IFC properties extend through the FFI boundary:
- HACL* guarantees: functional correctness + constant-time + memory safety
- RIINA guarantees: IFC label tracking + capability discipline + effect audit trail
- Combined: end-to-end verified crypto with type-level guarantees

### 4.5 Post-Quantum Migration Path

```
// Hybrid KEM: classical + post-quantum (following X-Wing pattern)
fungsi kapsul_hibrid(
    kunci_klasik: &KunciKap<X25519, Sulitkan>,
    kunci_pq: &KunciKap<MLKEM768, Sulitkan>,
    mesej: &[Bait]
) -> HybridCiphertext kesan Sulitkan {
    biar (ct1, ss1) = kapsul_x25519(kunci_klasik, mesej);
    biar (ct2, ss2) = kapsul_ml_kem(kunci_pq, mesej);
    biar ss_gabung = kdf(ss1, ss2);  // Combine shared secrets
    pulang HybridCiphertext { ct1, ct2, ss_gabung };
}
```

---

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|-------------|
| Zinzindohoué et al., "HACL*: A Verified Modern Cryptographic Library" | CCS 2017 | Verified crypto in F*, deployed in Firefox/Linux |
| Almeida et al., "Jasmin: High-Assurance and High-Speed Cryptography" | CCS 2017 | Verified compiler for crypto implementations |
| Erbsen et al., "Simple High-Level Code for Cryptographic Arithmetic" | S&P 2019 | Fiat-Crypto: correct-by-construction field arithmetic |
| Barbosa et al., "Jazzline" | CCS 2025 | Composable functional correctness for Jasmin |
| NIST, "FIPS 203: Module-Lattice-Based Key-Encapsulation Mechanism" | NIST 2024 | ML-KEM standard (Kyber) |
| NIST, "FIPS 204: Module-Lattice-Based Digital Signature" | NIST 2024 | ML-DSA standard (Dilithium) |
| Barthe et al., "Computer-Aided Cryptographic Proofs" | EasyCrypt | Game-based PQC security proofs |
| Bond et al., "Vale: Verifying High-Performance Cryptographic Assembly Code" | USENIX Security 2017 | Verified assembly for AES-NI |

---

## 6. Formalizability Assessment

| Component | Effort | Feasibility | Phase |
|-----------|--------|-------------|-------|
| Constant-time enforcement via IFC | Low | Very High (already works via T_Deref/T_Assign) | Current |
| Crypto effect type hierarchy in Coq | Low | High | Phase 6 |
| Key capability typing rules | Medium | High (extends capability system) | Phase 6 |
| HACL* C integration in riina-crypto | Medium | Very High (well-tested C code) | Phase 6 |
| EasyCrypt proof artifact integration | High | Medium (requires toolchain bridge) | Phase 7 |
| Full PQC security reduction proof | Very High | Low (EasyCrypt expertise required) | Phase 8+ |

**Bottom line:** RIINA is uniquely positioned for verified crypto. Its IFC system already provides constant-time enforcement as a natural consequence of secret non-interference. Integrating HACL*-verified C code as the crypto stdlib gives end-to-end guarantees: HACL* proves the C is correct + constant-time, RIINA proves the usage is IFC-compliant + capability-disciplined. The combination is stronger than either system alone.
