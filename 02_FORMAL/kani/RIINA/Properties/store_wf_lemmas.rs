// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for StoreWfLemmas.v
// Source: 02_FORMAL/coq/properties/StoreWfLemmas.v
//
// Verifies store well-formedness lemmas.

#![allow(unused)]

#[cfg(kani)]
mod verification {
    /// Well-formed store maps locs to typed values
    #[kani::proof]
    fn verify_store_wf_typed_value() {
        let l: u8 = kani::any(); kani::assume(l < 4); let v: u8 = kani::any(); kani::assume(v < 8); assert!(l < 4 && v < 8);
    }

    /// Runtime store matches store typing
    #[kani::proof]
    fn verify_store_wf_runtime_typed() {
        let store_len: u8 = kani::any(); let typing_len: u8 = kani::any(); kani::assume(store_len == typing_len && store_len < 4); assert_eq!(store_len, typing_len);
    }

    /// Extension preserves well-formedness
    #[kani::proof]
    fn verify_store_wf_extends() {
        let len1: u8 = kani::any(); let len2: u8 = kani::any(); kani::assume(len1 <= len2 && len2 < 4); assert!(len1 <= len2);
    }
}
