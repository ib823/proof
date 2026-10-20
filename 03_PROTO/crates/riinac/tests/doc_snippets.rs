// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Docs execute (mandate S3.2, REQ-96): every RIINA program shown to a reader
//! is checked by the shipped compiler, and must behave as the page says.
//!
//! On 2026-10-19 only 21 of the 47 `riina` blocks in the README and docs
//! passed `riinac check`, though every page presented them as working code;
//! README's Hello World, said to type-check and run, failed with an effect
//! error. Nothing tested them.
//!
//! Sources: `README.md`, every `.md` under `docs/` (the i18n READMEs and the
//! enterprise pages included), `llms.txt`, `llms-full.txt`, and the website
//! (`website/src`). In Markdown, the fence info after `riina` says what the
//! block must do:
//!
//! * nothing: `riinac check` accepts it;
//! * `error="text"`: `riinac check` rejects it with a diagnostic containing
//!   `text` (a page showing a rejected program must show the real error);
//! * `file=dir/name.rii`: the block is written at that path in a directory
//!   shared by the document's blocks, so a later block can import it;
//! * `illustrative=REQ-NN`: not checked. At most 3 repo-wide, each naming the
//!   REQ that will make it real, and none on the README's first screen.
//!
//! On the website, a RIINA program sits in `<Prog check="ok">` or
//! `<Prog check="error:text">`; its text, minus the `<Err>`/`<Dim>`
//! annotations, is checked the same way, and every `<K>fungsi</K>` on the site
//! must be inside one. Each playground example carries `expect: 'ok'` or
//! `expect: 'error:text'`.

use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::atomic::{AtomicUsize, Ordering};

const MAX_ILLUSTRATIVE: usize = 3;
/// README lines a reader sees before scrolling. No illustrative block there.
const README_FIRST_SCREEN_LINES: usize = 60;

fn repo_root() -> PathBuf {
    // .../03_PROTO/crates/riinac -> repo root
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(3)
        .expect("repo root above 03_PROTO/crates/riinac")
        .to_path_buf()
}

#[derive(Debug, Clone, PartialEq)]
enum Expect {
    Pass,
    Error(String),
    Illustrative(String),
}

#[derive(Debug)]
struct Snippet {
    /// `path:line` of the opening fence or element.
    origin: String,
    /// Document the snippet belongs to; `file=` blocks share its directory.
    doc: String,
    line: usize,
    code: String,
    expect: Expect,
    file: Option<String>,
}

/// `key=value` and `key="value with spaces"` pairs from a fence info string.
fn fence_attrs(info: &str) -> Result<Vec<(String, String)>, String> {
    let mut out = Vec::new();
    let mut rest = info.trim();
    while !rest.is_empty() {
        let eq = rest
            .find('=')
            .ok_or_else(|| format!("fence attribute without `=`: {rest:?}"))?;
        let key = rest[..eq].trim().to_string();
        let after = &rest[eq + 1..];
        let (value, tail) = if let Some(quoted) = after.strip_prefix('"') {
            let end = quoted
                .find('"')
                .ok_or_else(|| format!("unterminated quote in fence info: {info:?}"))?;
            (quoted[..end].to_string(), &quoted[end + 1..])
        } else {
            let end = after.find(char::is_whitespace).unwrap_or(after.len());
            (after[..end].to_string(), &after[end..])
        };
        out.push((key, value));
        rest = tail.trim_start();
    }
    Ok(out)
}

fn markdown_snippets(root: &Path, rel: &str, errors: &mut Vec<String>) -> Vec<Snippet> {
    let text = fs::read_to_string(root.join(rel)).unwrap_or_else(|e| panic!("read {rel}: {e}"));
    let lines: Vec<&str> = text.lines().collect();
    let mut out = Vec::new();
    let mut i = 0;
    while i < lines.len() {
        let line = lines[i].trim_start();
        let Some(fence) = line.strip_prefix("```") else {
            i += 1;
            continue;
        };
        let start = i;
        let lang = fence.split_whitespace().next().unwrap_or("");
        let info = fence[lang.len()..].to_string();
        let mut body = Vec::new();
        i += 1;
        while i < lines.len() && !lines[i].trim_start().starts_with("```") {
            body.push(lines[i]);
            i += 1;
        }
        i += 1; // closing fence
        let code = body.join("\n") + "\n";
        if lang != "riina" {
            // RIINA code must not hide in an untagged or mis-tagged block.
            let looks_riina = body.iter().any(|l| {
                let t = l.trim_start();
                t.starts_with("fungsi ") && t.contains("->")
            });
            if looks_riina {
                errors.push(format!(
                    "{rel}:{}: a RIINA program in a ```{lang} block; tag it ```riina",
                    start + 1
                ));
            }
            continue;
        }
        let attrs = match fence_attrs(&info) {
            Ok(a) => a,
            Err(e) => {
                errors.push(format!("{rel}:{}: {e}", start + 1));
                continue;
            }
        };
        let mut expect = Expect::Pass;
        let mut file = None;
        for (k, v) in attrs {
            match k.as_str() {
                "error" => expect = Expect::Error(v),
                "illustrative" => expect = Expect::Illustrative(v),
                "file" => file = Some(v),
                _ => errors.push(format!(
                    "{rel}:{}: unknown fence attribute `{k}`",
                    start + 1
                )),
            }
        }
        out.push(Snippet {
            origin: format!("{rel}:{}", start + 1),
            doc: rel.to_string(),
            line: start + 1,
            code,
            expect,
            file,
        });
    }
    out
}

