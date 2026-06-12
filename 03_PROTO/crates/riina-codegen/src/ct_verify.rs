//! Per-program constant-time (CT) verification pass over the lowered IR.
//!
//! The typechecker enforces the constant-time discipline at the source level
//! (rule A2: no branch on a `ConstantTime` value, and — for division/modulo — no
//! variable-time operation on one). This pass is the **codegen-level** counterpart:
//! it independently re-checks the *lowered IR* — the artifact that actually
//! becomes machine code — so a lowering bug or a future typechecker gap that let
//! a secret-dependent branch or a variable-time secret operation through would be
//! caught before emission. It is defense-in-depth, run once per program.
//!
//! It works on the IR's own type annotations: a value is constant-time if its
//! `AnnotatedInstr.ty` is `ConstantTime` (the lowerer propagates the CT tag
//! through arithmetic — see `ty_is_constant_time` / `infer_type`). CT-ness is
//! then propagated through data-flow instructions (`BinOp`, `UnaryOp`, `Copy`,
//! `Phi`, classify/declassify) to a fixpoint, and two hazards are reported:
//!
//!   * a `CondBranch` whose condition is constant-time — a secret-dependent
//!     branch (timing side-channel via control flow);
//!   * a `Div`/`Mod` with a constant-time operand — a data-dependent-latency
//!     operation (timing side-channel via instruction timing).
//!
//! This models RIINA's CT guarantee for the instruction-timing and
//! secret-dependent-branch channels. It does **not** address
//! data-memory-dependent-prefetcher (DMP / GoFetch-class) leakage, which is a
//! hardware-contract concern tracked for the CHERI era (see the constant-time
//! row of `RIINA_MASTER_PLAN.md` Part 11, Gate B).

use std::collections::{HashMap, HashSet};

use riina_types::Ty;

use crate::ir::{BinOp, Instruction, Program, Terminator, VarId};

/// A constant-time violation found in the lowered IR.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum CtViolation {
    /// A `CondBranch` branches on a constant-time condition (secret-dependent
    /// control flow).
    SecretDependentBranch { function: String, cond: VarId },
    /// A division or modulo has a constant-time operand (data-dependent latency).
    VariableTimeOperation {
        function: String,
        op: BinOp,
        result: VarId,
    },
}

impl CtViolation {
    /// A human-readable description for diagnostics.
    #[must_use]
    pub fn message(&self) -> String {
        match self {
            CtViolation::SecretDependentBranch { function, cond } => format!(
                "constant-time violation in `{function}`: branch on constant-time value {cond} \
                 (secret-dependent control flow)"
            ),
            CtViolation::VariableTimeOperation {
                function,
                op,
                result,
            } => format!(
                "constant-time violation in `{function}`: variable-time {op:?} producing {result} \
                 has a constant-time operand (data-dependent latency)"
            ),
        }
    }
}

/// Verify the constant-time discipline over a whole lowered program.
///
/// Returns `Ok(())` when no function contains a secret-dependent branch or a
/// variable-time operation on a constant-time value, otherwise the list of all
/// violations found.
///
/// # Errors
/// Returns the collected [`CtViolation`]s when the IR violates the CT discipline.
pub fn verify_constant_time(program: &Program) -> Result<(), Vec<CtViolation>> {
    let mut violations = Vec::new();
    for func in program.functions.values() {
        verify_function(func, &mut violations);
    }
    if violations.is_empty() {
        Ok(())
    } else {
        Err(violations)
    }
}

/// Whether a type carries the constant-time discipline (through a `Labeled`).
fn is_ct(ty: &Ty) -> bool {
    match ty {
        Ty::ConstantTime(_) => true,
        Ty::Labeled(inner, _) => is_ct(inner),
        _ => false,
    }
}

