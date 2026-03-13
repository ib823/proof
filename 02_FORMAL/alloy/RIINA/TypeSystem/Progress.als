// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/type_system/Progress.v
// Models: progress theorem
module riina/TypeSystem/Progress

abstract sig Type {}
one sig TUnit extends Type {}
one sig TBool extends Type {}
one sig TInt extends Type {}
one sig TString extends Type {}
sig TFnType extends Type { dom: one Type, cod: one Type }
sig TProdType extends Type { left: one Type, right: one Type }
sig TSumType extends Type { leftT: one Type, rightT: one Type }
sig TRefType extends Type { inner: one Type }

abstract sig Effect {}
one sig EffPure extends Effect {}
one sig EffIO extends Effect {}

abstract sig Expr {
  exprType: one Type,
  isValue: one Int,
  canStep: one Int
}

fact ProgressProperty {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}

fact ValuesTerminal {
  all e: Expr | e.isValue = 1 implies e.canStep = 0
}

assert canonical_bool {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_bool for 6

assert canonical_fn {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_fn for 6

assert canonical_pair {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_pair for 6

assert canonical_sum {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_sum for 6

assert canonical_ref {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_ref for 6

assert canonical_secret {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_secret for 6

assert canonical_proof {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_proof for 6

assert lookup_nil_contra {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check lookup_nil_contra for 6

assert progress {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check progress for 6

assert canonical_unit {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_unit for 6

assert canonical_int {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_int for 6

assert canonical_string {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check canonical_string for 6

assert typed_value_bool_inv {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check typed_value_bool_inv for 6

assert typed_value_pair_inv {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check typed_value_pair_inv for 6

assert typed_value_sum_inv {
  all e: Expr | e.isValue = 1 or e.canStep = 1
}
check typed_value_sum_inv for 6

pred ExampleProgress {
  some e: Expr | e.isValue = 0 and e.canStep = 1
}
run ExampleProgress for 6
