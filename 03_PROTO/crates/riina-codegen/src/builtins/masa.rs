// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Time builtins (masa)

use crate::value::Value;
use crate::{Error, Result};
use std::time::Instant;

// ── Civil calendar ─────────────────────────────────────────────────────────
//
// `masa_format`/`masa_urai` deliberately do NOT use the platform's
// `strftime`/`strptime`. The C backend can call libc; the interpreter cannot
// reach an equivalent without a dependency (Law 8), so letting libc define the
// contract guarantees the two backends disagree — and they did: before REQ-70
// routed this family, `masa_format((1700000000, "%Y-%m-%d"))` gave `2023-11-14`
// compiled and `1700000000` interpreted, because the interpreter simply ignored
// the format string. One algorithm, implemented on both sides and pinned by a
// differential, is the only shape that cannot drift.
//
// The date arithmetic is the standard proleptic-Gregorian days<->civil pair
// (Howard Hinnant's `civil_from_days`), which is exact for all dates the era
// arithmetic covers and needs no tables.

/// Civil date `(year, month, day)` from days since the Unix epoch.
pub(crate) fn civil_from_days(z: i64) -> (i64, u32, u32) {
    let z = z + 719_468;
    let era = if z >= 0 { z } else { z - 146_096 } / 146_097;
    let doe = (z - era * 146_097) as u64; // [0, 146096]
    let yoe = (doe - doe / 1460 + doe / 36_524 - doe / 146_096) / 365; // [0, 399]
    let y = yoe as i64 + era * 400;
    let doy = doe - (365 * yoe + yoe / 4 - yoe / 100); // [0, 365]
    let mp = (5 * doy + 2) / 153; // [0, 11]
    let d = (doy - (153 * mp + 2) / 5 + 1) as u32; // [1, 31]
    let m = if mp < 10 { mp + 3 } else { mp - 9 } as u32; // [1, 12]
    (if m <= 2 { y + 1 } else { y }, m, d)
}

/// Days since the Unix epoch from a civil date. Inverse of `civil_from_days`.
pub(crate) fn days_from_civil(y: i64, m: u32, d: u32) -> i64 {
    let y = if m <= 2 { y - 1 } else { y };
    let era = if y >= 0 { y } else { y - 399 } / 400;
    let yoe = (y - era * 400) as u64; // [0, 399]
    let mp = if m > 2 { m - 3 } else { m + 9 } as u64; // [0, 11]
    let doy = (153 * mp + 2) / 5 + d as u64 - 1; // [0, 365]
    let doe = yoe * 365 + yoe / 4 - yoe / 100 + doy; // [0, 146096]
    era * 146_097 + doe as i64 - 719_468
}

/// Split a Unix timestamp into `(days, hour, minute, second)`, flooring so
/// pre-epoch timestamps land on the right day.
fn split_ts(ts: i64) -> (i64, u32, u32, u32) {
    let days = ts.div_euclid(86_400);
    let rem = ts.rem_euclid(86_400);
    (days, (rem / 3600) as u32, ((rem % 3600) / 60) as u32, (rem % 60) as u32)
}

/// The format specifiers `masa_format`/`masa_urai` support, on every backend.
///
/// `%Y` year, `%m` month, `%d` day, `%H` hour, `%M` minute, `%S` second
/// (all zero-padded to their natural width), `%s` the raw Unix timestamp, and
/// `%%` a literal `%`. **Any other specifier is emitted literally, `%` and
/// all** — deliberately, so an unsupported specifier is visible in the output
/// rather than silently dropped, and so both backends agree on what "not
/// supported" looks like.
pub(crate) fn format_time(ts: i64, fmt: &str) -> String {
    let (days, hh, mi, ss) = split_ts(ts);
    let (y, mo, d) = civil_from_days(days);
    let mut out = String::new();
    let mut it = fmt.chars().peekable();
    while let Some(c) = it.next() {
        if c != '%' {
            out.push(c);
            continue;
        }
        match it.next() {
            Some('Y') => out.push_str(&format!("{y:04}")),
            Some('m') => out.push_str(&format!("{mo:02}")),
            Some('d') => out.push_str(&format!("{d:02}")),
            Some('H') => out.push_str(&format!("{hh:02}")),
            Some('M') => out.push_str(&format!("{mi:02}")),
            Some('S') => out.push_str(&format!("{ss:02}")),
            Some('s') => out.push_str(&ts.to_string()),
            Some('%') => out.push('%'),
            Some(other) => {
                out.push('%');
                out.push(other);
            }
            None => out.push('%'),
        }
    }
    out
}

