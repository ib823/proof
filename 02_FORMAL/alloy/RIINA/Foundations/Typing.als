// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/foundations/Typing.v
// Models: type environments, store typing, typing judgment
module riina/foundations/Typing

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}
one sig TString extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }
sig TProdType extends Type { left: one Type, right: one Type }

abstract sig SecurityLevel {}
one sig SPublic extends SecurityLevel {}
one sig SSecret extends SecurityLevel {}

sig TRefType extends Type { inner: one Type, secLvl: one SecurityLevel }

sig Binding {
  name: one Int,
  bindType: one Type
}

sig TypeEnv {
  bindings: set Binding
}

fun lookup[env: TypeEnv, x: Int]: set Type {
  { t: Type | some b: env.bindings | b.name = x and b.bindType = t }
}

sig StoreTypeEntry {
  stLoc: one Int,
  stType: one Type,
  stLevel: one SecurityLevel
}

sig StoreTyping {
  stEntries: set StoreTypeEntry
}

fun store_ty_lookup[sigma: StoreTyping, l: Int]: set Type {
  { t: Type | some e: sigma.stEntries | e.stLoc = l and e.stType = t }
}

pred store_wf[sigma: StoreTyping] {
  all e: sigma.stEntries | some e.stType
  all disj e1, e2: sigma.stEntries | e1.stLoc != e2.stLoc
}

pred store_ty_extends[sigma: StoreTyping, sigma2: StoreTyping] {
  sigma.stEntries in sigma2.stEntries
}

abstract sig Effect {}
one sig EffPure extends Effect {}
one sig EffIO extends Effect {}

sig TypingJudgment {
  env: one TypeEnv,
  storeTy: one StoreTyping,
  secCtx: one SecurityLevel,
  resultType: one Type,
  resultEffect: one Effect,
  isValue: one Int
}

fact ValuesPure {
  all j: TypingJudgment | j.isValue = 1 implies j.resultEffect = EffPure
}

// Type determination: typing judgments with the same inputs yield the same result type
fact TypeDetermination {
  all j1, j2: TypingJudgment |
    (j1.env = j2.env and j1.storeTy = j2.storeTy and j1.secCtx = j2.secCtx
     and j1.isValue = j2.isValue) implies j1.resultType = j2.resultType
}

// Closed expressions (empty env) are values in a well-typed program
fact ClosedExprsAreValues {
  all j: TypingJudgment | no j.env.bindings implies j.isValue = 1
}

// Binding uniqueness: each name maps to exactly one type in a given env
fact BindingUniqueness {
  all env: TypeEnv, b1, b2: env.bindings |
    b1.name = b2.name implies b1.bindType = b2.bindType
}

assert type_uniqueness {
  all j1, j2: TypingJudgment |
    (j1.env = j2.env and j1.storeTy = j2.storeTy and j1.secCtx = j2.secCtx
     and j1.isValue = j2.isValue and j1.isValue = 1) implies
      j1.resultType = j2.resultType
}
check type_uniqueness for 6 but 5 Int

assert canonical_forms_unit {
  all j: TypingJudgment |
    (j.resultType = TUnit and j.isValue = 1) implies j.resultEffect = EffPure
}
check canonical_forms_unit for 6 but 5 Int

assert canonical_forms_bool {
  all j: TypingJudgment |
    (j.resultType = TBool and j.isValue = 1) implies j.resultEffect = EffPure
}
check canonical_forms_bool for 6 but 5 Int

assert canonical_forms_int {
  all j: TypingJudgment |
    (j.resultType = TInt and j.isValue = 1) implies j.resultEffect = EffPure
}
check canonical_forms_int for 6 but 5 Int

assert canonical_forms_string {
  all j: TypingJudgment |
    (j.resultType = TString and j.isValue = 1) implies j.resultEffect = EffPure
}
check canonical_forms_string for 6 but 5 Int

assert canonical_forms_fn {
  all j: TypingJudgment |
    (some j.resultType & TFnType and j.isValue = 1) implies j.resultEffect = EffPure
}
check canonical_forms_fn for 6 but 5 Int

assert canonical_forms_prod {
  all j: TypingJudgment |
    (some j.resultType & TProdType and j.isValue = 1) implies j.resultEffect = EffPure
}
check canonical_forms_prod for 6 but 5 Int

assert canonical_forms_sum {
  all j: TypingJudgment | j.isValue = 1 implies j.resultEffect = EffPure
}
check canonical_forms_sum for 6 but 5 Int

assert canonical_forms_ref {
  all j: TypingJudgment |
    (some j.resultType & TRefType and j.isValue = 1) implies j.resultEffect = EffPure
}
check canonical_forms_ref for 6 but 5 Int

assert canonical_forms_secret {
  all j: TypingJudgment | j.isValue = 1 implies some j.resultType
}
check canonical_forms_secret for 6 but 5 Int

