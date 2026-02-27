-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing
import RIINA.Properties.CumulativeRelation

/-!
# RIINA KripkeProperties - Lean 4 Port

Port of 02_FORMAL/coq/properties/KripkeProperties.v (41 theorems).

Many "build" and "eq" theorems are already proved in CumulativeRelation.lean.
This file adds Kripke-world properties: step-up lemmas, monotonicity,
store extension, and the val_rel_at / val_rel_le bridge.
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

/-! ## val_rel_at -/

/-- val_rel_at (matches Coq: Definition val_rel_at) -/
def val_rel_at (n : Nat) (St : store_ty) (T : ty) (v1 v2 : expr) : Prop :=
  match n with
  | 0 => True
  | Nat.succ n' => val_rel_struct (val_rel_le n') St T v1 v2

/-! ## Preorder on store_ty_extends -/

/-- store_ty_extends_preorder (matches Coq) -/
theorem store_ty_extends_preorder :
    (∀ St, store_ty_extends St St) ∧
    (∀ St1 St2 St3, store_ty_extends St1 St2 → store_ty_extends St2 St3 →
      store_ty_extends St1 St3) := by
  constructor
  · intro St l T sl h; exact h
  · intro St1 St2 St3 h12 h23 l T sl h; exact h23 l T sl (h12 l T sl h)

/-! ## Build lemmas for types -/

/-- val_rel_le_build_bytes_k (matches Coq: val_rel_le_build_bytes) -/
theorem val_rel_le_build_bytes_k :
    ∀ m St v, value v → closed_expr v → val_rel_le m St TBytes v v := by
  intro m St v hv hc
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · exact ⟨hv, hv, hc, hc, rfl⟩

/-- val_rel_le_build_labeled_k (matches Coq: val_rel_le_build_labeled) -/
theorem val_rel_le_build_labeled_k :
    ∀ m St T sl v1 v2, value v1 → value v2 → closed_expr v1 →
    closed_expr v2 → val_rel_le m St (TLabeled T sl) v1 v2 := by
  intro m St T sl v1 v2 hv1 hv2 hc1 hc2
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · exact ⟨hv1, hv2, hc1, hc2, trivial⟩

/-- val_rel_le_build_tainted_k (matches Coq: val_rel_le_build_tainted) -/
theorem val_rel_le_build_tainted_k :
    ∀ m St T src v1 v2, value v1 → value v2 → closed_expr v1 →
    closed_expr v2 → val_rel_le m St (TTainted T src) v1 v2 := by
  intro m St T src v1 v2 hv1 hv2 hc1 hc2
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · exact ⟨hv1, hv2, hc1, hc2, trivial⟩

/-- val_rel_le_build_sanitized_k (matches Coq: val_rel_le_build_sanitized) -/
theorem val_rel_le_build_sanitized_k :
    ∀ m St T san v1 v2, value v1 → value v2 → closed_expr v1 →
    closed_expr v2 → val_rel_le m St (TSanitized T san) v1 v2 := by
  intro m St T san v1 v2 hv1 hv2 hc1 hc2
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · exact ⟨hv1, hv2, hc1, hc2, trivial⟩

/-- val_rel_le_build_proof_k (matches Coq: val_rel_le_build_proof) -/
theorem val_rel_le_build_proof_k :
    ∀ m St T v1 v2, value v1 → value v2 → closed_expr v1 →
    closed_expr v2 → val_rel_le m St (TProof T) v1 v2 := by
  intro m St T v1 v2 hv1 hv2 hc1 hc2
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · exact ⟨hv1, hv2, hc1, hc2, trivial⟩

/-- val_rel_le_build_ct_k (matches Coq: val_rel_le_build_ct) -/
theorem val_rel_le_build_ct_k :
    ∀ m St T v1 v2, value v1 → value v2 → closed_expr v1 →
    closed_expr v2 → val_rel_le m St (TConstantTime T) v1 v2 := by
  intro m St T v1 v2 hv1 hv2 hc1 hc2
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · exact ⟨hv1, hv2, hc1, hc2, trivial⟩

/-- val_rel_le_build_zero_k (matches Coq: val_rel_le_build_zero) -/
theorem val_rel_le_build_zero_k :
    ∀ m St T v1 v2, value v1 → value v2 → closed_expr v1 →
    closed_expr v2 → val_rel_le m St (TZeroizing T) v1 v2 := by
  intro m St T v1 v2 hv1 hv2 hc1 hc2
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · exact ⟨hv1, hv2, hc1, hc2, trivial⟩

