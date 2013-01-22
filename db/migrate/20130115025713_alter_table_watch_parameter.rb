class AlterTableWatchParameter < ActiveRecord::Migration
  def change
    remove_index :watch_parameters, [:symbol, :name]
    remove_column :watch_parameters, :name
    remove_column :watch_parameters, :watch_level

    add_column :watch_parameters, :ma_50, :decimal
    add_column :watch_parameters, :ma_100, :decimal
    add_column :watch_parameters, :ma_200, :decimal
    add_column :watch_parameters, :resistance, :decimal
    add_column :watch_parameters, :breakout, :decimal
    add_column :watch_parameters, :price, :decimal

    add_index :watch_parameters, :symbol, uniqueness: true
  end
end
