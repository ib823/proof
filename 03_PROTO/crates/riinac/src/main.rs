// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Compiler Driver
//!
//! Main entry point for the RIINA compiler.
//! RIINA = Rigorous Immutable Invariant — Normalized Axiom
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS

#![forbid(unsafe_code)]

mod diagnostics;
mod frontend;
mod mcp;
mod repl;
mod verify;

use std::fs;
use std::io::Read as _;
use std::path::PathBuf;
use std::process;

use riina_parser::Parser;

#[derive(Debug)]
enum Command {
    Check,
    Run,
    Build,
    EmitC,
    EmitIR,
    Repl,
    Fmt,
    Doc,
    Lsp,
    Test,
    Mcp,
    Verify(verify::Mode),
    Pkg(Vec<String>),
    ListCompliance,
}

/// Report output format.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
enum ReportFormat {
    #[default]
    Text,
    Json,
}

/// Parsed CLI options (beyond command + file).
#[derive(Debug, Default)]
struct Options {
    compliance: Vec<riina_compliance::ComplianceProfile>,
    report: Option<ReportFormat>,
    report_output: Option<PathBuf>,
    target: Option<riina_codegen::Target>,
    /// Output JSON instead of text (for AI agent consumption)
    json: bool,
    /// Read source from stdin instead of file
    stdin: bool,
    /// Auto-update expected values in jangkakan (expect-test) assertions
    update: bool,
}

fn usage() -> ! {
    eprintln!("Usage: riinac [command] [options] <file.rii>");
    eprintln!();
    eprintln!("Commands:");
    eprintln!("  check    Parse and typecheck only (default)");
    eprintln!("  run      Parse, typecheck, and interpret");
    eprintln!("  build    Parse, typecheck, emit C, and compile");
    eprintln!("  emit-c   Parse, typecheck, and emit C to stdout");
    eprintln!("  emit-ir  Parse, typecheck, lower, and print IR");
    eprintln!("  test     Discover and run inline ujian (test) blocks");
    eprintln!("  doc      Generate HTML documentation");
    eprintln!("  fmt      Format a .rii file");
    eprintln!("  lsp      Start LSP server (stdio)");
    eprintln!("  mcp      Start MCP server for AI agents (stdio)");
    eprintln!("  repl     Interactive read-eval-print loop");
    eprintln!("  verify   Run verification gate [--fast|--full]");
    eprintln!("  pkg      Package manager (init/add/remove/lock/build/...)");
    eprintln!();
    eprintln!("Options:");
    eprintln!("  --json                   Output structured JSON (for AI agents)");
    eprintln!("  --stdin                  Read source from stdin instead of file");
    eprintln!("  --update                 Auto-update jangkakan (expect-test) expected values");
    eprintln!("  --compliance <profiles>  Run compliance checks (comma-separated)");
    eprintln!("  --report                 Generate compliance report (text)");
    eprintln!("  --report-json            Generate compliance report (JSON)");
    eprintln!("  --report-output <file>   Write report to file instead of stdout");
    eprintln!("  --list-compliance        List available compliance profiles");
    eprintln!("  --target <target>        Compilation target (native, wasm32, wasm64, android-arm64, ios-arm64)");
    process::exit(1);
}