/-- val_rel_le_build_cap_k (matches Coq: val_rel_le_build_cap) -/
theorem val_rel_le_build_cap_k :
    ∀ m St k v1 v2, value v1 → value v2 → closed_expr v1 →
    closed_expr v2 → val_rel_le m St (TCapability k) v1 v2 := by
  intro m St k v1 v2 hv1 hv2 hc1 hc2
  induction m with
  | zero => trivial
  | succ k' ih =>
    constructor
    · exact ih
    · exact ⟨hv1, hv2, hc1, hc2, trivial⟩

-- Private helper: build val_rel_le for TCapabilityFull
private theorem build_capfull (m : Nat) (St : store_ty)
    (c : capability) (v1 v2 : expr)
    (hv1 : value v1) (hv2 : value v2)
    (hc1 : closed_expr v1) (hc2 : closed_expr v2)
    : val_rel_le m St (TCapabilityFull c) v1 v2 := by
  induction m with
  | zero => trivial
  | succ k ih => exact ⟨ih, ⟨hv1, hv2, hc1, hc2, trivial⟩⟩

-- Private helper: build val_rel_le for TChan
private theorem build_chan (m : Nat) (St : store_ty)
    (s : session_type) (v1 v2 : expr)
    (hv1 : value v1) (hv2 : value v2)
    (hc1 : closed_expr v1) (hc2 : closed_expr v2)
    : val_rel_le m St (TChan s) v1 v2 := by
  induction m with
  | zero => trivial
  | succ k ih => exact ⟨ih, ⟨hv1, hv2, hc1, hc2, trivial⟩⟩

-- Private helper: build val_rel_le for TSecureChan
private theorem build_securechan (m : Nat) (St : store_ty)
    (s : session_type) (sl : security_level) (v1 v2 : expr)
    (hv1 : value v1) (hv2 : value v2)
    (hc1 : closed_expr v1) (hc2 : closed_expr v2)
    : val_rel_le m St (TSecureChan s sl) v1 v2 := by
  induction m with
  | zero => trivial
  | succ k ih => exact ⟨ih, ⟨hv1, hv2, hc1, hc2, trivial⟩⟩

-- Private helper: build val_rel_le for TList
private theorem build_list (m : Nat) (St : store_ty)
    (T : ty) (v1 v2 : expr)
    (hv1 : value v1) (hv2 : value v2)
    (hc1 : closed_expr v1) (hc2 : closed_expr v2)
    : val_rel_le m St (TList T) v1 v2 := by
  induction m with
  | zero => trivial
  | succ k ih => exact ⟨ih, ⟨hv1, hv2, hc1, hc2, trivial⟩⟩

-- Private helper: build val_rel_le for TOption
private theorem build_option (m : Nat) (St : store_ty)
    (T : ty) (v1 v2 : expr)
    (hv1 : value v1) (hv2 : value v2)
    (hc1 : closed_expr v1) (hc2 : closed_expr v2)
    : val_rel_le m St (TOption T) v1 v2 := by
  induction m with
  | zero => trivial
  | succ k ih => exact ⟨ih, ⟨hv1, hv2, hc1, hc2, trivial⟩⟩

-- Private helper: build val_rel_le for TFn
private theorem build_fn (m : Nat) (St : store_ty)
    (T1 T2 : ty) (eff : effect) (v1 v2 : expr)
    (hv1 : value v1) (hv2 : value v2)
    (hc1 : closed_expr v1) (hc2 : closed_expr v2)
    : val_rel_le m St (TFn T1 T2 eff) v1 v2 := by
  induction m with
  | zero => trivial
  | succ k ih => exact ⟨ih, ⟨hv1, hv2, hc1, hc2, trivial⟩⟩

/-- val_rel_le_build_ref_kripke (matches Coq) -/
theorem val_rel_le_build_ref_kripke :
    ∀ m St T sl l, val_rel_le m St (TRef T sl) (ELoc l) (ELoc l) := by
  intro m St T sl l
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · unfold val_rel_struct
      exact ⟨value.VLoc l, value.VLoc l,
             fun x h => h, fun x h => h,
             ⟨l, rfl, rfl⟩⟩

/-! ## Step-up lemmas -/

