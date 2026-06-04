//! Cryptographic Known-Answer Test (KAT) audit manifest.
//!
//! A single, consolidated, auditor-facing entry point that re-verifies each
//! `riina-core` primitive against an **independently transcribed** canonical
//! test vector from its governing standard (the per-module unit tests verify
//! their own vectors; this manifest cross-checks them from the published source
//! so a regression in any primitive fails one obvious gate). Run with:
//!
//! ```text
//! cargo test -p riina-core --test kat_audit
//! ```
//!
//! Each test names its standard + vector source in a comment. Negative
//! (robustness) checks accompany the AEAD and signature primitives, since an
//! auditor probes tamper-rejection as well as correctness. This is REQ-28
//! (external crypto-audit) *preparation*: it does not replace an external
//! audit, but gives one a reproducible correctness baseline.

use riina_core::crypto::aes::Aes256;
use riina_core::crypto::ed25519::Ed25519SigningKey;
use riina_core::crypto::gcm::{Aes256Gcm, TAG_SIZE};
use riina_core::crypto::hkdf::HkdfSha256;
use riina_core::crypto::hmac::HmacSha256;
use riina_core::crypto::keccak::{Sha3_256, Sha3_512};
use riina_core::crypto::ml_kem::{
    MlKem768DecapsulationKey, MlKem768EncapsulationKey, MlKem768KeyPair,
};
use riina_core::crypto::ml_dsa::{MlDsa65KeyPair, MlDsa65SigningKey, MlDsa65VerifyingKey, PreHash};
use riina_core::crypto::sha2::{Sha256, Sha512};
use riina_core::crypto::x25519::x25519;

/// Decode a hex string into a byte vector (test-only helper).
fn hex(s: &str) -> Vec<u8> {
    let s: String = s.chars().filter(|c| !c.is_whitespace()).collect();
    assert!(s.len().is_multiple_of(2), "hex string must have even length");
    (0..s.len())
        .step_by(2)
        .map(|i| u8::from_str_radix(&s[i..i + 2], 16).expect("valid hex"))
        .collect()
}

fn hexn<const N: usize>(s: &str) -> [u8; N] {
    let v = hex(s);
    assert_eq!(v.len(), N, "expected {N} bytes, got {}", v.len());
    let mut a = [0u8; N];
    a.copy_from_slice(&v);
    a
}

/// Look up `key=value` in a vendored vector file (lines beginning `#` are comments).
fn kv<'a>(data: &'a str, key: &str) -> &'a str {
    let prefix = format!("{key}=");
    data.lines()
        .find_map(|l| l.trim().strip_prefix(&prefix))
        .unwrap_or_else(|| panic!("vector key not found: {key}"))
}

// ── SHA-2 — FIPS 180-4 ──────────────────────────────────────────────────────

