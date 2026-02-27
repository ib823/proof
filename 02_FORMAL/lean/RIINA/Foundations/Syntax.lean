/-!
# RIINA Syntax - Lean 4 Port

Port of 02_FORMAL/coq/foundations/Syntax.v.

## Core Definitions
- security_level, effect, ty, expr
- Security lattice operations (join, meet, leq)
- Substitution and value predicates
-/

-- Copyright (c) 2026 The RIINA Authors. All rights reserved.

namespace RIINA

-- Type aliases matching Coq definitions
abbrev ident := String
abbrev loc := Nat

-- Coq compatibility shims for generated Lean ports.
notation "nil" => (List.nil)
notation "S" n => Nat.succ n
notation "Some" => Option.some
notation "None" => Option.none
notation "NoDup" => List.Nodup
prefix:40 "~" => Not
infix:50 " <> " => Ne
@[inline] def nth_error {α : Type} (xs : List α) (n : Nat) : Option α :=
  xs.get? n

@[inline] def filter {α : Type} (p : α → Bool) (xs : List α) : List α :=
  List.filter p xs

namespace Nat
@[inline] def leb : Nat → Nat → Bool := Nat.ble
@[inline] def ltb : Nat → Nat → Bool := Nat.blt
@[inline] def eqb : Nat → Nat → Bool := Nat.beq
end Nat

namespace Bool
@[inline] def eqb (a b : Bool) : Bool := decide (a = b)
end Bool

namespace String
@[inline] def eqb (a b : String) : Bool := (a == b)
end String

/-- security_level (matches Coq: Inductive security_level) -/
inductive security_level where
  | LPublic : security_level
  | LInternal : security_level
  | LSession : security_level
  | LUser : security_level
  | LSystem : security_level
  | LSecret : security_level
  deriving DecidableEq, Repr

/-- effect (matches Coq: Inductive effect) -/
inductive effect where
  | EffPure : effect
  | EffRead : effect
  | EffWrite : effect
  | EffFileSystem : effect
  | EffNetwork : effect
  | EffNetSecure : effect
  | EffCrypto : effect
  | EffRandom : effect
  | EffSystem : effect
  | EffTime : effect
  | EffProcess : effect
  | EffPanel : effect
  | EffZirah : effect
  | EffBenteng : effect
  | EffSandi : effect
  | EffMenara : effect
  | EffGapura : effect
  deriving DecidableEq, Repr

/-- effect_category (matches Coq: Inductive effect_category) -/
inductive effect_category where
  | CatPure : effect_category
  | CatIO : effect_category
  | CatNetwork : effect_category
  | CatCrypto : effect_category
  | CatSystem : effect_category
  | CatProduct : effect_category
  deriving DecidableEq, Repr

/-- taint_source (matches Coq: Inductive taint_source) -/
inductive taint_source where
  | TaintNetworkExternal : taint_source
  | TaintNetworkInternal : taint_source
  | TaintUserInput : taint_source
  | TaintFileSystem : taint_source
  | TaintDatabase : taint_source
  | TaintEnvironment : taint_source
  | TaintGapuraRequest : taint_source
  | TaintZirahEvent : taint_source
  | TaintZirahEndpoint : taint_source
  | TaintBentengBiometric : taint_source
  | TaintSandiSignature : taint_source
  | TaintMenaraDevice : taint_source
  deriving DecidableEq, Repr

