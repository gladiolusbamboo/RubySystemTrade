# coding: Windows-31J

require "./lib/array"

p "���̔z��"
p array = [100, 97, 111, 115, 116, 123, 121, 119, 115, 110]

puts array.sum
puts array.average

p "�S���ړ�����"
p array.moving_average(4)
p "�R�����l"
p array.highs(3)
p "�R�����l"
p array.lows(3)

# 3��ԍ��l�ƈ��l�̒���
middle = array.map_indicator(3) do |vals|
    (vals.max + vals.min) / 2.0
end

p "3��ԍ��l�ƈ��l�̒���"
p middle

# �O���Ƃ̑���
changes = array.map_indicator(2) do |vals|
    vals.last - vals.first
end
p "�O���Ƃ̑���"
p changes

# 3��Ԃ̑����̕���
average_changes = changes.moving_average(3)
p "3��Ԃ̑����̕���"
p average_changes

# �w���ړ�����
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
p "4���w���ړ�����"
p ema_array
