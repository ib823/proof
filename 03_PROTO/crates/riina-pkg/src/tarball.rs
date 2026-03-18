// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Minimal tar archive creation and extraction (POSIX ustar format).
//!
//! No compression — raw tar only. Gzip support can be added later.

use crate::error::{PkgError, Result};
use std::path::{Path, PathBuf};

/// Size of a tar block.
const BLOCK: usize = 512;

/// Pack a directory into a tar archive.
pub(crate) fn pack(dir: &Path) -> Result<Vec<u8>> {
    let mut archive = Vec::new();
    let prefix = dir;
    pack_dir(prefix, dir, &mut archive)?;
    // Two zero blocks to mark end of archive
    archive.extend_from_slice(&[0u8; BLOCK * 2]);
    Ok(archive)
}

fn pack_dir(prefix: &Path, dir: &Path, archive: &mut Vec<u8>) -> Result<()> {
    let mut entries: Vec<_> = std::fs::read_dir(dir)
        .map_err(|e| PkgError::io(dir, e))?
        .collect::<std::result::Result<Vec<_>, _>>()
        .map_err(|e| PkgError::io(dir, e))?;
    entries.sort_by_key(|e| e.file_name());

    for entry in entries {
        let path = entry.path();
        let ft = entry.file_type().map_err(|e| PkgError::io(&path, e))?;
        let rel = path
            .strip_prefix(prefix)
            .unwrap_or(&path)
            .to_string_lossy()
            .into_owned();

        if ft.is_dir() {
            let dir_name = if rel.ends_with('/') {
                rel
            } else {
                format!("{rel}/")
            };
            let header = make_header(&dir_name, 0, b'5');
            archive.extend_from_slice(&header);
            pack_dir(prefix, &path, archive)?;
        } else if ft.is_file() {
            let data = std::fs::read(&path).map_err(|e| PkgError::io(&path, e))?;
            let header = make_header(&rel, data.len(), b'0');
            archive.extend_from_slice(&header);
            archive.extend_from_slice(&data);
            // Pad to block boundary
            let remainder = data.len() % BLOCK;
            if remainder != 0 {
                archive.extend_from_slice(&vec![0u8; BLOCK - remainder]);
            }
        }
        // Skip symlinks and other special files
    }
    Ok(())
}

/// Create a 512-byte ustar header.
fn make_header(name: &str, size: usize, typeflag: u8) -> [u8; BLOCK] {
    let mut header = [0u8; BLOCK];

    // Name (0..100)
    let name_bytes = name.as_bytes();
    let copy_len = name_bytes.len().min(100);
    header[..copy_len].copy_from_slice(&name_bytes[..copy_len]);

    // Mode (100..108) — 0644 for files, 0755 for dirs
    let mode = if typeflag == b'5' { b"0000755\0" } else { b"0000644\0" };
    header[100..108].copy_from_slice(mode);

    // UID (108..116)
    header[108..116].copy_from_slice(b"0001000\0");

    // GID (116..124)
    header[116..124].copy_from_slice(b"0001000\0");

    // Size (124..136) — octal, 11 digits + null
    let size_str = format!("{:011o}\0", size);
    header[124..136].copy_from_slice(size_str.as_bytes());

    // Mtime (136..148) — use 0
    header[136..148].copy_from_slice(b"00000000000\0");

    // Typeflag (156)
    header[156] = typeflag;

    // Magic (257..263)
    header[257..263].copy_from_slice(b"ustar\0");

    // Version (263..265)
    header[263..265].copy_from_slice(b"00");

    // Compute checksum (148..156): sum of all bytes treating checksum field as spaces
    header[148..156].copy_from_slice(b"        "); // 8 spaces
    let cksum: u32 = header.iter().map(|&b| b as u32).sum();
    let cksum_str = format!("{:06o}\0 ", cksum);
    header[148..156].copy_from_slice(cksum_str.as_bytes());

    header
}

