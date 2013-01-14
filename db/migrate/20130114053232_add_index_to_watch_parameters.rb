class AddIndexToWatchParameters < ActiveRecord::Migration
  def change
    add_index :watch_parameters, [:symbol, :name], uniqueness: true
  end
end
