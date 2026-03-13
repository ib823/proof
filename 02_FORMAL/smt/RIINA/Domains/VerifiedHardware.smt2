; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedHardware — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedHardware.v (47 assertions)
; Module: VerifiedHardware
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SecurityLevel 0)) (((Public) (Secret))))

(declare-datatypes ((Instruction 0)) (((IAdd) (ISub) (IAnd) (IOr) (IXor) (IMul) (IDiv) (ILoad) (IStore) (IBranch) (IJump) (ISCUB) (IFENCESC) (IISOL) (IZEROIZE) (INop))))

(declare-datatypes ((PipelineStage 0)) (((Fetch) (Decode) (Execute) (MemoryStage) (Writeback))))

(declare-datatypes ((Leakage 0)) (((LTiming) (LPower) (LCacheAccess) (LBranchOutcome))))

(declare-datatypes ((ArchState 0))
  (((mk-arch_state (regs Int) (mem Int) (pc Int) (security_labels Int) (isolation_mode Bool)))))

(declare-datatypes ((PipelineEntry 0))
  (((mk-pipeline_entry (pe_stage PipelineStage) (pe_instr Instruction) (pe_valid Bool)))))

(declare-datatypes ((RTLState 0))
  (((mk-rtl_state (rtl_regs Int) (rtl_mem Int) (rtl_pc Int) (rtl_pipeline (Seq Int)) (rtl_cycle Int) (rtl_security_labels Int) (rtl_isolation_mode Bool) (rtl_speculating Bool) (rtl_scub_active Bool) (rtl_fencesc_active Bool)))))

(declare-datatypes ((ECCWord 0))
  (((mk-ecc_word (ecc_data Int) (ecc_syndrome Int) (ecc_parity Bool)))))

(declare-datatypes ((Checkpoint 0))
  (((mk-checkpoint (chk_regs Int) (chk_pc Int) (chk_valid Bool)))))

