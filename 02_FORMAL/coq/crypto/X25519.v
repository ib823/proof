(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Crypto — X25519 Montgomery ladder, Formal Equivalence

    A mechanized model of the X25519 scalar multiplication in
    [05_TOOLING/crates/riina-core/src/crypto/montgomery.rs] — the Montgomery
    ladder (xDBL + xADD + conditional swap) over Curve25519, the field being
    GF(p), p = 2^255 - 19 (the field whose multiply [crypto/Field25519.v] proves
    correct mod p). This is the scalar-multiplication heart of X25519 ECDH.

    Faithfulness: the ladder formulas are transcribed exactly from the Rust
    [MontgomeryPoint::double]/[diff_add]/[scalar_mul]:

      double(X:Z):    A=X+Z; B=X-Z; AA=A^2; BB=B^2; C=AA-BB;
                      X'=AA*BB; Z'=C*(BB + 121666*C)
      diff_add(P,Q,u): A=Xp+Zp; B=Xp-Zp; C=Xq+Zq; D=Xq-Zq; DA=D*A; CB=C*B;
                      X'=(DA+CB)^2; Z'=u*(DA-CB)^2
      ladder:         r0=(1:0), r1=(u:1); for i=254..0: cswap(bit); r0,r1 =
                      double(r0), diff_add(r0,r1,u); cswap(bit); return r0
      clamp:          k[0]&=0xF8; k[31]&=127; k[31]|=64
      decode u:       little-endian, mask bit 255, reduce mod p
      output:         x0 * z0^(p-2) mod p, 32-byte little-endian

    Here field elements are plain residues in [0,p) (the Rust uses radix-2^51
    limbs whose multiply Field25519.v proves equals this mod p). The theorems
    prove by [vm_compute] that the modelled X25519 reproduces the **RFC 7748**
    §5.2 and §6.1 test vectors byte-for-byte — exactly what the Rust
    [test_rfc7748_vector1]/[test_rfc7748_basepoint_section6] check.

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. Rust bridge:
    [crypto::montgomery::tests::test_x25519_matches_coq_model]. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import List.
Import ListNotations.
Open Scope Z_scope.

(** ** Field GF(2^255-19) as residues in [0,p) *)

Definition p : Z := 2 ^ 255 - 19.
Definition addp (a b : Z) : Z := Z.modulo (a + b) p.
Definition subp (a b : Z) : Z := Z.modulo (a - b) p.
Definition mulp (a b : Z) : Z := Z.modulo (a * b) p.
Definition sqrp (a : Z) : Z := mulp a a.
Definition a24 : Z := 121666.   (* (486662 + 2) / 4 *)

(** Modular exponentiation (square-and-multiply), enough fuel for a 255-bit e. *)
Fixpoint powmod (fuel : nat) (base e : Z) : Z :=
  match fuel with
  | O => 1
  | S f => let h := powmod f (mulp base base) (Z.div e 2) in
           if Z.odd e then mulp base h else h
  end.
Definition inv (z : Z) : Z := powmod 256 z (p - 2).   (* Fermat: z^(p-2) = z^{-1} *)

(** ** One ladder step (cswap; xDBL on r0; xADD r0,r1; cswap back) *)

Definition ladder_step (b : bool) (bu : Z) (st : Z * Z * Z * Z) : Z * Z * Z * Z :=
  let '(x0, z0, x1, z1) := st in
  let '(x0, z0, x1, z1) := if b then (x1, z1, x0, z0) else (x0, z0, x1, z1) in
  (* double r0 = (x0:z0) *)
  let A := addp x0 z0 in
  let B := subp x0 z0 in
  let AA := sqrp A in
  let BB := sqrp B in
  let C := subp AA BB in
  let nx0 := mulp AA BB in
  let nz0 := mulp C (addp BB (mulp a24 C)) in
  (* diff_add: self=r0=(x0:z0), q=r1=(x1:z1), diff=bu *)
  let D := addp x1 z1 in
  let E := subp x1 z1 in
  let DA := mulp E A in
  let CB := mulp D B in
  let nx1 := sqrp (addp DA CB) in
  let nz1 := mulp bu (sqrp (subp DA CB)) in
  if b then (nx1, nz1, nx0, nz0) else (nx0, nz0, nx1, nz1).

(** Process scalar bits from [n-1] down to [0]. *)
Fixpoint ladder (n : nat) (k bu : Z) (st : Z * Z * Z * Z) : Z * Z * Z * Z :=
  match n with
  | O => st
  | S i => ladder i k bu (ladder_step (Z.testbit k (Z.of_nat i)) bu st)
  end.

(** ** Byte (de)coding and clamping (little-endian, RFC 7748 §5) *)

Fixpoint le_decode (bs : list Z) : Z :=
  match bs with
  | [] => 0
  | b :: t => b + 256 * le_decode t
  end.
Fixpoint le_encode (n : nat) (v : Z) : list Z :=
  match n with
  | O => []
  | S k => Z.modulo v 256 :: le_encode k (Z.div v 256)
  end.

(** Clamp at the integer level: clear bits 0,1,2 (k[0]&=0xF8), clear bit 255
    (k[31]&=127), set bit 254 (k[31]|=64). *)
Definition clamp (k : Z) : Z :=
  Z.lor (Z.land (Z.land k (Z.lnot 7)) (Z.lnot (2 ^ 255))) (2 ^ 254).
Definition decode_scalar (bs : list Z) : Z := clamp (le_decode bs).
Definition decode_u (bs : list Z) : Z := Z.modulo (Z.modulo (le_decode bs) (2 ^ 255)) p.

(** The X25519 function: scalar (32 bytes) * u-coordinate (32 bytes) -> 32 bytes. *)
Definition x25519 (scalar u_bytes : list Z) : list Z :=
  let k := decode_scalar scalar in
  let u := decode_u u_bytes in
  let '(x0, z0, _, _) := ladder 255 k u (1, 0, u, 1) in
  le_encode 32 (mulp x0 (inv z0)).

(** ** RFC 7748 test vectors *)

(** §5.2 Test Vector 1. *)
Definition rfc_scalar1 : list Z :=
  [ 0xa5;0x46;0xe3;0x6b;0xf0;0x52;0x7c;0x9d;0x3b;0x16;0x15;0x4b;0x82;0x46;0x5e;0xdd;
    0x62;0x14;0x4c;0x0a;0xc1;0xfc;0x5a;0x18;0x50;0x6a;0x22;0x44;0xba;0x44;0x9a;0xc4 ].
Definition rfc_u1 : list Z :=
  [ 0xe6;0xdb;0x68;0x67;0x58;0x30;0x30;0xdb;0x35;0x94;0xc1;0xa4;0x24;0xb1;0x5f;0x7c;
    0x72;0x66;0x24;0xec;0x26;0xb3;0x35;0x3b;0x10;0xa9;0x03;0xa6;0xd0;0xab;0x1c;0x4c ].
Definition rfc_expected1 : list Z :=
  [ 0xc3;0xda;0x55;0x37;0x9d;0xe9;0xc6;0x90;0x8e;0x94;0xea;0x4d;0xf2;0x8d;0x08;0x4f;
    0x32;0xec;0xcf;0x03;0x49;0x1c;0x71;0xf7;0x54;0xb4;0x07;0x55;0x77;0xa2;0x85;0x52 ].

Theorem x25519_rfc7748_vector1 :
  x25519 rfc_scalar1 rfc_u1 = rfc_expected1.
Proof. vm_compute. reflexivity. Qed.

(** §6.1 Alice's public key: X25519(a, 9). *)
Definition rfc_a : list Z :=
  [ 0x77;0x07;0x6d;0x0a;0x73;0x18;0xa5;0x7d;0x3c;0x16;0xc1;0x72;0x51;0xb2;0x66;0x45;
    0xdf;0x4c;0x2f;0x87;0xeb;0xc0;0x99;0x2a;0xb1;0x77;0xfb;0xa5;0x1d;0xb9;0x2c;0x2a ].
Definition u_nine : list Z := 9 :: repeat 0 31.
Definition rfc_ka : list Z :=
  [ 0x85;0x20;0xf0;0x09;0x89;0x30;0xa7;0x54;0x74;0x8b;0x7d;0xdc;0xb4;0x3e;0xf7;0x5a;
    0x0d;0xbf;0x3a;0x0d;0x26;0x38;0x1a;0xf4;0xeb;0xa4;0xa9;0x8e;0xaa;0x9b;0x4e;0x6a ].

Theorem x25519_rfc7748_basepoint :
  x25519 rfc_a u_nine = rfc_ka.
Proof. vm_compute. reflexivity. Qed.
