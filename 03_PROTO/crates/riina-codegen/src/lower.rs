// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! AST to IR Lowering
//!
//! Translates RIINA AST expressions to SSA-form IR.
//! Each AST construct is lowered according to the rules in Coq.
//!
//! # Correspondence with Coq
//!
//! ```coq
//! (* 02_FORMAL/coq/properties/Compilation.v *)
//!
//! (* Lowering preserves types *)
//! Theorem lower_preserves_type : forall Γ e T ε ir,
//!   typing Γ e T ε ->
//!   lower e = Some ir ->
//!   ir_typing Γ ir T ε.
//!
//! (* Lowering preserves semantics *)
//! Theorem lower_preserves_eval : forall e v ir,
//!   eval e v ->
//!   lower e = Some ir ->
//!   ir_eval ir v.
//! ```
//!
//! # Translation Rules
//!
//! Each `Expr` variant is translated to a sequence of IR instructions:
//!
//! | Expr | IR Translation |
//! |------|----------------|
//! | `Unit` | `Const(Unit)` |
//! | `Bool(b)` | `Const(Bool(b))` |
//! | `Int(n)` | `Const(Int(n))` |
//! | `String(s)` | `Const(String(s))` |
//! | `Var(x)` | `Copy(lookup(x))` |
//! | `Lam(x, T, e)` | `Closure(f, captures)` where f is a new function |
//! | `App(e1, e2)` | `v1 = lower(e1); v2 = lower(e2); Call(v1, v2)` |
//! | `Pair(e1, e2)` | `v1 = lower(e1); v2 = lower(e2); Pair(v1, v2)` |
//! | `Fst(e)` | `v = lower(e); Fst(v)` |
//! | `Snd(e)` | `v = lower(e); Snd(v)` |
//! | `Inl(e, T)` | `v = lower(e); Inl(v)` |
//! | `Inr(e, T)` | `v = lower(e); Inr(v)` |
//! | `Case(e, x, e1, y, e2)` | Branch on `IsLeft`, then `UnwrapLeft/Right` |
//! | `If(c, t, f)` | `CondBranch` with phi node for result |
//! | `Let(x, e1, e2)` | `v1 = lower(e1); extend env; lower(e2)` |
//! | `Perform(eff, e)` | `v = lower(e); Perform(eff, v)` |
//! | `Handle(e, x, h)` | `Handle` terminator with handler block |
//! | `Ref(e, l)` | `v = lower(e); Alloc(v, l)` |
//! | `Deref(e)` | `v = lower(e); Load(v)` |
//! | `Assign(e1, e2)` | `v1 = lower(e1); v2 = lower(e2); Store(v1, v2)` |
//! | `Classify(e)` | `v = lower(e); Classify(v)` |
//! | `Declassify(e, p)` | `ve = lower(e); vp = lower(p); Declassify(ve, vp)` |
//! | `Prove(e)` | `v = lower(e); Prove(v)` |
//! | `Require(eff, e)` | `RequireCap(eff); lower(e)` |
//! | `Grant(eff, e)` | `GrantCap(eff); lower(e)` |
//!
//! # Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST

use crate::builtins;
use crate::ir::BinOp as IrBinOp;
use crate::ir::{
    AnnotatedInstr, BlockId, Constant, FuncId, Function, Instruction, Program, Terminator, VarId,
};
use crate::{Error, Result};
use riina_types::{BinOp, Effect, Expr, Ident, SecurityLevel, Ty};
use std::collections::{HashMap, HashSet};

/// Map a source name to its canonical builtin name, if it is a known builtin.
fn builtin_canonical(name: &str) -> Option<&'static str> {
    // I/O
    match name {
        "cetak" | "print" => return Some("cetak"),
        "cetakln" | "println" => return Some("cetakln"),
        // String
        "gabung_teks" | "concat" => return Some("gabung_teks"),
        "panjang" | "length" => return Some("panjang"),
        // Conversion
        "ke_teks" | "to_string" => return Some("ke_teks"),
        "ke_nombor" | "parse_int" => return Some("ke_nombor"),
        "ke_bool" | "to_bool" => return Some("ke_bool"),
        "bool_ke_nombor" | "bool_to_int" => return Some("bool_ke_nombor"),
        "nombor_ke_teks" | "int_to_string" => return Some("nombor_ke_teks"),
        // Math
        "mutlak" | "abs" => return Some("mutlak"),
        "minimum" | "min" => return Some("minimum"),
        "maksimum" | "max" => return Some("maksimum"),
        "kuasa" | "pow" => return Some("kuasa"),
        "punca" | "sqrt" => return Some("punca"),
        "gcd" => return Some("gcd"),
        "lcm" => return Some("lcm"),
        // Test
        "tegaskan" | "assert" => return Some("tegaskan"),
        "tegaskan_sama" | "assert_eq" => return Some("tegaskan_sama"),
        "tegaskan_beza" | "assert_ne" => return Some("tegaskan_beza"),
        "tegaskan_betul" | "assert_true" => return Some("tegaskan_betul"),
        "tegaskan_salah" | "assert_false" => return Some("tegaskan_salah"),
        _ => {}
    }
    // String (teks) builtins
    for &(bm, en, canonical) in builtins::teks::BUILTINS {
        if name == bm || name == en {
            return Some(canonical);
        }
    }
    // List (senarai) builtins
    for &(bm, en, canonical) in builtins::senarai::BUILTINS {
        if name == bm || name == en {
            return Some(canonical);
        }
    }
    // Map (peta) builtins
    for &(bm, en, canonical) in builtins::peta::BUILTINS {
        if name == bm || name == en {
            return Some(canonical);
        }
    }
    // Set builtins
    for &(bm, en, canonical) in builtins::set::BUILTINS {
        if name == bm || name == en {
            return Some(canonical);
        }
    }
    None
}

fn css_hex_color(r: u8, g: u8, b: u8) -> String {
    format!("#{r:02x}{g:02x}{b:02x}")
}

fn css_style_fragment(padding: Option<u32>, font_size: Option<u32>) -> String {
    let mut styles = Vec::new();
    if let Some(padding) = padding {
        styles.push(format!("padding:{padding}px"));
    }
    if let Some(font_size) = font_size {
        styles.push(format!("font-size:{font_size}px"));
    }
    styles.join(";")
}

fn linearize_channel(channel: u8) -> f64 {
    let srgb = f64::from(channel) / 255.0;
    if srgb <= 0.039_28 {
        srgb / 12.92
    } else {
        ((srgb + 0.055) / 1.055).powf(2.4)
    }
}

fn relative_luminance(r: u8, g: u8, b: u8) -> f64 {
    0.2126 * linearize_channel(r) + 0.7152 * linearize_channel(g) + 0.0722 * linearize_channel(b)
}

fn wcag_aa_contrast_ok(fg: (u8, u8, u8), bg: (u8, u8, u8)) -> bool {
    let fg_l = relative_luminance(fg.0, fg.1, fg.2);
    let bg_l = relative_luminance(bg.0, bg.1, bg.2);
    let (lighter, darker) = if fg_l >= bg_l {
        (fg_l, bg_l)
    } else {
        (bg_l, fg_l)
    };
    (lighter + 0.05) / (darker + 0.05) >= 4.5
}

/// Whether a type carries the constant-time discipline, looking through a
/// security `Labeled` wrapper. Used for CT contagion in `infer_type` so the
/// codegen constant-time verifier can see CT-derived IR values.
fn ty_is_constant_time(ty: &Ty) -> bool {
    match ty {
        Ty::ConstantTime(_) => true,
        Ty::Labeled(inner, _) => ty_is_constant_time(inner),
        _ => false,
    }
}

/// Variable environment during lowering
#[derive(Debug, Clone, Default)]
struct VarEnv {
    /// Map from source names to IR variable IDs
    bindings: HashMap<Ident, VarId>,
    /// Security levels for each variable
    levels: HashMap<VarId, SecurityLevel>,
    /// Types for each variable
    types: HashMap<VarId, Ty>,
    /// Literal CAHAYA colors available under source names
    colors: HashMap<Ident, (u8, u8, u8)>,
}

impl VarEnv {
    fn new() -> Self {
        Self {
            bindings: HashMap::new(),
            levels: HashMap::new(),
            types: HashMap::new(),
            colors: HashMap::new(),
        }
    }

    fn bind(&mut self, name: Ident, var: VarId, ty: Ty, level: SecurityLevel) {
        self.colors.remove(&name);
        self.bindings.insert(name, var);
        self.levels.insert(var, level);
        self.types.insert(var, ty);
    }

    fn lookup(&self, name: &str) -> Option<VarId> {
        self.bindings.get(name).copied()
    }

    fn bind_color(&mut self, name: Ident, color: (u8, u8, u8)) {
        self.colors.insert(name, color);
    }

    fn color(&self, name: &str) -> Option<(u8, u8, u8)> {
        self.colors.get(name).copied()
    }
}

