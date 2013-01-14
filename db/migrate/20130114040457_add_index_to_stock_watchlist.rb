class AddIndexToStockWatchlist < ActiveRecord::Migration
  def change
    add_index :stock_watchlists, :symbol, unique: true
    add_index :stock_watchlists, :classification, unique: true
  end
end
