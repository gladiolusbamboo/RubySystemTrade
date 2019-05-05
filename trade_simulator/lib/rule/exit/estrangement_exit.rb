#coding: Windows-31J

# 移動平均乖離率による手仕舞いクラス
# 前日の終値がn日移動平均からx%以内のとき寄り付きで手仕舞う
class EstrangementExit < Exit
    def check_long(trade, index)
        if @estrangement[index - 1] > (-1) * @rate
            exit(trade, index, @stock.open_prices[index], :open)
        end
    end

    def check_short(trade, index)
        if @estrangement[index - 1] < @rate
            exit(trade, index, @stock.open_prices[index], :open)
        end
    end

    def initialize(params)
        @span = params[:span]
        @rate = params[:rate]
    end

    # 指標データとして移動平均乖離率を採用する
    def calculate_indicators
        # 中身は数字の配列
        @estrangement = Estrangement.new(@stock, span: @span).calculate
    end
end
