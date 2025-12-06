let data = In_channel.with_open_text "input.txt" In_channel.input_all;;

let load_padded_grid lines =
  let h = List.length lines in
  let w = String.length (List.hd lines) in
  let grid = Array.make_matrix (h + 2) (w + 2) '.' in

  List.iteri (fun r line ->
    String.iteri (fun c char ->
      grid.(r + 1).(c + 1) <- char
    ) line
  ) lines;

  ((h,w), grid)
;;

let seq_product s1 s2 =
  Seq.flat_map (fun x -> Seq.map (fun y -> (x,y)) s2) s1
;;
let neigh_iter i j = 
  seq_product (Seq.init 3 @@ (+) (i-1)) (Seq.init 3 @@ (+) (j-1))
;;
let get grid (i,j) = grid.(i).(j);;
let has_x_neigh x grid (i,j) = neigh_iter i j
  |> Seq.map @@ get grid |> Seq.filter ((=) '@') |> Seq.length |> ((>=) x)
;;
let find_accessible_rolls neigh_count ((h,w), grid) =
  seq_product (Seq.init h (fun x -> x+1)) (Seq.init w (fun x -> x+1))
  |> Seq.filter (fun (i,j) -> grid.(i).(j) = '@')
  |> Seq.filter (has_x_neigh neigh_count grid)
;;

let p_data d = d
  |> String.trim
  |> String.split_on_char '\n'
  |> load_padded_grid
;;
let p1 data = data |> p_data
  |> find_accessible_rolls 4
  |> Seq.length
;;

let _remove = List.fold_left (fun grid' (i,j) -> grid'.(i).(j) <- '.'; grid');;

let remove_tp neigh_count ((h,w), grid) =
  find_accessible_rolls neigh_count ((h,w), grid)
  |> List.of_seq
  |> (fun f g x -> (f x, g x)) List.length (_remove grid)
;;

let remove_until g = match remove_tp 4 g with
  | (0, grid) -> None
  | (count, grid) -> Some (count, (fst g, grid))
;;
let p2 data = data |> p_data
  |> Seq.unfold remove_until
  |> Seq.fold_left (+) 0
;;
