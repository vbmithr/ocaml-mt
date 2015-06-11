module Int64 = struct
  include Int64
  let ( + ) = add
  let ( - ) = sub
end

module Timestamp = struct
  class ['ts] t ts =
    object
      method ts : 'ts = ts
    end

  class ['ts] tns ts ns =
    object
      inherit ['ts] t ts
      method ns : 'ts = ns
    end
end

module Direction = struct
  type t = [`Unset | `Bid | `Ask] [@@deriving show,enum]
  let of_enum_exn d = match of_enum d with
    | Some d -> d
    | None -> invalid_arg "d_of_enum"

  class d d =
    object
      method d : t = d
    end
end

module Tick = struct
  class ['p] t ~p ~v =
    object
      method p : 'p = p
      method v : 'p = v
    end

  class ['p] td ~p ~v ~d =
    object
      inherit Direction.d d
      inherit ['p] t p v
    end

  class ['p, 'ts] tts ~ts ~p ~v =
    object
      inherit ['ts] Timestamp.t ts
      inherit ['p] t p v
    end

  class ['p, 'ts] tdts ~ts ~p ~v ~d =
    object
      inherit Direction.d d
      inherit ['ts] Timestamp.t ts
      inherit ['p] t p v
    end

  class ['p, 'ts] tdtsns ~ts ~ns ~p ~v ~d =
    object
      inherit Direction.d d
      inherit ['ts] Timestamp.tns ts ns
      inherit ['p] t p v
    end

  let show_tdts o =
    let ts = Int64.(o#ts div 1_000_000_000L) in
    let ns = Int64.(o#ts rem 1_000_000_000L) in
    Format.sprintf "< ts = %Ld.%Ld, p = %Ld, v = %Ld, d = %s >"
      ts ns o#p o#v (Direction.show o#d)

  let pp_tdts fmt o =
    let ts = Int64.(o#ts div 1_000_000_000L) in
    let ns = Int64.(o#ts rem 1_000_000_000L) in
    Format.fprintf fmt "< ts = %Ld.%Ld, p = %Ld, v = %Ld, d = %a >"
      ts ns o#p o#v Direction.pp o#d


  let show_tdtsns o =
    Format.sprintf "< ts = %Ld, ns = %Ld, p = %Ld, v = %Ld, d = %s >"
      o#ts o#ns o#p o#v (Direction.show o#d)

  let pp_tdtsns fmt o =
    Format.fprintf fmt "< ts = %Ld, ns = %Ld, p = %Ld, v = %Ld, d = %a >"
      o#ts o#ns o#p o#v Direction.pp o#d

  let int64_of_v_d v d =
    let open Int64 in
    logor
      (logand v (shift_left 1L 62 - 1L))
      (shift_left (of_int (Direction.to_enum d)) 62)

  let v_d_of_int64 i =
    let open Int64 in
    let d = shift_right_logical i 62 |> to_int |> Direction.of_enum_exn in
    let v = logand i (shift_left 1L 62 - 1L) in
    v, d

  module type IO = sig
    type t
    val length : t -> int
    val get_int64 : t -> int -> int64
    val set_int64 : t -> int -> int64 -> unit
  end

  module TickIO (IO: IO) = struct
    open IO
    let write_dtsns b off o =
      set_int64 b off o#ts;
      set_int64 b (off+8) o#ns;
      set_int64 b (off+16) o#p;
      set_int64 b (off+24) @@ int64_of_v_d o#v o#d

    let read_dtsns b off =
      let ts = get_int64 b off in
      let ns = get_int64 b (off+8) in
      let p = get_int64 b (off+16) in
      let v = get_int64 b (off+24) in
      let v, d = v_d_of_int64 v in
      new tdtsns ts ns p v d

    let write_dts b off o =
      set_int64 b off o#ts;
      set_int64 b (off+8) o#p;
      set_int64 b (off+16) @@ int64_of_v_d o#v o#d

    let read_dts b off =
      let ts = get_int64 b off in
      let p = get_int64 b (off+8) in
      let v = get_int64 b (off+16) in
      let v, d = v_d_of_int64 v in
      new tdts ts p v d
  end

  module BytesIO = struct
    include Bytes
    let get_int64 = EndianBytes.BigEndian.get_int64
    let set_int64 = EndianBytes.BigEndian.set_int64
  end

  module BigstringIO = struct
    include CCBigstring
    let get_int64 = EndianBigstring.BigEndian.get_int64
    let set_int64 = EndianBigstring.BigEndian.set_int64
  end

  module Bytes = TickIO(BytesIO)
  module Bigstring = TickIO(BigstringIO)
end

module Ticker = struct
  class ['ts, 'p] t ~last ~bid ~ask ~high ~low ~volume ~ts =
    object
      method last : 'p = last
      method bid : 'p = bid
      method ask : 'p = ask
      method high : 'p = high
      method low : 'p = low
      method volume : 'p = volume
      method timestamp : 'ts = ts
    end

  class ['ts, 'p] tvwap ~vwap ~last ~bid ~ask ~high ~low ~volume ~ts =
    object
      inherit ['ts, 'p] t ~last ~bid ~ask ~high ~low ~volume ~ts
      method vwap : 'p = vwap
    end
end

module OrderBook = struct
  type 'a t = {
    bids: 'a list;
    asks: 'a list;
  } [@@deriving show,create]
end
