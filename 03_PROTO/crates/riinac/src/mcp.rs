// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! MCP (Model Context Protocol) server for RIINA.
//!
//! Exposes RIINA compiler tools (check, test, run, format) to AI agents
//! over stdin/stdout using JSON-RPC 2.0 with Content-Length framing.
//!
//! # Protocol
//!
//! The MCP server implements the 2024-11-05 protocol version:
//! - `initialize` → server capabilities
//! - `tools/list` → available tools
//! - `tools/call` → execute a tool
//!
//! # Tools
//!
//! | Tool | Description |
//! |------|-------------|
//! | `riina_check` | Parse and typecheck RIINA source code |
//! | `riina_test` | Run inline ujian (test) blocks (pure code only by default) |
//! | `riina_run` | Interpret RIINA source code (pure code only by default) |
//! | `riina_format` | Format RIINA source code |
//!
//! # Execution policy — the source is UNTRUSTED
//!
//! `riina_run` and `riina_test` execute code supplied by whoever drives the
//! MCP client (an AI agent, and anything that agent read). By default:
//!
//! * a program (or test) whose INFERRED effect is not `Pure` is refused with a
//!   tool error naming the effect — nothing is evaluated;
//! * as defence in depth, evaluation uses an interpreter with no host-reaching
//!   builtins at all (file system, network, HTTP, durable store, VFS,
//!   stdin/stdout, clock, randomness; see
//!   `riina_codegen::builtins::is_host_effect_builtin`), so a bug in effect
//!   inference still cannot reach the host;
//! * every evaluation runs on its own thread under a step budget, a nesting
//!   depth cap and a wall-clock deadline (memory is not capped).
//!
//! `riinac mcp --allow-effects` opts in to effectful programs: the effect
//! check is skipped and the full builtin set is available (the budgets still
//! apply). Only use it with a trusted client — the program then runs with the
//! server's file and network access, and anything it prints goes to stdout,
//! which is the JSON-RPC channel. (Until 2026-10 the inferred effect was
//! computed and discarded, and both tools ran any program with full host
//! access.)
//!
//! RIINA = Rigorous Immutable Invariant, No Assumptions

use crate::frontend;
use std::io;
use std::time::Duration;

use riina_lsp::json::{self, JsonValue};
use riina_lsp::jsonrpc;
use riina_types::Effect;

/// Server policy, from the `riinac mcp` command line.
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
struct McpConfig {
    /// `--allow-effects`: run programs whatever their inferred effect, with
    /// the full (host-reaching) builtin set. Off by default.
    allow_effects: bool,
}

impl McpConfig {
    /// Parse the arguments that follow `mcp`. Unknown flags are an error, so a
    /// misspelt option is never silently ignored.
    fn from_args<I: IntoIterator<Item = String>>(args: I) -> Result<Self, String> {
        let mut config = Self::default();
        for arg in args {
            match arg.as_str() {
                "--allow-effects" => config.allow_effects = true,
                other => {
                    return Err(format!(
                        "riinac mcp: unknown option {other:?} (known: --allow-effects)"
                    ))
                }
            }
        }
        Ok(config)
    }

    /// The limits every evaluation runs under.
    fn exec_limits(self) -> riina_codegen::ExecLimits {
        riina_codegen::ExecLimits {
            deny_host_effects: !self.allow_effects,
            max_steps: EVAL_MAX_STEPS,
            max_depth: EVAL_MAX_DEPTH,
            wall_clock: EVAL_WALL_CLOCK,
        }
    }
}

/// Evaluation step budget per tool call (per test for `riina_test`).
const EVAL_MAX_STEPS: u64 = 20_000_000;
/// Nesting-depth cap, sized against [`EVAL_STACK_BYTES`] so deep recursion is a
/// clean error instead of a stack overflow that would abort the server.
/// Measured cost of one unit of interpreter nesting: ~70 KiB in a debug build
/// (the evaluator's giant `match` gets an enormous unoptimised frame) and
/// ~2.7 KiB in release, so the cap differs by profile; both leave >2x margin.
const EVAL_MAX_DEPTH: usize = if cfg!(debug_assertions) { 1_500 } else { 20_000 };
/// Wall-clock budget per evaluation.
const EVAL_WALL_CLOCK: Duration = Duration::from_secs(10);
/// Stack for the tool thread (parser, typechecker and interpreter are all
/// recursive; every tool call runs on its own thread with this stack).
const EVAL_STACK_BYTES: usize = 256 * 1024 * 1024;

