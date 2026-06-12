(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Properties.TypingInversion
open FStar.All

(* value — Coq Prop predicate stub *)
assume val value : nat -> bool

(* wf_session — Coq Prop predicate stub *)
assume val wf_session : nat -> bool

(* has_type — Coq Prop predicate stub *)
assume val has_type : nat -> nat -> nat -> nat -> nat -> nat -> bool

(* inversion_app (matches Coq: Lemma inversion_app) *)
let inversion_app (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EApp p_e1 p_e2) p_t p_epsilon == true)) (ensures ((exists p_t1. (exists p_epsilon_fn. (exists p_epsilon1. (exists p_epsilon2. has_type p_gamma p_sigma p_delta p_e1 (TFn p_t1 p_t epsilon_fn) epsilon1 == true)))) /\ has_type p_gamma p_sigma p_delta p_e2 T1 epsilon2 == true /\ p_epsilon == effect_join epsilon_fn (effect_join epsilon1 epsilon2))) = admit ()

(* inversion_lam (matches Coq: Lemma inversion_lam) *)
let inversion_lam (p_gamma: _) (p_sigma: _) (p_delta: _) (p_x: _) (p_t1: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ELam p_x p_t1 p_e) p_t p_epsilon == true)) (ensures ((exists p_t2. (exists p_epsilon_body. has_type ((p_x, p_t1) :: p_gamma) p_sigma p_delta p_e p_t2 epsilon_body == true)) /\ p_t == TFn p_t1 T2 epsilon_body /\ p_epsilon == EffectPure)) = admit ()

(* inversion_pair (matches Coq: Lemma inversion_pair) *)
let inversion_pair (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EPair p_e1 p_e2) p_t p_epsilon == true)) (ensures ((exists p_t1. (exists p_t2. (exists p_epsilon1. (exists p_epsilon2. has_type p_gamma p_sigma p_delta p_e1 p_t1 epsilon1 == true)))) /\ has_type p_gamma p_sigma p_delta p_e2 T2 epsilon2 == true /\ p_t == TProd T1 T2 /\ p_epsilon == effect_join epsilon1 epsilon2)) = admit ()

(* inversion_fst (matches Coq: Lemma inversion_fst) *)
let inversion_fst (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EFst p_e) p_t p_epsilon == true)) (ensures ((exists p_t2. has_type p_gamma p_sigma p_delta p_e (TProd p_t p_t2) p_epsilon == true))) = admit ()

(* inversion_snd (matches Coq: Lemma inversion_snd) *)
let inversion_snd (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ESnd p_e) p_t p_epsilon == true)) (ensures ((exists p_t1. has_type p_gamma p_sigma p_delta p_e (TProd p_t1 p_t) p_epsilon == true))) = admit ()

(* inversion_inl (matches Coq: Lemma inversion_inl) *)
let inversion_inl (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t_sum: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EInl p_e p_t_sum) p_t p_epsilon == true)) (ensures ((exists p_t1. (exists p_t2. has_type p_gamma p_sigma p_delta p_e p_t1 p_epsilon == true)) /\ p_t == TSum T1 T2)) = admit ()

(* inversion_inr (matches Coq: Lemma inversion_inr) *)
let inversion_inr (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t_sum: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EInr p_e p_t_sum) p_t p_epsilon == true)) (ensures ((exists p_t1. (exists p_t2. has_type p_gamma p_sigma p_delta p_e p_t2 p_epsilon == true)) /\ p_t == TSum T1 T2)) = admit ()

(* inversion_case (matches Coq: Lemma inversion_case) *)
let inversion_case (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_x1: _) (p_e1: _) (p_x2: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ECase p_e p_x1 p_e1 p_x2 p_e2) p_t p_epsilon == true)) (ensures ((exists p_t1. (exists p_t2. (exists p_epsilon0. (exists p_epsilon1. (exists p_epsilon2. has_type p_gamma p_sigma p_delta p_e (TSum p_t1 p_t2) epsilon0 == true))))) /\ has_type ((p_x1, T1) :: p_gamma) p_sigma p_delta p_e1 p_t epsilon1 == true /\ has_type ((p_x2, T2) :: p_gamma) p_sigma p_delta p_e2 p_t epsilon2 == true /\ p_epsilon == effect_join epsilon0 (effect_join epsilon1 epsilon2))) = admit ()

