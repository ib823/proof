// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Verus obligations for algebraic-effects budget invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

pub struct EffectBudget {
    pub io_tokens: u64,
    pub net_tokens: u64,
    pub crypto_tokens: u64,
}

pub open spec fn effect_budget_valid(b: EffectBudget) -> bool {
    b.io_tokens >= 1 && b.net_tokens >= 1 && b.crypto_tokens >= 1
}

pub open spec fn baseline_effect_budget() -> EffectBudget {
    EffectBudget { io_tokens: 1, net_tokens: 1, crypto_tokens: 1 }
}

pub open spec fn hardened_effect_budget() -> EffectBudget {
    EffectBudget { io_tokens: 2, net_tokens: 2, crypto_tokens: 2 }
}

pub proof fn lemma_baseline_effect_budget_valid()
    ensures effect_budget_valid(baseline_effect_budget())
{
    assert(effect_budget_valid(baseline_effect_budget()));
}

pub proof fn lemma_hardened_effect_budget_not_weaker()
    ensures
        effect_budget_valid(hardened_effect_budget()),
        hardened_effect_budget().io_tokens >= baseline_effect_budget().io_tokens,
        hardened_effect_budget().net_tokens >= baseline_effect_budget().net_tokens,
        hardened_effect_budget().crypto_tokens >= baseline_effect_budget().crypto_tokens,
{
    assert(effect_budget_valid(hardened_effect_budget()));
    assert(hardened_effect_budget().io_tokens >= baseline_effect_budget().io_tokens);
    assert(hardened_effect_budget().net_tokens >= baseline_effect_budget().net_tokens);
    assert(hardened_effect_budget().crypto_tokens >= baseline_effect_budget().crypto_tokens);
}

} // verus!

fn main() {}
