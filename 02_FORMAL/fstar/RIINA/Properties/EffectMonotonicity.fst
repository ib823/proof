(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v (41 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.EffectMonotonicity
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* app_pure_implies_parts_pure (matches Coq: Lemma app_pure_implies_parts_pure) *)
let app_pure_implies_parts_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t1: _) (p_t: _) (p_epsilon_fn: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 (TFn p_t1 p_t p_epsilon_fn) p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e2 p_t1 p_epsilon2 == true /\ effect_join p_epsilon_fn (effect_join p_epsilon1 p_epsilon2) == EffPure)) (ensures (p_epsilon_fn == EffPure /\ p_epsilon1 == EffPure /\ p_epsilon2 == EffPure)) = admit ()

(* let_pure_implies_parts_pure (matches Coq: Lemma let_pure_implies_parts_pure) *)
let let_pure_implies_parts_pure (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (effect_join p_epsilon1 p_epsilon2 == EffPure)) (ensures (p_epsilon1 == EffPure /\ p_epsilon2 == EffPure)) = admit ()

(* if_pure_implies_parts_pure (matches Coq: Lemma if_pure_implies_parts_pure) *)
let if_pure_implies_parts_pure (p_epsilon1: _) (p_epsilon2: _) (p_epsilon3: _) : Lemma (requires (effect_join p_epsilon1 (effect_join p_epsilon2 p_epsilon3) == EffPure)) (ensures (p_epsilon1 == EffPure /\ p_epsilon2 == EffPure /\ p_epsilon3 == EffPure)) = admit ()

(* app_effect_geq_fn (matches Coq: Lemma app_effect_geq_fn) *)
let app_effect_geq_fn (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) (p_t1: _) (p_epsilon_fn: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 (TFn p_t1 p_t p_epsilon_fn) p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e2 p_t1 p_epsilon2 == true)) (ensures (effect_leq p_epsilon_fn (effect_join p_epsilon_fn (effect_join p_epsilon1 p_epsilon2)) == true)) = admit ()

(* app_effect_geq_arg1 (matches Coq: Lemma app_effect_geq_arg1) *)
let app_effect_geq_arg1 (p_epsilon_fn: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (effect_leq p_epsilon1 (effect_join p_epsilon_fn (effect_join p_epsilon1 p_epsilon2)) == true) = admit ()

(* app_effect_geq_arg2 (matches Coq: Lemma app_effect_geq_arg2) *)
let app_effect_geq_arg2 (p_epsilon_fn: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (effect_leq p_epsilon2 (effect_join p_epsilon_fn (effect_join p_epsilon1 p_epsilon2)) == true) = admit ()

(* let_effect_geq_body (matches Coq: Lemma let_effect_geq_body) *)
let let_effect_geq_body (p_epsilon1: _) (p_epsilon2: _) : Lemma (effect_leq p_epsilon1 (effect_join p_epsilon1 p_epsilon2) == true) = admit ()

(* let_effect_geq_cont (matches Coq: Lemma let_effect_geq_cont) *)
let let_effect_geq_cont (p_epsilon1: _) (p_epsilon2: _) : Lemma (effect_leq p_epsilon2 (effect_join p_epsilon1 p_epsilon2) == true) = admit ()

(* fst_pure (matches Coq: Lemma fst_pure) *)
let fst_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t1: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EFst p_e) p_t1 EffPure == true)) (ensures ((exists p_t2. has_type p_gamma p_sigma p_delta p_e (TProd p_t1 p_t2) EffPure == true))) = admit ()

(* snd_pure (matches Coq: Lemma snd_pure) *)
let snd_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ESnd p_e) p_t2 EffPure == true)) (ensures ((exists p_t1. has_type p_gamma p_sigma p_delta p_e (TProd p_t1 p_t2) EffPure == true))) = admit ()

(* classify_pure (matches Coq: Lemma classify_pure) *)
let classify_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EClassify p_e) (TSecret p_t) EffPure == true)) (ensures (has_type p_gamma p_sigma p_delta p_e p_t EffPure == true)) = admit ()

(* prove_pure (matches Coq: Lemma prove_pure) *)
let prove_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EProve p_e) (TProof p_t) EffPure == true)) (ensures (has_type p_gamma p_sigma p_delta p_e p_t EffPure == true)) = admit ()

(* effect_join_level_bound (matches Coq: Lemma effect_join_level_bound) *)
let effect_join_level_bound (p_e1: _) (p_e2: _) : Lemma (effect_level (effect_join p_e1 p_e2) == Nat.max (effect_level p_e1) (effect_level p_e2)) = admit ()

