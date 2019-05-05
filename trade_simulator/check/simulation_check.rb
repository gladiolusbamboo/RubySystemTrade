# coding: Windows-31J

require "./lib/simulation"
require "./lib/trading_system"
require "./lib/base"
require "./lib/text_to_stock"
require "./lib/recorder"

# 株データオブジェクトを生成する
text_to_stock = TextToStock.new(stock_list: "tosho_list.txt")
# トレードシステムを作成する
estrangement_system = TradingSystem.new ({
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

# トレードを記録するオブジェクト
recorder = Recorder.new
recorder.record_dir = "result/estrangement/test_simulation"

simulation = Simulation.new(trading_system: estrangement_system,
                            data_loader: text_to_stock,
                            recorder: recorder)

recorder.create_record_folder

# simulation.simulate_a_stock(8604)

simulation.simulate_all_stocks