// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! File I/O builtins (fail) — REAL host-filesystem access gated by the
//! **verified** access-control predicates.
//!
//! Owner-approved semantic change (2026-08-09, the Gate C "wire `VirtualFs`
//! into the surface `file_*` builtins" item): every content operation here is
//! now gated by the same `riina_os::vfs` predicates the Coq theorems in
//! `02_FORMAL/coq/domains/VerifiedFileSystem.v` prove sound (`can_read` /
//! `can_write`, owner▷group▷other resolution, root override). The pattern is
//! the networking one: REAL I/O, with the verified model enforced on top.
//!
//! Mechanics (path→inode→uid): a thread-local metadata mirror maps each host
//! canonical path to a verified [`Inode`] on first touch — owned by the CURRENT access
//! context's uid (the one `vfs_jadi_pengguna` switches; shared with the
//! `vfs_*` world via `vfs::current_ctx`), mode 0644 like `vfs_tulis` creates.
//! Reads require `can_read`, writes/appends `can_write`, delete `can_write`
//! (and clears the mapping after successful removal, so a re-created file is
//! owned by its re-creator).
//!
//! What is REAL vs MODELLED (no overclaiming):
//!   * The I/O is REAL (std::fs on the host). The ENFORCEMENT is the verified
//!     model applied to this run's own operations: the host OS's real uid
//!     model is not portably visible, so first-touch assigns ownership under
//!     the session's identity — within a run, cross-uid access is then
//!     rejected exactly when the Coq predicates say so.
//!   * `fail_ada`/`fail_senarai` (existence / directory listing) are metadata
//!     queries the Coq model has no predicate for — deliberately ungated.
//!   * Byte quotas remain a `vfs_*`-world concern (in-memory store); the host
//!     gate enforces permissions, not quota.
//!   * Paths resolve through directory and symlink aliases before lookup.
//!     This is not a host sandbox: hard links and concurrent external path
//!     replacements require object-identity/handle-based enforcement beyond
//!     this session metadata mirror.

use crate::value::Value;
use crate::{Error, Result};
use riina_os::vfs::{Inode, Ownership, Permission};
use std::cell::RefCell;
use std::collections::HashMap;
use std::path::{Path, PathBuf};

/// Metadata-only mirror: path → verified inode. Content lives on the host FS;
/// ONLY the access-control metadata (the part the Coq theorems govern) is
/// mirrored here.
struct HostGate {
    inodes: HashMap<PathBuf, Inode>,
    next_id: u64,
}

thread_local! {
    static GATE: RefCell<HostGate> = RefCell::new(HostGate {
        inodes: HashMap::new(),
        next_id: 0,
    });
}

fn denied(op: &str, path: &str, pred: &str) -> Error {
    Error::InvalidOperation(format!(
        "{op}: '{path}': permission denied (verified {pred} is false for the current uid)"
    ))
}

/// Look up (or first-touch register) the path's inode and check `pred` under
/// the current shared access context.
fn path_key(path: &str) -> Result<PathBuf> {
    let input = Path::new(path);
    let resolved = input.canonicalize().or_else(|original| {
        if original.kind() != std::io::ErrorKind::NotFound {
            return Err(original);
        }
        // A dangling symlink must not acquire a new owner under its alias.
        if std::fs::symlink_metadata(input).is_ok() {
            return Err(original);
        }
        // Creation may target a missing leaf, but its existing parent must
        // still resolve through the same directory/symlink aliases.
        let Some(leaf) = input.file_name() else { return Err(original) };
        let parent = input.parent().filter(|p| !p.as_os_str().is_empty())
            .unwrap_or_else(|| Path::new("."));
        Ok(parent.canonicalize()?.join(leaf))
    });
    resolved.map_err(|e| Error::InvalidOperation(format!("file access: cannot resolve '{path}': {e}")))
}

