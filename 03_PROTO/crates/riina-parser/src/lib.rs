// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Parser
//!
//! Parses token streams into ASTs defined in `riina-types`.
//! RIINA = Rigorous Immutable Invariant, No Assumptions
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS

pub mod limits;
pub mod modules;

use riina_lexer::{LexError, Lexer, Span, Token, TokenKind};
use riina_types::Span as AstSpan;
use riina_types::{
    BinOp, CapabilityKind, Effect, EffectSet, Expr, ExternDecl, Ident, Import, Linearity, Program,
    Sanitizer,
    SecurityLevel, SessionType, SpannedDecl, TaintSource, TopLevelDecl, Ty,
};
use std::cell::RefCell;
use std::collections::{HashMap, HashSet};
use std::fmt;
use std::iter::Peekable;
use std::rc::Rc;

#[derive(Debug, Clone, PartialEq)]
pub struct ParseError {
    pub kind: ParseErrorKind,
    pub span: Span,
}

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{} at {}..{}", self.kind, self.span.start, self.span.end)
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum ParseErrorKind {
    UnexpectedToken(TokenKind),
    UnexpectedEof,
    ExpectedIdentifier,
    ExpectedType,
    ExpectedExpression,
    InvalidSecurityLevel,
    InvalidEffect,
    InvalidSessionType,
    /// Expression/grouping nesting exceeded the parser's depth limit. Returned
    /// instead of letting deeply nested input (e.g. `((((…`) overflow the stack
    /// — a denial-of-service guard on untrusted input (REQ-30).
    NestingTooDeep,
    /// `putus`/`lanjut` used outside any `selagi`/`ulang` body. Reported rather
    /// than ignored: until 2026-08 both desugared to `()` anywhere they appeared,
    /// so a misplaced loop-control statement silently did nothing.
    LoopControlOutsideLoop(&'static str),
    /// `biar ubah sekali/paling/mesti x` — a mutable slot with a linearity
    /// qualifier. The two do not combine ("use exactly once" vs "assign
    /// repeatedly"), and a slot carries no linearity, so this is reported
    /// rather than silently dropping the qualifier.
    MutWithLinearity,
    /// A floating-point literal such as `1.5`. RIINA has no floating point by
    /// design (owner ruling D8, 2026-10-19; master plan REQ-105): IEEE-754
    /// results vary with platform and compiler flags, and float timing depends
    /// on the operands (subnormals), which leaks secrets. Exact decimals are
    /// `perpuluhan("1.5")`, money is `wang("12.34")`. The error used to be a
    /// bare `Unexpected token: LiteralFloat("1.5", None)` pointing at the
    /// token BEFORE the literal.
    FloatLiteral(String),
    /// An integer literal with no `u64` value: a bad digit for its base
    /// (`0b12`), no digits (`0x`), or too large. Each used to become `0`
    /// through `unwrap_or(0)`: `0xFF` evaluated to 0, a too-large literal to
    /// 0, and the pattern `1_000` matched 0 (REQ-97, mandate R3).
    InvalidIntLiteral { literal: String, reason: &'static str },
    /// `a::b::c`: a path through a module inside a module. Modules are one
    /// level deep (`m::f`). The path used to keep its first and last segments,
    /// so `a::b::c()` silently called `a_c` (REQ-97).
    NestedModulePath(String),
    /// An item inside `modul m { … }` other than a `fungsi`. It used to be
    /// skipped token by token, so `modul m { biar x = 5; … }` silently lost
    /// the binding (REQ-97).
    UnsupportedModuleItem(String),
    /// A `pelaku` with more than one `kendalikan`. Messages are not dispatched
    /// by name, so the extra handlers had no meaning: the parser chained them
    /// into a value the checker then rejected with "Expected function type,
    /// found Unit".
    MultipleActorHandlers(String),
    /// A type name that is not built in, not declared in this file and not a
    /// generic parameter in scope. It used to parse as `Any`, so a typo
    /// (`Nombr`, `Rahsa<Teks>`) accepted every value (REQ-93(c)).
    UnknownType {
        name: String,
        suggestion: Option<String>,
    },
    /// A `jenis N = T;` alias used above its declaration, or inside its own
    /// definition. Its type is known only once the declaration is parsed.
    TypeAliasBeforeDeclaration(String),
    /// A type declared twice in one file, or with a built-in type's name.
    TypeRedeclared { name: String, builtin: bool },
    /// Type syntax the compiler does not implement, rejected rather than read
    /// as `Any` or dropped: a generic alias, `awam` on a type declaration and
    /// a bound on a generic parameter.
    UnsupportedTypeSyntax { name: String, what: &'static str },
    /// `modul Name { … }` with a CAPITALIZED name (REQ-82).
    ///
    /// The declaration and the call site disagreed, silently. A `modul Masa`
    /// block flattens its `fungsi f` to a top-level `Masa_f`, but the call
    /// `Masa::f` resolves through the capitalized-namespace rule to a bare `f`
    /// — so the block defined a function nothing could reach, and the call went
    /// to the BUILTIN of that name instead. A user writing a deterministic
    /// `masa_unix` stub got the real clock and no diagnostic.
    ///
    /// Rejecting the declaration is the lossless half of the fix: the
    /// capitalized CALL path is what the corpus actually uses (185 sites across
    /// `Masa`, `SistemFail`, `Kripto`, `Rangkaian`, …) and is untouched.
    CapitalizedModuleName(String),
    /// `fungsi Name(...)` whose RESOLVED name starts with an uppercase letter
    /// (REQ-82, second half).
    ///
    /// Such a function is undefinable-callable: an uppercase identifier at a
    /// call position is a data constructor, so `Kira_tokokan(1)` built the tuple
    /// `(Kira_tokokan, 1)` instead of calling anything — and said nothing.
    CapitalizedFunctionName(String),
    /// The program's syntax tree would be deeper than
    /// [`limits::MAX_AST_DEPTH`] levels. Flat source becomes a deep tree (a
    /// statement sequence is a right-nested `Let` chain, `a + b + …` a
    /// left-nested `BinOp` chain), and every later stage recurses over it, so
    /// a pathologically long sequence is rejected here rather than allowed to
    /// overflow the stack (an uncatchable abort) further down.
    ProgramTooDeep { depth: usize, limit: usize },
    /// The source contains text the lexer cannot tokenize. The token stream
    /// ends there; reporting it (rather than treating it as the end of the
    /// file) is what stops a stray character at the top level from silently
    /// discarding every declaration after it.
    Lex(LexError),
}

impl fmt::Display for ParseErrorKind {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ParseErrorKind::UnexpectedToken(tok) => write!(f, "Unexpected token: {:?}", tok),
            ParseErrorKind::UnexpectedEof => write!(f, "Unexpected end of input"),
            ParseErrorKind::ExpectedIdentifier => write!(f, "Expected identifier"),
            ParseErrorKind::ExpectedType => write!(f, "Expected type"),
            ParseErrorKind::ExpectedExpression => write!(f, "Expected expression"),
            ParseErrorKind::InvalidSecurityLevel => write!(f, "Invalid security level"),
            ParseErrorKind::InvalidEffect => write!(f, "Invalid effect"),
            ParseErrorKind::InvalidSessionType => write!(f, "Invalid session type"),
            ParseErrorKind::NestingTooDeep => write!(f, "Expression nesting too deep"),
            ParseErrorKind::LoopControlOutsideLoop(kw) => write!(
                f,
                "`{kw}` is only valid inside a `selagi` or `ulang` loop body"
            ),
            ParseErrorKind::MutWithLinearity => write!(
                f,
                "`ubah` cannot be combined with a linearity qualifier"
            ),
            ParseErrorKind::CapitalizedModuleName(name) => write!(
                f,
                "`modul {name}` has a capitalized name: its functions would be \
                 unreachable"
            ),
            ParseErrorKind::CapitalizedFunctionName(name) => write!(
                f,
                "`fungsi {name}` starts with an uppercase letter: it could never be \
                 called"
            ),
            ParseErrorKind::ProgramTooDeep { depth, limit } => write!(
                f,
                "Program too deeply nested: at least {depth} levels (limit {limit})"
            ),
            ParseErrorKind::FloatLiteral(lit) => write!(
                f,
                "Floating point is not supported in RIINA (`{lit}`); use perpuluhan(\"{lit}\") \
                 for an exact decimal or wang(\"{lit}\") for money"
            ),
            ParseErrorKind::InvalidIntLiteral { literal, reason } => {
                write!(f, "Invalid integer literal `{literal}`: {reason}")
            }
            ParseErrorKind::NestedModulePath(path) => write!(
                f,
                "`{path}` names a module inside a module; modules are one level deep (`m::f`)"
            ),
            ParseErrorKind::UnsupportedModuleItem(item) => write!(
                f,
                "only `fungsi` declarations are supported inside `modul {{ }}`, found {item}"
            ),
            ParseErrorKind::MultipleActorHandlers(actor) => write!(
                f,
                "`pelaku {actor}` has more than one `kendalikan`; an actor has one handler"
            ),
            ParseErrorKind::UnknownType { name, suggestion } => {
                write!(f, "unknown type `{name}`")?;
                match suggestion {
                    Some(s) => write!(f, "; did you mean `{s}`?"),
                    None => Ok(()),
                }
            }
            ParseErrorKind::TypeAliasBeforeDeclaration(name) => write!(
                f,
                "type alias `{name}` is used before its declaration"
            ),
            ParseErrorKind::TypeRedeclared { name, builtin: true } => {
                write!(f, "`{name}` is a built-in type and cannot be declared again")
            }
            ParseErrorKind::TypeRedeclared { name, builtin: false } => {
                write!(f, "type `{name}` is declared more than once")
            }
            ParseErrorKind::UnsupportedTypeSyntax { name, what } => {
                write!(f, "{what} are not supported (`{name}`)")
            }
            ParseErrorKind::Lex(e) => write!(f, "{e}"),
        }
    }
}

impl ParseErrorKind {
    /// Return an error code for this parse error.
    #[must_use]
    pub fn error_code(&self) -> &'static str {
        match self {
            ParseErrorKind::UnexpectedToken(_) => "P0001",
            ParseErrorKind::UnexpectedEof => "P0002",
            ParseErrorKind::ExpectedIdentifier => "P0003",
            ParseErrorKind::ExpectedType => "P0004",
            ParseErrorKind::ExpectedExpression => "P0005",
            ParseErrorKind::InvalidSecurityLevel => "P0006",
            ParseErrorKind::InvalidEffect => "P0007",
            ParseErrorKind::InvalidSessionType => "P0008",
            ParseErrorKind::NestingTooDeep => "P0009",
            ParseErrorKind::LoopControlOutsideLoop(_) => "P0010",
            ParseErrorKind::MutWithLinearity => "P0011",
            // REQ-82 renumbered to P0012/P0013: the loop-control and
            // linearity codes above are published in 07_EXAMPLES/README.md and
            // docs/guide/MUTABLE_STATE.md, so they keep the numbers a reader
            // may already have seen. These two were only ever named in the
            // internal registry.
            ParseErrorKind::CapitalizedModuleName(_) => "P0012",
            ParseErrorKind::CapitalizedFunctionName(_) => "P0013",
            ParseErrorKind::ProgramTooDeep { .. } => "P0014",
            ParseErrorKind::FloatLiteral(_) => "P0015",
            ParseErrorKind::InvalidIntLiteral { .. } => "P0016",
            ParseErrorKind::NestedModulePath(_) => "P0017",
            ParseErrorKind::UnsupportedModuleItem(_) => "P0018",
            ParseErrorKind::MultipleActorHandlers(_) => "P0019",
            ParseErrorKind::UnknownType { .. } => "P0020",
            ParseErrorKind::TypeAliasBeforeDeclaration(_) => "P0021",
            ParseErrorKind::TypeRedeclared { .. } => "P0022",
            ParseErrorKind::UnsupportedTypeSyntax { .. } => "P0023",
            ParseErrorKind::Lex(e) => e.error_code(),
        }
    }

    /// Return a fix hint for this parse error.
    #[must_use]
    pub fn fix_hint(&self) -> Option<String> {
        Some(match self {
            ParseErrorKind::UnexpectedToken(tok) => {
                format!("Unexpected {:?}. Check for missing semicolons, braces, or parentheses", tok)
            }
            ParseErrorKind::UnexpectedEof => {
                "Unexpected end of file. Check for unclosed braces {{ }}, parentheses (), or missing semicolons".to_string()
            }
            ParseErrorKind::ExpectedIdentifier => {
                "Expected a name (identifier). Variable and function names must start with a letter or underscore".to_string()
            }
            ParseErrorKind::ExpectedType => {
                "Expected a type. Valid types: Nombor, Teks, Benar, Kosong, Rahsia<T>, Senarai<T>, (T1, T2)".to_string()
            }
            ParseErrorKind::ExpectedExpression => {
                "Expected an expression. This can be a value (42, \"hello\", betul), variable, function call, or operator expression".to_string()
            }
            ParseErrorKind::LoopControlOutsideLoop(kw) => {
                format!("`{kw}` needs an enclosing loop. Wrap the code in `selagi <syarat> {{ ... }}` or `ulang {{ ... }}`, or delete the `{kw}`")
            }
            ParseErrorKind::MutWithLinearity => {
                "Drop either `ubah` (for a mutable slot) or the linearity qualifier `sekali`/`paling`/`mesti` (for a use-counted binding)".to_string()
            }
            ParseErrorKind::InvalidSecurityLevel => {
                "Invalid security level. Valid levels: Awam, Dalaman, Sesi, Pengguna, Sistem, Rahsia".to_string()
            }
            ParseErrorKind::InvalidEffect => {
                "Invalid effect. Valid effects: Bersih, Ubah, Baca, Tulis, SistemFail, Rangkaian, Kripto, Rawak, Sistem, Masa, Proses".to_string()
            }
            ParseErrorKind::InvalidSessionType => {
                "Invalid session type. Valid: Send<T, S>, Recv<T, S>, Select<S1, S2>, Branch<S1, S2>, End, Rec<X, S>, Var<X>".to_string()
            }
            ParseErrorKind::NestingTooDeep => {
                "Expression/grouping nesting is too deep. Deeply nested input like ((((… can exhaust the stack; reduce the nesting depth".to_string()
            }
            ParseErrorKind::Lex(_) => {
                "The source contains a character or literal the lexer cannot read at this position; fix or remove it".to_string()
            }
            ParseErrorKind::FloatLiteral(lit) => {
                format!(
                    "RIINA has no floating point by design: float results differ between \
                     platforms and float timing leaks secrets. Write `perpuluhan(\"{lit}\")` \
                     (exact decimal), `wang(\"{lit}\")` (money, fixed scale) or a scaled \
                     integer (`Nombor`)"
                )
            }
            ParseErrorKind::NestedModulePath(_) => {
                "A path is `module::name`, or `Namespace::builtin`. Import the module that \
                 defines the function (`guna m;`) and call it as `m::f`"
                    .to_string()
            }
            ParseErrorKind::MultipleActorHandlers(_) => {
                "Messages are not dispatched by name yet: give the actor one `kendalikan` \
                 and branch on the message inside it (`padan`)"
                    .to_string()
            }
            ParseErrorKind::UnsupportedModuleItem(_) => {
                "Move the item out of the `modul` block to the top level of the file, or \
                 put the module in its own file and import it with `guna`"
                    .to_string()
            }
            ParseErrorKind::UnknownType { name, .. } => {
                format!(
                    "Use a built-in type (Nombor, Teks, Benar, Kosong, Senarai<T>, \
                     Mungkin<T>, Hasil<T, E>, Rahsia<T>) or declare `{name}` in this file \
                     (`jenis {name} = Nombor;`, `bentuk {name} {{ … }}`, `pilihan {name} \
                     {{ … }}`). Types are local to the file that declares them: `guna` \
                     imports functions, not types"
                )
            }
            ParseErrorKind::TypeAliasBeforeDeclaration(name) => {
                format!(
                    "Move `jenis {name} = …;` above its first use. An alias cannot refer \
                     to itself; a recursive type needs `bentuk` or `pilihan`"
                )
            }
            ParseErrorKind::TypeRedeclared { builtin: true, .. } => {
                "Choose another name: this one already means a built-in type".to_string()
            }
            ParseErrorKind::TypeRedeclared { builtin: false, .. } => {
                "Remove or rename one of the declarations".to_string()
            }
            ParseErrorKind::UnsupportedTypeSyntax { .. } => {
                "Generic parameters carry no bounds and an alias takes no parameters; \
                 write the aliased type out where it is used. A type is local to its \
                 file, so it has no `awam`"
                    .to_string()
            }
            ParseErrorKind::InvalidIntLiteral { .. } => {
                "Integer literals are decimal (`255`, `1_000`), hexadecimal (`0xFF`), octal \
                 (`0o377`) or binary (`0b1111_1111`), and must fit in 64 bits"
                    .to_string()
            }
            ParseErrorKind::ProgramTooDeep { limit, .. } => {
                format!("Every statement in a block, every operator in a chain like `a + b + …`, every `lain kalau` and every top-level declaration adds a level. Split very long blocks or expressions into smaller functions so the program stays under {limit} levels")
            }
            ParseErrorKind::CapitalizedModuleName(name) => {
                let lower = lowercase_first(name);
                format!(
                    "A capitalized `modul` name reads as a BUILTIN namespace, so its \
                     block is unreachable: `{name}::f` resolves to the bare `f`, never \
                     to a function defined inside `modul {name}`. Write the function \
                     qualified instead — `fungsi {name}::f(...)` defines exactly what \
                     `{name}::f` calls. Or lowercase the module (`modul {lower} {{ \
                     fungsi f }}`, reachable as `{lower}::f`) if you want a real \
                     namespace, or drop the block if the builtin `{name}::f` was what \
                     you meant all along."
                )
            }
            ParseErrorKind::CapitalizedFunctionName(name) => {
                let lower = lowercase_first(name);
                format!(
                    "An uppercase identifier at a call position is a data CONSTRUCTOR, \
                     not a function, so `{name}(...)` would silently build the value \
                     `(\"{name}\", args)` instead of calling this definition. Rename it \
                     to `{lower}`, or write it qualified (`fungsi Ns::{lower}`) if you \
                     meant to place it in a namespace."
                )
            }
        })
    }
}

/// Lowercase only the FIRST character, so the fix hint suggests a name the user
/// recognises: `SistemFail` -> `sistemFail`, not `sistemfail`.
fn lowercase_first(s: &str) -> String {
    let mut chars = s.chars();
    match chars.next() {
        Some(c) => c.to_lowercase().collect::<String>() + chars.as_str(),
        None => String::new(),
    }
}

#[derive(Clone)]
struct LexerIter<'a> {
    lexer: Lexer<'a>,
    /// The first lexical error this token stream hit. The stream itself
    /// reports an error as `None` (no token); the parser reads the cause from
    /// here. Shared with the parser and with lookahead clones.
    error: Rc<RefCell<Option<LexError>>>,
}

impl Iterator for LexerIter<'_> {
    type Item = Token;

    fn next(&mut self) -> Option<Self::Item> {
        match self.lexer.next_token() {
            Ok(token) => Some(token),
            Err(e) => {
                let mut slot = self.error.borrow_mut();
                if slot.is_none() {
                    *slot = Some(e);
                }
                None
            }
        }
    }
}

/// Byte offset a lexical error points at.
fn lex_error_pos(e: &LexError) -> usize {
    match e {
        LexError::UnexpectedChar(_, p)
        | LexError::UnterminatedString(p)
        | LexError::UnterminatedChar(p)
        | LexError::UnterminatedComment(p)
        | LexError::InvalidEscapeSequence(p)
        | LexError::InvalidNumericLiteral(_, p)
        | LexError::EmptyCharLiteral(p)
        | LexError::Unknown(_, p) => *p,
    }
}

/// Maximum parser recursion depth, in nesting units, before the parser fails
/// with [`ParseErrorKind::NestingTooDeep`]. The recursive-descent parser would
/// otherwise overflow the stack on adversarial input (`((((…`) — a SIGABRT/SIGSEGV
/// rather than a catchable error.
///
/// EVERY self-recursive entry point charges one unit: `parse_expr`,
/// `parse_control_flow`, `parse_unary`, `parse_ty`, `parse_pattern` and
/// `parse_session_type`. Guarding only `parse_expr` (as until 2026-10) left
/// cycles that never pass through it unbounded — `[[[[…`, `!!!!…`,
/// `f(f(f(…`, curried lambdas `fungsi(x: N) fungsi(y: N) …`, nested `padan`
/// arms, `Senarai<Senarai<…` types — and each of those overflowed the stack
/// at a few thousand levels. A parenthesised level costs three units
/// (`parse_expr` → `parse_control_flow` → `parse_unary`), so this admits
/// about 100 nested parentheses, the same as the earlier per-`parse_expr`
/// limit of 100.
///
/// What this bounds is the parser's stack use. Measured (2026-10) per
/// nesting level of an UNOPTIMISED build: ~115 KiB per parenthesised level,
/// ~95 KiB per `[`, ~47 KiB per `!` — so at the limit the parser needs up to
/// ~15 MiB in a debug build and a small fraction of that optimised. (The
/// earlier claim of ~8 KiB per level, safe on a 2 MiB thread, did not hold
/// for debug builds.) `riinac` runs on a large dedicated stack and the
/// workspace raises `RUST_MIN_STACK` for tests; a library caller parsing
/// untrusted input on its own thread should reserve at least 16 MiB. No
/// hand-written or generated RIINA nests expressions anywhere near this deep.
/// REQ-30 (found by the fuzz-robustness harness).
///
/// This bounds NESTING only. Flat-but-long input (statement sequences,
/// operator chains, `lain kalau` chains) is parsed iteratively and bounded by
/// [`limits::MAX_AST_DEPTH`] instead.
const MAX_EXPR_DEPTH: usize = 300;

pub struct Parser<'a> {
    lexer: Peekable<LexerIter<'a>>,
    current_span: Span,
    /// Current expression-nesting depth (incremented per `parse_expr`); bounded
    /// by [`MAX_EXPR_DEPTH`] to keep untrusted input from overflowing the stack.
    depth: usize,
    /// Counter for generating fresh, capture-free variable names during
    /// desugaring (e.g. `padan` compilation). See [`Parser::fresh_var`].
    gensym: usize,
    /// A "virtual" closing `>` left over after splitting a `>>` (Shr) token while
    /// closing nested generic type arguments (e.g. `Mungkin<Senarai<Nombor>>`).
    /// When set, the next [`Parser::consume_type_close`] consumes it without
    /// advancing the real token stream.
    pending_gt: bool,
    /// Top-level decls flattened out of `modul Name { ... }` blocks, queued to
    /// be returned by `parse_top_level_decl` before resuming the token stream.
    /// A module function `fungsi f` becomes a top-level `Name_f` so the existing
    /// `Name::f` -> `Name_f` qualified-call resolution finds it.
    pending_decls: std::collections::VecDeque<TopLevelDecl>,
    /// Sibling modules named by a single-segment `guna <name>;` (REQ-71).
    /// A multi-segment path (`guna std::teks;`) names the builtin namespace,
    /// has no file behind it, and is deliberately NOT recorded here.
    imports: Vec<Import>,
    /// Top-level names introduced with the `awam` (pub) visibility keyword.
    /// Everything else is module-private to the file that declares it.
    public_names: Vec<Ident>,
    /// Set while parsing the declaration that directly follows an `awam`, so
    /// the name is captured wherever the decl parser finally produces it.
    pending_pub: bool,
    /// Lexical binding stack, innermost last, recording whether each name was
    /// introduced with `ubah`. Consulted to decide whether a name read is a
    /// plain [`Expr::Var`] or a mutable-slot read, and whether `x = e;` is a
    /// slot write or the legacy shadowing rebind. A shadowing immutable binding
    /// pushes `(name, false)`, so an inner `biar x` correctly hides an outer
    /// `biar ubah x`.
    binding_scope: Vec<(Ident, bool)>,
    /// Number of `selagi`/`ulang` bodies currently open. `putus`/`lanjut` are
    /// only meaningful inside one, so a zero depth turns them into a parse error
    /// instead of a silently-ignored statement (which is what they were until
    /// 2026-08 — both desugared to `()`).
    ///
    /// `untuk` also raises this: it lowers to a real `While`, preserving the
    /// enclosing function's return boundary and the innermost loop's control.
    loop_depth: usize,
    /// The token stream's first lexical error (see [`LexerIter::error`]).
    lex_error: Rc<RefCell<Option<LexError>>>,
    /// Every type this file declares, from a pre-scan of the whole source in
    /// [`Parser::new`], so a type may be used above its declaration. An alias
    /// gets its type when its declaration is parsed (REQ-93(c)).
    type_decls: HashMap<Ident, TypeDecl>,
    /// Type names whose declaration has been parsed, to reject a second one.
    declared_types: HashSet<Ident>,
    /// Generic parameters of the function being parsed (`fungsi f<T>`).
    type_params: Vec<Ident>,
}

/// What a declared type name means where it is used.
#[derive(Debug, Clone)]
enum TypeDecl {
    /// `jenis N = T;`: `T`, once the declaration has been parsed.
    Alias(Option<Ty>),
    /// `jenis N<T> = T;`, rejected wherever it appears.
    GenericAlias,
    /// A record (`bentuk`, `jenis N { … }`, `jenis N = { … }`), a variant type
    /// (`pilihan`, `jenis N = | A | B(T)`, `jenis N = N(T)`) or a marker
    /// (`jenis N`). The checker has no record or variant types (a record
    /// literal is typed `Any`), so the name reads as `Any`. `generic` says
    /// whether `<…>` arguments may follow it.
    Untyped { generic: bool },
}

