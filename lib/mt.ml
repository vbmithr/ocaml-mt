module Currency = struct
  type t = [
    | `XBT
    | `LTC
    | `EUR
    | `USD
  ] [@@deriving show, enum, eq, ord]

  let to_string = function
    | `XBT -> "XBT"
    | `LTC -> "LTC"
    | `EUR -> "EUR"
    | `USD -> "USD"

  let of_string s = match String.lowercase s with
    | "xbt" | "`xbt" | "btc" -> Some `XBT
    | "ltc" | "`ltc" -> Some `LTC
    | "eur" | "`eur" -> Some `EUR
    | "usd" | "`usd" -> Some `USD
    | _ -> None
end

module Symbol = struct
  type t = [
    | `XBTUSD
    | `XBTEUR
    | `LTCUSD
    | `LTCEUR
    | `LTCXBT
    | `XBTLTC
  ] [@@deriving show, enum, eq, ord]

  let to_string = function
    | `XBTUSD -> "XBTUSD"
    | `XBTEUR -> "XBTEUR"
    | `LTCUSD -> "LTCUSD"
    | `LTCEUR -> "LTCEUR"
    | `LTCXBT -> "LTCXBT"
    | `XBTLTC -> "XBTLTC"

  let of_string s = String.lowercase s |> function
    | "xbtusd" | "`xbtusd" | "btcusd" -> Some `XBTUSD
    | "ltcusd" | "`ltcusd" -> Some `LTCUSD
    | "xbteur" | "`xbteur" | "btceur" -> Some `XBTEUR
    | "ltceur" | "`ltceur" -> Some `LTCEUR
    | "ltcxbt" | "`ltcxbt" | "ltcbtc" -> Some `LTCXBT
    | "xbtltc" | "`xbtltc" | "btcltc" -> Some `XBTLTC
    | _ -> None

  let descr = function
    | `XBTUSD -> "Bitcoin / US Dollar"
    | `XBTEUR -> "Bitcoin / Euro"
    | `LTCUSD -> "Litecoin / US Dollar"
    | `LTCEUR -> "Litecoin / Euro"
    | `LTCXBT -> "Litecoin / Bitcoin"
    | `XBTLTC -> "Bitcoin / Litecoin"
end

module Order = struct
  type order_type = [
    | `Market
    | `Limit
    | `Stop
    | `Stop_limit
    | `Market_if_touched
  ] [@@deriving show, enum, eq, ord]

  type time_in_force = [
    | `Day
    | `Good_till_canceled
    | `Good_till_date_time
    | `Immediate_or_cancel
    | `All_or_none
    | `Fill_or_kill
  ] [@@deriving show, enum, eq, ord]

  class ['p, 'sym, 'ot, 'tif] t ~symbol ~client_id ~order_type ~direction
      ~price ?price2 ~amount ~time_in_force () =
    object
      method client_id : string = client_id
      method symbol : 'sym = symbol
      method order_type : 'ot = order_type
      method direction : [`Buy | `Sell] = direction
      method price : 'p = price
      method price2 : 'p option = price2
      method amount : 'p = amount
      method time_in_force : 'tif = time_in_force
    end
end

module Timestamp = struct
  class ['ts] t ts =
    object
      method ts : 'ts = ts
    end

  let compare t t' = compare t#ts t'#ts
end

module Direction = struct
  type dir = [`Unset | `Bid | `Ask] [@@deriving show,enum]
  let dir_of_enum_exn d = match dir_of_enum d with
    | Some d -> d
    | None -> invalid_arg "dir_of_enum"

  class t d =
    object
      method d : dir = d
    end

  let compare t t' = compare t#d t'#d
end

module Tick = struct
  module T = struct
    class ['p] t ~p ~v =
      object
        method p : 'p = p
        method v : 'p = v
      end

    let compare t t' = compare t#p t'#p
    let show o = Format.sprintf "< p = %Ld, v = %Ld >"  o#p o#v
    let pp fmt o = Format.fprintf fmt "< p = %Ld, v = %Ld >" o#p o#v
  end

  module TD = struct
    class ['p] t ~p ~v ~d =
      object
        inherit Direction.t d
        inherit ['p] T.t p v
      end

    let compare t t' = compare t#p t'#p
  end

  module TTS = struct
    class ['p, 'ts] t ~ts ~p ~v =
      object
        inherit ['ts] Timestamp.t ts
        inherit ['p] T.t p v
      end

    let compare t t' = compare t#p t'#p
  end

  module TDTS = struct
    class ['p, 'ts] t ~ts ~p ~v ~d =
      object
        inherit Direction.t d
        inherit ['ts] Timestamp.t ts
        inherit ['p] T.t p v
      end

    let compare t t' = compare t#p t'#p
    let show o =
      Format.sprintf "< ts = %Ld, p = %Ld, v = %Ld, d = %s >"
        o#ts o#p o#v (Direction.show_dir o#d)

    let pp fmt o =
      Format.fprintf fmt "< ts = %Ld, p = %Ld, v = %Ld, d = %a >"
        o#ts o#p o#v Direction.pp_dir o#d
  end
end

module Ticker = struct
  module T = struct
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
  end

  module Tvwap = struct
    class ['ts, 'p] t ~vwap ~last ~bid ~ask ~high ~low ~volume ~ts =
      object
        inherit ['ts, 'p] T.t ~last ~bid ~ask ~high ~low ~volume ~ts
        method vwap : 'p = vwap
      end
  end
end

module Balance = struct
  class ['a] t ~currency ~amount ~available =
    object
      method currency : Currency.t = currency
      method amount : 'a = amount
      method available : 'a = available
    end
end
