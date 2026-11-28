class CreateProductMonitoringExcludedSellers < ActiveRecord::Migration[8.1]
  def change
    create_table :product_monitoring_excluded_sellers do |t|
      t.string :platform, null: false
      # 収集結果の seller_id と同じく、大文字小文字まで区別して照合する
      t.string :seller_id, null: false, collation: "utf8mb4_bin"
      t.timestamps
    end
    add_index :product_monitoring_excluded_sellers, %i[platform seller_id], unique: true
  end
end
