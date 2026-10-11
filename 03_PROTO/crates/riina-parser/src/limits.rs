// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Structural size limits on parsed programs.
//!
//! The parser itself is iterative over every *flat* construct (statement
//! sequences, operator chains, `lain kalau` chains, postfix chains, top-level
//! declarations), and its genuinely recursive paths are bounded by the
//! nesting guard in `lib.rs`. But flat SOURCE still produces a deep TREE —
//! `biar` sequences become right-nested `Let` chains, `1 + 1 + …` a
//! left-nested `BinOp` chain — and every later stage (typechecker,
//! interpreter, lowering, emitters, formatter, even `Clone`/`Drop`) recurses
//! over that tree.
//!
//! `riinac` runs all of those stages on a dedicated large-stack thread (see
//! `riinac/src/main.rs`), sized so a tree [`MAX_AST_DEPTH`] levels deep fits
//! with margin. This module enforces the other half of that contract: a
//! program whose tree would be deeper than [`MAX_AST_DEPTH`] is rejected with
//! a clean `ProgramTooDeep` parse error instead of being handed to a stage
//! that would overflow the stack (an uncatchable abort).

use riina_types::{Expr, TopLevelDecl};

/// Maximum depth of a parsed (and desugared) expression tree.
///
/// Comfortably above anything a person or a code generator writes in one
/// function — a 10,000-term `a + b + …` sum or 10,000 consecutive statements
/// are accepted — while bounding the stack every downstream stage needs.
/// Measured per-level stack cost of the deepest stage (release): ~4.6 KiB in
/// the typechecker, ~6.1 KiB in the interpreter, so 20,000 levels need about
/// 120 MiB; `riinac` reserves 256 MiB (and proportionally more for debug
/// builds, whose frames are ~20x larger). Library users that call later
/// stages on their own threads must reserve a comparable stack.
pub const MAX_AST_DEPTH: usize = 20_000;

/// Call `$sink` on each direct sub-expression of `$e`. Shared by the
/// shared-reference and mutable-reference walkers so the variant list exists
/// once; it is exhaustive (no `_` arm), so a new `Expr` variant cannot be
/// added without deciding what its children are.
macro_rules! push_children {
    ($e:expr, $sink:ident, [$($amp:tt)*], $iter:ident) => {
        match $e {
            Expr::Unit
            | Expr::Bool(_)
            | Expr::Int(_)
            | Expr::IntN { .. }
            | Expr::String(_)
            | Expr::Var(_)
            | Expr::Break
            | Expr::Continue
            | Expr::SlotGet(_)
            | Expr::Loc(_)
            | Expr::ChoreographyBlock { .. }
            | Expr::UIColor(..)
            | Expr::UIStyleDecl { .. } => {}
            Expr::Lam(_, _, a)
            | Expr::Fst(a)
            | Expr::Snd(a)
            | Expr::Inl(a, _)
            | Expr::Inr(a, _)
            | Expr::Return(a)
            | Expr::SlotSet(_, a)
            | Expr::Perform(_, a)
            | Expr::Ref(a, _)
            | Expr::Deref(a)
            | Expr::Classify(a)
            | Expr::Prove(a)
            | Expr::Require(_, a)
            | Expr::Grant(_, a)
            | Expr::FieldAccess(a, _)
            | Expr::ActorRecv(a)
            | Expr::ContentHash(a)
            | Expr::ContractDeploy(a)
            | Expr::ZakatCalculate(a) => $sink($($amp)* **a),
            Expr::App(a, b)
            | Expr::Pair(a, b)
            | Expr::Let(_, _, a, b)
            | Expr::While(a, b)
            | Expr::LetMut(_, a, b)
            | Expr::Handle(a, _, b)
            | Expr::Assign(a, b)
            | Expr::Declassify(a, b)
            | Expr::LetRec(_, _, a, b)
            | Expr::BinOp(_, a, b)
            | Expr::Spawn(a, b)
            | Expr::ActorSend(a, b)
            | Expr::CRDTMerge(a, b)
            | Expr::ContentVerify(a, b)
            | Expr::UIText(a, b)
            | Expr::UIButton(a, b)
            | Expr::UIContrastCheck(a, b) => {
                $sink($($amp)* **a);
                $sink($($amp)* **b);
            }
            Expr::Case(a, _, b, _, c) | Expr::If(a, b, c) => {
                $sink($($amp)* **a);
                $sink($($amp)* **b);
                $sink($($amp)* **c);
            }
            Expr::ActorDecl {
                init_state,
                handler,
                ..
            } => {
                $sink($($amp)* **init_state);
                $sink($($amp)* **handler);
            }
            Expr::TokenTransfer { from, to, amount } => {
                $sink($($amp)* **from);
                $sink($($amp)* **to);
                $sink($($amp)* **amount);
            }
            Expr::LetRecGroup(fns, body) => {
                for (_, _, f) in fns.$iter() {
                    $sink(f);
                }
                $sink($($amp)* **body);
            }
            Expr::ListLit(items)
            | Expr::UIDisplay(items)
            | Expr::UIRow(items)
            | Expr::UIColumn(items)
            | Expr::FFICall { args: items, .. } => {
                for x in items.$iter() {
                    $sink(x);
                }
            }
            Expr::RecordLit(_, fields) => {
                for (_, x) in fields.$iter() {
                    $sink(x);
                }
            }
        }
    };
}

