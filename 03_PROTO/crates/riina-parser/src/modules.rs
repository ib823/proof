// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Module resolution — multi-file RIINA programs (master plan REQ-71).
//!
//! Before this, `guna <name>;` parsed and was discarded, so every RIINA program
//! had to be a single file: a two-file program failed with `Variable not found`.
//! This module turns `guna` into a real import.
//!
//! # What a module is
//!
//! A module is one `.rii` file. `guna kira;` in `main.rii` loads `kira.rii` from
//! the SAME directory. Module names are single-segment: a multi-segment path
//! (`guna std::teks;`) names the builtin namespace, has no file behind it, and
//! is ignored by the parser — which is what keeps every pre-REQ-71 example
//! compiling unchanged.
//!
//! # How linking works
//!
//! The surface already resolved `kira::tambah` to the flat name `kira_tambah`
//! at parse time (`parse_module_path`), and `modul kira { fungsi tambah }`
//! already flattened to `kira_tambah`. Linking reuses exactly that convention
//! rather than inventing a second one:
//!
//!   * every top-level name `f` of an imported module `kira` is renamed to
//!     `kira_f`;
//!   * every FREE reference to `f` inside that module is renamed with it, so
//!     the module's internal calls keep working (a local `biar f = …` that
//!     shadows the top-level `f` is correctly left alone);
//!   * the root module is NOT renamed, so `utama` stays `utama`.
//!
//! # What is enforced
//!
//! * **Cycles** — `a` importing `b` importing `a` is a hard error naming the
//!   full chain, not a stack overflow.
//! * **Visibility** — only `awam` names may be referenced across a module
//!   boundary. A private helper is module-local even though every name shares
//!   one flat namespace after linking.
//! * **Direct imports** — a module may only name modules it imports itself.
//!   Transitively-loaded modules are present in the linked program (they must
//!   be, for their importer) but are not silently in scope.
//! * **Collisions** — two modules producing the same final name is an error,
//!   never silent shadowing.
//!
//! # The traversal
//!
//! [`walk_free_idents`] is a single binder-aware walk used for BOTH renaming
//! and reference collection. Its `match` is exhaustive with **no wildcard arm**
//! on purpose: a new `Expr` variant must fail to compile here rather than
//! silently escape renaming and produce a mis-linked program.

use crate::Parser;
use riina_types::{Expr, Ident, Program, SpannedDecl, TopLevelDecl};
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};

/// Why module resolution failed.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ResolveErrorKind {
    /// `guna x;` named a file that does not exist.
    ModuleNotFound { module: Ident, tried: PathBuf },
    /// The file exists but could not be read.
    Io { path: PathBuf, detail: String },
    /// A module imports itself, directly or through a chain.
    CircularImport { chain: Vec<Ident> },
    /// Two modules produce the same top-level name after linking.
    NameCollision {
        name: Ident,
        first: Ident,
        second: Ident,
    },
    /// A module referenced a name that its owner did not declare `awam`.
    PrivateAccess {
        module: Ident,
        name: Ident,
        from: Ident,
    },
    /// A module referenced `other::name` without `guna other;`.
    MissingImport {
        module: Ident,
        name: Ident,
        from: Ident,
    },
    /// An imported module had top-level code (only the root may have a body).
    TopLevelCodeInModule { module: Ident },
    /// A module file failed to parse. The message carries the inner diagnostic.
    Parse { module: Ident, detail: String },
}

/// A module-resolution failure, with the file it came from.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ResolveError {
    pub kind: ResolveErrorKind,
    /// The file being processed when the error was raised.
    pub path: PathBuf,
}

