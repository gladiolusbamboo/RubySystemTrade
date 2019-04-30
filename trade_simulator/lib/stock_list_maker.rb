class StockListMaker
    attr_accessor :data_dir, :file_name

    def initialize(market)
        @data_dir = "data"
    end

    def save_stock_list
        File.open(@data_dir+"/"+@file_name, "w") do |file_w|
            File.open(@data_dir+"/origin/stocks_view.csv", "rt:UTF-8") do |file_r|
                file_r.each_line do |f|
                    line = parse(f)
                    if(!line.nil?)
                        file_w.puts(line)
                    end
                end
            end
        end
    end

    private
    def parse(data)
        arr = data.split("\t")
        arr = arr.map do |v|
            v.gsub("\"","")
        end
        code = arr[1]
        if !number?(code)
            return nil
        end
        market = arr[2]
        code+","+market+",100"
    end

    # 文字列が数字だけで構成されていれば true を返す
    def number?(str)
        # 文字列の先頭(\A)から末尾(\z)までが「0」から「9」の文字か
        nil != (str =~ /\A[0-9]+\z/)
    end
end
