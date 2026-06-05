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

> ## ⚑ HEADLINE FINDING — RIINA's PQC followed pre-final drafts, not FIPS 203/204
> Authentic **NIST ACVP keyGen vectors** (vendored under `tests/vectors/`) showed that
> **neither** ML-KEM-768 nor ML-DSA-65 reproduced NIST's keys — both followed the
> **pre-final Kyber/Dilithium drafts, not FIPS 203/204**. Identical pattern, confirmed
> by comparing intermediates against the vectors:
> - **ML-KEM:** `K-PKE.KeyGen` used `G(d)` instead of FIPS 203 `G(d ‖ k)`; adding the
>   domain-separator byte makes **ρ match NIST exactly**, but **t̂ still diverged**.
> - **ML-DSA:** keyGen used `H(ξ)` instead of FIPS 204 `H(ξ ‖ k ‖ ℓ)`; adding the
>   dimension bytes makes **ρ match NIST exactly**, but **pk still diverges**.
>
> So in *both* primitives the missing FIPS-final parameter-set domain separator is the
> first delta, and *both* had further sampling/NTT/encoding deltas. The existing
> roundtrip tests passed only because each implementation is **self-consistent**; they
> cannot detect non-interoperability. **Fixing this is output-breaking** (every key,
> ciphertext, signature, and shared secret changes) and must be a deliberate, atomic
> FIPS 203/204 reconciliation. The two ACVP KATs are the oracles. This is the
> single most important result of the pre-audit — exactly what ACVP testing and an
> external audit (REQ-28) exist to catch.
>
> ### ✅ UPDATE 2026-06-04 — BOTH PQC primitives RECONCILED (byte-exact vs NIST ACVP)
> **ML-KEM-768 → FIPS 203** for keyGen, encaps, and decaps
> (`kat_ml_kem_768_keygen_acvp_fips203`, `kat_ml_kem_768_encaps_decaps_acvp_fips203`).
> Beyond the `G(d) → G(d ‖ k)` domain separator, the root cause was a sampler bug:
> `sample_ntt` read its **zero-initialised buffer on the first iteration**, so the
> matrix Â was silently all-zeros and t̂ collapsed to ê (exactly why ŝ/dk matched NIST
> while t̂/ek did not). Also added `poly_tomont` after the Â∘ŝ basemul-accumulate and
> reconciled the FO transform (shared secret `K` from `G` directly; implicit rejection
> `K̄ = J(z ‖ c)` over the full ciphertext).
>
> **ML-DSA-65 → FIPS 204** for keyGen, sigGen, and sigVer
> (`kat_ml_dsa_65_keygen_acvp_fips204`, `kat_ml_dsa_65_siggen_acvp_fips204`,
> `kat_ml_dsa_65_sigver_acvp_fips204`). Fixes: (1) `H(ξ) → H(ξ ‖ k ‖ ℓ)`; (2) ExpandS
> (`sample_eta`) was a centered binomial distribution (ML-KEM style) — replaced with
> FIPS 204 `RejBoundedPoly` (`CoeffFromHalfByte` rejection sampling); (3) ExpandA
> (`sample_uniform_ntt`) used the Kyber two-12-bit byte extraction — replaced with
> Dilithium's one-23-bit `CoeffFromThreeBytes` (this was making Â, hence t/pk, diverge);
> (4) deterministic signing `ρ'' = H(K ‖ 0^32 ‖ μ)` (the draft omitted `rnd`).
> **All ACVP KATs pass; `kat_audit` now has 0 ignored tests.**

---

## Status summary

