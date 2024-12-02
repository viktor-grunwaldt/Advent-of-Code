# day 1

## how to run:

1. Install the `nix` language (version >=2.24)

[https://nixos.org/download/](https://nixos.org/download/)

2. Open REPL

`nix --extra-experimental-features pipe-operators repl`

3. Run script in REPL

`nix-repl> import ./part1.nix (builtins.readFile {path to file with input data})`
