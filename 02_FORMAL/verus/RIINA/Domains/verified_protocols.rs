// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Verus obligations for protocol-state transitions.

#![allow(unused)]
use vstd::prelude::*;

verus! {

pub enum ProtocolState {
    Init,
    Authenticated,
    Closed,
}

pub open spec fn step_ok(s1: ProtocolState, s2: ProtocolState) -> bool {
    match (s1, s2) {
        (ProtocolState::Init, ProtocolState::Init) => true,
        (ProtocolState::Init, ProtocolState::Authenticated) => true,
        (ProtocolState::Authenticated, ProtocolState::Authenticated) => true,
        (ProtocolState::Authenticated, ProtocolState::Closed) => true,
        (ProtocolState::Closed, ProtocolState::Closed) => true,
        _ => false,
    }
}

pub proof fn lemma_no_init_to_closed() {
    assert(!step_ok(ProtocolState::Init, ProtocolState::Closed));
}

pub proof fn lemma_close_requires_non_init(s: ProtocolState)
    requires
        step_ok(s, ProtocolState::Closed),
    ensures
        s == ProtocolState::Authenticated || s == ProtocolState::Closed,
{
    match s {
        ProtocolState::Init => {
            assert(!step_ok(ProtocolState::Init, ProtocolState::Closed));
            assert(false);
        }
        ProtocolState::Authenticated => {}
        ProtocolState::Closed => {}
    }
}

} // verus!

fn main() {}
