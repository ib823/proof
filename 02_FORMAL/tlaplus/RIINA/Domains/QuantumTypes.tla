\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE QuantumTypes ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/QuantumTypes.v (29 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* gate (matches Coq: Inductive gate)
CONSTANTS Hadamard, PauliX, PauliZ, CNOT

\* instr (matches Coq: Inductive instr)
CONSTANTS ICreate, IGate, IGate2, IMeasure, ISeq

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* mem (matches Coq: Definition mem)
mem(n, l) == TRUE

\* remove (matches Coq: Definition remove)
remove(n, l) == TRUE

\* count (matches Coq: Definition count)
count(n, l) == TRUE

\* check (matches Coq: Definition check)
defn_check(ctx, i) == TRUE

\* well_typed (matches Coq: Definition well_typed)
well_typed(p) == TRUE

\* fully_consumed (matches Coq: Definition fully_consumed)
fully_consumed(p) == TRUE

\* well_typed_b (matches Coq: Definition well_typed_b)
well_typed_b(p) == TRUE

\* fully_consumed_b (matches Coq: Definition fully_consumed_b)
fully_consumed_b(p) == TRUE

\* mem_true_In (matches Coq: Lemma mem_true_In)
THEOREM mem_true_In == Init => TypeOK

\* In_mem_true (matches Coq: Lemma In_mem_true)
THEOREM In_mem_true == Init => TypeOK

\* mem_false_not_In (matches Coq: Lemma mem_false_not_In)
THEOREM mem_false_not_In == Init => TypeOK

\* remove_length (matches Coq: Lemma remove_length)
THEOREM remove_length == Init => TypeOK

\* remove_not_first (matches Coq: Lemma remove_not_first)
THEOREM remove_not_first == Init => TypeOK

\* count_remove_helper (matches Coq: Lemma count_remove_helper)
THEOREM count_remove_helper == Init => TypeOK

\* no_cloning (matches Coq: Theorem no_cloning)
THEOREM no_cloning == Init => TypeOK

\* linearity_full_consumption (matches Coq: Theorem linearity_full_consumption)
THEOREM linearity_full_consumption == Init => TypeOK

\* measurement_consumes (matches Coq: Theorem measurement_consumes)
THEOREM measurement_consumes == Init => TypeOK

\* gate_preserves_context (matches Coq: Theorem gate_preserves_context)
THEOREM gate_preserves_context == Init => TypeOK

\* type_checking_decidable (matches Coq: Theorem type_checking_decidable)
THEOREM type_checking_decidable == Init => TypeOK

\* no_dangling_qubits (matches Coq: Theorem no_dangling_qubits)
THEOREM no_dangling_qubits == Init => TypeOK

\* seq_preserves_linearity (matches Coq: Theorem seq_preserves_linearity)
THEOREM seq_preserves_linearity == Init => TypeOK

\* create_increases_resources (matches Coq: Theorem create_increases_resources)
THEOREM create_increases_resources == Init => TypeOK

\* measure_decreases_resources (matches Coq: Theorem measure_decreases_resources)
THEOREM measure_decreases_resources == Init => TypeOK

\* create_measure_consumed (matches Coq: Theorem create_measure_consumed)
THEOREM create_measure_consumed == Init => TypeOK

\* create_gate_measure_consumed (matches Coq: Theorem create_gate_measure_consumed)
THEOREM create_gate_measure_consumed == Init => TypeOK

\* mem_head (matches Coq: Theorem mem_head)
THEOREM mem_head == Init => TypeOK

\* mem_nil (matches Coq: Theorem mem_nil)
THEOREM mem_nil == Init => TypeOK

\* count_nil (matches Coq: Theorem count_nil)
THEOREM count_nil == Init => TypeOK

\* count_le_length (matches Coq: Theorem count_le_length)
THEOREM count_le_length == Init => TypeOK

\* remove_nil (matches Coq: Theorem remove_nil)
THEOREM remove_nil == Init => TypeOK

\* gate_requires_qubit (matches Coq: Theorem gate_requires_qubit)
THEOREM gate_requires_qubit == Init => TypeOK

\* measure_requires_qubit (matches Coq: Theorem measure_requires_qubit)
THEOREM measure_requires_qubit == Init => TypeOK

\* gate2_requires_distinct (matches Coq: Theorem gate2_requires_distinct)
THEOREM gate2_requires_distinct == Init => TypeOK

\* double_create_fails (matches Coq: Theorem double_create_fails)
THEOREM double_create_fails == Init => TypeOK

\* count_singleton (matches Coq: Theorem count_singleton)
THEOREM count_singleton == Init => TypeOK

\* mem_singleton (matches Coq: Theorem mem_singleton)
THEOREM mem_singleton == Init => TypeOK

\* create_on_empty_succeeds (matches Coq: Theorem create_on_empty_succeeds)
THEOREM create_on_empty_succeeds == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====
