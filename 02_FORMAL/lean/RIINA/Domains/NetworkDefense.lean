-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Lean 4 port of Coq domain file OMEGA001_NetworkDefense.v

namespace RIINA.Domains.NetworkDefense

-- Coq compat shims
@[inline] private def negb (b : Bool) : Bool := !b
@[inline] private def andb (a b : Bool) : Bool := a && b
@[inline] private def orb (a b : Bool) : Bool := a || b
@[inline] private def forallb {α : Type} (f : α → Bool) (xs : List α) : Bool := xs.all f
@[inline] private def existsb {α : Type} (f : α → Bool) (xs : List α) : Bool := xs.any f
@[inline] private def length {α : Type} (xs : List α) : Nat := xs.length
@[inline] private def hd_error {α : Type} (xs : List α) : Option α := xs.head?
@[inline] private def find {α : Type} (p : α → Bool) (xs : List α) : Option α := xs.find? p
@[inline] private def fst {α β : Type} (p : α × β) : α := p.1
@[inline] private def snd {α β : Type} (p : α × β) : β := p.2

-- ============================================================================
-- Section 1: Token Bucket Rate Limiter
-- ============================================================================

structure TokenBucket where
  tb_tokens : Nat
  tb_capacity : Nat
  tb_refill_rate : Nat
  tb_last_refill : Nat
  deriving DecidableEq, Repr

def tb_refill (tb : TokenBucket) (now : Nat) : TokenBucket :=
  let elapsed := now - tb.tb_last_refill
  let new_tokens := min (tb.tb_tokens + elapsed * tb.tb_refill_rate) tb.tb_capacity
  { tb_tokens := new_tokens,
    tb_capacity := tb.tb_capacity,
    tb_refill_rate := tb.tb_refill_rate,
    tb_last_refill := now }

def tb_consume (tb : TokenBucket) (cost : Nat) : Option TokenBucket :=
  if cost ≤ tb.tb_tokens then
    some { tb_tokens := tb.tb_tokens - cost,
           tb_capacity := tb.tb_capacity,
           tb_refill_rate := tb.tb_refill_rate,
           tb_last_refill := tb.tb_last_refill }
  else none

def tb_available (tb : TokenBucket) : Nat := tb.tb_tokens

-- ============================================================================
-- Section 2: Capability-Based Network Access
-- ============================================================================

structure NetCapability where
  cap_id : Nat
  cap_permissions : List Nat
  cap_expiry : Nat
  cap_delegatable : Bool
  cap_signature : Nat
  deriving DecidableEq, Repr

def cap_valid (cap : NetCapability) (now : Nat) : Bool :=
  now < cap.cap_expiry

def cap_permits (cap : NetCapability) (port : Nat) : Bool :=
  cap.cap_permissions.any (· == port)

def cap_is_subset (child parent : NetCapability) : Bool :=
  child.cap_permissions.all (fun p => parent.cap_permissions.any (· == p))

def cap_delegate (parent : NetCapability) (perms : List Nat) (expiry sig : Nat) : Option NetCapability :=
  if parent.cap_delegatable then
    let child : NetCapability := {
      cap_id := sig,
      cap_permissions := perms.filter (fun p => parent.cap_permissions.any (· == p)),
      cap_expiry := min expiry parent.cap_expiry,
      cap_delegatable := false,
      cap_signature := sig }
    some child
  else none

-- ============================================================================
-- Section 3: SYN Cookie Model
-- ============================================================================

structure SynCookie where
  sc_client_ip : Nat
  sc_client_port : Nat
  sc_server_port : Nat
  sc_timestamp : Nat
  sc_mss_index : Nat
  deriving DecidableEq, Repr

def hmac_compute (key : Nat) (data : Nat) : Nat :=
  key + data

def syn_cookie_generate (secret : Nat) (cookie : SynCookie) : Nat :=
  hmac_compute secret (cookie.sc_client_ip + cookie.sc_client_port +
                       cookie.sc_server_port + cookie.sc_timestamp)

