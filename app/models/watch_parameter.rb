class WatchParameter < ActiveRecord::Base
  attr_accessible :symbol, :ma_50, :ma_100, :ma_200, :resistance, :breakout, :price

  # Defining constants
  EMA_50 = "50 Days EMA"
  EMA_100 = "100 Days EMA"
  EMA_200 = "200 Days EMA"
  BREAKOUT_LEVEL = "Breakout"
  RESISTANCE_LEVEL = "Resistance"
  PRICE = "Price"

  AUTO_PARAMETERS = [EMA_50, EMA_100, EMA_200]
  ALL_PARAMETERS = [EMA_50, EMA_100, EMA_200, BREAKOUT_LEVEL, RESISTANCE_LEVEL, PRICE]

  belongs_to :stock_watchlist, foreign_key: "symbol"
end
