// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `riinac emit-core`: the core term a program elaborates to (REQ-110,
//! mandate S1.2).
//!
//! The term is written with the constructors of the Coq core
//! (`02_FORMAL/coq/foundations/Syntax.v`) one-to-one, as an S-expression:
//!
//! * a constructor with arguments is `(Name arg …)`; one without is `Name`;
//! * `nat` and `N` are decimal, `bool` is `true`/`false`;
//! * `string` and `ident` are `"…"`. Printable ASCII is written as itself,
//!   except `"` and `\`, which are escaped as `\"` and `\\`. Every other byte
//!   of the UTF-8 text is written as `\xHH`.
//! * `list string` is `(list "a" "b")`.
//!
//! The output is canonical: [`parse`] accepts exactly what [`print`] writes,
//! and `print(parse(s)) == s`.
//!
//! A construct that `docs/spec/CORE_MAPPING.md` marks `unmodelled` has no Coq
//! constructor, so it is an error (mandate R3). It is never dropped or
//! approximated. Calls of builtins are errors for the same reason: the core
//! has no builtins.

use riina_types::{
    Capability, CapabilityKind, Effect, EffectSet, Expr, Ident, Sanitizer, SecurityLevel,
    SessionType, TaintSource, Ty,
};

/// A core term: a Coq constructor applied to its arguments, or a literal.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Term {
    Ctor(&'static str, Vec<Term>),
    Nat(u64),
    Bool(bool),
    Str(String),
    List(Vec<Term>),
}

fn c(name: &'static str, args: Vec<Term>) -> Term {
    Term::Ctor(name, args)
}

fn c0(name: &'static str) -> Term {
    Term::Ctor(name, Vec::new())
}

fn s(text: &str) -> Term {
    Term::Str(text.to_string())
}

// --------------------------------------------------------------------------
// The Coq signatures
// --------------------------------------------------------------------------

/// Argument sorts. The leaf sorts are Coq's `nat`, `N` (binary), `bool`,
/// `string` (which `ident` is) and `list string`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Sort {
    Expr,
    Ty,
    Effect,
    Level,
    Taint,
    Sanitizer,
    CapKind,
    Cap,
    Session,
    Nat,
    N,
    Bool,
    Str,
    StrList,
}

impl Sort {
    /// The Coq name of the sort, as `Syntax.v` writes it in a signature.
    pub const fn coq(self) -> &'static str {
        match self {
            Self::Expr => "expr",
            Self::Ty => "ty",
            Self::Effect => "effect",
            Self::Level => "security_level",
            Self::Taint => "taint_source",
            Self::Sanitizer => "sanitizer",
            Self::CapKind => "capability_kind",
            Self::Cap => "capability",
            Self::Session => "session_type",
            Self::Nat => "nat",
            Self::N => "N",
            Self::Bool => "bool",
            Self::Str => "string",
            Self::StrList => "list string",
        }
    }
}

use Sort as K;

/// Every constructor `emit-core` may write: (sort, name, argument sorts).
/// `tests/emit_core.rs` holds this table to the inductives in `Syntax.v`, so
/// a constructor added, removed or changed there fails the build.
pub const SIGNATURES: &[(Sort, &str, &[Sort])] = &[
    (K::Level, "LPublic", &[]),
    (K::Level, "LInternal", &[]),
    (K::Level, "LSession", &[]),
    (K::Level, "LUser", &[]),
    (K::Level, "LSystem", &[]),
    (K::Level, "LSecret", &[]),
    (K::Effect, "EffPure", &[]),
    (K::Effect, "EffRead", &[]),
    (K::Effect, "EffWrite", &[]),
    (K::Effect, "EffFileSystem", &[]),
    (K::Effect, "EffNetwork", &[]),
    (K::Effect, "EffNetSecure", &[]),
    (K::Effect, "EffCrypto", &[]),
    (K::Effect, "EffRandom", &[]),
    (K::Effect, "EffSystem", &[]),
    (K::Effect, "EffTime", &[]),
    (K::Effect, "EffProcess", &[]),
    (K::Effect, "EffPanel", &[]),
    (K::Effect, "EffZirah", &[]),
    (K::Effect, "EffBenteng", &[]),
    (K::Effect, "EffSandi", &[]),
    (K::Effect, "EffMenara", &[]),
    (K::Effect, "EffGapura", &[]),
    (K::Taint, "TaintNetworkExternal", &[]),
    (K::Taint, "TaintNetworkInternal", &[]),
    (K::Taint, "TaintUserInput", &[]),
    (K::Taint, "TaintFileSystem", &[]),
    (K::Taint, "TaintDatabase", &[]),
    (K::Taint, "TaintEnvironment", &[]),
    (K::Taint, "TaintGapuraRequest", &[]),
    (K::Taint, "TaintZirahEvent", &[]),
    (K::Taint, "TaintZirahEndpoint", &[]),
    (K::Taint, "TaintBentengBiometric", &[]),
    (K::Taint, "TaintSandiSignature", &[]),
    (K::Taint, "TaintMenaraDevice", &[]),
    (K::Sanitizer, "SanHtmlEscape", &[]),
    (K::Sanitizer, "SanUrlEncode", &[]),
    (K::Sanitizer, "SanJsEscape", &[]),
    (K::Sanitizer, "SanCssEscape", &[]),
    (K::Sanitizer, "SanJsonEscape", &[]),
    (K::Sanitizer, "SanSqlEscape", &[]),
    (K::Sanitizer, "SanSqlParam", &[]),
    (K::Sanitizer, "SanXssFilter", &[]),
    (K::Sanitizer, "SanPathTraversal", &[]),
    (K::Sanitizer, "SanCommandEscape", &[]),
    (K::Sanitizer, "SanLdapEscape", &[]),
    (K::Sanitizer, "SanXmlEscape", &[]),
    (K::Sanitizer, "SanJsonValidation", &[]),
    (K::Sanitizer, "SanXmlValidation", &[]),
    (K::Sanitizer, "SanEmailValidation", &[]),
    (K::Sanitizer, "SanPhoneValidation", &[]),
    (K::Sanitizer, "SanLengthBound", &[K::Nat]),
    (K::Sanitizer, "SanRangeBound", &[K::Nat, K::Nat]),
    (K::Sanitizer, "SanRegexMatch", &[K::Str]),
    (K::Sanitizer, "SanWhitelist", &[K::StrList]),
    (K::Sanitizer, "SanHashVerify", &[]),
    (K::Sanitizer, "SanSignatureVerify", &[]),
    (K::Sanitizer, "SanMacVerify", &[]),
    (K::Sanitizer, "SanGapuraAuth", &[]),
    (K::Sanitizer, "SanZirahSession", &[]),
    (K::Sanitizer, "SanBentengBiometric", &[]),
    (K::Sanitizer, "SanSandiDecrypt", &[]),
    (K::Sanitizer, "SanMenaraAttestation", &[]),
    (K::CapKind, "CapFileRead", &[]),
    (K::CapKind, "CapFileWrite", &[]),
    (K::CapKind, "CapFileExecute", &[]),
    (K::CapKind, "CapFileDelete", &[]),
    (K::CapKind, "CapNetConnect", &[]),
    (K::CapKind, "CapNetListen", &[]),
    (K::CapKind, "CapNetBind", &[]),
    (K::CapKind, "CapProcSpawn", &[]),
    (K::CapKind, "CapProcSignal", &[]),
    (K::CapKind, "CapSysTime", &[]),
    (K::CapKind, "CapSysRandom", &[]),
    (K::CapKind, "CapSysEnv", &[]),
    (K::CapKind, "CapRootProduct", &[]),
    (K::CapKind, "CapProductAccess", &[]),
    (K::Cap, "CapBasic", &[K::CapKind]),
    (K::Cap, "CapRevocable", &[K::Cap]),
    (K::Cap, "CapTimeBound", &[K::Cap, K::Nat]),
    (K::Cap, "CapDelegated", &[K::Cap, K::Str]),
    (K::Ty, "TUnit", &[]),
    (K::Ty, "TBool", &[]),
    (K::Ty, "TInt", &[]),
    (K::Ty, "TString", &[]),
    (K::Ty, "TBytes", &[]),
    (K::Ty, "TFn", &[K::Ty, K::Ty, K::Effect]),
    (K::Ty, "TProd", &[K::Ty, K::Ty]),
    (K::Ty, "TSum", &[K::Ty, K::Ty]),
    (K::Ty, "TList", &[K::Ty]),
    (K::Ty, "TOption", &[K::Ty]),
    (K::Ty, "TRef", &[K::Ty, K::Level]),
    (K::Ty, "TSecret", &[K::Ty]),
    (K::Ty, "TLabeled", &[K::Ty, K::Level]),
    (K::Ty, "TTainted", &[K::Ty, K::Taint]),
    (K::Ty, "TSanitized", &[K::Ty, K::Sanitizer]),
    (K::Ty, "TProof", &[K::Ty]),
    (K::Ty, "TCapability", &[K::CapKind]),
    (K::Ty, "TCapabilityFull", &[K::Cap]),
    (K::Ty, "TChan", &[K::Session]),
    (K::Ty, "TSecureChan", &[K::Session, K::Level]),
    (K::Ty, "TConstantTime", &[K::Ty]),
    (K::Ty, "TZeroizing", &[K::Ty]),
    (K::Session, "SessEnd", &[]),
    (K::Session, "SessSend", &[K::Ty, K::Session]),
    (K::Session, "SessRecv", &[K::Ty, K::Session]),
    (K::Session, "SessSelect", &[K::Session, K::Session]),
    (K::Session, "SessBranch", &[K::Session, K::Session]),
    (K::Session, "SessRec", &[K::Str, K::Session]),
    (K::Session, "SessVar", &[K::Str]),
    (K::Expr, "EUnit", &[]),
    (K::Expr, "EBool", &[K::Bool]),
    (K::Expr, "EInt", &[K::N]),
    (K::Expr, "EString", &[K::Str]),
    (K::Expr, "ELoc", &[K::Nat]),
    (K::Expr, "EVar", &[K::Str]),
    (K::Expr, "ELam", &[K::Str, K::Ty, K::Expr]),
    (K::Expr, "EApp", &[K::Expr, K::Expr]),
    (K::Expr, "EPair", &[K::Expr, K::Expr]),
    (K::Expr, "EFst", &[K::Expr]),
    (K::Expr, "ESnd", &[K::Expr]),
    (K::Expr, "EInl", &[K::Expr, K::Ty]),
    (K::Expr, "EInr", &[K::Expr, K::Ty]),
    (
        K::Expr,
        "ECase",
        &[K::Expr, K::Str, K::Expr, K::Str, K::Expr],
    ),
    (K::Expr, "EIf", &[K::Expr, K::Expr, K::Expr]),
    (K::Expr, "ELet", &[K::Str, K::Expr, K::Expr]),
    (K::Expr, "EPerform", &[K::Effect, K::Expr]),
    (K::Expr, "EHandle", &[K::Expr, K::Str, K::Expr]),
    (K::Expr, "ERef", &[K::Expr, K::Level]),
    (K::Expr, "EDeref", &[K::Expr]),
    (K::Expr, "EAssign", &[K::Expr, K::Expr]),
    (K::Expr, "EClassify", &[K::Expr]),
    (K::Expr, "EDeclassify", &[K::Expr, K::Expr]),
    (K::Expr, "EProve", &[K::Expr]),
    (K::Expr, "EFix", &[K::Expr]),
    (K::Expr, "ERequire", &[K::Effect, K::Expr]),
    (K::Expr, "EGrant", &[K::Effect, K::Expr]),
];

