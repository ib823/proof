// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Publisher signatures end to end through the real `riinac pkg` binary.
//!
//! Before this, `pkg lock` against a remote registry was trust-on-first-use:
//! whatever archive the registry served first was pinned. These tests run a
//! loopback registry (an honest-but-dumb store that keeps whatever is
//! published and can be made to serve tampered bytes) and drive
//! `keygen` → `publish` → `lock` → `build` with separate publisher and
//! consumer home directories, checking that the consumer refuses unsigned,
//! untrusted and tampered packages, pins the signer in `riina.lock`, and fails
//! closed when the signer changes.

use std::collections::BTreeMap;
use std::io::{BufRead, BufReader, Read, Write};
use std::net::TcpListener;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::{Arc, Mutex};

/// name -> version -> (archive, signature document)
type Store = Arc<Mutex<BTreeMap<String, BTreeMap<String, (Vec<u8>, Option<String>)>>>>;

/// Start a loopback registry implementing the riina-pkg HTTP API.
fn start_registry() -> (String, Store) {
    let listener = TcpListener::bind("127.0.0.1:0").expect("bind registry");
    let url = format!("http://{}", listener.local_addr().expect("addr"));
    let store: Store = Arc::default();
    let shared = Arc::clone(&store);
    std::thread::spawn(move || {
        for stream in listener.incoming() {
            let Ok(mut stream) = stream else { continue };
            let Ok(clone) = stream.try_clone() else {
                continue;
            };
            let mut reader = BufReader::new(clone);
            let mut request_line = String::new();
            if reader.read_line(&mut request_line).is_err() {
                continue;
            }
            let mut length = 0usize;
            loop {
                let mut line = String::new();
                if reader.read_line(&mut line).unwrap_or(0) == 0 || line.trim().is_empty() {
                    break;
                }
                if let Some(v) = line.to_ascii_lowercase().strip_prefix("content-length:") {
                    length = v.trim().parse().unwrap_or(0);
                }
            }
            let mut body = vec![0u8; length];
            if reader.read_exact(&mut body).is_err() {
                continue;
            }
            let mut parts = request_line.split_whitespace();
            let method = parts.next().unwrap_or("").to_string();
            let target = parts.next().unwrap_or("").to_string();
            let (status, reply) = handle(&shared, &method, &target, body);
            let head = format!(
                "HTTP/1.1 {status} X\r\nContent-Length: {}\r\nConnection: close\r\n\r\n",
                reply.len()
            );
            let _ = stream.write_all(head.as_bytes());
            if method != "HEAD" {
                let _ = stream.write_all(&reply);
            }
        }
    });
    (url, store)
}

fn handle(store: &Store, method: &str, target: &str, body: Vec<u8>) -> (u16, Vec<u8>) {
    let (path, query) = target.split_once('?').unwrap_or((target, ""));
    let params: BTreeMap<&str, &str> = query
        .split('&')
        .filter_map(|kv| kv.split_once('='))
        .collect();
    let segments: Vec<&str> = path
        .trim_start_matches("/api/v1/crates/")
        .split('/')
        .collect();
    let mut store = store.lock().expect("store");
    match (method, segments.as_slice()) {
        ("POST", ["new"]) => {
            let (name, version) = (params["name"], params["version"]);
            let signature = params.get("signature").map(|sig| {
                format!(
                    "riina-pkg-signature v1\nnama = \"{name}\"\nversi = \"{version}\"\n\
                     arkib-sha256 = \"{}\"\npenandatangan = \"{}\"\ntandatangan = \"{sig}\"\n",
                    params["sha256"], params["signer"]
                )
            });
            store
                .entry(name.into())
                .or_default()
                .insert(version.into(), (body, signature));
            (200, b"ok".to_vec())
        }
        ("GET", [name, "versions"]) => {
            let versions: Vec<String> = store
                .get(*name)
                .map(|v| v.keys().map(|k| format!("\"{k}\"")).collect())
                .unwrap_or_default();
            (
                200,
                format!("{{\"versions\":[{}]}}", versions.join(",")).into_bytes(),
            )
        }
        (_, [name, version, what]) => {
            let Some((archive, signature)) = store.get(*name).and_then(|v| v.get(*version)) else {
                return (404, b"no such package".to_vec());
            };
            match *what {
                "manifest" => (200, tar_member(archive, "riina.toml").unwrap_or_default()),
                "download" => (200, archive.clone()),
                "signature" => match signature {
                    Some(doc) => (200, doc.clone().into_bytes()),
                    None => (404, b"unsigned".to_vec()),
                },
                _ => (404, Vec::new()),
            }
        }
        _ => (404, Vec::new()),
    }
}

