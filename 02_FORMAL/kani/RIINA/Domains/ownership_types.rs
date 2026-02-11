// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for ownership-transition invariants.

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq, kani::Arbitrary)]
pub enum OwnerState {
    Owned,
    Moved,
    Dropped,
}

pub fn transition_ok(from: OwnerState, to: OwnerState) -> bool {
    matches!(
        (from, to),
        (OwnerState::Owned, OwnerState::Moved)
            | (OwnerState::Owned, OwnerState::Dropped)
            | (OwnerState::Moved, OwnerState::Dropped)
    )
}

#[kani::proof]
fn harness_no_move_after_move() {
    assert!(!transition_ok(OwnerState::Moved, OwnerState::Moved));
}

#[kani::proof]
fn harness_dropped_terminal() {
    let to: OwnerState = kani::any();
    assert!(!transition_ok(OwnerState::Dropped, to));
}
