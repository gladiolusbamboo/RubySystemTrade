# coding: Windows-31J

require "./lib/base"

class MovingAverageDirection < Indicator
    def initialize(stock, params)
        @stock = stock
        @span = params[:span]
    end

    def calculate_indicator
        @stock.close_prices.map_indicator(@span+1) do |prices|
            if prices.first < prices.last
                :up
            elsif prices.first > prices.last
                :down
            else
                :flat
            end
        end
    end
end
