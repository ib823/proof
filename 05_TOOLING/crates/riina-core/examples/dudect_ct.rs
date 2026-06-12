// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! `dudect_ct` — a dependency-free, dudect-style constant-time leakage probe.
//!
//! # What this is
//!
//! A black-box timing-leakage harness over `riina-core`'s secret-dependent
//! crypto operations, following the methodology of Reparaz, Balasch & Verbauwhede
//! ("Dude, is my code constant time?", DATE 2017): for each primitive it times the
//! operation under two input classes — **class 0** (a *fixed* secret) and **class 1**
//! (a *random* secret per sample) — with public inputs identical, then applies
//! **Welch's t-test** (with high-tail cropping to discard scheduler/steal-time
//! outliers). |t| > 4.5 ⇒ the timing distribution depends on the secret ⇒ a leak;
//! small |t| ⇒ no leak detected *at this measurement's statistical power*.
//!
//! It is **dependency-free** (Law 8): a small xorshift PRNG and a hand-rolled
//! t-test, no `dudect`/`criterion`/`rand` crates. It is an **example**, not a
//! `#[test]`, so it never runs as part of `cargo test` (timing in CI is noise) and
//! does not change the test count — run it explicitly, pinned to a core:
//!
//! ```text
//! taskset -c 0 cargo run --release --example dudect_ct -p riina-core
//! taskset -c 0 cargo run --release --example dudect_ct -p riina-core -- ed25519 8
//! #                                                          ^primitive ^scale
//! ```
//!
//! # Honest scope — read before trusting a result
//!
//! A **positive control** (`POSCTRL_leaky_eq`) — a deliberately non-constant-time
//! byte compare with an early return — is always run first. If the harness flags it
//! (|t| ≫ 4.5) it has demonstrated detection power *in the current environment*.
//!
//! - A **LEAK** verdict on a real primitive is a genuine red flag — investigate.
//! - A **no-leak** verdict bounds the leak to *below this host's noise floor*. On a
//!   shared/virtualized host (the RIINA dev container is Docker on a KVM vCPU:
//!   invariant TSC + `taskset` pinning available, but hypervisor steal-time and
//!   neighbour contention are not controllable) that floor is well above bare metal,
//!   so a no-leak result here is **indicative, not an audit-grade certification**.
//!   For REQ-28 (the external crypto audit) re-run on a controlled bare-metal host
//!   (`isolcpus`, `nohz_full`, fixed frequency, `perf`-grade clock).
//!
//! The RIINA crypto is constant-time *by construction* (branchless selects, no
//! secret-dependent branches — verified by source inspection in the pre-audit); this
//! harness is the empirical cross-check and a regression guard against reintroducing
//! a secret-dependent branch (the class of defect the Ed25519/ML-KEM passes removed).

// This is a measurement tool, not library code; mirror the crate's crypto-pragmatic
// lint posture (the package `[lints]` table applies clippy::pedantic to examples too).
#![allow(clippy::cast_precision_loss)]
#![allow(clippy::cast_possible_truncation)]
#![allow(clippy::cast_sign_loss)]
#![allow(clippy::cast_lossless)]
#![allow(clippy::doc_markdown)]
#![allow(clippy::too_many_lines)]
#![allow(clippy::missing_panics_doc)]

use std::hint::black_box;
use std::time::Instant;

use riina_core::constant_time::ct_eq_bytes;
use riina_core::crypto::aes::Aes256;
use riina_core::crypto::ed25519::Ed25519SigningKey;
use riina_core::crypto::gcm::Aes256Gcm;
use riina_core::crypto::ml_kem::MlKem768KeyPair;
use riina_core::crypto::x25519::X25519KeyPair;

/// Leak-detection threshold for |t| (dudect's conventional value: extremely high
/// confidence, ~5 sigma — chosen to tolerate the multiple primitives tested).
const T_THRESHOLD: f64 = 4.5;

/// Fraction of the slowest samples cropped from each class before the t-test.
/// On a virtualized host the high tail is dominated by hypervisor preemption /
/// steal time, which is secret-independent noise; cropping it sharpens the test.
const CROP_TOP: f64 = 0.10;

// ---------------------------------------------------------------------------
// Dependency-free deterministic PRNG (xorshift64*) — reproducible, Law-8 clean.
// ---------------------------------------------------------------------------

struct XorShift64(u64);

