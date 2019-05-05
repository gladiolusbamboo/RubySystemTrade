# coding: Windows-31J

require "./lib/trading_system"
require "./lib/recorder"
require "pp"

class Simulation
    def initialize(params = {})
        @trading_system = params[:trading_system]
        @data_loader = params[:data_loader]
        @recorder = params[:recorder]
        @from = params[:from]
        @to = params[:to]
        @record_every_stock = 
            if params[:record_every_stock] == false
                false
            else
                true
            end
    end

    # 1銘柄のシミュレーションを行う
    def simulate_a_stock(code)
        # 日付範囲を指定
        set_dates_to_data_loader
        # 株価データを取得する
        stock = @data_loader.generate_stock(code)
        # シミュレーション
        simulate(stock)
        # 結果を出力する
        @recorder.record_a_stock(@trades) unless @trades.empty?
    end

    # すべての銘柄のシミュレーションを行う
    def simulate_all_stocks
        results = []
        set_dates_to_data_loader
        @data_loader.each_stock do |stock|
            simulate(stock)
            puts stock.code
            next if @trades.empty?
            if @record_every_stock
                @recorder.record_a_stock(@trades)
            end
            results << @trades
        end
        @recorder.record_stats_for_each_stock(results)
        @recorder.record_stats(results)
    end

    private
    def set_dates_to_data_loader
        @data_loader.from = @from
        @data_loader.to = @to
    end

    def simulate(stock)
        @trading_system.set_stock(stock)
        @trading_system.calculate_indicators
        @trades = []
        @position = nil
        @unit = stock.unit
        # 日付分繰り返す
        stock.prices.size.times do |index|
            @index = index
            # 寄り付き前のシミュレート
            before_open
            # 寄り付き時のシミュレート
            at_open
            # ザラ場中のシミュレート
            in_session
            # 大引けのシミュレート
            at_close
        end
    end

    # 寄り付き前のシミュレート（初期化）
    def before_open
        # シグナルをけす
        @signal = nil
        # ポジションを持っていなければ終わり
        return unless @position
        # 手仕舞いデータが残っていれば消す
        @position.exit_date = nil
        @position.exit_price = nil
        # ストップ値を更新する
        @trading_system.set_stop(@position, @index)
        # 日付を１日分進める
        @position.length += 1
    end

    # 寄り付き時のシミュレート
    def at_open
        # 仕掛けをチェックする
        take_position(:open)
        # 手仕舞いをチェックする
        close_position(:open)
    end

    def in_session
        take_position(:in_session)
        close_position(:in_session)
    end

    def at_close
        take_position(:close)
        close_position(:close)
    end

    # 仕掛けをチェックする
    def take_position(entry_time)
        # ポジションをすでに持っていればおわり
        return if @position
        # シグナルが出ているかチェックする
        # @signalはtrade型
        @signal ||= @trading_system.check_entry(@index)
        # シグナルがなければ終わり
        return unless @signal
        # シグナルのタイミングが一致すれば
        # トレードデータを@positionに入れる
        if @signal.entry_time == entry_time
            @position = @signal
            @position.volume = @unit
            @signal = nil
        end
    end

    # 手仕舞いをチェックする
    def close_position(exit_time)
        # ポジションを持っていなければ終わり
        return unless @position
        # ポジションが終了していなければ手仕舞いをチェックする
        unless @position.closed?
            @trading_system.check_exit(@position, @index)
        end
        # 手仕舞いがなければ終了
        return unless @position.closed?
        # シグナルのタイミングが一致すれば
        # ポジションをtradesに記録して手仕舞いをする
        if @position.exit_time = exit_time
            @trades << @position
            @position = nil
        end
    end
end