/// Maximum JSON-RPC message size: 1 MiB.
/// This prevents OOM from malicious or broken clients sending huge Content-Length.
const MAX_MESSAGE_BYTES: usize = 1_048_576;

/// Maximum source code size accepted by tools: 256 KiB.
/// Source code larger than this is rejected before parsing to prevent
/// excessive memory use during AST construction and typechecking.
const MAX_SOURCE_BYTES: usize = 262_144;

/// Run the MCP server loop over stdin/stdout.
///
/// Options are read from the process arguments after `mcp` (the dispatcher
/// in `main.rs` hands over without parsing them): `--allow-effects`.
pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    let config = McpConfig::from_args(std::env::args().skip_while(|a| a != "mcp").skip(1))?;
    let stdin = io::stdin();
    let stdout = io::stdout();
    let mut reader = io::BufReader::new(stdin.lock());
    let mut writer = stdout.lock();

    if config.allow_effects {
        eprintln!(
            "RIINA MCP Server v0.1.0 — ready (--allow-effects: programs run with this \
             process's file/network access; use only with a trusted client)"
        );
    } else {
        eprintln!("RIINA MCP Server v0.1.0 — ready (pure programs only; sandboxed builtins)");
    }

    loop {
        let msg = match jsonrpc::read_message_bounded(&mut reader, MAX_MESSAGE_BYTES) {
            Ok(m) => m,
            Err(e) => {
                // EOF — clean shutdown
                if e.kind() == io::ErrorKind::UnexpectedEof {
                    break;
                }
                // Oversized or malformed — send error if possible, then continue
                // (don't crash the server on one bad message)
                if e.kind() == io::ErrorKind::InvalidData {
                    eprintln!("MCP rejected message: {e}");
                    continue;
                }
                eprintln!("MCP read error: {e}");
                break;
            }
        };

        let method = msg.get("method").and_then(|v| v.as_str()).unwrap_or("");
        let id = msg.get("id").cloned();
        let params = msg.get("params").cloned().unwrap_or(JsonValue::Null);

        match method {
            "initialize" => {
                if let Some(id) = id {
                    let result = handle_initialize();
                    jsonrpc::write_message(&mut writer, &jsonrpc::response(id, result))?;
                }
            }
            "initialized" => {
                // Notification — no response needed
            }
            "tools/list" => {
                if let Some(id) = id {
                    let result = handle_tools_list(config);
                    jsonrpc::write_message(&mut writer, &jsonrpc::response(id, result))?;
                }
            }
            "tools/call" => {
                if let Some(id) = id {
                    let result = handle_tools_call(&params, config);
                    jsonrpc::write_message(&mut writer, &jsonrpc::response(id, result))?;
                }
            }
            "shutdown" | "exit" => {
                if let Some(id) = id {
                    jsonrpc::write_message(&mut writer, &jsonrpc::response(id, JsonValue::Null))?;
                }
                break;
            }
            "notifications/cancelled" => {
                // Ignore cancellation notifications
            }
            _ => {
                // Unknown method — return error if it has an id
                if let Some(id) = id {
                    let err = json_rpc_error(id, -32601, &format!("Method not found: {method}"));
                    jsonrpc::write_message(&mut writer, &err)?;
                }
            }
        }
    }

    Ok(())
}

fn handle_initialize() -> JsonValue {
    json::obj(vec![
        ("protocolVersion", JsonValue::String("2024-11-05".into())),
        (
            "capabilities",
            json::obj(vec![("tools", json::obj(vec![]))]),
        ),
        (
            "serverInfo",
            json::obj(vec![
                ("name", JsonValue::String("riinac".into())),
                ("version", JsonValue::String("0.1.0".into())),
            ]),
        ),
    ])
}

