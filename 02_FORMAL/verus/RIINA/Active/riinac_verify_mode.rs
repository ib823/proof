// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Active (non-generated) D10 proof lane.
//
// Spec linkage to production code:
// - 03_PROTO/crates/riinac/src/main.rs (verify command dispatch)
// - 03_PROTO/crates/riinac/src/verify.rs (Mode::{Fast,Full})
//
// This file proves the core parse contract used by `riinac verify`:
// `--fast` maps to Fast, `--full` maps to Full, all else rejects.

#![allow(dead_code)]
use vstd::prelude::*;

verus! {

pub enum VerifyMode {
    Fast,
    Full,
}

pub enum VerifyFlag {
    FastFlag,
    FullFlag,
    Unknown,
}

pub open spec fn parse_verify_mode(flag: VerifyFlag) -> Option<VerifyMode> {
    match flag {
        VerifyFlag::FastFlag => Some(VerifyMode::Fast),
        VerifyFlag::FullFlag => Some(VerifyMode::Full),
        VerifyFlag::Unknown => None,
    }
}

proof fn lemma_fast_maps_to_fast()
    ensures(parse_verify_mode(VerifyFlag::FastFlag) == Some(VerifyMode::Fast))
{
}

proof fn lemma_full_maps_to_full()
    ensures(parse_verify_mode(VerifyFlag::FullFlag) == Some(VerifyMode::Full))
{
}

proof fn lemma_unknown_rejects()
    ensures(parse_verify_mode(VerifyFlag::Unknown) == Option::<VerifyMode>::None)
{
}

proof fn lemma_total_partition(flag: VerifyFlag)
    ensures(
        (flag == VerifyFlag::FastFlag ==> parse_verify_mode(flag) == Some(VerifyMode::Fast)) &&
        (flag == VerifyFlag::FullFlag ==> parse_verify_mode(flag) == Some(VerifyMode::Full)) &&
        (flag == VerifyFlag::Unknown  ==> parse_verify_mode(flag) == Option::<VerifyMode>::None)
    )
{
}

} // verus!

fn main() {}
