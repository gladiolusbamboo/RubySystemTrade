class Parent
    def plus(a,b)
        a+b
    end

    def minus(a,b)
        a-b
    end
end

class Child < Parent
end

c = Child.new
puts c.plus(5,8)
puts c.minus(9,6)
