//! Capability-based security system.
//!
//! Hardware capabilities with delegation and linear revocation.

/// Permission flags for a capability.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Permissions {
    pub read: bool,
    pub write: bool,
    pub execute: bool,
}

impl Permissions {
    pub const NONE: Self = Self { read: false, write: false, execute: false };
    pub const READ_ONLY: Self = Self { read: true, write: false, execute: false };
    pub const READ_WRITE: Self = Self { read: true, write: true, execute: false };
    pub const ALL: Self = Self { read: true, write: true, execute: true };
}

/// A capability granting access to a resource.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Capability {
    pub resource: u64,
    pub permissions: Permissions,
    pub delegatable: bool,
}

impl Capability {
    pub fn new(resource: u64, permissions: Permissions, delegatable: bool) -> Self {
        Self { resource, permissions, delegatable }
    }

    pub fn can_read(&self) -> bool {
        self.permissions.read
    }

    pub fn can_write(&self) -> bool {
        self.permissions.write
    }

    pub fn can_execute(&self) -> bool {
        self.permissions.execute
    }

    /// Delegate this capability to another entity.
    /// Returns `None` if the capability is not delegatable.
    pub fn delegate(&self) -> Option<Capability> {
        if self.delegatable {
            Some(self.clone())
        } else {
            None
        }
    }

    /// Revoke this capability by consuming it (linear ownership).
    /// The capability is moved into this function and cannot be used afterward.
    pub fn revoke(self) {
        // Consuming self ensures the capability cannot be used after revocation.
        // No explicit drop needed — Rust's ownership system handles it.
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn capability_read_permission() {
        let cap = Capability::new(1, Permissions::READ_ONLY, false);
        assert!(cap.can_read());
        assert!(!cap.can_write());
        assert!(!cap.can_execute());
    }

    #[test]
    fn capability_all_permissions() {
        let cap = Capability::new(1, Permissions::ALL, false);
        assert!(cap.can_read());
        assert!(cap.can_write());
        assert!(cap.can_execute());
    }

    #[test]
    fn capability_no_permissions() {
        let cap = Capability::new(1, Permissions::NONE, false);
        assert!(!cap.can_read());
        assert!(!cap.can_write());
        assert!(!cap.can_execute());
    }

    #[test]
    fn delegatable_capability_delegates() {
        let cap = Capability::new(42, Permissions::READ_WRITE, true);
        let delegated = cap.delegate();
        assert!(delegated.is_some());
        let d = delegated.unwrap();
        assert_eq!(d.resource, 42);
        assert_eq!(d.permissions, Permissions::READ_WRITE);
    }

    #[test]
    fn non_delegatable_capability_fails() {
        let cap = Capability::new(42, Permissions::READ_WRITE, false);
        assert!(cap.delegate().is_none());
    }

    #[test]
    fn revoke_consumes_capability() {
        let cap = Capability::new(1, Permissions::ALL, true);
        cap.revoke();
        // cap is moved — cannot use after revoke (enforced by Rust's ownership)
    }

    #[test]
    fn capability_equality() {
        let a = Capability::new(1, Permissions::READ_ONLY, false);
        let b = Capability::new(1, Permissions::READ_ONLY, false);
        assert_eq!(a, b);
    }

    #[test]
    fn capability_inequality_resource() {
        let a = Capability::new(1, Permissions::READ_ONLY, false);
        let b = Capability::new(2, Permissions::READ_ONLY, false);
        assert_ne!(a, b);
    }

    #[test]
    fn capability_inequality_permissions() {
        let a = Capability::new(1, Permissions::READ_ONLY, false);
        let b = Capability::new(1, Permissions::READ_WRITE, false);
        assert_ne!(a, b);
    }
}
