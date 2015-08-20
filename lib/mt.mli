module Currency : sig
  type t = [
    | `XBT
    | `LTC
    | `EUR
    | `USD
  ] [@@deriving show, enum, eq, ord]

  val of_string : string -> t option
  val to_string : t -> string
end

module Timestamp :
  sig
    class ['ts] t : 'ts -> object method ts : 'ts end
    val compare : < ts : 'a; .. > -> < ts : 'a; .. > -> int
  end
module Direction :
  sig
    type dir = [ `Ask | `Bid | `Unset ]
    val pp_dir : Format.formatter -> dir -> unit
    val show_dir : dir -> String.t
    val min_dir : int
    val max_dir : int
    val dir_to_enum : [< `Ask | `Bid | `Unset ] -> int
    val dir_of_enum : int -> [> `Ask | `Bid | `Unset ] option
    val dir_of_enum_exn : int -> [> `Ask | `Bid | `Unset ]
    class t : dir -> object method d : dir end
    val compare : < d : 'a; .. > -> < d : 'a; .. > -> int
  end
module Tick :
  sig
    module T :
      sig
        class ['p] t : p:'p -> v:'p -> object method p : 'p method v : 'p end
        val compare : < p : 'a; .. > -> < p : 'a; .. > -> int
        val show : < p : int64; v : int64; .. > -> string
        val pp : Format.formatter -> < p : int64; v : int64; .. > -> unit
      end
    module TD :
      sig
        class ['p] t :
          p:'p ->
          v:'p ->
          d:Direction.dir ->
          object method d : Direction.dir method p : 'p method v : 'p end
        val compare : < p : 'a; .. > -> < p : 'a; .. > -> int
      end
    module TTS :
      sig
        class ['p, 'ts] t :
          ts:'ts ->
          p:'p ->
          v:'p -> object method p : 'p method ts : 'ts method v : 'p end
        val compare : < p : 'a; .. > -> < p : 'a; .. > -> int
      end
    module TDTS :
      sig
        class ['p, 'ts] t :
          ts:'ts ->
          p:'p ->
          v:'p ->
          d:Direction.dir ->
          object
            method d : Direction.dir
            method p : 'p
            method ts : 'ts
            method v : 'p
          end
        val compare : < p : 'a; .. > -> < p : 'a; .. > -> int
        val show :
          < d : Direction.dir; p : int64; ts : int64; v : int64; .. > ->
          string
        val pp :
          Format.formatter ->
          < d : Direction.dir; p : int64; ts : int64; v : int64; .. > -> unit
      end
  end
module Ticker :
  sig
    module T :
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
      end
    module Tvwap :
      sig
        class ['ts, 'p] t :
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
  end

module Balance : sig
  class ['a] t :
    currency:Currency.t ->
    amount:'a ->
    available:'a ->
    object
      method currency : Currency.t
      method amount : 'a
      method available : 'a
    end
end
