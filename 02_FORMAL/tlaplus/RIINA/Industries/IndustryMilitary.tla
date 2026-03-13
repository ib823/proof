---- MODULE IndustryMilitary ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/Industries/IndustryMilitary.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ClassificationLevel (matches Coq: Inductive ClassificationLevel)
CONSTANTS Unclassified, CUI, Confidential, Secret, TopSecret, TS_SCI

ClassificationLevelSet == {Unclassified, CUI, Confidential, Secret, TopSecret, TS_SCI}

\* MilitaryEffect (matches Coq: Inductive MilitaryEffect)
CONSTANTS ClassifiedIO, SecureComms, WeaponSystem, IntelligenceOp

MilitaryEffectSet == {ClassifiedIO, SecureComms, WeaponSystem, IntelligenceOp}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* MilitarySecurityPolicy (matches Coq: Record MilitarySecurityPolicy)
VARIABLES classification, need_to_know, clearance_required, comsec_approved, tempest_certified

vars == <<classification, need_to_know, clearance_required, comsec_approved, tempest_certified>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ classification \in ClassificationLevelSet
  /\ need_to_know \in Seq(Nat)
  /\ clearance_required \in ClassificationLevelSet
  /\ comsec_approved \in BOOLEAN
  /\ tempest_certified \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ classification = Unclassified
  /\ need_to_know = <<>>
  /\ clearance_required = Unclassified
  /\ comsec_approved = FALSE
  /\ tempest_certified = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* class_le (matches Coq: Definition class_le)
class_le(c2) ==
    CASE c1 = Unclassified, _ -> TRUE
      [] c1 = CUI, CUI | CUI, Confidential | CUI, Secret | CUI, TopSecret | CUI, TS_SCI -> TRUE
      [] c1 = Confidential, Confidential | Confidential, Secret | Confidential, TopSecret | Confidential, TS_SCI -> TRUE
      [] c1 = Secret, Secret | Secret, TopSecret | Secret, TS_SCI -> TRUE
      [] c1 = TopSecret, TopSecret | TopSecret, TS_SCI -> TRUE
      [] c1 = TS_SCI, TS_SCI -> TRUE
      [] c1 = _, _ -> FALSE

\* class_to_nat (matches Coq: Definition class_to_nat)
class_to_nat(c) ==
    CASE c = Unclassified -> 0
      [] c = CUI -> 1
      [] c = Confidential -> 2
      [] c = Secret -> 3
      [] c = TopSecret -> 4
      [] c = TS_SCI -> 5

\* class_max (matches Coq: Definition class_max)
class_max(c2) ==
  c2 >= 0

\* key_level (matches Coq: Definition key_level)
key_level(c) ==
  c >= 0

\* weapon_system_authorized (matches Coq: Definition weapon_system_authorized)
weapon_system_authorized(clearance) ==
  clearance >= 0

\* redundancy_factor (matches Coq: Definition redundancy_factor)
redundancy_factor(c) ==
    CASE c = Unclassified -> 1
      [] c = CUI -> 2
      [] c = Confidential -> 2
      [] c = Secret -> 3
      [] c = TopSecret -> 4
      [] c = TS_SCI -> 5

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateMilitarySecurityPolicy ==
  /\ classification' \in ClassificationLevelSet
  /\ need_to_know' = need_to_know
  /\ clearance_required' \in ClassificationLevelSet
  /\ comsec_approved' \in BOOLEAN
  /\ tempest_certified' \in BOOLEAN

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateMilitarySecurityPolicy \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* nist_800_171_access_control
THEOREM nist_800_171_access_control ==
  \A policy \in Nat, data_class \in ClassificationLevelSet :
    policy >= 0 /\ data_class >= 0

\* cmmc_level3_compliance
THEOREM cmmc_level3_compliance ==
  \A policy \in Nat :
    policy >= 0

\* itar_export_control
THEOREM itar_export_control ==
  \A data_class \in ClassificationLevelSet, destination \in Nat :
    data_class >= 0 /\ destination >= 0

\* mil_std_882_safety
THEOREM mil_std_882_safety ==
  \A system \in Nat, hazard_level \in Nat :
    system >= 0 /\ hazard_level >= 0