/-- sanitizer (matches Coq: Inductive sanitizer) -/
inductive sanitizer where
  | SanHtmlEscape : sanitizer
  | SanUrlEncode : sanitizer
  | SanJsEscape : sanitizer
  | SanCssEscape : sanitizer
  | SanSqlEscape : sanitizer
  | SanSqlParam : sanitizer
  | SanXssFilter : sanitizer
  | SanPathTraversal : sanitizer
  | SanCommandEscape : sanitizer
  | SanLdapEscape : sanitizer
  | SanXmlEscape : sanitizer
  | SanJsonValidation : sanitizer
  | SanXmlValidation : sanitizer
  | SanEmailValidation : sanitizer
  | SanPhoneValidation : sanitizer
  | SanLengthBound : Nat → sanitizer
  | SanRangeBound : Nat → Nat → sanitizer
  | SanRegexMatch : String → sanitizer
  | SanWhitelist : List String → sanitizer
  | SanHashVerify : sanitizer
  | SanSignatureVerify : sanitizer
  | SanMacVerify : sanitizer
  | SanGapuraAuth : sanitizer
  | SanZirahSession : sanitizer
  | SanBentengBiometric : sanitizer
  | SanSandiDecrypt : sanitizer
  | SanMenaraAttestation : sanitizer
  deriving DecidableEq, Repr

/-- sanitizer_comp (matches Coq: Inductive sanitizer_comp) -/
inductive sanitizer_comp where
  | SanSingle : sanitizer → sanitizer_comp
  | SanAnd : sanitizer_comp → sanitizer_comp → sanitizer_comp
  | SanSeq : sanitizer_comp → sanitizer_comp → sanitizer_comp
  deriving DecidableEq, Repr

/-- capability_kind (matches Coq: Inductive capability_kind) -/
inductive capability_kind where
  | CapFileRead : capability_kind
  | CapFileWrite : capability_kind
  | CapFileExecute : capability_kind
  | CapFileDelete : capability_kind
  | CapNetConnect : capability_kind
  | CapNetListen : capability_kind
  | CapNetBind : capability_kind
  | CapProcSpawn : capability_kind
  | CapProcSignal : capability_kind
  | CapSysTime : capability_kind
  | CapSysRandom : capability_kind
  | CapSysEnv : capability_kind
  | CapRootProduct : capability_kind
  | CapProductAccess : capability_kind
  deriving DecidableEq, Repr

/-- capability (matches Coq: Inductive capability) -/
inductive capability where
  | CapBasic : capability_kind → capability
  | CapRevocable : capability → capability
  | CapTimeBound : capability → Nat → capability
  | CapDelegated : capability → ident → capability
  deriving DecidableEq, Repr

-- ty and session_type are mutually recursive (matches Coq)
mutual
  inductive ty where
    | TUnit : ty
    | TBool : ty
    | TInt : ty
    | TString : ty
    | TBytes : ty
    | TFn : ty → ty → effect → ty
    | TProd : ty → ty → ty
    | TSum : ty → ty → ty
    | TList : ty → ty
    | TOption : ty → ty
    | TRef : ty → security_level → ty
    | TSecret : ty → ty
    | TLabeled : ty → security_level → ty
    | TTainted : ty → taint_source → ty
    | TSanitized : ty → sanitizer → ty
    | TProof : ty → ty
    | TCapability : capability_kind → ty
    | TCapabilityFull : capability → ty
    | TChan : session_type → ty
    | TSecureChan : session_type → security_level → ty
    | TConstantTime : ty → ty
    | TZeroizing : ty → ty

  inductive session_type where
    | SessEnd : session_type
    | SessSend : ty → session_type → session_type
    | SessRecv : ty → session_type → session_type
    | SessSelect : session_type → session_type → session_type
    | SessBranch : session_type → session_type → session_type
    | SessRec : ident → session_type → session_type
    | SessVar : ident → session_type
end

/-- expr (matches Coq: Inductive expr) -/
inductive expr where
  | EUnit : expr
  | EBool : Bool → expr
  | EInt : Nat → expr
  | EString : String → expr
  | ELoc : loc → expr
  | EVar : ident → expr
  | ELam : ident → ty → expr → expr
  | EApp : expr → expr → expr
  | EPair : expr → expr → expr
  | EFst : expr → expr
  | ESnd : expr → expr
  | EInl : expr → ty → expr
  | EInr : expr → ty → expr
  | ECase : expr → ident → expr → ident → expr → expr
  | EIf : expr → expr → expr → expr
  | ELet : ident → expr → expr → expr
  | EPerform : effect → expr → expr
  | EHandle : expr → ident → expr → expr
  | ERef : expr → security_level → expr
  | EDeref : expr → expr
  | EAssign : expr → expr → expr
  | EClassify : expr → expr
  | EDeclassify : expr → expr → expr
  | EProve : expr → expr
  | ERequire : effect → expr → expr
  | EGrant : effect → expr → expr

