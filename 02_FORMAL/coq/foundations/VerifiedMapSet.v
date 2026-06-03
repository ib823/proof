(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Collections — Verified Map and Set Algebra

    Completes the collections "verified core algorithms" row alongside
    `foundations/VerifiedList.v`, modelling the prototype's map and set builtins.

    - **Map** (`riina-codegen/src/builtins/peta.rs`, a `BTreeMap<String,Value>`:
      `map_new`/`map_insert`/`map_get`/`map_remove`/`map_contains`). A finite map
      is modelled by the standard partial-map abstraction `nat -> option nat`, and
      the fundamental laws are proved: get-after-insert, insert leaves other keys
      untouched, insert shadows, and remove deletes exactly one key.

    - **Set** (`riina-codegen/src/builtins/set.rs`, a de-duplicated `Vec`:
      `set_insert`/`set_remove`/`set_contains`/`set_union`/`set_intersect`). A set
      is modelled as a list under membership; the [set] operations are modelled to
      match the prototype (union folds with a de-dup check against the accumulator,
      exactly as `set_kesatuan` does) and the membership algebra is proved
      (insert/remove/union/intersect), plus the no-duplicate invariant for insert.

    The matching Rust property tests in `peta.rs`/`set.rs` assert these same
    invariants on the running builtins. Stdlib-backed and fully constructive —
    every lemma is machine-checked. *)

From Stdlib Require Import List.
From Stdlib Require Import Arith.
Import ListNotations.

(* ========================================================================= *)
(** ** Map — the partial-map laws (models `peta.rs` / `BTreeMap`)            *)
(* ========================================================================= *)

Definition Map := nat -> option nat.

Definition mempty : Map := fun _ => None.
Definition mupdate (m : Map) (k v : nat) : Map :=
  fun k' => if Nat.eqb k' k then Some v else m k'.
Definition mremove (m : Map) (k : nat) : Map :=
  fun k' => if Nat.eqb k' k then None else m k'.

(** `map_get` after `map_insert` of the same key returns the inserted value. *)
Theorem map_get_after_insert : forall m k v, mupdate m k v k = Some v.
Proof. intros m k v. unfold mupdate. rewrite Nat.eqb_refl. reflexivity. Qed.

(** `map_insert` does not affect any other key. *)
Theorem map_insert_other : forall m k1 k2 v,
  k1 <> k2 -> mupdate m k1 v k2 = m k2.
Proof.
  intros m k1 k2 v H. unfold mupdate.
  destruct (Nat.eqb k2 k1) eqn:E.
  - apply Nat.eqb_eq in E. subst. contradiction.
  - reflexivity.
Qed.

(** A later `map_insert` on the same key shadows the earlier one. *)
Theorem map_insert_shadow : forall m k v1 v2 k',
  mupdate (mupdate m k v1) k v2 k' = mupdate m k v2 k'.
Proof.
  intros m k v1 v2 k'. unfold mupdate. destruct (Nat.eqb k' k); reflexivity.
Qed.

(** `map_remove` deletes exactly the named key. *)
Theorem map_remove_eq : forall m k, mremove m k k = None.
Proof. intros m k. unfold mremove. rewrite Nat.eqb_refl. reflexivity. Qed.

(** `map_remove` leaves any other key untouched. *)
Theorem map_remove_other : forall m k1 k2,
  k1 <> k2 -> mremove m k1 k2 = m k2.
Proof.
  intros m k1 k2 H. unfold mremove.
  destruct (Nat.eqb k2 k1) eqn:E.
  - apply Nat.eqb_eq in E. subst. contradiction.
  - reflexivity.
Qed.

(* ========================================================================= *)
(** ** Set — the membership algebra (models `set.rs`)                        *)
(* ========================================================================= *)

(** Decidable membership, matching `items.contains(val)`. *)
Fixpoint smem (x : nat) (l : list nat) : bool :=
  match l with
  | [] => false
  | h :: t => if Nat.eqb x h then true else smem x t
  end.

Lemma smem_spec : forall x l, smem x l = true <-> In x l.
Proof.
  intros x l. induction l as [| h t IH]; simpl.
  - split; intro H; [discriminate | contradiction].
  - destruct (Nat.eqb x h) eqn:E.
    + apply Nat.eqb_eq in E. subst. split; intro; [left; reflexivity | reflexivity].
    + apply Nat.eqb_neq in E. rewrite IH. split.
      * intro H. right. exact H.
      * intros [Heq | Hin]; [symmetry in Heq; contradiction | exact Hin].
Qed.

(** `set_insert`: add [x] only if absent (the prototype appends at the end). *)
Definition sinsert (x : nat) (l : list nat) : list nat :=
  if smem x l then l else l ++ [x].

(** `set_remove`: drop every copy of [x]. *)
Definition sremove (x : nat) (l : list nat) : list nat :=
  filter (fun y => negb (Nat.eqb y x)) l.

