// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Verus obligations for ownership-transition invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

pub enum OwnerState {
    Owned,
    Moved,
    Dropped,
}

pub open spec fn transition_ok(from: OwnerState, to: OwnerState) -> bool {
    match (from, to) {
        (OwnerState::Owned, OwnerState::Moved) => true,
        (OwnerState::Owned, OwnerState::Dropped) => true,
        (OwnerState::Moved, OwnerState::Dropped) => true,
        _ => false,
    }
}

pub proof fn lemma_no_move_after_move()
    ensures !transition_ok(OwnerState::Moved, OwnerState::Moved)
{}

pub proof fn lemma_dropped_terminal(to: OwnerState)
    ensures !transition_ok(OwnerState::Dropped, to)
{}

} // verus!

fn main() {}
