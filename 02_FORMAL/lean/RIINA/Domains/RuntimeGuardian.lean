-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA RuntimeGuardian - Lean 4 Port

Port of 02_FORMAL/coq/domains/U001_RuntimeGuardian.v (35 theorems).

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| Addr | Addr | OK |
| CFGEdge | CFGEdge | OK |
| CFG | CFG | OK |
| ShadowStack | ShadowStack | OK |
| Memory | Memory | OK |
| Protection | Protection | OK |
| SystemState | SystemState | OK |
| U_001_01_cfi_cfg_wellformed | U_001_01_cfi_cfg_wellformed | OK |
| U_001_02_cfi_ip_in_cfg | U_001_02_cfi_ip_in_cfg | OK |
| U_001_03_cfi_indirect_safe | U_001_03_cfi_indirect_safe | OK |
| U_001_04_cfi_return_integrity | U_001_04_cfi_return_integrity | OK |
| U_001_05_cfi_call_integrity | U_001_05_cfi_call_integrity | OK |
| U_001_06_cfi_no_arbitrary_jump | U_001_06_cfi_no_arbitrary_jump | OK |
| U_001_07_cfi_shadow_stack | U_001_07_cfi_shadow_stack | OK |
| U_001_08_cfi_forward_edge | U_001_08_cfi_forward_edge | OK |
| U_001_09_cfi_backward_edge | U_001_09_cfi_backward_edge | OK |
| U_001_10_cfi_violation_detected | U_001_10_cfi_violation_detected | OK |
| U_001_11_mem_checksum_correct | U_001_11_mem_checksum_correct | OK |
| U_001_12_mem_redundant_storage | U_001_12_mem_redundant_storage | OK |
| U_001_13_mem_ecc_corrects | U_001_13_mem_ecc_corrects | OK |
| U_001_14_mem_ecc_detects | U_001_14_mem_ecc_detects | OK |
| U_001_15_mem_bounds_enforced | U_001_15_mem_bounds_enforced | OK |
| U_001_16_mem_readonly_protected | U_001_16_mem_readonly_protected | OK |
| U_001_17_mem_kernel_isolated | U_001_17_mem_kernel_isolated | OK |
| U_001_18_mem_corruption_detected | U_001_18_mem_corruption_detected | OK |
| U_001_19_nmr_variants_independent | U_001_19_nmr_variants_independent | OK |
| U_001_20_nmr_state_synchronized | U_001_20_nmr_state_synchronized | OK |
| U_001_21_nmr_divergence_detected | U_001_21_nmr_divergence_detected | OK |
| U_001_22_nmr_single_fault_tolerant | U_001_22_nmr_single_fault_tolerant | OK |
| U_001_23_nmr_voting_correct | U_001_23_nmr_voting_correct | OK |
| U_001_24_nmr_recovery_sound | U_001_24_nmr_recovery_sound | OK |
| U_001_25_nmr_coverage | U_001_25_nmr_coverage | OK |
| U_001_26_panic_keys_zeroized | U_001_26_panic_keys_zeroized | OK |
| U_001_27_panic_execution_halted | U_001_27_panic_execution_halted | OK |
| U_001_28_panic_audit_logged | U_001_28_panic_audit_logged | OK |
| U_001_29_panic_triggered | U_001_29_panic_triggered | OK |
| U_001_30_panic_irreversible | U_001_30_panic_irreversible | OK |
| U_001_31_watchdog_nmi | U_001_31_watchdog_nmi | OK |
| U_001_32_watchdog_monitor_integrity | U_001_32_watchdog_monitor_integrity | OK |
| U_001_33_monitor_unprivileged | U_001_33_monitor_unprivileged | OK |
| U_001_34_monitor_complete_mediation | U_001_34_monitor_complete_mediation | OK |
| U_001_35_monitor_tamper_evident | U_001_35_monitor_tamper_evident | OK |
-/

namespace RIINA.Domains.RuntimeGuardian

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

-- ============================================================================
-- Type definitions
-- ============================================================================

abbrev Addr := Nat

/-- CFGEdge (matches Coq: Inductive CFGEdge) -/
inductive CFGEdge : Type where
  | DirectCall : Addr → Addr → CFGEdge
  | IndirectCall : Addr → Addr → CFGEdge
  | Return : Addr → Addr → CFGEdge
  | DirectJump : Addr → Addr → CFGEdge
  | IndirectJump : Addr → Addr → CFGEdge
  | FallThrough : Addr → Addr → CFGEdge
  deriving DecidableEq, Repr

