require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  namespace :api do # rubocop:disable Metrics/BlockLength
    namespace :v1 do # rubocop:disable Metrics/BlockLength
      resource :current_user, only: %i[show]
      resources :products, only: %i[index show create update destroy]
      namespace :products do
        scope path: ":product_id" do
          namespace :yahoo_auction_crawl_settings do
            resources :yahoo_auction_crawl_setting_exclude_products, only: %i[create destroy]
          end
          namespace :mercari_crawl_settings do
            resources :mercari_crawl_setting_exclude_products, only: %i[create destroy]
          end
          namespace :iosys_crawl_settings do
            resources :iosys_crawl_setting_exclude_products, only: %i[create destroy]
          end
          namespace :janpara_crawl_settings do
            resources :janpara_crawl_setting_exclude_products, only: %i[create destroy]
          end
          namespace :pc_koubou_crawl_settings do
            resources :pc_koubou_crawl_setting_exclude_products, only: %i[create destroy]
          end
          namespace :used_sofmap_crawl_settings do
            resources :used_sofmap_crawl_setting_exclude_products, only: %i[create destroy]
          end
        end
      end
      resources :categories, only: %i[index show create update destroy] do
        collection do
          get :structured
        end
        member do
          get :structured_subtree
        end
      end
      resources :backmarket_watch_targets, only: %i[index create update destroy]
      resources :backmarket_recents, only: %i[index]
      resources :product_prices, only: %i[index show]
      namespace :product_monitoring do
        resources :crawl_settings, only: %i[index show create update destroy] do
          post :sync, on: :member
        end
        resources :crawl_results, only: %i[index update destroy] do
          post :search, on: :collection
        end
        resources :monitors, only: %i[index create update destroy] do
          member do
            get :crawl_results
            get :summary
            post :aggregate_daily_market_prices
            get :transactions
          end
        end
        resources :daily_market_prices, only: %i[index]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # OmniAuth
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  get "/auth/csrf_token", to: "sessions#csrf_token"
  delete "/logout", to: "sessions#destroy"

  # OIDC test page
  get "/auth/test", to: "home#index"

  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"
end
