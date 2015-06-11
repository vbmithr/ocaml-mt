module Timestamp :
  sig
    class ['ts] t : 'ts -> object method ts : 'ts end
    class ['ts] tns :
      'ts -> 'ts -> object method ns : 'ts method ts : 'ts end
  end

module Direction :
  sig
    type t = [ `Ask | `Bid | `Unset ]
    val pp : Format.formatter -> [< `Ask | `Bid | `Unset ] -> unit
    val show : [< `Ask | `Bid | `Unset ] -> string
    val min : int
    val max : int
    val to_enum : [< `Ask | `Bid | `Unset ] -> int
    val of_enum : int -> [> `Ask | `Bid | `Unset ] option
    val of_enum_exn : int -> [> `Ask | `Bid | `Unset ]
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
      < d : [< `Ask | `Bid | `Unset ]; p : int64;
        ts : (int64 -> int64 -> int64) -> int64 -> int64; v : int64; .. > ->
      string
    val pp_tdts :
      Format.formatter ->
      < d : [< `Ask | `Bid | `Unset ]; p : int64;
        ts : (int64 -> int64 -> int64) -> int64 -> int64; v : int64; .. > ->
      unit
    val show_tdtsns :
      < d : [< `Ask | `Bid | `Unset ]; ns : int64; p : int64; ts : int64;
        v : int64; .. > ->
      string
    val pp_tdtsns :
      Format.formatter ->
      < d : [< `Ask | `Bid | `Unset ]; ns : int64; p : int64; ts : int64;
        v : int64; .. > ->
      unit
    val int64_of_v_d : int64 -> [< `Ask | `Bid | `Unset ] -> int64
    val v_d_of_int64 : int64 -> int64 * [> `Ask | `Bid | `Unset ]
    module type IO =
      sig
        type t
        val length : t -> int
        val get_int64 : t -> int -> int64
        val set_int64 : t -> int -> int64 -> unit
      end
    module TickIO :
      functor (IO : IO) ->
        sig
          val write_dtsns :
            IO.t ->
            int ->
            < d : [< `Ask | `Bid | `Unset ]; ns : int64; p : int64;
              ts : int64; v : int64; .. > ->
            unit
          val read_dtsns : IO.t -> int -> (int64, int64) tdtsns
          val write_dts :
            IO.t ->
            int ->
            < d : [< `Ask | `Bid | `Unset ]; p : int64; ts : int64;
              v : int64; .. > ->
            unit
          val read_dts : IO.t -> int -> (int64, int64) tdts
        end

    module TickBytes :
      sig
        val write_dtsns :
          Bytes.t ->
          int ->
          < d : [< `Ask | `Bid | `Unset ]; ns : int64; p : int64; ts : 
            int64; v : int64; .. > ->
          unit
        val read_dtsns : Bytes.t -> int -> (int64, int64) tdtsns
        val write_dts :
          Bytes.t ->
          int ->
          < d : [< `Ask | `Bid | `Unset ]; p : int64; ts : int64; v : 
            int64; .. > ->
          unit
        val read_dts : Bytes.t -> int -> (int64, int64) tdts
      end
    module TickBigstring :
      sig
        val write_dtsns :
          CCBigstring.t ->
          int ->
          < d : [< `Ask | `Bid | `Unset ]; ns : int64; p : int64; ts : 
            int64; v : int64; .. > ->
          unit
        val read_dtsns : CCBigstring.t -> int -> (int64, int64) tdtsns
        val write_dts :
          CCBigstring.t ->
          int ->
          < d : [< `Ask | `Bid | `Unset ]; p : int64; ts : int64; v : 
            int64; .. > ->
          unit
        val read_dts : CCBigstring.t -> int -> (int64, int64) tdts
      end
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
    type 'a t = { bids : 'a list; asks : 'a list; }
    val pp :
      (Format.formatter -> 'a -> 'b) -> Format.formatter -> 'a t -> unit
    val show : (Format.formatter -> 'a -> 'b) -> 'a t -> string
    val create : ?bids:'a list -> ?asks:'a list -> unit -> 'a t
  end
