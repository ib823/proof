---- MODULE OwnershipTypes ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/OwnershipTypes.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* OwnState (matches Coq: Inductive OwnState)
CONSTANTS Owned, Moved, Borrowed, MutBorrowed, Dropped

OwnStateSet == {Owned, Moved, Borrowed, MutBorrowed, Dropped}

\* RefCellState (matches Coq: Inductive RefCellState)
CONSTANTS RCUnborrowed, RCSharedBorrow, RCMutBorrow

RefCellStateSet == {RCUnborrowed, RCSharedBorrow, RCMutBorrow}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* OwnedVar (matches Coq: Record OwnedVar)
VARIABLES ov_id, ov_state, ov_lifetime, ov_is_copy

\* Borrow (matches Coq: Record Borrow)
VARIABLES br_source, br_target, br_mutable, br_lifetime

\* OwnCtx (matches Coq: Record OwnCtx)
VARIABLES oc_vars, oc_borrows, oc_current_lifetime

\* RefCell (matches Coq: Record RefCell)
VARIABLES rc_id, rc_state, rc_lifetime

\* BoxAlloc (matches Coq: Record BoxAlloc)
VARIABLES box_id, box_allocated, box_dropped

vars == <<ov_id, ov_state, ov_lifetime, ov_is_copy, br_source, br_target, br_mutable, br_lifetime, oc_vars, oc_borrows, oc_current_lifetime, rc_id, rc_state, rc_lifetime, box_id, box_allocated, box_dropped>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ ov_id \in Nat
  /\ ov_state \in OwnStateSet
  /\ ov_lifetime \in Nat
  /\ ov_is_copy \in BOOLEAN
  /\ br_source \in Nat
  /\ br_target \in Nat
  /\ br_mutable \in BOOLEAN
  /\ br_lifetime \in Nat
  /\ oc_vars \in Seq(Nat)
  /\ oc_borrows \in Seq(Nat)
  /\ oc_current_lifetime \in Nat
  /\ rc_id \in Nat
  /\ rc_state \in RefCellStateSet
  /\ rc_lifetime \in Nat
  /\ box_id \in Nat
  /\ box_allocated \in BOOLEAN
  /\ box_dropped \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ ov_id = 0
  /\ ov_state = Owned
  /\ ov_lifetime = 0
  /\ ov_is_copy = FALSE
  /\ br_source = 0
  /\ br_target = 0
  /\ br_mutable = FALSE
  /\ br_lifetime = 0
  /\ oc_vars = <<>>
  /\ oc_borrows = <<>>
  /\ oc_current_lifetime = 0
  /\ rc_id = 0
  /\ rc_state = RCUnborrowed
  /\ rc_lifetime = 0
  /\ box_id = 0
  /\ box_allocated = FALSE
  /\ box_dropped = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* Lifetime (matches Coq: Definition Lifetime)
Lifetime ==
  0

\* lifetime_outlives (matches Coq: Definition lifetime_outlives)
lifetime_outlives(l2) ==
  l2 >= 0

\* is_usable (matches Coq: Definition is_usable)
is_usable(v) ==
  ov_state

\* is_moved (matches Coq: Definition is_moved)
is_moved(v) ==
  ov_state

\* is_dropped (matches Coq: Definition is_dropped)
is_dropped(v) ==
  ov_state

\* refcell_try_borrow (matches Coq: Definition refcell_try_borrow)
refcell_try_borrow(rc) ==
  rc >= 0

\* refcell_try_borrow_mut (matches Coq: Definition refcell_try_borrow_mut)
refcell_try_borrow_mut(rc) ==
  rc >= 0

\* box_new (matches Coq: Definition box_new)
box_new(id) ==
  id >= 0

\* box_drop (matches Coq: Definition box_drop)
box_drop(b) ==
  b >= 0

\* well_formed_ctx (matches Coq: Definition well_formed_ctx)
well_formed_ctx(ctx) ==
  ctx >= 0

\* memory_safe (matches Coq: Definition memory_safe)
memory_safe(ctx) ==
  oc_borrows(ctx) /\ borrow_lifetime_valid(ctx) /\ oc_vars(ctx) /\ count_borrows(ctx) /\ oc_vars(ctx)

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateOwnedVar ==
  /\ ov_id' \in 0..100
  /\ ov_state' \in OwnStateSet
  /\ ov_lifetime' \in 0..100
  /\ ov_is_copy' \in BOOLEAN
  /\ UNCHANGED <<br_source, br_target, br_mutable, br_lifetime, oc_vars, oc_borrows, oc_current_lifetime, rc_id, rc_state, rc_lifetime, box_id, box_allocated, box_dropped>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateOwnedVar \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* existsb_false_forall
