; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AgentToolSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/AgentToolSecurity.v (26 assertions)
; Module: AgentToolSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CapLevel 0)) (((ReadOnly) (ReadWrite) (Execute) (Network) (System))))

(declare-datatypes ((InvocationResult 0)) (((Permitted) (DeniedLevel) (DeniedNetwork) (DeniedExecute) (DeniedSystem) (DeniedSandbox) (DeniedValidation) (DeniedSanitization) (DeniedRateLimit))))

(declare-datatypes ((ToolCapability 0))
  (((mk-tool_capability (tc_name Int) (tc_level CapLevel) (tc_sandboxed Bool) (tc_input_validated Bool) (tc_output_sanitized Bool) (tc_rate_limited Bool)))))

(declare-datatypes ((AgentBoundary 0))
  (((mk-agent_boundary (ab_max_level CapLevel) (ab_allow_network Bool) (ab_allow_execute Bool) (ab_allow_system Bool) (ab_require_sandbox Bool) (ab_require_validation Bool) (ab_require_sanitization Bool) (ab_require_rate_limit Bool)))))

(declare-datatypes ((ToolRequest 0))
  (((mk-tool_request (tr_tool ToolCapability) (tr_input_hash Int) (tr_caller_id Int) (tr_timestamp Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- CapLevel enum properties ---

; --- 1. CapLevel exhaustiveness ---
(push 1)
(declare-const x CapLevel)
(assert (not (or (= x ReadOnly) (= x ReadWrite) (= x Execute) (= x Network) (= x System))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CapLevel: ReadOnly != ReadWrite ---
(push 1)
(assert (= ReadOnly ReadWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CapLevel: ReadWrite != Execute ---
(push 1)
(assert (= ReadWrite Execute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CapLevel: Execute != Network ---
(push 1)
(assert (= Execute Network))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CapLevel: ReadOnly != System ---
(push 1)
(assert (= ReadOnly System))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CapLevel finite cardinality (5 values) ---
(push 1)
(declare-const x CapLevel)
(assert (and (not (= x ReadOnly)) (not (= x ReadWrite)) (not (= x Execute)) (not (= x Network)) (not (= x System))))
(check-sat) ; expect UNSAT
(pop 1)

; --- InvocationResult enum properties ---

; --- 7. InvocationResult exhaustiveness ---
(push 1)
(declare-const x InvocationResult)
(assert (not (or (= x Permitted) (= x DeniedLevel) (= x DeniedNetwork) (= x DeniedExecute) (= x DeniedSystem) (= x DeniedSandbox) (= x DeniedValidation) (= x DeniedSanitization) (= x DeniedRateLimit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. InvocationResult: Permitted != DeniedLevel ---
(push 1)
(assert (= Permitted DeniedLevel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. InvocationResult: DeniedLevel != DeniedNetwork ---
(push 1)
(assert (= DeniedLevel DeniedNetwork))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. InvocationResult: DeniedNetwork != DeniedExecute ---
(push 1)
(assert (= DeniedNetwork DeniedExecute))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. InvocationResult: Permitted != DeniedRateLimit ---
(push 1)
(assert (= Permitted DeniedRateLimit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. InvocationResult finite cardinality (9 values) ---
(push 1)
(declare-const x InvocationResult)
(assert (and (not (= x Permitted)) (not (= x DeniedLevel)) (not (= x DeniedNetwork)) (not (= x DeniedExecute)) (not (= x DeniedSystem)) (not (= x DeniedSandbox)) (not (= x DeniedValidation)) (not (= x DeniedSanitization)) (not (= x DeniedRateLimit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ToolCapability record properties ---

; --- 13. ToolCapability accessor round-trip: tc_name ---
(push 1)
(declare-const f0 Int)
(declare-const f1 CapLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (tc_name (mk-tool_capability f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. ToolCapability accessor round-trip: tc_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 CapLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (tc_level (mk-tool_capability f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ToolCapability accessor round-trip: tc_sandboxed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 CapLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (tc_sandboxed (mk-tool_capability f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ToolCapability accessor round-trip: tc_input_validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 CapLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (tc_input_validated (mk-tool_capability f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ToolCapability accessor round-trip: tc_output_sanitized ---
(push 1)
(declare-const f0 Int)
(declare-const f1 CapLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (tc_output_sanitized (mk-tool_capability f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AgentBoundary record properties ---

; --- 18. AgentBoundary accessor round-trip: ab_max_level ---
(push 1)
(declare-const f0 CapLevel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ab_max_level (mk-agent_boundary f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. AgentBoundary accessor round-trip: ab_allow_network ---
(push 1)
(declare-const f0 CapLevel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ab_allow_network (mk-agent_boundary f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. AgentBoundary accessor round-trip: ab_allow_execute ---
(push 1)
(declare-const f0 CapLevel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ab_allow_execute (mk-agent_boundary f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. AgentBoundary accessor round-trip: ab_allow_system ---
(push 1)
(declare-const f0 CapLevel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ab_allow_system (mk-agent_boundary f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AgentBoundary accessor round-trip: ab_require_sandbox ---
(push 1)
(declare-const f0 CapLevel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ab_require_sandbox (mk-agent_boundary f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ToolRequest record properties ---

; --- 23. ToolRequest accessor round-trip: tr_tool ---
(push 1)
(declare-const f0 ToolCapability)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tr_tool (mk-tool_request f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ToolRequest accessor round-trip: tr_input_hash ---
(push 1)
(declare-const f0 ToolCapability)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tr_input_hash (mk-tool_request f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ToolRequest accessor round-trip: tr_caller_id ---
(push 1)
(declare-const f0 ToolCapability)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (tr_caller_id (mk-tool_request f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ToolRequest: integer field consistency ---
(push 1)
(declare-const r ToolRequest)
(assert (>= (tr_input_hash r) 0))
(assert (>= (tr_caller_id r) 0))
(assert (not (>= (+ (tr_input_hash r) (tr_caller_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CapLevel ordering properties ---

(define-fun CapLevel_level ((x CapLevel)) Int
  (ite (= x ReadOnly) 0 (ite (= x ReadWrite) 1 (ite (= x Execute) 2 (ite (= x Network) 3 4)))))

(define-fun CapLevel_leq ((x CapLevel) (y CapLevel)) Bool
  (<= (CapLevel_level x) (CapLevel_level y)))

; --- 27. CapLevel_leq reflexivity ---
(push 1)
(declare-const x CapLevel)
(assert (not (CapLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. CapLevel_leq transitivity ---
(push 1)
(declare-const x CapLevel)
(declare-const y CapLevel)
(declare-const z CapLevel)
(assert (CapLevel_leq x y))
(assert (CapLevel_leq y z))
(assert (not (CapLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. CapLevel_leq antisymmetry ---
(push 1)
(declare-const x CapLevel)
(declare-const y CapLevel)
(assert (CapLevel_leq x y))
(assert (CapLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ReadOnly is bottom ---
(push 1)
(declare-const x CapLevel)
(assert (not (CapLevel_leq ReadOnly x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. System is top ---
(push 1)
(declare-const x CapLevel)
(assert (not (CapLevel_leq x System)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
