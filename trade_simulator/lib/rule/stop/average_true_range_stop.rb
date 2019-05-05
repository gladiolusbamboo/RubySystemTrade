# coding: Windows-31J

require "./lib/base"
require "./lib/tick"

# 真の値幅（前日終値を含めて考慮した値幅）の移動平均に基づくストップクラス
# 仕掛値から
# 買いでは、n日間のATRのx倍、下に
# 売りでは、n日間のATRのx倍、上にストップを置く
class AverageTrueRangeStop < Stop
    def initialize(params)
        @span = params[:span]
        @ratio = params[:ratio] || 1
    end

    # 指標データとしてATRを採用する
    def calculate_indicators
        @average_true_range = AverageTrueRange.new(@stock, span: @span).calculate
    end

    # 仕掛値からn日ATR(前日)のx倍下に言ったところにストップをおく
    def stop_price_long(position, index)
        Tick.truncate(position.entry_price - range(index))
    end

    # 仕掛値からn日ATR(前日)のx倍下に言ったところにストップをおく
    def stop_price_short(position, index)
        Tick.ceil(position.entry_price + range(index))
    end

    private
    def range(index)
        @average_true_range[index - 1] * @ratio
    end
end
