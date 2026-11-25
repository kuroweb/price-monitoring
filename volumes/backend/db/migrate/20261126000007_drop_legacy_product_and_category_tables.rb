class DropLegacyProductAndCategoryTables < ActiveRecord::Migration[8.1]
  def up
    drop_table :product_category_maps
    drop_table :category_hierarchies
    drop_table :categories
    drop_table :products
  end

  def down
    create_table :categories, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.string :name
      t.integer :parent_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:name], name: "index_categories_on_name", unique: true
    end

    create_table :category_hierarchies, id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
      t.index [:ancestor_id, :descendant_id, :generations], name: "category_anc_desc_idx", unique: true
      t.index [:descendant_id], name: "category_desc_idx"
    end

    create_table :products, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.string :name
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    create_table :product_category_maps, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint :product_id, null: false
      t.bigint :category_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:category_id], name: "index_product_category_maps_on_category_id"
      t.index [:product_id, :category_id], name: "index_product_category_maps_on_product_id_and_category_id", unique: true
      t.index [:product_id], name: "index_product_category_maps_on_product_id"
    end

    add_foreign_key :product_category_maps, :categories
    add_foreign_key :product_category_maps, :products
  end
end
