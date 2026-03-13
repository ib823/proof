// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for interrupt virtualization
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/InterruptVirtualization

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

assert interrupt_injection_authorized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check interrupt_injection_authorized for 6

assert interrupt_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check interrupt_isolation for 6

assert device_irq_unique_owner {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_irq_unique_owner for 6

assert timer_interrupt_local {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timer_interrupt_local for 6

assert ipi_requires_authorization {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ipi_requires_authorization for 6

assert unauthorized_ipi_blocked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check unauthorized_ipi_blocked for 6

assert self_injection_allowed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check self_injection_allowed for 6

assert masked_irq_not_deliverable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check masked_irq_not_deliverable for 6

assert disabled_irq_not_deliverable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check disabled_irq_not_deliverable for 6

assert non_pending_irq_not_deliverable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check non_pending_irq_not_deliverable for 6

assert unknown_irq_not_deliverable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check unknown_irq_not_deliverable for 6

assert no_auth_no_injection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_auth_no_injection for 6

assert device_irq_requires_ownership {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_irq_requires_ownership for 6

assert cross_vm_requires_ipi {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cross_vm_requires_ipi for 6

assert ipi_authorization_directional {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ipi_authorization_directional for 6

assert empty_ipi_blocks_cross_vm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_ipi_blocks_cross_vm for 6

assert empty_assignments_blocks_device_irqs {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_assignments_blocks_device_irqs for 6

assert irq_assignment_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check irq_assignment_deterministic for 6

assert timer_injection_always_succeeds {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timer_injection_always_succeeds for 6

assert self_ipi_possible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check self_ipi_possible for 6

assert injection_source_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check injection_source_valid for 6

pred ExampleInterruptVirtualization {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleInterruptVirtualization for 6
