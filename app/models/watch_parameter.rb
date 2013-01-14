class WatchParameter < ActiveRecord::Base
  attr_accessible :name, :symbol, :watch_level

  # Defining constants
  EMA_50 = "50 Days EMA"
  EMA_100 = "100 Days EMA"
  EMA_200 = "200 Days EMA"
  BREAKOUT_LEVEL = "Breakout Level"
  RESISTANCE_LEVEL = "Resistance Level"
  PRICE = "Price"

  AUTO_PARAMETERS = [EMA_50, EMA_100, EMA_200]
  ALL_PARAMETERS = [EMA_50, EMA_100, EMA_200, BREAKOUT_LEVEL, RESISTANCE_LEVEL, PRICE]

  validates :name, presence: true, inclusion: ALL_PARAMETERS, uniqueness: {scope: :symbol}
  validates :watch_level, presence: true, 
    unless: Proc.new {|a| AUTO_PARAMETERS.include?(a.name)}
 
  belongs_to :stock_watchlist, foreign_key: "symbol_id"
end
