// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Security builtins (keselamatan) — the runtime side of the taint→sink discipline.
//!
//! These are the interpreter implementations for the ~84 security builtins that
//! `riina-typechecker` types for the taint→sanitize→sink enforcement (the
//! `*_injection_impossible` family proven in Coq `domains/TaintSystemCorrectness.v`
//! and `domains/CSRFProtection.v`). The *type system* already guarantees, at
//! compile time, that only a `Sanitized<_, k>` value can reach a `k`-sink — that
//! is what the proofs are about. Until now those builtins had **no runtime
//! implementation**, so any program that actually *ran* one crashed the
//! interpreter with `unknown builtin`. This module closes that runtime gap so the
//! full pipeline (read untrusted → sanitize → sink) executes end-to-end.
//!
//! Runtime representation of taint. `Tainted<String, src>` and
//! `Sanitized<String, k>` are **type-level** wrappers; they carry no runtime
//! tag (cf. `Value` — there is a `Value::Secret` for IFC, but no taint variant).
//! At runtime every one of these values is simply a `Value::String`. So a
//! sanitizer is a `String -> String` transform at runtime; the `Tainted ->
//! Sanitized` change is purely in the types. Sinks receive the already-sanitized
//! `String`.
//!
//! What is REAL vs MODELLED (no overclaiming — Prime Directive 2):
//!   * Sanitizers (`sanitize_*`/`sanitasi_*`), validators (`validate_*`/`sahkan_*`,
//!     `strip_nulls`, `normalize_unicode`), CSRF (`csrf_*`), and the safe-file ops
//!     (`file_*_safe`) perform **real** work — standards-based escaping, real
//!     validation, real filesystem access (the latter mirroring the `fail`
//!     module). `json_parse_safe`/`deserialize_safe` delegate to the real JSON
//!     parser in `builtins::json`.
//!   * The effectful sinks that require an external system with no backing in a
//!     hermetic reference interpreter — SQL/LDAP/XML query sinks, shell exec,
//!     DOM mutation, email send, and the HTTP request methods — are **modelled**:
//!     they do not touch a database, spawn a process, open a socket, or send
//!     mail. Each returns the most informative pure result (the executed payload
//!     echoed back, a success flag, or unit) so a program can still observe the
//!     pipeline running. This is called out per-function below. `shell_exec` in
//!     particular deliberately NEVER spawns a process.
//!
//! Bilingual names (Bahasa Melayu + English) map to one canonical dispatch key.

use crate::value::Value;
use crate::{Error, Result};

/// (BM name, EN name, canonical dispatch key). Both surface names resolve to the
/// canonical key in `register_builtins`; `apply` matches the canonical key.
pub static BUILTINS: &[(&str, &str, &str)] = &[
    // ── Sanitizers: Tainted<String> → Sanitized<String, k> (runtime: String → String) ──
    ("sanitasi_html", "sanitize_html", "sanitize_html"),
    ("sanitasi_sql", "sanitize_sql", "sanitize_sql"),
    ("sanitasi_js", "sanitize_js", "sanitize_js"),
    ("sanitasi_css", "sanitize_css", "sanitize_css"),
    ("sanitasi_url", "sanitize_url", "sanitize_url"),
    ("sanitasi_laluan", "sanitize_path", "sanitize_path"),
    ("sanitasi_perintah", "sanitize_command", "sanitize_command"),
    ("sanitasi_ldap", "sanitize_ldap", "sanitize_ldap"),
    ("sanitasi_xml", "sanitize_xml", "sanitize_xml"),
    ("sanitasi_json", "sanitize_json", "sanitize_json"),
    ("sanitasi_emel", "sanitize_email", "sanitize_email"),
    // ── Validators / transformers ──
    ("sahkan_url", "validate_url", "validate_url"),
    ("normal_unicode", "normalize_unicode", "normalize_unicode"),
    ("buang_null", "strip_nulls", "strip_nulls"),
    ("sahkan_panjang", "validate_length", "validate_length"),
    // ── Sinks (modelled effect; require Sanitized<_, k> at the type level) ──
    ("sql_laksana", "sql_execute", "sql_execute"),
    ("html_papar", "html_render", "html_render"),
    ("js_nilai", "js_eval", "js_eval"),
    ("shell_laksana", "shell_exec", "shell_exec"),
    ("ldap_cari", "ldap_search", "ldap_search"),
    ("xml_cari", "xml_query", "xml_query"),
    ("dom_tetap_html", "dom_set_html", "dom_set_html"),
    ("dom_tetap_atribut", "dom_set_attr", "dom_set_attr"),
    ("emel_hantar", "email_send", "email_send"),
    ("emel_tetap_kepala", "email_set_header", "email_set_header"),
    ("http_arah_selamat", "http_redirect_safe", "http_redirect_safe"),
    // ── HTTP (modelled — no network I/O) ──
    ("http_dapat", "http_get", "http_get"),
    ("http_hantar", "http_post", "http_post"),
    ("http_kemaskini", "http_put", "http_put"),
    ("http_padam", "http_delete", "http_delete"),
    ("badan_http", "http_body", "http_body"),
    ("http_ambil_selamat", "http_fetch_safe", "http_fetch_safe"),
    // ── CSRF protection ──
    ("csrf_jana", "csrf_generate", "csrf_generate"),
    ("csrf_sahkan", "csrf_validate", "csrf_validate"),
    ("csrf_semak_origin", "csrf_check_origin", "csrf_check_origin"),
    ("csrf_semak_referer", "csrf_check_referer", "csrf_check_referer"),
    // ── Safe file I/O (real filesystem; path is Sanitized<_, PathTraversal>) ──
    ("fail_baca_selamat", "file_read_safe", "file_read_safe"),
    ("fail_tulis_selamat", "file_write_safe", "file_write_safe"),
    ("fail_buang_selamat", "file_delete_safe", "file_delete_safe"),
    // ── Safe parsers ──
    ("json_urai_selamat", "json_parse_safe", "json_parse_safe"),
    ("xml_urai_selamat", "xml_parse_safe", "xml_parse_safe"),
    ("nyahsiri_selamat", "deserialize_safe", "deserialize_safe"),
];