impl std::fmt::Display for ResolveError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match &self.kind {
            ResolveErrorKind::ModuleNotFound { module, tried } => write!(
                f,
                "module `{module}` not found (expected `{}`)\n  \
                 note: `guna {module};` imports the sibling file `{module}.rii`; \
                 for builtins use a qualified path such as `guna std::teks;`",
                tried.display()
            ),
            ResolveErrorKind::Io { path, detail } => {
                write!(f, "cannot read `{}`: {detail}", path.display())
            }
            ResolveErrorKind::CircularImport { chain } => write!(
                f,
                "circular import: {}",
                chain
                    .iter()
                    .map(String::as_str)
                    .collect::<Vec<_>>()
                    .join(" -> ")
            ),
            ResolveErrorKind::NameCollision {
                name,
                first,
                second,
            } => write!(
                f,
                "name collision: `{name}` is defined by both module `{first}` and \
                 module `{second}`\n  note: rename one of them; linking never \
                 silently shadows a definition"
            ),
            ResolveErrorKind::PrivateAccess { module, name, from } => write!(
                f,
                "`{module}::{name}` is private to module `{module}` (referenced from `{from}`)\n  \
                 note: mark it `awam fungsi {name}` to export it"
            ),
            ResolveErrorKind::MissingImport { module, name, from } => write!(
                f,
                "module `{from}` names `{module}::{name}` without importing it\n  \
                 note: add `guna {module};` to `{from}.rii`"
            ),
            ResolveErrorKind::TopLevelCodeInModule { module } => write!(
                f,
                "imported module `{module}` has top-level code; only the root file \
                 may have a program body\n  note: move it into a function"
            ),
            ResolveErrorKind::Parse { module, detail } => {
                write!(f, "in module `{module}`: {detail}")
            }
        }
    }
}

/// One parsed module before linking.
struct LoadedModule {
    /// Module name — the file stem. The root module keeps its own stem but is
    /// never renamed.
    name: Ident,
    path: PathBuf,
    program: Program,
}

/// Resolve `root` and everything it imports into ONE linked [`Program`].
///
/// The returned program is exactly what the single-file pipeline already
/// consumes, so `check_program` / `desugar` / lowering need no changes.
///
/// # Errors
/// Returns [`ResolveError`] for a missing/unreadable module, an import cycle, a
/// cross-module name collision, a private or un-imported cross-module
/// reference, or a parse failure in an imported file.
pub fn resolve_program(root: &Path, root_source: &str) -> Result<Program, ResolveError> {
    let mut loaded: Vec<LoadedModule> = Vec::new();
    let mut seen: HashSet<PathBuf> = HashSet::new();
    let mut stack: Vec<Ident> = Vec::new();

    let root_name = module_stem(root);
    let root_program = parse_source(root_source, &root_name, root)?;
    // Load dependencies first (post-order), so a module is always linked after
    // everything it needs.
    load_imports(&root_program, root, &mut loaded, &mut seen, &mut stack)?;
    loaded.push(LoadedModule {
        name: root_name.clone(),
        path: root.to_path_buf(),
        program: root_program,
    });

    link(loaded, &root_name)
}

/// Convenience wrapper that reads `root` from disk itself.
///
/// # Errors
/// As [`resolve_program`], plus an IO error if `root` cannot be read.
pub fn resolve_file(root: &Path) -> Result<Program, ResolveError> {
    let src = std::fs::read_to_string(root).map_err(|e| ResolveError {
        kind: ResolveErrorKind::Io {
            path: root.to_path_buf(),
            detail: e.to_string(),
        },
        path: root.to_path_buf(),
    })?;
    resolve_program(root, &src)
}

fn module_stem(path: &Path) -> Ident {
    path.file_stem()
        .map(|s| s.to_string_lossy().into_owned())
        .unwrap_or_else(|| "utama".to_string())
}

fn parse_source(src: &str, module: &str, path: &Path) -> Result<Program, ResolveError> {
    let mut parser = Parser::new(src);
    parser.parse_program().map_err(|e| ResolveError {
        kind: ResolveErrorKind::Parse {
            module: module.to_string(),
            detail: e.to_string(),
        },
        path: path.to_path_buf(),
    })
}

