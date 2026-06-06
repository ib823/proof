(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Numeric Tower — Arbitrary-Precision Integer Model (BigInt)

    A mechanized model of the magnitude arithmetic in
    [03_PROTO/crates/riina-codegen/src/bigint.rs] (the [besar] bignum), faithful
    to its little-endian base-[2^32] limb representation.

    Faithfulness map (Rust [Vec<u32>], little-endian limbs <-> [Z]):

      Rust                                   Coq
      ----                                   ---
      mag : Vec<u32> (little-endian)         l : list Z   (each limb in [[0,beta)])
      value of mag                           eval l = sum_i mag[i] * beta^i
      add_mag (carry-propagate)              add  (eval-correct: a + b)
      a single scalar * b + carry            scale_c
      mul_mag (schoolbook)                   mul  (eval-correct: a * b)
      divmod_mag (bit-serial long division)  divmod (Z quot/rem; Euclid spec)

    The headline results are that [eval] is a *ring homomorphism* from the limb
    representation to [Z]: [eval (add a b) = eval a + eval b] ([eval_add]) and
    [eval (mul a b) = eval a * eval b] ([eval_mul]) — proved by induction over
    the limb lists, with the carry handled by the Euclidean identity
    [m = beta*(m/beta) + m mod beta]. So whatever limb vector the Rust algorithm
    produces and whatever vector the model produces, both *denote* the same
    integer; the executable [vm_compute] KATs at the file end pin concrete
    values, asserted byte-identical to the Rust [add]/[mul]/[divmod] in the
    parity test [bigint::tests::test_bigint_matches_coq_model].

    Division: truncated division is characterised at the spec level
    ([divmod_correct]: [u = q*v + r] with [0 <= r < v]); the Rust bit-serial loop
    is tied to that spec by the executable cross-check (the model computes [Z]
    quot/rem; the bridge asserts the Rust limb algorithm agrees). The per-step
    invariant of the shift-subtract loop is not itself inducted over — the
    distinction add/mul (algorithmic proof) vs divmod (spec + executable
    cross-check) is deliberate and stated here, not hidden.

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import Lia.
From Stdlib Require Import List.
Import ListNotations.

Open Scope Z_scope.

(** ** Base and denotation *)

(** The limb base: [2^32], matching the Rust [u32] limb. *)
Definition beta : Z := 2 ^ 32.

Lemma beta_pos : 0 < beta. Proof. unfold beta. apply Z.pow_pos_nonneg; lia. Qed.
Lemma beta_neq : beta <> 0. Proof. pose proof beta_pos. lia. Qed.

(** Seal [beta] so [simpl]/[cbn] in the algebraic proofs leave [beta * x] as a
    multiplication (otherwise [simpl] expands [2^32] and rewrites the product
    into a bit-shift, defeating [Z.mul_add_distr_l]). [vm_compute] still reduces
    through it for the concrete KATs. *)
Opaque beta.

(** Value denoted by a little-endian limb list. Trailing zero limbs do not
    change the value, so normalisation (which the Rust code does) is invisible
    to [eval]. *)
Fixpoint eval (l : list Z) : Z :=
  match l with
  | [] => 0
  | x :: t => x + beta * eval t
  end.

(** The Euclidean split of a sum into (limb, carry): [m mod beta] is the limb,
    [m / beta] the carry, and they reconstruct [m]. *)
Lemma split_limb : forall m, m mod beta + beta * (m / beta) = m.
Proof. intro m. pose proof (Z.div_mod m beta beta_neq). lia. Qed.

(** ** Addition — [eval] is additive *)

(** Add a single carry [c] into a limb list. *)
Fixpoint add_one (b : list Z) (c : Z) : list Z :=
  match b with
  | [] => if c =? 0 then [] else [c]
  | y :: b' => ((y + c) mod beta) :: add_one b' ((y + c) / beta)
  end.

Lemma eval_add_one : forall b c, eval (add_one b c) = eval b + c.
Proof.
  induction b as [| y b' IH]; intro c; simpl.
  - destruct (c =? 0) eqn:E; simpl.
    + apply Z.eqb_eq in E. lia.
    + lia.
  - rewrite IH, Z.mul_add_distr_l.
    pose proof (split_limb (y + c)). lia.
Qed.

(** Carry-propagating addition, structural on the first list. *)
Fixpoint add_c (a b : list Z) (c : Z) : list Z :=
  match a with
  | [] => add_one b c
  | x :: a' =>
      match b with
      | [] => add_one (x :: a') c
      | y :: b' => ((x + y + c) mod beta) :: add_c a' b' ((x + y + c) / beta)
      end
  end.

Lemma eval_add_c : forall a b c, eval (add_c a b c) = eval a + eval b + c.
Proof.
  induction a as [| x a' IH]; intros b c; simpl.
  - rewrite eval_add_one. lia.
  - destruct b as [| y b']; simpl.
    + rewrite eval_add_one. simpl. rewrite Z.mul_add_distr_l.
      pose proof (split_limb (x + c)). lia.
    + rewrite IH, Z.mul_add_distr_l.
      pose proof (split_limb (x + y + c)). lia.
Qed.

Definition add (a b : list Z) : list Z := add_c a b 0.

Lemma eval_add : forall a b, eval (add a b) = eval a + eval b.
Proof. intros a b. unfold add. rewrite eval_add_c. lia. Qed.

(** ** Multiplication — [eval] is multiplicative *)

(** Multiply a limb list [b] by a scalar [x], threading carry [c]. *)
Fixpoint scale_c (b : list Z) (x c : Z) : list Z :=
  match b with
  | [] => if c =? 0 then [] else [c]
  | y :: b' => ((x * y + c) mod beta) :: scale_c b' x ((x * y + c) / beta)
  end.

Lemma eval_scale_c : forall b x c, eval (scale_c b x c) = x * eval b + c.
Proof.
  induction b as [| y b' IH]; intros x c; simpl.
  - destruct (c =? 0) eqn:E; simpl.
    + apply Z.eqb_eq in E. lia.
    + lia.
  - rewrite IH.
    pose proof (split_limb (x * y + c)). ring_simplify. lia.
Qed.

Definition scale (x : Z) (b : list Z) : list Z := scale_c b x 0.

Lemma eval_scale : forall x b, eval (scale x b) = x * eval b.
Proof. intros x b. unfold scale. rewrite eval_scale_c. lia. Qed.

(** Schoolbook multiplication: [ (x :: a') * b = x*b + beta*(a' * b) ]. The
    [0 :: _] prepends a zero limb, i.e. multiplies by [beta]. *)
Fixpoint mul (a b : list Z) : list Z :=
  match a with
  | [] => []
  | x :: a' => add (scale x b) (0 :: mul a' b)
  end.

Lemma eval_mul : forall a b, eval (mul a b) = eval a * eval b.
Proof.
  induction a as [| x a' IH]; intro b; simpl.
  - reflexivity.
  - rewrite eval_add, eval_scale. cbn [eval]. rewrite IH. ring.
Qed.

(** ** Faithful base-[beta] decomposition (used to write KAT operands) *)

Fixpoint toLimbs (fuel : nat) (n : Z) : list Z :=
  match fuel with
  | O => []
  | S f => if n =? 0 then [] else (n mod beta) :: toLimbs f (n / beta)
  end.

(** With enough fuel, the decomposition of a non-negative [n] denotes [n]. *)
Lemma eval_toLimbs : forall fuel n,
  0 <= n < beta ^ Z.of_nat fuel -> eval (toLimbs fuel n) = n.
Proof.
  pose proof beta_pos as Hb.
  induction fuel as [| f IH]; intros n [Hlo Hhi].
  - (* fuel = 0: bound is [n < beta^0 = 1], so [n = 0]. *)
    change (Z.of_nat 0) with 0 in Hhi. rewrite Z.pow_0_r in Hhi.
    cbn [toLimbs eval]. lia.
  - cbn [toLimbs]. destruct (n =? 0) eqn:E.
    + apply Z.eqb_eq in E. subst. cbn [eval]. reflexivity.
    + apply Z.eqb_neq in E. cbn [eval]. rewrite IH.
      * pose proof (split_limb n). lia.
      * split.
        -- apply Z.div_pos; lia.
        -- apply Z.div_lt_upper_bound; [lia|].
           rewrite Nat2Z.inj_succ, Z.pow_succ_r in Hhi by apply Nat2Z.is_nonneg.
           exact Hhi.
Qed.

(** ** Division — truncated quotient/remainder, Euclidean characterisation *)

(** The model of [divmod_mag]: for non-negative magnitudes this is [Z] integer
    division. The Rust bit-serial long division is asserted to agree with it by
    the executable cross-check below. *)
Definition divmod (u v : Z) : Z * Z := (u / v, u mod v).

(** Any correct unsigned division satisfies [u = q*v + r] with [0 <= r < v];
    this is exactly what [divmod] returns. *)
Lemma divmod_correct : forall u v,
  0 <= u -> 0 < v ->
  let (q, r) := divmod u v in u = q * v + r /\ 0 <= r < v.
Proof.
  intros u v Hu Hv. unfold divmod. cbn [fst snd].
  pose proof (Z.div_mod u v ltac:(lia)).
  pose proof (Z.mod_pos_bound u v Hv). lia.
Qed.

(** The quotient/remainder pair is unique, so the Rust algorithm's output is
    pinned once it is shown (by the bridge) to satisfy the reconstruction. *)
Lemma divmod_unique : forall u v q r,
  0 < v -> 0 <= r < v -> u = q * v + r -> q = u / v /\ r = u mod v.
Proof.
  intros u v q r Hv Hr Heq.
  assert (q = u / v).
  { rewrite Heq. rewrite Z.div_add_l by lia.
    rewrite Z.div_small by lia. lia. }
  split; [assumption|].
  rewrite Heq. rewrite Z.add_comm. rewrite Z_mod_plus_full.
  symmetry. apply Z.mod_small. lia.
Qed.

(** ** Executable cross-check (Coq model <-> Rust <-> concrete vectors)

    Operands as limb vectors via [toLimbs]; the model's results, closed by
    [vm_compute], are asserted byte-identical to the Rust [add]/[mul]/[divmod]
    in [bigint::tests::test_bigint_matches_coq_model].

    A := 123456789012345678901234567890
    B := 987654321098765432109876543210               *)

Definition Ak : Z := 123456789012345678901234567890.
Definition Bk : Z := 987654321098765432109876543210.
Definition LA : list Z := toLimbs 8 Ak.
Definition LB : list Z := toLimbs 8 Bk.

(** The limb decompositions are faithful. *)
Example eval_LA : eval LA = Ak. Proof. vm_compute. reflexivity. Qed.
Example eval_LB : eval LB = Bk. Proof. vm_compute. reflexivity. Qed.

(** The model computes the true sum and product (model <-> [Z] arithmetic). *)
Example add_kat : eval (add LA LB) = Ak + Bk. Proof. vm_compute. reflexivity. Qed.
Example mul_kat : eval (mul LA LB) = Ak * Bk. Proof. vm_compute. reflexivity. Qed.

(** Concrete products/quotients, pinned for the Rust bridge (decimal values the
    parity test reproduces with the running [bigint.rs]). *)
Example sum_value : eval (add LA LB) = 1111111110111111111011111111100.
Proof. vm_compute. reflexivity. Qed.

Example product_value :
  eval (mul LA LB) = 121932631137021795226185032733622923332237463801111263526900.
Proof. vm_compute. reflexivity. Qed.

(** Truncated division: B = q*A + r with 0 <= r < A. *)
Example divmod_BA : divmod Bk Ak = (8, 9000000000900000000090).
Proof. vm_compute. reflexivity. Qed.

Example divmod_BA_reconstructs : let (q, r) := divmod Bk Ak in Bk = q * Ak + r.
Proof. vm_compute. reflexivity. Qed.
