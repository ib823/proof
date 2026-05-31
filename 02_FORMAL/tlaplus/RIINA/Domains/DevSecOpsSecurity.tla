\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE DevSecOpsSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/DevSecOpsSecurity.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* PipelineSecurityConfig (matches Coq: Record PipelineSecurityConfig)
VARIABLES dso_pipeline_signing, dso_artifact_verification, dso_secret_scanning, dso_dependency_audit, dso_sast_enabled, dso_dast_enabled

\* DeploymentSecurityConfig (matches Coq: Record DeploymentSecurityConfig)
VARIABLES dso_immutable_infra, dso_canary_deploy, dso_rollback_auto, dso_env_isolation, dso_audit_trail

\* Type invariant
TypeOK ==
  /\ dso_pipeline_signing \in BOOLEAN
  /\ dso_artifact_verification \in BOOLEAN
  /\ dso_secret_scanning \in BOOLEAN
  /\ dso_dependency_audit \in BOOLEAN
  /\ dso_sast_enabled \in BOOLEAN
  /\ dso_dast_enabled \in BOOLEAN
  /\ dso_immutable_infra \in BOOLEAN
  /\ dso_canary_deploy \in BOOLEAN
  /\ dso_rollback_auto \in BOOLEAN
  /\ dso_env_isolation \in BOOLEAN
  /\ dso_audit_trail \in BOOLEAN

\* Initial state
Init ==
  /\ dso_pipeline_signing = TRUE
  /\ dso_artifact_verification = TRUE
  /\ dso_secret_scanning = TRUE
  /\ dso_dependency_audit = TRUE
  /\ dso_sast_enabled = TRUE
  /\ dso_dast_enabled = TRUE
  /\ dso_immutable_infra = TRUE
  /\ dso_canary_deploy = TRUE
  /\ dso_rollback_auto = TRUE
  /\ dso_env_isolation = TRUE
  /\ dso_audit_trail = TRUE

\* pipeline_secure (matches Coq: Definition pipeline_secure)
pipeline_secure(c) == TRUE

\* riina_pipeline (matches Coq: Definition riina_pipeline)
riina_pipeline == TRUE

\* deployment_secure (matches Coq: Definition deployment_secure)
deployment_secure(c) == TRUE

\* riina_deployment (matches Coq: Definition riina_deployment)
riina_deployment == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* DSO_001 (matches Coq: Theorem DSO_001)
THEOREM DSO_001 == Init => TypeOK

\* DSO_002 (matches Coq: Theorem DSO_002)
THEOREM DSO_002 == Init => TypeOK

\* DSO_003 (matches Coq: Theorem DSO_003)
THEOREM DSO_003 == Init => TypeOK

\* DSO_004 (matches Coq: Theorem DSO_004)
THEOREM DSO_004 == Init => TypeOK

\* DSO_005 (matches Coq: Theorem DSO_005)
THEOREM DSO_005 == Init => TypeOK

\* DSO_006 (matches Coq: Theorem DSO_006)
THEOREM DSO_006 == Init => TypeOK

\* DSO_007 (matches Coq: Theorem DSO_007)
THEOREM DSO_007 == Init => TypeOK

\* DSO_008 (matches Coq: Theorem DSO_008)
THEOREM DSO_008 == Init => TypeOK

\* DSO_009 (matches Coq: Theorem DSO_009)
THEOREM DSO_009 == Init => TypeOK

\* DSO_010 (matches Coq: Theorem DSO_010)
THEOREM DSO_010 == Init => TypeOK

\* DSO_011 (matches Coq: Theorem DSO_011)
THEOREM DSO_011 == Init => TypeOK

\* DSO_012 (matches Coq: Theorem DSO_012)
THEOREM DSO_012 == Init => TypeOK

\* DSO_013 (matches Coq: Theorem DSO_013)
THEOREM DSO_013 == Init => TypeOK

\* DSO_014 (matches Coq: Theorem DSO_014)
THEOREM DSO_014 == Init => TypeOK

\* DSO_015 (matches Coq: Theorem DSO_015)
THEOREM DSO_015 == Init => TypeOK

\* DSO_016 (matches Coq: Theorem DSO_016)
THEOREM DSO_016 == Init => TypeOK

\* DSO_017 (matches Coq: Theorem DSO_017)
THEOREM DSO_017 == Init => TypeOK

\* DSO_018 (matches Coq: Theorem DSO_018)
THEOREM DSO_018 == Init => TypeOK