/// A modelled-HTTP success response. The reference interpreter performs no
/// network I/O; every HTTP method returns this status line, and `http_body`
/// echoes the response back as its (network-tainted) body.
const MODELLED_HTTP_RESPONSE: &str = "200 OK";

/// Apply a security builtin. `Ok(None)` ⇒ the name is not ours (dispatch falls
/// through). A two-argument (pair) builtin given a single value returns a
/// `BuiltinPartial`, matching the currying convention in `interp.rs` (so a
/// surface call `f(a, b)` — which parses as `App(App(f, a), b)` — forms the
/// `(a, b)` pair on the second application).
#[allow(clippy::too_many_lines)]
pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    let result = match name {
        // ── Sanitizers (String → String) ──
        "sanitize_html" => Value::String(html_escape(&as_str(arg, name)?)),
        "sanitize_xml" => Value::String(xml_escape(&as_str(arg, name)?)),
        "sanitize_sql" => Value::String(sql_escape(&as_str(arg, name)?)),
        "sanitize_js" => Value::String(js_escape(&as_str(arg, name)?)),
        "sanitize_css" => Value::String(css_escape(&as_str(arg, name)?)),
        "sanitize_url" => Value::String(url_encode(&as_str(arg, name)?)),
        "sanitize_path" => Value::String(path_sanitize(&as_str(arg, name)?)),
        "sanitize_command" => Value::String(shell_quote(&as_str(arg, name)?)),
        "sanitize_ldap" => Value::String(ldap_escape(&as_str(arg, name)?)),
        "sanitize_json" => Value::String(json_escape(&as_str(arg, name)?)),
        "sanitize_email" => Value::String(email_sanitize(&as_str(arg, name)?)),

        // ── Validators / transformers ──
        "validate_url" => Value::String(url_validate(&as_str(arg, name)?)),
        "normalize_unicode" => Value::String(unicode_normalize_security(&as_str(arg, name)?)),
        "strip_nulls" => Value::String(strip_nul_bytes(&as_str(arg, name)?)),
        // (Tainted<String>, Int) → Option<Tainted<String>>.
        // Some(s) ⇒ inl(String); None ⇒ inr(Unit). Length is counted in Unicode
        // scalar values, not bytes.
        "validate_length" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(a, b) => {
                let s = as_str(&a, name)?;
                let max = as_int(&b, name)?;
                if s.chars().count() as u64 <= max {
                    Value::inl(Value::String(s))
                } else {
                    Value::inr(Value::Unit)
                }
            }
        },

        // ── Sinks: query sinks echo the executed (sanitized) payload (modelled
        //    execution — no database/LDAP/XML/JS engine is contacted) ──
        "sql_execute" | "ldap_search" | "xml_query" | "js_eval" => {
            Value::String(as_str(arg, name)?)
        }
        // HTML rendering: the input is already HtmlEscape-sanitized, so rendering
        // is just emitting it — this one is real (identity on the safe string).
        "html_render" => Value::String(as_str(arg, name)?),
        // Shell execution: NEVER spawns a process. Models a successful exit (0).
        "shell_exec" => {
            let _cmd = as_str(arg, name)?;
            Value::Int(0)
        }
        // DOM mutation sinks: modelled, return unit. `dom_set_html(elem, html)`
        // and `dom_set_attr(elem, (attr, value))` both desugar to a pair whose
        // first element is the element handle.
        "dom_set_html" | "dom_set_attr" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(_, _) => Value::Unit,
        },
        // Email send: modelled, returns `true` (sent). No SMTP.
        "email_send" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(_, _) => Value::Bool(true),
        },
        // Email header set: modelled, returns unit.
        "email_set_header" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(_, _) => Value::Unit,
        },
        // Safe redirect: modelled, returns unit.
        "http_redirect_safe" => {
            let _url = as_str(arg, name)?;
            Value::Unit
        }

        // ── HTTP (modelled — no socket is opened) ──
        // GET / fetch_safe take a single URL string.
        "http_get" | "http_fetch_safe" => {
            let _url = as_str(arg, name)?;
            Value::String(MODELLED_HTTP_RESPONSE.to_string())
        }
        // POST/PUT carry `(url, (body, csrf_token))`; DELETE carries `(url, token)`.
        "http_post" | "http_put" | "http_delete" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(_, _) => Value::String(MODELLED_HTTP_RESPONSE.to_string()),
        },
        // Extract the (network-tainted) body from a modelled response.
        "http_body" => match arg {
            Value::String(s) => Value::String(s.clone()),
            other => Value::String(crate::builtins::format_value(other)),
        },

        // ── CSRF ──
        // Unit → String. `csrf_generate()` and `csrf_generate(())` are the
        // same application: a zero-arg call applies `()` (REQ-68). Before that,
        // the bare form was dropped to a `Var` and evaluated to the un-applied
        // builtin instead of a token.
        "csrf_generate" => Value::String(generate_csrf_token()),
        // (request_token, session_token) → Bool. Non-short-circuiting compare so
        // matching does not leak the common prefix length by timing.
        "csrf_validate" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(a, b) => Value::Bool(constant_time_eq(&as_str(&a, name)?, &as_str(&b, name)?)),
        },
        // (origin, allowed_origin) → Bool. Exact-match same-origin check.
        "csrf_check_origin" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(a, b) => {
                let origin = as_str(&a, name)?;
                let allowed = as_str(&b, name)?;
                Value::Bool(!allowed.is_empty() && origin == allowed)
            }
        },
        // (referer, allowed_origin) → Bool. The referrer URL must begin with the
        // allowed origin.
        "csrf_check_referer" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(a, b) => {
                let referer = as_str(&a, name)?;
                let allowed = as_str(&b, name)?;
                Value::Bool(!allowed.is_empty() && referer.starts_with(&allowed))
            }
        },

        // ── Safe file I/O (real filesystem; path already PathTraversal-sanitized) ──
        "file_read_safe" => {
            let path = as_str(arg, name)?;
            // Same verified can_read gate as fail_baca (shared host-FS gate).
            crate::builtins::fail::gate_read("file_read_safe", &path)?;
            let content = std::fs::read_to_string(&path).map_err(|e| {
                Error::InvalidOperation(format!("file_read_safe: cannot read '{path}': {e}"))
            })?;
            Value::String(content)
        }
        "file_write_safe" => match split_pair(name, arg)? {
            Either::Partial(v) => v,
            Either::Pair(a, b) => {
                let path = as_str(&a, name)?;
                let content = as_str(&b, name)?;
                // Same verified can_write gate as fail_tulis.
                crate::builtins::fail::gate_write("file_write_safe", &path)?;
                std::fs::write(&path, content.as_bytes()).map_err(|e| {
                    Error::InvalidOperation(format!("file_write_safe: cannot write '{path}': {e}"))
                })?;
                Value::Unit
            }
        },
        "file_delete_safe" => {
            let path = as_str(arg, name)?;
            // Same verified can_write delete gate as fail_buang.
            crate::builtins::fail::gate_delete("file_delete_safe", &path)?;
            Value::Bool(std::fs::remove_file(&path).is_ok())
        }

        // ── Safe parsers ──
        // Delegate to the real JSON parser; "safe" = malformed input yields Unit
        // (a benign empty value) instead of a runtime error.
        "json_parse_safe" | "deserialize_safe" => {
            let s = as_str(arg, name)?;
            // "safe" = malformed input (a parse `Err`) or an unhandled shape
            // yields Unit, never a runtime error. So we must NOT `?`-propagate.
            match crate::builtins::json::apply("json_urai", &Value::String(s)) {
                Ok(Some(v)) => v,
                _ => Value::Unit,
            }
        }
        // XML has no parser in-tree (a full XML tree is the separate strings/XML
        // effort); modelled as identity on the document text so the value is
        // observable. Does NOT resolve entities (no XXE surface).
        "xml_parse_safe" => Value::String(as_str(arg, name)?),

        _ => return Ok(None),
    };
    Ok(Some(result))
}

