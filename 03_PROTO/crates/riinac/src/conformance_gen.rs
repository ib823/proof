// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The REQ-111 program generator: random riinac programs inside the Coq core,
//! for the differential in `conformance.rs`.
//!
//! Programs are built as riinac ASTs (`TopLevelDecl::Function`s and their
//! bodies), not as text, so they go through the same `check_program` and
//! `Program::desugar` as a parsed file, and every core constructor that has a
//! source form can be produced. Generation is type-directed: an expression is
//! built for a wanted type, from the constructors that can produce it, using
//! only the effects its function declares. Three kinds:
//!
//! * well typed by construction;
//! * a type error: one subterm replaced by one of another type;
//! * a flow violation: one information-flow or effect violation (a read of a
//!   reference above the public level, an effect the function does not
//!   declare, a declassification with the wrong proof, a call of a function
//!   with an undeclared effect).
//!
//! A branch on a secret is not among the violations: riinac accepts it (it
//! raises the security level of the branches) and the Coq core does not. That
//! is a known discrepancy, held by the fixture `accept_branch_on_secret.rii`
//! and `conformance::KNOWN_SOUNDNESS_DISCREPANCIES` until it is resolved.
//!
//! Generation is deterministic in the seed, so a reported program can be
//! regenerated.

use riina_types::{Effect, EffectSet, Expr, Ident, Program, SecurityLevel, TopLevelDecl, Ty};

/// splitmix64: small, fast and good enough to pick constructors.
pub struct Rng(u64);

impl Rng {
    pub const fn new(seed: u64) -> Self {
        Self(seed)
    }

    pub fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }

    pub fn below(&mut self, n: usize) -> usize {
        (self.next() % n as u64) as usize
    }

    pub fn chance(&mut self, percent: usize) -> bool {
        self.below(100) < percent
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Kind {
    WellTyped,
    TypeError,
    FlowViolation,
}

impl Kind {
    pub const fn label(self) -> &'static str {
        match self {
            Self::WellTyped => "well-typed",
            Self::TypeError => "type-error",
            Self::FlowViolation => "flow-violation",
        }
    }
}

pub struct Generated {
    pub name: String,
    pub kind: Kind,
    pub program: Program,
}

/// Effects a generated function may declare. `Mut` and `Alloc` have no Coq
/// counterpart, so they never appear.
const POOL: &[Effect] = &[
    Effect::Read,
    Effect::Write,
    Effect::FileSystem,
    Effect::Network,
    Effect::Crypto,
    Effect::Random,
    Effect::System,
    Effect::Time,
];

/// Effects in Coq's order (`effect_level`), for violations that must exceed
/// a declaration in both checkers.
const COQ_ORDER: &[Effect] = &[
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
    COQ_ORDER.iter().position(|x| *x == e).map_or(0, |i| i + 1)
}

fn max_level(set: EffectSet) -> usize {
    set.iter().map(coq_level).max().unwrap_or(0)
}

/// A function the generated code may call.
#[derive(Clone)]
struct Sig {
    name: Ident,
    params: Vec<Ty>,
    ret: Ty,
    eff: EffectSet,
}

/// What an expression may use.
struct Scope<'a> {
    vars: Vec<(Ident, Ty)>,
    funs: &'a [Sig],
    allow: EffectSet,
}

impl Scope<'_> {
    fn may(&self, e: Effect) -> bool {
        self.allow.contains(e)
    }
}

struct Gen {
    rng: Rng,
    fresh: usize,
    /// A type error still to be planted in the current body.
    plant_type_error: bool,
}

fn holds_ref(t: &Ty) -> bool {
    match t {
        Ty::Ref(..) => true,
        Ty::Prod(a, b) | Ty::Sum(a, b) => holds_ref(a) || holds_ref(b),
        _ => false,
    }
}

fn boxed(e: Expr) -> Box<Expr> {
    Box::new(e)
}

fn app(f: Expr, a: Expr) -> Expr {
    Expr::App(boxed(f), boxed(a))
}

