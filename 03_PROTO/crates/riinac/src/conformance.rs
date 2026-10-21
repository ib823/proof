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

use std::collections::{BTreeMap, BTreeSet};
use std::path::{Path, PathBuf};

use crate::emit_core::{self, Term};

/// Where the programs come from: the example corpus and the conformance
/// fixtures, which are written to stay inside the core.
pub const SOURCES: &[&str] = &["07_EXAMPLES", "03_PROTO/crates/riinac/tests/conformance"];

/// Programs riinac rejects and Coq accepts, each with the reason.
pub const KNOWN_COMPLETENESS_GAPS: &[(&str, &str)] = &[];

/// A numeral larger than this is not compared: Coq's `nat` is unary.
const MAX_NAT: u64 = 100_000;

/// riinac's verdict on a program.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Verdict {
    /// Accepted, with the program's type and effect as core terms.
    Accepts {
        ty: Term,
        eff: Term,
    },
    Rejects,
}

/// One program to compare.
#[derive(Debug, Clone)]
pub struct Case {
    pub name: String,
    pub term: Term,
    pub riinac: Verdict,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Outcome {
    BothAccept,
    BothReject,
    /// riinac accepts a program Coq rejects.
    Soundness,
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
        (Verdict::Rejects, 0) => Outcome::BothReject,
        (Verdict::Rejects, _) => Outcome::Completeness,
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
                term: unit(),
                riinac: accepts("TUnit"),
            },
            Outcome::BothAccept,
        ),
        (
            Case {
                name: "control: an ill-typed term claimed accepted".into(),
                term: ill,
                riinac: accepts("TUnit"),
            },
            Outcome::Soundness,
        ),
        (
            Case {
                name: "control: a wrong type claimed".into(),
                term: unit(),
                riinac: accepts("TInt"),
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
            Verdict::Rejects => ("TUnit".to_string(), "EffPure".to_string()),
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
    pub compared: Vec<(String, Outcome)>,
    /// Programs riinac parses but that use a construct the core lacks, by the
    /// CORE_MAPPING row of their first one.
    pub outside: BTreeMap<String, usize>,
    /// Programs emitted but not compared, with the reason.
    pub not_compared: Vec<(String, String)>,
    /// Files that do not parse or link (no term to compare).
    pub unparsed: usize,
    /// The `expr` constructors the compared terms use.
    pub exercised: BTreeSet<&'static str>,
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
        self.compared.iter().filter(|(_, x)| *x == o).count()
    }

    /// Everything that fails the gate.
    pub fn failures(&self) -> Vec<String> {
        let mut out = Vec::new();
        for (name, o) in &self.compared {
            match o {
                Outcome::Soundness => out.push(format!("SOUNDNESS: riinac accepts {name}, Coq rejects it")),
                Outcome::Mismatch => {
                    out.push(format!("SOUNDNESS: riinac and Coq give {name} different types or effects"))
                }
                Outcome::Completeness if !KNOWN_COMPLETENESS_GAPS.iter().any(|(n, _)| n == name) => out.push(format!(
                    "completeness gap not tracked: Coq accepts {name}, riinac rejects it (list it in \
                     conformance::KNOWN_COMPLETENESS_GAPS with the reason, or fix riinac)"
                )),
                _ => {}
            }
        }
        for (gap, _) in KNOWN_COMPLETENESS_GAPS {
            if !self
                .compared
                .iter()
                .any(|(n, o)| n == gap && *o == Outcome::Completeness)
            {
                out.push(format!(
                    "{gap} is listed as a completeness gap but is not one now; remove it"
                ));
            }
        }
        out
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

/// riinac's verdict and the core term for each program under [`SOURCES`].
pub fn collect(repo: &Path) -> (Vec<Case>, Report) {
    let builtins = riina_typechecker::register_builtin_types(&riina_typechecker::Context::new());
    let is_builtin = |x: &str| builtins.lookup(&x.to_string()).is_some();
    let mut report = Report::default();
    let mut cases = Vec::new();
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
        let riinac = match riina_typechecker::check_program(&program) {
            Err(_) => Verdict::Rejects,
            Ok((_, ty, eff)) => match (emit_core::core_ty(&ty), emit_core::core_effect_set(eff)) {
                (Ok(ty), Ok(eff)) => Verdict::Accepts { ty, eff },
                (Err(u), _) | (_, Err(u)) => {
                    report.not_compared.push((
                        name,
                        format!("riinac's result type or effect is outside the core: {u}"),
                    ));
                    continue;
                }
            },
        };
        cases.push(Case { name, term, riinac });
    }
    (cases, report)
}

/// Run the comparison with `rocq` in `coq_dir` (whose `.vo` files must be
/// built). An `Err` is a broken run, not a discrepancy.
pub fn run(repo: &Path, coq_dir: &Path, rocq: &Path, scratch: &Path) -> Result<Report, String> {
    let (cases, mut report) = collect(repo);
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
        report
            .compared
            .push((case.name.clone(), classify(&case.riinac, *v)));
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
        assert_eq!(classify(&Verdict::Rejects, 0), Outcome::BothReject);
        assert_eq!(classify(&Verdict::Rejects, 1), Outcome::Completeness);
        assert_eq!(classify(&Verdict::Rejects, 2), Outcome::Completeness);
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
        let mut r = Report::default();
        r.compared.push(("ok.rii".into(), Outcome::BothAccept));
        r.compared.push(("no.rii".into(), Outcome::BothReject));
        assert!(r.failures().is_empty());
        r.compared.push(("gap.rii".into(), Outcome::Completeness));
        assert_eq!(r.failures().len(), 1);
        r.compared.push(("bad.rii".into(), Outcome::Soundness));
        r.compared.push(("ty.rii".into(), Outcome::Mismatch));
        assert_eq!(r.failures().len(), 3);
    }

    #[test]
    fn every_fixture_is_compared() {
        // The fixtures are written to stay inside the core: each must emit,
        // and its name says riinac's verdict.
        let repo = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../..");
        let (cases, report) = collect(&repo);
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
    }
}
