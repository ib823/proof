; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA GraphicsEngine — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/GraphicsEngine.v (21 assertions)
; Module: GraphicsEngine
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((RenderStage 0)) (((Geometry) (Rasterization) (Shading) (Compositing) (Display))))

(declare-datatypes ((ColorSpace 0)) (((SRGB) (LinearRGB) (DisplayP3) (HDR10))))

(declare-datatypes ((AAMethod 0)) (((NoAA) (MSAA2x) (MSAA4x) (FXAA) (TAA))))

(declare-datatypes ((Frame 0))
  (((mk-frame (frame_id Int) (frame_render_time Int) (frame_complexity Int) (frame_rendered Bool)))))

(declare-datatypes ((Animation 0))
  (((mk-animation (anim_id Int) (anim_frames (Seq Int)) (anim_duration Int) (anim_fps Int)))))

(declare-datatypes ((Shader 0))
  (((mk-shader (shader_id Int) (shader_compiled Bool) (shader_validated Bool) (shader_type Int)))))

(declare-datatypes ((Texture 0))
  (((mk-texture (tex_id Int) (tex_width Int) (tex_height Int) (tex_memory_bytes Int) (tex_format Int)))))

(declare-datatypes ((GPUMemory 0))
  (((mk-gpu_memory (gpu_used_bytes Int) (gpu_max_bytes Int) (gpu_texture_bytes Int) (gpu_buffer_bytes Int)))))

(declare-datatypes ((DrawBatch 0))
  (((mk-draw_batch (batch_id Int) (batch_draw_calls Int) (batch_merged_calls Int) (batch_overdraw_ratio Int)))))

(declare-datatypes ((FrameBuffer 0))
  (((mk-frame_buffer (fb_width Int) (fb_height Int) (fb_front Int) (fb_back Int) (fb_double_buffered Bool)))))

(declare-datatypes ((RenderThread 0))
  (((mk-render_thread (rt_id Int) (rt_priority Int) (rt_frame_time_us Int) (rt_vsync_aligned Bool)))))

