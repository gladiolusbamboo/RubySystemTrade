# coding: Windows-31J

require "./lib/base"
require "./lib/text_to_stock"
require "./lib/trading_system"
require "./lib/recorder"
require "pp"

# 株データオブジェクトを生成する
@data = TextToStock.new(stock_list: "tosho_list.txt")
# @data.from = "2010/01/01"
# @data.to = "2011/09/01"


# トレードシステムを作成する
@trading_system = TradingSystem.new ({
                    # 移動平均乖離率による仕掛け
                    # 20日移動平均から5%離れたら寄り付きで仕掛ける
                    entries: EstrangementEntry.new(span: 20, rate: 5),
                    exits: [
                        # ストップラインによる手仕舞いをする
                        StopOutExit.new,
                        # 移動平均乖離率による手仕舞い
                        # 20日移動平均から3%以内に戻ったら手仕舞いをする
                        EstrangementExit.new(span:20, rate: 3)
                    ],
                    # ATRによるストップ
                    # 仕掛け値から20日ATRのところにストップラインを設定する
                    stops: AverageTrueRangeStop.new(span: 20),
                    # 移動平均の方向によるフィルター
                    # 買いは移動平均が上昇中のときのみ、
                    # 売りは移動平均が下降中のときのみしかける
                    filters: MovingAverageDirectionFilter.new(span: 30)
                  })

# トレードシステムを動かす
def simulate(code)
    # 特定銘柄のデータを取得する
    stock = @data.generate_stock(code)
    # システムに株オブジェクトを登録する
    @trading_system.set_stock(stock)
    # システムの各ルールに指標を登録する
    @trading_system.calculate_indicators
    # 1回ずつのトレード
    trade = nil
    # すべてのトレードを記録する
    trades = []
    # stockに登録されている日付の分だけループ
    stock.prices.size.times do |i|
        # ポジションがある場合
        if trade
            @trading_system.set_stop(trade, i)
            trade.length += 1
        end
        # ポジションがない場合
        unless trade
            # 仕掛けられるかチェックする
            trade = @trading_system.check_entry(i)
            # 最低単元で仕掛ける
            trade.volume = stock.unit if trade
        end
        if trade
            # Exitルールにひっかかってないかチェックする
            @trading_system.check_exit(trade, i)
            # 手仕舞いしたら記録して終了
            if trade.closed?
                trades << trade
                trade = nil
            end
        end
    end
    trades
end

# 記録用スクリプト
recorder = Recorder.new
recorder.record_dir = "result/test"
# 記録用フォルダを作る
recorder.create_record_folder
# __FILE__はこのファイルのこと
recorder.record_setting(__FILE__)

# シミュレーションする
results = [1301,1332,1333,1352,1376,1377,1379,1384,1413,7212,8604].map do |code|
    simulate(code)
end

# １銘柄ずつの結果を出力
results.each do |trades|
    recorder.record_a_stock(trades)
end

# 銘柄ごとの統計データを出力
recorder.record_stats_for_each_stock(results)
# まとめた統計データを出力
recorder.record_stats(results)
