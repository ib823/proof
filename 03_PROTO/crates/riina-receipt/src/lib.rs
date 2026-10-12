// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Keyed execution receipts for effectful RIINA runtime operations.
//!
//! A [`ReceiptChain`] is an append-only log of [`EffectReceipt`]s in which
//! every link carries an **HMAC-SHA256 tag** (from the first-party
//! `riina-core`) computed under a secret [`ReceiptKey`]. A finished chain is
//! closed with a **seal** — a second HMAC over the chain id, the receipt count
//! and the head tag.
//!
//! # What verification establishes
//!
//! [`ReceiptChain::verify`] succeeds only if every receipt's tag, every
//! back-link and the seal all check out under the verifier's key. Without the
//! key an adversary cannot produce a chain that verifies, so the following
//! are all detected (each has a test below):
//!
//! * editing any field of any receipt (effect, program hash, timestamp,
//!   sequence number, back-link, tag) or the chain id;
//! * reordering, inserting or deleting receipts, including dropping trailing
//!   receipts (the seal pins the count and the head) and stripping the seal
//!   (an unsealed chain does not `verify`);
//! * rebuilding the whole history and re-chaining it — the attack that the
//!   previous unkeyed FNV-1a chain could not detect;
//! * splicing receipts between two chains, even chains under the same key with
//!   identical contents (every tag covers the chain id);
//! * verifying under the wrong key.
//!
//! # What it does NOT establish
//!
//! * **Non-repudiation / third-party verifiability.** HMAC is symmetric:
//!   anyone who can verify can also forge. The key must be held only by the
//!   receipt producer and verifiers it trusts. Publicly verifiable receipts
//!   need signatures (e.g. Ed25519/ML-DSA from `riina-core`), not built here.
//! * **Freshness / rollback.** A key holder can seal any prefix of a chain;
//!   if two seals were ever issued for one chain id, the older (shorter) one
//!   still verifies. Seal a chain once, give every chain a unique id, and
//!   anchor the head externally ([`ReceiptChain::verify_anchored`]) when
//!   rollback matters.
//! * **Truthfulness.** A receipt proves the key holder recorded it, not that
//!   the effect happened as described. `program_hash` is the caller's 64-bit
//!   program identifier and is only as strong as the caller makes it.
//! * **Key management.** Generating, storing and rotating the key is the
//!   embedding application's job; `riina-core` has no entropy source.
//!
//! # Wire format (version 1)
//!
//! Every MAC input is a sequence of fields, each encoded as an 8-byte
//! big-endian length followed by the field bytes (`lp(x) = u64_be(len x) ‖ x`),
//! so no two distinct field lists encode to the same bytes:
//!
//! ```text
//! tag_i  = HMAC-SHA256(key, lp("RIINA-RECEIPT-LINK-v1") ‖ lp(chain_id)
//!                           ‖ lp(u64_be(sequence_i)) ‖ lp(prev_tag_i)
//!                           ‖ lp(u64_be(program_hash_i)) ‖ lp(u64_be(timestamp_i))
//!                           ‖ lp(utf8(effect_type_i)))
//! prev_tag_0 = 32 zero bytes;  prev_tag_i = tag_{i-1};  sequence_i = i
//! seal   = HMAC-SHA256(key, lp("RIINA-RECEIPT-SEAL-v1") ‖ lp(chain_id)
//!                           ‖ lp(u64_be(receipt_count)) ‖ lp(head_tag))
//! head_tag = tag of the last receipt, or 32 zero bytes for an empty chain
//! ```
//!
//! The `known_answer_*` tests pin both the encoding and the tags against an
//! independent HMAC implementation.
//!
//! # History
//!
//! Until 2026-10 the chain used an unkeyed 64-bit FNV-1a hash; anyone could
//! rewrite history and recompute it (audit L4). That mode had no consumers and
//! was removed rather than kept beside the keyed one, so no caller can pick
//! the forgeable variant by accident.

use riina_core::constant_time::ConstantTimeEq;
use riina_core::crypto::hmac::HmacSha256;
use riina_core::zeroize::Zeroize;
use std::fmt;

/// Length of a [`ReceiptKey`] in bytes (256-bit HMAC-SHA256 key).
pub const RECEIPT_KEY_LEN: usize = 32;

/// Length of a receipt tag / seal in bytes (HMAC-SHA256 output).
pub const RECEIPT_TAG_LEN: usize = 32;

