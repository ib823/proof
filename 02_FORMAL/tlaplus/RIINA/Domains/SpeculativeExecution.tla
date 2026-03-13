---- MODULE SpeculativeExecution ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/SpeculativeExecution.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* effect (matches Coq: Inductive effect)
CONSTANTS Eff_pure, Eff_timed, Eff_speculative

effectSet == {Eff_pure, Eff_timed, Eff_speculative}

\* visibility (matches Coq: Inductive visibility)
CONSTANTS Public, Secret

visibilitySet == {Public, Secret}

\* value (matches Coq: Inductive value)
CONSTANTS VNat, VBool

valueSet == {VNat, VBool}

\* instr (matches Coq: Inductive instr)
CONSTANTS IConst, IBinop, IBranch, ISeq, IAnnot

instrSet == {IConst, IBinop, IBranch, ISeq, IAnnot}

VARIABLES state, verified, step_count
vars == <<state, verified, step_count>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ state \in Nat
  /\ verified \in BOOLEAN
  /\ step_count \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ state = 0
  /\ verified = FALSE
  /\ step_count = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* eff_le (matches Coq: Definition eff_le)
eff_le(e2) ==
    CASE e1 = Eff_pure, _ -> TRUE
      [] e1 = Eff_timed, Eff_pure -> FALSE
      [] e1 = Eff_timed, _ -> TRUE
      [] e1 = Eff_speculative, Eff_speculative -> TRUE
      [] e1 = Eff_speculative, _ -> FALSE

\* eff_join (matches Coq: Definition eff_join)
eff_join(e2) ==
    CASE e1 = Eff_pure, e | e, Eff_pure -> e
      [] e1 = Eff_speculative, _ | _, Eff_speculative -> Eff_speculative
      [] e1 = Eff_timed, Eff_timed -> Eff_timed

\* is_spec_safe (matches Coq: Definition is_spec_safe)
is_spec_safe(i) ==
  ~(match infer_effect i with Eff_speculative => true | _ => false end)

\* infer_effect (matches Coq: Definition infer_effect)
infer_effect(i) ==
    CASE i = IConst _ -> Eff_pure
      [] i = IBinop a b -> eff_join
      [] i = IBranch Secret _ t f -> eff_join
      [] i = IBranch Public c t f -> eff_join
      [] i = ISeq a b -> eff_join
      [] i = IAnnot e sub -> eff_join

\* is_constant_time (matches Coq: Definition is_constant_time)
is_constant_time(i) ==
    CASE i = IConst _ -> TRUE
      [] i = IBinop a b -> is_constant_time
      [] i = IBranch Secret _ _ _ -> FALSE
      [] i = IBranch Public c t f -> is_constant_time
      [] i = ISeq a b -> is_constant_time
      [] i = IAnnot _ sub -> is_constant_time

\* eval_instr (matches Coq: Definition eval_instr)
eval_instr(i) ==
    CASE i = IConst v -> Some
      [] i = IBinop a b -> match
      [] i = _, _ -> None
      [] i = IBranch _ c t f -> match
    [] OTHER -> None
      [] i = ISeq a b -> match
      [] i = Some _ -> eval_instr
      [] i = None -> None
      [] i = IAnnot _ sub -> eval_instr

\* no_speculative_annotation (matches Coq: Definition no_speculative_annotation)
no_speculative_annotation(i) ==
    CASE i = IConst _ -> TRUE
      [] i = IBinop a b -> no_speculative_annotation
      [] i = IBranch _ c t f -> no_speculative_annotation
      [] i = ISeq a b -> no_speculative_annotation
      [] i = IAnnot Eff_speculative _ -> FALSE
      [] i = IAnnot _ sub -> no_speculative_annotation

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

Step ==
  /\ state' \in Nat
  /\ verified' \in BOOLEAN
  /\ step_count' = step_count + 1

Next == Step

Spec == Init /\ [][Next]_vars

\* ===================================================================


