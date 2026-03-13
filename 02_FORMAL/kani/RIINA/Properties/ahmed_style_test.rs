// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for AhmedStyleTest.v
// Source: 02_FORMAL/coq/properties/AhmedStyleTest.v
//
// Ahmed-style step-indexed logical relation test.

#![allow(unused)]

/// Step index for logical relation (bounded).
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
struct StepIndex(u8);

impl StepIndex {
    fn zero() -> Self { Self(0) }
    fn succ(self) -> Self { Self(self.0.saturating_add(1)) }
    fn pred(self) -> Option<Self> {
        if self.0 > 0 { Some(Self(self.0 - 1)) } else { None }
    }
    fn leq(self, other: Self) -> bool { self.0 <= other.0 }
}

/// Value relation: v1 and v2 are related at step index k.
fn val_rel(k: StepIndex, v1: u8, v2: u8) -> bool {
    // At step 0, all values are related (vacuously)
    if k.0 == 0 { return true; }
    // Otherwise, same-shaped values are related
    v1 == v2
}

/// Anti-monotonicity: if related at k, related at j <= k.
fn val_rel_anti_mono(k: StepIndex, j: StepIndex, v1: u8, v2: u8) -> bool {
    if j.leq(k) && val_rel(k, v1, v2) {
        val_rel(j, v1, v2)
    } else {
        true
    }
}

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_index() -> StepIndex {
        let v: u8 = kani::any();
        kani::assume(v <= 10);
        StepIndex(v)
    }

    #[kani::proof]
    fn verify_val_rel_zero() {
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 8 && v2 < 8);
        assert!(val_rel(StepIndex::zero(), v1, v2));
    }

    #[kani::proof]
    fn verify_val_rel_refl() {
        let k = any_index();
        let v: u8 = kani::any();
        kani::assume(v < 8);
        assert!(val_rel(k, v, v));
    }

    #[kani::proof]
    fn verify_val_rel_anti_monotone() {
        let k = any_index();
        let j = any_index();
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 8 && v2 < 8);
        assert!(val_rel_anti_mono(k, j, v1, v2));
    }

    #[kani::proof]
    fn verify_step_index_pred_succ() {
        let k = any_index();
        kani::assume(k.0 < 255);
        let s = k.succ();
        assert_eq!(s.pred(), Some(k));
    }
}
