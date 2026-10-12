// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Runtime proof bundle verifier.
//!
//! Usage:
//!   runtime-proof-verify --self-check
//!   runtime-proof-verify (--program-hash <hex64> | --program-identity <id>)
//!                        (--key-file <path> | --integrity-only) <bundle.rpb>
//!
//! The verifier must be told WHICH program the bundle is expected to describe
//! (`--program-hash`, or `--program-identity` hashed exactly as
//! `RuntimeProofBundle::new` hashes it); the bundle's own `program_hash` line
//! is attacker-chosen data until compared with that.
//!
//! Two modes, and the caller must pick one explicitly:
//!   * `--key-file <path>` — AUTHENTICATED: the bundle must carry an
//!     `auth_tag:<hex64>` line, an HMAC-SHA256 tag
//!     (`RuntimeProofBundle::authentication_tag`) under the hex-encoded key in
//!     `<path>` (at least 16 bytes). Prints `VALID (authenticated)`.
//!   * `--integrity-only` — the unkeyed SHA-256 chain only. Anyone can
//!     fabricate a bundle that passes, so a loud warning is printed and the
//!     verdict is `VALID (integrity only — NOT authenticity)`.
//!
//! Empty bundles are rejected in both modes. (Until 2026-10 the tool took only
//! a bundle path, checked only the unkeyed chain against the bundle's own
//! program hash, and printed `VALID` for an empty all-zero bundle.)

use std::env;
use std::fs;

use riina_effect::{RuntimeEvent, RuntimeEventKind, RuntimeProofBundle};

const USAGE: &str = "usage: runtime-proof-verify --self-check\n       \
     runtime-proof-verify (--program-hash <hex64> | --program-identity <id>)\n                            \
     (--key-file <path> | --integrity-only) <bundle.rpb>";

/// A key used ONLY by `--self-check` to exercise the authenticated path.
const SELF_CHECK_KEY: [u8; 32] = [0x52; 32];

/// What the command line asked for.
#[derive(Debug, PartialEq, Eq)]
enum Mode {
    SelfCheck,
    Verify {
        expected_program_hash: [u8; 32],
        key_file: Option<String>,
        bundle_path: String,
    },
}

/// A parsed bundle file: the bundle plus its optional authentication tag.
struct BundleFile {
    bundle: RuntimeProofBundle,
    auth_tag: Option<[u8; 32]>,
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();
    let mode = match parse_args(&args) {
        Ok(mode) => mode,
        Err(err) => {
            eprintln!("{err}\n{USAGE}");
            std::process::exit(2);
        }
    };

    match mode {
        Mode::SelfCheck => {
            if let Err(err) = self_check() {
                eprintln!("SELF-CHECK FAIL: {err}");
                std::process::exit(1);
            }
            println!("SELF-CHECK PASS");
        }
        Mode::Verify {
            expected_program_hash,
            key_file,
            bundle_path,
        } => {
            let key = match key_file.as_deref().map(read_key_file).transpose() {
                Ok(key) => key,
                Err(err) => {
                    eprintln!("{err}");
                    std::process::exit(1);
                }
            };
            let content = match fs::read_to_string(&bundle_path) {
                Ok(content) => content,
                Err(err) => {
                    eprintln!("failed to read {bundle_path}: {err}");
                    std::process::exit(1);
                }
            };
            match verify(&content, &expected_program_hash, key.as_deref()) {
                Ok(verdict) => {
                    if key.is_none() {
                        eprintln!("{INTEGRITY_ONLY_WARNING}");
                    }
                    println!("{verdict}");
                }
                Err(err) => {
                    eprintln!("INVALID: {err}");
                    std::process::exit(1);
                }
            }
        }
    }
}

const INTEGRITY_ONLY_WARNING: &str = "WARNING: --integrity-only checks an UNKEYED hash chain. It shows the \
bundle is internally consistent and names the expected program, NOT who produced it: anyone can \
fabricate a bundle that passes. Use --key-file for authenticity.";

