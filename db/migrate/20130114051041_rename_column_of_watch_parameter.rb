class RenameColumnOfWatchParameter < ActiveRecord::Migration
  change_table :watch_parameters do |t|
    t.rename :symbol_id, :symbol
  end
end
