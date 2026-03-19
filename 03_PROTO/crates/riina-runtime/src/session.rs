// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! # Session-Typed Channels
//!
//! Compile-time protocol enforcement via the type-state pattern.
//! Each operation (`send`, `recv`) consumes `self` and returns a
//! continuation type, so using operations out of order is a compile error.
//!
//! ## Example Protocol
//!
//! A client sends a `String`, receives a `u64`, then the session ends:
//!
//! ```text
//! Client: SessionSend<String, SessionRecv<u64, SessionEnd>>
//! Server: SessionRecv<String, SessionSend<u64, SessionEnd>>  (dual)
//! ```

use std::any::Any;
use std::marker::PhantomData;
use std::sync::mpsc;

// Internal type-erased message.
type RawMsg = Box<dyn Any + Send>;

/// Marker trait for session protocol types.
///
/// Implemented for `SessionSend`, `SessionRecv`, and `SessionEnd`.
/// Users should not need to implement this trait.
pub trait SessionType: private::Sealed {}

mod private {
    use super::*;

    pub trait Sealed {
        fn from_raw(tx: mpsc::Sender<RawMsg>, rx: mpsc::Receiver<RawMsg>) -> Self;
    }
}

use private::Sealed;

/// A session channel endpoint that must send a value of type `T` next,
/// then continue with protocol `Cont`.
pub struct SessionSend<T, Cont> {
    tx: mpsc::Sender<RawMsg>,
    rx: mpsc::Receiver<RawMsg>,
    _phantom: PhantomData<fn(T) -> Cont>,
}

/// A session channel endpoint that must receive a value of type `T` next,
/// then continue with protocol `Cont`.
pub struct SessionRecv<T, Cont> {
    tx: mpsc::Sender<RawMsg>,
    rx: mpsc::Receiver<RawMsg>,
    _phantom: PhantomData<fn() -> (T, Cont)>,
}

/// Terminal state — the session is complete.
pub struct SessionEnd {
    _tx: mpsc::Sender<RawMsg>,
    _rx: mpsc::Receiver<RawMsg>,
}

/// Trait for types that can be sent over session channels.
pub trait Encodable: Send + 'static {}

// Blanket impl — anything Send + 'static is Encodable.
impl<T: Send + 'static> Encodable for T {}

// --- SessionType + Sealed impls ---

impl<T, Cont> SessionType for SessionSend<T, Cont> {}
impl<T, Cont> SessionType for SessionRecv<T, Cont> {}
impl SessionType for SessionEnd {}

impl<T, Cont> Sealed for SessionSend<T, Cont> {
    fn from_raw(tx: mpsc::Sender<RawMsg>, rx: mpsc::Receiver<RawMsg>) -> Self {
        SessionSend {
            tx,
            rx,
            _phantom: PhantomData,
        }
    }
}

impl<T, Cont> Sealed for SessionRecv<T, Cont> {
    fn from_raw(tx: mpsc::Sender<RawMsg>, rx: mpsc::Receiver<RawMsg>) -> Self {
        SessionRecv {
            tx,
            rx,
            _phantom: PhantomData,
        }
    }
}

impl Sealed for SessionEnd {
    fn from_raw(tx: mpsc::Sender<RawMsg>, rx: mpsc::Receiver<RawMsg>) -> Self {
        SessionEnd { _tx: tx, _rx: rx }
    }
}

// --- Session channel operations ---

impl<T: Send + 'static, Cont: SessionType> SessionSend<T, Cont> {
    /// Send a value and transition to the continuation protocol.
    /// Consumes `self` — you cannot send twice on the same state.
    pub fn send(self, val: T) -> Cont {
        let boxed: RawMsg = Box::new(val);
        let _ = self.tx.send(boxed);
        Cont::from_raw(self.tx, self.rx)
    }
}

impl<T: Send + 'static, Cont: SessionType> SessionRecv<T, Cont> {
    /// Receive a value and transition to the continuation protocol.
    /// Consumes `self` — you cannot receive twice on the same state.
    pub fn recv(self) -> (T, Cont) {
        let raw = self
            .rx
            .recv()
            .expect("session: channel closed unexpectedly");
        let val = *raw
            .downcast::<T>()
            .expect("session: type mismatch in channel");
        let cont = Cont::from_raw(self.tx, self.rx);
        (val, cont)
    }
}

impl SessionEnd {
    /// Close the session. This is a no-op that consumes the endpoint,
    /// ensuring the protocol is fully completed.
    pub fn close(self) {
        // Dropping the channels closes them.
    }
}

// --- Dual type mapping ---

/// The dual (mirror) of a session type. Used to create the peer's endpoint.
///
/// - `Dual<SessionSend<T, C>>` = `SessionRecv<T, Dual<C>>`
/// - `Dual<SessionRecv<T, C>>` = `SessionSend<T, Dual<C>>`
/// - `Dual<SessionEnd>` = `SessionEnd`
pub trait HasDual {
    /// The dual session type.
    type Dual: SessionType;
}

impl HasDual for SessionEnd {
    type Dual = SessionEnd;
}

impl<T: Send + 'static, Cont: HasDual> HasDual for SessionSend<T, Cont> {
    type Dual = SessionRecv<T, <Cont as HasDual>::Dual>;
}

impl<T: Send + 'static, Cont: HasDual> HasDual for SessionRecv<T, Cont> {
    type Dual = SessionSend<T, <Cont as HasDual>::Dual>;
}

/// Create a new session channel pair. Returns `(client, server)` where
/// the server's type is the dual of the client's type.
///
/// # Example
///
/// ```ignore
/// type ClientProto = SessionSend<String, SessionRecv<u64, SessionEnd>>;
/// let (client, server) = session_channel::<ClientProto>();
/// // client: SessionSend<String, SessionRecv<u64, SessionEnd>>
/// // server: SessionRecv<String, SessionSend<u64, SessionEnd>>
/// ```
pub fn session_channel<P: HasDual + SessionType>() -> (P, P::Dual) {
    // Two mpsc channels — one per direction.
    let (tx_a, rx_a) = mpsc::channel::<RawMsg>();
    let (tx_b, rx_b) = mpsc::channel::<RawMsg>();

    // Client sends on tx_a, receives on rx_b.
    // Server sends on tx_b, receives on rx_a.
    let client: P = P::from_raw(tx_a, rx_b);
    let server: P::Dual = <P::Dual>::from_raw(tx_b, rx_a);

    (client, server)
}
