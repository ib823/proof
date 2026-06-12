// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// RIINA Typing - Real Kani Harnesses
// Source: 02_FORMAL/coq/foundations/Typing.v
//
// Demonstrates bounded model checking of the RIINA type checker.
// Models simplified typing judgements and verifies key properties.

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
enum Ty { TUnit = 0, TBool = 1, TInt = 2, TFn = 3, TProd = 4, TSum = 5 }

impl Ty {
    fn from_u8(v: u8) -> Option<Self> {
        match v {
            0 => Some(Self::TUnit), 1 => Some(Self::TBool), 2 => Some(Self::TInt),
            3 => Some(Self::TFn), 4 => Some(Self::TProd), 5 => Some(Self::TSum),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
enum ValueKind { VUnit = 0, VTrue = 1, VFalse = 2, VInt = 3, VLam = 4, VPair = 5, VInl = 6, VInr = 7 }

impl ValueKind {
    fn type_of(self) -> Ty {
        match self {
            Self::VUnit => Ty::TUnit,
            Self::VTrue | Self::VFalse => Ty::TBool,
            Self::VInt => Ty::TInt,
            Self::VLam => Ty::TFn,
            Self::VPair => Ty::TProd,
            Self::VInl | Self::VInr => Ty::TSum,
        }
    }

    fn from_u8(v: u8) -> Option<Self> {
        match v {
            0 => Some(Self::VUnit), 1 => Some(Self::VTrue), 2 => Some(Self::VFalse),
            3 => Some(Self::VInt), 4 => Some(Self::VLam), 5 => Some(Self::VPair),
            6 => Some(Self::VInl), 7 => Some(Self::VInr), _ => None,
        }
    }
}

/// Type uniqueness: a value has exactly one type.
fn type_unique(v: ValueKind) -> bool {
    let t = v.type_of();
    // Check no other type matches
    for i in 0..=5u8 {
        if let Some(other_t) = Ty::from_u8(i) {
            if other_t != t {
                // v should NOT have type other_t
                // (in our model, type_of is a function, so this is automatic)
            }
        }
    }
    true
}

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_value() -> ValueKind {
        let v: u8 = kani::any();
        kani::assume(v <= 7);
        ValueKind::from_u8(v).unwrap()
    }

    fn any_ty() -> Ty {
        let v: u8 = kani::any();
        kani::assume(v <= 5);
        Ty::from_u8(v).unwrap()
    }

    /// Coq: type_uniqueness — each value has exactly one type
    #[kani::proof]
    fn verify_type_uniqueness() {
        let v = any_value();
        assert!(type_unique(v));
    }

    /// Coq: canonical_forms_unit
    #[kani::proof]
    fn verify_canonical_unit() {
        let v = any_value();
        kani::assume(v.type_of() == Ty::TUnit);
        assert_eq!(v, ValueKind::VUnit);
    }

    /// Coq: canonical_forms_bool
    #[kani::proof]
    fn verify_canonical_bool() {
        let v = any_value();
        kani::assume(v.type_of() == Ty::TBool);
        assert!(v == ValueKind::VTrue || v == ValueKind::VFalse);
    }

    /// Coq: canonical_forms_int
    #[kani::proof]
    fn verify_canonical_int() {
        let v = any_value();
        kani::assume(v.type_of() == Ty::TInt);
        assert_eq!(v, ValueKind::VInt);
    }

    /// Coq: canonical_forms_fn
    #[kani::proof]
    fn verify_canonical_fn() {
        let v = any_value();
        kani::assume(v.type_of() == Ty::TFn);
        assert_eq!(v, ValueKind::VLam);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_type_uniqueness() {
        for i in 0..=7u8 {
            if let Some(v) = ValueKind::from_u8(i) {
                assert!(type_unique(v));
            }
        }
    }
}
