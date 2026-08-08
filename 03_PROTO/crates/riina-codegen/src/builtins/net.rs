// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Network builtins (`jaring_*`) — real TCP sockets gated by the **verified**
//! RFC 793 state machine.
//!
//! These expose `riina_os::net` — the 1:1 port of the predicate core of
//! `02_FORMAL/coq/domains/VerifiedNetwork.v` (`valid_transition`,
//! `is_strong_cipher`, the TLS 1.3 acceptance policy) — to RIINA programs.
//! Every connection carries a `TcpConnection` state machine that only moves
//! along edges the Coq theorem NET_001_11 (`tcp_state_machine_correct`)
//! proves valid, and every `jaring_hantar`/`jaring_terima` is gated on the
//! machine being ESTABLISHED: sending on a closed or half-open connection is
//! rejected by the model, not by hoping the OS notices.
//!
//! What is REAL vs MODELLED (no overclaiming — Prime Directive 2):
//!   * `jaring_sambung`/`jaring_hantar`/`jaring_terima`/`jaring_tutup`
//!     perform **real** network I/O over OS TCP sockets (`std::net`), with the
//!     verified state machine enforced on top: connect drives
//!     CLOSED→SYN_SENT→ESTABLISHED (the OS performs the actual SYN/SYN-ACK;
//!     we replay the corresponding verified events on success), send/recv
//!     require ESTABLISHED, and close walks the verified active-close path
//!     FIN_WAIT_1→FIN_WAIT_2→TIME_WAIT→CLOSED as the OS completes the
//!     FIN/ACK exchange. The machine's event ordering mirrors, but does not
//!     observe, the kernel's packet exchange.
//!   * `tls_dasar_ok` is the **pure** TLS acceptance policy (NET_001_03
//!     no-downgrade + NET_001_08 cipher strength): real policy, no handshake.
//!     TLS record-layer cryptography is NOT implemented — there is no
//!     dep-free TLS stack in 03_PROTO (Law 8), so no builtin claims to
//!     encrypt traffic.
//!
//! Interpreter-only: not registered in codegen's `builtin_canonical`, so the
//! C/WASM backends fail closed (unbound `jaring_*`) rather than miscompiling.

use crate::value::Value;
use crate::{Error, Result};
use riina_os::net::{tls_policy_accepts, CipherSuite, TcpConnection, TcpEvent, TcpState, TlsVersion};
use std::cell::RefCell;
use std::collections::HashMap;
use std::io::{Read, Write};
use std::net::TcpStream;

/// (BM name, EN name, canonical key).
pub static BUILTINS: &[(&str, &str, &str)] = &[
    ("jaring_sambung", "net_connect", "jaring_sambung"),
    ("jaring_hantar", "net_send", "jaring_hantar"),
    ("jaring_terima", "net_recv", "jaring_terima"),
    ("jaring_tutup", "net_close", "jaring_tutup"),
    ("tls_dasar_ok", "tls_policy_ok", "tls_dasar_ok"),
];

/// One tracked connection: the enforcing verified state machine plus the real
/// socket. The stream is dropped (really closed) when the machine leaves
/// ESTABLISHED via `jaring_tutup`.
struct Conn {
    machine: TcpConnection,
    stream: Option<TcpStream>,
}

#[derive(Default)]
struct NetState {
    next_id: u64,
    conns: HashMap<u64, Conn>,
}

thread_local! {
    static NET: RefCell<NetState> = RefCell::new(NetState::default());
}

fn err(msg: impl Into<String>) -> Error {
    Error::InvalidOperation(msg.into())
}

/// Parse a TLS version string as the Coq `TLSVersion` constructors.
fn parse_tls_version(s: &str) -> Option<TlsVersion> {
    match s.trim() {
        "1.0" | "TLS1.0" | "TLSv1.0" => Some(TlsVersion::Tls1_0),
        "1.1" | "TLS1.1" | "TLSv1.1" => Some(TlsVersion::Tls1_1),
        "1.2" | "TLS1.2" | "TLSv1.2" => Some(TlsVersion::Tls1_2),
        "1.3" | "TLS1.3" | "TLSv1.3" => Some(TlsVersion::Tls1_3),
        _ => None,
    }
}

