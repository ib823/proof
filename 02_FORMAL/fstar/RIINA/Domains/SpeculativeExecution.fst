(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/SpeculativeExecution.v (20 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.SpeculativeExecution
open FStar.All

(* effect (matches Coq) *)
type ty_effect =
  | Eff_pure
  | Eff_timed
  | Eff_speculative

(* visibility (matches Coq) *)
type visibility =
  | Public
  | Secret

(* value (matches Coq) *)
type value =
  | VNat of nat
  | VBool of bool

(* instr (matches Coq) *)
type instr =
  | IConst of value
  | IBinop of (instr * instr)
  | IBranch of (visibility * instr * instr * instr)
  | ISeq of (instr * instr)
  | IAnnot of (ty_effect * instr)

(* eff_le (matches Coq: Definition eff_le) *)
let eff_le (p_e1: ty_effect) (p_e2: ty_effect) : Tot bool =
  match p_e1, p_e2 with
  | Eff_pure, _ -> true
  | Eff_timed, Eff_pure -> false
  | Eff_timed, _ -> true
  | Eff_speculative, Eff_speculative -> true
  | Eff_speculative, _ -> false
  | _ -> false

(* eff_join (matches Coq: Definition eff_join) *)
let eff_join (p_e1: ty_effect) (p_e2: ty_effect) : Tot ty_effect =
  match p_e1, p_e2 with
  | e, Eff_pure -> e
  | _, Eff_speculative -> Eff_speculative
  | Eff_timed, Eff_timed -> Eff_timed
  | _ -> EffPure

(* infer_effect (matches Coq: Fixpoint infer_effect) *)
let rec infer_effect (p_i: instr) : Tot ty_effect =
  match p_i with
  | IConst _ -> Eff_pure
  | IBinop (a, b) -> eff_join (infer_effect a) (infer_effect b)
  | IBranch (Secret, _, t, f) -> eff_join Eff_speculative (eff_join (infer_effect t) (infer_effect f))
  | IBranch (Public, c, t, f) -> eff_join (infer_effect c) (eff_join (infer_effect t) (infer_effect f))
  | ISeq (a, b) -> eff_join (infer_effect a) (infer_effect b)
  | IAnnot (e, sub) -> eff_join e (infer_effect sub)
  | _ -> EffPure

(* is_constant_time (matches Coq: Fixpoint is_constant_time) *)
let rec is_constant_time (p_i: instr) : Tot bool =
  match p_i with
  | IConst _ -> true
  | IBinop (a, b) -> is_constant_time a && is_constant_time b
  | IBranch (Secret, _, _, _) -> false
  | IBranch (Public, c, t, f) -> is_constant_time c && is_constant_time t && is_constant_time f
  | ISeq (a, b) -> is_constant_time a && is_constant_time b
  | IAnnot (_, sub) -> is_constant_time sub
  | _ -> false

(* is_spec_safe (matches Coq: Definition is_spec_safe) *)
let is_spec_safe (p_i: instr) : Tot bool =
  (not (match infer_effect p_i with
  | Eff_speculative -> true
  | _ -> false))

(* eval_instr (matches Coq: Fixpoint eval_instr) *)
let rec eval_instr (p_i: instr) : Tot nat =
  match p_i with
  | IConst v -> Some v
  | IBinop (a, b) -> match eval_instr a, eval_instr b with
  | Some ((VNat x),, Some, (VNat y)) -> Some (VNat (x + y))
  | _, _ -> None
  | _ -> 0 | IBranch _ c t f => match eval_instr c with
  | Some (VBool true) -> eval_instr t
  | Some (VBool false) -> eval_instr f
  | _ -> None | ISeq a b => match eval_instr a with
  | Some _ -> eval_instr b
  | None -> None
  | _ -> 0 | IAnnot _ sub => eval_instr sub end

(* no_speculative_annotation (matches Coq: Fixpoint no_speculative_annotation) *)
let rec no_speculative_annotation (p_i: instr) : Tot bool =
  match p_i with
  | IConst _ -> true
  | IBinop (a, b) -> no_speculative_annotation a && no_speculative_annotation b
  | IBranch (_, c, t, f) -> no_speculative_annotation c && no_speculative_annotation t && no_speculative_annotation f
  | ISeq (a, b) -> no_speculative_annotation a && no_speculative_annotation b
  | IAnnot (Eff_speculative, _) -> false
  | IAnnot (_, sub) -> no_speculative_annotation sub
  | _ -> false

(* eff_join_pure_l (matches Coq: Lemma eff_join_pure_l) *)
let eff_join_pure_l (p_e: _) : Lemma (eff_join Eff_pure p_e == p_e) = ()

(* eff_join_pure_r (matches Coq: Lemma eff_join_pure_r) *)
let eff_join_pure_r (p_e: _) : Lemma (eff_join p_e Eff_pure == p_e) = ()

(* eff_le_refl (matches Coq: Lemma eff_le_refl) *)
let eff_le_refl (p_e: _) : Lemma (eff_le p_e p_e == true) = ()

(* eff_le_trans (matches Coq: Lemma eff_le_trans) *)
let eff_le_trans (p_e1: _) (p_e2: _) (p_e3: _) : Lemma (requires (eff_le p_e1 p_e2 == true /\ eff_le p_e2 p_e3 == true)) (ensures (eff_le p_e1 p_e3 == true)) = ()

(* pure_is_constant_time (matches Coq: Theorem pure_is_constant_time) *)
let pure_is_constant_time (p_i: _) : Lemma (requires (infer_effect p_i == Eff_pure)) (ensures (is_constant_time p_i == true)) = ()

(* ct_composition (matches Coq: Theorem ct_composition) *)
let ct_composition (p_a: _) (p_b: _) : Lemma (requires (is_constant_time p_a == true /\ is_constant_time p_b == true)) (ensures (is_constant_time (ISeq p_a p_b) == true)) = ()

(* no_secret_branch (matches Coq: Lemma no_secret_branch) *)
let no_secret_branch (p_i: _) : Lemma (requires (is_constant_time p_i == true)) (ensures ((forall (c: _). (forall (t: _). (forall (f: _). ~(p_i == IBranch Secret c t f)))))) = ()

(* spec_safe_no_secret_branch_aux (matches Coq: Lemma spec_safe_no_secret_branch_aux) *)
let spec_safe_no_secret_branch_aux (p_i: _) : Lemma (requires (no_speculative_annotation p_i == true /\ ~(infer_effect p_i == Eff_speculative))) (ensures (is_constant_time p_i == true)) = ()

(* spec_safe_implies_no_secret_leakage (matches Coq: Theorem spec_safe_implies_no_secret_leakage) *)
let spec_safe_implies_no_secret_leakage (p_i: _) : Lemma (requires (no_speculative_annotation p_i == true /\ is_spec_safe p_i == true)) (ensures (is_constant_time p_i == true)) = ()

(* effect_preorder_refl (matches Coq: Theorem effect_preorder_refl) *)
let effect_preorder_refl (p_e: _) : Lemma (eff_le p_e p_e == true) = ()

(* effect_preorder_trans (matches Coq: Theorem effect_preorder_trans) *)
let effect_preorder_trans (p_e1: _) (p_e2: _) (p_e3: _) : Lemma (requires (eff_le p_e1 p_e2 == true /\ eff_le p_e2 p_e3 == true)) (ensures (eff_le p_e1 p_e3 == true)) = ()

(* pure_is_bottom (matches Coq: Theorem pure_is_bottom) *)
let pure_is_bottom (p_e: _) : Lemma (eff_le Eff_pure p_e == true) = ()

(* seq_preserves_spec_safe (matches Coq: Theorem seq_preserves_spec_safe) *)
let seq_preserves_spec_safe (p_a: _) (p_b: _) : Lemma (requires (is_spec_safe p_a == true /\ is_spec_safe p_b == true)) (ensures (is_spec_safe (ISeq p_a p_b) == true)) = ()

(* public_branch_ct (matches Coq: Theorem public_branch_ct) *)
let public_branch_ct (p_c: _) (p_t: _) (p_f: _) : Lemma (requires (is_constant_time p_c == true /\ is_constant_time p_t == true /\ is_constant_time p_f == true)) (ensures (is_constant_time (IBranch Public p_c p_t p_f) == true)) = ()

(* annotation_soundness (matches Coq: Theorem annotation_soundness) *)
let annotation_soundness (p_e: _) (p_i: _) : Lemma (requires (eff_le (infer_effect p_i) p_e == true)) (ensures (eff_le (infer_effect (IAnnot p_e p_i)) p_e == true)) = ()

(* binop_preserves_ct (matches Coq: Theorem binop_preserves_ct) *)
let binop_preserves_ct (p_a: _) (p_b: _) : Lemma (requires (is_constant_time p_a == true /\ is_constant_time p_b == true)) (ensures (is_constant_time (IBinop p_a p_b) == true)) = ()

(* pure_implies_spec_safe (matches Coq: Theorem pure_implies_spec_safe) *)
let pure_implies_spec_safe (p_i: _) : Lemma (requires (infer_effect p_i == Eff_pure)) (ensures (is_spec_safe p_i == true)) = ()

(* timed_implies_spec_safe (matches Coq: Theorem timed_implies_spec_safe) *)
let timed_implies_spec_safe (p_i: _) : Lemma (requires (infer_effect p_i == Eff_timed)) (ensures (is_spec_safe p_i == true)) = ()

(* const_is_pure (matches Coq: Theorem const_is_pure) *)
let const_is_pure (p_v: _) : Lemma (infer_effect (IConst p_v) == Eff_pure) = ()

(* eff_join_comm (matches Coq: Theorem eff_join_comm) *)
let eff_join_comm (p_e1: _) (p_e2: _) : Lemma (eff_join p_e1 p_e2 == eff_join p_e2 p_e1) = ()
