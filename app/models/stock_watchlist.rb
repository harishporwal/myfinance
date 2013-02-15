class StockWatchlist < ActiveRecord::Base
  attr_accessible :classification, :notes, :exchange, :symbol, :watch_parameter_attributes, 
    :tags_attributes

  validates :symbol, presence: true, length: {maximum: 15}, uniqueness: true
  validates :exchange, presence: true
  validates :classification, presence: true
  validates :notes, length: {maximum: 128}

  has_one :watch_parameter, dependent: :destroy, primary_key: "symbol", foreign_key: "symbol"
  accepts_nested_attributes_for :watch_parameter, allow_destroy:true

  has_many :tags, as: :taggable, dependent: :destroy
  accepts_nested_attributes_for :tags, reject_if: lambda {|a| a[:name].blank?}, allow_destroy:true

  VALID_EXCHANGE_REGEX = /NSE|BSE/
  validates :exchange, presence: true, format: {with: VALID_EXCHANGE_REGEX}

  CLASSIFICATION_INVESTMENT = "INVESTMENT"
  CLASSIFICATION_TRADING = "TRADING"

  VALID_CLASSIFICATION_REGEX = /INVESTMENT|TRADING/
  validates :classification, presence: true, format: {with: VALID_CLASSIFICATION_REGEX}
  
  before_save {|stock_watchlist| stock_watchlist.symbol = stock_watchlist.symbol.upcase}

  # class level methods
  def self.search(classifications, watch_parameters, tag_names)
    stocks = scoped

    stocks = stocks.where("classification in (?)", classifications) unless classifications.to_a.empty? 
    stocks = stocks.joins(:tags).where("name in (?)",tag_names ).
      group("'stock_watchlists'.id") unless tag_names.to_a.empty?

    return stocks
  end
end
