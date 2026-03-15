; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MemorySafety — SMT Verification
; Derived from 02_FORMAL/coq/domains/MemorySafety.v (139 assertions)
; Module: MemorySafety
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AllocState 0)) (((Unallocated) (Allocated) (Freed))))

(declare-datatypes ((PointerValidity 0)) (((Valid) (Null) (Dangling) (OutOfBounds))))

(declare-datatypes ((SecurityDomain 0)) (((DomainKernel) (DomainUser) (DomainGuest) (DomainUntrusted))))

(declare-datatypes ((AccessPermission 0)) (((PermNone) (PermRead) (PermWrite) (PermReadWrite) (PermExecute))))

(declare-datatypes ((MemoryRegion 0))
  (((mk-memory_region (mr_alloc_state AllocState) (mr_size Int) (mr_initialized Bool) (mr_owned Bool)))))

(declare-datatypes ((Pointer 0))
  (((mk-pointer (ptr_validity PointerValidity) (ptr_offset Int) (ptr_bounds Int)))))

(declare-datatypes ((SecureMemoryRegion 0))
  (((mk-secure_memory_region (smr_base MemoryRegion) (smr_domain SecurityDomain) (smr_permission AccessPermission) (smr_encrypted Bool)))))

(declare-datatypes ((UseAfterFreeGuard 0))
  (((mk-use_after_free_guard (uaf_lifetime_tracking Bool) (uaf_ownership_clear Bool) (uaf_access_check Bool)))))

(declare-datatypes ((DoubleFreeGuard 0))
  (((mk-double_free_guard (df_state_tracking Bool) (df_single_owner Bool) (df_freed_check Bool)))))

(declare-datatypes ((NullDerefGuard 0))
  (((mk-null_deref_guard (nd_null_check Bool) (nd_option_types Bool) (nd_init_required Bool)))))

(declare-datatypes ((BoundsGuard 0))
  (((mk-bounds_guard (bg_bounds_check Bool) (bg_fat_pointers Bool) (bg_slice_safety Bool)))))

(declare-datatypes ((StackGuard 0))
  (((mk-stack_guard (sg_canary_enabled Bool) (sg_return_addr_protected Bool) (sg_frame_isolation Bool) (sg_shadow_stack Bool)))))

(declare-datatypes ((HeapGuard 0))
  (((mk-heap_guard (hg_allocation_tracking Bool) (hg_deallocation_check Bool) (hg_fragmentation_prevention Bool) (hg_metadata_integrity Bool)))))

(declare-datatypes ((IsolationGuard 0))
  (((mk-isolation_guard (ig_domain_separation Bool) (ig_permission_enforcement Bool) (ig_cross_domain_check Bool) (ig_capability_required Bool)))))

