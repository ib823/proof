// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Arbitrary-precision signed integers (`besar` — Malay for "big").
//!
//! Dependency-free (Law 8: zero third-party deps) sign-magnitude bignum used by
//! the interpreter's `Value::BigInt`. This is the first slice of the Gate C
//! numeric-tower "BigInt" row — arithmetic that does not overflow at 64 bits,
//! needed for finance use cases. Codegen (C/WASM) and a Coq equivalence model
//! are honest follow-ups (mirroring how the fixed-width numeric tower staged its
//! runtime before `foundations/SizedInt.v`).
//!
//! Representation: magnitude is little-endian base-2^32 limbs (`u32`), always
//! normalized (no trailing zero limbs); the empty vector is zero. `negative` is
//! `false` whenever the magnitude is zero, so equality is structural and there is
//! a single representation of every value. Division truncates toward zero and the
//! remainder takes the dividend's sign (Rust / C `T`-division), matching the
//! existing `Value::Int` `/` and `%`.

use std::cmp::Ordering;

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct BigInt {
    negative: bool,
    mag: Vec<u32>, // little-endian, no trailing zeros; empty == 0
}

const BASE_BITS: u32 = 32;

impl BigInt {
    /// The additive identity.
    pub fn zero() -> Self {
        BigInt {
            negative: false,
            mag: Vec::new(),
        }
    }

    pub fn is_zero(&self) -> bool {
        self.mag.is_empty()
    }

    pub fn is_negative(&self) -> bool {
        self.negative
    }

    /// Construct from a signed 64-bit integer.
    pub fn from_i64(n: i64) -> Self {
        if n == 0 {
            return Self::zero();
        }
        // Use the unsigned magnitude; i64::MIN is handled via `unsigned_abs`.
        let negative = n < 0;
        let m = n.unsigned_abs();
        let mut v = BigInt {
            negative,
            mag: Self::from_u64_mag(m),
        };
        v.normalize();
        v
    }

    /// Construct from an unsigned 64-bit integer.
    pub fn from_u64(n: u64) -> Self {
        let mut v = BigInt {
            negative: false,
            mag: Self::from_u64_mag(n),
        };
        v.normalize();
        v
    }

    /// `10^k` as a non-negative BigInt. Used by the decimal tower for scale
    /// alignment (`mantissa * 10^k`).
    pub fn pow10(k: u32) -> Self {
        let mut v = BigInt::from_u64(1);
        let ten = BigInt::from_u64(10);
        for _ in 0..k {
            v = v.mul(&ten);
        }
        v
    }

    /// True iff this value is exactly one (`1`). Used by decimal rounding.
    pub fn is_one(&self) -> bool {
        !self.negative && self.mag.len() == 1 && self.mag[0] == 1
    }

    fn from_u64_mag(n: u64) -> Vec<u32> {
        if n == 0 {
            Vec::new()
        } else if n <= u64::from(u32::MAX) {
            vec![n as u32]
        } else {
            vec![(n & u64::from(u32::MAX)) as u32, (n >> BASE_BITS) as u32]
        }
    }

    /// Parse a base-10 string with an optional leading `+`/`-`. Returns `None`
    /// for an empty string, a lone sign, or any non-digit character.
    pub fn from_decimal_str(s: &str) -> Option<Self> {
        let bytes = s.as_bytes();
        if bytes.is_empty() {
            return None;
        }
        let (negative, digits) = match bytes[0] {
            b'-' => (true, &bytes[1..]),
            b'+' => (false, &bytes[1..]),
            _ => (false, bytes),
        };
        if digits.is_empty() {
            return None;
        }
        // Accumulate in base 10^9 chunks for speed, then fold into the magnitude.
        let mut result = BigInt::zero();
        let mut i = 0;
        // Leading chunk may be short; subsequent chunks are exactly 9 digits.
        let first_len = if digits.len() % 9 == 0 { 9 } else { digits.len() % 9 };
        let mut chunk_len = first_len;
        while i < digits.len() {
            let mut chunk: u32 = 0;
            for &d in &digits[i..i + chunk_len] {
                if !d.is_ascii_digit() {
                    return None;
                }
                chunk = chunk * 10 + u32::from(d - b'0');
            }
            // result = result * 10^chunk_len + chunk
            let pow = 10u32.pow(chunk_len as u32);
            result = result.mul_small(pow).add_small(chunk);
            i += chunk_len;
            chunk_len = 9;
        }
        result.negative = negative && !result.is_zero();
        result.normalize();
        Some(result)
    }

