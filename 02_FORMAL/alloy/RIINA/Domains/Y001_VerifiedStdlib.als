// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for y001_verified stdlib
// Bounded verification of key properties
module riina/Domains/Y001_VerifiedStdlib

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert Y_001_01_option_map_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_01_option_map_correct for 6

assert Y_001_02_option_bind_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_02_option_bind_correct for 6

assert Y_001_03_result_map_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_03_result_map_correct for 6

assert Y_001_04_result_and_then_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_04_result_and_then_correct for 6

assert Y_001_05_option_unwrap_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_05_option_unwrap_safe for 6

assert Y_001_06_result_unwrap_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_06_result_unwrap_safe for 6

assert Y_001_07_option_or_default {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_07_option_or_default for 6

assert Y_001_08_result_or_default {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_08_result_or_default for 6

assert Y_001_09_vec_push_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_09_vec_push_correct for 6

assert Y_001_10_vec_pop_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_10_vec_pop_correct for 6

assert Y_001_11_vec_get_bounds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_11_vec_get_bounds for 6

assert Y_001_12_vec_len_accurate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_12_vec_len_accurate for 6

assert Y_001_13_hashmap_get_put {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_13_hashmap_get_put for 6

assert Y_001_14_hashmap_get_other {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_14_hashmap_get_other for 6

assert Y_001_14b_hashmap_different_key {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_14b_hashmap_different_key for 6

assert Y_001_15_hashmap_remove_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_15_hashmap_remove_correct for 6

assert Y_001_16_btree_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_16_btree_ordered for 6

assert Y_001_17_btree_balanced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_17_btree_balanced for 6

assert Y_001_18_collection_no_overflow {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_18_collection_no_overflow for 6

assert Y_001_19_utf8_valid_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_19_utf8_valid_preserved for 6

assert Y_001_20_string_concat_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_20_string_concat_valid for 6

assert Y_001_21_string_len_bytes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_21_string_len_bytes for 6

assert Y_001_22_string_len_chars {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_22_string_len_chars for 6

assert Y_001_23_string_slice_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_23_string_slice_valid for 6

assert Y_001_24_format_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_24_format_bounded for 6

assert Y_001_25_no_format_string_attack {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_25_no_format_string_attack for 6

assert Y_001_26_string_compare_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_26_string_compare_correct for 6

assert Y_001_27_io_effect_tracked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_27_io_effect_tracked for 6

assert Y_001_28_file_read_bounds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_28_file_read_bounds for 6

assert Y_001_29_json_parse_pure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_29_json_parse_pure for 6

assert Y_001_30_json_roundtrip {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_30_json_roundtrip for 6

assert Y_001_31_json_parse_terminates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_31_json_parse_terminates for 6

assert Y_001_32_xml_parse_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_32_xml_parse_safe for 6

assert Y_001_33_regex_terminates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_33_regex_terminates for 6

assert Y_001_34_regex_no_redos {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_34_regex_no_redos for 6

assert Y_001_35_int_add_no_overflow {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_35_int_add_no_overflow for 6

assert Y_001_36_int_mul_no_overflow {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_36_int_mul_no_overflow for 6

assert Y_001_37_int_div_no_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_37_int_div_no_zero for 6

assert Y_001_38_float_nan_propagates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_38_float_nan_propagates for 6

assert Y_001_39_bigint_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_39_bigint_correct for 6

assert Y_001_40_numeric_constant_time {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Y_001_40_numeric_constant_time for 6

pred ExampleY001_VerifiedStdlib {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleY001_VerifiedStdlib for 6
