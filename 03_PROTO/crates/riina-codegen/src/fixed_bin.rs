// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Binary fixed-point — Q-format (`qmn` / `binary_fixed`).
//!
//! A value is `raw / 2^frac_bits` where `raw` is a *bounded* signed machine
//! integer (`i64`) — the representation used in embedded/DSP/graphics code
//! (`Q16.16`, `Q8.8`, …). Unlike `wang`/`perpuluhan` the scale is a power of
//! *two*, so binary fractions (`0.5`, `0.25`, `0.75`) are exact while a decimal
//! like `0.1` becomes the nearest representable value (`0.1015625` at 8 bits).
//! Because `raw` is a machine word, arithmetic **wraps on overflow** — that is
//! the deliberate trade-off versus the arbitrary-precision money types.
//!
//! Construction and display use the proven [`crate::bigint::BigInt`] for an
//! *exact* decimal↔binary conversion (rounding half-to-even to the nearest
//! representable `raw`); arithmetic is done exactly in `BigInt` then wrapped back
//! into the `i64` word. `frac_bits` is restricted to `1..=32`.
//!
//! Dependency-free (Law 8). Interpreter slice; C/WASM codegen + a Coq model are
//! documented follow-ups (mirroring how the other numeric-tower types staged).

use crate::bigint::BigInt;
use std::cmp::Ordering;

/// Maximum supported fractional bits (Q*.32). Keeps `2^frac_bits` and the
/// alignment shifts comfortably bounded.
pub const MAX_FRAC_BITS: u32 = 32;

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct FixedBin {
    raw: i64,
    frac_bits: u32,
}

impl FixedBin {
    pub fn frac_bits(&self) -> u32 {
        self.frac_bits
    }

    pub fn is_zero(&self) -> bool {
        self.raw == 0
    }

    pub fn raw(&self) -> i64 {
        self.raw
    }

    // ── BigInt helpers (exact intermediates) ──

    /// `2^bits` as a BigInt (any `bits`).
    fn two_pow(bits: u32) -> BigInt {
        if bits < 63 {
            BigInt::from_u64(1u64 << bits)
        } else {
            let mut r = BigInt::from_u64(1u64 << 62);
            for _ in 62..bits {
                r = r.mul(&BigInt::from_u64(2));
            }
            r
        }
    }

    /// `5^n` as a BigInt.
    fn five_pow(n: u32) -> BigInt {
        let mut r = BigInt::from_u64(1);
        let five = BigInt::from_u64(5);
        for _ in 0..n {
            r = r.mul(&five);
        }
        r
    }

    fn abs(b: &BigInt) -> BigInt {
        if b.is_negative() {
            b.neg()
        } else {
            b.clone()
        }
    }

    /// `num / denom` rounded half-to-even (`denom` nonzero).
    fn round_quotient(num: &BigInt, denom: &BigInt) -> BigInt {
        let (q, r) = num.divmod(denom).expect("round_quotient: denom is nonzero");
        let two_abs_r = Self::abs(&r).mul(&BigInt::from_u64(2));
        let abs_denom = Self::abs(denom);
        let result_neg = num.is_negative() ^ denom.is_negative();
        let bump = |q: &BigInt| {
            let one = BigInt::from_u64(1);
            if result_neg {
                q.sub(&one)
            } else {
                q.add(&one)
            }
        };
        match two_abs_r.cmp(&abs_denom) {
            Ordering::Less => q,
            Ordering::Greater => bump(&q),
            Ordering::Equal => {
                let (_, parity) = q.divmod(&BigInt::from_u64(2)).expect("2 is nonzero");
                if parity.is_zero() {
                    q
                } else {
                    bump(&q)
                }
            }
        }
    }

    /// Reduce a BigInt into an `i64` word, wrapping modulo 2^64 (two's
    /// complement) — models machine-integer overflow.
    fn to_i64_wrapping(b: &BigInt) -> i64 {
        let modulus = Self::two_pow(64);
        let (_, r) = b.divmod(&modulus).expect("2^64 is nonzero");
        let r = if r.is_negative() { r.add(&modulus) } else { r };
        let u = r.to_decimal_string().parse::<u128>().unwrap_or(0) as u64;
        u as i64
    }

    /// Parse a decimal literal into `(mantissa, scale)` with `value =
    /// mantissa / 10^scale` (same grammar as the decimal types).
    fn parse_decimal_parts(s: &str) -> Option<(BigInt, u32)> {
        let s = s.trim();
        if s.is_empty() {
            return None;
        }
        let (sign, rest) = match s.as_bytes()[0] {
            b'-' => ("-", &s[1..]),
            b'+' => ("", &s[1..]),
            _ => ("", s),
        };
        if rest.is_empty() {
            return None;
        }
        let (int_part, frac_part) = match rest.split_once('.') {
            Some((i, f)) => (i, f),
            None => (rest, ""),
        };
        if int_part.is_empty() && frac_part.is_empty() {
            return None;
        }
        let digits = format!("{int_part}{frac_part}");
        if digits.is_empty() || !digits.bytes().all(|b| b.is_ascii_digit()) {
            return None;
        }
        let mantissa = BigInt::from_decimal_str(&format!("{sign}{digits}"))?;
        Some((mantissa, frac_part.len() as u32))
    }

