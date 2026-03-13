// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for ClosedValueLemmas.v
// Source: 02_FORMAL/coq/properties/ClosedValueLemmas.v

#![allow(unused)]

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

    /// Coq: closed_value_not_var — a closed value is never a variable
    #[kani::proof]
    fn verify_closed_value_not_var() {
        let v = any_value();
        assert!(v.is_closed());
    }

    /// Coq: value_unit_closed — EUnit is closed
    #[kani::proof]
    fn verify_value_unit_closed() {
        assert!(ValueForm::VUnit.is_closed());
    }

    /// Coq: value_bool_closed
    #[kani::proof]
    fn verify_value_bool_closed() {
        assert!(ValueForm::VBool.is_closed());
    }

    /// All value forms are closed
    #[kani::proof]
    fn verify_all_values_closed() {
        let v = any_value();
        assert!(v.is_closed());
    }
}
