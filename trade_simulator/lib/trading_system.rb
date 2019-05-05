# coding: Windows-31J

# トレーディングシステムの各ルールの管理をするクラス
class TradingSystem
    def initialize(rules = {})
        # 各ルールを設定する
        # flatten => 多重配列を普通の配列にする
        # compact => 配列からnilを取り除く
        @entries = [rules[:entries]].flatten.compact
        @exits = [rules[:exits]].flatten.compact
        @stops = [rules[:stops]].flatten.compact
        @filters = [rules[:filters]].flatten.compact
    end

    # すべての"Rule"に株価データをセットする
    def set_stock(stock)
        each_rules{|rule| rule.stock = stock}
    end

    # すべての"Rule"に指標データをセットする
    def calculate_indicators
        each_rules {|rule| rule.calculate_indicators}
    end

    # フィルターを適用して仕掛けをチェックする
    def check_entry(index)
        # フィルターを突破するtradeを取得して成立させる
        trade = entry_through_filter(index)
        # tradeが成立してなければ終了
        return unless trade
        # 最初のストップラインを設定する
        trade_with_first_stop(trade, index)
    end

    # ストップ値を更新する
    def set_stop(position, index)
        position.stop = tightest_stop(position, index)
    end

    # Exitルールにひっかかってないかチェックする
    def check_exit(trade ,index)
        @exits.each do |exit_rule|
            # exit_filterは手仕舞いを制限するフィルター
            exit_filter = exit_rule.check_exit(trade, index)
            return if exit_filter == :no_exit
            # Exitしたら終了
            return if trade.closed?
        end
    end

    private
    # すべての"Rule"に対して同じ処理を行うイテレータ
    def each_rules
        [@entries, @exits, @stops, @filters].flatten.each do |rule|
            yield rule
        end
    end

    # フィルターを突破するtradeを取得する
    def entry_through_filter(index)
        # フィルターをかけて結果をチェックする
        case filter_signal(index)
        # 買いも売りもできない時はnilを返す
        when :no_entry
            nil
        # 買いも売りもできる時は両方チェック
        when :long_and_short
            check_long_entry(index) || check_short_entry(index)
        # 買いチェック
        when :long_only
            check_long_entry(index)
        # 売りチェック
        when :short_only
            check_short_entry(index)
        end
    end

    # すべてのフィルターをチェックして、
    # 仕掛けられる条件を絞る
    def filter_signal(index)
        filters = @filters.map{|filter| filter.get_filter(index)}
        return :no_entry if filters.include?(nil)
        return :no_entry if filters.include?(:no_entry)
        return :no_entry if filters.include?(:long_only) && filters.include?(:short_only)
        return :long_only if filters.include?(:long_only)
        return :short_only if filters.include?(:short_only)
        return :long_and_short
    end

    # 各仕掛けルールを順にチェックし、
    # 最初に買い仕掛けが生じた時点で新規買いトレードを返す
    # 仕掛けがなければnilを返す
    def check_long_entry(index)
        check_entry_rule(:long, index)
    end

    # 各仕掛けルールを順にチェックし、
    # 最初に売り仕掛けが生じた時点で新規売りトレードを返す
    # 仕掛けがなければnilを返す
    def check_short_entry(index)
        check_entry_rule(:short, index)
    end

    def check_entry_rule(long_short, index)
        @entries.each do |entry|
            # Entryクラス（基底クラスのほう）のcheck_long_entry、もしくはcheck_short_entryメソッドを呼び出す
            trade = entry.send("check_#{long_short}_entry", index)
            # 最初の仕掛けが生じた時点でその取引を成立させて返す
            return trade if trade
        end
        nil
    end

    # 最もきついストップの値段を求める
    def tightest_stop(position, index)
        # 現在のストップとストップルールから求める新しいストップからなる配列
        stops = [position.stop] + @stops.map {|stop| stop.get_stop(position, index)}
        # nil排除
        stops.compact!
        # もっとも厳しいストップ値を採用
        if position.long?
            stops.max
        elsif position.short?
            stops.min
        end
    end

    # 最初のストップラインを設定する
    def trade_with_first_stop(trade, index)
        # ストップラインを設定していなければそのまま返す
        return trade if @stops.empty?
        # もっとも厳しいストップラインを取得する
        stop = tightest_stop(trade, index)
        # まだひとつもストップがなければ仕掛けない
        return unless stop
        # トレードにストップラインを設定して返す
        trade.first_stop = stop
        trade.stop = stop
        trade
    end
end
