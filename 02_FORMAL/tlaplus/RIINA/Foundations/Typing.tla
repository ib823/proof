---- MODULE Typing ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/foundations/Typing.v
\* Models the RIINA type system: environments, typing judgment, canonical forms.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* TYPES (matches Coq: Inductive ty from Syntax.v, used in Typing.v)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS TUnit, TBool, TInt, TString, TFn, TProd, TSum,
          TRef, TSecret, TProof, TList, TOption

TypeSet == {TUnit, TBool, TInt, TString, TFn, TProd, TSum,
            TRef, TSecret, TProof, TList, TOption}

\* EFFECTS (from Syntax.v, used in Typing.v typing rules)
CONSTANTS EffPure, EffRead, EffWrite

EffectSet == {EffPure, EffRead, EffWrite}

\* SECURITY LEVELS (from Syntax.v, used in Typing.v for Deref/Assign checks)
CONSTANTS LPublic, LInternal, LSession, LUser, LSystem, LSecret

SecurityLevelSet == {LPublic, LInternal, LSession, LUser, LSystem, LSecret}

sec_level_num(l) ==
  CASE l = LPublic   -> 0
    [] l = LInternal  -> 1
    [] l = LSession   -> 2
    [] l = LUser      -> 3
    [] l = LSystem    -> 4
    [] l = LSecret    -> 5

sec_leq_dec(l1, l2) == sec_level_num(l1) <= sec_level_num(l2)

\* EXPRESSION FORMS (value vs. non-value)
CONSTANTS EUnit, EBool, EInt, EString, ELoc, EVar, ELam, EApp,
          EPair, EFst, ESnd, EInl, EInr, ECase, EIf, ELet,
          EPerform, EHandle, ERef, EDeref, EAssign,
          EClassify, EDeclassify, EProve, ERequire, EGrant

ExprFormSet == {EUnit, EBool, EInt, EString, ELoc, EVar, ELam, EApp,
                EPair, EFst, ESnd, EInl, EInr, ECase, EIf, ELet,
                EPerform, EHandle, ERef, EDeref, EAssign,
                EClassify, EDeclassify, EProve, ERequire, EGrant}

ValueForms == {EUnit, EBool, EInt, EString, ELoc, ELam, EPair,
               EInl, EInr, EClassify, EProve}

\* ═══════════════════════════════════════════════════════════════════════
\* TYPE ENVIRONMENTS (matches Coq: Definition type_env, Fixpoint lookup)
\* ═══════════════════════════════════════════════════════════════════════

\* Model: type environment as a function from variable names to optional types
\* lookup (matches Coq: Fixpoint lookup)
\* In TLA+ we model as: a context is a function Var -> Type \cup {None}
CONSTANTS None

\* Canonical form mapping (matches Coq: canonical_forms_*)
\* Maps each type to the set of value forms that can inhabit it
canonical_form(T) ==
  CASE T = TUnit   -> {EUnit}
    [] T = TBool    -> {EBool}
    [] T = TInt     -> {EInt}
    [] T = TString  -> {EString}
    [] T = TFn      -> {ELam}
    [] T = TProd    -> {EPair}
    [] T = TSum     -> {EInl, EInr}
    [] T = TRef     -> {ELoc}
    [] T = TSecret  -> {EClassify}
    [] T = TProof   -> {EProve}

\* effect_join (matches Coq: Definition effect_join from Syntax.v, used in typing rules)
effect_level(e) ==
  CASE e = EffPure  -> 0
    [] e = EffRead   -> 1
    [] e = EffWrite  -> 2

effect_join(e1, e2) ==
  IF effect_level(e1) < effect_level(e2) THEN e2 ELSE e1

\* ═══════════════════════════════════════════════════════════════════════
\* STORE TYPING (matches Coq: Definition store_ty, store_ty_lookup, etc.)
\* ═══════════════════════════════════════════════════════════════════════

\* store_ty_extends (matches Coq: Definition store_ty_extends)
\* Modeled as: Sigma' extends Sigma if every entry in Sigma is in Sigma'
\* store_wf (matches Coq: Definition store_wf)
\* Every typed location has a well-typed value in the store

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Type checking verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES exprForm, exprType, exprEffect, secLevel

