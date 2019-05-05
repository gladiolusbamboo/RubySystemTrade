# coding: Windows-31J

require "./lib/base"

# 移動平均乖離率による仕掛けクラス
# 前日の終値がn日移動平均からx%離れたら寄り付きで仕掛ける
class EstrangementEntry < Entry
    def initialize(params)
        @span = params[:span]
        @rate = params[:rate]
    end

    # 指標データとして移動平均乖離率を採用する
    def calculate_indicators
        @estrangement = Estrangement.new(@stock, span:@span).calculate
    end

    # 買いで入れるかどうかをチェックする
    # 入れる場合は成立したTradeを返す
    # 入れない場合はnil
    def check_long(index)
        if @estrangement[index - 1] < (-1) * @rate
            enter_long(index, @stock.open_prices[index], :open)
        end
    end

    # 売りで入れるかどうかをチェックする
    # 入れる場合は成立したTradeを返す
    # 入れない場合はnil
    def check_short(index)
        if @estrangement[index - 1] > @rate
            enter_short(index, @stock.open_prices[index], :open)
        end
    end
end
