require 'yahoofinance'

module StockQuoteHelper
  #process the symbols, which is an array containing the symbol and the exchange
  def self.get_price(symbols)
    exchange_symbols = symbols.collect {|symbol| denormalize_symbol(symbol[0], symbol[1])}
    YahooFinance.get_quotes(YahooFinance::StandardQuote, exchange_symbols)    
  end

  def self.normalize_symbol(symbol)
    symbol.chomp(".NS").chomp(".BO")
  end

  def self.denormalize_symbol(symbol, exchange)
    exchange == "NSE" ? "#{symbol}.NS" : "#{symbol}.BO"
  end
end