(* effect_leq_join_both (matches Coq: Lemma effect_leq_join_both) *)
let effect_leq_join_both (p_e1: _) (p_e2: _) (p_e: _) : Lemma (requires (effect_leq (effect_join p_e1 p_e2) p_e == true)) (ensures (effect_leq p_e1 p_e == true /\ effect_leq p_e2 p_e == true)) = admit ()

(* effect_leq_both_join (matches Coq: Lemma effect_leq_both_join) *)
let effect_leq_both_join (p_e1: _) (p_e2: _) (p_e: _) : Lemma (requires (effect_leq p_e1 p_e == true /\ effect_leq p_e2 p_e == true)) (ensures (effect_leq (effect_join p_e1 p_e2) p_e == true)) = admit ()

(* effect_join_pure_r (matches Coq: Lemma effect_join_pure_r) *)
let effect_join_pure_r (p_e: _) : Lemma (effect_join p_e EffPure == p_e) = admit ()

(* tfn_injective (matches Coq: Lemma tfn_injective) *)
let tfn_injective (p_t1: _) (p_t2: _) (p_epsilon1: _) (p_t1_: _) (p_t2_: _) (p_epsilon1_: _) : Lemma (requires (TFn p_t1 p_t2 p_epsilon1 == TFn p_t1' p_t2' p_epsilon1_)) (ensures (p_t1 == p_t1' /\ p_t2 == p_t2' /\ p_epsilon1 == p_epsilon1_)) = admit ()

(* tprod_injective (matches Coq: Lemma tprod_injective) *)
let tprod_injective (p_t1: _) (p_t2: _) (p_t1_: _) (p_t2_: _) : Lemma (requires (TProd p_t1 p_t2 == TProd p_t1' p_t2')) (ensures (p_t1 == p_t1' /\ p_t2 == p_t2')) = admit ()

(* tsum_injective (matches Coq: Lemma tsum_injective) *)
let tsum_injective (p_t1: _) (p_t2: _) (p_t1_: _) (p_t2_: _) : Lemma (requires (TSum p_t1 p_t2 == TSum p_t1' p_t2')) (ensures (p_t1 == p_t1' /\ p_t2 == p_t2')) = admit ()

(* tref_injective (matches Coq: Lemma tref_injective) *)
let tref_injective (p_t: _) (p_sl: _) (p_t_: _) (p_sl_: _) : Lemma (requires (TRef p_t p_sl == TRef p_t' p_sl_)) (ensures (p_t == p_t' /\ p_sl == p_sl_)) = admit ()

(* tsecret_injective (matches Coq: Lemma tsecret_injective) *)
let tsecret_injective (p_t: _) (p_t_: _) : Lemma (requires (TSecret p_t == TSecret p_t')) (ensures (p_t == p_t')) = admit ()

(* tproof_injective (matches Coq: Lemma tproof_injective) *)
let tproof_injective (p_t: _) (p_t_: _) : Lemma (requires (TProof p_t == TProof p_t')) (ensures (p_t == p_t')) = admit ()

(* tlist_injective (matches Coq: Lemma tlist_injective) *)
let tlist_injective (p_t: _) (p_t_: _) : Lemma (requires (TList p_t == TList p_t')) (ensures (p_t == p_t')) = admit ()

(* toption_injective (matches Coq: Lemma toption_injective) *)
let toption_injective (p_t: _) (p_t_: _) : Lemma (requires (TOption p_t == TOption p_t')) (ensures (p_t == p_t')) = admit ()

(* nested_let_effect (matches Coq: Lemma nested_let_effect) *)
let nested_let_effect (p_gamma: _) (p_sigma: _) (p_delta: _) (p_x: _) (p_y: _) (p_e1: _) (p_e2: _) (p_e3: _) (p_t1: _) (p_t2: _) (p_t3: _) (p_epsilon1: _) (p_epsilon2: _) (p_epsilon3: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 p_t1 p_epsilon1 == true /\ has_type ((p_x, p_t1) :: p_gamma) p_sigma p_delta p_e2 p_t2 p_epsilon2 == true /\ has_type ((p_y, p_t2) :: (p_x, p_t1) :: p_gamma) p_sigma p_delta p_e3 p_t3 p_epsilon3 == true)) (ensures (has_type p_gamma p_sigma p_delta (ELet p_x p_e1 (ELet p_y p_e2 p_e3)) p_t3 (effect_join p_epsilon1 (effect_join p_epsilon2 p_epsilon3)) == true)) = admit ()

