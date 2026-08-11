// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Durable key–value store builtins (`simpan_*`) — the persistence half of
//! master plan REQ-73.
//!
//! These expose [`riina_os::store`], the log-structured store whose on-disk
//! journal realises the `VerifiedFileSystem.v` model: a record counts only when
//! committed (length prefix + CRC-32 both valid), and a torn tail from a crash
//! is discarded on recovery because the model says a pending transaction makes
//! the journal inconsistent.
//!
//! # Why this exists alongside `fail_*` and `vfs_*`
//!
//! * `fail_*`/`file_*` are raw whole-file reads and writes: a crash midway
//!   through `fail_tulis` truncates the file and the previous contents are
//!   gone. Fine for config, not a place to keep application state.
//! * `vfs_*` implements the verified access-control model but lives **in
//!   memory** — nothing survives the process.
//! * `simpan_*` is durable: every put and delete is `fsync`ed before the call
//!   returns, so it survives power loss, and reopening replays the journal.
//!
//! # Handles
//!
//! `simpan_buka` returns a small integer handle into a thread-local table,
//! matching the convention `jaring_*` already uses for sockets. Operating on an
//! unknown or closed handle is an error, never a silent no-op.
//!
//! Interpreter-only: not registered in codegen's `builtin_canonical`, so the
//! C/WASM backends fail closed (unbound `simpan_*`) rather than miscompiling
//! (REQ-70).

use crate::value::Value;
use crate::{Error, Result};
use riina_os::store::Store;
use std::cell::RefCell;
use std::collections::HashMap;

/// (BM name, EN name, canonical key).
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("simpan_buka", "store_open", "simpan_buka"),
    ("simpan_letak", "store_put", "simpan_letak"),
    ("simpan_dapat", "store_get", "simpan_dapat"),
    ("simpan_ada", "store_has", "simpan_ada"),
    ("simpan_padam", "store_delete", "simpan_padam"),
    ("simpan_kunci", "store_keys", "simpan_kunci"),
    ("simpan_padat", "store_compact", "simpan_padat"),
    ("simpan_tutup", "store_close", "simpan_tutup"),
];

#[derive(Default)]
struct StoreTable {
    next_id: u64,
    open: HashMap<u64, Store>,
}

thread_local! {
    static STORES: RefCell<StoreTable> = RefCell::new(StoreTable::default());
}

fn err(msg: impl Into<String>) -> Error {
    Error::InvalidOperation(msg.into())
}

fn as_str(v: &Value, name: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        other => Err(err(format!("{name}: expected a string, got {other:?}"))),
    }
}

fn as_id(v: &Value, name: &str) -> Result<u64> {
    match v {
        Value::Int(n) => Ok(*n),
        other => Err(err(format!("{name}: expected a store handle, got {other:?}"))),
    }
}

/// Run `f` against an open store, or fail loudly for an unknown handle.
fn with_store<T>(id: u64, name: &str, f: impl FnOnce(&mut Store) -> Result<T>) -> Result<T> {
    STORES.with(|t| {
        let st = &mut *t.borrow_mut();
        let store = st
            .open
            .get_mut(&id)
            .ok_or_else(|| err(format!("{name}: unknown or closed store handle {id}")))?;
        f(store)
    })
}

