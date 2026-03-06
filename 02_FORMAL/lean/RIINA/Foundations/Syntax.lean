-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA Syntax - Lean 4 Port

Hand-crafted port of 02_FORMAL/coq/foundations/Syntax.v.

## Core Definitions
- Basic types: ident, loc, security_level, effect
- Type system: ty, session_type
- Expressions: expr
- Value predicate: Value
- Substitution: substExpr
-/

namespace RIINA

-- Basic type aliases (matching Coq)
abbrev ident := String
abbrev loc := Nat

-- Security levels
inductive security_level where
  | lPublic : security_level
  | lInternal : security_level
  | lSession : security_level
  | lUser : security_level
  | lSystem : security_level
  | lSecret : security_level
  deriving DecidableEq, Repr, BEq

-- Effects
inductive effect where
  | effPure : effect
  | effRead : effect
  | effWrite : effect
  | effFileSystem : effect
  | effNetwork : effect
  | effNetSecure : effect
  | effCrypto : effect
  | effRandom : effect
  | effSystem : effect
  | effTime : effect
  | effProcess : effect
  | effPanel : effect
  | effZirah : effect
  | effBenteng : effect
  | effSandi : effect
  | effMenara : effect
  | effGapura : effect
  deriving DecidableEq, Repr, BEq

-- Effect categories
inductive effect_category where
  | catPure : effect_category
  | catIO : effect_category
  | catNetwork : effect_category
  | catCrypto : effect_category
  | catSystem : effect_category
  | catProduct : effect_category
  deriving DecidableEq, Repr

-- Taint sources
inductive taint_source where
  | taintNetworkExternal : taint_source
  | taintNetworkInternal : taint_source
  | taintUserInput : taint_source
  | taintFileSystem : taint_source
  | taintDatabase : taint_source
  | taintEnvironment : taint_source
  deriving DecidableEq, Repr

-- Sanitizers
inductive sanitizer where
  | sanHtmlEscape : sanitizer
  | sanUrlEncode : sanitizer
  | sanSqlParam : sanitizer
  deriving DecidableEq, Repr

-- Capability kinds
inductive capability_kind where
  | capFileRead : capability_kind
  | capFileWrite : capability_kind
  | capNetConnect : capability_kind
  | capNetListen : capability_kind
  | capSysRandom : capability_kind
  deriving DecidableEq, Repr

-- Capabilities
inductive capability where
  | capBasic : capability_kind → capability
  deriving DecidableEq, Repr

-- Types and session types (mutual)
mutual
inductive ty where
  | tUnit : ty
  | tBool : ty
  | tInt : ty
  | tString : ty
  | tFn : ty → ty → effect → ty
  | tProd : ty → ty → ty
  | tSum : ty → ty → ty
  | tRef : ty → security_level → ty
  | tSecret : ty → ty
  | tProof : ty → ty
  | tChan : session_type → ty

inductive session_type where
  | sessEnd : session_type
  | sessSend : ty → session_type → session_type
  | sessRecv : ty → session_type → session_type
end

-- BEq instances for mutual types (needed for pattern matching in subst, etc.)
mutual
def ty.beq : ty → ty → Bool
  | .tUnit, .tUnit => true
  | .tBool, .tBool => true
  | .tInt, .tInt => true
  | .tString, .tString => true
  | .tFn a1 b1 e1, .tFn a2 b2 e2 => ty.beq a1 a2 && ty.beq b1 b2 && e1 == e2
  | .tProd a1 b1, .tProd a2 b2 => ty.beq a1 a2 && ty.beq b1 b2
  | .tSum a1 b1, .tSum a2 b2 => ty.beq a1 a2 && ty.beq b1 b2
  | .tRef a1 l1, .tRef a2 l2 => ty.beq a1 a2 && l1 == l2
  | .tSecret a1, .tSecret a2 => ty.beq a1 a2
  | .tProof a1, .tProof a2 => ty.beq a1 a2
  | .tChan s1, .tChan s2 => session_type.beq s1 s2
  | _, _ => false

def session_type.beq : session_type → session_type → Bool
  | .sessEnd, .sessEnd => true
  | .sessSend t1 s1, .sessSend t2 s2 => ty.beq t1 t2 && session_type.beq s1 s2
  | .sessRecv t1 s1, .sessRecv t2 s2 => ty.beq t1 t2 && session_type.beq s1 s2
  | _, _ => false
end

instance : BEq ty := ⟨ty.beq⟩
instance : BEq session_type := ⟨session_type.beq⟩

-- Expressions
inductive expr where
  | eUnit : expr
  | eBool : Bool → expr
  | eInt : Nat → expr
  | eString : String → expr
  | eLoc : loc → expr
  | eVar : ident → expr
  | eLam : ident → ty → expr → expr
  | eApp : expr → expr → expr
  | ePair : expr → expr → expr
  | eFst : expr → expr
  | eSnd : expr → expr
  | eInl : expr → ty → expr
  | eInr : expr → ty → expr
  | eCase : expr → ident → expr → ident → expr → expr
  | eIf : expr → expr → expr → expr
  | eLet : ident → expr → expr → expr
  | ePerform : effect → expr → expr
  | eHandle : expr → ident → expr → expr
  | eRef : expr → security_level → expr
  | eDeref : expr → expr
  | eAssign : expr → expr → expr
  | eClassify : expr → expr
  | eDeclassify : expr → expr → expr
  | eProve : expr → expr
  | eRequire : effect → expr → expr
  | eGrant : effect → expr → expr
  deriving BEq

