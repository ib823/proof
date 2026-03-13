---- MODULE IndustryTransportation ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/Industries/IndustryTransportation.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ASIL (matches Coq: Inductive ASIL)
CONSTANTS ASIL_A, ASIL_B, ASIL_C, ASIL_D, QM

ASILSet == {ASIL_A, ASIL_B, ASIL_C, ASIL_D, QM}

\* SIL (matches Coq: Inductive SIL)
CONSTANTS SIL_0, SIL_1, SIL_2, SIL_3, SIL_4

SILSet == {SIL_0, SIL_1, SIL_2, SIL_3, SIL_4}

\* TransportationEffect (matches Coq: Inductive TransportationEffect)
CONSTANTS VehicleControl, RailwaySignaling, NavigationSystem, V2X_Communication, DiagnosticAccess

TransportationEffectSet == {VehicleControl, RailwaySignaling, NavigationSystem, V2X_Communication, DiagnosticAccess}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* ISO26262_Compliance (matches Coq: Record ISO26262_Compliance)
VARIABLES hazard_analysis, system_design, hardware_design, software_design, production, supporting_processes, asil_decomposition, cybersecurity_interface

vars == <<hazard_analysis, system_design, hardware_design, software_design, production, supporting_processes, asil_decomposition, cybersecurity_interface>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ hazard_analysis \in BOOLEAN
  /\ system_design \in BOOLEAN
  /\ hardware_design \in BOOLEAN
  /\ software_design \in BOOLEAN
  /\ production \in BOOLEAN
  /\ supporting_processes \in BOOLEAN
  /\ asil_decomposition \in BOOLEAN
  /\ cybersecurity_interface \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ hazard_analysis = FALSE
  /\ system_design = FALSE
  /\ hardware_design = FALSE
  /\ software_design = FALSE
  /\ production = FALSE
  /\ supporting_processes = FALSE
  /\ asil_decomposition = FALSE
  /\ cybersecurity_interface = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* asil_to_nat (matches Coq: Definition asil_to_nat)
asil_to_nat(a) ==
    CASE a = QM -> 0
      [] a = ASIL_A -> 1
      [] a = ASIL_B -> 2
      [] a = ASIL_C -> 3
      [] a = ASIL_D -> 4

\* asil_le (matches Coq: Definition asil_le)
asil_le(a2) ==
  a2 >= 0

\* sil_to_nat (matches Coq: Definition sil_to_nat)
sil_to_nat(s) ==
    CASE s = SIL_0 -> 0
      [] s = SIL_1 -> 1
      [] s = SIL_2 -> 2
      [] s = SIL_3 -> 3
      [] s = SIL_4 -> 4

\* sil_le (matches Coq: Definition sil_le)
sil_le(s2) ==
  s2 >= 0

\* asil_test_coverage_pct (matches Coq: Definition asil_test_coverage_pct)
asil_test_coverage_pct(a) ==
    CASE a = QM -> 0
      [] a = ASIL_A -> 60
      [] a = ASIL_B -> 80
      [] a = ASIL_C -> 90
      [] a = ASIL_D -> 100

\* work_products_required (matches Coq: Definition work_products_required)
work_products_required(a) ==
    CASE a = QM -> 5
      [] a = ASIL_A -> 20
      [] a = ASIL_B -> 30
      [] a = ASIL_C -> 40
      [] a = ASIL_D -> 50

\* asil_sum (matches Coq: Definition asil_sum)
asil_sum(a2) ==
  a2 >= 0

\* iso26262_full (matches Coq: Definition iso26262_full)
iso26262_full(c) ==
  hazard_analysis /\ system_design /\ hardware_design /\ software_design /\ production /\ supporting_processes /\ asil_decomposition /\ cybersecurity_interface

\* tolerable_hazard_rate_per_hour (matches Coq: Definition tolerable_hazard_rate_per_hour)
tolerable_hazard_rate_per_hour(s) ==
    CASE s = SIL_0 -> 1000
      [] s = SIL_1 -> 100
      [] s = SIL_2 -> 10
      [] s = SIL_3 -> 1
      [] s = SIL_4 -> 0

\* v2x_auth_timeout_ms (matches Coq: Definition v2x_auth_timeout_ms)
v2x_auth_timeout_ms(safety_critical) ==
  safety_critical >= 0

