\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE CRDTComposition ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/CRDTComposition.v (103 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* MerkleNode (matches Coq: Record MerkleNode)
VARIABLES merkle_hash, merkle_state

\* Type invariant
TypeOK ==
  /\ merkle_hash \in BOOLEAN
  /\ merkle_state \in BOOLEAN

\* Initial state
Init ==
  /\ merkle_hash = TRUE
  /\ merkle_state = TRUE

\* map_lookup (matches Coq: Definition map_lookup)
map_lookup(m, k) == TRUE

\* map_insert (matches Coq: Definition map_insert)
map_insert(m, k, v) == TRUE

\* map_merge_aux (matches Coq: Definition map_merge_aux)
map_merge_aux(m1, m2) == TRUE

\* map_has_key (matches Coq: Definition map_has_key)
map_has_key(m, k) == TRUE

\* map_remaining (matches Coq: Definition map_remaining)
map_remaining(m1, m2) == TRUE

\* map_merge (matches Coq: Definition map_merge)
map_merge(m1, m2) == TRUE

\* map_empty (matches Coq: Definition map_empty)
map_empty == TRUE

\* hash (matches Coq: Definition hash)
hash(n) == TRUE

\* merkle_valid (matches Coq: Definition merkle_valid)
merkle_valid(node) == TRUE

\* merkle_create (matches Coq: Definition merkle_create)
merkle_create(state) == TRUE

\* merkle_merge (matches Coq: Definition merkle_merge)
merkle_merge(a, b) == TRUE

\* dag_node_hash (matches Coq: Definition dag_node_hash)
dag_node_hash(n) == TRUE

\* dag_has_hash (matches Coq: Definition dag_has_hash)
dag_has_hash(dag, h) == TRUE

\* dag_node_valid (matches Coq: Definition dag_node_valid)
dag_node_valid(dag, node) == TRUE

\* dag_merge (matches Coq: Definition dag_merge)
dag_merge(a, b) == TRUE

\* dag_valid (matches Coq: Definition dag_valid)
dag_valid(dag) == TRUE

\* prod_merge_comm (matches Coq: Theorem prod_merge_comm)
THEOREM prod_merge_comm == Init => TypeOK

\* prod_merge_assoc (matches Coq: Theorem prod_merge_assoc)
THEOREM prod_merge_assoc == Init => TypeOK

\* prod_merge_idem (matches Coq: Theorem prod_merge_idem)
THEOREM prod_merge_idem == Init => TypeOK

\* prod_merge_fst (matches Coq: Theorem prod_merge_fst)
THEOREM prod_merge_fst == Init => TypeOK

\* prod_merge_snd (matches Coq: Theorem prod_merge_snd)
THEOREM prod_merge_snd == Init => TypeOK

\* prod_bottom_merge_l (matches Coq: Theorem prod_bottom_merge_l)
THEOREM prod_bottom_merge_l == Init => TypeOK

\* prod_bottom_merge_r (matches Coq: Theorem prod_bottom_merge_r)
THEOREM prod_bottom_merge_r == Init => TypeOK

\* prod_leq_refl (matches Coq: Theorem prod_leq_refl)
THEOREM prod_leq_refl == Init => TypeOK

\* prod_leq_trans (matches Coq: Theorem prod_leq_trans)
THEOREM prod_leq_trans == Init => TypeOK

\* prod_leq_antisym (matches Coq: Theorem prod_leq_antisym)
THEOREM prod_leq_antisym == Init => TypeOK

\* nat_prod_merge_comm (matches Coq: Theorem nat_prod_merge_comm)
THEOREM nat_prod_merge_comm == Init => TypeOK

\* nat_prod_merge_assoc (matches Coq: Theorem nat_prod_merge_assoc)
THEOREM nat_prod_merge_assoc == Init => TypeOK

\* nat_prod_merge_idem (matches Coq: Theorem nat_prod_merge_idem)
THEOREM nat_prod_merge_idem == Init => TypeOK

\* nat_prod_merge_bottom_l (matches Coq: Theorem nat_prod_merge_bottom_l)
THEOREM nat_prod_merge_bottom_l == Init => TypeOK

\* nat_prod_merge_bottom_r (matches Coq: Theorem nat_prod_merge_bottom_r)
THEOREM nat_prod_merge_bottom_r == Init => TypeOK

\* map_lookup_empty (matches Coq: Theorem map_lookup_empty)
THEOREM map_lookup_empty == Init => TypeOK

\* map_lookup_insert_same (matches Coq: Theorem map_lookup_insert_same)
THEOREM map_lookup_insert_same == Init => TypeOK

\* map_lookup_insert_diff (matches Coq: Theorem map_lookup_insert_diff)
THEOREM map_lookup_insert_diff == Init => TypeOK

\* map_has_key_insert (matches Coq: Theorem map_has_key_insert)
THEOREM map_has_key_insert == Init => TypeOK

\* map_has_key_empty (matches Coq: Theorem map_has_key_empty)
THEOREM map_has_key_empty == Init => TypeOK

\* map_merge_aux_lookup_in (matches Coq: Theorem map_merge_aux_lookup_in)
THEOREM map_merge_aux_lookup_in == Init => TypeOK

\* map_merge_aux_preserves (matches Coq: Theorem map_merge_aux_preserves)
THEOREM map_merge_aux_preserves == Init => TypeOK

\* map_merge_aux_length (matches Coq: Theorem map_merge_aux_length)
THEOREM map_merge_aux_length == Init => TypeOK

\* map_merge_aux_lookup_gen (matches Coq: Lemma map_merge_aux_lookup_gen)
THEOREM map_merge_aux_lookup_gen == Init => TypeOK

\* map_merge_aux_idem_key (matches Coq: Theorem map_merge_aux_idem_key)
THEOREM map_merge_aux_idem_key == Init => TypeOK

\* map_insert_lookup_ge (matches Coq: Theorem map_insert_lookup_ge)
THEOREM map_insert_lookup_ge == Init => TypeOK

\* map_merge_aux_empty_l (matches Coq: Theorem map_merge_aux_empty_l)
THEOREM map_merge_aux_empty_l == Init => TypeOK

\* triple_merge_comm (matches Coq: Theorem triple_merge_comm)
THEOREM triple_merge_comm == Init => TypeOK

\* triple_merge_assoc (matches Coq: Theorem triple_merge_assoc)
THEOREM triple_merge_assoc == Init => TypeOK

\* triple_merge_idem (matches Coq: Theorem triple_merge_idem)
THEOREM triple_merge_idem == Init => TypeOK

\* composition_preserves_convergence (matches Coq: Theorem composition_preserves_convergence)
THEOREM composition_preserves_convergence == Init => TypeOK

\* nested_product_comm (matches Coq: Theorem nested_product_comm)
THEOREM nested_product_comm == Init => TypeOK

\* nested_product_assoc (matches Coq: Theorem nested_product_assoc)
THEOREM nested_product_assoc == Init => TypeOK

\* nested_product_idem (matches Coq: Theorem nested_product_idem)
THEOREM nested_product_idem == Init => TypeOK

\* fold_merge_idem (matches Coq: Theorem fold_merge_idem)
THEOREM fold_merge_idem == Init => TypeOK

\* fold_merge_double_update (matches Coq: Theorem fold_merge_double_update)
THEOREM fold_merge_double_update == Init => TypeOK

\* merkle_create_valid (matches Coq: Theorem merkle_create_valid)
THEOREM merkle_create_valid == Init => TypeOK

\* merkle_equal_states_equal_hashes (matches Coq: Theorem merkle_equal_states_equal_hashes)
THEOREM merkle_equal_states_equal_hashes == Init => TypeOK

\* merkle_hash_deterministic (matches Coq: Theorem merkle_hash_deterministic)
THEOREM merkle_hash_deterministic == Init => TypeOK

\* merkle_merge_valid (matches Coq: Theorem merkle_merge_valid)
THEOREM merkle_merge_valid == Init => TypeOK

\* merkle_merge_comm (matches Coq: Theorem merkle_merge_comm)
THEOREM merkle_merge_comm == Init => TypeOK

\* merkle_merge_assoc (matches Coq: Theorem merkle_merge_assoc)
THEOREM merkle_merge_assoc == Init => TypeOK

\* merkle_merge_idem (matches Coq: Theorem merkle_merge_idem)
THEOREM merkle_merge_idem == Init => TypeOK

\* merkle_crdt_tamper_evident (matches Coq: Theorem merkle_crdt_tamper_evident)
THEOREM merkle_crdt_tamper_evident == Init => TypeOK

\* merkle_tamper_detected (matches Coq: Theorem merkle_tamper_detected)
THEOREM merkle_tamper_detected == Init => TypeOK

\* merkle_merge_state_max (matches Coq: Theorem merkle_merge_state_max)
THEOREM merkle_merge_state_max == Init => TypeOK

\* merkle_merge_state_geq_l (matches Coq: Theorem merkle_merge_state_geq_l)
THEOREM merkle_merge_state_geq_l == Init => TypeOK

\* merkle_merge_state_geq_r (matches Coq: Theorem merkle_merge_state_geq_r)
THEOREM merkle_merge_state_geq_r == Init => TypeOK

\* merkle_merge_preserves_hash_consistency (matches Coq: Theorem merkle_merge_preserves_hash_consistency)
THEOREM merkle_merge_preserves_hash_consistency == Init => TypeOK

\* merkle_merge_bottom_l (matches Coq: Theorem merkle_merge_bottom_l)
THEOREM merkle_merge_bottom_l == Init => TypeOK

\* merkle_content_addressed_eq (matches Coq: Theorem merkle_content_addressed_eq)
THEOREM merkle_content_addressed_eq == Init => TypeOK

\* merkle_content_addressed_hash_eq (matches Coq: Theorem merkle_content_addressed_hash_eq)
THEOREM merkle_content_addressed_hash_eq == Init => TypeOK

\* dag_merge_contains_l (matches Coq: Theorem dag_merge_contains_l)
THEOREM dag_merge_contains_l == Init => TypeOK

\* dag_merge_contains_r (matches Coq: Theorem dag_merge_contains_r)
THEOREM dag_merge_contains_r == Init => TypeOK

\* dag_merge_length (matches Coq: Theorem dag_merge_length)
THEOREM dag_merge_length == Init => TypeOK

\* existsb_app_local (matches Coq: Lemma existsb_app_local)
THEOREM existsb_app_local == Init => TypeOK

\* dag_has_hash_merge (matches Coq: Theorem dag_has_hash_merge)
THEOREM dag_has_hash_merge == Init => TypeOK

\* dag_has_hash_merge_r (matches Coq: Theorem dag_has_hash_merge_r)
THEOREM dag_has_hash_merge_r == Init => TypeOK

\* dag_merge_empty_l (matches Coq: Theorem dag_merge_empty_l)
THEOREM dag_merge_empty_l == Init => TypeOK

\* dag_merge_empty_r (matches Coq: Theorem dag_merge_empty_r)
THEOREM dag_merge_empty_r == Init => TypeOK

\* dag_hash_mismatch_detects_tamper (matches Coq: Theorem dag_hash_mismatch_detects_tamper)
THEOREM dag_hash_mismatch_detects_tamper == Init => TypeOK

\* dag_merge_assoc_structure (matches Coq: Theorem dag_merge_assoc_structure)
THEOREM dag_merge_assoc_structure == Init => TypeOK

\* dag_crdt_merge_monotone (matches Coq: Theorem dag_crdt_merge_monotone)
THEOREM dag_crdt_merge_monotone == Init => TypeOK

\* dag_merge_preserves_integrity (matches Coq: Theorem dag_merge_preserves_integrity)
THEOREM dag_merge_preserves_integrity == Init => TypeOK

\* dag_merge_comm_hash (matches Coq: Theorem dag_merge_comm_hash)
THEOREM dag_merge_comm_hash == Init => TypeOK

\* dag_valid_merge_preserves (matches Coq: Theorem dag_valid_merge_preserves)
THEOREM dag_valid_merge_preserves == Init => TypeOK

\* prod_triple_convergence (matches Coq: Theorem prod_triple_convergence)
THEOREM prod_triple_convergence == Init => TypeOK

\* nat_prod_order_independent (matches Coq: Theorem nat_prod_order_independent)
THEOREM nat_prod_order_independent == Init => TypeOK

\* merkle_merge_order_independent (matches Coq: Theorem merkle_merge_order_independent)
THEOREM merkle_merge_order_independent == Init => TypeOK

\* merkle_idempotent_delivery (matches Coq: Theorem merkle_idempotent_delivery)
THEOREM merkle_idempotent_delivery == Init => TypeOK

\* map_insert_roundtrip (matches Coq: Theorem map_insert_roundtrip)
THEOREM map_insert_roundtrip == Init => TypeOK

\* map_insert_overwrite (matches Coq: Theorem map_insert_overwrite)
THEOREM map_insert_overwrite == Init => TypeOK

\* map_insert_independent (matches Coq: Theorem map_insert_independent)
THEOREM map_insert_independent == Init => TypeOK

\* prod_merge_fst_preserves (matches Coq: Theorem prod_merge_fst_preserves)
THEOREM prod_merge_fst_preserves == Init => TypeOK

\* prod_merge_snd_preserves (matches Coq: Theorem prod_merge_snd_preserves)
THEOREM prod_merge_snd_preserves == Init => TypeOK

\* prod_merge_partial_bottom_l (matches Coq: Theorem prod_merge_partial_bottom_l)
THEOREM prod_merge_partial_bottom_l == Init => TypeOK

\* nat_prod_leq_refl (matches Coq: Theorem nat_prod_leq_refl)
THEOREM nat_prod_leq_refl == Init => TypeOK

\* nat_prod_merge_geq_l (matches Coq: Theorem nat_prod_merge_geq_l)
THEOREM nat_prod_merge_geq_l == Init => TypeOK

\* nat_prod_merge_geq_r (matches Coq: Theorem nat_prod_merge_geq_r)
THEOREM nat_prod_merge_geq_r == Init => TypeOK

\* map_has_key_insert_diff (matches Coq: Theorem map_has_key_insert_diff)
THEOREM map_has_key_insert_diff == Init => TypeOK

\* map_merge_aux_nil_r (matches Coq: Theorem map_merge_aux_nil_r)
THEOREM map_merge_aux_nil_r == Init => TypeOK

\* merkle_create_merge_self (matches Coq: Theorem merkle_create_merge_self)
THEOREM merkle_create_merge_self == Init => TypeOK

\* merkle_create_state (matches Coq: Theorem merkle_create_state)
THEOREM merkle_create_state == Init => TypeOK

\* merkle_create_hash (matches Coq: Theorem merkle_create_hash)
THEOREM merkle_create_hash == Init => TypeOK

\* dag_merge_node_count (matches Coq: Theorem dag_merge_node_count)
THEOREM dag_merge_node_count == Init => TypeOK

\* dag_singleton_has_hash (matches Coq: Theorem dag_singleton_has_hash)
THEOREM dag_singleton_has_hash == Init => TypeOK

\* dag_singleton_no_other (matches Coq: Theorem dag_singleton_no_other)
THEOREM dag_singleton_no_other == Init => TypeOK

\* triple_merge_fst_fst (matches Coq: Theorem triple_merge_fst_fst)
THEOREM triple_merge_fst_fst == Init => TypeOK

\* triple_merge_fst_snd (matches Coq: Theorem triple_merge_fst_snd)
THEOREM triple_merge_fst_snd == Init => TypeOK

\* triple_merge_snd (matches Coq: Theorem triple_merge_snd)
THEOREM triple_merge_snd == Init => TypeOK

\* composition_idempotent_delivery (matches Coq: Theorem composition_idempotent_delivery)
THEOREM composition_idempotent_delivery == Init => TypeOK

\* dag_merge_triple_assoc (matches Coq: Theorem dag_merge_triple_assoc)
THEOREM dag_merge_triple_assoc == Init => TypeOK

\* hash_deterministic (matches Coq: Theorem hash_deterministic)
THEOREM hash_deterministic == Init => TypeOK

\* hash_eq_implies_state_eq (matches Coq: Theorem hash_eq_implies_state_eq)
THEOREM hash_eq_implies_state_eq == Init => TypeOK

\* hash_neq_implies_state_neq (matches Coq: Theorem hash_neq_implies_state_neq)
THEOREM hash_neq_implies_state_neq == Init => TypeOK

\* content_addressed_eq (matches Coq: Theorem content_addressed_eq)
THEOREM content_addressed_eq == Init => TypeOK

\* content_addressed_merge_consistent (matches Coq: Theorem content_addressed_merge_consistent)
THEOREM content_addressed_merge_consistent == Init => TypeOK

\* map_merge_aux_has_key (matches Coq: Theorem map_merge_aux_has_key)
THEOREM map_merge_aux_has_key == Init => TypeOK

\* prod_bottom_idem (matches Coq: Theorem prod_bottom_idem)
THEOREM prod_bottom_idem == Init => TypeOK

\* dag_empty_no_hash (matches Coq: Theorem dag_empty_no_hash)
THEOREM dag_empty_no_hash == Init => TypeOK

\* dag_empty_valid (matches Coq: Theorem dag_empty_valid)
THEOREM dag_empty_valid == Init => TypeOK

\* merkle_merge_creates (matches Coq: Theorem merkle_merge_creates)
THEOREM merkle_merge_creates == Init => TypeOK

\* merkle_valid_hash_matches (matches Coq: Theorem merkle_valid_hash_matches)
THEOREM merkle_valid_hash_matches == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<merkle_hash, merkle_state>>

\* Specification
Spec == Init /\ [][Next]_<<merkle_hash, merkle_state>>

====