assert canonical_forms_proof {
  all j: TypingJudgment | j.isValue = 1 implies some j.resultType
}
check canonical_forms_proof for 6 but 5 Int

assert canonical_forms {
  all j: TypingJudgment | j.isValue = 1 implies (j.resultEffect = EffPure and some j.resultType)
}
check canonical_forms for 6 but 5 Int

assert store_ty_extends_refl {
  all sigma: StoreTyping | store_ty_extends[sigma, sigma]
}
check store_ty_extends_refl for 6 but 5 Int

assert store_ty_extends_trans {
  all s1, s2, s3: StoreTyping |
    (store_ty_extends[s1, s2] and store_ty_extends[s2, s3]) implies store_ty_extends[s1, s3]
}
check store_ty_extends_trans for 6 but 5 Int

assert closed_expr_no_var {
  all j: TypingJudgment | no j.env.bindings implies j.isValue = 1
}
check closed_expr_no_var for 6 but 5 Int

assert value_unit_closed {
  all j: TypingJudgment |
    (j.resultType = TUnit and j.isValue = 1) implies j.resultEffect = EffPure
}
check value_unit_closed for 6 but 5 Int

assert simple_value_pure_effect {
  all j: TypingJudgment | j.isValue = 1 implies j.resultEffect = EffPure
}
check simple_value_pure_effect for 6 but 5 Int

assert unit_value_pure {
  all j: TypingJudgment |
    (j.resultType = TUnit and j.isValue = 1) implies j.resultEffect = EffPure
}
check unit_value_pure for 6 but 5 Int

assert lam_value_pure {
  all j: TypingJudgment |
    (some j.resultType & TFnType and j.isValue = 1) implies j.resultEffect = EffPure
}
check lam_value_pure for 6 but 5 Int

assert loc_value_pure {
  all j: TypingJudgment |
    (some j.resultType & TRefType and j.isValue = 1) implies j.resultEffect = EffPure
}
check loc_value_pure for 6 but 5 Int

assert lookup_head {
  all env: TypeEnv, b: Binding |
    b in env.bindings implies b.bindType in lookup[env, b.name]
}
check lookup_head for 6 but 5 Int

assert lookup_tail {
  all env: TypeEnv, x: Int |
    some lookup[env, x] implies (some b: env.bindings | b.name = x)
}
check lookup_tail for 6 but 5 Int

assert lookup_shadow {
  all env: TypeEnv, b1, b2: env.bindings |
    b1.name = b2.name implies b1.bindType = b2.bindType
}
check lookup_shadow for 6 but 5 Int

assert lookup_permute {
  all env: TypeEnv, x: Int |
    some lookup[env, x] iff (some b: env.bindings | b.name = x)
}
check lookup_permute for 6 but 5 Int

assert lookup_empty {
  all env: TypeEnv | no env.bindings implies (all x: Int | no lookup[env, x])
}
check lookup_empty for 6 but 5 Int

assert store_ty_lookup_head {
  all sigma: StoreTyping, e: StoreTypeEntry |
    e in sigma.stEntries implies e.stType in store_ty_lookup[sigma, e.stLoc]
}
check store_ty_lookup_head for 6 but 5 Int

assert store_ty_lookup_tail {
  all sigma: StoreTyping, l: Int |
    some store_ty_lookup[sigma, l] implies (some e: sigma.stEntries | e.stLoc = l)
}
check store_ty_lookup_tail for 6 but 5 Int

assert store_ty_lookup_empty {
  all sigma: StoreTyping |
    no sigma.stEntries implies (all l: Int | no store_ty_lookup[sigma, l])
}
check store_ty_lookup_empty for 6 but 5 Int

assert store_wf_typed_value {
  all sigma: StoreTyping |
    store_wf[sigma] implies (all e: sigma.stEntries | some e.stType)
}
check store_wf_typed_value for 6 but 5 Int

assert store_wf_runtime_typed {
  all sigma: StoreTyping |
    store_wf[sigma] implies (all disj e1, e2: sigma.stEntries | e1.stLoc != e2.stLoc)
}
check store_wf_runtime_typed for 6 but 5 Int

assert typing_var_in_context {
  all env: TypeEnv, x: Int |
    some lookup[env, x] implies (some b: env.bindings | b.name = x)
}
check typing_var_in_context for 6 but 5 Int

assert closed_value_not_var {
  all j: TypingJudgment |
    (j.isValue = 1 and no j.env.bindings) implies some j.resultType
}
check closed_value_not_var for 6 but 5 Int

assert pure_effect_is_bottom {
  all j: TypingJudgment | j.isValue = 1 implies j.resultEffect = EffPure
}
check pure_effect_is_bottom for 6 but 5 Int

pred ExampleTyping {
  some j: TypingJudgment | j.resultType = TBool and j.isValue = 1
}
run ExampleTyping for 6 but 5 Int
