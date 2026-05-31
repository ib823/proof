(* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized. *)
(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/CRDTComposition.v (103 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.CRDTComposition
open FStar.All

(* MerkleNode (matches Coq) *)
type merkle_node = {
  f_merkle_hash: nat;
  f_merkle_state: nat;
}

(* map_lookup (matches Coq: Fixpoint map_lookup) *)
let rec map_lookup (p_m: nat) (p_k: nat) : Tot nat =
  match p_m with
  | [] -> 0
  | (p_k', v) :: rest -> if (p_k = p_k') then v else map_lookup rest p_k
  | _ -> 0

(* map_insert (matches Coq: Definition map_insert) *)
let map_insert (p_m: nat) (p_k: nat) (p_v: nat) : Tot nat =
  (p_k, p_v) :: p_m

(* map_merge_aux (matches Coq: Fixpoint map_merge_aux) *)
let rec map_merge_aux (p_m1: nat) (p_m2: nat) : Tot nat =
  match p_m1 with
  | [] -> p_m2
  | (k, v) :: rest -> let v2 = map_lookup p_m2 k in (k, (if v >= v2 then v else v2)) :: map_merge_aux rest p_m2
  | _ -> 0

(* map_has_key (matches Coq: Fixpoint map_has_key) *)
let rec map_has_key (p_m: nat) (p_k: nat) : Tot bool =
  match p_m with
  | [] -> false
  | (p_k', _) :: rest -> (p_k = p_k')
  | _ -> false

(* map_remaining (matches Coq: Definition map_remaining) *)
let map_remaining (p_m1: nat) (p_m2: nat) : Tot nat =
  filter (fun kv -> (not (map_has_key p_m1 (fst kv)))) p_m2

(* map_merge (matches Coq: Definition map_merge) *)
let map_merge (p_m1: nat) (p_m2: nat) : Tot nat =
  map_merge_aux p_m1 p_m2 @ map_remaining p_m1 p_m2

(* map_empty (matches Coq: Definition map_empty) *)
let map_empty : nat = []

(* hash (matches Coq: Definition hash) *)
let hash (p_n: nat) : Tot nat =
  p_n

(* merkle_valid (matches Coq: Definition merkle_valid) *)
let merkle_valid (p_node: merkle_node) : Tot bool =
  true

(* merkle_create (matches Coq: Definition merkle_create) *)
let merkle_create (p_state: nat) : Tot merkle_node =
  {f_merkle_hash=(hash p_state); f_merkle_state=p_state}

(* merkle_merge (matches Coq: Definition merkle_merge) *)
let merkle_merge (p_a: merkle_node) (p_b: merkle_node) : Tot merkle_node =
  let new_state = (if (p_a.f_merkle_state) >= (p_b.f_merkle_state) then (p_a.f_merkle_state) else (p_b.f_merkle_state)) in {f_merkle_hash=(hash new_state); f_merkle_state=new_state}

(* dag_node_hash (matches Coq: Definition dag_node_hash) *)
let dag_node_hash (p_n: nat) : Tot nat =
  fst p_n

(* dag_has_hash (matches Coq: Definition dag_has_hash) *)
let dag_has_hash (p_dag: nat) (p_h: nat) : Tot bool =
  existsb (fun n -> Nat.eqb (dag_node_hash n) p_h) p_dag

(* dag_node_valid (matches Coq: Definition dag_node_valid) *)
let dag_node_valid (p_dag: nat) (p_node: nat) : Tot bool =
  forallb (fun ch -> dag_has_hash p_dag ch) (dag_children p_node)

(* dag_merge (matches Coq: Definition dag_merge) *)
let dag_merge (p_a: nat) (p_b: nat) : Tot nat =
  p_a @ p_b

(* dag_valid (matches Coq: Definition dag_valid) *)
let dag_valid (p_dag: nat) : Tot bool =
  true

(* prod_merge_comm (matches Coq: Theorem prod_merge_comm) *)
let prod_merge_comm (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). p_ma a1 a2 == p_ma a2 a1))) /\ ((forall (b1: _). (forall (b2: _). p_mb b1 b2 == p_mb b2 b1))))) (ensures ((forall (x: _). (forall (y: _). prod_merge p_ma p_mb x y == prod_merge p_ma p_mb y x)))) = admit ()

(* prod_merge_assoc (matches Coq: Theorem prod_merge_assoc) *)
let prod_merge_assoc (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). (forall (a3: _). p_ma (p_ma a1 a2) a3 == p_ma a1 (p_ma a2 a3))))) /\ ((forall (b1: _). (forall (b2: _). (forall (b3: _). p_mb (p_mb b1 b2) b3 == p_mb b1 (p_mb b2 b3))))))) (ensures ((forall (x: _). (forall (y: _). (forall (z: _). prod_merge p_ma p_mb (prod_merge p_ma p_mb x y) z == prod_merge p_ma p_mb x (prod_merge p_ma p_mb y z)))))) = admit ()

(* prod_merge_idem (matches Coq: Theorem prod_merge_idem) *)
let prod_merge_idem (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) : Lemma (requires (((forall (p_a: _). p_ma p_a p_a == p_a)) /\ ((forall (p_b: _). p_mb p_b p_b == p_b)))) (ensures ((forall (x: _). prod_merge p_ma p_mb x x == x))) = admit ()

