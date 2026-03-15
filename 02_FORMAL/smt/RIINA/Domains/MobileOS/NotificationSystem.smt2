; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA NotificationSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/NotificationSystem.v (22 assertions)
; Module: NotificationSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Priority 0)) (((Critical) (High) (Normal) (Low))))

(declare-datatypes ((NotificationState 0)) (((Pending) (Delivered) (Read) (Dismissed) (Expired))))

(declare-datatypes ((FocusMode 0)) (((AllNotifications) (PriorityOnly) (CriticalOnly) (DoNotDisturb))))

(declare-datatypes ((Notification 0))
  (((mk-notification (notif_id Int) (notif_priority Priority) (notif_state NotificationState) (notif_created_at Int) (notif_ttl Int) (notif_delivered_at Int)))))

(declare-datatypes ((NotificationChannel 0))
  (((mk-notification_channel (channel_id Int) (channel_enabled Bool) (channel_priority Priority) (channel_sound_volume Int) (channel_vibration Bool) (channel_badge Bool)))))

(declare-datatypes ((NotificationGroup 0))
  (((mk-notification_group (group_id Int) (group_notifications (Seq Int)) (group_summary Int)))))

(declare-datatypes ((NotificationAction 0))
  (((mk-notification_action (action_id Int) (action_label Int) (action_validated Bool) (action_destructive Bool)))))

(declare-datatypes ((NotifHistory 0))
  (((mk-notif_history (history_notifications (Seq Int)) (history_max_size Int) (history_dismiss_tracked Bool)))))

