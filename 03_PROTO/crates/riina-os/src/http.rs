// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! HTTP/1.1 codec — the real message layer above the verified TCP machine
//! (master plan REQ-73).
//!
//! Before this, every HTTP surface in RIINA was **modelled**: `http_get` and
//! `http_post` returned the constant `"200 OK"` with no socket opened, so a
//! `.rii` program could not actually speak HTTP. `jaring_*` provided real TCP
//! (gated by the RFC 793 machine in [`crate::net`]), but anything above it had
//! to be hand-rolled string concatenation in RIINA — which is exactly how
//! request-smuggling and header-injection bugs are written.
//!
//! This module is the missing layer: RFC 9112 message framing, dependency-free
//! (Law 8), with the parser deliberately **strict**.
//!
//! # Why strict parsing is the security boundary
//!
//! HTTP/1.1's real-world vulnerabilities are almost all framing disagreements —
//! two parsers reading one byte stream differently. RIINA's whole thesis is that
//! the compiler refuses the ambiguous case, so this parser does too. It rejects,
//! rather than guesses:
//!
//! * **`Content-Length` together with `Transfer-Encoding`** (RFC 9112 §6.1) —
//!   the classic CL.TE / TE.CL request smuggle.
//! * **Conflicting duplicate `Content-Length` values** (`Content-Length: 5, 6`).
//! * **Whitespace between a field name and its colon** (RFC 9112 §5.1) — the
//!   `Foo : bar` smuggle that some parsers accept and others do not.
//! * **Bare CR or LF inside a field value** — response/header injection.
//! * **A missing `Host` header on HTTP/1.1** (RFC 9112 §3.2).
//! * **Anything but HTTP/1.0 or HTTP/1.1**, and any oversized message.
//!
//! Encoding is equally strict: a header name or value carrying CR, LF or NUL is
//! refused rather than serialised, so a RIINA program cannot emit a split
//! response even if it passes attacker-controlled data straight through.
//!
//! # What this is NOT
//!
//! No TLS. `https://` cannot be spoken here — the record layer is the still-open
//! half of REQ-73 and needs an owner decision on Law 8 (see the master plan).
//! Chunked *decoding* is not implemented: a chunked message is rejected as
//! unsupported rather than mis-framed, which is the safe direction.

use std::collections::BTreeMap;

/// Largest request/response head (start line + headers) accepted, in bytes.
/// Bounds memory for a hostile peer; 64 KiB is above any legitimate head.
pub const MAX_HEAD_BYTES: usize = 64 * 1024;

/// Largest number of header fields accepted.
pub const MAX_HEADERS: usize = 128;

/// Largest body accepted, in bytes (8 MiB).
pub const MAX_BODY_BYTES: usize = 8 * 1024 * 1024;

/// Why an HTTP message was rejected.
///
/// Every variant is a REFUSAL, never a repair: a message that could be read two
/// ways is an error, not a guess.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum HttpError {
    /// The head exceeded [`MAX_HEAD_BYTES`], or the body [`MAX_BODY_BYTES`].
    TooLarge { what: &'static str, limit: usize },
    /// More than [`MAX_HEADERS`] header fields.
    TooManyHeaders,
    /// The message had no `\r\n\r\n` head terminator.
    Incomplete,
    /// The request/status line was malformed.
    BadStartLine(String),
    /// Only HTTP/1.0 and HTTP/1.1 are handled.
    UnsupportedVersion(String),
    /// A header line was malformed.
    BadHeader(String),
    /// Whitespace between field name and colon (RFC 9112 §5.1).
    WhitespaceBeforeColon(String),
    /// `Content-Length` and `Transfer-Encoding` both present — request
    /// smuggling (RFC 9112 §6.1).
    ConflictingFraming,
    /// Duplicate `Content-Length` with differing values.
    ConflictingContentLength { first: u64, second: u64 },
    /// `Content-Length` was not a plain non-negative integer.
    BadContentLength(String),
    /// Chunked transfer coding is not implemented; rejected, never mis-framed.
    ChunkedUnsupported,
    /// HTTP/1.1 request without a `Host` header (RFC 9112 §3.2).
    MissingHost,
    /// A control character (CR, LF, NUL) appeared where it cannot be encoded.
    ControlCharacter { field: String },
    /// The body was shorter than the declared `Content-Length`.
    BodyTruncated { declared: u64, actual: usize },
}

