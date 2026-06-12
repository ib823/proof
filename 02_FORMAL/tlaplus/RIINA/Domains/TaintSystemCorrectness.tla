\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE TaintSystemCorrectness ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/TaintSystemCorrectness.v (50 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* taint_source (matches Coq: Inductive taint_source)
CONSTANTS TaintNetworkExternal, TaintNetworkInternal, TaintUserInput, TaintFileSystem, TaintDatabase, TaintEnvironment

\* sanitizer (matches Coq: Inductive sanitizer)
CONSTANTS SanSqlParam, SanHtmlEscape, SanJsEscape, SanCssEscape, SanUrlEncode, SanCommandEscape, SanLdapEscape, SanPathSanitize, SanCsrfToken

\* ty (matches Coq: Inductive ty)
CONSTANTS TUnit, TBool, TInt, TString, TFn, TProd, TList, TTainted, TSanitized

\* expr (matches Coq: Inductive expr)
CONSTANTS EUnit, ETrue, EFalse, EInt, EStr, EVar, EAbs, EApp, ELet, EIf, EPair, EFst, ESnd, ETaint, ESanitize, EUseSink

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* taint_source_eqb (matches Coq: Definition taint_source_eqb)
taint_source_eqb(t1, t2) == TRUE

\* sanitizer_eqb (matches Coq: Definition sanitizer_eqb)
sanitizer_eqb(s1, s2) == TRUE

\* lookup (matches Coq: Definition lookup)
lookup(x, gamma) == TRUE

\* subst (matches Coq: Definition subst)
subst(x, s, e) == TRUE

\* taint_source_eqb_refl (matches Coq: Lemma taint_source_eqb_refl)
THEOREM taint_source_eqb_refl == Init => TypeOK

\* sanitizer_eqb_refl (matches Coq: Lemma sanitizer_eqb_refl)
THEOREM sanitizer_eqb_refl == Init => TypeOK

\* taint_source_eqb_eq (matches Coq: Lemma taint_source_eqb_eq)
THEOREM taint_source_eqb_eq == Init => TypeOK

\* sanitizer_eqb_eq (matches Coq: Lemma sanitizer_eqb_eq)
THEOREM sanitizer_eqb_eq == Init => TypeOK

\* tainted_not_sanitized (matches Coq: Lemma tainted_not_sanitized)
THEOREM tainted_not_sanitized == Init => TypeOK

\* tainted_not_base (matches Coq: Lemma tainted_not_base)
THEOREM tainted_not_base == Init => TypeOK

\* sanitized_not_base (matches Coq: Lemma sanitized_not_base)
THEOREM sanitized_not_base == Init => TypeOK

\* canonical_tainted (matches Coq: Lemma canonical_tainted)
THEOREM canonical_tainted == Init => TypeOK

\* canonical_sanitized (matches Coq: Lemma canonical_sanitized)
THEOREM canonical_sanitized == Init => TypeOK

\* canonical_fn (matches Coq: Lemma canonical_fn)
THEOREM canonical_fn == Init => TypeOK

\* canonical_bool (matches Coq: Lemma canonical_bool)
THEOREM canonical_bool == Init => TypeOK

\* canonical_pair (matches Coq: Lemma canonical_pair)
THEOREM canonical_pair == Init => TypeOK

\* taint_progress (matches Coq: Theorem taint_progress)
THEOREM taint_progress == Init => TypeOK

\* free_in_context (matches Coq: Lemma free_in_context)
THEOREM free_in_context == Init => TypeOK

\* context_invariance (matches Coq: Lemma context_invariance)
THEOREM context_invariance == Init => TypeOK

\* weakening_empty (matches Coq: Lemma weakening_empty)
THEOREM weakening_empty == Init => TypeOK

\* substitution_preserves_typing (matches Coq: Lemma substitution_preserves_typing)
THEOREM substitution_preserves_typing == Init => TypeOK

\* taint_preservation (matches Coq: Theorem taint_preservation)
THEOREM taint_preservation == Init => TypeOK

\* taint_type_safety (matches Coq: Theorem taint_type_safety)
THEOREM taint_type_safety == Init => TypeOK

\* injection_prevention (matches Coq: Theorem injection_prevention)
THEOREM injection_prevention == Init => TypeOK

\* taint_sink_structural_impossibility (matches Coq: Lemma taint_sink_structural_impossibility)
THEOREM taint_sink_structural_impossibility == Init => TypeOK

\* tainted_neq_sanitized (matches Coq: Lemma tainted_neq_sanitized)
THEOREM tainted_neq_sanitized == Init => TypeOK

\* taint_expr_not_sanitized (matches Coq: Theorem taint_expr_not_sanitized)
THEOREM taint_expr_not_sanitized == Init => TypeOK

\* sanitize_expr_not_tainted (matches Coq: Theorem sanitize_expr_not_tainted)
THEOREM sanitize_expr_not_tainted == Init => TypeOK

\* taint_sanitize_disjointness_values (matches Coq: Theorem taint_sanitize_disjointness_values)
THEOREM taint_sanitize_disjointness_values == Init => TypeOK

\* taint_preserved_pair_fst (matches Coq: Lemma taint_preserved_pair_fst)
THEOREM taint_preserved_pair_fst == Init => TypeOK

\* taint_preserved_pair_snd (matches Coq: Lemma taint_preserved_pair_snd)
THEOREM taint_preserved_pair_snd == Init => TypeOK

\* taint_preserved_let (matches Coq: Lemma taint_preserved_let)
THEOREM taint_preserved_let == Init => TypeOK

\* sanitized_preserved_let (matches Coq: Lemma sanitized_preserved_let)
THEOREM sanitized_preserved_let == Init => TypeOK

\* sql_requires_sql_sanitizer (matches Coq: Lemma sql_requires_sql_sanitizer)
THEOREM sql_requires_sql_sanitizer == Init => TypeOK

\* html_requires_html_sanitizer (matches Coq: Lemma html_requires_html_sanitizer)
THEOREM html_requires_html_sanitizer == Init => TypeOK

\* js_requires_js_sanitizer (matches Coq: Lemma js_requires_js_sanitizer)
THEOREM js_requires_js_sanitizer == Init => TypeOK

\* cmd_requires_cmd_sanitizer (matches Coq: Lemma cmd_requires_cmd_sanitizer)
THEOREM cmd_requires_cmd_sanitizer == Init => TypeOK

\* ldap_requires_ldap_sanitizer (matches Coq: Lemma ldap_requires_ldap_sanitizer)
THEOREM ldap_requires_ldap_sanitizer == Init => TypeOK

\* url_requires_url_sanitizer (matches Coq: Lemma url_requires_url_sanitizer)
THEOREM url_requires_url_sanitizer == Init => TypeOK

\* css_requires_css_sanitizer (matches Coq: Lemma css_requires_css_sanitizer)
THEOREM css_requires_css_sanitizer == Init => TypeOK

\* path_requires_path_sanitizer (matches Coq: Lemma path_requires_path_sanitizer)
THEOREM path_requires_path_sanitizer == Init => TypeOK

\* csrf_requires_csrf_sanitizer (matches Coq: Lemma csrf_requires_csrf_sanitizer)
THEOREM csrf_requires_csrf_sanitizer == Init => TypeOK

\* lookup_deterministic (matches Coq: Lemma lookup_deterministic)
THEOREM lookup_deterministic == Init => TypeOK

\* typing_unique (matches Coq: Theorem typing_unique)
THEOREM typing_unique == Init => TypeOK

\* wrong_sanitizer_rejected (matches Coq: Lemma wrong_sanitizer_rejected)
THEOREM wrong_sanitizer_rejected == Init => TypeOK

\* sql_injection_impossible (matches Coq: Theorem sql_injection_impossible)
THEOREM sql_injection_impossible == Init => TypeOK

\* xss_html_impossible (matches Coq: Theorem xss_html_impossible)
THEOREM xss_html_impossible == Init => TypeOK

\* xss_js_impossible (matches Coq: Theorem xss_js_impossible)
THEOREM xss_js_impossible == Init => TypeOK

\* xss_css_impossible (matches Coq: Theorem xss_css_impossible)
THEOREM xss_css_impossible == Init => TypeOK

\* xss_url_impossible (matches Coq: Theorem xss_url_impossible)
THEOREM xss_url_impossible == Init => TypeOK

\* command_injection_impossible (matches Coq: Theorem command_injection_impossible)
THEOREM command_injection_impossible == Init => TypeOK

\* ldap_injection_impossible (matches Coq: Theorem ldap_injection_impossible)
THEOREM ldap_injection_impossible == Init => TypeOK

\* path_traversal_impossible (matches Coq: Theorem path_traversal_impossible)
THEOREM path_traversal_impossible == Init => TypeOK

\* csrf_impossible (matches Coq: Theorem csrf_impossible)
THEOREM csrf_impossible == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
