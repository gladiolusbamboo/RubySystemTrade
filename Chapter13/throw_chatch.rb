
def puts_each_value(values)
    values.each do |value|
        throw :no_value unless value
        puts value
    end
end

def catch_no_value
    catch(:no_value) do
        yield
    end
end

a = [1,2,3,nil,5,6,7]
catch_no_value do
    puts_each_value(a)
end
