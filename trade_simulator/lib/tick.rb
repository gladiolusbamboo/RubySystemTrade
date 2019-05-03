# coding: Windows-31J

# 呼値モジュール
# 呼値単位に合わせて値段を上下させたり丸めたりする
module Tick
    module_function
    # 呼値単位
    def size(price)
        if price <= 3000
            1
        elsif 3000 < price && price <= 5000
            5
        elsif 5000 < price && price <= 30000
            10
        elsif 30000 < price && price <= 50000
            50
        elsif 50000 < price && price <= 300000
            100
        elsif 300000 < price && price <= 500000
            500
        elsif 500000 < price && price <= 3000000
            1000
        elsif 3000000 < price && price <= 5000000
            5000
        elsif 5000000 < price && price <= 30000000
            10000
        elsif 30000000 < price && price <= 50000000
            50000
        elsif 50000000 < price
            100000
        end            
    end

    # 呼値単位に切り上げ
    def ceil(price)
        tick_size = size(price)
        if price % tick_size == 0
            price
        else
            truncate(price) + tick_size
        end
    end

    # 呼値単位に切り下げ
    def truncate(price)
        # 最後のtruncateは小数点以下を切り捨てるRuby標準メソッド
        (price - price % size(price)).truncate
    end

    # 呼値単位で近い方に丸め
    def round(price)
        tick_size = size(price)
        if price % tick_size * 2 >= tick_size
            ceil(price)
        else
            truncate(price)
        end
    end

    # 何ティックか足す
    def up(price, tick = 1)
        tick.times { price += size(price)}
        ceil(price)
    end

    # 何ティックか引く
    def down(price, tick = 1)
        price = truncate(price)
        tick.times { price -= size(price)}
        price
    end
end
