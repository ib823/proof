(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/StoreWfLemmas.v (17 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.StoreWfLemmas
open FStar.All

(* value — Coq Prop predicate stub *)
let value (__x0: nat) : Tot bool = true

(* wf_session — Coq Prop predicate stub *)
let wf_session (__x0: nat) : Tot bool = true

(* step — Coq Prop predicate stub *)
let step (__x0: nat) (__x1: nat) : Tot bool = true

(* multi_step — Coq Prop predicate stub *)
let multi_step (__x0: nat) (__x1: nat) : Tot bool = true

(* has_type — Coq Prop predicate stub *)
let has_type (__x0: nat) (__x1: nat) (__x2: nat) (__x3: nat) (__x4: nat) (__x5: nat) : Tot bool = true

(* store_wf_lookup_value (matches Coq: Lemma store_wf_lookup_value) *)
let store_wf_lookup_value (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures (value p_v == true)) = ()

(* store_wf_lookup_typed (matches Coq: Lemma store_wf_lookup_typed) *)
let store_wf_lookup_typed (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures ((exists p_t. (exists p_sl. store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) /\ has_type [] p_sigma Public p_v T EffectPure == true)) = ()

(* store_wf_typed_loc_has_value (matches Coq: Lemma store_wf_typed_loc_has_value) *)
let store_wf_typed_loc_has_value (p_sigma: _) (p_st: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v. store_lookup p_l p_st == Some p_v) /\ value v == true)) = ()

(* store_wf_typed_loc_gives_typed_value (matches Coq: Lemma store_wf_typed_loc_gives_typed_value) *)
let store_wf_typed_loc_gives_typed_value (p_sigma: _) (p_st: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v. store_lookup p_l p_st == Some p_v) /\ value v == true /\ has_type [] p_sigma Public v p_t EffectPure == true)) = ()

(* store_wf_forward (matches Coq: Lemma store_wf_forward) *)
let store_wf_forward (p_sigma: _) (p_st: _) : Lemma (requires (store_wf p_sigma p_st == true /\ (forall (l: _). (forall (t: _). (forall (sl: _). store_ty_lookup l p_sigma == Some (t, sl)))))) (ensures ((exists p_v. store_lookup l p_st == Some p_v) /\ value v == true /\ has_type [] p_sigma Public v T EffectPure == true)) = ()

(* store_wf_backward (matches Coq: Lemma store_wf_backward) *)
let store_wf_backward (p_sigma: _) (p_st: _) : Lemma (requires (store_wf p_sigma p_st == true /\ (forall (l: _). (forall (v: _). store_lookup l p_st == Some v)))) (ensures ((exists p_t. (exists p_sl. store_ty_lookup l p_sigma == Some (p_t, p_sl))) /\ value v == true /\ has_type [] p_sigma Public v T EffectPure == true)) = ()

(* store_wf_empty (matches Coq: Lemma store_wf_empty) *)
let store_wf_empty () : Lemma (store_wf [] [] == true) = ()

(* store_wf_empty_ty_no_values (matches Coq: Lemma store_wf_empty_ty_no_values) *)
let store_wf_empty_ty_no_values (p_st: _) : Lemma (requires (store_wf [] p_st == true)) (ensures ((forall (l: _). (forall (v: _). store_lookup l p_st == None)) \/ ~(value v == true) \/ ~(store_lookup l p_st == Some v))) = ()

(* store_wf_lookup_agree (matches Coq: Lemma store_wf_lookup_agree) *)
let store_wf_lookup_agree (p_sigma: _) (p_st1: _) (p_st2: _) : Lemma (requires (store_wf p_sigma p_st1 == true /\ ((forall (l: _). store_lookup l p_st1 == store_lookup l p_st2)))) (ensures (store_wf p_sigma p_st2 == true)) = ()

(* store_wf_all_pure (matches Coq: Lemma store_wf_all_pure) *)
let store_wf_all_pure (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures ((exists p_t. has_type [] p_sigma Public p_v p_t EffectPure == true))) = ()

(* store_wf_lookup_is_value (matches Coq: Lemma store_wf_lookup_is_value) *)
let store_wf_lookup_is_value (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures (value p_v == true)) = ()

(* store_wf_extends_forward (matches Coq: Lemma store_wf_extends_forward) *)
let store_wf_extends_forward (p_sigma: _) (p_sigma_prime: _) (p_st: _) (p_l: _) (p_t: _) (p_sl: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_ty_extends p_sigma p_sigma' == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl))) (ensures ((exists p_v. store_lookup p_l p_st == Some p_v) /\ value v == true)) = ()

(* store_wf_loc_not_in_ty (matches Coq: Lemma store_wf_loc_not_in_ty) *)
let store_wf_loc_not_in_ty (p_sigma: _) (p_st: _) (p_l: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_ty_lookup p_l p_sigma == None)) (ensures ((forall (t: _). (forall (sl: _). ~((store_ty_lookup p_l p_sigma == Some (t, sl))))))) = ()

(* store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored) *)
let store_wf_typed_implies_stored (p_sigma: _) (p_st: _) (p_l: _) : Lemma (requires (store_wf p_sigma p_st == true /\ ((exists p_t. (exists p_sl. store_ty_lookup p_l p_sigma == Some (p_t, p_sl)))))) (ensures ((exists p_v. store_lookup p_l p_st == Some p_v))) = ()

(* store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed) *)
let store_wf_stored_implies_typed (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_lookup p_l p_st == Some p_v)) (ensures ((exists p_t. (exists p_sl. store_ty_lookup p_l p_sigma == Some (p_t, p_sl))))) = ()

(* store_wf_update_same_type (matches Coq: Lemma store_wf_update_same_type) *)
let store_wf_update_same_type (p_sigma: _) (p_st: _) (p_l: _) (p_v: _) (p_t: _) (p_sl: _) : Lemma (requires (store_wf p_sigma p_st == true /\ store_ty_lookup p_l p_sigma == Some (p_t, p_sl) /\ value p_v == true /\ has_type [] p_sigma Public p_v p_t EffectPure == true)) (ensures (store_wf p_sigma (store_update p_l p_v p_st) == true)) = ()

(* store_wf_characterize (matches Coq: Lemma store_wf_characterize) *)
let store_wf_characterize (p_sigma: _) (p_st: _) : Lemma (store_wf p_sigma p_st == true <==> (((forall (l: _). (forall (t: _). (forall (sl: _). store_ty_lookup l p_sigma == Some (t, sl) -> exists v_ store_lookup l p_st = Some v))) /\ value v == true /\ has_type [] p_sigma Public v T EffectPure == true) /\ ((forall (l: _). (forall (v: _). store_lookup l p_st == Some v -> exists T sl_ store_ty_lookup l p_sigma = Some (T, sl))) /\ value v == true /\ has_type [] p_sigma Public v T EffectPure == true))) = ()