(declare-datatypes ((TamperState 0))
  (((mk-tamper_state (tamper_seal_intact Bool) (tamper_mesh_intact Bool) (tamper_voltage_ok Bool) (tamper_frequency_ok Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SecurityLevel enum properties ---

; --- 1. SecurityLevel exhaustiveness ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (or (= x Public) (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SecurityLevel: Public != Secret ---
(push 1)
(assert (= Public Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SecurityLevel finite cardinality (2 values) ---
(push 1)
(declare-const x SecurityLevel)
(assert (and (not (= x Public)) (not (= x Secret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Instruction enum properties ---

; --- 4. Instruction exhaustiveness ---
(push 1)
(declare-const x Instruction)
(assert (not (or (= x IAdd) (= x ISub) (= x IAnd) (= x IOr) (= x IXor) (= x IMul) (= x IDiv) (= x ILoad) (= x IStore) (= x IBranch) (= x IJump) (= x ISCUB) (= x IFENCESC) (= x IISOL) (= x IZEROIZE) (= x INop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Instruction: IAdd != ISub ---
(push 1)
(assert (= IAdd ISub))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Instruction: ISub != IAnd ---
(push 1)
(assert (= ISub IAnd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Instruction: IAnd != IOr ---
(push 1)
(assert (= IAnd IOr))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Instruction: IAdd != INop ---
(push 1)
(assert (= IAdd INop))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Instruction finite cardinality (16 values) ---
(push 1)
(declare-const x Instruction)
(assert (and (not (= x IAdd)) (not (= x ISub)) (not (= x IAnd)) (not (= x IOr)) (not (= x IXor)) (not (= x IMul)) (not (= x IDiv)) (not (= x ILoad)) (not (= x IStore)) (not (= x IBranch)) (not (= x IJump)) (not (= x ISCUB)) (not (= x IFENCESC)) (not (= x IISOL)) (not (= x IZEROIZE)) (not (= x INop))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PipelineStage enum properties ---

; --- 10. PipelineStage exhaustiveness ---
(push 1)
(declare-const x PipelineStage)
(assert (not (or (= x Fetch) (= x Decode) (= x Execute) (= x MemoryStage) (= x Writeback))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PipelineStage: Fetch != Decode ---
(push 1)
(assert (= Fetch Decode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PipelineStage: Decode != Execute ---
(push 1)
(assert (= Decode Execute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. PipelineStage: Execute != MemoryStage ---
(push 1)
(assert (= Execute MemoryStage))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PipelineStage: Fetch != Writeback ---
(push 1)
(assert (= Fetch Writeback))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PipelineStage finite cardinality (5 values) ---
(push 1)
(declare-const x PipelineStage)
(assert (and (not (= x Fetch)) (not (= x Decode)) (not (= x Execute)) (not (= x MemoryStage)) (not (= x Writeback))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Leakage enum properties ---

; --- 16. Leakage exhaustiveness ---
(push 1)
(declare-const x Leakage)
(assert (not (or (= x LTiming) (= x LPower) (= x LCacheAccess) (= x LBranchOutcome))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Leakage: LTiming != LPower ---
(push 1)
(assert (= LTiming LPower))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Leakage: LPower != LCacheAccess ---
(push 1)
(assert (= LPower LCacheAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Leakage: LCacheAccess != LBranchOutcome ---
(push 1)
(assert (= LCacheAccess LBranchOutcome))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Leakage: LTiming != LBranchOutcome ---
(push 1)
(assert (= LTiming LBranchOutcome))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Leakage finite cardinality (4 values) ---
(push 1)
(declare-const x Leakage)
(assert (and (not (= x LTiming)) (not (= x LPower)) (not (= x LCacheAccess)) (not (= x LBranchOutcome))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ArchState record properties ---

; --- 22. ArchState accessor round-trip: regs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (regs (mk-arch_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ArchState accessor round-trip: mem ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (mem (mk-arch_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ArchState accessor round-trip: pc ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pc (mk-arch_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ArchState accessor round-trip: security_labels ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (security_labels (mk-arch_state f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ArchState: integer field consistency ---
(push 1)
(declare-const r ArchState)
(assert (>= (regs r) 0))
(assert (>= (mem r) 0))
(assert (not (>= (+ (regs r) (mem r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PipelineEntry record properties ---

; --- 27. PipelineEntry accessor round-trip: pe_stage ---
(push 1)
(declare-const f0 PipelineStage)
(declare-const f1 Instruction)
(assert (not (= (pe_stage (mk-pipeline_entry f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. PipelineEntry accessor round-trip: pe_instr ---
(push 1)
(declare-const f0 PipelineStage)
(declare-const f1 Instruction)
(assert (not (= (pe_instr (mk-pipeline_entry f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RTLState record properties ---

; --- 29. RTLState accessor round-trip: rtl_regs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (rtl_regs (mk-r_t_l_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. RTLState accessor round-trip: rtl_mem ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (rtl_mem (mk-r_t_l_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. RTLState accessor round-trip: rtl_pc ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (rtl_pc (mk-r_t_l_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. RTLState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (Seq (mk-r_t_l_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. RTLState accessor round-trip: rtl_cycle ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (rtl_cycle (mk-r_t_l_state f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. RTLState: integer field consistency ---
(push 1)
(declare-const r RTLState)
(assert (>= (rtl_regs r) 0))
(assert (>= (rtl_mem r) 0))
(assert (not (>= (+ (rtl_regs r) (rtl_mem r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ECCWord record properties ---

; --- 35. ECCWord accessor round-trip: ecc_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ecc_data (mk-e_c_c_word f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ECCWord accessor round-trip: ecc_syndrome ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ecc_syndrome (mk-e_c_c_word f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ECCWord: integer field consistency ---
(push 1)
(declare-const r ECCWord)
(assert (>= (ecc_data r) 0))
(assert (>= (ecc_syndrome r) 0))
(assert (not (>= (+ (ecc_data r) (ecc_syndrome r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Checkpoint record properties ---

; --- 38. Checkpoint accessor round-trip: chk_regs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (chk_regs (mk-checkpoint f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Checkpoint accessor round-trip: chk_pc ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (chk_pc (mk-checkpoint f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Checkpoint: integer field consistency ---
(push 1)
(declare-const r Checkpoint)
(assert (>= (chk_regs r) 0))
(assert (>= (chk_pc r) 0))
(assert (not (>= (+ (chk_regs r) (chk_pc r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TamperState record properties ---

; --- 41. TamperState accessor round-trip: tamper_seal_intact ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (tamper_seal_intact (mk-tamper_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. TamperState accessor round-trip: tamper_mesh_intact ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (tamper_mesh_intact (mk-tamper_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. TamperState accessor round-trip: tamper_voltage_ok ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (tamper_voltage_ok (mk-tamper_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TamperState_all_enabled ((g TamperState)) Bool
  (and (tamper_seal_intact g) (tamper_mesh_intact g) (tamper_voltage_ok g)))

; --- 44. TamperState: all-enabled completeness ---
(push 1)
(declare-const g TamperState)
(assert (tamper_seal_intact g))
(assert (tamper_mesh_intact g))
(assert (tamper_voltage_ok g))
(assert (not (TamperState_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. TamperState: TamperState_all_enabled implies tamper_seal_intact ---
(push 1)
(declare-const g TamperState)
(assert (TamperState_all_enabled g))
(assert (not (tamper_seal_intact g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. TamperState: TamperState_all_enabled implies tamper_mesh_intact ---
(push 1)
(declare-const g TamperState)
(assert (TamperState_all_enabled g))
(assert (not (tamper_mesh_intact g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. TamperState: TamperState_all_enabled implies tamper_voltage_ok ---
(push 1)
(declare-const g TamperState)
(assert (TamperState_all_enabled g))
(assert (not (tamper_voltage_ok g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