fn js_unescape(s: &str) -> String {
    let mut out = String::new();
    let mut chars = s.chars();
    while let Some(c) = chars.next() {
        if c != '\\' {
            out.push(c);
            continue;
        }
        match chars.next() {
            Some('n') => out.push('\n'),
            Some('t') => out.push('\t'),
            Some('u') => {
                let hex: String = chars.by_ref().take(4).collect();
                if let Some(ch) = u32::from_str_radix(&hex, 16).ok().and_then(char::from_u32) {
                    out.push(ch);
                }
            }
            Some(other) => out.push(other),
            None => {}
        }
    }
    out
}

/// The program text of a `<Prog>` element's JSX children: string literals and
/// tag contents, with `<Err>`/`<Dim>` annotations dropped and whitespace-only
/// JSX text that spans lines removed (React drops it too).
fn jsx_text(jsx: &str) -> Result<String, String> {
    let mut src = jsx.to_string();
    for tag in ["Err", "Dim"] {
        let open = format!("<{tag}>");
        let close = format!("</{tag}>");
        while let Some(a) = src.find(&open) {
            let b = src[a..]
                .find(&close)
                .ok_or_else(|| format!("unclosed <{tag}>"))?
                + a;
            src.replace_range(a..b + close.len(), "");
        }
    }
    let bytes: Vec<char> = src.chars().collect();
    let mut out = String::new();
    let mut i = 0;
    while i < bytes.len() {
        match bytes[i] {
            '<' => {
                while i < bytes.len() && bytes[i] != '>' {
                    i += 1;
                }
                i += 1;
            }
            '{' => {
                let mut j = i + 1;
                while j < bytes.len() && bytes[j].is_whitespace() {
                    j += 1;
                }
                let quote = *bytes.get(j).ok_or("unterminated `{`")?;
                if quote == '/' {
                    // {/* comment */}
                    while j < bytes.len() && bytes[j] != '}' {
                        j += 1;
                    }
                    i = j + 1;
                    continue;
                }
                if !matches!(quote, '\'' | '"' | '`') {
                    return Err(format!(
                        "unsupported JSX expression at `{}`",
                        bytes[j..].iter().take(20).collect::<String>()
                    ));
                }
                let mut k = j + 1;
                let mut lit = String::new();
                while k < bytes.len() && bytes[k] != quote {
                    if bytes[k] == '\\' {
                        lit.push(bytes[k]);
                        k += 1;
                    }
                    lit.push(bytes[k]);
                    k += 1;
                }
                out.push_str(&js_unescape(&lit));
                k += 1;
                while k < bytes.len() && bytes[k] != '}' {
                    k += 1;
                }
                i = k + 1;
            }
            _ => {
                let start = i;
                while i < bytes.len() && bytes[i] != '<' && bytes[i] != '{' {
                    i += 1;
                }
                let text: String = bytes[start..i].iter().collect();
                if text.contains('\n') {
                    let joined: Vec<&str> = text
                        .lines()
                        .map(str::trim)
                        .filter(|l| !l.is_empty())
                        .collect();
                    out.push_str(&joined.join(" "));
                } else {
                    out.push_str(&text);
                }
            }
        }
    }
    Ok(out)
}

fn parse_check(origin: &str, value: &str, errors: &mut Vec<String>) -> Option<Expect> {
    if value == "ok" {
        Some(Expect::Pass)
    } else if let Some(e) = value.strip_prefix("error:") {
        Some(Expect::Error(e.to_string()))
    } else {
        errors.push(format!(
            "{origin}: expected \"ok\" or \"error:<text>\", found {value:?}"
        ));
        None
    }
}