| Primitive | Pass | Findings | Fixed this session | Open |
|---|---|---|---|---|
| `aes.rs` | KATs green (FIPS 197 C.3) | 4 (1 High, 1 Med, 2 Low) | CT barrier on `ct_lookup`; zeroize working state; +exhaustive `ct_lookup` test | raw-API visibility (Low); AESAVS/Monte-Carlo vectors (Low) |
| `constant_time.rs` | tests green | 1 (broken CT primitive) | `ct_select` made branchless; `ct_lt_u8` tightened; +tests | — |
| `ml_kem.rs` (FIPS 203) | **ACVP keyGen + encapDecap byte-exact (green)** | 1 Critical (was not FIPS 203) + 2 Med CT/hygiene | **FIPS 203 reconciliation (sampler/tomont/domain-sep/FO)**; decaps CT branches + zeroization (CT verified) | **✅ FIPS 203 COMPLIANT** |
| `x25519.rs` (+`montgomery`/`field25519`) | RFC 7748 §5.2 + §6.1 green | test hygiene (2 disabled KATs, 1 with bogus data) | enabled/fixed the RFC KATs; **impl was correct + CT**; **deep-pass 2026-06-04: confirmed clean (high-bit handled via field reduce, clamping, all-zero rejection) + added the missing negative test for the contributory all-zero rejection** | — |
| `ed25519.rs` (+`field25519`) | RFC 8032 #1/#2 green | **2 High (live)** + 2 strict-decode (deep-pass) | non-CT `ct_select` on secret scalar path; reversed-borrow `s<L` check; **deep-pass 2026-06-04: non-canonical `y >= p` decode + `x=0`/sign=1 decode now rejected (RFC 8032 §5.1.3)** | small-order/cofactor accept (RFC 8032 cofactorless, low priority); `from_bytes_mod_order` "just copy" (info, benign — clamped/pre-validated at all call sites) |
| `ml_dsa.rs` (FIPS 204) | **ACVP keyGen + sigGen + sigVer byte/behaviour-exact (green)** | 1 Critical (was not FIPS 204) + 1 Med CT | **FIPS 204 reconciliation (H‖k‖l / ExpandS rejection / ExpandA 23-bit / det. rnd)**; `check_norm` CT (poly+vec) + equivalence test | **✅ FIPS 204 COMPLIANT** |
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
- **No NIST ACVP / FIPS 203 KAT vectors (Medium → FIXED).** Roundtrip-only tests would
  pass on a self-consistent but non-compliant impl — and did. **Fixed:** vendored
  authentic NIST ACVP-Server keyGen + encapDecap vectors (with source URL + file
  SHA-256) and added byte-exact KATs. These caught the all-zero-Â sampler bug and now
  guard FIPS 203 compliance permanently.
- **⚑ NOT FIPS 203 (Critical → FIXED).** The keyGen ACVP vector failed: `G(d)` vs
  `G(d ‖ k)`, a missing `poly_tomont` after the Â∘ŝ basemul-accumulate, and — the root
  cause — `sample_ntt` reading its zero-initialised buffer on the first iteration (Â was
  silently all-zeros, so t̂ collapsed to ê). The FO transform also followed the draft.
  **Fixed:** all of the above; ML-KEM-768 keyGen/encaps/decaps are now byte-exact
  against NIST ACVP (the implicit-rejection FO change also updated the decaps
  zeroization set: `ss_valid`/valid-KDF input replaced by the direct `K'` and `j_input`).

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
- **⚑ ML-KEM FIPS 203 (Critical → FIXED 2026-06-04; see ML-KEM section + Headline
  UPDATE).** *Recorded for the audit trail because the earlier diagnosis was wrong:* the
  in-progress hypothesis was that t̂[0..6] = `[737,2104,85,1554,3304,2117]` vs NIST
  `[1832,2364,1911,1048,3000,32]` meant the bug lived in the **core transform
  (NTT/basemul/zeta Montgomery representation)**. It did **not**. The NTT/basemul/tomont
  were correct; the actual root cause was `sample_ntt` reading its **zero-initialised
  buffer on the first iteration**, so the matrix Â was all-zeros and t̂ collapsed to ê
  (hence ŝ/dk matched while t̂/ek didn't, and `poly_tomont` — which was genuinely also
  missing — changed nothing because `tomont(0)=0`). Lesson: an all-zeros operand can
  masquerade as a "deep core" divergence; check operand *content*, not just transforms.
  Now byte-exact against ACVP keyGen + encapDecap.
- **⚑ NOT FIPS 204 (Critical → FIXED 2026-06-04):** keyGen, sigGen, and sigVer are now
  byte/behaviour-exact vs authentic NIST ACVP. Beyond `H(ξ) → H(ξ ‖ k ‖ ℓ)` (which
  aligned ρ), the pk divergence had two sampler root causes — ExpandS used a centered
  binomial distribution instead of FIPS 204 `RejBoundedPoly` (`CoeffFromHalfByte`), and
  ExpandA used the Kyber two-12-bit byte extraction instead of Dilithium's one-23-bit
  `CoeffFromThreeBytes`. Signing additionally needed the deterministic randomizer
  `ρ'' = H(K ‖ 0^32 ‖ μ)`. Guards: `kat_ml_dsa_65_{keygen,siggen,sigver}_acvp_fips204`.