/// Apply a store builtin. `Ok(None)` ⇒ not ours; dispatch falls through.
///
/// # Errors
/// Propagates the store's own diagnostic (IO failure, bad magic, oversized key
/// or value) and rejects unknown handles.
pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    let result = match name {
        // `path -> handle`. Creates the store if absent; replays and repairs
        // the journal if present.
        "simpan_buka" => {
            let path = as_str(arg, name)?;
            let store = Store::open(&path).map_err(|e| err(format!("simpan: {e}")))?;
            STORES.with(|t| {
                let st = &mut *t.borrow_mut();
                let id = st.next_id;
                st.next_id += 1;
                st.open.insert(id, store);
                Value::Int(id)
            })
        }

        // `(handle, (key, value)) -> true`. Durable on return.
        "simpan_letak" => {
            let Value::Pair(id, rest) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let id = as_id(id, name)?;
            let Value::Pair(key, value) = &**rest else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let key = as_str(key, name)?;
            let value = as_str(value, name)?;
            with_store(id, name, |s| {
                s.put(key.as_bytes(), value.as_bytes())
                    .map_err(|e| err(format!("simpan: {e}")))
            })?;
            Value::Bool(true)
        }

        // `(handle, key) -> value`. An absent key yields "" — pair it with
        // `simpan_ada` when "absent" and "present but empty" must differ.
        "simpan_dapat" => {
            let Value::Pair(id, key) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let id = as_id(id, name)?;
            let key = as_str(key, name)?;
            let value = with_store(id, name, |s| {
                Ok(s.get(key.as_bytes())
                    .map(|v| String::from_utf8_lossy(v).into_owned())
                    .unwrap_or_default())
            })?;
            Value::String(value)
        }

        // `(handle, key) -> bool`.
        "simpan_ada" => {
            let Value::Pair(id, key) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let id = as_id(id, name)?;
            let key = as_str(key, name)?;
            let present = with_store(id, name, |s| Ok(s.contains(key.as_bytes())))?;
            Value::Bool(present)
        }

        // `(handle, key) -> was_present`. Durable on return.
        "simpan_padam" => {
            let Value::Pair(id, key) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let id = as_id(id, name)?;
            let key = as_str(key, name)?;
            let removed = with_store(id, name, |s| {
                s.delete(key.as_bytes())
                    .map_err(|e| err(format!("simpan: {e}")))
            })?;
            Value::Bool(removed)
        }

        // `handle -> [key, ...]`, sorted, so iteration is deterministic.
        "simpan_kunci" => {
            let id = as_id(arg, name)?;
            let keys = with_store(id, name, |s| Ok(s.keys()))?;
            Value::List(
                keys.into_iter()
                    .map(|k| Value::String(String::from_utf8_lossy(&k).into_owned()))
                    .collect(),
            )
        }

        // `handle -> true`. Rewrites the journal with only live records.
        "simpan_padat" => {
            let id = as_id(arg, name)?;
            with_store(id, name, |s| {
                s.compact().map_err(|e| err(format!("simpan: {e}")))
            })?;
            Value::Bool(true)
        }

        // `handle -> true`. Every write was already fsynced, so closing only
        // releases the handle; a later operation on it is an error.
        "simpan_tutup" => {
            let id = as_id(arg, name)?;
            STORES.with(|t| -> Result<Value> {
                let st = &mut *t.borrow_mut();
                st.open
                    .remove(&id)
                    .ok_or_else(|| err(format!("simpan_tutup: unknown store handle {id}")))?;
                Ok(Value::Bool(true))
            })?
        }

        _ => return Ok(None),
    };
    Ok(Some(result))
}

#[cfg(test)]
mod tests {
    use super::*;

    struct Tmp(std::path::PathBuf);
    impl Tmp {
        fn new(tag: &str) -> Self {
            let d = std::env::temp_dir()
                .join(format!("riina_simpan_b_{tag}_{}", std::process::id()));
            let _ = std::fs::remove_dir_all(&d);
            std::fs::create_dir_all(&d).unwrap();
            Self(d)
        }
        fn path(&self) -> String {
            self.0.join("data.simpan").to_string_lossy().into_owned()
        }
    }
    impl Drop for Tmp {
        fn drop(&mut self) {
            let _ = std::fs::remove_dir_all(&self.0);
        }
    }

    fn s(v: &str) -> Value {
        Value::String(v.to_string())
    }
    fn pair(a: Value, b: Value) -> Value {
        Value::Pair(Box::new(a), Box::new(b))
    }

    fn open(path: &str) -> u64 {
        match apply("simpan_buka", &s(path)).expect("no error").expect("ours") {
            Value::Int(id) => id,
            other => panic!("expected handle, got {other:?}"),
        }
    }

    #[test]
    fn put_get_has_delete_through_builtins() {
        let t = Tmp::new("basic");
        let id = open(&t.path());

        apply("simpan_letak", &pair(Value::Int(id), pair(s("nama"), s("Ahmad"))))
            .expect("no error");
        assert_eq!(
            apply("simpan_dapat", &pair(Value::Int(id), s("nama")))
                .expect("no error")
                .expect("ours"),
            s("Ahmad")
        );
        assert_eq!(
            apply("simpan_ada", &pair(Value::Int(id), s("nama")))
                .expect("no error")
                .expect("ours"),
            Value::Bool(true)
        );
        assert_eq!(
            apply("simpan_padam", &pair(Value::Int(id), s("nama")))
                .expect("no error")
                .expect("ours"),
            Value::Bool(true)
        );
        assert_eq!(
            apply("simpan_ada", &pair(Value::Int(id), s("nama")))
                .expect("no error")
                .expect("ours"),
            Value::Bool(false)
        );
    }