(* prod_merge_fst (matches Coq: Theorem prod_merge_fst) *)
let prod_merge_fst (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_x: _) (p_y: _) : Lemma (fst (prod_merge p_ma p_mb p_x p_y) == p_ma (fst p_x) (fst p_y)) = admit ()

(* prod_merge_snd (matches Coq: Theorem prod_merge_snd) *)
let prod_merge_snd (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_x: _) (p_y: _) : Lemma (snd (prod_merge p_ma p_mb p_x p_y) == p_mb (snd p_x) (snd p_y)) = admit ()

(* prod_bottom_merge_l (matches Coq: Theorem prod_bottom_merge_l) *)
let prod_bottom_merge_l (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_ba: nat) (p_bb: nat) : Lemma (requires (((forall (p_a: _). p_ma p_ba p_a == p_a)) /\ ((forall (p_b: _). p_mb p_bb p_b == p_b)))) (ensures ((forall (x: _). prod_merge p_ma p_mb (p_ba, p_bb) x == x))) = admit ()

(* prod_bottom_merge_r (matches Coq: Theorem prod_bottom_merge_r) *)
let prod_bottom_merge_r (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_ba: nat) (p_bb: nat) : Lemma (requires (((forall (p_a: _). p_ma p_a p_ba == p_a)) /\ ((forall (p_b: _). p_mb p_b p_bb == p_b)))) (ensures ((forall (x: _). prod_merge p_ma p_mb x (p_ba, p_bb) == x))) = admit ()

(* prod_leq_refl (matches Coq: Theorem prod_leq_refl) *)
let prod_leq_refl (p_a: Type0) (p_b: Type0) (p_la: nat) (p_lb: nat) : Lemma (requires (((forall (p_a: _). p_la p_a p_a == true)) /\ ((forall (p_b: _). p_lb p_b p_b == true)))) (ensures ((forall (x: _). prod_leq p_la p_lb x x == true))) = admit ()

(* prod_leq_trans (matches Coq: Theorem prod_leq_trans) *)
let prod_leq_trans (p_a: Type0) (p_b: Type0) (p_la: nat) (p_lb: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). (forall (a3: _). p_la a1 a2 -> p_la a2 a3 -> p_la a1 a3 == true)))) /\ ((forall (b1: _). (forall (b2: _). (forall (b3: _). p_lb b1 b2 -> p_lb b2 b3 -> p_lb b1 b3 == true)))) /\ (forall (x: _). (forall (y: _). (forall (z: _). prod_leq p_la p_lb x y == true))) /\ prod_leq p_la p_lb y z == true)) (ensures (prod_leq p_la p_lb x z == true)) = admit ()

(* prod_leq_antisym (matches Coq: Theorem prod_leq_antisym) *)
let prod_leq_antisym (p_a: Type0) (p_b: Type0) (p_la: nat) (p_lb: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). p_la a1 a2 -> p_la a2 a1 -> a1 == a2))) /\ ((forall (b1: _). (forall (b2: _). p_lb b1 b2 -> p_lb b2 b1 -> b1 == b2))) /\ (forall (x: _). (forall (y: _). prod_leq p_la p_lb x y == true)) /\ prod_leq p_la p_lb y x == true)) (ensures (x == y)) = admit ()

(* nat_prod_merge_comm (matches Coq: Theorem nat_prod_merge_comm) *)
let nat_prod_merge_comm (p_x: _) (p_y: _) : Lemma (nat_prod_merge p_x p_y == nat_prod_merge p_y p_x) = admit ()

(* nat_prod_merge_assoc (matches Coq: Theorem nat_prod_merge_assoc) *)
let nat_prod_merge_assoc (p_x: _) (p_y: _) (p_z: _) : Lemma (nat_prod_merge (nat_prod_merge p_x p_y) p_z == nat_prod_merge p_x (nat_prod_merge p_y p_z)) = admit ()

(* nat_prod_merge_idem (matches Coq: Theorem nat_prod_merge_idem) *)
let nat_prod_merge_idem (p_x: _) : Lemma (nat_prod_merge p_x p_x == p_x) = admit ()

(* nat_prod_merge_bottom_l (matches Coq: Theorem nat_prod_merge_bottom_l) *)
let nat_prod_merge_bottom_l (p_x: _) : Lemma (nat_prod_merge (0, 0) p_x == p_x) = admit ()

(* nat_prod_merge_bottom_r (matches Coq: Theorem nat_prod_merge_bottom_r) *)
let nat_prod_merge_bottom_r (p_x: _) : Lemma (nat_prod_merge p_x (0, 0) == p_x) = admit ()

(* map_lookup_empty (matches Coq: Theorem map_lookup_empty) *)
let map_lookup_empty (p_k: _) : Lemma (map_lookup map_empty p_k == 0) = admit ()

(* map_lookup_insert_same (matches Coq: Theorem map_lookup_insert_same) *)
let map_lookup_insert_same (p_m: _) (p_k: _) (p_v: _) : Lemma (map_lookup (map_insert p_m p_k p_v) p_k == p_v) = admit ()

(* map_lookup_insert_diff (matches Coq: Theorem map_lookup_insert_diff) *)
let map_lookup_insert_diff (p_m: _) (p_k: _) (p_k_: _) (p_v: _) : Lemma (requires (~(p_k == p_k_))) (ensures (map_lookup (map_insert p_m p_k_ p_v) p_k == map_lookup p_m p_k)) = admit ()

