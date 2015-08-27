module Currency : sig
  type t = [
    | `XBT
    | `LTC
    | `EUR
    | `USD
  ] [@@deriving show, enum, eq, ord]

  val of_string : string -> t option
  val of_string_exn : string -> t
  val to_string : t -> string
end

module Symbol : sig
  type t = [
    | `XBTUSD
    | `XBTEUR
    | `LTCUSD
    | `LTCEUR
    | `LTCXBT
    | `XBTLTC
  ] [@@deriving show, enum, eq, ord]

  val of_string : string -> t option
  val of_string_exn : string -> t
  val to_string : t -> string
  val descr : t -> string
end

module Order : sig
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

  type order_status =
    [ `Unspecified
    | `Sent
    | `Pending_open
    | `Pending_child
    | `Open
    | `Pending_cancel_replace
    | `Pending_cancel
    | `Filled
    | `Cancelled
    | `Rejected
    ] [@@deriving show, enum, eq, ord]

  type update_reason =
    [ `Unset
    | `Open_orders_request
    | `New_order_accepted
    | `Filled
    | `Partial_fill
    | `Cancelled
    | `Cancel_replace_complete
    | `New_order_reject
    | `Order_cancel_reject
    | `Order_cancel_replace_reject
    ] [@@deriving show, enum, eq, ord]

  class ['p, 'sym, 'ot, 'tif] t :
    symbol:'sym ->
    client_id:string -> order_type:'ot ->
    side:[`Buy | `Sell] ->
    price:'p -> ?price2:'p -> amount:'p ->
    time_in_force:'tif -> unit ->
    object
      method client_id: string
      method symbol: 'sym
      method order_type: 'ot
      method side: [`Buy | `Sell]
      method price: 'p
      method price2: 'p option
      method amount: 'p
      method time_in_force: 'tif
    end

  class ['p, 'sym, 'ex, 'ot, 'tif, 'ts] status :
    ?client_order_id:int -> ?server_order_id:int -> ?exchange_order_id:int ->
    symbol:'sym -> exchange:'ex -> p1:'p -> ?p2:'p ->
    order_qty:'p -> filled_qty:'p -> remaining_qty:'p -> avg_fill_price:'p ->
    side:[`Buy | `Sell] -> order_type:'ot -> time_in_force:'tif -> ts:'ts ->
    status:order_status -> update_reason:update_reason -> unit ->
    object
      method client_order_id: int
      method server_order_id: int
      method exchange_order_id: int
      method symbol : 'sym
      method exchange : 'ex
      method p1 : 'p
      method p2 : 'p option
      method order_qty : 'p
      method filled_qty : 'p
      method remaining_qty : 'p
      method avg_fill_price : 'p
      method side : [`Buy | `Sell]
      method order_type : 'ot
      method time_if_force : 'tif
      method ts : 'ts
      method status : order_status
      method update_reason : update_reason
    end
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
        val show : < d : Direction.dir; p : int64; v : int64; .. > -> string
        val pp :
          Format.formatter ->
          < d : Direction.dir; p : int64; v : int64; .. > -> unit
      end
    module TTS :
      sig
        class ['p, 'ts] t :
          ts:'ts ->
          p:'p ->
          v:'p -> object method p : 'p method ts : 'ts method v : 'p end
        val compare : < p : 'a; .. > -> < p : 'a; .. > -> int
        val show : < p : int64; ts : int64; v : int64; .. > -> string
        val pp :
          Format.formatter ->
          < p : int64; ts : int64; v : int64; .. > -> unit
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