    /// Data written through the builtins is visible to a NEW handle on the same
    /// path — durability as a RIINA program would observe it.
    #[test]
    fn data_survives_close_and_reopen() {
        let t = Tmp::new("reopen");
        let id = open(&t.path());
        apply("simpan_letak", &pair(Value::Int(id), pair(s("k"), s("v"))))
            .expect("no error");
        apply("simpan_tutup", &Value::Int(id)).expect("no error");

        let id2 = open(&t.path());
        assert_eq!(
            apply("simpan_dapat", &pair(Value::Int(id2), s("k")))
                .expect("no error")
                .expect("ours"),
            s("v")
        );
    }

    /// `simpan_dapat` flattens absent to "", so `simpan_ada` is how a program
    /// tells absent from present-but-empty.
    #[test]
    fn absent_and_empty_are_distinguishable() {
        let t = Tmp::new("empty");
        let id = open(&t.path());
        apply("simpan_letak", &pair(Value::Int(id), pair(s("kosong"), s(""))))
            .expect("no error");

        assert_eq!(
            apply("simpan_dapat", &pair(Value::Int(id), s("kosong")))
                .expect("no error")
                .expect("ours"),
            s("")
        );
        assert_eq!(
            apply("simpan_dapat", &pair(Value::Int(id), s("tiada")))
                .expect("no error")
                .expect("ours"),
            s("")
        );
        assert_eq!(
            apply("simpan_ada", &pair(Value::Int(id), s("kosong")))
                .expect("no error")
                .expect("ours"),
            Value::Bool(true)
        );
        assert_eq!(
            apply("simpan_ada", &pair(Value::Int(id), s("tiada")))
                .expect("no error")
                .expect("ours"),
            Value::Bool(false)
        );
    }

    #[test]
    fn keys_are_returned_sorted() {
        let t = Tmp::new("keys");
        let id = open(&t.path());
        for k in ["c", "a", "b"] {
            apply("simpan_letak", &pair(Value::Int(id), pair(s(k), s("v"))))
                .expect("no error");
        }
        assert_eq!(
            apply("simpan_kunci", &Value::Int(id))
                .expect("no error")
                .expect("ours"),
            Value::List(vec![s("a"), s("b"), s("c")])
        );
    }

    /// Using a closed handle is an error, never a silent no-op that loses data.
    #[test]
    fn closed_handle_is_an_error() {
        let t = Tmp::new("closed");
        let id = open(&t.path());
        apply("simpan_tutup", &Value::Int(id)).expect("no error");
        assert!(apply("simpan_dapat", &pair(Value::Int(id), s("k"))).is_err());
        assert!(apply("simpan_tutup", &Value::Int(id)).is_err());
    }

    #[test]
    fn unknown_handle_is_an_error() {
        assert!(apply("simpan_dapat", &pair(Value::Int(9_999), s("k"))).is_err());
    }

    /// Applying a pair builtin to one value curries, matching interp.rs.
    #[test]
    fn single_argument_curries() {
        let out = apply("simpan_dapat", &Value::Int(0))
            .expect("no error")
            .expect("ours");
        assert!(matches!(out, Value::BuiltinPartial(ref n, _) if n == "simpan_dapat"));
    }

    #[test]
    fn compaction_keeps_live_data_visible() {
        let t = Tmp::new("compact");
        let id = open(&t.path());
        for i in 0..20 {
            apply(
                "simpan_letak",
                &pair(Value::Int(id), pair(s(&format!("k{i}")), s("lama"))),
            )
            .expect("no error");
            apply(
                "simpan_letak",
                &pair(Value::Int(id), pair(s(&format!("k{i}")), s("baharu"))),
            )
            .expect("no error");
        }
        apply("simpan_padat", &Value::Int(id)).expect("compacts");
        assert_eq!(
            apply("simpan_dapat", &pair(Value::Int(id), s("k7")))
                .expect("no error")
                .expect("ours"),
            s("baharu")
        );
    }

    #[test]
    fn unknown_name_falls_through() {
        assert!(apply("bukan_milik_kami", &Value::Unit)
            .expect("no error")
            .is_none());
    }
}
