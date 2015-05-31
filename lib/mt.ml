class ['ts] timestamp ts =
  object
    method ts : 'ts = ts
  end

class ['ts] timestamp_ns ts ns =
  object
    inherit ['ts] timestamp ts
    method ns : 'ts = ns
  end

class direction d =
  object
    method d : [`Unset | `Bid | `Ask] = d
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

class ['p, 'ts] tick_with_timestamp ~p ~v ~ts =
  object
    inherit ['ts] timestamp ts
    inherit ['p] tick p v
  end

class ['p, 'ts] tick_with_direction_ts ~p ~v ~d ~ts =
  object
    inherit direction d
    inherit ['ts] timestamp ts
    inherit ['p] tick p v
  end

class ['p, 'ts] tick_with_d_ts_ns ~p ~v ~d ~ts ~ns =
  object
    inherit direction d
    inherit ['ts] timestamp_ns ts ns
    inherit ['p] tick p v
  end

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