// ─────────────────────────────────────────────────────────────────────────────
// Argument helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Result of inspecting a (possibly curried) pair argument.
enum Either {
    /// The single value seen so far; re-emitted as a `BuiltinPartial` so the next
    /// application can complete the pair.
    Partial(Value),
    /// A fully-formed `(fst, snd)` pair.
    Pair(Value, Value),
}

/// Split a pair argument, or defer via `BuiltinPartial` when only the first of a
/// curried two-argument call has arrived.
fn split_pair(name: &str, arg: &Value) -> Result<Either> {
    match arg {
        Value::Pair(a, b) => Ok(Either::Pair((**a).clone(), (**b).clone())),
        other => Ok(Either::Partial(Value::BuiltinPartial(
            name.to_string(),
            Box::new(other.clone()),
        ))),
    }
}

fn as_str(v: &Value, ctx: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        _ => Err(Error::TypeMismatch {
            expected: "string".to_string(),
            found: format!("{v:?}"),
            context: ctx.to_string(),
        }),
    }
}

fn as_int(v: &Value, ctx: &str) -> Result<u64> {
    match v {
        Value::Int(n) => Ok(*n),
        Value::IntN { value, .. } => Ok(*value),
        _ => Err(Error::TypeMismatch {
            expected: "int".to_string(),
            found: format!("{v:?}"),
            context: ctx.to_string(),
        }),
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Escaping primitives (each independently unit-tested below)
// ─────────────────────────────────────────────────────────────────────────────

/// HTML entity encoding (OWASP XSS Prevention, rule #1). `&` is escaped first so
/// the entities themselves are not double-encoded.
fn html_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '&' => out.push_str("&amp;"),
            '<' => out.push_str("&lt;"),
            '>' => out.push_str("&gt;"),
            '"' => out.push_str("&quot;"),
            '\'' => out.push_str("&#x27;"),
            '/' => out.push_str("&#x2F;"),
            _ => out.push(c),
        }
    }
    out
}