/// Parse an IANA cipher-suite name as the Coq `CipherSuite` constructors.
fn parse_cipher(s: &str) -> Option<CipherSuite> {
    match s.trim() {
        "TLS_AES_128_GCM_SHA256" => Some(CipherSuite::Aes128GcmSha256),
        "TLS_AES_256_GCM_SHA384" => Some(CipherSuite::Aes256GcmSha384),
        "TLS_CHACHA20_POLY1305_SHA256" => Some(CipherSuite::Chacha20Poly1305Sha256),
        _ => None,
    }
}

pub fn apply(name: &str, arg: &Value) -> Result<Option<Value>> {
    let result = match name {
        // Open a real TCP connection to "host:port", driving the verified
        // machine CLOSED→SYN_SENT (ActiveOpen) →ESTABLISHED (SynAckReceived,
        // replayed when the OS reports the handshake complete). Returns the
        // connection id. On connect failure nothing is registered.
        "jaring_sambung" => {
            let addr = as_str(arg, name)?;
            let mut machine = TcpConnection::new();
            machine
                .on_event(TcpEvent::ActiveOpen)
                .map_err(|_| err("jaring: internal state error"))?;
            let stream = TcpStream::connect(&addr)
                .map_err(|e| err(format!("jaring: sambung {addr}: {e}")))?;
            machine
                .on_event(TcpEvent::SynAckReceived)
                .map_err(|_| err("jaring: internal state error"))?;
            NET.with(|n| {
                let st = &mut *n.borrow_mut();
                let id = st.next_id;
                st.next_id += 1;
                st.conns.insert(
                    id,
                    Conn {
                        machine,
                        stream: Some(stream),
                    },
                );
                Value::Int(id)
            })
        }
        // Send, gated on ESTABLISHED. Returns the byte count written.
        "jaring_hantar" => {
            let Value::Pair(_, _) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let (id, data) = as_pair_int_str(arg, name)?;
            NET.with(|n| -> Result<Value> {
                let st = &mut *n.borrow_mut();
                let conn = st
                    .conns
                    .get_mut(&id)
                    .ok_or_else(|| err("jaring: unknown connection"))?;
                if conn.machine.state() != TcpState::Established {
                    return Err(err("jaring: not established"));
                }
                let stream = conn
                    .stream
                    .as_mut()
                    .ok_or_else(|| err("jaring: not established"))?;
                stream
                    .write_all(data.as_bytes())
                    .map_err(|e| err(format!("jaring: hantar: {e}")))?;
                Ok(Value::Int(data.len() as u64))
            })?
        }
        // Receive up to `max` bytes, gated on ESTABLISHED. Returns the data
        // read (possibly shorter; empty on orderly peer close).
        "jaring_terima" => {
            let Value::Pair(_, _) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let (id, max) = as_pair_int_int(arg, name)?;
            NET.with(|n| -> Result<Value> {
                let st = &mut *n.borrow_mut();
                let conn = st
                    .conns
                    .get_mut(&id)
                    .ok_or_else(|| err("jaring: unknown connection"))?;
                if conn.machine.state() != TcpState::Established {
                    return Err(err("jaring: not established"));
                }
                let stream = conn
                    .stream
                    .as_mut()
                    .ok_or_else(|| err("jaring: not established"))?;
                let cap = usize::try_from(max).map_err(|_| err("jaring: terima: max too large"))?;
                let mut buf = vec![0u8; cap];
                let got = stream
                    .read(&mut buf)
                    .map_err(|e| err(format!("jaring: terima: {e}")))?;
                buf.truncate(got);
                Ok(Value::String(String::from_utf8_lossy(&buf).into_owned()))
            })?
        }
        // Active close: ESTABLISHED --Close--> FIN_WAIT_1, then drop the real
        // socket (the OS sends FIN and completes the exchange) and replay the
        // verified path AckReceived→FIN_WAIT_2, FinReceived→TIME_WAIT,
        // Timeout→CLOSED. The entry stays registered so later sends fail with
        // "not established" from the CLOSED machine. Returns `true`.
        "jaring_tutup" => {
            let id = as_int(arg, name)?;
            NET.with(|n| -> Result<Value> {
                let st = &mut *n.borrow_mut();
                let conn = st
                    .conns
                    .get_mut(&id)
                    .ok_or_else(|| err("jaring: unknown connection"))?;
                conn.machine
                    .on_event(TcpEvent::Close)
                    .map_err(|_| err("jaring: not established"))?;
                drop(conn.stream.take());
                for ev in [TcpEvent::AckReceived, TcpEvent::FinReceived, TcpEvent::Timeout] {
                    conn.machine
                        .on_event(ev)
                        .map_err(|_| err("jaring: internal state error"))?;
                }
                debug_assert_eq!(conn.machine.state(), TcpState::Closed);
                Ok(Value::Bool(true))
            })?
        }
        // Pure TLS acceptance policy: `(version, cipher_suite) -> Bool`.
        // True exactly for TLS 1.3 with one of the three strong AEAD suites
        // (Coq NET_001_03 + NET_001_08). Unknown strings are `false` (fail
        // closed), never an error.
        "tls_dasar_ok" => {
            let Value::Pair(_, _) = arg else {
                return Ok(Some(Value::BuiltinPartial(
                    name.to_string(),
                    Box::new(arg.clone()),
                )));
            };
            let (version, cipher) = as_pair_strings(arg, name)?;
            let ok = match (parse_tls_version(&version), parse_cipher(&cipher)) {
                (Some(v), Some(c)) => tls_policy_accepts(v, c),
                _ => false,
            };
            Value::Bool(ok)
        }
        _ => return Ok(None),
    };
    Ok(Some(result))
}