    /// Construct from a decimal literal at `frac_bits` fractional bits, rounding
    /// half-to-even to the nearest representable value. `frac_bits` must be in
    /// `1..=MAX_FRAC_BITS`. Returns `None` on malformed input or bad `frac_bits`.
    pub fn parse(s: &str, frac_bits: u32) -> Option<Self> {
        if frac_bits == 0 || frac_bits > MAX_FRAC_BITS {
            return None;
        }
        let (mantissa, scale) = Self::parse_decimal_parts(s)?;
        // raw = round(value · 2^frac_bits) = round(mantissa · 2^frac_bits / 10^scale)
        let num = mantissa.mul(&Self::two_pow(frac_bits));
        let denom = BigInt::pow10(scale);
        let raw_big = Self::round_quotient(&num, &denom);
        Some(FixedBin {
            raw: Self::to_i64_wrapping(&raw_big),
            frac_bits,
        })
    }

    /// Render the exact decimal value (`raw / 2^frac_bits = raw·5^fb / 10^fb`),
    /// stripping trailing zeros (`0.5`, not `0.50000000`).
    pub fn to_string_repr(&self) -> String {
        if self.raw == 0 {
            return "0".to_string();
        }
        // numerator = raw · 5^frac_bits (exact); value = numerator / 10^frac_bits.
        let num = BigInt::from_i64(self.raw).mul(&Self::five_pow(self.frac_bits));
        Self::render_stripped(&num, self.frac_bits)
    }

    /// Render `num / 10^scale` in base 10 with trailing zeros stripped.
    fn render_stripped(num: &BigInt, scale: u32) -> String {
        // Strip trailing zero fractional digits by dividing out factors of 10.
        let ten = BigInt::from_u64(10);
        let mut m = num.clone();
        let mut scale = scale;
        while scale > 0 {
            let (q, r) = m.divmod(&ten).expect("10 is nonzero");
            if !r.is_zero() {
                break;
            }
            m = q;
            scale -= 1;
        }
        if scale == 0 {
            return m.to_decimal_string();
        }
        let neg = m.is_negative();
        let mag = if neg {
            m.neg().to_decimal_string()
        } else {
            m.to_decimal_string()
        };
        let scale = scale as usize;
        let s = if mag.len() <= scale {
            let zeros = "0".repeat(scale - mag.len());
            format!("0.{zeros}{mag}")
        } else {
            let point = mag.len() - scale;
            format!("{}.{}", &mag[..point], &mag[point..])
        };
        if neg {
            format!("-{s}")
        } else {
            s
        }
    }

    /// `raw` re-expressed at `target` fractional bits (exact, `target >= fb`).
    fn aligned_raw(&self, target: u32) -> BigInt {
        BigInt::from_i64(self.raw).mul(&Self::two_pow(target - self.frac_bits))
    }

    // ── arithmetic (exact in BigInt, wrapped into the i64 word) ──

    pub fn add(&self, other: &FixedBin) -> FixedBin {
        let fb = self.frac_bits.max(other.frac_bits);
        let r = self.aligned_raw(fb).add(&other.aligned_raw(fb));
        FixedBin {
            raw: Self::to_i64_wrapping(&r),
            frac_bits: fb,
        }
    }

    pub fn sub(&self, other: &FixedBin) -> FixedBin {
        let fb = self.frac_bits.max(other.frac_bits);
        let r = self.aligned_raw(fb).sub(&other.aligned_raw(fb));
        FixedBin {
            raw: Self::to_i64_wrapping(&r),
            frac_bits: fb,
        }
    }

    pub fn mul(&self, other: &FixedBin) -> FixedBin {
        let fb = self.frac_bits.max(other.frac_bits);
        // (a/2^fb)·(b/2^fb) at scale fb ⇒ round(a·b / 2^fb).
        let product = self.aligned_raw(fb).mul(&other.aligned_raw(fb));
        let r = Self::round_quotient(&product, &Self::two_pow(fb));
        FixedBin {
            raw: Self::to_i64_wrapping(&r),
            frac_bits: fb,
        }
    }

    pub fn div(&self, other: &FixedBin) -> Option<FixedBin> {
        if other.raw == 0 {
            return None;
        }
        let fb = self.frac_bits.max(other.frac_bits);
        // (a/2^fb)/(b/2^fb) at scale fb ⇒ round(a·2^fb / b).
        let num = self.aligned_raw(fb).mul(&Self::two_pow(fb));
        let r = Self::round_quotient(&num, &other.aligned_raw(fb));
        Some(FixedBin {
            raw: Self::to_i64_wrapping(&r),
            frac_bits: fb,
        })
    }