fn handle_tools_list(config: McpConfig) -> JsonValue {
    let policy = if config.allow_effects {
        "EFFECTS ALLOWED on this server (--allow-effects): the program runs with the \
         server process's file-system and network access. Execution is bounded by a \
         step, nesting-depth and wall-clock budget."
    } else {
        "Only PURE code runs: if the inferred effect is not Pure (e.g. file, network, \
         printing), the call is refused with an error naming the effect, and nothing is \
         executed. Evaluation uses a sandboxed builtin set with no file, network, process, \
         clock or randomness access, under a step, nesting-depth and wall-clock budget. \
         Start the server with `riinac mcp --allow-effects` to permit effects."
    };
    let test_desc = format!(
        "Typecheck RIINA source and run its inline ujian (test) blocks; returns pass/fail \
         for each test. {policy}"
    );
    let run_desc = format!(
        "Typecheck and interpret RIINA source code; returns the result value. {policy}"
    );
    json::obj(vec![
        ("tools", JsonValue::Array(vec![
            tool_def(
                "riina_check",
                "Parse and typecheck RIINA source code (nothing is executed). Returns type, effect, and any diagnostics.",
                &[("source", "string", "RIINA source code to check")],
            ),
            tool_def(
                "riina_test",
                &test_desc,
                &[("source", "string", "RIINA source code containing ujian blocks")],
            ),
            tool_def(
                "riina_run",
                &run_desc,
                &[("source", "string", "RIINA source code to run")],
            ),
            tool_def(
                "riina_format",
                "Format RIINA source code using the canonical formatter.",
                &[("source", "string", "RIINA source code to format")],
            ),
        ])),
    ])
}

fn handle_tools_call(params: &JsonValue, config: McpConfig) -> JsonValue {
    let tool_name = params.get("name").and_then(|v| v.as_str()).unwrap_or("");
    let args = params.get("arguments").cloned().unwrap_or(JsonValue::Null);
    let source = args.get("source").and_then(|v| v.as_str()).unwrap_or("");

    if source.is_empty() && tool_name != "riina_version" {
        return tool_error("Missing required argument: source");
    }

    // Reject oversized source code before parsing
    if source.len() > MAX_SOURCE_BYTES {
        return tool_error(&format!(
            "Source code too large: {} bytes (max {} bytes / {} KiB)",
            source.len(),
            MAX_SOURCE_BYTES,
            MAX_SOURCE_BYTES / 1024
        ));
    }

    // Every tool — parsing and typechecking included, both recursive over
    // untrusted input — runs on its own big-stack thread, so a pathological
    // program is an error result, never a stack overflow that aborts the
    // server.
    let tool_name = tool_name.to_string();
    let source = source.to_string();
    run_on_eval_thread(move || match tool_name.as_str() {
        "riina_check" => tool_check(&source),
        "riina_test" => tool_test(&source, config),
        "riina_run" => tool_run(&source, config),
        "riina_format" => tool_format(&source),
        _ => tool_error(&format!("Unknown tool: {tool_name}")),
    })
    .unwrap_or_else(|e| tool_error(&format!("Internal error: {e}")))
}

/// The refusal for an effectful program on a server without `--allow-effects`.
fn effect_refusal(what: &str, eff: riina_types::EffectSet) -> String {
    format!(
        "Refused: {what} has inferred effect {eff:?}, not Pure. This MCP server only \
         executes pure code; start it with `riinac mcp --allow-effects` to permit effects \
         (the program would then run with the server's file and network access)."
    )
}

/// Run `f` on a dedicated thread with an [`EVAL_STACK_BYTES`] stack and wait
/// for it. A panic becomes an error string instead of taking the server down.
fn run_on_eval_thread<T: Send + 'static>(
    f: impl FnOnce() -> T + Send + 'static,
) -> Result<T, String> {
    std::thread::Builder::new()
        .name("riina-mcp-eval".into())
        .stack_size(EVAL_STACK_BYTES)
        .spawn(f)
        .map_err(|e| format!("could not start evaluation thread: {e}"))?
        .join()
        .map_err(|_| "evaluation panicked".to_string())
}

// ─── Tool implementations ─────────────────────────────────────────────

fn tool_check(source: &str) -> JsonValue {
    use riina_parser::Parser;

    let mut parser = Parser::new(source);
    let program = match parser.parse_program() {
        Ok(p) => p,
        Err(e) => {
            return tool_text(&format!(
                "{{\"success\":false,\"error\":\"Parse error: {}\"}}",
                json_escape_str(&e.to_string())
            ));
        }
    };

    match frontend::check_program(&program) {
        Ok((_expr, ty, eff)) => tool_text(&format!(
            "{{\"success\":true,\"type\":\"{}\",\"effect\":\"{}\"}}",
            json_escape_str(&format!("{ty:?}")),
            json_escape_str(&format!("{eff:?}"))
        )),
        Err(e) => {
            let code = e.error_code();
            let fix = e
                .fix_hint()
                .map(|h| json_escape_str(&h))
                .unwrap_or_default();
            let rule = e.coq_rule().unwrap_or("");
            tool_text(&format!(
                "{{\"success\":false,\"error\":\"{}\",\"code\":\"{code}\",\"fix_hint\":\"{fix}\",\"rule\":\"{}\"}}",
                json_escape_str(&e.to_string()),
                json_escape_str(rule)
            ))
        }
    }
}

