def method_with_block
    yield
    yield
    yield    
end

method_with_block do puts "今日も大勝利" end

def three
    yield 3
end

three do |x|
    puts x*4
end

def number(n)
    puts yield n
end

number(1) {|x| x * 3}
number(4) {|x| x * 3}
number(5) {|x| (x + 4) ** 2}

def numbers(a,b)
    puts yield a, b
end

numbers(10, 20) {|x,y| x + y}
numbers(10, 20) {|x,y| x - y}
numbers(10, 20) {|x,y| x ** y}

def multiply(a, b)
    c = a * b
    yield c
end

multiply(3,5) do |x|
    puts x
end

multiply(3,5){|x| puts "答えは#{x}です"}
