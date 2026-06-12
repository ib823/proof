\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE EffectAlgebra ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/effects/EffectAlgebra.v (44 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* effect_leq (matches Coq: Definition effect_leq)
effect_leq(e1, e2) == TRUE

\* effect_meet (matches Coq: Definition effect_meet)
effect_meet(e1, e2) == TRUE

\* effect_lt (matches Coq: Definition effect_lt)
effect_lt(e1, e2) == TRUE

\* effect_leq_refl (matches Coq: Lemma effect_leq_refl)
THEOREM effect_leq_refl == Init => TypeOK

\* effect_leq_trans (matches Coq: Lemma effect_leq_trans)
THEOREM effect_leq_trans == Init => TypeOK

\* effect_leq_antisym (matches Coq: Lemma effect_leq_antisym)
THEOREM effect_leq_antisym == Init => TypeOK

\* effect_join_comm (matches Coq: Lemma effect_join_comm)
THEOREM effect_join_comm == Init => TypeOK

\* effect_level_join (matches Coq: Lemma effect_level_join)
THEOREM effect_level_join == Init => TypeOK

\* effect_join_assoc (matches Coq: Lemma effect_join_assoc)
THEOREM effect_join_assoc == Init => TypeOK

\* effect_join_ub_l (matches Coq: Lemma effect_join_ub_l)
THEOREM effect_join_ub_l == Init => TypeOK

\* effect_join_ub_r (matches Coq: Lemma effect_join_ub_r)
THEOREM effect_join_ub_r == Init => TypeOK

\* effect_join_lub (matches Coq: Lemma effect_join_lub)
THEOREM effect_join_lub == Init => TypeOK

\* effect_join_idem (matches Coq: Lemma effect_join_idem)
THEOREM effect_join_idem == Init => TypeOK

\* effect_leq_total (matches Coq: Lemma effect_leq_total)
THEOREM effect_leq_total == Init => TypeOK

\* effect_leq_dec (matches Coq: Lemma effect_leq_dec)
THEOREM effect_leq_dec == Init => TypeOK

\* effect_pure_bottom (matches Coq: Lemma effect_pure_bottom)
THEOREM effect_pure_bottom == Init => TypeOK

\* effect_join_pure_l_general (matches Coq: Lemma effect_join_pure_l_general)
THEOREM effect_join_pure_l_general == Init => TypeOK

\* effect_join_pure_r_general (matches Coq: Lemma effect_join_pure_r_general)
THEOREM effect_join_pure_r_general == Init => TypeOK

\* effect_level_injective (matches Coq: Lemma effect_level_injective)
THEOREM effect_level_injective == Init => TypeOK

\* effect_join_mono_l (matches Coq: Lemma effect_join_mono_l)
THEOREM effect_join_mono_l == Init => TypeOK

\* effect_join_mono_r (matches Coq: Lemma effect_join_mono_r)
THEOREM effect_join_mono_r == Init => TypeOK

\* effect_join_leq_iff (matches Coq: Lemma effect_join_leq_iff)
THEOREM effect_join_leq_iff == Init => TypeOK

\* effect_join_leq_iff_l (matches Coq: Lemma effect_join_leq_iff_l)
THEOREM effect_join_leq_iff_l == Init => TypeOK

\* effect_meet_comm (matches Coq: Lemma effect_meet_comm)
THEOREM effect_meet_comm == Init => TypeOK

\* effect_meet_idem (matches Coq: Lemma effect_meet_idem)
THEOREM effect_meet_idem == Init => TypeOK

\* effect_meet_lb_l (matches Coq: Lemma effect_meet_lb_l)
THEOREM effect_meet_lb_l == Init => TypeOK

\* effect_meet_lb_r (matches Coq: Lemma effect_meet_lb_r)
THEOREM effect_meet_lb_r == Init => TypeOK

\* effect_meet_glb (matches Coq: Lemma effect_meet_glb)
THEOREM effect_meet_glb == Init => TypeOK

\* effect_level_meet (matches Coq: Lemma effect_level_meet)
THEOREM effect_level_meet == Init => TypeOK

\* effect_meet_assoc (matches Coq: Lemma effect_meet_assoc)
THEOREM effect_meet_assoc == Init => TypeOK

\* effect_join_meet_absorb (matches Coq: Lemma effect_join_meet_absorb)
THEOREM effect_join_meet_absorb == Init => TypeOK

\* effect_meet_join_absorb (matches Coq: Lemma effect_meet_join_absorb)
THEOREM effect_meet_join_absorb == Init => TypeOK

\* effect_join_meet_distr (matches Coq: Lemma effect_join_meet_distr)
THEOREM effect_join_meet_distr == Init => TypeOK

\* effect_meet_join_distr (matches Coq: Lemma effect_meet_join_distr)
THEOREM effect_meet_join_distr == Init => TypeOK

\* effect_gapura_top (matches Coq: Lemma effect_gapura_top)
THEOREM effect_gapura_top == Init => TypeOK

\* effect_join_gapura (matches Coq: Lemma effect_join_gapura)
THEOREM effect_join_gapura == Init => TypeOK

\* effect_meet_pure (matches Coq: Lemma effect_meet_pure)
THEOREM effect_meet_pure == Init => TypeOK

\* effect_meet_gapura (matches Coq: Lemma effect_meet_gapura)
THEOREM effect_meet_gapura == Init => TypeOK

\* effect_lt_irrefl (matches Coq: Lemma effect_lt_irrefl)
THEOREM effect_lt_irrefl == Init => TypeOK

\* effect_lt_trans (matches Coq: Lemma effect_lt_trans)
THEOREM effect_lt_trans == Init => TypeOK

\* effect_lt_leq (matches Coq: Lemma effect_lt_leq)
THEOREM effect_lt_leq == Init => TypeOK

\* effect_trichotomy (matches Coq: Lemma effect_trichotomy)
THEOREM effect_trichotomy == Init => TypeOK

\* effect_lt_leq_trans (matches Coq: Lemma effect_lt_leq_trans)
THEOREM effect_lt_leq_trans == Init => TypeOK

\* effect_leq_lt_trans (matches Coq: Lemma effect_leq_lt_trans)
THEOREM effect_leq_lt_trans == Init => TypeOK

\* effect_lt_not_eq (matches Coq: Lemma effect_lt_not_eq)
THEOREM effect_lt_not_eq == Init => TypeOK

\* effect_lt_asymmetric (matches Coq: Lemma effect_lt_asymmetric)
THEOREM effect_lt_asymmetric == Init => TypeOK

\* effect_pure_lt_nonpure (matches Coq: Lemma effect_pure_lt_nonpure)
THEOREM effect_pure_lt_nonpure == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
