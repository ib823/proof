// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The REQ-111 mutation fuzzer: small edits to programs inside the Coq core,
//! for the differential in `conformance.rs`.
//!
//! The generator (`conformance_gen.rs`) builds programs from types; this takes
//! existing ones (the conformance fixtures and well-typed generated programs)
//! and changes one thing, so its mutants sit next to programs both checkers
//! accept. Each mutant is compared like any other program. A mutant that is
//! still well typed is fine: what matters is that riinac and Coq agree.
//!
//! Operators, by what they usually break:
//!
//! * types: a literal of another type, `fst`/`snd` swapped, `inl`/`inr`
//!   swapped, a subterm replaced by another of the same program, a binder's
//!   or a declaration's type changed, an argument dropped, a variable renamed;
//! * flow: a reference raised above the public level, an effect removed from a
//!   declaration, a performed or required effect raised above the declaration,
//!   a declassification given another proof, a secret passed where a public
//!   value is expected, a secret stored in a public reference.
//!
//! A mutant that comes to branch on a secret (a renamed variable, say) is
//! rejected by both checkers: riinac branches only on public values.

use riina_types::{Effect, EffectSet, Expr, Program, SecurityLevel, TopLevelDecl, Ty};

use crate::conformance_gen::Rng;

/// The core subterms of `e`, for traversal. A construct outside the core has
/// none listed: fuzzed programs stay inside the core.
pub fn children_mut(e: &mut Expr) -> Vec<&mut Expr> {
    match e {
        Expr::Lam(_, _, b)
        | Expr::Fst(b)
        | Expr::Snd(b)
        | Expr::Inl(b, _)
        | Expr::Inr(b, _)
        | Expr::Ascribe(b, _)
        | Expr::Perform(_, b)
        | Expr::Ref(b, _)
        | Expr::Deref(b)
        | Expr::Classify(b)
        | Expr::Prove(b)
        | Expr::Require(_, b)
        | Expr::Grant(_, b) => vec![&mut **b],
        Expr::App(a, b)
        | Expr::Pair(a, b)
        | Expr::Let(_, _, a, b)
        | Expr::Handle(a, _, b)
        | Expr::Assign(a, b)
        | Expr::Declassify(a, b)
        | Expr::LetRec(_, _, a, b) => vec![&mut **a, &mut **b],
        Expr::Case(s, _, a, _, b) | Expr::If(s, a, b) => vec![&mut **s, &mut **a, &mut **b],
        Expr::LetRecGroup(group, body) => {
            let mut out: Vec<&mut Expr> = group.iter_mut().map(|(_, _, e)| e).collect();
            out.push(&mut **body);
            out
        }
        _ => Vec::new(),
    }
}

/// Apply `f` to every node of `e`, outermost first.
pub fn for_each_mut(e: &mut Expr, f: &mut dyn FnMut(&mut Expr)) {
    f(e);
    for c in children_mut(e) {
        for_each_mut(c, f);
    }
}

fn size(e: &mut Expr) -> usize {
    let mut n = 0;
    for_each_mut(e, &mut |_| n += 1);
    n
}

fn nth_mut<'a>(e: &'a mut Expr, n: &mut usize) -> Option<&'a mut Expr> {
    if *n == 0 {
        return Some(e);
    }
    *n -= 1;
    for c in children_mut(e) {
        if let Some(x) = nth_mut(c, n) {
            return Some(x);
        }
    }
    None
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Op {
    LiteralType,
    SwapProjection,
    SwapInjection,
    ReplaceSubterm,
    ChangeAnnotation,
    DropArgument,
    RenameVariable,
    RaiseRefLevel,
    DropDeclaredEffect,
    RaiseEffect,
    BreakProof,
    SecretArgument,
    SecretIntoPublicRef,
}

impl Op {
    pub const ALL: [Self; 13] = [
        Self::LiteralType,
        Self::SwapProjection,
        Self::SwapInjection,
        Self::ReplaceSubterm,
        Self::ChangeAnnotation,
        Self::DropArgument,
        Self::RenameVariable,
        Self::RaiseRefLevel,
        Self::DropDeclaredEffect,
        Self::RaiseEffect,
        Self::BreakProof,
        Self::SecretArgument,
        Self::SecretIntoPublicRef,
    ];