-- Open inductive constructors for direct access
open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- Coq-era aliases preserved for transpiled files.
abbrev Public : security_level := LPublic
abbrev Internal : security_level := LInternal
abbrev Session : security_level := LSession
abbrev User : security_level := LUser
abbrev System : security_level := LSystem
abbrev Secret : security_level := LSecret

abbrev EffectPure : effect := EffPure
abbrev EffectRead : effect := EffRead
abbrev EffectWrite : effect := EffWrite
abbrev EffectFileSystem : effect := EffFileSystem
abbrev EffectNetwork : effect := EffNetwork
abbrev EffectCrypto : effect := EffCrypto

/-- value predicate (matches Coq: Inductive value : expr -> Prop) -/
inductive value : expr → Prop where
  | VUnit   : value EUnit
  | VBool   : ∀ b, value (EBool b)
  | VInt    : ∀ n, value (EInt n)
  | VString : ∀ s, value (EString s)
  | VLoc    : ∀ l, value (ELoc l)
  | VLam    : ∀ x T e, value (ELam x T e)
  | VPair   : ∀ v1 v2, value v1 → value v2 → value (EPair v1 v2)
  | VInl    : ∀ v T, value v → value (EInl v T)
  | VInr    : ∀ v T, value v → value (EInr v T)
  | VClassify : ∀ v, value v → value (EClassify v)
  | VProve  : ∀ v, value v → value (EProve v)

/-- sec_level_num (matches Coq) -/
def sec_level_num (l : security_level) : Nat :=
  match l with
  | LPublic => 0
  | LInternal => 1
  | LSession => 2
  | LUser => 3
  | LSystem => 4
  | LSecret => 5

/-- sec_leq (matches Coq) -/
def sec_leq (l1 l2 : security_level) : Prop :=
  sec_level_num l1 ≤ sec_level_num l2

/-- sec_leq_dec (matches Coq) -/
def sec_leq_dec (l1 l2 : security_level) : Bool :=
  Nat.ble (sec_level_num l1) (sec_level_num l2)

/-- sec_join (matches Coq) -/
def sec_join (l1 l2 : security_level) : security_level :=
  if Nat.ble (sec_level_num l1) (sec_level_num l2) then l2 else l1

/-- sec_meet (matches Coq) -/
def sec_meet (l1 l2 : security_level) : security_level :=
  if Nat.ble (sec_level_num l1) (sec_level_num l2) then l1 else l2

/-- effect_cat (matches Coq) -/
def effect_cat (e : effect) : effect_category :=
  match e with
  | EffPure => CatPure
  | EffRead | EffWrite | EffFileSystem => CatIO
  | EffNetwork | EffNetSecure => CatNetwork
  | EffCrypto | EffRandom => CatCrypto
  | EffSystem | EffTime | EffProcess => CatSystem
  | EffPanel | EffZirah | EffBenteng | EffSandi | EffMenara | EffGapura => CatProduct

/-- effect_level (matches Coq) -/
def effect_level (e : effect) : Nat :=
  match e with
  | EffPure => 0
  | EffRead => 1 | EffWrite => 2 | EffFileSystem => 3
  | EffNetwork => 4 | EffNetSecure => 5
  | EffCrypto => 6 | EffRandom => 7
  | EffSystem => 8 | EffTime => 9 | EffProcess => 10
  | EffPanel => 11 | EffZirah => 12 | EffBenteng => 13
  | EffSandi => 14 | EffMenara => 15 | EffGapura => 16

