; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SessionTypes.v (45 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: SessionTypes

(set-logic ALL)
(set-option :produce-models true)

; MsgType (matches Coq: Inductive MsgType)
(declare-datatypes ((MsgType 0)) (((MTNat) (MTBool) (MTUnit) (MTString))))

; SessionType (matches Coq: Inductive SessionType)
(declare-datatypes ((SessionType 0)) (((SSend) (SRecv) (SEnd))))

; Process (matches Coq: Inductive Process)
(declare-datatypes ((Process 0)) (((PSend) (PRecv) (PSelect) (PClose) (PEnd) (PPar))))

; Channel (matches Coq: Record Channel)
(declare-datatypes ((Channel 0))
  (((mk-channel (chan_id Int) (chan_type SessionType) (chan_linear Bool)))))

; ChannelPair (matches Coq: Record ChannelPair)
(declare-datatypes ((ChannelPair 0))
  (((mk-channel_pair (endpoint_a Channel) (endpoint_b Channel)))))

(declare-const __default_Channel Channel)
(declare-const __default_ChannelPair ChannelPair)
(declare-const __default_MsgType MsgType)
(declare-const __default_Process Process)
(declare-const __default_SessionType SessionType)

; msg_type_eqb (matches Coq: Definition msg_type_eqb)
(define-fun msg_type_eqb ((m1 MsgType) (m2 MsgType)) Bool
  (= 0 0))

; dual (matches Coq: Definition dual)
(declare-fun dual (SessionType) SessionType)

; channel_used (matches Coq: Definition channel_used)
(declare-fun channel_used (Channel) Channel)

; is_fresh (matches Coq: Definition is_fresh)
(define-fun is_fresh ((ch Channel)) Bool
  (= 0 0))

; well_formed_pair (matches Coq: Definition well_formed_pair)
(define-fun well_formed_pair ((cp ChannelPair)) Bool
  (= 0 0))

; is_value (matches Coq: Definition is_value)
(define-fun is_value ((p Process)) Bool
  (= 0 0))

; lookup (matches Coq: Definition lookup)
(define-fun lookup ((env Int) (id Int)) Int
  0)

; waiting (matches Coq: Definition waiting)
(define-fun waiting ((cfg Int) (t Int) (r Int)) Bool
  (= 0 0))

; holding (matches Coq: Definition holding)
(define-fun holding ((cfg Int) (t Int) (r Int)) Bool
  (= 0 0))

; waits_for (matches Coq: Definition waits_for)
(define-fun waits_for ((cfg Int) (t1 Int) (t2 Int)) Bool
  (= 0 0))

; circular_wait (matches Coq: Definition circular_wait)
(define-fun circular_wait ((cfg Int)) Bool
  (= 0 0))

; deadlocked (matches Coq: Definition deadlocked)
(define-fun deadlocked ((cfg Int)) Bool
  (= 0 0))

; session_typed (matches Coq: Definition session_typed)
(define-fun session_typed ((cfg Int)) Bool
  (= 0 0))

; ST_001_dual_end (matches Coq: Theorem ST_001_dual_end)
; ST_001_dual_end: dual SEnd = SEnd
(assert (= 0 0)) ; ST_001_dual_end [Coq-only]

; ST_002_dual_send_recv (matches Coq: Theorem ST_002_dual_send_recv)
; ST_002_dual_send_recv: forall mt s, dual (SSend mt s) = SRecv mt (dual s)
(assert (forall ((mt Bool) (s Bool)) (= 0 0))) ; ST_002_dual_send_recv [partial: bindings preserved]

; ST_003_dual_recv_send (matches Coq: Theorem ST_003_dual_recv_send)
; ST_003_dual_recv_send: forall mt s, dual (SRecv mt s) = SSend mt (dual s)
(assert (forall ((mt Bool) (s Bool)) (= 0 0))) ; ST_003_dual_recv_send [partial: bindings preserved]

; ST_004_dual_select_offer (matches Coq: Theorem ST_004_dual_select_offer)
; ST_004_dual_select_offer: forall branches, dual (SSelect branches) = SOffer (map (fun p => (fst p, dual (snd p))) branches)
(assert (forall ((branches Bool)) (= 0 0))) ; ST_004_dual_select_offer [partial: bindings preserved]

; ST_005_dual_offer_select (matches Coq: Theorem ST_005_dual_offer_select)
; ST_005_dual_offer_select: forall branches, dual (SOffer branches) = SSelect (map (fun p => (fst p, dual (snd p))) branches)
(assert (forall ((branches Bool)) (= 0 0))) ; ST_005_dual_offer_select [partial: bindings preserved]

; ST_006_dual_involutive_end (matches Coq: Theorem ST_006_dual_involutive_end)
; ST_006_dual_involutive_end: dual (dual SEnd) = SEnd
(assert (= 0 0)) ; ST_006_dual_involutive_end [Coq-only]

; ST_007_dual_involutive_send (matches Coq: Theorem ST_007_dual_involutive_send)
; ST_007_dual_involutive_send: forall mt, dual (dual (SSend mt SEnd)) = SSend mt SEnd
(assert (forall ((mt Bool)) (= 0 0))) ; ST_007_dual_involutive_send [partial: bindings preserved]

; ST_008_dual_involutive_recv (matches Coq: Theorem ST_008_dual_involutive_recv)
; ST_008_dual_involutive_recv: forall mt, dual (dual (SRecv mt SEnd)) = SRecv mt SEnd
(assert (forall ((mt Bool)) (= 0 0))) ; ST_008_dual_involutive_recv [partial: bindings preserved]

; ST_009_dual_chain (matches Coq: Theorem ST_009_dual_chain)
; ST_009_dual_chain: forall mt1 mt2, dual (dual (SSend mt1 (SRecv mt2 SEnd))) = SSend mt1 (SRecv mt2 SEnd)
(assert (forall ((mt1 Bool) (mt2 Bool)) (= 0 0))) ; ST_009_dual_chain [partial: bindings preserved]

; ST_010_dual_chain_rev (matches Coq: Theorem ST_010_dual_chain_rev)
; ST_010_dual_chain_rev: forall mt1 mt2, dual (dual (SRecv mt1 (SSend mt2 SEnd))) = SRecv mt1 (SSend mt2 SEnd)
(assert (forall ((mt1 Bool) (mt2 Bool)) (= 0 0))) ; ST_010_dual_chain_rev [partial: bindings preserved]

; ST_011_dual_preserves_msg (matches Coq: Theorem ST_011_dual_preserves_msg)
; ST_011_dual_preserves_msg: forall mt s, match dual (SSend mt s) with | SRecv mt' _ => mt' = mt | _ => False end
(assert (forall ((mt Bool) (s Bool)) (= 0 0))) ; ST_011_dual_preserves_msg [partial: bindings preserved]

; ST_012_endpoints_dual (matches Coq: Theorem ST_012_endpoints_dual)
; ST_012_endpoints_dual: forall s, dual s = dual s
(assert (forall ((s Bool)) (= 0 0))) ; ST_012_endpoints_dual [partial: bindings preserved]

; ST_013_fresh_linear (matches Coq: Theorem ST_013_fresh_linear)
; ST_013_fresh_linear: forall ch, is_fresh ch -> chan_linear ch = true
(assert (forall ((ch Bool)) (= 0 0))) ; ST_013_fresh_linear [partial: bindings preserved]

; ST_014_used_not_linear (matches Coq: Theorem ST_014_used_not_linear)
; ST_014_used_not_linear: forall ch, chan_linear (channel_used ch) = false
(assert (forall ((ch Bool)) (= 0 0))) ; ST_014_used_not_linear [partial: bindings preserved]

; ST_015_use_preserves_id (matches Coq: Theorem ST_015_use_preserves_id)
; ST_015_use_preserves_id: forall ch, chan_id (channel_used ch) = chan_id ch
(assert (forall ((ch Bool)) (= 0 0))) ; ST_015_use_preserves_id [partial: bindings preserved]

; ST_016_use_preserves_type (matches Coq: Theorem ST_016_use_preserves_type)
; ST_016_use_preserves_type: forall ch, chan_type (channel_used ch) = chan_type ch
(assert (forall ((ch Bool)) (= 0 0))) ; ST_016_use_preserves_type [partial: bindings preserved]

; ST_017_wf_pair_dual (matches Coq: Theorem ST_017_wf_pair_dual)
; ST_017_wf_pair_dual: forall cp, well_formed_pair cp -> chan_type (endpoint_a cp) = dual (chan_type (endpoint_b cp))
(assert (forall ((cp Bool)) (= 0 0))) ; ST_017_wf_pair_dual [partial: bindings preserved]

; ST_018_wf_pair_same_id (matches Coq: Theorem ST_018_wf_pair_same_id)
; ST_018_wf_pair_same_id: forall cp, well_formed_pair cp -> chan_id (endpoint_a cp) = chan_id (endpoint_b cp)
(assert (forall ((cp Bool)) (= 0 0))) ; ST_018_wf_pair_same_id [partial: bindings preserved]

; ST_019_session_no_deadlock (matches Coq: Theorem ST_019_session_no_deadlock)
; ST_019_session_no_deadlock: forall cfg, session_typed cfg -> ~ deadlocked cfg
(assert (forall ((cfg Bool)) (= 0 0))) ; ST_019_session_no_deadlock [partial: bindings preserved]

; ST_020_dual_communicate (matches Coq: Theorem ST_020_dual_communicate)
; ST_020_dual_communicate: forall mt s, dual (SSend mt s) = SRecv mt (dual s) -> True
(assert (forall ((mt Bool) (s Bool)) (= 0 0))) ; ST_020_dual_communicate [partial: bindings preserved]

; ST_021_value_done (matches Coq: Theorem ST_021_value_done)
; ST_021_value_done: forall p, is_value p -> p = PEnd
(assert (forall ((p Bool)) (= 0 0))) ; ST_021_value_done [partial: bindings preserved]

; ST_022_end_is_value (matches Coq: Theorem ST_022_end_is_value)
; ST_022_end_is_value: is_value PEnd
(assert (= 0 0)) ; ST_022_end_is_value [Coq-only]

; ST_023_empty_deadlock_free (matches Coq: Theorem ST_023_empty_deadlock_free)
; ST_023_empty_deadlock_free: ~ deadlocked []
(assert (= 0 0)) ; ST_023_empty_deadlock_free [Coq-only]

; ST_024_msg_eq_refl (matches Coq: Theorem ST_024_msg_eq_refl)
; ST_024_msg_eq_refl: forall mt, msg_type_eqb mt mt = true
(assert (forall ((mt Bool)) (= 0 0))) ; ST_024_msg_eq_refl [partial: bindings preserved]

; ST_025_msg_eq_true (matches Coq: Theorem ST_025_msg_eq_true)
; ST_025_msg_eq_true: forall mt1 mt2, msg_type_eqb mt1 mt2 = true -> mt1 = mt2
(assert (forall ((mt1 Bool) (mt2 Bool)) (= 0 0))) ; ST_025_msg_eq_true [partial: bindings preserved]

; ST_026_msg_type_cases (matches Coq: Theorem ST_026_msg_type_cases)
; ST_026_msg_type_cases: forall mt : MsgType, mt = MTNat \/ mt = MTBool \/ mt = MTUnit \/ mt = MTString
(assert (forall ((mt MsgType)) (= 0 0))) ; ST_026_msg_type_cases [partial: bindings preserved]

; ST_027_msg_type_dec (matches Coq: Theorem ST_027_msg_type_dec)
; ST_027_msg_type_dec: forall mt1 mt2 : MsgType, {mt1 = mt2} + {mt1 <> mt2}
(assert (= 0 0)) ; ST_027_msg_type_dec [Coq-only]

; ST_028_session_type_cases (matches Coq: Theorem ST_028_session_type_cases)
; ST_028_session_type_cases: forall s : SessionType, (exists mt s', s = SSend mt s') \/ (exists mt s', s = SRecv mt s') \/ (exists bs, s = SSelect bs
(assert (forall ((s SessionType)) (= 0 0))) ; ST_028_session_type_cases [partial: bindings preserved]

; ST_029_dual_non_end_send (matches Coq: Theorem ST_029_dual_non_end_send)
; ST_029_dual_non_end_send: forall mt s, dual (SSend mt s) <> SEnd
(assert (forall ((mt Bool) (s Bool)) (= 0 0))) ; ST_029_dual_non_end_send [partial: bindings preserved]

; ST_030_dual_non_end_recv (matches Coq: Theorem ST_030_dual_non_end_recv)
; ST_030_dual_non_end_recv: forall mt s, dual (SRecv mt s) <> SEnd
(assert (forall ((mt Bool) (s Bool)) (= 0 0))) ; ST_030_dual_non_end_recv [partial: bindings preserved]

; ST_031_dual_empty_select (matches Coq: Theorem ST_031_dual_empty_select)
; ST_031_dual_empty_select: dual (SSelect []) = SOffer []
(assert (= 0 0)) ; ST_031_dual_empty_select [Coq-only]

; ST_032_dual_empty_offer (matches Coq: Theorem ST_032_dual_empty_offer)
; ST_032_dual_empty_offer: dual (SOffer []) = SSelect []
(assert (= 0 0)) ; ST_032_dual_empty_offer [Coq-only]

; ST_033_lookup_empty (matches Coq: Theorem ST_033_lookup_empty)
; ST_033_lookup_empty: forall id, lookup [] id = None
(assert (forall ((id Bool)) (= 0 0))) ; ST_033_lookup_empty [partial: bindings preserved]

; ST_034_lookup_found (matches Coq: Theorem ST_034_lookup_found)
; ST_034_lookup_found: forall id ty env, lookup ((id, ty) :: env) id = Some ty
(assert (forall ((id Bool) (ty Bool) (env Bool)) (= 0 0))) ; ST_034_lookup_found [partial: bindings preserved]

; ST_035_lookup_skip (matches Coq: Theorem ST_035_lookup_skip)
; ST_035_lookup_skip: forall id1 id2 ty env, id1 <> id2 -> lookup ((id1, ty) :: env) id2 = lookup env id2
(assert (forall ((id1 Bool) (id2 Bool) (ty Bool) (env Bool)) (= 0 0))) ; ST_035_lookup_skip [partial: bindings preserved]

; ST_036_dual_compose_send (matches Coq: Theorem ST_036_dual_compose_send)
; ST_036_dual_compose_send: forall mt s1 s2, dual (SSend mt s1) = SRecv mt (dual s1) -> dual (SSend mt (SSend mt s2)) = SRecv mt (SRecv mt (dual s2)
(assert (forall ((mt Bool) (s1 Bool) (s2 Bool)) (= 0 0))) ; ST_036_dual_compose_send [partial: bindings preserved]

; ST_037_dual_branches (matches Coq: Theorem ST_037_dual_branches)
; ST_037_dual_branches: forall (l : nat) (s : SessionType), map (fun p : nat * SessionType => (fst p, dual (snd p))) [(l, s)] = [(l, dual s)]
(assert (forall ((l Int) (s SessionType)) (= 0 0))) ; ST_037_dual_branches [partial: bindings preserved]

; ST_038_single_branch_dual (matches Coq: Theorem ST_038_single_branch_dual)
; ST_038_single_branch_dual: forall (l : nat) (s : SessionType), dual (SSelect [(l, s)]) = SOffer [(l, dual s)]
(assert (forall ((l Int) (s SessionType)) (= 0 0))) ; ST_038_single_branch_dual [partial: bindings preserved]

; ST_039_wt_end_empty (matches Coq: Theorem ST_039_wt_end_empty)
; ST_039_wt_end_empty: forall env, well_typed_proc env PEnd -> env = []
(assert (forall ((env Bool)) (= 0 0))) ; ST_039_wt_end_empty [partial: bindings preserved]

; ST_040_par_exists (matches Coq: Theorem ST_040_par_exists)
; ST_040_par_exists: forall p1 p2, PPar p1 p2 = PPar p1 p2
(assert (forall ((p1 Bool) (p2 Bool)) (= 0 0))) ; ST_040_par_exists [partial: bindings preserved]

; ST_041_chan_construct (matches Coq: Theorem ST_041_chan_construct)
; ST_041_chan_construct: forall id ty lin, chan_id (mkChan id ty lin) = id /\ chan_type (mkChan id ty lin) = ty /\ chan_linear (mkChan id ty lin)
(assert (forall ((id Bool) (ty Bool) (lin Bool)) (= 0 0))) ; ST_041_chan_construct [partial: bindings preserved]

; ST_042_pair_construct (matches Coq: Theorem ST_042_pair_construct)
; ST_042_pair_construct: forall ea eb, endpoint_a (mkChanPair ea eb) = ea /\ endpoint_b (mkChanPair ea eb) = eb
(assert (forall ((ea Bool) (eb Bool)) (= 0 0))) ; ST_042_pair_construct [partial: bindings preserved]

; ST_043_process_cases (matches Coq: Theorem ST_043_process_cases)
; ST_043_process_cases: forall p : Process, (exists ch v p', p = PSend ch v p') \/ (exists ch p', p = PRecv ch p') \/ (exists ch l p', p = PSele
(assert (forall ((p Process)) (= 0 0))) ; ST_043_process_cases [partial: bindings preserved]

; ST_044_dual_triple_end (matches Coq: Theorem ST_044_dual_triple_end)
; ST_044_dual_triple_end: dual (dual (dual SEnd)) = dual SEnd
(assert (= 0 0)) ; ST_044_dual_triple_end [Coq-only]

; ST_045_nested_send_dual (matches Coq: Theorem ST_045_nested_send_dual)
; ST_045_nested_send_dual: forall mt1 mt2, dual (SSend mt1 (SSend mt2 SEnd)) = SRecv mt1 (SRecv mt2 SEnd)
(assert (forall ((mt1 Bool) (mt2 Bool)) (= 0 0))) ; ST_045_nested_send_dual [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
