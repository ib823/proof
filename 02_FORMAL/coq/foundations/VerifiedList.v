(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Collections — Verified Core List Algorithms

    A foundational model of the prototype's first-order list builtins
    (`riina-codegen/src/builtins/senarai.rs`: `senarai_balik`/`list_reverse`,
    `senarai_susun`/`list_sort`, `senarai_sambung`/`list_concat`,
    `senarai_panjang`/`list_len`, `senarai_peta`/`list_map`,
    `senarai_unik`/`list_unique`).

    The prototype represents a list as `Value::List(Vec<Value>)`; this file models
    it as the Stdlib [list] and proves the core algebraic laws those operations
    satisfy, plus the correctness of the sort (`list_sort` is an ascending,
    stable integer sort): the result is a permutation of the input AND sorted.
    The matching Rust property tests in `senarai.rs` assert these same invariants
    on the running implementation, so the proof and the code are tied together.

    Mirrors the numeric-tower model in `foundations/SizedInt.v`. Stdlib-backed
    and fully constructive — every lemma is machine-checked. *)

From Stdlib Require Import List.
From Stdlib Require Import Sorting.Permutation.
From Stdlib Require Import Sorting.Sorted.
From Stdlib Require Import Arith.
Import ListNotations.

(* ========================================================================= *)
(** ** Core list laws (reverse, concat, length, map)                         *)
(* ========================================================================= *)

(** `list_reverse` is involutive: reversing twice is the identity. *)
Theorem reverse_involutive : forall (A : Type) (l : list A),
  rev (rev l) = l.
Proof. exact rev_involutive. Qed.

(** `list_reverse` preserves length. *)
Theorem reverse_length : forall (A : Type) (l : list A),
  length (rev l) = length l.
Proof. exact length_rev. Qed.

(** `list_reverse` is a permutation of its input (no element lost or added). *)
Theorem reverse_permutation : forall (A : Type) (l : list A),
  Permutation l (rev l).
Proof. exact Permutation_rev. Qed.

(** `list_concat` adds the two lengths. *)
Theorem concat_length : forall (A : Type) (l1 l2 : list A),
  length (l1 ++ l2) = length l1 + length l2.
Proof. exact length_app. Qed.

(** `list_map` preserves length (it is a per-element transform). *)
Theorem map_preserves_length : forall (A B : Type) (f : A -> B) (l : list A),
  length (map f l) = length l.
Proof. exact length_map. Qed.

(* ========================================================================= *)
(** ** Insertion sort — the verified core algorithm (models `list_sort`)     *)
(* ========================================================================= *)

(** Insert [x] into a list, keeping ascending order. *)
Fixpoint ins (x : nat) (l : list nat) : list nat :=
  match l with
  | [] => [x]
  | h :: t => if x <=? h then x :: h :: t else h :: ins x t
  end.

