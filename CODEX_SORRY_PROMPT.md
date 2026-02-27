# Codex Task: Eliminate `sorry` in RIINA Lean 4 Proofs

## SETUP — READ THIS FIRST

All Lean files are under `02_FORMAL/lean/` relative to the repo root.
The Lean toolchain is `leanprover/lean4:v4.16.0` (installed via elan).

```bash
# Setup PATH for Lean/Lake
export PATH="$HOME/.elan/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

# Working directory for all lake commands
cd 02_FORMAL/lean
```

If `lake` is not found, install elan first:
```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --default-toolchain leanprover/lean4:v4.16.0
export PATH="$HOME/.elan/bin:$PATH"
```

---

## CRITICAL RULES

1. **Every file you modify MUST compile.** Verify with:
   ```bash
   cd 02_FORMAL/lean
   lake env lean <file_path> 2>&1 | grep "error"
   ```
   If ANY errors remain, do NOT commit.

2. **The full build MUST pass:**
   ```bash
   cd 02_FORMAL/lean && lake build RIINA
   ```

3. **Do NOT introduce new `sorry`.** Net reduction only.

4. **Do NOT change theorem signatures.** Only replace `sorry` with proofs.

5. **Commit format:** `[TRACK_A] PROOF: Description`

---

## CURRENT STATE

- **Build:** `lake build RIINA` passes cleanly (zero sorry warnings)
- **Total sorry:** 4 across 2 files (ALL in non-compiled files)
- **NonInterference_v2.lean:** 2 sorry + 12 pre-existing compilation errors
- **NonInterference_v2_LogicalRelation.lean:** 2 sorry + 240 pre-existing compilation errors
- **These files are NOT imported by the build.** They must be individually compiled with `lake env lean <file>`.
- **Previously eliminated:** sorry #2,#3 (val_rel_n unfold — propext), #4,#5 (store_rel_n unfold — rfl), #9 (store_rel_n_same_fresh — omega)

---

## FILE LOCATIONS (relative to `02_FORMAL/lean/`)

```
RIINA.lean                                              ← Build manifest
RIINA/Foundations/Syntax.lean                            ← Types, expressions, values
RIINA/Foundations/Semantics.lean                         ← step (32 constructors), multi_step
RIINA/TypeSystem/Typing.lean                            ← has_type, val_rel_n, store_rel_n
RIINA/Properties/NonInterference_v2.lean                ← Sorry #1–#6 (12 errors)
RIINA/Properties/NonInterference_v2_LogicalRelation.lean ← Sorry #7–#9 (239 errors)
```

---

## SORRY #1 (NI_v2 line 275): `val_rel_at_type_fo_trivial`

```lean
theorem val_rel_at_type_fo_trivial : ∀ T St v1 v2,
    first_order_type T = true → fo_type_has_trivial_rel T = true →
    value v1 → value v2 →
    has_type nil St Public v1 T EffectPure →
    has_type nil St Public v2 T EffectPure →
    val_rel_at_type_fo T v1 v2 := by sorry
```

**NOTE:** The file's own comment (lines 263–273) says this is an UNUSED LEMMA with known issues — TSum with trivial components fails when v1=EInl, v2=EInr. If you cannot prove it fully, leave the sorry with a comment, or prove non-TSum cases and sorry only TSum.

---

## SORRY #2 (NI_v2 line 290): `val_rel_n_S_unfold`

```lean
theorem val_rel_n_S_unfold : ∀ n St T v1 v2,
    val_rel_n (S n) St T v1 v2 =
    (val_rel_n n St T v1 v2 ∧ value v1 ∧ value v2 ∧ closed_expr v1 ∧ closed_expr v2 ∧
     has_type nil St Public v1 T EffectPure ∧ has_type nil St Public v2 T EffectPure ∧
     val_rel_at_type_n n St (store_rel_n n) (val_rel_n n) (store_rel_n n) (store_vals_rel n) T v1 v2) := by sorry
```

### CRITICAL: `val_rel_n` definition mismatch

The current `val_rel_n` in `RIINA/TypeSystem/Typing.lean` (line 430) **IGNORES the step index `_n`**:

