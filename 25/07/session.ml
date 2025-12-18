let data = In_channel.with_open_text "input.txt" In_channel.input_all;;
let seq_list_to_array_array xs =
  Array.of_list (List.map Array.of_seq xs)
;;
let p_data data = data
  |> String.trim
  |> String.split_on_char '\n'
  |> List.map String.to_seq
  |> seq_list_to_array_array;;
let d = p_data data;;

module IntPairs =
struct
  type t = int * int
  let compare = Stdlib.compare
end
;;
module PairsSet = Set.Make (IntPairs);;
module PairsMap = Map.Make (IntPairs);;
module State = struct
  type ('s, 'a) t = 's -> 'a * 's
  let return x s = (x, s)
  let bind m f s =
    let (v, s') = m s in
    f v s'
  let get s = (s, s)
  let put s _ = ((), s)
  let ( let* ) = bind
end

let walk_the_lab leaf fold make_node (g : char array array) =
  let h = Array.length g in
  let w = Array.length g.(0) in
  let open State in

  let cached (key : IntPairs.t) compute =
    let* cache = get in
    match PairsMap.find_opt key cache with
    | Some res -> return res
    | None ->
        let* res = compute () in
        let* current_cache = get in
        let* () = put (PairsMap.add key res current_cache) in
        return res
  in
  let rec f x y =
    if y >= h || y < 0 || x < 0 || x >= w then return leaf
    else
      cached (x,y) (fun () ->
        if g.(y).(x) = '^' then
          let* l = f (x - 1) y in
          let* r = f (x + 1) y in
          return @@ fold (make_node x y) (fold l r)
        else f x (y + 1)
      )
  in

  let start_x = Array.find_index ((=) 'S') g.(0) |> Option.get in
  let (final_result, _) = f start_x 0 PairsMap.empty in
  final_result
;;
let uncurry x y = (x,y);;
let blackbird = Fun.compose Fun.compose Fun.compose;;
let p1 data =
  let open PairsSet in data
  |> p_data
  |> walk_the_lab empty union (blackbird singleton uncurry)
  |> to_seq
  |> Seq.length
;;
let p2 data = data |> p_data
  |> walk_the_lab 1 (+) (fun _ _ -> 0)
;;