impl XorShift64 {
    fn new(seed: u64) -> Self {
        // Avoid the all-zero fixed point.
        Self(seed ^ 0x9E37_79B9_7F4A_7C15 | 1)
    }

    fn next_u64(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x.wrapping_mul(0x2545_F491_4F6C_DD1D)
    }

    fn fill(&mut self, buf: &mut [u8]) {
        let mut i = 0;
        while i < buf.len() {
            let r = self.next_u64().to_le_bytes();
            let n = (buf.len() - i).min(8);
            buf[i..i + n].copy_from_slice(&r[..n]);
            i += n;
        }
    }

    fn bit(&mut self) -> u8 {
        (self.next_u64() & 1) as u8
    }
}

// ---------------------------------------------------------------------------
// Welch's t-test with high-tail cropping.
// ---------------------------------------------------------------------------

fn mean_var(xs: &[f64]) -> (f64, f64) {
    let n = xs.len() as f64;
    let mean = xs.iter().sum::<f64>() / n;
    let var = xs.iter().map(|x| (x - mean) * (x - mean)).sum::<f64>() / (n - 1.0);
    (mean, var)
}

/// Sort ascending and drop the slowest `CROP_TOP` fraction (preemption outliers).
fn crop_top(xs: &mut Vec<f64>) {
    xs.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let keep = ((xs.len() as f64) * (1.0 - CROP_TOP)) as usize;
    xs.truncate(keep.max(2));
}

/// Welch's t-statistic for the two cropped classes. Returns (|t|, n0, n1).
fn welch_t(mut c0: Vec<f64>, mut c1: Vec<f64>) -> (f64, usize, usize) {
    crop_top(&mut c0);
    crop_top(&mut c1);
    let (m0, v0) = mean_var(&c0);
    let (m1, v1) = mean_var(&c1);
    let n0 = c0.len();
    let n1 = c1.len();
    let denom = (v0 / n0 as f64 + v1 / n1 as f64).sqrt();
    let t = if denom == 0.0 {
        0.0
    } else {
        (m1 - m0) / denom
    };
    (t.abs(), n0, n1)
}

// ---------------------------------------------------------------------------
// Probe driver.
// ---------------------------------------------------------------------------

/// Run one leakage probe.
///
/// `sample(class, rng)` performs any per-sample *untimed* setup for the given
/// secret class, then times exactly the operation under test and returns the
/// elapsed nanoseconds. The driver interleaves the two classes (so slow drift
/// affects both equally) and reports the verdict.
fn probe<F>(name: &str, n_samples: usize, mut sample: F)
where
    F: FnMut(u8, &mut XorShift64) -> f64,
{
    // Per-primitive deterministic seed (name-derived) for reproducibility.
    let seed = name.bytes().fold(0xC0FF_EE00_u64, |a, b| {
        a.wrapping_mul(31).wrapping_add(u64::from(b))
    });
    let mut rng = XorShift64::new(seed);

    // Warm up caches / branch predictors / frequency before measuring.
    for _ in 0..2_000 {
        black_box(sample(0, &mut rng));
        black_box(sample(1, &mut rng));
    }

    let mut c0 = Vec::with_capacity(n_samples / 2 + 1);
    let mut c1 = Vec::with_capacity(n_samples / 2 + 1);
    for _ in 0..n_samples {
        let class = rng.bit();
        let t = sample(class, &mut rng);
        if class == 0 {
            c0.push(t);
        } else {
            c1.push(t);
        }
    }

    let (t, n0, n1) = welch_t(c0, c1);
    let verdict = if t > T_THRESHOLD {
        "FLAGGED (|t| > 4.5 — investigate: real leak vs host artifact)"
    } else {
        "no leak detected (within this host's power)"
    };
    println!("  {name:<26} |t| = {t:8.2}   [n0={n0} n1={n1}]   {verdict}");
}

// ---------------------------------------------------------------------------
// Per-primitive samplers. Setup (key schedule / keygen) is OUTSIDE the timed
// region; only the operation under test is timed.
// ---------------------------------------------------------------------------

const FIXED_KEY: [u8; 32] = [0x42; 32];
const FIXED_SEED: [u8; 32] = [0x24; 32];

