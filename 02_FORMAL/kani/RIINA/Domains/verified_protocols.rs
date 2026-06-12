// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for protocol-state transitions.

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq, kani::Arbitrary)]
pub enum ProtocolState {
    Init,
    Authenticated,
    Closed,
}

pub fn step_ok(s1: ProtocolState, s2: ProtocolState) -> bool {
    matches!(
        (s1, s2),
        (ProtocolState::Init, ProtocolState::Init)
            | (ProtocolState::Init, ProtocolState::Authenticated)
            | (ProtocolState::Authenticated, ProtocolState::Authenticated)
            | (ProtocolState::Authenticated, ProtocolState::Closed)
            | (ProtocolState::Closed, ProtocolState::Closed)
    )
}

#[kani::proof]
fn harness_no_init_to_closed() {
    assert!(!step_ok(ProtocolState::Init, ProtocolState::Closed));
}

#[kani::proof]
fn harness_close_requires_non_init() {
    let from = kani::any::<ProtocolState>();
    kani::assume(step_ok(from, ProtocolState::Closed));
    assert!(from == ProtocolState::Authenticated || from == ProtocolState::Closed);
}
