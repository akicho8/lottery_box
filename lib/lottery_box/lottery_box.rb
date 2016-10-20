# -*- coding: utf-8 -*-
#
# 抽選
#
#   ・アタリだけにrateを指定することで設定が楽になる
#   ・rateの合計は 0..1.0 の範囲内でなければならない
#   ・どのように抽選するかはストラテジーだけが知っている
#
# 使い方
#
#   lottery_box = [
#     {robj: "S", rate: 0.01},
#     {robj: "A", rate: 0.1},
#     {robj: "B"},
#   ]
#   LotteryBox.pick(lottery_box)    # => "B"
#

require "active_support/core_ext/class/attribute_accessors"
require "active_support/core_ext/hash/keys"
require "active_support/configurable"
require "bigdecimal"

module LotteryBox
  include ActiveSupport::Configurable
  config.default_strategy = proc { RateStrategy.new }

  def self.pick(*args)
    Base.new(*args).pick
  end

  def self.summary(box)
    require "rain_table"
    Base.new(box).table.collect { |e|
      {"確率(%)" => "%.2f" % e.parcentage, "robj" => e.robj}
    }.to_t
  end

  class Element
    attr_accessor :range, :rate, :robj

    def initialize(range:, rate:, robj:)
      @range = range
      @rate = rate
      @robj = robj
    end

    def to_h
      {:range => range, :rate => rate, :robj => robj}
    end

    def summary
      "%7.2f %%  %s" % [parcentage, robj]
    end

    def parcentage
      rate * 100.0
    end
  end

  class Base
    attr_reader :box

    def initialize(box, strategy: nil)
      @box = box
      @strategy = strategy || LotteryBox.config.default_strategy.call
      table # new した時点で不整合チェックが走る前の仕様に合わせるため読んでいる
    end

    def pick
      return if table.empty?
      if e = @strategy.element_pick(table)
        e.robj
      end
    end

    def table
      @table ||= __table
    end

    private

    def __table
      if @box.empty?
        raise ArgumentError, "引数が空です"
      end
      @box.each { |e| e.assert_valid_keys(:rate, :robj) }
      assert_object_exist
      group = @box.group_by { |e| !!e[:rate] }
      false_group = group[false] || []
      true_group = group[true] || []
      total = true_group.collect { |e| e[:rate] }.reduce(0, :+)
      assert_total(total)
      other_rate = 0
      if false_group.size > 0
        other_rate = (1.0r - total.to_r) / false_group.size.to_r
      end
      last_rate = 0.0r
      table = []
      (true_group + false_group).each do |e|
        rate = (e[:rate] || other_rate).to_r
        range = last_rate ... (last_rate + rate)
        table << Element.new(range: range, rate: rate, robj: e[:robj])
        last_rate += rate
      end
      # BigDecimal で計算して最後に to_f で戻せば 0.9999999999999999999999999999 や 1.000000000000000000000001 が 1.0 になる
      if last_rate >= (1.0r + Float::EPSILON)
        raise "確率の合計値が1.0を越えている : #{last_rate.to_f}"
      end
      if false_group.size > 0 && (last_rate - 1.0r).abs > Float::EPSILON
        raise "はずれ要素があるのにもかかわらず最後が 1.0 になっていない : #{last_rate}"
      end
      # はずれ要素がない場合のみ 1.0 に届かないため補完する
      if last_rate <= (1.0 - Float::EPSILON)
        table << Element.new(range: last_rate...1.0, rate: 1.0r - last_rate, robj: nil)
      end
      table
    end

    def assert_object_exist
      @box.each do |e|
        unless e.has_key?(:robj)
          raise ArgumentError, "nil を返す場合であったとしても robj は必ず指定してください : #{e.inspect} #{@box.inspect}"
        end
      end
    end

    def assert_total(total)
      unless (0..1.0).cover?(total)
        raise ArgumentError, "確率の合計が 0..1.0 の範囲外になっています : #{total} #{@box.inspect}"
      end
    end
  end

  # 確率 (本番用)
  class RateStrategy
    def initialize(randy = Random.new)
      @randy = randy
    end

    def element_pick(table)
      if @randy.respond_to?(:rand)
        r = @randy.rand
      else
        r = @randy
      end
      table.find { |e| e.range.cover?(r) }
    end
  end

  # 順番に要素を返す (開発用)
  class CycleStrategy
    cattr_accessor :index
    @@index ||= 0

    def element_pick(table)
      table[@@index.modulo(table.size)].tap { @@index += 1 }
    end
  end

  # 一様にサンプルする (開発用)
  class SampleStrategy
    def element_pick(table)
      table.sample
    end
  end

  # 指定インデックスの要素を返す(テスト用)
  class OnlyStrategy
    def initialize(index)
      @index = index
    end

    def element_pick(table)
      table[@index]
    end
  end

  # インスタンスにインデックスを保持する版
  class OrderStrategy
    def initialize(index = 0)
      @index = index
    end

    def element_pick(table)
      table[@index.modulo(table.size)].tap { @index += 1 }
    end
  end
end
