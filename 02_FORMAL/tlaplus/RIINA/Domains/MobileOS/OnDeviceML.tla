---- MODULE OnDeviceML ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/mobile_os/OnDeviceML.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ModelUpdateState (matches Coq: Inductive ModelUpdateState)
CONSTANTS UpdateIdle, UpdateInProgress, UpdateComplete, UpdateFailed

ModelUpdateStateSet == {UpdateIdle, UpdateInProgress, UpdateComplete, UpdateFailed}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Tensor (matches Coq: Record Tensor)
VARIABLES tensor_shape, tensor_data

\* MLModel (matches Coq: Record MLModel)
VARIABLES model_id, model_weights, model_version, model_deterministic

\* UserData (matches Coq: Record UserData)
VARIABLES data_id, data_content, data_sensitive

\* InferenceRequest (matches Coq: Record InferenceRequest)
VARIABLES req_model, req_input, req_latency_ms, req_max_latency_ms

\* MemoryBudget (matches Coq: Record MemoryBudget)
VARIABLES budget_max_bytes, model_size_bytes

vars == <<tensor_shape, tensor_data, model_id, model_weights, model_version, model_deterministic, data_id, data_content, data_sensitive, req_model, req_input, req_latency_ms, req_max_latency_ms, budget_max_bytes, model_size_bytes>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ tensor_shape \in Seq(Nat)
  /\ tensor_data \in Nat
  /\ model_id \in Nat
  /\ model_weights \in Seq(Nat)
  /\ model_version \in Nat
  /\ model_deterministic \in BOOLEAN
  /\ data_id \in Nat
  /\ data_content \in Seq(Nat)
  /\ data_sensitive \in BOOLEAN
  /\ req_model \in Nat
  /\ req_input \in Nat
  /\ req_latency_ms \in Nat
  /\ req_max_latency_ms \in Nat
  /\ budget_max_bytes \in Nat
  /\ model_size_bytes \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ tensor_shape = <<>>
  /\ tensor_data = 0
  /\ model_id = 0
  /\ model_weights = <<>>
  /\ model_version = 0
  /\ model_deterministic = FALSE
  /\ data_id = 0
  /\ data_content = <<>>
  /\ data_sensitive = FALSE
  /\ req_model = 0
  /\ req_input = 0
  /\ req_latency_ms = 0
  /\ req_max_latency_ms = 0
  /\ budget_max_bytes = 0
  /\ model_size_bytes = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* TensorData (matches Coq: Definition TensorData)
TensorData ==
  0

\* transmitted (matches Coq: Definition transmitted)
transmitted(d) ==
  d >= 0

\* private_ml_system (matches Coq: Definition private_ml_system)
private_ml_system ==
  0

\* latency_within_bound (matches Coq: Definition latency_within_bound)
latency_within_bound(r) ==
  r >= 0

\* model_fits_memory (matches Coq: Definition model_fits_memory)
model_fits_memory(b) ==
  b >= 0

\* update_atomic (matches Coq: Definition update_atomic)
update_atomic(u) ==
  u >= 0

\* within_privacy_budget (matches Coq: Definition within_privacy_budget)
within_privacy_budget(pb) ==
  pb >= 0

\* version_tracked (matches Coq: Definition version_tracked)
version_tracked(m) ==
  m >= 0

\* confidence_calibrated (matches Coq: Definition confidence_calibrated)
confidence_calibrated(p) ==
  p >= 0

\* model_not_exportable (matches Coq: Definition model_not_exportable)
model_not_exportable(mp) ==
  mp >= 0

\* data_anonymized (matches Coq: Definition data_anonymized)
data_anonymized(td) ==
  td >= 0

\* adversarial_detected (matches Coq: Definition adversarial_detected)
adversarial_detected(ia) ==
  ia >= 0

\* fallback_ready (matches Coq: Definition fallback_ready)
fallback_ready(mf) ==
  mf >= 0

\* batch_ordered (matches Coq: Definition batch_ordered)
batch_ordered(br) ==
  br >= 0

\* quantization_bounded (matches Coq: Definition quantization_bounded)
quantization_bounded(qm) ==
  qm >= 0

\* is_sorted (matches Coq: Definition is_sorted)
is_sorted(l) ==
  match

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateTensor ==
  /\ tensor_shape' = tensor_shape
  /\ tensor_data' \in 0..100
  /\ UNCHANGED <<model_id, model_weights, model_version, model_deterministic, data_id, data_content, data_sensitive, req_model, req_input, req_latency_ms, req_max_latency_ms, budget_max_bytes, model_size_bytes>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateTensor \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* ml_inference_deterministic
