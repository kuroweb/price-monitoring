require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :products

      namespace :products do
        scope path: ":product_id" do
          resources :yahoo_auction_products, only: %i[index show]
          resources :yahoo_auction_crawl_settings, only: [:index]
          namespace :yahoo_auction_crawl_settings do
            resources :yahoo_auction_crawl_setting_exclude_conditions, only: %i[index create update destroy]
          end
          resources :calculate_daily_yahoo_auction_products, only: [:index]
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"
end