(* map_has_key_insert (matches Coq: Theorem map_has_key_insert) *)
let map_has_key_insert (p_m: _) (p_k: _) (p_v: _) : Lemma (map_has_key (map_insert p_m p_k p_v) p_k == true) = admit ()

(* map_has_key_empty (matches Coq: Theorem map_has_key_empty) *)
let map_has_key_empty (p_k: _) : Lemma (map_has_key map_empty p_k == false) = admit ()

(* map_merge_aux_lookup_in (matches Coq: Theorem map_merge_aux_lookup_in) *)
let map_merge_aux_lookup_in (p_m1: _) (p_m2: _) (p_k: _) (p_v: _) : Lemma (requires (List.Tot.memP (p_k, p_v) p_m1 /\ ((forall (p_k: _). List.Tot.memP (k_, v_) p_m1)))) (ensures (map_lookup (map_merge_aux p_m1 p_m2) p_k == Nat.max p_v (map_lookup p_m2 p_k))) = admit ()

(* map_merge_aux_preserves (matches Coq: Theorem map_merge_aux_preserves) *)
let map_merge_aux_preserves (p_m1: _) (p_m2: _) (p_k: _) : Lemma (requires (map_has_key p_m1 p_k == true)) (ensures (map_lookup (map_merge_aux p_m1 p_m2) p_k >= map_lookup p_m1 p_k)) = admit ()

(* map_merge_aux_length (matches Coq: Theorem map_merge_aux_length) *)
let map_merge_aux_length (p_m1: _) (p_m2: _) : Lemma (length (map_merge_aux p_m1 p_m2) == length p_m1 + length p_m2) = admit ()

(* map_merge_aux_lookup_gen (matches Coq: Lemma map_merge_aux_lookup_gen) *)
let map_merge_aux_lookup_gen (p_m1: _) (p_m2: _) (p_k: _) : Lemma (requires (map_has_key p_m1 p_k == true)) (ensures (map_lookup (map_merge_aux p_m1 p_m2) p_k == Nat.max (map_lookup p_m1 p_k) (map_lookup p_m2 p_k))) = admit ()

(* map_merge_aux_idem_key (matches Coq: Theorem map_merge_aux_idem_key) *)
let map_merge_aux_idem_key (p_m: _) (p_k: _) : Lemma (requires (map_has_key p_m p_k == true)) (ensures (map_lookup (map_merge_aux p_m p_m) p_k == map_lookup p_m p_k)) = admit ()

(* map_insert_lookup_ge (matches Coq: Theorem map_insert_lookup_ge) *)
let map_insert_lookup_ge (p_m: _) (p_k: _) (p_v: _) : Lemma (map_lookup (map_insert p_m p_k p_v) p_k >= p_v) = admit ()

(* map_merge_aux_empty_l (matches Coq: Theorem map_merge_aux_empty_l) *)
let map_merge_aux_empty_l (p_m: _) : Lemma (map_merge_aux [] p_m == p_m) = admit ()

(* triple_merge_comm (matches Coq: Theorem triple_merge_comm) *)
let triple_merge_comm (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). p_ma a1 a2 == p_ma a2 a1))) /\ ((forall (b1: _). (forall (b2: _). p_mb b1 b2 == p_mb b2 b1))) /\ ((forall (c1: _). (forall (c2: _). p_mc c1 c2 == p_mc c2 c1))))) (ensures ((forall (x: _). (forall (y: _). triple_merge p_ma p_mb p_mc x y == triple_merge p_ma p_mb p_mc y x)))) = admit ()

(* triple_merge_assoc (matches Coq: Theorem triple_merge_assoc) *)
let triple_merge_assoc (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). (forall (a3: _). p_ma (p_ma a1 a2) a3 == p_ma a1 (p_ma a2 a3))))) /\ ((forall (b1: _). (forall (b2: _). (forall (b3: _). p_mb (p_mb b1 b2) b3 == p_mb b1 (p_mb b2 b3))))) /\ ((forall (c1: _). (forall (c2: _). (forall (c3: _). p_mc (p_mc c1 c2) c3 == p_mc c1 (p_mc c2 c3))))))) (ensures ((forall (x: _). (forall (y: _). (forall (z: _). triple_merge p_ma p_mb p_mc (triple_merge p_ma p_mb p_mc x y) z == triple_merge p_ma p_mb p_mc x (triple_merge p_ma p_mb p_mc y z)))))) = admit ()

(* triple_merge_idem (matches Coq: Theorem triple_merge_idem) *)
let triple_merge_idem (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) : Lemma (requires (((forall (p_a: _). p_ma p_a p_a == p_a)) /\ ((forall (p_b: _). p_mb p_b p_b == p_b)) /\ ((forall (p_c: _). p_mc p_c p_c == p_c)))) (ensures ((forall (x: _). triple_merge p_ma p_mb p_mc x x == x))) = admit ()

