// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Typechecker
//!
//! Implements the typing rules defined in `foundations/Typing.v`.
//! RIINA = Rigorous Immutable Invariant, No Assumptions
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS

use riina_types::{
    BinOp, Effect, EffectSet, Expr, Ident, Linearity, Location, SecurityLevel, SessionType,
    StoreTy, Ty, Usage,
};
use std::collections::HashSet;
use std::cell::{Cell, RefCell};
use std::rc::Rc;

pub mod multiparty;
pub mod program;
pub use riina_types::persistent::{PMap, PSet};
pub use program::check_program;

#[derive(Debug, Clone, PartialEq)]
pub enum TypeError {
    VarNotFound(Ident),
    TypeMismatch {
        expected: Ty,
        found: Ty,
    },
    ExpectedFunction(Ty),
    ExpectedProduct(Ty),
    ExpectedSum(Ty),
    ExpectedRef(Ty),
    ExpectedSecret(Ty),
    ExpectedProof(Ty),
    /// A computation performs `found`, which the declared (or permitted) set
    /// `allowed` does not cover under the category-respecting partial order
    /// [`EffectSet::covers`]. `found` is the lowest-level offending effect.
    EffectViolation {
        allowed: EffectSet,
        found: Effect,
    },
    AnnotationMismatch {
        expected: Ty,
        found: Ty,
    },
    /// Security level violation: found level does not flow to expected level
    /// Matches Coq's `sl ⊑ Δ` check in T_Deref and T_Assign
    SecurityViolation {
        found: SecurityLevel,
        expected: SecurityLevel,
        context: &'static str,
    },
    /// Invalid declassification: proof does not match secret
    /// Matches Coq's `declass_ok e1 e2` predicate
    InvalidDeclassification {
        message: String,
    },
    /// Capability violation: an effect gate is required without a matching grant
    CapabilityViolation {
        required: Effect,
        message: String,
    },
    /// Location not found in store typing
    LocationNotFound(Location),
    /// Implicit information flow violation: branching on secret data
    /// and writing to a lower-security reference inside the branch.
    /// Matches Denning-style implicit flow prevention.
    ImplicitFlowViolation {
        branch_level: SecurityLevel,
        target_level: SecurityLevel,
        context: &'static str,
    },
    /// Tainted data flowing to sensitive sink without sanitization
    /// Matches Coq SQLInjectionPrevention.v:92 (taint_safe predicate)
    TaintViolation {
        taint_source: riina_types::TaintSource,
        required_sanitizer: riina_types::Sanitizer,
        context: &'static str,
    },
    /// Wrong sanitizer used for sensitive sink
    /// Matches Coq XSSPrevention.v:74 (context-specific encoding)
    SanitizerMismatch {
        expected: riina_types::Sanitizer,
        found: riina_types::Sanitizer,
        context: &'static str,
    },
    /// Constant-time violation: ConstantTime<T> value used in a context
    /// that would create a timing side-channel (branch condition, array index).
    /// This enforces the constant-time discipline: code processing
    /// ConstantTime values must not branch on them or use them as indices.
    ConstantTimeViolation {
        context: &'static str,
    },
    /// Linearity violation: variable used incorrectly given its linearity qualifier.
    /// Matches Coq LinearTypes.v linearity_check.
    LinearityViolation {
        var: Ident,
        linearity: Linearity,
        usage: Usage,
        message: String,
    },
    /// Expected an actor type but found something else
    ExpectedActor(Ty),
    /// Expected a CRDT type but found something else
    ExpectedCRDT(Ty),
    /// CRDT merge type mismatch: left and right operands have different CRDT types
    CRDTMismatch {
        left: Ty,
        right: Ty,
    },
    /// Choreography validation error
    ChoreographyError {
        message: String,
    },
    /// Crypto-agility (REQ-48): a program selects an algorithm the active policy
    /// marks Deprecated (e.g. a classical primitive past its NIST IR 8547 date).
    /// Mirrors the Coq `accepts` judgment in crypto/AlgorithmPolicy.v — an
    /// accepted program uses no deprecated algorithm.
    DeprecatedAlgorithm {
        algorithm: String,
        message: String,
    },
}

impl std::fmt::Display for TypeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            TypeError::VarNotFound(id) => write!(f, "Variable not found: {}", id),
            TypeError::TypeMismatch { expected, found } => {
                write!(
                    f,
                    "Type mismatch: expected {:?}, found {:?}",
                    expected, found
                )
            }
            TypeError::ExpectedFunction(ty) => write!(f, "Expected function type, found {:?}", ty),
            TypeError::ExpectedProduct(ty) => write!(f, "Expected product type, found {:?}", ty),
            TypeError::ExpectedSum(ty) => write!(f, "Expected sum type, found {:?}", ty),
            TypeError::ExpectedRef(ty) => write!(f, "Expected reference type, found {:?}", ty),
            TypeError::ExpectedSecret(ty) => write!(f, "Expected secret type, found {:?}", ty),
            TypeError::ExpectedProof(ty) => write!(f, "Expected proof type, found {:?}", ty),
            TypeError::EffectViolation { allowed, found } => {
                write!(
                    f,
                    "Effect violation: allowed {:?}, found {:?}",
                    allowed, found
                )
            }
            TypeError::AnnotationMismatch { expected, found } => {
                write!(
                    f,
                    "Annotation mismatch: expected {:?}, found {:?}",
                    expected, found
                )
            }
            TypeError::SecurityViolation {
                found,
                expected,
                context,
            } => {
                write!(
                    f,
                    "Security violation in {}: level {:?} does not flow to {:?}",
                    context, found, expected
                )
            }
            TypeError::InvalidDeclassification { message } => {
                write!(f, "Invalid declassification: {}", message)
            }
            TypeError::CapabilityViolation { required, message } => {
                write!(f, "Capability violation for {:?}: {}", required, message)
            }
            TypeError::LocationNotFound(loc) => {
                write!(f, "Location not found in store: {}", loc)
            }
            TypeError::ImplicitFlowViolation {
                branch_level,
                target_level,
                context,
            } => {
                write!(
                    f,
                    "Implicit flow violation in {}: branching on {:?} data cannot write to {:?} reference",
                    context, branch_level, target_level
                )
            }
            TypeError::TaintViolation {
                taint_source,
                required_sanitizer,
                context,
            } => {
                write!(
                    f,
                    "Taint violation in {}: {:?} data requires {:?} sanitization before use",
                    context, taint_source, required_sanitizer
                )
            }
            TypeError::SanitizerMismatch {
                expected,
                found,
                context,
            } => {
                write!(
                    f,
                    "Sanitizer mismatch in {}: expected {:?}, found {:?}",
                    context, expected, found
                )
            }
            TypeError::ConstantTimeViolation { context } => {
                write!(
                    f,
                    "Constant-time violation: ConstantTime value used in {} (creates timing side-channel)",
                    context
                )
            }
            TypeError::LinearityViolation {
                var,
                linearity,
                usage,
                message,
            } => {
                write!(
                    f,
                    "Linearity violation for '{}': {:?} variable has {:?} usage — {}",
                    var, linearity, usage, message
                )
            }
            TypeError::ExpectedActor(ty) => write!(f, "Expected actor type, found {:?}", ty),
            TypeError::ExpectedCRDT(ty) => write!(f, "Expected CRDT type, found {:?}", ty),
            TypeError::CRDTMismatch { left, right } => {
                write!(
                    f,
                    "CRDT merge type mismatch: left {:?}, right {:?}",
                    left, right
                )
            }
            TypeError::ChoreographyError { message } => {
                write!(f, "Choreography error: {}", message)
            }
            TypeError::DeprecatedAlgorithm { algorithm, message } => {
                write!(f, "Deprecated crypto algorithm '{}': {}", algorithm, message)
            }
        }
    }
}

impl std::error::Error for TypeError {}

impl TypeError {
    /// Return a human-readable fix hint for this error.
    /// Used by `riinac check --json` to help AI agents fix code.
    #[must_use]
    pub fn fix_hint(&self) -> Option<String> {
        Some(match self {
            TypeError::TypeMismatch { expected, found } => {
                format!(
                    "Convert with ke_nombor()/ke_teks()/ke_bool(), or change the annotation from {:?} to {:?}",
                    expected, found
                )
            }
            TypeError::VarNotFound(name) => {
                format!("Did you mean a different variable? Check spelling of '{name}'")
            }
            TypeError::EffectViolation { allowed, found } => {
                format!(
                    "Declare {found:?} in the function signature (effects of different \
                     categories do not cover each other: list them all, e.g. \
                     'kesan ({allowed:?}, {found:?})'), or remove the {found:?} operation"
                )
            }
            TypeError::SecurityViolation {
                found,
                expected,
                context,
            } => {
                format!(
                    "In {context}: level {:?} does not flow to {:?}. Use 'dedah' with a proof to declassify, or raise the context security level",
                    found, expected
                )
            }
            TypeError::ExpectedFunction(ty) => {
                format!(
                    "'{:?}' is not a function. Check that you are calling a function, not a value",
                    ty
                )
            }
            TypeError::ExpectedSecret(_) => {
                "Wrap the value with sulit(value) or Rahsia(value) to make it secret".to_string()
            }
            TypeError::InvalidDeclassification { .. } => {
                "Provide a valid Bukti proof term: dedah(sulit(value), bukti(sulit(value)))"
                    .to_string()
            }
            TypeError::CapabilityViolation { required, .. } => {
                format!(
                    "Inside a function, declare {required:?} in its 'kesan' (a function body can \
                     only narrow the capabilities it holds, never 'beri' itself new ones); at top \
                     level add a prior or enclosing 'beri {required:?} ...' before the guarded \
                     operation. Or remove the matching 'perlu {required:?}'"
                )
            }
            TypeError::AnnotationMismatch { expected, found } => {
                format!(
                    "Function body evaluates to {:?} but is declared as {:?}. Change the return type annotation or fix the body",
                    found, expected
                )
            }
            TypeError::ExpectedRef(_) => {
                "Use 'ruj' to create a reference first: biar r = ruj value @Awam;".to_string()
            }
            TypeError::LocationNotFound(_) => {
                "Location not in store typing — ensure the reference was allocated with 'ruj'"
                    .to_string()
            }
            TypeError::ExpectedProduct(_) => {
                "Expected a pair/tuple (T1, T2). Use fst/snd only on pairs".to_string()
            }
            TypeError::ExpectedSum(_) => {
                "Expected a sum type. Use inl/inr constructors".to_string()
            }
            TypeError::ExpectedProof(_) => {
                "Expected a Bukti<T> proof type. Use bukti(expr) to create one".to_string()
            }
            TypeError::ImplicitFlowViolation {
                branch_level,
                target_level,
                ..
            } => {
                format!(
                    "Cannot write to {:?}-level reference inside a branch guarded by {:?}-level data. \
                     Use a {:?}-level reference or declassify the condition first",
                    target_level, branch_level, branch_level
                )
            }
            TypeError::TaintViolation {
                taint_source,
                required_sanitizer,
                ..
            } => {
                format!(
                    "Sanitize the {:?} input with {:?} first. Example: biar bersih = sanitize_sql(input);",
                    taint_source, required_sanitizer
                )
            }
            TypeError::SanitizerMismatch { expected, .. } => {
                format!("Use the correct sanitizer for this context: {:?}", expected)
            }
            TypeError::ConstantTimeViolation { context } => {
                format!(
                    "Do not use ConstantTime values in {context}. \
                     Use constant-time comparison functions instead of branching on secret data"
                )
            }
            TypeError::LinearityViolation { linearity, .. } => {
                match linearity {
                    Linearity::Linear => "Linear variables must be used exactly once. Remove duplicate uses or change linearity to Affine/Unrestricted".to_string(),
                    Linearity::Affine => "Affine variables can be used at most once. Remove duplicate uses or change linearity to Unrestricted".to_string(),
                    Linearity::Relevant => "Relevant variables must be used at least once. Add a use or change linearity to Unrestricted".to_string(),
                    Linearity::Unrestricted => "Unrestricted variables have no usage constraints — this error should not occur".to_string(),
                }
            }
            TypeError::ExpectedActor(_) => {
                "Expected an Actor type. Use 'aktor' to declare an actor first".to_string()
            }
            TypeError::ExpectedCRDT(_) => {
                "Expected a CRDT type. Use CRDT(T, Op) type annotation".to_string()
            }
            TypeError::CRDTMismatch { .. } => {
                "Both operands of CRDT merge must have the same CRDT type".to_string()
            }
            TypeError::ChoreographyError { .. } => {
                "Choreography blocks require at least 2 roles and a well-formed protocol".to_string()
            }
            TypeError::DeprecatedAlgorithm { .. } => {
                "This algorithm is deprecated by policy; migrate to a current algorithm \
                 (see docs/MEMORY_SAFETY_ROADMAP.md and the crypto agility policy)".to_string()
            }
        })
    }

    /// Return an error code for this error type.
    #[must_use]
    pub fn error_code(&self) -> &'static str {
        match self {
            TypeError::VarNotFound(_) => "T0001",
            TypeError::TypeMismatch { .. } => "T0002",
            TypeError::ExpectedFunction(_) => "T0003",
            TypeError::ExpectedProduct(_) => "T0004",
            TypeError::ExpectedSum(_) => "T0005",
            TypeError::ExpectedRef(_) => "T0006",
            TypeError::ExpectedSecret(_) => "T0007",
            TypeError::ExpectedProof(_) => "T0008",
            TypeError::EffectViolation { .. } => "E0001",
            TypeError::AnnotationMismatch { .. } => "T0009",
            TypeError::SecurityViolation { .. } => "S0001",
            TypeError::InvalidDeclassification { .. } => "S0002",
            TypeError::ImplicitFlowViolation { .. } => "S0003",
            TypeError::CapabilityViolation { .. } => "CAP0001",
            TypeError::LocationNotFound(_) => "T0010",
            TypeError::TaintViolation { .. } => "TAINT001",
            TypeError::SanitizerMismatch { .. } => "TAINT002",
            TypeError::ConstantTimeViolation { .. } => "CT0001",
            TypeError::LinearityViolation { .. } => "LIN0001",
            TypeError::ExpectedActor(_) => "J0001",
            TypeError::ExpectedCRDT(_) => "J0002",
            TypeError::CRDTMismatch { .. } => "J0003",
            TypeError::ChoreographyError { .. } => "J0004",
            TypeError::DeprecatedAlgorithm { .. } => "K0001",
        }
    }

    /// Return a reference to the Coq typing rule related to this error.
    #[must_use]
    pub fn coq_rule(&self) -> Option<&'static str> {
        match self {
            TypeError::TypeMismatch { .. } => Some("T_App (Typing.v:142)"),
            TypeError::ExpectedFunction(_) => {
                Some("T_App (Typing.v:142) — e1 must have function type")
            }
            TypeError::EffectViolation { .. } => {
                Some("effect_sub (EffectSystem.v:89) — effect hierarchy")
            }
            TypeError::SecurityViolation { context, .. } => match *context {
                "dereference" => Some("T_Deref (Typing.v:178) — sl must flow to delta"),
                "assignment" => Some("T_Assign (Typing.v:183) — sl must flow to delta"),
                _ => Some("Information flow lattice (Syntax.v:48)"),
            },
            TypeError::InvalidDeclassification { .. } => {
                Some("T_Declassify (Typing.v:196) — declass_ok predicate")
            }
            TypeError::ImplicitFlowViolation { .. } => {
                Some("Denning implicit flow — Δ elevated in branch (NonInterference.v)")
            }
            TypeError::CapabilityViolation { .. } => Some("T_Require/T_Grant (Typing.v:207-213)"),
            TypeError::ExpectedRef(_) => Some("T_Deref (Typing.v:178) — operand must be TRef"),
            TypeError::ExpectedSecret(_) => {
                Some("T_Classify (Typing.v:192) — operand must be TSecret")
            }
            TypeError::TaintViolation { .. } => {
                Some("SQLInjectionPrevention.v:92 — taint_safe predicate")
            }
            TypeError::SanitizerMismatch { .. } => {
                Some("XSSPrevention.v:74 — context-specific encoding required")
            }
            TypeError::ConstantTimeViolation { .. } => {
                Some("ConstantTimeSecurity.v:56 — ct_safe predicate forbids branching on CT values")
            }
            TypeError::LinearityViolation { .. } => {
                Some("LinearTypes.v:172 — linearity_check enforces usage constraints")
            }
            _ => None,
        }
    }
}

/// A tracked (non-unrestricted) binding's usage counter.
///
/// The counter is SHARED (`Rc<Cell<_>>`) by every clone of the environment
/// that still has the binding in scope. Coq `linear_typed` threads its context
/// through every subterm (`T_Let`, `T_App`, `T_Pair` take the OUTPUT context of
/// the first premise as the INPUT of the next), so a use inside a nested `biar`
/// body, a lambda, a branch or a loop body is a use of the outer binding. The
/// checker clones its context for every sub-scope; a per-clone counter silently
/// discarded those uses (M2: `t_lin5.rii` used a `sekali` value three times).
#[derive(Clone, Debug)]
struct LinearEntry {
    lin: Linearity,
    usage: Rc<Cell<Usage>>,
    /// A closure that captured a linear/affine variable: it may only be
    /// applied directly, never copied or passed on (a copy could be called
    /// again, consuming the captured variable twice).
    call_only: bool,
}

/// A point-in-time view of one tracked binding, used to compare usages before
/// and after a branch, a loop body or a lambda body.
#[derive(Clone, Debug)]
pub(crate) struct LinearSnap {
    name: Ident,
    lin: Linearity,
    cell: Rc<Cell<Usage>>,
    before: Usage,
}

impl LinearSnap {
    fn now(&self) -> Usage {
        self.cell.get()
    }
    fn changed(&self) -> bool {
        self.cell.get() != self.before
    }
    fn restore(&self) {
        self.cell.set(self.before);
    }
}

fn usage_rank(u: Usage) -> u8 {
    match u {
        Usage::Zero => 0,
        Usage::One => 1,
        Usage::Many => 2,
    }
}

/// Type environment (Γ in Coq has_type judgment)
///
/// Maps variable names to their types, with optional linearity qualifiers.
/// Matches Coq `type_env := list (ident * ty)` (basic) and
/// `LEntry := (nat * LTy * Linearity * Usage)` (linear extension).
///
/// Both maps are PERSISTENT ([`PMap`]): `extend` shares structure with the
/// environment it extends instead of copying it, so cloning an environment is
/// O(1) and a scope nest of depth n costs O(n log n) memory, not O(n²) (5,000
/// sequential `biar` used 2.7 GB). Lookups see exactly what the old copied
/// `HashMap` did: the newest binding of a name shadows older ones.
#[derive(Clone)]
pub struct TypeEnv {
    vars: PMap<Ident, Ty>,
    /// Linearity tracking: (linearity qualifier, shared usage counter).
    /// Only populated for variables with non-Unrestricted linearity.
    linearity: PMap<Ident, LinearEntry>,
}

impl Default for TypeEnv {
    fn default() -> Self {
        Self::new()
    }
}

impl TypeEnv {
    pub fn new() -> Self {
        Self {
            vars: PMap::new(),
            linearity: PMap::new(),
        }
    }

    /// Iterate the bindings (name → type). Used by tooling that needs to walk
    /// the registered builtins, e.g. the stdlib API-doc generator.
    pub fn iter(&self) -> impl Iterator<Item = (&Ident, &Ty)> {
        self.vars.iter()
    }

    /// Extend with an unrestricted (default) binding.
    ///
    /// The new binding SHADOWS any tracked binding of the same name, so its
    /// linearity entry is dropped from this scope (the outer binding's counter
    /// stays with the outer scope).
    pub fn extend(&self, name: Ident, ty: Ty) -> Self {
        let mut new_vars = self.vars.clone();
        let mut new_lin = self.linearity.clone();
        new_lin.remove(&name);
        new_vars.insert(name, ty);
        Self {
            vars: new_vars,
            linearity: new_lin,
        }
    }

    /// Extend with an explicit linearity qualifier.
    /// Linear/Affine/Relevant bindings start at Usage::Zero.
    pub fn extend_linear(&self, name: Ident, ty: Ty, lin: Linearity) -> Self {
        self.extend_tracked(name, ty, lin, false)
    }

    fn extend_tracked(&self, name: Ident, ty: Ty, lin: Linearity, call_only: bool) -> Self {
        let mut new_vars = self.vars.clone();
        new_vars.insert(name.clone(), ty);
        let mut new_lin = self.linearity.clone();
        if lin == Linearity::Unrestricted {
            new_lin.remove(&name);
        } else {
            new_lin.insert(
                name,
                LinearEntry {
                    lin,
                    usage: Rc::new(Cell::new(Usage::Zero)),
                    call_only,
                },
            );
        }
        Self {
            vars: new_vars,
            linearity: new_lin,
        }
    }

    pub fn lookup(&self, name: &Ident) -> Option<&Ty> {
        self.vars.get(name)
    }

    /// Record a use of a variable. Returns error if the variable has been
    /// consumed beyond its linearity allows.
    pub fn record_use(&mut self, name: &Ident) -> Result<(), TypeError> {
        if let Some(entry) = self.linearity.get(name) {
            let lin = entry.lin;
            let new_usage = entry.usage.get().increment();
            // Linear: exactly once → reject second use
            if lin == Linearity::Linear && new_usage == Usage::Many {
                return Err(TypeError::LinearityViolation {
                    var: name.clone(),
                    linearity: lin,
                    usage: new_usage,
                    message: "linear variable used more than once".to_string(),
                });
            }
            // Affine: at most once → reject second use
            if lin == Linearity::Affine && new_usage == Usage::Many {
                return Err(TypeError::LinearityViolation {
                    var: name.clone(),
                    linearity: lin,
                    usage: new_usage,
                    message: "affine variable used more than once".to_string(),
                });
            }
            entry.usage.set(new_usage);
        }
        Ok(())
    }

    /// Check linearity constraints at scope exit.
    /// Call this after type-checking the body where the binding was in scope.
    pub fn check_linearity_at_exit(&self, name: &Ident) -> Result<(), TypeError> {
        if let Some(entry) = self.linearity.get(name) {
            let (lin, usage) = (entry.lin, entry.usage.get());
            match lin {
                Linearity::Linear if usage != Usage::One => {
                    return Err(TypeError::LinearityViolation {
                        var: name.clone(),
                        linearity: lin,
                        usage,
                        message: format!(
                            "linear variable must be used exactly once, but was used {:?}",
                            usage
                        ),
                    });
                }
                Linearity::Relevant if usage == Usage::Zero => {
                    return Err(TypeError::LinearityViolation {
                        var: name.clone(),
                        linearity: lin,
                        usage,
                        message: "relevant variable must be used at least once".to_string(),
                    });
                }
                _ => {} // Affine: Zero or One is fine; Unrestricted: anything is fine
            }
        }
        Ok(())
    }

    /// Get linearity info for a variable, if tracked.
    pub fn get_linearity(&self, name: &Ident) -> Option<(Linearity, Usage)> {
        self.linearity.get(name).map(|e| (e.lin, e.usage.get()))
    }

    /// Whether `name` is a closure that captured a linear/affine variable and
    /// so may only be applied directly.
    fn is_call_only(&self, name: &Ident) -> bool {
        self.linearity.get(name).is_some_and(|e| e.call_only)
    }

    /// Every tracked binding in scope with its current usage.
    pub(crate) fn linear_snapshot(&self) -> Vec<LinearSnap> {
        self.linearity
            .iter()
            .map(|(name, e)| LinearSnap {
                name: name.clone(),
                lin: e.lin,
                cell: e.usage.clone(),
                before: e.usage.get(),
            })
            .collect()
    }
}

fn linearity_error(snap: &LinearSnap, usage: Usage, message: &str) -> TypeError {
    TypeError::LinearityViolation {
        var: snap.name.clone(),
        linearity: snap.lin,
        usage,
        message: message.to_string(),
    }
}

/// Reconcile the usages of the two arms of a branch (`kalau`/`padan`).
///
/// Only one arm runs, so a linear variable must be consumed by both arms or by
/// neither; an affine one may be consumed by either (its usage is the larger);
/// a relevant one is only guaranteed used if both arms use it (the smaller).
/// `then_usage` is each tracked binding's usage after the first arm; the cells
/// currently hold the usage after the second arm.
fn merge_branch_usage(snaps: &[LinearSnap], then_usage: &[Usage]) -> Result<(), TypeError> {
    for (snap, &u1) in snaps.iter().zip(then_usage) {
        let u2 = snap.now();
        let merged = match snap.lin {
            Linearity::Linear => {
                if u1 != u2 {
                    return Err(linearity_error(
                        snap,
                        if usage_rank(u1) < usage_rank(u2) { u1 } else { u2 },
                        "linear variable must be consumed in every branch or in none \
                         (only one branch runs)",
                    ));
                }
                u1
            }
            Linearity::Affine => {
                if usage_rank(u1) >= usage_rank(u2) { u1 } else { u2 }
            }
            Linearity::Relevant => {
                if usage_rank(u1) <= usage_rank(u2) { u1 } else { u2 }
            }
            Linearity::Unrestricted => u2,
        };
        snap.cell.set(merged);
    }
    Ok(())
}

/// A tracked binding consumed in code that may run zero or many times (a loop
/// body, the right operand of `&&`/`||`): a linear/affine use is rejected, a
/// relevant use does not count as the guaranteed one.
fn reject_repeatable_use(snaps: &[LinearSnap], context: &str) -> Result<(), TypeError> {
    for snap in snaps {
        if !snap.changed() {
            continue;
        }
        match snap.lin {
            Linearity::Linear | Linearity::Affine => {
                return Err(linearity_error(
                    snap,
                    Usage::Many,
                    &format!("{context}; a {:?} variable may not be consumed there", snap.lin),
                ));
            }
            Linearity::Relevant => snap.restore(),
            Linearity::Unrestricted => {}
        }
    }
    Ok(())
}

/// Mutable slots written outside the function/closure being checked (H2).
#[derive(Clone, Debug, Default, PartialEq, Eq)]
pub struct SlotWrites {
    /// Identified slots written.
    ids: HashSet<u64>,
    /// A write whose target slot cannot be identified (a top-level slot, or a
    /// call to a `Mut` function value that is not a known local closure).
    unknown: bool,
}

impl SlotWrites {
    fn is_empty(&self) -> bool {
        self.ids.is_empty() && !self.unknown
    }
}

/// A fresh identity for a `biar ubah` slot.
fn fresh_slot_id() -> u64 {
    use std::sync::atomic::{AtomicU64, Ordering};
    static NEXT: AtomicU64 = AtomicU64::new(0);
    NEXT.fetch_add(1, Ordering::Relaxed)
}

