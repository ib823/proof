// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Execution receipts for effectful RIINA runtime operations.

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EffectReceipt {
    pub receipt_id: u64,
    pub program_hash: u64,
    pub effect_type: String,
    pub prev_receipt: u64,
    pub timestamp: u64,
}

#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct ReceiptChain {
    receipts: Vec<EffectReceipt>,
}

fn fnv1a_hash_bytes(bytes: &[u8]) -> u64 {
    const FNV_OFFSET_BASIS: u64 = 14_695_981_039_346_656_037;
    const FNV_PRIME: u64 = 1_099_511_628_211;

    let mut hash = FNV_OFFSET_BASIS;
    for &byte in bytes {
        hash ^= u64::from(byte);
        hash = hash.wrapping_mul(FNV_PRIME);
    }
    hash
}

fn receipt_hash(prev_receipt: u64, effect: &str, program_hash: u64) -> u64 {
    let mut bytes = Vec::with_capacity((2 * std::mem::size_of::<u64>()) + effect.len());
    bytes.extend_from_slice(&prev_receipt.to_be_bytes());
    bytes.extend_from_slice(effect.as_bytes());
    bytes.extend_from_slice(&program_hash.to_be_bytes());
    fnv1a_hash_bytes(&bytes)
}

impl ReceiptChain {
    #[must_use]
    pub fn new() -> Self {
        Self {
            receipts: Vec::new(),
        }
    }

    pub fn append(&mut self, effect: &str, program_hash: u64) -> &EffectReceipt {
        let prev_receipt = self
            .receipts
            .last()
            .map(|receipt| receipt.receipt_id)
            .unwrap_or(0);
        let receipt_id = receipt_hash(prev_receipt, effect, program_hash);
        self.receipts.push(EffectReceipt {
            receipt_id,
            program_hash,
            effect_type: effect.to_string(),
            prev_receipt,
            timestamp: 0,
        });
        self.receipts
            .last()
            .expect("receipt chain must contain the appended receipt")
    }

    #[must_use]
    pub fn verify(&self) -> bool {
        let mut expected_prev = 0;
        for receipt in &self.receipts {
            if receipt.prev_receipt != expected_prev {
                return false;
            }

            let expected_id = receipt_hash(
                receipt.prev_receipt,
                &receipt.effect_type,
                receipt.program_hash,
            );
            if receipt.receipt_id != expected_id {
                return false;
            }

            expected_prev = receipt.receipt_id;
        }
        true
    }

    #[must_use]
    pub fn len(&self) -> usize {
        self.receipts.len()
    }

    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.receipts.is_empty()
    }

    #[must_use]
    pub fn root(&self) -> u64 {
        self.receipts
            .last()
            .map(|receipt| receipt.receipt_id)
            .unwrap_or(0)
    }
}

#[cfg(test)]
mod tests {
    use super::{receipt_hash, ReceiptChain};

    #[test]
    fn empty_chain_verifies() {
        let chain = ReceiptChain::new();
        assert!(chain.verify());
    }

    #[test]
    fn empty_chain_reports_zero_root() {
        let chain = ReceiptChain::new();
        assert_eq!(chain.root(), 0);
    }

    #[test]
    fn single_receipt_chain_verifies() {
        let mut chain = ReceiptChain::new();
        chain.append("network_send", 7);
        assert!(chain.verify());
    }

    #[test]
    fn single_receipt_starts_with_zero_prev_receipt() {
        let mut chain = ReceiptChain::new();
        let receipt = chain.append("network_send", 7);
        assert_eq!(receipt.prev_receipt, 0);
    }

    #[test]
    fn append_increases_len() {
        let mut chain = ReceiptChain::new();
        chain.append("network_send", 7);
        chain.append("crypto_hash", 7);
        assert_eq!(chain.len(), 2);
    }

    #[test]
    fn multi_receipt_chain_verifies() {
        let mut chain = ReceiptChain::new();
        chain.append("network_send", 7);
        chain.append("crypto_hash", 7);
        chain.append("fs_write", 7);
        assert!(chain.verify());
    }

    #[test]
    fn root_hash_changes_with_each_append() {
        let mut chain = ReceiptChain::new();
        let first_root = chain.append("network_send", 7).receipt_id;
        let second_root = chain.append("crypto_hash", 7).receipt_id;
        assert_ne!(first_root, second_root);
        assert_eq!(chain.root(), second_root);
    }

    #[test]
    fn receipt_ids_are_deterministic() {
        let mut left = ReceiptChain::new();
        let mut right = ReceiptChain::new();
        left.append("network_send", 7);
        left.append("crypto_hash", 11);
        right.append("network_send", 7);
        right.append("crypto_hash", 11);
        assert_eq!(left.root(), right.root());
        assert!(left.verify());
        assert!(right.verify());
    }

    #[test]
    fn tampered_prev_receipt_fails_verification() {
        let mut chain = ReceiptChain::new();
        chain.append("network_send", 7);
        chain.append("crypto_hash", 11);
        chain.receipts[1].prev_receipt = 99;
        assert!(!chain.verify());
    }

    #[test]
    fn tampered_effect_type_fails_verification() {
        let mut chain = ReceiptChain::new();
        chain.append("network_send", 7);
        chain.receipts[0].effect_type = "fs_write".to_string();
        assert!(!chain.verify());
    }

    #[test]
    fn tampered_program_hash_fails_verification() {
        let mut chain = ReceiptChain::new();
        chain.append("network_send", 7);
        chain.receipts[0].program_hash = 9;
        assert!(!chain.verify());
    }

    #[test]
    fn tampered_receipt_id_fails_verification() {
        let mut chain = ReceiptChain::new();
        chain.append("network_send", 7);
        chain.receipts[0].receipt_id ^= 1;
        assert!(!chain.verify());
    }

    #[test]
    fn receipt_hash_matches_append_output() {
        let mut chain = ReceiptChain::new();
        let receipt = chain.append("network_send", 7);
        assert_eq!(receipt.receipt_id, receipt_hash(0, "network_send", 7));
    }
}
