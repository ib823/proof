// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Virtual filesystem builtins (`vfs_*`) — runtime access to the **verified**
//! access-control model.
//!
//! These expose `riina_os::vfs::VirtualFs` — the in-memory filesystem that is a
//! 1:1 port of `02_FORMAL/coq/domains/VerifiedFileSystem.v` (`can_read`,
//! `can_write`, the byte/inode `Quota`, the committed `Journal`) — to RIINA
//! programs. Every `vfs_tulis`/`vfs_baca`/`vfs_padam` is gated by the same
//! predicates the Coq theorems prove sound: a cross-user write is rejected with
//! `permission denied` exactly when `Inode::can_write` is false, and a write
//! past the quota with `quota exceeded` exactly when `Quota::can_allocate_bytes`
//! is false. So the proven model governs observable runtime behaviour.
//!
//! Design (the "wire VirtualFs to the surface" item): a path→inode map plus a
//! current `AccessContext` live in a thread-local enforcing `VirtualFs`. This is
//! an *additive* `vfs_*` API alongside the host-FS `fail_*`/`file_*` builtins —
//! it does not change their semantics. Newly-created files get owner `rw`,
//! group/other `r` (mode 0644), so another user can read but not overwrite them.
//! `vfs_mula` re-initialises the thread-local (also giving tests a clean slate).
//!
//! Interpreter-only: not registered in codegen's `builtin_canonical`, so the
//! C/WASM backends fail closed (unbound `vfs_*`) rather than miscompiling.

use crate::value::Value;
use crate::{Error, Result};
use riina_os::vfs::{AccessContext, Ownership, Permission, Quota, VfsError, VirtualFs};
use std::cell::RefCell;
use std::collections::HashMap;

/// (BM name, EN name, canonical key).
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("vfs_mula", "vfs_init", "vfs_mula"),
    ("vfs_jadi_pengguna", "vfs_become_user", "vfs_jadi_pengguna"),
    ("vfs_tulis", "vfs_write", "vfs_tulis"),
    ("vfs_baca", "vfs_read", "vfs_baca"),
    ("vfs_padam", "vfs_delete", "vfs_padam"),
];

struct VfsState {
    fs: VirtualFs,
    paths: HashMap<String, u64>,
    ctx: AccessContext,
}

const DEFAULT_UID: u64 = 1000;
const DEFAULT_INODE_LIMIT: u64 = 4096;

fn ctx_for(uid: u64) -> AccessContext {
    AccessContext {
        uid,
        gid: uid,
        groups: vec![uid],
        is_root: false,
    }
}

impl VfsState {
    fn new(limit_bytes: u64) -> Self {
        let quota = Quota {
            uid: DEFAULT_UID,
            limit_bytes,
            limit_inodes: DEFAULT_INODE_LIMIT,
            used_bytes: 0,
            used_inodes: 0,
        };
        VfsState {
            fs: VirtualFs::new(quota),
            paths: HashMap::new(),
            ctx: ctx_for(DEFAULT_UID),
        }
    }
}

thread_local! {
    /// A generous default so programs that never call `vfs_mula` still work; the
    /// quota only bites once `vfs_mula` sets a smaller limit.
    static VFS: RefCell<VfsState> = RefCell::new(VfsState::new(u64::MAX));
}

/// The current access context (uid switched by `vfs_jadi_pengguna`) — shared
/// with the host-FS gate in `builtins::fail`, so the interpreter has ONE
/// verified access-control world: `vfs_*` stores in memory, `fail_*` touches
/// the host FS, and both are gated by the same Coq predicates under the same
/// identity.
pub(crate) fn current_ctx() -> AccessContext {
    VFS.with(|v| v.borrow().ctx.clone())
}

fn vfs_err(e: VfsError) -> Error {
    Error::InvalidOperation(
        match e {
            VfsError::PermissionDenied => "vfs: permission denied",
            VfsError::QuotaExceeded => "vfs: quota exceeded",
            VfsError::NotFound => "vfs: not found",
        }
        .to_string(),
    )
}

pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    let result = match name {
        // Re-initialise the thread-local FS with a byte quota; resets users,
        // paths, and journal (also a clean slate between programs/tests).
        "vfs_mula" => {
            let limit = as_int(arg, name)?;
            VFS.with(|v| *v.borrow_mut() = VfsState::new(limit));
            Value::Unit
        }
        // Act as a different uid (the verified access check uses this context).
        "vfs_jadi_pengguna" => {
            let uid = as_int(arg, name)?;
            VFS.with(|v| v.borrow_mut().ctx = ctx_for(uid));
            Value::Unit
        }
        // Create-if-absent (mode 0644, owned by the current user) then write,
        // gated by `can_write` + the byte quota. A curried `vfs_tulis(p, d)`
        // arrives one arg at a time, so a non-pair defers via `BuiltinPartial`.
        "vfs_tulis" => {
            let Value::Pair(_, _) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let (path, data) = as_pair_strings(arg, name)?;
            VFS.with(|v| -> Result<Value> {
                let st = &mut *v.borrow_mut();
                let ctx = st.ctx.clone();
                let id = match st.paths.get(&path) {
                    Some(&id) => id,
                    None => {
                        let owner = Ownership {
                            uid: ctx.uid,
                            gid: ctx.gid,
                        };
                        let id = st
                            .fs
                            .create(
                                owner,
                                Permission::READ_WRITE,
                                Permission::READ_ONLY,
                                Permission::READ_ONLY,
                                false,
                            )
                            .map_err(vfs_err)?;
                        st.paths.insert(path.clone(), id);
                        id
                    }
                };
                st.fs.write(&ctx, id, data.as_bytes()).map_err(vfs_err)?;
                Ok(Value::Unit)
            })?
        }
        // Read, gated by `can_read`.
        "vfs_baca" => {
            let path = as_str(arg, name)?;
            VFS.with(|v| -> Result<Value> {
                let st = &*v.borrow();
                let id = *st
                    .paths
                    .get(&path)
                    .ok_or_else(|| vfs_err(VfsError::NotFound))?;
                let bytes = st.fs.read(&st.ctx, id).map_err(vfs_err)?;
                Ok(Value::String(String::from_utf8_lossy(bytes).into_owned()))
            })?
        }
        // Delete, gated by `can_write`. Returns `true` on success.
        "vfs_padam" => {
            let path = as_str(arg, name)?;
            VFS.with(|v| -> Result<Value> {
                let st = &mut *v.borrow_mut();
                let ctx = st.ctx.clone();
                let id = *st
                    .paths
                    .get(&path)
                    .ok_or_else(|| vfs_err(VfsError::NotFound))?;
                st.fs.delete(&ctx, id).map_err(vfs_err)?;
                st.paths.remove(&path);
                Ok(Value::Bool(true))
            })?
        }
        _ => return Ok(None),
    };
    Ok(Some(result))
}

fn as_int(v: &Value, ctx: &str) -> Result<u64> {
    match v {
        Value::Int(n) => Ok(*n),
        Value::IntN { value, .. } => Ok(*value),
        _ => Err(type_err("int", v, ctx)),
    }
}

fn as_str(v: &Value, ctx: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        _ => Err(type_err("string", v, ctx)),
    }
}

fn as_pair_strings(v: &Value, ctx: &str) -> Result<(String, String)> {
    match v {
        Value::Pair(a, b) => Ok((as_str(a, ctx)?, as_str(b, ctx)?)),
        _ => Err(type_err("(string, string)", v, ctx)),
    }
}

fn type_err(expected: &str, found: &Value, ctx: &str) -> Error {
    Error::TypeMismatch {
        expected: expected.to_string(),
        found: format!("{found:?}"),
        context: ctx.to_string(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn s(x: &str) -> Value {
        Value::String(x.to_string())
    }
    fn pair(a: &str, b: &str) -> Value {
        Value::Pair(Box::new(s(a)), Box::new(s(b)))
    }

    #[test]
    fn write_then_read_roundtrip() {
        apply("vfs_mula", &Value::Int(1_000_000)).unwrap();
        assert_eq!(
            apply("vfs_tulis", &pair("doc.txt", "hello")).unwrap(),
            Some(Value::Unit)
        );
        assert_eq!(
            apply("vfs_baca", &s("doc.txt")).unwrap(),
            Some(Value::String("hello".to_string()))
        );
    }

    #[test]
    fn cross_user_write_is_permission_denied() {
        apply("vfs_mula", &Value::Int(1_000_000)).unwrap();
        // User 1000 creates and writes doc (owner rw, other r).
        apply("vfs_tulis", &pair("shared.txt", "owned by 1000")).unwrap();
        // Become a different user; reading is allowed (other r) ...
        apply("vfs_jadi_pengguna", &Value::Int(2000)).unwrap();
        assert_eq!(
            apply("vfs_baca", &s("shared.txt")).unwrap(),
            Some(Value::String("owned by 1000".to_string()))
        );
        // ... but overwriting is denied by the verified `can_write`.
        let err = apply("vfs_tulis", &pair("shared.txt", "hijacked"));
        assert!(
            matches!(&err, Err(Error::InvalidOperation(m)) if m.contains("permission denied")),
            "cross-user write must be PermissionDenied, got {err:?}"
        );
    }

    #[test]
    fn write_past_quota_is_quota_exceeded() {
        // A 4-byte byte quota: the first small write fits, a larger one does not.
        apply("vfs_mula", &Value::Int(4)).unwrap();
        assert_eq!(
            apply("vfs_tulis", &pair("a.txt", "abcd")).unwrap(),
            Some(Value::Unit)
        );
        let err = apply("vfs_tulis", &pair("b.txt", "too big"));
        assert!(
            matches!(&err, Err(Error::InvalidOperation(m)) if m.contains("quota exceeded")),
            "over-quota write must be QuotaExceeded, got {err:?}"
        );
    }

    #[test]
    fn read_missing_is_not_found() {
        apply("vfs_mula", &Value::Int(1000)).unwrap();
        let err = apply("vfs_baca", &s("nope.txt"));
        assert!(matches!(&err, Err(Error::InvalidOperation(m)) if m.contains("not found")));
    }

    #[test]
    fn owner_delete_succeeds() {
        apply("vfs_mula", &Value::Int(1000)).unwrap();
        apply("vfs_tulis", &pair("tmp.txt", "x")).unwrap();
        assert_eq!(
            apply("vfs_padam", &s("tmp.txt")).unwrap(),
            Some(Value::Bool(true))
        );
        // Now gone.
        assert!(apply("vfs_baca", &s("tmp.txt")).is_err());
    }

    #[test]
    fn unknown_name_returns_none() {
        assert_eq!(apply("not_a_vfs_builtin", &Value::Unit).unwrap(), None);
    }
}
