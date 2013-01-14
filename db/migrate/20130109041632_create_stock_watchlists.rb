class CreateStockWatchlists < ActiveRecord::Migration
  def change
    create_table :stock_watchlists do |t|
      t.string :symbol
      t.string :exchange
      t.string :classification
      t.string :notes

      t.timestamps
    end
  end
end