fn tool_test(source: &str, config: McpConfig) -> JsonValue {
    use riina_parser::Parser;

    let mut parser = Parser::new(source);
    let program = match parser.parse_program() {
        Ok(p) => p,
        Err(e) => {
            return tool_text(&format!(
                "{{\"success\":false,\"error\":\"Parse error: {}\"}}",
                json_escape_str(&e.to_string())
            ));
        }
    };

    // Extract tests and non-test decls
    let test_blocks: Vec<(String, riina_types::Expr)> = program
        .decls
        .iter()
        .filter_map(|d| match d {
            riina_types::TopLevelDecl::Test { name, body } => {
                Some((name.clone(), (**body).clone()))
            }
            _ => None,
        })
        .collect();

    let non_test_decls: Vec<riina_types::TopLevelDecl> = program
        .decls
        .iter()
        .filter(|d| !matches!(d, riina_types::TopLevelDecl::Test { .. }))
        .cloned()
        .collect();

    // Typecheck the whole file first
    if let Err(e) = frontend::check_program(&program) {
        return tool_text(&format!(
            "{{\"success\":false,\"error\":\"Type error: {}\"}}",
            json_escape_str(&e.to_string())
        ));
    }

    // Typecheck each test AS THE PROGRAM IT WILL RUN (the non-test
    // declarations with the test body as the program body), to learn the
    // effect of exactly what is about to execute. Nothing runs unless every
    // test is admissible.
    let mut runnable = Vec::with_capacity(test_blocks.len());
    for (name, body) in test_blocks {
        let mut decls = non_test_decls.clone();
        decls.push(riina_types::TopLevelDecl::Expr(Box::new(body)));
        match frontend::check_program(&riina_types::Program::new(decls)) {
            Ok((expr, _ty, eff)) => {
                if !config.allow_effects && eff != Effect::Pure {
                    return tool_error(&effect_refusal(&format!("test \"{name}\""), eff));
                }
                runnable.push((name, expr));
            }
            Err(e) => {
                return tool_text(&format!(
                    "{{\"success\":false,\"error\":\"Type error in test \\\"{}\\\": {}\"}}",
                    json_escape_str(&name),
                    json_escape_str(&e.to_string())
                ));
            }
        }
    }

    // Run each test under the sandbox limits (each with its own budget).
    let limits = config.exec_limits();
    let outcomes: Vec<(String, Result<(), String>)> = runnable
        .into_iter()
        .map(|(name, expr)| {
            let outcome = riina_codegen::eval_with_limits(&expr, limits)
                .map(|_| ())
                .map_err(|e| e.to_string());
            (name, outcome)
        })
        .collect();

    let total = outcomes.len();
    let mut passed = 0usize;
    let mut failed = 0usize;
    let mut test_results = Vec::new();

    for (name, outcome) in &outcomes {
        match outcome {
            Ok(()) => {
                passed += 1;
                test_results.push(format!(
                    "{{\"name\":\"{}\",\"passed\":true}}",
                    json_escape_str(name)
                ));
            }
            Err(e) => {
                failed += 1;
                test_results.push(format!(
                    "{{\"name\":\"{}\",\"passed\":false,\"message\":\"{}\"}}",
                    json_escape_str(name),
                    json_escape_str(e)
                ));
            }
        }
    }

    tool_text(&format!(
        "{{\"success\":{},\"tests\":[{}],\"summary\":{{\"total\":{total},\"passed\":{passed},\"failed\":{failed}}}}}",
        failed == 0,
        test_results.join(",")
    ))
}

