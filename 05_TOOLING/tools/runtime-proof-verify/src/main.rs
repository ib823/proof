// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Runtime proof bundle verifier.
//!
//! Usage:
//!   runtime-proof-verify --self-check
//!   runtime-proof-verify <bundle.rpb>

use std::env;
use std::fs;

use riina_effect::{RuntimeEvent, RuntimeEventKind, RuntimeProofBundle};

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() == 2 && args[1] == "--self-check" {
        if let Err(err) = self_check() {
            eprintln!("SELF-CHECK FAIL: {err}");
            std::process::exit(1);
        }
        println!("SELF-CHECK PASS");
        return;
    }

    if args.len() != 2 {
        eprintln!("usage: runtime-proof-verify --self-check | <bundle.rpb>");
        std::process::exit(2);
    }

    let path = &args[1];
    let content = match fs::read_to_string(path) {
        Ok(content) => content,
        Err(err) => {
            eprintln!("failed to read {path}: {err}");
            std::process::exit(1);
        }
    };

    match parse_bundle(&content) {
        Ok(bundle) => match bundle.verify_chain() {
            Ok(()) => {
                println!("VALID");
            }
            Err(err) => {
                eprintln!("INVALID: {err:?}");
                std::process::exit(1);
            }
        },
        Err(err) => {
            eprintln!("PARSE ERROR: {err}");
            std::process::exit(1);
        }
    }
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

    let encoded = encode_bundle(&bundle);
    let parsed = parse_bundle(&encoded)?;
    parsed
        .verify_chain()
        .map_err(|err| format!("verify after parse failed: {err:?}"))?;
    Ok(())
}

fn encode_bundle(bundle: &RuntimeProofBundle) -> String {
    let mut lines = Vec::new();
    lines.push(format!("version:{}", bundle.version));
    lines.push(format!("program_hash:{}", to_hex(&bundle.program_hash)));
    lines.push(format!("chain_head:{}", to_hex(&bundle.chain_head)));
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

fn parse_bundle(input: &str) -> Result<RuntimeProofBundle, String> {
    let mut version: Option<u32> = None;
    let mut program_hash: Option<[u8; 32]> = None;
    let mut chain_head: Option<[u8; 32]> = None;
    let mut events: Vec<RuntimeEvent> = Vec::new();

    for raw in input.lines() {
        let line = raw.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        if let Some(value) = line.strip_prefix("version:") {
            version = Some(
                value
                    .parse::<u32>()
                    .map_err(|err| format!("invalid version: {err}"))?,
            );
            continue;
        }
        if let Some(value) = line.strip_prefix("program_hash:") {
            program_hash = Some(parse_hex_32(value)?);
            continue;
        }
        if let Some(value) = line.strip_prefix("chain_head:") {
            chain_head = Some(parse_hex_32(value)?);
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

    Ok(RuntimeProofBundle {
        version,
        program_hash,
        events,
        chain_head,
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
    if clean.len() % 2 != 0 {
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
    use super::{parse_hex_32, self_check, to_hex};

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
}
