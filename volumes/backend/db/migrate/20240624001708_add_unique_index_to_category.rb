class AddUniqueIndexToCategory < ActiveRecord::Migration[7.1]
  def change
    add_index :categories, %i[name], unique: true
  end
end
