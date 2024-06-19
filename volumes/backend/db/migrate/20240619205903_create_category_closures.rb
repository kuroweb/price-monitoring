class CreateCategoryClosures < ActiveRecord::Migration[7.1]
  def change
    create_table :category_closures do |t|
      t.references :parent, null: false, foreign_key: { to_table: :categories }
      t.references :child, null: false, foreign_key: { to_table: :categories }
      t.integer :depth, null: false

      t.timestamps
    end
  end
end
