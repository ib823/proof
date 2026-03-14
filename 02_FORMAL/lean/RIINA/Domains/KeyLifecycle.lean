-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA KeyLifecycle - Lean 4 Port

Port of 02_FORMAL/coq/domains/KeyLifecycle.v (25 theorems).

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| KeyState | KeyState | OK |
| KeyType | KeyType | OK |
| KeyMetadata | KeyMetadata | OK |
| GenParams | GenParams | OK |
| RotationRecord | RotationRecord | OK |
| DestructionRecord | DestructionRecord | OK |
| EscrowShare | EscrowShare | OK |
| key_001_entropy_sufficient | key_001_entropy_sufficient | OK |
| key_002_active_usable | key_002_active_usable | OK |
| key_003_valid_transition | key_003_valid_transition | OK |
| key_004_destroyed_unusable | key_004_destroyed_unusable | OK |
| key_005_compromised_unusable | key_005_compromised_unusable | OK |
| key_006_not_expired | key_006_not_expired | OK |
| key_007_rotation_new | key_007_rotation_new | OK |
| key_008_rotation_timing | key_008_rotation_timing | OK |
| key_009_destruction_verified | key_009_destruction_verified | OK |
| key_010_escrow_threshold | key_010_escrow_threshold | OK |
| key_011_escrow_share_index | key_011_escrow_share_index | OK |
| key_012_destruction_method | key_012_destruction_method | OK |
| key_013_symmetric_size | key_013_symmetric_size | OK |
| key_014_asymmetric_size | key_014_asymmetric_size | OK |
| key_015_purpose_bound | key_015_purpose_bound | OK |
| key_016_lifetime | key_016_lifetime | OK |
| key_017_rotation_due | key_017_rotation_due | OK |
| key_018_derivation_depth | key_018_derivation_depth | OK |
| key_019_access_control | key_019_access_control | OK |
| key_020_hsm_storage | key_020_hsm_storage | OK |
| key_021_audit_complete | key_021_audit_complete | OK |
| key_022_backup_encrypted | key_022_backup_encrypted | OK |
| key_023_custodian_diversity | key_023_custodian_diversity | OK |
| key_024_recovery_tested | key_024_recovery_tested | OK |
| key_025_defense_in_depth | key_025_defense_in_depth | OK |
-/

namespace RIINA.Domains.KeyLifecycle

/-- Coq compatibility shim: boolean negation -/
@[inline] private def negb (b : Bool) : Bool := !b
/-- Coq compatibility shim: boolean conjunction -/
@[inline] private def andb (a b : Bool) : Bool := a && b
/-- Coq compatibility shim: boolean disjunction -/
@[inline] private def orb (a b : Bool) : Bool := a || b
/-- Coq compatibility shim: list universal predicate -/
@[inline] private def forallb {α : Type} (f : α → Bool) (xs : List α) : Bool := xs.all f
/-- Coq compatibility shim: list existential predicate -/
@[inline] private def existsb {α : Type} (f : α → Bool) (xs : List α) : Bool := xs.any f
/-- Coq compatibility shim: list length alias -/
@[inline] private def length {α : Type} (xs : List α) : Nat := xs.length
/-- Coq compatibility shim: list head option -/
@[inline] private def hd_error {α : Type} (xs : List α) : Option α := xs.head?
/-- Coq compatibility shim: list find option -/
@[inline] private def find {α : Type} (p : α → Bool) (xs : List α) : Option α := xs.find? p
/-- Coq compatibility shim: pair first projection -/
@[inline] private def fst {α β : Type} (p : α × β) : α := p.1
/-- Coq compatibility shim: pair second projection -/
@[inline] private def snd {α β : Type} (p : α × β) : β := p.2

-- ═══════════════════════════════════════════════════════════════════════
-- SECTION A: KEY STATE MODEL
-- ═══════════════════════════════════════════════════════════════════════

/-- Key states -/
inductive KeyState : Type where
  | PreGeneration : KeyState
  | Active : KeyState
  | Suspended : KeyState
  | Deactivated : KeyState
  | Compromised : KeyState
  | Destroyed : KeyState
  deriving DecidableEq, Repr

