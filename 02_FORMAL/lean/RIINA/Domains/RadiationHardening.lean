-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA RadiationHardening - Lean 4 Port

Port of 02_FORMAL/coq/domains/RadiationHardening.v (18 theorems).

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| Bit | Bit | OK |
| Word | Word | OK |
| flip_bit | flip_bit | OK |
| apply_seu | apply_seu | OK |
| TMR | TMR | OK |
| majority_vote | majority_vote | OK |
| majority_vote_nat | majority_vote_nat | OK |
| tmr_read | tmr_read | OK |
| tmr_errors | tmr_errors | OK |
| hamming_distance | hamming_distance | OK |
| ECCWord | ECCWord | OK |
| ecc_syndrome | ecc_syndrome | OK |
| Watchdog | Watchdog | OK |
| watchdog_expired | watchdog_expired | OK |
| Checkpoint | Checkpoint | OK |
| CFSignature | CFSignature | OK |
| cf_valid | cf_valid | OK |
| StackFrame | StackFrame | OK |
| canary_valid | canary_valid | OK |
| ScrubState | ScrubState | OK |
| SystemMode | SystemMode | OK |
| mode_eqb | mode_eqb | OK |
| NVersionResult | NVersionResult | OK |
| count_agreements | count_agreements | OK |
| nvr_consensus | nvr_consensus | OK |
| Probability | Probability | OK |
| prob_lt | prob_lt | OK |
| RecoveryMetrics | RecoveryMetrics | OK |
| recovery_within_bound | recovery_within_bound | OK |
| CriticalData | CriticalData | OK |
| cd_consistent | cd_consistent | OK |
| cd_recover | cd_recover | OK |
| restore_checkpoint | restore_checkpoint | OK |
| store_critical | store_critical | OK |
| seu_response | seu_response | OK |
| scrub_effective | scrub_effective | OK |
| DOMAIN_001_01 | DOMAIN_001_01 | OK |
| DOMAIN_001_02 | DOMAIN_001_02 | OK |
| DOMAIN_001_03 | DOMAIN_001_03 | OK |
| DOMAIN_001_04 | DOMAIN_001_04 | OK |
| DOMAIN_001_05 | DOMAIN_001_05 | OK |
| DOMAIN_001_06 | DOMAIN_001_06 | OK |
| DOMAIN_001_07 | DOMAIN_001_07 | OK |
| DOMAIN_001_08 | DOMAIN_001_08 | OK |
| DOMAIN_001_09 | DOMAIN_001_09 | OK |
| DOMAIN_001_09_corrupted | DOMAIN_001_09_corrupted | OK |
| DOMAIN_001_10 | DOMAIN_001_10 | OK |
| DOMAIN_001_11 | DOMAIN_001_11 | OK |
| DOMAIN_001_12 | DOMAIN_001_12 | OK |
| DOMAIN_001_13 | DOMAIN_001_13 | OK |
| DOMAIN_001_14 | DOMAIN_001_14 | OK |
| DOMAIN_001_15 | DOMAIN_001_15 | OK |
| DOMAIN_001_15_single_corruption | DOMAIN_001_15_single_corruption | OK |
| DOMAIN_001_16 | DOMAIN_001_16 | OK |
| DOMAIN_001_17 | DOMAIN_001_17 | OK |
| DOMAIN_001_18 | DOMAIN_001_18 | OK |
-/

namespace RIINA.Domains.RadiationHardening

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

-- ═══════════════════════════════════════════════════════════════════════════
-- Types
-- ═══════════════════════════════════════════════════════════════════════════

/-- Bit representation -/
abbrev Bit := Bool

/-- Word as list of bits -/
abbrev Word := List Bit

/-- Single Event Upset (bit flip) -/
def flip_bit (b : Bit) : Bit := !b

/-- Apply SEU to word at position -/
def apply_seu (w : Word) (pos : Nat) : Word :=
  match w, pos with
  | [], _ => []
  | b :: rest, 0 => flip_bit b :: rest
  | b :: rest, n + 1 => b :: apply_seu rest n

/-- Triple Modular Redundancy -/
structure TMR (A : Type) where
  tmr_copy1 : A
  tmr_copy2 : A
  tmr_copy3 : A
  deriving Repr

