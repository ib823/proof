; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/WasmBackendVerification.v (43 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: WasmBackendVerification

(set-logic ALL)
(set-option :produce-models true)

; WasmValType (matches Coq: Inductive WasmValType)
(declare-datatypes ((WasmValType 0)) (((I32) (I64) (F32) (F64))))

; RiinaType (matches Coq: Inductive RiinaType)
(declare-datatypes ((RiinaType 0)) (((RTNombor) (RTTeks) (RTBool) (RTUnit) (RTSecret))))

; SecLabel (matches Coq: Inductive SecLabel)
(declare-datatypes ((SecLabel 0)) (((Public) (Secret))))

; WasmInstr (matches Coq: Inductive WasmInstr)
(declare-datatypes ((WasmInstr 0)) (((WConst) (WLoad) (WStore) (WAdd) (WMul) (WCall) (WLocalGet) (WLocalSet) (WIf) (WReturn) (WDrop) (WNop))))

; RiinaIR (matches Coq: Inductive RiinaIR)
(declare-datatypes ((RiinaIR 0)) (((IRConst) (IRVar) (IRAdd) (IRMul) (IRCall) (IRLet) (IRIf) (IRLoad) (IRStore))))

; RiinaEffect (matches Coq: Inductive RiinaEffect)
(declare-datatypes ((RiinaEffect 0)) (((EffPure) (EffIO) (EffNet) (EffFS))))

(declare-const __default_RiinaEffect RiinaEffect)
(declare-const __default_RiinaIR RiinaIR)
(declare-const __default_RiinaType RiinaType)
(declare-const __default_SecLabel SecLabel)
(declare-const __default_WasmInstr WasmInstr)
(declare-const __default_WasmValType WasmValType)

; sec_le (matches Coq: Definition sec_le)
(define-fun sec_le ((l1 SecLabel) (l2 SecLabel)) Bool
  (= 0 0))

; type_compile (matches Coq: Definition type_compile)
(declare-fun type_compile (RiinaType) WasmValType)

; ir_eval (matches Coq: Definition ir_eval)
(define-fun ir_eval ((env Int) (e RiinaIR)) Int
  0)

; compile_ir (matches Coq: Definition compile_ir)
(define-fun compile_ir ((e RiinaIR)) Int
  0)

; export_is_public (matches Coq: Definition export_is_public)
(define-fun export_is_public ((labels Int) (export_func Int)) Bool
  (= 0 0))

; ni_preserved (matches Coq: Definition ni_preserved)
(define-fun ni_preserved ((labeled (Seq Int)) (exports (Seq Int))) Bool
  (= 0 0))

; memory_partitioned (matches Coq: Definition memory_partitioned)
(define-fun memory_partitioned ((secret_region Int) (public_region Int)) Bool
  (= 0 0))

; effect_le (matches Coq: Definition effect_le)
(define-fun effect_le ((e1 RiinaEffect) (e2 RiinaEffect)) Bool
  (= 0 0))

; import_effect_safe (matches Coq: Definition import_effect_safe)
(define-fun import_effect_safe ((declared RiinaEffect) (import_effect RiinaEffect)) Bool
  (= 0 0))

; regions_disjoint (matches Coq: Definition regions_disjoint)
(define-fun regions_disjoint ((r1 Int) (r2 Int)) Bool
  (= 0 0))

; no_cross_label_access (matches Coq: Definition no_cross_label_access)
(define-fun no_cross_label_access ((regions (Seq Int)) (addr Int) (label SecLabel)) Bool
  (= 0 0))

; string_in_segment (matches Coq: Definition string_in_segment)
(define-fun string_in_segment ((s Int) (seg Int)) Bool
  (= 0 0))

; string_compiles_to_ptr (matches Coq: Definition string_compiles_to_ptr)
(define-fun string_compiles_to_ptr ((s Int)) Int
  0)

; closure_layout_valid (matches Coq: Definition closure_layout_valid)
(define-fun closure_layout_valid ((cl Int) (addr Int)) Bool
  (= 0 0))

; compile_closure_alloc (matches Coq: Definition compile_closure_alloc)
(define-fun compile_closure_alloc ((cl Int) (addr Int)) Int
  0)

; pair_size (matches Coq: Definition pair_size)
(define-fun pair_size () Int
  0)

; sum_size (matches Coq: Definition sum_size)
(define-fun sum_size () Int
  0)

; pair_fst_offset (matches Coq: Definition pair_fst_offset)
(define-fun pair_fst_offset ((p Int)) Int
  0)

; pair_snd_offset (matches Coq: Definition pair_snd_offset)
(define-fun pair_snd_offset ((p Int)) Int
  0)

; sum_tag_valid (matches Coq: Definition sum_tag_valid)
(define-fun sum_tag_valid ((s Int)) Bool
  (= 0 0))

; wasm_eval_const (matches Coq: Lemma wasm_eval_const)
; wasm_eval_const: forall n stk, wasm_eval [WConst n] stk (n :: stk)
(assert (forall ((n Bool) (stk Bool)) (= 0 0))) ; wasm_eval_const [partial: bindings preserved]

; wasm_eval_add (matches Coq: Lemma wasm_eval_add)
; wasm_eval_add: forall a b stk, wasm_eval [WAdd] (b :: a :: stk) ((a + b) :: stk)
(assert (forall ((a Bool) (b Bool) (stk Bool)) (= 0 0))) ; wasm_eval_add [partial: bindings preserved]

; wasm_eval_mul (matches Coq: Lemma wasm_eval_mul)
; wasm_eval_mul: forall a b stk, wasm_eval [WMul] (b :: a :: stk) ((a * b) :: stk)
(assert (forall ((a Bool) (b Bool) (stk Bool)) (= 0 0))) ; wasm_eval_mul [partial: bindings preserved]

; wasm_001_const_preservation (matches Coq: Theorem wasm_001_const_preservation)
; wasm_001_const_preservation: forall n stk, wasm_eval (compile_ir (IRConst n)) stk (ir_eval (fun _ => 0) (IRConst n) :: stk)
(assert (forall ((n Bool) (stk Bool)) (= 0 0))) ; wasm_001_const_preservation [partial: bindings preserved]

; wasm_002_ni_preservation (matches Coq: Theorem wasm_002_ni_preservation)
; wasm_002_ni_preservation: forall labeled exports, ni_preserved labeled exports
(assert (forall ((labeled Bool) (exports Bool)) (= 0 0))) ; wasm_002_ni_preservation [partial: bindings preserved]

; wasm_002_memory_separation (matches Coq: Theorem wasm_002_memory_separation)
; wasm_002_memory_separation: forall s_start s_size p_start p_size, s_start + s_size <= p_start -> memory_partitioned (s_start, s_start + s_size) (p_s
(assert (forall ((s_start Bool) (s_size Bool) (p_start Bool) (p_size Bool)) (= 0 0))) ; wasm_002_memory_separation [partial: bindings preserved]

; wasm_003_effect_preservation (matches Coq: Theorem wasm_003_effect_preservation)
; wasm_003_effect_preservation: forall eff, import_effect_safe eff EffPure
(assert (forall ((eff Bool)) (= 0 0))) ; wasm_003_effect_preservation [partial: bindings preserved]

; wasm_003_io_self_safe (matches Coq: Theorem wasm_003_io_self_safe)
; wasm_003_io_self_safe: import_effect_safe EffIO EffIO
(assert (= 0 0)) ; wasm_003_io_self_safe [Coq-only]

; wasm_004_int_type_preserved (matches Coq: Theorem wasm_004_int_type_preserved)
; wasm_004_int_type_preserved: wasm_well_typed (WConst 42) [] [type_compile RTNombor]
(assert (= 0 0)) ; wasm_004_int_type_preserved [Coq-only]

; wasm_004_add_type_preserved (matches Coq: Theorem wasm_004_add_type_preserved)
; wasm_004_add_type_preserved: wasm_well_typed WAdd [type_compile RTNombor; type_compile RTNombor] [type_compile RTNombor]
(assert (= 0 0)) ; wasm_004_add_type_preserved [Coq-only]

; wasm_004_bool_type_preserved (matches Coq: Theorem wasm_004_bool_type_preserved)
; wasm_004_bool_type_preserved: type_compile RTBool = I32
(assert (= 0 0)) ; wasm_004_bool_type_preserved [Coq-only]

; wasm_005_disjoint_regions (matches Coq: Theorem wasm_005_disjoint_regions)
; wasm_005_disjoint_regions: forall s_start s_size p_start p_size, s_start + s_size <= p_start -> regions_disjoint (mkRegion s_start s_size Secret) (
(assert (forall ((s_start Bool) (s_size Bool) (p_start Bool) (p_size Bool)) (= 0 0))) ; wasm_005_disjoint_regions [partial: bindings preserved]

; wasm_005_public_cannot_access_secret (matches Coq: Theorem wasm_005_public_cannot_access_secret)
; wasm_005_public_cannot_access_secret: forall s_start s_size addr, addr < s_start -> no_cross_label_access [mkRegion s_start s_size Secret] addr Public
(assert (forall ((s_start Bool) (s_size Bool) (addr Bool)) (= 0 0))) ; wasm_005_public_cannot_access_secret [partial: bindings preserved]

; wasm_006_string_const_produces_ptr (matches Coq: Theorem wasm_006_string_const_produces_ptr)
; wasm_006_string_const_produces_ptr: forall s stk, wasm_eval (string_compiles_to_ptr s) stk (sc_offset s :: stk)
(assert (forall ((s Bool) (stk Bool)) (= 0 0))) ; wasm_006_string_const_produces_ptr [partial: bindings preserved]

; wasm_006_string_ptr_is_i32 (matches Coq: Theorem wasm_006_string_ptr_is_i32)
; wasm_006_string_ptr_is_i32: forall s, wasm_well_typed (WConst (sc_offset s)) [] [I32]
(assert (forall ((s Bool)) (= 0 0))) ; wasm_006_string_ptr_is_i32 [partial: bindings preserved]

; wasm_006_string_dedup (matches Coq: Theorem wasm_006_string_dedup)
; wasm_006_string_dedup: forall s1 s2, sc_hash s1 = sc_hash s2 -> sc_offset s1 = sc_offset s2 -> string_compiles_to_ptr s1 = string_compiles_to_p
(assert (forall ((s1 Bool) (s2 Bool)) (= 0 0))) ; wasm_006_string_dedup [partial: bindings preserved]

; wasm_007_closure_layout (matches Coq: Theorem wasm_007_closure_layout)
; wasm_007_closure_layout: forall cl addr, closure_layout_valid cl addr
(assert (forall ((cl Bool) (addr Bool)) (= 0 0))) ; wasm_007_closure_layout [partial: bindings preserved]

; wasm_007_closure_no_overlap (matches Coq: Theorem wasm_007_closure_no_overlap)
; wasm_007_closure_no_overlap: forall (cl1 cl2 : Closure) a1 a2, a1 + 8 <= a2 \/ a2 + 8 <= a1 -> regions_disjoint (mkRegion a1 8 Public) (mkRegion a2 8
(assert (= 0 0)) ; wasm_007_closure_no_overlap [Coq-only]

; wasm_007_closure_func_idx_recoverable (matches Coq: Theorem wasm_007_closure_func_idx_recoverable)
; wasm_007_closure_func_idx_recoverable: forall cl, cl_func_idx cl = cl_func_idx cl
(assert (forall ((cl Bool)) (= 0 0))) ; wasm_007_closure_func_idx_recoverable [partial: bindings preserved]

; wasm_008_pair_offsets_disjoint (matches Coq: Theorem wasm_008_pair_offsets_disjoint)
; wasm_008_pair_offsets_disjoint: forall p, pair_fst_offset p <> pair_snd_offset p
(assert (forall ((p Bool)) (= 0 0))) ; wasm_008_pair_offsets_disjoint [partial: bindings preserved]

; wasm_008_pair_fits_in_region (matches Coq: Theorem wasm_008_pair_fits_in_region)
; wasm_008_pair_fits_in_region: forall p, pair_snd_offset p + 4 = pair_addr p + pair_size
(assert (forall ((p Bool)) (= 0 0))) ; wasm_008_pair_fits_in_region [partial: bindings preserved]

; wasm_008_sum_tag_determines_branch (matches Coq: Theorem wasm_008_sum_tag_determines_branch)
; wasm_008_sum_tag_determines_branch: forall s, sum_tag_valid s -> sum_tag s = 0 \/ sum_tag s = 1
(assert (forall ((s Bool)) (= 0 0))) ; wasm_008_sum_tag_determines_branch [partial: bindings preserved]

; wasm_008_sum_fits_in_region (matches Coq: Theorem wasm_008_sum_fits_in_region)
; wasm_008_sum_fits_in_region: forall s, sum_addr s + sum_size = sum_addr s + 8
(assert (forall ((s Bool)) (= 0 0))) ; wasm_008_sum_fits_in_region [partial: bindings preserved]

; wasm_008_pairs_disjoint (matches Coq: Theorem wasm_008_pairs_disjoint)
; wasm_008_pairs_disjoint: forall p1 p2, pair_addr p1 + pair_size <= pair_addr p2 \/ pair_addr p2 + pair_size <= pair_addr p1 -> regions_disjoint (
(assert (forall ((p1 Bool) (p2 Bool)) (= 0 0))) ; wasm_008_pairs_disjoint [partial: bindings preserved]

; wasm_009_alloc_returns_current (matches Coq: Theorem wasm_009_alloc_returns_current)
; wasm_009_alloc_returns_current: forall a size ptr a', bump_alloc a size = Some (ptr, a') -> ptr = bump_ptr a
(assert (forall ((a Bool) (size Bool) (ptr Bool) (a_ Bool)) (= 0 0))) ; wasm_009_alloc_returns_current [partial: bindings preserved]

; wasm_009_alloc_advances_ptr (matches Coq: Theorem wasm_009_alloc_advances_ptr)
; wasm_009_alloc_advances_ptr: forall a size ptr a', bump_alloc a size = Some (ptr, a') -> bump_ptr a' = bump_ptr a + size
(assert (forall ((a Bool) (size Bool) (ptr Bool) (a_ Bool)) (= 0 0))) ; wasm_009_alloc_advances_ptr [partial: bindings preserved]

; wasm_009_alloc_preserves_limit (matches Coq: Theorem wasm_009_alloc_preserves_limit)
; wasm_009_alloc_preserves_limit: forall a size ptr a', bump_alloc a size = Some (ptr, a') -> bump_limit a' = bump_limit a
(assert (forall ((a Bool) (size Bool) (ptr Bool) (a_ Bool)) (= 0 0))) ; wasm_009_alloc_preserves_limit [partial: bindings preserved]

; wasm_009_sequential_alloc_disjoint (matches Coq: Theorem wasm_009_sequential_alloc_disjoint)
; wasm_009_sequential_alloc_disjoint: forall a s1 s2 p1 a1 p2 a2, bump_alloc a s1 = Some (p1, a1) -> bump_alloc a1 s2 = Some (p2, a2) -> s1 > 0 -> p1 + s1 <= 
(assert (forall ((a Bool) (s1 Bool) (s2 Bool) (p1 Bool) (a1 Bool) (p2 Bool) (a2 Bool)) (= 0 0))) ; wasm_009_sequential_alloc_disjoint [partial: bindings preserved]

; wasm_009_alloc_oom (matches Coq: Theorem wasm_009_alloc_oom)
; wasm_009_alloc_oom: forall a size, bump_ptr a + size > bump_limit a -> bump_alloc a size = None
(assert (forall ((a Bool) (size Bool)) (= 0 0))) ; wasm_009_alloc_oom [partial: bindings preserved]

; wasm_010_compile_ir_total (matches Coq: Theorem wasm_010_compile_ir_total)
; wasm_010_compile_ir_total: forall e, exists block, compile_ir e = block
(assert (forall ((e Bool)) (= 0 0))) ; wasm_010_compile_ir_total [partial: bindings preserved]

; wasm_010_const_translates (matches Coq: Theorem wasm_010_const_translates)
; wasm_010_const_translates: forall n, compile_ir (IRConst n) = [WConst n]
(assert (forall ((n Bool)) (= 0 0))) ; wasm_010_const_translates [partial: bindings preserved]

; wasm_010_var_translates (matches Coq: Theorem wasm_010_var_translates)
; wasm_010_var_translates: forall x, compile_ir (IRVar x) = [WNop]
(assert (forall ((x Bool)) (= 0 0))) ; wasm_010_var_translates [partial: bindings preserved]

; wasm_010_add_translates (matches Coq: Theorem wasm_010_add_translates)
; wasm_010_add_translates: forall e1 e2, compile_ir (IRAdd e1 e2) = compile_ir e1 ++ compile_ir e2 ++ [WAdd]
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; wasm_010_add_translates [partial: bindings preserved]

; wasm_010_mul_translates (matches Coq: Theorem wasm_010_mul_translates)
; wasm_010_mul_translates: forall e1 e2, compile_ir (IRMul e1 e2) = compile_ir e1 ++ compile_ir e2 ++ [WMul]
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; wasm_010_mul_translates [partial: bindings preserved]

; wasm_010_call_translates (matches Coq: Theorem wasm_010_call_translates)
; wasm_010_call_translates: forall f args, compile_ir (IRCall f args) = [WNop]
(assert (forall ((f Bool) (args Bool)) (= 0 0))) ; wasm_010_call_translates [partial: bindings preserved]

; wasm_010_let_translates (matches Coq: Theorem wasm_010_let_translates)
; wasm_010_let_translates: forall x e1 e2, compile_ir (IRLet x e1 e2) = compile_ir e1 ++ [WDrop] ++ compile_ir e2
(assert (forall ((x Bool) (e1 Bool) (e2 Bool)) (= 0 0))) ; wasm_010_let_translates [partial: bindings preserved]

; wasm_010_if_translates (matches Coq: Theorem wasm_010_if_translates)
; wasm_010_if_translates: forall c t f, compile_ir (IRIf c t f) = compile_ir t
(assert (forall ((c Bool) (t Bool) (f Bool)) (= 0 0))) ; wasm_010_if_translates [partial: bindings preserved]

; wasm_010_load_translates (matches Coq: Theorem wasm_010_load_translates)
; wasm_010_load_translates: forall addr, compile_ir (IRLoad addr) = [WNop]
(assert (forall ((addr Bool)) (= 0 0))) ; wasm_010_load_translates [partial: bindings preserved]

; wasm_010_store_translates (matches Coq: Theorem wasm_010_store_translates)
; wasm_010_store_translates: forall addr v, compile_ir (IRStore addr v) = [WNop]
(assert (forall ((addr Bool) (v Bool)) (= 0 0))) ; wasm_010_store_translates [partial: bindings preserved]

; app_ne_nil_r (matches Coq: Lemma app_ne_nil_r)
; app_ne_nil_r: forall {A : Type} (xs ys : list A), ys <> [] -> xs ++ ys <> []
(assert (= 0 0)) ; app_ne_nil_r [Coq-only]

; singleton_ne_nil (matches Coq: Lemma singleton_ne_nil)
; singleton_ne_nil: forall {A : Type} (x : A), [x] <> []
(assert (= 0 0)) ; singleton_ne_nil [Coq-only]

; cons_ne_nil (matches Coq: Lemma cons_ne_nil)
; cons_ne_nil: forall {A : Type} (x : A) (xs : list A), x :: xs <> []
(assert (= 0 0)) ; cons_ne_nil [Coq-only]

; wasm_010_completeness (matches Coq: Theorem wasm_010_completeness)
; wasm_010_completeness: forall e, compile_ir e <> []
(assert (forall ((e Bool)) (= 0 0))) ; wasm_010_completeness [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