/// Depth-first load of every `guna` target, dependencies first.
fn load_imports(
    program: &Program,
    importer_path: &Path,
    loaded: &mut Vec<LoadedModule>,
    seen: &mut HashSet<PathBuf>,
    stack: &mut Vec<Ident>,
) -> Result<(), ResolveError> {
    let dir = importer_path.parent().unwrap_or_else(|| Path::new("."));
    let importer = module_stem(importer_path);

    for import in &program.imports {
        let child_path = dir.join(format!("{}.rii", import.module));

        // Cycle check BEFORE touching the filesystem, so a cycle reports the
        // chain rather than recursing until the stack dies.
        if stack.contains(&import.module) || importer == import.module {
            let mut chain = stack.clone();
            chain.push(importer.clone());
            chain.push(import.module.clone());
            return Err(ResolveError {
                kind: ResolveErrorKind::CircularImport { chain },
                path: importer_path.to_path_buf(),
            });
        }

        // Canonicalize so `./kira.rii` and `kira.rii` are one module.
        let key = std::fs::canonicalize(&child_path).unwrap_or_else(|_| child_path.clone());
        if seen.contains(&key) {
            continue; // diamond import — already linked
        }

        if !child_path.is_file() {
            return Err(ResolveError {
                kind: ResolveErrorKind::ModuleNotFound {
                    module: import.module.clone(),
                    tried: child_path,
                },
                path: importer_path.to_path_buf(),
            });
        }

        let src = std::fs::read_to_string(&child_path).map_err(|e| ResolveError {
            kind: ResolveErrorKind::Io {
                path: child_path.clone(),
                detail: e.to_string(),
            },
            path: importer_path.to_path_buf(),
        })?;
        let child = parse_source(&src, &import.module, &child_path)?;

        seen.insert(key);
        stack.push(importer.clone());
        load_imports(&child, &child_path, loaded, seen, stack)?;
        stack.pop();

        loaded.push(LoadedModule {
            name: import.module.clone(),
            path: child_path,
            program: child,
        });
    }
    Ok(())
}

/// Top-level names a module introduces (functions and bindings).
fn top_level_names(program: &Program) -> Vec<Ident> {
    let mut names = Vec::new();
    for decl in &program.decls {
        match decl {
            TopLevelDecl::Function { name, .. } | TopLevelDecl::Binding { name, .. } => {
                names.push(name.clone());
            }
            TopLevelDecl::ExternBlock { decls, .. } => {
                for d in decls {
                    names.push(d.name.clone());
                }
            }
            TopLevelDecl::Expr(_) | TopLevelDecl::Test { .. } => {}
        }
    }
    names
}