impl std::fmt::Display for HttpError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::TooLarge { what, limit } => write!(f, "{what} exceeds {limit} bytes"),
            Self::TooManyHeaders => write!(f, "more than {MAX_HEADERS} header fields"),
            Self::Incomplete => write!(f, "incomplete message: no CRLFCRLF head terminator"),
            Self::BadStartLine(l) => write!(f, "malformed start line: {l:?}"),
            Self::UnsupportedVersion(v) => {
                write!(f, "unsupported HTTP version {v:?} (only HTTP/1.0 and HTTP/1.1)")
            }
            Self::BadHeader(h) => write!(f, "malformed header line: {h:?}"),
            Self::WhitespaceBeforeColon(n) => write!(
                f,
                "whitespace between field name and colon in {n:?} (RFC 9112 §5.1: request smuggling)"
            ),
            Self::ConflictingFraming => write!(
                f,
                "both Content-Length and Transfer-Encoding present (RFC 9112 §6.1: request smuggling)"
            ),
            Self::ConflictingContentLength { first, second } => {
                write!(f, "conflicting Content-Length values: {first} and {second}")
            }
            Self::BadContentLength(v) => write!(f, "invalid Content-Length {v:?}"),
            Self::ChunkedUnsupported => {
                write!(f, "chunked transfer coding is not supported (rejected, not mis-framed)")
            }
            Self::MissingHost => write!(f, "HTTP/1.1 request without a Host header"),
            Self::ControlCharacter { field } => {
                write!(f, "control character (CR/LF/NUL) in {field:?}")
            }
            Self::BodyTruncated { declared, actual } => {
                write!(f, "body truncated: Content-Length {declared}, got {actual} bytes")
            }
        }
    }
}

/// HTTP version, restricted to what this codec handles.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Version {
    Http10,
    Http11,
}

impl Version {
    fn parse(s: &str) -> Result<Self, HttpError> {
        match s {
            "HTTP/1.0" => Ok(Self::Http10),
            "HTTP/1.1" => Ok(Self::Http11),
            other => Err(HttpError::UnsupportedVersion(other.to_string())),
        }
    }

    #[must_use]
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::Http10 => "HTTP/1.0",
            Self::Http11 => "HTTP/1.1",
        }
    }
}

/// Header fields, keyed by LOWERCASED name so lookup is case-insensitive
/// (RFC 9112 §5) and iteration order is deterministic.
pub type Headers = BTreeMap<String, String>;

/// A parsed request.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Request {
    pub method: String,
    pub target: String,
    pub version: Version,
    pub headers: Headers,
    pub body: Vec<u8>,
}

/// A parsed response.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Response {
    pub version: Version,
    pub status: u16,
    pub reason: String,
    pub headers: Headers,
    pub body: Vec<u8>,
}

/// Reject CR, LF or NUL — the characters that would let a value break framing.
fn reject_control(field: &str, value: &str) -> Result<(), HttpError> {
    if value.bytes().any(|b| b == b'\r' || b == b'\n' || b == 0) {
        return Err(HttpError::ControlCharacter {
            field: field.to_string(),
        });
    }
    Ok(())
}

/// Split a message into (head, body-start-index), requiring CRLFCRLF.
fn split_head(bytes: &[u8]) -> Result<(&[u8], usize), HttpError> {
    let limit = bytes.len().min(MAX_HEAD_BYTES.saturating_add(4));
    let mut i = 0;
    while i + 3 < limit {
        if &bytes[i..i + 4] == b"\r\n\r\n" {
            if i > MAX_HEAD_BYTES {
                return Err(HttpError::TooLarge {
                    what: "head",
                    limit: MAX_HEAD_BYTES,
                });
            }
            return Ok((&bytes[..i], i + 4));
        }
        i += 1;
    }
    if bytes.len() > MAX_HEAD_BYTES {
        return Err(HttpError::TooLarge {
            what: "head",
            limit: MAX_HEAD_BYTES,
        });
    }
    Err(HttpError::Incomplete)
}