/-- Majority vote for booleans -/
def majority_vote (a b c : Bool) : Bool :=
  orb (andb a b) (orb (andb b c) (andb a c))

/-- Majority vote for naturals with equality check -/
def majority_vote_nat (a b c : Nat) : Option Nat :=
  if a == b then some a
  else if b == c then some b
  else if a == c then some a
  else none

/-- TMR read with voting -/
def tmr_read (t : TMR Nat) : Option Nat :=
  majority_vote_nat t.tmr_copy1 t.tmr_copy2 t.tmr_copy3

/-- Count differing copies -/
def tmr_errors (t : TMR Nat) : Nat :=
  let a := t.tmr_copy1
  let b := t.tmr_copy2
  let c := t.tmr_copy3
  (if a == b then 0 else 1) +
  (if b == c then 0 else 1) +
  (if a == c then 0 else 1)

/-- Hamming distance -/
def hamming_distance (w1 w2 : Word) : Nat :=
  match w1, w2 with
  | [], [] => 0
  | b1 :: r1, b2 :: r2 => (if b1 == b2 then 0 else 1) + hamming_distance r1 r2
  | _, _ => 0

/-- Error-correcting code (simplified Hamming) -/
structure ECCWord where
  ecc_data : Word
  ecc_parity : Word
  deriving Repr

/-- Check parity (simplified) -/
def ecc_syndrome (e : ECCWord) : Nat :=
  List.foldl (fun (acc : Nat) (b : Bool) => acc + (if b then 1 else 0)) 0 e.ecc_parity

/-- Watchdog state -/
structure Watchdog where
  wd_counter : Nat
  wd_timeout : Nat
  wd_last_kick : Nat
  deriving Repr

/-- Check if watchdog has expired -/
def watchdog_expired (wd : Watchdog) (current_time : Nat) : Bool :=
  Nat.blt (wd.wd_last_kick + wd.wd_timeout) current_time

/-- Checkpoint -/
structure Checkpoint where
  cp_state : Nat
  cp_timestamp : Nat
  cp_valid : Bool
  deriving Repr

/-- Control flow signature -/
structure CFSignature where
  cfs_expected_next : List Nat
  cfs_current : Nat
  deriving Repr

/-- Check if control flow target is valid -/
def cf_valid (cfs : CFSignature) (actual_next : Nat) : Bool :=
  existsb (fun x => x == actual_next) cfs.cfs_expected_next

/-- Stack frame with canary -/
structure StackFrame where
  sf_canary : Nat
  sf_data : Nat
  sf_expected_canary : Nat
  deriving Repr

/-- Check stack canary validity -/
def canary_valid (sf : StackFrame) : Bool :=
  sf.sf_canary == sf.sf_expected_canary

/-- Memory scrubbing state -/
structure ScrubState where
  scrub_last_addr : Nat
  scrub_errors_found : Nat
  scrub_errors_corrected : Nat
  deriving Repr

/-- Safe mode state -/
inductive SystemMode where
  | NormalMode : SystemMode
  | SafeMode : SystemMode
  | RecoveryMode : SystemMode
  deriving DecidableEq, Repr

/-- System mode equality -/
def mode_eqb (m1 m2 : SystemMode) : Bool :=
  match m1, m2 with
  | .NormalMode, .NormalMode => true
  | .SafeMode, .SafeMode => true
  | .RecoveryMode, .RecoveryMode => true
  | _, _ => false

/-- N-version programming result -/
structure NVersionResult where
  nvr_results : List Nat
  nvr_agreement_threshold : Nat
  deriving Repr

/-- Count agreements for a value in results -/
def count_agreements (results : List Nat) (value : Nat) : Nat :=
  length (results.filter (fun x => x == value))

/-- N-version consensus -/
def nvr_consensus (nvr : NVersionResult) : Option Nat :=
  match nvr.nvr_results with
  | [] => none
  | x :: _ => if Nat.ble nvr.nvr_agreement_threshold (count_agreements nvr.nvr_results x)
               then some x
               else none

/-- Probability representation as rational (num/denom) -/
structure Probability where
  prob_num : Nat
  prob_denom : Nat
  deriving Repr

/-- Probability comparison -/
def prob_lt (p1 p2 : Probability) : Bool :=
  Nat.blt (p1.prob_num * p2.prob_denom) (p2.prob_num * p1.prob_denom)

