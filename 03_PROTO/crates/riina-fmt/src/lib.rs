// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Formatter
//!
//! Pretty-prints RIINA ASTs with consistent style.
//! RIINA = Rigorous Immutable Invariant, No Assumptions

#![forbid(unsafe_code)]

use riina_types::{
    BinOp, Capability, CapabilityKind, Effect, EffectSet, Expr, Program, Sanitizer,
    SecurityLevel, SessionType, TaintSource, TopLevelDecl, Ty,
};

/// Formatter configuration.
pub struct FmtConfig {
    pub indent: usize,
    pub max_width: usize,
}

impl Default for FmtConfig {
    fn default() -> Self {
        Self {
            indent: 4,
            max_width: 100,
        }
    }
}

/// Format a RIINA program from source text.
///
/// FAILS CLOSED. The formatter pretty-prints the parsed AST, so it can only be
/// trusted when its output means exactly what its input meant. Every result is
/// therefore re-parsed and compared with the input's AST, and `Err` is returned
/// — never a changed program — when:
///
/// * the output does not parse, or parses to a different program (the
///   2026-10-19 assessment found `(2 + 3) * 4` printed as `2 + 3 * 4`, and
///   actor/UI code replaced by a `/* … */` placeholder);
/// * the source contains comments, which the AST does not carry and the
///   output would silently drop;
/// * formatting does not reach a fixpoint (formatting the output again must
///   give the output back).
pub fn format_source(source: &str) -> Result<String, String> {
    let original = parse(source).map_err(|e| format!("Parse error: {e}"))?;
    if has_comments(source) {
        return Err("refusing to format: the file contains comments, which the formatter \
                    cannot yet preserve (it would delete them)"
            .to_string());
    }
    let cfg = FmtConfig::default();
    let formatted = format_program(&original, &cfg);
    let reparsed = parse(&formatted).map_err(|e| {
        format!("refusing to format: the formatter produced output that does not parse ({e})")
    })?;
    if !same_program(&original, &reparsed) {
        return Err("refusing to format: the formatted output would parse to a different \
                    program than the input (formatter bug — the file is left unchanged)"
            .to_string());
    }
    if format_program(&reparsed, &cfg) != formatted {
        return Err("refusing to format: formatting is not stable on this file \
                    (formatting the output again changes it)"
            .to_string());
    }
    Ok(formatted)
}

fn parse(source: &str) -> Result<Program, riina_parser::ParseError> {
    riina_parser::Parser::new(source).parse_program()
}

/// The two programs denote the same thing: identical declarations, imports
/// and visibility. Spans are ignored — they are byte offsets into the text
/// being rewritten — and so is the ORDER of a compound effect's components
/// (`kesan (Masa, SistemFail)` is a set; the printer lists it canonically).
/// Nothing else is normalised.
fn same_program(a: &Program, b: &Program) -> bool {
    canonical_decls(a) == canonical_decls(b)
        && a.public_names == b.public_names
        && a.imports.len() == b.imports.len()
        && a.imports
            .iter()
            .zip(&b.imports)
            .all(|(x, y)| x.module == y.module)
}

fn canonical_decls(p: &Program) -> Vec<TopLevelDecl> {
    p.decls
        .iter()
        .cloned()
        .map(|mut d| {
            if let TopLevelDecl::Function {
                effect, effect_set, ..
            } = &mut d
            {
                *effect_set = EffectSet::from_declaration(*effect, effect_set)
                    .iter()
                    .collect();
            }
            d
        })
        .collect()
}

/// Whether `source` holds a comment: any non-whitespace byte that no token
/// covers. The lexer skips comments without producing tokens, so a gap between
/// tokens that is not pure whitespace is exactly a comment (or anything else
/// the token stream — and so the AST — would lose).
fn has_comments(source: &str) -> bool {
    let mut lexer = riina_lexer::Lexer::new(source);
    let mut covered_to = 0usize;
    loop {
        match lexer.next_token() {
            Ok(tok) if tok.kind == riina_lexer::TokenKind::Eof => break,
            Ok(tok) => {
                // `get` rather than indexing: a span that is not a char
                // boundary means "cannot prove there is no comment".
                match source.get(covered_to.min(tok.span.start)..tok.span.start) {
                    Some(gap) if gap.chars().all(char::is_whitespace) => {}
                    _ => return true,
                }
                covered_to = covered_to.max(tok.span.end);
            }
            // The parser accepted the source, so this is unreachable; treat it
            // as "cannot prove there are no comments".
            Err(_) => return true,
        }
    }
    source
        .get(covered_to..)
        .is_none_or(|rest| rest.chars().any(|c| !c.is_whitespace()))
}

/// Render a type to its RIINA (Bahasa Melayu) surface form — e.g. `Ty::String`
/// → `Teks`, `Ty::Fn(a, b, eff)` → `Fn(a, b, eff)`. The canonical type renderer,
/// reused by tooling (e.g. the stdlib API-doc generator) so rendered signatures
/// match what the formatter prints.
pub fn format_ty(ty: &Ty) -> String {
    let mut out = String::new();
    fmt_ty(&mut out, ty);
    out
}

/// Format a parsed Program to a string.
pub fn format_program(program: &Program, cfg: &FmtConfig) -> String {
    let mut out = String::new();
    for (i, decl) in program.decls.iter().enumerate() {
        if i > 0 {
            out.push('\n');
        }
        fmt_decl(&mut out, decl, 0, cfg);
        out.push('\n');
    }
    out
}

fn indent(out: &mut String, level: usize, cfg: &FmtConfig) {
    for _ in 0..level * cfg.indent {
        out.push(' ');
    }
}