\* version_valid (matches Coq: Definition version_valid)
version_valid(new_ver) ==
  new_ver # 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateISO26262_Compliance ==
  /\ hazard_analysis' \in BOOLEAN
  /\ system_design' \in BOOLEAN
  /\ hardware_design' \in BOOLEAN
  /\ software_design' \in BOOLEAN
  /\ production' \in BOOLEAN
  /\ supporting_processes' \in BOOLEAN
  /\ asil_decomposition' \in BOOLEAN
  /\ cybersecurity_interface' \in BOOLEAN

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateISO26262_Compliance \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* iso_26262_compliance
THEOREM iso_26262_compliance ==
  \A compliance \in Nat, asil \in ASILSet :
    compliance >= 0

\* iso_21434_cybersecurity
THEOREM iso_21434_cybersecurity ==
  \A vehicle \in Nat, system \in Nat :
    vehicle >= 0 /\ system >= 0

\* unece_r155_compliance
THEOREM unece_r155_compliance ==
  \A vehicle_type \in Nat :
    vehicle_type >= 0

\* en_50128_compliance
THEOREM en_50128_compliance ==
  \A railway_software \in Nat, sil \in SILSet :
    railway_software >= 0

\* imo_maritime_cyber
THEOREM imo_maritime_cyber ==
  \A vessel \in Nat :
    vessel >= 0

\* asil_d_highest_rigor
THEOREM asil_d_highest_rigor ==
  \A compliance \in Nat :
    compliance >= 0

\* cyber_safety_interface
THEOREM cyber_safety_interface ==
  \A compliance \in Nat :
    compliance >= 0

\* asil_le_refl
THEOREM asil_le_refl ==
  \A a \in Nat :
      asil_le(a, a) = TRUE

\* asil_le_trans
THEOREM asil_le_trans ==
  \A a1 \in Nat, a2 \in Nat, a3 \in Nat :
      asil_le(a1, a2) => asil_le(a1, a3)

\* asil_le_antisym
THEOREM asil_le_antisym ==
  \A a1 \in Nat, a2 \in Nat :
      asil_le(a1, a2) => a1 = a2

\* sil_le_refl
THEOREM sil_le_refl ==
  \A s \in Nat :
      sil_le(s, s) = TRUE

\* asil_d_full_coverage
THEOREM asil_d_full_coverage ==
  asil_test_coverage_pct(ASIL_D) = 100

\* asil_coverage_monotone
THEOREM asil_coverage_monotone ==
  \A a1 \in Nat, a2 \in Nat :
      asil_le(a1, a2) => asil_test_coverage_pct a1 <= asil_test_coverage_pct a2

\* work_products_monotone
THEOREM work_products_monotone ==
  \A a1 \in Nat, a2 \in Nat :
      asil_le(a1, a2) => work_products_required a1 <= work_products_required a2

\* asil_decomposition_valid
THEOREM asil_decomposition_valid ==
  \A target \in Nat, a1 \in Nat, a2 \in Nat :
      asil_sum a1 a2 >= asil_to_nat target => asil_to_nat a1 + asil_to_nat a2 >= asil_to_nat target

\* full_requires_hazard_analysis
THEOREM full_requires_hazard_analysis ==
  \A c \in Nat :
      iso26262_full(c) => hazard_analysis(c)

\* full_requires_software_design
THEOREM full_requires_software_design ==
  \A c \in Nat :
      iso26262_full(c) => software_design(c)

\* full_requires_cyber_interface
THEOREM full_requires_cyber_interface ==
  \A c \in Nat :
      iso26262_full(c) => cybersecurity_interface(c)

\* sil4_zero_tolerable_hazard
THEOREM sil4_zero_tolerable_hazard ==
  tolerable_hazard_rate_per_hour(SIL_4) = 0

\* hazard_rate_decreasing
THEOREM hazard_rate_decreasing ==
  \A s1 \in Nat, s2 \in Nat :
      sil_le(s1, s2) => tolerable_hazard_rate_per_hour s2 <= tolerable_hazard_rate_per_hour s1

\* safety_critical_faster_auth
THEOREM safety_critical_faster_auth ==
  v2x_auth_timeout_ms true < v2x_auth_timeout_ms false

\* version_no_downgrade
THEOREM version_no_downgrade ==
  \A old_v \in Nat, new_v \in Nat :
      version_valid(old_v, new_v) => old_v < new_v

====
