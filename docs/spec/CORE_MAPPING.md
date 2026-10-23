# RIINA Core Mapping

The Coq definitions in `02_FORMAL/coq/foundations/Syntax.v`, `Typing.v` and
`Semantics.v` are the single normative definition of the core language
(mandate S1.1). This page maps the shipped compiler's AST
(`03_PROTO/crates/riina-types/src/lib.rs`) onto that core, constructor by
constructor, in both directions, and maps every surface construct to what the
parser elaborates it into.

`03_PROTO/crates/riinac/tests/core_mapping.rs` reads both definitions and the
lexer's keyword table, and fails when a Rust variant, a Coq constructor or a
keyword has no row here, when a row names something that no longer exists, or
when a row's status is not one of the five below.

**What this page shows.** The Coq theorems (type safety, effect soundness, and,
for the reference-free core, non-interference and termination) are about the
`core` and `elaborated` rows only. A program that uses an `unmodelled`
construct (arithmetic, loops, mutable locals, lists, records, builtin calls,
and the actor, UI and blockchain forms) is outside what is proven. Making the
core cover the shipped language is REQ-99 (core calculus v2); until then
`riinac emit-core` and assured mode reject `unmodelled` constructs (mandate R3,
S1.2, S1.6).

## `riinac emit-core`

`riinac emit-core <file>` (or `--stdin`) prints the core term a program
elaborates to (`Program::desugar`, then the Coq column of the tables below).
The program is not type-checked first, so the differential gate (REQ-111) can
compare riinac's verdict with the Coq checker's on any program.

- **Form.** A constructor with arguments is `(Name arg …)` and one without is
  `Name`, using exactly the constructors of the inductives in `Syntax.v`
  (`expr`, `ty`, `session_type`, `effect`, `security_level`, `taint_source`,
  `sanitizer`, `capability_kind`, `capability`). `nat` and `N` are decimal, `bool` is
  `true`/`false`, a `string` or `ident` is `"…"`, and `list string` is
  `(list "a" "b")`.
- **Strings.** Printable ASCII is written as itself, except `"` and `\`, which
  are `\"` and `\\`. Every other byte of the UTF-8 text is `\xHH`, in lower case.
- **Canonical.** The text has one spelling per term, with single spaces. The
  binary checks each term against the Coq signatures and parses its own output
  back before printing it.
- **Errors.** A construct this page marks `unmodelled`, a builtin, a `Let`
  with a linearity qualifier, or a group of mutually recursive functions is an
  error naming its row or section (`[CORE_MAPPING.md: Expr::BinOp]`). It is
  never dropped or approximated (mandate R3).

- **Conformance.** `riinac verify --full` and `--coq` type-check every
  emitted program in Coq too, with the executable checker `type_check_fn`
  (`foundations/TypeCheckFn.v`), and fail if Coq rejects a program riinac
  accepts, or gives it another type or effect (REQ-111). The programs are:
  - the fixtures in `riinac/tests/conformance/`, written to stay inside the
    core;
  - 10,000 per run from a seeded generator (`riinac/src/conformance_gen.rs`):
    well-typed programs, type errors, and information-flow or effect
    violations;
  - 5,000 mutants per run of those (`riinac/src/conformance_fuzz.rs`), each
    with one small change, such as a swapped projection, a renamed variable,
    a raised reference level or a dropped declared effect.

  Every discrepancy fails the gate. A class awaiting a decision can be listed
  in `conformance::KNOWN_SOUNDNESS_CLASSES` to be reported instead; none is
  open. The one there was, riinac's branch on a secret, was closed on
  2026-10-23 by riinac rejecting it.

  `riinac verify --nightly` runs the same comparison on at least 1,000,000
  programs: batches of the per-run size, each from its own seed, compared in
  parallel. CI runs it every night (`.github/workflows/conformance-nightly.yml`).
  Each generated or fuzzed program's name carries its batch's seed, and
  `RIINA_CONFORMANCE_SEED=0x<seed> riinac verify --coq` repeats that batch.

The core cannot yet express the corpus: 0 of the 83 checked examples emit.
`riinac/tests/emit_core.rs` records that count and prints each example's first
unmodelled construct.

## Status vocabulary

| Status | Meaning |
|---|---|
| `core` | The same constructor exists on the other side, with the same meaning. A representation difference is named in Notes. |
| `refined` | The Rust form carries more information than the Coq one and is checked at least as strictly (Notes say how). |
| `elaborated` | No constructor of its own: it is expressed with the Coq constructors named in the Coq column. |
| `unmodelled` | No Coq counterpart. Programs that use it are outside the proofs. |
| `coq-only` | A Coq constructor with no Rust variant (Notes say what produces it, if anything). |

## Rust → Coq