- Open: `decompose`/`make_hint`/`sample_in_ball` CT and encodings were not deeply audited
  this pass. The sign loop's iteration count is inherently `y`-dependent (acceptable).

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

**Net KAT status:** **every primitive now has an authoritative FIPS/RFC KAT** —
SHA-2/SHA-3/HMAC/HKDF/AES/GCM/X25519/Ed25519, plus **ML-KEM-768 (FIPS 203)** and
**ML-DSA-65 (FIPS 204)** byte/behaviour-exact against authentic NIST ACVP. Beyond the
representative KATs, the PQC oracle is now **swept in full for the implemented parameter
sets** (115 ACVP cases: ML-KEM-768 keyGen ×25 / encaps ×25 / decaps ×10; ML-DSA-65 keyGen
×25 / sigGen ×15 / sigVer ×15), the **ML-DSA external/pre-hash/hedged interfaces** are
ACVP-verified (pure, HashML-DSA for shipped hashes, deterministic=false), and **ML-KEM
key-validity checks** (FIPS 203 §7.2/§7.3) are covered. `kat_audit` has **0 ignored tests**.
The remaining correctness-assurance work is machine-level constant-time evidence
(dudect/ctgrind/asm), then the external audit (REQ-28).

---

## Highest-value open items (priority order)

1. ~~**NIST ACVP/CAVP KAT vectors across the suite**~~ **(DONE 2026-06-04)** — the PQC gap
   is closed and then some: ML-KEM-768 and ML-DSA-65 are byte/behaviour-exact vs authentic
   NIST ACVP for keyGen/encapDecap and keyGen/sigGen/sigVer, the **full vector sets** for
   the implemented parameter sets are swept (115 cases), the **ML-DSA external + pre-hash +
   hedged interfaces** are ACVP-verified, and the **ML-KEM §7.2/§7.3 key-validity checks**
   are in place. Remaining ACVP nicety: AESAVS Monte-Carlo (item 4); and the 6 pre-hash
   variants whose hashes RIINA doesn't yet ship (SHA-224/384, SHA-512/224, SHA-512/256,
   SHA3-224/384) — these need those hashes added first.
2. **Machine-level CT verification (next correctness item)** — emitted-asm inspection +
   dudect/ctgrind for the AES S-box, ML-KEM/ML-DSA reductions/NTT/samplers, and the curve
   ladders, per target+toolchain. *Status:* the code already follows CT discipline by
   construction (branchless selects, no secret-dependent branches — verified by inspection
   in this pre-audit), but statistical timing evidence needs a controlled host (stable
   clock, pinned core); it is deliberately **not** faked as a unit-test in CI, where the
   measurement would be noise. This is a scoped harness build-out, not a code patch.
3. **Remaining primitive passes** — `gcm.rs`/`ghash.rs`, `ed25519.rs`, `x25519.rs` deep
   CT/malleability passes (ML-DSA rejection-sampling timing now leaks only randomness, not
   the key — confirmed FIPS-204-correct).
