# テストユーザーを作成
# command:
#   rails db:seed:user -e {environment}

ApplicationRecord.transaction do
  100.times do |i|
    User.create!(name: "test_user_#{i}")
  end
end
