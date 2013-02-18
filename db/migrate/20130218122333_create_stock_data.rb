class CreateStockData < ActiveRecord::Migration
  def change
    create_table :stock_data do |t|
      t.string :symbol
      t.decimal :ma_50
      t.decimal :ma_100
      t.decimal :ma_200
      t.decimal :price

      t.timestamps
    end
  end
end
