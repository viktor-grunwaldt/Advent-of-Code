let data = In_channel.with_open_text "input.txt" In_channel.input_all;;
let char_to_int c = (int_of_char c) - 48;;
let p_line s = s |> String.to_seq |> Seq.map char_to_int |> List.of_seq;;
let rec pow base expn =
  Seq.init expn (fun _ -> base) |> Seq.fold_left ( *) 1 
;;
let rec highest_joltage digits xs = match digits, xs with
  | 0, _ -> None
  | _, [] -> None
  | 1, y::ys -> Some (List.fold_left max y ys)
  | d, y::ys ->
    let d1 = d - 1 in
    let picked = highest_joltage d1 ys |> Option.map @@ (+) (y * (pow 10 d1)) 
    and not_picked = highest_joltage d ys
    in max picked not_picked
;;
let p1 x = x
  |> String.split_on_char '\n'
  |> List.filter_map (fun y -> y |> p_line |> highest_joltage 2)
  |> List.fold_left (+) 0
;;
(* too slow *)
(* let p2 x = x *)
  (* |> String.split_on_char '\n' *)
  (* |> List.filter_map (fun y -> y |> p_line |> highest_joltage 12) *)
  (* |> List.fold_left (+) 0 *)
(* ;; *)

let memo_2d h =
  let rec f digits xs =
    try Hashtbl.find h (digits, List.length xs)
    with Not_found ->
      let value = match digits, xs with
        | 0, _ -> None
        | _, [] -> None
        | 1, y::ys -> Some (List.fold_left max y ys)
        | d, y::ys ->
          let d1 = d - 1 in
          let picked = f d1 ys |> Option.map @@ (+) (y * (pow 10 d1)) 
          and not_picked = f d ys
          in max picked not_picked
      in
      Hashtbl.add h (digits, List.length xs) value;
      value
    in f
;;

let p2 x = x
  |> String.split_on_char '\n'
  |> List.filter_map (fun y -> y |> p_line |> memo_2d (Hashtbl.create 16) 12)
  |> List.fold_left (+) 0
;;
