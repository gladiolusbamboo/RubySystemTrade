require "Date"

class StockDataGetter
    def initialize
        @data_dir = "data"        
    end


    def make_data_csv
        (1000..9999).each do |code|
            data_url = @data_dir+"/origin/"+code.to_s+".csv"
            output_url = @data_dir+"/"+code.to_s+".csv"
            if File.exist?(data_url)
                File.open(output_url, "w") do |file_w|
                    File.open(data_url, "rt:UTF-8") do |file_r|
                        file_r.each_line do |f|                            
                            line = parse(f)
                            if(!line.nil?)
                                 file_w.puts(line)
                            end
                        end
                    end
                end
            end
        end
    end

    private
    def parse(data)
        data.gsub!("\",\"","\",,\"")
        arr = data.split(",,")
        arr = arr.map do |v|
            v.gsub("\"","")
        end
        date = arr[0]
        if !date_valid?(date)
            return nil
        end
        start = arr[1].gsub(",","")
        high = arr[2].gsub(",","")
        low = arr[3].gsub(",","")
        end_price = arr[4].gsub(",","")
        val = arr[6].gsub(",","")
        date+","+start+","+high+","+low+","+end_price+","+val
    end

    def date_valid?(str)
        !! Date.parse(str) rescue false
    end
end
