class  Trade
    def initialize(params)
        @stock_code = params[:stock_code]
        @trade_type = params[:trade_type]
        @entry_date = params[:entry_date]
        @entry_price = params[:entry_price]
        @volume = params[:volume]
    end

    def exit(params)
        @exit_date = params[:exit_date]
        @exit_price = params[:exit_price]
    end
end

trade = Trade.new(
            stock_code: 8604,
            trade_type: :long,
            entry_date: "2011/08/25",
            entry_price: 312,
            volume: 100
        )

trade.exit(
    exit_price: 322,
    exit_date: "2011/09/01"
)
