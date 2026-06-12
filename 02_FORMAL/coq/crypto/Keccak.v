(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Crypto — Keccak-f[1600] / SHA3-256, Formal Equivalence

    A mechanized model of the Keccak-f[1600] permutation and the SHA3-256 sponge
    (FIPS 202), faithful to [05_TOOLING/crates/riina-core/src/crypto/keccak.rs],
    executed by [vm_compute] against the FIPS 202 KAT digests and cross-checked,
    byte-identical, against the Rust ([crypto::keccak::tests::*]).

    Faithfulness map (the state is 25 little-endian 64-bit lanes, lane [x+5y]):

      Rust                                   Coq
      ----                                   ---
      theta / rho / pi / chi / iota          theta / rho / pikeccak / chi / iotastep
      ROTATION_OFFSETS / PI_LANE / RC         ROT / PILANE / RC  (transcribed verbatim)
      24-round permute                        permute (fold over RC)
      xor_bytes (le lanes), sha3 pad 0x06..0x80, extract 32 bytes
                                              sha3_256 (lanes_of_bytes / bytes_of_lane)

    Mode: Zero Trust — 0 Admitted, 0 Axiom, 0 Abort. SHA-3 is a hash, so the
    content is executable model<->spec<->implementation agreement on the FIPS 202
    known-answer vectors (single rate-block messages), not deep algebra. *)

From Stdlib Require Import ZArith.ZArith.
From Stdlib Require Import List.
Import ListNotations.
Open Scope Z_scope.

(** ** 64-bit lane operations *)

Definition m64 (x : Z) : Z := Z.land x 0xffffffffffffffff.
Definition rotl64 (x n : Z) : Z := m64 (Z.lor (Z.shiftl x n) (Z.shiftr x (64 - n))).
Definition not64 (x : Z) : Z := Z.lxor x 0xffffffffffffffff.

(** ** Constants (transcribed verbatim from keccak.rs) *)

Definition RC : list Z :=
  [ 0x0000000000000001;0x0000000000008082;0x800000000000808a;0x8000000080008000;0x000000000000808b
  ; 0x0000000080000001;0x8000000080008081;0x8000000000008009;0x000000000000008a;0x0000000000000088
  ; 0x0000000080008009;0x000000008000000a;0x000000008000808b;0x800000000000008b;0x8000000000008089
  ; 0x8000000000008003;0x8000000000008002;0x8000000000000080;0x000000000000800a;0x800000008000000a
  ; 0x8000000080008081;0x8000000000008080;0x0000000080000001;0x8000000080008008 ].
Definition ROT : list nat := [0;1;62;28;27;36;44;6;55;20;3;10;43;25;39;41;45;15;21;8;18;2;61;56;14]%nat.
Definition PILANE : list nat := [0;6;12;18;24;3;9;10;16;22;1;7;13;19;20;4;5;11;17;23;2;8;14;15;21]%nat.

(** ** The five Keccak-f step mappings (FIPS 202 §3.2) *)

(** theta: column-parity diffusion. *)
Definition theta (s : list Z) : list Z :=
  let C := fun x:nat => Z.lxor (Z.lxor (Z.lxor (Z.lxor (nth x s 0) (nth (x+5)%nat s 0))
                                               (nth (x+10)%nat s 0)) (nth (x+15)%nat s 0))
                               (nth (x+20)%nat s 0) in
  let D := fun x:nat => Z.lxor (C ((x+4) mod 5)%nat) (rotl64 (C ((x+1) mod 5)%nat) 1) in
  map (fun i:nat => Z.lxor (nth i s 0) (D ((i mod 5)%nat))) (seq 0 25).

(** rho: per-lane bit rotation. *)
Definition rho (s : list Z) : list Z :=
  map (fun i:nat => rotl64 (nth i s 0) (Z.of_nat (nth i ROT 0%nat))) (seq 0 25).

(** pi: lane permutation. *)
Definition pikeccak (s : list Z) : list Z :=
  map (fun i:nat => nth (nth i PILANE 0%nat) s 0) (seq 0 25).

(** chi: the only non-linear step (per row). *)
Definition chi (s : list Z) : list Z :=
  map (fun i:nat => let x := (i mod 5)%nat in let y := (i / 5)%nat in
        Z.lxor (nth i s 0)
               (Z.land (not64 (nth (5*y + (x+1) mod 5)%nat s 0)) (nth (5*y + (x+2) mod 5)%nat s 0)))
      (seq 0 25).

(** iota: round constant into lane 0. *)
Definition iotastep (rc : Z) (s : list Z) : list Z :=
  map (fun i:nat => if Nat.eqb i 0 then Z.lxor (nth 0 s 0) rc else nth i s 0) (seq 0 25).

Definition kround (s : list Z) (rc : Z) : list Z := iotastep rc (chi (pikeccak (rho (theta s)))).

(** Keccak-f[1600]: 24 rounds. *)
Definition permute (s : list Z) : list Z := fold_left kround RC s.

(** ** SHA3-256 sponge (single rate block; |msg| < 135 bytes) *)

Fixpoint lanes_of_bytes (bs : list Z) : list Z :=
  match bs with
  | b0::b1::b2::b3::b4::b5::b6::b7::r =>
      (b0 + b1*2^8 + b2*2^16 + b3*2^24 + b4*2^32 + b5*2^40 + b6*2^48 + b7*2^56)
      :: lanes_of_bytes r
  | _ => []
  end.
Fixpoint bytes_of_lane (k : nat) (l : Z) : list Z :=
  match k with O => [] | S j => (l mod 256) :: bytes_of_lane j (Z.shiftr l 8) end.

(** SHA3-256: pad (0x06 .. 0x80) to the 136-byte rate block, absorb, permute,
    squeeze the first 32 bytes (4 lanes, little-endian). *)
Definition sha3_256 (msg : list Z) : list Z :=
  let block := msg ++ [0x06] ++ repeat 0 (134 - length msg) ++ [0x80] in
  flat_map (bytes_of_lane 8) (firstn 4 (permute (lanes_of_bytes block ++ repeat 0 8))).

(** ** FIPS 202 known-answer tests (closed by [vm_compute]) *)

(** SHA3-256("") = a7ffc6f8 bf1ed766 51c14756 a061d662 f580ff4d e43b49fa 82d80a4b 80f8434a *)
Example sha3_256_empty :
  sha3_256 [] =
  [ 0xa7;0xff;0xc6;0xf8;0xbf;0x1e;0xd7;0x66;0x51;0xc1;0x47;0x56;0xa0;0x61;0xd6;0x62
  ; 0xf5;0x80;0xff;0x4d;0xe4;0x3b;0x49;0xfa;0x82;0xd8;0x0a;0x4b;0x80;0xf8;0x43;0x4a ].
Proof. vm_compute. reflexivity. Qed.

(** SHA3-256("abc") = 3a985da7 4fe225b2 045c172d 6bd390bd 855f086e 3e9d525b 46bfe245 11431532 *)
Example sha3_256_abc :
  sha3_256 [0x61; 0x62; 0x63] =
  [ 0x3a;0x98;0x5d;0xa7;0x4f;0xe2;0x25;0xb2;0x04;0x5c;0x17;0x2d;0x6b;0xd3;0x90;0xbd
  ; 0x85;0x5f;0x08;0x6e;0x3e;0x9d;0x52;0x5b;0x46;0xbf;0xe2;0x45;0x11;0x43;0x15;0x32 ].
Proof. vm_compute. reflexivity. Qed.
