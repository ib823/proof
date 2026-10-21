// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Differential conformance against the Coq checker (REQ-111, mandate S1.4),
//! first slice.
//!
//! Every program riinac can write in the core (`emit-core`, REQ-110) is type
//! checked twice: by riinac, and by Coq's executable checker `type_check_fn`
//! (`02_FORMAL/coq/foundations/TypeCheckFn.v`, sound for the `has_type`
//! relation, REQ-54 S2). Coq evaluates the comparison itself, with `vm_compute`,
//! one `Eval` per program, and prints a number:
//!
//! * `0`: Coq rejects the term;
//! * `1`: Coq accepts it with the type and effect riinac reported;
//! * `2`: Coq accepts it with a different type or effect.
//!
//! riinac accepts and Coq rejects is a soundness discrepancy, and so is a
//! different type or effect: both fail the gate. riinac rejects and Coq accepts
//! is a completeness gap: it must be listed in [`KNOWN_COMPLETENESS_GAPS`]
//! (tracked, P2), and a listed gap that closes must be removed.
//!
//! Each run first checks three planted controls (an accepted term, an
//! ill-typed term claimed accepted, a wrong claimed type), so the comparison is
//! shown able to catch a discrepancy every time it reports none.
//!
//! The programs are the files under [`SOURCES`], [`GENERATED_PER_RUN`] from the
//! generator (`conformance_gen.rs`), and [`FUZZED_PER_RUN`] mutants of those
//! (`conformance_fuzz.rs`).

use std::collections::{BTreeMap, BTreeSet};
use std::path::{Path, PathBuf};

use riina_types::{Expr, Program, TopLevelDecl, Ty};

use crate::conformance_fuzz::Op;
use crate::conformance_gen::Kind;
use crate::emit_core::{self, Term};

/// Where the programs come from: the example corpus and the conformance
/// fixtures, which are written to stay inside the core.
pub const SOURCES: &[&str] = &["07_EXAMPLES", "03_PROTO/crates/riinac/tests/conformance"];

/// Programs riinac rejects and Coq accepts, each with the reason.
pub const KNOWN_COMPLETENESS_GAPS: &[(&str, &str)] = &[];

/// A class of soundness discrepancy that is known and awaiting a decision.
pub struct KnownClass {
    pub name: &'static str,
    /// A program in the class. It must come out [`Outcome::Known`] on every
    /// run, so the class is removed once it is resolved.
    pub witness: &'static str,
    pub reason: &'static str,
    /// Whether a program riinac accepts is in the class.
    pub detect: fn(&Program) -> bool,
}

/// riinac-accepts / Coq-rejects classes known and awaiting a decision. A
/// program riinac accepts, Coq rejects and a class detects is reported as
/// [`Outcome::Known`] instead of failing the gate; every other discrepancy
/// fails it. Such a program is not otherwise compared, so a second bug in it
/// stays hidden until the class is resolved; the counts are reported.
pub const KNOWN_SOUNDNESS_CLASSES: &[KnownClass] = &[KnownClass {
    name: "a branch on a secret",
    witness: "03_PROTO/crates/riinac/tests/conformance/accept_branch_on_secret.rii",
    reason: "riinac accepts a branch whose condition is a Rahsia or labelled Bool and raises \
             the branches' security level; Coq's T_If requires TBool, so such programs are \
             outside the proofs. Found by the REQ-111 generator 2026-10-21 (494 of 10,000); \
             the owner decides whether riinac rejects it or the core gains a security-raising \
             If (REQ-99)",
    detect: branches_on_a_secret,
}];

/// The expressions of a program's declarations.
fn bodies_mut(p: &mut Program) -> Vec<&mut Expr> {
    p.decls
        .iter_mut()
        .filter_map(|d| match d {
            TopLevelDecl::Function { body, .. } | TopLevelDecl::Test { body, .. } => {
                Some(&mut **body)
            }
            TopLevelDecl::Binding { value, .. } => Some(&mut **value),
            TopLevelDecl::Expr(e) => Some(&mut **e),
            _ => None,
        })
        .collect()
}