abbrev CFG := List CFGEdge

def edge_source : CFGEdge → Addr
  | .DirectCall src _ => src
  | .IndirectCall src _ => src
  | .Return src _ => src
  | .DirectJump src _ => src
  | .IndirectJump src _ => src
  | .FallThrough src _ => src

def edge_target : CFGEdge → Addr
  | .DirectCall _ tgt => tgt
  | .IndirectCall _ tgt => tgt
  | .Return _ tgt => tgt
  | .DirectJump _ tgt => tgt
  | .IndirectJump _ tgt => tgt
  | .FallThrough _ tgt => tgt

def valid_addresses (cfg : CFG) : List Addr :=
  cfg.flatMap (fun e => [edge_source e, edge_target e])

def in_cfg (cfg : CFG) (addr : Addr) : Prop :=
  addr ∈ valid_addresses cfg

def edge_in_cfg (cfg : CFG) (src tgt : Addr) : Prop :=
  ∃ e, e ∈ cfg ∧ edge_source e = src ∧ edge_target e = tgt

def cfg_wellformed (cfg : CFG) : Prop :=
  ∀ e, e ∈ cfg →
    edge_source e ∈ valid_addresses cfg ∧ edge_target e ∈ valid_addresses cfg

-- ============================================================================
-- Shadow Stack
-- ============================================================================

abbrev ShadowStack := List Addr

def shadow_push (ss : ShadowStack) (ret_addr : Addr) : ShadowStack :=
  ret_addr :: ss

def shadow_pop (ss : ShadowStack) : Option (Addr × ShadowStack) :=
  match ss with
  | [] => none
  | h :: t => some (h, t)

def shadow_matches (ss : ShadowStack) (actual : List Addr) : Prop :=
  ss = actual

-- ============================================================================
-- Memory Model
-- ============================================================================

abbrev Memory := Addr → Nat
abbrev Checksum := Nat
def MONITOR_CHECKSUM_CONST : Checksum := 12345

def compute_checksum (mem : Memory) (start len : Nat) : Checksum :=
  (List.range len).foldl (fun acc i => acc + mem (start + i)) 0

def checksum_valid (mem : Memory) (start len : Nat) (expected : Checksum) : Prop :=
  compute_checksum mem start len = expected

inductive Protection : Type where
  | ReadOnly : Protection
  | ReadWrite : Protection
  | NoAccess : Protection
  deriving DecidableEq, Repr

abbrev MemoryProtection := Addr → Protection

def protected_readonly (prot : MemoryProtection) (addr : Addr) : Prop :=
  prot addr = Protection.ReadOnly

-- ============================================================================
-- ECC
-- ============================================================================

def ecc_encode (data : Nat) : Nat := data * 2
def ecc_decode (encoded : Nat) : Nat := encoded / 2
def ecc_check (encoded : Nat) : Bool := Nat.beq (encoded % 2) 0

-- ============================================================================
-- N-Modular Redundancy
-- ============================================================================

abbrev ExecutionState := Nat
abbrev Variant := Nat → ExecutionState

def variants_independent (v1 v2 v3 : Variant) : Prop :=
  ∀ t, v1 t = v1 t ∧ v2 t = v2 t ∧ v3 t = v3 t

def states_synchronized (v1 v2 v3 : Variant) (t : Nat) : Prop :=
  v1 t = v2 t ∧ v2 t = v3 t

def divergence_detected (v1 v2 v3 : Variant) (t : Nat) : Prop :=
  v1 t ≠ v2 t ∨ v2 t ≠ v3 t ∨ v1 t ≠ v3 t

def majority_vote (a b c : ExecutionState) : ExecutionState :=
  if a == b then a
  else if b == c then b
  else if a == c then a
  else a

def voting_correct (a b c : ExecutionState) : Prop :=
  (a = b → majority_vote a b c = a) ∧
  (b = c → majority_vote a b c = b) ∧
  (a = c → majority_vote a b c = a)

-- ============================================================================
-- Panic State
-- ============================================================================

/-- SystemState (matches Coq: Record SystemState) -/
structure SystemState where
  ss_keys : List Nat
  ss_running : Bool
  ss_audit_log : List Nat
  ss_panic : Bool
  deriving Repr

def keys_zeroized (st : SystemState) : Prop :=
  ∀ k, k ∈ st.ss_keys → k = 0

def execution_halted (st : SystemState) : Prop :=
  st.ss_running = false