/-- effect_join (matches Coq) -/
def effect_join (e1 e2 : effect) : effect :=
  if Nat.blt (effect_level e1) (effect_level e2) then e2 else e1

/-- taint_combine (matches Coq) -/
def taint_combine (t1 t2 : taint_source) : taint_source :=
  match t1 with
  | TaintNetworkExternal => t1
  | _ => t2

/-- session_dual (matches Coq) -/
def session_dual : session_type → session_type
  | SessEnd => SessEnd
  | SessSend t s => SessRecv t (session_dual s)
  | SessRecv t s => SessSend t (session_dual s)
  | SessSelect s1 s2 => SessBranch (session_dual s1) (session_dual s2)
  | SessBranch s1 s2 => SessSelect (session_dual s1) (session_dual s2)
  | SessRec x s => SessRec x (session_dual s)
  | SessVar x => SessVar x

/-- TCapabilityOld (matches Coq) -/
def TCapabilityOld (e : effect) : ty :=
  match e with
  | EffPure => TCapability CapSysRandom
  | EffRead => TCapability CapFileRead
  | EffWrite => TCapability CapFileWrite
  | EffNetwork => TCapability CapNetConnect
  | _ => TCapability CapSysRandom

/-- subst (matches Coq: substitution [x := v] e) -/
def substExpr (x : ident) (v : expr) : expr → expr
  | EUnit => EUnit
  | EBool b => EBool b
  | EInt n => EInt n
  | EString s => EString s
  | ELoc l => ELoc l
  | EVar y => if x == y then v else EVar y
  | ELam y T body => if x == y then ELam y T body
      else ELam y T (substExpr x v body)
  | EApp e1 e2 => EApp (substExpr x v e1) (substExpr x v e2)
  | EPair e1 e2 => EPair (substExpr x v e1) (substExpr x v e2)
  | EFst e1 => EFst (substExpr x v e1)
  | ESnd e1 => ESnd (substExpr x v e1)
  | EInl e1 T => EInl (substExpr x v e1) T
  | EInr e1 T => EInr (substExpr x v e1) T
  | ECase e1 y1 e2 y2 e3 => ECase (substExpr x v e1)
            y1 (if x == y1 then e2 else substExpr x v e2)
            y2 (if x == y2 then e3 else substExpr x v e3)
  | EIf e1 e2 e3 => EIf (substExpr x v e1) (substExpr x v e2) (substExpr x v e3)
  | ELet y e1 e2 => ELet y (substExpr x v e1)
           (if x == y then e2 else substExpr x v e2)
  | EPerform eff e1 => EPerform eff (substExpr x v e1)
  | EHandle e1 y h => EHandle (substExpr x v e1) y
              (if x == y then h else substExpr x v h)
  | ERef e1 l => ERef (substExpr x v e1) l
  | EDeref e1 => EDeref (substExpr x v e1)
  | EAssign e1 e2 => EAssign (substExpr x v e1) (substExpr x v e2)
  | EClassify e1 => EClassify (substExpr x v e1)
  | EDeclassify e1 e2 => EDeclassify (substExpr x v e1) (substExpr x v e2)
  | EProve e1 => EProve (substExpr x v e1)
  | ERequire eff e1 => ERequire eff (substExpr x v e1)
  | EGrant eff e1 => EGrant eff (substExpr x v e1)

notation "[" x " := " v "] " e => substExpr x v e

