(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Crypto — GHASH GF(2^128) Multiplication, Formal Equivalence

    A mechanized model of the GF(2^128) multiplication used by GHASH / AES-GCM
    (SP 800-38D), faithful to the bit-serial algorithm in
    [05_TOOLING/crates/riina-core/src/crypto/ghash.rs::gf128_mul].

    Faithfulness map (Rust 16-byte big-endian block <-> [Z] in [[0, 2^128)],
    byte 0 the most-significant byte, so block bit "byte b, bit (7 - k)" is
    [Z] bit [127 - (8*b + k)] and GCM polynomial coefficient of [x^(8*b+k)]):

      Rust                                   Coq
      ----                                   ---
      z ^= v                                 Z.lxor z v
      v >> 1   (over the 16-byte array)      Z.shiftr v 1
      lsb = v[15] & 1                        Z.testbit v 0
      v[0] ^= 0xe1   (if lsb)                Z.lxor _ RED,  RED = 0xe1 << 120
      bit i of y, MSB-first (byte i/8,       Z.testbit y (127 - i)
        bit 7-(i%8))

    [mulx] is multiplication by the generator [x]; [gf_mul x y] folds it over
    the 128 bits of [y], exactly as the Rust loop does.

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. The algebraic laws are
    proved by bit extensionality ([Z.bits_inj']) reduced to boolean tautology
    ([btauto]); the NIST cross-check is closed by [vm_compute]. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import Lia.
From Stdlib Require Import Btauto.

Open Scope Z_scope.

(** ** Constants (in the Rust big-endian representation) *)

(** Reduction constant: [0xe1] in the most-significant byte (byte 0). *)
Definition RED : Z := Z.shiftl 225 120.   (* 0xe1 = 225 *)

(** Multiplicative identity: GCM's "1" is the polynomial [x^0], i.e. the
    most-significant bit of byte 0 = [Z] bit 127. *)
Definition ONE : Z := Z.shiftl 1 127.

(** ** Operations faithful to [gf128_mul] *)

(** Multiply a field element by the generator [x] (one Rust loop step on [v]). *)
Definition mulx (v : Z) : Z :=
  if Z.testbit v 0 then Z.lxor (Z.shiftr v 1) RED else Z.shiftr v 1.

(** The Rust loop: [n] steps starting at bit position [pos] (127 downto 0),
    accumulating [z] and advancing [v := mulx v] each step. *)
Fixpoint gf_iter (n : nat) (pos : Z) (y z v : Z) : Z :=
  match n with
  | O => z
  | S k =>
      let z' := if Z.testbit y pos then Z.lxor z v else z in
      gf_iter k (pos - 1) y z' (mulx v)
  end.

(** GHASH field multiplication [x * y] in GF(2^128). *)
Definition gf_mul (x y : Z) : Z := gf_iter 128 127 y 0 x.

(** ** Additive structure is XOR (inherited from [Z.lxor]) *)

Lemma add_comm  : forall a b, Z.lxor a b = Z.lxor b a.            Proof. exact Z.lxor_comm. Qed.
Lemma add_assoc : forall a b c, Z.lxor (Z.lxor a b) c = Z.lxor a (Z.lxor b c). Proof. exact Z.lxor_assoc. Qed.
Lemma add_0_r   : forall a, Z.lxor a 0 = a.                       Proof. exact Z.lxor_0_r. Qed.
Lemma add_nilpotent : forall a, Z.lxor a a = 0.
Proof. intro a. apply Z.lxor_nilpotent. Qed.

(** A handy XOR rearrangement, proved by bit extensionality. *)
Lemma lxor_swap_mid : forall a b c d,
  Z.lxor (Z.lxor a b) (Z.lxor c d) = Z.lxor (Z.lxor a c) (Z.lxor b d).
Proof. intros. apply Z.bits_inj'. intros n _. rewrite !Z.lxor_spec. btauto. Qed.

(** ** [mulx] is linear (a GF(2)-linear / additive map) *)

Lemma mulx_linear : forall a b, mulx (Z.lxor a b) = Z.lxor (mulx a) (mulx b).
Proof.
  intros a b. unfold mulx.
  rewrite Z.shiftr_lxor, Z.lxor_spec.
  destruct (Z.testbit a 0), (Z.testbit b 0); simpl;
    apply Z.bits_inj'; intros n _; rewrite !Z.lxor_spec; btauto.
Qed.

(** ** Right-linearity: [x * (a + b) = x*a + x*b] *)

Lemma gf_iter_y0 : forall n pos v, gf_iter n pos 0 0 v = 0.
Proof.
  induction n; intros pos v; simpl.
  - reflexivity.
  - rewrite Z.testbit_0_l. apply IHn.
Qed.

Lemma gf_mul_0_r : forall x, gf_mul x 0 = 0.
Proof. intro x. unfold gf_mul. apply gf_iter_y0. Qed.

Lemma gf_iter_distr_y : forall n pos a b za zb v,
  gf_iter n pos (Z.lxor a b) (Z.lxor za zb) v
  = Z.lxor (gf_iter n pos a za v) (gf_iter n pos b zb v).
Proof.
  induction n; intros pos a b za zb v; simpl.
  - reflexivity.
  - rewrite Z.lxor_spec.
    destruct (Z.testbit a pos), (Z.testbit b pos); simpl;
      rewrite <- IHn; f_equal;
      apply Z.bits_inj'; intros m _; rewrite !Z.lxor_spec; btauto.
Qed.

Lemma gf_mul_distr_r : forall x a b,
  gf_mul x (Z.lxor a b) = Z.lxor (gf_mul x a) (gf_mul x b).
Proof.
  intros x a b. unfold gf_mul.
  (* The accumulator 0 must be exhibited as [Z.lxor 0 0]; [exact] with
     explicit arguments decides that by conversion ([Z.lxor 0 0] reduces
     to [0]), where the previous [rewrite <- (Z.lxor_0_l 0) at 1] drove
     the setoid-rewrite occurrence machinery through the unfolded
     [gf_iter 128] goal — pathologically slow (hours on a slow vCPU). *)
  exact (gf_iter_distr_y 128%nat 127 a b 0 0 x).
Qed.

(** ** Left-linearity: [(a + b) * y = a*y + b*y] *)

Lemma gf_iter_distr_x : forall n pos y za zb va vb,
  gf_iter n pos y (Z.lxor za zb) (Z.lxor va vb)
  = Z.lxor (gf_iter n pos y za va) (gf_iter n pos y zb vb).
Proof.
  induction n; intros pos y za zb va vb; simpl.
  - reflexivity.
  - destruct (Z.testbit y pos); simpl;
      rewrite mulx_linear; rewrite <- IHn; f_equal;
      apply Z.bits_inj'; intros m _; rewrite !Z.lxor_spec; btauto.
Qed.

Lemma gf_mul_distr_l : forall a b y,
  gf_mul (Z.lxor a b) y = Z.lxor (gf_mul a y) (gf_mul b y).
Proof.
  intros a b y. unfold gf_mul.
  (* Same conversion-based closure as [gf_mul_distr_r] above. *)
  exact (gf_iter_distr_x 128%nat 127 y 0 0 a b).
Qed.

(** ** Multiplicative identity: [x * 1 = x] *)

Lemma testbit_ONE : forall k, k <> 127 -> Z.testbit ONE k = false.
Proof.
  intros k Hk. unfold ONE. rewrite Z.shiftl_1_l.
  destruct (Z_lt_le_dec k 0) as [Hneg | Hpos].
  - apply Z.testbit_neg_r. lia.
  - rewrite Z.pow2_bits_eqb by lia. apply Z.eqb_neq. lia.
Qed.

Lemma gf_iter_one_tail : forall n pos x v, pos <= 126 -> gf_iter n pos ONE x v = x.
Proof.
  induction n; intros pos x v Hpos; simpl.
  - reflexivity.
  - rewrite testbit_ONE by lia. apply IHn. lia.
Qed.

(** One-step unfolding of [gf_iter] (definitional). Used to step the loop
    without [simpl], which would try to unfold all 128 iterations and diverge. *)
Lemma gf_iter_S : forall k pos y z v,
  gf_iter (S k) pos y z v
  = gf_iter k (pos - 1) y (if Z.testbit y pos then Z.lxor z v else z) (mulx v).
Proof. reflexivity. Qed.

Lemma gf_mul_one_r : forall x, gf_mul x ONE = x.
Proof.
  intro x. unfold gf_mul.
  change 128%nat with (S 127%nat). rewrite gf_iter_S.
  replace (Z.testbit ONE 127) with true.
  - rewrite Z.lxor_0_l. apply gf_iter_one_tail. lia.
  - symmetry. unfold ONE. rewrite Z.shiftl_1_l, Z.pow2_bits_eqb by lia.
    apply Z.eqb_refl.
Qed.

(** ** Closure: the field operations stay within the 128-bit block *)

Definition in128 (x : Z) : Prop := 0 <= x < 2 ^ 128.

(** Bits at or above the bound are clear (forward direction). *)
Lemma bits_above_bound : forall a n k,
  0 <= n -> 0 <= a < 2 ^ n -> n <= k -> Z.testbit a k = false.
Proof.
  intros a n k Hn [Ha0 Ha1] Hnk.
  apply Z.testbit_false; [lia|].
  replace (a / 2 ^ k) with 0; [reflexivity|].
  symmetry. apply Z.div_small. split; [exact Ha0|].
  apply Z.lt_le_trans with (2 ^ n); [exact Ha1|].
  apply Z.pow_le_mono_r; lia.
Qed.

(** Converse: a nonneg value with all bits >= n clear is < 2^n. *)
Lemma lt_pow2_of_bits : forall x n,
  0 <= n -> 0 <= x -> (forall k, n <= k -> Z.testbit x k = false) -> x < 2 ^ n.
Proof.
  intros x n Hn Hx Hbits.
  destruct (Z_lt_le_dec x (2 ^ n)) as [H | H]; [exact H | exfalso].
  assert (Hxpos : 0 < x).
  { apply Z.lt_le_trans with (2 ^ n); [apply Z.pow_pos_nonneg; lia | exact H]. }
  assert (Hlog : n <= Z.log2 x) by (rewrite <- Z.log2_le_pow2 by exact Hxpos; exact H).
  assert (Hbit : Z.testbit x (Z.log2 x) = true) by (apply Z.bit_log2; exact Hxpos).
  rewrite Hbits in Hbit by exact Hlog. discriminate.
Qed.

(** XOR (the field addition) is closed in [in128]. *)
Lemma lxor_in128 : forall a b, in128 a -> in128 b -> in128 (Z.lxor a b).
Proof.
  intros a b [Ha0 Ha1] [Hb0 Hb1]. unfold in128. split.
  - rewrite Z.lxor_nonneg. tauto.
  - apply lt_pow2_of_bits; [lia | rewrite Z.lxor_nonneg; tauto |].
    intros k Hk.
    assert (Ta : Z.testbit a k = false) by
      (apply (bits_above_bound a 128 k); [lia | split; assumption | exact Hk]).
    assert (Tb : Z.testbit b k = false) by
      (apply (bits_above_bound b 128 k); [lia | split; assumption | exact Hk]).
    rewrite Z.lxor_spec, Ta, Tb. reflexivity.
Qed.

Lemma RED_in128 : in128 RED.
Proof.
  unfold in128, RED. rewrite Z.shiftl_mul_pow2 by lia.
  assert (Hp : 0 < 2 ^ 120) by (apply Z.pow_pos_nonneg; lia).
  assert (E : 2 ^ 128 = 256 * 2 ^ 120) by (vm_compute; reflexivity).
  split; nia.
Qed.

(** [shiftr _ 1] (multiply-by-x's shift) is closed. *)
Lemma shiftr1_in128 : forall v, in128 v -> in128 (Z.shiftr v 1).
Proof.
  intros v [H0 H1]. unfold in128. rewrite Z.shiftr_div_pow2 by lia.
  change (2 ^ 1) with 2. split.
  - apply Z.div_pos; lia.
  - apply Z.le_lt_trans with v; [apply Z.div_le_upper_bound; lia | exact H1].
Qed.

(** [mulx] (multiply by the generator) is closed. *)
Lemma mulx_in128 : forall v, in128 v -> in128 (mulx v).
Proof.
  intros v Hv. unfold mulx. destruct (Z.testbit v 0).
  - apply lxor_in128; [apply shiftr1_in128; exact Hv | apply RED_in128].
  - apply shiftr1_in128; exact Hv.
Qed.

(** The loop is closed, hence so is [gf_mul]. *)
Lemma gf_iter_in128 : forall n pos y z v,
  in128 z -> in128 v -> in128 (gf_iter n pos y z v).
Proof.
  induction n; intros pos y z v Hz Hv; simpl.
  - exact Hz.
  - apply IHn.
    + destruct (Z.testbit y pos); [apply lxor_in128; assumption | exact Hz].
    + apply mulx_in128; exact Hv.
Qed.

Lemma gf_mul_in128 : forall x y, in128 x -> in128 (gf_mul x y).
Proof.
  intros x y Hx. unfold gf_mul. apply gf_iter_in128; [|exact Hx].
  unfold in128. split; [lia | apply Z.pow_pos_nonneg; lia].
Qed.

(** ** Executable cross-check (Coq model <-> Rust <-> concrete vector)

    The model's concrete product is closed by [vm_compute] and asserted
    byte-identical to the Rust [gf128_mul] in the parity test
    [crypto::ghash::tests::test_gf128_mul_matches_coq_model]. (This bridge caught
    a real reduction-constant transcription error during development — exactly
    why an executable formal-equivalence anchor is worth having.) *)

Definition Xk : Z := 0x123456789abcdef01122334455667788.
Definition Yk : Z := 0xfedcba9876543210aabbccddeeff0011.
Definition Pk : Z := 0x650450d276326c809acbd6127814a7f1.

Example gf_mul_kat       : gf_mul Xk Yk = Pk. Proof. vm_compute. reflexivity. Qed.
Example gf_mul_kat_comm  : gf_mul Yk Xk = Pk. Proof. vm_compute. reflexivity. Qed.
Example gf_mul_kat_one   : gf_mul Xk ONE = Xk. Proof. vm_compute. reflexivity. Qed.
Example gf_mul_kat_zero  : gf_mul Xk 0 = 0.    Proof. vm_compute. reflexivity. Qed.

(** Closure of the model on the concrete operands (a sanity instance of
    [gf_mul_in128]). *)
Example pk_in128 : in128 Pk. Proof. unfold in128, Pk. split; [lia | vm_compute; reflexivity]. Qed.
