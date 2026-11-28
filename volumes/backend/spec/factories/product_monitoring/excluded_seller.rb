FactoryBot.define do
  factory :product_monitoring_excluded_seller, class: "ProductMonitoring::ExcludedSeller" do
    platform { "mercari" }
    sequence :seller_id do |n|
      "seller_#{n}"
    end
  end
end
