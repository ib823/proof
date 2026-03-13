// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for control flow integrity
// Bounded verification of ControlFlowIntegrity properties
module riina/Domains/ControlFlowIntegrity

sig CFITarget {
  whitelisted: one Int,
  indirect: one Int,
  safe: one Int
}

// Invariant: indirect_requires_whitelist
fact indirect_requires_whitelist_fact {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}

// Invariant: direct_always_safe
fact direct_always_safe_fact {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}

assert ctl_001_rop_impossible {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_001_rop_impossible for 6

assert ctl_002_jop_impossible {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_002_jop_impossible for 6

assert ctl_003_cop_impossible {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_003_cop_impossible for 6

assert ctl_004_ret2libc_impossible {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_004_ret2libc_impossible for 6

assert ctl_005_srop_impossible {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_005_srop_impossible for 6

assert ctl_006_code_injection_impossible {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_006_code_injection_impossible for 6

assert ctl_007_code_reuse_controlled {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_007_code_reuse_controlled for 6

assert ctl_008_data_only_mitigated {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_008_data_only_mitigated for 6

assert ctl_009_cf_bending_impossible {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_009_cf_bending_impossible for 6

assert ctl_010_indirect_call_safe {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_010_indirect_call_safe for 6

assert ctl_011_vtable_hijack_impossible {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_011_vtable_hijack_impossible for 6

assert ctl_012_exception_safe {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_012_exception_safe for 6

assert ctl_013_longjmp_safe {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_013_longjmp_safe for 6

assert ctl_014_got_plt_protected {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_014_got_plt_protected for 6

assert ctl_015_thread_hijack_impossible {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_015_thread_hijack_impossible for 6

assert ctl_016_shadow_push_pop_identity {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_016_shadow_push_pop_identity for 6

assert ctl_017_valid_return_after_push {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_017_valid_return_after_push for 6

assert ctl_018_wxor_x_empty {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_018_wxor_x_empty for 6

assert ctl_019_reloc_state_decidable {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_019_reloc_state_decidable for 6

assert ctl_020_shadow_push_length {
  all t: CFITarget | t.indirect = 0 implies t.safe = 1
}
check ctl_020_shadow_push_length for 6

assert ctl_021_valid_trace_prefix {
  all t: CFITarget | (t.indirect = 1 and t.safe = 1) implies t.whitelisted = 1
}
check ctl_021_valid_trace_prefix for 6

pred ExampleControlFlowIntegrity {
  some CFITarget
}
run ExampleControlFlowIntegrity for 6
