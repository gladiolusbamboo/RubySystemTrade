class Trader
    attr_reader :name, :account

    def set_name(name)
        @name = name
    end

    def set_account(account)
        @account = account
    end
end

tr = Trader.new

tr.instance_eval do
    set_name "ore"
    set_account 1000000
end

puts tr.name
puts tr.account

def generate_trader(&block)
    trader = Trader.new
    trader.instance_eval(&block)
    trader
end

tr = generate_trader do
    set_name "kare"
    set_account 5000000
end

puts tr.name
puts tr.account
