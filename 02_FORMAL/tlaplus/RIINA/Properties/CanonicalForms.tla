\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE CanonicalForms ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/CanonicalForms.v (43 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* canonical_unit (matches Coq: Lemma canonical_unit)
THEOREM canonical_unit == Init => TypeOK

\* canonical_bool (matches Coq: Lemma canonical_bool)
THEOREM canonical_bool == Init => TypeOK

\* canonical_int (matches Coq: Lemma canonical_int)
THEOREM canonical_int == Init => TypeOK

\* canonical_string (matches Coq: Lemma canonical_string)
THEOREM canonical_string == Init => TypeOK

\* canonical_fn (matches Coq: Lemma canonical_fn)
THEOREM canonical_fn == Init => TypeOK

\* canonical_pair (matches Coq: Lemma canonical_pair)
THEOREM canonical_pair == Init => TypeOK

\* canonical_sum (matches Coq: Lemma canonical_sum)
THEOREM canonical_sum == Init => TypeOK

\* canonical_sum_inl (matches Coq: Lemma canonical_sum_inl)
THEOREM canonical_sum_inl == Init => TypeOK

\* canonical_ref (matches Coq: Lemma canonical_ref)
THEOREM canonical_ref == Init => TypeOK

\* canonical_secret (matches Coq: Lemma canonical_secret)
THEOREM canonical_secret == Init => TypeOK

\* canonical_proof (matches Coq: Lemma canonical_proof)
THEOREM canonical_proof == Init => TypeOK

\* base_value_pure (matches Coq: Lemma base_value_pure)
THEOREM base_value_pure == Init => TypeOK

\* unit_value_pure (matches Coq: Lemma unit_value_pure)
THEOREM unit_value_pure == Init => TypeOK

\* bool_value_pure (matches Coq: Lemma bool_value_pure)
THEOREM bool_value_pure == Init => TypeOK

\* int_value_pure (matches Coq: Lemma int_value_pure)
THEOREM int_value_pure == Init => TypeOK

\* string_value_pure (matches Coq: Lemma string_value_pure)
THEOREM string_value_pure == Init => TypeOK

\* lambda_value_pure (matches Coq: Lemma lambda_value_pure)
THEOREM lambda_value_pure == Init => TypeOK

\* loc_value_pure (matches Coq: Lemma loc_value_pure)
THEOREM loc_value_pure == Init => TypeOK

\* unit_not_bool (matches Coq: Lemma unit_not_bool)
THEOREM unit_not_bool == Init => TypeOK

\* unit_not_int (matches Coq: Lemma unit_not_int)
THEOREM unit_not_int == Init => TypeOK

\* unit_not_fn (matches Coq: Lemma unit_not_fn)
THEOREM unit_not_fn == Init => TypeOK

\* bool_not_unit (matches Coq: Lemma bool_not_unit)
THEOREM bool_not_unit == Init => TypeOK

\* bool_not_int (matches Coq: Lemma bool_not_int)
THEOREM bool_not_int == Init => TypeOK

\* int_not_unit (matches Coq: Lemma int_not_unit)
THEOREM int_not_unit == Init => TypeOK

\* int_not_bool (matches Coq: Lemma int_not_bool)
THEOREM int_not_bool == Init => TypeOK

\* pair_components_typed (matches Coq: Lemma pair_components_typed)
THEOREM pair_components_typed == Init => TypeOK

\* inl_component_typed (matches Coq: Lemma inl_component_typed)
THEOREM inl_component_typed == Init => TypeOK

\* inr_component_typed (matches Coq: Lemma inr_component_typed)
THEOREM inr_component_typed == Init => TypeOK

\* classify_component_typed (matches Coq: Lemma classify_component_typed)
THEOREM classify_component_typed == Init => TypeOK

\* prove_component_typed (matches Coq: Lemma prove_component_typed)
THEOREM prove_component_typed == Init => TypeOK

\* value_shape (matches Coq: Lemma value_shape)
THEOREM value_shape == Init => TypeOK

\* value_type_unit (matches Coq: Lemma value_type_unit)
THEOREM value_type_unit == Init => TypeOK

\* value_type_bool (matches Coq: Lemma value_type_bool)
THEOREM value_type_bool == Init => TypeOK

\* value_type_int (matches Coq: Lemma value_type_int)
THEOREM value_type_int == Init => TypeOK

\* value_type_string (matches Coq: Lemma value_type_string)
THEOREM value_type_string == Init => TypeOK

\* value_type_loc (matches Coq: Lemma value_type_loc)
THEOREM value_type_loc == Init => TypeOK

\* value_type_lam (matches Coq: Lemma value_type_lam)
THEOREM value_type_lam == Init => TypeOK

\* canonical_pair_typed_components (matches Coq: Lemma canonical_pair_typed_components)
THEOREM canonical_pair_typed_components == Init => TypeOK

\* canonical_pair_component_values (matches Coq: Lemma canonical_pair_component_values)
THEOREM canonical_pair_component_values == Init => TypeOK

\* canonical_inl_component_value (matches Coq: Lemma canonical_inl_component_value)
THEOREM canonical_inl_component_value == Init => TypeOK

\* canonical_inr_component_value (matches Coq: Lemma canonical_inr_component_value)
THEOREM canonical_inr_component_value == Init => TypeOK

\* canonical_classify_component_value (matches Coq: Lemma canonical_classify_component_value)
THEOREM canonical_classify_component_value == Init => TypeOK

\* canonical_prove_component_value (matches Coq: Lemma canonical_prove_component_value)
THEOREM canonical_prove_component_value == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