/// Compute the set of free variables in an expression.
/// A variable is free if it is referenced but not bound within the expression.
fn free_vars(expr: &Expr) -> HashSet<Ident> {
    match expr {
        Expr::Unit | Expr::Bool(_) | Expr::Int(_) | Expr::String(_) | Expr::Loc(_) => {
            HashSet::new()
        }
        Expr::Var(name) => {
            let mut s = HashSet::new();
            s.insert(name.clone());
            s
        }
        Expr::Lam(param, _, body) => {
            let mut fv = free_vars(body);
            fv.remove(param);
            fv
        }
        Expr::App(e1, e2)
        | Expr::Pair(e1, e2)
        | Expr::Assign(e1, e2)
        | Expr::Declassify(e1, e2)
        | Expr::BinOp(_, e1, e2) => {
            let mut fv = free_vars(e1);
            fv.extend(free_vars(e2));
            fv
        }
        Expr::Let(name, _, e1, e2) => {
            let mut fv = free_vars(e1);
            let mut fv2 = free_vars(e2);
            fv2.remove(name);
            fv.extend(fv2);
            fv
        }
        Expr::LetRec(name, _, e1, e2) => {
            let mut fv1 = free_vars(e1);
            fv1.remove(name); // name is in scope in its own binding
            let mut fv2 = free_vars(e2);
            fv2.remove(name);
            fv1.extend(fv2);
            fv1
        }
        Expr::If(c, t, f) => {
            let mut fv = free_vars(c);
            fv.extend(free_vars(t));
            fv.extend(free_vars(f));
            fv
        }
        Expr::Case(e, x, e1, y, e2) => {
            let mut fv = free_vars(e);
            let mut fv1 = free_vars(e1);
            fv1.remove(x);
            let mut fv2 = free_vars(e2);
            fv2.remove(y);
            fv.extend(fv1);
            fv.extend(fv2);
            fv
        }
        Expr::Fst(e)
        | Expr::Snd(e)
        | Expr::Inl(e, _)
        | Expr::Inr(e, _)
        | Expr::Deref(e)
        | Expr::Classify(e)
        | Expr::Prove(e)
        | Expr::Return(e)
        | Expr::Ref(e, _) => free_vars(e),
        Expr::Perform(_, e) | Expr::Require(_, e) | Expr::Grant(_, e) => free_vars(e),
        Expr::Handle(e, x, h) => {
            let mut fv = free_vars(e);
            let mut fvh = free_vars(h);
            fvh.remove(x);
            fv.extend(fvh);
            fv
        }
        Expr::FFICall { args, .. } => {
            let mut fv = HashSet::new();
            for arg in args {
                fv.extend(free_vars(arg));
            }
            fv
        }
        Expr::ActorDecl {
            init_state,
            handler,
            ..
        } => {
            let mut fv = free_vars(init_state);
            fv.extend(free_vars(handler));
            fv
        }
        Expr::ChoreographyBlock { .. } => HashSet::new(),
        Expr::Spawn(a, b)
        | Expr::ActorSend(a, b)
        | Expr::CRDTMerge(a, b)
        | Expr::ContentVerify(a, b) => {
            let mut fv = free_vars(a);
            fv.extend(free_vars(b));
            fv
        }
        Expr::TokenTransfer { from, to, amount } => {
            let mut fv = free_vars(from);
            fv.extend(free_vars(to));
            fv.extend(free_vars(amount));
            fv
        }
        Expr::ActorRecv(a)
        | Expr::ContentHash(a)
        | Expr::ContractDeploy(a)
        | Expr::ZakatCalculate(a) => free_vars(a),
        // CAHAYA Phase J5
        Expr::ListLit(elems)
        | Expr::UIDisplay(elems)
        | Expr::UIRow(elems)
        | Expr::UIColumn(elems) => {
            let mut fv = HashSet::new();
            for e in elems {
                fv.extend(free_vars(e));
            }
            fv
        }
        Expr::RecordLit(_, fields) => {
            let mut fv = HashSet::new();
            for (_f, e) in fields {
                fv.extend(free_vars(e));
            }
            fv
        }
        Expr::FieldAccess(base, _) => free_vars(base),
        Expr::UIText(a, b) | Expr::UIButton(a, b) | Expr::UIContrastCheck(a, b) => {
            let mut fv = free_vars(a);
            fv.extend(free_vars(b));
            fv
        }
        Expr::UIColor(_, _, _) | Expr::UIStyleDecl { .. } => HashSet::new(),
    }
}

/// AST to IR lowering pass
///
/// Translates typed RIINA AST to SSA-form IR.
pub struct Lower {
    /// The program being built
    program: Program,
    /// Current function being compiled
    current_func: Option<FuncId>,
    /// Current basic block
    current_block: BlockId,
    /// Next variable ID
    next_var: u32,
    /// Variable environment
    env: VarEnv,
    /// Struct field layouts harvested from `RecordLit` nodes: struct name ->
    /// ordered `(field name, field type)`. `RecordLit` lowers a struct to a
    /// right-nested pair in field order, so field `i` is `Fst(Snd^i(base))`; the
    /// field types let a struct bound to an opaque value (e.g. a function call)
    /// still be typed as the matching product so projections recover field types.
    struct_layouts: HashMap<String, Vec<(String, Ty)>>,
    /// Functions whose result is a struct literal: fn name -> struct name.
    /// Lets `FieldAccess` on a call result (`biar v = f(); v.field`) resolve.
    fn_returns_struct: HashMap<String, String>,
    /// Variables currently known to hold a struct value: var name -> struct
    /// name. Scoped like `env` (saved/restored around each `Let` body).
    var_struct: HashMap<String, String>,
}

impl Lower {
    /// Create a new lowering pass
    #[must_use]
    pub fn new() -> Self {
        Self {
            program: Program::new(),
            current_func: None,
            current_block: BlockId::ENTRY,
            next_var: 0,
            env: VarEnv::new(),
            struct_layouts: HashMap::new(),
            fn_returns_struct: HashMap::new(),
            var_struct: HashMap::new(),
        }
    }

    /// Pre-pass over the whole desugared program: record every struct's field
    /// order (from `RecordLit` nodes) and every function whose result is a
    /// struct literal. This is what lets `FieldAccess` resolve to a real field
    /// projection later, including `biar v = f(); v.field` where `v` comes from
    /// a call. Variants without struct-bearing children fall through (`_`),
    /// preserving the previous behavior for anything unresolved.
    fn harvest_struct_info(&mut self, e: &Expr) {
        match e {
            Expr::RecordLit(name, fields) => {
                if !self.struct_layouts.contains_key(name) {
                    // Compute the layout (with field types) before inserting to
                    // avoid borrowing `self` mutably and immutably at once.
                    let layout: Vec<(String, Ty)> = fields
                        .iter()
                        .map(|(f, e)| (f.clone(), self.infer_type(e)))
                        .collect();
                    self.struct_layouts.insert(name.clone(), layout);
                }
                for (_, fe) in fields {
                    self.harvest_struct_info(fe);
                }
            }
            Expr::LetRec(name, _, bound, cont) => {
                if let Some(s) = Self::result_struct_name(bound) {
                    self.fn_returns_struct.entry(name.clone()).or_insert(s);
                }
                self.harvest_struct_info(bound);
                self.harvest_struct_info(cont);
            }
            Expr::Lam(_, _, b)
            | Expr::Fst(b)
            | Expr::Snd(b)
            | Expr::Inl(b, _)
            | Expr::Inr(b, _)
            | Expr::Return(b)
            | Expr::Perform(_, b)
            | Expr::Ref(b, _)
            | Expr::Deref(b)
            | Expr::Classify(b)
            | Expr::Prove(b)
            | Expr::Require(_, b)
            | Expr::Grant(_, b)
            | Expr::FieldAccess(b, _) => self.harvest_struct_info(b),
            Expr::App(a, b)
            | Expr::Pair(a, b)
            | Expr::Assign(a, b)
            | Expr::Declassify(a, b)
            | Expr::BinOp(_, a, b)
            | Expr::Handle(a, _, b) => {
                self.harvest_struct_info(a);
                self.harvest_struct_info(b);
            }
            Expr::Let(_, _, a, b) => {
                self.harvest_struct_info(a);
                self.harvest_struct_info(b);
            }
            Expr::If(a, b, c) | Expr::Case(a, _, b, _, c) => {
                self.harvest_struct_info(a);
                self.harvest_struct_info(b);
                self.harvest_struct_info(c);
            }
            Expr::ListLit(es) => {
                for x in es {
                    self.harvest_struct_info(x);
                }
            }
            Expr::FFICall { args, .. } => {
                for x in args {
                    self.harvest_struct_info(x);
                }
            }
            _ => {}
        }
    }

    /// The struct name a (function-body) expression evaluates to, if its tail is
    /// a struct literal — looking through `Lam`/`Return`/`Let`/`LetRec` wrappers
    /// and into both arms of an `If`.
    fn result_struct_name(e: &Expr) -> Option<String> {
        match e {
            Expr::RecordLit(name, _) => Some(name.clone()),
            Expr::Lam(_, _, b)
            | Expr::Return(b)
            | Expr::Let(_, _, _, b)
            | Expr::LetRec(_, _, _, b) => Self::result_struct_name(b),
            Expr::If(_, t, f) => {
                Self::result_struct_name(t).or_else(|| Self::result_struct_name(f))
            }
            _ => None,
        }
    }

    /// The struct name an expression holds, if known: a direct `RecordLit`, a
    /// variable tracked in `var_struct`, or a call to a struct-returning
    /// function. Used to resolve `FieldAccess`.
    fn struct_name_of(&self, e: &Expr) -> Option<String> {
        match e {
            Expr::RecordLit(name, _) => Some(name.clone()),
            // A bare `Var` is either a struct-bound local or a no-arg function
            // reference (a no-arg call desugars to the bare `Var`); either may
            // name a struct value.
            Expr::Var(x) => self
                .var_struct
                .get(x)
                .or_else(|| self.fn_returns_struct.get(x))
                .cloned(),
            Expr::App(f, _) => match f.as_ref() {
                Expr::Var(fname) => self.fn_returns_struct.get(fname).cloned(),
                _ => None,
            },
            Expr::Return(b) => self.struct_name_of(b),
            _ => None,
        }
    }

    /// The product type for a known struct: `(t0, (t1, ... Unit))` over its
    /// harvested field types, mirroring how `RecordLit` lowers.
    fn struct_prod_ty(&self, name: &str) -> Option<Ty> {
        self.struct_layouts.get(name).map(|layout| {
            layout
                .iter()
                .rev()
                .fold(Ty::Unit, |acc, (_, t)| {
                    Ty::Prod(Box::new(t.clone()), Box::new(acc))
                })
        })
    }

    /// Compile an expression to IR
    ///
    /// Creates a main function that evaluates the expression.
    pub fn compile(&mut self, expr: &Expr) -> Result<Program> {
        // Create main function. The return type is a placeholder here and is
        // corrected after lowering from the actual result value's type — the
        // pre-lowering `infer_type` cannot resolve named functions (empty env),
        // which previously left `main.return_ty = Unit` for programs like
        // `tambah(3, 4)` even though they return `Int`.
        let main_func = Function::new(
            FuncId::MAIN,
            "main".to_string(),
            "_unit".to_string(),
            Ty::Unit,
            self.infer_type(expr),
            self.infer_effect(expr),
        );
        self.program.add_function(main_func);
        self.current_func = Some(FuncId::MAIN);
        self.current_block = BlockId::ENTRY;

        // Pre-pass: harvest struct field layouts and struct-returning functions
        // so `FieldAccess` can be lowered to the matching positional projection.
        self.harvest_struct_info(expr);

        // Lower the expression
        let result = self.lower_expr(expr)?;

        // Correct main's return type from the lowered result value, falling
        // back to the structural estimate if the value has no recorded type.
        let ret_ty = self
            .result_var_ty(FuncId::MAIN, result)
            .unwrap_or_else(|| self.infer_type(expr));

        // Add return terminator
        if let Some(func) = self.program.function_mut(FuncId::MAIN) {
            func.return_ty = ret_ty;
            if let Some(block) = func.block_mut(self.current_block) {
                block.terminate(Terminator::Return(result));
            }
        }

        Ok(self.program.clone())
    }