impl Gen {
    fn name(&mut self, prefix: &str) -> Ident {
        self.fresh += 1;
        format!("{prefix}{}", self.fresh)
    }

    fn base_ty(&mut self) -> Ty {
        match self.rng.below(4) {
            0 => Ty::Unit,
            1 => Ty::Bool,
            2 => Ty::Int,
            _ => Ty::String,
        }
    }

    /// A type for a value in `scope`. References need `Write` to build;
    /// functions are pure.
    fn ty(&mut self, depth: usize, scope: &Scope<'_>) -> Ty {
        if depth == 0 || self.rng.chance(45) {
            return self.base_ty();
        }
        match self.rng.below(5) {
            0 => Ty::Prod(
                Box::new(self.ty(depth - 1, scope)),
                Box::new(self.ty(depth - 1, scope)),
            ),
            1 => Ty::Sum(
                Box::new(self.ty(depth - 1, scope)),
                Box::new(self.ty(depth - 1, scope)),
            ),
            2 => Ty::Secret(Box::new(self.base_ty())),
            3 if scope.may(Effect::Write) => {
                Ty::Ref(Box::new(self.base_ty()), SecurityLevel::Public)
            }
            _ => Ty::Fn(
                Box::new(self.base_ty()),
                Box::new(self.base_ty()),
                EffectSet::PURE,
            ),
        }
    }

    fn other_base(&mut self, ty: &Ty) -> Ty {
        loop {
            let t = self.base_ty();
            if &t != ty {
                return t;
            }
        }
    }

    /// A closed literal of `ty`, using no effect except `Write` for a
    /// reference.
    fn literal(&mut self, ty: &Ty) -> Expr {
        match ty {
            Ty::Unit => Expr::Unit,
            Ty::Bool => Expr::Bool(self.rng.chance(50)),
            // Now and then any `u64`: the core's `EInt` is binary, so every
            // value is compared.
            Ty::Int if self.rng.chance(10) => Expr::Int(self.rng.next()),
            Ty::Int => Expr::Int(self.rng.below(20) as u64),
            Ty::String => Expr::String(format!("s{}", self.rng.below(10))),
            Ty::Prod(a, b) => Expr::Pair(boxed(self.literal(a)), boxed(self.literal(b))),
            Ty::Sum(a, b) => {
                if self.rng.chance(50) {
                    Expr::Inl(boxed(self.literal(a)), ty.clone())
                } else {
                    Expr::Inr(boxed(self.literal(b)), ty.clone())
                }
            }
            Ty::Secret(t) => Expr::Classify(boxed(self.literal(t))),
            Ty::Ref(t, l) => Expr::Ref(boxed(self.literal(t)), *l),
            Ty::Fn(a, b, _) => {
                let x = self.name("x");
                Expr::Lam(x, (**a).clone(), boxed(self.literal(b)))
            }
            other => unreachable!("the generator makes no {other:?}"),
        }
    }

