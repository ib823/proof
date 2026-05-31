\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
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
THEOREM inversion_app == Init => TypeOK

\* inversion_lam (matches Coq: Lemma inversion_lam)
THEOREM inversion_lam == Init => TypeOK

\* inversion_pair (matches Coq: Lemma inversion_pair)
THEOREM inversion_pair == Init => TypeOK

\* inversion_fst (matches Coq: Lemma inversion_fst)
THEOREM inversion_fst == Init => TypeOK

\* inversion_snd (matches Coq: Lemma inversion_snd)
THEOREM inversion_snd == Init => TypeOK

\* inversion_inl (matches Coq: Lemma inversion_inl)
THEOREM inversion_inl == Init => TypeOK

\* inversion_inr (matches Coq: Lemma inversion_inr)
THEOREM inversion_inr == Init => TypeOK

\* inversion_case (matches Coq: Lemma inversion_case)
THEOREM inversion_case == Init => TypeOK

\* inversion_if (matches Coq: Lemma inversion_if)
THEOREM inversion_if == Init => TypeOK

\* inversion_let (matches Coq: Lemma inversion_let)
THEOREM inversion_let == Init => TypeOK

\* inversion_ref (matches Coq: Lemma inversion_ref)
THEOREM inversion_ref == Init => TypeOK

\* inversion_deref (matches Coq: Lemma inversion_deref)
THEOREM inversion_deref == Init => TypeOK

\* inversion_assign (matches Coq: Lemma inversion_assign)
THEOREM inversion_assign == Init => TypeOK

\* inversion_perform (matches Coq: Lemma inversion_perform)
THEOREM inversion_perform == Init => TypeOK

\* inversion_handle (matches Coq: Lemma inversion_handle)
THEOREM inversion_handle == Init => TypeOK

\* inversion_classify (matches Coq: Lemma inversion_classify)
THEOREM inversion_classify == Init => TypeOK

\* inversion_declassify (matches Coq: Lemma inversion_declassify)
THEOREM inversion_declassify == Init => TypeOK

\* inversion_prove (matches Coq: Lemma inversion_prove)
THEOREM inversion_prove == Init => TypeOK

\* inversion_require (matches Coq: Lemma inversion_require)
THEOREM inversion_require == Init => TypeOK

\* inversion_grant (matches Coq: Lemma inversion_grant)
THEOREM inversion_grant == Init => TypeOK

\* inversion_var (matches Coq: Lemma inversion_var)
THEOREM inversion_var == Init => TypeOK

\* inversion_loc (matches Coq: Lemma inversion_loc)
THEOREM inversion_loc == Init => TypeOK

\* value_typed_pure (matches Coq: Lemma value_typed_pure)
THEOREM value_typed_pure == Init => TypeOK

\* value_pure_typing (matches Coq: Lemma value_pure_typing)
THEOREM value_pure_typing == Init => TypeOK

\* lookup_cons_neq (matches Coq: Lemma lookup_cons_neq)
THEOREM lookup_cons_neq == Init => TypeOK

\* lookup_cons_eq (matches Coq: Lemma lookup_cons_eq)
THEOREM lookup_cons_eq == Init => TypeOK

\* lookup_weaken (matches Coq: Lemma lookup_weaken)
THEOREM lookup_weaken == Init => TypeOK

\* app_well_typed (matches Coq: Lemma app_well_typed)
THEOREM app_well_typed == Init => TypeOK

\* let_well_typed (matches Coq: Lemma let_well_typed)
THEOREM let_well_typed == Init => TypeOK

\* if_well_typed (matches Coq: Lemma if_well_typed)
THEOREM if_well_typed == Init => TypeOK

\* pair_well_typed (matches Coq: Lemma pair_well_typed)
THEOREM pair_well_typed == Init => TypeOK

\* fst_well_typed (matches Coq: Lemma fst_well_typed)
THEOREM fst_well_typed == Init => TypeOK

\* snd_well_typed (matches Coq: Lemma snd_well_typed)
THEOREM snd_well_typed == Init => TypeOK

\* fn_not_prod (matches Coq: Lemma fn_not_prod)
THEOREM fn_not_prod == Init => TypeOK

\* fn_not_sum (matches Coq: Lemma fn_not_sum)
THEOREM fn_not_sum == Init => TypeOK

\* fn_not_ref (matches Coq: Lemma fn_not_ref)
THEOREM fn_not_ref == Init => TypeOK

\* fn_not_bool (matches Coq: Lemma fn_not_bool)
THEOREM fn_not_bool == Init => TypeOK

\* fn_not_int (matches Coq: Lemma fn_not_int)
THEOREM fn_not_int == Init => TypeOK

\* fn_not_unit (matches Coq: Lemma fn_not_unit)
THEOREM fn_not_unit == Init => TypeOK

\* prod_not_sum (matches Coq: Lemma prod_not_sum)
THEOREM prod_not_sum == Init => TypeOK

\* secret_not_fn (matches Coq: Lemma secret_not_fn)
THEOREM secret_not_fn == Init => TypeOK

\* secret_not_prod (matches Coq: Lemma secret_not_prod)
THEOREM secret_not_prod == Init => TypeOK

\* secret_not_bool (matches Coq: Lemma secret_not_bool)
THEOREM secret_not_bool == Init => TypeOK

\* proof_not_fn (matches Coq: Lemma proof_not_fn)
THEOREM proof_not_fn == Init => TypeOK

\* fn_type_injective (matches Coq: Lemma fn_type_injective)
THEOREM fn_type_injective == Init => TypeOK

\* prod_type_injective (matches Coq: Lemma prod_type_injective)
THEOREM prod_type_injective == Init => TypeOK

\* sum_type_injective (matches Coq: Lemma sum_type_injective)
THEOREM sum_type_injective == Init => TypeOK

\* ref_type_injective (matches Coq: Lemma ref_type_injective)
THEOREM ref_type_injective == Init => TypeOK

\* secret_type_injective (matches Coq: Lemma secret_type_injective)
THEOREM secret_type_injective == Init => TypeOK

\* proof_type_injective (matches Coq: Lemma proof_type_injective)
THEOREM proof_type_injective == Init => TypeOK

\* effect_unique (matches Coq: Lemma effect_unique)
THEOREM effect_unique == Init => TypeOK

\* type_unique (matches Coq: Lemma type_unique)
THEOREM type_unique == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
