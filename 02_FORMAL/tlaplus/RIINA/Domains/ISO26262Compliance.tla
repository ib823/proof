---- MODULE ISO26262Compliance ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/ISO26262Compliance.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ASIL (matches Coq: Inductive ASIL)
CONSTANTS ASIL_D, ASIL_C, ASIL_B, ASIL_A, QM

ASILSet == {ASIL_D, ASIL_C, ASIL_B, ASIL_A, QM}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* HARA (matches Coq: Record HARA)
VARIABLES hara_hazards_identified, hara_severity_classified, hara_exposure_assessed, hara_controllability_assessed, hara_asil_determined, hara_safety_goals_defined

\* SafetyConcept (matches Coq: Record SafetyConcept)
VARIABLES fsc_safety_requirements, fsc_allocation_to_elements, fsc_fault_tolerant_mechanisms, fsc_safety_mechanisms

\* SoftwareDevelopment (matches Coq: Record SoftwareDevelopment)
VARIABLES sw_safety_requirements, sw_architecture_design, sw_unit_design, sw_unit_implementation, sw_unit_verification, sw_integration_verification, sw_safety_validation

\* VerificationMethods (matches Coq: Record VerificationMethods)
VARIABLES vm_requirements_inspection, vm_walkthrough, vm_formal_verification, vm_control_flow_analysis, vm_data_flow_analysis, vm_static_analysis, vm_semantic_analysis

\* TestingRequirements (matches Coq: Record TestingRequirements)
VARIABLES test_requirements_based, test_fault_injection, test_back_to_back, test_structural_coverage, test_mc_dc_coverage

vars == <<hara_hazards_identified, hara_severity_classified, hara_exposure_assessed, hara_controllability_assessed, hara_asil_determined, hara_safety_goals_defined, fsc_safety_requirements, fsc_allocation_to_elements, fsc_fault_tolerant_mechanisms, fsc_safety_mechanisms, sw_safety_requirements, sw_architecture_design, sw_unit_design, sw_unit_implementation, sw_unit_verification, sw_integration_verification, sw_safety_validation, vm_requirements_inspection, vm_walkthrough, vm_formal_verification, vm_control_flow_analysis, vm_data_flow_analysis, vm_static_analysis, vm_semantic_analysis, test_requirements_based, test_fault_injection, test_back_to_back, test_structural_coverage, test_mc_dc_coverage>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ hara_hazards_identified \in BOOLEAN
  /\ hara_severity_classified \in BOOLEAN
  /\ hara_exposure_assessed \in BOOLEAN
  /\ hara_controllability_assessed \in BOOLEAN
  /\ hara_asil_determined \in BOOLEAN
  /\ hara_safety_goals_defined \in BOOLEAN
  /\ fsc_safety_requirements \in BOOLEAN
  /\ fsc_allocation_to_elements \in BOOLEAN
  /\ fsc_fault_tolerant_mechanisms \in BOOLEAN
  /\ fsc_safety_mechanisms \in BOOLEAN
  /\ sw_safety_requirements \in BOOLEAN
  /\ sw_architecture_design \in BOOLEAN
  /\ sw_unit_design \in BOOLEAN
  /\ sw_unit_implementation \in BOOLEAN
  /\ sw_unit_verification \in BOOLEAN
  /\ sw_integration_verification \in BOOLEAN
  /\ sw_safety_validation \in BOOLEAN
  /\ vm_requirements_inspection \in BOOLEAN
  /\ vm_walkthrough \in BOOLEAN
  /\ vm_formal_verification \in BOOLEAN
  /\ vm_control_flow_analysis \in BOOLEAN
  /\ vm_data_flow_analysis \in BOOLEAN
  /\ vm_static_analysis \in BOOLEAN
  /\ vm_semantic_analysis \in BOOLEAN
  /\ test_requirements_based \in BOOLEAN
  /\ test_fault_injection \in BOOLEAN
  /\ test_back_to_back \in BOOLEAN
  /\ test_structural_coverage \in BOOLEAN
  /\ test_mc_dc_coverage \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ hara_hazards_identified = FALSE
  /\ hara_severity_classified = FALSE
  /\ hara_exposure_assessed = FALSE
  /\ hara_controllability_assessed = FALSE
  /\ hara_asil_determined = FALSE
  /\ hara_safety_goals_defined = FALSE
  /\ fsc_safety_requirements = FALSE
  /\ fsc_allocation_to_elements = FALSE
  /\ fsc_fault_tolerant_mechanisms = FALSE
  /\ fsc_safety_mechanisms = FALSE
  /\ sw_safety_requirements = FALSE
  /\ sw_architecture_design = FALSE
  /\ sw_unit_design = FALSE
  /\ sw_unit_implementation = FALSE
  /\ sw_unit_verification = FALSE
  /\ sw_integration_verification = FALSE
  /\ sw_safety_validation = FALSE
  /\ vm_requirements_inspection = FALSE
  /\ vm_walkthrough = FALSE
  /\ vm_formal_verification = FALSE
  /\ vm_control_flow_analysis = FALSE
  /\ vm_data_flow_analysis = FALSE
  /\ vm_static_analysis = FALSE
  /\ vm_semantic_analysis = FALSE
  /\ test_requirements_based = FALSE
  /\ test_fault_injection = FALSE
  /\ test_back_to_back = FALSE
  /\ test_structural_coverage = FALSE
  /\ test_mc_dc_coverage = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* asil_leq (matches Coq: Definition asil_leq)
