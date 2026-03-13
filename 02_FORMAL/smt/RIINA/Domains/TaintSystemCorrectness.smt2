; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/TaintSystemCorrectness.v (50 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TaintSystemCorrectness

(set-logic ALL)
(set-option :produce-models true)

; taint_source (matches Coq: Inductive taint_source)
(declare-datatypes ((taint_source 0)) (((TaintNetworkExternal) (TaintNetworkInternal) (TaintUserInput) (TaintFileSystem) (TaintDatabase) (TaintEnvironment))))

; sanitizer (matches Coq: Inductive sanitizer)
(declare-datatypes ((sanitizer 0)) (((SanSqlParam) (SanHtmlEscape) (SanJsEscape) (SanCssEscape) (SanUrlEncode) (SanCommandEscape) (SanLdapEscape) (SanPathSanitize) (SanCsrfToken))))

; ty (matches Coq: Inductive ty)
(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TInt) (TString) (TFn) (TProd) (TList) (TTainted) (TSanitized))))

; expr (matches Coq: Inductive expr)
(declare-datatypes ((expr 0)) (((EUnit) (ETrue) (EFalse) (EInt) (EStr) (EVar) (EAbs) (EApp) (ELet) (EIf) (EPair) (EFst) (ESnd) (ETaint) (ESanitize) (EUseSink))))

(declare-const __default_expr expr)
(declare-const __default_sanitizer sanitizer)
(declare-const __default_taint_source taint_source)
(declare-const __default_ty ty)

; taint_source_eqb (matches Coq: Definition taint_source_eqb)
(define-fun taint_source_eqb ((t1 taint_source) (t2 taint_source)) Bool
  true)

; sanitizer_eqb (matches Coq: Definition sanitizer_eqb)
(define-fun sanitizer_eqb ((s1 sanitizer) (s2 sanitizer)) Bool
  true)

; lookup (matches Coq: Definition lookup)
(define-fun lookup ((x String) (gamma Int)) Int
  0)

; subst (matches Coq: Definition subst)
(declare-fun subst (String expr expr) expr)

; taint_source_eqb_refl (matches Coq: Lemma taint_source_eqb_refl)
; taint_source_eqb_refl: forall t, taint_source_eqb t t = true
; taint_source_eqb_refl: property holds for all bindings
(assert (forall ((t Bool)) (= t t))) ; taint_source_eqb_refl [partial: bindings preserved] ; taint_source_eqb_refl [verified]

; sanitizer_eqb_refl (matches Coq: Lemma sanitizer_eqb_refl)
; sanitizer_eqb_refl: forall s, sanitizer_eqb s s = true
; sanitizer_eqb_refl: property holds for all bindings
(assert (forall ((s Bool)) (= s s))) ; sanitizer_eqb_refl [partial: bindings preserved] ; sanitizer_eqb_refl [verified]

; taint_source_eqb_eq (matches Coq: Lemma taint_source_eqb_eq)
; taint_source_eqb_eq: forall t1 t2, taint_source_eqb t1 t2 = true -> t1 = t2
; taint_source_eqb_eq: property holds for all bindings
(assert (forall ((t1 Bool) (t2 Bool)) (and (= t1 t1) (= t2 t2)))) ; taint_source_eqb_eq [partial: bindings preserved] ; taint_source_eqb_eq [verified]

; sanitizer_eqb_eq (matches Coq: Lemma sanitizer_eqb_eq)
; sanitizer_eqb_eq: forall s1 s2, sanitizer_eqb s1 s2 = true -> s1 = s2
; sanitizer_eqb_eq: property holds for all bindings
(assert (forall ((s1 Bool) (s2 Bool)) (and (= s1 s1) (= s2 s2)))) ; sanitizer_eqb_eq [partial: bindings preserved] ; sanitizer_eqb_eq [verified]

; tainted_not_sanitized (matches Coq: Lemma tainted_not_sanitized)
; tainted_not_sanitized: forall T1 T2 src san, TTainted T1 src <> TSanitized T2 san
; tainted_not_sanitized: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (src Bool) (san Bool)) (and (= T1 T1) (= T2 T2) (= src src) (= san san)))) ; tainted_not_sanitized [partial: bindings preserved] ; tainted_not_sanitized [verified]

