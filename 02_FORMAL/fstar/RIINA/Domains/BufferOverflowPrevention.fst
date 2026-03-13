(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/BufferOverflowPrevention.v (22 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.BufferOverflowPrevention
open FStar.All

(* Buffer (matches Coq) *)
type buffer = {
  f_buf_size: nat;
  f_buf_used: nat;
}

(* OverflowPrevention (matches Coq) *)
type overflow_prevention = {
  f_op_bounds_check_write: bool;
  f_op_bounds_check_read: bool;
  f_op_null_terminator_check: bool;
  f_op_integer_overflow_check: bool;
  f_op_stack_canaries: bool;
}

(* buffer_valid (matches Coq: Definition buffer_valid) *)
let buffer_valid (p_b: buffer) : Tot bool =
  (p_b.f_buf_used) <= (p_b.f_buf_size)

(* buffer_can_write (matches Coq: Definition buffer_can_write) *)
let buffer_can_write (p_b: buffer) (p_n: nat) : Tot bool =
  (p_b.f_buf_used + p_n) <= (p_b.f_buf_size)

(* buffer_can_read (matches Coq: Definition buffer_can_read) *)
let buffer_can_read (p_b: buffer) (p_offset: nat) (p_len: nat) : Tot bool =
  (p_offset + p_len) <= (p_b.f_buf_used)

(* overflow_protected (matches Coq: Definition overflow_protected) *)
let overflow_protected (p_p: overflow_prevention) : Tot bool =
  p_p.f_op_bounds_check_write && p_p.f_op_bounds_check_read && p_p.f_op_null_terminator_check && p_p.f_op_integer_overflow_check && p_p.f_op_stack_canaries

(* riina_overflow_config (matches Coq: Definition riina_overflow_config) *)
let riina_overflow_config : overflow_prevention = {f_op_bounds_check_write=true; f_op_bounds_check_read=true; f_op_null_terminator_check=true; f_op_integer_overflow_check=true; f_op_stack_canaries=true}

(* test_buffer (matches Coq: Definition test_buffer) *)
let test_buffer : buffer = {f_buf_size=100; f_buf_used=50}

(* andb_true_iff (matches Coq: Lemma andb_true_iff) *)
let andb_true_iff (p_a: bool) (p_b: bool) : Lemma (p_a && p_b == true <==> p_a == true /\ p_b == true) = ()

(* BOF_001_test_buffer_valid (matches Coq: Theorem BOF_001_test_buffer_valid) *)
let bof_001_test_buffer_valid () : Lemma (buffer_valid test_buffer == true) = ()

(* BOF_002_can_write_bounds (matches Coq: Theorem BOF_002_can_write_bounds) *)
let bof_002_can_write_bounds () : Lemma (buffer_can_write test_buffer 50 == true) = ()

(* BOF_003_cannot_write_beyond (matches Coq: Theorem BOF_003_cannot_write_beyond) *)
let bof_003_cannot_write_beyond () : Lemma (buffer_can_write test_buffer 51 == false) = ()

(* BOF_004_can_read_used (matches Coq: Theorem BOF_004_can_read_used) *)
let bof_004_can_read_used () : Lemma (buffer_can_read test_buffer 0 50 == true) = ()

(* BOF_005_cannot_read_beyond (matches Coq: Theorem BOF_005_cannot_read_beyond) *)
let bof_005_cannot_read_beyond () : Lemma (buffer_can_read test_buffer 0 51 == false) = ()

(* BOF_006_riina_protected (matches Coq: Theorem BOF_006_riina_protected) *)
let bof_006_riina_protected () : Lemma (overflow_protected riina_overflow_config == true) = ()

(* BOF_007_bounds_check_write (matches Coq: Theorem BOF_007_bounds_check_write) *)
let bof_007_bounds_check_write (p_p: overflow_prevention) : Lemma (requires (overflow_protected p_p == true)) (ensures (p_p.f_op_bounds_check_write == true)) = ()

(* BOF_008_bounds_check_read (matches Coq: Theorem BOF_008_bounds_check_read) *)
let bof_008_bounds_check_read (p_p: overflow_prevention) : Lemma (requires (overflow_protected p_p == true)) (ensures (p_p.f_op_bounds_check_read == true)) = ()

(* BOF_009_integer_overflow (matches Coq: Theorem BOF_009_integer_overflow) *)
let bof_009_integer_overflow (p_p: overflow_prevention) : Lemma (requires (overflow_protected p_p == true)) (ensures (p_p.f_op_integer_overflow_check == true)) = ()

(* BOF_010_stack_canaries (matches Coq: Theorem BOF_010_stack_canaries) *)
let bof_010_stack_canaries (p_p: overflow_prevention) : Lemma (requires (overflow_protected p_p == true)) (ensures (p_p.f_op_stack_canaries == true)) = ()

(* BOF_011_valid_implies_bounds (matches Coq: Theorem BOF_011_valid_implies_bounds) *)
let bof_011_valid_implies_bounds (p_b: buffer) : Lemma (requires (buffer_valid p_b == true)) (ensures ((buf_used p_b) (p_b.f_buf_size) == true)) = ()

(* BOF_012_riina_bounds_write (matches Coq: Theorem BOF_012_riina_bounds_write) *)
let bof_012_riina_bounds_write () : Lemma (riina_overflow_config.f_op_bounds_check_write == true) = ()

(* BOF_013_riina_canaries (matches Coq: Theorem BOF_013_riina_canaries) *)
let bof_013_riina_canaries () : Lemma (riina_overflow_config.f_op_stack_canaries == true) = ()

(* BOF_014_zero_write_safe (matches Coq: Theorem BOF_014_zero_write_safe) *)
let bof_014_zero_write_safe (p_b: buffer) : Lemma (requires (buffer_valid p_b == true)) (ensures (buffer_can_write p_b 0 == true)) = ()

(* BOF_015_complete_prevention (matches Coq: Theorem BOF_015_complete_prevention) *)
let bof_015_complete_prevention (p_p: overflow_prevention) : Lemma (requires (overflow_protected p_p == true)) (ensures (p_p.f_op_bounds_check_write == true /\ p_p.f_op_bounds_check_read == true /\ p_p.f_op_integer_overflow_check == true /\ p_p.f_op_stack_canaries == true)) = ()

(* BOF_016_write_bounded (matches Coq: Theorem BOF_016_write_bounded) *)
let bof_016_write_bounded (p_b: nat) (p_n: nat) : Lemma (requires (buffer_can_write (mkbuffer p_b 0) p_n == true)) (ensures (p_n <= p_b)) = ()

(* BOF_017_read_start_within (matches Coq: Theorem BOF_017_read_start_within) *)
let bof_017_read_start_within (p_b: _) (p_offset: _) (p_len: _) : Lemma (requires (buffer_can_read p_b p_offset p_len == true)) (ensures (p_offset <= p_b.f_buf_used)) = ()

(* BOF_018_zero_read_safe (matches Coq: Theorem BOF_018_zero_read_safe) *)
let bof_018_zero_read_safe (p_b: buffer) : Lemma (buffer_can_read p_b 0 0 == true) = ()

(* BOF_019_full_buffer_no_write (matches Coq: Theorem BOF_019_full_buffer_no_write) *)
let bof_019_full_buffer_no_write (p_sz: nat) : Lemma (buffer_can_write (mkbuffer p_sz p_sz) 1 == false) = ()

(* BOF_020_null_terminator_check (matches Coq: Theorem BOF_020_null_terminator_check) *)
let bof_020_null_terminator_check (p_p: overflow_prevention) : Lemma (requires (overflow_protected p_p == true)) (ensures (p_p.f_op_null_terminator_check == true)) = ()

(* BOF_021_valid_after_write (matches Coq: Theorem BOF_021_valid_after_write) *)
let bof_021_valid_after_write (p_b: nat) (p_n: nat) : Lemma (buffer_can_write (mkbuffer (p_b + p_n) p_b) p_n == true) = ()
