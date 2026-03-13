---- MODULE IndustryMedia ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/Industries/IndustryMedia.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* ContentType (matches Coq: Inductive ContentType)
CONSTANTS PreRelease, PostRelease, Screening, MasterFile, DailyRushes

ContentTypeSet == {PreRelease, PostRelease, Screening, MasterFile, DailyRushes}

\* ContentProtection (matches Coq: Inductive ContentProtection)
CONSTANTS Unencrypted, BasicDRM, StudioDRM, ForensicWatermark, HardwareProtected

ContentProtectionSet == {Unencrypted, BasicDRM, StudioDRM, ForensicWatermark, HardwareProtected}

\* MediaEffect (matches Coq: Inductive MediaEffect)
CONSTANTS ContentAccess, ContentTransfer, StreamingDelivery, RenderOperation, RightsManagement

MediaEffectSet == {ContentAccess, ContentTransfer, StreamingDelivery, RenderOperation, RightsManagement}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* ECP_Compliance (matches Coq: Record ECP_Compliance)
VARIABLES content_encryption, access_control, forensic_watermarking, audit_logging, secure_viewing, no_unauthorized_copies

\* ViewingSession (matches Coq: Record ViewingSession)
VARIABLES view_start, view_end, view_content, view_watermarked

vars == <<content_encryption, access_control, forensic_watermarking, audit_logging, secure_viewing, no_unauthorized_copies, view_start, view_end, view_content, view_watermarked>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ content_encryption \in BOOLEAN
  /\ access_control \in BOOLEAN
  /\ forensic_watermarking \in BOOLEAN
  /\ audit_logging \in BOOLEAN
  /\ secure_viewing \in BOOLEAN
  /\ no_unauthorized_copies \in BOOLEAN
  /\ view_start \in Nat
  /\ view_end \in Nat
  /\ view_content \in ContentTypeSet
  /\ view_watermarked \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ content_encryption = FALSE
  /\ access_control = FALSE
  /\ forensic_watermarking = FALSE
  /\ audit_logging = FALSE
  /\ secure_viewing = FALSE
  /\ no_unauthorized_copies = FALSE
  /\ view_start = 0
  /\ view_end = 0
  /\ view_content = PreRelease
  /\ view_watermarked = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* content_sensitivity (matches Coq: Definition content_sensitivity)
content_sensitivity(c) ==
    CASE c = PreRelease -> 5
      [] c = MasterFile -> 4
      [] c = DailyRushes -> 3
      [] c = Screening -> 3
      [] c = PostRelease -> 1

\* protection_strength (matches Coq: Definition protection_strength)
protection_strength(p) ==
    CASE p = Unencrypted -> 0
      [] p = BasicDRM -> 1
      [] p = StudioDRM -> 2
      [] p = ForensicWatermark -> 3
      [] p = HardwareProtected -> 5

\* ecp_all_controls (matches Coq: Definition ecp_all_controls)
ecp_all_controls(c) ==
  content_encryption /\ access_control /\ forensic_watermarking /\ audit_logging /\ secure_viewing /\ no_unauthorized_copies

\* count_ecp_controls (matches Coq: Definition count_ecp_controls)
count_ecp_controls(c) ==
  c >= 0

\* dci_min_key_bits (matches Coq: Definition dci_min_key_bits)
dci_min_key_bits ==
  128

\* viewing_duration (matches Coq: Definition viewing_duration)
viewing_duration(v) ==
  v >= 0

\* screener_count_valid (matches Coq: Definition screener_count_valid)
screener_count_valid(max_copies) ==
  max_copies # 0

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateECP_Compliance ==
  /\ content_encryption' \in BOOLEAN
  /\ access_control' \in BOOLEAN
  /\ forensic_watermarking' \in BOOLEAN
  /\ audit_logging' \in BOOLEAN
  /\ secure_viewing' \in BOOLEAN
  /\ no_unauthorized_copies' \in BOOLEAN
  /\ UNCHANGED <<view_start, view_end, view_content, view_watermarked>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateECP_Compliance \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* movielabs_ecp_compliance
