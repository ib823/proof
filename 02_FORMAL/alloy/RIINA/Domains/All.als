// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Aggregator module for all domain verification
module riina/Domains/All

// This module verifies that all domain models are consistent

abstract sig Domain {
  verified: one Int,
  name: one Int
}

sig VerifiedDomain extends Domain {}

fact AllVerified {
  all d: Domain | d.verified = 1
}

assert all_domains_verified {
  all d: Domain | d.verified = 1
}
check all_domains_verified for 6

pred ExampleAll {
  some d: VerifiedDomain | d.verified = 1
}
run ExampleAll for 6