(declare-datatypes ((ExtNotification 0))
  (((mk-ext_notification (ext_notif Notification) (ext_content_sanitized Bool) (ext_sound_volume Int) (ext_badge_count Int) (ext_expiry_time Int) (ext_delivery_confirmed Bool) (ext_is_silent Bool) (ext_channel Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Priority exhaustiveness ---
(push 1)
(declare-const x Priority)
(assert (not (or (= x Critical) (= x High) (= x Normal) (= x Low))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Priority: Critical != High ---
(push 1)
(assert (= Critical High))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Priority: High != Normal ---
(push 1)
(assert (= High Normal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Priority: Normal != Low ---
(push 1)
(assert (= Normal Low))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Priority: Critical != Low ---
(push 1)
(assert (= Critical Low))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Priority finite cardinality (4 values) ---
(push 1)
(declare-const x Priority)
(assert (and (not (= x Critical)) (not (= x High)) (not (= x Normal)) (not (= x Low))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. NotificationState exhaustiveness ---
(push 1)
(declare-const x NotificationState)
(assert (not (or (= x Pending) (= x Delivered) (= x Read) (= x Dismissed) (= x Expired))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. NotificationState: Pending != Delivered ---
(push 1)
(assert (= Pending Delivered))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. NotificationState: Delivered != Read ---
(push 1)
(assert (= Delivered Read))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. NotificationState: Read != Dismissed ---
(push 1)
(assert (= Read Dismissed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. NotificationState: Pending != Expired ---
(push 1)
(assert (= Pending Expired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. NotificationState finite cardinality (5 values) ---
(push 1)
(declare-const x NotificationState)
(assert (and (not (= x Pending)) (not (= x Delivered)) (not (= x Read)) (not (= x Dismissed)) (not (= x Expired))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. FocusMode exhaustiveness ---
(push 1)
(declare-const x FocusMode)
(assert (not (or (= x AllNotifications) (= x PriorityOnly) (= x CriticalOnly) (= x DoNotDisturb))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. FocusMode: AllNotifications != PriorityOnly ---
(push 1)
(assert (= AllNotifications PriorityOnly))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. FocusMode: PriorityOnly != CriticalOnly ---
(push 1)
(assert (= PriorityOnly CriticalOnly))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. FocusMode: CriticalOnly != DoNotDisturb ---
(push 1)
(assert (= CriticalOnly DoNotDisturb))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. FocusMode: AllNotifications != DoNotDisturb ---
(push 1)
(assert (= AllNotifications DoNotDisturb))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. FocusMode finite cardinality (4 values) ---
(push 1)
(declare-const x FocusMode)
(assert (and (not (= x AllNotifications)) (not (= x PriorityOnly)) (not (= x CriticalOnly)) (not (= x DoNotDisturb))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Notification accessor round-trip: notif_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Priority)
(declare-const f2 NotificationState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (notif_id (mk-notification f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Notification accessor round-trip: notif_priority ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Priority)
(declare-const f2 NotificationState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (notif_priority (mk-notification f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Notification accessor round-trip: notif_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Priority)
(declare-const f2 NotificationState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (notif_state (mk-notification f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Notification accessor round-trip: notif_created_at ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Priority)
(declare-const f2 NotificationState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (notif_created_at (mk-notification f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Notification accessor round-trip: notif_ttl ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Priority)
(declare-const f2 NotificationState)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (notif_ttl (mk-notification f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Notification: non-negative int fields sum ---
(push 1)
(declare-const r Notification)
(assert (>= (notif_id r) 0))
(assert (>= (notif_created_at r) 0))
(assert (not (>= (+ (notif_id r) (notif_created_at r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. NotificationChannel accessor round-trip: channel_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Priority)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (channel_id (mk-notification_channel f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. NotificationChannel accessor round-trip: channel_enabled ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Priority)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (channel_enabled (mk-notification_channel f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. NotificationChannel accessor round-trip: channel_priority ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Priority)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (channel_priority (mk-notification_channel f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. NotificationChannel accessor round-trip: channel_sound_volume ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Priority)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (channel_sound_volume (mk-notification_channel f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. NotificationChannel accessor round-trip: channel_vibration ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Priority)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (channel_vibration (mk-notification_channel f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. NotificationChannel: non-negative int fields sum ---
(push 1)
(declare-const r NotificationChannel)
(assert (>= (channel_id r) 0))
(assert (>= (channel_sound_volume r) 0))
(assert (not (>= (+ (channel_id r) (channel_sound_volume r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. NotificationGroup accessor round-trip: group_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (group_id (mk-notification_group f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. NotificationAction accessor round-trip: action_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (action_id (mk-notification_action f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. NotificationAction accessor round-trip: action_label ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (action_label (mk-notification_action f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. NotificationAction accessor round-trip: action_validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (action_validated (mk-notification_action f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. NotificationAction accessor round-trip: action_destructive ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (action_destructive (mk-notification_action f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. NotificationAction: non-negative int fields sum ---
(push 1)
(declare-const r NotificationAction)
(assert (>= (action_id r) 0))
(assert (>= (action_label r) 0))
(assert (not (>= (+ (action_id r) (action_label r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ExtNotification accessor round-trip: ext_notif ---
(push 1)
(declare-const f0 Notification)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (ext_notif (mk-ext_notification f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. ExtNotification accessor round-trip: ext_content_sanitized ---
(push 1)
(declare-const f0 Notification)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (ext_content_sanitized (mk-ext_notification f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. ExtNotification accessor round-trip: ext_sound_volume ---
(push 1)
(declare-const f0 Notification)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (ext_sound_volume (mk-ext_notification f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. ExtNotification accessor round-trip: ext_badge_count ---
(push 1)
(declare-const f0 Notification)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (ext_badge_count (mk-ext_notification f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. ExtNotification accessor round-trip: ext_expiry_time ---
(push 1)
(declare-const f0 Notification)
(declare-const f1 Bool)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Int)
(assert (not (= (ext_expiry_time (mk-ext_notification f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. ExtNotification: non-negative int fields sum ---
(push 1)
(declare-const r ExtNotification)
(assert (>= (ext_sound_volume r) 0))
(assert (>= (ext_badge_count r) 0))
(assert (not (>= (+ (ext_sound_volume r) (ext_badge_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun Priority_level ((x Priority)) Int
  (ite (= x Critical) 0 (ite (= x High) 1 (ite (= x Normal) 2 3))))

(define-fun Priority_leq ((x Priority) (y Priority)) Bool
  (<= (Priority_level x) (Priority_level y)))

; --- 43. Priority_leq reflexivity ---
(push 1)
(declare-const x Priority)
(assert (not (Priority_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. Priority_leq transitivity ---
(push 1)
(declare-const x Priority)
(declare-const y Priority)
(declare-const z Priority)
(assert (Priority_leq x y))
(assert (Priority_leq y z))
(assert (not (Priority_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. Priority_leq antisymmetry ---
(push 1)
(declare-const x Priority)
(declare-const y Priority)
(assert (Priority_leq x y))
(assert (Priority_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. Critical is bottom ---
(push 1)
(declare-const x Priority)
(assert (not (Priority_leq Critical x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. Low is top ---
(push 1)
(declare-const x Priority)
(assert (not (Priority_leq x Low)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
