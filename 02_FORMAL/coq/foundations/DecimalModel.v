(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Numeric Tower — Arbitrary-Precision Decimal Model (perpuluhan)

    A mechanized model of the exact base-10 arithmetic in
    [03_PROTO/crates/riina-codegen/src/decimal.rs] (the [perpuluhan] decimal),
    faithful to its representation: a [BigInt] [mantissa] scaled by a power of
    ten, denoting the value [mantissa * 10^(-scale)].

    Faithfulness map (Rust [Decimal] <-> [Q]):

      Rust                                   Coq
      ----                                   ---
      Decimal { mantissa, scale }            Dec (mkDec mant scal)
      value = mantissa * 10^(-scale)         value d = inject_Z (mant d) / 10^(scal d)
      align to max(sa, sb)                   aligned_l / aligned_r at scale (cs a b)
      add (align, then add mantissas)        dadd  (eval-correct: value a + value b)
      sub (align, then sub mantissas)        dsub  (eval-correct: value a - value b)
      mul (mul mantissas, add scales)        dmul  (eval-correct: value a * value b)
      neg (negate mantissa)                  dneg  (eval-correct: - value a)
      compare (align, cmp mantissas)         dcompare (value-based: Qcompare)

    The headline results are that [value] is a *ring homomorphism* from the
    scaled-integer representation to [Q] (the field of rationals):
      [value (dadd a b) == value a + value b]   ([value_add])
      [value (dsub a b) == value a - value b]   ([value_sub])
      [value (dmul a b) == value a * value b]   ([value_mul])
      [value (dneg a)   == - value a]           ([value_neg])
    proved via the scale-alignment invariance lemma [value_align_general]
    ([value (mkDec (m * 10^(s-sc)) s) == value (mkDec m sc)] for [sc <= s], i.e.
    re-scaling the mantissa does not change the value) and same-denominator
    field arithmetic over [Q]. So whatever scaled mantissa the Rust algorithm
    produces and whatever the model produces, both *denote* the same rational.

    Comparison is proved *value-based* — scale-insensitive: [3.14] and [3.140]
    compare [Eq] ([compare_eq]/[compare_lt]/[compare_gt] relate [dcompare] to the
    [Q] order of the denoted values, exactly mirroring Rust's [compare] which
    aligns scales before comparing mantissas).

    The executable [vm_compute] KATs at the file end pin concrete decimal values
    (0.1+0.2=0.3, 1.5*1.5=2.25, a >64-bit exact product, 5-0.01=4.99, the
    value-based 3.14 == 3.140), asserted to match the running [decimal.rs] in the
    parity test [decimal::tests::test_decimal_matches_coq_model].

    Division (round-half-to-even at a bounded scale) is *not* modelled here: it is
    the one non-exact operation, and like BigInt's bit-serial divmod it is tied to
    its specification by the executable cross-check in the Rust test suite rather
    than an algorithmic proof. This file proves the *exact* core (the ring
    homomorphism + value-based order), which is the soundness foundation the
    rounded division is built on. Stated, not hidden.

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import QArith.QArith.
From Stdlib Require Import Lia.

(** ** Powers of ten (the scale denominators) *)

Open Scope Z_scope.

(** [10^s] as a [Z]; the denominator of a scale-[s] decimal. *)
Definition ten_pow (s : nat) : Z := 10 ^ Z.of_nat s.

Lemma ten_pow_pos : forall s, 0 < ten_pow s.
Proof. intro s. unfold ten_pow. apply Z.pow_pos_nonneg; [lia | apply Nat2Z.is_nonneg]. Qed.

(** Powers of ten are multiplicative in the (nat) exponent — the algebraic fact
    behind scale alignment ([10^(a+b) = 10^a * 10^b]). *)
Lemma ten_pow_add : forall a b, ten_pow (a + b) = ten_pow a * ten_pow b.
Proof.
  intros a b. unfold ten_pow.
  rewrite Nat2Z.inj_add, Z.pow_add_r; try apply Nat2Z.is_nonneg. reflexivity.
Qed.

(** ** Rational denotation *)

Open Scope Q_scope.

(** [inject_Z] of a positive integer is a nonzero (resp. positive) rational —
    the denominators are never zero, so division is well-defined. *)
Lemma injZ_pos_nz : forall d, (0 < d)%Z -> ~ inject_Z d == 0.
Proof. intros d Hd Heq. unfold Qeq, inject_Z in Heq. simpl in Heq. lia. Qed.

Lemma injZ_pos : forall d, (0 < d)%Z -> 0 < inject_Z d.
Proof. intros d Hd. unfold Qlt, inject_Z. simpl. lia. Qed.

(** [inject_Z] is injective for equality and order (used by value-based
    comparison: same positive denominator ⇒ the [Q] order is the [Z] order). *)
Lemma injZ_eq_iff : forall x y, inject_Z x == inject_Z y <-> (x = y)%Z.
Proof. intros x y. unfold Qeq, inject_Z. simpl. lia. Qed.

Lemma injZ_lt_iff : forall x y, inject_Z x < inject_Z y <-> (x < y)%Z.
Proof. intros x y. unfold Qlt, inject_Z. simpl. lia. Qed.

(** A scale-[s] decimal: a [Z] mantissa over the denominator [10^s]. *)
Record Dec : Set := mkDec { mant : Z; scal : nat }.

(** The value denoted: [mantissa / 10^scale]. *)
Definition value (d : Dec) : Q := inject_Z (mant d) / inject_Z (ten_pow (scal d)).

(** ** Field building blocks (all probe-verified over [Q]) *)

(** Addition with a common denominator distributes over the numerators. *)
Lemma value_add_same_scale : forall x y s,
  value (mkDec (x + y) s) == value (mkDec x s) + value (mkDec y s).
Proof.
  intros x y s. unfold value; simpl. rewrite inject_Z_plus. field.
  apply injZ_pos_nz, ten_pow_pos.
Qed.

Lemma value_sub_same_scale : forall x y s,
  value (mkDec (x - y) s) == value (mkDec x s) - value (mkDec y s).
Proof.
  intros x y s. unfold value; simpl.
  replace (x - y)%Z with (x + - y)%Z by ring.
  rewrite inject_Z_plus, inject_Z_opp. field.
  apply injZ_pos_nz, ten_pow_pos.
Qed.

(** Scale invariance: re-expressing a mantissa at a larger scale (multiplying it
    by [10^(s-sc)] and using denominator [10^s]) leaves the value unchanged.
    This is the heart of "align then operate". *)
Lemma value_align_general : forall m sc s, (sc <= s)%nat ->
  value (mkDec (m * ten_pow (s - sc)) s) == value (mkDec m sc).
Proof.
  intros m sc s Hle. unfold value; simpl.
  assert (Hs : (ten_pow s = ten_pow sc * ten_pow (s - sc))%Z).
  { replace s with (sc + (s - sc))%nat at 1 by lia. apply ten_pow_add. }
  rewrite Hs, !inject_Z_mult. field.
  split; apply injZ_pos_nz, ten_pow_pos.
Qed.

(** Same-positive-denominator comparison reduces to integer comparison on the
    numerators (so value equality/order are decided by the aligned mantissas). *)
Lemma value_same_scale_eq_iff : forall x y s,
  value (mkDec x s) == value (mkDec y s) <-> (x = y)%Z.
Proof.
  intros x y s. unfold value; simpl.
  assert (HD : ~ inject_Z (ten_pow s) == 0) by (apply injZ_pos_nz, ten_pow_pos).
  rewrite <- injZ_eq_iff. split.
  - intro H. apply (Qmult_inj_r _ _ (Qinv (inject_Z (ten_pow s)))).
    + intro Hinv.
      assert (Hc : inject_Z (ten_pow s) * Qinv (inject_Z (ten_pow s)) == 0)
        by (rewrite Hinv; ring).
      rewrite Qmult_inv_r in Hc by exact HD. revert Hc. discriminate.
    + unfold Qdiv in H. exact H.
  - intro H. unfold Qdiv. rewrite H. reflexivity.
Qed.

Lemma value_same_scale_lt_iff : forall x y s,
  (value (mkDec x s) < value (mkDec y s))%Q <-> (x < y)%Z.
Proof.
  intros x y s. unfold value; simpl.
  rewrite <- injZ_lt_iff. split.
  - intro H. apply (Qmult_lt_r _ _ (Qinv (inject_Z (ten_pow s)))).
    + apply Qinv_lt_0_compat, injZ_pos, ten_pow_pos.
    + unfold Qdiv in H. exact H.
  - intro H. unfold Qdiv.
    apply Qmult_lt_r; [apply Qinv_lt_0_compat, injZ_pos, ten_pow_pos | exact H].
Qed.

(** ** Operations (mirroring [decimal.rs]) *)

(** Common scale of two decimals: [max] of the two scales. *)
Definition cs (a b : Dec) : nat := Nat.max (scal a) (scal b).

(** The two operands re-expressed at the common scale. *)
Definition aligned_l (a b : Dec) : Z := mant a * ten_pow (cs a b - scal a).
Definition aligned_r (a b : Dec) : Z := mant b * ten_pow (cs a b - scal b).

Definition dadd (a b : Dec) : Dec := mkDec (aligned_l a b + aligned_r a b) (cs a b).
Definition dsub (a b : Dec) : Dec := mkDec (aligned_l a b - aligned_r a b) (cs a b).
Definition dmul (a b : Dec) : Dec := mkDec (mant a * mant b) (scal a + scal b).
Definition dneg (a : Dec) : Dec := mkDec (- mant a) (scal a).
Definition dcompare (a b : Dec) : comparison := Z.compare (aligned_l a b) (aligned_r a b).

(** Aligning either operand to the common scale preserves its value. *)
Lemma value_aligned_l : forall a b,
  value (mkDec (aligned_l a b) (cs a b)) == value a.
Proof.
  intros a b. destruct a as [ma sa]. unfold aligned_l, cs; simpl.
  apply value_align_general. apply Nat.le_max_l.
Qed.

Lemma value_aligned_r : forall a b,
  value (mkDec (aligned_r a b) (cs a b)) == value b.
Proof.
  intros a b. destruct b as [mb sb]. unfold aligned_r, cs; simpl.
  apply value_align_general. apply Nat.le_max_r.
Qed.

(** ** Headline: [value] is a ring homomorphism to [Q] *)

Theorem value_add : forall a b, value (dadd a b) == value a + value b.
Proof.
  intros a b. unfold dadd.
  rewrite value_add_same_scale, value_aligned_l, value_aligned_r. reflexivity.
Qed.

Theorem value_sub : forall a b, value (dsub a b) == value a - value b.
Proof.
  intros a b. unfold dsub.
  rewrite value_sub_same_scale, value_aligned_l, value_aligned_r. reflexivity.
Qed.

Theorem value_mul : forall a b, value (dmul a b) == value a * value b.
Proof.
  intros a b. destruct a as [ma sa], b as [mb sb]. unfold dmul, value; simpl.
  rewrite ten_pow_add, !inject_Z_mult. field.
  split; apply injZ_pos_nz, ten_pow_pos.
Qed.

Theorem value_neg : forall a, value (dneg a) == - value a.
Proof.
  intros a. destruct a as [ma sa]. unfold dneg, value; simpl.
  rewrite inject_Z_opp. field. apply injZ_pos_nz, ten_pow_pos.
Qed.

(** ** Value-based comparison (scale-insensitive) *)

Theorem compare_eq : forall a b, dcompare a b = Eq <-> value a == value b.
Proof.
  intros a b. unfold dcompare. rewrite Z.compare_eq_iff.
  rewrite <- value_same_scale_eq_iff with (s := cs a b).
  rewrite value_aligned_l, value_aligned_r. reflexivity.
Qed.

Theorem compare_lt : forall a b, dcompare a b = Lt <-> (value a < value b)%Q.
Proof.
  intros a b. unfold dcompare. rewrite Z.compare_lt_iff.
  rewrite <- value_same_scale_lt_iff with (s := cs a b).
  rewrite value_aligned_l, value_aligned_r. reflexivity.
Qed.

Theorem compare_gt : forall a b, dcompare a b = Gt <-> (value b < value a)%Q.
Proof.
  intros a b. unfold dcompare. rewrite Z.compare_gt_iff.
  rewrite <- value_same_scale_lt_iff with (s := cs a b).
  rewrite value_aligned_l, value_aligned_r. reflexivity.
Qed.

(** ** Executable cross-check (Coq model <-> Rust <-> concrete decimals)

    Each KAT pins a concrete decimal the running [decimal.rs] reproduces (its
    [to_string_repr]), closed by [vm_compute]; asserted in the parity test
    [decimal::tests::test_decimal_matches_coq_model]. *)

(** 0.1 + 0.2 = 0.3 exactly (no binary-float drift). *)
Example add_point1_point2 :
  Qeq_bool (value (dadd (mkDec 1 1) (mkDec 2 1))) (value (mkDec 3 1)) = true.
Proof. vm_compute. reflexivity. Qed.

(** 1.5 * 1.5 = 2.25 (scale 1+1=2). *)
Example mul_1p5_1p5 :
  Qeq_bool (value (dmul (mkDec 15 1) (mkDec 15 1))) (value (mkDec 225 2)) = true.
Proof. vm_compute. reflexivity. Qed.

(** A >64-bit exact product: 9999999999.99^2 = 99999999999800000000.0001. *)
Example mul_big_exact :
  Qeq_bool
    (value (dmul (mkDec 999999999999 2) (mkDec 999999999999 2)))
    (value (mkDec 999999999998000000000001 4)) = true.
Proof. vm_compute. reflexivity. Qed.

(** 5 - 0.01 = 4.99 (scales aligned to 2). *)
Example sub_5_point01 :
  Qeq_bool (value (dsub (mkDec 5 0) (mkDec 1 2))) (value (mkDec 499 2)) = true.
Proof. vm_compute. reflexivity. Qed.

(** -3.14 is the negation of 3.14. *)
Example neg_3p14 :
  Qeq_bool (value (dneg (mkDec 314 2))) (value (mkDec (-314) 2)) = true.
Proof. vm_compute. reflexivity. Qed.

(** Value-based comparison: 3.14 == 3.140 (different scales, equal value). *)
Example compare_3p14_3p140 : dcompare (mkDec 314 2) (mkDec 3140 3) = Eq.
Proof. vm_compute. reflexivity. Qed.

(** 3.14 < 3.15. *)
Example compare_3p14_3p15 : dcompare (mkDec 314 2) (mkDec 315 2) = Lt.
Proof. vm_compute. reflexivity. Qed.

(** 100.00 == 100 (trailing-zero scale invisible to value). *)
Example compare_100_100 : dcompare (mkDec 10000 2) (mkDec 100 0) = Eq.
Proof. vm_compute. reflexivity. Qed.