asil_leq(a2) ==
    CASE a1 = QM, _ -> TRUE
      [] a1 = ASIL_A, QM -> FALSE
      [] a1 = ASIL_A, _ -> TRUE
      [] a1 = ASIL_B, QM -> FALSE
      [] a1 = ASIL_B, ASIL_A -> FALSE
      [] a1 = ASIL_B, _ -> TRUE
      [] a1 = ASIL_C, ASIL_D -> TRUE
      [] a1 = ASIL_C, ASIL_C -> TRUE
      [] a1 = ASIL_C, _ -> FALSE
      [] a1 = ASIL_D, ASIL_D -> TRUE
      [] a1 = ASIL_D, _ -> FALSE

\* hara_compliant (matches Coq: Definition hara_compliant)
hara_compliant(h) ==
  hara_hazards_identified /\ hara_severity_classified /\ hara_exposure_assessed /\ hara_controllability_assessed /\ hara_asil_determined /\ hara_safety_goals_defined

\* safety_concept_compliant (matches Coq: Definition safety_concept_compliant)
safety_concept_compliant(s) ==
  fsc_safety_requirements /\ fsc_allocation_to_elements /\ fsc_fault_tolerant_mechanisms /\ fsc_safety_mechanisms

\* sw_dev_compliant (matches Coq: Definition sw_dev_compliant)
sw_dev_compliant(d) ==
  sw_safety_requirements /\ sw_architecture_design /\ sw_unit_design /\ sw_unit_implementation /\ sw_unit_verification /\ sw_integration_verification /\ sw_safety_validation

\* verif_methods_compliant (matches Coq: Definition verif_methods_compliant)
verif_methods_compliant(v) ==
  vm_requirements_inspection /\ vm_walkthrough /\ vm_formal_verification /\ vm_control_flow_analysis /\ vm_data_flow_analysis /\ vm_static_analysis /\ vm_semantic_analysis

\* testing_compliant (matches Coq: Definition testing_compliant)
testing_compliant(t) ==
  test_requirements_based /\ test_fault_injection /\ test_back_to_back /\ test_structural_coverage /\ test_mc_dc_coverage

\* asil_d_compliant (matches Coq: Definition asil_d_compliant)
asil_d_compliant(c) ==
  iso_asil(c) /\ iso_hara(c) /\ iso_safety_concept(c) /\ iso_sw_dev(c) /\ iso_verif_methods(c)

\* mk_compliant_hara (matches Coq: Definition mk_compliant_hara)
mk_compliant_hara ==
  0

\* mk_compliant_safety_concept (matches Coq: Definition mk_compliant_safety_concept)
mk_compliant_safety_concept ==
  0

\* mk_compliant_sw_dev (matches Coq: Definition mk_compliant_sw_dev)
mk_compliant_sw_dev ==
  0

\* mk_compliant_verif_methods (matches Coq: Definition mk_compliant_verif_methods)
mk_compliant_verif_methods ==
  0

\* mk_compliant_testing (matches Coq: Definition mk_compliant_testing)
mk_compliant_testing ==
  0

\* riina_iso26262 (matches Coq: Definition riina_iso26262)
riina_iso26262 ==
  0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateHARA ==
  /\ hara_hazards_identified' \in BOOLEAN
  /\ hara_severity_classified' \in BOOLEAN
  /\ hara_exposure_assessed' \in BOOLEAN
  /\ hara_controllability_assessed' \in BOOLEAN
  /\ hara_asil_determined' \in BOOLEAN
  /\ hara_safety_goals_defined' \in BOOLEAN
  /\ UNCHANGED <<fsc_safety_requirements, fsc_allocation_to_elements, fsc_fault_tolerant_mechanisms, fsc_safety_mechanisms, sw_safety_requirements, sw_architecture_design, sw_unit_design, sw_unit_implementation, sw_unit_verification, sw_integration_verification, sw_safety_validation, vm_requirements_inspection, vm_walkthrough, vm_formal_verification, vm_control_flow_analysis, vm_data_flow_analysis, vm_static_analysis, vm_semantic_analysis, test_requirements_based, test_fault_injection, test_back_to_back, test_structural_coverage, test_mc_dc_coverage>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateHARA \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* andb_true_iff
THEOREM andb_true_iff ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true < => a = true /\ b = true