/// Every type name `parse_ty_inner` knows, in its match order. The
/// `builtin_type_names_match_the_parser` test holds this list to the match
/// arms, so a new built-in type cannot be missing here.
const BUILTIN_TYPE_NAMES: &[&str] = &[
    "Int", "Nombor", "u8", "u16", "u32", "u64", "i8", "i16", "i32", "i64", "Besar", "BigInt",
    "Perpuluhan", "Decimal", "Wang", "Money", "TitikTetap", "Qmn", "BinaryFixed", "Bool",
    "Benar", "Unit", "Kosong", "String", "Teks", "Bytes", "Bait", "List", "Senarai", "Option",
    "Mungkin", "Result", "Hasil", "Secret", "Rahsia", "Proof", "Bukti", "ConstantTime",
    "MasaTetap", "Zeroizing", "Sifar", "Ref", "Ruj", "Sum", "Fn", "fungsi", "Labeled",
    "Berlabel", "Tainted", "Tercemar", "Sanitized", "Disanitasi", "CInt", "CChar", "CVoid",
    "Capability", "Keupayaan", "Chan", "Saluran", "SecureChan", "SaluranSelamat",
    "SmartContract", "Token", "SyariahCompliant",
];

/// Find every type the source declares. A `jenis`/`bentuk`/`pilihan` keyword
/// followed by a name is a declaration: `jenis` is also a variable name, but
/// a variable is never directly followed by another name. The first
/// declaration of a name wins; the parser rejects the second.
fn scan_type_decls(source: &str) -> HashMap<Ident, TypeDecl> {
    let mut lexer = Lexer::new(source);
    let mut toks = Vec::new();
    // A lexical error ends the scan; the parser reports it at that point.
    while let Ok(t) = lexer.next_token() {
        if t.kind == TokenKind::Eof {
            break;
        }
        toks.push(t.kind);
    }
    let mut decls = HashMap::new();
    for (i, kind) in toks.iter().enumerate() {
        if !matches!(kind, TokenKind::KwType | TokenKind::KwStruct | TokenKind::KwEnum) {
            continue;
        }
        let Some(TokenKind::Identifier(name)) = toks.get(i + 1) else {
            continue;
        };
        let decl = classify_type_decl(kind, toks[i + 2..].iter().cloned());
        decls.entry(name.clone()).or_insert(decl);
    }
    decls
}

/// Classify a type declaration from its keyword and the tokens after its
/// name. The declaration parser reads this classification back from the
/// pre-scan rather than deciding again, so the two cannot disagree.
fn classify_type_decl(keyword: &TokenKind, mut rest: impl Iterator<Item = TokenKind>) -> TypeDecl {
    let mut next = rest.next();
    let generic = matches!(next, Some(TokenKind::Lt));
    if generic {
        let mut depth = 1u32;
        while depth > 0 {
            match rest.next() {
                Some(TokenKind::Lt) => depth += 1,
                Some(TokenKind::Gt) => depth -= 1,
                Some(TokenKind::Shr) => depth = depth.saturating_sub(2),
                Some(TokenKind::Eof) | None => return TypeDecl::Untyped { generic },
                Some(_) => {}
            }
        }
        next = rest.next();
    }
    if *keyword != TokenKind::KwType || next != Some(TokenKind::Eq) {
        return TypeDecl::Untyped { generic };
    }
    // `jenis N = …`: a record, a variant type or an alias.
    let first = rest.next();
    let second = rest.next();
    match (&first, &second) {
        (Some(TokenKind::LBrace | TokenKind::Or), _) => return TypeDecl::Untyped { generic },
        // `jenis Emel = Emel(Teks);`, a one-constructor variant. `Fn(A) -> R`
        // is the one built-in type written with parentheses.
        (Some(TokenKind::Identifier(c)), Some(TokenKind::LParen)) if c != "Fn" => {
            return TypeDecl::Untyped { generic };
        }
        _ => {}
    }
    // `jenis N = A | B(T);`: a `|` outside any brackets before the `;`.
    // `kesan` ends the scan: a `|` in an effect set is not a variant bar.
    let mut depth = 0u32;
    for tok in [first, second].into_iter().flatten().chain(rest) {
        match tok {
            TokenKind::LParen | TokenKind::LBracket | TokenKind::LBrace | TokenKind::Lt => {
                depth += 1;
            }
            TokenKind::RParen | TokenKind::RBracket | TokenKind::RBrace | TokenKind::Gt => {
                depth = depth.saturating_sub(1);
            }
            TokenKind::Shr => depth = depth.saturating_sub(2),
            TokenKind::Or if depth == 0 => return TypeDecl::Untyped { generic },
            TokenKind::KwEffect if depth == 0 => break,
            TokenKind::Semi | TokenKind::Eof => break,
            _ => {}
        }
    }
    if generic {
        TypeDecl::GenericAlias
    } else {
        TypeDecl::Alias(None)
    }
}

/// Edit distance, for "did you mean" suggestions.
fn edit_distance(a: &str, b: &str) -> usize {
    let b: Vec<char> = b.chars().collect();
    let mut row: Vec<usize> = (0..=b.len()).collect();
    for (i, ca) in a.chars().enumerate() {
        let mut prev = row[0];
        row[0] = i + 1;
        for (j, cb) in b.iter().enumerate() {
            let cur = row[j + 1];
            row[j + 1] = if ca == *cb {
                prev
            } else {
                1 + prev.min(row[j]).min(cur)
            };
            prev = cur;
        }
    }
    row[b.len()]
}

/// A surface match pattern, used only during `padan` compilation. The AST has
/// no pattern node; [`Parser::compile_match`] lowers these to core `Expr`.
#[derive(Debug, Clone)]
enum Pattern {
    /// `_` — matches anything, binds nothing.
    Wildcard,
    /// A variable binding — matches anything, binds the name.
    Var(Ident),
    /// Integer literal pattern.
    Int(u64),
    /// Boolean literal pattern.
    Bool(bool),
    /// String literal pattern.
    Str(String),
    /// Tuple pattern `(p1, p2, ...)`.
    Tuple(Vec<Pattern>),
    /// List pattern `[p0, p1, ...]` with an optional rest binding `..name`
    /// (`tail` is `Some(name)` for `[a, b, ..rest]`, `None` for a fixed-length
    /// `[a, b]`). An empty fixed list `[]` is `elems = [], tail = None`.
    List {
        elems: Vec<Pattern>,
        tail: Option<Ident>,
    },
    /// Left-injection constructor (`Some`/`Ada`/`Ok`/`Jadi`/`inl`) with payload.
    CtorLeft(Box<Pattern>),
    /// Right-injection constructor (`None`/`Tiada`/`Err`/`Gagal`/`Ralat`/`inr`)
    /// with payload.
    CtorRight(Box<Pattern>),
    /// Reference pattern `ruj(p)`: matches a reference, testing/binding the inner
    /// pattern `p` against the dereferenced value.
    Ref(Box<Pattern>),
    /// Named (nominal-enum) constructor pattern `C(p0, p1, ...)` or nullary `C`.
    /// Matches a structurally-tagged value `("C", payload)`: tests the tag string
    /// and binds the argument pattern(s) against the payload.
    NamedCtor { name: String, args: Vec<Pattern> },
}

/// One statement of a sequence, parsed but not yet wrapped around the rest of
/// the sequence (its continuation). [`Parser::parse_stmt_frames`] collects
/// these iteratively and [`Parser::fold_stmt_frames`] builds the nested
/// expression from the innermost statement outwards.
enum SeqFrame {
    /// Local `fungsi f(..) { .. }` → `LetRec(f, ty, lam, rest)`.
    LocalFn { name: Ident, fn_ty: Ty, lam: Expr },
    /// `biar (a, b, ..) = e;` → `Let(tmp, lin, e, Let(a, proj, ..rest))`.
    TupleLet {
        names: Vec<Ident>,
        linearity: Option<Linearity>,
        value: Expr,
    },
    /// `biar x = e;` → `Let(x, lin, e, rest)`.
    Let {
        name: Ident,
        linearity: Option<Linearity>,
        value: Expr,
    },
    /// `biar ubah x = e;` → `LetMut(x, e, rest)`. A linearity qualifier is an
    /// error, reported when the frame is folded (after the rest is parsed, as
    /// the recursive parser did).
    LetMut {
        name: Ident,
        value: Expr,
        has_linearity: bool,
    },
    /// Any other sequenced statement → `Let(name, None, value, rest)`
    /// (`name` is `_` for a discarded value, or the rebound name for `x = e;`).
    Seq { name: Ident, value: Expr },
    /// `pastikan cond …;` → `If(cond, rest, otherwise)`.
    Guard { cond: Expr, otherwise: Expr },
}

/// One link of a `kalau … lain kalau …` chain (see [`Parser::parse_if`]).
enum IfLink {
    /// `kalau cond { then } lain kalau …` — the next link follows.
    ElseIf { cond: Expr, then_branch: Expr },
    /// The final link, already built into its `If`.
    Last(Expr),
}

/// What a `pastikan` guard runs when its condition is false.
enum GuardElse {
    /// `pastikan c lain { body };`
    Block(Expr),
    /// `pastikan c ["msg"];` — fail execution.
    Fail,
}

impl GuardElse {
    fn into_expr(self) -> Expr {
        match self {
            GuardElse::Block(body) => body,
            // This compiler-internal name cannot be declared in surface syntax
            // (`$` is not an identifier character), so it cannot be shadowed.
            // It never returns: interpreter error, C abort, WASM trap.
            GuardElse::Fail => Expr::App(
                Box::new(Expr::Var("$guard_fail".into())),
                Box::new(Expr::Unit),
            ),
        }
    }
}

/// One arm of a `padan` expression: a pattern, an optional `kalau` guard, and a
/// body expression.
#[derive(Debug, Clone)]
struct MatchArm {
    pattern: Pattern,
    guard: Option<Expr>,
    body: Expr,
}

/// `s` followed by `k`: every place `s` ends (`End`) continues as `k`. A
/// choreography step after a `pilih` follows each of its branches.
fn then_session(s: SessionType, k: &SessionType) -> SessionType {
    match s {
        SessionType::End => k.clone(),
        SessionType::Send(t, rest) => SessionType::Send(t, Box::new(then_session(*rest, k))),
        SessionType::Recv(t, rest) => SessionType::Recv(t, Box::new(then_session(*rest, k))),
        SessionType::Select(a, b) => {
            SessionType::Select(Box::new(then_session(*a, k)), Box::new(then_session(*b, k)))
        }
        SessionType::Branch(a, b) => {
            SessionType::Branch(Box::new(then_session(*a, k)), Box::new(then_session(*b, k)))
        }
        SessionType::Rec(x, body) => SessionType::Rec(x, Box::new(then_session(*body, k))),
        SessionType::Var(x) => SessionType::Var(x),
    }
}

/// `e`, checked against the annotation if there is one (`Expr::Ascribe`).
fn ascribe(e: Expr, annotation: Option<Ty>) -> Expr {
    match annotation {
        Some(ty) => Expr::Ascribe(Box::new(e), ty),
        None => e,
    }
}

/// The value of an integer literal token: digit separators stripped, and a
/// `0x`/`0o`/`0b` prefix read in its base. A literal with no `u64` value is an
/// error, never 0.
fn int_literal_value(literal: &str) -> Result<u64, ParseErrorKind> {
    let digits: String = literal.chars().filter(|c| *c != '_').collect();
    let (radix, body) = match digits.get(..2) {
        Some("0x") => (16, &digits[2..]),
        Some("0o") => (8, &digits[2..]),
        Some("0b") => (2, &digits[2..]),
        _ => (10, digits.as_str()),
    };
    let fail = |reason| ParseErrorKind::InvalidIntLiteral {
        literal: literal.to_string(),
        reason,
    };
    if body.is_empty() {
        return Err(fail("no digits"));
    }
    if !body.chars().all(|c| c.is_digit(radix)) {
        return Err(fail("a digit is not valid in its base"));
    }
    u64::from_str_radix(body, radix).map_err(|_| fail("too large for 64 bits"))
}

/// Map a lexed integer width suffix (`u8`..`u64`, `i8`..`i64`) to its
/// `(bits, signed)`. The lexer (`peek_int_suffix`) only ever attaches one of
/// these eight suffixes and already range-checked the magnitude, so this is the
/// total inverse used when building a sized-integer literal (`Expr::IntN`).
fn int_suffix_to_width(suffix: &str) -> Option<(u8, bool)> {
    match suffix {
        "u8" => Some((8, false)),
        "u16" => Some((16, false)),
        "u32" => Some((32, false)),
        "u64" => Some((64, false)),
        "i8" => Some((8, true)),
        "i16" => Some((16, true)),
        "i32" => Some((32, true)),
        "i64" => Some((64, true)),
        _ => None,
    }
}

impl<'a> Parser<'a> {
    pub fn new(source: &'a str) -> Self {
        let lex_error = Rc::new(RefCell::new(None));
        Self {
            lexer: LexerIter {
                lexer: Lexer::new(source),
                error: Rc::clone(&lex_error),
            }
            .peekable(),
            lex_error,
            current_span: Span { start: 0, end: 0 },
            depth: 0,
            gensym: 0,
            pending_gt: false,
            pending_decls: std::collections::VecDeque::new(),
            imports: Vec::new(),
            public_names: Vec::new(),
            pending_pub: false,
            binding_scope: Vec::new(),
            loop_depth: 0,
            type_decls: scan_type_decls(source),
            declared_types: HashSet::new(),
            type_params: Vec::new(),
        }
    }

    /// Consume a closing `>` of a generic type-argument list, transparently
    /// handling a `>>` (Shr) token that closes two nesting levels at once
    /// (e.g. `Mungkin<Senarai<Nombor>>`). The lexer emits a single `Shr` for two
    /// adjacent `>`; the first call splits it (consuming the `Shr` and leaving a
    /// pending `>`), and the next call consumes the pending half.
    fn consume_type_close(&mut self) -> Result<(), ParseError> {
        if self.pending_gt {
            self.pending_gt = false;
            return Ok(());
        }
        match self.peek().map(|t| &t.kind) {
            Some(TokenKind::Shr) => {
                // `>>` closes two angle-bracket levels: consume the token, mark
                // the second `>` pending for the enclosing generic's close.
                self.next();
                self.pending_gt = true;
                Ok(())
            }
            _ => self.consume(TokenKind::Gt).map(|_| ()),
        }
    }

    pub fn parse_expr(&mut self) -> Result<Expr, ParseError> {
        // Depth guard (REQ-30): every nested grouping `(e)`, block, argument,
        // etc. re-enters here, so bounding `parse_expr` bounds the recursion and
        // turns a stack-overflow on adversarial input into a clean error.
        self.nested(Self::parse_stmt_sequence)
    }

    /// Run `f` one nesting unit deeper, failing with
    /// [`ParseErrorKind::NestingTooDeep`] past [`MAX_EXPR_DEPTH`] units. Every
    /// self-recursive parse function enters through here (see the constant).
    fn nested<T>(
        &mut self,
        f: impl FnOnce(&mut Self) -> Result<T, ParseError>,
    ) -> Result<T, ParseError> {
        self.depth += 1;
        if self.depth > MAX_EXPR_DEPTH {
            self.depth -= 1;
            return Err(ParseError {
                kind: ParseErrorKind::NestingTooDeep,
                span: self.current_span,
            });
        }
        let result = f(self);
        self.depth -= 1;
        result
    }

    /// The error for running out of tokens: the lexical error that ended the
    /// token stream if there was one, else end of input.
    fn end_of_tokens_error(&self) -> ParseError {
        match self.lex_error.borrow().as_ref() {
            Some(e) => {
                let at = lex_error_pos(e);
                ParseError {
                    kind: ParseErrorKind::Lex(e.clone()),
                    span: Span::new(at, at + 1),
                }
            }
            None => ParseError {
                kind: ParseErrorKind::UnexpectedEof,
                span: self.current_span,
            },
        }
    }

    /// Fail with [`ParseErrorKind::ProgramTooDeep`] once a flat chain being
    /// built iteratively (statements, operator operands, `lain kalau` arms,
    /// postfix operations, …) reaches [`limits::MAX_AST_DEPTH`] links, so the
    /// parser never even BUILDS a tree deeper than that (its derived
    /// `Clone`/`Drop` recurse per level too).
    fn check_chain_len(&self, len: usize) -> Result<(), ParseError> {
        if len >= limits::MAX_AST_DEPTH {
            return Err(ParseError {
                kind: ParseErrorKind::ProgramTooDeep {
                    depth: len,
                    limit: limits::MAX_AST_DEPTH,
                },
                span: self.current_span,
            });
        }
        Ok(())
    }

    /// Parse a complete .rii file as a sequence of top-level declarations.
    pub fn parse_program(&mut self) -> Result<Program, ParseError> {
        let mut decls = Vec::new();
        let mut spans = Vec::new();
        loop {
            let start = self.peek().map(|t| t.span.start).unwrap_or(0);
            let Some(decl) = self.parse_top_level_decl()? else {
                break;
            };
            // Desugaring nests each declaration under every earlier one
            // (`Program::desugar` builds a `Let`/`LetRecGroup` chain), so the
            // program's tree is at least `decls.len() + depth(decl)` deep.
            // Checked BEFORE the clone below: cloning (and dropping) a tree
            // recurses once per level.
            let depth = decls.len() + limits::decl_depth(&decl);
            if depth > limits::MAX_AST_DEPTH {
                limits::dismantle_decl(decl);
                return Err(ParseError {
                    kind: ParseErrorKind::ProgramTooDeep {
                        depth,
                        limit: limits::MAX_AST_DEPTH,
                    },
                    span: Span::new(start, self.current_span.end),
                });
            }
            let end = self.current_span.end;
            let name_span = match &decl {
                TopLevelDecl::Function { .. } | TopLevelDecl::Binding { .. } => {
                    // Name span recorded during parsing via current_span after ident
                    None // Will be filled in by enhanced parse methods below
                }
                TopLevelDecl::Expr(_)
                | TopLevelDecl::ExternBlock { .. }
                | TopLevelDecl::Test { .. } => None,
            };
            spans.push(SpannedDecl {
                decl: decl.clone(),
                span: AstSpan::new(start, end),
                name_span,
            });
            decls.push(decl);
        }
        Ok(Program::with_modules(
            decls,
            spans,
            std::mem::take(&mut self.imports),
            std::mem::take(&mut self.public_names),
        ))
    }