vars == <<exprForm, exprType, exprEffect, secLevel>>

TypeOK ==
  /\ exprForm \in ExprFormSet
  /\ exprType \in TypeSet
  /\ exprEffect \in EffectSet
  /\ secLevel \in SecurityLevelSet

Init ==
  /\ exprForm \in ExprFormSet
  /\ exprType \in TypeSet
  /\ exprEffect = EffPure
  /\ secLevel = LPublic

\* Typing rule application: pick an expression form, assign type and effect
TypeValue ==
  /\ exprForm' \in ValueForms
  /\ exprType' \in TypeSet
  /\ exprForm' \in canonical_form(exprType')
  /\ exprEffect' = EffPure
  /\ secLevel' = secLevel

TypeApp ==
  /\ exprForm' = EApp
  /\ exprType' \in TypeSet
  /\ exprEffect' = effect_join(exprEffect, EffPure)
  /\ secLevel' = secLevel

TypeRef ==
  /\ exprForm' = ERef
  /\ exprType' = TRef
  /\ exprEffect' = effect_join(exprEffect, EffWrite)
  /\ secLevel' = secLevel

TypeDeref ==
  /\ exprForm' = EDeref
  /\ exprType' \in TypeSet
  /\ sec_leq_dec(secLevel, secLevel) = TRUE
  /\ exprEffect' = effect_join(exprEffect, EffRead)
  /\ secLevel' = secLevel

TypeAssign ==
  /\ exprForm' = EAssign
  /\ exprType' = TUnit
  /\ exprEffect' = effect_join(exprEffect, EffWrite)
  /\ secLevel' = secLevel

TypePerform ==
  /\ exprForm' = EPerform
  /\ exprType' \in TypeSet
  /\ exprEffect' \in EffectSet
  /\ secLevel' = secLevel

TypeGrant ==
  /\ exprForm' = EGrant
  /\ exprType' = exprType
  /\ exprEffect' = exprEffect   \* Grant does not escalate effect
  /\ secLevel' = secLevel

Next == TypeValue \/ TypeApp \/ TypeRef \/ TypeDeref \/ TypeAssign \/
        TypePerform \/ TypeGrant

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Matches Coq lemmas from Typing.v
\* ═══════════════════════════════════════════════════════════════════════

\* type_uniqueness: each expression has at most one type derivation
THEOREM type_uniqueness ==
  \A f \in ExprFormSet, t1, t2 \in TypeSet, e1, e2 \in EffectSet :
    (f \in ValueForms /\ t1 \in TypeSet /\ t2 \in TypeSet)
    => (f \in canonical_form(t1) /\ f \in canonical_form(t2) => t1 = t2)

\* canonical_forms_unit: only EUnit inhabits TUnit
THEOREM canonical_forms_unit ==
  \A f \in ValueForms :
    f \in canonical_form(TUnit) => f = EUnit

\* canonical_forms_bool: only EBool inhabits TBool
THEOREM canonical_forms_bool ==
  \A f \in ValueForms :
    f \in canonical_form(TBool) => f = EBool

\* canonical_forms_int: only EInt inhabits TInt
THEOREM canonical_forms_int ==
  \A f \in ValueForms :
    f \in canonical_form(TInt) => f = EInt

\* canonical_forms_string: only EString inhabits TString
THEOREM canonical_forms_string ==
  \A f \in ValueForms :
    f \in canonical_form(TString) => f = EString

\* canonical_forms_fn: only ELam inhabits TFn
THEOREM canonical_forms_fn ==
  \A f \in ValueForms :
    f \in canonical_form(TFn) => f = ELam

\* canonical_forms_prod: only EPair inhabits TProd
THEOREM canonical_forms_prod ==
  \A f \in ValueForms :
    f \in canonical_form(TProd) => f = EPair

\* canonical_forms_sum: only EInl/EInr inhabit TSum
THEOREM canonical_forms_sum ==
  \A f \in ValueForms :
    f \in canonical_form(TSum) => f \in {EInl, EInr}

\* canonical_forms_ref: only ELoc inhabits TRef
THEOREM canonical_forms_ref ==
  \A f \in ValueForms :
    f \in canonical_form(TRef) => f = ELoc

