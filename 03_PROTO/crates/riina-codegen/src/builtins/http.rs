// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Real HTTP/1.1 builtins (`http_hurai_*`, `http_balas`, `http_minta`) —
//! master plan REQ-73.
//!
//! These expose [`riina_os::http`], the RFC 9112 codec, to RIINA programs. They
//! are the difference between "a program can open a TCP socket" (`jaring_*`,
//! already real) and "a program can serve or speak HTTP without hand-rolling
//! string concatenation" — which is how framing bugs get written.
//!
//! # Real vs modelled — no overclaiming (Prime Directive 2)
//!
//! The pre-existing `http_dapat`/`http_get`/`http_hantar`/`http_post` in
//! [`super::keselamatan`] are **modelled**: they return a canned `"200 OK"`
//! with no socket. They exist to carry the taint→sink TYPE discipline
//! (`Disanitasi<Teks, UrlAllowlist>` arguments), which is what the Coq
//! `*_injection_impossible` family is about. They are deliberately left alone —
//! renaming or repurposing them would break that discipline.
//!
//! The builtins here are the REAL layer, under distinct names:
//!
//! * `http_hurai_kaedah` / `http_hurai_laluan` / `http_hurai_jasad` /
//!   `http_hurai_kepala` — parse a request a server read off a socket. Pure.
//! * `http_balas` — build a response with framing computed, never caller-supplied.
//! * `http_minta` — perform a REAL one-shot HTTP/1.1 request over the verified
//!   RFC 793 TCP machine and return the response body.
//!
//! Every parse goes through the strict codec, so a smuggling attempt
//! (`Content-Length` + `Transfer-Encoding`, `Foo : bar`, conflicting duplicate
//! lengths) is an error inside the RIINA program rather than a silently
//! mis-framed message.
//!
//! `http_minta` speaks cleartext `http://` only. `https://` is REFUSED, loudly:
//! there is no TLS record layer yet (the still-open half of REQ-73), and a
//! silent downgrade to cleartext would be worse than a refusal.
//!
//! Interpreter-only: not registered in codegen's `builtin_canonical`, so the
//! C/WASM backends fail closed (unbound `http_*`) rather than miscompiling
//! (REQ-70).

use crate::value::Value;
use crate::{Error, Result};
use riina_os::http::{self, Headers};
use riina_os::net::{TcpConnection, TcpEvent, TcpState};
use std::io::{Read, Write};
use std::net::TcpStream;
use std::time::Duration;

/// (BM name, EN name, canonical key).
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("http_hurai_kaedah", "http_parse_method", "http_hurai_kaedah"),
    ("http_hurai_laluan", "http_parse_target", "http_hurai_laluan"),
    ("http_hurai_jasad", "http_parse_body", "http_hurai_jasad"),
    ("http_hurai_kepala", "http_parse_header", "http_hurai_kepala"),
    ("http_balas", "http_build_response", "http_balas"),
    ("http_minta", "http_request", "http_minta"),
];

/// How long a real request waits on the network before giving up.
const REQUEST_TIMEOUT: Duration = Duration::from_secs(30);

fn err(msg: impl Into<String>) -> Error {
    Error::InvalidOperation(msg.into())
}

fn as_str(v: &Value, name: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        other => Err(err(format!("{name}: expected a string, got {other:?}"))),
    }
}

/// Split a pair argument, returning a `BuiltinPartial` when applied to one
/// value (the currying convention in `interp.rs`).
enum Pair {
    Partial(Value),
    Both(Value, Value),
}

fn split_pair(name: &str, arg: &Value) -> Result<Pair> {
    match arg {
        Value::Pair(a, b) => Ok(Pair::Both((**a).clone(), (**b).clone())),
        other => Ok(Pair::Partial(Value::BuiltinPartial(
            name.to_string(),
            Box::new(other.clone()),
        ))),
    }
}

