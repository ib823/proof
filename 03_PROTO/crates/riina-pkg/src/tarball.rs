// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Minimal tar archive creation and extraction (POSIX ustar format).
//!
//! No compression — raw tar only. Gzip support can be added later.

use crate::error::{PkgError, Result};
use std::io::Write;
use std::path::{Component, Path, PathBuf};

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
    reject_link(dir)?;
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
            .replace('\\', "/");

        if ft.is_dir() {
            let dir_name = if rel.ends_with('/') {
                rel
            } else {
                format!("{rel}/")
            };
            let header = make_header(&dir_name, 0, b'5')?;
            archive.extend_from_slice(&header);
            pack_dir(prefix, &path, archive)?;
        } else if ft.is_file() {
            let data = std::fs::read(&path).map_err(|e| PkgError::io(&path, e))?;
            let header = make_header(&rel, data.len(), b'0')?;
            archive.extend_from_slice(&header);
            archive.extend_from_slice(&data);
            // Pad to block boundary
            let remainder = data.len() % BLOCK;
            if remainder != 0 {
                archive.extend_from_slice(&vec![0u8; BLOCK - remainder]);
            }
        } else {
            return Err(PkgError::Other(format!(
                "unsupported package link or special file: {}",
                path.display()
            )));
        }
    }
    Ok(())
}

/// Create a 512-byte ustar header.
fn make_header(name: &str, size: usize, typeflag: u8) -> Result<[u8; BLOCK]> {
    let mut header = [0u8; BLOCK];
    if size as u128 > 0o77777777777 {
        return Err(PkgError::Other(
            "package file exceeds ustar size limit".into(),
        ));
    }
    // Preserve long paths using the standard ustar prefix field; never
    // silently truncate two distinct package files onto the same name.
    let (prefix, name) = if name.len() <= 100 {
        ("", name)
    } else {
        name.match_indices('/')
            .rev()
            .find_map(|(i, _)| {
                let suffix = &name[i + 1..];
                (i <= 155 && !suffix.is_empty() && suffix.len() <= 100)
                    .then_some((&name[..i], suffix))
            })
            .ok_or_else(|| PkgError::Other("package path exceeds ustar name limits".into()))?
    };
    header[345..345 + prefix.len()].copy_from_slice(prefix.as_bytes());
    let name_bytes = name.as_bytes();
    header[..name_bytes.len()].copy_from_slice(name_bytes);

    // Mode (100..108) — 0644 for files, 0755 for dirs
    let mode = if typeflag == b'5' {
        b"0000755\0"
    } else {
        b"0000644\0"
    };
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

    Ok(header)
}

/// Unpack a tar archive to a destination directory.
pub(crate) fn unpack(data: &[u8], dest: &Path) -> Result<()> {
    std::fs::create_dir_all(dest).map_err(|e| PkgError::io(dest, e))?;
    reject_link(dest)?;

    let mut offset = 0;
    while offset + BLOCK <= data.len() {
        let header = &data[offset..offset + BLOCK];

        // Check for zero block (end of archive)
        if header.iter().all(|&b| b == 0) {
            if data.len() - offset < BLOCK * 2 || !data[offset..].iter().all(|&b| b == 0) {
                return Err(PkgError::Other("invalid tar end marker".into()));
            }
            return Ok(());
        }
        let checksum = read_octal(header, 148, 8)?;
        let actual: usize = header
            .iter()
            .enumerate()
            .map(|(i, &b)| {
                if (148..156).contains(&i) {
                    b' ' as usize
                } else {
                    b as usize
                }
            })
            .sum();
        if checksum != actual || &header[257..263] != b"ustar\0" {
            return Err(PkgError::Other("invalid package tar header".into()));
        }
        let mut name = read_str(header, 0, 100)?;
        let prefix = read_str(header, 345, 155)?;
        if !prefix.is_empty() {
            name = format!("{prefix}/{name}");
        }

        let size = read_octal(header, 124, 12)?;
        let typeflag = header[156];

        offset += BLOCK;

        let out_path = extraction_path(dest, &name)?;
        let end = offset
            .checked_add(size)
            .filter(|&end| end <= data.len())
            .ok_or_else(|| PkgError::Other("tar entry exceeds archive bounds".into()))?;
        let next = size
            .div_ceil(BLOCK)
            .checked_mul(BLOCK)
            .and_then(|padded| offset.checked_add(padded))
            .filter(|&next| next <= data.len())
            .ok_or_else(|| PkgError::Other("tar entry padding exceeds archive bounds".into()))?;

        match typeflag {
            b'5' => {
                // Directory
                create_extraction_dirs(dest, &out_path)?;
            }
            b'0' | 0 => {
                // Regular file
                if let Some(parent) = out_path.parent() {
                    create_extraction_dirs(dest, parent)?;
                }
                let file_data = &data[offset..end];
                // Never follow a pre-existing symlink or overwrite a hard-linked
                // file. A duplicate entry is an error as well.
                let mut file = std::fs::OpenOptions::new()
                    .write(true)
                    .create_new(true)
                    .open(&out_path)
                    .map_err(|e| PkgError::io(&out_path, e))?;
                file.write_all(file_data)
                    .map_err(|e| PkgError::io(&out_path, e))?;
            }
            _ => {
                return Err(PkgError::Other("unsupported package tar entry type".into()));
            }
        }
        offset = next;
    }

    Err(PkgError::Other(
        "truncated tar archive: missing end marker".into(),
    ))
}