/// Parse the header block, enforcing the anti-smuggling rules.
///
/// Returns the headers plus the framing decision (`Some(len)` = body of that
/// length, `None` = no body declared).
fn parse_headers(head_lines: &[&str]) -> Result<(Headers, Option<u64>), HttpError> {
    if head_lines.len() > MAX_HEADERS {
        return Err(HttpError::TooManyHeaders);
    }
    let mut headers = Headers::new();
    let mut content_length: Option<u64> = None;
    let mut saw_transfer_encoding = false;
    let mut chunked = false;

    for line in head_lines {
        let Some(colon) = line.find(':') else {
            return Err(HttpError::BadHeader((*line).to_string()));
        };
        let raw_name = &line[..colon];
        if raw_name.is_empty() {
            return Err(HttpError::BadHeader((*line).to_string()));
        }
        // RFC 9112 §5.1: no whitespace is allowed between field name and colon.
        // Accepting it is a documented request-smuggling vector.
        if raw_name.ends_with(' ') || raw_name.ends_with('\t') {
            return Err(HttpError::WhitespaceBeforeColon(raw_name.to_string()));
        }
        let name = raw_name.to_ascii_lowercase();
        let value = line[colon + 1..].trim_matches(|c| c == ' ' || c == '\t');

        match name.as_str() {
            "content-length" => {
                // A single field may carry a comma list; every element must
                // agree, otherwise the message frames two ways.
                for part in value.split(',') {
                    let part = part.trim();
                    let parsed: u64 = part
                        .parse()
                        .map_err(|_| HttpError::BadContentLength(part.to_string()))?;
                    match content_length {
                        None => content_length = Some(parsed),
                        Some(prev) if prev != parsed => {
                            return Err(HttpError::ConflictingContentLength {
                                first: prev,
                                second: parsed,
                            });
                        }
                        Some(_) => {}
                    }
                }
            }
            "transfer-encoding" => {
                saw_transfer_encoding = true;
                if value.to_ascii_lowercase().contains("chunked") {
                    chunked = true;
                }
            }
            _ => {}
        }

        // Later duplicates of other fields are joined per RFC 9112 §5.2.
        headers
            .entry(name)
            .and_modify(|existing| {
                existing.push_str(", ");
                existing.push_str(value);
            })
            .or_insert_with(|| value.to_string());
    }

    if saw_transfer_encoding && content_length.is_some() {
        return Err(HttpError::ConflictingFraming);
    }
    if chunked {
        return Err(HttpError::ChunkedUnsupported);
    }
    if saw_transfer_encoding {
        // A transfer coding we do not implement — refuse rather than guess the
        // body length.
        return Err(HttpError::ChunkedUnsupported);
    }
    Ok((headers, content_length))
}

/// Parse an HTTP/1.x request.
///
/// # Errors
/// Any [`HttpError`]; in particular every framing ambiguity listed on this
/// module is an error rather than a repaired message.
pub fn parse_request(bytes: &[u8]) -> Result<Request, HttpError> {
    let (head, body_start) = split_head(bytes)?;
    let head = std::str::from_utf8(head)
        .map_err(|_| HttpError::BadStartLine("non-UTF-8 head".to_string()))?;
    let mut lines = head.split("\r\n");
    let start = lines.next().unwrap_or_default();

    let mut parts = start.split(' ');
    let (Some(method), Some(target), Some(version)) = (parts.next(), parts.next(), parts.next())
    else {
        return Err(HttpError::BadStartLine(start.to_string()));
    };
    if parts.next().is_some() || method.is_empty() || target.is_empty() {
        return Err(HttpError::BadStartLine(start.to_string()));
    }
    if !method.bytes().all(|b| b.is_ascii_alphabetic()) {
        return Err(HttpError::BadStartLine(start.to_string()));
    }
    let version = Version::parse(version)?;

    let header_lines: Vec<&str> = lines.filter(|l| !l.is_empty()).collect();
    let (headers, content_length) = parse_headers(&header_lines)?;

    if version == Version::Http11 && !headers.contains_key("host") {
        return Err(HttpError::MissingHost);
    }

    let body = extract_body(bytes, body_start, content_length)?;
    Ok(Request {
        method: method.to_string(),
        target: target.to_string(),
        version,
        headers,
        body,
    })
}