/// Apply an HTTP builtin. `Ok(None)` ⇒ not ours; dispatch falls through.
///
/// # Errors
/// Returns the codec's own diagnostic for a malformed message, or the socket
/// error for a failed request. A parse failure is never repaired into a
/// plausible-looking value.
pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    let result = match name {
        // ── request parsing (pure) ───────────────────────────────────────
        "http_hurai_kaedah" => {
            let raw = as_str(arg, name)?;
            let req = http::parse_request(raw.as_bytes()).map_err(|e| err(format!("http: {e}")))?;
            Value::String(req.method)
        }
        "http_hurai_laluan" => {
            let raw = as_str(arg, name)?;
            let req = http::parse_request(raw.as_bytes()).map_err(|e| err(format!("http: {e}")))?;
            Value::String(req.target)
        }
        "http_hurai_jasad" => {
            let raw = as_str(arg, name)?;
            let req = http::parse_request(raw.as_bytes()).map_err(|e| err(format!("http: {e}")))?;
            Value::String(String::from_utf8_lossy(&req.body).into_owned())
        }
        // `(request, field_name) -> value`; absent field yields "" so a RIINA
        // program can branch without an option type.
        "http_hurai_kepala" => match split_pair(name, arg)? {
            Pair::Partial(v) => v,
            Pair::Both(raw, field) => {
                let raw = as_str(&raw, name)?;
                let field = as_str(&field, name)?;
                let req =
                    http::parse_request(raw.as_bytes()).map_err(|e| err(format!("http: {e}")))?;
                let value = req
                    .headers
                    .get(&field.to_ascii_lowercase())
                    .cloned()
                    .unwrap_or_default();
                Value::String(value)
            }
        },

        // ── response building (pure) ─────────────────────────────────────
        // `(status, body) -> wire bytes`. Content-Length and Connection are
        // computed by the codec, so a RIINA program cannot emit an ambiguous
        // or split response.
        "http_balas" => match split_pair(name, arg)? {
            Pair::Partial(v) => v,
            Pair::Both(status, body) => {
                let status = match status {
                    Value::Int(n) => u16::try_from(n)
                        .map_err(|_| err(format!("http_balas: status {n} out of range")))?,
                    other => return Err(err(format!("http_balas: expected status int, got {other:?}"))),
                };
                let body = as_str(&body, name)?;
                let mut headers = Headers::new();
                headers.insert("content-type".into(), "text/html; charset=utf-8".into());
                let bytes =
                    http::encode_response(status, http::reason_phrase(status), &headers, body.as_bytes())
                        .map_err(|e| err(format!("http: {e}")))?;
                Value::String(String::from_utf8_lossy(&bytes).into_owned())
            }
        },

        // ── real request (Network) ───────────────────────────────────────
        // `(method, url) -> response body`.
        "http_minta" => match split_pair(name, arg)? {
            Pair::Partial(v) => v,
            Pair::Both(method, url) => {
                let method = as_str(&method, name)?;
                let url = as_str(&url, name)?;
                Value::String(perform_request(&method, &url)?)
            }
        },

        _ => return Ok(None),
    };
    Ok(Some(result))
}

/// One-shot HTTP/1.1 request over a real socket, driving the same verified
/// RFC 793 machine as `jaring_*`.
///
/// The machine is driven rather than merely observed: CLOSED→SYN_SENT on
/// connect, ESTABLISHED before any byte moves, and the active-close path on the
/// way out. A send is impossible unless the model says ESTABLISHED.
fn perform_request(method: &str, url: &str) -> Result<String> {
    let (host_port, target) = http::split_url(url).map_err(|e| err(format!("http: {e}")))?;
    // RFC 9110 §7.2: the port belongs in `Host` unless it is the scheme
    // default. Stripping whatever port followed the last colon — which is what
    // this did before the C backend was written against it — sent
    // `Host: x.test` for `http://x.test:8080/`, so a virtual host keyed on the
    // port saw the wrong authority. Strip `:80` and nothing else.
    let host = host_port
        .strip_suffix(":80")
        .filter(|h| !h.is_empty())
        .unwrap_or(&host_port)
        .to_string();

    let wire = http::encode_request(method, &target, &host, &Headers::new(), b"")
        .map_err(|e| err(format!("http: {e}")))?;

    // Verified machine: CLOSED --ActiveOpen--> SYN_SENT --SynAckReceived--> ESTABLISHED.
    let mut machine = TcpConnection::new();
    machine
        .on_event(TcpEvent::ActiveOpen)
        .map_err(|_| err("http: internal state error"))?;
    let mut stream = TcpStream::connect(&host_port)
        .map_err(|e| err(format!("http: connect {host_port}: {e}")))?;
    machine
        .on_event(TcpEvent::SynAckReceived)
        .map_err(|_| err("http: internal state error"))?;
    if machine.state() != TcpState::Established {
        return Err(err("http: connection not established"));
    }
    let _ = stream.set_read_timeout(Some(REQUEST_TIMEOUT));
    let _ = stream.set_write_timeout(Some(REQUEST_TIMEOUT));

    stream
        .write_all(&wire)
        .map_err(|e| err(format!("http: send: {e}")))?;

    // Read until the codec says the message is complete, or the peer closes.
    let mut buf = Vec::new();
    let mut chunk = [0u8; 4096];
    loop {
        match http::message_length(&buf) {
            Ok(Some(_)) => break,
            Ok(None) => {}
            Err(e) => return Err(err(format!("http: {e}"))),
        }
        let n = stream
            .read(&mut chunk)
            .map_err(|e| err(format!("http: recv: {e}")))?;
        if n == 0 {
            break; // peer closed; parse what we have
        }
        buf.extend_from_slice(&chunk[..n]);
        if buf.len() > http::MAX_HEAD_BYTES + http::MAX_BODY_BYTES {
            return Err(err("http: response exceeds maximum size"));
        }
    }

    // Verified active close.
    machine
        .on_event(TcpEvent::Close)
        .map_err(|_| err("http: internal state error"))?;
    drop(stream);
    for ev in [TcpEvent::AckReceived, TcpEvent::FinReceived, TcpEvent::Timeout] {
        machine
            .on_event(ev)
            .map_err(|_| err("http: internal state error"))?;
    }

    let resp = http::parse_response(&buf).map_err(|e| err(format!("http: {e}")))?;
    Ok(String::from_utf8_lossy(&resp.body).into_owned())
}

