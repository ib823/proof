# RIINA™ `unsafe` Audit Log

**Status:** Gate G deliverable (REQ-32 — "Design doc for the `unsafe` blocks: per-block invariants +
audit log"). This is the *canonical, exhaustive* record; `THREAT_MODEL.md` §5 is the summary view.

**Methodology:** every `unsafe` site in *shipped source* is listed with the exact operation, the
safety contract it relies on, the invariant that discharges that contract, and a review note. The
inventory is **re-derived from the tree** (`grep -rnE "unsafe (fn|\{|impl)"`), never copied from
prose — per the Paranoid-Absolute Verification directive. Last re-derived: **2026-06-10**.

> **Correction recorded (Zero-Trust directive).** The master plan's prose said "the 7 `unsafe`
> blocks (riina-arena, riina-wasm)". The tree as of 2026-06-10 has **8 `unsafe` sites across the two
> proto crates** (5 in `riina-arena`, 3 in `riina-wasm` — plus a 4th in `riina-wasm` that is an
> `unsafe fn` *signature*, see W-0) **and 4 in `riina-core`**. The number drifted; this log is the
> corrected source of truth. `riina-wasm` is the in-browser playground shim, not the compiler path —
> the plan's "(riina-arena, riina-wasm)" was right about *where*, off-by-one on *how many*.

## Coverage posture

- **`#![forbid(unsafe_code)]` in 11 of 19 proto crates**, including the entire compiler hot path
  outside the arena: `riinac`, `riina-runtime`, `riina-codegen`'s adjacent crates, `riina-fmt`,
  `riina-lsp`, `riina-doc`, `riina-pkg`, `riina-span`, `riina-symbols`, `riina-compliance`, and
  `riina-lexer` (the lexer's lib forbids it; the one fast-path lives behind an explicit allow).
- **All remaining `unsafe` is confined to 3 modules**: `riina-arena` (memory arena), `riina-wasm`
  (playground FFI), and `riina-core` (crypto hygiene). No `unsafe` anywhere else in shipped src.
- **No raw SIMD/`asm!`/gather** in shipped `riina-core` src (verified 2026-06-10) — relevant to the
  Downfall-class side-channel posture in `THREAT_MODEL.md` §6.

---

## A. `riina-arena/src/lib.rs` — bump-allocated typed AST arena (5 sites)

**Why `unsafe` at all:** the parser builds large ASTs; a typed bump-arena hands out stable indices
without per-node heap allocation. The soundness rests on **one structural invariant**:

> **ARENA-INV — chunks are append-only.** A chunk's backing `Vec` is only ever `push`-ed to. It is
> never reallocated in place (growth allocates a *new* chunk and pushes it), never removed, never
> shrunk. Therefore any pointer/reference into an existing chunk remains valid for the arena's
> lifetime.

### A-1 `lib.rs:148` — `let end = unsafe { ptr.add(capacity) };`
- **Contract:** `pointer::add` requires the result to stay within (or one past) the same allocation.
- **Invariant:** `capacity` is exactly the `Vec`'s reserved length (`Vec::with_capacity(capacity)`);
  `ptr` is its start. `ptr.add(capacity)` is the one-past-end pointer — defined.
- **Review:** ✔ sound. End pointer is only ever *compared*, never dereferenced.

### A-2 `lib.rs:193` — `self.ptr.set(unsafe { new_ptr.add(len) });`
- **Contract:** as A-1.
- **Invariant:** `len = current_chunk.storage.len()` ≤ its capacity; the cursor advances by exactly
  the live element count and is range-checked against `end` before the next allocation.
- **Review:** ✔ sound.

### A-3 `lib.rs:204` — `let end = unsafe { ptr.add(new_capacity) };` (in `grow`)
- Identical shape to A-1 for the freshly-allocated chunk. ✔ sound.

### A-4 `lib.rs:230` — `return unsafe { &*ptr.add(local_index) };`
- **Contract:** forming `&T` requires a valid, aligned, initialised `T` that outlives the borrow.
- **Invariant:** the deref is guarded by `index < offset + chunk.storage.len()` (so `local_index` is
  in-bounds of *initialised* elements), and **ARENA-INV** guarantees the element is not moved for the
  arena's lifetime, so the returned `&T` is valid for `&self`. Out-of-range → `panic!` (no UB).
- **Review:** ✔ sound — this is the canonical typed-arena pattern. The only block that vends a
  reference; its safety is the whole point of ARENA-INV.

### A-5 `lib.rs:270` — `unsafe impl<T: Send> Send for TypedArena<T> {}`
- **Contract:** `Send` requires it be sound to move the value to another thread.
- **Invariant:** interior mutability is `RefCell`/`Cell`, so the arena is **deliberately not `Sync`**
  (no shared cross-thread access). *Moving* the whole arena when `T: Send` is sound; the `T: Send`
  bound is necessary and present.
- **Review:** ✔ sound. In practice the compiler is single-threaded; this impl only enables moving an
  arena into a thread, not sharing it.

**Module residual risk:** **Low.** Append-only, bounds-checked, single-threaded use, 6 in-crate unit
tests. ARENA-INV is the single load-bearing invariant and is structurally enforced by the API (no
method exposes chunk removal or in-place realloc).

---

## B. `riina-wasm/src/lib.rs` — browser-playground C-ABI shim (3 blocks + 1 `unsafe fn`)

**Why `unsafe`:** this crate is the `extern "C"` bridge a JS Web Worker calls to run the compiler
in-browser. C-ABI boundaries are inherently `unsafe`. **It is not in the `riinac` compile path** — a
desktop/CI build never links it.

### W-0 `lib.rs:49` — `pub unsafe extern "C" fn riina_free(ptr, size)`
- This is an `unsafe` **function signature**, not a block — and that is *correct*: freeing a
  caller-supplied pointer can only be sound if the caller passes a `(ptr,size)` previously returned by
  `riina_alloc`. Marking the fn `unsafe` pushes that obligation onto the caller, where it belongs. The
  `# Safety` doc-comment states the contract; the JS worker honours it.
- **Review:** ✔ correct API design.

### W-1 `lib.rs:40` — `unsafe { alloc(layout) }`
- **Contract:** `GlobalAlloc::alloc` requires a non-zero-size layout.
- **Invariant:** `size == 0` returns null *before* this line; `Layout::from_size_align(size, 1)` is
  valid for any non-zero `size`. ✔ sound.

### W-2 `lib.rs:66` — `unsafe { slice::from_raw_parts(ptr, len) }`
- **Contract:** `(ptr,len)` must describe a single valid, initialised, immutable allocation for the
  slice's lifetime.
- **Invariant:** `ptr` is null-checked first; by the FFI contract the JS side wrote `len` bytes via a
  prior `riina_alloc(len)`. Crucially, the bytes are then **validated** (`str::from_utf8`), so a
  malformed payload becomes `Err`, never UB downstream.
- **Review:** ⚠ **trusts the caller's `(ptr,len)`** — see residual.

### W-3 `lib.rs:82` — `unsafe { copy_nonoverlapping(...) ×2 }`
- **Contract:** non-overlapping, valid, correctly-sized source/dest.
- **Invariant:** dest = a fresh `riina_alloc(4 + bytes.len())` (null-checked); source = the caller's
  `&str` bytes and a 4-byte length array; fresh allocation cannot overlap the source. Sizes are exact
  (`4` and `bytes.len()`). ✔ sound.

**Module residual risk:** **Medium** (`THREAT_MODEL.md` OR-4). W-2 dereferences a caller-supplied
`(ptr,len)`; a buggy/hostile JS worker could pass a bad pair. This is intrinsic to a C-ABI playground
shim and lies **outside the compiler TCB**. Hardening option (not yet applied): a sanity bound on
`len` before `from_raw_parts`. Documented as accepted for the playground context.

---

## C. `riina-core/src/...` — cryptographic library (4 sites)

`riina-core` is the most heavily-assured module in the repo (9 Coq formal-equivalence proofs, ACVP
KATs, structural + timing CT lanes). Its `unsafe` is narrow crypto-hygiene.

### C-1/C-2 `zeroize.rs:50, :88` — `ptr::write_volatile(_, 0)` + `compiler_fence(SeqCst)`
- **Contract:** valid, aligned, uniquely-borrowed (`&mut`) memory.
- **Invariant:** writes `0u8`/zero to memory reached through a live `&mut`. The volatile write +
  fence are the **security mechanism** (they stop the optimiser from eliding a secret-wipe), not a
  hazard. This is the textbook constant-folding-resistant zeroize.
- **Review:** ✔ sound and *intentional* — eliding it would be the bug.

### C-3 `hmac.rs:93` — `ManuallyDrop::take(&mut self.inner_hash)` in `finalize(self)`
- **Contract:** `ManuallyDrop::take` must be called at most once and the inner value must not be used
  or dropped afterwards.
- **Invariant:** `finalize` consumes `self` by value; `inner_hash` is taken **exactly once**; the
  `Drop` impl is written to zeroize *keys only*, never `inner_hash` (it is `ManuallyDrop`). No
  double-free, no use-after-take.
- **Review:** ✔ sound. The `Drop`/`ManuallyDrop` pairing is the load-bearing detail and is correct.

### C-4 `ed25519.rs:1082` — `&*(self.public_key.as_ptr() as *const Ed25519VerifyingKey)`
- **Contract:** the reinterpret-cast `&[u8;32] → &Ed25519VerifyingKey` is sound only if the target is
  layout-compatible.
- **Invariant:** **verified this session** — `Ed25519VerifyingKey` is declared
  `#[repr(transparent)]` over the 32-byte key, so it has identical layout to `[u8; 32]`. The cast is
  sound and the SAFETY comment's claim is *true* (not aspirational).
- **Review:** ✔ sound, repr verified.

**Module residual risk:** **Low.** All four are standard, narrowly-scoped patterns in the
most-audited crate. (The `overflow-checks = false` profile override for this crate is **not** an
`unsafe` block but is recorded in `THREAT_MODEL.md` §5 as a security-motivated, auditable decision.)

---

## D. Audit gate (how this log stays honest)

1. **A new `unsafe` site without an entry here should fail review.** This file is the registry; the
   §5 summary in `THREAT_MODEL.md` must agree with it.
2. The count is re-derived, not remembered:
   ```
   grep -rnE "unsafe (fn|\{|impl)" 03_PROTO/crates 05_TOOLING/crates --include="*.rs" \
     | grep -vE "forbid|deny|//|examples"
   ```
   (examples/ — e.g. `ctgrind_ct.rs` — are excluded: they are CT *measurement harnesses*, not shipped
   library code; their `unsafe` is the Valgrind client-request ABI.)
3. **External review (REQ-28/Gate G) supersedes this self-audit.** This log is audit *preparation*;
   it does not substitute for the independent crypto/compiler audit, which remains OPEN.