fn parse_args() -> (Command, Option<PathBuf>, Options) {
    let args: Vec<String> = std::env::args().collect();

    // Handle pkg early — it takes subcommands, not a file
    if args.len() >= 2 && args[1] == "pkg" {
        return (Command::Pkg(args[2..].to_vec()), None, Options::default());
    }

    // Handle verify early — it takes flags, not a file
    if args.len() >= 2 && args[1] == "verify" {
        let mode = if args.len() >= 3 {
            match args[2].as_str() {
                "--fast" => verify::Mode::Fast,
                "--full" => verify::Mode::Full,
                other => {
                    eprintln!("Unknown verify flag: {other}");
                    usage();
                }
            }
        } else {
            verify::Mode::Fast
        };
        return (Command::Verify(mode), None, Options::default());
    }

    if args.len() < 2 {
        usage();
    }

    // Parse command
    let (cmd, rest) = match args[1].as_str() {
        "check" => (Command::Check, &args[2..]),
        "run" => (Command::Run, &args[2..]),
        "build" => (Command::Build, &args[2..]),
        "emit-c" => (Command::EmitC, &args[2..]),
        "emit-ir" => (Command::EmitIR, &args[2..]),
        "test" => (Command::Test, &args[2..]),
        "doc" => (Command::Doc, &args[2..]),
        "fmt" => (Command::Fmt, &args[2..]),
        "repl" => return (Command::Repl, None, Options::default()),
        "lsp" => return (Command::Lsp, None, Options::default()),
        "mcp" => return (Command::Mcp, None, Options::default()),
        _ => {
            // No command given — default to Check, treat arg[1] as file
            (Command::Check, &args[1..])
        }
    };

    // Parse options and file from remaining args
    let mut opts = Options::default();
    let mut file: Option<PathBuf> = None;
    let mut i = 0;
    let rest_slice: Vec<&str> = rest.iter().map(|s| s.as_str()).collect();

    while i < rest_slice.len() {
        match rest_slice[i] {
            "--list-compliance" => {
                return (Command::ListCompliance, None, Options::default());
            }
            "--json" => {
                opts.json = true;
            }
            "--stdin" => {
                opts.stdin = true;
            }
            "--update" => {
                opts.update = true;
            }
            "--compliance" => {
                i += 1;
                if i >= rest_slice.len() {
                    eprintln!("--compliance requires a comma-separated list of profiles");
                    usage();
                }
                match riina_compliance::parse_profiles(rest_slice[i]) {
                    Ok(profiles) => opts.compliance = profiles,
                    Err(e) => {
                        eprintln!("{e}");
                        eprintln!("Use --list-compliance to see available profiles");
                        process::exit(1);
                    }
                }
            }
            "--report" => {
                opts.report = Some(ReportFormat::Text);
            }
            "--report-json" => {
                opts.report = Some(ReportFormat::Json);
            }
            "--report-output" => {
                i += 1;
                if i >= rest_slice.len() {
                    eprintln!("--report-output requires a file path");
                    usage();
                }
                opts.report_output = Some(PathBuf::from(rest_slice[i]));
            }
            "--target" => {
                i += 1;
                if i >= rest_slice.len() {
                    eprintln!("--target requires a target name (native, wasm32, wasm64, android-arm64, ios-arm64)");
                    usage();
                }
                match riina_codegen::Target::from_str(rest_slice[i]) {
                    Some(t) => opts.target = Some(t),
                    None => {
                        eprintln!("Unknown target: {}", rest_slice[i]);
                        eprintln!(
                            "Available targets: native, wasm32, wasm64, android-arm64, ios-arm64"
                        );
                        process::exit(1);
                    }
                }
            }
            arg if arg.starts_with('-') => {
                eprintln!("Unknown option: {arg}");
                usage();
            }
            path => {
                file = Some(PathBuf::from(path));
            }
        }
        i += 1;
    }

    (cmd, file, opts)
}