fn signature(name: &str) -> Option<(Sort, &'static str, &'static [Sort])> {
    SIGNATURES.iter().find(|(_, n, _)| *n == name).copied()
}

/// Check that `t` is a well-formed Coq term of sort `want`.
pub fn validate(t: &Term, want: Sort) -> Result<(), String> {
    match (t, want) {
        (Term::Nat(_), Sort::Nat | Sort::N)
        | (Term::Bool(_), Sort::Bool)
        | (Term::Str(_), Sort::Str) => Ok(()),
        (Term::List(items), Sort::StrList) => items.iter().try_for_each(|i| validate(i, Sort::Str)),
        (Term::Ctor(name, args), _) => {
            let (sort, _, sig) =
                signature(name).ok_or_else(|| format!("`{name}` is not a Coq constructor"))?;
            if sort != want {
                return Err(format!(
                    "`{name}` is a {}, not a {}",
                    sort.coq(),
                    want.coq()
                ));
            }
            if args.len() != sig.len() {
                return Err(format!(
                    "`{name}` takes {} arguments, not {}",
                    sig.len(),
                    args.len()
                ));
            }
            args.iter().zip(sig).try_for_each(|(a, s)| validate(a, *s))
        }
        _ => Err(format!("{} where a {} was expected", print(t), want.coq())),
    }
}

// --------------------------------------------------------------------------
// Printing and parsing
// --------------------------------------------------------------------------

/// The canonical text of a term.
pub fn print(t: &Term) -> String {
    let mut out = String::new();
    write_term(t, &mut out);
    out
}

fn write_term(t: &Term, out: &mut String) {
    match t {
        Term::Ctor(name, args) if args.is_empty() => out.push_str(name),
        Term::Ctor(name, args) => {
            out.push('(');
            out.push_str(name);
            for a in args {
                out.push(' ');
                write_term(a, out);
            }
            out.push(')');
        }
        Term::Nat(n) => out.push_str(&n.to_string()),
        Term::Bool(b) => out.push_str(if *b { "true" } else { "false" }),
        Term::Str(text) => {
            out.push('"');
            for byte in text.bytes() {
                match byte {
                    b'"' => out.push_str("\\\""),
                    b'\\' => out.push_str("\\\\"),
                    0x20..=0x7e => out.push(char::from(byte)),
                    _ => out.push_str(&format!("\\x{byte:02x}")),
                }
            }
            out.push('"');
        }
        Term::List(items) => {
            out.push_str("(list");
            for i in items {
                out.push(' ');
                write_term(i, out);
            }
            out.push(')');
        }
    }
}

/// Parse the canonical text [`print`] writes. Anything else is an error,
/// including a different spelling of the same term.
pub fn parse(text: &str) -> Result<Term, String> {
    let bytes = text.as_bytes();
    let mut pos = 0;
    let t = parse_term(bytes, &mut pos)?;
    if pos != bytes.len() {
        return Err(format!("trailing text at byte {pos}"));
    }
    Ok(t)
}

fn parse_term(b: &[u8], pos: &mut usize) -> Result<Term, String> {
    match b.get(*pos) {
        None => Err("unexpected end of input".to_string()),
        Some(b'(') => {
            *pos += 1;
            let head = parse_atom(b, pos)?;
            let mut args = Vec::new();
            loop {
                match b.get(*pos) {
                    Some(b')') => {
                        *pos += 1;
                        break;
                    }
                    Some(b' ') => {
                        *pos += 1;
                        args.push(parse_term(b, pos)?);
                    }
                    _ => return Err(format!("expected ' ' or ')' at byte {}", *pos)),
                }
            }
            if head == "list" {
                return Ok(Term::List(args));
            }
            if args.is_empty() {
                return Err(format!(
                    "`({head})`: a constructor without arguments is written bare"
                ));
            }
            let (_, name, _) =
                signature(&head).ok_or_else(|| format!("`{head}` is not a Coq constructor"))?;
            Ok(Term::Ctor(name, args))
        }
        Some(b'"') => parse_string(b, pos).map(Term::Str),
        Some(_) => {
            let atom = parse_atom(b, pos)?;
            match atom.as_str() {
                "true" => Ok(Term::Bool(true)),
                "false" => Ok(Term::Bool(false)),
                a if a.bytes().all(|d| d.is_ascii_digit()) => {
                    if a.len() > 1 && a.starts_with('0') {
                        return Err(format!("`{a}`: a number has no leading zero"));
                    }
                    a.parse()
                        .map(Term::Nat)
                        .map_err(|_| format!("`{a}` does not fit in 64 bits"))
                }
                a => {
                    let (_, name, _) =
                        signature(a).ok_or_else(|| format!("`{a}` is not a Coq constructor"))?;
                    Ok(Term::Ctor(name, Vec::new()))
                }
            }
        }
    }
}

fn parse_atom(b: &[u8], pos: &mut usize) -> Result<String, String> {
    let start = *pos;
    while matches!(b.get(*pos), Some(c) if c.is_ascii_alphanumeric() || *c == b'_') {
        *pos += 1;
    }
    if *pos == start {
        return Err(format!("expected a name or number at byte {start}"));
    }
    Ok(String::from_utf8_lossy(&b[start..*pos]).into_owned())
}