4. **AES**: AESAVS Monte-Carlo vectors; decide raw-block visibility.
5. **Formal equivalence (the repo's north star)** — the ACVP byte-exact reference + vendored
   vectors are the anchor for an eventual proof that the Rust matches a formal spec
   (Coq/F* extraction or a refinement argument), turning "tested-correct" into
   "proven-correct". The F* `CryptographicSecurityActive` lane is still smoke-only; this is
   a major separate effort, now well-anchored.

**AI-ASSISTED PRE-AUDIT — NOT an independent external audit (REQ-28 remains open).
Findings are leads requiring human verification; expect false positives and misses. The
ACVP byte-exactness now gives an external auditor a reproducible correctness baseline,
which is precisely what makes REQ-28 tractable and cheap to commission.**

---

## Deep-pass 2026-06-04 (third pass) — Ed25519 RFC 8032 strict point-decoding + X25519 confirm

Dedicated per-primitive deep pass over `ed25519.rs` / `x25519.rs` (the items left open
by the second-model pass). Method unchanged: read the file + dependencies, run the KATs,
and reason about correctness / malleability / canonicality at source level.

### Ed25519 — two RFC 8032 §5.1.3 strict-decode gaps (fixed)

`EdwardsPoint::decompress` accepted **non-canonical point encodings** that RFC 8032
§5.1.3 requires rejecting. Both are malleability gaps (a single curve point with more
than one valid 32-byte encoding) rather than forgeries, but both are explicit decode
rules and matter for any consensus/fingerprint use of an Ed25519 public key, and for
strict-verification interop:

1. **Non-canonical `y >= p` accepted (fixed).** After clearing the sign bit, the code
   passed the 255-bit `y_bytes` straight to `FieldElement::from_bytes`, which **masks
   bit 255 and reduces mod p silently** — so an encoding with `y ∈ [p, 2^255)` decoded
   to the same point as its canonical `y - p` form. RFC 8032 step 1: "if the resulting
   value is >= p, decoding fails." **Fixed:** added `is_canonical_y` (branchless
   `y_bytes - p` borrow check, mirroring `is_scalar_valid`'s `s < L`) and reject before
   `from_bytes`.
2. **`x = 0` with sign bit set accepted (fixed).** RFC 8032 step 3: "if x = 0 and x_0 =
   1, decoding fails" (there is no negative zero). The code computed `x = 0`, saw the
   requested sign differed, negated (`-0 = 0`), and accepted. **Fixed:** reject when
   `x.is_zero() && x_sign == 1`.

Both fixes are **behaviour-preserving for every canonical input** — all RFC 8032 test
vectors, the sign/verify roundtrips and the basepoint/identity compression tests are
unchanged — they only *add* rejections for non-canonical encodings. New negative tests:
`test_decompress_rejects_noncanonical_y`, `test_decompress_rejects_x_zero_with_sign_set`,
`test_is_canonical_y_boundaries`.

Also added `test_verify_rejects_malleable_s_plus_l`: an end-to-end check that a forged
`(R, s + L)` (congruent to a valid signature mod L) is rejected by the `0 <= s < L`
gate — exercising the second-model `is_scalar_valid` borrow fix through `verify`, which
previously had only a unit test on the helper.

Still open (unchanged, low priority): no small-order/cofactor rejection of `A`/`R`
(RFC 8032 permits cofactorless verification; RIINA's `verify` already uses the strict
`s*B - k*A == R` byte-equality form, which is the cofactorless-strict variant).

### X25519 — confirmed clean; added the missing contributory-rejection test

Re-reviewed `x25519.rs` + `montgomery::x25519`/`x25519_base`. **No defects.** The
RFC 7748 "mask the most significant bit" requirement is subsumed by
`FieldElement::from_bytes` reducing the u-coordinate mod p; scalar clamping is correct;
the all-zero (small-order) shared-secret rejection is present on both the standalone
`x25519` and `X25519KeyPair::diffie_hellman`. The only coverage gap was that **no test
actually triggered** that rejection. **Added** `test_x25519_rejects_low_order_zero_output`
(peer `u = 0`, the order-2 point → clamped scalar sends it to the identity → all-zero
output → `Err`), covering the contributory-behavior guard on both APIs.

### GCM — confirmed clean (no change)

Reconfirmed the second-model finding: CT bitwise GHASH (no H-table), CT tag compare,
verify-before-release, 96-bit nonce enforced. The one documented open item — SP 800-38D
§5.2.1.1 input length limits (plaintext `<= 2^39-256` bits, AAD `<= 2^64-1` bits) — is
**deliberately not enforced**: the bound is ~64 GiB of plaintext in a single buffer
(practically unreachable) and a guard for it could not be exercised by a unit test, so
adding an untestable branch was judged net-negative versus documenting the limit here.

**Net:** Ed25519 decode is now RFC 8032 §5.1.3-strict; X25519 and GCM confirmed clean.
`05_TOOLING` `cargo test --all` 280 → **285 / 0 / 0** (+5 tests), `kat_audit` **23 / 0**,
clippy clean. Machine-level CT evidence (dudect/ctgrind) and the formal-equivalence proof
remain the open crypto threads; REQ-28 (external audit) is still owner-gated.

---

## Machine-level CT evidence 2026-06-05 (report item 2) — dudect-style harness

The pre-audit's "next correctness item" was empirical constant-time evidence to back the
by-construction CT analysis. Delivered: a **dependency-free, dudect-style timing-leakage
harness** at `05_TOOLING/crates/riina-core/examples/dudect_ct.rs` (an `example`, not a
`#[test]` — timing in CI is noise; it never runs in `cargo test` and does not change the
test count). Run it pinned to a core:
`taskset -c 0 cargo run --release --example dudect_ct -p riina-core`.

**Method.** Per primitive, two input classes — class 0 (*fixed* secret) vs class 1
(*random* secret), public inputs equal — are interleaved; the operation is timed and a
**Welch's t-test** (with top-10% cropping to drop hypervisor-steal-time outliers) is
applied. |t| > 4.5 ⇒ FLAGGED. No `dudect`/`criterion`/`rand` crate (Law 8): a hand-rolled
xorshift PRNG + t-test. A **positive control** (`leaky_eq`, an early-return compare) runs
first to prove the harness has detection power in the current environment.

**Environment feasibility (assessed, reported — not faked).** The RIINA dev container is
Docker on a KVM vCPU: it *does* have invariant TSC (`constant_tsc`/`nonstop_tsc`/`rdtscp`),
a 1 ns monotonic clock, and `taskset` core-pinning — better than a worst-case shared host
— but hypervisor steal-time and neighbour contention are not controllable. So in-container
results are **indicative, not audit-grade certification**; the harness exists to (a) catch
gross leaks and regressions and (b) be re-run by an auditor on a controlled bare-metal host
(`isolcpus`/`nohz_full`/fixed freq) for REQ-28.

**Results (representative, `taskset -c 0`, scale ×1):**

| Target | |t| | Verdict |
|---|---|---|
| `POSCTRL_leaky_eq` (positive control) | ~2800–10000 | FLAGGED — correct (early-return branch); confirms detection power |
| `ct_eq_bytes_32` | < 1 | no leak |
| `aes256_encrypt_block` (S-box `ct_lookup`) | < 2 | no leak |
| `ed25519_sign` (`scalar_mul`/`ct_select`) | < 2 | no leak |
| `x25519_diffie_hellman` (ladder swap) | < 1 | no leak |
| `mlkem768_decapsulate` (reductions + implicit reject) | ~2–3 | no leak |
| `aes256gcm_encrypt_64b` (GHASH `gf128_mul`) | ~20–40 | FLAGGED → **investigated: host artifact** |

**The GCM flag is a measurement artifact, not a leak — established two ways:** (1) source
inspection — `ghash::gf128_mul` processes all 128 bits with a mask-based conditional XOR,
shift, and `0xe1` reduction, with **no secret-dependent branch or table** (the prior pass's
"bitwise CT" assessment holds; code inspection is ground truth for a branch leak); (2) the
flag's magnitude (|t|~30, vs the positive control's thousands) is the signature of a tiny
systematic bias, consistent with fixed-vs-random data on a shared vCPU, not a data-dependent
branch. AES alone (same secret=key) reads clean, so it is the software AES+GHASH data path's
microarchitectural sensitivity to *fixed* vs *varying* inputs, which a controlled host
resolves. Recorded as the one in-container FLAG-but-clean for the auditor to re-confirm.