    /// An expression of type `ty` whose effects are within `scope.allow`.
    #[allow(clippy::too_many_lines)]
    fn expr(&mut self, ty: &Ty, scope: &mut Scope<'_>, depth: usize) -> Expr {
        if self.plant_type_error && self.rng.chance(12) {
            self.plant_type_error = false;
            let wrong = self.other_base(ty);
            return self.literal(&wrong);
        }
        if depth == 0 || self.rng.chance(20) {
            let vars: Vec<Ident> = scope
                .vars
                .iter()
                .filter(|(_, t)| t == ty)
                .map(|(n, _)| n.clone())
                .collect();
            if !vars.is_empty() && self.rng.chance(60) {
                return Expr::Var(vars[self.rng.below(vars.len())].clone());
            }
            return self.literal(ty);
        }
        let d = depth - 1;
        // `!` on a Bool is negation (CORE_MAPPING `Expr::Deref`).
        if *ty == Ty::Bool && self.rng.chance(15) {
            return Expr::Deref(boxed(self.expr(ty, scope, d)));
        }
        // A cell: `biar c = ruj e @Awam; c := e2; !c` (or `()` without
        // `Baca`), so references and assignments are common wherever `Tulis`
        // is allowed.
        let read =
            scope.may(Effect::Read) && matches!(ty, Ty::Unit | Ty::Bool | Ty::Int | Ty::String);
        if scope.may(Effect::Write) && (read || *ty == Ty::Unit) && self.rng.chance(25) {
            let t = if read { ty.clone() } else { self.base_ty() };
            let init = self.expr(&t, scope, d);
            let c = self.name("c");
            scope.vars.push((
                c.clone(),
                Ty::Ref(Box::new(t.clone()), SecurityLevel::Public),
            ));
            let v = self.expr(&t, scope, d);
            scope.vars.pop();
            let assign = Expr::Assign(boxed(Expr::Var(c.clone())), boxed(v));
            let rest = if read {
                Expr::Deref(boxed(Expr::Var(c.clone())))
            } else {
                Expr::Unit
            };
            let u = self.name("u");
            return Expr::Let(
                c,
                None,
                boxed(Expr::Ref(boxed(init), SecurityLevel::Public)),
                boxed(Expr::Let(u, None, boxed(assign), boxed(rest))),
            );
        }
        loop {
            match self.rng.below(15) {
                // let x = e1 in e2
                0 | 1 => {
                    let t = self.ty(1, scope);
                    let bound = self.expr(&t, scope, d);
                    let x = self.name("v");
                    scope.vars.push((x.clone(), t));
                    let body = self.expr(ty, scope, d);
                    scope.vars.pop();
                    return Expr::Let(x, None, boxed(bound), boxed(body));
                }
                2 => {
                    let c = self.expr(&Ty::Bool, scope, d);
                    let a = self.expr(ty, scope, d);
                    let b = self.expr(ty, scope, d);
                    return Expr::If(boxed(c), boxed(a), boxed(b));
                }
                // (fn (x: T) => body) arg
                3 => {
                    let t = self.base_ty();
                    let x = self.name("x");
                    scope.vars.push((x.clone(), t.clone()));
                    let body = self.expr(ty, scope, d);
                    scope.vars.pop();
                    let arg = self.expr(&t, scope, d);
                    return app(Expr::Lam(x, t, boxed(body)), arg);
                }
                4 => {
                    let (l, r) = (self.base_ty(), self.base_ty());
                    let sum = Ty::Sum(Box::new(l.clone()), Box::new(r.clone()));
                    let scrut = self.expr(&sum, scope, d);
                    let (x, y) = (self.name("l"), self.name("r"));
                    scope.vars.push((x.clone(), l));
                    let a = self.expr(ty, scope, d);
                    scope.vars.pop();
                    scope.vars.push((y.clone(), r));
                    let b = self.expr(ty, scope, d);
                    scope.vars.pop();
                    return Expr::Case(boxed(scrut), x, boxed(a), y, boxed(b));
                }
                5 => {
                    let other = self.base_ty();
                    let (a, b) = (self.expr(ty, scope, d), self.expr(&other, scope, d));
                    return if self.rng.chance(50) {
                        Expr::Fst(boxed(Expr::Pair(boxed(a), boxed(b))))
                    } else {
                        Expr::Snd(boxed(Expr::Pair(boxed(b), boxed(a))))
                    };
                }
                6 => {
                    let t = self.base_ty();
                    let e = self.expr(&t, scope, d);
                    let x = self.name("h");
                    scope.vars.push((x.clone(), t));
                    let h = self.expr(ty, scope, d);
                    scope.vars.pop();
                    return Expr::Handle(boxed(e), x, boxed(h));
                }
                // a call of a declared function whose effects are allowed
                7 => {
                    let callable: Vec<Sig> = scope
                        .funs
                        .iter()
                        .filter(|f| &f.ret == ty && f.eff.iter().all(|e| scope.may(e)))
                        .cloned()
                        .collect();
                    if callable.is_empty() {
                        continue;
                    }
                    let f = &callable[self.rng.below(callable.len())];
                    let mut call = Expr::Var(f.name.clone());
                    if f.params.is_empty() {
                        call = app(call, Expr::Unit);
                    }
                    for p in &f.params {
                        let a = self.expr(p, scope, d);
                        call = app(call, a);
                    }
                    return call;
                }
                8 if matches!(ty, Ty::Unit | Ty::Bool | Ty::Int | Ty::String)
                    && scope.may(Effect::Read)
                    && scope.may(Effect::Write) =>
                {
                    let r = self.expr(
                        &Ty::Ref(Box::new(ty.clone()), SecurityLevel::Public),
                        scope,
                        d,
                    );
                    return Expr::Deref(boxed(r));
                }
                9 if matches!(ty, Ty::Unit | Ty::Bool | Ty::Int | Ty::String) => {
                    let v = self.literal(ty);
                    return Expr::Declassify(
                        boxed(Expr::Classify(boxed(v.clone()))),
                        boxed(Expr::Prove(boxed(Expr::Classify(boxed(v))))),
                    );
                }
                10 | 11 => {
                    let allowed: Vec<Effect> = scope.allow.iter().collect();
                    if allowed.is_empty() {
                        continue;
                    }
                    let e = allowed[self.rng.below(allowed.len())];
                    let inner = self.expr(ty, scope, d);
                    return match self.rng.below(3) {
                        0 => Expr::Perform(e, boxed(inner)),
                        1 => Expr::Require(e, boxed(inner)),
                        _ => Expr::Grant(e, boxed(inner)),
                    };
                }
                12 if *ty == Ty::Unit && scope.may(Effect::Write) => {
                    let t = self.base_ty();
                    let r = self.expr(
                        &Ty::Ref(Box::new(t.clone()), SecurityLevel::Public),
                        scope,
                        d,
                    );
                    let v = self.expr(&t, scope, d);
                    return Expr::Assign(boxed(r), boxed(v));
                }
                // a local recursive function: let rec f : Int -> T = λn. body.
                // Its body is pure, so T must not need `Write` to build.
                13 if !holds_ref(ty) => {
                    let f = self.name("rec");
                    let n = self.name("n");
                    let fn_ty = Ty::Fn(Box::new(Ty::Int), Box::new(ty.clone()), EffectSet::PURE);
                    let mut inner = Scope {
                        vars: scope.vars.clone(),
                        funs: &[],
                        allow: EffectSet::PURE,
                    };
                    inner.vars.push((f.clone(), fn_ty.clone()));
                    inner.vars.push((n.clone(), Ty::Int));
                    let base = self.expr(ty, &mut inner, d);
                    let recurse = app(Expr::Var(f.clone()), Expr::Var(n.clone()));
                    let body = Expr::If(
                        boxed(Expr::Bool(self.rng.chance(50))),
                        boxed(base),
                        boxed(recurse),
                    );
                    let lam = Expr::Lam(n, Ty::Int, boxed(body));
                    let arg = self.expr(&Ty::Int, scope, d);
                    return Expr::LetRec(
                        f.clone(),
                        fn_ty,
                        boxed(lam),
                        boxed(app(Expr::Var(f), arg)),
                    );
                }
                _ => match ty {
                    Ty::Prod(a, b) => {
                        let (x, y) = (self.expr(a, scope, d), self.expr(b, scope, d));
                        return Expr::Pair(boxed(x), boxed(y));
                    }
                    Ty::Sum(a, b) => {
                        return if self.rng.chance(50) {
                            Expr::Inl(boxed(self.expr(a, scope, d)), ty.clone())
                        } else {
                            Expr::Inr(boxed(self.expr(b, scope, d)), ty.clone())
                        };
                    }
                    Ty::Secret(t) => return Expr::Classify(boxed(self.expr(t, scope, d))),
                    Ty::Ref(t, l) => return Expr::Ref(boxed(self.expr(t, scope, d)), *l),
                    Ty::Fn(a, b, _) => {
                        let x = self.name("x");
                        let mut inner = Scope {
                            vars: scope.vars.clone(),
                            funs: &[],
                            allow: EffectSet::PURE,
                        };
                        inner.vars.push((x.clone(), (**a).clone()));
                        let body = self.expr(b, &mut inner, d);
                        return Expr::Lam(x, (**a).clone(), boxed(body));
                    }
                    _ => return self.literal(ty),
                },
            }
        }
    }

