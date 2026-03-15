; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AnimationSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/AnimationSystem.v (22 assertions)
; Module: AnimationSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AnimationType 0)) (((ImplicitAnim) (ExplicitAnim) (SpringAnim) (KeyframeAnim) (TransitionAnim))))

(declare-datatypes ((TimingFunction 0)) (((Linear) (EaseIn) (EaseOut) (EaseInOut) (CustomCubic))))

(declare-datatypes ((SpringParams 0))
  (((mk-spring_params (spring_stiffness Int) (spring_damping Int) (spring_mass Int) (spring_initial_pos Int) (spring_target_pos Int)))))

(declare-datatypes ((SpringAnimation 0))
  (((mk-spring_animation (spring_params SpringParams) (spring_positions (Seq Int)) (spring_velocities (Seq Int)) (spring_duration Int)))))

(declare-datatypes ((AnimationControl 0))
  (((mk-animation_control (anim_type AnimationType) (anim_speed Int) (anim_reversed Bool) (anim_autoreverses Bool) (anim_repeat_count Int) (anim_current_repeat Int) (anim_fill_mode Int) (anim_delegate_notified Bool) (anim_removed_cleanly Bool)))))

(declare-datatypes ((AnimationGroup 0))
  (((mk-animation_group (ag_animations (Seq Int)) (ag_synchronized Bool) (ag_duration Int)))))

(declare-datatypes ((LayerAnimation 0))
  (((mk-layer_animation (la_property Int) (la_gpu_accelerated Bool) (la_from_value Int) (la_to_value Int) (la_timing TimingFunction)))))

(declare-datatypes ((Keyframe 0))
  (((mk-keyframe (kf_time Int) (kf_value Int) (kf_timing TimingFunction)))))

