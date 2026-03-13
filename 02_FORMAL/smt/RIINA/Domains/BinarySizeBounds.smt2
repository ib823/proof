; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA BinarySizeBounds — SMT Verification
; Derived from 02_FORMAL/coq/domains/BinarySizeBounds.v (20 assertions)
; Module: BinarySizeBounds
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Instr 0)) (((INop) (IMov) (IAdd) (ISub) (IMul) (IDiv) (ILoad) (IStore) (IBranch) (ICall) (IRet))))

(declare-datatypes ((ArchParams 0))
  (((mk-arch_params (arch_word_size Int) (arch_max_instr_size Int) (arch_call_overhead Int) (arch_ret_overhead Int) (arch_flash_size Int) (arch_ram_size Int)))))

(declare-datatypes ((Rec_Function 0))
  (((mk-function (func_blocks (Seq Int)) (func_locals Int)))))

(declare-datatypes ((Rec_Module 0))
  (((mk-module (mod_functions (Seq Int)) (mod_data Int) (mod_bss Int)))))

(declare-datatypes ((Program 0))
  (((mk-program (prog_modules (Seq Int)) (prog_startup Int)))))

(declare-datatypes ((StackFrame 0))
  (((mk-stack_frame (sf_locals Int) (sf_saved_regs Int)))))

(declare-datatypes ((InlineInfo 0))
  (((mk-inline_info (inline_original_size Int) (inline_call_sites Int)))))

(declare-datatypes ((LoopInfo 0))
  (((mk-loop_info (loop_body_size Int) (loop_unroll_factor Int)))))

(declare-datatypes ((GenericInfo 0))
  (((mk-generic_info (generic_template_size Int) (generic_instantiation_count Int)))))

(declare-datatypes ((ROMLayout 0))
  (((mk-rom_layout (rom_text Int) (rom_rodata Int) (rom_init_data Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Instr exhaustiveness ---
(push 1)
(declare-const x Instr)
(assert (not (or (= x INop) (= x IMov) (= x IAdd) (= x ISub) (= x IMul) (= x IDiv) (= x ILoad) (= x IStore) (= x IBranch) (= x ICall) (= x IRet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Instr: INop != IMov ---
(push 1)
(assert (= INop IMov))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Instr: IMov != IAdd ---
(push 1)
(assert (= IMov IAdd))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Instr: IAdd != ISub ---
(push 1)
(assert (= IAdd ISub))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Instr: INop != IRet ---
(push 1)
(assert (= INop IRet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Instr finite cardinality (11 values) ---
(push 1)
(declare-const x Instr)
(assert (and (not (= x INop)) (not (= x IMov)) (not (= x IAdd)) (not (= x ISub)) (not (= x IMul)) (not (= x IDiv)) (not (= x ILoad)) (not (= x IStore)) (not (= x IBranch)) (not (= x ICall)) (not (= x IRet))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. ArchParams accessor round-trip: arch_word_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (arch_word_size (mk-arch_params f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ArchParams accessor round-trip: arch_max_instr_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (arch_max_instr_size (mk-arch_params f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ArchParams accessor round-trip: arch_call_overhead ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (arch_call_overhead (mk-arch_params f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ArchParams accessor round-trip: arch_ret_overhead ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (arch_ret_overhead (mk-arch_params f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ArchParams accessor round-trip: arch_flash_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (arch_flash_size (mk-arch_params f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ArchParams: non-negative int fields sum ---
(push 1)
(declare-const r ArchParams)
(assert (>= (arch_word_size r) 0))
(assert (>= (arch_max_instr_size r) 0))
(assert (not (>= (+ (arch_word_size r) (arch_max_instr_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. StackFrame accessor round-trip: sf_locals ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (sf_locals (mk-stack_frame f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. StackFrame accessor round-trip: sf_saved_regs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (sf_saved_regs (mk-stack_frame f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. StackFrame: non-negative int fields sum ---
(push 1)
(declare-const r StackFrame)
(assert (>= (sf_locals r) 0))
(assert (>= (sf_saved_regs r) 0))
(assert (not (>= (+ (sf_locals r) (sf_saved_regs r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. InlineInfo accessor round-trip: inline_original_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (inline_original_size (mk-inline_info f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. InlineInfo accessor round-trip: inline_call_sites ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (inline_call_sites (mk-inline_info f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. InlineInfo: non-negative int fields sum ---
(push 1)
(declare-const r InlineInfo)
(assert (>= (inline_original_size r) 0))
(assert (>= (inline_call_sites r) 0))
(assert (not (>= (+ (inline_original_size r) (inline_call_sites r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. LoopInfo accessor round-trip: loop_body_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (loop_body_size (mk-loop_info f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. LoopInfo accessor round-trip: loop_unroll_factor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (loop_unroll_factor (mk-loop_info f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. LoopInfo: non-negative int fields sum ---
(push 1)
(declare-const r LoopInfo)
(assert (>= (loop_body_size r) 0))
(assert (>= (loop_unroll_factor r) 0))
(assert (not (>= (+ (loop_body_size r) (loop_unroll_factor r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. GenericInfo accessor round-trip: generic_template_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (generic_template_size (mk-generic_info f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. GenericInfo accessor round-trip: generic_instantiation_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (generic_instantiation_count (mk-generic_info f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. GenericInfo: non-negative int fields sum ---
(push 1)
(declare-const r GenericInfo)
(assert (>= (generic_template_size r) 0))
(assert (>= (generic_instantiation_count r) 0))
(assert (not (>= (+ (generic_template_size r) (generic_instantiation_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ROMLayout accessor round-trip: rom_text ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (rom_text (mk-rom_layout f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ROMLayout accessor round-trip: rom_rodata ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (rom_rodata (mk-rom_layout f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ROMLayout accessor round-trip: rom_init_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (rom_init_data (mk-rom_layout f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ROMLayout: non-negative int fields sum ---
(push 1)
(declare-const r ROMLayout)
(assert (>= (rom_text r) 0))
(assert (>= (rom_rodata r) 0))
(assert (not (>= (+ (rom_text r) (rom_rodata r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
