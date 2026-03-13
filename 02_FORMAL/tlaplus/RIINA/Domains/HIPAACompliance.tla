---- MODULE HIPAACompliance ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/HIPAACompliance.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* Role (matches Coq: Inductive Role)
CONSTANTS Physician, Nurse, Admin, Patient, Auditor, Emergency

RoleSet == {Physician, Nurse, Admin, Patient, Auditor, Emergency}

\* PHICategory (matches Coq: Inductive PHICategory)
CONSTANTS Demographics, MedicalHistory, Diagnosis, Treatment, Billing, Genetic

PHICategorySet == {Demographics, MedicalHistory, Diagnosis, Treatment, Billing, Genetic}

\* EncryptionState (matches Coq: Inductive EncryptionState)
CONSTANTS Plaintext, EncryptedAES128, EncryptedAES256

EncryptionStateSet == {Plaintext, EncryptedAES128, EncryptedAES256}

\* TransportSecurity (matches Coq: Inductive TransportSecurity)
CONSTANTS NoTLS, TLS12, TLS13

TransportSecuritySet == {NoTLS, TLS12, TLS13}

\* AuthFactor (matches Coq: Inductive AuthFactor)
CONSTANTS Password, Token, Biometric

AuthFactorSet == {Password, Token, Biometric}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* AuthState (matches Coq: Record AuthState)
VARIABLES auth_factors, auth_user_id, auth_timestamp

\* PHIRecord (matches Coq: Record PHIRecord)
VARIABLES phi_category, phi_patient_id, phi_data, phi_encryption, phi_consent_documented

\* AuditEntry (matches Coq: Record AuditEntry)
VARIABLES audit_timestamp, audit_user_id, audit_action, audit_phi_id, audit_success

\* DisposalRecord (matches Coq: Record DisposalRecord)
VARIABLES disposal_phi_id, disposal_method, disposal_passes, disposal_verified

\* BreachEvent (matches Coq: Record BreachEvent)
VARIABLES breach_detected_time, breach_occurred_time, breach_user_id, breach_phi_ids

vars == <<auth_factors, auth_user_id, auth_timestamp, phi_category, phi_patient_id, phi_data, phi_encryption, phi_consent_documented, audit_timestamp, audit_user_id, audit_action, audit_phi_id, audit_success, disposal_phi_id, disposal_method, disposal_passes, disposal_verified, breach_detected_time, breach_occurred_time, breach_user_id, breach_phi_ids>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ auth_factors \in Seq(Nat)
  /\ auth_user_id \in Nat
  /\ auth_timestamp \in Nat
  /\ phi_category \in PHICategorySet
  /\ phi_patient_id \in Nat
  /\ phi_data \in Nat
  /\ phi_encryption \in EncryptionStateSet
  /\ phi_consent_documented \in BOOLEAN
  /\ audit_timestamp \in Nat
  /\ audit_user_id \in Nat
  /\ audit_action \in Nat
  /\ audit_phi_id \in Nat
  /\ audit_success \in BOOLEAN
  /\ disposal_phi_id \in Nat
  /\ disposal_method \in Nat
  /\ disposal_passes \in Nat
  /\ disposal_verified \in BOOLEAN
  /\ breach_detected_time \in Nat
  /\ breach_occurred_time \in Nat
  /\ breach_user_id \in Nat
  /\ breach_phi_ids \in Seq(Nat)

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ auth_factors = <<>>
  /\ auth_user_id = 0
  /\ auth_timestamp = 0
  /\ phi_category = Demographics
  /\ phi_patient_id = 0
  /\ phi_data = 0
  /\ phi_encryption = Plaintext
  /\ phi_consent_documented = FALSE
  /\ audit_timestamp = 0
  /\ audit_user_id = 0
  /\ audit_action = 0
  /\ audit_phi_id = 0
  /\ audit_success = FALSE
  /\ disposal_phi_id = 0
  /\ disposal_method = 0
  /\ disposal_passes = 0
  /\ disposal_verified = FALSE
  /\ breach_detected_time = 0
  /\ breach_occurred_time = 0
  /\ breach_user_id = 0
  /\ breach_phi_ids = <<>>

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* BREACH_DETECTION_LIMIT_S (matches Coq: Definition BREACH_DETECTION_LIMIT_S)
BREACH_DETECTION_LIMIT_S ==
  0

\* is_hipaa_encrypted (matches Coq: Definition is_hipaa_encrypted)
is_hipaa_encrypted(enc) ==
    CASE enc = EncryptedAES256 -> TRUE
    [] OTHER -> FALSE

\* is_hipaa_transport (matches Coq: Definition is_hipaa_transport)
is_hipaa_transport(ts) ==
    CASE ts = TLS13 -> TRUE
    [] OTHER -> FALSE

\* session_timeout (matches Coq: Definition session_timeout)
session_timeout ==
  300

\* session_expired (matches Coq: Definition session_expired)
session_expired(last_activity) ==
  last_activity >= 0

\* is_mfa (matches Coq: Definition is_mfa)
is_mfa(auth) ==
  auth # 0

\* is_secure_disposal (matches Coq: Definition is_secure_disposal)
is_secure_disposal(d) ==
  match /\ isposal_method /\ physical

\* breach_detection_limit (matches Coq: Definition breach_detection_limit)
breach_detection_limit ==
  0

\* breach_detected_timely (matches Coq: Definition breach_detected_timely)
breach_detected_timely(b) ==
  b >= 0

\* can_disclose (matches Coq: Definition can_disclose)
can_disclose(phi) ==
  phi_consent_documented