**Methodology note (and a harness self-audit).** A first cut FLAGGED ML-KEM at |t|=114 and
GCM at |t|=21. ML-KEM was a **harness bug**, not a leak: class 1 drew keys from a 256-entry
*pool* (cold cache) vs class 0's single hot fixed key — a footprint artifact. Switching to
per-sample keygen+encaps into the *same* buffers for both classes (symmetric setup; only the
secret bytes differ) dropped ML-KEM to |t|~2.5. Lesson baked into the harness: do identical
untimed work for both classes so only the secret *value* differs. (GCM persisted through this
fix → the source-level investigation above.)

**Net:** by-construction CT is now backed by indicative empirical evidence with a validated
positive control; 5/6 primitives read clean in-container and the 6th (GCM) is code-confirmed
CT with the flag traced to a host artifact. The harness is the reusable instrument for the
controlled-host CT certification an external auditor (REQ-28) performs. The formal-equivalence
proof remains the north-star open thread.

---

## Formal equivalence 2026-06-05 (the north star) — GHASH GF(2^128), first primitive

The north-star deliverable — turning "tested-correct" into "proven-correct" — is now started
with its first primitive: the **GF(2^128) multiplication** at the heart of GHASH / AES-GCM. New
mechanized Coq lane `02_FORMAL/coq/crypto/GF128.v` (the first crypto proof in the Coq corpus;
`# Crypto` section added to `_CoqProject`; active build **314 → 315 files, 12,456 → 12,485 Qed,
0 Admitted / 0 Axiom / 0 Abort**).

