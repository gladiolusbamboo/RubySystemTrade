#coding: Windows-31J

# ブレイクアウト手仕舞いクラス
class BreakoutExit < Exit
    include Breakout

    # 寄り付きでブレイクした場合は始値、
    # ザラ場でブレイクした場合はn日安値の1ティック下で売る
    def check_long(trade, index)
        if break_low?(index)
            exit(trade, index, *price_and_time_for_break_low(index))
            trade
        end
    end

    def check_short(trade, index)
        if break_high?(index)
            exit(trade, index, *price_and_time_for_break_high(index))
        end
    end
end
