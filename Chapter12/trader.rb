class Trader
    def win
        puts "勝ったぞ！！"
    end
end

trader = Trader.new

trader.win

class Trader
    def lose
        puts "負けちゃった・・・"
    end
end

trader.win
trader.lose

class Trader
    def win
        puts "わーいわーい"
    end
end

trader.win
trader.lose
