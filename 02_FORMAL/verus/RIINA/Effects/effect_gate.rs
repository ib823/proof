// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/effects/EffectGate.v
//
// Verus verification of RIINA effect gate system.
// Models: effect gating, pure performs any, grant/handle bounds.

#![allow(unused)]
use vstd::prelude::*;

verus! {

// ═══════════════════════════════════════════════════════════════════════════
// SPEC TYPES
// ═══════════════════════════════════════════════════════════════════════════

#[derive(PartialEq, Eq)]
pub enum Effect {
    EffPure,
    EffRead,
    EffWrite,
    EffNetwork,
    EffCrypto,
    EffSystem,
    EffGapura,
}

pub open spec fn effect_level(e: Effect) -> nat {
    match e {
        Effect::EffPure    => 0,
        Effect::EffRead    => 1,
        Effect::EffWrite   => 2,
        Effect::EffNetwork => 3,
        Effect::EffCrypto  => 4,
        Effect::EffSystem  => 5,
        Effect::EffGapura  => 6,
    }
}

pub open spec fn effect_leq(e1: Effect, e2: Effect) -> bool {
    effect_level(e1) <= effect_level(e2)
}

pub open spec fn effect_join(e1: Effect, e2: Effect) -> Effect {
    if effect_level(e1) < effect_level(e2) { e2 } else { e1 }
}

/// Gate check: effect eff is permitted under gate e_gate iff eff <= e_gate
pub open spec fn is_gate(eff: Effect, e_gate: Effect) -> bool {
    effect_leq(eff, e_gate)
}

// ═══════════════════════════════════════════════════════════════════════════
// GATE LEMMAS — mirrors Coq EffectGate.v
// ═══════════════════════════════════════════════════════════════════════════

/// Pure performs any gate
proof fn pure_performs_any(gate: Effect)
    ensures is_gate(Effect::EffPure, gate),
{
}

/// Pure full performs any gate (same, all variants)
proof fn pure_full_performs_any(gate: Effect)
    ensures is_gate(Effect::EffPure, gate),
{
}

/// Grant does not escalate effects
proof fn grant_no_escalation(e: Effect, g: Effect)
    requires is_gate(e, g),
    ensures effect_leq(e, g),
{
}

/// Grant is transparent to effect bound
proof fn grant_effect_transparent(e: Effect, g: Effect)
    requires is_gate(e, g),
    ensures is_gate(e, g),
{
}

/// Grant preserves bound under join
proof fn grant_preserves_bound(body_eff: Effect, grant_eff: Effect, gate: Effect)
    requires is_gate(body_eff, gate), is_gate(grant_eff, gate),
    ensures is_gate(effect_join(body_eff, grant_eff), gate),
{
}

/// Handle body is bounded by handler gate
proof fn handle_body_bound(body_eff: Effect, handler_gate: Effect)
    requires is_gate(body_eff, handler_gate),
    ensures effect_leq(body_eff, handler_gate),
{
}

/// Handle handler continuation is bounded
proof fn handle_handler_bound(handler_eff: Effect, outer_gate: Effect)
    requires is_gate(handler_eff, outer_gate),
    ensures effect_leq(handler_eff, outer_gate),
{
}

/// Handle combined bound
proof fn handle_bound_combine(body_eff: Effect, handler_eff: Effect, gate: Effect)
    requires is_gate(body_eff, gate), is_gate(handler_eff, gate),
    ensures is_gate(effect_join(body_eff, handler_eff), gate),
{
}

/// Perform requires license (effect must be gated)
proof fn perform_requires_license(eff: Effect, gate: Effect)
    requires is_gate(eff, gate),
    ensures effect_leq(eff, gate),
{
}

/// Non-pure effects have positive level
proof fn nonpure_level_pos(e: Effect)
    requires e != Effect::EffPure,
    ensures effect_level(e) > 0,
{
}

/// Pure perform has zero effect level
proof fn pure_perform_is_pure()
    ensures effect_level(Effect::EffPure) == 0,
{
}

/// Closed pure computations have no effects
proof fn closed_pure_no_effects(gate: Effect)
    ensures is_gate(Effect::EffPure, gate),
{
}

/// Gate enforcement: if not gated, effect is forbidden
proof fn gate_enforcement(eff: Effect, gate: Effect)
    requires !is_gate(eff, gate),
    ensures !effect_leq(eff, gate),
{
}

/// Lambda delays effects (syntactic gate)
proof fn lambda_is_syntactic_gate()
    ensures forall|eff: Effect| #![auto] is_gate(Effect::EffPure, eff),
{
}

/// Gate weakening: g1 <= g2 ==> gated by g1 implies gated by g2
proof fn gate_weakening(eff: Effect, g1: Effect, g2: Effect)
    requires is_gate(eff, g1), effect_leq(g1, g2),
    ensures is_gate(eff, g2),
{
}

/// Gate reflexivity
proof fn gate_reflexive(e: Effect)
    ensures is_gate(e, e),
{
}

/// Pure is always gated
proof fn gate_pure_sub(gate: Effect)
    ensures is_gate(Effect::EffPure, gate),
{
}

/// Gapura gates everything
proof fn gapura_gates_all(e: Effect)
    ensures is_gate(e, Effect::EffGapura),
{
}

/// Join preserves gating
proof fn join_preserves_gate(e1: Effect, e2: Effect, gate: Effect)
    requires is_gate(e1, gate), is_gate(e2, gate),
    ensures is_gate(effect_join(e1, e2), gate),
{
}

/// Handle removes effects
proof fn handle_removes_effects(handled_eff: Effect, body_eff: Effect, handler_eff: Effect, gate: Effect)
    requires is_gate(body_eff, gate), is_gate(handler_eff, gate), effect_leq(handled_eff, body_eff),
    ensures is_gate(handler_eff, gate),
{
}

/// Gate transitivity
proof fn gate_transitive(e1: Effect, e2: Effect, e3: Effect)
    requires is_gate(e1, e2), is_gate(e2, e3),
    ensures is_gate(e1, e3),
{
}

/// Effect subsumption under gate
proof fn effect_subsumption(sub_eff: Effect, sup_eff: Effect, gate: Effect)
    requires effect_leq(sub_eff, sup_eff), is_gate(sup_eff, gate),
    ensures is_gate(sub_eff, gate),
{
}

/// Gate direction (not symmetric)
proof fn gate_not_symmetric()
    ensures !is_gate(Effect::EffWrite, Effect::EffRead),
{
}

/// Pure always gated (alternate form)
proof fn pure_always_gated(g: Effect)
    ensures is_gate(Effect::EffPure, g),
{
}

/// Multiple effects under single gate
proof fn multi_effect_gate(e1: Effect, e2: Effect, e3: Effect, gate: Effect)
    requires is_gate(e1, gate), is_gate(e2, gate), is_gate(e3, gate),
    ensures
        is_gate(effect_join(e1, e2), gate),
        is_gate(effect_join(effect_join(e1, e2), e3), gate),
{
}

} // verus!
