# coding: Windows-31J

require "./lib/base"

# 移動平均クラス
# 始値、高値、安値、終値のどれを使うかを
# :price_atパラメーターで指定する
# 指定がなければ終値
class MovingAverage < Indicator
    def initialize(stock, params)
        @stock = stock
        @span = params[:span]
        @price_at = params[:price_at] || :close
    end

    def calculate_indicator
        # 指定したパラメータの値段の配列を得る
        prices = @stock.send(@price_at.to_s+"_prices")
        # 拡張したArrayクラスのメソッドを呼び出す
        prices.moving_average(@span)
    end
end