fn parse_args(args: &[String]) -> Result<Mode, String> {
    if args.len() == 1 && args[0] == "--self-check" {
        return Ok(Mode::SelfCheck);
    }
    let mut program_hash: Option<[u8; 32]> = None;
    let mut key_file: Option<String> = None;
    let mut integrity_only = false;
    let mut bundle_path: Option<String> = None;
    let mut it = args.iter();
    while let Some(arg) = it.next() {
        match arg.as_str() {
            "--program-hash" | "--program-identity" | "--key-file" => {
                let value = it
                    .next()
                    .ok_or_else(|| format!("{arg} requires a value"))?;
                let slot_taken = match arg.as_str() {
                    "--key-file" => key_file.replace(value.clone()).is_some(),
                    "--program-hash" => program_hash.replace(parse_hex_32(value)?).is_some(),
                    _ => program_hash
                        .replace(RuntimeProofBundle::program_hash_for(value.as_bytes()))
                        .is_some(),
                };
                if slot_taken {
                    return Err(format!("{arg}: program/key given more than once"));
                }
            }
            "--integrity-only" => integrity_only = true,
            other if other.starts_with("--") => return Err(format!("unknown option {other}")),
            path => {
                if bundle_path.replace(path.to_string()).is_some() {
                    return Err("exactly one bundle path is required".to_string());
                }
            }
        }
    }
    let expected_program_hash = program_hash.ok_or_else(|| {
        "the expected program is required (--program-hash or --program-identity); \
         the bundle's own program_hash is not trusted"
            .to_string()
    })?;
    match (key_file.is_some(), integrity_only) {
        (true, true) => return Err("--key-file and --integrity-only are exclusive".to_string()),
        (false, false) => {
            return Err(
                "choose --key-file (authenticated) or --integrity-only (unauthenticated, \
                 explicit opt-in)"
                    .to_string(),
            )
        }
        _ => {}
    }
    Ok(Mode::Verify {
        expected_program_hash,
        key_file,
        bundle_path: bundle_path.ok_or_else(|| "a bundle path is required".to_string())?,
    })
}

/// Verify a bundle file's text. With a key, the `auth_tag` line is mandatory.
fn verify(content: &str, expected: &[u8; 32], key: Option<&[u8]>) -> Result<&'static str, String> {
    let file = parse_bundle(content)?;
    match key {
        Some(key) => {
            let tag = file
                .auth_tag
                .ok_or_else(|| "bundle has no auth_tag line (required with --key-file)".to_string())?;
            file.bundle
                .verify_authenticated(expected, key, &tag)
                .map_err(|err| format!("{err:?}"))?;
            Ok("VALID (authenticated: HMAC-SHA256 tag verified)")
        }
        None => {
            file.bundle
                .verify_for_program(expected)
                .map_err(|err| format!("{err:?}"))?;
            Ok("VALID (integrity only — NOT authenticity)")
        }
    }
}

/// Read a hex-encoded HMAC key (surrounding whitespace ignored).
fn read_key_file(path: &str) -> Result<Vec<u8>, String> {
    let text = fs::read_to_string(path).map_err(|err| format!("failed to read key {path}: {err}"))?;
    let key = parse_hex(text.trim()).map_err(|err| format!("key file {path}: {err}"))?;
    if key.len() < riina_effect::MIN_AUTH_KEY_LEN {
        return Err(format!(
            "key file {path}: key must be at least {} bytes",
            riina_effect::MIN_AUTH_KEY_LEN
        ));
    }
    Ok(key)
}

fn self_check() -> Result<(), String> {
    let mut bundle = RuntimeProofBundle::new(b"riina.self.check");
    bundle
        .append_event(1_700_000_000, RuntimeEventKind::EffectDecision, b"allow")
        .map_err(|err| format!("append event 1 failed: {err:?}"))?;
    bundle
        .append_event(1_700_000_001, RuntimeEventKind::ConstantTimeSample, b"ct")
        .map_err(|err| format!("append event 2 failed: {err:?}"))?;
    bundle
        .verify_chain()
        .map_err(|err| format!("verify before encode failed: {err:?}"))?;

    let expected = RuntimeProofBundle::program_hash_for(b"riina.self.check");
    let tag = bundle
        .authentication_tag(&SELF_CHECK_KEY)
        .map_err(|err| format!("tag failed: {err:?}"))?;
    let encoded = encode_bundle(&bundle, Some(&tag));
    verify(&encoded, &expected, Some(&SELF_CHECK_KEY))
        .map_err(|err| format!("authenticated verify after parse failed: {err}"))?;
    verify(&encoded, &expected, None)
        .map_err(|err| format!("integrity verify after parse failed: {err}"))?;

    // The negative cases must fail, or the self-check proves nothing.
    let empty = "version:1\nprogram_hash:".to_string()
        + &"0".repeat(64)
        + "\nchain_head:"
        + &"0".repeat(64);
    if verify(&empty, &[0u8; 32], None).is_ok() {
        return Err("an empty bundle verified".to_string());
    }
    if verify(&encoded, &RuntimeProofBundle::program_hash_for(b"other"), None).is_ok() {
        return Err("a bundle for another program verified".to_string());
    }
    if verify(&encode_bundle(&bundle, None), &expected, Some(&SELF_CHECK_KEY)).is_ok() {
        return Err("an untagged bundle passed authenticated verification".to_string());
    }
    Ok(())
}

