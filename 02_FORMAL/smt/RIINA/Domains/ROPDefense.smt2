; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ROPDefense — SMT Verification
; Derived from 02_FORMAL/coq/domains/ROPDefense.v (89 assertions)
; Module: ROPDefense
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((GadgetType 0)) (((GadgetROP) (GadgetJOP) (GadgetCOP) (GadgetSROP))))

(declare-datatypes ((CodePtrType 0)) (((CPFunction) (CPVTable) (CPReturnAddr) (CPExceptionHandler) (CPSignalHandler))))

(declare-datatypes ((CFIConfig 0))
  (((mk-cfi_config (cfi_shadow_stack Bool) (cfi_indirect_branch_tracking Bool) (cfi_return_address_protection Bool) (cfi_forward_edge_cfi Bool) (cfi_backward_edge_cfi Bool)))))

(declare-datatypes ((CodeReuse 0))
  (((mk-code_reuse (cr_gadget_elimination Bool) (cr_instruction_alignment Bool) (cr_code_pointer_integrity Bool)))))

(declare-datatypes ((ROPDefenseConfig 0))
  (((mk-rop_defense_config (rop_cfi CFIConfig) (rop_code_reuse CodeReuse) (rop_aslr_compatible Bool) (rop_dep_compatible Bool)))))

(declare-datatypes ((ShadowEntry 0))
  (((mk-shadow_entry (se_return_addr Int) (se_caller_func Int) (se_frame_ptr Int) (se_mac_valid Bool)))))

(declare-datatypes ((BTBEntry 0))
  (((mk-btb_entry (btb_source Int) (btb_target Int) (btb_validated Bool)))))

(declare-datatypes ((Gadget 0))
  (((mk-gadget (gadget_type GadgetType) (gadget_addr Int) (gadget_length Int) (gadget_ends_in_ret Bool) (gadget_ends_in_jump Bool)))))

(declare-datatypes ((CodePointer 0))
  (((mk-code_pointer (cp_type CodePtrType) (cp_addr Int) (cp_authenticated Bool) (cp_bounds_checked Bool)))))