fn tool_run(source: &str, config: McpConfig) -> JsonValue {
    use riina_parser::Parser;

    let mut parser = Parser::new(source);
    let program = match parser.parse_program() {
        Ok(p) => p,
        Err(e) => {
            return tool_text(&format!("Parse error: {e}"));
        }
    };

    let (expr, _ty, eff) = match frontend::check_program(&program) {
        Ok(result) => result,
        Err(e) => return tool_text(&format!("Type error: {e}")),
    };

    // The inferred effect is the policy input — it used to be discarded.
    if !config.allow_effects && eff != Effect::Pure {
        return tool_error(&effect_refusal("the program", eff));
    }

    // Runs on the tool thread (see `handle_tools_call`) under the sandbox
    // limits.
    match riina_codegen::eval_with_limits(&expr, config.exec_limits()) {
        Ok(val) => tool_text(&format!("{val:?}")),
        Err(e) => tool_text(&format!("Runtime error: {e}")),
    }
}

fn tool_format(source: &str) -> JsonValue {
    match riina_fmt::format_source(source) {
        Ok(formatted) => tool_text(&formatted),
        Err(e) => tool_text(&format!("Format error: {e}")),
    }
}

// ─── Helpers ──────────────────────────────────────────────────────────

/// Build an MCP tool definition.
fn tool_def(name: &str, description: &str, params: &[(&str, &str, &str)]) -> JsonValue {
    let mut properties = Vec::new();
    let mut required = Vec::new();
    for &(pname, ptype, pdesc) in params {
        properties.push((
            pname,
            json::obj(vec![
                ("type", JsonValue::String(ptype.into())),
                ("description", JsonValue::String(pdesc.into())),
            ]),
        ));
        required.push(JsonValue::String(pname.into()));
    }

    let mut prop_map = std::collections::BTreeMap::new();
    for (k, v) in properties {
        prop_map.insert(k.to_string(), v);
    }

    json::obj(vec![
        ("name", JsonValue::String(name.into())),
        ("description", JsonValue::String(description.into())),
        (
            "inputSchema",
            json::obj(vec![
                ("type", JsonValue::String("object".into())),
                ("properties", JsonValue::Object(prop_map)),
                ("required", JsonValue::Array(required)),
            ]),
        ),
    ])
}

/// Build an MCP tool result with text content.
fn tool_text(text: &str) -> JsonValue {
    json::obj(vec![(
        "content",
        JsonValue::Array(vec![json::obj(vec![
            ("type", JsonValue::String("text".into())),
            ("text", JsonValue::String(text.into())),
        ])]),
    )])
}

/// Build an MCP tool error result.
fn tool_error(message: &str) -> JsonValue {
    json::obj(vec![
        ("isError", JsonValue::Bool(true)),
        (
            "content",
            JsonValue::Array(vec![json::obj(vec![
                ("type", JsonValue::String("text".into())),
                ("text", JsonValue::String(message.into())),
            ])]),
        ),
    ])
}

/// Build a JSON-RPC error response.
fn json_rpc_error(id: JsonValue, code: i64, message: &str) -> JsonValue {
    json::obj(vec![
        ("jsonrpc", JsonValue::String("2.0".into())),
        ("id", id),
        (
            "error",
            json::obj(vec![
                ("code", JsonValue::Number(code as f64)),
                ("message", JsonValue::String(message.into())),
            ]),
        ),
    ])
}

