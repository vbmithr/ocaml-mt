module Timestamp :
  sig
    class ['ts] t : 'ts -> object method ts : 'ts end
    class ['ts] tns :
      'ts -> 'ts -> object method ns : 'ts method ts : 'ts end
  end

module Direction :
  sig
    type t = [ `Ask | `Bid | `Unset ] [@@deriving show,enum]
    val of_enum_exn : int -> t
    class d : t -> object method d : t end
  end

module Tick :
  sig
    class ['p] t : p:'p -> v:'p -> object method p : 'p method v : 'p end
    class ['p] td :
      p:'p ->
      v:'p ->
      d:Direction.t ->
      object method d : Direction.t method p : 'p method v : 'p end
    class ['p, 'ts] tts :
      ts:'ts ->
      p:'p -> v:'p -> object method p : 'p method ts : 'ts method v : 'p end
    class ['p, 'ts] tdts :
      ts:'ts ->
      p:'p ->
      v:'p ->
      d:Direction.t ->
      object
        method d : Direction.t
        method p : 'p
        method ts : 'ts
        method v : 'p
      end
    class ['p, 'ts] tdtsns :
      ts:'ts ->
      ns:'ts ->
      p:'p ->
      v:'p ->
      d:Direction.t ->
      object
        method d : Direction.t
        method ns : 'ts
        method p : 'p
        method ts : 'ts
        method v : 'p
      end
    val show_tdts :
      < d : Direction.t; p : int64; ts : int64;  v : int64; .. > -> string
    val pp_tdts :
      Format.formatter ->
      < d : Direction.t; p : int64; ts : int64; v : int64; .. > -> unit
    val show_tdtsns :
      < d : Direction.t; ns : int64; p : int64; ts : int64;
        v : int64; .. > ->
      string
    val pp_tdtsns :
      Format.formatter ->
      < d : Direction.t; ns : int64; p : int64; ts : int64;
        v : int64; .. > ->
      unit
  end

module Ticker :
  sig
    class ['ts, 'p] t :
      last:'p ->
      bid:'p ->
      ask:'p ->
      high:'p ->
      low:'p ->
      volume:'p ->
      ts:'ts ->
      object
        method ask : 'p
        method bid : 'p
        method high : 'p
        method last : 'p
        method low : 'p
        method timestamp : 'ts
        method volume : 'p
      end
    class ['ts, 'p] tvwap :
      vwap:'p ->
      last:'p ->
      bid:'p ->
      ask:'p ->
      high:'p ->
      low:'p ->
      volume:'p ->
      ts:'ts ->
      object
        method ask : 'p
        method bid : 'p
        method high : 'p
        method last : 'p
        method low : 'p
        method timestamp : 'ts
        method volume : 'p
        method vwap : 'p
      end
  end
module OrderBook :
  sig
    type 'a t = { bids : 'a list; asks : 'a list; } [@@deriving show,create]
  end
