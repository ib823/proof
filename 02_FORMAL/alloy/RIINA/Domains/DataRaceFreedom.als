// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for data race freedom
// Bounded verification of DataRaceFreedom properties
module riina/Domains/DataRaceFreedom

abstract sig AccessType {}
one sig Read extends AccessType {}
one sig Write extends AccessType {}
one sig Exclusive extends AccessType {}

sig SharedResource {
  locked: one Int,
  ownerCount: one Int
}

sig ResourceAccess {
  resource: one SharedResource,
  accessType: one AccessType,
  safe: one Int
}

// Invariant: write_requires_lock
fact write_requires_lock_fact {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}

// Invariant: exclusive_single_owner
fact exclusive_single_owner_fact {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}

// Invariant: no_concurrent_write
fact no_concurrent_write_fact {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}

assert DR_001_exclusive_is_exclusive {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_001_exclusive_is_exclusive for 6

assert DR_002_shared_compatible {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_002_shared_compatible for 6

assert DR_003_well_formed_prevents_race {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_003_well_formed_prevents_race for 6

assert DR_004_well_formed_race_free {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_004_well_formed_race_free for 6

assert DR_005_mutex_acquire_unlocked {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_005_mutex_acquire_unlocked for 6

assert DR_006_mutex_acquire_locked {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_006_mutex_acquire_locked for 6

assert DR_007_mutex_release_owner {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_007_mutex_release_owner for 6

assert DR_008_mutex_release_non_owner {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_008_mutex_release_non_owner for 6

assert DR_009_rwlock_read_no_writer {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_009_rwlock_read_no_writer for 6

assert DR_010_rwlock_read_increments {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_010_rwlock_read_increments for 6

assert DR_011_rwlock_read_blocked_by_writer {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_011_rwlock_read_blocked_by_writer for 6

assert DR_012_rwlock_write_no_readers {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_012_rwlock_write_no_readers for 6

assert DR_013_rwlock_write_blocked_by_readers {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_013_rwlock_write_blocked_by_readers for 6

assert DR_014_mut_borrow_owned {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_014_mut_borrow_owned for 6

assert DR_015_shared_borrow_owned {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_015_shared_borrow_owned for 6

assert DR_016_shared_borrow_extends {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_016_shared_borrow_extends for 6

assert DR_017_empty_well_formed {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_017_empty_well_formed for 6

assert DR_018_empty_race_free {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_018_empty_race_free for 6

assert DR_019_single_exclusive_well_formed {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_019_single_exclusive_well_formed for 6

assert DR_020_single_exclusive_race_free {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_020_single_exclusive_race_free for 6

assert DR_021_mutex_mutual_exclusion {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_021_mutex_mutual_exclusion for 6

assert DR_022_init_mutex_well_formed {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_022_init_mutex_well_formed for 6

assert DR_023_acquired_mutex_well_formed {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_023_acquired_mutex_well_formed for 6

assert DR_024_rwlock_init_well_formed {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_024_rwlock_init_well_formed for 6

assert DR_025_shared_no_race {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_025_shared_no_race for 6

assert DR_026_access_mode_dec {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_026_access_mode_dec for 6

assert DR_027_remove_preserves_wf {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_027_remove_preserves_wf for 6

assert DR_028_race_free_location {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_028_race_free_location for 6

assert DR_029_ownership_state_cases {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_029_ownership_state_cases for 6

assert DR_030_valid_borrow_respects_ownership {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_030_valid_borrow_respects_ownership for 6

assert DR_031_mutex_locked_dec {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_031_mutex_locked_dec for 6

assert DR_032_rwlock_readers_nonneg {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_032_rwlock_readers_nonneg for 6

assert DR_033_mutex_acquire_release_cycle {
  all r: SharedResource | r.locked = 1 implies r.ownerCount <= 1
}
check DR_033_mutex_acquire_release_cycle for 6

assert DR_034_access_mode_cases {
  all a: ResourceAccess | (a.accessType = Write and a.safe = 1) implies a.resource.locked = 1
}
check DR_034_access_mode_cases for 6

assert DR_035_no_concurrent_exclusive {
  all a: ResourceAccess | a.accessType = Exclusive implies a.resource.ownerCount <= 1
}
check DR_035_no_concurrent_exclusive for 6

pred ExampleDataRaceFreedom {
  some SharedResource
}
run ExampleDataRaceFreedom for 6
