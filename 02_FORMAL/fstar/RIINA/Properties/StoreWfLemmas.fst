(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/StoreWfLemmas.v (4 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.StoreWfLemmas
open FStar.All

(* store_wf_lookup_value (matches Coq: Lemma store_wf_lookup_value) *)
let store_wf_lookup_value (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf Σ p_st == true /\ store_lookup p_l p_st == Some p_v) (ensures (value p_v == true))) = admit ()

(* store_wf_lookup_typed (matches Coq: Lemma store_wf_lookup_typed) *)
let store_wf_lookup_typed (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf Σ p_st == true /\ store_lookup p_l p_st == Some p_v) (ensures (exists T sl_ store_ty_lookup p_l Σ == Some (T, sl) /\ has_type nil Σ Public p_v T EffectPure == true))) = admit ()

(* store_wf_typed_loc_has_value (matches Coq: Lemma store_wf_typed_loc_has_value) *)
let store_wf_typed_loc_has_value (p_st: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_wf Σ p_st == true /\ store_ty_lookup p_l Σ == Some (p_t, p_sl)) (ensures (exists v_ store_lookup p_l p_st == Some v /\ value v == true))) = admit ()

(* store_wf_typed_loc_gives_typed_value (matches Coq: Lemma store_wf_typed_loc_gives_typed_value) *)
let store_wf_typed_loc_gives_typed_value (p_st: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_wf Σ p_st == true /\ store_ty_lookup p_l Σ == Some (p_t, p_sl)) (ensures (exists v_ store_lookup p_l p_st == Some v /\ value v == true /\ has_type nil Σ Public v p_t EffectPure == true))) = admit ()