**What is modeled and proved.** `GF128.v` models the *exact* bit-serial algorithm in
`05_TOOLING/crates/riina-core/src/crypto/ghash.rs::gf128_mul` over `Z` (big-endian 128-bit, with
an explicit faithfulness map at the file head: `z ^= v` ↔ `Z.lxor`, `v >> 1` ↔ `Z.shiftr v 1`,
`v[15]&1` ↔ `Z.testbit v 0`, `v[0] ^= 0xe1` ↔ `Z.lxor _ RED` with `RED = 0xe1 << 120`, MSB-first
y-bit `i` ↔ `Z.testbit y (127-i)`). It then proves the algebraic structure, all `Qed` (no
`Admitted`), via bit extensionality (`Z.bits_inj'`) reduced to boolean tautology (`btauto`):

- additive group laws (XOR: comm / assoc / 0 / nilpotent);
- `mulx` (multiply-by-the-generator) is GF(2)-linear;
- **bilinearity** — `gf_mul_distr_l` `(a+b)·y = a·y + b·y` and `gf_mul_distr_r`
  `x·(a+b) = x·a + x·b` (proved with loop-invariant lemmas over the 128-step fold);
- **identity** `gf_mul_one_r` `x·1 = x` and **zero** `gf_mul_0_r`;
- **closure** — `mulx`, the loop, and `gf_mul` all stay in `[0, 2^128)` (`gf_mul_in128`),
  i.e. the model is a genuinely closed 128-bit operation.

**Executable cross-check (the bridge).** Concrete products are closed by `vm_compute`
(`Example gf_mul_kat` etc.), and the parity test
`crypto::ghash::tests::test_gf128_mul_matches_coq_model` asserts the **Rust `gf128_mul` is
byte-identical** to the model's computed product on that vector (`05_TOOLING` 285 → **286 / 0 /
0**). So the chain is: *Coq model (proved bilinear/identity/closed) → `vm_compute` product →
Rust `gf128_mul` (byte-equal)*.

**The bridge caught a real bug — in the proof, not the code.** The first model used the
reduction constant as decimal `231` (= `0xe7`), a transcription error for `0xe1` (= `225`); the
parity test failed (`f2d1… ≠ 6504…`), localizing the defect to the Coq side (the Rust was
correct). Fixing `RED` to `225` made model and implementation agree byte-for-byte. This is
exactly why an *executable* equivalence anchor (not just a hand proof) is worth building — it
mechanically catches model⇄implementation drift in either direction.

**Honest scope.** This is one primitive. It is a real, complete, `Admitted`-free formal model +
impl cross-check for GHASH multiplication — and the template for the rest. It is *not* yet a full
GCM/AES proof, nor a commutativity/associativity proof of the field (the hard laws were not
attempted rather than admitted). Remaining formal-equivalence work (multi-session): the full
`Ghash::compute` fold, AES GF(2^8) (`xtime`/MixColumns + the S-box as field-inverse∘affine),
SHA-2/SHA-3 round bit-ops, and the curve25519 field arithmetic. The methodology (faithful `Z`
model + `bits_inj'`/`btauto` algebra + `vm_compute` KAT + a Rust parity test) now exists to
replicate.

### GHASH fold (second primitive, 2026-06-05)

`02_FORMAL/coq/crypto/GHASH.v` (imports `GF128`; active build 315 -> 316 files, 12,485 ->
12,506 Qed, 0 Admitted/Axiom/Abort) lifts the multiply to the **full GHASH hash**. It models
`Ghash::update_block`'s recurrence `acc := (acc XOR block) * H` as a `fold_left` (`ghash`) and
proves, all `Qed`:

- **`ghash_linear`** — GHASH_H is GF(2)-linear in the (equal-length) block message:
  `GHASH_H(X (+) Y) = GHASH_H(X) (+) GHASH_H(Y)`. This *is* the almost-XOR-universal structure
  GCM's authentication security rests on (forging the tag means colliding this hash).
- **`ghash_cons` / `ghash_horner_two`** — the Horner / polynomial form
  `GHASH_H(B1..Bm) = (+)_i B_i * H^(m-i+1)` (proved via an accumulator-shift lemma over the fold).

Executable `vm_compute` KATs (`ghash_kat_1`, `ghash_kat_2`, and `ghash_kat_horner` which closes
by the *proven* `ghash_horner_two`) feed the Rust parity test
`crypto::ghash::tests::test_ghash_fold_matches_coq_model` (a `Ghash::new`/`update_block`
sequence), byte-identical (05_TOOLING 286 -> 287).

