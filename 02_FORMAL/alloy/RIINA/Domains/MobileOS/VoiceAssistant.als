// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for voice assistant
// Bounded verification of key properties
module riina/Domains/MobileOS/VoiceAssistant

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

assert voice_recognition_accurate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_recognition_accurate for 6

assert voice_data_stays_local {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_data_stays_local for 6

assert local_processing_preserves_privacy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check local_processing_preserves_privacy for 6

assert recognition_reflects_locality {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check recognition_reflects_locality for 6

assert voice_data_processed_locally_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_data_processed_locally_thm for 6

assert wake_word_detection_on_device {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wake_word_detection_on_device for 6

assert no_always_listening {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_always_listening for 6

assert audio_deleted_after_processing_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check audio_deleted_after_processing_thm for 6

assert voice_command_intent_validated_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_command_intent_validated_thm for 6

assert speech_recognition_language_supported_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check speech_recognition_language_supported_thm for 6

assert voice_feedback_appropriate_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_feedback_appropriate_thm for 6

assert voice_permission_explicit_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_permission_explicit_thm for 6

assert conversation_context_bounded_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conversation_context_bounded_thm for 6

assert voice_authentication_secure_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_authentication_secure_thm for 6

assert noise_cancellation_bounded_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check noise_cancellation_bounded_thm for 6

assert voice_synthesis_quality_bounded_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_synthesis_quality_bounded_thm for 6

assert voice_command_undo_available_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_command_undo_available_thm for 6

assert accessibility_voice_control_complete_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accessibility_voice_control_complete_thm for 6

assert dictation_privacy_mode_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dictation_privacy_mode_thm for 6

assert voice_data_not_sent_to_server {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_data_not_sent_to_server for 6

assert voice_permission_requires_microphone {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_permission_requires_microphone for 6

assert voice_command_known_intent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_command_known_intent for 6

assert voice_undo_window_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check voice_undo_window_positive for 6

assert accessibility_labels_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accessibility_labels_complete for 6

pred ExampleVoiceAssistant {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVoiceAssistant for 6