/// Rename every module's names, check the rules, and concatenate.
fn link(mut loaded: Vec<LoadedModule>, root_name: &str) -> Result<Program, ResolveError> {
    // 1. Per-module rename maps. The root is never renamed.
    let mut owner: HashMap<Ident, Ident> = HashMap::new(); // final name -> module
    let mut public_final: HashSet<Ident> = HashSet::new();
    let mut private_final: HashMap<Ident, Ident> = HashMap::new(); // final name -> module

    let mut maps: Vec<HashMap<Ident, Ident>> = Vec::with_capacity(loaded.len());
    for m in &loaded {
        let is_root = m.name == root_name;
        let mut map = HashMap::new();
        for n in top_level_names(&m.program) {
            let final_name = if is_root {
                n.clone()
            } else {
                format!("{}_{}", m.name, n)
            };
            if let Some(prev) = owner.get(&final_name) {
                return Err(ResolveError {
                    kind: ResolveErrorKind::NameCollision {
                        name: final_name,
                        first: prev.clone(),
                        second: m.name.clone(),
                    },
                    path: m.path.clone(),
                });
            }
            owner.insert(final_name.clone(), m.name.clone());
            if is_root || m.program.public_names.contains(&n) {
                public_final.insert(final_name.clone());
            } else {
                private_final.insert(final_name.clone(), m.name.clone());
            }
            map.insert(n, final_name);
        }
        maps.push(map);
    }

    // 2. Rewrite each module in place: declaration names and free references.
    for (m, map) in loaded.iter_mut().zip(maps.iter()) {
        let is_root = m.name == root_name;
        if !is_root {
            // An imported module must not carry a program body. A trailing
            // `Expr(Unit)` is what the parser appends at EOF — harmless, drop
            // it. Anything else is real top-level code and is rejected.
            for decl in &m.program.decls {
                if let TopLevelDecl::Expr(e) = decl {
                    if **e != Expr::Unit {
                        return Err(ResolveError {
                            kind: ResolveErrorKind::TopLevelCodeInModule {
                                module: m.name.clone(),
                            },
                            path: m.path.clone(),
                        });
                    }
                }
            }
            m.program
                .decls
                .retain(|d| !matches!(d, TopLevelDecl::Expr(_)));
        }
        for decl in &mut m.program.decls {
            rename_decl(decl, map);
        }
    }

    // 3. Visibility + direct-import checks, on the renamed forms.
    for (i, m) in loaded.iter().enumerate() {
        let imported: HashSet<&str> = m
            .program
            .imports
            .iter()
            .map(|im| im.module.as_str())
            .collect();
        let own: HashSet<&Ident> = maps[i].values().collect();

        let mut refs: Vec<Ident> = Vec::new();
        for decl in &m.program.decls {
            collect_decl_refs(decl, &mut refs);
        }
        for r in refs {
            if own.contains(&r) {
                continue; // own definition
            }
            if let Some(target_mod) = private_final.get(&r) {
                if *target_mod != m.name {
                    let short = r
                        .strip_prefix(&format!("{target_mod}_"))
                        .unwrap_or(&r)
                        .to_string();
                    return Err(ResolveError {
                        kind: ResolveErrorKind::PrivateAccess {
                            module: target_mod.clone(),
                            name: short,
                            from: m.name.clone(),
                        },
                        path: m.path.clone(),
                    });
                }
            } else if public_final.contains(&r) {
                if let Some(target_mod) = owner.get(&r) {
                    if *target_mod != m.name
                        && *target_mod != root_name
                        && !imported.contains(target_mod.as_str())
                    {
                        let short = r
                            .strip_prefix(&format!("{target_mod}_"))
                            .unwrap_or(&r)
                            .to_string();
                        return Err(ResolveError {
                            kind: ResolveErrorKind::MissingImport {
                                module: target_mod.clone(),
                                name: short,
                                from: m.name.clone(),
                            },
                            path: m.path.clone(),
                        });
                    }
                }
            }
            // Anything else is a builtin or a genuine unbound name; the
            // typechecker reports it with a proper span.
        }
    }

    // 4. Concatenate — dependencies first, root last (its trailing expression
    //    stays the program body).
    let mut decls: Vec<TopLevelDecl> = Vec::new();
    let mut spans: Vec<SpannedDecl> = Vec::new();
    let mut imports = Vec::new();
    let mut public_names = Vec::new();
    for m in loaded {
        if m.name == root_name {
            imports = m.program.imports.clone();
            public_names = m.program.public_names.clone();
        }
        decls.extend(m.program.decls);
        // Spans belong to their own file; a linked program spans several files,
        // so per-decl spans are dropped for imported modules and kept only for
        // the root, whose source is what a diagnostic renders against.
        if m.name == root_name {
            spans = m.program.spans;
        }
    }
    Ok(Program::with_modules(decls, spans, imports, public_names))
}