    pub const fn label(self) -> &'static str {
        match self {
            Self::LiteralType => "literal-type",
            Self::SwapProjection => "swap-projection",
            Self::SwapInjection => "swap-injection",
            Self::ReplaceSubterm => "replace-subterm",
            Self::ChangeAnnotation => "change-annotation",
            Self::DropArgument => "drop-argument",
            Self::RenameVariable => "rename-variable",
            Self::RaiseRefLevel => "raise-ref-level",
            Self::DropDeclaredEffect => "drop-declared-effect",
            Self::RaiseEffect => "raise-effect",
            Self::BreakProof => "break-proof",
            Self::SecretArgument => "secret-argument",
            Self::SecretIntoPublicRef => "secret-into-public-ref",
        }
    }

    /// Whether the operator targets information flow or effects.
    pub const fn is_flow(self) -> bool {
        matches!(
            self,
            Self::RaiseRefLevel
                | Self::DropDeclaredEffect
                | Self::RaiseEffect
                | Self::BreakProof
                | Self::SecretArgument
                | Self::SecretIntoPublicRef
        )
    }
}

pub struct Mutant {
    pub name: String,
    pub op: Op,
    pub program: Program,
}

/// Effects in Coq's order; a raised effect is the next one up.
const COQ_ORDER: &[Effect] = &[
    Effect::Pure,
    Effect::Read,
    Effect::Write,
    Effect::FileSystem,
    Effect::Network,
    Effect::NetworkSecure,
    Effect::Crypto,
    Effect::Random,
    Effect::System,
    Effect::Time,
    Effect::Process,
    Effect::Panel,
    Effect::Zirah,
    Effect::Benteng,
    Effect::Sandi,
    Effect::Menara,
    Effect::Gapura,
];

fn coq_level(e: Effect) -> usize {
    COQ_ORDER.iter().position(|x| *x == e).unwrap_or(0)
}

fn other_literal(rng: &mut Rng, e: &Expr) -> Expr {
    loop {
        let lit = match rng.below(4) {
            0 => Expr::Unit,
            1 => Expr::Bool(rng.chance(50)),
            2 => Expr::Int(rng.below(20) as u64),
            _ => Expr::String(format!("m{}", rng.below(10))),
        };
        if std::mem::discriminant(&lit) != std::mem::discriminant(e) {
            return lit;
        }
    }
}

fn other_base(rng: &mut Rng, t: &Ty) -> Ty {
    loop {
        let u = [Ty::Unit, Ty::Bool, Ty::Int, Ty::String][rng.below(4)].clone();
        if &u != t {
            return u;
        }
    }
}

fn functions(p: &mut Program) -> Vec<&mut TopLevelDecl> {
    p.decls
        .iter_mut()
        .filter(|d| matches!(d, TopLevelDecl::Function { .. }))
        .collect()
}

/// Whether `op` has something to change at `e` itself.
fn applies(op: Op, e: &Expr) -> bool {
    match (op, e) {
        (Op::LiteralType, Expr::Unit | Expr::Bool(_) | Expr::Int(_) | Expr::String(_))
        | (Op::SwapProjection, Expr::Fst(_) | Expr::Snd(_))
        | (Op::SwapInjection, Expr::Inl(..) | Expr::Inr(..))
        | (Op::ReplaceSubterm, _)
        | (Op::ChangeAnnotation, Expr::Lam(..))
        | (Op::DropArgument, Expr::App(..))
        | (Op::RenameVariable, Expr::Var(_))
        | (Op::RaiseRefLevel, Expr::Ref(_, SecurityLevel::Public))
        | (Op::RaiseEffect, Expr::Perform(..) | Expr::Require(..))
        | (Op::SecretIntoPublicRef, Expr::Assign(..)) => true,
        (Op::BreakProof, Expr::Declassify(_, p)) => {
            matches!(&**p, Expr::Prove(inner) if matches!(**inner, Expr::Classify(_)))
        }
        (Op::SecretArgument, Expr::App(_, a)) => !matches!(**a, Expr::Unit),
        _ => false,
    }
}