(* inversion_if (matches Coq: Lemma inversion_if) *)
let inversion_if (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_e3: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EIf p_e1 p_e2 p_e3) p_t p_epsilon == true)) (ensures ((exists p_epsilon1. (exists p_epsilon2. (exists p_epsilon3. has_type p_gamma p_sigma p_delta p_e1 TBool epsilon1 == true))) /\ has_type p_gamma p_sigma p_delta p_e2 p_t epsilon2 == true /\ has_type p_gamma p_sigma p_delta p_e3 p_t epsilon3 == true /\ p_epsilon == effect_join epsilon1 (effect_join epsilon2 epsilon3))) = admit ()

(* inversion_let (matches Coq: Lemma inversion_let) *)
let inversion_let (p_gamma: _) (p_sigma: _) (p_delta: _) (p_x: _) (p_e1: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ELet p_x p_e1 p_e2) p_t p_epsilon == true)) (ensures ((exists p_t1. (exists p_epsilon1. (exists p_epsilon2. has_type p_gamma p_sigma p_delta p_e1 p_t1 epsilon1 == true))) /\ has_type ((p_x, T1) :: p_gamma) p_sigma p_delta p_e2 p_t epsilon2 == true /\ p_epsilon == effect_join epsilon1 epsilon2)) = admit ()

(* inversion_ref (matches Coq: Lemma inversion_ref) *)
let inversion_ref (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_l: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ERef p_e p_l) p_t p_epsilon == true)) (ensures ((exists p_t. has_type p_gamma p_sigma p_delta p_e p_t' epsilon_prime == true) /\ p_t == TRef p_t' p_l /\ p_epsilon == effect_join epsilon_prime EffectWrite)) = admit ()

(* inversion_deref (matches Coq: Lemma inversion_deref) *)
let inversion_deref (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EDeref p_e) p_t p_epsilon == true)) (ensures ((exists p_l. (exists p_epsilon. has_type p_gamma p_sigma p_delta p_e (TRef p_t p_l) epsilon_prime == true)) /\ sec_leq_dec l p_delta == true /\ p_epsilon == effect_join epsilon_prime EffectRead)) = admit ()

(* inversion_assign (matches Coq: Lemma inversion_assign) *)
let inversion_assign (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EAssign p_e1 p_e2) p_t p_epsilon == true)) (ensures ((exists p_t. has_type p_gamma p_sigma p_delta p_e1 (TRef p_t' l) epsilon1 == true) /\ has_type p_gamma p_sigma p_delta p_e2 p_t' epsilon2 == true /\ sec_leq_dec p_delta l == true /\ p_t == TUnit /\ p_epsilon == effect_join epsilon1 (effect_join epsilon2 EffectWrite))) = admit ()

(* inversion_perform (matches Coq: Lemma inversion_perform) *)
let inversion_perform (p_gamma: _) (p_sigma: _) (p_delta: _) (p_eff: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EPerform p_eff p_e) p_t p_epsilon == true)) (ensures ((exists p_epsilon. has_type p_gamma p_sigma p_delta p_e p_t epsilon_prime == true) /\ p_epsilon == effect_join epsilon_prime p_eff)) = admit ()

(* inversion_handle (matches Coq: Lemma inversion_handle) *)
let inversion_handle (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_x: _) (p_h: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EHandle p_e p_x p_h) p_t p_epsilon == true)) (ensures ((exists p_t1. (exists p_epsilon1. (exists p_epsilon2. has_type p_gamma p_sigma p_delta p_e p_t1 epsilon1 == true))) /\ has_type ((p_x, T1) :: p_gamma) p_sigma p_delta p_h p_t epsilon2 == true /\ p_epsilon == effect_join epsilon1 epsilon2)) = admit ()

