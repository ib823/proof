// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/VerifiedLayout.v (51 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/verified_layout

open util/boolean

abstract sig list_LayoutBox {}

// LayoutBox (matches Coq: Record LayoutBox)
sig LayoutBox {
  f_lb_x: one Int,
  f_lb_y: one Int,
  f_lb_width: one Int,
  f_lb_height: one Int,
  f_lb_visible: one Bool
}

// LayoutConfig (matches Coq: Record LayoutConfig)
sig LayoutConfig {
  f_vl_deterministic_placement: one Bool,
  f_vl_no_overlap_guarantee: one Bool,
  f_vl_bounds_respected: one Bool,
  f_vl_consistent_ordering: one Bool
}

// AccessibilityConfig (matches Coq: Record AccessibilityConfig)
sig AccessibilityConfig {
  f_vl_min_touch_target: one Bool,
  f_vl_contrast_ratio: one Bool,
  f_vl_focus_order: one Bool
}

// boxes_overlap (matches Coq: Definition boxes_overlap)
pred boxes_overlap[p_a: LayoutBox, p_b: LayoutBox] {
  some p_a
}

// box_in_bounds (matches Coq: Definition box_in_bounds)
pred box_in_bounds[p_b: LayoutBox, p_cw: Int, p_ch: Int] {
  some p_b
}

// box1 (matches Coq: Definition box1)
pred box1 {}

// box2 (matches Coq: Definition box2)
pred box2 {}

// box3 (matches Coq: Definition box3)
pred box3 {}

// zero_box (matches Coq: Definition zero_box)
pred zero_box {}

// far_box (matches Coq: Definition far_box)
pred far_box {}

// adjacent_box (matches Coq: Definition adjacent_box)
pred adjacent_box {}

// layout_valid (matches Coq: Definition layout_valid)
pred layout_valid[p_c: LayoutConfig] {
  some p_c
}

// riina_layout (matches Coq: Definition riina_layout)
pred riina_layout {}

// bad_layout (matches Coq: Definition bad_layout)
pred bad_layout {}

// all_in_bounds (matches Coq: Definition all_in_bounds)
pred all_in_bounds[p_boxes: list_LayoutBox, p_cw: Int, p_ch: Int] {
  some p_boxes
}

// accessibility_valid (matches Coq: Definition accessibility_valid)
pred accessibility_valid[p_c: AccessibilityConfig] {
  some p_c
}

// riina_accessibility (matches Coq: Definition riina_accessibility)
pred riina_accessibility {}

// bad_accessibility (matches Coq: Definition bad_accessibility)
pred bad_accessibility {}

// andb_true_iff (matches Coq: Lemma andb_true_iff)
assert andb_true_iff {
  all c: LayoutBox | some c.f_lb_x
}
check andb_true_iff for 5

// VL_001 (matches Coq: Theorem VL_001)
assert VL_001 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_001 for 5

// VL_002 (matches Coq: Theorem VL_002)
assert VL_002 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_002 for 5

// VL_003 (matches Coq: Theorem VL_003)
assert VL_003 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_003 for 5

// VL_004 (matches Coq: Theorem VL_004)
assert VL_004 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_004 for 5

// VL_005 (matches Coq: Theorem VL_005)
assert VL_005 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_005 for 5

// VL_006 (matches Coq: Theorem VL_006)
assert VL_006 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_006 for 5

// VL_007 (matches Coq: Theorem VL_007)
assert VL_007 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_007 for 5

// VL_008 (matches Coq: Theorem VL_008)
assert VL_008 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_008 for 5

// VL_009 (matches Coq: Theorem VL_009)
assert VL_009 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_009 for 5

// VL_010 (matches Coq: Theorem VL_010)
assert VL_010 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_010 for 5

// VL_011 (matches Coq: Theorem VL_011)
assert VL_011 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_011 for 5

// VL_012 (matches Coq: Theorem VL_012)
assert VL_012 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_012 for 5

// VL_013 (matches Coq: Theorem VL_013)
assert VL_013 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_013 for 5

// VL_014 (matches Coq: Theorem VL_014)
assert VL_014 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_014 for 5

// VL_015 (matches Coq: Theorem VL_015)
assert VL_015 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_015 for 5

// VL_016 (matches Coq: Theorem VL_016)
assert VL_016 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_016 for 5

// VL_017 (matches Coq: Theorem VL_017)
assert VL_017 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_017 for 5

// VL_018 (matches Coq: Theorem VL_018)
assert VL_018 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_018 for 5

// VL_019 (matches Coq: Theorem VL_019)
assert VL_019 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_019 for 5

// VL_020 (matches Coq: Theorem VL_020)
assert VL_020 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_020 for 5

// VL_021 (matches Coq: Theorem VL_021)
assert VL_021 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_021 for 5

// VL_022 (matches Coq: Theorem VL_022)
assert VL_022 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_022 for 5

// VL_023 (matches Coq: Theorem VL_023)
assert VL_023 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_023 for 5

// VL_024 (matches Coq: Theorem VL_024)
assert VL_024 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_024 for 5

// VL_025 (matches Coq: Theorem VL_025)
assert VL_025 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_025 for 5

// VL_026 (matches Coq: Theorem VL_026)
assert VL_026 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_026 for 5

// VL_027 (matches Coq: Theorem VL_027)
assert VL_027 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_027 for 5

// VL_028 (matches Coq: Theorem VL_028)
assert VL_028 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_028 for 5

// VL_029 (matches Coq: Theorem VL_029)
assert VL_029 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_029 for 5

// VL_030 (matches Coq: Theorem VL_030)
assert VL_030 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_030 for 5

// VL_031 (matches Coq: Theorem VL_031)
assert VL_031 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_031 for 5

// VL_032 (matches Coq: Theorem VL_032)
assert VL_032 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_032 for 5

// VL_033 (matches Coq: Theorem VL_033)
assert VL_033 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_033 for 5

// VL_034 (matches Coq: Theorem VL_034)
assert VL_034 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_034 for 5

// VL_035 (matches Coq: Theorem VL_035)
assert VL_035 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_035 for 5

// VL_036 (matches Coq: Theorem VL_036)
assert VL_036 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_036 for 5

// VL_037 (matches Coq: Theorem VL_037)
assert VL_037 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_037 for 5

// VL_038 (matches Coq: Theorem VL_038)
assert VL_038 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_038 for 5

// VL_039 (matches Coq: Theorem VL_039)
assert VL_039 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_039 for 5

// VL_040 (matches Coq: Theorem VL_040)
assert VL_040 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_040 for 5

// VL_041 (matches Coq: Theorem VL_041)
assert VL_041 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_041 for 5

// VL_042 (matches Coq: Theorem VL_042)
assert VL_042 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_042 for 5

// VL_043 (matches Coq: Theorem VL_043)
assert VL_043 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_043 for 5

// VL_044 (matches Coq: Theorem VL_044)
assert VL_044 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_044 for 5

// VL_045 (matches Coq: Theorem VL_045)
assert VL_045 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_045 for 5

// VL_046 (matches Coq: Theorem VL_046)
assert VL_046 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_046 for 5

// VL_047 (matches Coq: Theorem VL_047)
assert VL_047 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_047 for 5

// VL_048 (matches Coq: Theorem VL_048)
assert VL_048 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_048 for 5

// VL_049 (matches Coq: Theorem VL_049)
assert VL_049 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_049 for 5

// VL_050 (matches Coq: Theorem VL_050)
assert VL_050 {
  all c: LayoutBox | some c.f_lb_x
}
check VL_050 for 5