    /// Render in base 10 with a leading `-` for negatives.
    pub fn to_decimal_string(&self) -> String {
        if self.is_zero() {
            return "0".to_string();
        }
        // Repeatedly divide the magnitude by 10^9, emitting 9-digit groups.
        let mut limbs = self.mag.clone();
        let mut groups: Vec<u32> = Vec::new();
        while !limbs.is_empty() {
            let (q, r) = divmod_small(&limbs, 1_000_000_000);
            groups.push(r);
            limbs = q;
        }
        let mut out = String::new();
        if self.negative {
            out.push('-');
        }
        // Most-significant group has no leading zeros; the rest are zero-padded.
        let last = groups.len() - 1;
        out.push_str(&groups[last].to_string());
        for g in groups[..last].iter().rev() {
            out.push_str(&format!("{g:09}"));
        }
        out
    }

    fn normalize(&mut self) {
        while let Some(&0) = self.mag.last() {
            self.mag.pop();
        }
        if self.mag.is_empty() {
            self.negative = false;
        }
    }

    // ── magnitude helpers (operate on normalized little-endian limbs) ──

    fn cmp_mag(a: &[u32], b: &[u32]) -> Ordering {
        if a.len() != b.len() {
            return a.len().cmp(&b.len());
        }
        for (av, bv) in a.iter().zip(b).rev() {
            if av != bv {
                return av.cmp(bv);
            }
        }
        Ordering::Equal
    }

    fn add_mag(a: &[u32], b: &[u32]) -> Vec<u32> {
        let mut out = Vec::with_capacity(a.len().max(b.len()) + 1);
        let mut carry: u64 = 0;
        for i in 0..a.len().max(b.len()) {
            let av = u64::from(a.get(i).copied().unwrap_or(0));
            let bv = u64::from(b.get(i).copied().unwrap_or(0));
            let sum = av + bv + carry;
            out.push((sum & u64::from(u32::MAX)) as u32);
            carry = sum >> BASE_BITS;
        }
        if carry != 0 {
            out.push(carry as u32);
        }
        out
    }

    /// `a - b`, requires `a >= b` (magnitudes).
    fn sub_mag(a: &[u32], b: &[u32]) -> Vec<u32> {
        let mut out = Vec::with_capacity(a.len());
        let mut borrow: i64 = 0;
        for (i, &a_limb) in a.iter().enumerate() {
            let av = i64::from(a_limb);
            let bv = i64::from(b.get(i).copied().unwrap_or(0));
            let mut diff = av - bv - borrow;
            if diff < 0 {
                diff += 1i64 << BASE_BITS;
                borrow = 1;
            } else {
                borrow = 0;
            }
            out.push(diff as u32);
        }
        while let Some(&0) = out.last() {
            out.pop();
        }
        out
    }

    fn mul_mag(a: &[u32], b: &[u32]) -> Vec<u32> {
        if a.is_empty() || b.is_empty() {
            return Vec::new();
        }
        let mut out = vec![0u32; a.len() + b.len()];
        for (i, &av) in a.iter().enumerate() {
            let mut carry: u64 = 0;
            for (j, &bv) in b.iter().enumerate() {
                let cur = u64::from(out[i + j]) + u64::from(av) * u64::from(bv) + carry;
                out[i + j] = (cur & u64::from(u32::MAX)) as u32;
                carry = cur >> BASE_BITS;
            }
            out[i + b.len()] += carry as u32;
        }
        while let Some(&0) = out.last() {
            out.pop();
        }
        out
    }