/-- Coq-compatible free variable predicate used by transpiled proofs. -/
def free_in (x : ident) (e : expr) : Prop :=
  match e with
  | EUnit => False
  | EBool _ => False
  | EInt _ => False
  | EString _ => False
  | ELoc _ => False
  | EVar y => x = y
  | ELam y _ body => x <> y /\ free_in x body
  | EApp e1 e2 => free_in x e1 \/ free_in x e2
  | EPair e1 e2 => free_in x e1 \/ free_in x e2
  | EFst e0 => free_in x e0
  | ESnd e0 => free_in x e0
  | EInl e0 _ => free_in x e0
  | EInr e0 _ => free_in x e0
  | ECase e0 y1 e1 y2 e2 => free_in x e0 \/ (x <> y1 /\ free_in x e1) \/ (x <> y2 /\ free_in x e2)
  | EIf e1 e2 e3 => free_in x e1 \/ free_in x e2 \/ free_in x e3
  | ELet y e1 e2 => free_in x e1 \/ (x <> y /\ free_in x e2)
  | EPerform _ e0 => free_in x e0
  | EHandle e0 y h => free_in x e0 \/ (x <> y /\ free_in x h)
  | ERef e0 _ => free_in x e0
  | EDeref e0 => free_in x e0
  | EAssign e1 e2 => free_in x e1 \/ free_in x e2
  | EClassify e0 => free_in x e0
  | EDeclassify e1 e2 => free_in x e1 \/ free_in x e2
  | EProve e0 => free_in x e0
  | ERequire _ e0 => free_in x e0
  | EGrant _ e0 => free_in x e0

/-- Coq-compatible notion of closed expressions. -/
def closed_expr (e : expr) : Prop :=
  forall x, ~ free_in x e

/-- Reachability placeholder used by transpiled SN lemmas. -/
def expr_reaches (e1 e2 : expr) : Prop :=
  e1 = e2

/-- Substitution by environment mapping (Coq `subst_rho` compatibility). -/
def subst_rho (rho : ident → expr) : expr → expr
  | EVar x => rho x
  | EUnit => EUnit
  | EBool b => EBool b
  | EInt n => EInt n
  | EString s => EString s
  | ELam x T body =>
      ELam x T (subst_rho (fun y => if y = x then EVar y else rho y) body)
  | EApp e1 e2 => EApp (subst_rho rho e1) (subst_rho rho e2)
  | EPair e1 e2 => EPair (subst_rho rho e1) (subst_rho rho e2)
  | EFst e => EFst (subst_rho rho e)
  | ESnd e => ESnd (subst_rho rho e)
  | EInl e T => EInl (subst_rho rho e) T
  | EInr e T => EInr (subst_rho rho e) T
  | ECase e x1 e1 x2 e2 =>
      ECase (subst_rho rho e)
        x1 (subst_rho (fun y => if y = x1 then EVar y else rho y) e1)
        x2 (subst_rho (fun y => if y = x2 then EVar y else rho y) e2)
  | EIf e1 e2 e3 => EIf (subst_rho rho e1) (subst_rho rho e2) (subst_rho rho e3)
  | ELet x e1 e2 =>
      ELet x (subst_rho rho e1) (subst_rho (fun y => if y = x then EVar y else rho y) e2)
  | EPerform eff e => EPerform eff (subst_rho rho e)
  | EHandle e x h =>
      EHandle (subst_rho rho e) x (subst_rho (fun y => if y = x then EVar y else rho y) h)
  | ERef e sl => ERef (subst_rho rho e) sl
  | EDeref e => EDeref (subst_rho rho e)
  | EAssign e1 e2 => EAssign (subst_rho rho e1) (subst_rho rho e2)
  | ELoc l => ELoc l
  | EClassify e => EClassify (subst_rho rho e)
  | EDeclassify e1 e2 => EDeclassify (subst_rho rho e1) (subst_rho rho e2)
  | EProve e => EProve (subst_rho rho e)
  | ERequire eff e => ERequire eff (subst_rho rho e)
  | EGrant eff e => EGrant eff (subst_rho rho e)

/-- Shadow a variable in an environment substitution (used in lambda/let binding). -/
def rho_shadow (rho : ident → expr) (x : ident) : ident → expr :=
  fun y => if y = x then EVar y else rho y

/-- Extend an environment substitution with a new binding. -/
def rho_extend (rho : ident → expr) (x : ident) (v : expr) : ident → expr :=
  fun y => if y = x then v else rho y

/-- Single-binding environment substitution. -/
def rho_single (x : ident) (v : expr) : ident → expr :=
  fun y => if y = x then v else EVar y

