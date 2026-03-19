# Paper 3: Algebraic Effect Soundness for RIINA

## Abstract

We present a formal proof of effect soundness for RIINA's algebraic effect
system. RIINA tracks computational effects through a lattice-ordered effect
annotation system (Bersih through Masa), ensuring that pure functions cannot
perform side effects and that effect composition is sound. We prove that
effect annotations are preserved through reduction and that effect handling
correctly discharges effect obligations.

## Key Results

- **Theorem: Effect Preservation** — Reduction preserves effect annotations;
  a term annotated with effect E only performs operations within E.
- **Theorem: Effect Subsumption** — The effect lattice ordering is respected:
  a function with effect Bersih (pure) can be used where Tulis (write) is
  expected, but not vice versa.
- **Theorem: Handler Soundness** — An effect handler for effect E discharges
  the E obligation, producing a computation with reduced effect.
  Coq reference: `handle_typed_steps_once`
- **Theorem: Effect Row Composition** — Combined effects (e.g., Baca + Tulis)
  are correctly computed as the join in the effect lattice.

## Effect Lattice

```
Bersih(0) < Ubah(1) < Baca(2) < Peruntuk(3) < Tulis(4)
  < SistemFail(5) < Rangkaian(6) < Kripto(8) < Sistem(10) < Masa(11)
```

## Related Work (Sketch)

- Plotkin & Pretnar (2009) — Handlers of algebraic effects
- Bauer & Pretnar (2015) — Programming with algebraic effects and handlers
- Leijen (2017) — Type-directed compilation of row-typed algebraic effects (Koka)
- Lindley, McBride & McLaughlin (2017) — Do be do be do (Frank)

## Venue Target

**OOPSLA** (Object-Oriented Programming, Systems, Languages & Applications)
or **ICFP**

## Coq Source Files

- `02_FORMAL/coq/foundations/Effects.v`
- `02_FORMAL/coq/foundations/EffectLattice.v`
- `02_FORMAL/coq/foundations/Handlers.v`
