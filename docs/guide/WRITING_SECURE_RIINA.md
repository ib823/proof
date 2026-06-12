# Writing Secure RIINA

A practical guide to RIINA's security features: what each one is for, how to
use it, and — in keeping with this repository's honesty rules — **exactly what
is enforced by the shipped compiler today** versus what exists as a formal
model awaiting enforcement.

> **Verification promise.** Every code block below marked *(enforced today)*
> was run against the shipped `riinac` before publishing (2026-06-10): the
> "COMPILE ERROR" examples really fail with the message shown, and the
> positive examples really check and run. Claims about Coq theorems cite the
> file that proves them. The gaps section at the end is as load-bearing as the
> features.

---

## 1. Least effect: make functions `Bersih` by default

Every function declares an effect (`kesan`). The typechecker computes the
real effect of the body and rejects the function if it exceeds the
declaration. *(enforced today)*

```riina
fungsi senyap() -> Unit kesan Bersih {
    cetak("bocor")        // COMPILE ERROR
}
```

```
error: Effect violation: allowed Pure, found Write
```

**Practice.** Declare the *narrowest* effect that works, starting from
`Bersih`. A pure function cannot print, write files, or touch the network —
so a reviewer (or an AI agent) reading `kesan Bersih` has a machine-checked
guarantee, not a comment. The effect lattice (Pure < Read < Write <
FileSystem < Network < … < System) is mechanized in Coq
(`foundations/Syntax.v`, `effects/EffectAlgebra.v`), with the general effect
soundness theorem in `effects/EffectSystem.v` (`effect_safety`).

Effect names (EN | BM): `Pure|Bersih`, `Read|Baca`, `Write|Tulis`,
`FileSystem|SistemFail`, `Network|Rangkaian`, `NetworkSecure|RangkaianSelamat`,
`Crypto|Kripto`, `Random|Rawak`, `System|Sistem`, `Time|Masa`,
`Process|Proses`, `Mut|Ubah`, `Alloc|Peruntuk`.

## 2. Secrets: classify, never print, declassify with a proof

`sulit e` (classify) makes a value `Secret`. A secret cannot reach a print
sink — `cetak`, `cetakln`, `cetak_baris`, `print`, `println` — even nested
inside a pair or other container. *(enforced today; added 2026-06-10)*

```riina
fungsi utama() -> Unit kesan Tulis {
    biar pin = sulit 1234;
    cetak(pin)            // COMPILE ERROR
}
```

```
error: Security violation in print sink: declassify (dedah) the secret
       before printing it: level Secret does not flow to Public
```

The sanctioned exit is `dedah … dengan bukti …` (declassify … with proof …):

```riina
fungsi utama() -> Unit kesan Tulis {
    cetak(dedah (sulit 1234) dengan bukti (sulit 1234))    // prints 1234
}
```

The checker enforces the same proof-shape discipline as the Coq `declass_ok`
predicate: the proof must be `bukti` of the *matching* classified value, and
declassifying a non-secret is rejected. This mirrors the machine-checked
declassification theorems (`properties/Declassification.v`:
`logical_relation_declassify_proven`, `declassify_requires_public_context`;
`foundations/Typing.v`: `T_Classify`/`T_Declassify`).

**Practice.**
- Classify secrets *at birth* (key material, PINs, tokens), not at use sites.
- Treat every `dedah` as an audit point: it is grep-able, reviewable, and the
  only place secrecy is removed.
- Comparisons and crypto on secrets should go through constant-time/crypto
  builtins, not through declassify-then-compare.

**Scope today.** References already enforce no-read-up / no-write-down on
security levels (`Typing.v` `T_Deref`/`T_Assign`, mirrored by the checker's
`gate_b_parity` tests), and the print sinks now reject `Secret`. Rejection of
*level-labeled* (`Labeled`) data at print sinks by level, and secret-aware
checking of further sinks (network, file writes) are the named next
increments — tracked as REQ-27 in `RIINA_MASTER_PLAN.md`.

## 3. Untrusted input: taint in, sanitizer out

Anything read from the filesystem is `Tainted<_, FileSystem>` *at birth*, and
sensitive sinks demand `Sanitized` input. *(enforced today)*

```riina
fungsi utama() -> Unit kesan SistemFail {
    biar kandungan = fail_baca("data.sql");
    sql_execute(kandungan)     // COMPILE ERROR
}
```

```
error: Taint violation in sink argument: FileSystem data requires
       SqlParam sanitization before use
```

```riina
fungsi utama() -> Unit kesan Sistem {
    biar kandungan = fail_baca("data.sql");
    sql_execute(sanitasi_sql(kandungan))    // OK
}
```

Sanitizers are sink-specific — a SQL sanitizer does not satisfy an HTML sink:
`sanitasi_sql`/`sanitize_sql`, `sanitasi_html`/`sanitize_html`,
`sanitasi_js`/`sanitize_js`, `sanitasi_perintah`/`sanitize_command`. Using
the wrong one is a `SanitizerMismatch` error. The model is the Coq taint
system (`domains/TaintSystemCorrectness.v`).

### Paths are hardened too

Every file builtin takes a **plain** string path, so a tainted value (e.g.
contents you just read, or user input) cannot be used as a path —
path-traversal prevention at the type boundary. *(enforced today)*

