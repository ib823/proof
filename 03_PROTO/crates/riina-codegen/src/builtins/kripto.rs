// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Crypto-agility builtins (`kripto`) — the runtime behind REQ-48's
//! algorithm-SELECTION builtins `guna_kripto`/`use_crypto`,
//! `pilih_algo`/`select_algorithm`, `sifer`/`cipher` and
//! `hash_dengan`/`hash_with`.
//!
//! Until this module existed those eight names were **typed-only**: the
//! typechecker registered them as `Fn(Teks, Any, Kripto)` and ran the REQ-48
//! deprecation gate at their call sites, but no runtime bound them, so
//! `riinac run` failed with `unbound variable` exactly as `riinac build` did.
//!
//! # Two things this module is, and one it is not
//!
//! **1. The runtime half of the deprecation gate.** The static check
//! (`riina_typechecker::deprecated_algorithm_at_selection`) fires only when the
//! algorithm name is a string LITERAL — `guna_kripto("md5")` is rejected at
//! compile time, but `guna_kripto(nama)` with `nama` computed at runtime is not,
//! because the checker cannot see the string. Every selection here re-runs the
//! SAME policy (`riina_types::crypto_policy`, one table shared by both
//! checks so they cannot disagree), so a name the checker could not see is
//! still refused, at the moment of selection, with the same rationale. This is
//! the operational `accepts pol (CUse a) = (pol a = Current)` of
//! `02_FORMAL/coq/crypto/AlgorithmPolicy.v`, applied to the value rather than
//! the literal.
//!
//! **2. A handle to a real primitive.** A selection that passes policy returns
//! a HANDLE — a `Value::Builtin("kripto:<algorithm>")` — bound to the
//! corresponding `riina-core` implementation. The algorithm names mirror the
//! Coq `algo` inductive one-to-one:
//!
//! | Coq `algo` | canonical | family    | riina-core            |
//! |------------|-----------|-----------|-----------------------|
//! | `SHA256`   | `sha256`  | hash      | `crypto::sha2`        |
//! | `SHA3_256` | `sha3_256`| hash      | `crypto::keccak`      |
//! | `AES256`   | `aes256`  | AEAD      | `crypto::gcm` (GCM)   |
//! | `X25519`   | `x25519`  | key agree | `crypto::x25519`      |
//! | `MLKEM768` | `mlkem768`| KEM       | `crypto::ml_kem`      |
//! | `MLDSA65`  | `mldsa65` | signature | `crypto::ml_dsa`      |
//! | `ChaCha20` | `chacha20`| AEAD      | **none in-tree**      |
//! | `P256`     | `p256`    | —         | **none in-tree**      |
//! | `RSA2048`  | `rsa2048` | —         | **none in-tree**      |
//! | `Other s`  | `s`       | —         | **none**              |
//!
//! Selecting an algorithm that the policy ACCEPTS but that has no in-tree
//! primitive is a distinct, named runtime error ("no runtime primitive"), not
//! a policy rejection and not a silent stub: the Coq model says such a
//! selection is accepted, and this module says truthfully that it cannot then
//! be *used*. Nothing here pretends to be ChaCha20 or P-256.
//!
//! **What it is not:** a C/WASM runtime. The handles are interpreter-only. A
//! C AES-GCM or ML-KEM that is not `riina-core`'s would be a second, unverified
//! implementation behind a name that promises the verified one — the same
//! reasoning that keeps `jaring_tls_*` interpreter-only (master plan REQ-70).
//!
//! # Handle protocol
//!
//! Handles are applied like any builtin. A hash handle takes the text to hash.
//! Every other family takes `(op, payload)` where `op` is a Bahasa Melayu or
//! English operation name, so one handle serves the whole family and no
//! operation is inferred from argument shape:
//!
//! | family    | call                                        | result                 |
//! |-----------|---------------------------------------------|------------------------|
//! | hash      | `h(teks)`                                   | lowercase hex digest   |
//! | AEAD      | `h(("sulit", ((kunci, nonce), teks)))`      | hex `ct ‖ tag`         |
//! | AEAD      | `h(("buka", ((kunci, nonce), hex)))`        | `Ada(teks)` / `Tiada`  |
//! | key agree | `h(("awam", swasta))`                       | hex public key         |
//! | key agree | `h(("kongsi", (swasta, awam_rakan)))`       | hex shared secret      |
//! | KEM       | `h(("jana", benih64))`                      | `(ek, dk)` hex         |
//! | KEM       | `h(("kapsul", (ek, rawak32)))`              | `(ct, ss)` hex         |
//! | KEM       | `h(("nyahkapsul", (dk, ct)))`               | hex shared secret      |
//! | signature | `h(("jana", benih32))`                      | `(vk, sk)` hex         |
//! | signature | `h(("tandatangan", (sk, mesej)))`           | hex signature          |
//! | signature | `h(("sahkan", (vk, (mesej, tandatangan))))` | `betul` / `salah`      |
//!
//! Keys, nonces, seeds, ciphertexts and signatures cross the boundary as
//! lowercase hex of exactly the primitive's size; a wrong length is an error,
//! never padded or truncated. Key generation takes its randomness as an
//! explicit seed, as `riina-core` does — the builtin holds no RNG, so a program
//! decides where its entropy comes from and every operation is reproducible
//! under test. AEAD decryption failure is a VALUE (`Tiada`), not a crash: an
//! attacker-controlled ciphertext must not be able to abort the program.

