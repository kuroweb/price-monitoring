Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # TODO: config gem で origins の中身を切り替えられるようにする
    origins "localhost", "192.168.0.217"
    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
