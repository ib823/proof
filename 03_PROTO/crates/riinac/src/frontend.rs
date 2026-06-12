// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Compatibility shim for the shared frontend checks.

use riina_typechecker::{
    register_builtin_types, type_check_full, Context, TypeError, TypingContext,
};
use riina_types::{Effect, Expr};

pub(crate) use riina_typechecker::check_program;

fn builtin_typing_context() -> TypingContext {
    register_builtin_types(&Context::new()).to_typing_context()
}

pub(crate) fn check_expr(expr: &Expr) -> Result<(riina_types::Ty, Effect), TypeError> {
    let mut ctx = builtin_typing_context();
    type_check_full(&mut ctx, expr)
}
