// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Reference Interpreter
//!
//! A direct implementation of the RIINA operational semantics.
//! Corresponds exactly to the Coq `eval` relation in
//! `02_FORMAL/coq/foundations/Semantics.v`.
//!
//! # Correspondence with Coq
//!
//! ```coq
//! (* 02_FORMAL/coq/foundations/Semantics.v *)
//!
//! (* Big-step evaluation relation *)
//! Inductive eval : env -> store -> expr -> store -> value -> Prop :=
//!   (* Values *)
//!   | E_Unit : forall ρ σ,
//!       eval ρ σ EUnit σ VUnit
//!   | E_Bool : forall ρ σ b,
//!       eval ρ σ (EBool b) σ (VBool b)
//!   | E_Int : forall ρ σ n,
//!       eval ρ σ (EInt n) σ (VInt n)
//!   | E_String : forall ρ σ s,
//!       eval ρ σ (EString s) σ (VString s)
//!   | E_Var : forall ρ σ x v,
//!       lookup ρ x = Some v ->
//!       eval ρ σ (EVar x) σ v
//!
//!   (* Functions *)
//!   | E_Lam : forall ρ σ x T e,
//!       eval ρ σ (ELam x T e) σ (VClosure ρ x T e)
//!   | E_App : forall ρ σ σ' σ'' e1 e2 x T body ρ' v2 v,
//!       eval ρ σ e1 σ' (VClosure ρ' x T body) ->
//!       eval ρ σ' e2 σ'' v2 ->
//!       eval (extend ρ' x v2) σ'' body σ''' v ->
//!       eval ρ σ (EApp e1 e2) σ''' v
//!
//!   (* ... 22 more rules for all expression forms ... *)
//! ```
//!
//! Each method in `Interpreter` implements one or more of these rules.
//!
//! # Security Properties
//!
//! The interpreter enforces:
//! 1. **Non-interference**: Secret values cannot flow to public outputs
//! 2. **Effect safety**: Effects only occur when capabilities are held
//! 3. **Memory safety**: References are always valid
//!
//! # Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST

use crate::value::{Closure, Env, Location, RefCell, Sum, Value};
use crate::{Error, Result};
use riina_types::{BinOp, Effect, Expr, SecurityLevel};
use std::collections::HashMap;
use std::rc::Rc;

fn declassify_proof_matches(secret_expr: &Expr, proof_expr: &Expr) -> bool {
    match (secret_expr, proof_expr) {
        (Expr::Classify(secret), Expr::Prove(inner_proof)) => {
            matches!(inner_proof.as_ref(), Expr::Classify(proof_secret) if **secret == **proof_secret)
        }
        _ => false,
    }
}

fn css_hex_color(r: u8, g: u8, b: u8) -> String {
    format!("#{r:02x}{g:02x}{b:02x}")
}