/-- Identity environment substitution. -/
def rho_id : ident → expr :=
  fun y => EVar y

/-- Structural size of RIINA types (for well-founded inductions in ports). -/
def ty_size : ty → Nat
  | TUnit => 1
  | TBool => 1
  | TInt => 1
  | TString => 1
  | TBytes => 1
  | TFn t1 t2 _ => 1 + ty_size t1 + ty_size t2
  | TProd t1 t2 => 1 + ty_size t1 + ty_size t2
  | TSum t1 t2 => 1 + ty_size t1 + ty_size t2
  | TList t => 1 + ty_size t
  | TOption t => 1 + ty_size t
  | TRef t _ => 1 + ty_size t
  | TSecret t => 1 + ty_size t
  | TLabeled t _ => 1 + ty_size t
  | TTainted t _ => 1 + ty_size t
  | TSanitized t _ => 1 + ty_size t
  | TProof t => 1 + ty_size t
  | TCapability _ => 1
  | TCapabilityFull _ => 1
  | TChan _ => 1
  | TSecureChan _ _ => 1
  | TConstantTime t => 1 + ty_size t
  | TZeroizing t => 1 + ty_size t

/-- True iff a type is first-order (no function or channel values). -/
def first_order_type : ty → Bool
  | TFn _ _ _ => false
  | TChan _ => false
  | TSecureChan _ _ => false
  | TProd t1 t2 => first_order_type t1 && first_order_type t2
  | TSum t1 t2 => first_order_type t1 && first_order_type t2
  | TList t => first_order_type t
  | TOption t => first_order_type t
  | TRef t _ => first_order_type t
  | TSecret t => first_order_type t
  | TLabeled t _ => first_order_type t
  | TTainted t _ => first_order_type t
  | TSanitized t _ => first_order_type t
  | TProof t => first_order_type t
  | TConstantTime t => first_order_type t
  | TZeroizing t => first_order_type t
  | _ => true

/-- Maximum compound depth among first-order constructors. -/
def fo_compound_depth : ty → Nat
  | TProd t1 t2 => Nat.succ (Nat.max (fo_compound_depth t1) (fo_compound_depth t2))
  | TSum t1 t2 => Nat.succ (Nat.max (fo_compound_depth t1) (fo_compound_depth t2))
  | TList t => Nat.succ (fo_compound_depth t)
  | TOption t => Nat.succ (fo_compound_depth t)
  | TRef t _ => Nat.succ (fo_compound_depth t)
  | TSecret t => Nat.succ (fo_compound_depth t)
  | TLabeled t _ => Nat.succ (fo_compound_depth t)
  | TTainted t _ => Nat.succ (fo_compound_depth t)
  | TSanitized t _ => Nat.succ (fo_compound_depth t)
  | TProof t => Nat.succ (fo_compound_depth t)
  | TConstantTime t => Nat.succ (fo_compound_depth t)
  | TZeroizing t => Nat.succ (fo_compound_depth t)
  | _ => 0

/-- Conservative marker for first-order types with trivial relational structure. -/
def fo_type_has_trivial_rel : ty → Bool
  | TUnit => true
  | TCapability _ | TCapabilityFull _ => true
  | TSecret _ | TLabeled _ _ | TTainted _ _ | TSanitized _ _ | TProof _ => true
  | TList _ | TOption _ => true
  | _ => false

