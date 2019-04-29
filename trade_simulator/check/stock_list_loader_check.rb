# coding: Windows-31J

require "./lib/stock_list_loader"

sll = StockListLoader.new("data/tosho_list.txt")

puts sll.stock_info[0]

puts sll.codes[0]
puts sll.codes.last
puts sll.market_sections[0]
puts sll.units[0]

puts sll.market_sections.include?("���P")
sll.filter_by_market_section("���P")
puts sll.market_sections.include?("���Q")
# p sll.market_sections
# p sll.market_sections.include?("�i�p".encode("utf-8"))