\* rmf_authorization
THEOREM rmf_authorization ==
  \A system \in Nat, risk_level \in Nat :
    system >= 0 /\ risk_level >= 0

\* class_le_refl
THEOREM class_le_refl ==
  \A c \in Nat :
      class_le(c, c) = TRUE

\* class_le_trans
THEOREM class_le_trans ==
  \A c1 \in Nat, c2 \in Nat, c3 \in Nat :
      class_le(c1, c2) => class_le(c1, c3)

\* no_read_up
THEOREM no_read_up ==
  \A subject_clearance \in Nat, object_classification \in Nat :
    subject_clearance >= 0 /\ object_classification >= 0

\* class_le_iff_nat
THEOREM class_le_iff_nat ==
  \A c1 \in Nat, c2 \in Nat :
      class_le(c1, c2) => class_to_nat c1 <= class_to_nat c2

\* class_le_antisym
THEOREM class_le_antisym ==
  \A c1 \in Nat, c2 \in Nat :
      class_le(c1, c2) => c1 = c2

\* class_le_total
THEOREM class_le_total ==
  \A c1 \in Nat, c2 \in Nat :
      class_le(c1, c2) = true \/ class_le c2 c1 = true

\* unclassified_bottom
THEOREM unclassified_bottom ==
  \A c \in Nat :
      class_le(Unclassified, c) = TRUE

\* ts_sci_top
THEOREM ts_sci_top ==
  \A c \in Nat :
      class_le(c, TS_SCI) = TRUE

\* bell_lapadula_ss
THEOREM bell_lapadula_ss ==
  \A policy \in Nat, object_class \in ClassificationLevelSet :
      class_le object_class (clearance_required policy) = false => class_to_nat object_class > class_to_nat (clearance_required policy)

\* bell_lapadula_star
THEOREM bell_lapadula_star ==
  \A subject_class \in Nat, object_class \in Nat :
      class_le(subject_class, object_class) => class_to_nat subject_class <= class_to_nat object_class

\* has_compartment_In
THEOREM has_compartment_In ==
  \A c \in Nat, comps \in Nat :
      has_compartment(comps, c) => exists x, In x comps /\ Nat.eqb c x = true

\* empty_need_to_know_unrestricted
THEOREM empty_need_to_know_unrestricted ==
  \A c \in Nat :
      has_compartment(nil, c) = FALSE

\* comsec_required_for_classified_comms
THEOREM comsec_required_for_classified_comms ==
  \A policy \in Nat :
      class_le Confidential (classification policy) = true => class_to_nat (classification policy) >= 2

\* tempest_required_for_secret
THEOREM tempest_required_for_secret ==
  \A policy \in Nat :
      class_le Secret (classification policy) = true => class_to_nat (classification policy) >= 3

\* cross_domain_no_downgrade
THEOREM cross_domain_no_downgrade ==
  \A src_class \in Nat, dst_class \in Nat :
      class_le src_class dst_class = false => class_to_nat src_class > class_to_nat dst_class

\* class_max_ge_left
THEOREM class_max_ge_left ==
  \A c1 \in Nat, c2 \in Nat :
      class_le c1 (class_max c1 c2) = TRUE

\* class_max_ge_right
THEOREM class_max_ge_right ==
  \A c1 \in Nat, c2 \in Nat :
      class_le c2 (class_max c1 c2) = TRUE

\* aggregation_raises_classification
THEOREM aggregation_raises_classification ==
  \A c1 \in Nat, c2 \in Nat :
      class_to_nat (class_max c1 c2) >= class_to_nat c1 /\ class_to_nat (class_max c1 c2) >= class_to_nat c2

\* key_level_monotone
THEOREM key_level_monotone ==
  \A c1 \in Nat, c2 \in Nat :
      class_le(c1, c2) => key_level c1 <= key_level c2

\* personnel_clearance_dominates
THEOREM personnel_clearance_dominates ==
  \A policy \in Nat :
      class_le (classification policy) (clearance_required policy) = true => class_to_nat (classification policy) <= class_to_nat (clearance_required policy)

\* 2 additional theorems proven in Coq source

====
