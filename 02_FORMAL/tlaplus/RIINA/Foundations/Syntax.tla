---- MODULE Syntax ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/foundations/Syntax.v
\* Models the RIINA security lattice, effect system, and core AST.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* SECURITY LEVELS (matches Coq: Inductive security_level)
\* Lattice: LPublic ⊑ LInternal ⊑ LSession ⊑ LUser ⊑ LSystem ⊑ LSecret
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS LPublic, LInternal, LSession, LUser, LSystem, LSecret

SecurityLevelSet == {LPublic, LInternal, LSession, LUser, LSystem, LSecret}

\* sec_level_num (matches Coq: Definition sec_level_num)
sec_level_num(l) ==
  CASE l = LPublic   -> 0
    [] l = LInternal  -> 1
    [] l = LSession   -> 2
    [] l = LUser      -> 3
    [] l = LSystem    -> 4
    [] l = LSecret    -> 5

\* sec_leq (matches Coq: Definition sec_leq)
sec_leq(l1, l2) == sec_level_num(l1) <= sec_level_num(l2)

\* sec_leq_dec (matches Coq: Definition sec_leq_dec)
sec_leq_dec(l1, l2) == sec_level_num(l1) <= sec_level_num(l2)

\* sec_join — least upper bound (matches Coq: Definition sec_join)
sec_join(l1, l2) ==
  IF sec_level_num(l1) <= sec_level_num(l2) THEN l2 ELSE l1

\* sec_meet — greatest lower bound (matches Coq: Definition sec_meet)
sec_meet(l1, l2) ==
  IF sec_level_num(l1) <= sec_level_num(l2) THEN l1 ELSE l2

\* ═══════════════════════════════════════════════════════════════════════
\* EFFECTS (matches Coq: Inductive effect)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS EffPure, EffRead, EffWrite, EffFileSystem,
          EffNetwork, EffNetSecure,
          EffCrypto, EffRandom,
          EffSystem, EffTime, EffProcess,
          EffPanel, EffZirah, EffBenteng, EffSandi, EffMenara, EffGapura

EffectSet == {EffPure, EffRead, EffWrite, EffFileSystem,
              EffNetwork, EffNetSecure, EffCrypto, EffRandom,
              EffSystem, EffTime, EffProcess,
              EffPanel, EffZirah, EffBenteng, EffSandi, EffMenara, EffGapura}

\* effect_category (matches Coq: Inductive effect_category)
CONSTANTS CatPure, CatIO, CatNetwork, CatCrypto, CatSystem, CatProduct

EffectCategorySet == {CatPure, CatIO, CatNetwork, CatCrypto, CatSystem, CatProduct}

\* effect_level (matches Coq: Definition effect_level)
effect_level(e) ==
  CASE e = EffPure       -> 0
    [] e = EffRead        -> 1
    [] e = EffWrite       -> 2
    [] e = EffFileSystem  -> 3
    [] e = EffNetwork     -> 4
    [] e = EffNetSecure   -> 5
    [] e = EffCrypto      -> 6
    [] e = EffRandom      -> 7
    [] e = EffSystem      -> 8
    [] e = EffTime        -> 9
    [] e = EffProcess     -> 10
    [] e = EffPanel       -> 11
    [] e = EffZirah       -> 12
    [] e = EffBenteng     -> 13
    [] e = EffSandi       -> 14
    [] e = EffMenara      -> 15
    [] e = EffGapura      -> 16

\* effect_cat (matches Coq: Definition effect_cat)
effect_cat(e) ==
  CASE e = EffPure       -> CatPure
    [] e = EffRead        -> CatIO
    [] e = EffWrite       -> CatIO
    [] e = EffFileSystem  -> CatIO
    [] e = EffNetwork     -> CatNetwork
    [] e = EffNetSecure   -> CatNetwork
    [] e = EffCrypto      -> CatCrypto
    [] e = EffRandom      -> CatCrypto
    [] e = EffSystem      -> CatSystem
    [] e = EffTime        -> CatSystem
    [] e = EffProcess     -> CatSystem
    [] e = EffPanel       -> CatProduct
    [] e = EffZirah       -> CatProduct
    [] e = EffBenteng     -> CatProduct
    [] e = EffSandi       -> CatProduct
    [] e = EffMenara      -> CatProduct
    [] e = EffGapura      -> CatProduct

\* effect_join (matches Coq: Definition effect_join)
effect_join(e1, e2) ==
  IF effect_level(e1) < effect_level(e2) THEN e2 ELSE e1