/// Full typing context matching Coq's has_type judgment: Γ Σ Δ
///
/// - gamma (Γ): Type environment — variable → type
/// - sigma (Σ): Store typing — location → (type, security_level)
/// - delta (Δ): Current security context level
///
/// Reference: `02_FORMAL/coq/foundations/Typing.v`
#[derive(Clone)]
pub struct TypingContext {
    /// Γ: Type environment
    pub gamma: TypeEnv,
    /// Σ: Store typing (mutable for allocations)
    pub sigma: StoreTy,
    /// Δ: Current security context level
    pub delta: SecurityLevel,
    /// Granted capabilities: effects authorized by enclosing Grant expressions
    /// Matches Coq T_Grant/T_Require (Typing.v:209-215)
    pub granted: HashSet<Effect>,
    /// Returns collected in the current function, shared across lexical scopes.
    pub return_types: Rc<RefCell<Vec<Ty>>>,
    /// pc raise of the current function: a `pulang` under a secret pc makes
    /// whether the REST of the function runs depend on that secret, so every
    /// later check in the function runs at least at this level (H2).
    pub fn_raise: Rc<Cell<SecurityLevel>>,
    /// pc raise of each enclosing loop of the current function (innermost
    /// last): a `putus`/`teruskan` (or `pulang`) under a secret pc makes the
    /// rest of the loop body and every later iteration secret-dependent (H2).
    pub loop_raises: Vec<Rc<Cell<SecurityLevel>>>,
    /// Identity of every mutable slot (`biar ubah`) in scope, by name. Each
    /// `biar ubah` gets a fresh id, so a later slot that reuses a name is a
    /// different slot. (A top-level slot seen by `validate_top_level_decls`
    /// has no id: it is always outside the function being checked.)
    pub slot_ids: PMap<Ident, u64>,
    /// Ids of the slots bound inside the current function or closure. A write
    /// to any OTHER slot is a side effect visible to the caller (H2), so the
    /// closure's latent effect becomes `Mut`.
    pub fn_slot_ids: PSet<u64>,
    /// Slots outside the current function/closure that it writes, directly or
    /// by calling a known local closure.
    pub outer_writes: Rc<RefCell<SlotWrites>>,
    /// For a variable bound directly to a lambda (`biar f = fungsi..`, or a
    /// local `fungsi f`): which slots outside that lambda it writes. A call to
    /// such a closure writing only the CALLER's own slots is, like a direct
    /// slot write, unobservable outside the caller — so it is not charged
    /// `Mut` to the caller (the secret-pc check at the call still applies).
    pub closure_writes: PMap<Ident, Rc<SlotWrites>>,
    /// The outer writes of the lambda most recently checked in this context,
    /// read by the binding that the lambda is directly bound to.
    pub last_closure_writes: Option<Rc<SlotWrites>>,
    /// Linearity of the `biar` binding that the lambda being checked is
    /// DIRECTLY bound to (`biar sekali f = fungsi(..) {..}`), if any. Only a
    /// closure that is itself linear/affine may capture a linear/affine
    /// variable (M2).
    pub closure_linearity: Option<Linearity>,
    /// Enforce the capability gate even when no capability is granted. Set for
    /// TOP-LEVEL code by `check_program`: top-level code holds only the
    /// capabilities it is explicitly granted (`beri`), never the union of the
    /// effects other functions declare (M1a).
    pub gate_always: bool,
    /// M1b — the most a `beri` may grant here. `None` in top-level code, where
    /// `beri` is the program's explicit capability MANIFEST and is
    /// unrestricted. Inside any function body — a top-level function, a local
    /// `fungsi`, or a closure — it is `Some(held)`: the capabilities that body
    /// already holds when it starts (`enter_function`). There `beri X` may only
    /// ATTENUATE: it is accepted only if `held` covers `X` under the effect
    /// partial order ([`EffectSet::covers`]), so a function cannot grant itself
    /// a capability its declaration (or its enclosing scope) did not give it.
    pub grant_ceiling: Option<EffectSet>,
    /// Top-level functions in scope (by name, unshadowed). At top level a call
    /// to one is authorized by the callee's own effect declaration — its body
    /// is checked against exactly that declaration — whereas a builtin gated
    /// operation needs an explicit grant.
    pub declared_fns: PSet<Ident>,
}

impl Default for TypingContext {
    fn default() -> Self {
        Self::new()
    }
}

impl TypingContext {
    pub fn new() -> Self {
        Self::with_level(SecurityLevel::Public)
    }

    /// Create context with specific security level
    pub fn with_level(delta: SecurityLevel) -> Self {
        Self {
            gamma: TypeEnv::new(),
            sigma: StoreTy::new(),
            delta,
            granted: HashSet::new(),
            return_types: Rc::default(),
            fn_raise: Rc::new(Cell::new(SecurityLevel::Public)),
            loop_raises: Vec::new(),
            slot_ids: PMap::new(),
            fn_slot_ids: PSet::new(),
            outer_writes: Rc::default(),
            closure_writes: PMap::new(),
            last_closure_writes: None,
            closure_linearity: None,
            gate_always: false,
            grant_ceiling: None,
            declared_fns: PSet::new(),
        }
    }

    /// The effective program counter: the lexical security context Δ joined
    /// with every raise caused by secret-dependent `pulang`/`putus`/`teruskan`
    /// earlier in the current function / enclosing loops.
    pub fn pc(&self) -> SecurityLevel {
        self.loop_raises
            .iter()
            .fold(self.delta.join(self.fn_raise.get()), |acc, c| acc.join(c.get()))
    }

    /// Start a fresh function scope (a lambda or a top-level function body):
    /// returns, control-flow raises, local slots and outer-write tracking are
    /// all per function. The definition-site pc is kept as Δ.
    ///
    /// M1b: a function body can only attenuate the capabilities it starts
    /// with — the grants in scope here (a top-level function's declared set,
    /// or a closure's / local `fungsi`'s lexically enclosing grants) become the
    /// ceiling for every `beri` inside it.
    pub fn enter_function(&mut self) {
        self.grant_ceiling = Some(self.held());
        self.delta = self.pc();
        self.return_types = Rc::default();
        self.fn_raise = Rc::new(Cell::new(SecurityLevel::Public));
        self.loop_raises = Vec::new();
        self.fn_slot_ids = PSet::new();
        self.outer_writes = Rc::default();
        self.last_closure_writes = None;
        self.closure_linearity = None;
    }

    /// Extend the type environment with a new binding
    pub fn extend_gamma(&self, name: Ident, ty: Ty) -> Self {
        let mut ctx = self.clone();
        ctx.declared_fns.remove(&name);
        ctx.slot_ids.remove(&name);
        ctx.closure_writes.remove(&name);
        ctx.gamma = self.gamma.extend(name, ty);
        ctx
    }

    /// Extend gamma with an explicit linearity qualifier.
    /// Used for `let lin x = e1 in e2` where x has restricted usage.
    pub fn extend_gamma_linear(&self, name: Ident, ty: Ty, lin: Linearity) -> Self {
        let mut ctx = self.clone();
        ctx.declared_fns.remove(&name);
        ctx.slot_ids.remove(&name);
        ctx.closure_writes.remove(&name);
        ctx.gamma = self.gamma.extend_linear(name, ty, lin);
        ctx
    }

    /// Create context with an additional granted capability
    pub fn with_grant(&self, eff: Effect) -> Self {
        let mut ctx = self.clone();
        ctx.granted.insert(eff);
        ctx
    }

    /// Grant a function's whole DECLARED effect set in its body: every
    /// component, plus `Pure` so that even a `kesan Bersih` body has a
    /// non-empty granted set (which is what switches the opt-in capability
    /// gate on — exactly as granting the old single lattice value did).
    pub fn with_declared_grants(&self, declared: EffectSet) -> Self {
        let mut ctx = self.clone();
        ctx.granted.insert(Effect::Pure);
        ctx.granted.extend(declared.iter());
        ctx
    }

    /// The capabilities held here, as a set (for the `beri` ceiling).
    pub fn held(&self) -> EffectSet {
        self.granted.iter().collect()
    }

    /// Whether the capability gate is active and `eff` is NOT granted. The
    /// gate is EXACT membership (holding `RangkaianSelamat` does not open a
    /// plaintext `Rangkaian` operation); only `beri` uses the coverage order.
    fn capability_missing(&self, eff: Effect) -> bool {
        (self.gate_always || !self.granted.is_empty()) && !self.granted.contains(&eff)
    }

    /// The first GATED member of `effs` the gate does not let through here.
    /// Every component of a latent effect set is checked: with the old single
    /// lattice value, a callee performing `(Rangkaian, Kripto)` was gated only
    /// on `Kripto` (the join) and its Network use went unchecked.
    fn missing_gated_capability(&self, effs: EffectSet) -> Option<Effect> {
        effs.iter().find(|e| is_gated_effect(*e) && self.capability_missing(*e))
    }

    /// Allocate a new location in the store typing
    pub fn alloc(&mut self, ty: Ty, sl: SecurityLevel) -> Location {
        self.sigma.extend(ty, sl)
    }

    /// Look up variable type in Γ
    pub fn lookup_var(&self, name: &Ident) -> Option<&Ty> {
        self.gamma.lookup(name)
    }

    /// Look up location type in Σ
    pub fn lookup_loc(&self, loc: &Location) -> Option<&(Ty, SecurityLevel)> {
        self.sigma.lookup(loc)
    }
}

/// Legacy context for backward compatibility
/// DEPRECATED: Use TypingContext for new code
///
/// `vars` is persistent ([`PMap`]) for the same reason as [`TypeEnv`]: the
/// builtin registry alone is ~600 sequential `extend`s.
#[derive(Clone)]
pub struct Context {
    vars: PMap<Ident, Ty>,
    level: SecurityLevel,
    return_types: Rc<RefCell<Vec<Ty>>>,
}

impl Default for Context {
    fn default() -> Self {
        Self::new()
    }
}

impl Context {
    pub fn new() -> Self {
        Self {
            vars: PMap::new(),
            level: SecurityLevel::Public,
            return_types: Rc::default(),
        }
    }

    pub fn extend(&self, name: Ident, ty: Ty) -> Self {
        let mut new_vars = self.vars.clone();
        new_vars.insert(name, ty);
        Self {
            vars: new_vars,
            level: self.level,
            return_types: self.return_types.clone(),
        }
    }

    pub fn lookup(&self, name: &Ident) -> Option<&Ty> {
        self.vars.get(name)
    }

    /// Iterate the bindings (name → type). Used by tooling that walks the
    /// registered builtins, e.g. the stdlib API-doc generator.
    pub fn iter(&self) -> impl Iterator<Item = (&Ident, &Ty)> {
        self.vars.iter()
    }

    /// Convert to new TypingContext
    pub fn to_typing_context(&self) -> TypingContext {
        // Every binding is unrestricted, so the environment is exactly these
        // bindings — shared, not copied.
        let gamma = TypeEnv {
            vars: self.vars.clone(),
            linearity: PMap::new(),
        };
        let mut ctx = TypingContext::with_level(self.level);
        ctx.gamma = gamma;
        ctx.return_types = self.return_types.clone();
        ctx
    }
}