    /// Look up the type the lowerer recorded for `var` (the result of some
    /// emitted instruction) by scanning the function's blocks.
    fn result_var_ty(&self, fid: FuncId, var: VarId) -> Option<Ty> {
        let func = self.program.function(fid)?;
        for block in &func.blocks {
            for instr in &block.instrs {
                if instr.result == var {
                    return Some(instr.ty.clone());
                }
            }
        }
        None
    }

    /// Allocate a fresh variable ID
    fn fresh_var(&mut self) -> VarId {
        let id = VarId::new(self.next_var);
        self.next_var += 1;
        id
    }

    /// Emit an instruction to the current block
    fn emit(&mut self, instr: Instruction, ty: Ty, level: SecurityLevel, effect: Effect) -> VarId {
        let result = self.fresh_var();
        let annotated = AnnotatedInstr {
            instr,
            result,
            ty,
            security: level,
            effect,
        };

        if let Some(func) = self.current_func {
            if let Some(func) = self.program.function_mut(func) {
                if let Some(block) = func.block_mut(self.current_block) {
                    block.push(annotated);
                }
            }
        }

        result
    }

    fn emit_string_const(&mut self, value: impl Into<String>, ty: Ty) -> VarId {
        self.emit(
            Instruction::Const(Constant::String(value.into())),
            ty,
            SecurityLevel::Public,
            Effect::Pure,
        )
    }

    fn emit_bool_const(&mut self, value: bool) -> VarId {
        self.emit(
            Instruction::Const(Constant::Bool(value)),
            Ty::Bool,
            SecurityLevel::Public,
            Effect::Pure,
        )
    }

    fn emit_builtin_call(&mut self, name: &str, arg: VarId, ty: Ty, effect: Effect) -> VarId {
        self.emit(
            Instruction::BuiltinCall {
                name: name.to_string(),
                arg,
            },
            ty,
            SecurityLevel::Public,
            effect,
        )
    }

    fn emit_concat(&mut self, left: VarId, right: VarId) -> VarId {
        self.emit(
            Instruction::BinOp(IrBinOp::Add, left, right),
            Ty::String,
            SecurityLevel::Public,
            Effect::Pure,
        )
    }

    fn lower_to_text(&mut self, expr: &Expr) -> Result<VarId> {
        let value = self.lower_expr(expr)?;
        Ok(self.emit_builtin_call("ke_teks", value, Ty::String, Effect::Pure))
    }

    fn concat_parts(&mut self, parts: &[VarId], ty: Ty) -> Result<VarId> {
        let (first, rest) = parts.split_first().ok_or_else(|| {
            Error::InvalidOperation("cannot concatenate empty UI fragment".to_string())
        })?;
        let mut acc = *first;
        for part in rest {
            acc = self.emit_concat(acc, *part);
        }
        if ty == Ty::String {
            Ok(acc)
        } else {
            Ok(self.emit(
                Instruction::Copy(acc),
                ty,
                SecurityLevel::Public,
                Effect::Pure,
            ))
        }
    }

    fn resolve_color_literal(&self, expr: &Expr) -> Option<(u8, u8, u8)> {
        match expr {
            Expr::UIColor(r, g, b) => Some((*r, *g, *b)),
            Expr::Var(name) => self.env.color(name),
            _ => None,
        }
    }

    /// Infer the type of an expression (simplified)
    fn infer_type(&self, expr: &Expr) -> Ty {
        match expr {
            Expr::Unit => Ty::Unit,
            Expr::Bool(_) => Ty::Bool,
            Expr::Int(_) => Ty::Int,
            Expr::String(_) => Ty::String,
            Expr::Pair(e1, e2) => {
                Ty::Prod(Box::new(self.infer_type(e1)), Box::new(self.infer_type(e2)))
            }
            Expr::Fst(e) => {
                if let Ty::Prod(t1, _) = self.infer_type(e) {
                    *t1
                } else {
                    Ty::Unit // Error case
                }
            }
            Expr::Snd(e) => {
                if let Ty::Prod(_, t2) = self.infer_type(e) {
                    *t2
                } else {
                    Ty::Unit // Error case
                }
            }
            Expr::Inl(_, ty) | Expr::Inr(_, ty) => ty.clone(),
            Expr::Lam(_, param_ty, body) => Ty::Fn(
                Box::new(param_ty.clone()),
                Box::new(self.infer_type(body)),
                self.infer_effect(body),
            ),
            // `pulang e` has type Any (it never yields to its own context).
            Expr::Return(_) => Ty::Any,
            Expr::Classify(e) => Ty::Secret(Box::new(self.infer_type(e))),
            Expr::Declassify(e, _) => {
                if let Ty::Secret(t) = self.infer_type(e) {
                    *t
                } else {
                    self.infer_type(e)
                }
            }
            Expr::Prove(e) => Ty::Proof(Box::new(self.infer_type(e))),
            Expr::Ref(e, level) => Ty::Ref(Box::new(self.infer_type(e)), *level),
            Expr::Deref(e) => {
                if let Ty::Ref(t, _) = self.infer_type(e) {
                    *t
                } else {
                    Ty::Unit
                }
            }
            Expr::Assign(_, _) => Ty::Unit,
            Expr::If(_, t, _)
            | Expr::Let(_, _, _, t)
            | Expr::LetRec(_, _, _, t)
            | Expr::Case(_, _, t, _, _) => self.infer_type(t),
            Expr::App(e1, _) => {
                if let Ty::Fn(_, ret, _) = self.infer_type(e1) {
                    *ret
                } else {
                    Ty::Unit
                }
            }
            Expr::Perform(_, e) | Expr::Handle(e, _, _) => self.infer_type(e),
            Expr::Require(eff, _) => Ty::Capability(eff.to_capability_kind()),
            Expr::Grant(_, e) => self.infer_type(e),
            Expr::Var(name) => self
                .env
                .lookup(name)
                .and_then(|var| self.env.types.get(&var).cloned())
                .unwrap_or(Ty::Unit), // unbound (e.g. a top-level function not yet in env) → Unit
            Expr::Loc(_) => Ty::Unit, // Runtime-only; actual type from store
            Expr::BinOp(op, lhs, rhs) => {
                let base = match op {
                    BinOp::Add | BinOp::Sub | BinOp::Mul | BinOp::Div | BinOp::Mod => Ty::Int,
                    BinOp::Eq
                    | BinOp::Ne
                    | BinOp::Lt
                    | BinOp::Le
                    | BinOp::Gt
                    | BinOp::Ge
                    | BinOp::And
                    | BinOp::Or => Ty::Bool,
                };
                // Constant-time contagion: a result derived from a ConstantTime
                // operand stays ConstantTime, so the CT discipline is preserved
                // in the IR annotations for the codegen CT verifier. Guarded on
                // CT operands, so non-CT programs are unaffected.
                if ty_is_constant_time(&self.infer_type(lhs))
                    || ty_is_constant_time(&self.infer_type(rhs))
                {
                    Ty::ConstantTime(Box::new(base))
                } else {
                    base
                }
            }
            Expr::FFICall { ret_ty, .. } => ret_ty.clone(),
            Expr::ActorDecl { .. } => Ty::Unit,
            Expr::ChoreographyBlock { .. } => Ty::Unit,
            Expr::Spawn(_, _) => Ty::Int, // Actor ref as integer ID
            Expr::ActorSend(_, _) => Ty::Unit,
            Expr::ActorRecv(_) => Ty::Int, // Message as generic value
            Expr::CRDTMerge(_, _) => Ty::Int, // Merged state
            Expr::ContentHash(_) => Ty::String, // Hash as hex string
            Expr::ContentVerify(_, _) => Ty::Bool,
            Expr::ContractDeploy(expr) => Ty::SmartContract(Box::new(self.infer_type(expr))),
            Expr::TokenTransfer { from, amount, .. } => {
                if let Ty::Token(inner) = self.infer_type(from) {
                    Ty::Token(inner)
                } else {
                    Ty::Token(Box::new(self.infer_type(amount)))
                }
            }
            Expr::ZakatCalculate(expr) => self.infer_type(expr),
            // List literal — element type is approximated as Any (the
            // typechecker computes the precise element type).
            Expr::ListLit(_) => Ty::List(Box::new(Ty::Any)),
            // A record literal lowers to a right-nested pair in field order, so
            // its type is the matching nested product `(t0, (t1, ... Unit))`.
            // This lets `Fst`/`Snd` projections (and thus `FieldAccess`) recover
            // each field's concrete type instead of collapsing to `Unit`.
            Expr::RecordLit(_, fields) => fields
                .iter()
                .rev()
                .fold(Ty::Unit, |acc, (_, e)| {
                    Ty::Prod(Box::new(self.infer_type(e)), Box::new(acc))
                }),
            // Field access — the field's type when the struct/layout is known,
            // resolved as `Fst(Snd^i(base))` over the base's product type.
            Expr::FieldAccess(base, field) => {
                let resolved = self.struct_name_of(base).and_then(|sname| {
                    self.struct_layouts
                        .get(&sname)
                        .and_then(|layout| layout.iter().position(|(f, _)| f == field))
                        .map(|idx| {
                            let mut t = self.infer_type(base);
                            for _ in 0..idx {
                                t = match t {
                                    Ty::Prod(_, t2) => *t2,
                                    _ => Ty::Any,
                                };
                            }
                            match t {
                                Ty::Prod(t1, _) => *t1,
                                _ => Ty::Any,
                            }
                        })
                });
                resolved.unwrap_or(Ty::Any)
            }
            // CAHAYA Phase J5
            Expr::UIDisplay(_) | Expr::UIRow(_) | Expr::UIColumn(_) => Ty::Element,
            Expr::UIText(_, _) => Ty::Element,
            Expr::UIButton(_, _) => Ty::Element,
            Expr::UIColor(_, _, _) => Ty::Color,
            Expr::UIStyleDecl { .. } => Ty::UIStyle,
            Expr::UIContrastCheck(_, _) => Ty::Bool,
        }
    }

