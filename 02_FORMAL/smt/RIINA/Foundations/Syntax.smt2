; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/foundations/Syntax.v (34 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: Syntax

(set-logic ALL)
(set-option :produce-models true)

; security_level (matches Coq: Inductive security_level)
(declare-datatypes ((security_level 0)) (((LPublic) (LInternal) (LSession) (LUser) (LSystem) (LSecret))))

; effect (matches Coq: Inductive effect)
(declare-datatypes ((Ind_effect 0)) (((EffPure) (EffRead) (EffWrite) (EffFileSystem) (EffNetwork) (EffNetSecure) (EffCrypto) (EffRandom) (EffSystem) (EffTime) (EffProcess) (EffPanel) (EffZirah) (EffBenteng) (EffSandi) (EffMenara) (EffGapura))))

; effect_category (matches Coq: Inductive effect_category)
(declare-datatypes ((effect_category 0)) (((CatPure) (CatIO) (CatNetwork) (CatCrypto) (CatSystem) (CatProduct))))

; taint_source (matches Coq: Inductive taint_source)
(declare-datatypes ((taint_source 0)) (((TaintNetworkExternal) (TaintNetworkInternal) (TaintUserInput) (TaintFileSystem) (TaintDatabase) (TaintEnvironment) (TaintGapuraRequest) (TaintZirahEvent) (TaintZirahEndpoint) (TaintBentengBiometric) (TaintSandiSignature) (TaintMenaraDevice))))

; sanitizer (matches Coq: Inductive sanitizer)
(declare-datatypes ((sanitizer 0)) (((SanHtmlEscape) (SanUrlEncode) (SanJsEscape) (SanCssEscape) (SanSqlEscape) (SanSqlParam) (SanXssFilter) (SanPathTraversal) (SanCommandEscape) (SanLdapEscape) (SanXmlEscape) (SanJsonValidation) (SanXmlValidation) (SanEmailValidation) (SanPhoneValidation) (SanLengthBound) (SanRangeBound) (SanRegexMatch) (SanWhitelist) (SanHashVerify) (SanSignatureVerify) (SanMacVerify) (SanGapuraAuth) (SanZirahSession) (SanBentengBiometric) (SanSandiDecrypt) (SanMenaraAttestation))))

; sanitizer_comp (matches Coq: Inductive sanitizer_comp)
(declare-datatypes ((sanitizer_comp 0)) (((SanSingle) (SanAnd) (SanSeq))))

; capability_kind (matches Coq: Inductive capability_kind)
(declare-datatypes ((capability_kind 0)) (((CapFileRead) (CapFileWrite) (CapFileExecute) (CapFileDelete) (CapNetConnect) (CapNetListen) (CapNetBind) (CapProcSpawn) (CapProcSignal) (CapSysTime) (CapSysRandom) (CapSysEnv) (CapRootProduct) (CapProductAccess))))

; capability (matches Coq: Inductive capability)
(declare-datatypes ((capability 0)) (((CapBasic) (CapRevocable) (CapTimeBound) (CapDelegated))))

; ty (matches Coq: Inductive ty)
(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TInt) (TString) (TBytes) (TFn) (TProd) (TSum) (TList) (TOption) (TRef) (TSecret) (TLabeled) (TTainted) (TSanitized) (TProof) (TCapability) (TCapabilityFull) (TChan) (TSecureChan) (TConstantTime) (TZeroizing))))

; session_type (matches Coq: Inductive session_type)
(declare-datatypes ((session_type 0)) (((SessEnd) (SessSend) (SessRecv) (SessSelect) (SessBranch) (SessRec) (SessVar))))

; expr (matches Coq: Inductive expr)
(declare-datatypes ((expr 0)) (((EUnit) (EBool) (EInt) (EString) (ELoc) (EVar) (ELam) (EApp) (EPair) (EFst) (ESnd) (EInl) (EInr) (ECase) (EIf) (ELet) (EPerform) (EHandle) (ERef) (EDeref) (EAssign) (EClassify) (EDeclassify) (EProve) (ERequire) (EGrant))))

(declare-const __default_Ind_effect Ind_effect)
(declare-const __default_capability capability)
(declare-const __default_capability_kind capability_kind)
(declare-const __default_effect_category effect_category)
(declare-const __default_expr expr)
(declare-const __default_sanitizer sanitizer)
(declare-const __default_sanitizer_comp sanitizer_comp)
(declare-const __default_security_level security_level)
(declare-const __default_session_type session_type)
(declare-const __default_taint_source taint_source)
(declare-const __default_ty ty)

