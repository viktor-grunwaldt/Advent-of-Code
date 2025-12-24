module UnionFind = struct
  type t = { parent : int array; size : int array }

  let create n = { parent = Array.init n (fun i -> i); size = Array.make n 1 }

  let rec find t x =
    if t.parent.(x) = x then x
    else (
      t.parent.(x) <- find t t.parent.(x);
      t.parent.(x))

  let union t x y =
    let root_x = find t x in
    let root_y = find t y in
    if root_x <> root_y then
      if t.size.(root_x) < t.size.(root_y) then (
        t.parent.(root_x) <- root_y;
        t.size.(root_y) <- t.size.(root_y) + t.size.(root_x))
      else (
        t.parent.(root_y) <- root_x;
        t.size.(root_x) <- t.size.(root_x) + t.size.(root_y))
end

let data = In_channel.with_open_text "input.txt" In_channel.input_all

let p_line line =
  line |> String.split_on_char ',' |> List.map int_of_string |> function
  | [ x; y; z ] -> (x, y, z)
  | _ -> failwith "invalid data"

let p_data data =
  String.trim data |> String.split_on_char '\n' |> List.map p_line

let sq x = x * x
let dist (a, b, c) (x, y, z) = sq (a - x) + sq (b - y) + sq (c - z)

let pt_product_ids n =
  let rec loop i j acc =
    if i >= n then acc
    else if j >= n then loop (i + 1) (i + 2) acc
    else loop i (j + 1) ((i, j) :: acc)
  in
  loop 0 1 []

let by_dist pts (indices : (int * int) list) =
  let arr =
    Array.of_list indices
    |> Array.map (fun (u, v) -> (u, v, dist pts.(u) pts.(v)))
  in
  Array.fast_sort (fun (_, _, d1) (_, _, d2) -> compare d1 d2) arr;
  arr

module IntMap = Map.Make (Int)

let c_counter n num_pts edges =
  let circuits = UnionFind.create num_pts in
  let add_or_incr acc a =
    IntMap.update a (fun o -> Some ((Option.fold ~none:1 ~some:succ) o)) acc
  in
  let uf =
    Array.to_seq edges |> Seq.take n
    |> Seq.fold_left
         (fun uf (u, v, _) ->
           UnionFind.union uf u v;
           uf)
         circuits
  in
  Seq.ints 0 |> Seq.take num_pts
  |> Seq.map (UnionFind.find uf)
  |> Seq.fold_left add_or_incr IntMap.empty

let mult_three (counter : int IntMap.t) =
  counter |> IntMap.to_list
  |> List.map (fun (k, v) -> v)
  |> List.sort Stdlib.compare |> List.rev
  |> fun l -> match l with a :: b :: c :: _ -> a * b * c | _ -> 0

let _p1 n data_str =
  let d_list = p_data data_str in
  let d_arr = Array.of_list d_list in
  let num_pts = Array.length d_arr in
  pt_product_ids num_pts |> by_dist d_arr |> c_counter n num_pts |> mult_three

let p1 = _p1 1000

let try_connecting (uf, edges) (u, v, _) =
  if UnionFind.find uf u = UnionFind.find uf v then (uf, edges)
  else (
    UnionFind.union uf u v;
    (uf, (u, v) :: edges))

let mult_x_of_last_edges pts (_, edges) =
  let u, v = List.hd edges in
  let x1, _, _ = pts.(u) in
  let x2, _, _ = pts.(v) in
  x1 * x2

let p2 data_str =
  let d_list = p_data data_str in
  let d_arr = Array.of_list d_list in
  let num_pts = Array.length d_arr in
  pt_product_ids num_pts |> by_dist d_arr |> Array.to_seq
  |> Seq.fold_left try_connecting (UnionFind.create num_pts, [])
  |> mult_x_of_last_edges d_arr