    /// Infer the effect of an expression
    fn infer_effect(&self, expr: &Expr) -> Effect {
        match expr {
            Expr::Unit | Expr::Bool(_) | Expr::Int(_) | Expr::String(_) | Expr::Var(_) => {
                Effect::Pure
            }
            Expr::Lam(_, _, _) => Effect::Pure,
            Expr::LetRec(_, _, e1, e2) => self.infer_effect(e1).join(self.infer_effect(e2)),
            Expr::Pair(e1, e2) => self.infer_effect(e1).join(self.infer_effect(e2)),
            Expr::Fst(e) | Expr::Snd(e) => self.infer_effect(e),
            Expr::Inl(e, _) | Expr::Inr(e, _) => self.infer_effect(e),
            Expr::Case(e, _, e1, _, e2) => self
                .infer_effect(e)
                .join(self.infer_effect(e1))
                .join(self.infer_effect(e2)),
            Expr::If(c, t, f) => self
                .infer_effect(c)
                .join(self.infer_effect(t))
                .join(self.infer_effect(f)),
            Expr::Let(_, _, e1, e2) => self.infer_effect(e1).join(self.infer_effect(e2)),
            Expr::App(e1, e2) => {
                let base = self.infer_effect(e1).join(self.infer_effect(e2));
                if let Ty::Fn(_, _, eff) = self.infer_type(e1) {
                    base.join(eff)
                } else {
                    base
                }
            }
            Expr::Perform(eff, e) => self.infer_effect(e).join(*eff),
            Expr::Handle(e, _, h) => self.infer_effect(e).join(self.infer_effect(h)),
            Expr::Ref(e, _) => self.infer_effect(e).join(Effect::Write),
            Expr::Deref(e) => self.infer_effect(e).join(Effect::Read),
            Expr::Assign(e1, e2) => self
                .infer_effect(e1)
                .join(self.infer_effect(e2))
                .join(Effect::Write),
            Expr::Return(e) => self.infer_effect(e),
            Expr::Classify(e) | Expr::Declassify(e, _) | Expr::Prove(e) => self.infer_effect(e),
            Expr::Require(eff, e) => self.infer_effect(e).join(*eff),
            Expr::Grant(_, e) => self.infer_effect(e),
            Expr::BinOp(_, e1, e2) => self.infer_effect(e1).join(self.infer_effect(e2)),
            Expr::Loc(_) => Effect::Pure,
            Expr::FFICall { args, .. } => {
                let mut eff = Effect::System;
                for arg in args {
                    eff = eff.join(self.infer_effect(arg));
                }
                eff
            }
            Expr::ActorDecl {
                init_state,
                handler,
                ..
            } => self
                .infer_effect(init_state)
                .join(self.infer_effect(handler)),
            Expr::ChoreographyBlock { .. } => Effect::Pure,
            Expr::Spawn(a, b) => self
                .infer_effect(a)
                .join(self.infer_effect(b))
                .join(Effect::Alloc),
            Expr::ActorSend(a, b) => self
                .infer_effect(a)
                .join(self.infer_effect(b))
                .join(Effect::Write),
            Expr::ActorRecv(a) => self.infer_effect(a).join(Effect::Read),
            Expr::CRDTMerge(a, b) => self.infer_effect(a).join(self.infer_effect(b)),
            Expr::ContentHash(a) => self.infer_effect(a).join(Effect::Crypto),
            Expr::ContentVerify(a, b) => self
                .infer_effect(a)
                .join(self.infer_effect(b))
                .join(Effect::Crypto),
            Expr::ContractDeploy(a) => self.infer_effect(a).join(Effect::NetworkSecure),
            Expr::TokenTransfer { from, to, amount } => self
                .infer_effect(from)
                .join(self.infer_effect(to))
                .join(self.infer_effect(amount))
                .join(Effect::NetworkSecure),
            Expr::ZakatCalculate(a) => self.infer_effect(a),
            // List literal — effect is the join of its elements.
            Expr::ListLit(elems) => {
                let mut eff = Effect::Pure;
                for e in elems {
                    eff = eff.join(self.infer_effect(e));
                }
                eff
            }
            // Record literal — join of field effects; field access — base effect.
            Expr::RecordLit(_, fields) => {
                let mut eff = Effect::Pure;
                for (_f, e) in fields {
                    eff = eff.join(self.infer_effect(e));
                }
                eff
            }
            Expr::FieldAccess(base, _) => self.infer_effect(base),
            // CAHAYA Phase J5 — all UI expressions are pure
            Expr::UIDisplay(elems) | Expr::UIRow(elems) | Expr::UIColumn(elems) => {
                let mut eff = Effect::Pure;
                for e in elems {
                    eff = eff.join(self.infer_effect(e));
                }
                eff
            }
            Expr::UIText(a, b) | Expr::UIButton(a, b) | Expr::UIContrastCheck(a, b) => {
                self.infer_effect(a).join(self.infer_effect(b))
            }
            Expr::UIColor(_, _, _) | Expr::UIStyleDecl { .. } => Effect::Pure,
        }
    }

