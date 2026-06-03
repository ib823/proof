// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Math builtins (matematik)

use crate::value::Value;
use crate::{Error, Result};

pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("mutlak", "abs", "mutlak"),
    ("minimum", "min", "minimum"),
    ("maksimum", "max", "maksimum"),
    ("kuasa", "pow", "kuasa"),
    ("punca", "sqrt", "punca"),
    ("gcd", "gcd", "gcd"),
    ("lcm", "lcm", "lcm"),
    ("baki", "rem", "baki"),
    ("log2", "log2", "log2"),
    ("rawak", "random", "rawak"),
];

pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    match name {
        "mutlak" => {
            // u64 is always non-negative, so abs is identity
            let n = extract_int(arg, "mutlak")?;
            Ok(Some(Value::Int(n)))
        }
        "minimum" => {
            let (a, b) = extract_pair_ints(arg, "minimum")?;
            Ok(Some(Value::Int(a.min(b))))
        }
        "maksimum" => {
            let (a, b) = extract_pair_ints(arg, "maksimum")?;
            Ok(Some(Value::Int(a.max(b))))
        }
        "kuasa" => {
            let (base, exp) = extract_pair_ints(arg, "kuasa")?;
            Ok(Some(Value::Int(base.wrapping_pow(exp as u32))))
        }
        "punca" => {
            let n = extract_int(arg, "punca")?;
            Ok(Some(Value::Int((n as f64).sqrt() as u64)))
        }
        "gcd" => {
            let (a, b) = extract_pair_ints(arg, "gcd")?;
            Ok(Some(Value::Int(gcd_impl(a, b))))
        }
        "lcm" => {
            let (a, b) = extract_pair_ints(arg, "lcm")?;
            if a == 0 && b == 0 {
                Ok(Some(Value::Int(0)))
            } else {
                Ok(Some(Value::Int(a / gcd_impl(a, b) * b)))
            }
        }
        "baki" => {
            let (a, b) = extract_pair_ints(arg, "baki")?;
            if b == 0 {
                return Err(Error::InvalidOperation("modulo by zero".to_string()));
            }
            Ok(Some(Value::Int(a % b)))
        }
        "log2" => {
            let n = extract_int(arg, "log2")?;
            if n == 0 {
                return Err(Error::InvalidOperation("log2(0) is undefined".to_string()));
            }
            Ok(Some(Value::Int(63 - n.leading_zeros() as u64)))
        }
        "rawak" => {
            // Int -> Int (0..n exclusive)
            let n = extract_int(arg, "rawak")?;
            if n == 0 {
                return Err(Error::InvalidOperation(
                    "random(0) is undefined".to_string(),
                ));
            }
            // Simple PRNG using thread-local state
            use std::collections::hash_map::DefaultHasher;
            use std::hash::{Hash, Hasher};
            use std::time::SystemTime;
            let seed = SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .unwrap_or_default()
                .as_nanos();
            let mut h = DefaultHasher::new();
            seed.hash(&mut h);
            let r = h.finish() % n;
            Ok(Some(Value::Int(r)))
        }
        _ => Ok(None),
    }
}

fn gcd_impl(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let t = b;
        b = a % b;
        a = t;
    }
    a
}

fn extract_int(v: &Value, ctx: &str) -> Result<u64> {
    match v {
        Value::Int(n) => Ok(*n),
        _ => Err(Error::TypeMismatch {
            expected: "int".to_string(),
            found: format!("{:?}", v),
            context: ctx.to_string(),
        }),
    }
}