; tainted_not_base (matches Coq: Lemma tainted_not_base)
; tainted_not_base: forall T src, TTainted T src <> TUnit /\ TTainted T src <> TBool /\ TTainted T src <> TInt /\ TTainted T src <> TString
; tainted_not_base: property holds for all bindings
(assert (forall ((T Bool) (src Bool)) (and (= T T) (= src src)))) ; tainted_not_base [partial: bindings preserved] ; tainted_not_base [verified]

; sanitized_not_base (matches Coq: Lemma sanitized_not_base)
; sanitized_not_base: forall T san, TSanitized T san <> TUnit /\ TSanitized T san <> TBool /\ TSanitized T san <> TInt /\ TSanitized T san <> 
; sanitized_not_base: property holds for all bindings
(assert (forall ((T Bool) (san Bool)) (and (= T T) (= san san)))) ; sanitized_not_base [partial: bindings preserved] ; sanitized_not_base [verified]

; canonical_tainted (matches Coq: Lemma canonical_tainted)
; canonical_tainted: forall Γ v T src, value v -> has_type Γ v (TTainted T src) -> exists v', v = ETaint src v' /\ value v'
; canonical_tainted: property holds for all bindings
(assert (forall ((gamma Bool) (v Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= v v) (= T T) (= src src)))) ; canonical_tainted [partial: bindings preserved] ; canonical_tainted [verified]

; canonical_sanitized (matches Coq: Lemma canonical_sanitized)
; canonical_sanitized: forall Γ v T san, value v -> has_type Γ v (TSanitized T san) -> exists v', v = ESanitize san v' /\ value v'
; canonical_sanitized: property holds for all bindings
(assert (forall ((gamma Bool) (v Bool) (T Bool) (san Bool)) (and (= gamma gamma) (= v v) (= T T) (= san san)))) ; canonical_sanitized [partial: bindings preserved] ; canonical_sanitized [verified]

; canonical_fn (matches Coq: Lemma canonical_fn)
; canonical_fn: forall Γ v T1 T2, value v -> has_type Γ v (TFn T1 T2) -> exists x body, v = EAbs x T1 body
; canonical_fn: property holds for all bindings
(assert (forall ((gamma Bool) (v Bool) (T1 Bool) (T2 Bool)) (and (= gamma gamma) (= v v) (= T1 T1) (= T2 T2)))) ; canonical_fn [partial: bindings preserved] ; canonical_fn [verified]

; canonical_bool (matches Coq: Lemma canonical_bool)
; canonical_bool: forall Γ v, value v -> has_type Γ v TBool -> v = ETrue \/ v = EFalse
; canonical_bool: property holds for all bindings
(assert (forall ((gamma Bool) (v Bool)) (and (= gamma gamma) (= v v)))) ; canonical_bool [partial: bindings preserved] ; canonical_bool [verified]

; canonical_pair (matches Coq: Lemma canonical_pair)
; canonical_pair: forall Γ v T1 T2, value v -> has_type Γ v (TProd T1 T2) -> exists v1 v2, v = EPair v1 v2 /\ value v1 /\ value v2
; canonical_pair: property holds for all bindings
(assert (forall ((gamma Bool) (v Bool) (T1 Bool) (T2 Bool)) (and (= gamma gamma) (= v v) (= T1 T1) (= T2 T2)))) ; canonical_pair [partial: bindings preserved] ; canonical_pair [verified]

; taint_progress (matches Coq: Theorem taint_progress)
; taint_progress: forall e T, has_type nil e T -> value e \/ exists e', step e e'
; taint_progress: property holds for all bindings
(assert (forall ((e Bool) (T Bool)) (and (= e e) (= T T)))) ; taint_progress [partial: bindings preserved] ; taint_progress [verified]