### `Expr` (expressions)

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `Expr::Unit` | `EUnit` | core | T_Unit |
| `Expr::Bool` | `EBool` | core | T_Bool |
| `Expr::Int` | `EInt` | core | Coq `N` (binary, unbounded, non-negative); Rust `u64`. Negative numbers and overflow are unmodelled |
| `Expr::IntN` | — | unmodelled | sized integers (`42u8`); separate model `foundations/SizedInt.v`, not part of the core |
| `Expr::String` | `EString` | core | T_String |
| `Expr::Var` | `EVar` | core | a free name that is a builtin (`cetak`) has no Coq meaning: see Builtins below |
| `Expr::Lam` | `ELam` | core | T_Lam |
| `Expr::App` | `EApp` | core | T_App |
| `Expr::Pair` | `EPair` | core | T_Pair |
| `Expr::Fst` | `EFst` | core | T_Fst |
| `Expr::Snd` | `ESnd` | core | T_Snd |
| `Expr::Inl` | `EInl` | refined | T_Inl. Rust's annotation is the whole sum type `A + B`, and the checker requires the payload to have type `A`; Coq's `EInl e B` carries only the other side and infers `A`. `emit-core` writes `EInl e B` ascribed to `A + B`, which keeps the check of `A` (found by the REQ-111 fixtures, 2026-10-21) |
| `Expr::Inr` | `EInr` | refined | T_Inr. As `Inl`, mirrored: Rust's `Inr(e, A + B)` is Coq's `EInr e A` ascribed to `A + B` |
| `Expr::Case` | `ECase` | core | T_Case. A scrutinee labelled above public or tainted is rejected (2026-10-23), as T_Case needs a plain `TSum`; riinac used to raise the arms' security level, and match tainted data, instead |
| `Expr::If` | `EIf` | core | T_If. A condition labelled above public or tainted is rejected (2026-10-23), as T_If needs a plain `TBool`; riinac used to raise the branches' security level, and branch on tainted data, instead (found by REQ-111) |
| `Expr::Let` | `ELet` | core | the optional linearity qualifier is unmodelled; Coq `ELet` has none, so `emit-core` rejects a `Let` that carries one |
| `Expr::Ascribe` | `EApp`, `ELam`, `EVar` | elaborated | `e : T` (from `biar x: T = e` and a lambda's `-> T`) is `EApp (ELam y T (EVar y)) e`, which `emit-core` writes with `y` = `"ascribed"` (bound only around its own use, so it captures nothing); the Rust checker also allows its subsumptions (e.g. a `Sanitized` value where plain text is expected) |
| `Expr::Return` | — | unmodelled | early return (`pulang`); the core has no control effects |
| `Expr::While` | — | unmodelled | loops (`selagi`, `ulang`, `untuk`) |
| `Expr::Break` | — | unmodelled | `putus` |
| `Expr::Continue` | — | unmodelled | `lanjut` |
| `Expr::LetMut` | — | unmodelled | mutable local slot (`biar ubah`); not a `ruj` cell, so not `ERef` |
| `Expr::SlotGet` | — | unmodelled | read of a `biar ubah` slot |
| `Expr::SlotSet` | — | unmodelled | `x = e` on a `biar ubah` slot |
| `Expr::Perform` | `EPerform` | core | T_Perform |
| `Expr::Handle` | `EHandle` | core | T_Handle |
| `Expr::Ref` | `ERef` | core | T_Ref |
| `Expr::Deref` | `EDeref`; `EIf` on a Bool | refined | T_Deref on a reference. `!` is also negation on a `Bool`: riinac types `!b` as `Bool`, and the interpreter and both backends negate. The core has no negation, so `emit-core` writes `bukan b`'s term, `EIf b (EBool false) (EBool true)`, choosing by the operand's core type (REQ-111's generator found the negation written as `EDeref`, 2026-10-21) |
| `Expr::Assign` | `EAssign` | core | T_Assign |
| `Expr::Classify` | `EClassify` | core | T_Classify |
| `Expr::Declassify` | `EDeclassify` | core | T_Declassify |
| `Expr::Prove` | `EProve` | core | T_Prove |
| `Expr::Require` | `ERequire` | core | T_Require; Rust also runs a capability gate at run time |
| `Expr::Grant` | `EGrant` | refined | T_Grant. riinac also bounds a grant inside a function body by the capabilities the function holds: there `beri E` may only narrow, never add. Coq's T_Grant has no bound, so riinac is stricter. The REQ-111 fuzzer meets this as completeness gaps (`CapabilityViolation`) when it drops a declared effect that a `beri` relies on |
| `Expr::Loc` | `ELoc` | core | run-time only, never in source |
| `Expr::LetRec` | `ELet`, `EFix`, `ELam`, `ERequire` | elaborated | `let rec f : T = e1 in e2` is `ELet f (EFix (ELam f T e1)) e2` (T_Fix, function types only); a non-pure latent effect of `T` is required around each lambda body of `e1`, as for `LetRecGroup` |
| `Expr::LetRecGroup` | `ELet`, `EFix`, `ELam`, `EApp` | elaborated | a group of top-level functions (every run of `fungsi` declarations), every name in scope in every body. It is split into the strongly connected components of its calls and bound in dependency order (source order among independent functions): a function that calls itself is `ELet f (EFix (ELam f T e))`, as `LetRec` is; any other is `ELet f (e : T)`, so it stays in the `fix`-free fragment. A declared effect `E` (each arrow of a `fungsi` type carries it) is written `ERequire E` around each lambda body: riinac checks a body against `E` as an upper bound, the core has no subeffecting, and `T_Require` joins `E` into the body's effect while `ST_RequireValue` steps to the value (REQ-111 found both a pure body under `kesan Tulis` and the outer arrow of a two-parameter effectful function rejected by Coq without it). Two or more mutually recursive functions have no encoding, and `emit-core` rejects them |
| `Expr::BinOp` | — | unmodelled | arithmetic, comparison and logical operators; the core has no primitive operations |
| `Expr::ListLit` | — | unmodelled | list literals; the core has `TList` but no list expressions |
| `Expr::RecordLit` | — | unmodelled | records |
| `Expr::FieldAccess` | — | unmodelled | `e.f` |
| `Expr::FFICall` | — | unmodelled | foreign calls (`luaran`) |
| `Expr::ActorDecl` | — | unmodelled | `pelaku`; domain model `domains/ActorCalculus.v`, not the core |
| `Expr::ChoreographyBlock` | — | unmodelled | `koreografi`; domain model `domains/ChoreographyTypes.v` |
| `Expr::Spawn` | — | unmodelled | `lahir` |
| `Expr::ActorSend` | — | unmodelled | `hantar` |
| `Expr::ActorRecv` | — | unmodelled | `terima` |
| `Expr::CRDTMerge` | — | unmodelled | `gabung`; domain model `domains/CRDTFoundations.v` |
| `Expr::ContentHash` | — | unmodelled | `cincang` |
| `Expr::ContentVerify` | — | unmodelled | `sahkan` |
| `Expr::ContractDeploy` | — | unmodelled | `kontrak_pintar` |
| `Expr::TokenTransfer` | — | unmodelled | `token::pindah` |
| `Expr::ZakatCalculate` | — | unmodelled | `zakat` |
| `Expr::UIDisplay` | — | unmodelled | CAHAYA `paparan` |
| `Expr::UIRow` | — | unmodelled | `baris` |
| `Expr::UIColumn` | — | unmodelled | `lajur` |
| `Expr::UIText` | — | unmodelled | `tulisan` |
| `Expr::UIButton` | — | unmodelled | `butang` |
| `Expr::UIColor` | — | unmodelled | `warna` |
| `Expr::UIStyleDecl` | — | unmodelled | `gaya` |
| `Expr::UIContrastCheck` | — | unmodelled | `kontras` |

### `Ty` (types)

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `Ty::Unit` | `TUnit` | core | |
| `Ty::Bool` | `TBool` | core | |
| `Ty::Int` | `TInt` | core | see `Expr::Int` |
| `Ty::IntN` | — | unmodelled | `foundations/SizedInt.v` models the arithmetic, outside the core |
| `Ty::BigInt` | — | unmodelled | `besar`; `foundations/BigIntModel.v`, outside the core |
| `Ty::Decimal` | — | unmodelled | `perpuluhan`; `foundations/DecimalModel.v`, outside the core |
| `Ty::Fixed` | — | unmodelled | `wang`; `foundations/FixedPointModel.v`, outside the core |
| `Ty::FixedBin` | — | unmodelled | Q-format fixed point |
| `Ty::String` | `TString` | core | |
| `Ty::Bytes` | `TBytes` | core | |
| `Ty::Fn` | `TFn` | refined | Coq's latent effect is one `effect` in a total order; Rust's is an `EffectSet` with a per-category order. Rust accepts a subset of what the Coq order accepts (see `EffectSet` in `riina-types`). `emit-core` writes the set as its Coq join (the highest `effect_level`; the empty set is `EffPure`) |
| `Ty::Prod` | `TProd` | core | |
| `Ty::Sum` | `TSum` | core | |
| `Ty::List` | `TList` | core | the type only; list expressions are unmodelled |
| `Ty::Option` | `TOption` | core | |
| `Ty::Ref` | `TRef` | core | |
| `Ty::Secret` | `TSecret` | core | |
| `Ty::Labeled` | `TLabeled` | core | |
| `Ty::Tainted` | `TTainted` | core | |
| `Ty::Sanitized` | `TSanitized` | core | |
| `Ty::Proof` | `TProof` | core | |
| `Ty::Capability` | `TCapability` | core | |
| `Ty::CapabilityFull` | `TCapabilityFull` | core | |
| `Ty::Chan` | `TChan` | core | |
| `Ty::SecureChan` | `TSecureChan` | core | |
| `Ty::ConstantTime` | `TConstantTime` | core | |
| `Ty::Zeroizing` | `TZeroizing` | core | |
| `Ty::Any` | — | unmodelled | matches every type; used by polymorphic builtins, generic parameters (`fungsi f<T>`) and the names of record and variant types, which the checker does not type (REQ-93(c)) |
| `Ty::RawPtr` | — | unmodelled | FFI |
| `Ty::CChar` | — | unmodelled | FFI |
| `Ty::CInt` | — | unmodelled | FFI |
| `Ty::CVoid` | — | unmodelled | FFI |
| `Ty::Actor` | — | unmodelled | JALINAN |
| `Ty::Choreography` | — | unmodelled | JALINAN |
| `Ty::ContentAddressed` | — | unmodelled | JALINAN |
| `Ty::CRDT` | — | unmodelled | JALINAN; no source syntax produces a value of this type |
| `Ty::Supervisor` | — | unmodelled | JALINAN |
| `Ty::SmartContract` | — | unmodelled | blockchain |
| `Ty::Token` | — | unmodelled | blockchain |
| `Ty::SyariahCompliant` | — | unmodelled | a distinct wrapper type: no expression produces one and no rule gives it meaning |
| `Ty::Color` | — | unmodelled | CAHAYA |
| `Ty::Element` | — | unmodelled | CAHAYA |
| `Ty::Layout` | — | unmodelled | CAHAYA |
| `Ty::UIStyle` | — | unmodelled | CAHAYA |
| `Ty::AccessibleText` | — | unmodelled | CAHAYA |

### `Effect`

The relative order of the effects both sides share is the same. The numbers
are not. Rust's `Effect::level()` inserts `Mut` (1) and `Alloc` (3), so `Read`
is 2 in Rust and 1 in Coq, `Write` is 4 against 2, and so on up to `Gapura`
(18 against 16).

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `Effect::Pure` | `EffPure` | core | |
| `Effect::Read` | `EffRead` | core | |
| `Effect::Write` | `EffWrite` | core | |
| `Effect::Mut` | — | unmodelled | local mutation (`kesan Ubah`) |
| `Effect::Alloc` | — | unmodelled | heap allocation (`kesan Peruntuk`) |
| `Effect::FileSystem` | `EffFileSystem` | core | |
| `Effect::Network` | `EffNetwork` | core | |
| `Effect::NetworkSecure` | `EffNetSecure` | core | |
| `Effect::Crypto` | `EffCrypto` | core | |
| `Effect::Random` | `EffRandom` | core | |
| `Effect::System` | `EffSystem` | core | |
| `Effect::Time` | `EffTime` | core | |
| `Effect::Process` | `EffProcess` | core | |
| `Effect::Panel` | `EffPanel` | core | |
| `Effect::Zirah` | `EffZirah` | core | |
| `Effect::Benteng` | `EffBenteng` | core | |
| `Effect::Sandi` | `EffSandi` | core | |
| `Effect::Menara` | `EffMenara` | core | |
| `Effect::Gapura` | `EffGapura` | core | |

### `SecurityLevel`

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `SecurityLevel::Public` | `LPublic` | core | level 0 on both sides |
| `SecurityLevel::Internal` | `LInternal` | core | 1 |
| `SecurityLevel::Session` | `LSession` | core | 2 |
| `SecurityLevel::User` | `LUser` | core | 3 |
| `SecurityLevel::System` | `LSystem` | core | 4 |
| `SecurityLevel::Secret` | `LSecret` | core | 5 |

### `SessionType`

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `SessionType::End` | `SessEnd` | core | |
| `SessionType::Send` | `SessSend` | core | |
| `SessionType::Recv` | `SessRecv` | core | |
| `SessionType::Select` | `SessSelect` | core | |
| `SessionType::Branch` | `SessBranch` | core | |
| `SessionType::Rec` | `SessRec` | core | |
| `SessionType::Var` | `SessVar` | core | |

### `TaintSource`

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `TaintSource::NetworkExternal` | `TaintNetworkExternal` | core | |
| `TaintSource::NetworkInternal` | `TaintNetworkInternal` | core | |
| `TaintSource::UserInput` | `TaintUserInput` | core | |
| `TaintSource::FileSystem` | `TaintFileSystem` | core | |
| `TaintSource::Database` | `TaintDatabase` | core | |
| `TaintSource::Environment` | `TaintEnvironment` | core | |
| `TaintSource::GapuraRequest` | `TaintGapuraRequest` | core | |
| `TaintSource::ZirahEvent` | `TaintZirahEvent` | core | |
| `TaintSource::ZirahEndpoint` | `TaintZirahEndpoint` | core | |
| `TaintSource::BentengBiometric` | `TaintBentengBiometric` | core | |
| `TaintSource::SandiSignature` | `TaintSandiSignature` | core | |
| `TaintSource::MenaraDevice` | `TaintMenaraDevice` | core | |

### `Sanitizer`

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `Sanitizer::HtmlEscape` | `SanHtmlEscape` | core | |
| `Sanitizer::UrlEncode` | `SanUrlEncode` | core | |
| `Sanitizer::JsEscape` | `SanJsEscape` | core | |
| `Sanitizer::CssEscape` | `SanCssEscape` | core | |
| `Sanitizer::JsonEscape` | `SanJsonEscape` | core | |
| `Sanitizer::SqlEscape` | `SanSqlEscape` | core | |
| `Sanitizer::SqlParam` | `SanSqlParam` | core | |
| `Sanitizer::XssFilter` | `SanXssFilter` | core | |
| `Sanitizer::PathTraversal` | `SanPathTraversal` | core | |
| `Sanitizer::CommandEscape` | `SanCommandEscape` | core | |
| `Sanitizer::LdapEscape` | `SanLdapEscape` | core | |
| `Sanitizer::XmlEscape` | `SanXmlEscape` | core | |
| `Sanitizer::UrlAllowlist` | — | unmodelled | Rust-only |
| `Sanitizer::JsonValidation` | `SanJsonValidation` | core | |
| `Sanitizer::XmlValidation` | `SanXmlValidation` | core | |
| `Sanitizer::EmailValidation` | `SanEmailValidation` | core | |
| `Sanitizer::PhoneValidation` | `SanPhoneValidation` | core | |
| `Sanitizer::LengthBound` | `SanLengthBound` | core | Coq `nat`, Rust `u64` |
| `Sanitizer::RangeBound` | `SanRangeBound` | core | Coq `nat`, Rust `u64` |
| `Sanitizer::RegexMatch` | `SanRegexMatch` | core | |
| `Sanitizer::Whitelist` | `SanWhitelist` | core | |
| `Sanitizer::HashVerify` | `SanHashVerify` | core | |
| `Sanitizer::SignatureVerify` | `SanSignatureVerify` | core | |
| `Sanitizer::MacVerify` | `SanMacVerify` | core | |
| `Sanitizer::GapuraAuth` | `SanGapuraAuth` | core | |
| `Sanitizer::ZirahSession` | `SanZirahSession` | core | |
| `Sanitizer::BentengBiometric` | `SanBentengBiometric` | core | |
| `Sanitizer::SandiDecrypt` | `SanSandiDecrypt` | core | |
| `Sanitizer::MenaraAttestation` | `SanMenaraAttestation` | core | |

### `CapabilityKind` and `Capability`

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `CapabilityKind::FileRead` | `CapFileRead` | core | |
| `CapabilityKind::FileWrite` | `CapFileWrite` | core | |
| `CapabilityKind::FileExecute` | `CapFileExecute` | core | |
| `CapabilityKind::FileDelete` | `CapFileDelete` | core | |
| `CapabilityKind::NetConnect` | `CapNetConnect` | core | |
| `CapabilityKind::NetListen` | `CapNetListen` | core | |
| `CapabilityKind::NetBind` | `CapNetBind` | core | |
| `CapabilityKind::ProcSpawn` | `CapProcSpawn` | core | |
| `CapabilityKind::ProcSignal` | `CapProcSignal` | core | |
| `CapabilityKind::SysTime` | `CapSysTime` | core | |
| `CapabilityKind::SysRandom` | `CapSysRandom` | core | |
| `CapabilityKind::SysEnv` | `CapSysEnv` | core | |
| `CapabilityKind::RootProduct` | `CapRootProduct` | core | |
| `CapabilityKind::ProductAccess` | `CapProductAccess` | core | |
| `Capability::Basic` | `CapBasic` | core | |
| `Capability::Revocable` | `CapRevocable` | core | |
| `Capability::TimeBound` | `CapTimeBound` | core | Coq `nat`, Rust `u64` |
| `Capability::Delegated` | `CapDelegated` | core | |

### Rust-only enums

These have no Coq inductive; every variant is `unmodelled`.

| Rust | Coq | Status | Notes |
|---|---|---|---|
| `BinOp::Add` | — | unmodelled | `+` |
| `BinOp::Sub` | — | unmodelled | `-` |
| `BinOp::Mul` | — | unmodelled | `*` |
| `BinOp::Div` | — | unmodelled | `/` |
| `BinOp::Mod` | — | unmodelled | `%` |
| `BinOp::Eq` | — | unmodelled | `==` |
| `BinOp::Ne` | — | unmodelled | `!=` |
| `BinOp::Lt` | — | unmodelled | `<` |
| `BinOp::Le` | — | unmodelled | `<=` |
| `BinOp::Gt` | — | unmodelled | `>` |
| `BinOp::Ge` | — | unmodelled | `>=` |
| `BinOp::And` | — | unmodelled | `&&`, `dan` |
| `BinOp::Or` | — | unmodelled | `\|\|`, `atau` |
| `Linearity::Linear` | — | unmodelled | `Let` qualifier; `domains/LinearTypes.v` models linearity outside the core |
| `Linearity::Affine` | — | unmodelled | `Let` qualifier; `domains/LinearTypes.v` models linearity outside the core |
| `Linearity::Relevant` | — | unmodelled | `Let` qualifier; `domains/LinearTypes.v` models linearity outside the core |
| `Linearity::Unrestricted` | — | unmodelled | `Let` qualifier; `domains/LinearTypes.v` models linearity outside the core |

## Coq → Rust

| Coq | Rust | Status | Notes |
|---|---|---|---|
| `EUnit` | `Expr::Unit` | core | |
| `EBool` | `Expr::Bool` | core | |
| `EInt` | `Expr::Int` | core | `N` against `u64` |
| `EString` | `Expr::String` | core | |
| `ELoc` | `Expr::Loc` | core | |
| `EVar` | `Expr::Var` | core | |
| `ELam` | `Expr::Lam` | core | |
| `EApp` | `Expr::App` | core | |
| `EPair` | `Expr::Pair` | core | |
| `EFst` | `Expr::Fst` | core | |
| `ESnd` | `Expr::Snd` | core | |
| `EInl` | `Expr::Inl` | refined | the Rust annotation is the whole sum type (see `Expr::Inl`) |
| `EInr` | `Expr::Inr` | refined | the Rust annotation is the whole sum type (see `Expr::Inr`) |
| `ECase` | `Expr::Case` | core | |
| `EIf` | `Expr::If` | core | |
| `ELet` | `Expr::Let` | core | |
| `EPerform` | `Expr::Perform` | core | |
| `EHandle` | `Expr::Handle` | core | |
| `ERef` | `Expr::Ref` | core | |
| `EDeref` | `Expr::Deref` | refined | Rust's `!` is also negation on a `Bool` (see `Expr::Deref`) |
| `EAssign` | `Expr::Assign` | core | |
| `EClassify` | `Expr::Classify` | core | |
| `EDeclassify` | `Expr::Declassify` | core | |
| `EProve` | `Expr::Prove` | core | |
| `EFix` | — | coq-only | the target of `Expr::LetRec` |
| `ERequire` | `Expr::Require` | core | |
| `EGrant` | `Expr::Grant` | refined | riinac bounds a grant inside a function (see `Expr::Grant`) |
| `TUnit` | `Ty::Unit` | core | |
| `TBool` | `Ty::Bool` | core | |
| `TInt` | `Ty::Int` | core | |
| `TString` | `Ty::String` | core | |
| `TBytes` | `Ty::Bytes` | core | |
| `TFn` | `Ty::Fn` | refined | one effect against an `EffectSet` |
| `TProd` | `Ty::Prod` | core | |
| `TSum` | `Ty::Sum` | core | |
| `TList` | `Ty::List` | core | |
| `TOption` | `Ty::Option` | core | |
| `TRef` | `Ty::Ref` | core | |
| `TSecret` | `Ty::Secret` | core | |
| `TLabeled` | `Ty::Labeled` | core | |
| `TTainted` | `Ty::Tainted` | core | |
| `TSanitized` | `Ty::Sanitized` | core | |
| `TProof` | `Ty::Proof` | core | |
| `TCapability` | `Ty::Capability` | core | |
| `TCapabilityFull` | `Ty::CapabilityFull` | core | |
| `TChan` | `Ty::Chan` | core | |
| `TSecureChan` | `Ty::SecureChan` | core | |
| `TConstantTime` | `Ty::ConstantTime` | core | |
| `TZeroizing` | `Ty::Zeroizing` | core | |
| `SessEnd` | `SessionType::End` | core | |
| `SessSend` | `SessionType::Send` | core | |
| `SessRecv` | `SessionType::Recv` | core | |
| `SessSelect` | `SessionType::Select` | core | |
| `SessBranch` | `SessionType::Branch` | core | |
| `SessRec` | `SessionType::Rec` | core | |
| `SessVar` | `SessionType::Var` | core | |
| `EffPure` | `Effect::Pure` | core | |
| `EffRead` | `Effect::Read` | core | |
| `EffWrite` | `Effect::Write` | core | |
| `EffFileSystem` | `Effect::FileSystem` | core | |
| `EffNetwork` | `Effect::Network` | core | |
| `EffNetSecure` | `Effect::NetworkSecure` | core | |
| `EffCrypto` | `Effect::Crypto` | core | |
| `EffRandom` | `Effect::Random` | core | |
| `EffSystem` | `Effect::System` | core | |
| `EffTime` | `Effect::Time` | core | |
| `EffProcess` | `Effect::Process` | core | |
| `EffPanel` | `Effect::Panel` | core | |
| `EffZirah` | `Effect::Zirah` | core | |
| `EffBenteng` | `Effect::Benteng` | core | |
| `EffSandi` | `Effect::Sandi` | core | |
| `EffMenara` | `Effect::Menara` | core | |
| `EffGapura` | `Effect::Gapura` | core | |
| `LPublic` | `SecurityLevel::Public` | core | |
| `LInternal` | `SecurityLevel::Internal` | core | |
| `LSession` | `SecurityLevel::Session` | core | |
| `LUser` | `SecurityLevel::User` | core | |
| `LSystem` | `SecurityLevel::System` | core | |
| `LSecret` | `SecurityLevel::Secret` | core | |
| `TaintNetworkExternal` | `TaintSource::NetworkExternal` | core | |
| `TaintNetworkInternal` | `TaintSource::NetworkInternal` | core | |
| `TaintUserInput` | `TaintSource::UserInput` | core | |
| `TaintFileSystem` | `TaintSource::FileSystem` | core | |
| `TaintDatabase` | `TaintSource::Database` | core | |
| `TaintEnvironment` | `TaintSource::Environment` | core | |
| `TaintGapuraRequest` | `TaintSource::GapuraRequest` | core | |
| `TaintZirahEvent` | `TaintSource::ZirahEvent` | core | |
| `TaintZirahEndpoint` | `TaintSource::ZirahEndpoint` | core | |
| `TaintBentengBiometric` | `TaintSource::BentengBiometric` | core | |
| `TaintSandiSignature` | `TaintSource::SandiSignature` | core | |
| `TaintMenaraDevice` | `TaintSource::MenaraDevice` | core | |
| `SanHtmlEscape` | `Sanitizer::HtmlEscape` | core | |
| `SanUrlEncode` | `Sanitizer::UrlEncode` | core | |
| `SanJsEscape` | `Sanitizer::JsEscape` | core | |
| `SanCssEscape` | `Sanitizer::CssEscape` | core | |
| `SanJsonEscape` | `Sanitizer::JsonEscape` | core | |
| `SanSqlEscape` | `Sanitizer::SqlEscape` | core | |
| `SanSqlParam` | `Sanitizer::SqlParam` | core | |
| `SanXssFilter` | `Sanitizer::XssFilter` | core | |
| `SanPathTraversal` | `Sanitizer::PathTraversal` | core | |
| `SanCommandEscape` | `Sanitizer::CommandEscape` | core | |
| `SanLdapEscape` | `Sanitizer::LdapEscape` | core | |
| `SanXmlEscape` | `Sanitizer::XmlEscape` | core | |
| `SanJsonValidation` | `Sanitizer::JsonValidation` | core | |
| `SanXmlValidation` | `Sanitizer::XmlValidation` | core | |
| `SanEmailValidation` | `Sanitizer::EmailValidation` | core | |
| `SanPhoneValidation` | `Sanitizer::PhoneValidation` | core | |
| `SanLengthBound` | `Sanitizer::LengthBound` | core | |
| `SanRangeBound` | `Sanitizer::RangeBound` | core | |
| `SanRegexMatch` | `Sanitizer::RegexMatch` | core | |
| `SanWhitelist` | `Sanitizer::Whitelist` | core | |
| `SanHashVerify` | `Sanitizer::HashVerify` | core | |
| `SanSignatureVerify` | `Sanitizer::SignatureVerify` | core | |
| `SanMacVerify` | `Sanitizer::MacVerify` | core | |
| `SanGapuraAuth` | `Sanitizer::GapuraAuth` | core | |
| `SanZirahSession` | `Sanitizer::ZirahSession` | core | |
| `SanBentengBiometric` | `Sanitizer::BentengBiometric` | core | |
| `SanSandiDecrypt` | `Sanitizer::SandiDecrypt` | core | |
| `SanMenaraAttestation` | `Sanitizer::MenaraAttestation` | core | |
| `SanSingle` | — | coq-only | `sanitizer_comp`: composed sanitizers; no type uses it |
| `SanAnd` | — | coq-only | `sanitizer_comp` |
| `SanSeq` | — | coq-only | `sanitizer_comp` |
| `CapFileRead` | `CapabilityKind::FileRead` | core | |
| `CapFileWrite` | `CapabilityKind::FileWrite` | core | |
| `CapFileExecute` | `CapabilityKind::FileExecute` | core | |
| `CapFileDelete` | `CapabilityKind::FileDelete` | core | |
| `CapNetConnect` | `CapabilityKind::NetConnect` | core | |
| `CapNetListen` | `CapabilityKind::NetListen` | core | |
| `CapNetBind` | `CapabilityKind::NetBind` | core | |
| `CapProcSpawn` | `CapabilityKind::ProcSpawn` | core | |
| `CapProcSignal` | `CapabilityKind::ProcSignal` | core | |
| `CapSysTime` | `CapabilityKind::SysTime` | core | |
| `CapSysRandom` | `CapabilityKind::SysRandom` | core | |
| `CapSysEnv` | `CapabilityKind::SysEnv` | core | |
| `CapRootProduct` | `CapabilityKind::RootProduct` | core | |
| `CapProductAccess` | `CapabilityKind::ProductAccess` | core | |
| `CapBasic` | `Capability::Basic` | core | |
| `CapRevocable` | `Capability::Revocable` | core | |
| `CapTimeBound` | `Capability::TimeBound` | core | |
| `CapDelegated` | `Capability::Delegated` | core | |

## Surface → core

How the parser (`03_PROTO/crates/riina-parser/src/lib.rs`) and
`Program::desugar` (`riina-types`) turn source into the `Expr` above. The
elaborations name `Expr` variants; the Rust → Coq tables then say whether each
is in the core.

### Keywords

One row per keyword token of the lexer (`riina-lexer/src/lexer.rs`), with
every spelling. Kind:

| Kind | Meaning |
|---|---|
| `construct` | Starts a construct; Elaborates to says into what. |
| `part` | Valid only inside another construct, named in the row. |
| `soft` | No construct of its own: used as a name, it is an ordinary name. |
| `reserved` | No production: any use is a parse error. |

`core_mapping.rs` checks the last two kinds against the compiler: every
spelling of a `reserved` keyword must fail `riinac check`, and every spelling of
a `soft` one must work as a name. `scripts/generate-agent-files.py` refuses to
list a `reserved` or `soft` keyword as usable in the agent files,
and the test holds the website's keyword list to the same rule.

| Token | Spellings | Kind | Elaborates to |
|---|---|---|---|
| `KwFn` | `fungsi`, `fn` | construct | Top level: `fungsi f(x: A, y: B) -> R kesan E { b }` is a `TopLevelDecl::Function`; `Program::desugar` puts each run of consecutive functions in one `LetRecGroup` of curried `Lam`s (no parameters: `Lam(_unit, Unit, b)`). In a block: `LetRec(f, T, Lam…, rest)`. `fungsi(x: A) -> R { b }` is `Lam(x, A, Ascribe(b, R))`, so `b` and every `pulang` in it are checked against `R` |
| `KwLet` | `biar`, `let` | construct | `biar x = e; rest` is `Let(x, None, e, rest)`; with an annotation, `biar x: T = e` binds `Ascribe(e, T)`, which the checker holds `e` to. `biar (a, b) = e` binds a fresh name and projects with `Fst`/`Snd`. At top level, `TopLevelDecl::Binding`, then `Let` |
| `KwMut` | `ubah`, `mut` | part | `biar ubah x = e; rest` is `LetMut(x, e, rest)`; later reads of `x` are `SlotGet`, and `x = e` is `SlotSet`. Ignored on a parameter |
| `KwConst` | `tetap`, `const` | reserved | |
| `KwStatic` | `statik`, `static` | reserved | |
| `KwType` | `jenis`, `type` | construct | Declares the type name `N` for this file. `jenis N = T;` is an alias: `N` means `T`. `jenis N { … }`, `jenis N = { … };`, `jenis N = \| A \| B(T);` and `jenis N = N(T);` declare a record or variant type, and `jenis N` a marker: `N` reads as `Ty::Any` and the body is discarded, because the checker has no record or variant types (REQ-93(c)). Elsewhere `jenis` is a name |
| `KwStruct` | `bentuk`, `struktur`, `struct` | construct | `bentuk N { … }` declares the record type name `N` for this file; `N` reads as `Ty::Any` and the body is discarded (REQ-93(c)) |
| `KwEnum` | `pilihan`, `enum` | construct | `pilihan N { … }` declares the variant type name `N` for this file; `N` reads as `Ty::Any` and the body is discarded (REQ-93(c)) |
| `KwUnion` | `kesatuan`, `union` | reserved | |
| `KwTrait` | `sifat`, `trait` | reserved | |
| `KwImpl` | `laksana`, `impl` | reserved | |
| `KwWhere` | `dimana`, `where` | reserved | |
| `KwMod` | `modul`, `mod` | construct | `modul m { fungsi f … }` defines `f` as the top-level `m_f`; `awam` before a `fungsi` is accepted. Any other item in the block is error P0018 (it used to be discarded) |
| `KwPub` | `awam`, `pub` | construct | no node: marks the name exported from its module |
| `KwUse` | `guna`, `use` | construct | `guna m;` imports the sibling file `m.rii`, whose names become `m_f`. A path of several segments (`guna std::teks;`) is ignored: builtins need no import |
| `KwExtern` | `luaran`, `extern` | construct | `luaran "C" { fungsi f(x: A) -> R; }` is `Let(f, Lam(x, A, FFICall{f, [x], R}), rest)` |
| `KwFor` | `untuk`, `for` | construct | `untuk x dalam e { b }` is `Let(l, e, LetMut(i, 0, While(BinOp(Lt, SlotGet(i), len(l)), Let(x, get(l, i), …SlotSet(i, i + 1)… b))))`, where `len` and `get` are internal builtins |
| `KwIf` | `kalau`, `if` | construct | `If(c, a, b)`; with no `lain`, `If(c, Let(_, a, Unit), Unit)` |
| `KwElse` | `lain`, `else` | part | in `kalau` and `pastikan` |
| `KwMatch` | `padan`, `match` | construct | A match of constructor patterns (`Ada`/`Tiada`, `inl`/`inr`, …) is a `Case`; any other is `Let` of the scrutinee and a chain of `If`s whose tests are `BinOp(Eq, …)`, projections and list builtins |
| `KwLoop` | `ulang`, `loop` | construct | `While(Bool(true), b)` |
| `KwWhile` | `selagi`, `while` | construct | `While(c, b)` |
| `KwWith` | `dengan`, `with` | part | in `dedah … dengan …` and `kendali … dengan …` |
| `KwBreak` | `putus`, `break` | construct | `Break`; outside a loop, error P0010 |
| `KwContinue` | `lanjut`, `continue` | construct | `Continue`; outside a loop, error P0010 |
| `KwReturn` | `pulang`, `return` | construct | `Return(e)`, or `Return(Unit)` |
| `KwAs` | `sebagai`, `as` | reserved | |
| `KwRef` | `ruj`, `ref` | construct | `ruj e @Tahap` is `Ref(e, level)`; the level is required |
| `KwMove` | `pindah`, `move` | part | in `token::pindah(…)` |
| `KwSelfValue` | `diri`, `self` | reserved | |
| `KwSelfType` | `Diri`, `Self` | reserved | |
| `KwSuper` | `induk`, `super` | reserved | |
| `KwCrate` | `peti`, `crate` | reserved | |
| `KwAsync` | `tak_segerak`, `async` | reserved | |
| `KwAwait` | `tunggu`, `await` | reserved | |
| `KwUnsafe` | `bahaya`, `unsafe` | reserved | |
| `KwEffect` | `kesan`, `effect` | part | the effect clause of a `fungsi` signature and of a `Fn(…) -> R` type |
| `KwPerform` | `laku`, `perform` | construct | `Perform(effect, e)`: checks the capability, then yields the value of `e` (Coq ST_PerformValue) on every backend |
| `KwHandle` | `kendali`, `handle` | construct | `kendali e dengan x => h` is `Handle(e, x, h)`: as in Coq (ST_HandleValue), `h` runs once with `x` bound to the value of `e`, on every backend; it does not intercept a `laku` |
| `KwResume` | `sambung`, `resume` | reserved | |
| `KwAbort` | `batal`, `abort` | reserved | |
| `KwSecret` | `rahsia`, `secret` | soft | (the type `Rahsia<T>` is a capitalized type name, not this keyword) |
| `KwClassify` | `sulit`, `classify` | construct | `Classify(e)` |
| `KwPublic` | `terbuka`, `public` | reserved | |
| `KwTainted` | `tercemar`, `tainted` | reserved | (the type `Tercemar<T, Src>` is a capitalized type name) |
| `KwDeclassify` | `dedah`, `declassify` | construct | `dedah e dengan p` and `dedah(e, p)` are both `Declassify(e, p)` |
| `KwProve` | `bukti`, `prove` | construct | `Prove(e)` |
| `KwSanitize` | `bersihkan`, `sanitize` | reserved | (sanitizing is the builtins `sanitasi_*`) |
| `KwIn` | `dalam`, `in` | part | in `untuk … dalam …` |
| `KwIs` | `ialah`, `is` | reserved | |
| `KwPure` | `bersih`, `pure` | reserved | (the effect `Bersih` is a capitalized name) |
| `KwSafe` | `selamat`, `safe` | soft | |
| `KwPolicy` | `dasar`, `policy` | soft | |
| `KwLevel` | `tahap`, `level` | soft | |
| `KwChannel` | `saluran`, `channel` | soft | (the type `Saluran<S>` is a capitalized type name) |
| `KwBorrow` | `pinjam`, `borrow` | reserved | |
| `KwCopy` | `salin`, `copy` | reserved | |
| `KwClone` | `klon`, `clone` | reserved | |
| `KwLifetime` | `jangka`, `lifetime` | reserved | |
| `KwSekali` | `sekali`, `linear` | part | `biar sekali x = e` is `Let(x, Some(Linear), e, rest)`; using `x` twice is a linearity error |
| `KwPaling` | `paling`, `affine` | part | `Let(x, Some(Affine), …)` |
| `KwMesti` | `mesti`, `relevant` | part | `Let(x, Some(Relevant), …)` |
| `KwAnd` | `dan`, `and` | reserved | (conjunction is `&&`) |
| `KwOr` | `atau`, `or` | reserved | (disjunction is `\|\|`) |
| `KwNot` | `bukan`, `not` | construct | `bukan e` is `If(e, Bool(false), Bool(true))` |
| `KwGuard` | `pastikan`, `guard` | construct | `pastikan c lain { e }; rest` is `If(c, rest, e)`; without `lain`, the else branch calls an internal failure builtin, and a message string is discarded |
| `KwTest` | `ujian`, `test` | construct | `TopLevelDecl::Test`: run by `riinac test`, dropped from a program |
| `KwExpect` | `jangkakan`, `expect` | construct | `Var("jangkakan")`, a builtin |
| `KwInl` | `inl` | construct | `Inl(e, T)` |
| `KwInr` | `inr` | construct | `Inr(e, T)` |
| `KwFst` | `pertama`, `fst` | construct | `Fst(e)` |
| `KwSnd` | `kedua`, `snd` | construct | `Snd(e)` |
| `KwRequire` | `perlukan`, `require` | construct | `Require(effect, e)` |
| `KwGrant` | `beri`, `grant` | construct | `Grant(effect, e)` |
| `KwSome` | `Ada`, `Some` | construct | `Inl(e, Ty::Any)` |
| `KwNone` | `Tiada`, `Tidak`, `None` | construct | `Inr(Unit, Ty::Any)` |
| `KwOk` | `Jadi`, `Berjaya`, `Ok` | construct | `Inl(e, Ty::Any)` |
| `KwErr` | `Gagal`, `Ralat`, `Err` | construct | `Inr(e, Ty::Any)` |
| `KwSession` | `sesi`, `session` | reserved | |
| `KwSend` | `hantar`, `send` | construct | `hantar(a, m)` is `ActorSend(a, m)`; in `koreografi`, `A -> B: hantar T;` |
| `KwRecv` | `terima`, `recv` | construct | `ActorRecv(a)` |
| `KwSelect` | `pilih`, `select` | part | in `koreografi`: `pilih { … }` is `SessionType::Select` of exactly two branches, and the steps after it follow each branch |
| `KwBranch` | `cabang`, `branch` | reserved | |
| `KwEnd` | `tamat`, `end` | part | in `koreografi`: `SessionType::End` |
| `KwCapability` | `keupayaan`, `capability` | soft | (the type `Keupayaan<K>` is a capitalized type name) |
| `KwRevoke` | `tarik_balik`, `revoke` | reserved | |
| `KwAtomic` | `atom`, `atomic` | reserved | |
| `KwFence` | `pagar`, `fence` | reserved | |
| `KwAcquire` | `peroleh`, `acquire` | reserved | |
| `KwRelease` | `lepas`, `release` | reserved | |
| `KwSeqCst` | `turutan_ketat`, `seqcst` | reserved | |
| `KwRelaxed` | `santai`, `relaxed` | reserved | |
| `KwAcqRel` | `peroleh_lepas`, `acqrel` | reserved | |
| `KwProduct` | `hasil_darab`, `product` | reserved | |
| `KwCt` | `masa_tetap`, `ct` | reserved | (constant-time checking is on values of the type `MasaTetap<T>`) |
| `KwSpeculationSafe` | `selamat_spekulasi`, `speculation_safe` | reserved | |
| `KwCombined` | `gabungan`, `combined` | soft | |
| `KwZeroize` | `kosongkan`, `zeroize` | reserved | (the type `Sifar<T>` is a capitalized type name) |
| `KwChoreography` | `koreografi`, `choreography` | construct | `ChoreographyBlock { roles, protocol }`, where `protocol` is the local session type of the first role. A message type is read as any type annotation is |
| `KwActor` | `pelaku`, `actor` | construct | `ActorDecl` with message type `Ty::Any`, an initial state of the state type's default, and the handler `Lam(p, Any, body)`. More than one `kendalikan` is error P0019 |
| `KwRole` | `peranan`, `role` | part | in `koreografi` |
| `KwState` | `keadaan`, `state` | part | in `pelaku` (`keadaan: T`); elsewhere a name |
| `KwSupervisor` | `penyelia`, `supervisor` | reserved | |
| `KwMerge` | `gabung`, `merge` | construct | `CRDTMerge(a, b)`. A binding of the same name (`biar gabung = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwContentHash` | `cincang`, `content_hash` | construct | `ContentHash(e)` |
| `KwVerify` | `sahkan`, `verify` | construct | `ContentVerify(h, e)` |
| `KwSpawn` | `lahir`, `spawn` | construct | `lahir N(e)` is `Spawn(Var(N), e)` |
| `KwDisplay` | `paparan`, `display` | construct | `UIDisplay([…])`. A binding of the same name (`biar paparan = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwLayout` | `susun`, `layout` | reserved | |
| `KwColor` | `warna`, `color` | construct | `warna(r, g, b)` is `UIColor(r, g, b)`, each a literal of at most 255. A binding of the same name (`biar warna = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwText_` | `tulisan`, `text` | construct | `UIText(a, c)`. A binding of the same name (`biar tulisan = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwButton` | `butang`, `button` | construct | `UIButton(label, handler)` |
| `KwInput` | `masukan`, `input` | soft | |
| `KwImage` | `gambar`, `image` | reserved | |
| `KwStyle` | `gaya`, `style` | construct | `UIStyleDecl { padding, font_size }`. A binding of the same name (`biar gaya = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwContrast` | `kontras`, `contrast` | construct | `UIContrastCheck(fg, bg)` |
| `KwAccessible` | `mudahcapai`, `accessible` | reserved | |
| `KwRow` | `baris`, `row` | construct | `UIRow([…])`. A binding of the same name (`biar baris = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwColumn` | `lajur`, `column` | construct | `UIColumn([…])`. A binding of the same name (`biar lajur = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwPadding` | `pelapik`, `padding` | part | in `gaya` |
| `KwFontSize` | `saiz_fon`, `font_size` | part | in `gaya` |
| `KwSmartContract` | `kontrak_pintar`, `smart_contract` | construct | `ContractDeploy(e)`; in a type, `Ty::SmartContract` |
| `KwToken` | `token` | construct | `token::pindah(a, b, n)` is `TokenTransfer { from, to, amount }`; in a type, `Ty::Token`. A binding of the same name (`biar token = …`, a parameter) shadows it in its scope, where the name reads as the variable |
| `KwConsensus` | `konsensus`, `consensus` | reserved | |
| `KwShariahCompliant` | `patuh_syariah`, `shariah_compliant` | construct | types only: `patuh_syariah<T>` is `Ty::SyariahCompliant`, which no expression produces |
| `KwMudarabah` | `mudarabah` | reserved | |
| `KwMusharakah` | `musharakah` | reserved | |
| `KwSukuk` | `sukuk` | reserved | |
| `KwZakat` | `zakat` | construct | `ZakatCalculate(e)`: 2.5%, rounded down |
| `KwTakaful` | `takaful` | reserved | |
| `KwWakaf` | `wakaf` | reserved | |
| `KwPurify` | `tathir`, `purify` | reserved | |

### Other syntax

| Surface | Elaborates to |
|---|---|
| integer literal: `42`, `1_000`, `0xFF`, `0o17`, `0b1010` | `Int(n)`; a literal with no 64-bit value is error P0016 |
| sized literal: `42u8` … `7i64` | `IntN { value, bits, signed }`, range-checked by the lexer. A sized value and a `Nombor` do not mix in either direction, in arguments, annotations or operators: `biar x: i64 = 7` and `x > 0` are type errors (write `7i64`, `0i64`) |
| float literal: `1.5` | error P0015: RIINA has no floating point |
| `"teks"` | `String` |
| `betul`, `salah` (`true`, `false`) | `Bool` |
| `()`, `(e)`, `(a, b, c)` | `Unit`, `e`, `Pair(a, Pair(b, c))` |
| `e.0`, `e.1` | `Fst(e)`, `Snd(e)` |
| `e.f` | `FieldAccess(e, f)` |
| `Nama { f: e }` | `RecordLit(Nama, [(f, e)])` |
| `[a, b]` | `ListLit([a, b])` |
| `e[i]` | a call of the list builtin `senarai_dapat` on `(e, i)` |
| `f(a, b)`, `f a b` | `App(App(f, a), b)`; `f()` is `App(f, Unit)` |
| builtin call `cetak(x)` | `App(Var("cetak"), x)`: a builtin is a name, resolved later (see Builtins) |
| `Nama(a, b)` (capitalized) | `Pair(String("Nama"), Pair(a, b))`, a tagged tuple |
| `a::b`, `std::x` | `Var("a_b")`, `Var("x")`; `Ns::f` with a capitalized namespace is the builtin `f`. A path of three or more segments is error P0017 (it used to keep only the first and last) |
| `+ - * / %`, `== != < <= > >=`, `&&`, `\|\|` | `BinOp`; `+` also concatenates strings |
| `!e` | `Deref(e)`: a dereference on a reference, negation on a `Bool` (riinac chooses by the operand's type; `bukan e` is the keyword form) |
| unary `-e` | no production: write `0 - e` |
| `a := b` | `Assign(a, b)` |
| `x = e` | `SlotSet(x, e)` if `x` is a `biar ubah` slot; otherwise a new `Let(x, …)` that shadows `x` |
| `a \|> f` | `App(f, a)` |
| `a..b`, `a..=b` | calls of the range builtins `julat`, `julat_inklusif` |
| `format!("…{}…", a)` | a `BinOp::Add` chain of the pieces and `ke_teks(a)` |
| `{ s1; s2; e }` (a block body) | `Let(_, s1, Let(_, s2, e))` |
| `kesan E`, `kesan (A, B)`, `kesan ()` | the function's latent `EffectSet`; `()` is pure |
| `Fn(A) -> R kesan E` (type) | `Ty::Fn(A, R, E)`; `Fn(A, B) -> R kesan E` curries to `Ty::Fn(A, Fn(B, R, E), E)`, as a `fungsi` type does; `Fn() -> R` takes `Unit`. The legacy `Fn(A, R, E)` form takes an effect third, and a type there is an error |
| `Hasil<T, E>` (`Result`), `Kosong` (types) | `Ty::Sum(T, E)`, the type `Jadi`/`Gagal` build; `Ty::Unit` |
| an alias `N` (`jenis N = T;`) | `T`. Used above its declaration, or in its own definition, it is error P0021 |
| a record or variant type name, or a generic parameter `T` of `fungsi f<T>` | `Ty::Any`: the checker has no record or variant types, and generics are not instantiated (REQ-93(c)) |
| any other type name, including `Peta<…>` | error P0020, with the nearest known name. Types are local to the file that declares them: `guna` imports functions only |
| a type declared twice, or a type or generic parameter with a built-in type's name | error P0022 |
| a generic alias `jenis N<T> = …;`, `awam` on a type, a bound `fungsi f<T: S>` | error P0023 (the bound and `awam` used to be skipped, and `awam` then applied to the next declaration) |

### Builtins

A builtin call is `App(Var(name), arg)`: the core has no builtins, so every
builtin call is outside the proofs. Every builtin, its effect and the backends
that implement it are listed, generated from the compiler's registry, in
[docs/api/STDLIB.md](../api/STDLIB.md). Specifying each one in Coq (its effect,
security label and, where the model has one, its semantics) is mandate
S1.10(i), part of REQ-99.
