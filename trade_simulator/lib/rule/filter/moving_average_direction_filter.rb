# coding: Windows-31J

require "./lib/base"

# 移動平均の方向フィルタークラス
# 前日の移動平均が上昇中の時は買いからのみ入る
# 前日の移動平均が下降中の時は売りからのみ入る
# 前日の移動平均が横ばいの時は仕掛けない
class MovingAverageDirectionFilter < Filter    
    def initialize(params)
        @span = params[:span]
    end

    # 指標データとして移動平均の方向を採用する
    def calculate_indicators
        @moving_average_direction = MovingAverageDirection.new(@stock, span: @span).calculate
    end

    def filter(index)
        case @moving_average_direction[index - 1]
        when :up
            :long_only
        when :down
            :short_only
        when :flat
            :no_entry
        end
    end
end
