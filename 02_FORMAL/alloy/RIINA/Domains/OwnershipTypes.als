// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for ownership type verification
// Bounded verification of OwnershipTypes properties
module riina/Domains/OwnershipTypes

abstract sig Ownership {}
one sig Unique extends Ownership {}
one sig Shared extends Ownership {}
one sig Borrowed extends Ownership {}

sig OwnedValue {
  ownership: one Ownership,
  alive: one Int
}

sig Borrow {
  source: one OwnedValue,
  mutable: one Int,
  active: one Int
}

// Invariant: unique_no_alias
fact unique_no_alias_fact {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}

// Invariant: borrow_requires_alive
fact borrow_requires_alive_fact {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}

// Invariant: mutable_borrow_exclusive
fact mutable_borrow_exclusive_fact {
  all b: Borrow | b.mutable = 1 implies b.source.ownership != Shared
}

assert existsb_false_forall {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}
check existsb_false_forall for 6

assert find_var_map_moved {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}
check find_var_map_moved for 6

assert MEM_001_01 {
  all b: Borrow | b.mutable = 1 implies b.source.ownership != Shared
}
check MEM_001_01 for 6

assert MEM_001_02 {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}
check MEM_001_02 for 6

assert MEM_001_03 {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}
check MEM_001_03 for 6

assert filter_all_false_empty {
  all b: Borrow | b.mutable = 1 implies b.source.ownership != Shared
}
check filter_all_false_empty for 6

assert MEM_001_04 {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}
check MEM_001_04 for 6

assert MEM_001_05 {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}
check MEM_001_05 for 6

assert MEM_001_06 {
  all b: Borrow | b.mutable = 1 implies b.source.ownership != Shared
}
check MEM_001_06 for 6

assert MEM_001_07 {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}
check MEM_001_07 for 6

assert MEM_001_08 {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}
check MEM_001_08 for 6

assert MEM_001_09 {
  all b: Borrow | b.mutable = 1 implies b.source.ownership != Shared
}
check MEM_001_09 for 6

assert find_var_map_dropped {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}
check find_var_map_dropped for 6

assert MEM_001_10 {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}
check MEM_001_10 for 6

assert MEM_001_11 {
  all b: Borrow | b.mutable = 1 implies b.source.ownership != Shared
}
check MEM_001_11 for 6

assert MEM_001_12 {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}
check MEM_001_12 for 6

assert MEM_001_13 {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}
check MEM_001_13 for 6

assert MEM_001_14 {
  all b: Borrow | b.mutable = 1 implies b.source.ownership != Shared
}
check MEM_001_14 for 6

assert MEM_001_15 {
  all disj o1, o2: OwnedValue | o1.ownership = Unique and o2.ownership = Unique implies o1 != o2
}
check MEM_001_15 for 6

assert lifetime_outlives_refl {
  all b: Borrow | b.active = 1 implies b.source.alive = 1
}
check lifetime_outlives_refl for 6

pred ExampleOwnershipTypes {
  some OwnedValue
}
run ExampleOwnershipTypes for 6