use crate::value::{Sum, Value};
use crate::{Error, Result};
use riina_core::crypto::gcm::{Aes256Gcm, KEY_SIZE, NONCE_SIZE, TAG_SIZE};
use riina_core::crypto::keccak::Sha3_256;
use riina_core::crypto::ml_dsa::{
    MlDsa65KeyPair, MlDsa65SigningKey, MlDsa65VerifyingKey, PUBLIC_KEY_SIZE as DSA_PK,
    SECRET_KEY_SIZE as DSA_SK, SIGNATURE_SIZE as DSA_SIG,
};
use riina_core::crypto::ml_kem::{
    MlKem768DecapsulationKey, MlKem768EncapsulationKey, MlKem768KeyPair, CIPHERTEXT_SIZE as KEM_CT,
    PUBLIC_KEY_SIZE as KEM_EK, SECRET_KEY_SIZE as KEM_DK,
};
use riina_core::crypto::sha2::Sha256;
use riina_core::crypto::x25519::{x25519, x25519_base};
use riina_types::crypto_policy;

/// (BM name, EN name, canonical key). The canonical key is the name the
/// typechecker's `deprecated_algorithm_at_selection` also recognises.
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("guna_kripto", "use_crypto", "guna_kripto"),
    ("pilih_algo", "select_algorithm", "pilih_algo"),
    ("sifer", "cipher", "sifer"),
    ("hash_dengan", "hash_with", "hash_dengan"),
];

/// Prefix of every handle this module hands out. `apply_builtin` routes names
/// carrying it back here.
pub(crate) const HANDLE_PREFIX: &str = "kripto:";

/// Mirror of the Coq `algo` inductive (`crypto/AlgorithmPolicy.v`).
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) enum Algo {
    Aes256,
    ChaCha20,
    Sha256,
    Sha3_256,
    X25519,
    MlKem768,
    MlDsa65,
    P256,
    Rsa2048,
    Other(String),
}

/// What a handle can do. `Unbound` is "accepted by the policy model, no
/// primitive in this tree" — reported by name, never stubbed.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Family {
    Hash,
    Aead,
    KeyAgreement,
    Kem,
    Signature,
    Unbound,
}

impl Algo {
    /// Parse a user-facing algorithm name. Case, `-`, `_` and spaces are
    /// insignificant, so `SHA-256`, `sha_256` and `sha256` are one algorithm;
    /// the common aliases (`Kyber768`, `Dilithium3`, `secp256r1`) map to the
    /// standard's name. Anything else is `Other`, as in Coq.
    pub(crate) fn parse(name: &str) -> Self {
        let key: String = name
            .chars()
            .filter(|c| !matches!(c, '-' | '_' | ' '))
            .map(|c| c.to_ascii_lowercase())
            .collect();
        match key.as_str() {
            "aes256" | "aes256gcm" | "aesgcm256" => Self::Aes256,
            "chacha20" | "chacha20poly1305" => Self::ChaCha20,
            "sha256" | "sha2256" => Self::Sha256,
            "sha3256" => Self::Sha3_256,
            "x25519" | "curve25519" => Self::X25519,
            "mlkem768" | "kyber768" => Self::MlKem768,
            "mldsa65" | "dilithium3" => Self::MlDsa65,
            "p256" | "secp256r1" | "prime256v1" | "nistp256" | "ecdsap256" => Self::P256,
            "rsa2048" => Self::Rsa2048,
            _ => Self::Other(name.trim().to_ascii_lowercase()),
        }
    }

    /// The name inside the handle, and the name every error reports.
    pub(crate) fn canonical(&self) -> String {
        match self {
            Self::Aes256 => "aes256".into(),
            Self::ChaCha20 => "chacha20".into(),
            Self::Sha256 => "sha256".into(),
            Self::Sha3_256 => "sha3_256".into(),
            Self::X25519 => "x25519".into(),
            Self::MlKem768 => "mlkem768".into(),
            Self::MlDsa65 => "mldsa65".into(),
            Self::P256 => "p256".into(),
            Self::Rsa2048 => "rsa2048".into(),
            Self::Other(s) => s.clone(),
        }
    }

