class StockWatchlist < ActiveRecord::Base
  attr_accessible :classification, :notes, :exchange, :symbol, :watch_parameter_attributes

  validates :symbol, presence: true, length: {maximum: 15}, uniqueness: true
  validates :exchange, presence: true
  validates :classification, presence: true
  validates :notes, length: {maximum: 128}

  has_one :watch_parameter, dependent: :destroy, primary_key: "symbol", foreign_key: "symbol"
  accepts_nested_attributes_for :watch_parameter, allow_destroy:true
  has_many :tags, as: :taggable, dependent: :destroy

  VALID_EXCHANGE_REGEX = /NSE|BSE/
  validates :exchange, presence: true, format: {with: VALID_EXCHANGE_REGEX}

  VALID_CLASSIFICATION_REGEX = /INVESTMENT|TRADING/
  validates :classification, presence: true, format: {with: VALID_CLASSIFICATION_REGEX}
  
  before_save {|stock_watchlist| stock_watchlist.symbol = stock_watchlist.symbol.upcase}
end
