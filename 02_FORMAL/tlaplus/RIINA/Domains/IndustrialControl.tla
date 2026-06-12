\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE IndustrialControl ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/IndustrialControl.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* SCADAConfig (matches Coq: Record SCADAConfig)
VARIABLES ics_network_segmentation, ics_protocol_validation, ics_access_control, ics_anomaly_detection, ics_firmware_validation, ics_physical_interlock

\* PLCConfig (matches Coq: Record PLCConfig)
VARIABLES ics_plc_authentication, ics_plc_code_signing, ics_plc_memory_protection, ics_plc_watchdog, ics_plc_safe_state

\* Type invariant
TypeOK ==
  /\ ics_network_segmentation \in BOOLEAN
  /\ ics_protocol_validation \in BOOLEAN
  /\ ics_access_control \in BOOLEAN
  /\ ics_anomaly_detection \in BOOLEAN
  /\ ics_firmware_validation \in BOOLEAN
  /\ ics_physical_interlock \in BOOLEAN
  /\ ics_plc_authentication \in BOOLEAN
  /\ ics_plc_code_signing \in BOOLEAN
  /\ ics_plc_memory_protection \in BOOLEAN
  /\ ics_plc_watchdog \in BOOLEAN
  /\ ics_plc_safe_state \in BOOLEAN

\* Initial state
Init ==
  /\ ics_network_segmentation = TRUE
  /\ ics_protocol_validation = TRUE
  /\ ics_access_control = TRUE
  /\ ics_anomaly_detection = TRUE
  /\ ics_firmware_validation = TRUE
  /\ ics_physical_interlock = TRUE
  /\ ics_plc_authentication = TRUE
  /\ ics_plc_code_signing = TRUE
  /\ ics_plc_memory_protection = TRUE
  /\ ics_plc_watchdog = TRUE
  /\ ics_plc_safe_state = TRUE

\* scada_secure (matches Coq: Definition scada_secure)
scada_secure(c) == TRUE

\* riina_scada (matches Coq: Definition riina_scada)
riina_scada == TRUE

\* plc_secure (matches Coq: Definition plc_secure)
plc_secure(c) == TRUE

\* riina_plc (matches Coq: Definition riina_plc)
riina_plc == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* ICS_001 (matches Coq: Theorem ICS_001)
THEOREM ICS_001 == Init => TypeOK

\* ICS_002 (matches Coq: Theorem ICS_002)
THEOREM ICS_002 == Init => TypeOK

\* ICS_003 (matches Coq: Theorem ICS_003)
THEOREM ICS_003 == Init => TypeOK

\* ICS_004 (matches Coq: Theorem ICS_004)
THEOREM ICS_004 == Init => TypeOK

\* ICS_005 (matches Coq: Theorem ICS_005)
THEOREM ICS_005 == Init => TypeOK

\* ICS_006 (matches Coq: Theorem ICS_006)
THEOREM ICS_006 == Init => TypeOK

\* ICS_007 (matches Coq: Theorem ICS_007)
THEOREM ICS_007 == Init => TypeOK

\* ICS_008 (matches Coq: Theorem ICS_008)
THEOREM ICS_008 == Init => TypeOK

\* ICS_009 (matches Coq: Theorem ICS_009)
THEOREM ICS_009 == Init => TypeOK

\* ICS_010 (matches Coq: Theorem ICS_010)
THEOREM ICS_010 == Init => TypeOK

\* ICS_011 (matches Coq: Theorem ICS_011)
THEOREM ICS_011 == Init => TypeOK

\* ICS_012 (matches Coq: Theorem ICS_012)
THEOREM ICS_012 == Init => TypeOK

\* ICS_013 (matches Coq: Theorem ICS_013)
THEOREM ICS_013 == Init => TypeOK

\* ICS_014 (matches Coq: Theorem ICS_014)
THEOREM ICS_014 == Init => TypeOK

\* ICS_015 (matches Coq: Theorem ICS_015)
THEOREM ICS_015 == Init => TypeOK

\* ICS_016 (matches Coq: Theorem ICS_016)
THEOREM ICS_016 == Init => TypeOK

\* ICS_017 (matches Coq: Theorem ICS_017)
THEOREM ICS_017 == Init => TypeOK

\* ICS_018 (matches Coq: Theorem ICS_018)
THEOREM ICS_018 == Init => TypeOK

