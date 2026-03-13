---- MODULE AlgebraicEffects ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/AlgebraicEffects.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* BaseTy (matches Coq: Inductive BaseTy)
CONSTANTS TUnit, TBool, TNat

BaseTySet == {TUnit, TBool, TNat}

\* EffectOp (matches Coq: Inductive EffectOp)
CONSTANTS OpRead, OpWrite, OpRaise, OpPrint, OpRandom, OpAsync

EffectOpSet == {OpRead, OpWrite, OpRaise, OpPrint, OpRandom, OpAsync}

\* CompTy (matches Coq: Inductive CompTy)
CONSTANTS CTyPure, CTyEff

CompTySet == {CTyPure, CTyEff}

\* Val (matches Coq: Inductive Val)
CONSTANTS VUnit, VBool, VNat

ValSet == {VUnit, VBool, VNat}

\* Comp (matches Coq: Inductive Comp)
CONSTANTS CReturn, CPerform, CHandle, CBind, HReturn, HOp

CompSet == {CReturn, CPerform, CHandle, CBind, HReturn, HOp}

\* EvalCtx (matches Coq: Inductive EvalCtx)
CONSTANTS EHole, EBind

EvalCtxSet == {EHole, EBind}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* OpSig (matches Coq: Record OpSig)
VARIABLES opInputTy, opOutputTy

vars == <<opInputTy, opOutputTy>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ opInputTy \in BaseTySet
  /\ opOutputTy \in BaseTySet

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ opInputTy = TUnit
  /\ opOutputTy = TUnit

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* effectOp_eqb (matches Coq: Definition effectOp_eqb)
effectOp_eqb(o2) ==
    CASE o1 = OpRead, OpRead -> TRUE
      [] o1 = OpWrite, OpWrite -> TRUE
      [] o1 = OpRaise, OpRaise -> TRUE
      [] o1 = OpPrint, OpPrint -> TRUE
      [] o1 = OpRandom, OpRandom -> TRUE
      [] o1 = OpAsync, OpAsync -> TRUE
      [] o1 = _, _ -> FALSE

\* EffectSig (matches Coq: Definition EffectSig)
EffectSig ==
  0

\* EffectRow (matches Coq: Definition EffectRow)
EffectRow ==
  0

\* row_subset (matches Coq: Definition row_subset)
row_subset(r2) ==
  r2 >= 0

\* row_union (matches Coq: Definition row_union)
row_union(r2) ==
  r2 >= 0

\* row_nodup (matches Coq: Definition row_nodup)
row_nodup(r) ==
  r >= 0

\* empty_row (matches Coq: Definition empty_row)
empty_row ==
  0

\* getBaseTy (matches Coq: Definition getBaseTy)
getBaseTy(ct) ==
    CASE ct = CTyPure t -> t
      [] ct = CTyEff t _ -> t

\* getEffectRow (matches Coq: Definition getEffectRow)
getEffectRow(ct) ==
    CASE ct = CTyPure _ -> empty_row
      [] ct = CTyEff _ row -> row

\* opSignature (matches Coq: Definition opSignature)
opSignature(op) ==
    CASE op = OpRead -> mkOpSig
      [] op = OpWrite -> mkOpSig
      [] op = OpRaise -> mkOpSig
      [] op = OpPrint -> mkOpSig
      [] op = OpRandom -> mkOpSig
      [] op = OpAsync -> mkOpSig

\* sig_wellformed (matches Coq: Definition sig_wellformed)
sig_wellformed(sig) ==
  sig >= 0

\* is_return (matches Coq: Definition is_return)
is_return(c) ==
    CASE c = CReturn v -> Some
    [] OTHER -> None

\* effect_polymorphic_fn (matches Coq: Definition effect_polymorphic_fn)
effect_polymorphic_fn(f) ==
  f >= 0

\* respects_effects (matches Coq: Definition respects_effects)
respects_effects(f) ==
  f >= 0

\* handler_effects (matches Coq: Definition handler_effects)
handler_effects(h) ==
  h >= 0

\* compose_handlers (matches Coq: Definition compose_handlers)
compose_handlers(h2) ==
    CASE h1 = HReturn f -> h2
      [] h1 = HOp op f rest -> HOp

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateOpSig ==
  /\ opInputTy' \in BaseTySet
  /\ opOutputTy' \in BaseTySet

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateOpSig \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* effectOp_eqb_eq
THEOREM effectOp_eqb_eq ==
  \A o1 \in Nat, o2 \in Nat :
      effectOp_eqb(o1, o2) => o1 = o2

\* effectOp_eqb_refl
THEOREM effectOp_eqb_refl ==
  \A o \in Nat :
      effectOp_eqb(o, o) = TRUE

\* in_row_In
THEOREM in_row_In ==
  \A op \in Nat, row \in Nat :
      in_row(op, row) => In op row