/// Escape a string for embedding in JSON (without outer quotes).
fn json_escape_str(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if c < '\x20' => {
                out.push_str(&format!("\\u{:04x}", c as u32));
            }
            c => out.push(c),
        }
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_handle_initialize() {
        let result = handle_initialize();
        assert_eq!(
            result.get("protocolVersion"),
            Some(&JsonValue::String("2024-11-05".into()))
        );
        let server = result.get("serverInfo").unwrap();
        assert_eq!(
            server.get("name"),
            Some(&JsonValue::String("riinac".into()))
        );
    }

    #[test]
    fn test_handle_tools_list() {
        let result = handle_tools_list(McpConfig::default());
        let tools = result.get("tools").unwrap();
        if let JsonValue::Array(arr) = tools {
            assert_eq!(arr.len(), 4);
            let names: Vec<&str> = arr
                .iter()
                .filter_map(|t| t.get("name").and_then(|n| n.as_str()))
                .collect();
            assert!(names.contains(&"riina_check"));
            assert!(names.contains(&"riina_test"));
            assert!(names.contains(&"riina_run"));
            assert!(names.contains(&"riina_format"));
        } else {
            panic!("tools should be an array");
        }
    }

    #[test]
    fn test_tool_check_success() {
        let result = tool_check("fungsi utama() -> Nombor kesan Bersih { 42 }");
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("\"success\":true"));
        }
    }

    #[test]
    fn test_tool_check_parse_error() {
        let result = tool_check("fungsi {{{");
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("\"success\":false"));
        }
    }

    #[test]
    fn test_tool_run() {
        let result = tool_run("42", McpConfig::default());
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("42"));
        }
    }

    #[test]
    fn test_tool_format() {
        let result = tool_format("biar x = 42;");
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(!text.is_empty());
        }
    }

    #[test]
    fn test_tool_test_with_passing_test() {
        let source = "ujian \"basic\" {\n    tegaskan(betul)\n}\n";
        let result = tool_test(source, McpConfig::default());
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("\"success\":true"), "got: {text}");
            assert!(text.contains("\"passed\":1"), "got: {text}");
        }
    }

    #[test]
    fn test_tool_test_with_failing_test() {
        let source = "ujian \"should fail\" {\n    tegaskan(salah)\n}\n";
        let result = tool_test(source, McpConfig::default());
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("\"failed\":1"), "got: {text}");
        }
    }

    #[test]
    fn test_json_escape_str() {
        assert_eq!(json_escape_str("hello"), "hello");
        assert_eq!(json_escape_str("a\"b"), "a\\\"b");
        assert_eq!(json_escape_str("a\nb"), "a\\nb");
    }

    #[test]
    fn test_tool_error_format() {
        let result = tool_error("something went wrong");
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)));
    }

    // ─── Adversarial / hardening tests ───────────────────────────────

    #[test]
    fn test_unknown_tool_returns_error() {
        let params = json::obj(vec![
            ("name", JsonValue::String("nonexistent_tool".into())),
            (
                "arguments",
                json::obj(vec![("source", JsonValue::String("42".into()))]),
            ),
        ]);
        let result = handle_tools_call(&params, McpConfig::default());
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)));
    }

    #[test]
    fn test_missing_source_returns_error() {
        let params = json::obj(vec![
            ("name", JsonValue::String("riina_check".into())),
            ("arguments", json::obj(vec![])),
        ]);
        let result = handle_tools_call(&params, McpConfig::default());
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)));
    }

    #[test]
    fn test_empty_source_returns_error() {
        let params = json::obj(vec![
            ("name", JsonValue::String("riina_check".into())),
            (
                "arguments",
                json::obj(vec![("source", JsonValue::String("".into()))]),
            ),
        ]);
        let result = handle_tools_call(&params, McpConfig::default());
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)));
    }

    #[test]
    fn test_null_params_returns_error() {
        let result = handle_tools_call(&JsonValue::Null, McpConfig::default());
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)));
    }

    #[test]
    fn test_missing_tool_name_returns_error() {
        let params = json::obj(vec![(
            "arguments",
            json::obj(vec![("source", JsonValue::String("42".into()))]),
        )]);
        let result = handle_tools_call(&params, McpConfig::default());
        // Empty tool name → "Unknown tool: "
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)));
    }

    #[test]
    fn test_oversized_source_rejected() {
        // Create source larger than MAX_SOURCE_BYTES (256 KiB)
        let big_source = "a".repeat(MAX_SOURCE_BYTES + 1);
        let params = json::obj(vec![
            ("name", JsonValue::String("riina_check".into())),
            (
                "arguments",
                json::obj(vec![("source", JsonValue::String(big_source))]),
            ),
        ]);
        let result = handle_tools_call(&params, McpConfig::default());
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)));
        // Verify error message mentions size
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("too large"), "got: {text}");
        }
    }

    #[test]
    fn test_source_at_exact_limit_accepted() {
        // Source of exactly MAX_SOURCE_BYTES should be accepted (though it will parse-error)
        let source = "a".repeat(MAX_SOURCE_BYTES);
        let params = json::obj(vec![
            ("name", JsonValue::String("riina_check".into())),
            (
                "arguments",
                json::obj(vec![("source", JsonValue::String(source))]),
            ),
        ]);
        let result = handle_tools_call(&params, McpConfig::default());
        // Should NOT be a tool error (isError) — it's a parse error instead
        assert!(result.get("isError").is_none());
    }

    #[test]
    fn test_unicode_source_accepted() {
        // Multi-byte UTF-8 source should work
        let result = tool_check("biar nama = \"日本語\";");
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            // Should parse and return some result (success or type error)
            assert!(!text.is_empty());
        }
    }

    #[test]
    fn test_json_escape_control_chars() {
        // All control characters should be escaped
        assert_eq!(json_escape_str("\x00"), "\\u0000");
        assert_eq!(json_escape_str("\x01"), "\\u0001");
        assert_eq!(json_escape_str("\x1f"), "\\u001f");
        // Tab, newline, carriage return get special escapes
        assert_eq!(json_escape_str("\t"), "\\t");
        assert_eq!(json_escape_str("\n"), "\\n");
        assert_eq!(json_escape_str("\r"), "\\r");
    }

    #[test]
    fn test_json_escape_backslash_and_quote() {
        assert_eq!(json_escape_str("path\\to\\file"), "path\\\\to\\\\file");
        assert_eq!(json_escape_str("say \"hello\""), "say \\\"hello\\\"");
    }

    #[test]
    fn test_tool_check_with_type_error_returns_code() {
        // Type error should include error code and fix hint
        let result = tool_check("fungsi f() -> Nombor kesan Bersih { betul }");
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("\"success\":false"), "got: {text}");
        }
    }

    #[test]
    fn test_tool_run_runtime_error() {
        // Division by zero or similar runtime error
        let result = tool_run("tegaskan(salah)", McpConfig::default());
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(
                text.contains("error") || text.contains("Error") || text.contains("failed"),
                "Expected error message, got: {text}"
            );
        }
    }

    #[test]
    fn test_tool_test_no_tests() {
        // Source with no ujian blocks
        let result = tool_test("biar x = 42;", McpConfig::default());
        let content = result.get("content").unwrap();
        if let JsonValue::Array(arr) = content {
            let text = arr[0].get("text").unwrap().as_str().unwrap();
            assert!(text.contains("\"total\":0"), "got: {text}");
        }
    }

    #[test]
    fn test_max_message_bytes_constant() {
        // Verify constants are reasonable
        assert_eq!(MAX_MESSAGE_BYTES, 1_048_576); // 1 MiB
        assert_eq!(MAX_SOURCE_BYTES, 262_144); // 256 KiB
        const { assert!(MAX_SOURCE_BYTES < MAX_MESSAGE_BYTES) };
    }

    // ─── Execution policy (audit H4) ─────────────────────────────────

    fn text_of(result: &JsonValue) -> String {
        match result.get("content") {
            Some(JsonValue::Array(arr)) => arr[0].get("text").unwrap().as_str().unwrap().to_string(),
            _ => panic!("no content: {result:?}"),
        }
    }

    fn scratch_path(tag: &str) -> std::path::PathBuf {
        std::env::temp_dir().join(format!("riina_mcp_{tag}_{}.txt", std::process::id()))
    }

    const ALLOW: McpConfig = McpConfig { allow_effects: true };

    /// The headline regression: `riina_run` of an effectful program used to
    /// write to the host file system. It must be refused, naming the effect,
    /// and create nothing.
    #[test]
    fn riina_run_refuses_effectful_program_and_touches_nothing() {
        let path = scratch_path("run_refused");
        let _ = std::fs::remove_file(&path);
        let src = format!("fail_tulis((\"{}\", \"x\"))", path.display());
        let result = tool_run(&src, McpConfig::default());
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)), "{result:?}");
        let text = text_of(&result);
        assert!(text.contains("not Pure") && text.contains("--allow-effects"), "{text}");
        assert!(!path.exists(), "a refused program must not have written {}", path.display());
    }

    #[test]
    fn riina_test_refuses_effectful_test_and_touches_nothing() {
        let path = scratch_path("test_refused");
        let _ = std::fs::remove_file(&path);
        let src = format!(
            "ujian \"tulis\" {{\n    biar c = fail_tulis((\"{}\", \"x\"));\n    tegaskan(betul)\n}}\n",
            path.display()
        );
        let result = tool_test(&src, McpConfig::default());
        assert_eq!(result.get("isError"), Some(&JsonValue::Bool(true)), "{result:?}");
        assert!(text_of(&result).contains("not Pure"));
        assert!(!path.exists());
    }

    /// `--allow-effects` is an explicit opt-in that restores the old
    /// behaviour (with budgets).
    #[test]
    fn allow_effects_opt_in_runs_effectful_programs() {
        let path = scratch_path("run_allowed");
        let _ = std::fs::remove_file(&path);
        let src = format!("fail_tulis((\"{}\", \"x\"))", path.display());
        let result = tool_run(&src, ALLOW);
        assert!(result.get("isError").is_none(), "{result:?}");
        assert_eq!(std::fs::read_to_string(&path).unwrap(), "x");
        let _ = std::fs::remove_file(&path);
    }

    /// Defence in depth: even if effect inference let a host builtin through,
    /// the sandboxed environment does not contain it.
    #[test]
    fn sandbox_environment_has_no_host_builtins() {
        let path = scratch_path("sandbox_env");
        let _ = std::fs::remove_file(&path);
        let program = riina_parser::Parser::new(&format!("fail_tulis((\"{}\", \"x\"))", path.display()))
            .parse_program()
            .unwrap();
        let (expr, _, _) = frontend::check_program(&program).unwrap();
        let err = riina_codegen::eval_with_limits(&expr, McpConfig::default().exec_limits()).unwrap_err();
        assert!(err.to_string().contains("fail_tulis"), "{err}");
        assert!(!path.exists());
        for host in ["cetakln", "baca_baris", "jaring_sambung", "http_minta", "simpan_buka", "masa_sekarang", "rawak", "file_write_safe", "vfs_tulis", "csrf_generate"] {
            let program = riina_parser::Parser::new(host).parse_program().unwrap();
            let expr = program.desugar();
            let res = riina_codegen::eval_with_limits(&expr, McpConfig::default().exec_limits());
            assert!(res.is_err(), "{host} must be unbound in the sandbox, got {res:?}");
        }
    }

    #[test]
    fn pure_programs_still_run() {
        let result = tool_run(
            "fungsi kali(x: Nombor) -> Nombor kesan Bersih { x * 2 }\nkali(21)",
            McpConfig::default(),
        );
        assert!(result.get("isError").is_none(), "{result:?}");
        assert!(text_of(&result).contains("42"), "{}", text_of(&result));
    }

    /// Budgets: a non-terminating or absurdly deep program is a clean error
    /// and the server survives (deep recursion would otherwise overflow the
    /// stack and abort the process).
    /// Through the real dispatcher (which supplies the big-stack tool thread).
    fn call(tool: &str, source: &str, config: McpConfig) -> JsonValue {
        let params = json::obj(vec![
            ("name", JsonValue::String(tool.into())),
            (
                "arguments",
                json::obj(vec![("source", JsonValue::String(source.into()))]),
            ),
        ]);
        handle_tools_call(&params, config)
    }

    #[test]
    fn runaway_programs_hit_the_budget_not_the_host() {
        let looping = call(
            "riina_run",
            "fungsi f(n: Nombor) -> Nombor kesan Bersih { f(n + 1) }\nf(0)",
            McpConfig::default(),
        );
        let text = text_of(&looping);
        assert!(text.contains("budget exhausted"), "{text}");
        let deep = call(
            "riina_run",
            "fungsi d(n: Nombor) -> Nombor kesan Bersih { kalau n == 0 { 0 } lain { 1 + d(n - 1) } }\nd(1000000)",
            McpConfig::default(),
        );
        let text = text_of(&deep);
        assert!(text.contains("budget exhausted"), "{text}");
        // The same limits apply to tests.
        let test = call(
            "riina_test",
            "fungsi f(n: Nombor) -> Nombor kesan Bersih { f(n + 1) }\nujian \"lari\" {\n    tegaskan(f(0) == 0)\n}\n",
            McpConfig::default(),
        );
        assert!(text_of(&test).contains("budget exhausted"), "{}", text_of(&test));
        // ...and the next call still works.
        assert!(text_of(&call("riina_run", "1 + 1", McpConfig::default())).contains('2'));
    }

    #[test]
    fn config_flags_and_tool_descriptions() {
        assert_eq!(McpConfig::from_args(Vec::<String>::new()), Ok(McpConfig::default()));
        assert_eq!(McpConfig::from_args(vec!["--allow-effects".to_string()]), Ok(ALLOW));
        assert!(McpConfig::from_args(vec!["--allow-effect".to_string()]).is_err());
        let describe = |config| {
            let list = handle_tools_list(config);
            let Some(JsonValue::Array(tools)) = list.get("tools") else { panic!() };
            tools
                .iter()
                .find(|t| t.get("name").and_then(|n| n.as_str()) == Some("riina_run"))
                .and_then(|t| t.get("description").and_then(|d| d.as_str()).map(str::to_string))
                .unwrap()
        };
        assert!(describe(McpConfig::default()).contains("Only PURE code runs"));
        assert!(describe(ALLOW).contains("EFFECTS ALLOWED"));
    }
}