fn parse_string(b: &[u8], pos: &mut usize) -> Result<String, String> {
    *pos += 1; // opening quote
    let mut out = Vec::new();
    loop {
        match b.get(*pos) {
            None => return Err("unterminated string".to_string()),
            Some(b'"') => {
                *pos += 1;
                break;
            }
            Some(b'\\') => {
                match b.get(*pos + 1) {
                    Some(b'"') => out.push(b'"'),
                    Some(b'\\') => out.push(b'\\'),
                    Some(b'x') => {
                        let hex = b.get(*pos + 2..*pos + 4).ok_or("truncated \\x escape")?;
                        let hex = std::str::from_utf8(hex).map_err(|_| "bad \\x escape")?;
                        let byte = u8::from_str_radix(hex, 16).map_err(|_| "bad \\x escape")?;
                        if (0x20..=0x7e).contains(&byte) && byte != b'"' && byte != b'\\' {
                            return Err(format!(
                                "`\\x{hex}` is printable and is written as itself"
                            ));
                        }
                        if !hex
                            .bytes()
                            .all(|h| h.is_ascii_digit() || (b'a'..=b'f').contains(&h))
                        {
                            return Err(format!("`\\x{hex}`: escapes are lower-case"));
                        }
                        out.push(byte);
                        *pos += 2;
                    }
                    _ => return Err(format!("unknown escape at byte {}", *pos)),
                }
                *pos += 2;
            }
            Some(&byte) if (0x20..=0x7e).contains(&byte) => {
                out.push(byte);
                *pos += 1;
            }
            Some(_) => return Err(format!("unescaped byte at {}", *pos)),
        }
    }
    String::from_utf8(out).map_err(|_| "string is not UTF-8".to_string())
}

// --------------------------------------------------------------------------
// Elaboration: Rust `Expr` to the core term
// --------------------------------------------------------------------------

/// A construct with no Coq counterpart: the CORE_MAPPING row it falls under,
/// and what in the program used it.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Unmodelled {
    pub row: String,
    pub detail: String,
}

impl std::fmt::Display for Unmodelled {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}: the Coq core cannot express this [CORE_MAPPING.md: {}]; emit-core rejects it \
             rather than approximate it (mandate R3; REQ-99 extends the core)",
            self.detail, self.row
        )
    }
}

fn unmodelled(row: &str, detail: impl Into<String>) -> Unmodelled {
    Unmodelled {
        row: row.to_string(),
        detail: detail.into(),
    }
}

/// The name the ascription `e : T` binds: `EApp (ELam y T (EVar y)) e`.
/// `y` is bound only around its own use, so no name in `e` can be captured.
pub const ASCRIBE_BINDER: &str = "ascribed";

/// Elaborate a desugared program (`Program::desugar`) into a core term.
/// `is_builtin` names the builtins: a free name that is one has no Coq
/// meaning and is an error.
pub fn elaborate(e: &Expr, is_builtin: &dyn Fn(&str) -> bool) -> Result<Term, Unmodelled> {
    let t = Elab { is_builtin }.expr(e, &mut Vec::new())?;
    Ok(negations(t, &mut Vec::new()))
}

/// The core type of a Rust type (the `Ty` table of CORE_MAPPING).
pub fn core_ty(t: &Ty) -> Result<Term, Unmodelled> {
    Elab {
        is_builtin: &|_| false,
    }
    .ty(t)
}

/// A Rust effect set as one Coq effect: its join in Coq's order.
pub fn core_effect_set(set: EffectSet) -> Result<Term, Unmodelled> {
    Elab {
        is_builtin: &|_| false,
    }
    .effect_set(set)
}

/// The text `riinac emit-core` prints. Before printing, the term is checked
/// against [`SIGNATURES`] and its text is parsed back and compared, so a term
/// that is not well-sorted Coq, or that would not round-trip, is never written.
pub fn emit(e: &Expr, is_builtin: &dyn Fn(&str) -> bool) -> Result<String, String> {
    let t = elaborate(e, is_builtin).map_err(|u| u.to_string())?;
    validate(&t, Sort::Expr)
        .map_err(|m| format!("internal error: emitted an ill-sorted term: {m}"))?;
    let text = print(&t);
    match parse(&text) {
        Ok(back) if back == t => Ok(text),
        Ok(_) => Err("internal error: the printed term parses to a different term".to_string()),
        Err(m) => Err(format!(
            "internal error: the printed term does not parse: {m}"
        )),
    }
}

struct Elab<'a> {
    is_builtin: &'a dyn Fn(&str) -> bool,
}

