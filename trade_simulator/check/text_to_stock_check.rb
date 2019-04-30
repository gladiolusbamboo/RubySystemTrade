# coding: Windows-31J

require "./lib/text_to_stock"
require "./lib/stock"

tts = TextToStock.new(
        data_dir: "data",
        stock_list: "tosho_list.txt",
        market_section: "東１"
      )

stock = tts.generate_stock(1301)

puts stock.code
puts stock.dates.first
puts stock.open_prices.first

tts.each_stock do |stock|
    puts stock.code
end

tts.from = "2011/01/04"
tts.to = "2011/06/30"

tts.each_stock do |stock|
    puts [stock.code, 
          stock.dates.first,
          stock.dates.last].join(" ")
end
