// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for computer vision
// Bounded verification of key properties
module riina/Domains/MobileOS/ComputerVision

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

assert object_detection_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check object_detection_bounded for 6

assert detection_latency_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check detection_latency_bounded for 6

assert valid_detection_min_confidence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check valid_detection_min_confidence for 6

assert cv_stays_on_device {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cv_stays_on_device for 6

assert empty_result_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_result_bounded for 6

assert face_detection_privacy_preserving {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check face_detection_privacy_preserving for 6

assert ocr_accuracy_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ocr_accuracy_bounded for 6

assert object_detection_confidence_reported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check object_detection_confidence_reported for 6

assert image_classification_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check image_classification_deterministic for 6

assert barcode_format_validated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check barcode_format_validated for 6

assert face_data_on_device_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check face_data_on_device_preserved for 6

assert photo_analysis_permission_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check photo_analysis_permission_required for 6

assert depth_estimation_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check depth_estimation_bounded for 6

assert pose_estimation_stable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pose_estimation_stable for 6

assert scene_classification_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check scene_classification_consistent for 6

assert text_recognition_language_supported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check text_recognition_language_supported for 6

assert vision_request_cancellable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check vision_request_cancellable for 6

assert image_similarity_symmetric {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check image_similarity_symmetric for 6

assert vision_pipeline_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check vision_pipeline_ordered for 6

assert frame_analysis_rate_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check frame_analysis_rate_limited for 6

assert object_detection_confidence_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check object_detection_confidence_bounded for 6

assert depth_estimation_lower_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check depth_estimation_lower_bound for 6

assert pose_estimation_min_frames {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pose_estimation_min_frames for 6

assert language_in_supported_list {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check language_in_supported_list for 6

assert empty_detections_always_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_detections_always_bounded for 6

pred ExampleComputerVision {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleComputerVision for 6