/// Try `op` once on `program`; `None` if it found nothing to change.
fn apply(rng: &mut Rng, op: Op, program: &mut Program) -> Option<()> {
    let mut fns = functions(program);
    if fns.is_empty() {
        return None;
    }
    let i = rng.below(fns.len());
    let TopLevelDecl::Function {
        params,
        return_ty,
        effect,
        effect_set,
        body,
        ..
    } = &mut *fns[i]
    else {
        return None;
    };
    match op {
        Op::ChangeAnnotation if rng.chance(40) => {
            if !params.is_empty() && rng.chance(50) {
                let k = rng.below(params.len());
                params[k].1 = other_base(rng, &params[k].1);
            } else {
                *return_ty = other_base(rng, return_ty);
            }
            return Some(());
        }
        Op::DropDeclaredEffect => {
            let top = effect_set.iter().copied().max_by_key(|e| coq_level(*e))?;
            effect_set.retain(|e| *e != top);
            *effect = effect_set
                .iter()
                .copied()
                .max_by_key(|e| e.level())
                .unwrap_or(Effect::Pure);
            return Some(());
        }
        _ => {}
    }
    let declared = EffectSet::from_declaration(*effect, effect_set);
    // Names in the body, for renaming and for the subterm donor.
    let mut names = Vec::new();
    for_each_mut(body, &mut |e| {
        if let Expr::Var(x) = e {
            names.push(x.clone());
        }
    });
    let n = size(body);
    let donor = {
        let mut k = rng.below(n);
        nth_mut(body, &mut k).map(|e| e.clone())
    };
    // The nodes `op` can change, by preorder index: a rare one (a single
    // `ruj` in a large body) is found as easily as a common one.
    let mut candidates = Vec::new();
    let mut at = 0;
    for_each_mut(body, &mut |e| {
        if applies(op, e) {
            candidates.push(at);
        }
        at += 1;
    });
    for _ in 0..4 {
        if candidates.is_empty() {
            return None;
        }
        let mut k = candidates[rng.below(candidates.len())];
        let Some(node) = nth_mut(body, &mut k) else {
            continue;
        };
        let new = match (op, &*node) {
            (Op::LiteralType, Expr::Unit | Expr::Bool(_) | Expr::Int(_) | Expr::String(_)) => {
                Some(other_literal(rng, node))
            }
            (Op::SwapProjection, Expr::Fst(e)) => Some(Expr::Snd(e.clone())),
            (Op::SwapProjection, Expr::Snd(e)) => Some(Expr::Fst(e.clone())),
            (Op::SwapInjection, Expr::Inl(e, t)) => Some(Expr::Inr(e.clone(), t.clone())),
            (Op::SwapInjection, Expr::Inr(e, t)) => Some(Expr::Inl(e.clone(), t.clone())),
            (Op::ReplaceSubterm, _) => donor
                .clone()
                .filter(|d| d != node && !matches!(d, Expr::Classify(_))),
            (Op::ChangeAnnotation, Expr::Lam(x, t, b)) => {
                Some(Expr::Lam(x.clone(), other_base(rng, t), b.clone()))
            }
            (Op::DropArgument, Expr::App(f, _)) => Some((**f).clone()),
            (Op::RenameVariable, Expr::Var(x)) => {
                let others: Vec<&String> = names.iter().filter(|y| *y != x).collect();
                Some(Expr::Var(if others.is_empty() || rng.chance(20) {
                    "tiada_nama".to_string()
                } else {
                    others[rng.below(others.len())].clone()
                }))
            }
            (Op::RaiseRefLevel, Expr::Ref(e, SecurityLevel::Public)) => Some(Expr::Ref(
                e.clone(),
                [
                    SecurityLevel::Internal,
                    SecurityLevel::User,
                    SecurityLevel::Secret,
                ][rng.below(3)],
            )),
            (Op::RaiseEffect, Expr::Perform(_, e) | Expr::Require(_, e)) => {
                let top = declared.iter().map(coq_level).max().unwrap_or(0);
                if top + 1 >= COQ_ORDER.len() {
                    continue;
                }
                let above = COQ_ORDER[top + 1 + rng.below((COQ_ORDER.len() - top - 1).min(3))];
                Some(if matches!(node, Expr::Perform(..)) {
                    Expr::Perform(above, e.clone())
                } else {
                    Expr::Require(above, e.clone())
                })
            }
            (Op::BreakProof, Expr::Declassify(a, p)) => match &**p {
                Expr::Prove(inner) => match &**inner {
                    Expr::Classify(v) => Some(Expr::Declassify(
                        a.clone(),
                        Box::new(Expr::Prove(Box::new(Expr::Classify(Box::new(
                            other_literal(rng, v),
                        ))))),
                    )),
                    _ => None,
                },
                _ => None,
            },
            (Op::SecretArgument, Expr::App(f, a)) if !matches!(**a, Expr::Unit) => {
                Some(Expr::App(f.clone(), Box::new(Expr::Classify(a.clone()))))
            }
            (Op::SecretIntoPublicRef, Expr::Assign(r, v)) => {
                Some(Expr::Assign(r.clone(), Box::new(Expr::Classify(v.clone()))))
            }
            _ => None,
        };
        if let Some(new) = new {
            *node = new;
            return Some(());
        }
    }
    None
}

