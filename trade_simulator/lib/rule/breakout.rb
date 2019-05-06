# coding: Windows-31J

require "./lib/base"

# ブレイクアウトモジュール
module Breakout
    def initialize(params)
        @span = params[:span]        
    end

    # 指標として高値安値を使う
    def calculate_indicators
        # 区間高値
        @highs = HighLow.new(@stock, span: @span, high_low: :high).calculate
        # 区間安値
        @lows = HighLow.new(@stock, span: @span, high_low: :low).calculate
    end

    # 高値ブレイクしたか
    def break_high?(index)
        @stock.high_prices[index] > @highs[index - 1]
    end

    # 安値ブレイクしたか
    def break_low?(index)
        @stock.low_prices[index] < @lows[index - 1]
    end

    # 高値ブレイクしたときの株価と時間を返す
    def price_and_time_for_break_high(index)
        # ある日の始値と区間高値
        open_price = @stock.open_prices[index]
        highest_high = @highs[index - 1]
        # ある日の始値が高値ブレイクしていれば寄り付きの株価と時間を返す
        if open_price > highest_high
            [open_price, :open]
        # ザラ場中に高値ブレイクしていれば1Tick上の株価と時間を返す
        else
            [Tick.up(highest_high), :in_session]
        end
    end

    def price_and_time_for_break_low(index)
        open_price = @stock.open_prices[index]
        lowest_low = @lows[index - 1]
        if open_price < lowest_low
            [open_price, :open]
        else
            [Tick.down(lowest_low), :in_session]
        end
    end
end
