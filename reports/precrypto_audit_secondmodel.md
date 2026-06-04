# RIINA `riina-core` — Second-Model Crypto Pre-Audit (Cross-Check)

**What this is.** An independent, second-model (Claude) pre-audit pass over the
hand-rolled crypto in `05_TOOLING/crates/riina-core`, run on the actual checked-out
code (not a ZIP) with the KATs **executed** (`cargo test -p riina-core`). It both
cross-checks the external Codex AES pre-audit and extends to new primitives. Where
findings were clear and the fix was behavior-preserving, they were fixed in-session
(commits noted); riskier/unverifiable items are recorded, not fixed.

**What this is NOT.** Not the REQ-28 external audit (independent accredited firm).
Findings are leads; CT findings reasoned at source level — machine-level constant-
timeness still needs emitted-asm/dudect/ctgrind on each target. Expect false
positives and, especially, **false negatives**.

Method per primitive: read the file + dependencies, run its tests/KATs, analyze
correctness, constant-time (relative to RIINA's leakage contract, excluding
DMP/GoFetch), secret hygiene/zeroization, API misuse, and test adequacy.

> ## ⚑ HEADLINE FINDING — ML-KEM is NOT FIPS 203 compliant
> An authentic **NIST ACVP keyGen vector** (now vendored at
> `tests/vectors/mlkem768_keygen_acvp.txt`) shows RIINA's ML-KEM-768 keygen does
> **not** reproduce NIST's public/secret key — it follows the **pre-final Kyber
> draft, not FIPS 203**. Confirmed deltas: (1) `K-PKE.KeyGen` uses `G(d)` instead
> of FIPS 203's `G(d ‖ k)` domain separator — fixing that makes **ρ match NIST
> exactly**, but (2) **t̂ still diverges**, so the sampling/NTT/encoding pipeline
> has further draft-vs-final differences. The existing roundtrip tests pass only
> because the implementation is *self-consistent*; they cannot detect
> non-interoperability. **This is output-breaking to fix** (all ML-KEM keys/
> ciphertexts/shared-secrets change) and warrants a deliberate, atomic FIPS 203
> reconciliation (and the same ACVP check applied to ML-DSA). The ignored ACVP KAT
> is the oracle. This is the single most important result of the pre-audit, and is
> exactly what an external audit (REQ-28) and proper ACVP testing exist to catch.

---

## Status summary

| Primitive | Pass | Findings | Fixed this session | Open |
|---|---|---|---|---|
| `aes.rs` | KATs green (FIPS 197 C.3) | 4 (1 High, 1 Med, 2 Low) | CT barrier on `ct_lookup`; zeroize working state; +exhaustive `ct_lookup` test | raw-API visibility (Low); AESAVS/Monte-Carlo vectors (Low) |
| `constant_time.rs` | tests green | 1 (broken CT primitive) | `ct_select` made branchless; `ct_lt_u8` tightened; +tests | — |
| `ml_kem.rs` (FIPS 203) | roundtrip green; **ACVP keyGen FAILS** | **1 Critical (not FIPS 203)** + 2 Med CT/hygiene | decaps CT branches + zeroization (CT verified) | **⚑ NOT FIPS 203 — draft Kyber; output-breaking reconciliation needed** |
| `x25519.rs` (+`montgomery`/`field25519`) | RFC 7748 §5.2 + §6.1 green | test hygiene (2 disabled KATs, 1 with bogus data) | enabled/fixed the RFC KATs; **impl was correct + CT** | — |
| `ed25519.rs` (+`field25519`) | RFC 8032 #1/#2 green | **2 High (live)** | non-CT `ct_select` on secret scalar path; reversed-borrow `s<L` check | small-order accept (cofactor); `from_bytes_mod_order` "just copy" (info) |
| `ml_dsa.rs` (FIPS 204) | sign/verify roundtrip green | 1 Med (CT) | `check_norm` rejection-bound made constant-time (poly + vec level) + equivalence test | no ACVP KATs; decompose/make_hint/sample_in_ball CT deeper review |
| `gcm.rs`/`ghash.rs` | NIST GCM KATs green | **none** (clean) | — | nonce-reuse is caller's responsibility (documented); SP 800-38D length limits not enforced (unreachable) |
| `sha2`/`keccak`/`hmac`/`hkdf` | KATs green (+SHA-3 added) | **none** (clean) | added SHA3-256/512 FIPS 202 KATs to the manifest | — |

---

## AES (`aes.rs`) — cross-check of the Codex report

Codex's report was **accurate** (line refs matched, no hallucinations). All 4
findings confirmed against the code. Correctness, which Codex could not run, was
**executed here: FIPS 197 C.3 encrypt+decrypt + GCM KATs pass.**

- **#1 S-box CT not compiler-enforced (High → fixed/contingent).** `ct_lookup`'s
  masked 256-entry scan had no optimization barrier; the doc overclaimed an absolute
  CT guarantee. **Fixed:** `core::hint::black_box` barriers on index+result; doc made
  honest (source-level, contract-relative). Residual: confirm on emitted asm/dudect.
