(* #use "topfind";; *)
(* #require "str";; *)
let data = In_channel.with_open_text "input.txt" In_channel.input_all;;
let range x y = Seq.ints x |> Seq.take (y+1-x);;
let p_line s = String.split_on_char '-' s
  |> List.map int_of_string
  |> fun xs -> match xs with x :: y :: [] -> Some (range x y) | _ -> None
;;
let xs = String.trim data
  |>  String.split_on_char ','
  |> List.filter_map p_line
  |> List.to_seq
  |> Seq.concat
;;
let re1 = Str.regexp "^\\(.+\\)\\1$";;
let re2 = Str.regexp "^\\(.+\\)\\1+$";;
let matches_re regexp text =
  try ignore @@ Str.search_forward regexp text 0; true
  with Not_found -> false
;;
let common regexp xs = xs
  |> Seq.filter (fun x -> x |> string_of_int |>  matches_re regexp)
  |> Seq.fold_left (+) 0
;;
let p1 = common re1;;
let p2 = common re2;;
