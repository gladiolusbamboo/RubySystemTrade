#coding: Windows-31J

require "pp"
require "./lib/stock"
require "./lib/base"
require "./lib/tick"

# Entryから仕掛けクラスを作るテスト
class MyEntry < Entry
    def check_long(index)
        enter_long(index, 100, :close) if index % 2 == 0
    end

    def check_short(index)
        enter_short(index,100, :close) if index % 2 == 1
    end
end

puts '=== ENTRY ==='
stock = Stock.new(1000, :t, 100)

entry = MyEntry.new

entry.stock = stock

# indexが偶数なら買いでインする
pp entry.check_long_entry(0)
# indexが奇数なら買いでインしない
pp entry.check_long_entry(1)

# indexが偶数なら売りでインしない
pp entry.check_short_entry(0)
# indexが奇数なら売りでインする
pp entry.check_short_entry(1)

# Exitから手仕舞いクラスを作るテスト
class MyExit < Exit
    def check_long(trade, index)
        exit(trade, index, 105, :close) if index % 2 == 1
    end

    def check_short(trade, index)        
        exit(trade, index, 95, :close) if index % 2 == 0
    end
end

puts '=== EXIT ==='
my_exit = MyExit.new
my_exit.stock = stock
# 買いでインする
trade1 = entry.check_long_entry(0)
# indexが偶数なら買いを手仕舞わない
my_exit.check_exit(trade1, 0)
puts trade1.entry_price
puts trade1.exit_price
# indexが奇数なら買いを手仕舞い
my_exit.check_exit(trade1, 3)
puts trade1.entry_price
puts trade1.exit_price

# 売りでインする
trade2 = entry.check_short_entry(1)
# indexが奇数なら売りを手仕舞わない
my_exit.check_exit(trade2, 55)
puts trade2.entry_price
puts trade2.exit_price
# indexが奇数なら売りを手仕舞う
my_exit.check_exit(trade2, 2)
puts trade2.entry_price
puts trade2.exit_price

class MyStop < Stop
    def stop_price_long(position, index)
        # 5Tick下に損切りラインを置く
        Tick.down(position.entry_price, 5)
    end
    def stop_price_short(position, index)
        # 5Tick上に損切りラインを置く
        Tick.up(position.entry_price, 5)
    end
end

puts '=== STOP ==='
stop = MyStop.new
# 買いでインする
trade3 = entry.check_long_entry(0)
puts stop.get_stop(trade3, 0)

# 売りでインする
trade4 = entry.check_short_entry(1)
puts stop.get_stop(trade4, 1)

class MyFilter < Filter
    def filter(index)
        case index % 4
        when 0
            :long_only
        when 1
            :short_only
        when 2
            :no_entry
        when 3
            :long_and_short
        end
    end
end

filter = MyFilter.new

puts '=== FILTER ==='
p filter.get_filter(0)
p filter.get_filter(1)
p filter.get_filter(2)
p filter.get_filter(3)
