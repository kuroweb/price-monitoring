# テストデータを作成
# command:
#   rails db:seed:product -e {environment}

ApplicationRecord.transaction do
  users = User.all

  product_params = users.map do |user|
    10.times.map do |i|
      {
        user_id: user.id,
        name: "test_product_#{i}",
        price: 1000
      }
    end
  end.flatten

  Product.insert_all(product_params)
end
