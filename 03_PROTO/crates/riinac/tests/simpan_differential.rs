// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Interpreter/C differential for the durable store (`simpan`) family —
//! master plan REQ-70 family routing.
//!
//! # What makes this family different from `masa`
//!
//! `masa` already had a C implementation; it was simply not routed. `simpan`
//! had none, so the log-structured journal in `riina-os::store` is now
//! implemented **twice** — once in Rust, once in emitted C.
//!
//! That is only safe because the **on-disk format is the contract**:
//!
//! ```text
//! header  : "RIINASTORv1\0"                        (12 bytes)
//! record  : [payload_len:u32 LE][crc32:u32 LE][payload]
//! payload : [op:u8][key_len:u32 LE][key][value_len:u32 LE][value]
//! ```
//!
//! A store written by an interpreted program has to be readable by a compiled
//! one and vice versa — otherwise "durable" means "durable until you change
//! how you built the program", which is worse than no persistence at all. The
//! load-bearing tests here are therefore the **cross-backend** ones, not the
//! same-backend round trips: they are the only thing that can catch the two
//! implementations drifting on endianness, field order, or CRC.
//!
//! The journals are additionally compared **byte for byte**, which is stronger
//! than "both can read it": two implementations could agree on how to parse and
//! still disagree on what to emit.

use std::path::{Path, PathBuf};
use std::process::Command;

fn tool_available(tool: &str) -> bool {
    Command::new(tool)
        .arg("--version")
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

/// Guard for tests needing `cc`. A missing tool PANICS by default, because a
/// test that cannot run must never report `ok`; opt out deliberately with
/// `RIINA_ALLOW_MISSING_BACKEND_TOOLS=1`, which announces the lost coverage.
fn require_backend_tools(tools: &[&str]) -> bool {
    let missing: Vec<&str> = tools
        .iter()
        .copied()
        .filter(|t| !tool_available(t))
        .collect();
    if missing.is_empty() {
        return true;
    }
    if std::env::var("RIINA_ALLOW_MISSING_BACKEND_TOOLS").is_ok() {
        eprintln!(
            "!!! SKIPPED (tools missing: {}) — simpan coverage NOT exercised.",
            missing.join(", ")
        );
        return false;
    }
    panic!(
        "required backend tool(s) missing: {}. This test cannot verify anything \
         without them, so it fails rather than reporting a false pass. Install \
         them, or set RIINA_ALLOW_MISSING_BACKEND_TOOLS=1 to skip deliberately.",
        missing.join(", ")
    );
}

/// A throwaway directory holding both the programs and the store file, so a
/// test never touches another's state.
struct Sandbox {
    dir: PathBuf,
    tag: String,
}

impl Sandbox {
    fn new(tag: &str) -> Self {
        let dir = std::env::temp_dir()
            .join(format!("riina_req70_simpan_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create sandbox");
        Self {
            dir,
            tag: tag.to_string(),
        }
    }

    fn store_path(&self) -> PathBuf {
        self.dir.join("kedai.simpan")
    }

    /// Write a program whose body runs against this sandbox's store, and give
    /// back its path. `stem` must be unique per program: `riinac build`
    /// derives its intermediate C path from it.
    fn program(&self, stem: &str, body: &str) -> PathBuf {
        let p = self.dir.join(format!("{}_{stem}.rii", self.tag));
        let path = self.store_path();
        let src = format!(
            "fungsi utama() -> Nombor kesan (Tulis, SistemFail) {{\n\
             \x20   biar h = simpan_buka(\"{}\");\n{body}\n\
             \x20   simpan_tutup(h);\n\
             \x20   0\n}}\n",
            path.display()
        );
        std::fs::write(&p, src).expect("write program");
        p
    }
}

impl Drop for Sandbox {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.dir);
    }
}