    fn declared(&mut self) -> EffectSet {
        // Two in five functions are stateful (`kesan (Baca, Tulis)`), so
        // references are common; the rest draw only from the pool.
        let mut set = if self.rng.chance(40) {
            EffectSet::PURE.join(Effect::Read).join(Effect::Write)
        } else {
            EffectSet::PURE
        };
        for _ in 0..self.rng.below(3) {
            set = set.join(POOL[self.rng.below(POOL.len())]);
        }
        set
    }

    /// One flow violation, of type Unit, for a body that declares `allow`.
    fn violation(&mut self, allow: EffectSet, funs: &[Sig]) -> Expr {
        let lit = self.base_ty();
        match self.rng.below(4) {
            // A reference above the public level, read in public code.
            0 => {
                let level = [
                    SecurityLevel::Internal,
                    SecurityLevel::Session,
                    SecurityLevel::User,
                    SecurityLevel::System,
                    SecurityLevel::Secret,
                ][self.rng.below(5)];
                let v = self.literal(&lit);
                Expr::Let(
                    "_baca".into(),
                    None,
                    boxed(Expr::Deref(boxed(Expr::Ref(boxed(v), level)))),
                    boxed(Expr::Unit),
                )
            }
            // An effect above everything the function declares.
            1 => {
                let above: Vec<Effect> = COQ_ORDER
                    .iter()
                    .copied()
                    .filter(|e| coq_level(*e) > max_level(allow))
                    .collect();
                Expr::Perform(above[self.rng.below(above.len())], boxed(Expr::Unit))
            }
            // A declassification whose proof is of another value.
            2 => {
                let a = self.rng.below(10) as u64;
                Expr::Let(
                    "_dedah".into(),
                    None,
                    boxed(Expr::Declassify(
                        boxed(Expr::Classify(boxed(Expr::Int(a)))),
                        boxed(Expr::Prove(boxed(Expr::Classify(boxed(Expr::Int(a + 1)))))),
                    )),
                    boxed(Expr::Unit),
                )
            }
            // A call of a function with an effect above the declaration.
            _ => match funs.iter().find(|f| max_level(f.eff) > max_level(allow)) {
                Some(f) => {
                    let mut call = Expr::Var(f.name.clone());
                    if f.params.is_empty() {
                        call = app(call, Expr::Unit);
                    }
                    for p in &f.params.clone() {
                        call = app(call, self.literal(p));
                    }
                    Expr::Let("_panggil".into(), None, boxed(call), boxed(Expr::Unit))
                }
                None => Expr::Perform(Effect::Gapura, boxed(Expr::Unit)),
            },
        }
    }

