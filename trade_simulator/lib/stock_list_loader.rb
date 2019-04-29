# coding: Windows-31J

class StockListLoader
    def initialize(stock_list_file)
        unless stock_list_file
            raise "銘柄リストを指定してください"
        end
        @stock_list = File.readlines(stock_list_file, encoding: "utf-8:sjis").map do |line|
            line.split(",")
        end
    end

    def stock_info
        @stock_info ||= @stock_list.map do |data|
            {:code => data[0].to_i, :market_section => data[1], :unit => data[2].to_i}
        end
    end

    def codes
        @codes ||= stock_info.map{|info| info[:code]}
    end

    def market_sections
        @market_sections ||= stock_info.map{|info| info[:market_section]}
    end

    def units
        @units ||= stock_info.map{|info| info[:unit]}
    end

    def filter_by_market_section(*sections)
        return self unless sections[0]
        @stock_info = stock_info.find_all do |info|
            sections.include?(info[:market_section])
        end
        @codes = stock_info.map{|info| info[:code]}
        @market_sections = stock_info.map{|info| info[:market_section]}
        @units = stock_info.map{|info| info[:unit]}
        self
    end
end
