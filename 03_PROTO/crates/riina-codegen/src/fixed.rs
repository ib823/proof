// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Fixed-scale decimal (`wang` — Malay for "money" — and `titik_tetap`,
//! "fixed point").
//!
//! Like [`crate::decimal::Decimal`] a value is `mantissa * 10^(-scale)` over the
//! proven [`crate::bigint::BigInt`], but the *scale is fixed*: arithmetic rounds
//! (half-to-even) back to the operands' scale instead of letting it grow, and
//! display **preserves the scale** (trailing zeros are kept — `3.30`, `100.00`).
//! This is the behaviour finance/accounting needs: money carries exactly N
//! fractional digits, every operation stays at N digits, and `10.00 / 3` is
//! `3.33` (not `3.3333…`).
//!
//! Two constructors share this one type:
//!   * `wang("19.99")` infers the scale from the literal (here 2);
//!   * `titik_tetap("3.14159", 2)` takes an explicit scale and rounds to it.
//!
//! Contrast with `perpuluhan` ([`Decimal`](crate::decimal::Decimal)), which lets
//! the scale grow under multiplication, divides to 34 places, and strips trailing
//! zeros. `wang`/`titik_tetap` are a distinct type that does not silently mix.
//!
//! Dependency-free (Law 8). Interpreter slice; C/WASM codegen + a Coq model are
//! documented follow-ups (mirroring how BigInt and Decimal staged runtime first).

use crate::bigint::BigInt;
use std::cmp::Ordering;

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct Fixed {
    mantissa: BigInt,
    scale: u32,
}

impl Fixed {
    pub fn new(mantissa: BigInt, scale: u32) -> Self {
        Fixed { mantissa, scale }
    }

    pub fn zero() -> Self {
        Fixed {
            mantissa: BigInt::zero(),
            scale: 0,
        }
    }

    pub fn is_zero(&self) -> bool {
        self.mantissa.is_zero()
    }

    pub fn scale(&self) -> u32 {
        self.scale
    }

    /// Parse a decimal literal, inferring the fixed scale from the number of
    /// fractional digits given — the `wang` constructor: `wang("19.99")` → scale
    /// 2, `wang("5")` → scale 0. Returns `None` on malformed input.
    pub fn parse(s: &str) -> Option<Self> {
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
        let digits: String = format!("{int_part}{frac_part}");
        if digits.is_empty() || !digits.bytes().all(|b| b.is_ascii_digit()) {
            return None;
        }
        let mantissa = BigInt::from_decimal_str(&format!("{sign}{digits}"))?;
        Some(Fixed {
            mantissa,
            scale: frac_part.len() as u32,
        })
    }

    /// Parse a decimal literal and round (half-to-even) to an explicit target
    /// scale — the `titik_tetap` constructor: `titik_tetap("3.14159", 2)` → `3.14`,
    /// `titik_tetap("3.145", 2)` → `3.14` (banker's rounding). Returns `None` on
    /// malformed input.
    pub fn parse_scaled(s: &str, scale: u32) -> Option<Self> {
        Some(Self::parse(s)?.rescaled(scale))
    }

    /// Re-express this value at a new fixed `scale`, rounding half-to-even when
    /// fractional digits must be dropped (and padding with zeros when grown).
    pub fn rescaled(&self, scale: u32) -> Fixed {
        Fixed {
            mantissa: Self::rescale_mantissa(&self.mantissa, self.scale, scale),
            scale,
        }
    }