/// An HMAC-SHA256 receipt tag or seal.
pub type ReceiptTag = [u8; RECEIPT_TAG_LEN];

/// Back-link of the first receipt, and head of an empty chain.
pub const GENESIS_TAG: ReceiptTag = [0u8; RECEIPT_TAG_LEN];

/// Domain separator for per-receipt link tags.
const LINK_DOMAIN: &[u8] = b"RIINA-RECEIPT-LINK-v1";

/// Domain separator for chain seals.
const SEAL_DOMAIN: &[u8] = b"RIINA-RECEIPT-SEAL-v1";

/// Secret HMAC key for a receipt chain. Zeroized on drop; never printed.
pub struct ReceiptKey {
    bytes: [u8; RECEIPT_KEY_LEN],
}

impl ReceiptKey {
    /// Wrap a 32-byte key. The caller must draw it from a CSPRNG.
    #[must_use]
    pub fn from_bytes(bytes: [u8; RECEIPT_KEY_LEN]) -> Self {
        Self { bytes }
    }

    /// Wrap a key given as a slice.
    ///
    /// # Errors
    ///
    /// [`ReceiptError::InvalidKeyLength`] unless the slice is exactly
    /// [`RECEIPT_KEY_LEN`] bytes long.
    pub fn from_slice(bytes: &[u8]) -> Result<Self, ReceiptError> {
        let array: [u8; RECEIPT_KEY_LEN] = bytes
            .try_into()
            .map_err(|_| ReceiptError::InvalidKeyLength { len: bytes.len() })?;
        Ok(Self::from_bytes(array))
    }

    fn mac(&self, message: &[u8]) -> ReceiptTag {
        HmacSha256::mac(&self.bytes, message)
    }
}

impl Drop for ReceiptKey {
    fn drop(&mut self) {
        self.bytes.zeroize();
    }
}

impl fmt::Debug for ReceiptKey {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("ReceiptKey(<redacted>)")
    }
}

/// Why a receipt operation or verification failed.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ReceiptError {
    /// A key of the wrong length was supplied.
    InvalidKeyLength {
        /// The rejected length.
        len: usize,
    },
    /// The chain is sealed; nothing more may be appended or sealed.
    Sealed,
    /// The chain has no seal, so a full [`ReceiptChain::verify`] cannot
    /// rule out removed trailing receipts.
    Unsealed,
    /// Receipt `index` carries the wrong sequence number.
    Sequence {
        /// Position of the offending receipt.
        index: usize,
    },
    /// Receipt `index` does not link to its predecessor's tag.
    BrokenLink {
        /// Position of the offending receipt.
        index: usize,
    },
    /// Receipt `index`'s tag does not verify (edited field, wrong key, or a
    /// receipt taken from another chain).
    BadTag {
        /// Position of the offending receipt.
        index: usize,
    },
    /// The seal does not match the chain (truncated or extended chain, edited
    /// chain id, or wrong key).
    BadSeal,
    /// The chain does not match the externally anchored length/head.
    AnchorMismatch,
}

impl fmt::Display for ReceiptError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidKeyLength { len } => {
                write!(f, "receipt key must be {RECEIPT_KEY_LEN} bytes, got {len}")
            }
            Self::Sealed => f.write_str("receipt chain is sealed"),
            Self::Unsealed => f.write_str("receipt chain is not sealed"),
            Self::Sequence { index } => write!(f, "receipt {index}: wrong sequence number"),
            Self::BrokenLink { index } => write!(f, "receipt {index}: broken back-link"),
            Self::BadTag { index } => write!(f, "receipt {index}: tag does not verify"),
            Self::BadSeal => f.write_str("receipt chain seal does not verify"),
            Self::AnchorMismatch => f.write_str("receipt chain does not match its anchor"),
        }
    }
}

impl std::error::Error for ReceiptError {}

/// One effect recorded at an Effect Gate boundary.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EffectReceipt {
    /// Position in the chain, starting at 0.
    pub sequence: u64,
    /// Caller-supplied identifier of the program that performed the effect.
    pub program_hash: u64,
    /// The effect performed (e.g. `network_send`).
    pub effect_type: String,
    /// Caller-supplied timestamp (0 when the caller has none).
    pub timestamp: u64,
    /// Tag of the previous receipt ([`GENESIS_TAG`] for the first).
    pub prev_tag: ReceiptTag,
    /// HMAC-SHA256 tag over this receipt and its back-link.
    pub tag: ReceiptTag,
}

