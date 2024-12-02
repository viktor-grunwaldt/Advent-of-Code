with builtins;
let
  lib = import <nixpkgs/lib>;
  trans =
    { l, r }:
    x: {
      l = l ++ [ (head x) ];
      r = r ++ [ (builtins.elemAt x 1) ];
    };
  acc = {
    l = [ ];
    r = [ ];
  };
  regex = "([[:digit:]]+)[[:space:]]+([[:digit:]]+)\n*";
in
{
  lib = lib;
  collect = foldl' (acc: x: acc // { ${x} = (acc.${x} or 0) + 1; }) { };
  similarityScore = c: (x: (c.${x} or 0) * (lib.toInt x));
  parse = s: split regex s |> filter isList |> foldl' trans acc;
}
