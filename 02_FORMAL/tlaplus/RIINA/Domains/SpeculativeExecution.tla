\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE SpeculativeExecution ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/SpeculativeExecution.v (20 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* effect (matches Coq: Inductive effect)
CONSTANTS Eff_pure, Eff_timed, Eff_speculative

\* visibility (matches Coq: Inductive visibility)
CONSTANTS Public, Secret

\* value (matches Coq: Inductive value)
CONSTANTS VNat, VBool

\* instr (matches Coq: Inductive instr)
CONSTANTS IConst, IBinop, IBranch, ISeq, IAnnot

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* eff_le (matches Coq: Definition eff_le)
eff_le(e1, e2) == TRUE

\* eff_join (matches Coq: Definition eff_join)
eff_join(e1, e2) == TRUE

\* infer_effect (matches Coq: Definition infer_effect)
infer_effect(i) == TRUE

\* is_constant_time (matches Coq: Definition is_constant_time)
is_constant_time(i) == TRUE

\* is_spec_safe (matches Coq: Definition is_spec_safe)
is_spec_safe(i) == TRUE

\* eval_instr (matches Coq: Definition eval_instr)
eval_instr(i) == TRUE

\* no_speculative_annotation (matches Coq: Definition no_speculative_annotation)
no_speculative_annotation(i) == TRUE

\* eff_join_pure_l (matches Coq: Lemma eff_join_pure_l)
THEOREM eff_join_pure_l == Init => TypeOK

\* eff_join_pure_r (matches Coq: Lemma eff_join_pure_r)
THEOREM eff_join_pure_r == Init => TypeOK

\* eff_le_refl (matches Coq: Lemma eff_le_refl)
THEOREM eff_le_refl == Init => TypeOK

\* eff_le_trans (matches Coq: Lemma eff_le_trans)
THEOREM eff_le_trans == Init => TypeOK

\* pure_is_constant_time (matches Coq: Theorem pure_is_constant_time)
THEOREM pure_is_constant_time == Init => TypeOK

\* ct_composition (matches Coq: Theorem ct_composition)
THEOREM ct_composition == Init => TypeOK

\* no_secret_branch (matches Coq: Lemma no_secret_branch)
THEOREM no_secret_branch == Init => TypeOK

\* spec_safe_no_secret_branch_aux (matches Coq: Lemma spec_safe_no_secret_branch_aux)
THEOREM spec_safe_no_secret_branch_aux == Init => TypeOK

\* spec_safe_implies_no_secret_leakage (matches Coq: Theorem spec_safe_implies_no_secret_leakage)
THEOREM spec_safe_implies_no_secret_leakage == Init => TypeOK

\* effect_preorder_refl (matches Coq: Theorem effect_preorder_refl)
THEOREM effect_preorder_refl == Init => TypeOK

\* effect_preorder_trans (matches Coq: Theorem effect_preorder_trans)
THEOREM effect_preorder_trans == Init => TypeOK

\* pure_is_bottom (matches Coq: Theorem pure_is_bottom)
THEOREM pure_is_bottom == Init => TypeOK

\* seq_preserves_spec_safe (matches Coq: Theorem seq_preserves_spec_safe)
THEOREM seq_preserves_spec_safe == Init => TypeOK

\* public_branch_ct (matches Coq: Theorem public_branch_ct)
THEOREM public_branch_ct == Init => TypeOK

\* annotation_soundness (matches Coq: Theorem annotation_soundness)
THEOREM annotation_soundness == Init => TypeOK

\* binop_preserves_ct (matches Coq: Theorem binop_preserves_ct)
THEOREM binop_preserves_ct == Init => TypeOK

\* pure_implies_spec_safe (matches Coq: Theorem pure_implies_spec_safe)
THEOREM pure_implies_spec_safe == Init => TypeOK

\* timed_implies_spec_safe (matches Coq: Theorem timed_implies_spec_safe)
THEOREM timed_implies_spec_safe == Init => TypeOK

\* const_is_pure (matches Coq: Theorem const_is_pure)
THEOREM const_is_pure == Init => TypeOK

\* eff_join_comm (matches Coq: Theorem eff_join_comm)
THEOREM eff_join_comm == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
