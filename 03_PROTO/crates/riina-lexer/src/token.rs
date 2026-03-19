// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Token Definitions

use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq, Copy)]
pub struct Span {
    pub start: usize,
    pub end: usize,
}

impl Span {
    #[must_use]
    pub fn new(start: usize, end: usize) -> Self {
        Self { start, end }
    }
}

impl fmt::Display for Span {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}..{}", self.start, self.end)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Token {
    pub kind: TokenKind,
    pub span: Span,
}

impl Token {
    #[must_use]
    pub fn new(kind: TokenKind, span: Span) -> Self {
        Self { kind, span }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TokenKind {
    // Identifiers
    Identifier(String),
    RawIdentifier(String),
    Lifetime(String),
    Label(String),

    // Literals
    LiteralBool(bool),
    LiteralInt(String, Option<String>), // value, suffix
    LiteralFloat(String, Option<String>), // value, suffix
    LiteralChar(char),
    LiteralString(String),
    LiteralByte(u8),
    LiteralByteString(Vec<u8>),

    // Keywords
    KwFn,
    KwLet,
    KwMut,
    KwConst,
    KwStatic,
    KwType,
    KwStruct,
    KwEnum,
    KwUnion,
    KwTrait,
    KwImpl,
    KwWhere,
    KwFor,
    KwIf,
    KwElse,
    KwMatch,
    KwLoop,
    KwWhile,
    KwWith,
    KwBreak,
    KwContinue,
    KwReturn,
    KwMod,
    KwPub,
    KwUse,
    KwAs,
    KwSelfValue, // self
    KwSelfType,  // Self
    KwSuper,
    KwCrate,
    KwExtern,
    KwAsync,
    KwAwait,
    KwMove,
    KwRef,
    KwUnsafe,
    KwEffect,
    KwPerform,
    KwHandle,
    KwResume,
    KwAbort,
    KwSecret,
    KwClassify,
    KwPublic,
    KwTainted,
    KwDeclassify,
    KwProve,
    KwInl,
    KwInr,
    KwSanitize,
    KwSession,
    KwSend,
    KwRecv,
    KwSelect,
    KwBranch,
    KwEnd,
    KwCapability,
    KwRevoke,
    KwAtomic,
    KwFence,
    KwAcquire,
    KwRelease,
    KwSeqCst,
    KwRelaxed,
    KwAcqRel,
    KwProduct,
    KwCt,
    KwSpeculationSafe,
    KwCombined,
    KwZeroize,
    KwFst,            // fst / pertama
    KwSnd,            // snd / kedua
    KwRequire,        // require / perlukan
    KwGrant,          // grant / beri
    KwSome,           // Some / Ada
    KwNone,           // None / Tiada
    KwOk,             // Ok / Jadi
    KwErr,            // Err / Gagal
    KwIn,
    KwIs,
    KwPure,
    KwSafe,
    KwPolicy,
    KwLevel,
    KwChannel,
    KwBorrow,
    KwCopy,
    KwClone,
    KwLifetime,   // jangka / lifetime

    // Linearity keywords
    KwSekali,     // sekali / linear — must use exactly once
    KwPaling,     // paling / affine — use at most once
    KwMesti,      // mesti / relevant — must use at least once

    // JALINAN Phase 6 keywords
    KwChoreography, // koreografi / choreography — global multiparty protocol
    KwActor,        // pelakon / actor — computation unit with local state
    KwRole,         // peranan / role — participant in choreography
    KwState,        // keadaan / state — actor-local mutable state
    KwSupervisor,   // penyelia / supervisor — fault tolerance manager
    KwMerge,        // gabung / merge — CRDT convergence operation
    KwContentHash,  // cincang / hash — content-addressed hash
    KwVerify,       // sahkan / verify — integrity verification
    KwSpawn,        // lahir / spawn — create new actor

    // CAHAYA Phase J5 keywords
    KwDisplay,    // display / paparan — UI display block
    KwLayout,     // layout / susun — layout container
    KwColor,      // color / warna — color value
    KwText_,      // text / tulisan — text element
    KwButton,     // button / butang — interactive button
    KwInput,      // input / masukan — user input field
    KwImage,      // image / gambar — image element
    KwStyle,      // style / gaya — style declaration
    KwContrast,   // contrast / kontras — accessibility contrast
    KwAccessible, // accessible / mudahcapai — accessibility annotation
    KwRow,        // row / baris — horizontal layout
    KwColumn,     // column / lajur — vertical layout
    KwPadding,    // padding / pelapik — spacing
    KwFontSize,   // font_size / saiz_fon — text size

    // Logic keywords
    KwAnd,        // dan / and
    KwOr,         // atau / or
    KwNot,        // bukan / not

    // Guard clause
    KwGuard,      // pastikan / guard

    // Test keyword
    KwTest,       // ujian / test

    // Expect keyword (for inline snapshot tests)
    KwExpect,     // jangka / expect

    // Operators & Punctuation
    Pipe,         // |>
    Plus,       // +
    Minus,      // -
    Star,       // *
    Slash,      // /
    Percent,    // %
    And,        // &
    Or,         // |
    Caret,      // ^
    Not,        // !
    Shl,        // <<
    Shr,        // >>
    
    PlusEq,     // +=
    MinusEq,    // -=
    StarEq,     // *=
    SlashEq,    // /=
    PercentEq,  // %=
    AndEq,      // &=
    OrEq,       // |=
    CaretEq,    // ^=
    ShlEq,      // <<=
    ShrEq,      // >>=

    Eq,         // =
    EqEq,       // ==
    Ne,         // !=
    Lt,         // <
    Gt,         // >
    Le,         // <=
    Ge,         // >=
    
    AndAnd,     // &&
    OrOr,       // ||
    
    Dot,        // .
    DotDot,     // ..
    DotDotEq,   // ..=
    Comma,      // ,
    Colon,      // :
    ColonEq,    // :=
    Semi,       // ;
    Question,   // ?
    At,         // @
    Hash,       // #
    Dollar,     // $
    Arrow,      // ->
    FatArrow,   // =>
    ColonColon, // ::
    
    // Delimiters
    LParen,     // (
    RParen,     // )
    LBracket,   // [
    RBracket,   // ]
    LBrace,     // {
    RBrace,     // }

    // End of File
    Eof,
}