/-- First-order value relation used by transpiled logical-relation files. -/
def val_rel_at_type_fo : ty → expr → expr → Prop
  | TUnit, EUnit, EUnit => True
  | TBool, EBool b1, EBool b2 => b1 = b2
  | TInt, EInt n1, EInt n2 => n1 = n2
  | TString, EString s1, EString s2 => s1 = s2
  | TBytes, v1, v2 => v1 = v2
  | TRef _ _, ELoc l1, ELoc l2 => l1 = l2
  | TProd t1 t2, EPair a1 b1, EPair a2 b2 =>
      val_rel_at_type_fo t1 a1 a2 /\ val_rel_at_type_fo t2 b1 b2
  | TSum t1 t2, EInl a1 _, EInl a2 _ => val_rel_at_type_fo t1 a1 a2
  | TSum t1 t2, EInr b1 _, EInr b2 _ => val_rel_at_type_fo t2 b1 b2
  | TList _, _, _ => True
  | TOption _, _, _ => True
  | TSecret _, _, _ => True
  | TLabeled _ _, _, _ => True
  | TTainted _ _, _, _ => True
  | TSanitized _ _, _, _ => True
  | TProof _, _, _ => True
  | TCapability _, _, _ => True
  | TCapabilityFull _, _, _ => True
  | TConstantTime t, v1, v2 => val_rel_at_type_fo t v1 v2
  | TZeroizing t, v1, v2 => val_rel_at_type_fo t v1 v2
  | _, _, _ => False

/-- declass_ok (matches Coq) -/
def declass_ok (e1 e2 : expr) : Prop :=
  ∃ v, value v ∧ e1 = EClassify v ∧ e2 = EProve (EClassify v)

-- ============================================================================
-- Theorems (corresponding to Coq proofs)
-- ============================================================================

/-- effect_join_pure_l (matches Coq) -/
theorem effect_join_pure_l : ∀ e, effect_join EffPure e = e := by
  intro e; cases e <;> rfl

/-- effect_join_pure_r (matches Coq) -/
theorem effect_join_pure_r : ∀ e, effect_join e EffPure = e := by
  intro e; cases e <;> rfl

/-- sec_leq_refl (matches Coq) -/
theorem sec_leq_refl : ∀ l, sec_leq l l := by
  intro l; simp [sec_leq]

/-- sec_leq_trans (matches Coq) -/
theorem sec_leq_trans : ∀ l1 l2 l3, sec_leq l1 l2 → sec_leq l2 l3 → sec_leq l1 l3 := by
  intro l1 l2 l3 h1 h2; exact Nat.le_trans h1 h2

/-- sec_leq_antisym (matches Coq) -/
theorem sec_leq_antisym : ∀ l1 l2, sec_leq l1 l2 → sec_leq l2 l1 → l1 = l2 := by
  intro l1 l2; cases l1 <;> cases l2 <;> simp [sec_leq, sec_level_num] <;> intro h1 h2 <;> exact absurd (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt h1 (by decide)) h2) (by decide)

/-- sec_leq_total (matches Coq) -/
theorem sec_leq_total : ∀ l1 l2, sec_leq l1 l2 ∨ sec_leq l2 l1 := by
  intro l1 l2; simp [sec_leq]; exact Nat.le_total _ _

/-- sec_leq_public_bottom (matches Coq) -/
theorem sec_leq_public_bottom : ∀ l, sec_leq LPublic l := by
  intro l; simp [sec_leq, sec_level_num]

/-- sec_leq_secret_top (matches Coq) -/
theorem sec_leq_secret_top : ∀ l, sec_leq l LSecret := by
  intro l; cases l <;> simp [sec_leq, sec_level_num]

/-- sec_join_idem (matches Coq) -/
theorem sec_join_idem : ∀ l, sec_join l l = l := by
  intro l; cases l <;> rfl

/-- sec_meet_idem (matches Coq) -/
theorem sec_meet_idem : ∀ l, sec_meet l l = l := by
  intro l; cases l <;> rfl

/-- sec_join_assoc (matches Coq) -/
theorem sec_join_assoc : ∀ l1 l2 l3, sec_join l1 (sec_join l2 l3) = sec_join (sec_join l1 l2) l3 := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> rfl

/-- sec_meet_assoc (matches Coq) -/
theorem sec_meet_assoc : ∀ l1 l2 l3, sec_meet l1 (sec_meet l2 l3) = sec_meet (sec_meet l1 l2) l3 := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> rfl

