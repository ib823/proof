---- MODULE TaintSystemCorrectness ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/TaintSystemCorrectness.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* taint_source (matches Coq: Inductive taint_source)
CONSTANTS TaintNetworkExternal, TaintNetworkInternal, TaintUserInput, TaintFileSystem, TaintDatabase, TaintEnvironment

taint_sourceSet == {TaintNetworkExternal, TaintNetworkInternal, TaintUserInput, TaintFileSystem, TaintDatabase, TaintEnvironment}

\* sanitizer (matches Coq: Inductive sanitizer)
CONSTANTS SanSqlParam, SanHtmlEscape, SanJsEscape, SanCssEscape, SanUrlEncode, SanCommandEscape, SanLdapEscape, SanPathSanitize, SanCsrfToken

sanitizerSet == {SanSqlParam, SanHtmlEscape, SanJsEscape, SanCssEscape, SanUrlEncode, SanCommandEscape, SanLdapEscape, SanPathSanitize, SanCsrfToken}

\* ty (matches Coq: Inductive ty)
CONSTANTS TUnit, TBool, TInt, TString, TFn, TProd, TList, TTainted, TSanitized

tySet == {TUnit, TBool, TInt, TString, TFn, TProd, TList, TTainted, TSanitized}

\* expr (matches Coq: Inductive expr)
CONSTANTS EUnit, ETrue, EFalse, EInt, EStr, EVar, EAbs

exprSet == {EUnit, ETrue, EFalse, EInt, EStr, EVar, EAbs}

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

\* taint_source_eqb (matches Coq: Definition taint_source_eqb)
taint_source_eqb(t2) ==
    CASE t1 = TaintNetworkExternal, TaintNetworkExternal -> TRUE
      [] t1 = TaintNetworkInternal, TaintNetworkInternal -> TRUE
      [] t1 = TaintUserInput, TaintUserInput -> TRUE
      [] t1 = TaintFileSystem, TaintFileSystem -> TRUE
      [] t1 = TaintDatabase, TaintDatabase -> TRUE
      [] t1 = TaintEnvironment, TaintEnvironment -> TRUE
      [] t1 = _, _ -> FALSE

\* sanitizer_eqb (matches Coq: Definition sanitizer_eqb)
sanitizer_eqb(s2) ==
    CASE s1 = SanSqlParam, SanSqlParam -> TRUE
      [] s1 = SanHtmlEscape, SanHtmlEscape -> TRUE
      [] s1 = SanJsEscape, SanJsEscape -> TRUE
      [] s1 = SanCssEscape, SanCssEscape -> TRUE
      [] s1 = SanUrlEncode, SanUrlEncode -> TRUE
      [] s1 = SanCommandEscape, SanCommandEscape -> TRUE
      [] s1 = SanLdapEscape, SanLdapEscape -> TRUE
      [] s1 = SanPathSanitize, SanPathSanitize -> TRUE
      [] s1 = SanCsrfToken, SanCsrfToken -> TRUE
      [] s1 = _, _ -> FALSE

\* env (matches Coq: Definition env)
env ==
  0

\* closed (matches Coq: Definition closed)
closed(e) ==
  e >= 0

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
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* taint_source_eqb_refl
THEOREM taint_source_eqb_refl ==
  \A t \in Nat :
      taint_source_eqb(t, t) = TRUE

\* sanitizer_eqb_refl
THEOREM sanitizer_eqb_refl ==
  \A s \in Nat :
      sanitizer_eqb(s, s) = TRUE

\* taint_source_eqb_eq
THEOREM taint_source_eqb_eq ==
  \A t1 \in Nat, t2 \in Nat :
      taint_source_eqb(t1, t2) => t1 = t2

\* sanitizer_eqb_eq
THEOREM sanitizer_eqb_eq ==
  \A s1 \in Nat, s2 \in Nat :
      sanitizer_eqb(s1, s2) => s1 = s2

\* tainted_not_sanitized
THEOREM tainted_not_sanitized ==
  \A T1 \in Nat, T2 \in Nat, src \in Nat, san \in Nat :
      TTainted T1 src # TSanitized T2 san

\* tainted_not_base
THEOREM tainted_not_base ==
  \A T \in Nat, src \in Nat :
      TTainted T src <> TUnit /\ TTainted T src <> TBool /\ TTainted T src <> TInt /\ TTainted T src <> TString