/// Apply a rename map to a declaration: its own name and its free references.
fn rename_decl(decl: &mut TopLevelDecl, map: &HashMap<Ident, Ident>) {
    match decl {
        TopLevelDecl::Function {
            name, params, body, ..
        } => {
            if let Some(new) = map.get(name) {
                name.clone_from(new);
            }
            // Parameters shadow top-level names inside the body.
            let mut bound: Vec<Ident> = params.iter().map(|(p, _)| p.clone()).collect();
            walk_free_idents(body, &mut bound, &mut |id| {
                if let Some(new) = map.get(id) {
                    id.clone_from(new);
                }
            });
        }
        TopLevelDecl::Binding { name, value } => {
            if let Some(new) = map.get(name) {
                name.clone_from(new);
            }
            let mut bound = Vec::new();
            walk_free_idents(value, &mut bound, &mut |id| {
                if let Some(new) = map.get(id) {
                    id.clone_from(new);
                }
            });
        }
        TopLevelDecl::Expr(e) => {
            let mut bound = Vec::new();
            walk_free_idents(e, &mut bound, &mut |id| {
                if let Some(new) = map.get(id) {
                    id.clone_from(new);
                }
            });
        }
        TopLevelDecl::Test { body, .. } => {
            let mut bound = Vec::new();
            walk_free_idents(body, &mut bound, &mut |id| {
                if let Some(new) = map.get(id) {
                    id.clone_from(new);
                }
            });
        }
        TopLevelDecl::ExternBlock { decls, .. } => {
            for d in decls {
                if let Some(new) = map.get(&d.name) {
                    d.name.clone_from(new);
                }
            }
        }
    }
}

/// Collect every free identifier a declaration references.
fn collect_decl_refs(decl: &TopLevelDecl, out: &mut Vec<Ident>) {
    // The walk needs `&mut Expr`; cloning the body is acceptable here because
    // this runs once per declaration during linking, not in a hot path.
    let mut scratch;
    let (body, mut bound): (&mut Expr, Vec<Ident>) = match decl {
        TopLevelDecl::Function { params, body, .. } => {
            scratch = (**body).clone();
            (&mut scratch, params.iter().map(|(p, _)| p.clone()).collect())
        }
        TopLevelDecl::Binding { value, .. } => {
            scratch = (**value).clone();
            (&mut scratch, Vec::new())
        }
        TopLevelDecl::Expr(e) => {
            scratch = (**e).clone();
            (&mut scratch, Vec::new())
        }
        TopLevelDecl::Test { body, .. } => {
            scratch = (**body).clone();
            (&mut scratch, Vec::new())
        }
        TopLevelDecl::ExternBlock { .. } => return,
    };
    walk_free_idents(body, &mut bound, &mut |id| out.push(id.clone()));
}

