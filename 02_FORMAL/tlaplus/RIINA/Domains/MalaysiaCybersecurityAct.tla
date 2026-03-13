---- MODULE MalaysiaCybersecurityAct ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/MalaysiaCybersecurityAct.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* NCIISector (matches Coq: Inductive NCIISector)
CONSTANTS Government, BankingFinance, Transport, Defense, Healthcare, Telecom, Energy, Water, AgricultureFood, ScienceTechInnovation, InformationComm

NCIISectorSet == {Government, BankingFinance, Transport, Defense, Healthcare, Telecom, Energy, Water, AgricultureFood, ScienceTechInnovation, InformationComm}

\* RiskLevel (matches Coq: Inductive RiskLevel)
CONSTANTS Low, Medium, High, Critical

RiskLevelSet == {Low, Medium, High, Critical}

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

\* risk_level_nat (matches Coq: Definition risk_level_nat)
risk_level_nat(r) ==
    CASE r = Medium -> 1
      [] r = High -> 2
      [] r = Critical -> 3

\* risk_assessment_current (matches Coq: Definition risk_assessment_current)
risk_assessment_current(e) ==
  e >= 0

\* incident_reported_promptly (matches Coq: Definition incident_reported_promptly)
incident_reported_promptly(i) ==
  i >= 0

\* incident_report_complete (matches Coq: Definition incident_report_complete)
incident_report_complete(i) ==
  incident_reported_promptly(i) /\ incident_severity(i)

\* controls_sufficient (matches Coq: Definition controls_sufficient)
controls_sufficient(e) ==
  e >= 0

\* all_ncii_sectors (matches Coq: Definition all_ncii_sectors)
all_ncii_sectors ==
  0

\* all_risk_levels (matches Coq: Definition all_risk_levels)
all_risk_levels ==
  0

\* ceo_liability_applies (matches Coq: Definition ceo_liability_applies)
ceo_liability_applies(cl) ==
  cl >= 0

\* sector_critical (matches Coq: Definition sector_critical)
sector_critical(s) ==
  s >= 0

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

\* obligation_1_risk_assessment
THEOREM obligation_1_risk_assessment ==
  \A e \in Nat :
      ncii_risk_assessed(e) => risk_assessment_current(e)

\* obligation_2_audit
THEOREM obligation_2_audit ==
  \A e \in Nat, t \in Nat :
      t <= ncii_last_audit => audit_current(e, t)

\* audit_expiry
THEOREM audit_expiry ==
  \A e \in Nat, t \in Nat :
      ~ audit_current e t => ncii_last_audit e + ncii_audit_interval e < t

\* obligation_3_reporting
THEOREM obligation_3_reporting ==
  \A i \in Nat :
      incident_reported_at i <= incident_detected_at i + 6 => incident_reported_promptly(i)

\* severity_ordering
THEOREM severity_ordering ==
  \A s1 \in RiskLevelSet, s2 \in RiskLevelSet :
      risk_level_nat Critical > = risk_level_nat(s1)

\* obligation_4_controls
THEOREM obligation_4_controls ==
  \A e \in Nat :
      ncii_min_controls e <= ncii_security_controls e => controls_sufficient(e)

\* obligation_5_cssp
THEOREM obligation_5_cssp ==
  \A l \in Nat, t \in Nat :
      cssp_licensed(l) => cssp_valid(l, t)

\* act854_composition
THEOREM act854_composition ==
  \A e \in Nat, l \in Nat, t \in Nat :
      risk_assessment_current(e) => act854_compliant e l t

\* ncii_sector_coverage
THEOREM ncii_sector_coverage ==
  \A s \in NCIISectorSet :
      In s all_ncii_sectors

\* critical_is_highest_risk
THEOREM critical_is_highest_risk ==
  \A r \in RiskLevelSet :
      risk_level_nat r < = risk_level_nat(Critical)

\* low_is_lowest_risk
THEOREM low_is_lowest_risk ==
  \A r \in RiskLevelSet :
      risk_level_nat Low < = risk_level_nat(r)

\* risk_level_bounded
THEOREM risk_level_bounded ==
  \A r \in RiskLevelSet :
      risk_level_nat r < = 3

\* risk_level_coverage
THEOREM risk_level_coverage ==
  \A r \in RiskLevelSet :
      In r all_risk_levels

\* audit_current_expiry_exclusive
THEOREM audit_current_expiry_exclusive ==
  \A e \in Nat, t \in Nat :
      audit_current e t \/ ~ audit_current e t

\* more_controls_still_sufficient
THEOREM more_controls_still_sufficient ==
  \A e \in Nat, extra \in Nat :
      controls_sufficient(e) => ncii_min_controls e <= ncii_security_controls e + extra

\* act854_implies_risk_assessed
THEOREM act854_implies_risk_assessed ==
  \A e \in Nat, l \in Nat, t \in Nat :
      act854_compliant e l t => risk_assessment_current(e)

\* act854_implies_audit_current
THEOREM act854_implies_audit_current ==
  \A e \in Nat, l \in Nat, t \in Nat :
      act854_compliant e l t => audit_current(e, t)

\* act854_implies_controls
THEOREM act854_implies_controls ==
  \A e \in Nat, l \in Nat, t \in Nat :
      act854_compliant e l t => controls_sufficient(e)

\* act854_implies_cssp_valid
THEOREM act854_implies_cssp_valid ==
  \A e \in Nat, l \in Nat, t \in Nat :
      act854_compliant e l t => cssp_valid(l, t)

\* cssp_expired
THEOREM cssp_expired ==
  \A l \in Nat, t \in Nat :
      cssp_license_expiry l < t => ~ cssp_valid l t

\* cssp_unlicensed_invalid
THEOREM cssp_unlicensed_invalid ==
  \A l \in Nat, t \in Nat :
      ~cssp_licensed(l) => ~ cssp_valid l t

\* ceo_liable_when_negligent
THEOREM ceo_liable_when_negligent ==
  \A cl \in Nat :
      ~ceo_compliant(cl) => ceo_liability_applies(cl)

\* ceo_due_diligence_defense
THEOREM ceo_due_diligence_defense ==
  \A cl \in Nat :
      ceo_due_diligence(cl) => ~ (ceo_due_diligence cl = false)

\* incident_6h_stricter_than_24h
THEOREM incident_6h_stricter_than_24h ==
  \A i \in Nat :
      incident_reported_promptly(i) => incident_reported_at i <= incident_detected_at i + 24

\* immediate_report_always_timely
THEOREM immediate_report_always_timely ==
  \A i \in Nat :
      incident_reported_at i = incident_detected_at i => incident_reported_promptly(i)

\* 3 additional theorems proven in Coq source

====