    fn program(&mut self, kind: Kind) -> Program {
        let helpers = self.rng.below(3);
        let mut sigs: Vec<Sig> = Vec::new();
        let mut decls = Vec::new();
        for i in 0..helpers {
            let eff = self.declared();
            let scope0 = Scope {
                vars: Vec::new(),
                funs: &[],
                allow: eff,
            };
            let params: Vec<(Ident, Ty)> = (0..self.rng.below(3))
                .map(|_| (self.name("p"), self.ty(1, &scope0)))
                .collect();
            let ret = self.ty(1, &scope0);
            let sig = Sig {
                name: format!("f{i}"),
                params: params.iter().map(|(_, t)| t.clone()).collect(),
                ret: ret.clone(),
                eff,
            };
            // A helper may call earlier helpers and itself (never a cycle of two).
            let mut callable = sigs.clone();
            callable.push(sig.clone());
            let mut scope = Scope {
                vars: params.clone(),
                funs: &callable,
                allow: eff,
            };
            let body = self.expr(&ret, &mut scope, 3);
            decls.push(function(&sig.name, params, ret, eff, body));
            sigs.push(sig);
        }
        let allow = self.declared();
        let ret = self.base_ty();
        let mut scope = Scope {
            vars: Vec::new(),
            funs: &sigs,
            allow,
        };
        self.plant_type_error = kind == Kind::TypeError;
        let mut body = self.expr(&ret, &mut scope, 4);
        if self.plant_type_error {
            // Not planted on the way down: make the body's condition wrong.
            self.plant_type_error = false;
            body = Expr::If(boxed(Expr::Int(1)), boxed(body.clone()), boxed(body));
        }
        if kind == Kind::FlowViolation {
            let v = self.violation(allow, &sigs);
            body = Expr::Let("_".into(), None, boxed(v), boxed(body));
        }
        decls.push(function("utama", Vec::new(), ret, allow, body));
        // Declaration order is random, so the SCC split has work to do.
        for i in (1..decls.len()).rev() {
            let j = self.rng.below(i + 1);
            decls.swap(i, j);
        }
        Program::new(decls)
    }
}