/// Archive names use POSIX separators on every host. Reject Windows path
/// syntax too, so a package accepted on Unix cannot escape when used on Windows.
fn extraction_path(dest: &Path, name: &str) -> Result<PathBuf> {
    if name.contains(['\\', ':'])
        || name.split('/').any(|part| {
            part == ".." || part.ends_with([' ', '.']) && part != "." || reserved_device_name(part)
        })
    {
        return Err(PkgError::Other(format!("unsafe package tar path: {name}")));
    }
    let mut out = dest.to_path_buf();
    let mut has_name = false;
    for component in Path::new(name).components() {
        match component {
            Component::Normal(part) => {
                out.push(part);
                has_name = true;
            }
            Component::CurDir => {}
            _ => return Err(PkgError::Other(format!("unsafe package tar path: {name}"))),
        }
    }
    if !has_name {
        return Err(PkgError::Other("empty package tar path".into()));
    }
    Ok(out)
}

fn reserved_device_name(name: &str) -> bool {
    let stem = name.split('.').next().unwrap_or("").to_ascii_uppercase();
    matches!(stem.as_str(), "CON" | "PRN" | "AUX" | "NUL")
        || ((stem.starts_with("COM") || stem.starts_with("LPT"))
            && stem.len() == 4
            && matches!(stem.as_bytes()[3], b'1'..=b'9'))
}

fn reject_link(path: &Path) -> Result<()> {
    let metadata = std::fs::symlink_metadata(path).map_err(|e| PkgError::io(path, e))?;
    let linked = metadata.file_type().is_symlink();
    #[cfg(windows)]
    let linked = {
        use std::os::windows::fs::MetadataExt;
        linked || metadata.file_attributes() & 0x400 != 0 // any reparse point
    };
    if linked || !metadata.is_dir() {
        return Err(PkgError::Other(format!(
            "unsafe extraction directory: {}",
            path.display()
        )));
    }
    Ok(())
}

fn create_extraction_dirs(dest: &Path, path: &Path) -> Result<()> {
    let relative = path
        .strip_prefix(dest)
        .map_err(|_| PkgError::Other("tar path outside destination".into()))?;
    let mut current = dest.to_path_buf();
    reject_link(&current)?;
    for part in relative.components() {
        current.push(part);
        match std::fs::create_dir(&current) {
            Ok(()) => {}
            Err(e) if e.kind() == std::io::ErrorKind::AlreadyExists => {}
            Err(e) => return Err(PkgError::io(&current, e)),
        }
        reject_link(&current)?;
    }
    Ok(())
}

/// Read a null-terminated string from a header field.
fn read_str(header: &[u8], start: usize, max_len: usize) -> Result<String> {
    let field = &header[start..start + max_len];
    let end = field.iter().position(|&b| b == 0).unwrap_or(max_len);
    String::from_utf8(field[..end].to_vec())
        .map_err(|_| PkgError::Other("non-UTF-8 tar field".into()))
}

/// Read an octal number from a header field.
fn read_octal(header: &[u8], start: usize, max_len: usize) -> Result<usize> {
    let s = read_str(header, start, max_len)?;
    let s = s.trim();
    if s.is_empty() {
        return Ok(0);
    }
    usize::from_str_radix(s, 8).map_err(|_| PkgError::Other("invalid tar numeric field".into()))
}

