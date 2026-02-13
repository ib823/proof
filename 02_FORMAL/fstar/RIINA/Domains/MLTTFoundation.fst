(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/MLTTFoundation.v (25 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.MLTTFoundation
open FStar.All

(* Ty (matches Coq) *)
type ty =
  | TUnit
  | TPi of (ty * ty)
  | TSigma of (ty * ty)
  | TId of ty
  | TUniverse of nat

(* Term (matches Coq) *)
type term =
  | TmVar of nat
  | TmUnit
  | TmLam of (ty * term)
  | TmApp of (term * term)
  | TmPair of (term * term)
  | TmFst of term
  | TmSnd of term
  | TmRefl of term
  | TmJ of (ty * ty * term * term)

(* has_level — Coq Prop predicate stub *)
assume val has_level : ty -> nat -> bool

(* wf_ctx — Coq Prop predicate stub *)
assume val wf_ctx : nat -> bool

(* wf_ty — Coq Prop predicate stub *)
assume val wf_ty : nat -> ty -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> term -> ty -> bool

(* ty_eq — Coq Prop predicate stub *)
assume val ty_eq : ty -> ty -> bool

(* term_eq — Coq Prop predicate stub *)
assume val term_eq : term -> term -> bool

(* reduces — Coq Prop predicate stub *)
assume val reduces : term -> term -> bool

(* reduces_star — Coq Prop predicate stub *)
assume val reduces_star : term -> term -> bool

(* neutral — Coq Prop predicate stub *)
assume val neutral : term -> bool

(* normal — Coq Prop predicate stub *)
assume val normal : term -> bool

(* comp_eq — Coq Prop predicate stub *)
assume val comp_eq : term -> term -> bool

(* empty_ctx (matches Coq: Definition empty_ctx) *)
let empty_ctx : nat = []

(* ctx_extend (matches Coq: Definition ctx_extend) *)
let ctx_extend (p_g: nat) (p_a: ty) : Tot nat =
  p_a :: p_g

(* ctx_lookup (matches Coq: Fixpoint ctx_lookup) *)
let rec ctx_lookup (p_g: nat) (p_n: nat) : Tot nat =
  match p_g with
  | [] -> None
  | A :: p_g' -> if (p_n = 0) then Some A else ctx_lookup p_g' (p_n - 1)
  | _ -> 0

(* shift (matches Coq: Fixpoint shift) *)
let rec shift (p_c: nat) (p_d: nat) (p_t: term) : Tot term =
  match p_t with
  | TmVar n -> if p_c <= n then TmVar (n + p_d) else TmVar n
  | TmUnit -> TmUnit
  | TmLam (A, p_t') -> TmLam A (shift (((p_c) + 1)) p_d p_t')
  | TmApp (f, a) -> TmApp (shift p_c p_d f) (shift p_c p_d a)
  | TmPair (a, b) -> TmPair (shift p_c p_d a) (shift p_c p_d b)
  | TmFst p -> TmFst (shift p_c p_d p)
  | TmSnd p -> TmSnd (shift p_c p_d p)
  | TmRefl a -> TmRefl (shift p_c p_d a)
  | TmJ (A, C, p_d', p) -> TmJ A C (shift p_c p_d p_d') (shift p_c p_d p)
  | _ -> (* TODO: default value for term *) admit()

(* subst (matches Coq: Fixpoint subst) *)
let rec subst (p_n: nat) (p_s: term) (p_t: term) : Tot term =
  match p_t with
  | TmVar m -> if (p_n = m) then p_s else if p_n < m then TmVar (m - 1) else TmVar m
  | TmUnit -> TmUnit
  | TmLam (A, p_t') -> TmLam A (subst (((p_n) + 1)) (shift 0 1 p_s) p_t')
  | TmApp (f, a) -> TmApp (subst p_n p_s f) (subst p_n p_s a)
  | TmPair (a, b) -> TmPair (subst p_n p_s a) (subst p_n p_s b)
  | TmFst p -> TmFst (subst p_n p_s p)
  | TmSnd p -> TmSnd (subst p_n p_s p)
  | TmRefl a -> TmRefl (subst p_n p_s a)
  | TmJ (A, C, d, p) -> TmJ A C (subst p_n p_s d) (subst p_n p_s p)
  | _ -> (* TODO: default value for term *) admit()

(* cumulativity_level (matches Coq: Lemma cumulativity_level) *)
let cumulativity_level (p_a: _) (p_l: _) : Lemma (requires (has_level p_a p_l == true)) (ensures (has_level p_a ((p_l + 1)) == true)) = admit ()

(* TYPE_001_01 (matches Coq: Theorem TYPE_001_01) *)
let type_001_01 (p_g: nat) (p_a: ty) (p_b: ty) : Lemma (requires (wf_ctx p_g == true /\ wf_ty p_g p_a == true /\ wf_ty (ctx_extend p_g p_a) p_b == true)) (ensures (wf_ty p_g (TPi p_a p_b) == true)) = admit ()

(* TYPE_001_02 (matches Coq: Theorem TYPE_001_02) *)
let type_001_02 (p_g: nat) (p_a: ty) (p_b: ty) (p_f: term) (p_a: term) : Lemma (requires (has_type p_g p_f (TPi p_a p_b) == true /\ has_type p_g p_a p_a == true)) (ensures (has_type p_g (TmApp p_f p_a) p_b == true)) = admit ()

(* TYPE_001_03 (matches Coq: Theorem TYPE_001_03) *)
let type_001_03 (p_g: nat) (p_a: ty) (p_b: ty) (p_a: term) (p_b: term) : Lemma (requires (wf_ty p_g (TSigma p_a p_b) == true /\ has_type p_g p_a p_a == true /\ has_type p_g p_b p_b == true)) (ensures (has_type p_g (TmPair p_a p_b) (TSigma p_a p_b) == true)) = admit ()

(* TYPE_001_04 (matches Coq: Theorem TYPE_001_04) *)
let type_001_04 (p_g: nat) (p_a: ty) (p_b: ty) (p_p: term) : Lemma (requires (has_type p_g p_p (TSigma p_a p_b) == true)) (ensures (has_type p_g (TmFst p_p) p_a == true /\ has_type p_g (TmSnd p_p) p_b == true)) = admit ()

(* TYPE_001_05 (matches Coq: Theorem TYPE_001_05) *)
let type_001_05 (p_g: nat) (p_a: ty) (p_a: term) : Lemma (requires (wf_ty p_g p_a == true /\ has_type p_g p_a p_a == true)) (ensures (has_type p_g (TmRefl p_a) (TId p_a) == true)) = admit ()

(* TYPE_001_06 (matches Coq: Theorem TYPE_001_06) *)
let type_001_06 (p_g: nat) (p_a: ty) (p_c: ty) (p_d: term) (p_p: term) : Lemma (requires (wf_ty p_g p_a == true /\ has_type p_g p_d p_c == true /\ has_type p_g p_p (TId p_a) == true)) (ensures (has_type p_g (TmJ p_a p_c p_d p_p) p_c == true)) = admit ()

(* TYPE_001_07 (matches Coq: Theorem TYPE_001_07) *)
let type_001_07 (p_l: _) : Lemma (has_level (TUniverse p_l) ((p_l + 1)) == true) = admit ()

(* TYPE_001_08 (matches Coq: Theorem TYPE_001_08) *)
let type_001_08 (p_a: ty) (p_l: nat) : Lemma (requires (has_level p_a p_l == true)) (ensures (has_level p_a ((p_l + 1)) == true)) = admit ()

(* TYPE_001_09 (matches Coq: Theorem TYPE_001_09) *)
let type_001_09 (p_g: nat) (p_a: ty) : Lemma (requires (wf_ctx p_g == true)) (ensures (wf_ctx (ctx_extend p_g p_a) == true)) = admit ()

(* TYPE_001_10 (matches Coq: Theorem TYPE_001_10) *)
let type_001_10 (p_t1: _) (p_t2: _) (p_n: _) (p_s: _) : Lemma (requires (term_eq p_t1 p_t2 == true)) (ensures (term_eq (subst p_n p_s p_t1) (subst p_n p_s p_t2) == true)) = admit ()

(* type_uniqueness_eq (matches Coq: Lemma type_uniqueness_eq) *)
let type_uniqueness_eq (p_g: nat) (p_t: _) (p_a: _) (p_b: _) : Lemma (requires (has_type p_g p_t p_a == true /\ has_type p_g p_t p_b == true)) (ensures (p_a == p_b)) = admit ()

(* TYPE_001_11 (matches Coq: Theorem TYPE_001_11) *)
let type_001_11 (p_g: nat) (p_t: _) (p_a: _) (p_b: _) : Lemma (requires (has_type p_g p_t p_a == true /\ has_type p_g p_t p_b == true)) (ensures (ty_eq p_a p_b == true)) = admit ()

(* TYPE_001_12 (matches Coq: Theorem TYPE_001_12) *)
let type_001_12 (p_a: _) (p_t: _) (p_a: _) : Lemma (comp_eq (TmApp (TmLam p_a p_t) p_a) (subst 0 p_a p_t) == true) = admit ()

(* TYPE_001_13 (matches Coq: Theorem TYPE_001_13) *)
let type_001_13 (p_a: _) (p_f: _) : Lemma (comp_eq (TmLam p_a (TmApp (shift 0 1 p_f) (TmVar 0))) p_f == true) = admit ()

(* TYPE_001_14 (matches Coq: Theorem TYPE_001_14) *)
let type_001_14 (p_p: _) : Lemma (comp_eq (TmPair (TmFst p_p) (TmSnd p_p)) p_p == true) = admit ()

(* red_star_trans (matches Coq: Lemma red_star_trans) *)
let red_star_trans (p_t: _) (p_u: _) (p_v: _) : Lemma (requires (reduces_star p_t p_u == true /\ reduces_star p_u p_v == true)) (ensures (reduces_star p_t p_v == true)) = admit ()

(* red_star_app (matches Coq: Lemma red_star_app) *)
let red_star_app (p_f: _) (p_f_: _) (p_a: _) (p_a_: _) : Lemma (requires (reduces_star p_f p_f_ == true /\ reduces_star p_a p_a_ == true)) (ensures (reduces_star (TmApp p_f p_a) (TmApp p_f_ p_a_) == true)) = admit ()

(* red_star_lam (matches Coq: Lemma red_star_lam) *)
let red_star_lam (p_a: _) (p_body: _) (p_body_: _) : Lemma (requires (reduces_star p_body p_body_ == true)) (ensures (reduces_star (TmLam p_a p_body) (TmLam p_a p_body_) == true)) = admit ()

(* red_star_pair (matches Coq: Lemma red_star_pair) *)
let red_star_pair (p_a: _) (p_a_: _) (p_b: _) (p_b_: _) : Lemma (requires (reduces_star p_a p_a_ == true /\ reduces_star p_b p_b_ == true)) (ensures (reduces_star (TmPair p_a p_b) (TmPair p_a_ p_b_) == true)) = admit ()

(* red_star_fst (matches Coq: Lemma red_star_fst) *)
let red_star_fst (p_p: _) (p_p_: _) : Lemma (requires (reduces_star p_p p_p_ == true)) (ensures (reduces_star (TmFst p_p) (TmFst p_p_) == true)) = admit ()

(* red_star_snd (matches Coq: Lemma red_star_snd) *)
let red_star_snd (p_p: _) (p_p_: _) : Lemma (requires (reduces_star p_p p_p_ == true)) (ensures (reduces_star (TmSnd p_p) (TmSnd p_p_) == true)) = admit ()

(* red_star_refl_tm (matches Coq: Lemma red_star_refl_tm) *)
let red_star_refl_tm (p_a: _) (p_a_: _) : Lemma (requires (reduces_star p_a p_a_ == true)) (ensures (reduces_star (TmRefl p_a) (TmRefl p_a_) == true)) = admit ()

(* red_star_J (matches Coq: Lemma red_star_J) *)
let red_star_j (p_a: _) (p_c: _) (p_d: _) (p_d_: _) (p_p: _) (p_p_: _) : Lemma (requires (reduces_star p_d p_d_ == true /\ reduces_star p_p p_p_ == true)) (ensures (reduces_star (TmJ p_a p_c p_d p_p) (TmJ p_a p_c p_d_ p_p_) == true)) = admit ()

(* TYPE_001_15 (matches Coq: Theorem TYPE_001_15) *)
let type_001_15 (p_t: _) : Lemma (((exists p_nf. reduces_star p_t p_nf == true) /\ (normal nf == true \/ neutral nf == true))) = admit ()
