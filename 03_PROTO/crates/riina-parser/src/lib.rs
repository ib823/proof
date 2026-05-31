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
}

impl<'a> Parser<'a> {
    pub fn new(source: &'a str) -> Self {
        Self {
            lexer: LexerIter {
                lexer: Lexer::new(source),
            }
            .peekable(),
            current_span: Span { start: 0, end: 0 },
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

    fn parse_top_level_decl(&mut self) -> Result<TopLevelDecl, ParseError> {
        match self.peek().map(|t| &t.kind) {
            Some(TokenKind::KwMod) => {
                // modul name; — skip (no module system yet)
                self.consume(TokenKind::KwMod)?;
                let _name = self.parse_ident()?;
                self.consume(TokenKind::Semi)?;
                self.parse_top_level_decl()
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
        let name = self.parse_ident()?;
        self.consume(TokenKind::LParen)?;
        let params = self.parse_param_list()?;
        self.consume(TokenKind::RParen)?;

        // Optional return type
        let return_ty = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Arrow)) {
            self.consume(TokenKind::Arrow)?;
            self.parse_ty()?
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
        } else {
            Ok(first)
        }
    }

    /// True when the next token ends a statement sequence — a block close `}`
    /// or end of input. Used to allow a trailing `;` after the final statement.
    fn at_sequence_end(&mut self) -> bool {
        matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace) | None)
    }

