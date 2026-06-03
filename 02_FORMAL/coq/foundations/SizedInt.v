(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Numeric Tower — Fixed-Width Integer Model

    A foundational model of RIINA's fixed-width integer types ([Ty::IntN]):
    a width-[bits] unsigned value is the residue of an integer modulo
    [2 ^ bits], and wrapping arithmetic is arithmetic in [Z / 2^bits Z].

    These lemmas justify the prototype's width-aware evaluation and codegen,
    which compute the same width-[bits] result along three independent paths:

      - the interpreter ([Value::IntN]) reduces each result with [mask_width];
      - the C backend reduces via [riina_trunc] (value & (2^bits - 1));
      - the WASM backend reduces via [i32.and (2^bits - 1)].

    The soundness property they share is the ring homomorphism
    [Z -> Z / 2^bits Z]: reducing the operands and reducing only the final
    result agree, so the three paths cannot disagree ([wrapU_add]/[_sub]/[_mul]).
    The bit-mask the backends actually emit ([Z.land x (2^bits - 1)]) is proved
    equal to that modular reduction ([land_ones_is_wrapU]).

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. Proofs are direct
    consequences of the Rocq standard library's modular-arithmetic lemmas.
*)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import Lia.

Open Scope Z_scope.

(** ** Width and modulus *)

(** The modulus of a width-[bits] integer type is [2 ^ bits]
    (256 for [u8]/[i8], 65536 for [u16]/[i16], ...). *)
Definition modulus (bits : nat) : Z := 2 ^ (Z.of_nat bits).

Lemma modulus_pos : forall bits, 0 < modulus bits.
Proof.
  intros bits. unfold modulus. apply Z.pow_pos_nonneg; lia.
Qed.

(** ** Unsigned wrapping — the [Value::IntN] / [riina_trunc] semantics *)

(** Reduce an integer into the unsigned width-[bits] range [[0, 2^bits)]. *)
Definition wrapU (bits : nat) (x : Z) : Z := x mod modulus bits.

(** A wrapped value always lies in the representable range. *)
Lemma wrapU_range : forall bits x, 0 <= wrapU bits x < modulus bits.
Proof.
  intros bits x. unfold wrapU. apply Z.mod_pos_bound, modulus_pos.
Qed.

(** Reducing an already-reduced value is a no-op (idempotence): the prototype
    may re-mask a sized value freely. *)
Lemma wrapU_idemp : forall bits x, wrapU bits (wrapU bits x) = wrapU bits x.
Proof.
  intros bits x. unfold wrapU. now rewrite Zmod_mod.
Qed.

(** *** Ring homomorphism: reduce-at-the-end = reduce-throughout.

    This is the property the three backends rely on. Whether operands are
    reduced to the width before the operation (the interpreter, where each
    [Value::IntN] is already in range) or only the result is reduced (the
    backends' single trailing mask), the width-[bits] answer is identical. *)

Lemma wrapU_add : forall bits x y,
  wrapU bits (x + y) = wrapU bits (wrapU bits x + wrapU bits y).
Proof.
  intros bits x y. unfold wrapU. now rewrite Zplus_mod.
Qed.

Lemma wrapU_sub : forall bits x y,
  wrapU bits (x - y) = wrapU bits (wrapU bits x - wrapU bits y).
Proof.
  intros bits x y. unfold wrapU. now rewrite Zminus_mod.
Qed.

Lemma wrapU_mul : forall bits x y,
  wrapU bits (x * y) = wrapU bits (wrapU bits x * wrapU bits y).
Proof.
  intros bits x y. unfold wrapU. now rewrite Zmult_mod.
Qed.

(** ** The backends' bit-mask equals modular reduction.

    The C and WASM backends compute [value & (2^bits - 1)]. That bitwise AND
    with a mask of [bits] low ones is exactly reduction modulo [2^bits], so the
    emitted code realises [wrapU]. *)

Lemma land_ones_is_wrapU : forall bits x,
  Z.land x (2 ^ (Z.of_nat bits) - 1) = wrapU bits x.
Proof.
  intros bits x. unfold wrapU, modulus.
  replace (2 ^ (Z.of_nat bits) - 1) with (Z.ones (Z.of_nat bits)).
  - apply Z.land_ones. lia.
  - rewrite Z.ones_equiv. lia.
Qed.

(** ** Signed interpretation — the [sext_width] / signed display semantics *)

(** Reinterpret a width-[bits] unsigned residue as a two's-complement signed
    value in [[-2^(bits-1), 2^(bits-1))]: residues below the half-modulus stay
    non-negative; the upper half is shifted down by the full modulus. *)
Definition toSigned (bits : nat) (x : Z) : Z :=
  if Z.ltb (wrapU bits x) (modulus bits / 2)
  then wrapU bits x
  else wrapU bits x - modulus bits.

(** The signed interpretation only depends on the width-[bits] residue, so it is
    stable under (re-)masking — the prototype computes [sext_width] of an
    already-masked value. *)
Lemma toSigned_wrapU : forall bits x,
  toSigned bits (wrapU bits x) = toSigned bits x.
Proof.
  intros bits x. unfold toSigned. now rewrite wrapU_idemp.
Qed.