#[test]
fn kat_sha256_fips180_4_abc() {
    // FIPS 180-4, §B.1: SHA-256("abc")
    let got = Sha256::hash(b"abc");
    assert_eq!(
        got.to_vec(),
        hex("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
    );
}

#[test]
fn kat_sha512_fips180_4_abc() {
    // FIPS 180-4, §C.1: SHA-512("abc")
    let got = Sha512::hash(b"abc");
    assert_eq!(
        got.to_vec(),
        hex(
            "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a\
             2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f"
        )
    );
}

// ── SHA-3 — FIPS 202 ─────────────────────────────────────────────────────────

#[test]
fn kat_sha3_256_fips202_abc() {
    // FIPS 202 / NIST CAVP example: SHA3-256("abc")
    let got = Sha3_256::hash(b"abc");
    assert_eq!(
        got.to_vec(),
        hex("3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532")
    );
}

#[test]
fn kat_sha3_512_fips202_abc() {
    // FIPS 202 / NIST CAVP example: SHA3-512("abc")
    let got = Sha3_512::hash(b"abc");
    assert_eq!(
        got.to_vec(),
        hex(
            "b751850b1a57168a5693cd924b6b096e08f621827444f70d884f5d0240d2712e\
             10e116e9192af3c91a7ec57647e3934057340b4cf408d5a56592f8274eec53f0"
        )
    );
}

// ── ML-KEM-768 — NIST ACVP (FIPS 203) ────────────────────────────────────────

#[test]
fn kat_ml_kem_768_keygen_acvp_fips203() {
    // FIPS 203 COMPLIANT (byte-exact against this authentic NIST ACVP vector).
    // Reconciliation deltas that were fixed: (1) G(d) -> G(d||k) parameter-set
    // domain separator; (2) `poly_tomont` after the Â∘ŝ basemul-accumulate (the
    // R^(-1) from fqmul); (3) the root cause that masked everything else -- the
    // matrix sampler `sample_ntt` read its zero-initialised buffer on the first
    // iteration (Â was silently all-zeros, so t_hat collapsed to ê and tomont
    // had nothing to scale). See reports/precrypto_audit_secondmodel.md.
    // Authentic NIST ACVP-Server vector (FIPS 203). Source URL + file SHA-256 are
    // in the header of the vendored file. ACVP keyGen supplies d and z; RIINA's
    // generate() consumes randomness = d || z and must reproduce ek and dk.
    let data = include_str!("vectors/mlkem768_keygen_acvp.txt");
    let mut random = [0u8; 64];
    random[..32].copy_from_slice(&hexn::<32>(kv(data, "d")));
    random[32..].copy_from_slice(&hexn::<32>(kv(data, "z")));

    let kp = MlKem768KeyPair::generate(&random).expect("ML-KEM-768 keygen");
    assert_eq!(
        kp.encapsulation_key().as_bytes().to_vec(),
        hex(kv(data, "ek")),
        "ek does not match the ACVP expected public key"
    );
    assert_eq!(
        kp.decapsulation_key().as_bytes().to_vec(),
        hex(kv(data, "dk")),
        "dk does not match the ACVP expected secret key"
    );
}

#[test]
fn kat_ml_kem_768_encaps_decaps_acvp_fips203() {
    // FIPS 203 COMPLIANT (byte-exact against authentic NIST ACVP-Server vectors).
    // Source URL + file SHA-256 are in the vendored file header. Exercises both
    // FO-transform branches: encapsulation, valid decapsulation (returns K'), and
    // implicit rejection on a modified ciphertext (returns J(z || c)).
    let data = include_str!("vectors/mlkem768_encapdecap_acvp.txt");

    // Encapsulation AFT: given ek and m, reproduce ciphertext c and shared secret K.
    let ek_bytes: [u8; 1184] = hexn(kv(data, "enc_ek"));
    let m: [u8; 32] = hexn(kv(data, "enc_m"));
    let ek = MlKem768EncapsulationKey::from_bytes(&ek_bytes).expect("ek decode");
    let (ct, ss) = ek.encapsulate(&m).expect("encapsulate");
    assert_eq!(ct.to_vec(), hex(kv(data, "enc_c")), "encaps ciphertext mismatch");
    assert_eq!(ss.to_vec(), hex(kv(data, "enc_k")), "encaps shared secret mismatch");

    // Valid decapsulation VAL: given dk and c, reproduce K' directly.
    let dk_v: [u8; 2400] = hexn(kv(data, "dec_valid_dk"));
    let c_v: [u8; 1088] = hexn(kv(data, "dec_valid_c"));
    let dk_valid = MlKem768DecapsulationKey::from_bytes(&dk_v).expect("dk decode");
    assert_eq!(
        dk_valid.decapsulate(&c_v).expect("decaps").to_vec(),
        hex(kv(data, "dec_valid_k")),
        "valid decaps shared secret mismatch"
    );

    // Implicit-rejection VAL: modified ciphertext -> shared secret = J(z || c).
    let dk_r: [u8; 2400] = hexn(kv(data, "dec_reject_dk"));
    let c_r: [u8; 1088] = hexn(kv(data, "dec_reject_c"));
    let dk_reject = MlKem768DecapsulationKey::from_bytes(&dk_r).expect("dk decode");
    assert_eq!(
        dk_reject.decapsulate(&c_r).expect("decaps").to_vec(),
        hex(kv(data, "dec_reject_k")),
        "implicit-rejection shared secret mismatch"
    );
}

// ── ML-DSA-65 — NIST ACVP (FIPS 204) ─────────────────────────────────────────

#[test]
fn kat_ml_dsa_65_keygen_acvp_fips204() {
    // FIPS 204 COMPLIANT (byte-exact against this authentic NIST ACVP vector).
    // Reconciliation deltas that were fixed: (1) H(xi) -> H(xi || k || l)
    // parameter-set domain separator; (2) ExpandS sample_eta was a centered
    // binomial distribution (ML-KEM style) instead of FIPS 204 RejBoundedPoly
    // (CoeffFromHalfByte rejection sampling); (3) ExpandA sample_uniform_ntt used
    // the Kyber two-12-bit byte extraction instead of Dilithium's one-23-bit
    // CoeffFromThreeBytes. ACVP keyGen supplies the 32-byte seed xi; generate(xi)
    // reproduces pk and sk. See reports/precrypto_audit_secondmodel.md.
    let data = include_str!("vectors/mldsa65_keygen_acvp.txt");
    let seed = hexn::<32>(kv(data, "seed"));
    let kp = MlDsa65KeyPair::generate(&seed).expect("ML-DSA-65 keygen");
    assert_eq!(
        kp.verifying_key().as_bytes().to_vec(),
        hex(kv(data, "pk")),
        "pk does not match the ACVP expected public key"
    );
    assert_eq!(
        kp.signing_key().as_bytes().to_vec(),
        hex(kv(data, "sk")),
        "sk does not match the ACVP expected secret key"
    );
}

#[test]
fn kat_ml_dsa_65_siggen_acvp_fips204() {
    // FIPS 204 deterministic, internal-interface signing (Sign_internal with
    // rnd = 0^32, mu = H(tr || M)), byte-exact against an authentic NIST ACVP
    // vector. Source URL + file SHA-256 are in the vendored file header.
    let data = include_str!("vectors/mldsa65_siggen_acvp.txt");
    let sk_bytes: [u8; 4032] = hexn(kv(data, "sk"));
    let message = hex(kv(data, "message"));
    let sk = MlDsa65SigningKey::from_bytes(&sk_bytes).expect("sk decode");
    let sig = sk.sign(&message).expect("ML-DSA-65 sign");
    assert_eq!(
        sig.to_vec(),
        hex(kv(data, "signature")),
        "signature does not match the ACVP expected signature"
    );
}

#[test]
fn kat_ml_dsa_65_sigver_acvp_fips204() {
    // FIPS 204 verification (internal interface) against authentic NIST ACVP
    // vectors: one valid signature must verify, and tampered cases (modified
    // commitment c̃, modified message) must be rejected. Source + SHA-256 in the
    // vendored file header.
    let data = include_str!("vectors/mldsa65_sigver_acvp.txt");
    let case = |prefix: &str| {
        let pk: [u8; 1952] = hexn(kv(data, &format!("{prefix}_pk")));
        let message = hex(kv(data, &format!("{prefix}_message")));
        let sig: [u8; 3309] = hexn(kv(data, &format!("{prefix}_signature")));
        let want_ok = kv(data, &format!("{prefix}_pass")) == "1";
        let vk = MlDsa65VerifyingKey::from_bytes(&pk).expect("pk decode");
        let got_ok = vk.verify(&message, &sig).is_ok();
        assert_eq!(got_ok, want_ok, "sigVer case '{prefix}': got ok={got_ok}, want {want_ok}");
    };
    case("valid");
    case("badcommit");
    case("badmsg");
}

#[test]
fn kat_ml_dsa_65_external_acvp_fips204() {
    // FIPS 204 external/"pure", pre-hash (HashML-DSA), and hedged signing — all
    // byte-exact against authentic NIST ACVP vectors (same source file as the
    // internal sigGen vector). Also checks the external verify path + domain
    // separation (an external signature must NOT verify under the internal API).
    let data = include_str!("vectors/mldsa65_siggen_acvp.txt");
    let det = [0u8; 32];
    let sk = |k: &str| MlDsa65SigningKey::from_bytes(&hexn::<4032>(kv(data, k))).expect("sk");

    // External "pure" interface, deterministic (rnd = 0).
    let ext_msg = hex(kv(data, "ext_message"));
    let ext_ctx = hex(kv(data, "ext_context"));
    let ext_sig = sk("ext_sk")
        .sign_with_context(&ext_msg, &ext_ctx, &det)
        .expect("external sign");
    assert_eq!(ext_sig.to_vec(), hex(kv(data, "ext_signature")), "external pure signature mismatch");
    // The matching public key is in the secret key (rho||K||tr||s1||s2||t0 -> derive vk).
    let vk = MlDsa65SigningKey::from_bytes(&hexn::<4032>(kv(data, "ext_sk")))
        .unwrap()
        .verifying_key();
    assert!(vk.verify_with_context(&ext_msg, &ext_ctx, &ext_sig).is_ok(), "external verify must accept");
    assert!(vk.verify(&ext_msg, &ext_sig).is_err(), "internal verify must reject an external signature");

    // Internal hedged signing: the randomizer is supplied by the vector.
    let hedged_sig = sk("hedged_sk")
        .sign_hedged(&hex(kv(data, "hedged_message")), &hexn::<32>(kv(data, "hedged_rnd")))
        .expect("hedged sign");
    assert_eq!(hedged_sig.to_vec(), hex(kv(data, "hedged_signature")), "hedged signature mismatch");

    // Pre-hash (HashML-DSA), deterministic: SHA2-256 and SHAKE-256.
    let ph256 = sk("ph256_sk")
        .sign_prehash(&hex(kv(data, "ph256_message")), &hex(kv(data, "ph256_context")), PreHash::Sha256, &det)
        .expect("prehash sha256 sign");
    assert_eq!(ph256.to_vec(), hex(kv(data, "ph256_signature")), "pre-hash SHA2-256 signature mismatch");

    let phshake = sk("phshake_sk")
        .sign_prehash(&hex(kv(data, "phshake_message")), &hex(kv(data, "phshake_context")), PreHash::Shake256, &det)
        .expect("prehash shake256 sign");
    assert_eq!(phshake.to_vec(), hex(kv(data, "phshake_signature")), "pre-hash SHAKE-256 signature mismatch");
}

// ── HMAC-SHA256 — RFC 4231 ───────────────────────────────────────────────────

#[test]
fn kat_hmac_sha256_rfc4231_case2() {
    // RFC 4231 §4.3, Test Case 2: key="Jefe", data="what do ya want for nothing?"
    let mac = HmacSha256::mac(b"Jefe", b"what do ya want for nothing?");
    assert_eq!(
        mac.to_vec(),
        hex("5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843")
    );
    // Robustness: verify() accepts the right MAC and rejects a flipped bit.
    assert!(HmacSha256::verify(b"Jefe", b"what do ya want for nothing?", &mac));
    let mut bad = mac;
    bad[0] ^= 1;
    assert!(!HmacSha256::verify(b"Jefe", b"what do ya want for nothing?", &bad));
}

// ── HKDF-SHA256 — RFC 5869 ───────────────────────────────────────────────────

#[test]
fn kat_hkdf_sha256_rfc5869_case1() {
    // RFC 5869 §A.1, Test Case 1.
    let ikm = hex("0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b");
    let salt = hex("000102030405060708090a0b0c");
    let info = hex("f0f1f2f3f4f5f6f7f8f9");
    let prk = HkdfSha256::extract(&salt, &ikm);
    assert_eq!(
        prk.to_vec(),
        hex("077709362c2e32df0ddc3f0dc47bba6390b6c73bb50f9c3122ec844ad7c2b3e5"),
        "HKDF-Extract PRK"
    );
    let mut okm = [0u8; 42];
    HkdfSha256::expand(&prk, &info, &mut okm).expect("expand");
    assert_eq!(
        okm.to_vec(),
        hex(
            "3cb25f25faacd57a90434f64d0362f2a2d2d0a90cf1a5a4c5db02d56ec\
             c4c5bf34007208d5b887185865"
        ),
        "HKDF-Expand OKM"
    );
}

// ── AES-256 (raw block) — FIPS 197 ───────────────────────────────────────────

#[test]
fn kat_aes256_block_fips197() {
    // FIPS 197 §C.3 (AES-256): key = 000102..1f, in = 00112233..ff.
    let key = hexn::<32>("000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f");
    let cipher = Aes256::new(&key);
    let mut block = hexn::<16>("00112233445566778899aabbccddeeff");
    cipher.encrypt_block(&mut block);
    assert_eq!(block.to_vec(), hex("8ea2b7ca516745bfeafc49904b496089"));
    // Round-trip: decrypt restores the plaintext block.
    cipher.decrypt_block(&mut block);
    assert_eq!(block.to_vec(), hex("00112233445566778899aabbccddeeff"));
}

// ── AES-256-GCM — GCM spec (McGrew & Viega) ──────────────────────────────────

#[test]
fn kat_aes256_gcm_spec_case13_and_tamper() {
    // GCM spec Test Case 13 (AES-256): all-zero key + 96-bit IV, empty
    // plaintext and AAD ⇒ empty ciphertext, tag 530f8afb...738b.
    let key = [0u8; 32];
    let nonce = [0u8; 12];
    let gcm = Aes256Gcm::new(&key);
    let mut out = [0u8; TAG_SIZE]; // empty PT ⇒ output is just the tag
    let n = gcm.encrypt(&nonce, &[], &[], &mut out).expect("encrypt");
    assert_eq!(n, TAG_SIZE);
    assert_eq!(
        out.to_vec(),
        hex("530f8afbc74536b9a963b4f1c4cb738b"),
        "GCM tag for empty message under zero key/IV"
    );
    // Robustness: a flipped tag bit must fail authentication on decrypt.
    let mut tampered = out;
    tampered[0] ^= 1;
    let mut pt = [0u8; 0];
    assert!(
        gcm.decrypt(&nonce, &[], &tampered, &mut pt).is_err(),
        "tampered GCM tag must be rejected"
    );
}

// ── X25519 — RFC 7748 ────────────────────────────────────────────────────────

#[test]
fn kat_x25519_rfc7748() {
    // RFC 7748 §5.2, first test vector.
    let scalar = hexn::<32>("a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4");
    let u = hexn::<32>("e6db6867583030db3594c1a424b15f7c726624ec26b3353b10a903a6d0ab1c4c");
    let got = x25519(&scalar, &u).expect("x25519 shared secret");
    assert_eq!(
        got.to_vec(),
        hex("c3da55379de9c6908e94ea4df28d084f32eccf03491c71f754b4075577a28552")
    );
}

// ── Ed25519 — RFC 8032 (functional + unforgeability) ─────────────────────────

#[test]
fn kat_ed25519_sign_verify_and_forgery_rejected() {
    // Correctness + unforgeability: a genuine signature verifies; a tampered
    // signature or message is rejected. (The ed25519 module carries the exact
    // RFC 8032 KAT vectors; this manifest pins the security property.)
    let seed = hexn::<32>("0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20");
    let sk = Ed25519SigningKey::from_seed(&seed);
    let msg = b"riina crypto-audit manifest";
    let sig = sk.sign(msg);
    let vk = sk.public_key();
    assert!(vk.verify(msg, &sig).is_ok(), "valid signature must verify");

    let mut forged = sig;
    forged[10] ^= 0x40;
    assert!(vk.verify(msg, &forged).is_err(), "forged signature must be rejected");
    assert!(
        vk.verify(b"different message", &sig).is_err(),
        "signature must not verify a different message"
    );
}
