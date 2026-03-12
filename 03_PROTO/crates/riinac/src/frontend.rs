// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Shared RIINA frontend checks used by CLI, MCP, and REPL.
//!
//! The shipped entrypoints route through this module so parser output is
//! validated by the Coq-matching typechecker rather than the legacy checker.

use riina_typechecker::{
    register_builtin_types, type_check_full, types_compatible, Context, TypeError, TypingContext,
};
use riina_types::{Effect, Expr, Program, TopLevelDecl, Ty};

fn builtin_typing_context() -> TypingContext {
    register_builtin_types(&Context::new()).to_typing_context()
}

fn declared_function_type(params: &[(String, Ty)], return_ty: &Ty, effect: Effect) -> Ty {
    params
        .iter()
        .rev()
        .fold(return_ty.clone(), |ret, (_, param_ty)| {
            Ty::Fn(Box::new(param_ty.clone()), Box::new(ret), effect)
        })
}

fn validate_top_level_decls(program: &Program) -> Result<(), TypeError> {
    let mut ctx = builtin_typing_context();

    for decl in &program.decls {
        match decl {
            TopLevelDecl::Function {
                name,
                params,
                return_ty,
                effect,
                body,
            } => {
                let fn_ty = declared_function_type(params, return_ty, *effect);
                let mut body_ctx = ctx.extend_gamma(name.clone(), fn_ty.clone());
                for (param_name, param_ty) in params {
                    body_ctx = body_ctx.extend_gamma(param_name.clone(), param_ty.clone());
                }

                let (body_ty, body_eff) = type_check_full(&mut body_ctx, body)?;
                if !types_compatible(return_ty, &body_ty) {
                    return Err(TypeError::AnnotationMismatch {
                        expected: return_ty.clone(),
                        found: body_ty,
                    });
                }
                if body_eff.level() > effect.level() {
                    return Err(TypeError::EffectViolation {
                        allowed: *effect,
                        found: body_eff,
                    });
                }

                ctx = ctx.extend_gamma(name.clone(), fn_ty);
            }
            TopLevelDecl::Binding { name, value } => {
                let mut binding_ctx = ctx.clone();
                let (ty, _eff) = type_check_full(&mut binding_ctx, value)?;
                ctx = ctx.extend_gamma(name.clone(), ty);
            }
            TopLevelDecl::ExternBlock { decls, .. } => {
                for decl in decls {
                    let fn_ty = declared_function_type(&decl.params, &decl.ret_ty, decl.effect);
                    ctx = ctx.extend_gamma(decl.name.clone(), fn_ty);
                }
            }
            TopLevelDecl::Expr(_) | TopLevelDecl::Test { .. } => {}
        }
    }

    Ok(())
}

pub(crate) fn check_expr(expr: &Expr) -> Result<(Ty, Effect), TypeError> {
    let mut ctx = builtin_typing_context();
    type_check_full(&mut ctx, expr)
}

pub(crate) fn check_program(program: &Program) -> Result<(Expr, Ty, Effect), TypeError> {
    validate_top_level_decls(program)?;
    let expr = program.clone().desugar();
    let (ty, eff) = check_expr(&expr)?;
    Ok((expr, ty, eff))
}

#[cfg(test)]
mod tests {
    use super::*;
    use riina_parser::Parser;
    use riina_typechecker::TypeError;
    use riina_types::SecurityLevel;

    fn parse_program(source: &str) -> Program {
        let mut parser = Parser::new(source);
        parser.parse_program().expect("program should parse")
    }

    #[test]
    fn check_program_rejects_secret_deref_in_public_context() {
        let err = check_program(&parse_program("!ref 42 @ Secret")).unwrap_err();
        match err {
            TypeError::SecurityViolation {
                found,
                expected,
                context,
            } => {
                assert_eq!(found, SecurityLevel::Secret);
                assert_eq!(expected, SecurityLevel::Public);
                assert_eq!(context, "dereference");
            }
            other => panic!("expected SecurityViolation, got {other:?}"),
        }
    }

    #[test]
    fn check_program_rejects_invalid_declassification_proof() {
        let err = check_program(&parse_program(
            "declassify classify 42 with prove classify 7",
        ))
        .unwrap_err();
        match err {
            TypeError::InvalidDeclassification { .. } => {}
            other => panic!("expected InvalidDeclassification, got {other:?}"),
        }
    }

    #[test]
    fn check_program_rejects_zero_arg_pure_function_with_system_effect() {
        let err = check_program(&parse_program(
            "fungsi bocor() -> Unit kesan Bersih { print 1 }",
        ))
        .unwrap_err();
        match err {
            TypeError::EffectViolation { allowed, found } => {
                assert_eq!(allowed, Effect::Pure);
                assert_eq!(found, Effect::System);
            }
            other => panic!("expected EffectViolation, got {other:?}"),
        }
    }
}
