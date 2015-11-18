# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "../lib"
require "lottery_box"
require "pp"

box = [
  {robj: nil, rate: 0.009635622414780824},
  {robj: nil},
  {robj: nil},
  {robj: nil, rate: 0.004852311271884386},
  {robj: nil},
  {robj: nil, rate: 0.009312271632461639},
  {robj: nil},
  {robj: nil},
  {robj: nil, rate: 0.008729814031841091},
  {robj: nil},
  {robj: nil, rate: 0.004611081147308705},
  {robj: nil},
  {robj: nil, rate: 0.008776078010746228},
  {robj: nil},
  {robj: nil, rate: 0.006752383259684013},
  {robj: nil},
  {robj: nil, rate: 0.0015998607360991368},
  {robj: nil},
  {robj: nil, rate: 0.009511449376951793},
  {robj: nil},
  {robj: nil, rate: 0.004845510016269032},
  {robj: nil, rate: 0.009646980716507715},
  {robj: nil, rate: 0.0006208948176329632},
  {robj: nil, rate: 0.0009254000431896958},
  {robj: nil},
  {robj: nil, rate: 0.0016466538552785271},
  {robj: nil},
  {robj: nil},
  {robj: nil, rate: 0.00044484617600659584},
  {robj: nil},
  {robj: nil, rate: 0.0056678698830293795},
  {robj: nil},
  {robj: nil},
  {robj: nil},
  {robj: nil},
  {robj: nil, rate: 0.004052713703404115},
  {robj: nil, rate: 0.005280768064473656},
  {robj: nil, rate: 0.00819930220985294},
  {robj: nil},
  {robj: nil, rate: 0.0026512318728856075},
  {robj: nil, rate: 0.00411754078294234},
  {robj: nil},
  {robj: nil, rate: 0.0077192483672368474},
  {robj: nil, rate: 0.00901215845278368},
  {robj: nil, rate: 0.006588382366539072},
  {robj: nil},
  {robj: nil, rate: 0.003868380122877447},
  {robj: nil},
  {robj: nil, rate: 0.0011600613428592232},
  {robj: nil, rate: 0.00989583008392067},
  {robj: nil},
  {robj: nil, rate: 0.00045536414603734366},
  {robj: nil, rate: 0.0017049858609483515},
  {robj: nil, rate: 0.0003481553771529389},
  {robj: nil, rate: 0.00518825152135907},
  {robj: nil, rate: 0.0007807603253367657},
  {robj: nil, rate: 0.008650479842833248},
  {robj: nil},
  {robj: nil, rate: 0.006482470218220566},
  {robj: nil, rate: 0.0001984913515337472},
  {robj: nil},
  {robj: nil, rate: 0.00230181955909315},
  {robj: nil},
  {robj: nil, rate: 0.009706505501442917},
  {robj: nil, rate: 0.006726415151834999},
  {robj: nil, rate: 0.00042634710921122366},
  {robj: nil},
  {robj: nil, rate: 0.002570262235043007},
  {robj: nil, rate: 0.0021059281839349944},
  {robj: nil},
  {robj: nil, rate: 0.001225487254407882},
  {robj: nil, rate: 0.00476210526381844},
  {robj: nil, rate: 0.003159228215879366},
  {robj: nil},
  {robj: nil, rate: 0.0096623837151513},
  {robj: nil, rate: 0.0033150268044045686},
  {robj: nil, rate: 0.0033770355456089187},
  {robj: nil},
  {robj: nil, rate: 6.202327421113152e-05},
  {robj: nil},
  {robj: nil, rate: 0.007181646831446519},
  {robj: nil},
  {robj: nil},
  {robj: nil},
  {robj: nil, rate: 0.009460840525917953},
  {robj: nil},
  {robj: nil},
  {robj: nil, rate: 0.009611476893563634},
  {robj: nil},
  {robj: nil, rate: 0.0024192854765419346},
  {robj: nil, rate: 0.0001816574619426037},
  {robj: nil, rate: 0.005913421795579838},
  {robj: nil},
  {robj: nil},
  {robj: nil},
  {robj: nil, rate: 0.0019942313924557744},
  {robj: nil, rate: 0.0005102465858483596},
  {robj: nil, rate: 0.004329622380046563},
]

group = box.group_by { |e| !!e[:rate] }
g0 = group[false] || []
g1 = group[true] || []
total = g1.collect { |e| e[:rate] }.reduce(0, :+)
other = 0
if g0.size > 0
  other = (1.0r - total.to_r) / g0.size.to_r
end
last_rate = 0.0r
table = []

v = 0.0r
g1.each {|e| v += e[:rate].to_r }
g0.size.times { v += other }
p v.to_f
p (v.to_r - 1.0).abs <= Float::EPSILON