/// Parse an HTTP/1.x response.
///
/// # Errors
/// Any [`HttpError`].
pub fn parse_response(bytes: &[u8]) -> Result<Response, HttpError> {
    let (head, body_start) = split_head(bytes)?;
    let head = std::str::from_utf8(head)
        .map_err(|_| HttpError::BadStartLine("non-UTF-8 head".to_string()))?;
    let mut lines = head.split("\r\n");
    let start = lines.next().unwrap_or_default();

    let mut parts = start.splitn(3, ' ');
    let (Some(version), Some(status)) = (parts.next(), parts.next()) else {
        return Err(HttpError::BadStartLine(start.to_string()));
    };
    let reason = parts.next().unwrap_or("").to_string();
    let version = Version::parse(version)?;
    let status: u16 = status
        .parse()
        .map_err(|_| HttpError::BadStartLine(start.to_string()))?;
    if !(100..=599).contains(&status) {
        return Err(HttpError::BadStartLine(start.to_string()));
    }

    let header_lines: Vec<&str> = lines.filter(|l| !l.is_empty()).collect();
    let (headers, content_length) = parse_headers(&header_lines)?;
    let body = extract_body(bytes, body_start, content_length)?;

    Ok(Response {
        version,
        status,
        reason,
        headers,
        body,
    })
}

/// Take exactly the declared body, refusing a short read.
fn extract_body(
    bytes: &[u8],
    body_start: usize,
    content_length: Option<u64>,
) -> Result<Vec<u8>, HttpError> {
    let available = &bytes[body_start.min(bytes.len())..];
    match content_length {
        None => Ok(Vec::new()),
        Some(len) => {
            let len_usize = usize::try_from(len)
                .map_err(|_| HttpError::BadContentLength(len.to_string()))?;
            if len_usize > MAX_BODY_BYTES {
                return Err(HttpError::TooLarge {
                    what: "body",
                    limit: MAX_BODY_BYTES,
                });
            }
            if available.len() < len_usize {
                return Err(HttpError::BodyTruncated {
                    declared: len,
                    actual: available.len(),
                });
            }
            Ok(available[..len_usize].to_vec())
        }
    }
}

/// How many bytes a complete message occupies, if `bytes` contains one.
///
/// Lets a reader know when to stop pulling from the socket instead of blocking
/// forever. `Ok(None)` means "not yet complete — read more".
///
/// # Errors
/// Propagates a framing error as soon as the head is readable.
pub fn message_length(bytes: &[u8]) -> Result<Option<usize>, HttpError> {
    let (head, body_start) = match split_head(bytes) {
        Ok(v) => v,
        Err(HttpError::Incomplete) => return Ok(None),
        Err(e) => return Err(e),
    };
    let head = std::str::from_utf8(head)
        .map_err(|_| HttpError::BadStartLine("non-UTF-8 head".to_string()))?;
    let header_lines: Vec<&str> = head.split("\r\n").skip(1).filter(|l| !l.is_empty()).collect();
    let (_, content_length) = parse_headers(&header_lines)?;
    let want = body_start + usize::try_from(content_length.unwrap_or(0)).unwrap_or(usize::MAX);
    if bytes.len() >= want {
        Ok(Some(want))
    } else {
        Ok(None)
    }
}

/// Serialise a request. `Content-Length` is always set from the body, so the
/// message cannot frame two ways.
///
/// # Errors
/// [`HttpError::ControlCharacter`] if any component could break framing.
pub fn encode_request(
    method: &str,
    target: &str,
    host: &str,
    headers: &Headers,
    body: &[u8],
) -> Result<Vec<u8>, HttpError> {
    reject_control("method", method)?;
    reject_control("target", target)?;
    reject_control("host", host)?;
    let mut out = format!("{method} {target} HTTP/1.1\r\nHost: {host}\r\n");
    for (name, value) in headers {
        // Framing headers are computed, never taken from the caller.
        if matches!(name.as_str(), "content-length" | "transfer-encoding" | "host") {
            continue;
        }
        reject_control("header name", name)?;
        reject_control("header value", value)?;
        out.push_str(name);
        out.push_str(": ");
        out.push_str(value);
        out.push_str("\r\n");
    }
    out.push_str(&format!("Content-Length: {}\r\n\r\n", body.len()));
    let mut bytes = out.into_bytes();
    bytes.extend_from_slice(body);
    Ok(bytes)
}