    /// Parse the next top-level declaration; `None` at the end of input.
    ///
    /// Declarations with no runtime meaning of their own — `modul` blocks
    /// (whose functions are queued in `pending_decls`), `guna`,
    /// `bentuk`/`pilihan` and `jenis` — are consumed by
    /// [`Self::skip_meta_decl`] in a LOOP. This used to recurse once per
    /// skipped declaration (a long run of `guna …;` lines overflowed the
    /// stack) and, at end of input, produced a synthetic `()` declaration that
    /// `Program::desugar` then took as the program BODY: a trailing
    /// `guna`/`jenis` silently stopped `utama` from running, and a trailing
    /// `modul` block lost its queued functions.
    fn parse_top_level_decl(&mut self) -> Result<Option<TopLevelDecl>, ParseError> {
        loop {
            // Drain any decls flattened out of a `modul { ... }` block first.
            if let Some(decl) = self.pending_decls.pop_front() {
                return Ok(Some(decl));
            }
            match self.peek().map(|t| &t.kind) {
                Some(TokenKind::Eof) => return Ok(None),
                // A lexical error, not the end of the file: it used to end
                // the program silently, dropping everything after it.
                None => return Err(self.end_of_tokens_error()),
                Some(_) => {}
            }
            if !self.skip_meta_decl()? {
                break;
            }
        }
        let decl = match self.peek().map(|t| &t.kind) {
            Some(TokenKind::KwChoreography) => self.parse_choreography(),
            Some(TokenKind::KwActor) => self.parse_actor_decl(),
            Some(TokenKind::KwTest) => self.parse_test_block(),
            Some(TokenKind::KwExtern) => self.parse_extern_block(),
            Some(TokenKind::KwPub) => {
                // `awam fungsi ...` — consume the visibility keyword, then let
                // the normal decl parser run with `pending_pub` set so whatever
                // name it produces is recorded as public (REQ-71). Delegating
                // (rather than special-casing `fungsi` here) keeps `awam` working
                // for every decl form the parser already supports.
                self.consume(TokenKind::KwPub)?;
                // A type is local to its file, so `awam` cannot apply to one.
                // The loop below used to skip the type declaration and make
                // the NEXT declaration public instead.
                if matches!(
                    self.peek().map(|t| &t.kind),
                    Some(TokenKind::KwType | TokenKind::KwStruct | TokenKind::KwEnum)
                ) {
                    self.next();
                    let name = self.parse_ident()?;
                    return Err(ParseError {
                        kind: ParseErrorKind::UnsupportedTypeSyntax {
                            name,
                            what: "exported (`awam`) type declarations",
                        },
                        span: self.current_span,
                    });
                }
                self.pending_pub = true;
                // `nested`: `awam awam awam …` must not recurse unboundedly.
                let decl = self.nested(Self::parse_top_level_decl);
                self.pending_pub = false;
                // `awam` must make SOMETHING public: at end of input it is an
                // error (it used to yield a stray `()` declaration).
                let Some(d) = decl? else {
                    return Err(ParseError {
                        kind: ParseErrorKind::UnexpectedEof,
                        span: self.current_span,
                    });
                };
                match &d {
                    TopLevelDecl::Function { name, .. } | TopLevelDecl::Binding { name, .. } => {
                        if !self.public_names.contains(name) {
                            self.public_names.push(name.clone());
                        }
                    }
                    TopLevelDecl::Expr(_)
                    | TopLevelDecl::ExternBlock { .. }
                    | TopLevelDecl::Test { .. } => {}
                }
                return Ok(Some(d));
            }
            Some(TokenKind::KwFn) => self.parse_function_decl(),
            Some(TokenKind::KwLet) => {
                self.consume(TokenKind::KwLet)?;
                // Optional `ubah` (mut) modifier: a top-level mutable slot,
                // exactly as inside a function.
                let is_mut = matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwMut));
                if is_mut {
                    self.consume(TokenKind::KwMut)?;
                }
                let name = self.parse_binding_name()?;
                let annotation = self.parse_binding_annotation()?;
                self.consume(TokenKind::Eq)?;
                let value = ascribe(self.parse_control_flow()?, annotation);
                self.consume(TokenKind::Semi)?;
                // A top-level binding scopes over every declaration that
                // follows, so it stays on the scope stack (nothing pops it).
                self.binding_scope.push((name.clone(), is_mut));
                Ok(TopLevelDecl::Binding {
                    name,
                    value: Box::new(value),
                    is_mut,
                })
            }
            _ => {
                let expr = self.parse_expr()?;
                Ok(TopLevelDecl::Expr(Box::new(expr)))
            }
        }?;
        Ok(Some(decl))
    }

    /// Consume one top-level declaration that has no runtime meaning of its
    /// own (`modul`, `guna`, `bentuk`/`pilihan`, `jenis`). Returns `false`,
    /// consuming nothing, when the next token starts anything else.
    fn skip_meta_decl(&mut self) -> Result<bool, ParseError> {
        match self.peek().map(|t| &t.kind) {
            Some(TokenKind::KwMod) => {
                // Module declaration. `modul name;` (forward decl) is skipped.
                // `modul name { ...decls }` is FLATTENED: each inner `fungsi f`
                // becomes a top-level `name_f` so the existing `name::f` ->
                // `name_f` qualified-call resolution (parse_module_path) finds
                // the user definition. Any other item is an error (it used to
                // be skipped token by token).
                self.consume(TokenKind::KwMod)?;
                // Span of the NAME, not of the `modul` keyword, so the caret
                // lands on the thing the user has to change.
                let modname_span = self.peek().map(|t| t.span).unwrap_or(self.current_span);
                let modname = self.parse_ident()?;
                // REQ-82: a CAPITALIZED module name is rejected here rather than
                // flattened. `modul Masa { fungsi masa_unix }` defines
                // `Masa_masa_unix`, but `Masa::masa_unix` resolves via the
                // capitalized-namespace rule in `parse_module_path` to the bare
                // `masa_unix` — the BUILTIN. The block was therefore dead code
                // that looked live, and a stub written to make an example
                // deterministic silently got the real clock instead.
                //
                // Only the DECLARATION is rejected. The capitalized call path is
                // untouched, because that is the form the corpus actually uses.
                if modname.chars().next().is_some_and(char::is_uppercase) {
                    return Err(ParseError {
                        kind: ParseErrorKind::CapitalizedModuleName(modname),
                        span: modname_span,
                    });
                }
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LBrace)) {
                    self.consume(TokenKind::LBrace)?;
                    // `Eof` must end the scan as well as `None`: the lexer
                    // repeats `Eof` forever, so an unclosed `modul m {` used
                    // to spin here at 100% CPU (`self.next()` on `Eof` makes
                    // no progress). The `consume(RBrace)` below then reports
                    // the missing `}`.
                    while !matches!(
                        self.peek().map(|t| &t.kind),
                        Some(TokenKind::RBrace) | Some(TokenKind::Eof) | None
                    ) {
                        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwFn)) {
                            let decl = self.parse_function_decl()?;
                            if let TopLevelDecl::Function {
                                name,
                                params,
                                return_ty,
                                effect,
                                effect_set,
                                body,
                            } = decl
                            {
                                self.pending_decls.push_back(TopLevelDecl::Function {
                                    name: format!("{modname}_{name}"),
                                    params,
                                    return_ty,
                                    effect,
                                    effect_set,
                                    body,
                                });
                            }
                        } else if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwPub)) {
                            // `awam fungsi …`: a module's functions are all
                            // reachable as `m::f`, so the marker adds nothing.
                            self.next();
                        } else {
                            let tok = self.peek().expect("not at end");
                            return Err(ParseError {
                                kind: ParseErrorKind::UnsupportedModuleItem(format!("{:?}", tok.kind)),
                                span: tok.span,
                            });
                        }
                    }
                    self.consume(TokenKind::RBrace)?;
                } else {
                    self.consume(TokenKind::Semi)?;
                }
                Ok(true)
            }
            Some(TokenKind::KwUse) => {
                // `guna <name>;`            — import the sibling file <name>.rii (REQ-71).
                // `guna a::b;` / `guna std::teks;` — the BUILTIN namespace: no file
                //   behind it, so it is consumed and not recorded. This is what
                //   keeps every pre-module-system example (`guna std::senarai;`)
                //   compiling unchanged.
                self.consume(TokenKind::KwUse)?;
                let first = self.peek().and_then(|t| match &t.kind {
                    TokenKind::Identifier(n) => Some(n.clone()),
                    _ => None,
                });
                let name_span = self.peek().map(|t| t.span).unwrap_or(self.current_span);
                let mut segments = 0usize;
                // Stop at `Eof` too (the lexer yields it forever, never `None`):
                // `guna std::teks` with no `;` used to hang here. The
                // `consume(Semi)` below turns it into a clean error.
                while !matches!(
                    self.peek().map(|t| &t.kind),
                    Some(TokenKind::Semi) | Some(TokenKind::Eof) | None
                ) {
                    if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::ColonColon)) {
                        segments += 1;
                    }
                    self.next();
                }
                self.consume(TokenKind::Semi)?;
                if segments == 0 {
                    if let Some(module) = first {
                        // Deduplicate: importing the same module twice is
                        // harmless, and the resolver loads each file once.
                        if !self.imports.iter().any(|i| i.module == module) {
                            self.imports.push(Import {
                                module,
                                span: AstSpan::new(name_span.start, name_span.end),
                            });
                        }
                    }
                }
                Ok(true)
            }
            Some(TokenKind::KwStruct) | Some(TokenKind::KwEnum) => {
                // bentuk/pilihan: the name is declared (it reads as `Any`, see
                // `TypeDecl::Untyped`); the body has no meaning yet.
                self.next(); // consume KwStruct or KwEnum
                self.declare_type()?;
                self.consume(TokenKind::LBrace)?;
                self.skip_balanced_braces()?;
                Ok(true)
            }
            Some(TokenKind::KwType) => {
                // jenis. Forms handled:
                //   jenis Name = Type;          (alias: Name means Type)
                //   jenis Name { ... }          (record, reads as `Any`)
                //   jenis Name<T, ...> { ... }
                //   jenis Name = { ... };  jenis Name = | A | B(T);
                //   jenis Name = Name(T);       (record and variant types)
                //   jenis Name                  (marker type, no body)
                self.next(); // consume KwType
                let name = self.declare_type()?;
                let name_span = self.current_span;
                // Optional generic parameter list `<...>` — skip balanced angles.
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Lt)) {
                    self.next();
                    let mut depth = 1u32;
                    while depth > 0 {
                        match self.peek().map(|t| &t.kind) {
                            Some(TokenKind::Lt) => {
                                self.next();
                                depth += 1;
                            }
                            Some(TokenKind::Gt) => {
                                self.next();
                                depth -= 1;
                            }
                            // `>>` closes two levels (`jenis T<A<B>>`). It was
                            // skipped like any other token, so the scan ran on
                            // past the declaration and swallowed the rest of
                            // the file.
                            Some(TokenKind::Shr) => {
                                self.next();
                                depth = depth.saturating_sub(2);
                            }
                            // Terminate at Eof (lexer repeats Eof, never None) so
                            // unclosed `<` doesn't loop forever (REQ-30) — and
                            // report it, rather than accept a truncated decl.
                            Some(TokenKind::Eof) | None => {
                                return Err(ParseError {
                                    kind: ParseErrorKind::UnexpectedEof,
                                    span: self.current_span,
                                });
                            }
                            _ => {
                                self.next();
                            }
                        }
                    }
                }
                match self.peek().map(|t| &t.kind) {
                    // Record body: `jenis Name { ... }`
                    Some(TokenKind::LBrace) => {
                        self.next();
                        self.skip_balanced_braces()?;
                    }
                    // Type alias `jenis Name = SomeType;`: parse the type.
                    // It used to be skipped, so `Name` read as `Any`.
                    Some(TokenKind::Eq) => {
                        self.next();
                        match self.type_decls.get(&name) {
                            Some(TypeDecl::Alias(_)) => {
                                let ty = self.parse_ty()?;
                                self.consume(TokenKind::Semi)?;
                                self.type_decls.insert(name, TypeDecl::Alias(Some(ty)));
                                return Ok(true);
                            }
                            Some(TypeDecl::GenericAlias) => {
                                return Err(ParseError {
                                    kind: ParseErrorKind::UnsupportedTypeSyntax {
                                        name,
                                        what: "generic type aliases",
                                    },
                                    span: name_span,
                                });
                            }
                            Some(TypeDecl::Untyped { .. }) | None => {}
                        }
                        // A record or variant body: skip to the `;`. The scan
                        // stops at `Eof` as well: the lexer repeats `Eof`
                        // forever, so `jenis T =` with no `;` used to spin at
                        // 100% CPU (hanging `check`, `fmt`, the LSP and MCP).
                        while !matches!(
                            self.peek().map(|t| &t.kind),
                            Some(TokenKind::Semi) | Some(TokenKind::Eof) | None
                        ) {
                            self.next();
                        }
                        self.consume(TokenKind::Semi)?;
                    }
                    // Marker type with no body: `jenis Name`
                    _ => {}
                }
                Ok(true)
            }
            _ => Ok(false),
        }
    }

    /// Parse the name of a type declaration, rejecting a built-in type's name
    /// and a name this file already declared.
    fn declare_type(&mut self) -> Result<Ident, ParseError> {
        let name = self.parse_ident()?;
        let builtin = BUILTIN_TYPE_NAMES.contains(&name.as_str());
        if builtin || !self.declared_types.insert(name.clone()) {
            return Err(ParseError {
                kind: ParseErrorKind::TypeRedeclared { name, builtin },
                span: self.current_span,
            });
        }
        Ok(name)
    }

    /// Resolve a type name that is not built in: a generic parameter, an
    /// alias, or a declared record or variant type. Anything else is an
    /// error. It used to be `Any`, which accepted every value.
    fn resolve_named_type(&mut self, name: Ident) -> Result<Ty, ParseError> {
        let span = self.current_span;
        if self.type_params.contains(&name) {
            // Generic parameters have no semantics yet: `T` is `Any`.
            return Ok(Ty::Any);
        }
        let kind = match self.type_decls.get(&name) {
            Some(TypeDecl::Alias(Some(ty))) => return Ok(ty.clone()),
            Some(TypeDecl::Untyped { generic }) => {
                // The arguments of a generic record have no meaning yet either,
                // but they are parsed, so a name in them is checked.
                if *generic && matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Lt)) {
                    self.next();
                    self.parse_ty()?;
                    // A pending `>` (from an argument's `>>`) closes this
                    // list: the `,` after it belongs to the enclosing one.
                    while !self.pending_gt
                        && matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma))
                    {
                        self.next();
                        self.parse_ty()?;
                    }
                    self.consume_type_close()?;
                }
                return Ok(Ty::Any);
            }
            Some(TypeDecl::Alias(None)) => ParseErrorKind::TypeAliasBeforeDeclaration(name),
            Some(TypeDecl::GenericAlias) => ParseErrorKind::UnsupportedTypeSyntax {
                name,
                what: "generic type aliases",
            },
            None => {
                let suggestion = self.nearest_type_name(&name);
                ParseErrorKind::UnknownType { name, suggestion }
            }
        };
        Err(ParseError { kind, span })
    }

    /// The known type name closest to `name`, if it is close enough to be a
    /// likely typo.
    fn nearest_type_name(&self, name: &str) -> Option<String> {
        let limit = (name.chars().count() / 3).max(1);
        BUILTIN_TYPE_NAMES
            .iter()
            .copied()
            .chain(self.type_decls.keys().map(String::as_str))
            .chain(self.type_params.iter().map(String::as_str))
            .map(|cand| (edit_distance(name, cand), cand))
            .filter(|(d, _)| *d <= limit)
            .min()
            .map(|(_, cand)| cand.to_string())
    }

    /// `<T, U>` after a function name: the parameter names. A bound
    /// (`<T: Sifat>`) is an error, since nothing would check it.
    fn parse_generic_params(&mut self) -> Result<Vec<Ident>, ParseError> {
        let mut names = Vec::new();
        if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Lt)) {
            return Ok(names);
        }
        self.next();
        loop {
            let name = self.parse_ident()?;
            // A built-in name would be read as the built-in type, never as
            // the parameter.
            if BUILTIN_TYPE_NAMES.contains(&name.as_str()) {
                return Err(ParseError {
                    kind: ParseErrorKind::TypeRedeclared { name, builtin: true },
                    span: self.current_span,
                });
            }
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Colon)) {
                return Err(ParseError {
                    kind: ParseErrorKind::UnsupportedTypeSyntax {
                        name,
                        what: "bounds on generic parameters",
                    },
                    span: self.current_span,
                });
            }
            names.push(name);
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                self.next();
            } else {
                self.consume(TokenKind::Gt)?;
                return Ok(names);
            }
        }
    }

    fn parse_function_decl(&mut self) -> Result<TopLevelDecl, ParseError> {
        self.consume(TokenKind::KwFn)?;
        let name_span = self.peek().map(|t| t.span).unwrap_or(self.current_span);
        let mut name = self.parse_ident()?;
        // A qualified method-style definition name `Type::method` resolves to the
        // flat builtin name `Type_method` for a lowercase module, or to the final
        // segment for a capitalized namespace — matching how `::` call sites
        // resolve (see `parse_module_path`), so definitions and calls line up.
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::ColonColon)) {
            name = self.parse_module_path(name)?;
        }
        // REQ-82, second half: a function whose RESOLVED name starts uppercase
        // can never be called, because an uppercase identifier at a call position
        // is a data constructor. `fungsi Kira_tokokan(x)` parsed, and
        // `Kira_tokokan(1)` then evaluated to the tuple `(Kira_tokokan, 1)` —
        // a silent wrong answer with no diagnostic anywhere.
        //
        // The decision this encodes: uppercase-at-a-call-site stays a
        // constructor (that rule is load-bearing for nominal enums), so the
        // definition is what gives way.
        //
        // Checked AFTER `::` resolution on purpose: `fungsi Masa::dapat_bulan`
        // has an uppercase first segment but resolves to the lowercase
        // `dapat_bulan`, and that form is the recommended migration — it must
        // keep working.
        if name.chars().next().is_some_and(char::is_uppercase) {
            return Err(ParseError {
                kind: ParseErrorKind::CapitalizedFunctionName(name),
                span: name_span,
            });
        }
        // Optional generic parameter list `<T>`, `<E, T>`, `<T1, T2>`, etc.
        // RIINA's type system is monomorphic at this layer: each parameter
        // reads as `Any` in the signature and body.
        let generics = self.parse_generic_params()?;
        let outer_params = self.type_params.len();
        self.type_params.extend(generics);
        let decl = self.parse_function_rest(name);
        self.type_params.truncate(outer_params);
        decl
    }

    /// The parameters, return type, effect and body of a `fungsi`.
    fn parse_function_rest(&mut self, name: Ident) -> Result<TopLevelDecl, ParseError> {
        self.consume(TokenKind::LParen)?;
        let params = self.parse_param_list()?;
        self.consume(TokenKind::RParen)?;

        // Optional return type. `-> kesan <eff>` (an arrow immediately followed
        // by the effect keyword) denotes a Unit return with only an effect
        // annotation, so the arrow consumes no type in that case.
        let return_ty = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Arrow)) {
            self.consume(TokenKind::Arrow)?;
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwEffect)) {
                Ty::Unit
            } else {
                self.parse_ty()?
            }
        } else {
            Ty::Unit
        };

        // Optional effect annotation
        let (effect, effect_set) =
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwEffect)) {
                self.consume(TokenKind::KwEffect)?;
                self.parse_effect_annotation()?
            } else {
                (Effect::Pure, vec![Effect::Pure])
            };

        // Body in braces. Parameters shadow any outer `biar ubah` of the same
        // name, so a parameter read stays a plain `Var`.
        self.consume(TokenKind::LBrace)?;
        let scope: Vec<(Ident, bool)> = params.iter().map(|(n, _)| (n.clone(), false)).collect();
        let body = self.with_bindings(&scope, Self::parse_expr)?;
        self.consume(TokenKind::RBrace)?;

        Ok(TopLevelDecl::Function {
            name,
            params,
            return_ty,
            effect,
            effect_set,
            body: Box::new(body),
        })
    }

    /// Parse: luaran "C" { fungsi name(params) -> ret_ty; ... }
    /// Parse: ujian "name" { body }
    fn parse_test_block(&mut self) -> Result<TopLevelDecl, ParseError> {
        self.consume(TokenKind::KwTest)?;
        // Expect test name as string literal
        let name = match self.peek().map(|t| t.kind.clone()) {
            Some(TokenKind::LiteralString(s)) => {
                self.next();
                s
            }
            _ => {
                return Err(ParseError {
                    kind: ParseErrorKind::ExpectedExpression,
                    span: self.current_span,
                });
            }
        };
        self.consume(TokenKind::LBrace)?;
        let body = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;
        Ok(TopLevelDecl::Test {
            name,
            body: Box::new(body),
        })
    }

    fn parse_extern_block(&mut self) -> Result<TopLevelDecl, ParseError> {
        self.consume(TokenKind::KwExtern)?;
        // Expect ABI string literal "C"
        let abi = match self.peek().map(|t| t.kind.clone()) {
            Some(TokenKind::LiteralString(s)) => {
                self.next();
                s
            }
            _ => {
                return Err(ParseError {
                    kind: ParseErrorKind::ExpectedExpression,
                    span: self.current_span,
                });
            }
        };
        self.consume(TokenKind::LBrace)?;
        let mut decls = Vec::new();
        while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace) | None) {
            self.consume(TokenKind::KwFn)?;
            let name = self.parse_ident()?;
            self.consume(TokenKind::LParen)?;
            let params = self.parse_param_list()?;
            self.consume(TokenKind::RParen)?;
            let ret_ty = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Arrow)) {
                self.consume(TokenKind::Arrow)?;
                self.parse_ty()?
            } else {
                Ty::Unit
            };
            self.consume(TokenKind::Semi)?;
            decls.push(ExternDecl {
                name,
                params,
                ret_ty,
                effect: Effect::System,
            });
        }
        self.consume(TokenKind::RBrace)?;
        Ok(TopLevelDecl::ExternBlock { abi, decls })
    }

    fn parse_param_list(&mut self) -> Result<Vec<(Ident, Ty)>, ParseError> {
        let mut params = Vec::new();
        if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
            // Optional mut/ubah modifier (ignored for now)
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwMut)) {
                self.consume(TokenKind::KwMut)?;
            }
            let name = self.parse_binding_name()?;
            self.consume(TokenKind::Colon)?;
            let ty = self.parse_ty()?;
            params.push((name, ty));

            while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                // Parameters curry into a nested `Lam` chain.
                self.check_chain_len(params.len())?;
                self.consume(TokenKind::Comma)?;
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwMut)) {
                    self.consume(TokenKind::KwMut)?;
                }
                let name = self.parse_binding_name()?;
                self.consume(TokenKind::Colon)?;
                let ty = self.parse_ty()?;
                params.push((name, ty));
            }
        }
        Ok(params)
    }

    /// Parse a sequence of statements separated by semicolons.
    /// stmt_seq ::= (stmt ';')* expr
    /// A `biar` binding: `biar x = e1; rest` desugars to Let(x, e1, rest).
    /// A non-binding expression followed by `;`: `e1; rest` desugars to Let("_", e1, rest).
    ///
    /// The sequence is parsed ITERATIVELY: each statement becomes a
    /// [`SeqFrame`] and the nested `Let` chain is folded together afterwards
    /// (see [`Self::fold_stmt_frames`]). This used to recurse once per
    /// statement — through `with_bindings` closures as well — so a few
    /// thousand consecutive `biar` lines overflowed the stack even in a
    /// release build. The produced AST, the scoping of `biar ubah` slots and
    /// the order of generated names are unchanged.
    fn parse_stmt_sequence(&mut self) -> Result<Expr, ParseError> {
        // Names bound by the sequence scope over the rest of it and are
        // popped when it ends, exactly as the nested `with_bindings` calls
        // did.
        let mark = self.binding_scope.len();
        let parsed = self.parse_stmt_frames();
        self.binding_scope.truncate(mark);
        let (frames, tail) = parsed?;
        self.fold_stmt_frames(frames, tail)
    }

    /// Parse the statements of a sequence up to its end, returning one frame
    /// per statement plus the sequence's final value (its tail).
    fn parse_stmt_frames(&mut self) -> Result<(Vec<SeqFrame>, Expr), ParseError> {
        let mut frames: Vec<SeqFrame> = Vec::new();
        loop {
            self.check_chain_len(frames.len())?;

            // Local (nested) function declaration: `fungsi f(..) -> T { .. }`
            // in statement position. Desugars to a recursive `LetRec` binding
            // whose continuation is the rest of the sequence, mirroring how
            // top-level functions desugar. Distinguished from a lambda
            // (`fn(x: T) body`) by a *named* head: `fn`/`fungsi` immediately
            // followed by an identifier.
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwFn))
                && self.next_is_named_fn()
            {
                let decl = self.parse_function_decl()?;
                let (name, params, return_ty, effect, body) = match decl {
                    TopLevelDecl::Function {
                        name,
                        params,
                        return_ty,
                        effect,
                        effect_set,
                        body,
                    } => (
                        name,
                        params,
                        return_ty,
                        // The whole declared set, not the lossy lattice join (M1c).
                        EffectSet::from_declaration(effect, &effect_set),
                        body,
                    ),
                    _ => unreachable!("parse_function_decl returns Function"),
                };
                // Build the curried lambda and its function type through the
                // SAME helper top-level declarations use. This was a third
                // hand-rolled copy of the fold, and it diverged: when
                // zero-parameter functions gained a synthesised `()` parameter
                // (REQ-68) a NESTED zero-arg `fungsi` kept the old thunk shape
                // here, so calling it applied a non-function.
                let (lam, fn_ty) = riina_types::desugar_function(params, return_ty, effect, body);
                frames.push(SeqFrame::LocalFn {
                    name: name.clone(),
                    fn_ty,
                    lam,
                });
                if self.at_sequence_end() {
                    return Ok((frames, Expr::Var(name)));
                }
                continue;
            }

            // Check if this is a let-binding
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwLet)) {
                self.consume(TokenKind::KwLet)?;
                // Optional `ubah` (mut) modifier: `biar ubah x = e` binds a real
                // mutable slot (see `Expr::LetMut`). Without it the binding is
                // immutable, as before.
                let is_mut = matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwMut));
                if is_mut {
                    self.consume(TokenKind::KwMut)?;
                }
                let linearity = match self.peek().map(|t| &t.kind) {
                    Some(TokenKind::KwSekali) => {
                        self.next();
                        Some(Linearity::Linear)
                    }
                    Some(TokenKind::KwPaling) => {
                        self.next();
                        Some(Linearity::Affine)
                    }
                    Some(TokenKind::KwMesti) => {
                        self.next();
                        Some(Linearity::Relevant)
                    }
                    _ => None,
                };
                // Tuple-destructuring binding: `biar (a, b, ...) = e; rest`. Binds
                // a fresh temp to `e`, then projects each name via Fst/Snd
                // (left-nested pairs, matching how tuples are constructed).
                // Nested patterns are not supported here — only a flat list of
                // identifiers.
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
                    self.consume(TokenKind::LParen)?;
                    let mut names = vec![self.parse_ident()?];
                    while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                        self.consume(TokenKind::Comma)?;
                        names.push(self.parse_ident()?);
                    }
                    self.consume(TokenKind::RParen)?;
                    self.consume(TokenKind::Eq)?;
                    let value = self.parse_control_flow()?;
                    self.consume(TokenKind::Semi)?;
                    self.binding_scope
                        .extend(names.iter().map(|n| (n.clone(), false)));
                    frames.push(SeqFrame::TupleLet {
                        names,
                        linearity,
                        value,
                    });
                    if self.at_sequence_end() {
                        return Ok((frames, Expr::Unit));
                    }
                    continue;
                }
                let name = self.parse_binding_name()?;
                let annotation = self.parse_binding_annotation()?;
                self.consume(TokenKind::Eq)?;
                let value = ascribe(self.parse_control_flow()?, annotation);
                self.consume(TokenKind::Semi)?;
                // The name is in scope for the rest of the sequence, shadowing
                // any outer binding of the same name.
                self.binding_scope.push((name.clone(), is_mut));
                frames.push(if is_mut {
                    SeqFrame::LetMut {
                        name,
                        value,
                        has_linearity: linearity.is_some(),
                    }
                } else {
                    SeqFrame::Let {
                        name,
                        linearity,
                        value,
                    }
                });
                // A trailing binding with nothing after it (`biar x = e;` then
                // `}`/EOF) yields Unit as the block's value.
                if self.at_sequence_end() {
                    return Ok((frames, Expr::Unit));
                }
                continue;
            }

            // Statement-position assignment: `x = e;`.
            //
            // For a `biar ubah` name this is a real slot write, visible to every
            // later read of `x` — including reads OUTSIDE the enclosing block,
            // which is the whole point: `kalau c { jumlah = jumlah + 1; }` inside
            // a loop has to accumulate.
            //
            // For any other name it keeps the historical meaning — rebinding `x`
            // (shadowing) for the rest of this sequence. That is observationally
            // equivalent for straight-line code and keeps programs that never
            // say `ubah` working exactly as before, but it does NOT escape the
            // block, so `biar ubah` is the form to reach for.
            //
            // Detected as `ident =` where the next token is a single `=` (not
            // `==`). Field/element assignments (`obj.f = e`) fall through to
            // normal parsing.
            if let Some(name) = self.peek_simple_reassignment() {
                self.parse_ident()?; // consume the name
                self.consume(TokenKind::Eq)?;
                let value = self.parse_control_flow()?;
                self.consume(TokenKind::Semi)?;
                if self.is_slot(&name) {
                    frames.push(SeqFrame::Seq {
                        name: "_".to_string(),
                        value: Expr::SlotSet(name, Box::new(value)),
                    });
                    if self.at_sequence_end() {
                        return Ok((frames, Expr::Unit));
                    }
                    continue;
                }
                self.binding_scope.push((name.clone(), false));
                frames.push(SeqFrame::Seq {
                    name: name.clone(),
                    value,
                });
                if self.at_sequence_end() {
                    return Ok((frames, Expr::Var(name)));
                }
                continue;
            }

            // A guard statement `pastikan …;` scopes over the REST of the
            // sequence (it desugars to `kalau cond { rest } lain { … }`), so it
            // is a frame here too — handing the rest to `parse_guard` would
            // recurse once per guard.
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwGuard)) {
                let (cond, otherwise) = self.parse_guard_head()?;
                let needs_rest = matches!(otherwise, GuardElse::Block(_));
                frames.push(SeqFrame::Guard {
                    cond,
                    otherwise: otherwise.into_expr(),
                });
                // The `lain { … };` form always continues with the rest of the
                // sequence (an empty rest is a parse error, as before); the
                // assertion form ends the sequence with `()` when nothing follows.
                if !needs_rest && self.at_sequence_end() {
                    return Ok((frames, Expr::Unit));
                }
                continue;
            }

            // A block-form statement (`kalau`/`padan`/`selagi`/`untuk`/`ulang`)
            // may be used in statement position without a trailing `;`, e.g. an
            // early-return guard `kalau c { pulang x; }` followed by more
            // statements. Other expressions still require a `;` to start a
            // sequence.
            let first_is_block_form = matches!(
                self.peek().map(|t| &t.kind),
                Some(TokenKind::KwIf)
                    | Some(TokenKind::KwMatch)
                    | Some(TokenKind::KwWhile)
                    | Some(TokenKind::KwFor)
                    | Some(TokenKind::KwLoop)
            );

            let first = self.parse_control_flow()?;

            // If next token is ';', this is a statement sequence
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Semi)) {
                self.consume(TokenKind::Semi)?;
                // A trailing `;` before the block end (`expr;` then `}`/EOF) —
                // e.g. a final `pulang x;` — yields `expr` as the block's value.
                // RIINA marks returns explicitly with `pulang`, so `pulang x;}` is
                // intended to return `x`, not discard it.
                if self.at_sequence_end() {
                    return Ok((frames, first));
                }
                frames.push(SeqFrame::Seq {
                    name: "_".to_string(),
                    value: first,
                });
                continue;
            }
            if first_is_block_form && !self.at_sequence_end() {
                // No `;`, but a block-form statement is followed by more
                // statements — e.g. `kalau c { pulang x; }` (a guard) then
                // further statements. Sequence `first` (its value discarded)
                // before the rest.
                frames.push(SeqFrame::Seq {
                    name: "_".to_string(),
                    value: first,
                });
                continue;
            }
            return Ok((frames, first));
        }
    }

    /// Fold parsed statement frames, innermost (last) first, around the
    /// sequence's tail into the nested core-calculus expression.
    fn fold_stmt_frames(&mut self, frames: Vec<SeqFrame>, tail: Expr) -> Result<Expr, ParseError> {
        let mut acc = tail;
        for frame in frames.into_iter().rev() {
            acc = match frame {
                SeqFrame::LocalFn { name, fn_ty, lam } => {
                    Expr::LetRec(name, fn_ty, Box::new(lam), Box::new(acc))
                }
                SeqFrame::TupleLet {
                    names,
                    linearity,
                    value,
                } => {
                    let tmp = self.fresh_var("padTup");
                    // Bind the names from the temp via Fst/Snd projection; the
                    // last element is the final `Snd` of the left-nested pair
                    // chain.
                    let mut bound = acc;
                    let n = names.len();
                    for (i, nm) in names.iter().enumerate().rev() {
                        let proj = self.tuple_proj(&tmp, i, n);
                        bound = Expr::Let(nm.clone(), None, Box::new(proj), Box::new(bound));
                    }
                    Expr::Let(tmp, linearity, Box::new(value), Box::new(bound))
                }
                SeqFrame::Let {
                    name,
                    linearity,
                    value,
                } => Expr::Let(name, linearity, Box::new(value), Box::new(acc)),
                SeqFrame::LetMut {
                    name,
                    value,
                    has_linearity,
                } => {
                    // A slot has no linearity slot to carry, and "use exactly
                    // once" does not combine with "assign repeatedly" anyway.
                    // Reject the pair rather than silently dropping the
                    // qualifier.
                    if has_linearity {
                        limits::dismantle(acc);
                        return Err(ParseError {
                            kind: ParseErrorKind::MutWithLinearity,
                            span: self.current_span,
                        });
                    }
                    Expr::LetMut(name, Box::new(value), Box::new(acc))
                }
                SeqFrame::Seq { name, value } => {
                    Expr::Let(name, None, Box::new(value), Box::new(acc))
                }
                SeqFrame::Guard { cond, otherwise } => {
                    Expr::If(Box::new(cond), Box::new(acc), Box::new(otherwise))
                }
            };
        }
        Ok(acc)
    }

    /// True when the next token ends a statement sequence — a block close `}`
    /// or end of input. Used to allow a trailing `;` after the final statement.
    fn at_sequence_end(&mut self) -> bool {
        matches!(
            self.peek().map(|t| &t.kind),
            Some(TokenKind::RBrace) | Some(TokenKind::Eof) | None
        )
    }

    /// Skip tokens up to and including the `}` that closes an already-consumed
    /// opening `{`. Tracks nesting so inner braces don't end the skip early.
    /// Reaching the end of input first is an error: an unclosed `bentuk S {`
    /// used to be accepted as a complete declaration.
    fn skip_balanced_braces(&mut self) -> Result<(), ParseError> {
        let mut depth = 1u32;
        while depth > 0 {
            match self.peek().map(|t| &t.kind) {
                Some(TokenKind::LBrace) => {
                    self.next();
                    depth += 1;
                }
                Some(TokenKind::RBrace) => {
                    self.next();
                    depth -= 1;
                }
                // The lexer yields `Eof` repeatedly (never `None`) at end of
                // input, so an Eof here must terminate the skip — otherwise the
                // `_` arm consumes it without progress and loops forever on
                // unclosed input like `fungsi x<` (REQ-30, fuzz-found).
                Some(TokenKind::Eof) | None => {
                    return Err(ParseError {
                        kind: ParseErrorKind::UnexpectedEof,
                        span: self.current_span,
                    });
                }
                _ => {
                    self.next();
                }
            }
        }
        Ok(())
    }

    fn peek(&mut self) -> Option<&Token> {
        self.lexer.peek()
    }

    /// True when the current position begins a record-literal body: the next
    /// token is `{` and the one after is an identifier followed by `:`. Uses a
    /// cheap clone of the token stream for two-token lookahead; this avoids
    /// misreading a control-flow block as a record. A bare `{ }` (empty record)
    /// also qualifies.
    /// If the upcoming tokens are `<identifier> =` (a simple variable
    /// reassignment, with a single `=` — not `==`, and not `ident.field =`),
    /// return the identifier name. Uses a two-token clone-based lookahead so the
    /// real stream is untouched.
    /// True when `name` currently resolves to a `biar ubah` slot.
    fn is_slot(&self, name: &str) -> bool {
        self.binding_scope
            .iter()
            .rev()
            .find(|(n, _)| n == name)
            .is_some_and(|(_, is_mut)| *is_mut)
    }

    /// Read a name: a mutable slot reads through [`Expr::SlotGet`], everything
    /// else stays an ordinary [`Expr::Var`].
    fn name_ref(&self, name: Ident) -> Expr {
        if self.is_slot(&name) {
            Expr::SlotGet(name)
        } else {
            Expr::Var(name)
        }
    }

    /// Parse `body_fn` with `names` in scope, then restore the previous scope.
    fn with_bindings<T>(
        &mut self,
        names: &[(Ident, bool)],
        body_fn: impl FnOnce(&mut Self) -> Result<T, ParseError>,
    ) -> Result<T, ParseError> {
        let mark = self.binding_scope.len();
        self.binding_scope.extend(names.iter().cloned());
        let out = body_fn(self);
        self.binding_scope.truncate(mark);
        out
    }

    fn peek_simple_reassignment(&mut self) -> Option<Ident> {
        let mut ahead = self.lexer.clone();
        let name = match ahead.next().map(|t| t.kind) {
            Some(TokenKind::Identifier(s)) => s,
            _ => return None,
        };
        match ahead.next().map(|t| t.kind) {
            Some(TokenKind::Eq) => Some(name),
            _ => None,
        }
    }

    /// True when the upcoming tokens are `fn`/`fungsi` followed by an identifier
    /// — i.e. a *named* function declaration, as opposed to a lambda
    /// (`fn(x: T) body`). Uses a cheap clone of the token stream for two-token
    /// lookahead.
    fn next_is_named_fn(&mut self) -> bool {
        let mut ahead = self.lexer.clone();
        ahead.next(); // skip `fn`/`fungsi`
        matches!(ahead.next().map(|t| t.kind), Some(TokenKind::Identifier(_)))
    }

    fn looks_like_record_literal(&mut self) -> bool {
        if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LBrace)) {
            return false;
        }
        let mut ahead = self.lexer.clone();
        ahead.next(); // skip `{`
        match ahead.next().map(|t| t.kind) {
            Some(TokenKind::RBrace) => true, // empty record `{}`
            // A field name is an identifier or a soft keyword (e.g. `tahap:`).
            Some(TokenKind::Identifier(_)) => {
                matches!(ahead.next().map(|t| t.kind), Some(TokenKind::Colon))
            }
            Some(ref k) if Self::soft_keyword_spelling(k).is_some() => {
                matches!(ahead.next().map(|t| t.kind), Some(TokenKind::Colon))
            }
            _ => false,
        }
    }

    /// Parse a record-literal body starting at the `{` (the type name has been
    /// consumed): `{ field1: e1, field2: e2, ... }`. Trailing comma allowed.
    fn parse_record_literal_body(&mut self, type_name: Ident) -> Result<Expr, ParseError> {
        self.consume(TokenKind::LBrace)?;
        let mut fields = Vec::new();
        while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace) | None) {
            let field = self.parse_binding_name()?;
            self.consume(TokenKind::Colon)?;
            let value = self.parse_control_flow()?;
            fields.push((field, value));
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                self.consume(TokenKind::Comma)?;
            } else {
                break;
            }
        }
        self.consume(TokenKind::RBrace)?;
        Ok(Expr::RecordLit(type_name, fields))
    }

    /// Parse a qualified module path `Module::function` (the first segment is
    /// already consumed and passed as `first`). Resolves to a flat builtin name.
    ///
    /// A leading `std` segment is dropped (`std::teks::mengandungi`). A lowercase
    /// module (a type's own methods) maps to `module_function`
    /// (`teks::mengandungi` -> `teks_mengandungi`). A capitalized module (a
    /// namespace) drops the module and uses the final segment, which already
    /// carries its full builtin name (`Masa::masa_unix` -> `masa_unix`).
    ///
    /// Names that resolve to a non-existent builtin fail later at type-check with
    /// "Variable not found", which is the correct behavior.
    /// Parse a `format!("template", args...)` macro (the `format` identifier is
    /// already consumed). Desugars to string concatenation: the template is split
    /// on `{}` placeholders, and each placeholder is replaced by `ke_teks(arg)`
    /// of the corresponding positional argument. Literal `{{`/`}}` are unescaped
    /// to `{`/`}`. The result type is `Teks` (String).
    ///
    /// Example: `format!("a={} b={}", x, y)` becomes
    /// `"a=" + ke_teks(x) + " b=" + ke_teks(y) + ""`.
    fn parse_format_macro(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::Not)?;
        self.consume(TokenKind::LParen)?;
        let template = match self.peek().map(|t| t.kind.clone()) {
            Some(TokenKind::LiteralString(s)) => {
                self.next();
                s
            }
            _ => {
                return Err(ParseError {
                    kind: ParseErrorKind::UnexpectedToken(
                        self.peek().map(|t| t.kind.clone()).unwrap_or(TokenKind::Eof),
                    ),
                    span: self.current_span,
                });
            }
        };
        // Parse the (optional) positional arguments.
        let mut args = Vec::new();
        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
            self.consume(TokenKind::Comma)?;
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                break; // trailing comma
            }
            args.push(self.parse_control_flow()?);
        }
        self.consume(TokenKind::RParen)?;

        // Split the template into literal segments around `{}` placeholders,
        // honoring `{{`/`}}` escapes.
        let mut segments: Vec<String> = Vec::new();
        let mut cur = String::new();
        let mut chars = template.chars().peekable();
        let mut placeholders = 0usize;
        while let Some(c) = chars.next() {
            match c {
                '{' if chars.peek() == Some(&'{') => {
                    chars.next();
                    cur.push('{');
                }
                '}' if chars.peek() == Some(&'}') => {
                    chars.next();
                    cur.push('}');
                }
                '{' => {
                    // Placeholder `{}` or `{name}`/`{:spec}` — skip to the `}`.
                    while let Some(&n) = chars.peek() {
                        chars.next();
                        if n == '}' {
                            break;
                        }
                    }
                    segments.push(std::mem::take(&mut cur));
                    placeholders += 1;
                }
                _ => cur.push(c),
            }
        }
        segments.push(cur);
        // Two left-nested `+` levels per placeholder.
        self.check_chain_len(2 * placeholders)?;

        // Build: seg0 + ke_teks(arg0) + seg1 + ke_teks(arg1) + ... + segN.
        // `segments` has exactly `placeholders + 1` entries. Missing args (fewer
        // than placeholders) stringify the empty string; extra args are ignored.
        let mut result = Expr::String(segments[0].clone());
        for (i, seg) in segments.iter().enumerate().skip(1) {
            // Insert the stringified argument for the placeholder before this seg.
            let arg_expr = match args.get(i - 1) {
                Some(a) => Expr::App(
                    Box::new(Expr::Var("ke_teks".to_string())),
                    Box::new(a.clone()),
                ),
                None => Expr::String(String::new()),
            };
            result = Expr::BinOp(BinOp::Add, Box::new(result), Box::new(arg_expr));
            result = Expr::BinOp(
                BinOp::Add,
                Box::new(result),
                Box::new(Expr::String(seg.clone())),
            );
        }
        let _ = placeholders;
        Ok(result)
    }

    fn parse_module_path(&mut self, first: Ident) -> Result<Ident, ParseError> {
        let mut segments = vec![first];
        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::ColonColon)) {
            self.consume(TokenKind::ColonColon)?;
            segments.push(self.parse_ident()?);
        }
        // Drop a leading `std` namespace.
        if segments.len() > 1 && segments[0] == "std" {
            segments.remove(0);
        }
        if segments.len() == 1 {
            return Ok(segments.pop().unwrap());
        }
        if segments.len() > 2 {
            return Err(ParseError {
                kind: ParseErrorKind::NestedModulePath(segments.join("::")),
                span: self.current_span,
            });
        }
        let module = &segments[0];
        let func = segments.last().unwrap();
        let starts_upper = module
            .chars()
            .next()
            .map(|c| c.is_uppercase())
            .unwrap_or(false);
        if starts_upper {
            Ok(func.clone())
        } else {
            Ok(format!("{module}_{func}"))
        }
    }

    /// Parse the argument of an Option/Result constructor: either parenthesized
    /// `(e)` (the common `Some(x)` form) or a bare unary expression (`Some x`).
    fn parse_constructor_arg(&mut self) -> Result<Expr, ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
            self.consume(TokenKind::LParen)?;
            let e = self.parse_control_flow()?;
            self.consume(TokenKind::RParen)?;
            Ok(e)
        } else {
            self.parse_unary()
        }
    }

    fn next(&mut self) -> Option<Token> {
        let token = self.lexer.next();
        if let Some(t) = &token {
            self.current_span = t.span;
        }
        token
    }

    fn consume(&mut self, kind: TokenKind) -> Result<Token, ParseError> {
        let matches = if let Some(token) = self.peek() {
            token.kind == kind
        } else {
            false
        };

        if matches {
            Ok(self.next().unwrap())
        } else if let Some(token) = self.peek() {
            Err(ParseError {
                kind: ParseErrorKind::UnexpectedToken(token.kind.clone()),
                span: token.span,
            })
        } else {
            Err(self.end_of_tokens_error())
        }
    }

    /// Nesting-guarded entry (see [`MAX_EXPR_DEPTH`]).
    fn parse_control_flow(&mut self) -> Result<Expr, ParseError> {
        self.nested(Self::parse_control_flow_inner)
    }

    fn parse_control_flow_inner(&mut self) -> Result<Expr, ParseError> {
        let bound = self.peek_is_bound_keyword();
        match self.peek().map(|t| &t.kind) {
            Some(TokenKind::KwIf) => self.parse_if(),
            Some(TokenKind::KwFn) => self.parse_lam(),
            Some(TokenKind::KwMatch) => self.parse_match(),
            Some(TokenKind::KwHandle) => self.parse_handle(),
            Some(TokenKind::KwGuard) => self.parse_guard(),
            Some(TokenKind::KwReturn) => {
                self.consume(TokenKind::KwReturn)?;
                // `pulang e` — early return; unwinds to the nearest enclosing
                // function-application boundary (see Expr::Return). A bare
                // `pulang;` (no operand) returns Unit.
                let e = if matches!(
                    self.peek().map(|t| &t.kind),
                    Some(TokenKind::Semi) | Some(TokenKind::RBrace) | Some(TokenKind::Eof) | None
                ) {
                    Expr::Unit
                } else {
                    self.parse_pipe()?
                };
                Ok(Expr::Return(Box::new(e)))
            }
            Some(TokenKind::KwFor) => self.parse_for_in(),
            Some(TokenKind::KwWhile) => self.parse_while(),
            Some(TokenKind::KwLoop) => self.parse_loop(),
            // `putus` (break) / `lanjut` (continue) — real loop control over the
            // innermost enclosing `selagi`/`ulang`/`untuk` body. Until 2026-08
            // both desugared to a no-op `()`, so a `putus` in a loop silently did
            // nothing. An optional `'label` is still accepted and ignored (only
            // the innermost loop is targeted); using either outside a loop is a
            // parse error rather than a statement that quietly disappears.
            Some(TokenKind::KwBreak) | Some(TokenKind::KwContinue) => {
                let is_break = matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwBreak));
                let span = self.peek().map(|t| t.span).unwrap_or(self.current_span);
                self.next();
                if matches!(
                    self.peek().map(|t| &t.kind),
                    Some(TokenKind::Lifetime(_)) | Some(TokenKind::Label(_))
                ) {
                    self.next();
                }
                if self.loop_depth == 0 {
                    return Err(ParseError {
                        kind: ParseErrorKind::LoopControlOutsideLoop(if is_break {
                            "putus"
                        } else {
                            "lanjut"
                        }),
                        span,
                    });
                }
                Ok(if is_break { Expr::Break } else { Expr::Continue })
            }
            // CAHAYA Phase J5 block forms. A name bound in scope with the
            // same spelling shadows the form (see `peek_is_bound_keyword`).
            Some(TokenKind::KwDisplay) if !bound => self.parse_display(),
            Some(TokenKind::KwRow) if !bound => self.parse_row(),
            Some(TokenKind::KwColumn) if !bound => self.parse_column(),
            Some(TokenKind::KwStyle) if !bound => self.parse_style_decl(),
            _ => self.parse_pipe(),
        }
    }

    /// Parse for-in loop:
    ///   untuk x dalam iter { body }
    /// Desugars to an indexed while loop. A synthesized closure would capture
    /// `pulang` and return from the iteration instead of the enclosing function.
    fn parse_for_in(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwFor)?;
        // Loop variable: a single name, or a tuple pattern `(a, b, ...)` for
        // destructuring each element.
        let pattern_names: Vec<Ident> =
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
                self.consume(TokenKind::LParen)?;
                let mut names = vec![self.parse_binding_name()?];
                while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                    self.consume(TokenKind::Comma)?;
                    names.push(self.parse_binding_name()?);
                }
                self.consume(TokenKind::RParen)?;
                names
            } else {
                vec![self.parse_binding_name()?]
            };
        self.consume(TokenKind::KwIn)?;
        let iter = self.parse_pipe()?;
        self.consume(TokenKind::LBrace)?;
        // The loop variable shadows any outer `biar ubah` of the same name.
        let scope: Vec<(Ident, bool)> =
            pattern_names.iter().map(|n| (n.clone(), false)).collect();
        let body = self.with_bindings(&scope, Self::parse_loop_body)?;
        self.consume(TokenKind::RBrace)?;
        // Evaluate the iterable once and use source-illegal names for both the
        // temporaries and primitive operations, so user bindings cannot capture
        // the desugaring. Increment before the body so `lanjut` still advances.
        let list = self.fresh_var("forList");
        let index = self.fresh_var("forIndex");
        let elem = self.fresh_var("forElem");
        let bound = if pattern_names.len() == 1 {
            Expr::Let(pattern_names.into_iter().next().unwrap(), None,
                Box::new(Expr::Var(elem.clone())), Box::new(body))
        } else {
            let n = pattern_names.len();
            let mut bound = body;
            for (i, nm) in pattern_names.iter().enumerate().rev() {
                let proj = self.tuple_proj(&elem, i, n);
                bound = Expr::Let(nm.clone(), None, Box::new(proj), Box::new(bound));
            }
            bound
        };
        let condition = Expr::BinOp(BinOp::Lt, Box::new(Expr::SlotGet(index.clone())),
            Box::new(Expr::App(Box::new(Expr::Var("$for_len".into())),
                Box::new(Expr::Var(list.clone())))));
        let next_element = Expr::App(Box::new(Expr::Var("$for_get".into())),
            Box::new(Expr::Pair(Box::new(Expr::Var(list.clone())),
                Box::new(Expr::SlotGet(index.clone())))));
        let advance = Expr::SlotSet(index.clone(), Box::new(Expr::BinOp(BinOp::Add,
            Box::new(Expr::SlotGet(index.clone())), Box::new(Expr::Int(1)))));
        let iteration = Expr::Let(elem, None, Box::new(next_element),
            Box::new(Expr::Let(self.fresh_var("forAdvance"), None,
                Box::new(advance), Box::new(bound))));
        Ok(Expr::Let(list, None, Box::new(iter),
            Box::new(Expr::LetMut(index, Box::new(Expr::Int(0)),
                Box::new(Expr::While(Box::new(condition), Box::new(iteration)))))))
    }

    /// Parse while loop:
    ///   selagi cond { body }
    /// Desugars to: If(cond, Let("_", body, while_again), Unit)
    /// Since we don't have Fix/recursion, we desugar to a bounded
    /// representation the interpreter can handle via recursive eval.
    fn parse_while(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwWhile)?;
        let cond = self.parse_pipe()?;
        self.consume(TokenKind::LBrace)?;
        let body = self.parse_loop_body()?;
        self.consume(TokenKind::RBrace)?;
        Ok(Expr::While(Box::new(cond), Box::new(body)))
    }

    /// Parse a loop body, with `putus`/`lanjut` enabled for its extent.
    fn parse_loop_body(&mut self) -> Result<Expr, ParseError> {
        self.loop_depth += 1;
        let body = self.parse_expr();
        self.loop_depth -= 1;
        body
    }

    /// Parse infinite loop:
    ///   ulang { body }
    /// Desugars to: selagi betul { body }
    fn parse_loop(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwLoop)?;
        self.consume(TokenKind::LBrace)?;
        let body = self.parse_loop_body()?;
        self.consume(TokenKind::RBrace)?;
        // `ulang { body }` is `selagi betul { body }` — an unbounded loop that
        // only `putus` or `pulang` leaves.
        Ok(Expr::While(
            Box::new(Expr::Bool(true)),
            Box::new(body),
        ))
    }

    /// Parse guard clause:
    ///   'pastikan'|'guard' expr 'lain'|'else' '{' expr '}' ';' expr
    /// Desugars to If(cond, continuation, else_body)
    ///
    /// Reached only when a guard appears outside statement position; a
    /// statement-position guard is folded by `parse_stmt_frames` instead.
    fn parse_guard(&mut self) -> Result<Expr, ParseError> {
        let (cond, otherwise) = self.parse_guard_head()?;
        let continuation = match otherwise {
            GuardElse::Block(_) => self.parse_stmt_sequence()?,
            GuardElse::Fail if self.at_sequence_end() => Expr::Unit,
            GuardElse::Fail => self.parse_stmt_sequence()?,
        };
        Ok(Expr::If(
            Box::new(cond),
            Box::new(continuation),
            Box::new(otherwise.into_expr()),
        ))
    }

    /// The part of a guard clause before its continuation: the condition and
    /// what runs when it fails.
    ///
    /// Two surface forms:
    ///   1. `pastikan cond lain { else_body }; rest`  (Swift-style guard)
    ///   2. `pastikan cond ["message"]; rest`         (assertion guard)
    ///
    /// Both desugar to `kalau cond { rest } lain { else }`: execution proceeds
    /// to `rest` when the condition holds. Form 2 fails execution on a false
    /// condition rather than returning a Unit from an arbitrarily typed function.
    fn parse_guard_head(&mut self) -> Result<(Expr, GuardElse), ParseError> {
        self.consume(TokenKind::KwGuard)?;
        let cond = self.parse_pipe()?;
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwElse)) {
            self.consume(TokenKind::KwElse)?;
            self.consume(TokenKind::LBrace)?;
            let else_body = self.parse_expr()?;
            self.consume(TokenKind::RBrace)?;
            self.consume(TokenKind::Semi)?;
            return Ok((cond, GuardElse::Block(else_body)));
        }
        // Assertion form: optional trailing message expression, then `;`.
        if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Semi)) {
            let _msg = self.parse_pipe()?; // message (informational; discarded)
        }
        self.consume(TokenKind::Semi)?;
        Ok((cond, GuardElse::Fail))
    }

    /// Parse pipe expressions: expr (|> expr)*
    /// a |> f |> g  desugars to  App(g, App(f, a))
    fn parse_pipe(&mut self) -> Result<Expr, ParseError> {
        let mut expr = self.parse_assignment()?;
        // Range expression `a..b` (exclusive) / `a..=b` (inclusive), desugared to
        // the `julat`/`julat_inklusif` builtin producing the list [a, a+1, ...].
        // Used mainly as the iterable in `untuk i dalam 0..n { ... }`.
        if matches!(
            self.peek().map(|t| &t.kind),
            Some(TokenKind::DotDot) | Some(TokenKind::DotDotEq)
        ) {
            let inclusive = matches!(self.peek().map(|t| &t.kind), Some(TokenKind::DotDotEq));
            self.next();
            let end = self.parse_assignment()?;
            let builtin = if inclusive { "julat_inklusif" } else { "julat" };
            return Ok(Expr::App(
                Box::new(Expr::Var(builtin.to_string())),
                Box::new(Expr::Pair(Box::new(expr), Box::new(end))),
            ));
        }
        let mut links = 0usize;
        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Pipe)) {
            self.check_chain_len(links)?;
            links += 1;
            self.consume(TokenKind::Pipe)?;
            // The pipe target is a single expression. A lambda (`x |> fungsi(y)
            // { .. }`) is parsed directly so it works as a target, but the target
            // must NOT consume further `|>` operators — pipe is left-associative
            // (`x |> f |> g` is `g(f(x))`) — so we use `parse_assignment` for the
            // general case (not `parse_control_flow`, which would recurse here).
            let func = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwFn)) {
                self.parse_lam()?
            } else {
                self.parse_assignment()?
            };
            expr = Expr::App(Box::new(func), Box::new(expr));
        }
        Ok(expr)
    }

    fn parse_assignment(&mut self) -> Result<Expr, ParseError> {
        let lhs = self.parse_or()?;
        if let Some(TokenKind::ColonEq) = self.peek().map(|t| &t.kind) {
            self.consume(TokenKind::ColonEq)?;
            // The right-hand side is ONE expression, not the rest of the block.
            //
            // This used to call `parse_expr`, which parses a whole statement
            // sequence — so `r := 100; cetakln(!r);` was read as
            // `r := (100; cetakln(!r))`, quietly swallowing every following
            // statement into the assigned value. It surfaced only as a type
            // error on the assignment (`expected Int, found Unit`), or not at
            // all when the sequence happened to end in the right type, and it
            // made `:=` unusable in statement position — the corpus's own
            // `all_examples.rii` `contoh_ruj` did not type-check because of it.
            //
            // `parse_control_flow` is the same level `biar x = <here>;` uses:
            // it takes a full expression including `kalau`/`padan` forms, and
            // stops at the `;`, leaving `parse_stmt_sequence` to sequence what
            // follows.
            let rhs = self.parse_control_flow()?;
            Ok(Expr::Assign(Box::new(lhs), Box::new(rhs)))
        } else {
            Ok(lhs)
        }
    }

    fn parse_or(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_and()?;
        let mut links = 0usize;
        while let Some(TokenKind::OrOr) = self.peek().map(|t| &t.kind) {
            self.check_chain_len(links)?;
            links += 1;
            self.next();
            let right = self.parse_and()?;
            left = Expr::BinOp(BinOp::Or, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_and(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_equality()?;
        let mut links = 0usize;
        while let Some(TokenKind::AndAnd) = self.peek().map(|t| &t.kind) {
            self.check_chain_len(links)?;
            links += 1;
            self.next();
            let right = self.parse_equality()?;
            left = Expr::BinOp(BinOp::And, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_equality(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_comparison()?;
        // Iterative over the chain (`a + b + …` builds a left-nested BinOp
        // per operand); the cap stops the TREE growing past MAX_AST_DEPTH.
        let mut links = 0usize;
        loop {
            self.check_chain_len(links)?;
            links += 1;
            let op = match self.peek().map(|t| &t.kind) {
                Some(TokenKind::EqEq) => BinOp::Eq,
                Some(TokenKind::Ne) => BinOp::Ne,
                _ => break,
            };
            self.next();
            let right = self.parse_comparison()?;
            left = Expr::BinOp(op, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_comparison(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_additive()?;
        // Iterative over the chain (`a + b + …` builds a left-nested BinOp
        // per operand); the cap stops the TREE growing past MAX_AST_DEPTH.
        let mut links = 0usize;
        loop {
            self.check_chain_len(links)?;
            links += 1;
            let op = match self.peek().map(|t| &t.kind) {
                Some(TokenKind::Lt) => BinOp::Lt,
                Some(TokenKind::Gt) => BinOp::Gt,
                Some(TokenKind::Le) => BinOp::Le,
                Some(TokenKind::Ge) => BinOp::Ge,
                _ => break,
            };
            self.next();
            let right = self.parse_additive()?;
            left = Expr::BinOp(op, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_additive(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_multiplicative()?;
        // Iterative over the chain (`a + b + …` builds a left-nested BinOp
        // per operand); the cap stops the TREE growing past MAX_AST_DEPTH.
        let mut links = 0usize;
        loop {
            self.check_chain_len(links)?;
            links += 1;
            let op = match self.peek().map(|t| &t.kind) {
                Some(TokenKind::Plus) => BinOp::Add,
                Some(TokenKind::Minus) => BinOp::Sub,
                _ => break,
            };
            self.next();
            let right = self.parse_multiplicative()?;
            left = Expr::BinOp(op, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_multiplicative(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_app()?;
        // Iterative over the chain (`a + b + …` builds a left-nested BinOp
        // per operand); the cap stops the TREE growing past MAX_AST_DEPTH.
        let mut links = 0usize;
        loop {
            self.check_chain_len(links)?;
            links += 1;
            let op = match self.peek().map(|t| &t.kind) {
                Some(TokenKind::Star) => BinOp::Mul,
                Some(TokenKind::Slash) => BinOp::Div,
                Some(TokenKind::Percent) => BinOp::Mod,
                _ => break,
            };
            self.next();
            let right = self.parse_app()?;
            left = Expr::BinOp(op, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_app(&mut self) -> Result<Expr, ParseError> {
        let mut expr = self.parse_unary()?;
        let mut links = 0usize;
        // Postfix accessors, chained left-to-right:
        //   `e.field`      -> structural FieldAccess
        //   `e.0` / `e.1`  -> Fst / Snd (pairs)
        //   `e[i]`         -> list indexing, desugared to `senarai_dapat((e, i))`
        loop {
            self.check_chain_len(links)?;
            links += 1;
            match self.peek().map(|t| &t.kind) {
                Some(TokenKind::Dot) => {
                    self.consume(TokenKind::Dot)?;
                    match self.peek().map(|t| t.kind.clone()) {
                        Some(TokenKind::LiteralInt(ref n, _)) if n == "0" => {
                            self.next();
                            expr = Expr::Fst(Box::new(expr));
                        }
                        Some(TokenKind::LiteralInt(ref n, _)) if n == "1" => {
                            self.next();
                            expr = Expr::Snd(Box::new(expr));
                        }
                        Some(TokenKind::Identifier(name)) => {
                            self.next();
                            // Enum-variant access `Type.Variant`: when the base is
                            // a bare uppercase type name and the field is also
                            // uppercase, this is a nullary enum constructor rather
                            // than a struct field access. There is no nominal enum
                            // system yet, so it desugars to a unique string tag
                            // `"Type.Variant"` — equality comparison then makes it
                            // usable as both a value and a `padan` literal pattern.
                            if let Expr::Var(type_name) = &expr {
                                let base_upper = type_name
                                    .chars()
                                    .next()
                                    .map(|c| c.is_uppercase())
                                    .unwrap_or(false);
                                let variant_upper =
                                    name.chars().next().map(|c| c.is_uppercase()).unwrap_or(false);
                                if base_upper && variant_upper {
                                    expr = Expr::String(format!("{type_name}.{name}"));
                                    continue;
                                }
                            }
                            expr = Expr::FieldAccess(Box::new(expr), name);
                        }
                        // Soft-keyword field name, e.g. `rec.tahap`.
                        Some(ref k) if Self::soft_keyword_spelling(k).is_some() => {
                            let name = Self::soft_keyword_spelling(k).unwrap().to_string();
                            self.next();
                            expr = Expr::FieldAccess(Box::new(expr), name);
                        }
                        _ => {
                            return Err(ParseError {
                                kind: ParseErrorKind::ExpectedIdentifier,
                                span: self.current_span,
                            });
                        }
                    }
                }
                Some(TokenKind::LBracket) => {
                    // Index access `e[i]` -> `senarai_dapat((e, i))`, reusing the
                    // existing list-get builtin (which takes a (list, index) pair).
                    self.consume(TokenKind::LBracket)?;
                    let index = self.parse_pipe()?;
                    self.consume(TokenKind::RBracket)?;
                    expr = Expr::App(
                        Box::new(Expr::Var("senarai_dapat".to_string())),
                        Box::new(Expr::Pair(Box::new(expr), Box::new(index))),
                    );
                }
                // Parenthesized call `e(a, b, ...)` -> App(App(e, a), b)... Treated
                // as a call when the head could be a callee (a name, prior call,
                // field access — i.e. a method `obj.m(..)` — or projection). Kept
                // in this postfix loop so calls and field accesses chain freely,
                // e.g. `m.peta(..).peta(..)` (multi-step method chains).
                Some(TokenKind::LParen)
                    if matches!(
                        &expr,
                        Expr::Var(_)
                            | Expr::App(_, _)
                            | Expr::FieldAccess(_, _)
                            | Expr::Fst(_)
                            | Expr::Snd(_)
                    ) =>
                {
                    self.consume(TokenKind::LParen)?;
                    if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                        let arg = self.parse_control_flow()?;
                        expr = Expr::App(Box::new(expr), Box::new(arg));
                        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                            self.check_chain_len(links)?;
                            links += 1;
                            self.consume(TokenKind::Comma)?;
                            let arg = self.parse_control_flow()?;
                            expr = Expr::App(Box::new(expr), Box::new(arg));
                        }
                    }
                    else {
                        // Empty parens `f()` are a real application to `()`.
                        // A zero-parameter function now has a synthesised `()`
                        // parameter (`build_lambda`), so calling it is an
                        // application like any other. Treating `()` as a no-op
                        // suffix is what made a zero-arg function a global
                        // thunk that ran once, eagerly, whether called or not
                        // (master plan REQ-68).
                        expr = Expr::App(Box::new(expr), Box::new(Expr::Unit));
                    }
                    self.consume(TokenKind::RParen)?;
                }
                _ => break,
            }
        }
        // Juxtaposition application (`f x`). Only a callable head juxtaposes an
        // argument — a Var, a prior application, a field access (method-like), or
        // a projection. This prevents a literal followed by another atom (e.g. the
        // `0 "msg"` in `pastikan x >= 0 "msg"`) from being misread as the literal
        // applied to the next token.
        let head_is_callable = matches!(
            &expr,
            Expr::Var(_) | Expr::App(_, _) | Expr::FieldAccess(_, _) | Expr::Fst(_) | Expr::Snd(_)
        );
        if head_is_callable {
            loop {
                self.check_chain_len(links)?;
                links += 1;
                if self.is_expr_start() {
                    let arg = self.parse_unary()?;
                    expr = Expr::App(Box::new(expr), Box::new(arg));
                } else {
                    break;
                }
            }
        }
        Ok(expr)
    }

    fn is_expr_start(&mut self) -> bool {
        let kind = self.peek().map(|t| &t.kind);
        matches!(
            kind,
            Some(TokenKind::LiteralInt(_, _))
                | Some(TokenKind::LiteralBool(_))
                | Some(TokenKind::LiteralString(_))
                | Some(TokenKind::Identifier(_))
                | Some(TokenKind::LParen)
                | Some(TokenKind::Not)
                | Some(TokenKind::KwRef)
                | Some(TokenKind::KwPerform)
                | Some(TokenKind::KwClassify)
                | Some(TokenKind::KwDeclassify)
                | Some(TokenKind::KwProve)
                | Some(TokenKind::KwInl)
                | Some(TokenKind::KwInr)
                | Some(TokenKind::KwSome)
                | Some(TokenKind::KwNone)
                | Some(TokenKind::KwOk)
                | Some(TokenKind::KwErr)
                | Some(TokenKind::KwSpawn)
                | Some(TokenKind::KwSend)
                | Some(TokenKind::KwRecv)
                | Some(TokenKind::KwMerge)
                | Some(TokenKind::KwContentHash)
                | Some(TokenKind::KwVerify)
                | Some(TokenKind::KwSmartContract)
                | Some(TokenKind::KwToken)
                | Some(TokenKind::KwZakat)
        )
    }

    /// Nesting-guarded entry (see [`MAX_EXPR_DEPTH`]).
    fn parse_unary(&mut self) -> Result<Expr, ParseError> {
        self.nested(Self::parse_unary_inner)
    }

    fn parse_unary_inner(&mut self) -> Result<Expr, ParseError> {
        let kind = self.peek().map(|t| t.kind.clone());
        let bound = self.peek_is_bound_keyword();
        match kind {
            Some(TokenKind::Not) => {
                // `!e` is dereference (ML-style), not logical negation. The
                // operand is parsed at the postfix (`parse_app`) level so a
                // following call/index binds INSIDE the operator â `!f(x)` is
                // `Deref(f(x))`, not `(Deref f)(x)` (which left the `(x)` dangling
                // -> "Unexpected token: LParen").
                self.consume(TokenKind::Not)?;
                let e = self.parse_app()?;
                Ok(Expr::Deref(Box::new(e)))
            }
            Some(TokenKind::KwNot) => {
                // `bukan e` / `not e` is logical negation, desugared to
                // `kalau e { salah } lain { betul }` (reuses If â no new AST node).
                // Operand at `parse_app` level so `bukan f(x)` negates the call
                // result (same prefix-then-call gap as `!` above).
                self.consume(TokenKind::KwNot)?;
                let e = self.parse_app()?;
                Ok(Expr::If(
                    Box::new(e),
                    Box::new(Expr::Bool(false)),
                    Box::new(Expr::Bool(true)),
                ))
            }
            Some(TokenKind::KwRef) => {
                self.consume(TokenKind::KwRef)?;
                let e = self.parse_unary()?;
                self.consume(TokenKind::At)?;
                let level = self.parse_security_level()?;
                Ok(Expr::Ref(Box::new(e), level))
            }
            Some(TokenKind::KwPerform) => {
                self.consume(TokenKind::KwPerform)?;
                let eff = self.parse_effect()?;
                let e = self.parse_control_flow()?;
                Ok(Expr::Perform(eff, Box::new(e)))
            }
            Some(TokenKind::KwClassify) => {
                self.consume(TokenKind::KwClassify)?;
                let e = self.parse_control_flow()?;
                Ok(Expr::Classify(Box::new(e)))
            }
            Some(TokenKind::KwDeclassify) => {
                self.consume(TokenKind::KwDeclassify)?;
                // Two surface forms, ONE AST node (identical `Expr::Declassify`,
                // so the mechanized `T_Declassify`/`declass_ok` rule covers both
                // and no new semantics exists):
                //   canonical:  `dedah e dengan bukti p`
                //   call-form:  `dedah(e, p)` — used across the example corpus
                //               (REQ-55; 15 files were unparseable without it).
                // The streaming lexer has no backtracking, so the forms are
                // disambiguated AFTER parsing the operand: `(e, p)` parses as a
                // Pair, and a Pair operand with no following `dengan` IS the
                // call-form. A parenthesized canonical operand —
                // `dedah (sulit x) dengan p` — is unaffected because `dengan`
                // follows (this exact shape regressed under a lookahead-only
                // first attempt; see the corpus test on 00_basics/sulit_dedah).
                let e1 = self.parse_control_flow()?;
                if matches!(self.peek().map(|t| t.kind.clone()), Some(TokenKind::KwWith)) {
                    self.consume(TokenKind::KwWith)?;
                    let e2 = self.parse_control_flow()?;
                    return Ok(Expr::Declassify(Box::new(e1), Box::new(e2)));
                }
                if let Expr::Pair(a, b) = e1 {
                    return Ok(Expr::Declassify(a, b));
                }
                // Neither form: produce the canonical missing-`dengan` error.
                self.consume(TokenKind::KwWith)?;
                unreachable!("consume(KwWith) above always errors here")
            }
            Some(TokenKind::KwProve) => {
                self.consume(TokenKind::KwProve)?;
                let e = self.parse_control_flow()?;
                Ok(Expr::Prove(Box::new(e)))
            }
            Some(TokenKind::KwFst) => {
                self.consume(TokenKind::KwFst)?;
                let e = self.parse_unary()?;
                Ok(Expr::Fst(Box::new(e)))
            }
            Some(TokenKind::KwSnd) => {
                self.consume(TokenKind::KwSnd)?;
                let e = self.parse_unary()?;
                Ok(Expr::Snd(Box::new(e)))
            }
            Some(TokenKind::KwRequire) => {
                self.consume(TokenKind::KwRequire)?;
                let eff = self.parse_effect()?;
                let e = self.parse_control_flow()?;
                Ok(Expr::Require(eff, Box::new(e)))
            }
            Some(TokenKind::KwGrant) => {
                self.consume(TokenKind::KwGrant)?;
                let eff = self.parse_effect()?;
                let e = self.parse_control_flow()?;
                Ok(Expr::Grant(eff, Box::new(e)))
            }
            Some(TokenKind::KwInl) => {
                self.consume(TokenKind::KwInl)?;
                let e = self.parse_unary()?;
                self.consume(TokenKind::Colon)?;
                let ty = self.parse_ty()?;
                Ok(Expr::Inl(Box::new(e), ty))
            }
            Some(TokenKind::KwInr) => {
                self.consume(TokenKind::KwInr)?;
                let e = self.parse_unary()?;
                self.consume(TokenKind::Colon)?;
                let ty = self.parse_ty()?;
                Ok(Expr::Inr(Box::new(e), ty))
            }
            // Option/Result constructors desugar onto the existing sum type:
            //   Some(x)/Ada(x)  -> Inl x      None/Tiada      -> Inr unit
            //   Ok(x)/Jadi(x)   -> Inl x      Err(x)/Gagal(x) -> Inr x
            // The carried type is `Any` (structural; Option and Result are not
            // yet distinguished nominally by the typechecker).
            Some(TokenKind::KwSome) | Some(TokenKind::KwOk) => {
                self.next();
                let inner = self.parse_constructor_arg()?;
                Ok(Expr::Inl(Box::new(inner), Ty::Any))
            }
            Some(TokenKind::KwErr) => {
                self.next();
                let inner = self.parse_constructor_arg()?;
                Ok(Expr::Inr(Box::new(inner), Ty::Any))
            }
            Some(TokenKind::KwNone) => {
                self.next();
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
                    self.consume(TokenKind::LParen)?;
                    self.consume(TokenKind::RParen)?;
                }
                Ok(Expr::Inr(Box::new(Expr::Unit), Ty::Any))
            }
            Some(TokenKind::KwSpawn) => self.parse_spawn(),
            Some(TokenKind::KwSend) => self.parse_actor_send(),
            Some(TokenKind::KwRecv) => self.parse_actor_recv(),
            Some(TokenKind::KwMerge) if !bound => self.parse_crdt_merge(),
            Some(TokenKind::KwContentHash) => self.parse_content_hash(),
            Some(TokenKind::KwVerify) => self.parse_content_verify(),
            Some(TokenKind::KwSmartContract) => self.parse_contract_deploy(),
            Some(TokenKind::KwToken) if !bound => self.parse_token_transfer(),
            Some(TokenKind::KwZakat) => self.parse_zakat_calculate(),
            // CAHAYA Phase J5 prefix forms
            Some(TokenKind::KwText_) if !bound => self.parse_ui_text(),
            Some(TokenKind::KwButton) => self.parse_ui_button(),
            Some(TokenKind::KwColor) if !bound => self.parse_ui_color(),
            Some(TokenKind::KwContrast) => self.parse_ui_contrast(),
            _ => self.parse_atom(),
        }
    }

    fn parse_atom(&mut self) -> Result<Expr, ParseError> {
        let kind = self.peek().map(|t| t.kind.clone());
        match kind {
            // Anonymous (braced) record literal: `{ field: e, ... }` with no
            // type name (e.g. `pulang { hos: "localhost", port: 8080 }`). Records
            // are structural, so the type name is empty. Disambiguated from a
            // block via `looks_like_record_literal` (next-next token is `ident :`,
            // or `}` for the empty record).
            Some(TokenKind::LBrace) if self.looks_like_record_literal() => {
                self.parse_record_literal_body(String::new())
            }
            Some(TokenKind::LiteralInt(s, suffix)) => {
                self.next();
                let span = self.current_span;
                // When a width suffix is present the lexer guarantees a decimal
                // magnitude and has already range-checked it, so a sized literal
                // becomes `Expr::IntN`; otherwise it stays the default
                // `Expr::Int` (`Ty::Int`).
                let value = int_literal_value(&s).map_err(|kind| ParseError { kind, span })?;
                match suffix.as_deref().and_then(int_suffix_to_width) {
                    Some((bits, signed)) => Ok(Expr::IntN {
                        value,
                        bits,
                        signed,
                    }),
                    None => Ok(Expr::Int(value)),
                }
            }
            Some(TokenKind::LiteralBool(b)) => {
                self.next();
                Ok(Expr::Bool(b))
            }
            Some(TokenKind::LiteralString(s)) => {
                self.next();
                Ok(Expr::String(s))
            }
            Some(TokenKind::Identifier(s)) => {
                self.next();
                // `format!("tmpl", args...)` macro — Rust-style string formatting
                // used across the example corpus. Desugar to string concatenation
                // of the template's literal segments interleaved with the
                // stringified arguments (`ke_teks`).
                if s == "format" && matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Not)) {
                    return self.parse_format_macro();
                }
                // Qualified module path `Module::function` (e.g. `teks::mengandungi`,
                // `Masa::masa_unix`). Resolve to the flat builtin name so the
                // existing Var/builtin machinery handles it.
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::ColonColon)) {
                    let resolved = self.parse_module_path(s)?;
                    return Ok(Expr::Var(resolved));
                }
                // Record literal `Name { field: e, ... }`. Only treated as a
                // record when the brace is immediately followed by `ident :`,
                // so it cannot be confused with a control-flow block (those are
                // parsed by their own keywords, never reaching here).
                if self.looks_like_record_literal() {
                    return self.parse_record_literal_body(s);
                }
                // Named (nominal-enum) constructor. An uppercase identifier is a
                // data constructor: `C(args)` builds the structural tagged value
                // `Pair("C", payload)` (payload = the single arg, a tuple of args,
                // or Unit), and a bare uppercase `C` builds the tag string "C".
                // Lowercase identifiers remain variables/functions. `Titik {..}`
                // record literals are handled above; `T::m` paths and `T.V`
                // variants are handled elsewhere.
                let is_ctor = s.chars().next().map(|c| c.is_uppercase()).unwrap_or(false);
                if is_ctor && matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
                    self.consume(TokenKind::LParen)?;
                    let mut args = Vec::new();
                    if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                        args.push(self.parse_control_flow()?);
                        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                            self.check_chain_len(args.len())?;
                            self.consume(TokenKind::Comma)?;
                            args.push(self.parse_control_flow()?);
                        }
                    }
                    self.consume(TokenKind::RParen)?;
                    // payload: Unit for nullary, the arg for one, a right-nested
                    // tuple for many (matching tuple construction / projection).
                    let payload = match args.len() {
                        0 => Expr::Unit,
                        1 => args.pop().unwrap(),
                        _ => {
                            let mut it = args.into_iter().rev();
                            let mut acc = it.next().unwrap();
                            for x in it {
                                acc = Expr::Pair(Box::new(x), Box::new(acc));
                            }
                            acc
                        }
                    };
                    return Ok(Expr::Pair(
                        Box::new(Expr::String(s)),
                        Box::new(payload),
                    ));
                }
                // Bare uppercase identifier = nullary nominal-enum constructor,
                // built as the tag string "C" (matches the nullary `NamedCtor`
                // pattern). Excludes a following `.` — that is a `Type.Variant`
                // access handled in parse_app. Lowercase identifiers stay
                // variables.
                if is_ctor && !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Dot)) {
                    return Ok(Expr::String(s));
                }
                Ok(self.name_ref(s))
            }
            // List literal `[e1, e2, ...]`. A trailing comma is allowed; `[]` is
            // the empty list.
            Some(TokenKind::LBracket) => {
                self.next();
                let mut elems = Vec::new();
                while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBracket) | None) {
                    elems.push(self.parse_control_flow()?);
                    if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                        self.consume(TokenKind::Comma)?;
                    } else {
                        break;
                    }
                }
                self.consume(TokenKind::RBracket)?;
                Ok(Expr::ListLit(elems))
            }
            // KwExpect (jangkakan/expect) is both a keyword and a builtin function.
            // When used as an expression, treat it as Var("jangkakan").
            Some(TokenKind::KwExpect) => {
                self.next();
                Ok(Expr::Var("jangkakan".to_string()))
            }
            Some(TokenKind::LParen) => {
                self.next();
                let is_unit = if let Some(token) = self.peek() {
                    token.kind == TokenKind::RParen
                } else {
                    false
                };

                if is_unit {
                    self.next();
                    Ok(Expr::Unit)
                } else {
                    let e = self.parse_expr()?;

                    if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                        // Tuple. Collect all elements, then build a right-nested
                        // pair chain `(a, (b, (c, ...)))` so n-tuples (n >= 2) are
                        // supported uniformly (matching `tuple_proj`/Fst-Snd access
                        // and destructuring).
                        let mut elems = vec![e];
                        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                            self.check_chain_len(elems.len())?;
                            self.consume(TokenKind::Comma)?;
                            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                                break; // trailing comma
                            }
                            elems.push(self.parse_expr()?);
                        }
                        self.consume(TokenKind::RParen)?;
                        let mut iter = elems.into_iter().rev();
                        let mut acc = iter.next().unwrap();
                        for x in iter {
                            acc = Expr::Pair(Box::new(x), Box::new(acc));
                        }
                        Ok(acc)
                    } else {
                        self.consume(TokenKind::RParen)?;
                        Ok(e)
                    }
                }
            }
            // A "soft" keyword in value position (where an atom is expected) is a
            // variable reference — the corpus uses words like `tahap`, `keadaan`,
            // `jenis` as ordinary names. Treat it as `Var(canonical spelling)`.
            Some(ref k) if Self::soft_keyword_spelling(k).is_some() => {
                let name = Self::soft_keyword_spelling(k).unwrap().to_string();
                self.next();
                Ok(self.name_ref(name))
            }
            // A float literal: a dedicated error at the literal's own span.
            Some(TokenKind::LiteralFloat(lit, _)) => {
                let fallback = self.current_span;
                let span = self.peek().map_or(fallback, |t| t.span);
                Err(ParseError {
                    kind: ParseErrorKind::FloatLiteral(lit),
                    span,
                })
            }
            Some(kind) => Err(ParseError {
                kind: ParseErrorKind::UnexpectedToken(kind),
                span: self.current_span,
            }),
            None => Err(self.end_of_tokens_error()),
        }
    }

    // parse_let logic is now inlined in parse_stmt_sequence

    /// Parse `kalau c { .. } [lain kalau c { .. }]* [lain { .. }]`.
    ///
    /// The `lain kalau` links are collected in a LOOP and folded into the
    /// nested `If` chain afterwards (each link's else branch is the next
    /// link). Parsing each link by recursing into `parse_if` — as until
    /// 2026-10 — overflowed the stack on a few thousand links.
    fn parse_if(&mut self) -> Result<Expr, ParseError> {
        let mut links: Vec<(Expr, Expr)> = Vec::new();
        loop {
            self.check_chain_len(links.len())?;
            match self.parse_if_link()? {
                IfLink::ElseIf { cond, then_branch } => links.push((cond, then_branch)),
                IfLink::Last(innermost) => {
                    let mut acc = innermost;
                    for (cond, then_branch) in links.into_iter().rev() {
                        acc = Expr::If(Box::new(cond), Box::new(then_branch), Box::new(acc));
                    }
                    return Ok(acc);
                }
            }
        }
    }

    /// One `kalau c { .. }` link of an `if` chain, with its `lain` tail if the
    /// tail is not another `kalau`.
    fn parse_if_link(&mut self) -> Result<IfLink, ParseError> {
        self.consume(TokenKind::KwIf)?;
        let cond = self.parse_expr()?;
        self.consume(TokenKind::LBrace)?;
        let then_branch = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;

        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwElse)) {
            self.consume(TokenKind::KwElse)?;
            // `lain kalau ...` (else-if): the else branch is itself an `if` —
            // the next link, parsed by the caller's loop.
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwIf)) {
                return Ok(IfLink::ElseIf { cond, then_branch });
            }
            self.consume(TokenKind::LBrace)?;
            let else_branch = self.parse_expr()?;
            self.consume(TokenKind::RBrace)?;
            Ok(IfLink::Last(Expr::If(
                Box::new(cond),
                Box::new(then_branch),
                Box::new(else_branch),
            )))
        } else {
            // `kalau cond { ... }` with no `lain`: used as a statement (e.g. an
            // early-return guard `kalau c { pulang x; }`). Both branches must
            // agree in type, so the then-branch's value is discarded (sequenced
            // to Unit) and the implicit else is Unit. The construct yields Unit.
            let then_unit = Expr::Let(
                "_".to_string(),
                None,
                Box::new(then_branch),
                Box::new(Expr::Unit),
            );
            Ok(IfLink::Last(Expr::If(
                Box::new(cond),
                Box::new(then_unit),
                Box::new(Expr::Unit),
            )))
        }
    }

    fn parse_lam(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwFn)?;
        self.consume(TokenKind::LParen)?;
        // Parameter list: zero or more `name: Type`, comma-separated. Multiple
        // params curry into nested `Lam`s.
        let params = self.parse_param_list()?;
        self.consume(TokenKind::RParen)?;
        // Optional return-type annotation `-> T`: the body is checked against
        // it (`Expr::Ascribe`), and so is every `pulang` in it.
        let ret = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Arrow)) {
            self.consume(TokenKind::Arrow)?;
            Some(self.parse_ty()?)
        } else {
            None
        };
        // Body: a `{ ... }` block or a bare control-flow expression. As for a
        // named function, parameters shadow an outer `biar ubah` of the same name.
        let scope: Vec<(Ident, bool)> = params.iter().map(|(n, _)| (n.clone(), false)).collect();
        // A closure cannot break or continue a loop in its caller.
        let outer_loop_depth = self.loop_depth;
        self.loop_depth = 0;
        let body = self.with_bindings(&scope, |p| {
            if matches!(p.peek().map(|t| &t.kind), Some(TokenKind::LBrace)) {
                p.consume(TokenKind::LBrace)?;
                let b = p.parse_stmt_sequence()?;
                p.consume(TokenKind::RBrace)?;
                Ok(b)
            } else {
                p.parse_control_flow()
            }
        });
        self.loop_depth = outer_loop_depth;
        let body = ascribe(body?, ret);
        // Curry parameters into nested lambdas (right-fold). A no-parameter
        // `fungsi()` becomes a single Unit-typed parameter (a thunk).
        if params.is_empty() {
            Ok(Expr::Lam("_".to_string(), Ty::Unit, Box::new(body)))
        } else {
            Ok(params
                .into_iter()
                .rev()
                .fold(body, |acc, (p, ty)| Expr::Lam(p, ty, Box::new(acc))))
        }
    }

    /// Parse a `padan` (match) expression and compile it to the core calculus.
    ///
    /// RIINA's AST has no dedicated match/pattern node; `padan` is sugar that
    /// this function compiles down to the verified core constructs:
    ///   - `Case` (sum elimination) for Option/Result-style constructor patterns
    ///     (`Ada(x)`/`Tidak`, `Ok(x)`/`Ralat(e)`, `inl x`/`inr y`);
    ///   - nested `If` + structural `==` for literal / bool / string patterns;
    ///   - `Fst`/`Snd` projection for tuple patterns;
    ///   - variable / `_` patterns as binding catch-alls;
    ///   - `kalau <cond>` guards on any arm.
    ///
    /// Arm syntax accepts both `->` (Arrow, the surface syntax used across the
    /// example corpus) and `=>` (FatArrow, legacy). Arm bodies may be a bare
    /// expression or a `{ ... }` block.
    fn parse_match(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwMatch)?;
        let scrutinee = self.parse_pipe()?;
        self.consume(TokenKind::LBrace)?;

        let mut arms: Vec<MatchArm> = Vec::new();
        while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace) | None) {
            // Arms compile to a nested `If` chain, one level per arm.
            self.check_chain_len(arms.len())?;
            let pattern = self.parse_pattern()?;
            // Optional guard: `kalau <cond>`.
            let guard = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwIf)) {
                self.consume(TokenKind::KwIf)?;
                Some(self.parse_pipe()?)
            } else {
                None
            };
            self.consume_arm_arrow()?;
            let body = self.parse_arm_body()?;
            arms.push(MatchArm { pattern, guard, body });
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                self.next();
            }
        }
        self.consume(TokenKind::RBrace)?;

        self.compile_match(scrutinee, arms)
    }

    /// Consume the arrow separating a match pattern from its body. Accepts both
    /// `->` (surface syntax) and `=>` (legacy) for compatibility.
    fn consume_arm_arrow(&mut self) -> Result<(), ParseError> {
        match self.peek().map(|t| &t.kind) {
            Some(TokenKind::Arrow) => {
                self.consume(TokenKind::Arrow)?;
                Ok(())
            }
            Some(TokenKind::FatArrow) => {
                self.consume(TokenKind::FatArrow)?;
                Ok(())
            }
            _ => self.consume(TokenKind::Arrow).map(|_| ()),
        }
    }

    /// Parse a match arm body: either a `{ ... }` block (statement sequence) or
    /// a bare expression.
    fn parse_arm_body(&mut self) -> Result<Expr, ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LBrace)) {
            self.consume(TokenKind::LBrace)?;
            let body = self.parse_stmt_sequence()?;
            self.consume(TokenKind::RBrace)?;
            Ok(body)
        } else {
            // Use parse_control_flow (not parse_pipe) so a bare arm body may be a
            // control-flow expression — e.g. `0 -> pulang 99` or `_ -> kalau ...`.
            // The `pulang`/`kalau` operand parsers stop at the arm-separating `,`.
            self.parse_control_flow()
        }
    }

    /// Parse a single match pattern.
    /// Nesting-guarded entry (see [`MAX_EXPR_DEPTH`]).
    fn parse_pattern(&mut self) -> Result<Pattern, ParseError> {
        self.nested(Self::parse_pattern_inner)
    }

    fn parse_pattern_inner(&mut self) -> Result<Pattern, ParseError> {
        match self.peek().map(|t| t.kind.clone()) {
            // Tuple pattern `(p1, p2, ...)` (or `()` for unit).
            Some(TokenKind::LParen) => {
                self.consume(TokenKind::LParen)?;
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                    self.consume(TokenKind::RParen)?;
                    return Ok(Pattern::Tuple(Vec::new()));
                }
                let mut elems = vec![self.parse_pattern()?];
                while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                    self.consume(TokenKind::Comma)?;
                    elems.push(self.parse_pattern()?);
                }
                self.consume(TokenKind::RParen)?;
                if elems.len() == 1 {
                    Ok(elems.pop().unwrap())
                } else {
                    Ok(Pattern::Tuple(elems))
                }
            }
            // List pattern: `[]`, `[p0, p1, ...]`, or `[p0, ..rest]` (the rest
            // binding `..name` captures the remaining elements as a list and must
            // be last).
            Some(TokenKind::LBracket) => {
                self.consume(TokenKind::LBracket)?;
                let mut elems = Vec::new();
                let mut tail = None;
                while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBracket) | None) {
                    if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::DotDot)) {
                        // `..rest` rest-binding (or bare `..` to ignore the rest).
                        self.consume(TokenKind::DotDot)?;
                        if let Some(TokenKind::Identifier(_)) = self.peek().map(|t| &t.kind) {
                            tail = Some(self.parse_ident()?);
                        } else {
                            tail = Some("_".to_string());
                        }
                        break;
                    }
                    elems.push(self.parse_pattern()?);
                    if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                        self.consume(TokenKind::Comma)?;
                    } else {
                        break;
                    }
                }
                self.consume(TokenKind::RBracket)?;
                Ok(Pattern::List { elems, tail })
            }
            // Sum constructors that are keywords: Some/Ada, Ok/Jadi -> left;
            // None/Tiada, Err/Gagal -> right.
            Some(TokenKind::KwSome) | Some(TokenKind::KwOk) => {
                self.next();
                let inner = self.parse_ctor_payload()?;
                Ok(Pattern::CtorLeft(inner))
            }
            Some(TokenKind::KwErr) => {
                self.next();
                let inner = self.parse_ctor_payload()?;
                Ok(Pattern::CtorRight(inner))
            }
            Some(TokenKind::KwNone) => {
                self.next();
                // `Tiada`/`None` may appear bare or as `Tiada()`.
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
                    self.consume(TokenKind::LParen)?;
                    self.consume(TokenKind::RParen)?;
                }
                Ok(Pattern::CtorRight(Box::new(Pattern::Wildcard)))
            }
            Some(TokenKind::KwInl) => {
                self.next();
                let name = self.parse_ident()?;
                Ok(Pattern::CtorLeft(Box::new(Pattern::Var(name))))
            }
            Some(TokenKind::KwInr) => {
                self.next();
                let name = self.parse_ident()?;
                Ok(Pattern::CtorRight(Box::new(Pattern::Var(name))))
            }
            // Reference pattern `ruj(p)`: matches a reference, binding/testing the
            // inner pattern against the dereferenced value.
            Some(TokenKind::KwRef) => {
                self.next();
                let inner = self.parse_ctor_payload()?;
                Ok(Pattern::Ref(inner))
            }
            // Literal patterns.
            Some(TokenKind::LiteralInt(s, _)) => {
                self.next();
                let span = self.current_span;
                let value = int_literal_value(&s).map_err(|kind| ParseError { kind, span })?;
                Ok(Pattern::Int(value))
            }
            Some(TokenKind::LiteralBool(b)) => {
                self.next();
                Ok(Pattern::Bool(b))
            }
            Some(TokenKind::LiteralString(s)) => {
                self.next();
                Ok(Pattern::Str(s))
            }
            // Identifier: `_` is wildcard; an uppercase identifier followed by
            // `(...)` is an enum constructor (treated as a right-injection payload
            // binding so `Ralat(e)`/`Berjaya(v)` bind their argument); otherwise a
            // variable binding.
            Some(TokenKind::Identifier(s)) => {
                self.next();
                if s == "_" {
                    return Ok(Pattern::Wildcard);
                }
                let is_ctor = s.chars().next().map(|c| c.is_uppercase()).unwrap_or(false);
                // Enum-variant pattern `Type.Variant` — matches the string tag
                // that value-position `Type.Variant` desugars to (see parse_app).
                if is_ctor && matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Dot)) {
                    let mut ahead = self.lexer.clone();
                    ahead.next(); // `.`
                    if let Some(TokenKind::Identifier(v)) = ahead.next().map(|t| t.kind) {
                        if v.chars().next().map(|c| c.is_uppercase()).unwrap_or(false) {
                            self.consume(TokenKind::Dot)?;
                            self.parse_ident()?; // consume variant
                            return Ok(Pattern::Str(format!("{s}.{v}")));
                        }
                    }
                }
                if is_ctor && matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
                    // Named (nominal-enum) constructor with arguments, e.g.
                    // `Bulatan(r)` or `Segi(p, l)`. Matches the structural tag
                    // `("Bulatan", payload)` (see parse_atom construction).
                    self.consume(TokenKind::LParen)?;
                    let mut args = vec![self.parse_pattern()?];
                    while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                        self.consume(TokenKind::Comma)?;
                        args.push(self.parse_pattern()?);
                    }
                    self.consume(TokenKind::RParen)?;
                    Ok(Pattern::NamedCtor { name: s, args })
                } else if is_ctor {
                    // Nullary constructor used as a tag (e.g. `Tertutup`): matches
                    // the bare tag string "Tertutup".
                    Ok(Pattern::NamedCtor {
                        name: s,
                        args: Vec::new(),
                    })
                } else {
                    Ok(Pattern::Var(s))
                }
            }
            _ => Err(ParseError {
                kind: ParseErrorKind::ExpectedIdentifier,
                span: self.current_span,
            }),
        }
    }

    /// Parse a constructor's parenthesized payload pattern: `(p)`. A bare
    /// constructor with no parentheses binds nothing (wildcard payload).
    fn parse_ctor_payload(&mut self) -> Result<Box<Pattern>, ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
            self.consume(TokenKind::LParen)?;
            // Multi-arg constructors `C(a, b, ...)`: bind as a tuple pattern.
            let mut elems = vec![self.parse_pattern()?];
            while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                self.consume(TokenKind::Comma)?;
                elems.push(self.parse_pattern()?);
            }
            self.consume(TokenKind::RParen)?;
            if elems.len() == 1 {
                Ok(Box::new(elems.pop().unwrap()))
            } else {
                Ok(Box::new(Pattern::Tuple(elems)))
            }
        } else {
            Ok(Box::new(Pattern::Wildcard))
        }
    }

    /// Compile parsed match arms to core `Expr`. Constructor patterns
    /// (`CtorLeft`/`CtorRight`) compile to a `Case` over the sum; all other
    /// patterns compile to a nested `If` chain over structural tests. A `padan`
    /// that mixes both forms falls back to the `If`-chain compiler using the
    /// scrutinee directly.
    fn compile_match(
        &mut self,
        scrutinee: Expr,
        arms: Vec<MatchArm>,
    ) -> Result<Expr, ParseError> {
        let has_ctor = arms
            .iter()
            .any(|a| matches!(a.pattern, Pattern::CtorLeft(_) | Pattern::CtorRight(_)));
        let all_ctor_or_default = arms.iter().all(|a| {
            matches!(
                a.pattern,
                Pattern::CtorLeft(_) | Pattern::CtorRight(_) | Pattern::Wildcard | Pattern::Var(_)
            ) && a.guard.is_none()
        });

        if has_ctor && all_ctor_or_default {
            return self.compile_sum_match(scrutinee, arms);
        }
        self.compile_if_chain(scrutinee, arms)
    }

    /// Compile a constructor-style `padan` to a `Case` (sum elimination).
    /// Collects the first left arm and first right arm; a trailing
    /// wildcard/variable arm fills whichever side is absent.
    fn compile_sum_match(
        &mut self,
        scrutinee: Expr,
        arms: Vec<MatchArm>,
    ) -> Result<Expr, ParseError> {
        let mut left: Option<(Box<Pattern>, Expr)> = None;
        let mut right: Option<(Box<Pattern>, Expr)> = None;
        let mut default: Option<Expr> = None;

        for arm in arms {
            match arm.pattern {
                Pattern::CtorLeft(p) if left.is_none() => left = Some((p, arm.body)),
                Pattern::CtorRight(p) if right.is_none() => right = Some((p, arm.body)),
                Pattern::Wildcard | Pattern::Var(_) if default.is_none() => {
                    default = Some(arm.body)
                }
                _ => {} // redundant arm; first match wins
            }
        }

        // Choose the `Case` binder for each side. When the payload pattern is a
        // simple variable (the common `inl x =>` / `Ada(n) ->` form), use that
        // name directly as the binder — no wrapping `let`, giving a clean `Case`.
        // Otherwise introduce a fresh binder and destructure the payload.
        let (left_binder, left_branch) = match left {
            Some((pat, body)) => match *pat {
                Pattern::Var(name) => (name, body),
                Pattern::Wildcard => (self.fresh_var("padL"), body),
                other => {
                    let fresh = self.fresh_var("padL");
                    let b = self.bind_pattern(Expr::Var(fresh.clone()), &other, body)?;
                    (fresh, b)
                }
            },
            None => (self.fresh_var("padL"), default.clone().unwrap_or(Expr::Unit)),
        };
        let (right_binder, right_branch) = match right {
            Some((pat, body)) => match *pat {
                Pattern::Var(name) => (name, body),
                Pattern::Wildcard => (self.fresh_var("padR"), body),
                other => {
                    let fresh = self.fresh_var("padR");
                    let b = self.bind_pattern(Expr::Var(fresh.clone()), &other, body)?;
                    (fresh, b)
                }
            },
            None => (self.fresh_var("padR"), default.unwrap_or(Expr::Unit)),
        };

        Ok(Expr::Case(
            Box::new(scrutinee),
            left_binder,
            Box::new(left_branch),
            right_binder,
            Box::new(right_branch),
        ))
    }

    /// Bind a (payload) pattern against a scrutinee expression, then evaluate
    /// `body` in the resulting scope. Used for constructor payloads in `Case`
    /// branches. Variable patterns introduce a `let`; tuples project with
    /// `Fst`/`Snd`; wildcards/literals bind nothing.
    fn bind_pattern(
        &mut self,
        scrut: Expr,
        pat: &Pattern,
        body: Expr,
    ) -> Result<Expr, ParseError> {
        match pat {
            Pattern::Wildcard | Pattern::Int(_) | Pattern::Bool(_) | Pattern::Str(_) => Ok(body),
            Pattern::Var(name) => Ok(Expr::Let(
                name.clone(),
                None,
                Box::new(scrut),
                Box::new(body),
            )),
            Pattern::Tuple(elems) => {
                // Bind left-nested pairs: (a, b) -> let a = fst s; let b = snd s.
                // For arity > 2, the tail is itself treated as the snd component.
                self.bind_tuple(scrut, elems, body)
            }
            Pattern::CtorLeft(inner) | Pattern::CtorRight(inner) => {
                // Nested constructor in a payload: rare in the corpus; bind its
                // inner pattern directly against the (already-projected) value.
                self.bind_pattern(scrut, inner, body)
            }
            Pattern::List { .. } => {
                // List pattern as a constructor payload (e.g. `Ada([x, ..r])`):
                // bind a fresh temp to the value, then apply the list pattern's
                // element/rest bindings (the length test is irrefutable here since
                // the surrounding Case already selected this branch).
                let tmp = self.fresh_var("padLst");
                let (_test, binds) = self.pattern_test(&Expr::Var(tmp.clone()), pat);
                let bound = self.wrap_lets(binds, body);
                Ok(Expr::Let(tmp, None, Box::new(scrut), Box::new(bound)))
            }
            Pattern::Ref(inner) => {
                // Reference payload: bind the inner pattern against the deref.
                let deref = Expr::Deref(Box::new(scrut));
                self.bind_pattern(deref, inner, body)
            }
            Pattern::NamedCtor { .. } => {
                // Named-constructor pattern as a payload: bind a fresh temp and
                // apply its (irrefutable-here) variable bindings.
                let tmp = self.fresh_var("padCtor");
                let (_t, binds) = self.pattern_test(&Expr::Var(tmp.clone()), pat);
                let bound = self.wrap_lets(binds, body);
                Ok(Expr::Let(tmp, None, Box::new(scrut), Box::new(bound)))
            }
        }
    }

    /// Bind a tuple pattern by `Fst`/`Snd` projection. A 2-tuple binds
    /// `Fst`/`Snd`; an n-tuple binds the first element to `Fst` and recurses on
    /// `Snd` for the remainder.
    fn bind_tuple(
        &mut self,
        scrut: Expr,
        elems: &[Pattern],
        body: Expr,
    ) -> Result<Expr, ParseError> {
        if elems.is_empty() {
            return Ok(body);
        }
        if elems.len() == 1 {
            return self.bind_pattern(scrut, &elems[0], body);
        }
        let fst = Expr::Fst(Box::new(scrut.clone()));
        let snd = Expr::Snd(Box::new(scrut));
        let rest = self.bind_tuple(snd, &elems[1..], body)?;
        self.bind_pattern(fst, &elems[0], rest)
    }

    /// Compile a `padan` to a nested `If` chain over structural equality and
    /// tuple-component tests. Handles literal/bool/string/variable/wildcard/
    /// tuple patterns plus `kalau` guards.
    fn compile_if_chain(
        &mut self,
        scrutinee: Expr,
        mut arms: Vec<MatchArm>,
    ) -> Result<Expr, ParseError> {
        // Bind the scrutinee once to avoid re-evaluating it per arm.
        let s = self.fresh_var("padS");
        let s_expr = Expr::Var(s.clone());

        // RIINA has no exhaustiveness checker yet, and a desugared `If`-chain
        // needs a well-typed fallback. If no arm is irrefutable (no bare
        // wildcard/variable arm without a guard), the final arm is promoted to
        // the catch-all default: its test is dropped so its body becomes the
        // base case. This keeps exhaustive matches (e.g. `betul`/`salah`) sound
        // without a Unit-typed fallback. (Documented simplification.)
        let has_irrefutable = arms.iter().any(|a| {
            a.guard.is_none() && matches!(a.pattern, Pattern::Wildcard | Pattern::Var(_))
        });

        let mut result = if has_irrefutable {
            Expr::Unit
        } else if let Some(last) = arms.pop() {
            let (_test, bindings) = self.pattern_test(&s_expr, &last.pattern);
            self.wrap_lets(bindings, last.body)
        } else {
            Expr::Unit
        };

        for arm in arms.into_iter().rev() {
            let (test, bindings) = self.pattern_test(&s_expr, &arm.pattern);
            // Fold the guard (if any) into the arm test.
            let full_test = match arm.guard {
                Some(g) => match test {
                    Some(t) => Some(Expr::BinOp(BinOp::And, Box::new(t), Box::new(g))),
                    None => Some(g),
                },
                None => test,
            };
            // Bind the pattern variables around BOTH the test and body so guards
            // can reference them. Bindings are pure projections of the scrutinee.
            result = match full_test {
                Some(t) => self.wrap_lets(
                    bindings,
                    Expr::If(Box::new(t), Box::new(arm.body), Box::new(result)),
                ),
                None => self.wrap_lets(bindings, arm.body),
            };
        }
        Ok(Expr::Let(
            s,
            None,
            Box::new(scrutinee),
            Box::new(result),
        ))
    }

    /// Wrap `body` in a chain of `let` bindings, bringing pattern variables into
    /// scope. Bindings apply outermost-first (first binding is outermost).
    fn wrap_lets(&self, bindings: Vec<(Ident, Expr)>, body: Expr) -> Expr {
        bindings.into_iter().rev().fold(body, |acc, (name, value)| {
            Expr::Let(name, None, Box::new(value), Box::new(acc))
        })
    }

    /// Build the boolean test and variable bindings for one pattern against a
    /// scrutinee expression. Returns `(None, _)` for an irrefutable pattern
    /// (wildcard / variable) that always matches.
    fn pattern_test(&mut self, scrut: &Expr, pat: &Pattern) -> (Option<Expr>, Vec<(Ident, Expr)>) {
        match pat {
            Pattern::Wildcard => (None, Vec::new()),
            Pattern::Var(name) => (None, vec![(name.clone(), scrut.clone())]),
            Pattern::Int(n) => (
                Some(Expr::BinOp(
                    BinOp::Eq,
                    Box::new(scrut.clone()),
                    Box::new(Expr::Int(*n)),
                )),
                Vec::new(),
            ),
            Pattern::Bool(b) => (
                Some(Expr::BinOp(
                    BinOp::Eq,
                    Box::new(scrut.clone()),
                    Box::new(Expr::Bool(*b)),
                )),
                Vec::new(),
            ),
            Pattern::Str(s) => (
                Some(Expr::BinOp(
                    BinOp::Eq,
                    Box::new(scrut.clone()),
                    Box::new(Expr::String(s.clone())),
                )),
                Vec::new(),
            ),
            Pattern::Tuple(elems) => {
                // Conjoin component tests over Fst/Snd projections.
                let mut tests: Vec<Expr> = Vec::new();
                let mut binds: Vec<(Ident, Expr)> = Vec::new();
                let mut acc = scrut.clone();
                for (i, elem) in elems.iter().enumerate() {
                    let proj = if i + 1 == elems.len() {
                        // last component: the remaining accumulator
                        acc.clone()
                    } else {
                        Expr::Fst(Box::new(acc.clone()))
                    };
                    let (t, b) = self.pattern_test(&proj, elem);
                    if let Some(t) = t {
                        tests.push(t);
                    }
                    binds.extend(b);
                    acc = Expr::Snd(Box::new(acc));
                }
                let test = tests.into_iter().reduce(|a, b| {
                    Expr::BinOp(BinOp::And, Box::new(a), Box::new(b))
                });
                (test, binds)
            }
            Pattern::List { elems, tail } => {
                // Length test: exact `== n` for a fixed list, `>= n` when a rest
                // binding is present. Element `i` is `senarai_dapat((s, i))`; the
                // rest is `senarai_potong((s, (n, senarai_panjang(s))))`.
                let n = elems.len() as u64;
                let len_expr = Expr::App(
                    Box::new(Expr::Var("senarai_panjang".to_string())),
                    Box::new(scrut.clone()),
                );
                let len_op = if tail.is_some() { BinOp::Ge } else { BinOp::Eq };
                let mut tests = vec![Expr::BinOp(
                    len_op,
                    Box::new(len_expr.clone()),
                    Box::new(Expr::Int(n)),
                )];
                let mut binds: Vec<(Ident, Expr)> = Vec::new();
                for (i, elem) in elems.iter().enumerate() {
                    let item = Expr::App(
                        Box::new(Expr::Var("senarai_dapat".to_string())),
                        Box::new(Expr::Pair(
                            Box::new(scrut.clone()),
                            Box::new(Expr::Int(i as u64)),
                        )),
                    );
                    let (t, b) = self.pattern_test(&item, elem);
                    if let Some(t) = t {
                        tests.push(t);
                    }
                    binds.extend(b);
                }
                if let Some(rest_name) = tail {
                    if rest_name != "_" {
                        // rest = senarai_potong((s, (n, senarai_panjang(s))))
                        let slice = Expr::App(
                            Box::new(Expr::Var("senarai_potong".to_string())),
                            Box::new(Expr::Pair(
                                Box::new(scrut.clone()),
                                Box::new(Expr::Pair(
                                    Box::new(Expr::Int(n)),
                                    Box::new(len_expr),
                                )),
                            )),
                        );
                        binds.push((rest_name.clone(), slice));
                    }
                }
                let test = tests
                    .into_iter()
                    .reduce(|a, b| Expr::BinOp(BinOp::And, Box::new(a), Box::new(b)));
                (test, binds)
            }
            // Constructor patterns in the If-chain compiler (e.g. nested inside a
            // tuple pattern like `(Ada(a), Ada(b))`, where a top-level `Case`
            // can't be used). Test the sum tag with `adalah_kiri`/`adalah_kanan`
            // and project the payload with `nilai_kiri`/`nilai_kanan`, recursing
            // into the inner pattern.
            Pattern::CtorLeft(inner) | Pattern::CtorRight(inner) => {
                let is_left = matches!(pat, Pattern::CtorLeft(_));
                let (tag_fn, val_fn) = if is_left {
                    ("adalah_kiri", "nilai_kiri")
                } else {
                    ("adalah_kanan", "nilai_kanan")
                };
                let tag_test = Expr::App(
                    Box::new(Expr::Var(tag_fn.to_string())),
                    Box::new(scrut.clone()),
                );
                let payload = Expr::App(
                    Box::new(Expr::Var(val_fn.to_string())),
                    Box::new(scrut.clone()),
                );
                let (inner_test, binds) = self.pattern_test(&payload, inner);
                let test = match inner_test {
                    Some(t) => Expr::BinOp(BinOp::And, Box::new(tag_test), Box::new(t)),
                    None => tag_test,
                };
                (Some(test), binds)
            }
            // Reference pattern `ruj(p)`: dereference the scrutinee and match the
            // inner pattern against the pointed-to value. The reference itself is
            // irrefutable (any ref matches `ruj(_)`); refutability comes from `p`.
            Pattern::Ref(inner) => {
                let deref = Expr::Deref(Box::new(scrut.clone()));
                self.pattern_test(&deref, inner)
            }
            // Named (nominal-enum) constructor `C(p0, ...)` matches the structural
            // tagged value `("C", payload)`: test `fst(scrut) == "C"`, then match
            // the argument pattern(s) against `snd(scrut)` (the payload). A nullary
            // `C` matches the bare tag string "C".
            Pattern::NamedCtor { name, args } => {
                if args.is_empty() {
                    // Bare tag: the value is the string "C" itself.
                    let test = Expr::BinOp(
                        BinOp::Eq,
                        Box::new(scrut.clone()),
                        Box::new(Expr::String(name.clone())),
                    );
                    return (Some(test), Vec::new());
                }
                let tag = Expr::Fst(Box::new(scrut.clone()));
                let payload = Expr::Snd(Box::new(scrut.clone()));
                let mut tests = vec![Expr::BinOp(
                    BinOp::Eq,
                    Box::new(tag),
                    Box::new(Expr::String(name.clone())),
                )];
                let mut binds = Vec::new();
                // Match the argument pattern(s) against the payload. One arg
                // matches the payload directly; many match a right-nested tuple.
                let arg_pat = if args.len() == 1 {
                    args[0].clone()
                } else {
                    Pattern::Tuple(args.clone())
                };
                let (t, b) = self.pattern_test(&payload, &arg_pat);
                if let Some(t) = t {
                    tests.push(t);
                }
                binds.extend(b);
                let test = tests
                    .into_iter()
                    .reduce(|a, b| Expr::BinOp(BinOp::And, Box::new(a), Box::new(b)));
                (test, binds)
            }
        }
    }

    /// Generate a fresh, source-illegal variable name (contains `$`) to avoid
    /// capturing user identifiers in desugared bindings.
    fn fresh_var(&mut self, hint: &str) -> Ident {
        let id = self.gensym;
        self.gensym += 1;
        format!("${hint}{id}")
    }

    /// Build a projection of element `i` (0-based) from an `n`-element tuple held
    /// in variable `tmp`, where tuples are right-nested pairs
    /// `(e0, (e1, (e2, ...)))`. Element `i` is `Snd` applied `i` times, then
    /// `Fst` unless it is the last element (which is the final `Snd`).
    fn tuple_proj(&self, tmp: &str, i: usize, n: usize) -> Expr {
        let mut acc = Expr::Var(tmp.to_string());
        for _ in 0..i {
            acc = Expr::Snd(Box::new(acc));
        }
        if i + 1 < n {
            Expr::Fst(Box::new(acc))
        } else {
            acc
        }
    }

    fn parse_handle(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwHandle)?;
        let e = self.parse_expr()?;
        self.consume(TokenKind::KwWith)?;
        let x = self.parse_ident()?;
        self.consume(TokenKind::FatArrow)?;
        let h = self.parse_expr()?;
        Ok(Expr::Handle(Box::new(e), x, Box::new(h)))
    }

    fn parse_ident(&mut self) -> Result<Ident, ParseError> {
        let kind = self.peek().map(|t| t.kind.clone());
        match kind {
            Some(TokenKind::Identifier(s)) => {
                self.next();
                Ok(s)
            }
            Some(_) => Err(ParseError {
                kind: ParseErrorKind::ExpectedIdentifier,
                span: self.current_span,
            }),
            None => Err(ParseError {
                kind: ParseErrorKind::UnexpectedEof,
                span: self.current_span,
            }),
        }
    }

    /// The canonical Bahasa Melayu spelling for "soft" keyword tokens — domain
    /// keywords that the example corpus also uses as ordinary variable, parameter,
    /// and field names (e.g. `tahap`, `keadaan`, `jenis`, `input`). Returns `None`
    /// for tokens that are *not* allowed as names (structural keywords like `fn`,
    /// `let`, `if`, etc., whose use as a name would be genuinely ambiguous).
    fn soft_keyword_spelling(kind: &TokenKind) -> Option<&'static str> {
        Some(match kind {
            TokenKind::KwLevel => "tahap",
            TokenKind::KwState => "keadaan",
            TokenKind::KwType => "jenis",
            TokenKind::KwInput => "input",
            TokenKind::KwToken => "token",
            TokenKind::KwRole => "peranan",
            TokenKind::KwChannel => "saluran",
            TokenKind::KwPolicy => "dasar",
            TokenKind::KwText_ => "tulisan",
            TokenKind::KwDisplay => "paparan",
            TokenKind::KwSafe => "selamat",
            TokenKind::KwCapability => "keupayaan",
            TokenKind::KwSecret => "rahsia",
            TokenKind::KwRow => "baris",
            TokenKind::KwColumn => "lajur",
            TokenKind::KwMod => "mod",
            TokenKind::KwMerge => "gabung",
            TokenKind::KwCombined => "gabungan",
            TokenKind::KwColor => "warna",
            TokenKind::KwStyle => "gaya",
            // NOTE: `pertama`/`kedua` (KwFst/KwSnd) and `terus` (KwContinue) are
            // intentionally NOT soft keywords — they are projection operators /
            // control-flow in value position, so allowing them as names would be
            // genuinely ambiguous.
            _ => return None,
        })
    }

    /// The optional `: T` of `biar x: T = e`. It is checked: the value becomes
    /// `Expr::Ascribe(e, T)`. Until 2026-10-20 it was parsed and discarded, so
    /// `biar x: Teks = 5` ran and printed 5 (REQ-97).
    fn parse_binding_annotation(&mut self) -> Result<Option<Ty>, ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Colon)) {
            self.consume(TokenKind::Colon)?;
            Ok(Some(self.parse_ty()?))
        } else {
            Ok(None)
        }
    }

    /// True when the next token is a soft keyword whose spelling names a
    /// binding in scope (`biar baris = …`, a parameter `token`). That binding
    /// shadows the keyword's construct, so a read of it is the variable. Eight
    /// construct keywords (`token`, `tulisan`, `paparan`, `baris`, `lajur`,
    /// `gabung`, `warna`, `gaya`) were accepted as binding names while every
    /// read parsed as the construct, so the binding could never be used.
    fn peek_is_bound_keyword(&mut self) -> bool {
        let Some(name) = self.peek().and_then(|t| Self::soft_keyword_spelling(&t.kind)) else {
            return false;
        };
        self.binding_scope.iter().any(|(n, _)| n == name)
    }

    /// Parse a binding/parameter/field name. Accepts a normal identifier or a
    /// "soft" keyword (see [`Parser::soft_keyword_spelling`]) used as a name,
    /// which the example corpus does pervasively (`tahap: Teks`, `keadaan: ...`).
    fn parse_binding_name(&mut self) -> Result<Ident, ParseError> {
        match self.peek().map(|t| t.kind.clone()) {
            Some(TokenKind::Identifier(s)) => {
                self.next();
                Ok(s)
            }
            Some(ref k) if Self::soft_keyword_spelling(k).is_some() => {
                let name = Self::soft_keyword_spelling(k).unwrap().to_string();
                self.next();
                Ok(name)
            }
            Some(_) => Err(ParseError {
                kind: ParseErrorKind::ExpectedIdentifier,
                span: self.current_span,
            }),
            None => Err(ParseError {
                kind: ParseErrorKind::UnexpectedEof,
                span: self.current_span,
            }),
        }
    }

    /// Parse an optional trailing `kesan <eff>` effect annotation on a function
    /// type (e.g. `Fn(A) -> B kesan Tulis`). Defaults to pure.
    ///
    /// A compound annotation keeps EVERY component: the latent effect of a
    /// function type is an `EffectSet`, and collapsing `kesan (Masa,
    /// SistemFail)` to its lattice join (`Masa`) would let a `kesan Masa`
    /// caller invoke a file-writing function value (M1c).
    fn parse_optional_fn_effect(&mut self) -> Result<EffectSet, ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwEffect)) {
            self.consume(TokenKind::KwEffect)?;
            self.parse_effect_annotation()
                .map(|(eff, set)| EffectSet::from_declaration(eff, &set))
        } else {
            Ok(EffectSet::PURE)
        }
    }

    /// Nesting-guarded entry (see [`MAX_EXPR_DEPTH`]).
    fn parse_ty(&mut self) -> Result<Ty, ParseError> {
        self.nested(Self::parse_ty_inner)
    }

    fn parse_ty_inner(&mut self) -> Result<Ty, ParseError> {
        let kind = self.peek().map(|t| t.kind.clone());
        match kind {
            Some(TokenKind::Star) => {
                // *T = RawPtr(T) for FFI
                self.next();
                let inner = self.parse_ty()?;
                Ok(Ty::RawPtr(Box::new(inner)))
            }
            Some(TokenKind::LParen) => {
                self.next();
                // () = Unit, or (T1, T2) = Prod
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                    self.next();
                    return Ok(Ty::Unit);
                }
                let t1 = self.parse_ty()?;
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                    self.consume(TokenKind::Comma)?;
                    let t2 = self.parse_ty()?;
                    self.consume(TokenKind::RParen)?;
                    Ok(Ty::Prod(Box::new(t1), Box::new(t2)))
                } else {
                    self.consume(TokenKind::RParen)?;
                    Ok(t1)
                }
            }
            Some(TokenKind::Identifier(s)) => {
                self.next();
                match s.as_str() {
                    // Primitives
                    "Int" | "Nombor" => Ok(Ty::Int),
                    // Sized integer types (numeric-tower slice).
                    "u8" => Ok(Ty::IntN { bits: 8, signed: false }),
                    "u16" => Ok(Ty::IntN { bits: 16, signed: false }),
                    "u32" => Ok(Ty::IntN { bits: 32, signed: false }),
                    "u64" => Ok(Ty::IntN { bits: 64, signed: false }),
                    "i8" => Ok(Ty::IntN { bits: 8, signed: true }),
                    "i16" => Ok(Ty::IntN { bits: 16, signed: true }),
                    "i32" => Ok(Ty::IntN { bits: 32, signed: true }),
                    "i64" => Ok(Ty::IntN { bits: 64, signed: true }),
                    // Arbitrary-precision integer (numeric-tower BigInt slice).
                    "Besar" | "BigInt" => Ok(Ty::BigInt),
                    // Arbitrary-precision decimal (numeric-tower decimal slice).
                    "Perpuluhan" | "Decimal" => Ok(Ty::Decimal),
                    // Fixed-scale decimal / money (numeric-tower fixed-point slice).
                    "Wang" | "Money" | "TitikTetap" => Ok(Ty::Fixed),
                    // Binary fixed-point / Q-format (numeric-tower fixed-point slice).
                    "Qmn" | "BinaryFixed" => Ok(Ty::FixedBin),
                    "Bool" | "Benar" => Ok(Ty::Bool),
                    "Unit" | "Kosong" => Ok(Ty::Unit),
                    "String" | "Teks" => Ok(Ty::String),
                    "Bytes" | "Bait" => Ok(Ty::Bytes),

                    // Parameterized types: Name<T>
                    "List" | "Senarai" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::List(Box::new(inner)))
                    }
                    "Option" | "Mungkin" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::Option(Box::new(inner)))
                    }
                    // Result<T, E>: the sum `Jadi(x)` (left) and `Gagal(e)`
                    // (right) build.
                    "Result" | "Hasil" => {
                        self.consume(TokenKind::Lt)?;
                        let ok = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let err = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::Sum(Box::new(ok), Box::new(err)))
                    }
                    "Secret" | "Rahsia" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::Secret(Box::new(inner)))
                    }
                    "Proof" | "Bukti" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::Proof(Box::new(inner)))
                    }
                    "ConstantTime" | "MasaTetap" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::ConstantTime(Box::new(inner)))
                    }
                    "Zeroizing" | "Sifar" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::Zeroizing(Box::new(inner)))
                    }
                    // Ref<T>@level
                    "Ref" | "Ruj" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        self.consume(TokenKind::At)?;
                        let level = self.parse_security_level()?;
                        Ok(Ty::Ref(Box::new(inner), level))
                    }
                    // Sum type: Sum<T1, T2>
                    "Sum" => {
                        self.consume(TokenKind::Lt)?;
                        let t1 = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let t2 = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::Sum(Box::new(t1), Box::new(t2)))
                    }
                    // Function type. Two surface forms are accepted:
                    //   Fn(P0, P1, ...) -> Ret [kesan E]   (0+ params)
                    //   Fn(ParamTy, RetTy [, Eff])         (legacy comma form)
                    // Several parameters curry exactly as a `fungsi` declaration's
                    // type does (`declared_fn_ty`); `Fn()` takes Unit. Until
                    // 2026-10-20 only the first parameter was kept, so
                    // `Fn(A, B) -> R` accepted a one-argument function (REQ-97).
                    "Fn" | "fungsi" => {
                        self.consume(TokenKind::LParen)?;
                        // Collect comma-separated types inside the parens. A
                        // trailing element that is an effect keyword (legacy
                        // 3-arg form `Fn(P, R, Eff)`) is captured separately.
                        let mut tys = Vec::new();
                        let mut legacy_eff: Option<Effect> = None;
                        // Where a third TYPE starts: legal in the arrow form,
                        // an error in the legacy form (its third slot is an
                        // effect, and a type there used to be dropped).
                        let mut third_ty_span = None;
                        if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                            tys.push(self.parse_ty()?);
                            while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                                self.consume(TokenKind::Comma)?;
                                // In the legacy form, the third element is an
                                // effect, not a type. Detect an effect-starting
                                // token and parse it as such.
                                if tys.len() >= 2 && self.peek_starts_effect() {
                                    legacy_eff = Some(self.parse_effect()?);
                                    break;
                                }
                                if tys.len() == 2 {
                                    third_ty_span = self.peek().map(|t| t.span);
                                }
                                tys.push(self.parse_ty()?);
                            }
                        }
                        self.consume(TokenKind::RParen)?;

                        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Arrow)) {
                            // Arrow form `Fn(P0, P1, ...) -> Ret [kesan Eff]`. The
                            // AST `Ty::Fn` is single-argument, so the first param
                            // type is the representative (the type layer is not yet
                            // fully curried); `Fn()` uses Unit.
                            self.consume(TokenKind::Arrow)?;
                            let ret_ty = self.parse_ty()?;
                            let eff = self.parse_optional_fn_effect()?;
                            let params: Vec<(Ident, Ty)> =
                                tys.into_iter().map(|t| (String::new(), t)).collect();
                            Ok(riina_types::declared_fn_ty(&params, &ret_ty, eff))
                        } else if let Some(span) = third_ty_span.filter(|_| legacy_eff.is_none()) {
                            Err(ParseError {
                                kind: ParseErrorKind::InvalidEffect,
                                span,
                            })
                        } else {
                            // Legacy comma form `Fn(ParamTy, RetTy [, Effect])`.
                            let mut it = tys.into_iter();
                            let param_ty = it.next().unwrap_or(Ty::Unit);
                            let ret_ty = it.next().unwrap_or(Ty::Unit);
                            Ok(Ty::Fn(
                                Box::new(param_ty),
                                Box::new(ret_ty),
                                EffectSet::from(legacy_eff.unwrap_or(Effect::Pure)),
                            ))
                        }
                    }
                    // Labeled<T, Level> / Berlabel<T, Level>
                    "Labeled" | "Berlabel" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let level = self.parse_security_level()?;
                        self.consume_type_close()?;
                        Ok(Ty::Labeled(Box::new(inner), level))
                    }
                    // Tainted<T, Source> / Tercemar<T, Source>
                    "Tainted" | "Tercemar" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let source = self.parse_taint_source()?;
                        self.consume_type_close()?;
                        Ok(Ty::Tainted(Box::new(inner), source))
                    }
                    // Sanitized<T, Sanitizer> / Disanitasi<T, Sanitizer>
                    "Sanitized" | "Disanitasi" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let san = self.parse_sanitizer()?;
                        self.consume_type_close()?;
                        Ok(Ty::Sanitized(Box::new(inner), san))
                    }
                    // FFI C types
                    "CInt" => Ok(Ty::CInt),
                    "CChar" => Ok(Ty::CChar),
                    "CVoid" => Ok(Ty::CVoid),
                    // Capability<Kind> / Keupayaan<Kind>
                    "Capability" | "Keupayaan" => {
                        self.consume(TokenKind::Lt)?;
                        let kind = self.parse_capability_kind()?;
                        self.consume_type_close()?;
                        Ok(Ty::Capability(kind))
                    }
                    // Chan<SessionType> / Saluran<SessionType>
                    "Chan" | "Saluran" => {
                        self.consume(TokenKind::Lt)?;
                        let st = self.parse_session_type()?;
                        self.consume_type_close()?;
                        Ok(Ty::Chan(st))
                    }
                    // SecureChan<SessionType, Level> / SaluranSelamat<SessionType, Level>
                    "SecureChan" | "SaluranSelamat" => {
                        self.consume(TokenKind::Lt)?;
                        let st = self.parse_session_type()?;
                        self.consume(TokenKind::Comma)?;
                        let level = self.parse_security_level()?;
                        self.consume_type_close()?;
                        Ok(Ty::SecureChan(st, level))
                    }
                    "SmartContract" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::SmartContract(Box::new(inner)))
                    }
                    "Token" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::Token(Box::new(inner)))
                    }
                    "SyariahCompliant" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume_type_close()?;
                        Ok(Ty::SyariahCompliant(Box::new(inner)))
                    }
                    // A declared type or generic parameter; anything else is
                    // an error (REQ-93(c)).
                    _ => self.resolve_named_type(s),
                }
            }
            Some(TokenKind::KwSmartContract) => {
                self.next();
                self.consume(TokenKind::Lt)?;
                let inner = self.parse_ty()?;
                self.consume_type_close()?;
                Ok(Ty::SmartContract(Box::new(inner)))
            }
            Some(TokenKind::KwToken) => {
                self.next();
                self.consume(TokenKind::Lt)?;
                let inner = self.parse_ty()?;
                self.consume_type_close()?;
                Ok(Ty::Token(Box::new(inner)))
            }
            Some(TokenKind::KwShariahCompliant) => {
                self.next();
                self.consume(TokenKind::Lt)?;
                let inner = self.parse_ty()?;
                self.consume_type_close()?;
                Ok(Ty::SyariahCompliant(Box::new(inner)))
            }
            _ => Err(ParseError {
                kind: ParseErrorKind::ExpectedType,
                span: self.current_span,
            }),
        }
    }

    fn parse_security_level(&mut self) -> Result<SecurityLevel, ParseError> {
        let ident = self.parse_ident()?;
        match ident.as_str() {
            "Public" | "Awam" => Ok(SecurityLevel::Public),
            "Internal" | "Dalaman" => Ok(SecurityLevel::Internal),
            "Session" | "Sesi" => Ok(SecurityLevel::Session),
            "User" | "Pengguna" => Ok(SecurityLevel::User),
            "System" | "Sistem" => Ok(SecurityLevel::System),
            "Secret" | "Rahsia" => Ok(SecurityLevel::Secret),
            _ => Err(ParseError {
                kind: ParseErrorKind::InvalidSecurityLevel,
                span: self.current_span,
            }),
        }
    }

    /// Parse an effect annotation that is either a single effect (`kesan Kripto`)
    /// or a parenthesized list (`kesan (Kripto, MasaTetap)`). A list is combined
    /// with `Effect::join` into the dominant effect, since the effect model has
    /// no effect-rows yet. An empty `()` is `Pure`.
    /// Parse an effect annotation, returning both the joined lattice `Effect`
    /// (for propagation/codegen) and the *components* of a compound annotation
    /// (for capability granting — the join is lossy). A single effect yields a
    /// one-element component vector.
    fn parse_effect_annotation(&mut self) -> Result<(Effect, Vec<Effect>), ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
            self.consume(TokenKind::LParen)?;
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                self.consume(TokenKind::RParen)?;
                return Ok((Effect::Pure, vec![Effect::Pure]));
            }
            // A parenthesized effect set may be separated by `,` or `|`
            // (`kesan (Bersih | SistemFail)`); the components are preserved.
            let first = self.parse_effect()?;
            let mut eff = first;
            let mut set = vec![first];
            while matches!(
                self.peek().map(|t| &t.kind),
                Some(TokenKind::Comma) | Some(TokenKind::Or)
            ) {
                self.next();
                let e = self.parse_effect()?;
                eff = eff.join(e);
                set.push(e);
            }
            self.consume(TokenKind::RParen)?;
            Ok((eff, set))
        } else {
            let e = self.parse_effect()?;
            Ok((e, vec![e]))
        }
    }

    /// True when the next token is an identifier naming an effect (used to
    /// distinguish the legacy `Fn(P, R, Eff)` third element from a type).
    fn peek_starts_effect(&mut self) -> bool {
        matches!(
            self.peek().map(|t| &t.kind),
            Some(TokenKind::Identifier(s)) if matches!(
                s.as_str(),
                "Pure" | "Bersih" | "Mut" | "Ubah" | "Alloc" | "Peruntuk"
                | "Read" | "Baca" | "Write" | "Tulis" | "FileSystem" | "SistemFail"
                | "Network" | "Rangkaian" | "NetworkSecure" | "RangkaianSelamat"
                | "Crypto" | "Kripto" | "ConstantTime" | "MasaTetap" | "Random"
                | "Rawak" | "System" | "Sistem" | "Time" | "Masa" | "Process"
                | "Proses" | "Panel" | "Zirah" | "Benteng" | "Sandi" | "Menara"
                | "Gapura"
            )
        )
    }

    fn parse_effect(&mut self) -> Result<Effect, ParseError> {
        let ident = self.parse_ident()?;
        match ident.as_str() {
            "Pure" | "Bersih" => Ok(Effect::Pure),
            "Mut" | "Ubah" => Ok(Effect::Mut),
            "Alloc" | "Peruntuk" => Ok(Effect::Alloc),
            "Read" | "Baca" => Ok(Effect::Read),
            "Write" | "Tulis" => Ok(Effect::Write),
            "FileSystem" | "SistemFail" => Ok(Effect::FileSystem),
            "Network" | "Rangkaian" => Ok(Effect::Network),
            "NetworkSecure" | "RangkaianSelamat" => Ok(Effect::NetworkSecure),
            "Crypto" | "Kripto" => Ok(Effect::Crypto),
            // `MasaTetap` (constant-time) appears in effect position in many
            // examples. It is a crypto-security guarantee, so it maps to the
            // Crypto effect (there is no distinct constant-time effect variant).
            "ConstantTime" | "MasaTetap" => Ok(Effect::Crypto),
            "Random" | "Rawak" => Ok(Effect::Random),
            "System" | "Sistem" => Ok(Effect::System),
            "Time" | "Masa" => Ok(Effect::Time),
            "Process" | "Proses" => Ok(Effect::Process),
            "Panel" => Ok(Effect::Panel),
            "Zirah" => Ok(Effect::Zirah),
            "Benteng" => Ok(Effect::Benteng),
            "Sandi" => Ok(Effect::Sandi),
            "Menara" => Ok(Effect::Menara),
            "Gapura" => Ok(Effect::Gapura),
            _ => Err(ParseError {
                kind: ParseErrorKind::InvalidEffect,
                span: self.current_span,
            }),
        }
    }

    /// Parse a session type: Send<T, S> | Recv<T, S> | Select<S1, S2> |
    /// Branch<S1, S2> | End | Rec<X, S> | Var<X>
    /// Matches Coq SessionTypes.v session type constructors.
    /// Nesting-guarded entry (see [`MAX_EXPR_DEPTH`]).
    fn parse_session_type(&mut self) -> Result<SessionType, ParseError> {
        self.nested(Self::parse_session_type_inner)
    }

    fn parse_session_type_inner(&mut self) -> Result<SessionType, ParseError> {
        let ident = self.parse_ident()?;
        match ident.as_str() {
            // Send<PayloadType, Continuation>
            "Send" | "Hantar" => {
                self.consume(TokenKind::Lt)?;
                let payload = self.parse_ty()?;
                self.consume(TokenKind::Comma)?;
                let cont = self.parse_session_type()?;
                self.consume_type_close()?;
                Ok(SessionType::Send(Box::new(payload), Box::new(cont)))
            }
            // Recv<PayloadType, Continuation>
            "Recv" | "Terima" => {
                self.consume(TokenKind::Lt)?;
                let payload = self.parse_ty()?;
                self.consume(TokenKind::Comma)?;
                let cont = self.parse_session_type()?;
                self.consume_type_close()?;
                Ok(SessionType::Recv(Box::new(payload), Box::new(cont)))
            }
            // Select<S1, S2> — internal choice
            "Select" | "Pilih" => {
                self.consume(TokenKind::Lt)?;
                let s1 = self.parse_session_type()?;
                self.consume(TokenKind::Comma)?;
                let s2 = self.parse_session_type()?;
                self.consume_type_close()?;
                Ok(SessionType::Select(Box::new(s1), Box::new(s2)))
            }
            // Branch<S1, S2> — external choice
            "Branch" | "Cabang" => {
                self.consume(TokenKind::Lt)?;
                let s1 = self.parse_session_type()?;
                self.consume(TokenKind::Comma)?;
                let s2 = self.parse_session_type()?;
                self.consume_type_close()?;
                Ok(SessionType::Branch(Box::new(s1), Box::new(s2)))
            }
            // End — session termination
            "End" | "Tamat" => Ok(SessionType::End),
            // Rec<X, S> — recursive session type
            "Rec" | "Ulang" => {
                self.consume(TokenKind::Lt)?;
                let var = self.parse_ident()?;
                self.consume(TokenKind::Comma)?;
                let body = self.parse_session_type()?;
                self.consume_type_close()?;
                Ok(SessionType::Rec(var, Box::new(body)))
            }
            // Var<X> — session type variable (for recursion)
            "SVar" | "PembolehubahSesi" => {
                self.consume(TokenKind::Lt)?;
                let var = self.parse_ident()?;
                self.consume_type_close()?;
                Ok(SessionType::Var(var))
            }
            _ => Err(ParseError {
                kind: ParseErrorKind::InvalidSessionType,
                span: self.current_span,
            }),
        }
    }

    fn parse_taint_source(&mut self) -> Result<TaintSource, ParseError> {
        let ident = self.parse_ident()?;
        match ident.as_str() {
            "NetworkExternal" => Ok(TaintSource::NetworkExternal),
            "NetworkInternal" => Ok(TaintSource::NetworkInternal),
            "UserInput" => Ok(TaintSource::UserInput),
            "FileSystem" => Ok(TaintSource::FileSystem),
            "Database" => Ok(TaintSource::Database),
            "Environment" => Ok(TaintSource::Environment),
            "GapuraRequest" => Ok(TaintSource::GapuraRequest),
            "ZirahEvent" => Ok(TaintSource::ZirahEvent),
            "ZirahEndpoint" => Ok(TaintSource::ZirahEndpoint),
            "BentengBiometric" => Ok(TaintSource::BentengBiometric),
            "SandiSignature" => Ok(TaintSource::SandiSignature),
            "MenaraDevice" => Ok(TaintSource::MenaraDevice),
            _ => Err(ParseError {
                kind: ParseErrorKind::ExpectedType,
                span: self.current_span,
            }),
        }
    }

    fn parse_sanitizer(&mut self) -> Result<Sanitizer, ParseError> {
        let ident = self.parse_ident()?;
        match ident.as_str() {
            "HtmlEscape" => Ok(Sanitizer::HtmlEscape),
            "UrlEncode" => Ok(Sanitizer::UrlEncode),
            "JsEscape" => Ok(Sanitizer::JsEscape),
            "CssEscape" => Ok(Sanitizer::CssEscape),
            "SqlEscape" => Ok(Sanitizer::SqlEscape),
            "SqlParam" => Ok(Sanitizer::SqlParam),
            "XssFilter" => Ok(Sanitizer::XssFilter),
            "PathTraversal" => Ok(Sanitizer::PathTraversal),
            "CommandEscape" => Ok(Sanitizer::CommandEscape),
            "LdapEscape" => Ok(Sanitizer::LdapEscape),
            "XmlEscape" => Ok(Sanitizer::XmlEscape),
            "UrlAllowlist" => Ok(Sanitizer::UrlAllowlist),
            "JsonEscape" => Ok(Sanitizer::JsonEscape),
            "JsonValidation" => Ok(Sanitizer::JsonValidation),
            "XmlValidation" => Ok(Sanitizer::XmlValidation),
            "EmailValidation" => Ok(Sanitizer::EmailValidation),
            "PhoneValidation" => Ok(Sanitizer::PhoneValidation),
            "HashVerify" => Ok(Sanitizer::HashVerify),
            "SignatureVerify" => Ok(Sanitizer::SignatureVerify),
            "MacVerify" => Ok(Sanitizer::MacVerify),
            "GapuraAuth" => Ok(Sanitizer::GapuraAuth),
            "ZirahSession" => Ok(Sanitizer::ZirahSession),
            "BentengBiometric" => Ok(Sanitizer::BentengBiometric),
            "SandiDecrypt" => Ok(Sanitizer::SandiDecrypt),
            "MenaraAttestation" => Ok(Sanitizer::MenaraAttestation),
            _ => Err(ParseError {
                kind: ParseErrorKind::ExpectedType,
                span: self.current_span,
            }),
        }
    }

    // ── JALINAN Phase 6: Choreography & Actor parsing ──────────────────

    /// Parse: koreografi Name { peranan R1, R2; interactions... }
    fn parse_choreography(&mut self) -> Result<TopLevelDecl, ParseError> {
        self.consume(TokenKind::KwChoreography)?;
        let name = self.parse_ident()?;
        self.consume(TokenKind::LBrace)?;
        self.consume(TokenKind::KwRole)?;
        let mut roles = vec![self.parse_ident()?];
        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
            self.consume(TokenKind::Comma)?;
            roles.push(self.parse_ident()?);
        }
        self.consume(TokenKind::Semi)?;
        // Parse the protocol relative to the first role, so the stored
        // `SessionType` is that role's local view: `A -> B : T` becomes `Send T`
        // when A is roles[0] and `Recv T` when B is roles[0]. The other role's
        // view is the dual (see `project_choreography` in the typechecker).
        let viewpoint = roles.first().cloned().unwrap_or_default();
        let protocol = self.parse_choreography_protocol(&viewpoint)?;
        self.consume(TokenKind::RBrace)?;
        Ok(TopLevelDecl::Expr(Box::new(Expr::ChoreographyBlock {
            name,
            roles,
            protocol,
        })))
    }

    /// Parse a choreography interaction sequence into the `viewpoint` role's
    /// local `SessionType` (a message *from* the viewpoint is a `Send`, *to* it
    /// a `Recv`; a message between two other roles is skipped from this view).
    fn parse_choreography_protocol(
        &mut self,
        viewpoint: &str,
    ) -> Result<SessionType, ParseError> {
        match self.peek().map(|t| &t.kind) {
            // tamat; → End
            Some(TokenKind::KwEnd) => {
                self.consume(TokenKind::KwEnd)?;
                self.consume(TokenKind::Semi)?;
                Ok(SessionType::End)
            }
            // pilih { Label -> { ... }, Label -> { ... } } — the viewpoint role
            // selects (internal choice).
            Some(TokenKind::KwSelect) => {
                self.consume(TokenKind::KwSelect)?;
                self.consume(TokenKind::LBrace)?;
                let _label1 = self.parse_ident()?;
                self.consume(TokenKind::Arrow)?;
                self.consume(TokenKind::LBrace)?;
                let s1 = self.parse_choreography_protocol(viewpoint)?;
                self.consume(TokenKind::RBrace)?;
                self.consume(TokenKind::Comma)?;
                let _label2 = self.parse_ident()?;
                self.consume(TokenKind::Arrow)?;
                self.consume(TokenKind::LBrace)?;
                let s2 = self.parse_choreography_protocol(viewpoint)?;
                self.consume(TokenKind::RBrace)?;
                self.consume(TokenKind::RBrace)?;
                // Steps after the choice follow EACH branch. They used to be
                // parsed and dropped, so a protocol that went on after a
                // `pilih` lost its tail (REQ-97).
                let cont = self.parse_choreography_protocol(viewpoint)?;
                Ok(SessionType::Select(
                    Box::new(then_session(s1, &cont)),
                    Box::new(then_session(s2, &cont)),
                ))
            }
            // RBrace → implicit end (closing an enclosing block)
            Some(TokenKind::RBrace) => Ok(SessionType::End),
            // Identifier: sender -> receiver: hantar Type; continuation
            Some(TokenKind::Identifier(_)) => {
                let sender = self.parse_ident()?;
                self.consume(TokenKind::Arrow)?;
                let receiver = self.parse_ident()?;
                self.consume(TokenKind::Colon)?;
                self.consume(TokenKind::KwSend)?;
                // Any type, read like every other type annotation. Only four
                // names used to be recognised, and every other one (a list,
                // a record, `Rahsia<T>`) became `Any`.
                let msg_ty = self.parse_ty()?;
                self.consume(TokenKind::Semi)?;
                let continuation = self.parse_choreography_protocol(viewpoint)?;
                // Role-relative projection of a single message onto `viewpoint`.
                if sender == viewpoint {
                    Ok(SessionType::Send(Box::new(msg_ty), Box::new(continuation)))
                } else if receiver == viewpoint {
                    Ok(SessionType::Recv(Box::new(msg_ty), Box::new(continuation)))
                } else {
                    // Message between two other roles: invisible to this view.
                    Ok(continuation)
                }
            }
            _ => Err(ParseError {
                kind: ParseErrorKind::ExpectedExpression,
                span: self.current_span,
            }),
        }
    }

    /// Parse: pelaku Name { keadaan: Type kendalikan Msg(param) { body } ... }
    fn parse_actor_decl(&mut self) -> Result<TopLevelDecl, ParseError> {
        self.consume(TokenKind::KwActor)?;
        let name = self.parse_ident()?;
        self.consume(TokenKind::LBrace)?;

        // State type: keadaan: Type
        self.consume(TokenKind::KwState)?;
        self.consume(TokenKind::Colon)?;
        let state_ty = self.parse_ty()?;

        // Message handlers: kendalikan Msg(param) { body }
        let mut handlers: Vec<(Ident, Ident, Expr)> = Vec::new();
        while matches!(
            self.peek().map(|t| &t.kind),
            Some(TokenKind::Identifier(s)) if s == "kendalikan"
        ) {
            self.check_chain_len(handlers.len())?;
            self.next(); // consume "kendalikan" identifier
            let msg_name = self.parse_ident()?;
            self.consume(TokenKind::LParen)?;
            let param = self.parse_ident()?;
            self.consume(TokenKind::RParen)?;
            self.consume(TokenKind::LBrace)?;
            let body = self.parse_expr()?;
            self.consume(TokenKind::RBrace)?;
            handlers.push((msg_name, param, body));
        }

        self.consume(TokenKind::RBrace)?;

        // Build handler expression
        let handler = if handlers.is_empty() {
            Expr::Unit
        } else if handlers.len() == 1 {
            let (_msg, param, body) = handlers.into_iter().next().unwrap();
            Expr::Lam(param, Ty::Any, Box::new(body))
        } else {
            return Err(ParseError {
                kind: ParseErrorKind::MultipleActorHandlers(name),
                span: self.current_span,
            });
        };

        // Default init state based on state type
        let default_init = match &state_ty {
            Ty::Int => Expr::Int(0),
            Ty::Bool => Expr::Bool(false),
            Ty::String => Expr::String(String::new()),
            _ => Expr::Unit,
        };
        Ok(TopLevelDecl::Expr(Box::new(Expr::ActorDecl {
            name,
            state_ty,
            message_ty: Ty::Any,
            init_state: Box::new(default_init),
            handler: Box::new(handler),
        })))
    }

    /// Parse: lahir ActorType(init_state)
    fn parse_spawn(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwSpawn)?;
        let actor_name = self.parse_ident()?;
        self.consume(TokenKind::LParen)?;
        let init = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::Spawn(Box::new(Expr::Var(actor_name)), Box::new(init)))
    }

    /// Parse: hantar(actor, message)
    fn parse_actor_send(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwSend)?;
        self.consume(TokenKind::LParen)?;
        let actor = self.parse_control_flow()?;
        self.consume(TokenKind::Comma)?;
        let msg = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::ActorSend(Box::new(actor), Box::new(msg)))
    }

    /// Parse: terima(actor)
    fn parse_actor_recv(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwRecv)?;
        self.consume(TokenKind::LParen)?;
        let actor = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::ActorRecv(Box::new(actor)))
    }

    /// Parse: gabung(a, b)
    fn parse_crdt_merge(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwMerge)?;
        self.consume(TokenKind::LParen)?;
        let a = self.parse_control_flow()?;
        self.consume(TokenKind::Comma)?;
        let b = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::CRDTMerge(Box::new(a), Box::new(b)))
    }

    /// Parse: cincang(expr)
    fn parse_content_hash(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwContentHash)?;
        self.consume(TokenKind::LParen)?;
        let e = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::ContentHash(Box::new(e)))
    }

    /// Parse: sahkan(expected_hash, value)
    fn parse_content_verify(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwVerify)?;
        self.consume(TokenKind::LParen)?;
        let expected_hash = self.parse_control_flow()?;
        self.consume(TokenKind::Comma)?;
        let value = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::ContentVerify(
            Box::new(expected_hash),
            Box::new(value),
        ))
    }

    /// Parse: kontrak_pintar(expr) or kontrak_pintar { expr }
    fn parse_contract_deploy(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwSmartContract)?;
        let contract = match self.peek().map(|t| t.kind.clone()) {
            Some(TokenKind::LParen) => {
                self.consume(TokenKind::LParen)?;
                let contract = self.parse_control_flow()?;
                self.consume(TokenKind::RParen)?;
                contract
            }
            Some(TokenKind::LBrace) => {
                self.consume(TokenKind::LBrace)?;
                let contract = self.parse_control_flow()?;
                self.consume(TokenKind::RBrace)?;
                contract
            }
            Some(tok) => {
                return Err(ParseError {
                    kind: ParseErrorKind::UnexpectedToken(tok),
                    span: self.current_span,
                });
            }
            None => {
                return Err(ParseError {
                    kind: ParseErrorKind::UnexpectedEof,
                    span: self.current_span,
                });
            }
        };
        Ok(Expr::ContractDeploy(Box::new(contract)))
    }

    /// Parse: token(from, to, amount) or token::pindah(from, to, amount)
    fn parse_token_transfer(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwToken)?;
        if matches!(
            self.peek().map(|t| t.kind.clone()),
            Some(TokenKind::ColonColon)
        ) {
            self.consume(TokenKind::ColonColon)?;
            match self.peek().map(|t| t.kind.clone()) {
                Some(TokenKind::KwMove) => {
                    self.next();
                }
                Some(TokenKind::Identifier(method))
                    if method == "pindah" || method == "transfer" =>
                {
                    self.next();
                }
                Some(tok) => {
                    return Err(ParseError {
                        kind: ParseErrorKind::UnexpectedToken(tok),
                        span: self.current_span,
                    });
                }
                None => {
                    return Err(ParseError {
                        kind: ParseErrorKind::UnexpectedEof,
                        span: self.current_span,
                    });
                }
            }
        }
        self.consume(TokenKind::LParen)?;
        let from = self.parse_control_flow()?;
        self.consume(TokenKind::Comma)?;
        let to = self.parse_control_flow()?;
        self.consume(TokenKind::Comma)?;
        let amount = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::TokenTransfer {
            from: Box::new(from),
            to: Box::new(to),
            amount: Box::new(amount),
        })
    }

    /// Parse: zakat(expr)
    fn parse_zakat_calculate(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwZakat)?;
        self.consume(TokenKind::LParen)?;
        let value = self.parse_control_flow()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::ZakatCalculate(Box::new(value)))
    }

    // ════════════════════════════════════════════════════════════════════
    // CAHAYA Phase J5: UI Primitives
    // ════════════════════════════════════════════════════════════════════

    /// Parse a brace-delimited list of UI elements separated by `;`
    fn parse_ui_block_elements(&mut self) -> Result<Vec<Expr>, ParseError> {
        self.consume(TokenKind::LBrace)?;
        let mut elements = Vec::new();
        while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace)) {
            elements.push(self.parse_control_flow()?);
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Semi)) {
                self.next();
            }
        }
        self.consume(TokenKind::RBrace)?;
        Ok(elements)
    }

    /// Parse `paparan { elements... }` / `display { elements... }`
    fn parse_display(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwDisplay)?;
        let elements = self.parse_ui_block_elements()?;
        Ok(Expr::UIDisplay(elements))
    }

    /// Parse `baris { elements... }` / `row { elements... }`
    fn parse_row(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwRow)?;
        let elements = self.parse_ui_block_elements()?;
        Ok(Expr::UIRow(elements))
    }

    /// Parse `lajur { elements... }` / `column { elements... }`
    fn parse_column(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwColumn)?;
        let elements = self.parse_ui_block_elements()?;
        Ok(Expr::UIColumn(elements))
    }

    /// Parse `warna(r, g, b)` / `color(r, g, b)`
    fn parse_ui_color(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwColor)?;
        self.consume(TokenKind::LParen)?;
        let r = self.parse_u8_literal()?;
        self.consume(TokenKind::Comma)?;
        let g = self.parse_u8_literal()?;
        self.consume(TokenKind::Comma)?;
        let b = self.parse_u8_literal()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::UIColor(r, g, b))
    }

    /// Parse a u8 integer literal (0-255)
    fn parse_u8_literal(&mut self) -> Result<u8, ParseError> {
        let tok = self.next().ok_or(ParseError {
            kind: ParseErrorKind::UnexpectedEof,
            span: self.current_span,
        })?;
        match &tok.kind {
            TokenKind::LiteralInt(s, _) => {
                let val: u64 = s.parse().map_err(|_| ParseError {
                    kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                    span: tok.span,
                })?;
                if val > 255 {
                    return Err(ParseError {
                        kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                        span: tok.span,
                    });
                }
                Ok(val as u8)
            }
            _ => Err(ParseError {
                kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                span: tok.span,
            }),
        }
    }

    /// Parse `tulisan("text", color)` / `text("text", color)`
    fn parse_ui_text(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwText_)?;
        self.consume(TokenKind::LParen)?;
        let content = self.parse_expr()?;
        self.consume(TokenKind::Comma)?;
        let color = self.parse_expr()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::UIText(Box::new(content), Box::new(color)))
    }

    /// Parse `butang("label", handler)` / `button("label", handler)`
    fn parse_ui_button(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwButton)?;
        self.consume(TokenKind::LParen)?;
        let label = self.parse_expr()?;
        self.consume(TokenKind::Comma)?;
        let handler = self.parse_expr()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::UIButton(Box::new(label), Box::new(handler)))
    }

    /// Parse `kontras(fg, bg)` / `contrast(fg, bg)`
    fn parse_ui_contrast(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwContrast)?;
        self.consume(TokenKind::LParen)?;
        let fg = self.parse_expr()?;
        self.consume(TokenKind::Comma)?;
        let bg = self.parse_expr()?;
        self.consume(TokenKind::RParen)?;
        Ok(Expr::UIContrastCheck(Box::new(fg), Box::new(bg)))
    }

    /// Parse `gaya { pelapik: 16, saiz_fon: 14 }` / `style { padding: 16, font_size: 14 }`
    fn parse_style_decl(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwStyle)?;
        self.consume(TokenKind::LBrace)?;
        let mut padding = None;
        let mut font_size = None;
        while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace)) {
            let prop = self.peek().map(|t| t.kind.clone());
            match prop {
                Some(TokenKind::KwPadding) => {
                    self.consume(TokenKind::KwPadding)?;
                    self.consume(TokenKind::Colon)?;
                    let tok = self.next().ok_or(ParseError {
                        kind: ParseErrorKind::UnexpectedEof,
                        span: self.current_span,
                    })?;
                    match &tok.kind {
                        TokenKind::LiteralInt(s, _) => {
                            padding = Some(s.parse::<u32>().map_err(|_| ParseError {
                                kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                                span: tok.span,
                            })?);
                        }
                        _ => {
                            return Err(ParseError {
                                kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                                span: tok.span,
                            })
                        }
                    }
                }
                Some(TokenKind::KwFontSize) => {
                    self.consume(TokenKind::KwFontSize)?;
                    self.consume(TokenKind::Colon)?;
                    let tok = self.next().ok_or(ParseError {
                        kind: ParseErrorKind::UnexpectedEof,
                        span: self.current_span,
                    })?;
                    match &tok.kind {
                        TokenKind::LiteralInt(s, _) => {
                            font_size = Some(s.parse::<u32>().map_err(|_| ParseError {
                                kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                                span: tok.span,
                            })?);
                        }
                        _ => {
                            return Err(ParseError {
                                kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                                span: tok.span,
                            })
                        }
                    }
                }
                _ => {
                    let tok = self.next().ok_or(ParseError {
                        kind: ParseErrorKind::UnexpectedEof,
                        span: self.current_span,
                    })?;
                    return Err(ParseError {
                        kind: ParseErrorKind::UnexpectedToken(tok.kind.clone()),
                        span: tok.span,
                    });
                }
            }
            // consume optional comma separator
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                self.next();
            }
        }
        self.consume(TokenKind::RBrace)?;
        Ok(Expr::UIStyleDecl { padding, font_size })
    }

    fn parse_capability_kind(&mut self) -> Result<CapabilityKind, ParseError> {
        let ident = self.parse_ident()?;
        match ident.as_str() {
            "FileRead" => Ok(CapabilityKind::FileRead),
            "FileWrite" => Ok(CapabilityKind::FileWrite),
            "FileExecute" => Ok(CapabilityKind::FileExecute),
            "FileDelete" => Ok(CapabilityKind::FileDelete),
            "NetConnect" => Ok(CapabilityKind::NetConnect),
            "NetListen" => Ok(CapabilityKind::NetListen),
            "NetBind" => Ok(CapabilityKind::NetBind),
            "ProcSpawn" => Ok(CapabilityKind::ProcSpawn),
            "ProcSignal" => Ok(CapabilityKind::ProcSignal),
            "SysTime" => Ok(CapabilityKind::SysTime),
            "SysRandom" => Ok(CapabilityKind::SysRandom),
            "SysEnv" => Ok(CapabilityKind::SysEnv),
            "RootProduct" => Ok(CapabilityKind::RootProduct),
            "ProductAccess" => Ok(CapabilityKind::ProductAccess),
            _ => Err(ParseError {
                kind: ParseErrorKind::ExpectedType,
                span: self.current_span,
            }),
        }
    }
}

#[cfg(test)]
mod tests;

#[cfg(test)]
mod robustness_tests;
