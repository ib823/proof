; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ChoreographyTypes.v (150 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ChoreographyTypes

(set-logic ALL)
(set-option :produce-models true)

; MsgPayload (matches Coq: Inductive MsgPayload)
(declare-datatypes ((MsgPayload 0)) (((PayNat) (PayBool) (PayUnit) (PayString))))

; GlobalType (matches Coq: Inductive GlobalType)
(declare-datatypes ((GlobalType 0)) (((GEnd) (GVar) (GRec) (GMsg) (GBranch))))

; LocalType (matches Coq: Inductive LocalType)
(declare-datatypes ((LocalType 0)) (((LEnd) (LVar) (LRec) (LSend) (LRecv) (LSelect) (LOffer))))

(declare-const __default_GlobalType GlobalType)
(declare-const __default_LocalType LocalType)
(declare-const __default_MsgPayload MsgPayload)

; payload_eqb (matches Coq: Definition payload_eqb)
(define-fun payload_eqb ((p1 MsgPayload) (p2 MsgPayload)) Bool
  (= 0 0))

; role_eqb (matches Coq: Definition role_eqb)
(define-fun role_eqb ((r1 Int) (r2 Int)) Bool
  (= 0 0))

; global_size (matches Coq: Definition global_size)
(define-fun global_size ((g GlobalType)) Int
  0)

; local_size (matches Coq: Definition local_size)
(define-fun local_size ((l LocalType)) Int
  0)

; local_dual (matches Coq: Definition local_dual)
(declare-fun local_dual (LocalType) LocalType)

; project (matches Coq: Definition project)
(declare-fun project (GlobalType Int) LocalType)

; well_formed_global (matches Coq: Definition well_formed_global)
(define-fun well_formed_global ((g GlobalType)) Bool
  (= 0 0))

; well_formed_globalb (matches Coq: Definition well_formed_globalb)
(define-fun well_formed_globalb ((g GlobalType)) Bool
  (= 0 0))

; roles_of (matches Coq: Definition roles_of)
(define-fun roles_of ((g GlobalType)) (Seq Int)
  (as seq.empty (Seq Int)))

; interaction_dual (matches Coq: Definition interaction_dual)
(define-fun interaction_dual ((l1 LocalType) (l2 LocalType)) Bool
  (= 0 0))

; network_of (matches Coq: Definition network_of)
(define-fun network_of ((g GlobalType) (roles (Seq Int))) Int
  0)

; chor_waiting (matches Coq: Definition chor_waiting)
(define-fun chor_waiting ((net Int) (r1 Int) (r2 Int)) Bool
  (= 0 0))

; chor_circular_wait (matches Coq: Definition chor_circular_wait)
(define-fun chor_circular_wait ((net Int)) Bool
  (= 0 0))

; chor_deadlocked (matches Coq: Definition chor_deadlocked)
(define-fun chor_deadlocked ((net Int)) Bool
  (= 0 0))

; well_typed_network (matches Coq: Definition well_typed_network)
(define-fun well_typed_network ((net Int)) Bool
  (= 0 0))

; net_lookup (matches Coq: Definition net_lookup)
(define-fun net_lookup ((net Int) (r Int)) Int
  0)

; can_communicate (matches Coq: Definition can_communicate)
(define-fun can_communicate ((l1 LocalType) (l2 LocalType)) Bool
  (= 0 0))

; example_request_response (matches Coq: Definition example_request_response)
(define-fun example_request_response () GlobalType
  __default_GlobalType)

; example_delegation (matches Coq: Definition example_delegation)
(define-fun example_delegation () GlobalType
  __default_GlobalType)

; example_choice (matches Coq: Definition example_choice)
(define-fun example_choice () GlobalType
  __default_GlobalType)

; example_recursive (matches Coq: Definition example_recursive)
(define-fun example_recursive () GlobalType
  __default_GlobalType)

; CT_001_andb_true_iff (matches Coq: Lemma CT_001_andb_true_iff)
; CT_001_andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; CT_001_andb_true_iff [Coq-only]

; CT_002_negb_true_iff (matches Coq: Lemma CT_002_negb_true_iff)
; CT_002_negb_true_iff: forall b : bool, negb b = true <-> b = false
(assert (forall ((b Bool)) (= 0 0))) ; CT_002_negb_true_iff [partial: bindings preserved]

; CT_003_orb_true_iff (matches Coq: Lemma CT_003_orb_true_iff)
; CT_003_orb_true_iff: forall a b : bool, a || b = true <-> a = true \/ b = true
(assert (= 0 0)) ; CT_003_orb_true_iff [Coq-only]

; CT_004_nat_eqb_refl (matches Coq: Lemma CT_004_nat_eqb_refl)
; CT_004_nat_eqb_refl: forall n : nat, Nat.eqb n n = true
(assert (forall ((n Int)) (= 0 0))) ; CT_004_nat_eqb_refl [partial: bindings preserved]

; CT_005_nat_eqb_eq (matches Coq: Lemma CT_005_nat_eqb_eq)
; CT_005_nat_eqb_eq: forall n m : nat, Nat.eqb n m = true -> n = m
(assert (= 0 0)) ; CT_005_nat_eqb_eq [Coq-only]

; CT_006_nat_eqb_neq (matches Coq: Lemma CT_006_nat_eqb_neq)
; CT_006_nat_eqb_neq: forall n m : nat, Nat.eqb n m = false -> n <> m
(assert (= 0 0)) ; CT_006_nat_eqb_neq [Coq-only]

; CT_007_nat_eqb_sym (matches Coq: Lemma CT_007_nat_eqb_sym)
; CT_007_nat_eqb_sym: forall n m : nat, Nat.eqb n m = Nat.eqb m n
(assert (= 0 0)) ; CT_007_nat_eqb_sym [Coq-only]

; CT_008_nat_eq_dec (matches Coq: Lemma CT_008_nat_eq_dec)
; CT_008_nat_eq_dec: forall n m : nat, {n = m} + {n <> m}
(assert (= 0 0)) ; CT_008_nat_eq_dec [Coq-only]

; CT_009_payload_eqb_refl (matches Coq: Lemma CT_009_payload_eqb_refl)
; CT_009_payload_eqb_refl: forall p, payload_eqb p p = true
(assert (forall ((p Bool)) (= 0 0))) ; CT_009_payload_eqb_refl [partial: bindings preserved]

; CT_010_payload_eqb_eq (matches Coq: Lemma CT_010_payload_eqb_eq)
; CT_010_payload_eqb_eq: forall p1 p2, payload_eqb p1 p2 = true -> p1 = p2
(assert (forall ((p1 Bool) (p2 Bool)) (= 0 0))) ; CT_010_payload_eqb_eq [partial: bindings preserved]

; CT_011_payload_eqb_neq (matches Coq: Lemma CT_011_payload_eqb_neq)
; CT_011_payload_eqb_neq: forall p1 p2, payload_eqb p1 p2 = false -> p1 <> p2
(assert (forall ((p1 Bool) (p2 Bool)) (= 0 0))) ; CT_011_payload_eqb_neq [partial: bindings preserved]

; CT_012_payload_eq_dec (matches Coq: Lemma CT_012_payload_eq_dec)
; CT_012_payload_eq_dec: forall p1 p2 : MsgPayload, {p1 = p2} + {p1 <> p2}
(assert (= 0 0)) ; CT_012_payload_eq_dec [Coq-only]

; CT_013_payload_cases (matches Coq: Lemma CT_013_payload_cases)
; CT_013_payload_cases: forall p : MsgPayload, p = PayNat \/ p = PayBool \/ p = PayUnit \/ p = PayString
(assert (forall ((p MsgPayload)) (= 0 0))) ; CT_013_payload_cases [partial: bindings preserved]

; CT_014_payload_eqb_sym (matches Coq: Lemma CT_014_payload_eqb_sym)
; CT_014_payload_eqb_sym: forall p1 p2, payload_eqb p1 p2 = payload_eqb p2 p1
(assert (forall ((p1 Bool) (p2 Bool)) (= 0 0))) ; CT_014_payload_eqb_sym [partial: bindings preserved]

; CT_015_role_eqb_refl (matches Coq: Lemma CT_015_role_eqb_refl)
; CT_015_role_eqb_refl: forall r : Role, role_eqb r r = true
(assert (forall ((r Int)) (= 0 0))) ; CT_015_role_eqb_refl [partial: bindings preserved]

; CT_016_role_eqb_eq (matches Coq: Lemma CT_016_role_eqb_eq)
; CT_016_role_eqb_eq: forall r1 r2 : Role, role_eqb r1 r2 = true -> r1 = r2
(assert (= 0 0)) ; CT_016_role_eqb_eq [Coq-only]

; CT_017_role_eqb_neq (matches Coq: Lemma CT_017_role_eqb_neq)
; CT_017_role_eqb_neq: forall r1 r2 : Role, role_eqb r1 r2 = false -> r1 <> r2
(assert (= 0 0)) ; CT_017_role_eqb_neq [Coq-only]

; CT_018_role_eq_dec (matches Coq: Lemma CT_018_role_eq_dec)
; CT_018_role_eq_dec: forall r1 r2 : Role, {r1 = r2} + {r1 <> r2}
(assert (= 0 0)) ; CT_018_role_eq_dec [Coq-only]

; CT_019_role_eqb_sym (matches Coq: Lemma CT_019_role_eqb_sym)
; CT_019_role_eqb_sym: forall r1 r2 : Role, role_eqb r1 r2 = role_eqb r2 r1
(assert (= 0 0)) ; CT_019_role_eqb_sym [Coq-only]

; CT_020_role_neq_sym (matches Coq: Lemma CT_020_role_neq_sym)
; CT_020_role_neq_sym: forall r1 r2 : Role, r1 <> r2 -> r2 <> r1
(assert (= 0 0)) ; CT_020_role_neq_sym [Coq-only]

; CT_021_global_type_cases (matches Coq: Lemma CT_021_global_type_cases)
; CT_021_global_type_cases: forall g : GlobalType, g = GEnd \/ (exists n, g = GVar n) \/ (exists n g', g = GRec n g') \/ (exists p q t g', g = GMsg 
(assert (forall ((g GlobalType)) (= 0 0))) ; CT_021_global_type_cases [partial: bindings preserved]

; CT_022_gend_ne_gmsg (matches Coq: Lemma CT_022_gend_ne_gmsg)
; CT_022_gend_ne_gmsg: forall p q t g, GEnd <> GMsg p q t g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_022_gend_ne_gmsg [partial: bindings preserved]

; CT_023_gend_ne_gbranch (matches Coq: Lemma CT_023_gend_ne_gbranch)
; CT_023_gend_ne_gbranch: forall p q l1 g1 l2 g2, GEnd <> GBranch p q l1 g1 l2 g2
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_023_gend_ne_gbranch [partial: bindings preserved]

; CT_024_gend_ne_grec (matches Coq: Lemma CT_024_gend_ne_grec)
; CT_024_gend_ne_grec: forall n g, GEnd <> GRec n g
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CT_024_gend_ne_grec [partial: bindings preserved]

; CT_025_gend_ne_gvar (matches Coq: Lemma CT_025_gend_ne_gvar)
; CT_025_gend_ne_gvar: forall n, GEnd <> GVar n
(assert (forall ((n Bool)) (= 0 0))) ; CT_025_gend_ne_gvar [partial: bindings preserved]

; CT_026_gmsg_inj (matches Coq: Lemma CT_026_gmsg_inj)
; CT_026_gmsg_inj: forall p1 q1 t1 g1 p2 q2 t2 g2, GMsg p1 q1 t1 g1 = GMsg p2 q2 t2 g2 -> p1 = p2 /\ q1 = q2 /\ t1 = t2 /\ g1 = g2
(assert (forall ((p1 Bool) (q1 Bool) (t1 Bool) (g1 Bool) (p2 Bool) (q2 Bool) (t2 Bool) (g2 Bool)) (= 0 0))) ; CT_026_gmsg_inj [partial: bindings preserved]

; CT_027_gbranch_inj (matches Coq: Lemma CT_027_gbranch_inj)
; CT_027_gbranch_inj: forall p1 q1 l1a g1a l1b g1b p2 q2 l2a g2a l2b g2b, GBranch p1 q1 l1a g1a l1b g1b = GBranch p2 q2 l2a g2a l2b g2b -> p1 
(assert (forall ((p1 Bool) (q1 Bool) (l1a Bool) (g1a Bool) (l1b Bool) (g1b Bool) (p2 Bool) (q2 Bool) (l2a Bool) (g2a Bool) (l2b Bool) (g2b Bool)) (= 0 0))) ; CT_027_gbranch_inj [partial: bindings preserved]

; CT_028_grec_inj (matches Coq: Lemma CT_028_grec_inj)
; CT_028_grec_inj: forall n1 g1 n2 g2, GRec n1 g1 = GRec n2 g2 -> n1 = n2 /\ g1 = g2
(assert (forall ((n1 Bool) (g1 Bool) (n2 Bool) (g2 Bool)) (= 0 0))) ; CT_028_grec_inj [partial: bindings preserved]

; CT_029_gvar_inj (matches Coq: Lemma CT_029_gvar_inj)
; CT_029_gvar_inj: forall n1 n2, GVar n1 = GVar n2 -> n1 = n2
(assert (forall ((n1 Bool) (n2 Bool)) (= 0 0))) ; CT_029_gvar_inj [partial: bindings preserved]

; CT_030_gmsg_ne_gbranch (matches Coq: Lemma CT_030_gmsg_ne_gbranch)
; CT_030_gmsg_ne_gbranch: forall p1 q1 t g p2 q2 l1 g1 l2 g2, GMsg p1 q1 t g <> GBranch p2 q2 l1 g1 l2 g2
(assert (forall ((p1 Bool) (q1 Bool) (t Bool) (g Bool) (p2 Bool) (q2 Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_030_gmsg_ne_gbranch [partial: bindings preserved]

; CT_031_local_type_cases (matches Coq: Lemma CT_031_local_type_cases)
; CT_031_local_type_cases: forall l : LocalType, l = LEnd \/ (exists n, l = LVar n) \/ (exists n l', l = LRec n l') \/ (exists r t l', l = LSend r 
(assert (forall ((l LocalType)) (= 0 0))) ; CT_031_local_type_cases [partial: bindings preserved]

; CT_032_lend_ne_lsend (matches Coq: Lemma CT_032_lend_ne_lsend)
; CT_032_lend_ne_lsend: forall r t l, LEnd <> LSend r t l
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_032_lend_ne_lsend [partial: bindings preserved]

; CT_033_lend_ne_lrecv (matches Coq: Lemma CT_033_lend_ne_lrecv)
; CT_033_lend_ne_lrecv: forall r t l, LEnd <> LRecv r t l
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_033_lend_ne_lrecv [partial: bindings preserved]

; CT_034_lend_ne_lselect (matches Coq: Lemma CT_034_lend_ne_lselect)
; CT_034_lend_ne_lselect: forall r la l1 lb l2, LEnd <> LSelect r la l1 lb l2
(assert (forall ((r Bool) (la Bool) (l1 Bool) (lb Bool) (l2 Bool)) (= 0 0))) ; CT_034_lend_ne_lselect [partial: bindings preserved]

; CT_035_lend_ne_loffer (matches Coq: Lemma CT_035_lend_ne_loffer)
; CT_035_lend_ne_loffer: forall r la l1 lb l2, LEnd <> LOffer r la l1 lb l2
(assert (forall ((r Bool) (la Bool) (l1 Bool) (lb Bool) (l2 Bool)) (= 0 0))) ; CT_035_lend_ne_loffer [partial: bindings preserved]

; CT_036_lend_ne_lrec (matches Coq: Lemma CT_036_lend_ne_lrec)
; CT_036_lend_ne_lrec: forall n l, LEnd <> LRec n l
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; CT_036_lend_ne_lrec [partial: bindings preserved]

; CT_037_lend_ne_lvar (matches Coq: Lemma CT_037_lend_ne_lvar)
; CT_037_lend_ne_lvar: forall n, LEnd <> LVar n
(assert (forall ((n Bool)) (= 0 0))) ; CT_037_lend_ne_lvar [partial: bindings preserved]

; CT_038_lsend_inj (matches Coq: Lemma CT_038_lsend_inj)
; CT_038_lsend_inj: forall r1 t1 l1 r2 t2 l2, LSend r1 t1 l1 = LSend r2 t2 l2 -> r1 = r2 /\ t1 = t2 /\ l1 = l2
(assert (forall ((r1 Bool) (t1 Bool) (l1 Bool) (r2 Bool) (t2 Bool) (l2 Bool)) (= 0 0))) ; CT_038_lsend_inj [partial: bindings preserved]

; CT_039_lrecv_inj (matches Coq: Lemma CT_039_lrecv_inj)
; CT_039_lrecv_inj: forall r1 t1 l1 r2 t2 l2, LRecv r1 t1 l1 = LRecv r2 t2 l2 -> r1 = r2 /\ t1 = t2 /\ l1 = l2
(assert (forall ((r1 Bool) (t1 Bool) (l1 Bool) (r2 Bool) (t2 Bool) (l2 Bool)) (= 0 0))) ; CT_039_lrecv_inj [partial: bindings preserved]

; CT_040_lselect_inj (matches Coq: Lemma CT_040_lselect_inj)
; CT_040_lselect_inj: forall r1 la1 l1a lb1 l1b r2 la2 l2a lb2 l2b, LSelect r1 la1 l1a lb1 l1b = LSelect r2 la2 l2a lb2 l2b -> r1 = r2 /\ la1 
(assert (forall ((r1 Bool) (la1 Bool) (l1a Bool) (lb1 Bool) (l1b Bool) (r2 Bool) (la2 Bool) (l2a Bool) (lb2 Bool) (l2b Bool)) (= 0 0))) ; CT_040_lselect_inj [partial: bindings preserved]

; CT_041_local_dual_end (matches Coq: Lemma CT_041_local_dual_end)
; CT_041_local_dual_end: local_dual LEnd = LEnd
(assert (= 0 0)) ; CT_041_local_dual_end [Coq-only]

; CT_042_local_dual_var (matches Coq: Lemma CT_042_local_dual_var)
; CT_042_local_dual_var: forall n, local_dual (LVar n) = LVar n
(assert (forall ((n Bool)) (= 0 0))) ; CT_042_local_dual_var [partial: bindings preserved]

; CT_043_local_dual_rec (matches Coq: Lemma CT_043_local_dual_rec)
; CT_043_local_dual_rec: forall n l, local_dual (LRec n l) = LRec n (local_dual l)
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; CT_043_local_dual_rec [partial: bindings preserved]

; CT_044_local_dual_send (matches Coq: Lemma CT_044_local_dual_send)
; CT_044_local_dual_send: forall r t l, local_dual (LSend r t l) = LRecv r t (local_dual l)
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_044_local_dual_send [partial: bindings preserved]

; CT_045_local_dual_recv (matches Coq: Lemma CT_045_local_dual_recv)
; CT_045_local_dual_recv: forall r t l, local_dual (LRecv r t l) = LSend r t (local_dual l)
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_045_local_dual_recv [partial: bindings preserved]

; CT_046_local_dual_select (matches Coq: Lemma CT_046_local_dual_select)
; CT_046_local_dual_select: forall r la l1 lb l2, local_dual (LSelect r la l1 lb l2) = LOffer r la (local_dual l1) lb (local_dual l2)
(assert (forall ((r Bool) (la Bool) (l1 Bool) (lb Bool) (l2 Bool)) (= 0 0))) ; CT_046_local_dual_select [partial: bindings preserved]

; CT_047_local_dual_offer (matches Coq: Lemma CT_047_local_dual_offer)
; CT_047_local_dual_offer: forall r la l1 lb l2, local_dual (LOffer r la l1 lb l2) = LSelect r la (local_dual l1) lb (local_dual l2)
(assert (forall ((r Bool) (la Bool) (l1 Bool) (lb Bool) (l2 Bool)) (= 0 0))) ; CT_047_local_dual_offer [partial: bindings preserved]

; CT_048_local_dual_involutive (matches Coq: Theorem CT_048_local_dual_involutive)
; CT_048_local_dual_involutive: forall l, local_dual (local_dual l) = l
(assert (forall ((l Bool)) (= 0 0))) ; CT_048_local_dual_involutive [partial: bindings preserved]

; CT_049_dual_preserves_end (matches Coq: Lemma CT_049_dual_preserves_end)
; CT_049_dual_preserves_end: forall l, local_dual l = LEnd -> l = LEnd
(assert (forall ((l Bool)) (= 0 0))) ; CT_049_dual_preserves_end [partial: bindings preserved]

; CT_050_dual_send_ne_end (matches Coq: Lemma CT_050_dual_send_ne_end)
; CT_050_dual_send_ne_end: forall r t l, local_dual (LSend r t l) <> LEnd
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_050_dual_send_ne_end [partial: bindings preserved]

; CT_051_dual_recv_ne_end (matches Coq: Lemma CT_051_dual_recv_ne_end)
; CT_051_dual_recv_ne_end: forall r t l, local_dual (LRecv r t l) <> LEnd
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_051_dual_recv_ne_end [partial: bindings preserved]

; CT_052_dual_select_is_offer (matches Coq: Lemma CT_052_dual_select_is_offer)
; CT_052_dual_select_is_offer: forall r la l1 lb l2, exists r' la' l1' lb' l2', local_dual (LSelect r la l1 lb l2) = LOffer r' la' l1' lb' l2'
(assert (forall ((r Bool) (la Bool) (l1 Bool) (lb Bool) (l2 Bool)) (= 0 0))) ; CT_052_dual_select_is_offer [partial: bindings preserved]

; CT_053_dual_offer_is_select (matches Coq: Lemma CT_053_dual_offer_is_select)
; CT_053_dual_offer_is_select: forall r la l1 lb l2, exists r' la' l1' lb' l2', local_dual (LOffer r la l1 lb l2) = LSelect r' la' l1' lb' l2'
(assert (forall ((r Bool) (la Bool) (l1 Bool) (lb Bool) (l2 Bool)) (= 0 0))) ; CT_053_dual_offer_is_select [partial: bindings preserved]

; CT_054_dual_send_recv_pair (matches Coq: Lemma CT_054_dual_send_recv_pair)
; CT_054_dual_send_recv_pair: forall r t l, local_dual (LSend r t l) = LRecv r t (local_dual l) /\ local_dual (LRecv r t l) = LSend r t (local_dual l)
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_054_dual_send_recv_pair [partial: bindings preserved]

; CT_055_dual_send_produces_recv (matches Coq: Lemma CT_055_dual_send_produces_recv)
; CT_055_dual_send_produces_recv: forall r t l, match local_dual (LSend r t l) with | LRecv r' t' _ => r' = r /\ t' = t | _ => False end
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CT_055_dual_send_produces_recv [partial: bindings preserved]

; CT_056_project_end (matches Coq: Lemma CT_056_project_end)
; CT_056_project_end: forall r, project GEnd r = LEnd
(assert (forall ((r Bool)) (= 0 0))) ; CT_056_project_end [partial: bindings preserved]

; CT_057_project_var (matches Coq: Lemma CT_057_project_var)
; CT_057_project_var: forall n r, project (GVar n) r = LVar n
(assert (forall ((n Bool) (r Bool)) (= 0 0))) ; CT_057_project_var [partial: bindings preserved]

; CT_058_project_rec (matches Coq: Lemma CT_058_project_rec)
; CT_058_project_rec: forall n g r, project (GRec n g) r = LRec n (project g r)
(assert (forall ((n Bool) (g Bool) (r Bool)) (= 0 0))) ; CT_058_project_rec [partial: bindings preserved]

; CT_059_project_msg_sender (matches Coq: Lemma CT_059_project_msg_sender)
; CT_059_project_msg_sender: forall p q t g, project (GMsg p q t g) p = LSend q t (project g p)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_059_project_msg_sender [partial: bindings preserved]

; CT_060_project_msg_receiver (matches Coq: Lemma CT_060_project_msg_receiver)
; CT_060_project_msg_receiver: forall p q t g, p <> q -> project (GMsg p q t g) q = LRecv p t (project g q)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_060_project_msg_receiver [partial: bindings preserved]

; CT_061_project_msg_other (matches Coq: Lemma CT_061_project_msg_other)
; CT_061_project_msg_other: forall p q t g r, r <> p -> r <> q -> project (GMsg p q t g) r = project g r
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (r Bool)) (= 0 0))) ; CT_061_project_msg_other [partial: bindings preserved]

; CT_062_project_branch_sender (matches Coq: Lemma CT_062_project_branch_sender)
; CT_062_project_branch_sender: forall p q l1 g1 l2 g2, project (GBranch p q l1 g1 l2 g2) p = LSelect q l1 (project g1 p) l2 (project g2 p)
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_062_project_branch_sender [partial: bindings preserved]

; CT_063_project_branch_receiver (matches Coq: Lemma CT_063_project_branch_receiver)
; CT_063_project_branch_receiver: forall p q l1 g1 l2 g2, p <> q -> project (GBranch p q l1 g1 l2 g2) q = LOffer p l1 (project g1 q) l2 (project g2 q)
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_063_project_branch_receiver [partial: bindings preserved]

; CT_064_project_branch_other (matches Coq: Lemma CT_064_project_branch_other)
; CT_064_project_branch_other: forall p q l1 g1 l2 g2 r, r <> p -> r <> q -> project (GBranch p q l1 g1 l2 g2) r = project g1 r
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool) (r Bool)) (= 0 0))) ; CT_064_project_branch_other [partial: bindings preserved]

