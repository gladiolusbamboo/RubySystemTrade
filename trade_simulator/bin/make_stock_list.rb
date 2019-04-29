require "./lib/stock_list_maker"

# 東証銘柄の銘柄リストを作る
# 使い方：ruby bin\make_stock_list.rb file_name
# file_nameは省略可。省略すると"tosho_list.txt"になる

slm = StockListMaker.new(:toushou)
slm.file_name = ARGV[0] || "tosho_list.txt"
puts slm.file_name
slm.save_stock_list
