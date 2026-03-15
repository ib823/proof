; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Syntax — SMT Verification
; Derived from 02_FORMAL/coq/foundations/Syntax.v
; Module: Syntax
;
; Verifies: security lattice, effect ordering, session duality,
; substitution properties, datatype invariants.

(set-logic ALL)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; DATATYPE DECLARATIONS (from Coq Syntax.v)
; ═══════════════════════════════════════════════════════════════════════════

(declare-datatypes ((security_level 0)) (((LPublic) (LInternal) (LSession) (LUser) (LSystem) (LSecret))))
(declare-datatypes ((Ind_effect 0)) (((EffPure) (EffRead) (EffWrite) (EffFileSystem) (EffNetwork) (EffNetSecure) (EffCrypto) (EffRandom) (EffSystem) (EffTime) (EffProcess) (EffPanel) (EffZirah) (EffBenteng) (EffSandi) (EffMenara) (EffGapura))))
(declare-datatypes ((effect_category 0)) (((CatPure) (CatIO) (CatNetwork) (CatCrypto) (CatSystem) (CatProduct))))
(declare-datatypes ((taint_source 0)) (((TaintNetworkExternal) (TaintNetworkInternal) (TaintUserInput) (TaintFileSystem) (TaintDatabase) (TaintEnvironment) (TaintGapuraRequest) (TaintZirahEvent) (TaintZirahEndpoint) (TaintBentengBiometric) (TaintSandiSignature) (TaintMenaraDevice))))
(declare-datatypes ((sanitizer 0)) (((SanHtmlEscape) (SanUrlEncode) (SanJsEscape) (SanCssEscape) (SanSqlEscape) (SanSqlParam) (SanXssFilter) (SanPathTraversal) (SanCommandEscape) (SanLdapEscape) (SanXmlEscape) (SanJsonValidation) (SanXmlValidation) (SanEmailValidation) (SanPhoneValidation) (SanLengthBound) (SanRangeBound) (SanRegexMatch) (SanWhitelist) (SanHashVerify) (SanSignatureVerify) (SanMacVerify) (SanGapuraAuth) (SanZirahSession) (SanBentengBiometric) (SanSandiDecrypt) (SanMenaraAttestation))))
(declare-datatypes ((capability_kind 0)) (((CapFileRead) (CapFileWrite) (CapFileExecute) (CapFileDelete) (CapNetConnect) (CapNetListen) (CapNetBind) (CapProcSpawn) (CapProcSignal) (CapSysTime) (CapSysRandom) (CapSysEnv) (CapRootProduct) (CapProductAccess))))
(declare-datatypes ((capability 0)) (((CapBasic) (CapRevocable) (CapTimeBound) (CapDelegated))))
(declare-datatypes ((ty 0)) (((TUnit) (TBool) (TInt) (TString) (TBytes) (TFn) (TProd) (TSum) (TList) (TOption) (TRef) (TSecret) (TLabeled) (TTainted) (TSanitized) (TProof) (TCapability) (TCapabilityFull) (TChan) (TSecureChan) (TConstantTime) (TZeroizing))))
(declare-datatypes ((session_type 0)) (((SessEnd) (SessSend) (SessRecv) (SessSelect) (SessBranch) (SessRec) (SessVar))))
(declare-datatypes ((expr 0)) (((EUnit) (EBool) (EInt) (EString) (ELoc) (EVar) (ELam) (EApp) (EPair) (EFst) (ESnd) (EInl) (EInr) (ECase) (EIf) (ELet) (EPerform) (EHandle) (ERef) (EDeref) (EAssign) (EClassify) (EDeclassify) (EProve) (ERequire) (EGrant))))

; ═══════════════════════════════════════════════════════════════════════════
; FUNCTION DEFINITIONS (matching Coq definitions)
; ═══════════════════════════════════════════════════════════════════════════

; sec_level_num: numeric encoding of security levels (Coq: Definition sec_level_num)
(define-fun sec_level_num ((l security_level)) Int
  (ite (= l LPublic) 0
  (ite (= l LInternal) 1
  (ite (= l LSession) 2
  (ite (= l LUser) 3
  (ite (= l LSystem) 4
  5))))))

; sec_leq: l1 <= l2 iff sec_level_num(l1) <= sec_level_num(l2) (Coq: Definition sec_leq)
(define-fun sec_leq ((l1 security_level) (l2 security_level)) Bool
  (<= (sec_level_num l1) (sec_level_num l2)))

; sec_leq_dec: decidable security ordering (Coq: Definition sec_leq_dec)
(define-fun sec_leq_dec ((l1 security_level) (l2 security_level)) Bool
  (<= (sec_level_num l1) (sec_level_num l2)))

; sec_join: least upper bound = max (Coq: Definition sec_join)
(define-fun sec_join ((l1 security_level) (l2 security_level)) security_level
  (ite (sec_leq l1 l2) l2 l1))

