# coding: Windows-31J

class Array
    def average
        sum.to_f / self.size
    end

    # 元の配列と同じ要素数の配列を返す
    # 配列の各要素を span 個ずつ取り出した配列に対して、順番に
    # ブロックで実装された処理を実行する
    # 呼び出し方：array.map_indicator(span){|span_array|...}
    def map_indicator(span)
        indicator_array = Array.new(self.size)
        self.each_cons(span).with_index do |span_array, index|
            next if span_array.include?(nil)
            indicator_array[index + span - 1] = yield span_array
        end
        indicator_array
    end

    # 移動平均
    def moving_average(span)
        map_indicator(span) do |vals|
            vals.average
        end
    end

    # 区間高値
    def highs(span)
        map_indicator(span){|vals|vals.max}
    end

    # 区間安値
    def lows(span)
        map_indicator(span){|vals|vals.min}
    end
end
