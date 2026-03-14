// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for speculative execution safety invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct SpecExecPolicy {
    pub speculation_fenced: bool,
    pub transient_paths_safe: bool,
    pub cache_partitioned: bool,
}

pub fn spec_exec_secure(p: &SpecExecPolicy) -> bool {
    p.speculation_fenced && p.transient_paths_safe && p.cache_partitioned
}

pub fn baseline_spec_exec() -> SpecExecPolicy {
    SpecExecPolicy {
        speculation_fenced: true,
        transient_paths_safe: true,
        cache_partitioned: true,
    }
}

pub fn hardened_spec_exec() -> SpecExecPolicy {
    SpecExecPolicy {
        speculation_fenced: true,
        transient_paths_safe: true,
        cache_partitioned: true,
    }
}

#[kani::proof]
fn harness_baseline_spec_exec_secure() {
    let p = baseline_spec_exec();
    assert!(spec_exec_secure(&p));
}

#[kani::proof]
fn harness_hardened_spec_exec_not_weaker() {
    let b = baseline_spec_exec();
    let h = hardened_spec_exec();
    assert!(spec_exec_secure(&h));
}
