// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Compiler Driver
//!
//! Main entry point for the RIINA compiler.
//! RIINA = Rigorous Immutable Invariant, No Assumptions
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS

#![forbid(unsafe_code)]

mod c_toolchain;
mod diagnostics;
mod expect_update;
mod frontend;
mod pkg_compile;
mod mcp;
mod private_tmp;
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
    /// Run the compiled binary after building (native: ./output, wasm: wasmtime)
    run_after_build: bool,
}

/// The compiler version, from the workspace `Cargo.toml` (which
/// `scripts/bump-version.sh` keeps equal to `VERSION`). Never hand-typed: the
/// banners said "v0.1.0" through the 0.4.0 release.
const VERSION: &str = env!("CARGO_PKG_VERSION");

const USAGE: &str = "\
Usage: riinac [command] [options] <file.rii>

Commands:
  check    Parse and typecheck only (default)
  run      Parse, typecheck, and interpret
  build    Parse, typecheck, emit C/WASM, and compile (--run to execute)
  emit-c   Parse, typecheck, and emit C to stdout
  emit-ir  Parse, typecheck, lower, and print IR
  test     Discover and run inline ujian (test) blocks
  doc      Generate HTML documentation
  fmt      Format a .rii file
  lsp      Start LSP server (stdio)
  mcp      Start MCP server for AI agents (stdio)
  repl     Interactive read-eval-print loop
  verify   Run verification gate [--fast|--full|--coq]
  pkg      Package manager (init/add/remove/lock/build/...)
  help     Print this help (also --help, -h)
  version  Print the compiler version (also --version, -V)

Options:
  --json                   Output structured JSON (for AI agents)
  --stdin                  Read source from stdin instead of file
  --update                 Auto-update jangkakan (expect-test) expected values
  --compliance <profiles>  Run compliance checks (comma-separated)
  --report                 Generate compliance report (text)
  --report-json            Generate compliance report (JSON)
  --report-output <file>   Write report to file instead of stdout
  --list-compliance        List available compliance profiles
  --target <target>        Compilation target (native, wasm32, wasm64, android-arm64, ios-arm64)

Exactly one input file is accepted per invocation.";

fn usage() -> ! {
    eprintln!("{USAGE}");
    process::exit(1);
}

/// `true` when the first argument names a source file rather than a command,
/// so the documented `riinac <file.rii>` shorthand for `check` still works but
/// a mistyped or unknown command (`riinac chek x.rii`, `riinac emit-core
/// x.rii`) is an error instead of a silent `check` that reports success.
fn looks_like_source_file(arg: &str) -> bool {
    arg.ends_with(".rii") || arg.ends_with(".riih") || std::path::Path::new(arg).is_file()
}

fn parse_args() -> (Command, Option<PathBuf>, Options) {
    let args: Vec<String> = std::env::args().collect();

    if args.len() == 2 {
        match args[1].as_str() {
            "--help" | "-h" | "help" => {
                println!("{USAGE}");
                process::exit(0);
            }
            "--version" | "-V" | "version" => {
                println!("riinac {VERSION}");
                process::exit(0);
            }
            _ => {}
        }
    }

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
                "--coq" => verify::Mode::Coq,
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
        first if first.starts_with('-') || looks_like_source_file(first) => {
            // No command given — default to Check, treat arg[1] as file
            (Command::Check, &args[1..])
        }
        unknown => {
            eprintln!("Unknown command: {unknown}");
            eprintln!("Run `riinac --help` for the list of commands.");
            process::exit(1);
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
            "--run" => {
                opts.run_after_build = true;
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
                // Only one input file: a second one used to replace the first
                // silently, so `riinac check leaky.rii ok.rii` checked only
                // `ok.rii` and reported success.
                if let Some(prev) = &file {
                    eprintln!(
                        "Only one input file may be given (got `{}` and `{path}`)",
                        prev.display()
                    );
                    eprintln!("Run riinac once per file.");
                    process::exit(1);
                }
                file = Some(PathBuf::from(path));
            }
        }
        i += 1;
    }

    (cmd, file, opts)
}

