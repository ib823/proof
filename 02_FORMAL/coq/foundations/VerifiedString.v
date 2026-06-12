(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Strings — Verified Core String Algorithms

    A foundational model of the prototype's string builtins
    (`riina-codegen/src/builtins/teks.rs`), modelling a string as a list of
    code units (`list nat`) and proving the core algebraic laws:

    - **repeat** (`str_repeat`/`teks_ulang`): the length law and the recursive
      shape (`text.repeat(n)` is `text` concatenated `n` times).
    - **split/join round-trip** (`str_split`/`teks_belah` and
      `str_join`/`teks_cantum`): joining the pieces of a split on the same
      separator reconstructs the original — `join sep (split sep s) = s`.

    Case-folding (`str_to_upper`/`str_to_lower`) is deliberately NOT modelled
    here: Rust's Unicode `to_uppercase`/`to_lowercase` is not length-preserving
    (e.g. 'ß' ⇒ "SS"), so an abstract length-preserving char map would be an
    *unsound* model. Its idempotence is instead checked, Unicode-faithfully, by
    the property tests in `teks.rs`. The split/join round-trip is modelled for a
    single separator code unit; the property tests exercise the running
    multi-character implementation.

    Mirrors `foundations/VerifiedList.v` / `VerifiedMapSet.v`. Stdlib-backed and
    fully constructive — every lemma is machine-checked. *)

From Stdlib Require Import List.
From Stdlib Require Import Arith.
Import ListNotations.

(* ========================================================================= *)
(** ** repeat — `str_repeat` / `teks_ulang`                                  *)
(* ========================================================================= *)

(** `srepeat s n` is `s` concatenated `n` times (Rust `text.repeat(count)`). *)
Fixpoint srepeat (s : list nat) (n : nat) : list nat :=
  match n with
  | O => []
  | S k => s ++ srepeat s k
  end.

Lemma srepeat_zero : forall s, srepeat s 0 = [].
Proof. reflexivity. Qed.

Lemma srepeat_one : forall s, srepeat s 1 = s.
Proof. intro s. simpl. apply app_nil_r. Qed.

Lemma srepeat_succ : forall s n, srepeat s (S n) = s ++ srepeat s n.
Proof. reflexivity. Qed.

(** **repeat length law**: `|repeat s n| = n * |s|`. *)
Theorem srepeat_length : forall s n, length (srepeat s n) = n * length s.
Proof.
  intros s n. induction n as [| k IH]; simpl.
  - reflexivity.
  - rewrite length_app, IH. reflexivity.
Qed.

(* ========================================================================= *)
(** ** split / join — `str_split`/`teks_belah` and `str_join`/`teks_cantum`  *)
(* ========================================================================= *)

(** Prepend a code unit to the first segment of a split. *)
Definition cons_first (x : nat) (segs : list (list nat)) : list (list nat) :=
  match segs with
  | [] => [[x]]                            (* unreachable: split is never [] *)
  | seg :: rest => (x :: seg) :: rest
  end.
Arguments cons_first : simpl never.

(** Split `s` into segments at each occurrence of the separator [sep]. Always
    returns at least one (possibly empty) segment, matching `"".split(d) = [""]`. *)
Fixpoint split (sep : nat) (s : list nat) : list (list nat) :=
  match s with
  | [] => [[]]
  | x :: xs =>
      if Nat.eqb x sep then [] :: split sep xs
      else cons_first x (split sep xs)
  end.

(** Join segments, placing one [sep] between consecutive segments. *)
Fixpoint sjoin (sep : nat) (segs : list (list nat)) : list nat :=
  match segs with
  | [] => []
  | seg :: rest =>
      match rest with
      | [] => seg
      | _ => seg ++ sep :: sjoin sep rest
      end
  end.

(** One reduction step of [cons_first] on a non-empty segment list. *)
Lemma cons_first_cons : forall x seg segs,
  cons_first x (seg :: segs) = (x :: seg) :: segs.
Proof. reflexivity. Qed.

Lemma split_cons_eq : forall sep xs, split sep (sep :: xs) = [] :: split sep xs.
Proof. intros sep xs. simpl. rewrite Nat.eqb_refl. reflexivity. Qed.

Lemma split_cons_neq : forall sep x xs,
  x <> sep -> split sep (x :: xs) = cons_first x (split sep xs).
Proof.
  intros sep x xs H. simpl. apply Nat.eqb_neq in H. rewrite H. reflexivity.
Qed.

(** `split` never yields the empty list of segments. *)
Lemma split_nonempty : forall sep s, split sep s <> [].
Proof.
  intros sep s. destruct s as [| x xs]; simpl.
  - discriminate.
  - destruct (Nat.eqb x sep).
    + discriminate.
    + unfold cons_first. destruct (split sep xs); discriminate.
Qed.

(** Joining absorbs an empty leading segment into a separator. *)
Lemma sjoin_empty_head : forall sep seg segs,
  sjoin sep ([] :: seg :: segs) = sep :: sjoin sep (seg :: segs).
Proof. reflexivity. Qed.

(** Joining distributes over a leading character of the first segment. *)
Lemma sjoin_cons_seg : forall sep x seg segs,
  sjoin sep ((x :: seg) :: segs) = x :: sjoin sep (seg :: segs).
Proof. intros sep x seg segs. destruct segs; reflexivity. Qed.

(** **split/join round-trip**: joining a split on the same separator
    reconstructs the original string. *)
Theorem sjoin_split : forall sep s, sjoin sep (split sep s) = s.
Proof.
  intros sep s. induction s as [| x xs IH].
  - reflexivity.
  - destruct (Nat.eqb x sep) eqn:E.
    + apply Nat.eqb_eq in E. subst x.
      rewrite split_cons_eq.
      destruct (split sep xs) as [| seg segs] eqn:Es.
      * exfalso. apply (split_nonempty sep xs). exact Es.
      * rewrite sjoin_empty_head. rewrite IH. reflexivity.
    + assert (Hne : x <> sep) by (apply Nat.eqb_neq; exact E).
      rewrite (split_cons_neq sep x xs Hne).
      destruct (split sep xs) as [| seg segs] eqn:Es.
      * exfalso. apply (split_nonempty sep xs). exact Es.
      * rewrite cons_first_cons. rewrite sjoin_cons_seg.
        rewrite IH. reflexivity.
Qed.
