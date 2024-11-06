require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"

  namespace :api do
    namespace :v1 do
      resources :products, only: %i[index show create update destroy]
      resources :categories, only: %i[index]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # TODO: ProductionでBasic認証をかける
  mount Sidekiq::Web, at: "/sidekiq"
end