/// Unpack a tar archive to a destination directory.
pub(crate) fn unpack(data: &[u8], dest: &Path) -> Result<()> {
    std::fs::create_dir_all(dest).map_err(|e| PkgError::io(dest, e))?;

    let mut offset = 0;
    while offset + BLOCK <= data.len() {
        let header = &data[offset..offset + BLOCK];

        // Check for zero block (end of archive)
        if header.iter().all(|&b| b == 0) {
            break;
        }

        let name = read_str(header, 0, 100);
        if name.is_empty() {
            break;
        }

        let size = read_octal(header, 124, 12);
        let typeflag = header[156];

        offset += BLOCK;

        let out_path = dest.join(&name);

        match typeflag {
            b'5' => {
                // Directory
                std::fs::create_dir_all(&out_path).map_err(|e| PkgError::io(&out_path, e))?;
            }
            b'0' | 0 => {
                // Regular file
                if let Some(parent) = out_path.parent() {
                    std::fs::create_dir_all(parent).map_err(|e| PkgError::io(parent, e))?;
                }
                let end = offset + size;
                if end > data.len() {
                    return Err(PkgError::Other(format!(
                        "tar truncated: need {} bytes at offset {}, have {}",
                        size,
                        offset,
                        data.len()
                    )));
                }
                let file_data = &data[offset..end];
                std::fs::write(&out_path, file_data).map_err(|e| PkgError::io(&out_path, e))?;
                // Advance past data blocks
                let blocks = size.div_ceil(BLOCK);
                offset += blocks * BLOCK;
            }
            _ => {
                // Skip unknown types
                let blocks = size.div_ceil(BLOCK);
                offset += blocks * BLOCK;
            }
        }
    }

    Ok(())
}

/// Read a null-terminated string from a header field.
fn read_str(header: &[u8], start: usize, max_len: usize) -> String {
    let field = &header[start..start + max_len];
    let end = field.iter().position(|&b| b == 0).unwrap_or(max_len);
    String::from_utf8_lossy(&field[..end]).into_owned()
}

/// Read an octal number from a header field.
fn read_octal(header: &[u8], start: usize, max_len: usize) -> usize {
    let s = read_str(header, start, max_len);
    let s = s.trim();
    if s.is_empty() {
        return 0;
    }
    usize::from_str_radix(s, 8).unwrap_or(0)
}

/// Get the host portion from a URL for cache directory naming.
pub(crate) fn host_from_url(url: &str) -> String {
    let rest = url
        .strip_prefix("http://")
        .unwrap_or(url);
    let authority = match rest.find('/') {
        Some(i) => &rest[..i],
        None => rest,
    };
    // Replace colons (port separator) with underscores for filesystem safety
    authority.replace(':', "_")
}

/// Canonical cache directory for a given registry URL.
pub(crate) fn cache_dir_for_url(url: &str) -> PathBuf {
    let home = std::env::var("HOME")
        .or_else(|_| std::env::var("USERPROFILE"))
        .unwrap_or_else(|_| ".".into());
    PathBuf::from(home)
        .join(".riina")
        .join("cache")
        .join("http")
        .join(host_from_url(url))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_pack_unpack_roundtrip() {
        let tmp = std::env::temp_dir().join("riina_tar_test_roundtrip");
        let _ = fs::remove_dir_all(&tmp);
        let src = tmp.join("src");
        let dst = tmp.join("dst");
        fs::create_dir_all(src.join("sub")).unwrap();
        fs::write(src.join("hello.txt"), b"Hello, world!").unwrap();
        fs::write(src.join("sub/nested.txt"), b"Nested file").unwrap();

        let archive = pack(&src).unwrap();
        unpack(&archive, &dst).unwrap();

        assert_eq!(
            fs::read_to_string(dst.join("hello.txt")).unwrap(),
            "Hello, world!"
        );
        assert_eq!(
            fs::read_to_string(dst.join("sub/nested.txt")).unwrap(),
            "Nested file"
        );

        let _ = fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_pack_empty_dir() {
        let tmp = std::env::temp_dir().join("riina_tar_test_empty");
        let _ = fs::remove_dir_all(&tmp);
        let src = tmp.join("src");
        let dst = tmp.join("dst");
        fs::create_dir_all(&src).unwrap();

        let archive = pack(&src).unwrap();
        // Should just be two zero blocks (end marker)
        assert_eq!(archive.len(), BLOCK * 2);

        unpack(&archive, &dst).unwrap();
        assert!(dst.is_dir());

        let _ = fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_host_from_url() {
        assert_eq!(host_from_url("http://registry.riina.dev/api/v1"), "registry.riina.dev");
        assert_eq!(host_from_url("http://localhost:8080/api"), "localhost_8080");
    }
}