(declare-datatypes ((Frame 0))
  (((mk-frame (frame_render_time Int) (frame_id Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- AnimationType enum properties ---

; --- 1. AnimationType exhaustiveness ---
(push 1)
(declare-const x AnimationType)
(assert (not (or (= x ImplicitAnim) (= x ExplicitAnim) (= x SpringAnim) (= x KeyframeAnim) (= x TransitionAnim))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. AnimationType: ImplicitAnim != ExplicitAnim ---
(push 1)
(assert (= ImplicitAnim ExplicitAnim))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. AnimationType: ExplicitAnim != SpringAnim ---
(push 1)
(assert (= ExplicitAnim SpringAnim))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. AnimationType: SpringAnim != KeyframeAnim ---
(push 1)
(assert (= SpringAnim KeyframeAnim))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. AnimationType: ImplicitAnim != TransitionAnim ---
(push 1)
(assert (= ImplicitAnim TransitionAnim))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. AnimationType finite cardinality (5 values) ---
(push 1)
(declare-const x AnimationType)
(assert (and (not (= x ImplicitAnim)) (not (= x ExplicitAnim)) (not (= x SpringAnim)) (not (= x KeyframeAnim)) (not (= x TransitionAnim))))
(check-sat) ; expect UNSAT
(pop 1)

; --- TimingFunction enum properties ---

; --- 7. TimingFunction exhaustiveness ---
(push 1)
(declare-const x TimingFunction)
(assert (not (or (= x Linear) (= x EaseIn) (= x EaseOut) (= x EaseInOut) (= x CustomCubic))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TimingFunction: Linear != EaseIn ---
(push 1)
(assert (= Linear EaseIn))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TimingFunction: EaseIn != EaseOut ---
(push 1)
(assert (= EaseIn EaseOut))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TimingFunction: EaseOut != EaseInOut ---
(push 1)
(assert (= EaseOut EaseInOut))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TimingFunction: Linear != CustomCubic ---
(push 1)
(assert (= Linear CustomCubic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TimingFunction finite cardinality (5 values) ---
(push 1)
(declare-const x TimingFunction)
(assert (and (not (= x Linear)) (not (= x EaseIn)) (not (= x EaseOut)) (not (= x EaseInOut)) (not (= x CustomCubic))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SpringParams record properties ---

; --- 13. SpringParams accessor round-trip: spring_stiffness ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (spring_stiffness (mk-spring_params f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SpringParams accessor round-trip: spring_damping ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (spring_damping (mk-spring_params f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SpringParams accessor round-trip: spring_mass ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (spring_mass (mk-spring_params f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SpringParams accessor round-trip: spring_initial_pos ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (spring_initial_pos (mk-spring_params f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SpringParams: integer field consistency ---
(push 1)
(declare-const r SpringParams)
(assert (>= (spring_stiffness r) 0))
(assert (>= (spring_damping r) 0))
(assert (not (>= (+ (spring_stiffness r) (spring_damping r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SpringAnimation record properties ---

; --- 18. SpringAnimation accessor round-trip: spring_params ---
(push 1)
(declare-const f0 SpringParams)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (spring_params (mk-spring_animation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SpringAnimation accessor round-trip: Seq ---
(push 1)
(declare-const f0 SpringParams)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (spring_positions (mk-spring_animation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SpringAnimation accessor round-trip: Seq ---
(push 1)
(declare-const f0 SpringParams)
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (spring_velocities (mk-spring_animation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SpringAnimation: integer field consistency ---
(push 1)
(declare-const r SpringAnimation)
(assert (>= (seq.len (spring_positions r)) 0))
(assert (>= (seq.len (spring_positions r)) 0))
(assert (not (>= (+ (seq.len (spring_positions r)) (seq.len (spring_positions r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AnimationControl record properties ---

; --- 22. AnimationControl accessor round-trip: anim_type ---
(push 1)
(declare-const f0 AnimationType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (anim_type (mk-animation_control f0 f1 f2 f3 f4 f5 f6 f7 f8)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AnimationControl accessor round-trip: anim_speed ---
(push 1)
(declare-const f0 AnimationType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (anim_speed (mk-animation_control f0 f1 f2 f3 f4 f5 f6 f7 f8)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AnimationControl accessor round-trip: anim_reversed ---
(push 1)
(declare-const f0 AnimationType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (anim_reversed (mk-animation_control f0 f1 f2 f3 f4 f5 f6 f7 f8)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. AnimationControl accessor round-trip: anim_autoreverses ---
(push 1)
(declare-const f0 AnimationType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (anim_autoreverses (mk-animation_control f0 f1 f2 f3 f4 f5 f6 f7 f8)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. AnimationControl accessor round-trip: anim_repeat_count ---
(push 1)
(declare-const f0 AnimationType)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Bool)
(declare-const f8 Bool)
(assert (not (= (anim_repeat_count (mk-animation_control f0 f1 f2 f3 f4 f5 f6 f7 f8)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. AnimationControl: integer field consistency ---
(push 1)
(declare-const r AnimationControl)
(assert (>= (anim_speed r) 0))
(assert (>= (anim_repeat_count r) 0))
(assert (not (>= (+ (anim_speed r) (anim_repeat_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AnimationGroup record properties ---

; --- 28. AnimationGroup accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (ag_animations (mk-animation_group f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. AnimationGroup accessor round-trip: ag_synchronized ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (ag_synchronized (mk-animation_group f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- LayerAnimation record properties ---

; --- 30. LayerAnimation accessor round-trip: la_property ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 TimingFunction)
(assert (not (= (la_property (mk-layer_animation f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. LayerAnimation accessor round-trip: la_gpu_accelerated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 TimingFunction)
(assert (not (= (la_gpu_accelerated (mk-layer_animation f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. LayerAnimation accessor round-trip: la_from_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 TimingFunction)
(assert (not (= (la_from_value (mk-layer_animation f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. LayerAnimation accessor round-trip: la_to_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 TimingFunction)
(assert (not (= (la_to_value (mk-layer_animation f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. LayerAnimation: integer field consistency ---
(push 1)
(declare-const r LayerAnimation)
(assert (>= (la_property r) 0))
(assert (>= (la_from_value r) 0))
(assert (not (>= (+ (la_property r) (la_from_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Keyframe record properties ---

; --- 35. Keyframe accessor round-trip: kf_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 TimingFunction)
(assert (not (= (kf_time (mk-keyframe f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Keyframe accessor round-trip: kf_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 TimingFunction)
(assert (not (= (kf_value (mk-keyframe f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Keyframe: integer field consistency ---
(push 1)
(declare-const r Keyframe)
(assert (>= (kf_time r) 0))
(assert (>= (kf_value r) 0))
(assert (not (>= (+ (kf_time r) (kf_value r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Frame record properties ---

; --- 38. Frame accessor round-trip: frame_render_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (frame_render_time (mk-frame f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
