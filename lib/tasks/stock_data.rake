namespace :stock_data do
  desc "update stock related data with daily prices, moving averages & historical information"
  task update_stock_prices: :environment do
    StockWatchlist.update_price
  end
end