fn encode_bundle(bundle: &RuntimeProofBundle, auth_tag: Option<&[u8; 32]>) -> String {
    let mut lines = Vec::new();
    lines.push(format!("version:{}", bundle.version));
    lines.push(format!("program_hash:{}", to_hex(&bundle.program_hash)));
    lines.push(format!("chain_head:{}", to_hex(&bundle.chain_head)));
    if let Some(tag) = auth_tag {
        lines.push(format!("auth_tag:{}", to_hex(tag)));
    }
    for event in &bundle.events {
        lines.push(format!(
            "event:{},{},{},{},{},{}",
            event.sequence,
            event.timestamp_unix,
            event.kind.as_u8(),
            to_hex(&event.payload_hash),
            to_hex(&event.previous_hash),
            to_hex(&event.event_hash)
        ));
    }
    lines.join("\n")
}

fn set_once<T>(slot: &mut Option<T>, value: T, what: &str) -> Result<(), String> {
    if slot.replace(value).is_some() {
        return Err(format!("duplicate {what} line"));
    }
    Ok(())
}

fn parse_bundle(input: &str) -> Result<BundleFile, String> {
    let mut version: Option<u32> = None;
    let mut program_hash: Option<[u8; 32]> = None;
    let mut chain_head: Option<[u8; 32]> = None;
    let mut auth_tag: Option<[u8; 32]> = None;
    let mut events: Vec<RuntimeEvent> = Vec::new();

    for raw in input.lines() {
        let line = raw.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        if let Some(value) = line.strip_prefix("version:") {
            let v = value
                .parse::<u32>()
                .map_err(|err| format!("invalid version: {err}"))?;
            set_once(&mut version, v, "version")?;
            continue;
        }
        if let Some(value) = line.strip_prefix("program_hash:") {
            set_once(&mut program_hash, parse_hex_32(value)?, "program_hash")?;
            continue;
        }
        if let Some(value) = line.strip_prefix("chain_head:") {
            set_once(&mut chain_head, parse_hex_32(value)?, "chain_head")?;
            continue;
        }
        if let Some(value) = line.strip_prefix("auth_tag:") {
            set_once(&mut auth_tag, parse_hex_32(value)?, "auth_tag")?;
            continue;
        }
        if let Some(value) = line.strip_prefix("event:") {
            let parts: Vec<&str> = value.split(',').collect();
            if parts.len() != 6 {
                return Err("event line must have 6 comma-separated fields".to_string());
            }
            let sequence = parts[0]
                .parse::<u64>()
                .map_err(|err| format!("invalid event sequence: {err}"))?;
            let timestamp_unix = parts[1]
                .parse::<u64>()
                .map_err(|err| format!("invalid event timestamp: {err}"))?;
            let kind_num = parts[2]
                .parse::<u8>()
                .map_err(|err| format!("invalid event kind: {err}"))?;
            let kind = parse_kind(kind_num)?;
            let payload_hash = parse_hex_32(parts[3])?;
            let previous_hash = parse_hex_32(parts[4])?;
            let event_hash = parse_hex_32(parts[5])?;
            events.push(RuntimeEvent {
                sequence,
                timestamp_unix,
                kind,
                payload_hash,
                previous_hash,
                event_hash,
            });
            continue;
        }
        return Err(format!("unknown line: {line}"));
    }

    let version = version.ok_or_else(|| "missing version".to_string())?;
    let program_hash = program_hash.ok_or_else(|| "missing program_hash".to_string())?;
    let chain_head = chain_head.ok_or_else(|| "missing chain_head".to_string())?;

    Ok(BundleFile {
        bundle: RuntimeProofBundle {
            version,
            program_hash,
            events,
            chain_head,
        },
        auth_tag,
    })
}

fn parse_kind(kind: u8) -> Result<RuntimeEventKind, String> {
    match kind {
        1 => Ok(RuntimeEventKind::EffectDecision),
        2 => Ok(RuntimeEventKind::StateTransition),
        3 => Ok(RuntimeEventKind::ConstantTimeSample),
        4 => Ok(RuntimeEventKind::ZeroizationWitness),
        5 => Ok(RuntimeEventKind::AttestationExtension),
        _ => Err(format!("unsupported event kind: {kind}")),
    }
}

fn to_hex(bytes: &[u8]) -> String {
    let mut out = String::with_capacity(bytes.len() * 2);
    for byte in bytes {
        out.push(nibble_to_hex(byte >> 4));
        out.push(nibble_to_hex(byte & 0x0f));
    }
    out
}

const fn nibble_to_hex(nibble: u8) -> char {
    match nibble {
        0..=9 => (b'0' + nibble) as char,
        10..=15 => (b'a' + (nibble - 10)) as char,
        _ => '0',
    }
}

fn parse_hex_32(text: &str) -> Result<[u8; 32], String> {
    let bytes = parse_hex(text)?;
    if bytes.len() != 32 {
        return Err(format!("expected 32 bytes, got {}", bytes.len()));
    }
    let mut out = [0u8; 32];
    out.copy_from_slice(&bytes);
    Ok(out)
}

