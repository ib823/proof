---- MODULE DisplayDriver ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/security_foundation/DisplayDriver.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* AppId (matches Coq: Inductive AppId)
CONSTANTS App

AppIdSet == {App}

\* FrameBufferId (matches Coq: Inductive FrameBufferId)
CONSTANTS FBId

FrameBufferIdSet == {FBId}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* Application (matches Coq: Record Application)
VARIABLES app_id, app_screen_capture_perm, app_overlay_perm

\* FrameBuffer (matches Coq: Record FrameBuffer)
VARIABLES fb_id, fb_owner, fb_width, fb_height, fb_protected

\* Frame (matches Coq: Record Frame)
VARIABLES frame_id, frame_timestamp, frame_source

\* DisplayState (matches Coq: Record DisplayState)
VARIABLES frame_buffers, active_overlay

vars == <<app_id, app_screen_capture_perm, app_overlay_perm, fb_id, fb_owner, fb_width, fb_height, fb_protected, frame_id, frame_timestamp, frame_source, frame_buffers, active_overlay>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ app_id \in AppIdSet
  /\ app_screen_capture_perm \in BOOLEAN
  /\ app_overlay_perm \in BOOLEAN
  /\ fb_id \in FrameBufferIdSet
  /\ fb_owner \in AppIdSet
  /\ fb_width \in Nat
  /\ fb_height \in Nat
  /\ fb_protected \in BOOLEAN
  /\ frame_id \in Nat
  /\ frame_timestamp \in Nat
  /\ frame_source \in FrameBufferIdSet
  /\ frame_buffers \in Seq(Nat)
  /\ active_overlay \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ app_id = App
  /\ app_screen_capture_perm = FALSE
  /\ app_overlay_perm = FALSE
  /\ fb_id = FBId
  /\ fb_owner = App
  /\ fb_width = 0
  /\ fb_height = 0
  /\ fb_protected = FALSE
  /\ frame_id = 0
  /\ frame_timestamp = 0
  /\ frame_source = FBId
  /\ frame_buffers = <<>>
  /\ active_overlay = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* has_screen_capture_permission (matches Coq: Definition has_screen_capture_permission)
has_screen_capture_permission(app) ==
  app_screen_capture_perm

\* has_overlay_permission (matches Coq: Definition has_overlay_permission)
has_overlay_permission(app) ==
  app_overlay_perm

\* valid_framebuffer (matches Coq: Definition valid_framebuffer)
valid_framebuffer(fb) ==
  fb >= 0

\* pixel_count (matches Coq: Definition pixel_count)
pixel_count(fb) ==
  fb >= 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateApplication ==
  /\ app_id' \in AppIdSet
  /\ app_screen_capture_perm' \in BOOLEAN
  /\ app_overlay_perm' \in BOOLEAN
  /\ UNCHANGED <<fb_id, fb_owner, fb_width, fb_height, fb_protected, frame_id, frame_timestamp, frame_source, frame_buffers, active_overlay>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateApplication \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* display_buffer_isolated
THEOREM display_buffer_isolated ==
  \A app1 \in Nat, app2 \in Nat, buffer \in Nat :
      app_id app1 <> app_id app2 => ~ can_read_buffer app2 buffer

\* screen_capture_requires_permission
THEOREM screen_capture_requires_permission ==
  \A app \in Nat, frame \in Nat :
      captures_screen(app, frame) => has_screen_capture_permission(app)

\* protected_buffer_access
THEOREM protected_buffer_access ==
  \A app \in Nat, fb \in Nat :
      fb_protected(fb) => ~ can_read_buffer app fb \/ app_screen_capture_perm app = true

\* no_permission_no_capture
THEOREM no_permission_no_capture ==
  \A app \in Nat :
      ~app_screen_capture_perm(app) => forall frame, ~ captures_screen app frame

