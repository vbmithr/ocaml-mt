class ['ts] timestamp : 'ts -> object method ts : 'ts end
class ['ts] timestamp_ns :
  'ts -> 'ts -> object method ns : 'ts method ts : 'ts end
type d = [ `Ask | `Bid | `Unset ]
val pp_d : Format.formatter -> [< `Ask | `Bid | `Unset ] -> unit
val show_d : [< `Ask | `Bid | `Unset ] -> string
val min_d : int
val max_d : int
val d_to_enum : [< `Ask | `Bid | `Unset ] -> int
val d_of_enum : int -> [> `Ask | `Bid | `Unset ] option
val d_of_enum_exn : int -> [> `Ask | `Bid | `Unset ]
class direction : d -> object method d : d end
class ['p] tick : p:'p -> v:'p -> object method p : 'p method v : 'p end
class ['p] tick_with_direction :
  p:'p -> v:'p -> d:d -> object method d : d method p : 'p method v : 'p end
class ['p, 'ts] tick_with_timestamp :
  ts:'ts ->
  p:'p -> v:'p -> object method p : 'p method ts : 'ts method v : 'p end
class ['p, 'ts] tick_with_direction_ts :
  ts:'ts ->
  p:'p ->
  v:'p ->
  d:d -> object method d : d method p : 'p method ts : 'ts method v : 'p end
class ['p, 'ts] tick_with_d_ts_ns :
  ts:'ts ->
  ns:'ts ->
  p:'p ->
  v:'p ->
  d:d ->
  object
    method d : d
    method ns : 'ts
    method p : 'p
    method ts : 'ts
    method v : 'p
  end
val show_tick_with_d_ts_ns :
  < ns : int64; p : int64; ts : int64; v : int64; .. > -> string
val pp_tick_with_d_ts_ns :
  Format.formatter ->
  < ns : int64; p : int64; ts : int64; v : int64; .. > -> unit
val int64_of_v_d : int64 -> [< `Ask | `Bid | `Unset ] -> int64
val v_d_of_int64 : int64 -> int64 * [> `Ask | `Bid | `Unset ]
val tick_with_d_ts_ns_to_bytes :
  Bytes.t ->
  int ->
  < d : [< `Ask | `Bid | `Unset ]; ns : int64; p : int64; ts : int64;
    v : int64; .. > ->
  unit
val tick_with_d_ts_ns_to_bigstring :
  EndianBigstring.bigstring ->
  int ->
  < d : [< `Ask | `Bid | `Unset ]; ns : int64; p : int64; ts : int64;
    v : int64; .. > ->
  unit
val tick_with_d_ts_ns_of_bytes :
  Bytes.t -> int -> (int64, int64) tick_with_d_ts_ns option
val tick_with_d_ts_ns_of_bigstring :
  CCBigstring.t -> int -> (int64, int64) tick_with_d_ts_ns option
class ['ts, 'p] ticker :
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
class ['ts, 'p] ticker_with_vwap :
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
type 'a orderbook = { bids : 'a list; asks : 'a list; }
val pp_orderbook :
  (Format.formatter -> 'a -> 'b) -> Format.formatter -> 'a orderbook -> unit
val show_orderbook : (Format.formatter -> 'a -> 'b) -> 'a orderbook -> string
val create_orderbook : ?bids:'a list -> ?asks:'a list -> unit -> 'a orderbook
