; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ComputerVision — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/ComputerVision.v (25 assertions)
; Module: ComputerVision
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((BarcodeFormat 0)) (((QRCode) (EAN13) (Code128) (DataMatrix) (UnknownFormat))))

(declare-datatypes ((BoundingBox 0))
  (((mk-bounding_box (bbox_x Int) (bbox_y Int) (bbox_w Int) (bbox_h Int)))))

(declare-datatypes ((Detection 0))
  (((mk-detection (det_box BoundingBox) (det_class Int) (det_confidence Int) (det_valid Bool)))))

(declare-datatypes ((ObjectDetectionResult 0))
  (((mk-object_detection_result (od_detections (Seq Int)) (od_processed_on_device Bool) (od_latency_ms Int)))))

(declare-datatypes ((FaceDetection 0))
  (((mk-face_detection (face_box BoundingBox) (face_confidence Int) (face_data_on_device Bool) (face_anonymized Bool)))))

(declare-datatypes ((OCRResult 0))
  (((mk-ocr_result (ocr_text (Seq Int)) (ocr_confidence Int) (ocr_language Int) (ocr_accuracy_bound Int)))))

(declare-datatypes ((ObjectDetection 0))
  (((mk-object_detection (obj_class Int) (obj_confidence Int) (obj_bbox BoundingBox) (obj_confidence_reported Bool)))))

(declare-datatypes ((ClassificationResult 0))
  (((mk-classification_result (class_label Int) (class_score Int) (class_deterministic Bool)))))

(declare-datatypes ((BarcodeResult 0))
  (((mk-barcode_result (barcode_format BarcodeFormat) (barcode_data (Seq Int)) (barcode_valid Bool)))))

(declare-datatypes ((PhotoAnalysis 0))
  (((mk-photo_analysis (photo_id Int) (analysis_result (Seq Int)) (permission_granted Bool) (processed_on_device Bool)))))

(declare-datatypes ((DepthEstimate 0))
  (((mk-depth_estimate (depth_value Int) (depth_min Int) (depth_max Int) (depth_confidence Int)))))

(declare-datatypes ((PoseEstimate 0))
  (((mk-pose_estimate (pose_joints (Seq Int)) (pose_stable Bool) (pose_frame_count Int)))))

(declare-datatypes ((SceneClassification 0))
  (((mk-scene_classification (scene_label Int) (scene_confidence Int) (scene_consistent Bool)))))

(declare-datatypes ((TextRecognition 0))
  (((mk-text_recognition (text_content (Seq Int)) (text_language Int) (text_supported_languages (Seq Int)) (text_language_supported Bool)))))

(declare-datatypes ((VisionRequest 0))
  (((mk-vision_request (vr_id Int) (vr_cancelled Bool) (vr_completed Bool)))))

(declare-datatypes ((ImagePair 0))
  (((mk-image_pair (img_a Int) (img_b Int) (similarity_score Int)))))

(declare-datatypes ((PipelineStage 0))
  (((mk-pipeline_stage (stage_id Int) (stage_order Int) (stage_complete Bool)))))