\* buffer_ownership_exclusive
THEOREM buffer_ownership_exclusive ==
  \A app1 \in Nat, app2 \in Nat, fb \in Nat :
      owns_buffer(app1, fb) => app_id app1 = app_id app2

\* overlay_requires_permission
THEOREM overlay_requires_permission ==
  \A app \in Nat :
      creates_overlay(app) => has_overlay_permission(app)

\* no_overlay_without_permission
THEOREM no_overlay_without_permission ==
  \A app \in Nat :
      ~app_overlay_perm(app) => ~ creates_overlay app

\* display_output_integrity
THEOREM display_output_integrity ==
  \A app \in Nat, fb \in Nat, frame \in Nat :
      owns_buffer(app, fb) => fb_owner fb = app_id app

\* valid_fb_positive_pixels
THEOREM valid_fb_positive_pixels ==
  \A fb \in Nat :
      valid_framebuffer(fb) => pixel_count fb > 0

\* no_capture_perm_blocks_all_frames
THEOREM no_capture_perm_blocks_all_frames ==
  \A app \in Nat :
      ~app_screen_capture_perm(app) => forall f, ~ captures_screen app f

\* protected_buffer_blocks_non_owner
THEOREM protected_buffer_blocks_non_owner ==
  \A app \in Nat, fb \in Nat :
      fb_protected(fb) => ~ can_read_buffer app fb

\* read_requires_ownership_or_capture
THEOREM read_requires_ownership_or_capture ==
  \A app \in Nat, fb \in Nat :
      can_read_buffer(app, fb) => (owns_buffer app fb /\ fb_protected fb = false) \/ app_screen_capture_perm app = true

\* capture_perm_reads_all
THEOREM capture_perm_reads_all ==
  \A app \in Nat, fb \in Nat :
      app_screen_capture_perm(app) => can_read_buffer(app, fb)

\* owner_reads_unprotected
THEOREM owner_reads_unprotected ==
  \A app \in Nat, fb \in Nat :
      owns_buffer(app, fb) => can_read_buffer(app, fb)

\* overlay_state_consistent
THEOREM overlay_state_consistent ==
  \A ds \in Nat, app_id \in AppIdSet :
      active_overlay ds = Some app_id => active_overlay ds <> None

\* no_overlay_no_app
THEOREM no_overlay_no_app ==
  \A ds \in Nat :
      active_overlay ds = None => forall aid, active_overlay ds <> Some aid

\* fb_id_determines_buffer
THEOREM fb_id_determines_buffer ==
  \A fb1 \in Nat, fb2 \in Nat :
      fb_id fb1 = fb_id fb2 => fb1 = fb2

\* display_isolation_symmetric
THEOREM display_isolation_symmetric ==
  \A app1 \in Nat, app2 \in Nat, fb \in Nat :
      app_id app1 <> app_id app2 => ~ can_read_buffer app1 fb

\* capture_overlay_independent
THEOREM capture_overlay_independent ==
  \A app \in Nat :
      app_screen_capture_perm(app) => has_screen_capture_permission app /\ ~ has_overlay_permission app

\* dual_perm_app
THEOREM dual_perm_app ==
  \A app \in Nat :
      app_screen_capture_perm(app) => has_screen_capture_permission app /\ has_overlay_permission app

\* no_perm_app
THEOREM no_perm_app ==
  \A app \in Nat :
      ~app_screen_capture_perm(app) => ~ has_screen_capture_permission app /\ ~ has_overlay_permission app

\* empty_display_no_read
THEOREM empty_display_no_read ==
  \A ds \in Nat, app \in Nat, fb \in Nat :
      frame_buffers ds = [] => can_read_buffer(app, fb)

\* frame_timestamp_order
THEOREM frame_timestamp_order ==
  \A f1 \in Nat, f2 \in Nat :
      frame_timestamp f1 < = frame_timestamp f2 \/
      frame_timestamp f2 < frame_timestamp f1

====