fn fmt_decl(out: &mut String, decl: &TopLevelDecl, level: usize, cfg: &FmtConfig) {
    match decl {
        TopLevelDecl::Function {
            name,
            params,
            return_ty,
            effect,
            effect_set,
            body,
        } => {
            indent(out, level, cfg);
            out.push_str("fungsi ");
            out.push_str(name);
            out.push('(');
            for (i, (pname, pty)) in params.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                out.push_str(pname);
                out.push_str(": ");
                fmt_ty(out, pty);
            }
            out.push(')');
            if *return_ty != Ty::Unit {
                out.push_str(" -> ");
                fmt_ty(out, return_ty);
            }
            // Print the whole declared SET: printing only the lossy lattice
            // join would turn `kesan (Masa, SistemFail)` into `kesan Masa`,
            // which no longer covers the file write (M1c).
            let declared = EffectSet::from_declaration(*effect, effect_set);
            if !declared.is_pure() {
                out.push_str(" kesan ");
                fmt_effect_set(out, declared);
            }
            out.push_str(" {\n");
            fmt_expr(out, body, level + 1, cfg);
            out.push('\n');
            indent(out, level, cfg);
            out.push('}');
        }
        TopLevelDecl::Binding {
            name,
            value,
            is_mut,
        } => {
            indent(out, level, cfg);
            out.push_str(if *is_mut { "biar ubah " } else { "biar " });
            out.push_str(name);
            out.push_str(" = ");
            fmt_expr(out, value, level, cfg);
            out.push(';');
        }
        TopLevelDecl::Expr(e) => {
            indent(out, level, cfg);
            fmt_expr(out, e, level, cfg);
        }
        TopLevelDecl::Test { name, body } => {
            indent(out, level, cfg);
            out.push_str("ujian \"");
            out.push_str(name);
            out.push_str("\" {\n");
            fmt_expr(out, body, level + 1, cfg);
            out.push('\n');
            indent(out, level, cfg);
            out.push('}');
        }
        TopLevelDecl::ExternBlock { abi, decls } => {
            indent(out, level, cfg);
            out.push_str("luaran \"");
            out.push_str(abi);
            out.push_str("\" {\n");
            for decl in decls {
                indent(out, level + 1, cfg);
                out.push_str("fungsi ");
                out.push_str(&decl.name);
                out.push('(');
                for (i, (pname, pty)) in decl.params.iter().enumerate() {
                    if i > 0 {
                        out.push_str(", ");
                    }
                    out.push_str(pname);
                    out.push_str(": ");
                    fmt_ty(out, pty);
                }
                out.push(')');
                if decl.ret_ty != Ty::Unit {
                    out.push_str(" -> ");
                    fmt_ty(out, &decl.ret_ty);
                }
                if decl.effect != Effect::Pure {
                    out.push_str(" kesan ");
                    fmt_effect(out, &decl.effect);
                }
                out.push_str(";\n");
            }
            indent(out, level, cfg);
            out.push('}');
        }
    }
}

/// Format a record literal `Name { field: value, ... }` inline.
fn fmt_record_inline(out: &mut String, name: &str, fields: &[(String, Expr)], cfg: &FmtConfig) {
    out.push_str(name);
    out.push_str(" { ");
    for (i, (field, value)) in fields.iter().enumerate() {
        if i > 0 {
            out.push_str(", ");
        }
        out.push_str(field);
        out.push_str(": ");
        fmt_expr_inline(out, value, cfg);
    }
    out.push_str(" }");
}

/// Reconstruct the width suffix for a sized integer literal (`Expr::IntN`), e.g.
/// `(8, false)` ⇒ `"u8"`, `(32, true)` ⇒ `"i32"`, so formatting round-trips the
/// source token.
fn int_width_suffix(bits: u8, signed: bool) -> String {
    format!("{}{bits}", if signed { "i" } else { "u" })
}