/// A keyed, sealable, append-only receipt chain.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ReceiptChain {
    chain_id: Vec<u8>,
    receipts: Vec<EffectReceipt>,
    seal: Option<ReceiptTag>,
}

/// `lp(f1) ‖ lp(f2) ‖ …` — the unambiguous field encoding.
fn encode_fields(fields: &[&[u8]]) -> Vec<u8> {
    let total: usize = fields.iter().map(|f| 8 + f.len()).sum();
    let mut out = Vec::with_capacity(total);
    for field in fields {
        out.extend_from_slice(&(field.len() as u64).to_be_bytes());
        out.extend_from_slice(field);
    }
    out
}

fn link_message(
    chain_id: &[u8],
    sequence: u64,
    prev_tag: &ReceiptTag,
    program_hash: u64,
    timestamp: u64,
    effect_type: &str,
) -> Vec<u8> {
    encode_fields(&[
        LINK_DOMAIN,
        chain_id,
        &sequence.to_be_bytes(),
        prev_tag,
        &program_hash.to_be_bytes(),
        &timestamp.to_be_bytes(),
        effect_type.as_bytes(),
    ])
}

fn seal_message(chain_id: &[u8], count: u64, head: &ReceiptTag) -> Vec<u8> {
    encode_fields(&[SEAL_DOMAIN, chain_id, &count.to_be_bytes(), head])
}

impl ReceiptChain {
    /// Start an empty chain. `chain_id` should be unique per chain (e.g. a
    /// random run id): every tag covers it, so receipts cannot move between
    /// chains.
    #[must_use]
    pub fn new(chain_id: &[u8]) -> Self {
        Self {
            chain_id: chain_id.to_vec(),
            receipts: Vec::new(),
            seal: None,
        }
    }

    /// Reassemble a chain from stored parts (e.g. loaded from disk) so it can
    /// be verified. Nothing is checked here — call [`Self::verify`].
    #[must_use]
    pub fn from_parts(
        chain_id: Vec<u8>,
        receipts: Vec<EffectReceipt>,
        seal: Option<ReceiptTag>,
    ) -> Self {
        Self {
            chain_id,
            receipts,
            seal,
        }
    }

    /// The chain id every tag is bound to.
    #[must_use]
    pub fn chain_id(&self) -> &[u8] {
        &self.chain_id
    }

    /// The receipts, in order.
    #[must_use]
    pub fn receipts(&self) -> &[EffectReceipt] {
        &self.receipts
    }

    /// The seal, if the chain has been sealed.
    #[must_use]
    pub fn seal_tag(&self) -> Option<&ReceiptTag> {
        self.seal.as_ref()
    }

    /// Whether the chain has been sealed.
    #[must_use]
    pub fn is_sealed(&self) -> bool {
        self.seal.is_some()
    }

    /// Append a receipt with timestamp 0.
    ///
    /// # Errors
    ///
    /// [`ReceiptError::Sealed`] if the chain is already sealed.
    pub fn append(
        &mut self,
        key: &ReceiptKey,
        effect: &str,
        program_hash: u64,
    ) -> Result<&EffectReceipt, ReceiptError> {
        self.append_at(key, effect, program_hash, 0)
    }

    /// Append a receipt with an explicit timestamp.
    ///
    /// # Errors
    ///
    /// [`ReceiptError::Sealed`] if the chain is already sealed.
    pub fn append_at(
        &mut self,
        key: &ReceiptKey,
        effect: &str,
        program_hash: u64,
        timestamp: u64,
    ) -> Result<&EffectReceipt, ReceiptError> {
        if self.seal.is_some() {
            return Err(ReceiptError::Sealed);
        }
        let sequence = self.receipts.len() as u64;
        let prev_tag = self.head();
        let tag = key.mac(&link_message(
            &self.chain_id,
            sequence,
            &prev_tag,
            program_hash,
            timestamp,
            effect,
        ));
        self.receipts.push(EffectReceipt {
            sequence,
            program_hash,
            effect_type: effect.to_string(),
            timestamp,
            prev_tag,
            tag,
        });
        Ok(self
            .receipts
            .last()
            .expect("receipt chain must contain the appended receipt"))
    }