impl Elab<'_> {
    /// `scope` is the names bound around `e`, innermost last.
    #[allow(clippy::too_many_lines)]
    fn expr(&self, e: &Expr, scope: &mut Vec<Ident>) -> Result<Term, Unmodelled> {
        Ok(match e {
            Expr::Unit => c0("EUnit"),
            Expr::Bool(b) => c("EBool", vec![Term::Bool(*b)]),
            Expr::Int(n) => c("EInt", vec![Term::Nat(*n)]),
            Expr::String(text) => c("EString", vec![s(text)]),
            Expr::Loc(l) => c("ELoc", vec![Term::Nat(*l)]),
            Expr::Var(x) => {
                if !scope.contains(x) && (self.is_builtin)(x) {
                    return Err(unmodelled(
                        "Builtins",
                        format!(
                            "the builtin `{x}` (the core has no builtins; see docs/api/STDLIB.md)"
                        ),
                    ));
                }
                c("EVar", vec![s(x)])
            }
            Expr::Lam(x, ty, body) => {
                let t = self.ty(ty)?;
                let b = self.bind(x, body, scope)?;
                c("ELam", vec![s(x), t, b])
            }
            Expr::App(f, a) => c("EApp", vec![self.expr(f, scope)?, self.expr(a, scope)?]),
            Expr::Pair(a, b) => c("EPair", vec![self.expr(a, scope)?, self.expr(b, scope)?]),
            Expr::Fst(a) => c("EFst", vec![self.expr(a, scope)?]),
            Expr::Snd(a) => c("ESnd", vec![self.expr(a, scope)?]),
            Expr::Inl(a, ty) => self.inject(true, a, ty, scope)?,
            Expr::Inr(a, ty) => self.inject(false, a, ty, scope)?,
            Expr::Case(scrut, x, l, y, r) => c(
                "ECase",
                vec![
                    self.expr(scrut, scope)?,
                    s(x),
                    self.bind(x, l, scope)?,
                    s(y),
                    self.bind(y, r, scope)?,
                ],
            ),
            Expr::If(a, b, d) => c(
                "EIf",
                vec![
                    self.expr(a, scope)?,
                    self.expr(b, scope)?,
                    self.expr(d, scope)?,
                ],
            ),
            Expr::Let(x, linearity, bound, body) => {
                if let Some(l) = linearity {
                    return Err(unmodelled(
                        &format!("Linearity::{l:?}"),
                        format!("the `{l:?}` qualifier on `{x}`"),
                    ));
                }
                let b = self.expr(bound, scope)?;
                c("ELet", vec![s(x), b, self.bind(x, body, scope)?])
            }
            Expr::Ascribe(a, ty) => self.ascribe(self.expr(a, scope)?, ty)?,
            Expr::Perform(eff, a) => c("EPerform", vec![self.effect(*eff)?, self.expr(a, scope)?]),
            Expr::Handle(a, x, h) => c(
                "EHandle",
                vec![self.expr(a, scope)?, s(x), self.bind(x, h, scope)?],
            ),
            Expr::Ref(a, l) => c("ERef", vec![self.expr(a, scope)?, level(*l)]),
            Expr::Deref(a) => c("EDeref", vec![self.expr(a, scope)?]),
            Expr::Assign(a, b) => c("EAssign", vec![self.expr(a, scope)?, self.expr(b, scope)?]),
            Expr::Classify(a) => c("EClassify", vec![self.expr(a, scope)?]),
            Expr::Declassify(a, p) => c(
                "EDeclassify",
                vec![self.expr(a, scope)?, self.expr(p, scope)?],
            ),
            Expr::Prove(a) => c("EProve", vec![self.expr(a, scope)?]),
            Expr::Require(eff, a) => c("ERequire", vec![self.effect(*eff)?, self.expr(a, scope)?]),
            Expr::Grant(eff, a) => c("EGrant", vec![self.effect(*eff)?, self.expr(a, scope)?]),
            // `let rec f : T = e1 in e2` is `ELet f (EFix (ELam f T e1)) e2`.
            Expr::LetRec(f, ty, bound, body) => {
                let fix = self.fix(f, ty, bound, scope)?;
                c("ELet", vec![s(f), fix, self.bind(f, body, scope)?])
            }
            Expr::LetRecGroup(group, body) => self.group(group, body, scope)?,
            other => return Err(unmodelled_expr(other)),
        })
    }

    /// Elaborate `body` with `x` bound.
    fn bind(&self, x: &Ident, body: &Expr, scope: &mut Vec<Ident>) -> Result<Term, Unmodelled> {
        scope.push(x.clone());
        let t = self.expr(body, scope);
        scope.pop();
        t
    }

    /// Rust's `Inl(e, A + B)` carries the whole sum type and checks `e : A`;
    /// Coq's `EInl e B` carries only the other side. So `inl` is written
    /// `EInl e B` ascribed to `A + B`, which keeps riinac's check of `A`
    /// (and `inr` likewise, with `EInr e A`).
    fn inject(
        &self,
        left: bool,
        e: &Expr,
        ty: &Ty,
        scope: &mut Vec<Ident>,
    ) -> Result<Term, Unmodelled> {
        let Ty::Sum(l, r) = ty else {
            self.ty(ty)?;
            let which = if left { "Expr::Inl" } else { "Expr::Inr" };
            return Err(unmodelled(
                which,
                format!("an injection annotated with the non-sum type `{ty:?}`"),
            ));
        };
        let payload = self.expr(e, scope)?;
        let inj = if left {
            c("EInl", vec![payload, self.ty(r)?])
        } else {
            c("EInr", vec![payload, self.ty(l)?])
        };
        self.ascribe(inj, ty)
    }

    fn ascribe(&self, e: Term, ty: &Ty) -> Result<Term, Unmodelled> {
        Ok(c(
            "EApp",
            vec![
                c(
                    "ELam",
                    vec![
                        s(ASCRIBE_BINDER),
                        self.ty(ty)?,
                        c("EVar", vec![s(ASCRIBE_BINDER)]),
                    ],
                ),
                e,
            ],
        ))
    }

    fn fix(
        &self,
        f: &Ident,
        ty: &Ty,
        bound: &Expr,
        scope: &mut Vec<Ident>,
    ) -> Result<Term, Unmodelled> {
        let t = self.ty(ty)?;
        let b = self.declared(self.bind(f, bound, scope)?, ty)?;
        Ok(c("EFix", vec![c("ELam", vec![s(f), t, b])]))
    }

    /// A function bound at a declared type `A1 -> … -> R` with latent effect
    /// `E` at each arrow (`declared_fn_ty`). Rust checks each body against `E`
    /// as an upper bound; Coq's core has no subeffecting, so its latent effect
    /// is exactly the body's. Each lambda body is therefore written
    /// `ERequire E body`: `T_Require` joins `E` into the body's effect, which
    /// makes Coq's latent effect exactly `E` whenever riinac accepts the body,
    /// and `ST_RequireValue` steps to the value, so nothing else changes. A
    /// pure arrow needs no wrapper.
    fn declared(&self, lam: Term, ty: &Ty) -> Result<Term, Unmodelled> {
        let (Term::Ctor("ELam", mut args), Ty::Fn(_, ret, eff)) = (lam.clone(), ty) else {
            return Ok(lam);
        };
        let body = self.declared(args.pop().expect("ELam has a body"), ret)?;
        let body = if eff.is_pure() {
            body
        } else {
            c("ERequire", vec![self.effect_set(*eff)?, body])
        };
        args.push(body);
        Ok(Term::Ctor("ELam", args))
    }

    /// A top-level function group (`Program::desugar` makes one of every run
    /// of `fungsi` declarations). Every name of the group is in scope in
    /// every body. The group is split into its strongly connected components
    /// by which functions call which, and bound innermost-last in dependency
    /// order (source order among independent ones): a self-recursive function
    /// is `ELet f (EFix (ELam f T e))`, any other is `ELet f (e : T)`. A
    /// component of two or more mutually recursive functions has no encoding.
    fn group(
        &self,
        group: &[(Ident, Ty, Expr)],
        body: &Expr,
        scope: &mut Vec<Ident>,
    ) -> Result<Term, Unmodelled> {
        let names: Vec<&Ident> = group.iter().map(|(n, _, _)| n).collect();
        let base = scope.len();
        scope.extend(names.iter().map(|n| (*n).clone()));
        let mut bodies = Vec::with_capacity(group.len());
        for (_, _, e) in group {
            match self.expr(e, scope) {
                Ok(t) => bodies.push(t),
                Err(err) => {
                    scope.truncate(base);
                    return Err(err);
                }
            }
        }
        let cont = self.expr(body, scope);
        scope.truncate(base);
        let cont = cont?;

        // deps[i]: the group members whose names occur free in body i.
        let deps: Vec<Vec<usize>> = bodies
            .iter()
            .map(|t| {
                let free = free_vars(t);
                (0..names.len())
                    .filter(|j| free.contains(names[*j]))
                    .collect()
            })
            .collect();
        if let Some(cycle) = mutual_component(&deps) {
            let list: Vec<String> = cycle.iter().map(|i| format!("`{}`", names[*i])).collect();
            return Err(unmodelled(
                "Expr::LetRecGroup",
                format!("the mutually recursive functions {}", list.join(", ")),
            ));
        }
        // Dependency order; source order among independent functions.
        let mut placed: Vec<usize> = Vec::with_capacity(names.len());
        while placed.len() < names.len() {
            let next = (0..names.len())
                .find(|i| {
                    !placed.contains(i) && deps[*i].iter().all(|d| d == i || placed.contains(d))
                })
                .expect("an acyclic group always has a member whose dependencies are placed");
            placed.push(next);
        }
        let mut result = cont;
        for &i in placed.iter().rev() {
            let (name, ty, _) = &group[i];
            // `bodies[i]` was elaborated with every group name in scope, so it
            // is already the body `e` of `EFix (ELam f T e)`.
            let body = self.declared(bodies[i].clone(), ty)?;
            let bound = if deps[i].contains(&i) {
                c("EFix", vec![c("ELam", vec![s(name), self.ty(ty)?, body])])
            } else {
                self.ascribe(body, ty)?
            };
            result = c("ELet", vec![s(name), bound, result]);
        }
        Ok(result)
    }

    fn effect(&self, e: Effect) -> Result<Term, Unmodelled> {
        coq_effect(e).map(|(name, _)| c0(name))
    }

    /// Coq's latent effect is one `effect`; Rust's is a set. The set is
    /// written as its join in Coq's order (`effect_join` is the maximum
    /// `effect_level`); the empty set is `EffPure`.
    fn effect_set(&self, set: EffectSet) -> Result<Term, Unmodelled> {
        let mut best: (&'static str, u8) = ("EffPure", 0);
        for e in set.iter() {
            let (name, lvl) = coq_effect(e)?;
            if lvl > best.1 {
                best = (name, lvl);
            }
        }
        Ok(c0(best.0))
    }

    fn ty(&self, t: &Ty) -> Result<Term, Unmodelled> {
        let one =
            |name, inner: &Ty| -> Result<Term, Unmodelled> { Ok(c(name, vec![self.ty(inner)?])) };
        Ok(match t {
            Ty::Unit => c0("TUnit"),
            Ty::Bool => c0("TBool"),
            Ty::Int => c0("TInt"),
            Ty::String => c0("TString"),
            Ty::Bytes => c0("TBytes"),
            Ty::Fn(a, r, eff) => c(
                "TFn",
                vec![self.ty(a)?, self.ty(r)?, self.effect_set(*eff)?],
            ),
            Ty::Prod(a, b) => c("TProd", vec![self.ty(a)?, self.ty(b)?]),
            Ty::Sum(a, b) => c("TSum", vec![self.ty(a)?, self.ty(b)?]),
            Ty::List(a) => one("TList", a)?,
            Ty::Option(a) => one("TOption", a)?,
            Ty::Ref(a, l) => c("TRef", vec![self.ty(a)?, level(*l)]),
            Ty::Secret(a) => one("TSecret", a)?,
            Ty::Labeled(a, l) => c("TLabeled", vec![self.ty(a)?, level(*l)]),
            Ty::Tainted(a, src) => c("TTainted", vec![self.ty(a)?, c0(taint(*src))]),
            Ty::Sanitized(a, san) => c("TSanitized", vec![self.ty(a)?, sanitizer(san)?]),
            Ty::Proof(a) => one("TProof", a)?,
            Ty::Capability(k) => c("TCapability", vec![c0(cap_kind(*k))]),
            Ty::CapabilityFull(cap) => c("TCapabilityFull", vec![capability(cap)]),
            Ty::Chan(st) => c("TChan", vec![self.session(st)?]),
            Ty::SecureChan(st, l) => c("TSecureChan", vec![self.session(st)?, level(*l)]),
            Ty::ConstantTime(a) => one("TConstantTime", a)?,
            Ty::Zeroizing(a) => one("TZeroizing", a)?,
            other => {
                let name = format!("{other:?}");
                let head = name
                    .split(['(', ' ', '{'])
                    .next()
                    .unwrap_or(&name)
                    .to_string();
                return Err(unmodelled(
                    &format!("Ty::{head}"),
                    format!("the type `{head}`"),
                ));
            }
        })
    }

    fn session(&self, st: &SessionType) -> Result<Term, Unmodelled> {
        Ok(match st {
            SessionType::End => c0("SessEnd"),
            SessionType::Send(t, k) => c("SessSend", vec![self.ty(t)?, self.session(k)?]),
            SessionType::Recv(t, k) => c("SessRecv", vec![self.ty(t)?, self.session(k)?]),
            SessionType::Select(a, b) => c("SessSelect", vec![self.session(a)?, self.session(b)?]),
            SessionType::Branch(a, b) => c("SessBranch", vec![self.session(a)?, self.session(b)?]),
            SessionType::Rec(x, k) => c("SessRec", vec![s(x), self.session(k)?]),
            SessionType::Var(x) => c("SessVar", vec![s(x)]),
        })
    }
}