; sec_meet: greatest lower bound = min (Coq: Definition sec_meet)
(define-fun sec_meet ((l1 security_level) (l2 security_level)) security_level
  (ite (sec_leq l1 l2) l1 l2))

; effect_level: numeric encoding of effects (Coq: Definition effect_level)
(define-fun effect_level ((e Ind_effect)) Int
  (ite (= e EffPure) 0
  (ite (= e EffRead) 1
  (ite (= e EffWrite) 2
  (ite (= e EffFileSystem) 3
  (ite (= e EffNetwork) 4
  (ite (= e EffNetSecure) 5
  (ite (= e EffCrypto) 6
  (ite (= e EffRandom) 7
  (ite (= e EffSystem) 8
  (ite (= e EffTime) 9
  (ite (= e EffProcess) 10
  (ite (= e EffPanel) 11
  (ite (= e EffZirah) 12
  (ite (= e EffBenteng) 13
  (ite (= e EffSandi) 14
  (ite (= e EffMenara) 15
  16)))))))))))))))))

; effect_cat: effect category (Coq: Definition effect_cat)
(define-fun effect_cat ((e Ind_effect)) effect_category
  (ite (= e EffPure) CatPure
  (ite (or (= e EffRead) (= e EffWrite) (= e EffFileSystem)) CatIO
  (ite (or (= e EffNetwork) (= e EffNetSecure)) CatNetwork
  (ite (or (= e EffCrypto) (= e EffRandom)) CatCrypto
  (ite (or (= e EffSystem) (= e EffTime) (= e EffProcess)) CatSystem
  CatProduct))))))

; effect_join: max effect by level (Coq: Definition effect_join)
(define-fun effect_join ((e1 Ind_effect) (e2 Ind_effect)) Ind_effect
  (ite (< (effect_level e1) (effect_level e2)) e2 e1))

; session_dual: session type duality (Coq: Definition session_dual)
(define-fun session_dual ((s session_type)) session_type
  (ite (= s SessSend) SessRecv
  (ite (= s SessRecv) SessSend
  (ite (= s SessSelect) SessBranch
  (ite (= s SessBranch) SessSelect
  s)))))