    fn mul_small(&self, m: u32) -> BigInt {
        if m == 0 || self.is_zero() {
            return BigInt::zero();
        }
        let mut out = Vec::with_capacity(self.mag.len() + 1);
        let mut carry: u64 = 0;
        for &limb in &self.mag {
            let cur = u64::from(limb) * u64::from(m) + carry;
            out.push((cur & u64::from(u32::MAX)) as u32);
            carry = cur >> BASE_BITS;
        }
        if carry != 0 {
            out.push(carry as u32);
        }
        let mut v = BigInt {
            negative: self.negative,
            mag: out,
        };
        v.normalize();
        v
    }

    fn add_small(&self, n: u32) -> BigInt {
        // Only used during decimal parse where self is non-negative.
        self.add(&BigInt::from_u64(u64::from(n)))
    }

    // ── signed operations ──

    pub fn neg(&self) -> BigInt {
        if self.is_zero() {
            return BigInt::zero();
        }
        BigInt {
            negative: !self.negative,
            mag: self.mag.clone(),
        }
    }

    pub fn add(&self, other: &BigInt) -> BigInt {
        let mut v = if self.negative == other.negative {
            BigInt {
                negative: self.negative,
                mag: Self::add_mag(&self.mag, &other.mag),
            }
        } else {
            match Self::cmp_mag(&self.mag, &other.mag) {
                Ordering::Equal => BigInt::zero(),
                Ordering::Greater => BigInt {
                    negative: self.negative,
                    mag: Self::sub_mag(&self.mag, &other.mag),
                },
                Ordering::Less => BigInt {
                    negative: other.negative,
                    mag: Self::sub_mag(&other.mag, &self.mag),
                },
            }
        };
        v.normalize();
        v
    }

    pub fn sub(&self, other: &BigInt) -> BigInt {
        self.add(&other.neg())
    }

    pub fn mul(&self, other: &BigInt) -> BigInt {
        let mut v = BigInt {
            negative: self.negative != other.negative,
            mag: Self::mul_mag(&self.mag, &other.mag),
        };
        v.normalize();
        v
    }

    /// Truncated division: returns `(quotient, remainder)` with the quotient
    /// truncated toward zero and the remainder taking the dividend's sign
    /// (matching Rust/C `/` and `%`). Returns `None` when `other` is zero.
    pub fn divmod(&self, other: &BigInt) -> Option<(BigInt, BigInt)> {
        if other.is_zero() {
            return None;
        }
        let (q_mag, r_mag) = divmod_mag(&self.mag, &other.mag);
        let mut q = BigInt {
            negative: self.negative != other.negative,
            mag: q_mag,
        };
        let mut r = BigInt {
            negative: self.negative,
            mag: r_mag,
        };
        q.normalize();
        r.normalize();
        Some((q, r))
    }

}

impl PartialOrd for BigInt {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for BigInt {
    fn cmp(&self, other: &Self) -> Ordering {
        match (self.negative, other.negative) {
            (false, true) => Ordering::Greater,
            (true, false) => Ordering::Less,
            (false, false) => Self::cmp_mag(&self.mag, &other.mag),
            (true, true) => Self::cmp_mag(&other.mag, &self.mag),
        }
    }
}

impl std::fmt::Display for BigInt {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.to_decimal_string())
    }
}

/// Unsigned long division of little-endian magnitudes: `(u / v, u % v)`.
/// Bit-by-bit (shift-and-subtract) — O(bits·limbs), chosen for obvious
/// correctness in the reference interpreter rather than speed.
fn divmod_mag(u: &[u32], v: &[u32]) -> (Vec<u32>, Vec<u32>) {
    debug_assert!(!v.is_empty(), "division by zero magnitude");
    if BigInt::cmp_mag(u, v) == Ordering::Less {
        return (Vec::new(), u.to_vec());
    }
    let total_bits = u.len() * BASE_BITS as usize;
    let mut q = vec![0u32; u.len()];
    let mut r: Vec<u32> = Vec::new();
    for bit in (0..total_bits).rev() {
        // r <<= 1
        shl1(&mut r);
        // bring down bit `bit` of u
        let limb = bit / BASE_BITS as usize;
        let off = bit % BASE_BITS as usize;
        if (u[limb] >> off) & 1 == 1 {
            if r.is_empty() {
                r.push(1);
            } else {
                r[0] |= 1;
            }
        }
        if BigInt::cmp_mag(&r, v) != Ordering::Less {
            r = BigInt::sub_mag(&r, v);
            q[limb] |= 1 << off;
        }
    }
    while let Some(&0) = q.last() {
        q.pop();
    }
    (q, r)
}

