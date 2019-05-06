#coding: Windows-31J

require "./lib/base"

# MinHoldExitクラス
# ポジション保有日数がｎ日以下の時は手仕舞わない
class MinHoldExit < Exit
    # 最低保有日数を設定する
    def initialize(params)
        @min_hold_days = params[:min_hold_days]
    end

    # 最低保有日数以下なら手仕舞わない
    def check_exit(trade, index)
        return :no_exit if trade.length <= @min_hold_days
    end

    # 指標データは必要ない
    def calculate_indicators
    end    
end