/-- Key type -/
inductive KeyType : Type where
  | SymmetricKey : KeyType
  | AsymmetricPrivate : KeyType
  | AsymmetricPublic : KeyType
  | SigningKey : KeyType
  | EncryptionKey : KeyType
  deriving DecidableEq, Repr

/-- Key metadata -/
structure KeyMetadata where
  key_id : Nat
  key_type : KeyType
  key_state : KeyState
  key_created : Nat
  key_expires : Nat
  key_rotated : Nat
  key_entropy_bits : Nat
  deriving DecidableEq, Repr

-- ═══════════════════════════════════════════════════════════════════════
-- SECTION B: KEY OPERATIONS MODEL
-- ═══════════════════════════════════════════════════════════════════════

/-- Key generation parameters -/
structure GenParams where
  gen_type : KeyType
  gen_entropy : Nat
  gen_purpose : Nat
  deriving DecidableEq, Repr

/-- Key rotation record -/
structure RotationRecord where
  rot_old_key : Nat
  rot_new_key : Nat
  rot_timestamp : Nat
  rot_reason : Nat
  deriving DecidableEq, Repr

/-- Key destruction record -/
structure DestructionRecord where
  dest_key_id : Nat
  dest_method : Nat
  dest_verified : Bool
  dest_timestamp : Nat
  deriving DecidableEq, Repr

-- ═══════════════════════════════════════════════════════════════════════
-- SECTION C: KEY ESCROW MODEL
-- ═══════════════════════════════════════════════════════════════════════

/-- Escrow share -/
structure EscrowShare where
  escrow_key_id : Nat
  escrow_share_index : Nat
  escrow_custodian : Nat
  escrow_threshold : Nat
  escrow_total : Nat
  deriving DecidableEq, Repr

-- ═══════════════════════════════════════════════════════════════════════
-- SECTION D: HELPER DEFINITIONS
-- ═══════════════════════════════════════════════════════════════════════

def entropy_sufficient (key : KeyMetadata) (min_entropy : Nat) : Bool :=
  min_entropy ≤ key.key_entropy_bits

def is_usable_state (state : KeyState) : Bool :=
  match state with
  | KeyState.Active => true
  | _ => false

def valid_transition (from_ to : KeyState) : Bool :=
  match from_, to with
  | KeyState.PreGeneration, KeyState.Active => true
  | KeyState.Active, KeyState.Suspended => true
  | KeyState.Active, KeyState.Deactivated => true
  | KeyState.Active, KeyState.Compromised => true
  | KeyState.Suspended, KeyState.Active => true
  | KeyState.Suspended, KeyState.Deactivated => true
  | KeyState.Deactivated, KeyState.Destroyed => true
  | KeyState.Compromised, KeyState.Destroyed => true
  | _, _ => false

def key_not_expired (key : KeyMetadata) (current_time : Nat) : Bool :=
  current_time < key.key_expires

def rotation_valid (rot : RotationRecord) : Bool :=
  !(rot.rot_old_key == rot.rot_new_key)

def rotation_after_creation (key : KeyMetadata) (rot : RotationRecord) : Bool :=
  key.key_created < rot.rot_timestamp

def destruction_verified (dest : DestructionRecord) : Bool :=
  dest.dest_verified

def escrow_threshold_valid (share : EscrowShare) : Bool :=
  (1 ≤ share.escrow_threshold) && (share.escrow_threshold ≤ share.escrow_total)

def escrow_share_index_valid (share : EscrowShare) : Bool :=
  share.escrow_share_index < share.escrow_total

def destruction_method_valid (dest : DestructionRecord) : Bool :=
  dest.dest_method ≤ 2

def symmetric_key_size_ok (bits min_bits : Nat) : Bool :=
  min_bits ≤ bits

def asymmetric_key_size_ok (bits min_bits : Nat) : Bool :=
  min_bits ≤ bits

def purpose_matches (key_purpose allowed_purpose : Nat) : Bool :=
  key_purpose == allowed_purpose

def lifetime_ok (created expires max_lifetime : Nat) : Bool :=
  (expires - created) ≤ max_lifetime

def rotation_due (last_rotation current max_period : Nat) : Bool :=
  max_period < (current - last_rotation)

