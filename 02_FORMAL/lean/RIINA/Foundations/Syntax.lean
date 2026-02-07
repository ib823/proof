-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA Syntax - Lean 4 Port

Hand-corrected port of 02_FORMAL/coq/foundations/Syntax.v.
The transpiler-generated version had syntax errors; this is manually fixed
to establish Lean compilation baseline.

Generated initially by scripts/generate-multiprover.py, then hand-corrected.
-/

namespace RIINA

-- Identifiers and locations (matching Coq definitions)
abbrev ident := String
abbrev loc := Nat

/-- Security levels: LPublic ⊑ LInternal ⊑ LSession ⊑ LUser ⊑ LSystem ⊑ LSecret -/
inductive security_level where
  | lPublic    : security_level
  | lInternal  : security_level
  | lSession   : security_level
  | lUser      : security_level
  | lSystem    : security_level
  | lSecret    : security_level
  deriving DecidableEq, Repr

/-- Numeric encoding for security level ordering -/
def sec_level_num : security_level → Nat
  | .lPublic   => 0
  | .lInternal => 1
  | .lSession  => 2
  | .lUser     => 3
  | .lSystem   => 4
  | .lSecret   => 5

/-- Security level ordering: l1 ⊑ l2 -/
def sec_leq (l1 l2 : security_level) : Prop :=
  sec_level_num l1 ≤ sec_level_num l2

/-- Decidable security level ordering -/
def sec_leq_dec (l1 l2 : security_level) : Bool :=
  Nat.ble (sec_level_num l1) (sec_level_num l2)

/-- Security level join (least upper bound) -/
def sec_join (l1 l2 : security_level) : security_level :=
  if Nat.ble (sec_level_num l1) (sec_level_num l2) then l2 else l1

/-- Security level meet (greatest lower bound) -/
def sec_meet (l1 l2 : security_level) : security_level :=
  if Nat.ble (sec_level_num l1) (sec_level_num l2) then l1 else l2

/-- Effect labels tracking observable behaviors -/
inductive effect where
  | effPure       : effect
  | effRead       : effect
  | effWrite      : effect
  | effFileSystem  : effect
  | effNetwork    : effect
  | effNetSecure  : effect
  | effCrypto     : effect
  | effRandom     : effect
  | effSystem     : effect
  | effTime       : effect
  | effProcess    : effect
  | effPanel      : effect
  | effZirah      : effect
  | effBenteng    : effect
  | effSandi      : effect
  | effMenara     : effect
  | effGapura     : effect
  deriving DecidableEq, Repr

/-- Effect categories -/
inductive effect_category where
  | catPure    : effect_category
  | catIO      : effect_category
  | catNetwork : effect_category
  | catCrypto  : effect_category
  | catSystem  : effect_category
  | catProduct : effect_category
  deriving DecidableEq, Repr

/-- Effect level numeric encoding -/
def effect_level : effect → Nat
  | .effPure      => 0
  | .effRead      => 1
  | .effWrite     => 2
  | .effFileSystem => 3
  | .effNetwork   => 4
  | .effNetSecure => 5
  | .effCrypto    => 6
  | .effRandom    => 7
  | .effSystem    => 8
  | .effTime      => 9
  | .effProcess   => 10
  | .effPanel     => 11
  | .effZirah     => 12
  | .effBenteng   => 13
  | .effSandi     => 14
  | .effMenara    => 15
  | .effGapura    => 16

/-- Effect category classification -/
def effect_cat : effect → effect_category
  | .effPure      => .catPure
  | .effRead      => .catIO
  | .effWrite     => .catIO
  | .effFileSystem => .catIO
  | .effNetwork   => .catNetwork
  | .effNetSecure => .catNetwork
  | .effCrypto    => .catCrypto
  | .effRandom    => .catCrypto
  | .effSystem    => .catSystem
  | .effTime      => .catSystem
  | .effProcess   => .catSystem
  | .effPanel     => .catProduct
  | .effZirah     => .catProduct
  | .effBenteng   => .catProduct
  | .effSandi     => .catProduct
  | .effMenara    => .catProduct
  | .effGapura    => .catProduct

/-- Effect join (maximum by level) -/
def effect_join (e1 e2 : effect) : effect :=
  if Nat.ble (effect_level e1) (effect_level e2) then e2 else e1

/-- Taint sources for information flow tracking -/
inductive taint_source where
  | taintNetworkExternal  : taint_source
  | taintNetworkInternal  : taint_source
  | taintUserInput        : taint_source
  | taintFileSystem       : taint_source
  | taintDatabase         : taint_source
  | taintEnvironment      : taint_source
  | taintGapuraRequest    : taint_source
  | taintZirahEvent       : taint_source
  | taintZirahEndpoint    : taint_source
  | taintBentengBiometric : taint_source
  | taintSandiSignature   : taint_source
  | taintMenaraDevice     : taint_source
  deriving DecidableEq, Repr

