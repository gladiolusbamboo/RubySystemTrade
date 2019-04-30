class MyClass
    def initialize(array)
        @array = array
    end

    def each
        @array.each {|x| yield x}
    end
end

my_object = MyClass.new([1, 3, 5])
my_object.each do |x|
    puts x
end
