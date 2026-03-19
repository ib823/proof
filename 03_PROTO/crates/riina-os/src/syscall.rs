//! System call interface types.
//!
//! Defines the system call numbers and result types for TERAS.

/// System call identifiers.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SyscallId {
    Read,
    Write,
    Open,
    Close,
    Mmap,
    Munmap,
    Exit,
    Fork,
    Exec,
    Wait,
    Send,
    Recv,
}

/// Result of a system call.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum SyscallResult {
    Success(u64),
    Error(SyscallError),
}

/// System call error codes.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SyscallError {
    PermissionDenied,
    InvalidArgument,
    NotFound,
    AlreadyExists,
    OutOfMemory,
    IoError,
}

/// A system call request with arguments.
#[derive(Debug, Clone)]
pub struct SyscallRequest {
    pub id: SyscallId,
    pub args: [u64; 4],
}

impl SyscallRequest {
    pub fn new(id: SyscallId, args: [u64; 4]) -> Self {
        Self { id, args }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn syscall_request_creation() {
        let req = SyscallRequest::new(SyscallId::Read, [1, 1024, 0, 0]);
        assert_eq!(req.id, SyscallId::Read);
        assert_eq!(req.args[0], 1);
        assert_eq!(req.args[1], 1024);
    }

    #[test]
    fn syscall_result_success() {
        let result = SyscallResult::Success(42);
        assert_eq!(result, SyscallResult::Success(42));
    }

    #[test]
    fn syscall_result_error() {
        let result = SyscallResult::Error(SyscallError::PermissionDenied);
        assert_eq!(result, SyscallResult::Error(SyscallError::PermissionDenied));
    }
}