/// Contents of `member` in a ustar archive.
fn tar_member(archive: &[u8], member: &str) -> Option<Vec<u8>> {
    let mut offset = 0;
    while offset + 512 <= archive.len() {
        let header = &archive[offset..offset + 512];
        if header.iter().all(|&b| b == 0) {
            return None;
        }
        let name_end = header[..100].iter().position(|&b| b == 0).unwrap_or(100);
        let name = std::str::from_utf8(&header[..name_end]).ok()?;
        let size_field = std::str::from_utf8(&header[124..135]).ok()?;
        let size = usize::from_str_radix(size_field.trim_matches(char::from(0)).trim(), 8).ok()?;
        let data = offset + 512;
        if name == member {
            return archive.get(data..data + size).map(<[u8]>::to_vec);
        }
        offset = data + size.div_ceil(512) * 512;
    }
    None
}

/// A scratch directory that cleans itself up.
struct Scratch(PathBuf);

impl Scratch {
    fn new(tag: &str) -> Self {
        let dir = std::env::temp_dir().join(format!("riina_pkgsig_{tag}_{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).expect("create scratch");
        Self(dir)
    }

    fn dir(&self, name: &str) -> PathBuf {
        let path = self.0.join(name);
        std::fs::create_dir_all(&path).expect("create dir");
        path
    }
}

impl Drop for Scratch {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}

/// Run `riinac pkg <args>` in `cwd` with `HOME=home`; (success, stdout, stderr).
fn pkg(home: &Path, cwd: &Path, args: &[&str]) -> (bool, String, String) {
    let out = Command::new(env!("CARGO_BIN_EXE_riinac"))
        .arg("pkg")
        .args(args)
        .current_dir(cwd)
        .env("HOME", home)
        .env_remove("RIINA_REGISTRY")
        .output()
        .expect("run riinac pkg");
    (
        out.status.success(),
        String::from_utf8_lossy(&out.stdout).into_owned(),
        String::from_utf8_lossy(&out.stderr).into_owned(),
    )
}

fn ok(home: &Path, cwd: &Path, args: &[&str]) -> (String, String) {
    let (success, stdout, stderr) = pkg(home, cwd, args);
    assert!(success, "riinac pkg {args:?} failed:\n{stderr}");
    (stdout, stderr)
}

fn fails(home: &Path, cwd: &Path, args: &[&str]) -> String {
    let (success, _, stderr) = pkg(home, cwd, args);
    assert!(
        !success,
        "riinac pkg {args:?} unexpectedly succeeded:\n{stderr}"
    );
    stderr
}

/// `pkg init <name>` in a fresh directory.
fn new_package(scratch: &Scratch, home: &Path, name: &str) -> PathBuf {
    let dir = scratch.dir(name);
    ok(home, &dir, &["init", name]);
    dir
}

/// A consumer app depending on `dep` from the registry at `url`, trusting
/// `trusted` (key ids).
fn consumer(
    scratch: &Scratch,
    home: &Path,
    tag: &str,
    dep: &str,
    url: &str,
    trusted: &[&str],
) -> PathBuf {
    let dir = new_package(scratch, home, tag);
    ok(home, &dir, &["add", dep, "^0.1.0"]);
    let quoted: Vec<String> = trusted.iter().map(|k| format!("\"{k}\"")).collect();
    let manifest = dir.join("riina.toml");
    let mut text = std::fs::read_to_string(&manifest).expect("read manifest");
    text.push_str(&format!(
        "\n[registry]\nurl = \"{url}\"\ntrusted-publishers = [{}]\n",
        quoted.join(", ")
    ));
    std::fs::write(&manifest, text).expect("write manifest");
    dir
}

#[test]
fn signed_publish_lock_and_build_end_to_end() {
    let scratch = Scratch::new("e2e");
    let (url, store) = start_registry();
    let publisher_home = scratch.dir("home-publisher");

    // keygen: default location, owner-only private key, never overwritten.
    let (key_id, _) = ok(&publisher_home, &publisher_home, &["keygen"]);
    let key_id = key_id.trim().to_string();
    assert!(
        key_id.starts_with("ed25519:") && key_id.len() == 8 + 64,
        "{key_id}"
    );
    let private = publisher_home.join(".riina/keys/publisher.priv");
    let public = publisher_home.join(".riina/keys/publisher.pub");
    #[cfg(unix)]
    {
        use std::os::unix::fs::PermissionsExt;
        let mode = std::fs::metadata(&private)
            .expect("priv")
            .permissions()
            .mode();
        assert_eq!(mode & 0o777, 0o600);
    }
    let before = std::fs::read(&private).expect("read priv");
    let err = fails(&publisher_home, &publisher_home, &["keygen"]);
    assert!(err.contains("refusing to overwrite"), "{err}");
    assert_eq!(std::fs::read(&private).expect("read priv"), before);
    let (printed, _) = ok(
        &publisher_home,
        &publisher_home,
        &["key-id", public.to_str().unwrap()],
    );
    assert_eq!(printed.trim(), key_id);

    // publish: signed with the default key.
    let pustaka = new_package(&scratch, &publisher_home, "pustaka");
    let (_, err) = ok(&publisher_home, &pustaka, &["--registry", &url, "publish"]);
    assert!(err.contains(&format!("Signed by {key_id}")), "{err}");
    assert!(store.lock().unwrap()["pustaka"]["0.1.0"].1.is_some());

    // A publisher without a key cannot publish to a remote registry...
    let keyless_home = scratch.dir("home-keyless");
    let tanpa = new_package(&scratch, &keyless_home, "tanpa-tanda");
    let err = fails(&keyless_home, &tanpa, &["--registry", &url, "publish"]);
    assert!(err.contains("requires a publisher signing key"), "{err}");
    // ... unless they explicitly publish unsigned, loudly.
    let (_, err) = ok(
        &keyless_home,
        &tanpa,
        &["--registry", &url, "--insecure-allow-unsigned", "publish"],
    );
    assert!(err.contains("UNSIGNED"), "{err}");

    // Consumer that has not (yet) trusted the publisher: refused.
    let consumer_home = scratch.dir("home-consumer");
    let app = consumer(&scratch, &consumer_home, "app", "pustaka", &url, &[]);
    let err = fails(&consumer_home, &app, &["lock"]);
    assert!(err.contains("not a trusted publisher"), "{err}");
    assert!(!app.join("riina.lock").exists());

    // Trusting the key: lock pins checksum AND signer; no warnings.
    let app = consumer(
        &scratch,
        &consumer_home,
        "app-trusting",
        "pustaka",
        &url,
        &[&key_id],
    );
    let (_, err) = ok(&consumer_home, &app, &["lock"]);
    assert!(!err.contains("WARNING"), "{err}");
    let lock = std::fs::read_to_string(app.join("riina.lock")).expect("lock");
    assert!(
        lock.contains(&format!("penandatangan = \"{key_id}\"")),
        "{lock}"
    );
    ok(&consumer_home, &app, &["build"]);

    // The lock's signer is changed (as if the registry now served the package
    // under another key): the locked build fails closed.
    let other = "ed25519:ea4a6c63e29c520abef5507b132ec5f9954776aebebe7b92421eea691446d22c";
    std::fs::write(app.join("riina.lock"), lock.replace(&key_id, other)).expect("rewrite lock");
    let err = fails(&consumer_home, &app, &["build"]);
    assert!(err.contains("signer of package `pustaka` changed"), "{err}");

    // An unsigned package: refused, or accepted only with the loud opt-out,
    // which records it as unsigned.
    let app = consumer(
        &scratch,
        &consumer_home,
        "app-unsigned",
        "tanpa-tanda",
        &url,
        &[&key_id],
    );
    let err = fails(&consumer_home, &app, &["lock"]);
    assert!(err.contains("no publisher signature"), "{err}");
    let (_, err) = ok(&consumer_home, &app, &["--insecure-allow-unsigned", "lock"]);
    assert!(
        err.contains("WARNING: INSECURE") && err.contains("UNSIGNED"),
        "{err}"
    );
    let lock = std::fs::read_to_string(app.join("riina.lock")).expect("lock");
    assert!(lock.contains("penandatangan = \"unsigned\""), "{lock}");
    // Building it later still needs the opt-out.
    let err = fails(&consumer_home, &app, &["build"]);
    assert!(err.contains("no publisher signature"), "{err}");

    // A compromised registry serves different bytes under the old signature:
    // a fresh consumer refuses them before unpacking anything.
    {
        let mut store = store.lock().unwrap();
        let entry = store.get_mut("pustaka").unwrap().get_mut("0.1.0").unwrap();
        let archive = &mut entry.0;
        let at = archive
            .windows(b"pulang 0".len())
            .position(|w| w == b"pulang 0")
            .expect("library source in archive");
        archive[at + b"pulang ".len()] = b'7';
    }
    let fresh_home = scratch.dir("home-fresh");
    let app = consumer(
        &scratch,
        &fresh_home,
        "app-fresh",
        "pustaka",
        &url,
        &[&key_id],
    );
    let err = fails(&fresh_home, &app, &["lock"]);
    assert!(err.contains("SHA-256"), "{err}");
    assert!(
        !fresh_home.join(".riina/cache").exists() || !has_package(&fresh_home.join(".riina/cache"))
    );
}

/// Whether any unpacked package exists under a cache directory.
fn has_package(dir: &Path) -> bool {
    let Ok(entries) = std::fs::read_dir(dir) else {
        return false;
    };
    entries.flatten().any(|entry| {
        let path = entry.path();
        path.join("riina.toml").is_file() || (path.is_dir() && has_package(&path))
    })
}
