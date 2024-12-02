let
  lib = import <nixpkgs/lib>;
  isSafe =
    xs:
    let
      _xs = builtins.map lib.toInt xs;
      get = builtins.elemAt _xs;
      equal = (get 0) == (get 1);
      inc = (get 0) < (get 1);
    in
    !equal
    && (
      builtins.genList (x: x) ((builtins.length _xs) - 1) |> builtins.map (i: ((get (i + 1)) - (get i)))
    )
    |> builtins.all (x: if inc then (0 < x && x <= 3) else (0 > x && x >= -3));
  readReport = l: builtins.split " " l |> builtins.filter builtins.isString |> isSafe;
in
builtins.readFile ./in
|> builtins.split "\n"
|> builtins.filter (x: builtins.isString x && x != "")
|> builtins.map readReport
|> builtins.foldl' (acc: x: acc + (if x then 1 else 0)) 0
