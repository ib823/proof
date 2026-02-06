// SPDX-License-Identifier: MPL-2.0
// Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

//! Lexer Errors

use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum LexError {
    UnexpectedChar(char, usize),
    UnterminatedString(usize),
    UnterminatedChar(usize),
    UnterminatedComment(usize),
    InvalidEscapeSequence(usize),
    InvalidNumericLiteral(String, usize),
    EmptyCharLiteral(usize),
    Unknown(String, usize),
}

impl fmt::Display for LexError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            LexError::UnexpectedChar(c, pos) => write!(f, "Unexpected character '{c}' at position {pos}"),
            LexError::UnterminatedString(pos) => write!(f, "Unterminated string starting at position {pos}"),
            LexError::UnterminatedChar(pos) => write!(f, "Unterminated char literal starting at position {pos}"),
            LexError::UnterminatedComment(pos) => write!(f, "Unterminated block comment starting at position {pos}"),
            LexError::InvalidEscapeSequence(pos) => write!(f, "Invalid escape sequence at position {pos}"),
            LexError::InvalidNumericLiteral(s, pos) => write!(f, "Invalid numeric literal '{s}' at position {pos}"),
            LexError::EmptyCharLiteral(pos) => write!(f, "Empty char literal at position {pos}"),
            LexError::Unknown(s, pos) => write!(f, "Unknown error '{s}' at position {pos}"),
        }
    }
}

impl std::error::Error for LexError {}

impl LexError {
    /// Structured error code for AI agent consumption (L0xxx series).
    pub fn error_code(&self) -> &'static str {
        match self {
            LexError::UnexpectedChar(..) => "L0001",
            LexError::UnterminatedString(_) => "L0002",
            LexError::UnterminatedChar(_) => "L0003",
            LexError::UnterminatedComment(_) => "L0004",
            LexError::InvalidEscapeSequence(_) => "L0005",
            LexError::InvalidNumericLiteral(..) => "L0006",
            LexError::EmptyCharLiteral(_) => "L0007",
            LexError::Unknown(..) => "L0099",
        }
    }

    /// Human-readable fix hint for AI agents.
    pub fn fix_hint(&self) -> Option<String> {
        Some(match self {
            LexError::UnexpectedChar(c, _) => {
                format!("Remove or replace the unexpected character '{c}'. RIINA uses ASCII operators and Bahasa Melayu/English identifiers")
            }
            LexError::UnterminatedString(_) => {
                "Add a closing '\"' to terminate the string literal".to_string()
            }
            LexError::UnterminatedChar(_) => {
                "Add a closing \"'\" to terminate the character literal".to_string()
            }
            LexError::UnterminatedComment(_) => {
                "Add '*/' to close the block comment".to_string()
            }
            LexError::InvalidEscapeSequence(_) => {
                "Valid escape sequences: \\n, \\t, \\r, \\\\, \\\", \\', \\0".to_string()
            }
            LexError::InvalidNumericLiteral(s, _) => {
                format!("'{}' is not a valid number. Use integer (42) or float (3.14) syntax", s)
            }
            LexError::EmptyCharLiteral(_) => {
                "Place a character between the single quotes, e.g. 'a'".to_string()
            }
            LexError::Unknown(_, _) => {
                return None;
            }
        })
    }

    /// Position (byte offset) of the error.
    pub fn position(&self) -> usize {
        match self {
            LexError::UnexpectedChar(_, pos)
            | LexError::UnterminatedString(pos)
            | LexError::UnterminatedChar(pos)
            | LexError::UnterminatedComment(pos)
            | LexError::InvalidEscapeSequence(pos)
            | LexError::EmptyCharLiteral(pos)
            | LexError::Unknown(_, pos) => *pos,
            LexError::InvalidNumericLiteral(_, pos) => *pos,
        }
    }
}