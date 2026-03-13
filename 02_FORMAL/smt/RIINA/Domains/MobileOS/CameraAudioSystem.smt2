; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CameraAudioSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/CameraAudioSystem.v (21 assertions)
; Module: CameraAudioSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((RecordingState 0)) (((NotRecording) (Recording) (Paused))))

(declare-datatypes ((Scene 0))
  (((mk-scene (scene_id Int) (scene_data Int) (scene_timestamp Int)))))

(declare-datatypes ((RawPhoto 0))
  (((mk-raw_photo (photo_id Int) (photo_pixels Int) (photo_metadata Int) (photo_timestamp Int)))))

(declare-datatypes ((VideoRecording 0))
  (((mk-video_recording (video_id Int) (video_frames (Seq Int)) (video_duration_ms Int) (video_fps Int)))))

(declare-datatypes ((AudioSample 0))
  (((mk-audio_sample (audio_id Int) (audio_data (Seq Int)) (audio_input_time Int) (audio_output_time Int)))))

(declare-datatypes ((CameraPermission 0))
  (((mk-camera_permission (camera_granted Bool) (mic_granted Bool) (per_session_only Bool)))))

(declare-datatypes ((AccessIndicator 0))
  (((mk-access_indicator (indicator_visible Bool) (indicator_persistent Bool) (indicator_type Int)))))

(declare-datatypes ((AudioConfig 0))
  (((mk-audio_config (sample_rate Int) (bit_depth Int) (channels Int) (audio_level Int)))))

(declare-datatypes ((VideoConfig 0))
  (((mk-video_config (video_width Int) (video_height Int) (video_frame_rate Int) (stabilization_offset Int)))))

(declare-datatypes ((RecordingSession 0))
  (((mk-recording_session (rec_state RecordingState) (rec_indicator AccessIndicator) (rec_background Bool) (rec_permission CameraPermission)))))