/-- Recovery time -/
structure RecoveryMetrics where
  rm_mttr : Nat
  rm_requirement : Nat
  deriving Repr

/-- Check recovery within bound -/
def recovery_within_bound (rm : RecoveryMetrics) : Bool :=
  Nat.ble rm.rm_mttr rm.rm_requirement

/-- Critical data with redundancy -/
structure CriticalData where
  cd_primary : Nat
  cd_backup1 : Nat
  cd_backup2 : Nat
  cd_checksum : Nat
  deriving Repr

/-- Check critical data consistency -/
def cd_consistent (cd : CriticalData) : Bool :=
  andb (cd.cd_primary == cd.cd_backup1) (cd.cd_backup1 == cd.cd_backup2)

/-- Recover critical data via majority vote -/
def cd_recover (cd : CriticalData) : Nat :=
  match majority_vote_nat cd.cd_primary cd.cd_backup1 cd.cd_backup2 with
  | some v => v
  | none => cd.cd_primary

/-- Restore checkpoint -/
def restore_checkpoint (cp : Checkpoint) : Option Nat :=
  if cp.cp_valid then some cp.cp_state else none

/-- Store critical value with triple redundancy -/
def store_critical (v : Nat) : TMR Nat := ⟨v, v, v⟩

/-- SEU response -/
def seu_response (seu_detected : Bool) (current_mode : SystemMode) : SystemMode :=
  if seu_detected then SystemMode.SafeMode else current_mode

/-- Scrub effectiveness check -/
def scrub_effective (ss : ScrubState) : Bool :=
  Nat.ble ss.scrub_errors_corrected ss.scrub_errors_found

-- ═══════════════════════════════════════════════════════════════════════════
-- Theorems
-- ═══════════════════════════════════════════════════════════════════════════

/-- DOMAIN_001_01: TMR Correctness - majority vote on identical copies returns the value -/
theorem DOMAIN_001_01 (v : Nat) :
    let t := TMR.mk v v v
    tmr_read t = some v := by
  simp [tmr_read, majority_vote_nat]

/-- DOMAIN_001_02: TMR Voting Function - when at least two copies agree, vote returns a valid value -/
theorem DOMAIN_001_02 (a b c : Nat) (h : a = b ∨ b = c ∨ a = c) :
    ∃ v, majority_vote_nat a b c = some v ∧ (v = a ∨ v = b ∨ v = c) := by
  unfold majority_vote_nat
  rcases h with hab | hbc | hac
  · subst hab; simp
  · subst hbc
    by_cases hab : a == b <;> simp_all [BEq.beq]
  · subst hac
    by_cases hab : a == b <;> simp_all [BEq.beq]

/-- DOMAIN_001_03: ECC Detection - clean parity has zero syndrome -/
theorem DOMAIN_001_03 (data : Word) :
    let ecc_clean := ECCWord.mk data [false, false, false]
    ecc_syndrome ecc_clean = 0 := by
  simp [ecc_syndrome, List.foldl]

/-- DOMAIN_001_04: Hamming Distance - word has zero distance to itself -/
theorem DOMAIN_001_04 (w : Word) :
    hamming_distance w w = 0 := by
  induction w with
  | nil => simp [hamming_distance]
  | cons b rest ih => simp [hamming_distance, ih]

/-- DOMAIN_001_05: Watchdog Timer Expiration - timeout triggers reset -/
theorem DOMAIN_001_05 (wd : Watchdog) (current_time : Nat)
    (h : current_time > wd.wd_last_kick + wd.wd_timeout) :
    watchdog_expired wd current_time = true := by
  simp [watchdog_expired, Nat.blt_eq]
  omega

/-- DOMAIN_001_06: Checkpoint/Rollback Safety - valid checkpoint restores state -/
theorem DOMAIN_001_06 (state timestamp : Nat) :
    let cp := Checkpoint.mk state timestamp true
    restore_checkpoint cp = some state := by
  simp [restore_checkpoint]

/-- DOMAIN_001_07: Critical Variable Triple Storage - 3x redundancy preserved -/
theorem DOMAIN_001_07 (v : Nat) :
    let t := store_critical v
    t.tmr_copy1 = v ∧ t.tmr_copy2 = v ∧ t.tmr_copy3 = v := by
  simp [store_critical]

