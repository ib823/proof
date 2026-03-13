// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Csrf Protection domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Csrf Protection verification
pub struct HttpRequest {
    pub token_valid: bool,
    pub origin_checked: bool,
    pub method_safe_or_token_present: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn csrf_protection_secure(s: HttpRequest) -> bool {
    s.token_valid && s.origin_checked && s.method_safe_or_token_present && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_csrf_protection() -> HttpRequest {
    HttpRequest {
        token_valid: true,
        origin_checked: true,
        method_safe_or_token_present: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_csrf_protection() -> HttpRequest {
    HttpRequest {
        token_valid: true,
        origin_checked: true,
        method_safe_or_token_present: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures csrf_protection_secure(baseline_csrf_protection()),
{
    let b = baseline_csrf_protection();
    assert(b.token_valid);
    assert(b.origin_checked);
    assert(b.method_safe_or_token_present);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures csrf_protection_secure(hardened_csrf_protection()),
{
    let h = hardened_csrf_protection();
    assert(h.token_valid);
    assert(h.origin_checked);
    assert(h.method_safe_or_token_present);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        csrf_protection_secure(hardened_csrf_protection()),
        hardened_csrf_protection().assurance_level >= baseline_csrf_protection().assurance_level,
{
    let baseline = baseline_csrf_protection();
    let hardened = hardened_csrf_protection();
    assert(csrf_protection_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !csrf_protection_secure(HttpRequest { token_valid: false, origin_checked: true, method_safe_or_token_present: true, assurance_level: 1 }),
        !csrf_protection_secure(HttpRequest { token_valid: true, origin_checked: false, method_safe_or_token_present: true, assurance_level: 1 }),
        !csrf_protection_secure(HttpRequest { token_valid: true, origin_checked: true, method_safe_or_token_present: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !csrf_protection_secure(HttpRequest { token_valid: true, origin_checked: true, method_safe_or_token_present: true, assurance_level: 0 }),
{
}

} // verus!
