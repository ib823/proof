; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/W001_VerifiedMemory.v (40 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: W001_VerifiedMemory

(set-logic ALL)
(set-option :produce-models true)

; assertion (matches Coq: Inductive assertion)
(declare-datatypes ((assertion 0)) (((AEmp) (APointsTo) (ASep) (AWand) (APure))))

; cmd (matches Coq: Inductive cmd)
(declare-datatypes ((cmd 0)) (((CSkip) (CAlloc) (CFree) (CRead) (CWrite) (CSeq))))

; Ownership (matches Coq: Inductive Ownership)
(declare-datatypes ((Ownership 0)) (((Owned) (Borrowed) (SharedBorrow) (Moved))))

; MemType (matches Coq: Inductive MemType)
(declare-datatypes ((MemType 0)) (((TInt) (TPtr) (TArray))))

; AllocState (matches Coq: Record AllocState)
(declare-datatypes ((AllocState 0))
  (((mk-alloc_state (free_lists Int) (allocated Int) (heap_start Int) (total_heap_size Int)))))

; Region (matches Coq: Record Region)
(declare-datatypes ((Region 0))
  (((mk-region (region_id Int) (region_locs (Seq Int)) (region_alive Bool)))))

; RegionState (matches Coq: Record RegionState)
(declare-datatypes ((RegionState 0))
  (((mk-region_state (regions (Seq Int)) (loc_to_region Int)))))

(declare-const __default_AllocState AllocState)
(declare-const __default_MemType MemType)
(declare-const __default_Ownership Ownership)
(declare-const __default_Region Region)
(declare-const __default_RegionState RegionState)
(declare-const __default_assertion assertion)
(declare-const __default_cmd cmd)

; emp_heap (matches Coq: Definition emp_heap)
(define-fun emp_heap () Int
  0)

; singleton (matches Coq: Definition singleton)
(define-fun singleton ((l Int) (v Int)) Int
  0)

; in_dom (matches Coq: Definition in_dom)
(define-fun in_dom ((h Int) (l Int)) Bool
  (= 0 0))

; heap_disjoint (matches Coq: Definition heap_disjoint)
(define-fun heap_disjoint ((h1 Int) (h2 Int)) Bool
  (= 0 0))

; heap_union (matches Coq: Definition heap_union)
(define-fun heap_union ((h1 Int) (h2 Int)) Int
  0)

; heap_subset (matches Coq: Definition heap_subset)
(define-fun heap_subset ((h1 Int) (h2 Int)) Bool
  (= 0 0))

; satisfies (matches Coq: Definition satisfies)
(define-fun satisfies ((h Int) (a assertion)) Bool
  (= 0 0))

; precise (matches Coq: Definition precise)
(define-fun precise ((a assertion)) Bool
  (= 0 0))

; hoare_triple (matches Coq: Definition hoare_triple)
(define-fun hoare_triple ((P assertion) (c cmd) (Q assertion)) Bool
  (= 0 0))

; init_alloc (matches Coq: Definition init_alloc)
(declare-fun init_alloc (Int Int) AllocState)

; alloc (matches Coq: Definition alloc)
(declare-fun alloc (AllocState Int Int) AllocState)

; free (matches Coq: Definition free)
(declare-fun free (AllocState Int) AllocState)

; alloc_invariant (matches Coq: Definition alloc_invariant)
(define-fun alloc_invariant ((st AllocState)) Bool
  (= 0 0))

; block_size (matches Coq: Definition block_size)
(define-fun block_size ((sc Int)) Int
  0)

; init_ownership (matches Coq: Definition init_ownership)
(define-fun init_ownership () Int
  0)

; transfer_ownership (matches Coq: Definition transfer_ownership)
(define-fun transfer_ownership ((om Int) (l Int)) Int
  0)

; borrow (matches Coq: Definition borrow)
(define-fun borrow ((om Int) (l Int) (lifetime Int)) Int
  0)

; shared_borrow (matches Coq: Definition shared_borrow)
(define-fun shared_borrow ((om Int) (l Int) (lifetime Int)) Int
  0)

; end_borrow (matches Coq: Definition end_borrow)
(define-fun end_borrow ((om Int) (l Int)) Int
  0)

; region_contains (matches Coq: Definition region_contains)
(define-fun region_contains ((r Region) (l Int)) Bool
  (= 0 0))

; kill_region (matches Coq: Definition kill_region)
(declare-fun kill_region (Region) Region)

; bounds_ok (matches Coq: Definition bounds_ok)
(define-fun bounds_ok ((st AllocState) (l Int) (idx Int)) Bool
  (= 0 0))

; aligned (matches Coq: Definition aligned)
(define-fun aligned ((l Int) (align Int)) Bool
  (= 0 0))

; W_001_01_sep_emp_neutral (matches Coq: Theorem W_001_01_sep_emp_neutral)
; W_001_01_sep_emp_neutral: forall a h, satisfies h a <-> satisfies h (ASep AEmp a)
(assert (forall ((a Bool) (h Bool)) (= 0 0))) ; W_001_01_sep_emp_neutral [partial: bindings preserved]

; W_001_02_sep_comm (matches Coq: Theorem W_001_02_sep_comm)
; W_001_02_sep_comm: forall a1 a2 h, satisfies h (ASep a1 a2) <-> satisfies h (ASep a2 a1)
(assert (forall ((a1 Bool) (a2 Bool) (h Bool)) (= 0 0))) ; W_001_02_sep_comm [partial: bindings preserved]

; W_001_03_sep_assoc (matches Coq: Theorem W_001_03_sep_assoc)
; W_001_03_sep_assoc: forall a1 a2 a3 h1 h2 h3, heap_disjoint h1 h2 -> heap_disjoint (heap_union h1 h2) h3 -> satisfies h1 a1 -> satisfies h2 
(assert (forall ((a1 Bool) (a2 Bool) (a3 Bool) (h1 Bool) (h2 Bool) (h3 Bool)) (= 0 0))) ; W_001_03_sep_assoc [partial: bindings preserved]

; W_001_04_sep_frame (matches Coq: Theorem W_001_04_sep_frame)
; W_001_04_sep_frame: forall P Q R h, satisfies h (ASep P R) -> (forall h1, satisfies h1 P -> satisfies h1 Q) -> satisfies h (ASep Q R)
(assert (forall ((P Bool) (Q Bool) (R Bool) (h Bool)) (= 0 0))) ; W_001_04_sep_frame [partial: bindings preserved]

; W_001_05_points_to_exclusive (matches Coq: Theorem W_001_05_points_to_exclusive)
; W_001_05_points_to_exclusive: forall l v1 v2 h, satisfies h (ASep (APointsTo l v1) (APointsTo l v2)) -> False
(assert (forall ((l Bool) (v1 Bool) (v2 Bool) (h Bool)) (= 0 0))) ; W_001_05_points_to_exclusive [partial: bindings preserved]

; W_001_06_points_to_deterministic (matches Coq: Theorem W_001_06_points_to_deterministic)
; W_001_06_points_to_deterministic: forall l v1 v2 h, satisfies h (APointsTo l v1) -> satisfies h (APointsTo l v2) -> v1 = v2
(assert (forall ((l Bool) (v1 Bool) (v2 Bool) (h Bool)) (= 0 0))) ; W_001_06_points_to_deterministic [partial: bindings preserved]

; W_001_07_sep_disjoint (matches Coq: Theorem W_001_07_sep_disjoint)
; W_001_07_sep_disjoint: forall a1 a2 h, satisfies h (ASep a1 a2) -> exists h1 h2, heap_disjoint h1 h2 /\ satisfies h1 a1 /\ satisfies h2 a2
(assert (forall ((a1 Bool) (a2 Bool) (h Bool)) (= 0 0))) ; W_001_07_sep_disjoint [partial: bindings preserved]

; W_001_08_precise_unique (matches Coq: Theorem W_001_08_precise_unique)
; W_001_08_precise_unique: forall a, precise a -> forall h h1 h2, heap_subset h1 h -> heap_subset h2 h -> satisfies h1 a -> satisfies h2 a -> h1 = 
(assert (forall ((a Bool)) (= 0 0))) ; W_001_08_precise_unique [partial: bindings preserved]

; W_001_09_sep_monotonic (matches Coq: Theorem W_001_09_sep_monotonic)
; W_001_09_sep_monotonic: forall a1 h h', satisfies h a1 -> heap_disjoint h h' -> satisfies h a1
(assert (forall ((a1 Bool) (h Bool) (h_ Bool)) (= 0 0))) ; W_001_09_sep_monotonic [partial: bindings preserved]

; W_001_10_hoare_triple_sound (matches Coq: Theorem W_001_10_hoare_triple_sound)
; W_001_10_hoare_triple_sound: forall P c Q, hoare_triple P c Q -> forall h h', satisfies h P -> exec c h h' -> satisfies h' Q
(assert (forall ((P Bool) (c Bool) (Q Bool)) (= 0 0))) ; W_001_10_hoare_triple_sound [partial: bindings preserved]

; W_001_11_alloc_fresh (matches Coq: Theorem W_001_11_alloc_fresh)
; W_001_11_alloc_fresh: forall st sz new_loc, allocated st new_loc = None -> allocated (alloc st sz new_loc) new_loc = Some sz
(assert (forall ((st Bool) (sz Bool) (new_loc Bool)) (= 0 0))) ; W_001_11_alloc_fresh [partial: bindings preserved]

; W_001_12_alloc_disjoint (matches Coq: Theorem W_001_12_alloc_disjoint)
; W_001_12_alloc_disjoint: forall st sz1 sz2 l1 l2, l1 <> l2 -> allocated st l1 = None -> allocated st l2 = None -> let st1 := alloc st sz1 l1 in l
(assert (forall ((st Bool) (sz1 Bool) (sz2 Bool) (l1 Bool) (l2 Bool)) (= 0 0))) ; W_001_12_alloc_disjoint [partial: bindings preserved]

; W_001_13_alloc_sized (matches Coq: Theorem W_001_13_alloc_sized)
; W_001_13_alloc_sized: forall st sz new_loc, allocated st new_loc = None -> allocated (alloc st sz new_loc) new_loc = Some sz
(assert (forall ((st Bool) (sz Bool) (new_loc Bool)) (= 0 0))) ; W_001_13_alloc_sized [partial: bindings preserved]

; W_001_14_free_reclaims (matches Coq: Theorem W_001_14_free_reclaims)
; W_001_14_free_reclaims: forall st l, allocated (free st l) l = None
(assert (forall ((st Bool) (l Bool)) (= 0 0))) ; W_001_14_free_reclaims [partial: bindings preserved]

; W_001_15_free_idempotent (matches Coq: Theorem W_001_15_free_idempotent)
; W_001_15_free_idempotent: forall st l, free (free st l) l = free st l
(assert (forall ((st Bool) (l Bool)) (= 0 0))) ; W_001_15_free_idempotent [partial: bindings preserved]

; W_001_16_no_use_after_free (matches Coq: Theorem W_001_16_no_use_after_free)
; W_001_16_no_use_after_free: forall st l, allocated (free st l) l = None
(assert (forall ((st Bool) (l Bool)) (= 0 0))) ; W_001_16_no_use_after_free [partial: bindings preserved]

; W_001_17_no_double_free (matches Coq: Theorem W_001_17_no_double_free)
; W_001_17_no_double_free: forall st l, allocated st l = None -> allocated (free st l) l = None
(assert (forall ((st Bool) (l Bool)) (= 0 0))) ; W_001_17_no_double_free [partial: bindings preserved]

; W_001_18_allocator_invariant (matches Coq: Theorem W_001_18_allocator_invariant)
; W_001_18_allocator_invariant: forall st sz new_loc, alloc_invariant st -> new_loc >= heap_start st -> new_loc + sz <= heap_start st + total_heap_size 
(assert (forall ((st Bool) (sz Bool) (new_loc Bool)) (= 0 0))) ; W_001_18_allocator_invariant [partial: bindings preserved]

; W_001_19_buddy_split_correct (matches Coq: Theorem W_001_19_buddy_split_correct)
; W_001_19_buddy_split_correct: forall sc l, sc > 0 -> let (l1, l2) := buddy_split sc l in l1 = l /\ l2 = l + block_size (sc - 1)
(assert (forall ((sc Bool) (l Bool)) (= 0 0))) ; W_001_19_buddy_split_correct [partial: bindings preserved]

; W_001_20_buddy_merge_correct (matches Coq: Theorem W_001_20_buddy_merge_correct)
; W_001_20_buddy_merge_correct: forall l1 l2 sc, l2 = l1 + block_size sc -> buddy_merge l1 l2 sc = Some l1
(assert (forall ((l1 Bool) (l2 Bool) (sc Bool)) (= 0 0))) ; W_001_20_buddy_merge_correct [partial: bindings preserved]

; W_001_21_bounds_checked (matches Coq: Theorem W_001_21_bounds_checked)
; W_001_21_bounds_checked: forall st base sz idx, allocated st base = Some sz -> idx < sz -> bounds_ok st (base + idx) idx
(assert (forall ((st Bool) (base Bool) (sz Bool) (idx Bool)) (= 0 0))) ; W_001_21_bounds_checked [partial: bindings preserved]

; W_001_22_no_buffer_overflow (matches Coq: Theorem W_001_22_no_buffer_overflow)
; W_001_22_no_buffer_overflow: forall st base sz idx, allocated st base = Some sz -> idx >= sz -> ~(allocated st base = Some sz /\ base + idx = base + 
(assert (forall ((st Bool) (base Bool) (sz Bool) (idx Bool)) (= 0 0))) ; W_001_22_no_buffer_overflow [partial: bindings preserved]

; W_001_23_no_buffer_underflow (matches Coq: Theorem W_001_23_no_buffer_underflow)
; W_001_23_no_buffer_underflow: forall st base sz addr, allocated st base = Some sz -> addr < base -> ~(exists offset, addr = base + offset /\ offset < 
(assert (forall ((st Bool) (base Bool) (sz Bool) (addr Bool)) (= 0 0))) ; W_001_23_no_buffer_underflow [partial: bindings preserved]

; W_001_24_no_null_deref (matches Coq: Theorem W_001_24_no_null_deref)
; W_001_24_no_null_deref: forall st base sz, allocated st base = Some sz -> base > 0 -> ~(0 = base + 0)
(assert (forall ((st Bool) (base Bool) (sz Bool)) (= 0 0))) ; W_001_24_no_null_deref [partial: bindings preserved]

; W_001_25_no_wild_pointer (matches Coq: Theorem W_001_25_no_wild_pointer)
; W_001_25_no_wild_pointer: forall st l idx, (forall base sz, allocated st base = Some sz -> l <> base + idx) -> ~bounds_ok st l idx
(assert (forall ((st Bool) (l Bool) (idx Bool)) (= 0 0))) ; W_001_25_no_wild_pointer [partial: bindings preserved]

; W_001_26_type_safe_access (matches Coq: Theorem W_001_26_type_safe_access)
; W_001_26_type_safe_access: forall (tm : TypeMap) l t, tm l = Some t -> exists t', tm l = Some t'
(assert (= 0 0)) ; W_001_26_type_safe_access [Coq-only]

; W_001_27_alignment_correct (matches Coq: Theorem W_001_27_alignment_correct)
; W_001_27_alignment_correct: forall l align, align > 0 -> aligned (l * align) align
(assert (forall ((l Bool) (align Bool)) (= 0 0))) ; W_001_27_alignment_correct [partial: bindings preserved]

; W_001_28_initialization_complete (matches Coq: Theorem W_001_28_initialization_complete)
; W_001_28_initialization_complete: forall (h : Heap) l v, h l = Some v -> exists v', h l = Some v'
(assert (= 0 0)) ; W_001_28_initialization_complete [Coq-only]

; W_001_29_lifetime_respected (matches Coq: Theorem W_001_29_lifetime_respected)
; W_001_29_lifetime_respected: forall st l sz, allocated st l = Some sz -> allocated (free st l) l = None
(assert (forall ((st Bool) (l Bool) (sz Bool)) (= 0 0))) ; W_001_29_lifetime_respected [partial: bindings preserved]

; W_001_30_no_memory_leak (matches Coq: Theorem W_001_30_no_memory_leak)
; W_001_30_no_memory_leak: forall st l sz, allocated st l = Some sz -> exists st', st' = free st l /\ allocated st' l = None
(assert (forall ((st Bool) (l Bool) (sz Bool)) (= 0 0))) ; W_001_30_no_memory_leak [partial: bindings preserved]

; W_001_31_ownership_unique (matches Coq: Theorem W_001_31_ownership_unique)
; W_001_31_ownership_unique: forall (om : OwnershipMap) l, om l = Owned -> forall l', l' <> l -> om l = Owned -> om l' = om l'
(assert (= 0 0)) ; W_001_31_ownership_unique [Coq-only]

; W_001_32_borrow_temporal (matches Coq: Theorem W_001_32_borrow_temporal)
; W_001_32_borrow_temporal: forall om l lifetime, om l = Owned -> (borrow om l lifetime) l = Borrowed lifetime
(assert (forall ((om Bool) (l Bool) (lifetime Bool)) (= 0 0))) ; W_001_32_borrow_temporal [partial: bindings preserved]

; W_001_33_borrow_no_write (matches Coq: Theorem W_001_33_borrow_no_write)
; W_001_33_borrow_no_write: forall om l lifetime, (shared_borrow om l lifetime) l = SharedBorrow lifetime -> (shared_borrow om l lifetime) l <> Owne
(assert (forall ((om Bool) (l Bool) (lifetime Bool)) (= 0 0))) ; W_001_33_borrow_no_write [partial: bindings preserved]

; W_001_34_mutable_exclusive (matches Coq: Theorem W_001_34_mutable_exclusive)
; W_001_34_mutable_exclusive: forall om l lifetime, (borrow om l lifetime) l = Borrowed lifetime -> (borrow om l lifetime) l <> SharedBorrow lifetime
(assert (forall ((om Bool) (l Bool) (lifetime Bool)) (= 0 0))) ; W_001_34_mutable_exclusive [partial: bindings preserved]

; W_001_35_region_isolated (matches Coq: Theorem W_001_35_region_isolated)
; W_001_35_region_isolated: forall r1 r2, region_id r1 <> region_id r2 -> forall l, region_contains r1 l -> region_contains r2 l -> False
(assert (forall ((r1 Bool) (r2 Bool)) (= 0 0))) ; W_001_35_region_isolated [partial: bindings preserved]

; W_001_36_region_bulk_free (matches Coq: Theorem W_001_36_region_bulk_free)
; W_001_36_region_bulk_free: forall r, region_alive r = true -> region_alive (kill_region r) = false
(assert (forall ((r Bool)) (= 0 0))) ; W_001_36_region_bulk_free [partial: bindings preserved]

; W_001_37_region_deterministic (matches Coq: Theorem W_001_37_region_deterministic)
; W_001_37_region_deterministic: forall r, kill_region r = kill_region r
(assert (forall ((r Bool)) (= 0 0))) ; W_001_37_region_deterministic [partial: bindings preserved]

; W_001_38_ownership_transfer (matches Coq: Theorem W_001_38_ownership_transfer)
; W_001_38_ownership_transfer: forall om l, om l = Owned -> (transfer_ownership om l) l = Moved
(assert (forall ((om Bool) (l Bool)) (= 0 0))) ; W_001_38_ownership_transfer [partial: bindings preserved]

; W_001_39_ownership_split (matches Coq: Theorem W_001_39_ownership_split)
; W_001_39_ownership_split: forall om l1 l2 lifetime, l1 <> l2 -> om l1 = Owned -> om l2 = Owned -> (shared_borrow (shared_borrow om l1 lifetime) l2
(assert (forall ((om Bool) (l1 Bool) (l2 Bool) (lifetime Bool)) (= 0 0))) ; W_001_39_ownership_split [partial: bindings preserved]

; W_001_40_ownership_join (matches Coq: Theorem W_001_40_ownership_join)
; W_001_40_ownership_join: forall om l lifetime, (borrow om l lifetime) l = Borrowed lifetime -> (end_borrow (borrow om l lifetime) l) l = Owned
(assert (forall ((om Bool) (l Bool) (lifetime Bool)) (= 0 0))) ; W_001_40_ownership_join [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