/// XML predefined-entity encoding (XML 1.0 §4.6). Like HTML but uses `&apos;`.
fn xml_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '&' => out.push_str("&amp;"),
            '<' => out.push_str("&lt;"),
            '>' => out.push_str("&gt;"),
            '"' => out.push_str("&quot;"),
            '\'' => out.push_str("&apos;"),
            _ => out.push(c),
        }
    }
    out
}

/// SQL escaping for interpolation into a **single-quoted** string literal: ANSI
/// single-quote doubling, backslash escaping (MySQL default mode), and NUL
/// removal. Parameterized queries remain preferable; here the *type system*
/// forces this sanitizer before any `sql_execute` sink.
fn sql_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '\0' => {} // strip NUL
            '\\' => out.push_str("\\\\"),
            '\'' => out.push_str("''"),
            _ => out.push(c),
        }
    }
    out
}

/// JavaScript string-literal encoding (OWASP XSS Prevention, rule #3): ASCII
/// alphanumerics pass; every other character is escaped as `\xHH` (code point
/// < 0x100) or its UTF-16 code units as `\uHHHH`.
fn js_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        if c.is_ascii_alphanumeric() {
            out.push(c);
        } else if (c as u32) < 0x100 {
            out.push_str(&format!("\\x{:02X}", c as u32));
        } else {
            let mut buf = [0u16; 2];
            for unit in c.encode_utf16(&mut buf) {
                out.push_str(&format!("\\u{unit:04X}"));
            }
        }
    }
    out
}

/// CSS string/identifier encoding (OWASP XSS Prevention, rule #4): ASCII
/// alphanumerics pass; everything else becomes `\HH ` (backslash, hex code
/// point, space terminator).
fn css_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        if c.is_ascii_alphanumeric() {
            out.push(c);
        } else {
            out.push_str(&format!("\\{:x} ", c as u32));
        }
    }
    out
}

/// RFC 3986 percent-encoding. The unreserved set `A-Za-z0-9-._~` passes; every
/// other UTF-8 byte becomes `%HH` (uppercase).
fn url_encode(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for b in s.bytes() {
        match b {
            b'A'..=b'Z' | b'a'..=b'z' | b'0'..=b'9' | b'-' | b'.' | b'_' | b'~' => {
                out.push(b as char);
            }
            _ => out.push_str(&format!("%{b:02X}")),
        }
    }
    out
}

/// Path-traversal prevention (CWE-22). Strip NUL; split on `/` and `\`; drop
/// empty, `.` and `..` segments; rejoin with `/`. The result is a safe relative
/// path with no traversal, no absolute root, and no backslashes.
fn path_sanitize(s: &str) -> String {
    let cleaned: String = s.chars().filter(|&c| c != '\0').collect();
    cleaned
        .split(['/', '\\'])
        .filter(|seg| !seg.is_empty() && *seg != "." && *seg != "..")
        .collect::<Vec<_>>()
        .join("/")
}

/// POSIX shell single-quote escaping. The whole argument is wrapped in single
/// quotes and each embedded `'` becomes `'\''`, yielding one inert shell word
/// that the shell cannot re-interpret (command-injection safe).
fn shell_quote(s: &str) -> String {
    let mut out = String::with_capacity(s.len() + 2);
    out.push('\'');
    for c in s.chars() {
        if c == '\'' {
            out.push_str("'\\''");
        } else {
            out.push(c);
        }
    }
    out.push('\'');
    out
}