def derivation_depth_ok (depth max_depth : Nat) : Bool :=
  depth ≤ max_depth

def access_allowed (requester_level required_level : Nat) : Bool :=
  required_level ≤ requester_level

def hsm_stored (hsm_flag : Bool) : Bool := hsm_flag

def audit_complete (operations logged : Nat) : Bool :=
  operations == logged

def backup_encrypted (encryption_key : Nat) : Bool :=
  0 < encryption_key

def custodians_diverse (custodians : List Nat) (min_custodians : Nat) : Bool :=
  min_custodians ≤ custodians.eraseDups.length

def recovery_tested (last_test current max_interval : Nat) : Bool :=
  (current - last_test) ≤ max_interval

def key_layers (entropy state rotation destroy escrow : Bool) : Bool :=
  entropy && (state && (rotation && (destroy && escrow)))

-- ═══════════════════════════════════════════════════════════════════════
-- SECTION E: THEOREMS (KEY-001 through KEY-025)
-- ═══════════════════════════════════════════════════════════════════════

/-- key_001_entropy_sufficient (matches Coq) -/
theorem key_001_entropy_sufficient :
  ∀ (key : KeyMetadata) (min_entropy : Nat),
    entropy_sufficient key min_entropy = true →
    min_entropy ≤ key.key_entropy_bits := by
  intro key min_entropy h
  unfold entropy_sufficient at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_002_active_usable (matches Coq) -/
theorem key_002_active_usable :
  ∀ (key : KeyMetadata),
    key.key_state = KeyState.Active →
    is_usable_state key.key_state = true := by
  intro key h
  rw [h]; rfl

/-- key_003_valid_transition (matches Coq) -/
theorem key_003_valid_transition :
  ∀ (from_ to : KeyState),
    valid_transition from_ to = true →
    valid_transition from_ to = true := by
  intro _ _ h; exact h

/-- key_004_destroyed_unusable (matches Coq) -/
theorem key_004_destroyed_unusable :
  is_usable_state KeyState.Destroyed = false := by
  rfl

/-- key_005_compromised_unusable (matches Coq) -/
theorem key_005_compromised_unusable :
  is_usable_state KeyState.Compromised = false := by
  rfl

/-- key_006_not_expired (matches Coq) -/
theorem key_006_not_expired :
  ∀ (key : KeyMetadata) (current_time : Nat),
    key_not_expired key current_time = true →
    current_time < key.key_expires := by
  intro key current_time h
  unfold key_not_expired at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_007_rotation_new (matches Coq) -/
theorem key_007_rotation_new :
  ∀ (rot : RotationRecord),
    rotation_valid rot = true →
    rot.rot_old_key ≠ rot.rot_new_key := by
  intro rot h
  unfold rotation_valid at h
  simp [beq_iff_eq] at h
  exact h

/-- key_008_rotation_timing (matches Coq) -/
theorem key_008_rotation_timing :
  ∀ (key : KeyMetadata) (rot : RotationRecord),
    rotation_after_creation key rot = true →
    key.key_created < rot.rot_timestamp := by
  intro key rot h
  unfold rotation_after_creation at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_009_destruction_verified (matches Coq) -/
theorem key_009_destruction_verified :
  ∀ (dest : DestructionRecord),
    destruction_verified dest = true →
    dest.dest_verified = true := by
  intro dest h
  unfold destruction_verified at h; exact h

/-- key_010_escrow_threshold (matches Coq) -/
theorem key_010_escrow_threshold :
  ∀ (share : EscrowShare),
    escrow_threshold_valid share = true →
    1 ≤ share.escrow_threshold ∧ share.escrow_threshold ≤ share.escrow_total := by
  intro share h
  unfold escrow_threshold_valid at h
  simp [Bool.and_eq_true, decide_eq_true_eq] at h
  exact h

/-- key_011_escrow_share_index (matches Coq) -/
theorem key_011_escrow_share_index :
  ∀ (share : EscrowShare),
    escrow_share_index_valid share = true →
    share.escrow_share_index < share.escrow_total := by
  intro share h
  unfold escrow_share_index_valid at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_012_destruction_method (matches Coq) -/
