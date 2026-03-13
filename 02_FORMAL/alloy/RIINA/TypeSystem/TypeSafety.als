// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/type_system/TypeSafety.v
// Models: type safety = progress + preservation
module riina/TypeSystem/TypeSafety

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }

abstract sig Effect {}
one sig EffPure extends Effect {}
one sig EffIO extends Effect {}

sig StoreTyping {
  entries: set Int
}

pred store_ty_extends[s1: StoreTyping, s2: StoreTyping] {
  s1.entries in s2.entries
}

sig TypedExpr {
  exprType: one Type,
  exprEffect: one Effect,
  isValue: one Int,
  canStep: one Int,
  storeT: one StoreTyping
}

fact Progress {
  all e: TypedExpr | e.isValue = 1 or e.canStep = 1
}

sig SafeStep {
  before: one TypedExpr,
  after: one TypedExpr
}

fact Preservation {
  all s: SafeStep |
    s.before.exprType = s.after.exprType and
    store_ty_extends[s.before.storeT, s.after.storeT]
}

assert type_safety {
  all e: TypedExpr | e.isValue = 1 or e.canStep = 1
}
check type_safety for 6

assert type_safety_multi {
  all s: SafeStep | s.before.exprType = s.after.exprType
}
check type_safety_multi for 6

pred ExampleSafe {
  some s: SafeStep | s.before.exprType = TBool and s.after.isValue = 1
}
run ExampleSafe for 6