/// The Coq constructor and `effect_level` of a Rust effect.
fn coq_effect(e: Effect) -> Result<(&'static str, u8), Unmodelled> {
    Ok(match e {
        Effect::Pure => ("EffPure", 0),
        Effect::Read => ("EffRead", 1),
        Effect::Write => ("EffWrite", 2),
        Effect::FileSystem => ("EffFileSystem", 3),
        Effect::Network => ("EffNetwork", 4),
        Effect::NetworkSecure => ("EffNetSecure", 5),
        Effect::Crypto => ("EffCrypto", 6),
        Effect::Random => ("EffRandom", 7),
        Effect::System => ("EffSystem", 8),
        Effect::Time => ("EffTime", 9),
        Effect::Process => ("EffProcess", 10),
        Effect::Panel => ("EffPanel", 11),
        Effect::Zirah => ("EffZirah", 12),
        Effect::Benteng => ("EffBenteng", 13),
        Effect::Sandi => ("EffSandi", 14),
        Effect::Menara => ("EffMenara", 15),
        Effect::Gapura => ("EffGapura", 16),
        Effect::Mut | Effect::Alloc => {
            return Err(unmodelled(
                &format!("Effect::{e:?}"),
                format!("the effect `{e:?}`"),
            ))
        }
    })
}

fn level(l: SecurityLevel) -> Term {
    c0(match l {
        SecurityLevel::Public => "LPublic",
        SecurityLevel::Internal => "LInternal",
        SecurityLevel::Session => "LSession",
        SecurityLevel::User => "LUser",
        SecurityLevel::System => "LSystem",
        SecurityLevel::Secret => "LSecret",
    })
}

const fn taint(t: TaintSource) -> &'static str {
    match t {
        TaintSource::NetworkExternal => "TaintNetworkExternal",
        TaintSource::NetworkInternal => "TaintNetworkInternal",
        TaintSource::UserInput => "TaintUserInput",
        TaintSource::FileSystem => "TaintFileSystem",
        TaintSource::Database => "TaintDatabase",
        TaintSource::Environment => "TaintEnvironment",
        TaintSource::GapuraRequest => "TaintGapuraRequest",
        TaintSource::ZirahEvent => "TaintZirahEvent",
        TaintSource::ZirahEndpoint => "TaintZirahEndpoint",
        TaintSource::BentengBiometric => "TaintBentengBiometric",
        TaintSource::SandiSignature => "TaintSandiSignature",
        TaintSource::MenaraDevice => "TaintMenaraDevice",
    }
}

fn sanitizer(san: &Sanitizer) -> Result<Term, Unmodelled> {
    Ok(match san {
        Sanitizer::HtmlEscape => c0("SanHtmlEscape"),
        Sanitizer::UrlEncode => c0("SanUrlEncode"),
        Sanitizer::JsEscape => c0("SanJsEscape"),
        Sanitizer::CssEscape => c0("SanCssEscape"),
        Sanitizer::JsonEscape => c0("SanJsonEscape"),
        Sanitizer::SqlEscape => c0("SanSqlEscape"),
        Sanitizer::SqlParam => c0("SanSqlParam"),
        Sanitizer::XssFilter => c0("SanXssFilter"),
        Sanitizer::PathTraversal => c0("SanPathTraversal"),
        Sanitizer::CommandEscape => c0("SanCommandEscape"),
        Sanitizer::LdapEscape => c0("SanLdapEscape"),
        Sanitizer::XmlEscape => c0("SanXmlEscape"),
        Sanitizer::JsonValidation => c0("SanJsonValidation"),
        Sanitizer::XmlValidation => c0("SanXmlValidation"),
        Sanitizer::EmailValidation => c0("SanEmailValidation"),
        Sanitizer::PhoneValidation => c0("SanPhoneValidation"),
        Sanitizer::LengthBound(n) => c("SanLengthBound", vec![Term::Nat(*n)]),
        Sanitizer::RangeBound(a, b) => c("SanRangeBound", vec![Term::Nat(*a), Term::Nat(*b)]),
        Sanitizer::RegexMatch(r) => c("SanRegexMatch", vec![s(r)]),
        Sanitizer::Whitelist(items) => c(
            "SanWhitelist",
            vec![Term::List(items.iter().map(|i| s(i)).collect())],
        ),
        Sanitizer::HashVerify => c0("SanHashVerify"),
        Sanitizer::SignatureVerify => c0("SanSignatureVerify"),
        Sanitizer::MacVerify => c0("SanMacVerify"),
        Sanitizer::GapuraAuth => c0("SanGapuraAuth"),
        Sanitizer::ZirahSession => c0("SanZirahSession"),
        Sanitizer::BentengBiometric => c0("SanBentengBiometric"),
        Sanitizer::SandiDecrypt => c0("SanSandiDecrypt"),
        Sanitizer::MenaraAttestation => c0("SanMenaraAttestation"),
        Sanitizer::UrlAllowlist => {
            return Err(unmodelled(
                "Sanitizer::UrlAllowlist",
                "the sanitizer `UrlAllowlist`",
            ))
        }
    })
}

const fn cap_kind(k: CapabilityKind) -> &'static str {
    match k {
        CapabilityKind::FileRead => "CapFileRead",
        CapabilityKind::FileWrite => "CapFileWrite",
        CapabilityKind::FileExecute => "CapFileExecute",
        CapabilityKind::FileDelete => "CapFileDelete",
        CapabilityKind::NetConnect => "CapNetConnect",
        CapabilityKind::NetListen => "CapNetListen",
        CapabilityKind::NetBind => "CapNetBind",
        CapabilityKind::ProcSpawn => "CapProcSpawn",
        CapabilityKind::ProcSignal => "CapProcSignal",
        CapabilityKind::SysTime => "CapSysTime",
        CapabilityKind::SysRandom => "CapSysRandom",
        CapabilityKind::SysEnv => "CapSysEnv",
        CapabilityKind::RootProduct => "CapRootProduct",
        CapabilityKind::ProductAccess => "CapProductAccess",
    }
}

fn capability(cap: &Capability) -> Term {
    match cap {
        Capability::Basic(k) => c("CapBasic", vec![c0(cap_kind(*k))]),
        Capability::Revocable(inner) => c("CapRevocable", vec![capability(inner)]),
        Capability::TimeBound(inner, n) => {
            c("CapTimeBound", vec![capability(inner), Term::Nat(*n)])
        }
        Capability::Delegated(inner, who) => c("CapDelegated", vec![capability(inner), s(who)]),
    }
}

/// The CORE_MAPPING row of an `Expr` variant with no Coq counterpart.
fn unmodelled_expr(e: &Expr) -> Unmodelled {
    let (row, what): (&str, String) = match e {
        Expr::IntN { bits, signed, .. } => (
            "Expr::IntN",
            format!(
                "a sized integer literal ({}{bits})",
                if *signed { 'i' } else { 'u' }
            ),
        ),
        Expr::Return(_) => ("Expr::Return", "`pulang` (early return)".into()),
        Expr::While(..) => ("Expr::While", "a loop".into()),
        Expr::Break => ("Expr::Break", "`putus`".into()),
        Expr::Continue => ("Expr::Continue", "`lanjut`".into()),
        Expr::LetMut(x, ..) => ("Expr::LetMut", format!("the mutable local `{x}`")),
        Expr::SlotGet(x) => (
            "Expr::SlotGet",
            format!("a read of the mutable local `{x}`"),
        ),
        Expr::SlotSet(x, _) => (
            "Expr::SlotSet",
            format!("an assignment to the mutable local `{x}`"),
        ),
        Expr::BinOp(op, ..) => ("Expr::BinOp", format!("the operator {op:?}")),
        Expr::ListLit(_) => ("Expr::ListLit", "a list literal".into()),
        Expr::RecordLit(n, _) => ("Expr::RecordLit", format!("the record literal `{n}`")),
        Expr::FieldAccess(_, f) => ("Expr::FieldAccess", format!("the field access `.{f}`")),
        Expr::FFICall { name, .. } => ("Expr::FFICall", format!("the foreign call `{name}`")),
        Expr::ActorDecl { .. } => ("Expr::ActorDecl", "an actor (`pelaku`)".into()),
        Expr::ChoreographyBlock { .. } => ("Expr::ChoreographyBlock", "a choreography".into()),
        Expr::Spawn(..) => ("Expr::Spawn", "`lahir`".into()),
        Expr::ActorSend(..) => ("Expr::ActorSend", "`hantar`".into()),
        Expr::ActorRecv(_) => ("Expr::ActorRecv", "`terima`".into()),
        Expr::CRDTMerge(..) => ("Expr::CRDTMerge", "`gabung`".into()),
        Expr::ContentHash(_) => ("Expr::ContentHash", "`cincang`".into()),
        Expr::ContentVerify(..) => ("Expr::ContentVerify", "`sahkan`".into()),
        Expr::ContractDeploy(_) => ("Expr::ContractDeploy", "`kontrak_pintar`".into()),
        Expr::TokenTransfer { .. } => ("Expr::TokenTransfer", "`token::pindah`".into()),
        Expr::ZakatCalculate(_) => ("Expr::ZakatCalculate", "`zakat`".into()),
        Expr::UIDisplay(_) => ("Expr::UIDisplay", "`paparan`".into()),
        Expr::UIRow(_) => ("Expr::UIRow", "`baris`".into()),
        Expr::UIColumn(_) => ("Expr::UIColumn", "`lajur`".into()),
        Expr::UIText(..) => ("Expr::UIText", "`tulisan`".into()),
        Expr::UIButton(..) => ("Expr::UIButton", "`butang`".into()),
        Expr::UIColor(..) => ("Expr::UIColor", "`warna`".into()),
        Expr::UIStyleDecl { .. } => ("Expr::UIStyleDecl", "`gaya`".into()),
        Expr::UIContrastCheck(..) => ("Expr::UIContrastCheck", "`kontras`".into()),
        // Every other variant has a Coq counterpart and is handled in
        // `Elab::expr`; reaching here would be a bug in that match.
        other => (
            "Expr",
            format!("an expression emit-core does not handle: {other:?}"),
        ),
    };
    unmodelled(row, what)
}

