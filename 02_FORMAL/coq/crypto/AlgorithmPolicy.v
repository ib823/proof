(* ========================================================================= *)
(* AlgorithmPolicy.v — crypto-agility: typed algorithm deprecation           *)
(*                                                                           *)
(* REQ-48 (crypto-agility / PQC migration).                                  *)
(*                                                                           *)
(* The Rust typechecker gains a rule that REJECTS a program selecting a      *)
(* crypto algorithm marked Deprecated by policy (e.g. "P-256 after 2030").   *)
(* Because that is an ENFORCEMENT rule, it needs a mechanized counterpart —  *)
(* every other Gate-B security property has one. This file provides it, in   *)
(* the focused, self-contained style of RecursionSafety.v: a representative  *)
(* calculus of crypto-algorithm selection, an acceptance judgment mirroring  *)
(* the Rust check, and the three theorems that make the check meaningful.    *)
(*                                                                           *)
(* SCOPE (honest, per Zero-Trust). This models algorithm SELECTION and the   *)
(* deprecation gate over it — not the cryptographic primitives themselves    *)
(* (those are crypto/{AES,SHA256,...}.v) and not the effect/IFC core. It     *)
(* mechanizes exactly the rule the Rust `crypto_policy` check enforces:      *)
(* "an accepted program uses no deprecated algorithm", and its converse, and *)
(* the agility payoff (tightening a policy only affects programs that use    *)
(* the newly-deprecated algorithm).                                          *)
(* ========================================================================= *)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
Import ListNotations.

(* --- Algorithms and deprecation status ---------------------------------- *)

Inductive algo : Type :=
  | AES256    : algo
  | ChaCha20  : algo
  | SHA256    : algo
  | SHA3_256  : algo
  | X25519    : algo
  | MLKEM768  : algo   (* PQC KEM *)
  | MLDSA65   : algo   (* PQC signature *)
  | P256      : algo   (* classical ECC — deprecation candidate (NIST IR 8547) *)
  | RSA2048   : algo   (* classical — deprecation candidate *)
  | Other     : string -> algo.

Definition algo_eqb (a b : algo) : bool :=
  match a, b with
  | AES256, AES256 => true
  | ChaCha20, ChaCha20 => true
  | SHA256, SHA256 => true
  | SHA3_256, SHA3_256 => true
  | X25519, X25519 => true
  | MLKEM768, MLKEM768 => true
  | MLDSA65, MLDSA65 => true
  | P256, P256 => true
  | RSA2048, RSA2048 => true
  | Other s1, Other s2 => String.eqb s1 s2
  | _, _ => false
  end.

Inductive status : Type := Current | Deprecated.

(* A policy classifies each algorithm. Parameterised, so "after 2030" is just *)
(* a different policy — the migration is a policy change, not a code change.  *)
Definition policy := algo -> status.

(* --- Crypto programs: a tree of algorithm selections -------------------- *)

Inductive cprog : Type :=
  | CUse  : algo -> cprog          (* select an algorithm *)
  | CSeq  : cprog -> cprog -> cprog (* do one thing then another *)
  | CPure : cprog.                  (* no crypto used *)

Fixpoint algos_used (p : cprog) : list algo :=
  match p with
  | CUse a     => [a]
  | CSeq p1 p2 => algos_used p1 ++ algos_used p2
  | CPure      => []
  end.

(* The property the gate is supposed to guarantee. *)
Definition uses_only_current (pol : policy) (p : cprog) : Prop :=
  forall a, In a (algos_used p) -> pol a = Current.

(* --- The acceptance judgment: exactly what the Rust check does ---------- *)

Inductive accepts (pol : policy) : cprog -> Prop :=
  | A_Use  : forall a, pol a = Current -> accepts pol (CUse a)
  | A_Pure : accepts pol CPure
  | A_Seq  : forall p1 p2,
      accepts pol p1 -> accepts pol p2 -> accepts pol (CSeq p1 p2).

(* --- Soundness: an accepted program uses no deprecated algorithm -------- *)

Theorem accepts_uses_only_current :
  forall pol p, accepts pol p -> uses_only_current pol p.
Proof.
  intros pol p H. induction H; unfold uses_only_current in *; simpl; intros b Hin.
  - (* CUse *) destruct Hin as [Heq | []]. subst. assumption.
  - (* CPure *) destruct Hin.
  - (* CSeq *) apply in_app_or in Hin. destruct Hin as [Hin | Hin].
    + apply IHaccepts1; assumption.
    + apply IHaccepts2; assumption.
Qed.

(* --- Completeness: the check is EXACT, not conservative ----------------- *)
(* It accepts every program that in fact uses only current algorithms, so a  *)
(* rejection is always a real deprecated use — no false positives.           *)

Theorem uses_only_current_accepts :
  forall pol p, uses_only_current pol p -> accepts pol p.
Proof.
  intros pol p. induction p; unfold uses_only_current; simpl; intros H.
  - (* CUse *) apply A_Use. apply H. left. reflexivity.
  - (* CSeq *) apply A_Seq.
    + apply IHp1. intros x Hx. apply H. apply in_or_app. left. assumption.
    + apply IHp2. intros x Hx. apply H. apply in_or_app. right. assumption.
  - (* CPure *) apply A_Pure.
Qed.

Corollary accepts_iff_uses_only_current :
  forall pol p, accepts pol p <-> uses_only_current pol p.
Proof.
  split; [ apply accepts_uses_only_current | apply uses_only_current_accepts ].
Qed.

(* --- Crypto-agility payoff: deprecating one algorithm only affects ------ *)
(* programs that use it. Tightening a policy at algorithm `x` leaves the     *)
(* acceptance of any program NOT using `x` unchanged.                        *)

Definition tighten (pol : policy) (x : algo) : policy :=
  fun a => if algo_eqb a x then Deprecated else pol a.

Lemma algo_eqb_refl : forall a, algo_eqb a a = true.
Proof.
  destruct a; simpl; try reflexivity. apply String.eqb_refl.
Qed.

Lemma algo_eqb_true : forall a b, algo_eqb a b = true -> a = b.
Proof.
  destruct a, b; simpl; intro H; try discriminate; try reflexivity.
  apply String.eqb_eq in H. subst. reflexivity.
Qed.

Theorem deprecation_is_local :
  forall pol x p,
    ~ In x (algos_used p) ->
    accepts pol p ->
    accepts (tighten pol x) p.
Proof.
  intros pol x p Hnotin Hacc.
  apply uses_only_current_accepts.
  apply accepts_uses_only_current in Hacc.
  unfold uses_only_current in *. intros a Hin.
  unfold tighten. destruct (algo_eqb a x) eqn:Heq.
  - (* a = x, but x is not used — contradiction *)
    apply algo_eqb_true in Heq. subst. contradiction.
  - apply Hacc. assumption.
Qed.

(* --- A concrete IR-8547-style policy, as a sanity check ----------------- *)
(* Classical ECC/RSA deprecated; PQC and modern symmetric current.          *)

Definition ir8547_2030 : policy :=
  fun a => match a with
           | P256 | RSA2048 => Deprecated
           | _ => Current
           end.

(* A PQC program is accepted; a program using P-256 is not. *)
Example pqc_program_accepted :
  accepts ir8547_2030 (CSeq (CUse MLKEM768) (CUse X25519)).
Proof.
  apply A_Seq; apply A_Use; reflexivity.
Qed.

Example p256_program_rejected :
  ~ accepts ir8547_2030 (CUse P256).
Proof.
  intro H. inversion H. discriminate.
Qed.
