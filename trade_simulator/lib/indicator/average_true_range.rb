# coding: Windows-31J

require "./lib/base"

# 真の値幅の平均クラス
# 真の値幅の移動平均
class AverageTrueRange < Indicator
    def initialize(stock, params)
        @stock = stock
        @span = params[:span]
    end

    def calculate_indicator
        true_ranges = @stock.prices.map_indicator(2) do |prices|
            previous_close = prices.first[:close] # 前日終値
            current_high = prices.last[:high] # 本日高値
            current_low = prices.last[:low] # 本日安値
            true_high = [previous_close, current_high].max # 真の高値
            true_low = [previous_close, current_low].min # 真の安値
            true_high - true_low # 真の値幅
        end
        true_ranges.moving_average(@span)

        # @stock.close_prices.map_indicator(@span+1) do |prices|
        #     if prices.first < prices.last
        #         :up
        #     elsif prices.first > prices.last
        #         :down
        #     else
        #         :flat
        #     end
        # end
    end
end
