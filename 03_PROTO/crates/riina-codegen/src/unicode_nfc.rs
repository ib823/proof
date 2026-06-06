// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Unicode Normalization Form C (NFC) — UAX #15.
//!
//! Canonical decomposition → canonical ordering → canonical composition, over
//! the vendored UCD tables in [`crate::unicode_nfc_data`] (Law 8: dependency-free,
//! no `unicode-normalization` crate). Hangul is handled algorithmically (UAX #15
//! §16), everything else by table lookup. Conformance is checked against a sample
//! of the official `NormalizationTest.txt` in the test module.
//!
//! NFC is the standard on-the-wire/identifier form; combined with the
//! `normalize_unicode` security stripper (bidi/zero-width) this gives RIINA a
//! defence against homograph/spoofing inputs that differ only by combining-mark
//! order or precomposed-vs-decomposed encoding.

use crate::unicode_nfc_data::{COMBINING_CLASS, COMPOSE, DECOMP_DATA, DECOMP_INDEX};

// Hangul (UAX #15 §16): syllables compose/decompose arithmetically.
const S_BASE: u32 = 0xAC00;
const L_BASE: u32 = 0x1100;
const V_BASE: u32 = 0x1161;
const T_BASE: u32 = 0x11A7;
const L_COUNT: u32 = 19;
const V_COUNT: u32 = 21;
const T_COUNT: u32 = 28;
const N_COUNT: u32 = V_COUNT * T_COUNT; // 588
const S_COUNT: u32 = L_COUNT * N_COUNT; // 11172

/// Canonical combining class of a code point (0 if not in the table).
fn ccc(cp: u32) -> u8 {
    COMBINING_CLASS
        .binary_search_by_key(&cp, |&(c, _)| c)
        .map_or(0, |i| COMBINING_CLASS[i].1)
}

/// Append the full canonical decomposition of `cp` to `out`.
fn decompose_char(cp: u32, out: &mut Vec<u32>) {
    if (S_BASE..S_BASE + S_COUNT).contains(&cp) {
        let si = cp - S_BASE;
        out.push(L_BASE + si / N_COUNT);
        out.push(V_BASE + (si % N_COUNT) / T_COUNT);
        let t = si % T_COUNT;
        if t != 0 {
            out.push(T_BASE + t);
        }
        return;
    }
    if let Ok(i) = DECOMP_INDEX.binary_search_by_key(&cp, |&(c, _, _)| c) {
        let (_, off, len) = DECOMP_INDEX[i];
        let (o, l) = (off as usize, len as usize);
        out.extend_from_slice(&DECOMP_DATA[o..o + l]);
        return;
    }
    out.push(cp);
}

/// In-place canonical ordering: stably sort each run of combining marks by
/// combining class (UAX #15 — adjacent transposition while the earlier class is
/// strictly greater and non-zero).
fn canonical_order(buf: &mut [u32]) {
    let n = buf.len();
    let mut i = 1;
    while i < n {
        let cc = ccc(buf[i]);
        if cc != 0 {
            let mut j = i;
            while j > 0 {
                let prev = ccc(buf[j - 1]);
                if prev == 0 || prev <= cc {
                    break;
                }
                buf.swap(j - 1, j);
                j -= 1;
            }
        }
        i += 1;
    }
}

/// Canonical composition of an ordered starter `a` with `b`, if defined.
fn compose_pair(a: u32, b: u32) -> Option<u32> {
    // Hangul L + V
    if (L_BASE..L_BASE + L_COUNT).contains(&a) && (V_BASE..V_BASE + V_COUNT).contains(&b) {
        let (li, vi) = (a - L_BASE, b - V_BASE);
        return Some(S_BASE + (li * V_COUNT + vi) * T_COUNT);
    }
    // Hangul LV + T
    if (S_BASE..S_BASE + S_COUNT).contains(&a)
        && (a - S_BASE).is_multiple_of(T_COUNT)
        && (T_BASE + 1..T_BASE + T_COUNT).contains(&b)
    {
        return Some(a + (b - T_BASE));
    }
    COMPOSE
        .binary_search_by(|&(x, y, _)| (x, y).cmp(&(a, b)))
        .map(|i| COMPOSE[i].2)
        .ok()
}

