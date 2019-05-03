# coding: Windows-31J

require "./lib/trade"

class Rule
    attr_writer :stock

    private
    def with_valid_indicators
        catch(:no_value){yield}
    end
end
