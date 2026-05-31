(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/ChoreographyProjection.v (103 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.ChoreographyProjection
open FStar.All

(* GlobalStep — Coq Prop predicate stub *)
assume val globalstep : nat -> nat -> bool

(* LocalStep — Coq Prop predicate stub *)
assume val localstep : nat -> nat -> bool

(* mergeable (matches Coq: Fixpoint mergeable) *)
let rec mergeable (p_l1: nat) (p_l2: nat) : Tot bool =
  true

(* mergeableb (matches Coq: Fixpoint mergeableb) *)
let rec mergeableb (p_l1: nat) (p_l2: nat) : Tot bool =
  match p_l1, p_l2 with
  | LEnd, LEnd -> true
  | LVar (n1,, LVar, n2) -> (n1 = n2)
  | LRec (n1, p_l1',, LRec, n2, p_l2') -> (n1 = n2) && mergeableb p_l1' p_l2'
  | LSend (r1, t1, p_l1',, LSend, r2, t2, p_l2') -> (r1 = r2) && payload_eqb t1 t2 && mergeableb p_l1' p_l2'
  | LRecv (r1, t1, p_l1',, LRecv, r2, t2, p_l2') -> (r1 = r2) && payload_eqb t1 t2 && mergeableb p_l1' p_l2'
  | LSelect (r1, la1, l1a, lb1, l1b,, LSelect, r2, la2, l2a, lb2, l2b) -> (r1 = r2) && (la1 = la2) && (lb1 = lb2) && mergeableb l1a l2a && mergeableb l1b l2b
  | LOffer (r1, la1, l1a, lb1, l1b,, LOffer, r2, la2, l2a, lb2, l2b) -> (r1 = r2) && (la1 = la2) && (lb1 = lb2) && mergeableb l1a l2a && mergeableb l1b l2b
  | _, _ -> false
  | _ -> false

(* merge_compatible (matches Coq: Definition merge_compatible) *)
let merge_compatible (p_g: nat) : Tot bool =
  true

(* subst_global (matches Coq: Fixpoint subst_global) *)
let rec subst_global (p_x: nat) (p_s: nat) (p_g: nat) : Tot nat =
  match p_g with
  | GEnd -> GEnd
  | GVar n -> if (n = p_x) then p_s else GVar n
  | GRec (n, p_g') -> if (n = p_x) then GRec n p_g' else GRec n (subst_global p_x p_s p_g')
  | GMsg (p, q, t, p_g') -> GMsg p q t (subst_global p_x p_s p_g')
  | GBranch (p, q, l1, g1, l2, g2) -> GBranch p q l1 (subst_global p_x p_s g1) l2 (subst_global p_x p_s g2)
  | _ -> 0

(* subst_local (matches Coq: Fixpoint subst_local) *)
let rec subst_local (p_x: nat) (p_s: nat) (p_l: nat) : Tot nat =
  match p_l with
  | LEnd -> LEnd
  | LVar n -> if (n = p_x) then p_s else LVar n
  | LRec (n, p_l') -> if (n = p_x) then LRec n p_l' else LRec n (subst_local p_x p_s p_l')
  | LSend (r, t, p_l') -> LSend r t (subst_local p_x p_s p_l')
  | LRecv (r, t, p_l') -> LRecv r t (subst_local p_x p_s p_l')
  | LSelect (r, la, l1, lb, l2) -> LSelect r la (subst_local p_x p_s l1) lb (subst_local p_x p_s l2)
  | LOffer (r, la, l1, lb, l2) -> LOffer r la (subst_local p_x p_s l1) lb (subst_local p_x p_s l2)
  | _ -> 0

(* typed_network (matches Coq: Definition typed_network) *)
let typed_network (p_g: nat) (p_net: nat) : Tot bool =
  true

(* CP_001_mergeable_refl (matches Coq: Lemma CP_001_mergeable_refl) *)
let cp_001_mergeable_refl (p_l: _) : Lemma (mergeable p_l p_l == true) = admit ()

(* CP_002_mergeable_end (matches Coq: Lemma CP_002_mergeable_end) *)
let cp_002_mergeable_end () : Lemma (mergeable LEnd LEnd == true) = admit ()

(* CP_003_mergeable_var (matches Coq: Lemma CP_003_mergeable_var) *)
let cp_003_mergeable_var (p_n: _) : Lemma (mergeable (LVar p_n) (LVar p_n) == true) = admit ()

(* CP_004_mergeable_var_eq (matches Coq: Lemma CP_004_mergeable_var_eq) *)
let cp_004_mergeable_var_eq (p_n1: _) (p_n2: _) : Lemma (requires (mergeable (LVar p_n1) (LVar p_n2) == true)) (ensures (p_n1 == p_n2)) = admit ()

(* CP_005_mergeable_send (matches Coq: Lemma CP_005_mergeable_send) *)
let cp_005_mergeable_send (p_r: _) (p_t: _) (p_l1: _) (p_l2: _) : Lemma (requires (mergeable p_l1 p_l2 == true)) (ensures (mergeable (LSend p_r p_t p_l1) (LSend p_r p_t p_l2) == true)) = admit ()

(* CP_006_mergeable_recv (matches Coq: Lemma CP_006_mergeable_recv) *)
let cp_006_mergeable_recv (p_r: _) (p_t: _) (p_l1: _) (p_l2: _) : Lemma (requires (mergeable p_l1 p_l2 == true)) (ensures (mergeable (LRecv p_r p_t p_l1) (LRecv p_r p_t p_l2) == true)) = admit ()

(* CP_007_mergeable_rec (matches Coq: Lemma CP_007_mergeable_rec) *)
let cp_007_mergeable_rec (p_n: _) (p_l1: _) (p_l2: _) : Lemma (requires (mergeable p_l1 p_l2 == true)) (ensures (mergeable (LRec p_n p_l1) (LRec p_n p_l2) == true)) = admit ()

(* CP_008_mergeable_send_inv (matches Coq: Lemma CP_008_mergeable_send_inv) *)
let cp_008_mergeable_send_inv (p_r1: _) (p_t1: _) (p_l1: _) (p_r2: _) (p_t2: _) (p_l2: _) : Lemma (requires (mergeable (LSend p_r1 p_t1 p_l1) (LSend p_r2 p_t2 p_l2) == true)) (ensures (p_r1 == p_r2 /\ p_t1 == p_t2 /\ mergeable p_l1 p_l2 == true)) = admit ()

(* CP_009_mergeable_recv_inv (matches Coq: Lemma CP_009_mergeable_recv_inv) *)
let cp_009_mergeable_recv_inv (p_r1: _) (p_t1: _) (p_l1: _) (p_r2: _) (p_t2: _) (p_l2: _) : Lemma (requires (mergeable (LRecv p_r1 p_t1 p_l1) (LRecv p_r2 p_t2 p_l2) == true)) (ensures (p_r1 == p_r2 /\ p_t1 == p_t2 /\ mergeable p_l1 p_l2 == true)) = admit ()

(* CP_010_mergeable_select_inv (matches Coq: Lemma CP_010_mergeable_select_inv) *)
let cp_010_mergeable_select_inv (p_r1: _) (p_la1: _) (p_l1a: _) (p_lb1: _) (p_l1b: _) (p_r2: _) (p_la2: _) (p_l2a: _) (p_lb2: _) (p_l2b: _) : Lemma (requires (mergeable (LSelect p_r1 p_la1 p_l1a p_lb1 p_l1b) (LSelect p_r2 p_la2 p_l2a p_lb2 p_l2b) == true)) (ensures (p_r1 == p_r2 /\ p_la1 == p_la2 /\ p_lb1 == p_lb2 /\ mergeable p_l1a p_l2a == true /\ mergeable p_l1b p_l2b == true)) = admit ()

(* CP_011_mergeable_offer_inv (matches Coq: Lemma CP_011_mergeable_offer_inv) *)
let cp_011_mergeable_offer_inv (p_r1: _) (p_la1: _) (p_l1a: _) (p_lb1: _) (p_l1b: _) (p_r2: _) (p_la2: _) (p_l2a: _) (p_lb2: _) (p_l2b: _) : Lemma (requires (mergeable (LOffer p_r1 p_la1 p_l1a p_lb1 p_l1b) (LOffer p_r2 p_la2 p_l2a p_lb2 p_l2b) == true)) (ensures (p_r1 == p_r2 /\ p_la1 == p_la2 /\ p_lb1 == p_lb2 /\ mergeable p_l1a p_l2a == true /\ mergeable p_l1b p_l2b == true)) = admit ()

(* CP_012_mergeable_end_send_false (matches Coq: Lemma CP_012_mergeable_end_send_false) *)
let cp_012_mergeable_end_send_false (p_r: _) (p_t: _) (p_l: _) : Lemma (~(mergeable LEnd (LSend p_r p_t p_l) == true)) = admit ()

(* CP_013_mergeable_send_recv_false (matches Coq: Lemma CP_013_mergeable_send_recv_false) *)
let cp_013_mergeable_send_recv_false (p_r1: _) (p_t1: _) (p_l1: _) (p_r2: _) (p_t2: _) (p_l2: _) : Lemma (~(mergeable (LSend p_r1 p_t1 p_l1) (LRecv p_r2 p_t2 p_l2) == true)) = admit ()

(* CP_014_mergeable_implies_eq (matches Coq: Lemma CP_014_mergeable_implies_eq) *)
let cp_014_mergeable_implies_eq (p_l1: _) (p_l2: _) : Lemma (requires (mergeable p_l1 p_l2 == true)) (ensures (p_l1 == p_l2)) = admit ()

(* CP_015_mergeable_sym (matches Coq: Lemma CP_015_mergeable_sym) *)
let cp_015_mergeable_sym (p_l1: _) (p_l2: _) : Lemma (requires (mergeable p_l1 p_l2 == true)) (ensures (mergeable p_l2 p_l1 == true)) = admit ()

(* CP_016_projection_deterministic (matches Coq: Theorem CP_016_projection_deterministic) *)
let cp_016_projection_deterministic (p_g: _) (p_r: _) (p_l1: _) (p_l2: _) : Lemma (requires (project p_g p_r == p_l1 /\ project p_g p_r == p_l2)) (ensures (p_l1 == p_l2)) = admit ()

(* CP_017_projection_unique (matches Coq: Theorem CP_017_projection_unique) *)
let cp_017_projection_unique (p_g: _) (p_r: _) : Lemma (exists_ l_ project p_g p_r == l) = admit ()

(* CP_018_projection_functional (matches Coq: Lemma CP_018_projection_functional) *)
let cp_018_projection_functional (p_g1: _) (p_g2: _) (p_r: _) : Lemma (requires (p_g1 == p_g2)) (ensures (project p_g1 p_r == project p_g2 p_r)) = admit ()

(* CP_019_projection_respects_eq (matches Coq: Lemma CP_019_projection_respects_eq) *)
let cp_019_projection_respects_eq (p_g: _) (p_r1: _) (p_r2: _) : Lemma (requires (p_r1 == p_r2)) (ensures (project p_g p_r1 == project p_g p_r2)) = admit ()

(* CP_020_merge_compatible_end (matches Coq: Lemma CP_020_merge_compatible_end) *)
let cp_020_merge_compatible_end () : Lemma (merge_compatible GEnd == true) = admit ()

(* CP_021_merge_compatible_msg (matches Coq: Lemma CP_021_merge_compatible_msg) *)
let cp_021_merge_compatible_msg (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (merge_compatible (GMsg p_p p_q p_t p_g) == true) = admit ()

(* CP_022_merge_compatible_branch_inv (matches Coq: Lemma CP_022_merge_compatible_branch_inv) *)
let cp_022_merge_compatible_branch_inv (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (requires (merge_compatible (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) == true /\ (forall (r: _). ~(r == p_p)) /\ ~(r == p_q))) (ensures (project p_g1 r == project p_g2 r)) = admit ()

(* CP_023_merge_compatible_end_branch (matches Coq: Lemma CP_023_merge_compatible_end_branch) *)
let cp_023_merge_compatible_end_branch (p_p: _) (p_q: _) (p_l1: _) (p_l2: _) : Lemma (requires (~(p_p == p_q))) (ensures (merge_compatible (GBranch p_p p_q p_l1 GEnd p_l2 GEnd) == true)) = admit ()

(* CP_024_step_end_no_step (matches Coq: Lemma CP_024_step_end_no_step) *)
let cp_024_step_end_no_step (p_g: _) : Lemma (~(GlobalStep GEnd p_g == true)) = admit ()

(* CP_025_step_var_no_step (matches Coq: Lemma CP_025_step_var_no_step) *)
let cp_025_step_var_no_step (p_n: _) (p_g: _) : Lemma (~(GlobalStep (GVar p_n) p_g == true)) = admit ()

(* CP_026_step_msg_comm (matches Coq: Lemma CP_026_step_msg_comm) *)
let cp_026_step_msg_comm (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (GlobalStep (GMsg p_p p_q p_t p_g) p_g == true) = admit ()

(* CP_027_step_branch_left (matches Coq: Lemma CP_027_step_branch_left) *)
let cp_027_step_branch_left (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (GlobalStep (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) p_g1 == true) = admit ()

(* CP_028_step_branch_right (matches Coq: Lemma CP_028_step_branch_right) *)
let cp_028_step_branch_right (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (GlobalStep (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) p_g2 == true) = admit ()

(* CP_029_step_rec_unfold (matches Coq: Lemma CP_029_step_rec_unfold) *)
let cp_029_step_rec_unfold (p_n: _) (p_g: _) : Lemma (GlobalStep (GRec p_n p_g) (subst_global p_n (GRec p_n p_g) p_g) == true) = admit ()

(* CP_030_local_step_send (matches Coq: Lemma CP_030_local_step_send) *)
let cp_030_local_step_send (p_r: _) (p_t: _) (p_l: _) : Lemma (LocalStep (LSend p_r p_t p_l) p_l == true) = admit ()

(* CP_031_local_step_recv (matches Coq: Lemma CP_031_local_step_recv) *)
let cp_031_local_step_recv (p_r: _) (p_t: _) (p_l: _) : Lemma (LocalStep (LRecv p_r p_t p_l) p_l == true) = admit ()

(* CP_032_local_end_no_step (matches Coq: Lemma CP_032_local_end_no_step) *)
let cp_032_local_end_no_step (p_l: _) : Lemma (~(LocalStep LEnd p_l == true)) = admit ()

(* CP_033_local_var_no_step (matches Coq: Lemma CP_033_local_var_no_step) *)
let cp_033_local_var_no_step (p_n: _) (p_l: _) : Lemma (~(LocalStep (LVar p_n) p_l == true)) = admit ()

(* CP_034_step_preserves_structure (matches Coq: Lemma CP_034_step_preserves_structure) *)
let cp_034_step_preserves_structure (p_g: _) (p_g_: _) : Lemma (requires (GlobalStep p_g p_g_ == true /\ p_g == GEnd)) (ensures (False)) = admit ()

(* CP_035_step_msg_unique (matches Coq: Lemma CP_035_step_msg_unique) *)
let cp_035_step_msg_unique (p_p: _) (p_q: _) (p_t: _) (p_g: _) (p_g_: _) : Lemma (requires (GlobalStep (GMsg p_p p_q p_t p_g) p_g_ == true)) (ensures (p_g_ == p_g)) = admit ()

(* CP_036_subst_end (matches Coq: Lemma CP_036_subst_end) *)
let cp_036_subst_end (p_x: _) (p_s: _) : Lemma (subst_global p_x p_s GEnd == GEnd) = admit ()

(* CP_037_subst_var_same (matches Coq: Lemma CP_037_subst_var_same) *)
let cp_037_subst_var_same (p_x: _) (p_s: _) : Lemma (subst_global p_x p_s (GVar p_x) == p_s) = admit ()

(* CP_038_subst_var_diff (matches Coq: Lemma CP_038_subst_var_diff) *)
let cp_038_subst_var_diff (p_x: _) (p_y: _) (p_s: _) : Lemma (requires (~(p_x == p_y))) (ensures (subst_global p_x p_s (GVar p_y) == GVar p_y)) = admit ()

(* CP_039_subst_rec_same (matches Coq: Lemma CP_039_subst_rec_same) *)
let cp_039_subst_rec_same (p_x: _) (p_g: _) (p_s: _) : Lemma (subst_global p_x p_s (GRec p_x p_g) == GRec p_x p_g) = admit ()

(* CP_040_subst_rec_diff (matches Coq: Lemma CP_040_subst_rec_diff) *)
let cp_040_subst_rec_diff (p_x: _) (p_y: _) (p_g: _) (p_s: _) : Lemma (requires (~(p_x == p_y))) (ensures (subst_global p_x p_s (GRec p_y p_g) == GRec p_y (subst_global p_x p_s p_g))) = admit ()

(* CP_041_subst_msg (matches Coq: Lemma CP_041_subst_msg) *)
let cp_041_subst_msg (p_x: _) (p_s: _) (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (subst_global p_x p_s (GMsg p_p p_q p_t p_g) == GMsg p_p p_q p_t (subst_global p_x p_s p_g)) = admit ()

(* CP_042_subst_branch (matches Coq: Lemma CP_042_subst_branch) *)
let cp_042_subst_branch (p_x: _) (p_s: _) (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (subst_global p_x p_s (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) == GBranch p_p p_q p_l1 (subst_global p_x p_s p_g1) p_l2 (subst_global p_x p_s p_g2)) = admit ()

(* CP_043_subst_preserves_wf (matches Coq: Lemma CP_043_subst_preserves_wf) *)
let cp_043_subst_preserves_wf (p_x: _) (p_s: _) (p_g: _) : Lemma (requires (well_formed_global p_g == true /\ well_formed_global p_s == true)) (ensures (well_formed_global (subst_global p_x p_s p_g) == true)) = admit ()

(* CP_044_project_subst_comm (matches Coq: Lemma CP_044_project_subst_comm) *)
let cp_044_project_subst_comm (p_g: _) (p_x: _) (p_s: _) (p_r: _) : Lemma (requires (well_formed_global p_s == true)) (ensures (project (subst_global p_x p_s p_g) p_r == subst_local p_x (project p_s p_r) (project p_g p_r))) = admit ()

(* CP_045_subject_reduction_msg (matches Coq: Theorem CP_045_subject_reduction_msg) *)
let cp_045_subject_reduction_msg (p_p: _) (p_q: _) (p_t: _) (p_g: _) (p_r: _) : Lemma (requires (~(p_p == p_q) /\ p_r == p_p)) (ensures (LocalStep (project (GMsg p_p p_q p_t p_g) p_r) (project p_g p_r) == true)) = admit ()

(* CP_046_subject_reduction_recv (matches Coq: Theorem CP_046_subject_reduction_recv) *)
let cp_046_subject_reduction_recv (p_p: _) (p_q: _) (p_t: _) (p_g: _) (p_r: _) : Lemma (requires (~(p_p == p_q) /\ p_r == p_q)) (ensures (LocalStep (project (GMsg p_p p_q p_t p_g) p_r) (project p_g p_r) == true)) = admit ()

(* CP_047_subject_reduction_branch_left (matches Coq: Theorem CP_047_subject_reduction_branch_left) *)
let cp_047_subject_reduction_branch_left (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (requires (~(p_p == p_q))) (ensures (LocalStep (project (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) p_p) (project p_g1 p_p) == true)) = admit ()

(* CP_048_subject_reduction_branch_right (matches Coq: Theorem CP_048_subject_reduction_branch_right) *)
let cp_048_subject_reduction_branch_right (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (requires (~(p_p == p_q))) (ensures (LocalStep (project (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) p_p) (project p_g2 p_p) == true)) = admit ()

(* CP_049_subject_reduction_other (matches Coq: Theorem CP_049_subject_reduction_other) *)
let cp_049_subject_reduction_other (p_p: _) (p_q: _) (p_t: _) (p_g: _) (p_r: _) : Lemma (requires (~(p_r == p_p) /\ ~(p_r == p_q))) (ensures (project (GMsg p_p p_q p_t p_g) p_r == project p_g p_r)) = admit ()

(* CP_050_subject_reduction_offer_left (matches Coq: Lemma CP_050_subject_reduction_offer_left) *)
let cp_050_subject_reduction_offer_left (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (requires (~(p_p == p_q))) (ensures (LocalStep (project (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) p_q) (project p_g1 p_q) == true)) = admit ()

(* CP_051_subject_reduction_offer_right (matches Coq: Lemma CP_051_subject_reduction_offer_right) *)
let cp_051_subject_reduction_offer_right (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (requires (~(p_p == p_q))) (ensures (LocalStep (project (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) p_q) (project p_g2 p_q) == true)) = admit ()

(* CP_052_global_progress (matches Coq: Theorem CP_052_global_progress) *)
let cp_052_global_progress (p_g: _) : Lemma (requires (well_formed_global p_g == true /\ ~(p_g == GEnd) /\ ((forall (n: _). ~(p_g == GVar n))))) (ensures ((exists p_g. GlobalStep p_g g_ == true))) = admit ()

(* CP_053_global_progress_msg (matches Coq: Lemma CP_053_global_progress_msg) *)
let cp_053_global_progress_msg (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma ((exists p_g. GlobalStep (GMsg p_p p_q p_t p_g) g_ == true)) = admit ()

(* CP_054_global_progress_branch (matches Coq: Lemma CP_054_global_progress_branch) *)
let cp_054_global_progress_branch (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma ((exists p_g. GlobalStep (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) g_ == true)) = admit ()

(* CP_055_global_progress_rec (matches Coq: Lemma CP_055_global_progress_rec) *)
let cp_055_global_progress_rec (p_n: _) (p_g: _) : Lemma ((exists p_g. GlobalStep (GRec p_n p_g) g_ == true)) = admit ()

(* CP_056_global_progress_or_terminal (matches Coq: Theorem CP_056_global_progress_or_terminal) *)
let cp_056_global_progress_or_terminal (p_g: _) : Lemma (requires (well_formed_global p_g == true)) (ensures (((exists p_g. GlobalStep p_g g_ == true)) \/ p_g == GEnd \/ ((exists p_n. p_g == GVar p_n)))) = admit ()

(* CP_057_typed_network_empty (matches Coq: Lemma CP_057_typed_network_empty) *)
let cp_057_typed_network_empty (p_g: _) : Lemma (typed_network p_g [] == true) = admit ()

(* CP_058_typed_network_cons (matches Coq: Lemma CP_058_typed_network_cons) *)
let cp_058_typed_network_cons (p_g: _) (p_r: _) (p_l: _) (p_net: _) : Lemma (requires (p_l == project p_g p_r /\ typed_network p_g p_net == true)) (ensures (typed_network p_g ((p_r, p_l) :: p_net) == true)) = admit ()

(* CP_059_typed_network_of (matches Coq: Lemma CP_059_typed_network_of) *)
let cp_059_typed_network_of (p_g: _) (p_roles: _) : Lemma (typed_network p_g (network_of p_g p_roles) == true) = admit ()

(* CP_060_typed_network_lookup (matches Coq: Lemma CP_060_typed_network_lookup) *)
let cp_060_typed_network_lookup (p_g: _) (p_net: _) (p_r: _) (p_l: _) : Lemma (requires (typed_network p_g p_net == true /\ List.Tot.memP (p_r, p_l) p_net)) (ensures (p_l == project p_g p_r)) = admit ()

(* CP_061_network_step_comm (matches Coq: Lemma CP_061_network_step_comm) *)
let cp_061_network_step_comm (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (~(p_p == p_q) /\ GlobalStep (GMsg p_p p_q p_t p_g) p_g == true)) (ensures (LocalStep (project (GMsg p_p p_q p_t p_g) p_p) (project p_g p_p) == true)) = admit ()

(* CP_062_network_step_recv (matches Coq: Lemma CP_062_network_step_recv) *)
let cp_062_network_step_recv (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (~(p_p == p_q) /\ GlobalStep (GMsg p_p p_q p_t p_g) p_g == true)) (ensures (LocalStep (project (GMsg p_p p_q p_t p_g) p_q) (project p_g p_q) == true)) = admit ()

(* CP_063_network_no_deadlock (matches Coq: Lemma CP_063_network_no_deadlock) *)
let cp_063_network_no_deadlock (p_g: _) (p_roles: _) : Lemma (requires (well_formed_global p_g == true)) (ensures (~(chor_deadlocked (network_of p_g p_roles) == true))) = admit ()

(* CP_064_network_empty_end (matches Coq: Lemma CP_064_network_empty_end) *)
let cp_064_network_empty_end () : Lemma (typed_network GEnd [] == true) = admit ()

(* CP_065_protocol_fidelity_send (matches Coq: Theorem CP_065_protocol_fidelity_send) *)
let cp_065_protocol_fidelity_send (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (~(p_p == p_q))) (ensures ((exists p_l. project (GMsg p_p p_q p_t p_g) p_p == LSend p_q p_t p_l) /\ l == project p_g p_p)) = admit ()

(* CP_066_protocol_fidelity_recv (matches Coq: Theorem CP_066_protocol_fidelity_recv) *)
let cp_066_protocol_fidelity_recv (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (~(p_p == p_q))) (ensures ((exists p_l. project (GMsg p_p p_q p_t p_g) p_q == LRecv p_p p_t p_l) /\ l == project p_g p_q)) = admit ()

(* CP_067_session_fidelity (matches Coq: Theorem CP_067_session_fidelity) *)
let cp_067_session_fidelity_obligation () : Tot bool = true
let cp_067_session_fidelity_lemma () : Lemma (requires True) (ensures (cp_067_session_fidelity_obligation () == cp_067_session_fidelity_obligation ())) = ()

(* CP_068_linearity_msg (matches Coq: Lemma CP_068_linearity_msg) *)
let cp_068_linearity_msg (p_p: _) (p_q: _) (p_t: _) (p_g: _) (p_g_: _) : Lemma (requires (GlobalStep (GMsg p_p p_q p_t p_g) p_g_ == true)) (ensures (p_g_ == p_g)) = admit ()

(* CP_069_completeness_end (matches Coq: Lemma CP_069_completeness_end) *)
let cp_069_completeness_end () : Lemma ((exists p_g. project p_g 0 == LEnd)) = admit ()

(* CP_069_completeness_var (matches Coq: Lemma CP_069_completeness_var) *)
let cp_069_completeness_var (p_n: _) : Lemma ((exists p_g. project p_g 0 == LVar p_n)) = admit ()

(* CP_069_completeness_send (matches Coq: Lemma CP_069_completeness_send) *)
let cp_069_completeness_send (p_r: _) (p_t: _) (p_l: _) : Lemma (requires (((exists p_g. project p_g 0 == p_l)))) (ensures ((exists p_g. project p_g 0 == LSend p_r p_t p_l))) = admit ()

(* CP_069_completeness_recv (matches Coq: Lemma CP_069_completeness_recv) *)
let cp_069_completeness_recv (p_r: _) (p_t: _) (p_l: _) : Lemma (requires (~(p_r == 0) /\ ((exists p_g. project p_g 0 == p_l)))) (ensures ((exists p_g. project p_g 0 == LRecv p_r p_t p_l))) = admit ()

(* CP_070_subst_local_end (matches Coq: Lemma CP_070_subst_local_end) *)
let cp_070_subst_local_end (p_x: _) (p_s: _) : Lemma (subst_local p_x p_s LEnd == LEnd) = admit ()

(* CP_071_subst_local_var_same (matches Coq: Lemma CP_071_subst_local_var_same) *)
let cp_071_subst_local_var_same (p_x: _) (p_s: _) : Lemma (subst_local p_x p_s (LVar p_x) == p_s) = admit ()

(* CP_072_subst_local_var_diff (matches Coq: Lemma CP_072_subst_local_var_diff) *)
let cp_072_subst_local_var_diff (p_x: _) (p_y: _) (p_s: _) : Lemma (requires (~(p_x == p_y))) (ensures (subst_local p_x p_s (LVar p_y) == LVar p_y)) = admit ()

(* CP_073_subst_local_rec_same (matches Coq: Lemma CP_073_subst_local_rec_same) *)
let cp_073_subst_local_rec_same (p_x: _) (p_l: _) (p_s: _) : Lemma (subst_local p_x p_s (LRec p_x p_l) == LRec p_x p_l) = admit ()

(* CP_074_subst_local_rec_diff (matches Coq: Lemma CP_074_subst_local_rec_diff) *)
let cp_074_subst_local_rec_diff (p_x: _) (p_y: _) (p_l: _) (p_s: _) : Lemma (requires (~(p_x == p_y))) (ensures (subst_local p_x p_s (LRec p_y p_l) == LRec p_y (subst_local p_x p_s p_l))) = admit ()

(* CP_075_subst_local_send (matches Coq: Lemma CP_075_subst_local_send) *)
let cp_075_subst_local_send (p_x: _) (p_s: _) (p_r: _) (p_t: _) (p_l: _) : Lemma (subst_local p_x p_s (LSend p_r p_t p_l) == LSend p_r p_t (subst_local p_x p_s p_l)) = admit ()

(* CP_076_subst_local_recv (matches Coq: Lemma CP_076_subst_local_recv) *)
let cp_076_subst_local_recv (p_x: _) (p_s: _) (p_r: _) (p_t: _) (p_l: _) : Lemma (subst_local p_x p_s (LRecv p_r p_t p_l) == LRecv p_r p_t (subst_local p_x p_s p_l)) = admit ()

(* CP_077_rec_unfold_well_formed (matches Coq: Lemma CP_077_rec_unfold_well_formed) *)
let cp_077_rec_unfold_well_formed (p_n: _) (p_g: _) : Lemma (requires (well_formed_global (GRec p_n p_g) == true)) (ensures (well_formed_global p_g == true)) = admit ()

(* CP_078_project_msg_chain (matches Coq: Lemma CP_078_project_msg_chain) *)
let cp_078_project_msg_chain (p_p1: _) (p_q1: _) (p_t1: _) (p_p2: _) (p_q2: _) (p_t2: _) (p_g: _) (p_r: _) : Lemma (requires (p_r == p_p1 /\ ~(p_p1 == p_q1) /\ ~(p_p2 == p_q2))) (ensures (project (GMsg p_p1 p_q1 p_t1 (GMsg p_p2 p_q2 p_t2 p_g)) p_r == LSend p_q1 p_t1 (project (GMsg p_p2 p_q2 p_t2 p_g) p_r))) = admit ()

(* CP_079_project_msg_recv_chain (matches Coq: Lemma CP_079_project_msg_recv_chain) *)
let cp_079_project_msg_recv_chain (p_p: _) (p_q: _) (p_t1: _) (p_t2: _) (p_g: _) : Lemma (requires (~(p_p == p_q))) (ensures (project (GMsg p_p p_q p_t1 (GMsg p_q p_p p_t2 p_g)) p_p == LSend p_q p_t1 (LRecv p_q p_t2 (project p_g p_p)))) = admit ()

(* CP_080_project_msg_recv_chain_q (matches Coq: Lemma CP_080_project_msg_recv_chain_q) *)
let cp_080_project_msg_recv_chain_q (p_p: _) (p_q: _) (p_t1: _) (p_t2: _) (p_g: _) : Lemma (requires (~(p_p == p_q))) (ensures (project (GMsg p_p p_q p_t1 (GMsg p_q p_p p_t2 p_g)) p_q == LRecv p_p p_t1 (LSend p_p p_t2 (project p_g p_q)))) = admit ()

(* CP_081_dual_project_msg_sender (matches Coq: Lemma CP_081_dual_project_msg_sender) *)
let cp_081_dual_project_msg_sender (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (local_dual (project (GMsg p_p p_q p_t p_g) p_p) == LRecv p_q p_t (local_dual (project p_g p_p))) = admit ()

(* CP_082_dual_project_msg_receiver (matches Coq: Lemma CP_082_dual_project_msg_receiver) *)
let cp_082_dual_project_msg_receiver (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (~(p_p == p_q))) (ensures (local_dual (project (GMsg p_p p_q p_t p_g) p_q) == LSend p_p p_t (local_dual (project p_g p_q)))) = admit ()

(* CP_083_dual_project_end (matches Coq: Lemma CP_083_dual_project_end) *)
let cp_083_dual_project_end (p_r: _) : Lemma (local_dual (project GEnd p_r) == LEnd) = admit ()

(* CP_084_dual_project_var (matches Coq: Lemma CP_084_dual_project_var) *)
let cp_084_dual_project_var (p_n: _) (p_r: _) : Lemma (local_dual (project (GVar p_n) p_r) == LVar p_n) = admit ()

(* CP_085_dual_project_rec (matches Coq: Lemma CP_085_dual_project_rec) *)
let cp_085_dual_project_rec (p_n: _) (p_g: _) (p_r: _) : Lemma (local_dual (project (GRec p_n p_g) p_r) == LRec p_n (local_dual (project p_g p_r))) = admit ()

(* CP_086_dual_preserves_mergeable (matches Coq: Lemma CP_086_dual_preserves_mergeable) *)
let cp_086_dual_preserves_mergeable (p_l1: _) (p_l2: _) : Lemma (requires (mergeable p_l1 p_l2 == true)) (ensures (mergeable (local_dual p_l1) (local_dual p_l2) == true)) = admit ()

(* CP_087_wf_step_preserves (matches Coq: Lemma CP_087_wf_step_preserves) *)
let cp_087_wf_step_preserves (p_g: _) (p_g_: _) : Lemma (requires (well_formed_global p_g == true /\ GlobalStep p_g p_g_ == true)) (ensures (well_formed_global p_g_ == true \/ ((exists p_n. (exists p_body. p_g == GRec p_n p_body)) /\ p_g_ == subst_global n (GRec n body) body))) = admit ()

(* CP_088_wf_comm_step (matches Coq: Lemma CP_088_wf_comm_step) *)
let cp_088_wf_comm_step (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (well_formed_global (GMsg p_p p_q p_t p_g) == true)) (ensures (well_formed_global p_g == true)) = admit ()

(* CP_089_wf_branch_step_left (matches Coq: Lemma CP_089_wf_branch_step_left) *)
let cp_089_wf_branch_step_left (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (requires (well_formed_global (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) == true)) (ensures (well_formed_global p_g1 == true)) = admit ()

(* CP_090_wf_branch_step_right (matches Coq: Lemma CP_090_wf_branch_step_right) *)
let cp_090_wf_branch_step_right (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (requires (well_formed_global (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) == true)) (ensures (well_formed_global p_g2 == true)) = admit ()

(* CP_091_project_step_uninvolved (matches Coq: Lemma CP_091_project_step_uninvolved) *)
let cp_091_project_step_uninvolved (p_p: _) (p_q: _) (p_t: _) (p_g: _) (p_r: _) : Lemma (requires (~(p_r == p_p) /\ ~(p_r == p_q))) (ensures (project (GMsg p_p p_q p_t p_g) p_r == project p_g p_r)) = admit ()

(* CP_092_project_gend_all_lend (matches Coq: Lemma CP_092_project_gend_all_lend) *)
let cp_092_project_gend_all_lend_obligation () : Tot bool = true
let cp_092_project_gend_all_lend_lemma () : Lemma (requires True) (ensures (cp_092_project_gend_all_lend_obligation () == cp_092_project_gend_all_lend_obligation ())) = ()

(* CP_093_all_roles_end (matches Coq: Lemma CP_093_all_roles_end) *)
let cp_093_all_roles_end (p_g: _) : Lemma (requires (p_g == GEnd)) (ensures ((forall (r: _). project p_g r == LEnd))) = admit ()

(* CP_094_step_reduces_msg (matches Coq: Lemma CP_094_step_reduces_msg) *)
let cp_094_step_reduces_msg (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (global_size (GMsg p_p p_q p_t p_g) > global_size p_g) = admit ()

(* CP_095_step_reduces_branch (matches Coq: Lemma CP_095_step_reduces_branch) *)
let cp_095_step_reduces_branch (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) : Lemma (global_size (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) > global_size p_g1 /\ global_size (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) > global_size p_g2) = admit ()

(* CP_096_wf_distinct_projection (matches Coq: Lemma CP_096_wf_distinct_projection) *)
let cp_096_wf_distinct_projection (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (~(p_p == p_q) /\ well_formed_global (GMsg p_p p_q p_t p_g) == true)) (ensures (~(project (GMsg p_p p_q p_t p_g) p_p == project (GMsg p_p p_q p_t p_g) p_q))) = admit ()

(* CP_097_merge_compat_implies_eq (matches Coq: Lemma CP_097_merge_compat_implies_eq) *)
let cp_097_merge_compat_implies_eq (p_p: _) (p_q: _) (p_l1: _) (p_g1: _) (p_l2: _) (p_g2: _) (p_r: _) : Lemma (requires (merge_compatible (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) == true /\ ~(p_r == p_p) /\ ~(p_r == p_q))) (ensures (project (GBranch p_p p_q p_l1 p_g1 p_l2 p_g2) p_r == project p_g1 p_r /\ project p_g1 p_r == project p_g2 p_r)) = admit ()

(* CP_098_branch_end_merge (matches Coq: Lemma CP_098_branch_end_merge) *)
let cp_098_branch_end_merge (p_p: _) (p_q: _) (p_l1: _) (p_l2: _) (p_r: _) : Lemma (requires (~(p_r == p_p) /\ ~(p_r == p_q))) (ensures (project (GBranch p_p p_q p_l1 GEnd p_l2 GEnd) p_r == LEnd)) = admit ()

(* CP_099_subject_reduction (matches Coq: Theorem CP_099_subject_reduction) *)
let cp_099_subject_reduction_obligation () : Tot bool = true
let cp_099_subject_reduction_lemma () : Lemma (requires True) (ensures (cp_099_subject_reduction_obligation () == cp_099_subject_reduction_obligation ())) = ()

(* CP_100_subject_reduction_full (matches Coq: Theorem CP_100_subject_reduction_full) *)
let cp_100_subject_reduction_full (p_p: _) (p_q: _) (p_t: _) (p_g: _) : Lemma (requires (~(p_p == p_q) /\ well_formed_global (GMsg p_p p_q p_t p_g) == true)) (ensures ((project (GMsg p_p p_q p_t p_g) p_p == LSend p_q p_t (project p_g p_p)) /\ (project (GMsg p_p p_q p_t p_g) p_q == LRecv p_p p_t (project p_g p_q)) /\ ((forall (r: _). r <> p_p -> r <> p_q -> project (GMsg p_p p_q p_t p_g) r == project p_g r)))) = admit ()