/// Register builtin function types into a context.
/// Uses Ty::Any for polymorphic builtins.
pub fn register_builtin_types(ctx: &Context) -> Context {
    let mut c = ctx.clone();
    // I/O builtins. Printing to stdout is a Write effect (`Tulis`), matching the
    // documented effect vocabulary and the example corpus — a function that
    // prints declares `kesan Tulis`.
    c = c.extend(
        "cetak".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Unit), Effect::Write.into()),
    );
    c = c.extend(
        "print".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Unit), Effect::Write.into()),
    );
    c = c.extend(
        "cetakln".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Unit), Effect::Write.into()),
    );
    // `cetak_baris` ("print line") is the BM name the example corpus uses for a
    // line-terminated print; same signature as `cetakln`.
    c = c.extend(
        "cetak_baris".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Unit), Effect::Write.into()),
    );
    c = c.extend(
        "println".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Unit), Effect::Write.into()),
    );
    // String
    c = c.extend(
        "gabung_teks".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
            Box::new(Ty::String),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "concat".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
            Box::new(Ty::String),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "panjang".to_string(),
        Ty::Fn(Box::new(Ty::String), Box::new(Ty::Int), Effect::Pure.into()),
    );
    c = c.extend(
        "length".to_string(),
        Ty::Fn(Box::new(Ty::String), Box::new(Ty::Int), Effect::Pure.into()),
    );
    // Range constructors `a..b` / `a..=b`: (Int, Int) -> List<Int>.
    c = c.extend(
        "julat".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::Int))),
            Box::new(Ty::List(Box::new(Ty::Int))),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "julat_inklusif".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::Int))),
            Box::new(Ty::List(Box::new(Ty::Int))),
            Effect::Pure.into(),
        ),
    );
    // Sum (Option/Result) introspection for constructor-pattern desugaring.
    c = c.extend(
        "adalah_kiri".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Bool), Effect::Pure.into()),
    );
    c = c.extend(
        "adalah_kanan".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Bool), Effect::Pure.into()),
    );
    c = c.extend(
        "nilai_kiri".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Any), Effect::Pure.into()),
    );
    c = c.extend(
        "nilai_kanan".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Any), Effect::Pure.into()),
    );
    // Conversion
    c = c.extend(
        "ke_teks".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::String), Effect::Pure.into()),
    );
    c = c.extend(
        "to_string".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::String), Effect::Pure.into()),
    );
    c = c.extend(
        "ke_nombor".to_string(),
        Ty::Fn(Box::new(Ty::String), Box::new(Ty::Int), Effect::Pure.into()),
    );
    c = c.extend(
        "parse_int".to_string(),
        Ty::Fn(Box::new(Ty::String), Box::new(Ty::Int), Effect::Pure.into()),
    );
    // Arbitrary-precision integer constructor (numeric-tower BigInt slice):
    // parse a base-10 string of any length into a `BigInt`.
    for nm in ["besar", "bigint"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::BigInt), Effect::Pure.into()),
        );
    }
    // Arbitrary-precision decimal constructor (numeric-tower decimal slice):
    // parse a decimal literal string into a `Decimal`.
    for nm in ["perpuluhan", "decimal"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Decimal), Effect::Pure.into()),
        );
    }
    // Fixed-scale decimal / money (numeric-tower fixed-point slice): `wang` parses
    // a literal (scale inferred from the digits); `titik_tetap` takes a
    // `(literal, scale)` pair and rounds half-to-even to that scale.
    for nm in ["wang", "money"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Fixed), Effect::Pure.into()),
        );
    }
    for nm in ["titik_tetap", "fixed"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::Int))),
                Box::new(Ty::Fixed),
                Effect::Pure.into(),
            ),
        );
    }
    // Binary fixed-point / Q-format: `qmn((literal, frac_bits)) -> Qmn`.
    for nm in ["qmn", "binary_fixed"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::Int))),
                Box::new(Ty::FixedBin),
                Effect::Pure.into(),
            ),
        );
    }
    // Unicode NFC normalization (UAX #15): `String -> String`, pure.
    for nm in ["nfc", "ke_nfc"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::String), Effect::Pure.into()),
        );
    }
    // UTS #39 confusable skeleton (`String -> String`) + detection
    // (`(String, String) -> Bool`), both pure.
    for nm in ["skeleton", "rangka"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::String), Effect::Pure.into()),
        );
    }
    for nm in ["adalah_keliru", "is_confusable"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
                Box::new(Ty::Bool),
                Effect::Pure.into(),
            ),
        );
    }
    // Virtual-filesystem builtins (verified access-control via riina-os VFS).
    // `vfs_mula`/`vfs_jadi_pengguna` take an Int (byte quota / uid); `vfs_tulis`
    // a `(path, data)` pair; `vfs_baca`/`vfs_padam` a path. All carry filesystem
    // effects (not the capability-gated `System`) so they are usable directly.
    let unit_ty = || Box::new(Ty::Unit);
    for nm in ["vfs_mula", "vfs_init", "vfs_jadi_pengguna", "vfs_become_user"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), unit_ty(), Effect::FileSystem.into()),
        );
    }
    for nm in ["vfs_tulis", "vfs_write"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
                unit_ty(),
                Effect::Write.into(),
            ),
        );
    }
    for nm in ["vfs_baca", "vfs_read"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::String), Effect::Read.into()),
        );
    }
    for nm in ["vfs_padam", "vfs_delete"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::Write.into()),
        );
    }
    // Network builtins (real TCP gated by the verified RFC 793 state machine
    // in riina-os `net`). `jaring_sambung` takes "host:port" and returns a
    // connection id; `jaring_hantar` a `(conn, data)` pair returning the byte
    // count; `jaring_terima` a `(conn, max_bytes)` pair returning the data;
    // `jaring_tutup` a connection id. All carry the Network effect.
    for nm in ["jaring_sambung", "net_connect"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Int), Effect::Network.into()),
        );
    }
    for nm in ["jaring_hantar", "net_send"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::Int),
                Effect::Network.into(),
            ),
        );
    }
    for nm in ["jaring_terima", "net_recv"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::Int))),
                Box::new(Ty::String),
                Effect::Network.into(),
            ),
        );
    }
    for nm in ["jaring_tutup", "net_close"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Bool), Effect::Network.into()),
        );
    }
    // Passive open: `jaring_dengar` binds "host:port" and returns a listener
    // id; `jaring_alamat` reports its actual local address (ephemeral-port
    // discovery); `jaring_terima_sambungan` blocks for one connection and
    // returns a connection id usable with hantar/terima/tutup.
    for nm in ["jaring_dengar", "net_listen"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Int), Effect::Network.into()),
        );
    }
    for nm in ["jaring_alamat", "net_local_addr"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::String), Effect::Network.into()),
        );
    }
    for nm in ["jaring_terima_sambungan", "net_accept"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Network.into()),
        );
    }
    // TLS 1.3 record protection (real AEAD via riina-tls on riina-core):
    // `jaring_tls_kunci` installs keys from `(conn, traffic_secret)`;
    // `jaring_tls_hantar` seals `(conn, data)`; `jaring_tls_terima` opens the
    // next record on a conn. NetworkSecure effect — these are the encrypted
    // paths, distinguished from the plaintext `jaring_*` Network ones.
    // A real TLS 1.3 handshake over an established connection (ECDHE + key
    // schedule + Finished): `Nombor -> Benar`, NetworkSecure.
    for nm in ["jaring_tls_jabat", "net_tls_handshake"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Bool), Effect::NetworkSecure.into()),
        );
    }
    // Authentication (RFC 7250 raw public keys + §4.4.3 CertificateVerify):
    // identity takes a hex seed and returns the hex credential; percaya pins a
    // hex credential; jabat_sah runs the authenticated handshake; disahkan
    // reports whether the full Coq tls_connected conjunction holds.
    for nm in ["jaring_tls_identiti", "net_tls_identity"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::String),
                Box::new(Ty::String),
                Effect::NetworkSecure.into(),
            ),
        );
    }
    for nm in ["jaring_tls_percaya", "net_tls_trust"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Bool), Effect::NetworkSecure.into()),
        );
    }
    for nm in ["jaring_tls_jabat_sah", "net_tls_handshake_auth"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Bool), Effect::NetworkSecure.into()),
        );
    }
    for nm in ["jaring_tls_disahkan", "net_tls_is_authenticated"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Bool), Effect::NetworkSecure.into()),
        );
    }
    for nm in ["jaring_tls_kunci", "net_tls_keys"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::Bool),
                Effect::NetworkSecure.into(),
            ),
        );
    }
    for nm in ["jaring_tls_hantar", "net_tls_send"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::Int),
                Effect::NetworkSecure.into(),
            ),
        );
    }
    for nm in ["jaring_tls_terima", "net_tls_recv"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::String), Effect::NetworkSecure.into()),
        );
    }
    for nm in ["jaring_tutup_dengar", "net_close_listener"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Bool), Effect::Network.into()),
        );
    }
    // Durable key-value store (REQ-73 persistence). All carry FileSystem: a
    // put/delete is fsynced to disk before it returns.
    for nm in ["simpan_buka", "store_open"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Int), Effect::FileSystem.into()),
        );
    }
    for nm in ["simpan_letak", "store_put"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(
                    Box::new(Ty::Int),
                    Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
                )),
                Box::new(Ty::Bool),
                Effect::FileSystem.into(),
            ),
        );
    }
    for nm in ["simpan_dapat", "store_get"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::String),
                Effect::FileSystem.into(),
            ),
        );
    }
    for nm in ["simpan_ada", "store_has"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::Bool),
                Effect::FileSystem.into(),
            ),
        );
    }
    for nm in ["simpan_padam", "store_delete"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::Bool),
                Effect::FileSystem.into(),
            ),
        );
    }
    for nm in ["simpan_kunci", "store_keys"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Int),
                Box::new(Ty::List(Box::new(Ty::String))),
                Effect::FileSystem.into(),
            ),
        );
    }
    for nm in ["simpan_padat", "store_compact"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Bool), Effect::FileSystem.into()),
        );
    }
    for nm in ["simpan_tutup", "store_close"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Bool), Effect::FileSystem.into()),
        );
    }
    // Real HTTP/1.1 above the verified TCP machine (REQ-73). Parsing is Pure;
    // only `http_minta` touches the network. These are DISTINCT from the
    // modelled `http_get`/`http_post` sinks below, which open no socket.
    for nm in ["http_hurai_kaedah", "http_parse_method"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::String), Effect::Pure.into()),
        );
    }
    for nm in ["http_hurai_laluan", "http_parse_target"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::String), Effect::Pure.into()),
        );
    }
    for nm in ["http_hurai_jasad", "http_parse_body"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::String), Effect::Pure.into()),
        );
    }
    for nm in ["http_hurai_kepala", "http_parse_header"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
                Box::new(Ty::String),
                Effect::Pure.into(),
            ),
        );
    }
    for nm in ["http_balas", "http_build_response"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::String),
                Effect::Pure.into(),
            ),
        );
    }
    for nm in ["http_minta", "http_request"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
                Box::new(Ty::String),
                Effect::Network.into(),
            ),
        );
    }
    // Pure TLS acceptance policy (Coq NET_001_03 no-downgrade + NET_001_08
    // cipher strength): `(version, cipher_suite) -> Bool`, no I/O.
    for nm in ["tls_dasar_ok", "tls_policy_ok"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
                Box::new(Ty::Bool),
                Effect::Pure.into(),
            ),
        );
    }
    c = c.extend(
        "ke_bool".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Bool), Effect::Pure.into()),
    );
    c = c.extend(
        "to_bool".to_string(),
        Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Bool), Effect::Pure.into()),
    );
    // Math
    c = c.extend(
        "mutlak".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure.into()),
    );
    c = c.extend(
        "abs".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure.into()),
    );
    for name in &[
        "minimum", "min", "maksimum", "max", "kuasa", "pow", "gcd", "lcm",
    ] {
        c = c.extend(
            name.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::Int))),
                Box::new(Ty::Int),
                Effect::Pure.into(),
            ),
        );
    }
    c = c.extend(
        "punca".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure.into()),
    );
    c = c.extend(
        "sqrt".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure.into()),
    );
    // Assert
    c = c.extend(
        "tegaskan".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Unit), Effect::Pure.into()),
    );
    c = c.extend(
        "assert".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Unit), Effect::Pure.into()),
    );
    c = c.extend(
        "tegaskan_betul".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Unit), Effect::Pure.into()),
    );
    c = c.extend(
        "assert_true".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Unit), Effect::Pure.into()),
    );
    c = c.extend(
        "tegaskan_salah".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Unit), Effect::Pure.into()),
    );
    c = c.extend(
        "assert_false".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Unit), Effect::Pure.into()),
    );
    c = c.extend(
        "tegaskan_sama".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::Any), Box::new(Ty::Any))),
            Box::new(Ty::Unit),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "assert_eq".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::Any), Box::new(Ty::Any))),
            Box::new(Ty::Unit),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "tegaskan_beza".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::Any), Box::new(Ty::Any))),
            Box::new(Ty::Unit),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "assert_ne".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::Any), Box::new(Ty::Any))),
            Box::new(Ty::Unit),
            Effect::Pure.into(),
        ),
    );

    // ── String builtins (teks) ──
    for (bm, en) in &[
        ("teks_belah", "str_split"),
        ("teks_cantum", "str_join"),
        ("teks_potong", "str_trim"),
        ("teks_mengandungi", "str_contains"),
        ("teks_ganti", "str_replace"),
        ("teks_mula_dengan", "str_starts_with"),
        ("teks_akhir_dengan", "str_ends_with"),
        ("teks_huruf_besar", "str_to_upper"),
        ("teks_huruf_kecil", "str_to_lower"),
        ("teks_aksara_di", "str_char_at"),
        ("teks_sub", "str_substring"),
        ("teks_indeks", "str_index_of"),
        ("teks_ulang", "str_repeat"),
        ("teks_pad_kiri", "str_pad_left"),
        ("teks_pad_kanan", "str_pad_right"),
        ("teks_baris", "str_lines"),
    ] {
        let ty = Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Any), Effect::Pure.into());
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }

    // ── List builtins (senarai) ──
    for (bm, en) in &[
        ("senarai_baru", "list_new"),
        ("senarai_tolak", "list_push"),
        ("senarai_dapat", "list_get"),
        ("senarai_panjang", "list_len"),
        ("senarai_peta", "list_map"),
        ("senarai_tapis", "list_filter"),
        ("senarai_lipat", "list_fold"),
        ("senarai_balik", "list_reverse"),
        ("senarai_susun", "list_sort"),
        ("senarai_mengandungi", "list_contains"),
        ("senarai_sambung", "list_concat"),
        ("senarai_kepala", "list_head"),
        ("senarai_ekor", "list_tail"),
        ("senarai_zip", "list_zip"),
        ("senarai_nombor", "list_enumerate"),
        ("senarai_rata", "list_flatten"),
        ("senarai_unik", "list_unique"),
        ("senarai_potong", "list_slice"),
    ] {
        let ty = Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Any), Effect::Pure.into());
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }

    // ── Map builtins (peta) ──
    for (bm, en) in &[
        ("peta_baru", "map_new"),
        ("peta_letak", "map_insert"),
        ("peta_dapat", "map_get"),
        ("peta_buang", "map_remove"),
        ("peta_kunci", "map_keys"),
        ("peta_nilai", "map_values"),
        ("peta_mengandungi", "map_contains"),
        ("peta_panjang", "map_len"),
    ] {
        let ty = Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Any), Effect::Pure.into());
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }

    // ── Set builtins ──
    for (bm, en) in &[
        ("set_baru", "set_new"),
        ("set_letak", "set_insert"),
        ("set_buang", "set_remove"),
        ("set_mengandungi", "set_contains"),
        ("set_kesatuan", "set_union"),
        ("set_persilangan", "set_intersect"),
        ("set_panjang", "set_len"),
    ] {
        let ty = Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Any), Effect::Pure.into());
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }

    // ── File I/O builtins (fail) — Effect::FileSystem ──
    // Content-reading builtins are hardened (Gate C stdlib hardening): the path
    // must be a `String`, so a `Tainted` untrusted path is rejected at the I/O
    // boundary (path-traversal prevention, Coq `TaintSystemCorrectness.v`
    // `file_path_traversal_impossible` — the filesystem corollary of
    // `path_traversal_impossible`); and the returned contents are
    // `Tainted<String, FileSystem>` — an untrusted source that must be sanitized
    // before reaching any sink (Coq taint safety). The prototype↔Coq parity is
    // exercised by `taint_path_traversal_prevention_parity_all_file_ops`.
    for (bm, en) in &[("fail_baca", "file_read"), ("fail_baca_baris", "file_read_lines")] {
        let ty = Ty::Fn(
            Box::new(Ty::String),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::FileSystem,
            )),
            Effect::FileSystem.into(),
        );
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }
    // Single-path file ops take a `String` path (a `Tainted` untrusted path is
    // rejected — path-traversal prevention, consistent with `file_read`) and now
    // carry precise result types: exists→Bool, delete→Unit, size→Int. `list_dir`
    // stays `Any` (a directory listing; a later slice can make it a tainted list).
    for (bm, en, ret) in &[
        ("fail_ada", "file_exists", Ty::Bool),
        ("fail_buang", "file_delete", Ty::Unit),
        ("fail_panjang", "file_size", Ty::Int),
        ("fail_senarai", "file_list_dir", Ty::Any),
    ] {
        let ty = Ty::Fn(Box::new(Ty::String), Box::new(ret.clone()), Effect::FileSystem.into());
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }
    // Write/append take a `(path, data)` pair (the runtime `extract_pair_strings`
    // and the C `(Teks, Teks) -> ()` shape). Precise typing: the **path** is a
    // plain `String` so a `Tainted` untrusted path is rejected (path-traversal
    // prevention, like the single-path ops), the **data** is a `String` (declassify
    // tainted content before writing it to a sink), and the result is `Unit`.
    for (bm, en) in &[("fail_tulis", "file_write"), ("fail_tambah", "file_append")] {
        let ty = Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
            Box::new(Ty::Unit),
            Effect::FileSystem.into(),
        );
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }

    // ── Time builtins (masa) — precise types matching the runtime
    // (`riina-codegen/src/builtins/masa.rs` + the C emit). Was `Any → Any` (the
    // "Time interface — Unclear" stdlib row). The clocks are `Unit -> Int`
    // (the runtime value is a `Builtin`, i.e. a function, so this is sound — a
    // bare `Int` would type-check programs the untyped interpreter then rejects);
    // `sleep` takes a millisecond `Int`; `format`/`parse` take a `(value, format)`
    // pair. The `()` zero-arg-thunk *materialisation* at runtime is a separate,
    // codebase-wide item (the interpreter evaluates a bare builtin `Var` to its
    // `Builtin` value, like `baca_garisan`).
    let unit_to_int = || Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::Int), Effect::Time.into());
    for (bm, en, ty) in [
        ("masa_sekarang", "time_now", unit_to_int()),
        // `masa_unix` — alias used by the example corpus (REQ-55): same clock.
        ("masa_unix", "time_unix", unit_to_int()),
        ("masa_sekarang_ms", "time_now_ms", unit_to_int()),
        ("masa_jam", "time_clock", unit_to_int()),
        (
            "masa_tidur",
            "time_sleep",
            Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Unit), Effect::Time.into()),
        ),
        (
            "masa_format",
            "time_format",
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::String))),
                Box::new(Ty::String),
                Effect::Time.into(),
            ),
        ),
        (
            "masa_urai",
            "time_parse",
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
                Box::new(Ty::Int),
                Effect::Time.into(),
            ),
        ),
    ] {
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }

    // ── JSON builtins ──
    for (bm, en) in &[
        ("json_urai", "json_parse"),
        ("json_ke_teks", "json_stringify"),
        ("json_dapat", "json_get"),
        ("json_letak", "json_set"),
        ("json_ada", "json_has"),
    ] {
        let ty = Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Any), Effect::Pure.into());
        c = c.extend(bm.to_string(), ty.clone());
        c = c.extend(en.to_string(), ty);
    }

    // ── Extra math builtins ──
    //
    // `baki`/`rem` are BINARY and take a pair, like `minimum`/`maksimum`/`kuasa`.
    // They were previously typed `Nombor -> Nombor` because they shared this
    // loop with the genuinely unary `log2`, which made them **uncallable from
    // any well-typed program**: `baki(10, 3)` is `App(App(baki, 10), 3)` and
    // failed with "Expected function type, found Int", while `baki((10, 3))`
    // failed with "expected Int, found Prod(Int, Int)". Both the interpreter
    // (`matematik.rs`, `extract_pair_ints`) and the emitted C
    // (`riina_builtin_baki`, which requires `RIINA_TAG_PAIR`) have always taken
    // a pair, so the type was the single odd one out.
    for nm in ["baki", "rem"] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(
                Box::new(Ty::Prod(Box::new(Ty::Int), Box::new(Ty::Int))),
                Box::new(Ty::Int),
                Effect::Pure.into(),
            ),
        );
    }
    // `log2` really is unary — it is what the loop above was written for.
    c = c.extend(
        "log2".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Pure.into()),
    );
    // Random — Effect::Random
    c = c.extend(
        "rawak".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Random.into()),
    );
    c = c.extend(
        "random".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::Int), Effect::Random.into()),
    );

    // ── Extra conversion builtins ──
    c = c.extend(
        "bool_ke_nombor".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Int), Effect::Pure.into()),
    );
    c = c.extend(
        "bool_to_int".to_string(),
        Ty::Fn(Box::new(Ty::Bool), Box::new(Ty::Int), Effect::Pure.into()),
    );
    c = c.extend(
        "nombor_ke_teks".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::String), Effect::Pure.into()),
    );
    c = c.extend(
        "int_to_string".to_string(),
        Ty::Fn(Box::new(Ty::Int), Box::new(Ty::String), Effect::Pure.into()),
    );

    // ── DOMAIN SECURITY: Taint Sources (return tainted data) ──

    // User input → Tainted<String, UserInput>
    c = c.extend(
        "read_line".to_string(),
        Ty::Fn(
            Box::new(Ty::Unit),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Effect::System.into(),
        ),
    );
    c = c.extend(
        "baca_baris".to_string(),
        Ty::Fn(
            Box::new(Ty::Unit),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Effect::System.into(),
        ),
    );
    // `baca_garisan` — read one line of input as plain text. A real
    // `Unit -> Teks` function, like the `masa_*` clocks beside it. It used to
    // be bound to its RESULT type `Teks`, because a zero-arg call dropped its
    // `()` and left a bare `Var`; that typed the call site as a string while
    // the runtime value was the un-applied builtin (master plan REQ-68).
    c = c.extend(
        "baca_garisan".to_string(),
        Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::String), Effect::System.into()),
    );

    // HTTP request body → Tainted<String, NetworkExternal>
    c = c.extend(
        "http_body".to_string(),
        Ty::Fn(
            Box::new(Ty::Any),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::NetworkExternal,
            )),
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "badan_http".to_string(),
        Ty::Fn(
            Box::new(Ty::Any),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::NetworkExternal,
            )),
            Effect::Network.into(),
        ),
    );

    // ── DOMAIN SECURITY: Sanitizers (Tainted → Sanitized) ──

    // SQL sanitizer
    c = c.extend(
        "sanitize_sql".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::SqlParam,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_sql".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::SqlParam,
            )),
            Effect::Pure.into(),
        ),
    );

    // HTML sanitizer
    c = c.extend(
        "sanitize_html".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::HtmlEscape,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_html".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::HtmlEscape,
            )),
            Effect::Pure.into(),
        ),
    );

    // JavaScript sanitizer
    c = c.extend(
        "sanitize_js".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsEscape,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_js".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsEscape,
            )),
            Effect::Pure.into(),
        ),
    );

    // Command sanitizer
    c = c.extend(
        "sanitize_command".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::CommandEscape,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_perintah".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::CommandEscape,
            )),
            Effect::Pure.into(),
        ),
    );

    // LDAP sanitizer
    c = c.extend(
        "sanitize_ldap".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::LdapEscape,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_ldap".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::LdapEscape,
            )),
            Effect::Pure.into(),
        ),
    );

    // ── DOMAIN SECURITY: Sensitive Sinks (require Sanitized) ──

    // SQL execution — REQUIRES Sanitized<String, SqlParam>
    c = c.extend(
        "sql_execute".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::SqlParam,
            )),
            Box::new(Ty::Any), // Query results
            Effect::System.into(),
        ),
    );
    c = c.extend(
        "sql_laksana".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::SqlParam,
            )),
            Box::new(Ty::Any),
            Effect::System.into(),
        ),
    );

    // HTML rendering — REQUIRES Sanitized<String, HtmlEscape>
    c = c.extend(
        "html_render".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::HtmlEscape,
            )),
            Box::new(Ty::String),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "html_papar".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::HtmlEscape,
            )),
            Box::new(Ty::String),
            Effect::Pure.into(),
        ),
    );

    // JavaScript eval — REQUIRES Sanitized<String, JsEscape>
    c = c.extend(
        "js_eval".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsEscape,
            )),
            Box::new(Ty::Any),
            Effect::System.into(),
        ),
    );
    c = c.extend(
        "js_nilai".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsEscape,
            )),
            Box::new(Ty::Any),
            Effect::System.into(),
        ),
    );

    // Shell command execution — REQUIRES Sanitized<String, CommandEscape>
    c = c.extend(
        "shell_exec".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::CommandEscape,
            )),
            Box::new(Ty::Int), // Exit code
            Effect::System.into(),
        ),
    );
    c = c.extend(
        "shell_laksana".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::CommandEscape,
            )),
            Box::new(Ty::Int),
            Effect::System.into(),
        ),
    );

    // LDAP search — REQUIRES Sanitized<String, LdapEscape>
    c = c.extend(
        "ldap_search".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::LdapEscape,
            )),
            Box::new(Ty::Any), // Search results
            Effect::System.into(),
        ),
    );
    c = c.extend(
        "ldap_cari".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::LdapEscape,
            )),
            Box::new(Ty::Any),
            Effect::System.into(),
        ),
    );

    // ── TASK #4: Enhanced XSS Prevention ──

    // URL sanitizer (for safe redirects/links)
    c = c.extend(
        "sanitize_url".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlEncode,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_url".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlEncode,
            )),
            Effect::Pure.into(),
        ),
    );

    // CSS sanitizer (for safe style injection)
    c = c.extend(
        "sanitize_css".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::CssEscape,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_css".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::CssEscape,
            )),
            Effect::Pure.into(),
        ),
    );

    // ── DOM Manipulation (context-aware) ──

    // Safe innerHTML setter — REQUIRES HtmlEscape
    c = c.extend(
        "dom_set_html".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Any), // DOM element
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::HtmlEscape,
                )),
            )),
            Box::new(Ty::Unit),
            Effect::System.into(),
        ),
    );
    c = c.extend(
        "dom_tetap_html".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Any),
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::HtmlEscape,
                )),
            )),
            Box::new(Ty::Unit),
            Effect::System.into(),
        ),
    );

    // Safe attribute setter — REQUIRES HtmlEscape
    c = c.extend(
        "dom_set_attr".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Any), // DOM element
                Box::new(Ty::Prod(
                    Box::new(Ty::String), // Attribute name
                    Box::new(Ty::Sanitized(
                        Box::new(Ty::String),
                        riina_types::Sanitizer::HtmlEscape,
                    )),
                )),
            )),
            Box::new(Ty::Unit),
            Effect::System.into(),
        ),
    );
    c = c.extend(
        "dom_tetap_atribut".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Any),
                Box::new(Ty::Prod(
                    Box::new(Ty::String),
                    Box::new(Ty::Sanitized(
                        Box::new(Ty::String),
                        riina_types::Sanitizer::HtmlEscape,
                    )),
                )),
            )),
            Box::new(Ty::Unit),
            Effect::System.into(),
        ),
    );

    // ── Input Validation (pre-sanitization) ──

    // Length-bounded input validation
    c = c.extend(
        "validate_length".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Tainted(
                    Box::new(Ty::String),
                    riina_types::TaintSource::UserInput,
                )),
                Box::new(Ty::Int), // Max length
            )),
            Box::new(Ty::Option(Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )))),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sahkan_panjang".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Tainted(
                    Box::new(Ty::String),
                    riina_types::TaintSource::UserInput,
                )),
                Box::new(Ty::Int),
            )),
            Box::new(Ty::Option(Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )))),
            Effect::Pure.into(),
        ),
    );

    // Unicode normalization (prevents homograph attacks)
    c = c.extend(
        "normalize_unicode".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "normal_unicode".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Effect::Pure.into(),
        ),
    );

    // Strip null bytes (prevents injection bypass)
    c = c.extend(
        "strip_nulls".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "buang_null".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Effect::Pure.into(),
        ),
    );

    // ── TASK #5: CSRF Protection ──
    // Matches Coq CSRFProtection.v (20 Qed proofs)
    // All 5 CSRF protections: token validation, same-site cookies, origin check,
    // referer check, double-submit pattern

    // Generate CSRF token (cryptographically secure random token)
    // Spec: CSRFProtection.v — csrf_token_validation
    c = c.extend(
        "csrf_generate".to_string(),
        Ty::Fn(
            Box::new(Ty::Unit),
            Box::new(Ty::String), // Base64-encoded token
            Effect::Random.into(),       // Cryptographic randomness required
        ),
    );
    c = c.extend(
        "csrf_jana".to_string(),
        Ty::Fn(Box::new(Ty::Unit), Box::new(Ty::String), Effect::Random.into()),
    );

    // Validate CSRF token (request token vs session token)
    // Spec: CSRFProtection.v — csrf_double_submit
    c = c.extend(
        "csrf_validate".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String), // Request token
                Box::new(Ty::String), // Session token
            )),
            Box::new(Ty::Bool), // Validation result
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "csrf_sahkan".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
            Box::new(Ty::Bool),
            Effect::Pure.into(),
        ),
    );

    // Check origin header (same-origin policy enforcement)
    // Spec: CSRFProtection.v — csrf_origin_check
    c = c.extend(
        "csrf_check_origin".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String), // Request origin
                Box::new(Ty::String), // Expected origin
            )),
            Box::new(Ty::Bool),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "csrf_semak_origin".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
            Box::new(Ty::Bool),
            Effect::Pure.into(),
        ),
    );

    // Check referer header
    // Spec: CSRFProtection.v — csrf_referer_check
    c = c.extend(
        "csrf_check_referer".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String), // Request referer
                Box::new(Ty::String), // Expected referer
            )),
            Box::new(Ty::Bool),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "csrf_semak_referer".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
            Box::new(Ty::Bool),
            Effect::Pure.into(),
        ),
    );

    // ── HTTP Methods with CSRF Protection ──

    // Safe GET request (no CSRF token required — safe method)
    c = c.extend(
        "http_get".to_string(),
        Ty::Fn(
            Box::new(Ty::String), // URL only (no token needed)
            Box::new(Ty::Any),    // Response
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "http_dapat".to_string(),
        Ty::Fn(Box::new(Ty::String), Box::new(Ty::Any), Effect::Network.into()),
    );

    // State-changing POST (CSRF token REQUIRED in type signature)
    // Type: (URL, (body, csrf_token)) -> Response
    // The nested pair forces callers to provide a CSRF token
    c = c.extend(
        "http_post".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String), // URL
                Box::new(Ty::Prod(
                    Box::new(Ty::Any),    // Request body
                    Box::new(Ty::String), // CSRF token (REQUIRED)
                )),
            )),
            Box::new(Ty::Any), // Response
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "http_hantar".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String),
                Box::new(Ty::Prod(Box::new(Ty::Any), Box::new(Ty::String))),
            )),
            Box::new(Ty::Any),
            Effect::Network.into(),
        ),
    );

    // State-changing PUT (CSRF token REQUIRED)
    // Type: (URL, (body, csrf_token)) -> Response
    c = c.extend(
        "http_put".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String), // URL
                Box::new(Ty::Prod(
                    Box::new(Ty::Any),    // Request body
                    Box::new(Ty::String), // CSRF token (REQUIRED)
                )),
            )),
            Box::new(Ty::Any),
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "http_kemaskini".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String),
                Box::new(Ty::Prod(Box::new(Ty::Any), Box::new(Ty::String))),
            )),
            Box::new(Ty::Any),
            Effect::Network.into(),
        ),
    );

    // State-changing DELETE (CSRF token REQUIRED)
    // Type: (URL, csrf_token) -> Response
    // DELETE has no body, so just URL + token
    c = c.extend(
        "http_delete".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String), // URL
                Box::new(Ty::String), // CSRF token (REQUIRED)
            )),
            Box::new(Ty::Any),
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "http_padam".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(Box::new(Ty::String), Box::new(Ty::String))),
            Box::new(Ty::Any),
            Effect::Network.into(),
        ),
    );

    // ── TASK #6: Extended Domain Security Enforcement ──
    // 5 new OWASP attack classes: Path Traversal, XML/XXE, SSRF,
    // Email Header Injection, Unsafe Deserialization

    // ── 6a: Path Traversal (CWE-22) ──
    // Spec: TaintSystemCorrectness.v — path_traversal_impossible
    // Spec: VerifiedFileSystem.v

    // Path sanitizer: Tainted → Sanitized<String, PathTraversal>
    c = c.extend(
        "sanitize_path".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::PathTraversal,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_laluan".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::PathTraversal,
            )),
            Effect::Pure.into(),
        ),
    );

    // Safe file read — REQUIRES Sanitized<String, PathTraversal>
    c = c.extend(
        "file_read_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::PathTraversal,
            )),
            Box::new(Ty::Any), // File contents
            Effect::Read.into(),
        ),
    );
    c = c.extend(
        "fail_baca_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::PathTraversal,
            )),
            Box::new(Ty::Any),
            Effect::Read.into(),
        ),
    );

    // Safe file write — REQUIRES Sanitized<String, PathTraversal>
    c = c.extend(
        "file_write_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::PathTraversal,
                )),
                Box::new(Ty::Any), // Data to write
            )),
            Box::new(Ty::Unit),
            Effect::Write.into(),
        ),
    );
    c = c.extend(
        "fail_tulis_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::PathTraversal,
                )),
                Box::new(Ty::Any),
            )),
            Box::new(Ty::Unit),
            Effect::Write.into(),
        ),
    );

    // Safe file delete — REQUIRES Sanitized<String, PathTraversal>
    c = c.extend(
        "file_delete_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::PathTraversal,
            )),
            Box::new(Ty::Bool), // Success
            Effect::Write.into(),
        ),
    );
    c = c.extend(
        "fail_buang_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::PathTraversal,
            )),
            Box::new(Ty::Bool),
            Effect::Write.into(),
        ),
    );

    // ── 6b: XML Injection / XXE (CWE-611) ──
    // Spec: InjectionPrevention.v — inj_005_xxe_impossible

    // XML sanitizer: Tainted → Sanitized<String, XmlEscape>
    c = c.extend(
        "sanitize_xml".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::XmlEscape,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_xml".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::XmlEscape,
            )),
            Effect::Pure.into(),
        ),
    );

    // Safe XML parse — REQUIRES Sanitized<String, XmlEscape>
    c = c.extend(
        "xml_parse_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::XmlEscape,
            )),
            Box::new(Ty::Any), // Parsed XML tree
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "xml_urai_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::XmlEscape,
            )),
            Box::new(Ty::Any),
            Effect::Pure.into(),
        ),
    );

    // XML query — REQUIRES Sanitized<String, XmlEscape>
    c = c.extend(
        "xml_query".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::XmlEscape,
            )),
            Box::new(Ty::Any), // Query results
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "xml_cari".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::XmlEscape,
            )),
            Box::new(Ty::Any),
            Effect::Pure.into(),
        ),
    );

    // ── 6c: SSRF (CWE-918) ──
    // Spec: WebSecurity.v — web_005_ssrf_impossible

    // URL validator: Tainted → Sanitized<String, UrlAllowlist>
    c = c.extend(
        "validate_url".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlAllowlist,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sahkan_url".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlAllowlist,
            )),
            Effect::Pure.into(),
        ),
    );

    // Safe HTTP fetch — REQUIRES Sanitized<String, UrlAllowlist>
    c = c.extend(
        "http_fetch_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlAllowlist,
            )),
            Box::new(Ty::Any), // Response
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "http_ambil_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlAllowlist,
            )),
            Box::new(Ty::Any),
            Effect::Network.into(),
        ),
    );

    // Safe HTTP redirect — REQUIRES Sanitized<String, UrlAllowlist>
    c = c.extend(
        "http_redirect_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlAllowlist,
            )),
            Box::new(Ty::Unit),
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "http_arah_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::UrlAllowlist,
            )),
            Box::new(Ty::Unit),
            Effect::Network.into(),
        ),
    );

    // ── 6d: Email Header Injection (CWE-93) ──
    // Spec: InjectionPrevention.v — inj_011_email_header_safe

    // Email sanitizer: Tainted → Sanitized<String, EmailValidation>
    c = c.extend(
        "sanitize_email".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::EmailValidation,
            )),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "sanitasi_emel".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::EmailValidation,
            )),
            Effect::Pure.into(),
        ),
    );

    // Email send — REQUIRES Sanitized<String, EmailValidation>
    c = c.extend(
        "email_send".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::EmailValidation,
                )),
                Box::new(Ty::String), // Message body
            )),
            Box::new(Ty::Bool), // Success
            Effect::Network.into(),
        ),
    );
    c = c.extend(
        "emel_hantar".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::EmailValidation,
                )),
                Box::new(Ty::String),
            )),
            Box::new(Ty::Bool),
            Effect::Network.into(),
        ),
    );

    // Email set header — REQUIRES Sanitized<String, EmailValidation>
    c = c.extend(
        "email_set_header".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String), // Header name
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::EmailValidation,
                )),
            )),
            Box::new(Ty::Unit),
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "emel_tetap_kepala".to_string(),
        Ty::Fn(
            Box::new(Ty::Prod(
                Box::new(Ty::String),
                Box::new(Ty::Sanitized(
                    Box::new(Ty::String),
                    riina_types::Sanitizer::EmailValidation,
                )),
            )),
            Box::new(Ty::Unit),
            Effect::Pure.into(),
        ),
    );

    // ── 6e: Unsafe Deserialization (CWE-502) ──
    // Spec: DeserializationSafety.v — rce_prevention_active

    // JSON sanitizer: Tainted → Sanitized<String, JsonValidation>
    c = c.extend(
        "sanitize_json".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsonValidation,
            )),
            Effect::Pure.into(),
        ),
    );
    // JSON string-CONTENT escaper: Tainted → Sanitized<String, JsonEscape>.
    //
    // It used to mint `JsonValidation`, which made it the only producer of the
    // marker `json_urai_selamat` requires — and therefore the only way to reach
    // the safe parser. But it ESCAPES rather than validates: `{"a":1}` becomes
    // `{\"a\":1}`, so every JSON object arrived at the parser malformed and came
    // back as Unit. Measured before the split: an object parsed to `null`, while
    // a quote-free `[1,2,3]` survived, because only quote-free documents pass
    // through an escaper unchanged.
    //
    // `JsonEscape` says what this actually guarantees: safe to EMBED inside a
    // JSON string literal. Reaching the parser is now `sahkan_json`'s job.
    c = c.extend(
        "sanitasi_json".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsonEscape,
            )),
            Effect::Pure.into(),
        ),
    );

    // JSON document VALIDATOR: Tainted → Sanitized<String, JsonValidation>.
    //
    // The real gate on the safe parser. It does not transform its input at all —
    // a validator that edited the document would be an escaper again. It parses
    // to decide, and returns the text unchanged when the parse succeeds; on
    // malformed input it returns the empty string, which `json_urai_selamat`
    // then yields Unit for, preserving that builtin's never-abort contract.
    c = c.extend(
        "sahkan_json".to_string(),
        Ty::Fn(
            Box::new(Ty::Tainted(
                Box::new(Ty::String),
                riina_types::TaintSource::UserInput,
            )),
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsonValidation,
            )),
            Effect::Pure.into(),
        ),
    );

    // Safe JSON parse — REQUIRES Sanitized<String, JsonValidation>
    c = c.extend(
        "json_parse_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsonValidation,
            )),
            Box::new(Ty::Any), // Parsed value
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "json_urai_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsonValidation,
            )),
            Box::new(Ty::Any),
            Effect::Pure.into(),
        ),
    );

    // Safe deserialize — REQUIRES Sanitized<String, JsonValidation>
    c = c.extend(
        "deserialize_safe".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsonValidation,
            )),
            Box::new(Ty::Any), // Deserialized object
            Effect::Pure.into(),
        ),
    );
    c = c.extend(
        "nyahsiri_selamat".to_string(),
        Ty::Fn(
            Box::new(Ty::Sanitized(
                Box::new(Ty::String),
                riina_types::Sanitizer::JsonValidation,
            )),
            Box::new(Ty::Any),
            Effect::Pure.into(),
        ),
    );

    // Crypto-agility selection builtins (REQ-48): take an algorithm-name string,
    // return a crypto handle (`Any`), effect Crypto. The deprecation check fires
    // at these call sites — the App arm's `deprecated_algorithm_at_selection`,
    // mirroring `CUse` in crypto/AlgorithmPolicy.v.
    for nm in [
        "guna_kripto",
        "use_crypto",
        "pilih_algo",
        "select_algorithm",
        "cipher",
        "sifer",
        "hash_dengan",
        "hash_with",
    ] {
        c = c.extend(
            nm.to_string(),
            Ty::Fn(Box::new(Ty::String), Box::new(Ty::Any), Effect::Crypto.into()),
        );
    }

    c
}

/// Select the result type when joining two branch types that are already known
/// to be [`types_compatible`], preferring the more concrete type. If one side
/// is `Any` (RIINA's wildcard, produced for example by unannotated
/// Option/Result payloads), the other more concrete type is used; otherwise the
/// first is returned (they are compatible, so either is acceptable).
/// A return never falls through, but its value still constrains its function.
fn function_result_type(mut tail: Ty, returns: &[Ty]) -> Result<Ty, TypeError> {
    for returned in returns {
        if !types_compatible(&tail, returned) {
            return Err(TypeError::TypeMismatch { expected: tail, found: returned.clone() });
        }
        tail = join_branch_types(tail, returned.clone());
    }
    Ok(tail)
}

fn label_at_level(ty: Ty, level: SecurityLevel) -> Ty {
    if level.leq(ty_secrecy_level(&ty).unwrap_or(SecurityLevel::Public)) { ty }
    else if level == SecurityLevel::Secret { Ty::Secret(Box::new(ty)) }
    else { Ty::Labeled(Box::new(ty), level) }
}

/// Parser-generated iteration primitives cannot be shadowed by source names.
fn internal_primitive_type(name: &str) -> Option<Ty> {
    let (arg, result) = match name {
        "$guard_fail" => (Ty::Unit, Ty::Any),
        "$for_len" => (Ty::Any, Ty::Int),
        "$for_get" => (Ty::Any, Ty::Any),
        _ => return None,
    };
    Some(Ty::Fn(Box::new(arg), Box::new(result), Effect::Pure.into()))
}

/// Preserve an iterable's element type through lowering, so a return from a
/// `untuk` body is checked against the enclosing function's declared result.
fn internal_primitive_result(callee: &Expr, argument: &Ty, fallback: Ty) -> Result<Ty, TypeError> {
    let Expr::Var(name) = callee else { return Ok(fallback) };
    let (argument, _) = strip_label(argument);
    let list = match (name.as_str(), argument) {
        ("$for_len", list) => list,
        ("$for_get", Ty::Prod(list, _)) => list.as_ref(),
        ("$for_get", Ty::Any) => return Ok(Ty::Any),
        _ => return Ok(fallback),
    };
    let (list, level) = strip_label(list);
    match list {
        Ty::List(element) => Ok(if name == "$for_get" {
            label_at_level(*element.clone(), level)
        } else { Ty::Int }),
        Ty::Any => Ok(fallback),
        _ => Err(TypeError::TypeMismatch {
            expected: Ty::List(Box::new(Ty::Any)), found: list.clone(),
        }),
    }
}

// ============================================================================
// `Any` ERASURE DISCIPLINE (H1/H4/M3)
// ============================================================================
//
// `Ty::Any` is RIINA's wildcard: generic parameters, records (`jenis`), and
// most collection builtins are typed `Any`. `types_compatible` lets ANY type
// flow into an `Any` position, so everything the static type recorded about
// the value — its secrecy label, its taint, its constant-time tag, and, for a
// function value, the effect it performs when called — is FORGOTTEN at that
// point. Coq has no `Any` (every `has_type` rule is exact), so this is a
// Rust-only escape hatch and must not launder anything. The discipline:
//
//   * every point where a value is viewed at an `Any` type computes what was
//     erased (`erased_info`);
//   * the erased label/taint/CT tag is carried by the `Any`-typed RESULT
//     (`rewrap`): a record or list built from a secret is secret, a call whose
//     argument erased a secret returns a secret, and so on;
//   * an erased latent EFFECT is charged at the erasure point — the receiver
//     may call the function at any time, so it is performed "here" for the
//     purposes of the effect discipline, the capability gate and the pc check;
//   * a function whose DECLARED result type is a wildcard may not hide any of
//     these in its result (`erased_result_check`) — callers only see the
//     declaration.

/// What a value can reveal or do once its static type is forgotten.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Latent {
    /// Highest secrecy level of any data the value carries or can produce.
    level: SecurityLevel,
    /// Taint of any untrusted data the value carries or can produce.
    taint: Option<riina_types::TaintSource>,
    /// Whether it carries/produces a `ConstantTime` value.
    ct: bool,
    /// Effect performed when (a function inside) the value is called.
    effect: EffectSet,
}

impl Latent {
    const NONE: Latent = Latent {
        level: SecurityLevel::Public,
        taint: None,
        ct: false,
        effect: EffectSet::PURE,
    };

    fn join(self, other: Latent) -> Latent {
        Latent {
            level: self.level.join(other.level),
            taint: self.taint.or(other.taint),
            ct: self.ct || other.ct,
            effect: self.effect.join(other.effect),
        }
    }

    fn level(level: SecurityLevel) -> Latent {
        Latent { level, ..Latent::NONE }
    }

    /// The data-flow part only (the effect is accounted separately).
    fn data(self) -> Latent {
        Latent { effect: EffectSet::PURE, ..self }
    }
}

/// Everything a value of type `ty` can reveal or do if it is viewed as `Any`:
/// labels, taint and CT tags anywhere inside it, a reference's own level (its
/// contents are read at that level), and — for a function — its latent effect
/// plus whatever its RESULT can reveal (the receiver may call it).
///
/// EXHAUSTIVE on purpose, like `ty_secrecy_level`: a container this walk does
/// not descend into would be a laundering path, so a new `Ty` variant must
/// fail the build here.
fn latent_info(ty: &Ty) -> Latent {
    match ty {
        Ty::Secret(inner) => latent_info(inner).join(Latent::level(SecurityLevel::Secret)),
        Ty::Labeled(inner, l) | Ty::Ref(inner, l) => latent_info(inner).join(Latent::level(*l)),
        Ty::Tainted(inner, src) => latent_info(inner).join(Latent { taint: Some(*src), ..Latent::NONE }),
        Ty::ConstantTime(inner) => latent_info(inner).join(Latent { ct: true, ..Latent::NONE }),
        Ty::SecureChan(_, l) => Latent::level(*l),
        Ty::Fn(_, result, eff) => latent_info(result).join(Latent { effect: *eff, ..Latent::NONE }),
        Ty::Prod(a, b) | Ty::Sum(a, b) | Ty::Actor(a, b) | Ty::CRDT(a, b) => {
            latent_info(a).join(latent_info(b))
        }
        Ty::List(inner)
        | Ty::Option(inner)
        | Ty::Sanitized(inner, _)
        | Ty::Zeroizing(inner)
        | Ty::Proof(inner)
        | Ty::RawPtr(inner)
        | Ty::ContentAddressed(inner)
        | Ty::Supervisor(inner)
        | Ty::SmartContract(inner)
        | Ty::Token(inner)
        | Ty::SyariahCompliant(inner) => latent_info(inner),
        Ty::Chan(_) | Ty::Choreography(_, _) => Latent::NONE,
        Ty::Unit
        | Ty::Bool
        | Ty::Int
        | Ty::IntN { .. }
        | Ty::BigInt
        | Ty::Decimal
        | Ty::Fixed
        | Ty::FixedBin
        | Ty::String
        | Ty::Bytes
        | Ty::Capability(_)
        | Ty::CapabilityFull(_)
        | Ty::Any
        | Ty::CChar
        | Ty::CInt
        | Ty::CVoid
        | Ty::Color
        | Ty::Element
        | Ty::Layout
        | Ty::UIStyle
        | Ty::AccessibleText => Latent::NONE,
    }
}

