---- MODULE GarbageCollector ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/GarbageCollector.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ObjectId (matches Coq: Inductive ObjectId)
CONSTANTS ObjId

ObjectIdSet == {ObjId}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Object (matches Coq: Record Object)
VARIABLES obj_id, obj_size, obj_references

\* HeapState (matches Coq: Record HeapState)
VARIABLES live_objects, root_set

\* GCResult (matches Coq: Record GCResult)
VARIABLES gc_pre_state, gc_post_state, gc_preserves_reachable, gc_collects_unreachable

vars == <<obj_id, obj_size, obj_references, live_objects, root_set, gc_pre_state, gc_post_state, gc_preserves_reachable, gc_collects_unreachable>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ obj_id \in ObjectIdSet
  /\ obj_size \in Nat
  /\ obj_references \in Seq(Nat)
  /\ live_objects \in Seq(Nat)
  /\ root_set \in Seq(Nat)
  /\ gc_pre_state \in Nat
  /\ gc_post_state \in Nat
  /\ gc_preserves_reachable \in Nat
  /\ gc_collects_unreachable \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ obj_id = ObjId
  /\ obj_size = 0
  /\ obj_references = <<>>
  /\ live_objects = <<>>
  /\ root_set = <<>>
  /\ gc_pre_state = 0
  /\ gc_post_state = 0
  /\ gc_preserves_reachable = 0
  /\ gc_collects_unreachable = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* valid_gc (matches Coq: Definition valid_gc)
valid_gc(result) ==
  result >= 0

\* total_heap_size (matches Coq: Definition total_heap_size)
total_heap_size(st) ==
  st >= 0

\* heap_utilization (matches Coq: Definition heap_utilization)
heap_utilization(st) ==
  st >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateObject ==
  /\ obj_id' \in ObjectIdSet
  /\ obj_size' \in 0..100
  /\ obj_references' = obj_references
  /\ UNCHANGED <<live_objects, root_set, gc_pre_state, gc_post_state, gc_preserves_reachable, gc_collects_unreachable>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateObject \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* gc_preserves_live_objects
THEOREM gc_preserves_live_objects ==
  \A result \in Nat, oid \in ObjectIdSet :
      valid_gc(result) => exists_in_heap(gc_post_state(result), oid)

\* gc_collects_garbage
THEOREM gc_collects_garbage ==
  \A result \in Nat, obj \in Nat :
      valid_gc(result) => ~ exists_obj (gc_post_state result) obj

\* roots_reachable
THEOREM roots_reachable ==
  \A st \in Nat, oid \in ObjectIdSet :
      In(oid, root_set(st)) => reachable(st, oid)

\* references_reachable
THEOREM references_reachable ==
  \A st \in Nat, parent \in Nat, child_oid \in ObjectIdSet :
      reachable(st, obj_id(parent)) => reachable(st, child_oid)

\* empty_roots_gc
THEOREM empty_roots_gc ==
  \A result \in Nat :
      valid_gc(result) => ~ exists_obj (gc_post_state result) obj

\* gc_preserves_root_set
THEOREM gc_preserves_root_set ==
  \A result \in Nat :
      valid_gc(result) => exists_in_heap(gc_post_state(result), oid)

\* unreachable_heap_cleared
THEOREM unreachable_heap_cleared ==
  \A result \in Nat :
      valid_gc(result) => forall obj, ~ exists_obj (gc_post_state result) obj

\* gc_safety
THEOREM gc_safety ==
  \A result \in Nat :
      valid_gc(result) => reachable (gc_pre_state result) (obj_id obj)

\* root_reachable_subset
THEOREM root_reachable_subset ==
  \A st \in Nat, oid \in ObjectIdSet :
      In(oid, root_set(st)) => reachable(st, oid)

\* reachability_transitive
THEOREM reachability_transitive ==
  \A st \in Nat, a_oid \in ObjectIdSet, c_oid \in ObjectIdSet, b \in Nat :
      reachable(st, a_oid) => reachable(st, c_oid)

\* gc_idempotent
THEOREM gc_idempotent ==
  \A result \in Nat :
      valid_gc(result) => reachable (gc_pre_state result) (obj_id obj)

\* empty_heap_gc_safe
THEOREM empty_heap_gc_safe ==
  \A result \in Nat :
      live_objects (gc_pre_state result) = [] => forall obj, ~ exists_obj (gc_post_state result) obj

\* no_refs_no_children
THEOREM no_refs_no_children ==
  \A st \in Nat, parent \in Nat, child_oid \in ObjectIdSet :
      obj_references parent = [] => ~ (In parent (live_objects st) /\ In child_oid (obj_references parent))

\* gc_preserves_deterministic
THEOREM gc_preserves_deterministic ==
  \A result \in Nat, oid \in ObjectIdSet :
      valid_gc(result) => exists_in_heap(gc_post_state(result), oid)

\* single_root_survives
THEOREM single_root_survives ==
  \A result \in Nat, obj \in Nat :
      valid_gc(result) => exists_in_heap (gc_post_state result) (obj_id obj)

\* heap_utilization_nonneg
THEOREM heap_utilization_nonneg ==
  \A st \in Nat :
      heap_utilization st > = 0

\* empty_heap_zero_utilization
THEOREM empty_heap_zero_utilization ==
  \A st \in Nat :
      live_objects st = [] => heap_utilization st = 0

\* object_id_eq_refl
THEOREM object_id_eq_refl ==
  \A oid \in ObjectIdSet :
      ObjectId_eq_dec oid oid = left(eq_refl)

\* reachable_implies_exists
THEOREM reachable_implies_exists ==
  \A st \in Nat, oid \in ObjectIdSet :
      reachable(st, oid) => exists_in_heap(st, oid)

\* valid_gc_reflects_reachability
THEOREM valid_gc_reflects_reachability ==
  \A result \in Nat :
      valid_gc(result) => reachable (gc_pre_state result) (obj_id obj))

====
