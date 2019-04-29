class Dieter
    def initialize(weight)
        @weight = weight
    end

    def weight
        @weight + mackerel
    end

    private
    def mackerel
        -2
    end
end

dieter = Dieter.new(91)
puts dieter.weight
dieter.mackerel