    /// Render in base 10, **preserving the fixed scale** — trailing zeros are
    /// kept (`mantissa=330, scale=2` → `"3.30"`; `mantissa=10000, scale=2` →
    /// `"100.00"`). This is the money-formatting contract.
    pub fn to_string_repr(&self) -> String {
        if self.scale == 0 {
            return self.mantissa.to_decimal_string();
        }
        let neg = self.mantissa.is_negative();
        let mag = if neg {
            self.mantissa.neg().to_decimal_string()
        } else {
            self.mantissa.to_decimal_string()
        };
        let scale = self.scale as usize;
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

    // ── rounding helpers (the core fixed-point primitive) ──

    fn abs(b: &BigInt) -> BigInt {
        if b.is_negative() {
            b.neg()
        } else {
            b.clone()
        }
    }

    fn bump_away_from_zero(q: &BigInt, negative: bool) -> BigInt {
        let one = BigInt::from_u64(1);
        if negative {
            q.sub(&one)
        } else {
            q.add(&one)
        }
    }

    /// `num / denom` rounded half-to-even (`denom` must be nonzero). The single
    /// rounding primitive shared by `mul`, `div`, and `rescale_mantissa`.
    fn round_quotient(num: &BigInt, denom: &BigInt) -> BigInt {
        let (q, r) = num.divmod(denom).expect("round_quotient: denom is nonzero");
        let two_abs_r = Self::abs(&r).mul(&BigInt::from_u64(2));
        let abs_denom = Self::abs(denom);
        let result_neg = num.is_negative() ^ denom.is_negative();
        match two_abs_r.cmp(&abs_denom) {
            Ordering::Less => q,
            Ordering::Greater => Self::bump_away_from_zero(&q, result_neg),
            Ordering::Equal => {
                let (_, parity) = q
                    .divmod(&BigInt::from_u64(2))
                    .expect("divisor 2 is nonzero");
                if parity.is_zero() {
                    q
                } else {
                    Self::bump_away_from_zero(&q, result_neg)
                }
            }
        }
    }

    /// Round a mantissa currently at scale `from` to scale `to`: multiply by a
    /// power of ten when growing, round half-to-even when shrinking.
    fn rescale_mantissa(m: &BigInt, from: u32, to: u32) -> BigInt {
        if to >= from {
            m.mul(&BigInt::pow10(to - from))
        } else {
            Self::round_quotient(m, &BigInt::pow10(from - to))
        }
    }

    /// Re-express both operands at a common scale `max(a, b)` (always exact —
    /// growing only). Returns the two rescaled mantissas and that scale.
    fn align(&self, other: &Fixed) -> (BigInt, BigInt, u32) {
        let scale = self.scale.max(other.scale);
        let a = self.mantissa.mul(&BigInt::pow10(scale - self.scale));
        let b = other.mantissa.mul(&BigInt::pow10(scale - other.scale));
        (a, b, scale)
    }

    // ── arithmetic (result stays at max(scale), rounded half-to-even) ──

    /// Exact: aligns to `max` scale (growing only), so no rounding occurs.
    pub fn add(&self, other: &Fixed) -> Fixed {
        let (a, b, scale) = self.align(other);
        Fixed {
            mantissa: a.add(&b),
            scale,
        }
    }

    /// Exact: aligns to `max` scale (growing only), so no rounding occurs.
    pub fn sub(&self, other: &Fixed) -> Fixed {
        let (a, b, scale) = self.align(other);
        Fixed {
            mantissa: a.sub(&b),
            scale,
        }
    }

    /// The exact product has scale `self.scale + other.scale`; round it
    /// half-to-even back to `max(self.scale, other.scale)` (`1.55 * 1.55` at
    /// scale 2 is `2.4025` → `2.40`).
    pub fn mul(&self, other: &Fixed) -> Fixed {
        let target = self.scale.max(other.scale);
        let exact = self.mantissa.mul(&other.mantissa);
        Fixed {
            mantissa: Self::rescale_mantissa(&exact, self.scale + other.scale, target),
            scale: target,
        }
    }

    pub fn neg(&self) -> Fixed {
        Fixed {
            mantissa: self.mantissa.neg(),
            scale: self.scale,
        }
    }

    /// Value-based comparison (scale-insensitive): `3.30` and `3.3` compare equal.
    pub fn compare(&self, other: &Fixed) -> Ordering {
        let (a, b, _) = self.align(other);
        a.cmp(&b)
    }

    /// `self / other`, rounded half-to-even to `max(self.scale, other.scale)`
    /// fractional digits (the fixed scale is preserved, *not* extended to 34
    /// places like `perpuluhan`): `10.00 / 3` is `3.33`. Returns `None` when
    /// `other` is zero.
    pub fn div(&self, other: &Fixed) -> Option<Fixed> {
        if other.is_zero() {
            return None;
        }
        let target = self.scale.max(other.scale);
        // result ≈ value · 10^target = self.m · 10^(target + other.s - self.s) / other.m
        let shift = i64::from(target) + i64::from(other.scale) - i64::from(self.scale);
        let (num, denom) = if shift >= 0 {
            (
                self.mantissa.mul(&BigInt::pow10(shift as u32)),
                other.mantissa.clone(),
            )
        } else {
            (
                self.mantissa.clone(),
                other.mantissa.mul(&BigInt::pow10((-shift) as u32)),
            )
        };
        Some(Fixed {
            mantissa: Self::round_quotient(&num, &denom),
            scale: target,
        })
    }
}

impl std::fmt::Display for Fixed {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.to_string_repr())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn w(s: &str) -> Fixed {
        Fixed::parse(s).unwrap()
    }

    #[test]
    fn parse_and_render_preserves_scale_with_trailing_zeros() {
        // Unlike Decimal, trailing zeros are *kept* (money formatting).
        for s in ["0", "7", "-7", "3.30", "100.00", "0.001", "1000000.000001"] {
            assert_eq!(w(s).to_string_repr(), s, "roundtrip {s}");
        }
        assert_eq!(w("+5.50").to_string_repr(), "5.50");
        assert_eq!(w(".5").to_string_repr(), "0.5");
        assert_eq!(w("-0.25").to_string_repr(), "-0.25");
        // Scale is the count of fractional digits given.
        assert_eq!(w("19.99").scale(), 2);
        assert_eq!(w("5").scale(), 0);
        assert_eq!(w("1.0000").scale(), 4);
    }

    #[test]
    fn parse_rejects_garbage() {
        for s in ["", "-", "+", "1.2.3", "1,5", "abc", "1.5e3", "."] {
            assert!(Fixed::parse(s).is_none(), "must reject {s:?}");
        }
    }

