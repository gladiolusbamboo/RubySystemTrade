# coding: Windows-31J

require "./lib/array"

p "元の配列"
p array = [100, 97, 111, 115, 116, 123, 121, 119, 115, 110]

puts array.sum
puts array.average

p "４日移動平均"
p array.moving_average(4)
p "３日高値"
p array.highs(3)
p "３日安値"
p array.lows(3)

# 3区間高値と安値の中間
middle = array.map_indicator(3) do |vals|
    (vals.max + vals.min) / 2.0
end

p "3区間高値と安値の中間"
p middle

# 前日との増減
changes = array.map_indicator(2) do |vals|
    vals.last - vals.first
end
p "前日との増減"
p changes

# 3区間の増減の平均
average_changes = changes.moving_average(3)
p "3区間の増減の平均"
p average_changes

# 指数移動平均
span = 4
alpha = 2.0 / (span + 1)
ema = nil
ema_array = array.map_indicator(span) do |vals|
    unless ema
        ema = vals.average
    else
        ema += alpha * (vals.last - ema)
    end
end
p "4日指数移動平均"
p ema_array
