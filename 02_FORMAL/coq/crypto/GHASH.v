(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Crypto — GHASH fold (full hash), Formal Equivalence

    Builds on [crypto.GF128] to model the full GHASH universal hash of
    AES-GCM (SP 800-38D), faithful to
    [05_TOOLING/crates/riina-core/src/crypto/ghash.rs].

    The Rust [Ghash::update_block] is [acc := (acc XOR block) * H]; the hash of a
    block sequence is the [fold_left] of that step from accumulator 0:

      Rust                                   Coq
      ----                                   ---
      acc ^= block; acc = gf128_mul(acc,h)   ghash_step h acc block
      new(h); for b in blocks { ub(b) }      ghash h blocks  (fold_left, init 0)

    Headline theorems, all [Qed] (0 Admitted/Axiom/Abort):
      - [ghash_linear]: GHASH_H is GF(2)-linear in the (equal-length) block
        message — GHASH_H(X (+) Y) = GHASH_H(X) (+) GHASH_H(Y). This is the
        almost-XOR-universal structure GCM authentication rests on.
      - [ghash_cons] / [ghash_horner_two]: the Horner/polynomial form
        GHASH_H(B1..Bm) = (+)_i B_i * H^(m-i+1).

    [gf_mul] (a 128-step fixpoint) and [ghash_step]/[mul_pow] are kept [Opaque],
    so [simpl]/[cbn] never try to unfold them (which diverges); proofs go through
    the *_distr / *_linear lemmas, and [vm_compute] still reduces everything for
    the executable KATs, which the Rust parity test
    [crypto::ghash::tests::test_ghash_fold_matches_coq_model] mirrors. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import Lia.
From Stdlib Require Import List.
From Stdlib Require Import Btauto.
From RIINA Require Import crypto.GF128.

Import ListNotations.
Open Scope Z_scope.

Opaque gf_mul.

(** ** The GHASH step and fold *)

Definition ghash_step (h acc block : Z) : Z := gf_mul (Z.lxor acc block) h.

Definition ghash (h : Z) (blocks : list Z) : Z := fold_left (ghash_step h) blocks 0.

(** The step is the sum of two independent multiplies (left distributivity of
    [gf_mul]) — the seed of GHASH's linearity. *)
Lemma ghash_step_distr : forall h acc b,
  ghash_step h acc b = Z.lxor (gf_mul acc h) (gf_mul b h).
Proof. intros h acc b. unfold ghash_step. apply gf_mul_distr_l. Qed.

Opaque ghash_step.

Lemma ghash_nil : forall h, ghash h [] = 0.
Proof. reflexivity. Qed.

(** [gf_mul] is also left-absorbing (the empty/zero block). *)
Lemma gf_mul_0_l : forall y, gf_mul 0 y = 0.
Proof.
  intro y. assert (H := gf_mul_distr_l 0 0 y).
  rewrite Z.lxor_0_l, Z.lxor_nilpotent in H. exact H.
Qed.

(** ghash_step with a zero block reduces to one multiply. *)
Lemma ghash_step_0 : forall h b, ghash_step h 0 b = gf_mul b h.
Proof.
  intros h b. rewrite ghash_step_distr, gf_mul_0_l. apply Z.lxor_0_l.
Qed.

(** ** GF(2)-linearity of GHASH in the message *)

Fixpoint zip_xor (xs ys : list Z) : list Z :=
  match xs, ys with
  | x :: xs', y :: ys' => Z.lxor x y :: zip_xor xs' ys'
  | _, _ => []
  end.

(** Generic [Qed]-opaque structural lemmas. Rewriting with these (rather than
    [simpl]/[cbn]) keeps the goal's [fold_left]s from being unfolded by the
    kernel's *Qed-time* conversion — which ignores [Opaque] and would otherwise
    expand [ghash_step] -> [gf_mul]'s 128-step fixpoint and diverge. *)
Lemma fold_left_cons : forall (f : Z -> Z -> Z) x l a,
  fold_left f (x :: l) a = fold_left f l (f a x).
Proof. reflexivity. Qed.

Lemma fold_left_nil : forall (f : Z -> Z -> Z) a, fold_left f [] a = a.
Proof. reflexivity. Qed.

Lemma zip_xor_cons : forall x xs y ys,
  zip_xor (x :: xs) (y :: ys) = Z.lxor x y :: zip_xor xs ys.
Proof. reflexivity. Qed.

Lemma length_cons : forall (x : Z) l, length (x :: l) = S (length l).
Proof. reflexivity. Qed.

Lemma ghash_fold_linear : forall h xs ys a b,
  length xs = length ys ->
  fold_left (ghash_step h) (zip_xor xs ys) (Z.lxor a b)
  = Z.lxor (fold_left (ghash_step h) xs a) (fold_left (ghash_step h) ys b).
Proof.
  induction xs as [|x xs' IH]; intros ys a b Hlen; destruct ys as [|y ys'];
    try (simpl in Hlen; discriminate).
  - reflexivity.
  - rewrite zip_xor_cons, !fold_left_cons.
    replace (ghash_step h (Z.lxor a b) (Z.lxor x y))
      with (Z.lxor (ghash_step h a x) (ghash_step h b y)).
    + apply IH. simpl in Hlen. exact (eq_add_S _ _ Hlen).
    + rewrite !ghash_step_distr, !gf_mul_distr_l. apply lxor_swap_mid.
Qed.

Theorem ghash_linear : forall h xs ys,
  length xs = length ys ->
  ghash h (zip_xor xs ys) = Z.lxor (ghash h xs) (ghash h ys).
Proof.
  intros h xs ys Hlen. unfold ghash.
  transitivity (fold_left (ghash_step h) (zip_xor xs ys) (Z.lxor 0 0)).
  - rewrite Z.lxor_0_l. reflexivity.
  - apply ghash_fold_linear. exact Hlen.
Qed.

(** ** Horner / polynomial form *)

Fixpoint mul_pow (a h : Z) (k : nat) : Z :=
  match k with O => a | S k' => gf_mul (mul_pow a h k') h end.

Lemma mul_pow_O : forall a h, mul_pow a h 0 = a.
Proof. reflexivity. Qed.

Lemma mul_pow_linear : forall h k a b,
  mul_pow (Z.lxor a b) h k = Z.lxor (mul_pow a h k) (mul_pow b h k).
Proof.
  induction k; intros a b; simpl; [reflexivity | rewrite IHk; apply gf_mul_distr_l].
Qed.

Lemma mul_pow_step : forall h k a, mul_pow (gf_mul a h) h k = mul_pow a h (S k).
Proof.
  induction k; intros a; simpl; [reflexivity | rewrite IHk; reflexivity].
Qed.

Lemma mul_pow_0 : forall h k, mul_pow 0 h k = 0.
Proof.
  induction k; simpl; [reflexivity | rewrite IHk; apply gf_mul_0_l].
Qed.

Opaque mul_pow.

(** [mul_pow] of a step splits into the two operands' powers (one degree up). *)
Lemma mul_pow_ghash_step : forall h a b k,
  mul_pow (ghash_step h a b) h k
  = Z.lxor (mul_pow a h (S k)) (mul_pow b h (S k)).
Proof.
  intros h a b k. rewrite ghash_step_distr, mul_pow_linear, !mul_pow_step.
  reflexivity.
Qed.

(** Shifting the initial accumulator by [a] adds [a * H^(length blocks)]. *)
Lemma ghash_acc_shift : forall h blocks a,
  fold_left (ghash_step h) blocks a
  = Z.lxor (fold_left (ghash_step h) blocks 0) (mul_pow a h (length blocks)).
Proof.
  induction blocks as [|b rest IH]; intros a.
  - cbn [fold_left length]. rewrite mul_pow_O, Z.lxor_0_l. reflexivity.
  - rewrite !fold_left_cons, length_cons.
    rewrite (IH (ghash_step h a b)), (IH (ghash_step h 0 b)).
    rewrite !mul_pow_ghash_step, mul_pow_0, Z.lxor_0_l.
    apply Z.bits_inj'; intros n _; rewrite !Z.lxor_spec; btauto.
Qed.

(** GHASH of [b :: rest] adds [b * H^(|rest|+1)] — Horner evaluation at H. *)
Theorem ghash_cons : forall h b rest,
  ghash h (b :: rest)
  = Z.lxor (ghash h rest) (mul_pow (gf_mul b h) h (length rest)).
Proof.
  intros h b rest. unfold ghash. rewrite fold_left_cons.
  rewrite ghash_acc_shift, ghash_step_0. reflexivity.
Qed.

(** Fully unrolled two-block form: GHASH_H(B1,B2) = B1*H^2 (+) B2*H. *)
Theorem ghash_horner_two : forall h b1 b2,
  ghash h [b1; b2] = Z.lxor (gf_mul (gf_mul b1 h) h) (gf_mul b2 h).
Proof.
  intros h b1 b2. unfold ghash. rewrite !fold_left_cons, fold_left_nil.
  rewrite (ghash_step_distr h (ghash_step h 0 b1) b2), ghash_step_0. reflexivity.
Qed.

(** ** Executable cross-check (Coq model <-> Rust)

    Concrete values closed by [vm_compute] and asserted byte-identical to the Rust
    [Ghash] in [crypto::ghash::tests::test_ghash_fold_matches_coq_model]. *)

Definition Hk : Z := 0x66e94bd4ef8a2c3b884cfa59ca342b2e.
Definition B1 : Z := 0x0388dace60b6a392f328c2b971b2fe78.
Definition B2 : Z := 0x00000000000000000000000000000080.
Definition G1 : Z := 0x5e2ec746917062882c85b0685353deb7.
Definition G2 : Z := 0xf38cbb1ad69223dcc3457ae5b6b0f885.

Example ghash_kat_1 : ghash Hk [B1]      = G1. Proof. vm_compute. reflexivity. Qed.
Example ghash_kat_2 : ghash Hk [B1; B2]  = G2. Proof. vm_compute. reflexivity. Qed.

(** The two-block KAT also matches the *proven* Horner form B1*H^2 (+) B2*H. *)
Example ghash_kat_horner :
  ghash Hk [B1; B2] = Z.lxor (gf_mul (gf_mul B1 Hk) Hk) (gf_mul B2 Hk).
Proof. apply ghash_horner_two. Qed.
