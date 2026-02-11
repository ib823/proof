// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Verus obligations for binary-size budget bounds.

#![allow(unused)]
use vstd::prelude::*;

verus! {

pub struct SizeBudget {
    pub code_bytes: u64,
    pub metadata_bytes: u64,
    pub max_total_bytes: u64,
}

pub open spec fn total_bytes(b: SizeBudget) -> int {
    b.code_bytes as int + b.metadata_bytes as int
}

pub open spec fn within_budget(b: SizeBudget) -> bool {
    b.max_total_bytes > 0 && total_bytes(b) <= b.max_total_bytes as int
}

pub open spec fn baseline_size_budget() -> SizeBudget {
    SizeBudget { code_bytes: 200000, metadata_bytes: 10000, max_total_bytes: 250000 }
}

pub proof fn lemma_baseline_within_budget()
    ensures within_budget(baseline_size_budget())
{
    assert(within_budget(baseline_size_budget()));
}

} // verus!

fn main() {}
