{
  description = "Flake to manage python workspace";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = with pkgs; mkShell {
          packages = [
            (python313.withPackages (ppg: [
              ppg.more-itertools
              # ppg.icecream
            ]))
            pyright
            ruff
            ocaml
            ocamlPackages.ocaml-lsp
            ocamlPackages.utop
            # too hard
            # pdbpp
          ];
        };
      });
}
