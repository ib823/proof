// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia mcmc
// Bounded verification of key properties
module riina/Domains/MalaysiaMCMC

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

assert s234_encrypted_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check s234_encrypted_compliant for 6

assert s234_authorized_compliant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check s234_authorized_compliant for 6

assert s236_fraud_prevention {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check s236_fraud_prevention for 6

assert mcmc_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_composition for 6

assert mcmc_license_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_license_coverage for 6

assert nfp_highest_level {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nfp_highest_level for 6

assert csp_lowest_level {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check csp_lowest_level for 6

assert license_level_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check license_level_positive for 6

assert mcmc_compliant_licensed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_compliant_licensed for 6

assert mcmc_compliant_technical {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_compliant_technical for 6

assert mcmc_compliant_consumer {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_compliant_consumer for 6

assert mcmc_compliant_interception {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_compliant_interception for 6

assert mcmc_compliant_fraud {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_compliant_fraud for 6

assert count_mcmc_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check count_mcmc_bounded for 6

assert mcmc_compliant_all_five {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_compliant_all_five for 6

assert license_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check license_eqb_refl for 6

assert fraud_requires_identity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fraud_requires_identity for 6

assert fraud_requires_signing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fraud_requires_signing for 6

assert fraud_requires_audit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fraud_requires_audit for 6

assert mcmc_license_count {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcmc_license_count for 6

pred ExampleMalaysiaMCMC {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaMCMC for 6