    /// Close the chain: compute and store the seal. No further appends.
    ///
    /// # Errors
    ///
    /// [`ReceiptError::Sealed`] if the chain is already sealed.
    pub fn seal(&mut self, key: &ReceiptKey) -> Result<ReceiptTag, ReceiptError> {
        if self.seal.is_some() {
            return Err(ReceiptError::Sealed);
        }
        let seal = key.mac(&seal_message(
            &self.chain_id,
            self.receipts.len() as u64,
            &self.head(),
        ));
        self.seal = Some(seal);
        Ok(seal)
    }

    /// Full verification of a finished chain: every link tag, every back-link
    /// and the seal, all under `key`, with constant-time tag comparison.
    ///
    /// # Errors
    ///
    /// [`ReceiptError::Unsealed`] for an unsealed chain (a stripped seal must
    /// not hide removed receipts), otherwise the first failing check.
    pub fn verify(&self, key: &ReceiptKey) -> Result<(), ReceiptError> {
        let seal = self.seal.as_ref().ok_or(ReceiptError::Unsealed)?;
        self.verify_links(key)?;
        let expected = key.mac(&seal_message(
            &self.chain_id,
            self.receipts.len() as u64,
            &self.head(),
        ));
        if !expected.ct_eq(seal) {
            return Err(ReceiptError::BadSeal);
        }
        Ok(())
    }

    /// Verify every link tag and back-link under `key`, ignoring any seal.
    ///
    /// **Does not detect removal of trailing receipts**: every prefix of a
    /// genuine chain is itself a genuine chain. Use it only for a chain that
    /// is still being written, together with an externally anchored head
    /// ([`Self::verify_anchored`]); a finished chain uses [`Self::verify`].
    ///
    /// # Errors
    ///
    /// The first failing check.
    pub fn verify_links(&self, key: &ReceiptKey) -> Result<(), ReceiptError> {
        let mut expected_prev = GENESIS_TAG;
        for (index, receipt) in self.receipts.iter().enumerate() {
            if receipt.sequence != index as u64 {
                return Err(ReceiptError::Sequence { index });
            }
            if !receipt.prev_tag.ct_eq(&expected_prev) {
                return Err(ReceiptError::BrokenLink { index });
            }
            let expected = key.mac(&link_message(
                &self.chain_id,
                receipt.sequence,
                &receipt.prev_tag,
                receipt.program_hash,
                receipt.timestamp,
                &receipt.effect_type,
            ));
            if !expected.ct_eq(&receipt.tag) {
                return Err(ReceiptError::BadTag { index });
            }
            expected_prev = receipt.tag;
        }
        Ok(())
    }

    /// Verify the links of a (possibly unsealed) chain against a length and
    /// head recorded somewhere the adversary cannot rewrite.
    ///
    /// # Errors
    ///
    /// [`ReceiptError::AnchorMismatch`] if the length or head differ,
    /// otherwise the first failing link check.
    pub fn verify_anchored(
        &self,
        key: &ReceiptKey,
        expected_len: usize,
        expected_head: &ReceiptTag,
    ) -> Result<(), ReceiptError> {
        self.verify_links(key)?;
        if self.receipts.len() != expected_len || !self.head().ct_eq(expected_head) {
            return Err(ReceiptError::AnchorMismatch);
        }
        Ok(())
    }

    /// Number of receipts.
    #[must_use]
    pub fn len(&self) -> usize {
        self.receipts.len()
    }

