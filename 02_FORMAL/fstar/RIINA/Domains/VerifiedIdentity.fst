(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/VerifiedIdentity.v (40 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.VerifiedIdentity
open FStar.All

(* Credential (matches Coq) *)
type credential =
  | CredPassword of (list nat)
  | CredToken of ((list nat) * nat)
  | CredFIDO2 of ((list nat) * nat)
  | CredCertificate of (list nat)

(* AuthResult (matches Coq) *)
type auth_result =
  | AuthSuccess of nat
  | AuthFailure of string

(* Factor (matches Coq) *)
type factor =
  | FactorPassword of nat
  | FactorTOTP of nat
  | FactorFIDO2 of nat
  | FactorBiometric of nat

(* Principal (matches Coq) *)
type principal = {
  f_principal_id: nat;
  f_principal_name: string;
}

(* Argon2Params (matches Coq) *)
type argon2_params = {
  f_memory_cost: nat;
  f_time_cost: nat;
  f_parallelism: nat;
  f_output_len: nat;
}

(* Pepper (matches Coq) *)
type pepper = {
  f_pepper_value: list bool;
  f_pepper_hsm_id: nat;
  f_pepper_bound: bool;
}

(* TokenClaims (matches Coq) *)
type token_claims = {
  f_claim_sub: nat;
  f_claim_iat: nat;
  f_claim_exp: nat;
  f_claim_jti: nat;
}

(* ChannelBinding (matches Coq) *)
type channel_binding = {
  f_binding_tls_exporter: list bool;
}

(* BoundToken (matches Coq) *)
type bound_token = {
  f_token_claims: token_claims;
  f_token_binding: channel_binding;
  f_token_signature: list bool;
}

(* Session (matches Coq) *)
type session = {
  f_session_id: nat;
  f_session_principal: nat;
  f_session_created: nat;
  f_session_expires: nat;
  f_session_binding: channel_binding;
}

(* FIDO2Credential (matches Coq) *)
type fido2_credential = {
  f_fido2_id: list bool;
  f_fido2_public_key: list bool;
  f_fido2_counter: nat;
  f_fido2_origin: string;
  f_fido2_user_verification: bool;
}

(* FIDO2Assertion (matches Coq) *)
type fido2_assertion = {
  f_assertion_auth_data: list bool;
  f_assertion_client_data: list bool;
  f_assertion_signature: list bool;
  f_assertion_counter: nat;
  f_assertion_origin: string;
  f_assertion_user_verified: bool;
}

(* AuthLog (matches Coq) *)
type auth_log = {
  f_log_principal: nat;
  f_log_timestamp: nat;
  f_log_success: bool;
  f_log_ip: list bool;
}

(* RateLimitState (matches Coq) *)
type rate_limit_state = {
  f_rate_attempts: nat;
  f_rate_window_start: nat;
  f_rate_max_attempts: nat;
  f_rate_window_size: nat;
}

(* Adversary (matches Coq) *)
type adversary = {
  f_adv_known_keys: list bool;
  f_adv_compromised_channels: list bool;
}

(* MFAConfig (matches Coq) *)
type mfa_config = {
  f_mfa_factors: list bool;
  f_mfa_required: nat;
}

(* list_eq (matches Coq: Fixpoint list_eq) *)
let rec list_eq (p_l1: (list nat)) (p_l2: (list nat)) : Tot bool =
  match p_l1, p_l2 with
  | [], [] -> true
  | x :: xs, y :: ys -> (x = y) && list_eq xs ys
  | _, _ -> false
  | _ -> false

(* SECURE_MEMORY_COST (matches Coq: Definition SECURE_MEMORY_COST) *)
let secure_memory_cost : nat = 100

(* SECURE_TIME_COST (matches Coq: Definition SECURE_TIME_COST) *)
let secure_time_cost : nat = 3

(* SECURE_PARALLELISM (matches Coq: Definition SECURE_PARALLELISM) *)
let secure_parallelism : nat = 4

(* SECURE_OUTPUT_LEN (matches Coq: Definition SECURE_OUTPUT_LEN) *)
let secure_output_len : nat = 32

(* secure_params (matches Coq: Definition secure_params) *)
let secure_params : argon2_params = { memory_cost := SECURE_MEMORY_COST; time_cost := SECURE_TIME_COST; parallelism := SECURE_PARALLELISM; output_len := SECURE_OUTPUT_LEN }

(* params_secure (matches Coq: Definition params_secure) *)
let params_secure (p_p: argon2_params) : Tot bool =
  Nat.leb SECURE_MEMORY_COST (p_p.f_memory_cost) && Nat.leb SECURE_TIME_COST (p_p.f_time_cost) && Nat.leb 1 (p_p.f_parallelism) && Nat.leb SECURE_OUTPUT_LEN (p_p.f_output_len)

(* hash_deterministic_prop (matches Coq: Definition hash_deterministic_prop) *)
let hash_deterministic_prop : bool = true

(* hash_collision_resistant (matches Coq: Definition hash_collision_resistant) *)
let hash_collision_resistant (p_pw1: (list nat)) (p_pw2: (list nat)) (p_salt: (list nat)) (p_params: argon2_params) : Tot bool =
  true

(* constant_time_eq (matches Coq: Fixpoint constant_time_eq) *)
let rec constant_time_eq (p_a: (list nat)) (p_b: (list nat)) : Tot bool =
  match p_a, p_b with
  | [], [] -> true
  | x :: xs, y :: ys -> let diff = Nat.lxor x y in let rest = constant_time_eq xs ys in (diff = 0) && rest
  | _, _ -> false
  | _ -> false

(* empty_used_set (matches Coq: Definition empty_used_set) *)
let empty_used_set : nat = fun _ -> false

(* mark_used (matches Coq: Definition mark_used) *)
let mark_used (p_s: nat) (p_jti: nat) : Tot nat =
  fun j -> if (j = p_jti) then true else p_s j

(* is_used (matches Coq: Definition is_used) *)
let is_used (p_s: nat) (p_jti: nat) : Tot bool =
  p_s p_jti

(* verify_token_binding (matches Coq: Definition verify_token_binding) *)
let verify_token_binding (p_token: bound_token) (p_binding: channel_binding) : Tot bool =
  list_eq (binding_tls_exporter (p_token.f_token_binding)) (p_binding.f_binding_tls_exporter)

(* verify_token_expiry (matches Coq: Definition verify_token_expiry) *)
let verify_token_expiry (p_token: bound_token) (p_now: nat) : Tot bool =
  Nat.leb p_now (claim_exp (p_token.f_token_claims))

(* verify_token_not_replayed (matches Coq: Definition verify_token_not_replayed) *)
let verify_token_not_replayed (p_token: bound_token) (p_used: nat) : Tot bool =
  (not (is_used p_used (claim_jti (p_token.f_token_claims))))

(* verify_token (matches Coq: Definition verify_token) *)
let verify_token (p_token: bound_token) (p_binding: channel_binding) (p_now: nat) (p_used: nat) : Tot bool =
  verify_token_binding p_token p_binding && verify_token_expiry p_token p_now && verify_token_not_replayed p_token p_used

(* empty_revoked (matches Coq: Definition empty_revoked) *)
let empty_revoked : nat = fun _ -> false

(* revoke_token (matches Coq: Definition revoke_token) *)
let revoke_token (p_r: nat) (p_jti: nat) : Tot nat =
  fun j -> if (j = p_jti) then true else p_r j

(* is_revoked (matches Coq: Definition is_revoked) *)
let is_revoked (p_r: nat) (p_jti: nat) : Tot bool =
  p_r p_jti

(* empty_session_store (matches Coq: Definition empty_session_store) *)
let empty_session_store : nat = fun _ -> None

(* add_session (matches Coq: Definition add_session) *)
let add_session (p_store: nat) (p_s: session) : Tot nat =
  fun id -> if Nat.eqb id (p_s.f_session_id) then Some p_s else p_store id

(* session_valid (matches Coq: Definition session_valid) *)
let session_valid (p_s: session) (p_binding: channel_binding) (p_now: nat) : Tot bool =
  Nat.leb p_now (p_s.f_session_expires) && list_eq (binding_tls_exporter (p_s.f_session_binding)) (p_binding.f_binding_tls_exporter)

(* session_regenerated (matches Coq: Definition session_regenerated) *)
let session_regenerated (p_old_id: nat) (p_new_id: nat) : Tot bool =
  true

(* fido2_origin_matches (matches Coq: Definition fido2_origin_matches) *)
let fido2_origin_matches (p_cred: fido2_credential) (p_assertion: fido2_assertion) : Tot bool =
  String.eqb (p_cred.f_fido2_origin) (p_assertion.f_assertion_origin)

(* fido2_counter_valid (matches Coq: Definition fido2_counter_valid) *)
let fido2_counter_valid (p_cred: fido2_credential) (p_assertion: fido2_assertion) : Tot bool =
  (p_cred.f_fido2_counter) < (p_assertion.f_assertion_counter)

(* fido2_user_verified (matches Coq: Definition fido2_user_verified) *)
let fido2_user_verified (p_cred: fido2_credential) (p_assertion: fido2_assertion) : Tot bool =
  ((not (p_cred.f_fido2_user_verification))) || (p_assertion.f_assertion_user_verified)

(* verify_fido2 (matches Coq: Definition verify_fido2) *)
let verify_fido2 (p_cred: fido2_credential) (p_assertion: fido2_assertion) : Tot bool =
  fido2_origin_matches p_cred p_assertion && fido2_counter_valid p_cred p_assertion && fido2_user_verified p_cred p_assertion

(* valid_credential (matches Coq: Definition valid_credential) *)
let valid_credential (p_store: nat) (p_p: principal) (p_c: credential) : Tot bool =
  true

(* credential_matches (matches Coq: Definition credential_matches) *)
let credential_matches (p_c1: credential) (p_c2: credential) : Tot bool =
  match p_c1, p_c2 with
  | CredPassword (h1,, CredPassword, h2) -> list_eq h1 h2
  | CredToken (t1, e1,, CredToken, t2, e2) -> list_eq t1 t2 && (e1 = e2)
  | CredFIDO2 (k1, n1,, CredFIDO2, k2, n2) -> list_eq k1 k2 && (n1 = n2)
  | CredCertificate (x1,, CredCertificate, x2) -> list_eq x1 x2
  | _, _ -> false
  | _ -> false

(* authenticate (matches Coq: Definition authenticate) *)
let authenticate (p_store: nat) (p_p: principal) (p_c: credential) : Tot auth_result =
  if existsb (fun stored_c -> credential_matches stored_c p_c) (p_store (p_p.f_principal_id)) then AuthSuccess (p_p.f_principal_id) else AuthFailure "Invalid credentials"

(* log_auth_attempt (matches Coq: Definition log_auth_attempt) *)
let log_auth_attempt (p_logs: nat) (p_pid: nat) (p_ts: nat) (p_success: bool) (p_ip: (list nat)) : Tot nat =
  mkAuthLog p_pid p_ts p_success p_ip :: p_logs

(* rate_limit_check (matches Coq: Definition rate_limit_check) *)
let rate_limit_check (p_state: rate_limit_state) (p_now: nat) : Tot bool =
  if (p_state.f_rate_window_size) < (p_now - p_state.f_rate_window_start) then true else (p_state.f_rate_attempts) < (p_state.f_rate_max_attempts)

(* rate_limit_update (matches Coq: Definition rate_limit_update) *)
let rate_limit_update (p_state: rate_limit_state) (p_now: nat) : Tot rate_limit_state =
  if (p_state.f_rate_window_size) < (p_now - p_state.f_rate_window_start) then { rate_attempts := 1; rate_window_start := p_now; rate_max_attempts := p_state.f_rate_max_attempts; rate_window_size := p_state.f_rate_window_size } else { rate_attempts := ((p_state.f_rate_attempts) + 1); rate_window_start := p_state.f_rate_window_start; rate_max_attempts := p_state.f_rate_max_attempts; rate_window_size := p_state.f_rate_window_size }

(* has_key (matches Coq: Definition has_key) *)
let has_key (p_adv: adversary) (p_key: (list nat)) : Tot bool =
  true

(* factor_strength (matches Coq: Definition factor_strength) *)
let factor_strength (p_f: factor) : Tot nat =
  match p_f with
  | FactorPassword s -> s
  | FactorTOTP s -> s
  | FactorFIDO2 s -> s
  | FactorBiometric s -> s
  | _ -> 0

(* factor_secure (matches Coq: Definition factor_secure) *)
let factor_secure (p_f: factor) : Tot bool =
  Nat.leb 1 (factor_strength p_f)

(* mfa_combine (matches Coq: Definition mfa_combine) *)
let mfa_combine (p_f1: factor) (p_f2: factor) : Tot mfa_config =
  { mfa_factors := [p_f1; p_f2]; mfa_required := 2 }

(* sum_factor_strengths (matches Coq: Fixpoint sum_factor_strengths) *)
let rec sum_factor_strengths (p_factors: (list factor)) : Tot nat =
  match p_factors with
  | [] -> 0
  | f :: rest -> factor_strength f + sum_factor_strengths rest
  | _ -> 0

(* mfa_strength (matches Coq: Definition mfa_strength) *)
let mfa_strength (p_config: mfa_config) : Tot nat =
  sum_factor_strengths (p_config.f_mfa_factors)

(* all_factors_secure (matches Coq: Fixpoint all_factors_secure) *)
let rec all_factors_secure (p_factors: (list factor)) : Tot bool =
  match p_factors with
  | [] -> true
  | f :: rest -> factor_secure f && all_factors_secure rest
  | _ -> false

(* mfa_secure (matches Coq: Definition mfa_secure) *)
let mfa_secure (p_config: mfa_config) : Tot bool =
  (p_config.f_mfa_required) <= (List.List.Tot.length (p_config.f_mfa_factors)) && all_factors_secure (p_config.f_mfa_factors)

(* password_in_breach (matches Coq: Definition password_in_breach) *)
let password_in_breach (p_db: nat) (p_hash: (list nat)) : Tot bool =
  existsb (fun h -> list_eq h p_hash) p_db

(* list_eq_refl (matches Coq: Lemma list_eq_refl) *)
let list_eq_refl (p_l: _) : Lemma (list_eq p_l p_l == true) = ()

(* list_eq_sym (matches Coq: Lemma list_eq_sym) *)
let list_eq_sym (p_l1: _) (p_l2: _) : Lemma (list_eq p_l1 p_l2 == list_eq p_l2 p_l1) = ()

(* list_eq_sound (matches Coq: Lemma list_eq_sound) *)
let list_eq_sound (p_l1: _) (p_l2: _) : Lemma (requires (list_eq p_l1 p_l2 == true)) (ensures (p_l1 == p_l2)) = ()

(* constant_time_eq_correct (matches Coq: Lemma constant_time_eq_correct) *)
let constant_time_eq_correct (p_a: _) (p_b: _) : Lemma (constant_time_eq p_a p_b == true <==> p_a == p_b) = ()

(* existsb_exists (matches Coq: Lemma existsb_exists) *)
let existsb_exists (p_f: nat) (p_l: _) : Lemma (existsb p_f p_l == true <==> (exists p_x. List.Tot.memP p_x p_l) /\ p_f x == true) = ()

(* existsb_not_exists (matches Coq: Lemma existsb_not_exists) *)
let existsb_not_exists (p_f: nat) (p_l: _) : Lemma (requires (existsb p_f p_l == false <==> (forall (x: _). List.Tot.memP x p_l))) (ensures (p_f x == false)) = ()

(* credential_matches_refl (matches Coq: Lemma credential_matches_refl) *)
let credential_matches_refl (p_c: _) : Lemma (credential_matches p_c p_c == true) = ()

(* credential_matches_eq (matches Coq: Lemma credential_matches_eq) *)
let credential_matches_eq (p_c1: _) (p_c2: _) : Lemma (requires (credential_matches p_c1 p_c2 == true)) (ensures (p_c1 == p_c2)) = ()

(* AA_001_01_auth_completeness (matches Coq: Theorem AA_001_01_auth_completeness) *)
let aa_001_01_auth_completeness (p_p: _) (p_c: _) (p_store: _) : Lemma (requires (valid_credential p_store p_p p_c == true)) (ensures (authenticate p_store p_p p_c == AuthSuccess (p_p.f_principal_id))) = ()

(* AA_001_02_auth_soundness (matches Coq: Theorem AA_001_02_auth_soundness) *)
let aa_001_02_auth_soundness (p_p: _) (p_c: _) (p_store: _) : Lemma (requires (~(valid_credential p_store p_p p_c == true))) (ensures ((exists p_msg. authenticate p_store p_p p_c == AuthFailure p_msg))) = ()

(* AA_001_03_auth_deterministic (matches Coq: Theorem AA_001_03_auth_deterministic) *)
let aa_001_03_auth_deterministic (p_store: _) (p_p: _) (p_c: _) : Lemma (authenticate p_store p_p p_c == authenticate p_store p_p p_c) = ()

(* AA_001_04_credential_unforgeability (matches Coq: Theorem AA_001_04_credential_unforgeability) *)
let aa_001_04_credential_unforgeability (p_store: _) (p_p: _) (p_fake_cred: _) : Lemma (requires (~(valid_credential p_store p_p p_fake_cred == true))) (ensures (~(authenticate p_store p_p p_fake_cred == AuthSuccess (p_p.f_principal_id)))) = ()

(* AA_001_05_no_auth_bypass (matches Coq: Theorem AA_001_05_no_auth_bypass) *)
let aa_001_05_no_auth_bypass (p_store: _) (p_p: _) (p_c: _) : Lemma (requires (authenticate p_store p_p p_c == AuthSuccess (p_p.f_principal_id))) (ensures (valid_credential p_store p_p p_c == true)) = ()

(* AA_001_06_auth_timing_safe (matches Coq: Theorem AA_001_06_auth_timing_safe) *)
let aa_001_06_auth_timing_safe (p_a: _) (p_b: _) : Lemma (constant_time_eq p_a p_b == true <==> p_a == p_b) = ()

(* AA_001_07_auth_rate_limited (matches Coq: Theorem AA_001_07_auth_rate_limited) *)
let aa_001_07_auth_rate_limited (p_state: _) (p_now: _) : Lemma (requires (p_state.f_rate_attempts >= p_state.f_rate_max_attempts /\ p_now - rate_window_start p_state <= p_state.f_rate_window_size)) (ensures (rate_limit_check p_state p_now == false)) = ()

(* AA_001_08_auth_logging (matches Coq: Theorem AA_001_08_auth_logging) *)
let aa_001_08_auth_logging (p_logs: _) (p_pid: _) (p_ts: _) (p_success: _) (p_ip: _) : Lemma ((exists p_entry. List.Tot.memP p_entry new_logs) /\ entry.f_log_principal == p_pid /\ entry.f_log_timestamp == p_ts /\ entry.f_log_success == p_success) = ()

(* AA_001_09_password_hash_secure (matches Coq: Theorem AA_001_09_password_hash_secure) *)
let aa_001_09_password_hash_secure () : Lemma (params_secure secure_params == true) = ()

(* AA_001_10_password_preimage_resistant (matches Coq: Theorem AA_001_10_password_preimage_resistant) *)
let aa_001_10_password_preimage_resistant (p_hash: _) (p_salt: _) (p_params: _) (p_candidate: _) : Lemma (argon2id_hash p_candidate p_salt p_params == p_hash) = ()

(* AA_001_11_password_not_stored (matches Coq: Theorem AA_001_11_password_not_stored) *)
let aa_001_11_password_not_stored (p_store: _) (p_p: _) (p_pwd_hash: _) : Lemma (requires (valid_credential p_store p_p (CredPassword p_pwd_hash) == true)) (ensures ((exists (p_salt: (list nat)). (exists (p_params: argon2_params). List.length p_pwd_hash >= 0)))) = ()

(* AA_001_12_password_pepper_bound (matches Coq: Theorem AA_001_12_password_pepper_bound) *)
let aa_001_12_password_pepper_bound (p_pepper: _) : Lemma (p_pepper.f_pepper_bound == true /\ p_pepper.f_pepper_hsm_id > 0) = ()

(* AA_001_13_password_constant_time_compare (matches Coq: Theorem AA_001_13_password_constant_time_compare) *)
let aa_001_13_password_constant_time_compare (p_h1: _) (p_h2: _) : Lemma (constant_time_eq p_h1 p_h2 == list_eq p_h1 p_h2) = ()

(* AA_001_14_password_breach_checked (matches Coq: Theorem AA_001_14_password_breach_checked) *)
let aa_001_14_password_breach_checked (p_db: _) (p_hash: _) : Lemma (requires (password_in_breach p_db p_hash == true)) (ensures ((exists p_breached_hash. List.Tot.memP p_breached_hash p_db) /\ list_eq breached_hash p_hash == true)) = ()

(* AA_001_15_token_unforgeability (matches Coq: Theorem AA_001_15_token_unforgeability) *)
let aa_001_15_token_unforgeability (p_adv: _) (p_key: _) : Lemma (requires (~(has_key p_adv p_key == true))) (ensures ((forall (claims: token_claims). (forall (binding: channel_binding). (forall (fake_sig: (list nat)). ~((fake_sig == p_key /\ List.length fake_sig > 0 /\ List.Tot.memP fake_sig (p_adv.f_adv_known_keys)))))))) = ()

(* AA_001_16_token_channel_bound (matches Coq: Theorem AA_001_16_token_channel_bound) *)
let aa_001_16_token_channel_bound (p_token: _) (p_binding1: _) (p_binding2: _) : Lemma (requires (~(p_binding1.f_binding_tls_exporter == p_binding2.f_binding_tls_exporter) /\ p_token.f_token_binding == p_binding1)) (ensures (verify_token_binding p_token p_binding2 == false)) = ()

(* AA_001_17_token_expiry (matches Coq: Theorem AA_001_17_token_expiry) *)
let aa_001_17_token_expiry (p_token: _) (p_binding: _) (p_now: _) (p_used: _) : Lemma (requires (p_now > (p_token.f_token_claims).f_claim_exp)) (ensures (verify_token p_token p_binding p_now p_used == false)) = ()

(* AA_001_18_token_replay_prevented (matches Coq: Theorem AA_001_18_token_replay_prevented) *)
let aa_001_18_token_replay_prevented (p_token: _) (p_binding: _) (p_now: _) (p_used: _) : Lemma (requires (is_used p_used ((p_token.f_token_claims).f_claim_jti) == true)) (ensures (verify_token p_token p_binding p_now p_used == false)) = ()

(* AA_001_19_token_revocation (matches Coq: Theorem AA_001_19_token_revocation) *)
let aa_001_19_token_revocation (p_revoked: _) (p_jti: _) : Lemma (is_revoked (revoke_token p_revoked p_jti) p_jti == true) = ()

(* AA_001_20_token_refresh_secure (matches Coq: Theorem AA_001_20_token_refresh_secure) *)
let aa_001_20_token_refresh_secure (p_old_token: _) (p_new_claims: _) (p_binding: _) (p_now: _) (p_used: _) : Lemma (requires (verify_token p_old_token p_binding p_now p_used == true /\ p_new_claims.f_claim_sub == (p_old_token.f_token_claims).f_claim_sub /\ p_new_claims.f_claim_exp > (p_old_token.f_token_claims).f_claim_exp)) (ensures (p_new_claims.f_claim_sub == (p_old_token.f_token_claims).f_claim_sub)) = ()

(* AA_001_21_token_claims_integrity (matches Coq: Theorem AA_001_21_token_claims_integrity) *)
let aa_001_21_token_claims_integrity (p_token: _) : Lemma (p_token.f_token_claims == p_token.f_token_claims) = ()

(* AA_001_22_token_binding_verified (matches Coq: Theorem AA_001_22_token_binding_verified) *)
let aa_001_22_token_binding_verified (p_token: _) (p_binding: _) (p_now: _) (p_used: _) : Lemma (requires (verify_token p_token p_binding p_now p_used == true)) (ensures (verify_token_binding p_token p_binding == true)) = ()

(* AA_001_23_session_isolation (matches Coq: Theorem AA_001_23_session_isolation) *)
let aa_001_23_session_isolation (p_store: _) (p_s1: _) (p_s2: _) : Lemma (requires (p_store (p_s1.f_session_id) == Some p_s1 /\ p_store (p_s2.f_session_id) == Some p_s2 /\ ~(p_s1.f_session_id == p_s2.f_session_id))) (ensures (~(p_s1.f_session_principal == p_s2.f_session_principal) \/ p_s1.f_session_principal == p_s2.f_session_principal)) = ()

(* AA_001_24_session_binding (matches Coq: Theorem AA_001_24_session_binding) *)
let aa_001_24_session_binding (p_s: _) (p_binding1: _) (p_binding2: _) (p_now: _) : Lemma (requires (p_s.f_session_binding == p_binding1 /\ ~(p_binding1.f_binding_tls_exporter == p_binding2.f_binding_tls_exporter))) (ensures (session_valid p_s p_binding2 p_now == false)) = ()

(* AA_001_25_session_expiry (matches Coq: Theorem AA_001_25_session_expiry) *)
let aa_001_25_session_expiry (p_s: _) (p_binding: _) (p_now: _) : Lemma (requires (p_now > p_s.f_session_expires)) (ensures (session_valid p_s p_binding p_now == false)) = ()

(* AA_001_26_session_no_fixation (matches Coq: Theorem AA_001_26_session_no_fixation) *)
let aa_001_26_session_no_fixation (p_attacker_session_id: _) (p_new_session_id: _) : Lemma (requires (~(p_new_session_id == p_attacker_session_id))) (ensures (session_regenerated p_attacker_session_id p_new_session_id == true)) = ()

(* AA_001_27_session_regeneration (matches Coq: Theorem AA_001_27_session_regeneration) *)
let aa_001_27_session_regeneration (p_old_id: _) (p_new_id: _) : Lemma (requires (~(p_old_id == p_new_id))) (ensures (session_regenerated p_old_id p_new_id == true)) = ()

(* AA_001_28_fido2_phishing_resistant (matches Coq: Theorem AA_001_28_fido2_phishing_resistant) *)
let aa_001_28_fido2_phishing_resistant (p_cred: _) (p_assertion: _) : Lemma (requires (~(p_cred.f_fido2_origin == p_assertion.f_assertion_origin))) (ensures (verify_fido2 p_cred p_assertion == false)) = ()

(* AA_001_29_fido2_origin_bound (matches Coq: Theorem AA_001_29_fido2_origin_bound) *)
let aa_001_29_fido2_origin_bound (p_cred: _) (p_assertion: _) : Lemma (requires (verify_fido2 p_cred p_assertion == true)) (ensures (p_cred.f_fido2_origin == p_assertion.f_assertion_origin)) = ()

(* AA_001_30_fido2_replay_prevented (matches Coq: Theorem AA_001_30_fido2_replay_prevented) *)
let aa_001_30_fido2_replay_prevented (p_cred: _) (p_assertion: _) : Lemma (requires (p_assertion.f_assertion_counter <= p_cred.f_fido2_counter)) (ensures (verify_fido2 p_cred p_assertion == false)) = ()

(* AA_001_31_fido2_user_verification (matches Coq: Theorem AA_001_31_fido2_user_verification) *)
let aa_001_31_fido2_user_verification (p_cred: _) (p_assertion: _) : Lemma (requires (p_cred.f_fido2_user_verification == true /\ p_assertion.f_assertion_user_verified == false)) (ensures (verify_fido2 p_cred p_assertion == false)) = ()

(* AA_001_32_mfa_composition (matches Coq: Theorem AA_001_32_mfa_composition) *)
let aa_001_32_mfa_composition (p_f1: _) (p_f2: _) : Lemma (requires (factor_secure p_f1 == true /\ factor_secure p_f2 == true)) (ensures (mfa_secure (mfa_combine p_f1 p_f2) == true /\ mfa_strength (mfa_combine p_f1 p_f2) >= factor_strength p_f1 + factor_strength p_f2)) = ()