\* ═══════════════════════════════════════════════════════════════════════
\* TAINT SOURCES (matches Coq: Inductive taint_source)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS TaintNetworkExternal, TaintNetworkInternal, TaintUserInput,
          TaintFileSystem, TaintDatabase, TaintEnvironment,
          TaintGapuraRequest, TaintZirahEvent, TaintZirahEndpoint,
          TaintBentengBiometric, TaintSandiSignature, TaintMenaraDevice

TaintSourceSet == {TaintNetworkExternal, TaintNetworkInternal, TaintUserInput,
                   TaintFileSystem, TaintDatabase, TaintEnvironment,
                   TaintGapuraRequest, TaintZirahEvent, TaintZirahEndpoint,
                   TaintBentengBiometric, TaintSandiSignature, TaintMenaraDevice}

\* taint_combine (matches Coq: Definition taint_combine)
taint_combine(t1, t2) ==
  IF t1 = TaintNetworkExternal THEN t1 ELSE t2

\* ═══════════════════════════════════════════════════════════════════════
\* TYPES AND EXPRESSIONS (matches Coq: Inductive ty, expr)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS TUnit, TBool, TInt, TString, TBytes, TFn, TProd, TSum, TList,
          TOption, TRef, TSecret, TLabeled, TTainted, TSanitized, TProof,
          TCapability, TCapabilityFull, TChan, TSecureChan, TConstantTime, TZeroizing

TypeSet == {TUnit, TBool, TInt, TString, TBytes, TFn, TProd, TSum, TList,
            TOption, TRef, TSecret, TLabeled, TTainted, TSanitized, TProof,
            TCapability, TCapabilityFull, TChan, TSecureChan, TConstantTime, TZeroizing}

CONSTANTS SessEnd, SessSend, SessRecv, SessSelect, SessBranch, SessRec, SessVar
SessionTypeSet == {SessEnd, SessSend, SessRecv, SessSelect, SessBranch, SessRec, SessVar}

CONSTANTS EUnit, EBool, EInt, EString, ELoc, EVar, ELam, EApp, EPair, EFst, ESnd,
          EInl, EInr, ECase, EIf, ELet, EPerform, EHandle, ERef, EDeref, EAssign,
          EClassify, EDeclassify, EProve, ERequire, EGrant

ExprFormSet == {EUnit, EBool, EInt, EString, ELoc, EVar, ELam, EApp, EPair, EFst, ESnd,
                EInl, EInr, ECase, EIf, ELet, EPerform, EHandle, ERef, EDeref, EAssign,
                EClassify, EDeclassify, EProve, ERequire, EGrant}

\* Value forms (matches Coq: Inductive is_value)
ValueForms == {EUnit, EBool, EInt, EString, ELoc, ELam, EPair, EInl, EInr, EClassify, EProve}

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Security lattice verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES level1, level2, result

vars == <<level1, level2, result>>

TypeOK ==
  /\ level1 \in SecurityLevelSet
  /\ level2 \in SecurityLevelSet
  /\ result \in SecurityLevelSet \cup {TRUE, FALSE}

Init ==
  /\ level1 \in SecurityLevelSet
  /\ level2 \in SecurityLevelSet
  /\ result = sec_join(level1, level2)

\* Step: pick new levels, compute join/meet
ComputeJoin ==
  /\ level1' \in SecurityLevelSet
  /\ level2' \in SecurityLevelSet
  /\ result' = sec_join(level1', level2')

ComputeMeet ==
  /\ level1' \in SecurityLevelSet
  /\ level2' \in SecurityLevelSet
  /\ result' = sec_meet(level1', level2')

CheckLeq ==
  /\ level1' \in SecurityLevelSet
  /\ level2' \in SecurityLevelSet
  /\ result' = sec_leq(level1', level2')

Next == ComputeJoin \/ ComputeMeet \/ CheckLeq

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Security lattice properties (matches Coq lemmas)
\* ═══════════════════════════════════════════════════════════════════════

\* sec_leq_refl: reflexivity of security ordering
THEOREM sec_leq_refl ==
  \A l \in SecurityLevelSet : sec_leq(l, l)

\* sec_leq_trans: transitivity of security ordering
THEOREM sec_leq_trans ==
  \A l1, l2, l3 \in SecurityLevelSet :
    sec_leq(l1, l2) /\ sec_leq(l2, l3) => sec_leq(l1, l3)

\* sec_leq_antisym: antisymmetry of security ordering
THEOREM sec_leq_antisym ==
  \A l1, l2 \in SecurityLevelSet :
    sec_leq(l1, l2) /\ sec_leq(l2, l1) => l1 = l2

\* sec_leq_total: total ordering
THEOREM sec_leq_total ==
  \A l1, l2 \in SecurityLevelSet :
    sec_leq(l1, l2) \/ sec_leq(l2, l1)