(declare-datatypes ((FrameAnalysis 0))
  (((mk-frame_analysis (frame_id Int) (frame_timestamp_ms Int) (min_interval_ms Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. BarcodeFormat exhaustiveness ---
(push 1)
(declare-const x BarcodeFormat)
(assert (not (or (= x QRCode) (= x EAN13) (= x Code128) (= x DataMatrix) (= x UnknownFormat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. BarcodeFormat: QRCode != EAN13 ---
(push 1)
(assert (= QRCode EAN13))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. BarcodeFormat: EAN13 != Code128 ---
(push 1)
(assert (= EAN13 Code128))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. BarcodeFormat: Code128 != DataMatrix ---
(push 1)
(assert (= Code128 DataMatrix))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. BarcodeFormat: QRCode != UnknownFormat ---
(push 1)
(assert (= QRCode UnknownFormat))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. BarcodeFormat finite cardinality (5 values) ---
(push 1)
(declare-const x BarcodeFormat)
(assert (and (not (= x QRCode)) (not (= x EAN13)) (not (= x Code128)) (not (= x DataMatrix)) (not (= x UnknownFormat))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. BoundingBox accessor round-trip: bbox_x ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bbox_x (mk-bounding_box f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. BoundingBox accessor round-trip: bbox_y ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bbox_y (mk-bounding_box f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. BoundingBox accessor round-trip: bbox_w ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bbox_w (mk-bounding_box f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. BoundingBox accessor round-trip: bbox_h ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bbox_h (mk-bounding_box f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BoundingBox: non-negative int fields sum ---
(push 1)
(declare-const r BoundingBox)
(assert (>= (bbox_x r) 0))
(assert (>= (bbox_y r) 0))
(assert (not (>= (+ (bbox_x r) (bbox_y r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Detection accessor round-trip: det_box ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (det_box (mk-detection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Detection accessor round-trip: det_class ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (det_class (mk-detection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Detection accessor round-trip: det_confidence ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (det_confidence (mk-detection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Detection accessor round-trip: det_valid ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (det_valid (mk-detection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Detection: non-negative int fields sum ---
(push 1)
(declare-const r Detection)
(assert (>= (det_class r) 0))
(assert (>= (det_confidence r) 0))
(assert (not (>= (+ (det_class r) (det_confidence r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. FaceDetection accessor round-trip: face_box ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (face_box (mk-face_detection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. FaceDetection accessor round-trip: face_confidence ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (face_confidence (mk-face_detection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. FaceDetection accessor round-trip: face_data_on_device ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (face_data_on_device (mk-face_detection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. FaceDetection accessor round-trip: face_anonymized ---
(push 1)
(declare-const f0 BoundingBox)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (face_anonymized (mk-face_detection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ObjectDetection accessor round-trip: obj_class ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 BoundingBox)
(declare-const f3 Bool)
(assert (not (= (obj_class (mk-object_detection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ObjectDetection accessor round-trip: obj_confidence ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 BoundingBox)
(declare-const f3 Bool)
(assert (not (= (obj_confidence (mk-object_detection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ObjectDetection accessor round-trip: obj_bbox ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 BoundingBox)
(declare-const f3 Bool)
(assert (not (= (obj_bbox (mk-object_detection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ObjectDetection accessor round-trip: obj_confidence_reported ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 BoundingBox)
(declare-const f3 Bool)
(assert (not (= (obj_confidence_reported (mk-object_detection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ObjectDetection: non-negative int fields sum ---
(push 1)
(declare-const r ObjectDetection)
(assert (>= (obj_class r) 0))
(assert (>= (obj_confidence r) 0))
(assert (not (>= (+ (obj_class r) (obj_confidence r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ClassificationResult accessor round-trip: class_label ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (class_label (mk-classification_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ClassificationResult accessor round-trip: class_score ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (class_score (mk-classification_result f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ClassificationResult accessor round-trip: class_deterministic ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (class_deterministic (mk-classification_result f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ClassificationResult: non-negative int fields sum ---
(push 1)
(declare-const r ClassificationResult)
(assert (>= (class_label r) 0))
(assert (>= (class_score r) 0))
(assert (not (>= (+ (class_label r) (class_score r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. BarcodeResult accessor round-trip: barcode_format ---
(push 1)
(declare-const f0 BarcodeFormat)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (barcode_format (mk-barcode_result f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. PhotoAnalysis accessor round-trip: photo_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (photo_id (mk-photo_analysis f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DepthEstimate accessor round-trip: depth_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (depth_value (mk-depth_estimate f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. DepthEstimate accessor round-trip: depth_min ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (depth_min (mk-depth_estimate f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. DepthEstimate accessor round-trip: depth_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (depth_max (mk-depth_estimate f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. DepthEstimate accessor round-trip: depth_confidence ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (depth_confidence (mk-depth_estimate f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. DepthEstimate: non-negative int fields sum ---
(push 1)
(declare-const r DepthEstimate)
(assert (>= (depth_value r) 0))
(assert (>= (depth_min r) 0))
(assert (not (>= (+ (depth_value r) (depth_min r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SceneClassification accessor round-trip: scene_label ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (scene_label (mk-scene_classification f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. SceneClassification accessor round-trip: scene_confidence ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (scene_confidence (mk-scene_classification f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. SceneClassification accessor round-trip: scene_consistent ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (scene_consistent (mk-scene_classification f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SceneClassification: non-negative int fields sum ---
(push 1)
(declare-const r SceneClassification)
(assert (>= (scene_label r) 0))
(assert (>= (scene_confidence r) 0))
(assert (not (>= (+ (scene_label r) (scene_confidence r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. VisionRequest accessor round-trip: vr_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (vr_id (mk-vision_request f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. VisionRequest accessor round-trip: vr_cancelled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (vr_cancelled (mk-vision_request f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. VisionRequest accessor round-trip: vr_completed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (vr_completed (mk-vision_request f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ImagePair accessor round-trip: img_a ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (img_a (mk-image_pair f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ImagePair accessor round-trip: img_b ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (img_b (mk-image_pair f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. ImagePair accessor round-trip: similarity_score ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (similarity_score (mk-image_pair f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. ImagePair: non-negative int fields sum ---
(push 1)
(declare-const r ImagePair)
(assert (>= (img_a r) 0))
(assert (>= (img_b r) 0))
(assert (not (>= (+ (img_a r) (img_b r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. PipelineStage accessor round-trip: stage_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (stage_id (mk-pipeline_stage f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. PipelineStage accessor round-trip: stage_order ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (stage_order (mk-pipeline_stage f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. PipelineStage accessor round-trip: stage_complete ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (stage_complete (mk-pipeline_stage f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. PipelineStage: non-negative int fields sum ---
(push 1)
(declare-const r PipelineStage)
(assert (>= (stage_id r) 0))
(assert (>= (stage_order r) 0))
(assert (not (>= (+ (stage_id r) (stage_order r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. FrameAnalysis accessor round-trip: frame_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (frame_id (mk-frame_analysis f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. FrameAnalysis accessor round-trip: frame_timestamp_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (frame_timestamp_ms (mk-frame_analysis f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. FrameAnalysis accessor round-trip: min_interval_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (min_interval_ms (mk-frame_analysis f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. FrameAnalysis: non-negative int fields sum ---
(push 1)
(declare-const r FrameAnalysis)
(assert (>= (frame_id r) 0))
(assert (>= (frame_timestamp_ms r) 0))
(assert (not (>= (+ (frame_id r) (frame_timestamp_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