/// Whether riinac accepts `program` only because a `kalau` branches on a
/// secret: it rejects the program once every condition must be a plain Bool.
pub fn branches_on_a_secret(program: &Program) -> bool {
    let mut p = program.clone();
    for body in bodies_mut(&mut p) {
        crate::conformance_fuzz::for_each_mut(body, &mut |e| {
            if let Expr::If(c, _, _) = e {
                if !matches!(**c, Expr::Ascribe(_, Ty::Bool)) {
                    let inner = std::mem::replace(&mut **c, Expr::Unit);
                    **c = Expr::Ascribe(Box::new(inner), Ty::Bool);
                }
            }
        });
    }
    riina_typechecker::check_program(&p).is_err()
}

/// A numeral larger than this is not compared: Coq's `nat` is unary.
const MAX_NAT: u64 = 100_000;

/// Generated programs per run (`RIINA_CONFORMANCE_COUNT` overrides it). The
/// mandate asks for at least 10,000 per change (S1.4).
pub const GENERATED_PER_RUN: usize = 10_000;

/// The generator's seed: `RIINA_CONFORMANCE_SEED` if set, else derived from
/// the commit being verified, so each change sees new programs and any run can
/// be repeated.
pub fn seed(repo: &Path) -> u64 {
    if let Some(s) = std::env::var("RIINA_CONFORMANCE_SEED")
        .ok()
        .and_then(|v| v.parse().ok())
    {
        return s;
    }
    let head = std::process::Command::new("git")
        .args(["-C", &repo.to_string_lossy(), "rev-parse", "HEAD"])
        .output()
        .ok()
        .map(|o| String::from_utf8_lossy(&o.stdout).trim().to_string())
        .unwrap_or_default();
    // FNV-1a of the commit id.
    head.bytes().fold(0xcbf2_9ce4_8422_2325_u64, |h, b| {
        (h ^ u64::from(b)).wrapping_mul(0x0100_0000_01b3)
    })
}

/// Mutants per run (`RIINA_CONFORMANCE_FUZZ` overrides it), of the
/// fixtures and of this run's well-typed generated programs.
pub const FUZZED_PER_RUN: usize = 5_000;

fn env_count(var: &str, default: usize) -> usize {
    std::env::var(var)
        .ok()
        .and_then(|v| v.parse().ok())
        .unwrap_or(default)
}

/// riinac's verdict on a program.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Verdict {
    /// Accepted, with the program's type and effect as core terms.
    Accepts { ty: Term, eff: Term },
    /// Rejected, with the name of riinac's error (`CapabilityViolation`).
    Rejects(String),
}

/// Where a program came from.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Origin {
    /// A file under [`SOURCES`], or a planted control.
    File,
    /// The generator, with the kind of program it set out to make.
    Generated(Kind),
    /// The fuzzer, with the operator that made the mutant.
    Fuzzed(Op),
}

/// One program to compare.
#[derive(Debug, Clone)]
pub struct Case {
    pub name: String,
    pub origin: Origin,
    pub term: Term,
    pub riinac: Verdict,
    /// The known class riinac's acceptance falls in, if any.
    pub known: Option<&'static str>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Outcome {
    BothAccept,
    BothReject,
    /// riinac accepts a program Coq rejects.
    Soundness,
    /// A soundness discrepancy in a [`KNOWN_SOUNDNESS_CLASSES`] class.
    Known,
    /// Both accept, with a different type or effect.
    Mismatch,
    /// riinac rejects a program Coq accepts.
    Completeness,
}

pub fn classify(riinac: &Verdict, coq: u8) -> Outcome {
    match (riinac, coq) {
        (Verdict::Accepts { .. }, 1) => Outcome::BothAccept,
        (Verdict::Accepts { .. }, 2) => Outcome::Mismatch,
        (Verdict::Accepts { .. }, _) => Outcome::Soundness,
        (Verdict::Rejects(_), 0) => Outcome::BothReject,
        (Verdict::Rejects(_), _) => Outcome::Completeness,
    }
}