/// Serialise a response. As with [`encode_request`], `Content-Length` is
/// computed and `Connection: close` is set, so framing is unambiguous.
///
/// # Errors
/// [`HttpError::ControlCharacter`] if any component could break framing.
pub fn encode_response(
    status: u16,
    reason: &str,
    headers: &Headers,
    body: &[u8],
) -> Result<Vec<u8>, HttpError> {
    reject_control("reason", reason)?;
    let mut out = format!("HTTP/1.1 {status} {reason}\r\n");
    for (name, value) in headers {
        if matches!(
            name.as_str(),
            "content-length" | "transfer-encoding" | "connection"
        ) {
            continue;
        }
        reject_control("header name", name)?;
        reject_control("header value", value)?;
        out.push_str(name);
        out.push_str(": ");
        out.push_str(value);
        out.push_str("\r\n");
    }
    out.push_str(&format!(
        "Content-Length: {}\r\nConnection: close\r\n\r\n",
        body.len()
    ));
    let mut bytes = out.into_bytes();
    bytes.extend_from_slice(body);
    Ok(bytes)
}

/// The conventional reason phrase for a status code.
#[must_use]
pub fn reason_phrase(status: u16) -> &'static str {
    match status {
        200 => "OK",
        201 => "Created",
        204 => "No Content",
        301 => "Moved Permanently",
        302 => "Found",
        304 => "Not Modified",
        400 => "Bad Request",
        401 => "Unauthorized",
        403 => "Forbidden",
        404 => "Not Found",
        405 => "Method Not Allowed",
        408 => "Request Timeout",
        411 => "Length Required",
        413 => "Content Too Large",
        414 => "URI Too Long",
        429 => "Too Many Requests",
        500 => "Internal Server Error",
        501 => "Not Implemented",
        503 => "Service Unavailable",
        505 => "HTTP Version Not Supported",
        _ => "Unknown",
    }
}

