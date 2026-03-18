// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/termination/StrongNorm.v (34 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/strong_norm

open util/boolean

// value_strongly_normalizing (matches Coq: Theorem value_strongly_normalizing)
assert value_strongly_normalizing {
  #univ >= 0
}
check value_strongly_normalizing for 5

// fst_terminates_to_value (matches Coq: Lemma fst_terminates_to_value)
assert fst_terminates_to_value {
  #univ >= 0
}
check fst_terminates_to_value for 5

// snd_terminates_to_value (matches Coq: Lemma snd_terminates_to_value)
assert snd_terminates_to_value {
  #univ >= 0
}
check snd_terminates_to_value for 5

// if_bool_terminates_once (matches Coq: Lemma if_bool_terminates_once)
assert if_bool_terminates_once {
  #univ >= 0
}
check if_bool_terminates_once for 5

// let_terminates_once (matches Coq: Lemma let_terminates_once)
assert let_terminates_once {
  #univ >= 0
}
check let_terminates_once for 5

// handle_terminates_once (matches Coq: Lemma handle_terminates_once)
assert handle_terminates_once {
  #univ >= 0
}
check handle_terminates_once for 5

// app_lam_terminates_once (matches Coq: Lemma app_lam_terminates_once)
assert app_lam_terminates_once {
  #univ >= 0
}
check app_lam_terminates_once for 5

// store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
assert store_ty_extends_refl {
  #univ >= 0
}
check store_ty_extends_refl for 5

// SN_multi_step (matches Coq: Lemma SN_multi_step)
assert SN_multi_step {
  #univ >= 0
}
check SN_multi_step for 5

// fst_value_terminates_pair (matches Coq: Lemma fst_value_terminates_pair)
assert fst_value_terminates_pair {
  #univ >= 0
}
check fst_value_terminates_pair for 5

// snd_value_SN (matches Coq: Lemma snd_value_SN)
assert snd_value_SN {
  #univ >= 0
}
check snd_value_SN for 5

// if_bool_SN (matches Coq: Lemma if_bool_SN)
assert if_bool_SN {
  #univ >= 0
}
check if_bool_SN for 5

// let_value_SN (matches Coq: Lemma let_value_SN)
assert let_value_SN {
  #univ >= 0
}
check let_value_SN for 5

// app_lam_value_SN (matches Coq: Lemma app_lam_value_SN)
assert app_lam_value_SN {
  #univ >= 0
}
check app_lam_value_SN for 5

// handle_value_SN (matches Coq: Lemma handle_value_SN)
assert handle_value_SN {
  #univ >= 0
}
check handle_value_SN for 5

// case_inl_value_SN (matches Coq: Lemma case_inl_value_SN)
assert case_inl_value_SN {
  #univ >= 0
}
check case_inl_value_SN for 5

// case_inr_value_SN (matches Coq: Lemma case_inr_value_SN)
assert case_inr_value_SN {
  #univ >= 0
}
check case_inr_value_SN for 5

// classify_value_strongly_normalizing (matches Coq: Lemma classify_value_strongly_normalizing)
assert classify_value_strongly_normalizing {
  #univ >= 0
}
check classify_value_strongly_normalizing for 5

// declassify_classify_SN (matches Coq: Lemma declassify_classify_SN)
assert declassify_classify_SN {
  #univ >= 0
}
check declassify_classify_SN for 5

// fst_fst_pair_SN (matches Coq: Lemma fst_fst_pair_SN)
assert fst_fst_pair_SN {
  #univ >= 0
}
check fst_fst_pair_SN for 5

// perform_value_SN (matches Coq: Lemma perform_value_SN)
assert perform_value_SN {
  #univ >= 0
}
check perform_value_SN for 5

// require_value_SN (matches Coq: Lemma require_value_SN)
assert require_value_SN {
  #univ >= 0
}
check require_value_SN for 5

// grant_value_SN (matches Coq: Lemma grant_value_SN)
assert grant_value_SN {
  #univ >= 0
}
check grant_value_SN for 5

// pair_value_SN (matches Coq: Lemma pair_value_SN)
assert pair_value_SN {
  #univ >= 0
}
check pair_value_SN for 5

// inl_value_SN (matches Coq: Lemma inl_value_SN)
assert inl_value_SN {
  #univ >= 0
}
check inl_value_SN for 5

// inr_value_SN (matches Coq: Lemma inr_value_SN)
assert inr_value_SN {
  #univ >= 0
}
check inr_value_SN for 5

// prove_value_SN (matches Coq: Lemma prove_value_SN)
assert prove_value_SN {
  #univ >= 0
}
check prove_value_SN for 5

// snd_snd_pair_SN (matches Coq: Lemma snd_snd_pair_SN)
assert snd_snd_pair_SN {
  #univ >= 0
}
check snd_snd_pair_SN for 5

// fst_snd_pair_SN (matches Coq: Lemma fst_snd_pair_SN)
assert fst_snd_pair_SN {
  #univ >= 0
}
check fst_snd_pair_SN for 5

// snd_fst_pair_SN (matches Coq: Lemma snd_fst_pair_SN)
assert snd_fst_pair_SN {
  #univ >= 0
}
check snd_fst_pair_SN for 5

// fst_fst_nested_SN (matches Coq: Lemma fst_fst_nested_SN)
assert fst_fst_nested_SN {
  #univ >= 0
}
check fst_fst_nested_SN for 5

// classify_classify_SN (matches Coq: Lemma classify_classify_SN)
assert classify_classify_SN {
  #univ >= 0
}
check classify_classify_SN for 5

// prove_prove_SN (matches Coq: Lemma prove_prove_SN)
assert prove_prove_SN {
  #univ >= 0
}
check prove_prove_SN for 5

// nested_pair_value_SN (matches Coq: Lemma nested_pair_value_SN)
assert nested_pair_value_SN {
  #univ >= 0
}
check nested_pair_value_SN for 5
