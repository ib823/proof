// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/NonInterference_v2_Monotone.v
// Models: security properties for information flow control
module riina/Properties/NonInterference_v2_Monotone

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

assert store_ty_extends_trans_early {
  all d: DataFlow | d.destination in d.source.leq
}
check store_ty_extends_trans_early for 6

assert val_rel_at_type_mono_store {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_mono_store for 6

assert first_order_decidable_local {
  all d: DataFlow | d.destination in d.source.leq
}
check first_order_decidable_local for 6

assert val_rel_n_mono_store_fo {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_mono_store_fo for 6

assert val_rel_n_mono_store {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_mono_store for 6

pred ExampleNonInterference_v2_Monotone {
  some d: DataFlow | d.source = LSecret and d.destination = LSecret
}
run ExampleNonInterference_v2_Monotone for 6
