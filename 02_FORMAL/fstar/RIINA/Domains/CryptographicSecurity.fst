(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
module RIINA.Domains.CryptographicSecurity

open FStar.All

type crypto_policy = {
  key_bits: nat;
  tag_bits: nat;
  unique_nonce: bool;
  forward_secrecy: bool;
}

let valid_crypto_policy (p: crypto_policy) : Tot bool =
  p.key_bits >= 256
  && p.tag_bits >= 128
  && p.unique_nonce

let baseline_crypto_policy : crypto_policy = {
  key_bits = 256;
  tag_bits = 128;
  unique_nonce = true;
  forward_secrecy = true;
}

let hardened_crypto_policy : crypto_policy = {
  key_bits = 384;
  tag_bits = 192;
  unique_nonce = true;
  forward_secrecy = true;
}

let baseline_crypto_policy_valid () : Lemma
  (ensures (valid_crypto_policy baseline_crypto_policy)) =
  ()

let hardened_crypto_policy_valid () : Lemma
  (ensures (valid_crypto_policy hardened_crypto_policy)) =
  ()

let hardened_key_not_weaker () : Lemma
  (ensures (hardened_crypto_policy.key_bits >= baseline_crypto_policy.key_bits)) =
  ()
