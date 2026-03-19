// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Test/assertion builtins (ujian)

use crate::value::Value;
use crate::{Error, Result};

pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("tegaskan", "assert", "tegaskan"),
    ("tegaskan_sama", "assert_eq", "tegaskan_sama"),
    ("tegaskan_beza", "assert_ne", "tegaskan_beza"),
    ("tegaskan_betul", "assert_true", "tegaskan_betul"),
    ("tegaskan_salah", "assert_false", "tegaskan_salah"),
    ("jangkakan", "expect", "jangkakan"),
];

pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    match name {
        "tegaskan" | "tegaskan_betul" => match arg {
            Value::Bool(true) => Ok(Some(Value::Unit)),
            Value::Bool(false) => Err(Error::InvalidOperation("assertion failed".to_string())),
            _ => Err(Error::TypeMismatch {
                expected: "bool".to_string(),
                found: format!("{:?}", arg),
                context: name.to_string(),
            }),
        },
        "tegaskan_salah" => match arg {
            Value::Bool(false) => Ok(Some(Value::Unit)),
            Value::Bool(true) => Err(Error::InvalidOperation(
                "assert_false failed: got true".to_string(),
            )),
            _ => Err(Error::TypeMismatch {
                expected: "bool".to_string(),
                found: format!("{:?}", arg),
                context: name.to_string(),
            }),
        },
        "tegaskan_sama" | "assert_eq" => {
            match arg {
                Value::Pair(a, b) => {
                    if a == b {
                        Ok(Some(Value::Unit))
                    } else {
                        Err(Error::InvalidOperation(format!(
                            "assert_eq failed: {:?} != {:?}",
                            a, b
                        )))
                    }
                }
                // Partial application: tegaskan_sama(a) returns a partial
                // that waits for b, then checks Pair(a, b)
                other => Ok(Some(Value::BuiltinPartial(
                    "tegaskan_sama".to_string(),
                    Box::new(other.clone()),
                ))),
            }
        }
        "tegaskan_beza" | "assert_ne" => {
            match arg {
                Value::Pair(a, b) => {
                    if a != b {
                        Ok(Some(Value::Unit))
                    } else {
                        Err(Error::InvalidOperation(format!(
                            "assert_ne failed: {:?} == {:?}",
                            a, b
                        )))
                    }
                }
                // Partial application: tegaskan_beza(a) returns a partial
                // that waits for b, then checks Pair(a, b)
                other => Ok(Some(Value::BuiltinPartial(
                    "tegaskan_beza".to_string(),
                    Box::new(other.clone()),
                ))),
            }
        }
        "jangkakan" | "expect" => {
            // Expect-test / snapshot assertion: jangkakan(actual, "expected")
            // Compares the display representation of `actual` with `expected` string.
            match arg {
                Value::Pair(actual, expected) => {
                    let actual_str = crate::builtins::format_value(actual);
                    match expected.as_ref() {
                        Value::String(exp_str) => {
                            if actual_str == *exp_str {
                                Ok(Some(Value::Unit))
                            } else {
                                // Return a specific error that includes both values
                                // so the --update flag can extract the actual value.
                                Err(Error::InvalidOperation(format!(
                                    "expect mismatch:\n  actual:   {actual_str}\n  expected: {exp_str}"
                                )))
                            }
                        }
                        _ => Err(Error::TypeMismatch {
                            expected: "string".to_string(),
                            found: format!("{:?}", expected),
                            context: "jangkakan: second argument must be a string".to_string(),
                        }),
                    }
                }
                other => Ok(Some(Value::BuiltinPartial(
                    "jangkakan".to_string(),
                    Box::new(other.clone()),
                ))),
            }
        }
        _ => Ok(None),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_tegaskan() {
        assert_eq!(
            apply("tegaskan", &Value::Bool(true)).unwrap(),
            Some(Value::Unit)
        );
        assert!(apply("tegaskan", &Value::Bool(false)).is_err());
    }

    #[test]
    fn test_tegaskan_betul() {
        assert_eq!(
            apply("tegaskan_betul", &Value::Bool(true)).unwrap(),
            Some(Value::Unit)
        );
        assert!(apply("tegaskan_betul", &Value::Bool(false)).is_err());
    }

    #[test]
    fn test_tegaskan_salah() {
        assert_eq!(
            apply("tegaskan_salah", &Value::Bool(false)).unwrap(),
            Some(Value::Unit)
        );
        assert!(apply("tegaskan_salah", &Value::Bool(true)).is_err());
    }

    #[test]
    fn test_tegaskan_sama() {
        let arg = Value::Pair(Box::new(Value::Int(42)), Box::new(Value::Int(42)));
        assert_eq!(apply("tegaskan_sama", &arg).unwrap(), Some(Value::Unit));
        let arg2 = Value::Pair(Box::new(Value::Int(1)), Box::new(Value::Int(2)));
        assert!(apply("tegaskan_sama", &arg2).is_err());
    }

    #[test]
    fn test_tegaskan_beza() {
        let arg = Value::Pair(Box::new(Value::Int(1)), Box::new(Value::Int(2)));
        assert_eq!(apply("tegaskan_beza", &arg).unwrap(), Some(Value::Unit));
        let arg2 = Value::Pair(Box::new(Value::Int(1)), Box::new(Value::Int(1)));
        assert!(apply("tegaskan_beza", &arg2).is_err());
    }

    #[test]
    fn test_tegaskan_sama_partial_application() {
        // Calling tegaskan_sama with a non-pair should return BuiltinPartial
        let result = apply("tegaskan_sama", &Value::Int(42)).unwrap();
        assert!(
            matches!(result, Some(Value::BuiltinPartial(ref name, _)) if name == "tegaskan_sama")
        );
    }

    #[test]
    fn test_tegaskan_beza_partial_application() {
        let result = apply("tegaskan_beza", &Value::Int(1)).unwrap();
        assert!(
            matches!(result, Some(Value::BuiltinPartial(ref name, _)) if name == "tegaskan_beza")
        );
    }

    #[test]
    fn test_jangkakan_match() {
        let arg = Value::Pair(
            Box::new(Value::Int(42)),
            Box::new(Value::String("42".to_string())),
        );
        assert_eq!(apply("jangkakan", &arg).unwrap(), Some(Value::Unit));
    }

    #[test]
    fn test_jangkakan_mismatch() {
        let arg = Value::Pair(
            Box::new(Value::Int(42)),
            Box::new(Value::String("99".to_string())),
        );
        let err = apply("jangkakan", &arg).unwrap_err();
        let msg = err.to_string();
        assert!(msg.contains("expect mismatch"), "got: {msg}");
        assert!(msg.contains("42"), "got: {msg}");
        assert!(msg.contains("99"), "got: {msg}");
    }

    #[test]
    fn test_jangkakan_partial_application() {
        let result = apply("jangkakan", &Value::Int(42)).unwrap();
        assert!(matches!(result, Some(Value::BuiltinPartial(ref name, _)) if name == "jangkakan"));
    }

    #[test]
    fn test_jangkakan_string_value() {
        let arg = Value::Pair(
            Box::new(Value::String("hello".to_string())),
            Box::new(Value::String("hello".to_string())),
        );
        assert_eq!(apply("jangkakan", &arg).unwrap(), Some(Value::Unit));
    }

    #[test]
    fn test_jangkakan_bool_value() {
        let arg = Value::Pair(
            Box::new(Value::Bool(true)),
            Box::new(Value::String("true".to_string())),
        );
        assert_eq!(apply("jangkakan", &arg).unwrap(), Some(Value::Unit));
    }

    #[test]
    fn test_jangkakan_list_value() {
        let arg = Value::Pair(
            Box::new(Value::List(vec![Value::Int(1), Value::Int(2)])),
            Box::new(Value::String("[1, 2]".to_string())),
        );
        assert_eq!(apply("jangkakan", &arg).unwrap(), Some(Value::Unit));
    }
}
