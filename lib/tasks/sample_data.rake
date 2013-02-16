namespace :db do
  desc "Fill database with sample data"
  task populate_user: :environment do
    make_user
  end

  task populate_stock_watchlist: :environment do
    make_stock_watchlist
  end
end

def make_user
  user = User.create!(name:     "Harish Porwal",
                       email:    "harish.porwal@gmail.com",
                       password: "password",
                       password_confirmation: "password")
end

def make_stock_watchlist
  10.times {|index| StockWatchlist.create!(symbol: "Stock#{index}", classification: "INVESTMENT", exchange: "NSE", notes: "Good Stock#{index}") }
  10.times {|index| StockWatchlist.create!(symbol: "Stock#{index+100}", classification: "TRADING", exchange: "NSE", notes: "Good Stock#{index+100}") }
end

