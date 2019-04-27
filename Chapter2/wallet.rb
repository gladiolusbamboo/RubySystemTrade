class Wallet
    def initialize(money)
        @money = money
    end

    def put_in(money)
        @money += money
    end

    def take_out(money)
        @money -= money
    end

    def money
        @money
    end
end

my_wallet = Wallet.new(1000)
puts my_wallet.money
my_wallet.put_in(5000)
puts my_wallet.money
my_wallet.take_out(3000)
puts my_wallet.money
