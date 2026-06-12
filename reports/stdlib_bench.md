# RIINA Verified-Stdlib Benchmark Results

**Harness:** `03_PROTO/crates/riina-codegen/benches/stdlib_bench.rs`
(dependency-free, `harness = false` — **Law 8: zero third-party deps**, no
`criterion`). Exercises the *running* implementations behind the Coq-verified
algorithms (`VerifiedList.v`, `VerifiedMapSet.v`, `VerifiedString.v`,
`SizedInt.v`) via the public `apply_builtin` dispatcher and `Interpreter::eval`.

**Reproduce:** `cargo bench --manifest-path 03_PROTO/Cargo.toml -p riina-codegen --bench stdlib_bench`

**Method:** each row auto-scales its iteration count until a ≥50 ms wall-clock
window is reached, then reports mean ns/op and ops/s. Inputs are generated from
a fixed LCG seed (the same one the stdlib property tests use), so the numbers
are reproducible run to run on a given machine.

> **Absolute numbers are environment-specific** (the figures below were measured
> in the CI/dev container, not a tuned host). The *durable* signal is the
> **scaling** and the **clone-overhead** comparison, both reproducible anywhere.

## Environment (this run)

- rustc 1.94.1, `bench` profile (optimized)
- Intel(R) Xeon(R) @ 2.80GHz, 4 vCPU, Linux
- Measured 2026-06-03

## Results

```
[collections — senarai.rs / VerifiedList.v]
  senarai_susun (sort)             n=64            5111.3 ns/op           195646 ops/s
  senarai_susun (sort)             n=1024        263878.5 ns/op             3790 ops/s
  senarai_susun (sort)             n=8192       2852033.6 ns/op              351 ops/s
  senarai_unik (dedup)             n=64            9231.4 ns/op           108326 ops/s
  senarai_unik (dedup)             n=1024        302884.9 ns/op             3302 ops/s
  senarai_unik (dedup)             n=8192       2668344.1 ns/op              375 ops/s
  senarai_mengandungi (scan)       n=64            1613.5 ns/op           619767 ops/s
  senarai_mengandungi (scan)       n=1024         25552.8 ns/op            39135 ops/s
  senarai_mengandungi (scan)       n=8192        235236.5 ns/op             4251 ops/s

[maps — peta.rs / VerifiedMapSet.v]
  peta_letak (insert)              n=64           10370.3 ns/op            96429 ops/s
  peta_letak (insert)              n=1024        169101.6 ns/op             5914 ops/s
  peta_letak (insert)              n=8192       1588263.0 ns/op              630 ops/s
  peta_dapat (get)                 n=64            5770.7 ns/op           173288 ops/s
  peta_dapat (get)                 n=1024         81572.1 ns/op            12259 ops/s
  peta_dapat (get)                 n=8192        731778.5 ns/op             1367 ops/s

[sets — set.rs / VerifiedMapSet.v]
  set_letak (insert)               n=64            3224.6 ns/op           310117 ops/s
  set_letak (insert)               n=1024         46462.7 ns/op            21523 ops/s
  set_letak (insert)               n=8192        425456.7 ns/op             2350 ops/s
  set_kesatuan (union)             n=64           33245.8 ns/op            30079 ops/s
  set_kesatuan (union)             n=1024       3442585.1 ns/op              290 ops/s
  set_kesatuan (union)             n=8192      42126175.5 ns/op               24 ops/s

[strings — teks.rs / VerifiedString.v]
  teks_belah (split)               n=64            4546.6 ns/op           219944 ops/s
  teks_belah (split)               n=1024         62049.7 ns/op            16116 ops/s
  teks_belah (split)               n=8192         501044.8 ns/op            1996 ops/s
  teks_cantum (join)               n=64            9630.9 ns/op           103833 ops/s
  teks_cantum (join)               n=1024        136931.5 ns/op             7303 ops/s
  teks_cantum (join)               n=8192       1123020.4 ns/op              890 ops/s
  teks_ulang (repeat)              n=64             144.8 ns/op          6908270 ops/s
  teks_ulang (repeat)              n=1024           228.7 ns/op          4372737 ops/s
  teks_ulang (repeat)              n=8192           390.3 ns/op          2562404 ops/s

[numeric tower — IntN wrapping arithmetic / SizedInt.v]
  sized_int_add (u8 wrap)          n=0               59.4 ns/op         16835681 ops/s
  sized_int_mul (u8 wrap)          n=0               59.5 ns/op         16819403 ops/s

[clone baselines — overhead included in the rows above]
  List<Int> clone                  n=8192        242362.8 ns/op             4126 ops/s
  Map<String,Int> clone            n=8192        733383.8 ns/op             1364 ops/s
```

## Findings (durable, hardware-independent)

1. **`set_kesatuan` (union) scaled ~O(n²)** — ~30 µs at n=64 but ~42 ms at
   n=8192 (a 64× input grew runtime ~1270×). The `set.rs` union did a
   linear membership check per element over a `Vec`-backed set. **RESOLVED
   2026-06-05**: `set_kesatuan`/`set_persilangan` now build a hashable `SetKey`
   index over the scalar element variants for O(1) membership (O(n·m) → O(n+m)),
   with an exact `Vec::contains` fallback for compound values (`Pair`/`List`/
   `Closure`/`Ref`, which aren't `Ord`/`Hash` — so a `BTreeSet<Value>` was not
   viable). The change is behaviour-preserving (identical elements/order/no-dup),
   so the *verified* correctness (`VerifiedMapSet.v`) still describes the running
   code; locked by the `opt_union_intersect_equal_naive_reference` guard test.
2. **Read-only ops on large inputs are clone-dominated.** `peta_dapat` at
   n=8192 (≈732 µs) ≈ the `Map` clone baseline (≈733 µs); `senarai_mengandungi`
   at n=8192 (≈235 µs) ≈ the `List` clone baseline (≈242 µs). The public
   `apply_builtin` consumes its argument by value, so the harness clones once
   per call; the underlying get/scan is sub-µs. Real programs that pass
   ownership pay no such clone.
3. **`senarai_susun` / `senarai_unik` scale ~O(n log n)** as expected for
   insertion-sort-backed sort + de-dup (the constant is dominated by `Value`
   comparison/allocation, not algorithmic).
4. **Numeric `IntN` wrapping arithmetic ≈ 59 ns/op** — this is mostly
   interpreter dispatch (`Interpreter::eval` builds a fresh store/env per call);
   the residue-ring wrap itself is a couple of machine ops.