/// RFC 4515 §3 LDAP search-filter assertion-value escaping for the five
/// characters that are syntactically significant in a filter.
fn ldap_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '\\' => out.push_str("\\5c"),
            '*' => out.push_str("\\2a"),
            '(' => out.push_str("\\28"),
            ')' => out.push_str("\\29"),
            '\0' => out.push_str("\\00"),
            _ => out.push(c),
        }
    }
    out
}

/// RFC 8259 JSON string-content escaping (no surrounding quotes). Control
/// characters use the short forms where defined, else `\uHHHH`; U+2028/U+2029
/// (which terminate JavaScript string literals) are escaped too.
fn json_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\u{08}' => out.push_str("\\b"),
            '\u{0C}' => out.push_str("\\f"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            '\u{2028}' => out.push_str("\\u2028"),
            '\u{2029}' => out.push_str("\\u2029"),
            c if (c as u32) < 0x20 => out.push_str(&format!("\\u{:04x}", c as u32)),
            _ => out.push(c),
        }
    }
    out
}

/// Email header-injection prevention: drop CR/LF/NUL (which would split the
/// value into extra SMTP headers) and trim surrounding whitespace.
fn email_sanitize(s: &str) -> String {
    s.chars()
        .filter(|&c| c != '\r' && c != '\n' && c != '\0')
        .collect::<String>()
        .trim()
        .to_string()
}

/// URL allow-list (anti-XSS / open-redirect). Permits `http(s)://`, `mailto:`,
/// and same-origin relative paths (`/x` but not protocol-relative `//x`).
/// Everything else (`javascript:`, `data:`, `vbscript:`, `file:`, `//evil`)
/// collapses to the inert `about:blank`.
fn url_validate(s: &str) -> String {
    let t = s.trim();
    let lower = t.to_ascii_lowercase();
    let ok = lower.starts_with("http://")
        || lower.starts_with("https://")
        || lower.starts_with("mailto:")
        || (t.starts_with('/') && !t.starts_with("//"));
    if ok {
        t.to_string()
    } else {
        "about:blank".to_string()
    }
}

/// Targeted homograph / Trojan-Source defence (CVE-2021-42574): strip the
/// zero-width and bidirectional-control format characters that let visually
/// identical or reordered text conceal an attack. This is NOT UAX#15 NFC (the
/// separate, multi-session Strings row) — it is the security-relevant subset
/// that needs no Unicode normalization tables.
fn unicode_normalize_security(s: &str) -> String {
    s.chars().filter(|&c| !is_dangerous_format_char(c)).collect()
}

fn is_dangerous_format_char(c: char) -> bool {
    matches!(c as u32,
        0x200B..=0x200F | // ZWSP, ZWNJ, ZWJ, LRM, RLM
        0x202A..=0x202E | // LRE, RLE, PDF, LRO, RLO (bidi overrides)
        0x2066..=0x2069 | // LRI, RLI, FSI, PDI (bidi isolates)
        0x2060 |          // word joiner
        0x00AD |          // soft hyphen
        0xFEFF)           // BOM / ZWNBSP
}

/// Remove all NUL bytes (defeats NUL-byte truncation/injection bypasses).
fn strip_nul_bytes(s: &str) -> String {
    s.chars().filter(|&c| c != '\0').collect()
}

/// Non-short-circuiting byte comparison: the running time does not branch on the
/// first differing byte, so a partial-prefix match is not leaked by timing. (For
/// CSRF tokens the lengths are public and equal.)
fn constant_time_eq(a: &str, b: &str) -> bool {
    let (ab, bb) = (a.as_bytes(), b.as_bytes());
    if ab.len() != bb.len() {
        return false;
    }
    let mut diff: u8 = 0;
    for i in 0..ab.len() {
        diff |= ab[i] ^ bb[i];
    }
    diff == 0
}

