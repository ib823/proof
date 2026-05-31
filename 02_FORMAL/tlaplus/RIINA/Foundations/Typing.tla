\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE Typing ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/foundations/Typing.v (33 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* lookup (matches Coq: Definition lookup)
lookup(x, gamma) == TRUE

\* store_ty_update (matches Coq: Definition store_ty_update)
store_ty_update(l, T, sl, sigma) == TRUE

\* free_in (matches Coq: Definition free_in)
free_in(x, e) == TRUE

\* store_wf (matches Coq: Definition store_wf)
store_wf(sigma, st) == TRUE

\* store_ty_extends (matches Coq: Definition store_ty_extends)
store_ty_extends(sigma, sigma_prime) == TRUE

\* type_uniqueness (matches Coq: Lemma type_uniqueness)
THEOREM type_uniqueness == Init => TypeOK

\* canonical_forms_unit (matches Coq: Lemma canonical_forms_unit)
THEOREM canonical_forms_unit == Init => TypeOK

\* canonical_forms_bool (matches Coq: Lemma canonical_forms_bool)
THEOREM canonical_forms_bool == Init => TypeOK

\* canonical_forms_int (matches Coq: Lemma canonical_forms_int)
THEOREM canonical_forms_int == Init => TypeOK

\* canonical_forms_string (matches Coq: Lemma canonical_forms_string)
THEOREM canonical_forms_string == Init => TypeOK

\* canonical_forms_fn (matches Coq: Lemma canonical_forms_fn)
THEOREM canonical_forms_fn == Init => TypeOK

\* canonical_forms_prod (matches Coq: Lemma canonical_forms_prod)
THEOREM canonical_forms_prod == Init => TypeOK

\* canonical_forms_sum (matches Coq: Lemma canonical_forms_sum)
THEOREM canonical_forms_sum == Init => TypeOK

\* canonical_forms_ref (matches Coq: Lemma canonical_forms_ref)
THEOREM canonical_forms_ref == Init => TypeOK

\* canonical_forms_secret (matches Coq: Lemma canonical_forms_secret)
THEOREM canonical_forms_secret == Init => TypeOK

\* canonical_forms_proof (matches Coq: Lemma canonical_forms_proof)
THEOREM canonical_forms_proof == Init => TypeOK

\* canonical_forms (matches Coq: Lemma canonical_forms)
THEOREM canonical_forms == Init => TypeOK

\* store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
THEOREM store_ty_extends_refl == Init => TypeOK

\* store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
THEOREM store_ty_extends_trans == Init => TypeOK

\* closed_expr_no_var (matches Coq: Lemma closed_expr_no_var)
THEOREM closed_expr_no_var == Init => TypeOK

\* value_unit_closed (matches Coq: Lemma value_unit_closed)
THEOREM value_unit_closed == Init => TypeOK

\* simple_value_pure_effect (matches Coq: Lemma simple_value_pure_effect)
THEOREM simple_value_pure_effect == Init => TypeOK

\* unit_value_pure (matches Coq: Lemma unit_value_pure)
THEOREM unit_value_pure == Init => TypeOK

\* lam_value_pure (matches Coq: Lemma lam_value_pure)
THEOREM lam_value_pure == Init => TypeOK

\* loc_value_pure (matches Coq: Lemma loc_value_pure)
THEOREM loc_value_pure == Init => TypeOK

\* lookup_head (matches Coq: Lemma lookup_head)
THEOREM lookup_head == Init => TypeOK

\* lookup_tail (matches Coq: Lemma lookup_tail)
THEOREM lookup_tail == Init => TypeOK

\* lookup_shadow (matches Coq: Lemma lookup_shadow)
THEOREM lookup_shadow == Init => TypeOK

\* lookup_permute (matches Coq: Lemma lookup_permute)
THEOREM lookup_permute == Init => TypeOK

\* lookup_empty (matches Coq: Lemma lookup_empty)
THEOREM lookup_empty == Init => TypeOK

\* store_ty_lookup_head (matches Coq: Lemma store_ty_lookup_head)
THEOREM store_ty_lookup_head == Init => TypeOK

\* store_ty_lookup_tail (matches Coq: Lemma store_ty_lookup_tail)
THEOREM store_ty_lookup_tail == Init => TypeOK

\* store_ty_lookup_empty (matches Coq: Lemma store_ty_lookup_empty)
THEOREM store_ty_lookup_empty == Init => TypeOK

\* store_wf_typed_value (matches Coq: Lemma store_wf_typed_value)
THEOREM store_wf_typed_value == Init => TypeOK

\* store_wf_runtime_typed (matches Coq: Lemma store_wf_runtime_typed)
THEOREM store_wf_runtime_typed == Init => TypeOK

\* typing_var_in_context (matches Coq: Lemma typing_var_in_context)
THEOREM typing_var_in_context == Init => TypeOK

\* closed_value_not_var (matches Coq: Lemma closed_value_not_var)
THEOREM closed_value_not_var == Init => TypeOK

\* pure_effect_is_bottom (matches Coq: Lemma pure_effect_is_bottom)
THEOREM pure_effect_is_bottom == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
