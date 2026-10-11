// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `riinac test --update`: rewrite the expected value of a failing
//! `jangkakan` (expect-test) assertion in place.
//!
//! This used to replace the first `"<old expected>"` found ANYWHERE in the
//! file — so a test expecting `"rahsia"` rewrote an unrelated function's
//! `"rahsia"` literal and left the assertion untouched. The rewrite is now
//! confined to source spans: the failing test block's span (from the parser)
//! and, inside it, the exact token span (from the lexer) of the string
//! literal passed as the expected argument of a `jangkakan` call. When that
//! literal cannot be identified unambiguously nothing is rewritten and the
//! caller reports why.

use riina_lexer::{Lexer, Token, TokenKind};
use riina_types::TopLevelDecl;

/// The message prefix the `jangkakan` builtin produces on a mismatch
/// (`builtins/ujian.rs`): `expect mismatch:\n  actual:   A\n  expected: E`.
const MISMATCH_PREFIX: &str = "expect mismatch:\n  actual:   ";
const MISMATCH_EXPECTED: &str = "\n  expected: ";

/// One failing test: its name, which occurrence of that name it is among the
/// file's tests (0 for the first), and the runtime error message.
pub struct Failure<'a> {
    pub name: &'a str,
    pub occurrence: usize,
    pub message: &'a str,
}

/// Result of applying updates to a source file.
pub struct UpdateOutcome {
    /// The rewritten source.
    pub source: String,
    /// Number of assertions rewritten.
    pub updated: usize,
    /// Human-readable reasons for failures that could not be updated.
    pub skipped: Vec<String>,
}

