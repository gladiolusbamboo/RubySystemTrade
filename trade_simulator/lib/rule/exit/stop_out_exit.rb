#coding: Windows-31J

require "./lib/base"

# ストップアウトクラス
# 価格がストップにかかったら手仕舞う
# ストップにかかった瞬間、即座に手仕舞う
# 寄り付きでかかったら寄り付きで、
# ザラ場中にかかったらザラ場中に手仕舞う
class StopOutExit < Exit
    def check_long(trade, index)
        # 現在のストップ値を取得する
        stop = trade.stop
        # 現在の株価を取得する
        price = @stock.prices[index]
        # ストップ値より高ければreturn
        return unless stop >= price[:low]

        # 寄り付きでストップ値を下回っていれば寄付き値で寄り付きで手仕舞い
        if stop >= price[:open]
            price = price[:open]
            time = :open
        # 場中なら即座に手仕舞い
        else
            price = stop
            time = :in_session
        end
        exit(trade, index, price, time)
    end

    def check_short(trade, index)
        # 現在のストップ値を取得する
        stop = trade.stop
        # 現在の株価を取得する
        price = @stock.prices[index]
        # ストップ値より安ければreturn
        return unless stop <= price[:high]

        # 寄り付きでストップ値を上回っていれば寄付き値で寄り付きで手仕舞い
        if stop <= price[:open]
            price = price[:open]
            time = :open
        # 場中なら即座に手仕舞い
        else
            price = stop
            time = :in_session
        end
        exit(trade, index, price, time)
    end

    # 指標データは必要ない
    def calculate_indicators
    end
end