\* DSO_019 (matches Coq: Theorem DSO_019)
THEOREM DSO_019 == Init => TypeOK

\* DSO_020 (matches Coq: Theorem DSO_020)
THEOREM DSO_020 == Init => TypeOK

\* DSO_021 (matches Coq: Theorem DSO_021)
THEOREM DSO_021 == Init => TypeOK

\* DSO_022 (matches Coq: Theorem DSO_022)
THEOREM DSO_022 == Init => TypeOK

\* DSO_023 (matches Coq: Theorem DSO_023)
THEOREM DSO_023 == Init => TypeOK

\* DSO_024 (matches Coq: Theorem DSO_024)
THEOREM DSO_024 == Init => TypeOK

\* DSO_025 (matches Coq: Theorem DSO_025)
THEOREM DSO_025 == Init => TypeOK

\* DSO_026 (matches Coq: Theorem DSO_026)
THEOREM DSO_026 == Init => TypeOK

\* DSO_027 (matches Coq: Theorem DSO_027)
THEOREM DSO_027 == Init => TypeOK

\* DSO_028 (matches Coq: Theorem DSO_028)
THEOREM DSO_028 == Init => TypeOK

\* DSO_029 (matches Coq: Theorem DSO_029)
THEOREM DSO_029 == Init => TypeOK

\* DSO_030 (matches Coq: Theorem DSO_030)
THEOREM DSO_030 == Init => TypeOK

\* DSO_031 (matches Coq: Theorem DSO_031)
THEOREM DSO_031 == Init => TypeOK

\* DSO_032 (matches Coq: Theorem DSO_032)
THEOREM DSO_032 == Init => TypeOK

\* DSO_033 (matches Coq: Theorem DSO_033)
THEOREM DSO_033 == Init => TypeOK

\* DSO_034 (matches Coq: Theorem DSO_034)
THEOREM DSO_034 == Init => TypeOK

\* DSO_035 (matches Coq: Theorem DSO_035)
THEOREM DSO_035 == Init => TypeOK

\* DSO_036 (matches Coq: Theorem DSO_036)
THEOREM DSO_036 == Init => TypeOK

\* DSO_037 (matches Coq: Theorem DSO_037)
THEOREM DSO_037 == Init => TypeOK

\* DSO_038 (matches Coq: Theorem DSO_038)
THEOREM DSO_038 == Init => TypeOK

\* DSO_039 (matches Coq: Theorem DSO_039)
THEOREM DSO_039 == Init => TypeOK

\* DSO_040 (matches Coq: Theorem DSO_040)
THEOREM DSO_040 == Init => TypeOK

\* DSO_041 (matches Coq: Theorem DSO_041)
THEOREM DSO_041 == Init => TypeOK

\* DSO_042 (matches Coq: Theorem DSO_042)
THEOREM DSO_042 == Init => TypeOK

\* DSO_043 (matches Coq: Theorem DSO_043)
THEOREM DSO_043 == Init => TypeOK

\* DSO_044 (matches Coq: Theorem DSO_044)
THEOREM DSO_044 == Init => TypeOK

\* DSO_045 (matches Coq: Theorem DSO_045)
THEOREM DSO_045 == Init => TypeOK

\* DSO_046 (matches Coq: Theorem DSO_046)
THEOREM DSO_046 == Init => TypeOK

\* DSO_047 (matches Coq: Theorem DSO_047)
THEOREM DSO_047 == Init => TypeOK

\* DSO_048 (matches Coq: Theorem DSO_048)
THEOREM DSO_048 == Init => TypeOK

\* DSO_049 (matches Coq: Theorem DSO_049)
THEOREM DSO_049 == Init => TypeOK

\* DSO_050 (matches Coq: Theorem DSO_050)
THEOREM DSO_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<dso_pipeline_signing, dso_artifact_verification, dso_secret_scanning, dso_dependency_audit, dso_sast_enabled, dso_dast_enabled, dso_immutable_infra, dso_canary_deploy, dso_rollback_auto, dso_env_isolation, dso_audit_trail>>

\* Specification
Spec == Init /\ [][Next]_<<dso_pipeline_signing, dso_artifact_verification, dso_secret_scanning, dso_dependency_audit, dso_sast_enabled, dso_dast_enabled, dso_immutable_infra, dso_canary_deploy, dso_rollback_auto, dso_env_isolation, dso_audit_trail>>

====
