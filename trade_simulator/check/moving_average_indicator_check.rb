# coding: Windows-31J

require "./lib/base"
require "./lib/text_to_stock"

tts = TextToStock.new(
        data_dir: "data",
        stock_list: "tosho_list.txt",
        market_section: "東１"
      )

tts.from = "2012/01/01"
tts.to = "2012/01/31"
stock = tts.generate_stock(1301)

ma = MovingAverage.new(stock,
                       span:2,
                       price_at: :close).calculate

p stock.close_prices
ma.each do |value|
    print value.to_s + " "
end
# ma.each_with_index do |value, i|
#     next unless value
#     puts value
# end