(* inversion_classify (matches Coq: Lemma inversion_classify) *)
let inversion_classify (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EClassify p_e) p_t p_epsilon == true)) (ensures ((exists p_t. has_type p_gamma p_sigma p_delta p_e p_t' p_epsilon == true) /\ p_t == TSecret p_t')) = admit ()

(* inversion_declassify (matches Coq: Lemma inversion_declassify) *)
let inversion_declassify (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EDeclassify p_e1 p_e2) p_t p_epsilon == true)) (ensures ((exists p_epsilon1. (exists p_epsilon2. has_type p_gamma p_sigma p_delta p_e1 (TSecret p_t) epsilon1 == true)) /\ has_type p_gamma p_sigma p_delta p_e2 (TProof (TSecret p_t)) epsilon2 == true /\ declass_ok p_e1 p_e2 == true /\ p_epsilon == effect_join epsilon1 epsilon2)) = admit ()

(* inversion_prove (matches Coq: Lemma inversion_prove) *)
let inversion_prove (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EProve p_e) p_t p_epsilon == true)) (ensures ((exists p_t. has_type p_gamma p_sigma p_delta p_e p_t' p_epsilon == true) /\ p_t == TProof p_t')) = admit ()

(* inversion_require (matches Coq: Lemma inversion_require) *)
let inversion_require (p_gamma: _) (p_sigma: _) (p_delta: _) (p_eff: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ERequire p_eff p_e) p_t p_epsilon == true)) (ensures ((exists p_epsilon. has_type p_gamma p_sigma p_delta p_e p_t epsilon_prime == true) /\ p_epsilon == effect_join epsilon_prime p_eff)) = admit ()

(* inversion_grant (matches Coq: Lemma inversion_grant) *)
let inversion_grant (p_gamma: _) (p_sigma: _) (p_delta: _) (p_eff: _) (p_e: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EGrant p_eff p_e) p_t p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta p_e p_t p_epsilon == true)) = admit ()

(* inversion_var (matches Coq: Lemma inversion_var) *)
let inversion_var (p_gamma: _) (p_sigma: _) (p_delta: _) (p_x: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (EVar p_x) p_t p_epsilon == true)) (ensures (lookup p_x p_gamma == Some p_t /\ p_epsilon == EffectPure)) = admit ()

