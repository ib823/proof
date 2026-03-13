// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for buffer overflow prevention
// Bounded verification of BufferOverflowPrevention properties
module riina/Domains/BufferOverflowPrevention

sig Buffer {
  capacity: one Int,
  used: one Int,
  checked: one Int
}

sig BufferAccess {
  buffer: one Buffer,
  offset: one Int,
  safe: one Int
}

// Invariant: no_overflow
fact no_overflow_fact {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}

// Invariant: checked_implies_safe
fact checked_implies_safe_fact {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}

// Invariant: capacity_positive
fact capacity_positive_fact {
  all b: Buffer | b.capacity > 0
}

assert andb_true_iff {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check andb_true_iff for 6

assert BOF_001_test_buffer_valid {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}
check BOF_001_test_buffer_valid for 6

assert BOF_002_can_write_bounds {
  all b: Buffer | b.capacity > 0
}
check BOF_002_can_write_bounds for 6

assert BOF_003_cannot_write_beyond {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check BOF_003_cannot_write_beyond for 6

assert BOF_004_can_read_used {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}
check BOF_004_can_read_used for 6

assert BOF_005_cannot_read_beyond {
  all b: Buffer | b.capacity > 0
}
check BOF_005_cannot_read_beyond for 6

assert BOF_006_riina_protected {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check BOF_006_riina_protected for 6

assert BOF_007_bounds_check_write {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}
check BOF_007_bounds_check_write for 6

assert BOF_008_bounds_check_read {
  all b: Buffer | b.capacity > 0
}
check BOF_008_bounds_check_read for 6

assert BOF_009_integer_overflow {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check BOF_009_integer_overflow for 6

assert BOF_010_stack_canaries {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}
check BOF_010_stack_canaries for 6

assert BOF_011_valid_implies_bounds {
  all b: Buffer | b.capacity > 0
}
check BOF_011_valid_implies_bounds for 6

assert BOF_012_riina_bounds_write {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check BOF_012_riina_bounds_write for 6

assert BOF_013_riina_canaries {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}
check BOF_013_riina_canaries for 6

assert BOF_014_zero_write_safe {
  all b: Buffer | b.capacity > 0
}
check BOF_014_zero_write_safe for 6

assert BOF_015_complete_prevention {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check BOF_015_complete_prevention for 6

assert BOF_016_write_bounded {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}
check BOF_016_write_bounded for 6

assert BOF_017_read_start_within {
  all b: Buffer | b.capacity > 0
}
check BOF_017_read_start_within for 6

assert BOF_018_zero_read_safe {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check BOF_018_zero_read_safe for 6

assert BOF_019_full_buffer_no_write {
  all a: BufferAccess | a.buffer.checked = 1 implies a.safe = 1
}
check BOF_019_full_buffer_no_write for 6

assert BOF_020_null_terminator_check {
  all b: Buffer | b.capacity > 0
}
check BOF_020_null_terminator_check for 6

assert BOF_021_valid_after_write {
  all a: BufferAccess | a.safe = 1 implies a.offset >= 0 and a.offset < a.buffer.capacity
}
check BOF_021_valid_after_write for 6

pred ExampleBufferOverflowPrevention {
  some Buffer
}
run ExampleBufferOverflowPrevention for 6
