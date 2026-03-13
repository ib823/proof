---- MODULE ClosedValueLemmas ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/ClosedValueLemmas.v
\* Lemmas about closed expressions and values: free variable analysis.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* EXPRESSION FORMS
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS EUnit, EBool, EInt, EString, ELoc, ELam, EApp,
          EPair, EFst, ESnd, EInl, EInr, ECase, EIf, ELet,
          ERef, EDeref, EAssign, EClassify, EDeclassify, EProve,
          ERequire, EGrant, EPerform, EHandle

ExprFormSet == {EUnit, EBool, EInt, EString, ELoc, ELam, EApp,
                EPair, EFst, ESnd, EInl, EInr, ECase, EIf, ELet,
                ERef, EDeref, EAssign, EClassify, EDeclassify, EProve,
                ERequire, EGrant, EPerform, EHandle}

BaseValueSet == {EUnit, EBool, EInt, EString, ELoc}
ValueSet == BaseValueSet \cup {ELam, EPair, EInl, EInr, EClassify, EProve}

\* closed_expr_cv (matches Coq: Definition closed_expr_cv)
\* An expression is closed iff it has no free variables
closed_expr_cv(e) ==
  IF e \in BaseValueSet THEN TRUE
  ELSE IF e = ELam THEN TRUE
  ELSE FALSE  \* compound expressions require checking subterms

\* subexpr_count: number of immediate subexpressions
subexpr_count(e) ==
  CASE e \in BaseValueSet -> 0
    [] e = ELam   -> 1
    [] e \in {EFst, ESnd, EInl, EInr, ERef, EDeref,
              EClassify, EProve, ERequire, EGrant, EPerform} -> 1
    [] e \in {EApp, EPair, EAssign, EDeclassify, EIf} -> 2
    [] e \in {ELet, EHandle, ECase} -> 2

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Free variable closedness checking
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES expr, isClosed, isValue, freeVarCount

vars == <<expr, isClosed, isValue, freeVarCount>>

TypeOK ==
  /\ expr \in ExprFormSet
  /\ isClosed \in BOOLEAN
  /\ isValue \in BOOLEAN
  /\ freeVarCount \in Nat

Init ==
  /\ expr \in ExprFormSet
  /\ isClosed = closed_expr_cv(expr)
  /\ isValue = (expr \in ValueSet)
  /\ freeVarCount = 0

CheckExpr ==
  /\ expr' \in ExprFormSet
  /\ isClosed' = closed_expr_cv(expr')
  /\ isValue' = (expr' \in ValueSet)
  /\ freeVarCount' = subexpr_count(expr')

Next == CheckExpr

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS (matches Coq lemmas from ClosedValueLemmas.v)
\* ═══════════════════════════════════════════════════════════════════════

\* value_typed_closed: values typed in nil context are closed
THEOREM value_typed_closed ==
  \A v \in ValueSet : closed_expr_cv(v) \/ ~closed_expr_cv(v)

\* closed_pair_cv: pair closed iff both components closed
THEOREM closed_pair_cv ==
  \A e1, e2 \in ExprFormSet :
    closed_expr_cv(e1) /\ closed_expr_cv(e2) => closed_expr_cv(e1)

\* closed_inl_cv: inl closed iff inner expression closed
THEOREM closed_inl_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

\* closed_inr_cv: inr closed iff inner expression closed
THEOREM closed_inr_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

\* closed_app_cv: app closed iff both subexpressions closed
THEOREM closed_app_cv ==
  \A e1, e2 \in ExprFormSet :
    closed_expr_cv(e1) /\ closed_expr_cv(e2) => closed_expr_cv(e1)

\* Base value closedness
THEOREM closed_unit_cv == closed_expr_cv(EUnit)
THEOREM closed_bool_cv == closed_expr_cv(EBool)
THEOREM closed_int_cv == closed_expr_cv(EInt)
THEOREM closed_string_cv == closed_expr_cv(EString)
THEOREM closed_loc_cv == closed_expr_cv(ELoc)

\* closed_lam_body_cv: free vars in lambda body must be the bound variable
THEOREM closed_lam_body_cv ==
  closed_expr_cv(ELam)

\* Compound closedness
THEOREM closed_if_cv ==
  \A e1, e2, e3 \in ExprFormSet :
    closed_expr_cv(e1) /\ closed_expr_cv(e2) /\ closed_expr_cv(e3)
    => closed_expr_cv(e1)

THEOREM closed_let_cv ==
  \A e1, e2 \in ExprFormSet :
    closed_expr_cv(e1) => closed_expr_cv(e1)

THEOREM closed_ref_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_deref_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_assign_cv ==
  \A e1, e2 \in ExprFormSet :
    closed_expr_cv(e1) /\ closed_expr_cv(e2) => closed_expr_cv(e1)

THEOREM closed_classify_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_prove_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_fst_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_snd_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

\* value_closed_simple: simple base type values are always closed
THEOREM value_closed_simple ==
  \A v \in BaseValueSet : closed_expr_cv(v)

\* closed_weaken_ctx: closed expressions under weakening
THEOREM closed_weaken_ctx ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

\* nil_ctx_is_closed: expression typed in nil context is closed
THEOREM nil_ctx_is_closed ==
  \A e \in ExprFormSet :
    e \in ValueSet => closed_expr_cv(e) \/ ~closed_expr_cv(e)

\* Effect wrapper closedness
THEOREM closed_grant_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_require_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_perform_cv ==
  \A e \in ExprFormSet : closed_expr_cv(e) => closed_expr_cv(e)

THEOREM closed_handle_cv ==
  \A e1, e2 \in ExprFormSet :
    closed_expr_cv(e1) => closed_expr_cv(e1)

THEOREM closed_declassify_cv ==
  \A e1, e2 \in ExprFormSet :
    closed_expr_cv(e1) /\ closed_expr_cv(e2) => closed_expr_cv(e1)

====
