// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! # Structural constant-time verification (ctgrind / valgrind secret-poisoning)
//!
//! This example proves a *necessary* condition for constant-time: that the
//! crypto primitives perform **no secret-dependent control flow and no
//! secret-dependent memory access**. Unlike the timing harness
//! (`examples/dudect_ct.rs`), this check is **deterministic and host-noise
//! immune** — it does not measure time, so a shared/virtualised CPU is fine.
//!
//! ## How it works (Adam Langley's "ctgrind" technique)
//!
//! Secret inputs are marked *undefined* to Valgrind's memcheck via a client
//! request. Memcheck then propagates "undefined" through every derived value and
//! **errors if an undefined (secret-derived) value reaches a conditional
//! branch or a memory address**. A constant-time routine never does either, so a
//! correct primitive yields **zero** memcheck errors; a secret-dependent branch
//! or table index is flagged precisely.
//!
//! Run it under Valgrind (see `scripts/ct-structural-check.sh`):
//! ```text
//! cargo build --release --example ctgrind_ct -p riina-core
//! valgrind --error-exitcode=1 ./target/release/examples/ctgrind_ct battery   # expect 0 errors
//! valgrind --error-exitcode=1 ./target/release/examples/ctgrind_ct positive  # expect detection
//! ```
//!
//! Scope: this covers the instruction-level secret-branch / secret-memory
//! channels. It does NOT cover data-memory-dependent-prefetcher (DMP/GoFetch)
//! leakage, nor pure data-independent-timing variation — the latter is the
//! `dudect_ct.rs` timing harness's job (which needs a controlled host).
//!
//! Dependency-free (Law 8): the Valgrind client request is issued with a small
//! `core::arch::asm!` sequence, not the `crabgrind`/`cc` crates.

use std::hint::black_box;

use riina_core::constant_time::ct_eq_bytes;
use riina_core::crypto::aes::Aes256;
use riina_core::crypto::ed25519::Ed25519SigningKey;
use riina_core::crypto::montgomery;

// ── Valgrind memcheck client requests (x86-64), dependency-free ──────────────
//
// The magic sequence (4× `rol` on rdi — a net 128-bit rotation, i.e. identity —
// followed by `xchg rbx,rbx`) is Valgrind's recognised no-op marker: outside
// Valgrind it does nothing, inside it triggers the client request whose argument
// block is pointed to by rax, returning a handle in rdx. Codes are
// `('M'<<24 | 'C'<<16) + n` from `valgrind/memcheck.h`.

const VG_MAKE_MEM_UNDEFINED: u64 = 0x4D43_0001;
const VG_MAKE_MEM_DEFINED: u64 = 0x4D43_0002;

/// Issue one memcheck client request. `unsafe`: raw inline asm. Justification —
/// this is the documented Valgrind client-request ABI; the instruction sequence
/// is a no-op on real silicon (identity rotation + self-`xchg`), touches no
/// memory except reading the local `args` block, and only communicates with the
/// Valgrind JIT when present. There is no safe wrapper without a third-party
/// crate (Law 8 forbids one).
#[cfg(target_arch = "x86_64")]
#[inline(never)]
unsafe fn vg_client_request(code: u64, addr: *const u8, len: usize) {
    let args: [u64; 6] = [code, addr as u64, len as u64, 0, 0, 0];
    core::arch::asm!(
        "rol rdi, 3",
        "rol rdi, 13",
        "rol rdi, 61",
        "rol rdi, 51",
        "xchg rbx, rbx",
        inout("rdx") 0u64 => _,   // %rdx: default in, client-request handle out (discarded)
        in("rax") args.as_ptr(),  // %rax: pointer to the request block
        inout("rdi") 0u64 => _,   // %rdi: rotated (net identity) by the magic preamble
        options(nostack),
    );
}

#[cfg(not(target_arch = "x86_64"))]
unsafe fn vg_client_request(_code: u64, _addr: *const u8, _len: usize) {}

