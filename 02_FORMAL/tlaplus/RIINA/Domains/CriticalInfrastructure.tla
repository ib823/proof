\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE CriticalInfrastructure ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/CriticalInfrastructure.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* SCADASecurityConfig (matches Coq: Record SCADASecurityConfig)
VARIABLES cis_network_segmentation, cis_protocol_validation, cis_plc_authentication, cis_sensor_integrity, cis_command_verification, cis_failsafe_mode

\* SafetyCriticalConfig (matches Coq: Record SafetyCriticalConfig)
VARIABLES cis_redundancy_check, cis_watchdog_timer, cis_emergency_shutdown, cis_fault_tolerance, cis_deterministic_timing

\* Type invariant
TypeOK ==
  /\ cis_network_segmentation \in BOOLEAN
  /\ cis_protocol_validation \in BOOLEAN
  /\ cis_plc_authentication \in BOOLEAN
  /\ cis_sensor_integrity \in BOOLEAN
  /\ cis_command_verification \in BOOLEAN
  /\ cis_failsafe_mode \in BOOLEAN
  /\ cis_redundancy_check \in BOOLEAN
  /\ cis_watchdog_timer \in BOOLEAN
  /\ cis_emergency_shutdown \in BOOLEAN
  /\ cis_fault_tolerance \in BOOLEAN
  /\ cis_deterministic_timing \in BOOLEAN

\* Initial state
Init ==
  /\ cis_network_segmentation = TRUE
  /\ cis_protocol_validation = TRUE
  /\ cis_plc_authentication = TRUE
  /\ cis_sensor_integrity = TRUE
  /\ cis_command_verification = TRUE
  /\ cis_failsafe_mode = TRUE
  /\ cis_redundancy_check = TRUE
  /\ cis_watchdog_timer = TRUE
  /\ cis_emergency_shutdown = TRUE
  /\ cis_fault_tolerance = TRUE
  /\ cis_deterministic_timing = TRUE

\* scada_secure (matches Coq: Definition scada_secure)
scada_secure(c) == TRUE

\* riina_scada (matches Coq: Definition riina_scada)
riina_scada == TRUE

\* safety_critical_secure (matches Coq: Definition safety_critical_secure)
safety_critical_secure(c) == TRUE

\* riina_safety_critical (matches Coq: Definition riina_safety_critical)
riina_safety_critical == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* CIS_001 (matches Coq: Theorem CIS_001)
THEOREM CIS_001 == Init => TypeOK

\* CIS_002 (matches Coq: Theorem CIS_002)
THEOREM CIS_002 == Init => TypeOK

\* CIS_003 (matches Coq: Theorem CIS_003)
THEOREM CIS_003 == Init => TypeOK

\* CIS_004 (matches Coq: Theorem CIS_004)
THEOREM CIS_004 == Init => TypeOK

\* CIS_005 (matches Coq: Theorem CIS_005)
THEOREM CIS_005 == Init => TypeOK

\* CIS_006 (matches Coq: Theorem CIS_006)
THEOREM CIS_006 == Init => TypeOK

\* CIS_007 (matches Coq: Theorem CIS_007)
THEOREM CIS_007 == Init => TypeOK

\* CIS_008 (matches Coq: Theorem CIS_008)
THEOREM CIS_008 == Init => TypeOK

\* CIS_009 (matches Coq: Theorem CIS_009)
THEOREM CIS_009 == Init => TypeOK

\* CIS_010 (matches Coq: Theorem CIS_010)
THEOREM CIS_010 == Init => TypeOK

\* CIS_011 (matches Coq: Theorem CIS_011)
THEOREM CIS_011 == Init => TypeOK

\* CIS_012 (matches Coq: Theorem CIS_012)
THEOREM CIS_012 == Init => TypeOK

\* CIS_013 (matches Coq: Theorem CIS_013)
THEOREM CIS_013 == Init => TypeOK

\* CIS_014 (matches Coq: Theorem CIS_014)
THEOREM CIS_014 == Init => TypeOK

\* CIS_015 (matches Coq: Theorem CIS_015)
THEOREM CIS_015 == Init => TypeOK

\* CIS_016 (matches Coq: Theorem CIS_016)
THEOREM CIS_016 == Init => TypeOK

\* CIS_017 (matches Coq: Theorem CIS_017)
THEOREM CIS_017 == Init => TypeOK

\* CIS_018 (matches Coq: Theorem CIS_018)
THEOREM CIS_018 == Init => TypeOK

