// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Minimal HTTP/1.1 client using `std::net::TcpStream`.
//!
//! Supports GET, HEAD, and POST methods over plain HTTP.
//! HTTPS is **not** supported — deploy behind a TLS-terminating reverse proxy
//! for encrypted transport.

use crate::error::{PkgError, Result};
use std::io::{BufRead, BufReader, Read, Write};
use std::net::TcpStream;

/// Parsed HTTP response.
#[derive(Debug)]
pub(crate) struct HttpResponse {
    pub status: u16,
    #[allow(dead_code)] // Part of public(crate) API, used by consumers
    pub headers: Vec<(String, String)>,
    pub body: Vec<u8>,
}

impl HttpResponse {
    /// Get the first header value matching `name` (case-insensitive).
    #[allow(dead_code)] // Part of public(crate) API
    pub fn header(&self, name: &str) -> Option<&str> {
        let lower = name.to_ascii_lowercase();
        self.headers
            .iter()
            .find(|(k, _)| k.to_ascii_lowercase() == lower)
            .map(|(_, v)| v.as_str())
    }
}

/// Parsed components of an HTTP URL.
struct UrlParts {
    host: String,
    port: u16,
    path: String,
}

/// Parse an `http://host[:port]/path` URL.
fn parse_url(url: &str) -> Result<UrlParts> {
    let rest = url
        .strip_prefix("http://")
        .ok_or_else(|| PkgError::Network {
            message: format!("unsupported URL scheme (only http:// supported): {url}"),
        })?;

    let (authority, path) = match rest.find('/') {
        Some(i) => (&rest[..i], &rest[i..]),
        None => (rest, "/"),
    };

    let (host, port) = match authority.rfind(':') {
        Some(i) => {
            let port_str = &authority[i + 1..];
            let port = port_str.parse::<u16>().map_err(|_| PkgError::Network {
                message: format!("invalid port in URL: {port_str}"),
            })?;
            (authority[..i].to_string(), port)
        }
        None => (authority.to_string(), 80),
    };

    if host.is_empty() {
        return Err(PkgError::Network {
            message: "empty host in URL".to_string(),
        });
    }

    Ok(UrlParts {
        host,
        port,
        path: path.to_string(),
    })
}

/// Send a GET request.
pub(crate) fn get(url: &str) -> Result<HttpResponse> {
    request("GET", url, None, &[])
}

/// Send a HEAD request.
pub(crate) fn head(url: &str) -> Result<HttpResponse> {
    request("HEAD", url, None, &[])
}

/// Send a POST request with a body.
pub(crate) fn post(url: &str, content_type: &str, body: &[u8]) -> Result<HttpResponse> {
    request("POST", url, Some(content_type), body)
}

/// Build and send an HTTP/1.1 request, returning the parsed response.
fn request(
    method: &str,
    url: &str,
    content_type: Option<&str>,
    body: &[u8],
) -> Result<HttpResponse> {
    let parts = parse_url(url)?;
    let addr = format!("{}:{}", parts.host, parts.port);

    let mut stream = TcpStream::connect(&addr).map_err(|e| PkgError::Network {
        message: format!("failed to connect to {addr}: {e}"),
    })?;

    // Build request
    let mut req = format!(
        "{method} {path} HTTP/1.1\r\n\
         Host: {host}\r\n\
         Connection: close\r\n\
         User-Agent: riina-pkg/0.1.0\r\n",
        path = parts.path,
        host = parts.host,
    );

    if !body.is_empty() {
        req.push_str(&format!("Content-Length: {}\r\n", body.len()));
    }
    if let Some(ct) = content_type {
        req.push_str(&format!("Content-Type: {ct}\r\n"));
    }
    req.push_str("\r\n");

    stream
        .write_all(req.as_bytes())
        .map_err(|e| PkgError::Network {
            message: format!("failed to send request to {addr}: {e}"),
        })?;
    if !body.is_empty() {
        stream.write_all(body).map_err(|e| PkgError::Network {
            message: format!("failed to send request body to {addr}: {e}"),
        })?;
    }
    stream.flush().map_err(|e| PkgError::Network {
        message: format!("failed to flush request to {addr}: {e}"),
    })?;

    let is_head = method == "HEAD";
    read_response(stream, is_head)
}

/// Read and parse an HTTP response from a stream.
fn read_response(stream: TcpStream, head_only: bool) -> Result<HttpResponse> {
    let mut reader = BufReader::new(stream);

    // Status line: "HTTP/1.1 200 OK\r\n"
    let mut status_line = String::new();
    reader
        .read_line(&mut status_line)
        .map_err(|e| PkgError::Network {
            message: format!("failed to read status line: {e}"),
        })?;

    let status = parse_status_code(&status_line)?;

    // Headers
    let mut headers = Vec::new();
    loop {
        let mut line = String::new();
        reader.read_line(&mut line).map_err(|e| PkgError::Network {
            message: format!("failed to read header: {e}"),
        })?;
        let trimmed = line.trim_end_matches(['\r', '\n']);
        if trimmed.is_empty() {
            break;
        }
        if let Some(colon) = trimmed.find(':') {
            let key = trimmed[..colon].trim().to_string();
            let val = trimmed[colon + 1..].trim().to_string();
            headers.push((key, val));
        }
    }

    // Body — HEAD responses have no body
    let body = if head_only {
        Vec::new()
    } else {
        read_body(&mut reader, &headers)?
    };

    Ok(HttpResponse {
        status,
        headers,
        body,
    })
}

