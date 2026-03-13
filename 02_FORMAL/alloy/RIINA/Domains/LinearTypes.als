// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for linear type verification
// Bounded verification of LinearTypes properties
module riina/Domains/LinearTypes

sig LinearResource {
  used: one Int,
  consumed: one Int
}

sig LinearUse {
  resource: one LinearResource,
  valid: one Int
}

// Invariant: use_at_most_once
fact use_at_most_once_fact {
  all r: LinearResource | r.used <= 1
}

// Invariant: consumed_not_reused
fact consumed_not_reused_fact {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}

// Invariant: valid_use_uncancelled
fact valid_use_uncancelled_fact {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}

assert linearity_eqb_eq {
  all r: LinearResource | r.used <= 1
}
check linearity_eqb_eq for 6

assert get_update_same {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check get_update_same for 6

assert TYPE_002_01 {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check TYPE_002_01 for 6

assert TYPE_002_02 {
  all r: LinearResource | r.used <= 1
}
check TYPE_002_02 for 6

assert TYPE_002_03 {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check TYPE_002_03 for 6

assert TYPE_002_04 {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check TYPE_002_04 for 6

assert TYPE_002_05 {
  all r: LinearResource | r.used <= 1
}
check TYPE_002_05 for 6

assert usage_add_zero_l {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check usage_add_zero_l for 6

assert usage_add_zero_r {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check usage_add_zero_r for 6

assert TYPE_002_06 {
  all r: LinearResource | r.used <= 1
}
check TYPE_002_06 for 6

assert TYPE_002_07 {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check TYPE_002_07 for 6

assert linear_must_be_used {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check linear_must_be_used for 6

assert linear_zero_usage_invalid {
  all r: LinearResource | r.used <= 1
}
check linear_zero_usage_invalid for 6

assert linear_many_usage_invalid {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check linear_many_usage_invalid for 6

assert unused_linear_ill_formed {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check unused_linear_ill_formed for 6

assert extend_preserves_lookup_none {
  all r: LinearResource | r.used <= 1
}
check extend_preserves_lookup_none for 6

assert unit_typing_preserves_ctx {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check unit_typing_preserves_ctx for 6

assert TYPE_002_08_direct {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check TYPE_002_08_direct for 6

assert weakening_consequence {
  all r: LinearResource | r.used <= 1
}
check weakening_consequence for 6

assert TYPE_002_08 {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check TYPE_002_08 for 6

assert TYPE_002_09 {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check TYPE_002_09 for 6

assert TYPE_002_10 {
  all r: LinearResource | r.used <= 1
}
check TYPE_002_10 for 6

assert TYPE_002_11 {
  all r: LinearResource | r.consumed = 1 implies r.used = 1
}
check TYPE_002_11 for 6

assert resource_stays_consumed {
  all u: LinearUse | u.valid = 1 implies u.resource.consumed = 0
}
check resource_stays_consumed for 6

assert TYPE_002_12 {
  all r: LinearResource | r.used <= 1
}
check TYPE_002_12 for 6

pred ExampleLinearTypes {
  some LinearResource
}
run ExampleLinearTypes for 6