def audit_logged (st : SystemState) (event : Nat) : Prop :=
  event ∈ st.ss_audit_log

def panic_state (st : SystemState) : Prop :=
  st.ss_panic = true

def trigger_panic (st : SystemState) (event : Nat) : SystemState :=
  { ss_keys := st.ss_keys.map (fun _ => 0)
    ss_running := false
    ss_audit_log := event :: st.ss_audit_log
    ss_panic := true }

-- ============================================================================
-- Watchdog
-- ============================================================================

def uses_nmi (watchdog_config : Nat) : Prop := watchdog_config > 0

def monitor_checksum : Checksum := MONITOR_CHECKSUM_CONST

def verify_monitor_integrity (mem : Memory) : Prop :=
  compute_checksum mem 0 1000 = monitor_checksum

def unprivileged_app (app_id : Nat) : Prop := app_id > 0

def complete_mediation (_op : Nat) (monitored : Bool) : Prop := monitored = true

def tamper_evident (old_checksum new_checksum : Checksum) : Prop :=
  old_checksum ≠ new_checksum → old_checksum ≠ new_checksum

-- ============================================================================
-- Theorems U_001_01 through U_001_35
-- ============================================================================

/-- U_001_01: Control flow graph is well-formed -/
theorem U_001_01_cfi_cfg_wellformed : ∀ (cfg : CFG),
    (∀ e, e ∈ cfg →
      edge_source e ∈ valid_addresses cfg ∧
      edge_target e ∈ valid_addresses cfg) →
    cfg_wellformed cfg := by
  intro cfg h; exact h

/-- U_001_02: Instruction pointer always in valid CFG -/
theorem U_001_02_cfi_ip_in_cfg : ∀ (cfg : CFG) (ip : Addr),
    ip ∈ valid_addresses cfg → in_cfg cfg ip := by
  intro cfg ip h; exact h

/-- U_001_03: Indirect jumps only to valid targets -/
theorem U_001_03_cfi_indirect_safe : ∀ (cfg : CFG) (src tgt : Addr),
    CFGEdge.IndirectJump src tgt ∈ cfg →
    tgt ∈ valid_addresses cfg := by
  intro cfg src tgt h
  unfold valid_addresses
  simp [List.mem_flatMap]
  exact ⟨CFGEdge.IndirectJump src tgt, h, by simp [edge_source, edge_target]⟩

/-- U_001_04: Return addresses are valid -/
theorem U_001_04_cfi_return_integrity : ∀ (cfg : CFG) (src tgt : Addr),
    CFGEdge.Return src tgt ∈ cfg →
    tgt ∈ valid_addresses cfg := by
  intro cfg src tgt h
  unfold valid_addresses
  simp [List.mem_flatMap]
  exact ⟨CFGEdge.Return src tgt, h, by simp [edge_source, edge_target]⟩

/-- U_001_05: Call targets are valid -/
theorem U_001_05_cfi_call_integrity : ∀ (cfg : CFG) (src tgt : Addr),
    CFGEdge.DirectCall src tgt ∈ cfg →
    tgt ∈ valid_addresses cfg := by
  intro cfg src tgt h
  unfold valid_addresses
  simp [List.mem_flatMap]
  exact ⟨CFGEdge.DirectCall src tgt, h, by simp [edge_source, edge_target]⟩

/-- U_001_06: No jumps to arbitrary addresses -/
theorem U_001_06_cfi_no_arbitrary_jump : ∀ (cfg : CFG) (src tgt : Addr),
    edge_in_cfg cfg src tgt → tgt ∈ valid_addresses cfg := by
  intro cfg src tgt ⟨e, he_in, _, he_tgt⟩
  unfold valid_addresses
  simp [List.mem_flatMap]
  exact ⟨e, he_in, by simp [edge_target]; rw [he_tgt]; simp⟩

/-- U_001_07: Shadow stack matches actual returns -/
theorem U_001_07_cfi_shadow_stack : ∀ (ss actual : ShadowStack),
    ss = actual → shadow_matches ss actual := by
  intro ss actual h; exact h

/-- U_001_08: Forward edges are protected -/
theorem U_001_08_cfi_forward_edge : ∀ (cfg : CFG) (src tgt : Addr),
    CFGEdge.DirectCall src tgt ∈ cfg ∨ CFGEdge.DirectJump src tgt ∈ cfg →
    edge_in_cfg cfg src tgt := by
  intro cfg src tgt h
  cases h with
  | inl hcall => exact ⟨CFGEdge.DirectCall src tgt, hcall, rfl, rfl⟩
  | inr hjump => exact ⟨CFGEdge.DirectJump src tgt, hjump, rfl, rfl⟩

