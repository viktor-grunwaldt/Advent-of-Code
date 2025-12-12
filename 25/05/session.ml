let data = In_channel.with_open_text "input.txt" In_channel.input_all;;
let p_line s = String.split_on_char '-' s
  |> List.map int_of_string
;;
let folder (c,a) xs = match xs with 
| l::r::_ -> max c r, (a + max 0 (r+1 - max l (c+1) ))
| _ -> failwith "unreachable"
;;
let p1 data = match Str.split (Str.regexp "\n\n") data with
| ranges::ids::_ ->
  ranges
  |> String.split_on_char '\n'
  |> List.map p_line
  |> List.fold_left folder (0,0)
  |> snd
| _ -> failwith "Invalid data shape"