    /// Inverse of `canonical` for the bound algorithms (a handle's name).
    fn from_canonical(s: &str) -> Option<Self> {
        Some(match s {
            "aes256" => Self::Aes256,
            "sha256" => Self::Sha256,
            "sha3_256" => Self::Sha3_256,
            "x25519" => Self::X25519,
            "mlkem768" => Self::MlKem768,
            "mldsa65" => Self::MlDsa65,
            _ => return None,
        })
    }

    fn family(&self) -> Family {
        match self {
            Self::Sha256 | Self::Sha3_256 => Family::Hash,
            Self::Aes256 => Family::Aead,
            Self::X25519 => Family::KeyAgreement,
            Self::MlKem768 => Family::Kem,
            Self::MlDsa65 => Family::Signature,
            Self::ChaCha20 | Self::P256 | Self::Rsa2048 | Self::Other(_) => Family::Unbound,
        }
    }
}

/// The algorithms a handle can be bound to, for the "no runtime primitive"
/// message — so the reader learns what IS available, not just what is not.
const BOUND: &str = "aes256, sha256, sha3_256, x25519, mlkem768, mldsa65";

fn err(msg: impl Into<String>) -> Error {
    Error::InvalidOperation(msg.into())
}

/// Lowercase hex, the wire form of every key/nonce/ciphertext/signature.
pub(crate) fn to_hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

/// Hex of any length (ciphertexts, messages).
fn from_hex_vec(s: &str, ctx: &str) -> Result<Vec<u8>> {
    let s = s.trim();
    if !s.len().is_multiple_of(2) {
        return Err(err(format!("{ctx}: odd-length hex")));
    }
    (0..s.len() / 2)
        .map(|i| {
            u8::from_str_radix(&s[i * 2..i * 2 + 2], 16)
                .map_err(|_| err(format!("{ctx}: invalid hex")))
        })
        .collect()
}

/// Exactly `N` bytes of hex. A short or long key is an error — it is never
/// padded or truncated into something the primitive would accept.
fn from_hex<const N: usize>(s: &str, ctx: &str) -> Result<[u8; N]> {
    let v = from_hex_vec(s, ctx)?;
    if v.len() != N {
        return Err(err(format!(
            "{ctx}: expected {} hex chars ({N} bytes), got {}",
            N * 2,
            s.trim().len()
        )));
    }
    let mut out = [0u8; N];
    out.copy_from_slice(&v);
    Ok(out)
}

fn as_str(v: &Value, ctx: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        other => Err(Error::TypeMismatch {
            expected: "string".to_string(),
            found: format!("{other:?}"),
            context: ctx.to_string(),
        }),
    }
}

fn as_pair<'a>(v: &'a Value, ctx: &str) -> Result<(&'a Value, &'a Value)> {
    match v {
        Value::Pair(a, b) => Ok((a, b)),
        other => Err(Error::TypeMismatch {
            expected: "pair".to_string(),
            found: format!("{other:?}"),
            context: ctx.to_string(),
        }),
    }
}

fn ada(v: Value) -> Value {
    Value::Sum(Sum::Left(Box::new(v)))
}

fn tiada() -> Value {
    Value::Sum(Sum::Right(Box::new(Value::Unit)))
}

// ── Selection: the runtime `CUse a` ──────────────────────────────────────

/// Select an algorithm by name under the active policy and return its handle.
///
/// Order of checks, each with its own message so a failure says which rule
/// refused it: (1) policy — the SAME table the typechecker consults, applied
/// to the raw name exactly as the static gate applies it to a literal; (2) the
/// builtin's family, for the family-specific builtins; (3) availability of a
/// runtime primitive.
fn select(builtin: &str, arg: &Value) -> Result<Value> {
    let name = as_str(arg, builtin)?;
    if !crypto_policy::is_current(&name) {
        return Err(err(format!(
            "{builtin}: algorithm {name:?} is deprecated by policy — {}",
            crypto_policy::deprecation_reason(&name)
        )));
    }
    let algo = Algo::parse(&name);
    let canonical = algo.canonical();
    let family = algo.family();
    match builtin {
        "hash_dengan" if family != Family::Hash && family != Family::Unbound => {
            return Err(err(format!(
                "{builtin}: {canonical} is not a hash algorithm (use guna_kripto for a {} handle)",
                family_name(family)
            )));
        }
        "sifer" if family != Family::Aead && family != Family::Unbound => {
            return Err(err(format!(
                "{builtin}: {canonical} is not a cipher (use guna_kripto for a {} handle)",
                family_name(family)
            )));
        }
        _ => {}
    }
    if family == Family::Unbound {
        return Err(err(format!(
            "{builtin}: {canonical} is accepted by policy but has no runtime primitive in this \
             interpreter (bound: {BOUND})"
        )));
    }
    Ok(Value::Builtin(format!("{HANDLE_PREFIX}{canonical}")))
}