/// Normalize `s` to NFC.
pub fn nfc(s: &str) -> String {
    // 1. Canonical decomposition.
    let mut buf: Vec<u32> = Vec::with_capacity(s.len());
    for c in s.chars() {
        decompose_char(c as u32, &mut buf);
    }
    if buf.is_empty() {
        return String::new();
    }
    // 2. Canonical ordering.
    canonical_order(&mut buf);
    // 3. Canonical composition (UAX #15 reference; `-1` marks "immediately after
    //    the current starter", so the first following char is never blocked).
    let mut out: Vec<u32> = Vec::with_capacity(buf.len());
    out.push(buf[0]);
    let mut starter: Option<usize> = if ccc(buf[0]) == 0 { Some(0) } else { None };
    let mut prev_ccc: i32 = if ccc(buf[0]) == 0 {
        -1
    } else {
        i32::from(ccc(buf[0]))
    };
    for &cp in &buf[1..] {
        let cc = i32::from(ccc(cp));
        if let Some(si) = starter {
            if prev_ccc < cc {
                if let Some(composed) = compose_pair(out[si], cp) {
                    out[si] = composed;
                    continue; // `cp` absorbed; prev_ccc unchanged
                }
            }
        }
        if cc == 0 {
            starter = Some(out.len());
            prev_ccc = -1;
        } else {
            prev_ccc = cc;
        }
        out.push(cp);
    }
    out.iter()
        .map(|&c| char::from_u32(c).unwrap_or('\u{FFFD}'))
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Build a string from a space-separated hex code-point sequence.
    fn from_hex(seq: &str) -> String {
        seq.split_whitespace()
            .map(|h| char::from_u32(u32::from_str_radix(h, 16).unwrap()).unwrap())
            .collect()
    }

    #[test]
    fn famous_cases() {
        // Precomposed and decomposed "é" both normalize to U+00E9.
        assert_eq!(nfc("e\u{0301}"), "\u{00E9}");
        assert_eq!(nfc("\u{00E9}"), "\u{00E9}");
        // Combining marks are canonically reordered then recombined: a + ring
        // above (230) + dot below (220) — the dot reorders before the ring.
        assert_eq!(nfc("a\u{030A}\u{0323}"), nfc("a\u{0323}\u{030A}"));
        // Hangul: L + V + T compose into a single syllable, and back.
        assert_eq!(nfc("\u{1100}\u{1161}\u{11A8}"), "\u{AC01}");
        // ASCII and the empty string are fixed points.
        assert_eq!(nfc("hello"), "hello");
        assert_eq!(nfc(""), "");
    }

    #[test]
    fn idempotent() {
        for s in ["e\u{0301}", "\u{1100}\u{1161}\u{11A8}", "a\u{030A}\u{0323}b", "Ω"] {
            let once = nfc(s);
            assert_eq!(nfc(&once), once, "NFC must be idempotent on {s:?}");
        }
    }

    #[test]
    fn conformance_against_unicode_normalization_test() {
        // Each line `source;NFC` from the sampled official NormalizationTest.txt:
        // NFC(source) == NFC == NFC(NFC) (idempotence).
        let data = include_str!("../tests/fixtures/nfc_conformance.txt");
        let mut checked = 0usize;
        for line in data.lines() {
            let line = line.trim();
            if line.is_empty() || line.starts_with('#') {
                continue;
            }
            let (src, expect) = line.split_once(';').expect("source;NFC");
            let (source, expected) = (from_hex(src), from_hex(expect));
            let got = nfc(&source);
            assert_eq!(
                got, expected,
                "NFC({src}) = {:?} expected {:?}",
                got.chars().map(|c| format!("{:04X}", c as u32)).collect::<Vec<_>>(),
                expected.chars().map(|c| format!("{:04X}", c as u32)).collect::<Vec<_>>(),
            );
            // Stability: NFC of the expected form is itself.
            assert_eq!(nfc(&expected), expected, "NFC not stable on {expect}");
            checked += 1;
        }
        assert!(checked > 1000, "expected the conformance corpus to load, got {checked}");
    }
}