A Coq-specific lesson worth recording for the lane: because `gf_mul` is a 128-step fixpoint, any
`simpl`/`cbn` that reduces a goal containing it makes the **Qed-time kernel conversion** (which
ignores `Opaque`) expand the fixpoint symbolically and diverge. The fix that makes the lane
scalable: keep `gf_mul`/`ghash_step` `Opaque` and rewrite structure with generic `Qed`-opaque
lemmas (`fold_left_cons`/`zip_xor_cons`/...) so the kernel treats them as black boxes; concrete
KATs still go through `vm_compute`.

### AES GF(2^8) & S-box (third primitive, 2026-06-05)

`02_FORMAL/coq/crypto/AESField.v` (active build 316 -> 317 files, 12,506 -> 12,511 Qed, 0
Admitted/Axiom/Abort) models AES's field arithmetic — `xtime` (x2 mod the Rijndael polynomial
0x11b) and `gf_mul` (russian-peasant), faithful to `aes.rs` — and tackles the most error-prone
part of any AES: the two magic 256-byte S-box tables. The `SBOX`/`INV_SBOX` tables are
transcribed verbatim from `aes.rs` and proved, **over all 256 bytes by `vm_compute`** (concrete
reduction — no symbolic fixpoint blow-up), to be the genuine mathematical construction:

- **`sbox_eq_construction`** — `SBOX[a] = affine(a^254)` for every byte, where `a^254` is the
  GF(2^8) multiplicative inverse and `affine` is the AES affine map. I.e. the shipped table *is*
  the real AES S-box, not a mistyped table.
- **`gf_inv_correct`** — `a · a^254 = 1` for all `a != 0` (255 cases): `a^254` really is the
  inverse.
- **`sbox_inv_sbox_id` / `inv_sbox_sbox_id`** — `SBOX` and `INV_SBOX` are mutual inverses (so the
  S-box is a bijection and decryption inverts encryption at the substitution step).
- **`gmul_kat`** — the FIPS 197 §4.2 worked example `0x57 · 0x83 = 0xc1`.

Rust bridge `crypto::aes::tests::test_sbox_matches_coq_model` recomputes the S-box from
`gf_mul`+affine in Rust and asserts it equals the shipped `SBOX` (and that `INV_SBOX` inverts it),
mirroring the Coq construction. This finite-`vm_compute` style sidesteps the Qed-kernel-conversion
issue entirely and is the template for the remaining table/field primitives.

### SHA-256 (fourth primitive, 2026-06-05)

`02_FORMAL/coq/crypto/SHA256.v` (active build 317 -> 318 files, 12,511 -> 12,513 Qed, 0
Admitted/Axiom/Abort) is a faithful Coq model of `sha2.rs`: the 32-bit word ops, the round
functions (`ch`/`maj`/Σ0/Σ1/σ0/σ1), the message schedule, the 64-round compression with the
Davies-Meyer feed-forward, the constants `H0`/`K`, and single-block padding. SHA-256 is a hash —
designed to have no exploitable algebra — so the content here is *executable* equivalence rather
than structural theorems: the model is run by `vm_compute` and proven to reproduce the FIPS 180-4
known-answer digests for `"abc"` (`sha256_abc`) and `""` (`sha256_empty`). The Rust parity test
`crypto::sha2::tests::test_sha256_matches_coq_model` asserts `Sha256::hash` returns those
byte-identical digests, so the Coq spec, the FIPS vectors, and the shipped implementation all
agree.

### SHA-3 / Keccak-f[1600] (fifth primitive, 2026-06-05)

`02_FORMAL/coq/crypto/Keccak.v` (active build 318 -> 319 files, 12,513 -> 12,515 Qed, 0
Admitted/Axiom/Abort) models the Keccak-f[1600] permutation — the five step mappings
theta/rho/pi/chi/iota over the 25-lane (5x5x64) state, with the round-constant, rotation-offset
and pi-permutation tables transcribed verbatim from `keccak.rs` — and the SHA3-256 sponge
(rate 1088, domain `0x06`/`0x80` padding). Like SHA-256 it is a hash, so the content is the
executable model<->spec<->implementation agreement: the model is run by `vm_compute` and proven
to reproduce the FIPS 202 known-answer digests for `""` (`sha3_256_empty`) and `"abc"`
(`sha3_256_abc`). The Rust parity test `crypto::keccak::tests::test_sha3_256_matches_coq_model`
asserts `Sha3_256::hash` returns those byte-identical digests. (SHA-3/SHAKE is the symmetric
primitive the PQC suite — ML-KEM/ML-DSA — is built on, so this model also anchors a future PQC
formal-equivalence.)

