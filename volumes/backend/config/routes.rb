require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"

  namespace :api do # rubocop:disable Metrics/BlockLength
    namespace :v1 do
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
      resources :categories, only: %i[index]
      resources :product_prices, only: %i[index show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"
end