; CT_065_project_msg_sender_structure (matches Coq: Lemma CT_065_project_msg_sender_structure)
; CT_065_project_msg_sender_structure: forall p q t g, exists l', project (GMsg p q t g) p = LSend q t l'
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_065_project_msg_sender_structure [partial: bindings preserved]

; CT_066_project_msg_receiver_structure (matches Coq: Lemma CT_066_project_msg_receiver_structure)
; CT_066_project_msg_receiver_structure: forall p q t g, p <> q -> exists l', project (GMsg p q t g) q = LRecv p t l'
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_066_project_msg_receiver_structure [partial: bindings preserved]

; CT_067_project_end_always_lend (matches Coq: Lemma CT_067_project_end_always_lend)
; CT_067_project_end_always_lend: forall r, project GEnd r = LEnd
(assert (forall ((r Bool)) (= 0 0))) ; CT_067_project_end_always_lend [partial: bindings preserved]

; CT_068_project_msg_sender_payload (matches Coq: Lemma CT_068_project_msg_sender_payload)
; CT_068_project_msg_sender_payload: forall p q t g, match project (GMsg p q t g) p with | LSend _ t' _ => t' = t | _ => False end
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_068_project_msg_sender_payload [partial: bindings preserved]

; CT_069_project_msg_receiver_payload (matches Coq: Lemma CT_069_project_msg_receiver_payload)
; CT_069_project_msg_receiver_payload: forall p q t g, p <> q -> match project (GMsg p q t g) q with | LRecv _ t' _ => t' = t | _ => False end
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_069_project_msg_receiver_payload [partial: bindings preserved]

