with builtins;
with (import ./common.nix);
data: parse data |> ({ l, r }: map (similarityScore (collect r)) l) |> foldl' add 0