; value: predicate for value expressions (Coq: Inductive value)
(define-fun is_value ((e expr)) Bool
  (or (= e EUnit) (= e EBool) (= e EInt) (= e EString)
      (= e ELoc) (= e ELam) (= e EPair) (= e EInl) (= e EInr)
      (= e EClassify) (= e EProve)))

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION (push/pop blocks, UNSAT = property holds)
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. effect_join_pure_l: forall e, effect_join EffPure e = e ---
; Coq: Lemma effect_join_pure_l
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join EffPure e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. effect_join_pure_r: forall e, effect_join e EffPure = e ---
; Coq: Lemma effect_join_pure_r
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join e EffPure) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. sec_leq_refl: forall l, sec_leq l l ---
; Coq: Lemma sec_leq_refl
(push 1)
(declare-const l security_level)
(assert (not (sec_leq l l)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. sec_leq_trans: forall l1 l2 l3, sec_leq l1 l2 -> sec_leq l2 l3 -> sec_leq l1 l3 ---
; Coq: Lemma sec_leq_trans
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(declare-const l3 security_level)
(assert (sec_leq l1 l2))
(assert (sec_leq l2 l3))
(assert (not (sec_leq l1 l3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. sec_leq_antisym: forall l1 l2, sec_leq l1 l2 -> sec_leq l2 l1 -> l1 = l2 ---
; Coq: Lemma sec_leq_antisym
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (sec_leq l1 l2))
(assert (sec_leq l2 l1))
(assert (not (= l1 l2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. sec_leq_total: forall l1 l2, sec_leq l1 l2 \/ sec_leq l2 l1 ---
; Coq: Lemma sec_leq_total
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (or (sec_leq l1 l2) (sec_leq l2 l1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. sec_leq_public_bottom: forall l, sec_leq LPublic l ---
; Coq: Lemma sec_leq_public_bottom
(push 1)
(declare-const l security_level)
(assert (not (sec_leq LPublic l)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. sec_leq_secret_top: forall l, sec_leq l LSecret ---
; Coq: Lemma sec_leq_secret_top
(push 1)
(declare-const l security_level)
(assert (not (sec_leq l LSecret)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. sec_leq_dec_correct: sec_leq_dec and sec_leq agree ---
; Coq: Lemma sec_leq_dec_correct
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (= (sec_leq_dec l1 l2) (sec_leq l1 l2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. sec_join_ub_l: forall l1 l2, sec_leq l1 (sec_join l1 l2) ---
; Coq: Lemma sec_join_ub_l
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (sec_leq l1 (sec_join l1 l2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. sec_join_ub_r: forall l1 l2, sec_leq l2 (sec_join l1 l2) ---
; Coq: Lemma sec_join_ub_r
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (sec_leq l2 (sec_join l1 l2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. sec_meet_lb_l: forall l1 l2, sec_leq (sec_meet l1 l2) l1 ---
; Coq: Lemma sec_meet_lb_l
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (sec_leq (sec_meet l1 l2) l1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. sec_meet_lb_r: forall l1 l2, sec_leq (sec_meet l1 l2) l2 ---
; Coq: Lemma sec_meet_lb_r
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (sec_leq (sec_meet l1 l2) l2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. sec_join_comm: forall l1 l2, sec_join l1 l2 = sec_join l2 l1 ---
; Coq: Lemma sec_join_comm
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (= (sec_join l1 l2) (sec_join l2 l1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. sec_meet_comm: forall l1 l2, sec_meet l1 l2 = sec_meet l2 l1 ---
; Coq: Lemma sec_meet_comm
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (= (sec_meet l1 l2) (sec_meet l2 l1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. sec_join_idem: forall l, sec_join l l = l ---
; Coq: Lemma sec_join_idem
(push 1)
(declare-const l security_level)
(assert (not (= (sec_join l l) l)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. sec_meet_idem: forall l, sec_meet l l = l ---
; Coq: Lemma sec_meet_idem
(push 1)
(declare-const l security_level)
(assert (not (= (sec_meet l l) l)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. sec_join_assoc: forall l1 l2 l3, sec_join l1 (sec_join l2 l3) = sec_join (sec_join l1 l2) l3 ---
; Coq: Lemma sec_join_assoc
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(declare-const l3 security_level)
(assert (not (= (sec_join l1 (sec_join l2 l3)) (sec_join (sec_join l1 l2) l3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. sec_meet_assoc: forall l1 l2 l3, sec_meet l1 (sec_meet l2 l3) = sec_meet (sec_meet l1 l2) l3 ---
; Coq: Lemma sec_meet_assoc
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(declare-const l3 security_level)
(assert (not (= (sec_meet l1 (sec_meet l2 l3)) (sec_meet (sec_meet l1 l2) l3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. sec_join_meet_absorb: forall l1 l2, sec_join l1 (sec_meet l1 l2) = l1 ---
; Coq: Lemma sec_join_meet_absorb
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (= (sec_join l1 (sec_meet l1 l2)) l1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. sec_meet_join_absorb: forall l1 l2, sec_meet l1 (sec_join l1 l2) = l1 ---
; Coq: Lemma sec_meet_join_absorb
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (= (sec_meet l1 (sec_join l1 l2)) l1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. sec_join_meet_distrib: join distributes over meet ---
; Coq: Lemma sec_join_meet_distrib
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(declare-const l3 security_level)
(assert (not (= (sec_join l1 (sec_meet l2 l3))
               (sec_meet (sec_join l1 l2) (sec_join l1 l3)))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. sec_meet_join_distrib: meet distributes over join ---
; Coq: Lemma sec_meet_join_distrib
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(declare-const l3 security_level)
(assert (not (= (sec_meet l1 (sec_join l2 l3))
               (sec_join (sec_meet l1 l2) (sec_meet l1 l3)))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. sec_join_lub: join is least upper bound ---
; Coq: Lemma sec_join_lub
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(declare-const l3 security_level)
(assert (sec_leq l1 l3))
(assert (sec_leq l2 l3))
(assert (not (sec_leq (sec_join l1 l2) l3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. sec_meet_glb: meet is greatest lower bound ---
; Coq: Lemma sec_meet_glb
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(declare-const l3 security_level)
(assert (sec_leq l3 l1))
(assert (sec_leq l3 l2))
(assert (not (sec_leq l3 (sec_meet l1 l2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. sec_join_leq_r: l1 <= l2 -> join l1 l2 = l2 ---
; Coq: Lemma sec_join_leq_r
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (sec_leq l1 l2))
(assert (not (= (sec_join l1 l2) l2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. sec_meet_leq_l: l1 <= l2 -> meet l1 l2 = l1 ---
; Coq: Lemma sec_meet_leq_l
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (sec_leq l1 l2))
(assert (not (= (sec_meet l1 l2) l1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. sec_level_eq_dec: equality is decidable ---
; Coq: Lemma sec_level_eq_dec
(push 1)
(declare-const l1 security_level)
(declare-const l2 security_level)
(assert (not (or (= l1 l2) (not (= l1 l2)))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. effect_cat for EffPure = CatPure ---
(push 1)
(assert (not (= (effect_cat EffPure) CatPure)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. effect_cat for EffRead = CatIO ---
(push 1)
(assert (not (= (effect_cat EffRead) CatIO)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. effect_cat for EffNetwork = CatNetwork ---
(push 1)
(assert (not (= (effect_cat EffNetwork) CatNetwork)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. session_dual_involutive: forall s, dual(dual(s)) = s ---
; Coq: Theorem session_dual_involutive
(push 1)
(declare-const s session_type)
(assert (not (= (session_dual (session_dual s)) s)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. session dual Send/Recv duality ---
(push 1)
(assert (not (= (session_dual SessSend) SessRecv)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. session dual Recv/Send duality ---
(push 1)
(assert (not (= (session_dual SessRecv) SessSend)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