/// The planted controls and the outcome each must produce.
fn controls() -> Vec<(Case, Outcome)> {
    let unit = || Term::Ctor("EUnit", vec![]);
    let accepts = |ty: &'static str| Verdict::Accepts {
        ty: Term::Ctor(ty, vec![]),
        eff: Term::Ctor("EffPure", vec![]),
    };
    let ill = Term::Ctor("EApp", vec![Term::Ctor("EInt", vec![Term::Nat(1)]), unit()]);
    vec![
        (
            Case {
                name: "control: an accepted term".into(),
                origin: Origin::File,
                term: unit(),
                riinac: accepts("TUnit"),
                known: None,
            },
            Outcome::BothAccept,
        ),
        (
            Case {
                name: "control: an ill-typed term claimed accepted".into(),
                origin: Origin::File,
                term: ill,
                riinac: accepts("TUnit"),
                known: None,
            },
            Outcome::Soundness,
        ),
        (
            Case {
                name: "control: a wrong type claimed".into(),
                origin: Origin::File,
                term: unit(),
                riinac: accepts("TInt"),
                known: None,
            },
            Outcome::Mismatch,
        ),
    ]
}

/// A core term in Coq syntax.
pub fn to_coq(t: &Term) -> String {
    match t {
        Term::Ctor(name, args) if args.is_empty() => (*name).to_string(),
        Term::Ctor(name, args) => {
            let parts: Vec<String> = args.iter().map(to_coq).collect();
            format!("({name} {})", parts.join(" "))
        }
        Term::Nat(n) => n.to_string(),
        Term::Bool(b) => b.to_string(),
        Term::Str(s) if s.bytes().all(|b| (0x20..=0x7e).contains(&b)) => {
            format!("\"{}\"", s.replace('"', "\"\""))
        }
        Term::Str(s) => {
            let bytes: Vec<String> = s.bytes().map(|b| format!("ascii_of_nat {b}")).collect();
            format!("(string_of_list_ascii [{}])", bytes.join("; "))
        }
        Term::List(items) if items.is_empty() => "(@nil string)".to_string(),
        Term::List(items) => {
            let parts: Vec<String> = items.iter().map(to_coq).collect();
            format!("[{}]", parts.join("; "))
        }
    }
}

fn constructors(t: &Term, out: &mut BTreeSet<&'static str>) {
    match t {
        Term::Ctor(name, args) => {
            if emit_core::SIGNATURES
                .iter()
                .any(|(sort, n, _)| *sort == emit_core::Sort::Expr && n == name)
            {
                out.insert(name);
            }
            args.iter().for_each(|a| constructors(a, out));
        }
        Term::List(items) => items.iter().for_each(|a| constructors(a, out)),
        _ => {}
    }
}

fn largest_nat(t: &Term) -> u64 {
    match t {
        Term::Nat(n) => *n,
        Term::Ctor(_, args) | Term::List(args) => args.iter().map(largest_nat).max().unwrap_or(0),
        _ => 0,
    }
}

/// The Coq file: the comparison, then one `Eval` per case, in order.
pub fn coq_script(cases: &[Case]) -> String {
    let mut out = String::from(
        "From Stdlib Require Import String Ascii List Bool.\n\
         Import ListNotations.\n\
         Open Scope string_scope.\n\
         From RIINA Require Import foundations.Syntax foundations.StepFn foundations.TypeCheckFn.\n\
         Definition riina_conformance (t : expr) (T : ty) (e : effect) : nat :=\n\
         \x20 match type_check_fn nil nil LPublic t with\n\
         \x20 | None => 0\n\
         \x20 | Some (T', e') => if andb (ty_eqb T' T) (effect_eqb e' e) then 1 else 2\n\
         \x20 end.\n",
    );
    for c in cases {
        let (ty, eff) = match &c.riinac {
            Verdict::Accepts { ty, eff } => (to_coq(ty), to_coq(eff)),
            // Unused: a rejecting verdict is compared on accept/reject alone.
            Verdict::Rejects(_) => ("TUnit".to_string(), "EffPure".to_string()),
        };
        out.push_str(&format!(
            "Eval vm_compute in riina_conformance {} {ty} {eff}.\n",
            to_coq(&c.term)
        ));
    }
    out
}