/// The names that occur free in a core term.
pub fn free_vars(t: &Term) -> std::collections::BTreeSet<String> {
    let mut out = std::collections::BTreeSet::new();
    collect_free(t, &mut Vec::new(), &mut out);
    out
}

fn collect_free(t: &Term, bound: &mut Vec<String>, out: &mut std::collections::BTreeSet<String>) {
    let Term::Ctor(name, args) = t else { return };
    let ident = |i: usize| match &args[i] {
        Term::Str(x) => x.clone(),
        _ => String::new(),
    };
    let under = |x: String, body: &Term, bound: &mut Vec<String>, out: &mut _| {
        bound.push(x);
        collect_free(body, bound, out);
        bound.pop();
    };
    match *name {
        "EVar" => {
            let x = ident(0);
            if !bound.contains(&x) {
                out.insert(x);
            }
        }
        "ELam" => under(ident(0), &args[2], bound, out),
        "ELet" => {
            collect_free(&args[1], bound, out);
            under(ident(0), &args[2], bound, out);
        }
        "ECase" => {
            collect_free(&args[0], bound, out);
            under(ident(1), &args[2], bound, out);
            under(ident(3), &args[4], bound, out);
        }
        "EHandle" => {
            collect_free(&args[0], bound, out);
            under(ident(1), &args[2], bound, out);
        }
        _ => {
            for a in args {
                collect_free(a, bound, out);
            }
        }
    }
}

/// The names bound around a subterm, innermost last, with their core types
/// where those are known.
type TypeEnv = Vec<(String, Option<Term>)>;

/// Resolve `!` (CORE_MAPPING `Expr::Deref`). riinac's checker, interpreter
/// and both backends read `!e` as a dereference when `e` is a reference and
/// as negation when it is a `Bool`; the core has only `EDeref`. So each
/// `EDeref e` whose operand has core type `TBool` is written as `bukan e`'s
/// term, `EIf e (EBool false) (EBool true)`.
///
/// The operand's type is read off the annotated term ([`type_of`]). A wrong
/// answer cannot hide a discrepancy: it leaves a term Coq judges differently
/// from riinac, and the REQ-111 gate reports that.
fn negations(t: Term, env: &mut TypeEnv) -> Term {
    let Term::Ctor(name, mut args) = t else {
        return t;
    };
    let ident = |t: &Term| match t {
        Term::Str(x) => x.clone(),
        _ => String::new(),
    };
    let take = |slot: &mut Term| std::mem::replace(slot, Term::Nat(0));
    let under = |x: String, ty: Option<Term>, body: &mut Term, env: &mut TypeEnv| {
        env.push((x, ty));
        *body = negations(take(body), env);
        env.pop();
    };
    match name {
        "ELam" => {
            let (x, ty) = (ident(&args[0]), Some(args[1].clone()));
            under(x, ty, &mut args[2], env);
        }
        "ELet" => {
            args[1] = negations(take(&mut args[1]), env);
            let (x, ty) = (ident(&args[0]), type_of(&args[1], env));
            under(x, ty, &mut args[2], env);
        }
        "ECase" => {
            args[0] = negations(take(&mut args[0]), env);
            let (l, r) = match type_of(&args[0], env) {
                Some(Term::Ctor("TSum", mut lr)) => {
                    (Some(take(&mut lr[0])), Some(take(&mut lr[1])))
                }
                _ => (None, None),
            };
            let (x, y) = (ident(&args[1]), ident(&args[3]));
            under(x, l, &mut args[2], env);
            under(y, r, &mut args[4], env);
        }
        "EHandle" => {
            args[0] = negations(take(&mut args[0]), env);
            let (x, ty) = (ident(&args[1]), type_of(&args[0], env));
            under(x, ty, &mut args[2], env);
        }
        "EDeref" => {
            let e = negations(take(&mut args[0]), env);
            if type_of(&e, env) == Some(c0("TBool")) {
                return c(
                    "EIf",
                    vec![
                        e,
                        c("EBool", vec![Term::Bool(false)]),
                        c("EBool", vec![Term::Bool(true)]),
                    ],
                );
            }
            args[0] = e;
        }
        _ => {
            for a in &mut args {
                *a = negations(take(a), env);
            }
        }
    }
    Term::Ctor(name, args)
}

/// The core type of `t` as Coq's `has_type` assigns it, read off the term's
/// annotations, or `None` when it is not determined (an ill-typed term, or
/// `ELoc`). Only the shape matters to [`negations`], so a function type's
/// latent effect is not computed (it is written `EffPure`).
fn type_of(t: &Term, env: &mut TypeEnv) -> Option<Term> {
    let Term::Ctor(name, a) = t else { return None };
    let ident = |i: usize| match &a[i] {
        Term::Str(x) => x.clone(),
        _ => String::new(),
    };
    let under = |x: String, ty: Option<Term>, body: &Term, env: &mut TypeEnv| {
        env.push((x, ty));
        let out = type_of(body, env);
        env.pop();
        out
    };
    let part = |ty: Option<Term>, ctor: &str, i: usize| match ty {
        Some(Term::Ctor(n, mut parts)) if n == ctor => {
            Some(std::mem::replace(&mut parts[i], Term::Nat(0)))
        }
        _ => None,
    };
    match *name {
        "EUnit" | "EAssign" => Some(c0("TUnit")),
        "EBool" => Some(c0("TBool")),
        "EInt" => Some(c0("TInt")),
        "EString" => Some(c0("TString")),
        "EVar" => {
            let x = ident(0);
            env.iter()
                .rev()
                .find(|(y, _)| *y == x)
                .and_then(|(_, ty)| ty.clone())
        }
        "ELam" => {
            let body = under(ident(0), Some(a[1].clone()), &a[2], env)?;
            Some(c("TFn", vec![a[1].clone(), body, c0("EffPure")]))
        }
        "EApp" => {
            let f = type_of(&a[0], env);
            part(f, "TFn", 1)
        }
        "EPair" => Some(c("TProd", vec![type_of(&a[0], env)?, type_of(&a[1], env)?])),
        "EFst" | "ESnd" => {
            let p = type_of(&a[0], env);
            part(p, "TProd", usize::from(*name == "ESnd"))
        }
        "EInl" => Some(c("TSum", vec![type_of(&a[0], env)?, a[1].clone()])),
        "EInr" => Some(c("TSum", vec![a[1].clone(), type_of(&a[0], env)?])),
        "ECase" => {
            let s = type_of(&a[0], env);
            let (l, r) = (part(s.clone(), "TSum", 0), part(s, "TSum", 1));
            under(ident(1), l, &a[2], env).or_else(|| under(ident(3), r, &a[4], env))
        }
        "EIf" => type_of(&a[1], env).or_else(|| type_of(&a[2], env)),
        "ELet" => {
            let bound = type_of(&a[1], env);
            under(ident(0), bound, &a[2], env)
        }
        "EHandle" => {
            let bound = type_of(&a[0], env);
            under(ident(1), bound, &a[2], env)
        }
        "EPerform" | "ERequire" | "EGrant" => type_of(&a[1], env),
        "ERef" => Some(c("TRef", vec![type_of(&a[0], env)?, a[1].clone()])),
        "EDeref" => match type_of(&a[0], env)? {
            Term::Ctor("TRef", mut p) => Some(std::mem::replace(&mut p[0], Term::Nat(0))),
            b if b == c0("TBool") => Some(b),
            _ => None,
        },
        "EClassify" => Some(c("TSecret", vec![type_of(&a[0], env)?])),
        "EDeclassify" => {
            let s = type_of(&a[0], env);
            part(s, "TSecret", 0)
        }
        "EProve" => Some(c("TProof", vec![type_of(&a[0], env)?])),
        // T_Fix: `EFix e : T` where `e : T -> T`.
        "EFix" => {
            let f = type_of(&a[0], env);
            part(f, "TFn", 0)
        }
        _ => None,
    }
}