/// Parse `s` against `fmt`, the inverse of [`format_time`] over the same
/// specifier set. Returns `None` if the text does not match the format.
///
/// Literal characters in `fmt` must match exactly. A numeric field consumes
/// the digits that are there (up to its natural width), so both `2023-1-5` and
/// `2023-01-05` parse under `%Y-%m-%d`.
pub(crate) fn parse_time(s: &str, fmt: &str) -> Option<i64> {
    let sb: Vec<char> = s.chars().collect();
    let mut i = 0usize;
    let (mut y, mut mo, mut d) = (1970i64, 1u32, 1u32);
    let (mut hh, mut mi, mut ss) = (0u32, 0u32, 0u32);
    let mut epoch: Option<i64> = None;

    let mut f = fmt.chars().peekable();
    while let Some(c) = f.next() {
        if c != '%' {
            if sb.get(i) != Some(&c) {
                return None;
            }
            i += 1;
            continue;
        }
        let spec = f.next()?;
        if spec == '%' {
            if sb.get(i) != Some(&'%') {
                return None;
            }
            i += 1;
            continue;
        }
        // `%s` may carry a leading `-`; the field specifiers never do.
        let width = match spec {
            'Y' => 4,
            'm' | 'd' | 'H' | 'M' | 'S' => 2,
            's' => 20,
            other => {
                // Unsupported specifier: match it literally, exactly as
                // `format_time` emits it.
                if sb.get(i) != Some(&'%') || sb.get(i + 1) != Some(&other) {
                    return None;
                }
                i += 2;
                continue;
            }
        };
        let start = i;
        if spec == 's' && sb.get(i) == Some(&'-') {
            i += 1;
        }
        while i < sb.len() && i - start < width && sb[i].is_ascii_digit() {
            i += 1;
        }
        if i == start {
            return None;
        }
        let text: String = sb[start..i].iter().collect();
        match spec {
            'Y' => y = text.parse().ok()?,
            'm' => mo = text.parse().ok()?,
            'd' => d = text.parse().ok()?,
            'H' => hh = text.parse().ok()?,
            'M' => mi = text.parse().ok()?,
            'S' => ss = text.parse().ok()?,
            's' => epoch = Some(text.parse().ok()?),
            _ => unreachable!("width table and match arms agree"),
        }
    }
    if i != sb.len() {
        return None;
    }
    if let Some(e) = epoch {
        return Some(e);
    }
    if !(1..=12).contains(&mo) || !(1..=31).contains(&d) || hh > 23 || mi > 59 || ss > 59 {
        return None;
    }
    Some(days_from_civil(y, mo, d) * 86_400 + i64::from(hh) * 3600 + i64::from(mi) * 60 + i64::from(ss))
}

/// Monotonic origin for `masa_jam`, fixed at first use.
///
/// `masa_jam` is a MONOTONIC clock: nanoseconds from an unspecified origin,
/// never decreasing, for measuring elapsed time. It used to return wall-clock
/// nanoseconds since the epoch in the interpreter while the C backend used
/// `CLOCK_MONOTONIC` — different clocks with magnitudes three orders of
/// magnitude apart (1.79e18 vs 1.9e11), which routing this family would have
/// turned into a live divergence (REQ-70).
fn monotonic_origin() -> Instant {
    use std::sync::OnceLock;
    static ORIGIN: OnceLock<Instant> = OnceLock::new();
    *ORIGIN.get_or_init(Instant::now)
}

/// (BM name, EN alias, canonical name)
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("masa_sekarang", "time_now", "masa_sekarang"),
    ("masa_unix", "time_unix", "masa_sekarang"),
    ("masa_sekarang_ms", "time_now_ms", "masa_sekarang_ms"),
    ("masa_format", "time_format", "masa_format"),
    ("masa_urai", "time_parse", "masa_urai"),
    ("masa_tidur", "time_sleep", "masa_tidur"),
    ("masa_jam", "time_clock", "masa_jam"),
];

pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    match name {
        "masa_sekarang" | "masa_unix" => {
            // () -> Int (unix timestamp seconds)
            use std::time::{SystemTime, UNIX_EPOCH};
            let secs = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap_or_default()
                .as_secs();
            Ok(Some(Value::Int(secs)))
        }
        "masa_sekarang_ms" => {
            // () -> Int (unix timestamp milliseconds)
            use std::time::{SystemTime, UNIX_EPOCH};
            let ms = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap_or_default()
                .as_millis() as u64;
            Ok(Some(Value::Int(ms)))
        }
        "masa_format" => {
            // (Int, String) -> String, over the shared specifier set.
            match arg {
                Value::Pair(ts, fmt) => {
                    let t = extract_int(ts, "masa_format")?;
                    let f = extract_string(fmt, "masa_format")?;
                    Ok(Some(Value::String(format_time(t as i64, &f))))
                }
                _ => Err(type_err("(int, string)", arg, "masa_format")),
            }
        }
        "masa_urai" => {
            // (String, String) -> Int, the inverse of `masa_format`.
            match arg {
                Value::Pair(s, fmt) => {
                    let text = extract_string(s, "masa_urai")?;
                    let f = extract_string(fmt, "masa_urai")?;
                    let t = parse_time(&text, &f).ok_or_else(|| {
                        Error::InvalidOperation(format!(
                            "cannot parse '{text}' as a timestamp with format '{f}'"
                        ))
                    })?;
                    Ok(Some(Value::Int(t as u64)))
                }
                _ => Err(type_err("(string, string)", arg, "masa_urai")),
            }
        }
        "masa_tidur" => {
            // Int -> ()  (sleep milliseconds)
            let ms = extract_int(arg, "masa_tidur")?;
            std::thread::sleep(std::time::Duration::from_millis(ms));
            Ok(Some(Value::Unit))
        }
        "masa_jam" => {
            // () -> Int: MONOTONIC nanoseconds from an unspecified origin.
            // Was wall-clock-since-epoch here while C used CLOCK_MONOTONIC.
            Ok(Some(Value::Int(
                monotonic_origin().elapsed().as_nanos() as u64
            )))
        }
        _ => Ok(None),
    }
}

fn extract_int(v: &Value, ctx: &str) -> Result<u64> {
    match v {
        Value::Int(n) => Ok(*n),
        _ => Err(type_err("int", v, ctx)),
    }
}

fn extract_string(v: &Value, ctx: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        _ => Err(type_err("string", v, ctx)),
    }
}