/// Depth of `expr` (a leaf is depth 1), computed with an explicit work list
/// so measuring an arbitrarily deep tree cannot itself overflow the stack.
#[must_use]
pub fn expr_depth(expr: &Expr) -> usize {
    let mut max = 0;
    let mut work: Vec<(&Expr, usize)> = vec![(expr, 1)];
    while let Some((e, d)) = work.pop() {
        max = max.max(d);
        let mut visit = |c| work.push((c, d + 1));
        push_children!(e, visit, [&], iter);
    }
    max
}

/// Depth a top-level declaration contributes once `Program::desugar` has
/// turned it into an expression: its body plus the curried `Lam` chain of its
/// parameters (and, for an `extern` block, the `Let`/`Lam` chain built for
/// each foreign function).
#[must_use]
pub fn decl_depth(decl: &TopLevelDecl) -> usize {
    match decl {
        TopLevelDecl::Function { params, body, .. } => params.len() + 1 + expr_depth(body),
        TopLevelDecl::Binding { value, .. } => 1 + expr_depth(value),
        TopLevelDecl::Expr(e) | TopLevelDecl::Test { body: e, .. } => 1 + expr_depth(e),
        TopLevelDecl::ExternBlock { decls, .. } => decls
            .iter()
            .enumerate()
            .map(|(i, d)| i + d.params.len() + 2)
            .max()
            .unwrap_or(0),
    }
}

/// Drop `expr` without recursion.
///
/// The derived `Drop` of a `Box`-linked tree recurses once per level, so
/// dropping a tree we just REJECTED for being too deep would overflow the
/// stack on exactly the input the limit exists for. This takes the tree apart
/// with an explicit work list instead, leaving only shallow nodes to drop.
pub fn dismantle(expr: Expr) {
    let mut work = vec![expr];
    let mut taken: Vec<Expr> = Vec::new();
    while let Some(mut e) = work.pop() {
        let mut take = |c: &mut Expr| taken.push(std::mem::replace(c, Expr::Unit));
        push_children!(&mut e, take, [&mut], iter_mut);
        work.append(&mut taken);
        // `e` now has only `Unit` children: its drop is shallow.
    }
}

/// Drop a declaration without recursion (see [`dismantle`]).
pub fn dismantle_decl(decl: TopLevelDecl) {
    match decl {
        TopLevelDecl::Function { body, .. } => dismantle(*body),
        TopLevelDecl::Binding { value, .. } => dismantle(*value),
        TopLevelDecl::Expr(e) | TopLevelDecl::Test { body: e, .. } => dismantle(*e),
        TopLevelDecl::ExternBlock { .. } => {}
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use riina_types::BinOp;

    fn chain(n: usize) -> Expr {
        let mut e = Expr::Int(1);
        for _ in 0..n {
            e = Expr::BinOp(BinOp::Add, Box::new(e), Box::new(Expr::Int(1)));
        }
        e
    }

    #[test]
    fn depth_of_leaf_and_chain() {
        assert_eq!(expr_depth(&Expr::Unit), 1);
        assert_eq!(expr_depth(&chain(3)), 4);
    }

    #[test]
    fn deep_tree_is_measured_and_dropped_without_recursion() {
        // A million levels: recursive measurement or drop would overflow the
        // (default 2 MiB) test thread.
        let e = chain(1_000_000);
        assert_eq!(expr_depth(&e), 1_000_001);
        dismantle(e);
    }
}