fn line_of(text: &str, byte: usize) -> usize {
    text[..byte].matches('\n').count() + 1
}

fn website_snippets(root: &Path, rel: &str, errors: &mut Vec<String>) -> Vec<Snippet> {
    let text = fs::read_to_string(root.join(rel)).unwrap_or_else(|e| panic!("read {rel}: {e}"));
    let mut out = Vec::new();
    let mut spans = Vec::new();
    let open = "<Prog check=\"";
    let mut from = 0;
    while let Some(a) = text[from..].find(open).map(|p| p + from) {
        let origin = format!("{rel}:{}", line_of(&text, a));
        let vstart = a + open.len();
        let vend = text[vstart..].find('"').expect("closing quote") + vstart;
        let body_start = text[vend..].find('>').expect("end of <Prog") + vend + 1;
        let Some(body_end) = text[body_start..].find("</Prog>").map(|p| p + body_start) else {
            errors.push(format!("{origin}: <Prog> without </Prog>"));
            break;
        };
        spans.push((a, body_end));
        from = body_end;
        let Some(expect) = parse_check(&origin, &text[vstart..vend], errors) else {
            continue;
        };
        match jsx_text(&text[body_start..body_end]) {
            Ok(code) => out.push(Snippet {
                origin,
                doc: rel.to_string(),
                line: line_of(&text, a),
                code,
                expect,
                file: None,
            }),
            Err(e) => errors.push(format!("{origin}: {e}")),
        }
    }
    let kw = "<K>fungsi</K>";
    let mut from = 0;
    while let Some(p) = text[from..].find(kw).map(|q| q + from) {
        if !spans.iter().any(|&(a, b)| a < p && p < b) {
            errors.push(format!(
                "{rel}:{}: a RIINA program outside <Prog check=...>; wrap it so this test checks it",
                line_of(&text, p)
            ));
        }
        from = p + kw.len();
    }
    out
}

fn playground_snippets(root: &Path, rel: &str, errors: &mut Vec<String>) -> Vec<Snippet> {
    let text = fs::read_to_string(root.join(rel)).unwrap_or_else(|e| panic!("read {rel}: {e}"));
    let start = text
        .find("const EXAMPLES = [")
        .expect("playground EXAMPLES");
    let end = text[start..].find("\n];").expect("end of EXAMPLES") + start;
    let mut out = Vec::new();
    let mut from = start;
    while let Some(c) = text[from..end].find("code: `").map(|p| p + from) {
        let cstart = c + "code: `".len();
        let cend = text[cstart..].find('`').expect("closing backtick") + cstart;
        let origin = format!("{rel}:{}", line_of(&text, c));
        // The example's own object: from the previous `{` to the next `}`
        // after the code.
        let obj_start = text[..c].rfind("\n  {").unwrap_or(start);
        let obj_end = text[cend..].find("\n  }").map(|p| p + cend).unwrap_or(end);
        let obj = &text[obj_start..obj_end];
        from = cend + 1;
        let Some(e) = obj.find("expect: '") else {
            errors.push(format!("{origin}: playground example without `expect`"));
            continue;
        };
        let v = &obj[e + "expect: '".len()..];
        let v = &v[..v.find('\'').expect("closing quote")];
        if let Some(expect) = parse_check(&origin, v, errors) {
            out.push(Snippet {
                origin,
                doc: rel.to_string(),
                line: line_of(&text, c),
                code: js_unescape(&text[cstart..cend]) + "\n",
                expect,
                file: None,
            });
        }
    }
    if out.is_empty() {
        errors.push(format!("{rel}: no playground examples found"));
    }
    out
}

fn markdown_sources(root: &Path) -> Vec<String> {
    fn walk(dir: &Path, root: &Path, out: &mut Vec<String>) {
        let mut entries: Vec<_> = fs::read_dir(dir).expect("read_dir").flatten().collect();
        entries.sort_by_key(|e| e.path());
        for e in entries {
            let p = e.path();
            if p.is_dir() {
                walk(&p, root, out);
            } else if p.extension().is_some_and(|x| x == "md") {
                out.push(
                    p.strip_prefix(root)
                        .unwrap()
                        .to_string_lossy()
                        .replace('\\', "/"),
                );
            }
        }
    }
    let mut out = vec![
        "README.md".to_string(),
        "llms.txt".into(),
        "llms-full.txt".into(),
    ];
    walk(&root.join("docs"), root, &mut out);
    out.retain(|r| root.join(r).exists());
    out
}

