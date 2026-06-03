(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Math — Verified Laws for the Numeric Builtins

    The algebraic laws satisfied by the prototype's integer math builtins
    (`riina-codegen/src/builtins/matematik.rs`), modelled over [nat] (the
    prototype's `Nombor` is an unsigned 64-bit integer):

    - **min / max** (`min`/`minimum`, `max`/`maksimum`): commutativity,
      idempotence, the order bounds, and the identity `min a b + max a b = a + b`.
    - **gcd** (`gcd`, an Euclidean loop): it divides both arguments, is
      commutative, and `gcd a 0 = a`.
    - **pow** (`pow`/`kuasa`): `b^0 = 1`, `b^1 = b`, `b^(m+n) = b^m · b^n`.

    `abs`/`mutlak` is the identity on `Nombor` (unsigned ⇒ non-negative) and
    `sqrt`/`punca` is an `f64`-based floor — neither is modelled here; both are
    exercised by the property tests in `matematik.rs`, which also confirm the
    running `min`/`max`/`gcd`/`lcm`/`pow`/`rem` builtins compute exactly the
    `Nat` functions whose laws are proved below.

    Mirrors `foundations/VerifiedList.v` / `VerifiedMapSet.v` / `VerifiedString.v`.
    Stdlib-backed and fully constructive — every lemma is machine-checked. *)

From Stdlib Require Import Arith.
From Stdlib Require Import Lia.

(* ========================================================================= *)
(** ** min / max — `min`/`minimum` and `max`/`maksimum`                      *)
(* ========================================================================= *)

Theorem min_comm : forall a b, Nat.min a b = Nat.min b a.
Proof. intros. lia. Qed.

Theorem max_comm : forall a b, Nat.max a b = Nat.max b a.
Proof. intros. lia. Qed.

Theorem min_idempotent : forall a, Nat.min a a = a.
Proof. intros. lia. Qed.

Theorem max_idempotent : forall a, Nat.max a a = a.
Proof. intros. lia. Qed.

Theorem min_le_left : forall a b, Nat.min a b <= a.
Proof. intros. lia. Qed.

Theorem min_le_right : forall a b, Nat.min a b <= b.
Proof. intros. lia. Qed.

Theorem max_ge_left : forall a b, a <= Nat.max a b.
Proof. intros. lia. Qed.

Theorem max_ge_right : forall a b, b <= Nat.max a b.
Proof. intros. lia. Qed.

Theorem min_le_max : forall a b, Nat.min a b <= Nat.max a b.
Proof. intros. lia. Qed.

(** The defining identity tying `min` and `max` together. *)
Theorem min_max_sum : forall a b, Nat.min a b + Nat.max a b = a + b.
Proof. intros. lia. Qed.

(** Each of `min`/`max` returns one of its arguments. *)
Theorem min_is_one_arg : forall a b, Nat.min a b = a \/ Nat.min a b = b.
Proof. intros. lia. Qed.

Theorem max_is_one_arg : forall a b, Nat.max a b = a \/ Nat.max a b = b.
Proof. intros. lia. Qed.

(* ========================================================================= *)
(** ** gcd — `gcd` (the Euclidean loop in `gcd_impl`)                        *)
(* ========================================================================= *)

(** `gcd a b` divides both arguments. *)
Theorem gcd_divides_left : forall a b, Nat.divide (Nat.gcd a b) a.
Proof. exact Nat.gcd_divide_l. Qed.

Theorem gcd_divides_right : forall a b, Nat.divide (Nat.gcd a b) b.
Proof. exact Nat.gcd_divide_r. Qed.

Theorem gcd_comm : forall a b, Nat.gcd a b = Nat.gcd b a.
Proof. exact Nat.gcd_comm. Qed.

Theorem gcd_zero_right : forall a, Nat.gcd a 0 = a.
Proof. exact Nat.gcd_0_r. Qed.

(* ========================================================================= *)
(** ** pow — `pow` / `kuasa`                                                 *)
(* ========================================================================= *)

Theorem pow_zero : forall b, Nat.pow b 0 = 1.
Proof. exact Nat.pow_0_r. Qed.

Theorem pow_one : forall b, Nat.pow b 1 = b.
Proof. exact Nat.pow_1_r. Qed.

(** Exponent additivity: `b^(m+n) = b^m · b^n`. *)
Theorem pow_add : forall b m n, Nat.pow b (m + n) = Nat.pow b m * Nat.pow b n.
Proof. exact Nat.pow_add_r. Qed.
