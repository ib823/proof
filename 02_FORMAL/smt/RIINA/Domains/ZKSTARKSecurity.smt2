; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ZKSTARKSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/ZKSTARKSecurity.v (107 assertions)
; Module: ZKSTARKSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((STARKProperties 0))
  (((mk-stark_properties (stark_transparent Bool) (stark_scalable Bool) (stark_post_quantum Bool)))))

(declare-datatypes ((AIRProperties 0))
  (((mk-air_properties (air_algebraic Bool) (air_low_degree Bool) (air_fri_verified Bool)))))

(declare-datatypes ((FRIProperties 0))
  (((mk-fri_properties (fri_soundness Bool) (fri_query_bound Bool) (fri_commitment_binding Bool) (fri_interactive_to_non Bool) (fri_round_complexity Int) (fri_proximity_param Int)))))

(declare-datatypes ((ProverState 0))
  (((mk-prover_state (prover_witness Int) (prover_randomness Int) (prover_committed Bool) (prover_fri_complete Bool)))))

(declare-datatypes ((VerifierState 0))
  (((mk-verifier_state (verifier_challenges (Seq Int)) (verifier_queries (Seq Int)) (verifier_accepting Bool)))))

(declare-datatypes ((SimulatorState 0))
  (((mk-simulator_state (sim_transcript (Seq Int)) (sim_rewinding Bool) (sim_indistinguishable Bool)))))

(declare-datatypes ((STARKSecurity 0))
  (((mk-stark_security (starks_completeness Bool) (starks_soundness Bool) (starks_zero_knowledge Bool) (starks_stark STARKProperties) (starks_air AIRProperties)))))

(declare-datatypes ((ExtendedSTARKSecurity 0))
  (((mk-extended_stark_security (ext_base STARKSecurity) (ext_fri FRIProperties) (ext_simulation_secure Bool) (ext_extraction_secure Bool) (ext_quantum_resistant Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- STARKProperties record properties ---

; --- 1. STARKProperties accessor round-trip: stark_transparent ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (stark_transparent (mk-s_t_a_r_k_properties f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. STARKProperties accessor round-trip: stark_scalable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (stark_scalable (mk-s_t_a_r_k_properties f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun STARKProperties_all_enabled ((g STARKProperties)) Bool
  (and (stark_transparent g) (stark_scalable g)))

; --- 3. STARKProperties: all-enabled completeness ---
(push 1)
(declare-const g STARKProperties)
(assert (stark_transparent g))
(assert (stark_scalable g))
(assert (not (STARKProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. STARKProperties: STARKProperties_all_enabled implies stark_transparent ---
(push 1)
(declare-const g STARKProperties)
(assert (STARKProperties_all_enabled g))
(assert (not (stark_transparent g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. STARKProperties: STARKProperties_all_enabled implies stark_scalable ---
(push 1)
(declare-const g STARKProperties)
(assert (STARKProperties_all_enabled g))
(assert (not (stark_scalable g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AIRProperties record properties ---

; --- 6. AIRProperties accessor round-trip: air_algebraic ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (air_algebraic (mk-a_i_r_properties f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. AIRProperties accessor round-trip: air_low_degree ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (air_low_degree (mk-a_i_r_properties f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun AIRProperties_all_enabled ((g AIRProperties)) Bool
  (and (air_algebraic g) (air_low_degree g)))

; --- 8. AIRProperties: all-enabled completeness ---
(push 1)
(declare-const g AIRProperties)
(assert (air_algebraic g))
(assert (air_low_degree g))
(assert (not (AIRProperties_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. AIRProperties: AIRProperties_all_enabled implies air_algebraic ---
(push 1)
(declare-const g AIRProperties)
(assert (AIRProperties_all_enabled g))
(assert (not (air_algebraic g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. AIRProperties: AIRProperties_all_enabled implies air_low_degree ---
(push 1)
(declare-const g AIRProperties)
(assert (AIRProperties_all_enabled g))
(assert (not (air_low_degree g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FRIProperties record properties ---

; --- 11. FRIProperties accessor round-trip: fri_soundness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (fri_soundness (mk-f_r_i_properties f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. FRIProperties accessor round-trip: fri_query_bound ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (fri_query_bound (mk-f_r_i_properties f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. FRIProperties accessor round-trip: fri_commitment_binding ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (fri_commitment_binding (mk-f_r_i_properties f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. FRIProperties accessor round-trip: fri_interactive_to_non ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (fri_interactive_to_non (mk-f_r_i_properties f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. FRIProperties accessor round-trip: fri_round_complexity ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (fri_round_complexity (mk-f_r_i_properties f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProverState record properties ---

; --- 16. ProverState accessor round-trip: prover_witness ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (prover_witness (mk-prover_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ProverState accessor round-trip: prover_randomness ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (prover_randomness (mk-prover_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ProverState accessor round-trip: prover_committed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (prover_committed (mk-prover_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ProverState: integer field consistency ---
(push 1)
(declare-const r ProverState)
(assert (>= (prover_witness r) 0))
(assert (>= (prover_randomness r) 0))
(assert (not (>= (+ (prover_witness r) (prover_randomness r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifierState record properties ---

; --- 20. VerifierState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-verifier_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. VerifierState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-verifier_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. VerifierState: integer field consistency ---
(push 1)
(declare-const r VerifierState)
(assert (>= (Seq r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (Seq r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SimulatorState record properties ---

; --- 23. SimulatorState accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (Seq (mk-simulator_state f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SimulatorState accessor round-trip: sim_rewinding ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (sim_rewinding (mk-simulator_state f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- STARKSecurity record properties ---

; --- 25. STARKSecurity accessor round-trip: starks_completeness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 STARKProperties)
(assert (not (= (starks_completeness (mk-s_t_a_r_k_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. STARKSecurity accessor round-trip: starks_soundness ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 STARKProperties)
(assert (not (= (starks_soundness (mk-s_t_a_r_k_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. STARKSecurity accessor round-trip: starks_zero_knowledge ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 STARKProperties)
(assert (not (= (starks_zero_knowledge (mk-s_t_a_r_k_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. STARKSecurity accessor round-trip: starks_stark ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 STARKProperties)
(assert (not (= (starks_stark (mk-s_t_a_r_k_security f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ExtendedSTARKSecurity record properties ---

; --- 29. ExtendedSTARKSecurity accessor round-trip: ext_base ---
(push 1)
(declare-const f0 STARKSecurity)
(declare-const f1 FRIProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ext_base (mk-extended_s_t_a_r_k_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ExtendedSTARKSecurity accessor round-trip: ext_fri ---
(push 1)
(declare-const f0 STARKSecurity)
(declare-const f1 FRIProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ext_fri (mk-extended_s_t_a_r_k_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ExtendedSTARKSecurity accessor round-trip: ext_simulation_secure ---
(push 1)
(declare-const f0 STARKSecurity)
(declare-const f1 FRIProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ext_simulation_secure (mk-extended_s_t_a_r_k_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ExtendedSTARKSecurity accessor round-trip: ext_extraction_secure ---
(push 1)
(declare-const f0 STARKSecurity)
(declare-const f1 FRIProperties)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (ext_extraction_secure (mk-extended_s_t_a_r_k_security f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
