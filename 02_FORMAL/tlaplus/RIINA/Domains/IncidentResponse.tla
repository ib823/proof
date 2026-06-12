\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE IncidentResponse ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/IncidentResponse.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* DetectionConfig (matches Coq: Record DetectionConfig)
VARIABLES irs_anomaly_detection, irs_log_correlation, irs_threat_intel_feed, irs_behavior_analysis, irs_alert_triage, irs_forensic_capture

\* RecoveryConfig (matches Coq: Record RecoveryConfig)
VARIABLES irs_containment_auto, irs_backup_verified, irs_rollback_tested, irs_comms_encrypted, irs_post_mortem_required

\* Type invariant
TypeOK ==
  /\ irs_anomaly_detection \in BOOLEAN
  /\ irs_log_correlation \in BOOLEAN
  /\ irs_threat_intel_feed \in BOOLEAN
  /\ irs_behavior_analysis \in BOOLEAN
  /\ irs_alert_triage \in BOOLEAN
  /\ irs_forensic_capture \in BOOLEAN
  /\ irs_containment_auto \in BOOLEAN
  /\ irs_backup_verified \in BOOLEAN
  /\ irs_rollback_tested \in BOOLEAN
  /\ irs_comms_encrypted \in BOOLEAN
  /\ irs_post_mortem_required \in BOOLEAN

\* Initial state
Init ==
  /\ irs_anomaly_detection = TRUE
  /\ irs_log_correlation = TRUE
  /\ irs_threat_intel_feed = TRUE
  /\ irs_behavior_analysis = TRUE
  /\ irs_alert_triage = TRUE
  /\ irs_forensic_capture = TRUE
  /\ irs_containment_auto = TRUE
  /\ irs_backup_verified = TRUE
  /\ irs_rollback_tested = TRUE
  /\ irs_comms_encrypted = TRUE
  /\ irs_post_mortem_required = TRUE

\* detection_secure (matches Coq: Definition detection_secure)
detection_secure(c) == TRUE

\* riina_detection (matches Coq: Definition riina_detection)
riina_detection == TRUE

\* recovery_secure (matches Coq: Definition recovery_secure)
recovery_secure(c) == TRUE

\* riina_recovery (matches Coq: Definition riina_recovery)
riina_recovery == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* IRS_001 (matches Coq: Theorem IRS_001)
THEOREM IRS_001 == Init => TypeOK

\* IRS_002 (matches Coq: Theorem IRS_002)
THEOREM IRS_002 == Init => TypeOK

\* IRS_003 (matches Coq: Theorem IRS_003)
THEOREM IRS_003 == Init => TypeOK

\* IRS_004 (matches Coq: Theorem IRS_004)
THEOREM IRS_004 == Init => TypeOK

\* IRS_005 (matches Coq: Theorem IRS_005)
THEOREM IRS_005 == Init => TypeOK

\* IRS_006 (matches Coq: Theorem IRS_006)
THEOREM IRS_006 == Init => TypeOK

\* IRS_007 (matches Coq: Theorem IRS_007)
THEOREM IRS_007 == Init => TypeOK

\* IRS_008 (matches Coq: Theorem IRS_008)
THEOREM IRS_008 == Init => TypeOK

\* IRS_009 (matches Coq: Theorem IRS_009)
THEOREM IRS_009 == Init => TypeOK

\* IRS_010 (matches Coq: Theorem IRS_010)
THEOREM IRS_010 == Init => TypeOK

\* IRS_011 (matches Coq: Theorem IRS_011)
THEOREM IRS_011 == Init => TypeOK

\* IRS_012 (matches Coq: Theorem IRS_012)
THEOREM IRS_012 == Init => TypeOK

\* IRS_013 (matches Coq: Theorem IRS_013)
THEOREM IRS_013 == Init => TypeOK

\* IRS_014 (matches Coq: Theorem IRS_014)
THEOREM IRS_014 == Init => TypeOK

\* IRS_015 (matches Coq: Theorem IRS_015)
THEOREM IRS_015 == Init => TypeOK

\* IRS_016 (matches Coq: Theorem IRS_016)
THEOREM IRS_016 == Init => TypeOK

\* IRS_017 (matches Coq: Theorem IRS_017)
THEOREM IRS_017 == Init => TypeOK

\* IRS_018 (matches Coq: Theorem IRS_018)
THEOREM IRS_018 == Init => TypeOK