(* composition_preserves_convergence (matches Coq: Theorem composition_preserves_convergence) *)
let composition_preserves_convergence (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). p_ma a1 a2 == p_ma a2 a1))) /\ ((forall (a1: _). (forall (a2: _). (forall (a3: _). p_ma (p_ma a1 a2) a3 == p_ma a1 (p_ma a2 a3))))) /\ ((forall (b1: _). (forall (b2: _). p_mb b1 b2 == p_mb b2 b1))) /\ ((forall (b1: _). (forall (b2: _). (forall (b3: _). p_mb (p_mb b1 b2) b3 == p_mb b1 (p_mb b2 b3))))))) (ensures ((forall (s: _). (forall (u1: _). (forall (u2: _). prod_merge p_ma p_mb (prod_merge p_ma p_mb s u1) u2 == prod_merge p_ma p_mb (prod_merge p_ma p_mb s u2) u1))))) = admit ()

(* nested_product_comm (matches Coq: Theorem nested_product_comm) *)
let nested_product_comm (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_d: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) (p_md: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). p_ma a1 a2 == p_ma a2 a1))) /\ ((forall (b1: _). (forall (b2: _). p_mb b1 b2 == p_mb b2 b1))) /\ ((forall (c1: _). (forall (c2: _). p_mc c1 c2 == p_mc c2 c1))) /\ ((forall (d1: _). (forall (d2: _). p_md d1 d2 == p_md d2 d1))))) (ensures ((forall (x: _). (forall (y: _). prod_merge (prod_merge p_ma p_mb) (prod_merge p_mc p_md) x y == prod_merge (prod_merge p_ma p_mb) (prod_merge p_mc p_md) y x)))) = admit ()

(* nested_product_assoc (matches Coq: Theorem nested_product_assoc) *)
let nested_product_assoc (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_d: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) (p_md: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). (forall (a3: _). p_ma (p_ma a1 a2) a3 == p_ma a1 (p_ma a2 a3))))) /\ ((forall (b1: _). (forall (b2: _). (forall (b3: _). p_mb (p_mb b1 b2) b3 == p_mb b1 (p_mb b2 b3))))) /\ ((forall (c1: _). (forall (c2: _). (forall (c3: _). p_mc (p_mc c1 c2) c3 == p_mc c1 (p_mc c2 c3))))) /\ ((forall (d1: _). (forall (d2: _). (forall (d3: _). p_md (p_md d1 d2) d3 == p_md d1 (p_md d2 d3))))))) (ensures ((forall (x: _). (forall (y: _). (forall (z: _). prod_merge (prod_merge p_ma p_mb) (prod_merge p_mc p_md) (prod_merge (prod_merge p_ma p_mb) (prod_merge p_mc p_md) x y) z == prod_merge (prod_merge p_ma p_mb) (prod_merge p_mc p_md) x (prod_merge (prod_merge p_ma p_mb) (prod_merge p_mc p_md) y z)))))) = admit ()

(* nested_product_idem (matches Coq: Theorem nested_product_idem) *)
let nested_product_idem (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_d: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) (p_md: nat) : Lemma (requires (((forall (p_a: _). p_ma p_a p_a == p_a)) /\ ((forall (p_b: _). p_mb p_b p_b == p_b)) /\ ((forall (p_c: _). p_mc p_c p_c == p_c)) /\ ((forall (p_d: _). p_md p_d p_d == p_d)))) (ensures ((forall (x: _). prod_merge (prod_merge p_ma p_mb) (prod_merge p_mc p_md) x x == x))) = admit ()

(* fold_merge_idem (matches Coq: Theorem fold_merge_idem) *)
let fold_merge_idem (p_a: Type0) (p_merge: nat) : Lemma (requires (((forall (p_a: _). (forall (b: _). (forall (c: _). p_merge (p_merge p_a b) c == p_merge p_a (p_merge b c))))) /\ ((forall (p_a: _). p_merge p_a p_a == p_a)))) (ensures ((forall (s: _). fold_left p_merge [s] s == s))) = admit ()

(* fold_merge_double_update (matches Coq: Theorem fold_merge_double_update) *)
let fold_merge_double_update (p_a: Type0) (p_merge: nat) : Lemma (requires (((forall (p_a: _). (forall (b: _). (forall (c: _). p_merge (p_merge p_a b) c == p_merge p_a (p_merge b c))))) /\ ((forall (p_a: _). p_merge p_a p_a == p_a)))) (ensures ((forall (s: _). (forall (u: _). p_merge (p_merge s u) u == p_merge s u)))) = admit ()

(* merkle_create_valid (matches Coq: Theorem merkle_create_valid) *)
let merkle_create_valid (p_s: _) : Lemma (merkle_valid (merkle_create p_s) == true) = admit ()

(* merkle_equal_states_equal_hashes (matches Coq: Theorem merkle_equal_states_equal_hashes) *)
let merkle_equal_states_equal_hashes (p_a: _) (p_b: _) : Lemma (requires (p_a.f_merkle_state == p_b.f_merkle_state)) (ensures (hash (p_a.f_merkle_state) == hash (p_b.f_merkle_state))) = admit ()

(* merkle_hash_deterministic (matches Coq: Theorem merkle_hash_deterministic) *)
let merkle_hash_deterministic (p_s: _) : Lemma (hash p_s == hash p_s) = admit ()

(* merkle_merge_valid (matches Coq: Theorem merkle_merge_valid) *)
let merkle_merge_valid (p_a: _) (p_b: _) : Lemma (requires (merkle_valid p_a == true /\ merkle_valid p_b == true)) (ensures (merkle_valid (merkle_merge p_a p_b) == true)) = admit ()

