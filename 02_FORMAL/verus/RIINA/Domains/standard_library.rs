// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Standard Library domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Standard Library verification
pub struct StdlibFn {
    pub precondition_documented: bool,
    pub postcondition_verified: bool,
    pub total_or_partial_marked: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn standard_library_secure(s: StdlibFn) -> bool {
    s.precondition_documented && s.postcondition_verified && s.total_or_partial_marked && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_standard_library() -> StdlibFn {
    StdlibFn {
        precondition_documented: true,
        postcondition_verified: true,
        total_or_partial_marked: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_standard_library() -> StdlibFn {
    StdlibFn {
        precondition_documented: true,
        postcondition_verified: true,
        total_or_partial_marked: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures standard_library_secure(baseline_standard_library()),
{
    let b = baseline_standard_library();
    assert(b.precondition_documented);
    assert(b.postcondition_verified);
    assert(b.total_or_partial_marked);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures standard_library_secure(hardened_standard_library()),
{
    let h = hardened_standard_library();
    assert(h.precondition_documented);
    assert(h.postcondition_verified);
    assert(h.total_or_partial_marked);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        standard_library_secure(hardened_standard_library()),
        hardened_standard_library().assurance_level >= baseline_standard_library().assurance_level,
{
    let baseline = baseline_standard_library();
    let hardened = hardened_standard_library();
    assert(standard_library_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !standard_library_secure(StdlibFn { precondition_documented: false, postcondition_verified: true, total_or_partial_marked: true, assurance_level: 1 }),
        !standard_library_secure(StdlibFn { precondition_documented: true, postcondition_verified: false, total_or_partial_marked: true, assurance_level: 1 }),
        !standard_library_secure(StdlibFn { precondition_documented: true, postcondition_verified: true, total_or_partial_marked: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !standard_library_secure(StdlibFn { precondition_documented: true, postcondition_verified: true, total_or_partial_marked: true, assurance_level: 0 }),
{
}

} // verus!