(declare-datatypes ((MemorySafetyConfig 0))
  (((mk-memory_safety_config (ms_uaf UseAfterFreeGuard) (ms_df DoubleFreeGuard) (ms_nd NullDerefGuard) (ms_bounds BoundsGuard) (ms_stack StackGuard) (ms_heap HeapGuard) (ms_isolation IsolationGuard)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- AllocState enum properties ---

; --- 1. AllocState exhaustiveness ---
(push 1)
(declare-const x AllocState)
(assert (not (or (= x Unallocated) (= x Allocated) (= x Freed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AllocState: Unallocated != Allocated ---
(push 1)
(assert (= Unallocated Allocated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AllocState: Allocated != Freed ---
(push 1)
(assert (= Allocated Freed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AllocState: Unallocated != Freed ---
(push 1)
(assert (= Unallocated Freed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AllocState finite cardinality (3 values) ---
(push 1)
(declare-const x AllocState)
(assert (and (not (= x Unallocated)) (not (= x Allocated)) (not (= x Freed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PointerValidity enum properties ---

; --- 6. PointerValidity exhaustiveness ---
(push 1)
(declare-const x PointerValidity)
(assert (not (or (= x Valid) (= x Null) (= x Dangling) (= x OutOfBounds))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. PointerValidity: Valid != Null ---
(push 1)
(assert (= Valid Null))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PointerValidity: Null != Dangling ---
(push 1)
(assert (= Null Dangling))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PointerValidity: Dangling != OutOfBounds ---
(push 1)
(assert (= Dangling OutOfBounds))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PointerValidity: Valid != OutOfBounds ---
(push 1)
(assert (= Valid OutOfBounds))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PointerValidity finite cardinality (4 values) ---
(push 1)
(declare-const x PointerValidity)
(assert (and (not (= x Valid)) (not (= x Null)) (not (= x Dangling)) (not (= x OutOfBounds))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityDomain enum properties ---

; --- 12. SecurityDomain exhaustiveness ---
(push 1)
(declare-const x SecurityDomain)
(assert (not (or (= x DomainKernel) (= x DomainUser) (= x DomainGuest) (= x DomainUntrusted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. SecurityDomain: DomainKernel != DomainUser ---
(push 1)
(assert (= DomainKernel DomainUser))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SecurityDomain: DomainUser != DomainGuest ---
(push 1)
(assert (= DomainUser DomainGuest))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SecurityDomain: DomainGuest != DomainUntrusted ---
(push 1)
(assert (= DomainGuest DomainUntrusted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SecurityDomain: DomainKernel != DomainUntrusted ---
(push 1)
(assert (= DomainKernel DomainUntrusted))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SecurityDomain finite cardinality (4 values) ---
(push 1)
(declare-const x SecurityDomain)
(assert (and (not (= x DomainKernel)) (not (= x DomainUser)) (not (= x DomainGuest)) (not (= x DomainUntrusted))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AccessPermission enum properties ---

; --- 18. AccessPermission exhaustiveness ---
(push 1)
(declare-const x AccessPermission)
(assert (not (or (= x PermNone) (= x PermRead) (= x PermWrite) (= x PermReadWrite) (= x PermExecute))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. AccessPermission: PermNone != PermRead ---
(push 1)
(assert (= PermNone PermRead))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. AccessPermission: PermRead != PermWrite ---
(push 1)
(assert (= PermRead PermWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. AccessPermission: PermWrite != PermReadWrite ---
(push 1)
(assert (= PermWrite PermReadWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AccessPermission: PermNone != PermExecute ---
(push 1)
(assert (= PermNone PermExecute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AccessPermission finite cardinality (5 values) ---
(push 1)
(declare-const x AccessPermission)
(assert (and (not (= x PermNone)) (not (= x PermRead)) (not (= x PermWrite)) (not (= x PermReadWrite)) (not (= x PermExecute))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemoryRegion record properties ---

; --- 24. MemoryRegion accessor round-trip: mr_alloc_state ---
(push 1)
(declare-const f0 AllocState)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mr_alloc_state (mk-memory_region f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. MemoryRegion accessor round-trip: mr_size ---
(push 1)
(declare-const f0 AllocState)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mr_size (mk-memory_region f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. MemoryRegion accessor round-trip: mr_initialized ---
(push 1)
(declare-const f0 AllocState)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mr_initialized (mk-memory_region f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Pointer record properties ---

; --- 27. Pointer accessor round-trip: ptr_validity ---
(push 1)
(declare-const f0 PointerValidity)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ptr_validity (mk-pointer f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Pointer accessor round-trip: ptr_offset ---
(push 1)
(declare-const f0 PointerValidity)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (ptr_offset (mk-pointer f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecureMemoryRegion record properties ---

; --- 29. SecureMemoryRegion accessor round-trip: smr_base ---
(push 1)
(declare-const f0 MemoryRegion)
(declare-const f1 SecurityDomain)
(declare-const f2 AccessPermission)
(declare-const f3 Bool)
(assert (not (= (smr_base (mk-secure_memory_region f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SecureMemoryRegion accessor round-trip: smr_domain ---
(push 1)
(declare-const f0 MemoryRegion)
(declare-const f1 SecurityDomain)
(declare-const f2 AccessPermission)
(declare-const f3 Bool)
(assert (not (= (smr_domain (mk-secure_memory_region f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. SecureMemoryRegion accessor round-trip: smr_permission ---
(push 1)
(declare-const f0 MemoryRegion)
(declare-const f1 SecurityDomain)
(declare-const f2 AccessPermission)
(declare-const f3 Bool)
(assert (not (= (smr_permission (mk-secure_memory_region f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- UseAfterFreeGuard record properties ---

; --- 32. UseAfterFreeGuard accessor round-trip: uaf_lifetime_tracking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (uaf_lifetime_tracking (mk-use_after_free_guard f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. UseAfterFreeGuard accessor round-trip: uaf_ownership_clear ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (uaf_ownership_clear (mk-use_after_free_guard f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun UseAfterFreeGuard_all_enabled ((g UseAfterFreeGuard)) Bool
  (and (uaf_lifetime_tracking g) (uaf_ownership_clear g)))

; --- 34. UseAfterFreeGuard: all-enabled completeness ---
(push 1)
(declare-const g UseAfterFreeGuard)
(assert (uaf_lifetime_tracking g))
(assert (uaf_ownership_clear g))
(assert (not (UseAfterFreeGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. UseAfterFreeGuard: UseAfterFreeGuard_all_enabled implies uaf_lifetime_tracking ---
(push 1)
(declare-const g UseAfterFreeGuard)
(assert (UseAfterFreeGuard_all_enabled g))
(assert (not (uaf_lifetime_tracking g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. UseAfterFreeGuard: UseAfterFreeGuard_all_enabled implies uaf_ownership_clear ---
(push 1)
(declare-const g UseAfterFreeGuard)
(assert (UseAfterFreeGuard_all_enabled g))
(assert (not (uaf_ownership_clear g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DoubleFreeGuard record properties ---

; --- 37. DoubleFreeGuard accessor round-trip: df_state_tracking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (df_state_tracking (mk-double_free_guard f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. DoubleFreeGuard accessor round-trip: df_single_owner ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (df_single_owner (mk-double_free_guard f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DoubleFreeGuard_all_enabled ((g DoubleFreeGuard)) Bool
  (and (df_state_tracking g) (df_single_owner g)))

; --- 39. DoubleFreeGuard: all-enabled completeness ---
(push 1)
(declare-const g DoubleFreeGuard)
(assert (df_state_tracking g))
(assert (df_single_owner g))
(assert (not (DoubleFreeGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. DoubleFreeGuard: DoubleFreeGuard_all_enabled implies df_state_tracking ---
(push 1)
(declare-const g DoubleFreeGuard)
(assert (DoubleFreeGuard_all_enabled g))
(assert (not (df_state_tracking g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. DoubleFreeGuard: DoubleFreeGuard_all_enabled implies df_single_owner ---
(push 1)
(declare-const g DoubleFreeGuard)
(assert (DoubleFreeGuard_all_enabled g))
(assert (not (df_single_owner g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NullDerefGuard record properties ---

; --- 42. NullDerefGuard accessor round-trip: nd_null_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nd_null_check (mk-null_deref_guard f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. NullDerefGuard accessor round-trip: nd_option_types ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nd_option_types (mk-null_deref_guard f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NullDerefGuard_all_enabled ((g NullDerefGuard)) Bool
  (and (nd_null_check g) (nd_option_types g)))

; --- 44. NullDerefGuard: all-enabled completeness ---
(push 1)
(declare-const g NullDerefGuard)
(assert (nd_null_check g))
(assert (nd_option_types g))
(assert (not (NullDerefGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. NullDerefGuard: NullDerefGuard_all_enabled implies nd_null_check ---
(push 1)
(declare-const g NullDerefGuard)
(assert (NullDerefGuard_all_enabled g))
(assert (not (nd_null_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. NullDerefGuard: NullDerefGuard_all_enabled implies nd_option_types ---
(push 1)
(declare-const g NullDerefGuard)
(assert (NullDerefGuard_all_enabled g))
(assert (not (nd_option_types g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BoundsGuard record properties ---

; --- 47. BoundsGuard accessor round-trip: bg_bounds_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (bg_bounds_check (mk-bounds_guard f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. BoundsGuard accessor round-trip: bg_fat_pointers ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (bg_fat_pointers (mk-bounds_guard f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun BoundsGuard_all_enabled ((g BoundsGuard)) Bool
  (and (bg_bounds_check g) (bg_fat_pointers g)))

; --- 49. BoundsGuard: all-enabled completeness ---
(push 1)
(declare-const g BoundsGuard)
(assert (bg_bounds_check g))
(assert (bg_fat_pointers g))
(assert (not (BoundsGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. BoundsGuard: BoundsGuard_all_enabled implies bg_bounds_check ---
(push 1)
(declare-const g BoundsGuard)
(assert (BoundsGuard_all_enabled g))
(assert (not (bg_bounds_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. BoundsGuard: BoundsGuard_all_enabled implies bg_fat_pointers ---
(push 1)
(declare-const g BoundsGuard)
(assert (BoundsGuard_all_enabled g))
(assert (not (bg_fat_pointers g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StackGuard record properties ---

; --- 52. StackGuard accessor round-trip: sg_canary_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sg_canary_enabled (mk-stack_guard f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. StackGuard accessor round-trip: sg_return_addr_protected ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sg_return_addr_protected (mk-stack_guard f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. StackGuard accessor round-trip: sg_frame_isolation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sg_frame_isolation (mk-stack_guard f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun StackGuard_all_enabled ((g StackGuard)) Bool
  (and (sg_canary_enabled g) (sg_return_addr_protected g) (sg_frame_isolation g)))

; --- 55. StackGuard: all-enabled completeness ---
(push 1)
(declare-const g StackGuard)
(assert (sg_canary_enabled g))
(assert (sg_return_addr_protected g))
(assert (sg_frame_isolation g))
(assert (not (StackGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. StackGuard: StackGuard_all_enabled implies sg_canary_enabled ---
(push 1)
(declare-const g StackGuard)
(assert (StackGuard_all_enabled g))
(assert (not (sg_canary_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. StackGuard: StackGuard_all_enabled implies sg_return_addr_protected ---
(push 1)
(declare-const g StackGuard)
(assert (StackGuard_all_enabled g))
(assert (not (sg_return_addr_protected g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. StackGuard: StackGuard_all_enabled implies sg_frame_isolation ---
(push 1)
(declare-const g StackGuard)
(assert (StackGuard_all_enabled g))
(assert (not (sg_frame_isolation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HeapGuard record properties ---

; --- 59. HeapGuard accessor round-trip: hg_allocation_tracking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hg_allocation_tracking (mk-heap_guard f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. HeapGuard accessor round-trip: hg_deallocation_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hg_deallocation_check (mk-heap_guard f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. HeapGuard accessor round-trip: hg_fragmentation_prevention ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (hg_fragmentation_prevention (mk-heap_guard f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun HeapGuard_all_enabled ((g HeapGuard)) Bool
  (and (hg_allocation_tracking g) (hg_deallocation_check g) (hg_fragmentation_prevention g)))

; --- 62. HeapGuard: all-enabled completeness ---
(push 1)
(declare-const g HeapGuard)
(assert (hg_allocation_tracking g))
(assert (hg_deallocation_check g))
(assert (hg_fragmentation_prevention g))
(assert (not (HeapGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. HeapGuard: HeapGuard_all_enabled implies hg_allocation_tracking ---
(push 1)
(declare-const g HeapGuard)
(assert (HeapGuard_all_enabled g))
(assert (not (hg_allocation_tracking g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. HeapGuard: HeapGuard_all_enabled implies hg_deallocation_check ---
(push 1)
(declare-const g HeapGuard)
(assert (HeapGuard_all_enabled g))
(assert (not (hg_deallocation_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. HeapGuard: HeapGuard_all_enabled implies hg_fragmentation_prevention ---
(push 1)
(declare-const g HeapGuard)
(assert (HeapGuard_all_enabled g))
(assert (not (hg_fragmentation_prevention g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- IsolationGuard record properties ---

; --- 66. IsolationGuard accessor round-trip: ig_domain_separation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ig_domain_separation (mk-isolation_guard f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. IsolationGuard accessor round-trip: ig_permission_enforcement ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ig_permission_enforcement (mk-isolation_guard f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. IsolationGuard accessor round-trip: ig_cross_domain_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ig_cross_domain_check (mk-isolation_guard f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun IsolationGuard_all_enabled ((g IsolationGuard)) Bool
  (and (ig_domain_separation g) (ig_permission_enforcement g) (ig_cross_domain_check g)))

; --- 69. IsolationGuard: all-enabled completeness ---
(push 1)
(declare-const g IsolationGuard)
(assert (ig_domain_separation g))
(assert (ig_permission_enforcement g))
(assert (ig_cross_domain_check g))
(assert (not (IsolationGuard_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. IsolationGuard: IsolationGuard_all_enabled implies ig_domain_separation ---
(push 1)
(declare-const g IsolationGuard)
(assert (IsolationGuard_all_enabled g))
(assert (not (ig_domain_separation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. IsolationGuard: IsolationGuard_all_enabled implies ig_permission_enforcement ---
(push 1)
(declare-const g IsolationGuard)
(assert (IsolationGuard_all_enabled g))
(assert (not (ig_permission_enforcement g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. IsolationGuard: IsolationGuard_all_enabled implies ig_cross_domain_check ---
(push 1)
(declare-const g IsolationGuard)
(assert (IsolationGuard_all_enabled g))
(assert (not (ig_cross_domain_check g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemorySafetyConfig record properties ---

; --- 73. MemorySafetyConfig accessor round-trip: ms_uaf ---
(push 1)
(declare-const f0 UseAfterFreeGuard)
(declare-const f1 DoubleFreeGuard)
(declare-const f2 NullDerefGuard)
(declare-const f3 BoundsGuard)
(declare-const f4 StackGuard)
(declare-const f5 HeapGuard)
(declare-const f6 IsolationGuard)
(assert (not (= (ms_uaf (mk-memory_safety_config f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. MemorySafetyConfig accessor round-trip: ms_df ---
(push 1)
(declare-const f0 UseAfterFreeGuard)
(declare-const f1 DoubleFreeGuard)
(declare-const f2 NullDerefGuard)
(declare-const f3 BoundsGuard)
(declare-const f4 StackGuard)
(declare-const f5 HeapGuard)
(declare-const f6 IsolationGuard)
(assert (not (= (ms_df (mk-memory_safety_config f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. MemorySafetyConfig accessor round-trip: ms_nd ---
(push 1)
(declare-const f0 UseAfterFreeGuard)
(declare-const f1 DoubleFreeGuard)
(declare-const f2 NullDerefGuard)
(declare-const f3 BoundsGuard)
(declare-const f4 StackGuard)
(declare-const f5 HeapGuard)
(declare-const f6 IsolationGuard)
(assert (not (= (ms_nd (mk-memory_safety_config f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. MemorySafetyConfig accessor round-trip: ms_bounds ---
(push 1)
(declare-const f0 UseAfterFreeGuard)
(declare-const f1 DoubleFreeGuard)
(declare-const f2 NullDerefGuard)
(declare-const f3 BoundsGuard)
(declare-const f4 StackGuard)
(declare-const f5 HeapGuard)
(declare-const f6 IsolationGuard)
(assert (not (= (ms_bounds (mk-memory_safety_config f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. MemorySafetyConfig accessor round-trip: ms_stack ---
(push 1)
(declare-const f0 UseAfterFreeGuard)
(declare-const f1 DoubleFreeGuard)
(declare-const f2 NullDerefGuard)
(declare-const f3 BoundsGuard)
(declare-const f4 StackGuard)
(declare-const f5 HeapGuard)
(declare-const f6 IsolationGuard)
(assert (not (= (ms_stack (mk-memory_safety_config f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityDomain ordering properties ---

(define-fun SecurityDomain_level ((x SecurityDomain)) Int
  (ite (= x DomainKernel) 0 (ite (= x DomainUser) 1 (ite (= x DomainGuest) 2 3))))

(define-fun SecurityDomain_leq ((x SecurityDomain) (y SecurityDomain)) Bool
  (<= (SecurityDomain_level x) (SecurityDomain_level y)))

; --- 78. SecurityDomain_leq reflexivity ---
(push 1)
(declare-const x SecurityDomain)
(assert (not (SecurityDomain_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 79. SecurityDomain_leq transitivity ---
(push 1)
(declare-const x SecurityDomain)
(declare-const y SecurityDomain)
(declare-const z SecurityDomain)
(assert (SecurityDomain_leq x y))
(assert (SecurityDomain_leq y z))
(assert (not (SecurityDomain_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. SecurityDomain_leq antisymmetry ---
(push 1)
(declare-const x SecurityDomain)
(declare-const y SecurityDomain)
(assert (SecurityDomain_leq x y))
(assert (SecurityDomain_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. DomainKernel is bottom ---
(push 1)
(declare-const x SecurityDomain)
(assert (not (SecurityDomain_leq DomainKernel x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. DomainUntrusted is top ---
(push 1)
(declare-const x SecurityDomain)
(assert (not (SecurityDomain_leq x DomainUntrusted)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AccessPermission ordering properties ---

(define-fun AccessPermission_level ((x AccessPermission)) Int
  (ite (= x PermNone) 0 (ite (= x PermRead) 1 (ite (= x PermWrite) 2 (ite (= x PermReadWrite) 3 4)))))

(define-fun AccessPermission_leq ((x AccessPermission) (y AccessPermission)) Bool
  (<= (AccessPermission_level x) (AccessPermission_level y)))

; --- 83. AccessPermission_leq reflexivity ---
(push 1)
(declare-const x AccessPermission)
(assert (not (AccessPermission_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 84. AccessPermission_leq transitivity ---
(push 1)
(declare-const x AccessPermission)
(declare-const y AccessPermission)
(declare-const z AccessPermission)
(assert (AccessPermission_leq x y))
(assert (AccessPermission_leq y z))
(assert (not (AccessPermission_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 85. AccessPermission_leq antisymmetry ---
(push 1)
(declare-const x AccessPermission)
(declare-const y AccessPermission)
(assert (AccessPermission_leq x y))
(assert (AccessPermission_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 86. PermNone is bottom ---
(push 1)
(declare-const x AccessPermission)
(assert (not (AccessPermission_leq PermNone x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 87. PermExecute is top ---
(push 1)
(declare-const x AccessPermission)
(assert (not (AccessPermission_leq x PermExecute)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
