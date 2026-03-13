// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for ContextProperties.v
// Source: 02_FORMAL/coq/properties/ContextProperties.v

#![allow(unused)]

const MAX_CTX: usize = 4;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
enum Ty { TUnit = 0, TBool = 1, TInt = 2, TFn = 3 }

impl Ty {
    fn from_u8(v: u8) -> Option<Self> {
        match v { 0 => Some(Self::TUnit), 1 => Some(Self::TBool), 2 => Some(Self::TInt), 3 => Some(Self::TFn), _ => None }
    }
}

#[derive(Debug, Clone, Copy)]
struct Context { vars: [(u8, Ty); MAX_CTX], len: u8 }

impl Context {
    fn empty() -> Self { Self { vars: [(0, Ty::TUnit); MAX_CTX], len: 0 } }
    fn lookup(&self, x: u8) -> Option<Ty> {
        for i in 0..self.len as usize { if self.vars[i].0 == x { return Some(self.vars[i].1); } }
        None
    }
    fn extend(&self, x: u8, t: Ty) -> Self {
        let mut new = *self;
        if (new.len as usize) < MAX_CTX { new.vars[new.len as usize] = (x, t); new.len += 1; }
        new
    }
    fn len(&self) -> u8 { self.len }
}

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_var() -> u8 { let v: u8 = kani::any(); kani::assume(v < 4); v }
    fn any_ty() -> Ty { let v: u8 = kani::any(); kani::assume(v <= 3); Ty::from_u8(v).unwrap() }

    /// Context extension preserves existing bindings
    #[kani::proof]
    fn verify_extend_preserves() {
        let x = any_var();
        let y = any_var();
        kani::assume(x != y);
        let tx = any_ty();
        let ty = any_ty();
        let ctx = Context::empty().extend(x, tx).extend(y, ty);
        assert_eq!(ctx.lookup(x), Some(tx));
    }

    /// Empty context has no bindings
    #[kani::proof]
    fn verify_empty_no_bindings() {
        let x = any_var();
        assert_eq!(Context::empty().lookup(x), None);
    }

    /// Context length increases on extend
    #[kani::proof]
    fn verify_extend_increases_len() {
        let x = any_var();
        let t = any_ty();
        let ctx = Context::empty();
        let ctx2 = ctx.extend(x, t);
        assert!(ctx2.len() > ctx.len());
    }

    /// Permutation: lookup is independent of insertion order for distinct vars
    #[kani::proof]
    fn verify_lookup_permute() {
        let x = any_var();
        let y = any_var();
        kani::assume(x != y);
        let tx = any_ty();
        let ty = any_ty();
        let ctx1 = Context::empty().extend(x, tx).extend(y, ty);
        let ctx2 = Context::empty().extend(y, ty).extend(x, tx);
        assert_eq!(ctx1.lookup(x), ctx2.lookup(x));
    }
}
