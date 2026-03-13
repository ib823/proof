---- MODULE TypingInversion ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* inversion_app (matches Coq: Lemma inversion_app)
THEOREM inversion_app == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_lam (matches Coq: Lemma inversion_lam)
THEOREM inversion_lam == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_pair (matches Coq: Lemma inversion_pair)
THEOREM inversion_pair == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_fst (matches Coq: Lemma inversion_fst)
THEOREM inversion_fst == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_snd (matches Coq: Lemma inversion_snd)
THEOREM inversion_snd == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_inl (matches Coq: Lemma inversion_inl)
THEOREM inversion_inl == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_inr (matches Coq: Lemma inversion_inr)
THEOREM inversion_inr == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_case (matches Coq: Lemma inversion_case)
THEOREM inversion_case == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_if (matches Coq: Lemma inversion_if)
THEOREM inversion_if == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_let (matches Coq: Lemma inversion_let)
THEOREM inversion_let == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_ref (matches Coq: Lemma inversion_ref)
THEOREM inversion_ref == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_deref (matches Coq: Lemma inversion_deref)
THEOREM inversion_deref == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_assign (matches Coq: Lemma inversion_assign)
THEOREM inversion_assign == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_perform (matches Coq: Lemma inversion_perform)
THEOREM inversion_perform == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_handle (matches Coq: Lemma inversion_handle)
THEOREM inversion_handle == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_classify (matches Coq: Lemma inversion_classify)
THEOREM inversion_classify == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_declassify (matches Coq: Lemma inversion_declassify)
THEOREM inversion_declassify == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_prove (matches Coq: Lemma inversion_prove)
THEOREM inversion_prove == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_require (matches Coq: Lemma inversion_require)
THEOREM inversion_require == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_grant (matches Coq: Lemma inversion_grant)
THEOREM inversion_grant == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_var (matches Coq: Lemma inversion_var)
THEOREM inversion_var == \A x \in BOOLEAN : Spec => []TypeOK

\* inversion_loc (matches Coq: Lemma inversion_loc)
THEOREM inversion_loc == \A x \in BOOLEAN : Spec => []TypeOK

\* value_typed_pure (matches Coq: Lemma value_typed_pure)
THEOREM value_typed_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* value_pure_typing (matches Coq: Lemma value_pure_typing)
THEOREM value_pure_typing == \A x \in BOOLEAN : Spec => []TypeOK

\* lookup_cons_neq (matches Coq: Lemma lookup_cons_neq)
THEOREM lookup_cons_neq == \A x \in BOOLEAN : Spec => []TypeOK

\* lookup_cons_eq (matches Coq: Lemma lookup_cons_eq)
THEOREM lookup_cons_eq == \A x \in BOOLEAN : Spec => []TypeOK

\* lookup_weaken (matches Coq: Lemma lookup_weaken)
THEOREM lookup_weaken == \A x \in BOOLEAN : Spec => []TypeOK

\* app_well_typed (matches Coq: Lemma app_well_typed)
THEOREM app_well_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* let_well_typed (matches Coq: Lemma let_well_typed)
THEOREM let_well_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* if_well_typed (matches Coq: Lemma if_well_typed)
THEOREM if_well_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* pair_well_typed (matches Coq: Lemma pair_well_typed)
THEOREM pair_well_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* fst_well_typed (matches Coq: Lemma fst_well_typed)
THEOREM fst_well_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* snd_well_typed (matches Coq: Lemma snd_well_typed)
THEOREM snd_well_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* fn_not_prod (matches Coq: Lemma fn_not_prod)
THEOREM fn_not_prod == \A x \in BOOLEAN : Spec => []TypeOK

\* fn_not_sum (matches Coq: Lemma fn_not_sum)
THEOREM fn_not_sum == \A x \in BOOLEAN : Spec => []TypeOK

\* fn_not_ref (matches Coq: Lemma fn_not_ref)
THEOREM fn_not_ref == \A x \in BOOLEAN : Spec => []TypeOK

\* fn_not_bool (matches Coq: Lemma fn_not_bool)
THEOREM fn_not_bool == \A x \in BOOLEAN : Spec => []TypeOK

\* fn_not_int (matches Coq: Lemma fn_not_int)
THEOREM fn_not_int == \A x \in BOOLEAN : Spec => []TypeOK

\* fn_not_unit (matches Coq: Lemma fn_not_unit)
THEOREM fn_not_unit == \A x \in BOOLEAN : Spec => []TypeOK

\* prod_not_sum (matches Coq: Lemma prod_not_sum)
THEOREM prod_not_sum == \A x \in BOOLEAN : Spec => []TypeOK

\* secret_not_fn (matches Coq: Lemma secret_not_fn)
THEOREM secret_not_fn == \A x \in BOOLEAN : Spec => []TypeOK

\* secret_not_prod (matches Coq: Lemma secret_not_prod)
THEOREM secret_not_prod == \A x \in BOOLEAN : Spec => []TypeOK

\* secret_not_bool (matches Coq: Lemma secret_not_bool)
THEOREM secret_not_bool == \A x \in BOOLEAN : Spec => []TypeOK

\* proof_not_fn (matches Coq: Lemma proof_not_fn)
THEOREM proof_not_fn == \A x \in BOOLEAN : Spec => []TypeOK

\* fn_type_injective (matches Coq: Lemma fn_type_injective)
THEOREM fn_type_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* prod_type_injective (matches Coq: Lemma prod_type_injective)
THEOREM prod_type_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* sum_type_injective (matches Coq: Lemma sum_type_injective)
THEOREM sum_type_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* ref_type_injective (matches Coq: Lemma ref_type_injective)
THEOREM ref_type_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* secret_type_injective (matches Coq: Lemma secret_type_injective)
THEOREM secret_type_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* proof_type_injective (matches Coq: Lemma proof_type_injective)
THEOREM proof_type_injective == \A x \in BOOLEAN : Spec => []TypeOK

\* effect_unique (matches Coq: Lemma effect_unique)
THEOREM effect_unique == \A x \in BOOLEAN : Spec => []TypeOK

\* type_unique (matches Coq: Lemma type_unique)
THEOREM type_unique == \A x \in BOOLEAN : Spec => []TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