fn gate(path: &str, pred: impl Fn(&Inode, &riina_os::vfs::AccessContext) -> bool) -> Result<bool> {
    let key = path_key(path)?;
    let ctx = super::vfs::current_ctx();
    Ok(GATE.with(|g| {
        let st = &mut *g.borrow_mut();
        let next = st.next_id;
        let inode = st.inodes.entry(key).or_insert_with(|| {
            // First touch: owned by the current uid, mode 0644 — the same
            // modes vfs_tulis creates with (owner rw, group/other r).
            Inode {
                id: next,
                owner: Ownership {
                    uid: ctx.uid,
                    gid: ctx.gid,
                },
                perm_owner: Permission::READ_WRITE,
                perm_group: Permission::READ_ONLY,
                perm_other: Permission::READ_ONLY,
                is_directory: false,
                size: 0,
            }
        });
        if inode.id == next {
            st.next_id += 1;
        }
        pred(inode, &ctx)
    }))
}

/// Gate a read op — Coq `can_read`. Exposed for the `file_*_safe` twins in
/// `builtins::keselamatan`, which perform the same host I/O.
pub(crate) fn gate_read(op: &str, path: &str) -> Result<()> {
    if gate(path, |i, c| i.can_read(c))? {
        Ok(())
    } else {
        Err(denied(op, path, "can_read"))
    }
}

/// Gate a write/append op — Coq `can_write`.
pub(crate) fn gate_write(op: &str, path: &str) -> Result<()> {
    if gate(path, |i, c| i.can_write(c))? {
        Ok(())
    } else {
        Err(denied(op, path, "can_write"))
    }
}

/// Delete only after the Coq `can_write` gate. Retain ownership if the OS
/// rejects deletion, or deletion only removes a symlink to a live target.
pub(crate) fn delete_file(op: &str, path: &str) -> Result<bool> {
    let key = path_key(path)?;
    gate_write(op, path)?;
    let deleted = std::fs::remove_file(path).is_ok();
    if deleted && !key.exists() {
        GATE.with(|g| g.borrow_mut().inodes.remove(&key));
    }
    Ok(deleted)
}

/// (BM name, EN alias, canonical name)
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("fail_baca", "file_read", "fail_baca"),
    ("fail_tulis", "file_write", "fail_tulis"),
    ("fail_tambah", "file_append", "fail_tambah"),
    ("fail_ada", "file_exists", "fail_ada"),
    ("fail_buang", "file_delete", "fail_buang"),
    ("fail_panjang", "file_size", "fail_panjang"),
    ("fail_senarai", "file_list_dir", "fail_senarai"),
    ("fail_baca_baris", "file_read_lines", "fail_baca_baris"),
];

pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    match name {
        "fail_baca" => {
            // Teks -> Teks
            let path = extract_string(arg, "fail_baca")?;
            gate_read("fail_baca", &path)?;
            let content = std::fs::read_to_string(&path).map_err(|e| {
                Error::InvalidOperation(format!("fail_baca: cannot read '{}': {}", path, e))
            })?;
            Ok(Some(Value::String(content)))
        }
        "fail_tulis" => {
            // (Teks, Teks) -> ()
            let (path, content) = extract_pair_strings(arg, "fail_tulis")?;
            gate_write("fail_tulis", &path)?;
            std::fs::write(&path, &content).map_err(|e| {
                Error::InvalidOperation(format!("fail_tulis: cannot write '{}': {}", path, e))
            })?;
            Ok(Some(Value::Unit))
        }
        "fail_tambah" => {
            // (Teks, Teks) -> ()
            let (path, content) = extract_pair_strings(arg, "fail_tambah")?;
            gate_write("fail_tambah", &path)?;
            use std::io::Write;
            let mut f = std::fs::OpenOptions::new()
                .create(true)
                .append(true)
                .open(&path)
                .map_err(|e| {
                    Error::InvalidOperation(format!("fail_tambah: cannot open '{}': {}", path, e))
                })?;
            f.write_all(content.as_bytes())
                .map_err(|e| Error::InvalidOperation(format!("fail_tambah: write error: {}", e)))?;
            Ok(Some(Value::Unit))
        }
        "fail_ada" => {
            // Teks -> Bool
            let path = extract_string(arg, "fail_ada")?;
            Ok(Some(Value::Bool(std::path::Path::new(&path).exists())))
        }
        "fail_buang" => {
            // Teks -> Bool
            let path = extract_string(arg, "fail_buang")?;
            let ok = delete_file("fail_buang", &path)?;
            Ok(Some(Value::Bool(ok)))
        }
        "fail_panjang" => {
            // Teks -> Int
            let path = extract_string(arg, "fail_panjang")?;
            gate_read("fail_panjang", &path)?;
            let meta = std::fs::metadata(&path).map_err(|e| {
                Error::InvalidOperation(format!("fail_panjang: cannot stat '{}': {}", path, e))
            })?;
            Ok(Some(Value::Int(meta.len())))
        }
        "fail_senarai" => {
            // Teks -> List<Teks>
            let path = extract_string(arg, "fail_senarai")?;
            let entries = std::fs::read_dir(&path).map_err(|e| {
                Error::InvalidOperation(format!("fail_senarai: cannot read dir '{}': {}", path, e))
            })?;
            let mut items = Vec::new();
            for e in entries.flatten() {
                if let Some(name) = e.file_name().to_str() {
                    items.push(Value::String(name.to_string()));
                }
            }
            Ok(Some(Value::List(items)))
        }
        "fail_baca_baris" => {
            // Teks -> List<Teks>
            let path = extract_string(arg, "fail_baca_baris")?;
            gate_read("fail_baca_baris", &path)?;
            let content = std::fs::read_to_string(&path).map_err(|e| {
                Error::InvalidOperation(format!("fail_baca_baris: cannot read '{}': {}", path, e))
            })?;
            let lines: Vec<Value> = content
                .lines()
                .map(|l| Value::String(l.to_string()))
                .collect();
            Ok(Some(Value::List(lines)))
        }
        _ => Ok(None),
    }
}

