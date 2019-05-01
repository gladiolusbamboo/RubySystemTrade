puts [2,3,5,7,11].inject(0){|sum,number| sum + number}
puts [2,3,5,7,11].inject(1){|sum,number| sum * number}
puts [2,3,5,7,11].inject{|sum,number| sum + number}
puts [2,3,5,7,11].inject{|sum,number| sum * number}
puts [2,3,5,7,11].inject(:+)
