require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :products
      resources :yahoo_auction_products

      namespace :products do
        scope path: ":product_id" do
          resources :yahoo_auction_crawl_settings, only: [:index]
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"
end