/-- sec_join_comm (matches Coq) -/
theorem sec_join_comm : ∀ l1 l2, sec_join l1 l2 = sec_join l2 l1 := by
  intro l1 l2; cases l1 <;> cases l2 <;> rfl

/-- sec_meet_comm (matches Coq) -/
theorem sec_meet_comm : ∀ l1 l2, sec_meet l1 l2 = sec_meet l2 l1 := by
  intro l1 l2; cases l1 <;> cases l2 <;> rfl

/-- sec_join_meet_absorb (matches Coq) -/
theorem sec_join_meet_absorb : ∀ l1 l2, sec_join l1 (sec_meet l1 l2) = l1 := by
  intro l1 l2; cases l1 <;> cases l2 <;> rfl

/-- sec_meet_join_absorb (matches Coq) -/
theorem sec_meet_join_absorb : ∀ l1 l2, sec_meet l1 (sec_join l1 l2) = l1 := by
  intro l1 l2; cases l1 <;> cases l2 <;> rfl

/-- sec_join_meet_distrib (matches Coq) -/
theorem sec_join_meet_distrib : ∀ l1 l2 l3,
    sec_join l1 (sec_meet l2 l3) = sec_meet (sec_join l1 l2) (sec_join l1 l3) := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> rfl

/-- sec_meet_join_distrib (matches Coq) -/
theorem sec_meet_join_distrib : ∀ l1 l2 l3,
    sec_meet l1 (sec_join l2 l3) = sec_join (sec_meet l1 l2) (sec_meet l1 l3) := by
  intro l1 l2 l3; cases l1 <;> cases l2 <;> cases l3 <;> rfl

/-- session_dual_involutive (matches Coq) -/
theorem session_dual_involutive : ∀ s, session_dual (session_dual s) = s := by
  intro s
  match s with
  | SessEnd => rfl
  | SessSend t s' => simp [session_dual, session_dual_involutive s']
  | SessRecv t s' => simp [session_dual, session_dual_involutive s']
  | SessSelect s1 s2 => simp [session_dual, session_dual_involutive s1, session_dual_involutive s2]
  | SessBranch s1 s2 => simp [session_dual, session_dual_involutive s1, session_dual_involutive s2]
  | SessRec x s' => simp [session_dual, session_dual_involutive s']
  | SessVar _ => rfl

/-- value_not_stuck (matches Coq) -/
theorem value_not_stuck : ∀ e, value e →
    e = EUnit ∨ (∃ b, e = EBool b) ∨ (∃ n, e = EInt n) ∨ (∃ s, e = EString s) ∨
    (∃ x T body, e = ELam x T body) ∨ (∃ v1 v2, e = EPair v1 v2) ∨
    (∃ v T, e = EInl v T) ∨ (∃ v T, e = EInr v T) ∨
    (∃ l, e = ELoc l) ∨ (∃ v, e = EClassify v) ∨ (∃ v, e = EProve v) := by
  intro e h
  cases h with
  | VUnit => left; rfl
  | VBool b => right; left; exact ⟨b, rfl⟩
  | VInt n => right; right; left; exact ⟨n, rfl⟩
  | VString s => right; right; right; left; exact ⟨s, rfl⟩
  | VLam x T body => right; right; right; right; left; exact ⟨x, T, body, rfl⟩
  | VPair v1 v2 _ _ => right; right; right; right; right; left; exact ⟨v1, v2, rfl⟩
  | VInl v T _ => right; right; right; right; right; right; left; exact ⟨v, T, rfl⟩
  | VInr v T _ => right; right; right; right; right; right; right; left; exact ⟨v, T, rfl⟩
  | VLoc l => right; right; right; right; right; right; right; right; left; exact ⟨l, rfl⟩
  | VClassify v _ => right; right; right; right; right; right; right; right; right; left; exact ⟨v, rfl⟩
  | VProve v _ => right; right; right; right; right; right; right; right; right; right; exact ⟨v, rfl⟩

end RIINA
