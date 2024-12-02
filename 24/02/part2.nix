with builtins;
let
  lib = import <nixpkgs/lib>;
  isSafe =
    xs:
    let
      get = elemAt xs;
      equal = (get 0) == (get 1);
      inc = (get 0) < (get 1);
      isSequential = x: if inc then (0 < x && x <= 3) else (0 > x && x >= -3);
      nats = genList (x: x);
      mapOverNats = fn: (length xs) - 1 |> nats |> map fn;
      adjDiff = i: (get (i + 1)) - (get i);
    in
    !equal && (mapOverNats adjDiff |> all isSequential);
  parseLine = l: split " " l |> filter isString |> map lib.toInt;
  rmAt =
    idx: xs:
    lib.imap0 (i: x: {i = i;x = x;}) xs
    |> filter ({ i, ... }: i != idx)
    |> map (getAttr "x");
  everyRemoved = xs: lib.genList (i: rmAt i xs) (length xs);
in
readFile ./in
|> split "\n"
|> filter (x: isString x && x != "")
|> map parseLine
|> map (line: any isSafe (everyRemoved line))
|> foldl' (acc: x: acc + (if x then 1 else 0)) 0