fn parse_hex(text: &str) -> Result<Vec<u8>, String> {
    let clean = text.trim();
    if !clean.len().is_multiple_of(2) {
        return Err("hex string must have even length".to_string());
    }
    let mut out = Vec::with_capacity(clean.len() / 2);
    let chars: Vec<u8> = clean.bytes().collect();
    let mut i = 0usize;
    while i < chars.len() {
        let hi = hex_to_nibble(chars[i])?;
        let lo = hex_to_nibble(chars[i + 1])?;
        out.push((hi << 4) | lo);
        i += 2;
    }
    Ok(out)
}

fn hex_to_nibble(byte: u8) -> Result<u8, String> {
    match byte {
        b'0'..=b'9' => Ok(byte - b'0'),
        b'a'..=b'f' => Ok(byte - b'a' + 10),
        b'A'..=b'F' => Ok(byte - b'A' + 10),
        _ => Err(format!("invalid hex char: {}", byte as char)),
    }
}

#[cfg(test)]
mod tests {
    use super::{
        encode_bundle, parse_args, parse_hex_32, self_check, to_hex, verify, Mode, SELF_CHECK_KEY,
    };
    use riina_effect::{RuntimeEventKind, RuntimeProofBundle};

    fn args(list: &[&str]) -> Vec<String> {
        list.iter().map(|s| (*s).to_string()).collect()
    }

    fn sample() -> RuntimeProofBundle {
        let mut bundle = RuntimeProofBundle::new(b"prod-program");
        assert!(bundle
            .append_event(5, RuntimeEventKind::EffectDecision, b"allow")
            .is_ok());
        bundle
    }

    #[test]
    fn hex_roundtrip_32() {
        let input = [0xABu8; 32];
        let hex = to_hex(&input);
        let out = parse_hex_32(&hex).unwrap_or([0u8; 32]);
        assert_eq!(out, input);
    }

    #[test]
    fn verifier_self_check() {
        assert!(self_check().is_ok());
    }

    /// Regression (audit M3): `runtime-proof-verify empty.rpb` printed VALID.
    #[test]
    fn empty_all_zero_bundle_is_invalid() {
        let empty = format!(
            "version:1\nprogram_hash:{0}\nchain_head:{0}\n",
            "0".repeat(64)
        );
        assert!(verify(&empty, &[0u8; 32], None).is_err());
        assert!(verify(&empty, &[0u8; 32], Some(&SELF_CHECK_KEY)).is_err());
    }

    #[test]
    fn expected_program_is_required_and_enforced() {
        // No expected program → usage error, never a verdict.
        assert!(parse_args(&args(&["--integrity-only", "b.rpb"])).is_err());
        // No explicit mode → usage error (unauthenticated must be opted into).
        assert!(parse_args(&args(&["--program-identity", "p", "b.rpb"])).is_err());
        assert!(parse_args(&args(&["b.rpb"])).is_err());
        assert!(parse_args(&args(&[
            "--program-identity", "p", "--key-file", "k", "--integrity-only", "b.rpb"
        ]))
        .is_err());
        assert_eq!(
            parse_args(&args(&["--program-identity", "p", "--integrity-only", "b.rpb"])),
            Ok(Mode::Verify {
                expected_program_hash: RuntimeProofBundle::program_hash_for(b"p"),
                key_file: None,
                bundle_path: "b.rpb".to_string(),
            })
        );

        let encoded = encode_bundle(&sample(), None);
        let right = RuntimeProofBundle::program_hash_for(b"prod-program");
        let wrong = RuntimeProofBundle::program_hash_for(b"other-program");
        assert!(verify(&encoded, &right, None).is_ok());
        assert!(verify(&encoded, &wrong, None).is_err());
    }

    #[test]
    fn keyed_mode_requires_a_valid_tag() {
        let bundle = sample();
        let expected = RuntimeProofBundle::program_hash_for(b"prod-program");
        let key = [7u8; 32];
        let tag = bundle.authentication_tag(&key).unwrap_or([0u8; 32]);
        let tagged = encode_bundle(&bundle, Some(&tag));
        assert!(verify(&tagged, &expected, Some(&key)).is_ok());
        // Missing tag, wrong tag, wrong key: all rejected.
        assert!(verify(&encode_bundle(&bundle, None), &expected, Some(&key)).is_err());
        assert!(verify(&encode_bundle(&bundle, Some(&[0u8; 32])), &expected, Some(&key)).is_err());
        assert!(verify(&tagged, &expected, Some(&[8u8; 32])).is_err());
        // Duplicate fields are refused rather than last-one-wins.
        let dup = format!("{tagged}\nprogram_hash:{}", to_hex(&expected));
        assert!(verify(&dup, &expected, Some(&key)).is_err());
    }
}