/-- Sanitizer types -/
inductive sanitizer where
  | sanHtmlEscape       : sanitizer
  | sanUrlEncode        : sanitizer
  | sanJsEscape         : sanitizer
  | sanCssEscape        : sanitizer
  | sanSqlEscape        : sanitizer
  | sanSqlParam         : sanitizer
  | sanXssFilter        : sanitizer
  | sanPathTraversal    : sanitizer
  | sanCommandEscape    : sanitizer
  | sanLdapEscape       : sanitizer
  | sanXmlEscape        : sanitizer
  | sanJsonValidation   : sanitizer
  | sanXmlValidation    : sanitizer
  | sanEmailValidation  : sanitizer
  | sanPhoneValidation  : sanitizer
  | sanLengthBound      : Nat → sanitizer
  | sanRangeBound       : Nat → Nat → sanitizer
  | sanRegexMatch       : String → sanitizer
  | sanWhitelist        : List String → sanitizer
  | sanHashVerify       : sanitizer
  | sanSignatureVerify  : sanitizer
  | sanMacVerify        : sanitizer
  | sanGapuraAuth       : sanitizer
  | sanZirahSession     : sanitizer
  | sanBentengBiometric : sanitizer
  | sanSandiDecrypt     : sanitizer
  | sanMenaraAttestation: sanitizer

/-- Sanitizer composition -/
inductive sanitizer_comp where
  | sanSingle : sanitizer → sanitizer_comp
  | sanAnd    : sanitizer_comp → sanitizer_comp → sanitizer_comp
  | sanSeq    : sanitizer_comp → sanitizer_comp → sanitizer_comp

/-- Capability kinds -/
inductive capability_kind where
  | capFileRead      : capability_kind
  | capFileWrite     : capability_kind
  | capFileExecute   : capability_kind
  | capFileDelete    : capability_kind
  | capNetConnect    : capability_kind
  | capNetListen     : capability_kind
  | capNetBind       : capability_kind
  | capProcSpawn     : capability_kind
  | capProcSignal    : capability_kind
  | capSysTime       : capability_kind
  | capSysRandom     : capability_kind
  | capSysEnv        : capability_kind
  | capRootProduct   : capability_kind
  | capProductAccess : capability_kind
  deriving DecidableEq, Repr

/-- Capabilities with revocation and time-bounding -/
inductive capability where
  | capBasic     : capability_kind → capability
  | capRevocable : capability → capability
  | capTimeBound : capability → Nat → capability
  | capDelegated : capability → ident → capability

/-- Types
    Note: session_type is simplified to Nat index to avoid mutual induction
    inside a namespace (Lean 4 limitation). For full mutual induction,
    move to top-level scope.
-/
inductive ty where
  | tUnit         : ty
  | tBool         : ty
  | tInt          : ty
  | tString       : ty
  | tBytes        : ty
  | tFn           : ty → ty → effect → ty
  | tProd         : ty → ty → ty
  | tSum          : ty → ty → ty
  | tList         : ty → ty
  | tOption       : ty → ty
  | tRef          : ty → security_level → ty
  | tSecret       : ty → ty
  | tLabeled      : ty → security_level → ty
  | tTainted      : ty → taint_source → ty
  | tSanitized    : ty → sanitizer → ty
  | tProof        : ty → ty
  | tCapability   : capability_kind → ty
  | tCapabilityFull : capability → ty
  | tConstantTime : ty → ty
  | tZeroizing    : ty → ty

/-- Session types (non-mutual version for compilation) -/
inductive session_type where
  | sessEnd    : session_type
  | sessSend   : Nat → session_type → session_type  -- Nat encodes type index
  | sessRecv   : Nat → session_type → session_type
  | sessSelect : session_type → session_type → session_type
  | sessBranch  : session_type → session_type → session_type
  | sessRec    : ident → session_type → session_type
  | sessVar    : ident → session_type

/-- Expressions -/
inductive expr where
  | eUnit       : expr
  | eBool       : Bool → expr
  | eInt        : Nat → expr
  | eString     : String → expr
  | eLoc        : loc → expr
  | eVar        : ident → expr
  | eLam        : ident → ty → expr → expr
  | eApp        : expr → expr → expr
  | ePair       : expr → expr → expr
  | eFst        : expr → expr
  | eSnd        : expr → expr
  | eInl        : expr → ty → expr
  | eInr        : expr → ty → expr
  | eCase       : expr → ident → expr → ident → expr → expr
  | eIf         : expr → expr → expr → expr
  | eLet        : ident → expr → expr → expr
  | ePerform    : effect → expr → expr
  | eHandle     : expr → ident → expr → expr
  | eRef        : expr → security_level → expr
  | eDeref      : expr → expr
  | eAssign     : expr → expr → expr
  | eClassify   : expr → expr
  | eDeclassify : expr → expr → expr
  | eProve      : expr → expr
  | eRequire    : effect → expr → expr
  | eGrant      : effect → expr → expr

/-- Value predicate (matches Coq: is_value) -/
def is_value : expr → Bool
  | .eUnit       => true
  | .eBool _     => true
  | .eInt _      => true
  | .eString _   => true
  | .eLam _ _ _  => true
  | .ePair v1 v2 => is_value v1 && is_value v2
  | .eInl v _    => is_value v
  | .eInr v _    => is_value v
  | .eLoc _      => true
  | .eClassify v => is_value v
  | .eProve v    => is_value v
  | _            => false

-- Theorems (matching Coq proofs)

/-- Pure is left identity for effect join -/
theorem effect_join_pure_l (e : effect) : effect_join .effPure e = e := by
  simp [effect_join, effect_level, Nat.ble]

/-- Pure is right identity for effect join -/
theorem effect_join_pure_r (e : effect) : effect_join e .effPure = e := by
  cases e <;> simp [effect_join, effect_level, Nat.ble]

end RIINA