- **#2 Uncleared secret stack state (Medium → fixed).** `encrypt_block`/`decrypt_block`
  left the working `state` (on decrypt, the plaintext) unscrubbed. **Fixed:** volatile
  `state.zeroize()`. Residual (noted in code): transient ShiftRows/MixColumns byte
  copies remain.
- **#3 Raw block API public (Low, open).** Confirmed `pub`; misuse-resistance issue
  (CWE-327 is mis-mapped — AES isn't broken). Consider `pub(crate)`/`hazmat`.
- **#4 Thin tests (Low, partially addressed).** Added an exhaustive `ct_lookup ==
  table[index]` + involution test; still want AESAVS/Monte-Carlo vectors.

## `constant_time.rs` — new finding (Codex was scoped to aes.rs)

- **`ct_select` was not constant-time (fixed).** It computed a mask, ignored it, and
  did `if choice { a } else { b }` behind a `// TODO`. **Exposure was low (dead code):**
  the only `ct_select` call (ed25519:236) resolves to ed25519's *own* method, not this
  one. Still a latent trap in a `pub` "constant-time" API. **Fixed:** branchless
  `(a & mask) | (b & !mask)`; `ct_lt_u8` switched to borrow-based; added the missing
  tests (exhaustive). NOTE: ed25519's own `ct_select` on the secret scalar-bit path is
  a separate item for the ed25519 pass.

## ML-KEM (`ml_kem.rs`, FIPS 203) — second-model pass

**Positive (verified):** the IND-CCA2 implicit-rejection core is **correct and
constant-time** — `c==c'` compared by `|=` accumulation over all bytes, mask
`(((diff as i16)-1)>>8)` = 0xFF iff equal, shared secret selected branchlessly with
both candidates always computed. Reductions (`barrett_reduce`, `cond_sub_q`,
`montgomery_reduce`, `fqmul`) are branchless. `Drop` zeroizes the key bytes.

- **Secret-dependent branches on the decaps path (Medium → fixed).** `to_positive`
  (`if r<0`, feeds `compress` on m'-derived polys) and `encode_message` (`if c<0`,
  extracts decrypted m') branched on the sign of secret coefficients. **Fixed:**
  branchless `x += (x>>15) & q` (mirrors `cond_sub_q`); algebraically identical,
  roundtrip/decaps tests stay green.
- **Decaps secret intermediates unscrubbed (Medium → fixed).** Only `m_prime`/`g_input`
  were zeroized. **Fixed:** also `ss_valid`/`ss_reject`/`k_prime`/`r_prime`/`g_output`/
  `z`/KDF inputs.
- **No NIST ACVP / FIPS 203 KAT vectors (Medium → OPEN).** Tests are roundtrip/self-
  consistency only; they would pass on a self-consistent but non-compliant impl. Top
  correctness-assurance follow-up: add ACVP ML-KEM-768 KATs (and likewise across the
  suite). This needs official vectors and could not be done in-session.

## X25519 (`x25519.rs` + `montgomery.rs` + `field25519.rs`) — second-model pass

**The implementation is correct and constant-time** — the only issue was misleading
test hygiene that made it *look* unvalidated.
- **Disabled/bogus KATs (fixed, test-only).** `x25519::test_x25519_rfc7748_vector1`
  was `#[ignore]`'d ("pending invert validation") but actually passes;
  `montgomery::test_rfc7748_vector2_basepoint` was ignored as a "basepoint encoding
  issue" but in fact asserted a **non-RFC (bogus) expected value** for `scalar1*9`.
  Resolved with the authoritative RFC 7748 §6.1 Diffie-Hellman vectors (a→KA, b→KB,
  shared-secret agreement) + un-ignoring vector-1 + replacing the bogus test. All green.
- **Verified positive:** Montgomery ladder runs all 255 bits with a branchless
  `conditional_swap` (`mask = -swap`); `FieldElement::invert` is Fermat `a^(p-2)`
  (CT); `ct_eq`/`is_zero` branchless; clamping + all-zero (small-order) output
  rejection present.

## Ed25519 (`ed25519.rs` + `field25519.rs`) — second-model pass — **2 High, both live**

RFC 8032 #1/#2 pass, but two serious LIVE defects were found and fixed:
- **`EdwardsPoint::ct_select` not constant-time (High → fixed).** Same broken pattern
  as the dead `constant_time::ct_select`, but **live**: called by `scalar_mul` on the
  **secret** scalar bit during `sign`/keygen, with `if choice==1 {b} else {a}` behind a
  `// TODO`. A timing leak of the private scalar / nonce bits (key-recovery class).
  **Fixed:** branchless `FieldElement::conditional_select` selecting all four extended
  coordinates; RFC 8032 vectors unchanged.
- **`is_scalar_valid` (s<L) reversed borrow (High → fixed).** The non-malleability
  check subtracted `bytes - L` propagating the borrow **MSB→LSB**, mis-classifying any
  scalar needing a cross-byte borrow (**proven**: L-238 reported as ≥ L). Impact: valid
  signatures wrongly rejected (interop) **and** malleable `s ≥ L` could be wrongly
  accepted (defeating the check). **Fixed:** LSB→MSB, branchless; +regression test.
- Open (not fixed): no small-order/cofactor rejection of `A`/`R` (RFC 8032 allows
  cofactorless, so low priority); `Scalar::from_bytes_mod_order` "just copy" comment is
  misleading but benign in context (reduction happens in `scalar_mul`/`scalar_add`).

## ML-DSA (`ml_dsa.rs`, FIPS 204) — second-model pass

Reductions (`montgomery_reduce`/`reduce32`/`caddq`/`freeze`) are branchless/CT.
- **Rejection-bound check not constant-time (Med → fixed).** `Poly::check_norm` had
  secret-dependent branches and an **early `return false`** at the first out-of-bound
  coefficient; it runs on `z = y + c*s1` during signing, so the exit position leaked
  info about `z`/`s1` (the classic ML-DSA leak). `PolyVecK/L::check_norm` used `.all()`
  (short-circuits at the first failing poly). **Fixed:** branchless centered-abs +
  OR-accumulate over all coefficients, and a non-short-circuiting `&=` over polys.
  A **reference-equivalence test** (3000 random polys × 5 bounds + boundaries) proves
  the rewrite changed only timing, not behavior — the safety net for the missing ACVP.
- **⚑ NOT FIPS 203 (Critical, open):** the vendored NIST ACVP keyGen vector fails (see
  the Headline Finding above). `G(d)` should be `G(d ‖ k)` (fixes ρ); t̂ still diverges,
  so sampling/NTT/encoding also differ from FIPS 203. Roundtrip passes only because the
  impl is self-consistent. Needs an atomic, output-breaking FIPS 203 reconciliation; the
  ignored `kat_ml_kem_768_keygen_acvp_fips203` is the oracle.
- Open: no FIPS 204 ACVP KATs (roundtrip only); `decompose`/`make_hint`/`sample_in_ball`
  CT and encodings were not deeply audited this pass. The sign loop's iteration count is
  inherently `y`-dependent (acceptable).

## AES-GCM (`gcm.rs` + `ghash.rs`) — second-model pass — **clean**

No defects found; the hard parts are right:
- **GHASH `gf128_mul` is constant-time** — bitwise shift-and-XOR with mask-based
  conditional add/reduction, all 128 bits processed, **no table** (so the secret hash
  key H does not leak via cache timing).
- **Tag compare is constant-time** (`constant_time_eq`: XOR-accumulate, no early exit).
- **Verify-before-release**: decrypt computes the expected tag, checks it, and only
  runs GCTR decryption on success — no plaintext is produced before authentication.
- Minor/info: 96-bit nonce enforced; nonce-reuse is the caller's responsibility (clearly
  documented); SP 800-38D max-length limits aren't enforced (practically unreachable).

## SHA-2 / SHA-3 / HMAC / HKDF — second-model pass — **clean**

No defects; this family is inherently constant-time (no secret-dependent branches in the
hash cores) and well-tested:
- **HMAC-SHA256:** the one `unsafe` (`ManuallyDrop::take` in `finalize`) is sound (single
  use in a by-value `finalize`; `Drop` only zeroizes keys); `verify` is constant-time
  (`ct_eq`); full RFC 4231 case set (1,2,3,4,6,7).
- **HKDF-SHA256:** correct RFC 5869 extract/expand (counter bounded <= 255), zeroizes PRK/T.
- **SHA-2 / SHA-3:** no `unsafe`, no secret branches. Added **SHA3-256/512 FIPS 202 KATs**
  to the consolidated manifest (`tests/kat_audit.rs`) — was the one missing family there.

**Net KAT status:** every primitive except **ML-KEM** and **ML-DSA** now has an
authoritative FIPS/RFC KAT (SHA-2/SHA-3/HMAC/HKDF/AES/GCM/X25519/Ed25519). ML-KEM-768
(FIPS 203) and ML-DSA-65 (FIPS 204) remain on roundtrip-only tests and need NIST ACVP
JSON vectors — the precisely-scoped job for Codex's Task 1.

---

## Highest-value open items (priority order)

1. **NIST ACVP/CAVP KAT vectors across the suite** (esp. ML-KEM, ML-DSA, the SHA/HMAC/
   HKDF/GCM families) — the biggest correctness-assurance gap for hand-rolled crypto.
2. **Machine-level CT verification** — emitted-asm inspection + dudect/ctgrind for the
   AES S-box, ML-KEM/ML-DSA reductions/NTT, and the curve ladders, per target+toolchain.
3. **Remaining primitive passes** — `ml_dsa.rs` (rejection-sampling timing must leak
   only randomness, not the signing key), `gcm.rs`/`ghash.rs` (GHASH CT, nonce-reuse
   resistance, tag-compare CT, SP 800-38D limits), `ed25519.rs` (canonical S / S<L
   malleability, small-order handling, its own `ct_select` on the secret scalar path),
   `x25519.rs` (clamping, all-zero/low-order rejection, CT ladder).
4. **AES**: AESAVS vectors; decide raw-block visibility.

**AI-ASSISTED PRE-AUDIT — NOT an independent external audit (REQ-28 remains open).
Findings are leads requiring human verification; expect false positives and misses.**
