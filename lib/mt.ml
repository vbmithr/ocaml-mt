module Trade = struct
  class ['ts] timestamp ts =
    object
      method ts : 'ts = ts
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
      inherit ['p] tick ~p ~v
    end

  class ['p, 'ts] tick_with_timestamp ~p ~v ~ts =
    object
      inherit ['ts] timestamp ts
      inherit ['p] tick ~p ~v
    end

  class ['p, 'ts] tick_with_direction_ts ~p ~v ~d ~ts =
    object
      inherit direction d
      inherit ['ts] timestamp ts
      inherit ['p] tick ~p ~v
    end
end
