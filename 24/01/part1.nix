with builtins;
with (import ./common.nix);
data: data
|> parse
|> mapAttrs (name: val:  (map lib.toInt val) |> (sort lessThan))
|> ({ l, r }: lib.zipListsWith sub l r)
|> foldl' (acc: x: if x < 0 then acc - x else acc + x) 0
