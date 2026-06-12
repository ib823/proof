\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE TerasCapabilities ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/TerasCapabilities.v (36 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* CapConfinementConfig (matches Coq: Record CapConfinementConfig)
VARIABLES tc_no_cap_leak, tc_sandbox_boundary_enforced, tc_cap_table_integrity, tc_no_forgery

\* CapRevocationConfig (matches Coq: Record CapRevocationConfig)
VARIABLES tc_revocation_complete, tc_revocation_propagates, tc_no_zombie_caps, tc_immediate_effect

\* CapDelegationConfig (matches Coq: Record CapDelegationConfig)
VARIABLES tc_delegation_authorized, tc_attenuation_only, tc_delegation_audited

\* Type invariant
TypeOK ==
  /\ tc_no_cap_leak \in BOOLEAN
  /\ tc_sandbox_boundary_enforced \in BOOLEAN
  /\ tc_cap_table_integrity \in BOOLEAN
  /\ tc_no_forgery \in BOOLEAN
  /\ tc_revocation_complete \in BOOLEAN
  /\ tc_revocation_propagates \in BOOLEAN
  /\ tc_no_zombie_caps \in BOOLEAN
  /\ tc_immediate_effect \in BOOLEAN
  /\ tc_delegation_authorized \in BOOLEAN
  /\ tc_attenuation_only \in BOOLEAN
  /\ tc_delegation_audited \in BOOLEAN

\* Initial state
Init ==
  /\ tc_no_cap_leak = TRUE
  /\ tc_sandbox_boundary_enforced = TRUE
  /\ tc_cap_table_integrity = TRUE
  /\ tc_no_forgery = TRUE
  /\ tc_revocation_complete = TRUE
  /\ tc_revocation_propagates = TRUE
  /\ tc_no_zombie_caps = TRUE
  /\ tc_immediate_effect = TRUE
  /\ tc_delegation_authorized = TRUE
  /\ tc_attenuation_only = TRUE
  /\ tc_delegation_audited = TRUE

\* cap_confined (matches Coq: Definition cap_confined)
cap_confined(c) == TRUE

\* riina_cap_confinement (matches Coq: Definition riina_cap_confinement)
riina_cap_confinement == TRUE

\* bad_confinement (matches Coq: Definition bad_confinement)
bad_confinement == TRUE

\* cap_revocation_safe (matches Coq: Definition cap_revocation_safe)
cap_revocation_safe(c) == TRUE

\* riina_cap_revocation (matches Coq: Definition riina_cap_revocation)
riina_cap_revocation == TRUE

\* bad_revocation (matches Coq: Definition bad_revocation)
bad_revocation == TRUE

\* cap_delegation_safe (matches Coq: Definition cap_delegation_safe)
cap_delegation_safe(c) == TRUE

\* riina_cap_delegation (matches Coq: Definition riina_cap_delegation)
riina_cap_delegation == TRUE

\* bad_delegation (matches Coq: Definition bad_delegation)
bad_delegation == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* TC_001 (matches Coq: Theorem TC_001)
THEOREM TC_001 == Init => TypeOK

\* TC_002 (matches Coq: Theorem TC_002)
THEOREM TC_002 == Init => TypeOK

\* TC_003 (matches Coq: Theorem TC_003)
THEOREM TC_003 == Init => TypeOK

\* TC_004 (matches Coq: Theorem TC_004)
THEOREM TC_004 == Init => TypeOK

\* TC_005 (matches Coq: Theorem TC_005)
THEOREM TC_005 == Init => TypeOK

\* TC_006 (matches Coq: Theorem TC_006)
THEOREM TC_006 == Init => TypeOK

\* TC_007 (matches Coq: Theorem TC_007)
THEOREM TC_007 == Init => TypeOK

\* TC_008 (matches Coq: Theorem TC_008)
THEOREM TC_008 == Init => TypeOK

\* TC_009 (matches Coq: Theorem TC_009)
THEOREM TC_009 == Init => TypeOK

\* TC_010 (matches Coq: Theorem TC_010)
THEOREM TC_010 == Init => TypeOK

\* TC_011 (matches Coq: Theorem TC_011)
THEOREM TC_011 == Init => TypeOK

\* TC_012 (matches Coq: Theorem TC_012)
THEOREM TC_012 == Init => TypeOK

\* TC_013 (matches Coq: Theorem TC_013)
THEOREM TC_013 == Init => TypeOK

\* TC_014 (matches Coq: Theorem TC_014)
THEOREM TC_014 == Init => TypeOK

\* TC_015 (matches Coq: Theorem TC_015)
THEOREM TC_015 == Init => TypeOK

\* TC_016 (matches Coq: Theorem TC_016)
THEOREM TC_016 == Init => TypeOK

\* TC_017 (matches Coq: Theorem TC_017)
THEOREM TC_017 == Init => TypeOK

\* TC_018 (matches Coq: Theorem TC_018)
THEOREM TC_018 == Init => TypeOK

\* TC_019 (matches Coq: Theorem TC_019)
THEOREM TC_019 == Init => TypeOK

\* TC_020 (matches Coq: Theorem TC_020)
THEOREM TC_020 == Init => TypeOK

\* TC_021 (matches Coq: Theorem TC_021)
THEOREM TC_021 == Init => TypeOK

\* TC_022 (matches Coq: Theorem TC_022)
THEOREM TC_022 == Init => TypeOK

\* TC_023 (matches Coq: Theorem TC_023)
THEOREM TC_023 == Init => TypeOK

\* TC_024 (matches Coq: Theorem TC_024)
THEOREM TC_024 == Init => TypeOK

\* TC_025 (matches Coq: Theorem TC_025)
THEOREM TC_025 == Init => TypeOK

\* TC_026 (matches Coq: Theorem TC_026)
THEOREM TC_026 == Init => TypeOK

\* TC_027 (matches Coq: Theorem TC_027)
THEOREM TC_027 == Init => TypeOK

\* TC_028 (matches Coq: Theorem TC_028)
THEOREM TC_028 == Init => TypeOK

\* TC_029 (matches Coq: Theorem TC_029)
THEOREM TC_029 == Init => TypeOK

\* TC_030 (matches Coq: Theorem TC_030)
THEOREM TC_030 == Init => TypeOK

\* TC_031 (matches Coq: Theorem TC_031)
THEOREM TC_031 == Init => TypeOK

\* TC_032 (matches Coq: Theorem TC_032)
THEOREM TC_032 == Init => TypeOK

\* TC_033 (matches Coq: Theorem TC_033)
THEOREM TC_033 == Init => TypeOK

\* TC_034 (matches Coq: Theorem TC_034)
THEOREM TC_034 == Init => TypeOK

\* TC_035 (matches Coq: Theorem TC_035)
THEOREM TC_035 == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<tc_no_cap_leak, tc_sandbox_boundary_enforced, tc_cap_table_integrity, tc_no_forgery, tc_revocation_complete, tc_revocation_propagates, tc_no_zombie_caps, tc_immediate_effect, tc_delegation_authorized, tc_attenuation_only, tc_delegation_audited>>

\* Specification
Spec == Init /\ [][Next]_<<tc_no_cap_leak, tc_sandbox_boundary_enforced, tc_cap_table_integrity, tc_no_forgery, tc_revocation_complete, tc_revocation_propagates, tc_no_zombie_caps, tc_immediate_effect, tc_delegation_authorized, tc_attenuation_only, tc_delegation_audited>>

====