; CT_070_project_msg_sender_cont (matches Coq: Lemma CT_070_project_msg_sender_cont)
; CT_070_project_msg_sender_cont: forall p q t g, match project (GMsg p q t g) p with | LSend _ _ l' => l' = project g p | _ => False end
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_070_project_msg_sender_cont [partial: bindings preserved]

; CT_071_project_msg_receiver_cont (matches Coq: Lemma CT_071_project_msg_receiver_cont)
; CT_071_project_msg_receiver_cont: forall p q t g, p <> q -> match project (GMsg p q t g) q with | LRecv _ _ l' => l' = project g q | _ => False end
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_071_project_msg_receiver_cont [partial: bindings preserved]

; CT_072_project_branch_sender_labels (matches Coq: Lemma CT_072_project_branch_sender_labels)
; CT_072_project_branch_sender_labels: forall p q l1 g1 l2 g2, match project (GBranch p q l1 g1 l2 g2) p with | LSelect _ la _ lb _ => la = l1 /\ lb = l2 | _ =
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_072_project_branch_sender_labels [partial: bindings preserved]

; CT_073_project_branch_receiver_labels (matches Coq: Lemma CT_073_project_branch_receiver_labels)
; CT_073_project_branch_receiver_labels: forall p q l1 g1 l2 g2, p <> q -> match project (GBranch p q l1 g1 l2 g2) q with | LOffer _ la _ lb _ => la = l1 /\ lb =
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_073_project_branch_receiver_labels [partial: bindings preserved]

