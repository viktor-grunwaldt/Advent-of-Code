let data = In_channel.with_open_text "input.txt" In_channel.input_all;;
let rec transpose list = match list with
| []             -> []
| []      :: xss -> transpose xss
| (x::xs) :: xss ->
    List.(
      (x :: map hd xss) :: transpose (xs :: map tl xss)
    );;
let p_line = Str.split (Str.regexp " +");;
let p_data data = String.trim data |> String.split_on_char '\n' |> List.map p_line;;
let do_row a xs = a + match xs with
| "+"::xs -> List.map int_of_string xs |> List.fold_left (+) 0
| "*"::xs -> List.map int_of_string xs |> List.fold_left ( * ) 1
| _ -> failwith "Invalid data"
;;
let p1 data= p_data data |> transpose |> List.map List.rev |> List.fold_left do_row 0;;

let flip_row row = row |> String.to_seq |> List.of_seq |> List.rev;;

let rec split_at i xs = match i, xs with
| 0, xs -> [], xs
| _, x::xs -> let l,r = split_at (pred i) xs in
x::l, r
| _ -> failwith "i is greater than length of list"
;;

let p_col xs = let l,r = split_at (List.length xs |> pred) xs in
let num = l |> List.to_seq |> String.of_seq |> String.trim |> int_of_string_opt in
  num, List.hd r
;;

let eval (stack, res) (num, op) = match num with
| None -> (stack, res)
| Some num ->
  match op with
  | ' ' -> num::stack, res
  | '+' -> [], res + List.fold_left (+) num stack
  | '*' -> [], res + List.fold_left ( * ) num stack 
  | _ -> failwith @@ "invalid op: " ^ (Char.escaped op)
;;

let p2 data = data
  |> String.split_on_char '\n'
  |> List.map flip_row
  |> List.filter @@ (<>) []
  |> transpose
  |> List.map p_col
  |> List.fold_left eval ([],0) 
;;

