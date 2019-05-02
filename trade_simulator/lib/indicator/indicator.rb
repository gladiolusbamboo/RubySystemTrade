# coding: Windows-31J

require "./lib/array"

# テクニカル指標の親クラス
class Indicator
    include Enumerable

    def initialize(stock)
        @stock = stock
    end

    def each
        @indicator.each {|value| yield value}
    end

    def calculate
        @indicator = calculate_indicator
        self
    end

    # 要素が nil の時は :no_value を throw する
    def [](index)      
        # my_indicator[1..3]みたいにindexに配列っぽいのが入ってることがあることに注意
        if index.kind_of?(Numeric) && (@indicator[index].nil? || index < 0)
            throw :no_value
        else
            @indicator[index]
        end
    end

    def calculate_indicator; end

end