class AddIndexToTags < ActiveRecord::Migration
  def change
    add_index :tags, [:taggable_type, :taggable_id, :name], unique: true
  end
end