/// The numbers Coq printed, one per `Eval`.
pub fn parse_coq_output(out: &str) -> Vec<u8> {
    out.lines()
        .filter_map(|l| {
            l.trim()
                .strip_prefix("= ")
                .and_then(|n| n.trim().parse().ok())
        })
        .collect()
}

/// What a run found.
#[derive(Debug, Default)]
pub struct Report {
    pub compared: Vec<(String, Origin, Outcome)>,
    /// Programs riinac parses but that use a construct the core lacks, by the
    /// CORE_MAPPING row of their first one.
    pub outside: BTreeMap<String, usize>,
    /// Programs emitted but not compared, with the reason.
    pub not_compared: Vec<(String, String)>,
    /// Files that do not parse or link (no term to compare).
    pub unparsed: usize,
    /// The `expr` constructors the compared terms use.
    pub exercised: BTreeSet<&'static str>,
    /// The generator's seed and, per kind, how each outcome came out.
    pub seed: u64,
    pub generated: BTreeMap<(Kind, Outcome), usize>,
    /// Generated programs that did not emit: a generator bug.
    pub generator_errors: Vec<String>,
    /// Per operator, how each mutant's outcome came out, and how many
    /// mutants left the core (a renaming that makes two functions mutually
    /// recursive, say), so were not compared.
    pub fuzzed: BTreeMap<(Op, Outcome), usize>,
    pub fuzz_outside: usize,
    /// The generated and fuzzed completeness gaps, by riinac's error.
    pub gaps_by_reason: BTreeMap<String, usize>,
}

impl Report {
    /// The `expr` constructors no compared term uses.
    pub fn unexercised(&self) -> Vec<&'static str> {
        emit_core::SIGNATURES
            .iter()
            .filter(|(sort, name, _)| {
                *sort == emit_core::Sort::Expr && !self.exercised.contains(name)
            })
            .map(|(_, name, _)| *name)
            .collect()
    }

    pub fn count(&self, o: Outcome) -> usize {
        self.compared.iter().filter(|(_, _, x)| *x == o).count()
    }

    /// Everything that fails the gate.
    pub fn failures(&self) -> Vec<String> {
        let mut out = Vec::new();
        for (name, origin, o) in &self.compared {
            match o {
                Outcome::Soundness => {
                    out.push(format!("SOUNDNESS: riinac accepts {name}, Coq rejects it"));
                }
                Outcome::Mismatch => out.push(format!(
                    "SOUNDNESS: riinac and Coq give {name} different types or effects"
                )),
                // A generated or fuzzed program's name is not stable across
                // seeds, so its gap is counted and reported, not listed.
                Outcome::Completeness
                    if *origin == Origin::File
                        && !KNOWN_COMPLETENESS_GAPS.iter().any(|(n, _)| n == name) =>
                {
                    out.push(format!(
                        "completeness gap not tracked: Coq accepts {name}, riinac rejects it (list it in \
                         conformance::KNOWN_COMPLETENESS_GAPS with the reason, or fix riinac)"
                    ));
                }
                _ => {}
            }
        }
        for e in &self.generator_errors {
            out.push(format!("generator: {e}"));
        }
        for class in KNOWN_SOUNDNESS_CLASSES {
            if !self
                .compared
                .iter()
                .any(|(n, _, o)| n == class.witness && *o == Outcome::Known)
            {
                out.push(format!(
                    "the known class \"{}\" no longer holds for its witness {}: remove it from \
                     conformance::KNOWN_SOUNDNESS_CLASSES",
                    class.name, class.witness
                ));
            }
        }
        for (gap, _) in KNOWN_COMPLETENESS_GAPS {
            if !self
                .compared
                .iter()
                .any(|(n, _, o)| n == gap && *o == Outcome::Completeness)
            {
                out.push(format!(
                    "{gap} is listed as a completeness gap but is not one now; remove it"
                ));
            }
        }
        out
    }
}