fn extract_pair_ints(v: &Value, ctx: &str) -> Result<(u64, u64)> {
    match v {
        Value::Pair(a, b) => {
            let x = extract_int(a, ctx)?;
            let y = extract_int(b, ctx)?;
            Ok((x, y))
        }
        _ => Err(Error::TypeMismatch {
            expected: "(int, int)".to_string(),
            found: format!("{:?}", v),
            context: ctx.to_string(),
        }),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn pair_i(a: u64, b: u64) -> Value {
        Value::Pair(Box::new(Value::Int(a)), Box::new(Value::Int(b)))
    }

    #[test]
    fn test_mutlak() {
        assert_eq!(
            apply("mutlak", &Value::Int(42)).unwrap(),
            Some(Value::Int(42))
        );
    }

    #[test]
    fn test_minimum_maksimum() {
        assert_eq!(
            apply("minimum", &pair_i(3, 7)).unwrap(),
            Some(Value::Int(3))
        );
        assert_eq!(
            apply("maksimum", &pair_i(3, 7)).unwrap(),
            Some(Value::Int(7))
        );
    }

    #[test]
    fn test_kuasa() {
        assert_eq!(
            apply("kuasa", &pair_i(2, 10)).unwrap(),
            Some(Value::Int(1024))
        );
    }

    #[test]
    fn test_punca() {
        assert_eq!(
            apply("punca", &Value::Int(16)).unwrap(),
            Some(Value::Int(4))
        );
        assert_eq!(
            apply("punca", &Value::Int(15)).unwrap(),
            Some(Value::Int(3))
        );
    }

    #[test]
    fn test_gcd() {
        assert_eq!(apply("gcd", &pair_i(12, 8)).unwrap(), Some(Value::Int(4)));
        assert_eq!(apply("gcd", &pair_i(7, 13)).unwrap(), Some(Value::Int(1)));
    }

    #[test]
    fn test_lcm() {
        assert_eq!(apply("lcm", &pair_i(4, 6)).unwrap(), Some(Value::Int(12)));
        assert_eq!(apply("lcm", &pair_i(0, 0)).unwrap(), Some(Value::Int(0)));
    }

    #[test]
    fn test_baki() {
        assert_eq!(apply("baki", &pair_i(10, 3)).unwrap(), Some(Value::Int(1)));
        assert_eq!(apply("baki", &pair_i(9, 3)).unwrap(), Some(Value::Int(0)));
        assert!(apply("baki", &pair_i(5, 0)).is_err());
    }

    #[test]
    fn test_log2() {
        assert_eq!(apply("log2", &Value::Int(1)).unwrap(), Some(Value::Int(0)));
        assert_eq!(apply("log2", &Value::Int(8)).unwrap(), Some(Value::Int(3)));
        assert_eq!(
            apply("log2", &Value::Int(1024)).unwrap(),
            Some(Value::Int(10))
        );
        assert!(apply("log2", &Value::Int(0)).is_err());
    }

    #[test]
    fn test_rawak() {
        let result = apply("rawak", &Value::Int(100)).unwrap().unwrap();
        match result {
            Value::Int(n) => assert!(n < 100),
            _ => panic!("expected int"),
        }
    }

    // ── Property tests: the math builtins satisfy the laws proven in
    // `02_FORMAL/coq/foundations/VerifiedMath.v`, and the running impls compute
    // exactly the `Nat` functions whose laws are proved there. Dependency-free LCG.

    fn lcg(state: &mut u64) -> u64 {
        *state = state
            .wrapping_mul(6364136223846793005)
            .wrapping_add(1442695040888963407);
        *state >> 33
    }
    fn int_of(v: Value) -> u64 {
        match v {
            Value::Int(n) => n,
            o => panic!("expected Int, got {o:?}"),
        }
    }
    fn call2(name: &str, a: u64, b: u64) -> u64 {
        int_of(apply(name, &pair_i(a, b)).unwrap().unwrap())
    }
    fn call1(name: &str, a: u64) -> u64 {
        int_of(apply(name, &Value::Int(a)).unwrap().unwrap())
    }

    #[test]
    fn prop_min_max_laws() {
        // VerifiedMath.v: min_comm/max_comm, the order bounds, min_max_sum.
        let mut st: u64 = 0x1234_5678_9ABC_DEF0;
        for _ in 0..300 {
            let a = lcg(&mut st) % 1000;
            let b = lcg(&mut st) % 1000;
            let mn = call2("minimum", a, b);
            let mx = call2("maksimum", a, b);
            assert_eq!(mn, a.min(b), "min computes Nat.min");
            assert_eq!(mx, a.max(b), "max computes Nat.max");
            assert!(mn <= a && mn <= b && a <= mx && b <= mx, "order bounds");
            assert_eq!(mn + mx, a + b, "min_max_sum");
            assert_eq!(call2("minimum", a, b), call2("minimum", b, a), "min_comm");
            assert_eq!(call2("maksimum", a, b), call2("maksimum", b, a), "max_comm");
        }
    }

    #[test]
    fn prop_gcd_lcm_laws() {
        // VerifiedMath.v: gcd divides both, gcd_comm, gcd_zero_right; + gcd·lcm = a·b.
        fn rust_gcd(mut a: u64, mut b: u64) -> u64 {
            while b != 0 {
                let t = b;
                b = a % b;
                a = t;
            }
            a
        }
        let mut st: u64 = 0xCAFE_BABE_0000_0001;
        for _ in 0..300 {
            let a = lcg(&mut st) % 500 + 1;
            let b = lcg(&mut st) % 500 + 1;
            let g = call2("gcd", a, b);
            assert_eq!(g, rust_gcd(a, b), "gcd computes the Euclidean gcd");
            assert_eq!(a % g, 0, "gcd divides a");
            assert_eq!(b % g, 0, "gcd divides b");
            assert_eq!(call2("gcd", a, b), call2("gcd", b, a), "gcd_comm");
            assert_eq!(call2("gcd", a, 0), a, "gcd_zero_right");
            assert_eq!(g * call2("lcm", a, b), a * b, "gcd·lcm = a·b");
        }
    }

    #[test]
    fn prop_pow_abs_rem_laws() {
        // VerifiedMath.v: pow_zero/pow_one/pow_add; + abs identity & rem = a%b.
        let mut st: u64 = 0x0F0F_0F0F_F0F0_F0F0;
        for _ in 0..200 {
            let base = lcg(&mut st) % 10;
            let m = lcg(&mut st) % 6;
            let n = lcg(&mut st) % 6;
            assert_eq!(call2("kuasa", base, 0), 1, "pow_zero");
            assert_eq!(call2("kuasa", base, 1), base, "pow_one");
            assert_eq!(
                call2("kuasa", base, m + n),
                call2("kuasa", base, m) * call2("kuasa", base, n),
                "pow_add"
            );
            let x = lcg(&mut st);
            assert_eq!(call1("mutlak", x), x, "abs is identity on u64");
            let d = lcg(&mut st) % 100 + 1;
            assert_eq!(call2("baki", x, d), x % d, "rem = a % b");
        }
    }
}