/// Rewrite, in `source`, the expected literal of the `jangkakan` assertion
/// that failed in each test of `failures`.
pub fn apply(source: &str, failures: &[Failure<'_>]) -> UpdateOutcome {
    let mut skipped = Vec::new();
    let test_spans = match test_block_spans(source) {
        Ok(spans) => spans,
        Err(e) => {
            return UpdateOutcome {
                source: source.to_string(),
                updated: 0,
                skipped: vec![format!("cannot locate test blocks: {e}")],
            };
        }
    };

    // (start, end, replacement), applied back to front so earlier spans stay
    // valid.
    let mut edits: Vec<(usize, usize, String)> = Vec::new();
    for failure in failures {
        if !failure.message.contains(MISMATCH_PREFIX) {
            continue; // not an expect-test mismatch
        }
        let Some(&(start, end)) = test_spans
            .iter()
            .filter(|(name, _)| name == failure.name)
            .nth(failure.occurrence)
            .map(|(_, span)| span)
        else {
            skipped.push(format!(
                "ujian \"{}\": its block was not found in this file",
                failure.name
            ));
            continue;
        };
        let candidates: Vec<(usize, usize, String)> = expected_literals(source, start, end);
        // The message ends with the expected value the assertion compared
        // against; only literals with exactly that value can be the one that
        // failed, and the actual value is what lies between the two markers.
        let matching: Vec<(usize, usize, String)> = candidates
            .into_iter()
            .filter_map(|(s, e, value)| {
                actual_value(failure.message, &value).map(|actual| (s, e, actual))
            })
            .collect();
        match matching.as_slice() {
            [(s, e, actual)] => edits.push((*s, *e, riina_string_literal(actual))),
            [] => skipped.push(format!(
                "ujian \"{}\": no `jangkakan` string literal matching the failed expectation",
                failure.name
            )),
            _ => skipped.push(format!(
                "ujian \"{}\": several `jangkakan` assertions expect the same value; \
                 not guessing which one failed — update it by hand",
                failure.name
            )),
        }
    }

    edits.sort_by(|a, b| b.0.cmp(&a.0));
    let mut out = source.to_string();
    for (s, e, replacement) in &edits {
        out.replace_range(*s..*e, replacement);
    }
    UpdateOutcome {
        source: out,
        updated: edits.len(),
        skipped,
    }
}

/// A test block's name and source byte range `(start, end)`.
type TestSpan = (String, (usize, usize));

/// Every `ujian` block in `source`, in order.
fn test_block_spans(source: &str) -> Result<Vec<TestSpan>, String> {
    let program = riina_parser::Parser::new(source)
        .parse_program()
        .map_err(|e| e.to_string())?;
    Ok(program
        .spans
        .iter()
        .filter_map(|sd| match &sd.decl {
            TopLevelDecl::Test { name, .. } => Some((name.clone(), (sd.span.start, sd.span.end))),
            _ => None,
        })
        .collect())
}

/// The actual value from a mismatch `message` whose expected value is
/// `expected`, or `None` if the message is not about that expected value.
fn actual_value(message: &str, expected: &str) -> Option<String> {
    let at = message.find(MISMATCH_PREFIX)? + MISMATCH_PREFIX.len();
    let tail = format!("{MISMATCH_EXPECTED}{expected}");
    let rest = message.get(at..)?;
    let actual = rest.strip_suffix(tail.as_str())?;
    Some(actual.to_string())
}

/// Token spans `(start, end, value)` of the string literals passed as the
/// EXPECTED argument of each `jangkakan`/`expect` call inside
/// `source[start..end]`. Both call shapes are recognised:
/// `jangkakan((actual, "e"))` and `jangkakan(actual, "e")`.
fn expected_literals(source: &str, start: usize, end: usize) -> Vec<(usize, usize, String)> {
    let Some(block) = source.get(start..end) else {
        return Vec::new();
    };
    let mut tokens: Vec<Token> = Vec::new();
    let mut lexer = Lexer::new(block);
    while let Ok(tok) = lexer.next_token() {
        if tok.kind == TokenKind::Eof {
            break;
        }
        tokens.push(tok);
    }

    let mut found = Vec::new();
    for i in 0..tokens.len() {
        if tokens[i].kind != TokenKind::KwExpect
            || tokens.get(i + 1).map(|t| &t.kind) != Some(&TokenKind::LParen)
        {
            continue;
        }
        // The argument list is the call's parens, or a single parenthesised
        // tuple filling them.
        let Some(close) = matching_paren(&tokens, i + 1) else {
            continue;
        };
        let (open, close) = match (tokens.get(i + 2), matching_paren(&tokens, i + 2)) {
            (Some(t), Some(inner_close)) if t.kind == TokenKind::LParen && inner_close + 1 == close => {
                (i + 2, inner_close)
            }
            _ => (i + 1, close),
        };
        // `…, "expected" )` with the comma at the top level of the list.
        if close < open + 3 {
            continue;
        }
        let lit = &tokens[close - 1];
        let TokenKind::LiteralString(value) = &lit.kind else {
            continue;
        };
        if tokens[close - 2].kind != TokenKind::Comma || depth_at(&tokens, open, close - 2) != 1 {
            continue;
        }
        found.push((start + lit.span.start, start + lit.span.end, value.clone()));
    }
    found
}

/// Index of the `)` matching the `(` at `open`.
fn matching_paren(tokens: &[Token], open: usize) -> Option<usize> {
    let mut depth = 0usize;
    for (j, t) in tokens.iter().enumerate().skip(open) {
        match t.kind {
            TokenKind::LParen | TokenKind::LBracket | TokenKind::LBrace => depth += 1,
            TokenKind::RParen | TokenKind::RBracket | TokenKind::RBrace => {
                depth = depth.checked_sub(1)?;
                if depth == 0 {
                    return (t.kind == TokenKind::RParen).then_some(j);
                }
            }
            _ => {}
        }
    }
    None
}

/// Bracket depth just before token `at`, counting from the `(` at `open`
/// (so a token directly inside it is at depth 1).
fn depth_at(tokens: &[Token], open: usize, at: usize) -> usize {
    let mut depth = 0usize;
    for t in &tokens[open..at] {
        match t.kind {
            TokenKind::LParen | TokenKind::LBracket | TokenKind::LBrace => depth += 1,
            TokenKind::RParen | TokenKind::RBracket | TokenKind::RBrace => {
                depth = depth.saturating_sub(1);
            }
            _ => {}
        }
    }
    depth
}

/// `value` as a RIINA string literal, using exactly the escapes the lexer
/// reads back (`\\`, `\"`, `\n`, `\r`, `\t`, `\0`).
fn riina_string_literal(value: &str) -> String {
    let mut out = String::with_capacity(value.len() + 2);
    out.push('"');
    for c in value.chars() {
        match c {
            '\\' => out.push_str("\\\\"),
            '"' => out.push_str("\\\""),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            '\0' => out.push_str("\\0"),
            c => out.push(c),
        }
    }
    out.push('"');
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    fn mismatch(actual: &str, expected: &str) -> String {
        format!("invalid operation: expect mismatch:\n  actual:   {actual}\n  expected: {expected}")
    }

    #[test]
    fn only_the_failing_assertion_literal_is_rewritten() {
        // The audit's reproducer: an unrelated function returns the same
        // string the test expects. Only the test's literal may change.
        let src = "fungsi kata_laluan_lalai() -> Teks kesan Bersih { \"rahsia\" }\n\
                   fungsi sapa(x: Nombor) -> Teks kesan Bersih { \"hai\" }\n\
                   ujian \"sapa\" { jangkakan((sapa(1), \"rahsia\")) }\n";
        let msg = mismatch("hai", "rahsia");
        let out = apply(
            src,
            &[Failure {
                name: "sapa",
                occurrence: 0,
                message: &msg,
            }],
        );
        assert_eq!(out.updated, 1, "{:?}", out.skipped);
        assert_eq!(
            out.source,
            "fungsi kata_laluan_lalai() -> Teks kesan Bersih { \"rahsia\" }\n\
             fungsi sapa(x: Nombor) -> Teks kesan Bersih { \"hai\" }\n\
             ujian \"sapa\" { jangkakan((sapa(1), \"hai\")) }\n"
        );
    }

    #[test]
    fn two_argument_form_and_escaping() {
        let src = "ujian \"t\" { jangkakan(f(1), \"x\") }\n";
        let msg = mismatch("a \"q\"\nb\\", "x");
        let out = apply(
            src,
            &[Failure {
                name: "t",
                occurrence: 0,
                message: &msg,
            }],
        );
        assert_eq!(out.updated, 1, "{:?}", out.skipped);
        assert_eq!(out.source, "ujian \"t\" { jangkakan(f(1), \"a \\\"q\\\"\\nb\\\\\") }\n");
    }

    #[test]
    fn ambiguous_assertions_are_not_guessed() {
        let src = "ujian \"t\" { jangkakan((f(1), \"a\")); jangkakan((f(2), \"a\")) }\n";
        let msg = mismatch("b", "a");
        let out = apply(
            src,
            &[Failure {
                name: "t",
                occurrence: 0,
                message: &msg,
            }],
        );
        assert_eq!(out.updated, 0);
        assert_eq!(out.source, src);
        assert_eq!(out.skipped.len(), 1);
    }

    #[test]
    fn only_the_named_test_block_is_searched() {
        let src = "ujian \"a\" { jangkakan((f(1), \"v\")) }\n\
                   ujian \"b\" { jangkakan((f(2), \"v\")) }\n";
        let msg = mismatch("w", "v");
        let out = apply(
            src,
            &[Failure {
                name: "b",
                occurrence: 0,
                message: &msg,
            }],
        );
        assert_eq!(out.updated, 1, "{:?}", out.skipped);
        assert_eq!(
            out.source,
            "ujian \"a\" { jangkakan((f(1), \"v\")) }\n\
             ujian \"b\" { jangkakan((f(2), \"w\")) }\n"
        );
    }
}
