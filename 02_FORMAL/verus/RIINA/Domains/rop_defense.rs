// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Rop Defense domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Rop Defense verification
pub struct StackFrame {
    pub return_address_valid: bool,
    pub canary_intact: bool,
    pub no_gadget_chain: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn rop_defense_secure(s: StackFrame) -> bool {
    s.return_address_valid && s.canary_intact && s.no_gadget_chain && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_rop_defense() -> StackFrame {
    StackFrame {
        return_address_valid: true,
        canary_intact: true,
        no_gadget_chain: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_rop_defense() -> StackFrame {
    StackFrame {
        return_address_valid: true,
        canary_intact: true,
        no_gadget_chain: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures rop_defense_secure(baseline_rop_defense()),
{
    let b = baseline_rop_defense();
    assert(b.return_address_valid);
    assert(b.canary_intact);
    assert(b.no_gadget_chain);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures rop_defense_secure(hardened_rop_defense()),
{
    let h = hardened_rop_defense();
    assert(h.return_address_valid);
    assert(h.canary_intact);
    assert(h.no_gadget_chain);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        rop_defense_secure(hardened_rop_defense()),
        hardened_rop_defense().assurance_level >= baseline_rop_defense().assurance_level,
{
    let baseline = baseline_rop_defense();
    let hardened = hardened_rop_defense();
    assert(rop_defense_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !rop_defense_secure(StackFrame { return_address_valid: false, canary_intact: true, no_gadget_chain: true, assurance_level: 1 }),
        !rop_defense_secure(StackFrame { return_address_valid: true, canary_intact: false, no_gadget_chain: true, assurance_level: 1 }),
        !rop_defense_secure(StackFrame { return_address_valid: true, canary_intact: true, no_gadget_chain: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !rop_defense_secure(StackFrame { return_address_valid: true, canary_intact: true, no_gadget_chain: true, assurance_level: 0 }),
{
}

} // verus!