/// What is FORGOTTEN when a value of type `found` is accepted where `expected`
/// is required (the two are already `types_compatible`): the latent info of
/// every `found` component that lands in an `Any` position of `expected`.
/// A wrapper on the expected side covers what it already records (e.g. a
/// `Rahsia<T>` parameter keeps anything up to Secret).
fn erased_info(expected: &Ty, found: &Ty) -> Latent {
    match (expected, found) {
        (Ty::Any, found) => latent_info(found),
        (Ty::Prod(a, b), Ty::Prod(c, d))
        | (Ty::Sum(a, b), Ty::Sum(c, d))
        | (Ty::Actor(a, b), Ty::Actor(c, d))
        | (Ty::CRDT(a, b), Ty::CRDT(c, d)) => erased_info(a, c).join(erased_info(b, d)),
        (Ty::List(a), Ty::List(b))
        | (Ty::Option(a), Ty::Option(b))
        | (Ty::Option(a), Ty::Sum(b, _))
        | (Ty::Sum(a, _), Ty::Option(b))
        | (Ty::Sanitized(a, _), Ty::Sanitized(b, _))
        | (Ty::Ref(a, _), Ty::Ref(b, _))
        | (Ty::Zeroizing(a), Ty::Zeroizing(b))
        | (Ty::Proof(a), Ty::Proof(b))
        | (Ty::ContentAddressed(a), Ty::ContentAddressed(b))
        | (Ty::Supervisor(a), Ty::Supervisor(b))
        | (Ty::SmartContract(a), Ty::SmartContract(b))
        | (Ty::Token(a), Ty::Token(b))
        | (Ty::SyariahCompliant(a), Ty::SyariahCompliant(b))
        // A function's latent effect is not erased (`types_compatible` already
        // requires found ⊑ expected); only what its result reveals can be.
        | (Ty::Fn(_, a, _), Ty::Fn(_, b, _)) => erased_info(a, b),
        (Ty::Secret(a), Ty::Secret(b)) => Latent {
            level: SecurityLevel::Public,
            ..erased_info(a, b)
        },
        (Ty::Labeled(a, l), Ty::Labeled(b, _)) => {
            let inner = erased_info(a, b);
            Latent {
                level: if inner.level.leq(*l) { SecurityLevel::Public } else { inner.level },
                ..inner
            }
        }
        (Ty::Tainted(a, _), Ty::Tainted(b, _)) => Latent { taint: None, ..erased_info(a, b) },
        (Ty::ConstantTime(a), Ty::ConstantTime(b)) => Latent { ct: false, ..erased_info(a, b) },
        _ => Latent::NONE,
    }
}

/// Strip the security / taint / constant-time wrappers off the top of a type,
/// returning the core type and what the wrappers recorded.
fn peel(ty: &Ty) -> (&Ty, Latent) {
    let mut core = ty;
    let mut wrap = Latent::NONE;
    loop {
        match core {
            Ty::Secret(inner) => {
                wrap.level = wrap.level.join(SecurityLevel::Secret);
                core = inner;
            }
            Ty::Labeled(inner, l) => {
                wrap.level = wrap.level.join(*l);
                core = inner;
            }
            Ty::Tainted(inner, src) => {
                wrap.taint = wrap.taint.or(Some(*src));
                core = inner;
            }
            Ty::ConstantTime(inner) => {
                wrap.ct = true;
                core = inner;
            }
            _ => return (core, wrap),
        }
    }
}

/// Re-attach erased data-flow info to a type: constant-time innermost, then
/// taint, then the security label. Info the type already records is not
/// duplicated.
fn rewrap(ty: Ty, info: &Latent) -> Ty {
    let present = latent_info(&ty);
    let mut ty = ty;
    if info.ct && !present.ct {
        ty = Ty::ConstantTime(Box::new(ty));
    }
    if let (Some(src), None) = (info.taint, present.taint) {
        ty = Ty::Tainted(Box::new(ty), src);
    }
    label_at_level(ty, info.level)
}

/// Whether `ty` has an `Any` position anywhere — i.e. it could hand a value to
/// a sink that accepts anything.
fn ty_contains_any(ty: &Ty) -> bool {
    match ty {
        Ty::Any => true,
        Ty::Prod(a, b) | Ty::Sum(a, b) | Ty::Actor(a, b) | Ty::CRDT(a, b) | Ty::Fn(a, b, _) => {
            ty_contains_any(a) || ty_contains_any(b)
        }
        Ty::List(i)
        | Ty::Option(i)
        | Ty::Secret(i)
        | Ty::Labeled(i, _)
        | Ty::Tainted(i, _)
        | Ty::Sanitized(i, _)
        | Ty::Ref(i, _)
        | Ty::ConstantTime(i)
        | Ty::Zeroizing(i)
        | Ty::Proof(i)
        | Ty::RawPtr(i)
        | Ty::ContentAddressed(i)
        | Ty::Supervisor(i)
        | Ty::SmartContract(i)
        | Ty::Token(i)
        | Ty::SyariahCompliant(i) => ty_contains_any(i),
        _ => false,
    }
}

/// A function whose DECLARED result type has a wildcard (`Any`: a generic
/// `T`, a record, an unknown nominal type) must not return, in that position,
/// data more secret / tainted / constant-time than the declaration says —
/// callers only see the declaration, so the label would be silently dropped
/// (H1: `fungsi buka<T>(s: Rahsia<Nombor>) -> T { s }` returned the secret as
/// a plain `T`). Coq's T_App/T_Lam use the exact result type, so this only
/// closes the Rust `Any` gap. Returns the latent effect of function values
/// erased into the result, which the caller must charge to the function.
fn erased_result_check(declared: &Ty, found: &Ty) -> Result<EffectSet, TypeError> {
    let hidden = erased_info(declared, found);
    if hidden.level != SecurityLevel::Public {
        return Err(TypeError::SecurityViolation {
            found: hidden.level,
            expected: SecurityLevel::Public,
            context: "function result: a generic/record (Any) result type cannot carry secret \
                      data; declare the result as Rahsia<...> or declassify (dedah) first",
        });
    }
    if hidden.ct {
        return Err(TypeError::ConstantTimeViolation {
            context: "a function result typed generic/record (Any), which drops the ConstantTime tag",
        });
    }
    if hidden.taint.is_some() {
        return Err(TypeError::AnnotationMismatch {
            expected: declared.clone(),
            found: found.clone(),
        });
    }
    Ok(hidden.effect)
}

/// Check a LetRec/LetRecGroup binding's inferred function type against its
/// declaration for erased result information (see `erased_result_check`).
fn erased_function_check(declared: &Ty, found: &Ty) -> Result<(), TypeError> {
    let hidden_eff = erased_result_check(declared, found)?;
    let declared_eff = match declared {
        Ty::Fn(_, _, e) => *e,
        _ => EffectSet::PURE,
    };
    check_effects_covered(declared_eff, hidden_eff)
}

/// A LetRec/LetRecGroup binding's inferred latent effects against its declared
/// `kesan`, arrow by arrow along the curried chain, reported as an
/// `EffectViolation` naming the uncovered effect (the structural
/// `types_compatible` check that follows would only say "annotation
/// mismatch").
fn declared_latent_check(declared: &Ty, found: &Ty) -> Result<(), TypeError> {
    if let (Ty::Fn(_, r1, e1), Ty::Fn(_, r2, e2)) = (declared, found) {
        check_effects_covered(*e1, *e2)?;
        declared_latent_check(r1, r2)?;
    }
    Ok(())
}

/// The effect discipline: everything `performed` must be covered by the
/// `declared` set under the category-respecting partial order
/// ([`EffectSet::covers`]) — never by a merely higher-numbered effect of
/// another category (M1c: `kesan Masa` does not cover `SistemFail`).
fn check_effects_covered(declared: EffectSet, performed: EffectSet) -> Result<(), TypeError> {
    match declared.first_uncovered(performed) {
        Some(found) => Err(TypeError::EffectViolation { allowed: declared, found }),
        None => Ok(()),
    }
}

/// Call rule of the legacy `type_check`: an effectful call whose argument
/// erases a secret into an `Any` position (or that runs in a secret context)
/// is rejected; the result re-carries whatever was erased.
fn check_call_secrecy(expected: &Ty, found: &Ty, result: Ty, effect: EffectSet,
    pc: SecurityLevel) -> Result<Ty, TypeError> {
    let hidden = erased_info(expected, found);
    let observable_level = pc.join(hidden.level);
    if !effect.join(hidden.effect).is_pure() && observable_level != SecurityLevel::Public {
        return Err(TypeError::SecurityViolation {
            found: observable_level, expected: SecurityLevel::Public,
            context: "effectful call (including aliases)",
        });
    }
    let mut carried = hidden.data();
    if !ty_contains_any(&result) {
        carried.taint = None;
    }
    Ok(rewrap(result, &carried))
}

/// A mutable cell (`biar ubah` slot or `ruj` reference) whose content type has
/// an `Any` position is read back as a plain `Any`, so a taint or constant-time
/// tag erased into it would be laundered (H1/M3). Secrecy is handled by the
/// cell's level check; these two have no level to compare against.
fn reject_erased_into_cell(cell: &Ty, value: &Ty, hidden: &Latent) -> Result<(), TypeError> {
    if hidden.ct {
        return Err(TypeError::ConstantTimeViolation {
            context: "a value stored into an untyped (Any) mutable cell, which drops the ConstantTime tag",
        });
    }
    if hidden.taint.is_some() {
        return Err(TypeError::TypeMismatch {
            expected: cell.clone(),
            found: value.clone(),
        });
    }
    Ok(())
}

/// Effects the capability gate covers (reach-extending / secret / entropy / OS).
fn is_gated_effect(eff: Effect) -> bool {
    matches!(
        eff,
        Effect::Network
            | Effect::NetworkSecure
            | Effect::Process
            | Effect::Crypto
            | Effect::Random
            | Effect::System
    )
}

/// Charge the latent effect of function values erased into an `Any` position
/// at the erasure point: it must be granted (capability gate) and must not run
/// under a secret pc, exactly as if the function were called here.
fn charge_erased_effect(ctx: &TypingContext, latent: EffectSet, pc: SecurityLevel) -> Result<(), TypeError> {
    if latent.is_pure() {
        return Ok(());
    }
    if let Some(missing) = ctx.missing_gated_capability(latent) {
        return Err(TypeError::CapabilityViolation {
            required: missing,
            message: format!(
                "a function value performing {latent:?} is passed into an untyped (Any) position, \
                 where it may be called; {missing:?} must be granted in scope"
            ),
        });
    }
    if pc != SecurityLevel::Public {
        return Err(TypeError::SecurityViolation {
            found: pc,
            expected: SecurityLevel::Public,
            context: "a function value with side effects erased into an untyped (Any) position \
                      under a secret pc",
        });
    }
    Ok(())
}

/// H2: the effect charged to the CALLER for calling `callee`. A call to a
/// known local closure (`biar f = fungsi..`, local `fungsi f`) whose only
/// effect is writing mutable slots is charged nothing when every slot it
/// writes belongs to the caller — exactly like the caller writing its own slot
/// directly, which is unobservable outside it. Slots outside the caller are
/// recorded as the caller's own outer writes (so the caller becomes `Mut`).
/// Anything else is charged its full latent effect. The secret-pc check at the
/// call site always uses the full effect.
fn attribute_slot_writes(ctx: &TypingContext, callee: &Expr, fn_eff: EffectSet) -> EffectSet {
    // Only a closure whose ENTIRE latent effect is `Mut` qualifies.
    if fn_eff != Effect::Mut {
        return fn_eff;
    }
    let Expr::Var(f) = callee else { return fn_eff };
    let Some(writes) = ctx.closure_writes.get(f) else { return fn_eff };
    if writes.unknown {
        return fn_eff;
    }
    let mut outer = ctx.outer_writes.borrow_mut();
    for id in &writes.ids {
        if !ctx.fn_slot_ids.contains(id) {
            outer.ids.insert(*id);
        }
    }
    EffectSet::PURE
}

/// Join two compatible types (branch arms, a function's returns), preferring
/// the more concrete side of every `Any` and NEVER dropping a label: arm types
/// are joined structurally, and if a label of either side is still not
/// represented the result is labeled at it.
fn join_branch_types(t1: Ty, t2: Ty) -> Ty {
    fn structural(t1: Ty, t2: Ty) -> Ty {
        match (t1, t2) {
            (Ty::Any, t) | (t, Ty::Any) => t,
            (Ty::Prod(a, b), Ty::Prod(c, d)) => {
                Ty::Prod(Box::new(structural(*a, *c)), Box::new(structural(*b, *d)))
            }
            (Ty::Sum(a, b), Ty::Sum(c, d)) => {
                Ty::Sum(Box::new(structural(*a, *c)), Box::new(structural(*b, *d)))
            }
            (Ty::List(a), Ty::List(b)) => Ty::List(Box::new(structural(*a, *b))),
            (Ty::Option(a), Ty::Option(b)) => Ty::Option(Box::new(structural(*a, *b))),
            (Ty::Secret(a), Ty::Secret(b)) => Ty::Secret(Box::new(structural(*a, *b))),
            (Ty::Labeled(a, l1), Ty::Labeled(b, l2)) if l1 == l2 => {
                Ty::Labeled(Box::new(structural(*a, *b)), l1)
            }
            (Ty::Fn(a, r1, e1), Ty::Fn(_, r2, e2)) => {
                Ty::Fn(a, Box::new(structural(*r1, *r2)), e1.join(e2))
            }
            (t1, _) => t1,
        }
    }
    let wanted = latent_info(&t1).join(latent_info(&t2)).level;
    let joined = structural(t1, t2);
    if wanted.leq(latent_info(&joined).level) {
        joined
    } else {
        label_at_level(joined, wanted)
    }
}

/// M3: indexing a collection with a constant-time value makes the memory
/// access pattern (and so the timing) depend on it. The comment on
/// `ConstantTimeViolation` states the discipline: CT values may not be used as
/// branch conditions OR AS INDICES. `e[i]` desugars to `senarai_dapat((e, i))`.
fn ct_index_violation(callee: &Expr, arg_ty: &Ty) -> Option<TypeError> {
    let Expr::Var(name) = callee else { return None };
    let indexing = matches!(
        name.as_str(),
        "senarai_dapat"
            | "list_get"
            | "senarai_potong"
            | "list_slice"
            | "teks_aksara_di"
            | "str_char_at"
            | "teks_sub"
            | "str_substring"
            | "peta_dapat"
            | "map_get"
            | "json_dapat"
            | "json_get"
    );
    if !indexing {
        return None;
    }
    let (core, wrap) = peel(arg_ty);
    let index_is_ct = wrap.ct
        || match core {
            Ty::Prod(_, index) => latent_info(index).ct,
            _ => false,
        };
    index_is_ct.then_some(TypeError::ConstantTimeViolation {
        context: "a collection index or lookup key (secret-dependent memory access)",
    })
}

/// Refine an incompatible function-application argument error.
///
/// A sink whose parameter type is `Sanitized<_, required>` (e.g. `sql_execute`,
/// `ldap_search`, `xml_parse_safe`) produces a taint-specific diagnostic that
/// mirrors the Coq injection-prevention theorems in
/// `domains/TaintSystemCorrectness.v`, rather than a generic `TypeMismatch`:
/// - a `Tainted<_, src>` argument ⇒ `TaintViolation` (unsanitized data at a sink),
/// - a `Sanitized<_, other>` argument with the wrong sanitizer ⇒ `SanitizerMismatch`.
///
/// Any other incompatibility falls back to `TypeMismatch`.
fn sink_argument_error(arg_ty: Ty, found: Ty) -> TypeError {
    if let Ty::Sanitized(_, required) = &arg_ty {
        match &found {
            Ty::Tainted(_, src) => {
                return TypeError::TaintViolation {
                    taint_source: *src,
                    required_sanitizer: required.clone(),
                    context: "sink argument",
                };
            }
            Ty::Sanitized(_, found_san) if found_san != required => {
                return TypeError::SanitizerMismatch {
                    expected: required.clone(),
                    found: found_san.clone(),
                    context: "sink argument",
                };
            }
            _ => {}
        }
    }
    TypeError::TypeMismatch {
        expected: arg_ty,
        found,
    }
}

/// IFC sink discipline (REQ-27): data classified above `Public` may not reach a
/// public sink without declassification. Covers the sinks whose argument (or an
/// `Any`-typed position inside it) would otherwise swallow secret/labeled data:
///   - print sinks  `cetak`/`cetakln`/`cetak_baris`/`print`/`println` (arg `Any`)
///   - network-send `http_post`/`http_hantar`/`http_put` (body is `Any` inside
///     the `(URL, (body, csrf))` pair)
///   - file-write   `file_write`/`fail_tulis`/`file_append`/`fail_tambah`
///     (data is a concrete `String`, so a raw `Secret`/`Labeled` is already a
///     `TypeMismatch`; routing it here yields the *clear* `SecurityViolation`).
///
/// Coq forbids this flow: a `TSecret` value re-enters public typing only through
/// `T_Declassify` with a matching proof (`declass_ok`;
/// `properties/Declassification.v` `logical_relation_declassify_proven` /
/// `declassify_requires_public_context`), and a non-`Public` `Labeled` value
/// dereferenced from a secret reference carries the source level by the no-read-up
/// rule (`foundations/Typing.v` `T_Deref`). Reaching a Public sink without
/// declassifying is a `SecurityViolation` (secret data on a Public channel), not
/// a generic `TypeMismatch`. The check is conservative: a secret anywhere in the
/// sink argument (incl. the URL or CSRF position) is rejected — none of those
/// should be secret-derived either.
/// Crypto-agility (REQ-48): the algorithm-deprecation policy.
///
/// The table and the `is_current` / `deprecation_reason` functions now live in
/// `riina_types::crypto_policy`, because the policy is consulted TWICE — here,
/// statically, when a selection site's algorithm name is a literal, and at
/// runtime by `riina_codegen::builtins::kripto` for every selection whatever
/// the name's provenance (a computed name is invisible to this checker). One
/// shared table means the two gates cannot disagree. Re-exported so every
/// existing `crypto_policy::` path in this crate and its tests still resolves.
pub use riina_types::crypto_policy;

/// Crypto-agility sink (REQ-48): a crypto-selection builtin whose string
/// argument names a deprecated algorithm is rejected. Mirrors the Coq
/// `accepts pol (CUse a)` rule — the check runs at the algorithm-selection site,
/// exactly where `CUse` sits in the model. Recognised selection builtins are
/// the ones that take an algorithm name: `guna_kripto`/`use_crypto`,
/// `pilih_algo`/`select_algorithm`, `cipher`/`sifer`, `hash_dengan`/`hash_with`.
fn deprecated_algorithm_at_selection(callee: &Expr, arg: &Expr) -> Option<TypeError> {
    let Expr::Var(name) = callee else { return None };
    let is_selection = matches!(
        name.as_str(),
        "guna_kripto"
            | "use_crypto"
            | "pilih_algo"
            | "select_algorithm"
            | "cipher"
            | "sifer"
            | "hash_dengan"
            | "hash_with"
    );
    if !is_selection {
        return None;
    }
    let Expr::String(algo) = arg else { return None };
    if crypto_policy::is_current(algo) {
        return None;
    }
    Some(TypeError::DeprecatedAlgorithm {
        algorithm: algo.clone(),
        message: crypto_policy::deprecation_reason(algo).to_string(),
    })
}

fn secrecy_at_sink(callee: &Expr, arg_ty: &Ty) -> Option<TypeError> {
    let Expr::Var(name) = callee else { return None };
    let context = match name.as_str() {
        "cetak" | "cetakln" | "cetak_baris" | "print" | "println" => {
            "print sink: declassify (dedah) the secret before printing it"
        }
        // `http_kemaskini` is the BM alias of `http_put` (REQ-27 audit
        // 2026-06-12: it was registered but missing here — a secret body
        // passed the checker). GET/DELETE carry no `Any` body, but their
        // URL/token positions are still exfiltration channels; checking here
        // (before unification) upgrades the opaque TypeMismatch a raw secret
        // would produce into an actionable SecurityViolation.
        "http_post" | "http_hantar" | "http_put" | "http_kemaskini" | "http_get"
        | "http_dapat" | "http_delete" | "http_padam" => {
            "network sink: declassify (dedah) the secret before sending it over the network"
        }
        // The sanitized-path variants (`*_selamat`/`*_safe`) have an
        // `Any`-typed DATA position, so unlike the plain file writes a raw
        // secret sailed through unification (REQ-27 audit 2026-06-12).
        "file_write" | "fail_tulis" | "file_append" | "fail_tambah"
        | "file_write_safe" | "fail_tulis_selamat" => {
            "file-write sink: declassify (dedah) the secret before writing it to a file"
        }
        // A failing assertion renders BOTH operands into the runtime error
        // message (`assert_eq failed: {:?} != {:?}` — builtins/ujian.rs), so
        // an assert on a secret is an error-message sink.
        "assert_eq" | "tegaskan_sama" | "assert_ne" | "tegaskan_beza" => {
            "assertion sink: a failing assertion prints its operands; declassify (dedah) the secret before asserting on it"
        }
        _ => return None,
    };
    let found = ty_secrecy_level(arg_ty)?;
    Some(TypeError::SecurityViolation {
        found,
        expected: SecurityLevel::Public,
        context,
    })
}

/// The highest above-`Public` secrecy carried by `ty` in a data position, or
/// `None` if every leaf is `Public`/unlabeled.
///
/// `Secret<_>` is the lattice top (`SecurityLevel::Secret`); `Labeled(_, l)`
/// contributes `l` when `l != Public`; `SecureChan(_, l)` contributes its own
/// channel level. Recurses through EVERY container a sink could serialize:
/// products, sums, lists, options, the security/taint wrappers, refs,
/// constant-time/zeroizing wrappers, proof witnesses, raw pointers, and the
/// JALINAN / blockchain / Syariah containers (`ContentAddressed`, `Actor`,
/// `CRDT`, `Supervisor`, `SmartContract`, `Token`, `SyariahCompliant`).
///
/// Deliberately does NOT recurse into `Fn` (serializing a closure renders the
/// function value, not its captured data — a secret RESULT is caught at the
/// call site, where the result type is what reaches the sink) nor into
/// `Chan`/`Choreography` (session payloads are governed by the session/IFC
/// rules, not by this scan). `Any` is not treated as secret-bearing — the
/// check is syntactic on the inferred argument type, which is why
/// `propagate_secrecy_through_builtin` exists to re-carry labels through
/// `Any`-typed builtins.
///
/// The match is EXHAUSTIVE on purpose: this walk is exactly as deep as the
/// sink rule, so a missed container is a leak path, and a new `Ty` variant
/// must fail the build here rather than silently open one.
fn ty_secrecy_level(ty: &Ty) -> Option<SecurityLevel> {
    fn join(a: Option<SecurityLevel>, b: Option<SecurityLevel>) -> Option<SecurityLevel> {
        match (a, b) {
            (Some(x), Some(y)) => Some(if x.leq(y) { y } else { x }),
            (x, None) => x,
            (None, y) => y,
        }
    }
    // EXHAUSTIVE by construction — no wildcard arm. This walk is the depth of
    // the sink rule: a container it does not descend into answers "no secret",
    // and `secrecy_at_sink` then lets the value reach `cetak`/`http_post`/
    // `file_write`. It previously ended in `_ => None`, so every JALINAN /
    // blockchain / Syariah container (`ContentAddressed`, `Token`,
    // `SyariahCompliant`, `SmartContract`, `Supervisor`, `CRDT`, `Actor`) and
    // `RawPtr` silently laundered a secret past the check. Adding a `Ty`
    // variant must fail the build here rather than open a new leak path.
    match ty {
        Ty::Secret(inner) => join(Some(SecurityLevel::Secret), ty_secrecy_level(inner)),
        Ty::Labeled(inner, l) => {
            let here = (*l != SecurityLevel::Public).then_some(*l);
            join(here, ty_secrecy_level(inner))
        }
        // A secure channel's own level is part of its secrecy, not just its
        // payload's.
        Ty::SecureChan(_, l) => (*l != SecurityLevel::Public).then_some(*l),

        // Two-component containers: a secret in EITHER position is a secret.
        Ty::Prod(a, b) | Ty::Sum(a, b) | Ty::Actor(a, b) | Ty::CRDT(a, b) => {
            join(ty_secrecy_level(a), ty_secrecy_level(b))
        }

        // Single-component containers: secrecy travels with the payload.
        Ty::List(inner)
        | Ty::Option(inner)
        | Ty::Tainted(inner, _)
        | Ty::Sanitized(inner, _)
        | Ty::Ref(inner, _)
        | Ty::ConstantTime(inner)
        | Ty::Zeroizing(inner)
        | Ty::Proof(inner)
        | Ty::RawPtr(inner)
        | Ty::ContentAddressed(inner)
        | Ty::Supervisor(inner)
        | Ty::SmartContract(inner)
        | Ty::Token(inner)
        | Ty::SyariahCompliant(inner) => ty_secrecy_level(inner),

        // A function is NOT secret because it can return a secret: printing a
        // function value renders the closure, it does not evaluate the body, so
        // no secret is materialised at the sink. The secret is caught at the
        // call site instead, where the result type is what reaches the sink.
        // Deliberate, and now explicit rather than a wildcard's side effect.
        Ty::Fn(_, _, _) => None,

        // `Chan` carries a session type, not a value type — its payload
        // secrecy is enforced by the session/IFC rules, not by this scan.
        Ty::Chan(_) | Ty::Choreography(_, _) => None,

        // Ground types and capability/FFI/UI handles hold no payload.
        Ty::Unit
        | Ty::Bool
        | Ty::Int
        | Ty::IntN { .. }
        | Ty::BigInt
        | Ty::Decimal
        | Ty::Fixed
        | Ty::FixedBin
        | Ty::String
        | Ty::Bytes
        | Ty::Capability(_)
        | Ty::CapabilityFull(_)
        | Ty::Any
        | Ty::CChar
        | Ty::CInt
        | Ty::CVoid
        | Ty::Color
        | Ty::Element
        | Ty::Layout
        | Ty::UIStyle
        | Ty::AccessibleText => None,
    }
}

/// REQ-27 (laundering fix, 2026-06-12): builtins with `Any`-typed positions
/// are opaque to unification, so a secret routed through a pure
/// data-transforming builtin came out unlabeled and walked straight past
/// `secrecy_at_sink` — `cetak(ke_teks(pin))` and
/// `cetak(senarai_tolak((l, pin)))` type-checked while `cetak(pin)` was
/// rejected. These conversions/containers cannot remove secrecy, only move it,
/// so their result must re-carry the argument's level — the same label-join
/// discipline the Coq development applies through elimination forms
/// (Declassification.v: only `T_Declassify` with `declass_ok` lowers a label).
fn is_secrecy_propagating_builtin(name: &str) -> bool {
    const EXACT: &[&str] = &[
        "ke_teks",
        "to_string",
        "ke_bool",
        "to_bool",
        "gabung_teks",
        "nilai_kiri",
        "nilai_kanan",
        "adalah_kiri",
        "adalah_kanan",
    ];
    const PREFIXES: &[&str] = &[
        "str_", "teks_", "list_", "senarai_", "map_", "peta_", "set_", "json_",
    ];
    EXACT.contains(&name) || PREFIXES.iter().any(|p| name.starts_with(p))
}

/// If `callee` is a secrecy-propagating builtin and the argument carries an
/// above-`Public` level, the result type re-carries that level (top joins to
/// `Secret<_>`, intermediate levels to `Labeled(_, l)`). No-op when the result
/// already carries at least that level, and for user functions (their bodies
/// are checked directly; only opaque builtins need the conservative join).
fn propagate_secrecy_through_builtin(callee: &Expr, arg_ty: &Ty, ret_ty: Ty) -> Ty {
    let Expr::Var(name) = callee else {
        return ret_ty;
    };
    if !is_secrecy_propagating_builtin(name) {
        return ret_ty;
    }
    let Some(level) = ty_secrecy_level(arg_ty) else {
        return ret_ty;
    };
    if matches!(ty_secrecy_level(&ret_ty), Some(existing) if level.leq(existing)) {
        return ret_ty;
    }
    if level == SecurityLevel::Secret {
        Ty::Secret(Box::new(ret_ty))
    } else {
        Ty::Labeled(Box::new(ret_ty), level)
    }
}