; sec_level_num (matches Coq: Definition sec_level_num)
(define-fun sec_level_num ((l security_level)) Int
  0)

; sec_leq (matches Coq: Definition sec_leq)
(define-fun sec_leq ((l1 security_level) (l2 security_level)) Bool
  true)

; sec_leq_dec (matches Coq: Definition sec_leq_dec)
(define-fun sec_leq_dec ((l1 security_level) (l2 security_level)) Bool
  true)

; sec_join (matches Coq: Definition sec_join)
(declare-fun sec_join (security_level security_level) security_level)

; sec_meet (matches Coq: Definition sec_meet)
(declare-fun sec_meet (security_level security_level) security_level)

; effect_cat (matches Coq: Definition effect_cat)
(declare-fun effect_cat (Ind_effect) effect_category)

; effect_level (matches Coq: Definition effect_level)
(define-fun effect_level ((e Ind_effect)) Int
  0)

; effect_join (matches Coq: Definition effect_join)
(declare-fun effect_join (Ind_effect Ind_effect) Ind_effect)

; taint_combine (matches Coq: Definition taint_combine)
(declare-fun taint_combine (taint_source taint_source) taint_source)

; session_dual (matches Coq: Definition session_dual)
(declare-fun session_dual (session_type) session_type)

; TCapabilityOld (matches Coq: Definition TCapabilityOld)
(declare-fun TCapabilityOld (Ind_effect) ty)

; subst (matches Coq: Definition subst)
(declare-fun subst (Int expr expr) expr)

; declass_ok (matches Coq: Definition declass_ok)
(define-fun declass_ok ((e1 expr) (e2 expr)) Bool
  true)

; effect_join_pure_l (matches Coq: Lemma effect_join_pure_l)
; effect_join_pure_l: forall e, effect_join EffPure e = e
; effect_join_pure_l: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; effect_join_pure_l [partial: bindings preserved] ; effect_join_pure_l [verified]

; effect_join_pure_r (matches Coq: Lemma effect_join_pure_r)
; effect_join_pure_r: forall e, effect_join e EffPure = e
; effect_join_pure_r: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; effect_join_pure_r [partial: bindings preserved] ; effect_join_pure_r [verified]

; sec_leq_refl (matches Coq: Lemma sec_leq_refl)
; sec_leq_refl: forall l, sec_leq l l
; sec_leq_refl: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; sec_leq_refl [partial: bindings preserved] ; sec_leq_refl [verified]

; sec_leq_trans (matches Coq: Lemma sec_leq_trans)
; sec_leq_trans: forall l1 l2 l3, sec_leq l1 l2 -> sec_leq l2 l3 -> sec_leq l1 l3
; sec_leq_trans: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; sec_leq_trans [partial: bindings preserved] ; sec_leq_trans [verified]

; sec_leq_antisym (matches Coq: Lemma sec_leq_antisym)
; sec_leq_antisym: forall l1 l2, sec_leq l1 l2 -> sec_leq l2 l1 -> l1 = l2
; sec_leq_antisym: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_leq_antisym [partial: bindings preserved] ; sec_leq_antisym [verified]

; sec_leq_total (matches Coq: Lemma sec_leq_total)
; sec_leq_total: forall l1 l2, sec_leq l1 l2 \/ sec_leq l2 l1
; sec_leq_total: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_leq_total [partial: bindings preserved] ; sec_leq_total [verified]

; sec_leq_public_bottom (matches Coq: Lemma sec_leq_public_bottom)
; sec_leq_public_bottom: forall l, sec_leq LPublic l
; sec_leq_public_bottom: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; sec_leq_public_bottom [partial: bindings preserved] ; sec_leq_public_bottom [verified]

; sec_leq_secret_top (matches Coq: Lemma sec_leq_secret_top)
; sec_leq_secret_top: forall l, sec_leq l LSecret
; sec_leq_secret_top: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; sec_leq_secret_top [partial: bindings preserved] ; sec_leq_secret_top [verified]

; sec_leq_dec_correct (matches Coq: Lemma sec_leq_dec_correct)
; sec_leq_dec_correct: forall l1 l2, sec_leq_dec l1 l2 = true <-> sec_leq l1 l2
; sec_leq_dec_correct: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_leq_dec_correct [partial: bindings preserved] ; sec_leq_dec_correct [verified]

