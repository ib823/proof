// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually maintained Phase 2 smoke model for REQ-10.
// Scope: bounded access-control slice for procurement workflow actors.
// This file is intentionally small, finite, and executable with Alloy 6.

module riina/active/telus_procurement_access_control

abstract sig Permission {}
one sig SubmitRequest, ApproveRequest, BindVendor, ViewAudit, DelegateApproval, RevokeCapability extends Permission {}

abstract sig Resource {}
one sig ProcurementCaseResource, VendorRegistryResource, AuditLedgerResource extends Resource {}

abstract sig Role {
  inherits: set Role,
  grants: set Permission
}

one sig Requester, Approver, SeniorApprover, VendorManager, Auditor extends Role {}

sig Principal {
  roles: set Role
}

sig Capability {
  holder: one Principal,
  resource: one Resource,
  perms: set Permission,
  parent: lone Capability
}

sig ProcurementCase {
  requester: one Principal,
  approver: one Principal,
  vendorManager: one Principal,
  auditor: one Principal,
  requestCap: one Capability,
  approvalCap: one Capability,
  vendorCap: one Capability,
  auditCap: one Capability
}

fun effectivePerms[p: Principal]: set Permission {
  p.roles.*inherits.grants
}

fact RoleHierarchy {
  no iden & ^inherits

  no Requester.inherits
  no Approver.inherits
  SeniorApprover.inherits = Approver
  no VendorManager.inherits
  no Auditor.inherits

  Requester.grants = SubmitRequest
  Approver.grants = ApproveRequest
  SeniorApprover.grants = DelegateApproval + RevokeCapability
  VendorManager.grants = BindVendor
  Auditor.grants = ViewAudit
}

fact CapabilityDiscipline {
  no iden & ^parent

  all c: Capability |
    c.perms in effectivePerms[c.holder]

  all c: Capability |
    some c.parent implies {
      c.resource = c.parent.resource
      c.perms in c.parent.perms
    }

  all c: Capability |
    c.resource = ProcurementCaseResource implies
      c.perms in SubmitRequest + ApproveRequest + DelegateApproval + RevokeCapability

  all c: Capability |
    c.resource = VendorRegistryResource implies
      c.perms in BindVendor

  all c: Capability |
    c.resource = AuditLedgerResource implies
      c.perms in ViewAudit
}

fact ProcurementWorkflow {
  all pc: ProcurementCase | {
    disj[pc.requester, pc.approver, pc.vendorManager, pc.auditor]
    disj[pc.requestCap, pc.approvalCap, pc.vendorCap, pc.auditCap]

    pc.requester.roles = Requester
    pc.vendorManager.roles = VendorManager
    pc.auditor.roles = Auditor
    pc.approver.roles in Approver + SeniorApprover

    pc.requestCap.holder = pc.requester
    pc.requestCap.resource = ProcurementCaseResource
    pc.requestCap.perms = SubmitRequest

    pc.approvalCap.holder = pc.approver
    pc.approvalCap.resource = ProcurementCaseResource
    pc.approvalCap.perms = ApproveRequest

    pc.vendorCap.holder = pc.vendorManager
    pc.vendorCap.resource = VendorRegistryResource
    pc.vendorCap.perms = BindVendor

    pc.auditCap.holder = pc.auditor
    pc.auditCap.resource = AuditLedgerResource
    pc.auditCap.perms = ViewAudit
  }
}

pred ExampleTelusProcurement {
  some pc: ProcurementCase |
    some root: Capability | {
      pc.approver.roles = SeniorApprover
      root not in pc.requestCap + pc.approvalCap + pc.vendorCap + pc.auditCap
      root.holder = pc.approver
      root.resource = ProcurementCaseResource
      root.perms = ApproveRequest + DelegateApproval
      no root.parent
      pc.approvalCap.parent = root
    }
}

assert SeniorApproverInheritsApproval {
  all p: Principal |
    SeniorApprover in p.roles implies ApproveRequest in effectivePerms[p]
}

assert CapabilitiesRespectLeastPrivilege {
  all c: Capability |
    c.perms in effectivePerms[c.holder]
}

assert DerivedCapabilitiesCannotAmplify {
  all c: Capability |
    some c.parent implies
      c.resource = c.parent.resource and c.perms in c.parent.perms
}

assert ProcurementSeparationOfDuty {
  all pc: ProcurementCase |
    disj[pc.requester, pc.approver, pc.vendorManager, pc.auditor]
}

assert AuditorsStayOperationallySeparated {
  all pc: ProcurementCase |
    no pc.auditor.roles & (Requester + Approver + SeniorApprover + VendorManager)
}

assert VendorManagersCannotApproveCases {
  all pc: ProcurementCase |
    ApproveRequest not in effectivePerms[pc.vendorManager]
}

run ExampleTelusProcurement for exactly 4 Principal, exactly 5 Capability, exactly 1 ProcurementCase

check SeniorApproverInheritsApproval for 6
check CapabilitiesRespectLeastPrivilege for 6
check DerivedCapabilitiesCannotAmplify for 6
check ProcurementSeparationOfDuty for 6
check AuditorsStayOperationallySeparated for 6
check VendorManagersCannotApproveCases for 6
