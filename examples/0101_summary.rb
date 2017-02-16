# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "../lib"
require "pp"

require "lottery_box"

box = [
  {:robj => "SSR", :rate => 0.01},
  {:robj => Object.new},
]
LotteryBox.pick(box)            # => #<Object:0x007fbb569bf370>
puts LotteryBox.summary(box)
# >> +---------+----------------------------+
# >> | 確率(%) | robj                       |
# >> +---------+----------------------------+
# >> |   99.00 | #<Object:0x007fbb569bf370> |
# >> |    1.00 | SSR                        |
# >> +---------+----------------------------+