fn extract_string(v: &Value, ctx: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        _ => Err(type_err("string", v, ctx)),
    }
}

fn extract_pair_strings(v: &Value, ctx: &str) -> Result<(String, String)> {
    match v {
        Value::Pair(a, b) => {
            let sa = extract_string(a, ctx)?;
            let sb = extract_string(b, ctx)?;
            Ok((sa, sb))
        }
        _ => Err(type_err("(string, string)", v, ctx)),
    }
}

fn type_err(expected: &str, found: &Value, ctx: &str) -> Error {
    Error::TypeMismatch {
        expected: expected.to_string(),
        found: format!("{:?}", found),
        context: ctx.to_string(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fail_tulis_baca() {
        let tmp = std::env::temp_dir().join("riina_test_fail.txt");
        let path = tmp.to_str().unwrap().to_string();

        // Write
        let arg = Value::Pair(
            Box::new(Value::String(path.clone())),
            Box::new(Value::String("hello riina".to_string())),
        );
        assert_eq!(apply("fail_tulis", &arg).unwrap(), Some(Value::Unit));

        // Read
        let result = apply("fail_baca", &Value::String(path.clone()))
            .unwrap()
            .unwrap();
        assert_eq!(result, Value::String("hello riina".to_string()));

        // Exists
        assert_eq!(
            apply("fail_ada", &Value::String(path.clone())).unwrap(),
            Some(Value::Bool(true))
        );

        // Size
        let size = apply("fail_panjang", &Value::String(path.clone()))
            .unwrap()
            .unwrap();
        assert_eq!(size, Value::Int(11));

        // Delete
        assert_eq!(
            apply("fail_buang", &Value::String(path.clone())).unwrap(),
            Some(Value::Bool(true))
        );

        // No longer exists
        assert_eq!(
            apply("fail_ada", &Value::String(path)).unwrap(),
            Some(Value::Bool(false))
        );
    }

    #[test]
    fn test_fail_tambah() {
        let tmp = std::env::temp_dir().join("riina_test_append.txt");
        let path = tmp.to_str().unwrap().to_string();

        // Write initial
        let _ = std::fs::write(&path, "line1\n");
        let arg = Value::Pair(
            Box::new(Value::String(path.clone())),
            Box::new(Value::String("line2\n".to_string())),
        );
        apply("fail_tambah", &arg).unwrap();

        let content = std::fs::read_to_string(&path).unwrap();
        assert_eq!(content, "line1\nline2\n");
        let _ = std::fs::remove_file(&path);
    }

    #[test]
    fn test_fail_baca_baris() {
        let tmp = std::env::temp_dir().join("riina_test_lines.txt");
        let path = tmp.to_str().unwrap().to_string();
        std::fs::write(&path, "a\nb\nc").unwrap();

        let result = apply("fail_baca_baris", &Value::String(path.clone()))
            .unwrap()
            .unwrap();
        assert_eq!(
            result,
            Value::List(vec![
                Value::String("a".to_string()),
                Value::String("b".to_string()),
                Value::String("c".to_string()),
            ])
        );
        let _ = std::fs::remove_file(&path);
    }

    #[test]
    fn test_fail_senarai() {
        let tmp = std::env::temp_dir().join("riina_test_dir");
        let _ = std::fs::create_dir_all(&tmp);
        std::fs::write(tmp.join("a.txt"), "").unwrap();
        std::fs::write(tmp.join("b.txt"), "").unwrap();

        let result = apply(
            "fail_senarai",
            &Value::String(tmp.to_str().unwrap().to_string()),
        )
        .unwrap()
        .unwrap();
        match result {
            Value::List(items) => assert!(items.len() >= 2),
            _ => panic!("expected list"),
        }
        let _ = std::fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_unknown_returns_none() {
        assert_eq!(apply("unknown", &Value::Unit).unwrap(), None);
    }

    /// Become a uid in the SHARED access-control world (the same context
    /// vfs_jadi_pengguna switches), restoring the default on drop so a
    /// panicking assertion cannot leak the identity into later code.
    fn as_uid(uid: u64) {
        crate::builtins::vfs::apply("vfs_jadi_pengguna", &Value::Int(uid)).unwrap();
    }

    /// The owner-approved semantic change: a file first touched by uid A is
    /// owned by A (mode 0644), so uid B can READ it but a WRITE/DELETE by B
    /// is rejected by the verified can_write — real host I/O never happens
    /// for the denied op.
    #[test]
    fn cross_uid_write_and_delete_are_denied_read_allowed() {
        let tmp = std::env::temp_dir().join("riina_gate_cross_uid.txt");
        let path = tmp.to_str().unwrap().to_string();
        as_uid(1000);
        let write = |data: &str| {
            Value::Pair(
                Box::new(Value::String(path.clone())),
                Box::new(Value::String(data.to_string())),
            )
        };
        apply("fail_tulis", &write("owned by 1000")).unwrap();

        as_uid(2000);
        // other = r: reading is allowed…
        assert_eq!(
            apply("fail_baca", &Value::String(path.clone())).unwrap(),
            Some(Value::String("owned by 1000".to_string()))
        );
        // …but overwrite, append and delete are rejected by the model.
        for (op, arg) in [
            ("fail_tulis", write("hijacked")),
            ("fail_tambah", write("hijacked")),
            ("fail_buang", Value::String(path.clone())),
        ] {
            let res = apply(op, &arg);
            assert!(
                matches!(&res, Err(Error::InvalidOperation(m)) if m.contains("permission denied")),
                "{op} by a non-owner must be denied, got {res:?}"
            );
        }
        // The denied write really did not happen on the host.
        assert_eq!(std::fs::read_to_string(&path).unwrap(), "owned by 1000");

        // The owner can still delete.
        as_uid(1000);
        assert_eq!(
            apply("fail_buang", &Value::String(path.clone())).unwrap(),
            Some(Value::Bool(true))
        );
    }

    /// Delete clears the mapping: a re-created file belongs to its re-creator
    /// (VFS delete-then-create semantics).
    #[test]
    fn recreate_after_delete_transfers_ownership() {
        let tmp = std::env::temp_dir().join("riina_gate_recreate.txt");
        let path = tmp.to_str().unwrap().to_string();
        as_uid(1000);
        let write = |data: &str| {
            Value::Pair(
                Box::new(Value::String(path.clone())),
                Box::new(Value::String(data.to_string())),
            )
        };
        apply("fail_tulis", &write("v1")).unwrap();
        apply("fail_buang", &Value::String(path.clone())).unwrap();

        as_uid(2000);
        apply("fail_tulis", &write("v2 owned by 2000")).unwrap();
        as_uid(1000);
        let res = apply("fail_tulis", &write("takeover"));
        assert!(
            matches!(&res, Err(Error::InvalidOperation(m)) if m.contains("permission denied")),
            "after re-creation by 2000, uid 1000 must be denied, got {res:?}"
        );
        as_uid(2000);
        apply("fail_buang", &Value::String(path)).unwrap();
        as_uid(1000);
    }

    /// The file_*_safe twins go through the SAME gate.
    #[test]
    fn safe_twins_share_the_gate() {
        let tmp = std::env::temp_dir().join("riina_gate_safe_twin.txt");
        let path = tmp.to_str().unwrap().to_string();
        as_uid(1000);
        gate_write("test", &path).unwrap(); // register ownership as 1000
        as_uid(2000);
        let res = gate_write("file_write_safe", &path);
        assert!(
            matches!(&res, Err(Error::InvalidOperation(m)) if m.contains("permission denied")),
            "safe twin must be denied via the shared gate, got {res:?}"
        );
        as_uid(1000);
        GATE.with(|g| g.borrow_mut().inodes.remove(&path_key(&path).unwrap()));
    }

    #[test]
    fn path_aliases_do_not_reset_ownership() {
        let dir = std::env::temp_dir().join(format!("riina_gate_alias_{}", std::process::id()));
        std::fs::create_dir_all(dir.join("child")).unwrap();
        let path = dir.join("owned.txt").to_string_lossy().into_owned();
        as_uid(1000);
        apply("fail_tulis", &Value::Pair(
            Box::new(Value::String(path.clone())),
            Box::new(Value::String("owner data".into())),
        )).unwrap();
        let aliases = vec![dir.join(".").join("owned.txt"), dir.join("child").join("..").join("owned.txt")];
        #[cfg(windows)]
        let aliases = {
            let mut aliases = aliases;
            aliases.push(PathBuf::from(path.to_uppercase()));
            aliases
        };
        as_uid(2000);
        for alias in aliases {
            let alias = alias.to_string_lossy().into_owned();
            assert!(matches!(gate_write("test", &alias), Err(Error::InvalidOperation(m)) if m.contains("permission denied")), "alias {alias}");
            assert!(super::super::keselamatan::apply("file_delete_safe", &Value::String(alias)).is_err());
        }
        assert_eq!(std::fs::read_to_string(&path).unwrap(), "owner data");
        as_uid(1000);
        delete_file("test", &path).unwrap();
        std::fs::remove_dir(dir.join("child")).unwrap();
        std::fs::remove_dir(dir).unwrap();
    }

    #[test]
    fn failed_delete_preserves_owner_for_both_surfaces() {
        for op in ["fail_buang", "file_delete_safe"] {
            let dir = std::env::temp_dir().join(format!("riina_gate_failed_delete_{op}_{}", std::process::id()));
            std::fs::create_dir_all(&dir).unwrap();
            let path = dir.to_string_lossy().into_owned();
            as_uid(1000);
            gate_write("test", &path).unwrap();
            let result = if op == "fail_buang" {
                apply(op, &Value::String(path.clone()))
            } else {
                super::super::keselamatan::apply(op, &Value::String(path.clone()))
            };
            assert_eq!(result.unwrap(), Some(Value::Bool(false)));
            as_uid(2000);
            assert!(matches!(gate_write("test", &path), Err(Error::InvalidOperation(m)) if m.contains("permission denied")));
            as_uid(1000);
            std::fs::remove_dir(dir).unwrap();
        }
    }

    #[cfg(unix)]
    #[test]
    fn symlink_alias_shares_ownership_even_after_link_deletion() {
        let dir = std::env::temp_dir().join(format!("riina_gate_symlink_{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let target = dir.join("target");
        let alias = dir.join("alias");
        std::fs::write(&target, "owner data").unwrap();
        std::os::unix::fs::symlink(&target, &alias).unwrap();
        as_uid(1000);
        gate_write("test", target.to_str().unwrap()).unwrap();
        as_uid(2000);
        assert!(gate_write("test", alias.to_str().unwrap()).is_err());
        as_uid(1000);
        assert!(delete_file("test", alias.to_str().unwrap()).unwrap());
        as_uid(2000);
        assert!(gate_write("test", target.to_str().unwrap()).is_err());
        as_uid(1000);
        delete_file("test", target.to_str().unwrap()).unwrap();
        std::fs::remove_dir(dir).unwrap();
    }
}
