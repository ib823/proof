// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for algebraic-effects budget invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct EffectBudget {
    pub io_tokens: u64,
    pub net_tokens: u64,
    pub crypto_tokens: u64,
}

pub fn effect_budget_valid(b: &EffectBudget) -> bool {
    b.io_tokens >= 1 && b.net_tokens >= 1 && b.crypto_tokens >= 1
}

pub fn baseline_effect_budget() -> EffectBudget {
    EffectBudget { io_tokens: 1, net_tokens: 1, crypto_tokens: 1 }
}

pub fn hardened_effect_budget() -> EffectBudget {
    EffectBudget { io_tokens: 2, net_tokens: 2, crypto_tokens: 2 }
}

#[kani::proof]
fn harness_baseline_effect_budget_valid() {
    let b = baseline_effect_budget();
    assert!(effect_budget_valid(&b));
}

#[kani::proof]
fn harness_hardened_effect_budget_not_weaker() {
    let b = baseline_effect_budget();
    let h = hardened_effect_budget();
    assert!(effect_budget_valid(&h));
    assert!(h.io_tokens >= b.io_tokens);
    assert!(h.net_tokens >= b.net_tokens);
    assert!(h.crypto_tokens >= b.crypto_tokens);
}