/// In-place `<<= 1` on a little-endian magnitude.
fn shl1(mag: &mut Vec<u32>) {
    let mut carry: u32 = 0;
    for limb in mag.iter_mut() {
        let new_carry = *limb >> 31;
        *limb = (*limb << 1) | carry;
        carry = new_carry;
    }
    if carry != 0 {
        mag.push(carry);
    }
}

/// Divide a little-endian magnitude by a single-limb divisor: `(quotient, remainder)`.
fn divmod_small(u: &[u32], d: u32) -> (Vec<u32>, u32) {
    let mut q = vec![0u32; u.len()];
    let mut rem: u64 = 0;
    for i in (0..u.len()).rev() {
        let cur = (rem << BASE_BITS) | u64::from(u[i]);
        q[i] = (cur / u64::from(d)) as u32;
        rem = cur % u64::from(d);
    }
    while let Some(&0) = q.last() {
        q.pop();
    }
    (q, rem as u32)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn big(s: &str) -> BigInt {
        BigInt::from_decimal_str(s).unwrap()
    }

    #[test]
    fn parse_and_render_roundtrip() {
        for s in [
            "0",
            "7",
            "-7",
            "4294967296",                 // 2^32
            "18446744073709551616",       // 2^64
            "-340282366920938463463374607431768211456", // -2^128
            "123456789012345678901234567890",
        ] {
            assert_eq!(big(s).to_decimal_string(), s, "roundtrip {s}");
        }
        // Normalization: +/-0 and leading zeros collapse.
        assert_eq!(big("-0").to_decimal_string(), "0");
        assert_eq!(big("+42").to_decimal_string(), "42");
        assert_eq!(big("007").to_decimal_string(), "7");
    }

    #[test]
    fn parse_rejects_garbage() {
        for s in ["", "-", "+", "1.5", "12a", "0x10", " 3", "3 "] {
            assert!(BigInt::from_decimal_str(s).is_none(), "must reject {s:?}");
        }
    }

    // Dependency-free deterministic RNG for differential testing against i128.
    struct XorShift(u64);
    impl XorShift {
        fn next(&mut self) -> u64 {
            let mut x = self.0;
            x ^= x << 13;
            x ^= x >> 7;
            x ^= x << 17;
            self.0 = x;
            x
        }
        fn next_i64(&mut self) -> i64 {
            self.next() as i64
        }
    }

    #[test]
    fn arithmetic_matches_i128_on_random_i64_pairs() {
        let mut rng = XorShift(0x9E37_79B9_7F4A_7C15);
        for _ in 0..5000 {
            let a = rng.next_i64();
            let b = rng.next_i64();
            let (ba, bb) = (BigInt::from_i64(a), BigInt::from_i64(b));
            let (ia, ib) = (i128::from(a), i128::from(b));

            assert_eq!(ba.add(&bb).to_decimal_string(), (ia + ib).to_string());
            assert_eq!(ba.sub(&bb).to_decimal_string(), (ia - ib).to_string());
            assert_eq!(ba.mul(&bb).to_decimal_string(), (ia * ib).to_string());
            assert_eq!(
                ba.cmp(&bb),
                ia.cmp(&ib),
                "cmp {a} ? {b}"
            );
            if b != 0 {
                let (q, r) = ba.divmod(&bb).unwrap();
                assert_eq!(q.to_decimal_string(), (ia / ib).to_string(), "{a}/{b}");
                assert_eq!(r.to_decimal_string(), (ia % ib).to_string(), "{a}%{b}");
            }
        }
    }

    #[test]
    fn division_truncates_toward_zero_like_rust() {
        // Mirror Rust integer semantics across all sign combinations.
        let cases = [(7, 3), (-7, 3), (7, -3), (-7, -3), (1, 2), (-1, 2)];
        for (a, b) in cases {
            let (q, r) = BigInt::from_i64(a).divmod(&BigInt::from_i64(b)).unwrap();
            assert_eq!(q.to_decimal_string(), (a / b).to_string(), "{a}/{b}");
            assert_eq!(r.to_decimal_string(), (a % b).to_string(), "{a}%{b}");
        }
    }

    #[test]
    fn division_by_zero_is_none() {
        assert!(big("5").divmod(&BigInt::zero()).is_none());
    }

    #[test]
    fn large_values_beyond_u64() {
        // 2^64 * 2^64 = 2^128, well beyond any fixed-width int.
        let two_64 = big("18446744073709551616");
        assert_eq!(
            two_64.mul(&two_64).to_decimal_string(),
            "340282366920938463463374607431768211456"
        );
        // 20! = 2432902008176640000 (fits u64) ; 25! overflows u64.
        let mut fac = BigInt::from_u64(1);
        for k in 1..=25u64 {
            fac = fac.mul(&BigInt::from_u64(k));
        }
        assert_eq!(fac.to_decimal_string(), "15511210043330985984000000");
        // Exact division undoes the multiplication: 25! / 25! = 1, remainder 0.
        let (q, r) = fac.divmod(&fac).unwrap();
        assert_eq!(q.to_decimal_string(), "1");
        assert!(r.is_zero());
    }

    #[test]
    fn powers_of_ten_via_repeated_mul() {
        let ten = BigInt::from_u64(10);
        let mut p = BigInt::from_u64(1);
        for _ in 0..50 {
            p = p.mul(&ten);
        }
        assert_eq!(
            p.to_decimal_string(),
            "100000000000000000000000000000000000000000000000000"
        );
    }

    /// Coq⇄Rust formal-equivalence bridge. The running bignum reproduces the
    /// exact values the model proves by `vm_compute` in
    /// `02_FORMAL/coq/foundations/BigIntModel.v` (Examples `sum_value`,
    /// `product_value`, `divmod_BA`, `divmod_BA_reconstructs`) — tying this
    /// algorithm to the model whose `eval_add`/`eval_mul` prove `eval` is a ring
    /// homomorphism from the limb representation to ℤ. Same `(A, B)` operands as
    /// the Coq `Ak`/`Bk`.
    #[test]
    fn test_bigint_matches_coq_model() {
        let a = big("123456789012345678901234567890");
        let b = big("987654321098765432109876543210");
        // BigIntModel.v `sum_value`
        assert_eq!(a.add(&b).to_decimal_string(), "1111111110111111111011111111100");
        // BigIntModel.v `product_value`
        assert_eq!(
            a.mul(&b).to_decimal_string(),
            "121932631137021795226185032733622923332237463801111263526900"
        );
        // BigIntModel.v `divmod_BA`: B = 8*A + r, 0 <= r < A
        let (q, r) = b.divmod(&a).unwrap();
        assert_eq!(q.to_decimal_string(), "8");
        assert_eq!(r.to_decimal_string(), "9000000000900000000090");
        // BigIntModel.v `divmod_BA_reconstructs`
        assert_eq!(q.mul(&a).add(&r), b);
    }

    #[test]
    fn zero_and_sign_normalization() {
        assert!(BigInt::zero().is_zero());
        assert!(!BigInt::zero().is_negative());
        // a - a == 0 (canonical, non-negative).
        let a = big("-998877665544332211");
        let z = a.sub(&a);
        assert!(z.is_zero() && !z.is_negative());
        assert_eq!(z.to_decimal_string(), "0");
        // neg of zero is zero.
        assert_eq!(BigInt::zero().neg().to_decimal_string(), "0");
        // Mixed-sign add that cancels magnitude.
        assert_eq!(big("100").add(&big("-100")).to_decimal_string(), "0");
    }
}
