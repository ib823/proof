//! Verified-network state machine and TLS policy.
//!
//! Rust realisation of the predicate core of
//! `02_FORMAL/coq/domains/VerifiedNetwork.v` (25 Qed). Two pieces are ported
//! 1:1 from the Coq `Definition`s:
//!
//! * The RFC 793 TCP state machine — `TCPState`, `TCPEvent` and the
//!   `valid_transition` table. [`TcpConnection`] then *enforces* the table on
//!   every event, so a connection can only ever move along edges the Coq
//!   theorem NET_001_11 (`tcp_state_machine_correct`) proves are the valid
//!   ones: an invalid `(state, event)` pair is rejected, never applied.
//! * The TLS 1.3 acceptance policy — `TLSVersion`, `CipherSuite`,
//!   `is_strong_cipher`, and the decidable conjuncts of `tls_connected`:
//!   a connection is acceptable only at TLS 1.3 (NET_001_03,
//!   `tls_no_downgrade`) with a strong AEAD suite (NET_001_08,
//!   `tls_cipher_strength`).
//!
//! Law 8: std-only, zero third-party dependencies.

// ════════════════════════════════════════════════════════════════════════════
// TCP state machine  (Coq `TCPState` / `TCPEvent` / `valid_transition`)
// ════════════════════════════════════════════════════════════════════════════

/// TCP connection state — Coq `TCPState` (RFC 793 §3.2).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TcpState {
    Closed,
    Listen,
    SynSent,
    SynReceived,
    Established,
    FinWait1,
    FinWait2,
    CloseWait,
    Closing,
    LastAck,
    TimeWait,
}

/// TCP state-machine event — Coq `TCPEvent`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TcpEvent {
    PassiveOpen,
    ActiveOpen,
    SynReceived,
    SynAckReceived,
    AckReceived,
    FinReceived,
    Close,
    Timeout,
}

/// Coq `valid_transition` — the RFC 793 transition table, ported clause by
/// clause. `true` exactly for the `(from, event, to)` triples the Coq match
/// maps to `True`.
#[must_use]
pub fn valid_transition(from: TcpState, event: TcpEvent, to: TcpState) -> bool {
    use TcpEvent as E;
    use TcpState as S;
    matches!(
        (from, event, to),
        (S::Closed, E::PassiveOpen, S::Listen)
            | (S::Closed, E::ActiveOpen, S::SynSent)
            | (S::Listen, E::SynReceived, S::SynReceived)
            | (S::SynSent, E::SynAckReceived, S::Established)
            | (S::SynReceived, E::AckReceived, S::Established)
            | (S::Established, E::FinReceived, S::CloseWait)
            | (S::Established, E::Close, S::FinWait1)
            | (S::FinWait1, E::FinReceived, S::Closing)
            | (S::FinWait1, E::AckReceived, S::FinWait2)
            | (S::FinWait2, E::FinReceived, S::TimeWait)
            | (S::Closing, E::AckReceived, S::TimeWait)
            | (S::CloseWait, E::Close, S::LastAck)
            | (S::LastAck, E::AckReceived, S::Closed)
            | (S::TimeWait, E::Timeout, S::Closed)
    )
}

/// The unique successor state for `(from, event)`, if any. The Coq table is
/// deterministic — each `(from, event)` pair appears in at most one clause —
/// so this function is total over the relation: `next_state(f, e) == Some(t)`
/// iff `valid_transition(f, e, t)`.
#[must_use]
pub fn next_state(from: TcpState, event: TcpEvent) -> Option<TcpState> {
    use TcpEvent as E;
    use TcpState as S;
    let to = match (from, event) {
        (S::Closed, E::PassiveOpen) => S::Listen,
        (S::Closed, E::ActiveOpen) => S::SynSent,
        (S::Listen, E::SynReceived) => S::SynReceived,
        (S::SynSent, E::SynAckReceived) => S::Established,
        (S::SynReceived, E::AckReceived) => S::Established,
        (S::Established, E::FinReceived) => S::CloseWait,
        (S::Established, E::Close) => S::FinWait1,
        (S::FinWait1, E::FinReceived) => S::Closing,
        (S::FinWait1, E::AckReceived) => S::FinWait2,
        (S::FinWait2, E::FinReceived) => S::TimeWait,
        (S::Closing, E::AckReceived) => S::TimeWait,
        (S::CloseWait, E::Close) => S::LastAck,
        (S::LastAck, E::AckReceived) => S::Closed,
        (S::TimeWait, E::Timeout) => S::Closed,
        _ => return None,
    };
    Some(to)
}