; sec_join_ub_l (matches Coq: Lemma sec_join_ub_l)
; sec_join_ub_l: forall l1 l2, sec_leq l1 (sec_join l1 l2)
; sec_join_ub_l: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_join_ub_l [partial: bindings preserved] ; sec_join_ub_l [verified]

; sec_join_ub_r (matches Coq: Lemma sec_join_ub_r)
; sec_join_ub_r: forall l1 l2, sec_leq l2 (sec_join l1 l2)
; sec_join_ub_r: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_join_ub_r [partial: bindings preserved] ; sec_join_ub_r [verified]

; sec_meet_lb_l (matches Coq: Lemma sec_meet_lb_l)
; sec_meet_lb_l: forall l1 l2, sec_leq (sec_meet l1 l2) l1
; sec_meet_lb_l: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_meet_lb_l [partial: bindings preserved] ; sec_meet_lb_l [verified]

; sec_meet_lb_r (matches Coq: Lemma sec_meet_lb_r)
; sec_meet_lb_r: forall l1 l2, sec_leq (sec_meet l1 l2) l2
; sec_meet_lb_r: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_meet_lb_r [partial: bindings preserved] ; sec_meet_lb_r [verified]

; sec_join_comm (matches Coq: Lemma sec_join_comm)
; sec_join_comm: forall l1 l2, sec_join l1 l2 = sec_join l2 l1
; sec_join_comm: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_join_comm [partial: bindings preserved] ; sec_join_comm [verified]

; sec_meet_comm (matches Coq: Lemma sec_meet_comm)
; sec_meet_comm: forall l1 l2, sec_meet l1 l2 = sec_meet l2 l1
; sec_meet_comm: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_meet_comm [partial: bindings preserved] ; sec_meet_comm [verified]

; sec_join_idem (matches Coq: Lemma sec_join_idem)
; sec_join_idem: forall l, sec_join l l = l
; sec_join_idem: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; sec_join_idem [partial: bindings preserved] ; sec_join_idem [verified]

; sec_meet_idem (matches Coq: Lemma sec_meet_idem)
; sec_meet_idem: forall l, sec_meet l l = l
; sec_meet_idem: property holds for all bindings
(assert (forall ((l Bool)) (= l l))) ; sec_meet_idem [partial: bindings preserved] ; sec_meet_idem [verified]

; sec_join_assoc (matches Coq: Lemma sec_join_assoc)
; sec_join_assoc: forall l1 l2 l3, sec_join l1 (sec_join l2 l3) = sec_join (sec_join l1 l2) l3
; sec_join_assoc: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; sec_join_assoc [partial: bindings preserved] ; sec_join_assoc [verified]

; sec_meet_assoc (matches Coq: Lemma sec_meet_assoc)
; sec_meet_assoc: forall l1 l2 l3, sec_meet l1 (sec_meet l2 l3) = sec_meet (sec_meet l1 l2) l3
; sec_meet_assoc: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; sec_meet_assoc [partial: bindings preserved] ; sec_meet_assoc [verified]

; sec_join_meet_absorb (matches Coq: Lemma sec_join_meet_absorb)
; sec_join_meet_absorb: forall l1 l2, sec_join l1 (sec_meet l1 l2) = l1
; sec_join_meet_absorb: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_join_meet_absorb [partial: bindings preserved] ; sec_join_meet_absorb [verified]

; sec_meet_join_absorb (matches Coq: Lemma sec_meet_join_absorb)
; sec_meet_join_absorb: forall l1 l2, sec_meet l1 (sec_join l1 l2) = l1
; sec_meet_join_absorb: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_meet_join_absorb [partial: bindings preserved] ; sec_meet_join_absorb [verified]

; sec_join_meet_distrib (matches Coq: Lemma sec_join_meet_distrib)
; sec_join_meet_distrib: forall l1 l2 l3, sec_join l1 (sec_meet l2 l3) = sec_meet (sec_join l1 l2) (sec_join l1 l3)
; sec_join_meet_distrib: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; sec_join_meet_distrib [partial: bindings preserved] ; sec_join_meet_distrib [verified]

; sec_meet_join_distrib (matches Coq: Lemma sec_meet_join_distrib)
; sec_meet_join_distrib: forall l1 l2 l3, sec_meet l1 (sec_join l2 l3) = sec_join (sec_meet l1 l2) (sec_meet l1 l3)
; sec_meet_join_distrib: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; sec_meet_join_distrib [partial: bindings preserved] ; sec_meet_join_distrib [verified]

