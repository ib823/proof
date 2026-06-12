// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Active (non-generated) D10 executable lane for bounded model checking.
//
// Mirrors the `riinac verify` flag-to-mode contract from:
// - 03_PROTO/crates/riinac/src/main.rs
// - 03_PROTO/crates/riinac/src/verify.rs

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum VerifyMode {
    Fast,
    Full,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum VerifyFlag {
    FastFlag,
    FullFlag,
    Unknown,
}

fn parse_verify_mode(flag: VerifyFlag) -> Option<VerifyMode> {
    match flag {
        VerifyFlag::FastFlag => Some(VerifyMode::Fast),
        VerifyFlag::FullFlag => Some(VerifyMode::Full),
        VerifyFlag::Unknown => None,
    }
}

#[kani::proof]
fn proof_fast_maps_to_fast() {
    assert_eq!(parse_verify_mode(VerifyFlag::FastFlag), Some(VerifyMode::Fast));
}

#[kani::proof]
fn proof_full_maps_to_full() {
    assert_eq!(parse_verify_mode(VerifyFlag::FullFlag), Some(VerifyMode::Full));
}

#[kani::proof]
fn proof_unknown_rejects() {
    assert_eq!(parse_verify_mode(VerifyFlag::Unknown), None);
}

#[kani::proof]
fn proof_partition_holds_for_any_encoded_flag() {
    let encoded: u8 = kani::any();
    let flag = match encoded % 3 {
        0 => VerifyFlag::FastFlag,
        1 => VerifyFlag::FullFlag,
        _ => VerifyFlag::Unknown,
    };

    match flag {
        VerifyFlag::FastFlag => assert_eq!(parse_verify_mode(flag), Some(VerifyMode::Fast)),
        VerifyFlag::FullFlag => assert_eq!(parse_verify_mode(flag), Some(VerifyMode::Full)),
        VerifyFlag::Unknown => assert_eq!(parse_verify_mode(flag), None),
    }
}