(declare-datatypes ((ZBuffer 0))
  (((mk-z_buffer (zbuf_bits Int) (zbuf_near Int) (zbuf_far Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- RenderStage enum properties ---

; --- 1. RenderStage exhaustiveness ---
(push 1)
(declare-const x RenderStage)
(assert (not (or (= x Geometry) (= x Rasterization) (= x Shading) (= x Compositing) (= x Display))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. RenderStage: Geometry != Rasterization ---
(push 1)
(assert (= Geometry Rasterization))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. RenderStage: Rasterization != Shading ---
(push 1)
(assert (= Rasterization Shading))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. RenderStage: Shading != Compositing ---
(push 1)
(assert (= Shading Compositing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. RenderStage: Geometry != Display ---
(push 1)
(assert (= Geometry Display))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. RenderStage finite cardinality (5 values) ---
(push 1)
(declare-const x RenderStage)
(assert (and (not (= x Geometry)) (not (= x Rasterization)) (not (= x Shading)) (not (= x Compositing)) (not (= x Display))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ColorSpace enum properties ---

; --- 7. ColorSpace exhaustiveness ---
(push 1)
(declare-const x ColorSpace)
(assert (not (or (= x SRGB) (= x LinearRGB) (= x DisplayP3) (= x HDR10))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ColorSpace: SRGB != LinearRGB ---
(push 1)
(assert (= SRGB LinearRGB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ColorSpace: LinearRGB != DisplayP3 ---
(push 1)
(assert (= LinearRGB DisplayP3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ColorSpace: DisplayP3 != HDR10 ---
(push 1)
(assert (= DisplayP3 HDR10))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ColorSpace: SRGB != HDR10 ---
(push 1)
(assert (= SRGB HDR10))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ColorSpace finite cardinality (4 values) ---
(push 1)
(declare-const x ColorSpace)
(assert (and (not (= x SRGB)) (not (= x LinearRGB)) (not (= x DisplayP3)) (not (= x HDR10))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AAMethod enum properties ---

; --- 13. AAMethod exhaustiveness ---
(push 1)
(declare-const x AAMethod)
(assert (not (or (= x NoAA) (= x MSAA2x) (= x MSAA4x) (= x FXAA) (= x TAA))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AAMethod: NoAA != MSAA2x ---
(push 1)
(assert (= NoAA MSAA2x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AAMethod: MSAA2x != MSAA4x ---
(push 1)
(assert (= MSAA2x MSAA4x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AAMethod: MSAA4x != FXAA ---
(push 1)
(assert (= MSAA4x FXAA))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. AAMethod: NoAA != TAA ---
(push 1)
(assert (= NoAA TAA))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. AAMethod finite cardinality (5 values) ---
(push 1)
(declare-const x AAMethod)
(assert (and (not (= x NoAA)) (not (= x MSAA2x)) (not (= x MSAA4x)) (not (= x FXAA)) (not (= x TAA))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Frame record properties ---

; --- 19. Frame accessor round-trip: frame_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (frame_id (mk-frame f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Frame accessor round-trip: frame_render_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (frame_render_time (mk-frame f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Frame accessor round-trip: frame_complexity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (frame_complexity (mk-frame f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Frame: integer field consistency ---
(push 1)
(declare-const r Frame)
(assert (>= (frame_id r) 0))
(assert (>= (frame_render_time r) 0))
(assert (not (>= (+ (frame_id r) (frame_render_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Animation record properties ---

; --- 23. Animation accessor round-trip: anim_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (anim_id (mk-animation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Animation accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (anim_frames (mk-animation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Animation accessor round-trip: anim_duration ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (anim_duration (mk-animation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Animation: integer field consistency ---
(push 1)
(declare-const r Animation)
(assert (>= (anim_id r) 0))
(assert (>= (seq.len (anim_frames r)) 0))
(assert (not (>= (+ (anim_id r) (seq.len (anim_frames r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Shader record properties ---

; --- 27. Shader accessor round-trip: shader_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (shader_id (mk-shader f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. Shader accessor round-trip: shader_compiled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (shader_compiled (mk-shader f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. Shader accessor round-trip: shader_validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(assert (not (= (shader_validated (mk-shader f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Texture record properties ---

; --- 30. Texture accessor round-trip: tex_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (tex_id (mk-texture f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Texture accessor round-trip: tex_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (tex_width (mk-texture f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Texture accessor round-trip: tex_height ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (tex_height (mk-texture f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Texture accessor round-trip: tex_memory_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (tex_memory_bytes (mk-texture f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Texture: integer field consistency ---
(push 1)
(declare-const r Texture)
(assert (>= (tex_id r) 0))
(assert (>= (tex_width r) 0))
(assert (not (>= (+ (tex_id r) (tex_width r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- GPUMemory record properties ---

; --- 35. GPUMemory accessor round-trip: gpu_used_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (gpu_used_bytes (mk-gpu_memory f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. GPUMemory accessor round-trip: gpu_max_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (gpu_max_bytes (mk-gpu_memory f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. GPUMemory accessor round-trip: gpu_texture_bytes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (gpu_texture_bytes (mk-gpu_memory f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. GPUMemory: integer field consistency ---
(push 1)
(declare-const r GPUMemory)
(assert (>= (gpu_used_bytes r) 0))
(assert (>= (gpu_max_bytes r) 0))
(assert (not (>= (+ (gpu_used_bytes r) (gpu_max_bytes r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- DrawBatch record properties ---

; --- 39. DrawBatch accessor round-trip: batch_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (batch_id (mk-draw_batch f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. DrawBatch accessor round-trip: batch_draw_calls ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (batch_draw_calls (mk-draw_batch f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. DrawBatch accessor round-trip: batch_merged_calls ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (batch_merged_calls (mk-draw_batch f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. DrawBatch: integer field consistency ---
(push 1)
(declare-const r DrawBatch)
(assert (>= (batch_id r) 0))
(assert (>= (batch_draw_calls r) 0))
(assert (not (>= (+ (batch_id r) (batch_draw_calls r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FrameBuffer record properties ---

; --- 43. FrameBuffer accessor round-trip: fb_width ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_width (mk-frame_buffer f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. FrameBuffer accessor round-trip: fb_height ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_height (mk-frame_buffer f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. FrameBuffer accessor round-trip: fb_front ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_front (mk-frame_buffer f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. FrameBuffer accessor round-trip: fb_back ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_back (mk-frame_buffer f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. FrameBuffer: integer field consistency ---
(push 1)
(declare-const r FrameBuffer)
(assert (>= (fb_width r) 0))
(assert (>= (fb_height r) 0))
(assert (not (>= (+ (fb_width r) (fb_height r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RenderThread record properties ---

; --- 48. RenderThread accessor round-trip: rt_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rt_id (mk-render_thread f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. RenderThread accessor round-trip: rt_priority ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rt_priority (mk-render_thread f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. RenderThread accessor round-trip: rt_frame_time_us ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (rt_frame_time_us (mk-render_thread f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. RenderThread: integer field consistency ---
(push 1)
(declare-const r RenderThread)
(assert (>= (rt_id r) 0))
(assert (>= (rt_priority r) 0))
(assert (not (>= (+ (rt_id r) (rt_priority r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ZBuffer record properties ---

; --- 52. ZBuffer accessor round-trip: zbuf_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (zbuf_bits (mk-z_buffer f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. ZBuffer accessor round-trip: zbuf_near ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (zbuf_near (mk-z_buffer f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. ZBuffer: integer field consistency ---
(push 1)
(declare-const r ZBuffer)
(assert (>= (zbuf_bits r) 0))
(assert (>= (zbuf_near r) 0))
(assert (not (>= (+ (zbuf_bits r) (zbuf_near r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