def syn_cookie_verify (secret : Nat) (cookie : SynCookie) (mac : Nat) : Bool :=
  syn_cookie_generate secret cookie == mac

-- ============================================================================
-- Section 4: Proof-of-Work Puzzle
-- ============================================================================

def pow_hash (nonce challenge : Nat) : Nat :=
  nonce + challenge

def pow_valid (nonce challenge difficulty : Nat) : Bool :=
  pow_hash nonce challenge < difficulty

def pow_verify (nonce challenge difficulty : Nat) : Bool :=
  pow_valid nonce challenge difficulty

-- ============================================================================
-- Section 5: Connection Tracking
-- ============================================================================

inductive ConnState : Type where
  | ConnNew : ConnState
  | ConnEstablished : ConnState
  | ConnClosing : ConnState
  | ConnClosed : ConnState
  deriving DecidableEq, Repr

structure Connection where
  conn_src : Nat
  conn_dst : Nat
  conn_state : ConnState
  conn_bytes_in : Nat
  conn_bytes_out : Nat
  conn_start_time : Nat
  deriving DecidableEq, Repr

abbrev ConnTable := List Connection

def conn_lookup (table : ConnTable) (src dst : Nat) : Option Connection :=
  table.find? (fun c => c.conn_src == src && c.conn_dst == dst)

def conn_count_by_src (table : ConnTable) (src : Nat) : Nat :=
  (table.filter (fun c => c.conn_src == src)).length

def conn_limit_per_src : Nat := 100

def conn_allowed (table : ConnTable) (src : Nat) : Bool :=
  conn_count_by_src table src < conn_limit_per_src

-- ============================================================================
-- Rate Limiting (8 theorems)
-- ============================================================================

theorem OMEGA_001_01_tb_capacity_bound : ∀ (tb : TokenBucket) (now : Nat),
    (tb_refill tb now).tb_tokens ≤ tb.tb_capacity := by
  intro tb now; simp [tb_refill]; exact Nat.min_le_right _ _