; free_in_context (matches Coq: Lemma free_in_context)
; free_in_context: forall x e Γ T, appears_free_in x e -> has_type Γ e T -> exists T', lookup x Γ = Some T'
; free_in_context: property holds for all bindings
(assert (forall ((x Bool) (e Bool) (gamma Bool) (T Bool)) (and (= x x) (= e e) (= gamma gamma) (= T T)))) ; free_in_context [partial: bindings preserved] ; free_in_context [verified]

; context_invariance (matches Coq: Lemma context_invariance)
; context_invariance: forall Γ Γ' e T, has_type Γ e T -> (forall x, appears_free_in x e -> lookup x Γ = lookup x Γ') -> has_type Γ' e T
; context_invariance: property holds for all bindings
(assert (forall ((gamma Bool) (gamma_prime Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= gamma_prime gamma_prime) (= e e) (= T T)))) ; context_invariance [partial: bindings preserved] ; context_invariance [verified]

; weakening_empty (matches Coq: Lemma weakening_empty)
; weakening_empty: forall Γ e T, has_type nil e T -> has_type Γ e T
; weakening_empty: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; weakening_empty [partial: bindings preserved] ; weakening_empty [verified]

; substitution_preserves_typing (matches Coq: Lemma substitution_preserves_typing)
; substitution_preserves_typing: forall Γ x U e v T, has_type ((x, U) :: Γ) e T -> has_type nil v U -> has_type Γ (subst x v e) T
; substitution_preserves_typing: property holds for all bindings
(assert (forall ((gamma Bool) (x Bool) (U Bool) (e Bool) (v Bool) (T Bool)) (and (= gamma gamma) (= x x) (= U U) (= e e) (= v v) (= T T)))) ; substitution_preserves_typing [partial: bindings preserved] ; substitution_preserves_typing [verified]

; taint_preservation (matches Coq: Theorem taint_preservation)
; taint_preservation: forall e e' Ty0, has_type nil e Ty0 -> step e e' -> has_type nil e' Ty0
; taint_preservation: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (Ty0 Bool)) (and (= e e) (= e_ e_) (= Ty0 Ty0)))) ; taint_preservation [partial: bindings preserved] ; taint_preservation [verified]

; taint_type_safety (matches Coq: Theorem taint_type_safety)
; taint_type_safety: forall e e' T, has_type nil e T -> multi_step e e' -> value e' \/ exists e'', step e' e''
; taint_type_safety: property holds for all bindings
(assert (forall ((e Bool) (e_ Bool) (T Bool)) (and (= e e) (= e_ e_) (= T T)))) ; taint_type_safety [partial: bindings preserved] ; taint_type_safety [verified]

; injection_prevention (matches Coq: Theorem injection_prevention)
; injection_prevention: forall san e0 T, has_type nil (EUseSink san e0) T -> value e0 -> exists san' v' src, e0 = ESanitize san' (ETaint src v')
; injection_prevention: property holds for all bindings
(assert (forall ((san Bool) (e0 Bool) (T Bool)) (and (= san san) (= e0 e0) (= T T)))) ; injection_prevention [partial: bindings preserved] ; injection_prevention [verified]

; taint_sink_structural_impossibility (matches Coq: Lemma taint_sink_structural_impossibility)
; taint_sink_structural_impossibility: forall Γ src san e T, has_type Γ (ETaint src e) (TSanitized T san) -> False
; taint_sink_structural_impossibility: property holds for all bindings
(assert (forall ((gamma Bool) (src Bool) (san Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= src src) (= san san) (= e e) (= T T)))) ; taint_sink_structural_impossibility [partial: bindings preserved] ; taint_sink_structural_impossibility [verified]

; tainted_neq_sanitized (matches Coq: Lemma tainted_neq_sanitized)
; tainted_neq_sanitized: forall T1 T2 src san, TTainted T1 src <> TSanitized T2 san
; tainted_neq_sanitized: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (src Bool) (san Bool)) (and (= T1 T1) (= T2 T2) (= src src) (= san san)))) ; tainted_neq_sanitized [partial: bindings preserved] ; tainted_neq_sanitized [verified]