(* sequential_pair_effect (matches Coq: Lemma sequential_pair_effect) *)
let sequential_pair_effect (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t1: _) (p_t2: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 p_t1 p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e2 p_t2 p_epsilon2 == true)) (ensures (has_type p_gamma p_sigma p_delta (EPair p_e1 p_e2) (TProd p_t1 p_t2) (effect_join p_epsilon1 p_epsilon2) == true)) = admit ()

(* classify_preserves_effect (matches Coq: Lemma classify_preserves_effect) *)
let classify_preserves_effect (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta (EClassify p_e) (TSecret p_t) p_epsilon == true)) = admit ()

(* prove_preserves_effect (matches Coq: Lemma prove_preserves_effect) *)
let prove_preserves_effect (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta (EProve p_e) (TProof p_t) p_epsilon == true)) = admit ()

(* inl_preserves_effect (matches Coq: Lemma inl_preserves_effect) *)
let inl_preserves_effect (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t1 p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta (EInl p_e p_t2) (TSum p_t1 p_t2) p_epsilon == true)) = admit ()

(* inr_preserves_effect (matches Coq: Lemma inr_preserves_effect) *)
let inr_preserves_effect (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t2 p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta (EInr p_e p_t1) (TSum p_t1 p_t2) p_epsilon == true)) = admit ()

(* ref_introduces_write (matches Coq: Lemma ref_introduces_write) *)
let ref_introduces_write (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_l: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ERef p_e p_l) p_t p_epsilon == true)) (ensures (effect_leq EffWrite p_epsilon == true)) = admit ()

(* deref_introduces_read (matches Coq: Lemma deref_introduces_read) *)
let deref_introduces_read (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EDeref p_e) p_t p_epsilon == true)) (ensures (effect_leq EffRead p_epsilon == true)) = admit ()

(* assign_introduces_write (matches Coq: Lemma assign_introduces_write) *)
let assign_introduces_write (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EAssign p_e1 p_e2) p_t p_epsilon == true)) (ensures (effect_leq EffWrite p_epsilon == true)) = admit ()

(* ref_not_pure (matches Coq: Lemma ref_not_pure) *)
let ref_not_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_l: _) (p_t: _) : Lemma (~(has_type p_gamma p_sigma p_delta (ERef p_e p_l) p_t EffPure == true)) = admit ()

(* deref_not_pure (matches Coq: Lemma deref_not_pure) *)
let deref_not_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) : Lemma (~(has_type p_gamma p_sigma p_delta (EDeref p_e) p_t EffPure == true)) = admit ()

(* assign_not_pure (matches Coq: Lemma assign_not_pure) *)
let assign_not_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) : Lemma (~(has_type p_gamma p_sigma p_delta (EAssign p_e1 p_e2) p_t EffPure == true)) = admit ()

(* ref_effect_level_positive (matches Coq: Lemma ref_effect_level_positive) *)
let ref_effect_level_positive (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_l: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ERef p_e p_l) p_t p_epsilon == true)) (ensures (effect_level p_epsilon > 0)) = admit ()

(* deref_effect_level_positive (matches Coq: Lemma deref_effect_level_positive) *)
let deref_effect_level_positive (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EDeref p_e) p_t p_epsilon == true)) (ensures (effect_level p_epsilon > 0)) = admit ()

(* assign_effect_level_positive (matches Coq: Lemma assign_effect_level_positive) *)
let assign_effect_level_positive (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EAssign p_e1 p_e2) p_t p_epsilon == true)) (ensures (effect_level p_epsilon > 0)) = admit ()

(* ref_deref_both_nonpure (matches Coq: Lemma ref_deref_both_nonpure) *)
let ref_deref_both_nonpure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_l1: _) (p_e2: _) (p_t1: _) (p_t2: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ERef p_e1 p_l1) p_t1 p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta (EDeref p_e2) p_t2 p_epsilon2 == true)) (ensures (~(p_epsilon1 == EffPure) /\ ~(p_epsilon2 == EffPure))) = admit ()

(* assign_deref_both_nonpure (matches Coq: Lemma assign_deref_both_nonpure) *)
let assign_deref_both_nonpure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_e3: _) (p_t1: _) (p_t2: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EAssign p_e1 p_e2) p_t1 p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta (EDeref p_e3) p_t2 p_epsilon2 == true)) (ensures (~(p_epsilon1 == EffPure) /\ ~(p_epsilon2 == EffPure))) = admit ()
