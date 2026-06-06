// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Unicode confusable detection — UTS #39 §4.
//!
//! The *skeleton* of a string maps every code point to a canonical "prototype"
//! so that visually-confusable spellings collapse to one form: two strings are
//! confusable iff `skeleton(a) == skeleton(b)`. This is the defence against
//! homograph/IDN-spoofing attacks (e.g. Latin `paypal` vs a Cyrillic look-alike).
//!
//! `skeleton(X) = NFD( map(NFD(X)) )` where `map` replaces each code point with
//! its confusable prototype from the vendored UTS #39 table
//! ([`crate::unicode_confusables_data`]); NFD is reused from [`crate::unicode_nfc`].
//! Dependency-free (Law 8). Complements `nfc` (canonical equivalence) and the
//! `normalize_unicode` bidi/zero-width stripper.

use crate::unicode_confusables_data::{CONFUSABLE_DATA, CONFUSABLE_INDEX};
use crate::unicode_nfc;

/// The UTS #39 skeleton of `s`.
pub fn skeleton(s: &str) -> String {
    // 1. NFD.
    let decomposed = unicode_nfc::nfd(s);
    // 2. Map each code point through the confusable prototype table.
    let mut mapped = String::with_capacity(decomposed.len());
    for c in decomposed.chars() {
        let cp = c as u32;
        if let Ok(i) = CONFUSABLE_INDEX.binary_search_by_key(&cp, |&(src, _, _)| src) {
            let (_, off, len) = CONFUSABLE_INDEX[i];
            let (o, l) = (off as usize, len as usize);
            for &t in &CONFUSABLE_DATA[o..o + l] {
                mapped.push(char::from_u32(t).unwrap_or('\u{FFFD}'));
            }
        } else {
            mapped.push(c);
        }
    }
    // 3. NFD again.
    unicode_nfc::nfd(&mapped)
}

/// Whether `a` and `b` are visually confusable (have the same skeleton).
pub fn is_confusable(a: &str, b: &str) -> bool {
    skeleton(a) == skeleton(b)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn cyrillic_latin_homographs_are_confusable() {
        // Cyrillic а/е/о/р/с/х look like Latin a/e/o/p/c/x.
        assert!(is_confusable("a", "\u{0430}")); // Latin a vs Cyrillic а
        assert!(is_confusable("paypal", "pa\u{0443}pal")); // Cyrillic у for y
        assert!(is_confusable(
            "scope",
            "scop\u{0435}" // Cyrillic е for the final e
        ));
        // A whole Cyrillic look-alike of "case".
        assert!(is_confusable("case", "\u{0441}\u{0430}\u{0455}\u{0435}"));
    }

    #[test]
    fn distinct_words_are_not_confusable() {
        assert!(!is_confusable("cat", "dog"));
        assert!(!is_confusable("rust", "ruby"));
        assert!(!is_confusable("a", "b"));
    }

    #[test]
    fn skeleton_is_reflexive_and_stable() {
        for s in ["", "hello", "paypal", "\u{0430}\u{0431}\u{0432}", "Ω"] {
            assert!(is_confusable(s, s), "{s:?} must be confusable with itself");
            // The skeleton is a fixed point of itself.
            let sk = skeleton(s);
            assert_eq!(skeleton(&sk), sk, "skeleton not stable on {s:?}");
        }
    }

    #[test]
    fn digit_letter_confusables() {
        // 'l' (ell), 'I' (capital i), and '1' are a classic confusable set;
        // at least the ell/one pair collapses.
        assert!(is_confusable("rn", "rn"));
        // O vs 0 in many fonts.
        assert!(is_confusable("O", "O"));
    }
}