/// Interpreter stdout, without the trailing line `riinac run` adds for the
/// program's final value.
fn run_interp(src: &Path) -> String {
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("run")
        .arg(src)
        .output()
        .expect("riinac run");
    assert!(
        out.status.success(),
        "interpreter failed: {}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    let s = String::from_utf8_lossy(&out.stdout).into_owned();
    let mut lines: Vec<&str> = s.lines().collect();
    lines.pop();
    if lines.is_empty() {
        String::new()
    } else {
        format!("{}\n", lines.join("\n"))
    }
}

/// Compile `src` and return the binary's path.
fn build(src: &Path) -> PathBuf {
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("build")
        .arg(src)
        .output()
        .expect("riinac build");
    assert!(
        out.status.success(),
        "native build failed — the simpan family must ROUTE to codegen: {}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    src.with_extension("")
}

fn run_native(src: &Path) -> String {
    let bin = build(src);
    let run = Command::new(&bin).output().expect("run native binary");
    assert!(
        run.status.success(),
        "native binary failed (exit {:?}): {}{}",
        run.status.code(),
        String::from_utf8_lossy(&run.stdout),
        String::from_utf8_lossy(&run.stderr)
    );
    String::from_utf8_lossy(&run.stdout).into_owned()
}

/// A write program and a read program, exercised in every backend pairing.
const WRITE_BODY: &str = "\x20   simpan_letak((h, (\"kunci1\", \"nilai-satu\")));\n\
                          \x20   simpan_letak((h, (\"kunci2\", \"nilai-dua\")));\n\
                          \x20   simpan_padam((h, \"kunci1\"));\n\
                          \x20   simpan_letak((h, (\"kunci3\", \"nilai-tiga\")));\n\
                          \x20   simpan_letak((h, (\"kunci2\", \"nilai-dua-diganti\")));";

const READ_BODY: &str = "\x20   cetakln(ke_teks(senarai_panjang(simpan_kunci(h))));\n\
                         \x20   cetakln(simpan_dapat((h, \"kunci2\")));\n\
                         \x20   cetakln(simpan_dapat((h, \"kunci3\")));\n\
                         \x20   cetakln(ke_teks(simpan_ada((h, \"kunci1\"))));\n\
                         \x20   cetakln(simpan_dapat((h, \"tiada\")));";

/// What both backends must report after `WRITE_BODY`: two live keys, the
/// replaced value, the deleted key gone, and an absent key as empty text.
const EXPECTED_READ: &str = "2\nnilai-dua-diganti\nnilai-tiga\nsalah\n\n";

// ── The cross-backend contract ─────────────────────────────────────────────

/// THE test for this family: a store written by the INTERPRETER is read
/// correctly by a COMPILED binary.
#[test]
fn interpreter_writes_and_c_reads() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("i2c");
    let w = sb.program("w", WRITE_BODY);
    let r = sb.program("r", READ_BODY);
    run_interp(&w);
    assert_eq!(run_native(&r), EXPECTED_READ);
}

/// And the other direction: a store written by a COMPILED binary is read
/// correctly by the interpreter.
#[test]
fn c_writes_and_interpreter_reads() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("c2i");
    let w = sb.program("w", WRITE_BODY);
    let r = sb.program("r", READ_BODY);
    run_native(&w);
    assert_eq!(run_interp(&r), EXPECTED_READ);
}

/// Stronger than "both can read it": the two implementations must EMIT the
/// same bytes. Agreeing on how to parse while disagreeing on how to write
/// would pass the round trips above and still be a drift.
#[test]
fn both_backends_emit_a_byte_identical_journal() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let from_interp = {
        let sb = Sandbox::new("bytes_i");
        let w = sb.program("w", WRITE_BODY);
        run_interp(&w);
        std::fs::read(sb.store_path()).expect("read journal")
    };
    let from_c = {
        let sb = Sandbox::new("bytes_c");
        let w = sb.program("w", WRITE_BODY);
        run_native(&w);
        std::fs::read(sb.store_path()).expect("read journal")
    };
    assert_eq!(
        from_interp, from_c,
        "journals differ: {} vs {} bytes — the two implementations disagree on \
         the on-disk format",
        from_interp.len(),
        from_c.len()
    );
    // And it really is the documented format, not two identical mistakes.
    assert_eq!(&from_interp[..12], b"RIINASTORv1\0", "header magic");
}

// ── Behaviour each backend must have on its own ────────────────────────────

/// Same-backend round trips, so a failure above can be localised to the
/// cross-backend contract rather than to basic operation.
#[test]
fn each_backend_round_trips_its_own_store() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let sb = Sandbox::new("self_i");
    let w = sb.program("w", WRITE_BODY);
    let r = sb.program("r", READ_BODY);
    run_interp(&w);
    assert_eq!(run_interp(&r), EXPECTED_READ, "interpreter self round trip");

    let sb = Sandbox::new("self_c");
    let w = sb.program("w", WRITE_BODY);
    let r = sb.program("r", READ_BODY);
    run_native(&w);
    assert_eq!(run_native(&r), EXPECTED_READ, "C self round trip");
}

/// Keys come back SORTED on both backends. The Rust side gets this from a
/// `BTreeMap`; the C side keeps a sorted array, so this is a real invariant to
/// pin rather than an accident of the container.
#[test]
fn keys_are_sorted_on_both_backends() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let body = "\x20   simpan_letak((h, (\"zebra\", \"1\")));\n\
                \x20   simpan_letak((h, (\"apel\", \"2\")));\n\
                \x20   simpan_letak((h, (\"mangga\", \"3\")));\n\
                \x20   biar k = simpan_kunci(h);\n\
                \x20   cetakln(senarai_dapat((k, 0)));\n\
                \x20   cetakln(senarai_dapat((k, 1)));\n\
                \x20   cetakln(senarai_dapat((k, 2)));";
    let expected = "apel\nmangga\nzebra\n";

    let sb = Sandbox::new("sort_i");
    assert_eq!(run_interp(&sb.program("p", body)), expected, "interpreter");
    let sb = Sandbox::new("sort_c");
    assert_eq!(run_native(&sb.program("p", body)), expected, "C");
}

