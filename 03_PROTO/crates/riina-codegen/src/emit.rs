// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! C Code Emission Backend
//!
//! Translates RIINA IR to portable C99 code that can be compiled by any
//! standard C compiler. This provides a path from verified RIINA programs
//! to executable binaries while maintaining traceability to the formal proofs.
//!
//! # Architecture
//!
//! ```text
//! ┌─────────────────────────────────────────────────────────────────────────┐
//! │                        C Emission Pipeline                              │
//! │                                                                         │
//! │   ir::Program                                                           │
//! │       │                                                                 │
//! │       ▼                                                                 │
//! │   ┌────────────────────┐                                               │
//! │   │  CEmitter::new()   │  Initialize emitter state                     │
//! │   └────────────────────┘                                               │
//! │       │                                                                 │
//! │       ▼                                                                 │
//! │   ┌────────────────────┐                                               │
//! │   │  emit_prelude()    │  Runtime support, type definitions            │
//! │   └────────────────────┘                                               │
//! │       │                                                                 │
//! │       ▼                                                                 │
//! │   ┌────────────────────┐                                               │
//! │   │  emit_function()   │  For each function in program                 │
//! │   │    ├─ emit_block() │    For each basic block                       │
//! │   │    │   └─ emit_instr() │  For each instruction                     │
//! │   │    └─ emit_term()  │    Emit terminator                            │
//! │   └────────────────────┘                                               │
//! │       │                                                                 │
//! │       ▼                                                                 │
//! │   ┌────────────────────┐                                               │
//! │   │  emit_main()       │  Entry point wrapper                          │
//! │   └────────────────────┘                                               │
//! │       │                                                                 │
//! │       ▼                                                                 │
//! │   C99 Source Code                                                       │
//! │   (portable, compilable)                                                │
//! │                                                                         │
//! └─────────────────────────────────────────────────────────────────────────┘
//! ```
//!
//! # Correspondence with Coq
//!
//! The emitted C code maintains semantic equivalence with the interpreter:
//!
//! ```coq
//! (* 02_FORMAL/coq/properties/CEmission.v *)
//!
//! (* C emission preserves semantics *)
//! Theorem c_emission_correct : forall prog v c_prog,
//!   emit_c prog = Some c_prog ->
//!   ir_eval prog v ->
//!   c_eval c_prog v.
//! ```
//!
//! # Security Guarantees
//!
//! The emitted C code preserves RIINA's security properties:
//!
//! 1. **Memory Safety**: All allocations tracked, bounds checked
//! 2. **Type Safety**: Tagged union representation preserves types
//! 3. **Information Flow**: Runtime checks prevent secret leakage
//! 4. **Effect Safety**: Capability checks at effect boundaries
//!
//! # Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST

use crate::ir::{
    AnnotatedInstr, BasicBlock, BinOp, BlockId, Constant, FuncId, Function, Instruction, Program,
    Terminator, UnaryOp, VarId,
};
use crate::Result;
use riina_types::{Effect, SecurityLevel, Ty};
use std::collections::{HashMap, HashSet};
use std::fmt::Write as FmtWrite;

/// Phi copy information: for a target block, which phi result vars need copies
/// from which source vars, keyed by predecessor block ID.
///
/// PhiMap[target_block][predecessor_block] = Vec<(phi_result, source_var)>
type PhiMap = HashMap<BlockId, HashMap<BlockId, Vec<(VarId, VarId)>>>;

/// C code emitter
///
/// Translates RIINA IR to C99 source code.
pub struct CEmitter {
    /// Output buffer for generated code
    output: String,
    /// Current indentation level
    indent: usize,
    /// Set of declared variables (to avoid redeclaration)
    declared_vars: HashSet<VarId>,
    /// Functions that need forward declarations
    forward_decls: Vec<FuncId>,
}

impl CEmitter {
    /// Create a new C emitter
    #[must_use]
    pub fn new() -> Self {
        Self {
            output: String::with_capacity(64 * 1024), // Pre-allocate 64KB
            indent: 0,
            declared_vars: HashSet::new(),
            forward_decls: Vec::new(),
        }
    }

    /// Emit a complete C program from IR
    pub fn emit(&mut self, program: &Program) -> Result<String> {
        self.output.clear();
        self.declared_vars.clear();
        self.forward_decls.clear();

        // Emit file header
        self.emit_header();

        // Emit runtime support
        self.emit_runtime_prelude();

        // The Unicode runtime is the ONE part of the prelude emitted
        // conditionally. Everything else is unconditional and already costs a
        // hello-world ~228 KB of C; the vendored UCD tables would add ~250 KB
        // MORE — more than doubling every binary — to serve three builtins most
        // programs never call. So they are emitted only when the program
        // actually calls one.
        //
        // The tables are written out FROM the same Rust statics the interpreter
        // reads (`unicode_nfc_data`, `unicode_confusables_data`), not
        // transcribed. A hand-copied 250 KB table is a drift source no
        // differential could realistically cover; generating it means the two
        // backends cannot disagree about the DATA, only about the algorithm,
        // which is small enough to test properly.
        if Self::program_uses_unicode(program) {
            self.emit_unicode_runtime();
        }

        // Collect forward declarations
        for func_id in program.functions.keys() {
            self.forward_decls.push(*func_id);
        }

        // Emit forward declarations
        self.emit_forward_declarations(program)?;

        // Emit all functions
        for func in program.functions.values() {
            self.emit_function(func)?;
        }

        // Emit main entry point
        self.emit_main_wrapper(program)?;

        Ok(self.output.clone())
    }


    /// Canonical names of the builtins that need the Unicode runtime.
    const UNICODE_BUILTINS: &'static [&'static str] = &["nfc", "skeleton", "adalah_keliru"];

    /// Whether `program` calls any builtin that needs the UCD tables.
    fn program_uses_unicode(program: &Program) -> bool {
        program.functions.values().any(|f| {
            f.blocks.iter().any(|b| {
                b.instrs.iter().any(|i| {
                    matches!(&i.instr, crate::ir::Instruction::BuiltinCall { name, .. }
                        if Self::UNICODE_BUILTINS.contains(&name.as_str()))
                })
            })
        })
    }

    /// Emit the UCD tables and the NFC / UTS-39 skeleton implementation.
    ///
    /// The TABLES are generated from the very statics the interpreter uses, so
    /// the two backends read identical data by construction. Only the ALGORITHM
    /// is written twice, and it is short: canonical decomposition (with the
    /// algorithmic Hangul case), canonical ordering by combining class,
    /// canonical composition, and the confusable prototype mapping.
    fn emit_unicode_runtime(&mut self) {
        use crate::unicode_confusables_data::{CONFUSABLE_DATA, CONFUSABLE_INDEX};
        use crate::unicode_nfc_data::{COMBINING_CLASS, COMPOSE, DECOMP_DATA, DECOMP_INDEX};

        self.writeln("/* ══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*   UNICODE RUNTIME (UAX #15 NFC + UTS #39 skeleton)                 */");
        self.writeln("/*   Emitted only for programs that call nfc/skeleton/adalah_keliru.  */");
        self.writeln("/*   Tables generated from riina-codegen's own UCD statics — the      */");
        self.writeln("/*   interpreter and this backend read the SAME data by construction. */");
        self.writeln("/* ══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        // ── Tables ──
        self.writeln(&format!(
            "static const uint32_t riina_ucd_ccc[][2] = {{ /* {} */",
            COMBINING_CLASS.len()
        ));
        for chunk in COMBINING_CLASS.chunks(8) {
            let row: Vec<String> = chunk
                .iter()
                .map(|(cp, cc)| format!("{{{cp:#x},{cc}}}"))
                .collect();
            self.writeln(&format!("{},", row.join(",")));
        }
        self.writeln("};");
        self.writeln(&format!(
            "#define RIINA_UCD_CCC_N {}",
            COMBINING_CLASS.len()
        ));
        self.writeln("");

        self.writeln(&format!(
            "static const uint32_t riina_ucd_decomp_index[][3] = {{ /* {} */",
            DECOMP_INDEX.len()
        ));
        for chunk in DECOMP_INDEX.chunks(6) {
            let row: Vec<String> = chunk
                .iter()
                .map(|(cp, off, len)| format!("{{{cp:#x},{off},{len}}}"))
                .collect();
            self.writeln(&format!("{},", row.join(",")));
        }
        self.writeln("};");
        self.writeln(&format!(
            "#define RIINA_UCD_DECOMP_INDEX_N {}",
            DECOMP_INDEX.len()
        ));
        self.writeln("");

        self.writeln(&format!(
            "static const uint32_t riina_ucd_decomp_data[] = {{ /* {} */",
            DECOMP_DATA.len()
        ));
        for chunk in DECOMP_DATA.chunks(12) {
            let row: Vec<String> = chunk.iter().map(|cp| format!("{cp:#x}")).collect();
            self.writeln(&format!("{},", row.join(",")));
        }
        self.writeln("};");
        self.writeln("");

        self.writeln(&format!(
            "static const uint32_t riina_ucd_compose[][3] = {{ /* {} */",
            COMPOSE.len()
        ));
        for chunk in COMPOSE.chunks(6) {
            let row: Vec<String> = chunk
                .iter()
                .map(|(a, b, c)| format!("{{{a:#x},{b:#x},{c:#x}}}"))
                .collect();
            self.writeln(&format!("{},", row.join(",")));
        }
        self.writeln("};");
        self.writeln(&format!("#define RIINA_UCD_COMPOSE_N {}", COMPOSE.len()));
        self.writeln("");

        self.writeln(&format!(
            "static const uint32_t riina_ucd_conf_index[][3] = {{ /* {} */",
            CONFUSABLE_INDEX.len()
        ));
        for chunk in CONFUSABLE_INDEX.chunks(6) {
            let row: Vec<String> = chunk
                .iter()
                .map(|(cp, off, len)| format!("{{{cp:#x},{off},{len}}}"))
                .collect();
            self.writeln(&format!("{},", row.join(",")));
        }
        self.writeln("};");
        self.writeln(&format!(
            "#define RIINA_UCD_CONF_INDEX_N {}",
            CONFUSABLE_INDEX.len()
        ));
        self.writeln("");

        self.writeln(&format!(
            "static const uint32_t riina_ucd_conf_data[] = {{ /* {} */",
            CONFUSABLE_DATA.len()
        ));
        for chunk in CONFUSABLE_DATA.chunks(12) {
            let row: Vec<String> = chunk.iter().map(|cp| format!("{cp:#x}")).collect();
            self.writeln(&format!("{},", row.join(",")));
        }
        self.writeln("};");
        self.writeln("");

        // ── Algorithm ──
        //
        // Mirrors unicode_nfc.rs and unicode_confusables.rs. The parts a C
        // author would get wrong on their own are called out inline.
        self.writeln(
            r####"
/* Hangul composes and decomposes arithmetically (UAX #15 §16) rather than by
   table, so these 11172 syllables never appear in the decomposition data. */
#define RIINA_HANGUL_S_BASE 0xAC00u
#define RIINA_HANGUL_L_BASE 0x1100u
#define RIINA_HANGUL_V_BASE 0x1161u
#define RIINA_HANGUL_T_BASE 0x11A7u
#define RIINA_HANGUL_L_COUNT 19u
#define RIINA_HANGUL_V_COUNT 21u
#define RIINA_HANGUL_T_COUNT 28u
#define RIINA_HANGUL_N_COUNT (RIINA_HANGUL_V_COUNT * RIINA_HANGUL_T_COUNT)
#define RIINA_HANGUL_S_COUNT (RIINA_HANGUL_L_COUNT * RIINA_HANGUL_N_COUNT)

typedef struct { uint32_t* cps; size_t len; size_t cap; } riina_cpbuf_t;

static void riina_cpbuf_push(riina_cpbuf_t* b, uint32_t cp) {
    if (b->len >= b->cap) {
        b->cap = b->cap ? b->cap * 2 : 32;
        b->cps = (uint32_t*)realloc(b->cps, b->cap * sizeof(uint32_t));
        if (!b->cps) abort();
    }
    b->cps[b->len++] = cp;
}

static uint8_t riina_ucd_ccc_of(uint32_t cp) {
    size_t lo = 0, hi = RIINA_UCD_CCC_N;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        if (riina_ucd_ccc[mid][0] == cp) return (uint8_t)riina_ucd_ccc[mid][1];
        if (riina_ucd_ccc[mid][0] < cp) lo = mid + 1; else hi = mid;
    }
    return 0;
}

/* Full (recursive) canonical decomposition of one code point. */
static void riina_ucd_decompose_cp(uint32_t cp, riina_cpbuf_t* out) {
    if (cp >= RIINA_HANGUL_S_BASE && cp < RIINA_HANGUL_S_BASE + RIINA_HANGUL_S_COUNT) {
        uint32_t si = cp - RIINA_HANGUL_S_BASE;
        riina_cpbuf_push(out, RIINA_HANGUL_L_BASE + si / RIINA_HANGUL_N_COUNT);
        riina_cpbuf_push(out, RIINA_HANGUL_V_BASE
            + (si % RIINA_HANGUL_N_COUNT) / RIINA_HANGUL_T_COUNT);
        uint32_t t = si % RIINA_HANGUL_T_COUNT;
        if (t != 0) riina_cpbuf_push(out, RIINA_HANGUL_T_BASE + t);
        return;
    }
    size_t lo = 0, hi = RIINA_UCD_DECOMP_INDEX_N, found = (size_t)-1;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        if (riina_ucd_decomp_index[mid][0] == cp) { found = mid; break; }
        if (riina_ucd_decomp_index[mid][0] < cp) lo = mid + 1; else hi = mid;
    }
    if (found == (size_t)-1) { riina_cpbuf_push(out, cp); return; }
    uint32_t off = riina_ucd_decomp_index[found][1];
    uint32_t len = riina_ucd_decomp_index[found][2];
    for (uint32_t i = 0; i < len; i++) {
        riina_ucd_decompose_cp(riina_ucd_decomp_data[off + i], out);
    }
}

/* Canonical ordering: a STABLE insertion sort over runs of non-zero combining
   class. Stability is required by UAX #15 — an unstable sort reorders equal
   classes and changes the result. */
static void riina_ucd_canonical_order(riina_cpbuf_t* b) {
    for (size_t i = 1; i < b->len; i++) {
        uint8_t cc = riina_ucd_ccc_of(b->cps[i]);
        if (cc == 0) continue;
        size_t j = i;
        while (j > 0) {
            uint8_t prev = riina_ucd_ccc_of(b->cps[j - 1]);
            if (prev == 0 || prev <= cc) break;
            uint32_t t = b->cps[j]; b->cps[j] = b->cps[j - 1]; b->cps[j - 1] = t;
            j--;
        }
    }
}

static int riina_ucd_compose_pair(uint32_t a, uint32_t b, uint32_t* out) {
    /* Hangul first, arithmetically. */
    if (a >= RIINA_HANGUL_L_BASE && a < RIINA_HANGUL_L_BASE + RIINA_HANGUL_L_COUNT
        && b >= RIINA_HANGUL_V_BASE && b < RIINA_HANGUL_V_BASE + RIINA_HANGUL_V_COUNT) {
        *out = RIINA_HANGUL_S_BASE
             + ((a - RIINA_HANGUL_L_BASE) * RIINA_HANGUL_V_COUNT + (b - RIINA_HANGUL_V_BASE))
               * RIINA_HANGUL_T_COUNT;
        return 1;
    }
    if (a >= RIINA_HANGUL_S_BASE && a < RIINA_HANGUL_S_BASE + RIINA_HANGUL_S_COUNT
        && ((a - RIINA_HANGUL_S_BASE) % RIINA_HANGUL_T_COUNT) == 0
        && b > RIINA_HANGUL_T_BASE && b < RIINA_HANGUL_T_BASE + RIINA_HANGUL_T_COUNT) {
        *out = a + (b - RIINA_HANGUL_T_BASE);
        return 1;
    }
    /* COMPOSE is sorted by (first, second). */
    size_t lo = 0, hi = RIINA_UCD_COMPOSE_N;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        uint32_t ma = riina_ucd_compose[mid][0], mb = riina_ucd_compose[mid][1];
        if (ma == a && mb == b) { *out = riina_ucd_compose[mid][2]; return 1; }
        if (ma < a || (ma == a && mb < b)) lo = mid + 1; else hi = mid;
    }
    return 0;
}

/* Canonical composition (UAX #15 §X3). The BLOCKED check is the subtle part: a
   starter may only combine with a following mark if no intervening character
   has a combining class >= that mark's. Dropping it composes across a blocker
   and gives a different string. */
static void riina_ucd_compose_buf(riina_cpbuf_t* b) {
    if (b->len == 0) return;
    size_t starter = 0;
    uint8_t last_cc = 0;
    size_t out = 1;
    if (riina_ucd_ccc_of(b->cps[0]) != 0) last_cc = 0xFF; /* not a starter */
    for (size_t i = 1; i < b->len; i++) {
        uint32_t cp = b->cps[i];
        uint8_t cc = riina_ucd_ccc_of(cp);
        uint32_t composed;
        if (last_cc != 0xFF && (last_cc == 0 ? 1 : last_cc < cc)
            && riina_ucd_compose_pair(b->cps[starter], cp, &composed)) {
            b->cps[starter] = composed;
            continue;
        }
        if (cc == 0) { starter = out; last_cc = 0; }
        else { last_cc = cc; }
        b->cps[out++] = cp;
    }
    b->len = out;
}

static riina_cpbuf_t riina_ucd_decode(const char* s, size_t slen) {
    riina_cpbuf_t b = { NULL, 0, 0 };
    size_t i = 0;
    while (i < slen) riina_cpbuf_push(&b, riina_sec_utf8_next(s, slen, &i));
    return b;
}

static riina_value_t* riina_ucd_encode(riina_cpbuf_t* b) {
    size_t cap = b->len * 4 + 1, n = 0;
    char* out = (char*)malloc(cap);
    if (!out) abort();
    for (size_t i = 0; i < b->len; i++) riina_sec_put_utf8(&out, &n, &cap, b->cps[i]);
    out[n] = '\0';
    riina_value_t* v = riina_string(out);
    free(out);
    return v;
}

/* NFD: decompose then canonically order. */
static void riina_ucd_nfd_buf(riina_cpbuf_t* in, riina_cpbuf_t* out) {
    for (size_t i = 0; i < in->len; i++) riina_ucd_decompose_cp(in->cps[i], out);
    riina_ucd_canonical_order(out);
}

static riina_value_t* riina_builtin_nfc(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_cpbuf_t in = riina_ucd_decode(arg->data.string_val.data, arg->data.string_val.len);
    riina_cpbuf_t d = { NULL, 0, 0 };
    riina_ucd_nfd_buf(&in, &d);
    riina_ucd_compose_buf(&d);
    riina_value_t* r = riina_ucd_encode(&d);
    free(in.cps); free(d.cps);
    return r;
}

/* skeleton(X) = NFD( map(NFD(X)) ) — UTS #39 §4. Note it ends in NFD, NOT NFC:
   the skeleton is a comparison key, not a display form. */
static riina_value_t* riina_builtin_skeleton(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_cpbuf_t in = riina_ucd_decode(arg->data.string_val.data, arg->data.string_val.len);
    riina_cpbuf_t d1 = { NULL, 0, 0 };
    riina_ucd_nfd_buf(&in, &d1);

    riina_cpbuf_t mapped = { NULL, 0, 0 };
    for (size_t i = 0; i < d1.len; i++) {
        uint32_t cp = d1.cps[i];
        size_t lo = 0, hi = RIINA_UCD_CONF_INDEX_N, found = (size_t)-1;
        while (lo < hi) {
            size_t mid = lo + (hi - lo) / 2;
            if (riina_ucd_conf_index[mid][0] == cp) { found = mid; break; }
            if (riina_ucd_conf_index[mid][0] < cp) lo = mid + 1; else hi = mid;
        }
        if (found == (size_t)-1) { riina_cpbuf_push(&mapped, cp); continue; }
        uint32_t off = riina_ucd_conf_index[found][1];
        uint32_t len = riina_ucd_conf_index[found][2];
        for (uint32_t k = 0; k < len; k++) {
            riina_cpbuf_push(&mapped, riina_ucd_conf_data[off + k]);
        }
    }

    riina_cpbuf_t d2 = { NULL, 0, 0 };
    riina_ucd_nfd_buf(&mapped, &d2);
    riina_value_t* r = riina_ucd_encode(&d2);
    free(in.cps); free(d1.cps); free(mapped.cps); free(d2.cps);
    return r;
}

static riina_value_t* riina_builtin_adalah_keliru(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* a = riina_builtin_skeleton(arg->data.pair_val.fst);
    riina_value_t* b = riina_builtin_skeleton(arg->data.pair_val.snd);
    int same = a->data.string_val.len == b->data.string_val.len
        && memcmp(a->data.string_val.data, b->data.string_val.data,
                  a->data.string_val.len) == 0;
    return riina_bool(same != 0);
}
"####,
        );
    }

    /// Write a line with current indentation
    fn writeln(&mut self, s: &str) {
        for _ in 0..self.indent {
            self.output.push_str("    ");
        }
        self.output.push_str(s);
        self.output.push('\n');
    }

    /// Write without newline
    fn write(&mut self, s: &str) {
        for _ in 0..self.indent {
            self.output.push_str("    ");
        }
        self.output.push_str(s);
    }

    /// Write raw string (no indentation)
    fn write_raw(&mut self, s: &str) {
        self.output.push_str(s);
    }

    /// Increase indentation
    fn indent(&mut self) {
        self.indent += 1;
    }

    /// Decrease indentation
    fn dedent(&mut self) {
        if self.indent > 0 {
            self.indent -= 1;
        }
    }

    /// Emit file header with license and warnings
    fn emit_header(&mut self) {
        self.writeln("/*");
        self.writeln(" * RIINA Generated C Code");
        self.writeln(" * ");
        self.writeln(" * THIS FILE IS AUTO-GENERATED. DO NOT EDIT.");
        self.writeln(" * ");
        self.writeln(" * Generated by riina-codegen from verified RIINA source.");
        self.writeln(" * Corresponds to formal proofs in 02_FORMAL/coq/.");
        self.writeln(" * ");
        self.writeln(" * RIINA = Rigorous Immutable Invariant, No Assumptions");
        self.writeln(" * \"QED Eternum.\"");
        self.writeln(" */");
        self.writeln("");
        self.writeln("/* Required C99 or later */");
        self.writeln("#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 199901L");
        self.writeln("#error \"RIINA requires C99 or later\"");
        self.writeln("#endif");
        self.writeln("");
    }

    /// Emit runtime support structures and functions
    fn emit_runtime_prelude(&mut self) {
        // Standard includes
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                          INCLUDES                                   */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("#define _XOPEN_SOURCE 700");
        self.writeln("#include <stdint.h>");
        self.writeln("#include <stdbool.h>");
        self.writeln("#include <stddef.h>");
        self.writeln("#include <stdlib.h>");
        self.writeln("#include <string.h>");
        self.writeln("#include <stdio.h>");
        self.writeln("#include <setjmp.h>");
        self.writeln("#include <pthread.h>");
        self.writeln("");

        // Security level enum
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                       SECURITY LEVELS                               */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("typedef enum {");
        self.writeln("    RIINA_LEVEL_PUBLIC = 0,");
        self.writeln("    RIINA_LEVEL_INTERNAL = 1,");
        self.writeln("    RIINA_LEVEL_SESSION = 2,");
        self.writeln("    RIINA_LEVEL_USER = 3,");
        self.writeln("    RIINA_LEVEL_SYSTEM = 4,");
        self.writeln("    RIINA_LEVEL_SECRET = 5");
        self.writeln("} riina_security_level_t;");
        self.writeln("");

        // Effect enum
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                           EFFECTS                                   */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("typedef enum {");
        self.writeln("    RIINA_EFFECT_PURE = 0,");
        self.writeln("    RIINA_EFFECT_READ = 1,");
        self.writeln("    RIINA_EFFECT_WRITE = 2,");
        self.writeln("    RIINA_EFFECT_FILESYSTEM = 3,");
        self.writeln("    RIINA_EFFECT_NETWORK = 4,");
        self.writeln("    RIINA_EFFECT_NETWORK_SECURE = 5,");
        self.writeln("    RIINA_EFFECT_CRYPTO = 6,");
        self.writeln("    RIINA_EFFECT_RANDOM = 7,");
        self.writeln("    RIINA_EFFECT_SYSTEM = 8,");
        self.writeln("    RIINA_EFFECT_TIME = 9,");
        self.writeln("    RIINA_EFFECT_PROCESS = 10,");
        self.writeln("    RIINA_EFFECT_PANEL = 11,");
        self.writeln("    RIINA_EFFECT_ZIRAH = 12,");
        self.writeln("    RIINA_EFFECT_BENTENG = 13,");
        self.writeln("    RIINA_EFFECT_SANDI = 14,");
        self.writeln("    RIINA_EFFECT_MENARA = 15,");
        self.writeln("    RIINA_EFFECT_GAPURA = 16");
        self.writeln("} riina_effect_t;");
        self.writeln("");

        // Value type tags
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                         VALUE TAGS                                  */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("typedef enum {");
        self.writeln("    RIINA_TAG_UNIT = 0,");
        self.writeln("    RIINA_TAG_BOOL = 1,");
        self.writeln("    RIINA_TAG_INT = 2,");
        self.writeln("    RIINA_TAG_STRING = 3,");
        self.writeln("    RIINA_TAG_PAIR = 4,");
        self.writeln("    RIINA_TAG_SUM_LEFT = 5,");
        self.writeln("    RIINA_TAG_SUM_RIGHT = 6,");
        self.writeln("    RIINA_TAG_CLOSURE = 7,");
        self.writeln("    RIINA_TAG_REF = 8,");
        self.writeln("    RIINA_TAG_SECRET = 9,");
        self.writeln("    RIINA_TAG_PROOF = 10,");
        self.writeln("    RIINA_TAG_CAPABILITY = 11,");
        self.writeln("    RIINA_TAG_BIGINT = 12, /* arbitrary-precision integer (besar) */");
        self.writeln("    RIINA_TAG_DECIMAL = 13, /* arbitrary-precision decimal (perpuluhan) */");
        self.writeln("    RIINA_TAG_FIXED = 14, /* fixed-scale decimal money (wang/titik_tetap) */");
        self.writeln("    RIINA_TAG_FIXEDBIN = 15 /* binary fixed-point Q-format (qmn) */");
        self.writeln("} riina_tag_t;");
        self.writeln("");
        // Collection tags live with the enum so every consumer sees them
        // (`riina_binop_add` is emitted before the list machinery and needs
        // them). REQ-80: they MUST start past the last enum value — they used
        // to start at 12, colliding with RIINA_TAG_BIGINT/DECIMAL/FIXED, which
        // made a list indistinguishable from a bigint and segfaulted both ways.
        self.writeln("/* Extended tags for collections (must not collide with riina_tag_t) */");
        self.writeln("#define RIINA_TAG_LIST 16");
        self.writeln("#define RIINA_TAG_MAP 17");
        self.writeln("#define RIINA_TAG_SET 18");
        self.writeln("#define RIINA_LIST_DATA(v) ((riina_list_t*)(v)->data.wrapped_val)");
        self.writeln("/* REQ-80 guard: a future tag_t value must never reach the collection tags. */");
        self.writeln("#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L");
        self.writeln(
            "_Static_assert(RIINA_TAG_FIXEDBIN < RIINA_TAG_LIST, \"riina_tag_t grew into the collection tag range (REQ-80)\");",
        );
        self.writeln("#endif");
        self.writeln("");

        // Forward declare value type
        self.writeln("/* Forward declaration */");
        self.writeln("typedef struct riina_value riina_value_t;");
        self.writeln("");

        // Pair structure
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                       COMPOUND TYPES                                */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("typedef struct {");
        self.writeln("    riina_value_t* fst;");
        self.writeln("    riina_value_t* snd;");
        self.writeln("} riina_pair_t;");
        self.writeln("");

        // String structure
        self.writeln("typedef struct {");
        self.writeln("    char* data;");
        self.writeln("    size_t len;");
        self.writeln("} riina_string_t;");
        self.writeln("");

        // BigInt: sign-magnitude, little-endian base-2^32 limbs (mirrors
        // riina-codegen/src/bigint.rs). Magnitude is normalized (no trailing zero
        // limbs); len==0 / mag==NULL is zero, and neg is 0 for zero. Heap limbs
        // are leaked, matching this backend's value-allocation model.
        self.writeln("typedef struct {");
        self.writeln("    int neg;          /* sign; 0 for zero */");
        self.writeln("    uint32_t* mag;    /* little-endian limbs, normalized */");
        self.writeln("    size_t len;       /* number of limbs; 0 == zero */");
        self.writeln("} riina_bigint_t;");
        self.writeln("");

        // Decimal: an arbitrary-precision integer `mantissa` scaled by a power of
        // ten — value = mantissa * 10^(-scale) (mirrors riina-codegen/src/decimal.rs).
        self.writeln("typedef struct {");
        self.writeln("    riina_bigint_t mantissa;  /* the scaled integer */");
        self.writeln("    uint32_t scale;           /* value = mantissa * 10^-scale */");
        self.writeln("} riina_decimal_t;");
        self.writeln("");

        // Fixed-scale decimal money (`wang`/`titik_tetap`): same representation as
        // Decimal but the scale is fixed — arithmetic rounds back to it and
        // display preserves trailing zeros (mirrors riina-codegen/src/fixed.rs).
        self.writeln("typedef struct {");
        self.writeln("    riina_bigint_t mantissa;  /* the scaled integer */");
        self.writeln("    uint32_t scale;           /* fixed: value = mantissa * 10^-scale */");
        self.writeln("} riina_fixed_t;");
        self.writeln("");

        // Binary fixed-point / Q-format (`qmn`): value = raw / 2^frac_bits over a
        // bounded i64 word (mirrors riina-codegen/src/fixed_bin.rs).
        self.writeln("typedef struct {");
        self.writeln("    int64_t raw;        /* the scaled integer (wraps on overflow) */");
        self.writeln("    uint32_t frac_bits; /* value = raw / 2^frac_bits */");
        self.writeln("} riina_fixedbin_t;");
        self.writeln("");

        // Closure structure
        self.writeln("typedef struct {");
        self.writeln("    void* func_ptr;           /* Function pointer */");
        self.writeln("    riina_value_t** captures; /* Captured values */");
        self.writeln("    size_t num_captures;");
        self.writeln("} riina_closure_t;");
        self.writeln("");

        // Reference structure
        self.writeln("typedef struct {");
        self.writeln("    riina_value_t* value;");
        self.writeln("    riina_security_level_t level;");
        self.writeln("} riina_ref_t;");
        self.writeln("");

        // Tagged union value
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                      TAGGED UNION VALUE                             */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("struct riina_value {");
        self.writeln("    riina_tag_t tag;");
        self.writeln("    riina_security_level_t security;");
        self.writeln("    /* Numeric tower: for a signed sized int (Ty::IntN{signed}) this is the");
        self.writeln("       bit width (8/16/32/64) so format/compare/div sign-extend; 0 for plain");
        self.writeln("       or unsigned ints, which keep unsigned semantics (zeroed by calloc). */");
        self.writeln("    uint8_t int_signed_bits;");
        self.writeln("    union {");
        self.writeln("        /* RIINA_TAG_UNIT: no data */");
        self.writeln("        bool bool_val;              /* RIINA_TAG_BOOL */");
        self.writeln("        uint64_t int_val;           /* RIINA_TAG_INT */");
        self.writeln("        riina_string_t string_val;  /* RIINA_TAG_STRING */");
        self.writeln("        riina_pair_t pair_val;      /* RIINA_TAG_PAIR */");
        self.writeln("        riina_value_t* sum_val;     /* RIINA_TAG_SUM_LEFT/RIGHT */");
        self.writeln("        riina_closure_t closure_val;/* RIINA_TAG_CLOSURE */");
        self.writeln("        riina_ref_t ref_val;        /* RIINA_TAG_REF */");
        self.writeln("        riina_value_t* wrapped_val; /* RIINA_TAG_SECRET/PROOF */");
        self.writeln("        riina_effect_t cap_val;     /* RIINA_TAG_CAPABILITY */");
        self.writeln("        riina_bigint_t bigint_val;  /* RIINA_TAG_BIGINT */");
        self.writeln("        riina_decimal_t decimal_val;/* RIINA_TAG_DECIMAL */");
        self.writeln("        riina_fixed_t fixed_val;    /* RIINA_TAG_FIXED */");
        self.writeln("        riina_fixedbin_t fixedbin_val;/* RIINA_TAG_FIXEDBIN */");
        self.writeln("    } data;");
        self.writeln("};");
        self.writeln("");

        // Runtime context
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                      RUNTIME CONTEXT                                */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("typedef struct {");
        self.writeln("    riina_security_level_t current_level;");
        self.writeln("    uint32_t capabilities;  /* Bitmask of held capabilities */");
        self.writeln("} riina_context_t;");
        self.writeln("");
        self.writeln("static riina_context_t riina_ctx = {");
        self.writeln("    .current_level = RIINA_LEVEL_PUBLIC,");
        self.writeln("    .capabilities = 0");
        self.writeln("};");
        self.writeln("");

        // Value constructors
        self.emit_runtime_constructors();

        // BigInt (besar) runtime — must precede the binop/builtin helpers that use it.
        self.emit_bigint_runtime();

        // Decimal (perpuluhan) runtime — built on the BigInt runtime above, so it
        // must follow it (and precede the binop/builtin helpers that dispatch it).
        self.emit_decimal_runtime();

        // Fixed-point runtimes — built on the BigInt + Decimal runtimes above
        // (they reuse the round-half-even and decimal render helpers), so they
        // must follow both (and precede the binop/builtin helpers).
        self.emit_fixed_runtime();
        self.emit_fixedbin_runtime();

        // Runtime helpers
        self.emit_runtime_helpers();

        // Security checks
        self.emit_security_checks();

        // Builtin function helpers
        self.emit_builtin_helpers();

        // JALINAN runtime (actors, CRDTs, content-addressed)
        self.emit_jalinan_runtime();
    }

    /// Emit value constructor functions
    fn emit_runtime_constructors(&mut self) {
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                     VALUE CONSTRUCTORS                              */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        // Allocator
        self.writeln("static riina_value_t* riina_alloc(void) {");
        self.writeln("    riina_value_t* v = (riina_value_t*)calloc(1, sizeof(riina_value_t));");
        self.writeln("    if (!v) {");
        self.writeln("        fprintf(stderr, \"RIINA: Out of memory\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Unit
        self.writeln("static riina_value_t* riina_unit(void) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_UNIT;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Bool
        self.writeln("static riina_value_t* riina_bool(bool b) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_BOOL;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    v->data.bool_val = b;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Int
        self.writeln("static riina_value_t* riina_int(uint64_t n) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_INT;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    v->data.int_val = n;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Numeric tower: sign-extend a width-`bits` two's-complement bit pattern
        // to int64 (identity for bits 0/>=64). Used by signed format/compare/div.
        self.writeln("static int64_t riina_sext(uint64_t v, unsigned bits) {");
        self.writeln("    if (bits == 0 || bits >= 64) return (int64_t)v;");
        self.writeln("    unsigned sh = 64u - bits;");
        self.writeln("    return ((int64_t)(v << sh)) >> sh;");
        self.writeln("}");
        self.writeln("");

        // A sized integer: tags the value with its signed width (so signed values
        // sign-extend on display/compare/div). Unsigned ⇒ tag 0 ⇒ unsigned semantics.
        self.writeln(
            "static riina_value_t* riina_int_sized(uint64_t n, unsigned bits, int is_signed) {",
        );
        self.writeln("    riina_value_t* v = riina_int(n);");
        self.writeln("    if (is_signed) v->int_signed_bits = (uint8_t)bits;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // The signed width governing a binary op: the signed operand's width (0 if
        // neither is a signed sized int ⇒ the unsigned path).
        self.writeln(
            "static unsigned riina_swidth(riina_value_t* a, riina_value_t* b) {",
        );
        self.writeln("    return a->int_signed_bits ? a->int_signed_bits : b->int_signed_bits;");
        self.writeln("}");
        self.writeln("");

        // Reduce a boxed integer to its declared bit width (`Ty::IntN`).
        // Add/Sub/Mul/Div/Mod whose result types as a sized integer are wrapped
        // through this so compiled arithmetic overflows modulo 2^bits, matching the
        // interpreter; a signed result is tagged so it later prints/compares signed.
        self.writeln(
            "static riina_value_t* riina_trunc(riina_value_t* v, unsigned bits, int is_signed) {",
        );
        self.writeln("    uint64_t masked = (bits >= 64) ? v->data.int_val");
        self.writeln("                                   : (v->data.int_val & (((uint64_t)1 << bits) - 1u));");
        self.writeln("    return riina_int_sized(masked, bits, is_signed);");
        self.writeln("}");
        self.writeln("");

        // String
        self.writeln("static riina_value_t* riina_string(const char* s) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_STRING;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    size_t len = strlen(s);");
        self.writeln("    v->data.string_val.data = (char*)malloc(len + 1);");
        self.writeln("    if (!v->data.string_val.data) abort();");
        self.writeln("    memcpy(v->data.string_val.data, s, len + 1);");
        self.writeln("    v->data.string_val.len = len;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // String concat
        self.writeln(
            "static riina_value_t* riina_string_concat(riina_value_t* a, riina_value_t* b) {",
        );
        self.writeln("    if (a->tag != RIINA_TAG_STRING || b->tag != RIINA_TAG_STRING) {");
        self.writeln(
            "        fprintf(stderr, \"RIINA: string_concat on non-string\\n\"); abort();",
        );
        self.writeln("    }");
        self.writeln("    size_t len = a->data.string_val.len + b->data.string_val.len;");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_STRING;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    v->data.string_val.data = (char*)malloc(len + 1);");
        self.writeln("    if (!v->data.string_val.data) abort();");
        self.writeln(
            "    memcpy(v->data.string_val.data, a->data.string_val.data, a->data.string_val.len);",
        );
        self.writeln("    memcpy(v->data.string_val.data + a->data.string_val.len, b->data.string_val.data, b->data.string_val.len + 1);");
        self.writeln("    v->data.string_val.len = len;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // String length
        self.writeln("static riina_value_t* riina_string_length(riina_value_t* s) {");
        self.writeln("    if (s->tag != RIINA_TAG_STRING) {");
        self.writeln(
            "        fprintf(stderr, \"RIINA: string_length on non-string\\n\"); abort();",
        );
        self.writeln("    }");
        self.writeln("    return riina_int((uint64_t)s->data.string_val.len);");
        self.writeln("}");
        self.writeln("");

        // String equality
        self.writeln("static riina_value_t* riina_string_eq(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag != RIINA_TAG_STRING || b->tag != RIINA_TAG_STRING) {");
        self.writeln("        fprintf(stderr, \"RIINA: string_eq on non-string\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    bool eq = (a->data.string_val.len == b->data.string_val.len) &&");
        self.writeln("              (memcmp(a->data.string_val.data, b->data.string_val.data, a->data.string_val.len) == 0);");
        self.writeln("    return riina_bool(eq);");
        self.writeln("}");
        self.writeln("");

        // Pair
        self.writeln("static riina_value_t* riina_pair(riina_value_t* fst, riina_value_t* snd) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_PAIR;");
        self.writeln("    /* Pair is secret if either component is secret */");
        self.writeln("    v->security = (fst->security == RIINA_LEVEL_SECRET || ");
        self.writeln("                   snd->security == RIINA_LEVEL_SECRET) ");
        self.writeln("                  ? RIINA_LEVEL_SECRET : RIINA_LEVEL_PUBLIC;");
        self.writeln("    v->data.pair_val.fst = fst;");
        self.writeln("    v->data.pair_val.snd = snd;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Fst
        self.writeln("static riina_value_t* riina_fst(riina_value_t* pair) {");
        self.writeln("    if (pair->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: fst on non-pair\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return pair->data.pair_val.fst;");
        self.writeln("}");
        self.writeln("");

        // Snd
        self.writeln("static riina_value_t* riina_snd(riina_value_t* pair) {");
        self.writeln("    if (pair->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: snd on non-pair\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return pair->data.pair_val.snd;");
        self.writeln("}");
        self.writeln("");

        // Inl
        self.writeln("static riina_value_t* riina_inl(riina_value_t* val) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_SUM_LEFT;");
        self.writeln("    v->security = val->security;");
        self.writeln("    v->data.sum_val = val;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Inr
        self.writeln("static riina_value_t* riina_inr(riina_value_t* val) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_SUM_RIGHT;");
        self.writeln("    v->security = val->security;");
        self.writeln("    v->data.sum_val = val;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Is_left
        self.writeln("static bool riina_is_left(riina_value_t* sum) {");
        self.writeln("    return sum->tag == RIINA_TAG_SUM_LEFT;");
        self.writeln("}");
        self.writeln("");

        // Unwrap left
        self.writeln("static riina_value_t* riina_unwrap_left(riina_value_t* sum) {");
        self.writeln("    if (sum->tag != RIINA_TAG_SUM_LEFT) {");
        self.writeln("        fprintf(stderr, \"RIINA: unwrap_left on non-left\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return sum->data.sum_val;");
        self.writeln("}");
        self.writeln("");

        // Unwrap right
        self.writeln("static riina_value_t* riina_unwrap_right(riina_value_t* sum) {");
        self.writeln("    if (sum->tag != RIINA_TAG_SUM_RIGHT) {");
        self.writeln("        fprintf(stderr, \"RIINA: unwrap_right on non-right\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return sum->data.sum_val;");
        self.writeln("}");
        self.writeln("");

        // Reference
        self.writeln(
            "static riina_value_t* riina_ref(riina_value_t* init, riina_security_level_t level) {",
        );
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_REF;");
        self.writeln("    v->security = level;");
        self.writeln("    v->data.ref_val.value = init;");
        self.writeln("    v->data.ref_val.level = level;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Load.
        //
        // `!` is overloaded in the surface language: a dereference on a
        // reference, logical negation on a boolean. The typechecker accepts
        // both (`Expr::Deref` on `Ty::Bool` yields `Ty::Bool`) and the
        // interpreter dispatches on the runtime value — but the C backend used
        // to abort on anything that was not a ref, so `kalau !sah { ... }`
        // type-checked, ran correctly under `riinac run`, compiled without a
        // murmur, and then died at runtime with "load on non-ref". Dispatch on
        // the tag here, exactly as the interpreter does.
        self.writeln("static riina_value_t* riina_load(riina_value_t* ref) {");
        self.writeln("    if (ref->tag == RIINA_TAG_BOOL) {");
        self.writeln("        return riina_bool(!ref->data.bool_val);");
        self.writeln("    }");
        self.writeln("    if (ref->tag != RIINA_TAG_REF) {");
        self.writeln("        fprintf(stderr, \"RIINA: load on non-ref\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return ref->data.ref_val.value;");
        self.writeln("}");
        self.writeln("");

        // Store
        self.writeln("static riina_value_t* riina_store(riina_value_t* ref, riina_value_t* val) {");
        self.writeln("    if (ref->tag != RIINA_TAG_REF) {");
        self.writeln("        fprintf(stderr, \"RIINA: store on non-ref\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    /* Security check: don't store secret in public ref */");
        self.writeln("    if (val->security == RIINA_LEVEL_SECRET && ");
        self.writeln("        ref->data.ref_val.level == RIINA_LEVEL_PUBLIC) {");
        self.writeln("        fprintf(stderr, \"RIINA: security violation - storing secret in public ref\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    ref->data.ref_val.value = val;");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // Classify
        self.writeln("static riina_value_t* riina_classify(riina_value_t* val) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_SECRET;");
        self.writeln("    v->security = RIINA_LEVEL_SECRET;");
        self.writeln("    v->data.wrapped_val = val;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        self.writeln("static bool riina_value_eq(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a == b) return true;");
        self.writeln("    if (!a || !b) return false;");
        self.writeln("    if (a->tag != b->tag) return false;");
        self.writeln("    switch (a->tag) {");
        self.writeln("        case RIINA_TAG_UNIT:");
        self.writeln("            return true;");
        self.writeln("        case RIINA_TAG_BOOL:");
        self.writeln("            return a->data.bool_val == b->data.bool_val;");
        self.writeln("        case RIINA_TAG_INT:");
        self.writeln("            return a->data.int_val == b->data.int_val;");
        self.writeln("        case RIINA_TAG_STRING:");
        self.writeln(
            "            return strcmp(a->data.string_val.data, b->data.string_val.data) == 0;",
        );
        self.writeln("        case RIINA_TAG_SECRET:");
        self.writeln("        case RIINA_TAG_PROOF:");
        self.writeln(
            "            return riina_value_eq(a->data.wrapped_val, b->data.wrapped_val);",
        );
        self.writeln("        default:");
        self.writeln("            return false;");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("");

        // Declassify
        self.writeln(
            "static riina_value_t* riina_declassify(riina_value_t* secret, riina_value_t* proof) {",
        );
        self.writeln("    if (secret->tag != RIINA_TAG_SECRET) {");
        self.writeln("        return secret;");
        self.writeln("    }");
        self.writeln("    if (!proof || proof->tag != RIINA_TAG_PROOF) {");
        self.writeln("        fprintf(stderr, \"RIINA: invalid declassification proof\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    riina_value_t* proved_value = proof->data.wrapped_val;");
        self.writeln("    if (!proved_value || proved_value->tag != RIINA_TAG_SECRET) {");
        self.writeln(
            "        fprintf(stderr, \"RIINA: declassification proof must wrap a secret\\n\");",
        );
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln(
            "    if (!riina_value_eq(secret->data.wrapped_val, proved_value->data.wrapped_val)) {",
        );
        self.writeln(
            "        fprintf(stderr, \"RIINA: declassification proof does not match secret\\n\");",
        );
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return secret->data.wrapped_val;");
        self.writeln("}");
        self.writeln("");

        // Prove
        self.writeln("static riina_value_t* riina_prove(riina_value_t* val) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_PROOF;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    v->data.wrapped_val = val;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");

        // Capability
        self.writeln("static riina_value_t* riina_capability(riina_effect_t eff) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_CAPABILITY;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    v->data.cap_val = eff;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");
    }

    /// Emit the BigInt (`besar`) runtime: a faithful C port of the dependency-free
    /// bignum in `riina-codegen/src/bigint.rs` (little-endian base-2^32 limbs,
    /// schoolbook add/mul, bit-serial truncating divmod, base-10 parse/render),
    /// so a compiled `besar` program produces byte-identical output to the
    /// interpreter. Limbs are malloc'd and leaked, like every other boxed value.
    fn emit_bigint_runtime(&mut self) {
        self.output.push_str(
            r##"/* ═══════════════════════════════════════════════════════════════════ */
/*                       BIGINT (besar) RUNTIME                        */
/* ═══════════════════════════════════════════════════════════════════ */

/* Strip trailing zero limbs; return the normalized length. */
static size_t riina_bi_norm(uint32_t* mag, size_t len) {
    while (len > 0 && mag[len - 1] == 0) len--;
    return len;
}

/* Box a magnitude into a BigInt value (takes ownership of `mag`; forces the
   sign to non-negative when the value is zero). */
static riina_value_t* riina_bigint_mk(int neg, uint32_t* mag, size_t len) {
    len = riina_bi_norm(mag, len);
    riina_value_t* v = riina_alloc();
    v->tag = RIINA_TAG_BIGINT;
    v->security = RIINA_LEVEL_PUBLIC;
    v->data.bigint_val.neg = (len == 0) ? 0 : (neg ? 1 : 0);
    v->data.bigint_val.mag = mag;
    v->data.bigint_val.len = len;
    return v;
}

/* Compare magnitudes: -1 / 0 / 1. */
static int riina_bi_cmp_mag(const uint32_t* a, size_t na, const uint32_t* b, size_t nb) {
    if (na != nb) return na < nb ? -1 : 1;
    for (size_t i = na; i-- > 0;) {
        if (a[i] != b[i]) return a[i] < b[i] ? -1 : 1;
    }
    return 0;
}

static uint32_t* riina_bi_add_mag(const uint32_t* a, size_t na,
                                  const uint32_t* b, size_t nb, size_t* outlen) {
    size_t n = na > nb ? na : nb;
    uint32_t* out = (uint32_t*)malloc((n + 1) * sizeof(uint32_t));
    if (!out) abort();
    uint64_t carry = 0;
    for (size_t i = 0; i < n; i++) {
        uint64_t av = i < na ? a[i] : 0;
        uint64_t bv = i < nb ? b[i] : 0;
        uint64_t s = av + bv + carry;
        out[i] = (uint32_t)(s & 0xffffffffu);
        carry = s >> 32;
    }
    out[n] = (uint32_t)carry;
    *outlen = riina_bi_norm(out, n + 1);
    return out;
}

/* a - b, requires a >= b (magnitudes). */
static uint32_t* riina_bi_sub_mag(const uint32_t* a, size_t na,
                                  const uint32_t* b, size_t nb, size_t* outlen) {
    uint32_t* out = (uint32_t*)malloc((na ? na : 1) * sizeof(uint32_t));
    if (!out) abort();
    int64_t borrow = 0;
    for (size_t i = 0; i < na; i++) {
        int64_t av = (int64_t)a[i];
        int64_t bv = i < nb ? (int64_t)b[i] : 0;
        int64_t d = av - bv - borrow;
        if (d < 0) { d += ((int64_t)1 << 32); borrow = 1; } else { borrow = 0; }
        out[i] = (uint32_t)d;
    }
    *outlen = riina_bi_norm(out, na);
    return out;
}

static uint32_t* riina_bi_mul_mag(const uint32_t* a, size_t na,
                                  const uint32_t* b, size_t nb, size_t* outlen) {
    if (na == 0 || nb == 0) { *outlen = 0; return (uint32_t*)malloc(1); }
    size_t n = na + nb;
    uint32_t* out = (uint32_t*)calloc(n, sizeof(uint32_t));
    if (!out) abort();
    for (size_t i = 0; i < na; i++) {
        uint64_t carry = 0;
        for (size_t j = 0; j < nb; j++) {
            uint64_t cur = (uint64_t)out[i + j] + (uint64_t)a[i] * (uint64_t)b[j] + carry;
            out[i + j] = (uint32_t)(cur & 0xffffffffu);
            carry = cur >> 32;
        }
        out[i + nb] += (uint32_t)carry;
    }
    *outlen = riina_bi_norm(out, n);
    return out;
}

/* In-place <<= 1 on a magnitude held in a buffer of capacity `cap`. */
static size_t riina_bi_shl1(uint32_t* r, size_t len, size_t cap) {
    uint32_t carry = 0;
    for (size_t i = 0; i < len; i++) {
        uint32_t nc = r[i] >> 31;
        r[i] = (r[i] << 1) | carry;
        carry = nc;
    }
    if (carry && len < cap) { r[len] = carry; len++; }
    return len;
}

/* Unsigned long division by shift-and-subtract: q = u / v, r = u % v. */
static void riina_bi_divmod_mag(const uint32_t* u, size_t nu, const uint32_t* v, size_t nv,
                                uint32_t** qout, size_t* qlen, uint32_t** rout, size_t* rlen) {
    if (riina_bi_cmp_mag(u, nu, v, nv) < 0) {
        uint32_t* r = (uint32_t*)malloc((nu ? nu : 1) * sizeof(uint32_t));
        for (size_t i = 0; i < nu; i++) r[i] = u[i];
        *qout = (uint32_t*)malloc(1); *qlen = 0;
        *rout = r; *rlen = nu;
        return;
    }
    size_t total_bits = nu * 32;
    uint32_t* q = (uint32_t*)calloc(nu ? nu : 1, sizeof(uint32_t));
    size_t rcap = nu + 1;
    uint32_t* r = (uint32_t*)calloc(rcap, sizeof(uint32_t));
    if (!q || !r) abort();
    size_t rl = 0;
    for (size_t bi = total_bits; bi-- > 0;) {
        rl = riina_bi_shl1(r, rl, rcap);
        size_t limb = bi / 32, off = bi % 32;
        if ((u[limb] >> off) & 1u) {
            if (rl == 0) { r[0] = 1; rl = 1; } else { r[0] |= 1u; }
        }
        if (riina_bi_cmp_mag(r, rl, v, nv) >= 0) {
            size_t nl;
            uint32_t* nr = riina_bi_sub_mag(r, rl, v, nv, &nl);
            for (size_t i = 0; i < nl; i++) r[i] = nr[i];
            for (size_t i = nl; i < rl; i++) r[i] = 0;
            rl = nl;
            free(nr);
            q[limb] |= (uint32_t)1u << off;
        }
    }
    *qout = q; *qlen = riina_bi_norm(q, nu);
    *rout = r; *rlen = rl;
}

/* acc*m + add (scalar), used by base-10 parsing. */
static uint32_t* riina_bi_muladd_small(const uint32_t* a, size_t na,
                                       uint32_t m, uint32_t add, size_t* outlen) {
    uint32_t* out = (uint32_t*)malloc((na + 2) * sizeof(uint32_t));
    if (!out) abort();
    uint64_t carry = add;
    for (size_t i = 0; i < na; i++) {
        uint64_t cur = (uint64_t)a[i] * m + carry;
        out[i] = (uint32_t)(cur & 0xffffffffu);
        carry = cur >> 32;
    }
    size_t len = na;
    while (carry) { out[len++] = (uint32_t)(carry & 0xffffffffu); carry >>= 32; }
    *outlen = riina_bi_norm(out, len);
    return out;
}

/* Parse a base-10 string (optional leading +/-) into a BigInt value. */
static riina_value_t* riina_bigint_from_str(const char* s) {
    int neg = 0; size_t i = 0;
    if (s[0] == '-') { neg = 1; i = 1; } else if (s[0] == '+') { i = 1; }
    uint32_t* mag = (uint32_t*)malloc(1); size_t len = 0;
    for (; s[i]; i++) {
        if (s[i] < '0' || s[i] > '9') {
            fprintf(stderr, "RIINA: besar: '%s' is not a base-10 integer\n", s);
            abort();
        }
        size_t nl;
        uint32_t* nm = riina_bi_muladd_small(mag, len, 10u, (uint32_t)(s[i] - '0'), &nl);
        free(mag); mag = nm; len = nl;
    }
    return riina_bigint_mk(neg, mag, len);
}

/* Render a BigInt in base 10 (sign + 9-digit groups via division by 10^9). */
static char* riina_bigint_to_str(riina_value_t* v) {
    riina_bigint_t* b = &v->data.bigint_val;
    if (b->len == 0) { char* z = (char*)malloc(2); z[0] = '0'; z[1] = 0; return z; }
    size_t len = b->len;
    uint32_t* m = (uint32_t*)malloc(len * sizeof(uint32_t));
    if (!m) abort();
    for (size_t i = 0; i < len; i++) m[i] = b->mag[i];
    uint32_t* groups = (uint32_t*)malloc((len * 10 + 1) * sizeof(uint32_t));
    if (!groups) abort();
    size_t ng = 0;
    while (len > 0) {
        uint64_t rem = 0;
        for (size_t i = len; i-- > 0;) {
            uint64_t cur = (rem << 32) | m[i];
            m[i] = (uint32_t)(cur / 1000000000ull);
            rem = cur % 1000000000ull;
        }
        groups[ng++] = (uint32_t)rem;
        while (len > 0 && m[len - 1] == 0) len--;
    }
    char* out = (char*)malloc(ng * 9 + 2);
    if (!out) abort();
    size_t pos = 0;
    if (b->neg) out[pos++] = '-';
    pos += (size_t)sprintf(out + pos, "%u", groups[ng - 1]);
    for (size_t i = ng - 1; i-- > 0;) {
        pos += (size_t)sprintf(out + pos, "%09u", groups[i]);
    }
    out[pos] = 0;
    free(m); free(groups);
    return out;
}

/* Signed value-level operations (truncated division: quotient toward zero,
   remainder takes the dividend's sign — Rust/C semantics). */
static riina_value_t* riina_bigint_add(riina_value_t* x, riina_value_t* y) {
    riina_bigint_t* a = &x->data.bigint_val; riina_bigint_t* b = &y->data.bigint_val;
    size_t ol;
    if (a->neg == b->neg) {
        uint32_t* m = riina_bi_add_mag(a->mag, a->len, b->mag, b->len, &ol);
        return riina_bigint_mk(a->neg, m, ol);
    }
    int c = riina_bi_cmp_mag(a->mag, a->len, b->mag, b->len);
    if (c == 0) return riina_bigint_mk(0, (uint32_t*)malloc(1), 0);
    if (c > 0) {
        uint32_t* m = riina_bi_sub_mag(a->mag, a->len, b->mag, b->len, &ol);
        return riina_bigint_mk(a->neg, m, ol);
    }
    uint32_t* m = riina_bi_sub_mag(b->mag, b->len, a->mag, a->len, &ol);
    return riina_bigint_mk(b->neg, m, ol);
}

static riina_value_t* riina_bigint_neg(riina_value_t* x) {
    riina_bigint_t* a = &x->data.bigint_val;
    uint32_t* m = (uint32_t*)malloc((a->len ? a->len : 1) * sizeof(uint32_t));
    if (!m) abort();
    for (size_t i = 0; i < a->len; i++) m[i] = a->mag[i];
    return riina_bigint_mk(a->len ? !a->neg : 0, m, a->len);
}

static riina_value_t* riina_bigint_sub(riina_value_t* x, riina_value_t* y) {
    return riina_bigint_add(x, riina_bigint_neg(y));
}

static riina_value_t* riina_bigint_mul(riina_value_t* x, riina_value_t* y) {
    riina_bigint_t* a = &x->data.bigint_val; riina_bigint_t* b = &y->data.bigint_val;
    size_t ol;
    uint32_t* m = riina_bi_mul_mag(a->mag, a->len, b->mag, b->len, &ol);
    return riina_bigint_mk(a->neg ^ b->neg, m, ol);
}

static int riina_bigint_cmp(riina_value_t* x, riina_value_t* y) {
    riina_bigint_t* a = &x->data.bigint_val; riina_bigint_t* b = &y->data.bigint_val;
    if (a->neg != b->neg) return a->neg ? -1 : 1;
    int c = riina_bi_cmp_mag(a->mag, a->len, b->mag, b->len);
    return a->neg ? -c : c;
}

static void riina_bigint_divmod(riina_value_t* x, riina_value_t* y,
                                riina_value_t** q, riina_value_t** r) {
    riina_bigint_t* a = &x->data.bigint_val; riina_bigint_t* b = &y->data.bigint_val;
    if (b->len == 0) { fprintf(stderr, "RIINA: bigint division by zero\n"); abort(); }
    uint32_t *qm, *rm; size_t ql, rl;
    riina_bi_divmod_mag(a->mag, a->len, b->mag, b->len, &qm, &ql, &rm, &rl);
    *q = riina_bigint_mk(a->neg ^ b->neg, qm, ql);
    *r = riina_bigint_mk(a->neg, rm, rl);
}

/* The `besar`/`bigint` constructor builtin (String -> BigInt). */
static riina_value_t* riina_builtin_besar(riina_value_t* arg) {
    if (arg->tag == RIINA_TAG_STRING) return riina_bigint_from_str(arg->data.string_val.data);
    if (arg->tag == RIINA_TAG_BIGINT) return arg;
    if (arg->tag == RIINA_TAG_INT) {
        char buf[32];
        snprintf(buf, sizeof(buf), "%llu", (unsigned long long)arg->data.int_val);
        return riina_bigint_from_str(buf);
    }
    fprintf(stderr, "RIINA: besar expects a string or int\n");
    abort();
}

"##,
        );
    }

    /// Emit the Decimal (`perpuluhan`) runtime: a faithful C port of the
    /// arbitrary-precision exact-base-10 decimal in
    /// `riina-codegen/src/decimal.rs` (a [`riina_bigint_t`] mantissa scaled by a
    /// power of ten — value = mantissa·10^-scale). Built on the BigInt runtime
    /// above (it reuses `riina_bigint_{add,sub,mul,neg,cmp,divmod,from_str,to_str}`),
    /// so a compiled `perpuluhan` program produces byte-identical output to the
    /// interpreter. The arithmetic is the one the Coq model
    /// `foundations/DecimalModel.v` proves is a ring homomorphism to ℚ.
    fn emit_decimal_runtime(&mut self) {
        self.output.push_str(
            r##"/* ═══════════════════════════════════════════════════════════════════ */
/*                     DECIMAL (perpuluhan) RUNTIME                    */
/* ═══════════════════════════════════════════════════════════════════ */

/* Non-terminating division rounds half-to-even to this many fractional
   digits before trailing zeros are stripped (mirrors decimal.rs DIV_SCALE). */
#define RIINA_DEC_DIV_SCALE 34u

/* Wrap a bare (neg,mag,len) magnitude as a temporary BigInt value so the
   BigInt value-level ops can be reused on a decimal's mantissa. */
static riina_value_t riina_bi_wrap(int neg, uint32_t* mag, size_t len) {
    riina_value_t v;
    v.tag = RIINA_TAG_BIGINT;
    v.security = RIINA_LEVEL_PUBLIC;
    v.int_signed_bits = 0;
    v.data.bigint_val.neg = neg;
    v.data.bigint_val.mag = mag;
    v.data.bigint_val.len = len;
    return v;
}

/* Box a BigInt value's magnitude + a scale into a Decimal value. */
static riina_value_t* riina_decimal_from_bi(riina_value_t* m, uint32_t scale) {
    riina_value_t* v = riina_alloc();
    v->tag = RIINA_TAG_DECIMAL;
    v->security = RIINA_LEVEL_PUBLIC;
    v->data.decimal_val.mantissa = m->data.bigint_val;
    v->data.decimal_val.scale = scale;
    return v;
}

/* 10^k as a BigInt value (k small — a decimal scale). */
static riina_value_t* riina_dec_pow10(uint32_t k) {
    riina_value_t* r = riina_bigint_from_str("1");
    riina_value_t* ten = riina_bigint_from_str("10");
    for (uint32_t i = 0; i < k; i++) r = riina_bigint_mul(r, ten);
    return r;
}

/* The two scales' max — the common scale add/sub/compare align to. */
static uint32_t riina_dec_common_scale(riina_value_t* a, riina_value_t* b) {
    uint32_t sa = a->data.decimal_val.scale, sb = b->data.decimal_val.scale;
    return sa > sb ? sa : sb;
}

/* `d`'s mantissa re-expressed at common scale `s`: mantissa * 10^(s - d.scale). */
static riina_value_t* riina_dec_aligned(riina_value_t* d, uint32_t s) {
    riina_bigint_t* m = &d->data.decimal_val.mantissa;
    riina_value_t mv = riina_bi_wrap(m->neg, m->mag, m->len);
    riina_value_t* p = riina_dec_pow10(s - d->data.decimal_val.scale);
    return riina_bigint_mul(&mv, p);
}

/* |x| for a BigInt value. */
static riina_value_t* riina_dec_abs(riina_value_t* x) {
    if (x->data.bigint_val.neg) return riina_bigint_neg(x);
    return x;
}

/* Increment the magnitude of `q` by one in the direction of `negative`. */
static riina_value_t* riina_dec_bump(riina_value_t* q, int negative) {
    riina_value_t* one = riina_bigint_from_str("1");
    return negative ? riina_bigint_sub(q, one) : riina_bigint_add(q, one);
}

static riina_value_t* riina_decimal_add(riina_value_t* a, riina_value_t* b) {
    uint32_t s = riina_dec_common_scale(a, b);
    return riina_decimal_from_bi(riina_bigint_add(riina_dec_aligned(a, s),
                                                  riina_dec_aligned(b, s)), s);
}

static riina_value_t* riina_decimal_sub(riina_value_t* a, riina_value_t* b) {
    uint32_t s = riina_dec_common_scale(a, b);
    return riina_decimal_from_bi(riina_bigint_sub(riina_dec_aligned(a, s),
                                                  riina_dec_aligned(b, s)), s);
}

static riina_value_t* riina_decimal_mul(riina_value_t* a, riina_value_t* b) {
    riina_bigint_t* ma = &a->data.decimal_val.mantissa;
    riina_bigint_t* mb = &b->data.decimal_val.mantissa;
    riina_value_t av = riina_bi_wrap(ma->neg, ma->mag, ma->len);
    riina_value_t bv = riina_bi_wrap(mb->neg, mb->mag, mb->len);
    return riina_decimal_from_bi(riina_bigint_mul(&av, &bv),
        a->data.decimal_val.scale + b->data.decimal_val.scale);
}

static riina_value_t* riina_decimal_neg(riina_value_t* a) {
    riina_bigint_t* m = &a->data.decimal_val.mantissa;
    riina_value_t mv = riina_bi_wrap(m->neg, m->mag, m->len);
    return riina_decimal_from_bi(riina_bigint_neg(&mv), a->data.decimal_val.scale);
}

/* Value-based comparison (scale-insensitive): aligns then compares mantissas. */
static int riina_decimal_cmp(riina_value_t* a, riina_value_t* b) {
    uint32_t s = riina_dec_common_scale(a, b);
    return riina_bigint_cmp(riina_dec_aligned(a, s), riina_dec_aligned(b, s));
}

/* Strip trailing zero fractional digits (2.500 -> 2.5), reducing the scale. */
static riina_value_t* riina_decimal_stripped(riina_value_t* d) {
    riina_bigint_t* m = &d->data.decimal_val.mantissa;
    riina_value_t* ten = riina_bigint_from_str("10");
    uint32_t scale = d->data.decimal_val.scale;
    riina_value_t cur_box = riina_bi_wrap(m->neg, m->mag, m->len);
    riina_value_t* cur = &cur_box;
    while (scale > 0) {
        riina_value_t *q, *r;
        riina_bigint_divmod(cur, ten, &q, &r);
        if (r->data.bigint_val.len != 0) break;   /* not divisible by 10 */
        cur = q; scale--;
    }
    return riina_decimal_from_bi(cur, scale);
}

/* self / other, rounded half-to-even to RIINA_DEC_DIV_SCALE places then
   stripped. Mirrors decimal.rs::div exactly. */
static riina_value_t* riina_decimal_div(riina_value_t* a, riina_value_t* b) {
    riina_decimal_t* da = &a->data.decimal_val;
    riina_decimal_t* db = &b->data.decimal_val;
    if (db->mantissa.len == 0) {
        fprintf(stderr, "RIINA: decimal division by zero\n");
        abort();
    }
    long long shift = (long long)RIINA_DEC_DIV_SCALE
                    + (long long)db->scale - (long long)da->scale;
    riina_value_t amv = riina_bi_wrap(da->mantissa.neg, da->mantissa.mag, da->mantissa.len);
    riina_value_t bmv = riina_bi_wrap(db->mantissa.neg, db->mantissa.mag, db->mantissa.len);
    riina_value_t *num, *den;
    if (shift >= 0) {
        num = riina_bigint_mul(&amv, riina_dec_pow10((uint32_t)shift));
        den = riina_bigint_from_str("1"); *den = bmv;
    } else {
        num = riina_bigint_from_str("1"); *num = amv;
        den = riina_bigint_mul(&bmv, riina_dec_pow10((uint32_t)(-shift)));
    }
    riina_value_t *q, *r;
    riina_bigint_divmod(num, den, &q, &r);
    /* Round half-to-even on |2r| vs |den|. */
    riina_value_t* two = riina_bigint_from_str("2");
    riina_value_t* two_abs_r = riina_bigint_mul(riina_dec_abs(r), two);
    riina_value_t* abs_den = riina_dec_abs(den);
    int result_neg = (da->mantissa.neg ^ db->mantissa.neg) ? 1 : 0;
    int c = riina_bigint_cmp(two_abs_r, abs_den);
    if (c > 0) {
        q = riina_dec_bump(q, result_neg);
    } else if (c == 0) {
        riina_value_t *qq, *parity;
        riina_bigint_divmod(q, two, &qq, &parity);
        if (parity->data.bigint_val.len != 0) q = riina_dec_bump(q, result_neg);
    }
    return riina_decimal_stripped(riina_decimal_from_bi(q, RIINA_DEC_DIV_SCALE));
}

/* Parse a decimal literal (optional sign, integer part, optional '.frac'). */
static riina_value_t* riina_decimal_from_str(const char* s0) {
    const char* s = s0;
    while (*s == ' ' || *s == '\t' || *s == '\n' || *s == '\r') s++;
    size_t n = strlen(s);
    while (n > 0 && (s[n-1]==' '||s[n-1]=='\t'||s[n-1]=='\n'||s[n-1]=='\r')) n--;
    if (n == 0) {
        fprintf(stderr, "RIINA: perpuluhan: '%s' is not a decimal number\n", s0);
        abort();
    }
    int neg = 0; size_t i = 0;
    if (s[0] == '-') { neg = 1; i = 1; } else if (s[0] == '+') { i = 1; }
    char* digits = (char*)malloc(n + 2);
    if (!digits) abort();
    size_t dn = 0;
    if (neg) digits[dn++] = '-';
    int seen_dot = 0, any_digit = 0; uint32_t frac = 0;
    for (; i < n; i++) {
        char c = s[i];
        if (c == '.') {
            if (seen_dot) {
                fprintf(stderr, "RIINA: perpuluhan: '%s' is not a decimal number\n", s0);
                abort();
            }
            seen_dot = 1; continue;
        }
        if (c < '0' || c > '9') {
            fprintf(stderr, "RIINA: perpuluhan: '%s' is not a decimal number\n", s0);
            abort();
        }
        digits[dn++] = c; any_digit = 1;
        if (seen_dot) frac++;
    }
    if (!any_digit) {
        fprintf(stderr, "RIINA: perpuluhan: '%s' is not a decimal number\n", s0);
        abort();
    }
    digits[dn] = '\0';
    riina_value_t* m = riina_bigint_from_str(digits);
    free(digits);
    return riina_decimal_from_bi(m, frac);
}

/* Render in base 10, preserving the scale (mantissa=3140, scale=3 -> "3.140"). */
static char* riina_decimal_to_str(riina_value_t* v) {
    riina_decimal_t* d = &v->data.decimal_val;
    if (d->scale == 0) {
        riina_value_t mv = riina_bi_wrap(d->mantissa.neg, d->mantissa.mag, d->mantissa.len);
        return riina_bigint_to_str(&mv);
    }
    int neg = d->mantissa.neg;
    /* magnitude digits (force non-negative so to_str emits no sign) */
    riina_value_t magv = riina_bi_wrap(0, d->mantissa.mag, d->mantissa.len);
    char* mag = riina_bigint_to_str(&magv);
    size_t maglen = strlen(mag);
    uint32_t scale = d->scale;
    char* out;
    size_t p = 0;
    if ((size_t)scale >= maglen) {
        size_t zeros = (size_t)scale - maglen;
        out = (char*)malloc((neg ? 1 : 0) + 2 + zeros + maglen + 1);
        if (!out) abort();
        if (neg) out[p++] = '-';
        out[p++] = '0'; out[p++] = '.';
        for (size_t z = 0; z < zeros; z++) out[p++] = '0';
        memcpy(out + p, mag, maglen); p += maglen;
    } else {
        size_t point = maglen - (size_t)scale;
        out = (char*)malloc((neg ? 1 : 0) + maglen + 2);
        if (!out) abort();
        if (neg) out[p++] = '-';
        memcpy(out + p, mag, point); p += point;
        out[p++] = '.';
        memcpy(out + p, mag + point, maglen - point); p += (maglen - point);
    }
    out[p] = '\0';
    free(mag);
    return out;
}

/* The `perpuluhan`/`decimal` constructor builtin (String -> Decimal). */
static riina_value_t* riina_builtin_perpuluhan(riina_value_t* arg) {
    if (arg->tag == RIINA_TAG_STRING) return riina_decimal_from_str(arg->data.string_val.data);
    if (arg->tag == RIINA_TAG_DECIMAL) return arg;
    fprintf(stderr, "RIINA: perpuluhan expects a string\n");
    abort();
}

"##,
        );
    }

    /// Emit the Fixed (`wang`/`titik_tetap`) runtime: a faithful C port of
    /// `riina-codegen/src/fixed.rs` (a fixed-scale decimal money type). Same
    /// representation as Decimal but arithmetic rounds half-to-even *back to the
    /// scale* and display preserves trailing zeros. Reuses the BigInt + Decimal
    /// runtime helpers, so a compiled `wang` program is byte-identical to the
    /// interpreter.
    fn emit_fixed_runtime(&mut self) {
        self.output.push_str(
            r##"/* ═══════════════════════════════════════════════════════════════════ */
/*               FIXED-SCALE MONEY (wang / titik_tetap) RUNTIME        */
/* ═══════════════════════════════════════════════════════════════════ */

/* num / denom rounded half-to-even (denom nonzero) — the fixed-point rounding
   primitive (reuses the generic BigInt-value helpers from the runtimes above). */
static riina_value_t* riina_round_quotient(riina_value_t* num, riina_value_t* den) {
    riina_value_t *q, *r;
    riina_bigint_divmod(num, den, &q, &r);
    riina_value_t* two = riina_bigint_from_str("2");
    riina_value_t* two_abs_r = riina_bigint_mul(riina_dec_abs(r), two);
    riina_value_t* abs_den = riina_dec_abs(den);
    int result_neg = (num->data.bigint_val.neg ^ den->data.bigint_val.neg) ? 1 : 0;
    int c = riina_bigint_cmp(two_abs_r, abs_den);
    if (c > 0) {
        q = riina_dec_bump(q, result_neg);
    } else if (c == 0) {
        riina_value_t *qq, *parity;
        riina_bigint_divmod(q, two, &qq, &parity);
        if (parity->data.bigint_val.len != 0) q = riina_dec_bump(q, result_neg);
    }
    return q;
}

static riina_value_t* riina_fixed_from_bi(riina_value_t* m, uint32_t scale) {
    riina_value_t* v = riina_alloc();
    v->tag = RIINA_TAG_FIXED;
    v->security = RIINA_LEVEL_PUBLIC;
    v->data.fixed_val.mantissa = m->data.bigint_val;
    v->data.fixed_val.scale = scale;
    return v;
}

/* Mantissa value `m` rescaled from scale `from` to `to` (round h-t-e if shrinking). */
static riina_value_t* riina_fixed_rescale(riina_value_t* m, uint32_t from, uint32_t to) {
    if (to >= from) return riina_bigint_mul(m, riina_dec_pow10(to - from));
    return riina_round_quotient(m, riina_dec_pow10(from - to));
}

static uint32_t riina_fixed_max_scale(riina_value_t* a, riina_value_t* b) {
    uint32_t sa = a->data.fixed_val.scale, sb = b->data.fixed_val.scale;
    return sa > sb ? sa : sb;
}

/* a's mantissa as a BigInt value re-expressed at scale s (exact, grow only). */
static riina_value_t* riina_fixed_aligned(riina_value_t* a, uint32_t s) {
    riina_bigint_t* m = &a->data.fixed_val.mantissa;
    riina_value_t mv = riina_bi_wrap(m->neg, m->mag, m->len);
    return riina_bigint_mul(&mv, riina_dec_pow10(s - a->data.fixed_val.scale));
}

static riina_value_t* riina_fixed_add(riina_value_t* a, riina_value_t* b) {
    uint32_t s = riina_fixed_max_scale(a, b);
    return riina_fixed_from_bi(riina_bigint_add(riina_fixed_aligned(a, s),
                                                riina_fixed_aligned(b, s)), s);
}

static riina_value_t* riina_fixed_sub(riina_value_t* a, riina_value_t* b) {
    uint32_t s = riina_fixed_max_scale(a, b);
    return riina_fixed_from_bi(riina_bigint_sub(riina_fixed_aligned(a, s),
                                                riina_fixed_aligned(b, s)), s);
}

static riina_value_t* riina_fixed_mul(riina_value_t* a, riina_value_t* b) {
    uint32_t target = riina_fixed_max_scale(a, b);
    riina_bigint_t* ma = &a->data.fixed_val.mantissa;
    riina_bigint_t* mb = &b->data.fixed_val.mantissa;
    riina_value_t av = riina_bi_wrap(ma->neg, ma->mag, ma->len);
    riina_value_t bv = riina_bi_wrap(mb->neg, mb->mag, mb->len);
    riina_value_t* exact = riina_bigint_mul(&av, &bv);
    uint32_t from = a->data.fixed_val.scale + b->data.fixed_val.scale;
    return riina_fixed_from_bi(riina_fixed_rescale(exact, from, target), target);
}

static riina_value_t* riina_fixed_neg(riina_value_t* a) {
    riina_bigint_t* m = &a->data.fixed_val.mantissa;
    riina_value_t mv = riina_bi_wrap(m->neg, m->mag, m->len);
    return riina_fixed_from_bi(riina_bigint_neg(&mv), a->data.fixed_val.scale);
}

static int riina_fixed_cmp(riina_value_t* a, riina_value_t* b) {
    uint32_t s = riina_fixed_max_scale(a, b);
    return riina_bigint_cmp(riina_fixed_aligned(a, s), riina_fixed_aligned(b, s));
}

static riina_value_t* riina_fixed_div(riina_value_t* a, riina_value_t* b) {
    riina_fixed_t* da = &a->data.fixed_val;
    riina_fixed_t* db = &b->data.fixed_val;
    if (db->mantissa.len == 0) {
        fprintf(stderr, "RIINA: fixed division by zero\n");
        abort();
    }
    uint32_t target = riina_fixed_max_scale(a, b);
    long long shift = (long long)target + (long long)db->scale - (long long)da->scale;
    riina_value_t amv = riina_bi_wrap(da->mantissa.neg, da->mantissa.mag, da->mantissa.len);
    riina_value_t bmv = riina_bi_wrap(db->mantissa.neg, db->mantissa.mag, db->mantissa.len);
    riina_value_t *num, *den;
    if (shift >= 0) {
        num = riina_bigint_mul(&amv, riina_dec_pow10((uint32_t)shift));
        den = riina_bigint_from_str("1"); *den = bmv;
    } else {
        num = riina_bigint_from_str("1"); *num = amv;
        den = riina_bigint_mul(&bmv, riina_dec_pow10((uint32_t)(-shift)));
    }
    return riina_fixed_from_bi(riina_round_quotient(num, den), target);
}

/* Parse a literal, inferring the scale (the `wang` constructor). */
static riina_value_t* riina_fixed_from_str(const char* s0) {
    riina_value_t* d = riina_decimal_from_str(s0);   /* reuse the decimal parser */
    riina_decimal_t* dd = &d->data.decimal_val;
    riina_value_t mv = riina_bi_wrap(dd->mantissa.neg, dd->mantissa.mag, dd->mantissa.len);
    riina_value_t* m = riina_bigint_from_str("0"); *m = mv;
    return riina_fixed_from_bi(m, dd->scale);
}

/* Parse a literal then round half-to-even to an explicit scale (`titik_tetap`). */
static riina_value_t* riina_fixed_from_str_scaled(const char* s0, uint32_t scale) {
    riina_value_t* parsed = riina_fixed_from_str(s0);
    riina_fixed_t* p = &parsed->data.fixed_val;
    riina_value_t mv = riina_bi_wrap(p->mantissa.neg, p->mantissa.mag, p->mantissa.len);
    return riina_fixed_from_bi(riina_fixed_rescale(&mv, p->scale, scale), scale);
}

/* Render preserving the fixed scale (trailing zeros kept — money format). */
static char* riina_fixed_to_str(riina_value_t* v) {
    riina_fixed_t* d = &v->data.fixed_val;
    riina_value_t mv = riina_bi_wrap(d->mantissa.neg, d->mantissa.mag, d->mantissa.len);
    riina_value_t* m = riina_bigint_from_str("0"); *m = mv;
    /* same digit-placement as Decimal's scale-preserving render. */
    return riina_decimal_to_str(riina_decimal_from_bi(m, d->scale));
}

/* The `wang`/`money` constructor builtin (String -> Fixed). */
static riina_value_t* riina_builtin_wang(riina_value_t* arg) {
    if (arg->tag == RIINA_TAG_STRING) return riina_fixed_from_str(arg->data.string_val.data);
    if (arg->tag == RIINA_TAG_FIXED) return arg;
    fprintf(stderr, "RIINA: wang expects a string\n");
    abort();
}

/* The `titik_tetap`/`fixed` constructor builtin ((String, Int) -> Fixed). */
static riina_value_t* riina_builtin_titik_tetap(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) {
        fprintf(stderr, "RIINA: titik_tetap expects a (string, int) pair\n");
        abort();
    }
    riina_value_t* s = arg->data.pair_val.fst;
    riina_value_t* n = arg->data.pair_val.snd;
    if (s->tag != RIINA_TAG_STRING || n->tag != RIINA_TAG_INT) {
        fprintf(stderr, "RIINA: titik_tetap expects (string, int)\n");
        abort();
    }
    if (n->data.int_val > 1000) {
        fprintf(stderr, "RIINA: titik_tetap: scale out of range (max 1000)\n");
        abort();
    }
    return riina_fixed_from_str_scaled(s->data.string_val.data, (uint32_t)n->data.int_val);
}

"##,
        );
    }

    /// Emit the FixedBin (`qmn`) runtime: a faithful C port of
    /// `riina-codegen/src/fixed_bin.rs` (binary fixed-point / Q-format,
    /// `raw / 2^frac_bits` over a bounded i64). Construction/display reuse the
    /// Decimal parser/renderer for an exact decimal↔binary conversion; arithmetic
    /// is exact in BigInt then wrapped into the i64 word.
    fn emit_fixedbin_runtime(&mut self) {
        self.output.push_str(
            r##"/* ═══════════════════════════════════════════════════════════════════ */
/*                BINARY FIXED-POINT / Q-FORMAT (qmn) RUNTIME          */
/* ═══════════════════════════════════════════════════════════════════ */

static riina_value_t* riina_fixedbin_mk(int64_t raw, uint32_t frac_bits) {
    riina_value_t* v = riina_alloc();
    v->tag = RIINA_TAG_FIXEDBIN;
    v->security = RIINA_LEVEL_PUBLIC;
    v->data.fixedbin_val.raw = raw;
    v->data.fixedbin_val.frac_bits = frac_bits;
    return v;
}

/* 2^bits as a BigInt value. */
static riina_value_t* riina_fb_two_pow(uint32_t bits) {
    if (bits < 63) {
        char buf[32];
        snprintf(buf, sizeof(buf), "%llu", (unsigned long long)(1ULL << bits));
        return riina_bigint_from_str(buf);
    }
    riina_value_t* r = riina_bigint_from_str("4611686018427387904"); /* 2^62 */
    riina_value_t* two = riina_bigint_from_str("2");
    for (uint32_t i = 62; i < bits; i++) r = riina_bigint_mul(r, two);
    return r;
}

/* 5^n as a BigInt value. */
static riina_value_t* riina_fb_five_pow(uint32_t n) {
    riina_value_t* r = riina_bigint_from_str("1");
    riina_value_t* five = riina_bigint_from_str("5");
    for (uint32_t i = 0; i < n; i++) r = riina_bigint_mul(r, five);
    return r;
}

/* Reduce a BigInt value into an int64 word, wrapping mod 2^64 (two's complement). */
static int64_t riina_fb_to_i64(riina_value_t* b) {
    riina_value_t* mod = riina_fb_two_pow(64);
    riina_value_t *q, *r;
    riina_bigint_divmod(b, mod, &q, &r);
    if (r->data.bigint_val.neg) r = riina_bigint_add(r, mod);  /* [0, 2^64) */
    char* s = riina_bigint_to_str(r);
    unsigned long long u = strtoull(s, NULL, 10);
    free(s);
    return (int64_t)u;
}

/* raw as a BigInt value re-expressed at `target` fractional bits (exact). */
static riina_value_t* riina_fb_aligned(riina_value_t* a, uint32_t target) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%lld", (long long)a->data.fixedbin_val.raw);
    riina_value_t* rawv = riina_bigint_from_str(buf);
    return riina_bigint_mul(rawv, riina_fb_two_pow(target - a->data.fixedbin_val.frac_bits));
}

static uint32_t riina_fb_max_fb(riina_value_t* a, riina_value_t* b) {
    uint32_t fa = a->data.fixedbin_val.frac_bits, fb = b->data.fixedbin_val.frac_bits;
    return fa > fb ? fa : fb;
}

/* Construct from a decimal literal at `frac_bits` bits (round h-t-e to nearest). */
static riina_value_t* riina_fixedbin_parse(const char* s0, uint32_t frac_bits) {
    if (frac_bits == 0 || frac_bits > 32) {
        fprintf(stderr, "RIINA: qmn: frac_bits out of range (1..=32)\n");
        abort();
    }
    riina_value_t* d = riina_decimal_from_str(s0);    /* mantissa + decimal scale */
    riina_decimal_t* dd = &d->data.decimal_val;
    riina_value_t mv = riina_bi_wrap(dd->mantissa.neg, dd->mantissa.mag, dd->mantissa.len);
    /* raw = round(mantissa * 2^frac_bits / 10^scale) */
    riina_value_t* num = riina_bigint_mul(&mv, riina_fb_two_pow(frac_bits));
    riina_value_t* den = riina_dec_pow10(dd->scale);
    riina_value_t* raw_big = riina_round_quotient(num, den);
    return riina_fixedbin_mk(riina_fb_to_i64(raw_big), frac_bits);
}

/* Render the exact decimal value (raw / 2^fb = raw*5^fb / 10^fb), stripped. */
static char* riina_fixedbin_to_str(riina_value_t* v) {
    riina_fixedbin_t* fb = &v->data.fixedbin_val;
    if (fb->raw == 0) {
        char* z = (char*)malloc(2);
        if (!z) abort();
        z[0] = '0'; z[1] = '\0';
        return z;
    }
    char buf[32];
    snprintf(buf, sizeof(buf), "%lld", (long long)fb->raw);
    riina_value_t* rawv = riina_bigint_from_str(buf);
    riina_value_t* num = riina_bigint_mul(rawv, riina_fb_five_pow(fb->frac_bits));
    /* reuse the Decimal strip + render for num / 10^frac_bits. */
    return riina_decimal_to_str(riina_decimal_stripped(riina_decimal_from_bi(num, fb->frac_bits)));
}

static riina_value_t* riina_fixedbin_add(riina_value_t* a, riina_value_t* b) {
    uint32_t fb = riina_fb_max_fb(a, b);
    riina_value_t* r = riina_bigint_add(riina_fb_aligned(a, fb), riina_fb_aligned(b, fb));
    return riina_fixedbin_mk(riina_fb_to_i64(r), fb);
}

static riina_value_t* riina_fixedbin_sub(riina_value_t* a, riina_value_t* b) {
    uint32_t fb = riina_fb_max_fb(a, b);
    riina_value_t* r = riina_bigint_sub(riina_fb_aligned(a, fb), riina_fb_aligned(b, fb));
    return riina_fixedbin_mk(riina_fb_to_i64(r), fb);
}

static riina_value_t* riina_fixedbin_mul(riina_value_t* a, riina_value_t* b) {
    uint32_t fb = riina_fb_max_fb(a, b);
    riina_value_t* product = riina_bigint_mul(riina_fb_aligned(a, fb), riina_fb_aligned(b, fb));
    riina_value_t* r = riina_round_quotient(product, riina_fb_two_pow(fb));
    return riina_fixedbin_mk(riina_fb_to_i64(r), fb);
}

static riina_value_t* riina_fixedbin_div(riina_value_t* a, riina_value_t* b) {
    if (b->data.fixedbin_val.raw == 0) {
        fprintf(stderr, "RIINA: qmn division by zero\n");
        abort();
    }
    uint32_t fb = riina_fb_max_fb(a, b);
    riina_value_t* num = riina_bigint_mul(riina_fb_aligned(a, fb), riina_fb_two_pow(fb));
    riina_value_t* r = riina_round_quotient(num, riina_fb_aligned(b, fb));
    return riina_fixedbin_mk(riina_fb_to_i64(r), fb);
}

static int riina_fixedbin_cmp(riina_value_t* a, riina_value_t* b) {
    uint32_t fb = riina_fb_max_fb(a, b);
    return riina_bigint_cmp(riina_fb_aligned(a, fb), riina_fb_aligned(b, fb));
}

/* The `qmn`/`binary_fixed` constructor builtin ((String, Int) -> FixedBin). */
static riina_value_t* riina_builtin_qmn(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) {
        fprintf(stderr, "RIINA: qmn expects a (string, int) pair\n");
        abort();
    }
    riina_value_t* s = arg->data.pair_val.fst;
    riina_value_t* n = arg->data.pair_val.snd;
    if (s->tag != RIINA_TAG_STRING || n->tag != RIINA_TAG_INT) {
        fprintf(stderr, "RIINA: qmn expects (string, int)\n");
        abort();
    }
    return riina_fixedbin_parse(s->data.string_val.data, (uint32_t)n->data.int_val);
}

"##,
        );
    }

    /// Emit runtime helper functions
    fn emit_runtime_helpers(&mut self) {
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                      RUNTIME HELPERS                                */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        // Binary operations
        // Forward declaration: the list machinery is emitted later in the
        // prelude, but `+` on two lists concatenates (REQ-80) and must match the
        // interpreter, which supports it.
        self.writeln("static riina_value_t* riina_list_concat(riina_value_t* a, riina_value_t* b);");
        self.writeln("");
        self.writeln("static riina_value_t* riina_binop_add(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    /* REQ-80: list concatenation, matching the interpreter. */");
        self.writeln("    if (a->tag == RIINA_TAG_LIST && b->tag == RIINA_TAG_LIST) return riina_list_concat(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bigint_add(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_decimal_add(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_fixed_add(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_fixedbin_add(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_STRING && b->tag == RIINA_TAG_STRING) {");
        self.writeln("        size_t la = a->data.string_val.len;");
        self.writeln("        size_t lb = b->data.string_val.len;");
        self.writeln("        char* buf = (char*)malloc(la + lb + 1);");
        self.writeln("        memcpy(buf, a->data.string_val.data, la);");
        self.writeln("        memcpy(buf + la, b->data.string_val.data, lb);");
        self.writeln("        buf[la + lb] = '\\0';");
        self.writeln("        return riina_string(buf);");
        self.writeln("    }");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: add on incompatible types\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return riina_int(a->data.int_val + b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_sub(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bigint_sub(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_decimal_sub(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_fixed_sub(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_fixedbin_sub(a, b);");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: sub on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return riina_int(a->data.int_val - b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_mul(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bigint_mul(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_decimal_mul(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_fixed_mul(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_fixedbin_mul(a, b);");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: mul on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return riina_int(a->data.int_val * b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_div(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) {");
        self.writeln("        riina_value_t *q, *r; riina_bigint_divmod(a, b, &q, &r); return q;");
        self.writeln("    }");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_decimal_div(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_fixed_div(a, b);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_fixedbin_div(a, b);");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: div on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    if (b->data.int_val == 0) {");
        self.writeln("        fprintf(stderr, \"RIINA: division by zero\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    unsigned w = riina_swidth(a, b);");
        self.writeln("    if (w) return riina_int_sized((uint64_t)(riina_sext(a->data.int_val, w) / riina_sext(b->data.int_val, w)), w, 1);");
        self.writeln("    return riina_int(a->data.int_val / b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_mod(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) {");
        self.writeln("        riina_value_t *q, *r; riina_bigint_divmod(a, b, &q, &r); return r;");
        self.writeln("    }");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: mod on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    if (b->data.int_val == 0) {");
        self.writeln("        fprintf(stderr, \"RIINA: modulo by zero\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    unsigned w = riina_swidth(a, b);");
        self.writeln("    if (w) return riina_int_sized((uint64_t)(riina_sext(a->data.int_val, w) % riina_sext(b->data.int_val, w)), w, 1);");
        self.writeln("    return riina_int(a->data.int_val % b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        // Comparison operations
        self.writeln("static riina_value_t* riina_binop_eq(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag != b->tag) return riina_bool(false);");
        self.writeln("    switch (a->tag) {");
        self.writeln("        case RIINA_TAG_UNIT: return riina_bool(true);");
        self.writeln(
            "        case RIINA_TAG_BOOL: return riina_bool(a->data.bool_val == b->data.bool_val);",
        );
        self.writeln(
            "        case RIINA_TAG_INT: return riina_bool(a->data.int_val == b->data.int_val);",
        );
        self.writeln(
            "        case RIINA_TAG_BIGINT: return riina_bool(riina_bigint_cmp(a, b) == 0);",
        );
        self.writeln(
            "        case RIINA_TAG_DECIMAL: return riina_bool(riina_decimal_cmp(a, b) == 0);",
        );
        self.writeln(
            "        case RIINA_TAG_FIXED: return riina_bool(riina_fixed_cmp(a, b) == 0);",
        );
        self.writeln(
            "        case RIINA_TAG_FIXEDBIN: return riina_bool(riina_fixedbin_cmp(a, b) == 0);",
        );
        self.writeln("        case RIINA_TAG_STRING:");
        self.writeln(
            "            return riina_bool(a->data.string_val.len == b->data.string_val.len &&",
        );
        self.writeln("                memcmp(a->data.string_val.data, b->data.string_val.data, a->data.string_val.len) == 0);");
        self.writeln("        default: return riina_bool(false);");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_ne(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    riina_value_t* eq = riina_binop_eq(a, b);");
        self.writeln("    return riina_bool(!eq->data.bool_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_lt(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bool(riina_bigint_cmp(a, b) < 0);");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_bool(riina_decimal_cmp(a, b) < 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_bool(riina_fixed_cmp(a, b) < 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_bool(riina_fixedbin_cmp(a, b) < 0);");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: lt on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    unsigned w = riina_swidth(a, b);");
        self.writeln("    if (w) return riina_bool(riina_sext(a->data.int_val, w) < riina_sext(b->data.int_val, w));");
        self.writeln("    return riina_bool(a->data.int_val < b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_le(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bool(riina_bigint_cmp(a, b) <= 0);");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_bool(riina_decimal_cmp(a, b) <= 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_bool(riina_fixed_cmp(a, b) <= 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_bool(riina_fixedbin_cmp(a, b) <= 0);");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: le on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    unsigned w = riina_swidth(a, b);");
        self.writeln("    if (w) return riina_bool(riina_sext(a->data.int_val, w) <= riina_sext(b->data.int_val, w));");
        self.writeln("    return riina_bool(a->data.int_val <= b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_gt(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bool(riina_bigint_cmp(a, b) > 0);");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_bool(riina_decimal_cmp(a, b) > 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_bool(riina_fixed_cmp(a, b) > 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_bool(riina_fixedbin_cmp(a, b) > 0);");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: gt on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    unsigned w = riina_swidth(a, b);");
        self.writeln("    if (w) return riina_bool(riina_sext(a->data.int_val, w) > riina_sext(b->data.int_val, w));");
        self.writeln("    return riina_bool(a->data.int_val > b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_ge(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bool(riina_bigint_cmp(a, b) >= 0);");
        self.writeln("    if (a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_bool(riina_decimal_cmp(a, b) >= 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_bool(riina_fixed_cmp(a, b) >= 0);");
        self.writeln("    if (a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_bool(riina_fixedbin_cmp(a, b) >= 0);");
        self.writeln("    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: ge on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    unsigned w = riina_swidth(a, b);");
        self.writeln("    if (w) return riina_bool(riina_sext(a->data.int_val, w) >= riina_sext(b->data.int_val, w));");
        self.writeln("    return riina_bool(a->data.int_val >= b->data.int_val);");
        self.writeln("}");
        self.writeln("");

        // Logical operations
        self.writeln("static riina_value_t* riina_binop_and(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag != RIINA_TAG_BOOL || b->tag != RIINA_TAG_BOOL) {");
        self.writeln("        fprintf(stderr, \"RIINA: and on non-bool\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return riina_bool(a->data.bool_val && b->data.bool_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_binop_or(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    if (a->tag != RIINA_TAG_BOOL || b->tag != RIINA_TAG_BOOL) {");
        self.writeln("        fprintf(stderr, \"RIINA: or on non-bool\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return riina_bool(a->data.bool_val || b->data.bool_val);");
        self.writeln("}");
        self.writeln("");

        // Unary operations
        self.writeln("static riina_value_t* riina_unary_not(riina_value_t* a) {");
        self.writeln("    if (a->tag != RIINA_TAG_BOOL) {");
        self.writeln("        fprintf(stderr, \"RIINA: not on non-bool\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return riina_bool(!a->data.bool_val);");
        self.writeln("}");
        self.writeln("");

        self.writeln("static riina_value_t* riina_unary_neg(riina_value_t* a) {");
        self.writeln("    if (a->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: neg on non-int\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    return riina_int(-(int64_t)a->data.int_val);");
        self.writeln("}");
        self.writeln("");

        // Copy
        self.writeln("static riina_value_t* riina_copy(riina_value_t* v) {");
        self.writeln("    return v; /* Shallow copy - values are immutable */");
        self.writeln("}");
        self.writeln("");
    }

    /// Emit security check functions
    fn emit_security_checks(&mut self) {
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                      SECURITY CHECKS                                */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        self.writeln("static void riina_require_cap(riina_effect_t eff) {");
        self.writeln("    if (eff == RIINA_EFFECT_PURE) return; /* Pure always allowed */");
        self.writeln("    if (!(riina_ctx.capabilities & (1u << eff))) {");
        self.writeln(
            "        fprintf(stderr, \"RIINA: missing capability for effect %d\\n\", eff);",
        );
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("");

        self.writeln("static void riina_grant_cap(riina_effect_t eff) {");
        self.writeln("    riina_ctx.capabilities |= (1u << eff);");
        self.writeln("}");
        self.writeln("");

        // Effect handler stack (setjmp/longjmp based)
        self.writeln("#define RIINA_MAX_HANDLERS 64");
        self.writeln("");
        self.writeln("typedef struct {");
        self.writeln("    jmp_buf env;");
        self.writeln("    riina_effect_t effect;");
        self.writeln("    riina_value_t* payload;  /* set by perform before longjmp */");
        self.writeln("} riina_handler_frame_t;");
        self.writeln("");
        self.writeln("static riina_handler_frame_t riina_handler_stack[RIINA_MAX_HANDLERS];");
        self.writeln("static int riina_handler_top = 0;");
        self.writeln("");
        self.writeln("static void riina_push_handler(riina_effect_t eff) {");
        self.writeln("    if (riina_handler_top >= RIINA_MAX_HANDLERS) {");
        self.writeln("        fprintf(stderr, \"RIINA: handler stack overflow\\n\");");
        self.writeln("        abort();");
        self.writeln("    }");
        self.writeln("    riina_handler_stack[riina_handler_top].effect = eff;");
        self.writeln("    riina_handler_stack[riina_handler_top].payload = NULL;");
        self.writeln("    riina_handler_top++;");
        self.writeln("}");
        self.writeln("");
        self.writeln("static void riina_pop_handler(void) {");
        self.writeln("    if (riina_handler_top > 0) riina_handler_top--;");
        self.writeln("}");
        self.writeln("");
        self.writeln(
            "static riina_value_t* riina_perform(riina_effect_t eff, riina_value_t* payload) {",
        );
        self.writeln("    riina_require_cap(eff);");
        self.writeln("    /* Search handler stack for matching handler */");
        self.writeln("    for (int i = riina_handler_top - 1; i >= 0; i--) {");
        self.writeln("        if (riina_handler_stack[i].effect == eff) {");
        self.writeln("            riina_handler_stack[i].payload = payload;");
        self.writeln("            longjmp(riina_handler_stack[i].env, 1);");
        self.writeln("        }");
        self.writeln("    }");
        self.writeln("    /* No handler installed — return payload (default behavior) */");
        self.writeln("    return payload;");
        self.writeln("}");
        self.writeln("");
    }

    /// Emit built-in function helpers (C implementations of RIINA builtins)
    /// The C half of `riina-os::store` — the `simpan_*` durable key-value
    /// store (REQ-70 family routing).
    ///
    /// Emitted as one raw block rather than ~400 escaped `writeln` calls, so
    /// the runtime stays readable AS C and can be diffed against the Rust it
    /// mirrors. The ON-DISK FORMAT is the contract between the two: a store
    /// written by an interpreted program must be readable by a compiled one
    /// and vice versa, which is what the differential actually checks.
    fn emit_store_builtins(&mut self) {
        self.write_raw(STORE_RUNTIME_C);
        self.writeln("");
    }

    /// The C half of `riina-os::net` + `riina-os::http` — the `jaring_*` and
    /// `http_*` builtins (REQ-70 family routing).
    ///
    /// Two things are ported, not approximated:
    ///
    /// * the **verified RFC 793 state machine** (`next_state`'s 15 edges), so
    ///   the compiled backend gates send/recv on ESTABLISHED for the same
    ///   reason the interpreter does — a C backend that skipped the machine
    ///   would be strictly weaker than the language it compiles;
    /// * the **strict RFC 9112 parser**, so a request that the interpreter
    ///   refuses as a smuggling attempt (CL+TE, conflicting duplicate
    ///   `Content-Length`, `Foo : bar`, missing `Host`) is refused by compiled
    ///   code too. Two parsers reading one byte stream differently IS the
    ///   vulnerability class; agreement is the whole point.
    fn emit_net_builtins(&mut self) {
        self.write_raw(NET_RUNTIME_C);
        self.writeln("");
    }

    fn emit_builtin_helpers(&mut self) {
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                      BUILTIN FUNCTIONS                              */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        // Helper: format a value as a string for printing
        // Value rendering. Only DECLARED here: the definition needs
        // `riina_list_t` / `riina_map_t`, which are emitted with the collection
        // runtime further down, and `cetak`/`cetakln` below call it immediately.
        //
        // Until REQ-70's keselamatan increment this function handled the scalar
        // tags and answered the literal text `<value>` for every composite one —
        // PAIR, LIST, MAP and both SUM arms. `cetakln` and `ke_teks` both go
        // through it, so a compiled program printing a list, a map, or the
        // `Option` that `sahkan_panjang` returns showed `<value>` where
        // `riinac run` shows the contents. See the definition for the two
        // rendering modes it has to mirror.
        self.writeln("static const char* riina_format(riina_value_t* v);");
        self.writeln("");

        // cetak (print without newline)
        //
        // The `fflush` is not decoration. Rust's stdout is line-buffered even
        // when piped, so the interpreter's output is observable as it is
        // produced; C's stdout switches to BLOCK buffering off a tty, so a
        // compiled program that prints and then blocks (a `jaring_dengar`
        // service announcing its address before `jaring_terima_sambungan`,
        // which is exactly `07_EXAMPLES/11_servis/pelayan.rii`) delivers
        // nothing until it exits. That is a cross-backend divergence in
        // observable behaviour, not a performance preference.
        self.writeln("static riina_value_t* riina_builtin_cetak(riina_value_t* arg) {");
        self.writeln("    printf(\"%s\", riina_format(arg));");
        self.writeln("    fflush(stdout);");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // cetakln (print with newline)
        self.writeln("static riina_value_t* riina_builtin_cetakln(riina_value_t* arg) {");
        self.writeln("    printf(\"%s\\n\", riina_format(arg));");
        self.writeln("    fflush(stdout);");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // ke_teks (to_string)
        // `ke_teks` IS `builtins::format_value` in the interpreter, so it is
        // that one function here too rather than a parallel switch. It used to
        // carry its own copy of the scalar arms plus a `default:` returning the
        // literal text `<value>`, which is how the composite tags came to render
        // differently from `cetakln` — two switches, one of them updated.
        self.writeln("static riina_value_t* riina_builtin_ke_teks(riina_value_t* arg) {");
        // A string is already its own rendering; returning it avoids a copy and
        // keeps `ke_teks(s) == s` identical to the interpreter. Everything else
        // goes through the one shared formatter.
        self.writeln("    if (arg->tag == RIINA_TAG_STRING) return arg;");
        self.writeln("    return riina_string(riina_format(arg));");
        self.writeln("}");
        self.writeln("");

        // nombor_ke_teks (int_to_string) — alias
        self.writeln("static riina_value_t* riina_builtin_nombor_ke_teks(riina_value_t* arg) {");
        self.writeln("    return riina_builtin_ke_teks(arg);");
        self.writeln("}");
        self.writeln("");

        // panjang (length)
        self.writeln("static riina_value_t* riina_builtin_panjang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) {");
        self.writeln("        fprintf(stderr, \"RIINA: panjang on non-string\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_int((uint64_t)arg->data.string_val.len);");
        self.writeln("}");
        self.writeln("");

        // gabung_teks (concat) — expects a pair
        self.writeln("static riina_value_t* riina_builtin_gabung_teks(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: gabung_teks expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    riina_value_t* a = riina_builtin_ke_teks(arg->data.pair_val.fst);");
        self.writeln("    riina_value_t* b = riina_builtin_ke_teks(arg->data.pair_val.snd);");
        self.writeln("    return riina_string_concat(a, b);");
        self.writeln("}");
        self.writeln("");

        // ke_nombor (parse_int)
        self.writeln("static riina_value_t* riina_builtin_ke_nombor(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) {");
        self.writeln("        fprintf(stderr, \"RIINA: ke_nombor on non-string\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_int((uint64_t)atoll(arg->data.string_val.data));");
        self.writeln("}");
        self.writeln("");

        // ke_bool (to_bool)
        self.writeln("static riina_value_t* riina_builtin_ke_bool(riina_value_t* arg) {");
        self.writeln("    switch (arg->tag) {");
        self.writeln("        case RIINA_TAG_BOOL: return arg;");
        self.writeln("        case RIINA_TAG_INT: return riina_bool(arg->data.int_val != 0);");
        self.writeln(
            "        case RIINA_TAG_STRING: return riina_bool(arg->data.string_val.len > 0);",
        );
        self.writeln("        default: return riina_bool(false);");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("");

        // bool_ke_nombor
        self.writeln("static riina_value_t* riina_builtin_bool_ke_nombor(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_BOOL) {");
        self.writeln("        fprintf(stderr, \"RIINA: bool_ke_nombor on non-bool\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_int(arg->data.bool_val ? 1 : 0);");
        self.writeln("}");
        self.writeln("");

        // tegaskan (assert)
        self.writeln("static riina_value_t* riina_builtin_tegaskan(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_BOOL || !arg->data.bool_val) {");
        self.writeln("        fprintf(stderr, \"RIINA: assertion failed\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // tegaskan_betul (assert_true) — alias
        self.writeln("static riina_value_t* riina_builtin_tegaskan_betul(riina_value_t* arg) {");
        self.writeln("    return riina_builtin_tegaskan(arg);");
        self.writeln("}");
        self.writeln("");

        // tegaskan_salah (assert_false)
        self.writeln("static riina_value_t* riina_builtin_tegaskan_salah(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_BOOL || arg->data.bool_val) {");
        self.writeln("        fprintf(stderr, \"RIINA: assert_false failed\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // tegaskan_sama (assert_eq) — expects pair
        self.writeln("static riina_value_t* riina_builtin_tegaskan_sama(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: tegaskan_sama expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    riina_value_t* eq = riina_binop_eq(arg->data.pair_val.fst, arg->data.pair_val.snd);");
        self.writeln("    if (!eq->data.bool_val) {");
        self.writeln("        fprintf(stderr, \"RIINA: assert_eq failed\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // tegaskan_beza (assert_ne) — expects pair
        self.writeln("static riina_value_t* riina_builtin_tegaskan_beza(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: tegaskan_beza expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    riina_value_t* eq = riina_binop_eq(arg->data.pair_val.fst, arg->data.pair_val.snd);");
        self.writeln("    if (eq->data.bool_val) {");
        self.writeln("        fprintf(stderr, \"RIINA: assert_ne failed\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // mutlak (abs)
        self.writeln("static riina_value_t* riina_builtin_mutlak(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: mutlak on non-int\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    return riina_int(arg->data.int_val); /* uint64 always non-negative */");
        self.writeln("}");
        self.writeln("");

        // minimum (min) — expects pair
        self.writeln("static riina_value_t* riina_builtin_minimum(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: minimum expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    riina_value_t* a = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* b = arg->data.pair_val.snd;");
        self.writeln("    return (a->data.int_val <= b->data.int_val) ? a : b;");
        self.writeln("}");
        self.writeln("");

        // maksimum (max) — expects pair
        self.writeln("static riina_value_t* riina_builtin_maksimum(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: maksimum expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    riina_value_t* a = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* b = arg->data.pair_val.snd;");
        self.writeln("    return (a->data.int_val >= b->data.int_val) ? a : b;");
        self.writeln("}");
        self.writeln("");

        // kuasa (pow) — expects pair
        self.writeln("static riina_value_t* riina_builtin_kuasa(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: kuasa expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    uint64_t base = arg->data.pair_val.fst->data.int_val;");
        self.writeln("    uint64_t exp = arg->data.pair_val.snd->data.int_val;");
        self.writeln("    uint64_t result = 1;");
        self.writeln("    for (uint64_t i = 0; i < exp; i++) result *= base;");
        self.writeln("    return riina_int(result);");
        self.writeln("}");
        self.writeln("");

        // punca (sqrt)
        self.writeln("static riina_value_t* riina_builtin_punca(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_INT) {");
        self.writeln("        fprintf(stderr, \"RIINA: punca on non-int\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    uint64_t n = arg->data.int_val, r = 0;");
        self.writeln("    while ((r + 1) * (r + 1) <= n) r++;");
        self.writeln("    return riina_int(r);");
        self.writeln("}");
        self.writeln("");

        // gcd
        self.writeln("static riina_value_t* riina_builtin_gcd(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: gcd expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    uint64_t a = arg->data.pair_val.fst->data.int_val;");
        self.writeln("    uint64_t b = arg->data.pair_val.snd->data.int_val;");
        self.writeln("    while (b) { uint64_t t = b; b = a % b; a = t; }");
        self.writeln("    return riina_int(a);");
        self.writeln("}");
        self.writeln("");

        // lcm
        self.writeln("static riina_value_t* riina_builtin_lcm(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) {");
        self.writeln("        fprintf(stderr, \"RIINA: lcm expects pair\\n\"); abort();");
        self.writeln("    }");
        self.writeln("    uint64_t a = arg->data.pair_val.fst->data.int_val;");
        self.writeln("    uint64_t b = arg->data.pair_val.snd->data.int_val;");
        self.writeln("    riina_value_t* g = riina_builtin_gcd(arg);");
        self.writeln("    if (g->data.int_val == 0) return riina_int(0);");
        self.writeln("    return riina_int(a / g->data.int_val * b);");
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // RUNTIME COLLECTION TYPES
        // ═══════════════════════════════════════════════════════════════════

        // riina_list_t: dynamic array of riina_value_t*
        self.writeln("/* ── List runtime type ── */");
        self.writeln("typedef struct {");
        self.writeln("    riina_value_t** items;");
        self.writeln("    size_t len;");
        self.writeln("    size_t cap;");
        self.writeln("} riina_list_t;");
        self.writeln("");
        self.writeln("static riina_list_t riina_list_new(void) {");
        self.writeln("    riina_list_t l = { NULL, 0, 0 };");
        self.writeln("    return l;");
        self.writeln("}");
        self.writeln("");
        self.writeln("static void riina_list_push(riina_list_t* l, riina_value_t* v) {");
        self.writeln("    if (l->len >= l->cap) {");
        self.writeln("        l->cap = l->cap ? l->cap * 2 : 8;");
        self.writeln("        l->items = (riina_value_t**)realloc(l->items, l->cap * sizeof(riina_value_t*));");
        self.writeln("        if (!l->items) abort();");
        self.writeln("    }");
        self.writeln("    l->items[l->len++] = v;");
        self.writeln("}");
        self.writeln("");
        // Convert riina_list_t to RIINA_TAG_PAIR-based linked list? No — we use a PAIR encoding.
        // Actually, the interpreter uses Value::List but the C runtime uses tagged union.
        // We need a new tag for lists or encode them as nested pairs.
        // For simplicity: add RIINA_TAG_LIST that wraps riina_list_t.
        // But modifying the tag enum is risky. Instead, we'll use a helper approach:
        // list builtins work at the C level with riina_list_t internally,
        // but we won't add a list tag. The C builtins will encode lists as
        // nested Pair(head, Pair(next, ...)) terminated by Unit.
        // ACTUALLY — the BuiltinCall instruction in the IR is only generated for
        // builtins that the lowerer recognizes. Let me check if list builtins
        // actually get lowered to BuiltinCall...
        // Looking at the code: BuiltinCall { name, arg } is generated.
        // The C emitter just calls riina_builtin_{name}(arg).
        // So we need C functions that take/return riina_value_t*.
        // Since there's no list tag, list builtins can't work in C without one.
        // Let's add a RIINA_TAG_LIST and a list field to the union.
        //
        // DECISION: We won't modify the tag enum (too invasive). Instead,
        // we'll note that list/map/set builtins only work in interpreter mode
        // for now. The C emitter will emit stub functions that abort with a
        // "not supported in compiled mode" message. This is the pragmatic choice
        // since adding collection tags requires changes throughout the emitter.
        //
        // UPDATE: Actually, re-reading the plan, M1 asks us to add runtime types.
        // Let's do it properly — add RIINA_TAG_LIST, RIINA_TAG_MAP, RIINA_TAG_SET.

        // Collection tags, defined as constants because the tag enum is emitted
        // earlier in the prelude.
        //
        // REQ-80: these MUST NOT collide with the enum. They previously started
        // at 12, which is exactly `RIINA_TAG_BIGINT`, so a list was
        // indistinguishable from a bigint (and a map from a decimal, a set from
        // a fixed). Any tag dispatch then confused them: `[1] + [2,3]` reached
        // `riina_bigint_add`, which read a list through the bigint union member
        // and SEGFAULTED, and `senarai_panjang(besar("123"))` segfaulted the
        // other way — while the interpreter reported a clean type error for
        // both. They now start past `RIINA_TAG_FIXEDBIN` (15), and the static
        // assertion below fails the C compile if the enum ever grows into them.
        // (Collection tags are defined next to the tag enum — see REQ-80.)


        // Map entry type
        self.writeln("typedef struct riina_map_entry {");
        self.writeln("    char* key;");
        self.writeln("    riina_value_t* value;");
        self.writeln("    struct riina_map_entry* next;");
        self.writeln("} riina_map_entry_t;");
        self.writeln("");
        self.writeln("typedef struct {");
        self.writeln("    riina_map_entry_t* head;");
        self.writeln("    size_t len;");
        self.writeln("} riina_map_t;");
        self.writeln("");

        // Helper: make list value
        self.writeln("static riina_value_t* riina_make_list(riina_list_t l) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_LIST;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    /* Store list data in pair_val: fst=items ptr, snd encodes len+cap */");
        self.writeln("    /* We reuse wrapped_val to point to a heap-allocated riina_list_t */");
        self.writeln("    riina_list_t* lp = (riina_list_t*)malloc(sizeof(riina_list_t));");
        self.writeln("    if (!lp) abort();");
        self.writeln("    *lp = l;");
        self.writeln("    v->data.wrapped_val = (riina_value_t*)lp; /* type-punned */");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");
        self.writeln("/* REQ-80: `+` on two lists concatenates, matching the interpreter. */");
        self.writeln("static riina_value_t* riina_list_concat(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    riina_list_t out = riina_list_new();");
        self.writeln("    riina_list_t* la = RIINA_LIST_DATA(a);");
        self.writeln("    riina_list_t* lb = RIINA_LIST_DATA(b);");
        self.writeln("    for (size_t i = 0; i < la->len; i++) riina_list_push(&out, la->items[i]);");
        self.writeln("    for (size_t i = 0; i < lb->len; i++) riina_list_push(&out, lb->items[i]);");
        self.writeln("    return riina_make_list(out);");
        self.writeln("}");
        self.writeln("");
        // (RIINA_LIST_DATA is defined next to the tag enum — see REQ-80.)
        self.writeln("");

        // Helper: make map value
        self.writeln("static riina_value_t* riina_make_map(riina_map_t m) {");
        self.writeln("    riina_value_t* v = riina_alloc();");
        self.writeln("    v->tag = RIINA_TAG_MAP;");
        self.writeln("    v->security = RIINA_LEVEL_PUBLIC;");
        self.writeln("    riina_map_t* mp = (riina_map_t*)malloc(sizeof(riina_map_t));");
        self.writeln("    if (!mp) abort();");
        self.writeln("    *mp = m;");
        self.writeln("    v->data.wrapped_val = (riina_value_t*)mp;");
        self.writeln("    return v;");
        self.writeln("}");
        self.writeln("");
        self.writeln("#define RIINA_MAP_DATA(v) ((riina_map_t*)(v)->data.wrapped_val)");
        self.writeln("");

        // Value rendering, definition (declared above, next to `cetak`).
        // Emitted as one raw string because it is recursive and carries two
        // mutually-reachable modes, which the per-line `writeln` form makes
        // unreadable.
        //
        // WHY TWO MODES. The interpreter's `builtins::format_value` handles the
        // common tags itself and falls through to `Value`'s `Display` for the
        // rest — and the two spell the same value differently. `format_value`
        // prints a string BARE and a bool in RIINA's own `betul`/`salah`;
        // `Display` QUOTES the string and prints Rust's English `true`/`false`.
        // So `cetakln("x")` is `x` while `cetakln(inl "x")` is `inl "x"`, and a
        // bool inside a sum comes out English. That is an inconsistency in the
        // reference rather than a design, but the reference is what a compiled
        // program must match, so both modes are mirrored here rather than
        // tidied — changing it is a language decision, not a codegen one.
        self.writeln(
            r####"
static void riina_fmt_put(char** b, size_t* n, size_t* cap, const char* s) {
    size_t l = strlen(s);
    while (*n + l + 1 > *cap) {
        *cap = *cap ? *cap * 2 : 128;
        *b = (char*)realloc(*b, *cap);
        if (!*b) abort();
    }
    memcpy(*b + *n, s, l);
    *n += l;
    (*b)[*n] = '\0';
}

/* `display` selects Value::Display (quoted strings, English booleans) over
   builtins::format_value (bare strings, betul/salah). See the note above. */
static void riina_fmt_impl(riina_value_t* v, char** b, size_t* n, size_t* cap, bool display) {
    char tmp[64];
    switch (v->tag) {
        case RIINA_TAG_UNIT: riina_fmt_put(b, n, cap, "()"); return;
        case RIINA_TAG_BOOL:
            if (display) riina_fmt_put(b, n, cap, v->data.bool_val ? "true" : "false");
            else riina_fmt_put(b, n, cap, v->data.bool_val ? "betul" : "salah");
            return;
        case RIINA_TAG_INT:
            if (v->int_signed_bits) {
                snprintf(tmp, sizeof(tmp), "%lld",
                         (long long)riina_sext(v->data.int_val, v->int_signed_bits));
            } else {
                snprintf(tmp, sizeof(tmp), "%llu", (unsigned long long)v->data.int_val);
            }
            riina_fmt_put(b, n, cap, tmp);
            return;
        case RIINA_TAG_STRING:
            if (display) riina_fmt_put(b, n, cap, "\"");
            riina_fmt_put(b, n, cap, v->data.string_val.data);
            if (display) riina_fmt_put(b, n, cap, "\"");
            return;
        case RIINA_TAG_BIGINT: riina_fmt_put(b, n, cap, riina_bigint_to_str(v)); return;
        case RIINA_TAG_DECIMAL: riina_fmt_put(b, n, cap, riina_decimal_to_str(v)); return;
        case RIINA_TAG_FIXED: riina_fmt_put(b, n, cap, riina_fixed_to_str(v)); return;
        case RIINA_TAG_FIXEDBIN: riina_fmt_put(b, n, cap, riina_fixedbin_to_str(v)); return;
        case RIINA_TAG_PAIR:
            riina_fmt_put(b, n, cap, "(");
            riina_fmt_impl(v->data.pair_val.fst, b, n, cap, display);
            riina_fmt_put(b, n, cap, ", ");
            riina_fmt_impl(v->data.pair_val.snd, b, n, cap, display);
            riina_fmt_put(b, n, cap, ")");
            return;
        /* A sum has no `format_value` arm at all: it reaches Display, and so
           does everything nested inside it, however deep. Hence the hard `true`
           rather than passing `display` down. */
        case RIINA_TAG_SUM_LEFT:
            riina_fmt_put(b, n, cap, "inl ");
            riina_fmt_impl(v->data.sum_val, b, n, cap, true);
            return;
        case RIINA_TAG_SUM_RIGHT:
            riina_fmt_put(b, n, cap, "inr ");
            riina_fmt_impl(v->data.sum_val, b, n, cap, true);
            return;
        case RIINA_TAG_LIST: {
            riina_list_t* l = RIINA_LIST_DATA(v);
            riina_fmt_put(b, n, cap, "[");
            for (size_t i = 0; i < l->len; i++) {
                if (i) riina_fmt_put(b, n, cap, ", ");
                riina_fmt_impl(l->items[i], b, n, cap, display);
            }
            riina_fmt_put(b, n, cap, "]");
            return;
        }
        case RIINA_TAG_MAP: {
            riina_map_t* m = RIINA_MAP_DATA(v);
            riina_fmt_put(b, n, cap, "{");
            size_t i = 0;
            for (riina_map_entry_t* e = m->head; e; e = e->next, i++) {
                if (i) riina_fmt_put(b, n, cap, ", ");
                riina_fmt_put(b, n, cap, "\"");
                riina_fmt_put(b, n, cap, e->key);
                riina_fmt_put(b, n, cap, "\": ");
                riina_fmt_impl(e->value, b, n, cap, display);
            }
            riina_fmt_put(b, n, cap, "}");
            return;
        }
        default: riina_fmt_put(b, n, cap, "<value>"); return;
    }
}

static const char* riina_format(riina_value_t* v) {
    char* b = NULL; size_t n = 0, cap = 0;
    riina_fmt_impl(v, &b, &n, &cap, false);
    return b ? b : "";
}
"####,
        );

        // ═══════════════════════════════════════════════════════════════════
        // STRING BUILTINS (teks)
        // ═══════════════════════════════════════════════════════════════════

        // teks_belah (str_split): (String, String) -> List
        self.writeln("static riina_value_t* riina_builtin_teks_belah(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* d = arg->data.pair_val.snd;");
        self.writeln("    if (s->tag != RIINA_TAG_STRING || d->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_list_t result = riina_list_new();");
        self.writeln("    char* str = strdup(s->data.string_val.data);");
        self.writeln("    if (!str) abort();");
        self.writeln("    size_t dlen = d->data.string_val.len;");
        self.writeln("    if (dlen == 0) {");
        self.writeln("        /* Split each char */");
        self.writeln("        for (size_t i = 0; i < s->data.string_val.len; i++) {");
        self.writeln("            char c[2] = { str[i], 0 };");
        self.writeln("            riina_list_push(&result, riina_string(c));");
        self.writeln("        }");
        self.writeln("    } else {");
        self.writeln("        char* p = str;");
        self.writeln("        char* found;");
        self.writeln("        while ((found = strstr(p, d->data.string_val.data)) != NULL) {");
        self.writeln("            *found = '\\0';");
        self.writeln("            riina_list_push(&result, riina_string(p));");
        self.writeln("            p = found + dlen;");
        self.writeln("        }");
        self.writeln("        riina_list_push(&result, riina_string(p));");
        self.writeln("    }");
        self.writeln("    free(str);");
        self.writeln("    return riina_make_list(result);");
        self.writeln("}");
        self.writeln("");

        // teks_cantum (str_join): (String, List) -> String
        self.writeln("static riina_value_t* riina_builtin_teks_cantum(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* sep = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* lst = arg->data.pair_val.snd;");
        self.writeln(
            "    if (sep->tag != RIINA_TAG_STRING || lst->tag != RIINA_TAG_LIST) abort();",
        );
        self.writeln("    riina_list_t* l = RIINA_LIST_DATA(lst);");
        self.writeln("    size_t total = 0;");
        self.writeln("    for (size_t i = 0; i < l->len; i++) {");
        self.writeln("        if (l->items[i]->tag == RIINA_TAG_STRING) total += l->items[i]->data.string_val.len;");
        self.writeln("        if (i > 0) total += sep->data.string_val.len;");
        self.writeln("    }");
        self.writeln("    char* buf = (char*)malloc(total + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    buf[0] = '\\0';");
        self.writeln("    size_t off = 0;");
        self.writeln("    for (size_t i = 0; i < l->len; i++) {");
        self.writeln("        if (i > 0) { memcpy(buf + off, sep->data.string_val.data, sep->data.string_val.len); off += sep->data.string_val.len; }");
        self.writeln("        if (l->items[i]->tag == RIINA_TAG_STRING) { memcpy(buf + off, l->items[i]->data.string_val.data, l->items[i]->data.string_val.len); off += l->items[i]->data.string_val.len; }");
        self.writeln("    }");
        self.writeln("    buf[off] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_potong (str_trim)
        self.writeln("static riina_value_t* riina_builtin_teks_potong(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    const char* s = arg->data.string_val.data;");
        self.writeln("    size_t len = arg->data.string_val.len;");
        self.writeln("    size_t start = 0, end = len;");
        self.writeln("    while (start < len && (s[start]==' '||s[start]=='\\t'||s[start]=='\\n'||s[start]=='\\r')) start++;");
        self.writeln("    while (end > start && (s[end-1]==' '||s[end-1]=='\\t'||s[end-1]=='\\n'||s[end-1]=='\\r')) end--;");
        self.writeln("    char* buf = (char*)malloc(end - start + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    memcpy(buf, s + start, end - start);");
        self.writeln("    buf[end - start] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_mengandungi (str_contains): (String, String) -> Bool
        self.writeln("static riina_value_t* riina_builtin_teks_mengandungi(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* sub = arg->data.pair_val.snd;");
        self.writeln(
            "    if (s->tag != RIINA_TAG_STRING || sub->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln("    return riina_bool(strstr(s->data.string_val.data, sub->data.string_val.data) != NULL);");
        self.writeln("}");
        self.writeln("");

        // teks_ganti (str_replace): (String, (String, String)) -> String
        self.writeln("static riina_value_t* riina_builtin_teks_ganti(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* p = arg->data.pair_val.snd;");
        self.writeln("    if (s->tag != RIINA_TAG_STRING || p->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* from = p->data.pair_val.fst;");
        self.writeln("    riina_value_t* to = p->data.pair_val.snd;");
        self.writeln(
            "    if (from->tag != RIINA_TAG_STRING || to->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln("    const char* src = s->data.string_val.data;");
        self.writeln(
            "    size_t flen = from->data.string_val.len, tlen = to->data.string_val.len;",
        );
        self.writeln("    if (flen == 0) return s;");
        self.writeln("    /* Count occurrences */");
        self.writeln("    size_t count = 0;");
        self.writeln("    const char* tmp = src;");
        self.writeln("    while ((tmp = strstr(tmp, from->data.string_val.data)) != NULL) { count++; tmp += flen; }");
        self.writeln("    size_t newlen = s->data.string_val.len + count * (tlen - flen);");
        self.writeln("    char* buf = (char*)malloc(newlen + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    char* dst = buf;");
        self.writeln("    tmp = src;");
        self.writeln("    const char* found;");
        self.writeln("    while ((found = strstr(tmp, from->data.string_val.data)) != NULL) {");
        self.writeln("        size_t chunk = (size_t)(found - tmp);");
        self.writeln("        memcpy(dst, tmp, chunk); dst += chunk;");
        self.writeln("        memcpy(dst, to->data.string_val.data, tlen); dst += tlen;");
        self.writeln("        tmp = found + flen;");
        self.writeln("    }");
        self.writeln("    strcpy(dst, tmp);");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_mula_dengan (str_starts_with)
        self.writeln("static riina_value_t* riina_builtin_teks_mula_dengan(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* pfx = arg->data.pair_val.snd;");
        self.writeln(
            "    if (s->tag != RIINA_TAG_STRING || pfx->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln(
            "    if (pfx->data.string_val.len > s->data.string_val.len) return riina_bool(false);",
        );
        self.writeln("    return riina_bool(strncmp(s->data.string_val.data, pfx->data.string_val.data, pfx->data.string_val.len) == 0);");
        self.writeln("}");
        self.writeln("");

        // teks_akhir_dengan (str_ends_with)
        self.writeln("static riina_value_t* riina_builtin_teks_akhir_dengan(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* sfx = arg->data.pair_val.snd;");
        self.writeln(
            "    if (s->tag != RIINA_TAG_STRING || sfx->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln(
            "    if (sfx->data.string_val.len > s->data.string_val.len) return riina_bool(false);",
        );
        self.writeln("    size_t off = s->data.string_val.len - sfx->data.string_val.len;");
        self.writeln("    return riina_bool(strcmp(s->data.string_val.data + off, sfx->data.string_val.data) == 0);");
        self.writeln("}");
        self.writeln("");

        // teks_huruf_besar (str_to_upper)
        self.writeln("static riina_value_t* riina_builtin_teks_huruf_besar(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    size_t len = arg->data.string_val.len;");
        self.writeln("    char* buf = (char*)malloc(len + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    for (size_t i = 0; i < len; i++) {");
        self.writeln("        char c = arg->data.string_val.data[i];");
        self.writeln("        buf[i] = (c >= 'a' && c <= 'z') ? (char)(c - 32) : c;");
        self.writeln("    }");
        self.writeln("    buf[len] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_huruf_kecil (str_to_lower)
        self.writeln("static riina_value_t* riina_builtin_teks_huruf_kecil(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    size_t len = arg->data.string_val.len;");
        self.writeln("    char* buf = (char*)malloc(len + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    for (size_t i = 0; i < len; i++) {");
        self.writeln("        char c = arg->data.string_val.data[i];");
        self.writeln("        buf[i] = (c >= 'A' && c <= 'Z') ? (char)(c + 32) : c;");
        self.writeln("    }");
        self.writeln("    buf[len] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_aksara_di (str_char_at): (String, Int) -> String
        self.writeln("static riina_value_t* riina_builtin_teks_aksara_di(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* idx = arg->data.pair_val.snd;");
        self.writeln("    if (s->tag != RIINA_TAG_STRING || idx->tag != RIINA_TAG_INT) abort();");
        self.writeln("    size_t i = (size_t)idx->data.int_val;");
        self.writeln("    if (i >= s->data.string_val.len) { fprintf(stderr, \"RIINA: char_at out of bounds\\n\"); abort(); }");
        self.writeln("    char c[2] = { s->data.string_val.data[i], 0 };");
        self.writeln("    return riina_string(c);");
        self.writeln("}");
        self.writeln("");

        // teks_sub (str_substring): (String, (Int, Int)) -> String
        self.writeln("static riina_value_t* riina_builtin_teks_sub(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* range = arg->data.pair_val.snd;");
        self.writeln(
            "    if (s->tag != RIINA_TAG_STRING || range->tag != RIINA_TAG_PAIR) abort();",
        );
        self.writeln("    size_t start = (size_t)range->data.pair_val.fst->data.int_val;");
        self.writeln("    size_t end = (size_t)range->data.pair_val.snd->data.int_val;");
        self.writeln("    if (start > s->data.string_val.len) start = s->data.string_val.len;");
        self.writeln("    if (end > s->data.string_val.len) end = s->data.string_val.len;");
        self.writeln("    if (end < start) end = start;");
        self.writeln("    size_t len = end - start;");
        self.writeln("    char* buf = (char*)malloc(len + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    memcpy(buf, s->data.string_val.data + start, len);");
        self.writeln("    buf[len] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_indeks (str_index_of): (String, String) -> Int
        self.writeln("static riina_value_t* riina_builtin_teks_indeks(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* sub = arg->data.pair_val.snd;");
        self.writeln(
            "    if (s->tag != RIINA_TAG_STRING || sub->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln(
            "    const char* found = strstr(s->data.string_val.data, sub->data.string_val.data);",
        );
        self.writeln(
            "    if (found) return riina_int((uint64_t)(found - s->data.string_val.data));",
        );
        self.writeln("    return riina_int(UINT64_MAX);");
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // LIST BUILTINS (senarai)
        // ═══════════════════════════════════════════════════════════════════

        // senarai_baru (list_new)
        self.writeln("static riina_value_t* riina_builtin_senarai_baru(riina_value_t* arg) {");
        self.writeln("    (void)arg;");
        self.writeln("    riina_list_t l = riina_list_new();");
        self.writeln("    return riina_make_list(l);");
        self.writeln("}");
        self.writeln("");

        // senarai_tolak (list_push): (List, Value) -> List
        self.writeln("static riina_value_t* riina_builtin_senarai_tolak(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lst = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* val = arg->data.pair_val.snd;");
        self.writeln("    if (lst->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(lst);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln(
            "    for (size_t i = 0; i < old->len; i++) riina_list_push(&nl, old->items[i]);",
        );
        self.writeln("    riina_list_push(&nl, val);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_dapat (list_get): (List, Int) -> Value
        self.writeln("static riina_value_t* riina_builtin_senarai_dapat(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lst = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* idx = arg->data.pair_val.snd;");
        self.writeln("    if (lst->tag != RIINA_TAG_LIST || idx->tag != RIINA_TAG_INT) abort();");
        self.writeln("    riina_list_t* l = RIINA_LIST_DATA(lst);");
        self.writeln("    size_t i = (size_t)idx->data.int_val;");
        self.writeln("    if (i >= l->len) { fprintf(stderr, \"RIINA: list index out of bounds\\n\"); abort(); }");
        self.writeln("    return l->items[i];");
        self.writeln("}");
        self.writeln("");

        // senarai_panjang (list_len)
        self.writeln("static riina_value_t* riina_builtin_senarai_panjang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    return riina_int((uint64_t)RIINA_LIST_DATA(arg)->len);");
        self.writeln("}");
        self.writeln("");

        // ── Higher-order list builtins ────────────────────────────────────
        //
        // `senarai_peta`/`senarai_tapis`/`senarai_lipat` were listed as
        // codegen-supported (so `docs/api/STDLIB.md` published them as
        // "native-only") but no C body was ever emitted, so any program using
        // one died at LINK time with `undefined reference to
        // riina_builtin_senarai_peta`. That hit every `untuk` loop, which
        // desugars to `senarai_peta` — i.e. the most idiomatic loop in the
        // language could not be compiled, and said so only as a linker error.
        //
        // Calling back into a RIINA closure mirrors `Instruction::Call`: a
        // closure with captures takes `(_self, arg)`, one without takes `(arg)`.
        self.writeln("static riina_value_t* riina_apply_closure(riina_value_t* f, riina_value_t* x) {");
        self.writeln("    if (f->tag != RIINA_TAG_CLOSURE) { fprintf(stderr, \"RIINA: call on non-closure\\n\"); abort(); }");
        self.writeln("    if (f->data.closure_val.num_captures > 0) {");
        self.writeln("        return ((riina_value_t* (*)(riina_value_t*, riina_value_t*))f->data.closure_val.func_ptr)(f, x);");
        self.writeln("    }");
        self.writeln("    return ((riina_value_t* (*)(riina_value_t*))f->data.closure_val.func_ptr)(x);");
        self.writeln("}");
        self.writeln("");

        // senarai_peta (list_map): (list, fn) -> list
        self.writeln("static riina_value_t* riina_builtin_senarai_peta(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* f  = arg->data.pair_val.snd;");
        self.writeln("    if (lv->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(lv);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < old->len; i++) {");
        self.writeln("        riina_list_push(&nl, riina_apply_closure(f, old->items[i]));");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_tapis (list_filter): (list, fn) -> list
        self.writeln("static riina_value_t* riina_builtin_senarai_tapis(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* f  = arg->data.pair_val.snd;");
        self.writeln("    if (lv->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(lv);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < old->len; i++) {");
        self.writeln("        riina_value_t* keep = riina_apply_closure(f, old->items[i]);");
        self.writeln("        if (keep->tag == RIINA_TAG_BOOL && keep->data.bool_val) {");
        self.writeln("            riina_list_push(&nl, old->items[i]);");
        self.writeln("        }");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_lipat (list_fold): (list, (init, fn)) -> value.
        // `fn` is curried — `fn(acc)(item)` — matching how the interpreter
        // applies a two-parameter RIINA lambda.
        self.writeln("static riina_value_t* riina_builtin_senarai_lipat(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* rest = arg->data.pair_val.snd;");
        self.writeln("    if (lv->tag != RIINA_TAG_LIST || rest->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* acc = rest->data.pair_val.fst;");
        self.writeln("    riina_value_t* f = rest->data.pair_val.snd;");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(lv);");
        self.writeln("    for (size_t i = 0; i < old->len; i++) {");
        self.writeln("        acc = riina_apply_closure(riina_apply_closure(f, acc), old->items[i]);");
        self.writeln("    }");
        self.writeln("    return acc;");
        self.writeln("}");
        self.writeln("");

        // senarai_balik (list_reverse)
        self.writeln("static riina_value_t* riina_builtin_senarai_balik(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(arg);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln(
            "    for (size_t i = old->len; i > 0; i--) riina_list_push(&nl, old->items[i-1]);",
        );
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_susun (list_sort) — sorts ints ascending
        self.writeln("static int riina_cmp_values(const void* a, const void* b) {");
        self.writeln("    riina_value_t* va = *(riina_value_t**)a;");
        self.writeln("    riina_value_t* vb = *(riina_value_t**)b;");
        self.writeln("    if (va->tag == RIINA_TAG_INT && vb->tag == RIINA_TAG_INT) {");
        self.writeln("        if (va->data.int_val < vb->data.int_val) return -1;");
        self.writeln("        if (va->data.int_val > vb->data.int_val) return 1;");
        self.writeln("        return 0;");
        self.writeln("    }");
        self.writeln("    return 0;");
        self.writeln("}");
        self.writeln("");
        self.writeln("static riina_value_t* riina_builtin_senarai_susun(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(arg);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln(
            "    for (size_t i = 0; i < old->len; i++) riina_list_push(&nl, old->items[i]);",
        );
        self.writeln("    if (nl.len > 1) qsort(nl.items, nl.len, sizeof(riina_value_t*), riina_cmp_values);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_mengandungi (list_contains): (List, Value) -> Bool
        self.writeln("static bool riina_values_equal(riina_value_t* a, riina_value_t* b) {");
        self.writeln("    return riina_binop_eq(a, b)->data.bool_val;");
        self.writeln("}");
        self.writeln("");
        self.writeln(
            "static riina_value_t* riina_builtin_senarai_mengandungi(riina_value_t* arg) {",
        );
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lst = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* val = arg->data.pair_val.snd;");
        self.writeln("    if (lst->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* l = RIINA_LIST_DATA(lst);");
        self.writeln("    for (size_t i = 0; i < l->len; i++) {");
        self.writeln("        if (riina_values_equal(l->items[i], val)) return riina_bool(true);");
        self.writeln("    }");
        self.writeln("    return riina_bool(false);");
        self.writeln("}");
        self.writeln("");

        // senarai_sambung (list_concat): (List, List) -> List
        self.writeln("static riina_value_t* riina_builtin_senarai_sambung(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* la = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* lb = arg->data.pair_val.snd;");
        self.writeln("    if (la->tag != RIINA_TAG_LIST || lb->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* a = RIINA_LIST_DATA(la);");
        self.writeln("    riina_list_t* b = RIINA_LIST_DATA(lb);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < a->len; i++) riina_list_push(&nl, a->items[i]);");
        self.writeln("    for (size_t i = 0; i < b->len; i++) riina_list_push(&nl, b->items[i]);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_kepala (list_head)
        self.writeln("static riina_value_t* riina_builtin_senarai_kepala(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* l = RIINA_LIST_DATA(arg);");
        self.writeln(
            "    if (l->len == 0) { fprintf(stderr, \"RIINA: head of empty list\\n\"); abort(); }",
        );
        self.writeln("    return l->items[0];");
        self.writeln("}");
        self.writeln("");

        // senarai_ekor (list_tail)
        self.writeln("static riina_value_t* riina_builtin_senarai_ekor(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* l = RIINA_LIST_DATA(arg);");
        self.writeln(
            "    if (l->len == 0) { fprintf(stderr, \"RIINA: tail of empty list\\n\"); abort(); }",
        );
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 1; i < l->len; i++) riina_list_push(&nl, l->items[i]);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_zip (list_zip): (List, List) -> List
        self.writeln("static riina_value_t* riina_builtin_senarai_zip(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* la = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* lb = arg->data.pair_val.snd;");
        self.writeln("    if (la->tag != RIINA_TAG_LIST || lb->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* a = RIINA_LIST_DATA(la);");
        self.writeln("    riina_list_t* b = RIINA_LIST_DATA(lb);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    size_t min = a->len < b->len ? a->len : b->len;");
        self.writeln("    for (size_t i = 0; i < min; i++) riina_list_push(&nl, riina_pair(a->items[i], b->items[i]));");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_nombor (list_enumerate): List -> List of (Int, Value)
        self.writeln("static riina_value_t* riina_builtin_senarai_nombor(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* l = RIINA_LIST_DATA(arg);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < l->len; i++) riina_list_push(&nl, riina_pair(riina_int((uint64_t)i), l->items[i]));");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // MAP BUILTINS (peta)
        // ═══════════════════════════════════════════════════════════════════

        // peta_baru (map_new)
        self.writeln("static riina_value_t* riina_builtin_peta_baru(riina_value_t* arg) {");
        self.writeln("    (void)arg;");
        self.writeln("    riina_map_t m = { NULL, 0 };");
        self.writeln("    return riina_make_map(m);");
        self.writeln("}");
        self.writeln("");

        // Canonical map insert: strcmp-sorted key order, replacing on equal.
        //
        // The interpreter backs `Value::Map` with a `BTreeMap`, so its iteration
        // order is sorted by key. The C runtime used to append each new key at
        // the tail — insertion order — so `peta_kunci` returned a different
        // sequence under `riinac run` than under a compiled binary, and
        // `json_ke_teks` serialised the same object into two different strings.
        // Every map-producing builtin now funnels through this one helper so the
        // ordering rule is stated once and cannot drift between them.
        self.writeln("static void riina_map_put_sorted(riina_map_t* m, const char* key, riina_value_t* val) {");
        self.writeln("    riina_map_entry_t** slot = &m->head;");
        self.writeln("    while (*slot) {");
        self.writeln("        int c = strcmp((*slot)->key, key);");
        self.writeln("        if (c == 0) { (*slot)->value = val; return; }");
        self.writeln("        if (c > 0) break;");
        self.writeln("        slot = &(*slot)->next;");
        self.writeln("    }");
        self.writeln("    riina_map_entry_t* ne = (riina_map_entry_t*)malloc(sizeof(riina_map_entry_t));");
        self.writeln("    if (!ne) abort();");
        self.writeln("    ne->key = strdup(key);");
        self.writeln("    if (!ne->key) abort();");
        self.writeln("    ne->value = val;");
        self.writeln("    ne->next = *slot;");
        self.writeln("    *slot = ne;");
        self.writeln("    m->len++;");
        self.writeln("}");
        self.writeln("");

        // peta_letak (map_insert): (Map, (String, Value)) -> Map
        self.writeln("static riina_value_t* riina_builtin_peta_letak(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* mv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* kv = arg->data.pair_val.snd;");
        self.writeln("    if (mv->tag != RIINA_TAG_MAP || kv->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* key = kv->data.pair_val.fst;");
        self.writeln("    riina_value_t* val = kv->data.pair_val.snd;");
        self.writeln("    if (key->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_map_t* old = RIINA_MAP_DATA(mv);");
        self.writeln("    /* Rebuild through the sorted insert so the result is");
        self.writeln("       canonically ordered even if `old` somehow was not. */");
        self.writeln("    riina_map_t nm = { NULL, 0 };");
        self.writeln("    for (riina_map_entry_t* e = old->head; e; e = e->next) {");
        self.writeln("        riina_map_put_sorted(&nm, e->key, e->value);");
        self.writeln("    }");
        self.writeln("    riina_map_put_sorted(&nm, key->data.string_val.data, val);");
        self.writeln("    return riina_make_map(nm);");
        self.writeln("}");
        self.writeln("");

        // peta_dapat (map_get): (Map, String) -> Value
        self.writeln("static riina_value_t* riina_builtin_peta_dapat(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* mv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* key = arg->data.pair_val.snd;");
        self.writeln("    if (mv->tag != RIINA_TAG_MAP || key->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_map_t* m = RIINA_MAP_DATA(mv);");
        self.writeln("    for (riina_map_entry_t* e = m->head; e; e = e->next) {");
        self.writeln(
            "        if (strcmp(e->key, key->data.string_val.data) == 0) return e->value;",
        );
        self.writeln("    }");
        self.writeln("    fprintf(stderr, \"RIINA: key not found in map\\n\"); abort();");
        self.writeln("    return NULL;");
        self.writeln("}");
        self.writeln("");

        // peta_buang (map_remove): (Map, String) -> Map
        self.writeln("static riina_value_t* riina_builtin_peta_buang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* mv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* key = arg->data.pair_val.snd;");
        self.writeln("    if (mv->tag != RIINA_TAG_MAP || key->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_map_t* old = RIINA_MAP_DATA(mv);");
        self.writeln("    riina_map_t nm = { NULL, 0 };");
        self.writeln("    for (riina_map_entry_t* e = old->head; e; e = e->next) {");
        self.writeln("        if (strcmp(e->key, key->data.string_val.data) != 0) {");
        self.writeln("            riina_map_put_sorted(&nm, e->key, e->value);");
        self.writeln("        }");
        self.writeln("    }");
        self.writeln("    return riina_make_map(nm);");
        self.writeln("}");
        self.writeln("");

        // peta_kunci (map_keys): Map -> List
        self.writeln("static riina_value_t* riina_builtin_peta_kunci(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_MAP) abort();");
        self.writeln("    riina_map_t* m = RIINA_MAP_DATA(arg);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (riina_map_entry_t* e = m->head; e; e = e->next) riina_list_push(&nl, riina_string(e->key));");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // peta_nilai (map_values): Map -> List
        self.writeln("static riina_value_t* riina_builtin_peta_nilai(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_MAP) abort();");
        self.writeln("    riina_map_t* m = RIINA_MAP_DATA(arg);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (riina_map_entry_t* e = m->head; e; e = e->next) riina_list_push(&nl, e->value);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // peta_mengandungi (map_contains): (Map, String) -> Bool
        self.writeln("static riina_value_t* riina_builtin_peta_mengandungi(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* mv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* key = arg->data.pair_val.snd;");
        self.writeln("    if (mv->tag != RIINA_TAG_MAP || key->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_map_t* m = RIINA_MAP_DATA(mv);");
        self.writeln("    for (riina_map_entry_t* e = m->head; e; e = e->next) {");
        self.writeln(
            "        if (strcmp(e->key, key->data.string_val.data) == 0) return riina_bool(true);",
        );
        self.writeln("    }");
        self.writeln("    return riina_bool(false);");
        self.writeln("}");
        self.writeln("");

        // peta_panjang (map_len): Map -> Int
        self.writeln("static riina_value_t* riina_builtin_peta_panjang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_MAP) abort();");
        self.writeln("    return riina_int((uint64_t)RIINA_MAP_DATA(arg)->len);");
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // SET BUILTINS (set) — uses List internally
        // ═══════════════════════════════════════════════════════════════════

        // set_baru (set_new)
        self.writeln("static riina_value_t* riina_builtin_set_baru(riina_value_t* arg) {");
        self.writeln("    (void)arg;");
        self.writeln("    riina_list_t l = riina_list_new();");
        self.writeln("    return riina_make_list(l);");
        self.writeln("}");
        self.writeln("");

        // set_letak (set_insert): (List, Value) -> List
        self.writeln("static riina_value_t* riina_builtin_set_letak(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lst = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* val = arg->data.pair_val.snd;");
        self.writeln("    if (lst->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(lst);");
        self.writeln("    /* Check if already present */");
        self.writeln("    for (size_t i = 0; i < old->len; i++) {");
        self.writeln("        if (riina_values_equal(old->items[i], val)) return lst;");
        self.writeln("    }");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln(
            "    for (size_t i = 0; i < old->len; i++) riina_list_push(&nl, old->items[i]);",
        );
        self.writeln("    riina_list_push(&nl, val);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // set_buang (set_remove): (List, Value) -> List
        self.writeln("static riina_value_t* riina_builtin_set_buang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lst = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* val = arg->data.pair_val.snd;");
        self.writeln("    if (lst->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(lst);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < old->len; i++) {");
        self.writeln("        if (!riina_values_equal(old->items[i], val)) riina_list_push(&nl, old->items[i]);");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // set_mengandungi (set_contains): (List, Value) -> Bool
        self.writeln("static riina_value_t* riina_builtin_set_mengandungi(riina_value_t* arg) {");
        self.writeln("    return riina_builtin_senarai_mengandungi(arg);");
        self.writeln("}");
        self.writeln("");

        // set_kesatuan (set_union): (List, List) -> List
        self.writeln("static riina_value_t* riina_builtin_set_kesatuan(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* la = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* lb = arg->data.pair_val.snd;");
        self.writeln("    if (la->tag != RIINA_TAG_LIST || lb->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* a = RIINA_LIST_DATA(la);");
        self.writeln("    riina_list_t* b = RIINA_LIST_DATA(lb);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < a->len; i++) riina_list_push(&nl, a->items[i]);");
        self.writeln("    for (size_t i = 0; i < b->len; i++) {");
        self.writeln("        bool found = false;");
        self.writeln("        for (size_t j = 0; j < a->len; j++) {");
        self.writeln("            if (riina_values_equal(a->items[j], b->items[i])) { found = true; break; }");
        self.writeln("        }");
        self.writeln("        if (!found) riina_list_push(&nl, b->items[i]);");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // set_persilangan (set_intersect): (List, List) -> List
        self.writeln("static riina_value_t* riina_builtin_set_persilangan(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* la = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* lb = arg->data.pair_val.snd;");
        self.writeln("    if (la->tag != RIINA_TAG_LIST || lb->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* a = RIINA_LIST_DATA(la);");
        self.writeln("    riina_list_t* b = RIINA_LIST_DATA(lb);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < a->len; i++) {");
        self.writeln("        for (size_t j = 0; j < b->len; j++) {");
        self.writeln("            if (riina_values_equal(a->items[i], b->items[j])) {");
        self.writeln("                riina_list_push(&nl, a->items[i]);");
        self.writeln("                break;");
        self.writeln("            }");
        self.writeln("        }");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // set_panjang (set_len)
        self.writeln("static riina_value_t* riina_builtin_set_panjang(riina_value_t* arg) {");
        self.writeln("    return riina_builtin_senarai_panjang(arg);");
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // TIME BUILTINS (masa)
        // ═══════════════════════════════════════════════════════════════════

        self.writeln("#include <time.h>");
        self.writeln("");

        // masa_sekarang (time_now): () -> Int
        self.writeln("static riina_value_t* riina_builtin_masa_sekarang(riina_value_t* arg) {");
        self.writeln("    (void)arg;");
        self.writeln("    return riina_int((uint64_t)time(NULL));");
        self.writeln("}");
        self.writeln("");

        // masa_sekarang_ms (time_now_ms): () -> Int
        self.writeln("static riina_value_t* riina_builtin_masa_sekarang_ms(riina_value_t* arg) {");
        self.writeln("    (void)arg;");
        self.writeln("    struct timespec ts;");
        self.writeln("    clock_gettime(CLOCK_REALTIME, &ts);");
        self.writeln(
            "    return riina_int((uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000);",
        );
        self.writeln("}");
        self.writeln("");

        // Civil calendar, mirroring `builtins::masa` exactly.
        //
        // Deliberately NOT strftime/strptime. libc can format dates; the
        // interpreter cannot reach an equivalent under Law 8, so letting libc
        // define the contract guaranteed the backends disagreed — and they
        // did: `masa_format((1700000000, "%Y-%m-%d"))` gave `2023-11-14` here
        // and `1700000000` interpreted, because the interpreter ignored the
        // format string outright (REQ-70). One algorithm, two implementations,
        // pinned by a differential.
        self.writeln("static void riina_civil_from_days(int64_t z, int64_t* y, uint32_t* m, uint32_t* d) {");
        self.writeln("    z += 719468;");
        self.writeln("    int64_t era = (z >= 0 ? z : z - 146096) / 146097;");
        self.writeln("    uint64_t doe = (uint64_t)(z - era * 146097);");
        self.writeln("    uint64_t yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365;");
        self.writeln("    int64_t yy = (int64_t)yoe + era * 400;");
        self.writeln("    uint64_t doy = doe - (365*yoe + yoe/4 - yoe/100);");
        self.writeln("    uint64_t mp = (5*doy + 2) / 153;");
        self.writeln("    *d = (uint32_t)(doy - (153*mp + 2)/5 + 1);");
        self.writeln("    *m = (uint32_t)(mp < 10 ? mp + 3 : mp - 9);");
        self.writeln("    *y = (*m <= 2) ? yy + 1 : yy;");
        self.writeln("}");
        self.writeln("");
        self.writeln("static int64_t riina_days_from_civil(int64_t y, uint32_t m, uint32_t d) {");
        self.writeln("    y -= (m <= 2);");
        self.writeln("    int64_t era = (y >= 0 ? y : y - 399) / 400;");
        self.writeln("    uint64_t yoe = (uint64_t)(y - era * 400);");
        self.writeln("    uint64_t mp = (m > 2 ? m - 3 : m + 9);");
        self.writeln("    uint64_t doy = (153*mp + 2)/5 + d - 1;");
        self.writeln("    uint64_t doe = yoe*365 + yoe/4 - yoe/100 + doy;");
        self.writeln("    return era * 146097 + (int64_t)doe - 719468;");
        self.writeln("}");
        self.writeln("");

        // masa_format (time_format): (Int, String) -> String
        self.writeln("static riina_value_t* riina_builtin_masa_format(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* tsv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* fmt = arg->data.pair_val.snd;");
        self.writeln("    if (tsv->tag != RIINA_TAG_INT || fmt->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    int64_t ts = (int64_t)tsv->data.int_val;");
        self.writeln("    int64_t days = ts / 86400; int64_t rem = ts % 86400;");
        self.writeln("    if (rem < 0) { rem += 86400; days -= 1; }  /* floor, not trunc */");
        self.writeln("    int64_t y; uint32_t mo, d;");
        self.writeln("    riina_civil_from_days(days, &y, &mo, &d);");
        self.writeln("    uint32_t hh = (uint32_t)(rem/3600), mi = (uint32_t)((rem%3600)/60), ss = (uint32_t)(rem%60);");
        self.writeln("    char buf[512]; size_t o = 0;");
        self.writeln("    const char* f = fmt->data.string_val.data;");
        self.writeln("    for (size_t i = 0; f[i] && o + 32 < sizeof(buf); i++) {");
        self.writeln("        if (f[i] != '%') { buf[o++] = f[i]; continue; }");
        self.writeln("        char sp = f[i+1];");
        self.writeln("        if (sp == 0) { buf[o++] = '%'; break; }");
        self.writeln("        i++;");
        self.writeln("        switch (sp) {");
        self.writeln("            case 'Y': o += (size_t)snprintf(buf+o, 32, \"%04lld\", (long long)y); break;");
        self.writeln("            case 'm': o += (size_t)snprintf(buf+o, 32, \"%02u\", mo); break;");
        self.writeln("            case 'd': o += (size_t)snprintf(buf+o, 32, \"%02u\", d); break;");
        self.writeln("            case 'H': o += (size_t)snprintf(buf+o, 32, \"%02u\", hh); break;");
        self.writeln("            case 'M': o += (size_t)snprintf(buf+o, 32, \"%02u\", mi); break;");
        self.writeln("            case 'S': o += (size_t)snprintf(buf+o, 32, \"%02u\", ss); break;");
        self.writeln("            case 's': o += (size_t)snprintf(buf+o, 32, \"%lld\", (long long)ts); break;");
        self.writeln("            case '%': buf[o++] = '%'; break;");
        self.writeln("            /* Unsupported specifier is emitted LITERALLY, % and all, so it");
        self.writeln("               is visible rather than silently dropped — matching Rust. */");
        self.writeln("            default: buf[o++] = '%'; buf[o++] = sp; break;");
        self.writeln("        }");
        self.writeln("    }");
        self.writeln("    buf[o] = 0;");
        self.writeln("    return riina_string(buf);");
        self.writeln("}");
        self.writeln("");

        // masa_urai (time_parse): (String, String) -> Int
        self.writeln("static riina_value_t* riina_builtin_masa_urai(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* sv = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* fmt = arg->data.pair_val.snd;");
        self.writeln(
            "    if (sv->tag != RIINA_TAG_STRING || fmt->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln("    const char* s = sv->data.string_val.data;");
        self.writeln("    const char* f = fmt->data.string_val.data;");
        self.writeln("    int64_t y = 1970; uint32_t mo = 1, d = 1, hh = 0, mi = 0, ss = 0;");
        self.writeln("    int64_t epoch = 0; int have_epoch = 0; size_t i = 0;");
        self.writeln("    for (size_t k = 0; f[k]; k++) {");
        self.writeln("        if (f[k] != '%') { if (s[i] != f[k]) goto bad; i++; continue; }");
        self.writeln("        char sp = f[++k];");
        self.writeln("        if (sp == 0) goto bad;");
        self.writeln("        if (sp == '%') { if (s[i] != '%') goto bad; i++; continue; }");
        self.writeln("        int width;");
        self.writeln("        switch (sp) {");
        self.writeln("            case 'Y': width = 4; break;");
        self.writeln("            case 'm': case 'd': case 'H': case 'M': case 'S': width = 2; break;");
        self.writeln("            case 's': width = 20; break;");
        self.writeln("            default:");
        self.writeln("                if (s[i] != '%' || s[i+1] != sp) goto bad;");
        self.writeln("                i += 2; continue;");
        self.writeln("        }");
        self.writeln("        size_t start = i;");
        self.writeln("        if (sp == 's' && s[i] == '-') i++;");
        self.writeln("        while (s[i] && (int)(i - start) < width && s[i] >= '0' && s[i] <= '9') i++;");
        self.writeln("        if (i == start) goto bad;");
        self.writeln("        char num[32]; size_t n = i - start;");
        self.writeln("        if (n >= sizeof(num)) goto bad;");
        self.writeln("        memcpy(num, s + start, n); num[n] = 0;");
        self.writeln("        long long v = atoll(num);");
        self.writeln("        switch (sp) {");
        self.writeln("            case 'Y': y = (int64_t)v; break;");
        self.writeln("            case 'm': mo = (uint32_t)v; break;");
        self.writeln("            case 'd': d = (uint32_t)v; break;");
        self.writeln("            case 'H': hh = (uint32_t)v; break;");
        self.writeln("            case 'M': mi = (uint32_t)v; break;");
        self.writeln("            case 'S': ss = (uint32_t)v; break;");
        self.writeln("            case 's': epoch = (int64_t)v; have_epoch = 1; break;");
        self.writeln("        }");
        self.writeln("    }");
        self.writeln("    if (s[i] != 0) goto bad;");
        self.writeln("    if (have_epoch) return riina_int((uint64_t)epoch);");
        self.writeln("    if (mo < 1 || mo > 12 || d < 1 || d > 31 || hh > 23 || mi > 59 || ss > 59) goto bad;");
        self.writeln("    return riina_int((uint64_t)(riina_days_from_civil(y, mo, d) * 86400");
        self.writeln("                     + (int64_t)hh * 3600 + (int64_t)mi * 60 + (int64_t)ss));");
        self.writeln("bad:");
        self.writeln("    fprintf(stderr, \"RIINA: masa_urai cannot parse '%s' with format '%s'\\n\", s, f);");
        self.writeln("    abort();");
        self.writeln("}");
        self.writeln("");

        // masa_tidur (time_sleep): Int -> ()
        self.writeln("static riina_value_t* riina_builtin_masa_tidur(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_INT) abort();");
        self.writeln("    struct timespec ts;");
        self.writeln("    ts.tv_sec = (time_t)(arg->data.int_val / 1000);");
        self.writeln("    ts.tv_nsec = (long)((arg->data.int_val % 1000) * 1000000);");
        self.writeln("    nanosleep(&ts, NULL);");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // masa_jam (time_clock): () -> Int (monotonic nanoseconds)
        self.writeln("static riina_value_t* riina_builtin_masa_jam(riina_value_t* arg) {");
        self.writeln("    (void)arg;");
        self.writeln("    struct timespec ts;");
        self.writeln("    clock_gettime(CLOCK_MONOTONIC, &ts);");
        self.writeln(
            "    return riina_int((uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec);",
        );
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // DURABLE STORE BUILTINS (simpan) — REQ-70 family routing
        // ═══════════════════════════════════════════════════════════════════
        //
        // A second implementation of `riina-os::store`, in C. The ON-DISK
        // FORMAT is the contract and must be byte-identical, because a store
        // written by an interpreted program has to be readable by a compiled
        // one and vice versa — that cross-backend round trip is what the
        // differential actually checks. Emitted as a raw block rather than 250
        // escaped `writeln` calls so it stays readable AS C.
        self.emit_store_builtins();

        // ═══════════════════════════════════════════════════════════════════
        // NETWORK + HTTP BUILTINS (jaring, http) — REQ-70 family routing
        // ═══════════════════════════════════════════════════════════════════
        //
        // A second implementation of `riina-os::net` (the RFC 793 machine) and
        // `riina-os::http` (the strict RFC 9112 codec), in C. The WIRE FORMAT
        // is the contract: a request a compiled server parses must frame the
        // same way the interpreter frames it, and a response either emits must
        // be byte-identical — otherwise the two backends disagree about what a
        // message *is*, which is exactly the class of bug the strict parser
        // exists to refuse. The `jaring_tls_*` half is deliberately absent (it
        // needs the whole `riina-tls` stack in C); it stays interpreter-only
        // and fails closed rather than shipping a weaker TLS.
        self.emit_net_builtins();

        // ═══════════════════════════════════════════════════════════════════
        // ═══════════════════════════════════════════════════════════════════
        // SECURITY BUILTINS (keselamatan) — sanitizers, validators, and the
        // modelled sinks. REQ-70 family routing.
        // ═══════════════════════════════════════════════════════════════════
        //
        // Emitted as ONE raw-string block rather than ~200 `writeln` calls.
        // The rest of this file uses per-line `writeln`; at this volume that
        // is more transcription error than it is house style, and the block is
        // self-contained C with no interpolation. `writeln` indents only the
        // first line, which is cosmetic in C.
        //
        // These mirror `builtins::keselamatan` exactly, including the parts
        // that look like bugs and are not: `url_encode` iterates BYTES while
        // every other transform iterates CODEPOINTS, and `css_escape` emits a
        // trailing space after the hex escape (which CSS requires as a
        // terminator). Matching the interpreter matters more than matching
        // one's expectations of what the function ought to do.
        //
        // `constant_time_eq` is security-relevant and is transcribed as a
        // non-short-circuiting compare: a C version that returned early on the
        // first differing byte would leak by timing where the interpreter does
        // not — the same class of gap as the file gate, in a function whose
        // entire purpose is to not leak.
        self.writeln(r####"
/* ---- UTF-8 decode: one codepoint, advancing *i. Invalid bytes are passed
   through as U+FFFD-free single units so behaviour matches Rust's &str
   guarantee that the input was already valid UTF-8. ---- */
static uint32_t riina_sec_utf8_next(const char* s, size_t len, size_t* i) {
    unsigned char c = (unsigned char)s[*i];
    if (c < 0x80) { (*i) += 1; return c; }
    if ((c & 0xE0) == 0xC0 && *i + 1 < len) {
        uint32_t cp = ((uint32_t)(c & 0x1F) << 6) | (uint32_t)(s[*i+1] & 0x3F);
        (*i) += 2; return cp;
    }
    if ((c & 0xF0) == 0xE0 && *i + 2 < len) {
        uint32_t cp = ((uint32_t)(c & 0x0F) << 12) | ((uint32_t)(s[*i+1] & 0x3F) << 6)
                    | (uint32_t)(s[*i+2] & 0x3F);
        (*i) += 3; return cp;
    }
    if ((c & 0xF8) == 0xF0 && *i + 3 < len) {
        uint32_t cp = ((uint32_t)(c & 0x07) << 18) | ((uint32_t)(s[*i+1] & 0x3F) << 12)
                    | ((uint32_t)(s[*i+2] & 0x3F) << 6) | (uint32_t)(s[*i+3] & 0x3F);
        (*i) += 4; return cp;
    }
    (*i) += 1; return c;
}

static void riina_sec_put_utf8(char** b, size_t* n, size_t* cap, uint32_t cp);

static void riina_sec_reserve(char** b, size_t* n, size_t* cap, size_t extra) {
    while (*n + extra + 1 >= *cap) {
        *cap *= 2;
        *b = (char*)realloc(*b, *cap);
        if (!*b) abort();
    }
}

static void riina_sec_puts(char** b, size_t* n, size_t* cap, const char* s) {
    size_t l = strlen(s);
    riina_sec_reserve(b, n, cap, l);
    memcpy(*b + *n, s, l);
    *n += l;
}

static void riina_sec_putc(char** b, size_t* n, size_t* cap, char c) {
    riina_sec_reserve(b, n, cap, 1);
    (*b)[(*n)++] = c;
}

static void riina_sec_put_utf8(char** b, size_t* n, size_t* cap, uint32_t cp) {
    riina_sec_reserve(b, n, cap, 4);
    if (cp < 0x80) { (*b)[(*n)++] = (char)cp; }
    else if (cp < 0x800) {
        (*b)[(*n)++] = (char)(0xC0 | (cp >> 6));
        (*b)[(*n)++] = (char)(0x80 | (cp & 0x3F));
    } else if (cp < 0x10000) {
        (*b)[(*n)++] = (char)(0xE0 | (cp >> 12));
        (*b)[(*n)++] = (char)(0x80 | ((cp >> 6) & 0x3F));
        (*b)[(*n)++] = (char)(0x80 | (cp & 0x3F));
    } else {
        (*b)[(*n)++] = (char)(0xF0 | (cp >> 18));
        (*b)[(*n)++] = (char)(0x80 | ((cp >> 12) & 0x3F));
        (*b)[(*n)++] = (char)(0x80 | ((cp >> 6) & 0x3F));
        (*b)[(*n)++] = (char)(0x80 | (cp & 0x3F));
    }
}

/* Rust's char::is_whitespace, which str::trim uses. Enumerated because an
   ASCII-only trim would diverge on NBSP and the U+2000 block. */
static bool riina_sec_is_ws(uint32_t c) {
    return c == 0x20 || (c >= 0x09 && c <= 0x0D) || c == 0x85 || c == 0xA0
        || c == 0x1680 || (c >= 0x2000 && c <= 0x200A) || c == 0x2028
        || c == 0x2029 || c == 0x202F || c == 0x205F || c == 0x3000;
}

static bool riina_sec_ascii_alnum(uint32_t c) {
    return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
}

#define RIINA_SEC_BEGIN(argv) \
    if ((argv)->tag != RIINA_TAG_STRING) abort(); \
    const char* _s = (argv)->data.string_val.data; \
    size_t _slen = (argv)->data.string_val.len; \
    size_t _cap = _slen * 2 + 16, _n = 0; \
    char* _b = (char*)malloc(_cap); \
    if (!_b) abort();

#define RIINA_SEC_END() \
    _b[_n] = 0; \
    riina_value_t* _r = riina_string(_b); \
    free(_b); \
    return _r;

/* ---- Taint source. Routed alongside the sanitizers deliberately: it is the
   ONLY producer of `Tainted<Teks, UserInput>`, so without it every sanitizer
   would be marked `native-only` while being unreachable from any compiled
   program — the REQ-79 "lowers but aborts on contact" trap in a new costume.
   Taint is type-level, so the runtime value is just the line. ---- */
static riina_value_t* riina_builtin_baca_baris(riina_value_t* arg) {
    (void)arg;
    size_t cap = 256, n = 0;
    char* buf = (char*)malloc(cap);
    if (!buf) abort();
    int ch;
    while ((ch = fgetc(stdin)) != EOF) {
        if (n + 2 >= cap) { cap *= 2; buf = (char*)realloc(buf, cap); if (!buf) abort(); }
        buf[n++] = (char)ch;
        if (ch == '\n') break;
    }
    buf[n] = 0;
    /* Mirrors the interpreter: strip ALL trailing \n and \r, not just one. */
    while (n > 0 && (buf[n-1] == '\n' || buf[n-1] == '\r')) { buf[--n] = 0; }
    riina_value_t* r = riina_string(buf);
    free(buf);
    return r;
}

static riina_value_t* riina_builtin_sanitize_html(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c == '&') riina_sec_puts(&_b, &_n, &_cap, "&amp;");
        else if (c == '<') riina_sec_puts(&_b, &_n, &_cap, "&lt;");
        else if (c == '>') riina_sec_puts(&_b, &_n, &_cap, "&gt;");
        else if (c == '"') riina_sec_puts(&_b, &_n, &_cap, "&quot;");
        else if (c == '\'') riina_sec_puts(&_b, &_n, &_cap, "&#x27;");
        else if (c == '/') riina_sec_puts(&_b, &_n, &_cap, "&#x2F;");
        else riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_sanitize_xml(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c == '&') riina_sec_puts(&_b, &_n, &_cap, "&amp;");
        else if (c == '<') riina_sec_puts(&_b, &_n, &_cap, "&lt;");
        else if (c == '>') riina_sec_puts(&_b, &_n, &_cap, "&gt;");
        else if (c == '"') riina_sec_puts(&_b, &_n, &_cap, "&quot;");
        else if (c == '\'') riina_sec_puts(&_b, &_n, &_cap, "&apos;");
        else riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_sanitize_sql(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c == 0) { /* strip NUL */ }
        else if (c == '\\') riina_sec_puts(&_b, &_n, &_cap, "\\\\");
        else if (c == '\'') riina_sec_puts(&_b, &_n, &_cap, "''");
        else riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_sanitize_js(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    char tmp[16];
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (riina_sec_ascii_alnum(c)) {
            riina_sec_putc(&_b, &_n, &_cap, (char)c);
        } else if (c < 0x100) {
            snprintf(tmp, sizeof(tmp), "\\x%02X", (unsigned)c);
            riina_sec_puts(&_b, &_n, &_cap, tmp);
        } else if (c < 0x10000) {
            snprintf(tmp, sizeof(tmp), "\\u%04X", (unsigned)c);
            riina_sec_puts(&_b, &_n, &_cap, tmp);
        } else {
            /* Rust encode_utf16 yields a surrogate PAIR above the BMP. */
            uint32_t v = c - 0x10000;
            snprintf(tmp, sizeof(tmp), "\\u%04X", (unsigned)(0xD800 + (v >> 10)));
            riina_sec_puts(&_b, &_n, &_cap, tmp);
            snprintf(tmp, sizeof(tmp), "\\u%04X", (unsigned)(0xDC00 + (v & 0x3FF)));
            riina_sec_puts(&_b, &_n, &_cap, tmp);
        }
    }
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_sanitize_css(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    char tmp[16];
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (riina_sec_ascii_alnum(c)) {
            riina_sec_putc(&_b, &_n, &_cap, (char)c);
        } else {
            snprintf(tmp, sizeof(tmp), "\\%x ", (unsigned)c);
            riina_sec_puts(&_b, &_n, &_cap, tmp);
        }
    }
    RIINA_SEC_END()
}

/* NOTE: bytes, not codepoints — the interpreter iterates s.bytes() here. */
static riina_value_t* riina_builtin_sanitize_url(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    char tmp[8];
    for (size_t i = 0; i < _slen; i++) {
        unsigned char b = (unsigned char)_s[i];
        if ((b >= 'A' && b <= 'Z') || (b >= 'a' && b <= 'z') || (b >= '0' && b <= '9')
            || b == '-' || b == '.' || b == '_' || b == '~') {
            riina_sec_putc(&_b, &_n, &_cap, (char)b);
        } else {
            snprintf(tmp, sizeof(tmp), "%%%02X", b);
            riina_sec_puts(&_b, &_n, &_cap, tmp);
        }
    }
    RIINA_SEC_END()
}

/* Drop NULs, then split on '/' and '\\', dropping empty, "." and ".."
   segments, and rejoin with '/'. */
static riina_value_t* riina_builtin_sanitize_path(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    size_t seg_start = 0;
    bool first_out = true;
    char* seg = (char*)malloc(_slen + 1);
    if (!seg) abort();
    for (size_t i = 0; i <= _slen; i++) {
        char ch = (i < _slen) ? _s[i] : '/';
        if (ch == '/' || ch == '\\' || i == _slen) {
            size_t sl = 0;
            for (size_t k = seg_start; k < i; k++) {
                if (_s[k] != 0) seg[sl++] = _s[k];
            }
            seg[sl] = 0;
            bool skip = (sl == 0) || (strcmp(seg, ".") == 0) || (strcmp(seg, "..") == 0);
            if (!skip) {
                if (!first_out) riina_sec_putc(&_b, &_n, &_cap, '/');
                riina_sec_puts(&_b, &_n, &_cap, seg);
                first_out = false;
            }
            seg_start = i + 1;
        }
    }
    free(seg);
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_sanitize_command(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    riina_sec_putc(&_b, &_n, &_cap, '\'');
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c == '\'') riina_sec_puts(&_b, &_n, &_cap, "'\\''");
        else riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    riina_sec_putc(&_b, &_n, &_cap, '\'');
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_sanitize_ldap(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c == '\\') riina_sec_puts(&_b, &_n, &_cap, "\\5c");
        else if (c == '*') riina_sec_puts(&_b, &_n, &_cap, "\\2a");
        else if (c == '(') riina_sec_puts(&_b, &_n, &_cap, "\\28");
        else if (c == ')') riina_sec_puts(&_b, &_n, &_cap, "\\29");
        else if (c == 0) riina_sec_puts(&_b, &_n, &_cap, "\\00");
        else riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_sanitize_json(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    char tmp[16];
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c == '"') riina_sec_puts(&_b, &_n, &_cap, "\\\"");
        else if (c == '\\') riina_sec_puts(&_b, &_n, &_cap, "\\\\");
        else if (c == 0x08) riina_sec_puts(&_b, &_n, &_cap, "\\b");
        else if (c == 0x0C) riina_sec_puts(&_b, &_n, &_cap, "\\f");
        else if (c == '\n') riina_sec_puts(&_b, &_n, &_cap, "\\n");
        else if (c == '\r') riina_sec_puts(&_b, &_n, &_cap, "\\r");
        else if (c == '\t') riina_sec_puts(&_b, &_n, &_cap, "\\t");
        else if (c == 0x2028) riina_sec_puts(&_b, &_n, &_cap, "\\u2028");
        else if (c == 0x2029) riina_sec_puts(&_b, &_n, &_cap, "\\u2029");
        else if (c < 0x20) {
            snprintf(tmp, sizeof(tmp), "\\u%04x", (unsigned)c);
            riina_sec_puts(&_b, &_n, &_cap, tmp);
        }
        else riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    RIINA_SEC_END()
}

/* Filter CR/LF/NUL, then trim (Rust str::trim = Unicode whitespace). */
static riina_value_t* riina_builtin_sanitize_email(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    uint32_t* cps = (uint32_t*)malloc((_slen + 1) * sizeof(uint32_t));
    if (!cps) abort();
    size_t ncp = 0;
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c != '\r' && c != '\n' && c != 0) cps[ncp++] = c;
    }
    size_t lo = 0, hi = ncp;
    while (lo < hi && riina_sec_is_ws(cps[lo])) lo++;
    while (hi > lo && riina_sec_is_ws(cps[hi-1])) hi--;
    for (size_t k = lo; k < hi; k++) riina_sec_put_utf8(&_b, &_n, &_cap, cps[k]);
    free(cps);
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_validate_url(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    size_t lo = 0, hi = _slen;
    while (lo < hi && (unsigned char)_s[lo] <= 0x20) lo++;
    while (hi > lo && (unsigned char)_s[hi-1] <= 0x20) hi--;
    size_t tl = hi - lo;
    char* t = (char*)malloc(tl + 1);
    if (!t) abort();
    memcpy(t, _s + lo, tl); t[tl] = 0;
    char* low = (char*)malloc(tl + 1);
    if (!low) abort();
    for (size_t k = 0; k < tl; k++) {
        char c = t[k];
        low[k] = (c >= 'A' && c <= 'Z') ? (char)(c - 'A' + 'a') : c;
    }
    low[tl] = 0;
    bool ok = strncmp(low, "http://", 7) == 0 || strncmp(low, "https://", 8) == 0
           || strncmp(low, "mailto:", 7) == 0
           || (tl > 0 && t[0] == '/' && !(tl > 1 && t[1] == '/'));
    riina_sec_puts(&_b, &_n, &_cap, ok ? t : "about:blank");
    free(t); free(low);
    RIINA_SEC_END()
}

static bool riina_sec_dangerous_format(uint32_t c) {
    return (c >= 0x200B && c <= 0x200F) || (c >= 0x202A && c <= 0x202E)
        || (c >= 0x2066 && c <= 0x2069) || c == 0x2060 || c == 0x00AD || c == 0xFEFF;
}

static riina_value_t* riina_builtin_normalize_unicode(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (!riina_sec_dangerous_format(c)) riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    RIINA_SEC_END()
}

static riina_value_t* riina_builtin_strip_nulls(riina_value_t* arg) {
    RIINA_SEC_BEGIN(arg)
    for (size_t i = 0; i < _slen; ) {
        uint32_t c = riina_sec_utf8_next(_s, _slen, &i);
        if (c != 0) riina_sec_put_utf8(&_b, &_n, &_cap, c);
    }
    RIINA_SEC_END()
}

/* ---- Modelled sinks. These do NOT perform the dangerous operation; the
   interpreter models them and so does this. Their value is that the type
   system forces a Disanitasi<_> argument to reach them at all. ---- */
static riina_value_t* riina_builtin_sql_execute(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    return riina_string(arg->data.string_val.data);
}
static riina_value_t* riina_builtin_ldap_search(riina_value_t* arg) {
    return riina_builtin_sql_execute(arg);
}
static riina_value_t* riina_builtin_xml_query(riina_value_t* arg) {
    return riina_builtin_sql_execute(arg);
}
static riina_value_t* riina_builtin_js_eval(riina_value_t* arg) {
    return riina_builtin_sql_execute(arg);
}
static riina_value_t* riina_builtin_html_render(riina_value_t* arg) {
    return riina_builtin_sql_execute(arg);
}
static riina_value_t* riina_builtin_shell_exec(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    return riina_int(0);
}
static riina_value_t* riina_builtin_http_redirect_safe(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    return riina_unit();
}
/* Mirrors `MODELLED_HTTP_RESPONSE` in builtins/keselamatan.rs. No socket is
   opened on either side; the two must agree on the string they invent. */
#define RIINA_MODELLED_HTTP_RESPONSE "200 OK"
static riina_value_t* riina_builtin_http_get(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    return riina_string(RIINA_MODELLED_HTTP_RESPONSE);
}
static riina_value_t* riina_builtin_http_fetch_safe(riina_value_t* arg) {
    return riina_builtin_http_get(arg);
}
static riina_value_t* riina_builtin_http_body(riina_value_t* arg) {
    if (arg->tag == RIINA_TAG_STRING) return riina_string(arg->data.string_val.data);
    return riina_builtin_ke_teks(arg);
}

/* ---- Pair-taking members of the family.

   These take ONE argument that is a pair, never two curried arguments: every
   signature in riina-typechecker types them `Ty::Prod(..) -> _`, so the surface
   form `f(a, b)` is REJECTED AT TYPE-CHECK in both backends and only `f((a, b))`
   reaches a runtime. That is why no partial-application machinery is needed
   here — the interpreter's `BuiltinPartial` arm is unreachable from well-typed
   source, and a C backend that only understands pairs loses nothing. ---- */

/* (Tainted<Teks>, Nombor) -> Option<Tainted<Teks>>. Length is counted in
   UNICODE SCALAR VALUES, not bytes, so a multi-byte character costs one. */
static riina_value_t* riina_builtin_validate_length(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* sv = arg->data.pair_val.fst;
    riina_value_t* nv = arg->data.pair_val.snd;
    if (sv->tag != RIINA_TAG_STRING || nv->tag != RIINA_TAG_INT) abort();
    const char* s = sv->data.string_val.data;
    size_t slen = sv->data.string_val.len, i = 0, chars = 0;
    while (i < slen) { (void)riina_sec_utf8_next(s, slen, &i); chars++; }
    if ((uint64_t)chars <= nv->data.int_val) return riina_inl(riina_string(s));
    return riina_inr(riina_unit());
}

static riina_value_t* riina_builtin_dom_set_html(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    return riina_unit();
}
static riina_value_t* riina_builtin_dom_set_attr(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    return riina_unit();
}
/* Modelled send: no SMTP is spoken, and the interpreter reports success. */
static riina_value_t* riina_builtin_email_send(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    return riina_bool(true);
}
static riina_value_t* riina_builtin_email_set_header(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    return riina_unit();
}

/* POST/PUT carry (url, (body, csrf_token)); DELETE carries (url, token). All
   three answer with the same modelled status line as GET. */
static riina_value_t* riina_builtin_http_post(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    return riina_string(RIINA_MODELLED_HTTP_RESPONSE);
}
static riina_value_t* riina_builtin_http_put(riina_value_t* arg) {
    return riina_builtin_http_post(arg);
}
static riina_value_t* riina_builtin_http_delete(riina_value_t* arg) {
    return riina_builtin_http_post(arg);
}

/* Non-short-circuiting compare: the loop must not stop at the first differing
   byte, or the time taken leaks the length of the matching prefix. Length is
   compared first, exactly as the interpreter does — that much is already
   observable from the token's size. */
static riina_value_t* riina_builtin_csrf_validate(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* a = arg->data.pair_val.fst;
    riina_value_t* b = arg->data.pair_val.snd;
    if (a->tag != RIINA_TAG_STRING || b->tag != RIINA_TAG_STRING) abort();
    if (a->data.string_val.len != b->data.string_val.len) return riina_bool(false);
    unsigned char diff = 0;
    for (size_t i = 0; i < a->data.string_val.len; i++) {
        diff |= (unsigned char)(a->data.string_val.data[i] ^ b->data.string_val.data[i]);
    }
    return riina_bool(diff == 0);
}

/* An EMPTY allowed-origin never matches. Without that guard a program that
   forgot to configure one would accept every origin. */
static riina_value_t* riina_builtin_csrf_check_origin(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* o = arg->data.pair_val.fst;
    riina_value_t* w = arg->data.pair_val.snd;
    if (o->tag != RIINA_TAG_STRING || w->tag != RIINA_TAG_STRING) abort();
    if (w->data.string_val.len == 0) return riina_bool(false);
    if (o->data.string_val.len != w->data.string_val.len) return riina_bool(false);
    return riina_bool(memcmp(o->data.string_val.data, w->data.string_val.data,
                             w->data.string_val.len) == 0);
}
static riina_value_t* riina_builtin_csrf_check_referer(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* r = arg->data.pair_val.fst;
    riina_value_t* w = arg->data.pair_val.snd;
    if (r->tag != RIINA_TAG_STRING || w->tag != RIINA_TAG_STRING) abort();
    if (w->data.string_val.len == 0) return riina_bool(false);
    if (r->data.string_val.len < w->data.string_val.len) return riina_bool(false);
    return riina_bool(memcmp(r->data.string_val.data, w->data.string_val.data,
                             w->data.string_val.len) == 0);
}

/* No XML tree exists in-tree, so the interpreter models the parse as identity
   on the document text and deliberately does NOT resolve entities (no XXE
   surface). Identity here too — inventing a tree would be the overclaim. */
static riina_value_t* riina_builtin_xml_parse_safe(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    return riina_string(arg->data.string_val.data);
}
"####);
        // FILE I/O BUILTINS (fail)
        // ═══════════════════════════════════════════════════════════════════

        self.writeln("#include <sys/stat.h>");
        self.writeln("#include <dirent.h>");
        self.writeln("#include <unistd.h>");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // VERIFIED FILE GATE
        // ═══════════════════════════════════════════════════════════════════
        //
        // The interpreter never touches the host filesystem directly: every
        // `fail_*` builtin first calls gate_read/gate_write/gate_delete, which
        // evaluate the Coq `can_read`/`can_write` predicates. Emitted C used to
        // have none of that — bare fopen/fwrite — so compiling a program was a
        // way around a verified security check (REQ-70/REQ-27). This is the
        // gate, mirrored.
        //
        // ONE SPECIFICATION, TWO IMPLEMENTATIONS. The spec is Coq
        // `domains/VerifiedFileSystem.v` (Inode / Ownership / Permission /
        // is_owner / get_permission); `riina-os/src/vfs.rs` is the Rust
        // implementation and this is the C one. They cannot share code — the
        // compile pipeline is `cc -o out one.c` with nothing linked, so a
        // single implementation callable from both would mean shipping a
        // per-target Rust staticlib. The same shape as the `masa` civil
        // calendar (REQ-70) and the GF128/AES Coq⇄Rust equivalences: two
        // implementations of one model, held together by a differential —
        // here `file_gate_parity.rs` plus `file_differential.rs`.
        //
        // Deliberately NOT the host OS's own permission bits. The gate is
        // RIINA's model, so it must deny where the model denies even when the
        // host would allow (the process typically owns these files); letting
        // the kernel decide would silently make the check a no-op.
        self.writeln("typedef struct { bool read; bool write; bool execute; } riina_perm_t;");
        self.writeln("typedef struct riina_inode_s {");
        self.writeln("    char* path;");
        self.writeln("    uint64_t owner_uid;");
        self.writeln("    uint64_t owner_gid;");
        self.writeln("    riina_perm_t perm_owner;");
        self.writeln("    riina_perm_t perm_group;");
        self.writeln("    riina_perm_t perm_other;");
        self.writeln("    struct riina_inode_s* next;");
        self.writeln("} riina_inode_t;");
        self.writeln("");
        // `ctx_for(uid)` in builtins/vfs.rs yields { uid, gid: uid,
        // groups: [uid], is_root: false }, and DEFAULT_UID is 1000. Supplementary
        // groups are therefore always exactly [gid] today; `in_group` below is
        // written in the general form anyway so it still matches the model if
        // that changes.
        self.writeln("static uint64_t riina_ctx_uid = 1000;");
        self.writeln("static uint64_t riina_ctx_gid = 1000;");
        self.writeln("static bool riina_ctx_is_root = false;");
        self.writeln("static riina_inode_t* riina_inodes = NULL;");
        self.writeln("");
        // First touch registers the path owned by the CURRENT uid at mode 0644,
        // matching the interpreter's HostGate::gate and the modes vfs_tulis
        // creates with (owner rw, group/other r).
        self.writeln("static riina_inode_t* riina_gate_touch(const char* path) {");
        self.writeln("    for (riina_inode_t* i = riina_inodes; i; i = i->next) {");
        self.writeln("        if (strcmp(i->path, path) == 0) return i;");
        self.writeln("    }");
        self.writeln("    riina_inode_t* ino = (riina_inode_t*)malloc(sizeof(riina_inode_t));");
        self.writeln("    if (!ino) abort();");
        self.writeln("    ino->path = strdup(path);");
        self.writeln("    if (!ino->path) abort();");
        self.writeln("    ino->owner_uid = riina_ctx_uid;");
        self.writeln("    ino->owner_gid = riina_ctx_gid;");
        self.writeln("    ino->perm_owner = (riina_perm_t){ true, true, false };");
        self.writeln("    ino->perm_group = (riina_perm_t){ true, false, false };");
        self.writeln("    ino->perm_other = (riina_perm_t){ true, false, false };");
        self.writeln("    ino->next = riina_inodes;");
        self.writeln("    riina_inodes = ino;");
        self.writeln("    return ino;");
        self.writeln("}");
        self.writeln("");
        // Coq `get_permission` — owner > group > other resolution order.
        self.writeln("static riina_perm_t riina_permission_for(const riina_inode_t* ino) {");
        self.writeln("    if (ino->owner_uid == riina_ctx_uid) return ino->perm_owner;");
        self.writeln("    if (ino->owner_gid == riina_ctx_gid) return ino->perm_group;");
        self.writeln("    return ino->perm_other;");
        self.writeln("}");
        self.writeln("");
        // Coq `can_read` / `can_write` — root always, else the applicable bit.
        // Denial exits non-zero with the interpreter's wording; it must not be
        // possible for a denied op to fall through and touch the filesystem.
        self.writeln("static void riina_gate(const char* op, const char* path, bool want_write) {");
        self.writeln("    riina_inode_t* ino = riina_gate_touch(path);");
        self.writeln("    riina_perm_t p = riina_permission_for(ino);");
        self.writeln("    bool ok = riina_ctx_is_root || (want_write ? p.write : p.read);");
        self.writeln("    if (!ok) {");
        self.writeln("        fprintf(stderr, \"RIINA: %s: '%s': permission denied (verified %s is false for the current uid)\\n\",");
        self.writeln("                op, path, want_write ? \"can_write\" : \"can_read\");");
        self.writeln("        exit(1);");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("");
        // gate_delete: gate_write, then drop the mapping so a re-created file is
        // owned by whoever re-creates it (VFS delete-then-create semantics).
        self.writeln("static void riina_gate_delete(const char* op, const char* path) {");
        self.writeln("    riina_gate(op, path, true);");
        self.writeln("    riina_inode_t** slot = &riina_inodes;");
        self.writeln("    while (*slot) {");
        self.writeln("        if (strcmp((*slot)->path, path) == 0) {");
        self.writeln("            riina_inode_t* dead = *slot;");
        self.writeln("            *slot = dead->next;");
        self.writeln("            free(dead->path);");
        self.writeln("            free(dead);");
        self.writeln("            return;");
        self.writeln("        }");
        self.writeln("        slot = &(*slot)->next;");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("");
        // The in-memory VirtualFs itself — contents, byte/inode quota and the
        // three operations — mirroring `riina-os::vfs::VirtualFs` (Wave B.4).
        // Emitted here because it shares the access context and `riina_perm_t`
        // above and `vfs_mula` below resets it.
        self.write_raw(VFS_RUNTIME_C);
        self.writeln("");
        // vfs_mula (vfs_init): resets the host-FS gate AND the in-memory
        // VirtualFs, whose byte quota is the argument — exactly what the
        // interpreter's `VfsState::new(limit)` does (inode limit 4096).
        self.writeln("static riina_value_t* riina_builtin_vfs_mula(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_INT) abort();");
        self.writeln("    while (riina_inodes) {");
        self.writeln("        riina_inode_t* dead = riina_inodes;");
        self.writeln("        riina_inodes = dead->next;");
        self.writeln("        free(dead->path);");
        self.writeln("        free(dead);");
        self.writeln("    }");
        self.writeln("    riina_vfs_reset((uint64_t)arg->data.int_val);");
        self.writeln("    riina_ctx_uid = 1000; riina_ctx_gid = 1000; riina_ctx_is_root = false;");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");
        // vfs_jadi_pengguna (vfs_become_user): mirrors ctx_for(uid).
        self.writeln("static riina_value_t* riina_builtin_vfs_jadi_pengguna(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_INT) abort();");
        self.writeln("    riina_ctx_uid = arg->data.int_val;");
        self.writeln("    riina_ctx_gid = arg->data.int_val;");
        self.writeln("    riina_ctx_is_root = false;");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // fail_baca (file_read): Teks -> Teks
        self.writeln("static riina_value_t* riina_builtin_fail_baca(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_gate(\"fail_baca\", arg->data.string_val.data, false);");
        self.writeln("    FILE* f = fopen(arg->data.string_val.data, \"r\");");
        self.writeln("    if (!f) { fprintf(stderr, \"RIINA: cannot open file '%s'\\n\", arg->data.string_val.data); abort(); }");
        self.writeln("    fseek(f, 0, SEEK_END);");
        self.writeln("    long sz = ftell(f);");
        self.writeln("    fseek(f, 0, SEEK_SET);");
        self.writeln("    char* buf = (char*)malloc((size_t)sz + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    size_t rd = fread(buf, 1, (size_t)sz, f);");
        self.writeln("    buf[rd] = '\\0';");
        self.writeln("    fclose(f);");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // fail_tulis (file_write): (Teks, Teks) -> ()
        self.writeln("static riina_value_t* riina_builtin_fail_tulis(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* path = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* content = arg->data.pair_val.snd;");
        self.writeln("    if (path->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_gate(\"fail_tulis\", path->data.string_val.data, true);");
        self.writeln(
            "    if (path->tag != RIINA_TAG_STRING || content->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln("    FILE* f = fopen(path->data.string_val.data, \"w\");");
        self.writeln("    if (!f) { fprintf(stderr, \"RIINA: cannot write file '%s'\\n\", path->data.string_val.data); abort(); }");
        self.writeln(
            "    fwrite(content->data.string_val.data, 1, content->data.string_val.len, f);",
        );
        self.writeln("    fclose(f);");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // fail_tambah (file_append): (Teks, Teks) -> ()
        self.writeln("static riina_value_t* riina_builtin_fail_tambah(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* path = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* content = arg->data.pair_val.snd;");
        self.writeln("    if (path->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_gate(\"fail_tambah\", path->data.string_val.data, true);");
        self.writeln(
            "    if (path->tag != RIINA_TAG_STRING || content->tag != RIINA_TAG_STRING) abort();",
        );
        self.writeln("    FILE* f = fopen(path->data.string_val.data, \"a\");");
        self.writeln("    if (!f) { fprintf(stderr, \"RIINA: cannot append file '%s'\\n\", path->data.string_val.data); abort(); }");
        self.writeln(
            "    fwrite(content->data.string_val.data, 1, content->data.string_val.len, f);",
        );
        self.writeln("    fclose(f);");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // fail_ada (file_exists): Teks -> Bool
        self.writeln("static riina_value_t* riina_builtin_fail_ada(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    return riina_bool(access(arg->data.string_val.data, F_OK) == 0);");
        self.writeln("}");
        self.writeln("");

        // fail_buang (file_delete): Teks -> Bool
        self.writeln("static riina_value_t* riina_builtin_fail_buang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_gate_delete(\"fail_buang\", arg->data.string_val.data);");
        self.writeln("    return riina_bool(remove(arg->data.string_val.data) == 0);");
        self.writeln("}");
        self.writeln("");

        // The keselamatan safe-file trio. They live HERE rather than with the
        // rest of their family because they go through the SAME verified gate as
        // `fail_*` — `riina_gate` is defined above and the security family is
        // emitted before it. The interpreter shares `fail::gate_read` /
        // `gate_write` / `gate_delete` for exactly this reason; a "safe" file op
        // that skipped the access check would be the REQ-72 bypass wearing the
        // word `selamat`. The gate is passed the SAFE builtin's own name so a
        // denial says which call site was refused.
        self.writeln(
            r####"
static riina_value_t* riina_builtin_file_read_safe(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_gate("file_read_safe", arg->data.string_val.data, false);
    FILE* f = fopen(arg->data.string_val.data, "r");
    if (!f) {
        fprintf(stderr, "RIINA: file_read_safe: cannot read '%s'\n", arg->data.string_val.data);
        exit(1);
    }
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* buf = (char*)malloc((size_t)sz + 1);
    if (!buf) abort();
    size_t rd = fread(buf, 1, (size_t)sz, f);
    buf[rd] = '\0';
    fclose(f);
    riina_value_t* r = riina_string(buf);
    free(buf);
    return r;
}

static riina_value_t* riina_builtin_file_write_safe(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* path = arg->data.pair_val.fst;
    riina_value_t* content = arg->data.pair_val.snd;
    if (path->tag != RIINA_TAG_STRING || content->tag != RIINA_TAG_STRING) abort();
    riina_gate("file_write_safe", path->data.string_val.data, true);
    FILE* f = fopen(path->data.string_val.data, "w");
    if (!f) {
        fprintf(stderr, "RIINA: file_write_safe: cannot write '%s'\n", path->data.string_val.data);
        exit(1);
    }
    fwrite(content->data.string_val.data, 1, content->data.string_val.len, f);
    fclose(f);
    return riina_unit();
}

/* Returns whether the removal succeeded rather than stopping the program — the
   interpreter's `remove_file(..).is_ok()`. The GATE still stops it. */
static riina_value_t* riina_builtin_file_delete_safe(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_gate_delete("file_delete_safe", arg->data.string_val.data);
    return riina_bool(remove(arg->data.string_val.data) == 0);
}
"####,
        );

        // fail_panjang (file_size): Teks -> Int
        self.writeln("static riina_value_t* riina_builtin_fail_panjang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_gate(\"fail_panjang\", arg->data.string_val.data, false);");
        self.writeln("    struct stat st;");
        self.writeln("    if (stat(arg->data.string_val.data, &st) != 0) { fprintf(stderr, \"RIINA: cannot stat '%s'\\n\", arg->data.string_val.data); abort(); }");
        self.writeln("    return riina_int((uint64_t)st.st_size);");
        self.writeln("}");
        self.writeln("");

        // fail_senarai (file_list_dir): Teks -> List<Teks>
        self.writeln("static riina_value_t* riina_builtin_fail_senarai(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    DIR* d = opendir(arg->data.string_val.data);");
        self.writeln("    if (!d) { fprintf(stderr, \"RIINA: cannot open dir '%s'\\n\", arg->data.string_val.data); abort(); }");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    struct dirent* ent;");
        self.writeln("    while ((ent = readdir(d)) != NULL) {");
        self.writeln("        if (ent->d_name[0] == '.' && (ent->d_name[1] == '\\0' || (ent->d_name[1] == '.' && ent->d_name[2] == '\\0'))) continue;");
        self.writeln("        riina_list_push(&nl, riina_string(ent->d_name));");
        self.writeln("    }");
        self.writeln("    closedir(d);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // fail_baca_baris (file_read_lines): Teks -> List<Teks>
        self.writeln("static riina_value_t* riina_builtin_fail_baca_baris(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_gate(\"fail_baca_baris\", arg->data.string_val.data, false);");
        self.writeln("    FILE* f = fopen(arg->data.string_val.data, \"r\");");
        self.writeln("    if (!f) { fprintf(stderr, \"RIINA: cannot open '%s'\\n\", arg->data.string_val.data); abort(); }");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    char line[4096];");
        self.writeln("    while (fgets(line, sizeof(line), f)) {");
        self.writeln("        size_t len = strlen(line);");
        self.writeln("        if (len > 0 && line[len-1] == '\\n') line[--len] = '\\0';");
        self.writeln("        if (len > 0 && line[len-1] == '\\r') line[--len] = '\\0';");
        self.writeln("        riina_list_push(&nl, riina_string(line));");
        self.writeln("    }");
        self.writeln("    fclose(f);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // JSON BUILTINS
        // ═══════════════════════════════════════════════════════════════════

        // The parser is emitted as one raw string rather than per-line
        // `writeln` calls (the house style elsewhere in this file). At this
        // volume of C the escaping noise of the per-line form actively hides
        // bugs — which is how the LENIENT parser this replaces went unnoticed.
        //
        // STRICTNESS IS THE POINT. The previous emitter never failed: garbage
        // fell through to `strtoll` and became `0`, `nul` became `()`, `12abc`
        // became `12`, and an unterminated array closed itself. The interpreter
        // (`builtins/json.rs`) rejects all four. A compiled program parsing
        // attacker-controlled JSON therefore saw a FABRICATED value where
        // `riinac run` refuses — and `json_parse_safe`/`nyahsiri_selamat`, whose
        // whole contract is "malformed input yields Unit", cannot be routed to a
        // backend that has no notion of malformed.
        //
        // So this mirrors `builtins/json.rs` production-for-production,
        // including the parts that are not obviously deliberate:
        //   * whitespace is UNICODE (`str::trim`), not the ASCII four;
        //   * `\uD800`-`\uDFFF` decode to nothing at all (`char::from_u32`
        //     returns None and the interpreter pushes no character);
        //   * a number is read as `u64` first and only then as `f64` with a
        //     SATURATING cast, so `-5` is `0` and not a huge unsigned value;
        //   * trailing content after the top-level value is an error.
        // Failure is recorded rather than raised in place, because `json_urai`
        // must report it and `json_parse_safe` must swallow it.
        self.writeln(
            r####"
static bool riina_json_has_err = false;
static char riina_json_errbuf[192];

static void riina_json_fail(const char* msg) {
    if (riina_json_has_err) return;
    riina_json_has_err = true;
    snprintf(riina_json_errbuf, sizeof(riina_json_errbuf), "%s", msg);
}

/* Decode one codepoint from a NUL-terminated buffer. A truncated or invalid
   sequence advances one byte and reports U+FFFD, which is never whitespace and
   never a structural character, so the caller treats it as ordinary text. */
static uint32_t riina_json_cp(const char* p, size_t* adv) {
    unsigned char c0 = (unsigned char)p[0];
    unsigned char c1 = (unsigned char)p[1];
    if (c0 < 0x80) { *adv = 1; return c0; }
    if ((c0 & 0xE0) == 0xC0 && (c1 & 0xC0) == 0x80) {
        *adv = 2; return ((uint32_t)(c0 & 0x1F) << 6) | (uint32_t)(c1 & 0x3F);
    }
    unsigned char c2 = c1 ? (unsigned char)p[2] : 0;
    if ((c0 & 0xF0) == 0xE0 && (c1 & 0xC0) == 0x80 && (c2 & 0xC0) == 0x80) {
        *adv = 3;
        return ((uint32_t)(c0 & 0x0F) << 12) | ((uint32_t)(c1 & 0x3F) << 6)
             | (uint32_t)(c2 & 0x3F);
    }
    unsigned char c3 = c2 ? (unsigned char)p[3] : 0;
    if ((c0 & 0xF8) == 0xF0 && (c1 & 0xC0) == 0x80 && (c2 & 0xC0) == 0x80
        && (c3 & 0xC0) == 0x80) {
        *adv = 4;
        return ((uint32_t)(c0 & 0x07) << 18) | ((uint32_t)(c1 & 0x3F) << 12)
             | ((uint32_t)(c2 & 0x3F) << 6) | (uint32_t)(c3 & 0x3F);
    }
    *adv = 1; return 0xFFFD;
}

/* `str::trim_start`. Unicode, because the interpreter's is: an NBSP-indented
   document parses there and must parse here. */
static void riina_json_skip_ws(const char** p) {
    while (**p) {
        size_t adv; uint32_t c = riina_json_cp(*p, &adv);
        if (!riina_sec_is_ws(c)) return;
        *p += adv;
    }
}

static riina_value_t* riina_json_parse_value(const char** p);

static riina_value_t* riina_json_parse_string(const char** p) {
    (*p)++; /* opening quote; the caller has already matched it */
    size_t cap = 64, len = 0;
    char* buf = (char*)malloc(cap);
    if (!buf) abort();
    for (;;) {
        if (len + 8 >= cap) {
            cap *= 2; buf = (char*)realloc(buf, cap); if (!buf) abort();
        }
        if (**p == '\0') {
            free(buf); riina_json_fail("unterminated string"); return NULL;
        }
        if (**p == '"') {
            (*p)++; buf[len] = '\0';
            riina_value_t* r = riina_string(buf);
            free(buf);
            return r;
        }
        if (**p != '\\') {
            size_t adv; (void)riina_json_cp(*p, &adv);
            for (size_t k = 0; k < adv; k++) buf[len++] = (*p)[k];
            *p += adv;
            continue;
        }
        (*p)++;
        char e = **p;
        if (e == '"')       { buf[len++] = '"';  (*p)++; continue; }
        if (e == '\\')      { buf[len++] = '\\'; (*p)++; continue; }
        if (e == '/')       { buf[len++] = '/';  (*p)++; continue; }
        if (e == 'n')       { buf[len++] = '\n'; (*p)++; continue; }
        if (e == 'r')       { buf[len++] = '\r'; (*p)++; continue; }
        if (e == 't')       { buf[len++] = '\t'; (*p)++; continue; }
        if (e == 'b')       { buf[len++] = '\b'; (*p)++; continue; }
        if (e == 'f')       { buf[len++] = '\f'; (*p)++; continue; }
        if (e != 'u') {
            /* Covers end-of-input too: the interpreter's `_ => invalid escape`
               arm matches `None` as well as an unknown character. */
            free(buf); riina_json_fail("invalid escape"); return NULL;
        }
        (*p)++;
        /* The interpreter takes FOUR CHARS and then checks the BYTE length, so
           a multi-byte char inside the escape is not "incomplete" — it reaches
           `from_str_radix` and fails as "invalid" instead. Mirror both arms. */
        const char* hex = *p;
        int nchars = 0;
        while (nchars < 4 && **p) {
            size_t adv; (void)riina_json_cp(*p, &adv);
            *p += adv; nchars++;
        }
        size_t nbytes = (size_t)(*p - hex);
        if (nbytes < 4) {
            free(buf); riina_json_fail("incomplete unicode escape"); return NULL;
        }
        /* `u32::from_str_radix` accepts an optional leading '+' and nothing
           else outside the digits. Anything wider than 4 bytes contains a
           non-ASCII char and so cannot be radix-16 digits. */
        bool ok = (nbytes == 4);
        size_t i = (ok && hex[0] == '+') ? 1 : 0;
        if (ok && i == nbytes) ok = false;
        uint32_t cp = 0;
        for (; ok && i < nbytes; i++) {
            char h = hex[i]; int d;
            if (h >= '0' && h <= '9') d = h - '0';
            else if (h >= 'a' && h <= 'f') d = h - 'a' + 10;
            else if (h >= 'A' && h <= 'F') d = h - 'A' + 10;
            else { ok = false; break; }
            cp = (cp << 4) | (uint32_t)d;
        }
        if (!ok) {
            free(buf); riina_json_fail("invalid unicode escape"); return NULL;
        }
        /* A lone surrogate is `char::from_u32(cp) == None`, and the interpreter
           pushes NOTHING in that case rather than erroring. */
        if (cp >= 0xD800 && cp <= 0xDFFF) continue;
        if (cp < 0x80) {
            buf[len++] = (char)cp;
        } else if (cp < 0x800) {
            buf[len++] = (char)(0xC0 | (cp >> 6));
            buf[len++] = (char)(0x80 | (cp & 0x3F));
        } else {
            buf[len++] = (char)(0xE0 | (cp >> 12));
            buf[len++] = (char)(0x80 | ((cp >> 6) & 0x3F));
            buf[len++] = (char)(0x80 | (cp & 0x3F));
        }
    }
}

/* `u64` first, then `f64` with Rust's SATURATING `as u64`. The old emitter used
   `strtoll` and a C cast, so `-5` became 18446744073709551611 where the
   interpreter gives 0. */
static riina_value_t* riina_json_parse_number(const char** p) {
    const char* s = *p;
    size_t end = 0;
    while (s[end]) {
        char c = s[end];
        bool allowed = (c >= '0' && c <= '9') || c == '-' || c == '.'
                    || c == 'e' || c == 'E' || c == '+';
        if (!allowed) break;
        end++;
    }
    char nbuf[128];
    if (end >= sizeof(nbuf)) {
        riina_json_fail("cannot parse number"); return NULL;
    }
    memcpy(nbuf, s, end);
    nbuf[end] = '\0';
    *p = s + end;

    bool u_ok = true;
    size_t i = (nbuf[0] == '+') ? 1 : 0;
    if (nbuf[i] == '\0') u_ok = false;
    unsigned long long uv = 0;
    for (size_t k = i; u_ok && nbuf[k]; k++) {
        if (nbuf[k] < '0' || nbuf[k] > '9') { u_ok = false; break; }
        unsigned long long d = (unsigned long long)(nbuf[k] - '0');
        if (uv > (0xFFFFFFFFFFFFFFFFULL - d) / 10ULL) { u_ok = false; break; }
        uv = uv * 10ULL + d;
    }
    if (u_ok) return riina_int((uint64_t)uv);

    char* fend = NULL;
    double d = strtod(nbuf, &fend);
    if (fend == nbuf || *fend != '\0') {
        char msg[160];
        snprintf(msg, sizeof(msg), "cannot parse number: '%s'", nbuf);
        riina_json_fail(msg);
        return NULL;
    }
    if (!(d == d) || d <= 0.0) return riina_int(0);            /* NaN, negatives */
    if (d >= 18446744073709551616.0) return riina_int(0xFFFFFFFFFFFFFFFFULL);
    return riina_int((uint64_t)d);
}

static riina_value_t* riina_json_parse_object(const char** p) {
    (*p)++; /* '{' */
    riina_map_t m = { NULL, 0 };
    riina_json_skip_ws(p);
    if (**p == '}') { (*p)++; return riina_make_map(m); }
    for (;;) {
        riina_json_skip_ws(p);
        if (**p != '"') { riina_json_fail("expected string key in object"); return NULL; }
        riina_value_t* key = riina_json_parse_string(p);
        if (!key) return NULL;
        riina_json_skip_ws(p);
        if (**p != ':') { riina_json_fail("expected ':' in object"); return NULL; }
        (*p)++;
        riina_value_t* val = riina_json_parse_value(p);
        if (!val) return NULL;
        /* Sorted insert: the interpreter parses into a BTreeMap, so a duplicate
           key keeps the LAST value and iteration is by key. */
        riina_map_put_sorted(&m, key->data.string_val.data, val);
        riina_json_skip_ws(p);
        if (**p == '}') { (*p)++; return riina_make_map(m); }
        if (**p == ',') { (*p)++; continue; }
        riina_json_fail("expected ',' or '}' in object");
        return NULL;
    }
}

static riina_value_t* riina_json_parse_array(const char** p) {
    (*p)++; /* '[' */
    riina_list_t l = riina_list_new();
    riina_json_skip_ws(p);
    if (**p == ']') { (*p)++; return riina_make_list(l); }
    for (;;) {
        riina_value_t* val = riina_json_parse_value(p);
        if (!val) return NULL;
        riina_list_push(&l, val);
        riina_json_skip_ws(p);
        if (**p == ']') { (*p)++; return riina_make_list(l); }
        if (**p == ',') { (*p)++; continue; }
        riina_json_fail("expected ',' or ']' in array");
        return NULL;
    }
}

static bool riina_json_eat(const char** p, const char* lit) {
    size_t n = strlen(lit);
    if (strncmp(*p, lit, n) != 0) return false;
    *p += n;
    return true;
}

static riina_value_t* riina_json_parse_value(const char** p) {
    riina_json_skip_ws(p);
    if (**p == '\0') { riina_json_fail("unexpected end of input"); return NULL; }
    char c = **p;
    if (c == '"') return riina_json_parse_string(p);
    if (c == '{') return riina_json_parse_object(p);
    if (c == '[') return riina_json_parse_array(p);
    if (c == 't' || c == 'f') {
        if (riina_json_eat(p, "true")) return riina_bool(true);
        if (riina_json_eat(p, "false")) return riina_bool(false);
        riina_json_fail("expected 'true' or 'false'");
        return NULL;
    }
    if (c == 'n') {
        if (riina_json_eat(p, "null")) return riina_unit();
        riina_json_fail("expected 'null'");
        return NULL;
    }
    if (c == '-' || (c >= '0' && c <= '9')) return riina_json_parse_number(p);
    char msg[64];
    snprintf(msg, sizeof(msg), "unexpected char '%c'", c);
    riina_json_fail(msg);
    return NULL;
}

/* Whole document: a value, then nothing but whitespace. NULL ⇒ malformed, with
   the reason in riina_json_errbuf. */
static riina_value_t* riina_json_parse_document(const char* s) {
    riina_json_has_err = false;
    riina_json_errbuf[0] = '\0';
    const char* p = s;
    riina_value_t* v = riina_json_parse_value(&p);
    if (!v) return NULL;
    riina_json_skip_ws(&p);
    if (*p != '\0') {
        char msg[160];
        snprintf(msg, sizeof(msg), "unexpected trailing content: '%.20s'", p);
        riina_json_fail(msg);
        return NULL;
    }
    return v;
}

/* json_urai (json_parse): Teks -> Value. Malformed input is a runtime error, as
   in the interpreter — not a fabricated value. */
static riina_value_t* riina_builtin_json_urai(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_value_t* v = riina_json_parse_document(arg->data.string_val.data);
    if (!v) {
        fprintf(stderr, "RIINA: invalid operation: json_urai: %s\n", riina_json_errbuf);
        exit(1);
    }
    return v;
}

/* json_parse_safe / deserialize_safe: the SAME parser, with malformed input
   yielding Unit instead of stopping the program. That contract is the reason
   the strict parser above had to exist first. */
static riina_value_t* riina_builtin_json_parse_safe(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_value_t* v = riina_json_parse_document(arg->data.string_val.data);
    return v ? v : riina_unit();
}

/* sahkan_json. JSON document VALIDATION, not escaping: returns the document
   UNCHANGED when it parses and "" when it does not.

   Emitted HERE, beside json_parse_safe, rather than up with the sanitizers,
   because it needs riina_json_parse_document to be in scope — and it must be
   the SAME parser json_parse_safe uses, so the gate and the thing it gates can
   never disagree about what well-formed means. That is also why it does not
   re-implement a check: a second parser is a second opinion. */
static riina_value_t* riina_builtin_validate_json(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_value_t* v = riina_json_parse_document(arg->data.string_val.data);
    return v ? arg : riina_string("");
}

/* nyahsiri_selamat. The interpreter dispatches it to the same JSON parser, so
   this is an alias and not a second format. */
static riina_value_t* riina_builtin_deserialize_safe(riina_value_t* arg) {
    return riina_builtin_json_parse_safe(arg);
}
"####,
        );

        // JSON stringify helper (forward declare for recursion)
        self.writeln("static void riina_json_stringify_impl(riina_value_t* v, char** buf, size_t* len, size_t* cap);");
        self.writeln("");
        self.writeln("static void riina_json_buf_append(char** buf, size_t* len, size_t* cap, const char* s, size_t slen) {");
        self.writeln("    while (*len + slen + 1 >= *cap) { *cap *= 2; *buf = (char*)realloc(*buf, *cap); if (!*buf) abort(); }");
        self.writeln("    memcpy(*buf + *len, s, slen);");
        self.writeln("    *len += slen;");
        self.writeln("}");
        self.writeln("");
        self.writeln("static void riina_json_stringify_impl(riina_value_t* v, char** buf, size_t* len, size_t* cap) {");
        self.writeln("    char tmp[64];");
        self.writeln("    switch (v->tag) {");
        self.writeln("        case RIINA_TAG_UNIT: riina_json_buf_append(buf, len, cap, \"null\", 4); break;");
        self.writeln("        case RIINA_TAG_BOOL:");
        self.writeln(
            "            if (v->data.bool_val) riina_json_buf_append(buf, len, cap, \"true\", 4);",
        );
        self.writeln("            else riina_json_buf_append(buf, len, cap, \"false\", 5);");
        self.writeln("            break;");
        self.writeln("        case RIINA_TAG_INT: {");
        self.writeln("            int n = snprintf(tmp, sizeof(tmp), \"%llu\", (unsigned long long)v->data.int_val);");
        self.writeln("            riina_json_buf_append(buf, len, cap, tmp, (size_t)n);");
        self.writeln("            break;");
        self.writeln("        }");
        self.writeln("        case RIINA_TAG_STRING: {");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"\\\"\", 1);");
        self.writeln("            for (size_t i = 0; i < v->data.string_val.len; i++) {");
        self.writeln("                char c = v->data.string_val.data[i];");
        self.writeln(
            "                if (c == '\"') riina_json_buf_append(buf, len, cap, \"\\\\\\\"\", 2);",
        );
        self.writeln("                else if (c == '\\\\') riina_json_buf_append(buf, len, cap, \"\\\\\\\\\", 2);");
        self.writeln("                else if (c == '\\n') riina_json_buf_append(buf, len, cap, \"\\\\n\", 2);");
        self.writeln("                else if (c == '\\r') riina_json_buf_append(buf, len, cap, \"\\\\r\", 2);");
        self.writeln("                else if (c == '\\t') riina_json_buf_append(buf, len, cap, \"\\\\t\", 2);");
        self.writeln("                else if ((unsigned char)c < 0x20) {");
        self.writeln("                    /* Interpreter escapes every c < U+0020 as \\u00xx. */");
        self.writeln("                    char esc[8];");
        self.writeln("                    int en = snprintf(esc, sizeof(esc), \"\\\\u%04x\", (unsigned int)(unsigned char)c);");
        self.writeln("                    riina_json_buf_append(buf, len, cap, esc, (size_t)en);");
        self.writeln("                }");
        self.writeln("                else { riina_json_buf_append(buf, len, cap, &c, 1); }");
        self.writeln("            }");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"\\\"\", 1);");
        self.writeln("            break;");
        self.writeln("        }");
        self.writeln("        case RIINA_TAG_LIST: {");
        self.writeln("            riina_list_t* l = RIINA_LIST_DATA(v);");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"[\", 1);");
        self.writeln("            for (size_t i = 0; i < l->len; i++) {");
        self.writeln("                if (i > 0) riina_json_buf_append(buf, len, cap, \",\", 1);");
        self.writeln("                riina_json_stringify_impl(l->items[i], buf, len, cap);");
        self.writeln("            }");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"]\", 1);");
        self.writeln("            break;");
        self.writeln("        }");
        self.writeln("        case RIINA_TAG_MAP: {");
        self.writeln("            riina_map_t* m = RIINA_MAP_DATA(v);");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"{\", 1);");
        self.writeln("            size_t idx = 0;");
        self.writeln("            for (riina_map_entry_t* e = m->head; e; e = e->next, idx++) {");
        self.writeln(
            "                if (idx > 0) riina_json_buf_append(buf, len, cap, \",\", 1);",
        );
        self.writeln("                riina_json_buf_append(buf, len, cap, \"\\\"\", 1);");
        self.writeln(
            "                riina_json_buf_append(buf, len, cap, e->key, strlen(e->key));",
        );
        self.writeln("                riina_json_buf_append(buf, len, cap, \"\\\":\", 2);");
        self.writeln("                riina_json_stringify_impl(e->value, buf, len, cap);");
        self.writeln("            }");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"}\", 1);");
        self.writeln("            break;");
        self.writeln("        }");
        self.writeln("        case RIINA_TAG_PAIR: {");
        self.writeln("            /* The interpreter renders a Pair as a 2-element array; this");
        self.writeln("               arm used to fall through to `default` and emit `null`, so a");
        self.writeln("               tuple silently lost its contents under the C backend. */");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"[\", 1);");
        self.writeln("            riina_json_stringify_impl(v->data.pair_val.fst, buf, len, cap);");
        self.writeln("            riina_json_buf_append(buf, len, cap, \",\", 1);");
        self.writeln("            riina_json_stringify_impl(v->data.pair_val.snd, buf, len, cap);");
        self.writeln("            riina_json_buf_append(buf, len, cap, \"]\", 1);");
        self.writeln("            break;");
        self.writeln("        }");
        self.writeln("        default: riina_json_buf_append(buf, len, cap, \"null\", 4); break;");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("");

        // json_ke_teks (json_stringify): Value -> Teks
        self.writeln("static riina_value_t* riina_builtin_json_ke_teks(riina_value_t* arg) {");
        self.writeln("    size_t cap = 256, len = 0;");
        self.writeln("    char* buf = (char*)malloc(cap);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    riina_json_stringify_impl(arg, &buf, &len, &cap);");
        self.writeln("    buf[len] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // json_dapat (json_get): (Map, String) -> Value
        self.writeln("static riina_value_t* riina_builtin_json_dapat(riina_value_t* arg) {");
        self.writeln("    return riina_builtin_peta_dapat(arg);");
        self.writeln("}");
        self.writeln("");

        // json_letak (json_set): (Map, (String, Value)) -> Map
        self.writeln("static riina_value_t* riina_builtin_json_letak(riina_value_t* arg) {");
        self.writeln("    return riina_builtin_peta_letak(arg);");
        self.writeln("}");
        self.writeln("");

        // json_ada (json_has): (Map, String) -> Bool
        self.writeln("static riina_value_t* riina_builtin_json_ada(riina_value_t* arg) {");
        self.writeln("    return riina_builtin_peta_mengandungi(arg);");
        self.writeln("}");
        self.writeln("");

        // ═══════════════════════════════════════════════════════════════════
        // EXPANDED BUILTINS (M5)
        // ═══════════════════════════════════════════════════════════════════

        // teks_ulang (str_repeat): (String, Int) -> String
        self.writeln("static riina_value_t* riina_builtin_teks_ulang(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* n = arg->data.pair_val.snd;");
        self.writeln("    if (s->tag != RIINA_TAG_STRING || n->tag != RIINA_TAG_INT) abort();");
        self.writeln("    size_t count = (size_t)n->data.int_val;");
        self.writeln("    size_t slen = s->data.string_val.len;");
        self.writeln("    char* buf = (char*)malloc(slen * count + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    for (size_t i = 0; i < count; i++) memcpy(buf + i * slen, s->data.string_val.data, slen);");
        self.writeln("    buf[slen * count] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_pad_kiri (str_pad_left): (String, (Int, String)) -> String
        self.writeln("static riina_value_t* riina_builtin_teks_pad_kiri(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* params = arg->data.pair_val.snd;");
        self.writeln(
            "    if (s->tag != RIINA_TAG_STRING || params->tag != RIINA_TAG_PAIR) abort();",
        );
        self.writeln("    size_t width = (size_t)params->data.pair_val.fst->data.int_val;");
        self.writeln("    char pc = params->data.pair_val.snd->data.string_val.data[0];");
        self.writeln("    size_t slen = s->data.string_val.len;");
        self.writeln("    if (slen >= width) return s;");
        self.writeln("    size_t pad = width - slen;");
        self.writeln("    char* buf = (char*)malloc(width + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    memset(buf, pc, pad);");
        self.writeln("    memcpy(buf + pad, s->data.string_val.data, slen);");
        self.writeln("    buf[width] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_pad_kanan (str_pad_right): (String, (Int, String)) -> String
        self.writeln("static riina_value_t* riina_builtin_teks_pad_kanan(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* s = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* params = arg->data.pair_val.snd;");
        self.writeln(
            "    if (s->tag != RIINA_TAG_STRING || params->tag != RIINA_TAG_PAIR) abort();",
        );
        self.writeln("    size_t width = (size_t)params->data.pair_val.fst->data.int_val;");
        self.writeln("    char pc = params->data.pair_val.snd->data.string_val.data[0];");
        self.writeln("    size_t slen = s->data.string_val.len;");
        self.writeln("    if (slen >= width) return s;");
        self.writeln("    size_t pad = width - slen;");
        self.writeln("    char* buf = (char*)malloc(width + 1);");
        self.writeln("    if (!buf) abort();");
        self.writeln("    memcpy(buf, s->data.string_val.data, slen);");
        self.writeln("    memset(buf + slen, pc, pad);");
        self.writeln("    buf[width] = '\\0';");
        self.writeln("    riina_value_t* r = riina_string(buf);");
        self.writeln("    free(buf);");
        self.writeln("    return r;");
        self.writeln("}");
        self.writeln("");

        // teks_baris (str_lines): String -> List<String>
        self.writeln("static riina_value_t* riina_builtin_teks_baris(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_STRING) abort();");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    const char* s = arg->data.string_val.data;");
        self.writeln("    const char* start = s;");
        self.writeln("    while (*s) {");
        self.writeln("        if (*s == '\\n') {");
        self.writeln("            size_t len = (size_t)(s - start);");
        self.writeln("            if (len > 0 && start[len-1] == '\\r') len--;");
        self.writeln("            char* line = (char*)malloc(len + 1);");
        self.writeln("            if (!line) abort();");
        self.writeln("            memcpy(line, start, len); line[len] = '\\0';");
        self.writeln("            riina_list_push(&nl, riina_string(line));");
        self.writeln("            free(line);");
        self.writeln("            start = s + 1;");
        self.writeln("        }");
        self.writeln("        s++;");
        self.writeln("    }");
        self.writeln("    if (s > start) {");
        self.writeln("        size_t len = (size_t)(s - start);");
        self.writeln("        char* line = (char*)malloc(len + 1);");
        self.writeln("        if (!line) abort();");
        self.writeln("        memcpy(line, start, len); line[len] = '\\0';");
        self.writeln("        riina_list_push(&nl, riina_string(line));");
        self.writeln("        free(line);");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_rata (list_flatten): List -> List
        self.writeln("static riina_value_t* riina_builtin_senarai_rata(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(arg);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < old->len; i++) {");
        self.writeln("        if (old->items[i]->tag == RIINA_TAG_LIST) {");
        self.writeln("            riina_list_t* inner = RIINA_LIST_DATA(old->items[i]);");
        self.writeln("            for (size_t j = 0; j < inner->len; j++) riina_list_push(&nl, inner->items[j]);");
        self.writeln("        } else {");
        self.writeln("            riina_list_push(&nl, old->items[i]);");
        self.writeln("        }");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_unik (list_unique): List -> List
        self.writeln("static riina_value_t* riina_builtin_senarai_unik(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_LIST) abort();");
        self.writeln("    riina_list_t* old = RIINA_LIST_DATA(arg);");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = 0; i < old->len; i++) {");
        self.writeln("        bool dup = false;");
        self.writeln("        for (size_t j = 0; j < nl.len; j++) {");
        self.writeln("            if (riina_values_equal(old->items[i], nl.items[j])) { dup = true; break; }");
        self.writeln("        }");
        self.writeln("        if (!dup) riina_list_push(&nl, old->items[i]);");
        self.writeln("    }");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // senarai_potong (list_slice): (List, (Int, Int)) -> List
        self.writeln("static riina_value_t* riina_builtin_senarai_potong(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    riina_value_t* lst = arg->data.pair_val.fst;");
        self.writeln("    riina_value_t* range = arg->data.pair_val.snd;");
        self.writeln(
            "    if (lst->tag != RIINA_TAG_LIST || range->tag != RIINA_TAG_PAIR) abort();",
        );
        self.writeln("    riina_list_t* l = RIINA_LIST_DATA(lst);");
        self.writeln("    size_t start = (size_t)range->data.pair_val.fst->data.int_val;");
        self.writeln("    size_t end = (size_t)range->data.pair_val.snd->data.int_val;");
        self.writeln("    if (start > l->len) start = l->len;");
        self.writeln("    if (end > l->len) end = l->len;");
        self.writeln("    if (end < start) end = start;");
        self.writeln("    riina_list_t nl = riina_list_new();");
        self.writeln("    for (size_t i = start; i < end; i++) riina_list_push(&nl, l->items[i]);");
        self.writeln("    return riina_make_list(nl);");
        self.writeln("}");
        self.writeln("");

        // baki (rem): (Int, Int) -> Int
        self.writeln("static riina_value_t* riina_builtin_baki(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_PAIR) abort();");
        self.writeln("    uint64_t a = arg->data.pair_val.fst->data.int_val;");
        self.writeln("    uint64_t b = arg->data.pair_val.snd->data.int_val;");
        self.writeln("    if (b == 0) { fprintf(stderr, \"RIINA: modulo by zero\\n\"); abort(); }");
        self.writeln("    return riina_int(a % b);");
        self.writeln("}");
        self.writeln("");

        // Range constructors and sum introspection.
        //
        // The four sum helpers are NOT a stdlib convenience — they are compiler
        // internals. `parse_module_path`'s if-chain pattern compiler emits them
        // for a constructor pattern nested where a `Case` cannot go, e.g.
        // `(Ada(a), Tiada)` inside a tuple pattern. Until they were routed, that
        // whole class of pattern ran under `riinac run` and failed `riinac build`
        // with `Codegen Error: unbound variable: nilai_kiri` — a LANGUAGE feature
        // that did not compile, surfacing as a missing builtin.
        //
        // `nilai_kiri`/`nilai_kanan` are deliberately LENIENT, matching the
        // interpreter: a non-matching or non-sum argument yields the value
        // itself rather than aborting. The generated code only projects a
        // payload after the corresponding `adalah_*` tag test has passed, so the
        // lenient arms are unreachable from generated code — but a hand-written
        // call must behave the same in both backends.
        self.writeln(
            r####"
static riina_value_t* riina_builtin_julat(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* a = arg->data.pair_val.fst;
    riina_value_t* b = arg->data.pair_val.snd;
    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) abort();
    riina_list_t l = riina_list_new();
    for (uint64_t i = a->data.int_val; i < b->data.int_val; i++) {
        riina_list_push(&l, riina_int(i));
    }
    return riina_make_list(l);
}

/* Inclusive of the upper bound. The interpreter uses a SATURATING increment, so
   an upper bound of UINT64_MAX yields the same list as the exclusive form
   rather than wrapping to an empty one. */
static riina_value_t* riina_builtin_julat_inklusif(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* a = arg->data.pair_val.fst;
    riina_value_t* b = arg->data.pair_val.snd;
    if (a->tag != RIINA_TAG_INT || b->tag != RIINA_TAG_INT) abort();
    uint64_t hi = b->data.int_val;
    uint64_t end = (hi == 0xFFFFFFFFFFFFFFFFULL) ? hi : hi + 1;
    riina_list_t l = riina_list_new();
    for (uint64_t i = a->data.int_val; i < end; i++) {
        riina_list_push(&l, riina_int(i));
    }
    return riina_make_list(l);
}

static riina_value_t* riina_builtin_adalah_kiri(riina_value_t* arg) {
    return riina_bool(arg->tag == RIINA_TAG_SUM_LEFT);
}
static riina_value_t* riina_builtin_adalah_kanan(riina_value_t* arg) {
    return riina_bool(arg->tag == RIINA_TAG_SUM_RIGHT);
}
static riina_value_t* riina_builtin_nilai_kiri(riina_value_t* arg) {
    if (arg->tag == RIINA_TAG_SUM_LEFT || arg->tag == RIINA_TAG_SUM_RIGHT) {
        return arg->data.sum_val;
    }
    return arg;
}
static riina_value_t* riina_builtin_nilai_kanan(riina_value_t* arg) {
    return riina_builtin_nilai_kiri(arg);
}
"####,
        );

        // log2: Int -> Int
        self.writeln("static riina_value_t* riina_builtin_log2(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_INT) abort();");
        self.writeln("    uint64_t n = arg->data.int_val;");
        self.writeln(
            "    if (n == 0) { fprintf(stderr, \"RIINA: log2(0) undefined\\n\"); abort(); }",
        );
        self.writeln("    uint64_t r = 0;");
        self.writeln("    while (n > 1) { n >>= 1; r++; }");
        self.writeln("    return riina_int(r);");
        self.writeln("}");
        self.writeln("");

        // rawak (random): Int -> Int (0..n)
        self.writeln("static riina_value_t* riina_builtin_rawak(riina_value_t* arg) {");
        self.writeln("    if (arg->tag != RIINA_TAG_INT || arg->data.int_val == 0) {");
        self.writeln(
            "        fprintf(stderr, \"RIINA: random requires positive int\\n\"); abort();",
        );
        self.writeln("    }");
        self.writeln("    static uint64_t seed = 0;");
        self.writeln("    if (seed == 0) {");
        self.writeln("        struct timespec ts;");
        self.writeln("        clock_gettime(CLOCK_MONOTONIC, &ts);");
        self.writeln("        seed = (uint64_t)ts.tv_nsec ^ (uint64_t)ts.tv_sec;");
        self.writeln("    }");
        self.writeln("    seed = seed * 6364136223846793005ULL + 1442695040888963407ULL;");
        self.writeln("    return riina_int(seed % arg->data.int_val);");
        self.writeln("}");
        self.writeln("");
    }

    /// Emit JALINAN runtime support (actors, CRDTs, content-addressed hashing)
    fn emit_jalinan_runtime(&mut self) {
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                      JALINAN RUNTIME                                */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        // Actor type registry and instance definitions
        self.writeln("#define RIINA_ACTOR_MAILBOX_SIZE 256");
        self.writeln("#define RIINA_MAX_ACTORS 64");
        self.writeln("#define RIINA_MAX_ACTOR_TYPES 16");
        self.writeln("");
        self.writeln("typedef struct {");
        self.writeln("    riina_value_t* init_state;");
        self.writeln("    riina_value_t* handler;");
        self.writeln("} riina_actor_type_t;");
        self.writeln("");
        self.writeln("static riina_actor_type_t riina_actor_types[RIINA_MAX_ACTOR_TYPES];");
        self.writeln("static int64_t riina_next_actor_type_id = 0;");
        self.writeln("");
        self.writeln("typedef struct {");
        self.writeln("    int64_t id;");
        self.writeln("    riina_value_t* state;");
        self.writeln("    riina_value_t* handler;");
        self.writeln("    riina_value_t* mailbox[RIINA_ACTOR_MAILBOX_SIZE];");
        self.writeln("    int64_t mailbox_head;");
        self.writeln("    int64_t mailbox_tail;");
        self.writeln("    int64_t mailbox_count;");
        self.writeln("    pthread_mutex_t mutex;");
        self.writeln("    pthread_cond_t cond;");
        self.writeln("    pthread_t thread;");
        self.writeln("} riina_actor_t;");
        self.writeln("");
        self.writeln("static riina_actor_t riina_actors[RIINA_MAX_ACTORS];");
        self.writeln("static int64_t riina_next_actor_id = 0;");
        self.writeln("");

        // Actor declaration (registers actor type in type registry, returns type ID)
        self.writeln("static riina_value_t* riina_actor_decl(riina_value_t* init_state, riina_value_t* handler) {");
        self.writeln("    int64_t type_id = riina_next_actor_type_id++;");
        self.writeln("    riina_actor_types[type_id].init_state = init_state;");
        self.writeln("    riina_actor_types[type_id].handler = handler;");
        self.writeln("    return riina_int((uint64_t)type_id);");
        self.writeln("}");
        self.writeln("");

        // Choreography declaration (protocol declaration, returns unit)
        self.writeln("static riina_value_t* riina_choreography_decl(void) {");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // Actor spawn (creates actor instance with pthread primitives, returns actor ID)
        self.writeln("static riina_value_t* riina_actor_spawn(riina_value_t* actor_decl, riina_value_t* init_state) {");
        self.writeln("    int64_t actor_id = riina_next_actor_id++;");
        self.writeln("    riina_actor_t* actor = &riina_actors[actor_id];");
        self.writeln("    actor->id = actor_id;");
        self.writeln("    actor->state = init_state;");
        self.writeln("    actor->handler = riina_actor_types[actor_decl->data.int_val].handler;");
        self.writeln("    actor->mailbox_head = 0;");
        self.writeln("    actor->mailbox_tail = 0;");
        self.writeln("    actor->mailbox_count = 0;");
        self.writeln("    pthread_mutex_init(&actor->mutex, NULL);");
        self.writeln("    pthread_cond_init(&actor->cond, NULL);");
        self.writeln("    return riina_int((uint64_t)actor_id);");
        self.writeln("}");
        self.writeln("");

        // Actor send (enqueue message in ring buffer with mutex protection)
        self.writeln("static riina_value_t* riina_actor_send(riina_value_t* actor_ref, riina_value_t* msg) {");
        self.writeln("    int64_t actor_id = actor_ref->data.int_val;");
        self.writeln("    riina_actor_t* actor = &riina_actors[actor_id];");
        self.writeln("    pthread_mutex_lock(&actor->mutex);");
        self.writeln("    if (actor->mailbox_count < RIINA_ACTOR_MAILBOX_SIZE) {");
        self.writeln("        actor->mailbox[actor->mailbox_tail] = msg;");
        self.writeln(
            "        actor->mailbox_tail = (actor->mailbox_tail + 1) % RIINA_ACTOR_MAILBOX_SIZE;",
        );
        self.writeln("        actor->mailbox_count++;");
        self.writeln("    }");
        self.writeln("    pthread_cond_signal(&actor->cond);");
        self.writeln("    pthread_mutex_unlock(&actor->mutex);");
        self.writeln("    return riina_unit();");
        self.writeln("}");
        self.writeln("");

        // Actor receive (returns current actor state)
        self.writeln("static riina_value_t* riina_actor_recv(riina_value_t* actor_ref) {");
        self.writeln("    int64_t actor_id = actor_ref->data.int_val;");
        self.writeln("    riina_actor_t* actor = &riina_actors[actor_id];");
        self.writeln("    return actor->state;");
        self.writeln("}");
        self.writeln("");

        // CRDT merge (pointwise max for integer counters)
        self.writeln(
            "static riina_value_t* riina_crdt_merge(riina_value_t* a, riina_value_t* b) {",
        );
        self.writeln("    if (a->tag == RIINA_TAG_INT && b->tag == RIINA_TAG_INT) {");
        self.writeln("        return riina_int(a->data.int_val > b->data.int_val ? a->data.int_val : b->data.int_val);");
        self.writeln("    }");
        self.writeln("    return a;");
        self.writeln("}");
        self.writeln("");

        // Content hash (FNV-1a, returns hex string)
        self.writeln("static riina_value_t* riina_content_hash(riina_value_t* val) {");
        self.writeln("    uint64_t hash = 14695981039346656037ULL;");
        self.writeln("    const uint64_t prime = 1099511628211ULL;");
        self.writeln("    if (val->tag == RIINA_TAG_INT) {");
        self.writeln("        int64_t n = val->data.int_val;");
        self.writeln("        int i;");
        self.writeln("        for (i = 0; i < 8; i++) {");
        self.writeln("            hash ^= (n >> (i * 8)) & 0xFF;");
        self.writeln("            hash *= prime;");
        self.writeln("        }");
        self.writeln("    } else if (val->tag == RIINA_TAG_STRING) {");
        self.writeln("        const char* s = val->data.string_val.data;");
        self.writeln("        while (*s) { hash ^= (unsigned char)*s++; hash *= prime; }");
        self.writeln("    } else if (val->tag == RIINA_TAG_BOOL) {");
        self.writeln("        hash ^= (val->data.bool_val ? 1 : 0);");
        self.writeln("        hash *= prime;");
        self.writeln("    }");
        self.writeln("    char buf[17];");
        self.writeln("    snprintf(buf, sizeof(buf), \"%016llx\", (unsigned long long)hash);");
        self.writeln("    return riina_string(buf);");
        self.writeln("}");
        self.writeln("");
    }

    /// Emit forward declarations for all functions
    fn emit_forward_declarations(&mut self, program: &Program) -> Result<()> {
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                    FORWARD DECLARATIONS                             */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        for func_id in &self.forward_decls {
            if let Some(func) = program.functions.get(func_id) {
                if func.captures.is_empty() {
                    let _ = writeln!(
                        self.output,
                        "static riina_value_t* {}(riina_value_t* {});",
                        self.func_name(func_id),
                        func.param
                    );
                } else {
                    let _ = writeln!(
                        self.output,
                        "static riina_value_t* {}(riina_value_t* _self, riina_value_t* {});",
                        self.func_name(func_id),
                        func.param
                    );
                }
            }
        }
        self.writeln("");

        Ok(())
    }

    /// Build phi map for SSA destruction: collects all phi nodes in a function
    /// and organizes them by target block and predecessor block.
    fn build_phi_map(func: &Function) -> PhiMap {
        let mut phi_map: PhiMap = HashMap::new();
        for block in &func.blocks {
            for instr in &block.instrs {
                if let Instruction::Phi(entries) = &instr.instr {
                    for (pred_block, src_var) in entries {
                        phi_map
                            .entry(block.id)
                            .or_default()
                            .entry(*pred_block)
                            .or_default()
                            .push((instr.result, *src_var));
                    }
                }
            }
        }
        phi_map
    }

    /// Emit a single function
    fn emit_function(&mut self, func: &Function) -> Result<()> {
        self.declared_vars.clear();

        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        let _ = writeln!(self.output, "/* Function: {} */", func.name);
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");

        // Function signature
        if func.captures.is_empty() {
            self.write(&format!(
                "static riina_value_t* {}(riina_value_t* {})",
                self.func_name(&func.id),
                func.param
            ));
        } else {
            self.write(&format!(
                "static riina_value_t* {}(riina_value_t* _self, riina_value_t* {})",
                self.func_name(&func.id),
                func.param
            ));
        }
        self.write_raw(" {\n");
        self.indent();

        // Declare all variables used in the function
        self.emit_var_declarations(func)?;

        // Bind parameter and captured variables to their VarIds
        if !func.captures.is_empty() {
            self.writeln("/* Extract captured variables */");
            for (i, (_name, _ty)) in func.captures.iter().enumerate() {
                let var = VarId::new(i as u32);
                self.writeln(&format!(
                    "{} = _self->data.closure_val.captures[{i}];",
                    self.var_name(&var)
                ));
            }
            let param_var = VarId::new(func.captures.len() as u32);
            self.writeln(&format!("{} = {};", self.var_name(&param_var), func.param));
            self.writeln("");
        } else {
            // For non-capture functions, bind parameter to VarId(0)
            // (the lowerer allocates VarId(0) for the parameter)
            let param_var = VarId::new(0);
            if self.declared_vars.contains(&param_var) {
                self.writeln(&format!("{} = {};", self.var_name(&param_var), func.param));
                self.writeln("");
            }
        }

        // Build phi map for SSA destruction (copy insertion before jumps)
        let phi_map = Self::build_phi_map(func);

        // Emit each basic block
        for block in &func.blocks {
            self.emit_block_with_phi(block, &phi_map)?;
        }

        self.dedent();
        self.writeln("}");
        self.writeln("");

        Ok(())
    }


    /// Emit variable declarations for a function
    fn emit_var_declarations(&mut self, func: &Function) -> Result<()> {
        let mut vars: HashSet<VarId> = HashSet::new();

        // Add capture VarIds and parameter VarId
        if !func.captures.is_empty() {
            for i in 0..func.captures.len() {
                vars.insert(VarId::new(i as u32));
            }
            vars.insert(VarId::new(func.captures.len() as u32));
        }

        // Collect all variables (results and operands)
        for block in &func.blocks {
            for instr in &block.instrs {
                vars.insert(instr.result);
                // Also collect operand VarIds (for captures/params referenced)
                match &instr.instr {
                    Instruction::Copy(v)
                    | Instruction::Fst(v)
                    | Instruction::Snd(v)
                    | Instruction::IsLeft(v)
                    | Instruction::UnwrapLeft(v)
                    | Instruction::UnwrapRight(v)
                    | Instruction::Load(v)
                    | Instruction::Classify(v)
                    | Instruction::Prove(v)
                    | Instruction::UnaryOp(_, v)
                    | Instruction::Inl(v)
                    | Instruction::Inr(v)
                    | Instruction::ActorRecv(v)
                    | Instruction::ContentHash(v) => {
                        vars.insert(*v);
                    }
                    Instruction::BinOp(_, a, b)
                    | Instruction::Pair(a, b)
                    | Instruction::Store(a, b)
                    | Instruction::Declassify(a, b)
                    | Instruction::Call(a, b)
                    | Instruction::ActorSpawn(a, b)
                    | Instruction::ActorSend(a, b)
                    | Instruction::CRDTMerge(a, b) => {
                        vars.insert(*a);
                        vars.insert(*b);
                    }
                    // A list literal uses every one of its element vars.
                    Instruction::MakeList(elems) => {
                        for e in elems {
                            vars.insert(*e);
                        }
                    }
                    Instruction::Alloc { init, .. } => {
                        vars.insert(*init);
                    }
                    Instruction::Perform { payload, .. } => {
                        vars.insert(*payload);
                    }
                    Instruction::Closure { captures, .. } => {
                        for c in captures {
                            vars.insert(*c);
                        }
                    }
                    Instruction::Phi(entries) => {
                        for (_, v) in entries {
                            vars.insert(*v);
                        }
                    }
                    Instruction::BuiltinCall { arg, .. } => {
                        vars.insert(*arg);
                    }
                    Instruction::FFICall { args, .. } => {
                        for a in args {
                            vars.insert(*a);
                        }
                    }
                    Instruction::FixClosure { closure, .. } => {
                        vars.insert(*closure);
                    }
                    Instruction::ActorDecl {
                        init_state,
                        handler,
                        ..
                    } => {
                        vars.insert(*init_state);
                        vars.insert(*handler);
                    }
                    Instruction::ChoreographyDecl { .. } => {}
                    Instruction::Const(_)
                    | Instruction::RequireCap(_)
                    | Instruction::GrantCap(_) => {}
                }
            }
        }

        // Emit declarations
        if !vars.is_empty() {
            self.writeln("/* Local variables */");
            for var in &vars {
                self.writeln(&format!("riina_value_t* {} = NULL;", self.var_name(var)));
                self.declared_vars.insert(*var);
            }
            self.writeln("");
        }

        Ok(())
    }

    /// Emit a basic block with phi copy insertion (SSA destruction).
    fn emit_block_with_phi(&mut self, block: &BasicBlock, phi_map: &PhiMap) -> Result<()> {
        // Block label
        self.dedent();
        self.writeln(&format!("{}:", self.block_name(&block.id)));
        self.indent();

        // Instructions
        for instr in &block.instrs {
            self.emit_instruction(instr)?;
        }

        // Terminator (with phi copy insertion before jumps)
        if let Some(term) = &block.terminator {
            self.emit_terminator_with_phi(term, &block.id, phi_map)?;
        }

        Ok(())
    }

    /// Emit a single instruction
    fn emit_instruction(&mut self, instr: &AnnotatedInstr) -> Result<()> {
        let result = self.var_name(&instr.result);

        match &instr.instr {
            Instruction::Const(c) => {
                let val = match c {
                    Constant::Unit => "riina_unit()".to_string(),
                    Constant::Bool(b) => {
                        format!("riina_bool({})", if *b { "true" } else { "false" })
                    }
                    Constant::Int(n) => format!("riina_int({n}ULL)"),
                    Constant::String(s) => format!("riina_string(\"{}\")", self.escape_string(s)),
                };
                self.writeln(&format!("{result} = {val};"));
            }

            Instruction::Copy(src) => {
                self.writeln(&format!("{result} = riina_copy({});", self.var_name(src)));
            }

            Instruction::BinOp(op, lhs, rhs) => {
                let func = match op {
                    BinOp::Add => "riina_binop_add",
                    BinOp::Sub => "riina_binop_sub",
                    BinOp::Mul => "riina_binop_mul",
                    BinOp::Div => "riina_binop_div",
                    BinOp::Mod => "riina_binop_mod",
                    BinOp::Eq => "riina_binop_eq",
                    BinOp::Ne => "riina_binop_ne",
                    BinOp::Lt => "riina_binop_lt",
                    BinOp::Le => "riina_binop_le",
                    BinOp::Gt => "riina_binop_gt",
                    BinOp::Ge => "riina_binop_ge",
                    BinOp::And => "riina_binop_and",
                    BinOp::Or => "riina_binop_or",
                };
                let call = format!("{func}({}, {})", self.var_name(lhs), self.var_name(rhs));
                // Numeric tower: a result that types as a sized integer is wrapped
                // to its width so compiled arithmetic overflows modulo 2^bits, and a
                // signed result is tagged so it later prints/compares/divides signed.
                // Unsigned narrower-than-64 wraps; unsigned 64-bit needs nothing;
                // signed any-width is tagged. Comparisons type as `Bool`, untouched.
                let rhs_expr = match instr.ty {
                    Ty::IntN { bits, signed } if signed || bits < 64 => {
                        format!("riina_trunc({call}, {bits}, {})", i32::from(signed))
                    }
                    _ => call,
                };
                self.writeln(&format!("{result} = {rhs_expr};"));
            }

            Instruction::UnaryOp(op, operand) => {
                let func = match op {
                    UnaryOp::Not => "riina_unary_not",
                    UnaryOp::Neg => "riina_unary_neg",
                };
                self.writeln(&format!("{result} = {func}({});", self.var_name(operand)));
            }

            Instruction::Closure { func, captures } => {
                // Closure emission: captures array allocated and populated.
                // Single-arg calling convention; multi-arg via currying.
                if captures.is_empty() {
                    self.writeln(&format!("{result} = riina_alloc();",));
                    self.writeln(&format!("{result}->tag = RIINA_TAG_CLOSURE;",));
                    self.writeln(&format!("{result}->security = RIINA_LEVEL_PUBLIC;",));
                    self.writeln(&format!(
                        "{result}->data.closure_val.func_ptr = (void*){};",
                        self.func_name(func)
                    ));
                    self.writeln(&format!("{result}->data.closure_val.captures = NULL;",));
                    self.writeln(&format!("{result}->data.closure_val.num_captures = 0;",));
                } else {
                    self.writeln(&format!("{result} = riina_alloc();"));
                    self.writeln(&format!("{result}->tag = RIINA_TAG_CLOSURE;"));
                    self.writeln(&format!("{result}->security = RIINA_LEVEL_PUBLIC;"));
                    self.writeln(&format!(
                        "{result}->data.closure_val.func_ptr = (void*){};",
                        self.func_name(func)
                    ));
                    self.writeln(&format!(
                        "{result}->data.closure_val.captures = (riina_value_t**)malloc({} * sizeof(riina_value_t*));",
                        captures.len()
                    ));
                    self.writeln(&format!(
                        "{result}->data.closure_val.num_captures = {};",
                        captures.len()
                    ));
                    for (i, cap) in captures.iter().enumerate() {
                        self.writeln(&format!(
                            "{result}->data.closure_val.captures[{}] = {};",
                            i,
                            self.var_name(cap)
                        ));
                    }
                }
            }

            Instruction::FixClosure {
                closure,
                capture_index,
                value,
            } => {
                // Patch one of a closure's capture slots. `value` is the closure
                // itself for plain recursion, or a sibling in a mutually
                // recursive group (which is how a forward call resolves).
                self.writeln(&format!(
                    "{}->data.closure_val.captures[{}] = {}; /* fix closure capture */",
                    self.var_name(closure),
                    capture_index,
                    self.var_name(value)
                ));
            }

            Instruction::Call(func_var, arg) => {
                self.writeln(&format!(
                    "if ({}->tag != RIINA_TAG_CLOSURE) {{ fprintf(stderr, \"RIINA: call on non-closure\\n\"); abort(); }}",
                    self.var_name(func_var)
                ));
                // If closure has captures, pass _self as first arg
                self.writeln(&format!(
                    "if ({}->data.closure_val.num_captures > 0) {{",
                    self.var_name(func_var)
                ));
                self.indent();
                self.writeln(&format!(
                    "{result} = ((riina_value_t* (*)(riina_value_t*, riina_value_t*)){}->data.closure_val.func_ptr)({}, {});",
                    self.var_name(func_var),
                    self.var_name(func_var),
                    self.var_name(arg)
                ));
                self.dedent();
                self.writeln("} else {");
                self.indent();
                self.writeln(&format!(
                    "{result} = ((riina_value_t* (*)(riina_value_t*)){}->data.closure_val.func_ptr)({});",
                    self.var_name(func_var),
                    self.var_name(arg)
                ));
                self.dedent();
                self.writeln("}");
            }

            // REQ-79: a first-class list. The C runtime already had
            // `riina_list_push`/`riina_make_list` (builtins RETURN tagged lists);
            // literals just never used them, so `senarai_*` aborted on them.
            Instruction::MakeList(elems) => {
                // Mirrors the `riina_pair` convention: vars are already
                // `riina_value_t*`, and the constructor returns one.
                let tmp = format!("lst_{}", result.replace(|c: char| !c.is_alphanumeric(), "_"));
                self.writeln(&format!("riina_list_t {tmp} = riina_list_new();"));
                for e in elems {
                    self.writeln(&format!("riina_list_push(&{tmp}, {});", self.var_name(e)));
                }
                self.writeln(&format!("{result} = riina_make_list({tmp});"));
            }

            Instruction::Pair(fst, snd) => {
                self.writeln(&format!(
                    "{result} = riina_pair({}, {});",
                    self.var_name(fst),
                    self.var_name(snd)
                ));
            }

            Instruction::Fst(pair) => {
                self.writeln(&format!("{result} = riina_fst({});", self.var_name(pair)));
            }

            Instruction::Snd(pair) => {
                self.writeln(&format!("{result} = riina_snd({});", self.var_name(pair)));
            }

            Instruction::Inl(val) => {
                self.writeln(&format!("{result} = riina_inl({});", self.var_name(val)));
            }

            Instruction::Inr(val) => {
                self.writeln(&format!("{result} = riina_inr({});", self.var_name(val)));
            }

            Instruction::IsLeft(sum) => {
                self.writeln(&format!(
                    "{result} = riina_bool(riina_is_left({}));",
                    self.var_name(sum)
                ));
            }

            Instruction::UnwrapLeft(sum) => {
                self.writeln(&format!(
                    "{result} = riina_unwrap_left({});",
                    self.var_name(sum)
                ));
            }

            Instruction::UnwrapRight(sum) => {
                self.writeln(&format!(
                    "{result} = riina_unwrap_right({});",
                    self.var_name(sum)
                ));
            }

            Instruction::Alloc { init, level } => {
                let level_str = self.security_level_str(level);
                self.writeln(&format!(
                    "{result} = riina_ref({}, {level_str});",
                    self.var_name(init)
                ));
            }

            Instruction::Load(ref_var) => {
                self.writeln(&format!(
                    "{result} = riina_load({});",
                    self.var_name(ref_var)
                ));
            }

            Instruction::Store(ref_var, val) => {
                self.writeln(&format!(
                    "{result} = riina_store({}, {});",
                    self.var_name(ref_var),
                    self.var_name(val)
                ));
            }

            Instruction::Classify(val) => {
                self.writeln(&format!(
                    "{result} = riina_classify({});",
                    self.var_name(val)
                ));
            }

            Instruction::Declassify(secret, proof) => {
                self.writeln(&format!(
                    "{result} = riina_declassify({}, {});",
                    self.var_name(secret),
                    self.var_name(proof)
                ));
            }

            Instruction::Prove(val) => {
                self.writeln(&format!("{result} = riina_prove({});", self.var_name(val)));
            }

            Instruction::Perform { effect, payload } => {
                let eff_str = self.effect_str(effect);
                self.writeln(&format!(
                    "{result} = riina_perform({eff_str}, {});",
                    self.var_name(payload)
                ));
            }

            Instruction::RequireCap(effect) => {
                let eff_str = self.effect_str(effect);
                self.writeln(&format!("riina_require_cap({eff_str});"));
                self.writeln(&format!("{result} = riina_capability({eff_str});"));
            }

            Instruction::GrantCap(effect) => {
                let eff_str = self.effect_str(effect);
                self.writeln(&format!("riina_grant_cap({eff_str});"));
                self.writeln(&format!("{result} = riina_capability({eff_str});"));
            }

            Instruction::BuiltinCall { name, arg } => {
                self.writeln(&format!(
                    "{result} = riina_builtin_{name}({});",
                    self.var_name(arg)
                ));
            }

            Instruction::FFICall { name, args } => {
                let arg_strs: Vec<String> = args
                    .iter()
                    .map(|a| format!("{}.int_val", self.var_name(a)))
                    .collect();
                self.writeln(&format!(
                    "{result} = riina_int((int64_t){name}({args}));",
                    result = result,
                    name = name,
                    args = arg_strs.join(", "),
                ));
            }

            // ═══════════════════════════════════════════════════════════
            // JALINAN (actors, choreography, CRDTs, content-addressed)
            // ═══════════════════════════════════════════════════════════
            Instruction::ActorDecl {
                name: _,
                init_state,
                handler,
            } => {
                self.writeln(&format!(
                    "{result} = *riina_actor_decl(&{init}, &{handler});",
                    result = result,
                    init = self.var_name(init_state),
                    handler = self.var_name(handler),
                ));
            }

            Instruction::ChoreographyDecl { name: _, roles: _ } => {
                self.writeln(&format!("{result} = *riina_choreography_decl();",));
            }

            Instruction::ActorSpawn(decl, state) => {
                self.writeln(&format!(
                    "{result} = *riina_actor_spawn(&{decl}, &{state});",
                    result = result,
                    decl = self.var_name(decl),
                    state = self.var_name(state),
                ));
            }

            Instruction::ActorSend(actor, msg) => {
                self.writeln(&format!(
                    "{result} = *riina_actor_send(&{actor}, &{msg});",
                    result = result,
                    actor = self.var_name(actor),
                    msg = self.var_name(msg),
                ));
            }

            Instruction::ActorRecv(actor) => {
                self.writeln(&format!(
                    "{result} = *riina_actor_recv(&{actor});",
                    result = result,
                    actor = self.var_name(actor),
                ));
            }

            Instruction::CRDTMerge(a, b) => {
                self.writeln(&format!(
                    "{result} = *riina_crdt_merge(&{a}, &{b});",
                    result = result,
                    a = self.var_name(a),
                    b = self.var_name(b),
                ));
            }

            Instruction::ContentHash(val) => {
                self.writeln(&format!(
                    "{result} = *riina_content_hash(&{val});",
                    result = result,
                    val = self.var_name(val),
                ));
            }

            Instruction::Phi(_entries) => {
                // SSA phi destruction: phi nodes are eliminated by copy insertion.
                // The phi result variable is already declared. We do NOT emit code
                // at the phi site itself; instead, predecessor blocks insert copies
                // before their terminator (see emit_phi_copies in emit_block).
                //
                // However, as a safety net for blocks with no predecessor assignment,
                // initialize to unit (dead code in well-formed IR).
                self.writeln(&format!(
                    "{result} = {result}; /* phi: assigned by predecessors */"
                ));
            }
        }

        Ok(())
    }

    /// Emit phi copy assignments: before branching to `target`, copy source vars
    /// into phi result vars for all phi nodes in the target block that expect
    /// a value from `current_block`.
    fn emit_phi_copies(&mut self, current_block: &BlockId, target: &BlockId, phi_map: &PhiMap) {
        if let Some(target_phis) = phi_map.get(target) {
            if let Some(copies) = target_phis.get(current_block) {
                for (phi_result, src_var) in copies {
                    self.writeln(&format!(
                        "{} = {}; /* phi copy: {} <- {} */",
                        self.var_name(phi_result),
                        self.var_name(src_var),
                        self.var_name(phi_result),
                        self.var_name(src_var),
                    ));
                }
            }
        }
    }

    /// Emit a block terminator with phi copy insertion (SSA destruction).
    fn emit_terminator_with_phi(
        &mut self,
        term: &Terminator,
        current_block: &BlockId,
        phi_map: &PhiMap,
    ) -> Result<()> {
        match term {
            Terminator::Return(var) => {
                self.writeln(&format!("return {};", self.var_name(var)));
            }

            Terminator::Branch(target) => {
                self.emit_phi_copies(current_block, target, phi_map);
                self.writeln(&format!("goto {};", self.block_name(target)));
            }

            Terminator::CondBranch {
                cond,
                then_block,
                else_block,
            } => {
                // Emit phi copies for both branches using an if/else to select
                // which copies to perform before jumping.
                let has_then_phis = phi_map
                    .get(then_block)
                    .and_then(|m| m.get(current_block))
                    .is_some_and(|v| !v.is_empty());
                let has_else_phis = phi_map
                    .get(else_block)
                    .and_then(|m| m.get(current_block))
                    .is_some_and(|v| !v.is_empty());

                if has_then_phis || has_else_phis {
                    self.writeln(&format!("if ({}->data.bool_val) {{", self.var_name(cond)));
                    self.indent();
                    self.emit_phi_copies(current_block, then_block, phi_map);
                    self.writeln(&format!("goto {};", self.block_name(then_block)));
                    self.dedent();
                    self.writeln("} else {");
                    self.indent();
                    self.emit_phi_copies(current_block, else_block, phi_map);
                    self.writeln(&format!("goto {};", self.block_name(else_block)));
                    self.dedent();
                    self.writeln("}");
                } else {
                    self.writeln(&format!(
                        "if ({}->data.bool_val) goto {}; else goto {};",
                        self.var_name(cond),
                        self.block_name(then_block),
                        self.block_name(else_block)
                    ));
                }
            }

            Terminator::Handle {
                body_block,
                handler_block,
                resume_var,
                result_block,
            } => {
                // Push handler frame, setjmp for non-local return from perform
                self.writeln("riina_push_handler(RIINA_EFFECT_PURE); /* handler frame */");
                self.writeln("if (setjmp(riina_handler_stack[riina_handler_top - 1].env) == 0) {");
                self.indent();
                // Normal path: execute body
                self.emit_phi_copies(current_block, body_block, phi_map);
                self.writeln(&format!("goto {};", self.block_name(body_block)));
                self.dedent();
                self.writeln("} else {");
                self.indent();
                // Handler path: effect was performed, payload in handler frame
                self.writeln(&format!(
                    "riina_value_t* {} = riina_handler_stack[riina_handler_top].payload;",
                    resume_var
                ));
                self.writeln("riina_pop_handler();");
                self.emit_phi_copies(current_block, handler_block, phi_map);
                self.writeln(&format!("goto {};", self.block_name(handler_block)));
                self.dedent();
                self.writeln("}");
                let _ = result_block; // used by handler_block's continuation
            }

            Terminator::Unreachable => {
                self.writeln("fprintf(stderr, \"RIINA: unreachable\\n\");");
                self.writeln("abort();");
            }
        }

        Ok(())
    }

    /// Emit main wrapper function
    fn emit_main_wrapper(&mut self, program: &Program) -> Result<()> {
        let main_return_ty = program
            .function(program.main)
            .map(|f| f.return_ty.clone())
            .unwrap_or(Ty::Unit);

        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("/*                         MAIN ENTRY POINT                            */");
        self.writeln("/* ═══════════════════════════════════════════════════════════════════ */");
        self.writeln("");
        self.writeln("int main(void) {");
        self.indent();

        // Grant all capabilities for main (can be restricted later)
        self.writeln("/* Grant all capabilities to main */");
        self.writeln("riina_ctx.capabilities = 0xFFFFFFFF;");
        self.writeln("");

        // Call main function
        self.writeln("/* Execute main function */");
        self.writeln(&format!(
            "riina_value_t* result = {}(riina_unit());",
            self.func_name(&program.main)
        ));
        self.writeln("");

        // Echo the program's final value to stdout — EXCEPT Unit. A Unit result
        // means the program already performed its I/O via `cetak` and returns
        // nothing, so echoing "()" would diverge from the WASM backend (whose
        // result-echo also skips Unit). Non-Unit results — a bare-expression
        // value, UI markup, etc. — are still echoed, byte-identical to WASM.
        self.writeln("/* Echo non-Unit result (Unit = already did I/O via cetak) */");
        self.writeln("switch (result->tag) {");
        self.indent();
        self.writeln("case RIINA_TAG_UNIT:");
        self.writeln("    break;");
        self.writeln("case RIINA_TAG_BOOL:");
        self.writeln("    printf(\"%s\\n\", result->data.bool_val ? \"true\" : \"false\");");
        self.writeln("    break;");
        self.writeln("case RIINA_TAG_INT:");
        self.writeln("    if (result->int_signed_bits)");
        self.writeln("        printf(\"%lld\\n\", (long long)riina_sext(result->data.int_val, result->int_signed_bits));");
        self.writeln("    else");
        self.writeln("        printf(\"%llu\\n\", (unsigned long long)result->data.int_val);");
        self.writeln("    break;");
        self.writeln("case RIINA_TAG_STRING:");
        if main_return_ty == Ty::Element {
            self.writeln("    printf(\"%s\\n\", result->data.string_val.data);");
        } else {
            self.writeln("    printf(\"\\\"%s\\\"\\n\", result->data.string_val.data);");
        }
        self.writeln("    break;");
        self.writeln("default:");
        self.writeln("    printf(\"<value>\\n\");");
        self.writeln("    break;");
        self.dedent();
        self.writeln("}");
        self.writeln("");

        self.writeln("return 0;");
        self.dedent();
        self.writeln("}");

        Ok(())
    }

    // ═══════════════════════════════════════════════════════════════════════
    // HELPER METHODS
    // ═══════════════════════════════════════════════════════════════════════

    /// Generate C name for a variable
    fn var_name(&self, var: &VarId) -> String {
        format!("v{}", var.0)
    }

    /// Generate C name for a block
    fn block_name(&self, block: &BlockId) -> String {
        format!("bb{}", block.0)
    }

    /// Generate C name for a function
    fn func_name(&self, func: &FuncId) -> String {
        format!("riina_func_{}", func.0)
    }

    /// Convert security level to C enum
    fn security_level_str(&self, level: &SecurityLevel) -> &'static str {
        match level {
            SecurityLevel::Public => "RIINA_LEVEL_PUBLIC",
            SecurityLevel::Internal => "RIINA_LEVEL_INTERNAL",
            SecurityLevel::Session => "RIINA_LEVEL_SESSION",
            SecurityLevel::User => "RIINA_LEVEL_USER",
            SecurityLevel::System => "RIINA_LEVEL_SYSTEM",
            SecurityLevel::Secret => "RIINA_LEVEL_SECRET",
        }
    }

    /// Convert effect to C enum
    fn effect_str(&self, effect: &Effect) -> &'static str {
        match effect {
            Effect::Pure => "RIINA_EFFECT_PURE",
            Effect::Mut => "RIINA_EFFECT_MUT",
            Effect::Read => "RIINA_EFFECT_READ",
            Effect::Alloc => "RIINA_EFFECT_ALLOC",
            Effect::Write => "RIINA_EFFECT_WRITE",
            Effect::FileSystem => "RIINA_EFFECT_FILESYSTEM",
            Effect::Network => "RIINA_EFFECT_NETWORK",
            Effect::NetworkSecure => "RIINA_EFFECT_NETWORK_SECURE",
            Effect::Crypto => "RIINA_EFFECT_CRYPTO",
            Effect::Random => "RIINA_EFFECT_RANDOM",
            Effect::System => "RIINA_EFFECT_SYSTEM",
            Effect::Time => "RIINA_EFFECT_TIME",
            Effect::Process => "RIINA_EFFECT_PROCESS",
            Effect::Panel => "RIINA_EFFECT_PANEL",
            Effect::Zirah => "RIINA_EFFECT_ZIRAH",
            Effect::Benteng => "RIINA_EFFECT_BENTENG",
            Effect::Sandi => "RIINA_EFFECT_SANDI",
            Effect::Menara => "RIINA_EFFECT_MENARA",
            Effect::Gapura => "RIINA_EFFECT_GAPURA",
        }
    }

    /// Escape a string for C
    fn escape_string(&self, s: &str) -> String {
        let mut result = String::with_capacity(s.len());
        for c in s.chars() {
            match c {
                '\\' => result.push_str("\\\\"),
                '"' => result.push_str("\\\""),
                '\n' => result.push_str("\\n"),
                '\r' => result.push_str("\\r"),
                '\t' => result.push_str("\\t"),
                c if c.is_ascii_control() => {
                    let _ = write!(result, "\\x{:02x}", c as u8);
                }
                c => result.push(c),
            }
        }
        result
    }
}

impl Default for CEmitter {
    fn default() -> Self {
        Self::new()
    }
}

/// Emit C code from an IR program
pub fn emit_c(program: &Program) -> Result<String> {
    let mut emitter = CEmitter::new();
    emitter.emit(program)
}

/// C source for the `simpan_*` durable store runtime (REQ-70).
///
/// Mirrors `riina-os::store`. Kept as one block so it reads as C; the on-disk
/// format it implements is byte-identical to the Rust side by construction and
/// by differential test.
const STORE_RUNTIME_C: &str = r##"
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>

/* ── Durable key-value store (simpan) ───────────────────────────────────────
 *
 * The C half of `riina-os::store`. The on-disk format is the contract:
 *
 *   header  : "RIINASTORv1\0"                        (12 bytes)
 *   record  : [payload_len:u32 LE][crc32:u32 LE][payload]
 *   payload : [op:u8][key_len:u32 LE][key][value_len:u32 LE][value]
 *   op      : 1 = put, 2 = delete
 *
 * A record counts only when its length prefix AND CRC both validate; a torn
 * tail from a crash is discarded on replay, because the VerifiedFileSystem.v
 * model says a pending transaction makes the journal inconsistent. Every put
 * and delete is fsynced before the call returns.
 */
#define RIINA_STORE_MAGIC "RIINASTORv1\0"
#define RIINA_STORE_MAGIC_LEN 12
#define RIINA_STORE_MAX_KEY (4 * 1024)
#define RIINA_STORE_MAX_VALUE (16 * 1024 * 1024)
#define RIINA_STORE_OP_PUT 1
#define RIINA_STORE_OP_DELETE 2
#define RIINA_STORE_SLOTS 64

/* CRC-32/IEEE, bitwise — identical to the Rust `crc32`.
   KAT: crc32("123456789") == 0xCBF43926. */
static uint32_t riina_store_crc32(const unsigned char* d, size_t n) {
    uint32_t crc = 0xFFFFFFFFu;
    for (size_t i = 0; i < n; i++) {
        crc ^= (uint32_t)d[i];
        for (int b = 0; b < 8; b++) {
            uint32_t mask = (uint32_t)(-(int32_t)(crc & 1u));
            crc = (crc >> 1) ^ (0xEDB88320u & mask);
        }
    }
    return ~crc;
}

typedef struct { char* k; size_t klen; char* v; size_t vlen; } riina_store_kv_t;

typedef struct {
    int used;
    char* path;
    int fd;
    riina_store_kv_t* kv;   /* sorted by key bytes, matching Rust's BTreeMap */
    size_t n, cap;
    uint64_t dead_bytes;
} riina_store_t;

static riina_store_t riina_stores[RIINA_STORE_SLOTS];

static void riina_store_die(const char* what, const char* detail) {
    fprintf(stderr, "RIINA: simpan %s: %s\n", what, detail);
    abort();
}

/* Byte-lexicographic compare, matching Rust's Vec<u8> ordering. */
static int riina_store_kcmp(const char* a, size_t alen, const char* b, size_t blen) {
    size_t n = alen < blen ? alen : blen;
    int c = n ? memcmp(a, b, n) : 0;
    if (c != 0) return c;
    return alen < blen ? -1 : (alen > blen ? 1 : 0);
}

/* Index of `key`, or the insertion point with *found = 0. */
static size_t riina_store_find(riina_store_t* s, const char* k, size_t klen, int* found) {
    size_t lo = 0, hi = s->n;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        int c = riina_store_kcmp(s->kv[mid].k, s->kv[mid].klen, k, klen);
        if (c < 0) lo = mid + 1;
        else if (c > 0) hi = mid;
        else { *found = 1; return mid; }
    }
    *found = 0;
    return lo;
}

static uint64_t riina_store_record_size(size_t klen, size_t vlen) {
    return (uint64_t)(8 + 9 + klen + vlen);
}

static void riina_store_set(riina_store_t* s, const char* k, size_t klen,
                            const char* v, size_t vlen, int count_dead) {
    int found = 0;
    size_t at = riina_store_find(s, k, klen, &found);
    if (found) {
        if (count_dead)
            s->dead_bytes += riina_store_record_size(klen, s->kv[at].vlen);
        free(s->kv[at].v);
        s->kv[at].v = (char*)malloc(vlen ? vlen : 1);
        if (!s->kv[at].v) abort();
        memcpy(s->kv[at].v, v, vlen);
        s->kv[at].vlen = vlen;
        return;
    }
    if (s->n == s->cap) {
        size_t nc = s->cap ? s->cap * 2 : 16;
        riina_store_kv_t* nk = (riina_store_kv_t*)realloc(s->kv, nc * sizeof(*nk));
        if (!nk) abort();
        s->kv = nk; s->cap = nc;
    }
    memmove(&s->kv[at + 1], &s->kv[at], (s->n - at) * sizeof(s->kv[0]));
    s->kv[at].k = (char*)malloc(klen ? klen : 1);
    s->kv[at].v = (char*)malloc(vlen ? vlen : 1);
    if (!s->kv[at].k || !s->kv[at].v) abort();
    memcpy(s->kv[at].k, k, klen); s->kv[at].klen = klen;
    memcpy(s->kv[at].v, v, vlen); s->kv[at].vlen = vlen;
    s->n++;
}

static int riina_store_erase(riina_store_t* s, const char* k, size_t klen, size_t* old_vlen) {
    int found = 0;
    size_t at = riina_store_find(s, k, klen, &found);
    if (!found) return 0;
    *old_vlen = s->kv[at].vlen;
    free(s->kv[at].k); free(s->kv[at].v);
    memmove(&s->kv[at], &s->kv[at + 1], (s->n - at - 1) * sizeof(s->kv[0]));
    s->n--;
    return 1;
}

/* Encode one record into a freshly malloc'd buffer; *out_len gets its size. */
static unsigned char* riina_store_encode(unsigned char op, const char* k, size_t klen,
                                         const char* v, size_t vlen, size_t* out_len) {
    size_t plen = 1 + 4 + klen + 4 + vlen;
    size_t total = 8 + plen;
    unsigned char* buf = (unsigned char*)malloc(total);
    if (!buf) abort();
    unsigned char* p = buf + 8;
    p[0] = op;
    uint32_t kl = (uint32_t)klen, vl = (uint32_t)vlen;
    memcpy(p + 1, &kl, 4);
    memcpy(p + 5, k, klen);
    memcpy(p + 5 + klen, &vl, 4);
    memcpy(p + 9 + klen, v, vlen);
    uint32_t pl = (uint32_t)plen;
    uint32_t crc = riina_store_crc32(p, plen);
    memcpy(buf, &pl, 4);
    memcpy(buf + 4, &crc, 4);
    *out_len = total;
    return buf;
}

/* Replay a journal image, rebuilding the live map. Stops at the first torn or
   CRC-invalid record — that is a pending transaction, not corruption. */
static void riina_store_replay(riina_store_t* s, const unsigned char* b, size_t n) {
    size_t pos = 0;
    while (pos + 8 <= n) {
        uint32_t len, want;
        memcpy(&len, b + pos, 4);
        memcpy(&want, b + pos + 4, 4);
        size_t start = pos + 8;
        if ((size_t)len > (size_t)(RIINA_STORE_MAX_KEY + RIINA_STORE_MAX_VALUE + 9)
            || start + len > n) break;              /* torn tail */
        if (riina_store_crc32(b + start, len) != want) break;  /* pending */
        const unsigned char* p = b + start;
        if (len < 9) riina_store_die("replay", "committed record too short");
        unsigned char op = p[0];
        uint32_t kl; memcpy(&kl, p + 1, 4);
        if (5 + (size_t)kl + 4 > len) riina_store_die("replay", "key length past record");
        uint32_t vl; memcpy(&vl, p + 5 + kl, 4);
        if (9 + (size_t)kl + (size_t)vl != len) riina_store_die("replay", "value length mismatch");
        const char* k = (const char*)(p + 5);
        const char* v = (const char*)(p + 9 + kl);
        uint64_t rec_len = (uint64_t)(8 + len);
        if (op == RIINA_STORE_OP_PUT) {
            riina_store_set(s, k, kl, v, vl, 1);
        } else if (op == RIINA_STORE_OP_DELETE) {
            size_t old = 0;
            if (riina_store_erase(s, k, kl, &old))
                s->dead_bytes += riina_store_record_size(kl, old) + rec_len;
            else
                s->dead_bytes += rec_len;
        } else {
            riina_store_die("replay", "unknown op byte");
        }
        pos = start + len;
    }
}

static riina_store_t* riina_store_slot(uint64_t id, const char* what) {
    if (id >= RIINA_STORE_SLOTS || !riina_stores[id].used)
        riina_store_die(what, "unknown store handle");
    return &riina_stores[id];
}

/* fsync the directory containing `path` — without it a rename is not durable. */
static void riina_store_sync_parent(const char* path) {
    char dir[4096];
    size_t n = strlen(path);
    if (n >= sizeof(dir)) return;
    memcpy(dir, path, n + 1);
    char* slash = strrchr(dir, '/');
    if (slash) *slash = 0; else { dir[0] = '.'; dir[1] = 0; }
    int dfd = open(dir, O_RDONLY);
    if (dfd >= 0) { fsync(dfd); close(dfd); }
}

/* simpan_buka (store_open): Teks -> Nombor handle */
static riina_value_t* riina_builtin_simpan_buka(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) riina_store_die("simpan_buka", "expects a path string");
    const char* path = arg->data.string_val.data;
    uint64_t id = RIINA_STORE_SLOTS;
    for (uint64_t i = 0; i < RIINA_STORE_SLOTS; i++)
        if (!riina_stores[i].used) { id = i; break; }
    if (id == RIINA_STORE_SLOTS) riina_store_die("simpan_buka", "too many open stores");
    riina_store_t* s = &riina_stores[id];
    memset(s, 0, sizeof(*s));

    int fd = open(path, O_RDWR);
    if (fd < 0) {
        fd = open(path, O_RDWR | O_CREAT | O_EXCL, 0644);
        if (fd < 0) riina_store_die("simpan_buka", strerror(errno));
        if (write(fd, RIINA_STORE_MAGIC, RIINA_STORE_MAGIC_LEN) != RIINA_STORE_MAGIC_LEN)
            riina_store_die("simpan_buka", "short write of header");
        if (fsync(fd) != 0) riina_store_die("simpan_buka", strerror(errno));
        riina_store_sync_parent(path);
    } else {
        off_t sz = lseek(fd, 0, SEEK_END);
        if (sz < 0) riina_store_die("simpan_buka", strerror(errno));
        if (sz < RIINA_STORE_MAGIC_LEN) {
            if (sz != 0) riina_store_die("simpan_buka", "not a RIINA store (bad magic)");
            if (lseek(fd, 0, SEEK_SET) < 0) riina_store_die("simpan_buka", strerror(errno));
            if (write(fd, RIINA_STORE_MAGIC, RIINA_STORE_MAGIC_LEN) != RIINA_STORE_MAGIC_LEN)
                riina_store_die("simpan_buka", "short write of header");
            if (fsync(fd) != 0) riina_store_die("simpan_buka", strerror(errno));
        } else {
            if (lseek(fd, 0, SEEK_SET) < 0) riina_store_die("simpan_buka", strerror(errno));
            unsigned char magic[RIINA_STORE_MAGIC_LEN];
            if (read(fd, magic, RIINA_STORE_MAGIC_LEN) != RIINA_STORE_MAGIC_LEN)
                riina_store_die("simpan_buka", "short read of header");
            if (memcmp(magic, RIINA_STORE_MAGIC, RIINA_STORE_MAGIC_LEN) != 0)
                riina_store_die("simpan_buka", "not a RIINA store (bad magic) - refusing to overwrite it");
            size_t body = (size_t)(sz - RIINA_STORE_MAGIC_LEN);
            if (body) {
                unsigned char* buf = (unsigned char*)malloc(body);
                if (!buf) abort();
                ssize_t got = read(fd, buf, body);
                if (got < 0 || (size_t)got != body) riina_store_die("simpan_buka", "short read of journal");
                riina_store_replay(s, buf, body);
                free(buf);
            }
        }
    }
    if (lseek(fd, 0, SEEK_END) < 0) riina_store_die("simpan_buka", strerror(errno));
    s->used = 1;
    s->fd = fd;
    s->path = (char*)malloc(strlen(path) + 1);
    if (!s->path) abort();
    memcpy(s->path, path, strlen(path) + 1);
    return riina_int(id);
}

static void riina_store_append(riina_store_t* s, const unsigned char* rec, size_t len) {
    if (lseek(s->fd, 0, SEEK_END) < 0) riina_store_die("append", strerror(errno));
    ssize_t w = write(s->fd, rec, len);
    if (w < 0 || (size_t)w != len) riina_store_die("append", "short write");
    /* Durability point: the caller is told "stored" only after this. */
    if (fsync(s->fd) != 0) riina_store_die("append", strerror(errno));
}

/* simpan_letak (store_put): (handle, (key, value)) -> Benar */
static riina_value_t* riina_builtin_simpan_letak(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_store_die("simpan_letak", "expects (handle, (key, value))");
    riina_value_t* h = arg->data.pair_val.fst;
    riina_value_t* rest = arg->data.pair_val.snd;
    if (h->tag != RIINA_TAG_INT || rest->tag != RIINA_TAG_PAIR)
        riina_store_die("simpan_letak", "expects (handle, (key, value))");
    riina_value_t* kv = rest->data.pair_val.fst;
    riina_value_t* vv = rest->data.pair_val.snd;
    if (kv->tag != RIINA_TAG_STRING || vv->tag != RIINA_TAG_STRING)
        riina_store_die("simpan_letak", "key and value must be text");
    riina_store_t* s = riina_store_slot(h->data.int_val, "simpan_letak");
    size_t klen = kv->data.string_val.len, vlen = vv->data.string_val.len;
    if (klen > RIINA_STORE_MAX_KEY) riina_store_die("simpan_letak", "key exceeds 4096 bytes");
    if (vlen > RIINA_STORE_MAX_VALUE) riina_store_die("simpan_letak", "value exceeds 16777216 bytes");
    size_t rlen = 0;
    unsigned char* rec = riina_store_encode(RIINA_STORE_OP_PUT, kv->data.string_val.data, klen,
                                            vv->data.string_val.data, vlen, &rlen);
    riina_store_append(s, rec, rlen);
    free(rec);
    riina_store_set(s, kv->data.string_val.data, klen, vv->data.string_val.data, vlen, 1);
    return riina_bool(true);
}

/* simpan_dapat (store_get): (handle, key) -> Teks ("" when absent) */
static riina_value_t* riina_builtin_simpan_dapat(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_store_die("simpan_dapat", "expects (handle, key)");
    riina_value_t* h = arg->data.pair_val.fst;
    riina_value_t* kv = arg->data.pair_val.snd;
    if (h->tag != RIINA_TAG_INT || kv->tag != RIINA_TAG_STRING)
        riina_store_die("simpan_dapat", "expects (handle, key)");
    riina_store_t* s = riina_store_slot(h->data.int_val, "simpan_dapat");
    int found = 0;
    size_t at = riina_store_find(s, kv->data.string_val.data, kv->data.string_val.len, &found);
    if (!found) return riina_string("");
    char* tmp = (char*)malloc(s->kv[at].vlen + 1);
    if (!tmp) abort();
    memcpy(tmp, s->kv[at].v, s->kv[at].vlen);
    tmp[s->kv[at].vlen] = 0;
    riina_value_t* out = riina_string(tmp);
    free(tmp);
    return out;
}

/* simpan_ada (store_has): (handle, key) -> Benar */
static riina_value_t* riina_builtin_simpan_ada(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_store_die("simpan_ada", "expects (handle, key)");
    riina_value_t* h = arg->data.pair_val.fst;
    riina_value_t* kv = arg->data.pair_val.snd;
    if (h->tag != RIINA_TAG_INT || kv->tag != RIINA_TAG_STRING)
        riina_store_die("simpan_ada", "expects (handle, key)");
    riina_store_t* s = riina_store_slot(h->data.int_val, "simpan_ada");
    int found = 0;
    riina_store_find(s, kv->data.string_val.data, kv->data.string_val.len, &found);
    return riina_bool(found ? true : false);
}

/* simpan_padam (store_delete): (handle, key) -> Benar (whether it was present) */
static riina_value_t* riina_builtin_simpan_padam(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_store_die("simpan_padam", "expects (handle, key)");
    riina_value_t* h = arg->data.pair_val.fst;
    riina_value_t* kv = arg->data.pair_val.snd;
    if (h->tag != RIINA_TAG_INT || kv->tag != RIINA_TAG_STRING)
        riina_store_die("simpan_padam", "expects (handle, key)");
    riina_store_t* s = riina_store_slot(h->data.int_val, "simpan_padam");
    size_t klen = kv->data.string_val.len;
    const char* k = kv->data.string_val.data;
    int found = 0;
    riina_store_find(s, k, klen, &found);
    if (!found) return riina_bool(false);
    size_t rlen = 0;
    unsigned char* rec = riina_store_encode(RIINA_STORE_OP_DELETE, k, klen, "", 0, &rlen);
    riina_store_append(s, rec, rlen);
    size_t old = 0;
    riina_store_erase(s, k, klen, &old);
    s->dead_bytes += riina_store_record_size(klen, old) + (uint64_t)rlen;
    free(rec);
    return riina_bool(true);
}

/* simpan_kunci (store_keys): handle -> Senarai<Teks>, sorted */
static riina_value_t* riina_builtin_simpan_kunci(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_INT) riina_store_die("simpan_kunci", "expects a handle");
    riina_store_t* s = riina_store_slot(arg->data.int_val, "simpan_kunci");
    riina_list_t l = {0};
    for (size_t i = 0; i < s->n; i++) {
        char* tmp = (char*)malloc(s->kv[i].klen + 1);
        if (!tmp) abort();
        memcpy(tmp, s->kv[i].k, s->kv[i].klen);
        tmp[s->kv[i].klen] = 0;
        riina_list_push(&l, riina_string(tmp));
        free(tmp);
    }
    return riina_make_list(l);
}

/* simpan_padat (store_compact): handle -> Benar.
   Atomic: temp file -> fsync -> rename -> fsync of the PARENT DIRECTORY.
   Without that last step the rename is not durable and a crash can resurrect
   the old file. */
static riina_value_t* riina_builtin_simpan_padat(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_INT) riina_store_die("simpan_padat", "expects a handle");
    riina_store_t* s = riina_store_slot(arg->data.int_val, "simpan_padat");
    size_t plen = strlen(s->path);
    char* tmp = (char*)malloc(plen + 16);
    if (!tmp) abort();
    memcpy(tmp, s->path, plen);
    memcpy(tmp + plen, ".padat-tmp", 11);
    int fd = open(tmp, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) riina_store_die("simpan_padat", strerror(errno));
    if (write(fd, RIINA_STORE_MAGIC, RIINA_STORE_MAGIC_LEN) != RIINA_STORE_MAGIC_LEN)
        riina_store_die("simpan_padat", "short write of header");
    for (size_t i = 0; i < s->n; i++) {
        size_t rlen = 0;
        unsigned char* rec = riina_store_encode(RIINA_STORE_OP_PUT, s->kv[i].k, s->kv[i].klen,
                                                s->kv[i].v, s->kv[i].vlen, &rlen);
        ssize_t w = write(fd, rec, rlen);
        if (w < 0 || (size_t)w != rlen) riina_store_die("simpan_padat", "short write");
        free(rec);
    }
    if (fsync(fd) != 0) riina_store_die("simpan_padat", strerror(errno));
    close(fd);
    if (rename(tmp, s->path) != 0) riina_store_die("simpan_padat", strerror(errno));
    riina_store_sync_parent(s->path);
    free(tmp);
    close(s->fd);
    s->fd = open(s->path, O_RDWR);
    if (s->fd < 0) riina_store_die("simpan_padat", strerror(errno));
    if (lseek(s->fd, 0, SEEK_END) < 0) riina_store_die("simpan_padat", strerror(errno));
    s->dead_bytes = 0;
    return riina_bool(true);
}

/* simpan_tutup (store_close): handle -> Benar. Every write was already
   fsynced, so closing only releases the handle. */
static riina_value_t* riina_builtin_simpan_tutup(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_INT) riina_store_die("simpan_tutup", "expects a handle");
    riina_store_t* s = riina_store_slot(arg->data.int_val, "simpan_tutup");
    close(s->fd);
    for (size_t i = 0; i < s->n; i++) { free(s->kv[i].k); free(s->kv[i].v); }
    free(s->kv);
    free(s->path);
    memset(s, 0, sizeof(*s));
    return riina_bool(true);
}
"##;

/// C source for the `jaring_*` + `http_*` runtime (REQ-70 family routing).
///
/// Mirrors `riina-os::net` and `riina-os::http`. Kept as one block so it reads
/// as C and can be diffed against the Rust it ports. Two invariants must hold
/// for the two backends to be the same language:
///
/// 1. every socket operation is gated by the same verified RFC 793 machine, so
///    "send on a closed connection" is refused by the model on both sides;
/// 2. the HTTP parser is byte-for-byte as strict, so a message that frames two
///    ways is an error in compiled code exactly as it is in the interpreter.
const NET_RUNTIME_C: &str = r##"
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <errno.h>
#include <sys/time.h>

/* ── Verified TCP state machine (jaring) ────────────────────────────────────
 *
 * The C port of `riina-os::net`, which is itself the 1:1 port of the predicate
 * core of `02_FORMAL/coq/domains/VerifiedNetwork.v`. `riina_tcp_next_state` is
 * the SAME 15-edge table as Rust's `next_state`; anything not in it is not a
 * transition, and an operation needing one is refused. The kernel performs the
 * real packet exchange — the machine records the corresponding verified events
 * — so this gates RIINA's view of the connection, not the wire.
 */
typedef enum {
    RIINA_TCP_CLOSED = 0,
    RIINA_TCP_LISTEN,
    RIINA_TCP_SYN_SENT,
    RIINA_TCP_SYN_RECEIVED,
    RIINA_TCP_ESTABLISHED,
    RIINA_TCP_FIN_WAIT_1,
    RIINA_TCP_FIN_WAIT_2,
    RIINA_TCP_CLOSE_WAIT,
    RIINA_TCP_CLOSING,
    RIINA_TCP_LAST_ACK,
    RIINA_TCP_TIME_WAIT
} riina_tcp_state_t;

typedef enum {
    RIINA_EV_PASSIVE_OPEN = 0,
    RIINA_EV_ACTIVE_OPEN,
    RIINA_EV_SYN_RECEIVED,
    RIINA_EV_SYN_ACK_RECEIVED,
    RIINA_EV_ACK_RECEIVED,
    RIINA_EV_FIN_RECEIVED,
    RIINA_EV_CLOSE,
    RIINA_EV_TIMEOUT
} riina_tcp_event_t;

/* The transition table. Returns the successor state, or -1 for "no edge" —
   which is a REFUSAL, never a fallback to the current state. */
static int riina_tcp_next_state(riina_tcp_state_t from, riina_tcp_event_t ev) {
    switch (from) {
    case RIINA_TCP_CLOSED:
        if (ev == RIINA_EV_PASSIVE_OPEN) return RIINA_TCP_LISTEN;
        if (ev == RIINA_EV_ACTIVE_OPEN)  return RIINA_TCP_SYN_SENT;
        return -1;
    case RIINA_TCP_LISTEN:
        if (ev == RIINA_EV_SYN_RECEIVED) return RIINA_TCP_SYN_RECEIVED;
        if (ev == RIINA_EV_CLOSE)        return RIINA_TCP_CLOSED;
        return -1;
    case RIINA_TCP_SYN_SENT:
        if (ev == RIINA_EV_SYN_ACK_RECEIVED) return RIINA_TCP_ESTABLISHED;
        return -1;
    case RIINA_TCP_SYN_RECEIVED:
        if (ev == RIINA_EV_ACK_RECEIVED) return RIINA_TCP_ESTABLISHED;
        return -1;
    case RIINA_TCP_ESTABLISHED:
        if (ev == RIINA_EV_FIN_RECEIVED) return RIINA_TCP_CLOSE_WAIT;
        if (ev == RIINA_EV_CLOSE)        return RIINA_TCP_FIN_WAIT_1;
        return -1;
    case RIINA_TCP_FIN_WAIT_1:
        if (ev == RIINA_EV_FIN_RECEIVED) return RIINA_TCP_CLOSING;
        if (ev == RIINA_EV_ACK_RECEIVED) return RIINA_TCP_FIN_WAIT_2;
        return -1;
    case RIINA_TCP_FIN_WAIT_2:
        if (ev == RIINA_EV_FIN_RECEIVED) return RIINA_TCP_TIME_WAIT;
        return -1;
    case RIINA_TCP_CLOSING:
        if (ev == RIINA_EV_ACK_RECEIVED) return RIINA_TCP_TIME_WAIT;
        return -1;
    case RIINA_TCP_CLOSE_WAIT:
        if (ev == RIINA_EV_CLOSE) return RIINA_TCP_LAST_ACK;
        return -1;
    case RIINA_TCP_LAST_ACK:
        if (ev == RIINA_EV_ACK_RECEIVED) return RIINA_TCP_CLOSED;
        return -1;
    case RIINA_TCP_TIME_WAIT:
        if (ev == RIINA_EV_TIMEOUT) return RIINA_TCP_CLOSED;
        return -1;
    }
    return -1;
}

static void riina_net_die(const char* what, const char* detail) {
    fprintf(stderr, "RIINA: jaring %s: %s\n", what, detail);
    abort();
}

/* One tracked connection or listener. Ids are handed out from a single
   monotonically increasing counter shared by both kinds, exactly as the
   interpreter's `NetState::next_id` does, so a program's handle values agree
   across backends. */
#define RIINA_NET_KIND_FREE 0
#define RIINA_NET_KIND_CONN 1
#define RIINA_NET_KIND_LISTENER 2

typedef struct {
    int kind;
    riina_tcp_state_t state;
    int fd;                 /* -1 once the socket has really been closed */
} riina_net_entry_t;

static riina_net_entry_t* riina_net_tab = NULL;
static size_t riina_net_cap = 0;
static uint64_t riina_net_next_id = 0;

static uint64_t riina_net_new_id(int kind, riina_tcp_state_t state, int fd) {
    uint64_t id = riina_net_next_id++;
    if (id >= riina_net_cap) {
        size_t want = riina_net_cap ? riina_net_cap * 2 : 16;
        while (id >= want) want *= 2;
        riina_net_entry_t* grown =
            (riina_net_entry_t*)realloc(riina_net_tab, want * sizeof(riina_net_entry_t));
        if (!grown) abort();
        memset(grown + riina_net_cap, 0, (want - riina_net_cap) * sizeof(riina_net_entry_t));
        riina_net_tab = grown;
        riina_net_cap = want;
    }
    riina_net_tab[id].kind = kind;
    riina_net_tab[id].state = state;
    riina_net_tab[id].fd = fd;
    return id;
}

static riina_net_entry_t* riina_net_get(uint64_t id, int kind, const char* what) {
    if (id >= riina_net_next_id || id >= riina_net_cap || riina_net_tab[id].kind != kind) {
        riina_net_die(what, kind == RIINA_NET_KIND_CONN ? "unknown connection"
                                                        : "unknown listener");
    }
    return &riina_net_tab[id];
}

/* Drive the machine, refusing an event with no edge. `detail` is the message
   the interpreter uses for the same refusal. */
static void riina_net_event(riina_net_entry_t* e, riina_tcp_event_t ev,
                            const char* what, const char* detail) {
    int to = riina_tcp_next_state(e->state, ev);
    if (to < 0) riina_net_die(what, detail);
    e->state = (riina_tcp_state_t)to;
}

/* Build a RIINA string from `n` bytes, replacing ill-formed UTF-8 with U+FFFD
   the way Rust's `String::from_utf8_lossy` does (one replacement per maximal
   ill-formed subpart, Unicode 5.2 §3.9). Without this the two backends would
   disagree byte-for-byte the moment a peer sent non-UTF-8, and `riina_string`
   alone would additionally truncate at an embedded NUL. */
static riina_value_t* riina_net_string_lossy(const unsigned char* p, size_t n) {
    size_t cap = n + 16, len = 0;
    unsigned char* out = (unsigned char*)malloc(cap + 1);
    if (!out) abort();
    size_t i = 0;
    while (i < n) {
        unsigned char b = p[i];
        size_t width;
        unsigned char lo, hi;   /* accepted range for the SECOND byte */
        if (b < 0x80) {
            if (len + 1 > cap) { cap = cap * 2 + 1; out = (unsigned char*)realloc(out, cap + 1); if (!out) abort(); }
            out[len++] = b;
            i++;
            continue;
        } else if (b >= 0xC2 && b <= 0xDF) { width = 2; lo = 0x80; hi = 0xBF; }
        else if (b == 0xE0)                { width = 3; lo = 0xA0; hi = 0xBF; }
        else if (b >= 0xE1 && b <= 0xEC)   { width = 3; lo = 0x80; hi = 0xBF; }
        else if (b == 0xED)                { width = 3; lo = 0x80; hi = 0x9F; }
        else if (b >= 0xEE && b <= 0xEF)   { width = 3; lo = 0x80; hi = 0xBF; }
        else if (b == 0xF0)                { width = 4; lo = 0x90; hi = 0xBF; }
        else if (b >= 0xF1 && b <= 0xF3)   { width = 4; lo = 0x80; hi = 0xBF; }
        else if (b == 0xF4)                { width = 4; lo = 0x80; hi = 0x8F; }
        else                               { width = 0; lo = 0; hi = 0; }

        size_t good = 1;   /* bytes of a maximal subpart consumed so far */
        if (width != 0) {
            for (size_t k = 1; k < width; k++) {
                if (i + k >= n) break;
                unsigned char c = p[i + k];
                unsigned char klo = (k == 1) ? lo : 0x80;
                unsigned char khi = (k == 1) ? hi : 0xBF;
                if (c < klo || c > khi) break;
                good++;
            }
        }
        if (len + 3 > cap) { cap = cap * 2 + 3; out = (unsigned char*)realloc(out, cap + 1); if (!out) abort(); }
        if (width != 0 && good == width) {
            for (size_t k = 0; k < width; k++) out[len++] = p[i + k];
            i += width;
        } else {
            /* Ill-formed: ONE U+FFFD for the whole maximal subpart. */
            out[len++] = 0xEF; out[len++] = 0xBF; out[len++] = 0xBD;
            i += good;
        }
    }
    out[len] = 0;
    riina_value_t* v = riina_alloc();
    v->tag = RIINA_TAG_STRING;
    v->security = RIINA_LEVEL_PUBLIC;
    v->data.string_val.data = (char*)out;
    v->data.string_val.len = len;
    return v;
}

/* Resolve "host:port" the way Rust's `ToSocketAddrs` does: split at the LAST
   colon so an unbracketed IPv6 literal cannot be mis-split, then getaddrinfo. */
static struct addrinfo* riina_net_resolve(const char* addr, const char* what) {
    const char* colon = strrchr(addr, ':');
    if (!colon || colon == addr) riina_net_die(what, "address must be \"host:port\"");
    size_t hlen = (size_t)(colon - addr);
    char* host = (char*)malloc(hlen + 1);
    if (!host) abort();
    memcpy(host, addr, hlen);
    host[hlen] = 0;
    /* Strip the brackets of an IPv6 literal, as Rust's parser does. */
    char* hp = host;
    if (hlen >= 2 && host[0] == '[' && host[hlen - 1] == ']') {
        host[hlen - 1] = 0;
        hp = host + 1;
    }
    struct addrinfo hints, *res = NULL;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    int rc = getaddrinfo(hp, colon + 1, &hints, &res);
    free(host);
    if (rc != 0) riina_net_die(what, gai_strerror(rc));
    return res;
}

/* jaring_sambung (net_connect): Teks -> Nombor
   CLOSED --ActiveOpen--> SYN_SENT --SynAckReceived--> ESTABLISHED. On connect
   failure nothing is registered, so no id is ever handed out for a socket that
   does not exist. */
static riina_value_t* riina_builtin_jaring_sambung(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) riina_net_die("sambung", "expects an address string");
    const char* addr = arg->data.string_val.data;
    riina_tcp_state_t st = RIINA_TCP_CLOSED;
    int to = riina_tcp_next_state(st, RIINA_EV_ACTIVE_OPEN);
    if (to < 0) riina_net_die("sambung", "internal state error");
    st = (riina_tcp_state_t)to;

    struct addrinfo* res = riina_net_resolve(addr, "sambung");
    int fd = -1;
    for (struct addrinfo* ai = res; ai; ai = ai->ai_next) {
        fd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
        if (fd < 0) continue;
        if (connect(fd, ai->ai_addr, ai->ai_addrlen) == 0) break;
        close(fd);
        fd = -1;
    }
    int saved = errno;
    freeaddrinfo(res);
    if (fd < 0) riina_net_die("sambung", strerror(saved));

    to = riina_tcp_next_state(st, RIINA_EV_SYN_ACK_RECEIVED);
    if (to < 0) riina_net_die("sambung", "internal state error");
    return riina_int(riina_net_new_id(RIINA_NET_KIND_CONN, (riina_tcp_state_t)to, fd));
}

/* jaring_hantar (net_send): (handle, Teks) -> Nombor, gated on ESTABLISHED. */
static riina_value_t* riina_builtin_jaring_hantar(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_net_die("hantar", "expects (handle, data)");
    riina_value_t* h = arg->data.pair_val.fst;
    riina_value_t* d = arg->data.pair_val.snd;
    if (h->tag != RIINA_TAG_INT || d->tag != RIINA_TAG_STRING)
        riina_net_die("hantar", "expects (handle, data)");
    riina_net_entry_t* e = riina_net_get(h->data.int_val, RIINA_NET_KIND_CONN, "hantar");
    if (e->state != RIINA_TCP_ESTABLISHED || e->fd < 0) riina_net_die("hantar", "not established");
    const char* p = d->data.string_val.data;
    size_t left = d->data.string_val.len;
    while (left > 0) {
        ssize_t w = send(e->fd, p, left, 0);
        if (w < 0) {
            if (errno == EINTR) continue;
            riina_net_die("hantar", strerror(errno));
        }
        p += (size_t)w;
        left -= (size_t)w;
    }
    return riina_int((uint64_t)d->data.string_val.len);
}

/* jaring_terima (net_recv): (handle, max) -> Teks, gated on ESTABLISHED.
   ONE read, like the interpreter's single `stream.read` — a loop here would
   change how much data a program observes per call. */
static riina_value_t* riina_builtin_jaring_terima(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_net_die("terima", "expects (handle, max)");
    riina_value_t* h = arg->data.pair_val.fst;
    riina_value_t* m = arg->data.pair_val.snd;
    if (h->tag != RIINA_TAG_INT || m->tag != RIINA_TAG_INT)
        riina_net_die("terima", "expects (handle, max)");
    riina_net_entry_t* e = riina_net_get(h->data.int_val, RIINA_NET_KIND_CONN, "terima");
    if (e->state != RIINA_TCP_ESTABLISHED || e->fd < 0) riina_net_die("terima", "not established");
    uint64_t max = m->data.int_val;
    if (max > (uint64_t)SIZE_MAX) riina_net_die("terima", "max too large");
    size_t cap = (size_t)max;
    unsigned char* buf = (unsigned char*)malloc(cap ? cap : 1);
    if (!buf) abort();
    ssize_t got;
    do { got = recv(e->fd, buf, cap, 0); } while (got < 0 && errno == EINTR);
    if (got < 0) { int s = errno; free(buf); riina_net_die("terima", strerror(s)); }
    riina_value_t* out = riina_net_string_lossy(buf, (size_t)got);
    free(buf);
    return out;
}

/* jaring_tutup (net_close): handle -> Benar.
   Active close: ESTABLISHED --Close--> FIN_WAIT_1, really close the socket (the
   OS sends FIN), then replay AckReceived -> FIN_WAIT_2, FinReceived ->
   TIME_WAIT, Timeout -> CLOSED. The entry stays registered in CLOSED so a later
   send is refused by the machine rather than by a stale fd. */
static riina_value_t* riina_builtin_jaring_tutup(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_INT) riina_net_die("tutup", "expects a handle");
    riina_net_entry_t* e = riina_net_get(arg->data.int_val, RIINA_NET_KIND_CONN, "tutup");
    riina_net_event(e, RIINA_EV_CLOSE, "tutup", "not established");
    if (e->fd >= 0) { close(e->fd); e->fd = -1; }
    riina_net_event(e, RIINA_EV_ACK_RECEIVED, "tutup", "internal state error");
    riina_net_event(e, RIINA_EV_FIN_RECEIVED, "tutup", "internal state error");
    riina_net_event(e, RIINA_EV_TIMEOUT, "tutup", "internal state error");
    return riina_bool(true);
}

/* jaring_dengar (net_listen): Teks -> Nombor. CLOSED --PassiveOpen--> LISTEN.
   SO_REUSEADDR and backlog 128 match Rust's `TcpListener::bind`. */
static riina_value_t* riina_builtin_jaring_dengar(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) riina_net_die("dengar", "expects an address string");
    int to = riina_tcp_next_state(RIINA_TCP_CLOSED, RIINA_EV_PASSIVE_OPEN);
    if (to < 0) riina_net_die("dengar", "internal state error");

    struct addrinfo* res = riina_net_resolve(arg->data.string_val.data, "dengar");
    int fd = -1;
    for (struct addrinfo* ai = res; ai; ai = ai->ai_next) {
        fd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
        if (fd < 0) continue;
        int on = 1;
        setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
        if (bind(fd, ai->ai_addr, ai->ai_addrlen) == 0 && listen(fd, 128) == 0) break;
        close(fd);
        fd = -1;
    }
    int saved = errno;
    freeaddrinfo(res);
    if (fd < 0) riina_net_die("dengar", strerror(saved));
    return riina_int(riina_net_new_id(RIINA_NET_KIND_LISTENER, (riina_tcp_state_t)to, fd));
}

/* jaring_alamat (net_local_addr): handle -> Teks, rendered the way Rust's
   `SocketAddr` Display does ("127.0.0.1:8080", "[::1]:8080"). */
static riina_value_t* riina_builtin_jaring_alamat(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_INT) riina_net_die("alamat", "expects a handle");
    riina_net_entry_t* e = riina_net_get(arg->data.int_val, RIINA_NET_KIND_LISTENER, "alamat");
    if (e->state != RIINA_TCP_LISTEN || e->fd < 0) riina_net_die("alamat", "not listening");
    struct sockaddr_storage ss;
    socklen_t slen = sizeof(ss);
    if (getsockname(e->fd, (struct sockaddr*)&ss, &slen) != 0)
        riina_net_die("alamat", strerror(errno));
    char host[INET6_ADDRSTRLEN + 1];
    char out[INET6_ADDRSTRLEN + 16];
    if (ss.ss_family == AF_INET) {
        struct sockaddr_in* a = (struct sockaddr_in*)&ss;
        if (!inet_ntop(AF_INET, &a->sin_addr, host, sizeof(host)))
            riina_net_die("alamat", strerror(errno));
        snprintf(out, sizeof(out), "%s:%u", host, (unsigned)ntohs(a->sin_port));
    } else if (ss.ss_family == AF_INET6) {
        struct sockaddr_in6* a = (struct sockaddr_in6*)&ss;
        if (!inet_ntop(AF_INET6, &a->sin6_addr, host, sizeof(host)))
            riina_net_die("alamat", strerror(errno));
        snprintf(out, sizeof(out), "[%s]:%u", host, (unsigned)ntohs(a->sin6_port));
    } else {
        riina_net_die("alamat", "unsupported address family");
        return NULL;
    }
    return riina_string(out);
}

/* jaring_terima_sambungan (net_accept): handle -> Nombor.
   Gated on LISTEN; the accepted connection replays the verified passive path
   LISTEN --SynReceived--> SYN_RECEIVED --AckReceived--> ESTABLISHED and is then
   indistinguishable from a connected one. */
static riina_value_t* riina_builtin_jaring_terima_sambungan(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_INT) riina_net_die("terima_sambungan", "expects a handle");
    riina_net_entry_t* e =
        riina_net_get(arg->data.int_val, RIINA_NET_KIND_LISTENER, "terima_sambungan");
    if (e->state != RIINA_TCP_LISTEN || e->fd < 0)
        riina_net_die("terima_sambungan", "not listening");
    int lfd = e->fd;
    int cfd;
    do { cfd = accept(lfd, NULL, NULL); } while (cfd < 0 && errno == EINTR);
    if (cfd < 0) riina_net_die("terima_sambungan", strerror(errno));

    riina_tcp_state_t st = RIINA_TCP_LISTEN;
    int to = riina_tcp_next_state(st, RIINA_EV_SYN_RECEIVED);
    if (to < 0) riina_net_die("terima_sambungan", "internal state error");
    to = riina_tcp_next_state((riina_tcp_state_t)to, RIINA_EV_ACK_RECEIVED);
    if (to < 0) riina_net_die("terima_sambungan", "internal state error");
    return riina_int(riina_net_new_id(RIINA_NET_KIND_CONN, (riina_tcp_state_t)to, cfd));
}

/* jaring_tutup_dengar (net_close_listener): handle -> Benar.
   The RFC 793 p.22 close-from-LISTEN edge; a second close is refused because
   CLOSED has no Close edge. */
static riina_value_t* riina_builtin_jaring_tutup_dengar(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_INT) riina_net_die("tutup_dengar", "expects a handle");
    riina_net_entry_t* e =
        riina_net_get(arg->data.int_val, RIINA_NET_KIND_LISTENER, "tutup_dengar");
    riina_net_event(e, RIINA_EV_CLOSE, "tutup_dengar", "not listening");
    if (e->fd >= 0) { close(e->fd); e->fd = -1; }
    return riina_bool(true);
}

/* tls_dasar_ok (tls_policy_ok): (version, cipher) -> Bool.
   The PURE acceptance policy — NET_001_03 (no downgrade) + NET_001_08 (cipher
   strength): accept iff TLS 1.3 with a representable strong suite. No
   handshake happens here, on either backend. */
static int riina_tls_version_is_13(const char* s) {
    while (*s == ' ' || *s == '\t' || *s == '\n' || *s == '\r') s++;
    size_t n = strlen(s);
    while (n > 0 && (s[n-1] == ' ' || s[n-1] == '\t' || s[n-1] == '\n' || s[n-1] == '\r')) n--;
    return (n == 3 && memcmp(s, "1.3", 3) == 0)
        || (n == 6 && memcmp(s, "TLS1.3", 6) == 0)
        || (n == 7 && memcmp(s, "TLSv1.3", 7) == 0);
}

static int riina_tls_version_known(const char* s) {
    while (*s == ' ' || *s == '\t' || *s == '\n' || *s == '\r') s++;
    size_t n = strlen(s);
    while (n > 0 && (s[n-1] == ' ' || s[n-1] == '\t' || s[n-1] == '\n' || s[n-1] == '\r')) n--;
    static const char* known[] = {
        "1.0", "TLS1.0", "TLSv1.0", "1.1", "TLS1.1", "TLSv1.1",
        "1.2", "TLS1.2", "TLSv1.2", "1.3", "TLS1.3", "TLSv1.3"
    };
    for (size_t i = 0; i < sizeof(known) / sizeof(known[0]); i++) {
        if (strlen(known[i]) == n && memcmp(s, known[i], n) == 0) return 1;
    }
    return 0;
}

static int riina_tls_cipher_known(const char* s) {
    while (*s == ' ' || *s == '\t' || *s == '\n' || *s == '\r') s++;
    size_t n = strlen(s);
    while (n > 0 && (s[n-1] == ' ' || s[n-1] == '\t' || s[n-1] == '\n' || s[n-1] == '\r')) n--;
    static const char* known[] = {
        "TLS_AES_128_GCM_SHA256", "TLS_AES_256_GCM_SHA384", "TLS_CHACHA20_POLY1305_SHA256"
    };
    for (size_t i = 0; i < sizeof(known) / sizeof(known[0]); i++) {
        if (strlen(known[i]) == n && memcmp(s, known[i], n) == 0) return 1;
    }
    return 0;
}

static riina_value_t* riina_builtin_tls_dasar_ok(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_net_die("tls_dasar_ok", "expects (version, cipher)");
    riina_value_t* v = arg->data.pair_val.fst;
    riina_value_t* c = arg->data.pair_val.snd;
    if (v->tag != RIINA_TAG_STRING || c->tag != RIINA_TAG_STRING)
        riina_net_die("tls_dasar_ok", "expects (version, cipher)");
    /* An unparseable version or suite is NOT accepted — the interpreter returns
       false rather than erroring, and so does this. */
    if (!riina_tls_version_known(v->data.string_val.data)) return riina_bool(false);
    if (!riina_tls_cipher_known(c->data.string_val.data)) return riina_bool(false);
    /* Every representable suite is strong, so the policy reduces to TLS 1.3. */
    return riina_bool(riina_tls_version_is_13(v->data.string_val.data) ? true : false);
}

/* ── Strict HTTP/1.1 codec (http) ───────────────────────────────────────────
 *
 * The C port of `riina-os::http`. Deliberately strict: it REFUSES rather than
 * guesses, because HTTP/1.1's real vulnerabilities are framing disagreements
 * between two parsers reading one byte stream. Every refusal below has a
 * matching one in the Rust codec, and `net_differential.rs` checks they agree.
 */
#define RIINA_HTTP_MAX_HEAD (64 * 1024)
#define RIINA_HTTP_MAX_HEADERS 128
#define RIINA_HTTP_MAX_BODY (8 * 1024 * 1024)

static void riina_http_die(const char* detail) {
    fprintf(stderr, "RIINA: http: %s\n", detail);
    abort();
}

typedef struct { char* p; size_t n, cap; } riina_http_buf_t;

static void riina_http_buf_push(riina_http_buf_t* b, const char* d, size_t n) {
    if (b->n + n + 1 > b->cap) {
        size_t want = b->cap ? b->cap * 2 : 256;
        while (b->n + n + 1 > want) want *= 2;
        char* grown = (char*)realloc(b->p, want);
        if (!grown) abort();
        b->p = grown;
        b->cap = want;
    }
    if (n) memcpy(b->p + b->n, d, n);
    b->n += n;
    b->p[b->n] = 0;
}

static void riina_http_buf_str(riina_http_buf_t* b, const char* s) {
    riina_http_buf_push(b, s, strlen(s));
}

/* Header map: sorted by lowercase name, unique — the C shape of Rust's
   `BTreeMap<String, String>`, so `encode_response` emits fields in the SAME
   order on both backends. */
typedef struct { char* name; char* value; size_t vlen; } riina_http_hdr_t;
typedef struct { riina_http_hdr_t* h; size_t n, cap; } riina_http_hdrs_t;

static char* riina_http_dup(const char* p, size_t n) {
    char* s = (char*)malloc(n + 1);
    if (!s) abort();
    if (n) memcpy(s, p, n);
    s[n] = 0;
    return s;
}

/* Insert, or append ", value" to an existing field (RFC 9112 §5.2). Values
   carry an explicit length: a header value may legitimately contain a NUL on
   the request path (the parser does not reject it there), and the interpreter
   keeps it, so truncating at one would be a silent cross-backend divergence. */
static void riina_http_hdr_add(riina_http_hdrs_t* hs, const char* name,
                               const char* value, size_t vlen) {
    size_t lo = 0, hi = hs->n;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        int c = strcmp(hs->h[mid].name, name);
        if (c < 0) lo = mid + 1;
        else if (c > 0) hi = mid;
        else {
            size_t a = hs->h[mid].vlen;
            char* joined = (char*)malloc(a + 2 + vlen + 1);
            if (!joined) abort();
            memcpy(joined, hs->h[mid].value, a);
            memcpy(joined + a, ", ", 2);
            if (vlen) memcpy(joined + a + 2, value, vlen);
            joined[a + 2 + vlen] = 0;
            free(hs->h[mid].value);
            hs->h[mid].value = joined;
            hs->h[mid].vlen = a + 2 + vlen;
            return;
        }
    }
    if (hs->n + 1 > hs->cap) {
        size_t want = hs->cap ? hs->cap * 2 : 16;
        riina_http_hdr_t* grown = (riina_http_hdr_t*)realloc(hs->h, want * sizeof(riina_http_hdr_t));
        if (!grown) abort();
        hs->h = grown;
        hs->cap = want;
    }
    memmove(hs->h + lo + 1, hs->h + lo, (hs->n - lo) * sizeof(riina_http_hdr_t));
    hs->h[lo].name = riina_http_dup(name, strlen(name));
    hs->h[lo].value = riina_http_dup(value, vlen);
    hs->h[lo].vlen = vlen;
    hs->n++;
}

static const riina_http_hdr_t* riina_http_hdr_get(const riina_http_hdrs_t* hs, const char* name) {
    size_t lo = 0, hi = hs->n;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        int c = strcmp(hs->h[mid].name, name);
        if (c < 0) lo = mid + 1;
        else if (c > 0) hi = mid;
        else return &hs->h[mid];
    }
    return NULL;
}

static void riina_http_hdrs_free(riina_http_hdrs_t* hs) {
    for (size_t i = 0; i < hs->n; i++) { free(hs->h[i].name); free(hs->h[i].value); }
    free(hs->h);
    hs->h = NULL;
    hs->n = hs->cap = 0;
}

/* Locate the CRLFCRLF head terminator. Returns the head length and sets
   *body_start; -1 means "incomplete", -2 means "head too large". */
static long riina_http_split_head(const unsigned char* b, size_t n, size_t* body_start) {
    size_t limit = n < (size_t)RIINA_HTTP_MAX_HEAD + 4 ? n : (size_t)RIINA_HTTP_MAX_HEAD + 4;
    for (size_t i = 0; i + 3 < limit; i++) {
        if (b[i] == '\r' && b[i+1] == '\n' && b[i+2] == '\r' && b[i+3] == '\n') {
            if (i > (size_t)RIINA_HTTP_MAX_HEAD) return -2;
            *body_start = i + 4;
            return (long)i;
        }
    }
    if (n > (size_t)RIINA_HTTP_MAX_HEAD) return -2;
    return -1;
}

/* Trim SP/HTAB from both ends, matching Rust's `trim_matches`. */
static void riina_http_trim(const char** p, size_t* n) {
    while (*n > 0 && ((*p)[0] == ' ' || (*p)[0] == '\t')) { (*p)++; (*n)--; }
    while (*n > 0 && ((*p)[*n-1] == ' ' || (*p)[*n-1] == '\t')) (*n)--;
}

/* Parse the header block. `has_len`/`content_length` report the framing
   length. Every refusal here mirrors one in `riina-os::http::parse_headers`. */
static void riina_http_parse_headers(const char* head, size_t head_len, size_t skip_start_line,
                                     riina_http_hdrs_t* out, int* has_len, uint64_t* content_length) {
    *has_len = 0;
    *content_length = 0;
    int saw_te = 0;
    size_t count = 0;

    size_t i = 0;
    int first = 1;
    while (i <= head_len) {
        size_t j = i;
        while (j + 1 < head_len && !(head[j] == '\r' && head[j+1] == '\n')) j++;
        size_t line_len = (j + 1 < head_len) ? (j - i) : (head_len - i);
        const char* line = head + i;
        size_t next = (j + 1 < head_len) ? (j + 2) : (head_len + 1);

        if (first && skip_start_line) { first = 0; i = next; continue; }
        first = 0;
        if (line_len == 0) { i = next; continue; }

        if (++count > (size_t)RIINA_HTTP_MAX_HEADERS)
            riina_http_die("more than 128 header fields");

        const char* colon = (const char*)memchr(line, ':', line_len);
        if (!colon) riina_http_die("malformed header line");
        size_t nlen = (size_t)(colon - line);
        if (nlen == 0) riina_http_die("malformed header line");
        /* RFC 9112 §5.1: no whitespace between field name and colon. */
        if (line[nlen-1] == ' ' || line[nlen-1] == '\t')
            riina_http_die("whitespace between field name and colon (RFC 9112 5.1: request smuggling)");

        char* name = riina_http_dup(line, nlen);
        for (size_t k = 0; k < nlen; k++)
            if (name[k] >= 'A' && name[k] <= 'Z') name[k] = (char)(name[k] - 'A' + 'a');

        const char* vp = colon + 1;
        size_t vlen = line_len - nlen - 1;
        riina_http_trim(&vp, &vlen);
        char* value = riina_http_dup(vp, vlen);

        if (strcmp(name, "content-length") == 0) {
            /* A comma list must agree with itself, or the message frames two ways. */
            const char* s = value;
            while (1) {
                const char* comma = strchr(s, ',');
                size_t plen = comma ? (size_t)(comma - s) : strlen(s);
                const char* pp = s;
                riina_http_trim(&pp, &plen);
                if (plen == 0) riina_http_die("invalid Content-Length");
                uint64_t parsed = 0;
                for (size_t k = 0; k < plen; k++) {
                    if (pp[k] < '0' || pp[k] > '9') riina_http_die("invalid Content-Length");
                    if (parsed > (UINT64_MAX - (uint64_t)(pp[k] - '0')) / 10)
                        riina_http_die("invalid Content-Length");
                    parsed = parsed * 10 + (uint64_t)(pp[k] - '0');
                }
                if (!*has_len) { *has_len = 1; *content_length = parsed; }
                else if (*content_length != parsed) riina_http_die("conflicting Content-Length values");
                if (!comma) break;
                s = comma + 1;
            }
        } else if (strcmp(name, "transfer-encoding") == 0) {
            saw_te = 1;
        }

        riina_http_hdr_add(out, name, value, vlen);
        free(name);
        free(value);
        i = next;
    }

    if (saw_te && *has_len)
        riina_http_die("both Content-Length and Transfer-Encoding present (RFC 9112 6.1: request smuggling)");
    /* Chunked, or any transfer coding we do not implement: refuse rather than
       guess the body length. */
    if (saw_te)
        riina_http_die("chunked transfer coding is not supported (rejected, not mis-framed)");
}

typedef struct {
    char* method;
    size_t method_len;
    char* target;
    size_t target_len;
    riina_http_hdrs_t headers;
    char* body;
    size_t body_len;
} riina_http_msg_t;

static void riina_http_msg_free(riina_http_msg_t* m) {
    free(m->method);
    free(m->target);
    free(m->body);
    riina_http_hdrs_free(&m->headers);
    memset(m, 0, sizeof(*m));
}

static void riina_http_extract_body(const unsigned char* b, size_t n, size_t body_start,
                                    int has_len, uint64_t content_length,
                                    char** body, size_t* body_len) {
    if (!has_len) { *body = riina_http_dup("", 0); *body_len = 0; return; }
    if (content_length > (uint64_t)RIINA_HTTP_MAX_BODY)
        riina_http_die("body exceeds 8388608 bytes");
    size_t start = body_start < n ? body_start : n;
    size_t available = n - start;
    if (available < (size_t)content_length) riina_http_die("body shorter than Content-Length");
    *body_len = (size_t)content_length;
    *body = riina_http_dup((const char*)b + start, *body_len);
}

/* parse_request: the strict RFC 9112 request parser. */
static void riina_http_parse_request(const unsigned char* b, size_t n, riina_http_msg_t* out) {
    memset(out, 0, sizeof(*out));
    size_t body_start = 0;
    long head_len = riina_http_split_head(b, n, &body_start);
    if (head_len == -1) riina_http_die("incomplete message: no CRLFCRLF head terminator");
    if (head_len == -2) riina_http_die("head exceeds 65536 bytes");
    const char* head = (const char*)b;
    size_t hlen = (size_t)head_len;

    size_t sl = 0;
    while (sl + 1 < hlen && !(head[sl] == '\r' && head[sl+1] == '\n')) sl++;
    size_t start_len = (sl + 1 < hlen) ? sl : hlen;

    /* METHOD SP TARGET SP VERSION — exactly three space-separated fields. */
    const char* sp1 = (const char*)memchr(head, ' ', start_len);
    if (!sp1) riina_http_die("malformed start line");
    size_t mlen = (size_t)(sp1 - head);
    const char* rest = sp1 + 1;
    size_t rest_len = start_len - mlen - 1;
    const char* sp2 = (const char*)memchr(rest, ' ', rest_len);
    if (!sp2) riina_http_die("malformed start line");
    size_t tlen = (size_t)(sp2 - rest);
    const char* ver = sp2 + 1;
    size_t vlen = rest_len - tlen - 1;
    if (memchr(ver, ' ', vlen)) riina_http_die("malformed start line");
    if (mlen == 0 || tlen == 0) riina_http_die("malformed start line");
    for (size_t k = 0; k < mlen; k++) {
        char c = head[k];
        if (!((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')))
            riina_http_die("malformed start line");
    }
    int http11;
    if (vlen == 8 && memcmp(ver, "HTTP/1.1", 8) == 0) http11 = 1;
    else if (vlen == 8 && memcmp(ver, "HTTP/1.0", 8) == 0) http11 = 0;
    else riina_http_die("unsupported HTTP version (only HTTP/1.0 and HTTP/1.1)");

    out->method = riina_http_dup(head, mlen);
    out->method_len = mlen;
    out->target = riina_http_dup(rest, tlen);
    out->target_len = tlen;

    int has_len = 0;
    uint64_t content_length = 0;
    riina_http_parse_headers(head, hlen, 1, &out->headers, &has_len, &content_length);

    if (http11 && !riina_http_hdr_get(&out->headers, "host"))
        riina_http_die("HTTP/1.1 request without a Host header");

    riina_http_extract_body(b, n, body_start, has_len, content_length, &out->body, &out->body_len);
}

/* parse_response: the status-line counterpart. */
static void riina_http_parse_response(const unsigned char* b, size_t n, riina_http_msg_t* out) {
    memset(out, 0, sizeof(*out));
    size_t body_start = 0;
    long head_len = riina_http_split_head(b, n, &body_start);
    if (head_len == -1) riina_http_die("incomplete message: no CRLFCRLF head terminator");
    if (head_len == -2) riina_http_die("head exceeds 65536 bytes");
    const char* head = (const char*)b;
    size_t hlen = (size_t)head_len;

    size_t sl = 0;
    while (sl + 1 < hlen && !(head[sl] == '\r' && head[sl+1] == '\n')) sl++;
    size_t start_len = (sl + 1 < hlen) ? sl : hlen;

    const char* sp1 = (const char*)memchr(head, ' ', start_len);
    if (!sp1) riina_http_die("malformed start line");
    size_t vlen = (size_t)(sp1 - head);
    if (!(vlen == 8 && (memcmp(head, "HTTP/1.1", 8) == 0 || memcmp(head, "HTTP/1.0", 8) == 0)))
        riina_http_die("unsupported HTTP version (only HTTP/1.0 and HTTP/1.1)");
    const char* rest = sp1 + 1;
    size_t rest_len = start_len - vlen - 1;
    const char* sp2 = (const char*)memchr(rest, ' ', rest_len);
    size_t slen = sp2 ? (size_t)(sp2 - rest) : rest_len;
    if (slen == 0) riina_http_die("malformed start line");
    unsigned status = 0;
    for (size_t k = 0; k < slen; k++) {
        if (rest[k] < '0' || rest[k] > '9') riina_http_die("malformed start line");
        status = status * 10 + (unsigned)(rest[k] - '0');
        if (status > 100000) riina_http_die("malformed start line");
    }
    if (status < 100 || status > 599) riina_http_die("malformed start line");

    int has_len = 0;
    uint64_t content_length = 0;
    riina_http_parse_headers(head, hlen, 1, &out->headers, &has_len, &content_length);
    riina_http_extract_body(b, n, body_start, has_len, content_length, &out->body, &out->body_len);
}

/* message_length: 1 = complete, 0 = need more bytes. Same reasoning as the
   Rust codec, so both backends stop reading a response at the same byte. */
static int riina_http_message_complete(const unsigned char* b, size_t n) {
    size_t body_start = 0;
    long head_len = riina_http_split_head(b, n, &body_start);
    if (head_len == -1) return 0;
    if (head_len == -2) riina_http_die("head exceeds 65536 bytes");
    riina_http_hdrs_t hs;
    memset(&hs, 0, sizeof(hs));
    int has_len = 0;
    uint64_t content_length = 0;
    riina_http_parse_headers((const char*)b, (size_t)head_len, 1, &hs, &has_len, &content_length);
    riina_http_hdrs_free(&hs);
    uint64_t want = (uint64_t)body_start + (has_len ? content_length : 0);
    return (uint64_t)n >= want ? 1 : 0;
}

static const char* riina_http_reason_phrase(unsigned status) {
    switch (status) {
    case 200: return "OK";
    case 201: return "Created";
    case 204: return "No Content";
    case 301: return "Moved Permanently";
    case 302: return "Found";
    case 304: return "Not Modified";
    case 400: return "Bad Request";
    case 401: return "Unauthorized";
    case 403: return "Forbidden";
    case 404: return "Not Found";
    case 405: return "Method Not Allowed";
    case 408: return "Request Timeout";
    case 411: return "Length Required";
    case 413: return "Content Too Large";
    case 414: return "URI Too Long";
    case 429: return "Too Many Requests";
    case 500: return "Internal Server Error";
    case 501: return "Not Implemented";
    case 503: return "Service Unavailable";
    case 505: return "HTTP Version Not Supported";
    default:  return "Unknown";
    }
}

/* A CR, LF or NUL where it would be serialised is refused, so a RIINA program
   cannot emit a split response even passing attacker data straight through. */
static void riina_http_reject_control(const char* field, const char* v, size_t n) {
    for (size_t i = 0; i < n; i++) {
        if (v[i] == '\r' || v[i] == '\n' || v[i] == 0) {
            fprintf(stderr, "RIINA: http: control character (CR/LF/NUL) in \"%s\"\n", field);
            abort();
        }
    }
}

/* ── the http_* builtins ───────────────────────────────────────────────── */

static riina_value_t* riina_builtin_http_hurai_kaedah(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) riina_http_die("hurai_kaedah: expected a string");
    riina_http_msg_t m;
    riina_http_parse_request((const unsigned char*)arg->data.string_val.data,
                             arg->data.string_val.len, &m);
    riina_value_t* out = riina_net_string_lossy((const unsigned char*)m.method, m.method_len);
    riina_http_msg_free(&m);
    return out;
}

static riina_value_t* riina_builtin_http_hurai_laluan(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) riina_http_die("hurai_laluan: expected a string");
    riina_http_msg_t m;
    riina_http_parse_request((const unsigned char*)arg->data.string_val.data,
                             arg->data.string_val.len, &m);
    riina_value_t* out = riina_net_string_lossy((const unsigned char*)m.target, m.target_len);
    riina_http_msg_free(&m);
    return out;
}

static riina_value_t* riina_builtin_http_hurai_jasad(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) riina_http_die("hurai_jasad: expected a string");
    riina_http_msg_t m;
    riina_http_parse_request((const unsigned char*)arg->data.string_val.data,
                             arg->data.string_val.len, &m);
    riina_value_t* out = riina_net_string_lossy((const unsigned char*)m.body, m.body_len);
    riina_http_msg_free(&m);
    return out;
}

/* (request, field_name) -> value; an absent field yields "" so a RIINA program
   can branch without an option type. */
static riina_value_t* riina_builtin_http_hurai_kepala(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_http_die("hurai_kepala: expects (request, field)");
    riina_value_t* r = arg->data.pair_val.fst;
    riina_value_t* f = arg->data.pair_val.snd;
    if (r->tag != RIINA_TAG_STRING || f->tag != RIINA_TAG_STRING)
        riina_http_die("hurai_kepala: expects (request, field)");
    riina_http_msg_t m;
    riina_http_parse_request((const unsigned char*)r->data.string_val.data,
                             r->data.string_val.len, &m);
    char* field = riina_http_dup(f->data.string_val.data, f->data.string_val.len);
    for (size_t i = 0; field[i]; i++)
        if (field[i] >= 'A' && field[i] <= 'Z') field[i] = (char)(field[i] - 'A' + 'a');
    const riina_http_hdr_t* v = riina_http_hdr_get(&m.headers, field);
    riina_value_t* out = v ? riina_net_string_lossy((const unsigned char*)v->value, v->vlen)
                           : riina_string("");
    free(field);
    riina_http_msg_free(&m);
    return out;
}

/* http_balas (http_build_response): (status, body) -> wire bytes.
   Content-Length and Connection are COMPUTED, never caller-supplied, so a
   program cannot emit an ambiguous or split response. The single caller header
   is `content-type` — lowercase, because the codec's map key is, and the two
   backends must produce identical bytes. */
static riina_value_t* riina_builtin_http_balas(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_http_die("balas: expects (status, body)");
    riina_value_t* s = arg->data.pair_val.fst;
    riina_value_t* b = arg->data.pair_val.snd;
    if (s->tag != RIINA_TAG_INT) riina_http_die("balas: expected status int");
    if (b->tag != RIINA_TAG_STRING) riina_http_die("balas: expected a string body");
    if (s->data.int_val > 65535) riina_http_die("balas: status out of range");
    unsigned status = (unsigned)s->data.int_val;
    const char* reason = riina_http_reason_phrase(status);
    riina_http_reject_control("reason", reason, strlen(reason));

    riina_http_buf_t out;
    memset(&out, 0, sizeof(out));
    char line[128];
    snprintf(line, sizeof(line), "HTTP/1.1 %u %s\r\n", status, reason);
    riina_http_buf_str(&out, line);
    riina_http_buf_str(&out, "content-type: text/html; charset=utf-8\r\n");
    snprintf(line, sizeof(line), "Content-Length: %zu\r\nConnection: close\r\n\r\n",
             b->data.string_val.len);
    riina_http_buf_str(&out, line);
    riina_http_buf_push(&out, b->data.string_val.data, b->data.string_val.len);

    riina_value_t* v = riina_net_string_lossy((const unsigned char*)out.p, out.n);
    free(out.p);
    return v;
}

/* http_minta (http_request): (method, url) -> response body.
   A real one-shot request over the verified TCP machine. `https://` is
   REFUSED, loudly — there is no TLS record layer on this backend, and a silent
   downgrade to cleartext would be far worse than a refusal. */
static riina_value_t* riina_builtin_http_minta(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) riina_http_die("minta: expects (method, url)");
    riina_value_t* mv = arg->data.pair_val.fst;
    riina_value_t* uv = arg->data.pair_val.snd;
    if (mv->tag != RIINA_TAG_STRING || uv->tag != RIINA_TAG_STRING)
        riina_http_die("minta: expects (method, url)");
    const char* method = mv->data.string_val.data;
    const char* url = uv->data.string_val.data;

    if (strncmp(url, "https://", 8) == 0)
        riina_http_die("https is not supported (no TLS record layer yet - master plan REQ-73)");
    if (strncmp(url, "http://", 7) != 0) riina_http_die("not an http:// URL");
    const char* rest = url + 7;
    const char* slash = strchr(rest, '/');
    size_t alen = slash ? (size_t)(slash - rest) : strlen(rest);
    if (alen == 0) riina_http_die("empty host in URL");
    char* authority = riina_http_dup(rest, alen);
    const char* target = slash ? slash : "/";

    /* host:port for the connect, and the Host field value. RFC 9110 §7.2: the
       port belongs in Host unless it is the scheme default. */
    riina_http_buf_t hp;
    memset(&hp, 0, sizeof(hp));
    riina_http_buf_str(&hp, authority);
    if (!strchr(authority, ':')) riina_http_buf_str(&hp, ":80");
    size_t hlen = strlen(authority);
    if (hlen > 3 && strcmp(authority + hlen - 3, ":80") == 0) authority[hlen - 3] = 0;

    riina_http_reject_control("method", method, strlen(method));
    riina_http_reject_control("target", target, strlen(target));
    riina_http_reject_control("host", authority, strlen(authority));

    riina_http_buf_t wire;
    memset(&wire, 0, sizeof(wire));
    riina_http_buf_str(&wire, method);
    riina_http_buf_str(&wire, " ");
    riina_http_buf_str(&wire, target);
    riina_http_buf_str(&wire, " HTTP/1.1\r\nHost: ");
    riina_http_buf_str(&wire, authority);
    riina_http_buf_str(&wire, "\r\nContent-Length: 0\r\n\r\n");

    /* Verified machine: CLOSED --ActiveOpen--> SYN_SENT --SynAckReceived--> ESTABLISHED. */
    riina_tcp_state_t st = RIINA_TCP_CLOSED;
    int to = riina_tcp_next_state(st, RIINA_EV_ACTIVE_OPEN);
    if (to < 0) riina_http_die("internal state error");
    st = (riina_tcp_state_t)to;

    struct addrinfo* res = riina_net_resolve(hp.p, "minta");
    int fd = -1;
    for (struct addrinfo* ai = res; ai; ai = ai->ai_next) {
        fd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
        if (fd < 0) continue;
        if (connect(fd, ai->ai_addr, ai->ai_addrlen) == 0) break;
        close(fd);
        fd = -1;
    }
    int saved = errno;
    freeaddrinfo(res);
    if (fd < 0) { fprintf(stderr, "RIINA: http: connect %s: %s\n", hp.p, strerror(saved)); abort(); }
    to = riina_tcp_next_state(st, RIINA_EV_SYN_ACK_RECEIVED);
    if (to < 0) riina_http_die("internal state error");
    st = (riina_tcp_state_t)to;
    if (st != RIINA_TCP_ESTABLISHED) riina_http_die("connection not established");

    struct timeval tv;
    tv.tv_sec = 30;
    tv.tv_usec = 0;
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));

    const char* wp = wire.p;
    size_t left = wire.n;
    while (left > 0) {
        ssize_t w = send(fd, wp, left, 0);
        if (w < 0) {
            if (errno == EINTR) continue;
            fprintf(stderr, "RIINA: http: send: %s\n", strerror(errno));
            abort();
        }
        wp += (size_t)w;
        left -= (size_t)w;
    }

    riina_http_buf_t in;
    memset(&in, 0, sizeof(in));
    char chunk[4096];
    while (!riina_http_message_complete((const unsigned char*)(in.p ? in.p : ""), in.n)) {
        ssize_t got;
        do { got = recv(fd, chunk, sizeof(chunk), 0); } while (got < 0 && errno == EINTR);
        if (got < 0) { fprintf(stderr, "RIINA: http: recv: %s\n", strerror(errno)); abort(); }
        if (got == 0) break;   /* peer closed; parse what we have */
        riina_http_buf_push(&in, chunk, (size_t)got);
        if (in.n > (size_t)RIINA_HTTP_MAX_HEAD + (size_t)RIINA_HTTP_MAX_BODY)
            riina_http_die("response exceeds maximum size");
    }

    /* Verified active close. */
    to = riina_tcp_next_state(st, RIINA_EV_CLOSE);
    if (to < 0) riina_http_die("internal state error");
    close(fd);
    st = (riina_tcp_state_t)to;
    riina_tcp_event_t tail[3] = { RIINA_EV_ACK_RECEIVED, RIINA_EV_FIN_RECEIVED, RIINA_EV_TIMEOUT };
    for (int k = 0; k < 3; k++) {
        to = riina_tcp_next_state(st, tail[k]);
        if (to < 0) riina_http_die("internal state error");
        st = (riina_tcp_state_t)to;
    }

    riina_http_msg_t resp;
    riina_http_parse_response((const unsigned char*)(in.p ? in.p : ""), in.n, &resp);
    riina_value_t* out = riina_net_string_lossy((const unsigned char*)resp.body, resp.body_len);
    riina_http_msg_free(&resp);
    free(in.p);
    free(wire.p);
    free(hp.p);
    free(authority);
    return out;
}
"##;

/// C source for the in-memory verified virtual filesystem behind
/// `vfs_tulis` / `vfs_baca` / `vfs_padam` (REQ-70 family routing, Wave B.4).
///
/// ONE SPECIFICATION, TWO IMPLEMENTATIONS — the same shape as the file gate
/// above it and the `simpan` store below. The spec is Coq
/// `domains/VerifiedFileSystem.v` (`can_read`/`can_write`, the byte/inode
/// `Quota`); `riina-os/src/vfs.rs::VirtualFs` is the Rust implementation the
/// interpreter runs, and this is the C one. They cannot share code (the
/// compile pipeline is `cc -o out one.c`, nothing linked), so they are held
/// together by `vfs_differential.rs`, which runs the same programs on both and
/// compares every output AND every refusal.
///
/// Mirrored exactly, in order, from `VirtualFs::{create,write,read,delete}`
/// and `builtins/vfs.rs`:
///
/// * `vfs_tulis(path, data)`: a path not yet known is CREATED first — gated by
///   the inode quota (`can_allocate_inode` = `used_inodes < limit_inodes`),
///   owned by the current uid/gid at mode 0644 (owner rw, group r, other r),
///   charging one inode. Then `can_write` for the current context, then the
///   byte quota on GROWTH ONLY (`can_allocate_bytes(new - old)`, checked
///   against overflow as Rust's `checked_add` is), shrinking refunds.
/// * `vfs_baca(path)`: `not found`, then `can_read`, then the bytes.
/// * `vfs_padam(path)`: `not found`, then `can_write`, then the inode's bytes
///   and its inode are released. Returns `betul`.
/// * `vfs_mula(limit_bytes)`: the byte quota; `limit_inodes` is the
///   interpreter's `DEFAULT_INODE_LIMIT` (4096). Before `vfs_mula` the byte
///   limit is `u64::MAX`, as in the interpreter's thread-local default.
///
/// The three refusals carry the interpreter's exact wording — `vfs: not
/// found`, `vfs: permission denied`, `vfs: quota exceeded` — and exit
/// non-zero. A refused operation must not be able to fall through and touch
/// the table; every `die` is before the mutation.
///
/// Byte counts are the string's byte length (`string_val.len`), not
/// `strlen`, so a string carrying an interior NUL is charged as the
/// interpreter charges `data.as_bytes().len()`.
///
/// Separate from the host-FS gate's `riina_inodes`: in the interpreter the
/// `fail_*` gate (`builtins/fail.rs::HostGate`) and the `vfs_*` store
/// (`builtins/vfs.rs::VfsState`) are two tables sharing ONE access context,
/// and that is reproduced here — `riina_ctx_uid/gid/is_root` are shared,
/// the tables are not.
const VFS_RUNTIME_C: &str = r##"
/* ── Verified in-memory virtual filesystem (vfs_tulis / vfs_baca / vfs_padam) ─
 *
 * The C half of `riina-os::vfs::VirtualFs`, gated by the Coq-modelled
 * can_read / can_write predicates and the byte/inode Quota. Every check
 * precedes every mutation; a refusal exits with the interpreter's wording.
 */
typedef struct riina_vfs_node_s {
    char* path;
    uint64_t owner_uid;
    uint64_t owner_gid;
    riina_perm_t perm_owner;
    riina_perm_t perm_group;
    riina_perm_t perm_other;
    char* data;               /* exactly `size` bytes, plus a NUL for riina_string */
    uint64_t size;
    struct riina_vfs_node_s* next;
} riina_vfs_node_t;

#define RIINA_VFS_DEFAULT_INODE_LIMIT 4096ULL

static riina_vfs_node_t* riina_vfs_nodes = NULL;
static uint64_t riina_vfs_limit_bytes = UINT64_MAX;   /* interpreter default before vfs_mula */
static uint64_t riina_vfs_limit_inodes = RIINA_VFS_DEFAULT_INODE_LIMIT;
static uint64_t riina_vfs_used_bytes = 0;
static uint64_t riina_vfs_used_inodes = 0;

/* The interpreter surfaces VfsError as `Runtime Error: vfs: <reason>`. */
static void riina_vfs_die(const char* reason) {
    fprintf(stderr, "Runtime Error: vfs: %s\n", reason);
    exit(1);
}

static riina_vfs_node_t* riina_vfs_find(const char* path) {
    for (riina_vfs_node_t* n = riina_vfs_nodes; n; n = n->next) {
        if (strcmp(n->path, path) == 0) return n;
    }
    return NULL;
}

/* Coq get_permission: owner > group > other, against the SHARED context. */
static riina_perm_t riina_vfs_permission_for(const riina_vfs_node_t* n) {
    if (n->owner_uid == riina_ctx_uid) return n->perm_owner;
    if (n->owner_gid == riina_ctx_gid) return n->perm_group;
    return n->perm_other;
}

static bool riina_vfs_can_read(const riina_vfs_node_t* n) {
    return riina_ctx_is_root || riina_vfs_permission_for(n).read;
}

static bool riina_vfs_can_write(const riina_vfs_node_t* n) {
    return riina_ctx_is_root || riina_vfs_permission_for(n).write;
}

/* Quota::can_allocate_bytes — used + n <= limit, with the overflow guard
   Rust's checked_add gives (an overflowing sum is NOT "within quota"). */
static bool riina_vfs_can_allocate_bytes(uint64_t n) {
    if (riina_vfs_used_bytes > UINT64_MAX - n) return false;
    return riina_vfs_used_bytes + n <= riina_vfs_limit_bytes;
}

/* Quota::can_allocate_inode — strictly below the limit. */
static bool riina_vfs_can_allocate_inode(void) {
    return riina_vfs_used_inodes < riina_vfs_limit_inodes;
}

static void riina_vfs_reset(uint64_t limit_bytes) {
    while (riina_vfs_nodes) {
        riina_vfs_node_t* dead = riina_vfs_nodes;
        riina_vfs_nodes = dead->next;
        free(dead->path);
        free(dead->data);
        free(dead);
    }
    riina_vfs_limit_bytes = limit_bytes;
    riina_vfs_limit_inodes = RIINA_VFS_DEFAULT_INODE_LIMIT;
    riina_vfs_used_bytes = 0;
    riina_vfs_used_inodes = 0;
}

/* vfs_tulis (vfs_write): (Teks, Teks) -> () */
static riina_value_t* riina_builtin_vfs_tulis(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_PAIR) abort();
    riina_value_t* p = arg->data.pair_val.fst;
    riina_value_t* d = arg->data.pair_val.snd;
    if (p->tag != RIINA_TAG_STRING || d->tag != RIINA_TAG_STRING) abort();
    const char* path = p->data.string_val.data;
    riina_vfs_node_t* n = riina_vfs_find(path);
    if (!n) {
        /* VirtualFs::create — inode quota first, then first-touch ownership
           at mode 0644 by the current context. */
        if (!riina_vfs_can_allocate_inode()) riina_vfs_die("quota exceeded");
        n = (riina_vfs_node_t*)malloc(sizeof(riina_vfs_node_t));
        if (!n) abort();
        n->path = strdup(path);
        if (!n->path) abort();
        n->owner_uid = riina_ctx_uid;
        n->owner_gid = riina_ctx_gid;
        n->perm_owner = (riina_perm_t){ true, true, false };
        n->perm_group = (riina_perm_t){ true, false, false };
        n->perm_other = (riina_perm_t){ true, false, false };
        n->data = NULL;
        n->size = 0;
        n->next = riina_vfs_nodes;
        riina_vfs_nodes = n;
        riina_vfs_used_inodes += 1;
    }
    /* VirtualFs::write — can_write, then the byte quota on growth only. */
    if (!riina_vfs_can_write(n)) riina_vfs_die("permission denied");
    uint64_t old_len = n->size;
    uint64_t new_len = (uint64_t)d->data.string_val.len;
    if (new_len > old_len) {
        if (!riina_vfs_can_allocate_bytes(new_len - old_len)) riina_vfs_die("quota exceeded");
        riina_vfs_used_bytes += new_len - old_len;
    } else {
        riina_vfs_used_bytes -= old_len - new_len;
    }
    char* copy = (char*)malloc((size_t)new_len + 1);
    if (!copy) abort();
    memcpy(copy, d->data.string_val.data, (size_t)new_len);
    copy[new_len] = '\0';
    free(n->data);
    n->data = copy;
    n->size = new_len;
    return riina_unit();
}

/* vfs_baca (vfs_read): Teks -> Teks */
static riina_value_t* riina_builtin_vfs_baca(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    riina_vfs_node_t* n = riina_vfs_find(arg->data.string_val.data);
    if (!n) riina_vfs_die("not found");
    if (!riina_vfs_can_read(n)) riina_vfs_die("permission denied");
    riina_value_t* v = riina_alloc();
    v->tag = RIINA_TAG_STRING;
    v->security = RIINA_LEVEL_PUBLIC;
    v->data.string_val.data = (char*)malloc((size_t)n->size + 1);
    if (!v->data.string_val.data) abort();
    if (n->size) memcpy(v->data.string_val.data, n->data, (size_t)n->size);
    v->data.string_val.data[n->size] = '\0';
    v->data.string_val.len = (size_t)n->size;
    return v;
}

/* vfs_padam (vfs_delete): Teks -> Benar */
static riina_value_t* riina_builtin_vfs_padam(riina_value_t* arg) {
    if (arg->tag != RIINA_TAG_STRING) abort();
    const char* path = arg->data.string_val.data;
    riina_vfs_node_t** slot = &riina_vfs_nodes;
    while (*slot && strcmp((*slot)->path, path) != 0) slot = &(*slot)->next;
    if (!*slot) riina_vfs_die("not found");
    if (!riina_vfs_can_write(*slot)) riina_vfs_die("permission denied");
    riina_vfs_node_t* dead = *slot;
    *slot = dead->next;
    riina_vfs_used_bytes -= dead->size;
    riina_vfs_used_inodes -= 1;
    free(dead->path);
    free(dead->data);
    free(dead);
    return riina_bool(true);
}
"##;

#[cfg(test)]
mod tests {
    use super::*;
    use crate::lower::Lower;
    use riina_types::{Effect, Expr, SecurityLevel, Ty};

    fn compile_and_emit(expr: &Expr) -> Result<String> {
        let mut lower = Lower::new();
        let program = lower.compile(expr)?;
        emit_c(&program)
    }

    #[test]
    fn test_emit_unit() {
        let code = compile_and_emit(&Expr::Unit).unwrap();
        assert!(code.contains("riina_unit()"));
        assert!(code.contains("int main(void)"));
    }

    #[test]
    fn numeric_tower_sized_arithmetic_emits_width_mask() {
        // `200u8 + 100u8` types as u8, so the C emit wraps the result to 8 bits
        // (`riina_trunc(..., 8)`) — compiled overflow then matches the interpreter.
        let expr = Expr::BinOp(
            riina_types::BinOp::Add,
            Box::new(Expr::IntN {
                value: 200,
                bits: 8,
                signed: false,
            }),
            Box::new(Expr::IntN {
                value: 100,
                bits: 8,
                signed: false,
            }),
        );
        let code = compile_and_emit(&expr).unwrap();
        assert!(
            code.contains("static riina_value_t* riina_trunc"),
            "the width-truncation runtime helper must be emitted"
        );
        assert!(
            code.contains("riina_trunc(riina_binop_add("),
            "the u8 addition must be width-masked:\n{code}"
        );
        assert!(
            code.contains(", 8, 0)"),
            "the 8-bit unsigned width (bits=8, signed=0) must appear in the mask"
        );
    }

    #[test]
    fn bigint_emits_runtime_and_dispatches_binop() {
        // `besar("123") * besar("456")` must emit the bignum runtime, call the
        // `besar` constructor, and route the multiply through the BigInt path.
        let mk = |s: &str| {
            Expr::App(
                Box::new(Expr::Var("besar".to_string())),
                Box::new(Expr::String(s.to_string())),
            )
        };
        let expr = Expr::BinOp(
            riina_types::BinOp::Mul,
            Box::new(mk("123")),
            Box::new(mk("456")),
        );
        let code = compile_and_emit(&expr).unwrap();
        assert!(code.contains("RIINA_TAG_BIGINT"), "BigInt tag must be emitted");
        assert!(
            code.contains("static char* riina_bigint_to_str"),
            "the C bignum runtime must be emitted"
        );
        assert!(
            code.contains("riina_builtin_besar"),
            "the besar constructor must be emitted and called:\n{code}"
        );
        assert!(
            code.contains(
                "a->tag == RIINA_TAG_BIGINT && b->tag == RIINA_TAG_BIGINT) return riina_bigint_mul"
            ),
            "the multiply binop must dispatch the BigInt path"
        );
    }

    #[test]
    fn decimal_emits_runtime_and_dispatches_binop() {
        // `perpuluhan("0.1") + perpuluhan("0.2")` must emit the decimal runtime,
        // call the `perpuluhan` constructor, and route the add through the
        // Decimal path (value-based, built on the bignum runtime).
        let mk = |s: &str| {
            Expr::App(
                Box::new(Expr::Var("perpuluhan".to_string())),
                Box::new(Expr::String(s.to_string())),
            )
        };
        let expr = Expr::BinOp(
            riina_types::BinOp::Add,
            Box::new(mk("0.1")),
            Box::new(mk("0.2")),
        );
        let code = compile_and_emit(&expr).unwrap();
        assert!(
            code.contains("RIINA_TAG_DECIMAL"),
            "Decimal tag must be emitted"
        );
        assert!(
            code.contains("static char* riina_decimal_to_str"),
            "the C decimal runtime must be emitted"
        );
        assert!(
            code.contains("riina_builtin_perpuluhan"),
            "the perpuluhan constructor must be emitted and called:\n{code}"
        );
        assert!(
            code.contains(
                "a->tag == RIINA_TAG_DECIMAL && b->tag == RIINA_TAG_DECIMAL) return riina_decimal_add"
            ),
            "the add binop must dispatch the Decimal path"
        );
    }

    #[test]
    fn fixed_point_emits_runtimes_and_dispatches_binops() {
        // `wang("19.99") * wang("3")` and `qmn(("0.5", 8)) + qmn(("0.25", 8))`
        // must emit the Fixed + FixedBin runtimes, call the constructors, and
        // route the binops through the fixed-point dispatch paths.
        let wang = |s: &str| {
            Expr::App(
                Box::new(Expr::Var("wang".to_string())),
                Box::new(Expr::String(s.to_string())),
            )
        };
        let qmn = |s: &str| {
            Expr::App(
                Box::new(Expr::Var("qmn".to_string())),
                Box::new(Expr::Pair(
                    Box::new(Expr::String(s.to_string())),
                    Box::new(Expr::Int(8)),
                )),
            )
        };
        let expr = Expr::BinOp(
            riina_types::BinOp::Add,
            Box::new(Expr::BinOp(
                riina_types::BinOp::Mul,
                Box::new(wang("19.99")),
                Box::new(wang("3")),
            )),
            Box::new(wang("0")),
        );
        let code = compile_and_emit(&expr).unwrap();
        assert!(code.contains("RIINA_TAG_FIXED"), "Fixed tag must be emitted");
        assert!(
            code.contains("static char* riina_fixed_to_str"),
            "the C Fixed runtime must be emitted"
        );
        assert!(
            code.contains("riina_builtin_wang"),
            "the wang constructor must be emitted and called"
        );
        assert!(
            code.contains(
                "a->tag == RIINA_TAG_FIXED && b->tag == RIINA_TAG_FIXED) return riina_fixed_mul"
            ),
            "the multiply binop must dispatch the Fixed path"
        );
        // The FixedBin (qmn) runtime is also emitted, with its constructor.
        let qexpr = Expr::BinOp(
            riina_types::BinOp::Add,
            Box::new(qmn("0.5")),
            Box::new(qmn("0.25")),
        );
        let qcode = compile_and_emit(&qexpr).unwrap();
        assert!(qcode.contains("RIINA_TAG_FIXEDBIN"), "FixedBin tag must be emitted");
        assert!(
            qcode.contains("static char* riina_fixedbin_to_str"),
            "the C FixedBin runtime must be emitted"
        );
        assert!(
            qcode.contains("riina_builtin_qmn"),
            "the qmn constructor must be emitted and called"
        );
        assert!(
            qcode.contains(
                "a->tag == RIINA_TAG_FIXEDBIN && b->tag == RIINA_TAG_FIXEDBIN) return riina_fixedbin_add"
            ),
            "the add binop must dispatch the FixedBin path"
        );
    }

    #[test]
    fn numeric_tower_unsized_arithmetic_is_not_masked() {
        // Plain `Int` arithmetic is unaffected — no truncation call is emitted.
        let expr = Expr::BinOp(
            riina_types::BinOp::Add,
            Box::new(Expr::Int(200)),
            Box::new(Expr::Int(100)),
        );
        let code = compile_and_emit(&expr).unwrap();
        assert!(
            !code.contains("riina_trunc(riina_binop_add("),
            "plain Int addition must not be width-masked"
        );
    }

    #[test]
    fn numeric_tower_signed_arithmetic_tags_and_emits_helpers() {
        // `0i8 - 5i8` types as signed i8, so the result is wrapped *and tagged*
        // signed (`riina_trunc(.., 8, 1)`), and the signed runtime helpers exist.
        let s8 = |value| {
            Box::new(Expr::IntN {
                value,
                bits: 8,
                signed: true,
            })
        };
        let expr = Expr::BinOp(riina_types::BinOp::Sub, s8(0), s8(5));
        let code = compile_and_emit(&expr).unwrap();
        assert!(
            code.contains("riina_trunc(riina_binop_sub(") && code.contains(", 8, 1)"),
            "signed i8 subtraction must be tagged signed (bits=8, signed=1):\n{code}"
        );
        // The signed runtime path is emitted: sign extension + signed display.
        assert!(code.contains("int_signed_bits"), "value carries a signed-width tag");
        assert!(code.contains("riina_sext"), "sign-extension helper emitted");
        assert!(code.contains("%lld"), "signed values format with %lld");
    }

    #[test]
    fn test_emit_bool() {
        let code = compile_and_emit(&Expr::Bool(true)).unwrap();
        assert!(code.contains("riina_bool(true)"));
    }

    #[test]
    fn test_emit_int() {
        let code = compile_and_emit(&Expr::Int(42)).unwrap();
        assert!(code.contains("riina_int(42ULL)"));
    }

    #[test]
    fn test_emit_string() {
        let code = compile_and_emit(&Expr::String("hello".to_string())).unwrap();
        assert!(code.contains("riina_string(\"hello\")"));
    }

    #[test]
    fn test_emit_pair() {
        let pair = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        let code = compile_and_emit(&pair).unwrap();
        assert!(code.contains("riina_pair"));
    }

    #[test]
    fn test_emit_if() {
        let if_expr = Expr::If(
            Box::new(Expr::Bool(true)),
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        );
        let code = compile_and_emit(&if_expr).unwrap();
        assert!(code.contains("if ("));
        assert!(code.contains("goto"));
    }

    #[test]
    fn test_emit_let() {
        let let_expr = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(42)),
            Box::new(Expr::Var("x".to_string())),
        );
        let code = compile_and_emit(&let_expr).unwrap();
        assert!(code.contains("riina_int(42ULL)"));
    }

    #[test]
    fn test_emit_classify() {
        let classify = Expr::Classify(Box::new(Expr::Int(42)));
        let code = compile_and_emit(&classify).unwrap();
        assert!(code.contains("riina_classify"));
    }

    #[test]
    fn test_emit_runtime_prelude() {
        let code = compile_and_emit(&Expr::Unit).unwrap();
        // Check runtime prelude is included
        assert!(code.contains("typedef enum"));
        assert!(code.contains("RIINA_TAG_UNIT"));
        assert!(code.contains("riina_security_level_t"));
        assert!(code.contains("riina_effect_t"));
        assert!(code.contains("struct riina_value"));
    }

    #[test]
    fn test_emit_security_checks() {
        let code = compile_and_emit(&Expr::Unit).unwrap();
        assert!(code.contains("riina_require_cap"));
        assert!(code.contains("riina_grant_cap"));
    }

    #[test]
    fn test_emit_complete_program() {
        let expr = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(10)),
            Box::new(Expr::Let(
                "y".to_string(),
                None,
                Box::new(Expr::Int(20)),
                Box::new(Expr::Pair(
                    Box::new(Expr::Var("x".to_string())),
                    Box::new(Expr::Var("y".to_string())),
                )),
            )),
        );
        let code = compile_and_emit(&expr).unwrap();

        // Verify complete C program structure
        assert!(code.contains("#include <stdint.h>"));
        assert!(code.contains("int main(void)"));
        assert!(code.contains("return 0;"));
    }

    #[test]
    fn test_emit_lambda() {
        let lam = Expr::Lam(
            "x".to_string(),
            riina_types::Ty::Int,
            Box::new(Expr::Var("x".to_string())),
        );
        let code = compile_and_emit(&lam).unwrap();
        assert!(code.contains("RIINA_TAG_CLOSURE"));
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL EMIT TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_emit_bool_false() {
        let code = compile_and_emit(&Expr::Bool(false)).unwrap();
        assert!(code.contains("riina_bool(false)"));
    }

    #[test]
    fn test_emit_int_large() {
        let code = compile_and_emit(&Expr::Int(100)).unwrap();
        // Large numbers are handled correctly
        assert!(code.contains("int main(void)"));
    }

    #[test]
    fn test_emit_inl() {
        let inl = Expr::Inl(Box::new(Expr::Int(42)), Ty::Bool);
        let code = compile_and_emit(&inl).unwrap();
        assert!(code.contains("riina_inl"));
    }

    #[test]
    fn test_emit_inr() {
        let inr = Expr::Inr(Box::new(Expr::Bool(true)), Ty::Int);
        let code = compile_and_emit(&inr).unwrap();
        assert!(code.contains("riina_inr"));
    }

    #[test]
    fn test_emit_fst() {
        let fst = Expr::Fst(Box::new(Expr::Pair(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        )));
        let code = compile_and_emit(&fst).unwrap();
        assert!(code.contains("riina_fst"));
    }

    #[test]
    fn test_emit_snd() {
        let snd = Expr::Snd(Box::new(Expr::Pair(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        )));
        let code = compile_and_emit(&snd).unwrap();
        assert!(code.contains("riina_snd"));
    }

    #[test]
    fn test_emit_declassify() {
        // Declassify takes two arguments: secret value and proof
        let classified = Box::new(Expr::Classify(Box::new(Expr::Int(42))));
        let proof = Box::new(Expr::Prove(Box::new(Expr::Bool(true))));
        let declassify = Expr::Declassify(classified, proof);
        let code = compile_and_emit(&declassify).unwrap();
        assert!(code.contains("riina_declassify"));
        assert!(code.contains("invalid declassification proof"));
        assert!(code.contains("riina_value_eq"));
    }

    #[test]
    fn test_emit_prove() {
        let prove = Expr::Prove(Box::new(Expr::Bool(true)));
        let code = compile_and_emit(&prove).unwrap();
        assert!(code.contains("riina_prove"));
    }

    #[test]
    fn test_emit_require() {
        // Require takes Effect and body expression
        let require = Expr::Require(Effect::Read, Box::new(Expr::Unit));
        let code = compile_and_emit(&require).unwrap();
        assert!(code.contains("riina_require"));
    }

    #[test]
    fn test_emit_ref() {
        let ref_expr = Expr::Ref(Box::new(Expr::Int(42)), SecurityLevel::Public);
        let code = compile_and_emit(&ref_expr).unwrap();
        assert!(code.contains("riina_alloc"));
    }

    #[test]
    fn test_emit_deref() {
        let deref = Expr::Deref(Box::new(Expr::Ref(
            Box::new(Expr::Int(42)),
            SecurityLevel::Public,
        )));
        let code = compile_and_emit(&deref).unwrap();
        assert!(code.contains("riina_load"));
    }

    #[test]
    fn test_emit_nested_pairs() {
        let nested = Expr::Pair(
            Box::new(Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)))),
            Box::new(Expr::Int(3)),
        );
        let code = compile_and_emit(&nested).unwrap();
        // Should have multiple riina_pair calls
        let pair_count = code.matches("riina_pair").count();
        assert!(pair_count >= 2);
    }

    #[test]
    fn test_emit_content_hash() {
        let expr = Expr::ContentHash(Box::new(Expr::Int(42)));
        let code = compile_and_emit(&expr).unwrap();
        assert!(code.contains("riina_content_hash"));
    }

    #[test]
    fn test_emit_content_hash_fnv_constants() {
        let expr = Expr::ContentHash(Box::new(Expr::Int(1)));
        let code = compile_and_emit(&expr).unwrap();
        assert!(
            code.contains("14695981039346656037"),
            "FNV offset basis missing"
        );
        assert!(code.contains("1099511628211"), "FNV prime missing");
    }

    #[test]
    fn test_emit_crdt_merge_present() {
        let expr = Expr::CRDTMerge(Box::new(Expr::Int(5)), Box::new(Expr::Int(8)));
        let code = compile_and_emit(&expr).unwrap();
        assert!(code.contains("riina_crdt_merge"));
    }

    #[test]
    fn test_emit_crdt_merge_int_max() {
        let expr = Expr::CRDTMerge(Box::new(Expr::Int(5)), Box::new(Expr::Int(8)));
        let code = compile_and_emit(&expr).unwrap();
        assert!(
            code.contains("int_val > b->data.int_val"),
            "GCounter max logic missing"
        );
    }

    #[test]
    fn test_emit_ui_display_html() {
        let expr = Expr::UIDisplay(vec![Expr::UIText(
            Box::new(Expr::String("hello".into())),
            Box::new(Expr::UIColor(255, 255, 255)),
        )]);
        let code = compile_and_emit(&expr).unwrap();
        assert!(code.contains("<div style='display:flex;flex-direction:column'>"));
        assert!(code.contains("<span style='color:"));
        assert!(code.contains("#ffffff"));
        assert!(code.contains("</span>"));
    }

    #[test]
    fn test_emit_ui_main_prints_raw_markup() {
        let expr = Expr::UIButton(Box::new(Expr::String("Click".into())), Box::new(Expr::Unit));
        let code = compile_and_emit(&expr).unwrap();
        assert!(code.contains("printf(\"%s\\n\", result->data.string_val.data);"));
        assert!(!code.contains("printf(\"\\\"%s\\\"\\n\", result->data.string_val.data);"));
    }

    // ═══════════════════════════════════════════════════════════════════
    // ACTOR RUNTIME (PTHREAD) TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_emit_actor_pthread_include() {
        let actor = Expr::ActorDecl {
            name: "Counter".to_string(),
            state_ty: Ty::Int,
            message_ty: Ty::Int,
            init_state: Box::new(Expr::Int(0)),
            handler: Box::new(Expr::Lam(
                "msg".to_string(),
                Ty::Int,
                Box::new(Expr::Var("msg".to_string())),
            )),
        };
        let code = compile_and_emit(&actor).unwrap();
        assert!(code.contains("#include <pthread.h>"));
    }

    #[test]
    fn test_emit_actor_struct_definition() {
        let code = compile_and_emit(&Expr::Unit).unwrap();
        assert!(code.contains("riina_actor_t"));
        assert!(code.contains("pthread_mutex_t"));
        assert!(code.contains("pthread_cond_t"));
        assert!(code.contains("RIINA_ACTOR_MAILBOX_SIZE"));
    }

    #[test]
    fn test_emit_actor_spawn() {
        let decl = Expr::ActorDecl {
            name: "Counter".to_string(),
            state_ty: Ty::Int,
            message_ty: Ty::Int,
            init_state: Box::new(Expr::Int(0)),
            handler: Box::new(Expr::Lam(
                "msg".to_string(),
                Ty::Int,
                Box::new(Expr::Var("msg".to_string())),
            )),
        };
        let spawn = Expr::Spawn(Box::new(decl), Box::new(Expr::Int(0)));
        let code = compile_and_emit(&spawn).unwrap();
        assert!(code.contains("riina_actor_spawn"));
        assert!(code.contains("pthread_mutex_init"));
        assert!(code.contains("pthread_cond_init"));
    }

    #[test]
    fn test_emit_actor_send_mailbox() {
        let code = compile_and_emit(&Expr::Unit).unwrap();
        assert!(code.contains("riina_actor_send"));
        assert!(code.contains("pthread_mutex_lock"));
        assert!(code.contains("mailbox_tail"));
        assert!(code.contains("pthread_cond_signal"));
        assert!(code.contains("pthread_mutex_unlock"));
    }

    #[test]
    fn test_emit_actor_recv_returns_state() {
        let code = compile_and_emit(&Expr::Unit).unwrap();
        assert!(code.contains("riina_actor_recv"));
        assert!(code.contains("actor->state"));
    }

    #[test]
    fn test_emit_actor_decl_stores_type() {
        let code = compile_and_emit(&Expr::Unit).unwrap();
        assert!(code.contains("riina_actor_decl"));
        assert!(code.contains("riina_actor_types"));
        assert!(code.contains("riina_next_actor_type_id"));
    }
}
