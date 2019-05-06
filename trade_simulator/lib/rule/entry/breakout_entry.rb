# coding: Windows-31J

require "./lib/base"

# ブレイクアウト仕掛けクラス
# n日高値安値のブレイクで仕掛け
class BreakoutEntry < Entry
    include Breakout

    def check_long(index)
        if break_high?(index)
            # *で配列をバラす            
            #trade =
            enter_long(index, *price_and_time_for_break_high(index))            
        end
    end

    def check_short(index)
        if break_low?(index)            
            enter_short(index, *price_and_time_for_break_low(index))
        end
    end
end
