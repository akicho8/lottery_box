# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "../lib"
require "pp"

require "lottery_box"

box = [
  {:robj => "S", :rate => 0.1},
  {:robj => "R", :rate => 0.2},
  {:robj => "N"},
]
LotteryBox.pick(box)            # => "N"
puts LotteryBox.summary(box)    # => nil
# >> +---------+------+
# >> | 確率(%) | robj |
# >> +---------+------+
# >> |   10.00 | S    |
# >> |   20.00 | R    |
# >> |   70.00 | N    |
# >> +---------+------+
