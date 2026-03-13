// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Anti Jamming domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Anti Jamming verification
pub struct WirelessLink {
    pub frequency_hopping: bool,
    pub spread_spectrum: bool,
    pub error_corrected: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn anti_jamming_secure(s: WirelessLink) -> bool {
    s.frequency_hopping && s.spread_spectrum && s.error_corrected && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_anti_jamming() -> WirelessLink {
    WirelessLink {
        frequency_hopping: true,
        spread_spectrum: true,
        error_corrected: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_anti_jamming() -> WirelessLink {
    WirelessLink {
        frequency_hopping: true,
        spread_spectrum: true,
        error_corrected: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures anti_jamming_secure(baseline_anti_jamming()),
{
    let b = baseline_anti_jamming();
    assert(b.frequency_hopping);
    assert(b.spread_spectrum);
    assert(b.error_corrected);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures anti_jamming_secure(hardened_anti_jamming()),
{
    let h = hardened_anti_jamming();
    assert(h.frequency_hopping);
    assert(h.spread_spectrum);
    assert(h.error_corrected);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        anti_jamming_secure(hardened_anti_jamming()),
        hardened_anti_jamming().assurance_level >= baseline_anti_jamming().assurance_level,
{
    let baseline = baseline_anti_jamming();
    let hardened = hardened_anti_jamming();
    assert(anti_jamming_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !anti_jamming_secure(WirelessLink { frequency_hopping: false, spread_spectrum: true, error_corrected: true, assurance_level: 1 }),
        !anti_jamming_secure(WirelessLink { frequency_hopping: true, spread_spectrum: false, error_corrected: true, assurance_level: 1 }),
        !anti_jamming_secure(WirelessLink { frequency_hopping: true, spread_spectrum: true, error_corrected: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !anti_jamming_secure(WirelessLink { frequency_hopping: true, spread_spectrum: true, error_corrected: true, assurance_level: 0 }),
{
}

} // verus!
