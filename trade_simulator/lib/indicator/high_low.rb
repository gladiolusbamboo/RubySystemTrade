# coding: Windows-31J

require "./lib/base"

# 区間の高値安値クラス
# 4本値それぞれの高値・安値に対応
class HighLow < Indicator
    def initialize(stock, params)
        @stock = stock
        # n日間高値安値
        @span = params[:span]
        # 高値か安値か
        @high_low = params[:high_low]
        # 始値・高値・安値・終値のどれを基準にするか
        @price_at = params[:price_at] || params[:high_low]
    end

    def calculate_indicator
        # 価格の配列を取得する
        prices = @stock.map_prices(@price_at)
        # prices.highs(@span)みたいに呼び出す
        prices.send(@high_low.to_s + "s", @span)
    end
end
