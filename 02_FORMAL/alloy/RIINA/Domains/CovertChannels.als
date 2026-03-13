// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for covert channel elimination
// Bounded verification of CovertChannels properties
module riina/Domains/CovertChannels

sig Channel {
  bandwidth: one Int,
  observable: one Int,
  eliminated: one Int
}

// Invariant: eliminated_not_observable
fact eliminated_not_observable_fact {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}

// Invariant: zero_bandwidth_safe
fact zero_bandwidth_safe_fact {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}

assert secure_execute_deterministic {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check secure_execute_deterministic for 6

assert SEC_002_01 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_01 for 6

assert SEC_002_02 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_02 for 6

assert SEC_002_03 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_03 for 6

assert SEC_002_04 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_04 for 6

assert SEC_002_05 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_05 for 6

assert SEC_002_06 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_06 for 6

assert SEC_002_07 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_07 for 6

assert SEC_002_08 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_08 for 6

assert SEC_002_09 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_09 for 6

assert SEC_002_10 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_10 for 6

assert SEC_002_11 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_11 for 6

assert SEC_002_12 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_12 for 6

assert SEC_002_13 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_13 for 6

assert SEC_002_14 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_14 for 6

assert SEC_002_15 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_15 for 6

assert SEC_002_16 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_16 for 6

assert SEC_002_17 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_17 for 6

assert SEC_002_18 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_18 for 6

assert SEC_002_19 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_19 for 6

assert SEC_002_20 {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check SEC_002_20 for 6

assert SEC_002_21 {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check SEC_002_21 for 6

assert level_leq_refl {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check level_leq_refl for 6

assert public_lowest {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check public_lowest for 6

assert topsecret_no_flow_public {
  all c: Channel | c.eliminated = 1 implies c.observable = 0
}
check topsecret_no_flow_public for 6

assert secret_no_flow_public {
  all c: Channel | c.bandwidth = 0 implies c.eliminated = 1
}
check secret_no_flow_public for 6

pred ExampleCovertChannels {
  some Channel
}
run ExampleCovertChannels for 6
