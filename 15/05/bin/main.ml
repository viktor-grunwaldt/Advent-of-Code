let data = In_channel.with_open_text "input.txt" In_channel.input_all;;

module CharMap = Map.Make(Char);;

let has_vowels text =
  let myacc = CharMap.of_list @@ List.combine (List.of_seq @@ String.to_seq "aeiou") [0;0;0;0;0] in
  let myfold map c = CharMap.update c (Option.map (fun x -> x + 1)) map in
  String.fold_left myfold myacc text
  |> fun counter -> CharMap.fold (fun _ x acc -> acc + x) counter 0
  |> fun x -> x >= 3

let pairwise xs = Seq.zip xs (Seq.drop 1 xs);;
let uncurry f (x,y) = f x y;;
let has_repeating text = String.to_seq text
  |> pairwise
  |> Seq.exists @@ uncurry (==)
;;

let has_illegal text = String.to_seq text
  |> pairwise
  |> Seq.exists (fun x -> List.mem x [('a', 'b'); ('c', 'd'); ('p', 'q'); ('x', 'y');])
;;
let is_nice text = has_vowels text && has_repeating text && Bool.not (has_illegal text);;
let pt1 data = String.trim data
  |> String.split_on_char '\n'
  |> List.filter is_nice
  |> List.length
;;

let r1 = Str.regexp "\\(..\\).*\\1";; 
let r2 = Str.regexp "\\(.\\).\\1";;
let is_really_nice text =
  try
    ignore (Str.search_forward r1 text 0);
    ignore (Str.search_forward r2 text 0);
    true
  with Not_found -> false
;;

let pt2 data = String.trim data
  |> String.split_on_char '\n'
  |> List.filter is_really_nice
  |> List.length
;;
let a1 = "ugknbfddgicrmopn";;
let a2 = "jchzalrnumimnmhp";;
let a3 = "haegwjzuvuyypxyu";;
let a4 = "dvszwmarrgswjxmb";;
let a5 = "aaa";;
let () =
  Printf.printf "%s: %b\n" a1 @@ is_nice a1;
  Printf.printf "%s: %b\n" a2 @@ is_nice a2;
  Printf.printf "%s: %b\n" a3 @@ is_nice a3;
  Printf.printf "%s: %b\n" a4 @@ is_nice a4;
  Printf.printf "%s: %b\n" a5 @@ is_nice a5;
  Printf.printf "pt1: %d\n" @@ pt1 data;
  Printf.printf "pt1: %d\n" @@ pt1 data;
  Printf.printf "pt2: %d\n" @@ pt2 data;
