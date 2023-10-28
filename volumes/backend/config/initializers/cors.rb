Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # TODO: 環境変数で取り扱う
    origins "localhost:8080"

    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