/// Split an absolute `http://host[:port]/path` URL into (host_port, target).
///
/// # Errors
/// [`HttpError::BadStartLine`] for a non-`http://` URL. `https://` is rejected
/// explicitly: there is no TLS here, and silently downgrading would be worse
/// than refusing.
pub fn split_url(url: &str) -> Result<(String, String), HttpError> {
    if let Some(rest) = url.strip_prefix("https://") {
        let _ = rest;
        return Err(HttpError::BadStartLine(format!(
            "https is not supported (no TLS record layer yet — master plan REQ-73): {url}"
        )));
    }
    let rest = url
        .strip_prefix("http://")
        .ok_or_else(|| HttpError::BadStartLine(format!("not an http:// URL: {url}")))?;
    let (authority, path) = match rest.find('/') {
        Some(i) => (&rest[..i], &rest[i..]),
        None => (rest, "/"),
    };
    if authority.is_empty() {
        return Err(HttpError::BadStartLine(format!("empty host in URL: {url}")));
    }
    let host_port = if authority.contains(':') {
        authority.to_string()
    } else {
        format!("{authority}:80")
    };
    Ok((host_port, path.to_string()))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn req(bytes: &str) -> Result<Request, HttpError> {
        parse_request(bytes.as_bytes())
    }

    #[test]
    fn parses_a_minimal_request() {
        let r = req("GET /halo HTTP/1.1\r\nHost: contoh.test\r\n\r\n").expect("parses");
        assert_eq!(r.method, "GET");
        assert_eq!(r.target, "/halo");
        assert_eq!(r.version, Version::Http11);
        assert_eq!(r.headers.get("host").map(String::as_str), Some("contoh.test"));
        assert!(r.body.is_empty());
    }

    #[test]
    fn header_lookup_is_case_insensitive() {
        let r = req("GET / HTTP/1.1\r\nHOST: a.test\r\nX-Ujian: nilai\r\n\r\n").expect("parses");
        assert_eq!(r.headers.get("x-ujian").map(String::as_str), Some("nilai"));
    }

    #[test]
    fn reads_a_body_of_declared_length() {
        let r = req("POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 5\r\n\r\nhalo!")
            .expect("parses");
        assert_eq!(r.body, b"halo!");
    }

    // ── framing / smuggling ──────────────────────────────────────────────

    /// CL.TE smuggling: both framing headers present must be refused.
    #[test]
    fn rejects_content_length_with_transfer_encoding() {
        let e = req("POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 5\r\nTransfer-Encoding: chunked\r\n\r\nhalo!")
            .expect_err("must reject");
        assert_eq!(e, HttpError::ConflictingFraming);
    }

    #[test]
    fn rejects_conflicting_duplicate_content_length() {
        let e = req("POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 5\r\nContent-Length: 6\r\n\r\nhalo!")
            .expect_err("must reject");
        assert!(matches!(e, HttpError::ConflictingContentLength { .. }), "{e:?}");
    }

    /// A comma list inside one field must also agree.
    #[test]
    fn rejects_conflicting_content_length_list() {
        let e = req("POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 5, 6\r\n\r\nhalo!")
            .expect_err("must reject");
        assert!(matches!(e, HttpError::ConflictingContentLength { .. }), "{e:?}");
    }

    /// Agreeing duplicates are not ambiguous, so they are accepted.
    #[test]
    fn accepts_agreeing_duplicate_content_length() {
        let r = req("POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 5\r\nContent-Length: 5\r\n\r\nhalo!")
            .expect("agreeing duplicates are unambiguous");
        assert_eq!(r.body, b"halo!");
    }

    /// `Foo : bar` — whitespace before the colon is a smuggling vector.
    #[test]
    fn rejects_whitespace_before_colon() {
        let e = req("GET / HTTP/1.1\r\nHost: a.test\r\nX-Ujian : nilai\r\n\r\n")
            .expect_err("must reject");
        assert!(matches!(e, HttpError::WhitespaceBeforeColon(_)), "{e:?}");
    }

    #[test]
    fn rejects_chunked_rather_than_misframing() {
        let e = req("POST / HTTP/1.1\r\nHost: a.test\r\nTransfer-Encoding: chunked\r\n\r\n0\r\n\r\n")
            .expect_err("must reject");
        assert_eq!(e, HttpError::ChunkedUnsupported);
    }

    #[test]
    fn rejects_truncated_body() {
        let e = req("POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 99\r\n\r\nshort")
            .expect_err("must reject");
        assert!(matches!(e, HttpError::BodyTruncated { .. }), "{e:?}");
    }

    #[test]
    fn rejects_non_numeric_content_length() {
        let e = req("POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 0x10\r\n\r\n")
            .expect_err("must reject");
        assert!(matches!(e, HttpError::BadContentLength(_)), "{e:?}");
    }

    // ── start line / version / host ──────────────────────────────────────

    #[test]
    fn requires_host_on_http11() {
        let e = req("GET / HTTP/1.1\r\n\r\n").expect_err("must reject");
        assert_eq!(e, HttpError::MissingHost);
    }

    #[test]
    fn http10_does_not_require_host() {
        let r = req("GET / HTTP/1.0\r\n\r\n").expect("HTTP/1.0 has no Host requirement");
        assert_eq!(r.version, Version::Http10);
    }

    #[test]
    fn rejects_unsupported_version() {
        let e = req("GET / HTTP/2.0\r\nHost: a.test\r\n\r\n").expect_err("must reject");
        assert!(matches!(e, HttpError::UnsupportedVersion(_)), "{e:?}");
    }

    #[test]
    fn rejects_malformed_start_line() {
        assert!(req("GET /\r\nHost: a.test\r\n\r\n").is_err());
        assert!(req("GET / HTTP/1.1 extra\r\nHost: a.test\r\n\r\n").is_err());
        assert!(req("G3T / HTTP/1.1\r\nHost: a.test\r\n\r\n").is_err());
    }

    #[test]
    fn rejects_incomplete_message() {
        assert_eq!(
            req("GET / HTTP/1.1\r\nHost: a.test\r\n").expect_err("incomplete"),
            HttpError::Incomplete
        );
    }

    #[test]
    fn rejects_too_many_headers() {
        let mut s = String::from("GET / HTTP/1.1\r\nHost: a.test\r\n");
        for i in 0..=MAX_HEADERS {
            s.push_str(&format!("X-{i}: v\r\n"));
        }
        s.push_str("\r\n");
        assert_eq!(req(&s).expect_err("too many"), HttpError::TooManyHeaders);
    }

    #[test]
    fn rejects_oversized_head() {
        let mut s = String::from("GET / HTTP/1.1\r\nHost: a.test\r\nX-Big: ");
        s.push_str(&"a".repeat(MAX_HEAD_BYTES + 16));
        s.push_str("\r\n\r\n");
        let e = req(&s).expect_err("too large");
        assert!(matches!(e, HttpError::TooLarge { .. }), "{e:?}");
    }

    // ── encoding ─────────────────────────────────────────────────────────

    #[test]
    fn encodes_a_response_with_computed_framing() {
        let mut h = Headers::new();
        h.insert("content-type".into(), "text/plain".into());
        let bytes = encode_response(200, reason_phrase(200), &h, b"halo").expect("encodes");
        let s = String::from_utf8(bytes).expect("utf8");
        assert!(s.starts_with("HTTP/1.1 200 OK\r\n"), "{s}");
        assert!(s.contains("Content-Length: 4\r\n"), "{s}");
        assert!(s.ends_with("\r\n\r\nhalo"), "{s}");
    }

    /// A header value carrying CRLF must not be serialised — that is response
    /// splitting.
    #[test]
    fn refuses_to_encode_a_split_response() {
        let mut h = Headers::new();
        h.insert(
            "x-jahat".into(),
            "a\r\nSet-Cookie: pwned=1".into(),
        );
        let e = encode_response(200, "OK", &h, b"").expect_err("must refuse");
        assert!(matches!(e, HttpError::ControlCharacter { .. }), "{e:?}");
    }

    #[test]
    fn refuses_control_characters_in_request_target() {
        let e = encode_request("GET", "/a\r\nX: y", "a.test", &Headers::new(), b"")
            .expect_err("must refuse");
        assert!(matches!(e, HttpError::ControlCharacter { .. }), "{e:?}");
    }

    /// A caller cannot smuggle its own framing headers through the encoder.
    #[test]
    fn caller_supplied_framing_headers_are_ignored() {
        let mut h = Headers::new();
        h.insert("content-length".into(), "999".into());
        h.insert("transfer-encoding".into(), "chunked".into());
        let bytes = encode_response(200, "OK", &h, b"halo").expect("encodes");
        let s = String::from_utf8(bytes).expect("utf8");
        assert!(s.contains("Content-Length: 4\r\n"), "{s}");
        assert!(!s.contains("999"), "caller framing leaked: {s}");
        assert!(!s.to_lowercase().contains("transfer-encoding"), "{s}");
    }

    /// Encode → parse round-trip.
    #[test]
    fn request_round_trips() {
        let mut h = Headers::new();
        h.insert("x-ujian".into(), "nilai".into());
        let bytes = encode_request("POST", "/kira", "a.test:8080", &h, b"data").expect("encodes");
        let r = parse_request(&bytes).expect("parses back");
        assert_eq!(r.method, "POST");
        assert_eq!(r.target, "/kira");
        assert_eq!(r.headers.get("host").map(String::as_str), Some("a.test:8080"));
        assert_eq!(r.headers.get("x-ujian").map(String::as_str), Some("nilai"));
        assert_eq!(r.body, b"data");
    }

    #[test]
    fn response_round_trips() {
        let bytes = encode_response(404, reason_phrase(404), &Headers::new(), b"tiada")
            .expect("encodes");
        let r = parse_response(&bytes).expect("parses back");
        assert_eq!(r.status, 404);
        assert_eq!(r.reason, "Not Found");
        assert_eq!(r.body, b"tiada");
    }

    // ── framing helper ───────────────────────────────────────────────────

    #[test]
    fn message_length_reports_incomplete_then_complete() {
        let partial = b"GET / HTTP/1.1\r\nHost: a.test\r\n";
        assert_eq!(message_length(partial).expect("no error"), None);

        let full = b"POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 4\r\n\r\nhalo";
        assert_eq!(message_length(full).expect("no error"), Some(full.len()));
    }

    #[test]
    fn message_length_surfaces_framing_errors_early() {
        let smuggle = b"POST / HTTP/1.1\r\nHost: a.test\r\nContent-Length: 1\r\nTransfer-Encoding: chunked\r\n\r\nx";
        assert!(message_length(smuggle).is_err());
    }

    // ── URLs ─────────────────────────────────────────────────────────────

    #[test]
    fn splits_http_urls() {
        assert_eq!(
            split_url("http://contoh.test/halo").expect("splits"),
            ("contoh.test:80".to_string(), "/halo".to_string())
        );
        assert_eq!(
            split_url("http://contoh.test:8080").expect("splits"),
            ("contoh.test:8080".to_string(), "/".to_string())
        );
    }

    /// https must be refused loudly, never silently downgraded to cleartext.
    #[test]
    fn refuses_https_rather_than_downgrading() {
        let e = split_url("https://bank.test/").expect_err("must refuse");
        match e {
            HttpError::BadStartLine(m) => assert!(m.contains("REQ-73"), "{m}"),
            other => panic!("wrong error: {other:?}"),
        }
    }
}
