// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! List builtins (senarai)
//!
//! Higher-order builtins (senarai_peta, senarai_tapis, senarai_lipat)
//! are handled in interp.rs, not here.

use crate::value::Value;
use crate::{Error, Result};

/// (BM name, EN alias, canonical name)
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("senarai_baru", "list_new", "senarai_baru"),
    ("senarai_tolak", "list_push", "senarai_tolak"),
    ("senarai_dapat", "list_get", "senarai_dapat"),
    ("senarai_panjang", "list_len", "senarai_panjang"),
    ("senarai_peta", "list_map", "senarai_peta"),
    ("senarai_tapis", "list_filter", "senarai_tapis"),
    ("senarai_lipat", "list_fold", "senarai_lipat"),
    ("senarai_balik", "list_reverse", "senarai_balik"),
    ("senarai_susun", "list_sort", "senarai_susun"),
    (
        "senarai_mengandungi",
        "list_contains",
        "senarai_mengandungi",
    ),
    ("senarai_sambung", "list_concat", "senarai_sambung"),
    ("senarai_kepala", "list_head", "senarai_kepala"),
    ("senarai_ekor", "list_tail", "senarai_ekor"),
    ("senarai_zip", "list_zip", "senarai_zip"),
    ("senarai_nombor", "list_enumerate", "senarai_nombor"),
    ("senarai_rata", "list_flatten", "senarai_rata"),
    ("senarai_unik", "list_unique", "senarai_unik"),
    ("senarai_potong", "list_slice", "senarai_potong"),
];

/// Apply a list builtin. Returns Ok(None) if name doesn't match.
/// Higher-order builtins return None here (handled in interp.rs).
pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    match name {
        "senarai_baru" => Ok(Some(Value::List(Vec::new()))),
        "senarai_tolak" => {
            // (List, Value) -> List
            match arg {
                Value::Pair(list, val) => {
                    let mut items = extract_list(list, "senarai_tolak")?.clone();
                    items.push(val.as_ref().clone());
                    Ok(Some(Value::List(items)))
                }
                _ => Err(type_err("(list, value)", arg, "senarai_tolak")),
            }
        }
        "senarai_dapat" => {
            // (List, Int) -> Value
            match arg {
                Value::Pair(list, idx) => {
                    let items = extract_list(list, "senarai_dapat")?;
                    let i = extract_int(idx, "senarai_dapat")? as usize;
                    items.get(i).cloned().map(Some).ok_or_else(|| {
                        Error::InvalidOperation(format!(
                            "index {} out of bounds, list length {}",
                            i,
                            items.len()
                        ))
                    })
                }
                _ => Err(type_err("(list, int)", arg, "senarai_dapat")),
            }
        }
        "senarai_panjang" => {
            let items = extract_list(arg, "senarai_panjang")?;
            Ok(Some(Value::Int(items.len() as u64)))
        }
        "senarai_balik" => {
            let items = extract_list(arg, "senarai_balik")?;
            let mut reversed = items.clone();
            reversed.reverse();
            Ok(Some(Value::List(reversed)))
        }
        "senarai_susun" => {
            let items = extract_list(arg, "senarai_susun")?;
            let mut sorted = items.clone();
            sorted.sort_by(|a, b| match (a, b) {
                (Value::Int(x), Value::Int(y)) => x.cmp(y),
                _ => std::cmp::Ordering::Equal,
            });
            Ok(Some(Value::List(sorted)))
        }
        "senarai_mengandungi" => {
            // (List, Value) -> Bool
            match arg {
                Value::Pair(list, val) => {
                    let items = extract_list(list, "senarai_mengandungi")?;
                    Ok(Some(Value::Bool(items.contains(val))))
                }
                _ => Err(type_err("(list, value)", arg, "senarai_mengandungi")),
            }
        }
        "senarai_sambung" => {
            // (List, List) -> List
            match arg {
                Value::Pair(a, b) => {
                    let mut items = extract_list(a, "senarai_sambung")?.clone();
                    let items2 = extract_list(b, "senarai_sambung")?;
                    items.extend(items2.iter().cloned());
                    Ok(Some(Value::List(items)))
                }
                _ => Err(type_err("(list, list)", arg, "senarai_sambung")),
            }
        }
        "senarai_kepala" => {
            let items = extract_list(arg, "senarai_kepala")?;
            items
                .first()
                .cloned()
                .map(Some)
                .ok_or_else(|| Error::InvalidOperation("head of empty list".to_string()))
        }
        "senarai_ekor" => {
            let items = extract_list(arg, "senarai_ekor")?;
            if items.is_empty() {
                return Err(Error::InvalidOperation("tail of empty list".to_string()));
            }
            Ok(Some(Value::List(items[1..].to_vec())))
        }
        "senarai_zip" => {
            // (List, List) -> List of pairs
            match arg {
                Value::Pair(a, b) => {
                    let items_a = extract_list(a, "senarai_zip")?;
                    let items_b = extract_list(b, "senarai_zip")?;
                    let zipped: Vec<Value> = items_a
                        .iter()
                        .zip(items_b.iter())
                        .map(|(x, y)| Value::Pair(Box::new(x.clone()), Box::new(y.clone())))
                        .collect();
                    Ok(Some(Value::List(zipped)))
                }
                _ => Err(type_err("(list, list)", arg, "senarai_zip")),
            }
        }
        "senarai_nombor" => {
            // List -> List of (index, value) pairs
            let items = extract_list(arg, "senarai_nombor")?;
            let enumerated: Vec<Value> = items
                .iter()
                .enumerate()
                .map(|(i, v)| Value::Pair(Box::new(Value::Int(i as u64)), Box::new(v.clone())))
                .collect();
            Ok(Some(Value::List(enumerated)))
        }
        "senarai_rata" => {
            // List<List<T>> -> List<T>
            let items = extract_list(arg, "senarai_rata")?;
            let mut flat = Vec::new();
            for item in items {
                match item {
                    Value::List(inner) => flat.extend(inner.iter().cloned()),
                    other => flat.push(other.clone()),
                }
            }
            Ok(Some(Value::List(flat)))
        }
        "senarai_unik" => {
            // List<T> -> List<T>
            let items = extract_list(arg, "senarai_unik")?;
            let mut result = Vec::new();
            for item in items {
                if !result.contains(item) {
                    result.push(item.clone());
                }
            }
            Ok(Some(Value::List(result)))
        }
        "senarai_potong" => {
            // (List, Int, Int) -> List
            // Encoded as (list, (int, int))
            match arg {
                Value::Pair(list, range) => {
                    let items = extract_list(list, "senarai_potong")?;
                    match range.as_ref() {
                        Value::Pair(start, end) => {
                            let s = extract_int(start, "senarai_potong")? as usize;
                            let e = extract_int(end, "senarai_potong")? as usize;
                            let s = s.min(items.len());
                            let e = e.min(items.len());
                            let e = e.max(s);
                            Ok(Some(Value::List(items[s..e].to_vec())))
                        }
                        _ => Err(type_err("(list, (int, int))", arg, "senarai_potong")),
                    }
                }
                _ => Err(type_err("(list, (int, int))", arg, "senarai_potong")),
            }
        }
        // Higher-order builtins handled in interp.rs
        "senarai_peta" | "senarai_tapis" | "senarai_lipat" => Ok(None),
        _ => Ok(None),
    }
}