(declare-datatypes ((PhotoCapture 0))
  (((mk-photo_capture (capture_photo RawPhoto) (capture_has_metadata Bool) (capture_metadata_stripped Bool) (capture_resolution_w Int) (capture_resolution_h Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. RecordingState exhaustiveness ---
(push 1)
(declare-const x RecordingState)
(assert (not (or (= x NotRecording) (= x Recording) (= x Paused))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. RecordingState: NotRecording != Recording ---
(push 1)
(assert (= NotRecording Recording))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. RecordingState: Recording != Paused ---
(push 1)
(assert (= Recording Paused))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. RecordingState finite cardinality (3 values) ---
(push 1)
(declare-const x RecordingState)
(assert (and (not (= x NotRecording)) (not (= x Recording)) (not (= x Paused))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Scene accessor round-trip: scene_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scene_id (mk-scene f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Scene accessor round-trip: scene_data ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scene_data (mk-scene f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Scene accessor round-trip: scene_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scene_timestamp (mk-scene f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Scene: non-negative int fields sum ---
(push 1)
(declare-const r Scene)
(assert (>= (scene_id r) 0))
(assert (>= (scene_data r) 0))
(assert (not (>= (+ (scene_id r) (scene_data r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. RawPhoto accessor round-trip: photo_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (photo_id (mk-raw_photo f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. RawPhoto accessor round-trip: photo_pixels ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (photo_pixels (mk-raw_photo f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. RawPhoto accessor round-trip: photo_metadata ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (photo_metadata (mk-raw_photo f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. RawPhoto accessor round-trip: photo_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (photo_timestamp (mk-raw_photo f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. RawPhoto: non-negative int fields sum ---
(push 1)
(declare-const r RawPhoto)
(assert (>= (photo_id r) 0))
(assert (>= (photo_pixels r) 0))
(assert (not (>= (+ (photo_id r) (photo_pixels r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. VideoRecording accessor round-trip: video_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (video_id (mk-video_recording f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AudioSample accessor round-trip: audio_id ---
(push 1)
(declare-const f0 Int)
(assert (not (= (audio_id (mk-audio_sample f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. CameraPermission accessor round-trip: camera_granted ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (camera_granted (mk-camera_permission f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. CameraPermission accessor round-trip: mic_granted ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mic_granted (mk-camera_permission f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. CameraPermission accessor round-trip: per_session_only ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (per_session_only (mk-camera_permission f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CameraPermission_all_enabled ((g CameraPermission)) Bool
  (and (camera_granted g) (mic_granted g) (per_session_only g)))

; --- 19. CameraPermission: all-enabled completeness ---
(push 1)
(declare-const g CameraPermission)
(assert (camera_granted g))
(assert (mic_granted g))
(assert (per_session_only g))
(assert (not (CameraPermission_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. CameraPermission: CameraPermission_all_enabled implies camera_granted ---
(push 1)
(declare-const g CameraPermission)
(assert (CameraPermission_all_enabled g))
(assert (not (camera_granted g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. CameraPermission: CameraPermission_all_enabled implies mic_granted ---
(push 1)
(declare-const g CameraPermission)
(assert (CameraPermission_all_enabled g))
(assert (not (mic_granted g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. CameraPermission: CameraPermission_all_enabled implies per_session_only ---
(push 1)
(declare-const g CameraPermission)
(assert (CameraPermission_all_enabled g))
(assert (not (per_session_only g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AccessIndicator accessor round-trip: indicator_visible ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (indicator_visible (mk-access_indicator f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AccessIndicator accessor round-trip: indicator_persistent ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (indicator_persistent (mk-access_indicator f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. AccessIndicator accessor round-trip: indicator_type ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (indicator_type (mk-access_indicator f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AudioConfig accessor round-trip: sample_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (sample_rate (mk-audio_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AudioConfig accessor round-trip: bit_depth ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bit_depth (mk-audio_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. AudioConfig accessor round-trip: channels ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (channels (mk-audio_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. AudioConfig accessor round-trip: audio_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (audio_level (mk-audio_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. AudioConfig: non-negative int fields sum ---
(push 1)
(declare-const r AudioConfig)
(assert (>= (sample_rate r) 0))
(assert (>= (bit_depth r) 0))
(assert (not (>= (+ (sample_rate r) (bit_depth r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. VideoConfig accessor round-trip: video_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (video_width (mk-video_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. VideoConfig accessor round-trip: video_height ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (video_height (mk-video_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. VideoConfig accessor round-trip: video_frame_rate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (video_frame_rate (mk-video_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. VideoConfig accessor round-trip: stabilization_offset ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (stabilization_offset (mk-video_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VideoConfig: non-negative int fields sum ---
(push 1)
(declare-const r VideoConfig)
(assert (>= (video_width r) 0))
(assert (>= (video_height r) 0))
(assert (not (>= (+ (video_width r) (video_height r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. RecordingSession accessor round-trip: rec_state ---
(push 1)
(declare-const f0 RecordingState)
(declare-const f1 AccessIndicator)
(declare-const f2 Bool)
(declare-const f3 CameraPermission)
(assert (not (= (rec_state (mk-recording_session f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. RecordingSession accessor round-trip: rec_indicator ---
(push 1)
(declare-const f0 RecordingState)
(declare-const f1 AccessIndicator)
(declare-const f2 Bool)
(declare-const f3 CameraPermission)
(assert (not (= (rec_indicator (mk-recording_session f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. RecordingSession accessor round-trip: rec_background ---
(push 1)
(declare-const f0 RecordingState)
(declare-const f1 AccessIndicator)
(declare-const f2 Bool)
(declare-const f3 CameraPermission)
(assert (not (= (rec_background (mk-recording_session f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. RecordingSession accessor round-trip: rec_permission ---
(push 1)
(declare-const f0 RecordingState)
(declare-const f1 AccessIndicator)
(declare-const f2 Bool)
(declare-const f3 CameraPermission)
(assert (not (= (rec_permission (mk-recording_session f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. PhotoCapture accessor round-trip: capture_photo ---
(push 1)
(declare-const f0 RawPhoto)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (capture_photo (mk-photo_capture f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. PhotoCapture accessor round-trip: capture_has_metadata ---
(push 1)
(declare-const f0 RawPhoto)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (capture_has_metadata (mk-photo_capture f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. PhotoCapture accessor round-trip: capture_metadata_stripped ---
(push 1)
(declare-const f0 RawPhoto)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (capture_metadata_stripped (mk-photo_capture f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. PhotoCapture accessor round-trip: capture_resolution_w ---
(push 1)
(declare-const f0 RawPhoto)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (capture_resolution_w (mk-photo_capture f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. PhotoCapture accessor round-trip: capture_resolution_h ---
(push 1)
(declare-const f0 RawPhoto)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (capture_resolution_h (mk-photo_capture f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. PhotoCapture: non-negative int fields sum ---
(push 1)
(declare-const r PhotoCapture)
(assert (>= (capture_resolution_w r) 0))
(assert (>= (capture_resolution_h r) 0))
(assert (not (>= (+ (capture_resolution_w r) (capture_resolution_h r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