/-- val_rel_le_step_up_unit (matches Coq) -/
theorem val_rel_le_step_up_unit :
    ∀ n m St v1 v2, val_rel_le n St TUnit v1 v2 → n > 0 →
    val_rel_le m St TUnit v1 v2 := by
  intro n m St v1 v2 h hn
  have ⟨heq1, heq2⟩ := val_rel_le_unit_eq n St v1 v2 hn h
  subst heq1; subst heq2
  exact val_rel_le_build_unit m St

/-- val_rel_le_step_up_bool (matches Coq) -/
theorem val_rel_le_step_up_bool :
    ∀ n m St v1 v2, val_rel_le n St TBool v1 v2 → n > 0 →
    val_rel_le m St TBool v1 v2 := by
  intro n m St v1 v2 h hn
  have ⟨b, heq1, heq2⟩ := val_rel_le_bool_eq n St v1 v2 hn h
  subst heq1; subst heq2
  exact val_rel_le_build_bool m St b

/-- val_rel_le_step_up_int (matches Coq) -/
theorem val_rel_le_step_up_int :
    ∀ n m St v1 v2, val_rel_le n St TInt v1 v2 → n > 0 →
    val_rel_le m St TInt v1 v2 := by
  intro n m St v1 v2 h hn
  have ⟨i, heq1, heq2⟩ := val_rel_le_int_eq n St v1 v2 hn h
  subst heq1; subst heq2
  exact val_rel_le_build_int m St i

/-- val_rel_le_step_up_string (matches Coq) -/
theorem val_rel_le_step_up_string :
    ∀ n m St v1 v2, val_rel_le n St TString v1 v2 → n > 0 →
    val_rel_le m St TString v1 v2 := by
  intro n m St v1 v2 h hn
  have ⟨s, heq1, heq2⟩ := val_rel_le_string_eq n St v1 v2 hn h
  subst heq1; subst heq2
  exact val_rel_le_build_string m St s

/-- val_rel_le_step_up_bytes (matches Coq) -/
theorem val_rel_le_step_up_bytes :
    ∀ n m St v1 v2, val_rel_le n St TBytes v1 v2 → n > 0 →
    val_rel_le m St TBytes v1 v2 := by
  intro n m St v1 v2 h hn
  have heq := val_rel_le_bytes_eq n St v1 v2 hn h
  subst heq
  have hv := val_rel_le_value_left n St TBytes v1 v1 hn h
  have hc := val_rel_le_closed_left n St TBytes v1 v1 hn h
  exact val_rel_le_build_bytes_k m St v1 hv hc

/-- val_rel_le_step_up_secret (matches Coq) -/
theorem val_rel_le_step_up_secret :
    ∀ n m St l v1 v2, val_rel_le n St (TSecret l) v1 v2 → n > 0 →
    val_rel_le m St (TSecret l) v1 v2 := by
  intro n m St l v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TSecret l) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TSecret l) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TSecret l) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TSecret l) v1 v2 hn h
  exact val_rel_le_build_secret m St l v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_labeled (matches Coq) -/
theorem val_rel_le_step_up_labeled :
    ∀ n m St T sl v1 v2, val_rel_le n St (TLabeled T sl) v1 v2 → n > 0 →
    val_rel_le m St (TLabeled T sl) v1 v2 := by
  intro n m St T sl v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TLabeled T sl) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TLabeled T sl) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TLabeled T sl) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TLabeled T sl) v1 v2 hn h
  exact val_rel_le_build_labeled_k m St T sl v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_tainted (matches Coq) -/
theorem val_rel_le_step_up_tainted :
    ∀ n m St T src v1 v2, val_rel_le n St (TTainted T src) v1 v2 → n > 0 →
    val_rel_le m St (TTainted T src) v1 v2 := by
  intro n m St T src v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TTainted T src) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TTainted T src) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TTainted T src) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TTainted T src) v1 v2 hn h
  exact val_rel_le_build_tainted_k m St T src v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_sanitized (matches Coq) -/
theorem val_rel_le_step_up_sanitized :
    ∀ n m St T san v1 v2, val_rel_le n St (TSanitized T san) v1 v2 → n > 0 →
    val_rel_le m St (TSanitized T san) v1 v2 := by
  intro n m St T san v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TSanitized T san) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TSanitized T san) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TSanitized T san) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TSanitized T san) v1 v2 hn h
  exact val_rel_le_build_sanitized_k m St T san v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_proof (matches Coq) -/
theorem val_rel_le_step_up_proof :
    ∀ n m St T v1 v2, val_rel_le n St (TProof T) v1 v2 → n > 0 →
    val_rel_le m St (TProof T) v1 v2 := by
  intro n m St T v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TProof T) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TProof T) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TProof T) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TProof T) v1 v2 hn h
  exact val_rel_le_build_proof_k m St T v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_ct (matches Coq) -/
