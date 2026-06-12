// Copyright (c) 2026 The RIINA Authors. All rights reserved.
//
// RIINA Lexicographic Well-Founded Order - REAL Verus Proofs (Worker D Phase 5)
//
// Establishes the lexicographic order on (nat, nat) pairs that enables
// well-founded recursion on (step_index, ty_size). Also covers step-type
// order and triple lexicographic order.
//
// Based on: LexOrder.v (16 Qed)
//
// KEY INSIGHT: TFn contravariance requires decreasing step index for arguments,
// while same step allows decreasing type size. The lex order captures this.

#![allow(unused)]
use vstd::prelude::*;

verus! {

// ═══════════════════════════════════════════════════════════════════════════
// SPEC TYPES
// ═══════════════════════════════════════════════════════════════════════════

pub enum SpecTy {
    TUnit, TBool, TInt, TString,
    TFn(Box<SpecTy>, Box<SpecTy>, SpecEffect),
    TProd(Box<SpecTy>, Box<SpecTy>), TSum(Box<SpecTy>, Box<SpecTy>),
    TRef(Box<SpecTy>, SpecSecurityLevel),
    TSecret(Box<SpecTy>),
}

pub enum SpecEffect { EffectPure, EffectRead, EffectWrite }

#[derive(PartialEq, Eq)]
pub enum SpecSecurityLevel { LPublic, LSecret }

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 1: Lexicographic Order on (nat, nat) Pairs
// ═══════════════════════════════════════════════════════════════════════════

/// lex_lt: (m1, m2) < (n1, n2) iff m1 < n1, or m1 == n1 and m2 < n2
pub open spec fn lex_lt(m1: nat, m2: nat, n1: nat, n2: nat) -> bool {
    m1 < n1 || (m1 == n1 && m2 < n2)
}

/// lex_lt_left: If n' < n, then (n', m') < (n, m) for any m, m'
pub proof fn lex_lt_left(n: nat, m: nat, n_prime: nat, m_prime: nat)
    requires n_prime < n,
    ensures lex_lt(n_prime, m_prime, n, m),
{
}

/// lex_lt_right: If m' < m, then (n, m') < (n, m)
pub proof fn lex_lt_right(n: nat, m: nat, m_prime: nat)
    requires m_prime < m,
    ensures lex_lt(n, m_prime, n, m),
{
}

/// lex_lt is irreflexive: not (p < p)
pub proof fn lex_lt_irrefl(n: nat, m: nat)
    ensures !lex_lt(n, m, n, m),
{
}

/// lex_lt is transitive
pub proof fn lex_lt_trans(a1: nat, a2: nat, b1: nat, b2: nat, c1: nat, c2: nat)
    requires
        lex_lt(a1, a2, b1, b2),
        lex_lt(b1, b2, c1, c2),
    ensures
        lex_lt(a1, a2, c1, c2),
{
}

/// lex_lt is asymmetric
pub proof fn lex_lt_asymm(a1: nat, a2: nat, b1: nat, b2: nat)
    requires lex_lt(a1, a2, b1, b2),
    ensures !lex_lt(b1, b2, a1, a2),
{
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 2: Type Size (mirrors TypeMeasure.v)
// ═══════════════════════════════════════════════════════════════════════════

pub open spec fn ty_size(t: SpecTy) -> nat
    decreases t,
{
    match t {
        SpecTy::TUnit | SpecTy::TBool | SpecTy::TInt | SpecTy::TString => 1,
        SpecTy::TFn(t1, t2, _) => 1 + ty_size(*t1) + ty_size(*t2),
        SpecTy::TProd(t1, t2) => 1 + ty_size(*t1) + ty_size(*t2),
        SpecTy::TSum(t1, t2) => 1 + ty_size(*t1) + ty_size(*t2),
        SpecTy::TRef(t1, _) => 1 + ty_size(*t1),
        SpecTy::TSecret(t1) => 1 + ty_size(*t1),
    }
}

pub proof fn ty_size_pos(t: SpecTy)
    ensures ty_size(t) > 0,
    decreases t,
{
    match t {
        SpecTy::TUnit | SpecTy::TBool | SpecTy::TInt | SpecTy::TString => {},
        SpecTy::TFn(t1, t2, _) => { ty_size_pos(*t1); ty_size_pos(*t2); },
        SpecTy::TProd(t1, t2) => { ty_size_pos(*t1); ty_size_pos(*t2); },
        SpecTy::TSum(t1, t2) => { ty_size_pos(*t1); ty_size_pos(*t2); },
        SpecTy::TRef(t1, _) => { ty_size_pos(*t1); },
        SpecTy::TSecret(t1) => { ty_size_pos(*t1); },
    }
}

pub proof fn ty_size_fn_arg(t1: SpecTy, t2: SpecTy, eff: SpecEffect)
    ensures ty_size(t1) < ty_size(SpecTy::TFn(Box::new(t1), Box::new(t2), eff)),
{
    ty_size_pos(t2);
}

pub proof fn ty_size_fn_res(t1: SpecTy, t2: SpecTy, eff: SpecEffect)
    ensures ty_size(t2) < ty_size(SpecTy::TFn(Box::new(t1), Box::new(t2), eff)),
{
    ty_size_pos(t1);
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 3: Step-Type Lexicographic Order
// ═══════════════════════════════════════════════════════════════════════════

/// step_ty_lt: (n1, T1) < (n2, T2) in the lex order (step, ty_size)
pub open spec fn step_ty_lt(n1: nat, t1: SpecTy, n2: nat, t2: SpecTy) -> bool {
    n1 < n2 || (n1 == n2 && ty_size(t1) < ty_size(t2))
}

/// Decreasing step index: (n, T') < (S n, T) for any T, T'
pub proof fn step_ty_lt_step(n: nat, t: SpecTy, t_prime: SpecTy)
    ensures step_ty_lt(n, t_prime, n + 1, t),
{
}

/// Same step, smaller type: (n, T') < (n, T) when ty_size(T') < ty_size(T)
pub proof fn step_ty_lt_ty(n: nat, t: SpecTy, t_prime: SpecTy)
    requires ty_size(t_prime) < ty_size(t),
    ensures step_ty_lt(n, t_prime, n, t),
{
}

/// TFn arg is smaller at same step
pub proof fn step_ty_lt_fn_arg(n: nat, t1: SpecTy, t2: SpecTy, eff: SpecEffect)
    ensures step_ty_lt(n, t1, n, SpecTy::TFn(Box::new(t1), Box::new(t2), eff)),
{
    ty_size_fn_arg(t1, t2, eff);
}

/// TFn result is smaller at same step
pub proof fn step_ty_lt_fn_res(n: nat, t1: SpecTy, t2: SpecTy, eff: SpecEffect)
    ensures step_ty_lt(n, t2, n, SpecTy::TFn(Box::new(t1), Box::new(t2), eff)),
{
    ty_size_fn_res(t1, t2, eff);
}

/// step_ty_lt is irreflexive
pub proof fn step_ty_lt_irrefl(n: nat, t: SpecTy)
    ensures !step_ty_lt(n, t, n, t),
{
}

/// step_ty_lt with any smaller step
pub proof fn step_ty_lt_step_any(n: nat, n_prime: nat, t: SpecTy, t_prime: SpecTy)
    requires n_prime < n,
    ensures step_ty_lt(n_prime, t_prime, n, t),
{
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 4: Triple Lexicographic Order
// ═══════════════════════════════════════════════════════════════════════════

/// triple_lt: (a1, b1, c1) < (a2, b2, c2) in lexicographic order
pub open spec fn triple_lt(a1: nat, b1: nat, c1: nat, a2: nat, b2: nat, c2: nat) -> bool {
    a1 < a2 || (a1 == a2 && b1 < b2) || (a1 == a2 && b1 == b2 && c1 < c2)
}

/// triple_lt is irreflexive
pub proof fn triple_lt_irrefl(a: nat, b: nat, c: nat)
    ensures !triple_lt(a, b, c, a, b, c),
{
}

/// triple_lt is transitive
pub proof fn triple_lt_trans(
    a1: nat, b1: nat, c1: nat,
    a2: nat, b2: nat, c2: nat,
    a3: nat, b3: nat, c3: nat,
)
    requires
        triple_lt(a1, b1, c1, a2, b2, c2),
        triple_lt(a2, b2, c2, a3, b3, c3),
    ensures
        triple_lt(a1, b1, c1, a3, b3, c3),
{
}

} // verus!