/// A strongly connected component of two or more members, if the graph has
/// one (`deps[i]` are the members `i` refers to; a self-loop is allowed).
fn mutual_component(deps: &[Vec<usize>]) -> Option<Vec<usize>> {
    let n = deps.len();
    let reaches = |from: usize, to: usize| {
        let mut seen = vec![false; n];
        let mut stack = vec![from];
        while let Some(v) = stack.pop() {
            for &w in &deps[v] {
                if w == to {
                    return true;
                }
                if !seen[w] {
                    seen[w] = true;
                    stack.push(w);
                }
            }
        }
        false
    };
    for i in 0..n {
        let comp: Vec<usize> = (0..n)
            .filter(|j| *j == i || (reaches(i, *j) && reaches(*j, i)))
            .collect();
        if comp.len() > 1 {
            return Some(comp);
        }
    }
    None
}

#[cfg(test)]
mod tests {
    use super::*;

    fn none(_: &str) -> bool {
        false
    }

    fn el(e: &Expr) -> String {
        print(&elaborate(e, &none).expect("elaborates"))
    }

    fn var(x: &str) -> Box<Expr> {
        Box::new(Expr::Var(x.to_string()))
    }

    #[test]
    fn core_constructors_map_one_to_one() {
        let e = Expr::Let(
            "x".into(),
            None,
            Box::new(Expr::Pair(
                Box::new(Expr::Int(7)),
                Box::new(Expr::String("a\"b".into())),
            )),
            Box::new(Expr::If(
                Box::new(Expr::Bool(true)),
                Box::new(Expr::Fst(var("x"))),
                Box::new(Expr::Unit),
            )),
        );
        assert_eq!(
            el(&e),
            r#"(ELet "x" (EPair (EInt 7) (EString "a\"b")) (EIf (EBool true) (EFst (EVar "x")) EUnit))"#
        );
    }

    #[test]
    fn types_effects_and_levels() {
        let ty = Ty::Fn(
            Box::new(Ty::Secret(Box::new(Ty::Int))),
            Box::new(Ty::Ref(Box::new(Ty::String), SecurityLevel::Secret)),
            EffectSet::single(Effect::Read).join(Effect::Network),
        );
        let e = Expr::Lam(
            "s".into(),
            ty,
            Box::new(Expr::Ref(
                Box::new(Expr::String(String::new())),
                SecurityLevel::Secret,
            )),
        );
        assert_eq!(
            el(&e),
            r#"(ELam "s" (TFn (TSecret TInt) (TRef TString LSecret) EffNetwork) (ERef (EString "") LSecret))"#
        );
    }