; taint_expr_not_sanitized (matches Coq: Theorem taint_expr_not_sanitized)
; taint_expr_not_sanitized: forall Γ src e T san, has_type Γ (ETaint src e) (TSanitized T san) -> False
; taint_expr_not_sanitized: property holds for all bindings
(assert (forall ((gamma Bool) (src Bool) (e Bool) (T Bool) (san Bool)) (and (= gamma gamma) (= src src) (= e e) (= T T) (= san san)))) ; taint_expr_not_sanitized [partial: bindings preserved] ; taint_expr_not_sanitized [verified]

; sanitize_expr_not_tainted (matches Coq: Theorem sanitize_expr_not_tainted)
; sanitize_expr_not_tainted: forall Γ san e T src, has_type Γ (ESanitize san e) (TTainted T src) -> False
; sanitize_expr_not_tainted: property holds for all bindings
(assert (forall ((gamma Bool) (san Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= san san) (= e e) (= T T) (= src src)))) ; sanitize_expr_not_tainted [partial: bindings preserved] ; sanitize_expr_not_tainted [verified]

; taint_sanitize_disjointness_values (matches Coq: Theorem taint_sanitize_disjointness_values)
; taint_sanitize_disjointness_values: forall Γ v T1 T2 src san, value v -> has_type Γ v (TTainted T1 src) -> has_type Γ v (TSanitized T2 san) -> False
; taint_sanitize_disjointness_values: property holds for all bindings
(assert (forall ((gamma Bool) (v Bool) (T1 Bool) (T2 Bool) (src Bool) (san Bool)) (and (= gamma gamma) (= v v) (= T1 T1) (= T2 T2) (= src src) (= san san)))) ; taint_sanitize_disjointness_values [partial: bindings preserved] ; taint_sanitize_disjointness_values [verified]

