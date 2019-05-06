def my_method(&block)
    block.call
end

my_method{puts "やあ！"}
my_method do puts "おい" end

def my_each(array, &block)
    array.each(&block)
end

my_each([1,3,5]) do |a|
    puts a + 5
end

def your_each(array)
    yield array
end

your_each([1,3,5]) do |a|
    puts a
end
