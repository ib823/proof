// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! The C compiler `riinac build` and `riinac pkg build` link with.
//!
//! Supported (owner ruling on REQ-102, 2026-10-20, option B; a documented
//! deviation from mandate S3.3(iii)): gcc or clang, invoked as `cc`, on Linux
//! and macOS. On Windows, build inside WSL; MinGW is planned. MSVC (`cl`) is
//! not supported, because the emitted C includes POSIX headers
//! (`<unistd.h>`, `<sys/socket.h>`, `<pthread.h>`).
//!
//! The build used to say only "Failed to invoke cc: No such file or
//! directory". On a machine that has `cl` but no `cc` that read like a
//! missing install rather than an unsupported compiler, so a missing `cc`
//! now gets a message naming the supported set and the way forward.

use std::ffi::OsStr;
use std::io;
use std::path::Path;

/// The program the native backends invoke.
pub const C_COMPILER: &str = "cc";

/// The error to print when invoking [`C_COMPILER`] failed with `err`.
/// `path_var` is the `PATH` to search for MSVC's `cl`.
pub fn invoke_error(err: &io::Error, path_var: Option<&OsStr>) -> String {
    if err.kind() != io::ErrorKind::NotFound {
        return format!("failed to invoke the C compiler `{C_COMPILER}`: {err}");
    }
    let supported = "riinac needs gcc or clang, invoked as `cc`, on Linux or macOS; \
                     on Windows, build inside WSL (MinGW support is planned)";
    if path_var.is_some_and(|p| on_path(p, "cl")) {
        format!(
            "no `{C_COMPILER}` found, only MSVC (`cl`). MSVC is not supported: the emitted \
             C uses POSIX headers. {supported}."
        )
    } else {
        format!("no C compiler `{C_COMPILER}` found on PATH. {supported}.")
    }
}

/// Whether an executable file named `name` (or `name.exe`) is on `path_var`.
fn on_path(path_var: &OsStr, name: &str) -> bool {
    std::env::split_paths(path_var).any(|dir| {
        [name.to_string(), format!("{name}.exe")]
            .iter()
            .any(|file| is_executable(&dir.join(file)))
    })
}

fn is_executable(path: &Path) -> bool {
    let Ok(meta) = path.metadata() else {
        return false;
    };
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt as _;
        meta.is_file() && meta.permissions().mode() & 0o111 != 0
    }
    #[cfg(not(unix))]
    {
        meta.is_file()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn bin_dir(tag: &str, names: &[&str]) -> std::path::PathBuf {
        let dir = std::env::temp_dir().join(format!("riina_cc_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).unwrap();
        for name in names {
            let exe = dir.join(name);
            std::fs::write(&exe, "#!/bin/sh\n").unwrap();
            #[cfg(unix)]
            {
                use std::os::unix::fs::PermissionsExt as _;
                std::fs::set_permissions(&exe, std::fs::Permissions::from_mode(0o755)).unwrap();
            }
        }
        dir
    }

    #[test]
    fn a_missing_cc_with_msvc_present_names_msvc_as_unsupported() {
        let dir = bin_dir("msvc", &["cl"]);
        let err = io::Error::from(io::ErrorKind::NotFound);
        let msg = invoke_error(&err, Some(dir.as_os_str()));
        assert!(msg.contains("only MSVC"), "{msg}");
        assert!(msg.contains("not supported") && msg.contains("WSL"), "{msg}");
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn a_missing_cc_without_msvc_names_the_supported_compilers() {
        let dir = bin_dir("none", &["clx"]);
        let err = io::Error::from(io::ErrorKind::NotFound);
        let msg = invoke_error(&err, Some(dir.as_os_str()));
        assert!(!msg.contains("MSVC"), "{msg}");
        assert!(msg.contains("gcc or clang") && msg.contains("WSL"), "{msg}");
        let _ = std::fs::remove_dir_all(&dir);
    }

    #[test]
    fn other_invocation_errors_are_reported_as_they_are() {
        let err = io::Error::from(io::ErrorKind::PermissionDenied);
        let msg = invoke_error(&err, None);
        assert!(msg.starts_with("failed to invoke the C compiler `cc`"), "{msg}");
    }
}