(* inversion_loc (matches Coq: Lemma inversion_loc) *)
let inversion_loc (p_gamma: _) (p_sigma: _) (p_delta: _) (p_l: _) (p_t: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta (ELoc p_l) p_t p_epsilon == true)) (ensures ((exists p_t. store_ty_lookup p_l p_sigma == Some (p_t', sl)) /\ p_t == TRef p_t' sl /\ p_epsilon == EffectPure)) = admit ()

(* value_typed_pure (matches Coq: Lemma value_typed_pure) *)
let value_typed_pure (p_gamma: _) (p_sigma: _) (p_delta: _) (p_v: _) (p_t: _) (p_epsilon: _) : Lemma (requires (value p_v == true /\ has_type p_gamma p_sigma p_delta p_v p_t p_epsilon == true)) (ensures (p_epsilon == EffectPure)) = admit ()

(* value_pure_typing (matches Coq: Lemma value_pure_typing) *)
let value_pure_typing (p_gamma: _) (p_sigma: _) (p_delta: _) (p_v: _) (p_t: _) (p_epsilon: _) : Lemma (requires (value p_v == true /\ has_type p_gamma p_sigma p_delta p_v p_t p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta p_v p_t EffectPure == true)) = admit ()

(* lookup_cons_neq (matches Coq: Lemma lookup_cons_neq) *)
let lookup_cons_neq (p_x: _) (p_y: _) (p_t: _) (p_gamma: _) : Lemma (requires (~(p_x == p_y))) (ensures (lookup p_x ((p_y, p_t) :: p_gamma) == lookup p_x p_gamma)) = admit ()

(* lookup_cons_eq (matches Coq: Lemma lookup_cons_eq) *)
let lookup_cons_eq (p_x: _) (p_t: _) (p_gamma: _) : Lemma (lookup p_x ((p_x, p_t) :: p_gamma) == Some p_t) = admit ()

(* lookup_weaken (matches Coq: Lemma lookup_weaken) *)
let lookup_weaken (p_x: _) (p_t: _) (p_gamma: _) (p_y: _) (p_t_: _) : Lemma (requires (lookup p_x p_gamma == Some p_t /\ ~(p_x == p_y))) (ensures (lookup p_x ((p_y, p_t') :: p_gamma) == Some p_t)) = admit ()

(* app_well_typed (matches Coq: Lemma app_well_typed) *)
let app_well_typed (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t1: _) (p_t2: _) (p_epsilon_fn: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 (TFn p_t1 p_t2 p_epsilon_fn) p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e2 p_t1 p_epsilon2 == true)) (ensures (has_type p_gamma p_sigma p_delta (EApp p_e1 p_e2) p_t2 (effect_join p_epsilon_fn (effect_join p_epsilon1 p_epsilon2)) == true)) = admit ()

(* let_well_typed (matches Coq: Lemma let_well_typed) *)
let let_well_typed (p_gamma: _) (p_sigma: _) (p_delta: _) (p_x: _) (p_e1: _) (p_e2: _) (p_t1: _) (p_t2: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 p_t1 p_epsilon1 == true /\ has_type ((p_x, p_t1) :: p_gamma) p_sigma p_delta p_e2 p_t2 p_epsilon2 == true)) (ensures (has_type p_gamma p_sigma p_delta (ELet p_x p_e1 p_e2) p_t2 (effect_join p_epsilon1 p_epsilon2) == true)) = admit ()

(* if_well_typed (matches Coq: Lemma if_well_typed) *)
let if_well_typed (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_e3: _) (p_t: _) (p_epsilon1: _) (p_epsilon2: _) (p_epsilon3: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 TBool p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e2 p_t p_epsilon2 == true /\ has_type p_gamma p_sigma p_delta p_e3 p_t p_epsilon3 == true)) (ensures (has_type p_gamma p_sigma p_delta (EIf p_e1 p_e2 p_e3) p_t (effect_join p_epsilon1 (effect_join p_epsilon2 p_epsilon3)) == true)) = admit ()

(* pair_well_typed (matches Coq: Lemma pair_well_typed) *)
let pair_well_typed (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e1: _) (p_e2: _) (p_t1: _) (p_t2: _) (p_epsilon1: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e1 p_t1 p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e2 p_t2 p_epsilon2 == true)) (ensures (has_type p_gamma p_sigma p_delta (EPair p_e1 p_e2) (TProd p_t1 p_t2) (effect_join p_epsilon1 p_epsilon2) == true)) = admit ()

(* fst_well_typed (matches Coq: Lemma fst_well_typed) *)
let fst_well_typed (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e (TProd p_t1 p_t2) p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta (EFst p_e) p_t1 p_epsilon == true)) = admit ()

(* snd_well_typed (matches Coq: Lemma snd_well_typed) *)
let snd_well_typed (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e (TProd p_t1 p_t2) p_epsilon == true)) (ensures (has_type p_gamma p_sigma p_delta (ESnd p_e) p_t2 p_epsilon == true)) = admit ()

(* fn_not_prod (matches Coq: Lemma fn_not_prod) *)
let fn_not_prod (p_t1: _) (p_t2: _) (p_epsilon: _) (p_t3: _) (p_t4: _) : Lemma (~(TFn p_t1 p_t2 p_epsilon == TProd p_t3 p_t4)) = admit ()

(* fn_not_sum (matches Coq: Lemma fn_not_sum) *)
let fn_not_sum (p_t1: _) (p_t2: _) (p_epsilon: _) (p_t3: _) (p_t4: _) : Lemma (~(TFn p_t1 p_t2 p_epsilon == TSum p_t3 p_t4)) = admit ()

(* fn_not_ref (matches Coq: Lemma fn_not_ref) *)
let fn_not_ref (p_t1: _) (p_t2: _) (p_epsilon: _) (p_t3: _) (p_sl: _) : Lemma (~(TFn p_t1 p_t2 p_epsilon == TRef p_t3 p_sl)) = admit ()

