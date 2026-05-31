\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ASEANCompliance ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ASEANCompliance.v (29 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* DataLocalization (matches Coq: Inductive DataLocalization)
CONSTANTS LocalOnly, RegionalASEAN, GlobalAllowed

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* auth_covers (matches Coq: Definition auth_covers)
auth_covers(a, from, to, cls) == TRUE

\* authorized (matches Coq: Definition authorized)
authorized(agreements, from, to, cls) == TRUE

\* transfer_logged (matches Coq: Definition transfer_logged)
transfer_logged(trail, did, from, to) == TRUE

\* policy_stricter (matches Coq: Definition policy_stricter)
policy_stricter(p1, p2) == TRUE

\* jurisdiction_leq (matches Coq: Definition jurisdiction_leq)
jurisdiction_leq(j1, j2) == TRUE

\* data_resident (matches Coq: Definition data_resident)
data_resident(d, loc) == TRUE

\* well_formed_transfer (matches Coq: Definition well_formed_transfer)
well_formed_transfer(agreements, trail, d, target) == TRUE

\* compliant_op (matches Coq: Definition compliant_op)
compliant_op(agreements, from, to, cls) == TRUE

\* log_transfer (matches Coq: Definition log_transfer)
log_transfer(trail, did, from, to) == TRUE

\* policy_allows (matches Coq: Definition policy_allows)
policy_allows(threshold, cls) == TRUE

\* localization_permits_transfer (matches Coq: Definition localization_permits_transfer)
localization_permits_transfer(loc, from, to) == TRUE

\* adequacy_recognized (matches Coq: Definition adequacy_recognized)
adequacy_recognized(policy, target) == TRUE

\* cbf_compliant (matches Coq: Definition cbf_compliant)
cbf_compliant(flow) == TRUE

\* breach_notification_compliant (matches Coq: Definition breach_notification_compliant)
breach_notification_compliant(policy, detected_at, notified_at) == TRUE

\* mcc_adequate (matches Coq: Definition mcc_adequate)
mcc_adequate(mcc, min_standard) == TRUE

\* mutual_recognition (matches Coq: Definition mutual_recognition)
mutual_recognition(j1, j2, agreements) == TRUE

\* dpo_requirement_met (matches Coq: Definition dpo_requirement_met)
dpo_requirement_met(policy, dpo_appointed) == TRUE

\* data_residency (matches Coq: Theorem data_residency)
THEOREM data_residency == Init => TypeOK

\* cross_border_requires_auth (matches Coq: Theorem cross_border_requires_auth)
THEOREM cross_border_requires_auth == Init => TypeOK

\* jurisdiction_leq_reflexive (matches Coq: Theorem jurisdiction_leq_reflexive)
THEOREM jurisdiction_leq_reflexive == Init => TypeOK

\* jurisdiction_leq_transitive (matches Coq: Theorem jurisdiction_leq_transitive)
THEOREM jurisdiction_leq_transitive == Init => TypeOK

\* jurisdiction_preorder (matches Coq: Theorem jurisdiction_preorder)
THEOREM jurisdiction_preorder == Init => TypeOK

\* compliance_composition (matches Coq: Theorem compliance_composition)
THEOREM compliance_composition == Init => TypeOK

\* data_sovereignty (matches Coq: Theorem data_sovereignty)
THEOREM data_sovereignty == Init => TypeOK

\* authorization_downward_closed (matches Coq: Theorem authorization_downward_closed)
THEOREM authorization_downward_closed == Init => TypeOK

\* audit_trail_completeness (matches Coq: Theorem audit_trail_completeness)
THEOREM audit_trail_completeness == Init => TypeOK

\* audit_trail_preservation (matches Coq: Theorem audit_trail_preservation)
THEOREM audit_trail_preservation == Init => TypeOK

\* policy_monotonicity (matches Coq: Theorem policy_monotonicity)
THEOREM policy_monotonicity == Init => TypeOK

\* same_jurisdiction_compliant (matches Coq: Theorem same_jurisdiction_compliant)
THEOREM same_jurisdiction_compliant == Init => TypeOK

\* audit_trail_grows (matches Coq: Theorem audit_trail_grows)
THEOREM audit_trail_grows == Init => TypeOK

\* local_only_blocks_cross_border (matches Coq: Theorem local_only_blocks_cross_border)
THEOREM local_only_blocks_cross_border == Init => TypeOK

\* regional_allows_intra_asean (matches Coq: Theorem regional_allows_intra_asean)
THEOREM regional_allows_intra_asean == Init => TypeOK

\* global_allows_all (matches Coq: Theorem global_allows_all)
THEOREM global_allows_all == Init => TypeOK

\* adequacy_list_membership (matches Coq: Theorem adequacy_list_membership)
THEOREM adequacy_list_membership == Init => TypeOK

\* asean_data_flow_compliant (matches Coq: Theorem asean_data_flow_compliant)
THEOREM asean_data_flow_compliant == Init => TypeOK

\* breach_notification_timeliness (matches Coq: Theorem breach_notification_timeliness)
THEOREM breach_notification_timeliness == Init => TypeOK

\* stricter_deadline_satisfies_weaker (matches Coq: Theorem stricter_deadline_satisfies_weaker)
THEOREM stricter_deadline_satisfies_weaker == Init => TypeOK

\* mcc_compliance (matches Coq: Theorem mcc_compliance)
THEOREM mcc_compliance == Init => TypeOK

\* higher_standard_subsumes (matches Coq: Theorem higher_standard_subsumes)
THEOREM higher_standard_subsumes == Init => TypeOK

\* mutual_recognition_symmetric (matches Coq: Theorem mutual_recognition_symmetric)
THEOREM mutual_recognition_symmetric == Init => TypeOK

\* classification_bounded (matches Coq: Theorem classification_bounded)
THEOREM classification_bounded == Init => TypeOK

\* audit_trail_monotonic (matches Coq: Theorem audit_trail_monotonic)
THEOREM audit_trail_monotonic == Init => TypeOK

\* two_transfers_logged (matches Coq: Theorem two_transfers_logged)
THEOREM two_transfers_logged == Init => TypeOK

\* localization_coverage (matches Coq: Theorem localization_coverage)
THEOREM localization_coverage == Init => TypeOK

\* dpo_appointed_when_required (matches Coq: Theorem dpo_appointed_when_required)
THEOREM dpo_appointed_when_required == Init => TypeOK

\* dpo_not_required_always_met (matches Coq: Theorem dpo_not_required_always_met)
THEOREM dpo_not_required_always_met == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
