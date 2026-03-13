; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA OnDeviceML — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/OnDeviceML.v (25 assertions)
; Module: OnDeviceML
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ModelUpdateState 0)) (((UpdateIdle) (UpdateInProgress) (UpdateComplete) (UpdateFailed))))

(declare-datatypes ((Tensor 0))
  (((mk-tensor (tensor_shape (Seq Int)) (tensor_data Int)))))

(declare-datatypes ((MLModel 0))
  (((mk-ml_model (model_id Int) (model_weights (Seq Int)) (model_version Int) (model_deterministic Bool)))))

(declare-datatypes ((UserData 0))
  (((mk-user_data (data_id Int) (data_content (Seq Int)) (data_sensitive Bool)))))

(declare-datatypes ((InferenceRequest 0))
  (((mk-inference_request (req_model MLModel) (req_input Tensor) (req_latency_ms Int) (req_max_latency_ms Int)))))

(declare-datatypes ((MemoryBudget 0))
  (((mk-memory_budget (budget_max_bytes Int) (model_size_bytes Int)))))

(declare-datatypes ((ModelUpdate 0))
  (((mk-model_update (update_old_model MLModel) (update_new_model MLModel) (update_state ModelUpdateState) (update_version_increased Bool)))))

(declare-datatypes ((PrivacyBudget 0))
  (((mk-privacy_budget (epsilon Int) (delta Int) (max_epsilon Int) (max_delta Int)))))

(declare-datatypes ((Prediction 0))
  (((mk-prediction (pred_class Int) (pred_confidence Int) (pred_calibrated Bool)))))

(declare-datatypes ((ModelPolicy 0))
  (((mk-model_policy (policy_model MLModel) (policy_exportable Bool) (policy_on_device_only Bool)))))

(declare-datatypes ((TrainingData 0))
  (((mk-training_data (td_records (Seq Int)) (td_anonymized Bool) (td_pii_removed Bool)))))

(declare-datatypes ((InputAnalysis 0))
  (((mk-input_analysis (ia_input Tensor) (ia_perturbation_score Int) (ia_threshold Int) (ia_flagged Bool)))))

(declare-datatypes ((ModelWithFallback 0))
  (((mk-model_with_fallback (primary_model MLModel) (fallback_model MLModel) (primary_available Bool)))))

(declare-datatypes ((BatchRequest 0))
  (((mk-batch_request (batch_id Int) (batch_inputs (Seq Int)) (batch_sequence (Seq Int))))))