/// Visit every FREE identifier reference in `e`, honouring binders.
///
/// `bound` is the binder stack; `f` is applied to each free `Var` name (and may
/// rewrite it in place).
///
/// The `match` below is deliberately exhaustive with **no wildcard arm**: a new
/// `Expr` variant must break this build rather than silently skip renaming and
/// yield a mis-linked program.
fn walk_free_idents<F: FnMut(&mut Ident)>(e: &mut Expr, bound: &mut Vec<Ident>, f: &mut F) {
    match e {
        // ── the only reference site ──────────────────────────────────────
        Expr::Var(name) => {
            if !bound.contains(name) {
                f(name);
            }
        }

        // ── binders ──────────────────────────────────────────────────────
        Expr::Lam(param, _, body) => {
            bound.push(param.clone());
            walk_free_idents(body, bound, f);
            bound.pop();
        }
        Expr::Let(name, _, value, body) => {
            walk_free_idents(value, bound, f); // value is OUTSIDE the binding
            bound.push(name.clone());
            walk_free_idents(body, bound, f);
            bound.pop();
        }
        Expr::LetRec(name, _, value, body) => {
            bound.push(name.clone()); // recursive: in scope in its own value
            walk_free_idents(value, bound, f);
            walk_free_idents(body, bound, f);
            bound.pop();
        }
        Expr::LetRecGroup(entries, cont) => {
            // Every group name is in scope in every value AND the continuation.
            let n = entries.len();
            for (name, _, _) in entries.iter() {
                bound.push(name.clone());
            }
            for (_, _, value) in entries.iter_mut() {
                walk_free_idents(value, bound, f);
            }
            walk_free_idents(cont, bound, f);
            bound.truncate(bound.len() - n);
        }
        Expr::Case(scrutinee, left, left_body, right, right_body) => {
            walk_free_idents(scrutinee, bound, f);
            bound.push(left.clone());
            walk_free_idents(left_body, bound, f);
            bound.pop();
            bound.push(right.clone());
            walk_free_idents(right_body, bound, f);
            bound.pop();
        }
        Expr::Handle(body, name, handler) => {
            walk_free_idents(body, bound, f);
            bound.push(name.clone());
            walk_free_idents(handler, bound, f);
            bound.pop();
        }

        // ── leaves with no identifier references ─────────────────────────
        Expr::Unit
        | Expr::Bool(_)
        | Expr::Int(_)
        | Expr::IntN { .. }
        | Expr::String(_)
        | Expr::Loc(_)
        | Expr::UIColor(..)
        | Expr::UIStyleDecl { .. }
        | Expr::ChoreographyBlock { .. } => {}

        // ── one child ────────────────────────────────────────────────────
        Expr::Fst(a)
        | Expr::Snd(a)
        | Expr::Inl(a, _)
        | Expr::Inr(a, _)
        | Expr::Return(a)
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
        | Expr::ZakatCalculate(a) => walk_free_idents(a, bound, f),

        // ── two children ─────────────────────────────────────────────────
        Expr::App(a, b)
        | Expr::Pair(a, b)
        | Expr::Assign(a, b)
        | Expr::Declassify(a, b)
        | Expr::BinOp(_, a, b)
        | Expr::Spawn(a, b)
        | Expr::ActorSend(a, b)
        | Expr::CRDTMerge(a, b)
        | Expr::ContentVerify(a, b)
        | Expr::UIText(a, b)
        | Expr::UIButton(a, b)
        | Expr::UIContrastCheck(a, b) => {
            walk_free_idents(a, bound, f);
            walk_free_idents(b, bound, f);
        }

        // ── three children ───────────────────────────────────────────────
        Expr::If(a, b, c)
        | Expr::TokenTransfer {
            from: a,
            to: b,
            amount: c,
        } => {
            walk_free_idents(a, bound, f);
            walk_free_idents(b, bound, f);
            walk_free_idents(c, bound, f);
        }

        // ── sequences ────────────────────────────────────────────────────
        Expr::ListLit(items)
        | Expr::UIDisplay(items)
        | Expr::UIRow(items)
        | Expr::UIColumn(items) => {
            for item in items {
                walk_free_idents(item, bound, f);
            }
        }
        Expr::RecordLit(_, fields) => {
            // The record name is a type name and the keys are labels; only the
            // field VALUES are expressions.
            for (_, value) in fields {
                walk_free_idents(value, bound, f);
            }
        }
        Expr::FFICall { args, .. } => {
            // `name` is a foreign symbol, not a RIINA binding.
            for arg in args {
                walk_free_idents(arg, bound, f);
            }
        }
        Expr::ActorDecl {
            init_state,
            handler,
            ..
        } => {
            // `name` declares an actor type, a separate namespace from values.
            walk_free_idents(init_state, bound, f);
            walk_free_idents(handler, bound, f);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn parse(src: &str) -> Expr {
        let mut p = Parser::new(src);
        let prog = p.parse_program().expect("parses");
        prog.desugar()
    }

    /// Rename `f` -> `m_f` in an expression with no shadowing.
    #[test]
    fn renames_free_reference() {
        let mut e = Expr::Var("f".into());
        let map: HashMap<Ident, Ident> = [("f".to_string(), "m_f".to_string())].into();
        let mut bound = Vec::new();
        walk_free_idents(&mut e, &mut bound, &mut |id| {
            if let Some(n) = map.get(id) {
                id.clone_from(n);
            }
        });
        assert_eq!(e, Expr::Var("m_f".into()));
    }

    /// A `let`-bound name shadows a top-level one and must NOT be renamed.
    #[test]
    fn shadowed_name_is_not_renamed() {
        // let f = 1 in f
        let mut e = Expr::Let(
            "f".into(),
            None,
            Box::new(Expr::Int(1)),
            Box::new(Expr::Var("f".into())),
        );
        let map: HashMap<Ident, Ident> = [("f".to_string(), "m_f".to_string())].into();
        let mut bound = Vec::new();
        walk_free_idents(&mut e, &mut bound, &mut |id| {
            if let Some(n) = map.get(id) {
                id.clone_from(n);
            }
        });
        match e {
            Expr::Let(_, _, _, body) => assert_eq!(*body, Expr::Var("f".into())),
            other => panic!("shape changed: {other:?}"),
        }
    }

    /// A lambda parameter shadows a top-level name.
    #[test]
    fn lambda_param_shadows() {
        let mut e = Expr::Lam(
            "x".into(),
            riina_types::Ty::Int,
            Box::new(Expr::Var("x".into())),
        );
        let map: HashMap<Ident, Ident> = [("x".to_string(), "m_x".to_string())].into();
        let mut bound = Vec::new();
        walk_free_idents(&mut e, &mut bound, &mut |id| {
            if let Some(n) = map.get(id) {
                id.clone_from(n);
            }
        });
        match e {
            Expr::Lam(_, _, body) => assert_eq!(*body, Expr::Var("x".into())),
            other => panic!("shape changed: {other:?}"),
        }
    }

    /// The value of a non-recursive `let` is OUTSIDE the binding, so a
    /// reference there still renames.
    #[test]
    fn let_value_is_outside_its_own_binding() {
        let mut e = Expr::Let(
            "f".into(),
            None,
            Box::new(Expr::Var("f".into())),
            Box::new(Expr::Unit),
        );
        let map: HashMap<Ident, Ident> = [("f".to_string(), "m_f".to_string())].into();
        let mut bound = Vec::new();
        walk_free_idents(&mut e, &mut bound, &mut |id| {
            if let Some(n) = map.get(id) {
                id.clone_from(n);
            }
        });
        match e {
            Expr::Let(_, _, value, _) => assert_eq!(*value, Expr::Var("m_f".into())),
            other => panic!("shape changed: {other:?}"),
        }
    }

    /// The binder stack must be restored exactly (a truncate bug here would
    /// leak binders into sibling expressions and silently skip renames).
    #[test]
    fn letrecgroup_restores_binder_stack() {
        let mut e = Expr::Pair(
            Box::new(Expr::LetRecGroup(
                vec![("g".into(), riina_types::Ty::Int, Expr::Var("g".into()))],
                Box::new(Expr::Unit),
            )),
            Box::new(Expr::Var("g".into())),
        );
        let map: HashMap<Ident, Ident> = [("g".to_string(), "m_g".to_string())].into();
        let mut bound = Vec::new();
        walk_free_idents(&mut e, &mut bound, &mut |id| {
            if let Some(n) = map.get(id) {
                id.clone_from(n);
            }
        });
        assert!(bound.is_empty(), "binder stack leaked: {bound:?}");
        match e {
            // Inside the group `g` is bound (not renamed); outside it is free.
            Expr::Pair(_, rhs) => assert_eq!(*rhs, Expr::Var("m_g".into())),
            other => panic!("shape changed: {other:?}"),
        }
    }

    /// A real program body walks without panicking and renames the call site.
    #[test]
    fn renames_call_site_in_parsed_program() {
        let mut e = parse("fungsi utama() -> Nombor kesan Bersih { tambah(1) }");
        let map: HashMap<Ident, Ident> = [("tambah".to_string(), "kira_tambah".to_string())].into();
        let mut bound = Vec::new();
        let mut seen = Vec::new();
        walk_free_idents(&mut e, &mut bound, &mut |id| {
            if let Some(n) = map.get(id) {
                id.clone_from(n);
            }
            seen.push(id.clone());
        });
        assert!(
            seen.contains(&"kira_tambah".to_string()),
            "call site not renamed; saw {seen:?}"
        );
    }
}
