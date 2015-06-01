module Int64 = struct
  include Int64
  let ( + ) = add
  let ( - ) = sub
end

class ['ts] timestamp ts =
  object
    method ts : 'ts = ts
  end

class ['ts] timestamp_ns ts ns =
  object
    inherit ['ts] timestamp ts
    method ns : 'ts = ns
  end

type d = [`Unset | `Bid | `Ask] [@@deriving show,enum]
let d_of_enum_exn d = match d_of_enum d with
  | Some d -> d
  | None -> invalid_arg "d_of_enum"

class direction d =
  object
    method d : d = d
  end

class ['p] tick ~p ~v =
  object
    method p : 'p = p
    method v : 'p = v
  end

class ['p] tick_with_direction ~p ~v ~d =
  object
    inherit direction d
    inherit ['p] tick p v
  end

class ['p, 'ts] tick_with_timestamp ~ts ~p ~v =
  object
    inherit ['ts] timestamp ts
    inherit ['p] tick p v
  end

class ['p, 'ts] tick_with_direction_ts ~ts ~p ~v ~d =
  object
    inherit direction d
    inherit ['ts] timestamp ts
    inherit ['p] tick p v
  end

class ['p, 'ts] tick_with_d_ts_ns ~ts ~ns ~p ~v ~d =
  object
    inherit direction d
    inherit ['ts] timestamp_ns ts ns
    inherit ['p] tick p v
  end

let show_tick_with_d_ts_ns o =
  d_of_enum @@ Int64.(shift_right o#v 63 |> to_int) |> function
  | None -> assert false
  | Some d ->
    Format.sprintf "< ts = %Ld, ns = %Ld, p = %Ld, v = %Ld, d = %s >"
      o#ts o#ns o#p o#v (show_d d)

let pp_tick_with_d_ts_ns fmt o =
  d_of_enum @@ Int64.(shift_right o#v 63 |> to_int) |> function
  | None -> assert false
  | Some d ->
    Format.fprintf fmt "< ts = %Ld, ns = %Ld, p = %Ld, v = %Ld, d = %a >"
      o#ts o#ns o#p o#v pp_d d

let tick_with_d_ts_ns_to_bytes b off o =
  let open EndianBytes.LittleEndian in
  set_int64 b off o#ts;
  set_int64 b (off+8) o#ns;
  set_int64 b (off+16) o#p;
  let v =
    Int64.(logor
             (logand o#v (shift_left 1L 62 - 1L))
             (shift_left (of_int (d_to_enum o#d)) 62)
          ) in
  set_int64 b (off+24) v

let tick_with_d_ts_ns_of_bytes b off =
  let open EndianBytes.LittleEndian in
  if Bytes.length b <> 32 then None
  else
    let ts = get_int64 b off in
    let ns = get_int64 b (off+8) in
    let p = get_int64 b (off+16) in
    let v = get_int64 b (off+24) in
    let d = Int64.(shift_right v 62 |> to_int |> d_of_enum_exn) in
    let v = Int64.(logand v (shift_left 1L 62 - 1L)) in
    Some (new tick_with_d_ts_ns ts ns p v d)

class ['ts, 'p] ticker ~last ~bid ~ask ~high ~low ~volume ~ts =
  object
    method last : 'p = last
    method bid : 'p = bid
    method ask : 'p = ask
    method high : 'p = high
    method low : 'p = low
    method volume : 'p = volume
    method timestamp : 'ts = ts
  end

class ['ts, 'p] ticker_with_vwap ~vwap ~last ~bid ~ask ~high ~low ~volume ~ts =
  object
    inherit ['ts, 'p] ticker ~last ~bid ~ask ~high ~low ~volume ~ts
    method vwap : 'p = vwap
  end

type 'a orderbook = {
  bids: 'a list;
  asks: 'a list;
} [@@deriving show,create]