/// Check if two types are compatible, considering:
/// - Ty::Any as a wildcard
/// - Tainted cannot flow to Sanitized (taint violation)
/// - Sanitized must match exact sanitizer (sanitizer mismatch)
/// - Sanitized can flow to plain type (safe subtyping)
pub fn types_compatible(expected: &Ty, found: &Ty) -> bool {
    // Wildcard — Any matches anything
    if *expected == Ty::Any || *found == Ty::Any {
        return true;
    }

    // Exact match
    if expected == found {
        return true;
    }

    // Sized integers interoperate with the default `Int` (numeric-tower slice):
    // a plain integer literal may initialize a sized binding, and a sized value
    // may be used where `Int` is expected. Same-width/signedness is the exact
    // match above; differing sized types stay incompatible. Width-aware
    // narrowing/overflow checking is a later numeric-tower phase.
    if matches!(
        (expected, found),
        (Ty::Int, Ty::IntN { .. }) | (Ty::IntN { .. }, Ty::Int)
    ) {
        return true;
    }

    // ════════════════════════════════════════════════════════════════════
    // DOMAIN SECURITY: Taint Checking
    // ════════════════════════════════════════════════════════════════════

    // REJECT: Tainted → Sanitized (TAINT VIOLATION)
    // User input cannot flow to sensitive sink without sanitization
    if let (Ty::Sanitized(_, _), Ty::Tainted(_, _)) = (expected, found) {
        return false; // Will trigger TypeError::TypeMismatch → needs better error
    }

    // SANITIZER EXACT MATCH: Sanitized<T, S1> requires Sanitized<T, S2> where S1 == S2
    // SQL sink requires SqlParam sanitizer, not HtmlEscape
    if let (Ty::Sanitized(inner1, san1), Ty::Sanitized(inner2, san2)) = (expected, found) {
        return san1 == san2 && types_compatible(inner1, inner2);
    }

    // SAFE SUBTYPING: Sanitized → Plain Type
    // Sanitized data can be used as plain string (sanitization removes taint)
    match (expected, found) {
        (Ty::String, Ty::Sanitized(inner, _)) if **inner == Ty::String => {
            return true;
        }
        (Ty::Int, Ty::Sanitized(inner, _)) if **inner == Ty::Int => {
            return true;
        }
        _ => {}
    }

    // TAINT SOURCE COMPATIBILITY: Any Tainted matches expected Tainted
    // Sanitizers accept any tainted data, regardless of source
    // Tainted<String, NetworkExternal> matches Tainted<String, UserInput>
    if let (Ty::Tainted(inner1, _), Ty::Tainted(inner2, _)) = (expected, found) {
        return types_compatible(inner1, inner2);
    }

    // ════════════════════════════════════════════════════════════════════
    // Structural Recursion
    // ════════════════════════════════════════════════════════════════════

    match (expected, found) {
        // Function types: contravariant in argument, covariant in return
        (Ty::Fn(a1, r1, e1), Ty::Fn(a2, r2, e2)) => {
            // Effect subsumption: a function whose body has a *smaller* effect
            // (`e2`, found) satisfies a declaration of a *wider* effect (`e1`,
            // expected) — you may always declare more effect than you use (e.g. a
            // `kesan Baca` stub whose body is actually Pure). Argument/return
            // types must be compatible as before.
            //
            // "Smaller" is the category-respecting PARTIAL order: every latent
            // component of `e2` must be covered by `e1` (M1c). The old
            // `e2.level() <= e1.level()` let a `Masa`-typed slot hold a
            // file-writing closure because FileSystem (5) < Time (11).
            types_compatible(a1, a2) && types_compatible(r1, r2) && e1.covers_all(*e2)
        }

        // Product types: covariant in both components
        (Ty::Prod(l1, r1), Ty::Prod(l2, r2)) => {
            types_compatible(l1, l2) && types_compatible(r1, r2)
        }

        // Sum types: covariant in both branches
        (Ty::Sum(l1, r1), Ty::Sum(l2, r2)) => types_compatible(l1, l2) && types_compatible(r1, r2),

        // List types: covariant in element
        (Ty::List(t1), Ty::List(t2)) => types_compatible(t1, t2),

        // Option types: covariant in element
        (Ty::Option(t1), Ty::Option(t2)) => types_compatible(t1, t2),

        // Option <-> Sum: `Option<T>` is structurally `Sum(T, _)`. The Option/
        // Result constructors (`Ada`/`Ok`/...) desugar to `Inl`/`Inr` producing a
        // `Sum`, which must unify with a declared `Mungkin<T>` (Option) return
        // type. The left arm must match the element; the right arm is unconstrained
        // (the None/Tiada payload is unused).
        (Ty::Option(t1), Ty::Sum(l2, _)) | (Ty::Sum(l2, _), Ty::Option(t1)) => {
            types_compatible(t1, l2)
        }

        // Reference types: covariant in inner type, must match security level
        (Ty::Ref(t1, sl1), Ty::Ref(t2, sl2)) => sl1 == sl2 && types_compatible(t1, t2),

        // Secret types: covariant in inner type
        (Ty::Secret(t1), Ty::Secret(t2)) => types_compatible(t1, t2),

        // Labeled types: covariant in inner type, must match security level
        (Ty::Labeled(t1, sl1), Ty::Labeled(t2, sl2)) => sl1 == sl2 && types_compatible(t1, t2),

        // JALINAN / J6 structural types
        (Ty::Actor(s1, m1), Ty::Actor(s2, m2)) => {
            types_compatible(s1, s2) && types_compatible(m1, m2)
        }
        (Ty::ContentAddressed(t1), Ty::ContentAddressed(t2))
        | (Ty::Supervisor(t1), Ty::Supervisor(t2))
        | (Ty::SmartContract(t1), Ty::SmartContract(t2))
        | (Ty::Token(t1), Ty::Token(t2))
        | (Ty::SyariahCompliant(t1), Ty::SyariahCompliant(t2)) => types_compatible(t1, t2),
        (Ty::CRDT(v1, op1), Ty::CRDT(v2, op2)) => {
            types_compatible(v1, v2) && types_compatible(op1, op2)
        }
        (Ty::Choreography(roles1, proto1), Ty::Choreography(roles2, proto2)) => {
            roles1 == roles2 && proto1 == proto2
        }

        // No match
        _ => false,
    }
}

// ============================================================================
// FORMALIZED TYPE CHECKING (Coq-matching)
// ============================================================================

/// Validate declassification predicate: declass_ok e1 e2
///
/// Matches Coq definition in Syntax.v:519-520:
/// ```coq
/// Definition declass_ok (e1 e2 : expr) : Prop :=
///   exists v, value v /\ e1 = EClassify v /\ e2 = EProve (EClassify v).
/// ```
///
/// This ensures that declassification is only valid when:
/// 1. e1 is exactly EClassify v for some value v
/// 2. e2 is exactly EProve (EClassify v) — a proof wrapping the same secret
fn declass_ok(secret_expr: &Expr, proof_expr: &Expr) -> Result<(), TypeError> {
    // e1 must be Classify(v)
    let inner_val = match secret_expr {
        Expr::Classify(v) => v,
        _ => {
            return Err(TypeError::InvalidDeclassification {
                message: "Secret expression must be EClassify(v)".to_string(),
            });
        }
    };

    // e2 must be Prove(Classify(v')) where v' == v
    match proof_expr {
        Expr::Prove(inner_proof) => match inner_proof.as_ref() {
            Expr::Classify(v_prime) => {
                if **inner_val != **v_prime {
                    return Err(TypeError::InvalidDeclassification {
                        message: "Proof must wrap the same value as secret".to_string(),
                    });
                }
                Ok(())
            }
            _ => Err(TypeError::InvalidDeclassification {
                message: "Proof must be EProve(EClassify(v))".to_string(),
            }),
        },
        _ => Err(TypeError::InvalidDeclassification {
            message: "Proof expression must be EProve(...)".to_string(),
        }),
    }
}

/// Strip security labels from a type to get the underlying data type.
/// Used by BinOp and If to work with Labeled values transparently.
fn strip_label(ty: &Ty) -> (&Ty, SecurityLevel) {
    match ty {
        Ty::Labeled(inner, sl) => (inner.as_ref(), *sl),
        Ty::Secret(inner) => (inner.as_ref(), SecurityLevel::Secret),
        _ => (ty, SecurityLevel::Public),
    }
}

/// Strip a ConstantTime wrapper, returning (inner_type, was_ct).
/// Used by BinOp to propagate constant-time discipline through arithmetic.
fn strip_constant_time(ty: &Ty) -> (&Ty, bool) {
    match ty {
        Ty::ConstantTime(inner) => (inner.as_ref(), true),
        _ => (ty, false),
    }
}

/// Result type of integer arithmetic over two operand types (numeric tower).
///
/// A sized operand (`Ty::IntN`) makes the result that same sized type, so the
/// width propagates through `+`/`-`/`*`/`/`/`%` and the codegen/interpreter can
/// wrap at the declared width. A plain `Int` literal adapts to the sized operand
/// (`x: u8 + 1` is `u8`). Two sized operands must agree on width **and**
/// signedness — `u8 + u16` is rejected (returns `None`), unlike the looser
/// `Int`↔`IntN` initialiser compatibility, because silent width mixing would
/// lose bits. Returns `None` when either operand is not an integer.
fn int_arith_result(a: &Ty, b: &Ty) -> Option<Ty> {
    match (a, b) {
        (
            Ty::IntN {
                bits: b1,
                signed: s1,
            },
            Ty::IntN {
                bits: b2,
                signed: s2,
            },
        ) => (b1 == b2 && s1 == s2).then_some(Ty::IntN {
            bits: *b1,
            signed: *s1,
        }),
        (Ty::IntN { bits, signed }, Ty::Int) | (Ty::Int, Ty::IntN { bits, signed }) => {
            Some(Ty::IntN {
                bits: *bits,
                signed: *signed,
            })
        }
        (Ty::Int, Ty::Int) => Some(Ty::Int),
        // Arbitrary-precision integers form their own arithmetic domain; they do
        // not mix with fixed-width ints (convert explicitly via `besar`).
        (Ty::BigInt, Ty::BigInt) => Some(Ty::BigInt),
        // Decimals likewise form their own domain.
        (Ty::Decimal, Ty::Decimal) => Some(Ty::Decimal),
        // Fixed-scale decimals (`wang`/`titik_tetap`) form their own domain too.
        (Ty::Fixed, Ty::Fixed) => Some(Ty::Fixed),
        // Binary fixed-point (`qmn`) likewise.
        (Ty::FixedBin, Ty::FixedBin) => Some(Ty::FixedBin),
        _ => None,
    }
}

/// True when both operands are sized integers (`Ty::IntN`) but disagree on width
/// or signedness (e.g. `u8` and `u16`). Such a mix is rejected by arithmetic to
/// avoid silently dropping bits; a sized type mixed with a plain `Int` is fine.
fn mixed_int_width(a: &Ty, b: &Ty) -> bool {
    matches!(
        (a, b),
        (
            Ty::IntN { bits: b1, signed: s1 },
            Ty::IntN { bits: b2, signed: s2 },
        ) if b1 != b2 || s1 != s2
    )
}

// ============================================================================
// SESSION TYPE HELPERS (JALINAN Phase 6)
// ============================================================================

/// Compute the dual of a session type.
/// Send ↔ Recv, Select ↔ Branch, End ↔ End, Rec/Var preserved.
pub fn session_dual(s: &SessionType) -> SessionType {
    match s {
        SessionType::End => SessionType::End,
        SessionType::Send(ty, cont) => SessionType::Recv(ty.clone(), Box::new(session_dual(cont))),
        SessionType::Recv(ty, cont) => SessionType::Send(ty.clone(), Box::new(session_dual(cont))),
        SessionType::Select(l, r) => {
            SessionType::Branch(Box::new(session_dual(l)), Box::new(session_dual(r)))
        }
        SessionType::Branch(l, r) => {
            SessionType::Select(Box::new(session_dual(l)), Box::new(session_dual(r)))
        }
        SessionType::Rec(x, body) => SessionType::Rec(x.clone(), Box::new(session_dual(body))),
        SessionType::Var(x) => SessionType::Var(x.clone()),
    }
}

/// Check if two session types are dual to each other.
pub fn is_dual(s1: &SessionType, s2: &SessionType) -> bool {
    session_dual(s1) == *s2
}

/// A session type is well-formed (closed) when every recursion `Var` is bound by
/// an enclosing `Rec`. A free session variable makes duality/projection
/// meaningless, so the choreography checker rejects it.
pub fn session_well_formed(s: &SessionType) -> bool {
    fn go(s: &SessionType, bound: &mut Vec<Ident>) -> bool {
        match s {
            SessionType::End => true,
            SessionType::Send(_, k) | SessionType::Recv(_, k) => go(k, bound),
            SessionType::Select(a, b) | SessionType::Branch(a, b) => {
                go(a, bound) && go(b, bound)
            }
            SessionType::Rec(x, body) => {
                bound.push(x.clone());
                let r = go(body, bound);
                bound.pop();
                r
            }
            SessionType::Var(x) => bound.iter().any(|b| b == x),
        }
    }
    go(s, &mut Vec::new())
}

/// Project a choreography's global protocol onto one role's local session type.
///
/// The parser writes the stored `protocol` from the *first* role's perspective
/// (role-relative: `A -> B : T` becomes `Send T` when `A` is `roles[0]` and
/// `Recv T` when `B` is `roles[0]`). For a two-party choreography the first
/// role's local type is therefore the protocol itself and the second role's is
/// its dual — this is the binary-session specialisation of the Coq
/// `project` fixpoint (`ChoreographyTypes.v`), and the projected endpoints are
/// dual by construction (cf. `CT_103_projection_preserves_duality`).
///
/// Returns `None` for a role not in `roles`, or for choreographies with more
/// than two roles (a binary `SessionType` cannot express an N-party local type;
/// full multiparty projection is tracked as future work).
pub fn project_choreography(
    roles: &[Ident],
    protocol: &SessionType,
    role: &str,
) -> Option<SessionType> {
    let idx = roles.iter().position(|r| r == role)?;
    if roles.len() != 2 {
        return None;
    }
    match idx {
        0 => Some(protocol.clone()),
        1 => Some(session_dual(protocol)),
        _ => None,
    }
}

/// Verify that a choreography's roles and protocol compose safely: roles are
/// distinct (≥2) and the protocol is closed, and — for the two-party case —
/// projecting onto each role yields dual (compatible) local types, which
/// guarantees deadlock-free composition (Coq `ST_020_dual_communicate` /
/// `CT_117_choreography_deadlock_free`). Returns a human-readable reason on
/// failure. Three-or-more-party protocols are accepted structurally
/// (well-formed + distinct roles) but not yet projected (binary session types
/// cannot express the per-role views — see `project_choreography`).
pub fn choreography_compatible(roles: &[Ident], protocol: &SessionType) -> Result<(), String> {
    if roles.len() < 2 {
        return Err("a choreography requires at least 2 roles".to_string());
    }
    for (i, r) in roles.iter().enumerate() {
        if roles[i + 1..].iter().any(|o| o == r) {
            return Err(format!("duplicate role '{r}' in choreography"));
        }
    }
    if !session_well_formed(protocol) {
        return Err("protocol has a free (unbound) session variable".to_string());
    }
    if roles.len() == 2 {
        let p0 = project_choreography(roles, protocol, &roles[0])
            .expect("two-role projection is total for index 0");
        let p1 = project_choreography(roles, protocol, &roles[1])
            .expect("two-role projection is total for index 1");
        if !is_dual(&p0, &p1) {
            return Err(format!(
                "projected endpoints for roles '{}' and '{}' are not dual",
                roles[0], roles[1]
            ));
        }
    }
    Ok(())
}

/// Session type subtyping.
/// - Send: covariant in payload, covariant in continuation
/// - Recv: contravariant in payload, covariant in continuation
/// - Select/Branch: covariant in both branches
pub fn session_subtype(sub: &SessionType, sup: &SessionType) -> bool {
    match (sub, sup) {
        (SessionType::End, SessionType::End) => true,
        (SessionType::Send(t1, c1), SessionType::Send(t2, c2)) => {
            types_compatible(t1, t2) && session_subtype(c1, c2)
        }
        (SessionType::Recv(t1, c1), SessionType::Recv(t2, c2)) => {
            // Contravariant in payload: sup's payload must be subtype of sub's
            types_compatible(t2, t1) && session_subtype(c1, c2)
        }
        (SessionType::Select(l1, r1), SessionType::Select(l2, r2)) => {
            session_subtype(l1, l2) && session_subtype(r1, r2)
        }
        (SessionType::Branch(l1, r1), SessionType::Branch(l2, r2)) => {
            session_subtype(l1, l2) && session_subtype(r1, r2)
        }
        (SessionType::Rec(x1, b1), SessionType::Rec(x2, b2)) => x1 == x2 && session_subtype(b1, b2),
        (SessionType::Var(x1), SessionType::Var(x2)) => x1 == x2,
        _ => false,
    }
}

/// Full typechecker with Coq-matching signature.
///
/// Implements `has_type Γ Σ Δ e T ε` from Typing.v.
///
/// # Arguments
/// * `ctx` - Typing context containing Γ (type env), Σ (store typing), Δ (security level)
/// * `expr` - Expression to typecheck
///
/// # Returns
/// * `Ok((T, ε))` - Type and effect of the expression
/// * `Err(TypeError)` - Type error
///
/// # Coq Reference
/// ```coq
/// Inductive has_type : type_env -> store_ty -> security_level ->
///                       expr -> ty -> effect -> Prop
/// ```
pub fn type_check_full(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    match expr {
        // ════════════════════════════════════════════════════════════════════
        // VERIFIED: Values (T_Unit, T_Bool, T_Int, T_String, T_Var)
        // ════════════════════════════════════════════════════════════════════
        Expr::Unit => Ok((Ty::Unit, EffectSet::PURE)),
        Expr::Bool(_) => Ok((Ty::Bool, EffectSet::PURE)),
        Expr::Int(_) => Ok((Ty::Int, EffectSet::PURE)),
        // Sized integer literal `42u8` types as the distinct `Ty::IntN`, not the
        // default `Ty::Int` (numeric tower).
        Expr::IntN { bits, signed, .. } => Ok((
            Ty::IntN {
                bits: *bits,
                signed: *signed,
            },
            EffectSet::PURE,
        )),
        Expr::String(_) => Ok((Ty::String, EffectSet::PURE)),

        // List literal `[e1, e2, ...]`: every element must share a type; the
        // result is `List<elem>`. An empty `[]` is `List<Any>`. The effect is
        // the join of the element effects.
        Expr::ListLit(..) => tc_list_lit(ctx, expr),

        // Record literal — structural, no nominal type yet, so the result type
        // is `Any`. Every field is viewed as `Any`, so what the fields carry is
        // erased (H1): the record re-carries the join of the fields' labels,
        // taint and CT tags (`Kotak { isi: sulit 1234 }` is secret, and
        // `Kotak { q: read_line(()) }` is tainted), and the latent effect of a
        // stored closure is charged here (H4) — whoever reads the field may
        // call it.
        Expr::RecordLit(..) => tc_record_lit(ctx, expr),

        // Field access — the base is checked (for effects); the field type is
        // `Any` (records are structural with no field-type table yet). The
        // field re-carries whatever the base record carries (H1).
        Expr::FieldAccess(base, _field) => {
            let (t, eff) = type_check_full(ctx, base)?;
            Ok((rewrap(Ty::Any, &latent_info(&t).data()), eff))
        }

        // T_Var: Γ(x) = T → has_type Γ Σ Δ (EVar x) T EffectPure
        Expr::Var(..) => tc_var(ctx, expr),

        // ════════════════════════════════════════════════════════════════════
        // VERIFIED: Functions (T_Lam, T_App)
        // ════════════════════════════════════════════════════════════════════

        // T_Lam: has_type (Γ, x:T1) Σ Δ e T2 ε → has_type Γ Σ Δ (λx:T1.e) (T1 →[ε] T2) Pure
        //
        // Two compiler-level refinements (no Coq counterpart: Coq has neither
        // mutable slots nor linear closures in `has_type`):
        //   * H2 — a body that writes a mutable slot it did not bind (a
        //     captured or global `biar ubah`) has an effect observable by its
        //     caller, so the closure's latent effect is at least `Mut`; that
        //     makes `check_call_secrecy` reject calling it under a secret pc.
        //   * M2 — a linear/affine variable captured by the body is consumed by
        //     the closure; unless the closure is itself bound linearly it may
        //     be called many times (or never), so the capture is rejected.
        Expr::Lam(..) => tc_lam(ctx, expr),

        // T_App: has_type Γ Σ Δ e1 (T1 →[ε'] T2) ε1 →
        //        has_type Γ Σ Δ e2 T1 ε2 →
        //        has_type Γ Σ Δ (e1 e2) T2 (ε1 ⊔ ε2 ⊔ ε')
        Expr::App(..) => tc_app(ctx, expr),

        // ════════════════════════════════════════════════════════════════════
        // VERIFIED: Products (T_Pair, T_Fst, T_Snd)
        // ════════════════════════════════════════════════════════════════════
        Expr::Pair(e1, e2) => {
            let (t1, eff1) = type_check_full(ctx, e1)?;
            let (t2, eff2) = type_check_full(ctx, e2)?;
            Ok((Ty::Prod(Box::new(t1), Box::new(t2)), eff1.join(eff2)))
        }
        // A projection out of a labeled/tainted/CT pair keeps the wrapper.
        Expr::Fst(..) => tc_fst(ctx, expr),
        Expr::Snd(e) => {
            let (t, eff) = type_check_full(ctx, e)?;
            let (core, wrap) = peel(&t);
            match core {
                Ty::Prod(_, t2) => Ok((rewrap((**t2).clone(), &wrap), eff)),
                Ty::Any => Ok((rewrap(Ty::Any, &wrap), eff)),
                _ => Err(TypeError::ExpectedProduct(t)),
            }
        }

        // ════════════════════════════════════════════════════════════════════
        // VERIFIED: Sums (T_Inl, T_Inr, T_Case)
        // ════════════════════════════════════════════════════════════════════
        Expr::Inl(e, ty) => match ty {
            Ty::Sum(t1, t2) => {
                let (te, eff) = type_check_full(ctx, e)?;
                if te != **t1 {
                    return Err(TypeError::TypeMismatch {
                        expected: *t1.clone(),
                        found: te,
                    });
                }
                Ok((Ty::Sum(t1.clone(), t2.clone()), eff))
            }
            // Unannotated injection (from `Some(x)`/`Ok(x)` desugaring, carrying
            // `Ty::Any`): infer the left arm from the payload; right arm open.
            Ty::Any => {
                let (te, eff) = type_check_full(ctx, e)?;
                Ok((Ty::Sum(Box::new(te), Box::new(Ty::Any)), eff))
            }
            _ => Err(TypeError::ExpectedSum(ty.clone())),
        },
        Expr::Inr(e, ty) => match ty {
            Ty::Sum(t1, t2) => {
                let (te, eff) = type_check_full(ctx, e)?;
                if te != **t2 {
                    return Err(TypeError::TypeMismatch {
                        expected: *t2.clone(),
                        found: te,
                    });
                }
                Ok((Ty::Sum(t1.clone(), t2.clone()), eff))
            }
            // Unannotated injection (from `Err(x)`/`None` desugaring): infer the
            // right arm from the payload; left arm open.
            Ty::Any => {
                let (te, eff) = type_check_full(ctx, e)?;
                Ok((Ty::Sum(Box::new(Ty::Any), Box::new(te)), eff))
            }
            _ => Err(TypeError::ExpectedSum(ty.clone())),
        },
        // REQ-12: IFC-aware case analysis — elevate Δ in branches
        Expr::Case(..) => tc_case(ctx, expr),

        // ════════════════════════════════════════════════════════════════════
        // FORMALIZED: Control (T_If, T_Let, T_LetRec)
        // REQ-12: IFC-aware branching — elevate Δ in branch bodies
        // ════════════════════════════════════════════════════════════════════
        Expr::If(..) => tc_if(ctx, expr),
        // ── Loops and mutable locals (compiler-level; no Coq counterpart yet) ──
        //
        // T_While: Γ ⊢ cond : Bool, ε₁ →  Γ ⊢ body : _, ε₂ →
        //          Γ ⊢ (while cond body) : Unit, ε₁ ⊔ ε₂
        //
        // The body's own type is discarded (a loop body is evaluated for its
        // effects), and the loop itself always yields `()`. Effects are the join
        // of both — a body that prints makes the loop `Tulis`, once, however many
        // times it runs.
        //
        // IFC (H2): a `putus`/`teruskan`/`pulang` under a secret pc makes the
        // rest of the body AND every later iteration secret-dependent, so the
        // loop is re-checked at the raised pc until the raise is stable (the
        // lattice is finite, so this terminates; normally in one pass).
        //
        // Linearity (M2): the body may run many times (or never), so consuming
        // an outer linear/affine variable inside it is rejected.
        Expr::While(..) => tc_while(ctx, expr),
        // `putus` / `lanjut` never yield to their evaluation context, so — like
        // `pulang` — they take type `Any` and unify with any sibling branch type.
        // The parser has already rejected them outside a loop. Under a secret
        // pc they make the rest of the loop secret-dependent (H2).
        Expr::Break | Expr::Continue => {
            let pc = ctx.pc();
            if let Some(raise) = ctx.loop_raises.last() {
                raise.set(raise.get().join(pc));
            }
            Ok((Ty::Any, EffectSet::PURE))
        }

        // T_LetMut: Γ ⊢ e₁ : T, ε₁ →  Γ, x:Ref(T,Awam) ⊢ e₂ : U, ε₂ →
        //           Γ ⊢ (biar ubah x = e₁; e₂) : U, ε₁ ⊔ ε₂
        //
        // NOTE the absent `⊔ EffectWrite`: unlike T_Ref/T_Deref/T_Assign (which
        // mirror Coq `Typing.v` and must not be weakened), a slot is not first
        // class. `SlotGet`/`SlotSet` name a binder directly, so the cell can
        // never be aliased, returned or stored — reading and writing it is
        // unobservable outside the binding, the standard encapsulated-state
        // argument. A local counter therefore stays `kesan Bersih`. The
        // exception is a CLOSURE writing a slot bound outside it: that write is
        // visible to whoever calls the closure, so the closure's latent effect
        // is `Mut` (see T_Lam, H2).
        Expr::LetMut(x, e1, e2) => {
            let (t1, eff1) = type_check_full(ctx, e1)?;
            let mut inner = ctx.extend_gamma(x.clone(), Ty::Ref(Box::new(t1), SecurityLevel::Public));
            let id = fresh_slot_id();
            inner.slot_ids.insert(x.clone(), id);
            inner.fn_slot_ids.insert(id);
            let (t2, eff2) = type_check_full(&mut inner, e2)?;
            Ok((t2, eff1.join(eff2)))
        }
        Expr::SlotGet(..) => tc_slot_get(ctx, expr),
        Expr::SlotSet(..) => tc_slot_set(ctx, expr),
        Expr::Let(..) => tc_let(ctx, expr),
        // `pulang e` — early return. Its operand is type-checked (and its effect
        // propagated), but the return expression itself never yields to its
        // evaluation context, so it has type `Any` (unifies with any sibling
        // branch/sequence type via `types_compatible`). Under a secret pc the
        // returned value is labeled, and the REST of the function — and of any
        // enclosing loop — becomes secret-dependent (H2).
        Expr::Return(..) => tc_return(ctx, expr),
        Expr::LetRec(..) => tc_let_rec(ctx, expr),

        // Mutually-recursive group (REQ-44 forward references): all group names
        // are in scope in every body AND the continuation. Every BODY is granted
        // exactly its own declared effect set (the same grants as the
        // authoritative per-function check in validate_top_level_decls), and
        // its latent effects must be covered by that set. The CONTINUATION
        // (top-level code) is granted nothing from the group (M1a): a
        // function's declaration authorizes its own body, not the program.
        // Recursion soundness is mechanized in foundations/RecursionSafety.v.
        Expr::LetRecGroup(..) => tc_let_rec_group(ctx, expr),

        // ════════════════════════════════════════════════════════════════════
        // FORMALIZED: Effects (T_Perform, T_Handle)
        // ════════════════════════════════════════════════════════════════════
        Expr::Perform(eff, e) => {
            let (te, eff_e) = type_check_full(ctx, e)?;
            Ok((te, eff_e.join(*eff)))
        }
        Expr::Handle(e, x, h) => {
            let (t_e, eff_e) = type_check_full(ctx, e)?;
            // Coq T_Handle (Typing.v:172-175): handler binds x : T in h
            let mut h_ctx = ctx.extend_gamma(x.clone(), t_e);
            let (t_h, eff_h) = type_check_full(&mut h_ctx, h)?;
            // Coq: result effect is effect_join ε1 ε2
            Ok((t_h, eff_e.join(eff_h)))
        }

        // ════════════════════════════════════════════════════════════════════
        // FORMALIZED: References (T_Ref, T_Deref, T_Assign)
        // Matches Coq Typing.v:178-189
        // ════════════════════════════════════════════════════════════════════

        // T_Ref: has_type Γ Σ Δ e T ε →
        //        has_type Γ Σ Δ (ERef e l) (TRef T l) (ε ⊔ EffectWrite)
        Expr::Ref(e, sl) => {
            let (t, eff) = type_check_full(ctx, e)?;
            // Allocate in store typing Σ
            let _loc = ctx.alloc(t.clone(), *sl);
            Ok((Ty::Ref(Box::new(t), *sl), eff.join(Effect::Write)))
        }

        // T_Deref: has_type Γ Σ Δ e (TRef T l) ε →
        //          l ⊑ Δ →  (* SECURITY CHECK! *)
        //          has_type Γ Σ Δ (EDeref e) T (ε ⊔ EffectRead)
        Expr::Deref(..) => tc_deref(ctx, expr),

        // T_Assign: has_type Γ Σ Δ e1 (TRef T l) ε1 →
        //           has_type Γ Σ Δ e2 T ε2 →
        //           Δ ⊑ l →  (* NO-WRITE-DOWN: Bell-LaPadula *-property *)
        //           has_type Γ Σ Δ (EAssign e1 e2) TUnit (ε1 ⊔ ε2 ⊔ EffectWrite)
        //
        // IFC enforcement (REQ-12): The security context Δ must flow to the
        // reference level l. This prevents implicit information flows where
        // a branch guarded by secret data writes to a public reference.
        // Combined with T_Deref (l ⊑ Δ, no-read-up), this gives Bell-LaPadula.
        //
        // H3: Coq types the assigned value at EXACTLY the cell type `T`, so a
        // `TSecret T` value cannot be stored in a `TRef T l` cell at all. The
        // prototype accepts a labeled value (it strips the label to compare
        // the data type), so it must instead require the value's own level to
        // flow to the cell: level(value) ⊔ pc ⊑ l ⊔ level(T). Without this,
        // `r := sulit 42` on an `@ Awam` cell was accepted and `cetak(!r)`
        // printed the secret (only a runtime guard caught it).
        Expr::Assign(..) => tc_assign(ctx, expr),

        // ════════════════════════════════════════════════════════════════════
        // FORMALIZED: Security (T_Classify, T_Declassify, T_Prove)
        // Matches Coq Typing.v:192-204
        // ════════════════════════════════════════════════════════════════════

        // T_Classify: has_type Γ Σ Δ e T ε →
        //             has_type Γ Σ Δ (EClassify e) (TSecret T) ε
        Expr::Classify(e) => {
            let (t, eff) = type_check_full(ctx, e)?;
            Ok((Ty::Secret(Box::new(t)), eff))
        }

        // T_Declassify: has_type Γ Σ Δ e1 (TSecret T) ε1 →
        //               has_type Γ Σ Δ e2 (TProof (TSecret T)) ε2 →
        //               declass_ok e1 e2 →
        //               has_type Γ Σ Δ (EDeclassify e1 e2) T (ε1 ⊔ ε2)
        Expr::Declassify(..) => tc_declassify(ctx, expr),

        // T_Prove: has_type Γ Σ Δ e T ε →
        //          has_type Γ Σ Δ (EProve e) (TProof T) ε
        Expr::Prove(e) => {
            let (t, eff) = type_check_full(ctx, e)?;
            Ok((Ty::Proof(Box::new(t)), eff))
        }

        // ════════════════════════════════════════════════════════════════════
        // FORMALIZED: Capabilities (T_Require, T_Grant)
        // ════════════════════════════════════════════════════════════════════
        Expr::Require(..) => tc_require(ctx, expr),
        // T_Grant: typecheck body with eff added to granted set.
        //
        // M1b — grants may ATTENUATE, never AMPLIFY. Coq T_Grant is
        // unrestricted, and so was this arm: any function could `beri` itself
        // Network/Process/... and pass the capability gate. Now:
        //   * in TOP-LEVEL code (`grant_ceiling == None`) `beri` is the
        //     program's explicit capability manifest and stays unrestricted;
        //   * inside ANY function body — top-level `fungsi`, local `fungsi` or
        //     closure — `beri X` is accepted only if X is covered (effect
        //     partial order, `EffectSet::covers`) by what the body already held
        //     on entry (`enter_function`): a top-level function holds its
        //     declared `kesan` set; a closure or local `fungsi` holds exactly
        //     its lexically enclosing grants (a local function's own `kesan`
        //     bounds its latent effect but grants nothing — see T_LetRec), so
        //     neither is a route to amplification.
        // A permitted grant is covered by the ceiling, so it never raises it.
        Expr::Grant(eff, e) => {
            if let Some(held) = ctx.grant_ceiling {
                if !held.covers(*eff) {
                    return Err(TypeError::CapabilityViolation {
                        required: *eff,
                        message: format!(
                            "'beri {eff:?}' inside a function body may only narrow the \
                             capabilities the function already holds ({held:?}), never add one; \
                             declare {eff:?} in the function's 'kesan' instead (its callers \
                             then need it too)"
                        ),
                    });
                }
            }
            let mut grant_ctx = ctx.with_grant(*eff);
            let (t, e_eff) = type_check_full(&mut grant_ctx, e)?;
            Ok((t, e_eff))
        }

        // ════════════════════════════════════════════════════════════════════
        // T_Loc: Store locations — requires Σ lookup
        // ════════════════════════════════════════════════════════════════════
        Expr::Loc(idx) => {
            let loc = Location::new(*idx as usize);
            match ctx.lookup_loc(&loc) {
                Some((ty, sl)) => Ok((Ty::Ref(Box::new(ty.clone()), *sl), EffectSet::PURE)),
                None => Err(TypeError::LocationNotFound(loc)),
            }
        }

        // ════════════════════════════════════════════════════════════════════
        // FFI and Binary Operations
        // ════════════════════════════════════════════════════════════════════
        Expr::FFICall {
            name: _,
            args,
            ret_ty,
        } => {
            let mut eff = EffectSet::from(Effect::System);
            for arg in args {
                let (_t, e) = type_check_full(ctx, arg)?;
                eff = eff.join(e);
            }
            Ok((ret_ty.clone(), eff))
        }

        Expr::BinOp(..) => tc_bin_op(ctx, expr),

        // ════════════════════════════════════════════════════════════════════
        // JALINAN Phase 6: Session Types, Actors, Choreography, CRDTs
        // ════════════════════════════════════════════════════════════════════
        Expr::ActorDecl { .. } => tc_actor_decl(ctx, expr),

        Expr::ChoreographyBlock { .. } => tc_choreography_block(expr),

        Expr::Spawn(..) => tc_spawn(ctx, expr),

        Expr::ActorSend(..) => tc_actor_send(ctx, expr),

        Expr::ActorRecv(actor_expr) => {
            let (actor_ty, eff) = type_check_full(ctx, actor_expr)?;
            match &actor_ty {
                Ty::Actor(_, msg_ty) => Ok((*msg_ty.clone(), eff.join(Effect::Network))),
                _ => Err(TypeError::ExpectedActor(actor_ty)),
            }
        }

        Expr::CRDTMerge(..) => tc_crdt_merge(ctx, expr),

        Expr::ContentHash(expr) => {
            let (inner_ty, eff) = type_check_full(ctx, expr)?;
            Ok((
                Ty::ContentAddressed(Box::new(inner_ty)),
                eff.join(Effect::Crypto),
            ))
        }

        Expr::ContentVerify(..) => tc_content_verify(ctx, expr),

        Expr::ContractDeploy(contract) => {
            let (inner_ty, eff) = type_check_full(ctx, contract)?;
            Ok((
                Ty::SmartContract(Box::new(inner_ty)),
                eff.join(Effect::NetworkSecure),
            ))
        }

        Expr::TokenTransfer { .. } => tc_token_transfer(ctx, expr),

        Expr::ZakatCalculate(..) => tc_zakat_calculate(ctx, expr),

        // ════════════════════════════════════════════════════════════════════
        // CAHAYA Phase J5: UI Primitives
        // ════════════════════════════════════════════════════════════════════
        Expr::UIDisplay(elems) | Expr::UIRow(elems) | Expr::UIColumn(elems) => {
            let mut eff = EffectSet::PURE;
            for e in elems {
                let (_, e_eff) = type_check_full(ctx, e)?;
                eff = eff.join(e_eff);
            }
            Ok((Ty::Element, eff))
        }

        Expr::UIText(..) => tc_ui_text(ctx, expr),

        Expr::UIButton(label, handler) => {
            let (_, eff1) = type_check_full(ctx, label)?;
            let (_, eff2) = type_check_full(ctx, handler)?;
            Ok((Ty::Element, eff1.join(eff2)))
        }

        Expr::UIColor(_, _, _) => Ok((Ty::Color, EffectSet::PURE)),

        Expr::UIStyleDecl { .. } => Ok((Ty::UIStyle, EffectSet::PURE)),

        Expr::UIContrastCheck(..) => tc_ui_contrast_check(ctx, expr),
    }
}