/// Modelled CSRF token: a 128-bit (32 hex char) value seeded from the system
/// clock and a per-process monotonic counter (so rapid successive calls differ).
/// NOTE: this is a *reference* token, not a certified CSPRNG — production
/// deployments should source it from `riina-core`'s CSPRNG. The `Effect::Random`
/// on its type records the intent. Mirrors the seeding pattern of the existing
/// `matematik::rawak` builtin.
fn generate_csrf_token() -> String {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};
    use std::sync::atomic::{AtomicU64, Ordering};
    use std::time::SystemTime;

    static COUNTER: AtomicU64 = AtomicU64::new(0);
    let nanos = SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_nanos() as u64;
    let n = COUNTER.fetch_add(1, Ordering::Relaxed);

    let mut h1 = DefaultHasher::new();
    (nanos, n, 0xC5F1_0001_u64).hash(&mut h1);
    let mut h2 = DefaultHasher::new();
    (nanos, n, 0x7012_0002_u64).hash(&mut h2);
    format!("{:016x}{:016x}", h1.finish(), h2.finish())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn s(name: &str, input: &str) -> String {
        match apply(name, &Value::String(input.to_string())).unwrap().unwrap() {
            Value::String(out) => out,
            other => panic!("{name} returned non-string: {other:?}"),
        }
    }

    // ── Sanitizers: known attack vectors ──

    #[test]
    fn html_escapes_script_tag() {
        assert_eq!(
            s("sanitize_html", "<script>alert('xss')</script>"),
            "&lt;script&gt;alert(&#x27;xss&#x27;)&lt;&#x2F;script&gt;"
        );
        // `&` first — no double-encoding.
        assert_eq!(s("sanitize_html", "a & b"), "a &amp; b");
    }

    #[test]
    fn xml_uses_apos_not_hex() {
        assert_eq!(
            s("sanitize_xml", "<a b=\"x\">'&'</a>"),
            "&lt;a b=&quot;x&quot;&gt;&apos;&amp;&apos;&lt;/a&gt;"
        );
    }

    #[test]
    fn sql_doubles_quote_and_escapes_backslash_strips_nul() {
        assert_eq!(s("sanitize_sql", "Robert'); DROP TABLE--"), "Robert''); DROP TABLE--");
        assert_eq!(s("sanitize_sql", "a\\b"), "a\\\\b");
        assert_eq!(s("sanitize_sql", "a\0b"), "ab");
    }

    #[test]
    fn js_escapes_all_non_alnum() {
        assert_eq!(s("sanitize_js", "abc123"), "abc123");
        assert_eq!(s("sanitize_js", "</script>"), "\\x3C\\x2Fscript\\x3E");
        assert_eq!(s("sanitize_js", "'\""), "\\x27\\x22");
        // Code point < 0x100 → compact \xHH (é = U+00E9; \xE9 ≡ é in JS).
        assert_eq!(s("sanitize_js", "é"), "\\xE9");
        // Code point ≥ 0x100 → UTF-16 \uHHHH (€ = U+20AC).
        assert_eq!(s("sanitize_js", "€"), "\\u20AC");
    }

    #[test]
    fn css_escapes_with_trailing_space() {
        assert_eq!(s("sanitize_css", "red"), "red");
        assert_eq!(s("sanitize_css", "}"), "\\7d ");
        assert_eq!(s("sanitize_css", "a;b"), "a\\3b b");
    }

    #[test]
    fn url_percent_encodes_reserved() {
        assert_eq!(s("sanitize_url", "a b/c?d=e&f"), "a%20b%2Fc%3Fd%3De%26f");
        assert_eq!(s("sanitize_url", "safe-_.~"), "safe-_.~");
        // UTF-8 multi-byte → multiple %HH.
        assert_eq!(s("sanitize_url", "é"), "%C3%A9");
    }

    #[test]
    fn path_strips_traversal() {
        assert_eq!(s("sanitize_path", "../../etc/passwd"), "etc/passwd");
        assert_eq!(s("sanitize_path", "/abs/./x/../y"), "abs/x/y");
        assert_eq!(s("sanitize_path", "a\\..\\b"), "a/b");
        assert_eq!(s("sanitize_path", "ok/file.txt\0.png"), "ok/file.txt.png");
    }

    #[test]
    fn command_single_quote_wraps() {
        assert_eq!(s("sanitize_command", "ls -la"), "'ls -la'");
        assert_eq!(s("sanitize_command", "a'; rm -rf /"), "'a'\\''; rm -rf /'");
    }

    #[test]
    fn ldap_escapes_filter_metachars() {
        assert_eq!(s("sanitize_ldap", "*)(uid=*"), "\\2a\\29\\28uid=\\2a");
        assert_eq!(s("sanitize_ldap", "a\\b"), "a\\5cb");
    }

    #[test]
    fn json_escapes_quotes_and_controls() {
        assert_eq!(s("sanitize_json", "he said \"hi\"\n"), "he said \\\"hi\\\"\\n");
        assert_eq!(s("sanitize_json", "a\\b"), "a\\\\b");
        assert_eq!(s("sanitize_json", "\u{2028}"), "\\u2028");
    }

    #[test]
    fn email_strips_crlf_for_header_injection() {
        assert_eq!(
            s("sanitize_email", "user@example.com\r\nBcc: evil@x.com"),
            "user@example.comBcc: evil@x.com"
        );
        assert_eq!(s("sanitize_email", "  a@b.com  "), "a@b.com");
    }

    // ── Validators / transformers ──

    #[test]
    fn validate_url_blocks_javascript_scheme() {
        assert_eq!(s("validate_url", "https://example.com/x"), "https://example.com/x");
        assert_eq!(s("validate_url", "/relative/path"), "/relative/path");
        assert_eq!(s("validate_url", "javascript:alert(1)"), "about:blank");
        assert_eq!(s("validate_url", "//evil.com"), "about:blank");
        assert_eq!(s("validate_url", "data:text/html,<script>"), "about:blank");
        assert_eq!(s("validate_url", "  HTTPS://up.example/x  "), "HTTPS://up.example/x");
    }

    #[test]
    fn normalize_unicode_strips_bidi_and_zero_width() {
        // Trojan-Source bidi override + zero-width space removed; visible text kept.
        assert_eq!(
            s("normalize_unicode", "ad\u{202E}min\u{200B}istrator"),
            "administrator"
        );
    }

    #[test]
    fn strip_nulls_removes_nul() {
        assert_eq!(s("strip_nulls", "a\0b\0c"), "abc");
    }

    #[test]
    fn validate_length_returns_some_or_none() {
        // Some(s) when within bound.
        let within = apply(
            "validate_length",
            &Value::Pair(
                Box::new(Value::String("hello".to_string())),
                Box::new(Value::Int(5)),
            ),
        )
        .unwrap()
        .unwrap();
        assert_eq!(within, Value::inl(Value::String("hello".to_string())));

        // None when over bound.
        let over = apply(
            "validate_length",
            &Value::Pair(
                Box::new(Value::String("toolong".to_string())),
                Box::new(Value::Int(3)),
            ),
        )
        .unwrap()
        .unwrap();
        assert_eq!(over, Value::inr(Value::Unit));
    }

    #[test]
    fn validate_length_curries() {
        // First of a curried call → BuiltinPartial awaiting the bound.
        let partial = apply("validate_length", &Value::String("hi".to_string()))
            .unwrap()
            .unwrap();
        assert_eq!(
            partial,
            Value::BuiltinPartial("validate_length".to_string(), Box::new(Value::String("hi".to_string())))
        );
    }

    #[test]
    fn validate_length_counts_unicode_scalars_not_bytes() {
        // "é" is one scalar but two UTF-8 bytes; bound of 1 must accept it.
        let v = apply(
            "validate_length",
            &Value::Pair(
                Box::new(Value::String("é".to_string())),
                Box::new(Value::Int(1)),
            ),
        )
        .unwrap()
        .unwrap();
        assert_eq!(v, Value::inl(Value::String("é".to_string())));
    }

    // ── Sinks (modelled) ──

    #[test]
    fn query_sinks_echo_payload() {
        for sink in ["sql_execute", "ldap_search", "xml_query", "js_eval", "html_render"] {
            assert_eq!(s(sink, "payload"), "payload");
        }
    }

    #[test]
    fn shell_exec_never_spawns_returns_zero() {
        let v = apply("shell_exec", &Value::String("'rm -rf /'".to_string()))
            .unwrap()
            .unwrap();
        assert_eq!(v, Value::Int(0));
    }

    #[test]
    fn dom_and_email_sinks_model_unit_or_bool() {
        let pair = Value::Pair(
            Box::new(Value::String("#id".to_string())),
            Box::new(Value::String("<b>safe</b>".to_string())),
        );
        assert_eq!(apply("dom_set_html", &pair).unwrap().unwrap(), Value::Unit);
        assert_eq!(apply("email_set_header", &pair).unwrap().unwrap(), Value::Unit);
        assert_eq!(apply("email_send", &pair).unwrap().unwrap(), Value::Bool(true));
    }

    #[test]
    fn redirect_safe_models_unit() {
        assert_eq!(
            apply("http_redirect_safe", &Value::String("/home".to_string()))
                .unwrap()
                .unwrap(),
            Value::Unit
        );
    }

    // ── HTTP (modelled) ──

    #[test]
    fn http_get_returns_modelled_response_and_body_echoes() {
        let resp = s("http_get", "https://example.com");
        assert_eq!(resp, "200 OK");
        // http_body extracts the body from the (modelled) response.
        assert_eq!(s("http_body", &resp), "200 OK");
    }

    #[test]
    fn http_post_curries_url_then_payload() {
        // http_post(url, (body, token))
        let partial = apply("http_post", &Value::String("https://e/x".to_string()))
            .unwrap()
            .unwrap();
        assert!(matches!(partial, Value::BuiltinPartial(ref n, _) if n == "http_post"));
        let full = Value::Pair(
            Box::new(Value::String("https://e/x".to_string())),
            Box::new(Value::Pair(
                Box::new(Value::String("body".to_string())),
                Box::new(Value::String("csrf-token".to_string())),
            )),
        );
        assert_eq!(
            apply("http_post", &full).unwrap().unwrap(),
            Value::String("200 OK".to_string())
        );
    }

    // ── CSRF ──

    #[test]
    fn csrf_generate_is_32_hex_and_unique() {
        let a = match apply("csrf_generate", &Value::Unit).unwrap().unwrap() {
            Value::String(t) => t,
            other => panic!("expected token, got {other:?}"),
        };
        let b = match apply("csrf_generate", &Value::Unit).unwrap().unwrap() {
            Value::String(t) => t,
            other => panic!("expected token, got {other:?}"),
        };
        assert_eq!(a.len(), 32);
        assert!(a.chars().all(|c| c.is_ascii_hexdigit()));
        assert_ne!(a, b, "successive tokens must differ (counter mixed in)");
    }

    #[test]
    fn csrf_validate_constant_time_eq() {
        let same = Value::Pair(
            Box::new(Value::String("tok-abc".to_string())),
            Box::new(Value::String("tok-abc".to_string())),
        );
        assert_eq!(apply("csrf_validate", &same).unwrap().unwrap(), Value::Bool(true));
        let diff = Value::Pair(
            Box::new(Value::String("tok-abc".to_string())),
            Box::new(Value::String("tok-abd".to_string())),
        );
        assert_eq!(apply("csrf_validate", &diff).unwrap().unwrap(), Value::Bool(false));
        // Differing length ⇒ false.
        let len = Value::Pair(
            Box::new(Value::String("short".to_string())),
            Box::new(Value::String("longer".to_string())),
        );
        assert_eq!(apply("csrf_validate", &len).unwrap().unwrap(), Value::Bool(false));
    }

    #[test]
    fn csrf_origin_and_referer_checks() {
        let origin_ok = Value::Pair(
            Box::new(Value::String("https://app.example".to_string())),
            Box::new(Value::String("https://app.example".to_string())),
        );
        assert_eq!(apply("csrf_check_origin", &origin_ok).unwrap().unwrap(), Value::Bool(true));
        let origin_bad = Value::Pair(
            Box::new(Value::String("https://evil.example".to_string())),
            Box::new(Value::String("https://app.example".to_string())),
        );
        assert_eq!(apply("csrf_check_origin", &origin_bad).unwrap().unwrap(), Value::Bool(false));
        let referer_ok = Value::Pair(
            Box::new(Value::String("https://app.example/page".to_string())),
            Box::new(Value::String("https://app.example".to_string())),
        );
        assert_eq!(apply("csrf_check_referer", &referer_ok).unwrap().unwrap(), Value::Bool(true));
        // Empty allow-list never matches.
        let empty = Value::Pair(
            Box::new(Value::String("https://x".to_string())),
            Box::new(Value::String(String::new())),
        );
        assert_eq!(apply("csrf_check_origin", &empty).unwrap().unwrap(), Value::Bool(false));
    }

    // ── Safe parsers + safe file I/O ──

    #[test]
    fn json_parse_safe_parses_or_units() {
        // Real parse via the json module.
        let ok = apply("json_parse_safe", &Value::String("[1,2,3]".to_string()))
            .unwrap()
            .unwrap();
        assert_eq!(
            ok,
            Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)])
        );
        // Malformed input fails *safely* (Unit, not a runtime error).
        let bad = apply("json_parse_safe", &Value::String("{not json".to_string()))
            .unwrap()
            .unwrap();
        assert_eq!(bad, Value::Unit);
    }

    #[test]
    fn safe_file_roundtrip() {
        let tmp = std::env::temp_dir().join("riina_keselamatan_safefile.txt");
        let path = tmp.to_str().unwrap().to_string();

        let write = Value::Pair(
            Box::new(Value::String(path.clone())),
            Box::new(Value::String("guarded".to_string())),
        );
        assert_eq!(apply("file_write_safe", &write).unwrap().unwrap(), Value::Unit);
        assert_eq!(s("file_read_safe", &path), "guarded");
        assert_eq!(
            apply("file_delete_safe", &Value::String(path.clone())).unwrap().unwrap(),
            Value::Bool(true)
        );
        // Deleting a missing file is a benign `false`, not an error.
        assert_eq!(
            apply("file_delete_safe", &Value::String(path)).unwrap().unwrap(),
            Value::Bool(false)
        );
    }

    // ── Dispatch hygiene ──

    #[test]
    fn unknown_name_returns_none() {
        assert_eq!(apply("definitely_not_a_security_builtin", &Value::Unit).unwrap(), None);
    }

    #[test]
    fn every_canonical_name_is_handled() {
        // No canonical key may fall through to `Ok(None)` (the "unknown builtin"
        // path). A runtime `Err` is still "handled" — e.g. `file_read_safe("x")`
        // legitimately errors on a missing file; pair builtins given a single
        // value return a `BuiltinPartial` (still `Some`).
        for (_bm, _en, canonical) in BUILTINS {
            let probe = apply(canonical, &Value::String("x".to_string()));
            assert!(
                !matches!(probe, Ok(None)),
                "canonical `{canonical}` must be handled, got {probe:?}"
            );
        }
    }
}
