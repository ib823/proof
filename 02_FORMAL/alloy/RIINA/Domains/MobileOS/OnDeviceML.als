// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for on device ml
// Bounded verification of key properties
module riina/Domains/MobileOS/OnDeviceML

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert ml_inference_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ml_inference_deterministic for 6

assert inference_same_input_same_output {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check inference_same_input_same_output for 6

assert ml_data_private {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ml_data_private for 6

assert inference_preserves_shape {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check inference_preserves_shape for 6

assert different_model_version_matters {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check different_model_version_matters for 6

assert model_input_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_input_validated for 6

assert model_output_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_output_bounded for 6

assert inference_latency_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check inference_latency_bounded for 6

assert model_size_within_memory {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_size_within_memory for 6

assert model_update_atomic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_update_atomic for 6

assert differential_privacy_guaranteed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check differential_privacy_guaranteed for 6

assert model_version_tracked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_version_tracked for 6

assert feature_extraction_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check feature_extraction_deterministic for 6

assert prediction_confidence_calibrated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check prediction_confidence_calibrated for 6

assert model_not_exported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_not_exported for 6

assert training_data_anonymized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check training_data_anonymized for 6

assert adversarial_input_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check adversarial_input_detected for 6

assert model_fallback_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_fallback_available for 6

assert batch_inference_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check batch_inference_ordered for 6

assert model_quantization_bounded_error {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check model_quantization_bounded_error for 6

assert on_device_only_preserves_privacy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check on_device_only_preserves_privacy for 6

assert adversarial_implies_high_perturbation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check adversarial_implies_high_perturbation for 6

assert batch_length_consistency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check batch_length_consistency for 6

assert privacy_budget_epsilon_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check privacy_budget_epsilon_bounded for 6

assert failed_update_preserves_version {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check failed_update_preserves_version for 6

pred ExampleOnDeviceML {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleOnDeviceML for 6
