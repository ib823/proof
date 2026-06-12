// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! JSON-RPC message reader/writer over stdio.

use crate::json::{self, JsonValue};
use std::io::{self, BufRead, Write};

/// Read a JSON-RPC message from stdin (Content-Length framed).
pub fn read_message(reader: &mut impl BufRead) -> io::Result<JsonValue> {
    read_message_bounded(reader, usize::MAX)
}

/// Read a JSON-RPC message with a maximum body size limit.
///
/// Returns an error if Content-Length exceeds `max_bytes`.
/// Use this in security-sensitive contexts (MCP server) to prevent
/// OOM from malicious or broken clients.
pub fn read_message_bounded(reader: &mut impl BufRead, max_bytes: usize) -> io::Result<JsonValue> {
    // Read headers (limit header section to 64 lines to prevent header flooding)
    let mut content_length: usize = 0;
    let mut header_count = 0;
    loop {
        let mut line = String::new();
        reader.read_line(&mut line)?;
        let line = line.trim();
        if line.is_empty() {
            break;
        }
        header_count += 1;
        if header_count > 64 {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Too many headers (max 64)",
            ));
        }
        if let Some(len_str) = line.strip_prefix("Content-Length: ") {
            content_length = len_str.parse().map_err(|e| {
                io::Error::new(
                    io::ErrorKind::InvalidData,
                    format!("Bad Content-Length: {e}"),
                )
            })?;
        }
    }

    if content_length == 0 {
        return Err(io::Error::new(
            io::ErrorKind::UnexpectedEof,
            "No Content-Length",
        ));
    }

    if content_length > max_bytes {
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            format!(
                "Message too large: {} bytes (max {})",
                content_length, max_bytes
            ),
        ));
    }

    // Read body
    let mut buf = vec![0u8; content_length];
    reader.read_exact(&mut buf)?;
    let body = String::from_utf8(buf)
        .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, format!("Bad UTF-8: {e}")))?;

    json::parse(&body)
        .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, format!("Bad JSON: {e}")))
}

/// Write a JSON-RPC message to stdout (Content-Length framed).
pub fn write_message(writer: &mut impl Write, msg: &JsonValue) -> io::Result<()> {
    let body = msg.to_string();
    write!(writer, "Content-Length: {}\r\n\r\n{}", body.len(), body)?;
    writer.flush()
}

/// Build a JSON-RPC response.
pub fn response(id: JsonValue, result: JsonValue) -> JsonValue {
    json::obj(vec![
        ("jsonrpc", JsonValue::String("2.0".into())),
        ("id", id),
        ("result", result),
    ])
}