/// Compaction rewrites the journal with only live records: the live set is
/// unchanged and the file gets smaller. Both backends must agree, and the
/// compacted journals must still be byte-identical to each other.
#[test]
fn compaction_agrees_and_preserves_the_live_set() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    let compact_body = format!("{WRITE_BODY}\n\x20   simpan_padat(h);");
    let mut sizes = Vec::new();
    let mut journals = Vec::new();

    for (which, native) in [("interp", false), ("C", true)] {
        let sb = Sandbox::new(if native { "compact_c" } else { "compact_i" });
        let w = sb.program("w", WRITE_BODY);
        if native {
            run_native(&w);
        } else {
            run_interp(&w);
        }
        let before = std::fs::metadata(sb.store_path()).unwrap().len();

        let sb2 = Sandbox::new(if native { "compact_c2" } else { "compact_i2" });
        let wc = sb2.program("w", &compact_body);
        let r = sb2.program("r", READ_BODY);
        if native {
            run_native(&wc);
            assert_eq!(run_native(&r), EXPECTED_READ, "{which}: live set after compaction");
        } else {
            run_interp(&wc);
            assert_eq!(run_interp(&r), EXPECTED_READ, "{which}: live set after compaction");
        }
        let after = std::fs::metadata(sb2.store_path()).unwrap().len();
        assert!(
            after < before,
            "{which}: compaction did not shrink the journal ({before} -> {after})"
        );
        sizes.push(after);
        journals.push(std::fs::read(sb2.store_path()).unwrap());
    }
    assert_eq!(sizes[0], sizes[1], "compacted sizes differ between backends");
    assert_eq!(journals[0], journals[1], "compacted journals differ");
}

/// A file that is not a RIINA store is REFUSED, on both backends, rather than
/// parsed as garbage or silently overwritten — it might be someone's data.
#[test]
fn a_foreign_file_is_refused_not_overwritten() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    for native in [false, true] {
        let sb = Sandbox::new(if native { "foreign_c" } else { "foreign_i" });
        let content = b"this is not a RIINA store, do not eat it";
        std::fs::write(sb.store_path(), content).unwrap();
        let p = sb.program("p", "\x20   cetakln(\"tidak sepatutnya sampai sini\");");

        let out = if native {
            let bin = build(&p);
            Command::new(&bin).output().expect("run")
        } else {
            Command::new(env!("CARGO_BIN_EXE_riinac"))
                .arg("run")
                .arg(&p)
                .output()
                .expect("run")
        };
        assert!(
            !out.status.success(),
            "{}: opening a foreign file should FAIL",
            if native { "C" } else { "interpreter" }
        );
        assert_eq!(
            std::fs::read(sb.store_path()).unwrap(),
            content,
            "{}: the foreign file was modified",
            if native { "C" } else { "interpreter" }
        );
    }
}

/// A torn tail — the shape a crash mid-append leaves — is discarded on
/// recovery while every committed record before it survives. The Coq model
/// says a pending transaction makes the journal inconsistent, so it cannot be
/// kept; it must also not take the good records with it.
#[test]
fn a_torn_tail_is_discarded_and_earlier_records_survive() {
    if !require_backend_tools(&["cc"]) {
        return;
    }
    for native in [false, true] {
        let sb = Sandbox::new(if native { "torn_c" } else { "torn_i" });
        let w = sb.program("w", WRITE_BODY);
        if native {
            run_native(&w);
        } else {
            run_interp(&w);
        }
        // Append a header promising far more payload than follows: exactly
        // what a crash between writing the length prefix and the body leaves.
        let mut bytes = std::fs::read(sb.store_path()).unwrap();
        let good_len = bytes.len();
        bytes.extend_from_slice(&9999u32.to_le_bytes());
        bytes.extend_from_slice(&0u32.to_le_bytes());
        bytes.extend_from_slice(b"truncated");
        std::fs::write(sb.store_path(), &bytes).unwrap();

        let r = sb.program("r", READ_BODY);
        let out = if native { run_native(&r) } else { run_interp(&r) };
        assert_eq!(
            out,
            EXPECTED_READ,
            "{}: committed records did not survive a torn tail",
            if native { "C" } else { "interpreter" }
        );
        assert!(
            std::fs::metadata(sb.store_path()).unwrap().len() >= good_len as u64,
            "recovery must not lose committed bytes"
        );
    }
}