/// The name of a riinac type error's variant, for counting rejections by
/// reason.
fn error_name(e: &riina_typechecker::TypeError) -> String {
    format!("{e:?}")
        .split(|c: char| !c.is_alphanumeric() && c != '_')
        .next()
        .unwrap_or_default()
        .to_string()
}

/// riinac's verdict on `program`, or why it cannot be compared, and the known
/// class an acceptance falls in.
fn verdict(program: &Program) -> Result<(Verdict, Option<&'static str>), String> {
    match riina_typechecker::check_program(program) {
        Err(e) => Ok((Verdict::Rejects(error_name(&e)), None)),
        Ok((_, ty, eff)) => match (emit_core::core_ty(&ty), emit_core::core_effect_set(eff)) {
            (Ok(ty), Ok(eff)) => {
                let known = KNOWN_SOUNDNESS_CLASSES
                    .iter()
                    .find(|k| (k.detect)(program))
                    .map(|k| k.name);
                Ok((Verdict::Accepts { ty, eff }, known))
            }
            (Err(u), _) | (_, Err(u)) => Err(format!(
                "riinac's result type or effect is outside the core: {u}"
            )),
        },
    }
}

fn rii_files(dir: &Path, out: &mut Vec<PathBuf>) {
    let Ok(rd) = std::fs::read_dir(dir) else {
        return;
    };
    let mut entries: Vec<PathBuf> = rd.flatten().map(|e| e.path()).collect();
    entries.sort();
    for p in entries {
        if p.is_dir() {
            rii_files(&p, out);
        } else if p.extension().is_some_and(|e| e == "rii") {
            out.push(p);
        }
    }
}

/// riinac's verdict and the core term for each program under [`SOURCES`],
/// for `generated` programs from the generator and for `fuzzed` mutants.
pub fn collect(repo: &Path, generated: usize, fuzzed: usize) -> (Vec<Case>, Report) {
    let builtins = riina_typechecker::register_builtin_types(&riina_typechecker::Context::new());
    let is_builtin = |x: &str| builtins.lookup(&x.to_string()).is_some();
    let mut report = Report::default();
    let mut cases = Vec::new();
    // What the fuzzer mutates: every compared file but a known class's
    // witness, and the well-typed generated programs.
    let mut seeds = Vec::new();
    let mut files = Vec::new();
    for src in SOURCES {
        rii_files(&repo.join(src), &mut files);
    }
    for path in files {
        let name = path
            .strip_prefix(repo)
            .unwrap_or(&path)
            .to_string_lossy()
            .into_owned();
        let Ok(source) = std::fs::read_to_string(&path) else {
            report.unparsed += 1;
            continue;
        };
        let Ok(program) = riina_parser::modules::resolve_program(&path, &source) else {
            report.unparsed += 1;
            continue;
        };
        let term = match emit_core::elaborate(&program.clone().desugar(), &is_builtin) {
            Ok(t) => t,
            Err(u) => {
                *report.outside.entry(u.row).or_default() += 1;
                continue;
            }
        };
        if largest_nat(&term) > MAX_NAT {
            report.not_compared.push((
                name,
                format!("a numeral above {MAX_NAT} (Coq's nat is unary)"),
            ));
            continue;
        }
        let (riinac, known) = match verdict(&program) {
            Ok(v) => v,
            Err(why) => {
                report.not_compared.push((name, why));
                continue;
            }
        };
        if !KNOWN_SOUNDNESS_CLASSES.iter().any(|k| k.witness == name) {
            seeds.push(program);
        }
        cases.push(Case {
            name,
            origin: Origin::File,
            term,
            riinac,
            known,
        });
    }
    report.seed = seed(repo);
    for g in crate::conformance_gen::generate(report.seed, generated) {
        let term = match emit_core::elaborate(&g.program.clone().desugar(), &is_builtin) {
            Ok(t) => t,
            Err(u) => {
                report
                    .generator_errors
                    .push(format!("{} does not emit: {u}", g.name));
                continue;
            }
        };
        let (riinac, known) = match verdict(&g.program) {
            Ok(v) => v,
            Err(why) => {
                report.generator_errors.push(format!("{}: {why}", g.name));
                continue;
            }
        };
        if g.kind == Kind::WellTyped {
            seeds.push(g.program);
        }
        cases.push(Case {
            name: g.name,
            origin: Origin::Generated(g.kind),
            term,
            riinac,
            known,
        });
    }
    for m in crate::conformance_fuzz::fuzz(&seeds, report.seed, fuzzed) {
        let Ok(term) = emit_core::elaborate(&m.program.clone().desugar(), &is_builtin) else {
            report.fuzz_outside += 1;
            continue;
        };
        let (riinac, known) = match verdict(&m.program) {
            Ok(v) => v,
            Err(why) => {
                report.not_compared.push((m.name, why));
                continue;
            }
        };
        cases.push(Case {
            name: m.name,
            origin: Origin::Fuzzed(m.op),
            term,
            riinac,
            known,
        });
    }
    (cases, report)
}

