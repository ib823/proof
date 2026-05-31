// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Parser
//!
//! Parses token streams into ASTs defined in `riina-types`.
//! RIINA = Rigorous Immutable Invariant, No Assumptions
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS

use riina_lexer::{Lexer, Span, Token, TokenKind};
use riina_types::Span as AstSpan;
use riina_types::{
    BinOp, CapabilityKind, Effect, Expr, ExternDecl, Ident, Linearity, Program, Sanitizer,
    SecurityLevel, SessionType, SpannedDecl, TaintSource, TopLevelDecl, Ty,
};
use std::fmt;
use std::iter::Peekable;

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
            ParseErrorKind::InvalidSecurityLevel => {
                "Invalid security level. Valid levels: Awam, Dalaman, Sesi, Pengguna, Sistem, Rahsia".to_string()
            }
            ParseErrorKind::InvalidEffect => {
                "Invalid effect. Valid effects: Bersih, Ubah, Baca, Tulis, SistemFail, Rangkaian, Kripto, Rawak, Sistem, Masa, Proses".to_string()
            }
            ParseErrorKind::InvalidSessionType => {
                "Invalid session type. Valid: Send<T, S>, Recv<T, S>, Select<S1, S2>, Branch<S1, S2>, End, Rec<X, S>, Var<X>".to_string()
            }
        })
    }
}

#[derive(Clone)]
struct LexerIter<'a> {
    lexer: Lexer<'a>,
}

impl Iterator for LexerIter<'_> {
    type Item = Token;

    fn next(&mut self) -> Option<Self::Item> {
        self.lexer.next_token().ok()
    }
}

pub struct Parser<'a> {
    lexer: Peekable<LexerIter<'a>>,
    current_span: Span,
    /// Counter for generating fresh, capture-free variable names during
    /// desugaring (e.g. `padan` compilation). See [`Parser::fresh_var`].
    gensym: usize,
    /// A "virtual" closing `>` left over after splitting a `>>` (Shr) token while
    /// closing nested generic type arguments (e.g. `Mungkin<Senarai<Nombor>>`).
    /// When set, the next [`Parser::consume_type_close`] consumes it without
    /// advancing the real token stream.
    pending_gt: bool,
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
    /// Left-injection constructor (`Some`/`Ada`/`Ok`/`Jadi`/`inl`) with payload.
    CtorLeft(Box<Pattern>),
    /// Right-injection constructor (`None`/`Tiada`/`Err`/`Gagal`/`Ralat`/`inr`)
    /// with payload.
    CtorRight(Box<Pattern>),
}

/// One arm of a `padan` expression: a pattern, an optional `kalau` guard, and a
/// body expression.
#[derive(Debug, Clone)]
struct MatchArm {
    pattern: Pattern,
    guard: Option<Expr>,
    body: Expr,
}