; CT_074_project_rec_wraps (matches Coq: Lemma CT_074_project_rec_wraps)
; CT_074_project_rec_wraps: forall n g r, exists l', project (GRec n g) r = LRec n l'
(assert (forall ((n Bool) (g Bool) (r Bool)) (= 0 0))) ; CT_074_project_rec_wraps [partial: bindings preserved]

; CT_075_project_var_wraps (matches Coq: Lemma CT_075_project_var_wraps)
; CT_075_project_var_wraps: forall n r, project (GVar n) r = LVar n
(assert (forall ((n Bool) (r Bool)) (= 0 0))) ; CT_075_project_var_wraps [partial: bindings preserved]

; CT_076_wf_end (matches Coq: Lemma CT_076_wf_end)
; CT_076_wf_end: well_formed_global GEnd
(assert (= 0 0)) ; CT_076_wf_end [Coq-only]

; CT_077_wf_var (matches Coq: Lemma CT_077_wf_var)
; CT_077_wf_var: forall n, well_formed_global (GVar n)
(assert (forall ((n Bool)) (= 0 0))) ; CT_077_wf_var [partial: bindings preserved]

; CT_078_wf_rec (matches Coq: Lemma CT_078_wf_rec)
; CT_078_wf_rec: forall n g, well_formed_global g -> well_formed_global (GRec n g)
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CT_078_wf_rec [partial: bindings preserved]