theorem key_012_destruction_method :
  ∀ (dest : DestructionRecord),
    destruction_method_valid dest = true →
    dest.dest_method ≤ 2 := by
  intro dest h
  unfold destruction_method_valid at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_013_symmetric_size (matches Coq) -/
theorem key_013_symmetric_size :
  ∀ (bits min_bits : Nat),
    symmetric_key_size_ok bits min_bits = true →
    min_bits ≤ bits := by
  intro bits min_bits h
  unfold symmetric_key_size_ok at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_014_asymmetric_size (matches Coq) -/
theorem key_014_asymmetric_size :
  ∀ (bits min_bits : Nat),
    asymmetric_key_size_ok bits min_bits = true →
    min_bits ≤ bits := by
  intro bits min_bits h
  unfold asymmetric_key_size_ok at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_015_purpose_bound (matches Coq) -/
theorem key_015_purpose_bound :
  ∀ (key_purpose allowed_purpose : Nat),
    purpose_matches key_purpose allowed_purpose = true →
    key_purpose = allowed_purpose := by
  intro key_purpose allowed_purpose h
  unfold purpose_matches at h
  simp [beq_iff_eq] at h; exact h

/-- key_016_lifetime (matches Coq) -/
theorem key_016_lifetime :
  ∀ (created expires max_lifetime : Nat),
    lifetime_ok created expires max_lifetime = true →
    expires - created ≤ max_lifetime := by
  intro created expires max_lifetime h
  unfold lifetime_ok at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_017_rotation_due (matches Coq) -/
theorem key_017_rotation_due :
  ∀ (last_rotation current max_period : Nat),
    rotation_due last_rotation current max_period = true →
    max_period < current - last_rotation := by
  intro last_rotation current max_period h
  unfold rotation_due at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_018_derivation_depth (matches Coq) -/
theorem key_018_derivation_depth :
  ∀ (depth max_depth : Nat),
    derivation_depth_ok depth max_depth = true →
    depth ≤ max_depth := by
  intro depth max_depth h
  unfold derivation_depth_ok at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_019_access_control (matches Coq) -/
theorem key_019_access_control :
  ∀ (requester required : Nat),
    access_allowed requester required = true →
    required ≤ requester := by
  intro requester required h
  unfold access_allowed at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_020_hsm_storage (matches Coq) -/
theorem key_020_hsm_storage :
  ∀ (hsm_flag : Bool),
    hsm_stored hsm_flag = true →
    hsm_flag = true := by
  intro hsm_flag h
  unfold hsm_stored at h; exact h

/-- key_021_audit_complete (matches Coq) -/
theorem key_021_audit_complete :
  ∀ (operations logged : Nat),
    audit_complete operations logged = true →
    operations = logged := by
  intro operations logged h
  unfold audit_complete at h
  simp [beq_iff_eq] at h; exact h

/-- key_022_backup_encrypted (matches Coq) -/
theorem key_022_backup_encrypted :
  ∀ (encryption_key : Nat),
    backup_encrypted encryption_key = true →
    encryption_key > 0 := by
  intro encryption_key h
  unfold backup_encrypted at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_023_custodian_diversity (matches Coq) -/
theorem key_023_custodian_diversity :
  ∀ (custodians : List Nat) (min_custodians : Nat),
    custodians_diverse custodians min_custodians = true →
    min_custodians ≤ custodians.eraseDups.length := by
  intro custodians min_custodians h
  unfold custodians_diverse at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_024_recovery_tested (matches Coq) -/
theorem key_024_recovery_tested :
  ∀ (last_test current max_interval : Nat),
    recovery_tested last_test current max_interval = true →
    current - last_test ≤ max_interval := by
  intro last_test current max_interval h
  unfold recovery_tested at h
  simp [decide_eq_true_eq] at h; exact h

/-- key_025_defense_in_depth (matches Coq) -/
theorem key_025_defense_in_depth :
  ∀ e s r d es,
    key_layers e s r d es = true →
    e = true ∧ s = true ∧ r = true ∧ d = true ∧ es = true := by
  intro e s r d es h
  unfold key_layers at h
  simp [Bool.and_eq_true] at h
  exact ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1, h.2.2.2.2⟩

end RIINA.Domains.KeyLifecycle
