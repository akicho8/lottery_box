# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "../lib"
require "pp"

require "lottery_box"

box = [
  {:robj => "SSR", :rate => 0.01},
  {:robj => "SR",  :rate => 0.05},
  {:robj => "R",   :rate => 0.1},
  {:robj => "N1"},
  {:robj => "N2"},
  {:robj => "N3"},
]
LotteryBox.pick(box)            # => "N1"
puts LotteryBox.summary(box)
# >> +---------+------+
# >> | 確率(%) | robj |
# >> +---------+------+
# >> |    1.00 | SSR  |
# >> |    5.00 | SR   |
# >> |   10.00 | R    |
# >> |   28.00 | N1   |
# >> |   28.00 | N2   |
# >> |   28.00 | N3   |
# >> +---------+------+