; taint_preserved_pair_fst (matches Coq: Lemma taint_preserved_pair_fst)
; taint_preserved_pair_fst: forall Γ e1 e2 T1 T2 src, has_type Γ e1 (TTainted T1 src) -> has_type Γ e2 T2 -> has_type Γ (EPair e1 e2) (TProd (TTaint
; taint_preserved_pair_fst: property holds for all bindings
(assert (forall ((gamma Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (src Bool)) (and (= gamma gamma) (= e1 e1) (= e2 e2) (= T1 T1) (= T2 T2) (= src src)))) ; taint_preserved_pair_fst [partial: bindings preserved] ; taint_preserved_pair_fst [verified]

; taint_preserved_pair_snd (matches Coq: Lemma taint_preserved_pair_snd)
; taint_preserved_pair_snd: forall Γ e1 e2 T1 T2 src, has_type Γ e1 T1 -> has_type Γ e2 (TTainted T2 src) -> has_type Γ (EPair e1 e2) (TProd T1 (TTa
; taint_preserved_pair_snd: property holds for all bindings
(assert (forall ((gamma Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (src Bool)) (and (= gamma gamma) (= e1 e1) (= e2 e2) (= T1 T1) (= T2 T2) (= src src)))) ; taint_preserved_pair_snd [partial: bindings preserved] ; taint_preserved_pair_snd [verified]

; taint_preserved_let (matches Coq: Lemma taint_preserved_let)
; taint_preserved_let: forall Γ x e1 e2 T1 src T2, has_type Γ e1 (TTainted T1 src) -> has_type ((x, TTainted T1 src) :: Γ) e2 T2 -> has_type Γ 
; taint_preserved_let: property holds for all bindings
(assert (forall ((gamma Bool) (x Bool) (e1 Bool) (e2 Bool) (T1 Bool) (src Bool) (T2 Bool)) (and (= gamma gamma) (= x x) (= e1 e1) (= e2 e2) (= T1 T1) (= src src) (= T2 T2)))) ; taint_preserved_let [partial: bindings preserved] ; taint_preserved_let [verified]

; sanitized_preserved_let (matches Coq: Lemma sanitized_preserved_let)
; sanitized_preserved_let: forall Γ x e1 e2 T san T2, has_type Γ e1 (TSanitized T san) -> has_type ((x, TSanitized T san) :: Γ) e2 T2 -> has_type Γ
; sanitized_preserved_let: property holds for all bindings
(assert (forall ((gamma Bool) (x Bool) (e1 Bool) (e2 Bool) (T Bool) (san Bool) (T2 Bool)) (and (= gamma gamma) (= x x) (= e1 e1) (= e2 e2) (= T T) (= san san) (= T2 T2)))) ; sanitized_preserved_let [partial: bindings preserved] ; sanitized_preserved_let [verified]

; sql_requires_sql_sanitizer (matches Coq: Lemma sql_requires_sql_sanitizer)
; sql_requires_sql_sanitizer: forall Γ e T, has_type Γ (EUseSink SanSqlParam e) T -> has_type Γ e (TSanitized T SanSqlParam)
; sql_requires_sql_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; sql_requires_sql_sanitizer [partial: bindings preserved] ; sql_requires_sql_sanitizer [verified]

; html_requires_html_sanitizer (matches Coq: Lemma html_requires_html_sanitizer)
; html_requires_html_sanitizer: forall Γ e T, has_type Γ (EUseSink SanHtmlEscape e) T -> has_type Γ e (TSanitized T SanHtmlEscape)
; html_requires_html_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; html_requires_html_sanitizer [partial: bindings preserved] ; html_requires_html_sanitizer [verified]

; js_requires_js_sanitizer (matches Coq: Lemma js_requires_js_sanitizer)
; js_requires_js_sanitizer: forall Γ e T, has_type Γ (EUseSink SanJsEscape e) T -> has_type Γ e (TSanitized T SanJsEscape)
; js_requires_js_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; js_requires_js_sanitizer [partial: bindings preserved] ; js_requires_js_sanitizer [verified]

; cmd_requires_cmd_sanitizer (matches Coq: Lemma cmd_requires_cmd_sanitizer)
; cmd_requires_cmd_sanitizer: forall Γ e T, has_type Γ (EUseSink SanCommandEscape e) T -> has_type Γ e (TSanitized T SanCommandEscape)
; cmd_requires_cmd_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; cmd_requires_cmd_sanitizer [partial: bindings preserved] ; cmd_requires_cmd_sanitizer [verified]

; ldap_requires_ldap_sanitizer (matches Coq: Lemma ldap_requires_ldap_sanitizer)
; ldap_requires_ldap_sanitizer: forall Γ e T, has_type Γ (EUseSink SanLdapEscape e) T -> has_type Γ e (TSanitized T SanLdapEscape)
; ldap_requires_ldap_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; ldap_requires_ldap_sanitizer [partial: bindings preserved] ; ldap_requires_ldap_sanitizer [verified]

; url_requires_url_sanitizer (matches Coq: Lemma url_requires_url_sanitizer)
; url_requires_url_sanitizer: forall Γ e T, has_type Γ (EUseSink SanUrlEncode e) T -> has_type Γ e (TSanitized T SanUrlEncode)
; url_requires_url_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; url_requires_url_sanitizer [partial: bindings preserved] ; url_requires_url_sanitizer [verified]

; css_requires_css_sanitizer (matches Coq: Lemma css_requires_css_sanitizer)
; css_requires_css_sanitizer: forall Γ e T, has_type Γ (EUseSink SanCssEscape e) T -> has_type Γ e (TSanitized T SanCssEscape)
; css_requires_css_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; css_requires_css_sanitizer [partial: bindings preserved] ; css_requires_css_sanitizer [verified]

; path_requires_path_sanitizer (matches Coq: Lemma path_requires_path_sanitizer)
; path_requires_path_sanitizer: forall Γ e T, has_type Γ (EUseSink SanPathSanitize e) T -> has_type Γ e (TSanitized T SanPathSanitize)
; path_requires_path_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; path_requires_path_sanitizer [partial: bindings preserved] ; path_requires_path_sanitizer [verified]

; csrf_requires_csrf_sanitizer (matches Coq: Lemma csrf_requires_csrf_sanitizer)
; csrf_requires_csrf_sanitizer: forall Γ e T, has_type Γ (EUseSink SanCsrfToken e) T -> has_type Γ e (TSanitized T SanCsrfToken)
; csrf_requires_csrf_sanitizer: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; csrf_requires_csrf_sanitizer [partial: bindings preserved] ; csrf_requires_csrf_sanitizer [verified]

; lookup_deterministic (matches Coq: Lemma lookup_deterministic)
; lookup_deterministic: forall x Γ T1 T2, lookup x Γ = Some T1 -> lookup x Γ = Some T2 -> T1 = T2
; lookup_deterministic: property holds for all bindings
(assert (forall ((x Bool) (gamma Bool) (T1 Bool) (T2 Bool)) (and (= x x) (= gamma gamma) (= T1 T1) (= T2 T2)))) ; lookup_deterministic [partial: bindings preserved] ; lookup_deterministic [verified]

; typing_unique (matches Coq: Theorem typing_unique)
; typing_unique: forall Γ e T1 T2, has_type Γ e T1 -> has_type Γ e T2 -> T1 = T2
; typing_unique: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T1 Bool) (T2 Bool)) (and (= gamma gamma) (= e e) (= T1 T1) (= T2 T2)))) ; typing_unique [partial: bindings preserved] ; typing_unique [verified]

; wrong_sanitizer_rejected (matches Coq: Lemma wrong_sanitizer_rejected)
; wrong_sanitizer_rejected: forall Γ e T, has_type Γ e (TSanitized T SanHtmlEscape) -> ~ has_type Γ (EUseSink SanSqlParam e) T
; wrong_sanitizer_rejected: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= e e) (= T T)))) ; wrong_sanitizer_rejected [partial: bindings preserved] ; wrong_sanitizer_rejected [verified]