(* fn_not_bool (matches Coq: Lemma fn_not_bool) *)
let fn_not_bool (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (~(TFn p_t1 p_t2 p_epsilon == TBool)) = admit ()

(* fn_not_int (matches Coq: Lemma fn_not_int) *)
let fn_not_int (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (~(TFn p_t1 p_t2 p_epsilon == TInt)) = admit ()

(* fn_not_unit (matches Coq: Lemma fn_not_unit) *)
let fn_not_unit (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (~(TFn p_t1 p_t2 p_epsilon == TUnit)) = admit ()

(* prod_not_sum (matches Coq: Lemma prod_not_sum) *)
let prod_not_sum (p_t1: _) (p_t2: _) (p_t3: _) (p_t4: _) : Lemma (~(TProd p_t1 p_t2 == TSum p_t3 p_t4)) = admit ()

(* secret_not_fn (matches Coq: Lemma secret_not_fn) *)
let secret_not_fn (p_t: _) (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (~(TSecret p_t == TFn p_t1 p_t2 p_epsilon)) = admit ()

(* secret_not_prod (matches Coq: Lemma secret_not_prod) *)
let secret_not_prod (p_t: _) (p_t1: _) (p_t2: _) : Lemma (~(TSecret p_t == TProd p_t1 p_t2)) = admit ()

(* secret_not_bool (matches Coq: Lemma secret_not_bool) *)
let secret_not_bool (p_t: _) : Lemma (~(TSecret p_t == TBool)) = admit ()

(* proof_not_fn (matches Coq: Lemma proof_not_fn) *)
let proof_not_fn (p_t: _) (p_t1: _) (p_t2: _) (p_epsilon: _) : Lemma (~(TProof p_t == TFn p_t1 p_t2 p_epsilon)) = admit ()

(* fn_type_injective (matches Coq: Lemma fn_type_injective) *)
let fn_type_injective (p_t1: _) (p_t2: _) (p_epsilon: _) (p_t1_: _) (p_t2_: _) (p_epsilon_prime: _) : Lemma (requires (TFn p_t1 p_t2 p_epsilon == TFn p_t1' p_t2' p_epsilon_prime)) (ensures (p_t1 == p_t1' /\ p_t2 == p_t2' /\ p_epsilon == p_epsilon_prime)) = admit ()

(* prod_type_injective (matches Coq: Lemma prod_type_injective) *)
let prod_type_injective (p_t1: _) (p_t2: _) (p_t1_: _) (p_t2_: _) : Lemma (requires (TProd p_t1 p_t2 == TProd p_t1' p_t2')) (ensures (p_t1 == p_t1' /\ p_t2 == p_t2')) = admit ()

(* sum_type_injective (matches Coq: Lemma sum_type_injective) *)
let sum_type_injective (p_t1: _) (p_t2: _) (p_t1_: _) (p_t2_: _) : Lemma (requires (TSum p_t1 p_t2 == TSum p_t1' p_t2')) (ensures (p_t1 == p_t1' /\ p_t2 == p_t2')) = admit ()

(* ref_type_injective (matches Coq: Lemma ref_type_injective) *)
let ref_type_injective (p_t: _) (p_sl: _) (p_t_: _) (p_sl_: _) : Lemma (requires (TRef p_t p_sl == TRef p_t' p_sl_)) (ensures (p_t == p_t' /\ p_sl == p_sl_)) = admit ()

(* secret_type_injective (matches Coq: Lemma secret_type_injective) *)
let secret_type_injective (p_t: _) (p_t_: _) : Lemma (requires (TSecret p_t == TSecret p_t')) (ensures (p_t == p_t')) = admit ()

(* proof_type_injective (matches Coq: Lemma proof_type_injective) *)
let proof_type_injective (p_t: _) (p_t_: _) : Lemma (requires (TProof p_t == TProof p_t')) (ensures (p_t == p_t')) = admit ()

(* effect_unique (matches Coq: Lemma effect_unique) *)
let effect_unique (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t1: _) (p_epsilon1: _) (p_t2: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t1 p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e p_t2 p_epsilon2 == true)) (ensures (p_epsilon1 == p_epsilon2)) = admit ()

(* type_unique (matches Coq: Lemma type_unique) *)
let type_unique (p_gamma: _) (p_sigma: _) (p_delta: _) (p_e: _) (p_t1: _) (p_epsilon1: _) (p_t2: _) (p_epsilon2: _) : Lemma (requires (has_type p_gamma p_sigma p_delta p_e p_t1 p_epsilon1 == true /\ has_type p_gamma p_sigma p_delta p_e p_t2 p_epsilon2 == true)) (ensures (p_t1 == p_t2)) = admit ()