/// Build a JSON-RPC notification.
pub fn notification(method: &str, params: JsonValue) -> JsonValue {
    json::obj(vec![
        ("jsonrpc", JsonValue::String("2.0".into())),
        ("method", JsonValue::String(method.into())),
        ("params", params),
    ])
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_read_message() {
        let body = r#"{"a":2,"id":1}"#;
        let input = format!("Content-Length: {}\r\n\r\n{}", body.len(), body);
        let mut reader = io::BufReader::new(input.as_bytes());
        let msg = read_message(&mut reader).unwrap();
        assert_eq!(msg.get("id"), Some(&JsonValue::Number(1.0)));
    }

    #[test]
    fn test_write_message() {
        let msg = json::obj(vec![("id", JsonValue::Number(1.0))]);
        let mut buf = Vec::new();
        write_message(&mut buf, &msg).unwrap();
        let s = String::from_utf8(buf).unwrap();
        assert!(s.starts_with("Content-Length: "));
        assert!(s.contains("\"id\":1"));
    }

    // ─── Adversarial / boundary tests ────────────────────────────────

    #[test]
    fn test_bounded_rejects_oversized() {
        let body = r#"{"id":1}"#;
        let input = format!("Content-Length: {}\r\n\r\n{}", body.len(), body);
        let mut reader = io::BufReader::new(input.as_bytes());
        // Set limit smaller than the body
        let err = read_message_bounded(&mut reader, 4).unwrap_err();
        assert_eq!(err.kind(), io::ErrorKind::InvalidData);
        assert!(err.to_string().contains("too large"));
    }

    #[test]
    fn test_bounded_accepts_within_limit() {
        let body = r#"{"id":1}"#;
        let input = format!("Content-Length: {}\r\n\r\n{}", body.len(), body);
        let mut reader = io::BufReader::new(input.as_bytes());
        let msg = read_message_bounded(&mut reader, 1024).unwrap();
        assert_eq!(msg.get("id"), Some(&JsonValue::Number(1.0)));
    }

    #[test]
    fn test_bounded_exact_limit() {
        let body = r#"{"id":1}"#;
        let input = format!("Content-Length: {}\r\n\r\n{}", body.len(), body);
        let mut reader = io::BufReader::new(input.as_bytes());
        // Limit exactly equal to body size — should succeed
        let msg = read_message_bounded(&mut reader, body.len()).unwrap();
        assert_eq!(msg.get("id"), Some(&JsonValue::Number(1.0)));
    }

    #[test]
    fn test_header_flooding_rejected() {
        // 70 headers should trigger the 64-header limit
        let mut input = String::new();
        for i in 0..70 {
            input.push_str(&format!("X-Custom-{i}: value\r\n"));
        }
        input.push_str("Content-Length: 2\r\n\r\n{}");
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message_bounded(&mut reader, 1024).unwrap_err();
        assert!(err.to_string().contains("Too many headers"));
    }

    #[test]
    fn test_no_content_length() {
        let input = "X-Custom: value\r\n\r\n";
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message(&mut reader).unwrap_err();
        assert_eq!(err.kind(), io::ErrorKind::UnexpectedEof);
        assert!(err.to_string().contains("No Content-Length"));
    }

    #[test]
    fn test_bad_content_length_value() {
        let input = "Content-Length: not_a_number\r\n\r\n";
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message(&mut reader).unwrap_err();
        assert!(err.to_string().contains("Bad Content-Length"));
    }

    #[test]
    fn test_truncated_body() {
        // Content-Length says 100 but only 10 bytes follow
        let input = "Content-Length: 100\r\n\r\n{\"id\":1}xx";
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message(&mut reader).unwrap_err();
        // Should get UnexpectedEof from read_exact
        assert_eq!(err.kind(), io::ErrorKind::UnexpectedEof);
    }

    #[test]
    fn test_invalid_utf8_body() {
        // Valid Content-Length but body has invalid UTF-8
        let header = b"Content-Length: 4\r\n\r\n";
        let bad_bytes: &[u8] = &[0xFF, 0xFE, 0x80, 0x81];
        let mut input = Vec::new();
        input.extend_from_slice(header);
        input.extend_from_slice(bad_bytes);
        let mut reader = io::BufReader::new(input.as_slice());
        let err = read_message(&mut reader).unwrap_err();
        assert!(err.to_string().contains("Bad UTF-8"));
    }

    #[test]
    fn test_malformed_json_body() {
        let body = "{not valid json at all";
        let input = format!("Content-Length: {}\r\n\r\n{}", body.len(), body);
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message(&mut reader).unwrap_err();
        assert!(err.to_string().contains("Bad JSON"));
    }

    #[test]
    fn test_empty_input_eof() {
        let input = "";
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message(&mut reader).unwrap_err();
        // Empty input → reads empty line immediately → "No Content-Length"
        assert_eq!(err.kind(), io::ErrorKind::UnexpectedEof);
    }

    #[test]
    fn test_content_length_zero() {
        let input = "Content-Length: 0\r\n\r\n";
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message(&mut reader).unwrap_err();
        assert!(err.to_string().contains("No Content-Length"));
    }

    #[test]
    fn test_multiple_messages_sequential() {
        let body1 = r#"{"id":1}"#;
        let body2 = r#"{"id":2}"#;
        let input = format!(
            "Content-Length: {}\r\n\r\n{}Content-Length: {}\r\n\r\n{}",
            body1.len(),
            body1,
            body2.len(),
            body2
        );
        let mut reader = io::BufReader::new(input.as_bytes());
        let msg1 = read_message(&mut reader).unwrap();
        let msg2 = read_message(&mut reader).unwrap();
        assert_eq!(msg1.get("id"), Some(&JsonValue::Number(1.0)));
        assert_eq!(msg2.get("id"), Some(&JsonValue::Number(2.0)));
    }

    #[test]
    fn test_unicode_body() {
        // Valid UTF-8 with multi-byte chars
        let body = r#"{"name":"日本語テスト"}"#;
        let input = format!("Content-Length: {}\r\n\r\n{}", body.len(), body);
        let mut reader = io::BufReader::new(input.as_bytes());
        let msg = read_message(&mut reader).unwrap();
        assert_eq!(
            msg.get("name"),
            Some(&JsonValue::String("日本語テスト".into()))
        );
    }

    #[test]
    fn test_negative_content_length() {
        // Negative number parses as error for usize
        let input = "Content-Length: -1\r\n\r\n";
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message(&mut reader).unwrap_err();
        assert!(err.to_string().contains("Bad Content-Length"));
    }

    #[test]
    fn test_huge_content_length_bounded() {
        // Content-Length claims 4GB but bounded to 1MB
        let input = "Content-Length: 4294967296\r\n\r\n";
        let mut reader = io::BufReader::new(input.as_bytes());
        let err = read_message_bounded(&mut reader, 1_048_576).unwrap_err();
        assert!(err.to_string().contains("too large"));
    }
}