    /// Whether the chain has no receipts.
    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.receipts.is_empty()
    }

    /// Tag of the last receipt ([`GENESIS_TAG`] for an empty chain).
    #[must_use]
    pub fn head(&self) -> ReceiptTag {
        self.receipts
            .last()
            .map(|receipt| receipt.tag)
            .unwrap_or(GENESIS_TAG)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn key() -> ReceiptKey {
        ReceiptKey::from_bytes([0x42; RECEIPT_KEY_LEN])
    }

    fn other_key() -> ReceiptKey {
        ReceiptKey::from_bytes([0x24; RECEIPT_KEY_LEN])
    }

    /// A sealed three-receipt chain under `key()`.
    fn sealed_chain(chain_id: &[u8]) -> ReceiptChain {
        let k = key();
        let mut chain = ReceiptChain::new(chain_id);
        chain.append_at(&k, "network_send", 7, 100).unwrap();
        chain.append_at(&k, "crypto_hash", 11, 200).unwrap();
        chain.append_at(&k, "fs_write", 7, 300).unwrap();
        chain.seal(&k).unwrap();
        chain
    }

    fn hex(bytes: &[u8]) -> String {
        bytes.iter().map(|b| format!("{b:02x}")).collect()
    }

    // ── Genuine chains ─────────────────────────────────────────────────

    #[test]
    fn genuine_sealed_chain_verifies() {
        let chain = sealed_chain(b"run-1");
        assert_eq!(chain.verify(&key()), Ok(()));
        assert_eq!(chain.len(), 3);
        assert!(chain.is_sealed());
    }

    #[test]
    fn empty_sealed_chain_verifies_and_reports_genesis_head() {
        let mut chain = ReceiptChain::new(b"empty");
        assert_eq!(chain.head(), GENESIS_TAG);
        assert!(chain.is_empty());
        chain.seal(&key()).unwrap();
        assert_eq!(chain.verify(&key()), Ok(()));
    }

    #[test]
    fn first_receipt_links_to_genesis_and_sequences_count_up() {
        let chain = sealed_chain(b"run-1");
        assert_eq!(chain.receipts()[0].prev_tag, GENESIS_TAG);
        for (i, receipt) in chain.receipts().iter().enumerate() {
            assert_eq!(receipt.sequence, i as u64);
            if i > 0 {
                assert_eq!(receipt.prev_tag, chain.receipts()[i - 1].tag);
            }
        }
        assert_eq!(chain.head(), chain.receipts()[2].tag);
    }

    #[test]
    fn head_changes_with_each_append() {
        let k = key();
        let mut chain = ReceiptChain::new(b"run-1");
        let first = chain.append(&k, "network_send", 7).unwrap().tag;
        let second = chain.append(&k, "crypto_hash", 7).unwrap().tag;
        assert_ne!(first, second);
        assert_eq!(chain.head(), second);
    }

    #[test]
    fn tags_are_deterministic() {
        assert_eq!(sealed_chain(b"run-1"), sealed_chain(b"run-1"));
    }

    #[test]
    fn unsealed_live_chain_verifies_links_and_anchor_only() {
        let k = key();
        let mut chain = ReceiptChain::new(b"live");
        chain.append(&k, "network_send", 7).unwrap();
        chain.append(&k, "fs_write", 7).unwrap();
        assert_eq!(chain.verify_links(&k), Ok(()));
        let head = chain.head();
        assert_eq!(chain.verify_anchored(&k, 2, &head), Ok(()));
        // A full verify demands the seal.
        assert_eq!(chain.verify(&k), Err(ReceiptError::Unsealed));
    }

    #[test]
    fn sealed_chain_refuses_further_appends_and_reseal() {
        let mut chain = sealed_chain(b"run-1");
        assert_eq!(
            chain.append(&key(), "late", 7).map(|_| ()),
            Err(ReceiptError::Sealed)
        );
        assert_eq!(chain.seal(&key()), Err(ReceiptError::Sealed));
    }

    #[test]
    fn key_length_is_enforced_and_key_is_redacted() {
        assert_eq!(
            ReceiptKey::from_slice(&[0u8; 16]).map(|_| ()),
            Err(ReceiptError::InvalidKeyLength { len: 16 })
        );
        assert!(ReceiptKey::from_slice(&[0u8; 32]).is_ok());
        assert_eq!(format!("{:?}", key()), "ReceiptKey(<redacted>)");
    }

    // ── Known-answer tests (independent HMAC-SHA256 reference) ──────────
    //
    // Expected values computed with Python's `hmac`/`hashlib` (not this
    // crate): key = bytes(range(32)), chain id "kat-chain".

    fn kat_key() -> ReceiptKey {
        let mut bytes = [0u8; RECEIPT_KEY_LEN];
        for (i, b) in bytes.iter_mut().enumerate() {
            *b = i as u8;
        }
        ReceiptKey::from_bytes(bytes)
    }

    #[test]
    fn known_answer_link_encoding() {
        let msg = link_message(
            b"kat-chain",
            0,
            &GENESIS_TAG,
            7,
            1_700_000_000,
            "network_send",
        );
        assert_eq!(
            hex(&msg),
            concat!(
                "0000000000000015",
                "5249494e412d524543454950542d4c494e4b2d7631",
                "0000000000000009",
                "6b61742d636861696e",
                "0000000000000008",
                "0000000000000000",
                "0000000000000020",
                "0000000000000000000000000000000000000000000000000000000000000000",
                "0000000000000008",
                "0000000000000007",
                "0000000000000008",
                "000000006553f100",
                "000000000000000c",
                "6e6574776f726b5f73656e64",
            )
        );
    }

    #[test]
    fn known_answer_tags_and_seal() {
        let k = kat_key();
        let mut chain = ReceiptChain::new(b"kat-chain");
        chain
            .append_at(&k, "network_send", 7, 1_700_000_000)
            .unwrap();
        chain.append_at(&k, "fs_write", 7, 1_700_000_001).unwrap();
        let seal = chain.seal(&k).unwrap();
        assert_eq!(hex(&chain.receipts()[0].tag), KAT_TAG_0);
        assert_eq!(hex(&chain.receipts()[1].tag), KAT_TAG_1);
        assert_eq!(hex(&seal), KAT_SEAL);
        assert_eq!(chain.verify(&k), Ok(()));
    }

    const KAT_TAG_0: &str = "afcf6a94bc09df32bce6a1d63896d08c8832a0afcdbd14af3b353e2cfa2e8a73";
    const KAT_TAG_1: &str = "56729839e94690fec6a1583752ae127cc7f1e075e447d0ff73b01fafab69d900";
    const KAT_SEAL: &str = "349b92b957821da5557f83ae2b39fc7446ac0893de791e57220e6537af117a00";

    // ── Adversarial: everything below must FAIL keyed verification ──────

    /// The attack the unkeyed FNV-1a chain could not stop (audit L4): rewrite
    /// history and recompute every link. Without the key the forger must use
    /// some other key (or none), and the result does not verify.
    #[test]
    fn rechained_forgery_fails_keyed_verification() {
        let honest = sealed_chain(b"run-1");
        assert_eq!(honest.verify(&key()), Ok(()));

        // Re-chain a rewritten history under a key the forger controls.
        let forger = ReceiptKey::from_bytes([0x99; RECEIPT_KEY_LEN]);
        let mut forged = ReceiptChain::new(b"run-1");
        forged.append_at(&forger, "network_send", 7, 100).unwrap();
        forged
            .append_at(&forger, "nothing_to_see", 11, 200)
            .unwrap();
        forged.append_at(&forger, "fs_write", 7, 300).unwrap();
        forged.seal(&forger).unwrap();
        assert_eq!(
            forged.verify(&key()),
            Err(ReceiptError::BadTag { index: 0 })
        );

        // Rewrite one effect and keep every honest tag, link and the seal.
        let mut edited = honest.clone();
        edited.receipts[1].effect_type = "nothing_to_see".into();
        assert_eq!(
            edited.verify(&key()),
            Err(ReceiptError::BadTag { index: 1 })
        );

        // Rewrite and "recompute" the tail with a guessed tag.
        let mut guessed = honest.clone();
        guessed.receipts[2].effect_type = "nothing_to_see".into();
        guessed.receipts[2].tag = [0u8; RECEIPT_TAG_LEN];
        assert_eq!(
            guessed.verify(&key()),
            Err(ReceiptError::BadTag { index: 2 })
        );
    }

    #[test]
    fn every_field_edit_fails_verification() {
        let honest = sealed_chain(b"run-1");
        type Edit = fn(&mut ReceiptChain);
        let edits: [(&str, Edit); 8] = [
            ("effect_type", |c| {
                c.receipts[1].effect_type = "fs_write".into()
            }),
            ("program_hash", |c| c.receipts[1].program_hash = 12),
            ("timestamp", |c| c.receipts[1].timestamp = 201),
            ("sequence", |c| c.receipts[1].sequence = 5),
            ("prev_tag", |c| c.receipts[1].prev_tag[0] ^= 1),
            ("tag", |c| c.receipts[1].tag[31] ^= 0x80),
            ("chain_id", |c| c.chain_id = b"run-2".to_vec()),
            ("seal", |c| {
                if let Some(seal) = c.seal.as_mut() {
                    seal[0] ^= 1;
                }
            }),
        ];
        for (field, edit) in edits {
            let mut tampered = honest.clone();
            edit(&mut tampered);
            assert!(
                tampered.verify(&key()).is_err(),
                "editing {field} must fail verification"
            );
        }
    }

    #[test]
    fn reordering_fails_verification() {
        let honest = sealed_chain(b"run-1");
        let mut swapped = honest.clone();
        swapped.receipts.swap(1, 2);
        assert!(swapped.verify(&key()).is_err());

        // Even with sequence numbers rewritten to look in order.
        swapped.receipts[1].sequence = 1;
        swapped.receipts[2].sequence = 2;
        assert_eq!(
            swapped.verify(&key()),
            Err(ReceiptError::BrokenLink { index: 1 })
        );
    }

    #[test]
    fn truncation_fails_verification() {
        let honest = sealed_chain(b"run-1");

        // Drop the last receipt, keep the seal.
        let mut tail_cut = honest.clone();
        tail_cut.receipts.pop();
        assert_eq!(tail_cut.verify(&key()), Err(ReceiptError::BadSeal));

        // Drop the last receipt AND strip the seal.
        tail_cut.seal = None;
        assert_eq!(tail_cut.verify(&key()), Err(ReceiptError::Unsealed));

        // Drop everything.
        let mut emptied = honest.clone();
        emptied.receipts.clear();
        assert_eq!(emptied.verify(&key()), Err(ReceiptError::BadSeal));

        // Drop the first receipt.
        let mut head_cut = honest.clone();
        head_cut.receipts.remove(0);
        assert!(head_cut.verify(&key()).is_err());

        // A live chain anchored externally catches a dropped tail too.
        let anchor = honest.head();
        assert_eq!(
            tail_cut.verify_anchored(&key(), 3, &anchor),
            Err(ReceiptError::AnchorMismatch)
        );
    }

    #[test]
    fn extension_fails_verification() {
        let honest = sealed_chain(b"run-1");
        let mut extended = honest.clone();
        let last = extended.receipts[2].clone();
        extended.receipts.push(EffectReceipt {
            sequence: 3,
            program_hash: 7,
            effect_type: "exfiltrate".into(),
            timestamp: 400,
            prev_tag: last.tag,
            tag: last.tag,
        });
        assert_eq!(
            extended.verify(&key()),
            Err(ReceiptError::BadTag { index: 3 })
        );
    }

    #[test]
    fn wrong_key_fails_verification() {
        let honest = sealed_chain(b"run-1");
        assert_eq!(
            honest.verify(&other_key()),
            Err(ReceiptError::BadTag { index: 0 })
        );

        let mut empty = ReceiptChain::new(b"empty");
        empty.seal(&key()).unwrap();
        assert_eq!(empty.verify(&other_key()), Err(ReceiptError::BadSeal));
    }

    /// Two chains under the SAME key with IDENTICAL contents but different
    /// ids: no receipt, run of receipts or seal moves between them.
    #[test]
    fn splicing_between_chains_fails_verification() {
        let a = sealed_chain(b"run-A");
        let b = sealed_chain(b"run-B");
        assert_eq!(a.verify(&key()), Ok(()));
        assert_eq!(b.verify(&key()), Ok(()));

        // B's middle receipt into A.
        let mut spliced = a.clone();
        spliced.receipts[1] = b.receipts[1].clone();
        assert!(spliced.verify(&key()).is_err());

        // A's prefix followed by B's tail, B's seal.
        let mut joined = a.clone();
        joined.receipts[2] = b.receipts[2].clone();
        joined.seal = b.seal;
        assert!(joined.verify(&key()).is_err());

        // All of B's receipts and seal presented under A's id.
        let relabelled = ReceiptChain::from_parts(
            a.chain_id().to_vec(),
            b.receipts().to_vec(),
            b.seal_tag().copied(),
        );
        assert_eq!(
            relabelled.verify(&key()),
            Err(ReceiptError::BadTag { index: 0 })
        );

        // A's receipts with B's seal.
        let mut reseal = a.clone();
        reseal.seal = b.seal;
        assert_eq!(reseal.verify(&key()), Err(ReceiptError::BadSeal));
    }

    #[test]
    fn length_prefixing_prevents_field_boundary_shifts() {
        // Moving bytes between adjacent variable-length fields (chain id and
        // effect type) must change the MAC input.
        let a = link_message(b"ab", 0, &GENESIS_TAG, 0, 0, "c");
        let b = link_message(b"a", 0, &GENESIS_TAG, 0, 0, "bc");
        assert_ne!(a, b);
        let k = key();
        let mut left = ReceiptChain::new(b"ab");
        left.append(&k, "c", 0).unwrap();
        let mut right = ReceiptChain::new(b"a");
        right.append(&k, "bc", 0).unwrap();
        assert_ne!(left.receipts()[0].tag, right.receipts()[0].tag);
    }
}