/// Extract status code from status line.
fn parse_status_code(line: &str) -> Result<u16> {
    // "HTTP/1.1 200 OK"
    let parts: Vec<&str> = line.splitn(3, ' ').collect();
    if parts.len() < 2 {
        return Err(PkgError::Network {
            message: format!("malformed status line: {line}"),
        });
    }
    parts[1].parse::<u16>().map_err(|_| PkgError::Network {
        message: format!("invalid status code: {}", parts[1]),
    })
}

/// Read the response body, handling Content-Length and chunked encoding.
fn read_body(reader: &mut BufReader<TcpStream>, headers: &[(String, String)]) -> Result<Vec<u8>> {
    let content_length = headers
        .iter()
        .find(|(k, _)| k.eq_ignore_ascii_case("content-length"))
        .and_then(|(_, v)| v.parse::<usize>().ok());

    let is_chunked = headers
        .iter()
        .any(|(k, v)| k.eq_ignore_ascii_case("transfer-encoding") && v.contains("chunked"));

    if is_chunked {
        read_chunked(reader)
    } else if let Some(len) = content_length {
        let mut buf = vec![0u8; len];
        reader.read_exact(&mut buf).map_err(|e| PkgError::Network {
            message: format!("failed to read response body: {e}"),
        })?;
        Ok(buf)
    } else {
        // No Content-Length, not chunked: read until EOF
        let mut buf = Vec::new();
        reader
            .read_to_end(&mut buf)
            .map_err(|e| PkgError::Network {
                message: format!("failed to read response body: {e}"),
            })?;
        Ok(buf)
    }
}

/// Read a chunked transfer-encoded body.
fn read_chunked(reader: &mut BufReader<TcpStream>) -> Result<Vec<u8>> {
    let mut body = Vec::new();
    loop {
        let mut size_line = String::new();
        reader
            .read_line(&mut size_line)
            .map_err(|e| PkgError::Network {
                message: format!("failed to read chunk size: {e}"),
            })?;
        let size_str = size_line.trim();
        let chunk_size = usize::from_str_radix(size_str, 16).map_err(|_| PkgError::Network {
            message: format!("invalid chunk size: {size_str}"),
        })?;
        if chunk_size == 0 {
            // Read trailing \r\n after final chunk
            let mut _trailer = String::new();
            let _ = reader.read_line(&mut _trailer);
            break;
        }
        let mut chunk = vec![0u8; chunk_size];
        reader
            .read_exact(&mut chunk)
            .map_err(|e| PkgError::Network {
                message: format!("failed to read chunk data: {e}"),
            })?;
        body.extend_from_slice(&chunk);
        // Read trailing \r\n after chunk data
        let mut _crlf = [0u8; 2];
        let _ = reader.read_exact(&mut _crlf);
    }
    Ok(body)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_url_basic() {
        let p = parse_url("http://example.com/api/v1/crates").unwrap();
        assert_eq!(p.host, "example.com");
        assert_eq!(p.port, 80);
        assert_eq!(p.path, "/api/v1/crates");
    }

    #[test]
    fn test_parse_url_with_port() {
        let p = parse_url("http://localhost:8080/foo").unwrap();
        assert_eq!(p.host, "localhost");
        assert_eq!(p.port, 8080);
        assert_eq!(p.path, "/foo");
    }

    #[test]
    fn test_parse_url_no_path() {
        let p = parse_url("http://localhost:3000").unwrap();
        assert_eq!(p.host, "localhost");
        assert_eq!(p.port, 3000);
        assert_eq!(p.path, "/");
    }

    #[test]
    fn test_parse_url_rejects_https() {
        assert!(parse_url("https://example.com/foo").is_err());
    }

    #[test]
    fn test_parse_status_code() {
        assert_eq!(parse_status_code("HTTP/1.1 200 OK\r\n").unwrap(), 200);
        assert_eq!(
            parse_status_code("HTTP/1.1 404 Not Found\r\n").unwrap(),
            404
        );
        assert_eq!(parse_status_code("HTTP/1.0 301 Moved\r\n").unwrap(), 301);
    }

    #[test]
    fn test_parse_status_code_invalid() {
        assert!(parse_status_code("garbage").is_err());
    }

    #[test]
    fn test_http_response_header_lookup() {
        let resp = HttpResponse {
            status: 200,
            headers: vec![
                ("Content-Type".to_string(), "application/json".to_string()),
                ("Content-Length".to_string(), "42".to_string()),
            ],
            body: vec![],
        };
        assert_eq!(resp.header("content-type"), Some("application/json"));
        assert_eq!(resp.header("Content-Length"), Some("42"));
        assert_eq!(resp.header("X-Missing"), None);
    }
}
