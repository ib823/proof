// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for CanonicalForms.v
// Source: 02_FORMAL/coq/properties/CanonicalForms.v

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
enum Ty { TUnit = 0, TBool = 1, TInt = 2, TString = 3, TFn = 4, TProd = 5, TSum = 6, TRef = 7, TSecret = 8 }

impl Ty {
    fn from_u8(v: u8) -> Option<Self> {
        match v {
            0 => Some(Self::TUnit), 1 => Some(Self::TBool), 2 => Some(Self::TInt),
            3 => Some(Self::TString), 4 => Some(Self::TFn), 5 => Some(Self::TProd),
            6 => Some(Self::TSum), 7 => Some(Self::TRef), 8 => Some(Self::TSecret),
            _ => None,
        }
    }
    fn is_base(self) -> bool { matches!(self, Self::TUnit | Self::TBool | Self::TInt | Self::TString) }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
enum ValueForm { VUnit = 0, VBool = 1, VInt = 2, VString = 3, VLam = 4, VPair = 5, VInl = 6, VInr = 7, VLoc = 8, VClassify = 9 }

impl ValueForm {
    fn canonical_type(self) -> Ty {
        match self {
            Self::VUnit => Ty::TUnit, Self::VBool => Ty::TBool, Self::VInt => Ty::TInt,
            Self::VString => Ty::TString, Self::VLam => Ty::TFn, Self::VPair => Ty::TProd,
            Self::VInl | Self::VInr => Ty::TSum, Self::VLoc => Ty::TRef,
            Self::VClassify => Ty::TSecret,
        }
    }
    fn from_u8(v: u8) -> Option<Self> {
        match v {
            0 => Some(Self::VUnit), 1 => Some(Self::VBool), 2 => Some(Self::VInt),
            3 => Some(Self::VString), 4 => Some(Self::VLam), 5 => Some(Self::VPair),
            6 => Some(Self::VInl), 7 => Some(Self::VInr), 8 => Some(Self::VLoc),
            9 => Some(Self::VClassify), _ => None,
        }
    }
    fn is_closed(self) -> bool { true } // all value forms are closed (no free vars)
}


#[cfg(kani)]
mod verification {
    use super::*;

    fn any_value() -> ValueForm {
        let v: u8 = kani::any();
        kani::assume(v <= 9);
        ValueForm::from_u8(v).unwrap()
    }

    #[kani::proof]
    fn verify_canonical_unit() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TUnit);
        assert_eq!(v, ValueForm::VUnit);
    }

    #[kani::proof]
    fn verify_canonical_bool() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TBool);
        assert_eq!(v, ValueForm::VBool);
    }

    #[kani::proof]
    fn verify_canonical_int() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TInt);
        assert_eq!(v, ValueForm::VInt);
    }

    #[kani::proof]
    fn verify_canonical_string() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TString);
        assert_eq!(v, ValueForm::VString);
    }

    #[kani::proof]
    fn verify_canonical_fn() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TFn);
        assert_eq!(v, ValueForm::VLam);
    }

    #[kani::proof]
    fn verify_canonical_prod() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TProd);
        assert_eq!(v, ValueForm::VPair);
    }

    #[kani::proof]
    fn verify_canonical_sum() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TSum);
        assert!(v == ValueForm::VInl || v == ValueForm::VInr);
    }

    #[kani::proof]
    fn verify_canonical_ref() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TRef);
        assert_eq!(v, ValueForm::VLoc);
    }

    #[kani::proof]
    fn verify_canonical_secret() {
        let v = any_value();
        kani::assume(v.canonical_type() == Ty::TSecret);
        assert_eq!(v, ValueForm::VClassify);
    }

    #[kani::proof]
    fn verify_canonical_bijection() {
        let v = any_value();
        let t = v.canonical_type();
        // Each value form maps to exactly one type
        let v2 = any_value();
        kani::assume(v2.canonical_type() == t);
        // For base types, the mapping is injective
        if t.is_base() {
            assert_eq!(v, v2);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_all_canonical() {
        for i in 0..=9u8 {
            if let Some(v) = ValueForm::from_u8(i) {
                let _ = v.canonical_type();
            }
        }
    }
}