open security_level effect ty expr

-- Value predicate (matches Coq: Inductive value)
inductive Value : expr → Prop where
  | VUnit : Value .eUnit
  | VBool : (b : Bool) → Value (.eBool b)
  | VInt : (n : Nat) → Value (.eInt n)
  | VString : (s : String) → Value (.eString s)
  | VLoc : (l : loc) → Value (.eLoc l)
  | VLam : (x : ident) → (T : ty) → (e : expr) → Value (.eLam x T e)
  | VPair : {v1 v2 : expr} → Value v1 → Value v2 → Value (.ePair v1 v2)
  | VInl : {v : expr} → Value v → (T : ty) → Value (.eInl v T)
  | VInr : {v : expr} → Value v → (T : ty) → Value (.eInr v T)
  | VClassify : {v : expr} → Value v → Value (.eClassify v)
  | VProve : {v : expr} → Value v → Value (.eProve v)

-- Lowercase alias for compatibility with Coq-style code
abbrev value := Value

-- Security level numeric encoding
def sec_level_num : security_level → Nat
  | .lPublic => 0
  | .lInternal => 1
  | .lSession => 2
  | .lUser => 3
  | .lSystem => 4
  | .lSecret => 5

-- Security ordering
def sec_leq (l1 l2 : security_level) : Prop :=
  sec_level_num l1 ≤ sec_level_num l2

-- Effect level
def effect_level : effect → Nat
  | .effPure => 0
  | .effRead => 1
  | .effWrite => 2
  | .effFileSystem => 3
  | .effNetwork => 4
  | .effNetSecure => 5
  | .effCrypto => 6
  | .effRandom => 7
  | .effSystem => 8
  | .effTime => 9
  | .effProcess => 10
  | .effPanel => 11
  | .effZirah => 12
  | .effBenteng => 13
  | .effSandi => 14
  | .effMenara => 15
  | .effGapura => 16

-- Effect join (lattice join)
def eff_join (e1 e2 : effect) : effect :=
  if effect_level e1 < effect_level e2 then e2 else e1

-- Substitution (matches Coq: Definition subst)
def substExpr (x : ident) (v : expr) : expr → expr
  | .eUnit => .eUnit
  | .eBool b => .eBool b
  | .eInt n => .eInt n
  | .eString s => .eString s
  | .eLoc l => .eLoc l
  | .eVar y => if x == y then v else .eVar y
  | .eLam y T body => .eLam y T (if x == y then body else substExpr x v body)
  | .eApp e1 e2 => .eApp (substExpr x v e1) (substExpr x v e2)
  | .ePair e1 e2 => .ePair (substExpr x v e1) (substExpr x v e2)
  | .eFst e => .eFst (substExpr x v e)
  | .eSnd e => .eSnd (substExpr x v e)
  | .eInl e T => .eInl (substExpr x v e) T
  | .eInr e T => .eInr (substExpr x v e) T
  | .eCase e y1 e1 y2 e2 =>
      .eCase (substExpr x v e)
        y1 (if x == y1 then e1 else substExpr x v e1)
        y2 (if x == y2 then e2 else substExpr x v e2)
  | .eIf e1 e2 e3 => .eIf (substExpr x v e1) (substExpr x v e2) (substExpr x v e3)
  | .eLet y e1 e2 =>
      .eLet y (substExpr x v e1) (if x == y then e2 else substExpr x v e2)
  | .ePerform eff e => .ePerform eff (substExpr x v e)
  | .eHandle e y h =>
      .eHandle (substExpr x v e) y (if x == y then h else substExpr x v h)
  | .eRef e sl => .eRef (substExpr x v e) sl
  | .eDeref e => .eDeref (substExpr x v e)
  | .eAssign e1 e2 => .eAssign (substExpr x v e1) (substExpr x v e2)
  | .eClassify e => .eClassify (substExpr x v e)
  | .eDeclassify e1 e2 => .eDeclassify (substExpr x v e1) (substExpr x v e2)
  | .eProve e => .eProve (substExpr x v e)
  | .eRequire eff e => .eRequire eff (substExpr x v e)
  | .eGrant eff e => .eGrant eff (substExpr x v e)

-- Notation for substitution
notation "[" x " := " v "]" e => substExpr x v e

-- Declassification predicate (matches Coq)
def declass_ok (e1 e2 : expr) : Prop :=
  ∃ v, Value v ∧ e1 = .eClassify v ∧ e2 = .eProve (.eClassify v)

-- Lookup in a list of pairs
def lookup (x : ident) : List (ident × ty) → Option ty
  | [] => none
  | (y, T) :: rest => if x == y then some T else lookup x rest

end RIINA
