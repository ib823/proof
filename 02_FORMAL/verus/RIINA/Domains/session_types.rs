// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Session Types domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Session Types verification
pub struct SessionType {
    pub dual_consistent: bool,
    pub progress_guaranteed: bool,
    pub deadlock_free: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn session_types_secure(s: SessionType) -> bool {
    s.dual_consistent && s.progress_guaranteed && s.deadlock_free && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_session_types() -> SessionType {
    SessionType {
        dual_consistent: true,
        progress_guaranteed: true,
        deadlock_free: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_session_types() -> SessionType {
    SessionType {
        dual_consistent: true,
        progress_guaranteed: true,
        deadlock_free: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures session_types_secure(baseline_session_types()),
{
    let b = baseline_session_types();
    assert(b.dual_consistent);
    assert(b.progress_guaranteed);
    assert(b.deadlock_free);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures session_types_secure(hardened_session_types()),
{
    let h = hardened_session_types();
    assert(h.dual_consistent);
    assert(h.progress_guaranteed);
    assert(h.deadlock_free);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        session_types_secure(hardened_session_types()),
        hardened_session_types().assurance_level >= baseline_session_types().assurance_level,
{
    let baseline = baseline_session_types();
    let hardened = hardened_session_types();
    assert(session_types_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !session_types_secure(SessionType { dual_consistent: false, progress_guaranteed: true, deadlock_free: true, assurance_level: 1 }),
        !session_types_secure(SessionType { dual_consistent: true, progress_guaranteed: false, deadlock_free: true, assurance_level: 1 }),
        !session_types_secure(SessionType { dual_consistent: true, progress_guaranteed: true, deadlock_free: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !session_types_secure(SessionType { dual_consistent: true, progress_guaranteed: true, deadlock_free: true, assurance_level: 0 }),
{
}

} // verus!