// ── Typing rules split out of `type_check_full` ─────────────────────────────
//
// Each helper is one arm of `type_check_full`, moved verbatim. They are kept
// out of line so a recursion level only pays the stack frame of the rule
// actually being applied (a debug build otherwise reserves the locals of
// EVERY arm in each `type_check_full` frame, ~100 KiB, which overflowed the
// fuzz harness's 4 MiB worker stack on legal, parser-bounded nesting).

#[inline(never)]
fn tc_list_lit(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::ListLit(elems) = expr else {
        unreachable!("tc_list_lit is only called for Expr::ListLit")
    };
    let mut elem_ty = Ty::Any;
    let mut eff = EffectSet::PURE;
    for (i, e) in elems.iter().enumerate() {
        let (t, ef) = type_check_full(ctx, e)?;
        eff = eff.join(ef);
        if i == 0 {
            elem_ty = t;
        } else if elem_ty != Ty::Any && t != Ty::Any && t != elem_ty {
            return Err(TypeError::TypeMismatch {
                expected: elem_ty.clone(),
                found: t,
            });
        } else {
            // H1: an `Any` element (e.g. `senarai_baru(())`) must not
            // hide a later element's label — `[senarai_baru(()), pin]`
            // was a `List<Any>` that `cetak` accepted. Join so the
            // element type keeps the most concrete type and every label.
            elem_ty = join_branch_types(elem_ty, t);
        }
    }
    Ok((Ty::List(Box::new(elem_ty)), eff))
}

#[inline(never)]
fn tc_record_lit(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::RecordLit(_name, fields) = expr else {
        unreachable!("tc_record_lit is only called for Expr::RecordLit")
    };
    let mut eff = EffectSet::PURE;
    let mut info = Latent::NONE;
    for (_f, e) in fields {
        let (t, ef) = type_check_full(ctx, e)?;
        eff = eff.join(ef);
        info = info.join(latent_info(&t));
    }
    charge_erased_effect(ctx, info.effect, ctx.pc())?;
    Ok((rewrap(Ty::Any, &info.data()), eff.join(info.effect)))
}

#[inline(never)]
fn tc_var(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Var(x) = expr else {
        unreachable!("tc_var is only called for Expr::Var")
    };
    if let Some(ty) = internal_primitive_type(x) {
        return Ok((ty, EffectSet::PURE));
    }
    let ty = ctx
        .lookup_var(x)
        .cloned()
        .ok_or_else(|| TypeError::VarNotFound(x.clone()))?;
    // M2: a closure that captured a linear variable is itself used
    // linearly and may only be APPLIED (see the App rule); any other
    // use could copy it and so consume the capture twice.
    if ctx.gamma.is_call_only(x) {
        let usage = ctx.gamma.get_linearity(x).map_or(Usage::Zero, |(_, u)| u);
        return Err(TypeError::LinearityViolation {
            var: x.clone(),
            linearity: ctx.gamma.get_linearity(x).map_or(Linearity::Linear, |(l, _)| l),
            usage,
            message: "a closure that captures a linear/affine variable may only be \
                      called directly, not copied, stored or passed on"
                .to_string(),
        });
    }
    // A3: Record usage for linearity tracking.
    // Linear/Affine variables error on second use.
    ctx.gamma.record_use(x)?;
    Ok((ty, EffectSet::PURE))
}

#[inline(never)]
fn tc_lam(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Lam(x, t1, body) = expr else {
        unreachable!("tc_lam is only called for Expr::Lam")
    };
    let closure_lin = ctx.closure_linearity.take();
    let outer_linear = ctx.gamma.linear_snapshot();
    let mut new_ctx_mut = ctx.extend_gamma(x.clone(), t1.clone());
    new_ctx_mut.enter_function();
    let (t2, eff) = type_check_full(&mut new_ctx_mut, body)?;
    let t2 = label_at_level(t2, new_ctx_mut.fn_raise.get());
    let t2 = function_result_type(t2, &new_ctx_mut.return_types.borrow())?;
    for snap in outer_linear.iter().filter(|s| s.changed()) {
        match (snap.lin, closure_lin) {
            (_, Some(Linearity::Linear)) | (Linearity::Affine, Some(Linearity::Affine)) => {}
            (Linearity::Relevant, _) => snap.restore(),
            (Linearity::Linear, Some(Linearity::Affine)) => {
                return Err(linearity_error(
                    snap,
                    snap.now(),
                    "captured by an affine closure, which may never be called",
                ));
            }
            _ => {
                return Err(linearity_error(
                    snap,
                    Usage::Many,
                    "captured by a closure that may be called more than once \
                     (bind the closure itself with `biar sekali` to call it once)",
                ));
            }
        }
    }
    // `eff` already contains `Mut` for every call to a function value
    // whose slot writes could not be attributed; such a closure's own
    // writes are then unknown too.
    let mut writes = new_ctx_mut.outer_writes.borrow().clone();
    writes.unknown |= eff == Effect::Mut;
    let eff = if writes.is_empty() { eff } else { eff.join(Effect::Mut) };
    ctx.last_closure_writes = Some(Rc::new(writes));
    Ok((
        Ty::Fn(Box::new(t1.clone()), Box::new(t2), eff),
        EffectSet::PURE,
    ))
}

#[inline(never)]
fn tc_app(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::App(e1, e2) = expr else {
        unreachable!("tc_app is only called for Expr::App")
    };
    // M2: a call-only closure (it captured a linear variable) is
    // consumed by being applied — the one use it is allowed.
    let (t1, eff1) = match &**e1 {
        Expr::Var(f) if ctx.gamma.is_call_only(f) => {
            let ty = ctx
                .lookup_var(f)
                .cloned()
                .ok_or_else(|| TypeError::VarNotFound(f.clone()))?;
            ctx.gamma.record_use(f)?;
            (ty, EffectSet::PURE)
        }
        _ => type_check_full(ctx, e1)?,
    };
    let (t2, eff2) = type_check_full(ctx, e2)?;
    // A callee value chosen by secret data (e.g. a branch returning one
    // of two closures, or a field of a secret record) runs under that
    // secrecy: its effects are an implicit flow and its result is
    // labeled.
    let (callee_core, callee_wrap) = peel(&t1);
    let call_pc = ctx.pc().join(callee_wrap.level);

    match callee_core.clone() {
        Ty::Fn(arg_ty, ret_ty, fn_eff) => {
            // IFC (REQ-27): secret/labeled data may not reach a public
            // print/network/file-write sink without declassification.
            // Checked before unification so it wins over a generic
            // TypeMismatch (e.g. Secret vs the concrete file-write arg).
            if let Some(err) = secrecy_at_sink(e1, &t2) {
                return Err(err);
            }
            // Crypto-agility (REQ-48): reject selecting a deprecated
            // algorithm. Coq: crypto/AlgorithmPolicy.v `accepts`.
            if let Some(err) = deprecated_algorithm_at_selection(e1, e2) {
                return Err(err);
            }
            // M3: no constant-time value as an index / lookup key.
            if let Some(err) = ct_index_violation(e1, &t2) {
                return Err(err);
            }
            if !types_compatible(&arg_ty, &t2) {
                return Err(sink_argument_error(*arg_ty, t2));
            }
            // Gate C (hybrid POLA): once a program opts into the
            // capability discipline (granted set non-empty), a
            // reach-extending Network/Process operation requires the
            // matching capability granted in scope. Mirrors the opt-in
            // `T_Require` rule; a function declaring `kesan Rangkaian`/
            // `kesan Proses` auto-grants it in its body.
            //
            // The gated set covers the reach-extending effects
            // (Network/Process) and the secret/entropy/OS effects
            // (Crypto/Random/System). This is now *sound* for compound
            // declarations: a function declaring `kesan (Kripto, Tulis,
            // Rawak)` grants every component (via `effect_set` on the
            // function decl), so a legitimate compound-effect function
            // (e.g. `crypto_ops.rii`) is no longer a false positive. File
            // I/O and Time stay at effect+taint typing (not capability-gated);
            // since M1c that effect typing is the category-respecting partial
            // order, so a declaration of another category no longer covers
            // them.
            //
            // M1a: at TOP LEVEL (`gate_always`) a call to a declared
            // top-level function is authorized by that function's own
            // declaration (its body is checked against exactly it);
            // every other gated operation needs an explicit grant.
            //
            // M1c: EVERY gated component of the latent set is checked
            // (the old lattice value gated `(Rangkaian, Kripto)` only on
            // `Kripto`, its join).
            let declared_callee = ctx.gate_always
                && matches!(&**e1, Expr::Var(f) if ctx.declared_fns.contains(f));
            if !declared_callee {
                if let Some(missing) = ctx.missing_gated_capability(fn_eff) {
                    return Err(TypeError::CapabilityViolation {
                        required: missing,
                        message: format!(
                            "{missing:?} operation requires a granted {missing:?} capability in scope"
                        ),
                    });
                }
            }
            // H1/H4/M3: what the argument loses by being viewed at the
            // parameter type (an `Any` position). Parser-generated
            // iteration primitives preserve the element type exactly
            // (`internal_primitive_result`), so nothing is erased there.
            let internal = matches!(&**e1, Expr::Var(f) if internal_primitive_type(f).is_some());
            let hidden = if internal { Latent::NONE } else { erased_info(&arg_ty, &t2) };
            // H4: a function value erased into an `Any` parameter may be
            // called by the callee — charge its latent effect here (the
            // pc part is the observable-flow check just below).
            charge_erased_effect(ctx, hidden.effect, SecurityLevel::Public)?;
            let call_eff = fn_eff.join(hidden.effect);
            let total_eff = eff1
                .join(eff2)
                .join(attribute_slot_writes(ctx, e1, fn_eff))
                .join(hidden.effect);
            // An effectful call whose argument erased a secret, or that
            // runs under a secret pc (including a secret-chosen callee
            // and secret-dependent `pulang`/`putus` earlier), is an
            // observable flow. A slot-writing closure is `Mut` (H2).
            let observable_level = call_pc.join(hidden.level);
            if !call_eff.is_pure() && observable_level != SecurityLevel::Public {
                return Err(TypeError::SecurityViolation {
                    found: observable_level,
                    expected: SecurityLevel::Public,
                    context: "effectful call (including aliases)",
                });
            }
            let ret_ty = internal_primitive_result(e1, &t2, *ret_ty)?;
            // The result re-carries what the argument erased and what
            // the callee value itself carried. Taint only matters where
            // the result can reach an `Any`-accepting sink.
            let mut carried = hidden.data().join(callee_wrap);
            if !ty_contains_any(&ret_ty) {
                carried.taint = None;
            }
            let ret_ty = rewrap(ret_ty, &carried);
            // REQ-27: a pure data-transforming builtin re-carries its
            // argument's secrecy (laundering fix — see
            // propagate_secrecy_through_builtin).
            let ret_ty = propagate_secrecy_through_builtin(e1, &t2, ret_ty);
            Ok((ret_ty, total_eff))
        }
        // Applying an `Any`-typed callee (e.g. a closure passed as an
        // `Any` parameter, or a higher-order builtin result) yields `Any`.
        // Its effects were charged where the function value was erased
        // into `Any` (H4) — but WHEN it runs is decided here, so it may
        // not be called under a secret pc (H2), and the result re-carries
        // whatever the argument and the callee value carry.
        Ty::Any => {
            if call_pc != SecurityLevel::Public {
                return Err(TypeError::SecurityViolation {
                    found: call_pc,
                    expected: SecurityLevel::Public,
                    context: "call of an untyped (Any) function value under a secret pc \
                              (its effects are unknown)",
                });
            }
            let arg_info = latent_info(&t2);
            charge_erased_effect(ctx, arg_info.effect, call_pc)?;
            let carried = arg_info.data().join(callee_wrap);
            Ok((
                rewrap(Ty::Any, &carried),
                eff1.join(eff2).join(arg_info.effect),
            ))
        }
        _ => Err(TypeError::ExpectedFunction(t1)),
    }
}

#[inline(never)]
fn tc_fst(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Fst(e) = expr else {
        unreachable!("tc_fst is only called for Expr::Fst")
    };
    let (t, eff) = type_check_full(ctx, e)?;
    let (core, wrap) = peel(&t);
    match core {
        Ty::Prod(t1, _) => Ok((rewrap((**t1).clone(), &wrap), eff)),
        // Projecting a component of an `Any`-typed value (e.g. a closure
        // parameter bound from a `untuk (a, b)` destructure) yields `Any`.
        Ty::Any => Ok((rewrap(Ty::Any, &wrap), eff)),
        _ => Err(TypeError::ExpectedProduct(t)),
    }
}

#[inline(never)]
fn tc_case(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Case(e, x, e1, y, e2) = expr else {
        unreachable!("tc_case is only called for Expr::Case")
    };
    let (t, eff) = type_check_full(ctx, e)?;
    // A labeled / tainted / CT scrutinee is matched on its core type;
    // its label raises the pc of both arms, and the arm binders keep
    // every wrapper.
    let (core, wrap) = peel(&t);
    // A2/M3: matching on a ConstantTime value branches on it.
    if wrap.ct {
        return Err(TypeError::ConstantTimeViolation {
            context: "match scrutinee",
        });
    }
    // Normalize the scrutinee to a (left, right) pair of branch-binder
    // types. `Sum` is the native form; `Option<T>` is `(T, Unit)` (Ada
    // carries T, Tidak carries Unit); `Any` binds both as `Any`.
    let sum_arms: Option<(Ty, Ty)> = match core {
        Ty::Sum(l, r) => Some(((**l).clone(), (**r).clone())),
        Ty::Option(inner) => Some(((**inner).clone(), Ty::Unit)),
        Ty::Any => Some((Ty::Any, Ty::Any)),
        _ => None,
    };
    match sum_arms {
        Some((t_left, t_right)) => {
            let branch_delta = ctx.pc().join(wrap.level);
            let linear = ctx.gamma.linear_snapshot();

            let mut ctx1 = ctx.extend_gamma(x.clone(), rewrap(t_left, &wrap));
            ctx1.delta = branch_delta;
            let (t1, eff1) = type_check_full(&mut ctx1, e1)?;
            let then_usage: Vec<Usage> = linear.iter().map(LinearSnap::now).collect();
            linear.iter().for_each(LinearSnap::restore);

            let mut ctx2 = ctx.extend_gamma(y.clone(), rewrap(t_right, &wrap));
            ctx2.delta = branch_delta;
            let (t2, eff2) = type_check_full(&mut ctx2, e2)?;
            merge_branch_usage(&linear, &then_usage)?;

            // Branch result types must agree. `Any` (from unannotated
            // Option/Result payloads, e.g. a `padan` arm that returns the
            // bound payload) unifies with the concrete branch type; the
            // result is the more concrete of the two.
            if !types_compatible(&t1, &t2) {
                return Err(TypeError::TypeMismatch {
                    expected: t1,
                    found: t2,
                });
            }
            let result_ty = label_at_level(join_branch_types(t1, t2), branch_delta);

            Ok((result_ty, eff.join(eff1).join(eff2)))
        }
        None => Err(TypeError::ExpectedSum(t)),
    }
}

#[inline(never)]
fn tc_if(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::If(cond, e2, e3) = expr else {
        unreachable!("tc_if is only called for Expr::If")
    };
    let (t_cond, eff1) = type_check_full(ctx, cond)?;

    // IFC: Accept both Bool and Labeled(Bool, level) as condition.
    // Strip label to check inner type is Bool, but preserve the
    // security level for branch elevation.
    let (inner_cond, cond_wrap) = peel(&t_cond);
    let cond_label_level = cond_wrap.level;

    // A2: ConstantTime enforcement — reject CT values as branch conditions.
    // Branching on a ConstantTime value creates a timing side-channel
    // because the branch taken reveals information about the value.
    // `peel` sees the tag under any label/taint wrapper, including one
    // re-attached to an `Any` result (M3: `kalau id(a == 0)`).
    if cond_wrap.ct {
        return Err(TypeError::ConstantTimeViolation {
            context: "branch condition",
        });
    }

    // The condition must be Bool; `Any` (the wildcard, e.g. from a method
    // call or indexing that the structural checker types as Any) is also
    // accepted.
    if *inner_cond != Ty::Bool && *inner_cond != Ty::Any {
        return Err(TypeError::TypeMismatch {
            expected: Ty::Bool,
            found: inner_cond.clone(),
        });
    }

    // IFC: Elevate Δ in branches based on condition's security level.
    // If the condition was derived from high-security data (e.g.,
    // comparing a secret-labeled value), the branches must execute at
    // that elevated security level to prevent implicit flows through
    // control structure.
    //
    // Before this fix, cond_level was always Public because t_cond
    // was always Ty::Bool. Now Deref propagates labels and BinOp
    // preserves them, so a comparison of secret data produces
    // Labeled(Bool, Secret), and cond_label_level = Secret.
    let cond_level = cond_label_level;
    let branch_delta = ctx.pc().join(cond_level);
    let linear = ctx.gamma.linear_snapshot();

    let mut branch_ctx = ctx.clone();
    branch_ctx.delta = branch_delta;
    let (t2, eff2) = type_check_full(&mut branch_ctx, e2)?;
    // M2: only one branch runs — reconcile linear usage across both.
    let then_usage: Vec<Usage> = linear.iter().map(LinearSnap::now).collect();
    linear.iter().for_each(LinearSnap::restore);

    let mut branch_ctx2 = ctx.clone();
    branch_ctx2.delta = branch_delta;
    let (t3, eff3) = type_check_full(&mut branch_ctx2, e3)?;
    merge_branch_usage(&linear, &then_usage)?;

    // Branch types must agree; `Any` (e.g. from a `padan` arm returning
    // an unannotated Option/Result payload) unifies with the concrete
    // branch type. The result is the more concrete of the two.
    if !types_compatible(&t2, &t3) {
        return Err(TypeError::TypeMismatch {
            expected: t2,
            found: t3,
        });
    }
    let result_ty = label_at_level(join_branch_types(t2, t3), branch_delta);

    Ok((result_ty, eff1.join(eff2).join(eff3)))
}

#[inline(never)]
fn tc_while(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::While(cond, body) = expr else {
        unreachable!("tc_while is only called for Expr::While")
    };
    let linear = ctx.gamma.linear_snapshot();
    let raise = Rc::new(Cell::new(SecurityLevel::Public));
    let mut loop_pc = ctx.pc();
    loop {
        linear.iter().for_each(LinearSnap::restore);
        let mut loop_ctx = ctx.clone();
        loop_ctx.delta = loop_pc;
        loop_ctx.loop_raises.push(raise.clone());
        let (t_cond, eff_cond) = type_check_full(&mut loop_ctx, cond)?;
        let (inner_cond, cond_wrap) = peel(&t_cond);
        if cond_wrap.ct {
            return Err(TypeError::ConstantTimeViolation {
                context: "loop condition",
            });
        }
        if !matches!(inner_cond, Ty::Bool | Ty::Any) {
            return Err(TypeError::TypeMismatch {
                expected: Ty::Bool,
                found: t_cond,
            });
        }
        let mut body_ctx = loop_ctx.clone();
        body_ctx.delta = loop_pc.join(cond_wrap.level);
        let (_t_body, eff_body) = type_check_full(&mut body_ctx, body)?;
        reject_repeatable_use(&linear, "used inside a loop body, which may run more than once")?;
        if raise.get().leq(loop_pc) {
            return Ok((Ty::Unit, eff_cond.join(eff_body)));
        }
        loop_pc = loop_pc.join(raise.get());
    }
}