fn verify_function(func: &crate::ir::Function, out: &mut Vec<CtViolation>) {
    // Seed: every IR value whose annotated type is constant-time.
    let mut ct: HashSet<VarId> = HashSet::new();
    // Index instructions by result for propagation, and record Div/Mod sites.
    let mut def: HashMap<VarId, &Instruction> = HashMap::new();
    for block in &func.blocks {
        for ai in &block.instrs {
            if is_ct(&ai.ty) {
                ct.insert(ai.result);
            }
            def.insert(ai.result, &ai.instr);
        }
    }

    // Propagate CT-ness through data-flow instructions to a fixpoint: a result
    // is constant-time if any operand it is derived from is constant-time.
    let mut changed = true;
    while changed {
        changed = false;
        for (&result, instr) in &def {
            if ct.contains(&result) {
                continue;
            }
            let tainted = match instr {
                Instruction::BinOp(_, a, b) => ct.contains(a) || ct.contains(b),
                Instruction::UnaryOp(_, v)
                | Instruction::Copy(v)
                | Instruction::Classify(v)
                | Instruction::Prove(v) => ct.contains(v),
                Instruction::Declassify(v, _) => ct.contains(v),
                Instruction::Phi(arms) => arms.iter().any(|(_, v)| ct.contains(v)),
                _ => false,
            };
            if tainted {
                ct.insert(result);
                changed = true;
            }
        }
    }

    // Hazard 1: variable-time Div/Mod with a constant-time operand.
    for block in &func.blocks {
        for ai in &block.instrs {
            if let Instruction::BinOp(op @ (BinOp::Div | BinOp::Mod), a, b) = &ai.instr {
                if ct.contains(a) || ct.contains(b) {
                    out.push(CtViolation::VariableTimeOperation {
                        function: func.name.clone(),
                        op: *op,
                        result: ai.result,
                    });
                }
            }
        }
    }

    // Hazard 2: a branch whose condition is constant-time.
    for block in &func.blocks {
        if let Some(Terminator::CondBranch { cond, .. }) = &block.terminator {
            if ct.contains(cond) {
                out.push(CtViolation::SecretDependentBranch {
                    function: func.name.clone(),
                    cond: *cond,
                });
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ir::{
        AnnotatedInstr, BasicBlock, BlockId, Constant, Function, FuncId, UnaryOp,
    };
    use crate::lower::Lower;
    use riina_types::{BinOp as AstBinOp, Effect, Expr, SecurityLevel};

    fn ann(instr: Instruction, result: VarId, ty: Ty) -> AnnotatedInstr {
        AnnotatedInstr {
            instr,
            result,
            ty,
            effect: Effect::Pure,
            security: SecurityLevel::Public,
        }
    }

    fn func_with(instrs: Vec<AnnotatedInstr>, term: Terminator) -> Program {
        let mut program = Program::new();
        let mut f = Function::new(
            FuncId::MAIN,
            "main".to_string(),
            "x".to_string(),
            Ty::Unit,
            Ty::Int,
            Effect::Pure,
        );
        let entry = BlockId::new(0);
        let mut block = BasicBlock::new(entry);
        block.instrs = instrs;
        block.terminator = Some(term);
        f.blocks = vec![block];
        f.entry = entry;
        program.functions.insert(FuncId::MAIN, f);
        program
    }

    fn ct(inner: Ty) -> Ty {
        Ty::ConstantTime(Box::new(inner))
    }

    // ── Synthetic IR: precise detection ────────────────────────────────────

    #[test]
    fn plain_branch_is_accepted() {
        // A CondBranch on a plain Bool is fine.
        let (v0, v1, v2) = (VarId::new(0), VarId::new(1), VarId::new(2));
        let prog = func_with(
            vec![
                ann(Instruction::Const(Constant::Bool(true)), v0, Ty::Bool),
                ann(Instruction::Const(Constant::Int(1)), v1, Ty::Int),
                ann(Instruction::Const(Constant::Int(0)), v2, Ty::Int),
            ],
            Terminator::CondBranch {
                cond: v0,
                then_block: BlockId::new(1),
                else_block: BlockId::new(2),
            },
        );
        assert!(verify_constant_time(&prog).is_ok());
    }

    #[test]
    fn constant_time_branch_is_detected() {
        // A CondBranch whose condition is ConstantTime<Bool> is a violation.
        let v0 = VarId::new(0);
        let prog = func_with(
            vec![ann(
                Instruction::Const(Constant::Bool(true)),
                v0,
                ct(Ty::Bool),
            )],
            Terminator::CondBranch {
                cond: v0,
                then_block: BlockId::new(1),
                else_block: BlockId::new(2),
            },
        );
        match verify_constant_time(&prog) {
            Err(v) => assert_eq!(
                v,
                vec![CtViolation::SecretDependentBranch {
                    function: "main".into(),
                    cond: v0,
                }]
            ),
            Ok(()) => panic!("expected a secret-dependent branch violation"),
        }
    }

    #[test]
    fn constant_time_division_is_detected() {
        // Div with a ConstantTime operand is a variable-time violation.
        let (v0, v1, v2) = (VarId::new(0), VarId::new(1), VarId::new(2));
        let prog = func_with(
            vec![
                ann(Instruction::Const(Constant::Int(7)), v0, ct(Ty::Int)),
                ann(Instruction::Const(Constant::Int(3)), v1, Ty::Int),
                ann(Instruction::BinOp(BinOp::Div, v0, v1), v2, ct(Ty::Int)),
            ],
            Terminator::Return(v2),
        );
        match verify_constant_time(&prog) {
            Err(v) => assert_eq!(
                v,
                vec![CtViolation::VariableTimeOperation {
                    function: "main".into(),
                    op: BinOp::Div,
                    result: v2,
                }]
            ),
            Ok(()) => panic!("expected a variable-time division violation"),
        }
    }

    #[test]
    fn constant_time_propagates_through_dataflow() {
        // A CT value flows through Add and UnaryOp before reaching the branch;
        // the fixpoint must taint the derived condition.
        let (v0, v1, v2, v3) = (VarId::new(0), VarId::new(1), VarId::new(2), VarId::new(3));
        let prog = func_with(
            vec![
                ann(Instruction::Const(Constant::Int(1)), v0, ct(Ty::Int)),
                ann(Instruction::Const(Constant::Int(2)), v1, Ty::Int),
                // v2 = v0 + v1 — not annotated CT, but derived from a CT operand.
                ann(Instruction::BinOp(BinOp::Add, v0, v1), v2, Ty::Int),
                // v3 = not v2 — still tainted.
                ann(Instruction::UnaryOp(UnaryOp::Not, v2), v3, Ty::Bool),
            ],
            Terminator::CondBranch {
                cond: v3,
                then_block: BlockId::new(1),
                else_block: BlockId::new(2),
            },
        );
        assert!(matches!(
            verify_constant_time(&prog).unwrap_err().as_slice(),
            [CtViolation::SecretDependentBranch { .. }]
        ));
    }

    #[test]
    fn non_ct_program_passes() {
        let (v0, v1, v2) = (VarId::new(0), VarId::new(1), VarId::new(2));
        let prog = func_with(
            vec![
                ann(Instruction::Const(Constant::Int(10)), v0, Ty::Int),
                ann(Instruction::Const(Constant::Int(3)), v1, Ty::Int),
                ann(Instruction::BinOp(BinOp::Div, v0, v1), v2, Ty::Int),
            ],
            Terminator::Return(v2),
        );
        assert!(verify_constant_time(&prog).is_ok());
    }

    // ── End-to-end through the lowerer (CT contagion reaches the IR) ────────

    #[test]
    fn lowered_ct_arithmetic_is_visible_and_passes() {
        // (λx: ConstantTime<Int>. x + 1) 0 — the param is CT, so `x + 1` lowers
        // to a CT-annotated BinOp. No branch/div ⇒ verification passes, and the
        // CT tag is present in the IR (proving the lowerer preserves it).
        let body = Expr::BinOp(
            AstBinOp::Add,
            Box::new(Expr::Var("x".into())),
            Box::new(Expr::Int(1)),
        );
        let lam = Expr::Lam("x".into(), ct(Ty::Int), Box::new(body));
        let app = Expr::App(Box::new(lam), Box::new(Expr::Int(0)));
        let prog = Lower::new().compile(&app).expect("lowering succeeds");
        let has_ct = prog
            .functions
            .values()
            .any(|f| f.blocks.iter().any(|b| b.instrs.iter().any(|i| is_ct(&i.ty))));
        assert!(has_ct, "CT tag must survive lowering");
        verify_constant_time(&prog).expect("CT arithmetic without a branch is fine");
    }

    #[test]
    fn lowered_branch_on_ct_comparison_is_detected() {
        // (λx: ConstantTime<Int>. if x == 0 then 1 else 2) 0 — `x == 0` is a
        // CT<Bool>, so the lowered CondBranch is secret-dependent. The
        // typechecker would reject this at the source; this proves the codegen
        // pass independently catches it on the lowered artifact.
        let cond = Expr::BinOp(
            AstBinOp::Eq,
            Box::new(Expr::Var("x".into())),
            Box::new(Expr::Int(0)),
        );
        let body = Expr::If(
            Box::new(cond),
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        );
        let lam = Expr::Lam("x".into(), ct(Ty::Int), Box::new(body));
        let app = Expr::App(Box::new(lam), Box::new(Expr::Int(0)));
        let prog = Lower::new().compile(&app).expect("lowering succeeds");
        assert!(
            verify_constant_time(&prog).is_err(),
            "a branch on a CT comparison must be flagged"
        );
    }
}
