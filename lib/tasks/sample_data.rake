namespace :db do
  desc "Fill database with sample data"
  task populate_user: :environment do
    make_user
  end

  task populate_stock_watchlist: :environment do
    make_stock_watchlist
  end

  task populate_stock_prices: :environment do
    update_stock_prices
  end
end

def make_user
  user = User.create!(name:     "Harish Porwal",
                       email:    "harish.porwal@gmail.com",
                       password: "password",
                       password_confirmation: "password")
end

def make_stock_watchlist
  investment_stocks.each {|symbol| StockWatchlist.create!(symbol: symbol, classification: "INVESTMENT", exchange: "NSE", notes: "Good Investment Stock - #{symbol}") }
  trading_stocks.each {|symbol| StockWatchlist.create!(symbol: symbol, classification: "TRADING", exchange: "NSE", notes: "Good Trading Stock - #{symbol}") }
end

def update_stock_prices
  StockWatchlist.update_price(investment_stocks + trading_stocks)
end

private 
  def investment_stocks
    ["BANKBAROD","BANKINDIA","CANBK","CORPBANK","HDFCBANK","ICICIBANK",
      "KOTAKBANK","ORIENTBAN","SBIN"]
  end

  def trading_stocks
    ["MARUTI","MTNL","NATIONALU","ONGC","PNB","RANBAXY","RCOM","RELIANCE"]		
  end
