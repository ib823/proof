(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Crypto — ML-KEM (Kyber) NTT, Formal Equivalence

    A mechanized model of the number-theoretic transform in
    [05_TOOLING/crates/riina-core/src/crypto/ml_kem.rs] — the arithmetic core of
    ML-KEM-768 (FIPS 203). It is faithful down to the *exact integer semantics*:
    signed 16-bit two's-complement wrapping ([wrap16]), Montgomery reduction
    ([montgomery_reduce], R = 2^16, q = 3329, q^{-1} = -3327), Barrett reduction,
    the 128-entry [ZETAS] table (bit-reversed, Montgomery form), the
    Cooley-Tukey forward butterflies ([ntt]), the Gentleman-Sande inverse
    butterflies + the F = 1441 scaling ([inv_ntt]), and the degree-1 basemul
    ([pointwise_mul]).

    Headline theorem (`ntt_mul_*`): the way ML-KEM actually uses the NTT —
    [ntt a], [ntt b], pointwise-multiply, [inv_ntt], [reduce] — computes the
    polynomial product [a*b] in [Z_q[X]/(X^256+1)]. This is exactly the property
    the Rust [test_ntt_multiply_roundtrip] checks, here proved by [vm_compute] on
    concrete polynomials (including a non-trivial convolution), byte-faithful to
    the implementation's integer arithmetic.

    Representation: a polynomial is a [list Z] of 256 coefficients (each a signed
    16-bit value), index = coefficient degree, matching [Poly::coeffs]. The Rust
    butterflies are in-place over [[i16; 256]]; we model each layer as a
    block-structured list transform (split into [2*len] blocks, butterfly each).

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. Concrete finite computation,
    closed by [vm_compute]. Rust bridge:
    [crypto::ml_kem::tests::test_ntt_matches_coq_model]. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import List.
Import ListNotations.
Open Scope Z_scope.

(** ** Exact i16 / Montgomery / Barrett arithmetic (faithful to ml_kem.rs) *)

Definition Q : Z := 3329.

(** Truncate a [Z] to a signed 16-bit value (Rust [as i16] / wrapping ops). *)
Definition wrap16 (x : Z) : Z := Z.modulo (x + 32768) 65536 - 32768.
Definition add16 (a b : Z) : Z := wrap16 (a + b).
Definition sub16 (a b : Z) : Z := wrap16 (a - b).

(** [montgomery_reduce a]: given [a] (an i32 product), return [a * R^{-1} mod q]
    as i16. t = (a as i16) *_{i16} (-3327); u = (a - t*q) >> 16 (arith. shift). *)
Definition montgomery_reduce (a : Z) : Z :=
  let t := wrap16 (wrap16 a * (-3327)) in
  wrap16 (Z.div (a - t * Q) 65536).

(** Multiply two i16 in Montgomery form (product is exact i32 before reduce). *)
Definition fqmul (a b : Z) : Z := montgomery_reduce (a * b).

(** Barrett reduction (BARRETT_V = 20159, 1<<25, 1<<26), all i16-wrapping. *)
Definition barrett_reduce (a : Z) : Z :=
  let t := wrap16 (Z.div (20159 * a + 33554432) 67108864) in
  wrap16 (a - wrap16 (t * Q)).

(** Conditional subtract q (Rust [cond_sub_q], branchless mask). *)
Definition cond_sub_q (a : Z) : Z := if Z.leb Q a then a - Q else a.

(** Positive representative in [0,q) (Rust [to_positive]: i16 [%], then +q if <0). *)
Definition to_positive (a : Z) : Z :=
  let r := Z.rem a Q in if Z.ltb r 0 then r + Q else r.

(** ML-KEM's bit-reversed Montgomery zeta table (128 entries, verbatim). *)
Definition ZETAS : list Z :=
  [ -1044; -758; -359; -1517; 1493; 1422; 287; 202; -171; 622; 1577; 182; 962; -1202; -1474; 1468;
    573; -1325; 264; 383; -829; 1458; -1602; -130; -681; 1017; 732; 608; -1542; 411; -205; -1571;
    1223; 652; -552; 1015; -1293; 1491; -282; -1544; 516; -8; -320; -666; -1618; -1162; 126; 1469;
    -853; -90; -271; 830; 107; -1421; -247; -951; -398; 961; -1508; -725; 448; -1065; 677; -1275;
    -1103; 430; 555; 843; -1251; 871; 1550; 105; 422; 587; 177; -235; -291; -460; 1574; 1653; -246;
    778; 1159; -147; -777; 1483; -602; 1119; -1590; 644; -872; 349; 418; 329; -156; -75; 817; 1097;
    603; 610; 1322; -1285; -1465; 384; -1215; -136; 1218; -1335; -874; 220; -1187; -1659; -1185;
    -1530; -1278; 794; -1510; -854; -870; 478; -108; -308; 996; 991; 958; -1460; 1522; 1628 ]%Z.
Definition zeta (k : nat) : Z := nth k ZETAS 0.

(** ** Forward NTT (Cooley-Tukey) *)

Fixpoint map2 (f : Z -> Z -> Z) (xs ys : list Z) : list Z :=
  match xs, ys with
  | x :: xs', y :: ys' => f x y :: map2 f xs' ys'
  | _, _ => []
  end.

(** One forward butterfly block of width [2*len]: low' = low + t, high' = low - t,
    where t = fqmul zeta high (Rust ntt inner loop). *)
Definition ct_block (len : nat) (z : Z) (block : list Z) : list Z :=
  let lows := firstn len block in
  let highs := skipn len block in
  let ts := map (fun h => fqmul z h) highs in
  map2 add16 lows ts ++ map2 sub16 lows ts.

(** One layer: [nblocks] consecutive blocks of width [2*len], zeta index [k++]. *)
Fixpoint ct_layer (nblocks len k : nat) (poly : list Z) : list Z :=
  match nblocks with
  | O => poly
  | S nb => ct_block len (zeta k) (firstn (2 * len) poly)
            ++ ct_layer nb len (S k) (skipn (2 * len) poly)
  end.

(** len = 128,64,...,2 (7 layers); k starts at 128/len and runs 1..127 total. *)
Definition ntt (poly : list Z) : list Z :=
  let p := ct_layer 1 128 1 poly in
  let p := ct_layer 2 64 2 p in
  let p := ct_layer 4 32 4 p in
  let p := ct_layer 8 16 8 p in
  let p := ct_layer 16 8 16 p in
  let p := ct_layer 32 4 32 p in
  ct_layer 64 2 64 p.

(** ** Inverse NTT (Gentleman-Sande) + F scaling *)

(** One inverse butterfly block: low' = barrett(low + high),
    high' = fqmul zeta (high - low) (Rust inv_ntt inner loop). *)
Definition gs_block (len : nat) (z : Z) (block : list Z) : list Z :=
  let lows := firstn len block in
  let highs := skipn len block in
  map2 (fun l h => barrett_reduce (add16 l h)) lows highs
  ++ map2 (fun l h => fqmul z (sub16 h l)) lows highs.

(** Inverse layer: zeta index [k--] per block (Rust uses [k = k.wrapping_sub(1)]). *)
Fixpoint gs_layer (nblocks len k : nat) (poly : list Z) : list Z :=
  match nblocks with
  | O => poly
  | S nb => gs_block len (zeta k) (firstn (2 * len) poly)
            ++ gs_layer nb len (Nat.pred k) (skipn (2 * len) poly)
  end.

Definition F : Z := 1441.
Definition inv_ntt (poly : list Z) : list Z :=
  let p := gs_layer 64 2 127 poly in
  let p := gs_layer 32 4 63 p in
  let p := gs_layer 16 8 31 p in
  let p := gs_layer 8 16 15 p in
  let p := gs_layer 4 32 7 p in
  let p := gs_layer 2 64 3 p in
  let p := gs_layer 1 128 1 p in
  map (fun c => fqmul c F) p.

(** ** Basemul (pointwise multiply in NTT domain, Rust [pointwise_mul]) *)

(** Process 4 coefficients per group k (0..63): pairs (4k,4k+1) use ZETAS[64+k],
    pairs (4k+2,4k+3) use -ZETAS[64+k], each a degree-1 mult mod (X^2 - zeta). *)
Fixpoint pmul (ngroups k : nat) (a b : list Z) : list Z :=
  match ngroups with
  | O => []
  | S n =>
      match a, b with
      | a0 :: a1 :: a2 :: a3 :: a', b0 :: b1 :: b2 :: b3 :: b' =>
          let z := zeta (64 + k) in
          let nz := wrap16 (0 - z) in
          add16 (fqmul a0 b0) (fqmul (fqmul a1 b1) z)
          :: add16 (fqmul a0 b1) (fqmul a1 b0)
          :: add16 (fqmul a2 b2) (fqmul (fqmul a3 b3) nz)
          :: add16 (fqmul a2 b3) (fqmul a3 b2)
          :: pmul n (S k) a' b'
      | _, _ => []
      end
  end.
Definition pointwise_mul (a b : list Z) : list Z := pmul 64 0 a b.

(** ** The full ML-KEM multiply, and its correctness *)

(** [reduce] (barrett + cond_sub) then [to_positive], as the Rust test reads it. *)
Definition finalize (x : Z) : Z := to_positive (cond_sub_q (barrett_reduce x)).
Definition kyber_mul (a b : list Z) : list Z :=
  map finalize (inv_ntt (pointwise_mul (ntt a) (ntt b))).

(** A degree-0 polynomial [1] times [1] is [1] (Rust [test_ntt_multiply_roundtrip]). *)
Definition poly_one : list Z := 1 :: repeat 0 255.
Theorem ntt_mul_one :
  kyber_mul poly_one poly_one = 1 :: repeat 0 255.
Proof. vm_compute. reflexivity. Qed.

(** A genuine convolution: (1 + X)·(1 + X) = 1 + 2X + X^2 in Z_q[X]/(X^256+1). *)
Definition poly_1plusX : list Z := 1 :: 1 :: repeat 0 254.
Theorem ntt_mul_1plusX_squared :
  kyber_mul poly_1plusX poly_1plusX = 1 :: 2 :: 1 :: repeat 0 253.
Proof. vm_compute. reflexivity. Qed.

(** The wrap-around term X^255 · X = X^256 = -1 (negacyclic): (X^255)·(X) folds
    to q-1 at degree 0. This exercises the negacyclic reduction the NTT encodes. *)
Definition poly_Xn (n : nat) : list Z := repeat 0 n ++ [1] ++ repeat 0 (255 - n).
Theorem ntt_mul_negacyclic_wrap :
  kyber_mul (poly_Xn 255) (poly_Xn 1) = (Q - 1) :: repeat 0 255.
Proof. vm_compute. reflexivity. Qed.