impl<'a> Parser<'a> {
    pub fn new(source: &'a str) -> Self {
        Self {
            lexer: LexerIter {
                lexer: Lexer::new(source),
            }
            .peekable(),
            current_span: Span { start: 0, end: 0 },
            gensym: 0,
            pending_gt: false,
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
        self.parse_stmt_sequence()
    }

    /// Parse a complete .rii file as a sequence of top-level declarations.
    pub fn parse_program(&mut self) -> Result<Program, ParseError> {
        let mut decls = Vec::new();
        let mut spans = Vec::new();
        while self.peek().map(|t| &t.kind) != Some(&TokenKind::Eof) && self.peek().is_some() {
            let start = self.peek().map(|t| t.span.start).unwrap_or(0);
            let decl = self.parse_top_level_decl()?;
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
        Ok(Program::with_spans(decls, spans))
    }

    /// Continue parsing the next top-level declaration after a skipped one
    /// (module/use/etc.). If the input is exhausted, yield a Unit expression
    /// declaration instead of recursing into `parse_top_level_decl` (which would
    /// try to parse an expression from EOF and fail).
    fn parse_next_decl_or_unit(&mut self) -> Result<TopLevelDecl, ParseError> {
        if matches!(
            self.peek().map(|t| &t.kind),
            Some(TokenKind::Eof) | None
        ) {
            return Ok(TopLevelDecl::Expr(Box::new(Expr::Unit)));
        }
        self.parse_top_level_decl()
    }

    fn parse_top_level_decl(&mut self) -> Result<TopLevelDecl, ParseError> {
        match self.peek().map(|t| &t.kind) {
            Some(TokenKind::KwMod) => {
                // Module declaration (no module system yet — both forms are
                // skipped):
                //   modul name;            (external/forward declaration)
                //   modul name { ...decls } (inline module — body skipped)
                self.consume(TokenKind::KwMod)?;
                let _name = self.parse_ident()?;
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LBrace)) {
                    self.consume(TokenKind::LBrace)?;
                    self.skip_balanced_braces();
                } else {
                    self.consume(TokenKind::Semi)?;
                }
                self.parse_next_decl_or_unit()
            }
            Some(TokenKind::KwUse) => {
                // guna path::to::module; — skip (no module system yet)
                self.consume(TokenKind::KwUse)?;
                while !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Semi) | None) {
                    self.next();
                }
                self.consume(TokenKind::Semi)?;
                self.parse_top_level_decl()
            }
            Some(TokenKind::KwStruct) | Some(TokenKind::KwEnum) => {
                // bentuk/pilihan — skip declaration (no struct/enum semantics yet)
                self.next(); // consume KwStruct or KwEnum
                let _name = self.parse_ident()?;
                self.consume(TokenKind::LBrace)?;
                self.skip_balanced_braces();
                self.parse_top_level_decl()
            }
            Some(TokenKind::KwType) => {
                // jenis — skip type/record declaration (no nominal type semantics
                // yet; the typechecker infers structurally). Forms handled:
                //   jenis Name { ... }
                //   jenis Name<T, ...> { ... }
                //   jenis Name            (marker type, no body)
                self.next(); // consume KwType
                let _name = self.parse_ident()?;
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
                            None => break,
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
                        self.skip_balanced_braces();
                    }
                    // Type alias: `jenis Name = SomeType;` — skip to the `;`.
                    Some(TokenKind::Eq) => {
                        self.next();
                        while !matches!(
                            self.peek().map(|t| &t.kind),
                            Some(TokenKind::Semi) | None
                        ) {
                            self.next();
                        }
                        let _ = self.consume(TokenKind::Semi);
                    }
                    // Marker type with no body: `jenis Name`
                    _ => {}
                }
                self.parse_top_level_decl()
            }
            Some(TokenKind::KwChoreography) => self.parse_choreography(),
            Some(TokenKind::KwActor) => self.parse_actor_decl(),
            Some(TokenKind::KwTest) => self.parse_test_block(),
            Some(TokenKind::KwExtern) => self.parse_extern_block(),
            Some(TokenKind::KwPub) => {
                // awam fungsi ... — consume visibility, delegate
                self.consume(TokenKind::KwPub)?;
                self.parse_top_level_decl()
            }
            Some(TokenKind::KwFn) => self.parse_function_decl(),
            Some(TokenKind::KwLet) => {
                self.consume(TokenKind::KwLet)?;
                // Optional `ubah` (mut) modifier, accepted and ignored.
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwMut)) {
                    self.consume(TokenKind::KwMut)?;
                }
                let name = self.parse_ident()?;
                // Optional type annotation `biar x: T = e` (parsed and discarded;
                // type is inferred). Mirrors the in-function binding form.
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Colon)) {
                    self.consume(TokenKind::Colon)?;
                    let _annotated_ty = self.parse_ty()?;
                }
                self.consume(TokenKind::Eq)?;
                let value = self.parse_control_flow()?;
                self.consume(TokenKind::Semi)?;
                Ok(TopLevelDecl::Binding {
                    name,
                    value: Box::new(value),
                })
            }
            _ => {
                let expr = self.parse_expr()?;
                Ok(TopLevelDecl::Expr(Box::new(expr)))
            }
        }
    }

    fn parse_function_decl(&mut self) -> Result<TopLevelDecl, ParseError> {
        self.consume(TokenKind::KwFn)?;
        let mut name = self.parse_ident()?;
        // A qualified method-style definition name `Type::method` resolves to the
        // flat builtin name `Type_method` for a lowercase module, or to the final
        // segment for a capitalized namespace — matching how `::` call sites
        // resolve (see `parse_module_path`), so definitions and calls line up.
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::ColonColon)) {
            name = self.parse_module_path(name)?;
        }
        // Optional generic parameter list `<T>`, `<E, T>`, `<T1, T2>`, etc.
        // RIINA's type system is monomorphic at this layer; generic parameters
        // carry no semantics yet, so the list is skipped (balanced-angle aware,
        // so bounds like `<T: Sifat>` and nested `<Map<K, V>>` are consumed).
        self.skip_type_argument_list();
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
        let effect = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwEffect)) {
            self.consume(TokenKind::KwEffect)?;
            self.parse_effect_annotation()?
        } else {
            Effect::Pure
        };

        // Body in braces
        self.consume(TokenKind::LBrace)?;
        let body = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;

        Ok(TopLevelDecl::Function {
            name,
            params,
            return_ty,
            effect,
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
            let name = self.parse_ident()?;
            self.consume(TokenKind::Colon)?;
            let ty = self.parse_ty()?;
            params.push((name, ty));

            while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                self.consume(TokenKind::Comma)?;
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwMut)) {
                    self.consume(TokenKind::KwMut)?;
                }
                let name = self.parse_ident()?;
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
    fn parse_stmt_sequence(&mut self) -> Result<Expr, ParseError> {
        // Local (nested) function declaration: `fungsi f(..) -> T { .. }` in
        // statement position. Desugars to a recursive `LetRec` binding whose
        // continuation is the rest of the sequence, mirroring how top-level
        // functions desugar. Distinguished from a lambda (`fn(x: T) body`) by a
        // *named* head: `fn`/`fungsi` immediately followed by an identifier.
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
                    body,
                } => (name, params, return_ty, effect, body),
                _ => unreachable!("parse_function_decl returns Function"),
            };
            let continuation = if self.at_sequence_end() {
                Expr::Var(name.clone())
            } else {
                self.parse_stmt_sequence()?
            };
            // Build the curried lambda and its function type (right-fold over
            // params), matching `riina_types::desugar_function`.
            let lam = params.iter().rev().fold(*body, |acc, (p, ty)| {
                Expr::Lam(p.clone(), ty.clone(), Box::new(acc))
            });
            let fn_ty = params
                .iter()
                .rev()
                .fold(return_ty, |ret, (_, param_ty)| {
                    Ty::Fn(Box::new(param_ty.clone()), Box::new(ret), effect)
                });
            return Ok(Expr::LetRec(
                name,
                fn_ty,
                Box::new(lam),
                Box::new(continuation),
            ));
        }

        // Check if this is a let-binding
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwLet)) {
            self.consume(TokenKind::KwLet)?;
            // Optional `ubah` (mut) modifier: `biar ubah x = e`. Accepted and
            // ignored — the binding AST carries no mutability flag (matching how
            // `ubah` is handled on function parameters).
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwMut)) {
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
            let name = self.parse_ident()?;
            // Optional type annotation: `biar x: T = e`. Accepted for ergonomics
            // and documentation; the binding's type is inferred by the
            // typechecker, so the parsed `Ty` is intentionally discarded (the
            // Let AST node carries no annotation slot).
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Colon)) {
                self.consume(TokenKind::Colon)?;
                let _annotated_ty = self.parse_ty()?;
            }
            self.consume(TokenKind::Eq)?;
            let e1 = self.parse_control_flow()?;
            self.consume(TokenKind::Semi)?;
            // A trailing binding with nothing after it (`biar x = e;` then `}`/EOF)
            // yields Unit as the block's value.
            let e2 = if self.at_sequence_end() {
                Expr::Unit
            } else {
                self.parse_stmt_sequence()?
            };
            return Ok(Expr::Let(name, linearity, Box::new(e1), Box::new(e2)));
        }

        // Statement-position reassignment: `x = e;` rebinds `x` for the rest of
        // the sequence (shadowing). RIINA bindings are immutable, so a true
        // mutation has no AST node; for straight-line accumulator code
        // (`x = x + 1;`) rebinding is observationally equivalent — later
        // references see the new value. Detected as `ident =` where the next
        // token is a single `=` (not `==`). Field/element assignments
        // (`obj.f = e`) are not rebindable and fall through to normal parsing.
        if let Some(name) = self.peek_simple_reassignment() {
            self.parse_ident()?; // consume the name
            self.consume(TokenKind::Eq)?;
            let value = self.parse_control_flow()?;
            self.consume(TokenKind::Semi)?;
            let rest = if self.at_sequence_end() {
                Expr::Var(name.clone())
            } else {
                self.parse_stmt_sequence()?
            };
            return Ok(Expr::Let(name, None, Box::new(value), Box::new(rest)));
        }

        // A block-form statement (`kalau`/`padan`/`selagi`/`untuk`/`ulang`) may
        // be used in statement position without a trailing `;`, e.g. an
        // early-return guard `kalau c { pulang x; }` followed by more statements.
        // Other expressions still require a `;` to start a sequence.
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
            // A trailing `;` before the block end (`expr;` then `}`/EOF) — e.g. a
            // final `pulang x;` — yields `expr` as the block's value. RIINA marks
            // returns explicitly with `pulang`, so `pulang x;}` is intended to
            // return `x`, not discard it.
            if self.at_sequence_end() {
                return Ok(first);
            }
            let rest = self.parse_stmt_sequence()?;
            Ok(Expr::Let(
                "_".to_string(),
                None,
                Box::new(first),
                Box::new(rest),
            ))
        } else if first_is_block_form && !self.at_sequence_end() {
            // No `;`, but a block-form statement is followed by more statements
            // — e.g. `kalau c { pulang x; }` (a guard) then further statements.
            // Sequence `first` (its value discarded) before the rest.
            let rest = self.parse_stmt_sequence()?;
            Ok(Expr::Let(
                "_".to_string(),
                None,
                Box::new(first),
                Box::new(rest),
            ))
        } else {
            Ok(first)
        }
    }

    /// True when the next token ends a statement sequence — a block close `}`
    /// or end of input. Used to allow a trailing `;` after the final statement.
    fn at_sequence_end(&mut self) -> bool {
        matches!(
            self.peek().map(|t| &t.kind),
            Some(TokenKind::RBrace) | Some(TokenKind::Eof) | None
        )
    }

    /// Skip a `<...>` generic argument list (the leading `<` is still on the
    /// input). Tracks `<`/`>` nesting so e.g. `Map<K, List<V>>` is consumed
    /// fully. Used for unknown nominal types where generics carry no semantics
    /// yet. `Shr` (`>>`) closes two levels at once.
    fn skip_type_argument_list(&mut self) {
        // A pending `>` (left over from a `>>` split by an enclosing generic's
        // close) accounts for this list's opening `<` having no real `<` token —
        // but here we always require a real `<`, so just clear any stale pending
        // first via the normal close path rather than special-casing it.
        if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Lt)) {
            return;
        }
        self.next(); // consume opening `<`
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
                Some(TokenKind::Shr) => {
                    self.next();
                    if depth >= 2 {
                        // `>>` closes two levels that both belong to this list.
                        depth -= 2;
                    } else {
                        // Only one level remains here; the second `>` belongs to
                        // an enclosing generic — leave it pending so nested types
                        // like `Peta<.., ..>>>` don't over-consume the outer `>`s.
                        depth -= 1;
                        self.pending_gt = true;
                    }
                }
                None => break,
                _ => {
                    self.next();
                }
            }
        }
    }

    /// Skip tokens up to and including the `}` that closes an already-consumed
    /// opening `{`. Tracks nesting so inner braces don't end the skip early.
    fn skip_balanced_braces(&mut self) {
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
                None => break,
                _ => {
                    self.next();
                }
            }
        }
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
            Some(TokenKind::Identifier(_)) => {
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
            let field = self.parse_ident()?;
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
            Err(ParseError {
                kind: ParseErrorKind::UnexpectedEof,
                span: self.current_span,
            })
        }
    }

    fn parse_control_flow(&mut self) -> Result<Expr, ParseError> {
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
            // CAHAYA Phase J5 block forms
            Some(TokenKind::KwDisplay) => self.parse_display(),
            Some(TokenKind::KwRow) => self.parse_row(),
            Some(TokenKind::KwColumn) => self.parse_column(),
            Some(TokenKind::KwStyle) => self.parse_style_decl(),
            _ => self.parse_pipe(),
        }
    }

    /// Parse for-in loop:
    ///   untuk x dalam iter { body }
    /// Desugars to: map (fn(x: Any) body) iter
    fn parse_for_in(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwFor)?;
        let var = self.parse_ident()?;
        self.consume(TokenKind::KwIn)?;
        let iter = self.parse_pipe()?;
        self.consume(TokenKind::LBrace)?;
        let body = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;
        // Desugar: untuk x dalam list { body } → map(fn(x: Any) body, list)
        let lam = Expr::Lam(var, Ty::Any, Box::new(body));
        Ok(Expr::App(
            Box::new(Expr::App(Box::new(Expr::Var("map".into())), Box::new(lam))),
            Box::new(iter),
        ))
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
        let body = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;
        // Desugar: selagi cond { body } → if cond { body; () } else { () }
        // Full looping requires runtime support; for now emit single-iteration conditional
        Ok(Expr::If(
            Box::new(cond),
            Box::new(Expr::Let(
                "_".to_string(),
                None,
                Box::new(body),
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Unit),
        ))
    }

    /// Parse infinite loop:
    ///   ulang { body }
    /// Desugars to: selagi betul { body }
    fn parse_loop(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwLoop)?;
        self.consume(TokenKind::LBrace)?;
        let body = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;
        // Desugar: ulang { body } → body; () (single iteration for now)
        Ok(Expr::Let(
            "_".to_string(),
            None,
            Box::new(body),
            Box::new(Expr::Unit),
        ))
    }

    /// Parse guard clause:
    ///   'pastikan'|'guard' expr 'lain'|'else' '{' expr '}' ';' expr
    /// Desugars to If(cond, continuation, else_body)
    fn parse_guard(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwGuard)?;
        let cond = self.parse_pipe()?;
        self.consume(TokenKind::KwElse)?;
        self.consume(TokenKind::LBrace)?;
        let else_body = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;
        self.consume(TokenKind::Semi)?;
        let continuation = self.parse_expr()?;
        Ok(Expr::If(
            Box::new(cond),
            Box::new(continuation),
            Box::new(else_body),
        ))
    }

    /// Parse pipe expressions: expr (|> expr)*
    /// a |> f |> g  desugars to  App(g, App(f, a))
    fn parse_pipe(&mut self) -> Result<Expr, ParseError> {
        let mut expr = self.parse_assignment()?;
        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Pipe)) {
            self.consume(TokenKind::Pipe)?;
            let func = self.parse_assignment()?;
            expr = Expr::App(Box::new(func), Box::new(expr));
        }
        Ok(expr)
    }

    fn parse_assignment(&mut self) -> Result<Expr, ParseError> {
        let lhs = self.parse_or()?;
        if let Some(TokenKind::ColonEq) = self.peek().map(|t| &t.kind) {
            self.consume(TokenKind::ColonEq)?;
            let rhs = self.parse_expr()?;
            Ok(Expr::Assign(Box::new(lhs), Box::new(rhs)))
        } else {
            Ok(lhs)
        }
    }

    fn parse_or(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_and()?;
        while let Some(TokenKind::OrOr) = self.peek().map(|t| &t.kind) {
            self.next();
            let right = self.parse_and()?;
            left = Expr::BinOp(BinOp::Or, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_and(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_equality()?;
        while let Some(TokenKind::AndAnd) = self.peek().map(|t| &t.kind) {
            self.next();
            let right = self.parse_equality()?;
            left = Expr::BinOp(BinOp::And, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_equality(&mut self) -> Result<Expr, ParseError> {
        let mut left = self.parse_comparison()?;
        loop {
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
        loop {
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
        loop {
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
        loop {
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
        // Postfix accessors, chained left-to-right:
        //   `e.field`      -> structural FieldAccess
        //   `e.0` / `e.1`  -> Fst / Snd (pairs)
        //   `e[i]`         -> list indexing, desugared to `senarai_dapat((e, i))`
        loop {
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
                _ => break,
            }
        }
        // Check for parenthesized call syntax: f(a, b, c) → App(App(App(f, a), b), c)
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
            // Only treat as call if current expr could be a callee (Var or prior App)
            if matches!(&expr, Expr::Var(_) | Expr::App(_, _)) {
                self.consume(TokenKind::LParen)?;
                if !matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                    let arg = self.parse_control_flow()?;
                    expr = Expr::App(Box::new(expr), Box::new(arg));
                    while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                        self.consume(TokenKind::Comma)?;
                        let arg = self.parse_control_flow()?;
                        expr = Expr::App(Box::new(expr), Box::new(arg));
                    }
                }
                self.consume(TokenKind::RParen)?;
                return Ok(expr);
            }
        }
        loop {
            if self.is_expr_start() {
                let arg = self.parse_unary()?;
                expr = Expr::App(Box::new(expr), Box::new(arg));
            } else {
                break;
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

    fn parse_unary(&mut self) -> Result<Expr, ParseError> {
        let kind = self.peek().map(|t| t.kind.clone());
        match kind {
            Some(TokenKind::Not) => {
                // `!e` is dereference (ML-style), not logical negation.
                self.consume(TokenKind::Not)?;
                let e = self.parse_unary()?;
                Ok(Expr::Deref(Box::new(e)))
            }
            Some(TokenKind::KwNot) => {
                // `bukan e` / `not e` is logical negation, desugared to
                // `kalau e { salah } lain { betul }` (reuses If — no new AST node).
                self.consume(TokenKind::KwNot)?;
                let e = self.parse_unary()?;
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
                let e1 = self.parse_control_flow()?;
                self.consume(TokenKind::KwWith)?;
                let e2 = self.parse_control_flow()?;
                Ok(Expr::Declassify(Box::new(e1), Box::new(e2)))
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
            Some(TokenKind::KwMerge) => self.parse_crdt_merge(),
            Some(TokenKind::KwContentHash) => self.parse_content_hash(),
            Some(TokenKind::KwVerify) => self.parse_content_verify(),
            Some(TokenKind::KwSmartContract) => self.parse_contract_deploy(),
            Some(TokenKind::KwToken) => self.parse_token_transfer(),
            Some(TokenKind::KwZakat) => self.parse_zakat_calculate(),
            // CAHAYA Phase J5 prefix forms
            Some(TokenKind::KwText_) => self.parse_ui_text(),
            Some(TokenKind::KwButton) => self.parse_ui_button(),
            Some(TokenKind::KwColor) => self.parse_ui_color(),
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
            Some(TokenKind::LiteralInt(s, _)) => {
                self.next();
                Ok(Expr::Int(s.parse().unwrap_or(0)))
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
                Ok(Expr::Var(s))
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

                    let is_comma = if let Some(token) = self.peek() {
                        token.kind == TokenKind::Comma
                    } else {
                        false
                    };

                    if is_comma {
                        self.next();
                        let e2 = self.parse_expr()?;
                        self.consume(TokenKind::RParen)?;
                        Ok(Expr::Pair(Box::new(e), Box::new(e2)))
                    } else {
                        self.consume(TokenKind::RParen)?;
                        Ok(e)
                    }
                }
            }
            Some(kind) => Err(ParseError {
                kind: ParseErrorKind::UnexpectedToken(kind),
                span: self.current_span,
            }),
            None => Err(ParseError {
                kind: ParseErrorKind::UnexpectedEof,
                span: self.current_span,
            }),
        }
    }

    // parse_let logic is now inlined in parse_stmt_sequence

    fn parse_if(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwIf)?;
        let cond = self.parse_expr()?;
        self.consume(TokenKind::LBrace)?;
        let then_branch = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;

        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwElse)) {
            self.consume(TokenKind::KwElse)?;
            // `lain kalau ...` (else-if): the else branch is itself an `if`,
            // parsed recursively to chain conditions.
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwIf)) {
                let else_branch = self.parse_if()?;
                return Ok(Expr::If(
                    Box::new(cond),
                    Box::new(then_branch),
                    Box::new(else_branch),
                ));
            }
            self.consume(TokenKind::LBrace)?;
            let else_branch = self.parse_expr()?;
            self.consume(TokenKind::RBrace)?;
            Ok(Expr::If(
                Box::new(cond),
                Box::new(then_branch),
                Box::new(else_branch),
            ))
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
            Ok(Expr::If(
                Box::new(cond),
                Box::new(then_unit),
                Box::new(Expr::Unit),
            ))
        }
    }

    fn parse_lam(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwFn)?;
        self.consume(TokenKind::LParen)?;
        // Parameter list: zero or more `name: Type`, comma-separated. Multiple
        // params curry into nested `Lam`s.
        let params = self.parse_param_list()?;
        self.consume(TokenKind::RParen)?;
        // Optional return-type annotation `-> T` (accepted; inferred, so ignored).
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Arrow)) {
            self.consume(TokenKind::Arrow)?;
            let _ret = self.parse_ty()?;
        }
        // Body: a `{ ... }` block or a bare control-flow expression.
        let body = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LBrace)) {
            self.consume(TokenKind::LBrace)?;
            let b = self.parse_stmt_sequence()?;
            self.consume(TokenKind::RBrace)?;
            b
        } else {
            self.parse_control_flow()?
        };
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
    fn parse_pattern(&mut self) -> Result<Pattern, ParseError> {
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
            // Literal patterns.
            Some(TokenKind::LiteralInt(s, _)) => {
                self.next();
                Ok(Pattern::Int(s.parse().unwrap_or(0)))
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
                if is_ctor && matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
                    let inner = self.parse_ctor_payload()?;
                    // Named enum constructors map onto the right injection of the
                    // structural sum (the error/secondary case), mirroring how
                    // `Err`/`Ralat` desugar. This is a pragmatic structural
                    // encoding; nominal multi-variant enums are future work.
                    Ok(Pattern::CtorRight(inner))
                } else if is_ctor {
                    // Nullary constructor used as a tag (e.g. `Tertutup`): match
                    // it as the right injection ignoring any payload.
                    Ok(Pattern::CtorRight(Box::new(Pattern::Wildcard)))
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
            // Constructor patterns are not handled by the If-chain compiler
            // (compile_match routes pure-constructor matches to Case). If one
            // appears in a mixed match, treat it as an always-true catch-all
            // binding nothing, so it at least does not crash compilation.
            Pattern::CtorLeft(_) | Pattern::CtorRight(_) => (None, Vec::new()),
        }
    }

    /// Generate a fresh, source-illegal variable name (contains `$`) to avoid
    /// capturing user identifiers in desugared bindings.
    fn fresh_var(&mut self, hint: &str) -> Ident {
        let id = self.gensym;
        self.gensym += 1;
        format!("${hint}{id}")
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

    /// Parse an optional trailing `kesan <eff>` effect annotation on a function
    /// type (e.g. `Fn(A) -> B kesan Tulis`). Defaults to `Effect::Pure`.
    fn parse_optional_fn_effect(&mut self) -> Result<Effect, ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::KwEffect)) {
            self.consume(TokenKind::KwEffect)?;
            self.parse_effect_annotation()
        } else {
            Ok(Effect::Pure)
        }
    }

    fn parse_ty(&mut self) -> Result<Ty, ParseError> {
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
                    "Bool" | "Benar" => Ok(Ty::Bool),
                    "Unit" => Ok(Ty::Unit),
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
                    //   Fn(Param) -> Ret            (Rust-style arrow; 0+ params)
                    //   Fn(ParamTy, RetTy [, Eff])  (legacy comma form)
                    // The AST `Ty::Fn` is single-argument; for multiple params the
                    // first is kept as the representative argument type (the type
                    // layer is not yet fully curried), and an empty `Fn()` uses
                    // Unit as the argument type.
                    "Fn" | "fungsi" => {
                        self.consume(TokenKind::LParen)?;

                        // Empty parameter list `Fn()` (arrow form only, e.g.
                        // `Fn() -> T`); the argument type defaults to Unit.
                        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                            self.consume(TokenKind::RParen)?;
                            self.consume(TokenKind::Arrow)?;
                            let ret_ty = self.parse_ty()?;
                            let eff = self.parse_optional_fn_effect()?;
                            return Ok(Ty::Fn(Box::new(Ty::Unit), Box::new(ret_ty), eff));
                        }

                        let param_ty = self.parse_ty()?;

                        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                            // Legacy comma form: Fn(ParamTy, RetTy [, Effect]).
                            self.consume(TokenKind::Comma)?;
                            let ret_ty = self.parse_ty()?;
                            let eff =
                                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                                    self.consume(TokenKind::Comma)?;
                                    self.parse_effect()?
                                } else {
                                    Effect::Pure
                                };
                            self.consume(TokenKind::RParen)?;
                            Ok(Ty::Fn(Box::new(param_ty), Box::new(ret_ty), eff))
                        } else {
                            // Arrow form: Fn(ParamTy) -> RetTy [kesan Eff].
                            self.consume(TokenKind::RParen)?;
                            self.consume(TokenKind::Arrow)?;
                            let ret_ty = self.parse_ty()?;
                            let eff = self.parse_optional_fn_effect()?;
                            Ok(Ty::Fn(Box::new(param_ty), Box::new(ret_ty), eff))
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
                    // User-defined nominal type (e.g. a `jenis`-declared record
                    // like `JejakAudit`, `Taint`, or a generic `Keupayaan<HakBaca>`).
                    // RIINA has no nominal-type semantics yet (matching the `jenis`
                    // skip in top-level parsing), so an unknown type name is treated
                    // structurally as `Any`. Any `<...>` generic argument list is
                    // consumed (and discarded) so it parses.
                    _ => {
                        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Lt)) {
                            self.skip_type_argument_list();
                        }
                        Ok(Ty::Any)
                    }
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
    fn parse_effect_annotation(&mut self) -> Result<Effect, ParseError> {
        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::LParen)) {
            self.consume(TokenKind::LParen)?;
            if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RParen)) {
                self.consume(TokenKind::RParen)?;
                return Ok(Effect::Pure);
            }
            // A parenthesized effect set may be separated by `,` or `|`
            // (`kesan (Bersih | SistemFail)`); both denote the joined effect.
            let mut eff = self.parse_effect()?;
            while matches!(
                self.peek().map(|t| &t.kind),
                Some(TokenKind::Comma) | Some(TokenKind::Or)
            ) {
                self.next();
                eff = eff.join(self.parse_effect()?);
            }
            self.consume(TokenKind::RParen)?;
            Ok(eff)
        } else {
            self.parse_effect()
        }
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
    fn parse_session_type(&mut self) -> Result<SessionType, ParseError> {
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
        let protocol = self.parse_choreography_protocol()?;
        self.consume(TokenKind::RBrace)?;
        Ok(TopLevelDecl::Expr(Box::new(Expr::ChoreographyBlock {
            name,
            roles,
            protocol,
        })))
    }

    /// Parse choreography interaction sequence into a SessionType.
    fn parse_choreography_protocol(&mut self) -> Result<SessionType, ParseError> {
        match self.peek().map(|t| &t.kind) {
            // tamat; → End
            Some(TokenKind::KwEnd) => {
                self.consume(TokenKind::KwEnd)?;
                self.consume(TokenKind::Semi)?;
                Ok(SessionType::End)
            }
            // pilih { Label -> { ... }, Label -> { ... } }
            Some(TokenKind::KwSelect) => {
                self.consume(TokenKind::KwSelect)?;
                self.consume(TokenKind::LBrace)?;
                let _label1 = self.parse_ident()?;
                self.consume(TokenKind::Arrow)?;
                self.consume(TokenKind::LBrace)?;
                let s1 = self.parse_choreography_protocol()?;
                self.consume(TokenKind::RBrace)?;
                self.consume(TokenKind::Comma)?;
                let _label2 = self.parse_ident()?;
                self.consume(TokenKind::Arrow)?;
                self.consume(TokenKind::LBrace)?;
                let s2 = self.parse_choreography_protocol()?;
                self.consume(TokenKind::RBrace)?;
                self.consume(TokenKind::RBrace)?;
                // Check for continuation after choice block
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace)) {
                    // End of enclosing block, no continuation
                    Ok(SessionType::Select(Box::new(s1), Box::new(s2)))
                } else {
                    // There is a continuation (e.g. tamat;)
                    let _cont = self.parse_choreography_protocol()?;
                    Ok(SessionType::Select(Box::new(s1), Box::new(s2)))
                }
            }
            // RBrace → implicit end (closing an enclosing block)
            Some(TokenKind::RBrace) => Ok(SessionType::End),
            // Identifier: role -> role: hantar Type; continuation
            Some(TokenKind::Identifier(_)) => {
                let _sender = self.parse_ident()?;
                self.consume(TokenKind::Arrow)?;
                let _receiver = self.parse_ident()?;
                self.consume(TokenKind::Colon)?;
                self.consume(TokenKind::KwSend)?;
                let msg_ident = self.parse_ident()?;
                self.consume(TokenKind::Semi)?;
                let msg_ty = self.ident_to_ty(&msg_ident);
                let continuation = self.parse_choreography_protocol()?;
                Ok(SessionType::Send(Box::new(msg_ty), Box::new(continuation)))
            }
            _ => Err(ParseError {
                kind: ParseErrorKind::ExpectedExpression,
                span: self.current_span,
            }),
        }
    }

    /// Map an identifier to a Ty for choreography message types.
    fn ident_to_ty(&self, ident: &str) -> Ty {
        match ident {
            "Nombor" | "Int" => Ty::Int,
            "Benar" | "Bool" => Ty::Bool,
            "Teks" | "String" => Ty::String,
            "Unit" => Ty::Unit,
            _ => Ty::Any,
        }
    }

    /// Parse: pelakon Name { keadaan: Type kendalikan Msg(param) { body } ... }
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
            // Multiple handlers: chain as nested Let bindings of lambdas
            let mut result = Expr::Unit;
            for (_msg, param, body) in handlers.into_iter().rev() {
                let lam = Expr::Lam(param, Ty::Any, Box::new(body));
                result = Expr::Let(
                    "_handler".to_string(),
                    None,
                    Box::new(lam),
                    Box::new(result),
                );
            }
            result
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
