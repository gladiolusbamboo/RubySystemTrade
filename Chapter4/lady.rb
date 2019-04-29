class Lady
    attr_reader :name, :age

    def initialize(name, age)
        @name = name
        @age = age
    end
end

my_lady = Lady.new("Hanako", 20)
puts my_lady.name
puts my_lady.age

arr = [1,2,3].map{|n|n+1}
puts arr