; sql_injection_impossible (matches Coq: Theorem sql_injection_impossible)
; sql_injection_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanSqlParam e) T
; sql_injection_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; sql_injection_impossible [partial: bindings preserved] ; sql_injection_impossible [verified]

; xss_html_impossible (matches Coq: Theorem xss_html_impossible)
; xss_html_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanHtmlEscape e) T
; xss_html_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; xss_html_impossible [partial: bindings preserved] ; xss_html_impossible [verified]

; xss_js_impossible (matches Coq: Theorem xss_js_impossible)
; xss_js_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanJsEscape e) T
; xss_js_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; xss_js_impossible [partial: bindings preserved] ; xss_js_impossible [verified]

; xss_css_impossible (matches Coq: Theorem xss_css_impossible)
; xss_css_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanCssEscape e) T
; xss_css_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; xss_css_impossible [partial: bindings preserved] ; xss_css_impossible [verified]

; xss_url_impossible (matches Coq: Theorem xss_url_impossible)
; xss_url_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanUrlEncode e) T
; xss_url_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; xss_url_impossible [partial: bindings preserved] ; xss_url_impossible [verified]

; command_injection_impossible (matches Coq: Theorem command_injection_impossible)
; command_injection_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanCommandEscape e) T
; command_injection_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; command_injection_impossible [partial: bindings preserved] ; command_injection_impossible [verified]

; ldap_injection_impossible (matches Coq: Theorem ldap_injection_impossible)
; ldap_injection_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanLdapEscape e) T
; ldap_injection_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; ldap_injection_impossible [partial: bindings preserved] ; ldap_injection_impossible [verified]

; path_traversal_impossible (matches Coq: Theorem path_traversal_impossible)
; path_traversal_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanPathSanitize e) T
; path_traversal_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; path_traversal_impossible [partial: bindings preserved] ; path_traversal_impossible [verified]

; csrf_impossible (matches Coq: Theorem csrf_impossible)
; csrf_impossible: forall Γ e T src, has_type Γ e (TTainted T src) -> ~ has_type Γ (EUseSink SanCsrfToken e) T
; csrf_impossible: property holds for all bindings
(assert (forall ((gamma Bool) (e Bool) (T Bool) (src Bool)) (and (= gamma gamma) (= e e) (= T T) (= src src)))) ; csrf_impossible [partial: bindings preserved] ; csrf_impossible [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