```lean
def val_rel_n (_n : Nat) (St : store_ty) (T : ty) (v1 v2 : expr) : Prop :=
  value v1 ∧ value v2 ∧
  closed_expr v1 ∧ closed_expr v2 ∧
  has_type [] St Public v1 T EffectPure ∧
  has_type [] St Public v2 T EffectPure ∧
  (if first_order_type T then val_rel_at_type_fo T v1 v2 else True)
```

This means `val_rel_n (S n) = val_rel_n n = val_rel_n 0` — all identical. The theorem asks for `val_rel_at_type_n n ...` in the conjunction, which is STRONGER than the flat definition. **This theorem is UNPROVABLE with the current definition.**

**To fix:** Change `val_rel_n` in `Typing.lean` to be properly recursive:

```lean
def val_rel_n : Nat → store_ty → ty → expr → expr → Prop
  | 0, St, T, v1, v2 =>
      value v1 ∧ value v2 ∧ closed_expr v1 ∧ closed_expr v2 ∧
      has_type [] St Public v1 T EffectPure ∧ has_type [] St Public v2 T EffectPure ∧
      (if first_order_type T then val_rel_at_type_fo T v1 v2 else True)
  | Nat.succ n, St, T, v1, v2 =>
      val_rel_n n St T v1 v2 ∧
      value v1 ∧ value v2 ∧ closed_expr v1 ∧ closed_expr v2 ∧
      has_type [] St Public v1 T EffectPure ∧ has_type [] St Public v2 T EffectPure ∧
      val_rel_at_type_n n St (store_rel_n n) (val_rel_n n) (store_rel_n n) (store_vals_rel n) T v1 v2
```

**WARNING:** Changing `val_rel_n` affects ALL files that use it. After changing, verify:
```bash
lake build RIINA  # Must still pass
lake env lean RIINA/Properties/NonInterference_v2.lean 2>&1 | grep "error" | wc -l
```

---

## SORRY #3 (NI_v2 line 295): `val_rel_n_SS_unfold`

Same issue as #2. Same fix applies — once `val_rel_n` is recursive, both unfold by `rfl` or `simp [val_rel_n]`.

---

## SORRY #4 (NI_v2 line 298): `store_rel_n_0_unfold`

```lean
theorem store_rel_n_0_unfold : ∀ St st1 st2,
    store_rel_n 0 St st1 st2 = (store_max st1 = store_max st2) := by sorry
```

**EASY — `store_rel_n` IS properly recursive.** Proof:
```lean
  intros; rfl
```

---

## SORRY #5 (NI_v2 line 301): `store_rel_n_S_unfold`

```lean
theorem store_rel_n_S_unfold : ∀ n St st1 st2,
    store_rel_n (S n) St st1 st2 =
    (store_rel_n n St st1 st2 ∧ store_max st1 = store_max st2 ∧
     (∀ l T sl, store_ty_lookup l St = Some (T, sl) →
       ∃ v1 v2, store_lookup l st1 = Some v1 ∧ store_lookup l st2 = Some v2 ∧
         (if is_low_dec sl then val_rel_n n St T v1 v2
          else ...))) := by sorry
```

**ISSUE:** The definition uses `sec_leq_dec sl Public` but the theorem uses `is_low_dec sl`. They are equivalent:
```lean
def is_low_dec (l : security_level) : Bool := sec_leq_dec l observer
def observer : security_level := Public
```

Try: `intro n St st1 st2; simp only [store_rel_n, is_low_dec, observer]`
Or: `intros; rfl` if the definitions fully unfold to the same thing.

---

## SORRY #6 (NI_v2 line 682): `val_rel_at_type_TFn_step_0_bridge`

Large bridge lemma for TFn (function type) at step 0. Requires:
1. `canonical_forms_fn` to extract lambda structure
2. Beta reduction via `ST_AppAbs`
3. Substitution preservation for typing
4. This is the hardest sorry — may need to remain if infrastructure is missing.

---

## SORRY #7 (NI_v2_LR line 2075): `multi_step_preservation_aux`