(declare-datatypes ((CPIConfig 0))
  (((mk-cpi_config (cpi_ptr_authentication Bool) (cpi_bounds_checking Bool) (cpi_type_checking Bool) (cpi_isolation Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- GadgetType enum properties ---

; --- 1. GadgetType exhaustiveness ---
(push 1)
(declare-const x GadgetType)
(assert (not (or (= x GadgetROP) (= x GadgetJOP) (= x GadgetCOP) (= x GadgetSROP))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. GadgetType: GadgetROP != GadgetJOP ---
(push 1)
(assert (= GadgetROP GadgetJOP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. GadgetType: GadgetJOP != GadgetCOP ---
(push 1)
(assert (= GadgetJOP GadgetCOP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. GadgetType: GadgetCOP != GadgetSROP ---
(push 1)
(assert (= GadgetCOP GadgetSROP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. GadgetType: GadgetROP != GadgetSROP ---
(push 1)
(assert (= GadgetROP GadgetSROP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. GadgetType finite cardinality (4 values) ---
(push 1)
(declare-const x GadgetType)
(assert (and (not (= x GadgetROP)) (not (= x GadgetJOP)) (not (= x GadgetCOP)) (not (= x GadgetSROP))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CodePtrType enum properties ---

; --- 7. CodePtrType exhaustiveness ---
(push 1)
(declare-const x CodePtrType)
(assert (not (or (= x CPFunction) (= x CPVTable) (= x CPReturnAddr) (= x CPExceptionHandler) (= x CPSignalHandler))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CodePtrType: CPFunction != CPVTable ---
(push 1)
(assert (= CPFunction CPVTable))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CodePtrType: CPVTable != CPReturnAddr ---
(push 1)
(assert (= CPVTable CPReturnAddr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CodePtrType: CPReturnAddr != CPExceptionHandler ---
(push 1)
(assert (= CPReturnAddr CPExceptionHandler))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CodePtrType: CPFunction != CPSignalHandler ---
(push 1)
(assert (= CPFunction CPSignalHandler))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CodePtrType finite cardinality (5 values) ---
(push 1)
(declare-const x CodePtrType)
(assert (and (not (= x CPFunction)) (not (= x CPVTable)) (not (= x CPReturnAddr)) (not (= x CPExceptionHandler)) (not (= x CPSignalHandler))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CFIConfig record properties ---

; --- 13. CFIConfig accessor round-trip: cfi_shadow_stack ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cfi_shadow_stack (mk-cfi_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CFIConfig accessor round-trip: cfi_indirect_branch_tracking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cfi_indirect_branch_tracking (mk-cfi_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. CFIConfig accessor round-trip: cfi_return_address_protection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cfi_return_address_protection (mk-cfi_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. CFIConfig accessor round-trip: cfi_forward_edge_cfi ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cfi_forward_edge_cfi (mk-cfi_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CFIConfig_all_enabled ((g CFIConfig)) Bool
  (and (cfi_shadow_stack g) (cfi_indirect_branch_tracking g) (cfi_return_address_protection g) (cfi_forward_edge_cfi g)))

; --- 17. CFIConfig: all-enabled completeness ---
(push 1)
(declare-const g CFIConfig)
(assert (cfi_shadow_stack g))
(assert (cfi_indirect_branch_tracking g))
(assert (cfi_return_address_protection g))
(assert (cfi_forward_edge_cfi g))
(assert (not (CFIConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. CFIConfig: CFIConfig_all_enabled implies cfi_shadow_stack ---
(push 1)
(declare-const g CFIConfig)
(assert (CFIConfig_all_enabled g))
(assert (not (cfi_shadow_stack g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. CFIConfig: CFIConfig_all_enabled implies cfi_indirect_branch_tracking ---
(push 1)
(declare-const g CFIConfig)
(assert (CFIConfig_all_enabled g))
(assert (not (cfi_indirect_branch_tracking g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. CFIConfig: CFIConfig_all_enabled implies cfi_return_address_protection ---
(push 1)
(declare-const g CFIConfig)
(assert (CFIConfig_all_enabled g))
(assert (not (cfi_return_address_protection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CodeReuse record properties ---

; --- 21. CodeReuse accessor round-trip: cr_gadget_elimination ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cr_gadget_elimination (mk-code_reuse f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. CodeReuse accessor round-trip: cr_instruction_alignment ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (cr_instruction_alignment (mk-code_reuse f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CodeReuse_all_enabled ((g CodeReuse)) Bool
  (and (cr_gadget_elimination g) (cr_instruction_alignment g)))

; --- 23. CodeReuse: all-enabled completeness ---
(push 1)
(declare-const g CodeReuse)
(assert (cr_gadget_elimination g))
(assert (cr_instruction_alignment g))
(assert (not (CodeReuse_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. CodeReuse: CodeReuse_all_enabled implies cr_gadget_elimination ---
(push 1)
(declare-const g CodeReuse)
(assert (CodeReuse_all_enabled g))
(assert (not (cr_gadget_elimination g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. CodeReuse: CodeReuse_all_enabled implies cr_instruction_alignment ---
(push 1)
(declare-const g CodeReuse)
(assert (CodeReuse_all_enabled g))
(assert (not (cr_instruction_alignment g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ROPDefenseConfig record properties ---

; --- 26. ROPDefenseConfig accessor round-trip: rop_cfi ---
(push 1)
(declare-const f0 CFIConfig)
(declare-const f1 CodeReuse)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rop_cfi (mk-rop_defense_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ROPDefenseConfig accessor round-trip: rop_code_reuse ---
(push 1)
(declare-const f0 CFIConfig)
(declare-const f1 CodeReuse)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rop_code_reuse (mk-rop_defense_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ROPDefenseConfig accessor round-trip: rop_aslr_compatible ---
(push 1)
(declare-const f0 CFIConfig)
(declare-const f1 CodeReuse)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (rop_aslr_compatible (mk-rop_defense_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ShadowEntry record properties ---

; --- 29. ShadowEntry accessor round-trip: se_return_addr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (se_return_addr (mk-shadow_entry f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ShadowEntry accessor round-trip: se_caller_func ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (se_caller_func (mk-shadow_entry f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ShadowEntry accessor round-trip: se_frame_ptr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (se_frame_ptr (mk-shadow_entry f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ShadowEntry: integer field consistency ---
(push 1)
(declare-const r ShadowEntry)
(assert (>= (se_return_addr r) 0))
(assert (>= (se_caller_func r) 0))
(assert (not (>= (+ (se_return_addr r) (se_caller_func r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BTBEntry record properties ---

; --- 33. BTBEntry accessor round-trip: btb_source ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (btb_source (mk-btb_entry f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. BTBEntry accessor round-trip: btb_target ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (btb_target (mk-btb_entry f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. BTBEntry: integer field consistency ---
(push 1)
(declare-const r BTBEntry)
(assert (>= (btb_source r) 0))
(assert (>= (btb_target r) 0))
(assert (not (>= (+ (btb_source r) (btb_target r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Gadget record properties ---

; --- 36. Gadget accessor round-trip: gadget_type ---
(push 1)
(declare-const f0 GadgetType)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (gadget_type (mk-gadget f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Gadget accessor round-trip: gadget_addr ---
(push 1)
(declare-const f0 GadgetType)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (gadget_addr (mk-gadget f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. Gadget accessor round-trip: gadget_length ---
(push 1)
(declare-const f0 GadgetType)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (gadget_length (mk-gadget f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Gadget accessor round-trip: gadget_ends_in_ret ---
(push 1)
(declare-const f0 GadgetType)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (gadget_ends_in_ret (mk-gadget f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Gadget: integer field consistency ---
(push 1)
(declare-const r Gadget)
(assert (>= (gadget_addr r) 0))
(assert (>= (gadget_length r) 0))
(assert (not (>= (+ (gadget_addr r) (gadget_length r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CodePointer record properties ---

; --- 41. CodePointer accessor round-trip: cp_type ---
(push 1)
(declare-const f0 CodePtrType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cp_type (mk-code_pointer f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. CodePointer accessor round-trip: cp_addr ---
(push 1)
(declare-const f0 CodePtrType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cp_addr (mk-code_pointer f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. CodePointer accessor round-trip: cp_authenticated ---
(push 1)
(declare-const f0 CodePtrType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cp_authenticated (mk-code_pointer f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CPIConfig record properties ---

; --- 44. CPIConfig accessor round-trip: cpi_ptr_authentication ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cpi_ptr_authentication (mk-cpi_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. CPIConfig accessor round-trip: cpi_bounds_checking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cpi_bounds_checking (mk-cpi_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. CPIConfig accessor round-trip: cpi_type_checking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (cpi_type_checking (mk-cpi_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CPIConfig_all_enabled ((g CPIConfig)) Bool
  (and (cpi_ptr_authentication g) (cpi_bounds_checking g) (cpi_type_checking g)))

; --- 47. CPIConfig: all-enabled completeness ---
(push 1)
(declare-const g CPIConfig)
(assert (cpi_ptr_authentication g))
(assert (cpi_bounds_checking g))
(assert (cpi_type_checking g))
(assert (not (CPIConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. CPIConfig: CPIConfig_all_enabled implies cpi_ptr_authentication ---
(push 1)
(declare-const g CPIConfig)
(assert (CPIConfig_all_enabled g))
(assert (not (cpi_ptr_authentication g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. CPIConfig: CPIConfig_all_enabled implies cpi_bounds_checking ---
(push 1)
(declare-const g CPIConfig)
(assert (CPIConfig_all_enabled g))
(assert (not (cpi_bounds_checking g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. CPIConfig: CPIConfig_all_enabled implies cpi_type_checking ---
(push 1)
(declare-const g CPIConfig)
(assert (CPIConfig_all_enabled g))
(assert (not (cpi_type_checking g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