/// `path` made absolute (against the current directory), so that handing it to
/// `Command::new` executes exactly that file — a relative name with no
/// directory component would otherwise be looked up on `$PATH` — and so that
/// a file name beginning with `-` cannot be mistaken for an option.
fn explicit_path(path: &std::path::Path) -> PathBuf {
    if path.is_absolute() {
        return path.to_path_buf();
    }
    match std::env::current_dir() {
        Ok(cwd) => cwd.join(path),
        Err(_) => std::path::Path::new(".").join(path),
    }
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
fn format_success_json(ty: &riina_types::Ty, eff: &riina_types::EffectSet, filename: &str) -> String {
    let ty_str = json_escape(&format!("{:?}", ty));
    let eff_str = json_escape(&format!("{:?}", eff));
    format!(
        r#"{{"success":true,"diagnostics":[],"file":"{fn_esc}","type":"{ty_str}","effect":"{eff_str}"}}"#,
        fn_esc = json_escape(filename),
    )
}

/// Stack reserved for the compiler thread, on every platform and for every
/// command (check/run/build/emit-*/fmt/test/doc/repl/lsp/mcp/pkg/verify).
///
/// Every stage after the parser — typechecker, interpreter, lowering,
/// emitters, formatter, and the derived `Clone`/`Drop` of the AST — recurses
/// over the syntax tree, and flat source makes a deep tree: 2,000 sequential
/// `biar` statements or a 2,000-term `1 + 1 + …` overflowed the 8 MiB main
/// thread even in a release build (an uncatchable abort). The parser rejects
/// trees deeper than `riina_parser::limits::MAX_AST_DEPTH` (20,000) with a
/// clean error; this stack must hold that depth in the deepest stage.
///
/// Measured per-level cost: ~6 KiB (release) and ~90 KiB (debug — unoptimised
/// frames of the large `match`-based walkers are ~15–20x bigger). Hence
/// 256 MiB for release (2x margin at the limit) and 4 GiB of address space for
/// a debug build on 64-bit hosts. This is a reservation, not an allocation:
/// only the pages a deep program actually touches are ever committed.
const COMPILER_STACK_BYTES: usize = if cfg!(debug_assertions) && usize::BITS >= 64 {
    (4u64 << 30) as usize
} else {
    256 << 20
};

fn main() {
    // Run the whole driver on a dedicated large-stack thread, as rustc does.
    // If the host refuses a reservation that large (e.g. strict overcommit),
    // fall back to smaller ones rather than failing outright.
    let mut size = COMPILER_STACK_BYTES;
    loop {
        match std::thread::Builder::new()
            .name("riinac".into())
            .stack_size(size)
            .spawn(move || {
                // `run`, `test` and the REPL interpret on this thread: an
                // unbounded recursion must end as a runtime error, not abort.
                riina_codegen::declare_eval_stack(size);
                run();
            }) {
            Ok(worker) => {
                if let Err(panic) = worker.join() {
                    std::panic::resume_unwind(panic);
                }
                return;
            }
            Err(_) if size > 64 << 20 => size /= 4,
            Err(error) => {
                eprintln!("Cannot start compiler: {error}");
                process::exit(1);
            }
        }
    }
}

fn run() {
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
        // Inject the real compiler (REQ-72). `riina-pkg` has no compiler
        // dependency of its own, so `pkg build` and `riinac build` cannot drift
        // apart: both go through the same resolver/typechecker/backend.
        if let Err(e) = riina_pkg::cli::run(pkg_args, &pkg_compile::compile_package) {
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

    // 1. Parse program (top-level declarations).
    //
    // When the input is a real file we go through the module resolver
    // (REQ-71), which parses this file AND everything it reaches via
    // `guna <name>;`, then links them into one Program. A file with no
    // single-segment `guna` resolves to exactly the same Program the
    // single-file path produced, so this is transparent for existing programs.
    // `--stdin` has no directory to resolve against and stays single-file.
    let mut parser = Parser::new(&source);
    let parsed = match &input_path {
        Some(path) => match riina_parser::modules::resolve_program(path, &source) {
            Ok(p) => Ok(p),
            Err(re) => {
                // A parse failure in the ROOT file is reported with its span by
                // re-parsing here; module-level errors print the linker message.
                if matches!(re.kind, riina_parser::modules::ResolveErrorKind::Parse { .. })
                    && re.path == *path
                {
                    parser.parse_program()
                } else {
                    if opts.json {
                        println!(
                            r#"{{"success":false,"diagnostics":[{{"severity":"error","code":"M0001","message":"{}","file":"{}","line":0,"column":0,"fix_hint":"Check the guna imports","rule":null,"related":[]}}]}}"#,
                            json_escape(&re.to_string()),
                            json_escape(&re.path.display().to_string())
                        );
                    } else {
                        eprintln!("error: {re}");
                    }
                    process::exit(1);
                }
            }
        },
        None => parser.parse_program(),
    };
    let program = match parsed {
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
        // RIINA's cryptographic primitives are in-house and NOT validated (no
        // CMVP/CAVP certificate; owner ruling D8, 2026-10-19). A compliance run
        // over a program that uses them says so, so a report is never read as
        // evidence that its crypto is certified.
        if eff
            .iter()
            .any(|e| e.category() == riina_types::EffectCategory::Crypto)
        {
            eprintln!(
                "notice: this program uses RIINA crypto primitives, which are experimental \
                 and not validated (no CMVP/CAVP certificate); a compliance report is \
                 evidence toward a profile, not a conformity assessment"
            );
        }
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
                eprintln!("RIINA Compiler v{VERSION}");
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
            // Failing tests, for `--update`: (name, occurrence of that name
            // among the file's tests, error message).
            let mut update_candidates: Vec<(String, usize, String)> = Vec::new();

            if !opts.json {
                eprintln!("RIINA Test Runner v{VERSION}");
                eprintln!("File: {}", filename);
                eprintln!("Typecheck: LULUS (passed)");
                eprintln!();
            }

            for (index, (name, body)) in test_blocks.iter().enumerate() {
                let occurrence = test_blocks[..index].iter().filter(|(n, _)| n == name).count();
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

                        if opts.update {
                            update_candidates.push((name.clone(), occurrence, msg.clone()));
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
            // Each rewrite is confined to the source span of the failing
            // assertion's expected literal (see `expect_update`).
            if opts.update && !update_candidates.is_empty() {
                let failures: Vec<expect_update::Failure<'_>> = update_candidates
                    .iter()
                    .map(|(name, occurrence, message)| expect_update::Failure {
                        name,
                        occurrence: *occurrence,
                        message,
                    })
                    .collect();
                let outcome = expect_update::apply(&source, &failures);
                for reason in &outcome.skipped {
                    eprintln!("Not updated: {reason}");
                }
                let updated_source = outcome.source;
                let update_count = outcome.updated;
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
        Command::Run => match riina_codegen::eval_with_capabilities(&expr, eff) {
            Ok(val) => {
                if ty == riina_types::Ty::Element {
                    if let riina_codegen::Value::String(rendered) = val {
                        println!("{rendered}");
                    } else {
                        println!("{val}");
                    }
                } else {
                    println!("{:?}", val);
                }
            }
            Err(e) => {
                eprintln!("Runtime Error: {}", e);
                process::exit(1);
            }
        },
        Command::EmitC => {
            let target = opts.target.unwrap_or(riina_codegen::Target::Native);
            match riina_codegen::compile(&expr) {
                Ok(program) => {
                    let program = program.with_capabilities(eff);
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

            // The native capability gate starts with what the checker verified.
            let program = match riina_codegen::compile(&expr) {
                Ok(p) => p.with_capabilities(eff),
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

            let basename = std::path::Path::new(&filename)
                .file_name()
                .map(|f| f.to_string_lossy().to_string())
                .unwrap_or_else(|| filename.clone());
            let stem = basename.strip_suffix(".rii").unwrap_or(&basename);
            let output_dir = input_path
                .as_ref()
                .and_then(|p| p.parent())
                .unwrap_or_else(|| std::path::Path::new("."));

            if target == riina_codegen::Target::Native {
                // Native: write C, compile with cc. The intermediate C goes in
                // a private, freshly created directory (random name, mode 0700,
                // exclusive create) — never a predictable shared path that a
                // planted symlink could redirect.
                let output_name = output_dir.join(stem);
                let scratch = match private_tmp::PrivateTempDir::create("riina-build") {
                    Ok(dir) => dir,
                    Err(e) => {
                        eprintln!("Error creating temporary directory: {}", e);
                        process::exit(1);
                    }
                };
                let tmp_c = match scratch.write_new(&format!("{stem}.c"), &output.primary) {
                    Ok(path) => path,
                    Err(e) => {
                        eprintln!("Error writing temp file: {}", e);
                        drop(scratch);
                        process::exit(1);
                    }
                };

                let status = process::Command::new(c_toolchain::C_COMPILER)
                    .arg("-o")
                    .arg(&output_name)
                    .arg(&tmp_c)
                    .status();

                // Removes the C file and its directory (explicitly: the
                // `process::exit` calls below would skip the destructor).
                drop(scratch);

                match status {
                    Ok(s) if s.success() => {
                        eprintln!("Built: {}", output_name.display());
                        if opts.run_after_build {
                            // Execute the artifact by an explicit path. A bare
                            // name like `id` (from `build id.rii` in the cwd) made
                            // `Command::new` search `$PATH` and run /usr/bin/id.
                            let run_status =
                                process::Command::new(explicit_path(&output_name)).status();
                            match run_status {
                                Ok(s) if s.success() => {}
                                Ok(s) => process::exit(s.code().unwrap_or(1)),
                                Err(e) => {
                                    eprintln!("Failed to run {}: {}", output_name.display(), e);
                                    process::exit(1);
                                }
                            }
                        }
                    }
                    Ok(s) => {
                        eprintln!("C compiler exited with: {}", s);
                        process::exit(1);
                    }
                    Err(e) => {
                        let path = std::env::var_os("PATH");
                        eprintln!("Error: {}", c_toolchain::invoke_error(&e, path.as_deref()));
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

                // --run: execute WASM with wasmtime
                if opts.run_after_build {
                    let wasm_path = output_dir.join(format!("{}{}", stem, output.extension));
                    // Absolute, so a file name starting with `-` cannot be read
                    // as a wasmtime option.
                    let status = process::Command::new("wasmtime")
                        .arg("run")
                        .arg(explicit_path(&wasm_path))
                        .status();
                    match status {
                        Ok(s) if s.success() => {}
                        Ok(s) => {
                            eprintln!("wasmtime exited with: {}", s);
                            process::exit(s.code().unwrap_or(1));
                        }
                        Err(e) => {
                            eprintln!("Failed to invoke wasmtime: {} (install: curl https://wasmtime.dev/install.sh -sSf | bash)", e);
                            process::exit(1);
                        }
                    }
                }
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