```riina
fungsi utama() -> Unit kesan SistemFail {
    biar laluan = fail_baca("senarai.txt");
    fail_baca(laluan)          // COMPILE ERROR — tainted path
}
```

```
error: Type mismatch: expected String, found Tainted(String, FileSystem)
```

This is the typing-side counterpart of the Coq theorem
`file_path_traversal_impossible` (`domains/TaintSystemCorrectness.v`), and
the full file-builtin signature table — every op requires the `FileSystem`
effect, takes a plain path, returns tainted contents — is itself modeled and
proven in `effects/FileIOEffectModel.v`, pinned to the shipped checker by the
parity test `file_builtin_table_matches_coq_model`.

## 4. Filesystem access control: the verified VFS

The in-memory `vfs_*` builtin family is gated by predicates ported 1:1 from
the Coq access-control model `domains/VerifiedFileSystem.v` (109 Qed:
`no_read_without_perm`, `no_write_without_perm`, quota, journal consistency).
*(enforced today, interpreter)*

```riina
fungsi utama() -> Unit kesan Sistem {
    vfs_mula(1024);                                    // init, 1 KiB quota
    vfs_jadi_pengguna(1000);
    vfs_tulis(("rahsia.txt", "data pengguna 1000"));   // 0644, owned by 1000
    vfs_jadi_pengguna(2000);
    cetak(vfs_baca("rahsia.txt"));                     // OK — other may read
    vfs_tulis(("rahsia.txt", "tulis silang"))          // RUNTIME ERROR
}
```

```
Runtime Error: invalid operation: vfs: permission denied
```

The cross-user write is rejected by the *same* `can_write` predicate the Coq
theorems quantify over; over-quota writes fail with `quota exceeded`.

**Scope today.** The verified inode/uid model governs the `vfs_*` family
(in-memory, interpreter). The host-filesystem `fail_*`/`file_*` builtins are
path-only — they carry the taint/effect discipline of §3 but not the
uid/permission model.

## 5. Money: a separate, exact numeric domain

Financial code should use `wang` (fixed-scale, banker's rounding — both
properties proven over the Coq model, `foundations/FixedPointModel.v`:
`round_he_nearest`, `round_he_tie_even`) or `perpuluhan`
(arbitrary-precision exact decimal, `foundations/DecimalModel.v`).
*(enforced today, all three backends: interpreter, C, WASM)*

```riina
fungsi utama() -> Unit kesan Tulis {
    biar bil    = wang("100.00");
    biar sorang = bil / wang("3");     // 33.33 — rounds AT the sen
    cetak(sorang);
    cetak(wang("0.10") + wang("0.20")) // 0.30 — exactly; no float drift
}
```

The domains do not mix implicitly: `wang("19.99") * 3` is a **compile
error** (use `wang("3")`). There is no floating point in the language, so the
classic `0.1 + 0.2 ≠ 0.3` bug is unrepresentable. For a worked example with
sen reconciliation, see `07_EXAMPLES/03_applications/belah_bil.rii`; payroll
(`gaji.rii`) and invoicing (`invois.rii`) live alongside it.

## 6. Reach is capability-gated

Beyond effects, *reach-extending* operations (network, process) participate
in an opt-in capability discipline: once a program grants capabilities, a
`Network`/`Process` operation requires the matching capability in scope, and
a function declaring `kesan Rangkaian`/`kesan Proses` auto-grants it in its
body. The Coq side is `effects/EffectGate.v` (`grant_no_escalation` — a grant
authorizes, it never *adds* effects). *(enforced today, opt-in)*

## 7. What is NOT enforced yet — read this section

Honesty is the product. As of 2026-06-10:

| Area | Status |
|---|---|
| Effect checking (`kesan`) | Enforced (checker + interpreter; effect lattice proven in Coq) |
| Secret → print sink | Enforced (this guide §2); other sink families (network/file writes) and `Labeled`-by-level are the named next REQ-27 increments |
| Full non-interference | Proven in Coq for the model language; compiler enforcement is **partial** (REQ-27 tracks the parity gap) |
| Taint/sanitizers, path hardening | Enforced at the type boundary (§3) |
| Verified VFS | Enforced for `vfs_*` (interpreter, in-memory); host `file_*` are path-only |
| Numeric tower | Complete across interpreter + C + WASM backends; every type Coq-modeled |
| Example corpus | `00_basics/` + `03_applications/` run today; parts of the wider corpus are aspirational and do not compile yet |
| Crypto primitives | Implemented + KAT-tested (`riina-core`); **external audit not yet performed** (REQ-28) |

The authoritative, continuously verified status is `RIINA_MASTER_PLAN.md`
Part 2 (metrics re-derived from commands, never copied) and Part 11 (gap
register). If this guide and the plan ever disagree, the plan wins and the
guide has a bug.

## 8. Checklist

- [ ] Every function declares the narrowest `kesan` that compiles.
- [ ] Secrets are `sulit` at birth; `dedah … dengan bukti …` only at audited
      points; nothing secret is printed.
- [ ] All external input (files today; network when it lands) flows through a
      sink-matched `sanitasi_*` before reaching a sink.
- [ ] File paths are literals or validated plain strings — never tainted data.
- [ ] Multi-user file logic uses the verified `vfs_*` family, not host `file_*`.
- [ ] Money uses `wang` (or `perpuluhan`), never plain integers of sen.
- [ ] You have read §7 and your threat model does not assume an unenforced
      feature.