fn type_err(expected: &str, found: &Value, ctx: &str) -> Error {
    Error::TypeMismatch {
        expected: expected.to_string(),
        found: format!("{:?}", found),
        context: ctx.to_string(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_masa_sekarang() {
        let result = apply("masa_sekarang", &Value::Unit).unwrap().unwrap();
        match result {
            Value::Int(t) => assert!(t > 1_700_000_000), // after 2023
            _ => panic!("expected int"),
        }
    }

    #[test]
    fn test_masa_sekarang_ms() {
        let result = apply("masa_sekarang_ms", &Value::Unit).unwrap().unwrap();
        match result {
            Value::Int(t) => assert!(t > 1_700_000_000_000),
            _ => panic!("expected int"),
        }
    }

    #[test]
    fn test_masa_format() {
        let arg = Value::Pair(
            Box::new(Value::Int(1700000000)),
            Box::new(Value::String("%Y-%m-%d".to_string())),
        );
        let result = apply("masa_format", &arg).unwrap().unwrap();
        // Was `1700000000` — the format string was ignored outright, while the
        // C backend ran a real strftime (REQ-70).
        assert_eq!(result, Value::String("2023-11-14".to_string()));
    }

    #[test]
    fn test_masa_urai() {
        let arg = Value::Pair(
            Box::new(Value::String("2023-11-14".to_string())),
            Box::new(Value::String("%Y-%m-%d".to_string())),
        );
        let result = apply("masa_urai", &arg).unwrap().unwrap();
        assert_eq!(result, Value::Int(1_699_920_000));
    }

    // ── Civil calendar ─────────────────────────────────────────────────────

    #[test]
    fn civil_round_trips_across_era_boundaries() {
        // Leap rules, century rules, and the 400-year era boundary the
        // algorithm is built around — plus a pre-epoch date, since the epoch
        // split must FLOOR rather than truncate.
        for &(y, m, d) in &[
            (1970, 1, 1),
            (1969, 12, 31),
            (2000, 2, 29), // 400-divisible: IS a leap year
            (1900, 2, 28), // 100-divisible, not 400: NOT a leap year
            (2024, 2, 29),
            (2023, 11, 14),
            (1600, 1, 1),
            (2400, 12, 31),
        ] {
            let days = days_from_civil(y, m, d);
            assert_eq!(civil_from_days(days), (y, m, d), "round trip {y}-{m}-{d}");
        }
    }

    #[test]
    fn known_epoch_values() {
        assert_eq!(days_from_civil(1970, 1, 1), 0);
        assert_eq!(civil_from_days(0), (1970, 1, 1));
        // 1700000000 = 2023-11-14T22:13:20Z
        assert_eq!(format_time(1_700_000_000, "%Y-%m-%d %H:%M:%S"), "2023-11-14 22:13:20");
    }

    #[test]
    fn format_handles_epoch_literal_percent_and_unsupported() {
        assert_eq!(format_time(1_700_000_000, "%s"), "1700000000");
        assert_eq!(format_time(0, "100%%"), "100%");
        // An unsupported specifier is emitted LITERALLY — visible, not dropped.
        assert_eq!(format_time(0, "%Q"), "%Q");
        // A trailing bare `%` is kept.
        assert_eq!(format_time(0, "x%"), "x%");
    }

    #[test]
    fn pre_epoch_timestamps_floor_to_the_right_day() {
        // -1 is 1969-12-31T23:59:59Z. Truncating division would give
        // 1970-01-01, which is the classic off-by-one-day bug here.
        assert_eq!(format_time(-1, "%Y-%m-%d %H:%M:%S"), "1969-12-31 23:59:59");
    }

    #[test]
    fn parse_is_the_inverse_of_format() {
        for ts in [0i64, 1, 1_700_000_000, 2_000_000_000, -1, -86_400] {
            let text = format_time(ts, "%Y-%m-%d %H:%M:%S");
            assert_eq!(parse_time(&text, "%Y-%m-%d %H:%M:%S"), Some(ts), "round trip {ts}");
        }
    }

    #[test]
    fn parse_rejects_what_does_not_match() {
        assert_eq!(parse_time("not-a-date", "%Y-%m-%d"), None);
        // Trailing junk is a mismatch, not silently ignored.
        assert_eq!(parse_time("2023-11-14xyz", "%Y-%m-%d"), None);
        // Out-of-range fields are refused rather than normalised.
        assert_eq!(parse_time("2023-13-01", "%Y-%m-%d"), None);
        assert_eq!(parse_time("2023-11-14 25:00:00", "%Y-%m-%d %H:%M:%S"), None);
        // A literal that does not match.
        assert_eq!(parse_time("2023/11/14", "%Y-%m-%d"), None);
    }

    #[test]
    fn parse_accepts_unpadded_fields() {
        assert_eq!(parse_time("2023-1-5", "%Y-%m-%d"), parse_time("2023-01-05", "%Y-%m-%d"));
    }

    #[test]
    fn masa_jam_is_monotonic() {
        // It is a MONOTONIC clock, not wall-clock-since-epoch: successive reads
        // never decrease. The interpreter used to return wall nanos here while
        // C used CLOCK_MONOTONIC — magnitudes three orders apart (REQ-70).
        let a = apply("masa_jam", &Value::Unit).unwrap().unwrap();
        let b = apply("masa_jam", &Value::Unit).unwrap().unwrap();
        match (a, b) {
            (Value::Int(x), Value::Int(y)) => assert!(y >= x, "clock went backwards: {x} -> {y}"),
            other => panic!("expected ints, got {other:?}"),
        }
    }

    #[test]
    fn test_masa_jam() {
        let result = apply("masa_jam", &Value::Unit).unwrap().unwrap();
        match result {
            Value::Int(t) => assert!(t > 0),
            _ => panic!("expected int"),
        }
    }

    #[test]
    fn test_unknown_returns_none() {
        assert_eq!(apply("unknown", &Value::Unit).unwrap(), None);
    }
}