(** `set_intersect`: keep elements of [a] that are also in [b]. *)
Definition sintersect (a b : list nat) : list nat :=
  filter (fun x => smem x b) a.

(** `set_union`: fold [b] into [a], skipping any element already present — the
    exact shape of `set_kesatuan` (de-dup against the growing accumulator). *)
Fixpoint sunion_aux (acc b : list nat) : list nat :=
  match b with
  | [] => acc
  | h :: t => sunion_aux (if smem h acc then acc else acc ++ [h]) t
  end.
Definition sunion (a b : list nat) : list nat := sunion_aux a b.

(** Helper: appending a fresh element preserves the no-duplicate invariant. *)
Lemma nodup_snoc : forall (l : list nat) (x : nat),
  NoDup l -> ~ In x l -> NoDup (l ++ [x]).
Proof.
  induction l as [| h t IH]; intros x Hnd Hni; simpl.
  - constructor; [intro Hin; inversion Hin | constructor].
  - inversion Hnd as [| h' t' Hh Ht]; subst.
    constructor.
    + rewrite in_app_iff. intros [Hin | Hin].
      * apply Hh. exact Hin.
      * simpl in Hin. destruct Hin as [He | Hf]; [subst; apply Hni; left; reflexivity | inversion Hf].
    + apply IH; [exact Ht | intro Hin; apply Hni; right; exact Hin].
Qed.

(** **Set insert** adds exactly [x] to the membership. *)
Theorem set_insert_membership : forall x y l,
  In y (sinsert x l) <-> (y = x \/ In y l).
Proof.
  intros x y l. unfold sinsert. destruct (smem x l) eqn:E.
  - apply smem_spec in E. split.
    + intro H. right. exact H.
    + intros [Heq | Hin]; [subst; exact E | exact Hin].
  - rewrite in_app_iff. simpl. split.
    + intros [Hin | [He | Hf]]; [right; exact Hin | left; symmetry; exact He | inversion Hf].
    + intros [Heq | Hin]; [right; left; symmetry; exact Heq | left; exact Hin].
Qed.

(** **Set insert** preserves the no-duplicate invariant. *)
Theorem set_insert_nodup : forall x l, NoDup l -> NoDup (sinsert x l).
Proof.
  intros x l Hnd. unfold sinsert. destruct (smem x l) eqn:E.
  - exact Hnd.
  - apply nodup_snoc; [exact Hnd | intro Hin; apply smem_spec in Hin; rewrite Hin in E; discriminate].
Qed.

(** **Set remove** deletes [x] and keeps everything else. *)
Theorem set_remove_membership : forall x y l,
  In y (sremove x l) <-> (In y l /\ y <> x).
Proof.
  intros x y l. unfold sremove. rewrite filter_In. split.
  - intros [Hin Hf]. split; [exact Hin |].
    intro Heq. subst. rewrite Nat.eqb_refl in Hf. discriminate.
  - intros [Hin Hne]. split; [exact Hin |].
    destruct (Nat.eqb y x) eqn:E; [apply Nat.eqb_eq in E; contradiction | reflexivity].
Qed.

Corollary set_remove_absent : forall x l, ~ In x (sremove x l).
Proof.
  intros x l Hin. apply set_remove_membership in Hin.
  destruct Hin as [_ Hne]. apply Hne. reflexivity.
Qed.

(** **Set intersect** keeps exactly the common elements. *)
Theorem set_intersect_membership : forall a b y,
  In y (sintersect a b) <-> (In y a /\ In y b).
Proof.
  intros a b y. unfold sintersect. rewrite filter_In. split.
  - intros [Ha Hb]. split; [exact Ha | apply smem_spec; exact Hb].
  - intros [Ha Hb]. split; [exact Ha | apply smem_spec; exact Hb].
Qed.

Lemma sunion_aux_membership : forall b acc y,
  In y (sunion_aux acc b) <-> (In y acc \/ In y b).
Proof.
  induction b as [| h t IH]; intros acc y; simpl.
  - split; [intro H; left; exact H | intros [H | H]; [exact H | contradiction]].
  - rewrite IH. destruct (smem h acc) eqn:E.
    + apply smem_spec in E. split.
      * intros [Hacc | Ht]; [left; exact Hacc | right; right; exact Ht].
      * intros [Hacc | [Heq | Ht]];
          [left; exact Hacc | left; subst; exact E | right; exact Ht].
    + rewrite in_app_iff. simpl. split.
      * intros [[Hacc | [He | Hf]] | Ht];
          [left; exact Hacc | right; left; exact He | inversion Hf
           | right; right; exact Ht].
      * intros [Hacc | [Heq | Ht]];
          [left; left; exact Hacc | left; right; left; exact Heq
           | right; exact Ht].
Qed.

(** **Set union** has exactly the elements of either operand. *)
Theorem set_union_membership : forall a b y,
  In y (sunion a b) <-> (In y a \/ In y b).
Proof. intros a b y. unfold sunion. apply sunion_aux_membership. Qed.
