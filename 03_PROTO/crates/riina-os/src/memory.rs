//! Memory management — page frame allocation and virtual address mapping.

use std::collections::HashMap;

/// A physical page frame.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PageFrame {
    pub id: u64,
    pub size: usize,
}

/// A virtual address.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct VirtualAddress(pub u64);

/// Memory management error types.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum MemError {
    AlreadyMapped,
    NotMapped,
    OutOfMemory,
    InvalidAddress,
}

/// A simple page table mapping virtual addresses to page frames.
#[derive(Debug, Default)]
pub struct PageTable {
    mappings: HashMap<u64, PageFrame>,
}

impl PageTable {
    pub fn new() -> Self {
        Self::default()
    }

    /// Map a virtual address to a page frame.
    pub fn map(&mut self, vaddr: VirtualAddress, frame: PageFrame) -> Result<(), MemError> {
        if self.mappings.contains_key(&vaddr.0) {
            return Err(MemError::AlreadyMapped);
        }
        self.mappings.insert(vaddr.0, frame);
        Ok(())
    }

    /// Unmap a virtual address, returning the page frame.
    pub fn unmap(&mut self, vaddr: VirtualAddress) -> Result<PageFrame, MemError> {
        self.mappings.remove(&vaddr.0).ok_or(MemError::NotMapped)
    }

    /// Look up the page frame for a virtual address.
    pub fn lookup(&self, vaddr: VirtualAddress) -> Option<&PageFrame> {
        self.mappings.get(&vaddr.0)
    }

    /// Number of active mappings.
    pub fn mapping_count(&self) -> usize {
        self.mappings.len()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn frame(id: u64) -> PageFrame {
        PageFrame { id, size: 4096 }
    }

    #[test]
    fn map_and_lookup() {
        let mut pt = PageTable::new();
        pt.map(VirtualAddress(0x1000), frame(1)).unwrap();
        let f = pt.lookup(VirtualAddress(0x1000)).unwrap();
        assert_eq!(f.id, 1);
        assert_eq!(f.size, 4096);
    }

    #[test]
    fn unmap_returns_frame() {
        let mut pt = PageTable::new();
        pt.map(VirtualAddress(0x2000), frame(2)).unwrap();
        let f = pt.unmap(VirtualAddress(0x2000)).unwrap();
        assert_eq!(f.id, 2);
    }

    #[test]
    fn unmap_removes_mapping() {
        let mut pt = PageTable::new();
        pt.map(VirtualAddress(0x3000), frame(3)).unwrap();
        pt.unmap(VirtualAddress(0x3000)).unwrap();
        assert!(pt.lookup(VirtualAddress(0x3000)).is_none());
    }

    #[test]
    fn double_map_error() {
        let mut pt = PageTable::new();
        pt.map(VirtualAddress(0x4000), frame(4)).unwrap();
        assert_eq!(
            pt.map(VirtualAddress(0x4000), frame(5)),
            Err(MemError::AlreadyMapped)
        );
    }

    #[test]
    fn unmap_not_mapped_error() {
        let mut pt = PageTable::new();
        assert_eq!(
            pt.unmap(VirtualAddress(0x5000)),
            Err(MemError::NotMapped)
        );
    }

    #[test]
    fn mapping_count() {
        let mut pt = PageTable::new();
        assert_eq!(pt.mapping_count(), 0);
        pt.map(VirtualAddress(0x1000), frame(1)).unwrap();
        pt.map(VirtualAddress(0x2000), frame(2)).unwrap();
        assert_eq!(pt.mapping_count(), 2);
        pt.unmap(VirtualAddress(0x1000)).unwrap();
        assert_eq!(pt.mapping_count(), 1);
    }

    #[test]
    fn lookup_nonexistent() {
        let pt = PageTable::new();
        assert!(pt.lookup(VirtualAddress(0xDEAD)).is_none());
    }
}
