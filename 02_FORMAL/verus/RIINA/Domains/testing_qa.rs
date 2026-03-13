// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Testing Qa domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Testing Qa verification
pub struct TestSuite {
    pub coverage_sufficient: bool,
    pub oracle_correct: bool,
    pub regression_detected: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn testing_qa_secure(s: TestSuite) -> bool {
    s.coverage_sufficient && s.oracle_correct && s.regression_detected && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_testing_qa() -> TestSuite {
    TestSuite {
        coverage_sufficient: true,
        oracle_correct: true,
        regression_detected: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_testing_qa() -> TestSuite {
    TestSuite {
        coverage_sufficient: true,
        oracle_correct: true,
        regression_detected: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures testing_qa_secure(baseline_testing_qa()),
{
    let b = baseline_testing_qa();
    assert(b.coverage_sufficient);
    assert(b.oracle_correct);
    assert(b.regression_detected);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures testing_qa_secure(hardened_testing_qa()),
{
    let h = hardened_testing_qa();
    assert(h.coverage_sufficient);
    assert(h.oracle_correct);
    assert(h.regression_detected);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        testing_qa_secure(hardened_testing_qa()),
        hardened_testing_qa().assurance_level >= baseline_testing_qa().assurance_level,
{
    let baseline = baseline_testing_qa();
    let hardened = hardened_testing_qa();
    assert(testing_qa_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !testing_qa_secure(TestSuite { coverage_sufficient: false, oracle_correct: true, regression_detected: true, assurance_level: 1 }),
        !testing_qa_secure(TestSuite { coverage_sufficient: true, oracle_correct: false, regression_detected: true, assurance_level: 1 }),
        !testing_qa_secure(TestSuite { coverage_sufficient: true, oracle_correct: true, regression_detected: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !testing_qa_secure(TestSuite { coverage_sufficient: true, oracle_correct: true, regression_detected: true, assurance_level: 0 }),
{
}

} // verus!