/// Build a 32-byte secret for the given class, doing the **same untimed work**
/// for both classes (always draw randomness) so the two only differ in the secret
/// *bytes*, not in the cache/predictor state entering the timed region. This is
/// the canonical dudect discipline that avoids the "fixed input is cache-hot"
/// artifact — without it, a perfectly constant-time op can show a spurious t.
fn pick32(class: u8, rng: &mut XorShift64, fixed: &[u8; 32]) -> [u8; 32] {
    let mut s = [0u8; 32];
    rng.fill(&mut s); // always (symmetric pre-timing work)
    if class == 0 {
        s = *fixed;
    }
    s
}

/// AES-256 `encrypt_block` — exercises the S-box `ct_lookup`. Secret = key.
fn sample_aes(class: u8, rng: &mut XorShift64, batch: usize) -> f64 {
    let key = pick32(class, rng, &FIXED_KEY);
    let aes = Aes256::new(&key); // key schedule: untimed
    let mut block = [0x55u8; 16];
    let start = Instant::now();
    for _ in 0..batch {
        aes.encrypt_block(black_box(&mut block));
        black_box(&block);
    }
    start.elapsed().as_nanos() as f64
}

/// AES-256-GCM `encrypt` of a fixed 64-byte plaintext — exercises GHASH
/// `gf128_mul` (with secret H) + AES. Secret = key.
fn sample_gcm(class: u8, rng: &mut XorShift64, batch: usize) -> f64 {
    let key = pick32(class, rng, &FIXED_KEY);
    let gcm = Aes256Gcm::new(&key); // untimed
    let nonce = [0x07u8; 12];
    let pt = [0xA5u8; 64];
    let mut out = [0u8; 64 + 16];
    let start = Instant::now();
    for _ in 0..batch {
        let _ = gcm.encrypt(&nonce, &[], black_box(&pt), black_box(&mut out));
        black_box(&out);
    }
    start.elapsed().as_nanos() as f64
}

/// Ed25519 `sign` — exercises `scalar_mul`/`ct_select` on the secret scalar
/// (the path of the fixed key-bit timing leak). Secret = seed.
fn sample_ed25519(class: u8, rng: &mut XorShift64) -> f64 {
    let seed = pick32(class, rng, &FIXED_SEED);
    let sk = Ed25519SigningKey::from_seed(&seed); // untimed
    let msg = [0x6Du8; 32];
    let start = Instant::now();
    let sig = sk.sign(black_box(&msg));
    let dt = start.elapsed().as_nanos() as f64;
    black_box(sig);
    dt
}

/// X25519 `diffie_hellman` — exercises the Montgomery ladder `conditional_swap`
/// on the secret scalar. Secret = own private key.
fn sample_x25519(class: u8, rng: &mut XorShift64, peer_pk: &[u8; 32]) -> f64 {
    let sk = pick32(class, rng, &FIXED_SEED);
    let kp = X25519KeyPair::generate(&sk); // clamping: untimed
    let start = Instant::now();
    let shared = kp.diffie_hellman(black_box(peer_pk));
    let dt = start.elapsed().as_nanos() as f64;
    black_box(shared.ok());
    dt
}

/// `constant_time::ct_eq_bytes` of a fixed 32-byte secret against an equal
/// (class 0) vs first-byte-differing (class 1) array. A non-CT compare would be
/// faster for class 1 (early mismatch); ct_eq scans all bytes either way.
fn sample_ct_eq(class: u8, _rng: &mut XorShift64, batch: usize) -> f64 {
    let secret = FIXED_KEY;
    let mut other = secret;
    if class == 1 {
        other[0] ^= 0xFF; // earliest possible mismatch
    }
    let start = Instant::now();
    for _ in 0..batch {
        black_box(ct_eq_bytes(black_box(&secret), black_box(&other)));
    }
    start.elapsed().as_nanos() as f64
}

/// POSITIVE CONTROL: a deliberately leaky early-return compare. Class 1 (mismatch
/// at byte 0) must return far faster than class 0 (full scan). If this does NOT
/// flag, the harness lacks power in the current environment — distrust no-leak
/// verdicts above.
fn leaky_eq(a: &[u8], b: &[u8]) -> bool {
    for i in 0..a.len() {
        if a[i] != b[i] {
            return false; // early exit ⇒ secret-dependent timing
        }
    }
    true
}

fn sample_posctrl(class: u8, _rng: &mut XorShift64, batch: usize) -> f64 {
    let secret = FIXED_KEY;
    let mut other = secret;
    if class == 1 {
        other[0] ^= 0xFF;
    }
    let start = Instant::now();
    for _ in 0..batch {
        black_box(leaky_eq(black_box(&secret), black_box(&other)));
    }
    start.elapsed().as_nanos() as f64
}

