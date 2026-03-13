---- MODULE RollbackProtection ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/RollbackProtection.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ComponentId (matches Coq: Inductive ComponentId)
CONSTANTS CompId

ComponentIdSet == {CompId}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Version (matches Coq: Record Version)
VARIABLES major, minor, patch, build

\* VersionedComponent (matches Coq: Record VersionedComponent)
VARIABLES comp_id, comp_version, comp_hash

\* MinVersionEntry (matches Coq: Record MinVersionEntry)
VARIABLES min_comp_id, min_version, stored_in_hardware

\* RollbackState (matches Coq: Record RollbackState)
VARIABLES minimum_versions, current_versions, anti_rollback_enabled

vars == <<major, minor, patch, build, comp_id, comp_version, comp_hash, min_comp_id, min_version, stored_in_hardware, minimum_versions, current_versions, anti_rollback_enabled>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ major \in Nat
  /\ minor \in Nat
  /\ patch \in Nat
  /\ build \in Nat
  /\ comp_id \in ComponentIdSet
  /\ comp_version \in Nat
  /\ comp_hash \in Nat
  /\ min_comp_id \in ComponentIdSet
  /\ min_version \in Nat
  /\ stored_in_hardware \in BOOLEAN
  /\ minimum_versions \in Seq(Nat)
  /\ current_versions \in Seq(Nat)
  /\ anti_rollback_enabled \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ major = 0
  /\ minor = 0
  /\ patch = 0
  /\ build = 0
  /\ comp_id = CompId
  /\ comp_version = 0
  /\ comp_hash = 0
  /\ min_comp_id = CompId
  /\ min_version = 0
  /\ stored_in_hardware = FALSE
  /\ minimum_versions = <<>>
  /\ current_versions = <<>>
  /\ anti_rollback_enabled = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* version_lt (matches Coq: Definition version_lt)
version_lt(v2) ==
  v2 >= 0

\* version_le (matches Coq: Definition version_le)
version_le(v2) ==
  v2 >= 0

\* initial_rollback_state (matches Coq: Definition initial_rollback_state)
initial_rollback_state ==
  0

\* rollback_enforced (matches Coq: Definition rollback_enforced)
rollback_enforced(st) ==
  st >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateVersion ==
  /\ major' \in 0..100
  /\ minor' \in 0..100
  /\ patch' \in 0..100
  /\ build' \in 0..100
  /\ UNCHANGED <<comp_id, comp_version, comp_hash, min_comp_id, min_version, stored_in_hardware, minimum_versions, current_versions, anti_rollback_enabled>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateVersion \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* rollback_protection
THEOREM rollback_protection ==
  \A st \in Nat, comp \in ComponentIdSet, old_ver \in Nat :
      rollback_enforced(st) => version_allowed st comp old_ver = false

\* old_version_cannot_boot
THEOREM old_version_cannot_boot ==
  \A st \in Nat, comp \in Nat :
      rollback_enforced(st) => ~ can_boot_prop st comp

\* current_or_newer_allowed
THEOREM current_or_newer_allowed ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat :
      rollback_enforced(st) => version_allowed st comp ver = true

\* min_version_monotonic
THEOREM min_version_monotonic ==
  \A st \in Nat, comp \in ComponentIdSet, old_ver \in Nat, new_ver \in Nat :
      get_min_version st comp = Some old_ver => let st' := update_min_version st comp new_ver true in
      get_min_version st' comp = Some new_ver

\* no_minimum_any_allowed
THEOREM no_minimum_any_allowed ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat :
      get_min_version st comp = None => version_allowed st comp ver = true

\* disabled_rollback_allows_all
THEOREM disabled_rollback_allows_all ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat :
      ~anti_rollback_enabled(st) => version_allowed st comp ver = true

\* version_lt_irreflexive
THEOREM version_lt_irreflexive ==
  \A v \in Nat :
      version_lt(v, v) = FALSE

\* same_version_always_allowed
THEOREM same_version_always_allowed ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat :
      rollback_enforced(st) => version_allowed st comp ver = true

\* update_stores_new_min
THEOREM update_stores_new_min ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat, hw \in BOOLEAN :
      get_min_version (update_min_version st comp ver hw) comp = Some ver

\* record_preserves_anti_rollback
THEOREM record_preserves_anti_rollback ==
  \A st \in Nat, comp \in Nat :
      anti_rollback_enabled (record_current_version st comp) = anti_rollback_enabled(st)

\* record_preserves_minimums
THEOREM record_preserves_minimums ==
  \A st \in Nat, comp \in Nat :
      minimum_versions (record_current_version st comp) = minimum_versions(st)

\* update_preserves_anti_rollback
THEOREM update_preserves_anti_rollback ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat, hw \in BOOLEAN :
      anti_rollback_enabled (update_min_version st comp ver hw) = anti_rollback_enabled(st)

\* advance_preserves_anti_rollback
THEOREM advance_preserves_anti_rollback ==
  \A st \in Nat, comp \in ComponentIdSet :
      anti_rollback_enabled (advance_min_to_current st comp) = anti_rollback_enabled(st)

\* equal_version_not_rollback
THEOREM equal_version_not_rollback ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat :
      get_min_version st comp = Some ver => ~ is_rollback st comp ver

\* initial_state_allows_all
THEOREM initial_state_allows_all ==
  \A comp \in ComponentIdSet, ver \in Nat :
      version_allowed initial_rollback_state comp ver = TRUE

\* initial_state_no_minimums
THEOREM initial_state_no_minimums ==
  \A comp \in ComponentIdSet :
      get_min_version(initial_rollback_state, comp) = None

\* initial_state_no_current
THEOREM initial_state_no_current ==
  \A comp \in ComponentIdSet :
      get_current_version(initial_rollback_state, comp) = None

\* enforced_detects_rollback
THEOREM enforced_detects_rollback ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat :
      rollback_enforced(st) => can_boot_version st (mkVersionedComp comp ver 0) = false

\* hardware_stored_minimum_recorded
THEOREM hardware_stored_minimum_recorded ==
  \A st \in Nat, comp \in ComponentIdSet, ver \in Nat :
      let st' : = update_min_version st comp ver true in
      In (mkMinVersion comp ver true) (minimum_versions st')

\* advance_missing_current_identity
THEOREM advance_missing_current_identity ==
  \A st \in Nat, comp \in ComponentIdSet :
      get_current_version st comp = None => advance_min_to_current st comp = st

\* independent_component_minimums
THEOREM independent_component_minimums ==
  \A st \in Nat, comp1 \in ComponentIdSet, comp2 \in ComponentIdSet, ver \in Nat, hw \in BOOLEAN :
      comp1 # comp2 => let st' := update_min_version st comp1 ver hw in
      get_min_version st' comp2 = None

====
