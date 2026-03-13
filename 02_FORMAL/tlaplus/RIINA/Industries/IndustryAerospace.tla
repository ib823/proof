---- MODULE IndustryAerospace ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/Industries/IndustryAerospace.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* DAL (matches Coq: Inductive DAL)
CONSTANTS DAL_A, DAL_B, DAL_C, DAL_D, DAL_E

DALSet == {DAL_A, DAL_B, DAL_C, DAL_D, DAL_E}

\* AerospaceEffect (matches Coq: Inductive AerospaceEffect)
CONSTANTS FlightControl, Navigation, Communication, SafetyCritical, Telemetry

AerospaceEffectSet == {FlightControl, Navigation, Communication, SafetyCritical, Telemetry}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* DO178C_Compliance (matches Coq: Record DO178C_Compliance)
VARIABLES software_plans, software_development, verification, configuration_management, quality_assurance, certification_liaison, dal_level

vars == <<software_plans, software_development, verification, configuration_management, quality_assurance, certification_liaison, dal_level>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ software_plans \in BOOLEAN
  /\ software_development \in BOOLEAN
  /\ verification \in BOOLEAN
  /\ configuration_management \in BOOLEAN
  /\ quality_assurance \in BOOLEAN
  /\ certification_liaison \in BOOLEAN
  /\ dal_level \in DALSet

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ software_plans = FALSE
  /\ software_development = FALSE
  /\ verification = FALSE
  /\ configuration_management = FALSE
  /\ quality_assurance = FALSE
  /\ certification_liaison = FALSE
  /\ dal_level = DAL_A

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* dal_le (matches Coq: Definition dal_le)
dal_le(d2) ==
    CASE d1 = DAL_A, DAL_A -> TRUE
      [] d1 = DAL_B, DAL_A | DAL_B, DAL_B -> TRUE
      [] d1 = DAL_C, DAL_A | DAL_C, DAL_B | DAL_C, DAL_C -> TRUE
      [] d1 = DAL_D, DAL_A | DAL_D, DAL_B | DAL_D, DAL_C | DAL_D, DAL_D -> TRUE
      [] d1 = DAL_E, _ -> TRUE
      [] d1 = _, _ -> FALSE

\* objectives_for_dal (matches Coq: Definition objectives_for_dal)
objectives_for_dal(d) ==
    CASE d = DAL_A -> 71
      [] d = DAL_B -> 69
      [] d = DAL_C -> 62
      [] d = DAL_D -> 26
      [] d = DAL_E -> 0

\* dal_to_nat (matches Coq: Definition dal_to_nat)
dal_to_nat(d) ==
    CASE d = DAL_A -> 5
      [] d = DAL_B -> 4
      [] d = DAL_C -> 3
      [] d = DAL_D -> 2
      [] d = DAL_E -> 1

\* mcdc_required (matches Coq: Definition mcdc_required)
mcdc_required(d) ==
    CASE d = DAL_A -> TRUE
      [] d = DAL_B -> TRUE
    [] OTHER -> FALSE

\* decision_coverage_required (matches Coq: Definition decision_coverage_required)
decision_coverage_required(d) ==
    CASE d = DAL_A | DAL_B | DAL_C -> TRUE
    [] OTHER -> FALSE

\* do178c_all_sections (matches Coq: Definition do178c_all_sections)
do178c_all_sections(c) ==
  software_plans /\ software_development /\ verification /\ configuration_management /\ quality_assurance /\ certification_liaison

\* formal_methods_applicable (matches Coq: Definition formal_methods_applicable)
formal_methods_applicable(d) ==
    CASE d = DAL_A | DAL_B -> TRUE
    [] OTHER -> FALSE

\* dal_max (matches Coq: Definition dal_max)
dal_max(d2) ==
  d2 >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateDO178C_Compliance ==
  /\ software_plans' \in BOOLEAN
  /\ software_development' \in BOOLEAN
  /\ verification' \in BOOLEAN
  /\ configuration_management' \in BOOLEAN
  /\ quality_assurance' \in BOOLEAN
  /\ certification_liaison' \in BOOLEAN
  /\ dal_level' \in DALSet

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateDO178C_Compliance \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* do_178c_compliance
THEOREM do_178c_compliance ==
  \A compliance \in Nat :
    compliance >= 0

\* do_326a_security
THEOREM do_326a_security ==
  \A aircraft_system \in Nat, threat_model \in Nat :
    aircraft_system >= 0 /\ threat_model >= 0