/// Mark `buf` as secret (undefined) so any secret-dependent branch/address downstream is flagged.
fn poison(buf: &[u8]) {
    unsafe { vg_client_request(VG_MAKE_MEM_UNDEFINED, buf.as_ptr(), buf.len()) };
}
/// Mark `buf` as defined again (call on outputs before consuming them, so only the
/// primitive's *internal* behaviour is under test, not our use of its result).
fn unpoison(buf: &[u8]) {
    unsafe { vg_client_request(VG_MAKE_MEM_DEFINED, buf.as_ptr(), buf.len()) };
}

// ── The constant-time battery (must yield ZERO memcheck errors) ──────────────

/// AES-256: poison the key, run the full key schedule + block encrypt. Exercises
/// the `ct_lookup` masked S-box on secret bytes (no secret-indexed table load).
fn ct_aes() {
    let key = [0x4du8; 32];
    let mut block = [0x9eu8; 16];
    poison(&key);
    let cipher = Aes256::new(&key);
    cipher.encrypt_block(&mut block);
    unpoison(&block);
    black_box(&block);
}

/// X25519: poison the scalar, run the Montgomery ladder (cswap must be branchless).
fn ct_x25519() {
    let scalar = [0x37u8; 32];
    poison(&scalar);
    let out = montgomery::x25519_base(&scalar);
    unpoison(&out);
    black_box(&out);
}

/// Ed25519: poison the seed, run key derivation + sign (scalar `ct_select` path).
fn ct_ed25519() {
    let seed = [0x5au8; 32];
    let msg = b"riina ctgrind structural ct probe";
    poison(&seed);
    let sk = Ed25519SigningKey::from_seed(&seed);
    let sig = sk.sign(msg);
    unpoison(&sig);
    black_box(&sig);
}

/// `ct_eq_bytes`: poison one operand; the comparison must fold without branching.
fn ct_eq() {
    let a = [0x11u8; 32];
    let b = [0x11u8; 32];
    poison(&a);
    let eq = ct_eq_bytes(&a, &b);
    // The boolean result is secret-derived; consume it opaquely (never branch on it).
    black_box(eq);
}

fn battery() {
    ct_aes();
    ct_x25519();
    ct_ed25519();
    ct_eq();
    println!("ctgrind battery ran (AES key, X25519 scalar, Ed25519 seed, ct_eq) — \
              verdict = Valgrind error count (expect 0)");
}

/// Positive control: a genuine secret-dependent **memory index** that memcheck
/// MUST flag — validates the harness's detection power. (A secret-dependent
/// *branch* like `if s>128` is unreliable as a control: the optimiser lowers it
/// to a branchless `setg`, which is correctly NOT a leak.)
#[inline(never)]
fn positive_control() {
    // A table the optimiser cannot constant-fold (distinct values, made opaque),
    // so the secret-indexed load genuinely survives to the asm.
    let mut table = [0u32; 256];
    for i in 0u32..256 {
        table[i as usize] = i.wrapping_mul(2_654_435_761);
    }
    let table = black_box(table);
    let secret = black_box([200u8, 7, 7, 7]);
    poison(&secret);
    let idx = black_box(secret[0]) as usize;
    let leaked = black_box(&table)[idx];
    println!(
        "positive control ran (secret-indexed load) — Valgrind MUST report an error; got {}",
        black_box(leaked)
    );
}

/// Baseline: no crypto, no poison — measures incidental Valgrind noise (must be 0).
fn baseline() {
    let x = black_box(123u64);
    println!("baseline ran (no secret) — Valgrind must report 0 errors; {}", black_box(x));
}

fn main() {
    match std::env::args().nth(1).as_deref() {
        Some("positive") => positive_control(),
        Some("baseline") => baseline(),
        Some("aes") => ct_aes(),
        Some("x25519") => ct_x25519(),
        Some("ed25519") => ct_ed25519(),
        Some("cteq") => ct_eq(),
        _ => battery(),
    }
}
