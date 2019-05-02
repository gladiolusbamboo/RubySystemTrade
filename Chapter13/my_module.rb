module MyModule
    def plus(a,b)
        a + b
    end
end

class MyClass
    include MyModule
end

mc = MyClass.new
puts mc.plus(1,3)