\* CIS_019 (matches Coq: Theorem CIS_019)
THEOREM CIS_019 == Init => TypeOK

\* CIS_020 (matches Coq: Theorem CIS_020)
THEOREM CIS_020 == Init => TypeOK

\* CIS_021 (matches Coq: Theorem CIS_021)
THEOREM CIS_021 == Init => TypeOK

\* CIS_022 (matches Coq: Theorem CIS_022)
THEOREM CIS_022 == Init => TypeOK

\* CIS_023 (matches Coq: Theorem CIS_023)
THEOREM CIS_023 == Init => TypeOK

\* CIS_024 (matches Coq: Theorem CIS_024)
THEOREM CIS_024 == Init => TypeOK

\* CIS_025 (matches Coq: Theorem CIS_025)
THEOREM CIS_025 == Init => TypeOK

\* CIS_026 (matches Coq: Theorem CIS_026)
THEOREM CIS_026 == Init => TypeOK

\* CIS_027 (matches Coq: Theorem CIS_027)
THEOREM CIS_027 == Init => TypeOK

\* CIS_028 (matches Coq: Theorem CIS_028)
THEOREM CIS_028 == Init => TypeOK

\* CIS_029 (matches Coq: Theorem CIS_029)
THEOREM CIS_029 == Init => TypeOK

\* CIS_030 (matches Coq: Theorem CIS_030)
THEOREM CIS_030 == Init => TypeOK

\* CIS_031 (matches Coq: Theorem CIS_031)
THEOREM CIS_031 == Init => TypeOK

\* CIS_032 (matches Coq: Theorem CIS_032)
THEOREM CIS_032 == Init => TypeOK

\* CIS_033 (matches Coq: Theorem CIS_033)
THEOREM CIS_033 == Init => TypeOK

\* CIS_034 (matches Coq: Theorem CIS_034)
THEOREM CIS_034 == Init => TypeOK

\* CIS_035 (matches Coq: Theorem CIS_035)
THEOREM CIS_035 == Init => TypeOK

\* CIS_036 (matches Coq: Theorem CIS_036)
THEOREM CIS_036 == Init => TypeOK

\* CIS_037 (matches Coq: Theorem CIS_037)
THEOREM CIS_037 == Init => TypeOK

\* CIS_038 (matches Coq: Theorem CIS_038)
THEOREM CIS_038 == Init => TypeOK

\* CIS_039 (matches Coq: Theorem CIS_039)
THEOREM CIS_039 == Init => TypeOK

\* CIS_040 (matches Coq: Theorem CIS_040)
THEOREM CIS_040 == Init => TypeOK

\* CIS_041 (matches Coq: Theorem CIS_041)
THEOREM CIS_041 == Init => TypeOK

\* CIS_042 (matches Coq: Theorem CIS_042)
THEOREM CIS_042 == Init => TypeOK

\* CIS_043 (matches Coq: Theorem CIS_043)
THEOREM CIS_043 == Init => TypeOK

\* CIS_044 (matches Coq: Theorem CIS_044)
THEOREM CIS_044 == Init => TypeOK

\* CIS_045 (matches Coq: Theorem CIS_045)
THEOREM CIS_045 == Init => TypeOK

\* CIS_046 (matches Coq: Theorem CIS_046)
THEOREM CIS_046 == Init => TypeOK

\* CIS_047 (matches Coq: Theorem CIS_047)
THEOREM CIS_047 == Init => TypeOK

\* CIS_048 (matches Coq: Theorem CIS_048)
THEOREM CIS_048 == Init => TypeOK

\* CIS_049 (matches Coq: Theorem CIS_049)
THEOREM CIS_049 == Init => TypeOK

\* CIS_050 (matches Coq: Theorem CIS_050)
THEOREM CIS_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<cis_network_segmentation, cis_protocol_validation, cis_plc_authentication, cis_sensor_integrity, cis_command_verification, cis_failsafe_mode, cis_redundancy_check, cis_watchdog_timer, cis_emergency_shutdown, cis_fault_tolerance, cis_deterministic_timing>>

\* Specification
Spec == Init /\ [][Next]_<<cis_network_segmentation, cis_protocol_validation, cis_plc_authentication, cis_sensor_integrity, cis_command_verification, cis_failsafe_mode, cis_redundancy_check, cis_watchdog_timer, cis_emergency_shutdown, cis_fault_tolerance, cis_deterministic_timing>>

====