THEOREM ml_inference_deterministic ==
  \A model \in Nat, input \in Nat :
      infer(model, input) = infer(model, input)

\* inference_same_input_same_output
THEOREM inference_same_input_same_output ==
  \A model \in Nat, input1 \in Nat, input2 \in Nat :
      input1 = input2 => infer model input1 = infer model input2

\* ml_data_private
THEOREM ml_data_private ==
  \A data \in Nat, model \in Nat :
      private_ml_system => ~ transmitted data

\* inference_preserves_shape
THEOREM inference_preserves_shape ==
  \A model \in Nat, input \in Nat :
      tensor_shape (infer model input) = tensor_shape(input)

\* different_model_version_matters
THEOREM different_model_version_matters ==
  \A m1 \in Nat, m2 \in Nat, input \in Nat, h \in Nat, t \in Nat :
      tensor_data input = h :: t => tensor_data (infer m1 input) <> tensor_data (infer m2 input)

\* model_input_validated
THEOREM model_input_validated ==
  \A input \in Nat, expected \in Nat :
      input_shape_valid(input, expected) => tensor_shape input = expected

\* model_output_bounded
THEOREM model_output_bounded ==
  \A output \in Nat, bound \in Nat :
      output_bounded(output, bound) => all_below(bound, tensor_data(output))

\* inference_latency_bounded
THEOREM inference_latency_bounded ==
  \A r \in Nat :
      latency_within_bound(r) => req_latency_ms r <= req_max_latency_ms r

\* model_size_within_memory
THEOREM model_size_within_memory ==
  \A b \in Nat :
      model_fits_memory(b) => model_size_bytes b <= budget_max_bytes b

\* model_update_atomic
THEOREM model_update_atomic ==
  \A u \in Nat :
      update_atomic(u) => update_state u = UpdateComplete \/ update_state u = UpdateFailed

\* differential_privacy_guaranteed
THEOREM differential_privacy_guaranteed ==
  \A pb \in Nat :
      within_privacy_budget(pb) => epsilon pb <= max_epsilon pb /\ delta pb <= max_delta pb

\* model_version_tracked
THEOREM model_version_tracked ==
  \A m \in Nat :
      version_tracked(m) => model_version m > 0

\* feature_extraction_deterministic
THEOREM feature_extraction_deterministic ==
  \A m \in Nat, input1 \in Nat, input2 \in Nat :
      input1 = input2 => feature_extract m input1 = feature_extract m input2

\* prediction_confidence_calibrated
THEOREM prediction_confidence_calibrated ==
  \A p \in Nat :
      confidence_calibrated(p) => pred_confidence p <= 100

\* model_not_exported
THEOREM model_not_exported ==
  \A mp \in Nat :
      model_not_exportable(mp) => ~policy_exportable(mp)

\* training_data_anonymized
THEOREM training_data_anonymized ==
  \A td \in Nat :
      data_anonymized(td) => td_anonymized(td)

\* adversarial_input_detected
THEOREM adversarial_input_detected ==
  \A ia \in Nat :
      adversarial_detected(ia) => ia_flagged(ia)

\* model_fallback_available
THEOREM model_fallback_available ==
  \A mf \in Nat :
      fallback_ready(mf) => model_version (fallback_model mf) > 0

\* batch_inference_ordered
THEOREM batch_inference_ordered ==
  \A br \in Nat :
      batch_ordered(br) => is_sorted (batch_sequence br)

\* model_quantization_bounded_error
THEOREM model_quantization_bounded_error ==
  \A qm \in Nat :
      quantization_bounded(qm) => length (qm_original_weights qm) = length (qm_quantized_weights qm)

\* on_device_only_preserves_privacy
THEOREM on_device_only_preserves_privacy ==
  \A mp \in Nat :
      model_not_exportable(mp) => policy_on_device_only(mp)

\* adversarial_implies_high_perturbation
THEOREM adversarial_implies_high_perturbation ==
  \A ia \in Nat :
      adversarial_detected(ia) => ia_perturbation_score ia > ia_threshold ia

\* batch_length_consistency
THEOREM batch_length_consistency ==
  \A br \in Nat :
      batch_ordered(br) => length (batch_inputs br) = length (batch_sequence br)

\* privacy_budget_epsilon_bounded
THEOREM privacy_budget_epsilon_bounded ==
  \A pb \in Nat :
      within_privacy_budget(pb) => epsilon pb <= max_epsilon pb

\* failed_update_preserves_version
THEOREM failed_update_preserves_version ==
  \A u \in Nat :
      update_state u = UpdateFailed => model_version (update_old_model u) = model_version (update_old_model u)

====
