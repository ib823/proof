// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Verus obligations for constant-time discipline.

#![allow(unused)]
use vstd::prelude::*;

verus! {

pub struct CtTrace {
    pub branch_on_secret: bool,
    pub addr_on_secret: bool,
    pub cycle_upper_bound: u64,
}

pub open spec fn valid_ct_trace(t: CtTrace) -> bool {
    !t.branch_on_secret && !t.addr_on_secret && t.cycle_upper_bound > 0
}

pub open spec fn merge_trace(a: CtTrace, b: CtTrace) -> CtTrace {
    CtTrace {
        branch_on_secret: a.branch_on_secret || b.branch_on_secret,
        addr_on_secret: a.addr_on_secret || b.addr_on_secret,
        cycle_upper_bound: if a.cycle_upper_bound >= b.cycle_upper_bound { a.cycle_upper_bound } else { b.cycle_upper_bound },
    }
}

pub proof fn lemma_merge_preserves_ct(a: CtTrace, b: CtTrace)
    requires
        valid_ct_trace(a),
        valid_ct_trace(b),
    ensures
        valid_ct_trace(merge_trace(a, b)),
{
    assert(!a.branch_on_secret);
    assert(!b.branch_on_secret);
    assert(!a.addr_on_secret);
    assert(!b.addr_on_secret);
    assert(a.cycle_upper_bound > 0);
    assert(b.cycle_upper_bound > 0);
}

} // verus!

fn main() {}
