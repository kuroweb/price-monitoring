require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  namespace :api do # rubocop:disable Metrics/BlockLength
    namespace :v1 do # rubocop:disable Metrics/BlockLength
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
      resources :product_prices, only: %i[index show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # OmniAuth
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  delete "/logout", to: "sessions#destroy"

  # OIDC test page
  get "/auth/test", to: "home#index"

  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"
end
