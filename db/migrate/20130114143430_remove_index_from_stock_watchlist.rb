class RemoveIndexFromStockWatchlist < ActiveRecord::Migration
  def change
    remove_index :stock_watchlists, :classification
    add_index :stock_watchlists, :classification
  end
end
