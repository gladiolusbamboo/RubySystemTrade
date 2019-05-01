span = 5

[1,2,3,4,5,6,7,8,9,10].each_cons(span) do |arr| 
    puts arr.inject(:+) / span.to_f
end