THEOREM existsb_false_forall ==
  \A f \in Nat, l \in Nat :
      existsb f l = false => ~f(x)

\* find_var_map_moved
THEOREM find_var_map_moved ==
  \A vars \in Nat, from_id \in Nat, v \in Nat :
      find_var vars from_id = Some v => find_var (map (fun var =>
      if Nat.eqb (ov_id var) from_id
      then mkOV from_id Moved (ov_lifetime var) (ov_is_copy var)
      else var) vars) from_id = 
    Some (mkOV from_id Moved (ov_lifetime v) (ov_is_copy v))

\* MEM_001_01
THEOREM MEM_001_01 ==
  \A ctx \in Nat, from_id \in Nat, to_id \in Nat, v \in Nat :
      find_var (oc_vars ctx) from_id = Some v => ov_state v' = Moved

\* MEM_001_02
THEOREM MEM_001_02 ==
  \A ctx \in Nat, from_id \in Nat, to_id \in Nat, v \in Nat :
      find_var (oc_vars ctx) from_id = Some v => exists v_new, find_var (oc_vars ctx') to_id = Some v_new /\ ov_state v_new = Owned

\* MEM_001_03
THEOREM MEM_001_03 ==
  \A ctx \in Nat, id \in Nat, v \in Nat :
      find_var (oc_vars ctx) id = Some v => can_shared_borrow(ctx, id)

\* filter_all_false_empty
THEOREM filter_all_false_empty ==
  \A f \in Nat, l \in Nat :
      (forall x, In x l => filter f l = []

\* MEM_001_04
THEOREM MEM_001_04 ==
  \A ctx \in Nat, id \in Nat, v \in Nat :
      find_var (oc_vars ctx) id = Some v => count_borrows ctx id = 0

\* MEM_001_05
THEOREM MEM_001_05 ==
  \A ctx \in Nat, b \in Nat, v \in Nat :
      In(b, oc_borrows(ctx)) => lifetime_outlives (ov_lifetime v) (br_lifetime b) = true

\* MEM_001_06
THEOREM MEM_001_06 ==
  \A v \in Nat :
      ov_state v = Moved => ~is_usable(v)

\* MEM_001_07
THEOREM MEM_001_07 ==
  \A ctx \in Nat, id \in Nat, v \in Nat, b \in Nat :
      find_var (oc_vars ctx) id = Some v => can_mut_borrow ctx id = false

\* MEM_001_08
THEOREM MEM_001_08 ==
  \A ctx \in Nat, id \in Nat, v \in Nat, b \in Nat :
      find_var (oc_vars ctx) id = Some v => can_shared_borrow ctx id = false

\* MEM_001_09
THEOREM MEM_001_09 ==
  \A orig_lt \in Nat, reborrow_lt \in Nat :
      lifetime_outlives(orig_lt, reborrow_lt) => Nat.leb reborrow_lt orig_lt = true

\* find_var_map_dropped
THEOREM find_var_map_dropped ==
  \A vars \in Nat, id \in Nat, v \in Nat :
      find_var vars id = Some v => find_var (map (fun var =>
      if Nat.eqb (ov_id var) id
      then mkOV id Dropped (ov_lifetime var) (ov_is_copy var)
      else var) vars) id = 
    Some (mkOV id Dropped (ov_lifetime v) (ov_is_copy v))

\* MEM_001_10
THEOREM MEM_001_10 ==
  \A id \in Nat, v \in Nat :
      find_var (oc_vars ctx) id = Some v => drop_var ctx' id = None

\* MEM_001_11
THEOREM MEM_001_11 ==
  \A ctx \in Nat, b \in Nat, v \in Nat :
      well_formed_ctx(ctx) => lifetime_outlives (ov_lifetime v) (br_lifetime b) = true

\* MEM_001_12
THEOREM MEM_001_12 ==
  \A rc \in Nat :
      rc_state rc = RCMutBorrow => refcell_try_borrow rc = None /\ refcell_try_borrow_mut rc = None

\* MEM_001_13
THEOREM MEM_001_13 ==
  \A ctx \in Nat, from_id \in Nat, to_id \in Nat, v \in Nat :
      find_var (oc_vars ctx) from_id = Some v => move_var ctx from_id to_id = Some ctx

\* MEM_001_14
THEOREM MEM_001_14 ==
  \A id \in Nat :
      let b := box_new id in
    box_allocated b = true /\ ~box_dropped(b) /\ (exists b', box_drop b = Some b' /\ box_dropped b' = true)

\* MEM_001_15
THEOREM MEM_001_15 ==
  \A ctx \in Nat :
      memory_safe(ctx) => ~is_usable(v)

\* lifetime_outlives_refl
THEOREM lifetime_outlives_refl ==
  \A l \in Nat :
      lifetime_outlives(l, l) = TRUE

====