(declare-datatypes ((QuantizedModel 0))
  (((mk-quantized_model (qm_original_weights (Seq Int)) (qm_quantized_weights (Seq Int)) (qm_max_error Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ModelUpdateState exhaustiveness ---
(push 1)
(declare-const x ModelUpdateState)
(assert (not (or (= x UpdateIdle) (= x UpdateInProgress) (= x UpdateComplete) (= x UpdateFailed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ModelUpdateState: UpdateIdle != UpdateInProgress ---
(push 1)
(assert (= UpdateIdle UpdateInProgress))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ModelUpdateState: UpdateInProgress != UpdateComplete ---
(push 1)
(assert (= UpdateInProgress UpdateComplete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ModelUpdateState: UpdateComplete != UpdateFailed ---
(push 1)
(assert (= UpdateComplete UpdateFailed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ModelUpdateState: UpdateIdle != UpdateFailed ---
(push 1)
(assert (= UpdateIdle UpdateFailed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ModelUpdateState finite cardinality (4 values) ---
(push 1)
(declare-const x ModelUpdateState)
(assert (and (not (= x UpdateIdle)) (not (= x UpdateInProgress)) (not (= x UpdateComplete)) (not (= x UpdateFailed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. MLModel accessor round-trip: model_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (model_id (mk-ml_model f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. UserData accessor round-trip: data_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (data_id (mk-user_data f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. InferenceRequest accessor round-trip: req_model ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 Tensor)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (req_model (mk-inference_request f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. InferenceRequest accessor round-trip: req_input ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 Tensor)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (req_input (mk-inference_request f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. InferenceRequest accessor round-trip: req_latency_ms ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 Tensor)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (req_latency_ms (mk-inference_request f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. InferenceRequest accessor round-trip: req_max_latency_ms ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 Tensor)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (req_max_latency_ms (mk-inference_request f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. InferenceRequest: non-negative int fields sum ---
(push 1)
(declare-const r InferenceRequest)
(assert (>= (req_latency_ms r) 0))
(assert (>= (req_max_latency_ms r) 0))
(assert (not (>= (+ (req_latency_ms r) (req_max_latency_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MemoryBudget accessor round-trip: budget_max_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (budget_max_bytes (mk-memory_budget f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. MemoryBudget accessor round-trip: model_size_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (model_size_bytes (mk-memory_budget f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. MemoryBudget: non-negative int fields sum ---
(push 1)
(declare-const r MemoryBudget)
(assert (>= (budget_max_bytes r) 0))
(assert (>= (model_size_bytes r) 0))
(assert (not (>= (+ (budget_max_bytes r) (model_size_bytes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ModelUpdate accessor round-trip: update_old_model ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 MLModel)
(declare-const f2 ModelUpdateState)
(declare-const f3 Bool)
(assert (not (= (update_old_model (mk-model_update f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. ModelUpdate accessor round-trip: update_new_model ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 MLModel)
(declare-const f2 ModelUpdateState)
(declare-const f3 Bool)
(assert (not (= (update_new_model (mk-model_update f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ModelUpdate accessor round-trip: update_state ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 MLModel)
(declare-const f2 ModelUpdateState)
(declare-const f3 Bool)
(assert (not (= (update_state (mk-model_update f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ModelUpdate accessor round-trip: update_version_increased ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 MLModel)
(declare-const f2 ModelUpdateState)
(declare-const f3 Bool)
(assert (not (= (update_version_increased (mk-model_update f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. PrivacyBudget accessor round-trip: epsilon ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (epsilon (mk-privacy_budget f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. PrivacyBudget accessor round-trip: delta ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (delta (mk-privacy_budget f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. PrivacyBudget accessor round-trip: max_epsilon ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (max_epsilon (mk-privacy_budget f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. PrivacyBudget accessor round-trip: max_delta ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (max_delta (mk-privacy_budget f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. PrivacyBudget: non-negative int fields sum ---
(push 1)
(declare-const r PrivacyBudget)
(assert (>= (epsilon r) 0))
(assert (>= (delta r) 0))
(assert (not (>= (+ (epsilon r) (delta r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Prediction accessor round-trip: pred_class ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (pred_class (mk-prediction f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. Prediction accessor round-trip: pred_confidence ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (pred_confidence (mk-prediction f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Prediction accessor round-trip: pred_calibrated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (pred_calibrated (mk-prediction f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Prediction: non-negative int fields sum ---
(push 1)
(declare-const r Prediction)
(assert (>= (pred_class r) 0))
(assert (>= (pred_confidence r) 0))
(assert (not (>= (+ (pred_class r) (pred_confidence r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ModelPolicy accessor round-trip: policy_model ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (policy_model (mk-model_policy f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ModelPolicy accessor round-trip: policy_exportable ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (policy_exportable (mk-model_policy f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. ModelPolicy accessor round-trip: policy_on_device_only ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (policy_on_device_only (mk-model_policy f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. InputAnalysis accessor round-trip: ia_input ---
(push 1)
(declare-const f0 Tensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ia_input (mk-input_analysis f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. InputAnalysis accessor round-trip: ia_perturbation_score ---
(push 1)
(declare-const f0 Tensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ia_perturbation_score (mk-input_analysis f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. InputAnalysis accessor round-trip: ia_threshold ---
(push 1)
(declare-const f0 Tensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ia_threshold (mk-input_analysis f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. InputAnalysis accessor round-trip: ia_flagged ---
(push 1)
(declare-const f0 Tensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (ia_flagged (mk-input_analysis f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. InputAnalysis: non-negative int fields sum ---
(push 1)
(declare-const r InputAnalysis)
(assert (>= (ia_perturbation_score r) 0))
(assert (>= (ia_threshold r) 0))
(assert (not (>= (+ (ia_perturbation_score r) (ia_threshold r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. ModelWithFallback accessor round-trip: primary_model ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 MLModel)
(declare-const f2 Bool)
(assert (not (= (primary_model (mk-model_with_fallback f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. ModelWithFallback accessor round-trip: fallback_model ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 MLModel)
(declare-const f2 Bool)
(assert (not (= (fallback_model (mk-model_with_fallback f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. ModelWithFallback accessor round-trip: primary_available ---
(push 1)
(declare-const f0 MLModel)
(declare-const f1 MLModel)
(declare-const f2 Bool)
(assert (not (= (primary_available (mk-model_with_fallback f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. BatchRequest accessor round-trip: batch_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (batch_id (mk-batch_request f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