/// ML-KEM-768 `decapsulate` — exercises the constant-time reductions and the
/// implicit-rejection select. Secret = decapsulation key. Class 1 draws from a
/// pre-generated pool of random keypairs (keygen is far too costly to time per
/// sample); each entry carries a *valid* ciphertext so decaps takes the accept
/// path, isolating any key-bit dependence.
fn sample_mlkem(class: u8, rng: &mut XorShift64) -> f64 {
    // Symmetric setup: BOTH classes run keygen+encaps into the same locals each
    // sample (untimed), so the timed decaps starts from an equivalent cache state
    // and only the secret-key bytes differ. A pre-generated random *pool* would
    // make class 1 cache-cold vs class 0's hot fixed key — a footprint artifact,
    // not a key-bit leak.
    let mut seed = [0u8; 64];
    rng.fill(&mut seed);
    if class == 0 {
        seed = [0x5A; 64];
    }
    let kp = MlKem768KeyPair::generate(&seed).expect("keygen");
    let enc: [u8; 32] = seed[..32].try_into().unwrap(); // deterministic per seed
    let (ct, _) = kp.encapsulate(&enc).expect("encaps");
    let start = Instant::now();
    let ss = kp.decapsulate(black_box(&ct));
    let dt = start.elapsed().as_nanos() as f64;
    black_box(ss.ok());
    dt
}

// ---------------------------------------------------------------------------
// main
// ---------------------------------------------------------------------------

fn main() {
    // argv: [primitive-filter] [scale]   (filter = "all" or a substring; scale ≥ 1)
    let args: Vec<String> = std::env::args().collect();
    let filter = args.get(1).cloned().unwrap_or_else(|| "all".to_string());
    let scale: usize = args.get(2).and_then(|s| s.parse().ok()).unwrap_or(1).max(1);
    let want = |name: &str| filter == "all" || name.contains(&filter);

    println!("RIINA dudect-style constant-time probe (dependency-free)");
    println!("  threshold |t| > {T_THRESHOLD}  ·  crop top {:.0}%  ·  scale ×{scale}", CROP_TOP * 100.0);
    println!("  NOTE: in-container measurements are INDICATIVE, not audit-grade (see file header).");
    println!("  Pin a core: `taskset -c 0 cargo run --release --example dudect_ct -p riina-core`\n");

    // Positive control first — establishes detection power in THIS environment.
    if want("posctrl") || want("control") {
        println!("[positive control — MUST flag a leak]");
        probe("POSCTRL_leaky_eq_32", 60_000 * scale, |c, r| sample_posctrl(c, r, 512));
        println!();
    }

    println!("[crypto primitives — should NOT leak]");
    if want("ct_eq") {
        probe("ct_eq_bytes_32", 60_000 * scale, |c, r| sample_ct_eq(c, r, 512));
    }
    if want("aes") {
        probe("aes256_encrypt_block", 60_000 * scale, |c, r| sample_aes(c, r, 128));
    }
    if want("gcm") {
        probe("aes256gcm_encrypt_64b", 40_000 * scale, |c, r| sample_gcm(c, r, 64));
    }
    if want("ed25519") {
        probe("ed25519_sign", 8_000 * scale, sample_ed25519);
    }
    if want("x25519") {
        // A fixed, valid peer public key.
        let peer = *X25519KeyPair::generate(&[0x09u8; 32]).public_key();
        probe("x25519_diffie_hellman", 8_000 * scale, |c, r| sample_x25519(c, r, &peer));
    }
    if want("mlkem") || want("ml_kem") {
        eprintln!("  (ml-kem: keygen+encaps per sample makes this the slowest probe ...)");
        probe("mlkem768_decapsulate", 4_000 * scale, sample_mlkem);
    }

    println!("\nInterpretation: POSCTRL must be FLAGGED with a huge |t| (detection-power check).");
    println!("A primitive FLAGGED with only a small |t| (single/low-double digits) on this shared");
    println!("vCPU is most likely a fixed-vs-random microarchitectural artifact — confirm by source");
    println!("inspection (no secret-dependent branch/table) then re-run on a controlled host.");
    println!("A clean run here is INDICATIVE only; certify on a controlled host for REQ-28.");
}