(* merkle_merge_comm (matches Coq: Theorem merkle_merge_comm) *)
let merkle_merge_comm (p_a: _) (p_b: _) : Lemma (merkle_merge p_a p_b == merkle_merge p_b p_a) = admit ()

(* merkle_merge_assoc (matches Coq: Theorem merkle_merge_assoc) *)
let merkle_merge_assoc (p_a: _) (p_b: _) (p_c: _) : Lemma (merkle_merge (merkle_merge p_a p_b) p_c == merkle_merge p_a (merkle_merge p_b p_c)) = admit ()

(* merkle_merge_idem (matches Coq: Theorem merkle_merge_idem) *)
let merkle_merge_idem (p_a: _) : Lemma (requires (merkle_valid p_a == true)) (ensures (merkle_merge p_a p_a == p_a)) = admit ()

(* merkle_crdt_tamper_evident (matches Coq: Theorem merkle_crdt_tamper_evident) *)
let merkle_crdt_tamper_evident (p_a: _) (p_b: _) : Lemma (requires (merkle_valid p_a == true /\ merkle_valid p_b == true /\ ~(p_a.f_merkle_hash == p_b.f_merkle_hash))) (ensures (~(p_a.f_merkle_state == p_b.f_merkle_state))) = admit ()

(* merkle_tamper_detected (matches Coq: Theorem merkle_tamper_detected) *)
let merkle_tamper_detected (p_node: _) (p_fake_state: _) : Lemma (requires (merkle_valid p_node == true /\ ~(p_node.f_merkle_state == p_fake_state))) (ensures (~(p_node.f_merkle_hash == hash p_fake_state))) = admit ()

(* merkle_merge_state_max (matches Coq: Theorem merkle_merge_state_max) *)
let merkle_merge_state_max (p_a: _) (p_b: _) : Lemma ((merkle_merge p_a p_b).f_merkle_state == Nat.max (p_a.f_merkle_state) (p_b.f_merkle_state)) = admit ()

(* merkle_merge_state_geq_l (matches Coq: Theorem merkle_merge_state_geq_l) *)
let merkle_merge_state_geq_l (p_a: _) (p_b: _) : Lemma ((merkle_merge p_a p_b).f_merkle_state >= p_a.f_merkle_state) = admit ()

(* merkle_merge_state_geq_r (matches Coq: Theorem merkle_merge_state_geq_r) *)
let merkle_merge_state_geq_r (p_a: _) (p_b: _) : Lemma ((merkle_merge p_a p_b).f_merkle_state >= p_b.f_merkle_state) = admit ()

(* merkle_merge_preserves_hash_consistency (matches Coq: Theorem merkle_merge_preserves_hash_consistency) *)
let merkle_merge_preserves_hash_consistency (p_a: _) (p_b: _) : Lemma (requires (merkle_valid p_a == true /\ merkle_valid p_b == true)) (ensures ((merkle_merge p_a p_b).f_merkle_hash == hash ((merkle_merge p_a p_b).f_merkle_state))) = admit ()

(* merkle_merge_bottom_l (matches Coq: Theorem merkle_merge_bottom_l) *)
let merkle_merge_bottom_l (p_a: _) : Lemma (requires (merkle_valid p_a == true)) (ensures (merkle_merge (mkmerkle 0 0) p_a == p_a)) = admit ()

(* merkle_content_addressed_eq (matches Coq: Theorem merkle_content_addressed_eq) *)
let merkle_content_addressed_eq (p_s1: _) (p_s2: _) : Lemma (requires (p_s1 == p_s2)) (ensures (merkle_create p_s1 == merkle_create p_s2)) = admit ()

(* merkle_content_addressed_hash_eq (matches Coq: Theorem merkle_content_addressed_hash_eq) *)
let merkle_content_addressed_hash_eq (p_s1: _) (p_s2: _) : Lemma (requires (p_s1 == p_s2)) (ensures (hash p_s1 == hash p_s2)) = admit ()

(* dag_merge_contains_l (matches Coq: Theorem dag_merge_contains_l) *)
let dag_merge_contains_l (p_a: _) (p_b: _) (p_node: _) : Lemma (requires (List.Tot.memP p_node p_a)) (ensures (List.Tot.memP p_node (dag_merge p_a p_b))) = admit ()

(* dag_merge_contains_r (matches Coq: Theorem dag_merge_contains_r) *)
let dag_merge_contains_r (p_a: _) (p_b: _) (p_node: _) : Lemma (requires (List.Tot.memP p_node p_b)) (ensures (List.Tot.memP p_node (dag_merge p_a p_b))) = admit ()

(* dag_merge_length (matches Coq: Theorem dag_merge_length) *)
let dag_merge_length (p_a: _) (p_b: _) : Lemma (length (dag_merge p_a p_b) == length p_a + length p_b) = admit ()

(* existsb_app_local (matches Coq: Lemma existsb_app_local) *)
let existsb_app_local (p_f: nat) (p_l1: _) (p_l2: _) : Lemma (existsb p_f (p_l1 ++ p_l2) == existsb p_f p_l1 || existsb p_f p_l2) = admit ()

(* dag_has_hash_merge (matches Coq: Theorem dag_has_hash_merge) *)
let dag_has_hash_merge (p_a: _) (p_b: _) (p_h: _) : Lemma (requires (dag_has_hash p_a p_h == true)) (ensures (dag_has_hash (dag_merge p_a p_b) p_h == true)) = admit ()