fn as_int(v: &Value, ctx: &str) -> Result<u64> {
    match v {
        Value::Int(n) => Ok(*n),
        Value::IntN { value, .. } => Ok(*value),
        _ => Err(type_err("int", v, ctx)),
    }
}

fn as_str(v: &Value, ctx: &str) -> Result<String> {
    match v {
        Value::String(s) => Ok(s.clone()),
        _ => Err(type_err("string", v, ctx)),
    }
}

fn as_pair_strings(v: &Value, ctx: &str) -> Result<(String, String)> {
    match v {
        Value::Pair(a, b) => Ok((as_str(a, ctx)?, as_str(b, ctx)?)),
        _ => Err(type_err("(string, string)", v, ctx)),
    }
}

fn as_pair_int_str(v: &Value, ctx: &str) -> Result<(u64, String)> {
    match v {
        Value::Pair(a, b) => Ok((as_int(a, ctx)?, as_str(b, ctx)?)),
        _ => Err(type_err("(int, string)", v, ctx)),
    }
}

fn as_pair_int_int(v: &Value, ctx: &str) -> Result<(u64, u64)> {
    match v {
        Value::Pair(a, b) => Ok((as_int(a, ctx)?, as_int(b, ctx)?)),
        _ => Err(type_err("(int, int)", v, ctx)),
    }
}