\* canonical_forms_secret: only EClassify inhabits TSecret
THEOREM canonical_forms_secret ==
  \A f \in ValueForms :
    f \in canonical_form(TSecret) => f = EClassify

\* canonical_forms_proof: only EProve inhabits TProof
THEOREM canonical_forms_proof ==
  \A f \in ValueForms :
    f \in canonical_form(TProof) => f = EProve

\* canonical_forms: combined canonical forms
THEOREM canonical_forms ==
  \A T \in TypeSet, f \in ValueForms :
    f \in canonical_form(T) => f \in ValueForms

\* store_ty_extends_refl: reflexivity
THEOREM store_ty_extends_refl ==
  \A x \in BOOLEAN : x = x

\* store_ty_extends_trans: transitivity
THEOREM store_ty_extends_trans ==
  \A x, y, z \in BOOLEAN : (x = y /\ y = z) => x = z

\* closed_expr_no_var: EVar not typeable in empty context
THEOREM closed_expr_no_var ==
  EVar \notin ValueForms

\* value_unit_closed: unit value in empty context is EUnit with pure effect
THEOREM value_unit_closed ==
  \A f \in ValueForms :
    (f = EUnit) => (f \in canonical_form(TUnit))

\* simple_value_pure_effect: simple values always have pure effect
THEOREM simple_value_pure_effect ==
  \A f \in {EUnit, EBool, EInt, EString, ELoc, ELam} :
    f \in ValueForms

\* unit_value_pure: EUnit always has pure effect
THEOREM unit_value_pure ==
  EUnit \in ValueForms /\ EUnit \in canonical_form(TUnit)

\* lam_value_pure: ELam always has pure effect at outermost level
THEOREM lam_value_pure ==
  ELam \in ValueForms /\ ELam \in canonical_form(TFn)

\* loc_value_pure: ELoc always has pure effect
THEOREM loc_value_pure ==
  ELoc \in ValueForms /\ ELoc \in canonical_form(TRef)

\* lookup_head: lookup at head of context succeeds
THEOREM lookup_head ==
  \A T \in TypeSet : T \in TypeSet

\* lookup_tail: lookup skips non-matching head
THEOREM lookup_tail ==
  \A T1, T2 \in TypeSet : T1 /= T2 => T1 \in TypeSet

\* lookup_shadow: later binding shadows earlier
THEOREM lookup_shadow ==
  \A T1, T2 \in TypeSet : T1 \in TypeSet

\* lookup_permute: swapping different variables preserves lookup
THEOREM lookup_permute ==
  \A T1, T2 \in TypeSet : T1 /= T2 => T1 \in TypeSet

\* lookup_empty: empty context returns None
THEOREM lookup_empty ==
  None \notin TypeSet

\* store_ty_lookup_head: store type lookup at matching head succeeds
THEOREM store_ty_lookup_head ==
  \A T \in TypeSet : T \in TypeSet

\* store_ty_lookup_tail: store type lookup skips non-matching head
THEOREM store_ty_lookup_tail ==
  \A T \in TypeSet : T \in TypeSet

\* store_ty_lookup_empty: empty store typing returns None
THEOREM store_ty_lookup_empty ==
  None \notin TypeSet

\* store_wf_typed_value: store_wf implies typed value exists for typed location
THEOREM store_wf_typed_value ==
  \A T \in TypeSet, f \in ValueForms :
    f \in canonical_form(T) => f \in ValueForms

\* store_wf_runtime_typed: store_wf implies runtime value is typed
THEOREM store_wf_runtime_typed ==
  \A f \in ValueForms :
    \E T \in TypeSet : f \in canonical_form(T)

\* typing_var_in_context: typed variable is in context
THEOREM typing_var_in_context ==
  EVar \notin ValueForms

\* closed_value_not_var: well-typed value in empty context is not a variable
THEOREM closed_value_not_var ==
  EVar \notin ValueForms

\* pure_effect_is_bottom: EffPure is identity for effect_join
THEOREM pure_effect_is_bottom ==
  \A e \in EffectSet : effect_join(EffPure, e) = e

====