fn family_name(f: Family) -> &'static str {
    match f {
        Family::Hash => "hash",
        Family::Aead => "cipher",
        Family::KeyAgreement => "key-agreement",
        Family::Kem => "KEM",
        Family::Signature => "signature",
        Family::Unbound => "unbound",
    }
}

// ── Handle application ───────────────────────────────────────────────────

fn apply_handle(canonical: &str, arg: &Value) -> Result<Value> {
    let Some(algo) = Algo::from_canonical(canonical) else {
        return Err(err(format!("kripto: unknown handle {canonical:?}")));
    };
    let ctx = format!("kripto:{canonical}");
    match algo.family() {
        Family::Hash => {
            let data = as_str(arg, &ctx)?;
            let digest = match algo {
                Algo::Sha256 => Sha256::hash(data.as_bytes()).to_vec(),
                Algo::Sha3_256 => Sha3_256::hash(data.as_bytes()).to_vec(),
                _ => unreachable!("family() classified a non-hash as Hash"),
            };
            Ok(Value::String(to_hex(&digest)))
        }
        Family::Aead => aead(&ctx, arg),
        Family::KeyAgreement => key_agreement(&ctx, arg),
        Family::Kem => kem(&ctx, arg),
        Family::Signature => signature(&ctx, arg),
        Family::Unbound => Err(err(format!("{ctx}: no runtime primitive"))),
    }
}

/// `(op, payload)` — the operation name is explicit, never inferred from the
/// payload's shape.
fn op_and_payload<'a>(arg: &'a Value, ctx: &str) -> Result<(String, &'a Value)> {
    let (op, payload) = as_pair(arg, ctx)?;
    Ok((as_str(op, ctx)?, payload))
}

fn aead(ctx: &str, arg: &Value) -> Result<Value> {
    let (op, payload) = op_and_payload(arg, ctx)?;
    let (keys, data) = as_pair(payload, ctx)?;
    let (key, nonce) = as_pair(keys, ctx)?;
    let key: [u8; KEY_SIZE] = from_hex(&as_str(key, ctx)?, &format!("{ctx}: key"))?;
    let nonce: [u8; NONCE_SIZE] = from_hex(&as_str(nonce, ctx)?, &format!("{ctx}: nonce"))?;
    let cipher = Aes256Gcm::new(&key);
    match op.as_str() {
        "sulit" | "encrypt" => {
            let pt = as_str(data, ctx)?;
            let mut out = vec![0u8; pt.len() + TAG_SIZE];
            let n = cipher
                .encrypt(&nonce, &[], pt.as_bytes(), &mut out)
                .map_err(|e| err(format!("{ctx}: encrypt: {e:?}")))?;
            out.truncate(n);
            Ok(Value::String(to_hex(&out)))
        }
        "buka" | "decrypt" => {
            let ct = from_hex_vec(&as_str(data, ctx)?, &format!("{ctx}: ciphertext"))?;
            if ct.len() < TAG_SIZE {
                // Too short to even carry a tag: not a forgery attempt worth
                // distinguishing, just "does not open".
                return Ok(tiada());
            }
            let mut out = vec![0u8; ct.len() - TAG_SIZE];
            match cipher.decrypt(&nonce, &[], &ct, &mut out) {
                Ok(n) => {
                    out.truncate(n);
                    match String::from_utf8(out) {
                        Ok(pt) => Ok(ada(Value::String(pt))),
                        Err(_) => Err(err(format!(
                            "{ctx}: authenticated plaintext is not valid UTF-8"
                        ))),
                    }
                }
                // Authentication failure is a value: attacker-controlled input
                // must not be able to abort the program.
                Err(_) => Ok(tiada()),
            }
        }
        other => Err(err(format!(
            "{ctx}: unknown operation {other:?} (sulit/encrypt, buka/decrypt)"
        ))),
    }
}

fn key_agreement(ctx: &str, arg: &Value) -> Result<Value> {
    let (op, payload) = op_and_payload(arg, ctx)?;
    match op.as_str() {
        "awam" | "public" => {
            let sk: [u8; 32] = from_hex(&as_str(payload, ctx)?, &format!("{ctx}: private key"))?;
            Ok(Value::String(to_hex(&x25519_base(&sk))))
        }
        "kongsi" | "shared" => {
            let (sk, pk) = as_pair(payload, ctx)?;
            let sk: [u8; 32] = from_hex(&as_str(sk, ctx)?, &format!("{ctx}: private key"))?;
            let pk: [u8; 32] = from_hex(&as_str(pk, ctx)?, &format!("{ctx}: peer public key"))?;
            let ss = x25519(&sk, &pk)
                .map_err(|e| err(format!("{ctx}: shared secret rejected: {e:?}")))?;
            Ok(Value::String(to_hex(&ss)))
        }
        other => Err(err(format!(
            "{ctx}: unknown operation {other:?} (awam/public, kongsi/shared)"
        ))),
    }
}