\* terminate_session (matches Coq: Definition terminate_session)
terminate_session(s) ==
  s >= 0

\* transmission_secure (matches Coq: Definition transmission_secure)
transmission_secure(t) ==
  trans_security(t) /\ trans_phi(t) /\ trans_verified(t)

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateAuthState ==
  /\ auth_factors' = auth_factors
  /\ auth_user_id' \in 0..100
  /\ auth_timestamp' \in 0..100
  /\ UNCHANGED <<phi_category, phi_patient_id, phi_data, phi_encryption, phi_consent_documented, audit_timestamp, audit_user_id, audit_action, audit_phi_id, audit_success, disposal_phi_id, disposal_method, disposal_passes, disposal_verified, breach_detected_time, breach_occurred_time, breach_user_id, breach_phi_ids>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateAuthState \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* COMPLY_001_01
THEOREM COMPLY_001_01 ==
  \A phi \in Nat :
      is_hipaa_encrypted (phi_encryption phi) = true => phi_encryption phi = EncryptedAES256

\* COMPLY_001_02
THEOREM COMPLY_001_02 ==
  \A ts \in TransportSecuritySet :
      is_hipaa_transport(ts) => ts = TLS13

\* COMPLY_001_03
THEOREM COMPLY_001_03 ==
  \A role \in RoleSet, cat \in PHICategorySet :
      can_access role cat = false => ~ (can_access role cat = true)

\* COMPLY_001_04
THEOREM COMPLY_001_04 ==
  \A log \in Nat, user_id \in Nat, phi_id \in Nat, timestamp \in Nat, action \in Nat, success \in BOOLEAN :
      let new_log : = access_with_audit log user_id phi_id timestamp action success in
      audit_exists_for new_log user_id phi_id = true

\* COMPLY_001_05
THEOREM COMPLY_001_05 ==
  \A role \in RoleSet, requested \in Nat, cat \in PHICategorySet :
      In cat (minimum_necessary_access role requested) => can_access(role, cat)

\* COMPLY_001_06
THEOREM COMPLY_001_06 ==
  \A phi \in Nat :
      can_disclose(phi) => phi_consent_documented(phi)

\* COMPLY_001_07
THEOREM COMPLY_001_07 ==
  \A b \in Nat :
      breach_detected_timely(b) => breach_detected_time b - breach_occurred_time b <= breach_detection_limit

\* COMPLY_001_08
THEOREM COMPLY_001_08 ==
  \A role \in RoleSet, cat \in PHICategorySet :
      authorized_modification(role, cat) => can_access(role, cat)

\* COMPLY_001_09
THEOREM COMPLY_001_09 ==
  \A d \in Nat :
      is_secure_disposal(d) => (disposal_method d = 1) \/
      (disposal_method d = 2) \/
      (disposal_method d = 0 /\ disposal_passes d >= 3)

\* COMPLY_001_10
THEOREM COMPLY_001_10 ==
  \A auth \in Nat :
      is_mfa(auth) => length (auth_factors auth) >= 2

\* COMPLY_001_11
THEOREM COMPLY_001_11 ==
  \A current_time \in Nat, last_activity \in Nat :
      current_time - last_activity > session_timeout => session_expired(current_time, last_activity)

\* COMPLY_001_12
THEOREM COMPLY_001_12 ==
  \A s \in Nat, current_time \in Nat :
      session_is_active(s) => session_is_active (check_and_terminate current_time s) = false

\* COMPLY_001_13
THEOREM COMPLY_001_13 ==
  \A users \in Nat, uid \in Nat, r1 \in RoleSet, r2 \in RoleSet :
      all_unique_ids(users) => r1 = r2

\* COMPLY_001_14
THEOREM COMPLY_001_14 ==
  \A log \in Nat, user_id \in Nat, phi_id \in Nat, timestamp \in Nat, cat \in PHICategorySet :
      let new_log := emergency_access log user_id phi_id timestamp in
      audit_exists_for new_log user_id phi_id = true /\ can_access(Emergency, cat)

\* COMPLY_001_15
THEOREM COMPLY_001_15 ==
  \A t \in Nat :
      transmission_secure(t) => trans_security t = TLS13 /\
      phi_encryption (trans_phi t) = EncryptedAES256 /\
      trans_verified t = true

\* COMPLY_001_16
THEOREM COMPLY_001_16 ==
  \A cat \in PHICategorySet :
      can_access(Physician, cat) = TRUE

\* COMPLY_001_17
THEOREM COMPLY_001_17 ==
  can_access Patient Billing = false /\ can_access Patient MedicalHistory = false /\ can_access Patient Genetic = false

\* COMPLY_001_18
THEOREM COMPLY_001_18 ==
  \A log \in Nat, user_id \in Nat, phi_id \in Nat, timestamp \in Nat, action \in Nat, success \in BOOLEAN :
      let new_log : = access_with_audit log user_id phi_id timestamp action success in
      length new_log = S (length log)

\* COMPLY_001_19
THEOREM COMPLY_001_19 ==
  \A role \in RoleSet, requested \in Nat, cat \in PHICategorySet :
      In cat (minimum_necessary_access role requested) => In cat requested

\* COMPLY_001_20
THEOREM COMPLY_001_20 ==
  \A s \in Nat :
      session_is_active (terminate_session s) = FALSE

\* COMPLY_001_21
THEOREM COMPLY_001_21 ==
  \A enc \in EncryptionStateSet :
      is_hipaa_encrypted(enc) => enc # Plaintext

====
