class CreateCategoryClosures < ActiveRecord::Migration[7.1]
  def change
    create_table :category_closures do |t|
      t.references :ancestor, null: false, foreign_key: { to_table: :categories }
      t.references :descendant, null: false, foreign_key: { to_table: :categories }
      t.integer :depth, null: false

      t.timestamps
    end

    add_index :category_closures, %i[ancestor_id descendant_id depth],
              unique: true, name: "index_category_closures_on_ancestor_and_descendant_and_depth"
  end
end
