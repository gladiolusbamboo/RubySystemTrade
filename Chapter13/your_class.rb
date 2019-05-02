class YoutClass
    include Enumerable

    def initialize(values)
        @values = values
    end

    def each
        @values.each{|values| yield values}
    end
end

yc = YoutClass.new([100,200,300])
puts yc.count
puts yc.map{|v| v * 2}
puts yc.find_all{|v| v > 150}