\* IRS_019 (matches Coq: Theorem IRS_019)
THEOREM IRS_019 == Init => TypeOK

\* IRS_020 (matches Coq: Theorem IRS_020)
THEOREM IRS_020 == Init => TypeOK

\* IRS_021 (matches Coq: Theorem IRS_021)
THEOREM IRS_021 == Init => TypeOK

\* IRS_022 (matches Coq: Theorem IRS_022)
THEOREM IRS_022 == Init => TypeOK

\* IRS_023 (matches Coq: Theorem IRS_023)
THEOREM IRS_023 == Init => TypeOK

\* IRS_024 (matches Coq: Theorem IRS_024)
THEOREM IRS_024 == Init => TypeOK

\* IRS_025 (matches Coq: Theorem IRS_025)
THEOREM IRS_025 == Init => TypeOK

\* IRS_026 (matches Coq: Theorem IRS_026)
THEOREM IRS_026 == Init => TypeOK

\* IRS_027 (matches Coq: Theorem IRS_027)
THEOREM IRS_027 == Init => TypeOK

\* IRS_028 (matches Coq: Theorem IRS_028)
THEOREM IRS_028 == Init => TypeOK

\* IRS_029 (matches Coq: Theorem IRS_029)
THEOREM IRS_029 == Init => TypeOK

\* IRS_030 (matches Coq: Theorem IRS_030)
THEOREM IRS_030 == Init => TypeOK

\* IRS_031 (matches Coq: Theorem IRS_031)
THEOREM IRS_031 == Init => TypeOK

\* IRS_032 (matches Coq: Theorem IRS_032)
THEOREM IRS_032 == Init => TypeOK

\* IRS_033 (matches Coq: Theorem IRS_033)
THEOREM IRS_033 == Init => TypeOK

\* IRS_034 (matches Coq: Theorem IRS_034)
THEOREM IRS_034 == Init => TypeOK

\* IRS_035 (matches Coq: Theorem IRS_035)
THEOREM IRS_035 == Init => TypeOK

\* IRS_036 (matches Coq: Theorem IRS_036)
THEOREM IRS_036 == Init => TypeOK

\* IRS_037 (matches Coq: Theorem IRS_037)
THEOREM IRS_037 == Init => TypeOK

\* IRS_038 (matches Coq: Theorem IRS_038)
THEOREM IRS_038 == Init => TypeOK

\* IRS_039 (matches Coq: Theorem IRS_039)
THEOREM IRS_039 == Init => TypeOK

\* IRS_040 (matches Coq: Theorem IRS_040)
THEOREM IRS_040 == Init => TypeOK

\* IRS_041 (matches Coq: Theorem IRS_041)
THEOREM IRS_041 == Init => TypeOK

\* IRS_042 (matches Coq: Theorem IRS_042)
THEOREM IRS_042 == Init => TypeOK

\* IRS_043 (matches Coq: Theorem IRS_043)
THEOREM IRS_043 == Init => TypeOK

\* IRS_044 (matches Coq: Theorem IRS_044)
THEOREM IRS_044 == Init => TypeOK

\* IRS_045 (matches Coq: Theorem IRS_045)
THEOREM IRS_045 == Init => TypeOK

\* IRS_046 (matches Coq: Theorem IRS_046)
THEOREM IRS_046 == Init => TypeOK

\* IRS_047 (matches Coq: Theorem IRS_047)
THEOREM IRS_047 == Init => TypeOK

\* IRS_048 (matches Coq: Theorem IRS_048)
THEOREM IRS_048 == Init => TypeOK

\* IRS_049 (matches Coq: Theorem IRS_049)
THEOREM IRS_049 == Init => TypeOK

\* IRS_050 (matches Coq: Theorem IRS_050)
THEOREM IRS_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<irs_anomaly_detection, irs_log_correlation, irs_threat_intel_feed, irs_behavior_analysis, irs_alert_triage, irs_forensic_capture, irs_containment_auto, irs_backup_verified, irs_rollback_tested, irs_comms_encrypted, irs_post_mortem_required>>

\* Specification
Spec == Init /\ [][Next]_<<irs_anomaly_detection, irs_log_correlation, irs_threat_intel_feed, irs_behavior_analysis, irs_alert_triage, irs_forensic_capture, irs_containment_auto, irs_backup_verified, irs_rollback_tested, irs_comms_encrypted, irs_post_mortem_required>>

====
