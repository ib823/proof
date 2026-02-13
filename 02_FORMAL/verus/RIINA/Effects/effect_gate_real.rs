// Copyright (c) 2026 The RIINA Authors. All rights reserved.
//
// RIINA Effect Gate Proofs - REAL Verus Proofs (Worker D Phase 5)
//
// Formal verification of the Effect Gate mechanism:
// "Tak Ada Bukti, Tak Jadi Kesan" (No Proof, No Effect)
//
// Proves:
// - performs_within monotonicity (structural induction on expressions)
// - Pure effect minimality (pure satisfies any bound)
// - Grant non-escalation (EGrant does not add effects)
// - Handle decomposition (body + handler bounds)
// - Perform requires license (non-pure blocked in pure context)
// - Gate weakening
//
// Based on: EffectGate.v (20 Qed)

#![allow(unused)]
use vstd::prelude::*;

verus! {

// ═══════════════════════════════════════════════════════════════════════════
// SPEC TYPES
// ═══════════════════════════════════════════════════════════════════════════

#[derive(PartialEq, Eq)]
pub enum Effect {
    EffPure,    // level 0
    EffRead,    // level 1
    EffWrite,   // level 2
    EffIO,      // level 3
    EffFull,    // level 4
}

pub enum SpecExpr {
    EUnit, EBool(bool), EInt(int), EVar(Seq<char>),
    ELam(Seq<char>, Box<SpecExpr>),
    EApp(Box<SpecExpr>, Box<SpecExpr>),
    EPair(Box<SpecExpr>, Box<SpecExpr>),
    EFst(Box<SpecExpr>), ESnd(Box<SpecExpr>),
    EInl(Box<SpecExpr>), EInr(Box<SpecExpr>),
    EIf(Box<SpecExpr>, Box<SpecExpr>, Box<SpecExpr>),
    ELet(Seq<char>, Box<SpecExpr>, Box<SpecExpr>),
    EPerform(Effect, Box<SpecExpr>),
    EHandle(Box<SpecExpr>, Seq<char>, Box<SpecExpr>),
    EGrant(Effect, Box<SpecExpr>),
    ERequire(Effect, Box<SpecExpr>),
    ERef(Box<SpecExpr>), EDeref(Box<SpecExpr>),
    EAssign(Box<SpecExpr>, Box<SpecExpr>),
}

// ═══════════════════════════════════════════════════════════════════════════
// SPEC FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════

pub open spec fn effect_level(e: Effect) -> nat {
    match e {
        Effect::EffPure => 0,
        Effect::EffRead => 1,
        Effect::EffWrite => 2,
        Effect::EffIO => 3,
        Effect::EffFull => 4,
    }
}

pub open spec fn effect_leq(e1: Effect, e2: Effect) -> bool {
    effect_level(e1) <= effect_level(e2)
}

/// performs_within: Does expression e only perform effects within bound eff?
pub open spec fn performs_within(e: SpecExpr, eff: Effect) -> bool
    decreases e,
{
    match e {
        SpecExpr::EUnit | SpecExpr::EBool(_) | SpecExpr::EInt(_) | SpecExpr::EVar(_) => true,
        SpecExpr::ELam(_, _) => true, // lambda body not evaluated at creation
        SpecExpr::EApp(e1, e2) => performs_within(*e1, eff) && performs_within(*e2, eff),
        SpecExpr::EPair(e1, e2) => performs_within(*e1, eff) && performs_within(*e2, eff),
        SpecExpr::EFst(e1) | SpecExpr::ESnd(e1) => performs_within(*e1, eff),
        SpecExpr::EInl(e1) | SpecExpr::EInr(e1) => performs_within(*e1, eff),
        SpecExpr::EIf(e1, e2, e3) =>
            performs_within(*e1, eff) && performs_within(*e2, eff) && performs_within(*e3, eff),
        SpecExpr::ELet(_, e1, e2) => performs_within(*e1, eff) && performs_within(*e2, eff),
        SpecExpr::EPerform(eff_prime, e1) =>
            effect_leq(eff_prime, eff) && performs_within(*e1, eff),
        SpecExpr::EHandle(e1, _, h) => performs_within(*e1, eff) && performs_within(*h, eff),
        SpecExpr::EGrant(_, e1) => performs_within(*e1, eff),
        SpecExpr::ERequire(_, e1) => performs_within(*e1, eff),
        SpecExpr::ERef(e1) | SpecExpr::EDeref(e1) => performs_within(*e1, eff),
        SpecExpr::EAssign(e1, e2) => performs_within(*e1, eff) && performs_within(*e2, eff),
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 1: performs_within Monotonicity
// ═══════════════════════════════════════════════════════════════════════════

/// performs_within is monotone in the effect bound
/// Mirrors performs_within_mono from EffectSystem.v
pub proof fn performs_within_mono(e: SpecExpr, eff1: Effect, eff2: Effect)
    requires effect_leq(eff1, eff2), performs_within(e, eff1),
    ensures performs_within(e, eff2),
    decreases e,
{
    match e {
        SpecExpr::EUnit | SpecExpr::EBool(_) | SpecExpr::EInt(_) | SpecExpr::EVar(_) => {},
        SpecExpr::ELam(_, _) => {},
        SpecExpr::EApp(e1, e2) => {
            performs_within_mono(*e1, eff1, eff2);
            performs_within_mono(*e2, eff1, eff2);
        },
        SpecExpr::EPair(e1, e2) => {
            performs_within_mono(*e1, eff1, eff2);
            performs_within_mono(*e2, eff1, eff2);
        },
        SpecExpr::EFst(e1) | SpecExpr::ESnd(e1) => {
            performs_within_mono(*e1, eff1, eff2);
        },
        SpecExpr::EInl(e1) | SpecExpr::EInr(e1) => {
            performs_within_mono(*e1, eff1, eff2);
        },
        SpecExpr::EIf(e1, e2, e3) => {
            performs_within_mono(*e1, eff1, eff2);
            performs_within_mono(*e2, eff1, eff2);
            performs_within_mono(*e3, eff1, eff2);
        },
        SpecExpr::ELet(_, e1, e2) => {
            performs_within_mono(*e1, eff1, eff2);
            performs_within_mono(*e2, eff1, eff2);
        },
        SpecExpr::EPerform(eff_prime, e1) => {
            // eff_prime <= eff1 and eff1 <= eff2, so eff_prime <= eff2
            assert(effect_leq(eff_prime, eff2));
            performs_within_mono(*e1, eff1, eff2);
        },
        SpecExpr::EHandle(e1, _, h) => {
            performs_within_mono(*e1, eff1, eff2);
            performs_within_mono(*h, eff1, eff2);
        },
        SpecExpr::EGrant(_, e1) => {
            performs_within_mono(*e1, eff1, eff2);
        },
        SpecExpr::ERequire(_, e1) => {
            performs_within_mono(*e1, eff1, eff2);
        },
        SpecExpr::ERef(e1) | SpecExpr::EDeref(e1) => {
            performs_within_mono(*e1, eff1, eff2);
        },
        SpecExpr::EAssign(e1, e2) => {
            performs_within_mono(*e1, eff1, eff2);
            performs_within_mono(*e2, eff1, eff2);
        },
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 2: Pure Effect Minimality
// ═══════════════════════════════════════════════════════════════════════════

/// A pure expression satisfies any effect bound
pub proof fn pure_performs_any(e: SpecExpr, eff: Effect)
    requires performs_within(e, Effect::EffPure),
    ensures performs_within(e, eff),
{
    performs_within_mono(e, Effect::EffPure, eff);
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 3: Grant Non-Escalation
// ═══════════════════════════════════════════════════════════════════════════

/// EGrant does NOT add effects: if e performs within eff, so does Grant(_, e)
pub proof fn grant_no_escalation(eff_grant: Effect, e: SpecExpr, eff_bound: Effect)
    requires performs_within(e, eff_bound),
    ensures performs_within(SpecExpr::EGrant(eff_grant, Box::new(e)), eff_bound),
{
}

/// Grant effect is transparent: EGrant doesn't change effect bound
pub proof fn grant_effect_transparent(eff_grant: Effect, e: SpecExpr, eff_bound: Effect)
    requires performs_within(SpecExpr::EGrant(eff_grant, Box::new(e)), eff_bound),
    ensures performs_within(e, eff_bound),
{
}

/// Grant is a no-op for effect analysis (iff)
pub proof fn grant_effect_iff(eff_grant: Effect, e: SpecExpr, eff_bound: Effect)
    ensures
        performs_within(SpecExpr::EGrant(eff_grant, Box::new(e)), eff_bound) ==
        performs_within(e, eff_bound),
{
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 4: Handle Decomposition
// ═══════════════════════════════════════════════════════════════════════════

/// Handle body is bounded by the handle's bound
pub proof fn handle_body_bound(e: SpecExpr, x: Seq<char>, h: SpecExpr, eff: Effect)
    requires performs_within(SpecExpr::EHandle(Box::new(e), x, Box::new(h)), eff),
    ensures performs_within(e, eff),
{
}

/// Handle handler is bounded by the handle's bound
pub proof fn handle_handler_bound(e: SpecExpr, x: Seq<char>, h: SpecExpr, eff: Effect)
    requires performs_within(SpecExpr::EHandle(Box::new(e), x, Box::new(h)), eff),
    ensures performs_within(h, eff),
{
}

/// Combine body and handler bounds into handle bound
pub proof fn handle_bound_combine(e: SpecExpr, x: Seq<char>, h: SpecExpr, eff: Effect)
    requires performs_within(e, eff), performs_within(h, eff),
    ensures performs_within(SpecExpr::EHandle(Box::new(e), x, Box::new(h)), eff),
{
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 5: Perform Requires License
// "Tak Ada Bukti, Tak Jadi Kesan" (No Proof, No Effect)
// ═══════════════════════════════════════════════════════════════════════════

/// Non-pure perform is forbidden in pure context
pub proof fn perform_requires_license(eff_prime: Effect, e: SpecExpr)
    requires effect_level(eff_prime) > 0,
    ensures !performs_within(SpecExpr::EPerform(eff_prime, Box::new(e)), Effect::EffPure),
{
}

/// Non-pure effect has level > 0
pub proof fn nonpure_level_pos(eff: Effect)
    requires eff != Effect::EffPure,
    ensures effect_level(eff) > 0,
{
}

/// Combined: non-pure perform is blocked in pure context
pub proof fn nonpure_perform_blocked(eff_prime: Effect, e: SpecExpr)
    requires eff_prime != Effect::EffPure,
    ensures !performs_within(SpecExpr::EPerform(eff_prime, Box::new(e)), Effect::EffPure),
{
    nonpure_level_pos(eff_prime);
    perform_requires_license(eff_prime, e);
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 6: Gate Weakening
// ═══════════════════════════════════════════════════════════════════════════

/// Specific bounds: read within write
pub proof fn read_within_write(e: SpecExpr)
    requires performs_within(e, Effect::EffRead),
    ensures performs_within(e, Effect::EffWrite),
{
    performs_within_mono(e, Effect::EffRead, Effect::EffWrite);
}

/// Specific bounds: write within IO
pub proof fn write_within_io(e: SpecExpr)
    requires performs_within(e, Effect::EffWrite),
    ensures performs_within(e, Effect::EffIO),
{
    performs_within_mono(e, Effect::EffWrite, Effect::EffIO);
}

/// Specific bounds: IO within Full
pub proof fn io_within_full(e: SpecExpr)
    requires performs_within(e, Effect::EffIO),
    ensures performs_within(e, Effect::EffFull),
{
    performs_within_mono(e, Effect::EffIO, Effect::EffFull);
}

} // verus!
