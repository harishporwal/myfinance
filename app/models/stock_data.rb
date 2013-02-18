class StockData < ActiveRecord::Base
  attr_accessible :ma_100, :ma_200, :ma_50, :price, :symbol

  belongs_to :stock_watchlist, foreign_key: "symbol"
end