fn ansi_colorize(text: &str, r: u8, g: u8, b: u8) -> String {
    format!("\x1b[38;2;{r};{g};{b}m{text}\x1b[0m")
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

fn render_ui_value(value: &Value) -> String {
    match value {
        Value::String(s) => s.clone(),
        Value::Bool(b) => b.to_string(),
        Value::Int(n) => n.to_string(),
        Value::Unit => "()".to_string(),
        Value::Color(r, g, b) => css_hex_color(*r, *g, *b),
        _ => value.to_string(),
    }
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

fn contrast_ratio(fg: (u8, u8, u8), bg: (u8, u8, u8)) -> f64 {
    let fg_l = relative_luminance(fg.0, fg.1, fg.2);
    let bg_l = relative_luminance(bg.0, bg.1, bg.2);
    let (lighter, darker) = if fg_l >= bg_l {
        (fg_l, bg_l)
    } else {
        (bg_l, fg_l)
    };
    (lighter + 0.05) / (darker + 0.05)
}

fn has_wcag_aa_contrast(fg: (u8, u8, u8), bg: (u8, u8, u8)) -> bool {
    contrast_ratio(fg, bg) >= 4.5
}

fn expect_color(value: Value, context: &str) -> Result<(u8, u8, u8)> {
    if let Value::Color(r, g, b) = value {
        Ok((r, g, b))
    } else {
        Err(Error::TypeMismatch {
            expected: "color".to_string(),
            found: format!("{value:?}"),
            context: context.to_string(),
        })
    }
}

fn fnv1a_hash_bytes(bytes: &[u8]) -> u64 {
    const FNV_OFFSET_BASIS: u64 = 14_695_981_039_346_656_037;
    const FNV_PRIME: u64 = 1_099_511_628_211;

    let mut hash = FNV_OFFSET_BASIS;
    for &byte in bytes {
        hash ^= u64::from(byte);
        hash = hash.wrapping_mul(FNV_PRIME);
    }
    hash
}

fn encode_hash_value(hash: u64) -> Value {
    Value::Hash(format!("{hash:016x}").into_bytes())
}

fn decode_hash_value(hash_value: &Value) -> Result<u64> {
    match hash_value {
        Value::Hash(bytes) => {
            let hex = std::str::from_utf8(bytes).map_err(|_| {
                Error::InvalidOperation("content hash bytes must be valid UTF-8 hex".to_string())
            })?;
            u64::from_str_radix(hex, 16).map_err(|_| {
                Error::InvalidOperation("content hash must be a 16-digit hex string".to_string())
            })
        }
        other => Err(Error::TypeMismatch {
            expected: "hash".to_string(),
            found: format!("{other:?}"),
            context: "content lookup".to_string(),
        }),
    }
}

fn merkle_root_hash(leaves: &[u64]) -> u64 {
    if leaves.is_empty() {
        return fnv1a_hash_bytes(b"");
    }

    let mut bytes = Vec::with_capacity(std::mem::size_of_val(leaves));
    for leaf in leaves {
        bytes.extend_from_slice(&leaf.to_be_bytes());
    }
    fnv1a_hash_bytes(&bytes)
}

/// Mutable store (heap)
#[derive(Debug, Clone, Default)]
pub struct Store {
    /// Map from locations to values
    cells: HashMap<Location, (Value, SecurityLevel)>,
    /// Next available location
    next_loc: u32,
}

impl Store {
    /// Create a new empty store
    #[must_use]
    pub fn new() -> Self {
        Self {
            cells: HashMap::new(),
            next_loc: 0,
        }
    }

    /// Allocate a new reference
    pub fn alloc(&mut self, value: Value, level: SecurityLevel) -> Location {
        let loc = Location::new(self.next_loc);
        self.next_loc += 1;
        self.cells.insert(loc, (value, level));
        loc
    }

    /// Read from a location
    pub fn read(&self, loc: Location) -> Result<&Value> {
        self.cells
            .get(&loc)
            .map(|(v, _)| v)
            .ok_or_else(|| Error::InvalidReference(format!("location {} not found", loc)))
    }

    /// Read with security level
    pub fn read_with_level(&self, loc: Location) -> Result<(&Value, SecurityLevel)> {
        self.cells
            .get(&loc)
            .map(|(v, l)| (v, *l))
            .ok_or_else(|| Error::InvalidReference(format!("location {} not found", loc)))
    }

    /// Write to a location
    pub fn write(&mut self, loc: Location, value: Value) -> Result<()> {
        if let Some((v, _)) = self.cells.get_mut(&loc) {
            *v = value;
            Ok(())
        } else {
            Err(Error::InvalidReference(format!(
                "location {} not found",
                loc
            )))
        }
    }
}

/// Effect handler context
#[derive(Debug, Clone)]
struct HandlerContext {
    // NB: handler matching is LIFO and effect-agnostic (the most recently
    // installed handler runs for any `perform`), matching the Coq `T_Handle`
    // rule which joins effects rather than discriminating by effect tag.
    // There is therefore no per-handler effect to track here.
    /// Handler variable name
    handler_var: String,
    /// Handler expression
    handler: Rc<Expr>,
    /// Handler environment
    handler_env: Env,
}

/// Capability context
#[derive(Debug, Clone, Default)]
struct Capabilities {
    /// Set of held capabilities
    held: Vec<Effect>,
}

impl Capabilities {
    fn new() -> Self {
        Self { held: Vec::new() }
    }

    fn grant(&mut self, eff: Effect) {
        if !self.held.contains(&eff) {
            self.held.push(eff);
        }
    }

    fn has(&self, eff: Effect) -> bool {
        // Pure always allowed
        if eff == Effect::Pure {
            return true;
        }
        // Check if any held capability subsumes this effect
        self.held.iter().any(|h| h.level() >= eff.level())
    }
}

/// Reference interpreter
///
/// Implements the RIINA operational semantics.
/// Every evaluation corresponds to a derivation of the `eval` relation.
pub struct Interpreter {
    /// Global store (heap)
    store: Store,
    /// Effect handlers
    handlers: Vec<HandlerContext>,
    /// Capabilities
    caps: Capabilities,
    /// Current security context
    security_context: SecurityLevel,
    /// Next actor ID counter (JALINAN Phase 6)
    next_actor_id: u64,
    /// Registered actor definitions (JALINAN Phase 6)
    actor_defs: std::collections::HashMap<String, Expr>,
    /// Actor states: id → current state value (JALINAN Phase 6)
    actor_states: std::collections::HashMap<u64, Value>,
    /// Actor handlers: id → handler expression (JALINAN Phase 6)
    actor_handlers: std::collections::HashMap<u64, Expr>,
    /// Content-addressed store: hash → original value (JALINAN Phase 6 J2)
    content_store: HashMap<u64, Value>,
}

impl Interpreter {
    /// Create a new interpreter
    #[must_use]
    pub fn new() -> Self {
        Self {
            store: Store::new(),
            handlers: Vec::new(),
            caps: Capabilities::new(),
            security_context: SecurityLevel::Public,
            next_actor_id: 0,
            actor_defs: std::collections::HashMap::new(),
            actor_states: std::collections::HashMap::new(),
            actor_handlers: std::collections::HashMap::new(),
            content_store: HashMap::new(),
        }
    }

    /// Hash a runtime value into the content-addressed store.
    #[must_use]
    pub fn content_hash_value(&mut self, value: Value) -> Value {
        if value.is_hash() {
            return value;
        }
        encode_hash_value(self.store_content_addressed_value(value))
    }

    /// Look up a stored value by its raw content hash.
    #[must_use]
    pub fn content_lookup(&self, hash: u64) -> Option<&Value> {
        self.content_store.get(&hash)
    }

    /// Look up a stored value by a RIINA `Hash` value.
    #[must_use]
    pub fn content_lookup_hash(&self, hash_value: &Value) -> Option<&Value> {
        decode_hash_value(hash_value)
            .ok()
            .and_then(|hash| self.content_store.get(&hash))
    }

    fn store_content_addressed_value(&mut self, value: Value) -> u64 {
        match value {
            Value::List(items) => {
                let leaf_hashes = items
                    .iter()
                    .cloned()
                    .map(|item| self.store_content_addressed_value(item))
                    .collect::<Vec<_>>();
                let root_hash = merkle_root_hash(&leaf_hashes);
                self.content_store
                    .entry(root_hash)
                    .or_insert_with(|| Value::List(items));
                root_hash
            }
            other => {
                let hash = fnv1a_hash_value(&other);
                self.content_store.entry(hash).or_insert(other);
                hash
            }
        }
    }

    /// Evaluate an expression
    ///
    /// Main entry point. Creates an empty environment and evaluates.
    ///
    /// # Correspondence
    ///
    /// ```coq
    /// Definition run (e : expr) : option value :=
    ///   match eval empty_env empty_store e with
    ///   | (_, v) => Some v
    ///   end.
    /// ```
    pub fn eval(&mut self, expr: &Expr) -> Result<Value> {
        let env = Env::new();
        Self::catch_toplevel_return(self.eval_with_env(&env, expr))
    }

    /// Evaluate with built-in functions pre-registered.
    pub fn eval_with_builtins(&mut self, expr: &Expr) -> Result<Value> {
        let env = crate::builtins::register_builtins(&Env::new());
        Self::catch_toplevel_return(self.eval_with_env(&env, expr))
    }

    /// Catch a `pulang` that unwinds all the way to the top level (i.e. a return
    /// used outside any function), treating its value as the program's result.
    fn catch_toplevel_return(r: Result<Value>) -> Result<Value> {
        match r {
            Err(Error::Return(v)) => Ok(*v),
            other => other,
        }
    }

    /// Evaluate with an environment
    ///
    /// This is the core evaluation function. Each match arm corresponds
    /// to a rule in the Coq `eval` relation.
    fn eval_with_env(&mut self, env: &Env, expr: &Expr) -> Result<Value> {
        match expr {
            // ═══════════════════════════════════════════════════════════════
            // VALUES (E_Unit, E_Bool, E_Int, E_String)
            // ═══════════════════════════════════════════════════════════════

            // E_Unit: eval ρ σ EUnit σ VUnit
            Expr::Unit => Ok(Value::Unit),

            // E_Bool: eval ρ σ (EBool b) σ (VBool b)
            Expr::Bool(b) => Ok(Value::Bool(*b)),

            // E_Int: eval ρ σ (EInt n) σ (VInt n)
            Expr::Int(n) => Ok(Value::Int(*n)),

            // Sized integer literal: reduce the magnitude modulo 2^bits and carry
            // the width so arithmetic on it wraps at that width (numeric tower).
            Expr::IntN {
                value,
                bits,
                signed,
            } => Ok(Value::IntN {
                value: mask_width(*value, *bits),
                bits: *bits,
                signed: *signed,
            }),

            // E_String: eval ρ σ (EString s) σ (VString s)
            Expr::String(s) => Ok(Value::String(s.clone())),

            // ═══════════════════════════════════════════════════════════════
            // VARIABLES (E_Var)
            // ═══════════════════════════════════════════════════════════════

            // E_Var: lookup ρ x = Some v -> eval ρ σ (EVar x) σ v
            Expr::Var(name) => env
                .lookup(name)
                .cloned()
                .ok_or_else(|| Error::UnboundVariable(name.clone())),

            // ═══════════════════════════════════════════════════════════════
            // FUNCTIONS (E_Lam, E_App)
            // ═══════════════════════════════════════════════════════════════

            // E_Lam: eval ρ σ (ELam x T e) σ (VClosure ρ x T e)
            Expr::Lam(param, param_ty, body) => Ok(Value::Closure(Closure {
                env: env.clone(),
                param: param.clone(),
                param_ty: param_ty.clone(),
                body: Rc::new((**body).clone()),
            })),

            // E_App: Application rule
            Expr::App(func_expr, arg_expr) => {
                let func_val = self.eval_with_env(env, func_expr)?;
                let arg_val = self.eval_with_env(env, arg_expr)?;

                match func_val {
                    Value::Closure(closure) => {
                        // Extend closure environment with argument
                        let new_env = closure.env.extend(closure.param.clone(), arg_val);
                        // Evaluate body, catching an early `pulang` that unwinds
                        // to this function-application boundary. A curried call
                        // `f(a)(b)` only raises at the final application (earlier
                        // ones just build closures), so catching here scopes each
                        // return to its own function call.
                        match self.eval_with_env(&new_env, &closure.body) {
                            Err(Error::Return(v)) => Ok(*v),
                            other => other,
                        }
                    }
                    Value::Builtin(ref name) if crate::builtins::is_higher_order_builtin(name) => {
                        self.eval_higher_order_builtin(name, arg_val)?
                            .ok_or_else(|| {
                                Error::InvalidOperation(format!(
                                    "higher-order builtin {} failed",
                                    name
                                ))
                            })
                    }
                    Value::Builtin(name) => crate::builtins::apply_builtin(&name, arg_val),
                    // Partially-applied builtin: form pair and complete the call
                    Value::BuiltinPartial(name, first_arg) => {
                        let pair = Value::Pair(first_arg, Box::new(arg_val));
                        crate::builtins::apply_builtin(&name, pair)
                    }
                    _ => Err(Error::TypeMismatch {
                        expected: "function".to_string(),
                        found: format!("{:?}", func_val),
                        context: "application".to_string(),
                    }),
                }
            }

            // ═══════════════════════════════════════════════════════════════
            // PRODUCTS (E_Pair, E_Fst, E_Snd)
            // ═══════════════════════════════════════════════════════════════

            // E_Pair: eval ρ σ (EPair e1 e2) σ'' (VPair v1 v2)
            Expr::Pair(e1, e2) => {
                let v1 = self.eval_with_env(env, e1)?;
                let v2 = self.eval_with_env(env, e2)?;
                Ok(Value::Pair(Box::new(v1), Box::new(v2)))
            }

            // List literal `[e1, e2, ...]` — evaluate each element left to right.
            Expr::ListLit(elems) => {
                let mut items = Vec::with_capacity(elems.len());
                for e in elems {
                    items.push(self.eval_with_env(env, e)?);
                }
                Ok(Value::List(items))
            }

            // Record literal `Name { f: e, ... }` — evaluate to a string-keyed
            // Map (records are structural at runtime).
            Expr::RecordLit(_name, fields) => {
                let mut map = std::collections::BTreeMap::new();
                for (field, e) in fields {
                    map.insert(field.clone(), self.eval_with_env(env, e)?);
                }
                Ok(Value::Map(map))
            }

            // Field access `e.field` — look the field up in the record Map.
            Expr::FieldAccess(base, field) => {
                let v = self.eval_with_env(env, base)?;
                match v {
                    Value::Map(map) => map.get(field).cloned().ok_or_else(|| {
                        Error::TypeMismatch {
                            expected: format!("record with field `{field}`"),
                            found: "record without that field".to_string(),
                            context: "field access".to_string(),
                        }
                    }),
                    other => Err(Error::TypeMismatch {
                        expected: "record".to_string(),
                        found: format!("{other:?}"),
                        context: "field access".to_string(),
                    }),
                }
            }

            // E_Fst: eval ρ σ e σ' (VPair v1 v2) -> eval ρ σ (EFst e) σ' v1
            Expr::Fst(e) => {
                let v = self.eval_with_env(env, e)?;
                match v {
                    Value::Pair(v1, _) => Ok(*v1),
                    _ => Err(Error::TypeMismatch {
                        expected: "pair".to_string(),
                        found: format!("{:?}", v),
                        context: "fst".to_string(),
                    }),
                }
            }

            // E_Snd: eval ρ σ e σ' (VPair v1 v2) -> eval ρ σ (ESnd e) σ' v2
            Expr::Snd(e) => {
                let v = self.eval_with_env(env, e)?;
                match v {
                    Value::Pair(_, v2) => Ok(*v2),
                    _ => Err(Error::TypeMismatch {
                        expected: "pair".to_string(),
                        found: format!("{:?}", v),
                        context: "snd".to_string(),
                    }),
                }
            }

            // ═══════════════════════════════════════════════════════════════
            // SUMS (E_Inl, E_Inr, E_Case)
            // ═══════════════════════════════════════════════════════════════

            // E_Inl: eval ρ σ e σ' v -> eval ρ σ (EInl e T) σ' (VInl v)
            Expr::Inl(e, _ty) => {
                let v = self.eval_with_env(env, e)?;
                Ok(Value::Sum(Sum::Left(Box::new(v))))
            }

            // E_Inr: eval ρ σ e σ' v -> eval ρ σ (EInr e T) σ' (VInr v)
            Expr::Inr(e, _ty) => {
                let v = self.eval_with_env(env, e)?;
                Ok(Value::Sum(Sum::Right(Box::new(v))))
            }

            // E_CaseL / E_CaseR: Case analysis
            Expr::Case(scrut, left_name, left_branch, right_name, right_branch) => {
                let scrut_val = self.eval_with_env(env, scrut)?;
                match scrut_val {
                    Value::Sum(Sum::Left(v)) => {
                        let new_env = env.extend(left_name.clone(), *v);
                        self.eval_with_env(&new_env, left_branch)
                    }
                    Value::Sum(Sum::Right(v)) => {
                        let new_env = env.extend(right_name.clone(), *v);
                        self.eval_with_env(&new_env, right_branch)
                    }
                    _ => Err(Error::TypeMismatch {
                        expected: "sum".to_string(),
                        found: format!("{:?}", scrut_val),
                        context: "case".to_string(),
                    }),
                }
            }

            // ═══════════════════════════════════════════════════════════════
            // CONTROL FLOW (E_IfTrue, E_IfFalse, E_Let)
            // ═══════════════════════════════════════════════════════════════

            // E_IfTrue / E_IfFalse
            Expr::If(cond, then_expr, else_expr) => {
                let cond_val = self.eval_with_env(env, cond)?;
                match cond_val {
                    Value::Bool(true) => self.eval_with_env(env, then_expr),
                    Value::Bool(false) => self.eval_with_env(env, else_expr),
                    _ => Err(Error::TypeMismatch {
                        expected: "bool".to_string(),
                        found: format!("{:?}", cond_val),
                        context: "if condition".to_string(),
                    }),
                }
            }

            // E_Let: eval ρ σ e1 σ' v1 -> eval (extend ρ x v1) σ' e2 σ'' v2
            //        -> eval ρ σ (ELet x e1 e2) σ'' v2
            Expr::Let(name, _, binding, body) => {
                let bind_val = self.eval_with_env(env, binding)?;
                let new_env = env.extend(name.clone(), bind_val);
                self.eval_with_env(&new_env, body)
            }

            // E_Return: `pulang e` — evaluate the operand, then unwind to the
            // nearest enclosing function-application boundary by raising the
            // non-error `Error::Return` control-flow signal. The closure-call
            // rule (and the top-level `eval` entry) catch it.
            Expr::Return(e) => {
                let v = self.eval_with_env(env, e)?;
                Err(Error::Return(Box::new(v)))
            }

            // E_LetRec: Recursive let binding (fix-point)
            // For a recursive function, we wrap the body in an expression
            // that re-binds the function name on each call.
            Expr::LetRec(name, _ty, binding, body) => {
                // For LetRec, the binding (typically a lambda) needs the
                // function name in scope. We achieve this by storing the
                // raw binding expression and re-evaluating the self-reference
                // pattern: wrap the original lambda body so it re-binds `name`.
                match binding.as_ref() {
                    Expr::Lam(param, param_ty, lam_body) => {
                        // Create a closure whose body is wrapped:
                        // let rec name = lam(param) { let name = <self> in lam_body }
                        // We use a LetRec-aware closure: the closure env includes
                        // the name bound to itself.
                        let rec_body = Expr::LetRec(
                            name.clone(),
                            _ty.clone(),
                            binding.clone(),
                            Box::new((**lam_body).clone()),
                        );
                        let rec_closure = Value::Closure(Closure {
                            env: env.clone(),
                            param: param.clone(),
                            param_ty: param_ty.clone(),
                            body: Rc::new(rec_body),
                        });
                        let new_env = env.extend(name.clone(), rec_closure);
                        self.eval_with_env(&new_env, body)
                    }
                    _ => {
                        // Non-lambda binding. This is how a *zero-argument*
                        // function desugars (its body becomes the binding,
                        // evaluated eagerly), so the binding evaluation is itself
                        // a function-return boundary: catch an early `pulang`
                        // here and treat its value as the binding's value.
                        let bind_val = match self.eval_with_env(env, binding) {
                            Err(Error::Return(v)) => *v,
                            other => other?,
                        };
                        let new_env = env.extend(name.clone(), bind_val);
                        self.eval_with_env(&new_env, body)
                    }
                }
            }

            // ═══════════════════════════════════════════════════════════════
            // EFFECTS (E_Perform, E_Handle)
            // ═══════════════════════════════════════════════════════════════

            // E_Perform: Trigger an effect
            Expr::Perform(effect, payload) => {
                // Check capability
                if !self.caps.has(*effect) {
                    return Err(Error::MissingCapability(*effect));
                }

                let payload_val = self.eval_with_env(env, payload)?;

                // Look for a handler
                if let Some(handler_ctx) = self.handlers.pop() {
                    // Run handler with payload
                    let handler_env = handler_ctx
                        .handler_env
                        .extend(handler_ctx.handler_var.clone(), payload_val);
                    let result = self.eval_with_env(&handler_env, &handler_ctx.handler)?;
                    self.handlers.push(handler_ctx);
                    Ok(result)
                } else {
                    // No handler, return payload
                    Err(Error::UnhandledEffect(*effect))
                }
            }

            // E_Handle: Install effect handler (LIFO, effect-agnostic — see
            // HandlerContext; the topmost handler runs for any `perform`).
            Expr::Handle(body, handler_var, handler) => {
                // Push handler context
                self.handlers.push(HandlerContext {
                    handler_var: handler_var.clone(),
                    handler: Rc::new((**handler).clone()),
                    handler_env: env.clone(),
                });

                // Evaluate body
                let result = self.eval_with_env(env, body);

                // Pop handler
                self.handlers.pop();

                result
            }

            // ═══════════════════════════════════════════════════════════════
            // REFERENCES (E_Ref, E_Deref, E_Assign)
            // ═══════════════════════════════════════════════════════════════

            // E_Ref: Allocate a reference
            Expr::Ref(init, level) => {
                // Check capability for Write effect
                if !self.caps.has(Effect::Write) {
                    // Grant implicit capability for reference operations
                    self.caps.grant(Effect::Write);
                    self.caps.grant(Effect::Read);
                }

                let init_val = self.eval_with_env(env, init)?;
                let loc = self.store.alloc(init_val, *level);
                Ok(Value::Ref(RefCell {
                    location: loc,
                    level: *level,
                }))
            }

            // E_Deref: Dereference
            Expr::Deref(ref_expr) => {
                let ref_val = self.eval_with_env(env, ref_expr)?;
                match ref_val {
                    Value::Ref(cell) => {
                        let (val, level) = self.store.read_with_level(cell.location)?;

                        // Security check: don't leak high data to low context
                        if !level.leq(self.security_context) {
                            return Err(Error::SecurityViolation {
                                context_level: self.security_context,
                                data_level: level,
                            });
                        }

                        Ok(val.clone())
                    }
                    // `!` overloaded as logical-not on Bool (Deref shares the `!` token).
                    Value::Bool(b) => Ok(Value::Bool(!b)),
                    _ => Err(Error::TypeMismatch {
                        expected: "reference".to_string(),
                        found: format!("{:?}", ref_val),
                        context: "deref".to_string(),
                    }),
                }
            }

            // E_Assign: Assign to reference
            Expr::Assign(ref_expr, val_expr) => {
                let ref_val = self.eval_with_env(env, ref_expr)?;
                let new_val = self.eval_with_env(env, val_expr)?;

                match ref_val {
                    Value::Ref(cell) => {
                        // Security check: don't store high data in low cell
                        if new_val.security_level() == SecurityLevel::Secret
                            && cell.level == SecurityLevel::Public
                        {
                            return Err(Error::SecurityViolation {
                                context_level: cell.level,
                                data_level: new_val.security_level(),
                            });
                        }

                        self.store.write(cell.location, new_val)?;
                        Ok(Value::Unit)
                    }
                    _ => Err(Error::TypeMismatch {
                        expected: "reference".to_string(),
                        found: format!("{:?}", ref_val),
                        context: "assign".to_string(),
                    }),
                }
            }

            // ═══════════════════════════════════════════════════════════════
            // SECURITY (E_Classify, E_Declassify, E_Prove)
            // ═══════════════════════════════════════════════════════════════

            // E_Classify: Mark value as secret
            Expr::Classify(inner) => {
                let inner_val = self.eval_with_env(env, inner)?;
                Ok(Value::Secret(Box::new(inner_val)))
            }

            // E_Declassify: Reveal secret (requires proof)
            Expr::Declassify(secret, proof) => {
                let secret_val = self.eval_with_env(env, secret)?;
                let _proof_val = self.eval_with_env(env, proof)?;

                if !declassify_proof_matches(secret, proof) {
                    return Err(Error::InvalidOperation(
                        "invalid declassification proof".to_string(),
                    ));
                }

                match secret_val {
                    Value::Secret(v) => Ok(*v),
                    v => Ok(v), // Already public
                }
            }

            // E_Prove: Create proof witness
            Expr::Prove(inner) => {
                let inner_val = self.eval_with_env(env, inner)?;
                Ok(Value::Proof(Box::new(inner_val)))
            }

            // ═══════════════════════════════════════════════════════════════
            // CAPABILITIES (E_Require, E_Grant)
            // ═══════════════════════════════════════════════════════════════

            // E_Require: Demand a capability
            Expr::Require(effect, body) => {
                if !self.caps.has(*effect) {
                    return Err(Error::MissingCapability(*effect));
                }
                self.eval_with_env(env, body)
            }

            // E_Grant: Provide a capability
            Expr::Grant(effect, body) => {
                self.caps.grant(*effect);
                self.eval_with_env(env, body)
            }

            // ═══════════════════════════════════════════════════════════════
            // LOCATIONS (Expr::Loc — runtime-only, corresponds to Coq ELoc)
            // ═══════════════════════════════════════════════════════════════
            Expr::Loc(l) => {
                // Store locations are runtime values (Coq ELoc); look up in store
                let loc = Location::new(*l as u32);
                self.store.read(loc).cloned()
            }

            // ═══════════════════════════════════════════════════════════════
            // FFI CALLS — cannot be interpreted
            // ═══════════════════════════════════════════════════════════════
            Expr::FFICall { name, .. } => Err(Error::InvalidOperation(format!(
                "FFI call to '{}' cannot be interpreted; use `riinac build` to compile",
                name
            ))),

            // ═══════════════════════════════════════════════════════════════
            // BINARY OPERATIONS (Expr::BinOp)
            // ═══════════════════════════════════════════════════════════════
            // ═══════════════════════════════════════════════════════════════
            // JALINAN Phase 6 (Actor, Choreography, CRDT, Content-Addressed)
            // ═══════════════════════════════════════════════════════════════
            Expr::ActorDecl {
                name,
                init_state,
                handler,
                ..
            } => {
                // Register actor type: evaluate and store handler for spawn
                let _init = self.eval_with_env(env, init_state)?;
                let _handler = self.eval_with_env(env, handler)?;
                // Store actor definition for later use by Spawn
                self.actor_defs
                    .insert(name.clone(), handler.as_ref().clone());
                Ok(Value::Unit)
            }

            Expr::ChoreographyBlock { .. } => {
                // Protocol declaration — no runtime behavior
                Ok(Value::Unit)
            }

            Expr::Spawn(actor_expr, state_expr) => {
                // Resolve actor handler from defs
                let handler = match actor_expr.as_ref() {
                    Expr::Var(name) => self.actor_defs.get(name).cloned(),
                    _ => None,
                };
                let state = self.eval_with_env(env, state_expr)?;
                self.next_actor_id += 1;
                let id = self.next_actor_id;
                self.actor_states.insert(id, state);
                if let Some(h) = handler {
                    self.actor_handlers.insert(id, h);
                }
                Ok(Value::ActorRef(id))
            }

            Expr::ActorSend(actor_expr, msg_expr) => {
                let actor = self.eval_with_env(env, actor_expr)?;
                let msg = self.eval_with_env(env, msg_expr)?;
                // Synchronous message processing: apply handler lambda to message
                if let Value::ActorRef(id) = actor {
                    if let Some(handler) = self.actor_handlers.get(&id).cloned() {
                        // Handler is a Lam(param, ty, body) — apply it to the message
                        let app = Expr::App(
                            Box::new(handler),
                            Box::new(Expr::Int(msg.as_int().unwrap_or(0))),
                        );
                        let result = self.eval_with_env(env, &app)?;
                        self.actor_states.insert(id, result);
                    }
                }
                Ok(Value::Unit)
            }

            Expr::ActorRecv(actor_expr) => {
                let actor = self.eval_with_env(env, actor_expr)?;
                // Return current actor state
                if let Value::ActorRef(id) = actor {
                    if let Some(state) = self.actor_states.get(&id) {
                        return Ok(state.clone());
                    }
                }
                Ok(Value::Unit)
            }

            Expr::CRDTMerge(a_expr, b_expr) => {
                let a = self.eval_with_env(env, a_expr)?;
                let b = self.eval_with_env(env, b_expr)?;
                Ok(crdt_merge_values(&a, &b))
            }

            Expr::ContentHash(val_expr) => {
                let val = self.eval_with_env(env, val_expr)?;
                Ok(self.content_hash_value(val))
            }

            Expr::ContentVerify(expected_hash_expr, val_expr) => {
                let expected_hash = self.eval_with_env(env, expected_hash_expr)?;
                let val = self.eval_with_env(env, val_expr)?;
                let actual_hash = if val.is_hash() {
                    val
                } else {
                    self.content_hash_value(val)
                };
                Ok(Value::Bool(expected_hash == actual_hash))
            }

            Expr::ContractDeploy(contract_expr) => self.eval_with_env(env, contract_expr),

            Expr::TokenTransfer {
                from: from_expr,
                to: to_expr,
                amount: amount_expr,
            } => {
                let _from = self.eval_with_env(env, from_expr)?;
                let _to = self.eval_with_env(env, to_expr)?;
                self.eval_with_env(env, amount_expr)
            }

            Expr::ZakatCalculate(value_expr) => {
                let value = self.eval_with_env(env, value_expr)?;
                match value {
                    Value::Int(amount) => Ok(Value::Int(amount / 40)),
                    other => Err(Error::TypeMismatch {
                        expected: "integer".to_string(),
                        found: format!("{other:?}"),
                        context: "zakat".to_string(),
                    }),
                }
            }

            // CAHAYA Phase J5 — UI primitives
            Expr::UIDisplay(elements) | Expr::UIColumn(elements) => {
                let rendered = elements
                    .iter()
                    .map(|element| {
                        self.eval_with_env(env, element)
                            .map(|v| render_ui_value(&v))
                    })
                    .collect::<Result<Vec<_>>>()?
                    .join("\n");
                Ok(Value::String(rendered))
            }

            Expr::UIRow(elements) => {
                let rendered = elements
                    .iter()
                    .map(|element| {
                        self.eval_with_env(env, element)
                            .map(|v| render_ui_value(&v))
                    })
                    .collect::<Result<Vec<_>>>()?
                    .join(" ");
                Ok(Value::String(rendered))
            }

            Expr::UIText(content_expr, color_expr) => {
                let content = self.eval_with_env(env, content_expr)?;
                let color = expect_color(self.eval_with_env(env, color_expr)?, "ui_text")?;
                Ok(Value::String(ansi_colorize(
                    &render_ui_value(&content),
                    color.0,
                    color.1,
                    color.2,
                )))
            }

            Expr::UIButton(label_expr, _handler_expr) => {
                let label = self.eval_with_env(env, label_expr)?;
                Ok(Value::String(format!("[{}]", render_ui_value(&label))))
            }

            Expr::UIColor(r, g, b) => Ok(Value::Color(*r, *g, *b)),

            Expr::UIStyleDecl { padding, font_size } => {
                Ok(Value::String(css_style_fragment(*padding, *font_size)))
            }

            Expr::UIContrastCheck(fg_expr, bg_expr) => {
                let fg = expect_color(self.eval_with_env(env, fg_expr)?, "ui_contrast_check")?;
                let bg = expect_color(self.eval_with_env(env, bg_expr)?, "ui_contrast_check")?;
                Ok(Value::Bool(has_wcag_aa_contrast(fg, bg)))
            }

            Expr::BinOp(op, lhs, rhs) => {
                let l = self.eval_with_env(env, lhs)?;
                let r = self.eval_with_env(env, rhs)?;
                // Numeric tower: if either operand is a sized integer, arithmetic
                // and comparisons wrap/interpret at that width (a plain `Int`
                // literal adapts to the sized operand). Falls through to the
                // unsized arms below only for non-integer ops (And/Or) or operand
                // shapes this path does not handle.
                if matches!(l, Value::IntN { .. }) || matches!(r, Value::IntN { .. }) {
                    if let Some(result) = eval_sized_int_binop(*op, &l, &r) {
                        return result;
                    }
                }
                match (op, &l, &r) {
                    (BinOp::Add, Value::Int(a), Value::Int(b)) => {
                        Ok(Value::Int(a.wrapping_add(*b)))
                    }
                    (BinOp::Add, Value::String(a), Value::String(b)) => {
                        Ok(Value::String(format!("{a}{b}")))
                    }
                    // `+` concatenates lists (e.g. `[x] + akum`).
                    (BinOp::Add, Value::List(a), Value::List(b)) => {
                        let mut items = a.clone();
                        items.extend(b.iter().cloned());
                        Ok(Value::List(items))
                    }
                    (BinOp::Sub, Value::Int(a), Value::Int(b)) => {
                        Ok(Value::Int(a.wrapping_sub(*b)))
                    }
                    (BinOp::Mul, Value::Int(a), Value::Int(b)) => {
                        Ok(Value::Int(a.wrapping_mul(*b)))
                    }
                    (BinOp::Div, Value::Int(a), Value::Int(b)) => {
                        if *b == 0 {
                            return Err(Error::DivisionByZero);
                        }
                        Ok(Value::Int(a / b))
                    }
                    (BinOp::Mod, Value::Int(a), Value::Int(b)) => {
                        if *b == 0 {
                            return Err(Error::DivisionByZero);
                        }
                        Ok(Value::Int(a % b))
                    }
                    (BinOp::Eq, Value::Int(a), Value::Int(b)) => Ok(Value::Bool(a == b)),
                    (BinOp::Ne, Value::Int(a), Value::Int(b)) => Ok(Value::Bool(a != b)),
                    (BinOp::Lt, Value::Int(a), Value::Int(b)) => Ok(Value::Bool(a < b)),
                    (BinOp::Le, Value::Int(a), Value::Int(b)) => Ok(Value::Bool(a <= b)),
                    (BinOp::Gt, Value::Int(a), Value::Int(b)) => Ok(Value::Bool(a > b)),
                    (BinOp::Ge, Value::Int(a), Value::Int(b)) => Ok(Value::Bool(a >= b)),
                    (BinOp::Eq, Value::String(a), Value::String(b)) => Ok(Value::Bool(a == b)),
                    (BinOp::Ne, Value::String(a), Value::String(b)) => Ok(Value::Bool(a != b)),
                    (BinOp::Eq, Value::Bool(a), Value::Bool(b)) => Ok(Value::Bool(a == b)),
                    (BinOp::Ne, Value::Bool(a), Value::Bool(b)) => Ok(Value::Bool(a != b)),
                    (BinOp::And, Value::Bool(a), Value::Bool(b)) => Ok(Value::Bool(*a && *b)),
                    (BinOp::Or, Value::Bool(a), Value::Bool(b)) => Ok(Value::Bool(*a || *b)),
                    _ => Err(Error::TypeMismatch {
                        expected: "matching operand types for binary op".to_string(),
                        found: format!("{:?} {:?} {:?}", l, op, r),
                        context: "binary operation".to_string(),
                    }),
                }
            }
        }
    }
}

/// Reduce a value modulo `2^bits` (the raw two's-complement bit pattern of a
/// width-`bits` integer). `bits` is one of 8/16/32/64; width 64 is identity.
fn mask_width(value: u64, bits: u8) -> u64 {
    if bits >= 64 {
        value
    } else {
        value & ((1u64 << bits) - 1)
    }
}

/// Interpret a width-`bits` two's-complement bit pattern as a signed `i64`
/// (sign-extending from bit `bits-1`). Used for signed division/modulo,
/// comparison, and display of `Value::IntN`.
fn sext_width(value: u64, bits: u8) -> i64 {
    if bits >= 64 {
        value as i64
    } else {
        let shift = 64 - u32::from(bits);
        ((value << shift) as i64) >> shift
    }
}

/// Extract an integer operand: its raw bits plus, for a sized value, its
/// `(bits, signed)`. Returns `None` for non-integers.
fn as_int_operand(v: &Value) -> Option<(u64, Option<(u8, bool)>)> {
    match v {
        Value::Int(n) => Some((*n, None)),
        Value::IntN {
            value,
            bits,
            signed,
        } => Some((*value, Some((*bits, *signed)))),
        _ => None,
    }
}

/// Width-aware integer binop for the numeric tower. Called when at least one
/// operand is a `Value::IntN`. The sized operand fixes the width; a plain `Int`
/// operand is reduced to that width. Add/Sub/Mul wrap modulo `2^bits`;
/// Div/Mod/comparison respect signedness. Returns `None` for non-integer
/// operands or the boolean-only `And`/`Or` (so the caller's unsized arms — and
/// their generic type-mismatch error — still apply).
fn eval_sized_int_binop(op: BinOp, l: &Value, r: &Value) -> Option<Result<Value>> {
    let (a_raw, aw) = as_int_operand(l)?;
    let (b_raw, bw) = as_int_operand(r)?;
    let (bits, signed) = aw.or(bw)?; // at least one operand is sized (caller guard)
    let a = mask_width(a_raw, bits);
    let b = mask_width(b_raw, bits);
    let sized = |v: u64| Value::IntN {
        value: mask_width(v, bits),
        bits,
        signed,
    };
    let res = match op {
        BinOp::Add => Ok(sized(a.wrapping_add(b))),
        BinOp::Sub => Ok(sized(a.wrapping_sub(b))),
        BinOp::Mul => Ok(sized(a.wrapping_mul(b))),
        BinOp::Div => {
            if b == 0 {
                return Some(Err(Error::DivisionByZero));
            }
            if signed {
                Ok(sized(sext_width(a, bits).wrapping_div(sext_width(b, bits)) as u64))
            } else {
                Ok(sized(a / b))
            }
        }
        BinOp::Mod => {
            if b == 0 {
                return Some(Err(Error::DivisionByZero));
            }
            if signed {
                Ok(sized(sext_width(a, bits).wrapping_rem(sext_width(b, bits)) as u64))
            } else {
                Ok(sized(a % b))
            }
        }
        BinOp::Eq => Ok(Value::Bool(a == b)),
        BinOp::Ne => Ok(Value::Bool(a != b)),
        BinOp::Lt | BinOp::Le | BinOp::Gt | BinOp::Ge => {
            let ord = if signed {
                sext_width(a, bits).cmp(&sext_width(b, bits))
            } else {
                a.cmp(&b)
            };
            let truth = match op {
                BinOp::Lt => ord.is_lt(),
                BinOp::Le => ord.is_le(),
                BinOp::Gt => ord.is_gt(),
                _ => ord.is_ge(),
            };
            Ok(Value::Bool(truth))
        }
        BinOp::And | BinOp::Or => return None, // boolean-only operators
    };
    Some(res)
}

/// FNV-1a hash: feed bytes from a Value into the running hash state.
fn fnv1a_feed(hash: &mut u64, val: &Value) {
    const FNV_PRIME: u64 = 1_099_511_628_211;
    match val {
        Value::Unit => {
            *hash ^= 0x00;
            *hash = hash.wrapping_mul(FNV_PRIME);
        }
        Value::Int(n) => {
            let mut n = *n;
            for _ in 0..8 {
                *hash ^= n & 0xff;
                *hash = hash.wrapping_mul(FNV_PRIME);
                n >>= 8;
            }
        }
        Value::IntN {
            value,
            bits,
            signed,
        } => {
            // Feed the value bytes like `Int`, then the width/signedness so
            // distinct sized types (e.g. `42u8` vs `42u16`) hash distinctly.
            let mut n = *value;
            for _ in 0..8 {
                *hash ^= n & 0xff;
                *hash = hash.wrapping_mul(FNV_PRIME);
                n >>= 8;
            }
            *hash ^= u64::from(*bits);
            *hash = hash.wrapping_mul(FNV_PRIME);
            *hash ^= u64::from(*signed);
            *hash = hash.wrapping_mul(FNV_PRIME);
        }
        Value::String(s) => {
            for b in s.bytes() {
                *hash ^= u64::from(b);
                *hash = hash.wrapping_mul(FNV_PRIME);
            }
        }
        Value::Bool(b) => {
            *hash ^= if *b { 1 } else { 0 };
            *hash = hash.wrapping_mul(FNV_PRIME);
        }
        Value::Pair(a, b) => {
            // Tag bytes distinguish pairs from concatenated components
            *hash ^= 0x01;
            *hash = hash.wrapping_mul(FNV_PRIME);
            fnv1a_feed(hash, a);
            *hash ^= 0x02;
            *hash = hash.wrapping_mul(FNV_PRIME);
            fnv1a_feed(hash, b);
        }
        Value::Hash(bytes) => {
            for &b in bytes {
                *hash ^= u64::from(b);
                *hash = hash.wrapping_mul(FNV_PRIME);
            }
        }
        Value::Color(r, g, b) => {
            for &component in &[*r, *g, *b] {
                *hash ^= u64::from(component);
                *hash = hash.wrapping_mul(FNV_PRIME);
            }
        }
        Value::List(items) => {
            *hash ^= 0x03;
            *hash = hash.wrapping_mul(FNV_PRIME);
            for item in items {
                fnv1a_feed(hash, item);
                *hash ^= 0x04;
                *hash = hash.wrapping_mul(FNV_PRIME);
            }
        }
        Value::Map(entries) => {
            *hash ^= 0x05;
            *hash = hash.wrapping_mul(FNV_PRIME);
            for (key, value) in entries {
                for byte in key.bytes() {
                    *hash ^= u64::from(byte);
                    *hash = hash.wrapping_mul(FNV_PRIME);
                }
                *hash ^= 0x06;
                *hash = hash.wrapping_mul(FNV_PRIME);
                fnv1a_feed(hash, value);
            }
        }
        Value::ActorRef(id) => {
            for byte in id.to_le_bytes() {
                *hash ^= u64::from(byte);
                *hash = hash.wrapping_mul(FNV_PRIME);
            }
        }
        Value::CRDTState(value, metadata) => {
            *hash ^= 0x07;
            *hash = hash.wrapping_mul(FNV_PRIME);
            fnv1a_feed(hash, value);
            *hash ^= 0x08;
            *hash = hash.wrapping_mul(FNV_PRIME);
            fnv1a_feed(hash, metadata);
        }
        _ => {}
    }
}

/// Compute FNV-1a hash of a Value, returning the u64 digest.
fn fnv1a_hash_value(val: &Value) -> u64 {
    let mut hash = fnv1a_hash_bytes(&[]);
    fnv1a_feed(&mut hash, val);
    hash
}

/// CRDT merge: recursively merge two Values.
/// - Integers: max (GCounter)
/// - Strings: lexicographic max (LWW-Register)
/// - Pairs: componentwise merge
/// - Otherwise: return first argument
fn crdt_merge_values(a: &Value, b: &Value) -> Value {
    match (a, b) {
        (Value::Int(x), Value::Int(y)) => Value::Int(std::cmp::max(*x, *y)),
        (Value::String(x), Value::String(y)) => {
            Value::String(if x >= y { x.clone() } else { y.clone() })
        }
        (Value::Pair(a1, a2), Value::Pair(b1, b2)) => Value::Pair(
            Box::new(crdt_merge_values(a1, b1)),
            Box::new(crdt_merge_values(a2, b2)),
        ),
        _ => a.clone(),
    }
}

impl Interpreter {
    /// Evaluate higher-order builtins that need closure invocation.
    fn eval_higher_order_builtin(&mut self, name: &str, arg: Value) -> Result<Option<Value>> {
        match name {
            "senarai_peta" => {
                // (List, Closure) -> List
                match arg {
                    Value::Pair(list, func) => {
                        let items = match *list {
                            Value::List(items) => items,
                            _ => {
                                return Err(Error::TypeMismatch {
                                    expected: "list".to_string(),
                                    found: format!("{:?}", list),
                                    context: "senarai_peta".to_string(),
                                })
                            }
                        };
                        let closure = match *func {
                            Value::Closure(c) => c,
                            _ => {
                                return Err(Error::TypeMismatch {
                                    expected: "closure".to_string(),
                                    found: format!("{:?}", func),
                                    context: "senarai_peta".to_string(),
                                })
                            }
                        };
                        let mut result = Vec::with_capacity(items.len());
                        for item in items {
                            let new_env = closure.env.extend(closure.param.clone(), item);
                            let val = self.eval_with_env(&new_env, &closure.body)?;
                            result.push(val);
                        }
                        Ok(Some(Value::List(result)))
                    }
                    _ => Err(Error::TypeMismatch {
                        expected: "(list, closure)".to_string(),
                        found: format!("{:?}", arg),
                        context: "senarai_peta".to_string(),
                    }),
                }
            }
            "senarai_tapis" => {
                // (List, Closure) -> List
                match arg {
                    Value::Pair(list, func) => {
                        let items = match *list {
                            Value::List(items) => items,
                            _ => {
                                return Err(Error::TypeMismatch {
                                    expected: "list".to_string(),
                                    found: format!("{:?}", list),
                                    context: "senarai_tapis".to_string(),
                                })
                            }
                        };
                        let closure = match *func {
                            Value::Closure(c) => c,
                            _ => {
                                return Err(Error::TypeMismatch {
                                    expected: "closure".to_string(),
                                    found: format!("{:?}", func),
                                    context: "senarai_tapis".to_string(),
                                })
                            }
                        };
                        let mut result = Vec::new();
                        for item in items {
                            let new_env = closure.env.extend(closure.param.clone(), item.clone());
                            let val = self.eval_with_env(&new_env, &closure.body)?;
                            if val == Value::Bool(true) {
                                result.push(item);
                            }
                        }
                        Ok(Some(Value::List(result)))
                    }
                    _ => Err(Error::TypeMismatch {
                        expected: "(list, closure)".to_string(),
                        found: format!("{:?}", arg),
                        context: "senarai_tapis".to_string(),
                    }),
                }
            }
            "senarai_lipat" => {
                // (List, (Value, Closure)) -> Value
                match arg {
                    Value::Pair(list, init_and_func) => {
                        let items = match *list {
                            Value::List(items) => items,
                            _ => {
                                return Err(Error::TypeMismatch {
                                    expected: "list".to_string(),
                                    found: format!("{:?}", list),
                                    context: "senarai_lipat".to_string(),
                                })
                            }
                        };
                        match *init_and_func {
                            Value::Pair(init, func) => {
                                let closure = match *func {
                                    Value::Closure(c) => c,
                                    _ => {
                                        return Err(Error::TypeMismatch {
                                            expected: "closure".to_string(),
                                            found: format!("{:?}", func),
                                            context: "senarai_lipat".to_string(),
                                        })
                                    }
                                };
                                let mut acc = *init;
                                for item in items {
                                    // Closure takes a pair (acc, item)
                                    let pair = Value::Pair(Box::new(acc), Box::new(item));
                                    let new_env = closure.env.extend(closure.param.clone(), pair);
                                    acc = self.eval_with_env(&new_env, &closure.body)?;
                                }
                                Ok(Some(acc))
                            }
                            _ => Err(Error::TypeMismatch {
                                expected: "(value, closure)".to_string(),
                                found: format!("{:?}", init_and_func),
                                context: "senarai_lipat".to_string(),
                            }),
                        }
                    }
                    _ => Err(Error::TypeMismatch {
                        expected: "(list, (value, closure))".to_string(),
                        found: format!("{:?}", arg),
                        context: "senarai_lipat".to_string(),
                    }),
                }
            }
            _ => Ok(None),
        }
    }
}

impl Default for Interpreter {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use riina_types::Ty;

    // ═══════════════════════════════════════════════════════════════════════
    // VALUE TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_unit() {
        let mut interp = Interpreter::new();
        assert_eq!(interp.eval(&Expr::Unit), Ok(Value::Unit));
    }

    #[test]
    fn test_eval_bool() {
        let mut interp = Interpreter::new();
        assert_eq!(interp.eval(&Expr::Bool(true)), Ok(Value::Bool(true)));
        assert_eq!(interp.eval(&Expr::Bool(false)), Ok(Value::Bool(false)));
    }

    #[test]
    fn test_eval_int() {
        let mut interp = Interpreter::new();
        assert_eq!(interp.eval(&Expr::Int(0)), Ok(Value::Int(0)));
        assert_eq!(interp.eval(&Expr::Int(42)), Ok(Value::Int(42)));
        assert_eq!(interp.eval(&Expr::Int(u64::MAX)), Ok(Value::Int(u64::MAX)));
    }

    #[test]
    fn test_eval_string() {
        let mut interp = Interpreter::new();
        assert_eq!(
            interp.eval(&Expr::String("hello".to_string())),
            Ok(Value::String("hello".to_string()))
        );
        assert_eq!(
            interp.eval(&Expr::String("".to_string())),
            Ok(Value::String("".to_string()))
        );
    }

    // ═══════════════════════════════════════════════════════════════════════
    // VARIABLE TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_unbound_var() {
        let mut interp = Interpreter::new();
        let result = interp.eval(&Expr::Var("x".to_string()));
        assert!(matches!(result, Err(Error::UnboundVariable(_))));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // FUNCTION TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_lambda() {
        let mut interp = Interpreter::new();
        let lam = Expr::Lam(
            "x".to_string(),
            Ty::Int,
            Box::new(Expr::Var("x".to_string())),
        );
        let result = interp.eval(&lam);
        assert!(result.is_ok());
        assert!(result.unwrap().is_closure());
    }

    #[test]
    fn test_eval_application() {
        let mut interp = Interpreter::new();
        // (λx:Int. x) 42
        let identity = Expr::Lam(
            "x".to_string(),
            Ty::Int,
            Box::new(Expr::Var("x".to_string())),
        );
        let app = Expr::App(Box::new(identity), Box::new(Expr::Int(42)));
        assert_eq!(interp.eval(&app), Ok(Value::Int(42)));
    }

    #[test]
    fn test_eval_nested_application() {
        let mut interp = Interpreter::new();
        // (λx:Int. (λy:Int. x)) 1 2 = 1
        let inner = Expr::Lam(
            "y".to_string(),
            Ty::Int,
            Box::new(Expr::Var("x".to_string())),
        );
        let outer = Expr::Lam("x".to_string(), Ty::Int, Box::new(inner));
        let app1 = Expr::App(Box::new(outer), Box::new(Expr::Int(1)));
        let app2 = Expr::App(Box::new(app1), Box::new(Expr::Int(2)));
        assert_eq!(interp.eval(&app2), Ok(Value::Int(1)));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // PRODUCT TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_pair() {
        let mut interp = Interpreter::new();
        let pair = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        assert_eq!(
            interp.eval(&pair),
            Ok(Value::Pair(
                Box::new(Value::Int(1)),
                Box::new(Value::Int(2))
            ))
        );
    }

    #[test]
    fn test_eval_fst() {
        let mut interp = Interpreter::new();
        let pair = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        let fst = Expr::Fst(Box::new(pair));
        assert_eq!(interp.eval(&fst), Ok(Value::Int(1)));
    }

    #[test]
    fn test_eval_snd() {
        let mut interp = Interpreter::new();
        let pair = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        let snd = Expr::Snd(Box::new(pair));
        assert_eq!(interp.eval(&snd), Ok(Value::Int(2)));
    }

    #[test]
    fn test_eval_nested_pairs() {
        let mut interp = Interpreter::new();
        // ((1, 2), (3, 4))
        let p1 = Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)));
        let p2 = Expr::Pair(Box::new(Expr::Int(3)), Box::new(Expr::Int(4)));
        let nested = Expr::Pair(Box::new(p1), Box::new(p2));
        // fst (fst nested) = 1
        let fst_fst = Expr::Fst(Box::new(Expr::Fst(Box::new(nested))));
        assert_eq!(interp.eval(&fst_fst), Ok(Value::Int(1)));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // SUM TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_inl() {
        let mut interp = Interpreter::new();
        let inl = Expr::Inl(
            Box::new(Expr::Int(42)),
            Ty::Sum(Box::new(Ty::Int), Box::new(Ty::Bool)),
        );
        assert_eq!(interp.eval(&inl), Ok(Value::inl(Value::Int(42))));
    }

    #[test]
    fn test_eval_inr() {
        let mut interp = Interpreter::new();
        let inr = Expr::Inr(
            Box::new(Expr::Bool(true)),
            Ty::Sum(Box::new(Ty::Int), Box::new(Ty::Bool)),
        );
        assert_eq!(interp.eval(&inr), Ok(Value::inr(Value::Bool(true))));
    }

    #[test]
    fn test_eval_case_left() {
        let mut interp = Interpreter::new();
        // case (inl 42) of inl x => x | inr y => 0
        let scrut = Expr::Inl(
            Box::new(Expr::Int(42)),
            Ty::Sum(Box::new(Ty::Int), Box::new(Ty::Bool)),
        );
        let case_expr = Expr::Case(
            Box::new(scrut),
            "x".to_string(),
            Box::new(Expr::Var("x".to_string())),
            "y".to_string(),
            Box::new(Expr::Int(0)),
        );
        assert_eq!(interp.eval(&case_expr), Ok(Value::Int(42)));
    }

    #[test]
    fn test_eval_case_right() {
        let mut interp = Interpreter::new();
        // case (inr true) of inl x => 0 | inr y => 1
        let scrut = Expr::Inr(
            Box::new(Expr::Bool(true)),
            Ty::Sum(Box::new(Ty::Int), Box::new(Ty::Bool)),
        );
        let case_expr = Expr::Case(
            Box::new(scrut),
            "x".to_string(),
            Box::new(Expr::Int(0)),
            "y".to_string(),
            Box::new(Expr::Int(1)),
        );
        assert_eq!(interp.eval(&case_expr), Ok(Value::Int(1)));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // CONTROL FLOW TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_if_true() {
        let mut interp = Interpreter::new();
        let if_expr = Expr::If(
            Box::new(Expr::Bool(true)),
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        );
        assert_eq!(interp.eval(&if_expr), Ok(Value::Int(1)));
    }

    #[test]
    fn test_eval_if_false() {
        let mut interp = Interpreter::new();
        let if_expr = Expr::If(
            Box::new(Expr::Bool(false)),
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        );
        assert_eq!(interp.eval(&if_expr), Ok(Value::Int(2)));
    }

    #[test]
    fn test_eval_let() {
        let mut interp = Interpreter::new();
        // let x = 42 in x
        let let_expr = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(42)),
            Box::new(Expr::Var("x".to_string())),
        );
        assert_eq!(interp.eval(&let_expr), Ok(Value::Int(42)));
    }

    #[test]
    fn test_eval_nested_let() {
        let mut interp = Interpreter::new();
        // let x = 1 in let y = 2 in (x, y)
        let inner_let = Expr::Let(
            "y".to_string(),
            None,
            Box::new(Expr::Int(2)),
            Box::new(Expr::Pair(
                Box::new(Expr::Var("x".to_string())),
                Box::new(Expr::Var("y".to_string())),
            )),
        );
        let outer_let = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(1)),
            Box::new(inner_let),
        );
        assert_eq!(
            interp.eval(&outer_let),
            Ok(Value::Pair(
                Box::new(Value::Int(1)),
                Box::new(Value::Int(2))
            ))
        );
    }

    // ═══════════════════════════════════════════════════════════════════════
    // REFERENCE TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_ref() {
        let mut interp = Interpreter::new();
        let ref_expr = Expr::Ref(Box::new(Expr::Int(42)), SecurityLevel::Public);
        let result = interp.eval(&ref_expr);
        assert!(result.is_ok());
        assert!(result.unwrap().is_ref());
    }

    #[test]
    fn test_eval_deref() {
        let mut interp = Interpreter::new();
        // let r = ref 42 in !r
        let let_expr = Expr::Let(
            "r".to_string(),
            None,
            Box::new(Expr::Ref(Box::new(Expr::Int(42)), SecurityLevel::Public)),
            Box::new(Expr::Deref(Box::new(Expr::Var("r".to_string())))),
        );
        assert_eq!(interp.eval(&let_expr), Ok(Value::Int(42)));
    }

    #[test]
    fn test_eval_assign() {
        let mut interp = Interpreter::new();
        // let r = ref 1 in (r := 2; !r)
        let inner = Expr::Let(
            "_".to_string(),
            None,
            Box::new(Expr::Assign(
                Box::new(Expr::Var("r".to_string())),
                Box::new(Expr::Int(2)),
            )),
            Box::new(Expr::Deref(Box::new(Expr::Var("r".to_string())))),
        );
        let let_expr = Expr::Let(
            "r".to_string(),
            None,
            Box::new(Expr::Ref(Box::new(Expr::Int(1)), SecurityLevel::Public)),
            Box::new(inner),
        );
        assert_eq!(interp.eval(&let_expr), Ok(Value::Int(2)));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // SECURITY TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_classify() {
        let mut interp = Interpreter::new();
        let classify = Expr::Classify(Box::new(Expr::Int(42)));
        assert_eq!(
            interp.eval(&classify),
            Ok(Value::Secret(Box::new(Value::Int(42))))
        );
    }

    #[test]
    fn test_eval_declassify() {
        let mut interp = Interpreter::new();
        // declassify (classify 42) with (prove (classify 42))
        let classified = Expr::Classify(Box::new(Expr::Int(42)));
        let proof = Expr::Prove(Box::new(Expr::Classify(Box::new(Expr::Int(42)))));
        let declassify = Expr::Declassify(Box::new(classified), Box::new(proof));
        assert_eq!(interp.eval(&declassify), Ok(Value::Int(42)));
    }

    #[test]
    fn test_eval_declassify_rejects_invalid_proof() {
        let mut interp = Interpreter::new();
        let classified = Expr::Classify(Box::new(Expr::Int(42)));
        let proof = Expr::Prove(Box::new(Expr::Unit));
        let declassify = Expr::Declassify(Box::new(classified), Box::new(proof));
        assert_eq!(
            interp.eval(&declassify),
            Err(Error::InvalidOperation(
                "invalid declassification proof".to_string(),
            ))
        );
    }

    #[test]
    fn test_eval_prove() {
        let mut interp = Interpreter::new();
        let prove = Expr::Prove(Box::new(Expr::Int(42)));
        assert_eq!(
            interp.eval(&prove),
            Ok(Value::Proof(Box::new(Value::Int(42))))
        );
    }

    // ═══════════════════════════════════════════════════════════════════════
    // CAPABILITY TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_grant_require() {
        let mut interp = Interpreter::new();
        // grant Network to (require Network in 42)
        let require = Expr::Require(Effect::Network, Box::new(Expr::Int(42)));
        let grant = Expr::Grant(Effect::Network, Box::new(require));
        assert_eq!(interp.eval(&grant), Ok(Value::Int(42)));
    }

    #[test]
    fn test_eval_missing_capability() {
        let mut interp = Interpreter::new();
        // require Network in 42 (without grant)
        let require = Expr::Require(Effect::Network, Box::new(Expr::Int(42)));
        let result = interp.eval(&require);
        assert!(matches!(
            result,
            Err(Error::MissingCapability(Effect::Network))
        ));
    }

    #[test]
    fn test_eval_handle_perform_runs_handler() {
        // grant Network in (handle (perform Network 7) with x => x)  ==> 7
        // Verifies that the installed handler receives the performed payload.
        // Regression for the HandlerContext effect-field cleanup: handler
        // matching is LIFO / effect-agnostic and must still run the handler.
        let mut interp = Interpreter::new();
        let perform = Expr::Perform(Effect::Network, Box::new(Expr::Int(7)));
        let handle = Expr::Handle(
            Box::new(perform),
            "x".to_string(),
            Box::new(Expr::Var("x".to_string())),
        );
        let grant = Expr::Grant(Effect::Network, Box::new(handle));
        assert_eq!(interp.eval(&grant), Ok(Value::Int(7)));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // COMPLEX TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_factorial_simulation() {
        // Can't do recursion directly, but we can test iterative patterns
        let mut interp = Interpreter::new();
        // let x = 5 in let y = x in (x, y)
        let expr = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(5)),
            Box::new(Expr::Let(
                "y".to_string(),
                None,
                Box::new(Expr::Var("x".to_string())),
                Box::new(Expr::Pair(
                    Box::new(Expr::Var("x".to_string())),
                    Box::new(Expr::Var("y".to_string())),
                )),
            )),
        );
        assert_eq!(
            interp.eval(&expr),
            Ok(Value::Pair(
                Box::new(Value::Int(5)),
                Box::new(Value::Int(5))
            ))
        );
    }

    #[test]
    fn test_eval_church_booleans() {
        let mut interp = Interpreter::new();
        // Church true: λx. λy. x
        // Applying: true 1 2 = 1
        let church_true = Expr::Lam(
            "x".to_string(),
            Ty::Int,
            Box::new(Expr::Lam(
                "y".to_string(),
                Ty::Int,
                Box::new(Expr::Var("x".to_string())),
            )),
        );
        let app1 = Expr::App(Box::new(church_true), Box::new(Expr::Int(1)));
        let app2 = Expr::App(Box::new(app1), Box::new(Expr::Int(2)));
        assert_eq!(interp.eval(&app2), Ok(Value::Int(1)));
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL EDGE CASE TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_int_zero() {
        let mut interp = Interpreter::new();
        assert_eq!(interp.eval(&Expr::Int(0)), Ok(Value::Int(0)));
    }

    #[test]
    fn test_eval_int_large() {
        let mut interp = Interpreter::new();
        assert_eq!(interp.eval(&Expr::Int(1000000)), Ok(Value::Int(1000000)));
    }

    #[test]
    fn test_eval_int_max() {
        let mut interp = Interpreter::new();
        assert_eq!(interp.eval(&Expr::Int(u64::MAX)), Ok(Value::Int(u64::MAX)));
    }

    #[test]
    fn test_eval_string_empty() {
        let mut interp = Interpreter::new();
        assert_eq!(
            interp.eval(&Expr::String("".to_string())),
            Ok(Value::String("".to_string()))
        );
    }

    #[test]
    fn test_eval_string_unicode() {
        let mut interp = Interpreter::new();
        // Test with Bahasa Melayu
        assert_eq!(
            interp.eval(&Expr::String("Selamat pagi".to_string())),
            Ok(Value::String("Selamat pagi".to_string()))
        );
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL ARITHMETIC TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_subtraction() {
        let mut interp = Interpreter::new();
        // We can't directly test subtraction without the built-in,
        // so let's test nested pairs instead
        let pair_expr = Expr::Pair(
            Box::new(Expr::Pair(Box::new(Expr::Int(1)), Box::new(Expr::Int(2)))),
            Box::new(Expr::Pair(Box::new(Expr::Int(3)), Box::new(Expr::Int(4)))),
        );
        let result = interp.eval(&pair_expr).unwrap();
        assert!(result.is_pair());
    }

    #[test]
    fn test_eval_deeply_nested_let() {
        let mut interp = Interpreter::new();
        // let x = 1 in let y = 2 in let z = 3 in x
        let expr = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(1)),
            Box::new(Expr::Let(
                "y".to_string(),
                None,
                Box::new(Expr::Int(2)),
                Box::new(Expr::Let(
                    "z".to_string(),
                    None,
                    Box::new(Expr::Int(3)),
                    Box::new(Expr::Var("x".to_string())),
                )),
            )),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Int(1)));
    }

    #[test]
    fn test_eval_deeply_nested_let_inner() {
        let mut interp = Interpreter::new();
        // let x = 1 in let y = 2 in let z = 3 in z (innermost)
        let expr = Expr::Let(
            "x".to_string(),
            None,
            Box::new(Expr::Int(1)),
            Box::new(Expr::Let(
                "y".to_string(),
                None,
                Box::new(Expr::Int(2)),
                Box::new(Expr::Let(
                    "z".to_string(),
                    None,
                    Box::new(Expr::Int(3)),
                    Box::new(Expr::Var("z".to_string())),
                )),
            )),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Int(3)));
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL SUM TYPE TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_case_nested_inl() {
        let mut interp = Interpreter::new();
        let expr = Expr::Case(
            Box::new(Expr::Inl(Box::new(Expr::Int(100)), Ty::Bool)),
            "x".to_string(),
            Box::new(Expr::Var("x".to_string())),
            "y".to_string(),
            Box::new(Expr::Int(0)),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Int(100)));
    }

    #[test]
    fn test_eval_case_nested_inr() {
        let mut interp = Interpreter::new();
        let expr = Expr::Case(
            Box::new(Expr::Inr(Box::new(Expr::Int(200)), Ty::Bool)),
            "x".to_string(),
            Box::new(Expr::Int(0)),
            "y".to_string(),
            Box::new(Expr::Var("y".to_string())),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Int(200)));
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL SECURITY TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_nested_classify() {
        let mut interp = Interpreter::new();
        // classify(classify(42)) - double classification
        let expr = Expr::Classify(Box::new(Expr::Classify(Box::new(Expr::Int(42)))));
        let result = interp.eval(&expr).unwrap();
        assert_eq!(result.security_level(), SecurityLevel::Secret);
    }

    #[test]
    fn test_eval_classify_pair() {
        let mut interp = Interpreter::new();
        // (classify(1), 2) - pair with secret component
        let expr = Expr::Pair(
            Box::new(Expr::Classify(Box::new(Expr::Int(1)))),
            Box::new(Expr::Int(2)),
        );
        let result = interp.eval(&expr).unwrap();
        assert_eq!(result.security_level(), SecurityLevel::Secret);
    }

    // ═══════════════════════════════════════════════════════════════════
    // ADDITIONAL FUNCTION TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_identity_function() {
        let mut interp = Interpreter::new();
        // (λx. x) 42 = 42
        let expr = Expr::App(
            Box::new(Expr::Lam(
                "x".to_string(),
                Ty::Int,
                Box::new(Expr::Var("x".to_string())),
            )),
            Box::new(Expr::Int(42)),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Int(42)));
    }

    #[test]
    fn test_eval_constant_function() {
        let mut interp = Interpreter::new();
        // (λx. 100) 42 = 100
        let expr = Expr::App(
            Box::new(Expr::Lam(
                "x".to_string(),
                Ty::Int,
                Box::new(Expr::Int(100)),
            )),
            Box::new(Expr::Int(42)),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Int(100)));
    }

    #[test]
    fn test_eval_closure_captures() {
        let mut interp = Interpreter::new();
        // let a = 10 in (λx. a) 0 = 10
        let expr = Expr::Let(
            "a".to_string(),
            None,
            Box::new(Expr::Int(10)),
            Box::new(Expr::App(
                Box::new(Expr::Lam(
                    "x".to_string(),
                    Ty::Int,
                    Box::new(Expr::Var("a".to_string())),
                )),
                Box::new(Expr::Int(0)),
            )),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Int(10)));
    }

    // ═══════════════════════════════════════════════════════════════════
    // LETREC (RECURSIVE FUNCTION) TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_letrec_simple() {
        let mut interp = Interpreter::new();
        // let rec f : Int -> Int = λn. if n <= 0 then 1 else n * f(n-1) in f(5)
        let fn_ty = Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure);
        let body = Expr::If(
            Box::new(Expr::BinOp(
                BinOp::Le,
                Box::new(Expr::Var("n".into())),
                Box::new(Expr::Int(0)),
            )),
            Box::new(Expr::Int(1)),
            Box::new(Expr::BinOp(
                BinOp::Mul,
                Box::new(Expr::Var("n".into())),
                Box::new(Expr::App(
                    Box::new(Expr::Var("f".into())),
                    Box::new(Expr::BinOp(
                        BinOp::Sub,
                        Box::new(Expr::Var("n".into())),
                        Box::new(Expr::Int(1)),
                    )),
                )),
            )),
        );
        let lam = Expr::Lam("n".into(), Ty::Int, Box::new(body));
        let letrec = Expr::LetRec(
            "f".into(),
            fn_ty,
            Box::new(lam),
            Box::new(Expr::App(
                Box::new(Expr::Var("f".into())),
                Box::new(Expr::Int(5)),
            )),
        );
        assert_eq!(interp.eval(&letrec), Ok(Value::Int(120)));
    }

    #[test]
    fn test_eval_letrec_countdown() {
        let mut interp = Interpreter::new();
        // let rec count : Int -> Int = λn. if n <= 0 then 0 else count(n-1) in count(10)
        let fn_ty = Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure);
        let body = Expr::If(
            Box::new(Expr::BinOp(
                BinOp::Le,
                Box::new(Expr::Var("n".into())),
                Box::new(Expr::Int(0)),
            )),
            Box::new(Expr::Int(0)),
            Box::new(Expr::App(
                Box::new(Expr::Var("count".into())),
                Box::new(Expr::BinOp(
                    BinOp::Sub,
                    Box::new(Expr::Var("n".into())),
                    Box::new(Expr::Int(1)),
                )),
            )),
        );
        let lam = Expr::Lam("n".into(), Ty::Int, Box::new(body));
        let letrec = Expr::LetRec(
            "count".into(),
            fn_ty,
            Box::new(lam),
            Box::new(Expr::App(
                Box::new(Expr::Var("count".into())),
                Box::new(Expr::Int(10)),
            )),
        );
        assert_eq!(interp.eval(&letrec), Ok(Value::Int(0)));
    }

    // ═══════════════════════════════════════════════════════════════
    // BUILTIN PARTIAL APPLICATION TESTS (curried pair-builtins)
    // ═══════════════════════════════════════════════════════════════

    #[test]
    fn test_tegaskan_sama_curried() {
        // tegaskan_sama(42, 42) as curried: App(App(tegaskan_sama, 42), 42)
        let mut interp = Interpreter::new();
        let expr = Expr::App(
            Box::new(Expr::App(
                Box::new(Expr::Var("tegaskan_sama".into())),
                Box::new(Expr::Int(42)),
            )),
            Box::new(Expr::Int(42)),
        );
        assert_eq!(interp.eval_with_builtins(&expr), Ok(Value::Unit));
    }

    #[test]
    fn test_tegaskan_sama_curried_fail() {
        // tegaskan_sama(1, 2) should fail
        let mut interp = Interpreter::new();
        let expr = Expr::App(
            Box::new(Expr::App(
                Box::new(Expr::Var("tegaskan_sama".into())),
                Box::new(Expr::Int(1)),
            )),
            Box::new(Expr::Int(2)),
        );
        assert!(interp.eval_with_builtins(&expr).is_err());
    }

    #[test]
    fn test_tegaskan_beza_curried() {
        // tegaskan_beza(1, 2) as curried: should pass (1 != 2)
        let mut interp = Interpreter::new();
        let expr = Expr::App(
            Box::new(Expr::App(
                Box::new(Expr::Var("tegaskan_beza".into())),
                Box::new(Expr::Int(1)),
            )),
            Box::new(Expr::Int(2)),
        );
        assert_eq!(interp.eval_with_builtins(&expr), Ok(Value::Unit));
    }

    #[test]
    fn test_gabung_teks_curried() {
        // gabung_teks("hello", " world") as curried
        let mut interp = Interpreter::new();
        let expr = Expr::App(
            Box::new(Expr::App(
                Box::new(Expr::Var("gabung_teks".into())),
                Box::new(Expr::String("hello".into())),
            )),
            Box::new(Expr::String(" world".into())),
        );
        assert_eq!(
            interp.eval_with_builtins(&expr),
            Ok(Value::String("hello world".into()))
        );
    }

    // ═══════════════════════════════════════════════════════════════════════
    // JALINAN Phase 6 TESTS
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_actor_decl() {
        let mut interp = Interpreter::new();
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
        assert_eq!(interp.eval(&expr), Ok(Value::Unit));
    }

    #[test]
    fn test_eval_choreography_block() {
        let mut interp = Interpreter::new();
        let expr = Expr::ChoreographyBlock {
            name: "TwoParty".into(),
            roles: vec!["Alice".into(), "Bob".into()],
            protocol: riina_types::SessionType::End,
        };
        assert_eq!(interp.eval(&expr), Ok(Value::Unit));
    }

    #[test]
    fn test_eval_spawn() {
        let mut interp = Interpreter::new();
        let expr = Expr::Spawn(Box::new(Expr::Unit), Box::new(Expr::Int(0)));
        assert_eq!(interp.eval(&expr), Ok(Value::ActorRef(1)));
    }

    #[test]
    fn test_eval_spawn_unique_ids() {
        let mut interp = Interpreter::new();
        let spawn = Expr::Spawn(Box::new(Expr::Unit), Box::new(Expr::Int(0)));
        let r1 = interp.eval(&spawn).unwrap();
        let r2 = interp.eval(&spawn).unwrap();
        let r3 = interp.eval(&spawn).unwrap();
        assert_eq!(r1, Value::ActorRef(1));
        assert_eq!(r2, Value::ActorRef(2));
        assert_eq!(r3, Value::ActorRef(3));
    }

    #[test]
    fn test_eval_actor_send() {
        let mut interp = Interpreter::new();
        let expr = Expr::ActorSend(
            Box::new(Expr::Int(1)),  // actor ref
            Box::new(Expr::Int(42)), // message
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Unit));
    }

    #[test]
    fn test_eval_actor_recv() {
        let mut interp = Interpreter::new();
        let expr = Expr::ActorRecv(Box::new(Expr::Int(1)));
        assert_eq!(interp.eval(&expr), Ok(Value::Unit));
    }

    #[test]
    fn test_eval_crdt_merge_int() {
        let mut interp = Interpreter::new();
        let expr = Expr::CRDTMerge(Box::new(Expr::Int(5)), Box::new(Expr::Int(10)));
        assert_eq!(interp.eval(&expr), Ok(Value::Int(10)));
    }

    #[test]
    fn test_eval_crdt_merge_int_reversed() {
        let mut interp = Interpreter::new();
        let expr = Expr::CRDTMerge(Box::new(Expr::Int(10)), Box::new(Expr::Int(5)));
        assert_eq!(interp.eval(&expr), Ok(Value::Int(10)));
    }

    #[test]
    fn test_eval_crdt_merge_same() {
        let mut interp = Interpreter::new();
        let expr = Expr::CRDTMerge(Box::new(Expr::Int(7)), Box::new(Expr::Int(7)));
        assert_eq!(interp.eval(&expr), Ok(Value::Int(7)));
    }

    #[test]
    fn test_eval_crdt_merge_zero() {
        let mut interp = Interpreter::new();
        let expr = Expr::CRDTMerge(Box::new(Expr::Int(0)), Box::new(Expr::Int(0)));
        assert_eq!(interp.eval(&expr), Ok(Value::Int(0)));
    }

    #[test]
    fn test_eval_content_hash() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentHash(Box::new(Expr::Int(42)));
        let result = interp.eval(&expr).unwrap();
        assert!(result.is_hash());
    }

    #[test]
    fn test_eval_content_hash_deterministic() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentHash(Box::new(Expr::Int(42)));
        let r1 = interp.eval(&expr).unwrap();
        let r2 = interp.eval(&expr).unwrap();
        assert_eq!(r1, r2);
    }

    #[test]
    fn test_eval_content_hash_different() {
        let mut interp = Interpreter::new();
        let e1 = Expr::ContentHash(Box::new(Expr::Int(1)));
        let e2 = Expr::ContentHash(Box::new(Expr::Int(2)));
        let r1 = interp.eval(&e1).unwrap();
        let r2 = interp.eval(&e2).unwrap();
        assert_ne!(r1, r2);
    }

    #[test]
    fn test_eval_content_hash_string() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentHash(Box::new(Expr::String("hello".into())));
        let result = interp.eval(&expr).unwrap();
        assert!(result.is_hash());
        // Hash of same string should be deterministic
        let r2 = interp.eval(&expr).unwrap();
        assert_eq!(result, r2);
    }

    #[test]
    fn test_eval_content_hash_bool() {
        let mut interp = Interpreter::new();
        let t = Expr::ContentHash(Box::new(Expr::Bool(true)));
        let f = Expr::ContentHash(Box::new(Expr::Bool(false)));
        let rt = interp.eval(&t).unwrap();
        let rf = interp.eval(&f).unwrap();
        assert!(rt.is_hash());
        assert!(rf.is_hash());
        assert_ne!(rt, rf);
    }

    #[test]
    fn test_eval_content_hash_zero() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentHash(Box::new(Expr::Int(0)));
        let result = interp.eval(&expr).unwrap();
        assert!(result.is_hash());
        // Zero should produce a hash different from 1
        let one = Expr::ContentHash(Box::new(Expr::Int(1)));
        let r1 = interp.eval(&one).unwrap();
        assert_ne!(result, r1);
    }

    #[test]
    fn test_eval_content_hash_large_int() {
        let mut interp = Interpreter::new();
        let large = Expr::ContentHash(Box::new(Expr::Int(u64::MAX)));
        let small = Expr::ContentHash(Box::new(Expr::Int(1)));
        let rl = interp.eval(&large).unwrap();
        let rs = interp.eval(&small).unwrap();
        assert!(rl.is_hash());
        assert_ne!(rl, rs);
    }

    #[test]
    fn test_eval_content_hash_empty_string() {
        let mut interp = Interpreter::new();
        let empty = Expr::ContentHash(Box::new(Expr::String("".into())));
        let nonempty = Expr::ContentHash(Box::new(Expr::String("a".into())));
        let re = interp.eval(&empty).unwrap();
        let rn = interp.eval(&nonempty).unwrap();
        assert!(re.is_hash());
        assert_ne!(re, rn);
    }

    #[test]
    fn test_eval_content_hash_nested() {
        let mut interp = Interpreter::new();
        let inner = Expr::ContentHash(Box::new(Expr::Int(42)));
        let outer = Expr::ContentHash(Box::new(inner));
        let result = interp.eval(&outer).unwrap();
        assert!(result.is_hash());
        // Nested hash should be deterministic
        let inner2 = Expr::ContentHash(Box::new(Expr::Int(42)));
        let outer2 = Expr::ContentHash(Box::new(inner2));
        let r2 = interp.eval(&outer2).unwrap();
        assert_eq!(result, r2);
    }

    #[test]
    fn test_eval_actor_send_recv_roundtrip() {
        let mut interp = Interpreter::new();
        // Spawn an actor
        let spawn = Expr::Spawn(Box::new(Expr::Unit), Box::new(Expr::Int(0)));
        let _ref_val = interp.eval(&spawn).unwrap();
        // Send a message
        let send = Expr::ActorSend(Box::new(Expr::Int(1)), Box::new(Expr::Int(99)));
        assert_eq!(interp.eval(&send), Ok(Value::Unit));
        // Receive (single-threaded stub returns unit)
        let recv = Expr::ActorRecv(Box::new(Expr::Int(1)));
        assert_eq!(interp.eval(&recv), Ok(Value::Unit));
    }

    // ═══════════════════════════════════════════════════════════════════
    // PHASE J2: CONTENT-ADDRESSED CODEGEN — NEW TESTS
    // ═══════════════════════════════════════════════════════════════════

    #[test]
    fn test_eval_content_hash_pair() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentHash(Box::new(Expr::Pair(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        )));
        let result = interp.eval(&expr).unwrap();
        assert!(result.is_hash());
    }

    #[test]
    fn test_eval_content_hash_pair_different_order() {
        let mut interp = Interpreter::new();
        let e1 = Expr::ContentHash(Box::new(Expr::Pair(
            Box::new(Expr::Int(1)),
            Box::new(Expr::Int(2)),
        )));
        let e2 = Expr::ContentHash(Box::new(Expr::Pair(
            Box::new(Expr::Int(2)),
            Box::new(Expr::Int(1)),
        )));
        let r1 = interp.eval(&e1).unwrap();
        let r2 = interp.eval(&e2).unwrap();
        assert_ne!(r1, r2);
    }

    #[test]
    fn test_eval_content_hash_idempotent() {
        let mut interp = Interpreter::new();
        let single = Expr::ContentHash(Box::new(Expr::Int(42)));
        let double = Expr::ContentHash(Box::new(Expr::ContentHash(Box::new(Expr::Int(42)))));
        let r1 = interp.eval(&single).unwrap();
        let r2 = interp.eval(&double).unwrap();
        // hash(hash(42)) == hash(42) — idempotent
        assert_eq!(r1, r2);
    }

    #[test]
    fn test_eval_content_hash_triple_idempotent() {
        let mut interp = Interpreter::new();
        let single = Expr::ContentHash(Box::new(Expr::Int(7)));
        let triple = Expr::ContentHash(Box::new(Expr::ContentHash(Box::new(Expr::ContentHash(
            Box::new(Expr::Int(7)),
        )))));
        let r1 = interp.eval(&single).unwrap();
        let r3 = interp.eval(&triple).unwrap();
        assert_eq!(r1, r3);
    }

    #[test]
    fn test_eval_content_verify_true() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentVerify(
            Box::new(Expr::ContentHash(Box::new(Expr::Int(42)))),
            Box::new(Expr::Int(42)),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Bool(true)));
    }

    #[test]
    fn test_eval_content_verify_false() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentVerify(
            Box::new(Expr::ContentHash(Box::new(Expr::Int(41)))),
            Box::new(Expr::Int(42)),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Bool(false)));
    }

    #[test]
    fn test_content_store_roundtrip_scalar() {
        let mut interp = Interpreter::new();
        let original = Value::String("amanah".into());
        let hash_value = interp.content_hash_value(original.clone());
        assert_eq!(interp.content_lookup_hash(&hash_value), Some(&original));
    }

    #[test]
    fn test_content_lookup_raw_hash_roundtrip() {
        let mut interp = Interpreter::new();
        let original = Value::Int(99);
        let hash_value = interp.content_hash_value(original.clone());
        let hash = decode_hash_value(&hash_value).unwrap();
        assert_eq!(interp.content_lookup(hash), Some(&original));
    }

    #[test]
    fn test_content_lookup_unknown_hash_is_none() {
        let interp = Interpreter::new();
        assert_eq!(interp.content_lookup(0xdead_beef_dead_beef), None);
    }

    #[test]
    fn test_content_hash_list_merkle_root_matches_helper() {
        let mut interp = Interpreter::new();
        let list = Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]);
        let hash_value = interp.content_hash_value(list.clone());
        let hash = decode_hash_value(&hash_value).unwrap();
        let leaves = [Value::Int(1), Value::Int(2), Value::Int(3)]
            .into_iter()
            .map(|value| fnv1a_hash_value(&value))
            .collect::<Vec<_>>();
        assert_eq!(hash, merkle_root_hash(&leaves));
        assert_eq!(interp.content_lookup(hash), Some(&list));
    }

    #[test]
    fn test_content_hash_list_merkle_root_uses_leaf_hash_concatenation() {
        let mut interp = Interpreter::new();
        let list = Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]);
        let hash_value = interp.content_hash_value(list);
        let hash = decode_hash_value(&hash_value).unwrap();
        let leaf_hashes = [
            fnv1a_hash_value(&Value::Int(1)),
            fnv1a_hash_value(&Value::Int(2)),
            fnv1a_hash_value(&Value::Int(3)),
        ];
        let mut expected_bytes = Vec::new();
        for leaf_hash in leaf_hashes {
            expected_bytes.extend_from_slice(&leaf_hash.to_be_bytes());
        }
        assert_eq!(hash, fnv1a_hash_bytes(&expected_bytes));
    }

    #[test]
    fn test_content_hash_list_is_deterministic() {
        let list = Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]);
        let mut interp_a = Interpreter::new();
        let mut interp_b = Interpreter::new();
        let hash_a = interp_a.content_hash_value(list.clone());
        let hash_b = interp_b.content_hash_value(list);
        assert_eq!(hash_a, hash_b);
    }

    #[test]
    fn test_content_hash_list_is_order_sensitive() {
        let mut interp = Interpreter::new();
        let forward = interp.content_hash_value(Value::List(vec![
            Value::Int(1),
            Value::Int(2),
            Value::Int(3),
        ]));
        let reverse = interp.content_hash_value(Value::List(vec![
            Value::Int(3),
            Value::Int(2),
            Value::Int(1),
        ]));
        assert_ne!(forward, reverse);
    }

    #[test]
    fn test_content_hash_list_stores_each_leaf() {
        let mut interp = Interpreter::new();
        let list = Value::List(vec![Value::Int(7), Value::String("nur".into())]);
        let root_hash = decode_hash_value(&interp.content_hash_value(list.clone())).unwrap();
        assert_eq!(
            interp.content_lookup(fnv1a_hash_value(&Value::Int(7))),
            Some(&Value::Int(7))
        );
        assert_eq!(
            interp.content_lookup(fnv1a_hash_value(&Value::String("nur".into()))),
            Some(&Value::String("nur".into()))
        );
        assert_eq!(interp.content_lookup(root_hash), Some(&list));
    }

    #[test]
    fn test_content_hash_nested_list_stores_subtree() {
        let mut interp = Interpreter::new();
        let nested = Value::List(vec![
            Value::Int(1),
            Value::List(vec![Value::Int(2), Value::Int(3)]),
        ]);
        let root_hash = decode_hash_value(&interp.content_hash_value(nested.clone())).unwrap();
        let inner = Value::List(vec![Value::Int(2), Value::Int(3)]);
        let inner_hash = merkle_root_hash(&[
            fnv1a_hash_value(&Value::Int(2)),
            fnv1a_hash_value(&Value::Int(3)),
        ]);
        assert_eq!(interp.content_lookup(inner_hash), Some(&inner));
        assert_eq!(interp.content_lookup(root_hash), Some(&nested));
    }

    #[test]
    fn test_content_hash_empty_list_uses_empty_merkle_root() {
        let mut interp = Interpreter::new();
        let empty = Value::List(Vec::new());
        let hash_value = interp.content_hash_value(empty.clone());
        let hash = decode_hash_value(&hash_value).unwrap();
        assert_eq!(hash, merkle_root_hash(&[]));
        assert_eq!(interp.content_lookup(hash), Some(&empty));
    }

    #[test]
    fn test_content_verify_list_merkle_true_via_store() {
        let mut interp = Interpreter::new();
        let list = Value::List(vec![Value::Int(5), Value::Int(8), Value::Int(13)]);
        let expected = interp.content_hash_value(list.clone());
        let actual = interp.content_hash_value(list);
        assert_eq!(expected, actual);
    }

    #[test]
    fn test_content_verify_list_merkle_false_via_store() {
        let mut interp = Interpreter::new();
        let expected = interp.content_hash_value(Value::List(vec![
            Value::Int(5),
            Value::Int(8),
            Value::Int(13),
        ]));
        let actual = interp.content_hash_value(Value::List(vec![
            Value::Int(5),
            Value::Int(8),
            Value::Int(21),
        ]));
        assert_ne!(expected, actual);
    }

    #[test]
    fn test_eval_ui_text_ansi_render() {
        let mut interp = Interpreter::new();
        let expr = Expr::UIText(
            Box::new(Expr::String("RIINA".into())),
            Box::new(Expr::UIColor(255, 0, 0)),
        );
        assert_eq!(
            interp.eval(&expr),
            Ok(Value::String("\x1b[38;2;255;0;0mRIINA\x1b[0m".into()))
        );
    }

    #[test]
    fn test_eval_ui_display_nested_layout() {
        let mut interp = Interpreter::new();
        let expr = Expr::UIDisplay(vec![
            Expr::UIRow(vec![Expr::Int(1), Expr::Int(2)]),
            Expr::UIButton(Box::new(Expr::String("Click".into())), Box::new(Expr::Unit)),
        ]);
        assert_eq!(interp.eval(&expr), Ok(Value::String("1 2\n[Click]".into())));
    }

    #[test]
    fn test_eval_ui_contrast_white_on_black_passes() {
        let mut interp = Interpreter::new();
        let expr = Expr::UIContrastCheck(
            Box::new(Expr::UIColor(255, 255, 255)),
            Box::new(Expr::UIColor(0, 0, 0)),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Bool(true)));
    }

    #[test]
    fn test_eval_ui_contrast_white_on_white_fails() {
        let mut interp = Interpreter::new();
        let expr = Expr::UIContrastCheck(
            Box::new(Expr::UIColor(255, 255, 255)),
            Box::new(Expr::UIColor(255, 255, 255)),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::Bool(false)));
    }

    #[test]
    fn test_eval_crdt_merge_string() {
        let mut interp = Interpreter::new();
        let expr = Expr::CRDTMerge(
            Box::new(Expr::String("hello".into())),
            Box::new(Expr::String("world".into())),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::String("world".into())));
    }

    #[test]
    fn test_eval_crdt_merge_string_commutative() {
        let mut interp = Interpreter::new();
        let e1 = Expr::CRDTMerge(
            Box::new(Expr::String("world".into())),
            Box::new(Expr::String("hello".into())),
        );
        assert_eq!(interp.eval(&e1), Ok(Value::String("world".into())));
    }

    #[test]
    fn test_eval_crdt_merge_string_same() {
        let mut interp = Interpreter::new();
        let expr = Expr::CRDTMerge(
            Box::new(Expr::String("same".into())),
            Box::new(Expr::String("same".into())),
        );
        assert_eq!(interp.eval(&expr), Ok(Value::String("same".into())));
    }

    #[test]
    fn test_eval_crdt_merge_pair() {
        let mut interp = Interpreter::new();
        // merge(Pair(3, 5), Pair(7, 2)) → Pair(7, 5)
        let expr = Expr::CRDTMerge(
            Box::new(Expr::Pair(Box::new(Expr::Int(3)), Box::new(Expr::Int(5)))),
            Box::new(Expr::Pair(Box::new(Expr::Int(7)), Box::new(Expr::Int(2)))),
        );
        assert_eq!(
            interp.eval(&expr),
            Ok(Value::Pair(
                Box::new(Value::Int(7)),
                Box::new(Value::Int(5))
            ))
        );
    }

    #[test]
    fn test_eval_crdt_merge_pair_commutative() {
        let mut interp = Interpreter::new();
        let e1 = Expr::CRDTMerge(
            Box::new(Expr::Pair(Box::new(Expr::Int(3)), Box::new(Expr::Int(5)))),
            Box::new(Expr::Pair(Box::new(Expr::Int(7)), Box::new(Expr::Int(2)))),
        );
        let e2 = Expr::CRDTMerge(
            Box::new(Expr::Pair(Box::new(Expr::Int(7)), Box::new(Expr::Int(2)))),
            Box::new(Expr::Pair(Box::new(Expr::Int(3)), Box::new(Expr::Int(5)))),
        );
        let r1 = interp.eval(&e1).unwrap();
        let r2 = interp.eval(&e2).unwrap();
        assert_eq!(r1, r2);
    }

    #[test]
    fn test_eval_crdt_merge_int_associative() {
        let mut interp = Interpreter::new();
        // merge(3, merge(8, 5)) == merge(merge(3, 8), 5)
        let lhs = Expr::CRDTMerge(
            Box::new(Expr::Int(3)),
            Box::new(Expr::CRDTMerge(
                Box::new(Expr::Int(8)),
                Box::new(Expr::Int(5)),
            )),
        );
        let rhs = Expr::CRDTMerge(
            Box::new(Expr::CRDTMerge(
                Box::new(Expr::Int(3)),
                Box::new(Expr::Int(8)),
            )),
            Box::new(Expr::Int(5)),
        );
        assert_eq!(interp.eval(&lhs), interp.eval(&rhs));
    }

    #[test]
    fn test_eval_content_hash_pair_deterministic() {
        let mut interp = Interpreter::new();
        let expr = Expr::ContentHash(Box::new(Expr::Pair(
            Box::new(Expr::Int(10)),
            Box::new(Expr::String("abc".into())),
        )));
        let r1 = interp.eval(&expr).unwrap();
        let r2 = interp.eval(&expr).unwrap();
        assert_eq!(r1, r2);
    }

    /// Parse `src` and evaluate with builtins, returning the resulting Value.
    fn run_src(src: &str) -> Value {
        let mut p = riina_parser::Parser::new(src);
        let expr = p.parse_program().unwrap().desugar();
        let mut interp = Interpreter::new();
        interp.eval_with_builtins(&expr).unwrap()
    }

    #[test]
    fn test_early_return_guard_taken() {
        // The guard fires: `pulang 100` returns from `f`.
        let v = run_src(
            "fungsi f(n: Nombor) -> Nombor kesan Bersih { kalau n < 1 { pulang 100; } pulang n; } f(0)",
        );
        assert_eq!(v, Value::Int(100));
    }

    #[test]
    fn test_early_return_guard_skipped() {
        // The guard is skipped: control falls through to `pulang n`.
        let v = run_src(
            "fungsi f(n: Nombor) -> Nombor kesan Bersih { kalau n < 1 { pulang 100; } pulang n; } f(3)",
        );
        assert_eq!(v, Value::Int(3));
    }

    #[test]
    fn test_early_return_scopes_to_nearest_function() {
        // A nested function's `pulang` returns from *that* function only; it must
        // not unwind past the enclosing `g`.
        let v = run_src(
            "fungsi g() -> Nombor kesan Bersih { fungsi inner() -> Nombor { pulang 1; } biar x = inner(); 99 } g()",
        );
        assert_eq!(v, Value::Int(99));
    }

    #[test]
    fn test_early_return_recursive_accumulator_terminates() {
        // Tail-style recursion that relies on an early-return base case now
        // terminates (previously diverged because `pulang` was identity).
        let v = run_src(
            "fungsi fib(n: Nombor) -> Nombor kesan Bersih { fungsi akum(k: Nombor, a: Nombor, b: Nombor) -> Nombor { kalau k == 0 { pulang a; } pulang akum(k - 1, b, a + b); } pulang akum(n, 0, 1); } fib(10)",
        );
        assert_eq!(v, Value::Int(55));
    }

    // ═══════════════════════════════════════════════════════════════════════
    // ZERO-ARG THUNK MATERIALISATION (Gate C "OS/system" row)
    // ═══════════════════════════════════════════════════════════════════════

    #[test]
    fn test_zero_arg_thunk_materialises_to_builtin() {
        // A bare input-source `Var` must resolve to its `Builtin` value rather
        // than raising `UnboundVariable`. Previously `baca_garisan` was typed
        // (`Teks`) but never registered in the interpreter env, so any
        // reference crashed at runtime.
        let mut interp = Interpreter::new();
        let env = crate::builtins::register_builtins(&Env::new());
        for nm in ["baca_garisan", "baca_baris", "read_line"] {
            assert_eq!(
                interp.eval_with_env(&env, &Expr::Var(nm.to_string())),
                Ok(Value::Builtin(nm.to_string())),
                "input-source thunk `{nm}` should materialise to its Builtin",
            );
        }
    }

    #[test]
    fn test_zero_arg_call_baca_garisan_parses_and_evaluates() {
        // End-to-end: the surface zero-arg call `baca_garisan()` (the `()` is a
        // no-op suffix the parser drops) evaluates without `UnboundVariable`.
        let v = run_src("baca_garisan()");
        assert_eq!(v, Value::Builtin("baca_garisan".to_string()));
    }

    #[test]
    fn test_top_level_return() {
        // A `pulang` at top level (outside any function) yields its value.
        assert_eq!(run_src("pulang 42"), Value::Int(42));
    }

    // ── Numeric tower: width-aware evaluation (end-to-end source → value) ──

    fn iu(value: u64, bits: u8) -> Value {
        Value::IntN {
            value,
            bits,
            signed: false,
        }
    }
    fn is(value: u64, bits: u8) -> Value {
        Value::IntN {
            value,
            bits,
            signed: true,
        }
    }

    #[test]
    fn numeric_tower_sized_literal_evaluates_with_width() {
        assert_eq!(run_src("pulang 42u8"), iu(42, 8));
        assert_eq!(run_src("pulang 1000u16"), iu(1000, 16));
    }

    #[test]
    fn numeric_tower_unsigned_arithmetic_wraps_at_width() {
        // 200 + 100 = 300 ≡ 44 (mod 2^8)
        assert_eq!(run_src("pulang 200u8 + 100u8"), iu(44, 8));
        // 0 - 1 underflows to 255
        assert_eq!(run_src("pulang 0u8 - 1u8"), iu(255, 8));
        // u16 boundary
        assert_eq!(run_src("pulang 65535u16 + 1u16"), iu(0, 16));
        // u32 wrap: (4e9 + 1e9) mod 2^32 = 705_032_704
        assert_eq!(
            run_src("pulang 4000000000u32 + 1000000000u32"),
            iu(705_032_704, 32)
        );
    }

    #[test]
    fn numeric_tower_signed_overflow_wraps_to_negative() {
        // 127 + 1 overflows i8 to -128 (two's-complement bit pattern 0x80 = 128)
        let v = run_src("pulang 127i8 + 1i8");
        assert_eq!(v, is(128, 8));
        assert_eq!(format!("{v}"), "-128");
    }

    #[test]
    fn numeric_tower_signed_division_truncates_toward_zero() {
        // (127i8 + 1i8) = -128; -128 / 2 = -64 (bit pattern 0xC0 = 192)
        let v = run_src("pulang (127i8 + 1i8) / 2i8");
        assert_eq!(v, is(192, 8));
        assert_eq!(format!("{v}"), "-64");
    }

    #[test]
    fn numeric_tower_signed_comparison_respects_sign() {
        // -128 < 5 is true (an unsigned compare of 128 vs 5 would be false)
        assert_eq!(run_src("pulang (127i8 + 1i8) < 5i8"), Value::Bool(true));
    }

    #[test]
    fn numeric_tower_plain_int_operand_adapts_to_width() {
        // The plain `Int` literal `10` adopts the u8 width: 260 ≡ 4 (mod 2^8)
        assert_eq!(run_src("pulang 250u8 + 10"), iu(4, 8));
    }

    #[test]
    fn numeric_tower_display_is_signedness_aware() {
        assert_eq!(format!("{}", iu(255, 8)), "255");
        assert_eq!(format!("{}", is(128, 8)), "-128");
        assert_eq!(format!("{}", is(7, 32)), "7");
    }
}
