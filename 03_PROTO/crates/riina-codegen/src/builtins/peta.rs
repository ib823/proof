// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Map builtins (peta)

use crate::value::Value;
use crate::{Error, Result};
use std::collections::BTreeMap;

/// (BM name, EN alias, canonical name)
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("peta_baru", "map_new", "peta_baru"),
    ("peta_letak", "map_insert", "peta_letak"),
    ("peta_dapat", "map_get", "peta_dapat"),
    ("peta_buang", "map_remove", "peta_buang"),
    ("peta_kunci", "map_keys", "peta_kunci"),
    ("peta_nilai", "map_values", "peta_nilai"),
    ("peta_mengandungi", "map_contains", "peta_mengandungi"),
    ("peta_panjang", "map_len", "peta_panjang"),
];

pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    match name {
        "peta_baru" => Ok(Some(Value::Map(BTreeMap::new()))),
        "peta_letak" => {
            // (Map, (String, Value)) -> Map
            match arg {
                Value::Pair(map, kv) => {
                    let mut entries = extract_map(map, "peta_letak")?.clone();
                    match kv.as_ref() {
                        Value::Pair(k, v) => {
                            let key = extract_string(k, "peta_letak")?;
                            entries.insert(key, v.as_ref().clone());
                            Ok(Some(Value::Map(entries)))
                        }
                        _ => Err(type_err("(map, (string, value))", arg, "peta_letak")),
                    }
                }
                _ => Err(type_err("(map, (string, value))", arg, "peta_letak")),
            }
        }
        "peta_dapat" => {
            // (Map, String) -> Value
            match arg {
                Value::Pair(map, key) => {
                    let entries = extract_map(map, "peta_dapat")?;
                    let k = extract_string(key, "peta_dapat")?;
                    entries.get(&k).cloned().map(Some).ok_or_else(|| {
                        Error::InvalidOperation(format!("key '{}' not found in map", k))
                    })
                }
                _ => Err(type_err("(map, string)", arg, "peta_dapat")),
            }
        }
        "peta_buang" => {
            // (Map, String) -> Map
            match arg {
                Value::Pair(map, key) => {
                    let mut entries = extract_map(map, "peta_buang")?.clone();
                    let k = extract_string(key, "peta_buang")?;
                    entries.remove(&k);
                    Ok(Some(Value::Map(entries)))
                }
                _ => Err(type_err("(map, string)", arg, "peta_buang")),
            }
        }
        "peta_kunci" => {
            let entries = extract_map(arg, "peta_kunci")?;
            let keys: Vec<Value> = entries.keys().map(|k| Value::String(k.clone())).collect();
            Ok(Some(Value::List(keys)))
        }
        "peta_nilai" => {
            let entries = extract_map(arg, "peta_nilai")?;
            let vals: Vec<Value> = entries.values().cloned().collect();
            Ok(Some(Value::List(vals)))
        }
        "peta_mengandungi" => {
            // (Map, String) -> Bool
            match arg {
                Value::Pair(map, key) => {
                    let entries = extract_map(map, "peta_mengandungi")?;
                    let k = extract_string(key, "peta_mengandungi")?;
                    Ok(Some(Value::Bool(entries.contains_key(&k))))
                }
                _ => Err(type_err("(map, string)", arg, "peta_mengandungi")),
            }
        }
        "peta_panjang" => {
            let entries = extract_map(arg, "peta_panjang")?;
            Ok(Some(Value::Int(entries.len() as u64)))
        }
        _ => Ok(None),
    }
}

fn extract_map<'a>(v: &'a Value, ctx: &str) -> Result<&'a BTreeMap<String, Value>> {
    match v {
        Value::Map(m) => Ok(m),
        _ => Err(type_err("map", v, ctx)),
    }
}

