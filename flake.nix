{
  description = "Flake to manage python workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
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
        # pdbpp = let 
        #   pname = "pdbpp";
        #   version = "0.10.3";
        # in pkgs.python312Packages.buildPythonPackage {
        #   inherit pname version;
        #   src = pkgs.fetchPypi {
        #     inherit pname version;
        #     sha256 = "sha256-2eQ/T9o4jus2XyiH9Oe2asCdzptiNrdvY2FlMOL2afU=";
        #   };
        #   doCheck = false;
        #   # # specific to buildPythonPackage, see its reference
        #   # pyproject = true;
        #   # build-system = [
        #   #   pkgs.python312Packages.setuptools
        #   #   pkgs.python312Packages.wheel
        #   # ];
        # };
      in
      {
        devShells.default = with pkgs; mkShell {
          packages = [
            (python312.withPackages (ppg: [
              ppg.more-itertools
              ppg.icecream
            ]))
            pyright
            ruff
            # too hard
            # pdbpp
          ];
        };
      });
}
