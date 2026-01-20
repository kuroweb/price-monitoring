FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "Test User #{n}" }
    provider_name { User::ProviderName::AUTH_PROVIDER }
    sequence(:provider_uid) { |n| "user_#{n}" }
  end
end
