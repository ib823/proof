# RIINA Compiler — Production Dockerfile
# Multi-stage build: builder → minimal runtime (~50MB)
# Verification gate: riinac verify [--fast|--full]
#
# Base images are pinned by DIGEST (tag kept for readability): a tag can be
# re-pointed upstream, a digest cannot. The builder must satisfy the workspace's
# `rust-version = "1.94.1"` — the previous `rust:1.84` image could not build it.

# Stage 1: Build
FROM rust:1.94.1-bookworm@sha256:6ae102bdbf528294bc79ad6e1fae682f6f7c2a6e6621506ba959f9685b308a55 AS builder

WORKDIR /build

# Copy only what's needed for compilation
COPY 03_PROTO/ 03_PROTO/

WORKDIR /build/03_PROTO

# Build release binary exactly from Cargo.lock
RUN cargo build --release --locked && \
    cp target/release/riinac /riinac

# Stage 2: Minimal runtime
FROM debian:bookworm-slim@sha256:7c7b2c966bc9ee8cedfeef67e0e279108992c77681fa595db4a9d65c06ccc587

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --system --uid 10001 --create-home --home-dir /home/riina --shell /usr/sbin/nologin riina

COPY --from=builder /riinac /usr/local/bin/riinac

LABEL maintainer="RIINA Team <security@riina.my>"
LABEL version="0.4.0"
LABEL description="RIINA compiler — formally verified, zero-trust"
LABEL license="Proprietary"

# The compiler needs no privileges: run as an unprivileged user.
USER riina
WORKDIR /home/riina

ENTRYPOINT ["riinac"]