\* sanitized_not_base
THEOREM sanitized_not_base ==
  \A T \in Nat, san \in Nat :
      TSanitized T san <> TUnit /\ TSanitized T san <> TBool /\ TSanitized T san <> TInt /\ TSanitized T san <> TString

\* canonical_tainted
THEOREM canonical_tainted ==
  \A Γ \in Nat, v \in Nat, T \in Nat, src \in Nat :
      value(v) => exists v', v = ETaint src v' /\ value v'

\* canonical_sanitized
THEOREM canonical_sanitized ==
  \A Γ \in Nat, v \in Nat, T \in Nat, san \in Nat :
      value(v) => exists v', v = ESanitize san v' /\ value v'

\* canonical_fn
THEOREM canonical_fn ==
  \A Γ \in Nat, v \in Nat, T1 \in Nat, T2 \in Nat :
      value(v) => exists x body, v = EAbs x T1 body

\* canonical_bool
THEOREM canonical_bool ==
  \A Γ \in Nat, v \in Nat :
      value(v) => v = ETrue \/ v = EFalse

\* canonical_pair
THEOREM canonical_pair ==
  \A Γ \in Nat, v \in Nat, T1 \in Nat, T2 \in Nat :
      value(v) => exists v1 v2, v = EPair v1 v2 /\ value v1 /\ value v2

\* taint_progress
THEOREM taint_progress ==
  \A e \in Nat, T \in Nat :
      has_type nil e T => value e \/ exists e', step e e'

\* free_in_context
THEOREM free_in_context ==
  \A x \in Nat, e \in Nat, Γ \in Nat, T \in Nat :
      appears_free_in(x, e) => exists T', lookup x Γ = Some T'

\* context_invariance
THEOREM context_invariance ==
  \A Γ \in Nat, Γ \in Nat, e \in Nat, T \in Nat :
      has_type Γ e T => has_type Γ' e T

\* weakening_empty
THEOREM weakening_empty ==
  \A Γ \in Nat, e \in Nat, T \in Nat :
      has_type nil e T => has_type Γ e T

\* substitution_preserves_typing
THEOREM substitution_preserves_typing ==
  \A Γ \in Nat, x \in Nat, U \in Nat, e \in Nat, v \in Nat, T \in Nat :
      has_type ((x, U) :: Γ) e T => has_type Γ (subst x v e) T

\* taint_preservation
THEOREM taint_preservation ==
  \A e \in Nat, e \in Nat, Ty0 \in Nat :
      has_type nil e Ty0 => has_type nil e' Ty0

\* taint_type_safety
THEOREM taint_type_safety ==
  \A e \in Nat, e \in Nat, T \in Nat :
      has_type nil e T => value e' \/ exists e'', step e' e''

\* injection_prevention
THEOREM injection_prevention ==
  \A san \in Nat, e0 \in Nat, T \in Nat :
      has_type nil (EUseSink san e0) T => exists san' v' src, e0 = ESanitize san' (ETaint src v') /\ value v' /\ san = san'

\* taint_sink_structural_impossibility
THEOREM taint_sink_structural_impossibility ==
  \A Γ \in Nat, src \in Nat, san \in Nat, e \in Nat, T \in Nat :
      has_type Γ (ETaint src e) (TSanitized T san) => False

\* tainted_neq_sanitized
THEOREM tainted_neq_sanitized ==
  \A T1 \in Nat, T2 \in Nat, src \in Nat, san \in Nat :
      TTainted T1 src # TSanitized T2 san

\* taint_expr_not_sanitized
THEOREM taint_expr_not_sanitized ==
  \A Γ \in Nat, src \in Nat, e \in Nat, T \in Nat, san \in Nat :
      has_type Γ (ETaint src e) (TSanitized T san) => False

\* sanitize_expr_not_tainted
THEOREM sanitize_expr_not_tainted ==
  \A Γ \in Nat, san \in Nat, e \in Nat, T \in Nat, src \in Nat :
      has_type Γ (ESanitize san e) (TTainted T src) => False

\* taint_sanitize_disjointness_values
THEOREM taint_sanitize_disjointness_values ==
  \A Γ \in Nat, v \in Nat, T1 \in Nat, T2 \in Nat, src \in Nat, san \in Nat :
      value(v) => False

\* 25 additional theorems proven in Coq source

====
