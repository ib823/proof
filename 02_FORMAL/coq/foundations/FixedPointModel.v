(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Numeric Tower — Fixed-Point Model (wang / titik_tetap / qmn)

    A mechanized model of the *rounding* that distinguishes the fixed-point types
    in [03_PROTO/crates/riina-codegen/src/fixed.rs] (fixed-scale decimal money,
    [wang] / [titik_tetap]) and [.../fixed_bin.rs] (binary Q-format, [qmn]) from
    the exact [perpuluhan] decimal.

    Both fixed-point types share their *exact additive core* with the decimal:
    [wang] add/sub/neg are the same scale-aligned mantissa operations as
    [perpuluhan], so [DecimalModel]'s [value_add] / [value_sub] / [value_neg] and
    the value-based [compare_eq] / [compare_lt] / [compare_gt] already prove them
    a ring homomorphism to [Q] (no binary-float drift — the finance headline).
    Those are re-exported below ([wang_add_exact] / [wang_sub_exact] /
    [wang_neg_exact]) to make the reuse machine-checked, not merely asserted.

    What is *new* here is the single rounding primitive both fixed-point types
    use, [round_quotient] (a truncated divmod followed by a [|2r|] vs [|d|]
    comparison):

      * [wang] multiplication/division round the exact product/quotient
        half-to-even *back to the fixed scale* (so [10.00 / 3 = 3.33], not
        [3.333...]); and
      * [qmn] construction rounds a decimal literal half-to-even to the nearest
        representable [raw / 2^frac_bits].

    This file models that primitive as [round_he] and proves it is *correct
    rounding*:

      [round_he_nearest]   the result is within half a ULP of the true quotient
                           ([2 * |round_he m d * d - m| <= d]); and
      [round_he_tie_even]  on an exact half ([2 * (m mod d) = d]) the result is
                           even (banker's rounding — why [0.5 -> 0], [2.5 -> 2]).

    [round_quotient] decides on *magnitudes* (it compares [|2r|] to [|d|] and
    bumps away from zero), so the nonnegative model here captures the real
    rounding decision; the sign is reapplied symmetrically (cross-checked in the
    Rust suite). For nonnegative [m] and [d > 0] the floor divmod used here
    coincides with the truncated divmod the Rust code uses.

    The executable [vm_compute] KATs pin the concrete rounded values the running
    [fixed.rs] / [fixed_bin.rs] reproduce, asserted in
    [fixed::tests::test_fixed_matches_coq_model] and
    [fixed_bin::tests::test_fixedbin_matches_coq_model].

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import QArith.QArith.
From Stdlib Require Import Lia.
Require Import RIINA.foundations.DecimalModel.

Open Scope Z_scope.

(** ** The shared rounding primitive *)

(** Round [m / d] (for [m >= 0], [d > 0]) to the nearest integer, ties to even —
    the [round_quotient] of [fixed.rs] / [fixed_bin.rs]. Here over floor divmod,
    which for nonnegative [m] coincides with the truncated divmod Rust uses. *)
Definition round_he (m d : Z) : Z :=
  let q := m / d in
  let r := m mod d in
  if 2 * r <? d then q
  else if d <? 2 * r then q + 1
  else if Z.even q then q else q + 1.

(** Correct nearest-rounding: the result is within half a ULP of [m / d]
    (equivalently [|round_he m d - m/d| <= 1/2] over [Q]). *)
Lemma round_he_nearest : forall m d,
  0 <= m -> 0 < d -> 2 * Z.abs (round_he m d * d - m) <= d.
Proof.
  intros m d Hm Hd. unfold round_he.
  assert (Hd0 : d <> 0) by lia.
  pose proof (Z.div_mod m d Hd0) as Hdm.
  pose proof (Z.mod_pos_bound m d Hd) as [Hr0 Hrd].
  set (q := m / d) in *. set (r := m mod d) in *.
  destruct (2 * r <? d) eqn:E1.
  - apply Z.ltb_lt in E1.
    replace (q * d - m) with (- r) by nia.
    rewrite Z.abs_opp, Z.abs_eq by lia. lia.
  - apply Z.ltb_ge in E1. destruct (d <? 2 * r) eqn:E2.
    + apply Z.ltb_lt in E2.
      replace ((q + 1) * d - m) with (d - r) by nia.
      rewrite Z.abs_eq by lia. lia.
    + apply Z.ltb_ge in E2.
      destruct (Z.even q) eqn:Eq.
      * replace (q * d - m) with (- r) by nia.
        rewrite Z.abs_opp, Z.abs_eq by lia. lia.
      * replace ((q + 1) * d - m) with (d - r) by nia.
        rewrite Z.abs_eq by lia. lia.
Qed.

(** On an exact half, [round_he] rounds to an *even* integer (banker's rounding —
    why [0.5 -> 0], [1.5 -> 2], [2.5 -> 2], [3.5 -> 4]). *)
Lemma round_he_tie_even : forall m d,
  0 <= m -> 0 < d -> 2 * (m mod d) = d -> Z.even (round_he m d) = true.
Proof.
  intros m d Hm Hd Htie. unfold round_he.
  set (q := m / d) in *. set (r := m mod d) in *.
  assert (E1 : (2 * r <? d) = false) by (apply Z.ltb_ge; lia).
  assert (E2 : (d <? 2 * r) = false) by (apply Z.ltb_ge; lia).
  rewrite E1, E2.
  destruct (Z.even q) eqn:Eq.
  - exact Eq.
  - rewrite Z.add_1_r, Z.even_succ, <- Z.negb_even, Eq. reflexivity.
Qed.

(** ** Executable cross-check (Coq [round_he] <-> Rust [round_quotient])

    Each KAT pins a concrete rounded integer the running [fixed.rs] /
    [fixed_bin.rs] reproduces, closed by [vm_compute]. *)

(** [wang]: 10.00 / 3 = 3.33 (round the quotient back to scale 2). *)
Example wang_10_div_3 : round_he 1000 3 = 333.
Proof. vm_compute. reflexivity. Qed.

(** [wang]: 1.55 * 1.55 = 2.40 (exact 2.4025 rounded to scale 2). *)
Example wang_1p55_squared : round_he 24025 100 = 240.
Proof. vm_compute. reflexivity. Qed.

(** [wang]: 0.5 * 0.5 = 0.2 (exact 0.25 at scale 1 — a tie, rounds to even 2). *)
Example wang_0p5_squared_even : round_he 25 10 = 2.
Proof. vm_compute. reflexivity. Qed.

(** [titik_tetap("3.145", 2)] = 3.14 (a tie; 314 is even). *)
Example titik_tetap_3p145 : round_he 3145 10 = 314.
Proof. vm_compute. reflexivity. Qed.

(** [titik_tetap("3.155", 2)] = 3.16 (a tie; 315 is odd, so up to 316). *)
Example titik_tetap_3p155 : round_he 3155 10 = 316.
Proof. vm_compute. reflexivity. Qed.

(** [qmn("0.1", 8)]: round(0.1 * 2^8) = round_he 256 10 = 26, so 26/256 =
    0.1015625 (0.1 is not a binary fraction). *)
Example qmn_0p1_8bits : round_he 256 10 = 26.
Proof. vm_compute. reflexivity. Qed.

(** [qmn("0.03125", 4)]: 0.03125 * 2^4 = 0.5 — a tie, rounds to even 0. *)
Example qmn_0p03125_4bits : round_he 50000 100000 = 0.
Proof. vm_compute. reflexivity. Qed.

(** [qmn("0.09375", 4)]: 0.09375 * 2^4 = 1.5 — a tie, rounds to even 2. *)
Example qmn_0p09375_4bits : round_he 150000 100000 = 2.
Proof. vm_compute. reflexivity. Qed.

(** ** The exact additive core is the proven decimal homomorphism

    [wang]/[titik_tetap] add/sub/neg are literally [perpuluhan]'s scale-aligned
    mantissa operations ([dadd]/[dsub]/[dneg]), so [DecimalModel]'s ring
    homomorphism to [Q] proves them exact — no rounding, no float drift. *)

Corollary wang_add_exact : forall a b,
  (value (dadd a b) == value a + value b)%Q.
Proof. exact value_add. Qed.

Corollary wang_sub_exact : forall a b,
  (value (dsub a b) == value a - value b)%Q.
Proof. exact value_sub. Qed.

Corollary wang_neg_exact : forall a,
  (value (dneg a) == - value a)%Q.
Proof. exact value_neg. Qed.