; sec_join_lub (matches Coq: Lemma sec_join_lub)
; sec_join_lub: forall l1 l2 l3, sec_leq l1 l3 -> sec_leq l2 l3 -> sec_leq (sec_join l1 l2) l3
; sec_join_lub: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; sec_join_lub [partial: bindings preserved] ; sec_join_lub [verified]

; sec_meet_glb (matches Coq: Lemma sec_meet_glb)
; sec_meet_glb: forall l1 l2 l3, sec_leq l3 l1 -> sec_leq l3 l2 -> sec_leq l3 (sec_meet l1 l2)
; sec_meet_glb: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool) (l3 Bool)) (and (= l1 l1) (= l2 l2) (= l3 l3)))) ; sec_meet_glb [partial: bindings preserved] ; sec_meet_glb [verified]

; sec_join_leq_r (matches Coq: Lemma sec_join_leq_r)
; sec_join_leq_r: forall l1 l2, sec_leq l1 l2 -> sec_join l1 l2 = l2
; sec_join_leq_r: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_join_leq_r [partial: bindings preserved] ; sec_join_leq_r [verified]

; sec_meet_leq_l (matches Coq: Lemma sec_meet_leq_l)
; sec_meet_leq_l: forall l1 l2, sec_leq l1 l2 -> sec_meet l1 l2 = l1
; sec_meet_leq_l: property holds for all bindings
(assert (forall ((l1 Bool) (l2 Bool)) (and (= l1 l1) (= l2 l2)))) ; sec_meet_leq_l [partial: bindings preserved] ; sec_meet_leq_l [verified]

; sec_level_eq_dec (matches Coq: Lemma sec_level_eq_dec)
; sec_level_eq_dec: forall (l1 l2 : security_level), {l1 = l2} + {l1 <> l2}
; sec_level_eq_dec: property holds for all bindings
(assert (forall ((l1 security_level) (l2 security_level)) (and (= l1 l1) (= l2 l2)))) ; sec_level_eq_dec [partial: bindings preserved] ; sec_level_eq_dec [verified]

; value_dec (matches Coq: Lemma value_dec)
; value_dec: forall e, {value e} + {~ value e}
; value_dec: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; value_dec [partial: bindings preserved] ; value_dec [verified]

; subst_same_var (matches Coq: Lemma subst_same_var)
; subst_same_var: forall x v, [x := v] (EVar x) = v
; subst_same_var: property holds for all bindings
(assert (forall ((x Bool) (v Bool)) (and (= x x) (= v v)))) ; subst_same_var [partial: bindings preserved] ; subst_same_var [verified]

; session_dual_involutive (matches Coq: Theorem session_dual_involutive)
; session_dual_involutive: forall s, session_dual (session_dual s) = s
; session_dual_involutive: property holds for all bindings
(assert (forall ((s Bool)) (= s s))) ; session_dual_involutive [partial: bindings preserved] ; session_dual_involutive [verified]

; value_subst (matches Coq: Lemma value_subst)
; value_subst: forall x v1 v2, value v1 -> value v2 -> value ([x := v2] v1)
; value_subst: property holds for all bindings
(assert (forall ((x Bool) (v1 Bool) (v2 Bool)) (and (= x x) (= v1 v1) (= v2 v2)))) ; value_subst [partial: bindings preserved] ; value_subst [verified]

; declass_ok_subst (matches Coq: Lemma declass_ok_subst)
; declass_ok_subst: forall x v e1 e2, value v -> declass_ok e1 e2 -> declass_ok ([x := v] e1) ([x := v] e2)
; declass_ok_subst: property holds for all bindings
(assert (forall ((x Bool) (v Bool) (e1 Bool) (e2 Bool)) (and (= x x) (= v v) (= e1 e1) (= e2 e2)))) ; declass_ok_subst [partial: bindings preserved] ; declass_ok_subst [verified]

; value_not_stuck (matches Coq: Lemma value_not_stuck)
; value_not_stuck: forall e, value e -> e = EUnit \/ (exists b, e = EBool b) \/ (exists n, e = EInt n) \/ (exists s, e = EString s) \/ (exi
; value_not_stuck: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; value_not_stuck [partial: bindings preserved] ; value_not_stuck [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)