/// Network state-machine error.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum NetError {
    /// The event has no valid transition from the current state
    /// (`valid_transition` is false for every target).
    InvalidTransition {
        from: TcpState,
        event: TcpEvent,
    },
}

/// An enforcing TCP connection — the runtime counterpart of the Coq
/// `tcp_transition` relation. The only way to change `state` is
/// [`TcpConnection::on_event`], which applies exactly the `valid_transition`
/// table; NET_001_11 is therefore an invariant of every live value: any state
/// this connection has ever been in was reached through valid transitions
/// only.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TcpConnection {
    state: TcpState,
}

impl TcpConnection {
    /// A fresh connection starts CLOSED (RFC 793 fictional state).
    #[must_use]
    pub fn new() -> Self {
        TcpConnection {
            state: TcpState::Closed,
        }
    }

    #[must_use]
    pub fn state(&self) -> TcpState {
        self.state
    }

    /// Apply `event`. Succeeds with the new state iff the Coq
    /// `valid_transition` table has an edge for `(state, event)`; otherwise
    /// the state is unchanged and the event is rejected.
    pub fn on_event(&mut self, event: TcpEvent) -> Result<TcpState, NetError> {
        match next_state(self.state, event) {
            Some(to) => {
                self.state = to;
                Ok(to)
            }
            None => Err(NetError::InvalidTransition {
                from: self.state,
                event,
            }),
        }
    }
}

impl Default for TcpConnection {
    fn default() -> Self {
        Self::new()
    }
}

// ════════════════════════════════════════════════════════════════════════════
// TLS 1.3 acceptance policy  (Coq `TLSVersion` / `CipherSuite` /
// `is_strong_cipher` / decidable core of `tls_connected`)
// ════════════════════════════════════════════════════════════════════════════

/// TLS protocol version — Coq `TLSVersion`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TlsVersion {
    Tls1_0,
    Tls1_1,
    Tls1_2,
    Tls1_3,
}

/// Negotiable cipher suite — Coq `CipherSuite`. Only the three TLS 1.3 AEAD
/// suites are representable, which is itself the reason NET_001_08 holds.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CipherSuite {
    Aes128GcmSha256,
    Aes256GcmSha384,
    Chacha20Poly1305Sha256,
}

/// Coq `is_strong_cipher` — true for every representable suite (the theorem
/// NET_001_08 `tls_cipher_strength` is `reflexivity` per constructor).
#[must_use]
pub fn is_strong_cipher(cs: CipherSuite) -> bool {
    match cs {
        CipherSuite::Aes128GcmSha256
        | CipherSuite::Aes256GcmSha384
        | CipherSuite::Chacha20Poly1305Sha256 => true,
    }
}

/// The decidable core of the Coq `tls_connected` predicate: accept only
/// TLS 1.3 (NET_001_03 `tls_no_downgrade` — a connection accepted at any
/// lower version would contradict the theorem) with a strong suite
/// (NET_001_08). The remaining `tls_connected` conjuncts (certificate chain,
/// transcript binding, forward secrecy) concern a handshake this prototype
/// does not perform — see the honesty note on the `jaring_*` builtins.
#[must_use]
pub fn tls_policy_accepts(version: TlsVersion, cipher: CipherSuite) -> bool {
    version == TlsVersion::Tls1_3 && is_strong_cipher(cipher)
}

#[cfg(test)]
mod tests {
    use super::*;
    use TcpEvent as E;
    use TcpState as S;

