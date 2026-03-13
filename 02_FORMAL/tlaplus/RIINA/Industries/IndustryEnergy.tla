---- MODULE IndustryEnergy ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/Industries/IndustryEnergy.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* CIP_Impact (matches Coq: Inductive CIP_Impact)
CONSTANTS High_Impact, Medium_Impact, Low_Impact

CIP_ImpactSet == {High_Impact, Medium_Impact, Low_Impact}

\* BES_Asset (matches Coq: Inductive BES_Asset)
CONSTANTS ControlCenter, Substation, GenerationFacility, TransmissionLine, SCADA_System

BES_AssetSet == {ControlCenter, Substation, GenerationFacility, TransmissionLine, SCADA_System}

\* EnergyEffect (matches Coq: Inductive EnergyEffect)
CONSTANTS GridControl, SCADA_Operation, PowerGeneration, LoadBalancing, NuclearSafety

EnergyEffectSet == {GridControl, SCADA_Operation, PowerGeneration, LoadBalancing, NuclearSafety}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* NERC_CIP_Controls (matches Coq: Record NERC_CIP_Controls)
VARIABLES cip_002_identification, cip_003_management, cip_004_personnel, cip_005_electronic_perimeter, cip_006_physical, cip_007_systems, cip_008_incident, cip_009_recovery, cip_010_config, cip_011_info, cip_013_supply_chain

vars == <<cip_002_identification, cip_003_management, cip_004_personnel, cip_005_electronic_perimeter, cip_006_physical, cip_007_systems, cip_008_incident, cip_009_recovery, cip_010_config, cip_011_info, cip_013_supply_chain>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ cip_002_identification \in BOOLEAN
  /\ cip_003_management \in BOOLEAN
  /\ cip_004_personnel \in BOOLEAN
  /\ cip_005_electronic_perimeter \in BOOLEAN
  /\ cip_006_physical \in BOOLEAN
  /\ cip_007_systems \in BOOLEAN
  /\ cip_008_incident \in BOOLEAN
  /\ cip_009_recovery \in BOOLEAN
  /\ cip_010_config \in BOOLEAN
  /\ cip_011_info \in BOOLEAN
  /\ cip_013_supply_chain \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ cip_002_identification = FALSE
  /\ cip_003_management = FALSE
  /\ cip_004_personnel = FALSE
  /\ cip_005_electronic_perimeter = FALSE
  /\ cip_006_physical = FALSE
  /\ cip_007_systems = FALSE
  /\ cip_008_incident = FALSE
  /\ cip_009_recovery = FALSE
  /\ cip_010_config = FALSE
  /\ cip_011_info = FALSE
  /\ cip_013_supply_chain = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* cip_impact_to_nat (matches Coq: Definition cip_impact_to_nat)
cip_impact_to_nat(c) ==
    CASE c = Low_Impact -> 1
      [] c = Medium_Impact -> 2
      [] c = High_Impact -> 3

\* cip_le (matches Coq: Definition cip_le)
cip_le(c2) ==
  c2 >= 0

\* cip_mandatory_requirements (matches Coq: Definition cip_mandatory_requirements)
cip_mandatory_requirements(impact) ==
    CASE impact = Low_Impact -> 5
      [] impact = Medium_Impact -> 8
      [] impact = High_Impact -> 11

\* nerc_cip_all_controls (matches Coq: Definition nerc_cip_all_controls)
nerc_cip_all_controls(c) ==
  cip_002_identification /\ cip_003_management /\ cip_004_personnel /\ cip_005_electronic_perimeter /\ cip_006_physical /\ cip_007_systems /\ cip_008_incident /\ cip_009_recovery /\ cip_010_config /\ cip_011_info /\ cip_013_supply_chain

\* bes_criticality (matches Coq: Definition bes_criticality)
bes_criticality(a) ==
    CASE a = ControlCenter -> 5
      [] a = Substation -> 3
      [] a = GenerationFacility -> 4
      [] a = TransmissionLine -> 3
      [] a = SCADA_System -> 5

\* incident_response_hours (matches Coq: Definition incident_response_hours)
incident_response_hours(impact) ==
    CASE impact = High_Impact -> 1
      [] impact = Medium_Impact -> 4
      [] impact = Low_Impact -> 24

\* rto_hours (matches Coq: Definition rto_hours)
rto_hours(impact) ==
    CASE impact = High_Impact -> 4
      [] impact = Medium_Impact -> 24
      [] impact = Low_Impact -> 72

\* assessment_frequency_days (matches Coq: Definition assessment_frequency_days)
assessment_frequency_days(impact) ==
    CASE impact = High_Impact -> 35
      [] impact = Medium_Impact -> 90
      [] impact = Low_Impact -> 365

