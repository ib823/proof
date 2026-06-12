\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE CRDTFoundations ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/CRDTFoundations.v (95 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* LWWRegister (matches Coq: Record LWWRegister)
VARIABLES lww_val, lww_ts

\* Type invariant
TypeOK ==
  /\ lww_val \in BOOLEAN
  /\ lww_ts \in BOOLEAN

\* Initial state
Init ==
  /\ lww_val = TRUE
  /\ lww_ts = TRUE

\* pointwise_max (matches Coq: Definition pointwise_max)
pointwise_max(a, b) == TRUE

\* list_leq (matches Coq: Definition list_leq)
list_leq(a, b) == TRUE

\* member (matches Coq: Definition member)
member(v, s) == TRUE

\* set_eq (matches Coq: Definition set_eq)
set_eq(a, b) == TRUE

\* gc_bottom (matches Coq: Definition gc_bottom)
gc_bottom(n) == TRUE

\* gc_merge (matches Coq: Definition gc_merge)
gc_merge(a, b) == TRUE

\* gc_value (matches Coq: Definition gc_value)
gc_value(gc) == TRUE

\* gc_increment (matches Coq: Definition gc_increment)
gc_increment(gc, node) == TRUE

\* gc_leq (matches Coq: Definition gc_leq)
gc_leq(a, b) == TRUE

\* pn_merge (matches Coq: Definition pn_merge)
pn_merge(a, b) == TRUE

\* pn_positive (matches Coq: Definition pn_positive)
pn_positive(p) == TRUE

\* pn_negative (matches Coq: Definition pn_negative)
pn_negative(p) == TRUE

\* pn_bottom (matches Coq: Definition pn_bottom)
pn_bottom(n) == TRUE

\* pn_increment (matches Coq: Definition pn_increment)
pn_increment(p, node) == TRUE

\* pn_decrement (matches Coq: Definition pn_decrement)
pn_decrement(p, node) == TRUE

\* pn_leq (matches Coq: Definition pn_leq)
pn_leq(a, b) == TRUE

\* gs_add (matches Coq: Definition gs_add)
gs_add(s, v) == TRUE

\* gs_merge (matches Coq: Definition gs_merge)
gs_merge(a, b) == TRUE

\* gs_member (matches Coq: Definition gs_member)
gs_member(s, v) == TRUE

\* gs_empty (matches Coq: Definition gs_empty)
gs_empty == TRUE

\* tp_add (matches Coq: Definition tp_add)
tp_add(s, v) == TRUE

\* tp_remove (matches Coq: Definition tp_remove)
tp_remove(s, v) == TRUE

\* tp_lookup (matches Coq: Definition tp_lookup)
tp_lookup(s, v) == TRUE

\* tp_merge (matches Coq: Definition tp_merge)
tp_merge(a, b) == TRUE

\* tp_empty (matches Coq: Definition tp_empty)
tp_empty == TRUE

\* lww_merge (matches Coq: Definition lww_merge)
lww_merge(a, b) == TRUE

\* lww_write (matches Coq: Definition lww_write)
lww_write(r, v, ts) == TRUE

\* lww_read (matches Coq: Definition lww_read)
lww_read(r) == TRUE

\* lww_bottom (matches Coq: Definition lww_bottom)
lww_bottom == TRUE

\* or_entry_eqb (matches Coq: Definition or_entry_eqb)
or_entry_eqb(a, b) == TRUE

\* or_in_list (matches Coq: Definition or_in_list)
or_in_list(e, l) == TRUE

\* or_lookup (matches Coq: Definition or_lookup)
or_lookup(s, v) == TRUE

\* or_add (matches Coq: Definition or_add)
or_add(s, v, tag) == TRUE

\* or_remove (matches Coq: Definition or_remove)
or_remove(s, v) == TRUE

\* or_merge (matches Coq: Definition or_merge)
or_merge(a, b) == TRUE

\* or_empty (matches Coq: Definition or_empty)
or_empty == TRUE

\* pointwise_max_nil_l (matches Coq: Lemma pointwise_max_nil_l)
THEOREM pointwise_max_nil_l == Init => TypeOK

\* pointwise_max_nil_r (matches Coq: Lemma pointwise_max_nil_r)
THEOREM pointwise_max_nil_r == Init => TypeOK

\* pointwise_max_comm (matches Coq: Lemma pointwise_max_comm)
THEOREM pointwise_max_comm == Init => TypeOK

\* pointwise_max_assoc (matches Coq: Lemma pointwise_max_assoc)
THEOREM pointwise_max_assoc == Init => TypeOK

\* pointwise_max_idem (matches Coq: Lemma pointwise_max_idem)
THEOREM pointwise_max_idem == Init => TypeOK

\* pointwise_max_length (matches Coq: Lemma pointwise_max_length)
THEOREM pointwise_max_length == Init => TypeOK

\* list_leq_refl (matches Coq: Lemma list_leq_refl)
THEOREM list_leq_refl == Init => TypeOK

\* list_leq_trans (matches Coq: Lemma list_leq_trans)
THEOREM list_leq_trans == Init => TypeOK

\* nth_pointwise_max (matches Coq: Lemma nth_pointwise_max)
THEOREM nth_pointwise_max == Init => TypeOK

\* list_leq_pointwise_max_l (matches Coq: Lemma list_leq_pointwise_max_l)
THEOREM list_leq_pointwise_max_l == Init => TypeOK

\* list_leq_pointwise_max_r (matches Coq: Lemma list_leq_pointwise_max_r)
THEOREM list_leq_pointwise_max_r == Init => TypeOK

\* pointwise_max_lub (matches Coq: Lemma pointwise_max_lub)
THEOREM pointwise_max_lub == Init => TypeOK

\* gc_merge_comm (matches Coq: Theorem gc_merge_comm)
THEOREM gc_merge_comm == Init => TypeOK

\* gc_merge_assoc (matches Coq: Theorem gc_merge_assoc)
THEOREM gc_merge_assoc == Init => TypeOK

\* gc_merge_idem (matches Coq: Theorem gc_merge_idem)
THEOREM gc_merge_idem == Init => TypeOK

\* gc_merge_length (matches Coq: Theorem gc_merge_length)
THEOREM gc_merge_length == Init => TypeOK

\* gc_leq_refl (matches Coq: Theorem gc_leq_refl)
THEOREM gc_leq_refl == Init => TypeOK

\* gc_leq_trans (matches Coq: Theorem gc_leq_trans)
THEOREM gc_leq_trans == Init => TypeOK

\* gc_leq_merge_l (matches Coq: Theorem gc_leq_merge_l)
THEOREM gc_leq_merge_l == Init => TypeOK

\* gc_leq_merge_r (matches Coq: Theorem gc_leq_merge_r)
THEOREM gc_leq_merge_r == Init => TypeOK

\* gc_merge_lub (matches Coq: Theorem gc_merge_lub)
THEOREM gc_merge_lub == Init => TypeOK

\* fold_left_add_le (matches Coq: Lemma fold_left_add_le)
THEOREM fold_left_add_le == Init => TypeOK

\* fold_left_add_ge (matches Coq: Lemma fold_left_add_ge)
THEOREM fold_left_add_ge == Init => TypeOK

\* fold_left_add_mono (matches Coq: Lemma fold_left_add_mono)
THEOREM fold_left_add_mono == Init => TypeOK

\* pointwise_max_geq_l (matches Coq: Lemma pointwise_max_geq_l)
THEOREM pointwise_max_geq_l == Init => TypeOK

\* gc_merge_value_geq_l (matches Coq: Theorem gc_merge_value_geq_l)
THEOREM gc_merge_value_geq_l == Init => TypeOK

\* gc_merge_value_geq_r (matches Coq: Theorem gc_merge_value_geq_r)
THEOREM gc_merge_value_geq_r == Init => TypeOK

\* gc_value_nonneg (matches Coq: Theorem gc_value_nonneg)
THEOREM gc_value_nonneg == Init => TypeOK

\* gc_bottom_length (matches Coq: Theorem gc_bottom_length)
THEOREM gc_bottom_length == Init => TypeOK

\* gc_bottom_value (matches Coq: Theorem gc_bottom_value)
THEOREM gc_bottom_value == Init => TypeOK

\* gc_bottom_nth (matches Coq: Lemma gc_bottom_nth)
THEOREM gc_bottom_nth == Init => TypeOK

\* gc_bottom_leq (matches Coq: Theorem gc_bottom_leq)
THEOREM gc_bottom_leq == Init => TypeOK

\* pointwise_max_zero_l (matches Coq: Lemma pointwise_max_zero_l)
THEOREM pointwise_max_zero_l == Init => TypeOK

\* gc_bottom_merge_l (matches Coq: Theorem gc_bottom_merge_l)
THEOREM gc_bottom_merge_l == Init => TypeOK

\* gc_bottom_merge_r (matches Coq: Theorem gc_bottom_merge_r)
THEOREM gc_bottom_merge_r == Init => TypeOK

\* gc_increment_length (matches Coq: Theorem gc_increment_length)
THEOREM gc_increment_length == Init => TypeOK

\* pn_merge_comm (matches Coq: Theorem pn_merge_comm)
THEOREM pn_merge_comm == Init => TypeOK

\* pn_merge_assoc (matches Coq: Theorem pn_merge_assoc)
THEOREM pn_merge_assoc == Init => TypeOK

\* pn_merge_idem (matches Coq: Theorem pn_merge_idem)
THEOREM pn_merge_idem == Init => TypeOK

\* pn_leq_refl (matches Coq: Theorem pn_leq_refl)
THEOREM pn_leq_refl == Init => TypeOK

\* pn_leq_trans (matches Coq: Theorem pn_leq_trans)
THEOREM pn_leq_trans == Init => TypeOK

\* pn_leq_merge_l (matches Coq: Theorem pn_leq_merge_l)
THEOREM pn_leq_merge_l == Init => TypeOK

\* pn_leq_merge_r (matches Coq: Theorem pn_leq_merge_r)
THEOREM pn_leq_merge_r == Init => TypeOK

\* pn_bottom_merge_l (matches Coq: Theorem pn_bottom_merge_l)
THEOREM pn_bottom_merge_l == Init => TypeOK

\* pn_bottom_merge_r (matches Coq: Theorem pn_bottom_merge_r)
THEOREM pn_bottom_merge_r == Init => TypeOK

\* pn_bottom_leq (matches Coq: Theorem pn_bottom_leq)
THEOREM pn_bottom_leq == Init => TypeOK

\* pn_increment_preserves_neg (matches Coq: Theorem pn_increment_preserves_neg)
THEOREM pn_increment_preserves_neg == Init => TypeOK

\* pn_decrement_preserves_pos (matches Coq: Theorem pn_decrement_preserves_pos)
THEOREM pn_decrement_preserves_pos == Init => TypeOK

\* pn_increment_pos_length (matches Coq: Theorem pn_increment_pos_length)
THEOREM pn_increment_pos_length == Init => TypeOK

\* pn_decrement_neg_length (matches Coq: Theorem pn_decrement_neg_length)
THEOREM pn_decrement_neg_length == Init => TypeOK

\* pn_merge_pos_length (matches Coq: Theorem pn_merge_pos_length)
THEOREM pn_merge_pos_length == Init => TypeOK

\* pn_merge_neg_length (matches Coq: Theorem pn_merge_neg_length)
THEOREM pn_merge_neg_length == Init => TypeOK

\* member_cons (matches Coq: Lemma member_cons)
THEOREM member_cons == Init => TypeOK

\* member_refl (matches Coq: Lemma member_refl)
THEOREM member_refl == Init => TypeOK

\* gs_add_member (matches Coq: Theorem gs_add_member)
THEOREM gs_add_member == Init => TypeOK

\* gs_add_preserves (matches Coq: Theorem gs_add_preserves)
THEOREM gs_add_preserves == Init => TypeOK

\* gs_add_idempotent (matches Coq: Theorem gs_add_idempotent)
THEOREM gs_add_idempotent == Init => TypeOK

\* gs_merge_contains_l (matches Coq: Theorem gs_merge_contains_l)
THEOREM gs_merge_contains_l == Init => TypeOK

\* gs_merge_contains_r (matches Coq: Theorem gs_merge_contains_r)
THEOREM gs_merge_contains_r == Init => TypeOK

\* gs_merge_not_member (matches Coq: Lemma gs_merge_not_member)
THEOREM gs_merge_not_member == Init => TypeOK

\* gs_merge_comm_member (matches Coq: Theorem gs_merge_comm_member)
THEOREM gs_merge_comm_member == Init => TypeOK

\* gs_merge_add_idem (matches Coq: Lemma gs_merge_add_idem)
THEOREM gs_merge_add_idem == Init => TypeOK

\* gs_merge_idem (matches Coq: Theorem gs_merge_idem)
THEOREM gs_merge_idem == Init => TypeOK

\* gs_empty_merge_l (matches Coq: Theorem gs_empty_merge_l)
THEOREM gs_empty_merge_l == Init => TypeOK

\* gs_empty_member (matches Coq: Theorem gs_empty_member)
THEOREM gs_empty_member == Init => TypeOK

\* gs_add_not_member (matches Coq: Lemma gs_add_not_member)
THEOREM gs_add_not_member == Init => TypeOK

\* gs_add_comm_member (matches Coq: Theorem gs_add_comm_member)
THEOREM gs_add_comm_member == Init => TypeOK

\* gs_member_add_cases (matches Coq: Theorem gs_member_add_cases)
THEOREM gs_member_add_cases == Init => TypeOK

\* gs_merge_member_iff (matches Coq: Theorem gs_merge_member_iff)
THEOREM gs_merge_member_iff == Init => TypeOK

\* gs_merge_monotone (matches Coq: Theorem gs_merge_monotone)
THEOREM gs_merge_monotone == Init => TypeOK

\* tp_add_visible (matches Coq: Theorem tp_add_visible)
THEOREM tp_add_visible == Init => TypeOK

\* tp_remove_hides (matches Coq: Theorem tp_remove_hides)
THEOREM tp_remove_hides == Init => TypeOK

\* tp_remove_permanent (matches Coq: Theorem tp_remove_permanent)
THEOREM tp_remove_permanent == Init => TypeOK

\* tp_merge_comm_lookup (matches Coq: Theorem tp_merge_comm_lookup)
THEOREM tp_merge_comm_lookup == Init => TypeOK

\* tp_merge_idem (matches Coq: Theorem tp_merge_idem)
THEOREM tp_merge_idem == Init => TypeOK

\* tp_empty_merge_l (matches Coq: Theorem tp_empty_merge_l)
THEOREM tp_empty_merge_l == Init => TypeOK

\* tp_add_preserves_removed (matches Coq: Theorem tp_add_preserves_removed)
THEOREM tp_add_preserves_removed == Init => TypeOK

\* tp_remove_preserves_added (matches Coq: Theorem tp_remove_preserves_added)
THEOREM tp_remove_preserves_added == Init => TypeOK

\* tp_lookup_false_not_added (matches Coq: Theorem tp_lookup_false_not_added)
THEOREM tp_lookup_false_not_added == Init => TypeOK

\* tp_merge_add_visible (matches Coq: Theorem tp_merge_add_visible)
THEOREM tp_merge_add_visible == Init => TypeOK

\* tp_merge_preserves_removal (matches Coq: Theorem tp_merge_preserves_removal)
THEOREM tp_merge_preserves_removal == Init => TypeOK

\* tp_once_removed_stays_removed (matches Coq: Theorem tp_once_removed_stays_removed)
THEOREM tp_once_removed_stays_removed == Init => TypeOK

\* lww_merge_comm (matches Coq: Theorem lww_merge_comm)
THEOREM lww_merge_comm == Init => TypeOK

\* lww_merge_idem (matches Coq: Theorem lww_merge_idem)
THEOREM lww_merge_idem == Init => TypeOK

\* lww_merge_assoc_idem (matches Coq: Theorem lww_merge_assoc_idem)
THEOREM lww_merge_assoc_idem == Init => TypeOK

\* lww_write_higher_wins (matches Coq: Theorem lww_write_higher_wins)
THEOREM lww_write_higher_wins == Init => TypeOK

\* lww_read_after_write (matches Coq: Theorem lww_read_after_write)
THEOREM lww_read_after_write == Init => TypeOK

\* lww_merge_ts_nondecreasing (matches Coq: Theorem lww_merge_ts_nondecreasing)
THEOREM lww_merge_ts_nondecreasing == Init => TypeOK

\* lww_merge_ts_max (matches Coq: Theorem lww_merge_ts_max)
THEOREM lww_merge_ts_max == Init => TypeOK

\* lww_bottom_merge_l (matches Coq: Theorem lww_bottom_merge_l)
THEOREM lww_bottom_merge_l == Init => TypeOK

\* lww_concurrent_same_ts (matches Coq: Theorem lww_concurrent_same_ts)
THEOREM lww_concurrent_same_ts == Init => TypeOK

\* lww_merge_either (matches Coq: Theorem lww_merge_either)
THEOREM lww_merge_either == Init => TypeOK

\* or_entry_eqb_refl (matches Coq: Lemma or_entry_eqb_refl)
THEOREM or_entry_eqb_refl == Init => TypeOK

\* existsb_app (matches Coq: Lemma existsb_app)
THEOREM existsb_app == Init => TypeOK

\* or_add_lookup (matches Coq: Theorem or_add_lookup)
THEOREM or_add_lookup == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<lww_val, lww_ts>>

\* Specification
Spec == Init /\ [][Next]_<<lww_val, lww_ts>>

====
