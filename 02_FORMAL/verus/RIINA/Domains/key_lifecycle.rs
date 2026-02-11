// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Verus obligations for key lifecycle invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

pub enum KeyState {
    Generated,
    Active,
    Rotated,
    Retired,
    Destroyed,
}

pub open spec fn transition_ok(from: KeyState, to: KeyState) -> bool {
    match (from, to) {
        (KeyState::Generated, KeyState::Active) => true,
        (KeyState::Active, KeyState::Rotated) => true,
        (KeyState::Active, KeyState::Retired) => true,
        (KeyState::Rotated, KeyState::Retired) => true,
        (KeyState::Retired, KeyState::Destroyed) => true,
        _ => false,
    }
}

pub proof fn lemma_generated_not_destroyed_directly()
    ensures !transition_ok(KeyState::Generated, KeyState::Destroyed)
{}

pub proof fn lemma_destroyed_terminal(to: KeyState)
    ensures !transition_ok(KeyState::Destroyed, to)
{}

} // verus!

fn main() {}