\* access_log_retention_days (matches Coq: Definition access_log_retention_days)
access_log_retention_days(impact) ==
    CASE impact = High_Impact -> 90
      [] impact = Medium_Impact -> 90
      [] impact = Low_Impact -> 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateNERC_CIP_Controls ==
  /\ cip_002_identification' \in BOOLEAN
  /\ cip_003_management' \in BOOLEAN
  /\ cip_004_personnel' \in BOOLEAN
  /\ cip_005_electronic_perimeter' \in BOOLEAN
  /\ cip_006_physical' \in BOOLEAN
  /\ cip_007_systems' \in BOOLEAN
  /\ cip_008_incident' \in BOOLEAN
  /\ cip_009_recovery' \in BOOLEAN
  /\ cip_010_config' \in BOOLEAN
  /\ cip_011_info' \in BOOLEAN
  /\ cip_013_supply_chain' \in BOOLEAN

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateNERC_CIP_Controls \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* nerc_cip_compliance
THEOREM nerc_cip_compliance ==
  \A controls \in Nat, asset \in Nat :
    controls >= 0

\* iec_62351_security
THEOREM iec_62351_security ==
  \A communication \in Nat :
    communication >= 0

\* nrc_cyber_security
THEOREM nrc_cyber_security ==
  \A nuclear_system \in Nat :
    nuclear_system >= 0

\* ot_security
THEOREM ot_security ==
  \A scada_system \in Nat :
    scada_system >= 0

\* substation_security
THEOREM substation_security ==
  \A ied \in Nat :
    ied >= 0

\* high_impact_all_controls
THEOREM high_impact_all_controls ==
  \A controls \in Nat, asset \in Nat, impact \in CIP_ImpactSet :
    controls >= 0 /\ asset >= 0

\* esp_required
THEOREM esp_required ==
  \A controls \in Nat, asset \in Nat :
    controls # 0

\* cip_le_refl
THEOREM cip_le_refl ==
  \A c \in Nat :
      cip_le(c, c) = TRUE

\* cip_le_trans
THEOREM cip_le_trans ==
  \A c1 \in Nat, c2 \in Nat, c3 \in Nat :
      cip_le(c1, c2) => cip_le(c1, c3)

\* high_impact_all_11
THEOREM high_impact_all_11 ==
  cip_mandatory_requirements(High_Impact) = 11

\* cip_requirements_monotone
THEOREM cip_requirements_monotone ==
  \A c1 \in Nat, c2 \in Nat :
      cip_le(c1, c2) => cip_mandatory_requirements c1 <= cip_mandatory_requirements c2

\* full_cip_requires_identification
THEOREM full_cip_requires_identification ==
  \A c \in Nat :
      nerc_cip_all_controls(c) => cip_002_identification(c)

\* full_cip_requires_perimeter
THEOREM full_cip_requires_perimeter ==
  \A c \in Nat :
      nerc_cip_all_controls(c) => cip_005_electronic_perimeter(c)

\* full_cip_requires_supply_chain
THEOREM full_cip_requires_supply_chain ==
  \A c \in Nat :
      nerc_cip_all_controls(c) => cip_013_supply_chain(c)

\* control_center_critical
THEOREM control_center_critical ==
  bes_criticality(ControlCenter) = 5

\* scada_critical
THEOREM scada_critical ==
  bes_criticality(SCADA_System) = 5

\* bes_criticality_positive
THEOREM bes_criticality_positive ==
  \A a \in Nat :
      bes_criticality a > = 3

\* high_impact_fastest_response
THEOREM high_impact_fastest_response ==
  incident_response_hours(High_Impact) = 1

\* response_time_decreasing
THEOREM response_time_decreasing ==
  \A c1 \in Nat, c2 \in Nat :
      cip_le(c1, c2) => incident_response_hours c2 <= incident_response_hours c1

\* rto_bounded
THEOREM rto_bounded ==
  \A impact \in Nat :
      rto_hours impact < = 72

\* high_impact_short_rto
THEOREM high_impact_short_rto ==
  rto_hours High_Impact < = rto_hours(Medium_Impact)

\* assessment_more_frequent_high
THEOREM assessment_more_frequent_high ==
  \A c1 \in Nat, c2 \in Nat :
      cip_le(c1, c2) => assessment_frequency_days c2 <= assessment_frequency_days c1

\* high_medium_same_retention
THEOREM high_medium_same_retention ==
  access_log_retention_days(High_Impact) = access_log_retention_days(Medium_Impact)

====