fn function(
    name: &str,
    params: Vec<(Ident, Ty)>,
    return_ty: Ty,
    eff: EffectSet,
    body: Expr,
) -> TopLevelDecl {
    let components: Vec<Effect> = eff.iter().collect();
    let effect = components
        .iter()
        .copied()
        .max_by_key(|e| e.level())
        .unwrap_or(Effect::Pure);
    TopLevelDecl::Function {
        name: name.to_string(),
        params,
        return_ty,
        effect,
        effect_set: components,
        body: boxed(body),
    }
}

/// `count` programs from `seed`: 45% well typed, 30% type errors, 25% flow
/// violations, interleaved.
pub fn generate(seed: u64, count: usize) -> Vec<Generated> {
    let mut g = Gen {
        rng: Rng::new(seed),
        fresh: 0,
        plant_type_error: false,
    };
    (0..count)
        .map(|i| {
            let kind = match i % 20 {
                0..=8 => Kind::WellTyped,
                9..=14 => Kind::TypeError,
                _ => Kind::FlowViolation,
            };
            g.fresh = 0;
            let program = g.program(kind);
            Generated {
                name: format!("gen:{seed:016x}:{i}:{}", kind.label()),
                kind,
                program,
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generation_is_deterministic_in_the_seed() {
        let a: Vec<String> = generate(7, 40)
            .iter()
            .map(|g| format!("{:?}", g.program.decls))
            .collect();
        let b: Vec<String> = generate(7, 40)
            .iter()
            .map(|g| format!("{:?}", g.program.decls))
            .collect();
        let c: Vec<String> = generate(8, 40)
            .iter()
            .map(|g| format!("{:?}", g.program.decls))
            .collect();
        assert_eq!(a, b);
        assert_ne!(a, c);
    }

    #[test]
    fn the_mix_is_as_documented() {
        let gs = generate(1, 1000);
        let n = |k| gs.iter().filter(|g| g.kind == k).count();
        assert_eq!(
            (
                n(Kind::WellTyped),
                n(Kind::TypeError),
                n(Kind::FlowViolation)
            ),
            (450, 300, 250)
        );
    }

    #[test]
    fn well_typed_programs_check_and_emit() {
        let builtins =
            riina_typechecker::register_builtin_types(&riina_typechecker::Context::new());
        let is_builtin = |x: &str| builtins.lookup(&x.to_string()).is_some();
        let mut rejected = Vec::new();
        for g in generate(3, 300) {
            crate::emit_core::elaborate(&g.program.clone().desugar(), &is_builtin).unwrap_or_else(
                |u| panic!("{}: generated a program outside the core: {u}", g.name),
            );
            let verdict = riina_typechecker::check_program(&g.program);
            match g.kind {
                Kind::WellTyped if verdict.is_err() => {
                    rejected.push(format!(
                        "{}: {:?}\n{:?}",
                        g.name,
                        verdict.err(),
                        g.program.decls
                    ));
                }
                Kind::TypeError | Kind::FlowViolation => {}
                _ => {}
            }
        }
        assert!(
            rejected.is_empty(),
            "riinac rejects programs generated as well typed:\n{}",
            rejected.join("\n\n")
        );
    }
}