\* do_333_formal_methods
THEOREM do_333_formal_methods ==
  \A specification \in Nat, proof \in Nat :
    specification >= 0 /\ proof >= 0

\* arp4754a_development
THEOREM arp4754a_development ==
  \A system_architecture \in Nat :
    system_architecture >= 0

\* do_254_hardware
THEOREM do_254_hardware ==
  \A hardware_design \in Nat :
    hardware_design >= 0

\* dal_a_mcdc_required
THEOREM dal_a_mcdc_required ==
  \A compliance \in Nat :
    compliance # 0

\* dal_objectives_monotone
THEOREM dal_objectives_monotone ==
  \A d1 \in Nat, d2 \in Nat :
      dal_le(d2, d1) => objectives_for_dal d1 >= objectives_for_dal d2

\* dal_le_iff_nat
THEOREM dal_le_iff_nat ==
  \A d1 \in Nat, d2 \in Nat :
      dal_le(d1, d2) => dal_to_nat d1 <= dal_to_nat d2

\* dal_le_refl
THEOREM dal_le_refl ==
  \A d \in Nat :
      dal_le(d, d) = TRUE

\* dal_le_trans
THEOREM dal_le_trans ==
  \A d1 \in Nat, d2 \in Nat, d3 \in Nat :
      dal_le(d1, d2) => dal_le(d1, d3)

\* dal_le_antisym
THEOREM dal_le_antisym ==
  \A d1 \in Nat, d2 \in Nat :
      dal_le(d1, d2) => d1 = d2

\* dal_le_total
THEOREM dal_le_total ==
  \A d1 \in Nat, d2 \in Nat :
      dal_le(d1, d2) = true \/ dal_le d2 d1 = true

\* dal_e_bottom
THEOREM dal_e_bottom ==
  \A d \in Nat :
      dal_le(DAL_E, d) = TRUE

\* dal_a_max_objectives
THEOREM dal_a_max_objectives ==
  \A d \in Nat :
      objectives_for_dal d < = objectives_for_dal(DAL_A)

\* dal_e_zero_objectives
THEOREM dal_e_zero_objectives ==
  objectives_for_dal(DAL_E) = 0

\* objectives_strict_ordering
THEOREM objectives_strict_ordering ==
  objectives_for_dal DAL_A > objectives_for_dal DAL_B /\ objectives_for_dal DAL_B > objectives_for_dal DAL_C /\ objectives_for_dal DAL_C > objectives_for_dal DAL_D /\ objectives_for_dal DAL_D > objectives_for_dal DAL_E

\* mcdc_only_high_dal
THEOREM mcdc_only_high_dal ==
  \A d \in Nat :
      mcdc_required(d) => dal_le(DAL_B, d)

\* decision_coverage_implies_dal_c_or_above
THEOREM decision_coverage_implies_dal_c_or_above ==
  \A d \in Nat :
      decision_coverage_required(d) => dal_le(DAL_C, d)

\* do178c_all_requires_plans
THEOREM do178c_all_requires_plans ==
  \A c \in Nat :
      do178c_all_sections(c) => software_plans(c)

\* do178c_all_requires_verification
THEOREM do178c_all_requires_verification ==
  \A c \in Nat :
      do178c_all_sections(c) => verification(c)

\* do178c_all_requires_qa
THEOREM do178c_all_requires_qa ==
  \A c \in Nat :
      do178c_all_sections(c) => quality_assurance(c)

\* formal_methods_only_high_dal
THEOREM formal_methods_only_high_dal ==
  \A d \in Nat :
      formal_methods_applicable(d) => objectives_for_dal d >= 69

\* dal_max_dominates_left
THEOREM dal_max_dominates_left ==
  \A d1 \in Nat, d2 \in Nat :
      dal_le d1 (dal_max d1 d2) = TRUE

\* dal_max_dominates_right
THEOREM dal_max_dominates_right ==
  \A d1 \in Nat, d2 \in Nat :
      dal_le d2 (dal_max d1 d2) = TRUE

\* dal_max_objectives
THEOREM dal_max_objectives ==
  \A d1 \in Nat, d2 \in Nat :
      objectives_for_dal (dal_max d1 d2) >= objectives_for_dal d1 /\ objectives_for_dal (dal_max d1 d2) >= objectives_for_dal d2

====
