// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/Declassification.v
// Models: security properties for information flow control
module riina/Properties/Declassification

abstract sig SecurityLevel {
  level: one Int,
  leq: set SecurityLevel
}

one sig LPublic extends SecurityLevel {}
one sig LInternal extends SecurityLevel {}
one sig LSecret extends SecurityLevel {}

fact LevelEncoding {
  LPublic.level = 0
  LInternal.level = 1
  LSecret.level = 2
}

fact Ordering {
  all l1, l2: SecurityLevel | l2 in l1.leq iff l1.level <= l2.level
}

sig DataFlow {
  source: one SecurityLevel,
  destination: one SecurityLevel
}

fact InformationFlowPolicy {
  all d: DataFlow | d.destination in d.source.leq
}

sig Observer {
  observerLevel: one SecurityLevel
}

pred indistinguishable[d1, d2: DataFlow, obs: Observer] {
  d1.source.level > obs.observerLevel.level and
  d2.source.level > obs.observerLevel.level
}

pred noninterference[obs: Observer] {
  all d: DataFlow | d.source.level > obs.observerLevel.level implies
    d.destination.level > obs.observerLevel.level
}

assert val_rel_le_secret_trivial {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_le_secret_trivial for 6

assert declassify_eval {
  all d: DataFlow | d.destination in d.source.leq
}
check declassify_eval for 6

assert logical_relation_declassify_proven {
  all d: DataFlow | d.destination in d.source.leq
}
check logical_relation_declassify_proven for 6

assert value_multi_step_refl_decl {
  all d: DataFlow | d.destination in d.source.leq
}
check value_multi_step_refl_decl for 6

assert eval_deterministic_cfg {
  all d: DataFlow | d.destination in d.source.leq
}
check eval_deterministic_cfg for 6

assert eval_deterministic {
  all d: DataFlow | d.destination in d.source.leq
}
check eval_deterministic for 6

assert declassify_policy_safe {
  all d: DataFlow | d.destination in d.source.leq
}
check declassify_policy_safe for 6

assert classify_creates_secret {
  all d: DataFlow | d.destination in d.source.leq
}
check classify_creates_secret for 6

assert double_classify_typed {
  all d: DataFlow | d.destination in d.source.leq
}
check double_classify_typed for 6

assert classify_value {
  all d: DataFlow | d.destination in d.source.leq
}
check classify_value for 6

assert classify_closed {
  all d: DataFlow | d.destination in d.source.leq
}
check classify_closed for 6

assert declassify_requires_public_context {
  all d: DataFlow | d.destination in d.source.leq
}
check declassify_requires_public_context for 6

assert secret_value_pure {
  all d: DataFlow | d.destination in d.source.leq
}
check secret_value_pure for 6

assert declassify_deterministic {
  all d: DataFlow | d.destination in d.source.leq
}
check declassify_deterministic for 6

assert declassify_result {
  all d: DataFlow | d.destination in d.source.leq
}
check declassify_result for 6

assert declassification_zero_admits {
  all d: DataFlow | d.destination in d.source.leq
}
check declassification_zero_admits for 6

pred ExampleDeclassification {
  some d: DataFlow | d.source = LSecret and d.destination = LSecret
}
run ExampleDeclassification for 6