/-- DOMAIN_001_08: Control Flow Monitoring - valid address accepted -/
theorem DOMAIN_001_08 (cfs : CFSignature) (addr : Nat)
    (h : addr ∈ cfs.cfs_expected_next) :
    cf_valid cfs addr = true := by
  unfold cf_valid existsb
  exact List.any_eq_true.mpr ⟨addr, h, by simp⟩

/-- DOMAIN_001_09: Stack Canary Validity - matching canary is valid -/
theorem DOMAIN_001_09 (canary data : Nat) :
    let sf := StackFrame.mk canary data canary
    canary_valid sf = true := by
  simp [canary_valid]

/-- DOMAIN_001_09_corrupted: Corrupted canary detected -/
theorem DOMAIN_001_09_corrupted (canary data expected : Nat)
    (h : canary ≠ expected) :
    let sf := StackFrame.mk canary data expected
    canary_valid sf = false := by
  simp [canary_valid]
  intro heq
  exact absurd heq h

/-- DOMAIN_001_10: Memory Scrubbing Effectiveness - errors found ≥ corrected -/
theorem DOMAIN_001_10 (addr found corrected : Nat)
    (h : corrected ≤ found) :
    let ss := ScrubState.mk addr found corrected
    scrub_effective ss = true := by
  simp [scrub_effective, Nat.ble_eq]
  omega

/-- DOMAIN_001_11: Safe Mode Transition - SEU triggers safe mode -/
theorem DOMAIN_001_11 (current_mode : SystemMode) :
    seu_response true current_mode = SystemMode.SafeMode := by
  simp [seu_response]

/-- DOMAIN_001_12: Redundant Calculation Verification - N-version agreement -/
theorem DOMAIN_001_12 (v : Nat) (threshold : Nat)
    (h : threshold ≤ 3) :
    let nvr := NVersionResult.mk [v, v, v] threshold
    nvr_consensus nvr = some v := by
  simp [nvr_consensus, count_agreements, length, List.filter, Nat.ble_eq]
  omega

/-- DOMAIN_001_13: Bit-flip Probability Bound -/
theorem DOMAIN_001_13 (p_actual p_threshold : Probability)
    (h : p_actual.prob_num * p_threshold.prob_denom < p_threshold.prob_num * p_actual.prob_denom) :
    prob_lt p_actual p_threshold = true := by
  simp [prob_lt, Nat.blt_eq]
  omega

/-- DOMAIN_001_14: Recovery Time Bound - MTTR ≤ requirement -/
theorem DOMAIN_001_14 (mttr requirement : Nat)
    (h : mttr ≤ requirement) :
    let rm := RecoveryMetrics.mk mttr requirement
    recovery_within_bound rm = true := by
  simp [recovery_within_bound, Nat.ble_eq]
  omega

/-- DOMAIN_001_15: Data Integrity Through Radiation Event - consistent data recovers -/
theorem DOMAIN_001_15 (v : Nat) :
    let cd := CriticalData.mk v v v 0
    cd_recover cd = v := by
  simp [cd_recover, majority_vote_nat]

/-- DOMAIN_001_15_single_corruption: Single corruption still recovers correct value -/
theorem DOMAIN_001_15_single_corruption (v corrupted : Nat) :
    let cd := CriticalData.mk corrupted v v 0
    cd_recover cd = v := by
  simp [cd_recover, majority_vote_nat]
  by_cases h : corrupted == v <;> simp_all [BEq.beq]

/-- DOMAIN_001_16: Majority vote boolean correctness -/
theorem DOMAIN_001_16 (b : Bool) :
    majority_vote b b b = b := by
  cases b <;> simp [majority_vote, orb, andb]

/-- DOMAIN_001_17: Consistent critical data is recoverable -/
theorem DOMAIN_001_17 (v : Nat) (chk : Nat) :
    cd_consistent (CriticalData.mk v v v chk) = true := by
  simp [cd_consistent, andb]

/-- DOMAIN_001_18: Bit flip is self-inverse -/
theorem DOMAIN_001_18 (b : Bit) :
    flip_bit (flip_bit b) = b := by
  cases b <;> simp [flip_bit]

end RIINA.Domains.RadiationHardening