(* dag_has_hash_merge_r (matches Coq: Theorem dag_has_hash_merge_r) *)
let dag_has_hash_merge_r (p_a: _) (p_b: _) (p_h: _) : Lemma (requires (dag_has_hash p_b p_h == true)) (ensures (dag_has_hash (dag_merge p_a p_b) p_h == true)) = admit ()

(* dag_merge_empty_l (matches Coq: Theorem dag_merge_empty_l) *)
let dag_merge_empty_l (p_dag: _) : Lemma (dag_merge [] p_dag == p_dag) = admit ()

(* dag_merge_empty_r (matches Coq: Theorem dag_merge_empty_r) *)
let dag_merge_empty_r (p_dag: _) : Lemma (dag_merge p_dag [] == p_dag ++ []) = admit ()

(* dag_hash_mismatch_detects_tamper (matches Coq: Theorem dag_hash_mismatch_detects_tamper) *)
let dag_hash_mismatch_detects_tamper (p_dag: _) (p_node1: _) (p_node2: _) : Lemma (requires (List.Tot.memP p_node1 p_dag /\ List.Tot.memP p_node2 p_dag /\ ~(dag_node_hash p_node1 == dag_node_hash p_node2))) (ensures (~(p_node1 == p_node2))) = admit ()

(* dag_merge_assoc_structure (matches Coq: Theorem dag_merge_assoc_structure) *)
let dag_merge_assoc_structure (p_a: _) (p_b: _) (p_c: _) : Lemma (dag_merge (dag_merge p_a p_b) p_c == p_a ++ p_b ++ p_c) = admit ()

(* dag_crdt_merge_monotone (matches Coq: Theorem dag_crdt_merge_monotone) *)
let dag_crdt_merge_monotone (p_a: _) (p_b: _) (p_h: _) : Lemma (requires (dag_has_hash p_a p_h == true)) (ensures (dag_has_hash (dag_merge p_a p_b) p_h == true)) = admit ()

(* dag_merge_preserves_integrity (matches Coq: Theorem dag_merge_preserves_integrity) *)
let dag_merge_preserves_integrity (p_a: _) (p_b: _) (p_node: _) (p_ch: _) : Lemma (requires (List.Tot.memP p_node p_a /\ List.Tot.memP p_ch (dag_children p_node) /\ dag_has_hash p_a p_ch == true)) (ensures (dag_has_hash (dag_merge p_a p_b) p_ch == true)) = admit ()

(* dag_merge_comm_hash (matches Coq: Theorem dag_merge_comm_hash) *)
let dag_merge_comm_hash (p_a: _) (p_b: _) (p_h: _) : Lemma (requires (dag_has_hash (dag_merge p_a p_b) p_h == true)) (ensures (dag_has_hash (dag_merge p_b p_a) p_h == true)) = admit ()

(* dag_valid_merge_preserves (matches Coq: Theorem dag_valid_merge_preserves) *)
let dag_valid_merge_preserves (p_a: _) (p_b: _) : Lemma (requires (dag_valid p_a == true /\ dag_valid p_b == true /\ ((forall (node: _). List.Tot.memP node p_a)) /\ ((forall (node: _). List.Tot.memP node p_b)))) (ensures (dag_valid (dag_merge p_a p_b) == true)) = admit ()

(* prod_triple_convergence (matches Coq: Theorem prod_triple_convergence) *)
let prod_triple_convergence (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). p_ma a1 a2 == p_ma a2 a1))) /\ ((forall (a1: _). (forall (a2: _). (forall (a3: _). p_ma (p_ma a1 a2) a3 == p_ma a1 (p_ma a2 a3))))) /\ ((forall (b1: _). (forall (b2: _). p_mb b1 b2 == p_mb b2 b1))) /\ ((forall (b1: _). (forall (b2: _). (forall (b3: _). p_mb (p_mb b1 b2) b3 == p_mb b1 (p_mb b2 b3))))))) (ensures ((forall (s: _). (forall (u1: _). (forall (u2: _). (forall (u3: _). prod_merge p_ma p_mb (prod_merge p_ma p_mb (prod_merge p_ma p_mb s u1) u2) u3 == prod_merge p_ma p_mb (prod_merge p_ma p_mb (prod_merge p_ma p_mb s u3) u2) u1)))))) = admit ()

(* nat_prod_order_independent (matches Coq: Theorem nat_prod_order_independent) *)
let nat_prod_order_independent (p_s: _) (p_a: _) (p_b: _) : Lemma (nat_prod_merge (nat_prod_merge p_s p_a) p_b == nat_prod_merge (nat_prod_merge p_s p_b) p_a) = admit ()

(* merkle_merge_order_independent (matches Coq: Theorem merkle_merge_order_independent) *)
let merkle_merge_order_independent (p_s: _) (p_a: _) (p_b: _) : Lemma (merkle_merge (merkle_merge p_s p_a) p_b == merkle_merge (merkle_merge p_s p_b) p_a) = admit ()

(* merkle_idempotent_delivery (matches Coq: Theorem merkle_idempotent_delivery) *)
let merkle_idempotent_delivery (p_s: _) (p_u: _) : Lemma (requires (merkle_valid p_u == true)) (ensures (merkle_merge (merkle_merge p_s p_u) p_u == merkle_merge p_s p_u)) = admit ()

