require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  namespace :api do # rubocop:disable Metrics/BlockLength
    namespace :v1 do # rubocop:disable Metrics/BlockLength
      resources :products

      namespace :products do
        scope path: ":product_id" do
          ## yahoo_auction ##
          resources :yahoo_auction_products, only: %i[index show]
          resources :yahoo_auction_crawl_settings, only: [:index]
          namespace :yahoo_auction_crawl_settings do
            resources :yahoo_auction_crawl_setting_exclude_keywords, only: %i[index create update destroy]
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
            resources :mercari_crawl_setting_required_keywords, only: %i[index create update destroy]
          end
          resources :mercari_daily_purchase_summaries, only: [:index]

          ## janpara ##
          resources :janpara_crawl_settings, only: [:index]
          namespace :janpara_crawl_settings do
            resources :janpara_crawl_setting_exclude_keywords, only: %i[index create update destroy]
            resources :janpara_crawl_setting_required_keywords, only: %i[index create update destroy]
          end

          ## related_product ##
          resources :related_products, only: %i[index]
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"
end