theorem val_rel_le_step_up_ct :
    ∀ n m St T v1 v2, val_rel_le n St (TConstantTime T) v1 v2 → n > 0 →
    val_rel_le m St (TConstantTime T) v1 v2 := by
  intro n m St T v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TConstantTime T) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TConstantTime T) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TConstantTime T) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TConstantTime T) v1 v2 hn h
  exact val_rel_le_build_ct_k m St T v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_zero (matches Coq) -/
theorem val_rel_le_step_up_zero :
    ∀ n m St T v1 v2, val_rel_le n St (TZeroizing T) v1 v2 → n > 0 →
    val_rel_le m St (TZeroizing T) v1 v2 := by
  intro n m St T v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TZeroizing T) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TZeroizing T) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TZeroizing T) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TZeroizing T) v1 v2 hn h
  exact val_rel_le_build_zero_k m St T v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_cap (matches Coq) -/
theorem val_rel_le_step_up_cap :
    ∀ n m St k v1 v2, val_rel_le n St (TCapability k) v1 v2 → n > 0 →
    val_rel_le m St (TCapability k) v1 v2 := by
  intro n m St k v1 v2 h hn
  have hv1 := val_rel_le_value_left n St (TCapability k) v1 v2 hn h
  have hv2 := val_rel_le_value_right n St (TCapability k) v1 v2 hn h
  have hc1 := val_rel_le_closed_left n St (TCapability k) v1 v2 hn h
  have hc2 := val_rel_le_closed_right n St (TCapability k) v1 v2 hn h
  exact val_rel_le_build_cap_k m St k v1 v2 hv1 hv2 hc1 hc2

/-- val_rel_le_step_up_ref (matches Coq) -/
theorem val_rel_le_step_up_ref :
    ∀ n m St T sl v1 v2, val_rel_le n St (TRef T sl) v1 v2 → n > 0 →
    val_rel_le m St (TRef T sl) v1 v2 := by
  intro n m St T sl v1 v2 h hn
  have ⟨l, heq1, heq2⟩ := val_rel_le_ref_eq n St T sl v1 v2 hn h
  subst heq1; subst heq2
  exact val_rel_le_build_ref_kripke m St T sl l

/-! ## Kripke monotonicity -/

/-- val_rel_le_kripke_mono (matches Coq): step + store monotonicity -/
theorem val_rel_le_kripke_mono :
    ∀ n m St St' T v1 v2, m ≤ n → store_ty_extends St St' →
    val_rel_le n St T v1 v2 → val_rel_le m St' T v1 v2 := by
  intro n
  induction n with
  | zero =>
    intro m St St' T v1 v2 hle _ _
    match m with
    | 0 => trivial
  | succ k ih =>
    intro m St St' T v1 v2 hle hext h
    match m with
    | 0 => trivial
    | Nat.succ j =>
      have hle' : j ≤ k := Nat.le_of_succ_le_succ hle
      constructor
      · exact ih j St St' T v1 v2 hle' hext h.1
      · have hstr := h.2
        unfold val_rel_struct at hstr ⊢
        refine ⟨hstr.1, hstr.2.1, hstr.2.2.1, hstr.2.2.2.1, ?_⟩
        match T with
        | TUnit | TBool | TInt | TString | TBytes
        | TSecret _ | TLabeled _ _ | TTainted _ _ | TSanitized _ _
        | TCapability _ | TCapabilityFull _ | TProof _ | TChan _
        | TSecureChan _ _ | TConstantTime _ | TZeroizing _
        | TRef _ _ | TList _ | TOption _ | TFn _ _ _ =>
          exact hstr.2.2.2.2
        | TProd T1 T2 =>
          obtain ⟨a1, b1, a2, b2, heq1, heq2, hr1, hr2⟩ := hstr.2.2.2.2
          exact ⟨a1, b1, a2, b2, heq1, heq2,
                 ih j St St' T1 a1 a2 hle' hext hr1,
                 ih j St St' T2 b1 b2 hle' hext hr2⟩
        | TSum T1 T2 =>
          cases hstr.2.2.2.2 with
          | inl hl =>
            obtain ⟨a1, a2, heq1, heq2, hr⟩ := hl
            exact Or.inl ⟨a1, a2, heq1, heq2, ih j St St' T1 a1 a2 hle' hext hr⟩
          | inr hr =>
            obtain ⟨b1, b2, heq1, heq2, hrr⟩ := hr
            exact Or.inr ⟨b1, b2, heq1, heq2, ih j St St' T2 b1 b2 hle' hext hrr⟩