#[cfg(test)]
mod tests {
    use super::*;

    const REQ: &str = "POST /kira HTTP/1.1\r\nHost: a.test\r\nX-Ujian: nilai\r\nContent-Length: 4\r\n\r\ndata";

    fn s(name: &str, v: &str) -> Value {
        apply(name, &Value::String(v.to_string()))
            .expect("no error")
            .expect("ours")
    }

    fn pair(name: &str, a: &str, b: &str) -> Result<Value> {
        let arg = Value::Pair(
            Box::new(Value::String(a.to_string())),
            Box::new(Value::String(b.to_string())),
        );
        Ok(apply(name, &arg)?.expect("ours"))
    }

    #[test]
    fn parses_method_target_and_body() {
        assert_eq!(s("http_hurai_kaedah", REQ), Value::String("POST".into()));
        assert_eq!(s("http_hurai_laluan", REQ), Value::String("/kira".into()));
        assert_eq!(s("http_hurai_jasad", REQ), Value::String("data".into()));
    }

    #[test]
    fn header_lookup_is_case_insensitive_and_absent_is_empty() {
        assert_eq!(
            pair("http_hurai_kepala", REQ, "X-UJIAN").expect("ok"),
            Value::String("nilai".into())
        );
        assert_eq!(
            pair("http_hurai_kepala", REQ, "X-Tiada").expect("ok"),
            Value::String(String::new())
        );
    }

    /// A smuggling attempt surfaces as an error inside the RIINA program, not
    /// as a silently mis-framed request.
    #[test]
    fn smuggled_request_is_an_error_not_a_parse() {
        let smuggle = "POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 4\r\nTransfer-Encoding: chunked\r\n\r\ndata";
        let e = apply("http_hurai_laluan", &Value::String(smuggle.into()))
            .expect_err("must reject");
        assert!(format!("{e:?}").contains("smuggling"), "{e:?}");
    }

    #[test]
    fn builds_a_framed_response() {
        let arg = Value::Pair(
            Box::new(Value::Int(200)),
            Box::new(Value::String("<h1>halo</h1>".into())),
        );
        let out = apply("http_balas", &arg).expect("no error").expect("ours");
        let Value::String(wire) = out else {
            panic!("expected string");
        };
        assert!(wire.starts_with("HTTP/1.1 200 OK\r\n"), "{wire}");
        assert!(wire.contains("Content-Length: 13\r\n"), "{wire}");
        assert!(wire.ends_with("\r\n\r\n<h1>halo</h1>"), "{wire}");
    }

    /// A body carrying CRLF cannot split the response: framing is computed, and
    /// the body is length-delimited rather than interpolated into the head.
    #[test]
    fn response_body_cannot_split_the_message() {
        let arg = Value::Pair(
            Box::new(Value::Int(200)),
            Box::new(Value::String("a\r\nSet-Cookie: pwned=1".into())),
        );
        let out = apply("http_balas", &arg).expect("no error").expect("ours");
        let Value::String(wire) = out else {
            panic!("expected string");
        };
        let head_end = wire.find("\r\n\r\n").expect("has head");
        assert!(
            !wire[..head_end].to_lowercase().contains("set-cookie"),
            "body leaked into the head: {wire}"
        );
    }

    /// Applying a pair builtin to one value curries, matching interp.rs.
    #[test]
    fn single_argument_curries() {
        let out = apply("http_balas", &Value::Int(200))
            .expect("no error")
            .expect("ours");
        assert!(matches!(out, Value::BuiltinPartial(ref n, _) if n == "http_balas"));
    }

    /// https must be refused, never silently downgraded to cleartext.
    #[test]
    fn https_request_is_refused() {
        let e = perform_request("GET", "https://bank.test/").expect_err("must refuse");
        assert!(format!("{e:?}").contains("REQ-73"), "{e:?}");
    }

    #[test]
    fn non_http_url_is_refused() {
        assert!(perform_request("GET", "ftp://a.test/").is_err());
    }

    #[test]
    fn unknown_name_falls_through() {
        assert!(apply("bukan_milik_kami", &Value::Unit).expect("no error").is_none());
    }
}
