(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Manually maintained active F* obligations for D8 crypto-closure lane. *)
module RIINA.Active.CryptographicSecurityActive

open FStar.UInt8
open FStar.List.Tot

let ct_eq_u8 (x:t) (y:t) : Tot bool =
  if x = y then true else false

let lemma_ct_eq_reflexive (x:t)
  : Lemma (ensures (ct_eq_u8 x x = true))
  = ()

let lemma_ct_eq_symmetric (x:t) (y:t)
  : Lemma (ensures (ct_eq_u8 x y = ct_eq_u8 y x))
  = ()

let rec zeroize (n:nat) : Tot (list t) (decreases n) =
  if n = 0 then
    []
  else
    0uy :: zeroize (n - 1)

let rec lemma_zeroize_length (n:nat)
  : Lemma (ensures (length (zeroize n) = n)) (decreases n)
  = if n = 0 then () else lemma_zeroize_length (n - 1)
