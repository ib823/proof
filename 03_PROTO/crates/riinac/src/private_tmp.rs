// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! A private, unpredictable scratch directory for build intermediates.
//!
//! `riinac build` used to write its intermediate C to the predictable path
//! `$TMPDIR/riina_<stem>.c` with `fs::write`, which follows symlinks and
//! truncates whatever is there: anyone able to write to the temp directory
//! could plant `riina_<stem>.c` as a symlink and have the next build
//! overwrite the link's target with the builder's privileges (and two
//! concurrent builds of same-named files raced on one path). The directory
//! made here has a random name, is created with `create_dir` — which fails,
//! rather than reusing anything, if the path already exists (a planted
//! symlink included) — and is mode 0700 on Unix; files inside it are opened
//! with `create_new` (`O_EXCL`), so no existing file or link is ever opened.

use std::fs::{DirBuilder, OpenOptions};
use std::io::{self, Write as _};
use std::path::PathBuf;

/// A freshly created private directory, removed (with its contents) on drop.
///
/// `process::exit` skips destructors, so callers drop it explicitly before
/// exiting.
pub struct PrivateTempDir {
    path: PathBuf,
}

impl PrivateTempDir {
    /// Create a new private directory under the system temp directory.
    pub fn create(prefix: &str) -> io::Result<Self> {
        let base = std::env::temp_dir();
        for attempt in 0..64u32 {
            let path = base.join(format!("{prefix}-{:016x}", unpredictable_u64(attempt)));
            let mut builder = DirBuilder::new();
            #[cfg(unix)]
            {
                use std::os::unix::fs::DirBuilderExt as _;
                builder.mode(0o700);
            }
            match builder.create(&path) {
                Ok(()) => return Ok(Self { path }),
                // Something (or someone) already holds that name: never reuse
                // it, pick another.
                Err(e) if e.kind() == io::ErrorKind::AlreadyExists => continue,
                Err(e) => return Err(e),
            }
        }
        Err(io::Error::new(
            io::ErrorKind::AlreadyExists,
            "could not create a fresh private temporary directory",
        ))
    }

    /// The directory's path.
    #[cfg(test)]
    pub fn path(&self) -> &std::path::Path {
        &self.path
    }

    /// Write `contents` to a NEW file `name` inside the directory. Fails if
    /// the file already exists; never follows a symlink.
    pub fn write_new(&self, name: &str, contents: &[u8]) -> io::Result<PathBuf> {
        let file_path = self.path.join(name);
        let mut file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(&file_path)?;
        file.write_all(contents)?;
        Ok(file_path)
    }
}

impl Drop for PrivateTempDir {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.path);
    }
}

/// 64 bits that another local user cannot predict: `RandomState` is keyed
/// from the OS random source, mixed with the pid, time and attempt number.
fn unpredictable_u64(attempt: u32) -> u64 {
    use std::hash::{BuildHasher as _, Hasher as _};
    let mut hasher = std::collections::hash_map::RandomState::new().build_hasher();
    hasher.write_u32(std::process::id());
    hasher.write_u32(attempt);
    if let Ok(now) = std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH) {
        hasher.write_u128(now.as_nanos());
    }
    hasher.finish()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn creates_a_fresh_private_dir_and_removes_it() {
        let dir = PrivateTempDir::create("riina-test").expect("create");
        let p = dir.path().to_path_buf();
        assert!(p.is_dir());
        #[cfg(unix)]
        {
            use std::os::unix::fs::PermissionsExt as _;
            let mode = std::fs::metadata(&p).unwrap().permissions().mode() & 0o777;
            assert_eq!(mode & 0o077, 0, "no group/other access: {mode:o}");
        }
        let f = dir.write_new("a.c", b"int x;").expect("write");
        assert_eq!(std::fs::read(&f).unwrap(), b"int x;");
        assert!(dir.write_new("a.c", b"again").is_err(), "create_new must not reuse");
        drop(dir);
        assert!(!p.exists());
    }

    #[test]
    fn two_dirs_never_share_a_path() {
        let a = PrivateTempDir::create("riina-test").unwrap();
        let b = PrivateTempDir::create("riina-test").unwrap();
        assert_ne!(a.path(), b.path());
    }
}