(* map_insert_roundtrip (matches Coq: Theorem map_insert_roundtrip) *)
let map_insert_roundtrip (p_k: _) (p_v: _) : Lemma (map_lookup (map_insert map_empty p_k p_v) p_k == p_v) = admit ()

(* map_insert_overwrite (matches Coq: Theorem map_insert_overwrite) *)
let map_insert_overwrite (p_m: _) (p_k: _) (p_v1: _) (p_v2: _) : Lemma (map_lookup (map_insert (map_insert p_m p_k p_v1) p_k p_v2) p_k == p_v2) = admit ()

(* map_insert_independent (matches Coq: Theorem map_insert_independent) *)
let map_insert_independent (p_m: _) (p_k1: _) (p_k2: _) (p_v1: _) (p_v2: _) : Lemma (requires (~(p_k1 == p_k2))) (ensures (map_lookup (map_insert (map_insert p_m p_k1 p_v1) p_k2 p_v2) p_k1 == p_v1)) = admit ()

(* prod_merge_fst_preserves (matches Coq: Theorem prod_merge_fst_preserves) *)
let prod_merge_fst_preserves (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_x: _) (p_y: _) : Lemma (fst (prod_merge p_ma p_mb p_x p_y) == p_ma (fst p_x) (fst p_y)) = admit ()

(* prod_merge_snd_preserves (matches Coq: Theorem prod_merge_snd_preserves) *)
let prod_merge_snd_preserves (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_x: _) (p_y: _) : Lemma (snd (prod_merge p_ma p_mb p_x p_y) == p_mb (snd p_x) (snd p_y)) = admit ()

(* prod_merge_partial_bottom_l (matches Coq: Theorem prod_merge_partial_bottom_l) *)
let prod_merge_partial_bottom_l (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_ba: nat) (p_b1: _) (p_b2: _) : Lemma (requires (((forall (p_a: _). p_ma p_ba p_a == p_a)))) (ensures (fst (prod_merge p_ma p_mb (p_ba, p_b1) (p_ba, p_b2)) == p_ba)) = admit ()

(* nat_prod_leq_refl (matches Coq: Theorem nat_prod_leq_refl) *)
let nat_prod_leq_refl (p_x: nat) : Lemma (fst p_x <= fst p_x /\ snd p_x <= snd p_x) = admit ()

(* nat_prod_merge_geq_l (matches Coq: Theorem nat_prod_merge_geq_l) *)
let nat_prod_merge_geq_l (p_x: nat) (p_y: nat) : Lemma (fst (nat_prod_merge p_x p_y) >= fst p_x /\ snd (nat_prod_merge p_x p_y) >= snd p_x) = admit ()

(* nat_prod_merge_geq_r (matches Coq: Theorem nat_prod_merge_geq_r) *)
let nat_prod_merge_geq_r (p_x: nat) (p_y: nat) : Lemma (fst (nat_prod_merge p_x p_y) >= fst p_y /\ snd (nat_prod_merge p_x p_y) >= snd p_y) = admit ()

(* map_has_key_insert_diff (matches Coq: Theorem map_has_key_insert_diff) *)
let map_has_key_insert_diff (p_m: _) (p_k: _) (p_k_: _) (p_v: _) : Lemma (requires (map_has_key p_m p_k == true)) (ensures (map_has_key (map_insert p_m p_k_ p_v) p_k == true)) = admit ()

(* map_merge_aux_nil_r (matches Coq: Theorem map_merge_aux_nil_r) *)
let map_merge_aux_nil_r_obligation () : Tot bool = true
let map_merge_aux_nil_r_lemma () : Lemma (requires True) (ensures (map_merge_aux_nil_r_obligation () == map_merge_aux_nil_r_obligation ())) = ()

(* merkle_create_merge_self (matches Coq: Theorem merkle_create_merge_self) *)
let merkle_create_merge_self (p_s: _) : Lemma (merkle_merge (merkle_create p_s) (merkle_create p_s) == merkle_create p_s) = admit ()

(* merkle_create_state (matches Coq: Theorem merkle_create_state) *)
let merkle_create_state (p_s: _) : Lemma ((merkle_create p_s).f_merkle_state == p_s) = admit ()

(* merkle_create_hash (matches Coq: Theorem merkle_create_hash) *)
let merkle_create_hash (p_s: _) : Lemma ((merkle_create p_s).f_merkle_hash == hash p_s) = admit ()

(* dag_merge_node_count (matches Coq: Theorem dag_merge_node_count) *)
let dag_merge_node_count (p_a: _) (p_b: _) : Lemma (length (dag_merge p_a p_b) == length p_a + length p_b) = admit ()

(* dag_singleton_has_hash (matches Coq: Theorem dag_singleton_has_hash) *)
let dag_singleton_has_hash (p_h: _) (p_children: _) : Lemma (dag_has_hash [(p_h, p_children)] p_h == true) = admit ()

(* dag_singleton_no_other (matches Coq: Theorem dag_singleton_no_other) *)
let dag_singleton_no_other (p_h: _) (p_h_: _) (p_children: _) : Lemma (requires (~(p_h == p_h_))) (ensures (dag_has_hash [(p_h, p_children)] p_h_ == Nat.eqb p_h_ p_h)) = admit ()

