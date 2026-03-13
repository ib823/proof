// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/SecurityProperties.v
// Models: security properties for information flow control
module riina/Properties/SecurityProperties

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

assert security_non_interference {
  all d: DataFlow | d.destination in d.source.leq
}
check security_non_interference for 6

pred ExampleSecurityProperties {
  some d: DataFlow | d.source = LSecret and d.destination = LSecret
}
run ExampleSecurityProperties for 6