```lean
theorem multi_step_preservation_aux : ∀ cfg1 cfg2, cfg1 -→* cfg2 →
    ∀ St e st ctx T ε, cfg1 = (e, st, ctx) →
    has_type nil St Public e T ε → store_wf St st →
    ∃ e' st' ctx' St' ε', cfg2 = (e', st', ctx') ∧
      store_ty_extends St St' ∧ store_wf St' st' ∧
      has_type nil St' Public e' T ε' := by sorry
```

Requires single-step `preservation` theorem. Check if one exists in the codebase.

---

## SORRY #8 (NI_v2_LR line 2078): `multi_step_preservation`

Corollary of #7.

---

## SORRY #9 (NI_v2_LR line 2143): `store_rel_n_same_fresh`

```lean
theorem store_rel_n_same_fresh : ∀ n St st1 st2,
    store_rel_n n St st1 st2 → fresh_loc st1 = fresh_loc st2 := by sorry
```

**Proof approach:** `fresh_loc st = store_max st + 1`. Both `store_rel_n 0` and `store_rel_n (S k)` give `store_max st1 = store_max st2`.

```lean
  intro n St st1 st2 h
  simp only [fresh_loc]
  cases n with
  | zero => exact congrArg (· + 1) h
  | succ k => exact congrArg (· + 1) h.2.1
```

---

## PRE-EXISTING ERRORS TO FIX

### NonInterference_v2.lean (12 errors)

**Lines 167, 180, 183, 192, 200** — All the same pattern in `free_in_context'`:
```
Exists.intro Tx hlk — hlk has type type_env_lookup ... but expected lookup ...
```
Fix: The proof uses `hlk` directly but needs to strip the cons binding. Use `simp [lookup, hne] at hlk` before `exact ⟨Tx, hlk⟩`. Look at how the same theorem is proved earlier in the file (lines 153–208) — the working cases use `simp [lookup, hne] at hlk`.

**Line 215** — Type mismatch in `val_rel_at_type_fo_refl` branch. Check the subst/term.

**Line 224** — `'induction' tactic does not support mutually inductive types`. Replace `induction T` with `match T with` + explicit recursive calls.

**Lines 505, 590, 595, 602, 625** — Various tactic failures. Fix after earlier errors, as some may cascade.

### NonInterference_v2_LogicalRelation.lean (239 errors)

Most are `simp_all made no progress` or `application type mismatch`. This file has massive transpilation issues. Focus on the 3 sorry and the errors near them rather than trying to fix all 239.

---

## PRIORITY ORDER

1. **Sorry #4** (`store_rel_n_0_unfold`) — trivial `rfl`
2. **Sorry #5** (`store_rel_n_S_unfold`) — `simp` with `is_low_dec`/`observer`
3. **Sorry #9** (`store_rel_n_same_fresh`) — easy from `store_max` equality
4. **Sorry #2 & #3** (`val_rel_n_S/SS_unfold`) — requires fixing `val_rel_n` definition
5. **Sorry #1** (`val_rel_at_type_fo_trivial`) — known broken for TSum
6. **Sorry #7 & #8** (preservation) — needs preservation infrastructure
7. **Sorry #6** (`TFn_step_0_bridge`) — hardest, depends on much infrastructure

**Each sorry you eliminate is valuable.** Don't block on hard ones — submit what you can prove.

---

## BUILD COMMANDS

```bash
export PATH="$HOME/.elan/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
cd 02_FORMAL/lean

# Full build:
lake build RIINA

# Compile specific file:
lake env lean RIINA/Properties/NonInterference_v2.lean
lake env lean RIINA/Properties/NonInterference_v2_LogicalRelation.lean

# Count errors:
lake env lean <file> 2>&1 | grep "error" | wc -l

# Count sorry:
grep -rn "sorry" RIINA/ --include="*.lean" | grep -v "^.*:.*--.*sorry" | grep -v "zero_admits" | wc -l
```

## VERIFICATION CHECKLIST

- [ ] `lake build RIINA` — zero errors (MUST NOT REGRESS)
- [ ] Modified files compile: `lake env lean <file> 2>&1 | grep "error" | wc -l` → 0
- [ ] Sorry count decreased: `grep -rn "sorry" ... | wc -l` < 9
- [ ] No new sorry introduced
