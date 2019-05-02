# coding: Windows-31J

require "./lib/indicator/indicator"

class MyIndicator < Indicator
    def calculate_indicator
        [nil, nil, 3, 5, 8, 4]
    end
end

my_indicator = MyIndicator.new(nil).calculate
p my_indicator

my_indicator.each do |ind|
    p ind
end

puts my_indicator.first
puts my_indicator[2]
puts my_indicator[3]

catch(:no_value) do
    puts my_indicator[0]
end

(0..5).each do |i|
    catch(:no_value) do
        puts my_indicator[i]
    end
end

p my_indicator[0..2]
p my_indicator[2..4]
