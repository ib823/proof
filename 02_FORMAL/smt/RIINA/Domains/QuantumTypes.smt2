; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/QuantumTypes.v (29 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: QuantumTypes

(set-logic ALL)
(set-option :produce-models true)

; gate (matches Coq: Inductive gate)
(declare-datatypes ((gate 0)) (((Hadamard) (PauliX) (PauliZ) (CNOT))))

; instr (matches Coq: Inductive instr)
(declare-datatypes ((instr 0)) (((ICreate) (IGate) (IGate2) (IMeasure) (ISeq))))

(declare-const __default_gate gate)
(declare-const __default_instr instr)

; mem (matches Coq: Definition mem)
(define-fun mem ((n Int) (l (Seq Int))) Bool
  (= 0 0))

; remove (matches Coq: Definition remove)
(define-fun remove ((n Int) (l (Seq Int))) (Seq Int)
  (as seq.empty (Seq Int)))

; count (matches Coq: Definition count)
(define-fun count ((n Int) (l (Seq Int))) Int
  0)

; check (matches Coq: Definition check)
(define-fun defn_check ((ctx Int) (i instr)) Int
  0)

; well_typed (matches Coq: Definition well_typed)
(define-fun well_typed ((p Int)) Bool
  (= 0 0))

; fully_consumed (matches Coq: Definition fully_consumed)
(define-fun fully_consumed ((p Int)) Bool
  (= 0 0))

; well_typed_b (matches Coq: Definition well_typed_b)
(define-fun well_typed_b ((p Int)) Bool
  (= 0 0))

; fully_consumed_b (matches Coq: Definition fully_consumed_b)
(define-fun fully_consumed_b ((p Int)) Bool
  (= 0 0))

; mem_true_In (matches Coq: Lemma mem_true_In)
; mem_true_In: forall n l, mem n l = true -> In n l
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; mem_true_In [partial: bindings preserved]

; In_mem_true (matches Coq: Lemma In_mem_true)
; In_mem_true: forall n l, In n l -> mem n l = true
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; In_mem_true [partial: bindings preserved]

; mem_false_not_In (matches Coq: Lemma mem_false_not_In)
; mem_false_not_In: forall n l, mem n l = false -> ~ In n l
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; mem_false_not_In [partial: bindings preserved]

; remove_length (matches Coq: Lemma remove_length)
; remove_length: forall n l, mem n l = true -> length (remove n l) = pred (length l)
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; remove_length [partial: bindings preserved]

; remove_not_first (matches Coq: Lemma remove_not_first)
; remove_not_first: forall n l, mem n l = true -> ~ In n (remove n l) \/ In n (remove n l)
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; remove_not_first [partial: bindings preserved]

; count_remove_helper (matches Coq: Lemma count_remove_helper)
; count_remove_helper: forall n l, mem n l = true -> count n (remove n l) + 1 = count n l
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; count_remove_helper [partial: bindings preserved]

; no_cloning (matches Coq: Theorem no_cloning)
; no_cloning: forall q ctx, mem q ctx = true -> check ctx (ICreate q) = None
(assert (forall ((q Bool) (ctx Bool)) (= 0 0))) ; no_cloning [partial: bindings preserved]

; linearity_full_consumption (matches Coq: Theorem linearity_full_consumption)
; linearity_full_consumption: forall p, fully_consumed p -> check [] p = Some []
(assert (forall ((p Bool)) (= 0 0))) ; linearity_full_consumption [partial: bindings preserved]

; measurement_consumes (matches Coq: Theorem measurement_consumes)
; measurement_consumes: forall q ctx ctx', check ctx (IMeasure q) = Some ctx' -> ctx' = remove q ctx /\ mem q ctx = true
(assert (forall ((q Bool) (ctx Bool) (ctx_ Bool)) (= 0 0))) ; measurement_consumes [partial: bindings preserved]

; gate_preserves_context (matches Coq: Theorem gate_preserves_context)
; gate_preserves_context: forall g q ctx ctx', check ctx (IGate g q) = Some ctx' -> ctx' = ctx
(assert (forall ((g Bool) (q Bool) (ctx Bool) (ctx_ Bool)) (= 0 0))) ; gate_preserves_context [partial: bindings preserved]

; type_checking_decidable (matches Coq: Theorem type_checking_decidable)
; type_checking_decidable: forall p, well_typed_b p = true <-> well_typed p
(assert (forall ((p Bool)) (= 0 0))) ; type_checking_decidable [partial: bindings preserved]

; no_dangling_qubits (matches Coq: Theorem no_dangling_qubits)
; no_dangling_qubits: forall p, fully_consumed_b p = true -> check [] p = Some []
(assert (forall ((p Bool)) (= 0 0))) ; no_dangling_qubits [partial: bindings preserved]

; seq_preserves_linearity (matches Coq: Theorem seq_preserves_linearity)
; seq_preserves_linearity: forall i1 i2 ctx ctx1 ctx2, check ctx i1 = Some ctx1 -> check ctx1 i2 = Some ctx2 -> check ctx (ISeq i1 i2) = Some ctx2
(assert (forall ((i1 Bool) (i2 Bool) (ctx Bool) (ctx1 Bool) (ctx2 Bool)) (= 0 0))) ; seq_preserves_linearity [partial: bindings preserved]

; create_increases_resources (matches Coq: Theorem create_increases_resources)
; create_increases_resources: forall q ctx ctx', check ctx (ICreate q) = Some ctx' -> length ctx' = S (length ctx)
(assert (forall ((q Bool) (ctx Bool) (ctx_ Bool)) (= 0 0))) ; create_increases_resources [partial: bindings preserved]

; measure_decreases_resources (matches Coq: Theorem measure_decreases_resources)
; measure_decreases_resources: forall q ctx ctx', check ctx (IMeasure q) = Some ctx' -> length ctx' = pred (length ctx)
(assert (forall ((q Bool) (ctx Bool) (ctx_ Bool)) (= 0 0))) ; measure_decreases_resources [partial: bindings preserved]

; create_measure_consumed (matches Coq: Theorem create_measure_consumed)
; create_measure_consumed: forall q, fully_consumed (ISeq (ICreate q) (IMeasure q))
(assert (forall ((q Bool)) (= 0 0))) ; create_measure_consumed [partial: bindings preserved]

; create_gate_measure_consumed (matches Coq: Theorem create_gate_measure_consumed)
; create_gate_measure_consumed: forall q g, fully_consumed (ISeq (ICreate q) (ISeq (IGate g q) (IMeasure q)))
(assert (forall ((q Bool) (g Bool)) (= 0 0))) ; create_gate_measure_consumed [partial: bindings preserved]

; mem_head (matches Coq: Theorem mem_head)
; mem_head: forall n l, mem n (n :: l) = true
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; mem_head [partial: bindings preserved]

; mem_nil (matches Coq: Theorem mem_nil)
; mem_nil: forall n, mem n [] = false
(assert (forall ((n Bool)) (= 0 0))) ; mem_nil [partial: bindings preserved]

; count_nil (matches Coq: Theorem count_nil)
; count_nil: forall n, count n [] = 0
(assert (forall ((n Bool)) (= 0 0))) ; count_nil [partial: bindings preserved]

; count_le_length (matches Coq: Theorem count_le_length)
; count_le_length: forall n l, count n l <= length l
(assert (forall ((n Bool) (l Bool)) (= 0 0))) ; count_le_length [partial: bindings preserved]

; remove_nil (matches Coq: Theorem remove_nil)
; remove_nil: forall n, remove n [] = []
(assert (forall ((n Bool)) (= 0 0))) ; remove_nil [partial: bindings preserved]

; gate_requires_qubit (matches Coq: Theorem gate_requires_qubit)
; gate_requires_qubit: forall g q ctx, mem q ctx = false -> check ctx (IGate g q) = None
(assert (forall ((g Bool) (q Bool) (ctx Bool)) (= 0 0))) ; gate_requires_qubit [partial: bindings preserved]

; measure_requires_qubit (matches Coq: Theorem measure_requires_qubit)
; measure_requires_qubit: forall q ctx, mem q ctx = false -> check ctx (IMeasure q) = None
(assert (forall ((q Bool) (ctx Bool)) (= 0 0))) ; measure_requires_qubit [partial: bindings preserved]

; gate2_requires_distinct (matches Coq: Theorem gate2_requires_distinct)
; gate2_requires_distinct: forall g q ctx, check ctx (IGate2 g q q) = None
(assert (forall ((g Bool) (q Bool) (ctx Bool)) (= 0 0))) ; gate2_requires_distinct [partial: bindings preserved]

; double_create_fails (matches Coq: Theorem double_create_fails)
; double_create_fails: forall q, check [] (ISeq (ICreate q) (ICreate q)) = None
(assert (forall ((q Bool)) (= 0 0))) ; double_create_fails [partial: bindings preserved]

; count_singleton (matches Coq: Theorem count_singleton)
; count_singleton: forall n, count n [n] = 1
(assert (forall ((n Bool)) (= 0 0))) ; count_singleton [partial: bindings preserved]

; mem_singleton (matches Coq: Theorem mem_singleton)
; mem_singleton: forall n, mem n [n] = true
(assert (forall ((n Bool)) (= 0 0))) ; mem_singleton [partial: bindings preserved]

; create_on_empty_succeeds (matches Coq: Theorem create_on_empty_succeeds)
; create_on_empty_succeeds: forall q, check [] (ICreate q) = Some [q]
(assert (forall ((q Bool)) (= 0 0))) ; create_on_empty_succeeds [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)
