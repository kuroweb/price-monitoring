require "sidekiq/web"
require "sidekiq/cron/web"

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  namespace :api do
    namespace :v1 do
      resources :products

      namespace :products do
        scope path: ":product_id" do
          ## yahoo_auction ##
          resources :yahoo_auction_products, only: %i[index show]
          resources :yahoo_auction_crawl_settings, only: [:index]
          namespace :yahoo_auction_crawl_settings do
            resources :yahoo_auction_crawl_setting_exclude_keywords, only: %i[index create update destroy]
            resources :yahoo_auction_crawl_setting_exclude_products, only: %i[index create update destroy]
            resources :yahoo_auction_crawl_setting_required_keywords, only: %i[index create update destroy]
          end
          resources :yahoo_auction_daily_purchase_summaries, only: [:index]

          ## yahoo_fleamarket ##
          resources :yahoo_fleamarket_daily_purchase_summaries, only: [:index]

          ## mercari ##
          resources :mercari_products, only: %i[index show]
          resources :mercari_crawl_settings, only: [:index]
          namespace :mercari_crawl_settings do
            resources :mercari_crawl_setting_exclude_keywords, only: %i[index create update destroy]
            resources :mercari_crawl_setting_exclude_products, only: %i[index create update destroy]
            resources :mercari_crawl_setting_required_keywords, only: %i[index create update destroy]
          end
          resources :mercari_daily_purchase_summaries, only: [:index]

          ## janpara ##
          resources :janpara_crawl_settings, only: [:index]
          namespace :janpara_crawl_settings do
            resources :janpara_crawl_setting_exclude_keywords, only: %i[index create update destroy]
            resources :janpara_crawl_setting_exclude_products, only: %i[index create update destroy]
            resources :janpara_crawl_setting_required_keywords, only: %i[index create update destroy]
          end

          ## iosys ##
          resources :iosys_crawl_settings, only: [:index]
          namespace :iosys_crawl_settings do
            resources :iosys_crawl_setting_exclude_keywords, only: %i[index create update destroy]
            resources :iosys_crawl_setting_exclude_products, only: %i[index create update destroy]
            resources :iosys_crawl_setting_required_keywords, only: %i[index create update destroy]
          end

          ## pc_koubou ##
          resources :pc_koubou_crawl_settings, only: [:index]
          namespace :pc_koubou_crawl_settings do
            resources :pc_koubou_crawl_setting_exclude_keywords, only: %i[index create update destroy]
            resources :pc_koubou_crawl_setting_exclude_products, only: %i[index create update destroy]
            resources :pc_koubou_crawl_setting_required_keywords, only: %i[index create update destroy]
          end

          ## used_sofmap ##
          resources :used_sofmap_crawl_settings, only: [:index]
          namespace :used_sofmap_crawl_settings do
            resources :used_sofmap_crawl_setting_exclude_keywords, only: %i[index create update destroy]
            resources :used_sofmap_crawl_setting_exclude_products, only: %i[index create update destroy]
            resources :used_sofmap_crawl_setting_required_keywords, only: %i[index create update destroy]
          end

          ## related_product ##
          resources :related_products, only: %i[index]
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Sidekiq
  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"

  # GraphQL
  post "/graphql", to: "graphql#execute"
  mount GraphiQL::Rails::Engine, at: "/graphiql", as: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
end
# rubocop:enable Metrics/BlockLength
