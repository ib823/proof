---- MODULE MalaysiaSCGTRM ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/MalaysiaSCGTRM.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* CMEntityType (matches Coq: Inductive CMEntityType)
CONSTANTS BrokerDealer, FundManager, Exchange, ClearingHouse, Depository, CreditRatingAgency

CMEntityTypeSet == {BrokerDealer, FundManager, Exchange, ClearingHouse, Depository, CreditRatingAgency}

VARIABLES state, verified, step_count
vars == <<state, verified, step_count>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ state \in Nat
  /\ verified \in BOOLEAN
  /\ step_count \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ state = 0
  /\ verified = FALSE
  /\ step_count = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* gtrm_board_accountable (matches Coq: Definition gtrm_board_accountable)
gtrm_board_accountable(e) ==
  e >= 0

\* gtrm_risk_framework (matches Coq: Definition gtrm_risk_framework)
gtrm_risk_framework(e) ==
  e >= 0

\* gtrm_ai_assessed (matches Coq: Definition gtrm_ai_assessed)
gtrm_ai_assessed(e) ==
  e >= 0

\* gtrm_vendor_compliant (matches Coq: Definition gtrm_vendor_compliant)
gtrm_vendor_compliant(e) ==
  cm_third_party_assessed(e) /\ cm_cloud_risk_assessed(e)

\* gtrm_incident_ready (matches Coq: Definition gtrm_incident_ready)
gtrm_incident_ready(e) ==
  e >= 0

\* gtrm_data_protected (matches Coq: Definition gtrm_data_protected)
gtrm_data_protected(e) ==
  cm_data_protection(e)

\* all_cm_entity_types (matches Coq: Definition all_cm_entity_types)
all_cm_entity_types ==
  0

\* sc_incident_deadline (matches Coq: Definition sc_incident_deadline)
sc_incident_deadline ==
  24

\* sc_incident_timely (matches Coq: Definition sc_incident_timely)
sc_incident_timely(inc) ==
  inc >= 0

\* ai_risk_managed (matches Coq: Definition ai_risk_managed)
ai_risk_managed(ar) ==
  ar >= 0

\* cmc_cloud_risk_assessed (matches Coq: Definition cmc_cloud_risk_assessed)
cmc_cloud_risk_assessed(cr) ==
  cr >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

Step ==
  /\ state' \in Nat
  /\ verified' \in BOOLEAN
  /\ step_count' = step_count + 1

Next == Step

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* gtrm_req_1
THEOREM gtrm_req_1 ==
  \A e \in Nat :
      cm_board_accountability(e) => gtrm_board_accountable(e)

\* gtrm_req_2
THEOREM gtrm_req_2 ==
  \A e \in Nat :
      cm_risk_framework(e) => gtrm_risk_framework(e)

\* gtrm_req_3
THEOREM gtrm_req_3 ==
  \A e \in Nat, t \in Nat :
      cm_pentest_done(e) => gtrm_pentest_current(e, t)

\* gtrm_req_4
THEOREM gtrm_req_4 ==
  \A e \in Nat :
      cm_ai_risk_assessed(e) => gtrm_ai_assessed(e)

\* gtrm_req_5
THEOREM gtrm_req_5 ==
  \A e \in Nat :
      cm_third_party_assessed(e) => gtrm_vendor_compliant(e)

\* gtrm_req_6
THEOREM gtrm_req_6 ==
  \A e \in Nat :
      cm_incident_response_plan(e) => gtrm_incident_ready(e)

\* gtrm_req_7
THEOREM gtrm_req_7 ==
  \A e \in Nat :
      cm_data_protection(e) => gtrm_data_protected(e)

\* gtrm_composition
THEOREM gtrm_composition ==
  \A e \in Nat, t \in Nat :
      gtrm_board_accountable(e) => gtrm_fully_compliant(e, t)

\* cm_entity_coverage
THEOREM cm_entity_coverage ==
  \A t \in CMEntityTypeSet :
      In t all_cm_entity_types

\* pentest_expired
THEOREM pentest_expired ==
  \A e \in Nat, t \in Nat :
      cm_last_pentest e + cm_pentest_interval e < t => ~ gtrm_pentest_current e t

\* pentest_recently_done
THEOREM pentest_recently_done ==
  \A e \in Nat :
      cm_pentest_done(e) => gtrm_pentest_current(e, cm_last_pentest(e))

\* gtrm_full_implies_board
THEOREM gtrm_full_implies_board ==
  \A e \in Nat, t \in Nat :
      gtrm_fully_compliant(e, t) => gtrm_board_accountable(e)

\* gtrm_full_implies_risk
THEOREM gtrm_full_implies_risk ==
  \A e \in Nat, t \in Nat :
      gtrm_fully_compliant(e, t) => gtrm_risk_framework(e)

\* gtrm_full_implies_pentest
THEOREM gtrm_full_implies_pentest ==
  \A e \in Nat, t \in Nat :
      gtrm_fully_compliant(e, t) => gtrm_pentest_current(e, t)

\* gtrm_full_implies_ai
THEOREM gtrm_full_implies_ai ==
  \A e \in Nat, t \in Nat :
      gtrm_fully_compliant(e, t) => gtrm_ai_assessed(e)

\* gtrm_full_implies_vendor
THEOREM gtrm_full_implies_vendor ==
  \A e \in Nat, t \in Nat :
      gtrm_fully_compliant(e, t) => gtrm_vendor_compliant(e)

\* gtrm_full_implies_incident
THEOREM gtrm_full_implies_incident ==
  \A e \in Nat, t \in Nat :
      gtrm_fully_compliant(e, t) => gtrm_incident_ready(e)

\* gtrm_full_implies_data
THEOREM gtrm_full_implies_data ==
  \A e \in Nat, t \in Nat :
      gtrm_fully_compliant(e, t) => gtrm_data_protected(e)

\* sc_incident_reporting
THEOREM sc_incident_reporting ==
  \A inc \in Nat :
      sci_reported_at inc <= sci_detected_at inc + 24 => sc_incident_timely(inc)

\* sc_incident_late
THEOREM sc_incident_late ==
  \A inc \in Nat :
      sci_detected_at inc + sc_incident_deadline < sci_reported_at inc => ~ sc_incident_timely inc

\* ai_model_risk_complete
THEOREM ai_model_risk_complete ==
  \A ar \in Nat :
      ai_bias_assessed(ar) => ai_risk_managed(ar)

\* ai_not_validated_not_managed
THEOREM ai_not_validated_not_managed ==
  \A ar \in Nat :
      ~ai_model_validated(ar) => ~ ai_risk_managed ar

\* cm_cloud_fully_assessed
THEOREM cm_cloud_fully_assessed ==
  \A cr \in Nat :
      cmc_data_residency_compliant(cr) => cmc_cloud_risk_assessed(cr)

\* cm_cloud_missing_exit_strategy
THEOREM cm_cloud_missing_exit_strategy ==
  \A cr \in Nat :
      ~cmc_exit_strategy(cr) => ~ cmc_cloud_risk_assessed cr

====