fn extract_list<'a>(v: &'a Value, ctx: &str) -> Result<&'a Vec<Value>> {
    match v {
        Value::List(items) => Ok(items),
        _ => Err(type_err("list", v, ctx)),
    }
}

fn extract_int(v: &Value, ctx: &str) -> Result<u64> {
    match v {
        Value::Int(n) => Ok(*n),
        _ => Err(type_err("int", v, ctx)),
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
    fn test_senarai_baru() {
        assert_eq!(
            apply("senarai_baru", &Value::Unit).unwrap(),
            Some(Value::List(vec![]))
        );
    }

    #[test]
    fn test_senarai_tolak() {
        let list = Value::List(vec![Value::Int(1)]);
        let arg = Value::Pair(Box::new(list), Box::new(Value::Int(2)));
        let result = apply("senarai_tolak", &arg).unwrap().unwrap();
        assert_eq!(result, Value::List(vec![Value::Int(1), Value::Int(2)]));
    }

    #[test]
    fn test_senarai_dapat() {
        let list = Value::List(vec![Value::Int(10), Value::Int(20)]);
        let arg = Value::Pair(Box::new(list), Box::new(Value::Int(1)));
        assert_eq!(apply("senarai_dapat", &arg).unwrap(), Some(Value::Int(20)));
    }

    #[test]
    fn test_senarai_dapat_oob() {
        let list = Value::List(vec![Value::Int(10)]);
        let arg = Value::Pair(Box::new(list), Box::new(Value::Int(5)));
        assert!(apply("senarai_dapat", &arg).is_err());
    }

    #[test]
    fn test_senarai_panjang() {
        let list = Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]);
        assert_eq!(
            apply("senarai_panjang", &list).unwrap(),
            Some(Value::Int(3))
        );
    }

    #[test]
    fn test_senarai_balik() {
        let list = Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]);
        assert_eq!(
            apply("senarai_balik", &list).unwrap(),
            Some(Value::List(vec![
                Value::Int(3),
                Value::Int(2),
                Value::Int(1)
            ]))
        );
    }

    #[test]
    fn test_senarai_susun() {
        let list = Value::List(vec![Value::Int(3), Value::Int(1), Value::Int(2)]);
        assert_eq!(
            apply("senarai_susun", &list).unwrap(),
            Some(Value::List(vec![
                Value::Int(1),
                Value::Int(2),
                Value::Int(3)
            ]))
        );
    }

    #[test]
    fn test_senarai_mengandungi() {
        let list = Value::List(vec![Value::Int(1), Value::Int(2)]);
        let arg = Value::Pair(Box::new(list.clone()), Box::new(Value::Int(2)));
        assert_eq!(
            apply("senarai_mengandungi", &arg).unwrap(),
            Some(Value::Bool(true))
        );
        let arg2 = Value::Pair(Box::new(list), Box::new(Value::Int(5)));
        assert_eq!(
            apply("senarai_mengandungi", &arg2).unwrap(),
            Some(Value::Bool(false))
        );
    }

    #[test]
    fn test_senarai_sambung() {
        let a = Value::List(vec![Value::Int(1)]);
        let b = Value::List(vec![Value::Int(2)]);
        let arg = Value::Pair(Box::new(a), Box::new(b));
        assert_eq!(
            apply("senarai_sambung", &arg).unwrap(),
            Some(Value::List(vec![Value::Int(1), Value::Int(2)]))
        );
    }

    #[test]
    fn test_senarai_kepala_ekor() {
        let list = Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]);
        assert_eq!(apply("senarai_kepala", &list).unwrap(), Some(Value::Int(1)));
        assert_eq!(
            apply("senarai_ekor", &list).unwrap(),
            Some(Value::List(vec![Value::Int(2), Value::Int(3)]))
        );
    }

    #[test]
    fn test_senarai_zip() {
        let a = Value::List(vec![Value::Int(1), Value::Int(2)]);
        let b = Value::List(vec![
            Value::String("a".to_string()),
            Value::String("b".to_string()),
        ]);
        let arg = Value::Pair(Box::new(a), Box::new(b));
        let result = apply("senarai_zip", &arg).unwrap().unwrap();
        assert_eq!(
            result,
            Value::List(vec![
                Value::Pair(
                    Box::new(Value::Int(1)),
                    Box::new(Value::String("a".to_string()))
                ),
                Value::Pair(
                    Box::new(Value::Int(2)),
                    Box::new(Value::String("b".to_string()))
                ),
            ])
        );
    }

    #[test]
    fn test_senarai_rata() {
        let inner1 = Value::List(vec![Value::Int(1), Value::Int(2)]);
        let inner2 = Value::List(vec![Value::Int(3)]);
        let list = Value::List(vec![inner1, inner2]);
        assert_eq!(
            apply("senarai_rata", &list).unwrap(),
            Some(Value::List(vec![
                Value::Int(1),
                Value::Int(2),
                Value::Int(3)
            ]))
        );
    }

    #[test]
    fn test_senarai_unik() {
        let list = Value::List(vec![
            Value::Int(1),
            Value::Int(2),
            Value::Int(1),
            Value::Int(3),
        ]);
        assert_eq!(
            apply("senarai_unik", &list).unwrap(),
            Some(Value::List(vec![
                Value::Int(1),
                Value::Int(2),
                Value::Int(3)
            ]))
        );
    }

    #[test]
    fn test_senarai_potong() {
        let list = Value::List(vec![
            Value::Int(10),
            Value::Int(20),
            Value::Int(30),
            Value::Int(40),
        ]);
        let arg = Value::Pair(
            Box::new(list),
            Box::new(Value::Pair(
                Box::new(Value::Int(1)),
                Box::new(Value::Int(3)),
            )),
        );
        assert_eq!(
            apply("senarai_potong", &arg).unwrap(),
            Some(Value::List(vec![Value::Int(20), Value::Int(30)]))
        );
    }

    #[test]
    fn test_senarai_nombor() {
        let list = Value::List(vec![
            Value::String("a".to_string()),
            Value::String("b".to_string()),
        ]);
        let result = apply("senarai_nombor", &list).unwrap().unwrap();
        assert_eq!(
            result,
            Value::List(vec![
                Value::Pair(
                    Box::new(Value::Int(0)),
                    Box::new(Value::String("a".to_string()))
                ),
                Value::Pair(
                    Box::new(Value::Int(1)),
                    Box::new(Value::String("b".to_string()))
                ),
            ])
        );
    }

    // ── Property tests: the list builtins satisfy the invariants proven in
    // `02_FORMAL/coq/foundations/VerifiedList.v` (sort = ascending permutation,
    // reverse involutive, unique = de-dup preserving the set, concat length).
    // Dependency-free: a seeded LCG sweeps many random integer lists, with values
    // in a narrow range so duplicates are common.

    fn int_list(xs: &[u64]) -> Value {
        Value::List(xs.iter().map(|&n| Value::Int(n)).collect())
    }

    fn ints_of(v: &Value) -> Vec<u64> {
        match v {
            Value::List(items) => items
                .iter()
                .map(|x| match x {
                    Value::Int(n) => *n,
                    other => panic!("expected Int element, got {other:?}"),
                })
                .collect(),
            other => panic!("expected List, got {other:?}"),
        }
    }

    fn lcg(state: &mut u64) -> u64 {
        *state = state
            .wrapping_mul(6364136223846793005)
            .wrapping_add(1442695040888963407);
        *state >> 33
    }

    fn random_lists() -> Vec<Vec<u64>> {
        let mut state: u64 = 0x9E37_79B9_7F4A_7C15;
        let mut lists = Vec::new();
        for _ in 0..200 {
            let len = (lcg(&mut state) % 12) as usize; // 0..=11 elements
            let l: Vec<u64> = (0..len).map(|_| lcg(&mut state) % 10).collect();
            lists.push(l);
        }
        lists
    }

    #[test]
    fn prop_sort_is_ascending_permutation_and_idempotent() {
        // VerifiedList.v: isort_permutation + isort_sorted + isort_idempotent.
        for l in random_lists() {
            let out = apply("senarai_susun", &int_list(&l)).unwrap().unwrap();
            let got = ints_of(&out);
            let mut expect = l.clone();
            expect.sort_unstable();
            assert_eq!(got, expect, "sort must be the ascending permutation of {l:?}");
            let out2 = apply("senarai_susun", &out).unwrap().unwrap();
            assert_eq!(ints_of(&out2), got, "sort must be idempotent");
        }
    }

    #[test]
    fn prop_reverse_is_involutive_and_length_preserving() {
        // VerifiedList.v: reverse_involutive + reverse_length.
        for l in random_lists() {
            let r = apply("senarai_balik", &int_list(&l)).unwrap().unwrap();
            let mut expect = l.clone();
            expect.reverse();
            assert_eq!(ints_of(&r), expect, "reverse of {l:?}");
            let rr = apply("senarai_balik", &r).unwrap().unwrap();
            assert_eq!(ints_of(&rr), l, "reverse must be involutive");
        }
    }

    #[test]
    fn prop_unique_dedups_preserves_set_and_is_idempotent() {
        // VerifiedList.v: unique_no_duplicates + unique_preserves_membership.
        use std::collections::BTreeSet;
        for l in random_lists() {
            let u = apply("senarai_unik", &int_list(&l)).unwrap().unwrap();
            let got = ints_of(&u);
            let set: BTreeSet<u64> = got.iter().copied().collect();
            assert_eq!(set.len(), got.len(), "unique output {got:?} has duplicates");
            let in_set: BTreeSet<u64> = l.iter().copied().collect();
            assert_eq!(set, in_set, "unique must preserve the element set of {l:?}");
            // exact prototype semantics: keep the first occurrence, in order
            let mut seen = BTreeSet::new();
            let first_occ: Vec<u64> = l.iter().copied().filter(|n| seen.insert(*n)).collect();
            assert_eq!(got, first_occ, "unique must keep first occurrences in order");
            let uu = apply("senarai_unik", &u).unwrap().unwrap();
            assert_eq!(ints_of(&uu), got, "unique must be idempotent");
        }
    }

    #[test]
    fn prop_concat_length_is_sum_of_lengths() {
        // VerifiedList.v: concat_length.
        let lists = random_lists();
        for w in lists.windows(2) {
            let (a, b) = (&w[0], &w[1]);
            let arg = Value::Pair(Box::new(int_list(a)), Box::new(int_list(b)));
            let c = apply("senarai_sambung", &arg).unwrap().unwrap();
            let got = ints_of(&c);
            assert_eq!(got.len(), a.len() + b.len(), "concat length = |a| + |b|");
            let mut expect = a.clone();
            expect.extend_from_slice(b);
            assert_eq!(got, expect, "concat must be a ++ b");
        }
    }
}
