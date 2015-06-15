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
    let ts = Int64.(div o#ts 1_000_000_000L) in
    let ns = Int64.(rem o#ts 1_000_000_000L) in
    Format.sprintf "< ts = %Ld.%Ld, p = %Ld, v = %Ld, d = %s >"
      ts ns o#p o#v (Direction.show o#d)

  let pp_tdts fmt o =
    let ts = Int64.(div o#ts 1_000_000_000L) in
    let ns = Int64.(rem o#ts 1_000_000_000L) in
    Format.fprintf fmt "< ts = %Ld.%Ld, p = %Ld, v = %Ld, d = %a >"
      ts ns o#p o#v Direction.pp o#d


  let show_tdtsns o =
    Format.sprintf "< ts = %Ld, ns = %Ld, p = %Ld, v = %Ld, d = %s >"
      o#ts o#ns o#p o#v (Direction.show o#d)

  let pp_tdtsns fmt o =
    Format.fprintf fmt "< ts = %Ld, ns = %Ld, p = %Ld, v = %Ld, d = %a >"
      o#ts o#ns o#p o#v Direction.pp o#d
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