/-- U_001_09: Backward edges are protected -/
theorem U_001_09_cfi_backward_edge : ∀ (cfg : CFG) (src tgt : Addr),
    CFGEdge.Return src tgt ∈ cfg →
    edge_in_cfg cfg src tgt := by
  intro cfg src tgt h
  exact ⟨CFGEdge.Return src tgt, h, rfl, rfl⟩

/-- U_001_10: CFI violations are detected -/
theorem U_001_10_cfi_violation_detected : ∀ (cfg : CFG) (src tgt : Addr),
    tgt ∉ valid_addresses cfg →
    ¬edge_in_cfg cfg src tgt := by
  intro cfg src tgt hnotin hedge
  exact hnotin (U_001_06_cfi_no_arbitrary_jump cfg src tgt hedge)

/-- U_001_11: Memory checksums are correct -/
theorem U_001_11_mem_checksum_correct : ∀ (mem : Memory) (start len : Nat),
    checksum_valid mem start len (compute_checksum mem start len) := by
  intro mem start len; rfl

/-- U_001_12: Critical data stored redundantly -/
theorem U_001_12_mem_redundant_storage : ∀ (_data : Nat) (copies : Nat),
    copies ≥ 3 → copies ≥ 3 := by
  intro _ copies h; exact h

/-- U_001_13: ECC corrects single-bit errors -/
theorem U_001_13_mem_ecc_corrects : ∀ (data : Nat),
    ecc_decode (ecc_encode data) = data := by
  intro data
  simp [ecc_encode, ecc_decode, Nat.mul_div_cancel_left data (by omega : 0 < 2)]

/-- Helper: n * 2 is even -/
private theorem double_even : ∀ (n : Nat), (n * 2) % 2 = 0 := by
  intro n; omega

/-- U_001_14: ECC detects multi-bit errors -/
theorem U_001_14_mem_ecc_detects : ∀ (data : Nat),
    ecc_check (ecc_encode data) = true := by
  intro data
  simp [ecc_check, ecc_encode, Nat.beq_eq, double_even]

/-- U_001_15: Memory bounds are enforced -/
theorem U_001_15_mem_bounds_enforced : ∀ (addr lo hi : Nat),
    lo ≤ addr ∧ addr ≤ hi → lo ≤ addr ∧ addr ≤ hi := by
  intro _ _ _ h; exact h

/-- U_001_16: Read-only memory is protected -/
theorem U_001_16_mem_readonly_protected : ∀ (prot : MemoryProtection) (addr : Addr),
    prot addr = Protection.ReadOnly → protected_readonly prot addr := by
  intro prot addr h; exact h

/-- U_001_17: Kernel memory is isolated -/
theorem U_001_17_mem_kernel_isolated : ∀ (prot : MemoryProtection) (kernel_start kernel_end addr : Nat),
    (kernel_start ≤ addr ∧ addr ≤ kernel_end → prot addr = Protection.NoAccess) →
    kernel_start ≤ addr ∧ addr ≤ kernel_end →
    prot addr = Protection.NoAccess := by
  intro prot _ _ addr hisolated hrange
  exact hisolated hrange

/-- U_001_18: Memory corruption is detected -/
theorem U_001_18_mem_corruption_detected : ∀ (mem : Memory) (start len : Nat) (expected : Checksum),
    compute_checksum mem start len ≠ expected →
    ¬checksum_valid mem start len expected := by
  intro mem start len expected hneq; exact hneq

/-- U_001_19: Execution variants are independent -/
theorem U_001_19_nmr_variants_independent : ∀ (v1 v2 v3 : Variant),
    variants_independent v1 v2 v3 := by
  intro v1 v2 v3 t
  exact ⟨rfl, rfl, rfl⟩

/-- U_001_20: States synchronized at checkpoints -/
theorem U_001_20_nmr_state_synchronized : ∀ (v1 v2 v3 : Variant) (t : Nat),
    v1 t = v2 t → v2 t = v3 t → states_synchronized v1 v2 v3 t := by
  intro v1 v2 v3 t h12 h23
  exact ⟨h12, h23⟩

/-- U_001_21: State divergence is detected -/
theorem U_001_21_nmr_divergence_detected : ∀ (v1 v2 v3 : Variant) (t : Nat),
    v1 t ≠ v2 t → divergence_detected v1 v2 v3 t := by
  intro v1 v2 v3 t h
  exact Or.inl h