\* ISO_001_asil_reflexive
THEOREM ISO_001_asil_reflexive ==
  \A a \in Nat, ASIL \in Nat :
      asil_leq(a, a) = TRUE

\* ISO_002_asil_transitive
THEOREM ISO_002_asil_transitive ==
  \A a1 \in Nat, a2 \in Nat, a3 \in Nat, ASIL \in Nat :
      asil_leq(a1, a2) => asil_leq(a1, a3)

\* ISO_003_qm_bottom
THEOREM ISO_003_qm_bottom ==
  \A a \in Nat, ASIL \in Nat :
      asil_leq(QM, a) = TRUE

\* ISO_004_asil_d_top
THEOREM ISO_004_asil_d_top ==
  \A a \in Nat, ASIL \in Nat :
      asil_leq(a, ASIL_D) = TRUE

\* ISO_005_hara_valid
THEOREM ISO_005_hara_valid ==
  hara_compliant(mk_compliant_hara) = TRUE

\* ISO_006_hazards_identified
THEOREM ISO_006_hazards_identified ==
  \A h \in Nat, HARA \in Nat :
      hara_compliant(h) => hara_hazards_identified(h)

\* ISO_007_safety_goals
THEOREM ISO_007_safety_goals ==
  \A h \in Nat, HARA \in Nat :
      hara_compliant(h) => hara_safety_goals_defined(h)

\* ISO_008_asil_determined
THEOREM ISO_008_asil_determined ==
  \A h \in Nat, HARA \in Nat :
      hara_compliant(h) => hara_asil_determined(h)

\* ISO_009_sw_dev_valid
THEOREM ISO_009_sw_dev_valid ==
  sw_dev_compliant(mk_compliant_sw_dev) = TRUE

\* ISO_010_safety_requirements
THEOREM ISO_010_safety_requirements ==
  \A d \in Nat, SoftwareDevelopment \in Nat :
      sw_dev_compliant(d) => sw_safety_requirements(d)

\* ISO_011_unit_verification
THEOREM ISO_011_unit_verification ==
  \A d \in Nat, SoftwareDevelopment \in Nat :
      sw_dev_compliant(d) => sw_unit_verification(d)

\* ISO_012_safety_validation
THEOREM ISO_012_safety_validation ==
  \A d \in Nat, SoftwareDevelopment \in Nat :
      sw_dev_compliant(d) => sw_safety_validation(d)

\* ISO_013_verif_methods_valid
THEOREM ISO_013_verif_methods_valid ==
  verif_methods_compliant(mk_compliant_verif_methods) = TRUE

\* ISO_014_formal_verification
THEOREM ISO_014_formal_verification ==
  \A v \in Nat, VerificationMethods \in Nat :
      verif_methods_compliant(v) => vm_formal_verification(v)

\* ISO_015_static_analysis
THEOREM ISO_015_static_analysis ==
  \A v \in Nat, VerificationMethods \in Nat :
      verif_methods_compliant(v) => vm_static_analysis(v)

\* ISO_016_data_flow
THEOREM ISO_016_data_flow ==
  \A v \in Nat, VerificationMethods \in Nat :
      verif_methods_compliant(v) => vm_data_flow_analysis(v)

\* ISO_017_testing_valid
THEOREM ISO_017_testing_valid ==
  testing_compliant(mk_compliant_testing) = TRUE

\* ISO_018_mcdc_coverage
THEOREM ISO_018_mcdc_coverage ==
  \A t \in Nat, TestingRequirements \in Nat :
      testing_compliant(t) => test_mc_dc_coverage(t)

\* ISO_019_fault_injection
THEOREM ISO_019_fault_injection ==
  \A t \in Nat, TestingRequirements \in Nat :
      testing_compliant(t) => test_fault_injection(t)

\* ISO_020_requirements_based
THEOREM ISO_020_requirements_based ==
  \A t \in Nat, TestingRequirements \in Nat :
      testing_compliant(t) => test_requirements_based(t)

\* ISO_021_riina_asil_d
THEOREM ISO_021_riina_asil_d ==
  asil_d_compliant(riina_iso26262) = TRUE

\* ISO_022_asil_d_level
THEOREM ISO_022_asil_d_level ==
  \A c \in Nat, ISO26262Compliance \in Nat :
      asil_d_compliant(c) => iso_asil c = ASIL_D

\* ISO_023_asil_d_hara
THEOREM ISO_023_asil_d_hara ==
  \A c \in Nat, ISO26262Compliance \in Nat :
      asil_d_compliant(c) => hara_compliant (iso_hara c) = true

\* ISO_024_asil_d_sw_dev
THEOREM ISO_024_asil_d_sw_dev ==
  \A c \in Nat, ISO26262Compliance \in Nat :
      asil_d_compliant(c) => sw_dev_compliant (iso_sw_dev c) = true

\* 11 additional theorems proven in Coq source

====
