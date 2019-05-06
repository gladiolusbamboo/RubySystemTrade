money = "1000000000円"

def money.talk
    puts "俺は#{self}持っている!!"
end

money.talk

money = "うそです"
# money.talk

money = "1000000000円"
money.talk