    /// Lower an expression to IR
    ///
    /// Returns the variable ID holding the result.
    fn lower_expr(&mut self, expr: &Expr) -> Result<VarId> {
        match expr {
            // ═══════════════════════════════════════════════════════════════
            // CONSTANTS (Expr::Unit, Expr::Bool, Expr::Int, Expr::String)
            // ═══════════════════════════════════════════════════════════════
            Expr::Unit => Ok(self.emit(
                Instruction::Const(Constant::Unit),
                Ty::Unit,
                SecurityLevel::Public,
                Effect::Pure,
            )),

            // List literal `[e1, e2, ...]` is lowered to a nil-terminated cons
            // chain of IR pairs: (e1, (e2, (... , unit))). This reuses the
            // existing Pair instruction (no new IR op needed). The interpreter
            // builds a first-class Value::List directly; this representation is
            // for the C/WASM lowering path.
            Expr::ListLit(elems) => {
                let effect = self.infer_effect(expr);
                let mut acc = self.emit(
                    Instruction::Const(Constant::Unit),
                    Ty::Unit,
                    SecurityLevel::Public,
                    Effect::Pure,
                );
                for e in elems.iter().rev() {
                    let head = self.lower_expr(e)?;
                    let elem_ty = self.infer_type(e);
                    acc = self.emit(
                        Instruction::Pair(head, acc),
                        Ty::List(Box::new(elem_ty)),
                        SecurityLevel::Public,
                        effect,
                    );
                }
                Ok(acc)
            }

            // Record literal — lowered (for the C/WASM path) as a cons chain of
            // its field values. The interpreter builds a first-class Map; field
            // names are not retained in this representation.
            Expr::RecordLit(_name, fields) => {
                let effect = self.infer_effect(expr);
                let mut acc = self.emit(
                    Instruction::Const(Constant::Unit),
                    Ty::Unit,
                    SecurityLevel::Public,
                    Effect::Pure,
                );
                for (_f, e) in fields.iter().rev() {
                    let val = self.lower_expr(e)?;
                    acc = self.emit(
                        Instruction::Pair(val, acc),
                        Ty::Any,
                        SecurityLevel::Public,
                        effect,
                    );
                }
                Ok(acc)
            }

            // Field access — resolve to a positional projection over the struct's
            // pair layout when the base's struct (and thus the field index) is
            // known: field `i` is `Fst(Snd^i(base))`, matching how `RecordLit`
            // builds its right-nested pair. Falls back to lowering the base
            // aggregate when the struct/layout is unknown (prior behavior).
            Expr::FieldAccess(base, field) => {
                let proj = self.struct_name_of(base).and_then(|sname| {
                    self.struct_layouts.get(&sname).and_then(|layout| {
                        layout.iter().position(|(f, _)| f == field).map(|idx| {
                            let mut p = (**base).clone();
                            for _ in 0..idx {
                                p = Expr::Snd(Box::new(p));
                            }
                            Expr::Fst(Box::new(p))
                        })
                    })
                });
                match proj {
                    Some(p) => self.lower_expr(&p),
                    None => self.lower_expr(base),
                }
            }

            Expr::Bool(b) => Ok(self.emit(
                Instruction::Const(Constant::Bool(*b)),
                Ty::Bool,
                SecurityLevel::Public,
                Effect::Pure,
            )),

            Expr::Int(n) => Ok(self.emit(
                Instruction::Const(Constant::Int(*n)),
                Ty::Int,
                SecurityLevel::Public,
                Effect::Pure,
            )),

            Expr::String(s) => Ok(self.emit(
                Instruction::Const(Constant::String(s.clone())),
                Ty::String,
                SecurityLevel::Public,
                Effect::Pure,
            )),

            // ═══════════════════════════════════════════════════════════════
            // VARIABLES (Expr::Var)
            // ═══════════════════════════════════════════════════════════════
            Expr::Var(name) => {
                // If it's a known builtin used as a bare value (not in App position),
                // emit a string constant placeholder so we don't crash with UnboundVariable.
                if self.env.lookup(name).is_none() {
                    if let Some(canonical) = builtin_canonical(name) {
                        return Ok(self.emit(
                            Instruction::Const(Constant::String(canonical.to_string())),
                            Ty::String,
                            SecurityLevel::Public,
                            Effect::Pure,
                        ));
                    }
                }
                let var = self
                    .env
                    .lookup(name)
                    .ok_or_else(|| Error::UnboundVariable(name.clone()))?;
                let ty = self.env.types.get(&var).cloned().unwrap_or(Ty::Unit);
                let level = self
                    .env
                    .levels
                    .get(&var)
                    .copied()
                    .unwrap_or(SecurityLevel::Public);
                Ok(self.emit(Instruction::Copy(var), ty, level, Effect::Pure))
            }

            // ═══════════════════════════════════════════════════════════════
            // FUNCTIONS (Expr::Lam, Expr::App)
            // ═══════════════════════════════════════════════════════════════
            Expr::Lam(param, param_ty, body) => {
                // Create a new function for the lambda body
                let func_id = self.program.fresh_func_id();
                let body_effect = self.infer_effect(body);
                let return_ty = self.infer_type(body);

                let mut func = Function::new(
                    func_id,
                    format!("lambda_{}", func_id.0),
                    param.clone(),
                    param_ty.clone(),
                    return_ty.clone(),
                    body_effect,
                );

                // Compute free variables that need to be captured
                let body_fv = free_vars(body);
                let mut capture_names: Vec<Ident> = body_fv
                    .into_iter()
                    .filter(|name| name != param && self.env.lookup(name).is_some())
                    .collect();
                capture_names.sort(); // deterministic order

                // Resolve captures to VarIds in the *current* environment
                let capture_vars: Vec<VarId> = capture_names
                    .iter()
                    .filter_map(|name| self.env.lookup(name))
                    .collect();

                // Record capture metadata on the function for C emission
                func.captures = capture_names
                    .iter()
                    .map(|name| {
                        let var = self.env.lookup(name).unwrap();
                        let ty = self.env.types.get(&var).cloned().unwrap_or(Ty::Unit);
                        (name.clone(), ty)
                    })
                    .collect();

                // Save current state
                let saved_func = self.current_func;
                let saved_block = self.current_block;
                let saved_env = self.env.clone();
                let saved_next_var = self.next_var;

                // Reset for new function
                self.current_func = Some(func_id);
                self.current_block = BlockId::ENTRY;
                self.next_var = 0;
                self.env = VarEnv::new();

                // Bind captured variables in the new environment
                for name in &capture_names {
                    let old_var = saved_env.lookup(name).unwrap();
                    let new_var = self.fresh_var();
                    let ty = saved_env.types.get(&old_var).cloned().unwrap_or(Ty::Unit);
                    let level = saved_env
                        .levels
                        .get(&old_var)
                        .copied()
                        .unwrap_or(SecurityLevel::Public);
                    self.env.bind(name.clone(), new_var, ty, level);
                }

                // Bind parameter
                let param_var = self.fresh_var();
                self.env.bind(
                    param.clone(),
                    param_var,
                    param_ty.clone(),
                    SecurityLevel::Public,
                );

                // Add function to program so we can add blocks to it
                self.program.add_function(func);

                // Lower the body
                let result = self.lower_expr(body)?;

                // Terminate with return
                if let Some(func) = self.program.function_mut(func_id) {
                    if let Some(block) = func.block_mut(self.current_block) {
                        block.terminate(Terminator::Return(result));
                    }
                }

                // Restore state
                self.current_func = saved_func;
                self.current_block = saved_block;
                self.env = saved_env;
                self.next_var = saved_next_var;

                // Emit closure creation with captured variables
                let fn_ty = Ty::Fn(Box::new(param_ty.clone()), Box::new(return_ty), body_effect);
                Ok(self.emit(
                    Instruction::Closure {
                        func: func_id,
                        captures: capture_vars,
                    },
                    fn_ty,
                    SecurityLevel::Public,
                    Effect::Pure,
                ))
            }

            Expr::App(func_expr, arg_expr) => {
                // Intercept builtin calls: if func is Var(name) and name is a known builtin,
                // emit BuiltinCall instead of Call.
                if let Expr::Var(name) = func_expr.as_ref() {
                    if let Some(canonical) = builtin_canonical(name) {
                        let arg_var = self.lower_expr(arg_expr)?;
                        let effect = self.infer_effect(expr);
                        return Ok(self.emit(
                            Instruction::BuiltinCall {
                                name: canonical.to_string(),
                                arg: arg_var,
                            },
                            Ty::Unit, // builtins mostly return Unit or String; C emitter handles
                            SecurityLevel::Public,
                            effect,
                        ));
                    }
                }
                let func_var = self.lower_expr(func_expr)?;
                let arg_var = self.lower_expr(arg_expr)?;
                let return_ty = if let Ty::Fn(_, ret, _) = self.infer_type(func_expr) {
                    *ret
                } else {
                    Ty::Unit
                };
                let effect = self.infer_effect(expr);
                Ok(self.emit(
                    Instruction::Call(func_var, arg_var),
                    return_ty,
                    SecurityLevel::Public,
                    effect,
                ))
            }

            // ═══════════════════════════════════════════════════════════════
            // PRODUCTS (Expr::Pair, Expr::Fst, Expr::Snd)
            // ═══════════════════════════════════════════════════════════════
            Expr::Pair(e1, e2) => {
                let v1 = self.lower_expr(e1)?;
                let v2 = self.lower_expr(e2)?;
                let ty = Ty::Prod(Box::new(self.infer_type(e1)), Box::new(self.infer_type(e2)));
                let effect = self.infer_effect(e1).join(self.infer_effect(e2));
                Ok(self.emit(Instruction::Pair(v1, v2), ty, SecurityLevel::Public, effect))
            }

            Expr::Fst(e) => {
                let v = self.lower_expr(e)?;
                let ty = if let Ty::Prod(t1, _) = self.infer_type(e) {
                    *t1
                } else {
                    Ty::Unit
                };
                Ok(self.emit(
                    Instruction::Fst(v),
                    ty,
                    SecurityLevel::Public,
                    self.infer_effect(e),
                ))
            }

            Expr::Snd(e) => {
                let v = self.lower_expr(e)?;
                let ty = if let Ty::Prod(_, t2) = self.infer_type(e) {
                    *t2
                } else {
                    Ty::Unit
                };
                Ok(self.emit(
                    Instruction::Snd(v),
                    ty,
                    SecurityLevel::Public,
                    self.infer_effect(e),
                ))
            }

            // ═══════════════════════════════════════════════════════════════
            // SUMS (Expr::Inl, Expr::Inr, Expr::Case)
            // ═══════════════════════════════════════════════════════════════
            Expr::Inl(e, ty) => {
                let v = self.lower_expr(e)?;
                Ok(self.emit(
                    Instruction::Inl(v),
                    ty.clone(),
                    SecurityLevel::Public,
                    self.infer_effect(e),
                ))
            }

            Expr::Inr(e, ty) => {
                let v = self.lower_expr(e)?;
                Ok(self.emit(
                    Instruction::Inr(v),
                    ty.clone(),
                    SecurityLevel::Public,
                    self.infer_effect(e),
                ))
            }

            Expr::Case(scrutinee, left_name, left_branch, right_name, right_branch) => {
                // Lower scrutinee
                let scrut_var = self.lower_expr(scrutinee)?;

                // Derive each branch's payload type from the scrutinee's sum type,
                // mirroring the typechecker's T_Case normalization (Sum(l, r) ⇒
                // (l, r); Option(t) ⇒ (t, Unit)). Falls back to Unit when the type
                // can't be resolved, preserving prior behavior. This types the
                // UnwrapLeft/UnwrapRight values and the branch bindings correctly
                // (was hardcoded Unit), so downstream `infer_type` of the bound
                // payload variable resolves to the real type.
                let (left_ty, right_ty) = match self.infer_type(scrutinee) {
                    Ty::Sum(l, r) => (*l, *r),
                    Ty::Option(inner) => (*inner, Ty::Unit),
                    _ => (Ty::Unit, Ty::Unit),
                };

                // Check if left or right
                let is_left = self.emit(
                    Instruction::IsLeft(scrut_var),
                    Ty::Bool,
                    SecurityLevel::Public,
                    Effect::Pure,
                );

                // Create blocks for branches and merge
                let then_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                let else_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                let merge_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                // Terminate current block with conditional branch
                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(self.current_block) {
                            block.terminate(Terminator::CondBranch {
                                cond: is_left,
                                then_block,
                                else_block,
                            });
                        }
                    }
                }

                // Left branch (then block)
                self.current_block = then_block;
                let left_val = self.emit(
                    Instruction::UnwrapLeft(scrut_var),
                    left_ty.clone(),
                    SecurityLevel::Public,
                    Effect::Pure,
                );

                let saved_env = self.env.clone();
                self.env
                    .bind(left_name.clone(), left_val, left_ty, SecurityLevel::Public);
                let left_result = self.lower_expr(left_branch)?;
                self.env = saved_env;

                let then_end_block = self.current_block;

                // Branch to merge
                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(then_end_block) {
                            block.terminate(Terminator::Branch(merge_block));
                        }
                    }
                }

                // Right branch (else block)
                self.current_block = else_block;
                let right_val = self.emit(
                    Instruction::UnwrapRight(scrut_var),
                    right_ty.clone(),
                    SecurityLevel::Public,
                    Effect::Pure,
                );

                let saved_env = self.env.clone();
                self.env.bind(
                    right_name.clone(),
                    right_val,
                    right_ty,
                    SecurityLevel::Public,
                );
                let right_result = self.lower_expr(right_branch)?;
                self.env = saved_env;

                let else_end_block = self.current_block;

                // Branch to merge
                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(else_end_block) {
                            block.terminate(Terminator::Branch(merge_block));
                        }
                    }
                }

                // Merge block with phi
                self.current_block = merge_block;
                let result_ty = self.infer_type(left_branch);
                let phi = self.emit(
                    Instruction::Phi(vec![
                        (then_end_block, left_result),
                        (else_end_block, right_result),
                    ]),
                    result_ty,
                    SecurityLevel::Public,
                    self.infer_effect(expr),
                );

                Ok(phi)
            }

            // ═══════════════════════════════════════════════════════════════
            // CONTROL FLOW (Expr::If, Expr::Let)
            // ═══════════════════════════════════════════════════════════════
            Expr::If(cond, then_expr, else_expr) => {
                let cond_var = self.lower_expr(cond)?;

                // Create blocks
                let then_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                let else_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                let merge_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                // Conditional branch
                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(self.current_block) {
                            block.terminate(Terminator::CondBranch {
                                cond: cond_var,
                                then_block,
                                else_block,
                            });
                        }
                    }
                }

                // Then branch
                self.current_block = then_block;
                let then_result = self.lower_expr(then_expr)?;
                let then_end_block = self.current_block;

                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(then_end_block) {
                            block.terminate(Terminator::Branch(merge_block));
                        }
                    }
                }

                // Else branch
                self.current_block = else_block;
                let else_result = self.lower_expr(else_expr)?;
                let else_end_block = self.current_block;

                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(else_end_block) {
                            block.terminate(Terminator::Branch(merge_block));
                        }
                    }
                }

                // Merge with phi
                self.current_block = merge_block;
                let result_ty = self.infer_type(then_expr);
                Ok(self.emit(
                    Instruction::Phi(vec![
                        (then_end_block, then_result),
                        (else_end_block, else_result),
                    ]),
                    result_ty,
                    SecurityLevel::Public,
                    self.infer_effect(expr),
                ))
            }

            Expr::Let(name, _, binding, body) => {
                let bind_var = self.lower_expr(binding)?;
                let bind_color = self.resolve_color_literal(binding);
                let bind_struct = self.struct_name_of(binding);
                // Type a struct binding as its product type (even when the value
                // is opaque, e.g. a function call) so `FieldAccess` projections
                // recover field types; otherwise use the structural estimate.
                let bind_ty = bind_struct
                    .as_ref()
                    .and_then(|s| self.struct_prod_ty(s))
                    .unwrap_or_else(|| self.infer_type(binding));

                let saved_env = self.env.clone();
                let saved_struct = self.var_struct.clone();
                self.env
                    .bind(name.clone(), bind_var, bind_ty, SecurityLevel::Public);
                if let Some(color) = bind_color {
                    self.env.bind_color(name.clone(), color);
                }
                // Track (or shadow) this binding's struct identity for FieldAccess.
                match bind_struct {
                    Some(s) => {
                        self.var_struct.insert(name.clone(), s);
                    }
                    None => {
                        self.var_struct.remove(name);
                    }
                }
                let result = self.lower_expr(body)?;
                self.env = saved_env;
                self.var_struct = saved_struct;

                Ok(result)
            }

            Expr::LetRec(name, ty_ann, binding, body) => {
                // For LetRec, we pre-bind name so the lambda body can reference it.
                // The lambda captures the placeholder VarId. After the closure is
                // created, we emit FixClosure to patch the self-capture.
                let bind_ty = ty_ann.clone();
                let placeholder = self.fresh_var();

                let saved_env = self.env.clone();
                self.env.bind(
                    name.clone(),
                    placeholder,
                    bind_ty.clone(),
                    SecurityLevel::Public,
                );

                // Lower the binding (lambda). This creates a closure that captures
                // placeholder as the self-reference.
                let bind_var = self.lower_expr(binding)?;

                // Only emit FixClosure if the binding actually captured the
                // placeholder (i.e., the function is genuinely recursive).
                // Check if the last emitted instruction for bind_var was a
                // Closure that includes placeholder in its captures.
                let needs_fix = {
                    let func = self
                        .program
                        .functions
                        .get(&self.current_func.unwrap_or(FuncId(0)));
                    func.and_then(|f| {
                        let block = f.blocks.iter().find(|b| b.id == self.current_block)?;
                        // Find the Closure instruction that produced bind_var
                        block.instrs.iter().find_map(|ai| {
                            if ai.result == bind_var {
                                if let Instruction::Closure { captures, .. } = &ai.instr {
                                    // Find which capture index holds the placeholder
                                    captures.iter().position(|v| *v == placeholder)
                                } else {
                                    None
                                }
                            } else {
                                None
                            }
                        })
                    })
                };

                if let Some(capture_index) = needs_fix {
                    self.emit(
                        Instruction::FixClosure {
                            closure: bind_var,
                            capture_index,
                        },
                        Ty::Unit,
                        SecurityLevel::Public,
                        Effect::Pure,
                    );
                }

                // For the body, use bind_var as the resolved name
                self.env
                    .bind(name.clone(), bind_var, bind_ty, SecurityLevel::Public);
                let result = self.lower_expr(body)?;
                self.env = saved_env;

                Ok(result)
            }

            // ═══════════════════════════════════════════════════════════════
            // EFFECTS (Expr::Perform, Expr::Handle)
            // ═══════════════════════════════════════════════════════════════
            Expr::Perform(effect, payload) => {
                let payload_var = self.lower_expr(payload)?;
                let payload_ty = self.infer_type(payload);
                Ok(self.emit(
                    Instruction::Perform {
                        effect: *effect,
                        payload: payload_var,
                    },
                    payload_ty,
                    SecurityLevel::Public,
                    *effect,
                ))
            }

            Expr::Handle(body, handler_var, handler) => {
                // Create blocks for body and handler
                let body_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                let handler_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                let result_block = if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        func.new_block()
                    } else {
                        return Err(Error::InvalidOperation("No current function".to_string()));
                    }
                } else {
                    return Err(Error::InvalidOperation("No current function".to_string()));
                };

                // Terminate with handle
                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(self.current_block) {
                            block.terminate(Terminator::Handle {
                                body_block,
                                handler_block,
                                resume_var: handler_var.clone(),
                                result_block,
                            });
                        }
                    }
                }

                // Lower body
                self.current_block = body_block;
                let body_result = self.lower_expr(body)?;

                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(self.current_block) {
                            block.terminate(Terminator::Branch(result_block));
                        }
                    }
                }

                // Lower handler
                self.current_block = handler_block;
                let handler_param = self.fresh_var();
                self.env.bind(
                    handler_var.clone(),
                    handler_param,
                    Ty::Unit,
                    SecurityLevel::Public,
                );
                let _handler_result = self.lower_expr(handler)?;

                if let Some(func) = self.current_func {
                    if let Some(func) = self.program.function_mut(func) {
                        if let Some(block) = func.block_mut(self.current_block) {
                            block.terminate(Terminator::Branch(result_block));
                        }
                    }
                }

                // Result block
                self.current_block = result_block;
                Ok(body_result)
            }

            // ═══════════════════════════════════════════════════════════════
            // REFERENCES (Expr::Ref, Expr::Deref, Expr::Assign)
            // ═══════════════════════════════════════════════════════════════
            Expr::Ref(init, level) => {
                let init_var = self.lower_expr(init)?;
                let inner_ty = self.infer_type(init);
                Ok(self.emit(
                    Instruction::Alloc {
                        init: init_var,
                        level: *level,
                    },
                    Ty::Ref(Box::new(inner_ty), *level),
                    *level,
                    Effect::Write,
                ))
            }

            Expr::Deref(ref_expr) => {
                let ref_var = self.lower_expr(ref_expr)?;
                let inner_ty = if let Ty::Ref(t, _) = self.infer_type(ref_expr) {
                    *t
                } else {
                    Ty::Unit
                };
                Ok(self.emit(
                    Instruction::Load(ref_var),
                    inner_ty,
                    SecurityLevel::Public,
                    Effect::Read,
                ))
            }

            Expr::Assign(ref_expr, val_expr) => {
                let ref_var = self.lower_expr(ref_expr)?;
                let val_var = self.lower_expr(val_expr)?;
                Ok(self.emit(
                    Instruction::Store(ref_var, val_var),
                    Ty::Unit,
                    SecurityLevel::Public,
                    Effect::Write,
                ))
            }

            // ═══════════════════════════════════════════════════════════════
            // `pulang e` — early return. The IR backend has no early-return
            // instruction, so the operand is lowered and its value flows through
            // (best-effort; the reference interpreter implements true unwinding).
            Expr::Return(inner) => self.lower_expr(inner),

            // SECURITY (Expr::Classify, Expr::Declassify, Expr::Prove)
            // ═══════════════════════════════════════════════════════════════
            Expr::Classify(inner) => {
                let inner_var = self.lower_expr(inner)?;
                let inner_ty = self.infer_type(inner);
                Ok(self.emit(
                    Instruction::Classify(inner_var),
                    Ty::Secret(Box::new(inner_ty)),
                    SecurityLevel::Secret,
                    self.infer_effect(inner),
                ))
            }

            Expr::Declassify(secret, proof) => {
                let secret_var = self.lower_expr(secret)?;
                let proof_var = self.lower_expr(proof)?;
                let inner_ty = if let Ty::Secret(t) = self.infer_type(secret) {
                    *t
                } else {
                    self.infer_type(secret)
                };
                Ok(self.emit(
                    Instruction::Declassify(secret_var, proof_var),
                    inner_ty,
                    SecurityLevel::Public,
                    self.infer_effect(expr),
                ))
            }

            Expr::Prove(inner) => {
                let inner_var = self.lower_expr(inner)?;
                let inner_ty = self.infer_type(inner);
                Ok(self.emit(
                    Instruction::Prove(inner_var),
                    Ty::Proof(Box::new(inner_ty)),
                    SecurityLevel::Public,
                    self.infer_effect(inner),
                ))
            }

            // ═══════════════════════════════════════════════════════════════
            // CAPABILITIES (Expr::Require, Expr::Grant)
            // ═══════════════════════════════════════════════════════════════
            Expr::Require(effect, body) => {
                let _cap = self.emit(
                    Instruction::RequireCap(*effect),
                    Ty::Capability(effect.to_capability_kind()),
                    SecurityLevel::Public,
                    *effect,
                );
                self.lower_expr(body)
            }

            Expr::Grant(effect, body) => {
                let _cap = self.emit(
                    Instruction::GrantCap(*effect),
                    Ty::Capability(effect.to_capability_kind()),
                    SecurityLevel::Public,
                    Effect::Pure,
                );
                self.lower_expr(body)
            }

            Expr::Loc(l) => {
                // ELoc is a runtime-only value (store location).
                // Encode as integer constant; the runtime interprets it as a location.
                let result_ty = Ty::Unit;
                Ok(self.emit(
                    Instruction::Const(Constant::Int(*l)),
                    result_ty,
                    SecurityLevel::Public,
                    Effect::Pure,
                ))
            }

            Expr::FFICall { name, args, ret_ty } => {
                let mut arg_vars = Vec::new();
                for arg in args {
                    arg_vars.push(self.lower_expr(arg)?);
                }
                Ok(self.emit(
                    Instruction::FFICall {
                        name: name.clone(),
                        args: arg_vars,
                    },
                    ret_ty.clone(),
                    SecurityLevel::Public,
                    Effect::System,
                ))
            }

            Expr::ActorDecl {
                name,
                init_state,
                handler,
                ..
            } => {
                let init_var = self.lower_expr(init_state)?;
                let handler_var = self.lower_expr(handler)?;
                Ok(self.emit(
                    Instruction::ActorDecl {
                        name: name.clone(),
                        init_state: init_var,
                        handler: handler_var,
                    },
                    Ty::Unit,
                    SecurityLevel::Public,
                    Effect::Pure,
                ))
            }

            Expr::ChoreographyBlock { name, roles, .. } => Ok(self.emit(
                Instruction::ChoreographyDecl {
                    name: name.clone(),
                    roles: roles.clone(),
                },
                Ty::Unit,
                SecurityLevel::Public,
                Effect::Pure,
            )),

            Expr::Spawn(actor_expr, state_expr) => {
                let actor_var = self.lower_expr(actor_expr)?;
                let state_var = self.lower_expr(state_expr)?;
                Ok(self.emit(
                    Instruction::ActorSpawn(actor_var, state_var),
                    Ty::Int,
                    SecurityLevel::Public,
                    Effect::Alloc,
                ))
            }

            Expr::ActorSend(actor_expr, msg_expr) => {
                let actor_var = self.lower_expr(actor_expr)?;
                let msg_var = self.lower_expr(msg_expr)?;
                Ok(self.emit(
                    Instruction::ActorSend(actor_var, msg_var),
                    Ty::Unit,
                    SecurityLevel::Public,
                    Effect::Write,
                ))
            }

            Expr::ActorRecv(actor_expr) => {
                let actor_var = self.lower_expr(actor_expr)?;
                Ok(self.emit(
                    Instruction::ActorRecv(actor_var),
                    Ty::Int,
                    SecurityLevel::Public,
                    Effect::Read,
                ))
            }

            Expr::CRDTMerge(a_expr, b_expr) => {
                let a_var = self.lower_expr(a_expr)?;
                let b_var = self.lower_expr(b_expr)?;
                Ok(self.emit(
                    Instruction::CRDTMerge(a_var, b_var),
                    Ty::Int,
                    SecurityLevel::Public,
                    Effect::Pure,
                ))
            }

            Expr::ContentHash(val_expr) => {
                let val_var = self.lower_expr(val_expr)?;
                Ok(self.emit(
                    Instruction::ContentHash(val_var),
                    Ty::String,
                    SecurityLevel::Public,
                    Effect::Crypto,
                ))
            }

            Expr::ContentVerify(expected_hash_expr, value_expr) => {
                let expected_hash_var = self.lower_expr(expected_hash_expr)?;
                let value_var = self.lower_expr(value_expr)?;
                let actual_hash_var = self.emit(
                    Instruction::ContentHash(value_var),
                    Ty::String,
                    SecurityLevel::Public,
                    Effect::Crypto,
                );
                Ok(self.emit(
                    Instruction::BinOp(IrBinOp::Eq, expected_hash_var, actual_hash_var),
                    Ty::Bool,
                    SecurityLevel::Public,
                    Effect::Crypto,
                ))
            }

            Expr::ContractDeploy(contract_expr) => self.lower_expr(contract_expr),

            Expr::TokenTransfer {
                from: from_expr,
                to: to_expr,
                amount: amount_expr,
            } => {
                let _from_var = self.lower_expr(from_expr)?;
                let _to_var = self.lower_expr(to_expr)?;
                self.lower_expr(amount_expr)
            }

            Expr::ZakatCalculate(value_expr) => self.lower_expr(value_expr),

            // CAHAYA Phase J5 — lower UI values to string-backed HTML
            Expr::UIDisplay(elements) | Expr::UIColumn(elements) => {
                let mut parts = vec![self.emit_string_const(
                    "<div style='display:flex;flex-direction:column'>\n",
                    Ty::String,
                )];
                for element in elements {
                    parts.push(self.lower_to_text(element)?);
                    parts.push(self.emit_string_const("\n", Ty::String));
                }
                parts.push(self.emit_string_const("</div>\n", Ty::String));
                self.concat_parts(&parts, Ty::Element)
            }

            Expr::UIRow(elements) => {
                let mut parts = vec![self.emit_string_const(
                    "<div style='display:flex;flex-direction:row'>\n",
                    Ty::String,
                )];
                for element in elements {
                    parts.push(self.lower_to_text(element)?);
                    parts.push(self.emit_string_const("\n", Ty::String));
                }
                parts.push(self.emit_string_const("</div>\n", Ty::String));
                self.concat_parts(&parts, Ty::Element)
            }

            Expr::UIText(content_expr, color_expr) => {
                let content = self.lower_to_text(content_expr)?;
                let color = self.lower_expr(color_expr)?;
                let parts = vec![
                    self.emit_string_const("<span style='color:", Ty::String),
                    color,
                    self.emit_string_const("'>", Ty::String),
                    content,
                    self.emit_string_const("</span>", Ty::String),
                ];
                self.concat_parts(&parts, Ty::Element)
            }

            Expr::UIButton(label_expr, _handler_expr) => {
                let label = self.lower_to_text(label_expr)?;
                let parts = vec![
                    self.emit_string_const("<button type='button'>", Ty::String),
                    label,
                    self.emit_string_const("</button>", Ty::String),
                ];
                self.concat_parts(&parts, Ty::Element)
            }

            Expr::UIColor(r, g, b) => {
                Ok(self.emit_string_const(css_hex_color(*r, *g, *b), Ty::Color))
            }

            Expr::UIStyleDecl { padding, font_size } => {
                Ok(self.emit_string_const(css_style_fragment(*padding, *font_size), Ty::UIStyle))
            }

            Expr::UIContrastCheck(fg_expr, bg_expr) => {
                let fg = self.resolve_color_literal(fg_expr).ok_or_else(|| {
                    Error::InvalidOperation(
                        "ui contrast lowering requires literal or let-bound UIColor".to_string(),
                    )
                })?;
                let bg = self.resolve_color_literal(bg_expr).ok_or_else(|| {
                    Error::InvalidOperation(
                        "ui contrast lowering requires literal or let-bound UIColor".to_string(),
                    )
                })?;
                Ok(self.emit_bool_const(wcag_aa_contrast_ok(fg, bg)))
            }

            Expr::BinOp(op, lhs, rhs) => {
                let l = self.lower_expr(lhs)?;
                let r = self.lower_expr(rhs)?;
                let ir_op = match op {
                    BinOp::Add => IrBinOp::Add,
                    BinOp::Sub => IrBinOp::Sub,
                    BinOp::Mul => IrBinOp::Mul,
                    BinOp::Div => IrBinOp::Div,
                    BinOp::Mod => IrBinOp::Mod,
                    BinOp::Eq => IrBinOp::Eq,
                    BinOp::Ne => IrBinOp::Ne,
                    BinOp::Lt => IrBinOp::Lt,
                    BinOp::Le => IrBinOp::Le,
                    BinOp::Gt => IrBinOp::Gt,
                    BinOp::Ge => IrBinOp::Ge,
                    BinOp::And => IrBinOp::And,
                    BinOp::Or => IrBinOp::Or,
                };
                let result_ty = self.infer_type(expr);
                let effect = self.infer_effect(expr);
                Ok(self.emit(
                    Instruction::BinOp(ir_op, l, r),
                    result_ty,
                    SecurityLevel::Public,
                    effect,
                ))
            }
        }
    }
}