    const ALL_STATES: [TcpState; 11] = [
        S::Closed,
        S::Listen,
        S::SynSent,
        S::SynReceived,
        S::Established,
        S::FinWait1,
        S::FinWait2,
        S::CloseWait,
        S::Closing,
        S::LastAck,
        S::TimeWait,
    ];
    const ALL_EVENTS: [TcpEvent; 8] = [
        E::PassiveOpen,
        E::ActiveOpen,
        E::SynReceived,
        E::SynAckReceived,
        E::AckReceived,
        E::FinReceived,
        E::Close,
        E::Timeout,
    ];

    /// NET_001_11 (`tcp_state_machine_correct`): every transition the
    /// enforcing connection performs satisfies `valid_transition`, exhaustively
    /// over the full (state, event) space.
    #[test]
    fn every_applied_event_is_a_valid_transition() {
        for from in ALL_STATES {
            for event in ALL_EVENTS {
                let mut conn = TcpConnection { state: from };
                match conn.on_event(event) {
                    Ok(to) => assert!(
                        valid_transition(from, event, to),
                        "on_event applied an edge the Coq table does not have: \
                         {from:?} --{event:?}--> {to:?}"
                    ),
                    Err(NetError::InvalidTransition { .. }) => {
                        // Rejected — the table must indeed have no edge.
                        assert!(
                            ALL_STATES.iter().all(|&to| !valid_transition(from, event, to)),
                            "on_event rejected {from:?} --{event:?}-> but the table has an edge"
                        );
                        assert_eq!(conn.state(), from, "rejected event must not change state");
                    }
                }
            }
        }
    }

    /// `next_state` agrees with `valid_transition` in both directions
    /// (the determinism claim under NET_001_11).
    #[test]
    fn next_state_is_the_table() {
        for from in ALL_STATES {
            for event in ALL_EVENTS {
                for to in ALL_STATES {
                    assert_eq!(
                        next_state(from, event) == Some(to),
                        valid_transition(from, event, to),
                        "disagreement at {from:?} --{event:?}--> {to:?}"
                    );
                }
            }
        }
    }

    /// The active-open client lifecycle used by the `jaring_*` builtins:
    /// CLOSED → SYN_SENT → ESTABLISHED → FIN_WAIT_1 → FIN_WAIT_2 → TIME_WAIT
    /// → CLOSED, every step a valid transition.
    #[test]
    fn client_lifecycle_reaches_closed() {
        let mut c = TcpConnection::new();
        assert_eq!(c.on_event(E::ActiveOpen), Ok(S::SynSent));
        assert_eq!(c.on_event(E::SynAckReceived), Ok(S::Established));
        assert_eq!(c.on_event(E::Close), Ok(S::FinWait1));
        assert_eq!(c.on_event(E::AckReceived), Ok(S::FinWait2));
        assert_eq!(c.on_event(E::FinReceived), Ok(S::TimeWait));
        assert_eq!(c.on_event(E::Timeout), Ok(S::Closed));
    }

    /// Data transfer is only meaningful in ESTABLISHED; a CLOSED connection
    /// rejects the events a send would need (there is no edge out of CLOSED
    /// except the two opens).
    #[test]
    fn closed_rejects_everything_but_open() {
        for event in ALL_EVENTS {
            let mut c = TcpConnection::new();
            let ok = c.on_event(event).is_ok();
            assert_eq!(
                ok,
                matches!(event, E::PassiveOpen | E::ActiveOpen),
                "CLOSED must accept exactly the open events, got {event:?} -> {ok}"
            );
        }
    }

    /// NET_001_03 (`tls_no_downgrade`) + NET_001_08 (`tls_cipher_strength`):
    /// the policy accepts exactly TLS 1.3 × strong suite.
    #[test]
    fn tls_policy_is_13_only_with_strong_suites() {
        use CipherSuite as C;
        use TlsVersion as V;
        for v in [V::Tls1_0, V::Tls1_1, V::Tls1_2, V::Tls1_3] {
            for c in [C::Aes128GcmSha256, C::Aes256GcmSha384, C::Chacha20Poly1305Sha256] {
                assert_eq!(
                    tls_policy_accepts(v, c),
                    v == V::Tls1_3,
                    "policy must accept iff TLS 1.3 ({v:?}, {c:?})"
                );
                assert!(is_strong_cipher(c), "all representable suites are strong");
            }
        }
    }
}