/-- val_rel_le_store_preserves_step (matches Coq): store extension preserves step -/
theorem val_rel_le_store_preserves_step :
    ∀ n St St' T v1 v2, store_ty_extends St St' →
    val_rel_le n St T v1 v2 → val_rel_le n St' T v1 v2 := by
  intro n St St' T v1 v2 hext h
  exact val_rel_le_kripke_mono n n St St' T v1 v2 (Nat.le_refl n) hext h

/-! ## Store relation monotonicity -/

/-- store_rel_le_kripke_step (matches Coq) -/
theorem store_rel_le_kripke_step :
    ∀ n m St st1 st2, m ≤ n → store_rel_le n St st1 st2 →
    store_rel_le m St st1 st2 := by
  intro n m St st1 st2 _ h; exact h

/-! ## val_rel_at / val_rel_le bridge -/

/-- val_rel_le_includes_at (matches Coq) -/
theorem val_rel_le_includes_at :
    ∀ n St T v1 v2, val_rel_le n St T v1 v2 → val_rel_at n St T v1 v2 := by
  intro n St T v1 v2 h
  match n with
  | 0 => trivial
  | Nat.succ m => exact h.2

/-- val_rel_at_to_le (matches Coq) -/
theorem val_rel_at_to_le :
    ∀ n St T v1 v2, val_rel_le n St T v1 v2 →
    val_rel_at (Nat.succ n) St T v1 v2 →
    val_rel_le (Nat.succ n) St T v1 v2 := by
  intro n St T v1 v2 hprev hat
  exact ⟨hprev, hat⟩

/-! ## Indistinguishability -/

/-- val_rel_le_build_indist (matches Coq) -/
theorem val_rel_le_build_indist :
    ∀ m St T v1 v2, value v1 → value v2 → closed_expr v1 → closed_expr v2 →
    (match T with
     | TSecret _ | TLabeled _ _ | TTainted _ _ | TSanitized _ _
     | TCapability _ | TCapabilityFull _ | TProof _ | TChan _
     | TSecureChan _ _ | TConstantTime _ | TZeroizing _
     | TList _ | TOption _ => True
     | _ => False) →
    val_rel_le m St T v1 v2 := by
  intro m St T v1 v2 hv1 hv2 hc1 hc2 htmatch
  induction m with
  | zero => trivial
  | succ k ih =>
    constructor
    · exact ih
    · refine ⟨hv1, hv2, hc1, hc2, ?_⟩
      match T, htmatch with
      | TSecret _, _ => exact trivial
      | TLabeled _ _, _ => exact trivial
      | TTainted _ _, _ => exact trivial
      | TSanitized _ _, _ => exact trivial
      | TCapability _, _ => exact trivial
      | TCapabilityFull _, _ => exact trivial
      | TProof _, _ => exact trivial
      | TChan _, _ => exact trivial
      | TSecureChan _ _, _ => exact trivial
      | TConstantTime _, _ => exact trivial
      | TZeroizing _, _ => exact trivial
      | TList _, _ => exact trivial
      | TOption _, _ => exact trivial

-- COMMENTED OUT: val_rel_le_step_up_fo requires val_rel_le_fo_step_independent
-- from CumulativeRelation.lean, which is itself commented out due to
-- val_rel_le_extract_fo / val_rel_le_construct_fo definitional mismatch.
--
-- theorem val_rel_le_step_up_fo : ∀ n m St T v1 v2,
--   first_order_type T = true → val_rel_le n St T v1 v2 →
--   n > fo_compound_depth T → val_rel_le m St T v1 v2

/-! ## Base permanence -/