#[inline(never)]
fn tc_slot_get(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::SlotGet(x) = expr else {
        unreachable!("tc_slot_get is only called for Expr::SlotGet")
    };
    let ty = ctx
        .lookup_var(x)
        .cloned()
        .ok_or_else(|| TypeError::VarNotFound(x.clone()))?;
    match ty {
        Ty::Ref(inner, _) => Ok((*inner, EffectSet::PURE)),
        other => Ok((other, EffectSet::PURE)),
    }
}

#[inline(never)]
fn tc_slot_set(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::SlotSet(x, e) = expr else {
        unreachable!("tc_slot_set is only called for Expr::SlotSet")
    };
    let (t_val, eff) = type_check_full(ctx, e)?;
    let slot_ty = ctx
        .lookup_var(x)
        .cloned()
        .ok_or_else(|| TypeError::VarNotFound(x.clone()))?;
    // H2: writing a slot this function/closure did not bind is a side
    // effect its caller can observe.
    match ctx.slot_ids.get(x) {
        Some(id) if ctx.fn_slot_ids.contains(id) => {}
        Some(id) => {
            ctx.outer_writes.borrow_mut().ids.insert(*id);
        }
        None => ctx.outer_writes.borrow_mut().unknown = true,
    }
    if let Ty::Ref(inner, slot_level) = slot_ty {
        // What an `Any`-typed slot would forget about the value (H1/H4).
        let hidden = erased_info(&inner, &t_val);
        let level = ctx
            .pc()
            .join(ty_secrecy_level(&t_val).unwrap_or(SecurityLevel::Public))
            .join(hidden.level);
        let target = slot_level.join(ty_secrecy_level(&inner).unwrap_or(SecurityLevel::Public));
        if !level.leq(target) {
            return Err(TypeError::SecurityViolation { found: level, expected: target,
                context: "mutable local assignment" });
        }
        reject_erased_into_cell(&inner, &t_val, &hidden)?;
        charge_erased_effect(ctx, hidden.effect, ctx.pc())?;
        let (assigned, _) = strip_label(&t_val);
        let (expected, _) = strip_label(&inner);
        if !types_compatible(expected, assigned) {
            return Err(TypeError::TypeMismatch {
                expected: *inner,
                found: assigned.clone(),
            });
        }
        return Ok((Ty::Unit, eff.join(hidden.effect)));
    }
    Ok((Ty::Unit, eff))
}

#[inline(never)]
fn tc_let(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Let(x, linearity, e1, e2) = expr else {
        unreachable!("tc_let is only called for Expr::Let")
    };
    // M2: a lambda bound DIRECTLY by `biar sekali`/`biar paling` is
    // itself used at most once, so it may capture linear variables —
    // and is then call-only (see Var/App).
    let closure_lin = match (linearity, &**e1) {
        (Some(lin @ (Linearity::Linear | Linearity::Affine)), Expr::Lam(..)) => Some(*lin),
        _ => None,
    };
    let outer_linear = ctx.gamma.linear_snapshot();
    let saved = std::mem::replace(&mut ctx.closure_linearity, closure_lin);
    ctx.last_closure_writes = None;
    let checked = type_check_full(ctx, e1);
    ctx.closure_linearity = saved;
    let (t1, eff1) = checked?;
    let lambda_writes = match &**e1 {
        Expr::Lam(..) => ctx.last_closure_writes.take(),
        _ => None,
    };
    let captured_linear = closure_lin.is_some()
        && outer_linear.iter().any(|s| {
            matches!(s.lin, Linearity::Linear | Linearity::Affine) && s.changed()
        });
    let new_ctx = match linearity {
        Some(lin) => {
            let mut c = ctx.extend_gamma_linear(x.clone(), t1.clone(), *lin);
            c.gamma = ctx.gamma.extend_tracked(x.clone(), t1, *lin, captured_linear);
            c
        }
        None => ctx.extend_gamma(x.clone(), t1),
    };
    let mut new_ctx_mut = new_ctx;
    if let Some(writes) = lambda_writes {
        new_ctx_mut.closure_writes.insert(x.clone(), writes);
    }
    let (t2, eff2) = type_check_full(&mut new_ctx_mut, e2)?;
    // A3: Check linearity constraints at scope exit.
    // Linear variables must have been used exactly once; Relevant at least once.
    new_ctx_mut.gamma.check_linearity_at_exit(x)?;
    Ok((t2, eff1.join(eff2)))
}

#[inline(never)]
fn tc_return(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Return(e) = expr else {
        unreachable!("tc_return is only called for Expr::Return")
    };
    let (t, eff) = type_check_full(ctx, e)?;
    let pc = ctx.pc();
    ctx.return_types.borrow_mut().push(label_at_level(t, pc));
    ctx.fn_raise.set(ctx.fn_raise.get().join(pc));
    for raise in &ctx.loop_raises {
        raise.set(raise.get().join(pc));
    }
    Ok((Ty::Any, eff))
}

#[inline(never)]
fn tc_let_rec(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::LetRec(x, ty_ann, e1, e2) = expr else {
        unreachable!("tc_let_rec is only called for Expr::LetRec")
    };
    let ctx_rec = ctx.extend_gamma(x.clone(), ty_ann.clone());
    // A LOCAL `fungsi` is a named, recursive closure: its body holds exactly
    // the capabilities of its lexically enclosing scope, like any lambda
    // (M1b). Its `kesan` declaration is an UPPER BOUND on its latent effect
    // (checked below), not a grant. It used to grant its declared effect to
    // its own body (with the gate otherwise off), so `fungsi g() kesan
    // Rangkaian { .. }` inside a `kesan Bersih` function, or in top-level
    // code with no `beri`, could open sockets; and at top level a call to it
    // was then authorized "by its own declaration" (`declared_fns`), which is
    // only sound for TOP-LEVEL functions, whose bodies are checked against
    // their declaration alone. Neither grant leaks into the continuation
    // (M1a).
    let mut ctx_rec_mut = ctx_rec.clone();
    ctx_rec_mut.last_closure_writes = None;
    let (t1, eff1) = type_check_full(&mut ctx_rec_mut, e1)?;
    declared_latent_check(ty_ann, &t1)?;
    if !types_compatible(ty_ann, &t1) {
        return Err(TypeError::AnnotationMismatch {
            expected: ty_ann.clone(),
            found: t1,
        });
    }
    erased_function_check(ty_ann, &t1)?;
    let mut ctx_rec_mut2 = ctx_rec;
    if let (Expr::Lam(..), Some(writes)) = (&**e1, ctx_rec_mut.last_closure_writes.take()) {
        ctx_rec_mut2.closure_writes.insert(x.clone(), writes);
    }
    let (t2, eff2) = type_check_full(&mut ctx_rec_mut2, e2)?;
    Ok((t2, eff1.join(eff2)))
}

#[inline(never)]
fn tc_let_rec_group(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::LetRecGroup(bindings, cont) = expr else {
        unreachable!("tc_let_rec_group is only called for Expr::LetRecGroup")
    };
    let mut ctx_rec = ctx.clone();
    for (name, ty_ann, _) in bindings {
        ctx_rec = ctx_rec.extend_gamma(name.clone(), ty_ann.clone());
    }
    let mut body_ctx = ctx_rec.clone();
    body_ctx.gate_always = false;
    let mut eff = EffectSet::PURE;
    for (_, ty_ann, e1) in bindings {
        // Each body holds exactly ITS OWN declared effect set (every
        // component — the latent type is a set now, so nothing is lost). The
        // group used to grant every body the union of all the group's
        // declarations, to compensate for the lossy single-effect latent
        // type; that over-grant is gone. This re-check now agrees with the
        // authoritative per-function check in `validate_top_level_decls`.
        let mut c = match ty_ann {
            Ty::Fn(_, _, fn_eff) => body_ctx.with_declared_grants(*fn_eff),
            _ => body_ctx.clone(),
        };
        let (t1, eff1) = type_check_full(&mut c, e1)?;
        declared_latent_check(ty_ann, &t1)?;
        if !types_compatible(ty_ann, &t1) {
            return Err(TypeError::AnnotationMismatch {
                expected: ty_ann.clone(),
                found: t1,
            });
        }
        erased_function_check(ty_ann, &t1)?;
        eff = eff.join(eff1);
    }
    let mut c2 = ctx_rec;
    for (name, _, _) in bindings {
        c2.declared_fns.insert(name.clone());
    }
    let (t2, eff2) = type_check_full(&mut c2, cont)?;
    Ok((t2, eff.join(eff2)))
}

#[inline(never)]
fn tc_deref(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Deref(e) = expr else {
        unreachable!("tc_deref is only called for Expr::Deref")
    };
    let (t, eff) = type_check_full(ctx, e)?;
    match t {
        Ty::Ref(inner, sl) => {
            // Security check: sl ⊑ Δ (reference level flows to context level)
            let pc = ctx.pc();
            if !sl.leq(pc) {
                return Err(TypeError::SecurityViolation {
                    found: sl,
                    expected: pc,
                    context: "dereference",
                });
            }
            // IFC: Propagate security label to the result value.
            // Dereferencing a Secret-level reference produces a Labeled value,
            // so downstream expressions (BinOp, If) can track the data's origin.
            // This is essential for implicit flow prevention: if we compare a
            // secret-derived value and branch on the result, the branch delta
            // must be elevated.
            let result_ty = if sl != SecurityLevel::Public {
                Ty::Labeled(inner, sl)
            } else {
                *inner
            };
            Ok((result_ty, eff.join(Effect::Read)))
        }
        // `!` is overloaded: on a Bool it is logical negation (the corpus
        // writes `!cond`); `Any` (unknown) is likewise treated as boolean.
        Ty::Bool => Ok((Ty::Bool, eff)),
        Ty::Any => Ok((Ty::Any, eff)),
        _ => Err(TypeError::ExpectedRef(t)),
    }
}

#[inline(never)]
fn tc_assign(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Assign(e1, e2) = expr else {
        unreachable!("tc_assign is only called for Expr::Assign")
    };
    let (t1, eff1) = type_check_full(ctx, e1)?;
    let (t2, eff2) = type_check_full(ctx, e2)?;
    match t1 {
        Ty::Ref(inner, sl) => {
            // IFC check: Δ ⊑ sl (no-write-down)
            // Program counter security level must flow to reference level.
            // Prevents: secret-context code writing to public references.
            let pc = ctx.pc();
            if !pc.leq(sl) {
                return Err(TypeError::ImplicitFlowViolation {
                    branch_level: pc,
                    target_level: sl,
                    context: "assignment",
                });
            }
            // Explicit flow: the value's own label (including anything
            // an `Any`-typed cell would forget) must flow to the cell.
            let hidden = erased_info(&inner, &t2);
            let value_level = ty_secrecy_level(&t2)
                .unwrap_or(SecurityLevel::Public)
                .join(hidden.level);
            let target = sl.join(ty_secrecy_level(&inner).unwrap_or(SecurityLevel::Public));
            if !value_level.join(pc).leq(target) {
                return Err(TypeError::SecurityViolation {
                    found: value_level.join(pc),
                    expected: target,
                    context: "assignment",
                });
            }
            reject_erased_into_cell(&inner, &t2, &hidden)?;
            charge_erased_effect(ctx, hidden.effect, pc)?;
            // Strip labels from assigned value for type compatibility.
            // A Labeled(Int, Secret) value is assignable to Ref(Int, Secret).
            let (inner_t2, _) = strip_label(&t2);
            if *inner != *inner_t2 {
                return Err(TypeError::TypeMismatch {
                    expected: *inner,
                    found: inner_t2.clone(),
                });
            }
            Ok((Ty::Unit, eff1.join(eff2).join(Effect::Write).join(hidden.effect)))
        }
        _ => Err(TypeError::ExpectedRef(t1)),
    }
}

#[inline(never)]
fn tc_declassify(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Declassify(e, proof) = expr else {
        unreachable!("tc_declassify is only called for Expr::Declassify")
    };
    let (t, eff1) = type_check_full(ctx, e)?;
    let (proof_ty, eff2) = type_check_full(ctx, proof)?;

    match &t {
        Ty::Secret(inner) => {
            // Check proof type: must be TProof(TSecret(T))
            let expected_proof_ty = Ty::Proof(Box::new(t.clone()));
            if proof_ty != expected_proof_ty {
                return Err(TypeError::TypeMismatch {
                    expected: expected_proof_ty,
                    found: proof_ty,
                });
            }

            // Validate declass_ok predicate
            declass_ok(e, proof)?;

            Ok((*inner.clone(), eff1.join(eff2)))
        }
        _ => {
            // Strict mode: matches Coq T_Declassify (Typing.v:198-202)
            // Coq rule requires e1 : TSecret(T) — no alternative case
            Err(TypeError::ExpectedSecret(t))
        }
    }
}

#[inline(never)]
fn tc_require(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Require(eff, e) = expr else {
        unreachable!("tc_require is only called for Expr::Require")
    };
    // T_Require: if granted set is populated, enforce capability check.
    // Program-level validate_capabilities provides the authoritative check;
    // type-level enforcement is an additional guard when grant context is available.
    if ctx.capability_missing(*eff) {
        return Err(TypeError::CapabilityViolation {
            required: *eff,
            message: format!("effect {:?} required but not granted in current scope", eff),
        });
    }
    let (t, e_eff) = type_check_full(ctx, e)?;
    Ok((t, e_eff.join(*eff)))
}

#[inline(never)]
fn tc_bin_op(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::BinOp(op, e1, e2) = expr else {
        unreachable!("tc_bin_op is only called for Expr::BinOp")
    };
    let (t1, eff1) = type_check_full(ctx, e1)?;
    let (t2, eff2) = type_check_full(ctx, e2)?;
    let eff = eff1.join(eff2);

    // IFC: Strip security labels for type checking, but track the
    // maximum security level of operands. The result inherits this level.
    // This ensures that comparing secret-derived values produces a
    // Labeled(Bool, Secret) result, which triggers branch elevation in If.
    let (inner1, sl1) = strip_label(&t1);
    let (inner2, sl2) = strip_label(&t2);
    let max_sl = sl1.join(sl2);

    // A2: Strip ConstantTime wrappers for type checking, but propagate
    // the CT tag through arithmetic/comparison so CT values can't silently
    // escape the constant-time discipline via BinOp.
    let (inner1, ct1) = strip_constant_time(inner1);
    let (inner2, ct2) = strip_constant_time(inner2);
    let any_ct = ct1 || ct2;

    // Helper: wrap result type with security label and/or CT tag
    let label_result = |ty: Ty| -> Ty {
        let ty = if any_ct {
            Ty::ConstantTime(Box::new(ty))
        } else {
            ty
        };
        if max_sl != SecurityLevel::Public {
            Ty::Labeled(Box::new(ty), max_sl)
        } else {
            ty
        }
    };

    match op {
        BinOp::Add => {
            // `+` is overloaded for Int (addition) and String
            // (concatenation). If either operand is `Any` (its concrete
            // type unknown, e.g. a list element from `senarai_dapat`), the
            // result type is also `Any` rather than eagerly committing to
            // String — which would wrongly reject an Int at use sites.
            if *inner1 == Ty::Any || *inner2 == Ty::Any {
                Ok((label_result(Ty::Any), eff))
            } else if *inner1 == Ty::String && *inner2 == Ty::String {
                Ok((label_result(Ty::String), eff))
            } else if *inner1 == Ty::BigInt && *inner2 == Ty::BigInt {
                Ok((label_result(Ty::BigInt), eff))
            } else if *inner1 == Ty::Decimal && *inner2 == Ty::Decimal {
                Ok((label_result(Ty::Decimal), eff))
            } else if *inner1 == Ty::Fixed && *inner2 == Ty::Fixed {
                Ok((label_result(Ty::Fixed), eff))
            } else if *inner1 == Ty::FixedBin && *inner2 == Ty::FixedBin {
                Ok((label_result(Ty::FixedBin), eff))
            } else if types_compatible(&Ty::Int, inner1)
                && types_compatible(&Ty::Int, inner2)
            {
                // Numeric tower: a sized operand propagates its width to the
                // result; a plain `Int` literal adapts. Two sized operands of
                // different width/signedness are rejected (silent bit loss).
                if mixed_int_width(inner1, inner2) {
                    return Err(TypeError::TypeMismatch {
                        expected: inner1.clone(),
                        found: inner2.clone(),
                    });
                }
                Ok((
                    label_result(int_arith_result(inner1, inner2).unwrap_or(Ty::Int)),
                    eff,
                ))
            } else if types_compatible(&Ty::String, inner1)
                && types_compatible(&Ty::String, inner2)
            {
                Ok((label_result(Ty::String), eff))
            } else if let (Ty::List(e1), Ty::List(e2)) = (inner1, inner2) {
                // `+` also concatenates lists (`[x] + akum`). The element
                // types must be compatible; the result keeps the more
                // concrete element type.
                if types_compatible(e1, e2) {
                    Ok((label_result(Ty::List(Box::new(join_branch_types(
                        (**e1).clone(),
                        (**e2).clone(),
                    )))), eff))
                } else {
                    Err(TypeError::TypeMismatch {
                        expected: inner1.clone(),
                        found: inner2.clone(),
                    })
                }
            } else {
                Err(TypeError::TypeMismatch {
                    expected: inner1.clone(),
                    found: inner2.clone(),
                })
            }
        }
        BinOp::Sub | BinOp::Mul | BinOp::Div | BinOp::Mod => {
            // A2: integer division and modulo have data-dependent latency
            // on real ISAs, so a ConstantTime operand would leak through
            // timing exactly like a secret-dependent branch. Reject CT
            // div/mod (Sub/Mul are constant-time and keep the CT tag).
            if any_ct && matches!(op, BinOp::Div | BinOp::Mod) {
                return Err(TypeError::ConstantTimeViolation {
                    context: "variable-time division or modulo",
                });
            }
            // Arbitrary-precision integer / decimal arithmetic (each its
            // own domain, distinct from `Int` and from each other).
            if (*inner1 == Ty::BigInt && *inner2 == Ty::BigInt)
                || (*inner1 == Ty::Decimal && *inner2 == Ty::Decimal)
                || (*inner1 == Ty::Fixed && *inner2 == Ty::Fixed)
                || (*inner1 == Ty::FixedBin && *inner2 == Ty::FixedBin)
            {
                return Ok((label_result(inner1.clone()), eff));
            }
            if !types_compatible(&Ty::Int, inner1) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Int,
                    found: inner1.clone(),
                });
            }
            if !types_compatible(&Ty::Int, inner2) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Int,
                    found: inner2.clone(),
                });
            }
            // Numeric tower: reject mixing two different sized widths;
            // otherwise propagate the sized width (a plain `Int` adapts).
            if mixed_int_width(inner1, inner2) {
                return Err(TypeError::TypeMismatch {
                    expected: inner1.clone(),
                    found: inner2.clone(),
                });
            }
            Ok((
                label_result(int_arith_result(inner1, inner2).unwrap_or(Ty::Int)),
                eff,
            ))
        }
        BinOp::Eq | BinOp::Ne => {
            if !types_compatible(inner1, inner2) {
                return Err(TypeError::TypeMismatch {
                    expected: inner1.clone(),
                    found: inner2.clone(),
                });
            }
            if !types_compatible(&Ty::Int, inner1)
                && !types_compatible(&Ty::Bool, inner1)
                && !types_compatible(&Ty::String, inner1)
                && *inner1 != Ty::BigInt
                && *inner1 != Ty::Decimal
                && *inner1 != Ty::Fixed
                && *inner1 != Ty::FixedBin
            {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Int,
                    found: inner1.clone(),
                });
            }
            Ok((label_result(Ty::Bool), eff))
        }
        BinOp::Lt | BinOp::Le | BinOp::Gt | BinOp::Ge => {
            // Ordering is defined for fixed-width ints, BigInt, Decimal,
            // Fixed, and FixedBin.
            if (*inner1 == Ty::BigInt && *inner2 == Ty::BigInt)
                || (*inner1 == Ty::Decimal && *inner2 == Ty::Decimal)
                || (*inner1 == Ty::Fixed && *inner2 == Ty::Fixed)
                || (*inner1 == Ty::FixedBin && *inner2 == Ty::FixedBin)
            {
                return Ok((label_result(Ty::Bool), eff));
            }
            if !types_compatible(&Ty::Int, inner1) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Int,
                    found: inner1.clone(),
                });
            }
            if !types_compatible(&Ty::Int, inner2) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Int,
                    found: inner2.clone(),
                });
            }
            Ok((label_result(Ty::Bool), eff))
        }
        BinOp::And | BinOp::Or => {
            if !types_compatible(&Ty::Bool, inner1) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Bool,
                    found: inner1.clone(),
                });
            }
            if !types_compatible(&Ty::Bool, inner2) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Bool,
                    found: inner2.clone(),
                });
            }
            Ok((label_result(Ty::Bool), eff))
        }
    }
}

#[inline(never)]
fn tc_actor_decl(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::ActorDecl {
        name: _,
        state_ty,
        message_ty,
        init_state,
        handler,
    } = expr else {
        unreachable!("tc_actor_decl is only called for Expr::ActorDecl")
    };
    // Type-check init_state: must match declared state_ty
    let (init_ty, eff1) = type_check_full(ctx, init_state)?;
    if !types_compatible(state_ty, &init_ty) {
        return Err(TypeError::TypeMismatch {
            expected: state_ty.clone(),
            found: init_ty,
        });
    }
    // Type-check handler: must be Fn(message_ty) -> state_ty
    let (handler_ty, eff2) = type_check_full(ctx, handler)?;
    match &handler_ty {
        Ty::Fn(arg, ret, _) => {
            if !types_compatible(message_ty, arg) {
                return Err(TypeError::TypeMismatch {
                    expected: message_ty.clone(),
                    found: *arg.clone(),
                });
            }
            if !types_compatible(state_ty, ret) {
                return Err(TypeError::TypeMismatch {
                    expected: state_ty.clone(),
                    found: *ret.clone(),
                });
            }
        }
        _ => return Err(TypeError::ExpectedFunction(handler_ty)),
    }
    Ok((
        Ty::Actor(Box::new(state_ty.clone()), Box::new(message_ty.clone())),
        eff1.join(eff2),
    ))
}

#[inline(never)]
fn tc_choreography_block(expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::ChoreographyBlock {
        name: _,
        roles,
        protocol,
    } = expr else {
        unreachable!("tc_choreography_block is only called for Expr::ChoreographyBlock")
    };
    // Parse → project → check: the protocol must be closed, its roles
    // distinct, and (for the two-party case) its per-role projections
    // dual. This wires the projection pipeline into typechecking.
    if let Err(reason) = choreography_compatible(roles, protocol) {
        return Err(TypeError::ChoreographyError {
            message: format!("ill-formed choreography: {reason}"),
        });
    }
    Ok((
        Ty::Choreography(roles.clone(), protocol.clone()),
        EffectSet::PURE,
    ))
}

#[inline(never)]
fn tc_spawn(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::Spawn(actor_expr, init_state_expr) = expr else {
        unreachable!("tc_spawn is only called for Expr::Spawn")
    };
    let (actor_ty, eff1) = type_check_full(ctx, actor_expr)?;
    let (init_ty, eff2) = type_check_full(ctx, init_state_expr)?;
    match &actor_ty {
        Ty::Actor(state_ty, msg_ty) => {
            if !types_compatible(state_ty, &init_ty) {
                return Err(TypeError::TypeMismatch {
                    expected: *state_ty.clone(),
                    found: init_ty,
                });
            }
            Ok((
                Ty::Actor(state_ty.clone(), msg_ty.clone()),
                eff1.join(eff2).join(Effect::Process),
            ))
        }
        _ => Err(TypeError::ExpectedActor(actor_ty)),
    }
}

#[inline(never)]
fn tc_actor_send(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::ActorSend(actor_expr, msg_expr) = expr else {
        unreachable!("tc_actor_send is only called for Expr::ActorSend")
    };
    let (actor_ty, eff1) = type_check_full(ctx, actor_expr)?;
    let (msg_ty, eff2) = type_check_full(ctx, msg_expr)?;
    match &actor_ty {
        Ty::Actor(_, expected_msg) => {
            if !types_compatible(expected_msg, &msg_ty) {
                return Err(TypeError::TypeMismatch {
                    expected: *expected_msg.clone(),
                    found: msg_ty,
                });
            }
            // A send is an effectful call whose message is viewed at
            // the actor's (usually `Any`) message type: the same
            // erasure discipline as an `Any` parameter (H1/H4).
            let hidden = erased_info(expected_msg, &msg_ty);
            let observable = ctx.pc().join(hidden.level);
            if observable != SecurityLevel::Public {
                return Err(TypeError::SecurityViolation {
                    found: observable,
                    expected: SecurityLevel::Public,
                    context: "actor send (an effectful call)",
                });
            }
            charge_erased_effect(ctx, hidden.effect, SecurityLevel::Public)?;
            Ok((
                Ty::Unit,
                eff1.join(eff2).join(Effect::Network).join(hidden.effect),
            ))
        }
        _ => Err(TypeError::ExpectedActor(actor_ty)),
    }
}

#[inline(never)]
fn tc_crdt_merge(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::CRDTMerge(left, right) = expr else {
        unreachable!("tc_crdt_merge is only called for Expr::CRDTMerge")
    };
    let (left_ty, eff1) = type_check_full(ctx, left)?;
    let (right_ty, eff2) = type_check_full(ctx, right)?;
    match (&left_ty, &right_ty) {
        (Ty::CRDT(t1, op1), Ty::CRDT(t2, op2)) => {
            if !types_compatible(t1, t2) || !types_compatible(op1, op2) {
                return Err(TypeError::CRDTMismatch {
                    left: left_ty,
                    right: right_ty,
                });
            }
            Ok((Ty::CRDT(t1.clone(), op1.clone()), eff1.join(eff2)))
        }
        (Ty::CRDT(_, _), _) => Err(TypeError::ExpectedCRDT(right_ty)),
        _ => Err(TypeError::ExpectedCRDT(left_ty)),
    }
}

#[inline(never)]
fn tc_content_verify(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::ContentVerify(expected_hash, value) = expr else {
        unreachable!("tc_content_verify is only called for Expr::ContentVerify")
    };
    let (expected_ty, eff1) = type_check_full(ctx, expected_hash)?;
    let (value_ty, eff2) = type_check_full(ctx, value)?;
    let expected = Ty::ContentAddressed(Box::new(value_ty.clone()));
    match expected_ty {
        Ty::ContentAddressed(inner_ty) => {
            if !types_compatible(&inner_ty, &value_ty) {
                return Err(TypeError::TypeMismatch {
                    expected,
                    found: Ty::ContentAddressed(inner_ty),
                });
            }
            Ok((Ty::Bool, eff1.join(eff2).join(Effect::Crypto)))
        }
        found => Err(TypeError::TypeMismatch { expected, found }),
    }
}

#[inline(never)]
fn tc_token_transfer(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::TokenTransfer { from, to, amount } = expr else {
        unreachable!("tc_token_transfer is only called for Expr::TokenTransfer")
    };
    let (from_ty, eff1) = type_check_full(ctx, from)?;
    let (to_ty, eff2) = type_check_full(ctx, to)?;
    let (amount_ty, eff3) = type_check_full(ctx, amount)?;
    match (&from_ty, &to_ty) {
        (Ty::Token(from_inner), Ty::Token(to_inner)) => {
            if !types_compatible(from_inner, to_inner) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Token(from_inner.clone()),
                    found: to_ty,
                });
            }
            if !types_compatible(from_inner, &amount_ty) {
                return Err(TypeError::TypeMismatch {
                    expected: *from_inner.clone(),
                    found: amount_ty,
                });
            }
            Ok((
                Ty::Token(from_inner.clone()),
                eff1.join(eff2).join(eff3).join(Effect::NetworkSecure),
            ))
        }
        (Ty::Token(_), _) => Err(TypeError::TypeMismatch {
            expected: from_ty,
            found: to_ty,
        }),
        _ => Err(TypeError::TypeMismatch {
            expected: Ty::Token(Box::new(amount_ty)),
            found: from_ty,
        }),
    }
}

#[inline(never)]
fn tc_zakat_calculate(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::ZakatCalculate(value) = expr else {
        unreachable!("tc_zakat_calculate is only called for Expr::ZakatCalculate")
    };
    let (value_ty, eff) = type_check_full(ctx, value)?;
    match value_ty {
        Ty::Int => Ok((Ty::Int, eff)),
        Ty::Token(inner) if types_compatible(&Ty::Int, inner.as_ref()) => {
            Ok((Ty::Token(inner), eff))
        }
        found => Err(TypeError::TypeMismatch {
            expected: Ty::Int,
            found,
        }),
    }
}

