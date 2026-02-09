# Environment and Baseline Build

## Build System Detection

- Primary build system: `make` + `coq_makefile` driven by `_CoqProject`.
- Evidence:
  - `02_FORMAL/coq/_CoqProject:1` (`-Q . RIINA`, explicit ordered `.v` file list)
  - `02_FORMAL/coq/Makefile:13` (`include Makefile.conf`) and `02_FORMAL/coq/Makefile:37` (`coq_makefile -f _CoqProject -o Makefile`)
- Secondary/root build file exists but is malformed for compilation:
  - `Makefile:10` has a missing recipe separator (`missing separator` from GNU make).

## Toolchain

- Coq version:
  - `coqc -v` => `The Coq Proof Assistant, version 8.20.1` (OCaml 4.14.1)
- Coq toplevel version:
  - `coqtop -v` => `The Coq Proof Assistant, version 8.20.1`
- opam switch:
  - `opam switch show` => `coq820`

## Baseline Build

- Command executed:
  - `make -C 02_FORMAL/coq -j2`
- Result: **fail**
- Exit status: `2`
- First failing compilation unit:
  - `02_FORMAL/coq/effects/EffectGate.v`
- First hard error location:
  - `02_FORMAL/coq/effects/EffectGate.v:97` (unification failure in `EGrant` typing case)

### Failure Excerpt

```text
File "./effects/EffectGate.v", line 97, characters 16-23:
Error:
In environment
G : type_env
S : store_ty
D : security_level
eff : effect
e : expr
T : ty
ε : effect
H : has_type G S D e T ε
Unable to unify
 "has_type_full ?M1383 ?M1384 ?M1385 (EGrant ?M1386 ?M1387) ?M1388 ?M1389"
with "has_type G S D (EGrant eff e) T ε".
```

## Captured Logs

- Coq baseline build log: `/workspaces/proof/diagnostics/baseline_build.log`
- Root make probe log: `/tmp/root_make.log`