\* sec_leq_public_bottom: LPublic is bottom element
THEOREM sec_leq_public_bottom ==
  \A l \in SecurityLevelSet : sec_leq(LPublic, l)

\* sec_leq_secret_top: LSecret is top element
THEOREM sec_leq_secret_top ==
  \A l \in SecurityLevelSet : sec_leq(l, LSecret)

\* sec_leq_dec_correct: decidable ordering matches propositional
THEOREM sec_leq_dec_correct ==
  \A l1, l2 \in SecurityLevelSet :
    sec_leq_dec(l1, l2) <=> sec_leq(l1, l2)

\* sec_join_ub_l: join is upper bound (left)
THEOREM sec_join_ub_l ==
  \A l1, l2 \in SecurityLevelSet :
    sec_leq(l1, sec_join(l1, l2))

\* sec_join_ub_r: join is upper bound (right)
THEOREM sec_join_ub_r ==
  \A l1, l2 \in SecurityLevelSet :
    sec_leq(l2, sec_join(l1, l2))

\* sec_meet_lb_l: meet is lower bound (left)
THEOREM sec_meet_lb_l ==
  \A l1, l2 \in SecurityLevelSet :
    sec_leq(sec_meet(l1, l2), l1)

\* sec_meet_lb_r: meet is lower bound (right)
THEOREM sec_meet_lb_r ==
  \A l1, l2 \in SecurityLevelSet :
    sec_leq(sec_meet(l1, l2), l2)

\* sec_join_comm: join commutativity
THEOREM sec_join_comm ==
  \A l1, l2 \in SecurityLevelSet :
    sec_join(l1, l2) = sec_join(l2, l1)

\* sec_meet_comm: meet commutativity
THEOREM sec_meet_comm ==
  \A l1, l2 \in SecurityLevelSet :
    sec_meet(l1, l2) = sec_meet(l2, l1)

\* sec_join_idem: join idempotence
THEOREM sec_join_idem ==
  \A l \in SecurityLevelSet : sec_join(l, l) = l

\* sec_meet_idem: meet idempotence
THEOREM sec_meet_idem ==
  \A l \in SecurityLevelSet : sec_meet(l, l) = l

\* sec_join_assoc: join associativity
THEOREM sec_join_assoc ==
  \A l1, l2, l3 \in SecurityLevelSet :
    sec_join(l1, sec_join(l2, l3)) = sec_join(sec_join(l1, l2), l3)

\* sec_meet_assoc: meet associativity
THEOREM sec_meet_assoc ==
  \A l1, l2, l3 \in SecurityLevelSet :
    sec_meet(l1, sec_meet(l2, l3)) = sec_meet(sec_meet(l1, l2), l3)

\* sec_join_meet_absorb: join-meet absorption
THEOREM sec_join_meet_absorb ==
  \A l1, l2 \in SecurityLevelSet :
    sec_join(l1, sec_meet(l1, l2)) = l1

\* sec_meet_join_absorb: meet-join absorption
THEOREM sec_meet_join_absorb ==
  \A l1, l2 \in SecurityLevelSet :
    sec_meet(l1, sec_join(l1, l2)) = l1

\* sec_join_meet_distrib: join distributes over meet
THEOREM sec_join_meet_distrib ==
  \A l1, l2, l3 \in SecurityLevelSet :
    sec_join(l1, sec_meet(l2, l3)) = sec_meet(sec_join(l1, l2), sec_join(l1, l3))

\* sec_meet_join_distrib: meet distributes over join
THEOREM sec_meet_join_distrib ==
  \A l1, l2, l3 \in SecurityLevelSet :
    sec_meet(l1, sec_join(l2, l3)) = sec_join(sec_meet(l1, l2), sec_meet(l1, l3))

\* sec_join_lub: join is least upper bound
THEOREM sec_join_lub ==
  \A l1, l2, l3 \in SecurityLevelSet :
    sec_leq(l1, l3) /\ sec_leq(l2, l3) => sec_leq(sec_join(l1, l2), l3)

\* sec_meet_glb: meet is greatest lower bound
THEOREM sec_meet_glb ==
  \A l1, l2, l3 \in SecurityLevelSet :
    sec_leq(l3, l1) /\ sec_leq(l3, l2) => sec_leq(l3, sec_meet(l1, l2))

\* effect_join_pure_l: EffPure is left identity for effect_join
THEOREM effect_join_pure_l ==
  \A e \in EffectSet : effect_join(EffPure, e) = e

\* effect_join_pure_r: EffPure is right identity for effect_join
THEOREM effect_join_pure_r ==
  \A e \in EffectSet : effect_join(e, EffPure) = e

\* value_not_stuck: values have canonical forms
THEOREM value_not_stuck ==
  \A e \in ValueForms : e \in ExprFormSet

====