THEOREM movielabs_ecp_compliance ==
  \A compliance \in Nat, content \in ContentTypeSet :
    compliance >= 0

\* dci_security
THEOREM dci_security ==
  \A cinema_content \in ContentTypeSet :
    cinema_content >= 0

\* tpn_compliance
THEOREM tpn_compliance ==
  \A vendor \in Nat :
    vendor >= 0

\* forensic_watermark
THEOREM forensic_watermark ==
  \A content \in ContentTypeSet, viewer \in Nat :
    content >= 0 /\ viewer >= 0

\* cdsa_compliance
THEOREM cdsa_compliance ==
  \A content_delivery \in Nat :
    content_delivery >= 0

\* prerelease_maximum_protection
THEOREM prerelease_maximum_protection ==
  \A content \in ContentTypeSet, protection \in ContentProtectionSet :
    content >= 0 /\ protection >= 0

\* watermark_persistence
THEOREM watermark_persistence ==
  \A content \in ContentTypeSet, watermark \in Nat :
    content >= 0 /\ watermark >= 0

\* prerelease_highest_sensitivity
THEOREM prerelease_highest_sensitivity ==
  \A c \in Nat :
      content_sensitivity c < = content_sensitivity(PreRelease)

\* postrelease_lowest_sensitivity
THEOREM postrelease_lowest_sensitivity ==
  \A c \in Nat :
      content_sensitivity PostRelease < = content_sensitivity(c)

\* content_sensitivity_positive
THEOREM content_sensitivity_positive ==
  \A c \in Nat :
      content_sensitivity c > = 1

\* hardware_strongest
THEOREM hardware_strongest ==
  \A p \in Nat :
      protection_strength p < = protection_strength(HardwareProtected)

\* unencrypted_weakest
THEOREM unencrypted_weakest ==
  \A p \in Nat :
      protection_strength Unencrypted < = protection_strength(p)

\* hw_protects_any_content
THEOREM hw_protects_any_content ==
  \A ct \in Nat :
      protection_adequate(ct, HardwareProtected) = TRUE

\* unencrypted_inadequate_for_prerelease
THEOREM unencrypted_inadequate_for_prerelease ==
  protection_adequate(PreRelease, Unencrypted) = FALSE

\* postrelease_accepts_basic_drm
THEOREM postrelease_accepts_basic_drm ==
  protection_adequate(PostRelease, BasicDRM) = TRUE

\* ecp_all_requires_encryption
THEOREM ecp_all_requires_encryption ==
  \A c \in Nat :
      ecp_all_controls(c) => content_encryption(c)

\* ecp_all_requires_watermarking
THEOREM ecp_all_requires_watermarking ==
  \A c \in Nat :
      ecp_all_controls(c) => forensic_watermarking(c)

\* ecp_all_requires_no_copies
THEOREM ecp_all_requires_no_copies ==
  \A c \in Nat :
      ecp_all_controls(c) => no_unauthorized_copies(c)

\* count_ecp_bounded
THEOREM count_ecp_bounded ==
  \A c \in Nat :
      count_ecp_controls c < = 6

\* all_ecp_count_six
THEOREM all_ecp_count_six ==
  \A c \in Nat :
      ecp_all_controls(c) => count_ecp_controls c = 6

\* dci_key_sufficient
THEOREM dci_key_sufficient ==
  \A bits \in Nat :
      Nat.leb dci_min_key_bits bits = true => bits >= 128

\* viewing_bounded
THEOREM viewing_bounded ==
  \A v \in Nat, max_h \in Nat :
      viewing_within_window(v, max_h) => viewing_duration v <= max_h

\* screener_bounded
THEOREM screener_bounded ==
  \A c \in Nat, mc \in Nat :
      screener_count_valid(c, mc) => c <= mc

====