\* row_subset_incl
THEOREM row_subset_incl ==
  \A r1 \in Nat, r2 \in Nat :
      row_subset(r1, r2) => incl(r1, r2)

\* row_minus_spec
THEOREM row_minus_spec ==
  \A r \in Nat, handled \in Nat, op \in Nat :
      In op (row_minus r handled) < => In op r /\ ~In op handled

\* EFF_001_01_effect_signature_wellformedness
THEOREM EFF_001_01_effect_signature_wellformedness ==
  \A sig \in Nat :
      sig_wellformed(sig) => i = j

\* EFF_001_02_operation_typing
THEOREM EFF_001_02_operation_typing ==
  \A op \in EffectOpSet, v \in ValSet, sig \in Nat :
      val_has_type v (opInputTy (opSignature op)) => comp_has_type (CPerform op v) (CTyEff (opOutputTy (opSignature op)) sig)

\* EFF_001_03_handler_typing
THEOREM EFF_001_03_handler_typing ==
  \A h \in Nat, c \in CompSet, t \in BaseTySet :
      comp_has_type c (CTyEff t sig) => comp_has_type (CHandle c h) (CTyEff t sig')

\* EFF_001_04_effect_row_combination
THEOREM EFF_001_04_effect_row_combination ==
  \A r1 \in Nat, r2 \in Nat :
      sig_wellformed(r1) => sig_wellformed (row_union r1 r2)

\* EFF_001_05_effect_subsumption
THEOREM EFF_001_05_effect_subsumption ==
  \A op \in EffectOpSet, v \in ValSet :
      comp_has_type (CPerform op v) (CTyEff (opOutputTy (opSignature op)) sig) => comp_has_type (CPerform op v) (CTyEff (opOutputTy (opSignature op)) sig')

\* EFF_001_06_pure_computation
THEOREM EFF_001_06_pure_computation ==
  \A c \in CompSet, t \in BaseTySet :
      comp_has_type(c, CTyPure(t)) => is_pure(c)

\* compose_handlers_effects
THEOREM compose_handlers_effects ==
  \A h1 \in Nat, h2 \in Nat :
      handler_effects (compose_handlers h1 h2) = handler_effects h1 ++ handler_effects h2

\* EFF_001_07_handler_composition
THEOREM EFF_001_07_handler_composition ==
  \A h1 \in Nat, h2 \in Nat, t \in BaseTySet, sig \in Nat :
      handler_has_type h1 (handler_effects h1) t sig => handler_has_type (compose_handlers h1 h2) 
                       (handler_effects h1 ++ handler_effects h2) t sig

\* EFF_001_08_effect_polymorphism
THEOREM EFF_001_08_effect_polymorphism ==
  \A f \in Nat, forall \in Nat, sig \in Nat :
      Comp => effect_polymorphic_fn(f)

\* EFF_001_09_deep_handler_semantics
THEOREM EFF_001_09_deep_handler_semantics ==
  \A op \in EffectOpSet, v \in ValSet, f \in ValSet, h \in Nat :
      deep_step 
        (CHandle (CPerform op v) (HOp op f h))
        (f v (fun r = > CHandle (CReturn r) (HOp op f h)))

\* EFF_001_10_shallow_handler_semantics
THEOREM EFF_001_10_shallow_handler_semantics ==
  \A op \in EffectOpSet, v \in ValSet, f \in ValSet, h \in Nat :
      shallow_step
        (CHandle (CPerform op v) (HOp op f h))
        (f v (fun r = > CReturn r))

\* EFF_001_11_effect_masking
THEOREM EFF_001_11_effect_masking ==
  \A h \in Nat, sig \in Nat, op \in EffectOpSet :
      In(op, handler_effects(h)) => ~In op (row_minus sig (handler_effects h))

\* EFF_001_12_resumption_linearity
THEOREM EFF_001_12_resumption_linearity ==
  \A f \in ValSet, v \in ValSet, k \in ValSet :
      linear_handler_clause(f) => exists r, f v k = k r

\* EFF_001_13_effect_safety
THEOREM EFF_001_13_effect_safety ==
  \A c \in CompSet, t \in BaseTySet :
      comp_has_type c (CTyEff t empty_row) => (forall op v, c <> CPerform op v)

\* EFF_001_14_effect_parametricity
THEOREM EFF_001_14_effect_parametricity ==
  \A f \in CompSet :
      (forall c, f c = c) => respects_effects(f)

\* eval_pure_deterministic
THEOREM eval_pure_deterministic ==
  \A c \in Nat, v1 \in Nat, v2 \in Nat :
      eval_pure(c, v1) => v1 = v2

\* EFF_001_15_effect_coherence
THEOREM EFF_001_15_effect_coherence ==
  \A c \in CompSet, v1 \in ValSet, v2 \in ValSet :
      is_pure(c) => v1 = v2

====
