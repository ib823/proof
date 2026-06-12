// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for key lifecycle invariants.

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq, kani::Arbitrary)]
pub enum KeyState {
    Generated,
    Active,
    Rotated,
    Retired,
    Destroyed,
}

pub fn transition_ok(from: KeyState, to: KeyState) -> bool {
    matches!(
        (from, to),
        (KeyState::Generated, KeyState::Active)
            | (KeyState::Active, KeyState::Rotated)
            | (KeyState::Active, KeyState::Retired)
            | (KeyState::Rotated, KeyState::Retired)
            | (KeyState::Retired, KeyState::Destroyed)
    )
}

#[kani::proof]
fn harness_generated_not_destroyed_directly() {
    assert!(!transition_ok(KeyState::Generated, KeyState::Destroyed));
}

#[kani::proof]
fn harness_destroyed_terminal() {
    let to: KeyState = kani::any();
    assert!(!transition_ok(KeyState::Destroyed, to));
}
