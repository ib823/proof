(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Crypto — SHA-256, Formal Equivalence (executable model)

    A mechanized model of SHA-256 (FIPS 180-4), faithful to
    [05_TOOLING/crates/riina-core/src/crypto/sha2.rs], executed by [vm_compute]
    against the standard FIPS test vectors and cross-checked, byte-identical,
    against the Rust implementation
    ([crypto::sha2::tests::test_sha256_matches_coq_model]).

    Faithfulness map (32-bit words as [Z] in [[0, 2^32)]):

      Rust                                   Coq
      ----                                   ---
      a.wrapping_add(b)                      add32 a b
      x.rotate_right(n)                      rotr x n
      x >> n                                 shr x n
      ch / maj / Σ0 / Σ1 / σ0 / σ1           ch / maj / bsig0 / bsig1 / sig0 / sig1
      message schedule w[16..64]             schedule (extend)
      64-round compression + feed-forward    sha256_block
      pad: 0x80, zeros, be64(bitlen)         pad_msg

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. The KATs are concrete
    [vm_compute] checks (single-block messages); SHA-256 is a hash, so the
    content is the executable model<->spec<->implementation agreement, not deep
    algebra. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import List.
Import ListNotations.
Open Scope Z_scope.

(** ** 32-bit word operations *)

Definition m32 (x : Z) : Z := Z.land x 0xffffffff.
Definition add32 (a b : Z) : Z := m32 (a + b).
Definition rotr (x n : Z) : Z := m32 (Z.lor (Z.shiftr x n) (Z.shiftl x (32 - n))).
Definition shr (x n : Z) : Z := Z.shiftr x n.
Definition compl (x : Z) : Z := Z.lxor x 0xffffffff.   (* 32-bit bitwise NOT *)

(** ** Round functions (FIPS 180-4 §4.1.2) *)

Definition ch    (x y z : Z) : Z := Z.lxor (Z.land x y) (Z.land (compl x) z).
Definition maj   (x y z : Z) : Z := Z.lxor (Z.lxor (Z.land x y) (Z.land x z)) (Z.land y z).
Definition bsig0 (x : Z) : Z := Z.lxor (Z.lxor (rotr x 2)  (rotr x 13)) (rotr x 22).
Definition bsig1 (x : Z) : Z := Z.lxor (Z.lxor (rotr x 6)  (rotr x 11)) (rotr x 25).
Definition sig0  (x : Z) : Z := Z.lxor (Z.lxor (rotr x 7)  (rotr x 18)) (shr x 3).
Definition sig1  (x : Z) : Z := Z.lxor (Z.lxor (rotr x 17) (rotr x 19)) (shr x 10).

(** ** Constants (H0, K) *)

Definition K : list Z :=
  [ 0x428a2f98;0x71374491;0xb5c0fbcf;0xe9b5dba5;0x3956c25b;0x59f111f1;0x923f82a4;0xab1c5ed5
  ; 0xd807aa98;0x12835b01;0x243185be;0x550c7dc3;0x72be5d74;0x80deb1fe;0x9bdc06a7;0xc19bf174
  ; 0xe49b69c1;0xefbe4786;0x0fc19dc6;0x240ca1cc;0x2de92c6f;0x4a7484aa;0x5cb0a9dc;0x76f988da
  ; 0x983e5152;0xa831c66d;0xb00327c8;0xbf597fc7;0xc6e00bf3;0xd5a79147;0x06ca6351;0x14292967
  ; 0x27b70a85;0x2e1b2138;0x4d2c6dfc;0x53380d13;0x650a7354;0x766a0abb;0x81c2c92e;0x92722c85
  ; 0xa2bfe8a1;0xa81a664b;0xc24b8b70;0xc76c51a3;0xd192e819;0xd6990624;0xf40e3585;0x106aa070
  ; 0x19a4c116;0x1e376c08;0x2748774c;0x34b0bcb5;0x391c0cb3;0x4ed8aa4a;0x5b9cca4f;0x682e6ff3
  ; 0x748f82ee;0x78a5636f;0x84c87814;0x8cc70208;0x90befffa;0xa4506ceb;0xbef9a3f7;0xc67178f2 ].

Definition St := (Z*Z*Z*Z*Z*Z*Z*Z)%type.
Definition H0 : St :=
  (0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19).

(** ** Message schedule and compression (faithful to [compress_block]) *)

Fixpoint extend (n : nat) (w : list Z) : list Z :=
  match n with
  | O => w
  | S k =>
      let i := length w in
      let nw := add32 (add32 (nth (i-16) w 0) (sig0 (nth (i-15) w 0)))
                      (add32 (nth (i-7) w 0) (sig1 (nth (i-2) w 0))) in
      extend k (w ++ [nw])
  end.
Definition schedule (w0 : list Z) : list Z := extend 48 w0.   (* 16 -> 64 words *)

Definition do_round (s : St) (kw : Z*Z) : St :=
  let '(a,b,c,d,e,f,g,h) := s in let '(ki,wi) := kw in
  let t1 := add32 (add32 (add32 (add32 h (bsig1 e)) (ch e f g)) ki) wi in
  let t2 := add32 (bsig0 a) (maj a b c) in
  (add32 t1 t2, a, b, c, add32 d t1, e, f, g).

Definition add_st (x y : St) : St :=
  let '(a,b,c,d,e,f,g,h) := x in let '(a',b',c',d',e',f',g',h') := y in
  (add32 a a', add32 b b', add32 c c', add32 d d', add32 e e', add32 f f', add32 g g', add32 h h').

(** One compressed block: 64 rounds from [s0], then the Davies-Meyer feed-forward. *)
Definition sha256_block (s0 : St) (blk16 : list Z) : St :=
  add_st s0 (fold_left do_round (combine K (schedule blk16)) s0).

(** ** Padding + byte/word packing (single-block messages, |msg| <= 55) *)

Definition be8 (n : Z) : list Z :=
  [ Z.land (Z.shiftr n 56) 255; Z.land (Z.shiftr n 48) 255
  ; Z.land (Z.shiftr n 40) 255; Z.land (Z.shiftr n 32) 255
  ; Z.land (Z.shiftr n 24) 255; Z.land (Z.shiftr n 16) 255
  ; Z.land (Z.shiftr n 8)  255; Z.land n 255 ].

Definition pad_msg (msg : list Z) : list Z :=
  msg ++ [0x80] ++ repeat 0 (55 - length msg) ++ be8 (8 * Z.of_nat (length msg)).

Fixpoint words_of_bytes (bs : list Z) : list Z :=
  match bs with
  | b0 :: b1 :: b2 :: b3 :: r =>
      Z.lor (Z.lor (Z.lor (Z.shiftl b0 24) (Z.shiftl b1 16)) (Z.shiftl b2 8)) b3
      :: words_of_bytes r
  | _ => []
  end.

(** Full single-block SHA-256 of a byte message (|msg| <= 55). *)
Definition sha256 (msg : list Z) : St := sha256_block H0 (words_of_bytes (pad_msg msg)).

(** ** FIPS 180-4 known-answer tests (closed by [vm_compute]) *)

(** SHA-256("abc") = ba7816bf 8f01cfea 414140de 5dae2223 b00361a3 96177a9c b410ff61 f20015ad *)
Example sha256_abc :
  sha256 [0x61; 0x62; 0x63]
  = (0xba7816bf,0x8f01cfea,0x414140de,0x5dae2223,0xb00361a3,0x96177a9c,0xb410ff61,0xf20015ad).
Proof. vm_compute. reflexivity. Qed.

(** SHA-256("") = e3b0c442 98fc1c14 9afbf4c8 996fb924 27ae41e4 649b934c a495991b 7852b855 *)
Example sha256_empty :
  sha256 []
  = (0xe3b0c442,0x98fc1c14,0x9afbf4c8,0x996fb924,0x27ae41e4,0x649b934c,0xa495991b,0x7852b855).
Proof. vm_compute. reflexivity. Qed.