/-- val_rel_le_base_permanent (matches Coq) -/
theorem val_rel_le_base_permanent :
    ∀ St T v1 v2,
    (match T with
     | TUnit | TBool | TInt | TString | TBytes => True
     | TSecret _ | TLabeled _ _ | TTainted _ _ | TSanitized _ _ => True
     | TCapability _ | TCapabilityFull _ | TProof _ => True
     | TChan _ | TSecureChan _ _ => True
     | TConstantTime _ | TZeroizing _ => True
     | TList _ | TOption _ => True
     | _ => False) →
    val_rel_le 1 St T v1 v2 → ∀ n, val_rel_le n St T v1 v2 := by
  intro St T v1 v2 htmatch h1 n
  have hstr := h1.2
  have hv1 := hstr.1
  have hv2 := hstr.2.1
  have hc1 := hstr.2.2.1
  have hc2 := hstr.2.2.2.1
  match T, htmatch with
  | TUnit, _ =>
    have ⟨heq1, heq2⟩ := hstr.2.2.2.2
    subst heq1; subst heq2
    exact val_rel_le_build_unit n St
  | TBool, _ =>
    have ⟨b, heq1, heq2⟩ := hstr.2.2.2.2
    subst heq1; subst heq2
    exact val_rel_le_build_bool n St b
  | TInt, _ =>
    have ⟨i, heq1, heq2⟩ := hstr.2.2.2.2
    subst heq1; subst heq2
    exact val_rel_le_build_int n St i
  | TString, _ =>
    have ⟨s, heq1, heq2⟩ := hstr.2.2.2.2
    subst heq1; subst heq2
    exact val_rel_le_build_string n St s
  | TBytes, _ =>
    have heq := hstr.2.2.2.2
    subst heq
    exact val_rel_le_build_bytes_k n St v1 hv1 hc1
  | TSecret _, _ =>
    exact val_rel_le_build_secret n St _ v1 v2 hv1 hv2 hc1 hc2
  | TLabeled _ _, _ =>
    exact val_rel_le_build_labeled_k n St _ _ v1 v2 hv1 hv2 hc1 hc2
  | TTainted _ _, _ =>
    exact val_rel_le_build_tainted_k n St _ _ v1 v2 hv1 hv2 hc1 hc2
  | TSanitized _ _, _ =>
    exact val_rel_le_build_sanitized_k n St _ _ v1 v2 hv1 hv2 hc1 hc2
  | TCapability _, _ =>
    exact val_rel_le_build_cap_k n St _ v1 v2 hv1 hv2 hc1 hc2
  | TCapabilityFull c, _ =>
    exact build_capfull n St c v1 v2 hv1 hv2 hc1 hc2
  | TProof _, _ =>
    exact val_rel_le_build_proof_k n St _ v1 v2 hv1 hv2 hc1 hc2
  | TChan s, _ =>
    exact build_chan n St s v1 v2 hv1 hv2 hc1 hc2
  | TSecureChan s sl, _ =>
    exact build_securechan n St s sl v1 v2 hv1 hv2 hc1 hc2
  | TConstantTime _, _ =>
    exact val_rel_le_build_ct_k n St _ v1 v2 hv1 hv2 hc1 hc2
  | TZeroizing _, _ =>
    exact val_rel_le_build_zero_k n St _ v1 v2 hv1 hv2 hc1 hc2
  | TList t, _ =>
    exact build_list n St t v1 v2 hv1 hv2 hc1 hc2
  | TOption t, _ =>
    exact build_option n St t v1 v2 hv1 hv2 hc1 hc2

/-! ## Store typing helpers -/

/-- store_ty_lookup_update_neq (matches Coq) -/
private theorem store_ty_lookup_update_neq :
    ∀ l l' T sl St, l ≠ l' →
    store_ty_lookup l' (store_ty_update l T sl St) = store_ty_lookup l' St := by
  intro l l' T sl St hne
  match St with
  | [] =>
    simp [store_ty_update, store_ty_lookup]
    intro heq; exact absurd heq.symm hne
  | (l3, Tsl) :: rest =>
    simp only [store_ty_update]
    split
    · -- l = l3
      rename_i heql3
      simp only [store_ty_lookup]
      have hne2 : ¬(l' = l) := fun h => hne h.symm
      have hne3 : ¬(l' = l3) := by rw [← heql3]; exact hne2
      simp [hne2, hne3]
    · -- l ≠ l3
      simp only [store_ty_lookup]
      split
      · rfl
      · exact store_ty_lookup_update_neq l l' T sl rest hne

/-- store_ty_extends_add (matches Coq) -/
theorem store_ty_extends_add :
    ∀ St l T sl, store_ty_lookup l St = none →
    store_ty_extends St (store_ty_update l T sl St) := by
  intro St l T sl hnone l' T' sl' hlookup
  by_cases h : l = l'
  · subst h; rw [hnone] at hlookup; exact absurd hlookup (by simp)
  · rw [store_ty_lookup_update_neq l l' T sl St h]; exact hlookup

end RIINA
