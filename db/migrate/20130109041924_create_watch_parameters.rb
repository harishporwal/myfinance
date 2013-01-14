class CreateWatchParameters < ActiveRecord::Migration
  def change
    create_table :watch_parameters do |t|
      t.string :symbol_id
      t.string :name
      t.decimal :watch_level

      t.timestamps
    end
  end
end