/// Escape a string for JSON output (no external dependencies).
fn json_escape(s: &str) -> String {
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

/// Parse an expect-test mismatch error message.
/// Returns (actual_value, expected_value) if the message matches the expect mismatch format.
fn parse_expect_mismatch(msg: &str) -> Option<(String, String)> {
    // Format from jangkakan builtin:
    //   expect mismatch:
    //     actual:   <value>
    //     expected: <value>
    if !msg.contains("expect mismatch") {
        return None;
    }
    let actual = msg
        .split("actual:")
        .nth(1)?
        .split('\n')
        .next()?
        .trim()
        .to_string();
    let expected = msg.split("expected:").nth(1)?.trim().to_string();
    if actual.is_empty() || expected.is_empty() {
        return None;
    }
    Some((actual, expected))
}

/// Format a JSON diagnostic from a parse error.
fn format_parse_error_json(e: &riina_parser::ParseError, filename: &str) -> String {
    let code = e.kind.error_code();
    let msg = json_escape(&e.to_string());
    let fix = e
        .kind
        .fix_hint()
        .map(|h| json_escape(&h))
        .unwrap_or_default();

    format!(
        r#"{{"success":false,"diagnostics":[{{"severity":"error","code":"{code}","message":"{msg}","file":"{fn_esc}","line":0,"column":{start},"end_column":{end},"fix_hint":"{fix}","rule":null,"related":[]}}]}}"#,
        fn_esc = json_escape(filename),
        start = e.span.start,
        end = e.span.end,
    )
}

/// Format a JSON diagnostic from a type error.
fn format_type_error_json(e: &riina_typechecker::TypeError, filename: &str) -> String {
    let code = e.error_code();
    let msg = json_escape(&e.to_string());
    let fix = e.fix_hint().map(|h| json_escape(&h)).unwrap_or_default();
    let rule = e
        .coq_rule()
        .map(|r| format!("\"{}\"", json_escape(r)))
        .unwrap_or_else(|| "null".to_string());

    format!(
        r#"{{"success":false,"diagnostics":[{{"severity":"error","code":"{code}","message":"{msg}","file":"{fn_esc}","line":0,"column":0,"fix_hint":"{fix}","rule":{rule},"related":[]}}]}}"#,
        fn_esc = json_escape(filename),
    )
}

/// Format a JSON success result.
fn format_success_json(ty: &riina_types::Ty, eff: &riina_types::Effect, filename: &str) -> String {
    let ty_str = json_escape(&format!("{:?}", ty));
    let eff_str = json_escape(&format!("{:?}", eff));
    format!(
        r#"{{"success":true,"diagnostics":[],"file":"{fn_esc}","type":"{ty_str}","effect":"{eff_str}"}}"#,
        fn_esc = json_escape(filename),
    )
}

fn main() {
    let (command, input, opts) = parse_args();

    if let Command::ListCompliance = command {
        eprintln!("Available compliance profiles:");
        eprintln!();
        for p in riina_compliance::ComplianceProfile::ALL {
            eprintln!("  {:<14} {}", p.slug(), p.description());
        }
        return;
    }

    if let Command::Repl = command {
        repl::run();
        return;
    }

    if let Command::Lsp = command {
        if let Err(e) = riina_lsp::server::run() {
            eprintln!("LSP error: {e}");
            process::exit(1);
        }
        return;
    }

    if let Command::Mcp = command {
        if let Err(e) = mcp::run() {
            eprintln!("MCP error: {e}");
            process::exit(1);
        }
        return;
    }

    if let Command::Verify(mode) = command {
        process::exit(verify::run(mode));
    }

    if let Command::Pkg(ref pkg_args) = command {
        if let Err(e) = riina_pkg::cli::run(pkg_args) {
            eprintln!("pkg error: {e}");
            process::exit(1);
        }
        return;
    }

    // Read source from --stdin or file
    let (source, filename, input_path) = if opts.stdin {
        let mut buf = String::new();
        if let Err(e) = std::io::stdin().read_to_string(&mut buf) {
            if opts.json {
                println!(
                    r#"{{"success":false,"diagnostics":[{{"severity":"error","code":"I0001","message":"Failed to read stdin: {}","file":"<stdin>","line":0,"column":0,"fix_hint":"Pipe source code to stdin","rule":null,"related":[]}}]}}"#,
                    json_escape(&e.to_string())
                );
            } else {
                eprintln!("Error reading stdin: {}", e);
            }
            process::exit(1);
        }
        (buf, "<stdin>".to_string(), None)
    } else {
        let path = input.expect("file path required");
        let src = match fs::read_to_string(&path) {
            Ok(s) => s,
            Err(e) => {
                if opts.json {
                    println!(
                        r#"{{"success":false,"diagnostics":[{{"severity":"error","code":"I0002","message":"Cannot read file: {}","file":"{}","line":0,"column":0,"fix_hint":"Check the file path exists","rule":null,"related":[]}}]}}"#,
                        json_escape(&e.to_string()),
                        json_escape(&path.display().to_string())
                    );
                } else {
                    eprintln!("Error reading file: {}", e);
                }
                process::exit(1);
            }
        };
        let name = path.display().to_string();
        (src, name, Some(path))
    };

    // 1. Parse program (top-level declarations)
    let mut parser = Parser::new(&source);
    let program = match parser.parse_program() {
        Ok(p) => p,
        Err(e) => {
            if opts.json {
                println!("{}", format_parse_error_json(&e, &filename));
            } else {
                eprintln!(
                    "{}",
                    diagnostics::format_diagnostic(&source, &e.span, &e.to_string(), &filename)
                );
            }
            process::exit(1);
        }
    };

    // Extract test blocks before desugaring (desugar() consumes the Program)
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

    // Save non-test decls for building test expressions
    let non_test_decls: Vec<riina_types::TopLevelDecl> = if matches!(command, Command::Test) {
        program
            .decls
            .iter()
            .filter(|d| !matches!(d, riina_types::TopLevelDecl::Test { .. }))
            .cloned()
            .collect()
    } else {
        vec![]
    };

    // 2. Typecheck through the shared Coq-matching frontend path.
    let (expr, ty, eff) = match frontend::check_program(&program) {
        Ok(r) => r,
        Err(e) => {
            if opts.json {
                println!("{}", format_type_error_json(&e, &filename));
            } else {
                eprintln!("error: {}", e);
            }
            process::exit(1);
        }
    };

    // 3. Compliance validation (if profiles selected)
    if !opts.compliance.is_empty() {
        let violations = riina_compliance::validate(&expr, &opts.compliance);

        // Generate report if requested
        if let Some(fmt) = opts.report {
            let report = riina_compliance::report::generate(
                &filename,
                &source,
                &opts.compliance,
                &violations,
            );
            let report_text = match fmt {
                ReportFormat::Text => report.to_text(),
                ReportFormat::Json => report.to_json(),
            };
            if let Some(ref path) = opts.report_output {
                if let Err(e) = fs::write(path, &report_text) {
                    eprintln!("Error writing report: {e}");
                    process::exit(1);
                }
                eprintln!("Compliance report written to: {}", path.display());
            } else {
                println!("{report_text}");
            }
            if riina_compliance::has_errors(&violations) {
                process::exit(1);
            }
        } else if !violations.is_empty() {
            for v in &violations {
                eprintln!("{v}");
            }
            if riina_compliance::has_errors(&violations) {
                eprintln!();
                eprintln!("Compliance check failed with errors");
                process::exit(1);
            }
        }
    }

    // 4. Dispatch by command
    match command {
        Command::Check => {
            if opts.json {
                println!("{}", format_success_json(&ty, &eff, &filename));
            } else {
                eprintln!("RIINA Compiler v0.1.0");
                eprintln!("Compiling: {}", filename);
                eprintln!("Success!");
                println!("Type: {:?}", ty);
                println!("Effect: {:?}", eff);
            }
        }
        Command::Test => {
            let total = test_blocks.len();
            let mut passed = 0usize;
            let mut failed = 0usize;
            let mut results: Vec<(String, bool, std::time::Duration, String)> = Vec::new();
            // Collect expect-test updates: (old_expected, new_actual)
            let mut expect_updates: Vec<(String, String)> = Vec::new();

            if !opts.json {
                eprintln!("RIINA Test Runner v0.1.0");
                eprintln!("File: {}", filename);
                eprintln!("Typecheck: LULUS (passed)");
                eprintln!();
            }

            for (name, body) in &test_blocks {
                let test_expr = riina_types::Program::new(non_test_decls.clone())
                    .desugar_with_body(body.clone());

                let start = std::time::Instant::now();
                match riina_codegen::eval_with_builtins(&test_expr) {
                    Ok(_) => {
                        let elapsed = start.elapsed();
                        passed += 1;
                        if !opts.json {
                            eprintln!(
                                "ujian \"{}\" ... LULUS ({:.1}ms)",
                                name,
                                elapsed.as_secs_f64() * 1000.0
                            );
                        }
                        results.push((name.clone(), true, elapsed, String::new()));
                    }
                    Err(e) => {
                        let elapsed = start.elapsed();
                        let msg = e.to_string();

                        // Check if this is an expect-test mismatch (for --update)
                        if opts.update {
                            if let Some((actual, expected)) = parse_expect_mismatch(&msg) {
                                expect_updates.push((expected, actual));
                            }
                        }

                        failed += 1;
                        if !opts.json {
                            eprintln!(
                                "ujian \"{}\" ... GAGAL ({:.1}ms)",
                                name,
                                elapsed.as_secs_f64() * 1000.0
                            );
                            eprintln!("  {}", msg);
                        }
                        results.push((name.clone(), false, elapsed, msg));
                    }
                }
            }

            // Apply expect-test updates if --update was specified
            if opts.update && !expect_updates.is_empty() {
                let mut updated_source = source.clone();
                let mut update_count = 0;
                for (old_expected, new_actual) in &expect_updates {
                    // Find jangkakan/expect calls with the old expected string and replace
                    let old_pattern = format!("\"{}\"", old_expected);
                    let new_pattern = format!("\"{}\"", new_actual);
                    if updated_source.contains(&old_pattern) {
                        updated_source = updated_source.replacen(&old_pattern, &new_pattern, 1);
                        update_count += 1;
                    }
                }
                if update_count > 0 {
                    if let Some(ref path) = input_path {
                        if let Err(e) = fs::write(path, &updated_source) {
                            eprintln!("Error updating file: {e}");
                        } else {
                            eprintln!();
                            eprintln!(
                                "Updated {} jangkakan expected value(s) in {}",
                                update_count, filename
                            );
                        }
                    }
                }
            }

            if opts.json {
                let tests_json: Vec<String> = results
                    .iter()
                    .map(|(name, pass, elapsed, msg)| {
                        format!(
                            r#"{{"name":"{}","passed":{},"duration_ms":{:.1},"message":"{}"}}"#,
                            json_escape(name),
                            pass,
                            elapsed.as_secs_f64() * 1000.0,
                            json_escape(msg)
                        )
                    })
                    .collect();
                println!(
                    r#"{{"success":{},"tests":[{}],"file":"{}","summary":{{"total":{},"passed":{},"failed":{}}}}}"#,
                    failed == 0,
                    tests_json.join(","),
                    json_escape(&filename),
                    total,
                    passed,
                    failed
                );
            } else {
                eprintln!();
                eprintln!("{} ujian, {} lulus, {} gagal", total, passed, failed);
            }

            if failed > 0 && !opts.update {
                process::exit(1);
            }
        }
        Command::Run => match riina_codegen::eval_with_builtins(&expr) {
            Ok(val) => println!("{:?}", val),
            Err(e) => {
                eprintln!("Runtime Error: {}", e);
                process::exit(1);
            }
        },
        Command::EmitC => {
            let target = opts.target.unwrap_or(riina_codegen::Target::Native);
            match riina_codegen::compile(&expr) {
                Ok(program) => {
                    let backend = riina_codegen::backend_for_target(target);
                    match backend.emit(&program) {
                        Ok(output) => {
                            // Write primary output to stdout
                            use std::io::Write;
                            std::io::stdout().write_all(&output.primary).unwrap();
                        }
                        Err(e) => {
                            eprintln!("Codegen Error: {}", e);
                            process::exit(1);
                        }
                    }
                }
                Err(e) => {
                    eprintln!("Codegen Error: {}", e);
                    process::exit(1);
                }
            }
        }
        Command::EmitIR => match riina_codegen::compile(&expr) {
            Ok(program) => println!("{:#?}", program),
            Err(e) => {
                eprintln!("Codegen Error: {}", e);
                process::exit(1);
            }
        },
        Command::Build => {
            let target = opts.target.unwrap_or(riina_codegen::Target::Native);

            let program = match riina_codegen::compile(&expr) {
                Ok(p) => p,
                Err(e) => {
                    eprintln!("Codegen Error: {}", e);
                    process::exit(1);
                }
            };

            let backend = riina_codegen::backend_for_target(target);
            let output = match backend.emit(&program) {
                Ok(o) => o,
                Err(e) => {
                    eprintln!("Codegen Error: {}", e);
                    process::exit(1);
                }
            };

            let stem = filename.strip_suffix(".rii").unwrap_or(&filename);
            let output_dir = input_path
                .as_ref()
                .and_then(|p| p.parent())
                .unwrap_or_else(|| std::path::Path::new("."));

            if target == riina_codegen::Target::Native {
                // Native: write C, compile with cc
                let output_name = output_dir.join(stem);
                let tmp_c = std::env::temp_dir().join(format!("riina_{}.c", stem));
                if let Err(e) = fs::write(&tmp_c, &output.primary) {
                    eprintln!("Error writing temp file: {}", e);
                    process::exit(1);
                }

                let status = process::Command::new("cc")
                    .args([
                        "-o",
                        &output_name.to_string_lossy(),
                        &*tmp_c.to_string_lossy(),
                    ])
                    .status();

                let _ = fs::remove_file(&tmp_c);

                match status {
                    Ok(s) if s.success() => {
                        eprintln!("Built: {}", output_name.display());
                    }
                    Ok(s) => {
                        eprintln!("C compiler exited with: {}", s);
                        process::exit(1);
                    }
                    Err(e) => {
                        eprintln!("Failed to invoke cc: {}", e);
                        process::exit(1);
                    }
                }
            } else {
                // Non-native: write primary output + auxiliary files
                let primary_name = output_dir.join(format!("{}{}", stem, output.extension));
                if let Err(e) = fs::write(&primary_name, &output.primary) {
                    eprintln!("Error writing output: {}", e);
                    process::exit(1);
                }
                eprintln!("Wrote: {}", primary_name.display());

                for aux in &output.auxiliary {
                    let aux_path = output_dir.join(&aux.name);
                    if let Err(e) = fs::write(&aux_path, &aux.content) {
                        eprintln!("Error writing auxiliary file: {}", e);
                        process::exit(1);
                    }
                    eprintln!("Wrote: {}", aux_path.display());
                }

                eprintln!("Built for target: {}", target);
            }
        }
        Command::Fmt => match riina_fmt::format_source(&source) {
            Ok(formatted) => print!("{formatted}"),
            Err(e) => {
                eprintln!("Format error: {e}");
                process::exit(1);
            }
        },
        Command::Doc => {
            let title = input_path
                .as_ref()
                .and_then(|p| p.file_stem())
                .and_then(|s| s.to_str())
                .unwrap_or("RIINA");
            match riina_doc::generate_from_source(title, &source) {
                Ok(html) => print!("{html}"),
                Err(e) => {
                    eprintln!("Doc error: {e}");
                    process::exit(1);
                }
            }
        }
        Command::Repl => unreachable!("handled above"),
        Command::Lsp => unreachable!("handled above"),
        Command::Mcp => unreachable!("handled above"),
        Command::Verify(_) => unreachable!("handled above"),
        Command::Pkg(_) => unreachable!("handled above"),
        Command::ListCompliance => unreachable!("handled above"),
    }
}