impl Default for Lower {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_lower_unit() {
        let mut lower = Lower::new();
        let prog = lower.compile(&Expr::Unit).unwrap();
        assert!(prog.function(FuncId::MAIN).is_some());
    }

    #[test]
    fn test_lower_bool() {
        let mut lower = Lower::new();
        let prog = lower.compile(&Expr::Bool(true)).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        assert!(!main.blocks.is_empty());
    }

    #[test]
    fn test_lower_int() {
        let mut lower = Lower::new();
        let prog = lower.compile(&Expr::Int(42)).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        assert!(!main.blocks.is_empty());
    }

    #[test]
    fn test_lower_pair() {
        let mut lower = Lower::new();
        let pair = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        let prog = lower.compile(&pair).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        // Should have 3 instructions: const 1, const 2, pair
        assert!(main.blocks[0].instrs.len() >= 3);
    }

    #[test]
    fn test_lower_fst() {
        let mut lower = Lower::new();
        let pair = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        let fst = Expr::Fst(Box::new(pair));
        let prog = lower.compile(&fst).unwrap();
        assert!(prog.function(FuncId::MAIN).is_some());
    }

    #[test]
    fn test_lower_let() {
        let mut lower = Lower::new();
        let let_expr = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(42)),
            Box::new(Expr::Var("x".to_string())),
        );
        let prog = lower.compile(&let_expr).unwrap();
        assert!(prog.function(FuncId::MAIN).is_some());
    }

    #[test]
    fn test_lower_if() {
        let mut lower = Lower::new();
        let if_expr = Expr::If(
            Box::new(Expr::Bool(true)),
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        );
        let prog = lower.compile(&if_expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        // Should have multiple blocks: entry, then, else, merge
        assert!(main.blocks.len() >= 4);
    }

    #[test]
    fn test_lower_lambda() {
        let mut lower = Lower::new();
        let lam = Expr::Lam(
            "x".to_string(),
            Ty::Int,
            Box::new(Expr::Var("x".to_string())),
        );
        let prog = lower.compile(&lam).unwrap();
        // Should have main function and lambda function
        assert!(prog.functions.len() >= 2);
    }

    #[test]
    fn test_lower_classify() {
        let mut lower = Lower::new();
        let classify = Expr::Classify(Box::new(Expr::Int(42)));
        let prog = lower.compile(&classify).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        // Check that classify instruction was emitted
        let has_classify = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Classify(_)));
        assert!(has_classify);
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL LITERAL TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_lower_bool_false() {
        let mut lower = Lower::new();
        let prog = lower.compile(&Expr::Bool(false)).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_false = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Const(Constant::Bool(false))));
        assert!(has_false);
    }

    #[test]
    fn test_lower_string() {
        let mut lower = Lower::new();
        let prog = lower.compile(&Expr::String("hello".to_string())).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_string = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(&i.instr, Instruction::Const(Constant::String(s)) if s == "hello"));
        assert!(has_string);
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL PAIR/SUM TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_lower_snd() {
        let mut lower = Lower::new();
        let pair = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        let snd = Expr::Snd(Box::new(pair));
        let prog = lower.compile(&snd).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_snd = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Snd(_)));
        assert!(has_snd);
    }

    #[test]
    fn test_lower_inl() {
        let mut lower = Lower::new();
        let inl = Expr::Inl(Box::new(Expr::Int(42)), Ty::Bool);
        let prog = lower.compile(&inl).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_inl = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Inl(_)));
        assert!(has_inl);
    }

    #[test]
    fn test_lower_inr() {
        let mut lower = Lower::new();
        let inr = Expr::Inr(Box::new(Expr::Bool(true)), Ty::Int);
        let prog = lower.compile(&inr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_inr = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Inr(_)));
        assert!(has_inr);
    }

    #[test]
    fn test_lower_case() {
        let mut lower = Lower::new();
        let case = Expr::Case(
            Box::new(Expr::Inl(Box::new(Expr::Int(1)), Ty::Bool)),
            "x".to_string(),
            Box::new(Expr::Var("x".to_string())),
            "y".to_string(),
            Box::new(Expr::Int(0)),
        );
        let prog = lower.compile(&case).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        // Case creates multiple blocks
        assert!(main.blocks.len() >= 3);
    }

    // Helper: scan all blocks for the (UnwrapLeft, UnwrapRight) result types.
    fn unwrap_payload_types(main: &crate::ir::Function) -> (Option<Ty>, Option<Ty>) {
        let (mut left, mut right) = (None, None);
        for block in &main.blocks {
            for ins in &block.instrs {
                if matches!(ins.instr, Instruction::UnwrapLeft(_)) {
                    left = Some(ins.ty.clone());
                }
                if matches!(ins.instr, Instruction::UnwrapRight(_)) {
                    right = Some(ins.ty.clone());
                }
            }
        }
        (left, right)
    }

    #[test]
    fn test_lower_case_sum_payload_types() {
        // A `Case` over a `Sum(Int, String)` scrutinee must type the unwrapped
        // payloads with the real branch types, not the old hardcoded `Unit`
        // (mirrors the typechecker's T_Case normalization).
        let mut lower = Lower::new();
        let sum_ty = Ty::Sum(Box::new(Ty::Int), Box::new(Ty::String));
        let case = Expr::Case(
            Box::new(Expr::Inl(Box::new(Expr::Int(7)), sum_ty)),
            "x".to_string(),
            Box::new(Expr::Var("x".to_string())),
            "y".to_string(),
            Box::new(Expr::Var("y".to_string())),
        );
        let prog = lower.compile(&case).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let (left, right) = unwrap_payload_types(main);
        assert_eq!(left, Some(Ty::Int), "UnwrapLeft payload should be Int");
        assert_eq!(right, Some(Ty::String), "UnwrapRight payload should be String");
    }

    #[test]
    fn test_lower_case_option_payload_types() {
        // `Option(T)` normalizes to (T, Unit): the present arm carries T, the
        // absent arm carries Unit.
        let mut lower = Lower::new();
        let opt_ty = Ty::Option(Box::new(Ty::Bool));
        let case = Expr::Case(
            Box::new(Expr::Inl(Box::new(Expr::Bool(true)), opt_ty)),
            "x".to_string(),
            Box::new(Expr::Var("x".to_string())),
            "y".to_string(),
            Box::new(Expr::Var("y".to_string())),
        );
        let prog = lower.compile(&case).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let (left, right) = unwrap_payload_types(main);
        assert_eq!(left, Some(Ty::Bool), "present-arm payload should be Bool");
        assert_eq!(right, Some(Ty::Unit), "absent-arm payload should be Unit");
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL SECURITY TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_lower_declassify() {
        let mut lower = Lower::new();
        // Declassify takes a secret value and a proof
        let classified = Box::new(Expr::Classify(Box::new(Expr::Int(42))));
        let proof = Box::new(Expr::Prove(Box::new(Expr::Bool(true))));
        let declassify = Expr::Declassify(classified, proof);
        let prog = lower.compile(&declassify).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_declassify = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Declassify(_, _)));
        assert!(has_declassify);
    }

    #[test]
    fn test_lower_prove() {
        let mut lower = Lower::new();
        let prove = Expr::Prove(Box::new(Expr::Bool(true)));
        let prog = lower.compile(&prove).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_prove = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Prove(_)));
        assert!(has_prove);
    }

    #[test]
    fn test_lower_require() {
        let mut lower = Lower::new();
        // Require takes an Effect and a body expression
        let require = Expr::Require(Effect::Read, Box::new(Expr::Unit));
        let prog = lower.compile(&require).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_require = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::RequireCap(_)));
        assert!(has_require);
    }

    // ═══════════════════════════════════════════════════════════════════
    // EFFECT TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_lower_grant() {
        let mut lower = Lower::new();
        let grant = Expr::Grant(Effect::Read, Box::new(Expr::Unit));
        let prog = lower.compile(&grant).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_grant = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::GrantCap(Effect::Read)));
        assert!(has_grant);
    }

    // ═══════════════════════════════════════════════════════════════════
    // REFERENCE TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_lower_ref() {
        let mut lower = Lower::new();
        let ref_expr = Expr::Ref(Box::new(Expr::Int(42)), SecurityLevel::Public);
        let prog = lower.compile(&ref_expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_alloc = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Alloc { .. }));
        assert!(has_alloc);
    }

    #[test]
    fn test_lower_deref() {
        let mut lower = Lower::new();
        let deref = Expr::Deref(Box::new(Expr::Ref(
            Box::new(Expr::Int(42)),
            SecurityLevel::Public,
        )));
        let prog = lower.compile(&deref).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_load = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Load(_)));
        assert!(has_load);
    }

    // ═══════════════════════════════════════════════════════════════════
    // NESTED STRUCTURE TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_lower_nested_let() {
        let mut lower = Lower::new();
        let nested = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(1)),
            Box::new(Expr::Let(
                "y".to_string(),
                None,
                Box::new(Expr::Int(2)),
                Box::new(Expr::Var("x".to_string())),
            )),
        );
        let prog = lower.compile(&nested).unwrap();
        assert!(prog.function(FuncId::MAIN).is_some());
    }

    #[test]
    fn test_lower_nested_pair() {
        let mut lower = Lower::new();
        let nested = Expr::Pair(
            Box::new(Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)))),
            Box::new(Expr::Int(3)),
        );
        let prog = lower.compile(&nested).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        // Should have multiple pair instructions
        let pair_count = main.blocks[0]
            .instrs
            .iter()
            .filter(|i| matches!(i.instr, Instruction::Pair(_, _)))
            .count();
        assert!(pair_count >= 2);
    }

    // ═══════════════════════════════════════════════════════════════════════
    // JALINAN Phase 6 LOWERING TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_lower_actor_decl() {
        let mut lower = Lower::new();
        let expr = Expr::ActorDecl {
            name: "Counter".into(),
            state_ty: Ty::Int,
            message_ty: Ty::Int,
            init_state: Box::new(Expr::Int(0)),
            handler: Box::new(Expr::Lam(
                "msg".into(),
                Ty::Int,
                Box::new(Expr::Var("msg".into())),
            )),
        };
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_actor_decl = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::ActorDecl { .. }));
        assert!(has_actor_decl);
    }

    #[test]
    fn test_lower_choreography_block() {
        let mut lower = Lower::new();
        let expr = Expr::ChoreographyBlock {
            name: "Protocol".into(),
            roles: vec!["A".into(), "B".into()],
            protocol: riina_types::SessionType::End,
        };
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_choreo = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::ChoreographyDecl { .. }));
        assert!(has_choreo);
    }

    #[test]
    fn test_lower_spawn() {
        let mut lower = Lower::new();
        let expr = Expr::Spawn(Box::new(Expr::Unit), Box::new(Expr::Int(0)));
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_spawn = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::ActorSpawn(_, _)));
        assert!(has_spawn);
    }

    #[test]
    fn test_lower_actor_send() {
        let mut lower = Lower::new();
        let expr = Expr::ActorSend(Box::new(Expr::Int(1)), Box::new(Expr::Int(42)));
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_send = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::ActorSend(_, _)));
        assert!(has_send);
    }

    #[test]
    fn test_lower_actor_recv() {
        let mut lower = Lower::new();
        let expr = Expr::ActorRecv(Box::new(Expr::Int(1)));
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_recv = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::ActorRecv(_)));
        assert!(has_recv);
    }

    #[test]
    fn test_lower_crdt_merge() {
        let mut lower = Lower::new();
        let expr = Expr::CRDTMerge(Box::new(Expr::Int(5)), Box::new(Expr::Int(10)));
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_merge = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::CRDTMerge(_, _)));
        assert!(has_merge);
    }

    #[test]
    fn test_lower_content_hash() {
        let mut lower = Lower::new();
        let expr = Expr::ContentHash(Box::new(Expr::Int(42)));
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let has_hash = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::ContentHash(_)));
        assert!(has_hash);
    }

    #[test]
    fn test_lower_content_verify() {
        let mut lower = Lower::new();
        let expr = Expr::ContentVerify(
            Box::new(Expr::ContentHash(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(42)),
        );
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let hash_count = main.blocks[0]
            .instrs
            .iter()
            .filter(|i| matches!(i.instr, Instruction::ContentHash(_)))
            .count();
        let has_eq = main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::BinOp(IrBinOp::Eq, _, _)));
        assert_eq!(hash_count, 2);
        assert!(has_eq);
    }

    #[test]
    fn test_lower_ui_text_emits_html_fragments() {
        let mut lower = Lower::new();
        let expr = Expr::UIText(
            Box::new(Expr::String("hello".into())),
            Box::new(Expr::UIColor(255, 0, 0)),
        );
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        let string_consts: Vec<&str> = main.blocks[0]
            .instrs
            .iter()
            .filter_map(|i| match &i.instr {
                Instruction::Const(Constant::String(s)) => Some(s.as_str()),
                _ => None,
            })
            .collect();
        assert!(string_consts.contains(&"<span style='color:"));
        assert!(string_consts.contains(&"#ff0000"));
        assert!(string_consts.contains(&"</span>"));
    }

    #[test]
    fn test_lower_ui_contrast_literal_fold() {
        let mut lower = Lower::new();
        let expr = Expr::UIContrastCheck(
            Box::new(Expr::UIColor(255, 255, 255)),
            Box::new(Expr::UIColor(0, 0, 0)),
        );
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        assert!(main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Const(Constant::Bool(true)))));
    }

    #[test]
    fn test_lower_ui_contrast_let_bound_color() {
        let mut lower = Lower::new();
        let expr = Expr::Let(
            "fg".into(),
            None,
            Box::new(Expr::UIColor(255, 255, 255)),
            Box::new(Expr::UIContrastCheck(
                Box::new(Expr::Var("fg".into())),
                Box::new(Expr::UIColor(0, 0, 0)),
            )),
        );
        let prog = lower.compile(&expr).unwrap();
        let main = prog.function(FuncId::MAIN).unwrap();
        assert!(main.blocks[0]
            .instrs
            .iter()
            .any(|i| matches!(i.instr, Instruction::Const(Constant::Bool(true)))));
    }
}