    #[test]
    fn ascription_and_letrec() {
        let asc = Expr::Ascribe(Box::new(Expr::Int(1)), Ty::Int);
        assert_eq!(
            el(&asc),
            r#"(EApp (ELam "ascribed" TInt (EVar "ascribed")) (EInt 1))"#
        );
        let f_ty = Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), EffectSet::PURE);
        let lr = Expr::LetRec(
            "f".into(),
            f_ty,
            Box::new(Expr::Lam(
                "n".into(),
                Ty::Int,
                Box::new(Expr::App(var("f"), var("n"))),
            )),
            Box::new(Expr::App(var("f"), Box::new(Expr::Int(0)))),
        );
        assert_eq!(
            el(&lr),
            r#"(ELet "f" (EFix (ELam "f" (TFn TInt TInt EffPure) (ELam "n" TInt (EApp (EVar "f") (EVar "n"))))) (EApp (EVar "f") (EInt 0)))"#
        );
    }

    /// Rust's injection carries the whole sum type; Coq's carries the other
    /// side. The sum type is kept as an ascription (REQ-111 found the first
    /// mapping wrote the whole sum type where Coq expects one side).
    #[test]
    fn an_injection_keeps_its_sum_type_as_an_ascription() {
        let sum = Ty::Sum(Box::new(Ty::Int), Box::new(Ty::String));
        assert_eq!(
            el(&Expr::Inl(Box::new(Expr::Int(5)), sum.clone())),
            r#"(EApp (ELam "ascribed" (TSum TInt TString) (EVar "ascribed")) (EInl (EInt 5) TString))"#
        );
        assert_eq!(
            el(&Expr::Inr(Box::new(Expr::String("t".into())), sum)),
            r#"(EApp (ELam "ascribed" (TSum TInt TString) (EVar "ascribed")) (EInr (EString "t") TInt))"#
        );
        assert_eq!(
            elaborate(&Expr::Inl(Box::new(Expr::Int(5)), Ty::Any), &none)
                .unwrap_err()
                .row,
            "Ty::Any"
        );
        assert_eq!(
            elaborate(&Expr::Inl(Box::new(Expr::Int(5)), Ty::String), &none)
                .unwrap_err()
                .row,
            "Expr::Inl"
        );
    }

    #[test]
    fn a_group_is_split_in_dependency_order() {
        let fn_ty = || Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), EffectSet::PURE);
        let lam = |body: Expr| Expr::Lam("_unit".into(), Ty::Unit, Box::new(body));
        // `utama` calls `pembantu`, declared after it; `pembantu` calls itself.
        let group = vec![
            (
                "utama".to_string(),
                fn_ty(),
                lam(Expr::App(var("pembantu"), Box::new(Expr::Unit))),
            ),
            (
                "pembantu".to_string(),
                fn_ty(),
                lam(Expr::App(var("pembantu"), Box::new(Expr::Unit))),
            ),
        ];
        let e = Expr::LetRecGroup(
            group,
            Box::new(Expr::App(var("utama"), Box::new(Expr::Unit))),
        );
        let out = el(&e);
        assert!(
            out.starts_with(r#"(ELet "pembantu" (EFix (ELam "pembantu" (TFn TUnit TUnit EffPure)"#),
            "{out}"
        );
        assert!(out.contains(r#"(ELet "utama" (EApp (ELam "ascribed" (TFn TUnit TUnit EffPure) (EVar "ascribed"))"#), "{out}");
    }

    /// riinac checks a declared effect as an upper bound; the core has no
    /// subeffecting, so each lambda body of a declared function is wrapped in
    /// `ERequire E` (REQ-111 found both cases: `kesan Tulis` on a pure body,
    /// and the outer arrow of a two-parameter effectful function).
    #[test]
    fn a_declared_effect_is_required_at_every_arrow() {
        let wr = EffectSet::single(Effect::Write);
        let inner = Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Unit), wr);
        let fn_ty = Ty::Fn(Box::new(Ty::Int), Box::new(inner), wr);
        let lam = Expr::Lam(
            "a".into(),
            Ty::Int,
            Box::new(Expr::Lam("b".into(), Ty::Int, Box::new(Expr::Unit))),
        );
        let e = Expr::LetRecGroup(vec![("f".into(), fn_ty, lam)], Box::new(Expr::Unit));
        assert_eq!(
            el(&e),
            r#"(ELet "f" (EApp (ELam "ascribed" (TFn TInt (TFn TInt TUnit EffWrite) EffWrite) (EVar "ascribed")) (ELam "a" TInt (ERequire EffWrite (ELam "b" TInt (ERequire EffWrite EUnit))))) EUnit)"#
        );
    }

    /// `!` is a dereference on a reference and negation on a `Bool`, as in
    /// riinac (REQ-111 found the negation written as `EDeref`).
    #[test]
    fn bang_on_a_bool_is_negation() {
        let bang = |e: Expr| Expr::Deref(Box::new(e));
        assert_eq!(
            el(&bang(Expr::Bool(false))),
            "(EIf (EBool false) (EBool false) (EBool true))"
        );
        // A reference to a Bool: the inner `!` reads it, the outer negates.
        let r = Expr::Ref(Box::new(Expr::Bool(true)), SecurityLevel::Public);
        assert_eq!(
            el(&Expr::Let(
                "r".into(),
                None,
                Box::new(r),
                Box::new(bang(bang(Expr::Var("r".into()))))
            )),
            r#"(ELet "r" (ERef (EBool true) LPublic) (EIf (EDeref (EVar "r")) (EBool false) (EBool true)))"#
        );
        // Through a binder's annotation, a sum and an application.
        let lam = Expr::Lam("b".into(), Ty::Bool, Box::new(bang(Expr::Var("b".into()))));
        assert_eq!(
            el(&lam),
            r#"(ELam "b" TBool (EIf (EVar "b") (EBool false) (EBool true)))"#
        );
        let f = Expr::Lam("u".into(), Ty::Unit, Box::new(Expr::Bool(true)));
        assert!(el(&bang(Expr::App(Box::new(f), Box::new(Expr::Unit)))).starts_with("(EIf (EApp"));
        let sum = Ty::Sum(Box::new(Ty::Bool), Box::new(Ty::Int));
        let case = Expr::Case(
            Box::new(Expr::Inl(Box::new(Expr::Bool(true)), sum)),
            "x".into(),
            Box::new(bang(Expr::Var("x".into()))),
            "y".into(),
            Box::new(Expr::Bool(false)),
        );
        assert!(
            el(&case).contains(r#"(EIf (EVar "x") (EBool false) (EBool true))"#),
            "{}",
            el(&case)
        );
        // An operand of no known type stays a dereference.
        assert_eq!(el(&bang(Expr::Var("z".into()))), r#"(EDeref (EVar "z"))"#);
        assert_eq!(el(&bang(Expr::Int(1))), "(EDeref (EInt 1))");
    }

    #[test]
    fn mutual_recursion_is_rejected() {
        let fn_ty = || Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Unit), EffectSet::PURE);
        let call = |f: &str| {
            Expr::Lam(
                "_unit".into(),
                Ty::Unit,
                Box::new(Expr::App(var(f), Box::new(Expr::Unit))),
            )
        };
        let e = Expr::LetRecGroup(
            vec![
                ("a".into(), fn_ty(), call("b")),
                ("b".into(), fn_ty(), call("a")),
            ],
            Box::new(Expr::Unit),
        );
        let err = elaborate(&e, &none).unwrap_err();
        assert_eq!(err.row, "Expr::LetRecGroup");
        assert!(err.detail.contains("`a`, `b`"), "{}", err.detail);
    }

    #[test]
    fn unmodelled_constructs_are_errors() {
        let add = Expr::BinOp(
            riina_types::BinOp::Add,
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        );
        assert_eq!(elaborate(&add, &none).unwrap_err().row, "Expr::BinOp");
        let any = Expr::Lam("x".into(), Ty::Any, Box::new(Expr::Unit));
        assert_eq!(elaborate(&any, &none).unwrap_err().row, "Ty::Any");
        let mutation = Expr::Perform(Effect::Mut, Box::new(Expr::Unit));
        assert_eq!(elaborate(&mutation, &none).unwrap_err().row, "Effect::Mut");
        let lin = Expr::Let(
            "x".into(),
            Some(riina_types::Linearity::Linear),
            Box::new(Expr::Unit),
            Box::new(Expr::Unit),
        );
        assert_eq!(elaborate(&lin, &none).unwrap_err().row, "Linearity::Linear");
    }

    #[test]
    fn a_free_builtin_is_an_error_but_a_bound_name_is_not() {
        let is_cetak = |x: &str| x == "cetak";
        let call = Expr::App(var("cetak"), Box::new(Expr::String("hi".into())));
        assert_eq!(elaborate(&call, &is_cetak).unwrap_err().row, "Builtins");
        let shadowed = Expr::Let(
            "cetak".into(),
            None,
            Box::new(Expr::Unit),
            Box::new(Expr::App(var("cetak"), Box::new(Expr::Unit))),
        );
        assert!(elaborate(&shadowed, &is_cetak).is_ok());
    }

    #[test]
    fn print_and_parse_round_trip() {
        let t = c(
            "ELet",
            vec![
                s("ä\n\"\\"),
                c("EString", vec![s("\u{7f}x")]),
                c(
                    "ELam",
                    vec![
                        s("y"),
                        c(
                            "TSanitized",
                            vec![
                                c0("TString"),
                                c("SanWhitelist", vec![Term::List(vec![s("a"), s("")])]),
                            ],
                        ),
                        c0("EUnit"),
                    ],
                ),
            ],
        );
        let text = print(&t);
        assert_eq!(
            text,
            r#"(ELet "\xc3\xa4\x0a\"\\" (EString "\x7fx") (ELam "y" (TSanitized TString (SanWhitelist (list "a" ""))) EUnit))"#
        );
        assert_eq!(parse(&text), Ok(t.clone()));
        assert_eq!(print(&parse(&text).unwrap()), text);
        assert_eq!(validate(&t, Sort::Expr), Ok(()));
    }

    #[test]
    fn parse_accepts_only_canonical_text() {
        for bad in [
            "(EUnit)",
            "( EUnit)",
            "(EInt  1)",
            "(EInt 01)",
            "\"\\x41\"",
            "\"\\xC3\"",
            "EFoo",
            "EUnit ",
            "(EInt 1",
        ] {
            assert!(parse(bad).is_err(), "{bad:?} parsed");
        }
    }

    /// `SIGNATURES` is exactly the constructors of the nine Coq inductives
    /// it covers, with the same argument sorts (`ident` is `string`, `loc` is
    /// `nat`).
    #[test]
    fn signatures_match_syntax_v() {
        let path = concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/../../../02_FORMAL/coq/foundations/Syntax.v"
        );
        let src = std::fs::read_to_string(path).expect("read Syntax.v");
        // Drop comments (they do not nest in this file's constructor lines).
        let mut text = String::new();
        let mut rest = src.as_str();
        while let Some(i) = rest.find("(*") {
            text.push_str(&rest[..i]);
            let mut depth = 0usize;
            let mut j = i;
            let b = rest.as_bytes();
            while j + 1 < b.len() {
                if &b[j..j + 2] == b"(*" {
                    depth += 1;
                    j += 2;
                } else if &b[j..j + 2] == b"*)" {
                    depth -= 1;
                    j += 2;
                    if depth == 0 {
                        break;
                    }
                } else {
                    j += 1;
                }
            }
            rest = &rest[j..];
        }
        text.push_str(rest);
        let leaf = |t: &str| match t.trim() {
            "ident" | "string" => "string".to_string(),
            "loc" | "nat" => "nat".to_string(),
            other => other.split_whitespace().collect::<Vec<_>>().join(" "),
        };
        let mut coq = std::collections::BTreeSet::new();
        for sort in [
            "expr",
            "ty",
            "session_type",
            "effect",
            "security_level",
            "taint_source",
            "sanitizer",
            "capability_kind",
            "capability",
        ] {
            let header = text
                .find(&format!("Inductive {sort} : Type :="))
                .or_else(|| text.find(&format!("with {sort} : Type :=")))
                .unwrap_or_else(|| panic!("no inductive `{sort}` in Syntax.v"));
            let body = &text[header..];
            let body = &body[body.find(":=").unwrap() + 2..];
            // The definition ends at a `.` that ends its line, or at `with`.
            let dot = body
                .char_indices()
                .find(|(i, ch)| {
                    *ch == '.'
                        && body[i + 1..]
                            .split('\n')
                            .next()
                            .is_some_and(|r| r.trim().is_empty())
                })
                .map(|(i, _)| i);
            let end = [dot, body.find("\nwith ")]
                .into_iter()
                .flatten()
                .min()
                .unwrap();
            for ctor in body[..end].split('|').skip(1) {
                let (name, sig) = ctor.split_once(':').expect("constructor `Name : type`");
                let mut parts: Vec<String> = sig.split("->").map(leaf).collect();
                assert_eq!(parts.pop().as_deref(), Some(sort), "{name}: result sort");
                coq.insert((sort.to_string(), name.trim().to_string(), parts));
            }
        }
        let ours: std::collections::BTreeSet<_> = SIGNATURES
            .iter()
            .map(|(sort, name, args)| {
                (
                    sort.coq().to_string(),
                    (*name).to_string(),
                    args.iter().map(|a| a.coq().to_string()).collect::<Vec<_>>(),
                )
            })
            .collect();
        let missing: Vec<_> = coq.difference(&ours).collect();
        let extra: Vec<_> = ours.difference(&coq).collect();
        assert!(
            missing.is_empty() && extra.is_empty(),
            "Syntax.v but not SIGNATURES: {missing:?}\nSIGNATURES but not Syntax.v: {extra:?}"
        );
    }

    #[test]
    fn validate_rejects_ill_sorted_terms() {
        assert!(validate(&c("EInt", vec![s("1")]), Sort::Expr).is_err());
        assert!(validate(&c("EApp", vec![c0("EUnit")]), Sort::Expr).is_err());
        assert!(validate(&c0("TUnit"), Sort::Expr).is_err());
    }
}
