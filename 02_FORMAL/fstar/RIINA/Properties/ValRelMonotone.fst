(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/ValRelMonotone.v (14 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.ValRelMonotone
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* val_rel_le_monotone (matches Coq: Theorem val_rel_le_monotone) *)
let val_rel_le_monotone (p_m: _) (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_pred (matches Coq: Lemma val_rel_le_pred) *)
let val_rel_le_pred (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_trans_mono (matches Coq: Lemma val_rel_le_trans_mono) *)
let val_rel_le_trans_mono (p_k: _) (p_m: _) (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_k <= p_m /\ p_m <= p_n /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_k p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_max (matches Coq: Lemma val_rel_le_max) *)
let val_rel_le_max (p_m: _) (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_m p_sigma p_t p_v1 p_v2 == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le (max p_m p_n) p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_from_max (matches Coq: Lemma val_rel_le_from_max) *)
let val_rel_le_from_max (p_m: _) (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le (max p_m p_n) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_m p_sigma p_t p_v1 p_v2 == true /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_to_min (matches Coq: Lemma val_rel_le_to_min) *)
let val_rel_le_to_min (p_m: _) (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_m p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le (min p_m p_n) p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_to_min_r (matches Coq: Lemma val_rel_le_to_min_r) *)
let val_rel_le_to_min_r (p_m: _) (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le (min p_m p_n) p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_drop (matches Coq: Lemma val_rel_le_drop) *)
let val_rel_le_drop (p_k: _) (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le (p_n + p_k) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_double_mono (matches Coq: Lemma val_rel_le_double_mono) *)
let val_rel_le_double_mono (p_m: _) (p_n: _) (p_k: _) (p_l: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_m <= p_n /\ p_k <= p_l /\ val_rel_le (Nat.max p_n p_l) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le (Nat.min p_m p_k) p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_step_down_1 (matches Coq: Lemma val_rel_le_step_down_1) *)
let val_rel_le_step_down_1 (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le ((p_n + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_step_down_2 (matches Coq: Lemma val_rel_le_step_down_2) *)
let val_rel_le_step_down_2 (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le ((((p_n + 1)) + 1)) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_from_succ (matches Coq: Lemma val_rel_le_from_succ) *)
let val_rel_le_from_succ (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (p_n > 0 /\ val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le (p_n - 1) p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_mono_witness (matches Coq: Lemma val_rel_le_mono_witness) *)
let val_rel_le_mono_witness (p_n: _) (p_m: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true /\ p_m <= p_n)) (ensures (val_rel_le p_m p_sigma p_t p_v1 p_v2 == true)) = ()

(* val_rel_le_half (matches Coq: Lemma val_rel_le_half) *)
let val_rel_le_half (p_n: _) (p_sigma: _) (p_t: _) (p_v1: _) (p_v2: _) : Lemma (requires (val_rel_le (2 * p_n) p_sigma p_t p_v1 p_v2 == true)) (ensures (val_rel_le p_n p_sigma p_t p_v1 p_v2 == true)) = ()