fn all_snippets(root: &Path, errors: &mut Vec<String>) -> Vec<Snippet> {
    let mut out = Vec::new();
    for rel in markdown_sources(root) {
        out.extend(markdown_snippets(root, &rel, errors));
    }
    out.extend(website_snippets(
        root,
        "website/src/RiinaWebsite.jsx",
        errors,
    ));
    out.extend(playground_snippets(
        root,
        "website/src/playground/Playground.jsx",
        errors,
    ));
    out
}

/// Runs `riinac check` on every snippet; returns one message per snippet that
/// does not behave as its page says.
fn check_snippets(snippets: &[Snippet]) -> Vec<String> {
    // Tests run in parallel threads of one process: one directory per call.
    static CALLS: AtomicUsize = AtomicUsize::new(0);
    let call = CALLS.fetch_add(1, Ordering::Relaxed);
    let base =
        std::env::temp_dir().join(format!("riina_doc_snippets_{}_{call}", std::process::id()));
    let _ = fs::remove_dir_all(&base);
    let mut failures = Vec::new();
    for (n, s) in snippets.iter().enumerate() {
        if matches!(s.expect, Expect::Illustrative(_)) {
            continue;
        }
        let dir = base.join(s.doc.replace(['/', '.'], "_"));
        let path = match &s.file {
            Some(f) => dir.join(f),
            None => dir.join(format!("snippet_{n}_line{}.rii", s.line)),
        };
        fs::create_dir_all(path.parent().unwrap()).expect("mkdir");
        fs::write(&path, &s.code).expect("write snippet");
        let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
            .arg("check")
            .arg(&path)
            .current_dir(path.parent().unwrap())
            .output()
            .expect("run riinac");
        let text = format!(
            "{}{}",
            String::from_utf8_lossy(&out.stdout),
            String::from_utf8_lossy(&out.stderr)
        );
        let first = text
            .lines()
            .find(|l| !l.trim().is_empty())
            .unwrap_or("")
            .trim();
        match &s.expect {
            Expect::Pass if !out.status.success() => {
                failures.push(format!("{}: should check, but: {first}", s.origin));
            }
            Expect::Error(want) if out.status.success() => {
                failures.push(format!(
                    "{}: should be rejected with {want:?}, but it checks",
                    s.origin
                ));
            }
            Expect::Error(want) if !text.contains(want.as_str()) => {
                failures.push(format!(
                    "{}: should be rejected with {want:?}, but the error is: {first}",
                    s.origin
                ));
            }
            _ => {}
        }
    }
    let _ = fs::remove_dir_all(&base);
    failures
}

/// Rules on the annotations themselves, separate from what riinac says.
fn annotation_rules(snippets: &[Snippet]) -> Vec<String> {
    let mut errors = Vec::new();
    let illustrative: Vec<&Snippet> = snippets
        .iter()
        .filter(|s| matches!(s.expect, Expect::Illustrative(_)))
        .collect();
    if illustrative.len() > MAX_ILLUSTRATIVE {
        errors.push(format!(
            "{} illustrative blocks (at most {MAX_ILLUSTRATIVE} repo-wide, mandate S3.2): {}",
            illustrative.len(),
            illustrative
                .iter()
                .map(|s| s.origin.as_str())
                .collect::<Vec<_>>()
                .join(", ")
        ));
    }
    for s in &illustrative {
        let Expect::Illustrative(req) = &s.expect else {
            unreachable!()
        };
        let digits = req.strip_prefix("REQ-").unwrap_or("");
        if digits.is_empty() || !digits.chars().all(|c| c.is_ascii_digit()) {
            errors.push(format!(
                "{}: illustrative=\"{req}\" must name a REQ (REQ-NN)",
                s.origin
            ));
        }
        if s.doc == "README.md" && s.line <= README_FIRST_SCREEN_LINES {
            errors.push(format!(
                "{}: no illustrative block on the README's first screen",
                s.origin
            ));
        }
    }
    for s in snippets {
        if let Expect::Error(want) = &s.expect {
            if want.trim().is_empty() {
                errors.push(format!(
                    "{}: error=\"\" must quote the expected diagnostic",
                    s.origin
                ));
            }
        }
        if let Some(f) = &s.file {
            if f.starts_with('/') || f.contains("..") {
                errors.push(format!(
                    "{}: file={f} must be a relative path inside the document",
                    s.origin
                ));
            }
        }
    }
    errors
}

#[test]
fn every_documented_riina_program_behaves_as_its_page_says() {
    let root = repo_root();
    let mut errors = Vec::new();
    let snippets = all_snippets(&root, &mut errors);
    assert!(
        snippets.len() >= 40,
        "only {} snippets found: the extractor is broken or the docs moved",
        snippets.len()
    );
    errors.extend(annotation_rules(&snippets));
    errors.extend(check_snippets(&snippets));
    assert!(
        errors.is_empty(),
        "{} of {} documented RIINA programs do not behave as documented:\n  {}",
        errors.len(),
        snippets.len(),
        errors.join("\n  ")
    );
}