fn kem(ctx: &str, arg: &Value) -> Result<Value> {
    let (op, payload) = op_and_payload(arg, ctx)?;
    match op.as_str() {
        "jana" | "keygen" => {
            let seed: [u8; 64] = from_hex(&as_str(payload, ctx)?, &format!("{ctx}: seed"))?;
            let kp = MlKem768KeyPair::generate(&seed)
                .map_err(|e| err(format!("{ctx}: keygen: {e:?}")))?;
            Ok(Value::Pair(
                Box::new(Value::String(to_hex(kp.encapsulation_key().as_bytes()))),
                Box::new(Value::String(to_hex(kp.decapsulation_key().as_bytes()))),
            ))
        }
        "kapsul" | "encapsulate" => {
            let (ek, rnd) = as_pair(payload, ctx)?;
            let ek: [u8; KEM_EK] =
                from_hex(&as_str(ek, ctx)?, &format!("{ctx}: encapsulation key"))?;
            let rnd: [u8; 32] = from_hex(&as_str(rnd, ctx)?, &format!("{ctx}: randomness"))?;
            let ek = MlKem768EncapsulationKey::from_bytes(&ek)
                .map_err(|e| err(format!("{ctx}: encapsulation key rejected: {e:?}")))?;
            let (ct, ss) = ek
                .encapsulate(&rnd)
                .map_err(|e| err(format!("{ctx}: encapsulate: {e:?}")))?;
            Ok(Value::Pair(
                Box::new(Value::String(to_hex(&ct))),
                Box::new(Value::String(to_hex(&ss))),
            ))
        }
        "nyahkapsul" | "decapsulate" => {
            let (dk, ct) = as_pair(payload, ctx)?;
            let dk: [u8; KEM_DK] =
                from_hex(&as_str(dk, ctx)?, &format!("{ctx}: decapsulation key"))?;
            let ct: [u8; KEM_CT] = from_hex(&as_str(ct, ctx)?, &format!("{ctx}: ciphertext"))?;
            let dk = MlKem768DecapsulationKey::from_bytes(&dk)
                .map_err(|e| err(format!("{ctx}: decapsulation key rejected: {e:?}")))?;
            let ss = dk
                .decapsulate(&ct)
                .map_err(|e| err(format!("{ctx}: decapsulate: {e:?}")))?;
            Ok(Value::String(to_hex(&ss)))
        }
        other => Err(err(format!(
            "{ctx}: unknown operation {other:?} (jana/keygen, kapsul/encapsulate, \
             nyahkapsul/decapsulate)"
        ))),
    }
}

fn signature(ctx: &str, arg: &Value) -> Result<Value> {
    let (op, payload) = op_and_payload(arg, ctx)?;
    match op.as_str() {
        "jana" | "keygen" => {
            let seed: [u8; 32] = from_hex(&as_str(payload, ctx)?, &format!("{ctx}: seed"))?;
            let kp = MlDsa65KeyPair::generate(&seed)
                .map_err(|e| err(format!("{ctx}: keygen: {e:?}")))?;
            Ok(Value::Pair(
                Box::new(Value::String(to_hex(kp.verifying_key().as_bytes()))),
                Box::new(Value::String(to_hex(kp.signing_key().as_bytes()))),
            ))
        }
        "tandatangan" | "sign" => {
            let (sk, msg) = as_pair(payload, ctx)?;
            let sk: [u8; DSA_SK] = from_hex(&as_str(sk, ctx)?, &format!("{ctx}: signing key"))?;
            let msg = as_str(msg, ctx)?;
            let sk = MlDsa65SigningKey::from_bytes(&sk)
                .map_err(|e| err(format!("{ctx}: signing key rejected: {e:?}")))?;
            let sig = sk
                .sign(msg.as_bytes())
                .map_err(|e| err(format!("{ctx}: sign: {e:?}")))?;
            Ok(Value::String(to_hex(&sig)))
        }
        "sahkan" | "verify" => {
            let (vk, rest) = as_pair(payload, ctx)?;
            let (msg, sig) = as_pair(rest, ctx)?;
            let vk: [u8; DSA_PK] = from_hex(&as_str(vk, ctx)?, &format!("{ctx}: verifying key"))?;
            let msg = as_str(msg, ctx)?;
            let vk = MlDsa65VerifyingKey::from_bytes(&vk)
                .map_err(|e| err(format!("{ctx}: verifying key rejected: {e:?}")))?;
            // A malformed signature is simply not a valid signature: `salah`,
            // not an abort — same reasoning as AEAD decryption.
            let Ok(sig) = from_hex::<DSA_SIG>(&as_str(sig, ctx)?, &format!("{ctx}: signature"))
            else {
                return Ok(Value::Bool(false));
            };
            Ok(Value::Bool(vk.verify(msg.as_bytes(), &sig).is_ok()))
        }
        other => Err(err(format!(
            "{ctx}: unknown operation {other:?} (jana/keygen, tandatangan/sign, sahkan/verify)"
        ))),
    }
}