/// Get the host portion from a URL for cache directory naming.
#[cfg(test)]
fn host_from_url(url: &str) -> String {
    let rest = url.strip_prefix("http://").unwrap_or(url);
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
        .join(crate::integrity::sha256_hex(
            url.trim_end_matches('/').as_bytes(),
        ))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    fn test_archive(name: &str) -> Vec<u8> {
        let mut archive = make_header(name, 4, b'0').unwrap().to_vec();
        archive.extend_from_slice(b"test");
        archive.resize(BLOCK * 4, 0);
        archive
    }

    #[test]
    fn unpack_rejects_paths_outside_destination() {
        let tmp = std::env::temp_dir().join(format!("riina_tar_escape_{}", std::process::id()));
        fs::create_dir_all(&tmp).unwrap();
        let dst = tmp.join("dst");
        let outside = tmp.join("outside.txt");
        fs::write(&outside, b"preserve").unwrap();
        for name in [
            "../outside.txt",
            "sub/../../outside.txt",
            "/outside.txt",
            "C:/outside.txt",
            "C:outside.txt",
            "..\\outside.txt",
            "sub/.. /outside.txt",
            "NUL.txt",
            "sub/COM1",
        ] {
            assert!(
                unpack(&test_archive(name), &dst).is_err(),
                "accepted {name}"
            );
            assert_eq!(fs::read(&outside).unwrap(), b"preserve");
        }
        fs::remove_dir_all(&tmp).unwrap();
    }

    #[test]
    fn unpack_never_overwrites_an_existing_hardlink() {
        let tmp = std::env::temp_dir().join(format!("riina_tar_hardlink_{}", std::process::id()));
        let dst = tmp.join("dst");
        fs::create_dir_all(&dst).unwrap();
        let outside = tmp.join("outside.txt");
        fs::write(&outside, b"preserve").unwrap();
        fs::hard_link(&outside, dst.join("file.txt")).unwrap();
        assert!(unpack(&test_archive("file.txt"), &dst).is_err());
        assert_eq!(fs::read(&outside).unwrap(), b"preserve");
        fs::remove_dir_all(&tmp).unwrap();
    }

    #[cfg(unix)]
    #[test]
    fn unpack_rejects_a_symlinked_parent() {
        let tmp = std::env::temp_dir().join(format!("riina_tar_symlink_{}", std::process::id()));
        let dst = tmp.join("dst");
        let outside = tmp.join("outside");
        fs::create_dir_all(&dst).unwrap();
        fs::create_dir_all(&outside).unwrap();
        std::os::unix::fs::symlink(&outside, dst.join("sub")).unwrap();
        assert!(unpack(&test_archive("sub/file.txt"), &dst).is_err());
        assert!(!outside.join("file.txt").exists());
        fs::remove_dir_all(&tmp).unwrap();
    }

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
    fn malformed_or_truncated_archives_are_rejected() {
        let tmp = std::env::temp_dir().join(format!("riina_tar_malformed_{}", std::process::id()));
        let archive = test_archive("file.txt");
        for end in [0, 511, 512, 600, 1024, 1536] {
            let dest = tmp.join(end.to_string());
            assert!(
                unpack(&archive[..end], &dest).is_err(),
                "accepted truncated {end}"
            );
        }
        let mut corrupt = archive;
        corrupt[0] ^= 1;
        assert!(unpack(&corrupt, &tmp.join("corrupt")).is_err());
        std::fs::remove_dir_all(tmp).unwrap();
    }

    #[test]
    fn ustar_prefix_paths_roundtrip_without_truncation() {
        let tmp = std::env::temp_dir().join(format!("riina_tar_long_{}", std::process::id()));
        let name = format!("{}/{}.txt", "a".repeat(80), "b".repeat(40));
        let archive = test_archive(&name);
        unpack(&archive, &tmp).unwrap();
        assert_eq!(std::fs::read(tmp.join(name)).unwrap(), b"test");
        assert!(make_header(&"a".repeat(101), 0, b'0').is_err());
        std::fs::remove_dir_all(tmp).unwrap();
    }

    #[test]
    fn registry_cache_distinguishes_url_paths() {
        assert_ne!(
            cache_dir_for_url("http://localhost/one"),
            cache_dir_for_url("http://localhost/two")
        );
        assert_eq!(
            cache_dir_for_url("http://localhost/one/"),
            cache_dir_for_url("http://localhost/one")
        );
    }

    #[test]
    fn test_host_from_url() {
        assert_eq!(
            host_from_url("http://registry.riina.dev/api/v1"),
            "registry.riina.dev"
        );
        assert_eq!(host_from_url("http://localhost:8080/api"), "localhost_8080");
    }
}