#[inline(never)]
fn tc_ui_text(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::UIText(content, color) = expr else {
        unreachable!("tc_ui_text is only called for Expr::UIText")
    };
    let (_, eff1) = type_check_full(ctx, content)?;
    let (color_ty, eff2) = type_check_full(ctx, color)?;
    if !types_compatible(&Ty::Color, &color_ty) {
        return Err(TypeError::TypeMismatch {
            expected: Ty::Color,
            found: color_ty,
        });
    }
    Ok((Ty::Element, eff1.join(eff2)))
}

#[inline(never)]
fn tc_ui_contrast_check(ctx: &mut TypingContext, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    let Expr::UIContrastCheck(fg, bg) = expr else {
        unreachable!("tc_ui_contrast_check is only called for Expr::UIContrastCheck")
    };
    let (fg_ty, eff1) = type_check_full(ctx, fg)?;
    let (bg_ty, eff2) = type_check_full(ctx, bg)?;
    if !types_compatible(&Ty::Color, &fg_ty) {
        return Err(TypeError::TypeMismatch {
            expected: Ty::Color,
            found: fg_ty,
        });
    }
    if !types_compatible(&Ty::Color, &bg_ty) {
        return Err(TypeError::TypeMismatch {
            expected: Ty::Color,
            found: bg_ty,
        });
    }
    Ok((Ty::Bool, eff1.join(eff2)))
}

// ============================================================================
// LEGACY TYPE CHECKING (Backward Compatibility)
// ============================================================================

/// Legacy typechecker for backward compatibility.
/// DEPRECATED: Use type_check_full with TypingContext for new code.
pub fn type_check(ctx: &Context, expr: &Expr) -> Result<(Ty, EffectSet), TypeError> {
    match expr {
        // VERIFIED: Values
        Expr::Unit => Ok((Ty::Unit, EffectSet::PURE)),
        Expr::Bool(_) => Ok((Ty::Bool, EffectSet::PURE)),
        Expr::Int(_) => Ok((Ty::Int, EffectSet::PURE)),
        // Sized integer literal `42u8` types as the distinct `Ty::IntN` (numeric tower).
        Expr::IntN { bits, signed, .. } => Ok((
            Ty::IntN {
                bits: *bits,
                signed: *signed,
            },
            EffectSet::PURE,
        )),
        Expr::String(_) => Ok((Ty::String, EffectSet::PURE)),
        // List literal `[e1, ...]` — all elements share a type; result `List<T>`.
        Expr::ListLit(elems) => {
            let mut elem_ty = Ty::Any;
            let mut eff = EffectSet::PURE;
            for (i, e) in elems.iter().enumerate() {
                let (t, ef) = type_check(ctx, e)?;
                eff = eff.join(ef);
                if i == 0 {
                    elem_ty = t;
                } else if elem_ty != Ty::Any && t != Ty::Any && t != elem_ty {
                    return Err(TypeError::TypeMismatch {
                        expected: elem_ty.clone(),
                        found: t,
                    });
                }
            }
            Ok((Ty::List(Box::new(elem_ty)), eff))
        }
        // Record literal / field access — structural, typed as `Any`.
        Expr::RecordLit(_name, fields) => {
            let mut eff = EffectSet::PURE;
            for (_f, e) in fields {
                let (_t, ef) = type_check(ctx, e)?;
                eff = eff.join(ef);
            }
            Ok((Ty::Any, eff))
        }
        Expr::FieldAccess(base, _field) => {
            let (_t, eff) = type_check(ctx, base)?;
            Ok((Ty::Any, eff))
        }
        Expr::Var(x) => {
            if let Some(ty) = internal_primitive_type(x) {
                return Ok((ty, EffectSet::PURE));
            }
            let ty = ctx
                .lookup(x)
                .cloned()
                .ok_or_else(|| TypeError::VarNotFound(x.clone()))?;
            Ok((ty, EffectSet::PURE))
        }

        // VERIFIED: Functions
        Expr::Lam(x, t1, body) => {
            let mut new_ctx = ctx.extend(x.clone(), t1.clone());
            new_ctx.return_types = Rc::default();
            let (t2, eff) = type_check(&new_ctx, body)?;
            let t2 = function_result_type(t2, &new_ctx.return_types.borrow())?;
            Ok((
                Ty::Fn(Box::new(t1.clone()), Box::new(t2), eff),
                EffectSet::PURE,
            ))
        }
        Expr::App(e1, e2) => {
            let (t1, eff1) = type_check(ctx, e1)?;
            let (t2, eff2) = type_check(ctx, e2)?;

            match t1 {
                Ty::Fn(arg_ty, ret_ty, fn_eff) => {
                    // IFC (REQ-27): secret/labeled data may not reach a public
                    // print/network/file-write sink without declassification.
                    if let Some(err) = secrecy_at_sink(e1, &t2) {
                        return Err(err);
                    }
                    // Crypto-agility (REQ-48): reject selecting a deprecated
                    // algorithm. Coq: crypto/AlgorithmPolicy.v `accepts`.
                    if let Some(err) = deprecated_algorithm_at_selection(e1, e2) {
                        return Err(err);
                    }
                    if !types_compatible(&arg_ty, &t2) {
                        return Err(sink_argument_error(*arg_ty, t2));
                    }
                    // Effect accumulation: eff1 + eff2 + fn_eff
                    let total_eff = eff1.join(eff2).join(fn_eff);
                    // REQ-27: a pure data-transforming builtin re-carries its
                    // argument's secrecy (laundering fix — see
                    // propagate_secrecy_through_builtin).
                    let ret_ty = internal_primitive_result(e1, &t2, *ret_ty)?;
                    let ret_ty = check_call_secrecy(&arg_ty, &t2, ret_ty, fn_eff, ctx.level)?;
                    let ret_ty = propagate_secrecy_through_builtin(e1, &t2, ret_ty);
                    Ok((ret_ty, total_eff))
                }
                Ty::Any => Ok((Ty::Any, eff1.join(eff2))),
                _ => Err(TypeError::ExpectedFunction(t1)),
            }
        }

        // VERIFIED: Products
        Expr::Pair(e1, e2) => {
            let (t1, eff1) = type_check(ctx, e1)?;
            let (t2, eff2) = type_check(ctx, e2)?;
            Ok((Ty::Prod(Box::new(t1), Box::new(t2)), eff1.join(eff2)))
        }
        Expr::Fst(e) => {
            let (t, eff) = type_check(ctx, e)?;
            match t {
                Ty::Prod(t1, _) => Ok((*t1, eff)),
                Ty::Any => Ok((Ty::Any, eff)),
                _ => Err(TypeError::ExpectedProduct(t)),
            }
        }
        Expr::Snd(e) => {
            let (t, eff) = type_check(ctx, e)?;
            match t {
                Ty::Prod(_, t2) => Ok((*t2, eff)),
                Ty::Any => Ok((Ty::Any, eff)),
                _ => Err(TypeError::ExpectedProduct(t)),
            }
        }

        // VERIFIED: Sums
        Expr::Inl(e, ty) => match ty {
            Ty::Sum(t1, t2) => {
                let (te, eff) = type_check(ctx, e)?;
                if te != **t1 {
                    return Err(TypeError::TypeMismatch {
                        expected: *t1.clone(),
                        found: te,
                    });
                }
                Ok((Ty::Sum(t1.clone(), t2.clone()), eff))
            }
            Ty::Any => {
                let (te, eff) = type_check(ctx, e)?;
                Ok((Ty::Sum(Box::new(te), Box::new(Ty::Any)), eff))
            }
            _ => Err(TypeError::ExpectedSum(ty.clone())),
        },
        Expr::Inr(e, ty) => match ty {
            Ty::Sum(t1, t2) => {
                let (te, eff) = type_check(ctx, e)?;
                if te != **t2 {
                    return Err(TypeError::TypeMismatch {
                        expected: *t2.clone(),
                        found: te,
                    });
                }
                Ok((Ty::Sum(t1.clone(), t2.clone()), eff))
            }
            Ty::Any => {
                let (te, eff) = type_check(ctx, e)?;
                Ok((Ty::Sum(Box::new(Ty::Any), Box::new(te)), eff))
            }
            _ => Err(TypeError::ExpectedSum(ty.clone())),
        },
        Expr::Case(e, x, e1, y, e2) => {
            let (t, eff) = type_check(ctx, e)?;
            // Normalize Sum / Option<T> / Any to a (left, right) binder pair.
            let sum_arms: Option<(Ty, Ty)> = match &t {
                Ty::Sum(l, r) => Some(((**l).clone(), (**r).clone())),
                Ty::Option(inner) => Some(((**inner).clone(), Ty::Unit)),
                Ty::Any => Some((Ty::Any, Ty::Any)),
                _ => None,
            };
            match sum_arms {
                Some((t_left, t_right)) => {
                    let ctx1 = ctx.extend(x.clone(), t_left);
                    let (t1, eff1) = type_check(&ctx1, e1)?;

                    let ctx2 = ctx.extend(y.clone(), t_right);
                    let (t2, eff2) = type_check(&ctx2, e2)?;

                    if !types_compatible(&t1, &t2) {
                        return Err(TypeError::TypeMismatch {
                            expected: t1,
                            found: t2,
                        });
                    }
                    let result_ty = join_branch_types(t1, t2);

                    Ok((result_ty, eff.join(eff1).join(eff2)))
                }
                None => Err(TypeError::ExpectedSum(t)),
            }
        }

        // VERIFIED: Control
        Expr::If(cond, e2, e3) => {
            let (t_cond, eff1) = type_check(ctx, cond)?;
            if t_cond != Ty::Bool && t_cond != Ty::Any {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Bool,
                    found: t_cond,
                });
            }

            let (t2, eff2) = type_check(ctx, e2)?;
            let (t3, eff3) = type_check(ctx, e3)?;

            if !types_compatible(&t2, &t3) {
                return Err(TypeError::TypeMismatch {
                    expected: t2,
                    found: t3,
                });
            }
            let result_ty = join_branch_types(t2, t3);

            Ok((result_ty, eff1.join(eff2).join(eff3)))
        }
        // See `type_check_full` for the rules; this legacy path mirrors them.
        Expr::While(cond, body) => {
            let (t_cond, eff_cond) = type_check(ctx, cond)?;
            if t_cond != Ty::Bool && t_cond != Ty::Any {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Bool,
                    found: t_cond,
                });
            }
            let (_t_body, eff_body) = type_check(ctx, body)?;
            Ok((Ty::Unit, eff_cond.join(eff_body)))
        }
        Expr::Break | Expr::Continue => Ok((Ty::Any, EffectSet::PURE)),
        Expr::LetMut(x, e1, e2) => {
            let (t1, eff1) = type_check(ctx, e1)?;
            let ctx_new = ctx.extend(x.clone(), Ty::Ref(Box::new(t1), SecurityLevel::Public));
            let (t2, eff2) = type_check(&ctx_new, e2)?;
            Ok((t2, eff1.join(eff2)))
        }
        Expr::SlotGet(x) => {
            let ty = ctx
                .lookup(x)
                .cloned()
                .ok_or_else(|| TypeError::VarNotFound(x.clone()))?;
            match ty {
                Ty::Ref(inner, _) => Ok((*inner, EffectSet::PURE)),
                other => Ok((other, EffectSet::PURE)),
            }
        }
        Expr::SlotSet(_, _) => type_check_full(&mut ctx.to_typing_context(), expr),
        Expr::Let(x, _, e1, e2) => {
            let (t1, eff1) = type_check(ctx, e1)?;
            let ctx_new = ctx.extend(x.clone(), t1);
            let (t2, eff2) = type_check(&ctx_new, e2)?;
            Ok((t2, eff1.join(eff2)))
        }
        // `pulang e` — early return; type `Any` (see type_check_full).
        Expr::Return(e) => {
            let (t, eff) = type_check(ctx, e)?;
            ctx.return_types.borrow_mut().push(label_at_level(t, ctx.level));
            Ok((Ty::Any, eff))
        }
        Expr::LetRec(x, ty_ann, e1, e2) => {
            // Typecheck binding with name already in scope (for recursion)
            let ctx_rec = ctx.extend(x.clone(), ty_ann.clone());
            let (t1, eff1) = type_check(&ctx_rec, e1)?;
            // Check that binding type is compatible with annotation
            if !types_compatible(ty_ann, &t1) {
                return Err(TypeError::AnnotationMismatch {
                    expected: ty_ann.clone(),
                    found: t1,
                });
            }
            let (t2, eff2) = type_check(&ctx_rec, e2)?;
            Ok((t2, eff1.join(eff2)))
        }

        // Mutually-recursive group (REQ-44) — plain checker path.
        Expr::LetRecGroup(bindings, cont) => {
            let mut ctx_rec = ctx.clone();
            for (name, ty_ann, _) in bindings {
                ctx_rec = ctx_rec.extend(name.clone(), ty_ann.clone());
            }
            let mut eff = EffectSet::PURE;
            for (_, ty_ann, e1) in bindings {
                let (t1, eff1) = type_check(&ctx_rec, e1)?;
                if !types_compatible(ty_ann, &t1) {
                    return Err(TypeError::AnnotationMismatch {
                        expected: ty_ann.clone(),
                        found: t1,
                    });
                }
                eff = eff.join(eff1);
            }
            let (t2, eff2) = type_check(&ctx_rec, cont)?;
            Ok((t2, eff.join(eff2)))
        }

        // UNVERIFIED: Effects (Pending formalization in Typing.v)
        Expr::Perform(eff, e) => {
            let (te, eff_e) = type_check(ctx, e)?;
            // Matches Coq T_Perform (Typing.v:168): `e : T ! ε  ⊢  perform eff e : T ! (ε ⊔ eff)`.
            // The payload type passes through unchanged and the performed effect is
            // joined. RIINA's effect model has no per-effect payload *signature*
            // (T_Perform takes no signature premise), so there is deliberately no
            // payload-vs-signature validation here — adding one would be a Rust rule
            // with no Coq counterpart, violating Gate B enforcement parity. (The
            // `type_check_full` Perform arm is identical.)
            Ok((te, eff_e.join(*eff)))
        }
        Expr::Handle(e, x, h) => {
            let (t_e, eff_e) = type_check(ctx, e)?;
            // Coq T_Handle: handler binds x : T in h, result effect is join
            let h_ctx = ctx.extend(x.clone(), t_e);
            let (t_h, eff_h) = type_check(&h_ctx, h)?;
            Ok((t_h, eff_e.join(eff_h)))
        }

        // UNVERIFIED: References (Pending formalization in Typing.v)
        Expr::Ref(e, l) => {
            let (t, eff) = type_check(ctx, e)?;
            Ok((Ty::Ref(Box::new(t), *l), eff.join(Effect::Write))) // Allocation is a write-like effect?
        }
        Expr::Deref(e) => {
            let (t, eff) = type_check(ctx, e)?;
            match t {
                Ty::Ref(inner, _l) => Ok((*inner, eff.join(Effect::Read))),
                // `!` as logical negation on Bool/Any (see type_check_full).
                Ty::Bool => Ok((Ty::Bool, eff)),
                Ty::Any => Ok((Ty::Any, eff)),
                _ => Err(TypeError::ExpectedRef(t)),
            }
        }
        Expr::Assign(e1, e2) => {
            let (t1, eff1) = type_check(ctx, e1)?;
            let (t2, eff2) = type_check(ctx, e2)?;
            match t1 {
                Ty::Ref(inner, _l) => {
                    if *inner != t2 {
                        return Err(TypeError::TypeMismatch {
                            expected: *inner,
                            found: t2,
                        });
                    }
                    Ok((Ty::Unit, eff1.join(eff2).join(Effect::Write)))
                }
                _ => Err(TypeError::ExpectedRef(t1)),
            }
        }

        // UNVERIFIED: Security (Pending formalization in Typing.v)
        Expr::Classify(e) => {
            let (t, eff) = type_check(ctx, e)?;
            Ok((Ty::Secret(Box::new(t)), eff))
        }
        Expr::Declassify(e, _proof) => {
            let (t, eff) = type_check(ctx, e)?;
            match t {
                Ty::Secret(inner) => Ok((*inner, eff)),
                // Assuming we can define what a "proof" is later.
                _ => Err(TypeError::ExpectedSecret(t)), // Matches Coq T_Declassify: requires TSecret(T)
            }
        }
        Expr::Prove(e) => {
            let (t, eff) = type_check(ctx, e)?;
            Ok((Ty::Proof(Box::new(t)), eff))
        }

        // UNVERIFIED: Capabilities
        Expr::Require(eff, e) => {
            let (t, e_eff) = type_check(ctx, e)?;
            Ok((t, e_eff.join(*eff)))
        }
        Expr::Grant(_eff, e) => {
            // Grant satisfies a requirement?
            let (t, e_eff) = type_check(ctx, e)?;
            Ok((t, e_eff)) // Does it remove the effect from the context?
        }

        // Locations (runtime-only — corresponds to Coq ELoc)
        Expr::Loc(_) => {
            // Store locations are runtime values; typing requires store typing context.
            // Without store context, we return Ref(Unit, Public) as a conservative type.
            Ok((
                Ty::Ref(Box::new(Ty::Unit), SecurityLevel::Public),
                EffectSet::PURE,
            ))
        }

        // FFI call
        Expr::FFICall {
            name: _,
            args,
            ret_ty,
        } => {
            let mut eff = EffectSet::from(Effect::System); // FFI is always effectful
            for arg in args {
                let (_t, e) = type_check(ctx, arg)?;
                eff = eff.join(e);
            }
            Ok((ret_ty.clone(), eff))
        }

        // Binary operations
        Expr::BinOp(op, e1, e2) => {
            let (t1, eff1) = type_check(ctx, e1)?;
            let (t2, eff2) = type_check(ctx, e2)?;
            let eff = eff1.join(eff2);
            match op {
                BinOp::Add => {
                    if t1 == Ty::Any || t2 == Ty::Any {
                        Ok((Ty::Any, eff))
                    } else if t1 == Ty::String && t2 == Ty::String {
                        Ok((Ty::String, eff))
                    } else if t1 == Ty::Int && t2 == Ty::Int {
                        Ok((Ty::Int, eff))
                    } else {
                        Err(TypeError::TypeMismatch {
                            expected: t1,
                            found: t2,
                        })
                    }
                }
                BinOp::Sub | BinOp::Mul | BinOp::Div | BinOp::Mod => {
                    if t1 != Ty::Int && t1 != Ty::Any {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Int,
                            found: t1,
                        });
                    }
                    if t2 != Ty::Int && t2 != Ty::Any {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Int,
                            found: t2,
                        });
                    }
                    Ok((Ty::Int, eff))
                }
                BinOp::Eq | BinOp::Ne => {
                    // Eq/Ne work on Int, Bool, and String
                    if t1 != t2 {
                        return Err(TypeError::TypeMismatch {
                            expected: t1,
                            found: t2,
                        });
                    }
                    if t1 != Ty::Int && t1 != Ty::Bool && t1 != Ty::String {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Int,
                            found: t1,
                        });
                    }
                    Ok((Ty::Bool, eff))
                }
                BinOp::Lt | BinOp::Le | BinOp::Gt | BinOp::Ge => {
                    if t1 != Ty::Int {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Int,
                            found: t1,
                        });
                    }
                    if t2 != Ty::Int {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Int,
                            found: t2,
                        });
                    }
                    Ok((Ty::Bool, eff))
                }
                BinOp::And | BinOp::Or => {
                    if t1 != Ty::Bool {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Bool,
                            found: t1,
                        });
                    }
                    if t2 != Ty::Bool {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Bool,
                            found: t2,
                        });
                    }
                    Ok((Ty::Bool, eff))
                }
            }
        }

        // ════════════════════════════════════════════════════════════════════
        // JALINAN Phase 6: Session Types, Actors, Choreography, CRDTs
        // ════════════════════════════════════════════════════════════════════
        Expr::ActorDecl {
            name: _,
            state_ty,
            message_ty,
            init_state,
            handler,
        } => {
            let (init_ty, eff1) = type_check(ctx, init_state)?;
            if !types_compatible(state_ty, &init_ty) {
                return Err(TypeError::TypeMismatch {
                    expected: state_ty.clone(),
                    found: init_ty,
                });
            }
            let (handler_ty, eff2) = type_check(ctx, handler)?;
            match &handler_ty {
                Ty::Fn(arg, ret, _) => {
                    if !types_compatible(message_ty, arg) {
                        return Err(TypeError::TypeMismatch {
                            expected: message_ty.clone(),
                            found: *arg.clone(),
                        });
                    }
                    if !types_compatible(state_ty, ret) {
                        return Err(TypeError::TypeMismatch {
                            expected: state_ty.clone(),
                            found: *ret.clone(),
                        });
                    }
                }
                _ => return Err(TypeError::ExpectedFunction(handler_ty)),
            }
            Ok((
                Ty::Actor(Box::new(state_ty.clone()), Box::new(message_ty.clone())),
                eff1.join(eff2),
            ))
        }

        Expr::ChoreographyBlock {
            name: _,
            roles,
            protocol,
        } => {
            // Parse → project → check: the protocol must be closed, its roles
            // distinct, and (for the two-party case) its per-role projections
            // dual. This wires the projection pipeline into typechecking.
            if let Err(reason) = choreography_compatible(roles, protocol) {
                return Err(TypeError::ChoreographyError {
                    message: format!("ill-formed choreography: {reason}"),
                });
            }
            Ok((
                Ty::Choreography(roles.clone(), protocol.clone()),
                EffectSet::PURE,
            ))
        }

        Expr::Spawn(actor_expr, init_state_expr) => {
            let (actor_ty, eff1) = type_check(ctx, actor_expr)?;
            let (init_ty, eff2) = type_check(ctx, init_state_expr)?;
            match &actor_ty {
                Ty::Actor(state_ty, msg_ty) => {
                    if !types_compatible(state_ty, &init_ty) {
                        return Err(TypeError::TypeMismatch {
                            expected: *state_ty.clone(),
                            found: init_ty,
                        });
                    }
                    Ok((
                        Ty::Actor(state_ty.clone(), msg_ty.clone()),
                        eff1.join(eff2).join(Effect::Process),
                    ))
                }
                _ => Err(TypeError::ExpectedActor(actor_ty)),
            }
        }

        Expr::ActorSend(actor_expr, msg_expr) => {
            let (actor_ty, eff1) = type_check(ctx, actor_expr)?;
            let (msg_ty, eff2) = type_check(ctx, msg_expr)?;
            match &actor_ty {
                Ty::Actor(_, expected_msg) => {
                    if !types_compatible(expected_msg, &msg_ty) {
                        return Err(TypeError::TypeMismatch {
                            expected: *expected_msg.clone(),
                            found: msg_ty,
                        });
                    }
                    Ok((Ty::Unit, eff1.join(eff2).join(Effect::Network)))
                }
                _ => Err(TypeError::ExpectedActor(actor_ty)),
            }
        }

        Expr::ActorRecv(actor_expr) => {
            let (actor_ty, eff) = type_check(ctx, actor_expr)?;
            match &actor_ty {
                Ty::Actor(_, msg_ty) => Ok((*msg_ty.clone(), eff.join(Effect::Network))),
                _ => Err(TypeError::ExpectedActor(actor_ty)),
            }
        }

        Expr::CRDTMerge(left, right) => {
            let (left_ty, eff1) = type_check(ctx, left)?;
            let (right_ty, eff2) = type_check(ctx, right)?;
            match (&left_ty, &right_ty) {
                (Ty::CRDT(t1, op1), Ty::CRDT(t2, op2)) => {
                    if !types_compatible(t1, t2) || !types_compatible(op1, op2) {
                        return Err(TypeError::CRDTMismatch {
                            left: left_ty,
                            right: right_ty,
                        });
                    }
                    Ok((Ty::CRDT(t1.clone(), op1.clone()), eff1.join(eff2)))
                }
                (Ty::CRDT(_, _), _) => Err(TypeError::ExpectedCRDT(right_ty)),
                _ => Err(TypeError::ExpectedCRDT(left_ty)),
            }
        }

        Expr::ContentHash(expr) => {
            let (inner_ty, eff) = type_check(ctx, expr)?;
            Ok((
                Ty::ContentAddressed(Box::new(inner_ty)),
                eff.join(Effect::Crypto),
            ))
        }

        Expr::ContentVerify(expected_hash, value) => {
            let (expected_ty, eff1) = type_check(ctx, expected_hash)?;
            let (value_ty, eff2) = type_check(ctx, value)?;
            let expected = Ty::ContentAddressed(Box::new(value_ty.clone()));
            match expected_ty {
                Ty::ContentAddressed(inner_ty) => {
                    if !types_compatible(&inner_ty, &value_ty) {
                        return Err(TypeError::TypeMismatch {
                            expected,
                            found: Ty::ContentAddressed(inner_ty),
                        });
                    }
                    Ok((Ty::Bool, eff1.join(eff2).join(Effect::Crypto)))
                }
                found => Err(TypeError::TypeMismatch { expected, found }),
            }
        }

        Expr::ContractDeploy(contract) => {
            let (inner_ty, eff) = type_check(ctx, contract)?;
            Ok((
                Ty::SmartContract(Box::new(inner_ty)),
                eff.join(Effect::NetworkSecure),
            ))
        }

        Expr::TokenTransfer { from, to, amount } => {
            let (from_ty, eff1) = type_check(ctx, from)?;
            let (to_ty, eff2) = type_check(ctx, to)?;
            let (amount_ty, eff3) = type_check(ctx, amount)?;
            match (&from_ty, &to_ty) {
                (Ty::Token(from_inner), Ty::Token(to_inner)) => {
                    if !types_compatible(from_inner, to_inner) {
                        return Err(TypeError::TypeMismatch {
                            expected: Ty::Token(from_inner.clone()),
                            found: to_ty,
                        });
                    }
                    if !types_compatible(from_inner, &amount_ty) {
                        return Err(TypeError::TypeMismatch {
                            expected: *from_inner.clone(),
                            found: amount_ty,
                        });
                    }
                    Ok((
                        Ty::Token(from_inner.clone()),
                        eff1.join(eff2).join(eff3).join(Effect::NetworkSecure),
                    ))
                }
                (Ty::Token(_), _) => Err(TypeError::TypeMismatch {
                    expected: from_ty,
                    found: to_ty,
                }),
                _ => Err(TypeError::TypeMismatch {
                    expected: Ty::Token(Box::new(amount_ty)),
                    found: from_ty,
                }),
            }
        }

        Expr::ZakatCalculate(value) => {
            let (value_ty, eff) = type_check(ctx, value)?;
            match value_ty {
                Ty::Int => Ok((Ty::Int, eff)),
                Ty::Token(inner) if types_compatible(&Ty::Int, inner.as_ref()) => {
                    Ok((Ty::Token(inner), eff))
                }
                found => Err(TypeError::TypeMismatch {
                    expected: Ty::Int,
                    found,
                }),
            }
        }

        // CAHAYA Phase J5: UI Primitives
        Expr::UIDisplay(elems) | Expr::UIRow(elems) | Expr::UIColumn(elems) => {
            let mut eff = EffectSet::PURE;
            for e in elems {
                let (_, e_eff) = type_check(ctx, e)?;
                eff = eff.join(e_eff);
            }
            Ok((Ty::Element, eff))
        }

        Expr::UIText(content, color) => {
            let (_, eff1) = type_check(ctx, content)?;
            let (color_ty, eff2) = type_check(ctx, color)?;
            if !types_compatible(&Ty::Color, &color_ty) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Color,
                    found: color_ty,
                });
            }
            Ok((Ty::Element, eff1.join(eff2)))
        }

        Expr::UIButton(label, handler) => {
            let (_, eff1) = type_check(ctx, label)?;
            let (_, eff2) = type_check(ctx, handler)?;
            Ok((Ty::Element, eff1.join(eff2)))
        }

        Expr::UIColor(_, _, _) => Ok((Ty::Color, EffectSet::PURE)),

        Expr::UIStyleDecl { .. } => Ok((Ty::UIStyle, EffectSet::PURE)),

        Expr::UIContrastCheck(fg, bg) => {
            let (fg_ty, eff1) = type_check(ctx, fg)?;
            let (bg_ty, eff2) = type_check(ctx, bg)?;
            if !types_compatible(&Ty::Color, &fg_ty) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Color,
                    found: fg_ty,
                });
            }
            if !types_compatible(&Ty::Color, &bg_ty) {
                return Err(TypeError::TypeMismatch {
                    expected: Ty::Color,
                    found: bg_ty,
                });
            }
            Ok((Ty::Bool, eff1.join(eff2)))
        }
    }
}

#[cfg(test)]
mod tests;