fn extract_string(v: &Value, ctx: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        _ => Err(type_err("string", v, ctx)),
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
    fn test_peta_baru() {
        assert_eq!(
            apply("peta_baru", &Value::Unit).unwrap(),
            Some(Value::Map(BTreeMap::new()))
        );
    }

    #[test]
    fn test_peta_letak_dapat() {
        let map = Value::Map(BTreeMap::new());
        let kv = Value::Pair(
            Box::new(Value::String("key".to_string())),
            Box::new(Value::Int(42)),
        );
        let arg = Value::Pair(Box::new(map), Box::new(kv));
        let result = apply("peta_letak", &arg).unwrap().unwrap();

        // Now get
        let get_arg = Value::Pair(Box::new(result), Box::new(Value::String("key".to_string())));
        assert_eq!(apply("peta_dapat", &get_arg).unwrap(), Some(Value::Int(42)));
    }

    #[test]
    fn test_peta_buang() {
        let mut m = BTreeMap::new();
        m.insert("a".to_string(), Value::Int(1));
        m.insert("b".to_string(), Value::Int(2));
        let map = Value::Map(m);
        let arg = Value::Pair(Box::new(map), Box::new(Value::String("a".to_string())));
        let result = apply("peta_buang", &arg).unwrap().unwrap();
        let entries = result.as_map().unwrap();
        assert_eq!(entries.len(), 1);
        assert!(!entries.contains_key("a"));
    }

    #[test]
    fn test_peta_kunci_nilai() {
        let mut m = BTreeMap::new();
        m.insert("a".to_string(), Value::Int(1));
        m.insert("b".to_string(), Value::Int(2));
        let map = Value::Map(m);

        let keys = apply("peta_kunci", &map).unwrap().unwrap();
        assert_eq!(
            keys,
            Value::List(vec![
                Value::String("a".to_string()),
                Value::String("b".to_string()),
            ])
        );

        let vals = apply("peta_nilai", &map).unwrap().unwrap();
        assert_eq!(vals, Value::List(vec![Value::Int(1), Value::Int(2)]));
    }

    #[test]
    fn test_peta_mengandungi() {
        let mut m = BTreeMap::new();
        m.insert("x".to_string(), Value::Int(1));
        let map = Value::Map(m);
        let arg = Value::Pair(
            Box::new(map.clone()),
            Box::new(Value::String("x".to_string())),
        );
        assert_eq!(
            apply("peta_mengandungi", &arg).unwrap(),
            Some(Value::Bool(true))
        );
        let arg2 = Value::Pair(Box::new(map), Box::new(Value::String("y".to_string())));
        assert_eq!(
            apply("peta_mengandungi", &arg2).unwrap(),
            Some(Value::Bool(false))
        );
    }

    #[test]
    fn test_peta_panjang() {
        let mut m = BTreeMap::new();
        m.insert("a".to_string(), Value::Int(1));
        assert_eq!(
            apply("peta_panjang", &Value::Map(m)).unwrap(),
            Some(Value::Int(1))
        );
    }

    // ── Property tests: the map builtins satisfy the partial-map laws proven in
    // `02_FORMAL/coq/foundations/VerifiedMapSet.v` (get-after-insert, insert
    // shadows and leaves other keys untouched, remove deletes exactly one key).

    fn map_insert(m: Value, k: &str, v: u64) -> Value {
        let kv = Value::Pair(
            Box::new(Value::String(k.to_string())),
            Box::new(Value::Int(v)),
        );
        apply("peta_letak", &Value::Pair(Box::new(m), Box::new(kv)))
            .unwrap()
            .unwrap()
    }
    fn map_get(m: &Value, k: &str) -> Option<u64> {
        match apply(
            "peta_dapat",
            &Value::Pair(Box::new(m.clone()), Box::new(Value::String(k.to_string()))),
        ) {
            Ok(Some(Value::Int(n))) => Some(n),
            _ => None,
        }
    }
    fn map_contains(m: &Value, k: &str) -> bool {
        matches!(
            apply(
                "peta_mengandungi",
                &Value::Pair(Box::new(m.clone()), Box::new(Value::String(k.to_string()))),
            ),
            Ok(Some(Value::Bool(true)))
        )
    }
    fn map_len(m: &Value) -> u64 {
        match apply("peta_panjang", m) {
            Ok(Some(Value::Int(n))) => n,
            _ => panic!("map_len"),
        }
    }

    #[test]
    fn prop_map_get_after_insert_and_shadow() {
        let mut m = apply("peta_baru", &Value::Unit).unwrap().unwrap();
        for i in 0..20u64 {
            m = map_insert(m, &format!("k{i}"), i * 7);
            assert_eq!(map_get(&m, &format!("k{i}")), Some(i * 7), "get-after-insert");
        }
        // insert never disturbs an earlier key (map_insert_other)
        for i in 0..20u64 {
            assert_eq!(
                map_get(&m, &format!("k{i}")),
                Some(i * 7),
                "other keys preserved"
            );
        }
        // a re-insert shadows the value without growing the map (map_insert_shadow)
        let before = map_len(&m);
        m = map_insert(m, "k5", 999);
        assert_eq!(map_get(&m, "k5"), Some(999), "insert shadows");
        assert_eq!(map_len(&m), before, "shadow doesn't grow the map");
    }

    #[test]
    fn prop_map_contains_and_remove() {
        let mut m = apply("peta_baru", &Value::Unit).unwrap().unwrap();
        m = map_insert(m, "a", 1);
        m = map_insert(m, "b", 2);
        assert!(map_contains(&m, "a") && map_contains(&m, "b"));
        assert!(!map_contains(&m, "z"), "absent key is not contained");
        let before = map_len(&m);
        m = apply(
            "peta_buang",
            &Value::Pair(Box::new(m), Box::new(Value::String("a".to_string()))),
        )
        .unwrap()
        .unwrap();
        assert!(!map_contains(&m, "a"), "remove deletes the key (map_remove_eq)");
        assert!(
            map_contains(&m, "b"),
            "remove leaves other keys (map_remove_other)"
        );
        assert_eq!(map_len(&m), before - 1);
    }
}