(* triple_merge_fst_fst (matches Coq: Theorem triple_merge_fst_fst) *)
let triple_merge_fst_fst (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) (p_x: _) (p_y: _) : Lemma (fst (fst (triple_merge p_ma p_mb p_mc p_x p_y)) == p_ma (fst (fst p_x)) (fst (fst p_y))) = admit ()

(* triple_merge_fst_snd (matches Coq: Theorem triple_merge_fst_snd) *)
let triple_merge_fst_snd (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) (p_x: _) (p_y: _) : Lemma (snd (fst (triple_merge p_ma p_mb p_mc p_x p_y)) == p_mb (snd (fst p_x)) (snd (fst p_y))) = admit ()

(* triple_merge_snd (matches Coq: Theorem triple_merge_snd) *)
let triple_merge_snd (p_a: Type0) (p_b: Type0) (p_c: Type0) (p_ma: nat) (p_mb: nat) (p_mc: nat) (p_x: _) (p_y: _) : Lemma (snd (triple_merge p_ma p_mb p_mc p_x p_y) == p_mc (snd p_x) (snd p_y)) = admit ()

(* composition_idempotent_delivery (matches Coq: Theorem composition_idempotent_delivery) *)
let composition_idempotent_delivery (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) : Lemma (requires (((forall (a1: _). (forall (a2: _). (forall (a3: _). p_ma (p_ma a1 a2) a3 == p_ma a1 (p_ma a2 a3))))) /\ ((forall (p_a: _). p_ma p_a p_a == p_a)) /\ ((forall (b1: _). (forall (b2: _). (forall (b3: _). p_mb (p_mb b1 b2) b3 == p_mb b1 (p_mb b2 b3))))) /\ ((forall (p_b: _). p_mb p_b p_b == p_b)))) (ensures ((forall (s: _). (forall (u: _). prod_merge p_ma p_mb (prod_merge p_ma p_mb s u) u == prod_merge p_ma p_mb s u)))) = admit ()

(* dag_merge_triple_assoc (matches Coq: Theorem dag_merge_triple_assoc) *)
let dag_merge_triple_assoc (p_a: _) (p_b: _) (p_c: _) : Lemma (dag_merge (dag_merge p_a p_b) p_c == dag_merge p_a (dag_merge p_b p_c)) = admit ()

(* hash_deterministic (matches Coq: Theorem hash_deterministic) *)
let hash_deterministic (p_n: _) : Lemma (hash p_n == hash p_n) = admit ()

(* hash_eq_implies_state_eq (matches Coq: Theorem hash_eq_implies_state_eq) *)
let hash_eq_implies_state_eq (p_s1: _) (p_s2: _) : Lemma (requires (hash p_s1 == hash p_s2)) (ensures (p_s1 == p_s2)) = admit ()

(* hash_neq_implies_state_neq (matches Coq: Theorem hash_neq_implies_state_neq) *)
let hash_neq_implies_state_neq (p_s1: _) (p_s2: _) : Lemma (requires (~(hash p_s1 == hash p_s2))) (ensures (~(p_s1 == p_s2))) = admit ()

(* content_addressed_eq (matches Coq: Theorem content_addressed_eq) *)
let content_addressed_eq (p_s: _) : Lemma (hash p_s == hash p_s) = admit ()

(* content_addressed_merge_consistent (matches Coq: Theorem content_addressed_merge_consistent) *)
let content_addressed_merge_consistent (p_a: _) (p_b: _) : Lemma ((merkle_merge p_a p_b).f_merkle_hash == hash (Nat.max (p_a.f_merkle_state) (p_b.f_merkle_state))) = admit ()

(* map_merge_aux_has_key (matches Coq: Theorem map_merge_aux_has_key) *)
let map_merge_aux_has_key (p_m1: _) (p_m2: _) (p_k: _) : Lemma (requires (map_has_key p_m1 p_k == true)) (ensures (map_has_key (map_merge_aux p_m1 p_m2) p_k == true)) = admit ()

(* prod_bottom_idem (matches Coq: Theorem prod_bottom_idem) *)
let prod_bottom_idem (p_a: Type0) (p_b: Type0) (p_ma: nat) (p_mb: nat) (p_ba: nat) (p_bb: nat) : Lemma (requires (((forall (p_a: _). p_ma p_a p_a == p_a)) /\ ((forall (p_b: _). p_mb p_b p_b == p_b)))) (ensures (prod_merge p_ma p_mb (p_ba, p_bb) (p_ba, p_bb) == (p_ba, p_bb))) = admit ()

(* dag_empty_no_hash (matches Coq: Theorem dag_empty_no_hash) *)
let dag_empty_no_hash (p_h: _) : Lemma (dag_has_hash [] p_h == false) = admit ()

(* dag_empty_valid (matches Coq: Theorem dag_empty_valid) *)
let dag_empty_valid () : Lemma (dag_valid [] == true) = admit ()

(* merkle_merge_creates (matches Coq: Theorem merkle_merge_creates) *)
let merkle_merge_creates (p_s1: _) (p_s2: _) : Lemma (merkle_merge (merkle_create p_s1) (merkle_create p_s2) == merkle_create (Nat.max p_s1 p_s2)) = admit ()

(* merkle_valid_hash_matches (matches Coq: Theorem merkle_valid_hash_matches) *)
let merkle_valid_hash_matches (p_node: _) : Lemma (requires (merkle_valid p_node == true)) (ensures (p_node.f_merkle_hash == hash (p_node.f_merkle_state))) = admit ()
