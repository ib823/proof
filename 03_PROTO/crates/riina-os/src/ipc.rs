//! IPC — Inter-process communication.
//!
//! Simple message-passing between endpoints.

use std::collections::VecDeque;

/// An IPC endpoint identifier.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Endpoint {
    pub id: u64,
}

/// A message sent between endpoints.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Message {
    pub sender: u64,
    pub payload: Vec<u8>,
}

/// IPC error types.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum IpcError {
    EndpointNotFound,
    ChannelFull,
    ChannelEmpty,
    PermissionDenied,
}

/// A simple IPC channel backed by a bounded queue.
#[derive(Debug)]
pub struct Channel {
    pub endpoint: Endpoint,
    buffer: VecDeque<Message>,
    capacity: usize,
}

impl Channel {
    pub fn new(endpoint: Endpoint, capacity: usize) -> Self {
        Self {
            endpoint,
            buffer: VecDeque::with_capacity(capacity),
            capacity,
        }
    }

    /// Send a message to this channel.
    pub fn send(&mut self, msg: Message) -> Result<(), IpcError> {
        if self.buffer.len() >= self.capacity {
            return Err(IpcError::ChannelFull);
        }
        self.buffer.push_back(msg);
        Ok(())
    }

    /// Receive the next message from this channel.
    pub fn recv(&mut self) -> Result<Message, IpcError> {
        self.buffer.pop_front().ok_or(IpcError::ChannelEmpty)
    }

    /// Check if the channel is empty.
    pub fn is_empty(&self) -> bool {
        self.buffer.is_empty()
    }

    /// Number of pending messages.
    pub fn len(&self) -> usize {
        self.buffer.len()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_channel(cap: usize) -> Channel {
        Channel::new(Endpoint { id: 1 }, cap)
    }

    fn make_msg(sender: u64, data: &[u8]) -> Message {
        Message { sender, payload: data.to_vec() }
    }

    #[test]
    fn send_and_recv() {
        let mut ch = make_channel(10);
        ch.send(make_msg(1, b"hello")).unwrap();
        let msg = ch.recv().unwrap();
        assert_eq!(msg.sender, 1);
        assert_eq!(msg.payload, b"hello");
    }

    #[test]
    fn recv_empty_channel() {
        let mut ch = make_channel(10);
        assert_eq!(ch.recv(), Err(IpcError::ChannelEmpty));
    }

    #[test]
    fn send_full_channel() {
        let mut ch = make_channel(2);
        ch.send(make_msg(1, b"a")).unwrap();
        ch.send(make_msg(1, b"b")).unwrap();
        assert_eq!(ch.send(make_msg(1, b"c")), Err(IpcError::ChannelFull));
    }

    #[test]
    fn fifo_ordering() {
        let mut ch = make_channel(10);
        ch.send(make_msg(1, b"first")).unwrap();
        ch.send(make_msg(2, b"second")).unwrap();
        assert_eq!(ch.recv().unwrap().payload, b"first");
        assert_eq!(ch.recv().unwrap().payload, b"second");
    }

    #[test]
    fn len_and_is_empty() {
        let mut ch = make_channel(10);
        assert!(ch.is_empty());
        assert_eq!(ch.len(), 0);
        ch.send(make_msg(1, b"x")).unwrap();
        assert!(!ch.is_empty());
        assert_eq!(ch.len(), 1);
    }
}