fn fmt_expr(out: &mut String, expr: &Expr, level: usize, cfg: &FmtConfig) {
    match expr {
        Expr::Unit => {
            indent(out, level, cfg);
            out.push_str("()");
        }
        Expr::Bool(b) => {
            indent(out, level, cfg);
            out.push_str(if *b { "betul" } else { "salah" });
        }
        Expr::Int(n) => {
            indent(out, level, cfg);
            out.push_str(&n.to_string());
        }
        Expr::IntN {
            value,
            bits,
            signed,
        } => {
            indent(out, level, cfg);
            out.push_str(&format!("{value}{}", int_width_suffix(*bits, *signed)));
        }
        Expr::String(s) => {
            indent(out, level, cfg);
            out.push('"');
            // Escape special chars
            for c in s.chars() {
                match c {
                    '"' => out.push_str("\\\""),
                    '\\' => out.push_str("\\\\"),
                    '\n' => out.push_str("\\n"),
                    '\t' => out.push_str("\\t"),
                    '\r' => out.push_str("\\r"),
                    c => out.push(c),
                }
            }
            out.push('"');
        }
        Expr::Var(name) => {
            indent(out, level, cfg);
            out.push_str(name);
        }
        Expr::Lam(param, ty, body) => {
            indent(out, level, cfg);
            fmt_lam(out, param, ty, body, cfg);
        }
        Expr::App(func, arg) => {
            indent(out, level, cfg);
            fmt_expr_inline(out, func, cfg);
            out.push('(');
            fmt_expr_inline(out, arg, cfg);
            out.push(')');
        }
        Expr::Pair(a, b) => {
            indent(out, level, cfg);
            out.push('(');
            fmt_expr_inline(out, a, cfg);
            out.push_str(", ");
            fmt_expr_inline(out, b, cfg);
            out.push(')');
        }
        Expr::ListLit(elems) => {
            indent(out, level, cfg);
            out.push('[');
            for (i, e) in elems.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                fmt_expr_inline(out, e, cfg);
            }
            out.push(']');
        }
        Expr::RecordLit(name, fields) => {
            indent(out, level, cfg);
            fmt_record_inline(out, name, fields, cfg);
        }
        Expr::FieldAccess(base, field) => {
            indent(out, level, cfg);
            fmt_expr_inline(out, base, cfg);
            out.push('.');
            out.push_str(field);
        }
        Expr::Fst(e) => {
            indent(out, level, cfg);
            out.push_str("pertama ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Snd(e) => {
            indent(out, level, cfg);
            out.push_str("kedua ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Inl(e, ty) => {
            indent(out, level, cfg);
            out.push_str("inl ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(": ");
            fmt_ty(out, ty);
        }
        Expr::Inr(e, ty) => {
            indent(out, level, cfg);
            out.push_str("inr ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(": ");
            fmt_ty(out, ty);
        }
        Expr::Case(scrutinee, x, e1, y, e2) => {
            indent(out, level, cfg);
            out.push_str("padan ");
            fmt_expr_inline(out, scrutinee, cfg);
            out.push_str(" {\n");
            indent(out, level + 1, cfg);
            out.push_str("inl ");
            out.push_str(x);
            out.push_str(" => ");
            fmt_expr_inline(out, e1, cfg);
            out.push_str(",\n");
            indent(out, level + 1, cfg);
            out.push_str("inr ");
            out.push_str(y);
            out.push_str(" => ");
            fmt_expr_inline(out, e2, cfg);
            out.push_str(",\n");
            indent(out, level, cfg);
            out.push('}');
        }
        Expr::If(cond, then_br, else_br) => {
            indent(out, level, cfg);
            out.push_str("kalau ");
            fmt_expr_inline(out, cond, cfg);
            out.push_str(" {\n");
            fmt_expr(out, then_br, level + 1, cfg);
            out.push('\n');
            indent(out, level, cfg);
            out.push_str("} lain {\n");
            fmt_expr(out, else_br, level + 1, cfg);
            out.push('\n');
            indent(out, level, cfg);
            out.push('}');
        }
        Expr::While(cond, body) => {
            indent(out, level, cfg);
            out.push_str("selagi ");
            fmt_expr_inline(out, cond, cfg);
            out.push_str(" {\n");
            fmt_expr(out, body, level + 1, cfg);
            out.push('\n');
            indent(out, level, cfg);
            out.push('}');
        }
        Expr::Break => {
            indent(out, level, cfg);
            out.push_str("putus");
        }
        Expr::Continue => {
            indent(out, level, cfg);
            out.push_str("lanjut");
        }
        Expr::SlotGet(name) => {
            indent(out, level, cfg);
            out.push_str(name);
        }
        Expr::SlotSet(name, value) => {
            indent(out, level, cfg);
            out.push_str(name);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
        }
        Expr::LetMut(name, value, body) => {
            indent(out, level, cfg);
            out.push_str("biar ubah ");
            out.push_str(name);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
            out.push_str(";\n");
            fmt_expr(out, body, level, cfg);
        }
        Expr::Let(name, _, value, body) => {
            indent(out, level, cfg);
            out.push_str("biar ");
            out.push_str(name);
            let value = fmt_annotation(out, value);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
            out.push_str(";\n");
            fmt_expr(out, body, level, cfg);
        }
        // Only `biar x: T` and a lambda's `-> T` write an annotation, and both
        // are printed above. Anywhere else it has no surface form: printing the
        // expression makes the re-parse differ, so `format_source` refuses.
        Expr::Ascribe(inner, _) => fmt_expr(out, inner, level, cfg),
        Expr::LetRec(name, _ty, value, body) => {
            indent(out, level, cfg);
            out.push_str("biar ulang ");
            out.push_str(name);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
            out.push_str(";\n");
            fmt_expr(out, body, level, cfg);
        }
        Expr::LetRecGroup(bindings, body) => {
            for (name, _ty, value) in bindings {
                indent(out, level, cfg);
                out.push_str("biar ulang ");
                out.push_str(name);
                out.push_str(" = ");
                fmt_expr_inline(out, value, cfg);
                out.push_str(";\n");
            }
            fmt_expr(out, body, level, cfg);
        }
        Expr::Perform(eff, e) => {
            indent(out, level, cfg);
            out.push_str("laku ");
            fmt_effect(out, eff);
            out.push(' ');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Handle(e, x, h) => {
            indent(out, level, cfg);
            out.push_str("kendali ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(" dengan ");
            out.push_str(x);
            out.push_str(" => ");
            fmt_expr_inline(out, h, cfg);
        }
        Expr::Ref(e, lvl) => {
            indent(out, level, cfg);
            out.push_str("ruj ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(" @ ");
            fmt_security_level(out, lvl);
        }
        Expr::Deref(e) => {
            indent(out, level, cfg);
            out.push('!');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Assign(lhs, rhs) => {
            indent(out, level, cfg);
            fmt_expr_inline(out, lhs, cfg);
            out.push_str(" := ");
            fmt_expr_inline(out, rhs, cfg);
        }
        Expr::Classify(e) => {
            indent(out, level, cfg);
            out.push_str("sulit ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Declassify(e, proof) => {
            indent(out, level, cfg);
            out.push_str("dedah ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(" dengan ");
            fmt_expr_inline(out, proof, cfg);
        }
        Expr::Prove(e) => {
            indent(out, level, cfg);
            out.push_str("bukti ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Return(e) => {
            indent(out, level, cfg);
            out.push_str("pulang ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Require(eff, e) => {
            indent(out, level, cfg);
            out.push_str("perlukan ");
            fmt_effect(out, eff);
            out.push(' ');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Grant(eff, e) => {
            indent(out, level, cfg);
            out.push_str("beri ");
            fmt_effect(out, eff);
            out.push(' ');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Loc(n) => {
            indent(out, level, cfg);
            out.push_str(&format!("loc#{n}"));
        }
        Expr::BinOp(op, lhs, rhs) => {
            indent(out, level, cfg);
            fmt_operand(out, lhs, op, false, cfg);
            out.push(' ');
            fmt_binop(out, op);
            out.push(' ');
            fmt_operand(out, rhs, op, true, cfg);
        }
        Expr::FFICall { name, args, .. } => {
            indent(out, level, cfg);
            out.push_str(name);
            out.push('(');
            for (i, arg) in args.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                fmt_expr_inline(out, arg, cfg);
            }
            out.push(')');
        }
        Expr::ActorDecl { .. }
        | Expr::ChoreographyBlock { .. }
        | Expr::Spawn(_, _)
        | Expr::ActorSend(_, _)
        | Expr::ActorRecv(_)
        | Expr::CRDTMerge(_, _)
        | Expr::ContentHash(_)
        | Expr::ContentVerify(_, _) => {
            indent(out, level, cfg);
            out.push_str("/* JALINAN Phase 6: actor/choreography/CRDT */");
        }
        Expr::ContractDeploy(expr) => {
            indent(out, level, cfg);
            out.push_str("kontrak_pintar { ");
            fmt_expr_inline(out, expr, cfg);
            out.push_str(" }");
        }
        Expr::TokenTransfer { from, to, amount } => {
            indent(out, level, cfg);
            out.push_str("token::pindah(");
            fmt_expr_inline(out, from, cfg);
            out.push_str(", ");
            fmt_expr_inline(out, to, cfg);
            out.push_str(", ");
            fmt_expr_inline(out, amount, cfg);
            out.push(')');
        }
        Expr::ZakatCalculate(expr) => {
            indent(out, level, cfg);
            out.push_str("zakat(");
            fmt_expr_inline(out, expr, cfg);
            out.push(')');
        }

        // CAHAYA Phase J5
        Expr::UIDisplay(_)
        | Expr::UIRow(_)
        | Expr::UIColumn(_)
        | Expr::UIText(_, _)
        | Expr::UIButton(_, _)
        | Expr::UIColor(_, _, _)
        | Expr::UIStyleDecl { .. }
        | Expr::UIContrastCheck(_, _) => {
            indent(out, level, cfg);
            out.push_str("/* CAHAYA Phase J5: UI primitives */");
        }
    }
}

/// Format an expression inline (no leading indent).
#[allow(clippy::only_used_in_recursion)]
/// The `: T` of `biar x: T = e`, which the parser keeps as `Ascribe(e, T)`:
/// print it and return `e`. Any other value is returned as it is.
fn fmt_annotation<'e>(out: &mut String, value: &'e Expr) -> &'e Expr {
    match value {
        Expr::Ascribe(inner, ty) => {
            out.push_str(": ");
            fmt_ty(out, ty);
            inner
        }
        other => other,
    }
}

/// `fungsi(x: A) e`, or `fungsi(x: A) -> R { e }` when the body carries the
/// lambda's return annotation as `Ascribe(e, R)`.
fn fmt_lam(out: &mut String, param: &str, ty: &Ty, body: &Expr, cfg: &FmtConfig) {
    out.push_str("fungsi(");
    out.push_str(param);
    out.push_str(": ");
    fmt_ty(out, ty);
    out.push_str(") ");
    if let Expr::Ascribe(inner, ret) = body {
        out.push_str("-> ");
        fmt_ty(out, ret);
        out.push_str(" { ");
        fmt_expr_inline(out, inner, cfg);
        out.push_str(" }");
    } else {
        fmt_expr_inline(out, body, cfg);
    }
}

fn fmt_expr_inline(out: &mut String, expr: &Expr, cfg: &FmtConfig) {
    match expr {
        Expr::Unit => out.push_str("()"),
        Expr::Bool(b) => out.push_str(if *b { "betul" } else { "salah" }),
        Expr::Int(n) => out.push_str(&n.to_string()),
        Expr::IntN {
            value,
            bits,
            signed,
        } => out.push_str(&format!("{value}{}", int_width_suffix(*bits, *signed))),
        Expr::String(s) => {
            out.push('"');
            for c in s.chars() {
                match c {
                    '"' => out.push_str("\\\""),
                    '\\' => out.push_str("\\\\"),
                    '\n' => out.push_str("\\n"),
                    '\t' => out.push_str("\\t"),
                    '\r' => out.push_str("\\r"),
                    c => out.push(c),
                }
            }
            out.push('"');
        }
        Expr::Var(name) => out.push_str(name),
        Expr::Lam(param, ty, body) => fmt_lam(out, param, ty, body, cfg),
        Expr::App(func, arg) => {
            fmt_expr_inline(out, func, cfg);
            out.push('(');
            fmt_expr_inline(out, arg, cfg);
            out.push(')');
        }
        Expr::Pair(a, b) => {
            out.push('(');
            fmt_expr_inline(out, a, cfg);
            out.push_str(", ");
            fmt_expr_inline(out, b, cfg);
            out.push(')');
        }
        Expr::ListLit(elems) => {
            out.push('[');
            for (i, e) in elems.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                fmt_expr_inline(out, e, cfg);
            }
            out.push(']');
        }
        Expr::RecordLit(name, fields) => fmt_record_inline(out, name, fields, cfg),
        Expr::FieldAccess(base, field) => {
            fmt_expr_inline(out, base, cfg);
            out.push('.');
            out.push_str(field);
        }
        Expr::Fst(e) => {
            out.push_str("pertama ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Snd(e) => {
            out.push_str("kedua ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Inl(e, ty) => {
            out.push_str("inl ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(": ");
            fmt_ty(out, ty);
        }
        Expr::Inr(e, ty) => {
            out.push_str("inr ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(": ");
            fmt_ty(out, ty);
        }
        Expr::Case(scrutinee, x, e1, y, e2) => {
            out.push_str("padan ");
            fmt_expr_inline(out, scrutinee, cfg);
            out.push_str(" { inl ");
            out.push_str(x);
            out.push_str(" => ");
            fmt_expr_inline(out, e1, cfg);
            out.push_str(", inr ");
            out.push_str(y);
            out.push_str(" => ");
            fmt_expr_inline(out, e2, cfg);
            out.push_str(" }");
        }
        Expr::If(cond, then_br, else_br) => {
            out.push_str("kalau ");
            fmt_expr_inline(out, cond, cfg);
            out.push_str(" { ");
            fmt_expr_inline(out, then_br, cfg);
            out.push_str(" } lain { ");
            fmt_expr_inline(out, else_br, cfg);
            out.push_str(" }");
        }
        Expr::While(cond, body) => {
            out.push_str("selagi ");
            fmt_expr_inline(out, cond, cfg);
            out.push_str(" { ");
            fmt_expr_inline(out, body, cfg);
            out.push_str(" }");
        }
        Expr::Break => out.push_str("putus"),
        Expr::Continue => out.push_str("lanjut"),
        Expr::SlotGet(name) => out.push_str(name),
        Expr::SlotSet(name, value) => {
            out.push_str(name);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
        }
        Expr::LetMut(name, value, body) => {
            out.push_str("biar ubah ");
            out.push_str(name);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
            out.push_str("; ");
            fmt_expr_inline(out, body, cfg);
        }
        Expr::Let(name, _, value, body) => {
            out.push_str("biar ");
            out.push_str(name);
            let value = fmt_annotation(out, value);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
            out.push_str("; ");
            fmt_expr_inline(out, body, cfg);
        }
        Expr::Ascribe(inner, _) => fmt_expr_inline(out, inner, cfg),
        Expr::LetRec(name, _ty, value, body) => {
            out.push_str("biar ulang ");
            out.push_str(name);
            out.push_str(" = ");
            fmt_expr_inline(out, value, cfg);
            out.push_str("; ");
            fmt_expr_inline(out, body, cfg);
        }
        Expr::LetRecGroup(bindings, body) => {
            for (name, _ty, value) in bindings {
                out.push_str("biar ulang ");
                out.push_str(name);
                out.push_str(" = ");
                fmt_expr_inline(out, value, cfg);
                out.push_str("; ");
            }
            fmt_expr_inline(out, body, cfg);
        }
        Expr::Perform(eff, e) => {
            out.push_str("laku ");
            fmt_effect(out, eff);
            out.push(' ');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Handle(e, x, h) => {
            out.push_str("kendali ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(" dengan ");
            out.push_str(x);
            out.push_str(" => ");
            fmt_expr_inline(out, h, cfg);
        }
        Expr::Ref(e, lvl) => {
            out.push_str("ruj ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(" @ ");
            fmt_security_level(out, lvl);
        }
        Expr::Deref(e) => {
            out.push('!');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Assign(lhs, rhs) => {
            fmt_expr_inline(out, lhs, cfg);
            out.push_str(" := ");
            fmt_expr_inline(out, rhs, cfg);
        }
        Expr::Classify(e) => {
            out.push_str("sulit ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Declassify(e, proof) => {
            out.push_str("dedah ");
            fmt_expr_inline(out, e, cfg);
            out.push_str(" dengan ");
            fmt_expr_inline(out, proof, cfg);
        }
        Expr::Prove(e) => {
            out.push_str("bukti ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Return(e) => {
            out.push_str("pulang ");
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Require(eff, e) => {
            out.push_str("perlukan ");
            fmt_effect(out, eff);
            out.push(' ');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Grant(eff, e) => {
            out.push_str("beri ");
            fmt_effect(out, eff);
            out.push(' ');
            fmt_expr_inline(out, e, cfg);
        }
        Expr::Loc(n) => out.push_str(&format!("loc#{n}")),
        Expr::BinOp(op, lhs, rhs) => {
            fmt_operand(out, lhs, op, false, cfg);
            out.push(' ');
            fmt_binop(out, op);
            out.push(' ');
            fmt_operand(out, rhs, op, true, cfg);
        }
        Expr::FFICall { name, args, .. } => {
            out.push_str(name);
            out.push('(');
            for (i, arg) in args.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                fmt_expr_inline(out, arg, cfg);
            }
            out.push(')');
        }
        Expr::ActorDecl { .. }
        | Expr::ChoreographyBlock { .. }
        | Expr::Spawn(_, _)
        | Expr::ActorSend(_, _)
        | Expr::ActorRecv(_)
        | Expr::CRDTMerge(_, _)
        | Expr::ContentHash(_)
        | Expr::ContentVerify(_, _) => {
            out.push_str("/* JALINAN Phase 6: actor/choreography/CRDT */");
        }
        Expr::ContractDeploy(expr) => {
            out.push_str("kontrak_pintar { ");
            fmt_expr_inline(out, expr, cfg);
            out.push_str(" }");
        }
        Expr::TokenTransfer { from, to, amount } => {
            out.push_str("token::pindah(");
            fmt_expr_inline(out, from, cfg);
            out.push_str(", ");
            fmt_expr_inline(out, to, cfg);
            out.push_str(", ");
            fmt_expr_inline(out, amount, cfg);
            out.push(')');
        }
        Expr::ZakatCalculate(expr) => {
            out.push_str("zakat(");
            fmt_expr_inline(out, expr, cfg);
            out.push(')');
        }

        // CAHAYA Phase J5
        Expr::UIDisplay(_)
        | Expr::UIRow(_)
        | Expr::UIColumn(_)
        | Expr::UIText(_, _)
        | Expr::UIButton(_, _)
        | Expr::UIColor(_, _, _)
        | Expr::UIStyleDecl { .. }
        | Expr::UIContrastCheck(_, _) => {
            out.push_str("/* CAHAYA Phase J5: UI primitives */");
        }
    }
}

/// Binding level of a binary operator, matching the parser's precedence chain
/// (`parse_or` … `parse_multiplicative`). Every level is left-associative.
fn binop_level(op: &BinOp) -> u8 {
    match op {
        BinOp::Or => 1,
        BinOp::And => 2,
        BinOp::Eq | BinOp::Ne => 3,
        BinOp::Lt | BinOp::Le | BinOp::Gt | BinOp::Ge => 4,
        BinOp::Add | BinOp::Sub => 5,
        BinOp::Mul | BinOp::Div | BinOp::Mod => 6,
    }
}

/// Print an operand of `parent`, parenthesised whenever printing it bare would
/// re-parse differently: a looser-binding operator on the left, a looser-or-
/// equal one on the right (left associativity: `a - (b - c)`), and any operand
/// that is not an atom (`kalau`, `biar`, lambdas, ...). The old printer never
/// parenthesised, so `(2 + 3) * 4` came out as `2 + 3 * 4`.
fn fmt_operand(out: &mut String, e: &Expr, parent: &BinOp, is_right: bool, cfg: &FmtConfig) {
    let wrap = match e {
        Expr::BinOp(op, _, _) => {
            let (child, parent) = (binop_level(op), binop_level(parent));
            if is_right {
                child <= parent
            } else {
                child < parent
            }
        }
        Expr::Var(_)
        | Expr::Int(_)
        | Expr::Bool(_)
        | Expr::String(_)
        | Expr::Unit
        | Expr::App(_, _)
        | Expr::Pair(_, _) => false,
        _ => true,
    };
    if wrap {
        out.push('(');
        fmt_expr_inline(out, e, cfg);
        out.push(')');
    } else {
        fmt_expr_inline(out, e, cfg);
    }
}

fn fmt_binop(out: &mut String, op: &BinOp) {
    out.push_str(match op {
        BinOp::Add => "+",
        BinOp::Sub => "-",
        BinOp::Mul => "*",
        BinOp::Div => "/",
        BinOp::Mod => "%",
        BinOp::Eq => "==",
        BinOp::Ne => "!=",
        BinOp::Lt => "<",
        BinOp::Le => "<=",
        BinOp::Gt => ">",
        BinOp::Ge => ">=",
        BinOp::And => "&&",
        BinOp::Or => "||",
    });
}

fn fmt_effect(out: &mut String, eff: &Effect) {
    out.push_str(match eff {
        Effect::Pure => "Bersih",
        Effect::Mut => "Ubah",
        Effect::Read => "Baca",
        Effect::Alloc => "Peruntuk",
        Effect::Write => "Tulis",
        Effect::FileSystem => "SistemFail",
        Effect::Network => "Rangkaian",
        Effect::NetworkSecure => "RangkaianSelamat",
        Effect::Crypto => "Kripto",
        Effect::Random => "Rawak",
        Effect::System => "Sistem",
        Effect::Time => "Masa",
        Effect::Process => "Proses",
        Effect::Panel => "Panel",
        Effect::Zirah => "Zirah",
        Effect::Benteng => "Benteng",
        Effect::Sandi => "Sandi",
        Effect::Menara => "Menara",
        Effect::Gapura => "Gapura",
    });
}

/// A declared/latent effect set in surface syntax: `Tulis` for one effect,
/// `(Masa, SistemFail)` for a compound set, `Bersih` for the empty set.
fn fmt_effect_set(out: &mut String, effs: EffectSet) {
    let members: Vec<Effect> = effs.iter().collect();
    match members.as_slice() {
        [] => fmt_effect(out, &Effect::Pure),
        [one] => fmt_effect(out, one),
        many => {
            out.push('(');
            for (i, e) in many.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                fmt_effect(out, e);
            }
            out.push(')');
        }
    }
}

fn fmt_security_level(out: &mut String, lvl: &SecurityLevel) {
    out.push_str(match lvl {
        SecurityLevel::Public => "Awam",
        SecurityLevel::Internal => "Dalaman",
        SecurityLevel::Session => "Sesi",
        SecurityLevel::User => "Pengguna",
        SecurityLevel::System => "Sistem",
        SecurityLevel::Secret => "Rahsia",
    });
}

fn fmt_ty(out: &mut String, ty: &Ty) {
    match ty {
        Ty::Unit => out.push_str("()"),
        Ty::Bool => out.push_str("Benar"),
        Ty::Int => out.push_str("Nombor"),
        Ty::IntN { bits, signed } => {
            out.push(if *signed { 'i' } else { 'u' });
            out.push_str(&bits.to_string());
        }
        Ty::BigInt => out.push_str("Besar"),
        Ty::Decimal => out.push_str("Perpuluhan"),
        Ty::Fixed => out.push_str("Wang"),
        Ty::FixedBin => out.push_str("Qmn"),
        Ty::String => out.push_str("Teks"),
        Ty::Bytes => out.push_str("Bait"),
        Ty::Fn(param, ret, eff) if eff.iter().nth(1).is_some() => {
            // A compound latent set has no legacy `Fn(P, R, Eff)` spelling;
            // use the arrow form, which parses `kesan (A, B)`.
            out.push_str("Fn(");
            fmt_ty(out, param);
            out.push_str(") -> ");
            fmt_ty(out, ret);
            out.push_str(" kesan ");
            fmt_effect_set(out, *eff);
        }
        Ty::Fn(param, ret, eff) => {
            out.push_str("Fn(");
            fmt_ty(out, param);
            out.push_str(", ");
            fmt_ty(out, ret);
            if !eff.is_pure() {
                out.push_str(", ");
                fmt_effect(out, &eff.total_join());
            }
            out.push(')');
        }
        Ty::Prod(a, b) => {
            out.push('(');
            fmt_ty(out, a);
            out.push_str(", ");
            fmt_ty(out, b);
            out.push(')');
        }
        Ty::Sum(a, b) => {
            out.push_str("Sum<");
            fmt_ty(out, a);
            out.push_str(", ");
            fmt_ty(out, b);
            out.push('>');
        }
        Ty::List(inner) => {
            out.push_str("Senarai<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::Option(inner) => {
            out.push_str("Mungkin<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::Ref(inner, lvl) => {
            out.push_str("Ruj<");
            fmt_ty(out, inner);
            out.push_str(">@");
            fmt_security_level(out, lvl);
        }
        Ty::Secret(inner) => {
            out.push_str("Rahsia<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::Labeled(inner, lvl) => {
            out.push_str("Berlabel<");
            fmt_ty(out, inner);
            out.push_str(", ");
            fmt_security_level(out, lvl);
            out.push('>');
        }
        Ty::Tainted(inner, src) => {
            out.push_str("Tercemar<");
            fmt_ty(out, inner);
            out.push_str(", ");
            fmt_taint_source(out, src);
            out.push('>');
        }
        Ty::Sanitized(inner, san) => {
            out.push_str("Disanitasi<");
            fmt_ty(out, inner);
            out.push_str(", ");
            fmt_sanitizer(out, san);
            out.push('>');
        }
        Ty::Proof(inner) => {
            out.push_str("Bukti<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::Capability(kind) => {
            out.push_str("Keupayaan<");
            fmt_capability_kind(out, kind);
            out.push('>');
        }
        Ty::CapabilityFull(cap) => {
            out.push_str("Keupayaan<");
            fmt_capability(out, cap);
            out.push('>');
        }
        Ty::Chan(st) => {
            out.push_str("Chan<");
            fmt_session_type(out, st);
            out.push('>');
        }
        Ty::SecureChan(st, lvl) => {
            out.push_str("SecureChan<");
            fmt_session_type(out, st);
            out.push_str(", ");
            fmt_security_level(out, lvl);
            out.push('>');
        }
        Ty::ConstantTime(inner) => {
            out.push_str("MasaTetap<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::Zeroizing(inner) => {
            out.push_str("Sifar<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::Any => out.push_str("Any"),
        Ty::RawPtr(inner) => {
            out.push('*');
            fmt_ty(out, inner);
        }
        Ty::CChar => out.push_str("CChar"),
        Ty::CInt => out.push_str("CInt"),
        Ty::CVoid => out.push_str("CVoid"),
        Ty::Actor(_, _)
        | Ty::Choreography(_, _)
        | Ty::ContentAddressed(_)
        | Ty::CRDT(_, _)
        | Ty::Supervisor(_) => {
            out.push_str("/* JALINAN Phase 6: actor/choreography/CRDT type */");
        }
        Ty::SmartContract(inner) => {
            out.push_str("kontrak_pintar<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::Token(inner) => {
            out.push_str("token<");
            fmt_ty(out, inner);
            out.push('>');
        }
        Ty::SyariahCompliant(inner) => {
            out.push_str("patuh_syariah<");
            fmt_ty(out, inner);
            out.push('>');
        }

        // CAHAYA Phase J5
        Ty::Color => out.push_str("Color"),
        Ty::Element => out.push_str("Element"),
        Ty::Layout => out.push_str("Layout"),
        Ty::UIStyle => out.push_str("UIStyle"),
        Ty::AccessibleText => out.push_str("AccessibleText"),
    }
}

fn fmt_taint_source(out: &mut String, src: &TaintSource) {
    out.push_str(match src {
        TaintSource::NetworkExternal => "NetworkExternal",
        TaintSource::NetworkInternal => "NetworkInternal",
        TaintSource::UserInput => "UserInput",
        TaintSource::FileSystem => "FileSystem",
        TaintSource::Database => "Database",
        TaintSource::Environment => "Environment",
        TaintSource::GapuraRequest => "GapuraRequest",
        TaintSource::ZirahEvent => "ZirahEvent",
        TaintSource::ZirahEndpoint => "ZirahEndpoint",
        TaintSource::BentengBiometric => "BentengBiometric",
        TaintSource::SandiSignature => "SandiSignature",
        TaintSource::MenaraDevice => "MenaraDevice",
    });
}

fn fmt_sanitizer(out: &mut String, san: &Sanitizer) {
    out.push_str(match san {
        Sanitizer::HtmlEscape => "HtmlEscape",
        Sanitizer::UrlEncode => "UrlEncode",
        Sanitizer::JsEscape => "JsEscape",
        Sanitizer::CssEscape => "CssEscape",
        Sanitizer::SqlEscape => "SqlEscape",
        Sanitizer::SqlParam => "SqlParam",
        Sanitizer::XssFilter => "XssFilter",
        Sanitizer::PathTraversal => "PathTraversal",
        Sanitizer::CommandEscape => "CommandEscape",
        Sanitizer::LdapEscape => "LdapEscape",
        Sanitizer::XmlEscape => "XmlEscape",
        Sanitizer::UrlAllowlist => "UrlAllowlist",
        Sanitizer::JsonEscape => "JsonEscape",
        Sanitizer::JsonValidation => "JsonValidation",
        Sanitizer::XmlValidation => "XmlValidation",
        Sanitizer::EmailValidation => "EmailValidation",
        Sanitizer::PhoneValidation => "PhoneValidation",
        Sanitizer::LengthBound(n) => {
            out.push_str(&format!("LengthBound({n})"));
            return;
        }
        Sanitizer::RangeBound(lo, hi) => {
            out.push_str(&format!("RangeBound({lo}, {hi})"));
            return;
        }
        Sanitizer::RegexMatch(re) => {
            out.push_str(&format!("RegexMatch(\"{re}\")"));
            return;
        }
        Sanitizer::Whitelist(items) => {
            out.push_str("Whitelist(");
            for (i, item) in items.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                out.push_str(&format!("\"{item}\""));
            }
            out.push(')');
            return;
        }
        Sanitizer::HashVerify => "HashVerify",
        Sanitizer::SignatureVerify => "SignatureVerify",
        Sanitizer::MacVerify => "MacVerify",
        Sanitizer::GapuraAuth => "GapuraAuth",
        Sanitizer::ZirahSession => "ZirahSession",
        Sanitizer::BentengBiometric => "BentengBiometric",
        Sanitizer::SandiDecrypt => "SandiDecrypt",
        Sanitizer::MenaraAttestation => "MenaraAttestation",
    });
}

fn fmt_capability_kind(out: &mut String, kind: &CapabilityKind) {
    out.push_str(match kind {
        CapabilityKind::FileRead => "FileRead",
        CapabilityKind::FileWrite => "FileWrite",
        CapabilityKind::FileExecute => "FileExecute",
        CapabilityKind::FileDelete => "FileDelete",
        CapabilityKind::NetConnect => "NetConnect",
        CapabilityKind::NetListen => "NetListen",
        CapabilityKind::NetBind => "NetBind",
        CapabilityKind::ProcSpawn => "ProcSpawn",
        CapabilityKind::ProcSignal => "ProcSignal",
        CapabilityKind::SysTime => "SysTime",
        CapabilityKind::SysRandom => "SysRandom",
        CapabilityKind::SysEnv => "SysEnv",
        CapabilityKind::RootProduct => "RootProduct",
        CapabilityKind::ProductAccess => "ProductAccess",
    });
}

fn fmt_capability(out: &mut String, cap: &Capability) {
    match cap {
        Capability::Basic(k) => fmt_capability_kind(out, k),
        Capability::Revocable(inner) => {
            out.push_str("Revocable(");
            fmt_capability(out, inner);
            out.push(')');
        }
        Capability::TimeBound(inner, t) => {
            out.push_str("TimeBound(");
            fmt_capability(out, inner);
            out.push_str(&format!(", {t})"));
        }
        Capability::Delegated(inner, to) => {
            out.push_str("Delegated(");
            fmt_capability(out, inner);
            out.push_str(&format!(", {to})"));
        }
    }
}

fn fmt_session_type(out: &mut String, st: &SessionType) {
    match st {
        SessionType::End => out.push_str("Tamat"),
        SessionType::Send(ty, cont) => {
            out.push_str("Hantar(");
            fmt_ty(out, ty);
            out.push_str(", ");
            fmt_session_type(out, cont);
            out.push(')');
        }
        SessionType::Recv(ty, cont) => {
            out.push_str("Terima(");
            fmt_ty(out, ty);
            out.push_str(", ");
            fmt_session_type(out, cont);
            out.push(')');
        }
        SessionType::Select(a, b) => {
            out.push_str("Pilih(");
            fmt_session_type(out, a);
            out.push_str(", ");
            fmt_session_type(out, b);
            out.push(')');
        }
        SessionType::Branch(a, b) => {
            out.push_str("Cabang(");
            fmt_session_type(out, a);
            out.push_str(", ");
            fmt_session_type(out, b);
            out.push(')');
        }
        SessionType::Rec(name, body) => {
            out.push_str("Rec(");
            out.push_str(name);
            out.push_str(", ");
            fmt_session_type(out, body);
            out.push(')');
        }
        SessionType::Var(name) => out.push_str(name),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn reparse(src: &str) -> Program {
        parse(src).expect("parses")
    }

    /// Operator precedence survives formatting: `(2 + 3) * 4` used to come
    /// out as `2 + 3 * 4` (20 became 14), and left associativity needs the
    /// right operand of `-` parenthesised.
    #[test]
    fn parentheses_that_carry_meaning_are_kept() {
        for src in [
            "fungsi utama() -> Nombor { (2 + 3) * 4 }",
            "fungsi utama() -> Nombor { 10 - (4 - 3) }",
            "fungsi utama() -> Benar { (betul || salah) && salah }",
            "fungsi utama() -> Nombor { (8 / 4) / 2 }",
        ] {
            let out = format_source(src).expect(src);
            assert!(same_program(&reparse(src), &reparse(&out)), "{src} -> {out}");
        }
        let out = format_source("fungsi utama() -> Nombor { (2 + 3) * 4 }").unwrap();
        assert!(out.contains("(2 + 3) * 4"), "{out}");
    }

    /// The AST carries no comments, so formatting would delete them: refuse.
    #[test]
    fn a_file_with_comments_is_refused_not_stripped() {
        for src in [
            "// nota\nfungsi utama() -> Nombor { 1 }",
            "fungsi utama() -> Nombor { /* nota */ 1 }",
            "/// dok\nfungsi utama() -> Nombor { 1 }",
        ] {
            let err = format_source(src).expect_err(src);
            assert!(err.contains("comments"), "{src}: {err}");
        }
        // A `//` inside a string literal is not a comment.
        assert!(format_source("fungsi utama() -> Teks { \"http://x\" }").is_ok());
    }

    /// Annotations survive formatting. They used to be dropped by the parser,
    /// so `fmt` deleted `: T` and `-> T` from the source without a word.
    #[test]
    fn annotations_are_kept() {
        let src = "fungsi utama() -> Nombor kesan Bersih {\n    biar x: Nombor = 5;\n    biar f = fungsi(y: Nombor) -> Nombor { y };\n    f(x)\n}\n";
        let out = format_source(src).expect("formats");
        assert!(out.contains("biar x: Nombor = 5;"), "{out}");
        assert!(out.contains("-> Nombor { y }"), "{out}");
        assert_eq!(format_source(&out).expect("fixpoint"), out);
    }

    /// Constructs the printer cannot reproduce are refused. The CAHAYA block
    /// below used to be replaced by a `/* CAHAYA ... */` placeholder — the
    /// UI code was deleted and the output still "succeeded".
    #[test]
    fn output_that_would_change_the_program_is_refused() {
        let src = "paparan {\n    tulisan(\"hai\", warna(255, 255, 255));\n}\n";
        assert!(parse(src).is_ok(), "fixture must parse");
        let err = format_source(src).expect_err("UI block must not be formatted away");
        assert!(err.contains("refusing to format"), "{err}");
    }

    /// Output that does not parse is never returned (`untuk` loops print in
    /// their desugared form, which is not surface syntax).
    #[test]
    fn unparseable_output_is_refused() {
        let src = "fungsi f() -> Nombor kesan Tulis {\n    untuk i dalam 0..3 { cetak(i); }\n    pulang 0;\n}\n";
        assert!(parse(src).is_ok(), "fixture must parse");
        match format_source(src) {
            Ok(out) => assert!(same_program(&reparse(src), &reparse(&out)), "{out}"),
            Err(e) => assert!(e.contains("refusing to format"), "{e}"),
        }
    }

    #[test]
    fn test_format_simple_function() {
        let source = "fungsi tambah(x: Nombor, y: Nombor) -> Nombor { x + y }";
        let result = format_source(source).unwrap();
        assert!(result.contains("fungsi tambah"));
        assert!(result.contains("Nombor"));
    }

    #[test]
    fn test_format_binding() {
        let source = "biar x = 42;";
        let mut parser = riina_parser::Parser::new(source);
        let program = parser.parse_program().unwrap();
        let result = format_program(&program, &FmtConfig::default());
        assert!(result.contains("biar x = 42;"));
    }

    #[test]
    fn test_format_if() {
        let source = "kalau betul { 1 } lain { 0 }";
        let result = format_source(source).unwrap();
        assert!(result.contains("kalau"));
        assert!(result.contains("lain"));
    }

    #[test]
    fn test_format_string_escapes() {
        let cfg = FmtConfig::default();
        let mut out = String::new();
        let expr = Expr::String("hello\nworld".to_string());
        fmt_expr_inline(&mut out, &expr, &cfg);
        assert_eq!(out, "\"hello\\nworld\"");
    }

    #[test]
    fn test_format_effect() {
        let source = "fungsi io() -> Teks kesan Tulis { \"hello\" }";
        let result = format_source(source).unwrap();
        assert!(result.contains("kesan Tulis"));
    }

    #[test]
    fn test_format_keeps_compound_effects() {
        // Formatting must not collapse a compound declaration to its lattice
        // join: `kesan Masa` no longer covers the file write (M1c). Both the
        // declaration and a compound function-type parameter round-trip.
        let source = "fungsi f(k: Fn(Unit) -> Nombor kesan (Masa, SistemFail)) -> Nombor \
                      kesan (Masa, SistemFail) { k(()) }";
        let result = format_source(source).unwrap();
        assert!(result.contains(") -> Nombor kesan (SistemFail, Masa) {"), "{result}");
        assert!(result.contains("Fn(()) -> Nombor kesan (SistemFail, Masa)"), "{result}");
        // ...and the output parses back to the same declaration.
        let reparsed = riina_parser::Parser::new(&result).parse_program().unwrap();
        let original = riina_parser::Parser::new(source).parse_program().unwrap();
        let sig = |p: &Program| match &p.decls[0] {
            TopLevelDecl::Function { params, effect, effect_set, .. } => {
                (params[0].1.clone(), EffectSet::from_declaration(*effect, effect_set))
            }
            other => panic!("expected a function, got {other:?}"),
        };
        assert_eq!(sig(&reparsed), sig(&original));
    }

    #[test]
    fn test_format_security_ref() {
        let mut out = String::new();
        fmt_ty(&mut out, &Ty::Ref(Box::new(Ty::Int), SecurityLevel::Secret));
        assert_eq!(out, "Ruj<Nombor>@Rahsia");
    }
}