// The checks above must be able to fail: a wrong page is caught.

fn snippet(code: &str, expect: Expect) -> Snippet {
    Snippet {
        origin: "control.md:1".into(),
        doc: "control.md".into(),
        line: 1,
        code: code.into(),
        expect,
        file: None,
    }
}

const PRINTS_SECRET: &str = "fungsi utama() -> Unit kesan Tulis {\n    cetakln(sulit \"pin\")\n}\n";
const PRINTS_HELLO: &str = "fungsi utama() -> Unit kesan Tulis {\n    cetakln(\"hello\")\n}\n";

#[test]
fn control_a_rejected_program_shown_as_working_is_caught() {
    let f = check_snippets(&[snippet(PRINTS_SECRET, Expect::Pass)]);
    assert_eq!(f.len(), 1, "{f:?}");
    assert!(f[0].contains("should check"), "{f:?}");
}

#[test]
fn control_a_working_program_shown_as_rejected_is_caught() {
    let f = check_snippets(&[snippet(
        PRINTS_HELLO,
        Expect::Error("Security violation".into()),
    )]);
    assert_eq!(f.len(), 1, "{f:?}");
    assert!(f[0].contains("but it checks"), "{f:?}");
}

#[test]
fn control_the_wrong_diagnostic_is_caught() {
    let f = check_snippets(&[snippet(
        PRINTS_SECRET,
        Expect::Error("Effect violation".into()),
    )]);
    assert_eq!(f.len(), 1, "{f:?}");
    assert!(f[0].contains("but the error is"), "{f:?}");
    assert!(check_snippets(&[snippet(
        PRINTS_SECRET,
        Expect::Error("Security violation in print sink".into())
    )])
    .is_empty());
    assert!(check_snippets(&[snippet(PRINTS_HELLO, Expect::Pass)]).is_empty());
}

#[test]
fn control_illustrative_limits_are_enforced() {
    let mut many: Vec<Snippet> = (0..4)
        .map(|_| snippet("x", Expect::Illustrative("REQ-33".into())))
        .collect();
    assert!(annotation_rules(&many)[0].contains("4 illustrative blocks"));
    many.truncate(1);
    many[0].expect = Expect::Illustrative("someday".into());
    assert!(annotation_rules(&many)[0].contains("must name a REQ"));
    many[0].expect = Expect::Illustrative("REQ-33".into());
    many[0].doc = "README.md".into();
    many[0].line = 12;
    assert!(annotation_rules(&many)[0].contains("first screen"));
}

#[test]
fn control_markdown_fences_are_parsed() {
    let dir = std::env::temp_dir().join(format!("riina_doc_fences_{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();
    let md = "# t\n\n```riina error=\"Security violation in print sink\"\nA\n```\n\n```riina file=lib/a.rii\nB\n```\n\n```\nfungsi f() -> Nombor kesan Bersih { 1 }\n```\n\n```riina colour=red\nC\n```\n";
    fs::write(dir.join("d.md"), md).unwrap();
    let mut errors = Vec::new();
    let s = markdown_snippets(&dir, "d.md", &mut errors);
    let _ = fs::remove_dir_all(&dir);
    assert_eq!(s.len(), 3);
    assert_eq!(
        s[0].expect,
        Expect::Error("Security violation in print sink".into())
    );
    assert_eq!(s[0].code, "A\n");
    assert_eq!(s[1].file.as_deref(), Some("lib/a.rii"));
    assert_eq!(s[1].line, 7);
    assert_eq!(errors.len(), 2, "{errors:?}");
    assert!(errors[0].contains("tag it ```riina"));
    assert!(errors[1].contains("unknown fence attribute `colour`"));
}

#[test]
fn control_jsx_programs_are_extracted() {
    let jsx = "\n  <Dim>{'// note\\n'}</Dim>\n  <K>fungsi</K> <Fn>utama</Fn>{'() -> '}<Ty>Unit</Ty> <K>kesan</K>{' Tulis {\\n    cetak('}<Str>\"hi\"</Str>{');\\n'}\n  <Err>{'    ^^^ error\\n'}</Err>\n  {'}'}\n";
    assert_eq!(
        jsx_text(jsx).unwrap(),
        "fungsi utama() -> Unit kesan Tulis {\n    cetak(\"hi\");\n}"
    );
}
