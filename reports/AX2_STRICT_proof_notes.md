# AX2-STRICT Proof Notes (Blocked)

## Target

- `val_rel_n_step_up`
- Declaration: `02_FORMAL/coq/properties/NonInterference_v2.v:1535`

## 1) Exact failing goal + local context

### Strategy 1 failure (direct induction)

From `/tmp/ax2_strategy1.log` (`02_FORMAL/coq/properties/NonInterference_v2.v:1553`):

```text
Context:
Σ : store_ty
T : ty
v1, v2 : expr
Hrel_prev : val_rel_n 0 Σ T v1 v2
Hv1 : value v1
Hv2 : value v2
Hc1 : closed_expr v1
Hc2 : closed_expr v2
Hty1_prev : has_type [] Σ Public v1 T EffectPure
Hty2_prev : has_type [] Σ Public v2 T EffectPure
Hrat : True
...
Goal:
val_rel_at_type_n 1 Σ (store_rel_n 1) (val_rel_n 1)
  (store_rel_n 1) (store_vals_rel 1) T v1 v2
```

`Hrat` is only `True` (coming from `val_rel_at_type_n 0`), insufficient to build the required step-1 semantic relation.

### Strategy 2 failure (FO/HO split)

From `/tmp/ax2_strategy2.log` (`02_FORMAL/coq/properties/NonInterference_v2.v:1559`):

```text
Context includes:
Hfo : first_order_type T = false
Hrat : True
Goal:
val_rel_at_type_n 1 Σ (store_rel_n 1) (val_rel_n 1)
  (store_rel_n 1) (store_vals_rel 1) T v1 v2
```

FO branch is recoverable; non-FO branch still requires semantic content absent at step 1.

### Strategy 3 failure (typed non-FO constructor analysis)

From `/tmp/ax2_strategy3.log` (`02_FORMAL/coq/properties/NonInterference_v2.v:1559`):

```text
Context specialized:
T = TFn T1 T2 e
Hrel_prev : val_rel_n 0 Σ (TFn T1 T2 e) v1 v2
Hrat : True
...
Goal:
val_rel_at_type_n 1 Σ (store_rel_n 1) (val_rel_n 1)
  (store_rel_n 1) (store_vals_rel 1) (TFn T1 T2 e) v1 v2
```

Typing/value/closedness do not imply extensional function relation required by `val_rel_at_type`.

## 2) Why each strategy failed

1. **Direct structural induction** failed at the `n = 1 -> 2` transition because `val_rel_n 1` stores only `val_rel_at_type_n 0 = True`, while `val_rel_n 2` requires `val_rel_at_type_n 1` (full semantic relation).
2. **FO/HO split** solved FO cases using existing FO equivalence lemmas, but non-FO (especially `TFn`) still lacked the missing semantic witness.
3. **Typed non-FO constructor analysis** confirmed that pure typing information cannot synthesize the TFn Kripke relation demanded at step 1.

## 3) Minimal missing invariant/lemma candidate

A sufficient bridge would be a new invariant of the form:

```coq
forall Σ T v1 v2,
  first_order_type T = false ->
  val_rel_n 1 Σ T v1 v2 ->
  val_rel_at_type Σ (store_rel_n 1) (val_rel_n 1) (store_rel_n 1) (store_vals_rel 1) T v1 v2.
```

This is exactly what the failing branch needs, but it is not derivable from current `val_rel_n 1` design (where non-FO semantic payload is `True`).

## 4) Impacted signatures if elimination is forced without redefining internals

If AX2 were weakened (instead of proven as-is), these signatures/callers would require edits:

- `store_rel_n_step_up` (`02_FORMAL/coq/properties/NonInterference_v2.v:1542`)
- `store_vals_rel_step_up` (`02_FORMAL/coq/properties/NonInterference_v2.v:1596`)
- `val_rel_n_to_val_rel` (`02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1203`)
- `val_rel_n_to_val_rel_any` (`02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:1219`)
- `step_up_at_0` (`02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3195`)
- `logical_relation` internal step-up callsites (`02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:3502` and peers)
- `step_up_and_fundamental_mutual` (`02_FORMAL/coq/properties/NonInterference_v2_LogicalRelation.v:4943`)
- `val_rel_n_step_up_k` (`02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v:58`)

No signature changes were applied in this run.