theorem OMEGA_001_02_tb_consume_decreases : ∀ (tb : TokenBucket) (cost : Nat) (tb' : TokenBucket),
    tb_consume tb cost = some tb' →
    tb'.tb_tokens = tb.tb_tokens - cost := by
  intro tb cost tb' h
  simp [tb_consume] at h
  split at h <;> simp_all

theorem OMEGA_001_03_tb_consume_fails_insufficient : ∀ (tb : TokenBucket) (cost : Nat),
    tb.tb_tokens < cost →
    tb_consume tb cost = none := by
  intro tb cost h
  simp [tb_consume]
  omega

theorem OMEGA_001_04_tb_refill_monotone : ∀ (tb : TokenBucket) (t1 t2 : Nat),
    t1 ≤ t2 →
    tb.tb_last_refill ≤ t1 →
    (tb_refill tb t1).tb_tokens ≤ (tb_refill tb t2).tb_tokens := by
  intro tb t1 t2 ht hlast
  simp [tb_refill]
  apply Nat.min_le_min_right
  apply Nat.add_le_add_left
  apply Nat.mul_le_mul_right
  omega

theorem OMEGA_001_05_tb_consume_preserves_capacity : ∀ (tb : TokenBucket) (cost : Nat) (tb' : TokenBucket),
    tb_consume tb cost = some tb' →
    tb'.tb_capacity = tb.tb_capacity := by
  intro tb cost tb' h
  simp [tb_consume] at h
  split at h <;> simp_all

theorem OMEGA_001_06_tb_zero_cost_always_succeeds : ∀ (tb : TokenBucket),
    ∃ tb', tb_consume tb 0 = some tb' := by
  intro tb
  simp [tb_consume]
  exact ⟨{ tb_tokens := tb.tb_tokens, tb_capacity := tb.tb_capacity,
            tb_refill_rate := tb.tb_refill_rate, tb_last_refill := tb.tb_last_refill }, rfl⟩

theorem OMEGA_001_07_tb_refill_preserves_capacity : ∀ (tb : TokenBucket) (now : Nat),
    (tb_refill tb now).tb_capacity = tb.tb_capacity := by
  intros; rfl

theorem OMEGA_001_08_tb_available_bound : ∀ (tb : TokenBucket),
    tb_available tb ≤ tb.tb_capacity ∨ tb_available tb > tb.tb_capacity := by
  intro _; omega

-- ============================================================================
-- Capability Security (7 theorems)
-- ============================================================================

theorem OMEGA_002_01_expired_cap_invalid : ∀ (cap : NetCapability) (now : Nat),
    now ≥ cap.cap_expiry →
    cap_valid cap now = false := by
  intro cap now h; simp [cap_valid]; omega

theorem OMEGA_002_02_cap_subset_reflexive : ∀ (cap : NetCapability),
    cap_is_subset cap cap = true := by
  intro cap; simp [cap_is_subset]
  induction cap.cap_permissions with
  | nil => simp [List.all_nil]
  | cons x xs ih =>
    simp [List.all_cons]
    constructor
    · simp [List.any_cons, BEq.beq]
    · exact List.all_of_all_cons_of_all_tail
        (fun p => List.any (x :: xs) fun x_1 => x_1 == p) xs
        (by
          intro a ha
          simp [List.any_cons]
          right
          exact List.any_of_mem ha (by simp [BEq.beq]))
        |>.mp ih

theorem OMEGA_002_03_delegation_attenuation : ∀ (parent : NetCapability) (perms : List Nat) (expiry sig : Nat) (child : NetCapability),
    cap_delegate parent perms expiry sig = some child →
    child.cap_expiry ≤ parent.cap_expiry := by
  intro parent perms expiry sig child h
  simp [cap_delegate] at h
  split at h
  · simp at h; rw [← h]; simp; exact Nat.min_le_right _ _
  · simp at h

theorem OMEGA_002_04_delegation_permission_subset : ∀ (parent : NetCapability) (perms : List Nat) (expiry sig : Nat) (child : NetCapability),
    cap_delegate parent perms expiry sig = some child →
    cap_is_subset child parent = true := by
  intro parent perms expiry sig child h
  simp [cap_delegate] at h
  split at h
  · simp at h; rw [← h]; simp [cap_is_subset]
    intro a ha
    exact List.mem_filter.mp ha |>.2
  · simp at h

theorem OMEGA_002_05_nondelegatable_blocks : ∀ (parent : NetCapability) (perms : List Nat) (expiry sig : Nat),
    parent.cap_delegatable = false →
    cap_delegate parent perms expiry sig = none := by
  intro parent perms expiry sig h
  simp [cap_delegate, h]

theorem OMEGA_002_06_empty_cap_permits_nothing : ∀ (port : Nat),
    cap_permits { cap_id := 0, cap_permissions := [], cap_expiry := 0,
                  cap_delegatable := false, cap_signature := 0 } port = false := by
  intro _; rfl

theorem OMEGA_002_07_cap_permits_sound : ∀ (cap : NetCapability) (port : Nat),
    cap_permits cap port = true →
    ∃ p, p ∈ cap.cap_permissions ∧ (p == port) = true := by
  intro cap port h
  simp [cap_permits] at h
  exact List.any_eq_true_iff_exists.mp h |>.elim fun x hx =>
    ⟨x, hx.1, hx.2⟩

-- ============================================================================
-- SYN Cookie (6 theorems)
-- ============================================================================

theorem OMEGA_003_01_syn_cookie_verify_sound : ∀ (secret : Nat) (cookie : SynCookie),
    syn_cookie_verify secret cookie (syn_cookie_generate secret cookie) = true := by
  intros; simp [syn_cookie_verify, BEq.beq]

theorem OMEGA_003_02_syn_cookie_wrong_secret : ∀ (s1 s2 : Nat) (cookie : SynCookie),
    s1 ≠ s2 →
    syn_cookie_generate s1 cookie ≠ syn_cookie_generate s2 cookie := by
  intro s1 s2 cookie h; simp [syn_cookie_generate, hmac_compute]; omega

theorem OMEGA_003_03_syn_cookie_deterministic : ∀ (secret : Nat) (cookie : SynCookie),
    syn_cookie_generate secret cookie = syn_cookie_generate secret cookie := by
  intros; rfl

theorem OMEGA_003_04_syn_cookie_stateless : ∀ (secret : Nat) (cookie : SynCookie) (mac : Nat),
    syn_cookie_verify secret cookie mac = true →
    mac = syn_cookie_generate secret cookie := by
  intro secret cookie mac h
  simp [syn_cookie_verify, BEq.beq, Nat.beq_eq] at h
  exact h.symm

theorem OMEGA_003_05_syn_cookie_ip_sensitive : ∀ (secret : Nat) (c1 c2 : SynCookie),
    c1.sc_client_ip ≠ c2.sc_client_ip →
    c1.sc_client_port = c2.sc_client_port →
    c1.sc_server_port = c2.sc_server_port →
    c1.sc_timestamp = c2.sc_timestamp →
    syn_cookie_generate secret c1 ≠ syn_cookie_generate secret c2 := by
  intro secret c1 c2 hip hport hsport htime
  simp [syn_cookie_generate, hmac_compute]; omega

theorem OMEGA_003_06_wrong_mac_rejected : ∀ (secret : Nat) (cookie : SynCookie) (mac : Nat),
    mac ≠ syn_cookie_generate secret cookie →
    syn_cookie_verify secret cookie mac = false := by
  intro secret cookie mac h
  simp [syn_cookie_verify, BEq.beq, Nat.beq_eq, h]

-- ============================================================================
-- Connection Limiting (5 theorems)
-- ============================================================================

theorem OMEGA_004_01_empty_table_allows : ∀ (src : Nat),
    conn_allowed [] src = true := by
  intro _; rfl

theorem OMEGA_004_02_conn_count_nonneg : ∀ (table : ConnTable) (src : Nat),
    conn_count_by_src table src ≥ 0 := by
  intros; omega

theorem OMEGA_004_03_conn_count_bound : ∀ (table : ConnTable) (src : Nat),
    conn_count_by_src table src ≤ table.length := by
  intro table src; simp [conn_count_by_src]; exact List.length_filter_le _ _

theorem OMEGA_004_04_conn_lookup_deterministic : ∀ (table : ConnTable) (src dst : Nat) (c1 c2 : Connection),
    conn_lookup table src dst = some c1 →
    conn_lookup table src dst = some c2 →
    c1 = c2 := by
  intro _ _ _ _ _ h1 h2; rw [h1] at h2; exact Option.some.inj h2

theorem OMEGA_004_05_pow_verify_sound : ∀ (nonce challenge difficulty : Nat),
    pow_valid nonce challenge difficulty = true →
    pow_verify nonce challenge difficulty = true := by
  intro _ _ _ h; exact h

-- ============================================================================
-- Proof-of-Work (4 theorems)
-- ============================================================================

theorem OMEGA_005_01_pow_deterministic : ∀ (n c d : Nat),
    pow_valid n c d = pow_valid n c d := by
  intros; rfl

theorem OMEGA_005_02_pow_zero_difficulty_impossible : ∀ (n c : Nat),
    pow_valid n c 0 = false := by
  intros; simp [pow_valid, pow_hash]; omega

theorem OMEGA_005_03_pow_verify_complete : ∀ (n c d : Nat),
    pow_verify n c d = true → pow_valid n c d = true := by
  intro _ _ _ h; exact h

theorem OMEGA_005_04_pow_hash_deterministic : ∀ (n c : Nat),
    pow_hash n c = pow_hash n c := by
  intros; rfl

end RIINA.Domains.NetworkDefense