; CT_079_wf_msg (matches Coq: Lemma CT_079_wf_msg)
; CT_079_wf_msg: forall p q t g, p <> q -> well_formed_global g -> well_formed_global (GMsg p q t g)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_079_wf_msg [partial: bindings preserved]

; CT_080_wf_branch (matches Coq: Lemma CT_080_wf_branch)
; CT_080_wf_branch: forall p q l1 g1 l2 g2, p <> q -> well_formed_global g1 -> well_formed_global g2 -> well_formed_global (GBranch p q l1 g
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_080_wf_branch [partial: bindings preserved]

; CT_081_wf_msg_not_self (matches Coq: Lemma CT_081_wf_msg_not_self)
; CT_081_wf_msg_not_self: forall p t g, ~ well_formed_global (GMsg p p t g)
(assert (forall ((p Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_081_wf_msg_not_self [partial: bindings preserved]

; CT_082_wf_branch_not_self (matches Coq: Lemma CT_082_wf_branch_not_self)
; CT_082_wf_branch_not_self: forall p l1 g1 l2 g2, ~ well_formed_global (GBranch p p l1 g1 l2 g2)
(assert (forall ((p Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_082_wf_branch_not_self [partial: bindings preserved]

; CT_083_wf_msg_sender_ne_receiver (matches Coq: Lemma CT_083_wf_msg_sender_ne_receiver)
; CT_083_wf_msg_sender_ne_receiver: forall p q t g, well_formed_global (GMsg p q t g) -> p <> q
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_083_wf_msg_sender_ne_receiver [partial: bindings preserved]

; CT_084_wf_branch_sender_ne_receiver (matches Coq: Lemma CT_084_wf_branch_sender_ne_receiver)
; CT_084_wf_branch_sender_ne_receiver: forall p q l1 g1 l2 g2, well_formed_global (GBranch p q l1 g1 l2 g2) -> p <> q
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_084_wf_branch_sender_ne_receiver [partial: bindings preserved]

; CT_085_wf_msg_implies_cont_wf (matches Coq: Lemma CT_085_wf_msg_implies_cont_wf)
; CT_085_wf_msg_implies_cont_wf: forall p q t g, well_formed_global (GMsg p q t g) -> well_formed_global g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_085_wf_msg_implies_cont_wf [partial: bindings preserved]

; CT_086_wf_branch_implies_branches_wf (matches Coq: Lemma CT_086_wf_branch_implies_branches_wf)
; CT_086_wf_branch_implies_branches_wf: forall p q l1 g1 l2 g2, well_formed_global (GBranch p q l1 g1 l2 g2) -> well_formed_global g1 /\ well_formed_global g2
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_086_wf_branch_implies_branches_wf [partial: bindings preserved]

; CT_087_wf_rec_implies_body_wf (matches Coq: Lemma CT_087_wf_rec_implies_body_wf)
; CT_087_wf_rec_implies_body_wf: forall n g, well_formed_global (GRec n g) -> well_formed_global g
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CT_087_wf_rec_implies_body_wf [partial: bindings preserved]

; CT_088_roles_end (matches Coq: Lemma CT_088_roles_end)
; CT_088_roles_end: roles_of GEnd = []
(assert (= 0 0)) ; CT_088_roles_end [Coq-only]

; CT_089_roles_var (matches Coq: Lemma CT_089_roles_var)
; CT_089_roles_var: forall n, roles_of (GVar n) = []
(assert (forall ((n Bool)) (= 0 0))) ; CT_089_roles_var [partial: bindings preserved]

; CT_090_roles_rec (matches Coq: Lemma CT_090_roles_rec)
; CT_090_roles_rec: forall n g, roles_of (GRec n g) = roles_of g
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CT_090_roles_rec [partial: bindings preserved]

; CT_091_roles_msg (matches Coq: Lemma CT_091_roles_msg)
; CT_091_roles_msg: forall p q t g, roles_of (GMsg p q t g) = p :: q :: roles_of g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_091_roles_msg [partial: bindings preserved]

; CT_092_roles_branch (matches Coq: Lemma CT_092_roles_branch)
; CT_092_roles_branch: forall p q l1 g1 l2 g2, roles_of (GBranch p q l1 g1 l2 g2) = p :: q :: roles_of g1 ++ roles_of g2
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_092_roles_branch [partial: bindings preserved]

; CT_093_roles_msg_sender_in (matches Coq: Lemma CT_093_roles_msg_sender_in)
; CT_093_roles_msg_sender_in: forall p q t g, In p (roles_of (GMsg p q t g))
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_093_roles_msg_sender_in [partial: bindings preserved]

; CT_094_roles_msg_receiver_in (matches Coq: Lemma CT_094_roles_msg_receiver_in)
; CT_094_roles_msg_receiver_in: forall p q t g, In q (roles_of (GMsg p q t g))
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_094_roles_msg_receiver_in [partial: bindings preserved]

; CT_095_roles_branch_sender_in (matches Coq: Lemma CT_095_roles_branch_sender_in)
; CT_095_roles_branch_sender_in: forall p q l1 g1 l2 g2, In p (roles_of (GBranch p q l1 g1 l2 g2))
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_095_roles_branch_sender_in [partial: bindings preserved]

; CT_096_proj_duality_msg (matches Coq: Lemma CT_096_proj_duality_msg)
; CT_096_proj_duality_msg: forall p q t g, p <> q -> interaction_dual (project (GMsg p q t g) p) (project (GMsg p q t g) q)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_096_proj_duality_msg [partial: bindings preserved]

; CT_097_proj_duality_branch (matches Coq: Lemma CT_097_proj_duality_branch)
; CT_097_proj_duality_branch: forall p q l1 g1 l2 g2, p <> q -> interaction_dual (project (GBranch p q l1 g1 l2 g2) p) (project (GBranch p q l1 g1 l2 
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_097_proj_duality_branch [partial: bindings preserved]

; CT_098_proj_sender_receiver_dual (matches Coq: Lemma CT_098_proj_sender_receiver_dual)
; CT_098_proj_sender_receiver_dual: forall p q t g, p <> q -> exists lp lq, project (GMsg p q t g) p = LSend q t lp /\ project (GMsg p q t g) q = LRecv p t 
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_098_proj_sender_receiver_dual [partial: bindings preserved]

; CT_099_proj_interaction_dual_send (matches Coq: Lemma CT_099_proj_interaction_dual_send)
; CT_099_proj_interaction_dual_send: forall p q t g, p <> q -> match project (GMsg p q t g) p with | LSend q' t' _ => q' = q /\ t' = t | _ => False end
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_099_proj_interaction_dual_send [partial: bindings preserved]

; CT_100_proj_interaction_dual_recv (matches Coq: Lemma CT_100_proj_interaction_dual_recv)
; CT_100_proj_interaction_dual_recv: forall p q t g, p <> q -> match project (GMsg p q t g) q with | LRecv p' t' _ => p' = p /\ t' = t | _ => False end
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_100_proj_interaction_dual_recv [partial: bindings preserved]

; CT_101_proj_branch_dual_select (matches Coq: Lemma CT_101_proj_branch_dual_select)
; CT_101_proj_branch_dual_select: forall p q l1 g1 l2 g2, match project (GBranch p q l1 g1 l2 g2) p with | LSelect _ _ _ _ _ => True | _ => False end
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_101_proj_branch_dual_select [partial: bindings preserved]

; CT_102_proj_branch_dual_offer (matches Coq: Lemma CT_102_proj_branch_dual_offer)
; CT_102_proj_branch_dual_offer: forall p q l1 g1 l2 g2, p <> q -> match project (GBranch p q l1 g1 l2 g2) q with | LOffer _ _ _ _ _ => True | _ => False
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_102_proj_branch_dual_offer [partial: bindings preserved]

; CT_103_projection_preserves_duality (matches Coq: Theorem CT_103_projection_preserves_duality)
; CT_103_projection_preserves_duality: forall p q t g, p <> q -> project (GMsg p q t g) p = LSend q t (project g p) /\ project (GMsg p q t g) q = LRecv p t (pr
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_103_projection_preserves_duality [partial: bindings preserved]

; CT_104_dual_proj_msg_symmetric (matches Coq: Lemma CT_104_dual_proj_msg_symmetric)
; CT_104_dual_proj_msg_symmetric: forall p q t g, p <> q -> local_dual (project (GMsg p q t g) p) = LRecv q t (local_dual (project g p))
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_104_dual_proj_msg_symmetric [partial: bindings preserved]

; CT_105_dual_proj_branch_symmetric (matches Coq: Lemma CT_105_dual_proj_branch_symmetric)
; CT_105_dual_proj_branch_symmetric: forall p q l1 g1 l2 g2, p <> q -> local_dual (project (GBranch p q l1 g1 l2 g2) p) = LOffer q l1 (local_dual (project g1
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_105_dual_proj_branch_symmetric [partial: bindings preserved]

; CT_106_proj_dual_end_pair (matches Coq: Lemma CT_106_proj_dual_end_pair)
; CT_106_proj_dual_end_pair: forall r, project GEnd r = LEnd /\ local_dual (project GEnd r) = LEnd
(assert (forall ((r Bool)) (= 0 0))) ; CT_106_proj_dual_end_pair [partial: bindings preserved]

; CT_107_proj_dual_simple_protocol (matches Coq: Lemma CT_107_proj_dual_simple_protocol)
; CT_107_proj_dual_simple_protocol: let g := GMsg 0 1 PayNat GEnd in project g 0 = LSend 1 PayNat LEnd /\ project g 1 = LRecv 0 PayNat LEnd
(assert (= 0 0)) ; CT_107_proj_dual_simple_protocol [Coq-only]

; CT_108_proj_dual_branching_protocol (matches Coq: Lemma CT_108_proj_dual_branching_protocol)
; CT_108_proj_dual_branching_protocol: let g := GBranch 0 1 10 GEnd 20 GEnd in project g 0 = LSelect 1 10 LEnd 20 LEnd /\ project g 1 = LOffer 0 10 LEnd 20 LEn
(assert (= 0 0)) ; CT_108_proj_dual_branching_protocol [Coq-only]

; CT_109_proj_dual_recursive_protocol (matches Coq: Lemma CT_109_proj_dual_recursive_protocol)
; CT_109_proj_dual_recursive_protocol: let g := GRec 0 (GMsg 0 1 PayBool (GVar 0)) in project g 0 = LRec 0 (LSend 1 PayBool (LVar 0)) /\ project g 1 = LRec 0 (
(assert (= 0 0)) ; CT_109_proj_dual_recursive_protocol [Coq-only]

; CT_110_dual_interaction_coherence (matches Coq: Lemma CT_110_dual_interaction_coherence)
; CT_110_dual_interaction_coherence: forall p q t g, p <> q -> match project (GMsg p q t g) p, project (GMsg p q t g) q with | LSend q' t1 _, LRecv p' t2 _ =
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_110_dual_interaction_coherence [partial: bindings preserved]

; CT_111_network_empty (matches Coq: Lemma CT_111_network_empty)
; CT_111_network_empty: network_of GEnd [] = []
(assert (= 0 0)) ; CT_111_network_empty [Coq-only]

; CT_112_network_typed (matches Coq: Lemma CT_112_network_typed)
; CT_112_network_typed: forall g roles, well_formed_global g -> well_typed_network (network_of g roles)
(assert (forall ((g Bool) (roles Bool)) (= 0 0))) ; CT_112_network_typed [partial: bindings preserved]

; CT_113_waiting_false (matches Coq: Lemma CT_113_waiting_false)
; CT_113_waiting_false: forall net r1 r2, ~ chor_waiting net r1 r2
(assert (forall ((net Bool) (r1 Bool) (r2 Bool)) (= 0 0))) ; CT_113_waiting_false [partial: bindings preserved]

; CT_114_circular_wait_impossible (matches Coq: Lemma CT_114_circular_wait_impossible)
; CT_114_circular_wait_impossible: forall net, ~ chor_circular_wait net
(assert (forall ((net Bool)) (= 0 0))) ; CT_114_circular_wait_impossible [partial: bindings preserved]

; CT_115_deadlock_free_empty (matches Coq: Lemma CT_115_deadlock_free_empty)
; CT_115_deadlock_free_empty: ~ chor_deadlocked []
(assert (= 0 0)) ; CT_115_deadlock_free_empty [Coq-only]

; CT_116_deadlock_free_typed (matches Coq: Lemma CT_116_deadlock_free_typed)
; CT_116_deadlock_free_typed: forall net, well_typed_network net -> ~ chor_deadlocked net
(assert (forall ((net Bool)) (= 0 0))) ; CT_116_deadlock_free_typed [partial: bindings preserved]

; CT_117_choreography_deadlock_free (matches Coq: Theorem CT_117_choreography_deadlock_free)
; CT_117_choreography_deadlock_free: forall g roles, well_formed_global g -> ~ chor_deadlocked (network_of g roles)
(assert (forall ((g Bool) (roles Bool)) (= 0 0))) ; CT_117_choreography_deadlock_free [partial: bindings preserved]

; CT_118_can_communicate_pair (matches Coq: Lemma CT_118_can_communicate_pair)
; CT_118_can_communicate_pair: forall q t l1 p l2, can_communicate (LSend q t l1) (LRecv p t l2)
(assert (forall ((q Bool) (t Bool) (l1 Bool) (p Bool) (l2 Bool)) (= 0 0))) ; CT_118_can_communicate_pair [partial: bindings preserved]

; CT_119_can_communicate_implies_progress (matches Coq: Lemma CT_119_can_communicate_implies_progress)
; CT_119_can_communicate_implies_progress: forall l1 l2, can_communicate l1 l2 -> (exists q t l', l1 = LSend q t l') \/ (exists r la l1' lb l2', l1 = LSelect r la 
(assert (forall ((l1 Bool) (l2 Bool)) (= 0 0))) ; CT_119_can_communicate_implies_progress [partial: bindings preserved]

; CT_120_network_step_exists (matches Coq: Lemma CT_120_network_step_exists)
; CT_120_network_step_exists: forall p q t g roles, p <> q -> In p roles -> In q roles -> well_formed_global (GMsg p q t g) -> can_communicate (projec
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (roles Bool)) (= 0 0))) ; CT_120_network_step_exists [partial: bindings preserved]

; CT_121_well_typed_network_progress (matches Coq: Lemma CT_121_well_typed_network_progress)
; CT_121_well_typed_network_progress: forall g p q t, p <> q -> well_formed_global (GMsg p q t g) -> can_communicate (project (GMsg p q t g) p) (project (GMsg
(assert (forall ((g Bool) (p Bool) (q Bool) (t Bool)) (= 0 0))) ; CT_121_well_typed_network_progress [partial: bindings preserved]

; CT_122_config_value (matches Coq: Lemma CT_122_config_value)
; CT_122_config_value: forall r, project GEnd r = LEnd
(assert (forall ((r Bool)) (= 0 0))) ; CT_122_config_value [partial: bindings preserved]

; CT_123_config_end (matches Coq: Lemma CT_123_config_end)
; CT_123_config_end: forall roles, Forall (fun p => snd p = LEnd) (network_of GEnd roles)
(assert (forall ((roles Bool)) (= 0 0))) ; CT_123_config_end [partial: bindings preserved]

; CT_124_network_monotone (matches Coq: Lemma CT_124_network_monotone)
; CT_124_network_monotone: forall g r roles, In r roles -> exists l, In (r, l) (network_of g roles)
(assert (forall ((g Bool) (r Bool) (roles Bool)) (= 0 0))) ; CT_124_network_monotone [partial: bindings preserved]

; CT_125_network_termination (matches Coq: Lemma CT_125_network_termination)
; CT_125_network_termination: forall roles, network_of GEnd roles = map (fun r => (r, LEnd)) roles
(assert (forall ((roles Bool)) (= 0 0))) ; CT_125_network_termination [partial: bindings preserved]

; CT_126_project_composition (matches Coq: Lemma CT_126_project_composition)
; CT_126_project_composition: forall p q t1 t2 g r, r <> p -> r <> q -> project (GMsg p q t1 (GMsg p q t2 g)) r = project (GMsg p q t2 g) r
(assert (forall ((p Bool) (q Bool) (t1 Bool) (t2 Bool) (g Bool) (r Bool)) (= 0 0))) ; CT_126_project_composition [partial: bindings preserved]

; CT_127_project_sequential (matches Coq: Lemma CT_127_project_sequential)
; CT_127_project_sequential: forall p q t g, project (GMsg p q t g) p = LSend q t (project g p)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_127_project_sequential [partial: bindings preserved]

; CT_128_project_independent_roles (matches Coq: Lemma CT_128_project_independent_roles)
; CT_128_project_independent_roles: forall p q t g r, r <> p -> r <> q -> project (GMsg p q t g) r = project g r
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (r Bool)) (= 0 0))) ; CT_128_project_independent_roles [partial: bindings preserved]

; CT_129_global_size_positive (matches Coq: Lemma CT_129_global_size_positive)
; CT_129_global_size_positive: forall g, global_size g >= 1
(assert (forall ((g Bool)) (= 0 0))) ; CT_129_global_size_positive [partial: bindings preserved]

; CT_130_global_size_msg (matches Coq: Lemma CT_130_global_size_msg)
; CT_130_global_size_msg: forall p q t g, global_size (GMsg p q t g) = 1 + global_size g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CT_130_global_size_msg [partial: bindings preserved]

; CT_131_global_size_branch (matches Coq: Lemma CT_131_global_size_branch)
; CT_131_global_size_branch: forall p q l1 g1 l2 g2, global_size (GBranch p q l1 g1 l2 g2) = 1 + global_size g1 + global_size g2
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CT_131_global_size_branch [partial: bindings preserved]

; CT_132_project_preserves_rec (matches Coq: Lemma CT_132_project_preserves_rec)
; CT_132_project_preserves_rec: forall n g r, project (GRec n g) r = LRec n (project g r)
(assert (forall ((n Bool) (g Bool) (r Bool)) (= 0 0))) ; CT_132_project_preserves_rec [partial: bindings preserved]

; CT_133_project_preserves_var (matches Coq: Lemma CT_133_project_preserves_var)
; CT_133_project_preserves_var: forall n r, project (GVar n) r = LVar n
(assert (forall ((n Bool) (r Bool)) (= 0 0))) ; CT_133_project_preserves_var [partial: bindings preserved]

; CT_134_local_dual_preserves_rec (matches Coq: Lemma CT_134_local_dual_preserves_rec)
; CT_134_local_dual_preserves_rec: forall n l, local_dual (LRec n l) = LRec n (local_dual l)
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; CT_134_local_dual_preserves_rec [partial: bindings preserved]

; CT_135_local_dual_preserves_var (matches Coq: Lemma CT_135_local_dual_preserves_var)
; CT_135_local_dual_preserves_var: forall n, local_dual (LVar n) = LVar n
(assert (forall ((n Bool)) (= 0 0))) ; CT_135_local_dual_preserves_var [partial: bindings preserved]

; CT_136_two_party_request_response (matches Coq: Lemma CT_136_two_party_request_response)
; CT_136_two_party_request_response: project example_request_response 0 = LSend 1 PayNat (LRecv 1 PayBool LEnd)
(assert (= 0 0)) ; CT_136_two_party_request_response [Coq-only]

; CT_137_two_party_buyer_seller (matches Coq: Lemma CT_137_two_party_buyer_seller)
; CT_137_two_party_buyer_seller: project example_request_response 1 = LRecv 0 PayNat (LSend 0 PayBool LEnd)
(assert (= 0 0)) ; CT_137_two_party_buyer_seller [Coq-only]

; CT_138_three_party_delegation (matches Coq: Lemma CT_138_three_party_delegation)
; CT_138_three_party_delegation: project example_delegation 0 = LSend 1 PayNat LEnd /\ project example_delegation 1 = LRecv 0 PayNat (LSend 2 PayNat LEnd
(assert (= 0 0)) ; CT_138_three_party_delegation [Coq-only]

; CT_139_binary_choice_protocol (matches Coq: Lemma CT_139_binary_choice_protocol)
; CT_139_binary_choice_protocol: project example_choice 0 = LSelect 1 1 LEnd 2 LEnd /\ project example_choice 1 = LOffer 0 1 LEnd 2 LEnd
(assert (= 0 0)) ; CT_139_binary_choice_protocol [Coq-only]

; CT_140_recursive_protocol (matches Coq: Lemma CT_140_recursive_protocol)
; CT_140_recursive_protocol: project example_recursive 0 = LRec 0 (LSend 1 PayNat (LVar 0)) /\ project example_recursive 1 = LRec 0 (LRecv 0 PayNat (
(assert (= 0 0)) ; CT_140_recursive_protocol [Coq-only]

; CT_141_example_project_sender (matches Coq: Lemma CT_141_example_project_sender)
; CT_141_example_project_sender: project (GMsg 0 1 PayUnit GEnd) 0 = LSend 1 PayUnit LEnd
(assert (= 0 0)) ; CT_141_example_project_sender [Coq-only]

; CT_142_example_project_receiver (matches Coq: Lemma CT_142_example_project_receiver)
; CT_142_example_project_receiver: project (GMsg 0 1 PayUnit GEnd) 1 = LRecv 0 PayUnit LEnd
(assert (= 0 0)) ; CT_142_example_project_receiver [Coq-only]

; CT_143_example_project_observer (matches Coq: Lemma CT_143_example_project_observer)
; CT_143_example_project_observer: project (GMsg 0 1 PayUnit GEnd) 2 = LEnd
(assert (= 0 0)) ; CT_143_example_project_observer [Coq-only]

; CT_144_example_wf (matches Coq: Lemma CT_144_example_wf)
; CT_144_example_wf: well_formed_global example_request_response
(assert (= 0 0)) ; CT_144_example_wf [Coq-only]

; CT_145_example_dual_projected (matches Coq: Lemma CT_145_example_dual_projected)
; CT_145_example_dual_projected: interaction_dual (project (GMsg 0 1 PayNat GEnd) 0) (project (GMsg 0 1 PayNat GEnd) 1)
(assert (= 0 0)) ; CT_145_example_dual_projected [Coq-only]

; CT_146_global_depth (matches Coq: Lemma CT_146_global_depth)
; CT_146_global_depth: forall g, global_size g >= 1
(assert (forall ((g Bool)) (= 0 0))) ; CT_146_global_depth [partial: bindings preserved]

; CT_147_local_size_positive (matches Coq: Lemma CT_147_local_size_positive)
; CT_147_local_size_positive: forall l, local_size l >= 1
(assert (forall ((l Bool)) (= 0 0))) ; CT_147_local_size_positive [partial: bindings preserved]

; CT_148_project_depth_bound (matches Coq: Lemma CT_148_project_depth_bound)
; CT_148_project_depth_bound: forall r, local_size (project GEnd r) = 1
(assert (forall ((r Bool)) (= 0 0))) ; CT_148_project_depth_bound [partial: bindings preserved]

; CT_149_role_not_in_end (matches Coq: Lemma CT_149_role_not_in_end)
; CT_149_role_not_in_end: forall r, ~ In r (roles_of GEnd)
(assert (forall ((r Bool)) (= 0 0))) ; CT_149_role_not_in_end [partial: bindings preserved]

; CT_150_projection_total (matches Coq: Lemma CT_150_projection_total)
; CT_150_projection_total: forall g r, exists l, project g r = l
(assert (forall ((g Bool) (r Bool)) (= 0 0))) ; CT_150_projection_total [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
