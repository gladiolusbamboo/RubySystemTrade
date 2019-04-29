# coding: Windows-31J

require "./lib/stock_list_loader"

sll = StockListLoader.new("data/tosho_list.txt")

puts sll.stock_info[0]

puts sll.codes[0]
puts sll.codes.last
puts sll.market_sections[0]
puts sll.units[0]

puts sll.market_sections.include?("東１")
sll.filter_by_market_section("東１")
puts sll.market_sections.include?("東２")
# p sll.market_sections
# p sll.market_sections.include?("ＪＱ".encode("utf-8"))