\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* eff_join_pure_l
THEOREM eff_join_pure_l ==
  \A e \in Nat :
      eff_join(Eff_pure, e) = e

\* eff_join_pure_r
THEOREM eff_join_pure_r ==
  \A e \in Nat :
      eff_join(e, Eff_pure) = e

\* eff_le_refl
THEOREM eff_le_refl ==
  \A e \in Nat :
      eff_le(e, e)

\* eff_le_trans
THEOREM eff_le_trans ==
  \A e1 \in Nat, e2 \in Nat, e3 \in Nat :
      eff_le(e1, e2) => eff_le(e1, e3)

  
  Theorem pure_is_constant_time : forall i,
    infer_effect i = Eff_pure => is_constant_time(i)

\* pure_is_constant_time
THEOREM pure_is_constant_time ==
  \A i \in Nat :
      infer_effect(i) = Eff_pure => is_constant_time(i)

  
  Theorem ct_composition : forall a b,
    is_constant_time a = true => is_constant_time (ISeq a b) = true

\* ct_composition
THEOREM ct_composition ==
  \A a \in Nat, b \in Nat :
      is_constant_time(a) => is_constant_time (ISeq a b) = true

  
  Lemma no_secret_branch : forall i,
    is_constant_time i = true => forall c t f, i <> IBranch Secret c t f

\* no_secret_branch
THEOREM no_secret_branch ==
  \A i \in Nat :
      is_constant_time(i) => forall c t f, i <> IBranch Secret c t f

\* spec_safe_no_secret_branch_aux
THEOREM spec_safe_no_secret_branch_aux ==
  \A i \in Nat :
      no_speculative_annotation(i) => is_constant_time(i)

\* spec_safe_implies_no_secret_leakage
THEOREM spec_safe_implies_no_secret_leakage ==
  \A i \in Nat :
      no_speculative_annotation(i) => is_constant_time(i)

  
  Theorem effect_preorder_refl : forall e, eff_le e e = true

\* effect_preorder_refl
THEOREM effect_preorder_refl ==
  \A e \in Nat :
      eff_le(e, e)

\* effect_preorder_trans
THEOREM effect_preorder_trans ==
  \A e1 \in Nat, e2 \in Nat, e3 \in Nat :
      eff_le(e1, e2) => eff_le(e1, e3)

  
  Theorem pure_is_bottom : forall e, eff_le Eff_pure e = true

\* pure_is_bottom
THEOREM pure_is_bottom ==
  \A e \in Nat :
      eff_le(Eff_pure, e)

  
  Theorem seq_preserves_spec_safe : forall a b,
    is_spec_safe a = true => is_spec_safe (ISeq a b) = true

\* seq_preserves_spec_safe
THEOREM seq_preserves_spec_safe ==
  \A a \in Nat, b \in Nat :
      is_spec_safe(a) => is_spec_safe (ISeq a b) = true

  
  Theorem public_branch_ct : forall c t f,
    is_constant_time c = true => is_constant_time (IBranch Public c t f) = true

\* public_branch_ct
THEOREM public_branch_ct ==
  \A c \in Nat, t \in Nat, f \in Nat :
      is_constant_time(c) => is_constant_time (IBranch Public c t f) = true

  
  Definition effect_eq_dec (e1 e2 : effect) : {e1 = e2} + {e1 <> e2}

\* annotation_soundness
THEOREM annotation_soundness ==
  \A e \in Nat, i \in Nat :
      eff_le (infer_effect i) e = true => eff_le (infer_effect (IAnnot e i)) e = true

\* binop_preserves_ct
THEOREM binop_preserves_ct ==
  \A a \in Nat, b \in Nat :
      is_constant_time(a) => is_constant_time (IBinop a b) = true

\* pure_implies_spec_safe
THEOREM pure_implies_spec_safe ==
  \A i \in Nat :
      infer_effect(i) = Eff_pure => is_spec_safe(i)

\* 6 additional theorems proven in Coq source

====