\* ICS_019 (matches Coq: Theorem ICS_019)
THEOREM ICS_019 == Init => TypeOK

\* ICS_020 (matches Coq: Theorem ICS_020)
THEOREM ICS_020 == Init => TypeOK

\* ICS_021 (matches Coq: Theorem ICS_021)
THEOREM ICS_021 == Init => TypeOK

\* ICS_022 (matches Coq: Theorem ICS_022)
THEOREM ICS_022 == Init => TypeOK

\* ICS_023 (matches Coq: Theorem ICS_023)
THEOREM ICS_023 == Init => TypeOK

\* ICS_024 (matches Coq: Theorem ICS_024)
THEOREM ICS_024 == Init => TypeOK

\* ICS_025 (matches Coq: Theorem ICS_025)
THEOREM ICS_025 == Init => TypeOK

\* ICS_026 (matches Coq: Theorem ICS_026)
THEOREM ICS_026 == Init => TypeOK

\* ICS_027 (matches Coq: Theorem ICS_027)
THEOREM ICS_027 == Init => TypeOK

\* ICS_028 (matches Coq: Theorem ICS_028)
THEOREM ICS_028 == Init => TypeOK

\* ICS_029 (matches Coq: Theorem ICS_029)
THEOREM ICS_029 == Init => TypeOK

\* ICS_030 (matches Coq: Theorem ICS_030)
THEOREM ICS_030 == Init => TypeOK

\* ICS_031 (matches Coq: Theorem ICS_031)
THEOREM ICS_031 == Init => TypeOK

\* ICS_032 (matches Coq: Theorem ICS_032)
THEOREM ICS_032 == Init => TypeOK

\* ICS_033 (matches Coq: Theorem ICS_033)
THEOREM ICS_033 == Init => TypeOK

\* ICS_034 (matches Coq: Theorem ICS_034)
THEOREM ICS_034 == Init => TypeOK

\* ICS_035 (matches Coq: Theorem ICS_035)
THEOREM ICS_035 == Init => TypeOK

\* ICS_036 (matches Coq: Theorem ICS_036)
THEOREM ICS_036 == Init => TypeOK

\* ICS_037 (matches Coq: Theorem ICS_037)
THEOREM ICS_037 == Init => TypeOK

\* ICS_038 (matches Coq: Theorem ICS_038)
THEOREM ICS_038 == Init => TypeOK

\* ICS_039 (matches Coq: Theorem ICS_039)
THEOREM ICS_039 == Init => TypeOK

\* ICS_040 (matches Coq: Theorem ICS_040)
THEOREM ICS_040 == Init => TypeOK

\* ICS_041 (matches Coq: Theorem ICS_041)
THEOREM ICS_041 == Init => TypeOK

\* ICS_042 (matches Coq: Theorem ICS_042)
THEOREM ICS_042 == Init => TypeOK

\* ICS_043 (matches Coq: Theorem ICS_043)
THEOREM ICS_043 == Init => TypeOK

\* ICS_044 (matches Coq: Theorem ICS_044)
THEOREM ICS_044 == Init => TypeOK

\* ICS_045 (matches Coq: Theorem ICS_045)
THEOREM ICS_045 == Init => TypeOK

\* ICS_046 (matches Coq: Theorem ICS_046)
THEOREM ICS_046 == Init => TypeOK

\* ICS_047 (matches Coq: Theorem ICS_047)
THEOREM ICS_047 == Init => TypeOK

\* ICS_048 (matches Coq: Theorem ICS_048)
THEOREM ICS_048 == Init => TypeOK

\* ICS_049 (matches Coq: Theorem ICS_049)
THEOREM ICS_049 == Init => TypeOK

\* ICS_050 (matches Coq: Theorem ICS_050)
THEOREM ICS_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<ics_network_segmentation, ics_protocol_validation, ics_access_control, ics_anomaly_detection, ics_firmware_validation, ics_physical_interlock, ics_plc_authentication, ics_plc_code_signing, ics_plc_memory_protection, ics_plc_watchdog, ics_plc_safe_state>>

\* Specification
Spec == Init /\ [][Next]_<<ics_network_segmentation, ics_protocol_validation, ics_access_control, ics_anomaly_detection, ics_firmware_validation, ics_physical_interlock, ics_plc_authentication, ics_plc_code_signing, ics_plc_memory_protection, ics_plc_watchdog, ics_plc_safe_state>>

====