/// Entry point from `apply_builtin`: the four selection builtins and every
/// handle they hand out. `None` for names that are not ours.
pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    if let Some(canonical) = name.strip_prefix(HANDLE_PREFIX) {
        return apply_handle(canonical, arg).map(Some);
    }
    match name {
        "guna_kripto" | "pilih_algo" | "sifer" | "hash_dengan" => select(name, arg).map(Some),
        _ => Ok(None),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn s(x: &str) -> Value {
        Value::String(x.to_string())
    }
    fn pair(a: Value, b: Value) -> Value {
        Value::Pair(Box::new(a), Box::new(b))
    }
    fn op(name: &str, payload: Value) -> Value {
        pair(s(name), payload)
    }
    fn handle(builtin: &str, algo: &str) -> Value {
        apply(builtin, &s(algo))
            .expect("selection must not error")
            .expect("selection must be ours")
    }
    fn call(h: &Value, arg: Value) -> Result<Value> {
        let Value::Builtin(name) = h else { panic!("handle must be a Builtin, got {h:?}") };
        apply(name, &arg).map(|r| r.expect("handle must be ours"))
    }
    fn str_of(v: Value) -> String {
        match v {
            Value::String(x) => x,
            other => panic!("expected string, got {other:?}"),
        }
    }

    // ── Selection mirrors the Coq model ─────────────────────────────────

    #[test]
    fn every_coq_algo_constructor_parses_to_its_canonical_name() {
        // The name table mirrors `crypto/AlgorithmPolicy.v` `algo` one-to-one;
        // case and separators are insignificant.
        for (input, want) in [
            ("AES-256-GCM", Algo::Aes256),
            ("aes256", Algo::Aes256),
            ("ChaCha20-Poly1305", Algo::ChaCha20),
            ("SHA-256", Algo::Sha256),
            ("sha_256", Algo::Sha256),
            ("SHA3-256", Algo::Sha3_256),
            ("X25519", Algo::X25519),
            ("ML-KEM-768", Algo::MlKem768),
            ("Kyber768", Algo::MlKem768),
            ("ML-DSA-65", Algo::MlDsa65),
            ("P-256", Algo::P256),
            ("secp256r1", Algo::P256),
            ("RSA-2048", Algo::Rsa2048),
            ("blake3", Algo::Other("blake3".into())),
        ] {
            assert_eq!(Algo::parse(input), want, "{input}");
        }
        for a in [
            Algo::Aes256,
            Algo::Sha256,
            Algo::Sha3_256,
            Algo::X25519,
            Algo::MlKem768,
            Algo::MlDsa65,
        ] {
            assert_eq!(Algo::from_canonical(&a.canonical()), Some(a.clone()), "{a:?} round-trips");
        }
    }

    #[test]
    fn deprecated_algorithm_is_refused_at_runtime_with_the_static_gates_reason() {
        // The runtime check consults the SAME table as the typechecker, so a
        // name the checker could not see (non-literal) is refused identically.
        for builtin in ["guna_kripto", "pilih_algo", "sifer", "hash_dengan"] {
            for algo in ["md5", "MD5", "sha1", "des", "rc4", "rsa1024"] {
                let e = apply(builtin, &s(algo)).expect_err("must be refused");
                let msg = format!("{e:?}");
                assert!(msg.contains("deprecated by policy"), "{builtin}({algo}): {msg}");
                assert!(
                    msg.contains(crypto_policy::deprecation_reason(algo)),
                    "{builtin}({algo}) must carry the policy's rationale: {msg}"
                );
            }
        }
    }

    #[test]
    fn current_algorithm_yields_a_handle_negative_control() {
        // NEGATIVE CONTROL for the test above: the check is COMPLETE (Coq
        // `uses_only_current_accepts`) — current algorithms are not refused.
        for (builtin, algo, want) in [
            ("guna_kripto", "aes256-gcm", "kripto:aes256"),
            ("pilih_algo", "SHA3-256", "kripto:sha3_256"),
            ("guna_kripto", "ML-KEM-768", "kripto:mlkem768"),
            ("guna_kripto", "ML-DSA-65", "kripto:mldsa65"),
            ("guna_kripto", "x25519", "kripto:x25519"),
            ("sifer", "AES-256-GCM", "kripto:aes256"),
            ("hash_dengan", "sha256", "kripto:sha256"),
        ] {
            assert_eq!(handle(builtin, algo), Value::Builtin(want.into()), "{builtin}({algo})");
        }
    }

    #[test]
    fn accepted_but_unbound_algorithm_is_named_not_stubbed() {
        // ChaCha20 / P-256 / RSA-2048 are `Current` under the active policy and
        // are constructors of the Coq model, but no primitive exists in-tree.
        // That is a distinct, named error — NOT a policy rejection, NOT a stub
        // that silently does something else.
        for algo in ["chacha20-poly1305", "P-256", "rsa2048", "blake3"] {
            let e = apply("guna_kripto", &s(algo)).expect_err("must be refused");
            let msg = format!("{e:?}");
            assert!(msg.contains("no runtime primitive"), "{algo}: {msg}");
            assert!(!msg.contains("deprecated"), "{algo} is not deprecated: {msg}");
            assert!(msg.contains(BOUND), "the message must say what IS bound: {msg}");
        }
    }

    #[test]
    fn family_specific_builtins_refuse_the_wrong_family() {
        let e = apply("hash_dengan", &s("aes256")).expect_err("a cipher is not a hash");
        assert!(format!("{e:?}").contains("not a hash algorithm"));
        let e = apply("sifer", &s("sha256")).expect_err("a hash is not a cipher");
        assert!(format!("{e:?}").contains("not a cipher"));
        // ...while the generic selectors take any bound algorithm.
        handle("guna_kripto", "sha256");
        handle("pilih_algo", "aes256");
    }

    // ── Known-answer tests pin the WIRING to riina-core, not the primitive ──

    #[test]
    fn hash_handles_match_published_test_vectors() {
        let sha256 = handle("hash_dengan", "sha256");
        assert_eq!(
            str_of(call(&sha256, s("abc")).unwrap()),
            "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
        );
        assert_eq!(
            str_of(call(&sha256, s("")).unwrap()),
            "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        );
        let sha3 = handle("hash_dengan", "sha3-256");
        assert_eq!(
            str_of(call(&sha3, s("abc")).unwrap()),
            "3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532"
        );
        assert_eq!(
            str_of(call(&sha3, s("")).unwrap()),
            "a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a"
        );
        // NEGATIVE CONTROL: the two handles are different algorithms.
        assert_ne!(
            call(&sha256, s("abc")).unwrap(),
            call(&sha3, s("abc")).unwrap()
        );
    }

    #[test]
    fn aes256_gcm_handle_matches_the_gcm_spec_test_case_14() {
        // GCM spec test case 14: K = 0^256, IV = 0^96, P = 0^128 →
        // C = cea7403d4d606b6e074ec5d3baf39d18, T = d0d1c8a799996bf0265b98b5d48ab919.
        let h = handle("sifer", "aes256");
        let keys = pair(s(&"00".repeat(32)), s(&"00".repeat(12)));
        let pt = String::from_utf8(vec![0u8; 16]).unwrap();
        let ct = str_of(call(&h, op("sulit", pair(keys.clone(), s(&pt)))).unwrap());
        assert_eq!(
            ct,
            "cea7403d4d606b6e074ec5d3baf39d18d0d1c8a799996bf0265b98b5d48ab919",
            "ciphertext ‖ tag"
        );
        // Round trip, BM and EN operation names.
        let back = call(&h, op("decrypt", pair(keys.clone(), s(&ct)))).unwrap();
        assert_eq!(back, ada(s(&pt)));
        // Tampering the tag → `Tiada`, a value, not an abort.
        let mut tampered = ct.clone();
        tampered.replace_range(ct.len() - 2.., "00");
        assert_eq!(call(&h, op("buka", pair(keys.clone(), s(&tampered)))).unwrap(), tiada());
        // Wrong key → `Tiada`.
        let wrong = pair(s(&"01".repeat(32)), s(&"00".repeat(12)));
        assert_eq!(call(&h, op("buka", pair(wrong, s(&ct)))).unwrap(), tiada());
        // A key of the wrong length is an ERROR, never padded.
        let short = pair(s(&"00".repeat(16)), s(&"00".repeat(12)));
        let e = call(&h, op("sulit", pair(short, s("x")))).expect_err("16-byte key");
        assert!(format!("{e:?}").contains("expected 64 hex chars"));
    }

    #[test]
    fn x25519_handle_matches_rfc_7748_section_6_1() {
        let h = handle("guna_kripto", "x25519");
        let a_sk = "77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a";
        let b_sk = "5dab087e624a8a4b79e17f8b83800ee66f3bb1292618b6fd1c2f8b27ff88e0eb";
        let a_pk = str_of(call(&h, op("awam", s(a_sk))).unwrap());
        let b_pk = str_of(call(&h, op("public", s(b_sk))).unwrap());
        assert_eq!(a_pk, "8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a");
        assert_eq!(b_pk, "de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f");
        let k_ab = str_of(call(&h, op("kongsi", pair(s(a_sk), s(&b_pk)))).unwrap());
        let k_ba = str_of(call(&h, op("shared", pair(s(b_sk), s(&a_pk)))).unwrap());
        assert_eq!(k_ab, "4a5d9d5ba4ce2de1728e3bf480350f25e07e21c947d19e3376f09b3c1e161742");
        assert_eq!(k_ab, k_ba);
        // The all-zero point is rejected by riina-core; the handle surfaces it.
        let e = call(&h, op("kongsi", pair(s(a_sk), s(&"00".repeat(32))))).expect_err("low order");
        assert!(format!("{e:?}").contains("shared secret rejected"));
    }

    #[test]
    fn mlkem768_handle_round_trips_and_rejects_the_wrong_ciphertext() {
        let h = handle("guna_kripto", "ML-KEM-768");
        let seed = (0u8..64).map(|b| format!("{b:02x}")).collect::<String>();
        let (ek, dk) = match call(&h, op("jana", s(&seed))).unwrap() {
            Value::Pair(a, b) => (str_of(*a), str_of(*b)),
            other => panic!("{other:?}"),
        };
        assert_eq!(ek.len(), KEM_EK * 2);
        assert_eq!(dk.len(), KEM_DK * 2);
        // Deterministic in the seed.
        assert_eq!(call(&h, op("keygen", s(&seed))).unwrap(), call(&h, op("jana", s(&seed))).unwrap());
        let rnd = "ab".repeat(32);
        let (ct, ss) = match call(&h, op("kapsul", pair(s(&ek), s(&rnd)))).unwrap() {
            Value::Pair(a, b) => (str_of(*a), str_of(*b)),
            other => panic!("{other:?}"),
        };
        assert_eq!(ct.len(), KEM_CT * 2);
        assert_eq!(ss.len(), 64);
        let ss2 = str_of(call(&h, op("nyahkapsul", pair(s(&dk), s(&ct)))).unwrap());
        assert_eq!(ss, ss2, "decapsulation recovers the shared secret");
        // NEGATIVE CONTROL: a corrupted ciphertext decapsulates to a DIFFERENT
        // secret (FIPS 203 implicit rejection), never to the real one.
        let mut bad = ct.clone();
        bad.replace_range(0..2, if &ct[0..2] == "00" { "01" } else { "00" });
        let ss3 = str_of(call(&h, op("decapsulate", pair(s(&dk), s(&bad)))).unwrap());
        assert_ne!(ss, ss3);
    }

    #[test]
    fn mldsa65_handle_signs_verifies_and_refuses_forgeries() {
        let h = handle("pilih_algo", "ML-DSA-65");
        let seed = "42".repeat(32);
        let (vk, sk) = match call(&h, op("jana", s(&seed))).unwrap() {
            Value::Pair(a, b) => (str_of(*a), str_of(*b)),
            other => panic!("{other:?}"),
        };
        assert_eq!(vk.len(), DSA_PK * 2);
        assert_eq!(sk.len(), DSA_SK * 2);
        let sig = str_of(call(&h, op("tandatangan", pair(s(&sk), s("mesej")))).unwrap());
        assert_eq!(sig.len(), DSA_SIG * 2);
        let ok = call(&h, op("sahkan", pair(s(&vk), pair(s("mesej"), s(&sig))))).unwrap();
        assert_eq!(ok, Value::Bool(true));
        // NEGATIVE CONTROLS: other message, bit-flipped signature, malformed
        // signature — each is `salah`, a value, not an abort.
        let other = call(&h, op("verify", pair(s(&vk), pair(s("mesej!"), s(&sig))))).unwrap();
        assert_eq!(other, Value::Bool(false));
        let mut flipped = sig.clone();
        flipped.replace_range(0..2, if &sig[0..2] == "00" { "01" } else { "00" });
        let bad = call(&h, op("sahkan", pair(s(&vk), pair(s("mesej"), s(&flipped))))).unwrap();
        assert_eq!(bad, Value::Bool(false));
        let short = call(&h, op("sahkan", pair(s(&vk), pair(s("mesej"), s("abcd"))))).unwrap();
        assert_eq!(short, Value::Bool(false));
    }

    #[test]
    fn unknown_operation_names_are_errors_not_guesses() {
        let h = handle("guna_kripto", "aes256");
        let keys = pair(s(&"00".repeat(32)), s(&"00".repeat(12)));
        let e = call(&h, op("hash", pair(keys, s("x")))).expect_err("no such op");
        assert!(format!("{e:?}").contains("unknown operation"));
        // And a handle name that was never handed out is refused.
        let e = apply("kripto:chacha20", &s("x")).unwrap_err();
        assert!(format!("{e:?}").contains("unknown handle"));
    }
}