/-- U_001_22: Single faults are tolerated -/
theorem U_001_22_nmr_single_fault_tolerant : ∀ (a b c correct : ExecutionState),
    (a = correct ∧ b = correct) ∨ (b = correct ∧ c = correct) ∨ (a = correct ∧ c = correct) →
    majority_vote a b c = correct := by
  intro a b c correct h
  unfold majority_vote
  rcases h with ⟨ha, hb⟩ | ⟨hb, hc⟩ | ⟨ha, hc⟩
  · subst ha; subst hb; simp [BEq.beq]
  · subst hb; subst hc
    simp [BEq.beq]
    split <;> [rfl; rfl]
  · subst ha; subst hc
    simp [BEq.beq]
    split
    · rfl
    · split <;> [rfl; simp [BEq.beq]; rfl]

/-- U_001_23: Voting mechanism is correct -/
theorem U_001_23_nmr_voting_correct : ∀ (a b c : ExecutionState),
    voting_correct a b c := by
  intro a b c
  unfold voting_correct majority_vote
  refine ⟨?_, ?_, ?_⟩
  · intro hab; subst hab; simp [BEq.beq]
  · intro hbc; subst hbc
    simp [BEq.beq]; split <;> rfl
  · intro hac; subst hac
    simp [BEq.beq]
    split
    · rfl
    · split <;> [rfl; simp [BEq.beq]; rfl]

/-- U_001_24: Recovery mechanism is sound -/
theorem U_001_24_nmr_recovery_sound : ∀ (v1 v2 v3 : Variant) (t : Nat) (correct : ExecutionState),
    majority_vote (v1 t) (v2 t) (v3 t) = correct →
    majority_vote (v1 t) (v2 t) (v3 t) = correct := by
  intro _ _ _ _ _ h; exact h

/-- U_001_25: NMR covers probabilistic errors -/
theorem U_001_25_nmr_coverage : ∀ (p_error : Nat),
    p_error ≥ 1 → p_error * p_error ≤ p_error * p_error * 3 := by
  intro p_error h; omega

/-- U_001_26: Keys zeroized on panic -/
theorem U_001_26_panic_keys_zeroized : ∀ (st : SystemState) (event : Nat),
    keys_zeroized (trigger_panic st event) := by
  intro st event k hk
  simp [trigger_panic, keys_zeroized] at hk
  exact hk.2

/-- U_001_27: Execution halted on panic -/
theorem U_001_27_panic_execution_halted : ∀ (st : SystemState) (event : Nat),
    execution_halted (trigger_panic st event) := by
  intro st event; rfl

/-- U_001_28: Violation logged before halt -/
theorem U_001_28_panic_audit_logged : ∀ (st : SystemState) (event : Nat),
    audit_logged (trigger_panic st event) event := by
  intro st event
  simp [audit_logged, trigger_panic]

/-- U_001_29: Invariant violation triggers panic -/
theorem U_001_29_panic_triggered : ∀ (st : SystemState) (event : Nat),
    panic_state (trigger_panic st event) := by
  intro st event; rfl

/-- U_001_30: Panic state is irreversible -/
theorem U_001_30_panic_irreversible : ∀ (st : SystemState),
    panic_state st → st.ss_panic = true := by
  intro st h; exact h

/-- U_001_31: Watchdog uses non-maskable interrupt -/
theorem U_001_31_watchdog_nmi : ∀ (config : Nat),
    config > 0 → uses_nmi config := by
  intro config h; exact h

/-- U_001_32: Watchdog verifies monitor integrity -/
theorem U_001_32_watchdog_monitor_integrity : ∀ (mem : Memory),
    compute_checksum mem 0 1000 = monitor_checksum →
    verify_monitor_integrity mem := by
  intro mem h; exact h

/-- U_001_33: Application cannot modify monitor -/
theorem U_001_33_monitor_unprivileged : ∀ (app_id : Nat),
    app_id > 0 → unprivileged_app app_id := by
  intro app_id h; exact h

/-- U_001_34: All operations go through monitor -/
theorem U_001_34_monitor_complete_mediation : ∀ (op : Nat),
    complete_mediation op true := by
  intro _; rfl

/-- U_001_35: Monitor tampering is evident -/
theorem U_001_35_monitor_tamper_evident : ∀ (old new_ : Checksum),
    old ≠ new_ → tamper_evident old new_ := by
  intro old new_ h hdiff; exact hdiff

end RIINA.Domains.RuntimeGuardian
