class ['ts] timestamp : 'ts -> object method ts : 'ts end
class direction :
  [ `Ask | `Bid | `Unset ] -> object method d : [ `Ask | `Bid | `Unset ] end
class ['p] tick : p:'p -> v:'p -> object method p : 'p method v : 'p end
class ['p] tick_with_direction :
  p:'p ->
  v:'p ->
  d:[ `Ask | `Bid | `Unset ] ->
  object method d : [ `Ask | `Bid | `Unset ] method p : 'p method v : 'p end
class ['p, 'ts] tick_with_timestamp :
  p:'p ->
  v:'p -> ts:'ts -> object method p : 'p method ts : 'ts method v : 'p end
class ['p, 'ts] tick_with_direction_ts :
  p:'p ->
  v:'p ->
  d:[ `Ask | `Bid | `Unset ] ->
  ts:'ts ->
  object
    method d : [ `Ask | `Bid | `Unset ]
    method p : 'p
    method ts : 'ts
    method v : 'p
  end
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
