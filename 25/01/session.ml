let data = In_channel.with_open_text "input.txt" In_channel.input_all;;
let split_at s i = (String.sub s 0 i, String.sub s i (String.length s - i));;
let p_line l = match split_at l 1 with
  | ("L", num) -> Some (int_of_string num )
  | ("R", num) -> Some (- int_of_string num)
  | _ -> None
;;
let floor_div x = if x >= 0 then x / 100 else (x - 99) / 100;;
let count_revolutions a b =
  let (x, y) = if a <= b then (b,a) else (a-1, b-1) in
  (floor_div x) - (floor_div y)
;;
let pairwise xs = Seq.zip xs (Seq.drop 1 xs);;
let uncurry f (x, y) = f x y;;

let p_common x =
 String.trim x
  |> String.split_on_char '\n'
  |> List.to_seq
  |> Seq.filter_map p_line
  |> Seq.scan (+) 50

let p1 x = p_common x
  |> Seq.filter (fun x -> (x mod 100) == 0)
  |> Seq.length;;

let p2 x = p_common x
  |> pairwise
  |> Seq.map @@ uncurry count_revolutions
  |> Seq.fold_left (+) 0
;;

let () =
  Printf.printf "p1: %d\n" @@ p1 data;
  Printf.printf "p2: %d\n" @@ p2 data