    /// Skip a `<...>` generic argument list (the leading `<` is still on the
    /// input). Tracks `<`/`>` nesting so e.g. `Map<K, List<V>>` is consumed
    /// fully. Used for unknown nominal types where generics carry no semantics
    /// yet. `Shr` (`>>`) closes two levels at once.
    fn skip_type_argument_list(&mut self) {
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
                    // `>>` closes two angle-bracket levels.
                    self.next();
                    depth = depth.saturating_sub(2);
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
                // pulang expr — return is identity (desugars to just the expression)
                self.parse_pipe()
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
        // Postfix field/tuple access: `e.field`, or `e.0`/`e.1` for pairs.
        // `.0` desugars to `pertama`/fst, `.1` to `kedua`/snd; any other field
        // name becomes a structural FieldAccess. Chains left-to-right.
        while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Dot)) {
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
                self.consume(TokenKind::Not)?;
                let e = self.parse_unary()?;
                Ok(Expr::Deref(Box::new(e)))
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
        let e2 = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;
        self.consume(TokenKind::KwElse)?;
        self.consume(TokenKind::LBrace)?;
        let e3 = self.parse_expr()?;
        self.consume(TokenKind::RBrace)?;
        Ok(Expr::If(Box::new(cond), Box::new(e2), Box::new(e3)))
    }

    fn parse_lam(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwFn)?;
        self.consume(TokenKind::LParen)?;
        let name = self.parse_ident()?;
        self.consume(TokenKind::Colon)?;
        let ty = self.parse_ty()?;
        self.consume(TokenKind::RParen)?;
        let body = self.parse_control_flow()?;
        Ok(Expr::Lam(name, ty, Box::new(body)))
    }

    fn parse_match(&mut self) -> Result<Expr, ParseError> {
        self.consume(TokenKind::KwMatch)?;
        let scrutinee = self.parse_pipe()?;
        self.consume(TokenKind::LBrace)?;

        // Dispatch: inl/inr → sum match, otherwise → literal match
        match self.peek().map(|t| &t.kind) {
            Some(TokenKind::KwInl) => {
                self.consume(TokenKind::KwInl)?;
                let x = self.parse_ident()?;
                self.consume(TokenKind::FatArrow)?;
                let e1 = self.parse_expr()?;
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                    self.next();
                }
                self.consume(TokenKind::KwInr)?;
                let y = self.parse_ident()?;
                self.consume(TokenKind::FatArrow)?;
                let e2 = self.parse_expr()?;
                if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                    self.next();
                }
                self.consume(TokenKind::RBrace)?;
                Ok(Expr::Case(
                    Box::new(scrutinee),
                    x,
                    Box::new(e1),
                    y,
                    Box::new(e2),
                ))
            }
            _ => {
                // Literal match: desugar to nested if-else
                let mut arms = Vec::new();
                let mut default = None;
                loop {
                    if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::RBrace) | None) {
                        break;
                    }
                    // Wildcard _
                    if matches!(self.peek().map(|t| t.kind.clone()), Some(TokenKind::Identifier(ref s)) if s == "_")
                    {
                        self.next();
                        self.consume(TokenKind::FatArrow)?;
                        default = Some(self.parse_pipe()?);
                        if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                            self.next();
                        }
                        break;
                    }
                    let pattern = self.parse_atom()?;
                    self.consume(TokenKind::FatArrow)?;
                    let body = self.parse_pipe()?;
                    arms.push((pattern, body));
                    if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                        self.next();
                    }
                }
                self.consume(TokenKind::RBrace)?;
                let fallback = default.unwrap_or(Expr::Unit);
                let result = arms
                    .into_iter()
                    .rev()
                    .fold(fallback, |else_branch, (pat, body)| {
                        Expr::If(
                            Box::new(Expr::BinOp(
                                BinOp::Eq,
                                Box::new(scrutinee.clone()),
                                Box::new(pat),
                            )),
                            Box::new(body),
                            Box::new(else_branch),
                        )
                    });
                Ok(result)
            }
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
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::List(Box::new(inner)))
                    }
                    "Option" | "Mungkin" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Option(Box::new(inner)))
                    }
                    "Secret" | "Rahsia" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Secret(Box::new(inner)))
                    }
                    "Proof" | "Bukti" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Proof(Box::new(inner)))
                    }
                    "ConstantTime" | "MasaTetap" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::ConstantTime(Box::new(inner)))
                    }
                    "Zeroizing" | "Sifar" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Zeroizing(Box::new(inner)))
                    }
                    // Ref<T>@level
                    "Ref" | "Ruj" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
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
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Sum(Box::new(t1), Box::new(t2)))
                    }
                    // Function type: Fn(T1, T2) or Fn(T1, T2, Effect)
                    "Fn" => {
                        self.consume(TokenKind::LParen)?;
                        let param_ty = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let ret_ty = self.parse_ty()?;
                        // Optional effect as third argument
                        let eff = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma))
                        {
                            self.consume(TokenKind::Comma)?;
                            self.parse_effect()?
                        } else {
                            Effect::Pure
                        };
                        self.consume(TokenKind::RParen)?;
                        Ok(Ty::Fn(Box::new(param_ty), Box::new(ret_ty), eff))
                    }
                    // Labeled<T, Level> / Berlabel<T, Level>
                    "Labeled" | "Berlabel" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let level = self.parse_security_level()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Labeled(Box::new(inner), level))
                    }
                    // Tainted<T, Source> / Tercemar<T, Source>
                    "Tainted" | "Tercemar" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let source = self.parse_taint_source()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Tainted(Box::new(inner), source))
                    }
                    // Sanitized<T, Sanitizer> / Disanitasi<T, Sanitizer>
                    "Sanitized" | "Disanitasi" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Comma)?;
                        let san = self.parse_sanitizer()?;
                        self.consume(TokenKind::Gt)?;
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
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Capability(kind))
                    }
                    // Chan<SessionType> / Saluran<SessionType>
                    "Chan" | "Saluran" => {
                        self.consume(TokenKind::Lt)?;
                        let st = self.parse_session_type()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Chan(st))
                    }
                    // SecureChan<SessionType, Level> / SaluranSelamat<SessionType, Level>
                    "SecureChan" | "SaluranSelamat" => {
                        self.consume(TokenKind::Lt)?;
                        let st = self.parse_session_type()?;
                        self.consume(TokenKind::Comma)?;
                        let level = self.parse_security_level()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::SecureChan(st, level))
                    }
                    "SmartContract" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::SmartContract(Box::new(inner)))
                    }
                    "Token" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
                        Ok(Ty::Token(Box::new(inner)))
                    }
                    "SyariahCompliant" => {
                        self.consume(TokenKind::Lt)?;
                        let inner = self.parse_ty()?;
                        self.consume(TokenKind::Gt)?;
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
                self.consume(TokenKind::Gt)?;
                Ok(Ty::SmartContract(Box::new(inner)))
            }
            Some(TokenKind::KwToken) => {
                self.next();
                self.consume(TokenKind::Lt)?;
                let inner = self.parse_ty()?;
                self.consume(TokenKind::Gt)?;
                Ok(Ty::Token(Box::new(inner)))
            }
            Some(TokenKind::KwShariahCompliant) => {
                self.next();
                self.consume(TokenKind::Lt)?;
                let inner = self.parse_ty()?;
                self.consume(TokenKind::Gt)?;
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
            let mut eff = self.parse_effect()?;
            while matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Comma)) {
                self.consume(TokenKind::Comma)?;
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
                self.consume(TokenKind::Gt)?;
                Ok(SessionType::Send(Box::new(payload), Box::new(cont)))
            }
            // Recv<PayloadType, Continuation>
            "Recv" | "Terima" => {
                self.consume(TokenKind::Lt)?;
                let payload = self.parse_ty()?;
                self.consume(TokenKind::Comma)?;
                let cont = self.parse_session_type()?;
                self.consume(TokenKind::Gt)?;
                Ok(SessionType::Recv(Box::new(payload), Box::new(cont)))
            }
            // Select<S1, S2> — internal choice
            "Select" | "Pilih" => {
                self.consume(TokenKind::Lt)?;
                let s1 = self.parse_session_type()?;
                self.consume(TokenKind::Comma)?;
                let s2 = self.parse_session_type()?;
                self.consume(TokenKind::Gt)?;
                Ok(SessionType::Select(Box::new(s1), Box::new(s2)))
            }
            // Branch<S1, S2> — external choice
            "Branch" | "Cabang" => {
                self.consume(TokenKind::Lt)?;
                let s1 = self.parse_session_type()?;
                self.consume(TokenKind::Comma)?;
                let s2 = self.parse_session_type()?;
                self.consume(TokenKind::Gt)?;
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
                self.consume(TokenKind::Gt)?;
                Ok(SessionType::Rec(var, Box::new(body)))
            }
            // Var<X> — session type variable (for recursion)
            "SVar" | "PembolehubahSesi" => {
                self.consume(TokenKind::Lt)?;
                let var = self.parse_ident()?;
                self.consume(TokenKind::Gt)?;
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