(** Insertion sort: the abstract model of `list_sort`'s ascending integer sort. *)
Fixpoint isort (l : list nat) : list nat :=
  match l with
  | [] => []
  | h :: t => ins h (isort t)
  end.

(** Small inversion helper for [HdRel] on a cons. *)
Lemma hdrel_le : forall a b l, HdRel Nat.le a (b :: l) -> a <= b.
Proof. intros a b l H. inversion H; subst; assumption. Qed.

(** [ins x l] contains exactly [x] more than [l]. *)
Lemma ins_permutation : forall x l, Permutation (x :: l) (ins x l).
Proof.
  intros x l. induction l as [| h t IH]; simpl.
  - apply Permutation_refl.
  - destruct (x <=? h).
    + apply Permutation_refl.
    + apply Permutation_trans with (h :: x :: t).
      * apply perm_swap.
      * apply perm_skip. exact IH.
Qed.

(** **Sort spec, part 1 — permutation**: the sorted output is a rearrangement of
    the input, so nothing is dropped, duplicated, or invented. *)
Theorem isort_permutation : forall l, Permutation l (isort l).
Proof.
  induction l as [| h t IH]; simpl.
  - apply Permutation_refl.
  - apply Permutation_trans with (h :: isort t).
    + apply perm_skip. exact IH.
    + apply ins_permutation.
Qed.

(** The sort preserves length (a corollary of the permutation spec). *)
Theorem isort_length : forall l, length (isort l) = length l.
Proof.
  intro l. symmetry. apply Permutation_length. apply isort_permutation.
Qed.

(** Inserting a small-enough head keeps it at the front of an ordered relation. *)
Lemma hdrel_ins : forall a x l,
  a <= x -> HdRel Nat.le a l -> HdRel Nat.le a (ins x l).
Proof.
  intros a x l Hax Hhd. destruct l as [| h t]; simpl.
  - constructor. exact Hax.
  - destruct (x <=? h) eqn:E.
    + constructor. exact Hax.
    + constructor. apply (hdrel_le a h t). exact Hhd.
Qed.

(** [ins] preserves sortedness. *)
Lemma ins_sorted : forall x l, Sorted Nat.le l -> Sorted Nat.le (ins x l).
Proof.
  intros x l. induction l as [| h t IH]; intro Hs; simpl.
  - constructor. constructor. constructor.
  - destruct (x <=? h) eqn:E.
    + apply Nat.leb_le in E.
      constructor. exact Hs. constructor. exact E.
    + assert (Hst : Sorted Nat.le t) by (inversion Hs; assumption).
      assert (Hhd : HdRel Nat.le h t) by (inversion Hs; assumption).
      apply Nat.leb_gt in E.
      constructor.
      * apply IH. exact Hst.
      * apply hdrel_ins. apply Nat.lt_le_incl. exact E. exact Hhd.
Qed.

(** **Sort spec, part 2 — sortedness**: the output is in ascending order. *)
Theorem isort_sorted : forall l, Sorted Nat.le (isort l).
Proof.
  induction l as [| h t IH]; simpl.
  - constructor.
  - apply ins_sorted. exact IH.
Qed.

(** On an already-ordered head, [ins] just prepends. *)
Lemma ins_front : forall x l, HdRel Nat.le x l -> ins x l = x :: l.
Proof.
  intros x l H. destruct l as [| h t]; simpl.
  - reflexivity.
  - assert (Hxh : x <= h) by (apply (hdrel_le x h t); exact H).
    apply Nat.leb_le in Hxh. rewrite Hxh. reflexivity.
Qed.

(** Sorting a sorted list is the identity. *)
Lemma isort_fixed_on_sorted : forall l, Sorted Nat.le l -> isort l = l.
Proof.
  induction l as [| h t IH]; intro Hs; simpl.
  - reflexivity.
  - assert (Hst : Sorted Nat.le t) by (inversion Hs; assumption).
    assert (Hhd : HdRel Nat.le h t) by (inversion Hs; assumption).
    rewrite (IH Hst). apply ins_front. exact Hhd.
Qed.

(** **Sort is idempotent** (matches the `list_sort` property test): sorting an
    already-sorted list changes nothing. *)
Theorem isort_idempotent : forall l, isort (isort l) = isort l.
Proof.
  intro l. apply isort_fixed_on_sorted. apply isort_sorted.
Qed.

(* ========================================================================= *)
(** ** De-duplication invariants (models `list_unique`)                      *)
(* ========================================================================= *)

(** `list_unique` removes duplicates: the result has no repeats. (The prototype
    keeps the first occurrence; Stdlib [nodup] keeps one occurrence too — the
    proven invariants below are order-agnostic and the Rust property test checks
    them directly on the implementation.) *)
Theorem unique_no_duplicates : forall l, NoDup (nodup Nat.eq_dec l).
Proof. intro l. apply NoDup_nodup. Qed.

(** `list_unique` preserves the set of elements (membership is unchanged). *)
Theorem unique_preserves_membership : forall x l,
  In x (nodup Nat.eq_dec l) <-> In x l.
Proof. intros x l. apply nodup_In. Qed.