fn type_err(expected: &str, found: &Value, ctx: &str) -> Error {
    Error::TypeMismatch {
        expected: expected.to_string(),
        found: format!("{found:?}"),
        context: ctx.to_string(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::net::TcpListener;

    fn s(x: &str) -> Value {
        Value::String(x.to_string())
    }
    fn pair(a: Value, b: Value) -> Value {
        Value::Pair(Box::new(a), Box::new(b))
    }

    /// A loopback echo server for one connection; returns its address.
    fn spawn_echo() -> std::net::SocketAddr {
        let listener = TcpListener::bind("127.0.0.1:0").unwrap();
        let addr = listener.local_addr().unwrap();
        std::thread::spawn(move || {
            if let Ok((mut sock, _)) = listener.accept() {
                let mut buf = [0u8; 1024];
                while let Ok(n) = sock.read(&mut buf) {
                    if n == 0 || sock.write_all(&buf[..n]).is_err() {
                        break;
                    }
                }
            }
        });
        addr
    }

    #[test]
    fn connect_send_recv_close_roundtrip() {
        let addr = spawn_echo();
        let conn = apply("jaring_sambung", &s(&addr.to_string()))
            .unwrap()
            .unwrap();
        let Value::Int(id) = conn else {
            panic!("connect must return an Int id, got {conn:?}")
        };
        assert_eq!(
            apply("jaring_hantar", &pair(Value::Int(id), s("ping"))).unwrap(),
            Some(Value::Int(4))
        );
        assert_eq!(
            apply("jaring_terima", &pair(Value::Int(id), Value::Int(16))).unwrap(),
            Some(Value::String("ping".to_string()))
        );
        assert_eq!(
            apply("jaring_tutup", &Value::Int(id)).unwrap(),
            Some(Value::Bool(true))
        );
    }

    /// The verified-machine gate: after close the machine is CLOSED, so a
    /// send is rejected by the model (NET_001_11 — there is no send edge out
    /// of CLOSED), not by an OS error.
    #[test]
    fn send_after_close_is_rejected_by_the_state_machine() {
        let addr = spawn_echo();
        let Some(Value::Int(id)) = apply("jaring_sambung", &s(&addr.to_string())).unwrap() else {
            panic!("connect failed")
        };
        apply("jaring_tutup", &Value::Int(id)).unwrap();
        let res = apply("jaring_hantar", &pair(Value::Int(id), s("late")));
        assert!(
            matches!(&res, Err(Error::InvalidOperation(m)) if m.contains("not established")),
            "send on CLOSED must be rejected, got {res:?}"
        );
        // Double close: the CLOSED machine has no Close edge either.
        let res = apply("jaring_tutup", &Value::Int(id));
        assert!(
            matches!(&res, Err(Error::InvalidOperation(m)) if m.contains("not established")),
            "double close must be rejected, got {res:?}"
        );
    }

    #[test]
    fn unknown_connection_is_an_error() {
        let res = apply("jaring_hantar", &pair(Value::Int(999_999), s("x")));
        assert!(matches!(&res, Err(Error::InvalidOperation(m)) if m.contains("unknown connection")));
    }

    #[test]
    fn connect_refused_registers_nothing() {
        // Port 1 on loopback is essentially never listening.
        let before = NET.with(|n| n.borrow().conns.len());
        let res = apply("jaring_sambung", &s("127.0.0.1:1"));
        assert!(res.is_err(), "connect to a dead port must error");
        let after = NET.with(|n| n.borrow().conns.len());
        assert_eq!(before, after, "failed connect must not register a connection");
    }

    /// NET_001_03 + NET_001_08 at the surface: only TLS 1.3 × strong suite
    /// passes; downgrades and unknown strings fail closed.
    #[test]
    fn tls_policy_accepts_only_13_with_strong_suite() {
        let ok = |v: &str, c: &str| {
            apply("tls_dasar_ok", &pair(s(v), s(c))).unwrap() == Some(Value::Bool(true))
        };
        assert!(ok("1.3", "TLS_AES_128_GCM_SHA256"));
        assert!(ok("TLSv1.3", "TLS_CHACHA20_POLY1305_SHA256"));
        assert!(!ok("1.2", "TLS_AES_128_GCM_SHA256"), "downgrade must be rejected");
        assert!(!ok("1.0", "TLS_AES_256_GCM_SHA384"));
        assert!(!ok("1.3", "TLS_RSA_WITH_RC4_128_SHA"), "weak/unknown suite fails closed");
        assert!(!ok("bogus", "TLS_AES_128_GCM_SHA256"));
    }

    #[test]
    fn unknown_name_returns_none() {
        assert_eq!(apply("not_a_net_builtin", &Value::Unit).unwrap(), None);
    }
}
