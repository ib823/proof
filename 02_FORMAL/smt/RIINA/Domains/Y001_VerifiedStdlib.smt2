; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/Y001_VerifiedStdlib.v (41 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: Y001_VerifiedStdlib

(set-logic ALL)
(set-option :produce-models true)

; IOEffect (matches Coq: Inductive IOEffect)
(declare-datatypes ((IOEffect 0)) (((ReadFile) (WriteFile) (Network))))

; JsonValue (matches Coq: Inductive JsonValue)
(declare-datatypes ((JsonValue 0)) (((JsonNull) (JsonBool) (JsonNum) (JsonString) (JsonArray))))

; Utf8String (matches Coq: Record Utf8String)
(declare-datatypes ((Utf8String 0))
  (((mk-utf8_string (utf8_bytes (Seq Int)) (utf8_valid Int)))))

; BoundedRead (matches Coq: Record BoundedRead)
(declare-datatypes ((BoundedRead 0))
  (((mk-bounded_read (read_data (Seq Int)) (read_requested Int) (read_actual Int) (read_bounds_ok Int)))))

(declare-const __default_BoundedRead BoundedRead)
(declare-const __default_IOEffect IOEffect)
(declare-const __default_JsonValue JsonValue)
(declare-const __default_Utf8String Utf8String)

; is_utf8_continuation (matches Coq: Definition is_utf8_continuation)
(define-fun is_utf8_continuation ((b Int)) Bool
  (= 0 0))

; is_utf8_start_1 (matches Coq: Definition is_utf8_start_1)
(define-fun is_utf8_start_1 ((b Int)) Bool
  (= 0 0))

; is_utf8_start_2 (matches Coq: Definition is_utf8_start_2)
(define-fun is_utf8_start_2 ((b Int)) Bool
  (= 0 0))

; is_utf8_start_3 (matches Coq: Definition is_utf8_start_3)
(define-fun is_utf8_start_3 ((b Int)) Bool
  (= 0 0))

; is_utf8_start_4 (matches Coq: Definition is_utf8_start_4)
(define-fun is_utf8_start_4 ((b Int)) Bool
  (= 0 0))

; is_valid_utf8 (matches Coq: Definition is_valid_utf8)
(define-fun is_valid_utf8 ((bytes (Seq Int))) Bool
  (= 0 0))

; utf8_len_bytes (matches Coq: Definition utf8_len_bytes)
(define-fun utf8_len_bytes ((s Utf8String)) Int
  0)

; utf8_char_count (matches Coq: Definition utf8_char_count)
(define-fun utf8_char_count ((bytes (Seq Int))) Int
  0)

; utf8_len_chars (matches Coq: Definition utf8_len_chars)
(define-fun utf8_len_chars ((s Utf8String)) Int
  0)

; bigint_add (matches Coq: Definition bigint_add)
(define-fun bigint_add ((a Int) (b Int)) Int
  0)

; Y_001_01_option_map_correct (matches Coq: Theorem Y_001_01_option_map_correct)
; Y_001_01_option_map_correct: forall (A B : Type) (f : A -> B) (o : option A), (forall x, o = Some x -> option_map f o = Some (f x)) /\ (o = None -> o
(assert (forall ((A Int) (B Int) (f Int) (o Int)) (= 0 0))) ; Y_001_01_option_map_correct [partial: bindings preserved]

; Y_001_02_option_bind_correct (matches Coq: Theorem Y_001_02_option_bind_correct)
; Y_001_02_option_bind_correct: forall (A B C : Type) (o : option A) (f : A -> option B) (g : B -> option C), option_bind (option_bind o f) g = option_b
(assert (forall ((A Int) (B Int) (C Int) (o Int) (f Int) (g Int)) (= 0 0))) ; Y_001_02_option_bind_correct [partial: bindings preserved]

; Y_001_03_result_map_correct (matches Coq: Theorem Y_001_03_result_map_correct)
; Y_001_03_result_map_correct: forall (A B E : Type) (f : A -> B) (r : Result A E), (forall x, r = Ok x -> result_map f r = Ok (f x)) /\ (forall e, r =
(assert (forall ((A Int) (B Int) (E Int) (f Int) (r Int)) (= 0 0))) ; Y_001_03_result_map_correct [partial: bindings preserved]

; Y_001_04_result_and_then_correct (matches Coq: Theorem Y_001_04_result_and_then_correct)
; Y_001_04_result_and_then_correct: forall (A B C E : Type) (r : Result A E) (f : A -> Result B E) (g : B -> Result C E), result_and_then (result_and_then r
(assert (forall ((A Int) (B Int) (C Int) (E Int) (r Int) (f Int) (g Int)) (= 0 0))) ; Y_001_04_result_and_then_correct [partial: bindings preserved]

; Y_001_05_option_unwrap_safe (matches Coq: Theorem Y_001_05_option_unwrap_safe)
; Y_001_05_option_unwrap_safe: forall (A : Type) (o : option A) (default val : A), option_unwrap o default = val -> (o = Some val) \/ (o = None /\ val 
(assert (forall ((A Int) (o Int) (default Int) (v_val Int)) (= 0 0))) ; Y_001_05_option_unwrap_safe [partial: bindings preserved]

; Y_001_06_result_unwrap_safe (matches Coq: Theorem Y_001_06_result_unwrap_safe)
; Y_001_06_result_unwrap_safe: forall (A E : Type) (r : Result A E) (default val : A), result_unwrap r default = val -> (exists x, r = Ok x /\ val = x)
(assert (forall ((A Int) (E Int) (r Int) (default Int) (v_val Int)) (= 0 0))) ; Y_001_06_result_unwrap_safe [partial: bindings preserved]

; Y_001_07_option_or_default (matches Coq: Theorem Y_001_07_option_or_default)
; Y_001_07_option_or_default: forall (A : Type) (default : A), option_or_default None default = default
(assert (forall ((A Int) (default Int)) (= 0 0))) ; Y_001_07_option_or_default [partial: bindings preserved]

; Y_001_08_result_or_default (matches Coq: Theorem Y_001_08_result_or_default)
; Y_001_08_result_or_default: forall (A E : Type) (e : E) (default : A), result_or_default (Err e) default = default
(assert (forall ((A Int) (E Int) (e Int) (default Int)) (= 0 0))) ; Y_001_08_result_or_default [partial: bindings preserved]

; Y_001_09_vec_push_correct (matches Coq: Theorem Y_001_09_vec_push_correct)
; Y_001_09_vec_push_correct: forall (A : Type) (v : Vec A) (x : A), vec_data (vec_push v x) = vec_data v ++ [x]
(assert (forall ((A Int) (v Int) (x Int)) (= 0 0))) ; Y_001_09_vec_push_correct [partial: bindings preserved]

; Y_001_10_vec_pop_correct (matches Coq: Theorem Y_001_10_vec_pop_correct)
; Y_001_10_vec_pop_correct: forall (A : Type) (v : Vec A) (x : A), vec_pop v = Some x -> vec_data v <> []
(assert (forall ((A Int) (v Int) (x Int)) (= 0 0))) ; Y_001_10_vec_pop_correct [partial: bindings preserved]

; Y_001_11_vec_get_bounds (matches Coq: Theorem Y_001_11_vec_get_bounds)
; Y_001_11_vec_get_bounds: forall (A : Type) (v : Vec A) (i : nat), i >= vec_length v -> vec_get v i = None
(assert (forall ((A Int) (v Int) (i Int)) (= 0 0))) ; Y_001_11_vec_get_bounds [partial: bindings preserved]

; Y_001_12_vec_len_accurate (matches Coq: Theorem Y_001_12_vec_len_accurate)
; Y_001_12_vec_len_accurate: forall (A : Type) (v : Vec A), vec_len v = length (vec_data v)
(assert (forall ((A Int) (v Int)) (= 0 0))) ; Y_001_12_vec_len_accurate [partial: bindings preserved]

; Y_001_13_hashmap_get_put (matches Coq: Theorem Y_001_13_hashmap_get_put)
; Y_001_13_hashmap_get_put: forall (K V : Type) (eq_dec : forall k1 k2 : K, {k1 = k2} + {k1 <> k2}) (m : HashMap K V) (k : K) (v : V), hashmap_get e
(assert (forall ((K Int) (V Int) (eq_dec Int) (m Int) (k Int) (v Int)) (= 0 0))) ; Y_001_13_hashmap_get_put [partial: bindings preserved]

; Y_001_14_hashmap_get_other (matches Coq: Theorem Y_001_14_hashmap_get_other)
; Y_001_14_hashmap_get_other: forall (K V : Type) (eq_dec : forall k1 k2 : K, {k1 = k2} + {k1 <> k2}) (m : HashMap K V) (k1 k2 : K) (v : V), k1 <> k2 
(assert (forall ((K Int) (V Int) (eq_dec Int) (m Int) (k1 Int) (k2 Int) (v Int)) (= 0 0))) ; Y_001_14_hashmap_get_other [partial: bindings preserved]

; Y_001_14b_hashmap_different_key (matches Coq: Theorem Y_001_14b_hashmap_different_key)
; Y_001_14b_hashmap_different_key: forall (K V : Type) (eq_dec : forall k1 k2 : K, {k1 = k2} + {k1 <> k2}) (k1 k2 : K) (v : V), k1 <> k2 -> hashmap_get eq_
(assert (forall ((K Int) (V Int) (eq_dec Int) (k1 Int) (k2 Int) (v Int)) (= 0 0))) ; Y_001_14b_hashmap_different_key [partial: bindings preserved]

; Y_001_15_hashmap_remove_correct (matches Coq: Theorem Y_001_15_hashmap_remove_correct)
; Y_001_15_hashmap_remove_correct: forall (K V : Type) (eq_dec : forall k1 k2 : K, {k1 = k2} + {k1 <> k2}) (m : HashMap K V) (k : K), hashmap_get eq_dec (h
(assert (forall ((K Int) (V Int) (eq_dec Int) (m Int) (k Int)) (= 0 0))) ; Y_001_15_hashmap_remove_correct [partial: bindings preserved]

; Y_001_16_btree_ordered (matches Coq: Theorem Y_001_16_btree_ordered)
; Y_001_16_btree_ordered: forall (A : Type) (lt : A -> A -> bool) (t : BTree A), btree_ordered lt t None None = true -> True
(assert (forall ((A Int) (lt Int) (t Int)) (= 0 0))) ; Y_001_16_btree_ordered [partial: bindings preserved]

; Y_001_17_btree_balanced (matches Coq: Theorem Y_001_17_btree_balanced)
; Y_001_17_btree_balanced: forall (A : Type) (t : BTree A), btree_balanced t = true -> True
(assert (forall ((A Int) (t Int)) (= 0 0))) ; Y_001_17_btree_balanced [partial: bindings preserved]

; Y_001_18_collection_no_overflow (matches Coq: Theorem Y_001_18_collection_no_overflow)
; Y_001_18_collection_no_overflow: forall (A : Type) (v : Vec A) (x : A), vec_length (vec_push v x) = S (vec_length v)
(assert (forall ((A Int) (v Int) (x Int)) (= 0 0))) ; Y_001_18_collection_no_overflow [partial: bindings preserved]

; Y_001_19_utf8_valid_preserved (matches Coq: Theorem Y_001_19_utf8_valid_preserved)
; Y_001_19_utf8_valid_preserved: forall (s : Utf8String), is_valid_utf8 (utf8_bytes s) = true
(assert (forall ((s Utf8String)) (= 0 0))) ; Y_001_19_utf8_valid_preserved [partial: bindings preserved]

; Y_001_20_string_concat_valid (matches Coq: Theorem Y_001_20_string_concat_valid)
; Y_001_20_string_concat_valid: forall (s1 s2 : Utf8String), is_valid_utf8 (utf8_bytes s1) = true -> is_valid_utf8 (utf8_bytes s2) = true -> True
(assert (forall ((s1 Utf8String) (s2 Utf8String)) (= 0 0))) ; Y_001_20_string_concat_valid [partial: bindings preserved]

; Y_001_21_string_len_bytes (matches Coq: Theorem Y_001_21_string_len_bytes)
; Y_001_21_string_len_bytes: forall (s : Utf8String), utf8_len_bytes s = length (utf8_bytes s)
(assert (forall ((s Utf8String)) (= 0 0))) ; Y_001_21_string_len_bytes [partial: bindings preserved]

; Y_001_22_string_len_chars (matches Coq: Theorem Y_001_22_string_len_chars)
; Y_001_22_string_len_chars: forall (s : Utf8String), utf8_len_chars s = utf8_char_count (utf8_bytes s)
(assert (forall ((s Utf8String)) (= 0 0))) ; Y_001_22_string_len_chars [partial: bindings preserved]

; Y_001_23_string_slice_valid (matches Coq: Theorem Y_001_23_string_slice_valid)
; Y_001_23_string_slice_valid: forall (s : Utf8String) (start len : nat), is_valid_utf8 (utf8_bytes s) = true -> True
(assert (forall ((s Utf8String) (start Int) (len Int)) (= 0 0))) ; Y_001_23_string_slice_valid [partial: bindings preserved]

; Y_001_24_format_bounded (matches Coq: Theorem Y_001_24_format_bounded)
; Y_001_24_format_bounded: forall (fmt : list nat) (max_output : nat), length fmt <= max_output -> True
(assert (forall ((fmt (Seq Int)) (max_output Int)) (= 0 0))) ; Y_001_24_format_bounded [partial: bindings preserved]

; Y_001_25_no_format_string_attack (matches Coq: Theorem Y_001_25_no_format_string_attack)
; Y_001_25_no_format_string_attack: forall (fmt : list nat), True
(assert (forall ((fmt (Seq Int))) (= 0 0))) ; Y_001_25_no_format_string_attack [partial: bindings preserved]

; Y_001_26_string_compare_correct (matches Coq: Theorem Y_001_26_string_compare_correct)
; Y_001_26_string_compare_correct: forall (s1 s2 : list nat), (s1 = s2 <-> s1 = s2)
(assert (forall ((s1 (Seq Int)) (s2 (Seq Int))) (= 0 0))) ; Y_001_26_string_compare_correct [partial: bindings preserved]

; Y_001_27_io_effect_tracked (matches Coq: Theorem Y_001_27_io_effect_tracked)
; Y_001_27_io_effect_tracked: forall (A : Type) (io : TrackedIO A), exists effects, io_effects io = effects
(assert (forall ((A Int) (io Int)) (= 0 0))) ; Y_001_27_io_effect_tracked [partial: bindings preserved]

; Y_001_28_file_read_bounds (matches Coq: Theorem Y_001_28_file_read_bounds)
; Y_001_28_file_read_bounds: forall (r : BoundedRead), read_actual r <= read_requested r
(assert (forall ((r BoundedRead)) (= 0 0))) ; Y_001_28_file_read_bounds [partial: bindings preserved]

; Y_001_29_json_parse_pure (matches Coq: Theorem Y_001_29_json_parse_pure)
; Y_001_29_json_parse_pure: forall (input : list nat) (v : JsonValue), True
(assert (forall ((input (Seq Int)) (v JsonValue)) (= 0 0))) ; Y_001_29_json_parse_pure [partial: bindings preserved]

; Y_001_30_json_roundtrip (matches Coq: Theorem Y_001_30_json_roundtrip)
; Y_001_30_json_roundtrip: forall (v : JsonValue), v = v
(assert (forall ((v JsonValue)) (= 0 0))) ; Y_001_30_json_roundtrip [partial: bindings preserved]

; Y_001_31_json_parse_terminates (matches Coq: Theorem Y_001_31_json_parse_terminates)
; Y_001_31_json_parse_terminates: forall (input : list nat), True
(assert (forall ((input (Seq Int))) (= 0 0))) ; Y_001_31_json_parse_terminates [partial: bindings preserved]

; Y_001_32_xml_parse_safe (matches Coq: Theorem Y_001_32_xml_parse_safe)
; Y_001_32_xml_parse_safe: forall (input : list nat), True
(assert (forall ((input (Seq Int))) (= 0 0))) ; Y_001_32_xml_parse_safe [partial: bindings preserved]

; Y_001_33_regex_terminates (matches Coq: Theorem Y_001_33_regex_terminates)
; Y_001_33_regex_terminates: forall (pattern input : list nat), True
(assert (forall ((pattern (Seq Int)) (input (Seq Int))) (= 0 0))) ; Y_001_33_regex_terminates [partial: bindings preserved]

; Y_001_34_regex_no_redos (matches Coq: Theorem Y_001_34_regex_no_redos)
; Y_001_34_regex_no_redos: forall (pattern input : list nat), True
(assert (forall ((pattern (Seq Int)) (input (Seq Int))) (= 0 0))) ; Y_001_34_regex_no_redos [partial: bindings preserved]

; Y_001_35_int_add_no_overflow (matches Coq: Theorem Y_001_35_int_add_no_overflow)
; Y_001_35_int_add_no_overflow: forall (a b max_val : Z), (a + b > max_val)%Z -> checked_add a b max_val = None
(assert (forall ((a Int) (b Int) (max_val Int)) (= 0 0))) ; Y_001_35_int_add_no_overflow [partial: bindings preserved]

; Y_001_36_int_mul_no_overflow (matches Coq: Theorem Y_001_36_int_mul_no_overflow)
; Y_001_36_int_mul_no_overflow: forall (a b max_val : Z), (a * b > max_val)%Z -> checked_mul a b max_val = None
(assert (forall ((a Int) (b Int) (max_val Int)) (= 0 0))) ; Y_001_36_int_mul_no_overflow [partial: bindings preserved]

; Y_001_37_int_div_no_zero (matches Coq: Theorem Y_001_37_int_div_no_zero)
; Y_001_37_int_div_no_zero: forall (a : Z), checked_div a 0%Z = None
(assert (forall ((a Int)) (= 0 0))) ; Y_001_37_int_div_no_zero [partial: bindings preserved]

; Y_001_38_float_nan_propagates (matches Coq: Theorem Y_001_38_float_nan_propagates)
; Y_001_38_float_nan_propagates: forall (a : Z) (max_val : Z), checked_add a 0%Z max_val = checked_add a 0%Z max_val
(assert (forall ((a Int) (max_val Int)) (= 0 0))) ; Y_001_38_float_nan_propagates [partial: bindings preserved]

; Y_001_39_bigint_correct (matches Coq: Theorem Y_001_39_bigint_correct)
; Y_001_39_bigint_correct: forall (a b : BigInt), length (bigint_add a b) = length a + length b
(assert (forall ((a Int) (b Int)) (= 0 0))) ; Y_001_39_bigint_correct [partial: bindings preserved]

; Y_001_40_numeric_constant_time (matches Coq: Theorem Y_001_40_numeric_constant_time)
; Y_001_40_numeric_constant_time: forall (a b max_val : Z), exists result, checked_add a b max_val = result
(assert (forall ((a Int) (b Int) (max_val Int)) (= 0 0))) ; Y_001_40_numeric_constant_time [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
