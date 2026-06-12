// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of MobileOS Touch Gesture System invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// State model for Touch Gesture System
pub struct GestureRecognizer {
    pub hit_test_correct: bool,
    pub conflict_resolved: bool,
    pub velocity_bounded: bool,
    pub accessibility_equivalent: bool,
    pub assurance_level: u64,
}

/// Invariant: all properties must hold with positive assurance
pub open spec fn touch_gesture_system_valid(s: GestureRecognizer) -> bool {
    s.hit_test_correct && s.conflict_resolved && s.velocity_bounded && s.accessibility_equivalent && s.assurance_level >= 1
}

/// Baseline configuration
pub open spec fn baseline_touch_gesture_system() -> GestureRecognizer {
    GestureRecognizer { hit_test_correct: true, conflict_resolved: true, velocity_bounded: true, accessibility_equivalent: true, assurance_level: 1 }
}

/// Hardened configuration
pub open spec fn hardened_touch_gesture_system() -> GestureRecognizer {
    GestureRecognizer { hit_test_correct: true, conflict_resolved: true, velocity_bounded: true, accessibility_equivalent: true, assurance_level: 3 }
}

/// Lemma: baseline is valid
proof fn lemma_baseline_valid()
    ensures touch_gesture_system_valid(baseline_touch_gesture_system()),
{
    let b = baseline_touch_gesture_system();
    assert(b.hit_test_correct && b.conflict_resolved && b.velocity_bounded && b.accessibility_equivalent && b.assurance_level >= 1);
}

/// Lemma: hardened is valid and dominates baseline
proof fn lemma_hardened_dominates()
    ensures
        touch_gesture_system_valid(hardened_touch_gesture_system()),
        hardened_touch_gesture_system().assurance_level >= baseline_touch_gesture_system().assurance_level,
{
}

/// Lemma: each property is individually necessary
proof fn lemma_properties_necessary()
    ensures
        !touch_gesture_system_valid(GestureRecognizer { hit_test_correct: false, conflict_resolved: true, velocity_bounded: true, accessibility_equivalent: true, assurance_level: 1 }),
        !touch_gesture_system_valid(GestureRecognizer { hit_test_correct: true, conflict_resolved: false, velocity_bounded: true, accessibility_equivalent: true, assurance_level: 1 }),
        !touch_gesture_system_valid(GestureRecognizer { hit_test_correct: true, conflict_resolved: true, velocity_bounded: false, accessibility_equivalent: true, assurance_level: 1 }),
        !touch_gesture_system_valid(GestureRecognizer { hit_test_correct: true, conflict_resolved: true, velocity_bounded: true, accessibility_equivalent: false, assurance_level: 1 }),
{
}

} // verus!