### Curve25519 field GF(2^255-19) (sixth primitive — the deep one, 2026-06-05)

`02_FORMAL/coq/crypto/Field25519.v` (active build 319 -> 320 files, 12,515 -> 12,524 Qed, 0
Admitted/Axiom/Abort) takes on the structurally-deep target the lane had been saving: the
radix-2^51, 5-limb field arithmetic of `field25519.rs` (the field underneath X25519 and Ed25519).
Unlike the hashes, this is proved *symbolically*, not by KAT. A field element's value is
`a0 + a1*2^51 + ... + a4*2^204`; the theorems are:

- **`mul_correct_mod`** (headline) — `val(femul a b) mod p = (val a * val b) mod p`. The Rust
  `mul` is a 5x5 schoolbook product whose high half is folded by `2^255 = 19 (mod p)`. The proof
  shows the folded 5-limb result differs from the true product `val a * val b` by an exact
  multiple of `p = 2^255-19` (`mul_reduce_eq`, closed by `ring`), so they are congruent mod p.
  This is the Mersenne-style reduction correctness that makes Curve25519 arithmetic right — the
  same property fiat-crypto mechanizes.
- **`add_correct`** (`val(feadd a b) = val a + val b`, exact) and **`sub_correct_mod`** (the
  Rust's `+2p` underflow-avoidance vanishes mod p, using `val(P_LIMBS) = p`).
- Executable corner cases (`vm_compute`): `(p-1)^2 ≡ 1` and the reduction `2^254·4 ≡ 38`.

The Rust then runs carry propagation (which preserves the value mod p); the parity test
`crypto::field25519::tests::test_mul_matches_coq_model` confirms the *full carried* implementation
on those vectors, including the reduction case.

### Full AES-256 cipher (seventh primitive, 2026-06-05)

`02_FORMAL/coq/crypto/AES.v` (active build 320 -> 321 files, 12,524 -> 12,528 Qed, 0
Admitted/Axiom/Abort) closes the loop on AES. `AESField.v` (third primitive) already proved the
256-byte S-box *is* the genuine field construction `affine(a^254)`; this primitive assembles the
**whole cipher** on top of it. The model represents the AES state as a flat 16-byte list in block
order (index `4c+r` is state cell `s[r][c]`, exactly the big-endian `block_to_state` packing of the
Rust `u32x4` state) and defines each transform faithfully:

- **Key schedule** (`key_schedule`): the 60-word AES-256 expansion — `RotWord`/`SubWord`/`Rcon` at
  `i mod 8 = 0`, the extra `SubWord` at `i mod 8 = 4` — reusing the proven `aes_sbox`.
- **The four round transforms**: `sub_bytes` (S-box over 16 bytes), `shift_rows` (the fixed
  block-order permutation derived from the Rust row-extract/shift/repack), `mix_columns` (the
  `[2 3 1 1; …]` GF(2^8) matrix via the proven `gmul`), `add_round_key` (bytewise XOR), plus their
  inverses, wired into the 14-round encrypt and decrypt structure (final round drops MixColumns).

`aes256_encrypt_fips197` and `aes256_decrypt_fips197` prove by `vm_compute` that the model
reproduces the **FIPS-197 Appendix C.3** known-answer vector (key `000102…1f`, plaintext
`00112233…ff` ⟷ ciphertext `8ea2b7ca…89`) in *both* directions — and `ks_first_word`/`ks_eighth_word`
pin the schedule. The parity test `crypto::aes::tests::test_aes256_matches_coq_model` confirms the
shipping `Aes256` (the optimized `u32`-state impl) is byte-identical on those exact vectors. So AES
is verified from "the S-box is the genuine construction" all the way up to "the entire AES-256 block
transform is the real AES".

**Lane status:** seven primitives now model-proven + implementation-cross-checked — GHASH's
GF(2^128) multiply, the full GHASH fold, AES's GF(2^8)/S-box, the full AES-256 cipher, SHA-256,
SHA3-256/Keccak, and the Curve25519 field (the GCM + AES + SHA-2 + SHA-3 + ECC cores of Law-2
crypto). The crypto formal-equivalence lane now spans every symmetric/field core of the suite, with
AES proven end-to-end. Remaining algebra targets: the ML-KEM/ML-DSA NTT and the X25519 ladder; then
machine-level CT on a controlled host; then REQ-28.
