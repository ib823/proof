(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Crypto — Curve25519 field GF(2^255-19), Formal Equivalence

    A mechanized model of the radix-2^51 field arithmetic in
    [05_TOOLING/crates/riina-core/src/crypto/field25519.rs], with the *deep*
    correctness theorems: the limb operations compute the right value modulo
    p = 2^255 - 19. This is the field underneath X25519 and Ed25519.

    Representation: a field element is 5 limbs [(a0..a4)], value
    [val = a0 + a1*2^51 + a2*2^102 + a3*2^153 + a4*2^204].

    Faithfulness map:

      Rust                                   Coq
      ----                                   ---
      add: limbwise a[i]+b[i]                feadd
      sub: a[i]-b[i] + 2*p_limb[i]           fesub
      mul: schoolbook c[i+j]+=a[i]b[j],      femul  (the 10-limb product folded
           then c[i]+=c[i+5]*19                     by 2^255 = 19 mod p)

    The Rust then runs carry propagation, which preserves the represented value
    modulo p; the model proves the *pre-carry* correctness (the cryptographic
    reduction), and the Rust parity test
    [crypto::field25519::tests::test_mul_matches_coq_model] confirms the full,
    carried implementation on concrete vectors.

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. The algebra closes by [ring]
    + the modular-arithmetic standard library. *)

From Stdlib Require Import ZArith.ZArith.
Open Scope Z_scope.

(** ** Representation *)

Definition B : Z := Eval compute in 2 ^ 51.       (* the radix *)
Definition P : Z := Eval compute in 2 ^ 255 - 19. (* the prime *)
Definition fe := (Z * Z * Z * Z * Z)%type.

Definition vval (f : fe) : Z :=
  let '(a0,a1,a2,a3,a4) := f in a0 + a1*B + a2*B*B + a3*B*B*B + a4*B*B*B*B.

(** The modulus's own radix-2^51 limbs evaluate to [P] (sanity / used by [sub]). *)
Definition P_LIMBS : fe := (0x7ffffffffffed, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff).
Lemma p_limbs_value : vval P_LIMBS = P.
Proof. unfold vval, P_LIMBS, B, P. reflexivity. Qed.

Lemma reduction_identity : B*B*B*B*B = P + 19.   (* 2^255 = (2^255-19) + 19 *)
Proof. unfold B, P. reflexivity. Qed.

(** ** Faithful limb-level operations *)

Definition feadd (a b : fe) : fe :=
  let '(a0,a1,a2,a3,a4) := a in let '(b0,b1,b2,b3,b4) := b in
  (a0+b0, a1+b1, a2+b2, a3+b3, a4+b4).

Definition fesub (a b : fe) : fe :=
  let '(a0,a1,a2,a3,a4) := a in let '(b0,b1,b2,b3,b4) := b in
  (a0-b0 + 2*0x7ffffffffffed, a1-b1 + 2*0x7ffffffffffff, a2-b2 + 2*0x7ffffffffffff,
   a3-b3 + 2*0x7ffffffffffff, a4-b4 + 2*0x7ffffffffffff).

(** The Rust [mul]: 5x5 schoolbook product [c[0..8]], then fold the high half
    [c[i] += c[i+5]*19] (using [2^255 = 19 (mod p)]). *)
Definition femul (a b : fe) : fe :=
  let '(a0,a1,a2,a3,a4) := a in let '(b0,b1,b2,b3,b4) := b in
  ( a0*b0                       + 19*(a1*b4+a2*b3+a3*b2+a4*b1)
  , a0*b1+a1*b0                 + 19*(a2*b4+a3*b3+a4*b2)
  , a0*b2+a1*b1+a2*b0           + 19*(a3*b4+a4*b3)
  , a0*b3+a1*b2+a2*b1+a3*b0     + 19*(a4*b4)
  , a0*b4+a1*b3+a2*b2+a3*b1+a4*b0 ).

(** ** Correctness theorems (value modulo p) *)

(** Addition is exact at the value level. *)
Theorem add_correct : forall a b, vval (feadd a b) = vval a + vval b.
Proof.
  intros [[[[a0 a1] a2] a3] a4] [[[[b0 b1] b2] b3] b4]. unfold feadd, vval, B. ring.
Qed.

(** Subtraction is correct modulo p (it adds 2p to stay non-negative). *)
Theorem sub_correct_mod : forall a b, vval (fesub a b) mod P = (vval a - vval b) mod P.
Proof.
  intros [[[[a0 a1] a2] a3] a4] [[[[b0 b1] b2] b3] b4]. unfold fesub, vval.
  replace (a0-b0 + 2*0x7ffffffffffed + (a1-b1 + 2*0x7ffffffffffff)*B
           + (a2-b2 + 2*0x7ffffffffffff)*B*B + (a3-b3 + 2*0x7ffffffffffff)*B*B*B
           + (a4-b4 + 2*0x7ffffffffffff)*B*B*B*B)
    with ((a0 + a1*B + a2*B*B + a3*B*B*B + a4*B*B*B*B
           - (b0 + b1*B + b2*B*B + b3*B*B*B + b4*B*B*B*B)) + 2 * P)
    by (unfold B, P; ring).
  now rewrite Z_mod_plus_full.
Qed.

(** The reduction identity behind [mul]: the folded 5-limb result differs from
    the true product by a multiple of p. *)
Theorem mul_reduce_eq : forall a b,
  vval (femul a b) = vval a * vval b
    - P * (let '(a0,a1,a2,a3,a4):=a in let '(b0,b1,b2,b3,b4):=b in
           (a1*b4+a2*b3+a3*b2+a4*b1) + (a2*b4+a3*b3+a4*b2)*B
           + (a3*b4+a4*b3)*B*B + (a4*b4)*B*B*B).
Proof.
  intros [[[[a0 a1] a2] a3] a4] [[[[b0 b1] b2] b3] b4]. unfold femul, vval, B, P. ring.
Qed.

(** **The headline**: the field multiply is correct modulo p. *)
Theorem mul_correct_mod : forall a b, vval (femul a b) mod P = (vval a * vval b) mod P.
Proof.
  intros a b. rewrite mul_reduce_eq.
  match goal with |- (?X - P * ?W) mod P = _ =>
    replace (X - P * W) with (X + (- W) * P) by ring end.
  now rewrite Z_mod_plus_full.
Qed.

(** Squaring is multiplication by self, hence also correct mod p. *)
Corollary square_correct_mod : forall a, vval (femul a a) mod P = (vval a * vval a) mod P.
Proof. intro a. apply mul_correct_mod. Qed.

(** ** Concrete cross-check (vm_compute) *)

(** A product that exercises the 2^255-fold: (2^255 - 20) = p - 1, squared,
    is congruent to 1 (mod p).  Here [p-1] in limbs is [P_LIMBS] minus one. *)
Definition PM1 : fe := (0x7ffffffffffec, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff).
Example pm1_is_p_minus_1 : vval PM1 = P - 1. Proof. vm_compute. reflexivity. Qed.
Example pm1_squared_is_one : vval (femul PM1 PM1) mod P = 1.
Proof. rewrite mul_correct_mod. vm_compute. reflexivity. Qed.