    #[test]
    fn add_sub_keep_scale_exactly() {
        // Sum 10 invoices of 0.10 → exactly 1.00, displayed with cents.
        let mut total = Fixed::zero();
        for _ in 0..10 {
            total = total.add(&w("0.10"));
        }
        assert_eq!(total.to_string_repr(), "1.00");
        // Mixed scales align to the larger.
        assert_eq!(w("1.10").add(&w("2.005")).to_string_repr(), "3.105");
        assert_eq!(w("100.00").sub(&w("0.01")).to_string_repr(), "99.99");
        assert_eq!(w("5.00").sub(&w("5.00")).to_string_repr(), "0.00");
    }

    #[test]
    fn mul_rounds_back_to_scale_half_even() {
        // Price * integer quantity stays at 2 places: 19.99 * 3 = 59.97.
        assert_eq!(w("19.99").mul(&w("3")).to_string_repr(), "59.97");
        // 1.50 * 1.50 = 2.2500 → 2.25 (no rounding needed).
        assert_eq!(w("1.50").mul(&w("1.50")).to_string_repr(), "2.25");
        // 1.55 * 1.55 = 2.4025 → 2.40 (rounded to 2 places).
        assert_eq!(w("1.55").mul(&w("1.55")).to_string_repr(), "2.40");
        // 0.5 * 0.5 = 0.25 → at scale 1, half-to-even gives 0.2.
        assert_eq!(w("0.5").mul(&w("0.5")).to_string_repr(), "0.2");
        // Sign and a tax-rate style product: 100.00 * 0.07 = 7.00 (scale stays 2).
        assert_eq!(w("100.00").mul(&w("0.07")).to_string_repr(), "7.00");
        assert_eq!(w("-2.50").mul(&w("4")).to_string_repr(), "-10.00");
    }

    #[test]
    fn div_rounds_to_fixed_scale_not_34_places() {
        // The defining contrast with perpuluhan: division stays at the fixed
        // scale instead of expanding to 34 places.
        assert_eq!(w("10.00").div(&w("3")).unwrap().to_string_repr(), "3.33");
        assert_eq!(w("10.00").div(&w("8")).unwrap().to_string_repr(), "1.25");
        assert_eq!(w("1.000").div(&w("3")).unwrap().to_string_repr(), "0.333");
        // Integer money (scale 0) divides to an integer.
        assert_eq!(w("10").div(&w("3")).unwrap().to_string_repr(), "3");
        // Half-to-even at the fixed scale: 1.005 / 1 at scale 3 stays 1.005;
        // 2.5 / 1 ... use a true rounding case: 0.125 at scale 2 → 0.12 (even).
        assert_eq!(w("1.00").div(&w("8")).unwrap().to_string_repr(), "0.12");
        // 0.375 at scale 2 → 0.38 (round half up to even 8).
        assert_eq!(w("3.00").div(&w("8")).unwrap().to_string_repr(), "0.38");
        // Division by zero is None.
        assert!(w("5.00").div(&w("0")).is_none());
        // Sign.
        assert_eq!(w("-1.00").div(&w("8")).unwrap().to_string_repr(), "-0.12");
    }

    #[test]
    fn titik_tetap_explicit_scale_rounds() {
        // parse_scaled = the `titik_tetap(value, scale)` constructor.
        assert_eq!(
            Fixed::parse_scaled("3.14159", 2).unwrap().to_string_repr(),
            "3.14"
        );
        // Banker's rounding at the boundary: 3.145 → 3.14 (4 is even).
        assert_eq!(
            Fixed::parse_scaled("3.145", 2).unwrap().to_string_repr(),
            "3.14"
        );
        // 3.155 → 3.16 (6 is even).
        assert_eq!(
            Fixed::parse_scaled("3.155", 2).unwrap().to_string_repr(),
            "3.16"
        );
        // Growing the scale pads with zeros.
        assert_eq!(
            Fixed::parse_scaled("1.5", 4).unwrap().to_string_repr(),
            "1.5000"
        );
        assert_eq!(Fixed::parse_scaled("100", 2).unwrap().to_string_repr(), "100.00");
    }

    #[test]
    fn compare_is_value_based() {
        assert_eq!(w("3.30").compare(&w("3.3")), Ordering::Equal);
        assert_eq!(w("100.00").compare(&w("100")), Ordering::Equal);
        assert_eq!(w("3.14").compare(&w("3.15")), Ordering::Less);
        assert_eq!(w("-1.00").compare(&w("0.00")), Ordering::Less);
        assert_eq!(w("2.50").compare(&w("2.50001")), Ordering::Less);
    }

    #[test]
    fn finance_invoice_no_float_drift() {
        // 3 line items: 2 × 19.99 + 1 × 5.00, then 7% tax, all at 2 places.
        let subtotal = w("19.99").mul(&w("2")).add(&w("5.00"));
        assert_eq!(subtotal.to_string_repr(), "44.98");
        let tax = subtotal.mul(&w("0.07"));
        assert_eq!(tax.to_string_repr(), "3.15"); // 44.98*0.07 = 3.1486 → 3.15
        let total = subtotal.add(&tax);
        assert_eq!(total.to_string_repr(), "48.13");
    }
}