/// Run the comparison with `rocq` in `coq_dir` (whose `.vo` files must be
/// built). An `Err` is a broken run, not a discrepancy.
pub fn run(repo: &Path, coq_dir: &Path, rocq: &Path, scratch: &Path) -> Result<Report, String> {
    let (cases, mut report) = collect(
        repo,
        env_count("RIINA_CONFORMANCE_COUNT", GENERATED_PER_RUN),
        env_count("RIINA_CONFORMANCE_FUZZ", FUZZED_PER_RUN),
    );
    let ctl = controls();
    let all: Vec<Case> = ctl
        .iter()
        .map(|(c, _)| c.clone())
        .chain(cases.iter().cloned())
        .collect();
    let file = scratch.join("riina_conformance.v");
    std::fs::write(&file, coq_script(&all))
        .map_err(|e| format!("cannot write {}: {e}", file.display()))?;
    let out = std::process::Command::new(rocq)
        .args([
            "compile",
            "-q",
            "-w",
            "-deprecated-native-compiler-option",
            "-native-compiler",
            "no",
            "-Q",
            ".",
            "RIINA",
        ])
        .arg(&file)
        .current_dir(coq_dir)
        .output()
        .map_err(|e| format!("failed to run rocq: {e}"))?;
    let text = String::from_utf8_lossy(&out.stdout);
    if !out.status.success() {
        return Err(format!(
            "rocq failed on the conformance script: {}",
            String::from_utf8_lossy(&out.stderr)
                .lines()
                .take(6)
                .collect::<Vec<_>>()
                .join(" | ")
        ));
    }
    let verdicts = parse_coq_output(&text);
    if verdicts.len() != all.len() {
        return Err(format!(
            "Coq printed {} verdicts for {} programs",
            verdicts.len(),
            all.len()
        ));
    }
    for ((case, want), v) in ctl.iter().zip(&verdicts) {
        let got = classify(&case.riinac, *v);
        if got != *want {
            return Err(format!(
                "{} came out {got:?}, not {want:?}: the comparison cannot be trusted to catch a discrepancy",
                case.name
            ));
        }
    }
    for (case, v) in cases.iter().zip(&verdicts[ctl.len()..]) {
        let outcome = match classify(&case.riinac, *v) {
            Outcome::Soundness if case.known.is_some() => Outcome::Known,
            o => o,
        };
        if let (Outcome::Completeness, Verdict::Rejects(why)) = (outcome, &case.riinac) {
            if case.origin != Origin::File {
                *report.gaps_by_reason.entry(why.clone()).or_default() += 1;
            }
        }
        match case.origin {
            Origin::Generated(kind) => *report.generated.entry((kind, outcome)).or_default() += 1,
            Origin::Fuzzed(op) => *report.fuzzed.entry((op, outcome)).or_default() += 1,
            Origin::File => {}
        }
        report
            .compared
            .push((case.name.clone(), case.origin, outcome));
        constructors(&case.term, &mut report.exercised);
    }
    Ok(report)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn t(name: &'static str, args: Vec<Term>) -> Term {
        Term::Ctor(name, args)
    }

    #[test]
    fn outcomes() {
        let acc = Verdict::Accepts {
            ty: t("TUnit", vec![]),
            eff: t("EffPure", vec![]),
        };
        assert_eq!(classify(&acc, 1), Outcome::BothAccept);
        assert_eq!(classify(&acc, 0), Outcome::Soundness);
        assert_eq!(classify(&acc, 2), Outcome::Mismatch);
        let rej = Verdict::Rejects("TypeMismatch".into());
        assert_eq!(classify(&rej, 0), Outcome::BothReject);
        assert_eq!(classify(&rej, 1), Outcome::Completeness);
        assert_eq!(classify(&rej, 2), Outcome::Completeness);
    }

    #[test]
    fn coq_syntax() {
        let term = t(
            "ELet",
            vec![
                Term::Str("x".into()),
                t("EString", vec![Term::Str("say \"hi\"".into())]),
                t("EString", vec![Term::Str("ä".into())]),
            ],
        );
        assert_eq!(
            to_coq(&term),
            r#"(ELet "x" (EString "say ""hi""") (EString (string_of_list_ascii [ascii_of_nat 195; ascii_of_nat 164])))"#
        );
        assert_eq!(to_coq(&Term::List(vec![])), "(@nil string)");
        assert_eq!(
            to_coq(&Term::List(vec![
                Term::Str("a".into()),
                Term::Str("b".into())
            ])),
            r#"["a"; "b"]"#
        );
    }

    #[test]
    fn coq_output_is_read_in_order() {
        let out = "     = 1\n     : nat\n     = 0\n     : nat\n     = 2\n     : nat\n";
        assert_eq!(parse_coq_output(out), vec![1, 0, 2]);
    }

    #[test]
    fn the_script_has_one_eval_per_case_in_order() {
        let cases: Vec<Case> = controls().into_iter().map(|(c, _)| c).collect();
        let s = coq_script(&cases);
        let evals: Vec<&str> = s
            .lines()
            .filter(|l| l.starts_with("Eval vm_compute"))
            .collect();
        assert_eq!(evals.len(), 3);
        assert!(
            evals[1].contains("(EApp (EInt 1) EUnit) TUnit EffPure"),
            "{}",
            evals[1]
        );
    }

    #[test]
    fn an_untracked_gap_and_any_soundness_discrepancy_fail() {
        let file = |n: &str, o| (n.to_string(), Origin::File, o);
        let mut r = Report::default();
        for k in KNOWN_SOUNDNESS_CLASSES {
            r.compared.push(file(k.witness, Outcome::Known));
        }
        r.compared.push(file("ok.rii", Outcome::BothAccept));
        r.compared.push(file("no.rii", Outcome::BothReject));
        r.compared.push(file("known.rii", Outcome::Known));
        assert!(r.failures().is_empty());
        r.compared.push(file("gap.rii", Outcome::Completeness));
        assert_eq!(r.failures().len(), 1);
        r.compared.push(file("bad.rii", Outcome::Soundness));
        r.compared.push(file("ty.rii", Outcome::Mismatch));
        assert_eq!(r.failures().len(), 3);
        // A generated or fuzzed gap is reported, not failed; a generated or
        // fuzzed discrepancy fails like any other.
        let op = Origin::Fuzzed(Op::RenameVariable);
        r.compared
            .push(("fuzz:1".into(), op, Outcome::Completeness));
        r.compared.push((
            "gen:1".into(),
            Origin::Generated(Kind::TypeError),
            Outcome::Completeness,
        ));
        assert_eq!(r.failures().len(), 3);
        r.compared.push(("fuzz:2".into(), op, Outcome::Soundness));
        assert_eq!(r.failures().len(), 4);
        // A known class whose witness is no longer in it must be removed.
        r.compared
            .retain(|(n, _, _)| !KNOWN_SOUNDNESS_CLASSES.iter().any(|k| k.witness == n));
        assert_eq!(r.failures().len(), 4 + KNOWN_SOUNDNESS_CLASSES.len());
    }

    fn parse(source: &str) -> Program {
        riina_parser::Parser::new(source)
            .parse_program()
            .expect("parses")
    }

    #[test]
    fn the_secret_branch_class_is_recognised_by_what_riinac_does() {
        let secret = parse(
            "fungsi utama() -> () kesan Bersih { biar h = kalau sulit betul { 1 } lain { 2 }; () }",
        );
        assert!(riina_typechecker::check_program(&secret).is_ok());
        assert!(branches_on_a_secret(&secret));
        let public = parse(
            "fungsi utama() -> Nombor kesan Bersih { biar b = betul; kalau b { 1 } lain { 2 } }",
        );
        assert!(riina_typechecker::check_program(&public).is_ok());
        assert!(!branches_on_a_secret(&public));
        // `bukan` is an `If` too.
        let negated = parse("fungsi utama() -> () kesan Bersih { biar h = bukan sulit betul; () }");
        if riina_typechecker::check_program(&negated).is_ok() {
            assert!(branches_on_a_secret(&negated));
        }
    }

    #[test]
    fn every_fixture_is_compared() {
        // The fixtures are written to stay inside the core: each must emit,
        // and its name says riinac's verdict.
        let repo = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../..");
        let (cases, report) = collect(&repo, 0, 0);
        let fixtures: Vec<&Case> = cases
            .iter()
            .filter(|c| c.name.contains("tests/conformance/"))
            .collect();
        assert!(
            fixtures.len() >= 20,
            "only {} fixtures emitted; outside the core: {:?}",
            fixtures.len(),
            report.outside
        );
        let mut on_disk = Vec::new();
        rii_files(&repo.join(SOURCES[1]), &mut on_disk);
        assert_eq!(
            fixtures.len(),
            on_disk.len(),
            "a fixture did not emit or was not compared: {:?}",
            report.not_compared
        );
        for c in fixtures {
            let accepts = matches!(c.riinac, Verdict::Accepts { .. });
            let file = c.name.rsplit('/').next().unwrap_or_default();
            assert_eq!(
                accepts,
                file.starts_with("accept_"),
                "{}: riinac's verdict does not match the name",
                c.name
            );
        }
        // Each known class is detected in its witness, and in no other file.
        for k in KNOWN_SOUNDNESS_CLASSES {
            assert!(
                cases
                    .iter()
                    .any(|c| c.name == k.witness && c.known == Some(k.name)),
                "\"{}\" is not detected in its witness {}",
                k.name,
                k.witness
            );
        }
        let others: Vec<&str> = cases
            .iter()
            .filter(|c| {
                c.known.is_some() && !KNOWN_SOUNDNESS_CLASSES.iter().any(|k| k.witness == c.name)
            })
            .map(|c| c.name.as_str())
            .collect();
        assert!(others.is_empty(), "files in a known class: {others:?}");
    }

    #[test]
    fn every_mutant_is_compared_or_accounted_for() {
        let repo = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../..");
        let (cases, report) = collect(&repo, 200, 300);
        let fuzzed = cases
            .iter()
            .filter(|c| matches!(c.origin, Origin::Fuzzed(_)))
            .count();
        let not_compared = report
            .not_compared
            .iter()
            .filter(|(n, _)| n.starts_with("fuzz:"))
            .count();
        assert_eq!(fuzzed + report.fuzz_outside + not_compared, 300);
        assert!(
            fuzzed >= 250,
            "only {fuzzed} of 300 mutants stayed in the core"
        );
        assert!(cases
            .iter()
            .any(|c| c.name.starts_with("fuzz:") && matches!(c.riinac, Verdict::Rejects(_))));
    }
}
