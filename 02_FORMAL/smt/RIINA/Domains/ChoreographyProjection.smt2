; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ChoreographyProjection.v (103 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ChoreographyProjection

(set-logic ALL)
(set-option :produce-models true)

; mergeable (matches Coq: Definition mergeable)
(define-fun mergeable ((l1 Int) (l2 Int)) Bool
  (= 0 0))

; mergeableb (matches Coq: Definition mergeableb)
(define-fun mergeableb ((l1 Int) (l2 Int)) Bool
  (= 0 0))

; merge_compatible (matches Coq: Definition merge_compatible)
(define-fun merge_compatible ((g Int)) Bool
  (= 0 0))

; subst_global (matches Coq: Definition subst_global)
(define-fun subst_global ((x Int) (s Int) (g Int)) Int
  0)

; subst_local (matches Coq: Definition subst_local)
(define-fun subst_local ((x Int) (s Int) (l Int)) Int
  0)

; typed_network (matches Coq: Definition typed_network)
(define-fun typed_network ((g Int) (net Int)) Bool
  (= 0 0))

; CP_001_mergeable_refl (matches Coq: Lemma CP_001_mergeable_refl)
; CP_001_mergeable_refl: forall l, mergeable l l
(assert (forall ((l Bool)) (= 0 0))) ; CP_001_mergeable_refl [partial: bindings preserved]

; CP_002_mergeable_end (matches Coq: Lemma CP_002_mergeable_end)
; CP_002_mergeable_end: mergeable LEnd LEnd
(assert (= 0 0)) ; CP_002_mergeable_end [Coq-only]

; CP_003_mergeable_var (matches Coq: Lemma CP_003_mergeable_var)
; CP_003_mergeable_var: forall n, mergeable (LVar n) (LVar n)
(assert (forall ((n Bool)) (= 0 0))) ; CP_003_mergeable_var [partial: bindings preserved]

; CP_004_mergeable_var_eq (matches Coq: Lemma CP_004_mergeable_var_eq)
; CP_004_mergeable_var_eq: forall n1 n2, mergeable (LVar n1) (LVar n2) -> n1 = n2
(assert (forall ((n1 Bool) (n2 Bool)) (= 0 0))) ; CP_004_mergeable_var_eq [partial: bindings preserved]

; CP_005_mergeable_send (matches Coq: Lemma CP_005_mergeable_send)
; CP_005_mergeable_send: forall r t l1 l2, mergeable l1 l2 -> mergeable (LSend r t l1) (LSend r t l2)
(assert (forall ((r Bool) (t Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; CP_005_mergeable_send [partial: bindings preserved]

; CP_006_mergeable_recv (matches Coq: Lemma CP_006_mergeable_recv)
; CP_006_mergeable_recv: forall r t l1 l2, mergeable l1 l2 -> mergeable (LRecv r t l1) (LRecv r t l2)
(assert (forall ((r Bool) (t Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; CP_006_mergeable_recv [partial: bindings preserved]

; CP_007_mergeable_rec (matches Coq: Lemma CP_007_mergeable_rec)
; CP_007_mergeable_rec: forall n l1 l2, mergeable l1 l2 -> mergeable (LRec n l1) (LRec n l2)
(assert (forall ((n Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; CP_007_mergeable_rec [partial: bindings preserved]

; CP_008_mergeable_send_inv (matches Coq: Lemma CP_008_mergeable_send_inv)
; CP_008_mergeable_send_inv: forall r1 t1 l1 r2 t2 l2, mergeable (LSend r1 t1 l1) (LSend r2 t2 l2) -> r1 = r2 /\ t1 = t2 /\ mergeable l1 l2
(assert (forall ((r1 Bool) (t1 Bool) (l1 Bool) (r2 Bool) (t2 Bool) (l2 Bool)) (= 0 0))) ; CP_008_mergeable_send_inv [partial: bindings preserved]

; CP_009_mergeable_recv_inv (matches Coq: Lemma CP_009_mergeable_recv_inv)
; CP_009_mergeable_recv_inv: forall r1 t1 l1 r2 t2 l2, mergeable (LRecv r1 t1 l1) (LRecv r2 t2 l2) -> r1 = r2 /\ t1 = t2 /\ mergeable l1 l2
(assert (forall ((r1 Bool) (t1 Bool) (l1 Bool) (r2 Bool) (t2 Bool) (l2 Bool)) (= 0 0))) ; CP_009_mergeable_recv_inv [partial: bindings preserved]

; CP_010_mergeable_select_inv (matches Coq: Lemma CP_010_mergeable_select_inv)
; CP_010_mergeable_select_inv: forall r1 la1 l1a lb1 l1b r2 la2 l2a lb2 l2b, mergeable (LSelect r1 la1 l1a lb1 l1b) (LSelect r2 la2 l2a lb2 l2b) -> r1 
(assert (forall ((r1 Bool) (la1 Bool) (l1a Bool) (lb1 Bool) (l1b Bool) (r2 Bool) (la2 Bool) (l2a Bool) (lb2 Bool) (l2b Bool)) (= 0 0))) ; CP_010_mergeable_select_inv [partial: bindings preserved]

; CP_011_mergeable_offer_inv (matches Coq: Lemma CP_011_mergeable_offer_inv)
; CP_011_mergeable_offer_inv: forall r1 la1 l1a lb1 l1b r2 la2 l2a lb2 l2b, mergeable (LOffer r1 la1 l1a lb1 l1b) (LOffer r2 la2 l2a lb2 l2b) -> r1 = 
(assert (forall ((r1 Bool) (la1 Bool) (l1a Bool) (lb1 Bool) (l1b Bool) (r2 Bool) (la2 Bool) (l2a Bool) (lb2 Bool) (l2b Bool)) (= 0 0))) ; CP_011_mergeable_offer_inv [partial: bindings preserved]

; CP_012_mergeable_end_send_false (matches Coq: Lemma CP_012_mergeable_end_send_false)
; CP_012_mergeable_end_send_false: forall r t l, ~ mergeable LEnd (LSend r t l)
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CP_012_mergeable_end_send_false [partial: bindings preserved]

; CP_013_mergeable_send_recv_false (matches Coq: Lemma CP_013_mergeable_send_recv_false)
; CP_013_mergeable_send_recv_false: forall r1 t1 l1 r2 t2 l2, ~ mergeable (LSend r1 t1 l1) (LRecv r2 t2 l2)
(assert (forall ((r1 Bool) (t1 Bool) (l1 Bool) (r2 Bool) (t2 Bool) (l2 Bool)) (= 0 0))) ; CP_013_mergeable_send_recv_false [partial: bindings preserved]

; CP_014_mergeable_implies_eq (matches Coq: Lemma CP_014_mergeable_implies_eq)
; CP_014_mergeable_implies_eq: forall l1 l2, mergeable l1 l2 -> l1 = l2
(assert (forall ((l1 Bool) (l2 Bool)) (= 0 0))) ; CP_014_mergeable_implies_eq [partial: bindings preserved]

; CP_015_mergeable_sym (matches Coq: Lemma CP_015_mergeable_sym)
; CP_015_mergeable_sym: forall l1 l2, mergeable l1 l2 -> mergeable l2 l1
(assert (forall ((l1 Bool) (l2 Bool)) (= 0 0))) ; CP_015_mergeable_sym [partial: bindings preserved]

; CP_016_projection_deterministic (matches Coq: Theorem CP_016_projection_deterministic)
; CP_016_projection_deterministic: forall g r l1 l2, project g r = l1 -> project g r = l2 -> l1 = l2
(assert (forall ((g Bool) (r Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; CP_016_projection_deterministic [partial: bindings preserved]

; CP_017_projection_unique (matches Coq: Theorem CP_017_projection_unique)
; CP_017_projection_unique: forall g r, exists! l, project g r = l
(assert (forall ((g Bool) (r Bool)) (= 0 0))) ; CP_017_projection_unique [partial: bindings preserved]

; CP_018_projection_functional (matches Coq: Lemma CP_018_projection_functional)
; CP_018_projection_functional: forall g1 g2 r, g1 = g2 -> project g1 r = project g2 r
(assert (forall ((g1 Bool) (g2 Bool) (r Bool)) (= 0 0))) ; CP_018_projection_functional [partial: bindings preserved]

; CP_019_projection_respects_eq (matches Coq: Lemma CP_019_projection_respects_eq)
; CP_019_projection_respects_eq: forall g r1 r2, r1 = r2 -> project g r1 = project g r2
(assert (forall ((g Bool) (r1 Bool) (r2 Bool)) (= 0 0))) ; CP_019_projection_respects_eq [partial: bindings preserved]

; CP_020_merge_compatible_end (matches Coq: Lemma CP_020_merge_compatible_end)
; CP_020_merge_compatible_end: merge_compatible GEnd
(assert (= 0 0)) ; CP_020_merge_compatible_end [Coq-only]

; CP_021_merge_compatible_msg (matches Coq: Lemma CP_021_merge_compatible_msg)
; CP_021_merge_compatible_msg: forall p q t g, merge_compatible (GMsg p q t g)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_021_merge_compatible_msg [partial: bindings preserved]

; CP_022_merge_compatible_branch_inv (matches Coq: Lemma CP_022_merge_compatible_branch_inv)
; CP_022_merge_compatible_branch_inv: forall p q l1 g1 l2 g2, merge_compatible (GBranch p q l1 g1 l2 g2) -> forall r, r <> p -> r <> q -> project g1 r = proje
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_022_merge_compatible_branch_inv [partial: bindings preserved]

; CP_023_merge_compatible_end_branch (matches Coq: Lemma CP_023_merge_compatible_end_branch)
; CP_023_merge_compatible_end_branch: forall p q l1 l2, p <> q -> merge_compatible (GBranch p q l1 GEnd l2 GEnd)
(assert (forall ((p Bool) (q Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; CP_023_merge_compatible_end_branch [partial: bindings preserved]

; CP_024_step_end_no_step (matches Coq: Lemma CP_024_step_end_no_step)
; CP_024_step_end_no_step: forall g, ~ GlobalStep GEnd g
(assert (forall ((g Bool)) (= 0 0))) ; CP_024_step_end_no_step [partial: bindings preserved]

; CP_025_step_var_no_step (matches Coq: Lemma CP_025_step_var_no_step)
; CP_025_step_var_no_step: forall n g, ~ GlobalStep (GVar n) g
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CP_025_step_var_no_step [partial: bindings preserved]

; CP_026_step_msg_comm (matches Coq: Lemma CP_026_step_msg_comm)
; CP_026_step_msg_comm: forall p q t g, GlobalStep (GMsg p q t g) g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_026_step_msg_comm [partial: bindings preserved]

; CP_027_step_branch_left (matches Coq: Lemma CP_027_step_branch_left)
; CP_027_step_branch_left: forall p q l1 g1 l2 g2, GlobalStep (GBranch p q l1 g1 l2 g2) g1
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_027_step_branch_left [partial: bindings preserved]

; CP_028_step_branch_right (matches Coq: Lemma CP_028_step_branch_right)
; CP_028_step_branch_right: forall p q l1 g1 l2 g2, GlobalStep (GBranch p q l1 g1 l2 g2) g2
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_028_step_branch_right [partial: bindings preserved]

; CP_029_step_rec_unfold (matches Coq: Lemma CP_029_step_rec_unfold)
; CP_029_step_rec_unfold: forall n g, GlobalStep (GRec n g) (subst_global n (GRec n g) g)
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CP_029_step_rec_unfold [partial: bindings preserved]

; CP_030_local_step_send (matches Coq: Lemma CP_030_local_step_send)
; CP_030_local_step_send: forall r t l, LocalStep (LSend r t l) l
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CP_030_local_step_send [partial: bindings preserved]

; CP_031_local_step_recv (matches Coq: Lemma CP_031_local_step_recv)
; CP_031_local_step_recv: forall r t l, LocalStep (LRecv r t l) l
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CP_031_local_step_recv [partial: bindings preserved]

; CP_032_local_end_no_step (matches Coq: Lemma CP_032_local_end_no_step)
; CP_032_local_end_no_step: forall l, ~ LocalStep LEnd l
(assert (forall ((l Bool)) (= 0 0))) ; CP_032_local_end_no_step [partial: bindings preserved]

; CP_033_local_var_no_step (matches Coq: Lemma CP_033_local_var_no_step)
; CP_033_local_var_no_step: forall n l, ~ LocalStep (LVar n) l
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; CP_033_local_var_no_step [partial: bindings preserved]

; CP_034_step_preserves_structure (matches Coq: Lemma CP_034_step_preserves_structure)
; CP_034_step_preserves_structure: forall g g', GlobalStep g g' -> g = GEnd -> False
(assert (forall ((g Bool) (g_ Bool)) (= 0 0))) ; CP_034_step_preserves_structure [partial: bindings preserved]

; CP_035_step_msg_unique (matches Coq: Lemma CP_035_step_msg_unique)
; CP_035_step_msg_unique: forall p q t g g', GlobalStep (GMsg p q t g) g' -> g' = g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (g_ Bool)) (= 0 0))) ; CP_035_step_msg_unique [partial: bindings preserved]

; CP_036_subst_end (matches Coq: Lemma CP_036_subst_end)
; CP_036_subst_end: forall x s, subst_global x s GEnd = GEnd
(assert (forall ((x Bool) (s Bool)) (= 0 0))) ; CP_036_subst_end [partial: bindings preserved]

; CP_037_subst_var_same (matches Coq: Lemma CP_037_subst_var_same)
; CP_037_subst_var_same: forall x s, subst_global x s (GVar x) = s
(assert (forall ((x Bool) (s Bool)) (= 0 0))) ; CP_037_subst_var_same [partial: bindings preserved]

; CP_038_subst_var_diff (matches Coq: Lemma CP_038_subst_var_diff)
; CP_038_subst_var_diff: forall x y s, x <> y -> subst_global x s (GVar y) = GVar y
(assert (forall ((x Bool) (y Bool) (s Bool)) (= 0 0))) ; CP_038_subst_var_diff [partial: bindings preserved]

; CP_039_subst_rec_same (matches Coq: Lemma CP_039_subst_rec_same)
; CP_039_subst_rec_same: forall x g s, subst_global x s (GRec x g) = GRec x g
(assert (forall ((x Bool) (g Bool) (s Bool)) (= 0 0))) ; CP_039_subst_rec_same [partial: bindings preserved]

; CP_040_subst_rec_diff (matches Coq: Lemma CP_040_subst_rec_diff)
; CP_040_subst_rec_diff: forall x y g s, x <> y -> subst_global x s (GRec y g) = GRec y (subst_global x s g)
(assert (forall ((x Bool) (y Bool) (g Bool) (s Bool)) (= 0 0))) ; CP_040_subst_rec_diff [partial: bindings preserved]

; CP_041_subst_msg (matches Coq: Lemma CP_041_subst_msg)
; CP_041_subst_msg: forall x s p q t g, subst_global x s (GMsg p q t g) = GMsg p q t (subst_global x s g)
(assert (forall ((x Bool) (s Bool) (p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_041_subst_msg [partial: bindings preserved]

; CP_042_subst_branch (matches Coq: Lemma CP_042_subst_branch)
; CP_042_subst_branch: forall x s p q l1 g1 l2 g2, subst_global x s (GBranch p q l1 g1 l2 g2) = GBranch p q l1 (subst_global x s g1) l2 (subst_
(assert (forall ((x Bool) (s Bool) (p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_042_subst_branch [partial: bindings preserved]

; CP_043_subst_preserves_wf (matches Coq: Lemma CP_043_subst_preserves_wf)
; CP_043_subst_preserves_wf: forall x s g, well_formed_global g -> well_formed_global s -> well_formed_global (subst_global x s g)
(assert (forall ((x Bool) (s Bool) (g Bool)) (= 0 0))) ; CP_043_subst_preserves_wf [partial: bindings preserved]

; CP_044_project_subst_comm (matches Coq: Lemma CP_044_project_subst_comm)
; CP_044_project_subst_comm: forall g x s r, well_formed_global s -> project (subst_global x s g) r = subst_local x (project s r) (project g r)
(assert (forall ((g Bool) (x Bool) (s Bool) (r Bool)) (= 0 0))) ; CP_044_project_subst_comm [partial: bindings preserved]

; CP_045_subject_reduction_msg (matches Coq: Theorem CP_045_subject_reduction_msg)
; CP_045_subject_reduction_msg: forall p q t g r, p <> q -> r = p -> LocalStep (project (GMsg p q t g) r) (project g r)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (r Bool)) (= 0 0))) ; CP_045_subject_reduction_msg [partial: bindings preserved]

; CP_046_subject_reduction_recv (matches Coq: Theorem CP_046_subject_reduction_recv)
; CP_046_subject_reduction_recv: forall p q t g r, p <> q -> r = q -> LocalStep (project (GMsg p q t g) r) (project g r)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (r Bool)) (= 0 0))) ; CP_046_subject_reduction_recv [partial: bindings preserved]

; CP_047_subject_reduction_branch_left (matches Coq: Theorem CP_047_subject_reduction_branch_left)
; CP_047_subject_reduction_branch_left: forall p q l1 g1 l2 g2, p <> q -> LocalStep (project (GBranch p q l1 g1 l2 g2) p) (project g1 p)
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_047_subject_reduction_branch_left [partial: bindings preserved]

; CP_048_subject_reduction_branch_right (matches Coq: Theorem CP_048_subject_reduction_branch_right)
; CP_048_subject_reduction_branch_right: forall p q l1 g1 l2 g2, p <> q -> LocalStep (project (GBranch p q l1 g1 l2 g2) p) (project g2 p)
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_048_subject_reduction_branch_right [partial: bindings preserved]

; CP_049_subject_reduction_other (matches Coq: Theorem CP_049_subject_reduction_other)
; CP_049_subject_reduction_other: forall p q t g r, r <> p -> r <> q -> project (GMsg p q t g) r = project g r
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (r Bool)) (= 0 0))) ; CP_049_subject_reduction_other [partial: bindings preserved]

; CP_050_subject_reduction_offer_left (matches Coq: Lemma CP_050_subject_reduction_offer_left)
; CP_050_subject_reduction_offer_left: forall p q l1 g1 l2 g2, p <> q -> LocalStep (project (GBranch p q l1 g1 l2 g2) q) (project g1 q)
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_050_subject_reduction_offer_left [partial: bindings preserved]

; CP_051_subject_reduction_offer_right (matches Coq: Lemma CP_051_subject_reduction_offer_right)
; CP_051_subject_reduction_offer_right: forall p q l1 g1 l2 g2, p <> q -> LocalStep (project (GBranch p q l1 g1 l2 g2) q) (project g2 q)
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_051_subject_reduction_offer_right [partial: bindings preserved]

; CP_052_global_progress (matches Coq: Theorem CP_052_global_progress)
; CP_052_global_progress: forall g, well_formed_global g -> g <> GEnd -> (forall n, g <> GVar n) -> exists g', GlobalStep g g'
(assert (forall ((g Bool)) (= 0 0))) ; CP_052_global_progress [partial: bindings preserved]

; CP_053_global_progress_msg (matches Coq: Lemma CP_053_global_progress_msg)
; CP_053_global_progress_msg: forall p q t g, exists g', GlobalStep (GMsg p q t g) g'
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_053_global_progress_msg [partial: bindings preserved]

; CP_054_global_progress_branch (matches Coq: Lemma CP_054_global_progress_branch)
; CP_054_global_progress_branch: forall p q l1 g1 l2 g2, exists g', GlobalStep (GBranch p q l1 g1 l2 g2) g'
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_054_global_progress_branch [partial: bindings preserved]

; CP_055_global_progress_rec (matches Coq: Lemma CP_055_global_progress_rec)
; CP_055_global_progress_rec: forall n g, exists g', GlobalStep (GRec n g) g'
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CP_055_global_progress_rec [partial: bindings preserved]

; CP_056_global_progress_or_terminal (matches Coq: Theorem CP_056_global_progress_or_terminal)
; CP_056_global_progress_or_terminal: forall g, well_formed_global g -> (exists g', GlobalStep g g') \/ g = GEnd \/ (exists n, g = GVar n)
(assert (forall ((g Bool)) (= 0 0))) ; CP_056_global_progress_or_terminal [partial: bindings preserved]

; CP_057_typed_network_empty (matches Coq: Lemma CP_057_typed_network_empty)
; CP_057_typed_network_empty: forall g, typed_network g []
(assert (forall ((g Bool)) (= 0 0))) ; CP_057_typed_network_empty [partial: bindings preserved]

; CP_058_typed_network_cons (matches Coq: Lemma CP_058_typed_network_cons)
; CP_058_typed_network_cons: forall g r l net, l = project g r -> typed_network g net -> typed_network g ((r, l) :: net)
(assert (forall ((g Bool) (r Bool) (l Bool) (net Bool)) (= 0 0))) ; CP_058_typed_network_cons [partial: bindings preserved]

; CP_059_typed_network_of (matches Coq: Lemma CP_059_typed_network_of)
; CP_059_typed_network_of: forall g roles, typed_network g (network_of g roles)
(assert (forall ((g Bool) (roles Bool)) (= 0 0))) ; CP_059_typed_network_of [partial: bindings preserved]

; CP_060_typed_network_lookup (matches Coq: Lemma CP_060_typed_network_lookup)
; CP_060_typed_network_lookup: forall g net r l, typed_network g net -> In (r, l) net -> l = project g r
(assert (forall ((g Bool) (net Bool) (r Bool) (l Bool)) (= 0 0))) ; CP_060_typed_network_lookup [partial: bindings preserved]

; CP_061_network_step_comm (matches Coq: Lemma CP_061_network_step_comm)
; CP_061_network_step_comm: forall p q t g, p <> q -> GlobalStep (GMsg p q t g) g -> LocalStep (project (GMsg p q t g) p) (project g p)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_061_network_step_comm [partial: bindings preserved]

; CP_062_network_step_recv (matches Coq: Lemma CP_062_network_step_recv)
; CP_062_network_step_recv: forall p q t g, p <> q -> GlobalStep (GMsg p q t g) g -> LocalStep (project (GMsg p q t g) q) (project g q)
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_062_network_step_recv [partial: bindings preserved]

; CP_063_network_no_deadlock (matches Coq: Lemma CP_063_network_no_deadlock)
; CP_063_network_no_deadlock: forall g roles, well_formed_global g -> ~ chor_deadlocked (network_of g roles)
(assert (forall ((g Bool) (roles Bool)) (= 0 0))) ; CP_063_network_no_deadlock [partial: bindings preserved]

; CP_064_network_empty_end (matches Coq: Lemma CP_064_network_empty_end)
; CP_064_network_empty_end: typed_network GEnd []
(assert (= 0 0)) ; CP_064_network_empty_end [Coq-only]

; CP_065_protocol_fidelity_send (matches Coq: Theorem CP_065_protocol_fidelity_send)
; CP_065_protocol_fidelity_send: forall p q t g, p <> q -> exists l, project (GMsg p q t g) p = LSend q t l /\ l = project g p
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_065_protocol_fidelity_send [partial: bindings preserved]

; CP_066_protocol_fidelity_recv (matches Coq: Theorem CP_066_protocol_fidelity_recv)
; CP_066_protocol_fidelity_recv: forall p q t g, p <> q -> exists l, project (GMsg p q t g) q = LRecv p t l /\ l = project g q
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_066_protocol_fidelity_recv [partial: bindings preserved]

; CP_067_session_fidelity (matches Coq: Theorem CP_067_session_fidelity)
; CP_067_session_fidelity: forall p q t g, p <> q -> match project (GMsg p q t g) p, project (GMsg p q t g) q with | LSend _ t1 _, LRecv _ t2 _ => 
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_067_session_fidelity [partial: bindings preserved]

; CP_068_linearity_msg (matches Coq: Lemma CP_068_linearity_msg)
; CP_068_linearity_msg: forall p q t g g', GlobalStep (GMsg p q t g) g' -> g' = g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (g_ Bool)) (= 0 0))) ; CP_068_linearity_msg [partial: bindings preserved]

; CP_069_completeness_end (matches Coq: Lemma CP_069_completeness_end)
; CP_069_completeness_end: exists g, project g 0 = LEnd
(assert (= 0 0)) ; CP_069_completeness_end [Coq-only]

; CP_069_completeness_var (matches Coq: Lemma CP_069_completeness_var)
; CP_069_completeness_var: forall n, exists g, project g 0 = LVar n
(assert (forall ((n Bool)) (= 0 0))) ; CP_069_completeness_var [partial: bindings preserved]

; CP_069_completeness_send (matches Coq: Lemma CP_069_completeness_send)
; CP_069_completeness_send: forall r t l, (exists g, project g 0 = l) -> exists g, project g 0 = LSend r t l
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CP_069_completeness_send [partial: bindings preserved]

; CP_069_completeness_recv (matches Coq: Lemma CP_069_completeness_recv)
; CP_069_completeness_recv: forall r t l, r <> 0 -> (exists g, project g 0 = l) -> exists g, project g 0 = LRecv r t l
(assert (forall ((r Bool) (t Bool) (l Bool)) (= 0 0))) ; CP_069_completeness_recv [partial: bindings preserved]

; CP_070_subst_local_end (matches Coq: Lemma CP_070_subst_local_end)
; CP_070_subst_local_end: forall x s, subst_local x s LEnd = LEnd
(assert (forall ((x Bool) (s Bool)) (= 0 0))) ; CP_070_subst_local_end [partial: bindings preserved]

; CP_071_subst_local_var_same (matches Coq: Lemma CP_071_subst_local_var_same)
; CP_071_subst_local_var_same: forall x s, subst_local x s (LVar x) = s
(assert (forall ((x Bool) (s Bool)) (= 0 0))) ; CP_071_subst_local_var_same [partial: bindings preserved]

; CP_072_subst_local_var_diff (matches Coq: Lemma CP_072_subst_local_var_diff)
; CP_072_subst_local_var_diff: forall x y s, x <> y -> subst_local x s (LVar y) = LVar y
(assert (forall ((x Bool) (y Bool) (s Bool)) (= 0 0))) ; CP_072_subst_local_var_diff [partial: bindings preserved]

; CP_073_subst_local_rec_same (matches Coq: Lemma CP_073_subst_local_rec_same)
; CP_073_subst_local_rec_same: forall x l s, subst_local x s (LRec x l) = LRec x l
(assert (forall ((x Bool) (l Bool) (s Bool)) (= 0 0))) ; CP_073_subst_local_rec_same [partial: bindings preserved]

; CP_074_subst_local_rec_diff (matches Coq: Lemma CP_074_subst_local_rec_diff)
; CP_074_subst_local_rec_diff: forall x y l s, x <> y -> subst_local x s (LRec y l) = LRec y (subst_local x s l)
(assert (forall ((x Bool) (y Bool) (l Bool) (s Bool)) (= 0 0))) ; CP_074_subst_local_rec_diff [partial: bindings preserved]

; CP_075_subst_local_send (matches Coq: Lemma CP_075_subst_local_send)
; CP_075_subst_local_send: forall x s r t l, subst_local x s (LSend r t l) = LSend r t (subst_local x s l)
(assert (forall ((x Bool) (s Bool) (r Bool) (t Bool) (l Bool)) (= 0 0))) ; CP_075_subst_local_send [partial: bindings preserved]

; CP_076_subst_local_recv (matches Coq: Lemma CP_076_subst_local_recv)
; CP_076_subst_local_recv: forall x s r t l, subst_local x s (LRecv r t l) = LRecv r t (subst_local x s l)
(assert (forall ((x Bool) (s Bool) (r Bool) (t Bool) (l Bool)) (= 0 0))) ; CP_076_subst_local_recv [partial: bindings preserved]

; CP_077_rec_unfold_well_formed (matches Coq: Lemma CP_077_rec_unfold_well_formed)
; CP_077_rec_unfold_well_formed: forall n g, well_formed_global (GRec n g) -> well_formed_global g
(assert (forall ((n Bool) (g Bool)) (= 0 0))) ; CP_077_rec_unfold_well_formed [partial: bindings preserved]

; CP_078_project_msg_chain (matches Coq: Lemma CP_078_project_msg_chain)
; CP_078_project_msg_chain: forall p1 q1 t1 p2 q2 t2 g r, r = p1 -> p1 <> q1 -> p2 <> q2 -> project (GMsg p1 q1 t1 (GMsg p2 q2 t2 g)) r = LSend q1 t
(assert (forall ((p1 Bool) (q1 Bool) (t1 Bool) (p2 Bool) (q2 Bool) (t2 Bool) (g Bool) (r Bool)) (= 0 0))) ; CP_078_project_msg_chain [partial: bindings preserved]

; CP_079_project_msg_recv_chain (matches Coq: Lemma CP_079_project_msg_recv_chain)
; CP_079_project_msg_recv_chain: forall p q t1 t2 g, p <> q -> project (GMsg p q t1 (GMsg q p t2 g)) p = LSend q t1 (LRecv q t2 (project g p))
(assert (forall ((p Bool) (q Bool) (t1 Bool) (t2 Bool) (g Bool)) (= 0 0))) ; CP_079_project_msg_recv_chain [partial: bindings preserved]

; CP_080_project_msg_recv_chain_q (matches Coq: Lemma CP_080_project_msg_recv_chain_q)
; CP_080_project_msg_recv_chain_q: forall p q t1 t2 g, p <> q -> project (GMsg p q t1 (GMsg q p t2 g)) q = LRecv p t1 (LSend p t2 (project g q))
(assert (forall ((p Bool) (q Bool) (t1 Bool) (t2 Bool) (g Bool)) (= 0 0))) ; CP_080_project_msg_recv_chain_q [partial: bindings preserved]

; CP_081_dual_project_msg_sender (matches Coq: Lemma CP_081_dual_project_msg_sender)
; CP_081_dual_project_msg_sender: forall p q t g, local_dual (project (GMsg p q t g) p) = LRecv q t (local_dual (project g p))
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_081_dual_project_msg_sender [partial: bindings preserved]

; CP_082_dual_project_msg_receiver (matches Coq: Lemma CP_082_dual_project_msg_receiver)
; CP_082_dual_project_msg_receiver: forall p q t g, p <> q -> local_dual (project (GMsg p q t g) q) = LSend p t (local_dual (project g q))
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_082_dual_project_msg_receiver [partial: bindings preserved]

; CP_083_dual_project_end (matches Coq: Lemma CP_083_dual_project_end)
; CP_083_dual_project_end: forall r, local_dual (project GEnd r) = LEnd
(assert (forall ((r Bool)) (= 0 0))) ; CP_083_dual_project_end [partial: bindings preserved]

; CP_084_dual_project_var (matches Coq: Lemma CP_084_dual_project_var)
; CP_084_dual_project_var: forall n r, local_dual (project (GVar n) r) = LVar n
(assert (forall ((n Bool) (r Bool)) (= 0 0))) ; CP_084_dual_project_var [partial: bindings preserved]

; CP_085_dual_project_rec (matches Coq: Lemma CP_085_dual_project_rec)
; CP_085_dual_project_rec: forall n g r, local_dual (project (GRec n g) r) = LRec n (local_dual (project g r))
(assert (forall ((n Bool) (g Bool) (r Bool)) (= 0 0))) ; CP_085_dual_project_rec [partial: bindings preserved]

; CP_086_dual_preserves_mergeable (matches Coq: Lemma CP_086_dual_preserves_mergeable)
; CP_086_dual_preserves_mergeable: forall l1 l2, mergeable l1 l2 -> mergeable (local_dual l1) (local_dual l2)
(assert (forall ((l1 Bool) (l2 Bool)) (= 0 0))) ; CP_086_dual_preserves_mergeable [partial: bindings preserved]

; CP_087_wf_step_preserves (matches Coq: Lemma CP_087_wf_step_preserves)
; CP_087_wf_step_preserves: forall g g', well_formed_global g -> GlobalStep g g' -> well_formed_global g' \/ (exists n body, g = GRec n body /\ g' =
(assert (forall ((g Bool) (g_ Bool)) (= 0 0))) ; CP_087_wf_step_preserves [partial: bindings preserved]

; CP_088_wf_comm_step (matches Coq: Lemma CP_088_wf_comm_step)
; CP_088_wf_comm_step: forall p q t g, well_formed_global (GMsg p q t g) -> well_formed_global g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_088_wf_comm_step [partial: bindings preserved]

; CP_089_wf_branch_step_left (matches Coq: Lemma CP_089_wf_branch_step_left)
; CP_089_wf_branch_step_left: forall p q l1 g1 l2 g2, well_formed_global (GBranch p q l1 g1 l2 g2) -> well_formed_global g1
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_089_wf_branch_step_left [partial: bindings preserved]

; CP_090_wf_branch_step_right (matches Coq: Lemma CP_090_wf_branch_step_right)
; CP_090_wf_branch_step_right: forall p q l1 g1 l2 g2, well_formed_global (GBranch p q l1 g1 l2 g2) -> well_formed_global g2
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_090_wf_branch_step_right [partial: bindings preserved]

; CP_091_project_step_uninvolved (matches Coq: Lemma CP_091_project_step_uninvolved)
; CP_091_project_step_uninvolved: forall p q t g r, r <> p -> r <> q -> project (GMsg p q t g) r = project g r
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool) (r Bool)) (= 0 0))) ; CP_091_project_step_uninvolved [partial: bindings preserved]

; CP_092_project_gend_all_lend (matches Coq: Lemma CP_092_project_gend_all_lend)
; CP_092_project_gend_all_lend: forall roles, Forall (fun r => project GEnd r = LEnd) roles
(assert (forall ((roles Bool)) (= 0 0))) ; CP_092_project_gend_all_lend [partial: bindings preserved]

; CP_093_all_roles_end (matches Coq: Lemma CP_093_all_roles_end)
; CP_093_all_roles_end: forall g, g = GEnd -> forall r, project g r = LEnd
(assert (forall ((g Bool)) (= 0 0))) ; CP_093_all_roles_end [partial: bindings preserved]

; CP_094_step_reduces_msg (matches Coq: Lemma CP_094_step_reduces_msg)
; CP_094_step_reduces_msg: forall p q t g, global_size (GMsg p q t g) > global_size g
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_094_step_reduces_msg [partial: bindings preserved]

; CP_095_step_reduces_branch (matches Coq: Lemma CP_095_step_reduces_branch)
; CP_095_step_reduces_branch: forall p q l1 g1 l2 g2, global_size (GBranch p q l1 g1 l2 g2) > global_size g1 /\ global_size (GBranch p q l1 g1 l2 g2) 
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool)) (= 0 0))) ; CP_095_step_reduces_branch [partial: bindings preserved]

; CP_096_wf_distinct_projection (matches Coq: Lemma CP_096_wf_distinct_projection)
; CP_096_wf_distinct_projection: forall p q t g, p <> q -> well_formed_global (GMsg p q t g) -> project (GMsg p q t g) p <> project (GMsg p q t g) q
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_096_wf_distinct_projection [partial: bindings preserved]

; CP_097_merge_compat_implies_eq (matches Coq: Lemma CP_097_merge_compat_implies_eq)
; CP_097_merge_compat_implies_eq: forall p q l1 g1 l2 g2 r, merge_compatible (GBranch p q l1 g1 l2 g2) -> r <> p -> r <> q -> project (GBranch p q l1 g1 l
(assert (forall ((p Bool) (q Bool) (l1 Bool) (g1 Bool) (l2 Bool) (g2 Bool) (r Bool)) (= 0 0))) ; CP_097_merge_compat_implies_eq [partial: bindings preserved]

; CP_098_branch_end_merge (matches Coq: Lemma CP_098_branch_end_merge)
; CP_098_branch_end_merge: forall p q l1 l2 r, r <> p -> r <> q -> project (GBranch p q l1 GEnd l2 GEnd) r = LEnd
(assert (forall ((p Bool) (q Bool) (l1 Bool) (l2 Bool) (r Bool)) (= 0 0))) ; CP_098_branch_end_merge [partial: bindings preserved]

; CP_099_subject_reduction (matches Coq: Theorem CP_099_subject_reduction)
; CP_099_subject_reduction: forall g g', well_formed_global g -> GlobalStep g g' -> forall p q, p <> q -> (forall r, r <> p -> r <> q -> match g wit
(assert (forall ((g Bool) (g_ Bool)) (= 0 0))) ; CP_099_subject_reduction [partial: bindings preserved]

; CP_100_subject_reduction_full (matches Coq: Theorem CP_100_subject_reduction_full)
; CP_100_subject_reduction_full: forall p q t g, p <> q -> well_formed_global (GMsg p q t g) -> (project (GMsg p q t g) p = LSend q t (project g p)) /\ (
(assert (forall ((p Bool) (q Bool) (t Bool) (g Bool)) (= 0 0))) ; CP_100_subject_reduction_full [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