/// `count` mutants of the `seeds`, from `seed`. The operators are tried in
/// turn, so one with little to change in the seeds makes fewer mutants
/// instead of stalling the rest.
pub fn fuzz(seeds: &[Program], seed: u64, count: usize) -> Vec<Mutant> {
    let mut rng = Rng::new(seed ^ 0x6d75_7461_6e74_7321);
    let mut out = Vec::with_capacity(count);
    if seeds.is_empty() {
        return out;
    }
    let mut attempts = 0;
    while out.len() < count && attempts < count * 20 {
        let op = Op::ALL[attempts % Op::ALL.len()];
        attempts += 1;
        let from = &seeds[rng.below(seeds.len())];
        let mut program = from.clone();
        // A change can undo itself (a subterm replaced by an equal one
        // elsewhere): only a program that differs from its seed is a mutant.
        if apply(&mut rng, op, &mut program).is_some() && program.decls != from.decls {
            out.push(Mutant {
                name: format!("fuzz:{seed:016x}:{}:{}", out.len(), op.label()),
                op,
                program,
            });
        }
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    fn seeds(n: usize) -> Vec<Program> {
        crate::conformance_gen::generate(11, n)
            .into_iter()
            .filter(|g| g.kind == crate::conformance_gen::Kind::WellTyped)
            .map(|g| g.program)
            .collect()
    }

    fn shown(ms: &[Mutant]) -> Vec<String> {
        ms.iter()
            .map(|m| format!("{:?}", m.program.decls))
            .collect()
    }

    #[test]
    fn fuzzing_is_deterministic_and_covers_every_operator() {
        let s = seeds(1000);
        assert_eq!(shown(&fuzz(&s, 5, 1300)), shown(&fuzz(&s, 5, 1300)));
        assert_ne!(shown(&fuzz(&s, 5, 50)), shown(&fuzz(&s, 6, 50)));
        let ms = fuzz(&s, 5, 1300);
        assert_eq!(ms.len(), 1300);
        for op in Op::ALL {
            let n = ms.iter().filter(|m| m.op == op).count();
            assert!(n >= 20, "{op:?} made only {n} of 1,300 mutants");
        }
    }

    #[test]
    fn a_mutant_differs_from_its_seed() {
        for one in seeds(100).into_iter().take(20) {
            let from = format!("{:?}", one.decls);
            for m in fuzz(std::slice::from_ref(&one), 9, 26) {
                assert_ne!(
                    format!("{:?}", m.program.decls),
                    from,
                    "{} changed nothing",
                    m.name
                );
            }
        }
    }
}