    pub fn neg(&self) -> FixedBin {
        FixedBin {
            raw: self.raw.wrapping_neg(),
            frac_bits: self.frac_bits,
        }
    }

    /// Value-based comparison (aligns the binary scales first).
    pub fn compare(&self, other: &FixedBin) -> Ordering {
        let fb = self.frac_bits.max(other.frac_bits);
        self.aligned_raw(fb).cmp(&other.aligned_raw(fb))
    }
}

impl std::fmt::Display for FixedBin {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.to_string_repr())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn q(s: &str, fb: u32) -> FixedBin {
        FixedBin::parse(s, fb).unwrap()
    }

    #[test]
    fn binary_fractions_are_exact() {
        // Powers of two and their sums are represented exactly.
        assert_eq!(q("0.5", 8).to_string_repr(), "0.5");
        assert_eq!(q("0.25", 8).to_string_repr(), "0.25");
        assert_eq!(q("0.75", 8).to_string_repr(), "0.75");
        assert_eq!(q("3.140625", 8).to_string_repr(), "3.140625"); // 804/256
        assert_eq!(q("-2.5", 16).to_string_repr(), "-2.5");
        assert_eq!(q("0", 16).to_string_repr(), "0");
        assert_eq!(q("100", 8).to_string_repr(), "100");
    }

    #[test]
    fn raw_is_value_times_two_pow_fracbits() {
        assert_eq!(q("0.5", 8).raw(), 128); // 0.5 * 256
        assert_eq!(q("1", 16).raw(), 65536);
        assert_eq!(q("0.25", 4).raw(), 4); // 0.25 * 16
    }

    #[test]
    fn decimal_tenth_rounds_to_nearest_representable() {
        // 0.1 is not a binary fraction: 0.1 * 256 = 25.6 → 26 → 26/256 = 0.1015625.
        let a = q("0.1", 8);
        assert_eq!(a.raw(), 26);
        assert_eq!(a.to_string_repr(), "0.1015625");
        // Half-to-even at the bit boundary: 0.03125 · 2^4 = 0.5 → 0 (even).
        assert_eq!(q("0.03125", 4).raw(), 0);
        // 0.09375 · 2^4 = 1.5 → 2 (even).
        assert_eq!(q("0.09375", 4).raw(), 2);
    }

    #[test]
    fn parse_rejects_bad_fracbits_and_garbage() {
        assert!(FixedBin::parse("1.5", 0).is_none());
        assert!(FixedBin::parse("1.5", MAX_FRAC_BITS + 1).is_none());
        for s in ["", "-", "1.2.3", "abc", "."] {
            assert!(FixedBin::parse(s, 8).is_none(), "must reject {s:?}");
        }
    }

    #[test]
    fn arithmetic_is_exact_for_binary_values() {
        // 0.5 + 0.25 = 0.75 exactly.
        assert_eq!(q("0.5", 8).add(&q("0.25", 8)).to_string_repr(), "0.75");
        // 1.5 * 1.5 = 2.25 exactly (Q8.8).
        assert_eq!(q("1.5", 8).mul(&q("1.5", 8)).to_string_repr(), "2.25");
        // 3.0 / 2.0 = 1.5 exactly.
        assert_eq!(q("3", 8).div(&q("2", 8)).unwrap().to_string_repr(), "1.5");
        // Subtraction and sign.
        assert_eq!(q("0.25", 8).sub(&q("1", 8)).to_string_repr(), "-0.75");
        // Mixed fractional bits align to the larger.
        assert_eq!(q("0.5", 4).add(&q("0.25", 8)).to_string_repr(), "0.75");
        // Division by zero is None.
        assert!(q("1", 8).div(&q("0", 8)).is_none());
    }

    #[test]
    fn compare_is_value_based_across_scales() {
        assert_eq!(q("0.5", 4).compare(&q("0.5", 16)), Ordering::Equal);
        assert_eq!(q("0.25", 8).compare(&q("0.5", 8)), Ordering::Less);
        assert_eq!(q("-1", 8).compare(&q("0", 8)), Ordering::Less);
        assert_eq!(q("2.5", 8).compare(&q("2.5", 8)), Ordering::Equal);
    }

    #[test]
    fn multiplication_wraps_on_overflow() {
        // Q1.32 with a large integer part overflows the i64 word on multiply,
        // wrapping rather than panicking (the documented machine-int trade-off).
        let big = q("1000000", 32); // raw = 10^6 * 2^32 ≈ 4.3e15 (fits i64)
        let _ = big.mul(&big); // raw·raw / 2^32 ≈ 4.3e15 — wraps; must not panic.
        // A clearly-overflowing case still yields *some* defined i64 value.
        let r = big.mul(&big);
        assert_eq!(r.frac_bits(), 32);
    }
}
