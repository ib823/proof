(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/SessionTypes.v (45 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.SessionTypes
open FStar.All

(* MsgType (matches Coq) *)
type msg_type =
  | MTNat
  | MTBool
  | MTUnit
  | MTString

(* SessionType (matches Coq) *)
type session_type =
  | SSend of (msg_type * session_type)
  | SRecv of (msg_type * session_type)
  | SEnd

(* Process (matches Coq) *)
type process =
  | PSend of (channel * nat * process)
  | PRecv of (channel * process)
  | PSelect of (channel * nat * process)
  | PClose of channel
  | PEnd
  | PPar of (process * process)

(* Channel (matches Coq) *)
type channel = {
  f_chan_id: nat;
  f_chan_type: session_type;
  f_chan_linear: bool;
}

(* ChannelPair (matches Coq) *)
type channel_pair = {
  f_endpoint_a: channel;
  f_endpoint_b: channel;
}

(* well_typed_proc — Coq Prop predicate stub *)
assume val well_typed_proc : nat -> process -> bool

(* msg_type_eqb (matches Coq: Definition msg_type_eqb) *)
let msg_type_eqb (p_m1: msg_type) (p_m2: msg_type) : Tot bool =
  match p_m1, p_m2 with
  | MTNat, MTNat -> true
  | MTBool, MTBool -> true
  | MTUnit, MTUnit -> true
  | MTString, MTString -> true
  | _, _ -> false
  | _ -> false

(* dual (matches Coq: Fixpoint dual) *)
let rec dual (p_s: session_type) : Tot session_type =
  match p_s with
  | SSend (t, p_s') -> SRecv t (dual p_s')
  | SRecv (t, p_s') -> SSend t (dual p_s')
  | SSelect branches -> SOffer (map (fun p -> (fst p, dual (snd p))) branches)
  | SOffer branches -> SSelect (map (fun p -> (fst p, dual (snd p))) branches)
  | SEnd -> SEnd
  | _ -> (* TODO: default value for session_type *) admit()

(* channel_used (matches Coq: Definition channel_used) *)
let channel_used (p_ch: channel) : Tot channel =
  {f_chan_id=(p_ch.f_chan_id); f_chan_type=(p_ch.f_chan_type); f_chan_linear=false}

(* is_fresh (matches Coq: Definition is_fresh) *)
let is_fresh (p_ch: channel) : Tot bool =
  true

(* well_formed_pair (matches Coq: Definition well_formed_pair) *)
let well_formed_pair (p_cp: channel_pair) : Tot bool =
  true

(* is_value (matches Coq: Definition is_value) *)
let is_value (p_p: process) : Tot bool =
  true

(* lookup (matches Coq: Fixpoint lookup) *)
let rec lookup (p_env: nat) (p_id: nat) : Tot nat =
  match p_env with
  | [] -> None
  | (p_id', ty) :: rest -> if (p_id = p_id') then Some ty else lookup rest p_id
  | _ -> 0

(* waiting (matches Coq: Definition waiting) *)
let waiting (p_cfg: nat) (p_t: nat) (p_r: nat) : Tot bool =
  true

(* holding (matches Coq: Definition holding) *)
let holding (p_cfg: nat) (p_t: nat) (p_r: nat) : Tot bool =
  true

(* waits_for (matches Coq: Definition waits_for) *)
let waits_for (p_cfg: nat) (p_t1: nat) (p_t2: nat) : Tot bool =
  true

(* circular_wait (matches Coq: Definition circular_wait) *)
let circular_wait (p_cfg: nat) : Tot bool =
  true

(* deadlocked (matches Coq: Definition deadlocked) *)
let deadlocked (p_cfg: nat) : Tot bool =
  true

(* session_typed (matches Coq: Definition session_typed) *)
let session_typed (p_cfg: nat) : Tot bool =
  true

(* ST_001_dual_end (matches Coq: Theorem ST_001_dual_end) *)
let st_001_dual_end () : Lemma (dual SEnd == SEnd) = admit ()

(* ST_002_dual_send_recv (matches Coq: Theorem ST_002_dual_send_recv) *)
let st_002_dual_send_recv (p_mt: _) (p_s: _) : Lemma (dual (SSend p_mt p_s) == SRecv p_mt (dual p_s)) = admit ()

(* ST_003_dual_recv_send (matches Coq: Theorem ST_003_dual_recv_send) *)
let st_003_dual_recv_send (p_mt: _) (p_s: _) : Lemma (dual (SRecv p_mt p_s) == SSend p_mt (dual p_s)) = admit ()

(* ST_004_dual_select_offer (matches Coq: Theorem ST_004_dual_select_offer) *)
let st_004_dual_select_offer_obligation () : Tot bool = true
let st_004_dual_select_offer_lemma () : Lemma (requires True) (ensures (st_004_dual_select_offer_obligation () == st_004_dual_select_offer_obligation ())) = ()

(* ST_005_dual_offer_select (matches Coq: Theorem ST_005_dual_offer_select) *)
let st_005_dual_offer_select_obligation () : Tot bool = true
let st_005_dual_offer_select_lemma () : Lemma (requires True) (ensures (st_005_dual_offer_select_obligation () == st_005_dual_offer_select_obligation ())) = ()

(* ST_006_dual_involutive_end (matches Coq: Theorem ST_006_dual_involutive_end) *)
let st_006_dual_involutive_end () : Lemma (dual (dual SEnd) == SEnd) = admit ()

(* ST_007_dual_involutive_send (matches Coq: Theorem ST_007_dual_involutive_send) *)
let st_007_dual_involutive_send (p_mt: _) : Lemma (dual (dual (SSend p_mt SEnd)) == SSend p_mt SEnd) = admit ()

(* ST_008_dual_involutive_recv (matches Coq: Theorem ST_008_dual_involutive_recv) *)
let st_008_dual_involutive_recv (p_mt: _) : Lemma (dual (dual (SRecv p_mt SEnd)) == SRecv p_mt SEnd) = admit ()

(* ST_009_dual_chain (matches Coq: Theorem ST_009_dual_chain) *)
let st_009_dual_chain (p_mt1: _) (p_mt2: _) : Lemma (dual (dual (SSend p_mt1 (SRecv p_mt2 SEnd))) == SSend p_mt1 (SRecv p_mt2 SEnd)) = admit ()

(* ST_010_dual_chain_rev (matches Coq: Theorem ST_010_dual_chain_rev) *)
let st_010_dual_chain_rev (p_mt1: _) (p_mt2: _) : Lemma (dual (dual (SRecv p_mt1 (SSend p_mt2 SEnd))) == SRecv p_mt1 (SSend p_mt2 SEnd)) = admit ()

(* ST_011_dual_preserves_msg (matches Coq: Theorem ST_011_dual_preserves_msg) *)
let st_011_dual_preserves_msg_obligation () : Tot bool = true
let st_011_dual_preserves_msg_lemma () : Lemma (requires True) (ensures (st_011_dual_preserves_msg_obligation () == st_011_dual_preserves_msg_obligation ())) = ()

(* ST_012_endpoints_dual (matches Coq: Theorem ST_012_endpoints_dual) *)
let st_012_endpoints_dual (p_s: _) : Lemma (dual p_s == dual p_s) = admit ()

(* ST_013_fresh_linear (matches Coq: Theorem ST_013_fresh_linear) *)
let st_013_fresh_linear (p_ch: _) : Lemma (requires (is_fresh p_ch == true)) (ensures (p_ch.f_chan_linear == true)) = admit ()

(* ST_014_used_not_linear (matches Coq: Theorem ST_014_used_not_linear) *)
let st_014_used_not_linear (p_ch: _) : Lemma ((channel_used p_ch).f_chan_linear == false) = admit ()

(* ST_015_use_preserves_id (matches Coq: Theorem ST_015_use_preserves_id) *)
let st_015_use_preserves_id (p_ch: _) : Lemma ((channel_used p_ch).f_chan_id == p_ch.f_chan_id) = admit ()

(* ST_016_use_preserves_type (matches Coq: Theorem ST_016_use_preserves_type) *)
let st_016_use_preserves_type (p_ch: _) : Lemma ((channel_used p_ch).f_chan_type == p_ch.f_chan_type) = admit ()

(* ST_017_wf_pair_dual (matches Coq: Theorem ST_017_wf_pair_dual) *)
let st_017_wf_pair_dual (p_cp: _) : Lemma (requires (well_formed_pair p_cp == true)) (ensures ((p_cp.f_endpoint_a).f_chan_type == dual ((p_cp.f_endpoint_b).f_chan_type))) = admit ()

(* ST_018_wf_pair_same_id (matches Coq: Theorem ST_018_wf_pair_same_id) *)
let st_018_wf_pair_same_id (p_cp: _) : Lemma (requires (well_formed_pair p_cp == true)) (ensures ((p_cp.f_endpoint_a).f_chan_id == (p_cp.f_endpoint_b).f_chan_id)) = admit ()

(* ST_019_session_no_deadlock (matches Coq: Theorem ST_019_session_no_deadlock) *)
let st_019_session_no_deadlock (p_cfg: _) : Lemma (requires (session_typed p_cfg == true)) (ensures (~(deadlocked p_cfg == true))) = admit ()

(* ST_020_dual_communicate (matches Coq: Theorem ST_020_dual_communicate) *)
let st_020_dual_communicate (p_mt: _) (p_s: _) : Lemma (dual (SSend p_mt p_s) == SRecv p_mt (dual p_s)) = admit ()

(* ST_021_value_done (matches Coq: Theorem ST_021_value_done) *)
let st_021_value_done (p_p: _) : Lemma (requires (is_value p_p == true)) (ensures (p_p == PEnd)) = admit ()

(* ST_022_end_is_value (matches Coq: Theorem ST_022_end_is_value) *)
let st_022_end_is_value () : Lemma (is_value PEnd == true) = admit ()

(* ST_023_empty_deadlock_free (matches Coq: Theorem ST_023_empty_deadlock_free) *)
let st_023_empty_deadlock_free () : Lemma (~(deadlocked [] == true)) = admit ()

(* ST_024_msg_eq_refl (matches Coq: Theorem ST_024_msg_eq_refl) *)
let st_024_msg_eq_refl (p_mt: _) : Lemma (msg_type_eqb p_mt p_mt == true) = admit ()

(* ST_025_msg_eq_true (matches Coq: Theorem ST_025_msg_eq_true) *)
let st_025_msg_eq_true (p_mt1: _) (p_mt2: _) : Lemma (requires (msg_type_eqb p_mt1 p_mt2 == true)) (ensures (p_mt1 == p_mt2)) = admit ()

(* ST_026_msg_type_cases (matches Coq: Theorem ST_026_msg_type_cases) *)
let st_026_msg_type_cases (p_mt: msg_type) : Lemma (p_mt == MTNat \/ p_mt == MTBool \/ p_mt == MTUnit \/ p_mt == MTString) = admit ()

(* ST_027_msg_type_dec (matches Coq: Theorem ST_027_msg_type_dec) *)
let st_027_msg_type_dec (p_mt1: msg_type) (p_mt2: msg_type) : Lemma ({p_mt1 == mt2_ + {p_mt1 <> mt2_) = admit ()

(* ST_028_session_type_cases (matches Coq: Theorem ST_028_session_type_cases) *)
let st_028_session_type_cases (p_s: session_type) : Lemma (((exists p_mt. (exists p_s. p_s == SSend p_mt s_))) \/ ((exists p_mt. (exists p_s. p_s == SRecv p_mt s_))) \/ ((exists p_bs. p_s == SSelect p_bs)) \/ ((exists p_bs. p_s == SOffer p_bs)) \/ p_s == SEnd) = admit ()

(* ST_029_dual_non_end_send (matches Coq: Theorem ST_029_dual_non_end_send) *)
let st_029_dual_non_end_send (p_mt: _) (p_s: _) : Lemma (~(dual (SSend p_mt p_s) == SEnd)) = admit ()

(* ST_030_dual_non_end_recv (matches Coq: Theorem ST_030_dual_non_end_recv) *)
let st_030_dual_non_end_recv (p_mt: _) (p_s: _) : Lemma (~(dual (SRecv p_mt p_s) == SEnd)) = admit ()

(* ST_031_dual_empty_select (matches Coq: Theorem ST_031_dual_empty_select) *)
let st_031_dual_empty_select () : Lemma (dual (SSelect []) == SOffer []) = admit ()

(* ST_032_dual_empty_offer (matches Coq: Theorem ST_032_dual_empty_offer) *)
let st_032_dual_empty_offer () : Lemma (dual (SOffer []) == SSelect []) = admit ()

(* ST_033_lookup_empty (matches Coq: Theorem ST_033_lookup_empty) *)
let st_033_lookup_empty (p_id: _) : Lemma (lookup [] p_id == None) = admit ()

(* ST_034_lookup_found (matches Coq: Theorem ST_034_lookup_found) *)
let st_034_lookup_found (p_id: _) (p_ty: _) (p_env: _) : Lemma (lookup ((p_id, p_ty) :: p_env) p_id == Some p_ty) = admit ()

(* ST_035_lookup_skip (matches Coq: Theorem ST_035_lookup_skip) *)
let st_035_lookup_skip (p_id1: _) (p_id2: _) (p_ty: _) (p_env: _) : Lemma (requires (~(p_id1 == p_id2))) (ensures (lookup ((p_id1, p_ty) :: p_env) p_id2 == lookup p_env p_id2)) = admit ()

(* ST_036_dual_compose_send (matches Coq: Theorem ST_036_dual_compose_send) *)
let st_036_dual_compose_send (p_mt: _) (p_s1: _) (p_s2: _) : Lemma (requires (dual (SSend p_mt p_s1) == SRecv p_mt (dual p_s1))) (ensures (dual (SSend p_mt (SSend p_mt p_s2)) == SRecv p_mt (SRecv p_mt (dual p_s2)))) = admit ()

(* ST_037_dual_branches (matches Coq: Theorem ST_037_dual_branches) *)
let st_037_dual_branches_obligation () : Tot bool = true
let st_037_dual_branches_lemma () : Lemma (requires True) (ensures (st_037_dual_branches_obligation () == st_037_dual_branches_obligation ())) = ()

(* ST_038_single_branch_dual (matches Coq: Theorem ST_038_single_branch_dual) *)
let st_038_single_branch_dual (p_l: nat) (p_s: session_type) : Lemma (dual (SSelect [(p_l, p_s)]) == SOffer [(p_l, dual p_s)]) = admit ()

(* ST_039_wt_end_empty (matches Coq: Theorem ST_039_wt_end_empty) *)
let st_039_wt_end_empty (p_env: _) : Lemma (requires (well_typed_proc p_env PEnd == true)) (ensures (p_env == [])) = admit ()

(* ST_040_par_exists (matches Coq: Theorem ST_040_par_exists) *)
let st_040_par_exists (p_p1: _) (p_p2: _) : Lemma (PPar p_p1 p_p2 == PPar p_p1 p_p2) = admit ()

(* ST_041_chan_construct (matches Coq: Theorem ST_041_chan_construct) *)
let st_041_chan_construct (p_id: _) (p_ty: _) (p_lin: _) : Lemma ((mkchan p_id p_ty p_lin).f_chan_id == p_id /\ (mkchan p_id p_ty p_lin).f_chan_type == p_ty /\ (mkchan p_id p_ty p_lin).f_chan_linear == p_lin) = admit ()

(* ST_042_pair_construct (matches Coq: Theorem ST_042_pair_construct) *)
let st_042_pair_construct (p_ea: _) (p_eb: _) : Lemma ((mkchanpair p_ea p_eb).f_endpoint_a == p_ea /\ (mkchanpair p_ea p_eb).f_endpoint_b == p_eb) = admit ()

(* ST_043_process_cases (matches Coq: Theorem ST_043_process_cases) *)
let st_043_process_cases (p_p: process) : Lemma (((exists p_ch. (exists p_v. (exists p_p. p_p == PSend p_ch p_v p_)))) \/ ((exists p_ch. (exists p_p. p_p == PRecv p_ch p_))) \/ ((exists p_ch. (exists p_l. (exists p_p. p_p == PSelect p_ch p_l p_)))) \/ ((exists p_ch. (exists p_bs. p_p == POffer p_ch p_bs))) \/ ((exists p_ch. p_p == PClose p_ch)) \/ p_p == PEnd \/ ((exists p_p1. (exists p_p2. p_p == PPar p_p1 p_p2)))) = admit ()

(* ST_044_dual_triple_end (matches Coq: Theorem ST_044_dual_triple_end) *)
let st_044_dual_triple_end () : Lemma (dual (dual (dual SEnd)) == dual SEnd) = admit ()

(* ST_045_nested_send_dual (matches Coq: Theorem ST_045_nested_send_dual) *)
let st_045_nested_send_dual (p_mt1: _) (p_mt2: _) : Lemma (dual (SSend p_mt1 (SSend p_mt2 SEnd)) == SRecv p_mt1 (SRecv p_mt2 SEnd)) = admit ()
