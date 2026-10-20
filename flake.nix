{
  description = "RIINA — Rigorous Immutable Invariant, No Assumptions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      packages = forAllSystems (system:
        let pkgs = pkgsFor system; in {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "riinac";
            version = "0.4.0"; # keep in sync with the repo-root VERSION file
            src = ./03_PROTO;
            cargoLock.lockFile = ./03_PROTO/Cargo.lock;
            meta = with pkgs.lib; {
              description = "RIINA compiler — a programming language with a Coq-verified core model";
              homepage = "https://github.com/ib823/riina";
              # The repository LICENSE is proprietary (see ./LICENSE); this
              # previously declared MPL-2.0.
              license = licenses.unfree;
              mainProgram = "riinac";
            };
          };
        }
      );

      devShells = forAllSystems (system:
        let pkgs = pkgsFor system; in {
          default = pkgs.mkShell {
            # No `coq` here on purpose: nixos-24.11 ships Coq 8.20, but the
            # corpus needs Rocq 9.1.1 + stdlib 9.1.0 (it uses `From Stdlib`).
            # The pin has ONE definition, scripts/provision-coq.sh (CI uses the
            # same script); this shell provides what that script needs.
            buildInputs = with pkgs; [
              (rust-bin.stable."1.94.1".default)
              gcc
              opam
              gmp
              m4
            ];
            shellHook = ''
              echo "RIINA dev shell — Rust $(rustc --version)"
              echo "Rocq (pinned 9.1.1): bash scripts/provision-coq.sh && eval \$(opam env --switch=rocq)"
            '';
          };
        }
      );
    };
}
