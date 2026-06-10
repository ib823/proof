# RIINA root Makefile.
#
#   make verify-all   Reproducible verification one-liner (Gate G / REQ-32):
#                     re-derives every public metric from source — compiled Coq
#                     Qed count, Rust test count, doc/metric parity — via the
#                     canonical `riinac verify --full` plus the doc-parity audit.
#   make verify       Fast variant (static Qed scan, skips the heavy Coq recompile).
#   make coq | all    Build the active Coq corpus (delegates to 02_FORMAL/coq,
#                     whose generated Makefile drives `rocq compile -Q . RIINA`).
#   make clean        Clean Coq build artifacts.
#
# Prerequisites (pinned toolchains): Rust 1.94.1 and Rocq 9.2 on PATH. For Coq:
#   eval $(opam env --switch=rocq)
# `riinac verify` auto-detects the Coq binary via $COQBIN / the opam switch / PATH.

RIINAC = 03_PROTO/target/release/riinac

.PHONY: all coq verify-all verify clean

all: coq

# The canonical Coq build lives in 02_FORMAL/coq (CoqMakefile generated from
# _CoqProject). Delegate to it rather than duplicate the flags here.
coq:
	$(MAKE) -C 02_FORMAL/coq

verify-all:
	@echo "== [1/3] build the verifier (release) =="
	cargo build --release --manifest-path 03_PROTO/Cargo.toml -p riinac
	@echo "== [2/3] riinac verify --full: re-compile Coq (Qed), all Rust tests, clippy =="
	$(RIINAC) verify --full
	@echo "== [3/3] doc/metric parity audit (published counts == source) =="
	bash scripts/audit-docs.sh
	@echo ""
	@echo "verify-all: every public metric re-derived from source. OK"

verify:
	cargo build --release --manifest-path 03_PROTO/Cargo.toml -p riinac
	$(RIINAC) verify --fast

clean:
	-$(MAKE) -C 02_FORMAL/coq clean
