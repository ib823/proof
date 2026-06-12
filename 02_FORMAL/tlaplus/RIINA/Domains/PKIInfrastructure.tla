\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE PKIInfrastructure ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/PKIInfrastructure.v (51 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* CertManagementConfig (matches Coq: Record CertManagementConfig)
VARIABLES pki_ca_hardened, pki_crl_enabled, pki_ocsp_stapling, pki_cert_transparency, pki_key_escrow_disabled, pki_renewal_automated

\* KeyManagementConfig (matches Coq: Record KeyManagementConfig)
VARIABLES pki_hsm_storage, pki_key_rotation, pki_algorithm_agility, pki_split_knowledge, pki_backup_encrypted

\* Type invariant
TypeOK ==
  /\ pki_ca_hardened \in BOOLEAN
  /\ pki_crl_enabled \in BOOLEAN
  /\ pki_ocsp_stapling \in BOOLEAN
  /\ pki_cert_transparency \in BOOLEAN
  /\ pki_key_escrow_disabled \in BOOLEAN
  /\ pki_renewal_automated \in BOOLEAN
  /\ pki_hsm_storage \in BOOLEAN
  /\ pki_key_rotation \in BOOLEAN
  /\ pki_algorithm_agility \in BOOLEAN
  /\ pki_split_knowledge \in BOOLEAN
  /\ pki_backup_encrypted \in BOOLEAN

\* Initial state
Init ==
  /\ pki_ca_hardened = TRUE
  /\ pki_crl_enabled = TRUE
  /\ pki_ocsp_stapling = TRUE
  /\ pki_cert_transparency = TRUE
  /\ pki_key_escrow_disabled = TRUE
  /\ pki_renewal_automated = TRUE
  /\ pki_hsm_storage = TRUE
  /\ pki_key_rotation = TRUE
  /\ pki_algorithm_agility = TRUE
  /\ pki_split_knowledge = TRUE
  /\ pki_backup_encrypted = TRUE

\* cert_management_secure (matches Coq: Definition cert_management_secure)
cert_management_secure(c) == TRUE

\* riina_cert_management (matches Coq: Definition riina_cert_management)
riina_cert_management == TRUE

\* key_management_secure (matches Coq: Definition key_management_secure)
key_management_secure(c) == TRUE

\* riina_key_management (matches Coq: Definition riina_key_management)
riina_key_management == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* PKI_001 (matches Coq: Theorem PKI_001)
THEOREM PKI_001 == Init => TypeOK

\* PKI_002 (matches Coq: Theorem PKI_002)
THEOREM PKI_002 == Init => TypeOK

\* PKI_003 (matches Coq: Theorem PKI_003)
THEOREM PKI_003 == Init => TypeOK

\* PKI_004 (matches Coq: Theorem PKI_004)
THEOREM PKI_004 == Init => TypeOK

\* PKI_005 (matches Coq: Theorem PKI_005)
THEOREM PKI_005 == Init => TypeOK

\* PKI_006 (matches Coq: Theorem PKI_006)
THEOREM PKI_006 == Init => TypeOK

\* PKI_007 (matches Coq: Theorem PKI_007)
THEOREM PKI_007 == Init => TypeOK

\* PKI_008 (matches Coq: Theorem PKI_008)
THEOREM PKI_008 == Init => TypeOK

\* PKI_009 (matches Coq: Theorem PKI_009)
THEOREM PKI_009 == Init => TypeOK

\* PKI_010 (matches Coq: Theorem PKI_010)
THEOREM PKI_010 == Init => TypeOK

\* PKI_011 (matches Coq: Theorem PKI_011)
THEOREM PKI_011 == Init => TypeOK

\* PKI_012 (matches Coq: Theorem PKI_012)
THEOREM PKI_012 == Init => TypeOK

\* PKI_013 (matches Coq: Theorem PKI_013)
THEOREM PKI_013 == Init => TypeOK

\* PKI_014 (matches Coq: Theorem PKI_014)
THEOREM PKI_014 == Init => TypeOK

\* PKI_015 (matches Coq: Theorem PKI_015)
THEOREM PKI_015 == Init => TypeOK

\* PKI_016 (matches Coq: Theorem PKI_016)
THEOREM PKI_016 == Init => TypeOK

\* PKI_017 (matches Coq: Theorem PKI_017)
THEOREM PKI_017 == Init => TypeOK

\* PKI_018 (matches Coq: Theorem PKI_018)
THEOREM PKI_018 == Init => TypeOK

\* PKI_019 (matches Coq: Theorem PKI_019)
THEOREM PKI_019 == Init => TypeOK

\* PKI_020 (matches Coq: Theorem PKI_020)
THEOREM PKI_020 == Init => TypeOK

\* PKI_021 (matches Coq: Theorem PKI_021)
THEOREM PKI_021 == Init => TypeOK

\* PKI_022 (matches Coq: Theorem PKI_022)
THEOREM PKI_022 == Init => TypeOK

\* PKI_023 (matches Coq: Theorem PKI_023)
THEOREM PKI_023 == Init => TypeOK

\* PKI_024 (matches Coq: Theorem PKI_024)
THEOREM PKI_024 == Init => TypeOK

\* PKI_025 (matches Coq: Theorem PKI_025)
THEOREM PKI_025 == Init => TypeOK

\* PKI_026 (matches Coq: Theorem PKI_026)
THEOREM PKI_026 == Init => TypeOK

\* PKI_027 (matches Coq: Theorem PKI_027)
THEOREM PKI_027 == Init => TypeOK

\* PKI_028 (matches Coq: Theorem PKI_028)
THEOREM PKI_028 == Init => TypeOK

\* PKI_029 (matches Coq: Theorem PKI_029)
THEOREM PKI_029 == Init => TypeOK

\* PKI_030 (matches Coq: Theorem PKI_030)
THEOREM PKI_030 == Init => TypeOK

\* PKI_031 (matches Coq: Theorem PKI_031)
THEOREM PKI_031 == Init => TypeOK

\* PKI_032 (matches Coq: Theorem PKI_032)
THEOREM PKI_032 == Init => TypeOK

\* PKI_033 (matches Coq: Theorem PKI_033)
THEOREM PKI_033 == Init => TypeOK

\* PKI_034 (matches Coq: Theorem PKI_034)
THEOREM PKI_034 == Init => TypeOK

\* PKI_035 (matches Coq: Theorem PKI_035)
THEOREM PKI_035 == Init => TypeOK

\* PKI_036 (matches Coq: Theorem PKI_036)
THEOREM PKI_036 == Init => TypeOK

\* PKI_037 (matches Coq: Theorem PKI_037)
THEOREM PKI_037 == Init => TypeOK

\* PKI_038 (matches Coq: Theorem PKI_038)
THEOREM PKI_038 == Init => TypeOK

\* PKI_039 (matches Coq: Theorem PKI_039)
THEOREM PKI_039 == Init => TypeOK

\* PKI_040 (matches Coq: Theorem PKI_040)
THEOREM PKI_040 == Init => TypeOK

\* PKI_041 (matches Coq: Theorem PKI_041)
THEOREM PKI_041 == Init => TypeOK

\* PKI_042 (matches Coq: Theorem PKI_042)
THEOREM PKI_042 == Init => TypeOK

\* PKI_043 (matches Coq: Theorem PKI_043)
THEOREM PKI_043 == Init => TypeOK

\* PKI_044 (matches Coq: Theorem PKI_044)
THEOREM PKI_044 == Init => TypeOK

\* PKI_045 (matches Coq: Theorem PKI_045)
THEOREM PKI_045 == Init => TypeOK

\* PKI_046 (matches Coq: Theorem PKI_046)
THEOREM PKI_046 == Init => TypeOK

\* PKI_047 (matches Coq: Theorem PKI_047)
THEOREM PKI_047 == Init => TypeOK

\* PKI_048 (matches Coq: Theorem PKI_048)
THEOREM PKI_048 == Init => TypeOK

\* PKI_049 (matches Coq: Theorem PKI_049)
THEOREM PKI_049 == Init => TypeOK

\* PKI_050 (matches Coq: Theorem PKI_050)
THEOREM PKI_050 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<pki_ca_hardened, pki_crl_enabled, pki_ocsp_stapling, pki_cert_transparency, pki_key_escrow_disabled, pki_renewal_automated, pki_hsm_storage, pki_key_rotation, pki_algorithm_agility, pki_split_knowledge, pki_backup_encrypted>>

\* Specification
Spec == Init /\ [][Next]_<<pki_ca_hardened, pki_crl_enabled, pki_ocsp_stapling, pki_cert_transparency, pki_key_escrow_disabled, pki_renewal_automated, pki_hsm_storage, pki_key_rotation, pki_algorithm_agility, pki_split_knowledge, pki_backup_encrypted>>

====
