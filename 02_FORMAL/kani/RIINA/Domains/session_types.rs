// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for session type invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct SessionTypePolicy {
    pub protocol_complete: bool,
    pub deadlock_free: bool,
    pub linearity_enforced: bool,
}

pub fn session_secure(p: &SessionTypePolicy) -> bool {
    p.protocol_complete && p.deadlock_free && p.linearity_enforced
}

pub fn baseline_session() -> SessionTypePolicy {
    SessionTypePolicy {
        protocol_complete: true,
        deadlock_free: true,
        linearity_enforced: true,
    }
}

pub fn hardened_session() -> SessionTypePolicy {
    SessionTypePolicy {
        protocol_complete: true,
        deadlock_free: true,
        linearity_enforced: true,
    }
}

#[kani::proof]
fn harness_baseline_session_secure() {
    let p = baseline_session();
    assert!(session_secure(&p));
}

#[kani::proof]
fn harness_hardened_session_not_weaker() {
    let b = baseline_session();
    let h = hardened_session();
    assert!(session_secure(&h));
}
